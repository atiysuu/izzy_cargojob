let playerData = {}
let levelSelected = false;
let selectedLevel = {};
let created = false;
let maxPack = 0

const convertValue = (value, oldMin, oldMax, newMin, newMax) => {
	const oldRange = oldMax - oldMin
	const newRange = newMax - newMin
	const newValue = ((value - oldMin) * newRange) / oldRange + newMin
	return newValue
}

const calcExp = () => {
	const exp = playerData.experience % 100

	$(".next-level-gift .current-xp p").text(exp)
	$(".next-level-gift .progress-outside").css("stroke-dashoffset", convertValue(exp, 0, 100, 609, 0))
	$(".next-level-gift .subtitle span").text(nextLevelGift.amount + "x " + nextLevelGift.label)
}

$(function () {
	$(window).on("message", async ({ originalEvent: { data: msg } }) => {
        switch(msg.action){
            case "openUi":
                
                $("main").fadeIn("fast")
                $("#level span").text(msg.userLevel)
                $("#levelWrap .subtitle #expLeft").text(100 - (msg.userExp % 100))
                $("#levelWrap .experience span").text(msg.userExp % 100)
                $(".profile .name .username").text(msg.fullname)
                $(".progress-outside").css("stroke-dashoffset", convertValue(msg.userExp % 100, 0, 100, 201, 0))
                $(".profile img").attr("src", msg.profilePhoto)
    
                let items = ""

                for(let i = 0; i < (msg.config.Levels).length; i++){
                    const level = msg.config.Levels[i]
                
                    if (msg.userLevel >= level.level) {
                        items += (`
                        <div class="item" data-car="${level.car}" data-exp="${level.experience}" data-pack="${level.package}" data-money="${level.money}"">
                            <div class="bg"><img src="assets/items/${level.bgsrc}"></div>
                            <div class="title-wrap">
                                <div class="title">${level.label}</div>
                                <div class="subtitle">${level.subtitle}</div>
                            </div>
                            <div class="selected">
                                <span>SELECTED</span>
                                <svg width="31" height="31" viewBox="0 0 31 31" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <g filter="url(#filter0_d_14_18)">
                                    <path d="M4 3L13.5822 26L16.9841 15.9841L27 12.5822L4 3Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" shape-rendering="crispEdges"/>
                                    </g>
                                    <defs>
                                    <filter id="filter0_d_14_18" x="0" y="0" width="31" height="31" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                                    <feFlood flood-opacity="0" result="BackgroundImageFix"/>
                                    <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
                                    <feOffset dy="1"/>
                                    <feGaussianBlur stdDeviation="1.5"/>
                                    <feComposite in2="hardAlpha" operator="out"/>
                                    <feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.6 0"/>
                                    <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_14_18"/>
                                    <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_14_18" result="shape"/>
                                    </filter>
                                    </defs>
                                </svg>
                            </div>
                            <div class="level">
                                <span>${level.level}</span>
                                <p>LEVEL</p>
                            </div>
                        </div>
                        `)
                    }else{
                        items += (`
                        <div class="item locked">
                            <div class="bg"><img src="assets/items/${level.bgsrc}"></div>
                            <div class="required-box">
                                <div class="icon">
                                    <svg width="12" height="14" viewBox="0 0 12 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <circle cx="1" cy="1" r="1" transform="matrix(1 0 0 -1 5 11)" fill="white"/>
                                    <path d="M1.33333 6.75H10.6667C10.9287 6.75 11.25 7.00267 11.25 7.45455V12.5455C11.25 12.9973 10.9287 13.25 10.6667 13.25H1.33333C1.07126 13.25 0.75 12.9973 0.75 12.5455V7.45455C0.75 7.00267 1.07126 6.75 1.33333 6.75Z" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                                    <mask id="path-3-inside-1_14_53" fill="white">
                                    <path d="M2 6V3.33333C2 2.44928 2.42143 1.60143 3.17157 0.976311C3.92172 0.351189 4.93913 0 6 0C7.06087 0 8.07828 0.351189 8.82843 0.976311C9.57857 1.60143 10 2.44928 10 3.33333V6"/>
                                    </mask>
                                    <path d="M0.5 6C0.5 6.82843 1.17157 7.5 2 7.5C2.82843 7.5 3.5 6.82843 3.5 6H0.5ZM2 3.33333H0.5H2ZM8.5 6C8.5 6.82843 9.17157 7.5 10 7.5C10.8284 7.5 11.5 6.82843 11.5 6H8.5ZM3.5 6V3.33333H0.5V6H3.5ZM3.5 3.33333C3.5 2.94454 3.68325 2.50247 4.13185 2.12864L2.2113 -0.176021C1.1596 0.70039 0.5 1.95402 0.5 3.33333H3.5ZM4.13185 2.12864C4.58843 1.74816 5.25748 1.5 6 1.5V-1.5C4.62079 -1.5 3.25501 -1.04578 2.2113 -0.176021L4.13185 2.12864ZM6 1.5C6.74252 1.5 7.41157 1.74816 7.86815 2.12864L9.7887 -0.176021C8.74499 -1.04578 7.37921 -1.5 6 -1.5V1.5ZM7.86815 2.12864C8.31675 2.50247 8.5 2.94454 8.5 3.33333H11.5C11.5 1.95402 10.8404 0.70039 9.7887 -0.176021L7.86815 2.12864ZM8.5 3.33333V6H11.5V3.33333H8.5Z" fill="white" mask="url(#path-3-inside-1_14_53)"/>
                                    </svg>
                                </div>
                                <div class="level-required">LEVEL ${level.level} REQUIRED</div>
                            </div>
                            <div class="title-wrap">
                                <div class="title">${level.label}</div>
                                <div class="subtitle">${level.subtitle}</div>
                            </div>
                            <div class="level">
                                <span>${level.level}</span>
                                <p>LEVEL</p>
                            </div>
                        </div>
                        `)
                    }
                } // FOR END

                if ($(".content").data("slick-initialized")) {
                    $(".content").slick("unslick")
                }

                $(".content").html(items)

                setTimeout(() => {
                    $('.content').slick({
                        infinite: false,
                        dots: false,
                        arrows: false,
                        slidesToShow: 3,
                        slidesToScroll: 3
                    })

                    $('.content').data('slick-initialized', true)
                })

                $(".item").on("click", function(){
                    $(".item").removeClass("active")
                    $(this).addClass("active")
                    levelSelected = true;
                    selectedLevel = $(this).data();
                    maxPack = $(this).data("pack")
                    
                    $("#start").removeClass("deactive");
                })
               

            break   

            case 'packageUpdate':
                if (msg.show){
                    $(".packInCar").css("display", "flex")
                    $(".packInCar span").text(msg.package + "/" + maxPack)
                }else{
                    $(".packInCar").css("display", "none")
                }
                
            break   
            }
    })

    $("#start").on("click", function(){
        if (levelSelected) {
            console.log("CLICKED")

            $.post(`https://${GetParentResourceName()}/START`, JSON.stringify(selectedLevel))
            $("main").fadeOut("fast")
        }
    })

    $.post(`https://${GetParentResourceName()}/LOADED`)
})

$(window).on("keydown", function ({ originalEvent: { key } }) {
    if (key == "Escape") {
        $.post(`https://${GetParentResourceName()}/CLOSE`)

        $("main").fadeOut("fast")
    }
})

$( "#start" ).hover(
    function() {
        $( "#top" ).addClass( "second" );
        $( "#top" ).removeClass( "first" );
    }, function() {
        $( "#top" ).removeClass( "second" );
        $( "#top" ).addClass( "first" );
    }
);
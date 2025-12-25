Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F52E776FC
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 00:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001626B0088; Wed, 24 Dec 2025 19:20:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1A76B0089; Wed, 24 Dec 2025 19:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3816B008A; Wed, 24 Dec 2025 19:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAC896B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 19:20:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A180B95F3
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 00:20:52 +0000 (UTC)
X-FDA: 84256087944.14.B1AC227
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FFFC40005
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 00:20:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nxfZLen6
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766622050; a=rsa-sha256;
	cv=none;
	b=Md2WNDJY5eNvBA6v62ZBtExUFbmhSR+YjflzYZCDkVqAn2OOPk1rgYYAxT36ooCo8w580I
	hnG+qcIhwm2VteJxyncywMBSTaN7LnNQcefy3icXaMH2P23esHc416M34hixNiz83UZO/c
	5jTWOCFyfi9WWQsqESsx7qxq4P5WUdo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nxfZLen6;
	dmarc=none;
	spf=none (imf01.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 202.12.124.145) smtp.mailfrom=fthain@linux-m68k.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766622050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqLER5/He2ATZFOr47hO2xqlE5rJXmXQubwaLbaCipw=;
	b=fblfa6Mn7vlm80tnkWsV0m86UlGSTUpZWznCjiw8+0Wvtuj84hWxj3A5hmr3iYV8jHWoFb
	8h1AwMEyowSMrO0qZq3K1Mvz2sKDpQ4TZEmQ6izhqJLJwgIG3Ey26M5S/KQ58Eg2XsXbU2
	wtQqgoTX1ky7Er6SLmA4+9HvZd7Eue8=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 443621D00119;
	Wed, 24 Dec 2025 19:20:49 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 24 Dec 2025 19:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1766622049; x=1766708449; bh=GqLER5/He2ATZFOr47hO2xqlE5rJXmXQubw
	aLbaCipw=; b=nxfZLen60ZujHlXgIEDOxUgmUTYfrfcywayX4kxqwOdHuj8/9ex
	xmyAFnsioLUSB5uBE2273n8o1+ZJtalbxSxPhWYX5uOsUCAVodW0C0pVoNrRgytT
	LVo2JO3GCHXzq+nSjnMSxr1e/RgpupXqcz+9GTFyy4FvWu3Qrz0vpk1Z5606p97a
	13X9vZyJBnA5ImCCLm/KYU5ktFETmT6vh8XPfG90xJPstrupm5nlFI5aC1guwwuT
	NJ/t0N45RQfvP3MIe6CZ7cRHTxg9Lp2ZOnjX7lE0nd2n8xAyqC2fONSpCWGvCk3t
	cKQBm5SMNFrYSvMmG8tr4h/fkzajeh0ldsQ==
X-ME-Sender: <xms:X4NMaXn6Uj9rebLZkmMIy8fJR8Ojn3lAFb3LDvYhLTC7LyKW4txxkw>
    <xme:X4NMaeicWlDY25IZqOCJw--YEjbp8WCdgGRi4SLwkJ6v8H0Ud86a6hUcZJ9shT-Jr
    YSPtKrI7XVcMarpg7rEjXNZAhSqo8z_AM8yiwy5EPbjVXgTGYKfSYA>
X-ME-Received: <xmr:X4NMaXeZML4F5GGOfiyi0Nx-fDgTw6RjaSJsdr-wvc0abA8SplyAtKedKOvoS6FofBn4pGpkIOUCEXWRtDujW5v3FW4_gr9osOk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeigedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfvhhgr
    ihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephffhtdehjeelgfeifffhhfeffffgjeefleeuudefuefhvedtieehheduhfegheeu
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghdptddurdhorhhgnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthhgrihhnsehlihhnuhig
    qdhmieekkhdrohhrghdpnhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpd
    hrtghpthhtohepphgvthgvrhiisehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohep
    lhhkphesihhnthgvlhdrtghomhdprhgtphhtthhopehovgdqkhgsuhhilhguqdgrlhhlse
    hlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:X4NMaWixMzSV9KkcJ5LNMJ2fU0iS_h95QjBhLEUlkaDh2KhV1fSYtQ>
    <xmx:X4NMaXzIu83omezfAWmNS8lrjVMIgdnhyIWDo70afWyVXbdxxW-D_A>
    <xmx:X4NMaaPjkzjq2yP9YFmDTaLwGy-gGlF73b0RH21kMziw1gFljCBRoQ>
    <xmx:X4NMaQXVyDcwssCwOy-H1SngGiuV8sTbhV-7TSyfKK5sxqkJKkrbdQ>
    <xmx:YYNMaYDGIyyfRLLw6y1A1BLRh1_2x30ChV0UWHEvYU9CU2jph8i6l92C>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Dec 2025 19:20:44 -0500 (EST)
Date: Thu, 25 Dec 2025 11:21:56 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    David Hildenbrand <david@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-nonmm-unstable 68/96] arm-linux-gnueabi-ld: error:
 zImage file size is incorrect
In-Reply-To: <202512241835.avmTEP6X-lkp@intel.com>
Message-ID: <b59bbd77-7e5a-b0ca-cf39-ae34bda80267@linux-m68k.org>
References: <202512241835.avmTEP6X-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FFFC40005
X-Rspamd-Server: rspam10
X-Stat-Signature: k4gdq4g46xux8o4ytiy9sdwhktp6145d
X-HE-Tag: 1766622050-653106
X-HE-Meta: U2FsdGVkX18PREd5xkDm4UcxPqI7+oqxFGkSTj7i/kY4cABgQxZGZEq/4VVwlPSG2AAoYEQd22CorhPp/zdt4DT13aiqMpP/MZB7G9vPB+1t/bpLTrN+uzTSBlcay821GWnh2lMBzXa5p8GJomMeSGGXrDjm7pSH6FPgIs7sLECeK2+zNT7wI0gCkhBHstWD+lMLNwG38u4LzsxPAWPxedQToWNpMpCSNYrBAYHV+dxMCSL1HFedvW351zkleJ31+6cBl5J1Tpk+LyET22CrAjj7CN5zYL+KpvvH4cJb02hubdLnML+asW/WAuOutODEUahf1eyA6U7J0l8Hdftw8ifofLxwUvWKmnFfh6pWRcWyw7Tb6g1mS91Ar73lcgzQsOpe37u78Qx3krrmFymRG7bcJIpc/7uja6zEDUpF9Rf2hiMrQVrh5NYUNhLYJd/RWJRLlQA7GShyTNYCVYpvjzBPTvGQKGs0HVcTTvPLx5w6L1N9kTGX3Pov2aDk/qxMRkjzqf5rGzwThq4VSoJFXf8741zFCbmH7YMrZ4uFuUmLkOff8WSt2QLu2yy1yMbXC/Ehwl/vBtTR/0k+RdWZnZlr2OyivI9mhOLBedLwOZDwm3DbV2XIJsXFOOwoXfK3bEbQKhLvwQ399qHwjsV1e8Q/OlY5FGg0nZRqkN/eMs7jx70/bIY0q7AOZQSait2CatcVlyYf90UjDIv0smI/flq8yEev1FPY91Fsq4V471X1ti/qlZKT23TGZAgOOZ/riZ0RnFrT+RqGTRpmVFRbBqBASQShG7DOG3ewfKm3dhrjeus9F+izCDq/Vhd3uwLRnQ9/9BZndaaFwMJ75PKKcANOn7S5j0VgueyhzAJU4PcstoninZ9+TiYeWRx1txlYB7OnwYu1CW07qckdIiC0ZB7EWkqXMLPOVTXc5D6lQJlLeoTFz86xTSqDucg3GPGtvDnrAVX5+7ToM6UTRy9
 9I+mRwPp
 bYToa5Wej8vUWZnJ0TQtxa7muYS7rAZI2/3XumsSU2n/Ks9W845/3ZCD2cOu7CRv3Oqedj3ZunCIfKx3DCZdsNRUPW/C9/p3VXkRKty9+4eRgy4QhNybeFk9ako8AyT86OJ3zLWju/fIL5rqMsS6ZFd35RyUriVGmv4NJuo6fm8vk/K6E5+L4Krhzeo/8eYajvgn4whbKJ1OYWbRgrepOYdK9EIkAIASsX7SP4fQgaQRfsaASDPRlbVu6yuTH9A0b2ZIHwS5aeqil9xS66+B2iNJ7GOjRfoF2yTGNNbMbmTrtLdpfsRgOJu5NU9KCxqjEdWA5aYRKXjtC/G2IZNNGf/B8psu7p9Ps4vbrcvune42DsLK3ZmBTDAB/6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


I've reproduced this failure and it is basically the same as the one seen 
in linux-next (which also involved CONFIG_EFI_STUB). The same changes 
which resolved that for x86 also resolved this new error:

https://lore.kernel.org/lkml/fcc9ca3e-8c04-43c0-606c-e798bc0cf9ce@linux-m68k.org/

Peter, this patch has your name on it, so I wonder if you have any 
comment. Would you prefer that I submit my version under my name instead 
of yours?

On Wed, 24 Dec 2025, kernel test robot wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   c40f0b9f72a08d208c7793090ae98faaf6a58719
> commit: 613bf373e660523dbb3f2567fceb6cbd8bc2a469 [68/96] atomic: add alignment check to instrumented atomic operations
> config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20251224/202512241835.avmTEP6X-lkp@intel.com/config)
> compiler: arm-linux-gnueabi-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251224/202512241835.avmTEP6X-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512241835.avmTEP6X-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
> >> arm-linux-gnueabi-ld: warning: orphan section `.data..once' from `drivers/firmware/efi/libstub/efi-stub.stub.o' being placed in section `.data..once'
> >> arm-linux-gnueabi-ld: error: zImage file size is incorrect
>    arm-linux-gnueabi-ld: drivers/firmware/efi/libstub/efi-stub.stub.o: in function `efi_stub_common':
> >> efi-stub.c:(.text.efi_stub_common+0x190): undefined reference to `warn_slowpath_fmt'
>    arm-linux-gnueabi-ld: arch/arm/boot/compressed/vmlinux: hidden symbol `warn_slowpath_fmt' isn't defined
>    arm-linux-gnueabi-ld: final link failed: bad value
> 
> 


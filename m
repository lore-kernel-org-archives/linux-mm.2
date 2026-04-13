Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCB3F34C5D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40166B0089; Mon, 13 Apr 2026 10:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1046B008A; Mon, 13 Apr 2026 10:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF426B0092; Mon, 13 Apr 2026 10:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA1446B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:43:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5091D56BE6
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:43:44 +0000 (UTC)
X-FDA: 84653801568.18.BCA69BA
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf19.hostedemail.com (Postfix) with ESMTP id 33D241A0004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:43:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=dThTVDJR;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="m KaUdPc";
	spf=pass (imf19.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776091422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPqrtdPK1fzOFd0Y9/MDHGVDApYeKMdzUWsDXpmbjTE=;
	b=sROMQQXgdmt8d/Ooe3A/uvqu4z9JVEJvslcsT89ac79SZpi3jGUDLI1OTnvZcrmS0rvq84
	w5VYqg9IBn+6G+f4TRNpoSgko29oMHa15uINd3BznwwUrKBlkPUb/FFp/3juDUGm8TViwE
	pxcqo38mmUz2WrwGyvIuNANL57/LO64=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=dThTVDJR;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="m KaUdPc";
	spf=pass (imf19.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776091422; a=rsa-sha256;
	cv=none;
	b=r6DwyRgdG/NS4MMFuS+1j1VGJMqs0WmkaLN57JDsylYgDppWm2BJi4Xyl9+Fjmbiq2rV3Z
	LyGdaM90LNktyH0U/z1i215LPSUsJn4L0k9cwKdsbYErvWIcvbsi5hJ8TBxB3FJGD++xQ4
	TOacTHGYzR0Hh1QEU2wVljmGfeRXZJo=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 580C613004A2;
	Mon, 13 Apr 2026 10:43:39 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 13 Apr 2026 10:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776091419;
	 x=1776098619; bh=CPqrtdPK1fzOFd0Y9/MDHGVDApYeKMdzUWsDXpmbjTE=; b=
	dThTVDJRrT61VUkRS+cdt7Y0Z5RRsLEBjlt5LbUT/Wkj3XuC1dVyKWZPgLth6rHI
	xbXnXmRzoJxvLeN5K5KTS4bLI9JTPMUMZHJQi9mq2+Mm0O8HtxzN6gdwi5dKMGzS
	o1z8qIdRudVgAnBmJYPys1vSE6iXXFJKhXBunGcqiXTQxSIZPwExbixipylrVyN9
	4kf4i5YSOQ5TyiEguuaQMFY1bjfsEzY4T5yjV+i49k3OFs/Vmf2QAO7EvG9pkkWh
	N8bT6ZPczJACaYt7v0DdNhd+Jcw1QSr4sfdnPLEq3qIenfqRfJd23mvz1BSPAcJy
	t7jf+cR2gTZwsPDeAUjd8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776091419; x=
	1776098619; bh=CPqrtdPK1fzOFd0Y9/MDHGVDApYeKMdzUWsDXpmbjTE=; b=m
	KaUdPcERkC+zzfJk9o14B4ADxV7hBFIrlwDzvbBZEzHm0PKs68AEHjccunfdwCIR
	xandwmc3ligmxNR3yrYrjDSRktpJmwg0D7TTzo3rAlmWy0gSHQXh1wFw4+NYGyVg
	zDlM8PgR4QH15XnDMMXbSfnGvjJh/j4eK/GlCalmtgkTknPnFph+dfWco8cTlWse
	WFEPDTU+OA38Yo/f8OVtqBAERl/dqEvgrfDqnngro8UiU3Du4URjogCH7u9C6eP/
	RYqA02k02M2VwiJpdNWH8HG6r4KmynyPDoJYdxTNeNoiAqYyt88JcV7BBjOLulpB
	DJUQhLG59C0zm2Z5pxrQg==
X-ME-Sender: <xms:GAHdaVYGCaKUPjfNsUorzxAck0ngCpZdPLdqJKjZEoxtd6QEkfV5yg>
    <xme:GAHdaXPKX2B9tilU84LfHthnj4XuzUMENgXV2EBsOOdx9XMImcZUEPIIzoIwFqvOh
    pcGkwnRvUUR4OUGZGU3iYkbbpFp25Dx9wq8LoeuFKlAv-Ydx1YT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefkeehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeegkedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepthdrshgrihhlvghrsegrlhhumhhnihdrvghthhiirdgthhdprhgtph
    htthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohep
    lhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegurghvvghmse
    gurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrdhi
    ugdrrghupdhrtghpthhtoheprhihrggsihhnihhnrdgrrdgrsehgmhgrihhlrdgtohhmpd
    hrtghpthhtohepuhhrvgiikhhisehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggvlhhl
    vghrsehgmhigrdguvgdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprg
    hnrgdrohhrghdrrghu
X-ME-Proxy: <xmx:GAHdadx3OaLmpgnQ-qR09fFSyphBizIiykQxx2Qr5HCiMADvCUw5LA>
    <xmx:GAHdabzajIhZOwZQz55Cqp-WmIPvMJl0Qeu3WJrRVrqO07JZC9K3bQ>
    <xmx:GAHdaSIxPmEuEecG1TMTc2ieeRuLkqK7w1Mgwy5a1Wj0e-ew_hD6MQ>
    <xmx:GAHdaVsDbvRI-p-Ezq237oUrDyOkdrmimmA3aH1JiaBrwsVneKVMbQ>
    <xmx:GwHdaelj14NT6xOHjmTv_huVndzlY2JM81Rr0b3-wFbundNAWyZ-7jZM>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E9F8A700065; Mon, 13 Apr 2026 10:43:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AaL_vZcj0OrJ
Date: Mon, 13 Apr 2026 16:43:14 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Thomas Gleixner" <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: "Michael Ellerman" <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 x86@kernel.org, "Baolu Lu" <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev, "Michael Grzeschik" <m.grzeschik@pengutronix.de>,
 Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Bernie Thompson" <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "Marco Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>,
 kasan-dev@googlegroups.com, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Thomas Sailer" <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Richard Henderson" <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, "Russell King" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Huacai Chen" <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, "Dinh Nguyen" <dinguyen@kernel.org>,
 "Jonas Bonn" <jonas@southpole.se>,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
 "Helge Deller" <deller@gmx.de>, linux-parisc@vger.kernel.org,
 "Paul Walmsley" <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Message-Id: <3d7c3433-2325-4bb2-a8f6-ddd11c82f71d@app.fastmail.com>
In-Reply-To: <20260410120319.723429844@kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120319.723429844@kernel.org>
Subject: Re: [patch 32/38] powerpc/spufs: Use mftb() directly
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33D241A0004
X-Stat-Signature: 86bphmsnbhgijjhdx7mhz9obfim3c7jz
X-Rspam-User: 
X-HE-Tag: 1776091422-324040
X-HE-Meta: U2FsdGVkX196pO/l/fPuYr5rqmXXjYIVG6vKtgsXQQxsF47W1fSiu85dHFv/YQoPp9nhqYZTr5HncBKVrxuZtuvh2b7GWL8vFUAGglM3yV6BkfC2eg+F6F23vRDR/P/xzawJ7euttZlUVJ2H+b6PcsBfR/Rp9p0o4YqjwS+inVgSLu/LLRmeU0iBaMVDV5zmY9rzqZsCO7cjjyCltJKJWQZuHA1mCHpFOoeShj+07238qLap+9LDi7AjZjLBxe8fNamxQnrANY9UOQHaHXbEhUGI620yLmRiU5xYL6O+Y70sV2o3AO/jIdeSAIhqhH2eQTPy1+ijlmiaL83qs3GpTSqpPxqMpJ3wq7VYQIe21wkIKRGFkHUDqOa90CNT4H7Vu3ewGfRQ2IquRJQrE8vA5Z7E5sVlkqjducYdO1daWqDP0TCvv96ocEg/4bOzBYCSE6ouvtYaBl1xRk2HoMBym+RaYCA1TNkOt1SlSYUZX8Sd1mQtlwfIgSX1i5isTmG3B6fbzaK0FGtjLUzws0mxcxfgsCJukoIW1KsxSYELgno/6FXJdawZZSKkjK2zVbaO8U04aElL/E2xWEWmRitcWF9xAjKMSEv2yRCIdOrkAHrWDictE1y8HAlljDKNIFqAHB9SdC7NADl0n+f4x0+drKZcbj+53ADRMVwAVBlveQ8dXocCSVyvdLfCg0eeZ3mywTZg+xg8nPWVP19pywEHV8GIuCtFDLS7seV/q+LvWgwcO9nJ5eanGMvbcDsmdZ1WFBBezcHwE5CHwDnj8t6Rh9eXBpmoCmT2aF8ztJPVrm1kIAJRVSWSzgC28WqSOA7d1k9ZvQCEuxQZ4GUXyQp51SNVu9+SOltaBwK377qJVe4akOB/Yv6/FjiLMMwWQvfTIGHWZDpwEG/aHB1vajErU0b6fV8z8THg/CyC9JBdy1x4kt+LEL/u0L0w46YwhqCSfnj2i9PRs5WX3I9vaAu
 usWnjXwu
 GybkZJ2Uq2PPs7HG65fft1tM687D4ZzPTRzFT9CFq2mU48X+Tqr1hTM5xYawuK3JOCbRyBXfvkyJORgrOJFFMTJ8uUV/bB9F4VUblKE8d2Pxdf67BS2HFevhkkNYHO4SMQYOWpwG27Fm17L1OqHhKCbNItDGHpI4Kag3bRlLu1By9be5oemLceUokvfEDlTI7Xu0tUMB+GKtSeCB8DAjUYNiPmJye8jIH8P/5jFakQo9BqVI9OoLI2DxPnNruy92MHKnNZiy56EZWFItLTc6HAVcq0kmyBxBbzMBux5YYKLF28ALCLRnEF12R2qta8iVXAnuZg98lr8pJksRotfT9waPCtI2uuVbUtPXBbLGGXy2mRUT1Xqln8UQrVjyO5c9PBQxC+Tgw53IEQv56AuSVzd5pWCbEaPbUmqyIXXfHXNVVIjl0W3s41IQucmz8RNc9RWcKNLL+NOYH7AkNooKusS7SUozPHTFFVrnfEVSoArmYeWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026, at 14:21, Thomas Gleixner wrote:
> There is no reason to indirect via get_cycles(), which is about to be
> removed.
>
> Use mftb() directly.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org

Acked-by: Arnd Bergmann <arnd@arndb.de>


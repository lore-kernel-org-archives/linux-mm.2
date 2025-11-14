Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FEBCE8D4D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123F38E000B; Fri, 14 Nov 2025 11:04:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC3A8E0008; Fri, 14 Nov 2025 11:04:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011FA8E000B; Fri, 14 Nov 2025 11:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E49228E0008
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:04:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABC3712E152
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:04:06 +0000 (UTC)
X-FDA: 84109684092.20.8614517
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf21.hostedemail.com (Postfix) with ESMTP id 73B4E1C001A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:04:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=iUuUK+Iq;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="E PmgzzJ";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf21.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763136244; a=rsa-sha256;
	cv=none;
	b=EZD3NaCY8mh4XY7RqvzCPBkSXWYwfSClVkRw4j/Hj1VHgJyH6GsV1L4ffeUOFm+l0U47OP
	5rI52KciOKwRLSLAKaveTCOf21SNpk9fOuHOvxJN/CEMtIoFHJhpWQxkn0F/XE8w33oNFP
	DEVsZ1hl4rB+RK0wD0cr3q4yLiF8xrI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=iUuUK+Iq;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="E PmgzzJ";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf21.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763136244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9f+1V/Gs5C5ClKhbfgT9um9exOzG9W9HnZ9J5MzYFY=;
	b=QM49MpGiP0XCSiKhJK04k3RNxOCJdrdKeMLXhnmzMc5+Zp8zBzhnJgLgX6lrehjznLY8FJ
	nG+mDaU3Bwcd25HqszqFY9YhReS3H6l4QyupRpSqeXVTxot+GZW7Lk1dy9xxyoFnRZguRF
	lqiv6ukGz9wODOVMozAuSGrvkvE0Phs=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8E2337A01AE;
	Fri, 14 Nov 2025 11:04:02 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 14 Nov 2025 11:04:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763136242;
	 x=1763222642; bh=M9f+1V/Gs5C5ClKhbfgT9um9exOzG9W9HnZ9J5MzYFY=; b=
	iUuUK+IqWqJXW16WpkpxRxPRAtrf6jqtV7WJneZ3XbpcXufA5YS7BhLcfFN3iKGY
	wVjrBvMkUBSaeOk9SVPhEh1CmfMmrDpdE2ogQ3sHiuidBHmYT82ymxj8Pm/g/Pea
	gJeWNvSxej3ucg9i89MEvdGDo5tFuWpSKmkzX5kBAKAalJPch9aE780StTAW5NFx
	Cmlbpi50BB2XPnhFURxMaI1Hg2WDObVPkE0uxWY/hKvxsjiJgtzpzTzyhgMibwPi
	JOP5y0ENCFAaaMokteMOyLWKENySsm/55Y1q8nVGAJkalDFY1CiipLPwPWHNRXzz
	Pf7LCQRkIHYGJB9bmpGdYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763136242; x=
	1763222642; bh=M9f+1V/Gs5C5ClKhbfgT9um9exOzG9W9HnZ9J5MzYFY=; b=E
	PmgzzJcrt+h0JC8NtWhi4UJRX9JSEuwVpcW9P6a4pCvY0SdhcCGIMF6xyQFbrC0G
	BOtT89f8YPJKbFNjWyvAXNY+1I/nW62tdg3sfFoEUhthpdYnbptmds2a0TaCpQFp
	96IC/ikXcG4TaiQ9TitSuG0vIJmE3/sD82Beh1LV023voCOJPXGvFUIlw0fEV5n/
	9sX7vQuB8+9cFSdG91otRe3+89cpyfjFrlWd+3azBdxXeGXipIhkFf5y623elKZL
	hWa3BFMOxipEnFpGZOXyFgIdtR1niCl/7Mi+dLC7+VqVKhoMN8Kov+EHxRGA2qDW
	BSNisJaMiHTUZPS/8y9GQ==
X-ME-Sender: <xms:8VIXaSQUTbGlNqoBm96asAebHCJLTwjAMNlPXbzGLJF4vrZcYX7zhw>
    <xme:8VIXaSm_qGICw4h1CKRHnPHP4ec_0wMH3rj0ydB-3a3qqTvG1luEEXgi3ZUCQIKN6
    6FvXdlGJZEkYEGxiV3PNVZSbxyKCOQFWYGELxzfm0ejHp0QQWCE_aY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvuddtvdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepvdelpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopegtrghtrghlih
    hnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohepjhgrmhgvshdrmhhorhhs
    vgesrghrmhdrtghomhdprhgtphhtthhopehmrghrkhdrrhhuthhlrghnugesrghrmhdrtg
    homhdprhgtphhtthhopegrlhgvgigrnhgurhgvrdgsvghllhhonhhisegsohhothhlihhn
    rdgtohhmpdhrtghpthhtohepjhhonhgrthhhrghnrdgtrghmvghrohhnsehhuhgrfigvih
    drtghomhdprhgtphhtthhopehlihhnuhigrghrmheshhhurgifvghirdgtohhmpdhrtghp
    thhtohepfigrnhhghihushhhrghnuddvsehhuhgrfigvihdrtghomhdprhgtphhtthhope
    hpvghtvghriiesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:8VIXaaCQi_bM4GIEQ_jBunmYtmzlrZxFP7n5lAYiWyfa-4msWaS0iQ>
    <xmx:8VIXaVSysmvIwseAM0TznwvZ94MPNSpd_nqP7aY25ncwx8evwSv4_w>
    <xmx:8VIXaRalsjiiTdT-vQi9kNTQC_wzVzBavsjweVEQDrXnjhGzfpXXpg>
    <xmx:8VIXaaW8w0IjPS9W8wroo2kONi-pnHfHvtBzWdvJYt9D-V7aoy1gzQ>
    <xmx:8lIXaaNw9x_t5t-hIL3XLxZP43HBdfy0h65TDU0tI1Usk61Z7PgFp97w>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 41EC1700065; Fri, 14 Nov 2025 11:04:01 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AWJreI-smgpg
Date: Fri, 14 Nov 2025 17:03:40 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jonathan Cameron" <Jonathan.Cameron@huawei.com>
Cc: "Conor Dooley" <conor@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>, linux-cxl@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-mm@kvack.org,
 "Dan Williams" <dan.j.williams@intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Drew Fustini" <fustini@kernel.org>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Krzysztof Kozlowski" <krzk@kernel.org>,
 "James Morse" <james.morse@arm.com>, "Will Deacon" <will@kernel.org>,
 "Davidlohr Bueso" <dave@stgolabs.net>, linuxarm@huawei.com,
 "Yushan Wang" <wangyushan12@huawei.com>,
 "Lorenzo Pieralisi" <lpieralisi@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, x86@kernel.org,
 "Andy Lutomirski" <luto@kernel.org>,
 "Dave Jiang" <dave.jiang@intel.com>
Message-Id: <93c1c6be-dae5-477e-8924-1b77f8567732@app.fastmail.com>
In-Reply-To: <20251114155746.00003719@huawei.com>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
 <20251108-spearmint-contend-aa3dd8a0220e@spud>
 <20251114124958.00006a85@huawei.com>
 <20251114-juror-stiffness-046b47b8d9f7@spud>
 <02244119-d6b8-4ef4-833f-b8fba7a73f43@app.fastmail.com>
 <20251114155746.00003719@huawei.com>
Subject: Re: [PATCH v5 0/6]  Cache coherency management subsystem
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 73B4E1C001A
X-Rspamd-Server: rspam07
X-Stat-Signature: 3m9q9ura74g5bxsseo1dz678eori7jcz
X-Rspam-User: 
X-HE-Tag: 1763136244-112009
X-HE-Meta: U2FsdGVkX180Z2uGxdSGUWIH8jShaYxtRp1rk9VTJaN6ZjJwXeYPdq1CQ58lXvKG8UGIYmJEAKu6Se23LNG+s9VZedw4wcQU6JuJO/i/DBMv3BpF04bo8F1Cj9RS55m5SB5wa6kOFqDbRe6DE+LI9Z8VF3ACRqTNXYqa5E6L1QTEA8ZLQSwAUIbRATEvDOQpOI9CyI+0FNaHgs5AG7ob8f4YZTEKZRU+wRcz6WRiu3ngIiZ8ytIeUX60L6mB0Q5jZlpklO2ILUIr5G/gKOwO8Jbco88vivwFx4YbSSZzVD58RxHR4gsEzSCjPcMYjBRj02pOXZsB2iJL/JZ989XflkXqfWL7tWWyLYXeCCfy3wPsnbHjtnUToBDFwrsnaJd68jcYfTh1qQBaphDywLitE4K55uj7aoWozDFp6QzlAzgqfIFlyBrhTmw6ZDmxj0bFOUr6CXiwYJRRPBhhhByuwSxWy0qV7e1CFvE6zVSNxzAsf6TdHC7kVel3kbxngXLOI5gqzC8LlPMsXVmbCwIUMmlySpHO40zxPUrIb+XJL/ieDtSsm3ydbafFWM9hxMYsaaCudQxEe+Iw7H6qp5yq6Q4b4qM4GouI6ocloMOtfgDxtS7HXp6E2LJV6LodkM1cQ9nQRFJLt/2Jzr8sWIuikb1FT6rrsgZNWTcrvdicKYC3kLzT4IrfJyJYMLL+9ovmKuilKATc352C8XhvI98QINjjVX0Hqb1ikmRn7yUqohn5KbwVwuvLd0KxbEIJDPuLVwPzGCeEsTu4MW2ZqtB+RHvftm4py1Qm0vmQzj6LGlkOIj8pqB6Ht7J5FXk3MV2dnhPpciNVnv3ttndy/HlSps0UIKuttsw8A3PBGudiT6fIG5NfWVr1fBeq8zaH9efBuWne/MBGvTscVc7i0f+k3TfUm4Q4H/q/SWyTosJkD2UIkOPbL17GhWEFKpXQ232FAiq9/KWKFOG+P3H1ueK
 qCoKq3FZ
 3VWwMOXY0ZGVRyRq5rpG1JsvgYjFidIM29PIt2t7yQBZ0mfDBRNOLbTYn0DjWYhG5QArgEOonGqzd/DoM1wzjX2fycAS2ED6n3J+5xzfVVFrsQUgsjhP6DmIH8J419KSGBYMEDDUFQuAKcdgETck7QWadHy/ckNbnwzoLNEsHx4QfAJD1uXNNRjYpMAppTObMNYOOXGP07bBUr5oledHmkv6cPM7tXh+ZqZJ5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025, at 16:57, Jonathan Cameron wrote:
> On Fri, 14 Nov 2025 15:07:33 +0100 "Arnd Bergmann" <arnd@arndb.de> wrote:
> Hi Arnd,
>
> Thanks for taking another look.
>
> Agreed splitting the menus reduces chance of confusion, so makes
> sense to me as well.
>
> Implementation wise I think we have to use menuconfig + bool if we want
> to have help and dependencies and then an if block under that.
> The syntax for Kconfig always leaves me finding an example to copy
> rather than finding it intuitive
>
> menuconfig CACHEMAINT_FOR_DMA
> 	bool "Cache management for noncoherent DMA"
> 	depends on RISCV
> 	help
> 	  These drivers implement support for noncoherent DMA master devices
> 	  on platforms that lack the standard CPU interfaces for this.
>
> if CACHEMAINT_FOR_DMA
> ... drivers here...
>
> endif #CACHEMAINT_FOR_DMA
>
> menuconfig CACHEMAINT_FOR_HOTPLUG
> 	bool "Cache management for hotplug like operations"
> 	depends on GENERIC_CPU_CACHE_MAINTENANCE
> 	help
> 	   These drivers implement support for cache management flows
> 	   as required for action such as memory hotplug on platforms
> 	   where this is done by platform specific interfaces.
>
> if CACHEMAINT_FOR_HOTPLUG
> ... drivers here
>
> endif #CACHEMAINT_FOR_HOTPLUG

Works for me.

> I'm not sure if the 'hotplug like' is close enough to all the cases
> for device drivers that provide the services needed to implement
> ARCH_HAS_CPU_CACHE_INVALIDATE_MEMEGION

The _FOR_HOTPLUG does feel a little more specific than it should be,
but I haven't come up with a better name for it yet. We'll
probably figure that out if we ever get a second driver here.

> Alternative might be to phrase around pushing beyond the point of
> coherence, but that seems to be an ARM specific term and would
> seem to incorporate fine grained sharing where this interface might
> work but isn't a good solution.

Agreed.

     Arnd


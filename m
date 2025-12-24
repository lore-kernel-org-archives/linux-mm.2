Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45984E75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 10:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2619B6B0005; Wed, 24 Dec 2025 05:40:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FFF6B0088; Wed, 24 Dec 2025 05:40:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1066B008A; Wed, 24 Dec 2025 05:40:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF6A66B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:40:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80F20BA8F6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:40:10 +0000 (UTC)
X-FDA: 84254019780.12.00E8B05
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf01.hostedemail.com (Postfix) with ESMTP id 566B74000C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:40:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=QeJJgFZh;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="L yacBhe";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.152 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766572808; a=rsa-sha256;
	cv=none;
	b=6Sj8CrXyTRcZ63W+pprzdInCcbl8zmtT9eiJYead6NbQBBrnKCe4k33Y9egjV28syFvdlt
	GRIJoUkGxmLlHtSngawCFvf2SpFQF+deNUNDSN3fKO9r7Q72uzJP0kfQVMdpuJASUDZn4x
	9UaAgf73x+7ylhSPmIIR0g30GR0FbZs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=QeJJgFZh;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="L yacBhe";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.152 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766572808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YX0Iu63byjNVx+YuTlIdUvEoIm6dN1b2nrc/xx3b1B4=;
	b=1tAxgF/EORUfg4ktLciPo/jFkOVW9x22MedQcNGMMytHBkHeSg/aTTxf+4WZA2Ku8h5zUt
	/T5PoMymf06HBxqhKbEy/g6CDlXNXUlWAEs3MO3mddTe6XWZbUywumoACv3QCp68FwGsZB
	Y+OaOs1x2atvK3icBFZLXMgyR7QA4vc=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 16CC97A0111;
	Wed, 24 Dec 2025 05:40:07 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Wed, 24 Dec 2025 05:40:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1766572806;
	 x=1766659206; bh=YX0Iu63byjNVx+YuTlIdUvEoIm6dN1b2nrc/xx3b1B4=; b=
	QeJJgFZhNvvg0LviLTt+Pq5z3YtzD9j7TUGykYJZMwfAX0UFf6qeDVyVIERLmj5p
	U7j/beLiLT4zFfDYY/bX9GbjBd2MkzDcWJM5CapFk/lYhsWlrLjvRsHhPArOucK+
	oM5O4fAp1pWVB50sMYoixNnD8B8mWIkErPF7ZfAchJJE8jEe9oHngj4CWWcTzurL
	UtR+OffS0D49o+dM8YZ9iDIoYxUkTRr3trBcSI+qd6I7+MRdqma44EA6FE/24IrX
	3IiZXXefHN2GRZ7XkOIhYgzFpUarW7nIQRqisVOBOoYkhoSoJDRQezI3JQUok0MD
	9Kh4HKMAAVKu6Pxb7e9xjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1766572806; x=
	1766659206; bh=YX0Iu63byjNVx+YuTlIdUvEoIm6dN1b2nrc/xx3b1B4=; b=L
	yacBhegZDB19uOBTAp/wSlLXl8g6HBw0+822kqJcnJiIdEm6W+a8lHW2tr66/HJF
	oxpnd+iRDmx4rCaC9u/H8yFh09nkx538PDqIQ86KzhtVmuBR/VllurMBodF5p6iq
	vlKcjySvJq+ECORrqOCTpFi5do4v4hP3x+B8FG4uiIGoV3VJ11w41ifHkyMxpVkX
	PItiB//BWRFNF6Cz0U0TPgDDV5jRYxZfWpRzmR2q90i/hBnqbh2gYMGeVoN2OZiM
	rFWjIge4/DHxL2S3RVSBxZ5tVMR2YUdnrN9PhqjhfadJZ/cHELc8gkooejWNHcFj
	WgatZY5d/aQpBvTMtWZTA==
X-ME-Sender: <xms:BcNLaQ8_rLHVTGubTg2P5ApbiePHfRLPueQURHHYIn4yM1yRNivjNw>
    <xme:BcNLaTgnYWbussBHtYvReijMeyGzF5RDOnjwZpljyD3i3rzrX4cvRjTLXaI3xtGjs
    xFX0CfAf-Krn4xifppTrCf97cnrPk_15Du-2hfEAbYIdTHkwk1xb4E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeivdeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheplhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtth
    hopegrnhgurhgvrghssehgrghishhlvghrrdgtohhmpdhrtghpthhtohepfihilhhlhies
    ihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheptghhlhgvrhhohieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    giekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtg
    hkrdhorhhgpdhrtghpthhtoheplhhinhhushdrfigrlhhlvghijheslhhinhgrrhhordho
    rhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
X-ME-Proxy: <xmx:BsNLabj5Yb1efwgwyTd1LSIMoi70vcnjBOt3SFtI-jp0Z29wK1e9LA>
    <xmx:BsNLadkCZiJD4h480VwjNs-pq8OK3G1CzOk3qfrOsmNA6HAkAqeqMQ>
    <xmx:BsNLaUq0Wy6zYySKPnxsEUBzUKAr8PGSq2bXJWTVEibcouFQDC-kzA>
    <xmx:BsNLaZJ9xGBNNGmTeO_GCEZiyEqQkgoYgAA_A9A2X_-wwwkI0r4IJQ>
    <xmx:BsNLaQOG8zh3VdLD6QUVIu4Ol1HBvAQigwbEglcR8MAqbb0gtF6h8g8h>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E4F4570006D; Wed, 24 Dec 2025 05:40:05 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AQxZfb8dcq5J
Date: Wed, 24 Dec 2025 11:39:26 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Message-Id: <f6c49549-57af-4640-a09e-896c47bb8657@app.fastmail.com>
In-Reply-To: <aUtPRFdbpSQ20eOx@nvidia.com>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-4-arnd@kernel.org>
 <20251219171412.GG254720@nvidia.com>
 <513078d3-976a-4e6d-b311-dcfcfea99238@app.fastmail.com>
 <aUtPRFdbpSQ20eOx@nvidia.com>
Subject: Re: [PATCH 3/4] ARM: remove support for highmem on VIVT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 566B74000C
X-Stat-Signature: ddjeturdxxk93mfuzoc5mse9nr4k1hez
X-Rspam-User: 
X-HE-Tag: 1766572808-910838
X-HE-Meta: U2FsdGVkX19nM/Quc1UBR57Yl4bdLKFCdZcqU4RmXbUhltZ+1Ds2Ui2Y03Gepqld6XBzTNapbw2QnuLdTfQtC0NGdYhRFYMHHrIAZM9FOxPtYI6gZEBpLZqpoECqENLRHtIJtBRI839DbFSdVvHI9EQ3m8Y2SKM7bgJnjL3FiLimsHXkLF2DWMrcZ5KI+fXUNavmhgzbradTFQ9C+7CzSE3e5Haxquxx+H3gAEpQa2nzWbURtyE3AN0UJXrUaTA8BubaoeoDQeLf6UxLW/5UxF6djL0+Htb5d+8+MOvR0dLyLlZC5t0Am/Ve9Opf9uWpXL9DjYJl4waN0kY+g+F4uoFf17QxLLo6tEv6Xqeaf23bjYLQXA5mceE8eLqLrX21V+hC7Fk8+g66abu4yXCZR+puQTaAJT+AYvIdqHMcS4Zoxny+/bjdulJSN+13LaHYzhYWDlaOnU/CuyvBQBwKx3OqW1EUO+REGNVkVAMD6JZrUrLKSVHw5PE+pDnbi9nT6h/WzC/ClMJmxdzh0QeVuMXa041Wg7oQxc+BCl4AhX5D6J1LCd5NeAkat243i5xOLXGm7RZB11zzm+0mS/y5HxQZNsqC3qQTOtfjtC79sdePn/eienkp6BjFtu8RHaByaUofBWT3bMFCfdg/dm/HqhWADkb3zDjDBkzvEOX2eJNkerofsO4M3Ke8tvo2Vw8LvEbD6hj5ClTF947YO9dMdb54VAmE3X9WLwWevd7Q+byu/uA47Opi/z6Q3mWQbOFFASjysILZsQ5fyGbrRi9zfbmZZtwW3gJZIJdHqHSI2lFpKGjzY+C5Xyg8Qpl0xykboH8h5DFtgPCt1Y/EXANWJKatr/sqg5NTq09dwHcDDTNJj5HnmZ0HPquVTVWF3ZdeVHkBEtcTqbFGaa+zxUkLpvj9zj5IhrjveDMiBzbNtwsSLCIZl8sDoJn6KHeYhMTgX0x7e+IydKdSDQKdely
 OVzGfi/+
 adtOUqbMPemkkp/r/LIwZ8OUaQKxUtGOmbBMzGFSbe5ZzlhnljtAx90xhA7MdhM8fw7v6F2oSlDFUPUHnSUO1w/kE9HdsBUKqth3RmgYdWG81dz58DfTMZnHHVZV4VABbS8TbwYey/MRbWC6aWADvsGRqL0QTmAD/fFQVwmUCoSMULxN5iliNsBxPu5QmaiOKYbaoz17ZAHL8yh4n2zRxmC0iqsiCKQspa1oYar1pR9CcFqkhWyc/JkCL5vW8iu1w9xMGFG1FCA/aV9I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025, at 03:26, Jason Gunthorpe wrote:
> On Fri, Dec 19, 2025 at 09:34:33PM +0100, Arnd Bergmann wrote:
>> On Fri, Dec 19, 2025, at 18:14, Jason Gunthorpe wrote:
>> >
>> > This looks great, but do you think there should be a boot time crash
>> > if a VIVT and HIGHMEM are enabled, just incase?
>> 
>> Do you mean in the common code or just for Arm?
>> 
>> We could use the Arm specific cache_is_vivt() macro, but it feels like
>> the 'dpends on !CPU_CACHE_VIVT' Kconfig check I added is both
>> safer and simpler.
>
> Okay, so maybe I'm asking if !CPU_CACHE_VIVT then the kernel fails to
> boot on vivt systems, maybe it already does?
>

Yes, in two separate ways:

- you can build a kernel for any combination of armv4/v4t/v5 CPUs
  (all VIVT), or any combination of armv6/v6k/v7/v7ve/v8 CPUs
  (all VIPT or PIPT), but we already enforce that you cannot mix
  the two in any way. The two sets are sufficiently different in
  terms of instruction set, MMU cache and FPU that trying to boot
  the wrong one probably doesn't even get to the point of printing
  any output.

- If something changed about the assumption above, any Arm kernel
  still needs to enable support for each individual CPU model that
  you may want to boot on. Enabling a SoC family will select the
  CPUs used in that SoC, and enabling a CPU type selects
  the cache features like CPU_CACHE_VIVT. Attempting to boot
  on a CPU model that is not enabled in the kernel build makes
  it fail in setup_arch() with:

                pr_err("CPU%u: configuration botched (ID %08x), CPU halted\n",
                       smp_processor_id(), midr);
                while (1)
                        ;

     Arnd


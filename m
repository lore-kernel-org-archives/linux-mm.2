Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B676CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66688002F; Mon, 27 Oct 2025 05:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D548000A; Mon, 27 Oct 2025 05:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53108002F; Mon, 27 Oct 2025 05:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B199F8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:44:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B93D48AFB
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:44:29 +0000 (UTC)
X-FDA: 84043409058.17.2DC6C75
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id 46F5B1C000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:44:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=eeY3yaie;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="U UUfqpt";
	spf=pass (imf18.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761558267; a=rsa-sha256;
	cv=none;
	b=fgPk5FnxthHk23Eet1ZnruEPbgE4I4cFTlQVtYZqSDzTTawac4eOtByW1jDUyo0aBzMsch
	OCxKWQ7MNSzmyvAqRBVx4JFA7J61kKxpzsbxpOq1o6vwF5+jYGycpAYlBx6yp7dOy2qaTE
	uy8tFkCH4u864s04pTXxgz/ItDQvmeY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=eeY3yaie;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="U UUfqpt";
	spf=pass (imf18.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761558267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJvSA8YZX3AlZqgSb2OmKRc9R00iJ2ZMmXzo0lfwC+4=;
	b=RPaowW5DzVlewVOqxEcuwM7fiXbENgMK/O8TaKZon3kHgZQoskZKuBc10fhKCtI7wFJOuz
	8R8Nkq+YTUSqZqRGJe0aWxqIlz+4ErayZC4i7k+T8vVo1N35wmovoN3IjW0HN0Crbx88CH
	Ge3G8RdKFX12zIOmJrdgWZd60b1fYcM=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id BF3481D0016B;
	Mon, 27 Oct 2025 05:44:25 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 27 Oct 2025 05:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761558265;
	 x=1761644665; bh=KJvSA8YZX3AlZqgSb2OmKRc9R00iJ2ZMmXzo0lfwC+4=; b=
	eeY3yaieiEBumzryH7jLM/ghYrAibipO8peOhqtb8bfFMaTxJtEWmMtKNYAgCGm2
	94kVW8q94feZ4UDf9dy2WZwRKsAN5exIaoEWP3Q84MA1Olo5olZRBom/k8mW2DWQ
	kAp+KDnTvMnHNg3WVgqZQzITlfTu3Nmb2kUzC13QO6lpPMTMxSANzuMt1DHXyIAg
	ixPpMcQwQdZMXhy+UNbO5b7wM1g9XuDpaOOTJzefns8EWvSODVNkXdvs6M4E3dqm
	76l/gjzvk1CpdEM81uxcGYGm3zC0kXnt/ceOrFWv+8kwyVDZ3U9A3S7EHyIJAtLb
	UP23hcaCoQGFWUhrbiB9Vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1761558265; x=
	1761644665; bh=KJvSA8YZX3AlZqgSb2OmKRc9R00iJ2ZMmXzo0lfwC+4=; b=U
	UUfqptBz0CLlDAFrqFj4ffpuCDyU31b+r5lFDAIu6dzge23rw/riviHX/GPRYG4q
	LqOXGm8I7NfwzfG8k+FMnAJewolkRJA4H8mu+oONFbBCpvjx2wUcreKYlLhU2jFi
	XLeBppEmE6BwP5ED60rxwDh1HhWh953IA/L5NLc7Kii7bJLx5SJe1sF6ri5m1YrT
	Rv7T4tTWCT8tOy1uG2V1gDqXQfq7UgDozCD9WpJKvrDdCXTQApu6jM5zuejt9ux1
	0iSm1x4PE20xOnsaGbyc3pb+Z8bAveaRLzQ262amqBKRxbJXw4vIocrprykEKSaa
	oNzg18SFj0+/+s+w83GCw==
X-ME-Sender: <xms:-D7_aEovHD20lFstMNr2Zox0hzxEgh6Vw7Ha3expxITBZZnDYyCyIg>
    <xme:-D7_aFdyQ_eTlvlZG8CW8XCqFpsS4SH0sdJ9k8-TNGSFTGlJBeEzTObEjAPRD3a94
    -h-LdJuN28jqItIaKp8c5SpXjGarmfV_Ue-wrZSzZyceV_nsb5Wt50>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduheejieegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:-D7_aPQWpquGASXx6NTT05lR8G-iE52Vn8_1U2O848xtp-a7S6oyXQ>
    <xmx:-D7_aA7eTn11ifHMPUzl2oRGx8mgDp1q3eptoFPLfK4p9oAKgAnOQg>
    <xmx:-D7_aCp-0wlpKruYkQ9qZyZnzM6GI5JPml2lrT9Lc-flz_TGog4EHA>
    <xmx:-D7_aDSzE4Gtck2H-PagpOPmRP6nF8DgsBVQKcs6YP1M9hM-qhoHqQ>
    <xmx:-T7_aMVJ9PF8LVIjl1uGufn8MO16JMBrWkhK842OCrMPk4Yb_-H7sE0X>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5E81B700054; Mon, 27 Oct 2025 05:44:24 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A1uCXwKauNWg
Date: Mon, 27 Oct 2025 10:44:03 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jonathan Cameron" <jonathan.cameron@huawei.com>,
 "Conor Dooley" <conor@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>, linux-cxl@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-mm@kvack.org,
 "Dan Williams" <dan.j.williams@intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "James Morse" <james.morse@arm.com>, "Will Deacon" <will@kernel.org>,
 "Davidlohr Bueso" <dave@stgolabs.net>, linuxarm@huawei.com,
 "Yushan Wang" <wangyushan12@huawei.com>,
 "Lorenzo Pieralisi" <lpieralisi@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, x86@kernel.org,
 "Andy Lutomirski" <luto@kernel.org>, "Dave Jiang" <dave.jiang@intel.com>,
 "Krzysztof Kozlowski" <krzk@kernel.org>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Drew Fustini" <fustini@kernel.org>
Message-Id: <fe57097b-1817-4428-9940-477c3f36cafb@app.fastmail.com>
In-Reply-To: <20251023174026.00005b42@huawei.com>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
 <20251022122241.d2aa0d7864f67112aa7691bf@linux-foundation.org>
 <20251022-harsh-juggling-2d4778b0649e@spud>
 <20251023174026.00005b42@huawei.com>
Subject: Re: [PATCH v4 0/6] Cache coherency management subsystem
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3ujic36y56tn5hkzw654js1kkqsbmdgi
X-Rspamd-Queue-Id: 46F5B1C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761558267-598050
X-HE-Meta: U2FsdGVkX1/ZC38N2zQ/2O1jsa/H4QP+cK1WRIMdKMQ7wgK2/LUGc8Vhj6o8QqUWDU+Ah3i48KxzdRMQzZpAwNcdYxKtk34aT7jkLmJTNDCe6euAbHnjk3zLBH4CX7LEE/bmw3Aem4JucqCSDrVlLCjl14+NADXZImLUjdYkaxpFrm8rDivcco0hilumAf8eBGJJ4vLBakJyIL/bXMiXw0j8twx8T5190Hpg/a+HXu1eXWy3u4LH7g0a918d9YRULtBPdnqTcEBZTpx/UQq/CKQLebCEVUHh9fC/ipXCjFAcCbmqIBhy4nkAJUaImwxQrI4mBcpuIk7WTEyxVPrFJb9zJaR8eOqzK3233/RQvpleHx6TVdZ7EQOObuwn52qdxUxp8U87GJlv/GwtmHlFG1ClVICHLGxp365LVUoLLHTUK7MGeMc36C/mJdZU4UELbs3dsyt4zLMQtAGISWvBTiRFM2lO+MmFpNAn217HYx+n5G6zZCzYe/ttAaFSxR9n/Wc740G19I/FuNH2NwCuqg6ei6C1MZ01pUEY2pz7M4MmwBvog6oMfwWCYVpl8E0iNCCXp97A6mWskWFypEt4vdv5ipgIY0+PkwJnEEealBQH1B92Qo5x/t/nuV8h5/vZKoZmSJOMNWCqEI5d18x56jowA92udTL6urecB1rV9ZDWzw8m6HFO9OOdsaoVev9ea4PefX3HSc7kCG8drPJ65eRzAfiS3mgqQI8n+0aY5nuMK2ar1XU1fG7THvHMQUJxqA+1gK1BBowGP+VQUoGhDdqfWIkvZnWOj2QuoYl3LwTk+T3cqqsjbOOYlvtbxWm2F+ld0+dGCCzlZLMgOOOZ0V1JlcbRfE9EyLYdD8Ui/oXaJ6YyZJ2Ce9tdYsVPuidEO16NRvV43uIRcnIgfN/YMN1h45TNhBSdtY+pWjhjGwDdraIEC3N6mIxd9vonllBXaxWjva8IN8qKaBl7b7d
 renYWjQb
 UjXBIsDW1Qk9WcM/XhFXBv3Ptv37L6wA8FpZlnPt61Qy96iwFGblghsr/sHK82/nMDx7zsN9RU4YjcGsq3O/glTlsw+dPTkGDpuo4kYyzdZFd/Qff5qJ+qgGznVl3rzRCJ616IFWrVKmYHRYt2Ial7IcvMswXzVZFDAGTLomE9tIEKQJsIZZyaKiEUf7J4++euUWaa8EWHSph44EpgZhVR5bPlg7MAa67Q51CIdVXJAGNQMuGXWNKKluqmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025, at 18:40, Jonathan Cameron wrote:
> On Wed, 22 Oct 2025 21:47:21 +0100 Conor Dooley <conor@kernel.org> wrote:

> On CXL discord, some reasonable doubts were expressed about justifying
> this to Linus via CXL. Which is fair given tiny overlap from a 'where
> the code is' point of view and also it seems I went too far in trying to
> avoid people interpreting this as affecting x86 systems (see earlier
> versions for how my badly scoped cover letter distracted from what this
> was doing) and focus in on what was specifically being enabled rather
> than the generic bit. Hence it mentions arm64 only right now and right
> at the top of the cover letter.
>
> Given it's not Arm architecture (hence just one Kconfig line in Arm
> specific code) I guess alternative is back to drivers/cache and Conor which
> I see goes via SoC (so +CC SoC tree maintainers).

I tried to understand the driver from the cover letter and the
implementation, but I think I still have some fundamental questions
about which parts of the system require this for coherency with
one another.

drivers/cache/* is about keeping coherency between DMA masters
that lack support for snooping the CPU caches on low-end SoCs.
Does the new code fit into the same category?
Or is this about flushing cacheable mappings on CXL devices
that are mapped as MMIO into the CPU physical address space,
which sounds like it would be out of scope for drivers/cache?

If it's the first of those two scenarios, we may want to
generalize the existing riscv_nonstd_cache_ops structure into
something that can be used across architectures.

     Arnd


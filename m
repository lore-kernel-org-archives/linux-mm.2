Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D16CDCE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049598E0005; Fri, 14 Nov 2025 09:08:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020A18E0002; Fri, 14 Nov 2025 09:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E788B8E0005; Fri, 14 Nov 2025 09:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D59218E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:08:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 945E01603B9
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:08:09 +0000 (UTC)
X-FDA: 84109391898.25.C6094C6
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6CCDD20018
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:08:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=Idm42L6l;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="q PDvuIs";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.149 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763129287; a=rsa-sha256;
	cv=none;
	b=eHupwAvMvHdXRjhb77qVhbAXgHJhfUZoBBBvGURO9pBl23XFqQHsZfhxE8KPDuVulAFXn7
	rCcpps1Yf2TIol1f9sYNCiboC0sbLnJl4TmaS1BF+k73H1lQPT9pZbw0Py16SLlUSiZsCJ
	JYsFMeynENJoJD6wskPv0f9vMa1V//M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=Idm42L6l;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="q PDvuIs";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.149 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763129287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iodSp6JgC3IsDPGboSdprZdWRAfsZYqpQHiFNrkabpA=;
	b=VOyqq1msW3+JeZM4/dl+9LJ7pREySmLHOJAyN2IREDbClMKBaiC8d9s+xscPuSsT2aV4ec
	+gqVU+LQMtbLN69fUkV6DNi9jtj5W1vvqjm4b0H4CMfoRH51Z8/ALqojq+/UJUVt/WFlqN
	V/wAxmr1m1xlqRbqtfDKUZUZ664gvK4=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id D53881D00175;
	Fri, 14 Nov 2025 09:08:05 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 14 Nov 2025 09:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763129285;
	 x=1763215685; bh=iodSp6JgC3IsDPGboSdprZdWRAfsZYqpQHiFNrkabpA=; b=
	Idm42L6lYT6qztn2DtWHjkIF/PsI6EYRzGLlKuwcLpOzsctduJomAZ2WGn055T/1
	/SzsJLRUZqTSGxz3AIWIDegt0vZfOwXt1up0lsqba/gPgtU4ZU6xCA6Y3pZ3WHcl
	XqK7r2dwYRwGjbMA+cDcV3O7WFRH3RWGKtGlc7mk/eFGY7Da6XL/hfXrQj0g0CmO
	yoFNab3hsOfRR5tlin/6GV70VNRVglQcYOUCZk4TxoW/GCU1C22qs5IaFxyh/jOW
	Gue2IWbgAKaOpf6XfVFDX3iVyGVJ3xuVsx76rrNPHEclXkQGxXQXA9M+My5HZ5UN
	sq9yaez5MbcGHlZJk6X9pQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763129285; x=
	1763215685; bh=iodSp6JgC3IsDPGboSdprZdWRAfsZYqpQHiFNrkabpA=; b=q
	PDvuIssQOkZeLinqlA3HJdt/sFObO8+fWmRCmCMskaEiYETXnOBSLeLXGSu5tO5f
	n1+7AJ178gg0AoilpC2tBiicRUJBV+SWpXNXRMAF7aM3pLfgsR7rXFBhzawxI1Gh
	5R18DesXDO2OBF7kv+aLNWe4S2+3qXQMpqE17p1wW+2rQeER9jfEtbQ82z38gR+J
	PVz8AF+y1wSyRGt5TuqaPjeAt7kcZVZ6HVv9z67piTuvmkzNLfpzKPHuQ6xPPmtA
	KTEPDjDabxEu6sjZJ0YYOWigrlhzi+cqs5mkhNkUFW0SMUTxv4q3jp8xPtbFCeHu
	iJPGVWTdO1qbt1BUJTpkA==
X-ME-Sender: <xms:wzcXab0s0WwU5rJo0rZsFhRB0fTB84Ee1xdHpc22sHoDCENdmbv5dw>
    <xme:wzcXaU6uDENGsRfBbu6y2FWLFMleZy1YrGh0TBcq4U6LNUG14pUKW5_O8LKXdPP9t
    Zl1cZPME73tbL72YxWsXIk7zyX9PKn_cH8iImNOdQdy1MZHyfaJ7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvuddttddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepfefhheetffduvdfgieeghfejtedvkeetkeejfeekkeelffejteevvdeghffhiefh
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgt
    phhtthhopedvledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivg
    hnkedruggvpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtgho
    mhdprhgtphhtthhopehjrghmvghsrdhmohhrshgvsegrrhhmrdgtohhmpdhrtghpthhtoh
    epmhgrrhhkrdhruhhtlhgrnhgusegrrhhmrdgtohhmpdhrtghpthhtoheprghlvgigrghn
    ughrvgdrsggvlhhlohhnihessghoohhtlhhinhdrtghomhdprhgtphhtthhopehjohhnrg
    hthhgrnhdrtggrmhgvrhhonheshhhurgifvghirdgtohhmpdhrtghpthhtoheplhhinhhu
    gigrrhhmsehhuhgrfigvihdrtghomhdprhgtphhtthhopeifrghnghihuhhshhgrnhduvd
    eshhhurgifvghirdgtohhmpdhrtghpthhtohepphgvthgvrhiisehinhhfrhgruggvrggu
    rdhorhhg
X-ME-Proxy: <xmx:wzcXaQfmOOPDp3_2pYo_j-dohnvtWxYq-lt_eldXmIJ0yLoHFXKALg>
    <xmx:wzcXaSUbYGz5OmI9ShPfgQRnHeC2mwd0fdpnABHsmt7W-E8Ic2pG7Q>
    <xmx:wzcXafUqQZRr4xMM7F5YFQWtlYo127YsUjVHq6tKXkowDY2PCK3tAw>
    <xmx:wzcXaaOnKFCxCQjGr4HLVXHo_NdGaKCCsNau9jefMD9SDcMY3r582A>
    <xmx:xTcXaaCY2J7kIm-Cn0_IaZAJeXcRkDXR1VaOugR2aGvhF6NU2l8fo2cA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9761C700054; Fri, 14 Nov 2025 09:08:03 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AWJreI-smgpg
Date: Fri, 14 Nov 2025 15:07:33 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Conor Dooley" <conor@kernel.org>,
 "Jonathan Cameron" <jonathan.cameron@huawei.com>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>, linux-cxl@vger.kernel.org,
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
Message-Id: <02244119-d6b8-4ef4-833f-b8fba7a73f43@app.fastmail.com>
In-Reply-To: <20251114-juror-stiffness-046b47b8d9f7@spud>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
 <20251108-spearmint-contend-aa3dd8a0220e@spud>
 <20251114124958.00006a85@huawei.com>
 <20251114-juror-stiffness-046b47b8d9f7@spud>
Subject: Re: [PATCH v5 0/6]  Cache coherency management subsystem
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6CCDD20018
X-Rspamd-Server: rspam07
X-Stat-Signature: hxk6466jwcq7k5tbph9ttusyynxfta5p
X-Rspam-User: 
X-HE-Tag: 1763129287-204106
X-HE-Meta: U2FsdGVkX1/UEG8MeLGeb20xTOaMuDbvVGnyDgzK8MqSJZvCAiVkN1rwlw9HcTHzybbq/m4L4JtGVh/bEYCqyNzemLgjZpJQYBvZ0VELhDSXBU6hp5oSyX/eFgJVY6rNqWWdQSkN/NrmmpVmbtIwXp+U7XmesRs8+A1gVoFWGOwbX81VWzB+n5/HmigJ0CBjFcUSee1os26wyN10+ujkk1u696po2N32SxKi21j6n4yF4dCggz013weWOBNeZR1G74fXI+lXAikw0g3WV4GdKxZnFFCHpHaTKCbYd40ITaHXhyETLIgrZy5s8LaKjbMCWBSw/q3nMCU8d9VT4eZy58j+BT0T2sDqtgdk7rMaUzA22sWeHmV0zjd3LlDo3gzMyMMas8wBWRoiHQug7Pwr9SCLrg7WzpjdmZX3sJtDqf9Kvcujrq3Vqm/7rdMlf0UysYcDQhzywyERE5kwfe+VTdPN5FkwdDM13pCJ24EuR8ZmnKwAZrsUXr2orZ53l3jJoUH6fG2SUf5FQRznwyN6KY2qNtcU1l0TTSXhNmCTb0uMrjx06BKk9cX/U/MHxlr2Cn/xz9u1jQ9xtfv/LlyDbSoNTwkUuz3qTMu2MNfAFCFcuVMVvetqVhdxpL2sJLsgsmwCvLbss5ciXvmJbq7u+WPxtVQxY7K698vxHie87J9TZQ9sBxq8tE3hpb9SgbvmgUr8gyw1XxsaMg0kzdNzS72115ZaCeou2nj5xjXQwilMgo1JFY+IdvBR+Nprr+XIeZ+HNj4yAib5ejM8/i1GLakVb4p6jt6Rz5oe09iMN7oIFwfJo9MwRnL9dqOhtyZiUk/T4mlIUrHQxA3l2E2prdZook4eyktoSpC5E7DJkZffFjLi9YMbRz1OqtNrrbr3QobQlVLqTK9R/fQLnicR7A57NfNMmkrxkPBp0mLCz9u00AqaP6ocwHj/lZmZAjFuijUfTJESJQiPr3xcYHc
 js8Yv48x
 LLrqhPpiG9wwALjZa87i6y/Wzk3zzfP//or2p1YmKgjv/d3bfuzHB4znjFBlvjCcanpdJmyM7mIG/lIqHZKWFXc9DPJk7hH6AN/EVksJggr7kH48us0nbuI6dbae4vBSIPeK0b5IomPbD3JBaqd2BKjlkz4JtxZ3vrkXWkTGirBpLOeFMmM5z8/q1RTKO0SpS/eSRp+FBGyR9r2Scf+ipDoUSK5G8JL/FcmS6zZ9kRxOtQOwiI+sM0GAEWUyixeH0VaRRKegINTSI2+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025, at 13:52, Conor Dooley wrote:
> On Fri, Nov 14, 2025 at 12:49:58PM +0000, Jonathan Cameron wrote:
>> On Sat, 8 Nov 2025 20:02:52 +0000 Conor Dooley <conor@kernel.org> wrote:
>> > 
>> > On Fri, Oct 31, 2025 at 11:17:03AM +0000, Jonathan Cameron wrote:
>> > > Support system level interfaces for cache maintenance as found on some
>> > > ARM64 systems. It is expected that systems using other CPU architectures
>> > > (such as RiscV) that support CXL memory and allow for native OS flows
>> > > will also use this. This is needed for correct functionality during
>> > > various forms of memory hotplug (e.g. CXL). Typical hardware has MMIO
>> > > interface found via ACPI DSDT. A system will often contain multiple
>> > > hardware instances.
>> > > 
>> > > Includes parameter changes to cpu_cache_invalidate_memregion() but no
>> > > functional changes for architectures that already support this call.
>> > > 
>> > > How to merge?
>> > > - Current suggestion would be via Conor's drivers/cache tree which routes
>> > >   through the SoC tree.  
>> > 
>> > I was gonna put this in linux-next, but I'm not really sure that Arnd
>> > was satisfied with the discussion on the previous version about
>> > suitability of the directory: https://lore.kernel.org/all/20251028114348.000006ed@huawei.com/
>> > 
>> > Arnd, did that response satisfy you, or nah?
>> 
>> Seems Arnd is busy.  Conor, if you are happy doing so, maybe push it to a tree
>> linux-next picks up, but hold off on the pull request until Arnd has had a chance
>> to reply?
>
> Yeah, I did step one of that last night and will put it in linux-next
> from Monday. Ultimately the PR goes to Arnd, so he can judge it there
> anyway.

Sorry about the delay on my side. I've read up on it again and understand
better where we are with this now.

I think the implementation is fine, and placing it in drivers/cache/
is also ok, given that we don't have a better place for it.

However, this does feel sufficiently different from the three existing
drivers in drivers/cache that I think we should have separate
submenus in Kconfig and describe them differently:

- the arch/riscv drivers are specifically for managing coherency
  between the CPU and any device driver using the linux/dma-mapping.h
  interfaces to manage coherency using CPU specific interfaces.

- the new driver does not interface with linux/dma-mapping.h
  or a CPU specific register set, and as I understand that would
  make no sense here. The only similarities are that it manages
  coherency between multiple entities that access the same memory
  and have private caches for that.

If we can come up with better names for the two things, I'd
like them to have distinct submenus. Something like the draft
below for the existing drivers would work, in addition to
a new menu that only contains the one driver for now. I've
moved the 'depends on RISCV' into the 'menu' here, since that
is the only thing using it today (32-bit arm has the same thing
in arch/arm/mm/cache-*.S with a different interface, most others
only have an architected interface).

    Arnd

---
diff --git a/drivers/cache/Kconfig b/drivers/cache/Kconfig
index db51386c663a..8a49086eb8af 100644
--- a/drivers/cache/Kconfig
+++ b/drivers/cache/Kconfig
@@ -1,9 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0
-menu "Cache Drivers"
+menu "Cache management for noncoherent DMA"
+       depends on RISCV
+       help
+         These drivers implement support for noncoherent DMA master devices
+         on platforms that lack the standard CPU interfaces for this.
 
 config AX45MP_L2_CACHE
        bool "Andes Technology AX45MP L2 Cache controller"
-       depends on RISCV
        select RISCV_NONSTANDARD_CACHE_OPS
        help
          Support for the L2 cache controller on Andes Technology AX45MP platforms.
@@ -16,7 +19,6 @@ config SIFIVE_CCACHE
 
 config STARFIVE_STARLINK_CACHE
        bool "StarFive StarLink Cache controller"
-       depends on RISCV
        depends on ARCH_STARFIVE
        depends on 64BIT
        select RISCV_DMA_NONCOHERENT


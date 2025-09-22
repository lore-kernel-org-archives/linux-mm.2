Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F7ACAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 12:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19DC98E000A; Mon, 22 Sep 2025 08:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175708E0001; Mon, 22 Sep 2025 08:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B668E000A; Mon, 22 Sep 2025 08:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED52F8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:54:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94AC711A9A3
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:54:58 +0000 (UTC)
X-FDA: 83916881076.05.BDA42F4
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F62A20009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:54:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=Byx+4gU0;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="H 0IPFaD";
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758545696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t36qDepR8M2DCIZbR0pCgjLUAnazHFDPHVI50t3UlR0=;
	b=4EEAM+o58AdvzTDq0LN495os0BZ4SBsiDLk2guoTiLde2SC06mAaoOxATuFNHSNrLOd1B2
	u00nFupQIJf2AJeLA56rc32xMf0LKXPrrhcOhag3Rmsnydy4VGVjgWJmwDUeLxIxGTtqR2
	tmt4HALe02Q4iij9xpNCEh9ei22kpvw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=Byx+4gU0;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="H 0IPFaD";
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758545696; a=rsa-sha256;
	cv=none;
	b=rWCNHo3wCrklZ33FacKiNrVY1wO06eQHW1NuPejPC9r/FX6h+gR8bxKJSj8lOh98fFFLqv
	8pafVVFJRzzq0NfGbi9NHVMmraOuTOa5rav6qKckNpGZCPLxIH8doq/zpkOyASQIlaB0UG
	sM92tCaju/dDbDSiL5GDXxszChJLiNo=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id B4DF41380189;
	Mon, 22 Sep 2025 08:54:55 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 22 Sep 2025 08:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1758545695;
	 x=1758552895; bh=t36qDepR8M2DCIZbR0pCgjLUAnazHFDPHVI50t3UlR0=; b=
	Byx+4gU0eym5kWVlcDXwUEDI2l9mrErWD5C903u60dnEyaLum9cP1ZuS5KIp+xgV
	ZPhoSR2eD/GkgL674LQAABX9NWS2vtfKwaGvmIMh7dn5zMpqei4YDaKF6Sg1lPqM
	/QYUc0VveyM9znhOFNe0I0Peulxx/MpOzCUQKlSEgPHlsEhuUOD2y6mRk3lDEj02
	VonOHqKY3rqz628mNujxcDBLfdikoS4DkYJFuSM7iVjrVgPyCF1G4xzwHAbC28ak
	vvUqx1uImSJZ0/2d1CaWpImUIRc3GyUcfQGlUAGQNOWn2gPJHn5TvlH9sflGdsBd
	Q080PKF/+Wx2IOzfgFAq3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758545695; x=
	1758552895; bh=t36qDepR8M2DCIZbR0pCgjLUAnazHFDPHVI50t3UlR0=; b=H
	0IPFaD0Bba71iIapHDtSV1s5vKNTmSWg76ZWGgJDWMeMe2uVZv93YLpC6F+3M7WS
	7WR8RZqD6IX9RfHdr78aWjw7DCVCJJDQQAyQV579FYFi5N053564JuPCiuOaoK7E
	jCNWhlk6xzOLMU//k4yHk7ANSniWbtRW6bN+QjnKeFTwCD651tkhjiL2UZK6FT4a
	N+e/Yd+67opM9BzKp4zMCF1uEB2IdBcU4BDnt7dF2IYQtXXKkU2s8zbUPCs7FRgT
	esVXVJWVpb7ki7wYLCkfM9rz4wm7rTHNen16vLJGDFL/xHUUzNYiuVSL2AtqWUoo
	LzUsfYTN6qltg5PEeMddw==
X-ME-Sender: <xms:HkfRaIhwl2BmHC6VY4isyWFya-k04jD6ylI2zmgaqD6hV2yhCcrcAw>
    <xme:HkfRaBA26ySSRAPgSQvT1XYEaaJYts20E0XhpKyqZSIXJCR2OE9jzNtNSAFz8UVQR
    HSJ4LKxnkBuSkZFk1c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehjeeltdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopedviedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheplhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtth
    hopehrmhhkodhkvghrnhgvlhesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthho
    pehnrghordhhohhrihhguhgthhhisehgmhgrihhlrdgtohhmpdhrtghpthhtoheprhhosh
    htvgguthesghhoohgumhhishdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtoheplhhirghohhhurgegsehhuhgrfigvihdrtghomhdprh
    gtphhtthhopehlihhlihhnjhhivgeksehhuhgrfigvihdrtghomhdprhgtphhtthhopehl
    ihhnmhhirghohhgvsehhuhgrfigvihdrtghomhdprhgtphhtthhopeigihgvhihurghnsg
    hinhdusehhuhgrfigvihdrtghomh
X-ME-Proxy: <xmx:HkfRaCigs8Fbeh9nddaAG96q7IyZQvw3aeIYEeOmKg-CRsa1QbL_6Q>
    <xmx:HkfRaCv2xmbmRFslevLLrkDTmmKL1-lKBkFUSXaessp7GPqBHtniAg>
    <xmx:HkfRaE64XxBzr53OG3J0xus2BYuY6_ti3fdW9pt59OdOalF9khdfew>
    <xmx:HkfRaNtIkKJV0zAg5uDGA1LBG8hBH_va0vo4RVrbVfhnUgCeeDvgOQ>
    <xmx:H0fRaKVMmb-oKkRydhvIG9b_njKCBCZyzUrTrxLNyaHqA221GeTlQIFn>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3037D700065; Mon, 22 Sep 2025 08:54:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AFFCV0QGVXfF
Date: Mon, 22 Sep 2025 14:51:59 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Xie Yuanbin" <xieyuanbin1@huawei.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Ard Biesheuvel" <ardb@kernel.org>, "Dave Vasilevsky" <dave@vasilevsky.ca>,
 "David Hildenbrand" <david@redhat.com>, "Eric Biggers" <ebiggers@kernel.org>,
 "Kees Cook" <kees@kernel.org>, liaohua4@huawei.com, lilinjie8@huawei.com,
 linmiaohe@huawei.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 "Russell King" <linux@armlinux.org.uk>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Michal Hocko" <mhocko@suse.com>, nao.horiguchi@gmail.com,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Russell King" <rmk+kernel@armlinux.org.uk>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@suse.cz>,
 "Will Deacon" <will@kernel.org>
Message-Id: <9c0cd24c-559b-4550-9fc8-5dc4bcc20bf7@app.fastmail.com>
In-Reply-To: <20250922082843.26722-1-xieyuanbin1@huawei.com>
References: <727caa4f-5be5-4b59-a10e-8dc9bbc384bf@app.fastmail.com>
 <20250922082843.26722-1-xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH 1/2] ARM: mm: support memory-failure
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6F62A20009
X-Rspamd-Server: rspam05
X-Stat-Signature: 51edcqu8x8a4zc37jik76m9y1qxpe8de
X-Rspam-User: 
X-HE-Tag: 1758545696-46317
X-HE-Meta: U2FsdGVkX1+LOpiU54SSBY9TXMEjdjTaQqEQJklDmzhi1OMRmzzH1T+b54DFTlkvyQOKvyGi5PbThTFRv5WesurrcQAqlQhJy4ZwhLB2LjljtOgcIk9eAIF7Ye6zR61Yl5XCBRTxVKA9WMEPtpmGoQQuGVOZRiI1waB867pKv4NRRZhX5XzoTHwCj3FzF8bJsgmcWT61en5sgtjgqlN79wm5omHLuP2MezqPgSdQoSM1q2p30VNg/NaSUcwolQJAR6UMGzPDvs4umoL0yRjBnYVxDDVk+L5LYq4ytzVputKIKFrGLZCpelxdVZ/Ynarz6t4aa95yUuf6D7J/p+1Ql+iaUkhJzol2ooym0G21X0y+N5sH0FlUUukJszzKQtVSad0syFLX8v91IkhpjKyDXViSBOSw95JDBC5Lvga5o0hrNxy41VLZrCc7e9KopOvycnbuge3XE+1sfm8nQGOLjFeb7oLWk375hLaD5SKaoY1vJggKkz9310ojZa/i7EIcAYWRrFUhzDYd822GX4rWl55ykFTY3MmYKJLFpYJ23B5quCGnH9CDAZj0KcHdqrsd9wAoIUuW6yHRD25MqnK0HDhzZFl39HqqIKrAF8Dtmm9K+6JqhdpClt1OqeyOXUMnWjBUXcj6U8esvS9YJY+qtL0U2blCdX5I7VTIWPWyP8+aFKQeijevaqc/fnYxQOUIIp+Pu2Md8/HOEVpv9YSH1DraPJOMQZ92klUg6pFYfa+ibNSQBYyjgbisTXlV+1dnETa0UzrCypzkkb3moZZTEYrtp8RMV3v2h54HJHAaLVWnJN/mPdSGfFWVHrICpekj8kpC6wYqnumr+tfovzv2gY5ajO7eenOy3jBohqX8kc3nu2PwSD05a49xWjnL1k3VFroWqL7ebexhUkOqnxpXSwU2j2GkJSuT0DcOZd2qzJDuzhMEl/aVDzbJI3TPlqC7dnq6Npf42cck0DWWLny
 U3tUyMBv
 96OZ/zlZ7jEj7zkmWutD6aMA4Yk7Wn2KpPlndPRjn2w6svlzzyyTPTOUCR2w7O8XxBsf9Z32WlIzRktIDJdmPmT/5odOaIBH//P1D2h4GIK1xZ9Ccr8rs672+OSbdZFuQiBWNlqTDxjdFFNrt8JGqMflC14orliQXRD1ZVt2Bm1y1FApDr/eCCYpkF8G7BS0NuLjcCpI22vUxtYB+lj6CAehBmqdlZMg0/Ml69HrYoPxV76/M3a4RO6NOCd7wQLnsXD3a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025, at 10:28, Xie Yuanbin wrote:
>> It would be helpful to be more specific about what you
>> want to do with this.
>> 
>> Are you working on a driver that would actually make use of
>> the exported interface?
>
> Thanks for your reply.
>
> Yes, In fact, we have developed a hardware component to detect DDR bit
> transitions (software does not sense the detection behavior). Once a bit
> transition is detected, an interrupt is reported to the CPU.
>
> On the software side, we have developed a driver module ko to register
> the interrupt callback to perform soft page offline to the corresponding
> physical pages.
>
> In fact, we will export `soft_offline_page` for ko to use (we can ensure
> that it is not called in the interrupt context), but I have looked at the
> code and found that `memory_failure_queue` and `memory_failure` can also
> be used, which are already exported.

Ok

>> I see only a very small number of
>> drivers that call memory_failure(), and none of them are
>> usable on Arm.
>
> I think that not all drivers are in the open source kernel code.
> As far as I know, there should be similar third-party drivers in other
> architectures that use memory-failure functions, like x86 or arm64.
> I am not a specialist in drivers, so if I have made any mistakes,
> please correct me.

I'm not familiar with the memory-failure support, but this sounds
like something that is usually done with a drivers/edac/ driver.
There are many SoC specific drivers, including for 32-bit Arm
SoCs.

Have you considered adding an EDAC driver first? I don't know
how the other platforms that have EDAC drivers handle failures,
but I would assume that either that subsystem already contains
functionality for taking pages offline, or this is something
that should be done in a way that works for all of them without
requiring an extra driver.

      Arnd


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F9D5105D996
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D9A6B008A; Tue,  7 Apr 2026 22:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E246B008C; Tue,  7 Apr 2026 22:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824996B0092; Tue,  7 Apr 2026 22:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 723696B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:36:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14F96140926
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:36:00 +0000 (UTC)
X-FDA: 84633823680.19.6B6D99D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4528F1C0004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:35:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MjzcvJNT;
	spf=pass (imf21.hostedemail.com: domain of djbw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djbw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775615758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KkMn0KxS9q4QmvPIW+laFe0pPrRm5OjtvnER+1DCMbw=;
	b=AneHBXmUP/XjwDgDUsiO1xjDbZ4V25xxRmBgZIABAY7xk0P6UNmB7NIDzcZuPTRFofG2nv
	2/Nq6lZtZjVlE9onQyPqPw4XD7QdZ3snGSJZp72zj/FeSy1HyCKfdJkW0VEb3nhMAaAZNO
	Efg59cdF6INLOGcpTuBAsM/e8qD8ax0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775615758; a=rsa-sha256;
	cv=none;
	b=hqXyCzIvOpM8R3jwFHA77/izBgPF5uqMnPS/S14pqtlNrvq4At+/DHmFIrf7HLUePvxECn
	KvJSMvAOiKpMXaxKPHr3HOUnSkiAmEbpyTuuZS2+SXaoUpZ9/1X+Fxj/HmjXi1izZBfqdQ
	H9Oh9HYBZJQvpCy838z5FG3ZRJnDwHw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MjzcvJNT;
	spf=pass (imf21.hostedemail.com: domain of djbw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djbw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4405540349
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3AEC19421
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775615757;
	bh=x+v/WG2GftoMBlJMi6E/znxkqCjwUXYr5lqBIrrZgxA=;
	h=Date:From:To:Cc:Subject:From;
	b=MjzcvJNTGtX2eAUAX4l1OvT7c6/mxer5VUVKy4XqYDi1n6OhdY6iUMOcMRJUvb8UC
	 U0IFo0atnAaiNcnHd2ddDMoaQHr5PQN4dIXd7OXLMUzakIW/+qDIh3dx5vLXhL4gL6
	 H0fKXUSM/W/2efB56PzSRWVPlQ6Tywx88U0h9iZKsq+Z8S0T4OEoPfk/TRRC9uOL0w
	 1e20Xgb2x52zfuLTT/NCywruEWmGkc9aSkirDECimhPsB1LbesJqfUcznFTvMMVfVd
	 7IzuP6ULCrjV8vRjd0nNunvYIAb4m/EnW3hVEGhyEvveCg1CDCX3UOgyuJ+PcNPy1W
	 dZz+2CNDObw4g==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 327E3F40069;
	Tue,  7 Apr 2026 22:35:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 07 Apr 2026 22:35:56 -0400
X-ME-Sender: <xms:DL_VaSAZZAV53uxjsRoP8ApXqKPTHg7KaBhB7ifUm8g8fwFadW9NrA>
    <xme:DL_VaX_AR3Is1-h9xH8WUeuJcRC38pgF90y0A6m3yM7MpjDZARyngo-u9S3wPZIUJ
    4o2uNUJ3XyzvWXOV7ZIRoTYYLs56H9p8vJ4Izg_7XLDsypywO4IZt-R>
X-ME-Received: <xmr:DL_VaZEjfj4Ec1nGc6wYr8-0FSY_nr59Sbmj-g9KVnDM8g4QhUw4u2vAuTLe_YPrMBG6hOJEjQ11pfQsEQoj6sOtMtHkbSh7dLU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvvdefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevkffugggtgfesthejredttddtje
    enucfhrhhomhepffgrnhcuhghilhhlihgrmhhsuceoughjsgifsehkvghrnhgvlhdrohhr
    gheqnecuggftrfgrthhtvghrnheptdfhtefhheekffekueetkeeuteelieffteetieegje
    evueevveefledugfefhfefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegujhgsfidomhgvsh
    hmthhprghuthhhphgvrhhsohhnrghlihhthidqudejjedvfedtgeehhedqfeeffeelgedt
    geejqdgujhgsfieppehkvghrnhgvlhdrohhrghesfhgrshhtmhgrihhlrdgtohhmpdhnsg
    gprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlshhfqdhp
    tgeslhhishhtshdrlhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqtgiglhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvg
    hvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:DL_VaVNRgpJOjWjXP8hbzVv3ecxHhcj4jkmX_hhlkwFAzGQIjjZfkA>
    <xmx:DL_VaTfFIwx3t5CasfjAMCpUsgvnb2MJXQ08a8_8Zi6o0Kvwehm6ZQ>
    <xmx:DL_VaauMv1Ry1BCjazIFh2eT6bby-rGeKEz16WKt5x9_EdDmbhHhmw>
    <xmx:DL_VaclDqlrxZWas45yv3xXH0aT9QZzYkg-JK7QuPGinkIOshHG8Jg>
    <xmx:DL_VaUzMrWI9WaBAGB14TgJZjrS71Tos5c9nOdNlAxbfV_njFljK-y-o>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Apr 2026 22:35:55 -0400 (EDT)
Date: Tue, 07 Apr 2026 19:35:54 -0700
From: Dan Williams <djbw@kernel.org>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-cxl@vger.kernel.org, 
 linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org
Message-ID: <69d5bf0ab2210_2b3110036@djbw-dev.notmuch>
Subject: [LSF/MM/BPF TOPIC] What's brewing in CXL?
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4528F1C0004
X-Stat-Signature: x1nkpfz6mg4pzgxcptfthm4zjnonjjfi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775615758-978009
X-HE-Meta: U2FsdGVkX186R2VcjvqTqAP8cLzSLJ+w6qHqB6lZHiNP5x9nxxRkrCRnS5UDvEzXqKCioW6H1LHi9bjp2L55GnLuwpmS//2V74d+VzBQBLCw5u94kwAR0JpNwxLzpGPIcmuRMlItkPYGaT52dDfd6n0i+1a45S8jdk300J2+7WrGOSfM9M2cb+b1ZkvXlXUPvv6iXxWflgSmdOG2zerosSEiyqeJwnjQ7xKFykAMV2siTepyNxlW8eg4Z1jyQUxc1arHOWNlrWX2Gaj36r9SGLplnXPey/t/KemMJ0Ygx/wBFCZ1TNztSuSJBHj/aWVhsHrstR0VZDLUcDJNXW6Lp+Z02uzj26AqC5GdzpyhfbiOdWMsmJqcrWkmWndpzWiG8zcwSGSxyZ+R4zJmcwc9ILEvHu4QtsKz4yKcQ3uqTdEvmwIwNHQ09nuqht2mbQmA6pPYO0fm32jiDJZ/TGC6g4vAC6SbHKlKxXtIcJM6UJLRKefejIz9nvReXOR3UL/+nEsmLuBCzY1M2VcSM+KW4tb1/72Lb5Egwa72efwRs4+ByJNoLzEOL4sWAxbS9axerk/siw6CbtRYrbVt0LMGcsyuBhUXjDXo2+MJ2kxcqwfoU8Pn5XPb4sz91kAu4/PuV61HLkkCI8U9C+upd2dTrL2HiSJecNBY2JyF2jVZg8iRSpgimO4Lx86/fuO7AENi12aOQUwEqbg+MVbi32aXEQHiX+7B79d6I0O6jTrVqKDz8I8vusyDenL2BToco88+milMW1oaEX0i3s9DPIEqftx6StVcehk4wdVvjfNgqayd/tBRzSxM6misP4BnClQKW+QXntRjyokjXrZv0mTnfqYb+gK0aL33rv/SSHCjSzPZiCAsnEYEXJcHWohDYInWXNf3skt7+L4Ew1hxvvujCy2Yvvf+x2z6mb/LLNB6UkDeoccT7hyXnVsbsMnuOflOXlM84jWXoMGkrofpZa3
 jYQIEw52
 abRjDlzpHPoRL7X+Bxudsx3LT9qiNYqngE2TTIgLWlELrmHEc5DP3dmiR+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the summit I offered to organize a discussion on what has been
happening in CXL since Plumbers and a summary of the monthly CXL calls
since. The session goal is present top challenges, address concerns /
questions from the room, and perhaps introduce the CXL topics that have
their own session later in the day.

Please do comment, question, ack/nak, or add to the themes below to
highlight interest and help focus on the few topics we can cover in the
limited time.

* CXL vs MM:

  * Much of the angst of "CXL vs MM" has been harnessed by Gregory in
    his Private Memory Nodes proposal [1]. The meta discussion for this
    session would be questions like "how many former device-dax use cases
    can be subsumed by a mechanism like this?". In general, the game here is
    how to properly isolate memory that does not behave like locally
    attached DRAM.

  * The granularity of CXL hotplug vs memory_blocks vs various
    distribution hotplug policies stimulated a proposal to support full
    "region" hotplug [2].
 
* CXL vs Platform Firmware (ACPI/EFI/BIOS):

  * Attempts to use software interleaving to amortize the surprise of
    "memory that does not behave like locally attached DRAM", introduce
    firmware dependencies. The firmware descriptions of the performance need
    to be complete and match a shared understanding of the requirements.
    Surprise, sometimes this does not line up. [3].

  * Firmware, in trying to be helpful to pre-CXL aware OSes, pre-map CXL
    memory (whether public generic expansion or private belonging to an
    accelerator) into the system address map. This causes problems for a
    subsystem that wants to support hot remove and re-assignment of
    host-bridge resources. Lack of a specified protocol and the resulting
    problems it causes for accelerator reset and driver reload, need more
    thought.
 
* CXL vs PCI:

  * While CXL capabilities are enumerated over PCI, to software it is an
    additional optional protocol. The subsystem supports being built as a
    module. This has led to a design for error handling that sees the PCI
    core minimally involved to forward events over kfifo. This arrangement
    is raising ongoing questions for uAPI like PCI reset and vfio_pci
    that expect to be able to manage device with PCI core services alone
    [4].

* CXL vs Tooling / RAS:

  * Error injection, tests, and usability have continued to improve. For
    folks looking to deploy CXL in production what is cxl-cli missing?

  * While CXL Error isolation has a hard time justifying its utility for
    general purpose memory expansion, the accelerator use case at least
    has a reasonable chance to construct a recoverable scenario.

[1]: https://lore.kernel.org/linux-cxl/abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F/
[2]: https://lore.kernel.org/linux-cxl/20260321150404.3288786-6-gourry@gourry.net/
[3]: http://lore.kernel.org/20260316051258.246-1-rakie.kim@sk.com
[4]: http://lore.kernel.org/20260401143917.108413-1-mhonap@nvidia.com

"CXL, making MM problems worse since 2021..." -- CXL subsystem tagline


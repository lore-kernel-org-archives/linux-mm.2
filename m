Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E9FCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 21:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357436B0062; Wed, 27 Aug 2025 17:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308096B007B; Wed, 27 Aug 2025 17:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DA86B0088; Wed, 27 Aug 2025 17:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3EC6B0062
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:31:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99A681A083E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:31:07 +0000 (UTC)
X-FDA: 83823832974.24.26C6754
Received: from manchmal.in-ulm.de (manchmal.in-ulm.de [217.10.9.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C1A280003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:31:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=manchmal.in-ulm.de;
	spf=pass (imf02.hostedemail.com: domain of linux-kernel.bfrz@manchmal.in-ulm.de designates 217.10.9.201 as permitted sender) smtp.mailfrom=linux-kernel.bfrz@manchmal.in-ulm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756330266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UYWGQPmX6bVwZclzC4hrEojML/ykl94D8lch15dFTbk=;
	b=pCmvIlbrTT3VAGMDS9tdpiS/PyfmajCMwze/IldZGkm4yCNLrOfAk4EVQ9JAJOuo5VUZrZ
	bqYMkWo4bEBYn7arbeASHi0o9SebG+HR7KhXI7rm0db+atbaMMdtaWcfv/SkjJWzA87Uu5
	GLvXf97GA4HocnNJko0ce6R9KqavVI4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=manchmal.in-ulm.de;
	spf=pass (imf02.hostedemail.com: domain of linux-kernel.bfrz@manchmal.in-ulm.de designates 217.10.9.201 as permitted sender) smtp.mailfrom=linux-kernel.bfrz@manchmal.in-ulm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756330266; a=rsa-sha256;
	cv=none;
	b=ONpl4qOtRgk/dqk0bco79Ab5cbIlSj4RW2d3g/94N8pElS8uUgDW30Q4yaE8L2XtZbkxNW
	ai4loG00/1E2YVVQd7zrlYRQ7ZbkIyfqSCHfPA/DOkObB/Z5eb0Yc8XYQUDN6LRYCmSZ0G
	UZ5quNf39uKrlsiJqe7UtakaFrmmAlg=
Date: Wed, 27 Aug 2025 23:31:02 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Helge Deller <deller@gmx.de>
Cc: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-parisc <linux-parisc@vger.kernel.org>
Subject: Re: 6.16-pre-rc1: BUG: Bad page state in process swapper on parisc
Message-ID: <1756327287@msgid.manchmal.in-ulm.de>
References: <5a004aef-9df1-4126-b167-1aae27d4240d@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a004aef-9df1-4126-b167-1aae27d4240d@gmx.de>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C1A280003
X-Stat-Signature: rkkz6187dfb33nbmnudokxyt61mudxs8
X-Rspam-User: 
X-HE-Tag: 1756330265-640172
X-HE-Meta: U2FsdGVkX1/Ho7izIyBhyM6DKWyVEoqTa+EM5o6W3fuSluopq1jz3BY6bojjzyCnNvWpdP9j/bsbPETlDynXCxCsVe7V1M65w09MazJGmqSsKxS+9waDUr1i2f0Tkl4EbLoxHG+JNQFbAay7G/Ca22xjEcvN0gPnzt1hOYuA2HeAH+WqwNlh2tBkYaQzYqb2U/Jbn3qlRgYiEtF+JE8kFCwcbNO9ksMwYD6J1KGfYj+MRlPRscL7pMD7/Zrj1APZARiAIUs08JhZtVAZk4j7eyOOakb/7Gbl0zV7qduMQY8F7AZVXcpvVIegLB5kJgYxky5elDsjbKVe6Iy4Hs3LYIULRYs/vNfGIbZXw4ZwM0BhGlsw2uTib3Vo60jxcnvO31g0lctfoYHIeJoCwCjlcL/zDISUjvpr7RbSSPSnjCWs5nH4jSd0MxY4G6ryP5bvwptcwYNz7xqpy/96VSnGKR6mRsyytvBPAIRok9cVbmt23jPGoJgHl6lXuz1Ehd8Htt/qlC13x93Mc6XvTk1GuAxRWg7UcXpanqHckotgS9sVTLpJM6FJCJB4+uk7KRgORcjuAYnKbcTv4dYizAZ/IluaQStM+7eKamiEnXqKv9bIpBzQc9BDENuvQsPyte5EMSdzRydfNfm59E9dRjqy4E/rltdKPSjDY7sZGmNRjFr9dRCDxPHOFjXi8/RvWXQIf5EcRJ7lpXNsiIcsZLsGLrzTMaVMBmFso9HzIKo2pnk37BiinfL3CUW/d2QON9/bRmfTJ/3ZbH55z5uNAyv5F5Hnmvb3GUkA6jphAjDGBt5cqfamnoVlMl1CtLxGnLiA+ySCHceMjLVkYFUNJ01/KVFXITUpjaxKlGoAvpvz9moTsiJpU1UGpBxdIMR2K7v85fZ5SuAk3BRIFJPaUwFWGMLq9jyuxx0m/6iJ+oxmKFzlOwHBbFDnH851Mvy+8zfMBA1C+jsxt0mk6+VhDU4
 InX2qon1
 qopc+mzH0QMJPQIdKg8x+wQQPFbI+2ezPaVyXCGsRV7O5OkU6s/tYQXCjqUHBGYkRUoUCuFJ19w5Azuk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for being somewhat late to the party ...

Helge Deller wrote a few weeks ago ...

> I'm facing a kernel crash on the 32-bit parisc platform with git head.
> 
> git bisecting leads to this patch which triggers the crash:
> commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
> 
> Syslog:...
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 131072
> [    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
> [    0.000000] stackdepot: allocating hash table via alloc_large_system_hash
> [    0.000000] stackdepot hash table entries: 32768 (order: 6, 262144 bytes, linear)
> ..
> [    0.000000] MEMBLOCK configuration: (I added this output during debugging:)
> [    0.000000]  memory size = 0x20000000 reserved size = 0x01f0ed2a
> [    0.000000]  memory.cnt  = 0x1
> [    0.000000]  memory[0x0]     [0x00000000-0x1fffffff], 0x20000000 bytes flags: 0x0
> [    0.000000]  reserved.cnt  = 0xa
> [    0.000000]  reserved[0x0]   [0x00000000-0x0008a0b0], 0x0008a0b1 bytes flags: 0x0
> [    0.000000]  reserved[0x1]   [0x0008a0c0-0x0008a130], 0x00000071 bytes flags: 0x0
> [    0.000000]  reserved[0x2]   [0x0008a140-0x0008a143], 0x00000004 bytes flags: 0x0
> [    0.000000]  reserved[0x3]   [0x0008a150-0x0008a153], 0x00000004 bytes flags: 0x0
> [    0.000000]  reserved[0x4]   [0x0008a160-0x0008a2d3], 0x00000174 bytes flags: 0x0
> [    0.000000]  reserved[0x5]   [0x0008a2e0-0x0008a5e3], 0x00000304 bytes flags: 0x0
> [    0.000000]  reserved[0x6]   [0x0008a5f0-0x0008a6b3], 0x000000c4 bytes flags: 0x0
> [    0.000000]  reserved[0x7]   [0x0008a6c0-0x0008acc3], 0x00000604 bytes flags: 0x0
> [    0.000000]  reserved[0x8]   [0x0008acd0-0x000f6d8f], 0x0006c0c0 bytes flags: 0x0
> [    0.000000]  reserved[0x9]   [0x00100000-0x01f17fff], 0x01e18000 bytes flags: 0x0
> [    0.000000] BUG: Bad page state in process swapper  pfn:000f7
> [    0.000000] page: refcount:0 mapcount:0 mapping:00000000 index:0x0 pfn:0xf7
> [    0.000000] flags: 0x0(zone=0)
> [    0.000000] raw: 00000000 118022c0 118022c0 00000000 00000000 00000000 ffffffff 00000000
> [    0.000000] raw: 00000000
> [    0.000000] page dumped because: page_pool leak
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-32bit+ #2730 NONE
> [    0.000000] Hardware name: 9000/778/B160L
> [    0.000000] Backtrace:
> [    0.000000]  [<1041d1f4>] show_stack+0x34/0x48
> [    0.000000]  [<10412dd8>] dump_stack_lvl+0x80/0xc8
> [    0.000000]  [<10412e3c>] dump_stack+0x1c/0x2c
> [    0.000000]  [<106ece88>] bad_page+0x14c/0x17c
> [    0.000000]  [<10406c50>] free_page_is_bad.part.0+0xd4/0xec
> [    0.000000]  [<106ed180>] free_page_is_bad+0x80/0x88
> [    0.000000]  [<106ef05c>] __free_pages_ok+0x374/0x508
> [    0.000000]  [<1011d34c>] __free_pages_core+0x1f0/0x218
> [    0.000000]  [<1011a2f0>] memblock_free_pages+0x68/0x94
> [    0.000000]  [<10120324>] memblock_free_all+0x26c/0x310
> [    0.000000]  [<1011a4d8>] mm_core_init+0x18c/0x208
> [    0.000000]  [<10100e88>] start_kernel+0x4ec/0x7a0
> [    0.000000]  [<101054d0>] start_parisc+0xb4/0xc4

The same occured here but due to time constraints and hardware issues I
couldn't dig into this earlier.

Bisecting in the 6.15.y stable series led to commit c30ae60f41f9 which
was cherry-picked from ee62ce7a1d90 ("page_pool: Track DMA-mapped pages
and unmap them when destroying the pool").

The problem still exists in 6.17-rc2.

| HP-UX model name: 9000/785/C3600
if that matters.

    Christoph


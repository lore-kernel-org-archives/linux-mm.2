Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A236BCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3106B00D5; Fri, 29 May 2026 11:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6744F6B00D7; Fri, 29 May 2026 11:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BFE6B00D8; Fri, 29 May 2026 11:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5DA6B00D5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B84AA01C4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:45 +0000 (UTC)
X-FDA: 84820774290.08.24C5B6F
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C73120016
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KHIjy/CF";
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nr+g4bn7R579mD3Y03TuWUSeVDUqiKsP3+OhxcAEXrs=;
	b=vq9oZTbQyH/i6bAfPRQk2yWtcHSEm/2C4W+7kXyx0M9HFl1N8Qk/GivmyDeMgJTrZ1wAen
	bkdqIuDa6EgFbiAhioCZgbG5Mz7m6MS8lWAizKhN41kZvrT4951W8wwh0qWMcKo83rMumw
	irjvWkjUBpo094FBZO4FK+q7pflmIjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066963; a=rsa-sha256;
	cv=none;
	b=WMukuFJObCCqVrurddPkEC79s3CySsoRFOlU08r7x09KBkJGqoYC/RQrKzGCmv5v1mrN3/
	SEuRPS9CccbpiYss/mKfXB/F3leSk34/0hvdJ6uGwzf1expLNmnfGrTiWbi64ePuTx6Ovy
	hJ8NvXTlPNCYsMGjbYsO9w43BFx8cVk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KHIjy/CF";
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain; charset=UTF-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780066960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nr+g4bn7R579mD3Y03TuWUSeVDUqiKsP3+OhxcAEXrs=;
	b=KHIjy/CF1A3+4fzbwtgNcdW/l9N0WpDILcuvrdWVIYa4WplG55L86uPEkc35TEKL6rlYUs
	iPnP3NmgN1CtbzGPLA6myTQ+fCxPGlT+Kslpni2DUj5NdVXg/vUd7jAmfJ8wfucCXR5gvV
	sbqqEwE9gYyi6m18fUbOwMrKJPkYIH0=
Date: Fri, 29 May 2026 15:02:33 +0000
Message-Id: <DIV92L7AZOHG.1FKDUXLPZEUK4@linux.dev>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 <rppt@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>,
 <derkling@google.com>, <reijiw@google.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Yosry Ahmed"
 <yosry@kernel.org>
Subject: Re: [PATCH v2 19/22] mm/page_alloc: implement __GFP_UNMAPPED
 allocations
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Brendan Jackman" <jackmanb@google.com>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com>
 <7bfda0d8-2a7a-4337-8b55-d0c158df7839@kernel.org>
 <DIJEIELZ5DJU.26LYHOT4WR7A2@google.com>
In-Reply-To: <DIJEIELZ5DJU.26LYHOT4WR7A2@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: qab3bhtkg6zyb79o599nkybqrbt3ojby
X-Rspamd-Queue-Id: 0C73120016
X-Rspam-User: 
X-HE-Tag: 1780066962-370875
X-HE-Meta: U2FsdGVkX1+NPO/yPn5rK3EkN1LlbrahTsc4uPMxRJLci3mZ7tmEKJm3GU3q2vJHOXKzOl2PMjjrkQW9SZpvvNpyAi73M/7Xnq2R6qhkXMuPLu17gRx4357MPR9ogRZTYdwrSfUAutc3q/KsKFGCpas9FnBSXxyIxuzrd3K5Ekus2/0zrOCqhwHAnUrHYnm6sgGyNI2XSE4RPLSmeR58KL2cxXmpDc12JasDQt+QpLuPrQm4Qyxaa8IztDHK7ei15wVN575mJ7kv5YPhk+MgyvnVwGW8B4+rAidqZysCYPm+uFTtbEmKHX+N8XYkEksymKYvgn9jjoRdPmN0aMO9biUGLnVdOgQ/hkTWh/jQ8xCYpPzJMzDWvD9GPSBYHYUCs4xgLwdVIdjHBhDXvVxhGNV+elimHmIvbui2RWW5lWXK52exiLmoum3gI3Z5b3qHWn0EGLdL0bf3bURq24+CAwMJRMuJhHgA9tzVq1RCf7PSyQXYkqCQU8oDZfAMEEVZofoUW7GRINbAl2IEg+2A011ZDr3sa9v2Detho5xkMmnv87Mu2t33CsBRFIVI2RLwY86Pv/JaZXbW6GIv3XDT3PdY20F9ECd65GO9pXxaYbdywFhvrBpwo4pSdvTmJBBbg46FuBGGKTTJm+LvnbLqiDTPAR5YTY0tlggkut1n4ylRdgxeTyscel7n9cYcty5l5GNk0wMVTt8qEOuvASokMhyq4C5zXI/jFhAMqloHeCBHgyUFEvLsp6ZITLnJ1yzPJdlbhe5Rsd2xT1jGLW87s+/w04Ehq6POlCOuTRJ4+nikRCTraBdosW+vsEY7xKuEpmYDhe8ZPdPBnA+yg/Ij9SW+1Ssy3kuvJH6Qj+1e/h2zTiS++WvIn7/H9Z+fE9UvnxKUrM9P6+vjHj7kfBhC3DxpDn7djerqP08Pm+9daQ2o15vGdevMgpkgynj9fQdTFIT/B4bODWA6PoEbSfO
 brfGv31X
 /ky3c/vj9L3cfWyg9QDzlrm/K6otsv8LgSq1FZKYHrx234O+w1O6eQNSaTthaeqJ7qZh7QJALkZddh0bASDaFpvA8UZE5vDWA4vf0tBRbYeX6KKk10OY+314w+eq04K90/I6Vtak3KkHvfD+HW32Y485Zg/7kVdvHR9g4tSjjoHEWLq7jIUg9ta2tp9DG2aKdXS5rLwsZRYUaRrUK9snjKKmvga6nDU3R9N9R9AagbB96ugDW94SPhosryQlE8CofY+8JjZRDp9xsyW78JappHVm6JshaB0Q1HldXke4R3dGNZEprrSz1c+gTow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri May 15, 2026 at 4:46 PM UTC, Brendan Jackman wrote:
> On Wed May 13, 2026 at 3:43 PM UTC, Vlastimil Babka (SUSE) wrote:
[...]
>> Uhh, speaking of compaction and reclaim... we rely on finding a whole fr=
ee
>> pageblock in order to flip it. If that doesn't exist, the whole
>> get_page_from_freelist() will fail, and we might enter the
>> reclaim/compaction cycle in __allow_pages_slowpath(). But since we might
>> ultimately want an order-0 allocation, there won't be any compaction
>> attempted, because that code won't know we failed to flip a pageblock. A=
nd
>> the watermarks might look good and prevent reclaim as well I think? We
>> should somehow indicate this, and handle accordingly. Might not be trivi=
al.
>> Or maybe reuse pageblock isolation code to do the migrations directly in
>> __rmqueue_direct_map?
>
> Ah, thanks, I suspect you are right.
>
> I did fear there would be some sort of case where this "not-quite
> reclaim" interacted badly with the actual reclaim, and I tried to test
> it by running some stuff in parallel with stress-ng (allocating
> __GFP_UNMAPPED via secretmem), and I didn't see a difference in the
> effective availability of memory. However, I suspect testing this is
> quite a deep art my "run these two commands that I copy pasted from an
> LLM suggestion" test was just crap.
>
> Do you have any workloads you can suggest for evaluating this kinda
> thing? We would definitely see it in Google prod (I think we see this
> kind of issue with our shrinker-based internal version of ASI distorting
> reclaim behaviour in ways even more subtle than this) but that is not a
> very practical experimental cycle...

I slop-coded a benchmark:

https://github.com/bjackman/kernel-benchmarks-nix/tree/master/packages/benc=
hmarks/secretmem-vs-frag

It does some mmap/munmap patterns to try and generate fragmentation,
then spams secretmem allocations until it gets OOM-killed.

With this series, I see the OOM-kills happening noticeably sooner on a
1GiB VM:

metric: secretmem_allocated_bytes (B)   |  test: secretmem-vs-frag
+---------------------------------------------+---------+-------------+----=
---------+-----------------+-------------+-------+
| kernel_release                              | samples |        mean |    =
     min | histogram       |         max | =CE=94=CE=BC    |
+---------------------------------------------+---------+-------------+----=
---------+-----------------+-------------+-------+
| 7.0.0-rc4-next-20260319                     |       4 | 683,147,264 | 643=
,825,664 |               =E2=96=88 | 715,128,832 |       |
| 7.0.0-rc4-next-20260319-00028-gf00246eb72cd |       3 | 623,553,195 | 551=
,550,976 |            =E2=96=88=E2=96=88=E2=96=88  | 692,060,160 | -8.7% |
+---------------------------------------------+---------+-------------+----=
---------+-----------------+-------------+-------+

So... I think maybe I've reproduced the issue you pointed out? I will
try and fix it and see if this degradation goes away.


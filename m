Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66872C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868066B0096; Mon, 24 Aug 2026 07:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818196B0099; Mon, 24 Aug 2026 07:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755236B009B; Mon, 24 Aug 2026 07:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0EF6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:55:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DBA9E4049C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:55:44 +0000 (UTC)
X-FDA: 85136008608.08.80F36B9
Received: from mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id AC3D340009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:55:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SYxlGl+3;
	spf=pass (imf27.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787572543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6V38Y/LCKzqBiK5IPBNyYf66QS5OFBvnQPyqIVJvh7k=;
	b=2Kw9AP1S+RSeCabnInIR42cIKg4YyAg+EIDXVpC3+JhEBEySCYG8bx2cZ0Nkva+AHuukX8
	FfTjCWt9ba5OTnPFwEs0mNCXWFAFC/noNukUBKo+r0RYXfji1NTOpbULikzAZrnoptz4Od
	18NYNXlmPktUkUwfGW3+QogFMZ/FyzY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SYxlGl+3;
	spf=pass (imf27.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787572543;
	b=ddbiZWYEkFqmvjfdvEdn0tTtxTdK5538qyg34l1E8LGc/lyhe8nfrMO77nwWNtUJGTXRBP
	0CgTfmopuf+wISE/gQQDDFuA8hYwthkz92ZRL/1KEQhBTrfVESVNvmtrSOWYWVHhY7K+4j
	VHv6SfJ/WSY2PHCsfcBpagoP4qiNQfg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9sA4HqESCZemC8Qy80NybOgOQNBjAON37oeRT7uodbM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787572541; v=1; x=1788177341;
 b=SYxlGl+3U0uxHPBjdIMelnEAoM9wpLwgKBpxpy9o/Yb88XIMUU6HeWO/Hb2YNdeaLSa6awam
 Lr5VEdDmyaqmN2RgB+g7GA//9Kf2DvwG2HxqrhoIsGE3oc/SdzxpL2kADhd6tlTlACYKJ7+n6vu
 b34UrEf7pu5KQ+Jc7GtlaF7g=
X-Envelope-To: linux-mm@kvack.org
Received: from [7.250.142.105] (139.159.170.87)
	by smtp.migadu.com with ESMTPS id 90b5f181d21c03a6;
	Mon, 24 Aug 2026 11:55:41 +0000
X-Mizu-Trace-ID: 90b5f181d21c03a6
X-Migadu-Flow: FLOW_OUT
Message-ID: <5da6d1ef-28c7-4aed-abd4-a0d74da7998c@linux.dev>
Date: Mon, 24 Aug 2026 19:55:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: disable smart scan for ksm_tests
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, shr@devkernel.io,
 ljs@kernel.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20260823184314.45044-1-zenghui.yu@linux.dev>
 <24cdec9c-28b5-4e44-bb05-fef27ef09846@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <24cdec9c-28b5-4e44-bb05-fef27ef09846@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC3D340009
X-Stat-Signature: nqs5wk3pyzii84ugqz85s5cgogx7sx6j
X-Rspam-User: 
X-HE-Tag: 1787572542-910362
X-HE-Meta: U2FsdGVkX1/tw+Dasexx9Jie+HUsuobOcxvEgm91dT4pGicnK/fXg8hIo+0v4UPmsKRKwAHRXDZAeNTDcbXRckbzys8+VWSllct4sz7qKcP0536fYh+6Fv5yBEDiYm8IvHYBprtLWtVWbhuz8u5QCi1Uo3lDyPUgUhO0B0qmiFqtyS/NWfoS9cXFlJUajxo36AdrdGJlSDJeTX9oT+lGTC8O+WiNCPyZ2V1VBjBuXIDrgwCF7kLI9UxqCLbLBFpiE3CsUNpi/EZdHiEddIQvsnZ7uXWD1Wq1Lj0l8rFR2wFTGR3aLvNo0XMnb8cr5DqJzNkLSMaThMqAGk1Kmu8HlkE+f9oXBDMM/XA/aVr7j3hoFe4KysqpmYEtZmMVY808Jse8D3VgHTa1DBX+EY/LDauhGndyqOsrII4E5ob5mPhJuChK1K61ADvRYtqDbG2+FNoX76KOjH8vwW32ZpaSxilPvicuxnlcDT3qJH3WR64U5QNlYPm8RLYmg75eQ5lgEM2q3YEzPHyHpjs2dC/f0cxd3RML7KwAfo7RyNOVBxC/KfhLa8jPOTyXRnQD5hOLL05mPueW5LGocIA9JmRly0Hu7dDwbtHqpsvYxoCAkuRi+qH4pufZ0YkHH4ic29I7HaTf5vCj+gMAlm+McRTRmQAUhYDm/I8txENRJ4tHT3Gp1Nq+4UNDmdL+bhTUXrgq9FYzehDFXzBhiRH6OyUbDTzIzS0Fe9ZlCYpWWPHdAEQ9wwVGY6MdZbk9PHGkYSSksY4npW43kOkoUvWUOuaIMABNiPFaRQtYkRl/zAg8W4U1vniHDQz8NcQQXU+wWj8zuC9UoxEBV0CPcTaFu6nPo78fFrecVP2FOtLZk2tOolwSRtu0cOsZP8Ej7srUdxG++HTkRjYhtyVGQgAOLOGewYAS+1HnnXTLPNhhj/pEqgmKREMullhr2huc6j7ThO8/wCsoKbQsR3PIfBsvyKB
 rhDocfaQ
 VhYU84u7xhyheBmyRjh8P907hnNx7q2T20jppA4t405XWnh+fRHlvdDM+XQezsYGEts6xRQpYFX7mhA4P5VyLfWDG2wecuGYHRlthE93vUfU6m60oihycUR3qJqDFfrb2S8IbVM+rwt3DdOM0ClZ5GevQL7BvxkgcIy9Cupew0QSQvbqGVztkEVM1apCipr3g1O/CCKRxNmhlu3CGtLfmsleLuIWFRQuZ2FR+so1IjF7q3z/MjhyGMO75uiJpWKpxD4tYUceVp6NaKOeqja/EkqWPGdYUpMjJI1GdKlNl9P30kbvyIV5Ntq8HKcU9fHIW7Yto
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 8/24/26 6:33 PM, David Hildenbrand (Arm) wrote:
> On 8/23/26 20:43, Zenghui Yu wrote:
> > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> >
> > The "KSM NUMA merging" test allocates two identical pages on two NUMA nodes
> > and verifies KSM will merge these two pages after 2 scans (see
> > ksm_merge_pages()). But when smart scan is enabled, pages that have
> > previously not been de-duplicated may get skipped for some scans. Verifying
> > KSM behavior after only 2 scans may not be enough.
> >
> >  $ ./ksm_tests -N -d
> >  TAP version 13
> >  1..1
> >  pages_shared      : 0
> >  pages_sharing     : 0
> >  max_page_sharing  : 256
> >  full_scans        : 211
> >  pages_unshared    : 1
> >  pages_volatile    : 2
> >  stable_node_chains: 0
> >  stable_node_dups  : 0
> >  general_profit    : -128
> >  ksm_rmap_items 2
> >  ksm_zero_pages 0
> >  ksm_merging_pages 0
> >  ksm_process_profit -128
> >  ksm_merge_any: no
> >  ksm_mergeable: yes
> >  not ok 1 KSM NUMA merging
> >  # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
> 
> How did you reproduce this? Is this an actual test result?

I reproduced this in a guest, using arm64's virtconfig. I don't think there
is any particular configuration. This is an actual test result but this is
not 100% reproducible.

> ~/linux/tools/testing/selftests/mm$ cat /sys/kernel/mm/ksm/smart_scan
> 1
> ~/linux/tools/testing/selftests/mm$ sudo ./ksm_tests -N -d
> TAP version 13
> 1..1
> pages_shared      : 1
> pages_sharing     : 1
> max_page_sharing  : 256
> full_scans        : 1283
> pages_unshared    : 0
> pages_volatile    : 0
> stable_node_chains: 0
> stable_node_dups  : 0
> general_profit    : 3968
> ksm_rmap_items 2
> ksm_zero_pages 0
> ksm_merging_pages 2
> ksm_process_profit 8064
> ksm_merge_any: no
> ksm_mergeable: yes
> ok 1 KSM NUMA merging
> # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> 
> >
> > This specific test fails because KSM started scanning the second page
> > whilst the first page had already been scanned for 16 times
> 
> How is that supposed to happen? The sequence we have is:
> 
> numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
> numa2_map_ptr = numa_alloc_onnode(page_size, second_node);
> ...
> memset(numa1_map_ptr, '*', page_size);
> memset(numa2_map_ptr, '*', page_size);
> ...
> if (ksm_merge_pages(merge_type, numa1_map_ptr, page_size, start_time, timeout) ...
> 
> KSM smart scan operates on rmap entries. rmap entries are per MM.

This is what I had for debugging:

diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e0998..aec2a292cba5 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2495,6 +2495,8 @@ static bool should_skip_rmap_item(struct folio *folio,
 	if (age != U8_MAX)
 		rmap_item->age++;

+	pr_info("addr=%lx age=%u r_skips=%u\n", rmap_item->address, age, rmap_item->remaining_skips);
+
 	/*
 	 * Smaller ages are not skipped, they need to get a chance to go
 	 * through the different phases of the KSM merging.
@@ -2820,8 +2822,10 @@ static void ksm_do_scan(unsigned int scan_npages)
 	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
-		if (!rmap_item)
+		if (!rmap_item) {
+			pr_info("\n");
 			return;
+		}
 		cmp_and_merge_page(page, rmap_item);
 		put_page(page);
 		ksm_pages_scanned++;

$ dmesg
[  309.111144] addr=7fff959d4000 age=0 r_skips=0

[  309.111215] addr=7fff959d4000 age=1 r_skips=0

[  309.111223] addr=7fff959d4101 age=2 r_skips=0

[  309.111230] addr=7fff959d4102 age=3 r_skips=0

[  309.111237] addr=7fff959d4103 age=4 r_skips=1

[  309.111241] addr=7fff959d4000 age=5 r_skips=0

[  309.111248] addr=7fff959d4105 age=6 r_skips=2

[  309.111251] addr=7fff959d4000 age=7 r_skips=1

[  309.111255] addr=7fff959d4000 age=8 r_skips=0

[  309.111262] addr=7fff959d4108 age=9 r_skips=4

[  309.111265] addr=7fff959d4000 age=10 r_skips=3

[  309.111269] addr=7fff959d4000 age=11 r_skips=2

[  309.111272] addr=7fff959d4000 age=12 r_skips=1

[  309.111297] addr=7fff959ac000 age=0 r_skips=0
[  309.111303] addr=7fff959d4000 age=13 r_skips=0	-> page 0's age is 13 greater that page 1's

[  309.111311] addr=7fff959ac000 age=1 r_skips=0
[  309.111316] addr=7fff959d410d age=14 r_skips=8

[  309.111320] addr=7fff959ac10e age=2 r_skips=0
[  309.111325] addr=7fff959d4000 age=15 r_skips=7

[  309.111329] addr=7fff959ac10f age=3 r_skips=0
[  309.111334] addr=7fff959d4000 age=16 r_skips=6

[  309.111338] addr=7fff959ac110 age=4 r_skips=1
[  309.111339] addr=7fff959d4000 age=17 r_skips=5

[  309.111343] addr=7fff959ac000 age=5 r_skips=0
[  309.111348] addr=7fff959d4000 age=18 r_skips=4

[  309.111352] addr=7fff959ac112 age=6 r_skips=2
[  309.111353] addr=7fff959d4000 age=19 r_skips=3

[  309.111357] addr=7fff959ac000 age=7 r_skips=1
[  309.111358] addr=7fff959d4000 age=20 r_skips=2

[  309.111362] addr=7fff959ac000 age=8 r_skips=0
[  309.111367] addr=7fff959d4000 age=21 r_skips=1

[  309.111372] addr=7fff959ac115 age=9 r_skips=4
[  309.111373] addr=7fff959d4000 age=22 r_skips=0	-> remaining_skips can not be 0 at the same time for both pages

Not sure if I had misunderstood something.

Thanks,
Zenghui


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA30F606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UanhZ4fi
Received: by kanga.kvack.org (Postfix)
	id EA7376B00EF; Mon, 16 Nov 2026 02:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57DC6B05B0; Mon, 16 Nov 2026 02:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D916B05B1; Mon, 16 Nov 2026 02:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE49A6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:25:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E64D1608A5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:25:00 +0000 (UTC)
X-FDA: 85440145560.09.455A8A6
Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	by imf29.hostedemail.com (Postfix) with ESMTP id 371C2120004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:24:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UanhZ4fi;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxWuCpbv03Zc02+oBlxfrkWwPg/mIkyueML8T0AAdnc=;
	b=sAAX03gpWHKy2+sNDxMxp4oPPg6LsPiHcX9bj/fRr5BdBzl0gbo1fcnqUXm4RHZG5p610M
	TtxxHiJbb5xYJZEl3ljUNP4idryLkfPY6uijGzi0j+lOEWmgOnKEf8JA7wtwjglQ9KvZ9O
	j7tci2uX7YV5sqU8B5XKr7ybxfqYb7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813898;
	b=AiHVjC4mkzbyCN1xe3MHaR0/tWyiQiwpnT0snuLdHjpXaU765sT9VIJxlbknzW8G0JA3gB
	32iBXNBi3AYb8KL+9GF9bgMgM9ES8uz2N3UKuk5ZVZxz3l7FMI2vBdCZUGN7kfWuedNKVF
	tRb8GKxS9Z5EHQp+KPmUiP3wiqmy7cA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UanhZ4fi;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g8ClyyMtcgLdsQ6JL3yApqtIQt0AnNXmbikE9ZqcOv0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813896; v=1; x=1795418696;
 b=UanhZ4fikeBcpR755ZTsXCKC47TE+RRt60Tw4BHuythe1/9smHKtSHbU9Tk0lUCaaEqx9RC+
 2zLQe+fnGe5QYVi66r3gCDm4Y8svM86ocMa8reNfRbNSHedMdfImX5tC0QwGAkuPfTjO1Yxfv39
 Em3c8X+OX7l9vxmy46dF6BiA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b52167547f9f5bc8;
	Mon, 16 Nov 2026 07:24:56 +0000
X-Mizu-Trace-ID: b52167547f9f5bc8
X-Migadu-Flow: FLOW_OUT
Date: Mon, 16 Nov 2026 15:24:51 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	kasong@tencent.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: Re: [PATCH v3 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Message-ID: <avqvw25Ftak2Qq7E@fedora>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
 <20261113084953.412919-2-baoquan.he@linux.dev>
 <sashiko-outbox-214123@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-214123@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 371C2120004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dusmzf71nrb3afpi5d7mxkea4echkc3f
X-Rspam-User: 
X-HE-Tag: 1794813898-585892
X-HE-Meta: U2FsdGVkX19pGPCbyvxjnlqjPtvADW6KQSkdbUjyObKnhZp0Rxd8DPyNSoaZakTDKYAGzC/T+2i/6PXg7kgnxAYGEM13vAIM982w1wnCNlL5i9g5xS5wpD9zYHhRVV3CSpZC7HOc3K47zexi3EW8hyaQgh6/0UYlrOOgJQR26f0ldwIDHBa1kt51CVdU9hu1eWykS2xErgU4D+E7pKOFfLLynyyrM1ap68sBSlfK6F8aDYKY8Xnn5NWIEjolmJkVQl1hxfzDNRPjwU5rggUTn4StmYfT4arxa3R0Efi+0hI3g+x2+ldIEDUq4QWnSERfJSnhlYq3brLuWNdIrQSsU9Ui6Aq9tHu5E0V4yJI3WKFUWYoUxgcfPDC9pA4DNBtxnZ/TOKULyGMgn1zDwAa4Pa8leIfYEYLAybyFslKj6804q8n3E8GeanddtSAnkbcq1d6Exj0l8aMKM68eePGqoVYS/CDjpFkQv52Pyoh2MuRa0BYti6Xzc6vnkYLCOZq0qLCJotRoG3hsWdvnYAdPLFsuu1RwQS95a1I7LynuAHdFx+KRw96wTjcNMrceCMJ+t5DekzDGZEXHdQg2i+xJJ7MF4UiqBlAT/E/ATN8M5F+8WPfYBafsPzirUK94W8o9IQKAioQCjbiUIg7mbYTLEXqmAhxI0jwSVdfNfnmRAJuzqfmz5Niqp6jmq8AkrVogmB/XxN4qx7nmRxMg+F745D+JHwfVS91RjTQMsugTGWbCfluJw1IX2y/wihiusLek/aBMNIwyDgIjeFZ/NSfbrj3ibTPr6ZULaypnIgizxgKk+m0bapMU2t4+jQPzAnGWpFltTVI1VX5c9Wh7ax2RZqnaUZlHpIlygj269d5jq3sZLXGIAvvC7TgsSIo9M9amhHLPZjn0c3yZD4AzuDq2iGbmc3jYxGywhxsZN6P53RuFr+gsipRLccimH/RcoYSKiblOF7muNr6tqoEQiSJ
 meuZYM/v
 DhhaHfiHNDvR1j31jbEm7S4trJNpwvwUD/QeYyOpmNEAlUqYVO1NgIa3Ox5g4LLUlurSokbvtXxukCJg3/3AWw3mDL2pddkQu/7RrIFALPg347dBcq03Jg8viD2px8+krW5G07Qga5JgHW6D+8XVkUc7CFEGzLdNaH/K562pDcIAP7N90r6rjwIXJcRLOjbA56sM8TiQNx67IKoUhZVPoyV/mz2G2DxKdf/gCZAuQf+4OAy13T5r3kRRFbjEt5tK3xHLyLE3D30YUd/JCU67cTBivsG41eVYEWRBToEPec6LZdp+bv3pFzUTuKRiKYb5Tcm3RebA5Wjd/xTCZH8VKhvvkR3oXuSjXmcuha+hydnqWRE1VtRhiCZsahgW+SliooDgdSrNvoAzWVVCaGz/zIZY4XjP4WxxGqIWFMu8aJ1ITGFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 at 03:42am, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [Medium] mm/mglru: get_pte_pfn() and get_pmd_pfn() skip non-young
>   entries in walk stats
> - [Medium] mm/mglru: walk_pte_range() undercounts MM_LEAF_ASSOCIATED on
>   large folios
> - [Low] mm/mglru: mm_vmscan_lru_gen_walk tracepoint defined outside
>   CONFIG_LRU_GEN

Thanks for the review. All three points are correct. Please see the
reply in inline paragraphs.

> --
> 
> commit b5309c24549f959bf1eb3e88053e43540b30ee90
> Author: Baoquan He <hebaoquan@kylinos.cn>
> 
> mm/mglru: add MM_WALK_EMPTY stats and tracepoint
> 
> This commit adds per-walk statistics and a tracepoint to track MGLRU aging
> page-table walks that find no folios belonging to the target lruvec.
> 
> > diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> > index 9dafdb5bd3ce8..2b268fd0f89e8 100644
> > --- a/mm/trace_vmscan.h
> > +++ b/mm/trace_vmscan.h
> > @@ -763,6 +763,34 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
> >  		__entry->nid,
> >  		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
> >  );
> > +TRACE_EVENT(mm_vmscan_lru_gen_walk,
> > +
> > +	TP_PROTO(int nid, unsigned long seq, int leaf_total,
> > +		 int leaf_associated, bool empty),
> 
> [Severity: Low]
> Should mm_vmscan_lru_gen_walk be placed inside the #ifdef CONFIG_LRU_GEN
> block alongside mm_mglru_scan_folios and mm_mglru_aging?  Its only caller in
> try_to_inc_max_seq() is built under CONFIG_LRU_GEN, so defining it here
> generates unused tracepoint code and tracefs entries when CONFIG_LRU_GEN is
> disabled.

Will fix. mm_vmscan_lru_gen_walk will be put inside the same block as
mm_mglru_scan_folios and mm_mglru_aging.

> 
> [ ... ]
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 25a224746c36d..6034bae03dc21 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3582,6 +3582,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
> >  		if (!folio)
> >  			continue;
> >  
> > +		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
> > +
> >  		if (folio_test_large(folio)) {
> >  			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
> 
> [Severity: Medium]
> Does walk_pte_range() undercount MM_LEAF_ASSOCIATED when a large folio spans
> a batch of contiguous PTEs?

MM_LEAF_ASSOCIATED is not scaled by the batch size for large folios.

Will fix. For a batched large folio we now add nr - 1 as well, so
MM_LEAF_YOUNG can no longer be larger than MM_LEAF_ASSOCIATED.

> 
> When folio_test_large(folio) is true, folio_pte_batch_flags() sets nr to the
> number of batched PTEs and adds nr - 1 to walk->mm_stats[MM_LEAF_TOTAL] and
> nr to walk->mm_stats[MM_LEAF_YOUNG], before the loop advances by nr entries:
> 
> mm/vmscan.c:walk_pte_range() {
>     ...
> 		if (folio_test_large(folio)) {
> 			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
> 
> 			nr = folio_pte_batch_flags(folio, NULL, cur_pte, &ptent,
> 						   max_nr, FPB_MERGE_YOUNG_DIRTY);
> 			total += nr - 1;
> 			walk->mm_stats[MM_LEAF_TOTAL] += nr - 1;
> 		}
>     ...
> 		young += nr;
> 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
> 	}
> 
> Because MM_LEAF_ASSOCIATED is only incremented by 1 before the batch size is
> computed, the remaining nr - 1 PTEs in the batch are not counted, and
> MM_LEAF_YOUNG can end up larger than MM_LEAF_ASSOCIATED.
> 
> [ ... ]
> 
> > @@ -4158,8 +4162,28 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
> >  
> >  	do {
> >  		success = iterate_mm_list(walk, &mm);
> > -		if (mm)
> > +		if (mm) {
> > +			bool empty = false;
> > +
> >  			walk_mm(mm, walk);
> > +			/*
> > +			 * A walk that traversed page tables but found no folio
> > +			 * belonging to this lruvec (node+memcg) is pure waste.
> > +			 */
> > +			if (walk->mm_stats[MM_LEAF_TOTAL]) {
> > +				walk->mm_stats[MM_WALK_TOTAL]++;
> > +				if (walk->mm_stats[MM_LEAF_ASSOCIATED] == 0) {
> > +					walk->mm_stats[MM_WALK_EMPTY]++;
> > +					walk->mm_stats[MM_LEAF_EMPTY_WALKS] +=
> > +						walk->mm_stats[MM_LEAF_TOTAL];
> > +					empty = true;
> > +				}
> > +			}
> > +			trace_mm_vmscan_lru_gen_walk(
> > +					lruvec_pgdat(lruvec)->node_id, walk->seq,
> > +					walk->mm_stats[MM_LEAF_TOTAL],
> > +					walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
> > +		}
> >  	} while (mm);
> 
> [Severity: Medium]
> Does this count a walk as empty whenever an mm has folios in this lruvec
> whose PTEs and PMDs are all non-young?
> 
> In walk_pte_range() and walk_pmd_range_locked(), MM_LEAF_ASSOCIATED is
> incremented only after get_pte_pfn() or get_pmd_pfn() succeeds, but both
> helpers reject non-young entries up front when the mm has no MMU notifiers:
> 
> mm/vmscan.c:get_pte_pfn() {
>     ...
> 	if (!pte_young(pte) && !mm_has_notifiers(vma->vm_mm))
> 		return -1;
> 
> As a result, non-young leaf entries mapping folios in this lruvec are never
> counted in MM_LEAF_ASSOCIATED, and any walk over an mm whose mapped folios in
> this lruvec are all cold has MM_LEAF_ASSOCIATED == 0 and is recorded in
> MM_WALK_EMPTY, MM_LEAF_EMPTY_WALKS, and trace_mm_vmscan_lru_gen_walk() with
> empty=1.

get_pte_pfn() / get_pmd_pfn() reject non-young entries before
MM_LEAF_ASSOCIATED is counted, so a walk is reported as "empty" when the mm
has folios in this lruvec but all of them are cold.

Yes, that is what the code does, and the name did not say it. The
behaviour is on purpose. The PUD filter in patch 3 carries a subtree only
when it had young entries for this lruvec, so "nothing young" is exactly
what we want to measure. Counting the folios before the young test would
add a folio lookup for every cold leaf, and that is the cost this series
tries to remove.

So v4 will fix the naming and the comments instead: MM_LEAF_ASSOCIATED is
"young leaf entries whose folio is in this lruvec", MM_WALK_EMPTY is
"walks that found nothing young for this lruvec", and the comment in
try_to_inc_max_seq() says the same.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261113084953.412919-1-baoquan.he@linux.dev?part=1


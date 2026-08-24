Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D48FCC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84ED6B008C; Mon, 24 Aug 2026 04:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CB06B0092; Mon, 24 Aug 2026 04:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B356B0095; Mon, 24 Aug 2026 04:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAB06B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:12:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 281FB80487
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:12:03 +0000 (UTC)
X-FDA: 85135444926.01.F1DA350
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf17.hostedemail.com (Postfix) with ESMTP id 034D540005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:12:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w70lUTIr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787559121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hy00iRxJs2zY3ws8J+5v/W0KudWjjEJz3w0NrbACOkQ=;
	b=Z9LJeHhqNxMy1dEjX+yRYfip82p1iuwuORjOM0EtV3kfv2XHAl/gWDKqwmUK7Q/pcMCQTO
	BlEf4eubBNtRnohMpQvODJvRl9kWogRrMNE7BrNQdaYBluILQ8pUiYWugI6GVJF2iFVUGL
	kbKoMi2CF+pUswx9lpIPGua8gja5mDQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w70lUTIr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787559121;
	b=7AHrXil4GhWBYr8qB4yxWH8i5JZjJHufsf/vDXqtJqujPgJLK3JW+9/CodR6R6llhTUIdv
	Fwos0RzhOhH0CRNP88KMw2UT7h6+nexY81r8m/E4VpA0pelqJh/3mOtmTQACQx92rjvtK4
	U4xZE0OS9qBnhgFLFjVqFxr3Jc2/Irs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x3L9j04AskDMN5SqBp6Ad1fWgNPZR0oU+4gEtyCt2aU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787559119; v=1; x=1788163919;
 b=w70lUTIriKJh4Umi67IlxNH5A/Tyo1bTVKO3dcDO4sp3jiz5scwuXwUuWHK5z6sDhUIG0GP2
 ucKPdu0oq/siHgHqrrs+dscf6q3XKC+aoIQWP6XJ9ka5TcHeZztfRbm0JO4Pt5sinhBwjA1VVdn
 9H4TNS0xHwL2j+CLuXaB1R4s=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 9f53ebf6e40b8349;
	Mon, 24 Aug 2026 08:11:59 +0000
X-Mizu-Trace-ID: 9f53ebf6e40b8349
X-Migadu-Flow: FLOW_OUT
Date: Mon, 24 Aug 2026 16:11:51 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, kasong@tencent.com,
	baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/9] mm/mglru: suppress empty page table walks during
 aging
Message-ID: <aov8x5b4w-cnv8sI@fedora>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 034D540005
X-Rspamd-Server: rspam07
X-Stat-Signature: 5r8zn1yxded8wyxe5qs7sddre439wa3s
X-HE-Tag: 1787559120-544378
X-HE-Meta: U2FsdGVkX1+6etCU+bYf33hzTvpx97txDqP7od8wQJ9cawPtzuHfgyPZdEsYnZI6tUxODeirGscQsj26lequub0f2oKCRVe6fZye+DnaJB/3g19m//R+PzzpbcsggFFIE+Iv2B9MFPP2SRJ7T5a/r+uECrm/yEGTYlWsD3lsiTLQFF7AwKmxV31hQ74G0DPlObLrQCQVwvZvS1YdZDRfD0ue2ch1uFbhGoZnoj+EQ7alRdbk4/frOAgKfu7fcUYZUmgGi48FHbYho23eG8xPKnHwE4epW0n6cFdALbtQfdKfcidRr2ayTrTPou7bEU7ceIm6cXFa8g4wKuDesVs74Loh075FX2dCTVThjBZS5ixu7RNaJf3DpSEv1wc5vFZ2Kv69g22o2/sbuDP3tVTGDV4DQub596jPzjmEKo7WIcIkDpYUXtQ4hgRHMaENGZxJtpwgp6FUoYJ3KW5KD+Me7iX5s3u7XW0pE/RVcNnZZ1E3Cl8+QuiFBYruxm9irBIpRJhNfb9senWk+4vBpzfAcpBcK+n8mXUnvkEsuf1dmc95yXO2EezvnWUUpROdBFwPRaJo2Ka9mUCxf5awifN4CVseP4ozFE9WKFu2MVrMlXKmjHS4Ujm6k+fhvqUkxjIl0FQff+z5gjmrHRm8MkCUf5ReMN4XN8GSXrdxlAiwveGaaLnQcmiIfk3IKmEgC51FLf2wt0Bhgy13qbwwb2huGfF0ItVfnVXq2mO0fj2lO+++WEFAPPJmKxsvDRKSjIEoLVRGp87oJdwAT4nBK4sEvImhpURMgxmXgV32N5gRLY9oPcd4lZrOXh/c7m+TI6MveIJ+/VbWdjAOEUFRs+LLGSA/tbM2cAboDHWY+18hqNkQ8VFpTcJfX8UuXtwyNYFL5WCCzi8s1+thinJYm/7bAEIDjCyjRJ43S0V/B0haemsMqXxx+Fgkc2c1IJ6iQWiqmIEwCXCZvVm9vvR89d5
 v1vm4PEZ
 g6idbRi4yccUurktStTeRFzOVFyxXX4CzWR7+DEmrNRB9p9mJHvas0O4obH3XmE6mZv5mKEBNsU/JFGn4/JpF9R4sf+UA2lRJ4DBqakgERA+DCxpST/lLi+Z64EqMjalGQdhpqeZcs/aOa7I/bMkxDHUYKR2OWg/nK92aZu4Erp2mw9aUcJwthxELCygvaTmzyPSabXbjmjgKaXndMPAgdzS9E5TJm1/LOW8fO0W1tIcmZebPRJYNJDosD0zvRPX5h/+DOPpVbvK7ksP95v+kSwIHBevMZda82q4xur1Eo/ME5IFf8TTKMnq/MmeCkXqPrpoPvp7fJo3j63RBrVhJdyB8mfaCQZmZ9sKIab8+BWjKMGvvx91ZNxEYKiIA8cVHvgp5rQztqQj4uY011Qi0MZcgzrWzUZFYoOhN5yByYpZKSAMCnlHbgT/24Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/24/26 at 03:37pm, Baoquan He wrote:
> In the current MGLRU, lru_gen_use_mm() will mark an mm for all nodes at
> each context switch, so on each node aging will walk into each mm's page
> table independently. On a multi-NUMA node system, one process launched
> on one or a subset of nodes, its mm is walked by all other nodes's aging
> while finds on pages for their lruvec. This is pure waste (100% walks
              ^ s/on/no/, typo
> are empty on those other nodes)
> 
> This patch series suppresses these empty page table walks with two
> complementary mechanisms at different levels:
> 
>   - empty_map (cross-node specifc). At mm granularity, one process's mm
>     whose walk found no pages for one node's lruvec is skipped on that
>     node between re-scan passes.
> 
>   - PUD-level Bloom filter (general). One level up from the existing PMD
>     filters, it skips any 1GB PUD that had no young entries last
>     generation - namely whose 512 PMDs all failed PMD test. Cross-node
>     empty walks can prove its effect the best, but it also suppresses
>     purely code PUD inside local mms. So it reduces unnecessary walking
>     in any workload with cold areas.
> 
> The two complement each other: empty_map reduces the *number* of
> cross-node walks, the PUD-level filter reduces the *cost* of the walks
> that remain.
> 
> Measurement test (3-socket Xeon 6766E, 32 x 256MB workers pinned to node 0):
> 
>   node 1 (foreign mm walks):
>     empty_map off (PUD filter on): 3300 walks, all empty, ~1238 PTE scans/walk
>     both on:                       900 walks (-73%), ~0 PTE scans/walk
> 
>   - empty_map cuts node 1's walk count by ~73% (every 4th pass re-scans
>     to close migration/fault windows).
>   - the PUD-level filter makes the remaining walks nearly free: the 1GB
>     subtrees are skipped instead of iterating their 512 PMDs
>     (leaf_total drops from ~1238 to ~0 per walk).
>   - worker RSS is unchanged in both modes - no premature reclaim. A
>     force_scan pass confirms the local pages are found young and eligible
>     (leaf_eligible == young == 21320 on node 0) when the filters are
>     bypassed, i.e. the pages are hot and the aging walker can find them.
> 
> Performance regression test (make -j4 in a 3G memory cgroup, 4 vCPU / 8GB
> 2-NUMA VM, median of 3 runs):
> 
>                   baseline   patch    diff
>     build time     10m01s    9m41s    -3.4%
>     pgpgin        136868    138080   +0.9%
>     pgmajfault      1832      1862   +1.6%
> 
> Build time, page-in and major-fault counts are within run-to-run
> variance of a no-patch baseline - no measurable regression. The build
> time is if anything slightly lower, consistent with the suppression
> reducing reclaim overhead (fewer cross-node empty walks) during a real
> memory-pressure workload.
> 
> The test codes/scripts (numa_workload + run_test_v4.sh) are available at:
> https://github.com/baoquan-he/mglru-empty-walk-test
> 
> RFC-v1:
>   - Bloom filter helpers are named symmetrically -
>     test/update/reset_pmd_bloom_filter() alongside the PUD-level ones, and
>     the struct field filters -> pmd_filters (Barry).
> 
>   - An mm is marked empty only when its page tables were actually walked
>     (a failed mmap_read_trylock() or a stale seq is not empty), and the skip
>     is invalidated on the major page-fault and migration paths. (Sashiko)
> 
>   - Reworked the re-scan: the old shared counter across nodes got stuck at
>     the slowest node, so the skip never really engaged. Now each node re-scans
>     its empty mms every N passes on its own clock. N is the skip_empty knob
>     (default 4, proper read/write with input validation). (Sashiko)
> 
>   - Added measurement counters/tracepoint, and a kernel-build regression
>     test (no measurable impact).
> 
> 
> Baoquan He (9):
>   mm/mglru: add MM_WALK_EMPTY stats and tracepoint
>   mm/mglru: suppress cross-node empty page table walks
>   mm/mglru: add debugfs knob for the empty-walk skip threshold
>   mm/mglru: invalidate empty-walk skip on page fault and migration
>   mm/mglru: add PUD-level Bloom filter state
>   mm/mglru: refactor Bloom filter helpers for two filter levels
>   mm/mglru: skip PUD subtrees during aging
>   mm/mglru: report hot PUDs from the rmap feedback path
>   mm/mglru: count PUD subtrees skipped by the PUD-level filter
> 
>  include/linux/mm_types.h      |  22 ++++
>  include/linux/mmzone.h        |  13 ++-
>  include/trace/events/vmscan.h |  30 +++++
>  mm/huge_memory.c              |   3 +
>  mm/memory.c                   |  15 +++
>  mm/migrate.c                  |   4 +
>  mm/vmscan.c                   | 205 +++++++++++++++++++++++++++++-----
>  7 files changed, 264 insertions(+), 28 deletions(-)
> 
> 
> base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
> -- 
> 2.54.0
> 
> 


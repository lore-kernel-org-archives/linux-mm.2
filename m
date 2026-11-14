Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CB6606A337
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HqpIC1mz
Received: by kanga.kvack.org (Postfix)
	id D00036B05B1; Sat, 14 Nov 2026 13:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7756B05B2; Sat, 14 Nov 2026 13:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15036B05B5; Sat, 14 Nov 2026 13:11:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8266B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:11:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FBEF40446
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:11:55 +0000 (UTC)
X-FDA: 85434518190.07.B431531
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 127B34000D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:11:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HqpIC1mz;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794679913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Z6kVyng+edrJn16r9HBEkiQxk4z+4fLliDv7QvLeZ4=;
	b=bibiHwCBJJaSt2i+tmgLxh2p2Y91OFLOex77QgWyBoVSuWd88ReaB6RsGdoI/mO+O6T20u
	mFDQehRT3tTNBzr+QP+0t/TyAjAgTV5oHER3g4xarknXN8nO1o7u8Dj+0+tUm8GCIVCeEm
	qS5me2iNshgiPwxWsQLjcQYGNEEV3Lk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HqpIC1mz;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794679913;
	b=2xsnsuWRwpZDbvQT62Aqs9UNJKusOhQvF2f7bpiq4EY7RJquvSkY6AUEQNmEWQ1PD+fs5r
	UFCB3hCyT3rldT2XYPogxDB586kuD3XMb9WMy9o845LBvt3xkiYMkioSQc6Qx5oct61lqW
	7GHRKqBqBw/ijoBOwkensXQp9SsqYe4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07C74143D;
	Sat, 14 Nov 2026 10:11:49 -0800 (PST)
Received: from [10.163.159.227] (unknown [10.163.159.227])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9B623F632;
	Sat, 14 Nov 2026 10:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794679912; bh=xDsiiU8GWWJ/pQq9t2dTAxHzPfy05fd8pgLnjvQ2Ib0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HqpIC1mzY1Ev+xlyk5jniXI7ipxiEJBO4kOkrFV+Zq4gzs3MU4V/PxGnAfB/i4Uxa
	 zWpy/kvkAV3JOoGbIDprum2RzcPRavJKyTCU9yjQfKymhqpb+E2PfOiQ3iCNP5/g+1
	 XHWlussL2t485cJJ1CNvYzY3uR8fYEnx8a2Mmk9U=
Message-ID: <28a340e0-76f5-416f-a74e-f74f4a2c2d36@arm.com>
Date: Sat, 14 Nov 2026 23:41:44 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: sample empty pageblocks again from a
 random offset
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261104101747.2485913-1-kas@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261104101747.2485913-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g45tcdj7r8a4oa8w71f194oox38bn3k4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 127B34000D
X-HE-Tag: 1794679912-7556
X-HE-Meta: U2FsdGVkX19fXx9xeIsoDssVHVcDK5dhNytLQTl6oT44n+/wijndX5jxG9M9AiS3MaHTDmM+nNQtqZyMydSeOm7iob7544sJ1q6sq4ziyhIcykFxLmJfae1jhIoGnMVmZ/JKBCzbBjUCl9A63t6wYxgndrPsCdlj6w+9Y2kWfxfFxfZVZlehneJMdFMeDJOt3t8D21dOiJ051rsrEkM4n++JT9bEBNPIDuylltUehC5Sfu3BspoTx0RTwZFkXH6lEc/DlSXeqOnjTPH0vhTe1xQb70w7s2vF6WNEr09GtE3L5FFResFdY7sc/Q9NQ1WuGWNoUXt8ntCw/j8cwMYc/N/pdeijkKNuw5TYxgxwbm3TQ27RFXn/K/MFt2HE2InK4KfnS4ifP8V9vrb3OPL/3szBjKzENXw1lCaxyNsM/rE17pLgarPvJ7YatSsWrQGY9Vka/VvtV2QMbuPranMCs/d2H0S5A33j2bhl1kGS+O1j7DxaalVEUjtkqAB2E05Wd2H3RkAxnM/rZbV2xW0uMbZdXoRK3LvzzRBbto230/2h8e8cAJddUsqIPvCmweei/fsDt5Q8jjajRzI0VzPEwdboR66eYCkzB4f+gol6sdE7Xfcy8LzbjAep9h+a0+QxXW58pdfuBM8fYoahTjQY/QPlYISDhfhlgERPV4ooFM6K3r4PamcwRy/ueQx9/+uJIJrY+u353E3Q3NIEXPDBMsxtmOCHpzUFG0s8uj0Ah8T8uACnocFdc3Y9nhwN+I6r/vdOfWdcKR46E7AtVcTxGv6LyplC+fNZnT6MfsjeUoPsFb/Rpweuw/5xDQgg7KdNBD3CnG+E8cSUfqFuCCxD8T2FcI1IMwXrgXh0Aur5i6odaSyI7JvUIizu9ccJ3Wwely7hPd8/T7G2BEcZ588J1xA2Sjnwz5MBnofk/6xWShxpLuGhpy5A686IzqfyhYq39tsk/9bym/WvhyaA44s
 6zHeUfl6
 PvHyrv0dIWco7QlIgFLpOrDbbg2UbKTm12arrtI7ev9kziOko5KBILJMQYH+eMIhZ3JJNw+tWKqY9XIsEK3nDrjSDLKE3foDaU2uZNAS0K42xq+aOyx94BF/CzHWKY8pEHYNjfQRFiVDGvMMHhM+k04PPf90n0WvtT8JIONqQrIBbdrT6vwHrT9MCH+E/t60bLaxqevCvPzR63rb0AprD9OgH6z/9n4PcGHERJ77UxrksaPvbWNmQgyPMobpx8rZKqg4I7csC0JrYROllY1rUcaMxw8247Lk3kaSB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 04/11/26 3:47 pm, Kiryl Shutsemau (Meta) wrote:
> Once the free scanner finds pageblocks with nothing to isolate, it checks
> only every stride-th pfn of the next block.  The stride doubles with each
> empty block, up to COMPACT_CLUSTER_MAX, and async compaction starts at
> the maximum.  A block that gives nothing is marked skip, and the cached
> free pfn moves below it.
> 
> The samples sit on a fixed power-of-two grid and alias with any layout
> that repeats at a power of two: when the free pages sit off the grid,
> every sample misses them.  With one free page in eight, all at
> pfn % 8 == 4, a stride of eight or more sees no free page at all.  The
> free scanner runs into the migrate scanner, and compaction fails with
> most of the free memory in the zone untouched.
> 
> Tasks then stall in direct reclaim, and huge page faults fall back to
> small pages, while gigabytes of memory are free.
> 
> Real memory is rarely this regular; the test below builds such a layout

That is where it gets hairy: will this be observable in real workloads?

Suppose stride is 32 and the pageblock has 100 non-free pages. What is
the probability that 512 slots are filled with 100 objects such that
x = 0 (mod 32) is filled? It is

C(496, 84) / C(512, 100) = 1.6 * 10^(-12), very improbable.

So the chance you have a sparse block and you are missing out by not
looking at other offsets is very low.

If stride = 32 and #objects = 400, the probability comes out to be
1.8%.

Keeping #objects fixed, lowering the stride lowers the probability
exponentially. (This is relevant since we start with lower strides)

On the other hand, what happens if you are scanning over fully filled
memory? (there is no way to tell whether a pageblock is sparse)
You are going to repeat the scans unnecessarily.

IOW I think the probability this patch is going to have a downside is
more than that of upside.


> on purpose.  On a 32G VM it:
> 
>   1. fills memory with anonymous pages and pins one of them in every
>      pageblock;
>   2. frees one page in eight, 3.6G in total;
>   3. creates a million files on tmpfs with defrag_mode=1.
> 
> Direct reclaim entries (allocstall) and the time to create the files,
> 10 runs each:
> 
>                            allocstall
>     free pages at          median    max      time, s
>     pfn % 8 == 0                0      0      4.6-4.8
>     pfn % 8 == 4               86   1544      4.8-5.6
>     pfn % 8 == 4, patched       0      1      4.6-4.8
> 
> Sparse layouts hit a milder form of the same miss: at async compaction's
> stride, a block with only a few scattered free pages usually yields
> nothing.
> 
> Keep the aligned samples: the head of a free page of the stride's size or
> larger is visible only there.  When they find nothing, sample the block
> once more from a random offset.  A random offset is the usual cure for
> aliasing: no fixed layout lines up with it, and one free page in eight is
> found again within about eight blocks on average.
> 
> The second pass at most doubles the samples taken from an empty block.
> Pages scanned by the free scanner stay within run-to-run noise, both in
> the test above and in an mTHP fault benchmark.
> 
> Fixes: 4fca9730c51d ("mm, compaction: sample pageblocks for free pages")
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/compaction.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f1b2060eb201..475b3a645122 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -23,6 +23,7 @@
>  #include <linux/freezer.h>
>  #include <linux/page_owner.h>
>  #include <linux/psi.h>
> +#include <linux/random.h>
>  #include <linux/cpuset.h>
>  #include "page_alloc.h"
>  #include "internal.h"
> @@ -1797,6 +1798,26 @@ static void isolate_freepages(struct compact_control *cc)
>  		nr_isolated = isolate_freepages_block(cc, &isolate_start_pfn,
>  					block_end_pfn, cc->freepages, stride, false);
>  
> +		/*
> +		 * Free pages of the stride's size or larger start on a sample,
> +		 * but order-0 free pages spaced at a power of two can all fall
> +		 * between the samples. Sample a block that gave nothing again
> +		 * from a random offset.
> +		 */
> +		if (!nr_isolated && stride > 1 &&
> +		    isolate_start_pfn == block_end_pfn) {
> +			unsigned long pfn = block_start_pfn + 1 +
> +					    get_random_u32_below(stride - 1);
> +
> +			/* The block can be shorter than the stride */
> +			if (pfn < block_end_pfn) {
> +				nr_isolated = isolate_freepages_block(cc, &pfn,
> +						block_end_pfn, cc->freepages,
> +						stride, false);
> +				isolate_start_pfn = pfn;
> +			}
> +		}
> +
>  		/* Update the skip hint if the full pageblock was scanned */
>  		if (isolate_start_pfn == block_end_pfn)
>  			update_pageblock_skip(cc, page, block_start_pfn -
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4



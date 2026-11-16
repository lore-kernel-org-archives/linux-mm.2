Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05062606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LwJ29DC/
Received: by kanga.kvack.org (Postfix)
	id 263C56B05B2; Mon, 16 Nov 2026 03:38:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214586B05B3; Mon, 16 Nov 2026 03:38:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104486B05B4; Mon, 16 Nov 2026 03:38:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA8EF6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:38:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EF731A04FC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:38:36 +0000 (UTC)
X-FDA: 85440331032.04.6238EF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8AF371A0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:38:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LwJ29DC/";
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794818314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YwQjPlE5C9xr3ZrljBav55IFe0LmvzgE7fM0ikoKYZU=;
	b=ZytbxcrtSTCGC2b8MU+UPiL1MMgDN6RUc0oAoN/rgYNwvlwh1I7FwoZt6bj3OAzLEnTKCm
	cm/swohWd4vBEoQQnCS1+pcrO4DDWPr84AsKYaFGa5ZDWNUJD6YZiWeRNgyE6GUvobVJG1
	CBKBbnhUEgU55nF08sB6QjiwcNmEGs4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794818314;
	b=c0IY4wwJTA5ADPIBT77hBcd1qKwMW96YOC5sEu8jACPTY4JYnxOzUlQ0paczsIPfMZeFwk
	FsCwfB7E5vndy/0eb5tEGkDHyDYtGih/okSJyVafbqQoY6r+EtQU7619I9piIzd6QtPlJa
	9/lUti6usg2uptSOXu+dLQnonFVzs9I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LwJ29DC/";
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCB3340B28;
	Mon, 16 Nov 2026 08:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1E71F000C4;
	Mon, 16 Nov 2026 08:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794818313;
	bh=YwQjPlE5C9xr3ZrljBav55IFe0LmvzgE7fM0ikoKYZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LwJ29DC/lf644LHL68blpNQ70huLnHF0+Rl5hrrQBxHPjQodrNL/sePSpa/8y/OuR
	 B1k9NQBK+yE54apQ+9ViglwcMZ5VbY9Fqqp4dFxRwqQkHXOX5nVaOZXxv7MiYdqWDa
	 O2KZP+JDM6V5hJCXpfvn2b1WLJZraH/c5uvOWT+9dM2yUzT7YnhU4+ZBBJPpxqbW/P
	 F3szZ9hQpxWosw1naW2pWU61OffrDTugQkCv7SfHQfz5e1Sf/XOohNKZkcltu/e4ct
	 pvIdMXFwUHy6Yi2KyoC01HSNFUEr6GOmHXpk10rKhbDiCmO+NAOxpFjZc0U5icDxkD
	 3Ao6XVCcot2QA==
Message-ID: <d92f9b62-5d2a-44af-908a-ef80fc8e1766@kernel.org>
Date: Mon, 16 Nov 2026 09:38:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: sample empty pageblocks again from a
 random offset
To: Dev Jain <dev.jain@arm.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261104101747.2485913-1-kas@kernel.org>
 <28a340e0-76f5-416f-a74e-f74f4a2c2d36@arm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <28a340e0-76f5-416f-a74e-f74f4a2c2d36@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: m9ezieedry41n3jemxy473sz1fbuz9cq
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 8AF371A0006
X-Rspam-User: 
X-HE-Tag: 1794818314-589146
X-HE-Meta: U2FsdGVkX1/CXHlh0GtEu57fgds7HeXD0joVSDa69NXGL3+Y32EWc4dX7Adpdm3UQq0iYWwyfmc8tMaWllTMQupvVn/fwv6HypHy3HPLNAF1zWGkRpEsRNOLkCPTpdass5qWZTDbkM1hg9P1AHzzKRZa0ZEm4KXNO0WywUfkl80g9eWsM+kLQFQCQFSnJ4Z8/tZ3j6nWgFbldXl6CFa2pXx56JnZBvGRiwn4I9wklnqths+KweelHDHpRVs5C/QHLssWXnmC5k41L+UhKwbmXQZl5h1wL8e/gRO0sfN/LFPe9h2IHi6TbvwYTc3YTLJJwLDy2IS3heyVQqKX57fxzsCk92NfyKQorIW2HdKi6drAb13aW5e281Zl+xHcgUoNhNDiZYDasq8ZBeC+sk6M3CWmbPnUZ5ngA5z8Uy3yengunIaYdqSo6y5PpB9sdVtHPYr8ieAAcRA48ESpSQEy1SS+OCPg9CHJdWgbZYUG9Wd0ulsTuIzLFxBRrf2bKV/PGIYM7EzxYUVRRE2J/9n1Z9IhWS31YvZ6bG9U4EfKrClewfyPMG//Mt0a97ux+i3UI+4AIE+5t3mz2ebg2xkk7iIuJqOIZYXLIXe4xMuSxG6vliIaJ9YAv2iFolvhiumNvDUZn7avTmuipQuZhikvIPIR6bbxnmOqX8VvFxDl0CWj+9yNMeIq04tRoYqdA33CKPjb0rQDTtG/bgll6nP/ZXMvJw1YU0zgdRXxsaYqrjTX717R4gzLgZ4GTr3csFAU+W4SfRhthKMALP8tJNbanobbH7gglil5IowdGJX3p9BQUZb/Z7ORR1CVl/0KRzOENlwbhGnBxudZl6l9iKn6dH1xhDq8XhCqHZhU5SZHW0bSkaE5kBVsbfk7RzgRFmSEP/8Tmm0Nq+dQ1jrODid7siLxlRTWHcFqEUwkePW0yP/p8f4UsL2Hp1R69GhFHy+CLQ+B1lUYuA/Gho68tdu
 HLPGYOLv
 Qq74nYg8y1B0SqTfI4moKCul2hPnpK3Z6Ob7czwJ/RozU94xwcLf6b0BfjgXzV4LuGu+xoDdZCg9j1MVGP8npsI8CLve4+yb4e8iNcOCBtH6Y8PO+nWzmKsrlSRQLuvL2qpYbVQyKbkgo39ModIT+uHfit91rpCzJKeALSu35njN7dMauhUiB+9eHgY7iYrC8IgzWa21Sz5H4+3tCLfutW+DkPer4bYpTSuMrQv1V0FpDBsI+01/sLlSLyY4XbHw5TFYYqNpxY+eqWG/XHekFNXFIxua82AZA+YGV2RyY+N4RlRqMUn7ldXERyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 19:11, Dev Jain wrote:
> 
> 
> On 04/11/26 3:47 pm, Kiryl Shutsemau (Meta) wrote:
>> Once the free scanner finds pageblocks with nothing to isolate, it checks
>> only every stride-th pfn of the next block.  The stride doubles with each
>> empty block, up to COMPACT_CLUSTER_MAX, and async compaction starts at
>> the maximum.  A block that gives nothing is marked skip, and the cached
>> free pfn moves below it.
>> 
>> The samples sit on a fixed power-of-two grid and alias with any layout
>> that repeats at a power of two: when the free pages sit off the grid,
>> every sample misses them.  With one free page in eight, all at
>> pfn % 8 == 4, a stride of eight or more sees no free page at all.  The
>> free scanner runs into the migrate scanner, and compaction fails with
>> most of the free memory in the zone untouched.
>> 
>> Tasks then stall in direct reclaim, and huge page faults fall back to
>> small pages, while gigabytes of memory are free.
>> 
>> Real memory is rarely this regular; the test below builds such a layout
> 
> That is where it gets hairy: will this be observable in real workloads?
> 
> Suppose stride is 32 and the pageblock has 100 non-free pages. What is
> the probability that 512 slots are filled with 100 objects such that
> x = 0 (mod 32) is filled? It is
> 
> C(496, 84) / C(512, 100) = 1.6 * 10^(-12), very improbable.
> 
> So the chance you have a sparse block and you are missing out by not
> looking at other offsets is very low.
> 
> If stride = 32 and #objects = 400, the probability comes out to be
> 1.8%.
> 
> Keeping #objects fixed, lowering the stride lowers the probability
> exponentially. (This is relevant since we start with lower strides)
> 
> On the other hand, what happens if you are scanning over fully filled
> memory? (there is no way to tell whether a pageblock is sparse)
> You are going to repeat the scans unnecessarily.
> 
> IOW I think the probability this patch is going to have a downside is
> more than that of upside.

Agreed. This seems to all be based on a hypothetical scenario, only
constructed artificially to demonstrate it. A real-life motivation is needed.

> 
>> on purpose.  On a 32G VM it:
>> 
>>   1. fills memory with anonymous pages and pins one of them in every
>>      pageblock;
>>   2. frees one page in eight, 3.6G in total;
>>   3. creates a million files on tmpfs with defrag_mode=1.
>> 
>> Direct reclaim entries (allocstall) and the time to create the files,
>> 10 runs each:
>> 
>>                            allocstall
>>     free pages at          median    max      time, s
>>     pfn % 8 == 0                0      0      4.6-4.8
>>     pfn % 8 == 4               86   1544      4.8-5.6
>>     pfn % 8 == 4, patched       0      1      4.6-4.8
>> 
>> Sparse layouts hit a milder form of the same miss: at async compaction's
>> stride, a block with only a few scattered free pages usually yields
>> nothing.
>> 
>> Keep the aligned samples: the head of a free page of the stride's size or
>> larger is visible only there.  When they find nothing, sample the block
>> once more from a random offset.  A random offset is the usual cure for
>> aliasing: no fixed layout lines up with it, and one free page in eight is
>> found again within about eight blocks on average.
>> 
>> The second pass at most doubles the samples taken from an empty block.
>> Pages scanned by the free scanner stay within run-to-run noise, both in
>> the test above and in an mTHP fault benchmark.
>> 
>> Fixes: 4fca9730c51d ("mm, compaction: sample pageblocks for free pages")
>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> ---
>>  mm/compaction.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>> 
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index f1b2060eb201..475b3a645122 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/freezer.h>
>>  #include <linux/page_owner.h>
>>  #include <linux/psi.h>
>> +#include <linux/random.h>
>>  #include <linux/cpuset.h>
>>  #include "page_alloc.h"
>>  #include "internal.h"
>> @@ -1797,6 +1798,26 @@ static void isolate_freepages(struct compact_control *cc)
>>  		nr_isolated = isolate_freepages_block(cc, &isolate_start_pfn,
>>  					block_end_pfn, cc->freepages, stride, false);
>>  
>> +		/*
>> +		 * Free pages of the stride's size or larger start on a sample,
>> +		 * but order-0 free pages spaced at a power of two can all fall
>> +		 * between the samples. Sample a block that gave nothing again
>> +		 * from a random offset.
>> +		 */
>> +		if (!nr_isolated && stride > 1 &&
>> +		    isolate_start_pfn == block_end_pfn) {
>> +			unsigned long pfn = block_start_pfn + 1 +
>> +					    get_random_u32_below(stride - 1);
>> +
>> +			/* The block can be shorter than the stride */
>> +			if (pfn < block_end_pfn) {
>> +				nr_isolated = isolate_freepages_block(cc, &pfn,
>> +						block_end_pfn, cc->freepages,
>> +						stride, false);
>> +				isolate_start_pfn = pfn;
>> +			}
>> +		}
>> +
>>  		/* Update the skip hint if the full pageblock was scanned */
>>  		if (isolate_start_pfn == block_end_pfn)
>>  			update_pageblock_skip(cc, page, block_start_pfn -
>> 
>> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> 



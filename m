Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A70DF9EDD1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 13:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B9E6B0088; Wed, 22 Apr 2026 09:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C866B008A; Wed, 22 Apr 2026 09:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51D06B008C; Wed, 22 Apr 2026 09:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A79C96B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:42:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA634137532
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:42:58 +0000 (UTC)
X-FDA: 84686307636.30.1374D2E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1B9741A0007
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:42:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dDlHpjOo;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776865377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHfSybB/9Le2Cbiog8Xe3gYh1JbzR5xtcBcNtHIoo2M=;
	b=4QXuIJd2g0qKdtNCOxVqK5sFFm2LeJ5GnxD6FzJxSvid1PzopDY+QyEAHbVJ/MENxhXfpo
	fuQjn65N7YOAKW053gw/cO6dAEBQltCinP7/gs+loU158PGc44qWsnIat9yNOg4LflbCY0
	NT3eo3l7p2SPm+LsQPiGPWWJrz+VTpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776865377; a=rsa-sha256;
	cv=none;
	b=pHnOUJgcpPdqDz/5Keng/LzbsSMkRfpzC9ZiZQ9gV8pQgCQQtrFKOjR+07hjqetwqvOFRA
	Xm6OGaV8oE16ShDWsGl6F1/AxhM5Gtpu9zdiF2mCmEVGS/FJ4z4grrnCUjfAwbrHgs7OuJ
	AMB+WirizZ3R73OqmzXiDtqM+chHqk0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dDlHpjOo;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7316C22D9;
	Wed, 22 Apr 2026 06:42:50 -0700 (PDT)
Received: from [10.57.89.34] (unknown [10.57.89.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDBC23F836;
	Wed, 22 Apr 2026 06:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776865376; bh=Vx64GZKttVMr0fTXGUstSKBpCcNADw/xlPJ3ED67K7s=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=dDlHpjOoHba0kXrIfjxHqbOUa3sTKw06GESEAJ79dMzP3hxiA+2YYw2vDGTUtfPPM
	 kQ9M9hNMP6d51DYOKvtQ4y+N/oPhVDpNERO1kDpUrPRx+wsfKWje1sOFiqcuVl/b0c
	 GnwQG4aiN5Wk/IiAj+rPtrBuyWwaCjEMLFjw7oPs=
Message-ID: <0a8ba718-7ff2-4876-9154-9dd5d404df3e@arm.com>
Date: Wed, 22 Apr 2026 14:42:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
Content-Language: en-GB
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
References: <20260401101634.2868165-1-usama.anjum@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260401101634.2868165-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 56444mnoy5rdskzi457i5b8fwapmsibf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B9741A0007
X-Rspam-User: 
X-HE-Tag: 1776865376-405897
X-HE-Meta: U2FsdGVkX1/LBgNo7uGkcv6GbawlwzBxlMfSYihgAkrhKi/740a6emSQmCbetP77JoJIlmKR29cPl7KRJT5uFWWC1JLMmZ+E6lFbPch7WhZghAAFv5vyw6FQon3k74bXlDGUlpk9az82FiWWN5bQ/ZSToO08fWNw73vbT+pl7bCoPOE3jlLsEys59XqP7fuzrP7ajgydMrbLEnHHR6XIs64o3/FY/3o0vny5CjwIIsYANV3GEcskAOCgfskkp4wusRuBsSqrkIFHGMlpcLtchF7wJ726LGn9bcYsYTSRag+hzUJOpaDy5JObWVCBD7lJuhO3mFNkc0x8nAaZaljICHVVYs9UwRW8vcQh+y1AVQBuOpRNqMLg6nv31p9RYuFqfOcT4UHngJpEjLI8hcNwVDQu77cVKppdnOStrlAKSVIWIpFCrTaXmzJVm9YBh+QR+JcBvgjcuEb28IviHgpdFzuSxwaJi1gd9QhYHqaOQ7mt7i/IEPV8vEAGjd54kP6N010KH8SkR0tYgdVUbuXYBQF+SVVvwzsG2ATguMQ7wI639OpzPeOGKOWo4cgSYFoE3LEIkXVdgUGrV5dqrMkxogwnlgQbL0PyLnFHnQAAa4OL1ne0kvTyV2UADq4DpD8dhnBA7/hv326aEM0ZHRHy9YCnzlX3R1fXzU426mt5WStD3Oc9sRF4KN/Wgju7BMhH10QSO9dnWQfozuJWuXMZWaHMv+j6OEe3DDKWLvkepBa+IeKeLDHAcTLywlUpXGucTV7xVnjr4BtkLRDIqTibezy/BQjnra9lLOqq48dgPz0n1RhOQ1y+Cs/MArow5zY4L2Wqya4O2CVntDPFb0/rOGGj4hzYZ9FWCsXQ+YBpDoKhvZyowu8oVRU5gFyLlCeioquIHo6a3a2iH8zcLufdAH085pi3II83jKcT2+08PZGwFN+DtaICSlWLpjo5JtUk/iEIekXZPUZ5+8PQPeG
 IJ06aZXw
 FyvG1AxtJv2fu4Ibvh3LQ5DrZLSD8r5gHYbj9C+QUXZJesMct8vwFQUZjBAmCsSu6KsyQqVVZTxxfw8aj1Qctl2GAnPkkReM2RaOBRqeGNLfTECvJTvXuYCCJL4d+JS6iQDeaGFBvq5LA7vrmZtc2xCNYq+uLxMJQ76wrhXkLYH8XPWQxVarV+ZpOezecs71axBpYa05UXE33qCDchNuqm47AGccyOKly2DR6dm01FfwUFCiWyyAbWdX+S9gFnJzfJA3Ut8XSgDRAqNol0+o6Bwf2DV/qjlKdHGSPN7pE6JDzpn8kKno83A1g/Jd8BQIoX5CHjAvlLlmROHKVXEkqsuscmPjrHYKMwUin
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Small nudge on this series; I believe it has all appropriate A-b/R-b tags and no
outstanding actions. Is it ready to go into mm-new?

Thanks,
Ryan


On 01/04/2026 11:16, Muhammad Usama Anjum wrote:
> Hi All,
> 
> A recent change to vmalloc caused some performance benchmark regressions (see
> [1]). I'm attempting to fix that (and at the same time significantly improve
> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.
> 
> At the same time I observed that free_contig_range() was essentially doing the
> same thing as vfree() so I've fixed it there too. While at it, optimize the
> __free_contig_frozen_range() as well.
> 
> Check that the contiguous range falls in the same section. If they aren't enabled,
> the if conditions get optimized out by the compiler as memdesc_section() returns 0.
> See num_pages_contiguous() for more details about it.
> 
> [1] https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com
> 
> v6.18      - Before the patch causing regression was added
> mm-new     - current latest code
> this series - v2 series of these patches
> 
> (>0 is faster, <0 is slower, (R)/(I) = statistically significant
> Regression/Improvement)
> 
> v6.18 vs mm-new
> +-----------------+----------------------------------------------------------+-------------------+-------------+
> | Benchmark       | Result Class                                             |   v6.18    (base) |    mm-new   |
> +=================+==========================================================+===================+=============+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |         653643.33 | (R) -50.92% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         366167.33 | (R) -11.96% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         489484.00 | (R) -35.21% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1011250.33 | (R) -36.45% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1086812.33 | (R) -31.83% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |         657940.00 | (R) -38.62% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |         765422.00 | (R) -24.84% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        2468585.00 | (R) -37.83% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        2815758.33 | (R) -26.32% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        4851969.00 | (R) -37.76% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        4496257.33 | (R) -31.15% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         570605.00 |      -8.97% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         500866.00 |      -5.88% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         499733.00 |      -6.95% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        5266237.67 | (R) -40.19% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         490284.00 |      -2.10% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |         850986.33 | (R) -48.03% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        2712106.00 | (R) -40.48% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         111151.33 |       3.52% |
> +-----------------+----------------------------------------------------------+-------------------+-------------+
> 
> v6.18 vs mm-new with patches
> +-----------------+----------------------------------------------------------+-------------------+--------------+
> | Benchmark       | Result Class                                             |   v6.18 (base)    |  this series |
> +=================+==========================================================+===================+==============+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |         653643.33 |      -14.02% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         366167.33 |       -7.23% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         489484.00 |       -1.57% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1011250.33 |        1.57% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1086812.33 |   (I) 15.75% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |         657940.00 |    (I) 9.05% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |         765422.00 |   (I) 38.45% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        2468585.00 |   (I) 12.56% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        2815758.33 |   (I) 38.61% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        4851969.00 |   (I) 13.43% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        4496257.33 |   (I) 49.21% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         570605.00 |       -8.47% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         500866.00 |       -8.17% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         499733.00 |       -5.54% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        5266237.67 |    (I) 4.63% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         490284.00 |        1.53% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |         850986.33 |       -0.00% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        2712106.00 |        1.22% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         111151.33 |    (I) 4.98% |
> +-----------------+----------------------------------------------------------+-------------------+--------------+
> 
> mm-new vs vmalloc_2 results are in 2/3 patch.
> 
> So this series is mitigating the regression on average as results show -14% to 49% improvement.
> 
> Thanks,
> Muhammad Usama Anjum
> 
> ---
> Changes since v5:
> - Patch 1: Move page_to_pfn() outside the loop free_prepared_contig_range()
> - Patch 2: Change subject of the patch
> Changes since v4: (summary)
> - Patch 1: move can_free initialization inside the loop
> - Patch 1: Use pfn_to_page() for each pfn instead of page++
> - Patch 2: Use num_pages_contiguous() instead of raw loop
> 
> Chagnes since v3: (summary)
> - Introduce __free_contig_range_common() in first patch  and use it in
>   3rd patch as well
> - Cosmetic changes related to comments and kerneldoc
> 
> Changes since v2: (summary)
> - Patch 1 and 3:  Rework the loop to check for memory sections
> - Patch 2: Rework by removing the BUG on and add helper free_pages_bulk()
> 
> Changes since v1:
> - Update description
> - Rebase on mm-new and rerun benchmarks/tests
> - Patch 1: move FPI_PREPARED check and add todo
> - Patch 2: Rework catering newer changes in vfree()
> - New Patch 3: optimizes __free_contig_frozen_range()
> 
> Muhammad Usama Anjum (1):
>   mm/page_alloc: Optimize __free_contig_frozen_range()
> 
> Ryan Roberts (2):
>   mm/page_alloc: Optimize free_contig_range()
>   vmalloc: Optimize vfree with free_pages_bulk()
> 
>  include/linux/gfp.h |   4 ++
>  mm/page_alloc.c     | 143 ++++++++++++++++++++++++++++++++++++++++++--
>  mm/vmalloc.c        |  16 ++---
>  3 files changed, 146 insertions(+), 17 deletions(-)
> 



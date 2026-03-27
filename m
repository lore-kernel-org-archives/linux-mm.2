Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D3210ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A6C6B0092; Fri, 27 Mar 2026 08:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2ABC6B0095; Fri, 27 Mar 2026 08:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40EC6B0096; Fri, 27 Mar 2026 08:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD6D6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:57:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED3BF5E8C0
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:57:37 +0000 (UTC)
X-FDA: 84591844554.24.EF45A45
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 347CB4000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:57:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LrA6sDVL;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774616256; a=rsa-sha256;
	cv=none;
	b=EgeneoYHLViVHxXF0SQD29OdQOLmjaKTwc6/7AwXm+gShaYU8GcKay/E8xzYDDIpV9tJCJ
	t72N3SIp86OLfaDQphrEkREIPBDRHnr5ERh0ce0ONN9GHxV8n/dyRTUcNw4mnBbwkIZUiM
	DcG3lnyPJFO0gASPvTrFQt4G9EIAJQ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774616256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JM3UH8E5GVBC08qdtZHDGrqKsMCaXsASzh9TuTty3Vs=;
	b=X2T8wIYjI19B3G7NMoQW9wFG833CmSGrcEVXpJWy1ORyM5+F55L1quomvs/iEk08xVoz6u
	JritiE6CuQ39uFGGTGEJHtL29ZTf3YpUM1egzALY43c66YlYXWFfkabxpT254VMgr3cj1o
	h4V0H9aPWZJ33BUwnrj8rLdjm4F8WIM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LrA6sDVL;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24DA735A1;
	Fri, 27 Mar 2026 05:57:29 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2EEED3F905;
	Fri, 27 Mar 2026 05:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774616255; bh=fW9VknbcGagUXC5K7RwsOauZC9Z8jFdk0hGXN7TqvDA=;
	h=From:To:Cc:Subject:Date:From;
	b=LrA6sDVL8cZ0Ug0UaZi4iHA3NFxZiG0KHfUGBhfurgMrYpxDl47p1agpS4+1ZxYIJ
	 t882IKY9Ql2OTRk0ncwCtXyg0z10wZCJnCK2Mmys4KSo494eY+ohUJAVvO2rLR/Ut0
	 KPhmQQ6E+BOuDK+kxZOPPdy5e48imE0gNrwrn8BA=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v4 0/3] mm: Free contiguous order-0 pages efficiently
Date: Fri, 27 Mar 2026 12:57:12 +0000
Message-ID: <20260327125720.2270651-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 347CB4000B
X-Stat-Signature: hezxoum8ogyrpdymuhzxgzs58r6pggai
X-HE-Tag: 1774616256-220425
X-HE-Meta: U2FsdGVkX18kPXQwNvuUJui5Xhq6gwUYiK1rJmgk6zT8V1/FtX3K+X4QGmW4tmVhpRH/75rRqRK6Yvj/brtRKJwBexzVCh+Fct02ZC3D5uBA8urWV8YpcKTVH/lZZ5QtJAoq4JksIIV6dKIMktiOgHAy9dfDBFNrUmN4yZL7+amcHQjQKrY4C+2djVHD8gRewO4Hvliejz7qUu/VyDJwOAtbqvyc/lFV1y4UsF1lWiEDtGh0QgySVqEt6jGrvl13s7odpCi0e3Tur0v1el0UM3GZfrouGC/r9G1YccFQ1x41JXBMYwIRLnemfrgCjbe5pDxNTsP1Uj5adKYUS+VkvVz7b6lFyGAsMhamDwa+2jctaIURnBScwH/alIBY/G5oC6IJW4G4UarOkESrGrXJtg3tZwp8K0OX4giWiQlBvDmU1VSmfzC/9RQ2b04aWim6g7elTeAz87T0UnGjWrKOdFE70DpnNywG+5aWsh31SXoutBdSxi4uS5/sCKeOIMN8DH08Qymft+CarqLxb1K6RS/awK4EsTjmZAjcswVv9G7sXh6DvlGPVmkrzw23cHS/enqkVUm6ikkQEdX6G/8M5rlCshsHkNxVrF04PApqkJMO2PXt1x1gfSh+9JgUgL1Nzessklase+c99IAhvkEjI5bNgJMQdRqGOtDv4VSaH2wEzMpaBgeRHHXQ+SM6pEZYxxtTV2foNQiOANpZVRNmSPNmeIQy386/V/qKocVENouagEc5DlcK22JyV23v/j7I5l3T60ZCVLaz6FZQ4HBFnDEH19aZu0wejgjooMNWiP7ocAlRCEzJU9rF/VHi/zWXQlu3XWUTpBNhcQOql7ifnYcR40TEXSZNBp/7rxI45Yu9Tv8aue70nEP88VIxJ3hzv/aorsmL2TT40hncxAG/t+63nE8NKzBK0ERaxW3/rjt+hF9imhLcTmBC5cgfKmPeAVr5szMiB0TYU0TPmtv
 YSxZawFF
 a32DWS55iVar3u7DfsByQY6dA8EQLsXh6NPq3J9LHPBp7u7w47JJaTOAfvwFho8kNfkl3R7iIyuFdBaHM1B6LFhLDzln/khO6M/NhNa2g4+uRubgdHG1XU0FZbkB+yCJUoIlVQRLCLwUhvqVD8tyQMr1Oo2DuM9qNo6t2hHhuxRZNtvshYWd95AFomXeoKz4fSMm3P8TymFTZknOpS6fivu95veJB+LWvmbXN3pM6SUG15GaFuVIfSmcHIgDiXzaukpJ/l4pglZ6tT39PfdFqUPc9Q+0l9bQIuud+rZhLesKbg8k4a07r2wpuhjT7EBtEh+pvKX7DjVSndRgF4vsZVOqnQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

A recent change to vmalloc caused some performance benchmark regressions (see
[1]). I'm attempting to fix that (and at the same time significantly improve
beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.

At the same time I observed that free_contig_range() was essentially doing the
same thing as vfree() so I've fixed it there too. While at it, optimize the
__free_contig_frozen_range() as well.

Check that the contiguous range falls in the same section. If they aren't enabled,
the if conditions get optimized out by the compiler as memdesc_section() returns 0.
See num_pages_contiguous() for more details about it.

[1] https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com

v6.18      - Before the patch causing regression was added
mm-new     - current latest code
this series - v2 series of these patches

(>0 is faster, <0 is slower, (R)/(I) = statistically significant
Regression/Improvement)

v6.18 vs mm-new
+-----------------+----------------------------------------------------------+-------------------+-------------+
| Benchmark       | Result Class                                             |   v6.18    (base) |    mm-new   |
+=================+==========================================================+===================+=============+
| micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |         653643.33 | (R) -50.92% |
|                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         366167.33 | (R) -11.96% |
|                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         489484.00 | (R) -35.21% |
|                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1011250.33 | (R) -36.45% |
|                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1086812.33 | (R) -31.83% |
|                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |         657940.00 | (R) -38.62% |
|                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |         765422.00 | (R) -24.84% |
|                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        2468585.00 | (R) -37.83% |
|                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        2815758.33 | (R) -26.32% |
|                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        4851969.00 | (R) -37.76% |
|                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        4496257.33 | (R) -31.15% |
|                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         570605.00 |      -8.97% |
|                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         500866.00 |      -5.88% |
|                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         499733.00 |      -6.95% |
|                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        5266237.67 | (R) -40.19% |
|                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         490284.00 |      -2.10% |
|                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |         850986.33 | (R) -48.03% |
|                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        2712106.00 | (R) -40.48% |
|                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         111151.33 |       3.52% |
+-----------------+----------------------------------------------------------+-------------------+-------------+

v6.18 vs mm-new with patches
+-----------------+----------------------------------------------------------+-------------------+--------------+
| Benchmark       | Result Class                                             |   v6.18 (base)    |  this series |
+=================+==========================================================+===================+==============+
| micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |         653643.33 |      -14.02% |
|                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         366167.33 |       -7.23% |
|                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         489484.00 |       -1.57% |
|                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1011250.33 |        1.57% |
|                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1086812.33 |   (I) 15.75% |
|                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |         657940.00 |    (I) 9.05% |
|                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |         765422.00 |   (I) 38.45% |
|                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        2468585.00 |   (I) 12.56% |
|                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        2815758.33 |   (I) 38.61% |
|                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        4851969.00 |   (I) 13.43% |
|                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        4496257.33 |   (I) 49.21% |
|                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         570605.00 |       -8.47% |
|                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         500866.00 |       -8.17% |
|                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         499733.00 |       -5.54% |
|                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        5266237.67 |    (I) 4.63% |
|                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         490284.00 |        1.53% |
|                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |         850986.33 |       -0.00% |
|                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        2712106.00 |        1.22% |
|                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         111151.33 |    (I) 4.98% |
+-----------------+----------------------------------------------------------+-------------------+--------------+

mm-new vs vmalloc_2 results are in 2/3 patch.

So this series is mitigating the regression on average as results show -14% to 49% improvement.

Thanks,
Muhammad Usama Anjum

---
Chagnes since v3: (summary)
- Introduce __free_contig_range_common() in first patch  and use it in
  3rd patch as well
- Cosmetic changes related to comments and kerneldoc

Changes since v2: (summary)
- Patch 1 and 3:  Rework the loop to check for memory sections
- Patch 2: Rework by removing the BUG on and add helper free_pages_bulk()

Changes since v1:
- Update description
- Rebase on mm-new and rerun benchmarks/tests
- Patch 1: move FPI_PREPARED check and add todo
- Patch 2: Rework catering newer changes in vfree()
- New Patch 3: optimizes __free_contig_frozen_range()

Muhammad Usama Anjum (1):
  mm/page_alloc: Optimize __free_contig_frozen_range()

Ryan Roberts (2):
  mm/page_alloc: Optimize free_contig_range()
  vmalloc: Optimize vfree

 include/linux/gfp.h |   4 ++
 mm/page_alloc.c     | 144 ++++++++++++++++++++++++++++++++++++++++++--
 mm/vmalloc.c        |  16 ++---
 3 files changed, 149 insertions(+), 15 deletions(-)

-- 
2.47.3



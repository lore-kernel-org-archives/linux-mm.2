Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5577D35170
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050606B0005; Wed,  1 Apr 2026 06:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000EA6B0088; Wed,  1 Apr 2026 06:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80AF6B0089; Wed,  1 Apr 2026 06:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D69216B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:16:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E0E81B8A2C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:43 +0000 (UTC)
X-FDA: 84609583086.10.43892FA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6C86140009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OTyDEOYG;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775038601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YYXyiboMIImqwuc7vkYcx8H444RW6P5IN0gdwzbgOE0=;
	b=N4j34uGjaJcshlHCJosLXRdS+hbq3biJuZpNbws9cNzITM93rJR+8uE5LQUkZ2eC5PMkVf
	AZx3ONI7I7n6YT4ymOjtKzyfmOE24iGsmOiRd+sOlVFdaFGmKaexbRe1Crv7RWEXvF7NW+
	CCgDcQfJi+hp96XYmYoHxDvW2OElSr8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OTyDEOYG;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775038601; a=rsa-sha256;
	cv=none;
	b=T03AeQ+csyz19Hr3JkjvcwyrkaG4TX/BDpo9OSyeQMRGrCxb8zWWE1fG6d2errHAwIOhwG
	yR07ViYRYAtkjDlzT0sxZnF51YUu4pZeyds4QiHA+R9qUEBkI62rVPirAK4DnEL734m9hs
	wTh37jdBsGB8mvBZfjJmLvwx8axlvgo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 823CD1D6F;
	Wed,  1 Apr 2026 03:16:34 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D489D3F915;
	Wed,  1 Apr 2026 03:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775038600; bh=QIGPbG/hNIIrgGzENVsHjAyVbxwqz7uvUwqcJOctN9c=;
	h=From:To:Cc:Subject:Date:From;
	b=OTyDEOYGrlSdWlXHxWZDUCgyH4c4VL3P6GzJEFGdz/OZ9L94HLTySuOrD/gAHNfzD
	 dI7TDFTKnhIJnijUDHYJ7wZ6zQ1dhX36e5R7dEhCPwI18F7UGGsJrqgSp5rNTIcC6b
	 r2gZ+r5Mq9pUnrhhnNy/ba4C0W09xgNOfN7IO3So=
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
Subject: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
Date: Wed,  1 Apr 2026 11:16:18 +0100
Message-ID: <20260401101634.2868165-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A6C86140009
X-Stat-Signature: f44mkbjtju538okb7pd4b9uhidugusiq
X-Rspamd-Server: rspam06
X-HE-Tag: 1775038601-885088
X-HE-Meta: U2FsdGVkX1+cHqjDwy5mRI6u5WL0YEJ0JjHYenHfFZ3KjjGhquKYMNLTaA20YHiQwaIlJX1eQjzvcJ381wMVjf6xGAj3EeczWYOKDUPYiQTcVXQT4jCOIGwvHoyEDvGDZmwkkVxDl0WiNU5gHkDDxDkiVICvwo4+FWUHHmiDgCWVaBb+V0yZ3o8v7J5ZnUW3Ee5z5OmL99BniuVOSB4OyNpYKgxT+xg4bVtTfk0/2JaWXADDb4tYed8eck1w7oc0z4MV+vtf8yBogqE4hPo9d5Af1Q0a773Wx2+ZtrjN4e7jC54/vzM8M4fJtB4Gzt4CAuvXkG8tPCiF7/s3iJ3Mm3racZnCfGEDPrbQmo8seZzAVCd0Svm+kpMSWn/LIrh+Tnn2579XJdEadz5DUlAPAsJLBOfgES6WvcjCn4DZ6i8BfilMQKBe6qA6zbrY8F4BXweKGht98I5ZOFCq2lxyBFkGXyqfYehJsSjSAIPBjgPb3JlB5MwYRHHGHhj0J1oFVsqvx++eEDcdhYj++wMOAP8Mf4Cr0OeRU0zBeSXXaTu54hCJjUzA/TnmZvBrCYYGB01qzNpxIf5Vccc43dKSOcCQx3K4JZ/Fc+oFJqwOqMCLqtShLW+bqXCsptd3Y6gR1s5XwfE5JCCrZ28FfY6BgsQYD4c1wbhgW1XK29QoOH1cXeyMYL4PcZHE2bMG4x5j9LZghS4pn45rUQDokdFkCrD56EvbtRQ6tKLkVp1VznB8CucSvwyJQnDiMnP5Atu4BUTsDK4kl4wQxotR1IKSZr0nuy3q7JwgXp+aAM2A5dHiHrfXoao3oRYPBwS5tLjlOY9fY82gCkvzx84qEQK+F/evUVoq0w/gmWEvBQmoon6dmEeDaHZiOGJm8E6EL7AfdK8gOmCI2WvG9nP9OjpbqddCR7ODnh+nbt7B3dbHHcEZGFud7IuMAJX/8BfiAnWmWA7yCaV/Gd7E5y8NlQ0
 a6uIYJFB
 5OVtqA4Mhnl6mE563RHSwiMhyxGPC+9KwWGW894ltkPXA2QDmUP+aaCIrRXmcsGv69o0vpTuDK70xNDmYlxvlEgfCpf7/GM4FcDIrR6/PbPSCR11bPc+T680OAh3z6BGP9ebSptrhDrWZXTUqhYEdfvW9/uFqEP0dZ+8ftn4PXMGnRRenjSfeIyGcnhe49eFGV/2FtP5N2uKLdG+ZMJ/vtP1mpgiTzkCAFOiZL0E3dzWjRoC3HNVH0hNElM3cfP1WaCC+kMQWK0Dm7VLs5aU6/pLb6PLJLOtIaWeC2UOZDtndx+E=
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
Changes since v5:
- Patch 1: Move page_to_pfn() outside the loop free_prepared_contig_range()
- Patch 2: Change subject of the patch
Changes since v4: (summary)
- Patch 1: move can_free initialization inside the loop
- Patch 1: Use pfn_to_page() for each pfn instead of page++
- Patch 2: Use num_pages_contiguous() instead of raw loop

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
  vmalloc: Optimize vfree with free_pages_bulk()

 include/linux/gfp.h |   4 ++
 mm/page_alloc.c     | 143 ++++++++++++++++++++++++++++++++++++++++++--
 mm/vmalloc.c        |  16 ++---
 3 files changed, 146 insertions(+), 17 deletions(-)

-- 
2.47.3



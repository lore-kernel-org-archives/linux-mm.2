Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE03F109B48D
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199286B008C; Tue, 31 Mar 2026 11:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A126B0096; Tue, 31 Mar 2026 11:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FF46B0098; Tue, 31 Mar 2026 11:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBD046B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:22:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A01FDC3D66
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:22:19 +0000 (UTC)
X-FDA: 84606724398.17.2729CB6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id E4D3814000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:22:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BhEkNpUP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774970538; a=rsa-sha256;
	cv=none;
	b=iHUYRPhamsDrMztNBhOssAagaf3HTUg4wvdeK88DF3QawPKzBgjiWgLUNXyH9WqGj6m7aM
	fOYQeTGTXMHlN8nQNttostSZeQEQ04QBuy+2dwF2nNj3N/4lWh75ekAYWzQZaiOqL+w+Am
	yMdBiTUzPKTO93XhuvZImDWgdgMCP+w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BhEkNpUP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774970538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dPsgYKX/sWzW9rQfgv3qneZB7goSNS3fM6ILxrY15r0=;
	b=5tvkFgSEhqGoYtfRzBPVH9qHqDicxTJQ563TVQ1Hhr8fRlAYjYonsNrp7CzRmpkBDg7d0t
	DOib0dzm4CQDg75n9InxnG94tgvz8a3eyuYAahBCtnru/aoDaIpGx1p0gKyZrcwWxjIEQT
	cw4tKPvv6FX1SeiNz64qhVuCkdiH+o8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 086C32364;
	Tue, 31 Mar 2026 08:22:11 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 71EB73F641;
	Tue, 31 Mar 2026 08:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774970536; bh=76AReawEblF9zwLAiLT7vjcTU5NOi5gm84ErlbSFzuo=;
	h=From:To:Cc:Subject:Date:From;
	b=BhEkNpUP/+8uC6lI5Ab17iUM9+kpj5uey6UHxZP0PKUHKfHZtnCoHc6HYpk0mBube
	 GIXymS/d4x/Nty4hMHA6KJ2e51fruiORAu5ewN+dUx0WKYIpYt3f91RxOn4bfZ97VO
	 OIX4VkcwvPDNJqv6I8MdbYCDHtXck+Yjnlvqpa98=
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
Subject: [PATCH v5 0/3] mm: Free contiguous order-0 pages efficiently
Date: Tue, 31 Mar 2026 16:21:58 +0100
Message-ID: <20260331152208.975266-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4D3814000D
X-Stat-Signature: c8g7x93ngkfrh9zrtwrud4zc9tx683hf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774970537-822902
X-HE-Meta: U2FsdGVkX1+6AF5awbqMpYU0pIUZ4/GATirKdGurganh5d6Tnvppp6z+6UobH8uY5rqwEG5gaNg5XZrKW6jC9goYI0PXhNFjpLkdT0DTo3aGU53r+TtuUruxluhzgp/M0s/YyH8ARtYCi8Za0jGGj6cuw17s9EcovKCT4hyaYIok6fGz3EFWZcILjjaRNxUvlMVg7rRBLCL15CyoUS0BRlCU95mtmliVZD6xicFMN8EJvqgM9I3uiOT+S+FrrkQuy/hJOuVzV/gxgINJJwjnSznvpVPikfQjapwvRxfHaL6cv05T5X1d5f/VS0vrH4AJRTUxiYrQUwIXYTYoufpTDeFTbE9O5IlJrNAUDgsgS0McxY9bG9edNMz+BeWVEd4DRa1lzif+9ZsC17kyyBds9r/W4k5vINMrZTSrrPxZJXb5olUX7+SWQ+iyIvvqdKeMdi+35syUPoNdzveWBzCGlYYwxyB4UceEnNAOcsucc5cuMaFLtC6JZm7UKNTiLqg0aBdSQqreb3JX5RcNwI7EIAoptSVThVGUCNFOwAn2c9hukPRGKBnmHFnYPeRaUvSr+7tUdpx3uyZ9UvSyOS97j2CLsftBbDWm/O72DHPgE1fb7OtIjzqQNuKluEVMEyD5+8o/fIeaP/5mE7IlxMdflQNGCRYHQYPvr0vRmukyQiJ9gAjNNiYAxUZPx1QouZYIWlHhK7zlpeAf9nbAYRNOSu3eRLJnLuGTFWrGXJh/2LHZn6oX0Kx7+V06vSuYBluAznIPfQtZfi2H/6lEHDMRLlrJnwh6slFit64jK4H940a2sBPadUgo8UoNGRKQnm0ovqLLAjo95dwKmGLovr2onANTlKXjDdIwotgvS55iN+QIWopdDMbJDYfpug3sY1KrjVQGblLf7NXqFvtix6nH3nICxuSe9ZZdgBCBvLUBcD/r3bEHvTdYpoJYGv0L+BRFQ9RBxSq/Znpr08AdI/y
 uUPqDl2f
 AXocmC2fxDIm7Fyt+d92TlAX+Z5FbJd4/8x8ex9ketVnNWaRTZLBtsu40I7EDTcRf5j+UOghCKhm8O0TW8rv2uMYuHq4euGTUbQFE40to+CHOHVk8nrYqfYSvMn4yU0XqEg+aZivxZup7n++9ObZlGsEwGtx301CgKpFhIP9d36QPiHgeFMKQX43ki+JXjS9czhLUtiR9sg7irzTVfVEphJVY5H5W4+ul1H53YkFL1nNGyWUveMDyjEJC0NAU/vFnbWGKWiJfyguZBFf1M0SNh+M+jXIblFxbak/qnXNk9B0iCto=
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
  vmalloc: Optimize vfree

 include/linux/gfp.h |   4 ++
 mm/page_alloc.c     | 141 ++++++++++++++++++++++++++++++++++++++++++--
 mm/vmalloc.c        |  16 ++---
 3 files changed, 144 insertions(+), 17 deletions(-)

-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C99F46450
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 334766B01F0; Mon, 16 Mar 2026 07:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7C26B01F1; Mon, 16 Mar 2026 07:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6CF6B01F2; Mon, 16 Mar 2026 07:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 077746B01F0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:32:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95B67B61C0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:32 +0000 (UTC)
X-FDA: 84551713344.07.F8EFC7C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 83D4540011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:32:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773660751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=pO3Qi+RYDEtoJWahYQblGZzXn5dyTXgIKwW0+XVJ/HI=;
	b=XS5NahUSsUnKSpODOoY6xkNGVMFgF0Hak16Y2fwBQL+FeAbqpms3GYWayByJ3IGSkWkMKb
	ixSTA1N3hCKDGrh4FJP/Gat+9bbHNLNKFnzMt9FmpppsXKxkOX3/M4K8rVkzeQc/A8kfmU
	jhBhhQEJjEo7TWeVcBr2qmRvyMERx34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773660751; a=rsa-sha256;
	cv=none;
	b=L6Y2/guIrgP3NUkWdvm4bPrp8+r5Le+sgC8a2o0etBHKNbG2naSBuySHmYj5TR6FbMXfsa
	oxQFJjfPlPn+Xd7yFsvFkEmzbj4p0gA8p1+HYcBSqCxEAQtye4xHVryA9dasRBA/oAlbc2
	5DEO+iI0ecd6XwUPMhyvNuQbXhXlvCQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B1891477;
	Mon, 16 Mar 2026 04:32:23 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DA7DE3F778;
	Mon, 16 Mar 2026 04:32:26 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 0/3] mm: Free contiguous order-0 pages efficiently
Date: Mon, 16 Mar 2026 11:31:41 +0000
Message-ID: <20260316113209.945853-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83D4540011
X-Stat-Signature: 8oaesebgwaanx6bhfponetn414yfgat1
X-Rspam-User: 
X-HE-Tag: 1773660750-285533
X-HE-Meta: U2FsdGVkX19cRrC/Qf/OpYlQSTsGZo4jFNCXoOe85Ot/0UiYN0eDXmO4VHY07xWAUZQG9mDXIHqgPEgYd9Hkr48GRFW9ElJbrJGylgcUGVLHVrzVxNdAViWo/qYU8qIQREkbn7ZeIpfGASPsfiriiaju+BcBbkWmYHfkjDpsxKO4poElWXTR+xotpHKlHwZyVowurYanqGTdAcY/4Ls/uv5YzaQmlnHJ3yKBIdmPz5hrpasc1jAUzYEUmW9YC9obb3kAU8OakA8MsgXHDMD/yqMZZh/W0X3ZxhSfsdZg79hoFcMG8UWx950p/v4wXrMMhC9iKtDtp0jfwHnjPwwVELdzuiWsMPiJ3+6X7zA5m9ehs8hD7YJdfdbA8cmqMICvVVJ7ou70NCPHiYyj6PFEzuRMndPghqhdbWRnU5PDY6TxP7aI4q61V/r3BhQhGKrW9/5AYQz4hzbg5B2NGmMeDbiWK4fwUEc+TcvGd6fXqlU9TIRtmHSq5BmO1tcrnGkzutpFzmRUYR2GOPNraYPY2qNWidqBfhODNLZo3yQRfEzDOTdVjERhNBEq2B7fI7is/lfP0GJ06o6ldKT7sQTkB5AQPO/xwYgFIxA2iX0u6W3WDIEbkheeic+5mJKng8bAJWhfCMft+awZ4Tuxq/edZWoD9QSVwHGsvBRHvEwZZckdQb3DAXImPHuJ90rQJYZxpm3k41u6pywSOdx3X9hev/sgAHINS83c5aGWVmzg7cgT/mFlhELed7wp62Tc5LLZ/x7KbeHAxFjaFkI/jdMw8pSqZTrehg/blfSun4KwKgBvD77JZpOfKqudKqEh4UXNT9F6rfz/ZRw8rtYKyoq+SQOR/XTv2VHNioWip97CHiXJx+vCpsfFqnUukyvJKS13wwxyiY8z7ElSUZti+FedKWT77BLKKF8WdVmHxj86FAWQ/0v5e1JRFTUo0UfyMde4gmtFkAURXlievTRZqEj
 4zrUB7ly
 Roj00ULWfiKisXbJgPIerFKNGW77h3vAFbHkxqRGEeLQVgiPrMltjIxaJQ7mBk6sEF7vKg1Q7uqatUPQ5yNbN52Xqq1ph8vJQMDDeqTOrUjIKh/K3r3Zc85w/Rk2cvNK2IzhapqGxZRKn16DtOpDqusu3vpllH+UD/vnWvmEa8gvhB+MsoBu6UYM8YHjz0h24eNwdwa++M3PwxYhdFbhKMLbrmxH1rh6aWbv9n+vlD6oH+Ty9Jc1IAmeI4gL/eXYuA/NyKfH4xmhmP5MHCbvdgtiGAs1JhZ0ctftD
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

 include/linux/gfp.h |   2 +
 mm/page_alloc.c     | 128 +++++++++++++++++++++++++++++++++++++++++---
 mm/vmalloc.c        |  34 ++++++++----
 3 files changed, 149 insertions(+), 15 deletions(-)

-- 
2.47.3



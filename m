Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E642DF54AB8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C906B0088; Tue, 24 Mar 2026 09:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563A36B008C; Tue, 24 Mar 2026 09:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A7C6B0095; Tue, 24 Mar 2026 09:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 343C66B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:35:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8FA85FE26
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:35:52 +0000 (UTC)
X-FDA: 84581054544.19.A86406C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20A26A000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:35:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YrOiJ1S4;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774359351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ist5j9IyOv2jNLBpdm2SCRw7LmoLL9oo43OXtvd39mk=;
	b=lYTvYprQ/DuKNl8edaNWhqRC42J1lPF2OctIbQFkcVTaA1lkHr3iTa+/JHspmtDohlbgHa
	doOo4+P+xsAZo4d2otlyfW9O53mFb8pb7gMVV/mc6IUykxMf1+WpJ4Om2Q8krw86h8NubR
	oK64cZgdcZXi8OSDx/7WwTTOdrweAGk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YrOiJ1S4;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774359351; a=rsa-sha256;
	cv=none;
	b=o+kB4VW8vMSDFr7XFvQm7qt9jv7wTRmGbSvp+empafYiwmwbgOhx5yKVcR59IGq5i3tnhW
	1Bk9mXdGwo9PPjAVrEU8Nhf3MRrG8HxYE+JVakzOHy7qTpjQNypv7mkSq4jtMelBAKoWGn
	ugOeC4a1i5mXgGfILzzcQViMIQRpd+E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 267011476;
	Tue, 24 Mar 2026 06:35:44 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B07DA3F836;
	Tue, 24 Mar 2026 06:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774359350; bh=vl2OXl2LVtwWCfThahPA38qmIKBgDZZ2FO5uliPOXaQ=;
	h=From:To:Cc:Subject:Date:From;
	b=YrOiJ1S4OX/2cBG3iTjFDWXRB27gOHHkVQ98dP48Z3JlKlbtaQ1trhiRDRbf9SC24
	 y+TukdXunVA/89hdgTqOvGHZeKIkFVCCFHrZAHSgQH7+9ke1HLl6uOYJL/A6zfvmIt
	 K4R9I7u2Qs06b/PHODVKGsSTHeB1S3ptLvBx9XgI=
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
Subject: [PATCH v3 0/3] mm: Free contiguous order-0 pages efficiently
Date: Tue, 24 Mar 2026 13:35:31 +0000
Message-ID: <20260324133538.497616-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20A26A000E
X-Stat-Signature: ru1x6htjaxwkx9pazsgd1tjih5ae41is
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774359350-620009
X-HE-Meta: U2FsdGVkX1+sJZgOZzBY23Kz9L9fjHSuF0dClV//Tz4NLKt8urkLIVqtC9vSGGe0XcLM9WpyOKV+E26ILVVimoXFjKKMp6+QbsBIHz8newcDtPwWXu0KiCahxujW3E/EJBnn2KJPdRkCGkJ8VITKStF+/IISFnhbTwMs+wPBZ+byi70wBw3wrW7JLbWgEwrFoBSzDg4a6fw3J8yPjOeCdVB30jS2FVZx9NxCRJTmi2yl0rMmNG8IvZo3zs3rn84YpRB8JuBSQLTApLN/YRXhDPPYxg8XZAy6mYL11w4wuGscNPBDMr8O7vSMDLa3GXftww4txBa34cJka2NEBo+yDCNHfQz61dPgKW0NZZYX7O6FK/vF+MTYUJRRG8lsEmXnppvBb5EhdMBJbzlI+PFxJXOGWJ548CJx6AKmxmrP91i//33Y2fDyI5VyAVuunhoTkNjbadMJs66tzs9geV+rKlSnWuuxyotB/UU1ugzUNuTFBLZeU79XXV94Btbn+JAEfjUJ/4o+QBewrUuuXV7+akjIYbagsarU2nIr2xXt08YhneccMtnOkF5kWWKLaPwjnnKe4tpJ3cE+0TN2sPixG1rUF6NO7F57GonIVo1JaafsXC/SVrJGxttB27N62bq9eFj0kH2dqZeKhqofxd62AoN2Mv72NEe+lzCpfkwc4JC1hsj8WceC4cx3V/FLMeg+pw4zjCabEKWV4UafxIA4qTibOjc9yIq7qp/8I6FZABz344ar2Qyxf8d6fLvSpJNRxnIdCLSME+Rpducp5ZVMWvYDYsP8BYiz9+kPrucCmdzJ28v3lcB8Limb/fy6d6iWGaU7HBnLqxXbqJ2RGWdw09zGzPP7xce88DhyyGCwxrvmXkRJ1lQ3qikD6I27Y9E4IuX/lIJ59origHVcH/8n2JzWJiUN/0yYUxMzGKpiLDnkyUVy8gLOvjTtSXlpLtvTuKaliYPkLpECKmmU6oL
 YlaDOYoU
 ftUkvuYsUc9riwJrFA4QhZtojV6EB32+pBi2/DKRzXFKTTQMcln2jNFVGg5ESD75Juky/YcpDEeA9GvFeV0tLzXkANJ6ANoJEegGLV1nCzI2rtGJE3dHUb3Fa1FjcG2MAWFMiRmX96V9MJuntD8L9EXdrXdN0Z+rf7yqlqz+Yi6M8Wk/oC9ParyvAkV23m9YA9B0eaoOnm63FVRjcMNjTeNZKsAccIzBlzKEKlYf+8+t5dlBo4X8AgMbbc87FhItH5wrzEq8j0Svsku51aFMwCyARMsEKnGFOnkRwC6GGv3uAfSlZDSTWcT/xa69QslbeeZpUbIXxvnffyNJTUr29r7a8cRZd8Dl9Mg1HudgTcpomfgTDTP30Ejnvzw==
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
 mm/page_alloc.c     | 146 ++++++++++++++++++++++++++++++++++++++++++--
 mm/vmalloc.c        |  16 ++---
 3 files changed, 151 insertions(+), 15 deletions(-)

-- 
2.47.3



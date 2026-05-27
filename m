Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF30CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E4D6B0005; Wed, 27 May 2026 07:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1FA96B008A; Wed, 27 May 2026 07:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34C56B008C; Wed, 27 May 2026 07:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2A9B6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:07:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66C348FE94
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:07:08 +0000 (UTC)
X-FDA: 84812922936.08.EC71560
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf12.hostedemail.com (Postfix) with ESMTP id A6F6B40005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:07:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=QdYLaf7r;
	spf=pass (imf12.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vvR/tuZayREkwIkwHZP/jPrTyMDEhSidNL4CuNjxao4=;
	b=MDFgMRxrVA4m1XQFtLWSQQpqiqRH2PE684YSFr5uSVFB9e6tnmlNB+KS+DOGKKy8UGryYp
	3KJVESeybsZ6UJ12+CD6hsjim5+bRJ6FaDATQmB0eVrVgsL/7abX0wBnDEnrPDLKm0/iJT
	p1QwE85LtVgBNmsuBM7+yGtuT3ipKxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880026; a=rsa-sha256;
	cv=none;
	b=RquUWgOmx3XXeff8LjEcNMJcGUjt7nrXzWFchRIIotKivAnEPHlZ6FZtR7SewpVsTiO4MF
	4SrP2StBtlmTxWUcqOqPIbziyR9PCeGaOUIvfwVgix8Lv6zYttBYkfIUdvug31Jtl86mDx
	mzzfPqxTeaxBIjroJOagm06P58TJwkg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=QdYLaf7r;
	spf=pass (imf12.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=vvR/tuZayREkwIkwHZP/jPrTyMDEhSidNL4CuNjxao4=;
	b=QdYLaf7rRUY0eslf6/Dm3hgzaAxp8J54DWdegtqXyS3m6oBsFnah8p8LFKqKy9gqw3DSuBW3Z
	FWwRV66U5wdU0ilIb85tskEAYEdOXfnqg5rQ4TE0w4s4gJ0PL/ght2I4MYGaCT25aG/12gPQWWQ
	KDjiXKyb42/L4dBK7BnWDjo=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gQRcS4gXvzYl1Fx;
	Wed, 27 May 2026 19:05:44 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:06:59 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:06:59 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
Date: Wed, 27 May 2026 19:01:32 +0800
Message-ID: <20260527110147.17815-1-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspamd-Server: rspam11
X-Stat-Signature: e6ohi3b1ej1mjstui6eu3e814rztxow4
X-Rspamd-Queue-Id: A6F6B40005
X-Rspam-User: 
X-HE-Tag: 1779880025-169425
X-HE-Meta: U2FsdGVkX19yeNmAWDglj0r2AVBCrwJRv/2G+TMRbzIoJX0Ttsj0Z3BUeiUZYlPl4dLuW4Bynaa3yWjSwHZmxyk9TnJ17zlWzTGhEcnSzhAQkzIgcZs4f4GOdk1zqLAxCSC+NojH/iGHOwLNFtkohQqlbTOYQSeuEHziz9X4InDln5dWj/MOWQu/4X/zsfkvNs7Pu0eT7mGhyx+Hc/HQIudK7teVkR6+3frcTqTWRTx0kBBhVudWYQSu023iOmzh9M8IQOomB6K8SrPp73v0vwXv3g6Pi0JUqx4Ot/mhEwyiHDuL2rBPz6tXwp2IfrIw73OWr4zC7n/qQM/uG5xB3Zz9lqt5tQBwJSDgq0jloq4YZfsSMC2fYJHmNvetkaa+L870MPZ4OIyHNwypSaHibmNfikB7EXEIbQ756Mnn8pP+VSo7nqAuUH/XbcSKw7wrrMyjqedd7+TAh3bZMJbi7fwWnW8cgAyHjgyg+KcYcqidq7ZdmaIcbVn9jUvy3yGSABI8fZBrusrbkCrt6FDUsnKmBkzZkErPbmFKRgdDaxzlAdim1AbtXpuzvt+IdUokzpYmS7R0k+STyL7ziVSCpT4GhXqXYl7AiUEo2Au4VjchidJ399E315JIL9anhqeq0WAgrYbXmsGzUHYDEwxN/FIGxhbbMsq5mPV/6FCG3V2kdtKnb3IBKWPyCCmPIW4gCWwHOWEYdPS7lzxoZwu2lOdYLb2LKVt3Giyrbx7x+++P98W+2x6Cc668HB0OneYEE6VnFFYJxgv9/3k23XqRyVX7n858h2waU6SPJbALlHBpyx4DoAj5wZHabNW7BZTVKp/9P8ZEyIIettcfW891G0Uxelxl4MzjRgxDv9SO+LLuHkheAwfbDBhm+jgJqUtjfApR/5ioQ3S5jdLWX5HNoubbxK339uFKTt9NKBnxBIOPonQmC4aAjWuwNy5aufjhu80Ic77+EpF9Xl+VAZv
 UPC0hzSF
 3qJ/ruQ83yb8fczbb4JSgO6/ozQgL68AbNrJzp/3nfJgKKOh600j39yoRJh57/v79la5tOj6Id2kqHonhmjm9AX8XzCOmIelPxAf1tUZ//5Tk45y3LuJeD8HyLgF4Quq6DpYh2mhdpXGJdyJtjSqht9BI3hiAvhxZ9GcBnUob7DgWXqUmQWBqDWIxFgFDRExS5Pz7q19a4HQyflEc6G0IvrBqhKJ2oH3eGWBYp6IZwM0R0qeGZbQfEte4pOn8H7VL7PVeSe7THn/P00Id3mGXyF/v2qOY9HqvvboDMiTGW8UL031XwI8DAzmORAP12XgxrUmFavXbj0UGGyGe1VTF74M6p7MCam5GcHK6NF4KxfG1Whc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR
-----

This series introduces ANON_VMA_LAZY, which defers anon_vma creation
until it is actually required.

- anon_vma memory reduced by ~92-97%, anon_vma_chain reduced by ~50-57%  
- rmap operations on ANON_VMA_LAZY VMAs do not require anon_vma locking

Background
----------

Currently anon_vma structures are created eagerly when anonymous VMAs
are initialized. However, many VMAs never participate in fork or rmap
operations that require anon_vma chains, so the allocated anon_vma and
anon_vma_chain objects are often unnecessary.

Design overview
---------------

ANON_VMA_LAZY defers anon_vma allocation until it is actually needed
(for example during fork). VMAs that never participate in sharing can
avoid creating anon_vma structures entirely.

Before an anon_vma exists, rmap operations rely directly on VMA
information, so no anon_vma locking is required. An anon_vma is created
and linked only when sharing semantics are required.

This series introduces anon_rmap helpers to make rmap less dependent on
direct anon_vma access. It also introduces anon_vma_tree_t as a container
to support both the lazy and the existing anon_vma layouts.

Once a VMA becomes associated with an anon_vma, the normal behavior
remains unchanged.

Memory impact
-------------

Preliminary measurements show significant reductions in anon_vma-related
slab allocations.

After boot:

Object            | Before (active KB) | After (active KB) | Change
vm_area_struct    | 117035             | 118176            | +1.0%
anon_vma_chain    | 18865.8            | 8112.06           | -57.0%
anon_vma          | 20426.4            | 613.75            | -97.0%

After launching 24 apps:

Object            | Before (active KB) | After (active KB) | Change
vm_area_struct    | 196873             | 197345            | +0.2%
anon_vma_chain    | 31477.1            | 15576.8           | -50.5%
anon_vma          | 33280              | 2648.12           | -92.0%

Simple fork microbenchmarks also show a slight improvement in fork
performance, since child VMAs do not need to allocate anon_vma
structures during fork.

Feedback and suggestions are welcome.


tao (15):
  mm/rmap: introduce anon_rmap APIs for anonymous folios
  mm: convert anon_vma rmap APIs to anon_rmap
  mm: introduce anon_vma_tree_t for multiple anon_vma topologies
  mm: switch to anon_vma_tree_t APIs in preparation for ANON_VMA_LAZY
  mm: add CONFIG_ANON_VMA_LAZY and folio helpers
  mm: add CONFIG_VMA_REF and VMA helpers
  mm: replace direct FOLIO_MAPPING_ANON usage with helpers
  mm: prepare rmap infrastructure for ANON_VMA_LAZY
  mm: implement ANON_VMA_LAZY rmap semantics
  mm: defer anon_vma creation with ANON_VMA_LAZY
  mm: handle ANON_VMA_LAZY in huge page operations
  mm: handle ANON_VMA_LAZY during migration
  mm: support setup and upgrade of ANON_VMA_LAZY folios
  mm: support merging of ANON_VMA_LAZY VMAs
  mm: enable CONFIG_ANON_VMA_LAZY on arm64 and x86_64

 arch/arm64/Kconfig         |   1 +
 arch/x86/Kconfig           |   1 +
 fs/proc/page.c             |   6 +-
 include/linux/mm.h         |  38 ++
 include/linux/mm_types.h   |   9 +-
 include/linux/page-flags.h |  34 +-
 include/linux/pagemap.h    |   2 +-
 include/linux/rmap.h       | 165 ++++++++-
 mm/Kconfig                 |  22 ++
 mm/damon/ops-common.c      |   4 +-
 mm/debug.c                 |   2 +-
 mm/debug_vm_pgtable.c      |   2 +-
 mm/gup.c                   |   6 +-
 mm/huge_memory.c           |  16 +-
 mm/internal.h              | 171 +++++++++
 mm/khugepaged.c            |  13 +-
 mm/ksm.c                   |  43 ++-
 mm/memory-failure.c        |  11 +-
 mm/memory.c                |  19 +-
 mm/migrate.c               | 126 ++++---
 mm/mmap.c                  |  15 +-
 mm/mremap.c                |   4 +-
 mm/page_idle.c             |   2 +-
 mm/rmap.c                  | 690 ++++++++++++++++++++++++++++++++++---
 mm/vma.c                   |  76 ++--
 mm/vma.h                   |   4 +-
 mm/vma_exec.c              |   2 +-
 mm/vma_init.c              |   1 +
 28 files changed, 1279 insertions(+), 206 deletions(-)

-- 
2.17.1



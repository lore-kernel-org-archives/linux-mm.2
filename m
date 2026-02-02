Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC80D172AB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC51E6B0089; Sun,  1 Feb 2026 19:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72906B008A; Sun,  1 Feb 2026 19:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71776B008C; Sun,  1 Feb 2026 19:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C5ABD6B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6746B13BF4A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:30 +0000 (UTC)
X-FDA: 84397698420.07.18E655A
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6B18180010
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hmk4ezPQ;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S6S79S/dxGzOUWakad8EjOaI91nR+6xoxuxHJIInMSk=;
	b=BlRgvIqz0GdMd1BqSSzNOWvOeVtXppVgivOlWd9tDBDjxmj7WqhsVZbFcfMWl3pMVoKKLD
	ENKJr2Nh9nHo49PVIuOikqWOhYS/QjhzSV/qy8r681kWUl2wDf+mdvHWCHwh/h042ckQCk
	peqGkIFU0kkVrGQpB8VV8+PcYlPQgbk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hmk4ezPQ;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993728; a=rsa-sha256;
	cv=none;
	b=wZrBj19iWrt/F+QWkV3l4toGc/7ukwpsio5dn1chMg7WowPgwxnXkkPyvEfPGvTlrBncRU
	50BOoewR+jQWuxHVKgTaoPMEgn1nfLZ0PZNFrwqLat0OgpgieyPcAl0nZ9uej18K9oVfA9
	H6V0nSEjppV1qctaikVdbGor5T70TP4=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d19d3c7208so2188028a34.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993727; x=1770598527; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S6S79S/dxGzOUWakad8EjOaI91nR+6xoxuxHJIInMSk=;
        b=hmk4ezPQCeXvdVDpwbSoMV1N6uVoL5Oub77YI8AJSu5zZFgcZDZEIfPb+lT4vaKpOE
         UvX6Ejky8eTixDAGGUg7y7cCNT2rUNxaBMkUkKTsuf/sUaiKR0gzu5GvmBM6B2cowBG5
         XfQ4orPy9w+YSt1B1zuJ8fk3dchkfmmFMJ8b2rGLIJSm62cHYGRCRJP9lqa4Z4OsCp0f
         kcdeY5v6ZvVQOaGjGrzc9khp9qui3ZeRj2ExP4LImtcfdiKXWtGvfNVe+Wke5xSS1WHn
         lxc4BBp8zR3Gl6IgZ7yCHqtwsIEWutupshrtfJNOTAn8oOXjqK4Wis2CO1qQPuHJHvU2
         z21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993727; x=1770598527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6S79S/dxGzOUWakad8EjOaI91nR+6xoxuxHJIInMSk=;
        b=L+JGQcTHXN+XfMtu1RKvI3PI2gcn0PZ/j6GWboKq6wdfbT71DWDalC15X5YetDg2k/
         3tdX4vDf1bnkl5lInZCsVpHSZdWWs0bM4rUkNWNak/F18uV1ZkB0cbc13EkeJ38AMngJ
         ZstnMZ3GYeGHU4ModmtuZDwXCzuS16nsyTV979Nea1ltDWk6uUG1cKUZVPHey191P+5O
         eyeQV7YrBMP9eGwEsRlLJs+ptnbAw9cGDlPiUMO2wOPNVzdrT3/8sFSHFsplm34QBlqR
         ugQ+QdKuVUaXR0GGP68ws8lEzj+JD4z4zy+32A6Xo1K+nld3dYF8ti1u4Ls8V/74aO09
         N6Tw==
X-Forwarded-Encrypted: i=1; AJvYcCUUMPlTtjsBKsN26a6bqppiqa9AGAnjUAU1PgnuWs/FtBxO1nLN+jnreMywhC2QVZEAQLHH1tKTiA==@kvack.org
X-Gm-Message-State: AOJu0YxIfQFQvpg6MnyE0Vyxu92iJi3xE5b+EpV4pwuZAVm/KR3OskHl
	55ytq48MlANzb02tRK4jCUUwgUxGWTaklLEQ3tBoW2sQHc+OFEsYJYte
X-Gm-Gg: AZuq6aICnVnf3Os8sxnZFhrhRZT8dZ8JubZYhaKtrnkq2t6nj/GTE32CuByMz6HPhsv
	Keh5bweknZ3JBjBDY/fzbOEgCxz80dl9Piq0BSg6Xf2zzSKaPCO4NWzkTCw+CgpTOToaDPRuj7F
	0eXvT6DZF+APn402zewQ3fZKv2EVE4OQex+dzAUEXd6lYe15LfOIwD7xlaXppE6JQpeKy3Otbuc
	qDZIlms/qJKWE26gnuXbRQKH4aDdAjM1JKu6QBFkF2iUn/86f32/OejV+l/DCb+ew4dqhvPaRAh
	7cxDK5lGuTdV1t+hJeuETpLE0u/Up+nRpWFUqg1nyBKvH4ZxGZ0mgg4t6ZBVAtc/x616sOKcPJW
	4pEyzc6WgrZCQzG1kkf2NHfCmYeKTAyNl4JM81be8zYtxotHVdpyEo4thNG7vo+gMn1CMTf+5SZ
	/DoLgt
X-Received: by 2002:a05:6830:6add:b0:7cf:e539:dcf0 with SMTP id 46e09a7af769-7d1a52974b0mr6198948a34.10.1769993727529;
        Sun, 01 Feb 2026 16:55:27 -0800 (PST)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c69f197sm9598342a34.12.2026.02.01.16.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:26 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 00/12] mm: PUD (1GB) THP implementation
Date: Sun,  1 Feb 2026 16:50:17 -0800
Message-ID: <20260202005451.774496-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6B18180010
X-Stat-Signature: 3rwo9j5y9zumghr3x5jsu9fgokgdumbc
X-Rspam-User: 
X-HE-Tag: 1769993728-320547
X-HE-Meta: U2FsdGVkX19jVHe0R7XJbhKyNyd7JpHYODOlX8UfYtoB3YSp+Ik+pc/ZVaIPZP3MOtHl1wY/Hbyk6rikIwWhIscIL04fUR/4an3Q2+6hwTPK8T6ab7Nf1Sc+qD+S6EOzQFHfsJdthhLYHG50ZxiM02HhF3qTzJrJjnpgAKZq8QT2wZhrVI7UqXH9tEolIk9DXnqbqTNTP0D47jiG4tOdZ/hUTMdjRPY7hq6Bbrb4z+96+/kNqPzilWP1s48kSX1J0j9/aXD3W/GXpC31bMiiAL5q3Hd0dslEptUYM89+aqEMADXk8KpduM5YuyY1/osZ8dWjdQTIRd7aq06Ilmxq8XB0bgxWsgZWZH1aNHbDSymjvHTBHXwjOJLJnJp7/2l/y4GFinz6rodWW8mDwCzjEMPnwV1e38NAep765qvoUngzkWxKpFHBB5WOIhNPFDa8TyLigQ8jWLnGDeoYswb86tefsX2Ge5iZFe5QZy3T2ILsNxg2gjFqqxg7TLHSazYv+LBo1++59WL4F2Z9aYaFpYeyIf/Df6AqT8Nr4U52vkaonSMulAFO8ATNSxua63HrsJn1KEjYFQkFvxoSuzeQEvaUS4wqj7GtMTdZaYd3JZDZWqtvnT89QZcoQhNkz2m2dAfq1oYFr8IiY7cnGF8HMw8efdJq+VHz/0VbqBYBw6YgUlymE9rmjwKNodbbED+CXv9daDhLkrLyY+qzbY3jWJMIedgGa7NYstTJQh9hBuLWseCdwuxVRp9s/wui5iK0g/lEViXyiBRpq+sYIiJaZkHmkBVSwgEwiecbCQwCxKm25ZVnKzT38bLAwWT2xt9XSE2OetUhrjQjOFGG8FmO/HPmaJIWSFYBhZh3jtheT5xlcU0rrmQFEgJidt3lYsPC18RV3zSI/66LADUkNXKOw+30Id6DBM9USS7NSdC4iWUaSgL8Kz0Xe/q8r5dyapkMXnyjj1fFN6Bwxt80Eh3
 ibDUM9C5
 RaIa8K3CU7A8wcVQ++2EWt1YAJ8k8/h4u7FhdxSew07ZuWEJqlwtEYUfoUAJFnpWix6MYAixcVTGA0ruhntvBIIy3+4hlEAkERIYfYRgqJqWzyf14pfY7LmMALJf4s3m3P7MxuGyyrCB1kAkmgHtng0tmDkz/P72VL7hll7/478lOnnmEk1ZMWcmXu6GRj2stfMWIHU0PRwOs8vDv8gOdz4lrF2foxXPUYNX6JWdk9PKnEE8BbX9WA1n8brKIFvggA99l2dx1OBwjgVRyFVRt6cK194KvQDooyy68T4GAV3XSAwlQDMXudDsk0iLNovw2hDXurhKPd2zBq49RDWqtgANPLiloKQRrRmW9EL8kWoO+rIFycCqiJ1/Nz19kphnzMyPN52m3aEpWLMHKTGKKQyMOl2p1k09h7u8avy+szfjygL8QK5ul3H2tPJ8w6sSr168HFWvy1LiBeD2oEkhcw1g6Ihs/wuGxZOifAQre5NqJBkNZu4UlCJQHgFNAuAC4Opaqqahs82t/YWSXFCOgdirSFO7hylF9OHxIsgEpPVxLAJUxNEqNudgVMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC series to implement 1GB PUD-level THPs, allowing
applications to benefit from reduced TLB pressure without requiring
hugetlbfs. The patches are based on top of
f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).

Motivation: Why 1GB THP over hugetlbfs?
=======================================

While hugetlbfs provides 1GB huge pages today, it has significant limitations
that make it unsuitable for many workloads:

1. Static Reservation: hugetlbfs requires pre-allocating huge pages at boot
   or runtime, taking memory away. This requires capacity planning,
   administrative overhead, and makes workload orchastration much much more
   complex, especially colocating with workloads that don't use hugetlbfs.

4. No Fallback: If a 1GB huge page cannot be allocated, hugetlbfs fails
   rather than falling back to smaller pages. This makes it fragile under
   memory pressure.

4. No Splitting: hugetlbfs pages cannot be split when only partial access
   is needed, leading to memory waste and preventing partial reclaim.

5. Memory Accounting: hugetlbfs memory is accounted separately and cannot
   be easily shared with regular memory pools.

PUD THP solves these limitations by integrating 1GB pages into the existing
THP infrastructure.

Performance Results
===================

Benchmark results of these patches on Intel Xeon Platinum 8321HC:

Test: True Random Memory Access [1] test of 4GB memory region with pointer
chasing workload (4M random pointer dereferences through memory):

| Metric            | PUD THP (1GB) | PMD THP (2MB) | Change       |
|-------------------|---------------|---------------|--------------|
| Memory access     | 88 ms         | 134 ms        | 34% faster   |
| Page fault time   | 898 ms        | 331 ms        | 2.7x slower  |

Page faulting 1G pages is 2.7x slower (Allocating 1G pages is hard :)).
For long-running workloads this will be a one-off cost, and the 34%
improvement in access latency provides significant benefit.

ARM with 64K PAGE_SZIE supports 512M PMD THPs. In meta, we have a CPU
bound workload running on a large number of ARM servers (256G). I enabled
the 512M THP settings to always for a 100 servers in production (didn't
really have high expectations :)). The average memory used for the workload
increased from 217G to 233G. The amount of memory backed by 512M pages was
68G! The dTLB misses went down by 26% and the PID multiplier increased input
by 5.9% (This is a very significant improvment in workload performance).
A significant number of these THPs were faulted in at application start when
were present across different VMAs. Ofcourse getting these 512M pages is
easier on ARM due to bigger PAGE_SIZE and pageblock order.

I am hoping that these patches for 1G THP can be used to provide similar
benefits for x86. I expect workloads to fault them in at start time when there
is plenty of free memory available.


Previous attempt by Zi Yan
==========================

Zi Yan attempted 1G THPs [2] in kernel version 5.11. There have been
significant changes in kernel since then, including folio conversion, mTHP
framework, ptdesc, rmap changes, etc. I found it easier to use the current PMD
code as reference for making 1G PUD THP work. I am hoping Zi can provide
guidance on these patches!

Major Design Decisions
======================

1. No shared 1G zero page: The memory cost would be quite significant!

2. Page Table Pre-deposit Strategy
   PMD THP deposits a single PTE page table. PUD THP deposits 512 PTE
   page tables (one for each potential PMD entry after split).
   We allocate a PMD page table and use its pmd_huge_pte list to store
   the deposited PTE tables. This ensures split operations don't fail due
   to page table allocation failures (at the cost of 2M per PUD THP)

3. Split to Base Pages
   When a PUD THP must be split (COW, partial unmap, mprotect), we split
   directly to base pages (262,144 PTEs). The ideal thing would be to split
   to 2M pages and then to 4K pages if needed. However, this would require
   significant rmap and mapcount tracking changes.

4. COW and fork handling via split
   Copy-on-write and fork for PUD THP triggers a split to base pages, then
   uses existing PTE-level COW infrastructure. Getting another 1G region is
   hard and could fail. If only a 4K is written, copying 1G is a waste.
   Probably this should only be done on CoW and not fork?

5. Migration via split
   Split PUD to PTEs and migrate individual pages. It is going to be difficult
   to find a 1G continguous memory to migrate to. Maybe its better to not
   allow migration of PUDs at all? I am more tempted to not allow migration,
   but have kept splitting in this RFC.


Reviewers guide
===============

Most of the code is written by adapting from PMD code. For e.g. the PUD page
fault path is very similar to PMD. The difference is no shared zero page and
the page table deposit strategy. I think the easiest way to review this series
is to compare with PMD code.

Test results
============

  1..7
  # Starting 7 tests from 1 test cases.
  #  RUN           pud_thp.basic_allocation ...
  # pud_thp_test.c:169:basic_allocation:PUD THP allocated (anon_fault_alloc: 0 -> 1)
  #            OK  pud_thp.basic_allocation
  ok 1 pud_thp.basic_allocation
  #  RUN           pud_thp.read_write_access ...
  #            OK  pud_thp.read_write_access
  ok 2 pud_thp.read_write_access
  #  RUN           pud_thp.fork_cow ...
  # pud_thp_test.c:236:fork_cow:Fork COW completed (thp_split_pud: 0 -> 1)
  #            OK  pud_thp.fork_cow
  ok 3 pud_thp.fork_cow
  #  RUN           pud_thp.partial_munmap ...
  # pud_thp_test.c:267:partial_munmap:Partial munmap completed (thp_split_pud: 1 -> 2)
  #            OK  pud_thp.partial_munmap
  ok 4 pud_thp.partial_munmap
  #  RUN           pud_thp.mprotect_split ...
  # pud_thp_test.c:293:mprotect_split:mprotect split completed (thp_split_pud: 2 -> 3)
  #            OK  pud_thp.mprotect_split
  ok 5 pud_thp.mprotect_split
  #  RUN           pud_thp.reclaim_pageout ...
  # pud_thp_test.c:322:reclaim_pageout:Reclaim completed (thp_split_pud: 3 -> 4)
  #            OK  pud_thp.reclaim_pageout
  ok 6 pud_thp.reclaim_pageout
  #  RUN           pud_thp.migration_mbind ...
  # pud_thp_test.c:356:migration_mbind:Migration completed (thp_split_pud: 4 -> 5)
  #            OK  pud_thp.migration_mbind
  ok 7 pud_thp.migration_mbind
  # PASSED: 7 / 7 tests passed.
  # Totals: pass:7 fail:0 xfail:0 xpass:0 skip:0 error:0

[1] https://gist.github.com/uarif1/bf279b2a01a536cda945ff9f40196a26
[2] https://lore.kernel.org/linux-mm/20210224223536.803765-1-zi.yan@sent.com/

Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Usama Arif (12):
  mm: add PUD THP ptdesc and rmap support
  mm/thp: add mTHP stats infrastructure for PUD THP
  mm: thp: add PUD THP allocation and fault handling
  mm: thp: implement PUD THP split to PTE level
  mm: thp: add reclaim and migration support for PUD THP
  selftests/mm: add PUD THP basic allocation test
  selftests/mm: add PUD THP read/write access test
  selftests/mm: add PUD THP fork COW test
  selftests/mm: add PUD THP partial munmap test
  selftests/mm: add PUD THP mprotect split test
  selftests/mm: add PUD THP reclaim test
  selftests/mm: add PUD THP migration test

 include/linux/huge_mm.h                   |  60 ++-
 include/linux/mm.h                        |  19 +
 include/linux/mm_types.h                  |   5 +-
 include/linux/pgtable.h                   |   8 +
 include/linux/rmap.h                      |   7 +-
 mm/huge_memory.c                          | 535 +++++++++++++++++++++-
 mm/internal.h                             |   3 +
 mm/memory.c                               |   8 +-
 mm/migrate.c                              |  17 +
 mm/page_vma_mapped.c                      |  35 ++
 mm/pgtable-generic.c                      |  83 ++++
 mm/rmap.c                                 |  96 +++-
 mm/vmscan.c                               |   2 +
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/pud_thp_test.c | 360 +++++++++++++++
 15 files changed, 1197 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/mm/pud_thp_test.c

-- 
2.47.3



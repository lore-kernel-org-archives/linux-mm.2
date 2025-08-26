Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0750CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1968E00AB; Tue, 26 Aug 2025 03:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79398E00A8; Tue, 26 Aug 2025 03:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8FC58E00AB; Tue, 26 Aug 2025 03:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6D668E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:20:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 554CE118C54
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:10 +0000 (UTC)
X-FDA: 83818059780.29.593C101
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75B1B120003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XyUI4gCa;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MvSNIEmsBO/S1uWXAujiQsWnGsOXId7wmCU3A+Uy2og=;
	b=M3AYpjURNvQy/fEDcl4RIQHUJOnT7Cb+aekRywlL3/kbze7YHMif3gj18LvI+zvDbgye+A
	NnsdvjedysUcA+o5Ugw6UMWAyng2Kdc1PvQTIJ31FBMiDSRFLcYRas04AKq06N2uBps1bR
	5iCeKCet3DUVQUMi2WHFwM19OIo5Dkk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XyUI4gCa;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192808; a=rsa-sha256;
	cv=none;
	b=rz1fy1/I7yJvmeaRwmju8ULT1g/LXadvvgb/jyRkWciGcFmgXbot7A++UtCRUPZiwbg8l1
	9bJ2hRSWcbFyuolvajZTfIHYiinkYPA4iLbyhZiE3Qae/2mEOvqs2ax3G14WPXCroLtbg4
	J7Fs/yBGXy+msMkv4XX3Fk0GQ6EPPP0=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-771f69fd6feso761260b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192807; x=1756797607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MvSNIEmsBO/S1uWXAujiQsWnGsOXId7wmCU3A+Uy2og=;
        b=XyUI4gCactXwydjt+HbhtV6AoYMTqyLTU8i9RO/c8RNwG1Beeb5ht8OpTeO6pZoKGr
         SOwjme3/p52mN+4KKtrPD6U5/eE/rTNDvfJ/ZF71qOa5bY9nMuAahAgu5AjmTeXS/Kz6
         OlX5UKCnY+P3IMdaUbXHLVa/G8JO7DCYO4VblwAKXRVoIyOH7NKLQy4ux1jUxSODTB8z
         Rw9WUUzKRlcgw0JkM2HjKXS0O72fsusSIZto2DqKmFR+ht2VbbjtvamK2aNL1MkmrZyD
         tPPBeK901NOwWUdprRRbJm3xNm2l5p3r0OkfTXTB9LiKPaBcAhXwlmcI38wNpRer8vBB
         fv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192807; x=1756797607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvSNIEmsBO/S1uWXAujiQsWnGsOXId7wmCU3A+Uy2og=;
        b=FI2fLOVsGWpZcMUWBmVZTabiQd3Gbrgozv6rp3Egupf7leyr9Nb4zXmgZCOr2IQbq0
         xH9viaN9XLpV5HaPtPsWY4wWHzoWefhhFtkkZuHODjtd7Z/bzpDsxIdGxkzk0Hyej/HB
         VeBoEXKrZH5WCR4gxr9XaaYBdlDx1uGMpbR2mGStEsH+a1H1vTkdz0bUkru53lx+/VeM
         wH/AgIJt1oppmNlASlYaOgWe26YUrpH4Eh64aVn1YxAdHDvjxVpaB0207b4Eoe5luXQx
         oDxaL5sHcgviXsn7iJiAgaA0jKXd1wCAAo4XQoJCUPNu8m91UGn46IkobRGpKUvs2T/1
         186Q==
X-Forwarded-Encrypted: i=1; AJvYcCVUU1r1er+d7e4kfOL8CyJ/ciaYg+2ACvt3Ka/15H0WWx+pnGbO3iad7XiZq2E9aE3BZwbfiXIQTQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+pwj7wthxenM5eaZ77wPwFt+FYGYlde+twwA5BgEBTiFo6Hv2
	IqrCpZlGyCuHg4EKi6JxBnGd9cnlleL3/5e+7WLdKZHjtY/iz7St9/Dw
X-Gm-Gg: ASbGncsfo9tWLRV67F7ZXvfAYYf9Dqd/Xp3hU5s+lXGb3e1dw2Anduf9aglw8i7HeJY
	gw952rESDRCLq2GOh5v8eaTY6bbbzO2ZM5r1LRwVaegIIU7Bd18/x4UtJG3qLbNu/ihtXQnI67z
	SpjAtEYBnMSZ/rs8lBPVT43TcyvPFCCsmKQRljpzyyquUHGDjEjmnoOJ2wrbjmQ6GmMynA/aNHw
	oiyeSPjnEc+hcesQ5BWMZWIutgzh0/gNZrlwaJNnV5pcl5bGEnGbqUKZQRsMxqUpCV5jvy1c694
	6WoW75TB8C0p5R+qSUBmn/vZDbYwK0tfDk6KSEsaKozqQVvPgGWEWw1YJVtqQWqs43Q1AErF9B5
	yl+fW3XSqKoExF7Gu47dkhDwWZ99+irTQ1GTxV/mK+UhSHoFbCDU1duIYXtLEJXbChKcnVYj2/5
	3d8NE=
X-Google-Smtp-Source: AGHT+IHJJhanwvW5EbqwEOoFAkZdDHlluG/q6CqoQ9rDCm4qZgtWZOtyBmLarDVC5avUWvJXYxUL7w==
X-Received: by 2002:a05:6a20:4325:b0:243:15b9:7655 with SMTP id adf61e73a8af0-24340d2288cmr21351592637.47.1756192807103;
        Tue, 26 Aug 2025 00:20:07 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.19.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:20:06 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 00/10] mm, bpf: BPF based THP order selection
Date: Tue, 26 Aug 2025 15:19:38 +0800
Message-Id: <20250826071948.2618-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 75B1B120003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gbftnnmurmrpw5zfntqcchk5ibu35jp9
X-HE-Tag: 1756192808-317238
X-HE-Meta: U2FsdGVkX1+E0DXL9RnOVWhhc8DnuigUplPXgtCXRGHef14VfKr8CrdbB85qOBet7zfgLhiuoEjYaJFSwiSTP+uwLiUIASgi3wfuIQvZeT+wSrOYlXcdFxsetprUj7AZY4fPdxcooRJGUMA3Ety7DL8RYp/fns+k/5MMbtUpdQSLdBXzD7kRwMk+55nCo+TuS2kyOHWZ/lZ7kwTOOQO14X1sD1r+oJU/8v6xosqMn0RacLphL9Q1lgMn2PtVIw4AW8TVWHQXEQxxW/+PTnPRHLR6FZXjqznQ4erRyxGbKw48voDZN/i98/iNK+AKH62loTCWxqDojk3ZARDdJqGzogvvZOf8C4vEKQoigPEibLs+xXo6FOquW8ywXYJ0mGWJ6NmBcldP6tpYKfPBwGoudB2KmSQ+D88TdDeZO7E1yu9zK4ovX7ISzCfhQpE0KxlDwRt/n8IrnTSR7Z90esjDrvEvbhqtjqgwxJt6zfPNuoSEf6vaf78b+NELd+zGFUva6bhGwbGADHD/bQJtGjbM6CqTpELKxakJ1DXXbPa3f9ulLTROfd9cyJ/2BvPogeehEIGHrBG8XeMbSjTV9Ox/o1kAOu6mOFm8c2OH/bXmEfl7nOVG77HzXSrcjPV3+JryjFJN/1zGr33X7eh94w5agcvZwJ/s6MJ5NQiqrk938GgQrdJgs7AdQpD8cg+k8BqQdArBpAHrc/LjIl4JrgKclMFK75Wh/8VedhNrbYURoIwQICu0HdAZ+pcY4QexV0G6gXpP6WQ0it6eCYieeW0Jhq646K9wB04FSS7M9djzC0w7qore+UsYTTmNLH8cm26CSWU67mBaVmnCl/mHI1vLQ7yZJKOu+CZdoOIuUlFeIX+2PrIfc1+FP4sMUn2Q8R0XEXduS5L1qqUeI/EDOryhik2JEPxdWr/oExUBsih/x7lU4RDjY/p2LcmtSStMZYob587xcuM8C3QdtCL+w/m
 bN/+YUNK
 yJs4rWhPaxtnEdMN07zBEWnWdbvwaTCHkKzmaA0i/PYFsNgRNGQ2vNK9VX23qLHiBK0nLaoFM1keNx4xBQbI7eMxKBBNMHaOFsTt75wgAmHbxuHI8ma7yOvPquiPvqkGLT7p6xoMYnsJ0XwhCVrtyM5F9eqir8cGnVFqie/9QKmOqlr5vLVf0t98aaLEGefQmVZ3vOWLwUp9esjjhQ1QI6ufNzONmOJmrRYK4tG9udUtIyiN6k8cPorFKmHtH4Lk6lOWMXP3kvWjIpOErZ8C4xesz6Ew7TcTyhXiK6Q8DS3CbyKKdbVu3kT34r5tij62jG2pme27Pgl7kB8eH8I8Q1HfXjO59cmn9jzDEgoflEX2kOszpIAFSKgWHeM4stzx/H9BgcrGhGMPGmEMeEhqBHK8ARY3TyhZGDyIJTej5yUneN1TeywkeCxfyLgFhMFx0Pv+QljYrd5cWJdkU4tdZetxw2XWeUkiVBtfYenBKd69Uq+BsPDZOctqo0ifNbfYF6vKp5ChPJnka2yj98o84LR7jWn8wKtTITOiXSn93k6o9a7OmeLT3kIu/ZnWBn+GkliZuYl0UCX/pJRp4a84735Py6C4SLBrTDFNgafCaAGwwkgQ3L2xdir4QghM/+ttTnQMfo4qX42nBt1WxvMuBEPB0zMRrqy9ue2ggVf+OCMhY9aO3c5A6/Nym5MGwQ6uGbcw7z9RXzVpM3h62pW9mLBnjCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Background
==========

Our production servers consistently configure THP to "never" due to
historical incidents caused by its behavior. Key issues include:
- Increased Memory Consumption
  THP significantly raises overall memory usage, reducing available memory
  for workloads.

- Latency Spikes
  Random latency spikes occur due to frequent memory compaction triggered
  by THP.

- Lack of Fine-Grained Control
  THP tuning is globally configured, making it unsuitable for containerized
  environments. When multiple workloads share a host, enabling THP without
  per-workload control leads to unpredictable behavior.

Due to these issues, administrators avoid switching to madvise or always
modes—unless per-workload THP control is implemented.

To address this, we propose BPF-based THP policy for flexible adjustment.
Additionally, as David mentioned [0], this mechanism can also serve as a
policy prototyping tool (test policies via BPF before upstreaming them).

Proposed Solution
=================

As suggested by David [0], we introduce a new BPF interface:

/**
 * @get_suggested_order: Get the suggested THP orders for allocation
 * @mm: mm_struct associated with the THP allocation
 * @vma__nullable: vm_area_struct associated with the THP allocation (may be NULL)
 *                 When NULL, the decision should be based on @mm (i.e., when
 *                 triggered from an mm-scope hook rather than a VMA-specific
 *                 context).
 *                 Must belong to @mm (guaranteed by the caller).
 * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is NULL)
 * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
 * @orders: Bitmask of requested THP orders for this allocation
 *          - PMD-mapped allocation if PMD_ORDER is set
 *          - mTHP allocation otherwise
 *
 * Rerurn: Bitmask of suggested THP orders for allocation. The highest
 *         suggested order will not exceed the highest requested order
 *         in @orders.
 */
 int (*get_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
                            u64 vma_flags, enum tva_type tva_flags, int orders) __rcu;

This interface:
- Supports both use cases (per-workload tuning + policy prototyping).
- Can be extended with BPF helpers (e.g., for memory pressure awareness).

This is an experimental feature. To use it, you must enable
CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION.

Warning:
- The interface may change
- Behavior may differ in future kernel versions
- We might remove it in the future


Selftests
=========

BPF selftests
-------------

Patch #5: Implements a basic BPF THP policy that restricts THP allocation
          via khugepaged to tasks within a specified memory cgroup.
Patch #6: Contains test cases validating the khugepaged fork behavior.
Patch #7: Provides tests for dynamic BPF program updates and replacement.
Patch #8: Includes negative tests for invalid BPF helper usage, verifying
          proper verification by the BPF verifier.

Currently, several dependency patches reside in mm-new but haven't been
merged into bpf-next:
  mm: add bitmap mm->flags field
  mm/huge_memory: convert "tva_flags" to "enum tva_type"
  mm: convert core mm to mm_flags_*() accessors

To enable BPF CI testing, these dependencies were manually applied to
bpf-next [1]. All selftests in this series pass successfully. The observed
CI failures are unrelated to these changes.

Performance Evaluation
----------------------

As suggested by Usama [2], performance impact was measured given the page
fault handler modifications. The standard `perf bench mem memset` benchmark
was employed to assess page fault performance.

Testing was conducted on an AMD EPYC 7W83 64-Core Processor (single NUMA
node). Due to variance between individual test runs, a script executed
10000 iterations to calculate meaningful averages and standard deviations.

The results across three configurations show negligible performance impact:
- Baseline (without this patch series)
- With patch series but no BPF program attached
- With patch series and BPF program attached

The result are as follows,

  Number of runs: 10,000
  Average throughput: 40-41 GB/sec
  Standard deviation: 7-8 GB/sec

Production verification
-----------------------

We have successfully deployed a variant of this approach across numerous
Kubernetes production servers. The implementation enables THP for specific
workloads (such as applications utilizing ZGC [3]) while disabling it for
others. This selective deployment has operated flawlessly, with no
regression reports to date.

For ZGC-based applications, our verification demonstrates that shmem THP
delivers significant improvements:
- Reduced CPU utilization
- Lower average latencies

Future work
===========

Based on our validation with production workloads, we observed mixed
results with XFS large folios (also known as File THP):

- Performance Benefits
  Some workloads demonstrated significant improvements with XFS large
  folios enabled
- Performance Regression
  Some workloads experienced degradation when using XFS large folios

These results demonstrate that File THP, similar to anonymous THP, requires
a more granular approach instead of a uniform implementation.

We will extend the BPF-based order selection mechanism to support File THP
allocation policies.

Link: https://lwn.net/ml/all/9bc57721-5287-416c-aa30-46932d605f63@redhat.com/ [0] 
Link: https://github.com/kernel-patches/bpf/pull/9561 [1]
Link: https://lwn.net/ml/all/a24d632d-4b11-4c88-9ed0-26fa12a0fce4@gmail.com/ [2]
Link: https://wiki.openjdk.org/display/zgc/Main#Main-EnablingTransparentHugePagesOnLinux [3]

Changes:
=======

RFC v5-> v6:
- Code improvement around the RCU usage (Usama)
- Add selftests for khugepaged fork (Usama)
- Add performance data for page fault (Usama)
- Remove the RFC tag

RFC v4->v5: https://lwn.net/Articles/1034265/
- Add support for vma (David)
- Add mTHP support in khugepaged (Zi)
- Use bitmask of all allowed orders instead (Zi)
- Retrieve the page size and PMD order rather than hardcoding them (Zi)

RFC v3->v4: https://lwn.net/Articles/1031829/
- Use a new interface get_suggested_order() (David)
- Mark it as experimental (David, Lorenzo)
- Code improvement in THP (Usama)
- Code improvement in BPF struct ops (Amery)

RFC v2->v3: https://lwn.net/Articles/1024545/
- Finer-graind tuning based on madvise or always mode (David, Lorenzo)
- Use BPF to write more advanced policies logic (David, Lorenzo)

RFC v1->v2: https://lwn.net/Articles/1021783/
The main changes are as follows,
- Use struct_ops instead of fmod_ret (Alexei)
- Introduce a new THP mode (Johannes)
- Introduce new helpers for BPF hook (Zi)
- Refine the commit log

RFC v1: https://lwn.net/Articles/1019290/

Yafang Shao (10):
  mm: thp: add support for BPF based THP order selection
  mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
  mm: thp: add a new kfunc bpf_mm_get_task()
  bpf: mark vma->vm_mm as trusted
  selftests/bpf: add a simple BPF based THP policy
  selftests/bpf: add test case for khugepaged fork
  selftests/bpf: add test case to update thp policy
  selftests/bpf: add test cases for invalid thp_adjust usage
  Documentation: add BPF-based THP adjustment documentation
  MAINTAINERS: add entry for BPF-based THP adjustment

 Documentation/admin-guide/mm/transhuge.rst    |  47 +++
 MAINTAINERS                                   |  10 +
 include/linux/huge_mm.h                       |  15 +
 include/linux/khugepaged.h                    |  12 +-
 kernel/bpf/verifier.c                         |   5 +
 mm/Kconfig                                    |  12 +
 mm/Makefile                                   |   1 +
 mm/bpf_thp.c                                  | 269 ++++++++++++++
 mm/huge_memory.c                              |  10 +
 mm/khugepaged.c                               |  26 +-
 mm/memory.c                                   |  18 +-
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 343 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     | 115 ++++++
 .../bpf/progs/test_thp_adjust_trusted_vma.c   |  27 ++
 .../progs/test_thp_adjust_unreleased_memcg.c  |  24 ++
 .../progs/test_thp_adjust_unreleased_task.c   |  25 ++
 17 files changed, 955 insertions(+), 7 deletions(-)
 create mode 100644 mm/bpf_thp.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_task.c

-- 
2.47.3



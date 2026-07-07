Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5CB1C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928366B009D; Tue,  7 Jul 2026 02:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D88C6B009E; Tue,  7 Jul 2026 02:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8416B009F; Tue,  7 Jul 2026 02:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AD846B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B79258D13D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:39 +0000 (UTC)
X-FDA: 84961037238.15.1D88F0F
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C8021C0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ov+5NpAx;
	spf=pass (imf20.hostedemail.com: domain of 33J9MagsKCKcZVbYHcWHUKHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--souravpanda.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=33J9MagsKCKcZVbYHcWHUKHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406558;
	b=L2Syn49si0J6C7hXMmm7fn/w/ypD5OFnLNzCX7NZW9AGRMXS/0YSsnMpRCr7pdKuOu1ql+
	SZXIgBi+rildbh8R9xnjIUBMMLcUOaTidbAXMQR2W6muIfSbAsrezm6377kjh21jueUs81
	bHVc15ITHGAELuTkukvEDEkYZyqaRsg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ov+5NpAx;
	spf=pass (imf20.hostedemail.com: domain of 33J9MagsKCKcZVbYHcWHUKHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--souravpanda.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=33J9MagsKCKcZVbYHcWHUKHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xeJmdcEDb3hj4kjTojGe7izWAUg4e6NWPJspG9L+qV0=;
	b=UwesTzDMmG7a8njmneOcdP8kuUbow8BFI7rf2fLYD4XUFJS6Yw97LXbj84f1RheqUG2y1L
	WLo+oQcZalIFS8aP/xoVzfK7ZcHBE6I2C8OhP8fuv96AajA0eZYR5iNa7PWYvT96hhFI/l
	gOlfnriZi5Xew/YYgTG8ELuf7qqH+as=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ccafc5e82cso19475975ad.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 23:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783406557; x=1784011357; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xeJmdcEDb3hj4kjTojGe7izWAUg4e6NWPJspG9L+qV0=;
        b=ov+5NpAxAOUHY0gZ6uUEGwqqu3cUW70BMqv+QINmO8skt3sj/QJVwJf/ZSYO9+fTat
         L26j3nZ13bA/Cz0/XSnAI0A3zw5kwcIw6rApL+Q41uBkAbG410vdurYJL9EQacLepfVp
         fAi4Uiy83IsBzGRRnlHmpy6HNTqY/94rH8tUFGIFTVIBadBpfoCRHLgeN499PdCfaBor
         xtkgqzPC0zM2h/svt8EC5xbhSJZKXLuWiGUTLiZ9MJqEtqGfhO6Absq/XbkGuI81SMAe
         19jVW25w5uapgQcYZP8UjrWcHlEFMuPnjq4BMcFLbXJQEN/tsU5wtpB+/tilSJ7hopwK
         RHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783406557; x=1784011357;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xeJmdcEDb3hj4kjTojGe7izWAUg4e6NWPJspG9L+qV0=;
        b=bgjrxYywqSxs42lFaohuElgLvsTNDCVcn/dL19PWyOOL2/uMEeASnq/B2N5QPnqWpm
         7+7+ZEgTxTXxxXOEStSkETofGpDrc+UEcB+UNxu/JOBh4yIDzSimJrgeOb0WgEQmQJZD
         37lFO6nGR5LtNu9YQ+dfJtoKdA6EfJjdrNNCdB1uVc2l4NPgyBYnkxAPONLfNl+L/r01
         zp14LNcz8TUVa1C88gEfeePi+40DrdXIlhn90F8e8QamUwOVr2Xq/dseeOK0yyyuzq5/
         0pqJv0IOdJaYzvmeFoaXEVXXZ2mQ2S8oIGzp0mbAausscL+0ZfI0vCBSoz6UwUUBS6zw
         c0pw==
X-Forwarded-Encrypted: i=1; AHgh+RrNmy6LuO1+2DduOXyFYcZj0nqA1iBK9mTsr3zTmd5v3sI+xCTjaQE9nZyBNQy0Ih5OowkwWSxXWg==@kvack.org
X-Gm-Message-State: AOJu0YzA44hZOkEYDMiN/yZqbpXtUSVAladegd4qvnM8JHF7iin2aYhi
	sJMK6ab2aZbiveJO2SURiBQPDeKsAouFZY3R1qJkW67OgA2cnQX84y2M0FabcJ/0LcOxgJp2GWl
	UTRVqHLVKOZEEBa4QLNifJ7vAXA==
X-Received: from plblk15.prod.google.com ([2002:a17:903:8cf:b0:2c6:bce1:2477])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:388b:b0:2ca:d463:27fc with SMTP id d9443c01a7336-2ccbf076ebdmr41254245ad.45.1783406556649;
 Mon, 06 Jul 2026 23:42:36 -0700 (PDT)
Date: Tue,  7 Jul 2026 06:42:29 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260707064235.1386552-1-souravpanda@google.com>
Subject: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache & Free
 Page Reporting
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mst@redhat.com, 
	mhklinux@outlook.com, souravpanda@google.com, fvdl@google.com, 
	gthelen@google.com, mike.kravetz@oracle.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, riel@surriel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C8021C0002
X-Stat-Signature: a34rdyfmgqbff7t19ncwgj93dtqj4q7c
X-HE-Tag: 1783406557-479887
X-HE-Meta: U2FsdGVkX18LearDnEFpoaal81MUV6NblxP8Y55yCnzEEFdZmODbcFtVEWQSJCt1Nrk8p1aE3reClgT0TZnlMyszNiVPli4kSLjNQUA2VLL5KXuu4kD3euGCLy3JtRcdptNlQ909kVS0//pR5ogkySVn5yFM2fTNeL6LJvoV464WJAPSL5vbzRQROhyHehTQe2Twf63X872ZuabnfnLSh3jf1q2pOFHH+D4SLE2nZaQl8MEPd3sL5uPxGyhAA6v2R2aPxMAdGPoYTLzzOMVrORA9rdnxDktNAL+D9VjB2+C1cE++dOrNck1gn5qJ2WYt2DVGXRlsmVFbgugTosvNVxLYftxjO0d3dRwildUVXUKh9VsBZzx9drpf2Sau8NOoFLuyOj6rf1AvwmompL0+ZeR/xQEcJVdPfHFe87e/+QSpfeTVlKNT2pgO/fS05lcVyzF+1Z+M/8Z6GmRzAOzmW7CHLoFlSOQVaF2T48xrY9h6eWqNi+ZLLY/QdU5rddFHe1KGjz39o9+iRsqSNdTijbBHw3HliCBI82ayXwEEl6X7VEKBO6wUMrxRWcY17MmberOey7ofw8Vnk75oWz96o20DvVbwLaZ1mAC/YBJgeQoWkL2kagALRdUvgFIvK4njc/xS894fgOyM0fdDLcVPTZpByL/ReHQpZrdj/U3tpxBJD/N9PT91O17xqyBLHjELzE+Qsaanymd/65aWgu9cfLHD+Np5GrmHrQ74ydKqJ1utOo4hiuyVO41vWeVP5nuzbZpQAEOOMXkyO2h/4iPgPTGSP3OJC+BfqlT2uhjFUO+WmNTeS35AHTO5b0WiudlAczTPuWGPRdxQKRCuW0VfCR9rWGjl1ZakOoQ4T07u4AwFQnzKUmqgJPJ7scpnJGNuz6qNMjTXpxWIBx11JrCLOHotRu/SRfoz1qjTvvnh9H2bAxz1JwR27yjsfhYHoh5J1bHUV/Fop/x7RpCl0MR
 WSYAuolh
 RXnNxJid1xogka3CXDpsNgzRJSrwpjmQbW1mAONofA8PTL4Biw6oi9AVRuUr3cw0CGRdr8Qs2Tk5+C/FrEc9R7G+r1YbXsTiJjnfsvS/zGrQ6OzvFxTceTfhu4PqiPkCIcDY/0dXeLYq0jPe5vNBw2nQ/PCxp4mFVzxH4tRQiTM+IZpxJUGmsNaqGijLMLz/WBvCiGbkgh3nHPPMQptV1UrW0vZGxBHjsPSIhz7WL4K/871JjJv6JQU1gKP3XQKbE/rQ68Eohhpk1keEiRfESfE7NsnWXhVyUOrVUZzc5gF4/hU0vXU/YYMLV7326RE7OxzQWQ5RA8JFmX6BeW+rxR06ZqfPWTPK6x861A9KLApMoW65dCh1/G4em8OE4F4OnPy24+bWedZgv3tWj9uokvoyJ0OHBzrp8AWzb1VvQ7nY0TxAFpP6W9L9wyq5h8zT9j20/JovNClj90yZy05Mpt9cZiABskdkoykIpL0l/7flcDleu2sPeqt+bES9EQDcNNVak0PSLcjs/4o3GfoRbgkQ80z0oCl/n5B9rshdeNRUKmdo2ZHY2i1xA5XFobkY59RTOOBfaSSiXnD+fRQjclrkfL8XrN0soZgv/SB5KghfhxV5JF3/Pxo5g9vfvlsmOHhJt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Overview
This patch series introduces a dynamic, NUMA-aware HugePage Cache,
backed by a kernel shrinker to safely return memory under pressure, and
integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
specifically targeting gigantic (1GB) hugepages. The goal is to solve
the tradeoff between allocation latency and memory
fungibility in virtualized and heterogeneous cloud environments.

---

The Core Problem: Allocation Latency vs. Memory Fungibility

With highly heterogeneous workloads, latency-critical applications demand
gigantic hugepages. However, dynamic runtime allocation of 1GB pages
from the buddy allocator (via CMA) is slow.

To bypass this latency, operators often pre-allocate hugepages
statically. However, this locks up the memory: when the HugeTLB
workloads are idle, that memory is completely unavailable for other
buddy-allocator workloads (e.g., page cache, anonymous memory). If buddy
memory is exhausted, the system will OOM even if gigabytes of HugeTLB
pages are sitting idle.

This series resolves this challenge by delivering Dynamic Fungibility:

1.  Dynamic Caching: Intercepts freed surplus hugepages and recycles
    them into a NUMA-aware cache instead of dissolving them immediately.
2.  Fast Allocations: Satisfies subsequent dynamic allocations
    instantly from this warm, local hugepage cache.
3.  Kernel Shrinker Integration: Registers a NUMA-aware kernel shrinker
    to dynamically dissolve cached pages back to the buddy allocator
    under memory pressure, restoring host/guest memory fungibility.
4.  Free Page Reporting Integration: For virtualized environments (Guest
    VMs), cached pages trigger background Free Page Reporting via
    virtio-balloon. This allows the host to reclaim the physical memory
    while the guest retains its Vmemmap Optimization (HVO) metadata
    savings (~14GB saved per 1TB VM)!

  +---------------+   Slow Allocate  +---------------------+
  | Buddy         | ---------------> | Active HugeTLB Page |
  | Allocator     |                  +---------------------+
  +---------------+                    |                ^
    ^                                  | (1) Free to    | (2) Fast
    | (3) Under                        v     Cache      |     Allocate
    | Pressure                       +---------------------+
    | Shrink()  <------------------- | HugeTLB Cache       |
                                     +---------------------+
                                       |
                                       v (4) Free Page Reporting
                                         (Host Reclaim in the case
                                          of virtualization)

---

Patch Series Structure

Patch 1/6: mm/hugetlb: add Kconfig and basic cache infrastructure
  - Introduces the CONFIG_HUGETLB_CACHE option, hstate tracking fields,
    and the HPG_cached page flag.
  - Establishes the clean helper API (hugetlb_folio_is_cached(),
    hugetlb_cache_remove(), hugetlb_cache_add()) and updates
    remove_hugetlb_folio() to be cache-aware, eliminating inline #ifdef
    blocks.
Patch 2/6: mm/hugetlb: implement cache recycling and allocation
  - Hooks up recycling in free_huge_folio() (up to the cache limit) and
    allocation in alloc_surplus_hugetlb_folio().
  - Implements MRU allocation policy for maximum warmth, poison safety
    checks, and MTE/dcache cleaning.
Patch 3/6: mm/hugetlb: add sysfs interfaces for cache
  - Exposes global and per-node sysfs attributes (max_cached_huge_pages,
    nr_cached_hugepages) for dynamic userspace control, including NUMA
    memory policy scaling.
  - Supports dynamic delta adjustments (+1/-1) to safely scale cache
    sizes alongside concurrent background reclaim operations.
Patch 4/6: mm/hugetlb: add memory shrinker for cache
  - Registers a NUMA-aware kernel shrinker to evict and dissolve cached
    gigantic pages back to buddy under memory pressure.
Patch 5/6: Documentation/admin-guide/mm/hugetlbpage.rst: document cache
    interfaces
  - Documents the Kconfig option, sysfs attributes, and shrinker
    behavior in the admin guide.
Patch 6/6: mm/hugetlb: support free page reporting for cached hugepages
  - Integrates the cache with the Free Page Reporting framework (virtio-
    balloon), introducing the HPG_reported flag and the
    reporting/isolation/draining lifecycle.
Sourav Panda (6):
  mm/hugetlb: add Kconfig and basic cache infrastructure
  mm/hugetlb: implement cache recycling and allocation
  mm/hugetlb: add sysfs interfaces for cache
  mm/hugetlb: add memory shrinker for cache
  Documentation/admin-guide/mm/hugetlbpage.rst: document cache
    interfaces
  mm/hugetlb: support free page reporting for cached hugepages

 Documentation/admin-guide/mm/hugetlbpage.rst |  34 +-
 fs/Kconfig                                   |   9 +
 include/linux/hugetlb.h                      |  45 ++
 include/linux/page_reporting.h               |   1 +
 mm/hugetlb.c                                 | 590 ++++++++++++++++++-
 mm/hugetlb_internal.h                        |   9 +
 mm/hugetlb_sysfs.c                           | 158 +++++
 mm/page_reporting.c                          |  10 +-
 mm/page_reporting.h                          |   6 +
 9 files changed, 844 insertions(+), 18 deletions(-)

-- 
2.55.0.rc0.799.gd6f94ed593-goog



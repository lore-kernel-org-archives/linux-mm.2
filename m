Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EA7D1D493
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28F06B0088; Thu,  8 Jan 2026 15:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01646B0089; Thu,  8 Jan 2026 15:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD51E6B0092; Thu,  8 Jan 2026 15:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB8816B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:38:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7DCE1A02D2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:38 +0000 (UTC)
X-FDA: 84309959916.03.2AC0A32
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id D231218000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eLUy6o2b;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767904716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W+FiscnY2dd9CMZcfeOt+saJiVQsfJ0OYuH1fa+Xrtc=;
	b=d8UvUTrnnPDNRiy/1mRUwSrIiEbEnVurN4VK6I+IpEcdR/Vgtf5VLcJ4iE1qW2bmivQuz3
	KihRwsNFYgELwiq2OuUoLk07mExwo9XwrHxvz5xg/ZnF7WEZWXT23yFNudr1WQET2GmG2n
	bEiMh3SwtUzMp9BHjMob+6RW0skk9dQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767904716; a=rsa-sha256;
	cv=none;
	b=rxiA3llP7avcz1j/ZxOVX48CDDnjjoZQjgy0hjoYCKK5VOTdOJ9WH/G4hFG/y3z9Zr5W/m
	wVLtHdfgGd4s0vSHbZWWdleOuDsbAWt+EMGIeNEgA18xBTX7QWKdqQRmXvaqAZgpRkmEFv
	tB9O0ZGa1rNFbLd2AJtLAX56qoZkwM8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eLUy6o2b;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4eda6c385c0so26327021cf.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767904715; x=1768509515; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W+FiscnY2dd9CMZcfeOt+saJiVQsfJ0OYuH1fa+Xrtc=;
        b=eLUy6o2b/tPuh0GeMiMQcfOGQCc/8yXHbrXw4wYmktzlgwTp96EaYD6LyIUjyAFy0F
         Q/n/Zig5ou8CtEbErjWc6cZQ1gggKJOtI38SDRRRZhCJ9VI2+p4XQCvIgACZ3rqZ7iVu
         BR2pET+aJ/ith9/9XQ1SVrzwXpceA5KXfLCaV0VdNv5uJBSxf1+xaOtQk1KHlN+c4S1A
         vihOg1os6GJNLH4mID+I/yofQCYb027FxMpIhB+RRgOyJsKsO1aoImKjkw71MH1fhfxC
         2xMnIvDgABchmlkmNbXSuM8J7k8ZyIlzvtifszIdXh6XYz2jMZLtb4IxEoWGA0BR8WcH
         pXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904715; x=1768509515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+FiscnY2dd9CMZcfeOt+saJiVQsfJ0OYuH1fa+Xrtc=;
        b=M9EOSMwJuMrsqaKBXwCxEdZr7+Mkffp8vozuySXppBlbEwIcARDW3bAIMmA7OxCTp1
         jvKufVWR/Q1JsvBShaeSND1RwR6waup0cevxFGq93WvYfBL9MZUpD1ABTNRN1LZFSDIQ
         HfRZ/q/KIcAScrelkZT4Ph/l8LQywlkykn61jFpBw+fyc8l27s1N/SEwe8AMuB7PUZ/3
         f3NUjpBBClw6npeSO95HMIMxhjoTALbBGZjF/ao5bHL63IKu4wMSAAewuBxcWTBKt9rH
         ZNCo41XDVJeF39a6g4zM7iflPypLdxvZyph8T599NlDzwnf43kPGreYvRIb4g1hkBnoC
         WxTA==
X-Gm-Message-State: AOJu0YyBOozHIbYJlnrtzeNboHbPvlN8xx01a6YzYk2eEMi5MjmDFUyn
	KMaR6J3W1zs6ocND4dcab+iqiYs2ScTcA4lsz1CKTvYM2/sTOVz8LPnsEkfC4gAZjJY9kaGzpkB
	ZZkO+
X-Gm-Gg: AY/fxX6L49ROZAG0FJnT4um8XT0WL2sbHI+yiycn0A2OM+pTZjoaS6Ph4K8ZOPpny/u
	9rLwKcCHo25pTShmAp6u8bDHb9UY4nTy2VZLQwf+8BjSXHy2B4fn0YJGHhKGoP3/QhF9Y1WGqxP
	WNzr23j3K2oawWqQ9hS12m8nMJhxrqzSiWllzxmp8eE4+EaqxFRWCGzmVq79EP0D+NKucUG61yK
	hBHqWSNejQjwSvvPTnuZQlU7wfM3qJAD1O5kzRKtR5ydLbhZ3qqJ5L3Zk3J4egc3OL3ACYA1O+g
	LA7X7ZhoLM1i57Oitd14+RLRGOYL05edKQj9ZXrMIq9huvwLnOgiWxcuYXbdG0pmPGrr/rLJn6d
	senHxhbCRrefiFqnwuzplsuBCzDsbSWMYzO9FHlhrjPxyqQ3kxinSQDybWB9v/fpv5NOeD4AHaP
	ARJS9scR0HwzGaJnFAGvA3ubYs2wTyzQC38phaWbNE5Nz/MUvCh8LciGEzPhuOepCKIl5BxVLsy
	YU=
X-Google-Smtp-Source: AGHT+IGgVKMRufuoIwNk6V89uYwrjMlLk/itQMcGhMZDRBQvLjiXAI9ku2u4EWxqz6DDG1P/QUPQlA==
X-Received: by 2002:a05:622a:181e:b0:4ee:49b8:fb81 with SMTP id d75a77b69052e-4ffb4a26a6dmr88539831cf.61.1767904715304;
        Thu, 08 Jan 2026 12:38:35 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:38:34 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	zhengqi.arch@bytedance.com
Subject: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for device-managed memory
Date: Thu,  8 Jan 2026 15:37:47 -0500
Message-ID: <20260108203755.1163107-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D231218000E
X-Rspam-User: 
X-Stat-Signature: ic9hzbb9t5eup5onuagjgcogdcpju6ed
X-HE-Tag: 1767904716-806398
X-HE-Meta: U2FsdGVkX19sS+A3OXnACCPRvNeVyL4Ti4NymVR9maweioa5oxnU/ixYm8lLpoYLw5/gnN85C0UIEkFhoLt02YBO7ne2Ksm0Nppt7LRAeHVppmc4BUorbGPO3apNN9Fjfe2jk7cEkCLhRLXi/85WNQj9kkOevo7wKn9l7iL9mjd7p7WuE/MLvyzlknLkh26dGnun9gz60Ung0QvMhSlE1s/1FTjDweOJgZpgYDJen0qjb34IR55kijnr9O8+SqAOqG+fhT1bTUg7OiuZDD5HY39BLH0kL2cFqYIchiSzSWI/ZGc876EA63fkHSkgT4K+Rl0jZJN14JuH5fXvlExgv5eRvNADKMl1tGGpD8WrxpFp/V3fsIsWim5TfvxZsJ85HbLHXYTSCxcBmPV2Rno5/eghkJm8UZx+5ANC9nU3kWvVnTQt3bawvJdLaJfguITByu+icL2BD/x3PDfRsrurWG97yP/txwhZ0OEv+eBOraY27dU8ddwhZUoikIlwi82Q11h6cTssk9Vbk6el2fM7RjODTlDx+rBTxZfOfKpm81JaW2ENn5wwyvHwuS3aZo+NLgIwBKEm2N1ansXhu3msY9kk2PZLb1f83sOhg997tpSnXQY4cLXRKgi5S8a8xtcOAKt7xiWoFksNdU2d1JUTaCfX+IxKoWQmOUBXUDGUVfSkN3DexP6mF8CeTswlmuGHz+8BfXGB/WfNU9w+jeNg0nyBb2wxTxG0OZXtLX1HCqGLUXn7SAcxaGISAegrTbPbbIXABOp/IbgN9iJfSM8wrHx4BCoUOlXeiauNpBJMG0PfN+mafbkeFN9fgaUW7ABGiSF5MGISQ2jq6HfJXsyzkr1z8ap07T6JYwjJblc9BMrZ2KFDzgRjFru7EosMp3VExR+fWVpNtVAYELMdPEmXtbSaE95FlCioiyFcFrHUZN0kpc5S3kgvwwl5nHT11EZTmnrcnwZlI0s+h8/rAwS
 SrHsASJK
 NfBgznJy0T4X1cAmd6b1dZDCpD+n6vCz8oc9ELvrKNUogXAVuLCoiPGX/ZCTvK0cOTVIPVXgl/ZKvIB6ESnx39ALF1uTn5OAjo1JdHvHjIipFZZc7yi8F5FCR+svlB7213fgVUB6bAMwo+EXtwFD289jy6gmWegN4ukYrm9BxEgH8pyTGXAxpUfu7jD2UdurPF93MZMTLeWL0oWYU+M+Rc12kwBtBKIovo8R69j0JXHt8hFUrqRPU8ur4Xi7fVC0JhSlbzM3RZ9tLgnkDVM28mLMxc6WTfyrjDr3AVP0vRBY6Zop4spnZuG34Qc6NSUqeQiVnD7+ZnVZ1lyVv8H/+A/0PHX3b6BLTAWjE653FfvT7tfk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces N_PRIVATE, a new node state for memory nodes 
whose memory is not intended for general system consumption.  Today,
device drivers (CXL, accelerators, etc.) hotplug their memory to access
mm/ services like page allocation and reclaim, but this exposes general
workloads to memory with different characteristics and reliability
guarantees than system RAM.

N_PRIVATE provides isolation by default while enabling explicit access
via __GFP_THISNODE for subsystems that understand how to manage these
specialized memory regions.

Motivation
==========

Several emerging memory technologies require kernel memory management
services but should not be used for general allocations:

  - CXL Compressed RAM (CRAM): Hardware-compressed memory where the
    effective capacity depends on data compressibility.  Uncontrolled
    use risks capacity exhaustion when compression ratios degrade.

  - Accelerator Memory: GPU/TPU-attached memory optimized for specific
    access patterns that are not intended for general allocation.

  - Tiered Memory: Memory intended only as a demotion target, not for
    initial allocations.

Currently, these devices either avoid hotplugging entirely (losing mm/
services) or hotplug as regular N_MEMORY (risking reliability issues).
N_PRIVATE solves this by creating an isolated node class.

Design
======

The series introduces:

  1. N_PRIVATE node state (mutually exclusive with N_MEMORY)
  2. private_memtype enum for policy-based access control
  3. cpuset.mems.sysram for user-visible isolation
  4. Integration points for subsystems (zswap demonstrated)
  5. A cxl private_region example to demonstrate full plumbing

Private Memory Types (private_memtype)
======================================

The private_memtype enum defines policy bits that control how different
kernel subsystems may access private nodes:

  enum private_memtype {
      NODE_MEM_NOTYPE,      /* No type assigned (invalid state) */
      NODE_MEM_ZSWAP,       /* Swap compression target */
      NODE_MEM_COMPRESSED,  /* General compressed RAM */
      NODE_MEM_ACCELERATOR, /* Accelerator-attached memory */
      NODE_MEM_DEMOTE_ONLY, /* Memory-tier demotion target only */
      NODE_MAX_MEMTYPE,
  };

These types serve as policy hints for subsystems:

NODE_MEM_ZSWAP
--------------
Nodes with this type are registered as zswap compression targets.  When
zswap compresses a page, it can allocate directly from ZSWAP-typed nodes
using __GFP_THISNODE, bypassing software compression if the device
provides hardware compression.

Example flow:
  1. CXL device creates private_region with type=zswap
  2. Driver calls node_register_private() with NODE_MEM_ZSWAP
  3. zswap_add_direct_node() registers the node as a compression target
  4. On swap-out, zswap allocates from the private node
  5. page_allocated() callback validates compression ratio headroom
  6. page_freed() callback zeros pages to improve device compression

Prototype Note:
  This patch set does not actually do compression ratio validation, as
  this requires an actual device to provide some kind of counter and/or
  interrupt to denote when allocations are safe.  The callbacks are
  left as stubs with TODOs for device vendors to pick up the next step
  (we'll continue with a QEMU example if reception is positive).

  For now, this always succeeds because compressed=real capacity.

NODE_MEM_COMPRESSED (CRAM)
--------------------------
For general compressed RAM devices.  Unlike ZSWAP nodes, CRAM nodes
could be exposed to subsystems that understand compression semantics:

  - vmscan: Could prefer demoting pages to CRAM nodes before swap
  - memory-tiering: Could place CRAM between DRAM and persistent memory
  - zram: Could use as backing store instead of or alongside zswap

Such a component (mm/cram.c) would differ from zswap or zram by allowing
the compressed pages to remain mapped Read-Only in the page table.

NODE_MEM_ACCELERATOR
--------------------
For GPU/TPU/accelerator-attached memory.  Policy implications:

  - Default allocations: Never (isolated from general page_alloc)
  - GPU drivers: Explicit allocation via __GFP_THISNODE
  - NUMA balancing: Excluded from automatic migration
  - Memory tiering: Not a demotion target

Some GPU vendors want management of their memory via NUMA nodes, but
don't want fallback or migration allocations to occur.  This enables
that pattern.

mm/mempolicy.c could be used to allow for N_PRIVATE nodes of this type
if the intent is per-vma access to accelerator memory (e.g. via mbind)
but this is omitted from this series from now to limit userland
exposure until first class examples are provided.

NODE_MEM_DEMOTE_ONLY
--------------------
For memory intended exclusively as a demotion target in memory tiering:

  - page_alloc: Never allocates initially (slab, page faults, etc.)
  - vmscan/reclaim: Valid demotion target during memory pressure
  - memory-tiering: Allow hotness monitoring/promotion for this region

This enables "cold storage" tiers using slower/cheaper memory (CXL-
attached DRAM, persistent memory in volatile mode) without the memory
appearing in allocation fast paths.

This also adds some additional bonus of enforcing memory placement on
these nodes to be movable allocations only (with all the normal caveats
around page pinning).

Subsystem Integration Points
============================

The private_node_ops structure provides callbacks for integration:

  struct private_node_ops {
      struct list_head list;
      resource_size_t res_start;
      resource_size_t res_end;
      enum private_memtype memtype;
      int (*page_allocated)(struct page *page, void *data);
      void (*page_freed)(struct page *page, void *data);
      void *data;
  };

page_allocated(): Called after allocation, returns 0 to accept or
-ENOSPC/-ENODEV to reject (caller retries elsewhere).  Enables:
  - Compression ratio enforcement for CRAM/zswap
  - Capacity tracking for accelerator memory
  - Rate limiting for demotion targets

page_freed(): Called on free, enables:
  - Zeroing for compression ratio recovery
  - Capacity accounting updates
  - Device-specific cleanup

Isolation Enforcement
=====================

The series modifies core allocators to respect N_PRIVATE isolation:

  - page_alloc: Constrains zone iteration to cpuset.mems.sysram
  - slub: Allocates only from N_MEMORY nodes
  - compaction: Skips N_PRIVATE nodes
  - mempolicy: Uses sysram_nodes for policy evaluation

__GFP_THISNODE bypasses isolation, enabling explicit access:

  page = alloc_pages_node(private_nid, GFP_KERNEL | __GFP_THISNODE, 0);

This pattern is used by zswap, and would be used by other subsystems
that explicitly opt into private node access.

User-Visible Changes
====================

cpuset gains cpuset.mems.sysram (read-only), shows N_MEMORY nodes.

ABI: /proc/<pid>/status Mems_allowed shows sysram nodes only.

Drivers create private regions via sysfs:
  echo region0 > /sys/bus/cxl/.../create_private_region
  echo zswap > /sys/bus/cxl/.../region0/private_type
  echo 1 > /sys/bus/cxl/.../region0/commit

Series Organization
===================

Patch 1: numa,memory_hotplug: create N_PRIVATE (Private Nodes)
  Core infrastructure: N_PRIVATE node state, node_mark_private(),
  private_memtype enum, and private_node_ops registration.

Patch 2: mm: constify oom_control, scan_control, and alloc_context 
nodemask
  Preparatory cleanup for enforcing that nodemasks don't change.

Patch 3: mm: restrict slub, compaction, and page_alloc to sysram
  Enforce N_MEMORY-only allocation for general paths.

Patch 4: cpuset: introduce cpuset.mems.sysram
  User-visible isolation via cpuset interface.

Patch 5: Documentation/admin-guide/cgroups: update docs for mems_allowed
  Document the new behavior and sysram_nodes.

Patch 6: drivers/cxl/core/region: add private_region
  CXL infrastructure for private regions.

Patch 7: mm/zswap: compressed ram direct integration
  Zswap integration demonstrating direct hardware compression.

Patch 8: drivers/cxl: add zswap private_region type
  Complete example: CXL region as zswap compression target.

Future Work
===========

This series provides the foundation.  Planned follow-ups include:

  - CRAM integration with vmscan for smart demotion
  - ACCELERATOR type for GPU memory management
  - Memory-tiering integration with DEMOTE_ONLY nodes

Testing
=======

All patches build cleanly.  Tested with:
  - CXL QEMU emulation with private regions
  - Zswap stress tests with private compression targets
  - Cpuset verification of mems.sysram isolation


Gregory Price (8):
  numa,memory_hotplug: create N_PRIVATE (Private Nodes)
  mm: constify oom_control, scan_control, and alloc_context nodemask
  mm: restrict slub, compaction, and page_alloc to sysram
  cpuset: introduce cpuset.mems.sysram
  Documentation/admin-guide/cgroups: update docs for mems_allowed
  drivers/cxl/core/region: add private_region
  mm/zswap: compressed ram direct integration
  drivers/cxl: add zswap private_region type

 .../admin-guide/cgroup-v1/cpusets.rst         |  19 +-
 Documentation/admin-guide/cgroup-v2.rst       |  26 ++-
 Documentation/filesystems/proc.rst            |   2 +-
 drivers/base/node.c                           | 199 ++++++++++++++++++
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/core.h                       |   4 +
 drivers/cxl/core/port.c                       |   4 +
 drivers/cxl/core/private_region/Makefile      |  12 ++
 .../cxl/core/private_region/private_region.c  | 129 ++++++++++++
 .../cxl/core/private_region/private_region.h  |  14 ++
 drivers/cxl/core/private_region/zswap.c       | 127 +++++++++++
 drivers/cxl/core/region.c                     |  63 +++++-
 drivers/cxl/cxl.h                             |  22 ++
 include/linux/cpuset.h                        |  24 ++-
 include/linux/gfp.h                           |   6 +
 include/linux/mm.h                            |   4 +-
 include/linux/mmzone.h                        |   6 +-
 include/linux/node.h                          |  60 ++++++
 include/linux/nodemask.h                      |   1 +
 include/linux/oom.h                           |   2 +-
 include/linux/swap.h                          |   2 +-
 include/linux/zswap.h                         |   5 +
 kernel/cgroup/cpuset-internal.h               |   8 +
 kernel/cgroup/cpuset-v1.c                     |   8 +
 kernel/cgroup/cpuset.c                        |  98 ++++++---
 mm/compaction.c                               |   6 +-
 mm/internal.h                                 |   2 +-
 mm/memcontrol.c                               |   2 +-
 mm/memory_hotplug.c                           |   2 +-
 mm/mempolicy.c                                |   6 +-
 mm/migrate.c                                  |   4 +-
 mm/mmzone.c                                   |   5 +-
 mm/page_alloc.c                               |  31 +--
 mm/show_mem.c                                 |   9 +-
 mm/slub.c                                     |   8 +-
 mm/vmscan.c                                   |   6 +-
 mm/zswap.c                                    | 106 +++++++++-
 37 files changed, 942 insertions(+), 91 deletions(-)
 create mode 100644 drivers/cxl/core/private_region/Makefile
 create mode 100644 drivers/cxl/core/private_region/private_region.c
 create mode 100644 drivers/cxl/core/private_region/private_region.h
 create mode 100644 drivers/cxl/core/private_region/zswap.c
---
base-commit: 803dd4b1159cf9864be17aab8a17653e6ecbbbb6

-- 
2.52.0


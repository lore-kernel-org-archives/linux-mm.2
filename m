Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 948E1FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5096B0088; Thu, 30 Apr 2026 04:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A660C6B008A; Thu, 30 Apr 2026 04:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CC66B008C; Thu, 30 Apr 2026 04:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 868CC6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:47:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23BCE160533
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:47:12 +0000 (UTC)
X-FDA: 84714592704.04.92FAEDF
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf24.hostedemail.com (Postfix) with ESMTP id F0E2C18000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:47:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MaG+tVmq;
	spf=pass (imf24.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777538830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+NygFpZCjew1XeWMBdTJLjG0JrwpgBTum7ciRNGxLY=;
	b=CHzimOo91WOVrRVhq7F6EZwxRYYWuwNJNCx0T0eiTLgeqgAl9qjdXmDnbgk2hS/7p3nbf8
	MteqO0ROQ9TGi4KrBQkjkexDkmH3Pkt9ZOb7nBeW+dP2qgAlaiBFYMMEBW0XoDbh7Kipdf
	Q0ea68HT2mZpuCC4E9iqa988XVt2A/E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MaG+tVmq;
	spf=pass (imf24.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777538830; a=rsa-sha256;
	cv=none;
	b=L2MSrlsfRqXOFrIX7wjCcQZXTX82W72X34C48mtBFxzKd7k2Xc9ahve7VvhDkYIpd7YF13
	QS5C74nJjlFNF3o/yX0/QPFrZAMCQh7KGT8GHIFZMPSn75vUDdoYdtIJRDl3YxfxZ6RN+c
	l8iOkUBJUTz7NTVOdlmYC5APB6Iqgc0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777538825; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=3+NygFpZCjew1XeWMBdTJLjG0JrwpgBTum7ciRNGxLY=;
	b=MaG+tVmqRfhCSJgdk/KdaXdqPGrF2jCTO7gp/2+5X38MzldakzPDYr13X4bH1FwTeqgHM0j00YrhYlYQy8VXTYjWkTQ+LASsCOK0LJC0zOoBopa/yLba3bQVJ82n/ssOjqh0KYj9uBTkUUHfEAGFw+PoAD3BdG2LjND/TII342w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2-T4-8_1777538822;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2-T4-8_1777538822 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Apr 2026 16:47:03 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,
  <kinseyho@google.com>,  <weixugc@google.com>,  <ljs@kernel.org>,
  <Liam.Howlett@oracle.com>,  <vbabka@kernel.org>,  <willy@infradead.org>,
  <rppt@kernel.org>,  <surenb@google.com>,  <mhocko@suse.com>,
  <ziy@nvidia.com>,  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <dave@stgolabs.net>,
  <Jonathan.Cameron@huawei.com>,  <rkodsara@amd.com>,  <vkoul@kernel.org>,
  <bharata@amd.com>,  <sj@kernel.org>,  <rientjes@google.com>,
  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <dave.hansen@intel.com>,  <hannes@cmpxchg.org>,  <jhubbard@nvidia.com>,
  <peterx@redhat.com>,  <riel@surriel.com>,  <shakeel.butt@linux.dev>,
  <stalexan@redhat.com>,  <tj@kernel.org>,  <nifan.cxl@gmail.com>,
  <jic23@kernel.org>,  <aneesh.kumar@kernel.org>,  <nathan.lynch@amd.com>,
  <Frank.li@nxp.com>,  <djbw@kernel.org>,  <linux-kernel@vger.kernel.org>,
  <linux-mm@kvack.org>
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
In-Reply-To: <20260428155043.39251-2-shivankg@amd.com> (Shivank Garg's message
	of "Tue, 28 Apr 2026 15:50:37 +0000")
References: <20260428155043.39251-2-shivankg@amd.com>
Date: Thu, 30 Apr 2026 16:47:01 +0800
Message-ID: <87zf2kvnqy.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: F0E2C18000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 7qjhecdzhw5eensqu5oyt8nxkty97kaj
X-HE-Tag: 1777538828-972407
X-HE-Meta: U2FsdGVkX19oI8eMmv00CWFUoZrXQwXImbAg6vTdruIAEGgVoDw5S86Lw88MKq+RKuGr5gO1MkICT3w7jlciJWBrihIg6z7FBrNVszBdFbIFK2NqzzTnZl7fXOuLXUPSVV/XMIy9UVRSWSSnkKKqkHMC0NRhrbG1w8i3S+FgQqC3v2DB3i5thzdDaY7qmCLwzz3ZOdc5FASnFkfQzbp93fIuzZc9kGEYHxbuZDT0IYqrvSEUhc811xl7W8ZMGLhig5tLZc1+awT0v4pMRzxLyOpCDf8ujcFVbyKfEa1bKXYi9vhhjIAwPXAatG4rwWfDtq1awonEjEjUrKjtetsTs5v+EwlIi9rHhj3Da/c01mP6tWc0yygj0bb0g8XLFPmhaEzcnwCrixGgiF8CmVrtM9krB4qhY/Z/LVxOrhhDxJcY1FYhQAcQy4p56d0bv38lhHCRlvR1bLwnb2/ahXdlYjdvLVXA36l0ZUs0xqCtHEATd1ZE3ij5NhqIdPRZuhVhrF57IKB2ekMKrxjlebtxVALjm4UONDXHosQqfWjTVN5S3kscRuDj6OEbcbmsr58jnfEfu2qmaMaug4kEKwCVMvHIFaFYX79ouAl3TaMe+omDAYoO6a1w4Jpks4Zp7z5eQWUlzo8ETkwLLOOIC/359z8pyEhwVt/j3aWB2Pa9XGRjTW145RNn4NbPAzDEVCaa6zZsn7Ukh3O7YCNFkXoOxKHKJxBUCtcvIQCXHctA8UhiEPbdabtQeetLZWy8Qe7jtDbIEpYAkyC6phKjSFBLkM+QRtWwCAvegQ44oxv9j4cz6CDKFdvEGtEcambEgbdKGlOCDjEkJ/ycB9LaqxFlNBS+Od7rA2wkCB1S6u1eiE0bsD8P+auTWRz7cVxEGBqN9U/VxH7L5qfK/XKfvAa/MBR0wARJW5lKmeAuVwDR6rYhaTQifukYSGOPGfLHDzkQJ/uBhDhj/tkPqDx6Ykg
 Q3xMPws5
 MvThL8RdLVRL7jfNqy6twApbSSFUjYAwaYtr7S7nWmx4jmzyUqzRSaykWILGLbRGXJYCi6UT0fMJo9LB3Y9t17wv0cTULcTEGac+5My4kuJZBTmORG5NscD6RF95zOdcYFOtzTY/c6BPksXzzqAmZwb2iIcxvMeh/qxB1nTMHeTiRb99/bbBbe3VEzfebDSaStvcPYfXx60O9+rB3oebrlE4yC9lY1yOhDvhgvDUp3s1tTfR6obdGdlbf+EZWCGKiKVy8b+dC2UbPXhoEZZ19amkT/8eJjAjgBNIK02PURy/NE2vK2H+3T7M87GFpg2aT0icv9uMBkNeXFfsO4voMF5vfuNglBw7JxeLt6gljni9mWXpfMb9oUzNsFzS7hPm89SPMvaVovZtTuVtdhEP+Zlj6+rxn8TXlsCd5irHDfNsnvYkaZX26OSrPBmsrKR1DvAzXI1Mcnvl0gqzVGtKYqeZwwVdPUgc/WrU3gQs88eUMFH7J1O13vJEc6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shivank Garg <shivankg@amd.com> writes:

> This is the fifth RFC of the patchset to enhance page migration by
> batching folio-copy operations and enabling acceleration via DMA offload.
>
> Single-threaded, folio-by-folio copying bottlenecks page migration in
> modern systems with deep memory hierarchies, especially for large folios
> where copy overhead dominates, leaving significant hardware potential
> untapped.
>
> By batching the copy phase, we create an opportunity for hardware
> acceleration. This series builds the framework and provides a DMA
> offload driver (dcbm) as a reference implementation, targeting bulk
> migration workloads where offloading the copy improves throughput
> and latency while freeing the CPU cycles.
>
> See the RFC V3 cover letter [2] for motivation.
>
> Changelog since V4:
> -------------------
>
> 1. Renamed PAGE_* migration state flags to FOLIO_*. (David)
> 2. Use the new folio->migrate_info field instead of folio->private
>    for migration state. (David)
> 3. Fold folios_mc_copy patch in batch-copy implementation patch. (David)
> 3. Renamed migrate_offload_start()/stop() to register()/unregister().
>    (Huang, Ying)
> 4. Dropped should_batch() callback from struct migrator. Reason-based
>    policy now lives in migrate_pages_batch(). Migrators can still skip
>    a batch they don't want (size based policy). (Huang, Ying)
> 5. CONFIG_MIGRATION_COPY_OFFLOAD is now hidden and selected by the
>    migrator driver. CONFIG_DCBM_DMA is tristate. (Huang Ying, Gregory Price). 
> 6. Wrapped the SRCU + static_call dispatch in a small helper. (Huang, Ying)
> 7. Requir m->owner in migrate_offload_register(), SRCU sync at
>    unregister relies on it. Counters are atomic_long_t to avoid lock-order
>    issue.
> 9. Moved DCBM sysfs from /sys/kernel/dcbm to /sys/module/dcbm (Huang, Ying) 
> 10. Rebased on v7.1-rc1.
>
>
> DESIGN:
> -------
>
> New Migration Flow:
>
> [ migrate_pages_batch() ]
>     |
>     |--> do_batch = migrate_offload_do_batch(reason)  // core filters by migration reason
>     |
>     |--> for each folio:
>     |      migrate_folio_unmap()        // unmap the folio
>     |      |
>     |      +--> (success):
>     |           if do_batch && folio_supports_batch_copy():
>     |               -> unmap_batch / dst_batch  // batch list for copy offloading
>     |           else:
>     |               -> unmap_single / dst_single // single lists for per-folio CPU copy
>     |
>     |--> try_to_unmap_flush()                   // single batched TLB flush
>     |
>     |--> Batch copy (if unmap_batch not empty):
>     |    - Migrator is configurable at runtime via sysfs.
>     |
>     |      static_call(migrate_offload_copy)    // Pluggable Migrators
>     |              /          |            \
>     |             v           v             v
>     |     [ Default ]  [ DMA Offload ]  [ ... ]
>     |
>     |      On -EOPNOTSUPP or other error, batch falls back to per-folio CPU copy.
>     |
>     +--> migrate_folios_move()      // metadata, update PTEs, finalize
>          (batch list with already_copied=true, single list with false)
>
> Offload Registration:
>
>     Driver fills struct migrator { .name, .offload_copy, .owner } and calls
>     migrate_offload_register().  This:
>       - Pins the module via try_module_get()
>       - Patches the migrate_offload_copy() static_call target
>       - Enables the migrate_offload_enabled static branch
>
>     migrate_offload_unregister() disables the static branch and reverts
>     the static_call, then synchronize_srcu() waits for in-flight migrations
>     before module_put().
>
> PERFORMANCE RESULTS:
> --------------------
>
> Re-ran the V4 workload on v7.1-rc1 with this series; relative
> speedups match V4 (~6x for 2MB folios at 16 DMA channels). No design
> change in V5 alters this picture; please refer to the V4 cover letter
> for the throughput tables [1].

IMHO, it's better to copy performance data here.

In addition to the performance benefit, I want to know the downside as
well.  For example, the migration latency of the first folio may be
longer.  If so, by how much?  Can you measure the batch number vs. total
migration time (benefit) and first folio migration time (downside)?
That can be used to determine the optimal batch number.

> PLAN:
> -----
>
> Patches 1-4 (the batching infrastructure) don't depend on the migrator
> interface, so if it helps I can split them off and post them ahead of
> the migrator and DCBM bits, which still have a few open questions to
> work through.
>
> I would appreciate guidance on splitting the infrastructure portion
> ahead of the migrator interface if that matches maintainers' preference.
>
> OPEN QUESTIONS:
> ---------------
>
> 1. Should the batch path run without a registered migrator? Patches 1-4
>    are self-contained and use folios_mc_copy() (CPU). I have several
>    options like making batch path always-on for eligible folios, or
>    giving admin an option to flip the static branch, or keep the gate.
>    I'm leaning toward always-on.
>
> 2. Carrying already_copied via folio->migrate_info vs changing the
>    migrate_folio() callback signature (Huang, Ying). I went with the
>    field for now to avoid touching every fs callback before the design
>    settles. Happy to revisit.
>
> 3. Per-caller offload selection: Today eligibility is by migrate_reason
>    only. Some are latency-tolerant, others may be not. Is reason the
>    right granularity, or do we want a per-caller hint?
>
> 4. Cgroup integration: How should per-cgroup be accounted for different
>    migrators (e.g.: any accounting for DMA-busy time)?
>
> 5. Tuning migrate_pages callers for offloading. For instance, in
>    compaction COMPACT_CLUSTER_MAX = 32 caps DMA's payoff for compaction
>    (V4 experiment).
>
> 6. Where do batch-size thresholds live, and how are they tuned? Per
>    Huang Ying's split, that policy lives in the migrator. DCBM has no
>    threshold today. Open whether it should later be a per-migrator
>    sysfs knob or hard-coded; probably clearer once a second migrator
>    (SDXI, mtcopy) shows the trade-off.
>
>
> FOLLOW-UPS:
> --------------
>
> 1. dmaengine_prep_dma_memcpy_sg() in DCBM (Vinod Koul). The SG-prep
>    variant cuts per-batch prep/submit cost (=CPU savings), but ptdma does
>    not implement the SG hook yet [10]. The end-to-end migration throughput
>    delta is small because per-descriptor execute time dominates.
>    I'll post the ptdma SG hook + DCBM switch as a follow-up.
>   
> 2. SDXI as a second migrator. The SDXI series [11] is in  review. SDXI is
>    a generic memcpy engine without DMA_PRIVATE, so channel acquisition
>    goes through dma_find_channel() or async_tx rather than
>    dma_request_chan_by_mask(). I have a local DCBM variant working on top
>    of the SDXI driver. I'm planning to send it as a follow-up once the
>    SDXI series settles.
>  
> 3. IOMMU SG merging in DCBM (Gregory). dma_map_sgtable() may merge
>    contiguous PFNs unevenly, so src.nents != dst.nents. DCBM falls back
>    to CPU for safety. Though I haven't seen it on Zen3 + PTDMA. I'll
>    understand this and address it a follow-up.
>  
> 4. Revisit Multi-threaded CPU copy migrator once the infra is settled.
>
> EARLIER POSTINGS:
> -----------------
> [1] RFC V4: https://lore.kernel.org/all/20260309120725.308854-3-shivankg@amd.com
> [2] RFC V3: https://lore.kernel.org/all/20250923174752.35701-1-shivankg@amd.com
> [3] RFC V2: https://lore.kernel.org/all/20250319192211.10092-1-shivankg@amd.com
> [4] RFC V1: https://lore.kernel.org/all/20240614221525.19170-1-shivankg@amd.com
> [5] RFC from Zi Yan: https://lore.kernel.org/all/20250103172419.4148674-1-ziy@nvidia.com
>
> RELATED DISCUSSIONS:
> --------------------
> [6] MM-alignment Session [Nov 12, 2025]:
>     https://lore.kernel.org/linux-mm/bd6a3c75-b9f0-cbcf-f7c4-1ef5dff06d24@google.com
> [7] Linux Memory Hotness and Promotion call [Nov 6, 2025]:
>     https://lore.kernel.org/linux-mm/8ff2fd10-c9ac-4912-cf56-7ecd4afd2770@google.com
> [8] LSFMM 2025:
>     https://lore.kernel.org/all/cf6fc05d-c0b0-4de3-985e-5403977aa3aa@amd.com
> [9] OSS India:
>     https://ossindia2025.sched.com/event/23Jk1
> [10] DMA_MEMCPY_SG comparison:
>      https://lore.kernel.org/linux-mm/3e73addb-ac01-4a05-bc75-c6c1c56072df@amd.com
> [11] SDXI V1:
>      https://lore.kernel.org/all/20260410-sdxi-base-v1-0-1d184cb5c60a@amd.com
>
> Thanks to everyone who reviewed, tested or participated in discussions
> around this series. Your feedback helped me throughout the development
> process.
>
> Best Regards,
> Shivank
>
>
> Shivank Garg (6):
>   mm/migrate: rename PAGE_ migration flags to FOLIO_
>   mm/migrate: use migrate_info field instead of private
>   mm/migrate: skip data copy for already-copied folios
>   mm/migrate: add batch-copy path in migrate_pages_batch
>   mm/migrate: add copy offload registration infrastructure
>   drivers/migrate_offload: add DMA batch copy driver (dcbm)
>
> Zi Yan (1):
>   mm/migrate: adjust NR_MAX_BATCHED_MIGRATION for testing
>
>  drivers/Kconfig                       |   2 +
>  drivers/Makefile                      |   2 +
>  drivers/migrate_offload/Kconfig       |   9 +
>  drivers/migrate_offload/Makefile      |   1 +
>  drivers/migrate_offload/dcbm/Makefile |   1 +
>  drivers/migrate_offload/dcbm/dcbm.c   | 440 ++++++++++++++++++++++++++
>  include/linux/migrate_copy_offload.h  |  44 +++
>  include/linux/mm.h                    |   2 +
>  include/linux/mm_types.h              |   1 +
>  mm/Kconfig                            |   6 +
>  mm/Makefile                           |   1 +
>  mm/migrate.c                          | 211 ++++++++----
>  mm/migrate_copy_offload.c             |  94 ++++++
>  mm/util.c                             |  30 ++
>  14 files changed, 784 insertions(+), 60 deletions(-)
>  create mode 100644 drivers/migrate_offload/Kconfig
>  create mode 100644 drivers/migrate_offload/Makefile
>  create mode 100644 drivers/migrate_offload/dcbm/Makefile
>  create mode 100644 drivers/migrate_offload/dcbm/dcbm.c
>  create mode 100644 include/linux/migrate_copy_offload.h
>  create mode 100644 mm/migrate_copy_offload.c
>
>
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731

---
Best Regards,
Huang, Ying


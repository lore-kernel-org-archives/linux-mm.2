Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5609CCD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 09:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72CD66B0088; Thu,  7 May 2026 05:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC516B008A; Thu,  7 May 2026 05:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB926B008C; Thu,  7 May 2026 05:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4762F6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 05:58:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F20E7A0456
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:58:28 +0000 (UTC)
X-FDA: 84740173896.17.94F1696
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8BFC440003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:58:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fdDUBLPp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778147907; a=rsa-sha256;
	cv=none;
	b=Z5VLVnLxAyXuQZB18xOgN7t59kNM8HszVnVmaXwn2M0vNEA6WTNPNjboBRuc8XLiLS+/ML
	keRdC90V4hdkCESoFrm/zP4EVnedeB9kDaTnDDhUuvFb720r2bOjVadcBXdR1rth/ZYO2P
	ybWFSL+pWCYu6tk3Ow8jqZahpLgc3SU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fdDUBLPp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778147907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Guzl8KlL1Kp9opMOIFQEpshAevM9uQ4PUucMWqrUqWE=;
	b=y3R5se2ldNToyytltn0c8qEtiKZR6T9AAJF1ah2M/peRPoKTqutT0BUp+LLXxdSG8L97on
	x0Lxb6enCZgnrf5ybUiZizogSiizNQ7yJdYXZ8dak4uGWg4r4iipgmZ1RGMzlarAjkWytA
	Si/AKeDOVrPmdm/P11PPqZR6IrHouts=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778147902; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=Guzl8KlL1Kp9opMOIFQEpshAevM9uQ4PUucMWqrUqWE=;
	b=fdDUBLPp+RejJ68zro3d+7SV2qQAIvPPddYWhQjXTirzFCdv1v9q2vBzH+gVMos/RRZdeykDOXn4cRSEeJgeupNqAZ+KV/CxF1BoulfTH1/DSeOFQJ39P0U6XiflZos1uZsFARPlNRPf6zARgMxrNaotBPvYL13yJ4DuK2vmSD0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2UBJON_1778147898;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2UBJON_1778147898 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 May 2026 17:58:19 +0800
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
Date: Thu, 07 May 2026 17:58:17 +0800
Message-ID: <87a4ub35ja.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: sts7upspgur15dntkckcjpf7f9aijz36
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BFC440003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778147905-374782
X-HE-Meta: U2FsdGVkX192OLFdtA6Lk9QHwHp3FgyVyPz6IGbCCG/hxob6AJoJLXIeiJqfoWNSILhgYXowy6D2ci9kv+aPWpuikHgs2T8in6LGGwbDoWOdvkvqKrS8cPE4Qaq/8lKTNIk4gQd+hZXfKHbFysU2ThmVnRceTOEh/gLvSdUkc1/+r80RvzcFZ81giuloMsM7DSgTzCuSwCTFaZzmGkMkBjZkVfQIJza6OZ3p4x1HdWh47/mnBYxVgeWYbsUbHPqPac41mvQmt5FlQ5xUJ2HK9KRDh9ages6LmTnpjWErhDiBk7P2xyiJm6RSaAi+ZabHAyv/calV8OCqpVlC2wLlAEkHRIQDux/8i73ucJwhe4TMX6KwaDyBnOawzoDnkHP9ADgbPPwOEo1+CCJy4UPnbVJeS20MHHLnL3VRyNVpR+0hGSgL5A6LHFs6uq/FwtwDpxzuI8c7oyaaYTesQEut5YyIAIseXoHlPMALNrQXE53iu//oO4EHb7ZydtsNEml3vp3/RELpNUdaaIKfsFcMNO/VACfCFmZwBhUPHfFhdQyiQGg/W7bDyzPzh3O66ciOMSZm0zq8UCxG484LHxK3fYu5mkEIpgwKxalRh6LKmGSLE7mLrxMLemZhc40u4Q3iqZ/JKl6jJftfrcEZuAfY5AOPD9V15mHeZa2cEVNMDwgDQY1Mein1RocwHsP5YHK+jrZzWAUfZsWdCqnBAUT6UgVlGnsAgjA31C6vr3u8z6nctkCre+5H7O3BwmRZa8Twsw3dZulEvcEGvK/ZNEugjTXeBSGbmbsC9awaEMleeS+5hK1nrqKZcPP2UgV6GpyZRDIlmtCjtZNRG3bK7BRKZEKzbinnWrMjUfNiBcS02NWOr0hwJK/a0OrvSiLwiiSiE0RsawsNWAB8myyMeS0dPXWaaG6t0wd74CSLSHmiD1OJj9AV74Zoymgi4hDxp+pKKwkYkQXk0pKkb+RV6rm
 aqRcGF/d
 WWqCTSreXmMkYZfeCkLekNdnWASGGBu5gUGLz36QT86fJapz6r2fwYdTjIV6yShGrGWmh6j7zIH3fBxaF59FHOHY5rHVaPKptDHcEeADv5mJaTMlY9C0VSn311lasRCcJZsJHy9L0MfqYzbD+HiFtxEuVj4cVEEaFdOTKEGW8zgdhZOj+0qTREXuQICfi0h2RpH4KlT3AjlBiebYAKh6jUB/G5BgsV02jovGwrg/IQj4eKt/LpY+JK6LiqdRL3wLgWlkTzhYpctwE50cK/mAG+iNyOwfdKoSSm2TDe3afwVzab19WfCv/9p1pm8T1KWI72n7bKK0UPGZGXYygw7ZcETr6eJADEGZGx4KKK7upnqau2S81O2mWiVcxb5i/WVLkywuTVaETebgENwyEt2C99ah0hDU40qcmgefK6wRvGEPj6LRZCHKXDs1R7Rbx3iPbUvTLCeg5L3AAOAUuFgB4IiTB/Wdgym5uO4AQ53q+VU9UJFCfkzF/MdJVXA==
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
>
>
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

Personally, I still prefer to change migrate_folio() callbacks for
better readability.

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


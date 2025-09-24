Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 507BCCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 01:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F858E0002; Tue, 23 Sep 2025 21:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DFE58E0001; Tue, 23 Sep 2025 21:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CA48E0002; Tue, 23 Sep 2025 21:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5C78E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 21:49:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE27D14065E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:49:56 +0000 (UTC)
X-FDA: 83922462792.09.B02EC31
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE9DB40003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:49:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F4xoxPze;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758678595; a=rsa-sha256;
	cv=none;
	b=j7dLDmBylpnyBnxC2qxmOp6L1q7vAGpiAhRVCc7lpPg8zNbtguDxosOt8s/kevaU6fh8/Z
	RdL4M2U1VXWdoN2qpLse93f7XEqzHwVSvZwAL7IrtuUDMAek07UDDWFj8zCfKUFDNDO0pC
	2LTRpf9BrSFzWUvxwfkVjYvy0n9jH6M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F4xoxPze;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758678594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NxHbnawDoiwdor0a0/TkIoFsILHYQtnh4tEXaeWR3w=;
	b=G7sU5Zji8D8/TAl3qo2va6xndjgFIHx4+3z6ATxJs4WtOs4Js8j3OO09plavmolPS9KJ4G
	NhcypP1QDc+gc0CHYjgDZcE0VrGDtZyfhflSOS5L7wBcYkLaLmrz7ED585rkXNYoW2+fEw
	3dCLvh8ccqZAEwEVr0Pz8hpaFsZzZq4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758678590; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=0NxHbnawDoiwdor0a0/TkIoFsILHYQtnh4tEXaeWR3w=;
	b=F4xoxPzegiASihfxGaqZBCRDa6m7zwGFzEiEdi38a1Mkljz3NyJu8eNo0j2lKjbgeF+cuS6/75RkkT8Dw7kisrlQtb1jbKNQFsixmd50t3YD2HAXoIB/cONoPB+wbsWpEs5BPXeRnMHC07QgK3xugPnOXBe0eFjXSwEqh2Q5FDY=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WohcHHC_1758678578 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Sep 2025 09:49:48 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@redhat.com>,  <ziy@nvidia.com>,
  <willy@infradead.org>,  <matthew.brost@intel.com>,
  <joshua.hahnjy@gmail.com>,  <rakie.kim@sk.com>,  <byungchul@sk.com>,
  <gourry@gourry.net>,  <apopple@nvidia.com>,
  <lorenzo.stoakes@oracle.com>,  <Liam.Howlett@oracle.com>,
  <vbabka@suse.cz>,  <rppt@kernel.org>,  <surenb@google.com>,
  <mhocko@suse.com>,  <vkoul@kernel.org>,  <lucas.demarchi@intel.com>,
  <rdunlap@infradead.org>,  <jgg@ziepe.ca>,  <kuba@kernel.org>,
  <justonli@chromium.org>,  <ivecera@redhat.com>,  <dave.jiang@intel.com>,
  <Jonathan.Cameron@huawei.com>,  <dan.j.williams@intel.com>,
  <rientjes@google.com>,  <Raghavendra.KodsaraThimmappa@amd.com>,
  <bharata@amd.com>,  <alirad.malek@zptcorp.com>,  <yiannis@zptcorp.com>,
  <weixugc@google.com>,  <linux-kernel@vger.kernel.org>,
  <linux-mm@kvack.org>
Subject: Re: [RFC V3 0/9] Accelerate page migration with batch copying and
 hardware offload
In-Reply-To: <20250923174752.35701-1-shivankg@amd.com> (Shivank Garg's message
	of "Tue, 23 Sep 2025 17:47:35 +0000")
References: <20250923174752.35701-1-shivankg@amd.com>
Date: Wed, 24 Sep 2025 09:49:37 +0800
Message-ID: <87plbghb66.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AE9DB40003
X-Stat-Signature: st4inezo4xwocmgouqaxuwokrko13ywg
X-Rspam-User: 
X-HE-Tag: 1758678593-617378
X-HE-Meta: U2FsdGVkX1+9f/O94BxwL5LMn7r0USsfDSUmGKZBBmT/XOLYyOV9WWw2Z4red8BHTEInDX8Fqosgp3fgp4O08sWU2he1h9dK3Ixg8Di4CgzuGLUXP2BAWrFC/u0du/gBbgBWZBHJFi17c7KKwKD+xk9baU3iqe4Y7+MwOtcATktFSdxU1DmG574x/QUpc5JhCVMO7hxAsLT1AkVNjL7Efv5nLY5p42bfaYzNYmtYTVfVOSMkpGzWj5s7eaoR8sxxRMPxLu+TPeqHzzx5jsPYI+nc6R5xrFuFLxMFw26muydHfH5J7yAmRgmHEc6rfCH76C/xG5MHHJktMNXChTaNA1aqaSgm492GFa/toMiKDH58WoPzLfb4HtCD9/e9l6++Gyep+NvwlbTX3t6JLnQCb2tMdp8q0EMpo0QxQ34e+pnSAXy/vgGZwdM7A93qGt5vw7tWgWMcVuzuWBqxj6Y0r0S9O9MsPlpU9GRvoUF2Ty8X2CqwCOL3djQM26GBY/kwTz1fxhtIrP3Xp9LFs2MN1F5FebWQuHkL1L88oDfKuiuiU+/Hg+IG6y0eg968W9zz2FvWV0iHtiSeq6i0YHGHq895HhDhlKfhKXgq+BaBvj+M280RVhYE15TISV+axjXHmn/12cCQpv6Z9Pu1JpdE1g8zRCvDQf2nACLnTA3F+gVKah5UGBSe2wgWeMxKzMAkRrm5Z3ipa/gVnhLFEN69I3Ww+ex6Pxu1RCJjL1QhVdU1nW3FN+UvzOZHwfgWg0nrJEwLR6NCjmrAUOYjxZxgZO+lB3qiJ3lL+W4NQ+YqGS4W4z56McBZnUdOz3431EatQ9DTR4QuSDsR3Gj+CN5jIZWjQL2/+g2397javyrBdc78elNkBxySBkI//1ZwGtp3wuFCDuRNb33wzlbZkD8VcL7ykjJSgwBblfnQ0St+N3w+Av8tgW3M/aC5ZD9Gd+5LOz33XtVlQuOeSgNMoEv
 CjKT9JNX
 SRdp8W9/TvXpeNovGFMUHNURVIcQNegu76NebNwfhHkh96mloXQqUHqQCE32c8hq0tHMBLP81pRjm2ssjiaIfz3WjCzOCAKwQn2RpYL2BhQRjILRO2qdIxgjdLWwnXKiNWuR+dhBMCFwoLwOE8QFz58MQPSdGBrnqe62VUUFnkJmR+Gfykxfy+cR8cBvqqem2XxwcmgVzFMcFzJqyE46ncy2VSQwdptxZ2xWOitleT9Sbp7r/xW5PtnRlMePVwfW/xJh7YmlmsxSp57FpMCW0sJ4zp+I5SZBsO6pKNQecNO3tX+A4jznWcNCkPuii6P+hrI0/+PmiKH2FZy8SLBnGvkI4FTvkT1jDFAg9Q/7967HdxobVGAkoyw0JAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Shivank,

Thanks for working on this!

Shivank Garg <shivankg@amd.com> writes:

> This is the third RFC of the patchset to enhance page migration by batching
> folio-copy operations and enabling acceleration via multi-threaded CPU or
> DMA offload.
>
> Single-threaded, folio-by-folio copying bottlenecks page migration
> in modern systems with deep memory hierarchies, especially for large
> folios where copy overhead dominates, leaving significant hardware
> potential untapped. 
>
> By batching the copy phase, we create an opportunity for significant
> hardware acceleration. This series builds a framework for this acceleration
> and provides two initial offload driver implementations: one using multiple
> CPU threads (mtcopy) and another leveraging the DMAEngine subsystem (dcbm).
>
> This version incorporates significant feedback to improve correctness,
> robustness, and the efficiency of the DMA offload path.
>
> Changelog since V2:
>
> 1. DMA Engine Rewrite:
>    - Switched from per-folio dma_map_page() to batch dma_map_sgtable()
>    - Single completion interrupt per batch (reduced overhead)
>    - Order of magnitude improvement in setup time for large batches
> 2. Code cleanups and refactoring
> 3. Rebased on latest mainline (6.17-rc6+)
>
> MOTIVATION:
> -----------
>
> Current Migration Flow:
> [ move_pages(), Compaction, Tiering, etc. ]
>               |
>               v
>      [ migrate_pages() ] // Common entry point
>               |
>               v
>     [ migrate_pages_batch() ] // NR_MAX_BATCHED_MIGRATION (512) folios at a time
>       |
>       |--> [ migrate_folio_unmap() ]
>       |
>       |--> [ try_to_unmap_flush() ] // Perform a single, batched TLB flush
>       |
>       |--> [ migrate_folios_move() ] // Bottleneck: Interleaved copy
>            - For each folio:
>              - Metadata prep: Copy flags, mappings, etc.
>              - folio_copy()  <-- Single-threaded, serial data copy.
>              - Update PTEs & finalize for that single folio.
>              
> Understanding overheads in page migration (move_pages() syscall):
>
> Total move_pages() overheads = folio_copy() + Other overheads
> 1. folio_copy() is the core copy operation that interests us.
> 2. The remaining operations are user/kernel transitions, page table walks,
> locking, folio unmap, dst folio alloc, TLB flush, copying flags, updating
> mappings and PTEs etc. that contribute to the remaining overheads.
>
> Percentage of folio_copy() overheads in move_pages(N pages) syscall time:
> Number of pages being migrated and folio size:
>             4KB     2MB
> 1 page     <1%     ~66%
> 512 page   ~35%    ~97%
>
> Based on Amdahl's Law, optimizing folio_copy() for large pages offers a
> substantial performance opportunity.
>
> move_pages() syscall speedup = 1 / ((1 - F) + (F / S))
> Where F is the fraction of time spent in folio_copy() and S is the speedup of
> folio_copy().
>
> For 4KB folios, folio copy overheads are significantly small in single-page
> migrations to impact overall speedup, even for 512 pages, maximum theoretical
> speedup is limited to ~1.54x with infinite folio_copy() speedup.
>
> For 2MB THPs, folio copy overheads are significant even in single page
> migrations, with a theoretical speedup of ~3x with infinite folio_copy()
> speedup and up to ~33x for 512 pages.
>
> A realistic value of S (speedup of folio_copy()) is 7.5x for DMA offload
> based on my measurements for copying 512 2MB pages.
> This gives move_pages(), a practical speedup of 6.3x for 512 2MB page (also
> observed in the experiments below).
>
> DESIGN: A Pluggable Migrator Framework
> ---------------------------------------
>
> Introduce migrate_folios_batch_move():
>
> [ migrate_pages_batch() ]
>     |
>     |--> migrate_folio_unmap()
>     |      
>     |--> try_to_unmap_flush()
>     |
>     +--> [ migrate_folios_batch_move() ] // new batched design
>             |
>             |--> Metadata migration
>             |    - Metadata prep: Copy flags, mappings, etc.
>             |    - Use MIGRATE_NO_COPY to skip the actual data copy.
>             |
>             |--> Batch copy folio data
>             |    - Migrator is configurable at runtime via sysfs.
>             |
>             |          static_call(_folios_copy) // Pluggable migrators
>             |          /          |            \
>             |         v           v             v
>             | [ Default ]  [ MT CPU copy ]  [ DMA Offload ]
>             |
>             +--> Update PTEs to point to dst folios and complete migration.
>

I just jump in the discussion, so this may be discussed before already.
Sorry if so.  Why not

migrate_folios_unmap()
try_to_unmap_flush()
copy folios in parallel if possible
migrate_folios_move(): with MIGRATE_NO_COPY?

> User Control of Migrator:
>
> # echo 1 > /sys/kernel/dcbm/offloading
>    |
>    +--> Driver's sysfs handler
>         |
>         +--> calls start_offloading(&cpu_migrator)
>               |
>               +--> calls offc_update_migrator()
>                     |
>                     +--> static_call_update(_folios_copy, mig->migrate_offc)
>
> Later, During Migration ...
> migrate_folios_batch_move()
>     |
>     +--> static_call(_folios_copy) // Now dispatches to the selected migrator
>           |
>           +-> [ mtcopy | dcbm | kernel_default ]
>

[snip]

---
Best Regards,
Huang, Ying


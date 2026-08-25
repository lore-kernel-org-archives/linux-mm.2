Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EDE5C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B54F6B008A; Tue, 25 Aug 2026 04:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08BE76B0095; Tue, 25 Aug 2026 04:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4166B009E; Tue, 25 Aug 2026 04:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF4646B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96697160390
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:04 +0000 (UTC)
X-FDA: 85139167008.09.56122EB
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 23F7640002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RHKLAdCL;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647742;
	b=TU6HCZACA/7sjDSD0bYuqYUKRSRBoKsWT994NH0tWQmVIx9vHonPknvCOX52vSvTervjqj
	qVZq9LODqztJhgkIQLrfKGRhJCY1pG7Dzh26A3bL4fxAETIZcPAWXzVNN/l4edLaJne8Zf
	ncZhqNy83VL2mwerYWGzxrNwWIdu+3c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RHKLAdCL;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S3hKQUMatSsldJGL1EQZgNBrWtZeW478Fj/hzsUT3a0=;
	b=GU1vAUD8AZGWvpAJDp1SbhZc5ZsBv0qoo9QUIveKdVGa+XdcsgzsM6i4GLmpJkTttprBth
	/qYa8qmqZG1xDTpjTq/aRgWeC7qF8u+h5bGc58P5Afvsykucp0UzpKXHn3xmExN12k+7aB
	9TlhRKzy3qP7zAwbJjxDNiu5LCRKQbA=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ceaf8a1265so51008585ad.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647741; x=1788252541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S3hKQUMatSsldJGL1EQZgNBrWtZeW478Fj/hzsUT3a0=;
        b=RHKLAdCLLWz/qeeKDWkpkhU3bHcPZ6a0EvNuSjBQjrl0feTjOGfAAu892GlUKszp5a
         g+9ijtUaXa/NJB2DTZXy1g0PLydXyeeD+tgQM/H/xg4sTPhhGGpL9aaVhf7RvDlDbaNT
         WwlQOTlIs8mxxPeQgzWedtRZmEZv3JE/k3EpXGbnQlWBD5GZLflV5rBksiw1bXXhhqxX
         GJ4xhpLJqW42ogPHZqq8kwfEOJEVzv2RAgFt1gqLLi3YW7s+AqXvwRbgumSCfpFyBXkg
         ItBaMEZsbqqc5Ho4i4a43Mz+vNRxg5cGmzXrry+FBpAq4c90ZPQjn9E1gnoqR5N7zZx2
         uKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647741; x=1788252541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S3hKQUMatSsldJGL1EQZgNBrWtZeW478Fj/hzsUT3a0=;
        b=lFdpomo4tLVWDBbdwuHVm8qTZ3eWKbeNUinqVYe6LYDwiYM4uIL8gN85NXb7nen4+Y
         NMzudxjgMBfElBKqrZTMRz37qz+QpnxkqCTj/FQBTe8sNGTqmf4fBO73pbP+Whk8qmge
         Rfp76LaNuzIBjvNy4WuyZ3lEpSNqdYs61iP0Z75zWxdmLx6bxaKPSdB6wPGUU+Jw/lBc
         7xF6M0BZShVUGONGoy3UTSLQwdYG4a9HY4RlbeUqzqN0Ng1b6NmpfNsC3vn4W1fMsC39
         zBlZ9uuqATuAdW6otdGs7CUkRej9YBgs/vL493ta4vG0sKEmewIWt7ow3uHv9kK267DM
         62Eg==
X-Forwarded-Encrypted: i=1; AHgh+Rps2KILrt9iD7/PYiQvggNu6lyHKLvL/oGWKJKSnMez1fGz5Sv80aE88NZeECRQ2VPjW9gL3lIZ0A==@kvack.org
X-Gm-Message-State: AFuF++lDIviIfbaxAQSyzMycEkNG7cdHhYUtRRU1XzI+m4Lqyip/oL7N
	XNMvZEC6inXgos6ZMfxzYoEItwBKQFwBjOpinkKXXt0u5KDLGkys7OiS+IzWKNoNR9Ve07eWyDr
	C8CDJaO0=
X-Gm-Gg: AR+sD10GYk3WNS4iZFqYWAJtVwZHNmFneNVxrg66t5fp+Nd2iwPlV3U9pfAEXUGtXOT
	/7U1V7YpXbJV8mAXJmoBlIn0mEopHhHmN4GMNyh0+YXSVs+pgDvTSu5QwzTWU2BEHwUMEUuWIBJ
	9nY+vfImVjT/t6+LDC7JGvKoBFjg5mfvipelLrlmzV2Okn2s3E/dj0G74Vm3I9jaIZ8b2RLe2iC
	NE/uG9gua+6x92ZzMMIckKFdEgIZzIPvvDmLvIW2Mi5TyJahjjJHzDyeI8S0+3mhH1dgeOsZuHQ
	uR+RgWOdVtUA8+lwzUtqLAPcT9Siw37SPOjnHga6/gVYJq2vDRq7ChVYCeypxJxfiQjtD6e2szp
	pWCZ22ejuyQWA1w11nxeK8SAdbxbil30R+IzYGcqBmVwd1j8GovOiwlEdeSy50kkeZtpnj+UJCB
	yggXVADWLqGXveTJUjFCzzwz8Iv0jqYla2FCTeTI2diri72OJiLDcx9RZ5N46+Y3a3jRG3qF02b
	kk2RcfMSmgMWFlemIeTK+dG/A==
X-Received: by 2002:a17:90b:520c:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-395c3867ac5mr63054426a91.14.1787647740376;
        Tue, 25 Aug 2026 01:49:00 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.48.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:48:59 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 00/17] mm: Introduce section-based vmemmap optimization for HugeTLB
Date: Tue, 25 Aug 2026 16:45:51 +0800
Message-ID: <20260825084608.47437-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23F7640002
X-Stat-Signature: 4487qnadgxti1rfyg77ni6deo5x3ycqy
X-HE-Tag: 1787647741-754803
X-HE-Meta: U2FsdGVkX18g8LMaePIqFnitn4EMpx3wIRnPcXIyq0uHBmr9uWS87Ol5XZuajIP8C6+R5GV3TO5zEZqgn7d7h44HBahL+8h7idnjLVNQIQ0X94wIR+Xr/VBKa4wVpjPe6chH7qak2vs+j1YNFP0hUETG7zT7JZYH5QYOZm9gktXr7DZfrAjIQg6vjtF2jokpkATjFeQrRly/QjK8x/pmnYG3RzP5E4wEmzU8nuQwN6LZW0R/4nus0vKAIMAb4dyG6NkKzWSDVjykQp3cYSlZYg9Zey+fDj1XRc6E9QXMZ/z4/84ikB7dG7MPNKARkY9ScGCgZPL8RgAPFqcDUJdpDpK2gCCPG9TYb6a3OVKwG6NLtBbNdJBwakcv80jxe90HcV+dXxYSUfj9+TigMvfKaXcqOuUPMUEBPU5BhRW60z4xFnINCSea5fHv+FbO+7L7Y/ldogtPxFDlQwFCF0zUXmyyyJl5yK+7C3zRhlQ6W+5GT7Q9RBjTv7/rNFjzIiQvN3aeNc6nJq4dwrAxZ7Gvl3U3wTAVHQJk+Ilwx6/OmPPBMstW7EFrSg/l/QhOMaALyStmDmRl+MxJ/LT1jzVEPH9HRAC2sQp8SL+tNalH2NzZ323QayVPntmGuH8897UmVGkQfiluH0tYEouwaO2YeYD9oUI+ZRcFkQsak7AFVolK99MDwgCK3XTkeWtGEIMnd6KmrHNVzqa9BjCoH9hVPSfm9nS96tS+D1VNXJf9SJ5Xi6lBEUU4h694REYzecLTzLsf4PbTyFnG3/vo4DSNrWvJvI+uRBujKHstD/gip9K62Yv8PI2PBCeixRYSaqvixDkL2dJXorUljSnqrbL2eg9+M1kgdrCw8NtffPyUijWf3ms8cDEDC2sEl8n7Ph1H9h1uDkvc5WmdbM2IBjaJsevTqeOhHPcJT9OVnTmn2FTQZ9mTkiD9tC1oEb9MbAJlAhaKNN1/+OLS8TC7OFm
 ueNIXBCa
 XCB6MzZxuSA3pHiTIDmbyAqBsKLo4bFFRltVSloo3SxNE5uDnGnxb0NOKsXPI6ogJ2K2OjrDOdRSxUled3x+xEw5npxf4iTpZm/3tBU7ekT/5ygy/ldBfdrt32sy8dYfxIDQ0e1wcAZXYtwRBl2ae4EJIGVWshsTe+DfphVPbCdbSu3wdK3u8v7Wdy/CLw4ihbnTSIW2N6tHOQRx/kLVdXK/NoPUmfutiDpFSES4/hcCMDHSBh8OdwKvWHP9j3RgwHr0asnZI95mLdoHFDQLYr90+FFNeZxcAmIuaSf6r3iX1e6nQ6cCncpA9hajK63ICoxhn7qEdKw1TCnrJPnD3eSf2aLIrzTaMqcBJvibjYk/LF1dtS+Eleu0YMwx2oW3zJa473ySeeaBFhS3YFY4q8EMsWmcy323pHBHL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: making the generic sparse-vmemmap code
section-based optimization aware and switching HugeTLB bootmem pages to
this path.

HugeTLB vmemmap optimization currently has its own early boot setup
path. It pre-populates optimized vmemmap mappings before the normal
sparse-vmemmap population code runs, and sparsemem carries
SPARSEMEM_VMEMMAP_PREINIT only to support that special case.

That makes the HugeTLB vmemmap optimization path harder to share with
other users of sparse-vmemmap optimization and leaves a fair amount of
HugeTLB-specific boot-time state in the generic memory initialization
flow.

This series introduces section-based vmemmap optimization support in
the sparse-vmemmap code and switches HugeTLB bootmem pages over to it.
Instead of having HugeTLB pre-populate optimized vmemmap mappings
itself, HugeTLB now records the compound page order in the corresponding
memory sections. The generic sparse-vmemmap population path can then
allocate or reuse shared tail vmemmap pages based on section metadata.

The patches are organized as follows:

  - patches 1-2 prepare sparsemem and vmemmap optimization metadata
  - patches 3-8 teach the common sparse-vmemmap paths to use that state
  - patches 9-10 switch HugeTLB bootmem optimization to the
    section-based path
  - patches 11-17 clean up sparsemem and HugeTLB bootmem code that is no
    longer needed after the conversion

This is intended to be the second smaller step toward the broader HVO
generalization. The device DAX conversion and the wider HVO
consolidation are left for follow-up series.

v5:
- Add comments for pageblock migratetype helper callers and shared tail
  vmemmap skipping (suggested by Mike Rapoport).
- Move section_nr_vmemmap_pages() earlier under its own
  CONFIG_MEMORY_HOTPLUG block to avoid code movement in the later
  visibility change (suggested by Mike Rapoport).
- Add vmemmap_alloc_pte() to keep PTE allocation handling clearer
  (suggested by Mike Rapoport).
- Collect Reviewed-by/Acked-by from Mike Rapoport.

v4:
- Rename pfn_vmemmap_optimizable() to vmemmap_optimizable_pfn() for
  consistency with vmemmap_optimizable_order().
- Move section_nr_vmemmap_pages() outside CONFIG_MEMORY_HOTPLUG to fix
  CONFIG_MEMORY_HOTPLUG=n builds (reported by kernel test robot).

v3:
- Replaced the !SPARSEMEM __pfn_to_section() stub with
  pfn_to_section_order() so callers can keep mem_section access inside
  sparse helpers (suggested by Mike Rapoport).
- Added vmemmap_optimizable_order() for order-based vmemmap
  optimization checks and used it for HugeTLB bootmem decisions.
- Fixed the pfn_to_zone() commit message to name mm/mm_init.h instead
  of mm/internal.h.
- Collected Acked-by tags from Mike Rapoport.

v2:
- Kept struct mem_section aligned after relaxing lookup constraints
  (suggested by David Laight).
- Folded section order tracking into the first user instead of keeping
  a standalone API-only patch (suggested by Mike Rapoport).
- Renamed the HVO order macros with a VMEMMAP_OPTIMIZATION prefix
  (suggested by Mike Rapoport).
- Moved pfn_to_zone() before the sparse-vmemmap optimization changes
  (suggested by Mike Rapoport).
- Kept vmemmap accounting and population logic in sparse-vmemmap.c
  (suggested by Mike Rapoport).
- Renamed the early sparsemem helper to sparse_sections_init()
  (suggested by Mike Rapoport).
- Fixed the !SPARSEMEM stub name so SPARSEMEM=n builds compile
  (reported by Sashiko).
- Guarded section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
  it returns 0 when HVO is disabled and lets the compiler optimize the
  code as much as possible (suggested by Mike Rapoport).
- Collected Acked-by tags from Mike Rapoport.

[1] https://lore.kernel.org/linux-mm/20260513130542.35604-1-songmuchun@bytedance.com/

Muchun Song (17):
  mm/sparse: relax struct mem_section size constraints
  mm/sparse-vmemmap: rename HVO order macros
  mm/mm_init: skip initializing shared vmemmap tail pages
  mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
  mm/sparse-vmemmap: support section-based vmemmap accounting
  mm/mm_init: factor out pfn_to_zone()
  mm/sparse-vmemmap: move helpers ahead of future callers
  mm/sparse-vmemmap: support section-based vmemmap optimization
  mm/sparse: initialize memory sections earlier
  mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
  mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
  mm/sparse: inline usemap allocation into sparse_init_nid()
  mm/sparse: remove section_map_size()
  mm/hugetlb: remove HUGE_BOOTMEM_HVO
  mm/hugetlb: remove HUGE_BOOTMEM_CMA
  mm/hugetlb: localize struct huge_bootmem_page
  mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID

 arch/x86/Kconfig        |   1 -
 fs/Kconfig              |   1 -
 include/linux/hugetlb.h |   5 -
 include/linux/mm.h      |   4 -
 include/linux/mmzone.h  |  66 ++++--------
 mm/Kconfig              |   5 -
 mm/hugetlb.c            |  64 +++---------
 mm/hugetlb_vmemmap.c    | 103 +-----------------
 mm/hugetlb_vmemmap.h    |  13 +--
 mm/internal.h           |   7 --
 mm/mm_init.c            |  69 ++++++++-----
 mm/mm_init.h            |   1 +
 mm/sparse-vmemmap.c     | 224 +++++++++++++++++++---------------------
 mm/sparse.c             |  94 ++++-------------
 mm/sparse.h             |  85 +++++++++++++++
 scripts/gdb/linux/mm.py |   6 +-
 16 files changed, 299 insertions(+), 449 deletions(-)


base-commit: 4b18edbd8e70f7e6860d56370f13244896d0f95c
-- 
2.54.0



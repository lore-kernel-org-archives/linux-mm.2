Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213B3C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E206B0095; Wed, 19 Aug 2026 05:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55F46B009E; Wed, 19 Aug 2026 05:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92AD6B009F; Wed, 19 Aug 2026 05:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA5256B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B78A804CA
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:02 +0000 (UTC)
X-FDA: 85117555404.05.604ACCC
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 997A21C0003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:52:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="W/fq3L9A";
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lfdcWHvC2PHdCUa/CQ4iiK0aiUxLXLj/NwPaomXlhZs=;
	b=xkWR6qBDDPYJ903vp21uB03voV/33uQaqEqDCDKYgFsAxIcf+NAF1qf+0qK58qnhmqIwNs
	4X+jDelsV2VEGPmDGr8IfTxzeBjZ03LZpOjL2NVcTxq2Z2RmkiNyRK7Rd35NQxxASlPYzo
	RaPsturIAecPuxiH6XeCvGGdFXANkDg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="W/fq3L9A";
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133180;
	b=F27FbBU81EuGerQ5Uoihh6eEOX4M8mmMC9K+RLZOkYlUpy6kbV5GYCfjjep9faME51jLAI
	yt8gUMV4XJ2MT74zG/W7fKQab5UL019QAh7E7Ip/1aLA2o6XmTqmi6dvg36m6uvJYAa5W/
	1anNwyMxMAIY4+Tuck4ElE3PxhtkA6k=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso9352755ad.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133178; x=1787737978; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lfdcWHvC2PHdCUa/CQ4iiK0aiUxLXLj/NwPaomXlhZs=;
        b=W/fq3L9Av8ezBhlTAACSHDxpv/RUSdFxUEsIyiUjXUgSWVxgTwMocNGDytMZkCnnQt
         Au/fG3hZ+5OTWK03m6gvB+NPOIw9HUKDe4KrzRnTKwt2pq5G886aqDEa1D3m/SB9SXQv
         KtKRNGR6DjOZijNhKdNA0Uu+T2dQj87VYnwvCqw9x8XVpbSRjpcYJIF5RgboKYnjM/PH
         XZCX5Uasw2XT2ooU8tN0b+GWa42v0nNIhvqqmqOgFPedRRb5D4zPdkc7/fILitSZ2yWf
         MF3VYFUtISmmUXlImwBuYbfbkiNqzyFPBHLknFY3JTmrmJkWX00Ia1Zb1Eb+tsIpk8nX
         /VeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133178; x=1787737978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lfdcWHvC2PHdCUa/CQ4iiK0aiUxLXLj/NwPaomXlhZs=;
        b=MAyS/eh1nPmOoJPg7Eb+ZdtP98Lc2WgwQ1HuqbQ4/CVCvyEPCn7w76SNOvtidagJzC
         V1EpKpzknt9yISCjo4J7NSgxjKic7dVwzeWUIoq1DEX1r4GcyZyyZDXTbNmF6XNoz0wh
         iYByejBpduN3N0k+Siu4wWst/g/5ccB8QDmGFwzURBRsMoPxBTOTCZvZTzYHX/efiWjo
         zqW2032i/rtVnZ1sjbOfujnt6dHTewWDUBXi7BWnd3nSlWVX8V023EJfO8hsVykfqRPn
         7RolRj0KRPRqi8r2EK2W/nbiubw4PVdKJTKMw2ypC95jYzXmAEQYvvOaT6XTrG5/rOIW
         qShw==
X-Forwarded-Encrypted: i=1; AHgh+Rqf0TO3lpAZgtbijjhH7Z6NsddFB5RnDnY61BpE7gmwvxdKYIuTBN3NN9sfZ0KKAvEaKFlu3koZeg==@kvack.org
X-Gm-Message-State: AFuF++nJBqTRVX2rMwqQJSiKMRlZvlWHrot/kk2LnROlzwlHcReqHaC2
	2SWmP5tU32N1/Mh+2s/HbUIgLsy6KrwiCB3bBc9rOjLoFvwO8HvUQpDD3tmB0vG94lE=
X-Gm-Gg: AR+sD119qI4lpCEvmb5JSYYHxaoxZT0zdhh8OwR7+NlmG+DRjNKap/mzlSMf4Z0vTDG
	mUmwx5GaQMGMPG5UgGSrYSExH51kvV8WJ4zdqrMwdGKN2LDL+40MGK8YaYQQPK2NvkpfjFLNMi1
	b3/yzUf0BLMG4W+e/oeOLCsS36MAhhB6Jge1HodMREgqIpwtrhp0OkW/VxvcKObBP4Pqxk4THNx
	Jd0YIRRKkeJXknb2I7gZI70B1ETMUVnBuvhwkxepH/z9CY04uu38M9pue7cRynXAMqL+c8RlGFy
	QGrf/A6M6DuMpR61krPOxLccji3Be73o9vI4WGlj/LQE7HpUkCeEHITKO8J09Ubk/Zt22xakKxK
	Ufzf4pLD+3WK33e26Z0CAV2cXKOIEgPS53r/mmulkYnlunC5II1VM7rOy0qCsm3ZTCFM2hDmrzi
	enxjxegpEwH+P5bdVp1m6Y379C/2TKj77G3hBmJPArM3JmgRHASlZSeEiaAVcEbTUNm+y7OUhhu
	+JODKYoy3yBsAjqG1AB4XwlQR0f0t/1VkhJ
X-Received: by 2002:a17:902:fc4f:b0:2c7:f2c6:89e0 with SMTP id d9443c01a7336-2d5fd628343mr59435505ad.4.1787133178026;
        Wed, 19 Aug 2026 02:52:58 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.52.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:52:57 -0700 (PDT)
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 00/17] mm: Introduce section-based vmemmap optimization for HugeTLB
Date: Wed, 19 Aug 2026 17:51:22 +0800
Message-ID: <20260819095140.17252-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ecu4d11o8hhhkiwgfef8at1srhabu7pg
X-Rspamd-Queue-Id: 997A21C0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787133179-116222
X-HE-Meta: U2FsdGVkX18xxg12RK52K3I7OEZqZUisMKJoZSJ5ZxOcwF+8+KmYRJmhtHfBRw8AE5WuV9zcp5d7BoPJIvha8Xiycf4urC7XN4AytmZSsOU6An4F8QnbRGIJDTd4ioEO15hVgkxLR1ZN9iWsrD4PBo3+QwLnci6IqzEYYN9DWtF3APQ6kTZhfEykPJ7qeTs2HkU3JM6GjGWq7QRKgq8ujmAMyxCxaDoKPzJ5GW5yzO/3JaV953KyjDILLL+V4Ncyq3JZdu30yGAxKJlVJ/Vg/YWQ4O4SdfE4ZogCnfqX+ztnfAF6KGsginvCYN+LF4A6t/z8CZ7qdEmwE5LTqkUWF120CTgpB1Eq2F7Ko4nTYpkFG6soF/YSRZ8J1S82DmZuSw5txsUeRMqRse7LfgIkf5JNoK4cRHamfyCHDgpLSgIn2rs/FVQ1hSd58e2wvtLMiOY/iIoLTfzCoPHok0NCM6IeF9dnpEfy45HCzsi3f/Io4nYqmuOmoldHQBeUd4ZY8F2VJwaAP8bY4SzyGpWBaDT10PjF/hJz3dSVufY9SWddcR6rtk70cmGOsDATnPkp+ytqy9+pclsb73aRKc35h12moIaeJFPP2esr1Sss6ej/T0ozQmTisuqAcsQKCaHd34rZacg8EF01DskezSOE/LUxT4/KyYbDOYM+G2RKpMKKI1eRswXLHqQ9E9GjOXl1kIzXq9EINA1CosKx/FRDkPhnU2UnMNR+1w7mVSwaf6zf/Rm9kM6mwIN6JrTC4VZR8sLMFXpDexWBVmcDwrDvtBo4Qv+4wXQefKm3B5NMorzLr3VTaOSPTtRTmnNvBGQgdLOXF3R7EpVCDu7ZV0x0IOCzEvfmYApMPmr09d/Dj4IGS0CBHqra7syaszw3bVWgYUYecrblpcgyTbOidvEUwSN7T+FCyMFs8uOK4lbO4V2dhZo4Ioq4jwT9r17vhUKeYL3oT2YW1uA4xVjhEMT
 2TH16TFc
 DdMJBiMcpdrkwY/mPRTDWziLE3VYMxxh0OrpVV3usb3nkMsqzOZuoU2tK0K7gozwcLxyaArQN+a3iotENrKQBjxG6x5455tGlIC9Fh44j6Fo73iZWuqb9do+JGg6jY2e7zlhWvGFyDYNWvBrxhWC9Mz/zto7/lzI+ZXxbc2byzEz1DZQGbfZaFBz4+wa8cjAljUDxZbhaCwY03MTVehtwwgfWue5w3q5b9flIt2N0t+hwEBzOZVhMQE1ZjUmDfu7Ide4g+XiNgxFyFKAreln2PJIecyzAippchYXkRuiq0f2aHs+dM+IrYsNO66LkvmeJ22QDuYii1lZazrU/jH1tXJKZgSYyNp8QpCb1rqdG0nq3ynZXkuVP8hfPfUc55zGB3pb8eMyqkD5ekcw68P1s4Dm5iaSGZqRouY6U
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
  mm/sparse-vmemmap: move vmemmap_get_tail() before PTE population
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
 mm/hugetlb.c            |  64 ++++--------
 mm/hugetlb_vmemmap.c    | 103 +------------------
 mm/hugetlb_vmemmap.h    |  13 +--
 mm/internal.h           |   7 --
 mm/mm_init.c            |  63 +++++++-----
 mm/mm_init.h            |   1 +
 mm/sparse-vmemmap.c     | 216 ++++++++++++++++++----------------------
 mm/sparse.c             |  94 ++++-------------
 mm/sparse.h             |  85 ++++++++++++++++
 scripts/gdb/linux/mm.py |   6 +-
 16 files changed, 285 insertions(+), 449 deletions(-)


base-commit: 5453bc3279e9f8578ac3e534d476240e40c879e1
-- 
2.54.0



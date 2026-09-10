Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86BFAC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD1D6B0096; Thu, 10 Sep 2026 02:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886616B0098; Thu, 10 Sep 2026 02:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79BD26B0099; Thu, 10 Sep 2026 02:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 578CB6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDBA614043E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:25 +0000 (UTC)
X-FDA: 85196885970.03.5B9D403
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 469DA40004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=R7gn08pU;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022004;
	b=E0X/4JGDkUlncDYKVWweJ/pHKfwVaDlhJ8xSBqlMhPRKXy4TTctsl/N1IYKzQrXuM/TZAQ
	9EZ88zXoztwD+dH0tU2oLqc3+4re+LSho3apwkIAFafcBdRkPNzJ8Yb8HkUdGerZY5tx7i
	nUEzYxy4GqHn6rgw9SD62X/5RgO6erw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=R7gn08pU;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rAd33FXhTKmE+GxkEc0xfvfKe/VbGJPr1z8AjG4R4y8=;
	b=qCPOtZeVHfs2PIyGB8Iwsj6rT1r1JKYyxsYK96ieFvV4XvffLSU/zzzFCGFPEIbxnX2sYO
	cAScFvy6leRLcP2to/bPwAeVYI/sQn54XPmk44Q/hjsXCm4Z4JS6LxoNOuVMJD2s0eI1VR
	OXYA8wqtEuopeJfL/T8/zRqkVpOnTn8=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4be0e5469so16300a12.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022001; x=1789626801; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rAd33FXhTKmE+GxkEc0xfvfKe/VbGJPr1z8AjG4R4y8=;
        b=R7gn08pU4/zrQDUr/Q00gEMZ2HXxF3kHcobVvam/b3U8PPFF/+t7UkQUh5cP7YbIcs
         AmI5tKj/QMj8gK5ATya/hwYnqPaWVJlnGSSBZvdqi0XSCM/64UKy9Vgjm5ozfa1tgPGN
         QuaFcz1qtGjnmJ7rR3GtXB23JB2YNwuolAOlZIBO6zITgAMvf6k3CO68KtC7cCgsTXkS
         4NXyrMuARBsuAzNEuY2XEnLWbAH6Ejgmm6D7mCE+LD+e1qbCOcjcg6GHZ0bSzU06yKLW
         8DNv96mXiJZPDfty+A6rkpneVHB82MaygvXc6iQqtwrDMVqF8z781ZMu7N6amagbR9YI
         u0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022001; x=1789626801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rAd33FXhTKmE+GxkEc0xfvfKe/VbGJPr1z8AjG4R4y8=;
        b=ldLxyyzfYNyq1kjlmAq/IZfvxkTIGysNVGDljP5VbENUuKXYQyG/n7oZWU23iaeSbz
         IqtYFoajQI4mRtpGNhQRzaRFUMfppWZjXUwAVRCI4vZUjOH5SANR5lh3lDXf6ymdbQmD
         DmIJzZiPebuej1UabLmi1FXugzePKw1M7KIuG9CjrIUZoGgc4x/Uw8B0ORn6k5o0/Irf
         9j8lKe5Dmuw9jWbkyX4LXIvvlDr81NScxUfISkt99Qz//eEYFEy/DwMozV7XTTHSvm8t
         kYabrr12cAjHmCq9lFozSZI2aCL7iILwD34BSlNjlQjJKhZWFoBgeWD+O3hbIdQeCo4H
         CCxQ==
X-Forwarded-Encrypted: i=1; AKwUvByuEgdq8K4vXQr5bRnBtLZCcq9i5AKyBEZ+Atg8SNcYiixXNlBvqW2zQ72HVTbxhSYQPfsbchYf7g==@kvack.org
X-Gm-Message-State: AFuF++lHBUJc0S5Ty79F57Q1YCbggHZZyM/pI6sdUrDxHGDd3736kfHR
	yFGJ9sJDY/E9KdtZdcUu4/1L9GbdgWYsj3D6FK+YaPllmTS1RW0OncjeIFXnxX0ROFM=
X-Gm-Gg: AYBFou0d6r3UQ5tdUPaprubplUi/6+v2VUlKKKx1R50QnXa4C9+QXYCsJ0Nkejdm8bj
	ewQYRZZapfUKJeCu+bnz+1bW+2aQHTjWYCsJk6LNuawtxipHHS8GEwBECqWya5Kn5o5WkbXC57u
	rGHyiRDK7CnKe90/+F8+m+X6OqwfDKg2xj1KJkkGwMAoctjBOE2Q0tjQQDNVm4dq4MEm1PBXjuk
	qlhaUJpkcq5tX01GrVfYfrwxwVl9fcn/h7ZxL2dmrrv1zwT5vtdiYeVLDksyLOCeyYiX2lq+2EP
	W9Llw4XgbuLelVG0NPIyRqTvdD4d3XvOnJ11hnw4NZIrnhqK+3hGTFY76WEPRMjPTChmKUVwo8P
	5i1QwSKcgZfnTerk4LgCy9Pj/h2MbV6IMl21H3cVr1xVWEZ/JUUs+MXAvOgNitmMbH6QYDWMZ/Z
	E5pHLEaYIKCqp5w+jWkW6LAvUQcLW3Vk2x+KjcpUdkk4+99Q7KwNKDUluOkXOHhQhCJeV++ctyO
	KqEuF9jPi68HoxDo2Rjwg8BdbxsBdgYCAnBZr9oQ5ILlg==
X-Received: by 2002:a17:90b:3c45:b0:398:9beb:5c19 with SMTP id 98e67ed59e1d1-39b26232bb1mr58417921a91.20.1789022000528;
        Wed, 09 Sep 2026 23:33:20 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:19 -0700 (PDT)
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
Subject: [PATCH v6 00/17] mm: Introduce section-based vmemmap optimization for HugeTLB
Date: Thu, 10 Sep 2026 14:32:39 +0800
Message-ID: <20260910063256.64386-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 469DA40004
X-Rspam-User: 
X-Stat-Signature: sob6rk5anxekckmqpdkzgap98ogopahy
X-HE-Tag: 1789022002-36781
X-HE-Meta: U2FsdGVkX19HniAcdIxDl0SCHj01WBUtFBQ4psxBc7iX5tP6NZL+NZ6PxOKA5OFJbn4HNI0XhzdLdZE68uB6Vl+fBXF/2FaF7YAL8B2bYm0xQNg93+Q7aVDM5NQ66XSTynz/m9FSOgSdIgD/TWDZuOiP0PDPcbmFbYj0kJCgyOT2++BJ8UKK0PmQxT2XW2oJyTsuA3CXbsstWnMfTptHetR3Aebyb4mxNoRj3+QmxyMKoayYD3EhKyi9ckWvUH8hlCxQL71hkj0SOrOeCRH8DW3k0ALpGLqvX4o5dbQTxJLj4q3Ai7aDtn9NpgAQLENsMdaVRX1A2QJ4kUeUSGmweciip2PZMz7MJyIhNUbfAa1UwVZOwNrjuedaeqe+rJACKRxT2MzPCToi3tTE6efzwxlPMSeAlGqT6MfZkdzNGr5TdFZhcGsHcg8weSjvTI4VvFvyQ6UTaAGaIo1gqCMOCUwhK9M9Ps2zSSMB78Uv552KQUZ90d08F88qJH+b0v7CGi6Ji42nKHOuZJdm7SQbtb/2hli5jPdMkDS9JVd8FpN8FBQk0d7IjNIJHjIN6Sw6MlkU1OK/ERQkF1rtFyt4wLcLIaKKMKhdBb1t+BQHPdpui4Y49G5bEOwGBbPP8haZhgviZfvC0nJehxN1YeFGfHe9PgzFBG0AbyLZZvki81OIOGmAUTzDo+2QDKj3VSQ+ngwlOyT4O/eeZkUP+TO+dHISaTOtx9/vPmRhCj5ilCv0FuR9XSNr6BpOd2TZ2g2hMe/G5wvFohWt2Iwv2FRoJnwEuaVWJJSdqj4WmToYxOPtZ/4WCXORAf2Ci6MZ81HUSnHORGrfskEb0gKOGfVFtq5EKVxxcxf+7CRgHoGBdaNvFEaO/l/QFYj9g6WArbLC086RSKItlkhBR0s8BDfq44Rjljan5lUGRpQ2rQryogH852jF+bJkIA7F4am6iPxPTwtuTBhb/2goLMP2uGU
 WAwDqLNH
 7bV1P+WnZFzOFEuzMybgnH11vXZbQKXqACcClteRiVWO8c2c4DYV14YiTtMrVls0rigOn6dAPVJ0R8orJHugwYaAeNzPn9BBOuFsPGuyhwKeLthZfAi9TtD238a8C7mx+EUpgD20ZODsxgYZ0j6hdWBV1EsNaIQjTreZg6FCZMngG87b/UU3sQGWt6Ci/SLkirkZTb48NE3usV21U/IhhO8hvn0WSQcPATcVBJMaInrEUReAs6ql3lUyqTO1GRsOgSxFcHkqvInsdewz3MfjUP8Fz6uC0FudgdS5NuZUahLxJAW2gKpbAoL1c8Lq8rXMfiv9YfSIakHfn0jj/76fVpdkKKR2uNDhgH8oYBtBvfj8pGleJL0KT86lxyaIHO01VHp91FsNDBXAl6a/PSRzFa/tUEuNhME2Jkb3/
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

v6:
- Rename the section order field and helpers to use compound page order
  terminology (suggested by David Hildenbrand).
- Clarify when shared tail vmemmap pages are initialized and drop an
  inaccurate sparse_sections_init() comment (suggested by David
  Hildenbrand).
- Make the local vmemmap allocation size const (suggested by David
  Hildenbrand).
- Collect Reviewed-by/Acked-by tags from Mike Rapoport, Qi Zheng and
  David Hildenbrand.

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

[1] https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/

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
 mm/hugetlb.c            |  65 ++++--------
 mm/hugetlb_vmemmap.c    | 103 +-----------------
 mm/hugetlb_vmemmap.h    |  13 +--
 mm/internal.h           |   7 --
 mm/mm_init.c            |  69 ++++++++-----
 mm/mm_init.h            |   1 +
 mm/sparse-vmemmap.c     | 224 +++++++++++++++++++---------------------
 mm/sparse.c             |  93 +++--------------
 mm/sparse.h             |  88 ++++++++++++++++
 scripts/gdb/linux/mm.py |   6 +-
 16 files changed, 302 insertions(+), 449 deletions(-)


base-commit: 219467624544a1dd72e2022a442741e66766e39a
-- 
2.54.0



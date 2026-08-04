Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C67AC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBBA6B0092; Mon,  3 Aug 2026 23:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D27B6B0093; Mon,  3 Aug 2026 23:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C0C6B0095; Mon,  3 Aug 2026 23:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE8356B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:55:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50845120862
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:55:49 +0000 (UTC)
X-FDA: 85062223218.16.9EFDA09
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id F28E3100002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:55:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YYtWhkMP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zRwaoz2FDOmuj5qQzcI87AT2QJQ01oT5JuXMaekPpYs=;
	b=K+rgKsuxDXC4S2vNF6wuOkWkAB3gWlwVVaxx0qN67OE9paaUSYDggCTJ5F0xpPZQEWPBlx
	j/HJfhE2cXYnXMb4ZKknB3kNy4pIRuPdzrpFTi31WtBtSfwXsj3NGcIgSBimLvesf3fLmP
	/Q8B0oIDbBzyudtWRKPVHGzmM2RV9bo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YYtWhkMP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815747;
	b=E7j1EFls92VlK5To1cCoNGIujL1REyt4ILbVduYKOA/yL0UmTD9Aj6XwgtEQOWxLWNJgr4
	yvhuEJf38iLjhwQwHvr4AGxhVajE7doRsXIq76D01ijAiBro54hqs6zBDrvIravZYQV7Pw
	QXQxmTs9/osw49HyKNmHE4eRTR+6oHU=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc891373e0so45203665ad.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815744; x=1786420544; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zRwaoz2FDOmuj5qQzcI87AT2QJQ01oT5JuXMaekPpYs=;
        b=YYtWhkMPzkotE8AHM94vKoJZGiU9AfA7So3uTrBc+21BjRuwJoXJBa3gYguhCMfiHd
         6HBfEaqU5f5oPQdQYBAguC2adPq+L2jxaQ38SXqgdyLpuHV4XM9nRIEcquzUuPr14ssH
         ZFbWz4svakqir+xy4+cpaKQvUEKE3mwjd7FHtiSDMNot2pw1LK8fb1x0RJ07XhghXDY/
         EF2Tv8wjVChT/AitBwISbOQWvH2wh1psxDWcl1+xcAIIaf7DtbplxYV76tGVOLjO1qNx
         8bIUXuG+xLbZEOeWDqF5D3g/B2sMXjZ8Q97JoH0IZF71ybd/j4kU0bkiQahR5fPPVUdn
         QecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815744; x=1786420544;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zRwaoz2FDOmuj5qQzcI87AT2QJQ01oT5JuXMaekPpYs=;
        b=heg+5fzrcWRhqFbGQiMD/HaHD1iKCk1RrUXcN460ykRecfh6fh5JkfbKznaUIm69xl
         q3fwKkLUJa/amM6lPjJAyRyH8GuprRh+2KKCxK16YztGxHOQoSxyh+RyKxwep5WfLKMk
         fygGqK/hihhYCxCQNSvKdP2Fs7kU+Leu2It04MhzjgX+dJ2fsmX5flkWEhcRnL7BmX47
         HQlp7KrLjmTtyu7ImNiYmurSiv8RLlkZG1XEPBIaqub8AO9dua/xGpIVW4Tj/pQZ6HXv
         K7awpjP6QTchm3Hn7rkUZhuW88K2NmXjNrxUW2jSJtIISynWFFViXagZfH9Odjc4rslP
         soIw==
X-Forwarded-Encrypted: i=1; AHgh+RpNaF0V4IerK0D0JIPvd9hzRZRQoAD9/BesbbNrz5XDLyYsKJd3GHSg4l1TGOS8hCKMSckvJDgXSw==@kvack.org
X-Gm-Message-State: AOJu0Yx84VW5jJgktTT6q2bOs0Frllw1FOpd8tiAWQPziESVw5FIJHmb
	rmySzTybjh7Jz0sqNkbYQ1IN927pEmLpDmmhdTfUrXr+IAiBoHiz8TGTAHjEaJw2AKA=
X-Gm-Gg: AR+sD13CFu4KgJOQWR5OFBj3KCtQeKQCId3wdduXZw4vLL4QHBb/X5T8pctJgpJk5P8
	rPmtjmb7RJzCmkKVJfbQDSDwdy75IpT2s1C8cSqiZgXZJM8ZwJHDUwC4Vq1ikv29CtKkYJ9/21v
	jFuyhl+scnIhj72taBM2BLthDK3IeoHRazacG6shrNpPMg+/T7Ljc0hIaUCihY+Ek/gvrIlrjvD
	cv5GUSaJRR1RezVMXOdpXiDTxpvg6Qo9OyHYQmzOudVTfy4WGY4IdcJdrHkEuVpdKlJsWHaw5qo
	hG0V1JII4pxB7pdWCsqEnYnq2cVWKrKtvtlpj0MR1zjFogv1hVOVvgvJugwd6Baz5ZXJOgIa94e
	DW3UnHrndsgQ24iHAa15DWtrXtqmm/94WhvzzXzwbDhZ4prda62hNkQDb4gSZEZLiPha8BNgraa
	v6kI6vOx7gYiVDDeYzvw6CGtogBt24nDNgNsruPbVduLJHmODdTSG6qPoDjhJATP8zOcllZmCP0
	EEIZfij
X-Received: by 2002:a17:903:1b4f:b0:2c9:da58:17dd with SMTP id d9443c01a7336-2d052415633mr126989915ad.34.1785815744090;
        Mon, 03 Aug 2026 20:55:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:55:42 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 00/17] mm: Introduce section-based vmemmap optimization for HugeTLB
Date: Tue,  4 Aug 2026 11:55:18 +0800
Message-ID: <20260804035535.2846016-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tkub4mrjxgfe77iz9i78wcdr8qqtgp4u
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F28E3100002
X-Rspam-User: 
X-HE-Tag: 1785815746-657764
X-HE-Meta: U2FsdGVkX18RfoBnjWVHJ+lFv0Noys8I7e7SMqTujAkFbG5kgKZpAtoUgcjAeiVeeeHmVQwDiTKN3TWoaFu+BrY3cBMoGe76oFxzrIfAbzuHZIRC7bvgL//bSQ0CoNL1NieVUhVOcSZr8iB0/fFVN41kH01e97uBSLDOLR/QxEBMEONjltXtbaph9LmhGXBic6LBjxZHrFAWYxeQvURNeWXn6lkxmagKH7wsG1MlwIgo5/+nNVuITBkSatMIVt3bfQYQyNGzvQdpRC9OpWUxahwNbd+NEKO4m0YCnxGS5Da0uOOkcmEXWPbbS0enWN2bqvsVEtEzPVqwmhJL2DrS4Hi7cD9jMCK3sWJsrPM+8teXncnkAaX1ppn9+CNI9x5w8Qek9MYh+VjiB/TDfFRMPT9b6DQ4Q3EBRTU9QhIl6Op05OcgzsVnXiXx1bLb1K+WD43lLVzl+FsI8+w2mp8k9/BW+Vbk5A6RPOWKcKMf3ZIGyX30X+ge2srIrsKwBSzU5NvwUQqFbZsCCOFMn2pGEJEPcEseDYqOc6I6xe1Xvx9+6ghEf0oQAp46aXaxmsXLUoFK/GjZZM+cK6DnXXOQUgGcQVGqiZb4Q2+aenjUfBcoY0PevVUeGnO61o1pdV9J0efiMBtOwZ58x2wZP4nDQKKi6OaFJPDOFqGvoCy71oNqkiV/1/y/39xwOU8OSTqWd9cF1Pbk+gc77sDphnTH2qEuMyK0vSLrJ4Wiv3GoQmkPbcfib9tu7UTeI4P5LrP6KiIgFjhoCciKBys0CTmIGsLAQ/urMJJBKLzQ7u6pAaQnmH+tstrpFYoP/FBmKJULQYnUDYm/gSJmLeM2NlCa0avC4RQlNwtgrggITxSAKK7pLQQZgagERnigRXIGvufm0J557T9Gdf6OzxuxpU23ZJQjpDEpw+sxp+bEV4bXP4GEN6nLmrBSpyZoc1ir3++g3KO3NSaLZOzTsOvX+3D
 ZaUFRPxd
 tXhDjkreeoVv6fMgTRZHDtgYmlGmIU7KzNl67nQql8Xvju0PETmzhDEZp5FmfkS4/+1UCRAldewpbAknvLj2eNi0Z4taMR5nwj4hR53JA1Sw6XO/4PhDQibUEmsbzmgN3vSzx+sH4KR8gjd535froXFnvdN3WG14UZR/FO49hZj9kAkzjvW1S92QePZ8v/L8WHFqjoJdDx5AHMF1kRMzTHgvvRKHKIDHMbc3D6a6ubwFVG2Nt4+j6/+IzK3O1ATB8nfrdyaoEXJYXkSdpk5GoyfqOMZKRDrGpBYXYEzxehabGcMwJDdN40pISH8+rJ5QqLp677rk8sDhD2u3RNjSyapLJsddzPmUuW7BqWFwuj6rhInqeg/XWJsHFw5JnVXeQ1RF1Ep7n2pbwS4kdf2LG4+CSvBS8857bz4im
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
- Guard section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
  it returns 0 when HVO is disabled and lets the compiler optimize the
  code as much as possible (suggested by Mike Rapoport)
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
 include/linux/hugetlb.h |   5 --
 include/linux/mm.h      |   4 -
 include/linux/mmzone.h  |  66 +++++----------
 mm/Kconfig              |   5 --
 mm/hugetlb.c            |  64 ++++-----------
 mm/hugetlb_vmemmap.c    | 103 +----------------------
 mm/hugetlb_vmemmap.h    |  13 +--
 mm/internal.h           |   7 --
 mm/mm_init.c            |  63 ++++++++------
 mm/mm_init.h            |   1 +
 mm/sparse-vmemmap.c     | 176 +++++++++++++++++-----------------------
 mm/sparse.c             |  94 ++++-----------------
 mm/sparse.h             |  85 +++++++++++++++++++
 scripts/gdb/linux/mm.py |   6 +-
 16 files changed, 265 insertions(+), 429 deletions(-)


base-commit: 9a4cdc958dd79fc6c3b20b51a10debec6ca09fec
-- 
2.54.0



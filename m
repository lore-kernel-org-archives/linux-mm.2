Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F198C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399D96B008C; Mon, 20 Jul 2026 05:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AFA6B0092; Mon, 20 Jul 2026 05:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260D56B0093; Mon, 20 Jul 2026 05:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED7C56B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:31:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74AAD807DC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:31:53 +0000 (UTC)
X-FDA: 85008638106.25.360DE88
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE8A4100006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:31:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Rt7cl89u;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539911;
	b=J/Au/3+L44KgFrEynTtsw69CQj2v/D+IhdzwkiwBWyhMHVgQ/t9tbxDtv9orLX75kQtn6i
	q41ozQ+OWLWnnqRbS5NLCC44mhv3nEFUKRms8HsBbP3hNJhNmeLcbn0LywxghoROF8uMAh
	Ui9E+858hOa/9z3R8V5DDf9hkJBAQrA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Rt7cl89u;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yJVF6JbqogoY8HdXIsfRZ9+PMfuGJZF+sHMViUld/dU=;
	b=zyS9hYl0krLtLKiAd0OEUV7o6uW0O18l/HZvSK+2upulYC1poWaQOS6IuSKe4pSnjNhzAV
	fgJsqpiIX+eAo/cqn/oKg5Vqey3CuEj3ELRcJWuNlLetOGJ9mayGuefnwmreyKhJotgSS+
	bHm/xnRtbIoxvibmbvqKs1eYYVRoOLw=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cad4170e8eso134023075ad.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539910; x=1785144710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yJVF6JbqogoY8HdXIsfRZ9+PMfuGJZF+sHMViUld/dU=;
        b=Rt7cl89uh+pTvZTAaxKYSBQjimNqAHV1IYtkSbKUn3vIhtGGLB2gh4gee74ERU8wAZ
         rvYqAJLoqAwPDt4BzKTKq+54oI4hMGq4KMMc6LnRkvm2kupVx8ssxWYTk9fhYdipxXBc
         rVfeNVKh3NQfyEYH6fA1iJr2IRaR2jnB4D9FNygQ9Ci4LejptPlvtOO7UIh57rhpSwp/
         tfy7YfxlS970UXIH3zYKN382TPXS0JwYPwI/Hxu7S74Ec97u9cfpfWp54GTlwzj/5GSH
         mw3ID+sZv2rlKTUo/JyYDC+SnyN/uWlC0CfMLXajLtV5thFt+n5jMNbsIT+vVE5XCUnF
         zvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539910; x=1785144710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yJVF6JbqogoY8HdXIsfRZ9+PMfuGJZF+sHMViUld/dU=;
        b=EDUQSTDVGF3VESMk93HI6UMJuyN/MoVKzI2Pv4tzSF89cA7Rlql2r0vnfjAG8p7B7S
         i57LF3Y8CnEiSGOIWpRAGBWPDvbCWDUEdTH2COSLBmhacfU4jtpipjvPUCPYQSosPFiC
         IVTmpACl1f8Q0v1cBL/XZGys0b8CDrtz9VrASB3GW3U2OfYWxNnT0dNXv4A0kXFwVHLH
         /jwKRbN9ftBnpEZtdFEtUTCY5FTHMcUfeiBvUpB+eLk7feePqq+dkoEOcBSE7BcBteq8
         hY5CGJOi6e1Tow0U9BVO7dkEUKbgJ8zvVnqest5uAkXyGpF2EhsxJ/31zVbHTnyTmA/J
         2sow==
X-Forwarded-Encrypted: i=1; AHgh+RrKoFQAxUCst8AwYFk8vjFin+D1pr0BCG59xEFisLGvrxucyJQgfwEpGb8B27jADj6WomYWn9Uubw==@kvack.org
X-Gm-Message-State: AOJu0YyBr01Y8Qz+LLbAaZQUhc+dko4ntfaryLOF7ZGh0aKoI3ka8yh3
	1dxobHPLWcBE/nPpcEITS6OcTkZ+hLC/NEcnWrNKhkydmSzzvgtSBPhRCCvVN1mtkqI=
X-Gm-Gg: AfdE7cmqK8eYIAgBY9K4vpdMuRLtCAOPBOH/aW1FcV+2+aP/iO2X1KDNTf77ZBw7AC4
	1f1VSEmNLj8rEQnUo9R6MK3SN6AlyaiE3f0GD9i3/6Zt1zdrZmV3oq+858/XDECyxS83elLKtTv
	MxytZXT7h+My1+66Rne8ykzjLiimIwKXMg33DvCg2Fepb/MzB4EzKgBJt1zpOvqCaddMtkBAVoa
	glsKyrOQfX4I/eJ5YoAJd7s6IDBpFz1Rert4uryJzK5iUT/61xBedFgkAoapTMOZdPEWewRKqHR
	Sok8ZgtmnN8xk47tCl/p/lUFzqrDphjvu5+EAqwzwlr0WvbgYTY242Vt7WEqu7RhTG5LH1r3jxv
	bisaudRtK92tcvOrM+cwlgoyLrtdBSOh1uoXfMWHsHx1iplThS0fkxvmd68uWZ45cHLx3Lkl2nS
	anU/1agwnAMjnqW/A/I/x/IYk5uUNITOHZ7A==
X-Received: by 2002:a17:902:cf12:b0:2c9:97a7:71af with SMTP id d9443c01a7336-2cf349ed678mr136956245ad.42.1784539909607;
        Mon, 20 Jul 2026 02:31:49 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:31:48 -0700 (PDT)
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
Subject: [PATCH v2 00/17] mm: Introduce section-based vmemmap optimization for HugeTLB
Date: Mon, 20 Jul 2026 17:31:10 +0800
Message-ID: <20260720093127.540540-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE8A4100006
X-Stat-Signature: zms1xja1zuy5inubctctee3359xn7bg9
X-HE-Tag: 1784539910-327090
X-HE-Meta: U2FsdGVkX1/0xGapf9BNLh7GWAYMD3dDVTlyd7sfjiy9ZdLDRna6t5mcgZm2F2LCL/n1LvHS6NzokYCijDoLfTmSKI9aNmRkq4QlgQVONFO3OQD+jMivSYsMiB4Yie1Zm7D5pIlz6mBDUVk+Gu0jVoqVN6WKt9yMPC3aozcRLENiHLHlnF961tlqW8XVz2/gUZEFCr8gT6EZpjne9G8SwPG6wNrkXUMwa3cB1L4voUce128+A2iGMlVIH/f1oyFyi4LQMZvnhNwdY6MBE4Os3p+xBbPkbA6Xu6XZAmhbWs8dlhb19+zC92M98w6dV3dTuq13pmWATAG7aFvCZTpoMzwojyJbp8oD2SJRFywGTqGBFQ8TruAWV3YGVcVvCzOCGZyCwBC+GgvqADTmWfY9bDecWJX+B8mw6LC/DunsLy3o4tZzGUc/gapzuXe6ZpiJf4TTu1aujIvf3SX6VyAb1xyZk1Mt7ey+w+jtf6IlvET8GT4zxY1ys2fSTZL/+5Noml45sLxLK+0dQ/GYmqvplTE2OJkKatlQKYxUE7c+Vp4Gb3URgMAblzU9hPcxZJSY2L2Fz1CrNLKSbXfQ2Va7TgbiGj3U9Ga0YPYyhY8jaAoz4CExLUFmiAp9oWNil6JrRKe6+xkH3bqNu98NENj4bVXQx0EG7mGOsH77ysEgzHotIZwy1bJ1uHIQbD6LPpI0hLTwIrY3ttC6u0Rs6Gu0h/Len6+fse4kStzF/gm8N93RPSy45Taqm8D7311W3imWkdrzovIoejHP0ulXs+nNUUPhWiqveqXfpZ5J4eCjC+bKnGbhH2EjMD1ZX0qL/OS4p6r/A6tzAbkiWnKxqptz5k6KPno0pwAlHazZV0PybeOO0scptCz3O1aIcfutvlJ10DfZhHCGapK4Das5o+/3kQfbi5C8z6AZs3XfsxZY3RFMqDc4Hz7RcUSjg3TvokQ9yFmXIAd1ArD3eg7b211
 WPISD+34
 sV8SRbc8yB4yYKPe/3w52hEDQ2j21s1WUeh3w3vcWKc74m2/e8alGrs7m+O83heNwhHtwtTvhGyA6WqKGvKT/HfSkjtQOQXeESzbmGJtC6FbI1+pjr8WuBDz8vsrq8EBqPZrmNaaji8uIPlXgaeJuzbbUaN5EGA/cDxgiv5NYiZYLcC3EEbBU/pqgCFfm6S0siF+xaTK2Y5CscQhZTlBKzLFmS2sEpGoDK2LhYAmbDAFUkhdkqgxePlI/pv9mvo8E3rVO9fzq2Ym3JOS9XwIsQmnRd7jrDe+xyzL76sZlXmBAgctJYWkgNB0u8UrghGLivdDPuGX8vCJEz5H34MOlw1tRV8YkWG32HA1rez2rNvWUu0Rn2/6/R5q+W0Uu3wclgBXKYwTEXxclT2Deel5r41vggRjuU0P5UQBt
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
 include/linux/mmzone.h  |  72 +++++++---------
 mm/Kconfig              |   5 --
 mm/hugetlb.c            |  64 ++++-----------
 mm/hugetlb_vmemmap.c    | 103 +----------------------
 mm/hugetlb_vmemmap.h    |  13 +--
 mm/internal.h           |   7 --
 mm/mm_init.c            |  62 ++++++++------
 mm/mm_init.h            |   1 +
 mm/sparse-vmemmap.c     | 176 +++++++++++++++++-----------------------
 mm/sparse.c             |  94 ++++-----------------
 mm/sparse.h             |  67 +++++++++++++++
 scripts/gdb/linux/mm.py |   6 +-
 16 files changed, 253 insertions(+), 428 deletions(-)


base-commit: 0718283ab28bc3907e10b61a6b4be6fefa1cbb2f
-- 
2.54.0



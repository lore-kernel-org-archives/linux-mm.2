Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C49606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=akhvAxCq
Received: by kanga.kvack.org (Postfix)
	id 68E5C6B0497; Tue, 20 Oct 2026 07:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F2B6B0498; Tue, 20 Oct 2026 07:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DBF6B0499; Tue, 20 Oct 2026 07:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE476B0497
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:53:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A80F716011F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:53:17 +0000 (UTC)
X-FDA: 85342844034.07.5502EB3
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6415C180003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:53:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=akhvAxCq;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ElDVQlbtH45fHoqyfiMOaRd5Y+wT93d0d2y0h85C5ro=;
	b=jIN24K+HeeDdQBFKvgTAxEAkdE9TRVpnEXpjx5amQZ/QnExgpVJCpEqB9WElG64qEFL7CB
	7sExtGXbCAVhgwx9QkL/L8hWuS61QSZBv7n3ol1eyj7OzESCaP7U6F3WboC3Qa5cQ9qZF9
	mIpWA7TVsNsemZVnCq+6S7N8544g3XQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=akhvAxCq;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497195;
	b=5v9hkm4kLZI9qr6OFgZk9jeePcikcmfjNRvIe2/1O1h7rWewgsBzgBF8A0fpasBCe4o2RN
	n2eg5O3GmyZAmid8nh4ipj5J43gxjO6OeVbmfio4QvBgovqIbaXq3xHktDHfIuxzNV3fLn
	ODE83Bub9MjaYYH3VO2W7Buk85MCEHs=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso1794996a91.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497194; x=1793101994; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ElDVQlbtH45fHoqyfiMOaRd5Y+wT93d0d2y0h85C5ro=;
        b=akhvAxCqFGKF7ibwFpXcQI58a6orrfaMH2DEWNJyEtH9Yc1sISvEGgeE18M6j+gCSQ
         3u8q2cxEwgEfA3Bybhx6h23Uc+FkRvKn27+5DMdSiuHdF6ZKVYnxTeU10fpyargSWELw
         yUq4KwNuGAXWlqctMWuqD4dfFzQTtMhEkHIRyPUGJsvqvdz9WAlV90mXXoB7VzJ92vlL
         hJxhXGzuGW5kE9eOA1ERumOZ8eFr36oMUNWYi/9QQ2BTOVlKE0d25VtqNg+RvyX/dO2h
         uz6tiomTGKrqTm+Et2B5Xw+MnItIK0ijOg1rkZm1tkjdf6mjLliuTV9EpK3j4D10yXsJ
         d7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497194; x=1793101994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ElDVQlbtH45fHoqyfiMOaRd5Y+wT93d0d2y0h85C5ro=;
        b=KJEr3vfnSj4s6Yj+21+lSK+pLF32r0yfjmsmYTvITCHIHqGoYGLdt+6eSK4N0rEmuZ
         j4JKPJzMx2pud6fvDlwQm7H+IaO/eJ1LzqHpQtdKxEsPVIUDTw0t2gXcpUGNkLoiAGRb
         hcgcEPtSqi5rnFhRIaJD3Ha0mqX0hy9MyxNN4N2TYY+kUv5NilBvjmWgncbTKe9Ifcqm
         qAZjIvnoPn9EySnbeazE1voitIYL1Cgg8T99tuyySLL5JetLUYzqt/V3Emx2O2dfJaC7
         XqjLk3d98QuVDcLf9Y5Pb3x6QZ7zKMsGwOOqh6OEElqOQsRV1GyBC8yi1FRexbMpXbNu
         BCjA==
X-Forwarded-Encrypted: i=1; AKwUvBxEfy3OkC1geeJ+ZsoFS/FfU/v9Zc1dVrpUT/QExwQGbuifC4+ClcuFAIdUxypftFPhjNsdPeG83Q==@kvack.org
X-Gm-Message-State: AFq9FYInaBCR6j97fTLZqxPwgJ7WJ4Sp+K26sOAFcx5orq+xXTVFqfNf
	BBfpzmc9BVGKtAqnvO6q8bF5aoXdakHZw1QYW/b6XcEOSPVHGhra5XU14OglfLWhtUA=
X-Gm-Gg: AYBFou37x+aZwCiDyGWxWrHjSM++Z4Lhsh8Zokzfea+pUptaLT7lJzgSJZwEW8uQ6lZ
	5bC1rNJ2e3OS02w696adYzImBDFNj7s9PeifCPtjuwCmNp2hK74TgiNq03X0/Rg0xfOeF6k/IzN
	wNXh8T0C8+o5viodDAgqs/e2TRrsZ8ozeeeGp+xpvgw4keQOR4waO7ioQJTFfPYLO0QsuPM8yIx
	AlqLor6FvUlFMPqOQ12rdYk0aU1HR3yIi/13dlyn4ErbyXsS1lmVAB0Mnb3e8nKIiSVst3p0hhV
	JVpY76YX+1uqwkEUlnVTPoYjbmIHkHlbgrJWp4pzobti7CHbqXv/oCxN4yL76BWNT/ekd50aOE0
	Hb6GdKGnvC34MvfzXRUBTePPJsFIup4J1zCLqO0j+ZQmbN5jcGruGk1RX+pU5PiBftQXkIYp5WC
	iWNKTM70Mvzm9vflz1NnEd00Qw8BY7eWP5xS2NqoZaCv+HNzHb0hJL8owQmEMcM21SHea5DCQRB
	hQGnU4Z5KRDbcponSAL
X-Received: by 2002:a17:90b:2889:b0:3a7:bf13:6007 with SMTP id 98e67ed59e1d1-3acef134bf7mr9626848a91.14.1792497193835;
        Tue, 20 Oct 2026 04:53:13 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60f34bb6sm3742401a91.10.2026.10.20.04.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:53:13 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 00/12] mm: Decouple folio-based vmemmap optimization from HugeTLB
Date: Tue, 20 Oct 2026 19:52:54 +0800
Message-ID: <20261020115306.813483-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6415C180003
X-Stat-Signature: qjdkkxtqbwr3fo8hxrwwci5e4isy8cqy
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792497195-473290
X-HE-Meta: U2FsdGVkX1+2yMmrK+bvUDdFNSTASxczwGTTmzDOSjyiP4bW3JoKIinNq+EXlJO6T3cKm0aM5oXEC5LNsf3oglw6aFJwOhAeWfF9Hd6ITYDKthPEZPfq7lUjrH3WzQr06dPiaK5Qv4dOegiDQEFF8dWjVOLtj7/3AUDZPb0ksFSNYRaaq4uZy8lrwqjk9akDt4evXSC+p0zNCVDDsV6uDS1xQ+Sm7twdi5PlFMUJezbLCmqP/Ug00l+GtuecUAq2v+JrCx4WG1XmLO2Bt2WV4vGNARiFSym8glpUAw+aytHTn743lMoqu9rAxgAFq9O2c3KLrDHjUDlmRm5N7gDgb22Dyre/XdP71buoVGoDOwquGYCObzOYY6gtOvsH9wjYU8932XPMBEZgtm3ilTnKRVtg0Of0V9AQGfcm2IoOh0YKk8jyKMn3woUuY/Jxej1dY5VQ2kqxvCqi/tuYMsGH+0NpNv6zu+2UjM0l92Dtd39/K+yEbrnKEV+aRJwXcbqdk5odRBr6ReeqWfI5Gai/PeI/smQYMPD7g891yZH5N3+tENsGzQgFW3hTeyx954fEyMoRVjSPK1F9O78Ik0ShODXj/e+EK0baGZLEeFr/UmYc+cnF6pMkvKBaeFtpbcc98zOpT8K2TPqa7kBrd07xlZrdA28o/9nICKo0eVp0bYu6Mo8fjDFEoIaOBEBmL/CVoowmJ1HSL+VSMNugdWIXtt/JwoAcjdX0AcP2jUaxV58GuFy60BcTrJkKVOY6dVz1UdtKWo1w+dj/eNOaefpPYN6To9XyjjniVq95SOtV6/gLLSm/o8clbehhLCGYe3Sl6L1FIzMTkKyZIPY/BYlfLyG1CXXEah7ka+gdR/ebxixPvZjJ5DFb+iJh7czUSESOlkqfTlBoN/BIxRaf+dLzAJtraTX/40/nB6WUQQfz1y32f09He/qNr+98BMlRHjGT2Pesm+HfKfvvmf09YWA
 99Bwx2VN
 2dyBlfA4jUcQe8J8XMyDyYRAqHKT1oRbXXuG7TsLrsZyfqusWEEEkyt2mWx4k2zNKdtndecBVrcqwPKPGh+wmyvbyruhkHXE18jtV/PaIJG8u3WJEgKy706Guy5ddIWF+kWDs625bxeY2QMGXODMELzsyQi6DVQcfBRZpX4a3Rq6wE8nIUm3nKaAYnAbfiuMHTpVqmlFe+9mHc3P1OL/DlRU3EFcj8gW2jb98y22CSQf5iCCapfTkb1IfTE7twFL07WENaLdHzee5SgVgsVubqsgBNA+ZrDfioOsy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Section-based vmemmap optimization is implemented in sparse-vmemmap.c,
while folio-based optimization currently lives in hugetlb_vmemmap.c.
The latter is tightly coupled to HugeTLB-specific state even though the
underlying page-table remapping operates on one folio at a time.

To make these interfaces easier to maintain, the folio-based remapping
mechanics first need a boundary that is independent of HugeTLB-specific
state and raw address ranges. This will allow the mechanics to be moved
into a common vmemmap optimization layer alongside the section-based
interface.

This series establishes that boundary through three folio-oriented
operations, each with a distinct role:

  - vmemmap_optimize_folio() optimizes the vmemmap backing of a folio;
  - vmemmap_restore_folio() restores the vmemmap backing of a folio; and
  - vmemmap_pteify_folio() converts the vmemmap backing of a folio to
    PTE mappings.

Together, these operations encapsulate the address-range calculation and
remapping mechanics for a folio. HugeTLB wrappers retain policy decisions
such as eligibility, optimized state, batching and TLB flush handling.

Patches 1-8 generalize the underlying vmemmap remapping infrastructure by
removing HugeTLB-specific assumptions and simplifying remap control and
resource handling. Patches 9-12 then establish folio-oriented operations
for optimization, restoration and PTE conversion.

The implementation remains in hugetlb_vmemmap.c for now. A follow-up can
move the folio-based operations into the common vmemmap optimization layer
once the interface boundary is in place.

Muchun Song (12):
  mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization
    macros
  mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
  mm: hugetlb_vmemmap: simplify vmemmap head page handling
  mm: hugetlb_vmemmap: generalize vmemmap page allocation
  mm: hugetlb_vmemmap: unify writable vmemmap page preparation
  mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to
    vmemmap_optimize_pte()
  mm: hugetlb_vmemmap: simplify shared tail page handling
  mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free
    helper
  mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
  mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
  mm: hugetlb_vmemmap: unify vmemmap range restoration
  mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented

 include/linux/vmemmap-optimization.h |  10 +-
 mm/hugetlb.c                         |   4 +-
 mm/hugetlb_vmemmap.c                 | 364 ++++++++++++---------------
 mm/hugetlb_vmemmap.h                 |  10 +-
 mm/mm_init.c                         |   6 +-
 mm/sparse-vmemmap.c                  |   5 +-
 6 files changed, 176 insertions(+), 223 deletions(-)


base-commit: 59d7f9ec14ad4b6f38c04d254f8f2bfb991e888e
-- 
2.54.0



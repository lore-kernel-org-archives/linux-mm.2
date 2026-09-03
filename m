Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D902FC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02CB6B0099; Thu,  3 Sep 2026 08:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5E36B009B; Thu,  3 Sep 2026 08:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBA66B009D; Thu,  3 Sep 2026 08:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 904B46B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:21:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A051C04E1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:21:54 +0000 (UTC)
X-FDA: 85172362548.19.9625644
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4BB241C0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:21:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PSud0lfM;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788438112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJ73qBOQiTpXKwSrjAZqmWemxXwNOfQBE65lRVHowjY=;
	b=37x98TE9R8xpViU9RCWCJmqT/aZiqyTpHmCeo/HzE2Ck4p2g2wlSG+SsFxraxDXOEtCFYw
	nV7TJJHegmvuinC6aLpF1l3q95srJ2WDb+QlovXnfRi71Tzem+XnA3PaOa5kYbvx8J+DUC
	Fn5CpZBRFcMmzStFPby8eDOhi1TnRg8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PSud0lfM;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788438112;
	b=WmFiaKpBeB6iQaDoEn9KeTEsrTTsh3/5eFCSGLgVuCnmagjbAvL7512Wx/1B6cDIjzpvfy
	2nrEhD2JWcAt0qnmNeJUr62Z5045tGkVVd5kl+aIIjC+qZaLQgUXCQgv13Z5Pd6lLrn8zr
	GFf3HS8Uv5W9zNlXpDSPtEn493w/S00=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84eb992a881so2025163b3a.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788438109; x=1789042909; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJ73qBOQiTpXKwSrjAZqmWemxXwNOfQBE65lRVHowjY=;
        b=PSud0lfMF3bIFVtfph8HujaP4+PE6J+zUnbUbQfPU9awU1wPD+11Ddkb2H6w/I+lIv
         nxKESjh27uosFs9GI4VNCyM/qjXZbBVJST5Wxc/N9l8JLVRX8Y1Pcq22SGqzp0jWpWQO
         u0IBQOFO54kzFBQwppO8ZnYk5Vp7jSs8eGBL+woclkXNrZikySCvRgvGCXrfgNlh4gSa
         UqGUefR88qkHSixL22N0BAXg7gJ+wRlOnpYZaFzKVNBZ0tMfnhq70r2pwLxOiQlUbvod
         h84UlpS6sGWiW/6SYxR00kR3/trBPhn6sPJiOq6Zvi5/jnwTyVzpFjC9HVz9LlAPLFXD
         uZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438109; x=1789042909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pJ73qBOQiTpXKwSrjAZqmWemxXwNOfQBE65lRVHowjY=;
        b=bFUzcFFb+yDfFXGKuREiCMVV5GPDrVJgvps22SM6/I8wqh0lwAcdpS7d6KBOOOLwyT
         E9fb1ocCZM1qsiELmC/Pg9NMsaCaEiGxqBCz5UBHYoFUyKZqaP53thtnpe33+ysmz7Ep
         r0wV5paGZBt4jACkCxxDv8Z97HHRFefZYSypYDqlGsJ3C7MoAoB6NFkf1lLRiZInKmCG
         WvbDEH4+iRg9yDrjnmL9FAEhdkTph8LAOrG3Kowyf7hqd7leQ/ThXYMrQuRdXH75X5FR
         ZCOr81a5TyYz5geVdK53t9aztNtuHHB7uJ6HKk408KLwizLJBEblc+81bUJwXZih9J55
         f5OA==
X-Gm-Message-State: AFuF++mAtNP9GPXgumZ387Xyp+JEIEzPvBPnEFfh7uHQj3CbLXhneLv2
	XQP8qKvpAyNTVQYO71g1NWbLyLQDPF9qhObCuIWEPrGGCahrjoMpUsP3SWm6vMH6+RM=
X-Gm-Gg: AYBFou2urZkTsJO2Y3eSQnqcg5JsqTdbPwfhEwJSdUGSCF8ArXz733ELgrjCQaqM1DS
	1etMCgqN+9C6jhU0dU9G68ZwCrbNptBeJgRhcjyYI3kuCXatxD4OBWWQklnPmXnX4j+t03GrxSt
	ogw7lGGK6bVOC8/5oW0Umghpq7dR+3jzb5N5+gacIhILuYG+p/D/PaQKOfl0vcrCrIf42zmK5rg
	19uNNL70/uF5ZwSXdZpwLLsCAHmZTaji/hafm5iQPgw9WLZhkezNsvtEck+3rPvVNd1tKo0LvKs
	gFzOnxk/IIb56OGA2ew6XJkMrvNj2hrBNEvCnlTGf208wOokt6xk8ywFSSP3EKGeIGApGDg8sLU
	xezDWQn2yi0ataDPOGWLHlnmX0qUvJx8vl2lxiKfsLIZRKifIarLLPpEAX8QAY1ejexjHYd4aHY
	0ip2P5tFSUi7DdfZ+poYWje4/dnWhgup+1UXoIzsrFqIwYAugDs5IC9CIg478DU0T29n2L/QN8E
	GWYjzAgE68BnSXggi54mxT8Gg==
X-Received: by 2002:a05:6a00:3021:b0:848:30c3:45dd with SMTP id d2e1a72fcca58-85ed2cbc58amr18768996b3a.11.1788438108017;
        Thu, 03 Sep 2026 05:21:48 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm2868126b3a.4.2026.09.03.05.21.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 05:21:47 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 1/4] mm: generalize vmemmap remap architecture support
Date: Thu,  3 Sep 2026 20:21:24 +0800
Message-ID: <20260903122128.12264-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903122128.12264-1-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z5f4rxt7114gmojy4rnpb6hxatoobwrh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4BB241C0003
X-Rspam-User: 
X-HE-Tag: 1788438110-977894
X-HE-Meta: U2FsdGVkX1/FIZimm9vTkyq7umjetiz/EQMR5ofT3s+dAvBxxvZDtm/TWo41LrKw1jwNu6ccY81Y69twmKj01I/z4XFP1y3G74Y2J7JeIvxAs6lixzZm7i3DEv4l+4s+sqlb/a+HebMHUpHFbb8MF8HG5xXhEnoGkv6gFqeHNKh7KykYd8icmgnm5FJo7L660Fau8E9eiA9TM6jZBS4a99DU1kgdTHYOKvAROhHLRhX1HEdXStxTcmpyXs06KMYJXa0KrRBYaTTreVEvoUWPqBsFfAFPtgmOabqcpSUO0T9CyJMcIa9QY4qa7mkH6Z+vP9px8s7jLYpuwyTLABj6I2RtGD9j8mTNRVrPJnPv8THUDo8r0ok9Y3JyR4GDfARd0Y+dNVikOUItjOiS8a8VGprCnV2MPj3UCuB7LP+m7yxMrPVn650XbiYrzVAL3II9u2ck/dV70+JKru4vYmFEcOLvzkFNaZp9ogELpN/GMknPWo23X8z7/U78rOMlGzVL8a+A4eIIhgz5b517HCwsUV36l2Z4gycPybDUnmwdd/jtg9wUl2KqIFTp9//rRK/qcBI/bpaqogbDvFtOORobh47Hirmp3A2+gvoT3KaT+YZ3u8akYT6wfpmhqRcz4fW08ZhWGkubpIszM95Oq1mGoVmYrrLqSHriOExmmDvups0N1CCXx41GtSGCi8b0Z7zbzuunhg3eWXydmV/EezKFf3MhSgcvlLu+dHUGjzq8ARa3DNV3Bz4Rf9M+0fcNM1E71eVErSUsmQ6eDptYD4YYYo0iY0T6EmYIiWYR0Jtg+/l3w04vlkZB4M86z2il73dUUt9t0YoBkC3asBVBl+BmNBwvqvL5rJVjlUqs2C8D7LRXkLdZXqAFr1WT5pO6iiGuSuuxOnQ27a5TC4sI137qrp8pZrdjgxAarmuZ45laaMT2VYuktoVtIgmGZdCCrNjHoV9o1Y6XEfcWqBBnUeC
 6YyGV+C1
 pjhFU9OPFyHJvWJILqxAtEwEFsvM2YkbzJka4M++f3kSQ92EdP/8CQfP9TYfzlVjwTGQov9pE1KSJ5wPZ43qCf7AiXN6NUIko4s5c5RwHMm45HChvVR0njwcrW/p9NPafMDYy/Enf71SDZVfdUN/utH6UX0+MeI1LarTnpcNiiExMquT/A8kQ60L2AXs1MZZ6PkIGYsgVUjy1xss7QIE8DgcDnP+ZSnRmtyYl9nD5megEuj/7f4ciJ3qNGKu6fci/eyuvyd9kFuIQqJpMh8wtQ2QOk6caDmZeEmRW0BdhnAp9KYzPDlntUWD2iooES4yHPv5Vb+LdlkNzJGm9xfvP7Ljj3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP is named after its first user, but
the underlying requirement is not HugeTLB-specific. Generic MM only needs
to know whether an architecture can safely remap populated vmemmap PTEs at
run time.

Rename the architecture opt-in to ARCH_SUPPORTS_VMEMMAP_REMAP and make
HugeTLB vmemmap optimization depend on that generic capability. This also
prepares for FS-DAX vmemmap optimization, which relies on the same runtime
remap support.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/loongarch/Kconfig | 2 +-
 arch/riscv/Kconfig     | 2 +-
 arch/x86/Kconfig       | 2 +-
 fs/Kconfig             | 2 +-
 mm/Kconfig             | 6 ++++--
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 9c5def706222..e9bf19172e86 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -72,6 +72,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
+	select ARCH_SUPPORTS_VMEMMAP_REMAP if 64BIT
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_MEMTEST
@@ -80,7 +81,6 @@ config LOONGARCH
 	select ARCH_WANT_DEFAULT_BPF_JIT if HAVE_EBPF_JIT
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 	select ARCH_WANT_LD_ORPHAN_WARN
-	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if 64BIT
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select BUILDTIME_TABLE_SORT
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 5965666194b0..3614001cafdb 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -76,6 +76,7 @@ config RISCV
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_SCHED_MC if SMP
+	select ARCH_SUPPORTS_VMEMMAP_REMAP
 	select ARCH_USE_CMPXCHG_LOCKREF if 64BIT
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
@@ -88,7 +89,6 @@ config RISCV
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select ARCH_WEAK_RELEASE_ACQUIRE if ARCH_USE_QUEUED_SPINLOCKS
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8c3b3d31a27..53f72d1500c5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -133,6 +133,7 @@ config X86
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_RT
+	select ARCH_SUPPORTS_VMEMMAP_REMAP	if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_MEMTEST
@@ -148,7 +149,6 @@ config X86
 	select ARCH_WANT_HUGE_PMD_SHARE		if X86_64
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
-	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
diff --git a/fs/Kconfig b/fs/Kconfig
index d1c210c6508f..655795fbbd1b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -276,7 +276,7 @@ config HUGETLB_PAGE
 
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
-	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
+	depends on ARCH_SUPPORTS_VMEMMAP_REMAP
 	depends on SPARSEMEM_VMEMMAP
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
diff --git a/mm/Kconfig b/mm/Kconfig
index c1ddf59c0d71..7ec734d89beb 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -463,12 +463,14 @@ config SPARSEMEM_VMEMMAP
 
 #
 # Select this config option from the architecture Kconfig, if it is preferred
-# to enable the feature of HugeTLB/dev_dax vmemmap optimization.
+# to enable the feature of dev_dax vmemmap optimization.
 #
 config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	bool
 
-config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
+# Select this from architectures where generic MM can safely remap populated
+# vmemmap PTEs at run time.
+config ARCH_SUPPORTS_VMEMMAP_REMAP
 	bool
 
 config HAVE_MEMBLOCK_PHYS_MAP
-- 
2.54.0



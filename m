Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B24E6401A
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9B76B00E8; Sun,  5 Apr 2026 08:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279536B00EA; Sun,  5 Apr 2026 08:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168BE6B00EB; Sun,  5 Apr 2026 08:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F382E6B00E8
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:58:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE59D1B8B46
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:22 +0000 (UTC)
X-FDA: 84624505644.05.20D49FE
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id EF1F640003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZS1wfpfZ;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393901; a=rsa-sha256;
	cv=none;
	b=kFRx9UN7VoL8x0VBO7E0jU//2WRLJf+yshZJJoMvbeIIiYKyFJmj8MpQ8wXawWXitKg9sd
	Davc06XgU9Idnh/AobYXqwwekg3yG7RKROEhSnpBwrQActOnamscEde/kr+4pwfD6Jl9L2
	sD5tndLZfMwN9iunuVcoAJQKDDSgjyg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tR6tFFSAYX0KQImZ49bGZfXfFcdkBNLOh7cRjPEro20=;
	b=G7kF0ronh5ESl+mUNwy9685ifOaTFDYrPWZEWysjrG6G8zZECDt8BCs+mYQ0x0Ew34fdXC
	Pb22vBU/gBmBKS+qrICrTRWjNhgvOR1QF6Bp/2h1HiK60pPmVGIM4G1PjedsAwnkd2ZyLR
	N6N7j7/sRulLQ6Vhyxm/kLfEQoY3d8I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZS1wfpfZ;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so2030775a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393900; x=1775998700; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tR6tFFSAYX0KQImZ49bGZfXfFcdkBNLOh7cRjPEro20=;
        b=ZS1wfpfZ5US6smuRGySJ05oPBweQvoU1MhZ1qg2jR6aEFJZCKgg3l/2Oro2D/e1PW8
         IDDaxmpoWMzPqxCP9HlI08j3kLUbjM7fATcAsSxCqvo1iD5e/eDiMHG5NgkSEqT8sGdY
         G1ZqSprF1YoGY8+wJ3C51T5m6QxJDPoKFpjVd7CsJHp/I4ONETDenkEiOUqrIhPuGGSg
         7Oj9RY0FGWhFJt3KMgeUz33ADLnSkgjGWJtfI5hW9Vj73T+9GAuVovtiFeYsusicSd4r
         3ryaUbHZL7G+74KUP9vZuEj28eFQbaoJ3iMVBuQIs7fEX469OwiPy2pLs9SU8C7y5/Ti
         YUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393900; x=1775998700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tR6tFFSAYX0KQImZ49bGZfXfFcdkBNLOh7cRjPEro20=;
        b=iZsjzz5wuKaPb6jwNImqIIgKPoyIMC06Qy1NZWQAbEmY0M+DJbgsTZu0kBDEY6YsEG
         mkwRin3nZ27xK77m9PTuLnexVnVVy1/L2brNcNWjZndZk9L175PnTqgFN4d81Qz3XpUf
         pjdFKbXAs6JslNXomExML+pGTu4I8QnrDe9C/Xb53n7jSuZFpMJO8JdUk0DSGgSvRdok
         tbU16X8nEMT2tX+cRpFlJek+lBklZDaCFD7C0s/Bla/KFLHThonGRSpgVIMZmXHedMhD
         EY7+TFO4AXTG0J3U+1dZBbrzy8Zqdt9e/RrXKgHgE8lon587L9OZKPDs9/WLiN67ZDPE
         Yhvg==
X-Forwarded-Encrypted: i=1; AJvYcCVz0d2xOUzv9vPO9V/h1tS+9z5/9Zib3FhtQN/44UvMBmh6l/p/o+fvxJXX/IL9l6n/6XHsK8HfvA==@kvack.org
X-Gm-Message-State: AOJu0Yyr1kkZ3PctcC6s5J2yTe6L2sUXVkANJWNrkm6rSIiai7a3l+Hf
	mNsD5o169adsH90XQPw6dzDEKyYxupozuCjyUY0F45cFRBbuH+d2iqGmSv69XXZH7Zg=
X-Gm-Gg: AeBDieujTTjsRFPSrzAmTzsWsdzrhiOmu6jmzQrPL/Q/LePCup/Qviejx7fObY1HcSy
	9mNIvM6ZDfqJSrbx92Zak2fvOW7+0EOykkM6oCKyK0lwUXLn5qd/fXdA1g+/6uYdObd9e53/1jR
	0p5qHxR5YiPug58FUN/93mSbROq76VTgaxfMTW7fC2DzMuJ+mJ7kjBkPrZXf545xLCukonO0xm6
	hEFEjd4GwTQkYvmtbKmE/MQ0qmmcrginlLat3rQ9sUwn4rSBbEHcBg6wJrAaBbhd+vXRCR7GqqC
	cy/pyMe8TZcRRfrdGLqjy5QFAILpH593ji69KP2TkXbDni3/FoOjaNb4pqfGAJXRnjpjQ16V43q
	cwr2WXyATy4b9neY28FkreqS75s0xQxV641Wxb4dsgxpu0JCSzn55Bgy4OZuLbrd+7wdvCBAECV
	ixo7XyGTcCkpCHs3m2Z1C1SKMpMhgdCZS8bMrjDRJgW6s=
X-Received: by 2002:a17:90b:224e:b0:35b:e51b:1935 with SMTP id 98e67ed59e1d1-35de68cfba8mr8245353a91.17.1775393899744;
        Sun, 05 Apr 2026 05:58:19 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:19 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 44/49] mm/sparse-vmemmap: drop ARCH_WANT_OPTIMIZE_DAX_VMEMMAP and simplify checks
Date: Sun,  5 Apr 2026 20:52:35 +0800
Message-Id: <20260405125240.2558577-45-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF1F640003
X-Stat-Signature: emmopmhtsf9mmkzi315fzzze1btqjgpb
X-HE-Tag: 1775393900-288033
X-HE-Meta: U2FsdGVkX1+ePYH0fDGdWBCsuEafgnf72JFJq/qWY2gjhVUZf4q3EcqyvF9aXO9m8/Xc6l0skjvjwACCUFnOxK3k7dyUpvQdAl1OpwattVzPxdxddwgjKTgvg7lA9YtCHg108wR1gMijpFpUxKIajQttebe6wmtOkhCgMlGbRM2lrTV9ZP8tXaKwj31rGZoL9/5eAaRNTS7xTxeAoWSihZmiUVG+2IrNw3sDcwIIhquhskxiPdf1ZhCmeWBr46s8sQ9edgmPvUBT5LiNszl4WTNE2RaF9eTNz4tz/5k858UTdQlCA39XBJYtdgoPy1hufRC1tBq2lR01KZ6yh9nNz9E+lLbNBqY0QMhgoA4cwDOGaPn+1UsIvxQ8JqC2b2Nuqb6asX3VnqhWMrpj4jcPJyYqZbFKhGEMQtcD3iLA1aZlAj9T9ztlMI3HgpkZTXRC1BNnLqv0P7VyJp+6jbtFSiOtrKI9c32/I0EcyvmZAvDmMcMzr4shIPbq8Hk9ZWUP5VPspSdYt/lnNktgzGVFppdst/1JjYunCwhWxeFu8NN0eOOSb9xY0iaNf3icOb1TbBhukTxv+7gusNtJpNfCtH8tdPIWDK2vY9d2GPOkLVnLZP8Agsl4wJ3huzS7aFmf2/9XBExrWpU+ojMSXciwfl7zZj+jRkQ9FMw4ervSg42b6SadGDc2gUV7kGZYlZ6bw9vu9k0VQTAtU05ci6ypYXO+DhTout4SosA3JvVYISuCe6V34P1k1qAGwti+FHIG8NDGd3l9oBPDTGQQ7kluh9vMteUrpxk5aDGX1fwR0jlKgiN547T/Eng6foaLk8RvXraPHS5cehSWTW6I9M7fhAb5MVhZFjm+hP0AletHXgzQ9fYXe2i7IqTwJmK4xuha2scnUpFTYad/wAo7lryCvKiNNJNWkUcOc+POySFa82TrFal6y2h1kixXhbbOrk5jijsO632M1xwpgDIxodJ
 0ajNOaKY
 sRlmeGHAGAjb3kDTYxBVI4s25C7geKQZ5Tppo1GbRMDiHa8hobXA0JhdhIl6adeFUimDD35k1H6GN2gkeijlXv9aTZOKtXzN4hRezHIzC49jwgTWFekLGSldfL/lGg39AnjH4Pg16aRZ4k3gZsukLhDjqOXVImdNR2Mt2mueJj6OHV328CWfhKXGpxOlqJnmCzg4V5vmsZZqv9rcRxgikxk/4aC6ylfgDFXPU+RPI84+PzAZvYEO/RG+6sG/KFPpczfJ1t+BYBRjJCZDGQC6mylHWYz15b4HyLDLINfyUDmRLj1Jio2Nc+/Y8nA22Tl+a8jc1ZLdPlZ/j4Csc11zW4TJiyTNPLLH/tGIqkjd/YvXX1iiJc0HnegCyB/D1MW7R7LwXyjEcvWwOQkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically, when device DAX vmemmap optimization was introduced, it was
initially implemented as a generic feature within sparse-vmemmap.c. However,
it was later discovered that architectures with specific page table formats
(such as PowerPC with hash translation) would crash because the generic
vmemmap_populate_compound_pages() was unaware of their specific page table
setup (e.g., bolted table entries).

To address this, commit 87a7ae75d738 ("mm/vmemmap/devdax: fix kernel crash
when probing devdax devices") introduced a restrictive config option,
which eventually evolved into ARCH_WANT_OPTIMIZE_DAX_VMEMMAP (via commits
0b376f1e0ff5 and 0b6f15824cc7). This effectively turned a generic
optimization into an opt-in architectural feature.

However, the architecture landscape has evolved. The decision of whether
to apply DAX vmemmap optimization techniques for specific page table formats
is now fully delegated to the architecture-specific implementations (e.g.,
within vmemmap_populate()). The upper-level Kconfig restrictions and the
rigid generic wrapper functions are no longer necessary to prevent crashes,
as the architectures themselves handle the viability of the mappings. If an
architecture does not support DAX vmemmap optimization, it can simply
implement fallback logic similar to what PowerPC does in its
vmemmap_populate() routines.

If the architecture supports neither HugeTLB vmemmap optimization nor DAX
vmemmap optimization, but still wants to reduce code size and disable this
feature entirely, it is now possible to turn off SPARSEMEM_VMEMMAP_OPTIMIZATION.
It is no longer a hidden option, but rather a user-configurable boolean under
the SPARSEMEM_VMEMMAP umbrella.

Therefore, this patch removes the redundant ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
and drops the complicated vmemmap_can_optimize() helper. Instead, we
unify SPARSEMEM_VMEMMAP_OPTIMIZATION as a fundamental core capability that
is enabled by default whenever SPARSEMEM_VMEMMAP is selected.

The check in sparse_add_section() is safely simplified to:
if (!altmap && pgmap && nr_pages == PAGES_PER_SECTION)
which succinctly reflects the prerequisites for the optimization without
unnecessary boilerplate.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/Kconfig |  1 -
 arch/riscv/Kconfig   |  1 -
 arch/x86/Kconfig     |  1 -
 include/linux/mm.h   | 34 ----------------------------------
 mm/Kconfig           | 14 ++++++++------
 mm/sparse-vmemmap.c  |  2 +-
 6 files changed, 9 insertions(+), 44 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index da4e2ec2af20..8158d5d0c226 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -184,7 +184,6 @@ config PPC
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 	select ARCH_WANT_LD_ORPHAN_WARN
-	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if PPC_RADIX_MMU
 	select ARCH_WANTS_MODULES_DATA_IN_VMALLOC	if PPC_BOOK3S_32 || PPC_8xx
 	select ARCH_WEAK_RELEASE_ACQUIRE
 	select BINFMT_ELF
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 61a9d8d3ea64..a8eccb828e7b 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -85,7 +85,6 @@ config RISCV
 	select ARCH_WANT_GENERAL_HUGETLB if !RISCV_ISA_SVNAPOT
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
 	select ARCH_WANT_LD_ORPHAN_WARN if !XIP_KERNEL
-	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if HAVE_ARCH_TRANSPARENT_HUGEPAGE
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f19625648f0f..83c55e286b40 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -146,7 +146,6 @@ config X86
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE		if X86_64
 	select ARCH_WANT_LD_ORPHAN_WARN
-	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c36001c9d571..8baa224444be 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4910,40 +4910,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	OPTIMIZED_FOLIO_VMEMMAP_PAGES
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
-					  struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages;
-	unsigned long nr_vmemmap_pages;
-
-	if (!pgmap || !is_power_of_2(sizeof(struct page)))
-		return false;
-
-	nr_pages = pgmap_vmemmap_nr(pgmap);
-	nr_vmemmap_pages = ((nr_pages * sizeof(struct page)) >> PAGE_SHIFT);
-	/*
-	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
-	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
-	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
-}
-/*
- * If we don't have an architecture override, use the generic rule
- */
-#ifndef vmemmap_can_optimize
-#define vmemmap_can_optimize __vmemmap_can_optimize
-#endif
-
-#else
-static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
-					   struct dev_pagemap *pgmap)
-{
-	return false;
-}
-#endif
-
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
diff --git a/mm/Kconfig b/mm/Kconfig
index e81aa77182b2..166552d5d69a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -411,17 +411,19 @@ config SPARSEMEM_VMEMMAP
 	  efficient option when sufficient kernel resources are available.
 
 config SPARSEMEM_VMEMMAP_OPTIMIZATION
-	bool
+	bool "Enable Vmemmap Optimization Infrastructure"
+	default y
 	depends on SPARSEMEM_VMEMMAP
+	help
+	  This allows features like HugeTLB and DAX to map multiple contiguous
+	  vmemmap pages to a single underlying physical page to save memory.
+
+	  If unsure, say Y.
 
 #
 # Select this config option from the architecture Kconfig, if it is preferred
-# to enable the feature of HugeTLB/dev_dax vmemmap optimization.
+# to enable the feature of HugeTLB vmemmap optimization.
 #
-config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-	bool
-	select SPARSEMEM_VMEMMAP_OPTIMIZATION if SPARSEMEM_VMEMMAP
-
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ac2efba9ef92..752a48112504 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -698,7 +698,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 		return ret;
 
 	ms = __nr_to_section(section_nr);
-	if (vmemmap_can_optimize(altmap, pgmap) && nr_pages == PAGES_PER_SECTION) {
+	if (!altmap && pgmap && nr_pages == PAGES_PER_SECTION) {
 		section_set_order(ms, pgmap->vmemmap_shift);
 #ifdef CONFIG_ZONE_DEVICE
 		section_set_zone(ms, ZONE_DEVICE);
-- 
2.20.1



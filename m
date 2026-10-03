Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A25EDCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0A06B00AD; Fri,  2 Oct 2026 20:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5026B00AE; Fri,  2 Oct 2026 20:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16EDC6B00AF; Fri,  2 Oct 2026 20:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7FC96B00AD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 763B61208BE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:49 +0000 (UTC)
X-FDA: 85279411938.23.830AAED
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id C3E5440004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J3Zcd7rC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3mkrAagoKCI00Ay5BxyA54x55x2v.t532z4BE-331Crt1.58x@flex--jthoughton.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3mkrAagoKCI00Ay5BxyA54x55x2v.t532z4BE-331Crt1.58x@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVvjhrnHN0xVzOU1sGetn/TIp5Cpe7kDHcSDZkewKqc=;
	b=eTu2oEi42/g7A0cQrIL3d0ayUgDOk0KENx2nma7dkYAztvyWeEwegjW044VZbh56UCXa7Q
	0oltNpNHYjt1ItxfLY4CME/3222GTLvKql9xwQFPGlNXFFBIcCbK3k41L4jlFI8vGqo6Ze
	c0IB5QjQMuWUz04EO3NpRVtcOvcw6iA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J3Zcd7rC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3mkrAagoKCI00Ay5BxyA54x55x2v.t532z4BE-331Crt1.58x@flex--jthoughton.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3mkrAagoKCI00Ay5BxyA54x55x2v.t532z4BE-331Crt1.58x@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986907;
	b=pNIy4j89NMkdXjXBi4DRq+Pes3pQItn9wCeyXmSZL+P5DpN5+h7n29yq7CE93lPpVVCU8m
	AaQZT1L2ZZxP59vmMC8rf8cbx0pBd9EMPEJtd6gGRgCsT7uTwlmDx6CocQkubeVizHSdFe
	VRrnrwYJKxLYQW4YaDZQZBtF89W4t0U=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-88c768885b0so76132b3a.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986907; x=1791591707; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVvjhrnHN0xVzOU1sGetn/TIp5Cpe7kDHcSDZkewKqc=;
        b=J3Zcd7rCUPe7xmSRrSNVoqUoAJVGryTPWbsZuKo+3loG5OP/WMkkpFvA0FZUtTd3XB
         dM+Mm8w/tB9d6nXTgf9AoMjDtMPAR9XJHPFTAU9davuXnHm1HabBNmBNyGGL4MdWdZOr
         3DnNdGRnzz56QA7amrq2F03y3D28erybtPTxxmnIVHFUu6l4JIyV09ImEMI27FgiI9bq
         wA3+4deGLxgPclriY6SyVkIgkKTbRsqsQf3yIQJO2ikJeg3NDLpIuh5LbS5wYfRFejg+
         Anl2euA4wppU5g1TlGoVaqf0oIqJjW81OtyIkFNLGSyFASj1VjvYcvz+Z5ITVCbFbvW7
         fodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986907; x=1791591707;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EVvjhrnHN0xVzOU1sGetn/TIp5Cpe7kDHcSDZkewKqc=;
        b=mZNqkonYzRbrxSAlTJWtFJeE+Z7niUzLT/EvAQ+97rLOo/tiM3fPdrlfk0ebtwOKZq
         wkWEiI538AIEWQjkXbUbhd3ACdaK9azzlk8Zpgbz5Ypg2QdlV9c8ip6D2NkkgAKuSJVD
         x14u+xPuL/i7S27WUsMUuITrM+OXzv6jf/3MhvoniVuPA3i6GFj7RiRu5u0xN1sRgu4W
         7eD65WLKKAL7cQiLONeFfw1P2SEbtF/BA1nPTaMuapZoJtfckTIwnrXCocRBHcA+CmF5
         txuqH5Wx6UYy2cJW1QMAoSG8cotrPL7iugRZBtZ0U7zb44fHG9NJMUwWs22F2AKLLVyh
         IM9Q==
X-Forwarded-Encrypted: i=1; AKwUvBwnuAgeMIZIH22s1EGgq3nux/VdO1ZcErU4aUuJO0XMIWEVyA0u271IzIKRuURGOdVWDJ9A+k9y3g==@kvack.org
X-Gm-Message-State: AFuF++m23fOycoqc+JCOhWVwV1JdiTA0SysV4WBGgYpq2Iese2y9W0TJ
	G6QwROvWXEUNhlVwLxVHy0s05rRlLuDTn81/QNPUkQbivBaNbujnjfchTukjqVfME9YIInsWSio
	jvv3XUe07yhkgJpCnkDcxSw==
X-Received: from pfbf1.prod.google.com ([2002:a05:6a00:ad81:b0:872:9706:205a])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:138f:b0:878:3783:8a4d with SMTP id d2e1a72fcca58-88af5ac19ccmr4135678b3a.53.1790986906132;
 Fri, 02 Oct 2026 17:21:46 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:16 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-14-jthoughton@google.com>
Subject: [PATCH v2 13/20] arm64: Support hugetlb vmemmap optimization
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C3E5440004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bfbcthmpy64pxgjpy4w8iepu8tgkgkp5
X-HE-Tag: 1790986907-199340
X-HE-Meta: U2FsdGVkX1/vJrFvMtNKmAqbqL+a2P/KP4A65k3XgjlojXJR5BT9AvaUPKLAMr8OFEEedAL0hrI8CcqsacFvucgD35cKpfkiAD2ZRZS8yqglkEYL6mhRU1VDQMMimg1SoWlJ3d0UVeerQm33G3gE+868cw5tpSlzpsBaRFM3cees6SRT5F+JviEVgEeBz4u4DEKi9RCFW/TuvQz51buWSQFSa7kazbGxBnOsbscwiCwBkp7j6i8hJQ66u/wB7QrniXo7y7TDAPggIS2Ygekhv3McKi3hULksH0FZQ2y0tcIu5M2q/+KD9zpRmSu8Ol5jqt24JdN+cj+qybmSE3qEwR8hJ1QiyrfZMWwMGsDdjDiY8WyMpWLNfen1t6lQVUQbX1M33pOKXIjbX4ndHtrDmmfjUgBWqzXeLzmdhmrfqrA7w4bspV6NH087x5oxO6aU85T4HnVE87AskBCgpFvelIfR5RaLxaCrLpnjwqhnuruCCftrw07j7L2KMcD4QpDK0cJRm7yzk6MqIx+1FpQD9rltLmv51SJIZs8vlTn8J57Zt75pQsslcPBpEDY3lIwOejkoEcNUSEQid5Kby72KZesc42MMTdf2z8sAUeNcquz/RPqhtMs8DXitfLpYQfRhMcuaSrdJRd5byAXGadRELiGiaCP8cWBeddw6pbp5YXqiYH3hZUb2TZOzDp3hMTcFDGWeTsAUxYwKWBrUCk1QoTjDlofdp6dtGci94q5xxAWx3/8wY/cXW6F2NiUs5HGcbCjXHKF3h1A6mKza+k9WrXzm3HDTNhnq5tqJf5LUbC1XL/IhCpigyc0T2oMLi2xd8XZVF4bmZZFpKGrOVPiIPSSD3CGUZ4mxttQ3lXYY/iD22Rs5EaerWg5ILojOzOhE0IEmF77ZuJzffU7Ei9CxX8XnC88qbPqtxnbWNNNZ59eX1U9u0UCS+IskSXzd6Rkf7HjdpQUr/7i3gLLLYTV
 mEpXfJlF
 rVFgmAzgnNGF6vlZZ7qwOv9Ff+camjbPJof/tiwL3tjODb4lWVZzNPVr/bNn7hHYUZsdzRwBdJHJ5eN7iVjD4gryIFa5dvjQZGIPMCqjbEHJvggyMSKHMYeIWArUeVYV9W/hiVnpqhORRd3io9okzRcCZOuE1986SjtDPrz7im+F8693i4DinRhxjSXzEBNnDvPQLLtkx+ARCPUmND0iMZGmrUt1hIM8KcwduiudREl9RG2V53KlVTfQckgs73FsqRTd7cqTSW70rjwpdVI9qWbXOuMDPf9cB/PsA6c/yQSNpcAnp+wlUGpSRdRWlwNyippDi4i4HPTrnvQ1/54rpVeEwQ1mRlxoCiD41X7ptSKtJZUgBxXWCESn8gxDlWlOIIKRtRcgwEiP8HoICOg0AvF7/6Vlk0C3+jhDfiWcBx41S2ppqLoZYtXyYZLkOmvLhOLtRj45syn3jUMM3WwSIUAi5AJSgK7nk287Bh1nf60w0js2aub/OMUYTnTdh7pP8gbW7G0C0PEWPOrZHe4qdC7yk4Upqf7XXHzBp744x1KLixhO1pdfIOXxwL13xX9GhV8w+N1D8Hr5sAflTpxfzv6zgjBWJ+dxXlXsDXlLa7efhLQfwFEhX9iHtItRa8AjzpKJLDhg8odnGLFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Support HVO if HW AF and BBML3 are supported. These are the required
features for the vmemmap to be modified in place.

On arm64 systems that do not have the required hardware features to
support HVO, the HVO sysctl will not appear, and any attempts to enable
HVO (either via the command line or via
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=y) will have no effect.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/Kconfig               | 2 ++
 arch/arm64/include/asm/hugetlb.h | 7 +++++++
 mm/hugetlb_vmemmap.c             | 4 ++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b51d23a62c92..e4c87487bc7f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -92,7 +92,9 @@ config ARM64
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
+	select ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT
 	select ARCH_WANT_LD_ORPHAN_WARN
+	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_HW_AFDBM
 	select ARCH_WANTS_EXECMEM_LATE
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
diff --git a/arch/arm64/include/asm/hugetlb.h b/arch/arm64/include/asm/hugetlb.h
index d038ff14d16c..938d7896a31e 100644
--- a/arch/arm64/include/asm/hugetlb.h
+++ b/arch/arm64/include/asm/hugetlb.h
@@ -11,6 +11,7 @@
 #define __ASM_HUGETLB_H
 
 #include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
 #include <asm/mte.h>
 #include <asm/page.h>
 
@@ -65,6 +66,12 @@ extern void huge_ptep_modify_prot_commit(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep,
 					 pte_t old_pte, pte_t new_pte);
 
+#define __HAVE_ARCH_HVO_SUPPORTED
+static inline bool arch_hugetlb_vmemmap_optimization_supported(void)
+{
+	return system_supports_bbm_through_af();
+}
+
 #include <asm-generic/hugetlb.h>
 
 static inline void __flush_hugetlb_tlb_range(struct vm_area_struct *vma,
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c1c736dd08b9..fabf2b25fe59 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -85,6 +85,10 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
+		/*
+		 * On arm64, this requires BBML3. Its support has already been
+		 * checked.
+		 */
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
 		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7299EC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C6B6B0133; Thu, 16 Jul 2026 11:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE766B0135; Thu, 16 Jul 2026 11:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC2E6B0136; Thu, 16 Jul 2026 11:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C60876B0133
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 278AAA00D6
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:13 +0000 (UTC)
X-FDA: 84994605066.30.3429097
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1DB6D20002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i7Ld3Y8W;
	spf=pass (imf31.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QhVe14fP0y9rm/shff3jRao3xNlRAMh2yWf3Ip6xG8=;
	b=0IPQLlohnUk3pOpPW8tYJxwAqLvgsuFepH4aLnCM8DJag18KiBJH1rlBPgKIpRbor3Xvmj
	6Te+BLeKSJAGLPe+5znwhuSh1IFDJQN7unOxwzJE/b9Ye16gJ+kbnLs7DY58WEx17FVwqo
	7hkx/c4bBkNEFhvFQIx7kK9uYK2dKMQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i7Ld3Y8W;
	spf=pass (imf31.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205791;
	b=c1oZYScTnT2uNPf+OfGX8PkX8I4ofpe+fdMFNIKkaZ4NzBBzfxoYBwB8EGfe9vc+BfB/bO
	jaDBUieLz1lyvkGH2OlWU321OXNuuiSGiHDk0MpCSu+Qj9sneCG1n7C3vSQkciR73amTIB
	Sool0peC1QF/FQm5H6i5FVb0JBl9UwI=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso216464a91.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205790; x=1784810590; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6QhVe14fP0y9rm/shff3jRao3xNlRAMh2yWf3Ip6xG8=;
        b=i7Ld3Y8WGNSVJZC6WvECQVBY7cdWlsW/tBlADpt0Djz7qi4QOg9V7YXNiuw/DI/Ugr
         vC3PhtgN1AbpjSvpIoAW22gCIUaQtRhtHcBdIjCC1kpT/rvB/aaZZkobSveXNQdoQfKH
         eor0VbtVNiE+uDCrgE4DqCQX66h1GI2Gwj0FAbjGI3jBgaxPeaDKVqqsBeui2ZwhLP+I
         VPA7Dh3AJKPy9WzPJZHTBxW8CdofzvVb7NVcAyWgu0SnOjuXUpcmLPCWcP7X8sNvs8jJ
         /pDdVCv4gnAtKp2aIlxtva5qfIykQ4Ucn7gFHRGrD5GOTL/EQK0a9SBdjlg8R9odY6wN
         YO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205790; x=1784810590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6QhVe14fP0y9rm/shff3jRao3xNlRAMh2yWf3Ip6xG8=;
        b=Q0lnhRd3f02hRvGFYqxaVuudQFxXg6rCu5S46Uan/Z783Q2ogR8IqXsAB9PamnPm89
         RETz8fGcHj4e21K/rQ89DPz2+gKVgVR4YpXnD7i9xpJTY0GGEs+vt4Uaw0o24gQbNtt+
         mnryusAIHTBgItwyDrATljb2FwmCmvLDt0JIgLelDa/1lEYto3ldZVcEn/v9azL9jq/O
         dUS/JjKakVJaNtcIXYbHwo9fZDw5h9aeDcEjvPH1iUAMdCgIdLmuwxSq9QbFqYFo60ff
         s27iFHPS5yq0pedzinZI8BIIcW/Jr0RbiQdPCSoZkufqsui/OVY0OIAp+TuWVcgijWIk
         h2og==
X-Forwarded-Encrypted: i=1; AHgh+RpalNZLkYJczDjvnrInR3qN0PX9EJ6cJIbDDgdp1rrfWHyiygEEBUfgGCoaroRfFH6pwsYdai+d/Q==@kvack.org
X-Gm-Message-State: AOJu0Yx047CmFAHkWiNyxRj4xcBrEtXvsZTPX6NeV2VPIw3Lvf0EdGxV
	IKTSkKci1z/FqLDbht6hV1ZBNifX8OkILPPcDpirqYRcsnTfctIkCE6e9i7Iak41okQ=
X-Gm-Gg: AfdE7cnCy2vnCMM1X66C1X8qdcd+EF1gRCyCWObJOESuePmNbRFboQmuLzj3zdxDV2k
	87bAOabtSF3x7G5iSkoTVbM6+oc50RjYbtOuG03DOPaM/P7e3kbtHcUgNYpnyXgjX2mRPJGIDrK
	xLWEEA/qJ5PkJzxJloVTp7Li3yBi0jgNEiuSjLXhLe14p+YFiJhwr9+X2k2hZfIODDrEVPEFp6H
	ZzAvg3jLPGeCnMGe69pRP8OOdJzjfv/mntSlONSstj6Tu9q+8ARHjIKj7motj7g51P4JWe+3keQ
	y30bh/q9ua2tQT3qLqqISnB9esx8ylnGBe9s0i37HkYMURw94QjyX1LbrPjhsvFojPQUXae2KJA
	ZKDDg3VU/OFRX0MhAA8UrwB6c9v2C+86g4qvCF7uCblpe6cMwMh6TYfZUjfVpRlYweTypABxDnG
	PUdJlhCq1j6kZBYY+7cBHPreY=
X-Received: by 2002:a05:6a20:6a26:b0:3c3:990b:2292 with SMTP id adf61e73a8af0-3c3990b4230mr1076478637.57.1784205789867;
        Thu, 16 Jul 2026 05:43:09 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.43.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:43:07 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 03/15] riscv/mm: implement Svnapot contpte read-side helpers
Date: Thu, 16 Jul 2026 20:41:38 +0800
Message-Id: <0c93b57b5315147c6ae6586371d795fb629dcc7a.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1DB6D20002
X-Stat-Signature: asongigx4afqgbuu196dxmpxcmifhp9y
X-HE-Tag: 1784205790-400854
X-HE-Meta: U2FsdGVkX1/nGs0uiGhnfcz5YsawikA30Is+yTjhfdlFaYa7vghXndLJOpwvK81qD+XxKRa+7qLdqSLK0Vw/6jrcmcddUDJxOVFtlLwaHAPMFbH5NDf/oPy67/4dHPgU1Ts1PJ/ga0ZvCsnEprh/XVQXhcXCI/el726SzFoPR0BI7R78U6dKT4HQ337TF22NfGuWgUu1dKO3/YkLgQG9cqs+25mB0dlSf1KrMonh7lMOvETM+NqS82+FanyKQCdEk9c8lL5/uTnV6QsMWvyJ+Nbhu7RrXudhxgm3QskqtBikznkFto3nA6zAZ5Wnvgt0CMhfifbtMwwU80RGiZ0Q0hl/mkjnyaKGAVNdyJe+nBZjFVv7/rvsmjAGHD8SSG4mIDuAGMxy1YzD++FvIbyBquyGzXwJIOFxbk/Ww9q+6une2E3vqhUhHV2eTx803zlJ5TrkyohhvnJZPIbtuSG/fVT7MIoZOJC+9W63r70/X3JgKNdp9Jd4o74wn6m44BcG+ZRNULhFHEOY6ISKRiyeqkZERJ80tpO/ulNowtHV3LM1DOcLzXIbqOyXytkMBlqm6ESpLnesdCwvScRJk2wtadzCDfgYGLxSztAOd+kPkALAVVrrWd9iIF7a9bAaOmUO91+io5EVVs7U18p875+X+spDbkyYNhNL+kw0zzSNFqZYwU1cRVs/2C66q2oO8XQBRWWrjvUtIN5MKSwr47/jCRcP2VUMsGOhCy9fe2hRa8gkp1NAIVJ2oPkKikMXWcwFUxVU6vhqfgW9Fpnm793wv1uxKuO59dZ3m9pjsq5Ot4MBU/GrScF3GVySIgpGTYtUPoX3LVhJt1jNzemEJwN4amu+OkXNcGEb6H6CbZ8vMJIt4Foax68q4VrInfDksQR2yXeJbr2Cykqb5TBhAmHQdrDdyL5gkWxuAMOyWDkj+kCgGBuxdZ+cLQ7Vz5DExWln99RTFSb/rHxs7tXRTK1
 Pwbxi0/v
 37/TRCHhT8B/f71HAegipJLbb1L4zaN9P2zkzR5Y5Tw4x48VIeYJCGHWhSgFATN2zrh9To9q4lht48lf5Vco5jThoUq79/9+y1ajCa5H7tBuqJcYHrQv5eUmDFuHdOP2o1t8fwpQhM8YX/U95fyda4rfxiqC2meBcn4rxp7i+1pmZXuxGFMwxgyNMPKUc37ICW9VyFEFf157gs9u/W0v6x3mLENVQZkj1O6elqW+dG46rGP8KlG7RQagf3UxU2j1fRxmg3YQZ2LoO5N2qkpa9i7ZCqk3SQJJaaN4qdslCTKI2WSQtMky/+J8dzAKV5MZPFt7l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Svnapot keeps a contiguous mapping encoded in a block of page-table
entries, while generic MM code expects the public PTE getters to return
a normal per-page view for the address being queried. Without a dedicated
read path, exposing the raw NAPOT encoding through the public helpers
would leak arch-private representation details into generic MM users and
make folded mappings harder to integrate with existing PTE walkers.

Add Svnapot-aware contpte read-side helpers and route the public PTE
getters through them, so generic MM sees the logical sub-PTE for the
current page while RISC-V raw helpers continue to operate on the encoded
entries.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h |  50 +++++-
 arch/riscv/mm/Makefile           |   1 +
 arch/riscv/mm/contpte.c          | 273 +++++++++++++++++++++++++++++++
 3 files changed, 322 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/mm/contpte.c

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index a0f64e980e981..fce6d04ea65db 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -312,6 +312,11 @@ static inline unsigned long pte_napot(pte_t pte)
 	return 0;
 }
 
+static inline pte_t pte_mknapot(pte_t pte, unsigned int order)
+{
+	return pte;
+}
+
 #endif /* CONFIG_RISCV_ISA_SVNAPOT */
 
 /* Yields the page frame number (PFN) of a page table entry */
@@ -350,6 +355,11 @@ static inline int pte_present(pte_t pte)
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
 }
 
+static inline bool pte_present_napot(pte_t pte)
+{
+	return pte_present(pte) && pte_napot(pte);
+}
+
 #define pte_accessible pte_accessible
 static inline unsigned long pte_accessible(struct mm_struct *mm, pte_t a)
 {
@@ -538,6 +548,13 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 #define pte_leaf_size(pte)	(pte_napot(pte) ?				\
 					napot_cont_size(napot_cont_order(pte)) :\
 					PAGE_SIZE)
+
+void __napotpte_try_fold(struct mm_struct *mm, unsigned long addr,
+			 pte_t *ptep, pte_t pte);
+void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep, pte_t pte);
+pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte);
+pte_t napotpte_ptep_get_lockless(pte_t *ptep);
 #endif
 
 #ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
@@ -689,6 +706,37 @@ static inline pte_t __ptep_get_lockless(pte_t *ptep)
 	return __ptep_get(ptep);
 }
 
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+
+#define ptep_get ptep_get
+static inline pte_t ptep_get(pte_t *ptep)
+{
+	pte_t pte = __ptep_get(ptep);
+
+	if (likely(!pte_present_napot(pte)))
+		return pte;
+
+	return napotpte_ptep_get(ptep, pte);
+}
+
+#define ptep_get_lockless ptep_get_lockless
+static inline pte_t ptep_get_lockless(pte_t *ptep)
+{
+	pte_t pte = __ptep_get_lockless(ptep);
+
+	if (likely(!pte_present_napot(pte)))
+		return pte;
+
+	return napotpte_ptep_get_lockless(ptep);
+}
+
+#else
+
+#define ptep_get __ptep_get
+#define ptep_get_lockless __ptep_get_lockless
+
+#endif
+
 static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 					   unsigned long addr, pte_t *ptep,
 					   pte_t pte, cydp_t flags)
@@ -822,8 +870,6 @@ static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #define __ptep_clear_flush_young __ptep_clear_flush_young
 
-#define ptep_get __ptep_get
-#define ptep_get_lockless __ptep_get_lockless
 #define set_pte __set_pte
 #define set_ptes __set_ptes
 
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index b916a68d324ad..fd260903cd340 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -19,6 +19,7 @@ obj-y += context.o
 obj-y += pmem.o
 
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+obj-$(CONFIG_RISCV_ISA_SVNAPOT) += contpte.o
 obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_KASAN)   += kasan_init.o
 
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
new file mode 100644
index 0000000000000..43ea76e424492
--- /dev/null
+++ b/arch/riscv/mm/contpte.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/align.h>
+#include <linux/cpufeature.h>
+#include <linux/efi.h>
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/page_table_check.h>
+#include <linux/pgtable.h>
+
+#include <asm/tlbflush.h>
+
+static inline bool napot_hw_supported(void)
+{
+	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVNAPOT);
+}
+
+static inline bool mm_is_user(struct mm_struct *mm)
+{
+	if (unlikely(mm_is_efi(mm)))
+		return false;
+
+	return mm != &init_mm;
+}
+
+static inline unsigned int napotpte_order(void)
+{
+	return NAPOT_CONT64KB_ORDER;
+}
+
+static inline unsigned long napotpte_size(void)
+{
+	return napot_cont_size(napotpte_order());
+}
+
+static inline unsigned int napotpte_pte_num(void)
+{
+	return napot_pte_num(napotpte_order());
+}
+
+static inline unsigned long napot_align_addr(unsigned long addr)
+{
+	return ALIGN_DOWN(addr, napotpte_size());
+}
+
+static inline pte_t *napot_align_ptep(pte_t *ptep)
+{
+	return PTR_ALIGN_DOWN(ptep, napotpte_pte_num() * sizeof(*ptep));
+}
+
+static inline pte_t pte_mask_ad(pte_t pte)
+{
+	return pte_mkold(pte_mkclean(pte));
+}
+
+void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep, pte_t pte);
+
+static inline unsigned long pte_protval_no_pfn_no_napot(pte_t pte)
+{
+	return (pte_val(pte) & ~_PAGE_PFN_MASK) & ~_PAGE_NAPOT;
+}
+
+static inline pte_t napotpte_subpte(pte_t *ptep, pte_t pte)
+{
+	unsigned long pfn;
+	pgprot_t prot;
+
+	if (!pte_present_napot(pte))
+		return pte;
+
+	pfn = pte_pfn(pte) + (ptep - napot_align_ptep(ptep));
+	prot = __pgprot(pte_protval_no_pfn_no_napot(pte));
+
+	return pfn_pte(pfn, prot);
+}
+
+static inline pte_t __napot_ptep_get_and_clear(struct mm_struct *mm,
+					       unsigned long addr, pte_t *ptep)
+{
+	pte_t pte;
+
+	pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
+	page_table_check_pte_clear(mm, addr, pte_mknonnapot(pte, addr));
+
+	return pte;
+}
+
+static void napotpte_convert(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep, pte_t target)
+{
+	unsigned long start_addr, end, ptent_addr;
+	pte_t *start_ptep;
+	pte_t ptent, pte;
+	unsigned int i, nr;
+
+	start_addr = napot_align_addr(addr);
+	start_ptep = napot_align_ptep(ptep);
+	nr = napotpte_pte_num();
+	end = start_addr + napotpte_size();
+
+	for (i = 0; i < nr; i++) {
+		ptent_addr = start_addr + i * PAGE_SIZE;
+		ptent = __napot_ptep_get_and_clear(mm, ptent_addr,
+						   start_ptep + i);
+		if (pte_dirty(ptent))
+			target = riscv_pte_mkhwdirty(target);
+		if (pte_young(ptent))
+			target = pte_mkyoung(target);
+	}
+
+	flush_tlb_mm_range(mm, start_addr, end, PAGE_SIZE);
+
+	page_table_check_ptes_set(mm, start_addr, start_ptep, target, nr);
+	if (pte_napot(target)) {
+		for (i = 0; i < nr; i++)
+			__set_pte_at(mm, start_ptep + i, target);
+		return;
+	}
+
+	for (i = 0; i < nr; i++) {
+		pte = pfn_pte(pte_pfn(target) + i,
+			      __pgprot(pte_protval_no_pfn_no_napot(target)));
+		if (pte_dirty(target))
+			pte = riscv_pte_mkhwdirty(pte);
+		if (pte_young(target))
+			pte = pte_mkyoung(pte);
+		__set_pte_at(mm, start_ptep + i, pte);
+	}
+}
+
+static inline bool napotpte_is_consistent(pte_t pte, pte_t orig_pte)
+{
+	return pte_present_napot(pte) &&
+	       pte_val(pte_mask_ad(pte)) == pte_val(pte_mask_ad(orig_pte));
+}
+
+void __napotpte_try_fold(struct mm_struct *mm, unsigned long addr,
+			 pte_t *ptep, pte_t pte)
+{
+	struct page *page;
+	struct folio *folio;
+	unsigned long folio_start, folio_end;
+	unsigned long cont_start, cont_end;
+	unsigned long pfn;
+	pgprot_t prot;
+	pte_t expected, cur;
+	pte_t *start;
+	unsigned int i, nr;
+
+	if (!napot_hw_supported() || !mm_is_user(mm))
+		return;
+
+	if (!pte_present(pte) || pte_napot(pte) || pte_special(pte))
+		return;
+
+	/*
+	 * Driver __GFP_COMP pages inserted by vm_insert_page() have valid
+	 * compound metadata. Fold them only after verifying the whole supported
+	 * Svnapot range is identical and contiguous.
+	 */
+	page = pte_page(pte);
+	folio = page_folio(page);
+	folio_start = addr - (page - &folio->page) * PAGE_SIZE;
+	folio_end = folio_start + folio_nr_pages(folio) * PAGE_SIZE;
+	cont_start = napot_align_addr(addr);
+	cont_end = cont_start + napotpte_size();
+	if (folio_start > cont_start || folio_end < cont_end)
+		return;
+
+	nr = napotpte_pte_num();
+	start = napot_align_ptep(ptep);
+
+	pfn = ALIGN_DOWN(pte_pfn(pte), nr);
+	prot = pte_pgprot(pte_mask_ad(pte));
+	expected = pfn_pte(pfn, prot);
+
+	/*
+	 * The caller must hold the PTL across validation and conversion.
+	 * Software PTE updates are serialized by the PTL; hardware A/D updates
+	 * may race and are re-read and folded into target by napotpte_convert().
+	 */
+	for (i = 0; i < nr; i++) {
+		cur = READ_ONCE(start[i]);
+		if (pte_val(pte_mask_ad(cur)) != pte_val(expected))
+			return;
+		pte_val(expected) += 1UL << _PAGE_PFN_SHIFT;
+	}
+
+	expected = pte_mknapot(pfn_pte(pfn, prot), napotpte_order());
+	napotpte_convert(mm, addr, ptep, expected);
+}
+EXPORT_SYMBOL(__napotpte_try_fold);
+
+void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep, pte_t pte)
+{
+	pte_t target;
+	pgprot_t prot;
+
+	if (!napot_hw_supported() || !mm_is_user(mm) ||
+	    !pte_present_napot(pte))
+		return;
+
+	prot = __pgprot(pte_protval_no_pfn_no_napot(pte));
+	target = pfn_pte(pte_pfn(pte), prot);
+
+	napotpte_convert(mm, addr, ptep, target);
+}
+EXPORT_SYMBOL(__napotpte_try_unfold);
+
+pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
+{
+	pte_t pte, cur;
+	pte_t *start;
+	unsigned int i, nr;
+
+	if (!napot_hw_supported() || !pte_present_napot(orig_pte))
+		return orig_pte;
+
+	pte = orig_pte;
+	start = napot_align_ptep(ptep);
+	nr = napotpte_pte_num();
+
+	for (i = 0; i < nr; i++) {
+		cur = READ_ONCE(start[i]);
+		if (!napotpte_is_consistent(cur, orig_pte))
+			return napotpte_subpte(ptep, orig_pte);
+		if (pte_dirty(cur))
+			pte = riscv_pte_mkhwdirty(pte);
+		if (pte_young(cur))
+			pte = pte_mkyoung(pte);
+	}
+
+	return napotpte_subpte(ptep, pte);
+}
+EXPORT_SYMBOL(napotpte_ptep_get);
+
+pte_t napotpte_ptep_get_lockless(pte_t *orig_ptep)
+{
+	pte_t orig_pte, pte;
+	pte_t *ptep;
+	unsigned int i, nr;
+
+	if (!napot_hw_supported())
+		return READ_ONCE(*orig_ptep);
+
+	nr = napotpte_pte_num();
+
+retry:
+	orig_pte = READ_ONCE(*orig_ptep);
+	if (!pte_present_napot(orig_pte))
+		return orig_pte;
+
+	ptep = napot_align_ptep(orig_ptep);
+
+	for (i = 0; i < nr; i++, ptep++) {
+		pte = READ_ONCE(*ptep);
+
+		if (!napotpte_is_consistent(pte, orig_pte))
+			goto retry;
+
+		if (pte_dirty(pte))
+			orig_pte = riscv_pte_mkhwdirty(orig_pte);
+
+		if (pte_young(pte))
+			orig_pte = pte_mkyoung(orig_pte);
+	}
+
+	return napotpte_subpte(orig_ptep, orig_pte);
+}
+EXPORT_SYMBOL(napotpte_ptep_get_lockless);
-- 
2.39.5



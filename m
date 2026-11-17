Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FDB606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=3mjTo5zh
Received: by kanga.kvack.org (Postfix)
	id 34B636B05B4; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322FD6B05B6; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238C96B05B7; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD49B6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BF511C34DE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:47 +0000 (UTC)
X-FDA: 85442962374.30.AF4EFEE
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id A2EB81C0007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3mjTo5zh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7i9FPBLxBo+nFBKLQHwPNwyitgFkr47EWET+hoYLFAE=;
	b=tri53VqDDsx1HEMt19nb2XJbCxMC+hnUOS3yENWJgyt7ue0wCZrou85AsyB2AWS7xfo0id
	+6EIq8of3Ce/GnxljxshSL7SBX/arguNYRov0SVacILtwkvNwzFVnsI55BjQfhBM7kxr+v
	obRgqkCk8XF3HCEAbEGNNdVmMb8EDUo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3mjTo5zh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880965;
	b=mJFFOHxrxvnqvWm+d8UqkRLaWXhSMg3gLkA8eD4bl9Bat17eGKyvu4/poQDIldGCu6LkRm
	9NDqDJ5uX5jagggrnz+Rl+QZsgJCaiIHfTQYJhnESuP28y2ElFpbx2D7CY67IfAeYpIFRh
	L4rmpSGeyS6kYxVrwLjNLV53tLB8Uzo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7i9FPBLxBo+nFBKLQHwPNwyitgFkr47EWET+hoYLFAE=;
	b=3mjTo5zhLcyKWtbueN+7irQ/JAJgxWhADx/d8zMIZITdwBU4LKuRLehqbBxIJrN9EVaEDw/ZI
	85RF0EpL2a94NP5QNVCoFCF6cuiQ/frjYZdYScnYLsTgLiXY7M03ZKfEvLlAjKXBCJQwTzqX06m
	bcEwx3P+WMOGznfqzUkS/7U=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jT7JX5dDPzcbPt;
	Tue, 17 Nov 2026 10:01:48 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id EB0A94056E;
	Tue, 17 Nov 2026 10:02:38 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 17 Nov
 2026 10:02:38 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 1/4] mm: define generic pudp_invalidate() implementation
Date: Tue, 17 Nov 2026 10:02:34 +0800
Message-ID: <20261117020237.4037980-2-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117020237.4037980-1-tujinjiang@huawei.com>
References: <20261117020237.4037980-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: A2EB81C0007
X-Rspam-User: 
X-Stat-Signature: phigu6j5bj9t4oat8ktt3y8f1jodgh3o
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794880963-408188
X-HE-Meta: U2FsdGVkX18pelKKPlrGjTyY9/08/MUveES36XTVXn8rIiZNuMpk8RhNEHN7h4LbZaqlGNKG4XGkqy5yr6wHJK6CAkCkFT/D0VAwzK+GQ48P8+UkWwGr8pAU2GYG3I6PPrRIozg3ywCWKcGr0lCPVFbJ6mAvoMi8tdYs6CNzRnQvAOtkAUGxY+SCJERnLEM1jwZZtj4c+JqFohsPdDKUEMUkkYrgq8RTU0yFvlV2Oq+BefIBDRdvt4MHxPrrYPLIjtCe/ypeJyWPU7kNtJ/wjmbpy9/i8/4xxlD8YMFupP+LCt9NnLbUkc5FYvvQUiGdyOqFxU+5+Yzh4Jm1nLQCWUtgnnHs2AbDNupMr8OX0/8NVe25fmygilNd4tZ+38YfEWE6H/YlfxJZiuROEi7UJK5DzMLeOoJB9d3fcc7p5Bjv6NcBsh0VA99BcdvRYBFCbKGs3VFAOVROCeyqN1QQJUUctfGdiNBMRhKPPm6c6anqCm7Vrvu+dJoYoq9ApwlSi38y013BSIbbOgYAWF8y8/iFzhuYSKLr2t2pnBMut10J1CmmxfPZ1+mDVA6e7sIrayvRD3WHWKvvcvw3ekIWWX4Nu9O0otNeUJuABthwn7IJb8IG6jtIp4BeB6fR3EBjoIGKKRuGufscqRkXMp/osymaTPmalivB9JZ1t0OBUBYVtXzFHBQIhFGlaS+dzKh3yJtiWfb8bkeYcjVO2lSv2eQa+kVAZXU0wEIgwc7EDpj4j6jLYjcw4BMD97N149LJbQcxvSAKkla0RyXFJesJ8tJVLCPJo3XPZA7W1I2z0gGL/2xIascgtVdKGe3+iTKCGd/+G/yCr1WYiyo/HN3j+CG7fC7ghjoYJiAVCdKLOnE3FyYWF6pakCDQVh5upEUf/nRTvcjWWjBS1UYuggfmGuRe6RIZOCdspp2SDmwd5UhYaOpWBd0X5ZTTdu4Uyo3Rjm14NJbB2gW8mQSIavS
 kQRFG/Xf
 1XlvIGST2GIHcnnnXVcLLChuh/LavBBscAfpooO2iLEpJd6jlYgryMWDZ7qUa8vqYXfQSX03FyVs8KCvd9pdrSaYUKZ+GoxvzCjzAvAEKieRUCF6oqewjJiZ8uNy9KOOdfIagXI5z7BYtCRi0/CjEBcQOov6mRIPbAfSDWfULzN9UOkEplxMV8GONkt4ISiZ01jzKWknksQMI110rjnUNZb5pKg8STcDTXDNmINEuaPzP+cU0ZuMRmIku2KlIA00CO1QmP/XS/1AwSDDOM01DbTaK8vH+SB3u+22rikNQ1tChmanGoD8nvx2ozXQHp4CvYNzwxPKdUXZhvDXopW11Glyz/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

x86 and riscv have identical pudp_invalidate() implementations. Move it to
mm/pgtable-generic.c with the __HAVE_ARCH_PUDP_INVALIDATE override guard.
PowerPC keeps its own implementation. In the later patch, arm64 will use
the generic implementation too.

No functional change intended.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h |  1 +
 arch/riscv/include/asm/pgtable.h             |  3 ---
 arch/riscv/mm/pgtable.c                      |  9 ---------
 arch/x86/include/asm/pgtable.h               |  3 ---
 arch/x86/mm/pgtable.c                        | 12 ------------
 include/linux/pgtable.h                      |  7 +++++++
 mm/pgtable-generic.c                         | 14 ++++++++++++++
 7 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index dff8790a047d..267d5e24f3b0 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1412,6 +1412,7 @@ static inline pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm,
 #define __HAVE_ARCH_PMDP_INVALIDATE
 extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			     pmd_t *pmdp);
+#define __HAVE_ARCH_PUDP_INVALIDATE
 extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			     pud_t *pudp);
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2ebd5fa5adc5..174a2f2bcaa2 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1162,9 +1162,6 @@ static inline pud_t pud_mkinvalid(pud_t pud)
 	return __pud(pud_val(pud) & ~(_PAGE_PRESENT | _PAGE_PROT_NONE));
 }
 
-extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
-			     pud_t *pudp);
-
 static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
 {
 	return pte_pud(pte_modify(pud_pte(pud), newprot));
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index cd180f9abb5e..7c76756b59da 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -154,15 +154,6 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 	return pmd;
 }
 
-pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
-		      pud_t *pudp)
-{
-	VM_WARN_ON_ONCE(!pud_present(*pudp));
-	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
-
-	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
-	return old;
-}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma)
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 000fc6c1ca37..ad7a40abef7d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1391,9 +1391,6 @@ static inline pud_t pudp_establish(struct vm_area_struct *vma,
 extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp);
 
-pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
-		      pud_t *pudp);
-
 /*
  * Page table pages are page-aligned.  The lower half of the top
  * level is used for userspace and the top half for the kernel.
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 4a105f283cfb..591931d144f2 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -519,18 +519,6 @@ pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
 }
 #endif
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
-	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
-		     pud_t *pudp)
-{
-	VM_WARN_ON_ONCE(!pud_present(*pudp));
-	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
-	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
-	return old;
-}
-#endif
-
 /**
  * reserve_top_address - Reserve a hole in the top of the kernel address space
  * @reserve: Size of hole to reserve
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..0021eaf88e1d 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1318,6 +1318,13 @@ extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp);
 #endif
 
+#ifndef __HAVE_ARCH_PUDP_INVALIDATE
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+			     pud_t *pudp);
+#endif
+#endif
+
 #ifndef __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t pte_a, pte_t pte_b)
 {
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 6e83ce3801b8..1b7081fc4a75 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -229,6 +229,20 @@ pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
 }
 #endif
 
+#ifndef __HAVE_ARCH_PUDP_INVALIDATE
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+		      pud_t *pudp)
+{
+	VM_WARN_ON_ONCE(!pud_present(*pudp));
+	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
+
+	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
+	return old;
+}
+#endif
+#endif
+
 #ifndef pmdp_collapse_flush
 pmd_t pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
 			  pmd_t *pmdp)
-- 
2.54.0



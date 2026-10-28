Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC876606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JO+nsC+Z
Received: by kanga.kvack.org (Postfix)
	id A8E4D6B05B2; Wed, 28 Oct 2026 08:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61F06B05B5; Wed, 28 Oct 2026 08:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4E76B05B3; Wed, 28 Oct 2026 08:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6175F6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:14:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E637340C70
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:20 +0000 (UTC)
X-FDA: 85371927480.07.21A0F79
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf22.hostedemail.com (Postfix) with ESMTP id 23FC8C0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JO+nsC+Z;
	spf=pass (imf22.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793189659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdMrwv24vZrkS4zL94ChspDJhcnzFGi1U4E5UatyTIs=;
	b=SDe2mYUedivZAdy36CTbSf/hmHgKfmKm/4PB7oAPIL9vH7FwZejx9uSHtb3N5Z1rSafS/d
	+n47UvahMLEQQheZvhQJq9zqzEGYWU8/ux4zN/deLj91QfrMBQZVVtwWz0FuVNCVnQ2vlK
	HTqB4uCMO/KoRNhnAg4HKm8thQ+stzI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JO+nsC+Z;
	spf=pass (imf22.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793189659;
	b=l8aDA6RzdrV7fRrdXrxKPLMhSBpgmTZ7gNNKAoK75kKTLjIEtZgeZcpCm4lPqivQAsRh0L
	N2kXj2vpU7cfsk+1NpfiX88Ucc65bADbiqWLwcIYnTu0Rkj5FDfgD8L2xAUmIl9w4rPfd0
	VV3aGLy4uS5+FM57Epl4tQuqjE/0jXM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VdMrwv24vZrkS4zL94ChspDJhcnzFGi1U4E5UatyTIs=;
	b=JO+nsC+ZMBA28VZrHp/hi9sh4lca0ayq3DBPRGclRIV+eh8ZmscmfmLrb0OlVEsK7N9c0NiM0
	0k5t6UyeF9UD2GJQljxe2u1wImJ0h9eJweGHfNrrp52wSeI12liAEhDYwESsyq180II0McmSix1
	cZtr5tzBZAvjPGG5DeksGH4=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jF5r515WgzKm6K;
	Wed, 28 Oct 2026 20:13:57 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 45B124058D;
	Wed, 28 Oct 2026 20:14:06 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 28 Oct
 2026 20:14:05 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH RESEND 1/3] mm: define generic pudp_invalidate() implementation
Date: Wed, 28 Oct 2026 20:14:02 +0800
Message-ID: <20261028121404.853944-2-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028121404.853944-1-tujinjiang@huawei.com>
References: <20261028121404.853944-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23FC8C0009
X-Stat-Signature: 8t9ttcomcmiqjso95t8mmpczzokxcjzn
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793189658-550974
X-HE-Meta: U2FsdGVkX19X2mXOsP8PEI7WVzzQXqf71e9Ok1uJ9JldPyD+2dox96ky/qi9j9wbAWWSQwYWyA4po7gtSpzGJzsRbsruMz2gJwAVG+t484xJgq9DyrTn55AKygfT7Ph8991sGD4uYpLujiFyJvaPCbLa2kJ1JxIV89JHjlG4SjnWTG3eR2DGKntvhKfzo7/B9mg3mLrqLQHgX6QRAgxK4Ia8v84HVMtMcwui5wSQN1d0BHwURbj4pus5CYA4OhKXTadBeVxO57+qHp+0LLIncw+gQQGJGby9RtdfeQrCiDjLPRNzvI71eHXTQD9NmqIK8/LEKtWh0XOSddfz0tqXv0LPa382UVbse7syp6QqG69yUiuUktUc0ckRxF1TAjTxpV4WorCsuYHqzO5BkcQ6rd3aMVH8Mr2VM47SAum9jSEk6BjKxPIKEdTMHBScAI9ZBa9gjDj9zx+0tvUcHHsSwp7FTTw6f7/oRVoZ/ntaWrZw2LTaAO5U11LQ1Df2fl0sPn26u+gyHF4Is5wHIvnYx7h1smlYvj8mkK84wRmfGnbJrfZHW4+R3xHs3lTQYmZWCrtBWubefNqjMKevLciD/dGa4vbskzCFNdMCAOCu5WBT65wvCSd+Eo+OgN8sCHzCPw0rZ00Gny5JNZLugRh9ljJBvTw80CUY5lQtAZNG2GLeM4QkLRvJRe4oyzfcxwF8lqRQfVuM7JB/SKgoChSZSm3AnIqmuusGFOgZvLej2q/V2nfoWf1P/l24d+jBYbJcJiNYBV5iH+Wy+qgKUEoA2/H3yD0DCxkbFeh6Z5CKGtR0T6QTvFCtx9zjE/EpW5fnDFPVSWZ1byxBTgXRdEQXds7wqH0c96rH4cp3ucr5qOcs6K34IX8W48vtHjjfL56erXdoZ5lHv02rgs+K5OpksFH/Sf5lHn5tIQ1x768YYrV10NaXsW+5hLjCJO4KH2riJ05AUn4OiXkk+/ptYMZ
 JMhvERSs
 LB4EuPi0DweGWp6lLJfewQCTO36ouKI1GGoiuUJBWsoGhliNc8SfUnrQjhNCVS3ZRUuvj+oA+/njvRAcxj3j3hEGvAXDU7WC3lPmKfmR+/FLk35T8PW5Q5Dxhi+6bnIQyjqIgtD3BpdhbKc5blMZnFkx1b3A574l1na/j1Q4hbXuwEWM9ldW7Kgzprwj35wBKPH9f6YlhiJJLJlh0Tnyi8syKATGWebsSKslsrFOaxYSeEjcNuCi2yAVRXvTLI7e/86y1toW2DJ8IfHozDHUO/3tIyGu/AWFSNABO4SFTg3k2Qiyql0EwZkVqauJiomtfa6kWCcKj0CH0doOpM3XKJ5EfVw==
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
index d48f90140841..0126d6ca5643 100644
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
index 9c4427d0b187..156e385e7db4 100644
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
2.43.0



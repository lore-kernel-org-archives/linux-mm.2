Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF9D606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=KUSvzg32
Received: by kanga.kvack.org (Postfix)
	id E959D6B05B5; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E465B6B05B7; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C136B05B6; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 968F26B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:02:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D188C1A02BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:46 +0000 (UTC)
X-FDA: 85442962332.09.FDBB59C
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A4EF4000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KUSvzg32;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnfOAroky9GpyEAMhifmXEL8ZhCK57vnkqCNRMR6/lg=;
	b=AmGXnKb7MjlgdFiI9vi/3o9EyHaoI5ElaLCFjtccAaJydTQknn6w8i9xeT6WYdx2/S4D5O
	nPA8MADjpWr8PelxhXq4SAsrR+QHSpCDk8zeRoLhmD3nQx/T1EWU+9XPy4t5maGCpLlgJL
	ajGs6Em6IytD7iqWsQiTBo0tDzpmGY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880965;
	b=mc3DUr6lfC0XQ5JuM/baU4Cils+VvxOA28f2Lf9uf6aCA266n2hoqCaHXbSh9W0xgVuth/
	oHeZwFYNClsFlTBzfxGDChHKWOlkhIZcMudoDHh7UZnPJ15GYSN1qOk0v+ME+K9LBrMdMW
	Xb/hYGrwkESDscBpwJJ7f4O0AfHWvLc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KUSvzg32;
	spf=pass (imf27.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pnfOAroky9GpyEAMhifmXEL8ZhCK57vnkqCNRMR6/lg=;
	b=KUSvzg32rZxk7WYKK8YqB9uRFqp2f2YDG7qDmN/QwyzkOO/Xl9DeiPkurI7glZS39BtF+uNZa
	wN143P23uWEO7ICEfpaqeK3Oy5RqwryeLjXSatgMYlvrD2R890D+OjNkRo9nZMJ69sv5erpJB+I
	+LAAfwaodaV3SIP670ojXwg=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jT7Jc3XYvzpTJS;
	Tue, 17 Nov 2026 10:01:52 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 1375240577;
	Tue, 17 Nov 2026 10:02:40 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 17 Nov
 2026 10:02:39 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 3/4] mm: add spurious fault fixing support for huge pud
Date: Tue, 17 Nov 2026 10:02:36 +0800
Message-ID: <20261117020237.4037980-4-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117020237.4037980-1-tujinjiang@huawei.com>
References: <20261117020237.4037980-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A4EF4000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zyoh963bg3dftrfmpd3q6nu4beawnwr6
X-HE-Tag: 1794880963-186559
X-HE-Meta: U2FsdGVkX1+Rnnd9ZqMD1urke6FY62g/n2ZcCn2+xEhLalai/TRQj0mBxh5MfjBO5YT5t92/ExusPNgPDMZp4Ui8PXrETHVsXrnN77cXcXhY4XNRk6hykJ0GhhBBdNshXpHZScAoDeTxPuNSJbfxu1KJ275k1OE2u1Wa1EPjeApVszgoa/j/GgkiwyIYbxNssJaAVztrFD5fwLuTD2OKDPizveg1Bczx8aWXxgU45syrCg/B5q95GvB5z2tkeku+a3Xj/Fm91ITRqjpO9qdL4WPpSco5wiuYoWHa8RY1Z6P4tOd16KMJZl4U8HeX006qvqunk0Pga6MURDtS2ldQm8pWD09ru2udkVKlkYEkJH9VTHQSbJUW6qf/tc0U0ihy9PfbGyWX55HcAwGYBrKGylFuycrvWiRGWYXDq3GlbVUNoOpSRUFlJQIVvleINew7LzWlKxExNPrCLMyavwqAm6FHo144NmfJv8whu2zmKrBaJ+eaSg75Du/egWERnxrYbjr/tDP7vd6pLTtgDJvjVuWlu0gE9E9IBlFmLCxY8/pD2xdMY7S0SBiK+MvGqNbUTB6Rh1ElwPTkRW+1FAg9LsR/qG56/KyVe6S7pv4BtufjSn0Ozt8PjEwNNl26I0vTps0CQP5i0V5IQVNbhLfoN976ak6Y3E4zYIcIXvYV9DLuEHy5FRUltdywwH17LRRcoqwNZqWRNXHeFONS/Ip+oK3gm2Cuz9+BaZ3fiABVzRmd/htGujVNdNeCuq0AsyTt/AdF5AqXD2a4gw6TFQvE4SDpk+CtPMl1l5ZPRz48wX24iOYxsifeXT1mNt24476CGK3EkkoFjwlSiHErFVr8TT99LhMDX44PaZAoe0MdyWsy0eA4EKD1+R/rZgfx5BcJs27nGYdweXXVIZKch0WreCZgyfl1hZkm0x3KxDJ6QcgP1HOK1mAaNw0CLi91lUb7ZLYxK+Mu4ExIwpgv71u
 MqHt7WRe
 uvMzEHAjoQb8gU6mMB7bSnD/7Wa/6JUDv0d0FUpNfH++xEjnp35CAPJXAbziz2WtHhuuZ3LLkONolwgXdzeKdJtr9y2m3HfhxT1JaWbnCJPTOQ2G/Cplb+dKXiGTJzl08zM+0kMfSDfx5wVTF8HGtoax9cYxUD69yuFLdW8AvM6Wpvx+UIwrhU9ArOX+ie1O19u+H4MZIKT4IVGn3eWibU7ZhzH06aggZQZuiAhd43tJFThclrqoEL5oqhbArEXo7cOhbn0KA90UfehpifUrpGArUJLZJxhDMiGDlfFgkVA8/yp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Spurious fault fixing is supported for PTE and huge PMD mappings, but not
for huge PUD mappings.

The next patch in the series adds PUD THP support for DAX and pfnmap on
arm64. arm64 write protection faults only flush the local TLB and leave
stale read-only entries to be flushed by the faulting CPU, so these
mappings need the huge PUD variant of the same fix.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 arch/arm64/include/asm/pgtable.h |  4 ++++
 include/linux/huge_mm.h          |  5 +++--
 include/linux/pgtable.h          |  4 ++++
 mm/huge_memory.c                 | 17 +++++++++--------
 mm/internal.h                    |  2 +-
 mm/memory.c                      | 14 ++++++++++----
 6 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a06b0f5c3411..3c1c000cc5dd 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -107,6 +107,10 @@ static inline void arch_leave_lazy_mmu_mode(void)
 	__flush_tlb_range(vma, address, address + PMD_SIZE, PMD_SIZE, 2,	\
 			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
 
+#define flush_tlb_fix_spurious_fault_pud(vma, address, pudp)			\
+	__flush_tlb_range(vma, address, address + PUD_SIZE, PUD_SIZE, 1,	\
+			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
+
 #ifdef CONFIG_ARM64_PA_BITS_52
 static inline phys_addr_t __pte_to_phys(pte_t pte)
 {
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index fac05120ab77..1d8ab7c864f2 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -16,10 +16,11 @@ int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 		pud_t *dst_pud, pud_t *src_pud, unsigned long addr);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
+bool huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
 #else
-static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
+static inline bool huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 {
+	return true;
 }
 #endif
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 0021eaf88e1d..795bbc313bcb 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1493,6 +1493,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 #define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp) do { } while (0)
 #endif
 
+#ifndef flush_tlb_fix_spurious_fault_pud
+#define flush_tlb_fix_spurious_fault_pud(vma, address, pudp) do { } while (0)
+#endif
+
 /*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eb913acb03b7..09bf622b14ea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2059,7 +2059,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-void touch_pud(struct vm_area_struct *vma, unsigned long addr,
+bool touch_pud(struct vm_area_struct *vma, unsigned long addr,
 	       pud_t *pud, bool write)
 {
 	pud_t _pud;
@@ -2068,8 +2068,12 @@ void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 	if (write)
 		_pud = pud_mkdirty(_pud);
 	if (pudp_set_access_flags(vma, addr & HPAGE_PUD_MASK,
-				  pud, _pud, write))
+				  pud, _pud, write)) {
 		update_mmu_cache_pud(vma, addr, pud);
+		return true;
+	}
+
+	return false;
 }
 
 int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
@@ -2118,17 +2122,14 @@ int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	return ret;
 }
 
-void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
+bool huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 {
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 
-	vmf->ptl = pud_lock(vmf->vma->vm_mm, vmf->pud);
 	if (unlikely(!pud_same(*vmf->pud, orig_pud)))
-		goto unlock;
+		return false;
 
-	touch_pud(vmf->vma, vmf->address, vmf->pud, write);
-unlock:
-	spin_unlock(vmf->ptl);
+	return touch_pud(vmf->vma, vmf->address, vmf->pud, write);
 }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
diff --git a/mm/internal.h b/mm/internal.h
index e3f92883bf23..0a0a71fa110d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1311,7 +1311,7 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
 /*
  * mm/huge_memory.c
  */
-void touch_pud(struct vm_area_struct *vma, unsigned long addr,
+bool touch_pud(struct vm_area_struct *vma, unsigned long addr,
 	       pud_t *pud, bool write);
 bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	       pmd_t *pmd, bool write);
diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee..94a6d106e801 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6578,8 +6578,8 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
  *
  * Note: flush_tlb_fix_spurious_fault() is defined as flush_tlb_page()
  * by default and used as such on most architectures, while
- * flush_tlb_fix_spurious_fault_pmd() is defined as NOP by default and
- * used as such on most architectures.
+ * flush_tlb_fix_spurious_fault_pmd() and flush_tlb_fix_spurious_fault_pud()
+ * are defined as NOP by default and used as such on most architectures.
  */
 static void fix_spurious_fault(struct vm_fault *vmf,
 			       enum pgtable_level ptlevel)
@@ -6597,9 +6597,12 @@ static void fix_spurious_fault(struct vm_fault *vmf,
 		if (ptlevel == PGTABLE_LEVEL_PTE)
 			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
 						     vmf->pte);
-		else
+		else if (ptlevel == PGTABLE_LEVEL_PMD)
 			flush_tlb_fix_spurious_fault_pmd(vmf->vma, vmf->address,
 							 vmf->pmd);
+		else
+			flush_tlb_fix_spurious_fault_pud(vmf->vma, vmf->address,
+							 vmf->pud);
 	}
 }
 /*
@@ -6757,7 +6760,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
 			} else {
-				huge_pud_set_accessed(&vmf, orig_pud);
+				vmf.ptl = pud_lock(vmf.vma->vm_mm, vmf.pud);
+				if (!huge_pud_set_accessed(&vmf, orig_pud))
+					fix_spurious_fault(&vmf, PGTABLE_LEVEL_PUD);
+				spin_unlock(vmf.ptl);
 				return 0;
 			}
 		}
-- 
2.54.0



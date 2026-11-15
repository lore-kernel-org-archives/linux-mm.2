Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE215606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DMEVOckw
Received: by kanga.kvack.org (Postfix)
	id D96AB6B05C5; Sun, 15 Nov 2026 09:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E316B05C6; Sun, 15 Nov 2026 09:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84A36B05C7; Sun, 15 Nov 2026 09:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 978406B05C5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:40:37 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22BF54077C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:37 +0000 (UTC)
X-FDA: 85437614514.20.3945766
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CAB940006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:40:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DMEVOckw;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FI3asJNj7qOQlV/TGWUmB60338C7WC/uFNSW9D9/jCI=;
	b=VGUHAEjRWbJ0/Z0oFZ+w6vuiCgYziobgTd8rSTxAJZ87BtKi/yjC8bQB/NDR1PTTbKkuTg
	9qodtnM/fD/v8wmaO67ysokyRQT4NbFfAP866pNPfkByHE1/E6y7H+oSx2SegsOEKdCtmy
	EU9p5ExmgPn7LPNGnC7XBNrwbdzZpkU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753635;
	b=w+ciwBKZZX+LQIIsXLWYJIqxaxc7pTmmBSYcxNev3y4msQyxnSPFuftlddLmyECk1R+XCO
	OHth3fdP9fpK824E5QmVD+MMUZ//RswLnmskfslf2gjeCHjMqIedYdY3VSraM2lRvJ+JbX
	vBGSY66ahJMi3PcsbxLhdmWdOkTTFqM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DMEVOckw;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0AE41575;
	Sun, 15 Nov 2026 06:40:31 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DDDDA3F85F;
	Sun, 15 Nov 2026 06:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753634; bh=IOwZLzBTzh9eQvjrTuwoQ1OhI4taf+RWz3s7nNKkGsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMEVOckw1bncfikR/EnGed2E3Z2HQv6tBEHDD6DNwp5YW2PUslaR2AIXb5/Gq6tCp
	 8+NsqxFXbKEp9lKCyxiV/D3wB/+ZsWC4gyT8qCCKDGygsZ0gggx8gEsNMAXNSaBPix
	 efHhX4QG2x37fNTYQWwMb+8DBFYlDIhWS1gCWEg4=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 9/9] mm, sparc: batch arch_unmap_one()
Date: Sun, 15 Nov 2026 14:39:04 +0000
Message-ID: <20261115143905.3045084-10-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CAB940006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b17jf5ty69mn4efzbjf9ppoa9hyzpkax
X-Rspam-User: 
X-HE-Tag: 1794753635-418969
X-HE-Meta: U2FsdGVkX1/X1aV/9gzR+DZqhfQ5Akra+H3hplH9iqgFg9Bw/tBtwfhU32GkFhjsVUa7bkqP08lWdjirWdXILnA8oz1IFerbxwzrSjCR8bbcK4AzGkvHT2UN7oDV9vK0rgX7f7aDk60SpCA/H270Y0pwkdoQezUq4f8by4ukX4CH8qLNPzb3gEG0fPo3e1qcSnvZTMHRsxsYkPGndACB9X4DACwJLnQUgTiogL3URsA0FvbKvEhzYhwXq3Nge4AFaqXGU5vM8JMN8Hssl+H4+x9VtsrdgLjDYDrmCFIvWwEz2vnchvIjCyDON7J416Z4j29w0d+VQsqyOn8Hj6v/bHJ6N1iFMjLlV6fII9wH8egB53jCMjCi3jPknxw9vbch/u9n+N49+mDknUCLp7FioqQoJJSTIAnKLIAZW8ZLDfKql5wEielJD62r0FhWWGO1BBHE4Hx7LSKJvnz++9h5pu5TfDOs2z19zKHDigqbXdRTL1/wphf+gBeK/XrlgOa9qeNtGIvzWxR9cL0UpK+Rfd3s2P9MDVWf1C/18B/eEFPY4aJ7W/TDjnzoGvtT0TFNmz/plLXEx+qJQuWSHYnJpsUdt37Oj9Ax0Z+1W5OjwT/azkK16arSR2X/4H7tg15mPSnVlfqR2flnLxReyUc8nRdGkQRJkuTV8XLJ9C/hJ62wWKuB5kzsSSjV/7Jo92llWCx3Tty4BQPMrSnVlnc+rZl+bGTRVtgYLM6fc/X4hI5iruEt1fbNCP2Yh88lceq8lyDfP7BaGDQW3grTzU/eXPyAYHPc7BMCMv/yuXYwQDmKZ8HDhLvmI9sJcXYP5oQrXBLzZklBi8zvwdg1q6xqK+L365oVdPGG8nvY9Oefb6a+pwyH14wddzyNdI6fRqEOq16dFYrkRJtRjoLAiNTHdOwv3v9RtAwm1bbmFpQCoR2F+yqTQzJO9Yf8NKjYQGo8PcG7h6wfKjQAG/gYsbR
 TCzghcSE
 YiVvZCGAIfg2LLaJJfc+Z8Gta1vndhvCm9FN9LWsB7/+oNDsP26lKia1prMlflp5vxlJQ9psOCXyYBfvHMXUwx5a0hJwVUrE58EWmbTUmFZq4cWXOyDoZMA1Sp1zO7asvLGzhFgCMab5mqIJVmSvwJkQi9a8QZ+OBXUP5jP09VYtJTHqmDEdFZlV04wwc/l7hcH3Yey8IbJ8b019G8xWW6wkHmg14CIedSu9jc7J7n2xIM6cQwy7e3P7wYZ1bgMy5f2OgR8oGpBAh/37Hl1E5Ly2Ql2yLuD936aq69VG4qyFyRrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The anonymous large-folio unmap batching path can clear and replace
multiple PTEs at once, but architectures like sparc need arch_unmap_one()
to preserve per-page metadata before swap entries are installed.
sparc uses this hook to save ADI tags.

Extend arch_unmap_one() to operate on a pte range.

sparc uses the count to walk the PTE range and save ADI tags for entries
carrying _PAGE_MCD_4V. There is no reverse operation for a partially
saved range: saving ADI tags only records a copy for later restore, so
if a later entry fails and the core keeps the original PTEs, there is
no architectural state to unsave.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 arch/sparc/include/asm/pgtable_64.h | 10 +++++++---
 arch/sparc/kernel/adi_64.c          | 21 +++++++++++++++++++++
 include/linux/pgtable.h             |  6 +++---
 mm/rmap.c                           | 11 +++--------
 4 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 44d1333065a6a..f7dd1872884e4 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -1037,6 +1037,9 @@ void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 int adi_save_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 		  unsigned long addr, pte_t oldpte);
 
+int adi_save_tags_range(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long addr, pte_t oldpte, unsigned long nr);
+
 #define __HAVE_ARCH_DO_SWAP_PAGE
 static inline void arch_do_swap_page(struct mm_struct *mm,
 				     struct vm_area_struct *vma,
@@ -1057,10 +1060,11 @@ static inline void arch_do_swap_page(struct mm_struct *mm,
 #define __HAVE_ARCH_UNMAP_ONE
 static inline int arch_unmap_one(struct mm_struct *mm,
 				 struct vm_area_struct *vma,
-				 unsigned long addr, pte_t oldpte)
+				 unsigned long addr, pte_t oldpte,
+				 unsigned long nr)
 {
-	if (adi_state.enabled && (pte_val(oldpte) & _PAGE_MCD_4V))
-		return adi_save_tags(mm, vma, addr, oldpte);
+	if (adi_state.enabled)
+		return adi_save_tags_range(mm, vma, addr, oldpte, nr);
 	return 0;
 }
 
diff --git a/arch/sparc/kernel/adi_64.c b/arch/sparc/kernel/adi_64.c
index 18036a43cf568..ffa378accefe3 100644
--- a/arch/sparc/kernel/adi_64.c
+++ b/arch/sparc/kernel/adi_64.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 #include <asm/mdesc.h>
 #include <asm/adi_64.h>
 #include <asm/mmu_64.h>
@@ -394,3 +395,23 @@ int adi_save_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	return 0;
 }
+
+int adi_save_tags_range(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long addr, pte_t oldpte, unsigned long nr)
+{
+	unsigned long i;
+
+	for (i = 0; i < nr; i++, addr += PAGE_SIZE,
+	     oldpte = pte_next_pfn(oldpte)) {
+		int ret;
+
+		if (!(pte_val(oldpte) & _PAGE_MCD_4V))
+			continue;
+
+		ret = adi_save_tags(mm, vma, addr, oldpte);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 7e62479db5df7..71fa47b60e50c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1431,12 +1431,12 @@ static inline void arch_do_swap_page_nr(struct mm_struct *mm,
  * restored when the page is swapped back in. SPARC M7 and newer
  * processors support an ADI (Application Data Integrity) tag for the
  * page as metadata for the page. arch_unmap_one() can save this
- * metadata on a swap-out of a page.
+ * metadata on swap-out of one or more pages.
  */
 static inline int arch_unmap_one(struct mm_struct *mm,
 				  struct vm_area_struct *vma,
-				  unsigned long addr,
-				  pte_t orig_pte)
+				  unsigned long addr, pte_t orig_pte,
+				  unsigned long nr)
 {
 	return 0;
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index a2481323b778a..89dd71f84ff74 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1974,6 +1974,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 
 	if (flags & TTU_HWPOISON)
 		return 1;
+
 	if (!folio_test_large(folio))
 		return 1;
 
@@ -1984,11 +1985,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-#ifdef __HAVE_ARCH_UNMAP_ONE
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
-		return 1;
-#endif
-
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2183,8 +2179,7 @@ static bool __ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	 * architectures where we could have PFN swap PTEs,
 	 * so we'll not check/care.
 	 */
-	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-		VM_WARN_ON(nr_pages != 1);
+	if (arch_unmap_one(mm, vma, address, pteval, nr_pages) < 0) {
 		folio_put_swap_pages(folio, page, nr_pages);
 		return false;
 	}
@@ -2753,7 +2748,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * architectures where we could have PFN swap PTEs,
 			 * so we'll not check/care.
 			 */
-			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+			if (arch_unmap_one(mm, vma, address, pteval, 1) < 0) {
 				if (folio_test_hugetlb(folio))
 					set_huge_pte_at(mm, address, pvmw.pte,
 							pteval, hsz);
-- 
2.43.0



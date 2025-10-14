Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 583C2CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFB28E0113; Tue, 14 Oct 2025 09:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68BE8E000D; Tue, 14 Oct 2025 09:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9581F8E0112; Tue, 14 Oct 2025 09:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8086A8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:07:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C6461608FF
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:52 +0000 (UTC)
X-FDA: 83996747184.17.BAB3A1E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0F0C82000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cR/djIVU";
	spf=pass (imf03.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4OZ/FMtNXDdZa/+FmlYwe3N/LH3oTbKpyLgCA01R+Ck=;
	b=xA8LTBfuOIltZDf9VGmKZRVqw/BFEZuebyuz6sIKuufVtj0L7VeXtDj0ujOToRcXj6RG6X
	vQSkK4G31zp7XehWo7l56gIipDb/XBt8SzGM9FQKWjN5pghbvPRgxcJi4bRVbOqu+ZLM/6
	qVdxhQzQfXPOXlz7S+HOFTEzar9phA0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cR/djIVU";
	spf=pass (imf03.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447270; a=rsa-sha256;
	cv=none;
	b=6mh/swGiwbSRPpZLXv4rTkneu5uT1w4oM9wExs23MGZ0mrY5ZFIM2aIg0hiEyM4/ntwNSk
	b4nCpKFubXlKj98zs6DnYgfQt/1H3dOk9GK6Za6YiNNeblMFwI9ieN6G0xl9/lkRPzWb1+
	h8DFDIH8atDf2a4FYhIh8Es2ra85UTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760447270; x=1791983270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3LqwvcyCTUGBDDv54GKFHPFhtunF891CzWSsBDlRHvg=;
  b=cR/djIVUW9/E+DmNiF9fI6klxUZjTGu1rIqBeY606kVBBa9MEyIJBKVI
   fIMS3fNVX7j/i2gq24eVQdyF732BL/BnWlPW4NlChuqnMoT+7zTV0XiYP
   dY34zCVcdfrQjonutslN9eOMAUSp7GvhDP1IgLE77xbfgWtQyhAWkNhlz
   Be93bQ7meM6NCKobkqDYVw+C1+wuv7EWcsFJ/tlXSRUsiycOq4gp9Z20u
   MtZ63+zB/WW3Dnbv+kpmCm6J3W4rxz2nbOKs3tpI3Dw8/DpR/gGbdcRpp
   UfOQnxDA2lz1cimWCfM/JfzCsGtk4uUFSBJ5h3A2xOEXIuln0PllozeaI
   A==;
X-CSE-ConnectionGUID: 86x3SRPQRAuLYiO01ysZXw==
X-CSE-MsgGUID: EJWymsilS/y1Gu/n6H79pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62515383"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62515383"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:07:50 -0700
X-CSE-ConnectionGUID: wkKPsVjuQIOO3qPNmRmAVw==
X-CSE-MsgGUID: z+j4SIdnSy2mQrtAx02caw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182675618"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 06:07:43 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
Date: Tue, 14 Oct 2025 21:04:33 +0800
Message-ID: <20251014130437.1090448-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F0C82000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mhwqca3fmjjr3bxt1m5gwnus1o7ygdi9
X-HE-Tag: 1760447269-393421
X-HE-Meta: U2FsdGVkX18wn+uW5CMWk6I3uYsvpYFiAQU2D88KijBKzau0L8mK4R01fW2o2ebVCbxgbf/Cn2zga/56UZ0/xk0cTtK5RSLXVuwS2hTVqU3q6SNS6F1lHNGvMPhUKADw/xIUj655vdgPyKp3KK9JFuPmdt1y2huKqLsmO6sd5Lzb98/5QGjDIy+6tpSx0BVWR1Nz/KDyyqp+od5Sj7YWXly8LZGmwSY83FOtLgqz8M/gK9fUWvYPncI2P6+3SB6wFOA73gLbFd5qJ8qPEvD9AQw47W+XpVxN2uBSmrIdCEx7daAPhIOwLjyPSl9fsng1kgIDQeap1Ais/3A4CGks1xyw8PKk5POoeKIaQjt/OXLx2BpwWt8yQey3D34xlZvZg84uRccnDpjcAi2nkPFA0du54WH+KFxkq2Av18Q12nae5D+QUJx5iybo7TbZ8/B/vyNmPDzHKYUZXHNFH7XE4fakLDog+nExkw79seGUDgxlPj0dGq2aOJmHwscjyCIHqO2pgOlaTOLmY0yQZN8sn87bdSr0sqLuwXeuSpkOcNcW12VDT2/LbMUeyEQ5IPsEx87vusCSFhz0TkNb+qRXT7dczeXmDGoD0eRjAsBBy1I2aWfMTF7Ti9ktKmr2o/Sfn9aGLoEkAz9hCSi8JCUpef/TLrLBr0EZ+zurLJBt++AmB/jBwwLxNzc8FzY+7QVsPijpesUi1dHqpKPXJILiGwg/3iWi0gU36kN7jU/AVFpJBp/oE541lAdOjQqPpNk3++7mgHgxCnWX1N5r7o0aWZH5cvYRgCiWpmuVBmsDAs4BC9YbACla3+LvoIpeeIX3Am4m5s3AyV+eGjAkqKfqLnaM7q3e44qzXHJYCFcBfR328cSbGOF9Gtj/MDEyEqRuuqXsYUp1tEo33LibMhg3tJNhALvtRdUXKYe5c201zXwc5L492DLvlVLAP2TUL+DdnEZxMjvhyQxVDbtCxiO
 E1QVPI5P
 4Lv1qZf/hBRW2PGPPemu8HngvXmnaqEROrgHmTMqAMC4l7lZrUE0oz2EhEhGfo2Tybte+oAEPWe9QeO43xLp6rVElhB9ZklbvbvO+jWkcejWFUyydLdmrFZ+NTh4IOZRBsuz3jbdSxw7dYpJN/G3keQQuDjZivjBWPI5gbjbTVaJoK/eQjj2FuuLSWNbZq2yFDaj07qSiBCg49CPUdYjSk5qFO6O47w2zuFFZr/mUxQw8DxE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

There are a billion ways to refer to a physical memory address.
One of the x86 PMD freeing code location chooses to use a 'pte_t *' to
point to a PMD page and then call a PTE-specific freeing function for
it.  That's a bit wonky.

Just use a 'struct ptdesc *' instead. Its entire purpose is to refer
to page table pages. It also means being able to remove an explicit
cast.

Right now, pte_free_kernel() is a one-liner that calls
pagetable_dtor_free(). Effectively, all this patch does is
remove one superfluous __pa(__va(paddr)) conversion and then
call pagetable_dtor_free() directly instead of through a helper.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/mm.h    |  6 ++++--
 arch/x86/mm/pgtable.c | 12 ++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15ce0c415d36..94e2ec6c5685 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3203,8 +3203,7 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
 	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd))? \
 		NULL: pte_offset_kernel(pmd, address))
 
-#if defined(CONFIG_SPLIT_PMD_PTLOCKS)
-
+#if defined(CONFIG_SPLIT_PMD_PTLOCKS) || defined(CONFIG_X86_64)
 static inline struct page *pmd_pgtable_page(pmd_t *pmd)
 {
 	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
@@ -3215,6 +3214,9 @@ static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
 {
 	return page_ptdesc(pmd_pgtable_page(pmd));
 }
+#endif
+
+#if defined(CONFIG_SPLIT_PMD_PTLOCKS)
 
 static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index ddf248c3ee7d..c830ccbc2fd8 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -729,7 +729,7 @@ int pmd_clear_huge(pmd_t *pmd)
 int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 {
 	pmd_t *pmd, *pmd_sv;
-	pte_t *pte;
+	struct ptdesc *pt;
 	int i;
 
 	pmd = pud_pgtable(*pud);
@@ -750,8 +750,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		if (!pmd_none(pmd_sv[i])) {
-			pte = (pte_t *)pmd_page_vaddr(pmd_sv[i]);
-			pte_free_kernel(&init_mm, pte);
+			pt = pmd_ptdesc(&pmd_sv[i]);
+			pagetable_dtor_free(pt);
 		}
 	}
 
@@ -772,15 +772,15 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
  */
 int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 {
-	pte_t *pte;
+	struct ptdesc *pt;
 
-	pte = (pte_t *)pmd_page_vaddr(*pmd);
+	pt = pmd_ptdesc(pmd);
 	pmd_clear(pmd);
 
 	/* INVLPG to clear all paging-structure caches */
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
 
-	pte_free_kernel(&init_mm, pte);
+	pagetable_dtor_free(pt);
 
 	return 1;
 }
-- 
2.43.0



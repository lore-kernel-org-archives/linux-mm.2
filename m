Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A83DCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EB68E0019; Wed, 22 Oct 2025 04:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CEFA8E0002; Wed, 22 Oct 2025 04:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797298E0019; Wed, 22 Oct 2025 04:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 640188E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:30:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3C2648B2F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:30:03 +0000 (UTC)
X-FDA: 84025077486.23.D01D1A1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA912A000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:30:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZXcUgi4F;
	spf=pass (imf15.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121802; a=rsa-sha256;
	cv=none;
	b=x5QD2Po9yQ/5/cnZtnDeAM7q2BovFFSXSJTBc3KEnAyp70ikA2elO7FgZx3SNi+JYTuH4F
	PvERN33SQkv/9EQParwmh/hGUBOjSA23M/R60XMMPf7nxh17wI8fczMGxTLTu+rSGc4Ace
	b0uDy/mX8Leun2b9U6cgxDGkWljnEng=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZXcUgi4F;
	spf=pass (imf15.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDZl6F1NiSO6HgTviX9Y07aHB8ZW9D1LIPjfDyEKKkw=;
	b=XVbJs1WF2QfrIA6SBUsHy0tHpvd68oCs9D1ID2naxYlQc1lJef12TADVa6K6gS9ksSBE3v
	DGgB/x0+2NfkfIM2fGpgHcW3MsvBtHFlqmMLO1T3ictaamb4DzxEUT8c0RCqzSoDKkUuL8
	vpL/y5u1YS1hrTzYw4KCghAELDsxYgk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761121801; x=1792657801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MfPys1H3mTkc2x7BxXNZ3i5yT93gXL3B3ELjd678Yt8=;
  b=ZXcUgi4F8EuElerUNwWimxOIbAlpvgQgfaTYc3yeZo7EzoDCdEuQ76QU
   o6e/3MS7bNJELKzE5ibXcT+xbzxinTEE1540ckydcDgeXhqq0km5xYysW
   Y7JjI3RGfIBvv15nPOrAIq7bqAfiRAN8MqVRSrX2jdgmtGmriga7G4bpj
   GUKizN/T4wY1+cMgSRiemp5BbwyGFufOARrsK9iCXzZ0MMs1PKEd2OGqH
   4Keh0m/GVbIOEj6PbU5WW2xciNDPdz2wn3alzIGIoBkHGTyVXV8cONlU3
   2s2q5EP5QSpOoK2/5JOaV1muBFV/ruq2xm0e2e1T8M8FRXKSi2f0jqrBZ
   A==;
X-CSE-ConnectionGUID: RkMFFX+gTPyYJY1iogIzww==
X-CSE-MsgGUID: 38dc7D6BR1ObkAVtrB+1FA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="65879195"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="65879195"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 01:30:00 -0700
X-CSE-ConnectionGUID: lunhTNnjRASOL1ioYgr5fQ==
X-CSE-MsgGUID: 3cO1hRCkTtuGzHJHtyXxUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183516435"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa007.fm.intel.com with ESMTP; 22 Oct 2025 01:29:54 -0700
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
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v7 7/8] mm: Introduce deferred freeing for kernel page tables
Date: Wed, 22 Oct 2025 16:26:33 +0800
Message-ID: <20251022082635.2462433-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j3sntwpbt1ihs4pudqa14m8jf4pbnckg
X-Rspamd-Queue-Id: BA912A000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1761121801-856589
X-HE-Meta: U2FsdGVkX1/xTQJot27TGCbYhYrqoerqt2SKpsGSKklrnANaa4OPF8uTeGGz7VgRi4QNILXA6f/2vg75Ae/HueirgvOzTeDZ93ymL98kQyXg91GPQwqL6z3QdpmYsrUozLQR7/MkDIWwchAQsRINVBvITPtjeYzDuiEd8cMrh1hfxW4vH2RDmnXEA4yifXjlx4tPlZulfhukBuUUmrfcUoCBdV2D4T+hw+Otxd7o//iQnzz5duprRmbNBX8nvFdbFEapdS87gplfNxN6DXXggYz9tN8hf1/YNfvMNEz2fKOkRLNwPOb9G7l3nimrR8rzJRa5+GFYeb3VPaNyZcurRQJOcymWiIOvw3Y47TSxcccmPdHeYbJBZwRNanz1w335urlAkVNLqL1Ak0i6LTs27T2QpZcMl5zL27ia09Verygv3c6w97bq4JUP7AaME7fHQ7mLAblLg2X0d/Mtri8s1Bp9V4hfLBjR7NmFkXWZkIa9U2PlKjccIbd2bflZI9s8aY51Nr2g6d6SqNKNGM9JJsWnx9eyHJYsKkyy9tMTginzbtNVgW557uVhVr40vtUTzf/sgxMo6OOFxKkAlbhNmu4XmIMAWLxmLj3N5ahzY5FCWyEz5wNcTY2QH1An7h4u/b66uB2abrZGaucyl3AuLvmQhHN+LONQRu9fIfBpDbicVjoVSDADi99T03IUjutTGzy27nytYb2Hp4VMZspM2w6F8P1EIAmMoTKpePhNl4dg4BLr+Wkqz8/WCt4wAtUGUq/NlvtGTAftKWzhd4Q7WYWnVVGODXVAa3avAzCQ7L9yyc4sAJpFEVmBwBsiMypVpRzYW0asODIkpHKbPMUJahyG7bxByVClRiHRnowIZM7d39dpP/Y87v44UQt4fzL2PBtJZgACe/kmN2cBNti/WifVhaI281a9z3T2Gxd5AVOEgfVDdbtzqxQrSRFbtyvqoQwBgfHz/V4ftcHk5ZX
 +huy/6vH
 p5HtlYOtAme3h43/OP/nQ+GJbH5IcDwOSWb6EciulEynTmY+hkx/ww8rUJdKzgx4bCw1V5KXYiLQ8++JbswgJmqLnWtgEkK5Zea2fOseUbzR/hkF2JTID27TCknvhnQsKsA3mW8rx0tCV5vKwjKEw/fY8meiY4B3Br7bQRYOLF4wiGg1Rvu7x/DqYsRlyyoW5UU68Qeg+DfpldHyb/HXWBfE1X/x21la6azjOZUGonRDC4VY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

This introduces a conditional asynchronous mechanism, enabled by
CONFIG_ASYNC_KERNEL_PGTABLE_FREE. When enabled, this mechanism defers the
freeing of pages that are used as page tables for kernel address mappings.
These pages are now queued to a work struct instead of being freed
immediately.

This deferred freeing allows for batch-freeing of page tables, providing
a safe context for performing a single expensive operation (TLB flush)
for a batch of kernel page tables instead of performing that expensive
operation for each page table.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 mm/Kconfig           |  3 +++
 include/linux/mm.h   | 16 +++++++++++++---
 mm/pgtable-generic.c | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 0e26f4fc8717..a83df9934acd 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -908,6 +908,9 @@ config PAGE_MAPCOUNT
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
+config ASYNC_KERNEL_PGTABLE_FREE
+	def_bool n
+
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 52ae551d0eb4..d521abd33164 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3031,6 +3031,14 @@ static inline void __pagetable_free(struct ptdesc *pt)
 	__free_pages(page, compound_order(page));
 }
 
+#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
+void pagetable_free_kernel(struct ptdesc *pt);
+#else
+static inline void pagetable_free_kernel(struct ptdesc *pt)
+{
+	__pagetable_free(pt);
+}
+#endif
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
@@ -3040,10 +3048,12 @@ static inline void __pagetable_free(struct ptdesc *pt)
  */
 static inline void pagetable_free(struct ptdesc *pt)
 {
-	if (ptdesc_test_kernel(pt))
+	if (ptdesc_test_kernel(pt)) {
 		ptdesc_clear_kernel(pt);
-
-	__pagetable_free(pt);
+		pagetable_free_kernel(pt);
+	} else {
+		__pagetable_free(pt);
+	}
 }
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 567e2d084071..1c7caa8ef164 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -406,3 +406,40 @@ pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 	pte_unmap_unlock(pte, ptl);
 	goto again;
 }
+
+#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
+static void kernel_pgtable_work_func(struct work_struct *work);
+
+static struct {
+	struct list_head list;
+	/* protect above ptdesc lists */
+	spinlock_t lock;
+	struct work_struct work;
+} kernel_pgtable_work = {
+	.list = LIST_HEAD_INIT(kernel_pgtable_work.list),
+	.lock = __SPIN_LOCK_UNLOCKED(kernel_pgtable_work.lock),
+	.work = __WORK_INITIALIZER(kernel_pgtable_work.work, kernel_pgtable_work_func),
+};
+
+static void kernel_pgtable_work_func(struct work_struct *work)
+{
+	struct ptdesc *pt, *next;
+	LIST_HEAD(page_list);
+
+	spin_lock(&kernel_pgtable_work.lock);
+	list_splice_tail_init(&kernel_pgtable_work.list, &page_list);
+	spin_unlock(&kernel_pgtable_work.lock);
+
+	list_for_each_entry_safe(pt, next, &page_list, pt_list)
+		__pagetable_free(pt);
+}
+
+void pagetable_free_kernel(struct ptdesc *pt)
+{
+	spin_lock(&kernel_pgtable_work.lock);
+	list_add(&pt->pt_list, &kernel_pgtable_work.list);
+	spin_unlock(&kernel_pgtable_work.lock);
+
+	schedule_work(&kernel_pgtable_work.work);
+}
+#endif
-- 
2.43.0



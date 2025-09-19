Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A23CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC1B28003B; Fri, 19 Sep 2025 01:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CAB28000F; Fri, 19 Sep 2025 01:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C1428003B; Fri, 19 Sep 2025 01:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F85728000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:43:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E025558D05
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:43:09 +0000 (UTC)
X-FDA: 83904906498.08.EF198A6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CF7010000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:43:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZEIF1OsF;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFyhiG19Aj+ClQ+OtHrsBd1jqqkHLmYcrToUI2uqAd4=;
	b=C1Mv9E7VbZ/nnwTn18UMVOR0dcDQHuKXX44s08LsBZxwVDVupHB2rRpy9g8/xQQL+7mf9r
	Ys0b0p6JAOmr+CGMT3OsO2xTv/Ma03KbavquskucUX7s/FgY+4W+YcfeT90Mc0DttOxLAk
	E3vapHxxyqQbQ1jYifzVObgNW+Yma20=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZEIF1OsF;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260587; a=rsa-sha256;
	cv=none;
	b=R5DdE0YMTCXzQ3mE64epE+0ClnfdzvPdPXVMG5UXKDclhzuOEfBA9/jr2qkKgmmPIc6lxQ
	Friv1Lre0HK6U004lQ6FtSIC0XRaxZlRQnRNHfGXF5cMYfaA9BqE/U+pqo/dmc9Fxg56cj
	9Ua3HoakHWMr7Na5lI/+k00r2xx5ITA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260588; x=1789796588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XUszhuNZ389vB8JW9mMK3FCAh5uDSfA8sbiYQetS8U0=;
  b=ZEIF1OsFtQdFiuX9PDBXFdWVpOKW31yi8UaqowLiPrXuuRk0O2EnKwSN
   BXw8Rd/oMAk4D0Q6ak8n6ssnUK7m7YQ9cTi46jDXM6UDtXJDzRLDFR2e/
   xSxFq43Ai5Lt1d0+WsnGzu3x7vPwD+y3SGrTynn9XnJ1QOrunl3kR2tVj
   xm6GoXlwkA4b11dkIJIFmsKnnalmZGa8QZAbmDDPyC60kZguNkV4xT4M6
   a7hUQpf30eySkW0RPRm43II+pdwqK/jSrOJbFs/8jEA18RzQkWThp3rJz
   4AbpOMt+gfTnwHAB2iHu9tK/2PohjpZX4Sb/xkJVQcEp3aYYHGXm1w0jL
   g==;
X-CSE-ConnectionGUID: fIOWtTRrQiWkfanuNwJxGw==
X-CSE-MsgGUID: kq4PnHjrTAKeuHt0chU5Aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235825"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235825"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:43:07 -0700
X-CSE-ConnectionGUID: bQxzzAHVRQKGYHmNzIp8gA==
X-CSE-MsgGUID: DXTduhSRRmiv7fQx7EjT8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858756"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:43:01 -0700
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
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 6/8] mm: Introduce deferred freeing for kernel page tables
Date: Fri, 19 Sep 2025 13:40:04 +0800
Message-ID: <20250919054007.472493-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9CF7010000F
X-Rspamd-Server: rspam05
X-Stat-Signature: yeyim7ogy89z4n8axk1nha35cdf4bh6e
X-Rspam-User: 
X-HE-Tag: 1758260587-929724
X-HE-Meta: U2FsdGVkX1/KUoYY+wTZMy89ri9apX87gLL9jQ3Bao7L6YGGajz08Ou7cEwxKdihlR1vgabGulKh2b8cAH1L726FQDXbuvSR5Y8hBBOC3f1WhXC4sUf2nPnkfpmnOkALPq4epjznSDAcdTXCdGN0M/hQimUewkLqwmz9xS5ufKZFriNQdT7X+fEVObEZ3jg9nO6GlsjTTeUxfnyGMwVZEsoiUFk2yb2C8EnZklRb1L+GJtb5dOHFbPAwQ7qh4Fc9hSVy7TWzLS1YaKGepLXMDHEcSl0ptU1wIfXzD0I7zNWGIqYaASxkvUg3Dcd+BTsiNPq2iVy3vpFrzbEhSdUUWKISoVeBjdMDH+5zW95UnH1fTlyW5mW7RAJlWnSP99sSyq/osX3oKPbeoxOGgmejoMhLMd6ev2BhetEJLTY3JwPZ/X2kjH9EN14cfnHWPgnN3EzgNcRvOgwRtii/XhHhhYKpkvkPLOLTjoMduENef4idyuaMDK4eP8f11CQDlAMapU8Obb4lHDnPbcklRvgpb1J9tEVW7VbIit2Z50D7NglZRaPBAEm1TH33AkBjzeVLJTe4zZTy+Sfk8DE3bASyXDhbXC3SRLtIdTNOcZ27TIW5CBKD3iY8XWVXoNG6kXdCpqoqTJQO4c+Hbb8ZwawC5ZYysTRiJ8xSiqjWonIyRMYZCXCapludalZLPBV3D2As/F2Mwq8rPvkZ+HPwHaFrySaAopGevaJEJ+Cs7a2kHTJlzyVhH78Zwa8m0kTje+sioN+6SrEihvqNiaaYq1kDLTdF66Wm97cg8UHCc0THL68W8Ph8di/wZRRVpzcXOnopnK4JwfCOSlEQ+eA6tUj4mYmsY+/MHJ07jdX2loTXaEy2xchHilclU2o6XNPpyU7GU8Fehp6S906cbaT3TcJG8uAztoSUhcFfz+w7BudxdgdGXZXKgU4dHMVPKkB8yP9E2k+NxxNXSz2JXq9fmri
 Fsbb+Jal
 MTosO6ZWQdn1huurVyIJfsTKdScEhA9JnF9jLeikB4EXSSfGlJ3HNUVZFDcBLVPSjhOUPT2w8s6QTluF1GMHIem0n2UieG5OXe9Fynx246xmc1CMl4e3GDApOD0v0UGgVH0SNpajIYN0WLK+T4RSUq3fIoaUZznVWikZGPckTu/DUIWS+4WSYAXJA02EwtUVnBn5GL4U2FtjpvU5y3JS24/UocXIYWaGztj1g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

This introduces a conditional asynchronous mechanism, enabled by
CONFIG_ASYNC_PGTABLE_FREE. When enabled, this mechanism defers the freeing
of pages that are used as page tables for kernel address mappings. These
pages are now queued to a work struct instead of being freed immediately.

This deferred freeing provides a safe context for a future patch to add
an IOMMU-specific callback, which might be expensive on large-scale
systems. This ensures the necessary IOMMU cache invalidation is performed
before the page is finally returned to the page allocator outside of any
critical, non-sleepable path.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/mm.h   | 16 +++++++++++++---
 mm/pgtable-generic.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 668d519edc0f..2d7b4af40442 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2891,6 +2891,14 @@ static inline void __pagetable_free(struct ptdesc *pt)
 	__free_pages(page, compound_order(page));
 }
 
+#ifdef CONFIG_ASYNC_PGTABLE_FREE
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
@@ -2900,10 +2908,12 @@ static inline void __pagetable_free(struct ptdesc *pt)
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
index 567e2d084071..0279399d4910 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -406,3 +406,40 @@ pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 	pte_unmap_unlock(pte, ptl);
 	goto again;
 }
+
+#ifdef CONFIG_ASYNC_PGTABLE_FREE
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



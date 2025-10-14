Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E75CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E02E8E0116; Tue, 14 Oct 2025 09:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7798E0112; Tue, 14 Oct 2025 09:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6E38E0116; Tue, 14 Oct 2025 09:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED4998E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:08:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABE05C0936
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:08:16 +0000 (UTC)
X-FDA: 83996748192.14.7B94DCA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D0CBC0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:08:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S/RW4m4h";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447294; a=rsa-sha256;
	cv=none;
	b=08II1/sLl7xmIlgqR5qQX3hCUK1IuesYQzC/mrVzR6DIYDvrfq1xiWEtQJAA/uuy6awkEb
	Ns+0SkQrqO4DJkFBgfE00PPkwc80cPE6zofncKKKoThsBRnSc+3sURIYufoIwQLv1S0+lp
	xAsWp9ywG+Gnq453keXIx6cgOubMRy0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S/RW4m4h";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFjqPss/05hT4Ui2djTBpxHlgiGLKTGxBVqpMBNPmSI=;
	b=67N9kSL+VcxaQEE/At93rtrgEcyw2YqxvxsdCrBik5VQDkL+4aRBTNbNuPygObyc8qqXL5
	+8GeIgJEh0lg84OCbECK7zXUblGoCqdn62q9TTr/VY+AAdhwHCWegmhIE/f8xd84ek9E6f
	jw0iOZDAwo0k+CkM+mJJaFvAUbVVpvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760447295; x=1791983295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F4I8Kvtwn3jusskaFJsgVirsMtZJ1VpejkaxbIoXrsI=;
  b=S/RW4m4hawkfHBMgvtjWPWtNg/08J8XI2ScCiSYpxDo/4lYHU5x1cmgZ
   aAKf0lm03iDelczbzy3zsJDUdWQdw8cZVwlt4j+WKO0yRmaxtHGqB4BwS
   d+CHqEHWw3w6Ud24XmRQohf8qgY040Xq5lM53FrsyUMyGvOR4KqEvBQuG
   r7Tj+oeS2Gyj+xzHe8Ow0Vu/6gTXSDqg/gxkV8TI7qZ01sjBSYpdI1K1C
   d8ebP7pN765mV4XzgiRJX+ApA8ULRULRTXpqlmHCxNNYKHFOoB/CPONK/
   oYMPz4+wduBx9OeEy9AbAKRHPkCN0aTP0+T1N8tAOdR2d4D0/VvRs8RFx
   w==;
X-CSE-ConnectionGUID: ytS6hdpfQZmMuNRM4damkA==
X-CSE-MsgGUID: B78sZD5OQFSwCjqDi2U36A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62515481"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62515481"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:08:14 -0700
X-CSE-ConnectionGUID: tSK9WVeGSxqGkNXKwf99Kg==
X-CSE-MsgGUID: OTzctZkDTmCiQhcd/KV4OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182675699"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 06:08:06 -0700
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
Subject: [PATCH v6 6/7] mm: Introduce deferred freeing for kernel page tables
Date: Tue, 14 Oct 2025 21:04:36 +0800
Message-ID: <20251014130437.1090448-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cz1tjsit6tnkhcztqfnzp3daopszc7xj
X-Rspamd-Queue-Id: 6D0CBC0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760447294-171485
X-HE-Meta: U2FsdGVkX1/pEDFKgmj+QSdvt6d5pXbo21rEoGFblJT9cv66KjijmHWG3+hHKhAS/9Dyyvq+xe6SKMYNGNLz4UJDTAIsFPXDSHUxxP3ftyl+ZV5mmEYG1zH227kUyNHRTk6OMlzzUi3/jP4W1jLoOKbau6DcU/flmbgV6Rn3KyxuV0Wm3MEOaLI3OnVwIvXI2PW/ssKSb9Z6bytnJUGFXlnl8F/SRS0fmUrev+98WnFqKnTP8hxIjIBLdWKW/JvZTAe/ebRtpOt56oueABmeTjjq34eVRYjm/mVHDRiSV0DofIuLF4MEUDJmTv5iLaPHOrRjM/YdZ29rXI6G52+7ZbFTLhBB2iR8BAZD8MQ6iZAWn65tFNOHZ/NP81F2vDyC3AATBG8Zx9F2K1MFr1r1cWf41seTaYfgtScHV+twYEQCvm+JZH2YRqGabXrqiv/nwxTsJ0+XtFYbix86B4Rcm1Eax+7c3ch/84iWoEORnDolri7lRzDGss8WVu8r8tgXH/bj+FVw9R/Rsu8eBhD9yKxRn4xPG9y99R42eX/M3tzJpyW9ONy47y9cwq2ytcnasR+fiDL6JHXuKbmxpIoSrq81+Or/W+7EJQtvjDp/lH8c2w6CWzErUVE53KHLr2EEphwU/gT20PVY0QA3bnsAzqbAOCDw+TMOZnMu5o9LhPUzUTSJxpTMy+bjoeY2VQ0y3BJCl9XbtRbfqoDq1zEr85mcdxOlPkVsRrhgkXirkiGjK/DKzNVKFi8v8Q08xuQxHWy9rM9ZdgIdmEnArEeJyG1qORExuPc7+a+CP/g0KdN8//QEDsKdxuT8JH5BWw7mWkmp0ORkFfAPWUkuNNjoba+ojaGjNlWi7yDEb6fgX1IHRQXcT0kdR26OPktP88RLSzXxvmKeOKyRLUHA6w9dzoiksJbDRTXrSqO3aE1SRmLARBVCT04e0yDdL5Y0J81qT3QozZab232K0lrwiuR
 qvVnB9MN
 8ebIoJtMCApPDkaCN+O/n0gYFwRW7zioXHI4iBJbBrDDJd/eiTqcGPRvaPj406hk0/Ooz2az9QeEXhG9q+1TiJPaDzj/7dcjUZt6t/zPoNI3wb9noHsbFPYCApmP0sPk6JoCZmLG8wZeXHPYJ05RlBlwVW9xLYOwWSqjKFsPyMZJFEhGX5IyjHJmo1RfiIDqrhNbhXtujux1RxEy43Q0ghiFVs4Az3OyGqS3DPz++L3zmgLg=
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

On x86, CONFIG_ASYNC_KERNEL_PGTABLE_FREE is selected if CONFIG_IOMMU_SVA
is enabled, because both Intel and AMD IOMMU architectures could
potentially cache kernel page table entries in their paging structure
cache, regardless of the permission.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 arch/x86/Kconfig     |  1 +
 mm/Kconfig           |  3 +++
 include/linux/mm.h   | 16 +++++++++++++---
 mm/pgtable-generic.c | 37 +++++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fa3b616af03a..ded29ee848fd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -279,6 +279,7 @@ config X86
 	select HAVE_PCI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select ASYNC_KERNEL_PGTABLE_FREE 	if IOMMU_SVA
 	select MMU_GATHER_RCU_TABLE_FREE
 	select MMU_GATHER_MERGE_VMAS
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
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
index bb235a9f991e..fe5515725c46 100644
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7284D637A7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 20:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177056B0088; Tue, 16 Dec 2025 15:12:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155096B0089; Tue, 16 Dec 2025 15:12:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0576D6B008A; Tue, 16 Dec 2025 15:12:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9B7F6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:12:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F712C02E7
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:12:48 +0000 (UTC)
X-FDA: 84226432416.30.47878C3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7DC7B16000D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:12:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YTjpuX6n;
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765915966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tll61WMHPvREOW4/BIXFdflMn43TT6wy4soTCDBhrOM=;
	b=unazrDYNK7xu/MCAEYEaV+nv4tQt+MDRlEOXdoIpcTOqbT/BsNolokvN8NVSVJk/HzwtNQ
	W9FFTEoSxZoIp8j8rizPuU/CyPWzuslB48v7FXf3pBXveDTONakb9YX76kfE9ALuyAppbl
	JrRINuFQKpIDh8/qgggPsOcy+ODE1zA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YTjpuX6n;
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765915966; a=rsa-sha256;
	cv=none;
	b=SqUmITA6b7DmvwUUpHQFu3d75RHqZBI+0IWC0Kntraeb2Xx+VXe3/QuT4+xNL0cbi/Hfch
	Ci3/wQJ5yfa0DS+hsjLkpnlcHNu6NFx8dc1V/Cu2gCqPiMF22ExC2erYEeHxnPj/JyFCXp
	XgeAKmwdyq9m/DqvAcrFZ1AKwcFnw8o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765915967; x=1797451967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iCjVYYUFM5BX9VEsC0diH84CR7Fq7Z2IR+YKYKMbFb0=;
  b=YTjpuX6n8H/4fAqduBHrdpcdhMFEcGuMaExEcJwLNK6ux4EzFKfGuf1o
   x7CwQLmHOQXeeYdhXrtrIc6BMtlqMDbGpPN+y9AAm426mnOs0w/qn2uME
   pNtuxx40xX0Tv02orTf2vsTzJVeXqddQxVnb3ojvhMZ9WkMp3yv6AipKU
   lnJXSUiYdkW4YofHj1Dn64ML7a0YNVWBis7YeKrg1aEQa7U634lZz8/g3
   HenZE8et8oDCW1q/gGsq4g4a+GOjxdz99tFF14hxBBAGDRStdaqaV8LwT
   h1vgw/E+5VagvvNU7ydnBo4w2ri2CIaIWaHzlluW5CDpkJplTPExL300Z
   Q==;
X-CSE-ConnectionGUID: C1AZZXCIRUqnTVh2UamizQ==
X-CSE-MsgGUID: b5GeiwbHTAWKphU6C98Mpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="68000582"
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="68000582"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 12:12:45 -0800
X-CSE-ConnectionGUID: zcX2E0nfQiWvpx2Bn0gV1g==
X-CSE-MsgGUID: eeXiC8OkTwuiZ/7bQKq4tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="202612430"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.244.214])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 12:12:43 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH 1/4] mm/migrate: Add migrate_device_split_page
Date: Tue, 16 Dec 2025 21:10:11 +0100
Message-ID: <20251216201206.1660899-2-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251216201206.1660899-1-francois.dugast@intel.com>
References: <20251216201206.1660899-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: wz9cmuo7rtq8o6f1srkqyxkaytqra3z6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DC7B16000D
X-HE-Tag: 1765915966-830823
X-HE-Meta: U2FsdGVkX18A7cUvtNd+dGndkeVcjoqmJpccKU6eXLnfmmvnBBA8ANrIMdzyDf3jbbElkkzGkrU7F8DYHvfj9nR0M74KvNFURilzhmhwB8HgzHjTwuJlTLBvyviojKapaOqzDPAg9IpgYck7lg4yD+Ndo+ZXZVvezJY44roDu4InGVxrgq2uS0vyAEmDn6AGtT0UONEAwSvOLWLxUirZtfOVaBEbY0oj4ZznhKXqYSDE8injVlzP7Bxm2CdwFhuc97F8K1EXxrI580IvS6gne3CDTSv9RbW0o42LdpgcS/eKfE5Sy4pomoeXC3lZXl4mrJG7Fby/iOJInmb3Xy/4KS9MQaxdcjBVRy7cG7OnCj959ngBPZe0js/c6pUX3ihXCaxQAUiFhsnOBBUb+Xjkiau7GoxeW227JDkhS0wDMBbyxstajFHhk4EDglsAo+jyuz2hRgum56d2E9Nps2NChtr1J6A00B9YZVOkDaC5LVMeuM4rbpgjpQTuqvfgkpCp27HQ6akydoWOQGJpgA2hUriq6Q305M6EdOOGmw3EkTVoYxnXX994xcuAeU7r1rbdzMa5MjmvHI8h8RfsM05QtYBhv0AfQWolrzbQJCh/nYy3iID6jciTElkhpzktcwaAhZHpR+bjvSvusRbW7qT/Daxz8wMTbHmIlUnlLDovoIFk0TQMuGNbOTP5RCejQbmjjELfY/xqfvfUu1yxfITSnX11ZRnc9bQ/FEprsA8dCV1NL4OsdqQcnhy6IZUwcz0F3+73GS1MW3gagBCkzk7aRaHwFCVFi3AvVVP4j/ALz2+B4KNX+tBvwBKGYoUobOZx8MignAv9c4VriEkxObYUvPmHdccrBz45
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Introduce migrate_device_split_page() to split a device page into
lower-order pages. Used when a folio allocated as higher-order is freed
and later reallocated at a smaller order by the driver memory manager.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 include/linux/huge_mm.h |  3 +++
 include/linux/migrate.h |  1 +
 mm/huge_memory.c        |  6 ++---
 mm/migrate_device.c     | 49 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..6ad8f359bc0d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -374,6 +374,9 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
 unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
+int __split_unmapped_folio(struct folio *folio, int new_order,
+			   struct page *split_at, struct xa_state *xas,
+			   struct address_space *mapping, enum split_type split_type);
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 26ca00c325d9..ec65e4fd5f88 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -192,6 +192,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
 			unsigned long npages);
 void migrate_device_finalize(unsigned long *src_pfns,
 			unsigned long *dst_pfns, unsigned long npages);
+int migrate_device_split_page(struct page *page);
 
 #endif /* CONFIG_MIGRATION */
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..7ded35a3ecec 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3621,9 +3621,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
-		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+int __split_unmapped_folio(struct folio *folio, int new_order,
+			   struct page *split_at, struct xa_state *xas,
+			   struct address_space *mapping, enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 23379663b1e1..eb0f0e938947 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -775,6 +775,49 @@ int migrate_vma_setup(struct migrate_vma *args)
 EXPORT_SYMBOL(migrate_vma_setup);
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+/**
+ * migrate_device_split_page() - Split device page
+ * @page: Device page to split
+ *
+ * Splits a device page into smaller pages. Typically called when reallocating a
+ * folio to a smaller size. Inherently racy—only safe if the caller ensures
+ * mutual exclusion within the page's folio (i.e., no other threads are using
+ * pages within the folio). Expected to be called a free device page and
+ * restores all split out pages to a free state.
+ */
+int migrate_device_split_page(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+	struct dev_pagemap *pgmap = folio->pgmap;
+	struct page *unlock_page = folio_page(folio, 0);
+	unsigned int order = folio_order(folio), i;
+	int ret = 0;
+
+	VM_BUG_ON_FOLIO(!order, folio);
+	VM_BUG_ON_FOLIO(!folio_is_device_private(folio), folio);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+
+	folio_lock(folio);
+
+	ret = __split_unmapped_folio(folio, 0, page, NULL, NULL, SPLIT_TYPE_UNIFORM);
+	if (ret) {
+	       /*
+		* We can't fail here unless the caller doesn't know what they
+		* are doing.
+		*/
+		VM_BUG_ON_FOLIO(ret, folio);
+
+		return ret;
+	}
+
+	for (i = 0; i < 0x1 << order; ++i, ++unlock_page) {
+		page_folio(unlock_page)->pgmap = pgmap;
+		folio_unlock(page_folio(unlock_page));
+	}
+
+	return 0;
+}
+
 /**
  * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate->vma->vm_mm
  * at @addr. folio is already allocated as a part of the migration process with
@@ -927,6 +970,11 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	return ret;
 }
 #else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+int migrate_device_split_page(struct page *page)
+{
+	return 0;
+}
+
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
 					 struct page *page,
@@ -943,6 +991,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	return 0;
 }
 #endif
+EXPORT_SYMBOL(migrate_device_split_page);
 
 static unsigned long migrate_vma_nr_pages(unsigned long *src)
 {
-- 
2.43.0



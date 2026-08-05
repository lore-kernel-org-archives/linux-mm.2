Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B80DC55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156B96B009D; Wed,  5 Aug 2026 17:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D7A6B009E; Wed,  5 Aug 2026 17:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06AEB6B009F; Wed,  5 Aug 2026 17:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE1896B009D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E5A0A062C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:19 +0000 (UTC)
X-FDA: 85068448878.16.B636D35
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id B003E80008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JicgyhLh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAHwpiH4yYWNgumGaMK1j2M65MBFePIvlnZqmKRnndU=;
	b=6W0nCicpFda8rSKorg3wLrc1vvOKBGnMgHQ7NYb/nBwDpmvZAVt2Nrq3X+YMHhXccnPNtN
	KwtEl/Vj7KpS+Dc2hop74DkGJ4wXAxzVoU+CkQC5BuP9lYWCXViPSPPsBMwDLJlVhJiPbG
	Z923sHCZq65NxBNE9nk0vxwOqI/9BrE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JicgyhLh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963977;
	b=MBME/dsp1GN64nuDfj9o+qQ3xaWgVcmj5xpOqd+z5Qkbfjn4xHyvlADX0OclzWw5oi0sa4
	eqzOV3jpRxE3rEx7cjLVUoF/G50wdfKth6Q/UTpCH0ItxyHkhHgNnVpwLA1iR6gJlmpHXV
	Kb4tZqA32qP0D9NyJL4UEQJwAeVL6Vw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=hAHwpiH4yYWNgumGaMK1j2M65MBFePIvlnZqmKRnndU=; b=JicgyhLhS91OIiO6kYmPLd/lcy
	cE/FRzVTJARf24S7+jwlC/6xruwWjPjfwmgKoqSDA8mA0SsEr3czuY3pzxJqrMZZl2BFkTOEDlbUs
	H5h5LTwQvFs59vLBfvsxyr3eEmt5pcTX7sLaQI5Fdn5VzWOsYQH4yqWY2HT7ypafHkAk7AOIDntYn
	TrKftvnMUrW/4HmH+RkjPOj3ATCNZ9YqRXyt27gtHgSYG4jB0C8Z7tkCE0hw5zSFG97aPFH6XGnqD
	s0TOCwto9bTtiRTuZd1EDvvP1TAlIg26ndJl69lMuKd/HY6zvgh0DJRY9ytbmkag5fbUeOB1+/LNq
	26iL/D9Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioJ-00000004h6B-2kv3;
	Wed, 05 Aug 2026 21:05:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH v9 04/15] hugetlb: Mark some function arguments as const
Date: Wed,  5 Aug 2026 22:05:44 +0100
Message-ID: <20260805210557.1118966-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B003E80008
X-Stat-Signature: 6us3my9d459qc6fcwjnicbpz1scrdu71
X-Rspam-User: 
X-HE-Tag: 1785963977-8473
X-HE-Meta: U2FsdGVkX1+w8Dk3gX6PpFeTi6nt4IH+8+JkY/zT7O/ghUMZumbzjlzeugnMhmyaodPEgwIf9PJ28VmrD0QDfd8IB0YyezQHrxgVdKD938trXPO5l4CZ67fL7U/N5oUAh1/lZOi3MA4NHSHZySsuqaUWhlGuH2afTO/qNJhNFXs9Cwy5hNchuvscMgQr7+qFcLyEDsjKpWVMwLPsdUCPJUGl2DNiQ9LJMZZuiEHJNH9FKwKzoD1vonncIFCGC6Ada036psP0zrhIhn5//hy9Dusu9p27M6h2X0PZnLQ5YauTjy1A+paIJt0m5iP9B7J/g59vG72lGebMbJ8fH+ZjJf+U2OpukVCpJIAqizucuhzSiddcr3DJUXJSWgXESp5XEn1ZfQlPEZrt8pCYKMwiCe5iy8QQ8GXg8U7WHmL5ulf/UsTnlVQ/VHE12ueOp1CPu58VDk8BCZyu/pIXSPp45a0SZiVeARArxFZbB2cNjZmny7fYLOB7KcqKF0Gc9zVWprwQcWLmr6oN1RzkDynWgdplo+QqMh9BErCEtWyssEU/XvA+tqgaJk8EBZ8hNqu1kOKqfC7ZCtNG2dhP07b6h9Iv6ar2AxBI+NbqoXl0u34Xyz2jb9BdSJ5HcJkPQzhYyhIkqaEqaOItkgrpbgEfLBkt+RNNEv8e6DllbvsDQxoTMdd7yybm913Z9wSPboHXtRBM0XOHPypW2v26GSLci2weaYnhnxktKPqwzTIoDvAwgfhVEhoWQUBWqKIZMyRMvebo7tly5wpJ4MFOZv1QBzK09bC807T91/n64toX8iZKpMge4bI822qCuOvoGaeTcntevT9cbTj9nYKSceDto/i7gm7jfiO73R0kwP9rnaOrdS3dwXgfhJYkTXD8/bffVwxEhwO+BWYCz/FhdOQ6EK/+AEe8HVaKr3RqvyiKy06sRBRvA/Pllx1qbIrB0h4X1S/1hSk2VmSN2WXHYpc
 0UIuO3PW
 wBF4ybjVh47Z0fukg8zkFBmDLEGgwssj+F1TMzuT9WLz4DNezOSv0Nme74NVXvKXYW/r7NBX8nCvh4e27KgKDf7YFolxkcmZLRF6Oqolfw6K5rtAntZAYD3t9+Gfe/m7BA6gkUwt2LXQtZmGY2XRe8Amvj9xMx6EsrhJM+OW6BbZCDhePTtF6J19Q9/fEHz7HQujiAUenRA6C2TvZoaHvbXU9w2DsB5f1LRkG/z9BYHJt3gOX7z3zmADtB0Wc0SQKn5/Ll8it9HA35gnndg+ujRbIUfn8MzsFruGvNkphTXY1hCnl2z3nOZg4Fj4FNfpAhRqRyUPFlehQ2WpdwtxZeVw70A+mjLeIUK/xQiPnlh7A8veCOzJbooPcFbPx2W5gJ25yQ6PrOlSBf5V97uIgN5mh6YfrnCR8zMOUgI6yePsEr5dvt0XJzcDhrmgxliE6BN0Gv4NCO4Lo6ZNNk1DneFuJ+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions do not modify their folio argument, so we can mark them
as being const which will allow for some minor optimisations and let us
mark other function arguments as being const in the future.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
---
 include/linux/hugetlb.h | 19 +++++++++----------
 mm/hugetlb.c            |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 50eab2c23299..e200c93088bc 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -176,7 +176,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 				 struct vm_area_struct *vma,
 				 unsigned long address);
 
-struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
+struct address_space *hugetlb_folio_mapping_lock_write(const struct folio *folio);
 
 extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
@@ -311,8 +311,7 @@ static inline unsigned long hugetlb_total_pages(void)
 	return 0;
 }
 
-static inline struct address_space *hugetlb_folio_mapping_lock_write(
-							struct folio *folio)
+static inline struct address_space *hugetlb_folio_mapping_lock_write(const struct folio *folio)
 {
 	return NULL;
 }
@@ -614,8 +613,8 @@ enum hugetlb_page_flags {
 #ifdef CONFIG_HUGETLB_PAGE
 #define TESTHPAGEFLAG(uname, flname)				\
 static __always_inline						\
-bool folio_test_hugetlb_##flname(struct folio *folio)		\
-	{	void *private = &folio->private;		\
+bool folio_test_hugetlb_##flname(const struct folio *folio)	\
+	{	const void *private = &folio->private;		\
 		return test_bit(HPG_##flname, private);		\
 	}
 
@@ -635,7 +634,7 @@ void folio_clear_hugetlb_##flname(struct folio *folio)		\
 #else
 #define TESTHPAGEFLAG(uname, flname)				\
 static inline bool						\
-folio_test_hugetlb_##flname(struct folio *folio)		\
+folio_test_hugetlb_##flname(const struct folio *folio)		\
 	{ return 0; }
 
 #define SETHPAGEFLAG(uname, flname)				\
@@ -746,7 +745,7 @@ static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
 	return HUGETLBFS_SB(inode->i_sb)->spool;
 }
 
-static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
+static inline struct hugepage_subpool *hugetlb_folio_subpool(const struct folio *folio)
 {
 	return folio->_hugetlb_subpool;
 }
@@ -876,7 +875,7 @@ static inline bool arch_has_huge_bootmem_alloc(void)
 }
 #endif
 
-static inline struct hstate *folio_hstate(struct folio *folio)
+static inline struct hstate *folio_hstate(const struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 	return size_to_hstate(folio_size(folio));
@@ -1107,7 +1106,7 @@ static inline unsigned long huge_page_mask_align(struct file *file)
 	return 0;
 }
 
-static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
+static inline struct hugepage_subpool *hugetlb_folio_subpool(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1176,7 +1175,7 @@ static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
 	return NULL;
 }
 
-static inline struct hstate *folio_hstate(struct folio *folio)
+static inline struct hstate *folio_hstate(const struct folio *folio)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..cc8d98399913 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1775,7 +1775,7 @@ void init_new_hugetlb_folio(struct folio *folio)
  * stable.  Due to locking order, we can only trylock_write.  If we can
  * not get the lock, simply return NULL to caller.
  */
-struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
+struct address_space *hugetlb_folio_mapping_lock_write(const struct folio *folio)
 {
 	struct address_space *mapping = folio_mapping(folio);
 
-- 
2.47.3



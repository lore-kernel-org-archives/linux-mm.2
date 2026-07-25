Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE44C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288A76B00AB; Sat, 25 Jul 2026 12:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239BE6B00AC; Sat, 25 Jul 2026 12:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1507D6B00AD; Sat, 25 Jul 2026 12:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7E336B00AB
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:01:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A08B4039B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:17 +0000 (UTC)
X-FDA: 85027763394.24.EB878C8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id C2F4140011
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dzharug1;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL216fIv4vvT2FQ3lahp26Y5N739lhMmfF6ZddEZbhg=;
	b=xtkx52AXBPOjE906pfdYdmo31RWHROby/dCfd9zuJT0mhWSuASVi9KDba5A+gGYp99VuCg
	g52ipk+5RowjAKJka1a4Y0Tsw36kMlhmW+mqMsDmPzD9Ha5bm3WbMRd/onWvvjqh9cLVd6
	8eE7ziEG6gL8Vedx4/zn9nCmRVsWzVQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dzharug1;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995275;
	b=ZFgT+dDYETsV8SfbXwPbtZOg2vsQVvMG3m2S3R3GLheHoEC8sXbxOkq5yEFLtg/iJq2M+K
	pO9/xnSwQ7QvoGRDIHUty+3zfdHA2WpHEHmcv3fBlu+dI9gRZQzE3phDSJls1eqc3gRrc3
	GIMoZVjvrBb5ax5n0WTzEo9tVPjNV0E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=lL216fIv4vvT2FQ3lahp26Y5N739lhMmfF6ZddEZbhg=; b=dzharug1kLXjsR91cwzRQjJUW5
	ratPyA1u2jsc9HZceRqkjrtdDr7Z6nFWM3iOjjPAX1QWXAHJHnarIx6vW0lM3pxcl46OyI4c10WM9
	IjmjkMeyZEKWvjRMcRwIiTt9FxgRdZ92JUXLv9qj8hq1Pc6EzwKGqDkD7MCcC4wbUvKz/W/LDahqy
	w8QC6ernQsbCPTF6bh17lqOvJ/XPOujcmsZtB0nPE7Fz/8egqGE8VnOKTlKmhapDbJRzUddTmWyTh
	Vbr8j8xEJYrCDrAQWFGDejomCnp1MBULKp7d6NHuycY4xfscxCVVbiFwtajKfctaF6sDW6x2j+FOC
	WVFRrZgw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnenr-00000006X7U-2gIF;
	Sat, 25 Jul 2026 16:00:43 +0000
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
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 03/12] hugetlb: Mark some function arguments as const
Date: Sat, 25 Jul 2026 17:00:31 +0100
Message-ID: <20260725160042.1557264-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C2F4140011
X-Rspamd-Server: rspam01
X-Stat-Signature: 9u5pspeift313u7hxos1dp158y13mft7
X-HE-Tag: 1784995275-706168
X-HE-Meta: U2FsdGVkX19oiPj/lxScKkWC87pAj/FXWtHF3ZkpEiFe85ZQ/cU/iGjc4i7YtT1ur5HdGSRXHZdAxtqKrgKI7VXPEt9J17mxwg6E7fU3FjiPMDDYEC3NftEQbGOYRMjIzzZXkjgfBc3nYAIIbVHsYZM4EWKco7LCYgvB0tcHAQzJjmjrbCTfq124ccVt1CRotibVuDp/gwUY8y1p7BqWW0RfgnluDxhfrkVCwr7tRIyAMyR7JcbDl9mT02caNAfY1hombi3jJh2jw2XWy4tTGS9mdKoVY0cHnXG83VONcs59rgKGY3TjoarM0luA6lvrGLf1GW1RQp5mRgIrytrbcjn5qbLzoXM5z0aZ1c1HgfUjY+skD6Ildm/6wHWk9h5nhXwSpPFY+wBtQpmQqrVh/z0UmgEwQOLIji5BHuZ6cBOtA+zsWFJ1XGxx+YezzH5SSw9qqh9kZpu9O2CapNWqP1XUKvDlgxsn2SLO/d6KFu3e7yZneKwi3uOh4DRsOeMLy65GKlASXOxHqAdZ51+b52y2mccP2syoOPXhfda1Ml8Z8/oMXVz8cYlq76Ya7GYNBtryK1li0Z8F5ck4hj4xTwI/E2Pvq59GLP+ywni42hN+7lcouq2wUP2Y4ywwrGzoxgw6B9qRyRSdKi+Uk/QqkLE7Dq7k8hF617vdW1yv8A9Z9RBzZcFV9fXDPqF1TT5Yv838/CjRfg2/A5VfIFs83G+E/tJJhYOfrvZOd6zTEWwcvhttvXpiqrDdlNgZzlPOb8pZr+Ku6RYBDzf4XIaDI8OqYQTNa2gPfS38AbDGP5YrFmHFoT/lIIrYkhoF3md4eVf0dMX1TTSwjsWXvi81uVdnVl+tfgGNxlBb8mpfNjREUa2YpzkvdvThk4Pg/Snl/WZsZRxpFS6B68CJsUTtjtEOGjk0Za7w2h0Q4PpzBn++pYVxbIbM6MvkkJYObM6pRIB0JeutMOklVaAxCwD
 5F33axbJ
 GuIpUDGA8L7uXTHqvn5VVPq653kaENY48ebcuQrOBnK1qTyIlRExArVtKrN4OsUU1LuOyE8qpiQTFvRNgQuWNgpciGTb0Skt71MYJY5431H5x969+/m536JNWNEmyBHJuh7ZYMq1MydAKpb3KtBhLvxQt4shVWIqnCijgTIsFXuskR60ABHJuTT/YUlnDHvscGE6zltt+OogboKBAI61GnsYLkoxrEgark4w7GJkWGilXo8jVgd/Bo57HopHESFlOf9ZudvKgVIEVd6kjsZpG47E+ty9uVQp1qvzKIKOu3aM6a35ngnrgGOH+46EFPdgOZCVfwE4TeTg9f8s=
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
---
 include/linux/hugetlb.h | 19 +++++++++----------
 mm/hugetlb.c            |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e9..18661a7cdb37 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -165,7 +165,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 				 struct vm_area_struct *vma,
 				 unsigned long address);
 
-struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
+struct address_space *hugetlb_folio_mapping_lock_write(const struct folio *folio);
 
 extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
@@ -292,8 +292,7 @@ static inline unsigned long hugetlb_total_pages(void)
 	return 0;
 }
 
-static inline struct address_space *hugetlb_folio_mapping_lock_write(
-							struct folio *folio)
+static inline struct address_space *hugetlb_folio_mapping_lock_write(const struct folio *folio)
 {
 	return NULL;
 }
@@ -595,8 +594,8 @@ enum hugetlb_page_flags {
 #ifdef CONFIG_HUGETLB_PAGE
 #define TESTHPAGEFLAG(uname, flname)				\
 static __always_inline						\
-bool folio_test_hugetlb_##flname(struct folio *folio)		\
-	{	void *private = &folio->private;		\
+bool folio_test_hugetlb_##flname(const struct folio *folio)	\
+	{	const void *private = &folio->private;		\
 		return test_bit(HPG_##flname, private);		\
 	}
 
@@ -616,7 +615,7 @@ void folio_clear_hugetlb_##flname(struct folio *folio)		\
 #else
 #define TESTHPAGEFLAG(uname, flname)				\
 static inline bool						\
-folio_test_hugetlb_##flname(struct folio *folio)		\
+folio_test_hugetlb_##flname(const struct folio *folio)		\
 	{ return 0; }
 
 #define SETHPAGEFLAG(uname, flname)				\
@@ -727,7 +726,7 @@ static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
 	return HUGETLBFS_SB(inode->i_sb)->spool;
 }
 
-static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
+static inline struct hugepage_subpool *hugetlb_folio_subpool(const struct folio *folio)
 {
 	return folio->_hugetlb_subpool;
 }
@@ -857,7 +856,7 @@ static inline bool arch_has_huge_bootmem_alloc(void)
 }
 #endif
 
-static inline struct hstate *folio_hstate(struct folio *folio)
+static inline struct hstate *folio_hstate(const struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 	return size_to_hstate(folio_size(folio));
@@ -1088,7 +1087,7 @@ static inline unsigned long huge_page_mask_align(struct file *file)
 	return 0;
 }
 
-static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
+static inline struct hugepage_subpool *hugetlb_folio_subpool(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1157,7 +1156,7 @@ static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
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



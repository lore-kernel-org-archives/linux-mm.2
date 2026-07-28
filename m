Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A132C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5776B00AA; Tue, 28 Jul 2026 16:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EC36B00AB; Tue, 28 Jul 2026 16:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D686B00AC; Tue, 28 Jul 2026 16:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 717B86B00AA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1467C80512
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:32 +0000 (UTC)
X-FDA: 85039363584.28.DAC9464
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id D7064100006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Zzwir8qa;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FUQLu4weq3fV0V0JIC3lW/QzSoH6SgOF5JyW6Zg6wc=;
	b=l1eXrM0Dovk6WJui+hBPIfO0qmZAulXiesigyyf9Zd2ykpWys+NvWXJrQ67KxzbDpCDF9h
	E06K6lfPiCrVZDX9+uesdoMeCYc8Y431ieNa8M/G/the6ZI5SDqlZmR++AR0EHAXB4Avqf
	md7kA2T91ig0WsPS0H1dyGLVg0+gm+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271470;
	b=loSAShnXPfoJje66Bj7eVu9gwCbHQr5xOfsHhYCiMlWNPdDzQKP3yYOY38oSN3vV60vkhH
	jMUQ0r0Om5YgHuuKayn7+0vN+zuWBRtVqC3Hrb3nOIrP8yMEUHIVon7dgZgbH7FfCONEc/
	clfc21CaCWaSK+Dlm40XnEzkSNDjQL8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Zzwir8qa;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=0FUQLu4weq3fV0V0JIC3lW/QzSoH6SgOF5JyW6Zg6wc=; b=Zzwir8qawGyvk2cNtHdO0WkCZe
	hy3mzOooXkYdR0qQqY+mR2wGWSgK5xQi90VJjSxvKSRh2B41AN2+Lf1OZKOGp48KC4ZViJINgf4Ye
	I/f8JW+N0reeOy2fmgqHuVKnr5STPXfqOEZP6kJ/AaBhrmzJeTtd9PiCiE7BYNNxOdwxUi/B6H/GZ
	RS9KbTLtefi1TWWgqITZvK8uICRc6FgF/GWPnscJkqGUfdiiHNxtDH/WAbWceOt4zgd1c6XXQ/NQw
	RQcRUxLoWOwvOrHwJ9T7RTCBUy4y71WFbLklxpQf5ziF7tdbaW2MZWBPjTPhy0fEHc27a5nVQssON
	vB6H25+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeo-0000000EFWU-42xY;
	Tue, 28 Jul 2026 20:44:10 +0000
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
Subject: [PATCH v7 03/13] hugetlb: Mark some function arguments as const
Date: Tue, 28 Jul 2026 21:43:55 +0100
Message-ID: <20260728204409.3396238-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4zx3gkw49wot7wt5fncfesodkkfnhtij
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7064100006
X-HE-Tag: 1785271469-32194
X-HE-Meta: U2FsdGVkX1+ib13qKtgW0UvJE1dXgFlFx2Xi2YOjts4iwVeJPS2dULtuVSamNafbtv7IXNBm6AU8tjWt1hF8GtVZz+m0hMa+uzP5HH+a4N9kWkw8jbgHWVIYXstJI4BfUb5rNpUHUBmkIVtoHDEUDl6UMPhho4ObgT548kQe/OiN0mQcXjpLAjmXN/b0s8cY0F0rqNNEhnT+CkJh41gyzv124jeRwrdGPmHo420EXHcluzQ5qn/Xg7ssRHo1LOuNjFfG5fjgcX5uvkG6kv2eXmUXR+dw5Nqyv88Kog0X3f6YDE9JQQMz42wQHT99w707213KMVvsIKmrqjY1woOBKm/JDxiUrQT/Nex/Qal1J12FcY7Wkgb985v78bRkaz5k/zxetDof+z0mH0leW45FmaRdzQtaFeR3WCdbZ52e2hqWwhGZigzk/ZcUktdLat+sb1mtccqcslugn6tC2i5REI4REvuFGUerUlPzysSD5AlYNtbQhGCHOF0v4hwe3Z48E4XbyshtWEEkR+m6kLCrYlh2jod52J7PzhMEf9qUdIEyF7IUlSuCnPA74mzSasnH4cBeI0GROGGYCSpoCHSMnfwwgf7RRDZBWgXQalPX/5yQP8rdSMmNUDtqRWGeah6plcab7UQpYcNqkIiUtIOEYrNZ6nIEYVhJ5ZuQ1Ft+vHugzsk6YqdCr6TBkBnbr+zEHXHPYIM1afozI+1j8/LHPy9pKS16+hfwkl66wG+f1HmpjMDgoof5bKek5Yza2XxqbdaFq99G527EvWHLeyZ8TW4L5Fma5T9MYniJQ9Fvvy8twtI1H4T/nvgMb21FHpj9TaidDM0TWQ1eVsE1NbU5VIDcKEM+YYn27w+V7HbLdAPvCi4c2Mx50R84oMctldlw3FxfAR9h7/QcXj8jFsaF7lnfoQ4Ve3slqvcqAEHlonItif3bC0gUmenwaqEEGb1q9DkzbSV3zvFEoE5yOsl
 OgTGeimu
 Pu63JrlINORv0VLhjyvHbOCaVgCdXdr6FbW5TLQ4ZTSFviV50mCSCsGxG9Ikw1RthwRUgaeaK739KlhGzXZ8WXXL1lYJ9MKq+kP+G0ipLXYc75mQP+WfOq4kifLCIid48VK5z8Bm29GQJinzeYziAPiIleW9Ic9TvMlv+f6DJh9TzU3S5vZkk7dC5E1h71jhGv+ATuwRupKjDafBhTEBp61Hh6JesivipKrtxBj9SF2FFm7fGETLh2K2DRdNz/TCYd+8o15xcX9nVz/Qp/FIQNlN2vUC07UhP2qLPXoYNVyw0PdAw/mv6aFYltbtD62L/G0H5AZVLD8Zj6edvnCH/zuC6Sd3CWdmKuHhvJTRkfE+vW2bFE8ORn2i6qua0RVZBpNN8EkOhANG5nYYE0K9RKYVlDWY1wbm3i8n/vX7IFpeqtVA=
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



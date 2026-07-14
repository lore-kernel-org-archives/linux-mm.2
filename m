Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3655AC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61B66B00D1; Tue, 14 Jul 2026 14:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D133D6B00D2; Tue, 14 Jul 2026 14:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9A46B00D3; Tue, 14 Jul 2026 14:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE8D6B00D1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:09:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F31F4140436
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:15 +0000 (UTC)
X-FDA: 84988169070.02.9278BB9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 597A2C000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="HXw/pLdY";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL216fIv4vvT2FQ3lahp26Y5N739lhMmfF6ZddEZbhg=;
	b=rHNSpzCKtr8Y7vhWqz18zM+8e8vEompR5c/ZYd4Yg+Dfoc+WaKDgLoGnmGJRguoGcMBrAa
	3LrnoBt3Kc5vhZbZOJjNt3NOLoQVC9JlsMZl71E6THnVEJ6B17MjO/5d8hip2kxhF+fYNl
	8av8yruXtv2D3MkpueuiVxCWzAhCehw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="HXw/pLdY";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052554;
	b=xawlpxp7aGJbluknoih15AfkaQ2ieoOKN7v++BXfr5eYxfl3JmADBx10MDcAihNIZdADOc
	fMLf9P8DHWUEUTCU/Ej6cevsanFnPhoy9fE+YrL5ST3lTJMtJrtl590U1RcyCac1kaeqzh
	EcutuM/l9439ylJDt1hc1uD0RprPdxQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=lL216fIv4vvT2FQ3lahp26Y5N739lhMmfF6ZddEZbhg=; b=HXw/pLdYjTp+AlmI8arZ9MGMwt
	BlLfk1k+5AWkCkR8zzomGFLKi7kHOzA8eBPeyKyY0OsVg+MzCm8quclLRphxEnnQeTR3xFeOT5M1m
	1ucZamplx10R+la9m1p7K3n6p1wYSOdc1TnTAnXnk9QW4PGMG6kIUJo0W/yph1NyICIYI0RvM0xZ/
	ROeQMVrA+ZdCz/O7aZZ91lt/1W+wdTaVnOwMd27OBrbUAkJpxCUUDXU3G406mwcjmXxXzfyIOBobt
	PKLp8LMJ7ZrrB/H0Ldsd6BcMdkz0EENuzXAGSPcPJq8Ob4pKz9pCtohXcwcoAsr2K6MaUFFip6yei
	L4QBMtBA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYg-0000000FegS-3K0q;
	Tue, 14 Jul 2026 18:08:42 +0000
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
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 2/9] hugetlb: Mark some function arguments as const
Date: Tue, 14 Jul 2026 19:08:32 +0100
Message-ID: <20260714180840.3731244-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7mk3kk8skcd79j7rbgp4kjrbqat46dnf
X-Rspamd-Queue-Id: 597A2C000D
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784052554-907059
X-HE-Meta: U2FsdGVkX1/hUA7T7Q6CTVH+vgH3hNXGnBDv4o2mV2D/NOHxgsb6p0vafTdbdYOVNsQkOmb/oVkumE6jVG++ChdvQoIArVJjcH5TL1XK/R40rCx8xWKFk1SDyfKlmRpIRAezU6FWfmYt3UZBpzA3SH80ClUgq56+2nUBV+ByOd/QdiJTFktuFnuturyXsszVPn+Vl3ET5Q/ccv85QZ2KRkKaaMYX7bONFLP4Y5vT+a5zT1fRPkP3j8Iyj/pE0tH6mIxTYpw97ulNVakrX9LaF1HFtoshtRHuIvIMPXhiH21KgAck0gavrpTSSJeCDOcUkVobTs0vlDLBR40BpQQ4XMbPxJvULYYK3kD/jkN3tsH64PVR7/KjOA+l/SaHes34svZdjRulmA6WiUb0RzzzIHoM77BD5G64FCTSCo3kGyE3BfQ3hGDGRZkMd9FwH9ObMlJGtZcCnVn0ewp7/TpjZYIvFeCCwu1mgXUqnerfmiyouqCnktSQwl7V2HuEIRk2Fmir6EUl9nVcfW2SMJp899WyQF5syZj5Sl0TBIbiSnXNn4nSM3zr3eg4/IR/cmzevimqRacv2jJb0vDzBK4V+YbXj1Zdepxu5294dReNVgCHT/Ek8y2F8JOEJarlO2RNcIkbE7A/lQTEP+aiPJCnfLXI4jWO4z0ApSN9qwvvuBar/F3mjEuxPhThzyFxPSjd1KT7sDz8ZRcr0xmmRUnUflZXNq8Mf2zBQBFs9o4HaPg3CewNbrvSjC+O7A86Fey5Q2wR/YpvfPe07HHKhCwQwdnNDIsIciAFJiziDR1vzkb2ZrQv/bFzewV/T1gBtiIQ7BlqzesiRrvo4gyy4h/GPmY/27vcnaztSAg2uFBDxG7PafTixI2FDbi82kYcBRnBZTqu7UxwbR6JRVikPZUECC7u9cetjJbtI10IUFvbmV6s4MEMGuczTcByKXNSYlnNl5yDosudYMlS/KlO9G4
 DYiqIoCe
 rhE5phOpbPviPmoZdSn4ADQVzX3IVwrZc49iQ9AwSLcZGfRiDlKHQ/nNmJP+M0kVoErYMDRitwyRp0eZ5Nzr38OchObfEUJimPLK5HA1NrBf6NZKGx2iWWYXpLX0O9N+nyOodI8YdRrmzwsMjKGLyTckDjDvUPfKisPv/z8D2272G2WcUg6QU4Il5SgaKc6WLnrZzmal8DQpdBzPOs6JKOy/kuYIY2CFd+uO9VwEbvvpf/+fynp/0rzB9dBlASrnOiPy3sishaStUT3U8QIzQkP6NnYbpHuwn+f9uoMWEts/wtCPl0Ae5vEQAwzAy/UZQliYMNOD5p3TwpE8=
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



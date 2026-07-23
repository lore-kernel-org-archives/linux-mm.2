Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C04EC531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5766B00A3; Thu, 23 Jul 2026 10:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475C16B00AA; Thu, 23 Jul 2026 10:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364636B00AB; Thu, 23 Jul 2026 10:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A94116B00A3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D22AC031C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:16 +0000 (UTC)
X-FDA: 85020278952.11.26158EC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53A7C20013
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nms5fz2N;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL216fIv4vvT2FQ3lahp26Y5N739lhMmfF6ZddEZbhg=;
	b=f2zrkdP1HOgGWLiQ1OR04HPwLnjctrAOR3HtHSm/NlQeUGUH3FXsv/+rU7MCqX4/cNMTo7
	xn+hE+hqsb5oSdqXXSQzgAgXMz9/gb/eNqZz8zj4Qv7w9qaCf2AojOmiAkB3OrRoiWkPOX
	xpNUQykfqg27nTORlvfgCXSI/kvArSI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nms5fz2N;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817074;
	b=y5O7yD2NnXo4HIo8Foda++6k3pAPvcYokjmq8agP4Er7BoHfnY1fmP/u6nfqrsnfTNeu6o
	Qtg+h2CGvF0l7RLJHBGTbC06R+ia4WdikEknDG7lsdzVrUVE1CddaRrAjk78Livp4N3SCY
	+o3DTM7OtPUbfnnLcmbhPcO41uWU/NQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=lL216fIv4vvT2FQ3lahp26Y5N739lhMmfF6ZddEZbhg=; b=nms5fz2NfDOxV/4tMhCFbx+MqB
	Z4jlCPZPcl9bhmIuzworAqljm0an8UGg9GTy9zN2QfhZ8teyu59RUI/yYGAW9U3Ajtpu+zl1+Iw0W
	v+yRZ9ezd6XKewJ8uAiTXOBrDC9SNP97CMQJ9QmdXSiFsgacgzST+FnZgVaMk4JxhAEse2Xaiatxh
	Gb+5SObAsAXF1/z32gLJE5/gNjGMLeX0YvfClB416e9yWHRjDxE7bOFFImxGwYrPw1vlodxYaBChD
	BoWJcdfJyB8tEaTIaEkib0UPDNrcPWO0creI8FuXCwrH+DSoBEcNSoZWQkKsH5HMgQHnQWgyeCy/I
	xSjE7pCQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRY-00000000jhv-3K3E;
	Thu, 23 Jul 2026 14:30:36 +0000
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
Subject: [PATCH v4 04/14] hugetlb: Mark some function arguments as const
Date: Thu, 23 Jul 2026 15:30:21 +0100
Message-ID: <20260723143034.175661-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 53A7C20013
X-Rspam-User: 
X-Stat-Signature: gpe9869nxpxrzs8kkzfts1jdsu69whg5
X-Rspamd-Server: rspam04
X-HE-Tag: 1784817074-622984
X-HE-Meta: U2FsdGVkX1+Z9YyHBVdJII/6Q1NTvDt9cWsRXcI3eAOTejIvlvLWcwiKiZWJk+HmsUJdegR7V89WEJD+7k2g+tFQ2AKFcfIC6MyX+X7Ftua72O7Z2QIqclrGg6YcIs7zG6cACME5jg+/ihnBBJgu33vsw6XETiat9RnjiNIEKV+zZIBrgLe4eM0ADkPpa1vQD2tVQAUKyH1yGeS61x6C1wWUnLJRVAQo/55RzZVcckvLfmNWQLLNI5UFA+x3bo89C/piIzwNpdYDAEMjDSaYV69FiDBGEuaLnviRXok5H1A2mjVf2hoKtQ2UidhrLyo4JVoQEO2kzvn0cF+1eyPb5ts9icwqjojfEBwe9gAnzuHOue7DSomz8oPLrtRXcexHt3HupvVNXDEBjvzMd9oQGqcn7k04/NhYX70eqiO8+Nm7zqD7LN/VeBqOoMheQ7RHoxdwKrfh9SkbA+geXKZJpqGA+OL3PnkkshHUHHV4API9tLWomREflx0ydYPSOa/O52A8yRuBiyZ0pRNcmSR3PBy/HCUokRNeuTraLKJAB5Sg+sLDQyHz1Wu9Rfy+SsI1JNNjMvIL15N2jH2uotsgiDve2b8FqCtcPris5V6VyozZjKkc4k68sBgQLB6bPc+1eTP24eEptRdXWLJVg679qraRYvhNq8uw69lLAZCpbe5FuZMuG8y2wgDN6oAlbGXgL0SqDjIHPOuJNaviQwM0AzaZxvh2RKe25Z/4g7vNoor99TChiSoC/Y7qCzBwyzKtnK6kn0TZodbLiw9cMXCWKUPR4TlqekZdTu4u8G5DK+k7o22X6iEaLrxs/RKYmV32/1aP122MfgeUS3wB0seTneDyWS++Wliw3osMNi5kMYNtCXUyVDWFNc+G2sTBN6qlflN1fXpS3bKkvvJOmbpQeqJ/gnL5UvzERiDBsRPKm9spkwkl7eujdxaMB3u3T47OBf9VwRdJuJsKLwlByAG
 5i43Uw09
 T82FvGmT0EgNMMwOhuF9GNZibcZcXCwqi8Cv/ruyCB1cYYELFg4fp1Evsk7sY1ajvI4jDmWD/PFxZo6jzNwht/fRGsAEsYM7CdC7qOmvjNI/mK9lFEDaK/Jd4VfwQjO+V50zP9jW+LUVwlFWatKQVq0i0YoL3fILKvNC7HcNe0Yd1X4XHu7rocFaw1b119F8V+byRMc+kCdGZCccXESbDwt+ueJy21Od0uAD4FymQsjnWAq3P894BRzbnFpe0I5Sp26r5QcX7SoOn8xc6QzgKSN5GUmH7ikF0BeSba3qo9eiwo3HAodIZRuzyZYtobufWgWNBE1VXwNmvuzE=
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



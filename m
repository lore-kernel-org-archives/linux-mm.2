Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D782C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2055B6B00A7; Mon, 27 Jul 2026 14:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F2F6B00A9; Mon, 27 Jul 2026 14:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CEA6B00AA; Mon, 27 Jul 2026 14:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2CC56B00A7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6756FA016B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:40 +0000 (UTC)
X-FDA: 85035354600.02.7EB2CC5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id D5C5220008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iAoWnhkk;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL216fIv4vvT2FQ3lahp26Y5N739lhMmfF6ZddEZbhg=;
	b=tp66ou9H89p471/QHkOwESg9bqB9bbXHMoef2j6D3k4gmB2yObjpOyBqf/bkafaNi5i3vk
	d8M7nrM1lKSgs7B2PI7fQG2Ug/VlFhPMkvWrBaW7gHXCcc3KrGufj7oxmXoSPbrx66Ga98
	xMA9Iuej5MU15yu4w7PtWRJSPvlXwIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176018;
	b=FAteYo9ABsJkY7D27Hwi9aIP8Y4z1YgyjGl3KXLaK9r8c6ep7f0ILSacIvpFLrGMJHMtQt
	MRlwI5scoU/4n0cNm79x4s2DbfVyMH0IjjlM4SWGJ3WXraRbC0h30iLdIsmMK9tcX6nJZv
	M1L48+GIbvghzCcs5uEoAcysiqUhYWk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iAoWnhkk;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=lL216fIv4vvT2FQ3lahp26Y5N739lhMmfF6ZddEZbhg=; b=iAoWnhkkF9RREe+Id92K+dJPOT
	5o7KHwxlhSwJ6Vq+JEoeuxqte49aTsi6qdPCPgG2UO3T7jXe4w59PZA5QfMb7dgq7PrYJBzT+bZey
	N8u68K+tVSdiSdxfKm2fEsnk+8N+oHJlAzE9h4qlSJ75+un+cA8Bk5CztFJUuWwd9GgAXm0MO1fKH
	+Wv7WZgqrRv3InbEoFrimADfyXgHVcDXzJIPvaxc8mIqpmEeoUbstnMaEBrFIPYVi8l/nMgQKPtSi
	15r2IV4HUSKB/oVolD/f7qJMhyz4zvhfzvzuVSIm2Av7AcfnJtxT/qrgxHOpp4XQlpN4iV0xtUXVm
	EyzOlSpw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpA-0000000BD7S-0Jdr;
	Mon, 27 Jul 2026 18:13:12 +0000
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
Subject: [PATCH v6 03/12] hugetlb: Mark some function arguments as const
Date: Mon, 27 Jul 2026 19:12:59 +0100
Message-ID: <20260727181310.2671972-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5C5220008
X-Stat-Signature: qf73tbr7q5yuxqbh8cg3j44ehhqwe6ym
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785176018-658839
X-HE-Meta: U2FsdGVkX1+2+mnv6gRRVd/2FubpU3SWSzLIVImDpBKJk/bR4e/gtDYx572daBZK6pu0kzvXSLRQJDt6LlNdO1zVwDr7LuTQpQuI1Ma4E92Bt9NHghRGtnCNP/oklXYz8GrMTg970rKsmzS6lt3o7ayMpZkkUaJdA9d+vYyPIOHJgie8n7BUjsRXuMGosAeyfePDX1BA0zj6glBUT584vcI/8VLdiIZB94yFSynO/4OBSWUzPqtbWJWHHk51T6xFR2Nbpj9ALeLxItArNiYm5rngo/hs/TbQ8wKQ4z8+4wzHe3HMCheHRATgrWw0sodaXdczDncoxL1eIAwduJLZYF3oC370aZbDxnz1XBurKb675w0PLnulzHCmiXEXM4xf3WcBFRCIM7SnwMmyGtSvOw3xKTCPo7uvQbVqNV0XCKlANcHmd5tnF9V6sx1noZTfThLJuY9DRUtcAe8ar8yYQls4lzEHPTS2rYDzxaLSqMjQnDx8UH1mFYBwYlteT6cMY75itFtDtnPij1ieDo4cAy+VI4RD02eBMznvPe2gQ2Y2yTVAlYnebuac9pcK8LjikpWt7BuZ03DkC4oBVKiwImLj6JRxNbBrC/5zMfsZCTSNc7c3PxnGiaiYyfV0vKBrhUmUfR2dmu4lyRkXwATQjCbh8uIlsqcwjaHoOr7J99VzFVUwNcG0DKYsar144ZlLdEOM2sHq5bNKJoCEf4zvNEw7TMbdf65qbhuHCD0h+2/uLHOfhvXlOQ0gR4gt+PsxymWZzumzK2Y981z/pEiJG0ueMtwaIUSkLx1kva3PJRgJEguOCwMx2WG8Inx1q4+heV+cPYTnaDHpC9N4mjSn7qJo/oP2rJUjDVDqiwSrvHBN/fB1bZUiQ+e/l0kzLu5t2Nhvi6VniedIjHbQGzASLfKrVOg4sdDZ/F5iOY2LEknhlwC8xyeLYm+6aJAn9f0A/IZmV1HXmWt1QJ0fPci
 YgzBBOu8
 Juj54TFjwd4g/wfPmr/+oAdIGEUc0XHJ5Mj0c8FKM3iKM6Wa0wuAFu1N9LDqoLp0bM5kXiyaAQQSL36osceHPt8EDhRad2252uIun5Mi6/KtaumfNEuK+M/kUrBl5tIa/Tv4ORUktNnTqaGUzhOiBgRHVb18xYEAHaz6HQI5H/1kwypXq4H47V71j3quo//uthRPCqjJatu3uHC1svPzXrQR/DQy20MqRp2+nbLJZg7kBSOTtY/TDwy3yCoSagMAmJyYj2Rg0s61Wq0OPNC08SIxeFR9FXO3M0BprILlfmaJd1oNhbdoEvAdAOwbekeD1UFnz/GkwGPTSmCc=
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



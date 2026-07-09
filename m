Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 798D7C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D1B6B0095; Thu,  9 Jul 2026 14:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14FA6B0096; Thu,  9 Jul 2026 14:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04466B0099; Thu,  9 Jul 2026 14:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B84D76B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:47:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E203C0A9E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:49 +0000 (UTC)
X-FDA: 84970122258.21.3E4F1C7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4CE95160012
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OD2cPwhr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGzsdh6wPoQgMw5cd9uKBeGzgmNURZq8GSz/ptEy9mA=;
	b=kaZSdBoDZH692UWEDTdZYNx5ssd6Gx0DJH1Abd8EhfOU57zNrUzNg7ZAqKZRFacjG1qPvw
	B8w96XisvzN47aK4Id+/zlXZNi6vhSH+CYajBynQAUDQmdza20jJ8qTjxFaI9ALSNCcFq6
	zH2p8RjgNWJukilikkgwrkFrt2vk4Ek=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OD2cPwhr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622867;
	b=PxEfs0/4Y3nCL+T9vUNaH2D0uj9I2l16c2xX9LCOGEOWOHtMNidnMO5rGNV0kLu6bcSn0g
	+C6ufdkNQ5jPCetfBzOb6pafbVSBHoqswa4eyrgb/n/ef3K3Nw3x3k/xmjeBTYM2jvjpyb
	rsgdYjzAMKQAoCeRZ564G5PAF6qFFAU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=WGzsdh6wPoQgMw5cd9uKBeGzgmNURZq8GSz/ptEy9mA=; b=OD2cPwhraNaHSAcICzvZE/QgCi
	yGiOlNuWxYJD9mNrLOs+HiMuuN6JTVX+CXKAwS8kyGsrW4q6nu3TK5i0a87qN9ReAGs/UvrtuTgF1
	I4T942+DTI5t2SvTydflGQ8tkE3zVkwR1uQHjLi5UQYOGsMLDCM9/ZS+SBrlMzeI2V9ri+s7JjdYy
	Jql0ORX0UuADYovrmTImGYnlOULrMYVGjvlVtsLh/eeolR9pvPrA2H2fVMCWT8jz5uXDbAOZxrAcB
	4uV2gO30SSa8vNYFWLlfj/7brK86BAm/qoxs8yR43vzw386P1AKRpL2qhGNo3xSPEJ+/vcGXWbmcK
	dlBKzKXw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmg-00000005OhD-1lcP;
	Thu, 09 Jul 2026 18:47:42 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 02/10] hugetlb: Mark some function arguments as const
Date: Thu,  9 Jul 2026 19:47:30 +0100
Message-ID: <20260709184740.1286561-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4CE95160012
X-Stat-Signature: rmjis1rnf8cjoox44xnjjas3ikbiants
X-Rspam-User: 
X-HE-Tag: 1783622866-68483
X-HE-Meta: U2FsdGVkX1+3vvpVWznSKOs+b7aExWVdPQhwpnmflvSrIsGvQ3FGNqyLKmvDulnUdoKeeUich4t80aN33sXZMu5gL+W/J5tEteVE6h/x42Ieo7rTEu/VTOQS4AH5w8tFtVu1K5DxzRbgfI7pO+5rMPiCgFJMjEFDAg2FA605EaymRbrHVjSaI9L+UwTaBNCivPReMWIHYGH9nlViQ0qoq7VHGFBSOUJeGXqWkSj7ZdwiUe4Nzf3Nk8VCDPJbDB88Wvi3Abo9SE95PeyLLsf5l+vlQG/6nebvhLggpG3bK9jb57/j3hX1QmvPTtFeW5V/K3XxSk3/DD3ARyL2c/uPdFNaoiroUVLqbitn4NWbf6knIDSQDDzKZPoOIThHSBXbDHuH3xjZ5rdrB/dkZXb27kNxnEY0Bkk+R9d21R4yiirutX57Yu++QDsIRrlRBO9r8lFi2RN1G4myLV2AkXdTaLGe+7XHw3LqtfbfM2RCw/5AfjK2m27okvM9jgvoD9xKNSWM++sJxMaNnx7rWWNiAK6y5fVXZW/cZ1n/uP3p1Tzt9T9HEbvZdzy4z5pwV5Cir+UvCnyaZS0DQM8eLADw0jhlcqMDjKmHHO4imVfRFfUCNDKeJ11Jck+UgQfxIiTBmOvplbNG3ufMHc+ecupkAu2FO99hZsBVBFxSl/r8jrasC51Qc34y+ek9NN8EYaArNrNjpK2+MXL3mNjSKtcV6D+7lbLp+QuzqBnZPEKlWTrXZ45lvowdU7oyU0wYM7/XXtZj2VpIlPw891yF+7RgHyfkuICHgq8IKcB77VRw/IuUkhQSuftNV+GeMGnj8CcfebE3mC06YGAe6BQhCAc2pHg4NAkQ/iIdL9wtPjdtDqTRkRRiiSeso9EeMLfRkm9fsijy3hNiABpJQCjA56eUffRSHhV7Jaj/vvBB+yiDJMuDuqb+Ilz7WNCLWNyj6XWmQYMXneK8WlEDSLs9Mt4
 YTJt0bj4
 AXIjq8A7baWfOa3BpQ6o1/lxcbKy6yjWZrDBkZpIeyMOd2RHozHzUuwIziY2TYEnHRue1XS51nPfMU1sIB8S9XJVHTe7k+KFOwSIUTCEghwg3bOCe/O4FpgUfBJqLpy+xl1MrxSNPglsayptrkmVHk6JMQktY/Fh2YbNAMUiZy7VDy3eLeNI9PtblhPsNvdfiQDCVvQMqEjNbbSOOQwFfRSdhoY06rO4WF4DAf8MNchPEQ0PE/CiXE0YD4DU/4TGuU2fczJsbwibmwAc9ZCiG8gW6f0HRJ6+fTNfYJGPWWA0EhVpo6fEHHKpFMfJTW5AYy8KjE9xdAFsJIqaFfImdjoOk0pxrMzwTfA1238dj5V8pSWA=
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



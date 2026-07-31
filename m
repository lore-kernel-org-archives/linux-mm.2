Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FDDC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913556B009B; Fri, 31 Jul 2026 16:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875386B009D; Fri, 31 Jul 2026 16:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2F76B009E; Fri, 31 Jul 2026 16:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 546C36B009B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56CB280150
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:16 +0000 (UTC)
X-FDA: 85050158592.10.C86E4BD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id CED0A10000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v9Rd9esF;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCsINWgR/sLHMztmR7oqLBuFdownCBpUvKqPC33EfA4=;
	b=pHafIeIu7LHGS/mSPicI+AOgppzSMG4AYU8PTuP/smit6xdFZlhqr1vQ9UgRzrekpE2CKT
	pdYzDaZ/mWMOwQwTDC54uUT9TO5rK3BHLEEUJxXFmw+C18ARpOYlPcEhtU3vsHuwL4XojZ
	G5Na/hd+b7qM8jRtgcqMRPR5N/H9m9k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v9Rd9esF;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528494;
	b=fqnxKYTrEXnSGdRlhh4DI75mSAz4EvcRHO5ZLwFFOYGzt9WnP3pQQxORALvd2Z/kLSkr1Z
	vZxCxIiL2PQrqE8+LIlKZI5lR0a3PpfQGcp+H14rm8uZYtBLqhzWUt+X8V5RYhrGmFQBMv
	WzcWwYntTmkqjM63FFRHlLxvzlGhP8U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=BCsINWgR/sLHMztmR7oqLBuFdownCBpUvKqPC33EfA4=; b=v9Rd9esF5j7rF7lYwdR0jpBrdc
	SfB8cFx53mZDx5AznEFYfHxedw4a7e9lgnp/FLjFrof7YKh4jczzIox/qXdXPKgC+bId7zOs9ccJJ
	DZD+UCk2vwyuEr5k2BBdukp7YdMfRkKBypfAInQJ4EN8bZFKXs6un9ON38S554HzbahaxbRDP9FkJ
	pUlUs7S7ffzRX2vH3wdJ1zwptCph02Pf1ec3kiQ63RoF+H6sjNpw8f/VvkUqARa85XeBJjhD1wXWh
	ewaVnmjjSuIEm6r/iXLZPxx7QkA+U6seBXu7GW6aiqXa5L0KUF/12y37ThhzOIu76FlcVsfbl+rqD
	PrMvYnsQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWW-00000002Phy-20Ne;
	Fri, 31 Jul 2026 20:08:04 +0000
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
Subject: [PATCH v8 04/15] hugetlb: Mark some function arguments as const
Date: Fri, 31 Jul 2026 21:07:49 +0100
Message-ID: <20260731200802.574821-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CED0A10000A
X-Stat-Signature: 8f3ymmqrmjdepd3ugxwza4y3rna5ya87
X-HE-Tag: 1785528494-356261
X-HE-Meta: U2FsdGVkX19RfKhyil25QZWU/1sINhyFfHA6beL+qLKJFQIRRqk6UmLxpD5ysYKR7rMR1MbFXTuW8rzfMnfszsDx/beho6XxHznFnKAkP7rRxojZMlCveQ9KYf+vPqDCvAFe6D7AnhTLgvbw1Zsh0+8N2+lJu298I8UEqZZY12FJid7ZzgjpjH0EB0FPjNBz3r8q2uF/2m7TZ1Zpr8puP8AGqU+V8xb/dxZb2X+OaVJ3tnl4oS0tCgRAEg/c6PEVf7W2r5WEwdjSpgbQKB4C+NwhT56sbGy7bSwhEk85ODxv7ZpVdW2lznzmmGJdL8HkRa61SJmGMDpVSnJE65WrMSBXmUkYhzdbPpea9DSh2NPCRCS91Cm/OV/uQIbaQzmu96Nk3rfOLVy+41gk26SIVqRGzTl/uU0Qjo0qmDejRPPNNhf5TkSDCu5uCnF/xZvDZm28ErW6H+u/+JY7By+wb42E8wA5JQrASimlfRzQunEWW+P/eXDNxem6kzaaRKQtmyiZrT6w8hNGHTl43pSQT0BYF8lJDJerZri7grfDLCzFbXocXTC2C6JgDHXVcw0qtvhzWA7j6cqBplv3kFzUNXj2Eoz5NcJ5xj/w5Bw/NdEe9VduttO/IDrOBSvWOa/ZmhHUOn5SjwWba84RhwVrTBnJa8NJJQhs46PWuvp3D08b0XdTpfY2whPs7cbgMthLyBQnZaBUJH/i4ASqJCa6/lZRqFxMBgtl1zyb+S5N2DO2t2B4WXgG/cDb+7HE9GQXhjzSciFFVQ81rGT0rPheV7Q0lwaGjmwbT1YF7G9SDAI8wIwbMA8EjoQ/J8xOFglgf4haXfXwun9iWDGSZ1mYYQPOnUJFTXI4qHbpMlGbwIph5U4aCJ49Tqfam3iEFa5T8ntKdzag5nH1i7NBWFxdmvo+el7aLrdFYEr0kn7+MFSYdOOlOVBAEp8wPW+0pv/1DH4XftVlAn6luSwB1ov
 FxZMWFWW
 62MGYJoMWSYAG9CqbGZEsYDNkzl50IE2aCV9j31I8lYOxDnK5njVz/Sh97kIpzcBD4oPoGual2R8V5ah0k6eS1e356BjCc01rBtkOmPprPRUvr5/SMKy40vRrDAimyjo9j1c9CgxRh48U3s8gU9jm6zb6r+h5wbDsWms/HXmSrkVEK6pUD3pypb/sAJp4mVm6EmHbdVQ4J7uvfvNWWnFHixatXH49KlNQ8/s9nmLvnPKYWSWuPomtl258cSKBwmYeCEUcnDmRjkEjKD54hin40xXy5pk9gM26G9PhAgc+I+xSiSHwcuRoiObxxjuTot4FY6+OngWT1siJRV4Von9MEi+Jd5FFALb/R3mlWu1dIzXT+VEyXx34S7SFtk4RFHV2W+jpP24JoEo9aRIs8018Vva5ePBg9xybC7Fh
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



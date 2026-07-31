Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5749EC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8BD6B00A5; Fri, 31 Jul 2026 16:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0EF6B00A6; Fri, 31 Jul 2026 16:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFB36B00A7; Fri, 31 Jul 2026 16:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB3A76B00A5
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E022C0147
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:32 +0000 (UTC)
X-FDA: 85050159264.30.6C4FC6A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id D2F40180008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=E4Uf1kaQ;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528510;
	b=voffdWfzh8soEU+bGz0G9rUq9+oEAylvwgjG3PxaZFcumcrK80OJPQxs84pdk5QI8NNCdO
	QVKcjnWQjc9GY8kSa/wINZT2mz072V/LudJtnRYwHHuv6eqNi9FSbv751UmXbrnMu4dEgW
	tKj7Ml8Wk+TejiavCDHmmCkfusckJkU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=E4Uf1kaQ;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjbXQn4QoiTxZl+Huwpo/nxjyN7q9xkXNbPJMZ+/N3k=;
	b=vb7BgHAXmaS4+SHXyR+5gl7S29Vfm92/KO51bp38p2uhUwUddikqn9o7dVjf3WHW6rJOI7
	AB3P9xjKdqsVZ6jjfsZM8CLjiGKeUwcOs7s5nJ/wBK39RZeHqkeK5Qv+4Op4azxCgE3UpQ
	X0IRckW8vN+CrB8EPlNdKg7D8Ajrl6M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=rjbXQn4QoiTxZl+Huwpo/nxjyN7q9xkXNbPJMZ+/N3k=; b=E4Uf1kaQ2OIfH2iLIcLjfYADbC
	u8bDC/1Y8Gk2aT5Bi5SEpm4LjW1k6HRVKbPoaO+xA2RD+7Dim8ADOBeHCO4WT8nfo2Bl5oUOO4TV5
	lIy6E4EDYJdeh0zflZ7z0Fom6Ok3mk5+hgsy+thDlWvY1Z5NKRxzgk6WHuEQkBxvvzT6PPkOdkz4I
	M9ITZNihaWcFG5o0a0BIH/gfxJRxzzf/EKzXVTm3D5sgNLXqj07OzPc487jul1d7W4OfgO0sl0GaZ
	/ZDomjKv/x8j85W9TQgFHKRD4Zjc80ukj/ZVlBjrT4ZVqGZHiyZWOWt+niIvkikP09/GZYCIuHdR8
	14K/tE7g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWX-00000002PnU-1lBH;
	Fri, 31 Jul 2026 20:08:05 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 11/15] filemap: Add hwpoison handling to filemap_read()
Date: Fri, 31 Jul 2026 21:07:56 +0100
Message-ID: <20260731200802.574821-12-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D2F40180008
X-Stat-Signature: 9ztahtayiidwye6nfgr1axjhtqpdh739
X-Rspam-User: 
X-HE-Tag: 1785528510-728377
X-HE-Meta: U2FsdGVkX19jzaBr0ELCZlDn8a1XNHCck/JTkzltQ6LVfZMC9lWxXPY4cvfo3U+ncconVGWmeKlgG5mGQSzDsUP4N5W8IVfp4WL3sDdjfQ/HRwFP8V24hIuK2faO6C/FGqifDhRoCtY63AwdWDyTprUqp2OpZ3NtuncDiaFoqHlhwRSFcVnBJ8g7NHcBJ8akZh7dJbXWyBIOfnlEyjXZmeU/yez443hh0zz4rYzXP8AfOdAXpz0uGLZvwSEj4X+ZVeLFFIjHroKsNKSO+7cYX+2f+0Bxl6COW0mxd+2ssNN8wkMNO7ENbXsi+ZtaEpb9g+IzK3vrU0a1MBR79AtqK/SDw9x8SpfHBb7KdP+k61BtQOzG09/eoR/xSAzuli2wBnPmEZ/w/tWec8kbC7fbfS7v3BUnnFtlXogo7cm0XuOxdHhEx46yBLxHAjlsvvlgDDU52wm7UByP8Z+cqzfBxOGs1+8haw5sHb1kj5CeEBhcdjtVkK4W1Ju+kzufzhxaPyXSPGZ3EkQBT5Jej6EtfSDcthyc8YBe+YvpQ7VZfzmtaYz3Pg+7K24XBWm2ybmQFd915Q38BlhcC7cY/F/iYRXaS2n2TypqIZZatiF0I2zhqZeQawUqRHaxwgNMdVM5veQCiQy2QooHYkpsGCRwVSYrmhd9o9OoVAieK1lNDPDcnvjncXoquXSddE6w7APMD7pdbGbVjKSzZ2wuDng/HMTeLzlAotFkx5yueFdpb7g2W2XEs/rssb7XpQJkLYNX8mXA0P+FxKxYxaGxjjJG32HfvS6YGpQhanW9tok6Cs/abhRmmtgUJuuctHXUzrEpH+/+2j3JFlLzl6VlkWO+nX8SVF48FwBz9uJaeIzmp55I8w++PxuaTc1o7WDwSlegZp2V6WSKXaSBU9s8UXZeNBS1xa05tQE90fF3PA286fwWZP4gFJURrXx1txIfeqxmdhl00nnvGfdA1mZC9o+
 zZnyvaDC
 DxwPJLGWPfMaHMKUQcIoexQ1PDBqHNlNLZmxgojV0ExqlO2jtyYKqL8rjnsOtYa4lN68zPCFqGxet1KrMO3X5X4zX1Qp5XHYF5YBloHu9WgM5lcWRCqbY5PDb4E3PMKKJIZ1bEjMmvRomo8PYXO0X+4oqS9ipA/KS0wbFuZJUZ+ukL9Dx3IcQDyIvdBstatDgVNCOTaetadW4bneUZ4gnwmzPzkMSy/xQDJRATwGGC7PC1ZMSbvWCt3gLZPKSfRrHX+X3UxXBD18Z3t2pT2k1atbCHPMXViW+Hp/2wCqBq84nKhrxs5LB7Pt1p/6AQSMaXpr/bnDyC8PmXcV3BCi5VbctG+lzV67c6rBE//j1PXb6UJppen3NlAsOozBqGlbwCHVq7FEDpuf510VN4VuWO7db6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jane Chu <jane.chu@oracle.com>

Add hwpoison handling to filemap_read() such that .read_iter() could
make best effort copying data out of clean pages without risking
MCE in case page cache contains HWpoison.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
Co-developed-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 include/linux/hugetlb.h    |  2 --
 include/linux/page-flags.h | 11 +++++++++++
 mm/filemap.c               | 33 +++++++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index ec604cee8d22..639c0a772856 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1088,8 +1088,6 @@ void hugetlb_register_node(struct node *node);
 void hugetlb_unregister_node(struct node *node);
 #endif
 
-bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
-
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
 	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index ee026ba9b0b5..07cc7854b2de 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1094,6 +1094,7 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
 bool hugetlb_unref_page_hwpoison(const struct page *page);
 
 /*
@@ -1115,6 +1116,16 @@ static inline bool is_page_hwpoison(const struct page *page)
 	return PageHWPoison(page);
 }
 
+static inline bool is_ref_page_hwpoison(const struct folio *folio,
+		const struct page *page)
+{
+	if (PageHWPoison(page))
+		return true;
+	if (folio_test_hugetlb(folio))
+		return hugetlb_page_hwpoison(folio, page);
+	return false;
+}
+
 static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
 	return PageHWPoison(&folio->page) ||
diff --git a/mm/filemap.c b/mm/filemap.c
index 58eb9d240643..26a5f18121f9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2483,6 +2483,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 
 		if (!folio_batch_add(fbatch, folio))
 			break;
+		if (folio_has_hwpoisoned_page(folio))
+			break;
 		if (!folio_test_uptodate(folio))
 			break;
 		if (folio_test_readahead(folio))
@@ -2749,6 +2751,29 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
 	return (pos1 >> shift == pos2 >> shift);
 }
 
+static size_t adjust_range_hwpoison(const struct folio *folio, size_t offset,
+		size_t bytes)
+{
+	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t safe_bytes;
+
+	if (!folio_has_hwpoisoned_page(folio))
+		return bytes;
+	if (is_ref_page_hwpoison(folio, page))
+		return 0;
+
+	/* Safe to read the remaining bytes in this page. */
+	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
+	page++;
+
+	/* Check each remaining page as long as we are not done yet. */
+	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
+		if (is_ref_page_hwpoison(folio, page))
+			break;
+
+	return min(safe_bytes, bytes);
+}
+
 static void filemap_end_dropbehind_read(struct folio *folio)
 {
 	if (!folio_test_dropbehind(folio))
@@ -2862,14 +2887,18 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			if (writably_mapped)
 				flush_dcache_folio(folio);
 
-			copied = copy_folio_to_iter(folio, offset, bytes, iter);
+			copied = adjust_range_hwpoison(folio, offset, bytes);
+			if (copied < bytes)
+				error = -EIO;
+			copied = copy_folio_to_iter(folio, offset, copied, iter);
 
 			already_read += copied;
 			iocb->ki_pos += copied;
 			last_pos = iocb->ki_pos;
 
 			if (copied < bytes) {
-				error = -EFAULT;
+				if (!error)
+					error = -EFAULT;
 				break;
 			}
 		}
-- 
2.47.3



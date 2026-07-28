Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAD7C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15EDC6B00AB; Tue, 28 Jul 2026 16:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136116B00AC; Tue, 28 Jul 2026 16:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0247A6B00AD; Tue, 28 Jul 2026 16:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF1716B00AB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67E654041F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:34 +0000 (UTC)
X-FDA: 85039363668.19.8E1E91A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id DEBAB140002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XezzPoDm;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPkMEYO9mjH/Ia6rRtWcuKRSGQrQUxUN5Ze4piyRhiI=;
	b=mOJlDnrZSax1MoLmGPu1AQt9sH7leON4C9OZTIG5V90oyjTtE9tBklwfyShT2cIGKTiC6V
	DsPdprJ5f/T8rqGNnCjobH+7Kfzhz6Ynrzap6dlBgaQrmOCJnL1TaVvnA0YaeHP1DdGYls
	XSWDXbd7QC64cCqbCbiopf4at0WlITM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271472;
	b=DfLOjULBvl9i/Agx8c45YOuKsnEWMvexwmk2vFHjazAcNQiIxi367EiA6jD+Lpu2HTXUWN
	0jOp+a5OuDD5WE7/KwfI33FZ7I+pMSKbaFR1mzBTRFoMVTVnAV5nDPZMX7tYWEH2Sit0Be
	gWqBq/LQHqkNolVnRAZjGknHb0Mx0zU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XezzPoDm;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xPkMEYO9mjH/Ia6rRtWcuKRSGQrQUxUN5Ze4piyRhiI=; b=XezzPoDm+9iAq/loN7TsqBgWTJ
	JOsPtROhdL/+DdTC4DoGeWreGorMDVigUg2KSGC04dZkLG0NAOfiKCgW9ehJSbGjSjtSrRGrG7icF
	PT2c8IyrhHMZHP0DwVaFVvaDXvNh84HIs7R+pcFLBfTHWOBaXVTODR31EMpBriqbVP+q6YoxqjjrG
	DJ2vD7+qAGB+YM/JCUiBTJhgcI02+eb5r+1pO9g5M1ZyGLqsl45SaMvlC3WrnF67SpPTnWAycRlUB
	mr9h8HAUJECfxGmJjqp+BRyEYSOm9KHTyXQs/IqvHYelsi5xs+1+psaZI66eQvikqm02eFr3HqkBP
	chd8UWhw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeq-0000000EFWr-0BUg;
	Tue, 28 Jul 2026 20:44:12 +0000
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
Subject: [PATCH v7 09/13] filemap: Add hwpoison handling to filemap_read()
Date: Tue, 28 Jul 2026 21:44:01 +0100
Message-ID: <20260728204409.3396238-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DEBAB140002
X-Stat-Signature: ck834fnbhoh39a3y7fwo6cjmbknxmtk6
X-Rspam-User: 
X-HE-Tag: 1785271472-758849
X-HE-Meta: U2FsdGVkX19ZvfgkRL3ACTm0xgn2r0zhenmv9lFeVsZW3Ze7IysHSsSmKWmi+VyAhQKSKbkl/ntwn2L3UP4YPjoGLhg4FidtQrqNAbTIbwhub19PSNKSXZJjReRROunbO6gprWh3SKziig03Wtx37yHaaTep0jkGbDTIiRJtJcK8rfO0982O40rgHyAppNMp2ecEGC+jE/oQR4HMEwIODDL97aYBspATlO4AeCl2GXTJG3e4KMEARkOubQP7Jyy8y3wKO47xZjLQQ295GRvfkb6m6CUwiLGmssqoalvQ4z7v56V8Xz228YWZrdeuYzuYAaVDfgl2kX8dyi7D6zRJ1dx6gfTcho6a2DFuBp97gPFKhxZ23mk/lbhfB5QK4JE4HIy5TSb7yxoXcrQQnVMFzNq2PROGGs8ErTJdC/qyS8+60cP/ucvWELb3+XbQ77swmfeVZVW/ZK78BIVZFkt6s1+wyLGjFncwt/DRus1uMNLT9lYjo2i3Ea9FWJqzfhPK992b4ukzhbewJ4yjgVxWDDfF400BHrc9ykB6z5AKZjelAxtbAeJahDCKhYzJqtMp7OKBBwQgLjuRYCY1WwiCstjzwYIG/FN0Q8+tTEtsB78TI7FjNHFFFX5MKUCq3BuPI5BJ2UsU66vgUEb1crC8ORyJGtH2wmHdWcGHSy9ijc8HvKjluPGVdcZ7Q0CRiP+diijxdhkrgBUMLooSzj2Xs3nB3/gi2JqcznY1wEzYn5py0Di/fiMPzQixuJ0QvrBmJ5878Iml7nZIjVkIKwMfPgWc/rTRpQFZlQSgyQG7XLluamMkhZxxufFEw284fpYzR0ubTvokTmA1Fb1aekUPJKfCSLZzAAMmH/Yi9DBd9aGdF1GlW+77wMShftgXnrpUvTuInyF5J/XMbcd/7zTXcNYf591huQJiAOk88Ro+1YLN0+iRP61vu+CFglrlJHddAwD8AsSRAefDhTmWMBz
 WL2QlUj6
 iLeA4XTo6o2g951H5Ggn34ViXj/lWEkvRo96sRL3ePideB8xdp0Ruk6nBQM4u1BI0zKIxa8bu5+g9Qt3CopB3u3iSmgggy9M4G9IWgxj8trxpQz1URE1CiR9IW3ZPrKSeZrSKAyNvne1OZXwKyWBq6KMRx9W7Isz0RMJjJT//zcVAGdPVHJXdU9YOdxsAa7eRIQAF9rMTwmamWFsVD6A3hilAAQ4MDSSGMFYsLGVLGRj0NkGjb26c2Cv1hYyAK8gIGr/tmLVdaFRCpikxF4SmVqwPlwSO4vKTobyEFyL5aYhxV+sXk6rSJz+gaeLVSzYc4ChRL9wLvM2nA7Bp5+AjFFzxf7AW7xfiNa4qEFBJ34l5L5MPMnn3mQMOlySsGChhekHiufC0QN5/L6KphTIAUZHvkw==
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
index 325f0404a7eb..1878642e75ec 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1069,8 +1069,6 @@ void hugetlb_register_node(struct node *node);
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



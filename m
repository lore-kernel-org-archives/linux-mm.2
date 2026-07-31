Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7635AC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87DFF6B0092; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84DBE6B0098; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0276B0095; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32B636B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8ECD3A0547
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:09 +0000 (UTC)
X-FDA: 85050158298.27.D1D38C3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 16A6F2000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rigCgr1T;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=;
	b=2dIyMPaPhTooRK8fOjS8eOtfIy25UBU0EFm234f3bi1X9pPyoaWQtGalWrplRwtly4LoNv
	aJeDcpeLlPK8VSQasmzf8nuiagZkeuKAUWN7M/l0KmNW8lSWsxsK8HdaYRBNsfp0jJXDBb
	FI+GqtrVIq5WEWxKeh+jFih3kEBTl9M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rigCgr1T;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528488;
	b=T8dFqkCya/jRyEIBbI3zB0Abh3jmZqNplHzVemzl41d6v6zViiEe5eBAwp3wIHuWNISTgO
	a86y9uYsHLA0OsagOI9hkHjTmwa/ONh+5/sa37tpP9W4GtupIuPEhkfHa4PCWsV6qOLb0G
	vGIlSH9G6ybXENCPrGp7NF6ZEGUthOU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=; b=rigCgr1TjO8VCs/SyKgnCTN1CU
	HN+ySp+xxIrnX+IGBHw4RX6Q56nhMH7Qs+h1GiIljk348E7Avx314zkjDFemtx1cVlbI5wXQxELCt
	H91w6VPk81s6zo8F6NMxUkJw8CtGjzZgoF5eDVprzphkXYP5BB1jusfOCykL0vk1KNBQ5se44svMs
	0hrZWmGNh3/5p3GK/MGMf/HbMcQ3WZnxdh8F49HL4/lgO6VI6OeQeWaO2sGL7CmrIhKuvdizRQAlX
	pTFI2yD3EEGQFR186Ciqx3CiPQLav9z4mJcndUuDm+twVhktvRjcldU+MQvpTrg0xG9KcJp1B+lx+
	g2pp59DA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWX-00000002PqS-40aN;
	Fri, 31 Jul 2026 20:08:06 +0000
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v8 15/15] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Fri, 31 Jul 2026 21:08:00 +0100
Message-ID: <20260731200802.574821-16-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16A6F2000A
X-Stat-Signature: umdee3iqnb1bgijen5gnyjxb7a7sodhn
X-HE-Tag: 1785528486-486912
X-HE-Meta: U2FsdGVkX184CnWipRnJ+5pG880kg5zKLZPFvqouVlI83TNNSvPmVyA0NZnIiLCAEzOYh+Ovim1FvlL9dwMFQfmBerWNsO+HzJg2s0XYAYPux5YZUcdvRyA0QTQp5mMlFRfeonjhBXxwDghw69NyuGq2X31wWY5+SpDkO/vXZQ03ZEqQol21Kj7zqj1eyEzdGn1z1rlXLKPQmcCkPUvrjKsBNSmKTPLUQiWqJbVvI2WB/Qt5jNPFqiCNrOXBFeAXI9b7fLtkEcnn5sWqDt59H4HZpRAKQqBJdm4xKqWYpxJCzUFhVw5xvVcKXMm8uGaGusb/75ITm+OhBsDyyiBioUKNBERuYpqgznu+980LP0NCLhNy4AJE7SU1Ng+I/G1cgHAh5EH33HNb3KzRzN44Q1fvLGDg8p20X9eOkRHMlSD4b5BDc+hd445JiU6uLJ1u13nP247tmxrtCMSSVEfP9nHF/eWQb5b2rBOWuFYgwYHtITMVcuOTKoCs3V/cZBVfC1zg6kmgn52r3e6q/EseuLwOc/u9SnKbFcxL5mocbaI8fVrYO0ZynXbTqL439nih1JriUT4xP7i9IiaDL3ar9BKGrDENQl8T0wiY6EHLtfpLa41H1ZPbLzsihE+3nP0PFlwrzVW6rOXwfEAQXiHBuvHqgSmX5SyIQ/h/fQ6BHGIf/Ij6pRCx5HOcjs7mQUC3FndmswLsj/dMWBIov3EPWLTd8ZOcNQ1RMdAkGmHHfXZFD/ocCxzs5BmOtmKIcNSc/5Zy+d5KqocxaWZbCQjtyCHU1QpD1y1kVmO8J+P6aJV723UmOFI7Ynk8SV0BbqO82epTr5ywEW9BGGwrosC2+9c0ax9py+FxPSbd8TazRNk7QEM7BItFU18YWhuLPVvV0qiuTpvlT1Qnvc/rdHMMExYD7940hmsCtv66CGEG5HnYU6Y09zemJeGBLHZHMifq1gRqVf+BiTwTyyy6VVz
 qqPW9wih
 iEtBHl15I8jeOh/kImmSADBHUJSYYmtDVRnAw9qy6yavs56KmM9XKYI/ZGBGjQRN+/ASiL+HpaqBiYAgHCrmO3BGQTTCOEC2KkRQr6D/3ZVMYnoP6JPfQ6bYwfiJbEUr1i+6OpImN7crTyVPTb36PFQDcVuOEMO8+Rx7l+XGill3ZeAlj+RAKHlaDicTGoPSdMTNlaXtyGiUy6c/YDAbZHa2RixF9JEectkt+hw0k75IgUXZKML9a5RSrhdtv422e+Bn/vfVngvdI2s14DZjsUS1a8JK1A3PgsTffRVRPgmmxqtpVzhXc9PrHBTJQxsTgOJFi7rkk/Hg6Sl5Hj0jBH5BZPQgHItBWrgsa7jS/uJkvQUClX5NzfjTYkeQ0TNdENymu4Q+9O03MO8OJRctUfXZIQztK8+GGiMIp7T3qCVgym64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jane Chu <jane.chu@oracle.com>

generic_file_read_iter() now handles hugetlb poison, hugetlb page
size and missing folios correctly, so we no longer need a separate
hugetlbfs_read_iter().

Signed-off-by: Jane Chu <jane.chu@oracle.com>
Co-developed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/hugetlbfs/inode.c | 110 +------------------------------------------
 1 file changed, 2 insertions(+), 108 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8d15413a67ee..cef7e61b827d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -187,113 +187,6 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	return mm_get_unmapped_area_vmflags(file, addr0, len, pgoff, flags, 0);
 }
 
-/*
- * Someone wants to read @bytes from a HWPOISON hugetlb @folio from @offset.
- * Returns the maximum number of bytes one can read without touching the 1st raw
- * HWPOISON page.
- */
-static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
-		size_t bytes)
-{
-	struct page *page = folio_page(folio, offset / PAGE_SIZE);
-	size_t safe_bytes;
-
-	if (hugetlb_page_hwpoison(folio, page))
-		return 0;
-	/* Safe to read the remaining bytes in this page. */
-	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
-	page++;
-
-	/* Check each remaining page as long as we are not done yet. */
-	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
-		if (hugetlb_page_hwpoison(folio, page))
-			break;
-
-	return min(safe_bytes, bytes);
-}
-
-/*
- * Support for read() - Find the page attached to f_mapping and copy out the
- * data. This provides functionality similar to filemap_read().
- */
-static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
-{
-	struct file *file = iocb->ki_filp;
-	struct hstate *h = hstate_file(file);
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	unsigned long index = iocb->ki_pos >> huge_page_shift(h);
-	unsigned long offset = iocb->ki_pos & ~huge_page_mask(h);
-	unsigned long end_index;
-	loff_t isize;
-	ssize_t retval = 0;
-
-	while (iov_iter_count(to)) {
-		struct folio *folio;
-		size_t nr, copied, want;
-
-		/* nr is the maximum number of bytes to copy from this page */
-		nr = huge_page_size(h);
-		isize = i_size_read(inode);
-		if (!isize)
-			break;
-		end_index = (isize - 1) >> huge_page_shift(h);
-		if (index > end_index)
-			break;
-		if (index == end_index) {
-			nr = ((isize - 1) & ~huge_page_mask(h)) + 1;
-			if (nr <= offset)
-				break;
-		}
-		nr = nr - offset;
-
-		/* Find the folio */
-		folio = filemap_lock_hugetlb_folio(h, mapping, index);
-		if (IS_ERR(folio)) {
-			/*
-			 * We have a HOLE, zero out the user-buffer for the
-			 * length of the hole or request.
-			 */
-			copied = iov_iter_zero(nr, to);
-		} else {
-			folio_unlock(folio);
-
-			if (!folio_test_has_hwpoisoned(folio))
-				want = nr;
-			else {
-				/*
-				 * Adjust how many bytes safe to read without
-				 * touching the 1st raw HWPOISON page after
-				 * offset.
-				 */
-				want = adjust_range_hwpoison(folio, offset, nr);
-				if (want == 0) {
-					folio_put(folio);
-					retval = -EIO;
-					break;
-				}
-			}
-
-			/*
-			 * We have the folio, copy it to user space buffer.
-			 */
-			copied = copy_folio_to_iter(folio, offset, want, to);
-			folio_put(folio);
-		}
-		offset += copied;
-		retval += copied;
-		if (copied != nr && iov_iter_count(to)) {
-			if (!retval)
-				retval = -EFAULT;
-			break;
-		}
-		index += offset >> huge_page_shift(h);
-		offset &= ~huge_page_mask(h);
-	}
-	iocb->ki_pos = ((loff_t)index << huge_page_shift(h)) + offset;
-	return retval;
-}
-
 static int hugetlbfs_write_begin(const struct kiocb *iocb,
 			struct address_space *mapping,
 			loff_t pos, unsigned len,
@@ -891,6 +784,7 @@ static void hugetlbfs_init_regular_inode(struct inode *inode)
 	inode->i_op = &hugetlbfs_inode_operations;
 	inode->i_fop = &hugetlbfs_file_operations;
 	mapping_set_folio_order_range(inode->i_mapping, order, order);
+	mapping_set_authoritative(inode->i_mapping);
 }
 
 /*
@@ -1215,7 +1109,7 @@ static void init_once(void *foo)
 }
 
 static const struct file_operations hugetlbfs_file_operations = {
-	.read_iter		= hugetlbfs_read_iter,
+	.read_iter		= generic_file_read_iter,
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
-- 
2.47.3



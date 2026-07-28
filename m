Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E59C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA516B00A0; Tue, 28 Jul 2026 16:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1C36B00A1; Tue, 28 Jul 2026 16:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0686B00A3; Tue, 28 Jul 2026 16:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68DA06B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9038A172F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:19 +0000 (UTC)
X-FDA: 85039363038.18.F9E9FEA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id C4FA6160004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ebFTlQJs;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=;
	b=A0AgwJ2fzdkxeDIqqYDiwHXu7xZStQdh3Qyafmt2rNkbKJf8O9mRVq25SnyiRYtpG1QS0U
	xSK100Rd+tSeK6B67D96b8NCBo7U6zuXdpjxjpLQKD4NOVbGBC/V8CinogZ9KRwIs3jkNE
	fSmhYszwKcQ0UBeHwqZVeaE4VFobYoo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ebFTlQJs;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271458;
	b=h5zHZjnGToEdiwSU53GPtaNYzTQelbc/XvlnjytMx+v7rLIf2ZQ72fCYkmX1b1fh7l2v5H
	ns9yfHP+DjkK4r4ebK8MKQ0muFy/s07+OnWFRBnzzTs7uKS7LE7bzMQ+9LyFQVQaGEPHIa
	cbtep4FqRGEzGloXqAzCsln5Z/AWZd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=; b=ebFTlQJsaq7X5DMy6DIStSRYLi
	A+ci2DkHXQVWC1m5F6hsGPhujLv3iYgpN5gn0RpSJ+rsc4dZENyvmJDjvP3reCfwJS8iLzBrORwrv
	KaFi0mFouqOd7x0svNpiSFz6Gh6VSaBZ9QgW8DF81CRgM/J7j9XBrZycPZ5L1hwAe0kW8tVj4KUGq
	dELona07MqwrfOK1nhdLgBGvtuIxrY7GuRHY/xFfwPKjLK+xqXfk0taUodmBl07wL6+Vz4Vq/RKDn
	sMsUqYrO/Wf4SeV66zPvYr5y0WZV1hy6IrtvUvZWjR6eXyInIx3/w4RY6GH/r6m7JbSEebAJM6T1U
	ZqTH1eaw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeq-0000000EFX3-2jpP;
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v7 13/13] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Tue, 28 Jul 2026 21:44:05 +0100
Message-ID: <20260728204409.3396238-14-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C4FA6160004
X-Stat-Signature: 1pa56szdtsxq195isbag6chb5br8xxhc
X-HE-Tag: 1785271457-930986
X-HE-Meta: U2FsdGVkX1+SXdE2QioyP9kOlCxc+902oNWb0bCxajh6MT4wlqFoZfCnmUZ8LXoq33DZ8AnryQt4kSn7h3TPgTRBOosrhrPX48giX/Yfx5NU5ezzCgJuM9kCcGhUE1GxEuy/+xa6rJgqV9CDUQIF2YnOtgoc6l3pwH08XaVjyfWco63KMOoPACI3IJ0LZukwbZ2K4Fpx9BTtXuS9W5grMTKVf63U61HvfaYK6IFClDjgbHsJMi6nYNDfuBIKULD9mn2gZcU8dw24HvWPDT6XV9E5dL870AFVCR4jq+PKOxX0Ravu5ilqdRckQtluhgrUNinao4uCJxtoI4bFGnDuj0HOo0ZRKcIorT5NmQZE5g0YPO0+kIYs3xHFCCCx5RNq3K+PBtzsQbFIxSlDZRoAO4vRzlcnDPGFL2UmtifZkXvo20RHbwZ5FNt4J9Bg6z74tGQvG9aikPFSiYIybmMbUQQ5/vceOw9JLD/TTQgAaeaqurRJr+MFOnLpfotxGA54os62Aatfdjuot2paPy+AuDrD+OZlogIf+Uz26GeUIMT7owh/Afvq7AVx2xFGNl7WoNv1D24Z5WbJafrkXpCdH3DvqPqvuOaeZJsQM0SvipM9qCdtnRYaybQtJ+S2atWih/qCyAyzjCvBRE+rsTVPRKxaaI3LCtjdHMiIyWCinfUpF6f126B8tnDCJNT9O/qfJcdUjPLf9naaFJJs0Lu428OwJxTZsGbOlfQZeR45iuUV0sqrVBFRebjvT11p/Sd0/WRCBvG+0Ybz1WFcs8OSuVCwE1EPCFCL22wPgIxtuHkxLYFve3AS7yBvmeIl9yfkT2fMBFdUvBb4ITawELmM+tmZDQvsQp7txdcI8oyCgjgw160wYBMq4EHZuuhLuVGcaizZkDR0QkgmsUIGtfMBEAVYt+udHb2iu6oZ6O76BiTOpUbkxVfBXhrUXKfjsjEvbloGJH7k9OcIWF6L6H8
 ybU/ElUN
 Fvm9k9bbN3O4fDgIK1t0E6D+gafEP8u9WnEuhm4PDYMM/7Mi8YGaqzdb+SGYj93yqsUUfJDhqSzY6EiGxrL8T+3VkEdS6aMLg5ZS/AiEQXQ/F+WeUUrFly2WiNfkmZMPAh4ke/ymoe3xTSmETCI5tbjOyumbvg2tbmFMHCNO8JQvloWqUzaxqISW7Ru8tW79L/R1CZ0hYwkLbi8d0bwwq8kLM3rBePmAmWqoSHNHK6tYJzZayIAyqmdsVMj4sA6QfFQT6gbk+OI9hvZ3irpRftSXg4WV1t8+vwPdlD/hImV+GG2rKiqwjKCARHWgWiE+fyraTg6GAFMrPKT9KtxfqnkDnkRponrk7fYDU2wUt3NviBM//pSZEpMdtMcYG0E+tNlzvnrvdgNc4x3I=
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



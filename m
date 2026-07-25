Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04DB5C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212416B008C; Sat, 25 Jul 2026 12:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D2F6B009E; Sat, 25 Jul 2026 12:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8E56B00A0; Sat, 25 Jul 2026 12:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C58F46B008C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:00:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4853D1A039C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:53 +0000 (UTC)
X-FDA: 85027762386.20.63381D3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7BE72160011
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rZn6goUk;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=;
	b=g2YN7a2UMMIFl/GNuEUao4V/xDiLJGjLcwR5S25a0err0OJyzo5H+niuGcAsyWRGB6GGS8
	bPLP5V6VC884t5yY9LjtUBKkd0V4lr4WQ3fkA46qBwtnPdO79lDlZy8RF4FmTK9nP1TcNV
	pG2m3nRIKZEsl/NDDOLYCl5myR5zTA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995251;
	b=FJOFTOWIMGa3FguJESks53OIlHbli9DF2j97HEdexQvm+3PSD10YnL1SRmznLKFLbKwMIe
	YD6jRyUUqRXSop3Re9hqyu88sO3rkX4hcOT3ECaw9A9n5F+4yppnk2bx16nuIPIBnzm2Ia
	Qe5qp8J1dnmF829PVZe1M+RYmVBtDQo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rZn6goUk;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=; b=rZn6goUkLvuZoY1PGE4EQEmfcY
	QEdf8lJGES/Px8sDHG730b8eGcfFkUC10pOLs5xtSllGNeZlPom8aULnF1do4V/gFgZWH7o1WVr2Y
	NvSiFd2/TiuIGgdyndHscAamUd1EDFdj2VTIlNNK/XkNaVFq+TD56XLS+srZp33yTiixo3hy9HFQ9
	eRPNzVnHlBI9rFKThQkNyb19mq4zQUakBzRPyPJJvsuDa+JwxFSXsP2NsCyGNx+FTB+ZxEbWS96X5
	Ov5qzZHRL0NQv9xd0a1NhLQNljf0ljHkoOV2iNYljApDHBPWxhflMD1I2gZuE0SH3fv9WZWV2Uo5G
	5KlldWgQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnens-00000006X7m-2qct;
	Sat, 25 Jul 2026 16:00:44 +0000
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
Subject: [PATCH v5 12/12] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Sat, 25 Jul 2026 17:00:40 +0100
Message-ID: <20260725160042.1557264-13-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h5oegnj4shicgangsw4ynykh5zrkaxn7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7BE72160011
X-HE-Tag: 1784995251-935933
X-HE-Meta: U2FsdGVkX19TempQpVVEagnHPl6yUG++d+FL+bDn2RTIs/QKuU0aepw7BlHBRLWS3wiLKHwery0XeO/kNtdY1lYtTj7uGkiBGiJqF11jzcDatLrgbPsZSiJbi07g6JfZzqr6WZqc5xLlzILdUBo3xqLwnPoL1CLpvJbzWCxpJCwk2+C15fOuu9CTkZUZLmtj6+tZVRPaMMAjoyx36cWodsbGZ4dbG6OxNLoMj+aQUU+2nmudjRKW1wa1a0HBV8dhTOkduldQG8ShVSQQG962hpZDwUxdB3QIYL91yFjGTMeh5eE+iaZWz7vrMQwV1srYydClxmf9swZhi5py2lAnIFVetTF2ib9EFxF7ugEb3rou5wUjeTwnDKvLY3/gJ8m8HqYYPuiLXK4HhTiprOp9yvTgcyvLRf7i6AA/5VpZSbZDstKT4qjiARaG4mG8UeeOCSrR6C+USEeOypK8rg9DaQExQp94zhgT4QanZokbUkWIQVQQTK75yUgggkLOy88lk0uBuX1BvKN2Be3iKHu7c/BT1eTipZBPh/FTDgX8nQhapiOt7d2pScji+opyM+FPS0QP5r3e/XchYhZG2gbiBLi/bFTDp3S40GuwBtw38bta0OtiuPjffVwOXDoDRueq1ugna6bZqpcjvHfG3+X1EdzEoU7SirA4Gl/9myBK6bW6QluckECsxHQvdral2PAC1U3VhEKbK5Xkl2nChouXMLy771rUslETSgSym1MxwSMeBz0kftXFRGgZSue976ngZZnEuXcdlZzO7fjr80N2IYo7M7iqpwnXePFxPWrejEjvvKFeFjfzKkHoP/f98Ixiv/HTJYCOhfGMJiQfMOVnZu++sBSb07mrSsh8bWZ0Mwrlnf+ZMN6pyUpfEEB+SDFqOQX+UDpVDVBc5ixviENGVwN20LkBjrqSc6lj1y83cZ9KpihDaPv9yBUJXqj6TRos1/YzsdglDfbHk7bVahP
 cm+dXKuH
 +SaRyVtX1jLhXu+l5rfJdJ+rklgRRA8fNgL6nxTIBBHNeB+ZB8EykRru3maktpu8hLjRN+9CLWInB3ivmj0KTdYlhDeDZYlT0pRdLmrWVRQZXmWHBrHeDo6awOVSZ55BYKkzXf09cDT2M3qzWzYugXJdsXD8EULBNAtePOAlvZWx1pr0EU0JeqShQgiAyGep44wHqQX9X9jiJ12NbV9o9+1CrWg5DlfFShrb8JnCr7Wrs67RsuZT/AUcmEZLnS6DLWrzsBnSd/+FjbolPyEAJjj5n3j07vWmCvV4x0vK+C8U4Lia5igsCCQ6S8aD39cafggc5PSIHLkxogMynJO9WtZmZao94hg1bhciZSBLMnN0C+0mnLLoIgQE3sYXFErPR49JUheRvhHEUE14QiWNb6H2hPc8qSCOlULTkNveVuoeP640=
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



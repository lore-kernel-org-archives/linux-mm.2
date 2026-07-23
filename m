Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E37C531D4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E0C6B00AD; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDE66B00A7; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8460C6B00A7; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2FE6B00A6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCA50A050E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:15 +0000 (UTC)
X-FDA: 85020278910.12.AFC940A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5410AA000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TFr7C4Rn;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817074;
	b=M5lp+x++GSnW3Fa8SvvE1qdiJeTHIuQ4uwhkLFI2g0+0/G7ZQByLJyBnndu3iPNf624eG9
	DY/+o0GQ2EH6pnr2824Ti7V8NWteYfjAcIhwxLXmDKfleC83YXlt/ZkFbcfpwK9pBfrBoz
	et3WIF1bDyNpjPzs7u/btsCT7jlk838=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TFr7C4Rn;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=;
	b=I9/Sv2HQPDt2sIgRiR7xPe/9GsEibGZwMTGvwVJvgfUOEiFM6zIdTjG9mFLz7MMvgp2/VP
	LWU+/qupyUllJY6HTNBcCbWH8nbPnogD1BkqPagxbKOOwg7ES55OqMpe8CQkuKFhTjJSDU
	XLm94Zp89GWajNnJ1G6I8dMrWFpB4Z0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=; b=TFr7C4RntTyAW5kvQaJB5Y5UEB
	8y5r5SuS5CPN7sREoKcXfth4zStOGkBqWchmpiVN+MaoCjCHoo/iCWDSwgo/R74AmWo3WPgsBz0jA
	MUGMUKbUDd8uCaA+uDdCYSrdOfKAglstXpRS9FtKN+TauAnyy67nbTdJRH28Nha5MUnCs1mQ5qtIT
	XV6mBIVxj58bev60KhKt9WhIVpkXdZgwT5o0LbMpsaxfHSTTmQjU/16aQBykSizxxL2Xz7YK54Q71
	CMWAxsHdGTEGJyAygXAW3bZ2BlhITI661HAGAumjyNNbRX7KQa1h1KyWDw3YFS8Ee1w1NsqJE8xfK
	bjfwzaBA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000jiF-3sdp;
	Thu, 23 Jul 2026 14:30:37 +0000
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
Subject: [PATCH v4 14/14] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Thu, 23 Jul 2026 15:30:31 +0100
Message-ID: <20260723143034.175661-15-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4xrkxk8na5c76x8tgqsut51eo65g4774
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5410AA000C
X-Rspam-User: 
X-HE-Tag: 1784817074-100067
X-HE-Meta: U2FsdGVkX1+N6QF6c1nBm1B4QINXAZvpMbBizd/AzAA1vDZy+90Pe62KwGDAWzETBcagJGeBj9bAtjQ0LPCuP3vVCayCjP1S9tnBC/McJzGPfqn5irbnPE7NMYasyueipXW/ARV906hjmB+mt7/Q/tMAoL4hZuBuryIgKmXvNsuWQu2J5ByKhWrKN6O5AK3yOZgiBXrCvDhMzjhJ2ENMR7G1+d0Ca5gdDwo8pBOW2Enxqo6PLxVZmxdMVAvUt3UxQs7aZbjGzB2sn77EaypgrckRFcujd7E6B9U8/ZuykeOKLPjdBm/x7ZrCC/LICPiKD4l2lB7nKLei/NkLnkCx930HHJktnJT1KRK5Qse3Nmt8irZC+amp6j8uE4+jJTtrMn+U8EryDwVpvAUZXGkk3dlypc6y57fehHHi9zS003tC6HdnjXsy38oKsj/zxaofrxJfpA6+ZVvoWcSHjSBbdeNzSpmYfEcspC/+t8BBtpTk6PSx8YGWh3cvefx+FBWcMZTs4xhSJSlzOT0WzTnlUeElC9Nsl77GNM7Whfdg5u9PVpvzzRlQTASFsg8gOTAvd+nm+GDe23mDEN1YEzUUyuU/WO7xsD2uAOF+rWYHgHpehoByqX7mxAcFgbUbSXXYVzAnF76RThCZtA/k/MWsfzs/hmOFLDu2qq7Fj3JNaEje7l+nVWMpf+UbmhxJjOAF2ozv2/WFPe/73CF7ejbz8hjtQ7gwrBdXfW4IBHUkocE3HcfC1hiMzJVHLWQJ9p9PljEXaiez3mZQnIcICrYOibH8JeHyAduemZMHs7KFK3K+qXNd3XgefxiAZUAiwcHKYoaMBy/+qN4F59uvS6hdWMsPpNGSB42mOYAfDje3oeWAoIXBbNoUBq7m658NTeSYfnwZqLDAsl5Oes52tvtubS3BMl47UOYYmHD9utDu4+MKSe2PeByfGslyO29pxIY43Kk5NolB1mn2ceCuxLv
 5tDBM6eg
 JdA/DotTnCaJKA6VEcdTspciOPp1R1pfSjbeYBLg4ZbR81aQZUkNUOzZs/1ETjl4C33Bt9yz/7ZvULsZlkMAo3YGbEBj95U+L3mhhsGUL11wwIjRAokNXsR0B+pjx3t0b/OISR1SfZppVb6SWxUz7mTXdMMnYZ/dxCKDW38Vw/1aJbUznU9SasVUEFY1YfQ+t6gJ2dR5LQ0UYYBfH+uDndH8K4KzhWnRA4oMh9CiE2qXrtqo0PLA6awJ8tyno6+XO//lGE+MLXxW/dG/3UqbNIwLATmhVDVVviVRbDh84y7WgcJpmhQDLYCSKURa6CzfNGbEtADuJ8Z0xg+AfLzUgYVqESUGV2C9ehhbAyB06NkTVL12p9Y1s2mqVYnMoWuCKN+sn/Bxvm1VtZTtAvviRKrqKWg==
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



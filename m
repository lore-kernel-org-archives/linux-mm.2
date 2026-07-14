Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A1BC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B83E6B00CF; Tue, 14 Jul 2026 14:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019E76B00D0; Tue, 14 Jul 2026 14:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4ACD6B00D1; Tue, 14 Jul 2026 14:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9A2C6B00CF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:09:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E0F2A03C5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:10 +0000 (UTC)
X-FDA: 84988168860.28.5EEC734
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 76B844000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=prV2pc4H;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5peFVE/kDNvQpa6l5/g+1jooYT1uWZcYKJ+53pLsnI=;
	b=AMUb7O0BYX2pMgBNz5mfYaO88O8d4Rhr/PUYbk0oNB+TwEqWRK4xJQ0njrZOnweZlBiGyp
	qYN3l9cP1VA8hcmmAsViymxbhRy2ucxWNA9xPPybFTpo9J4q/c97L4qkrh24dEpPHu9yMw
	RGqhJMCNKvDW6MYnUuvAfPY55JSs9xk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=prV2pc4H;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052548;
	b=JMl+4TzhCZWxVEiszIXWb+8yPof7hS/UJvcfNPkhBbGIs2sW2xhGv5RD8X4QZWx2IJhe7A
	pQmJDCaV90PyWC20zHYttXgUkUDA1XORbRLsgZBLUIu5BuMQkQ/ZYhrdnfS36nwesZ7q0p
	GJl6HX1BcoBgF9ZUBlSvho6YsE9hW1k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=S5peFVE/kDNvQpa6l5/g+1jooYT1uWZcYKJ+53pLsnI=; b=prV2pc4HrxeZVtzm7109qwhFLv
	BkeZyIiGXRTBXJUPoeINbjKW4/G/dXKg2Cd9/A3oGV8Ftb/xO9DgB9Wu6xqpR5baj2ShaSt7kgPxk
	IVRd4ouCu25XIyvLiZNaRU7B8mvjDVaXFewgyDWZGzTOBWV6yBJWIEZtRVJ358W8qtIrW0q4crXZy
	1sC9baMtvvKdAgUAWPEKIw6QYpTUXf9LXvx0ZtFuG8LTuWJxHjkYLbhAauWYILAfxn49olyfJFeiP
	5VteEpFSeRmfdxSzqKCriejNcRqTYLlybZm/CLOXq/GgTRYGZcjXHFpSfhfRP3yQpysPVa6D9d07M
	VsAHG2Fg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYh-0000000Fegk-2gVk;
	Tue, 14 Jul 2026 18:08:43 +0000
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v3 9/9] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Tue, 14 Jul 2026 19:08:39 +0100
Message-ID: <20260714180840.3731244-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 76B844000F
X-Stat-Signature: ooezth6kwmcrzicma9m1ptigqsndw6ca
X-Rspam-User: 
X-HE-Tag: 1784052548-193834
X-HE-Meta: U2FsdGVkX1/Jmg9H5+3neGV3K0QeJVvyZ8sEaKQJMv4SlSi0pTbu1VSBPbx+NtE8VKCCeH9zhbMasepEzimATp6kazm4Fe8uGB0AcIMuzjEbvWD2jdwM+QJ1vlfJuMomBAG3U38Yz9sa7wlj7fuqtyHrClpuqPLhbZKhcuToiCMkxv6L3qOR6X8XA/NSc9knVY5MaU/eTGJ6Wm8HbOf3Swcc7da4LtavTxHBOyO4vEBO7hosJnsPiVUcGZKpJr/jzpAYrOs1z9PdIKor2d1qw2jcw+VldbIGlI6fZWi5/3UPA/+pXM8qnj2/UGQjXqEp2WG6eRYGPD20t3hj7pfOT2lK5LDLqt0yZWlXhZNKs5pmQ982LMxXUuc9Gn4rGMQz39FMrL6NzBhcI7yfCiwe4w/Mk2s+8R9psAnnkVvGjk1cPvX5aLHRJZizdsBNwJXhpHxqlMqcU3as/2cULHIvhIoSgCMyCkxe7DePJ6wXYYZzFUDk/6p4RGgOozsgIuvNYWM0SQx+EG6C/0HZdsZq72v4lX/aiSVuBUulmdo8iZDfHI/t4kUqBtvhfa5EwFIO2oQ1IIEbjIHQsgRy9/sT6Cqs1Wl7EQM1hFpxig9E2ebIz9gAWyXjpSG5Tcage0cqDpWXQEILxd1H8IA+uqMxNNnScfAlUgT4W2hDJ1TCk4dzbMUDhRfGXSNGpiFbbe6391qJa2f4Buwor34rUy/73R1ddC/zkrBdgUJdpj+z9zM+zD+1w+dGoXcKIe8D8nYVtkWAGLdXwEmELXyy3ODdFZpuJJ3hnu9OQiR/RpLOmNGVtaB66Tz45mfgJTA4phdeZm/MBzcUDLLbjoaJSgoUOl1jgB71wgR4cfPEal1m6WnW2C6Y7JT+36uLSPWXlGQyi3zXe1JcKGuz1bW5iqUXRUM5oTKqh50zTBxL4gmn9J/JBHwRs9G5oNOBOTcRnazTHIrI9fa0eGwHUf70MaY
 m2a64wNI
 vtYMg3wkudM6JZZW0Bb1T5jxWPgZKAFp1fUNMM9Dk/R9k+mLF1j8Yx50h+6625t5FeT5dWs5QI0ZSxYcZD/51dDM4R1/h8xEF1fSyEZH9Rp5PUyGwl2kl/kRiEWmQYmHdUtd6Z4CFkZWGRvg1Rt+41BNKTvLhm5sKCOFK62v/i2jrSTN/TYiiKVnWpScM0v3NjxPX+EPQMQ9UU5IWt7lgc7Jc9Ps2FXet41z7jPzXrkoVSUpU4P5wcuOOjwfXPgxaCY17EnpaZ41sczehFvoN2jD91tRwDbODGmqoLnvia2Erkh8lMifeEg7IPhH2xWMvWs4LoDOv42HwFfw2rK+MHGqz4d5eCBr4fa6hPiPpXxaRc8SoGbxUnDHJneC4YenL4ptrDpvt4NBx/cpbKWZ4XmgxuA==
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
 fs/hugetlbfs/inode.c | 109 +------------------------------------------
 1 file changed, 1 insertion(+), 108 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 725bb945a440..a6f0459d79de 100644
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
-			if (!folio_test_hwpoison(folio))
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
@@ -1215,7 +1108,7 @@ static void init_once(void *foo)
 }
 
 static const struct file_operations hugetlbfs_file_operations = {
-	.read_iter		= hugetlbfs_read_iter,
+	.read_iter		= generic_file_read_iter,
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6873C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D58F6B00A3; Mon, 27 Jul 2026 14:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5601E6B00A4; Mon, 27 Jul 2026 14:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315E26B00A5; Mon, 27 Jul 2026 14:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E74656B00A3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 742CB160139
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:34 +0000 (UTC)
X-FDA: 85035354348.18.6923213
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id E16BD40005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aGYXYXsf;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=;
	b=aCWQtcxWUKoAzbiDB0YVXYCNyVZq9BqauA2OtmyWgLzQmMYK1CCbMgAPAx3IBeFpNOYT7K
	NJRwft7/krwRdZJlKUCwE5Nf61FF6W5ywHRKfOp6ubj/ozxk0g321/qIoDhXQv+jWaRRtf
	SVxXwoIuLpH2lmf49pji2Y4sGcOimwM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176013;
	b=Bk8DcP5pE04NLDN38k37vXkzYN4m1GT+SGeD1dVPV4Z+Y0W0ZN4WuZW4scxuiAQs/wGBTK
	pohE5SHeEKwsA3CExPr/PJOx77LfECgp/GVNHsTm+2GkBauyFF13IZhukSLy5wzOcw/ow+
	79Td0cdjEbV+BU0TpYkgzzOvKY+k71A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aGYXYXsf;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=YiJptwzuHVJ9HDL+jrIMqP8ge/TVdk1lJOQr0HqI1/Q=; b=aGYXYXsfARgJbvYzf3mIsd/A3/
	1U66Jfu2m6Bx0sw6dmtlTZygBYgyyDO+3nl7aXsKfxaFopykjnhhlcO9xGpclUWgGBTpw2kC5lVxN
	uxSikTqaWvlodigfEVSWPVLpfOwjicgCKIkVqJgnT5riiyxYhLL0x8JXpzXRgB/ztcnyReoNCypui
	L/PG+DgYmGNhxj5WOilAxtF7XCJFNfpZAn69cOkHmTzj4zx6Jno1RigPB8ySOSMglrktnjloqX7i0
	OBDdyH77IyiHs7f1ghCQCvmk5dz/9JO0FUHoNpWW0Kj+HDg4gQ7YxIGyXjt+dCDbFUBRqiM4xmxbW
	WdgBZ6QA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpB-0000000BD7k-0ddm;
	Mon, 27 Jul 2026 18:13:13 +0000
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
Subject: [PATCH v6 12/12] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Mon, 27 Jul 2026 19:13:08 +0100
Message-ID: <20260727181310.2671972-13-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E16BD40005
X-Stat-Signature: yaaud4riq9kdya6j65etiapwzyzbg6o1
X-Rspam-User: 
X-HE-Tag: 1785176012-42267
X-HE-Meta: U2FsdGVkX19upZKHpYEvHSyT06RsepYJesi0y+rvNSFxikgLXH2EhCF4wBhRtgohl1ot2WJBwMtViSC0ec3GbZ5RsS41BUv9Qd+GFiZYTG+2auISgguegnGN6hCGj/GQRDQtePEOzemI8RrlGt3IGLeN4PFVehiCowUnD9rfMTXVCup5Ew4OTmoc+fX6XsKHYa/fFOSAyaRUO3vfe1YNUF05tRGnHVWnTMhyzDqVDtEerx2k4rn8Cg2kfjaqc4FhYIIlzbdR4bh7caJvAuffo5Umw7vpTldjhrfL7RIxB6MdoEs0Sga1hXe81Xlz1rOE58Kx6zqNg6/yOiLCVNcf3NNmm75swvQXb44vPmBZOB2lS1y8YZmUefELYxMPIUeQzx22OYbe3/BWcmX38ttO78DDjkljrGxQP5FFK7y/qO+RJnXozLIOpYpwI5WXsjwMi5XO1hQaZRstrqgRt6TK8dAtFNHprM09/9JxU37qB0vXdQXeSsCudVTiGARm5C0FUBb5eddx0VlvYLkKj7B0kptDGTgm5DXkVj73CVdU7iqI1KyIWpKCCrK+pZwopU8MPP+9SvvsRLzr+v/BvEvYFMDxBiMNsYYHhrf6s2tp/XCaDeEK6VaTnWr0cv3e2cc7glgGlet/1fnrVe+Rki8Qn25ej3qXZ9aHv53KRWqUQ3HCY3Vxsf6M4Yyz0VICz7TaDgN4Ap4CC+gNvAQozPgEPN/1pNS17qi0G21uy9NC8gnnxwrVJzmf/EwwmelspBQ51OoQpcLgXPV14dEVOW7DdcVAxQYMyMGPMRjtlb4Vr8nOW2/bO5XhSFUbhZp2lGH0IBWDlR0fu8Bk6FUqDhZ+K+T2DKc48zyhejAUpQyQ8ugWmenbaXRW7uApMFCY9EBwOSGkTUiR2WGfK2VRe8oexS7wP8W1vZo3KhRLOykOL53AZbEl5n9TXFo0XadFbeSdnShmujfJhD/8eC6gNps
 2VIAphOO
 7vMZQJYWMRUDBEiSplVJEIilKBJKcNM1BjCmeXAnl+GvmjnIkbRX5l7BN5xlKrLHK1qhQjBS5r4JhwycfmglzxQbui0yXCi1ADrVor4EqD9TLJFSoGVO6w3T0EyoVj7oYIKs8bwTND+uwPxHwruUuDD/Owc91QAr/IwxMZP+34sMAb4Pz+j5wwHHcu4Mqs5pNTmIWUICSQPDpM7OliscC9PHQ2v3FIil4Yftuse3ttHueR831nv+wEXIVIeDg+sGsDN4YxQZw5ZNvFHisbVxMQOWmQczLvo6W5HbxbIQAe2k+KjBi0r6zFgZOGbVtCtAMZaWMv7wMdyFatlxuJMlWFnwtxNj514EJh/6Qg9Rry2+LZthFJPmDcQWGx3P4LmuILdLGZ64Nih4BKhnKNUgKKiMmeCsbK9VQ41fRIjv3yMNDln0=
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



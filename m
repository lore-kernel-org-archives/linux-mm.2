Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22AAC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C986B009B; Thu,  9 Jul 2026 14:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9966C6B009F; Thu,  9 Jul 2026 14:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8865A6B00A0; Thu,  9 Jul 2026 14:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5477F6B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:47:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF8CFA028B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:51 +0000 (UTC)
X-FDA: 84970122342.08.B7E4041
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id CACEC40008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n3TNjBBo;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5peFVE/kDNvQpa6l5/g+1jooYT1uWZcYKJ+53pLsnI=;
	b=pik96QqPbZTXPsx9He5vz6ijkJYI0iuyLxKk2Dz61wkpgFgaM1Z9q7QMXRP0+hJAXhIZIG
	+gZe259nCDCz2xWJTgL2+B7H2k1Kpsq5dRza8baOUEenDY+Z821ncZeD8IiGuFH4PyJscF
	deEKeGWtBLEML76ayTNqCBPIaez8DQI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622870;
	b=B84ErRz4NxZzC4rNPYqevRTrzrUmU1LctFFl+Tbme3xNr9nqgN9c8P7yuZMI5MfUVihFGI
	hKGIsg44mrGqiBzWmpPxpTQqpo6DydKiq0rhhkdfI3TldfRLEkk8lqWJPPN/64a3ZjWM2m
	+EqZu4wn2Jvlz5wNQ5QnAKHkYjcO0S0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n3TNjBBo;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=S5peFVE/kDNvQpa6l5/g+1jooYT1uWZcYKJ+53pLsnI=; b=n3TNjBBo5vmhKRfE6Lwi0KbR1Z
	z7lXyyoSLLA9qDidKAkJHt5sJMKILB17EF1yHP/owXtWEgcK5/YGM3GAJEhoZ0pNki13Qyrfqh8uw
	O81P6nP8T+zoqY4uVHZ0nmmZJzsHdxvx+jjl06Z0LNtTOCyQRUd5n9Duf3bHQ4q0RjBOKkmdpOjHK
	WD1+sEAqSScIks2ukeYBqeZyE15YXGdA14G6vf8gXQx1QAWQUDZSVFbHrL3m2dQNbWVDMTjVLtN3W
	EFiCH0phNS19Dpg3rDuamHZGJOqDW9dX95LgDXs/O0+zfXcDbFaEpMKvWETEXqaKlF0evS6MLKloa
	1LlB4BmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmh-00000005OhT-2ZYQ;
	Thu, 09 Jul 2026 18:47:43 +0000
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
Subject: [PATCH v2 10/10] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Thu,  9 Jul 2026 19:47:38 +0100
Message-ID: <20260709184740.1286561-11-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CACEC40008
X-Stat-Signature: 8bx1k3pihqyc68884edcopdbcuk6emm8
X-HE-Tag: 1783622869-783819
X-HE-Meta: U2FsdGVkX18I9U5016iMOLVCGVggnG29KAZXfLeb4hvEKu7r8+4c6i04OjIiQWAKpruOPdx8LZoO5jrr9pAwMmS0xcs79FEEUjrn3o+TyYyg3iwx9RVw8f78jO3X2Z6DBup6Y0RnOzff7UjSD/MvRjKqdynbyXzGKyyKKET8zhMS/7yUQXh284I/IGnq2UePd/IT3IRlnVj4x5Tpu/yGZ6OkMkwfmCs47FbliLpUsS4T9q2dxxItjPXie96HvipYz3ISWrR0gNd8+N8P48Fc6hHuNeUOwNzZTebKHODpeg7MfytwHbu0AuOYdinZjG5eb5civBgXox3sd8sSsGCb//Epdwec8izsMa6KNc8GmGRo2qnrxL8bVlYvv65l6jw7yjb4lgvLq+vPr6jdwcq7UQ2X7PVE99fR9+5O+n/RE0al7z8YKESUg1OYT+AXeEuuosAeceNL5HIzgx2kUUhzLMc6CixoIdr2py8FYKfk3LYuguoXwO1On+77UNaXMJJ+NRLdP26Ic7ypKfaD7jmq0etgejDhinLM9PnlkAOFJvwdAbEuGFbJCuiEHp4EHhvp73VnEf7gsdlh9cwNfelG9llhmMAqsHpywznvqvo1PjNTzvPAAYdjua+UTSLFImnSB8RTYNVlfgXL8qxEhlAJ4uY1HlZEsiZNCcYL1yV3vagYj8ckSaVo6sCjgrQ0QZ3PZfPx6MFDfeBe9Ik4MCT9AKKgqTWZCTorfDfXTsNZcSSEBhqJ5eAlQeNSuqNVqcbFTu4lgVQJyEIykXtAJnz0JoS3v43KuGjB4d2xIKXKDCzzqByPt0M3G4vcAxUjvL2hHBM0uB+ecOQ/UVgbcjnwZ+0tGgi5XHSM6JlzDK03VZaG5GVzl+4AMDLxVbOPTUx4m+AKzfV0BE1kDP1YvbspcEfEkhFkmGqpVyDraHNgHdVuOlSVfc4I6rGnIYmoWD/Z6qHY4rd2z0fzT6y8h6y
 tU3lFIUO
 ilkyKzu3tpuys8BxVVoP6Sa3NLHZqm6qP3BnQ7Z38U7LzMo3J+9LE/9v2PBHjneoqQf9NMBWbzZ/NlK9KG2YReN5zwO9YRw0sBS1pBu3h3lg1i5TRg9nj52J/MGBF8imxZDm0+3zYmHZ+CiMq0dpewa4KoELOJzcy1/F70GqR/LkffSOzQQxmj3OKo3XzldHNsbH6zpBK4997Zi/gpsP4XUn2es5zxvSBT7pStb5mVspi/3edEFjaTgtpqYrxbf1S2VwYbYzLovo74pXHj14ucTEBAX8FY3A9NLyUrY/CjH/u2rqbuq/hWOSIt54wDLT12NCVYPPUXxOm2E/1gKIundSxDpJPUjTk52f7qF1CSELlWVoO0cRWMW6DOdH0f5ScUNeBIjKBeUvgTtvmY3lvf24TjkmTIHDH0KAclod774svumo=
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD6DC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32476B009B; Wed,  5 Aug 2026 17:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07F36B009F; Wed,  5 Aug 2026 17:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44CC6B00A1; Wed,  5 Aug 2026 17:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 660546B009B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:29:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2337A0632
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:24 +0000 (UTC)
X-FDA: 85068507048.18.818306A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 42C0E40005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MpMLTFwN;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785965363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ma4zHx7bJMFjy6oLtPyEY9Y1gbp/GxsGhVs6sSsTh+c=;
	b=4S64xzjKLiHb+rMEPZ9DO3u0JHoy6VI+UpyOqlVJhsyJ8RJI8H7kze67h8jUA1F5gIrheH
	95QIlN0wgJsra/ZLGBybVHEg0+4I6h4p398VoVepypVtxE2sMybNX89eJnzmZ7wWrCMcbT
	iWJc2skHaN7eyq6YiKlYYa5ZylF8Ir0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785965363;
	b=uRHGaJnAqlMyDuCjfGIkm/YZs66GUG5iOkf9WORUFXSOiK8A7vFhV+0NRA75Cr12wlNaEv
	vrh9tsj88MgIaHZ+XS6ENAla7RTs3w3uE+Ae6We9arGuxE29T3ueDiDKdXL0/1UzgWUrn/
	S/jGN1NfLyrFajLcKxd4eZZrXcluN9w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MpMLTFwN;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ma4zHx7bJMFjy6oLtPyEY9Y1gbp/GxsGhVs6sSsTh+c=; b=MpMLTFwN3V9WHEZXYfPOhi/3j1
	MhzHyiANdaHqWZ0GG86xRti4sH9nb/vvmkYPm+6EDV2DYfV50IvLAQlOK6o/5Pg03EHnEE1VgK9I8
	6riq+KsTj0rjk9XSG2+WhLvHnSFAKg6lZy5n0K4WWQ+PFwQeunALxZdfsiSsXngpd/Q9VbA65eR04
	qijnLBwZWjH6Jmsg444WEb5KyRKWesQEAIGtI2hSllc8Uk9IsqCzgG9fwy25KVFK+s/O5Dksb3V2m
	OZA979jlpBWp3mtm+mI3FHEp9I+pZlStc6ydciY+FsO9ugf1slpKFc1+eJa9QIGWHNG8rOx8ZWwhU
	UJY2J3GA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioL-00000004h6X-00KI;
	Wed, 05 Aug 2026 21:06:01 +0000
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v9 15/15] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Wed,  5 Aug 2026 22:05:55 +0100
Message-ID: <20260805210557.1118966-16-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: a47deu31dci83zeigd78jbqcwrt1wz7d
X-Rspamd-Queue-Id: 42C0E40005
X-HE-Tag: 1785965363-434370
X-HE-Meta: U2FsdGVkX195//lKfIBEKILN+D+ePY0grTH9RW5yQiGUyxkCJwhJfStMtw+s6AbMToHCTOSIb7woIClF917zo0aToDvfT7EZuOFAHJTdosh2OYEMi7Kmvc5oj1SlaXp4OdthVo2VUZJ2vXCkuO4Ii9ux2BH+R9Iac58Rt6UDOUED8OBYsufL2jgPrSPgTaancYpOgpQdVp8LtpYMBjEmJNjEczNbI8p0NoIA9yVdxxRczYrXyrNS23E1GbnAcCatcaaFNCvIAT71QUeS2v/VttC2KQZvATo6uzOCtXrs7QcbQF+d6tMWC5+zjK0zlbWuOyspRYTW+Nck/5pyfBYQQPC8TmyyG+I6YjQ88UlBY210xvseKsSpfsqq61tn3KFfJGmHD/qS9TINFjaOhJsJua72TEXdTeIEK62y4/Dp22a2z3lOqLrfZUxhv4VuNYMphG3HYOk/M9znhmoptBM6uTL0D+ybZ/N9lruMT2YjCfBZEmpKWDeZOdHWQuB4W9eTxcsIbyHG8bdE42Rk+nItFzIf26+Ppwd5RZO+tCnWenhkBXBNRH2+b6Wn2vx+rjrHhqMZS/zGPj8qP+dS8bQ/uQM/M/vc+gLdQGuEc7h3PQGUo2GLFryktXZuNWrakwseKMXB6/Tekmk6UL7I2P4iFpJwwjD+7xuOH+IyGorIP0qdfvUM2nzYB8vp3WOFL39G2blQ99QP+BNCZ9zg6sUm6Mn5SPcLDknJPeRrDyLutCS6693x1RNbl1eo2sveSf4MXn3tJNOUNWhz24/MKjSTnwzz63OQ1Y+iSRwhahGhQPoTgKIcvjN1DNCmS5hdmrf5vRNtZBPFLRGfhGnbfjreKB6JLYV0KFBFI9UoLFBndffHsE7HclFUJ4jxSzoonpd6uOofqAT52IJY532U6VZHYqHWAiGj4MqjL8LKtwLTtpwfiUGAxuaQjIuutrghJeHmb/uqo+/paL3Cr4Omsqz
 VA3OASmI
 MzJNCrhyRQHaVP2DxYIDOoh/4HCMDCAvsFyq80A9nICB15S0m8vUH6Ug22Lv0NRgTq+qcULqR1jKYELeq+BY5gZnwbc0g+9++PX7bRJr/+5wBalY+64zsSQBDUil1Pcbv1rUyz2YgUKfZO+r3D8tU3rl2cqWVmiDXvjU0ZxWrbDgQp77mtAukrttay1SJIN+GAf1f43legbTt+R3n+fF52JwFN6z9+f7MxA6qWE+WQOMdujxc9yfIOGG5xNPfpndR6HMTkDUY2X9mxsrMgPc1dMTm9oQ0D2manPOjW6tUmTelzV0e6eTxDblfHcg7L8b6YohBEtcUe8bPV1co/sdiLMC/1EYK9a0vacRCoc6RaloShkX6R0yfoM5Ur8ilu2QYyyW4PdB7ElNeLqffGycYpS0opa3/wQEvaYujye/egtAH2rumkE03T+izfOIzOb7QkagvOrz6dLs4e3qCfv2FYdPaYECWqjITyE3TYOQWYBj2qfc=
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
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
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



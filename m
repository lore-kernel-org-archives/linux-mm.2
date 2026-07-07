Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86037C44503
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF576B009E; Tue,  7 Jul 2026 14:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFE66B009F; Tue,  7 Jul 2026 14:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A292D6B00A0; Tue,  7 Jul 2026 14:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEC16B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:17:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37B428F21E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:26 +0000 (UTC)
X-FDA: 84962788092.26.393E617
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 634C2140009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dz1hd4+Q;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448244;
	b=1GdfQ2NCuTjdsMez3F5tasTqcxguWSt0CeUjAmHdZwPC6IAk9HnqwBFBGOBLXHwhChr5R/
	TuEfgjmxcrG5J4LqzE7wYvZu5tNCcWFH326wfj5sQdO5+eGiQLBaIgoFXCWFHPaRW6Xpj+
	p1CXUvg7DpD4c5/6ArLgm/VOeFJn750=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dz1hd4+Q;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAG019187axLLkQVYQk6OpdhUnEw7ZLe9gH95D/SIsk=;
	b=qsgQe1m/u1cmn4D5dcVpIVhRTC5byairmPnZaXOmYRHNPJGzZGUJCrx9q/WPTpJ/iW6hGh
	wDSVCO5hSPhi6wlNPPq2suH3gu0AkE0stGrMHiQjA37w6LqtpkFjEXJ1axaYqkIS56j+nu
	zK8dmE3Cg7GBD5/2hnAiDnHA0O+Nrb0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ZAG019187axLLkQVYQk6OpdhUnEw7ZLe9gH95D/SIsk=; b=dz1hd4+Q8AvGSlJEMe+p53jlyW
	PxNysVrMfVvWLJWjkMp1Ei9H1p6sn2VQtl1p3pL8cHrsO8xq25enoQKk3CdZ2kIRVlGJwGvQzcBOc
	rhD16y7PloHf1BNtrFx+59iQWC8QTi27ES6fZsy9YfmO2rrK0WXbVxO2p8RoajVVW3JJw94SrKIG4
	LnHrYBvKZjDDlVs2hE5OkzRyhK+e4G3atOx4BtBXG7NjGxJ2xIw4ZSYw0MYCGsZqUBTTM0wa9YrRa
	V+19VsVTVkmS7bR6SIIzCBnv5cP2jqLW3BBG3o51WTEPITvBqSE35Yh5YyNi+h6XLwwe/pbWc1oVq
	wnHlDlTA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whAM7-00000000sBk-3Dse;
	Tue, 07 Jul 2026 18:17:15 +0000
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
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 4/4] hugetlbfs: replace hugetlbfs_read_iter() with generic_file_read_iter()
Date: Tue,  7 Jul 2026 19:17:11 +0100
Message-ID: <20260707181713.208282-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707181713.208282-1-willy@infradead.org>
References: <20260707181713.208282-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 634C2140009
X-Rspam-User: 
X-Stat-Signature: csbd893t6ny6nnywpk6r1qruosuh7t9b
X-Rspamd-Server: rspam03
X-HE-Tag: 1783448244-515196
X-HE-Meta: U2FsdGVkX18FcERusQJccmgwuO/3fgwfE3qCHGaK9CZ4DzNnS/RLD804Lw5gRPq2dC6iLZd40XdmjtnTm0O82otVGIagm6Rf2uKcw/SojuExv3MtjdCP/DcH+fLc4AO04J5ysfMMpT048aH3NCKr3KnH7akOgfa4KkStDmo6iqNrsDmkjBl92oKHJlBR3V3M+a8DHiqt6e35yYGRkl7ukgKlwWsjrzINrI5PsPgog8m5Lj5iyg34QXpwxQvGXGOs+Bquk6/dmtHnNbmR4U0o4FHzanyNE6XkEsijv0ExFg1s7aLhjOUtp1KivbuowaHDwK5byWGBIvBx2lNt1sZG7GnC3FLlVyQ8zLMJNSPUFzw2cjdUS2ZH5zxby5TV0a1btbxkmFn4z5RSmpjUfu735Q2KSIbVa26TlnA1qvzgNWVmEu6sQw1pZ7S/HCFo60LzPqWPMtChovnMWEV15qWcxD25DZrdg4j9qKFBRb/4rxPj3QrrqXxlUKkzRNTP45qL6U8YsNrY8LLOBgLsJWpjsjSXhcjHAWQd51EhM6qiUppgceM5fhv14FJtGWYVx4O9yz01pIO/0LpZ/N5szY+bw555I+X3dfHxlxWvDinLU6WHR3FhHR7oSZ/cRS0gN8X3Oy6O5CboEyv2s6Z4pebxjeNX1klUKjhSWEfoNmfuBLGMG8DzuE1s8kRASBULJPsh7jhACNdUZXjFfvB7FcPWFuHOiKBSluO85RywSV8gEeBg0rq3AuZZ4LWDlxfjRLbFw7B4DrXYjlEtV5rtY1qoOrU+iutjSJeqKCIfp4dkRFyYJwpNQqlikkMsgsmAR5prSejRGcGTK9kIi/v3jMPlIZkZGaCd/UuUgAlxKHcOja/hDRRFuG60NnYUbWGGikVh/Hiq2fSlH1V915LjiEKFeCyuBCFC6sQyIvsctqeuFcSQFepc4NBe65iqXAQIzxtZeMedBVgtH/f7D5GYyzm
 pTtbjKVK
 KTCX5x6MeTHgN6Ai2GvknnsUV7Sd5F2ASz47ltNNDNOfooDyo/nlQxxUUyQK9CdU3St7zMKd1qyvMJ+JTWht1h06FSE2J6VgCVo+8mSgfgOPawUh+zWUJ6vMGYMZi7FYrp2Gvs022FJFkxziu3kSmMSrvuxpmVVjr33JNcpoYl//eAWWfzMTOBMutBR9dNHVrWbPi692DMGY6ZIX7QMRcUq+62zBvjNasEizOK+0+r3OB/Ne839ZdSDY7/jktjD3xp5iB/CTSUSbSscRWnigM/ZxkF+y0Wy3WKCmwiKR7boso/gmGSy5NNdvykmMlcD+I7JbhwPvVeNF21SLH2oZ9NswXKReVuIkqZheSHKAMRV6ljRP+B+XBDF0vW8KQll7Zfce6OgdSFvmo2F7/S/1Y9rR+QqynkYdwNPUXpgFIM1T6yB83oiCFsCrtBf7kMjJIMlb2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jane Chu <jane.chu@oracle.com>

generic_file_read_iter() now handles hugetlb poison and hugetlb page
size correctly, so we no longer need a separate hugetlbfs_read_iter().

[1] https://lore.kernel.org/linux-mm/aeZwAz6PcdlqSnJ2@casper.infradead.org/

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
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



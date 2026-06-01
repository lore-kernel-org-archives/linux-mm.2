Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14761CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 19:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B23F6B04AD; Mon,  1 Jun 2026 15:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92DAA6B04AF; Mon,  1 Jun 2026 15:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DB16B04B0; Mon,  1 Jun 2026 15:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69A5B6B04AD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:26:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2139E140754
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:26:37 +0000 (UTC)
X-FDA: 84832325634.08.8CD2421
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C6AFC0014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:26:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RDwq7RFT;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780341995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xE7nz6y5yTk+D+hCyFyD22HvbRBiBxqKUhasX87Gfew=;
	b=2IKicEFwYyI6GuWl7Ix8G5VFjIWank67IQnCCWJxFDwyyA4sDH0YJGK1o7BY3UjMX6vd9A
	WQOJfmEZj9R/NI101AsbgLDOWbghr5z3Y5ZeNcUuM6EpYevmNErpeLbwwnhCytMrRzf6LB
	PtW/okJ4GVGbwOEDyH/zK5lJrWDjJPo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780341995;
	b=Sj7R2RLQ44ewPhiXEChOdWZU62rF3dl4pKs9CnqxmRV8qrExYVf0t5nTbfyTSqgoLmJJaW
	FsOX2jsUHqXnH+5hcRjqYyrIeTit4yz282hHYEyu8e+vLZXxUq/teRoOwicKmZqoQ+FJxE
	m7VXXc/IUMCjxh6zRuvQEN34wYbzHTY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RDwq7RFT;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xE7nz6y5yTk+D+hCyFyD22HvbRBiBxqKUhasX87Gfew=; b=RDwq7RFTQuC1k+DOq8Lb69tdOd
	It3yfTDUq6MHftcRJ0y0CM/kcAcBN1LoeyT6Fs/1d7EBEf+s40PkjQirRdP7Y0Sc4gxcx8a1a8w40
	5Tvk0UC7s/y9b+rqwMvSqoH2Q5yBVWMPhEFFcxS9qLa42aH5KC4MD3WbujrjSpglSVAqqXCp2ovj/
	iwviQBPhwSI98vIkze0RR4eJoSqUDTdrdtYHFgCAHzGPXkODf9wEmjCp5imlOqT/+MLoJ6QAAkMVF
	0kpz8spr488iIT+urQWV4MCaj0xmwJ/EBQiJmQOebw8G3zLoOX6UoQfw7crEbMvzf43pV0vz5mST6
	aengo4CA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU8HL-00000000dEW-3wV8;
	Mon, 01 Jun 2026 19:26:27 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ntfs: Correct use of folios in handle_bounds_compressed_page()
Date: Mon,  1 Jun 2026 20:26:20 +0100
Message-ID: <20260601192626.150804-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601192626.150804-1-willy@infradead.org>
References: <20260601192626.150804-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C6AFC0014
X-Rspam-User: 
X-Stat-Signature: gmnfsjhki5df37nc59sgd391sacg3int
X-Rspamd-Server: rspam08
X-HE-Tag: 1780341995-706032
X-HE-Meta: U2FsdGVkX1+3+DsP3CJZGFXACl+qT8QUhSOG0Ihen0ccXZpva+krzghdny3Bgo32dpEvi2hHVX5OCqZmv38ZeIjRgtSkY8sA+xi4BjSBhxFFKeIta15B32qZgSXiLGWF8Ii1W/k1YQdxk4FaVOrmsso9Qglm6jtfISpggvWBjJ13WKGVbqymCItgBwpzs2qhwSz/rKuoc9PzwiX+pNfs1xDZz9R74LcQS+21V2UBVXucMcpqGoPugebSTWuKnGZ0XQvbla6lNCQqM8sBjoEINgUfXuzrwzKx+RwIsea/D46roxSz1dPE1zrGgKaMYXmnpvG4hGvZTLsXoTKTESAsftpSBCV2GHJbpUxvtFJlnupnU3U+ZYAgh3mhACofFBdEg4iYLNwFA/nxSN3n4l6pxHqO/3+owI+H/uCTF1big1nZCvpbFuvJz9aRKFPbbBoy9N/von0nzIWAyOP+NUENSSXa569F4Q/O2mG4D8UVDEmOYO7CL6A+1OQF+A0o+6L12wllm8ADqxHbNq1sdwgT9wzyJ8iKOTyVh86U44TeDzv14NdneQzvbdsbtz8NXwQ16ap074WlAO2aFPYKDBzo+U6rO4fqeQ3frMfX7mWT8CpBGPbD55qP3GA5aZZa4DAs+Ez8QSg2VL6enAXe2DQ5BZ4M0Bn+Ot53hppNpDwMTfT0Pl6b3aD3cWRc2pY6eXz6ZGVi0BEYHU9HqCE33YTIQ8+2K1biaJn7VoLq1gLvrSJ6JoT1rfjlyhkprOBFeaNv+wzsl9pfALAKp29di/1yYspRlxn0bMUhg1K7/daARE4jR7crVO+022Fp8ivbymTxMBTmQsYWXxyByKzdl/UqeX4C+l0D//21njQcDCNaie7NtkSA+YWAsMJf0Q1CtsWyu2WxaziLjDz9tzinw2leAIDzKY531FUTp+RCQiflDEzQNdSmiT/N3nNrAT2iWomEN2+QZXiLUTxw2ROio16
 L6kufACy
 2IJI3yJjfxN7gKZXd9W61Ub6um9mYjVGLZ5zqkRmqa6STm+H74FZfec+1XoCGIypiY6yogAle7C8yzRdWZgnJCRwSP+wkpFIxsYnM0MvD5n23PN3eEfmR9sklbpsiwHBhnvFamhYwg/ISZ7S55BGshJ2Ismhm480puBVb1n3P1froLscawO/N+HyNfrt7gfr72JwVO0Rr1u8nZ4qSQJSI2BHHqT7m5pnSSvhN1yGjd4XULZ318BXPV8TdHqt3U+8Rt/AdmWZpSCprD2TKeAFsj1BScYz11vZxwmgEbjIrpOsm15dSrx06goSE2m8ZHLvcxgKcDa2WNSX5oDiVSWOO3vYl+9Vt/0gB3iBnvidf89iIWCAktgKFnpojgdzo11N609gzpuH395WHVzoBR3uly0bus5pYV5Au0uIeYklFGcEnnySZWSPIW0DRDWqcWqt1ciIm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inline zero_partial_compressed_page() into its one caller, remove accesses
to page->__folio_index, fix highmem (page_address() does not work with
kmap_local()), switch to using zero_user_segment() which includes the
call to flush_dcache_page().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 495e90fa3348 (ntfs: update attrib operations)
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ntfs/compress.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 76bd806b41ed..143f362a42f5 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -96,26 +96,6 @@ void free_compression_buffers(void)
 	mutex_unlock(&ntfs_cb_lock);
 }
 
-/*
- * zero_partial_compressed_page - zero out of bounds compressed page region
- * @page: page to zero
- * @initialized_size: initialized size of the attribute
- */
-static void zero_partial_compressed_page(struct page *page,
-		const s64 initialized_size)
-{
-	u8 *kp = page_address(page);
-	unsigned int kp_ofs;
-
-	ntfs_debug("Zeroing page region outside initialized size.");
-	if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
-		clear_page(kp);
-		return;
-	}
-	kp_ofs = initialized_size & ~PAGE_MASK;
-	memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
-}
-
 /*
  * handle_bounds_compressed_page - test for&handle out of bounds compressed page
  * @page: page to check and handle
@@ -125,9 +105,21 @@ static void zero_partial_compressed_page(struct page *page,
 static inline void handle_bounds_compressed_page(struct page *page,
 		const loff_t i_size, const s64 initialized_size)
 {
-	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
-			(initialized_size < i_size))
-		zero_partial_compressed_page(page, initialized_size);
+	const struct folio *folio = page_folio(page);
+	pgoff_t page_index = page_pgoff(folio, page);
+	size_t offset;
+
+	if ((page_index < (initialized_size >> PAGE_SHIFT)) ||
+			(initialized_size >= i_size))
+		return;
+
+	ntfs_debug("Zeroing page region outside initialized size.");
+	if (((loff_t)page_index << PAGE_SHIFT) >= initialized_size)
+		offset = 0;
+	else
+		offset = initialized_size & ~PAGE_MASK;
+
+	zero_user_segment(page, offset, PAGE_SIZE);
 }
 
 /*
@@ -231,7 +223,6 @@ static int ntfs_decompress(struct page *dest_pages[], int completed_pages[],
 				 */
 				handle_bounds_compressed_page(dp, i_size,
 						initialized_size);
-				flush_dcache_page(dp);
 				kunmap_local(page_address(dp));
 				SetPageUptodate(dp);
 				unlock_page(dp);
@@ -767,7 +758,6 @@ int ntfs_read_compressed_block(struct folio *folio)
 				 */
 				handle_bounds_compressed_page(page, i_size,
 						initialized_size);
-				flush_dcache_page(page);
 				kunmap_local(page_address(page));
 				SetPageUptodate(page);
 				unlock_page(page);
-- 
2.47.3



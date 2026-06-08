Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D39CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8CB6B0093; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A382E6B0092; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926A76B0092; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA366B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4728C180B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:24 +0000 (UTC)
X-FDA: 84857978688.16.FD9796E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8CB8118000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eYvcnt5S;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+ZuF2r2Oud129G1tEYJnRmLJ02jsFWuNiWcn1m32OU=;
	b=6U3imdl8XUyqvZrDeE56yqwXiCTl8I2GfJssLv99evZq0FYnQqaTNvUfgXaxBwVT4SjgAE
	BGUNK4myCdpZRsIsZLM30TdDIJW1p0sMu8VdyPB6vNge2N+2XqfGHyFfw59kghzXMQu/K9
	HOxPreyXJOWXsH9AVNN5y2jVx4iBvMc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eYvcnt5S;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952783;
	b=1N/D5aT86cMY1DwmIt3s6QRQUT4NZTIxz6EnFz+dQdBJ82N1ursKKqW5iSV4+IJiXeUnxq
	zvERPmWFEc3s4Fr+1s/6u+I4JhL+lFdv47Y7g1XWMO8314O67k8ZR/ZuWN4viEuXTvBk5h
	Cbb1blxjwr+dMUirh91jdRXp1j7CMxM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=8+ZuF2r2Oud129G1tEYJnRmLJ02jsFWuNiWcn1m32OU=; b=eYvcnt5S6kwXMOOa4EbrcNpxle
	gFABR7F2zxEDFHd5pl+olcRm2361wFpKa7DvNpB4yF0EzJxk69XuVhapbTSPqrB2yPGsWWLotDIof
	f8fl/LXQku8tXoSP9AQdf1EmVkiFjRJqrvqIWEbijWc+GApzR4J0VXDf5hhhHLZePvZPNYJGFfX3i
	LfdfJE1XTPDG8rU/a4HMykfbmbfnEBJIPbKK6EXsVRAwV6Mz+1qCOyPA069Nc8Eex+43PH43YTlow
	Ly0TdX5enMacJ6GOVKRpLgThZAi9ch//suhsB3XdfCGxuS9/P3e0a4yGegVTVv4griv37n16k70pI
	Xe6srkNw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWhAq-0000000EQBS-3Ec6;
	Mon, 08 Jun 2026 21:06:20 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 4/6] ntfs: Remove references to page->__folio_index
Date: Mon,  8 Jun 2026 22:06:14 +0100
Message-ID: <20260608210618.3437216-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608210618.3437216-1-willy@infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8CB8118000F
X-Stat-Signature: 9r69oyuahi6f4g16bwdy8fji3o3hsd8i
X-Rspam-User: 
X-HE-Tag: 1780952782-968997
X-HE-Meta: U2FsdGVkX1/KDYxHuDgU3bWRkE1T4LetkaFBeyS3rfD4uBBFJK1JOfUDlXlZJ18P43zumDbC8MJbWrhqO0Q6FcyGaoWqlwZTGJrNQG2V4q1OxGzFip0QTXjB7PLnx4VBEpklVgFNnExIAuZKNrkPUqDZMIQ+7OuBcThQOFuovie7IU9bcG8ax11xjcc29AYvBOsw54Vd9y7E5RQWQ8m/vnJ7YNXu/wkyg5zwYfX2BjUFVnr2xVF8Al+old+9wG8N6eaCWH+CvgTCnAFP/LvJ8TAxb1HirKcmO2EJxpAAospSMxeqOKf2e88f/V9pdyBmXX9VbJGfRMCDHtUf/pYP9CN2MXafzalpBq71p435ubQvCcvjKuQ3KvZqdbWFX7ROc3mjOheuYN+9sZd1o9IGxGZvpueVBqPbMn9FGqwKA/Vs7offjwiYyoR4satHbBlBNPrylCfqRIWjvAbteGZwh7SoF7P/Ebu8sNcqBb2AeqCMla2OFk8KjfDKoksq7OGtmpc+p3LPpDJOG1tyGTSGYXIme4os8mPHT7p+PzbqXEic3AF9YRYUDOnx5RWzHnOpWpinVvhteQB0htrMU3oR0RhdH3jkRURtRoJIi6BCfAHbtM/OAvKxvG3VTsF/aC0jsBYbXDkfGgrC1F43MXJPq3Fh60/HCBakpzN2Bqt7HasrFph1rwQIW1BqRKMB02Cg/IM1VSZrSHi4iX5835IsRDHGwNbsvDS9pOpNZDDwoYUOB07fQNSyh4E9oL4oo+Od14s8YwUPNCkxDHNxtXzLdgm7UuYh3sse2gqgTluDkvjOm+DjKhjXD0REvqDXq0KDXu7RiMijT6Bn1nqlelF6Xdy7PIebp4HiZY1eIHUhegYC3+WISB1n9YdH05jwPKFXe7YovuDIhCB2PBw2LLOmCIqm+d4XSk6M6C3gQkCwRY5KqeKbBODqBzi2d6YhgOgzete1QTrmPf+a+GfAgUV
 f0felEfu
 T56ROdwcmnZm+1Ta1c1sgohwYWw6aZBhi+dsi5EOEchoMk2ZFi46qmlsFHLNn0p0RlmSq5bI7bPpaCazUh3h8yUppsy8BQF/Nw5b42HNBjdxs+dUDEypmGkk5YKgQtL2Xp+9EXPHiosgMAM6CZWM6ybpE3HELCeH0A+5Bf8Nhf7onrq54Trr8roiGktjN2A4tZxAA579OcjzgrlXoVNMzDdKG7C0Psjryv+quXBxng07qaCYo/vNpN991rq8WobiiJ2jtZMRcgY1HFXVybAg+D9u+FQSdyNBq4ggQvMMLi5cksJc+9Bp6hylcX3QJnoINdqhQ+xHCbj0DJxXoHIpsXuQ0oxJCL3zrJCvAUtcsk+dwILF9xKvR9pJKBTXjY+6rH3t8e8XbHy8Hh+6eiH0JeVNwldB+mrWJNU9pjOg6NE85smRJYR+QLnEWZRz8W5Vi5Nq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages don't have indexes, folios have indexes.  Correct this in
ntfs_read_compressed_block() and also remove a use of page->mapping
while I'm in here.  Also convert the calls to unlock_page() and
flush_dcache_page().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 495e90fa3348 (ntfs: update attrib operations)
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ntfs/compress.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 89067fecf5a0..eae0339a8518 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -455,14 +455,14 @@ int ntfs_read_compressed_block(struct folio *folio)
 	struct page *page = &folio->page;
 	loff_t i_size;
 	s64 initialized_size;
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
 	struct ntfs_inode *ni = NTFS_I(mapping->host);
 	struct ntfs_volume *vol = ni->vol;
 	struct super_block *sb = vol->sb;
 	struct runlist_element *rl;
 	unsigned long flags;
 	u8 *cb, *cb_pos, *cb_end;
-	unsigned long offset, index = page->__folio_index;
+	unsigned long offset, index = folio->index;
 	u32 cb_size = ni->itype.compressed.block_size;
 	u64 cb_size_mask = cb_size - 1UL;
 	s64 vcn;
@@ -811,14 +811,16 @@ int ntfs_read_compressed_block(struct folio *folio)
 	for (cur_page = 0; cur_page < max_page; cur_page++) {
 		page = pages[cur_page];
 		if (page) {
+			folio = page_folio(page);
+
 			ntfs_error(vol->sb,
 				"Still have pages left! Terminating them with extreme prejudice.  Inode 0x%llx, page index 0x%lx.",
-				ni->mft_no, page->__folio_index);
-			flush_dcache_page(page);
+				ni->mft_no, folio->index);
+			flush_dcache_folio(folio);
 			kunmap_local(page_address(page));
-			unlock_page(page);
+			folio_unlock(folio);
 			if (cur_page != xpage)
-				put_page(page);
+				folio_put(folio);
 			pages[cur_page] = NULL;
 		}
 	}
-- 
2.47.3



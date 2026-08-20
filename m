Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05985C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7724A6B00A9; Thu, 20 Aug 2026 15:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7236F6B00AA; Thu, 20 Aug 2026 15:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612256B00AB; Thu, 20 Aug 2026 15:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 396026B00A9
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:34:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A750C160294
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:12 +0000 (UTC)
X-FDA: 85122648744.07.D5B6A58
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2F10880007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XrQL0Q3p;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254451;
	b=Rcyr8ziFgONqEilY6S4tlD9mQStsXdZn4PZP9bBtiDWB0bT015esH3Dk8+ZiftZPpP5DLz
	Ti8YSGj82W3tikMplBxp57Trbr0PWVMPEwX2YBcXVXBfmsQ3H5XvI5UhpWz2xVZJjqScSW
	IMStmaiO6Vc40UiSAbiBdTsmUsqkTe4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XrQL0Q3p;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VKTMcP0i+1jQJg4IREBIQusP9YVDXmuicUrrJXB4D8=;
	b=MbFIHNxB9TpkUyIgG0itx9DM/fyqvwVG93B8a46XwQCS1ZhoLBDiVpxlw/K9Xb8PGPBbqr
	crxcyEGBgQUc/uHtFDg7yW+NdoglC9PE/7MAqCisNqUG2pLfAB84GI+u8E5sZ2id+jBFyS
	59ltVi8hU9D5qLSscW73FsNQiyDdAFQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4VKTMcP0i+1jQJg4IREBIQusP9YVDXmuicUrrJXB4D8=; b=XrQL0Q3prpwN0Fz1aYd6dOfMWI
	LVshGosyccqaZefpoTfBiI9z6sVc8R3ffIEQQB9xciXOZQtNNSfaKM3X5hav2VYB4EC1HLAkZkPwY
	57iIuaXGxcr937gqukmvi7qWNtlhKSoNx4DLx2O2useD5TQ6YmtUddqLdUreRp8MapKXTVxZQ510+
	G10LMv1PL8CjikpQWI734Yn8tnopaRH+22zS8wQ23Pp85wcdFgsMsZx9gAB+Ev0b8RSdI5Jr/so9A
	bWH/RdqWJwqWzeD6r3ohD6MJQKzIKXnVAOz97q+yQwjynkniCOJ8Ts0pw1UJzcqVdOG4RgQDwrXf5
	ZbZx0ccA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx8WG-0000000GALX-2xrk;
	Thu, 20 Aug 2026 19:33:44 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/7] filemap: Export filemap_invalidate_pages() to modules
Date: Thu, 20 Aug 2026 20:33:34 +0100
Message-ID: <20260820193343.3852967-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820193343.3852967-1-willy@infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F10880007
X-Stat-Signature: 3q519yb5akh4okdu7x87jb8h39j5cuzq
X-HE-Tag: 1787254451-743887
X-HE-Meta: U2FsdGVkX19dJC55JHd+l/mx3Rlqhk1OT9Qiszk6uXV5c4lOGmDoDLbfpAygaVry9B0/inwhFVVBjo49f5ptstIWyw5a38u+3bKbKGjfj4595sH13M298uSx4PWDxtlPOYeuRvC1rMZ1rKZAWpA4p9CniUz0mtpOsQ3jOmPYrGQeEa6x8QvqFrbXCq0Sq2ZtpkSpscxYhv8G5b4pe6sHyFeMz4R6oWb4Pg6A/BQG/R1nLNeX9/yEB6qYiDtzRKdAijzAWWdq2E0W9fBfegtSBwBHd5n4Y7a2E7xPRNLsuaSz1MowIRhVEH1npvVzSNCCCJI/O8mqz2AXb+f5d2aYfZ95rss7CayWr7/NR70xqZLufPFZxET59Rbw6KfHcdy1pP/q4R1uz7I0/ALEXQ4skZ74EIP3nYpwOlE15qqVQy4KTl/H/NB2TDzoQL3oWGlOQmp+1bfeZ6z2IHRbFb1jjfBJ+Gm58gRA9AHTpP4CGCzPUaGKJlvDQ0uq1EWLJ7VrcFMI0QJXkCq1cyJmEaN7OvJZSR1mQHxSDEjtBxQBV73BE2ABsG9u0LYku4mo7mdeY2H8NFIhmIflf4xz8MZA2KqcmejK2NjcJBCECJT2ojgfP+Q0QrvjOGzNgG0frCfERPY4disRVqIWN74zaGJ6dpT9Ue0DKaxQ36f73A8b4Y1bLX3h/NS0GkpsgAo6TdPlmCa7iR0cSIShNSmiR7Wqqvxp/JnXaLOBoBPRS1jDhzn/wjk8NbY5jK8Z40HIi7HX9kY66AOa1eURf+b2xZ2e9jYygQ1vwLUV3ReMxVbkfeXADTBRTyg4al6qvUAFE6cb9pV31iQSV4zOxMDYAcdGa2MbDXNfeUv9D5JCGwZD8hq4uQ6TEtiNlRTZyB4dHm4q+qivgQQuWS5NJ7MUNaD/d+/Pw1uGMj1o3XoTJv3v0GR5l0nRAde1u2cE0mjOy+gFqwSCNdo79saFpMCsvg4
 A4roUY/0
 TAXmrKPWX59YQgu9qNlrUHc9llqK0vJx7VMRzVmZsct1kJLRDcVy7apfNP3Ydhqj3vm4Kl3i4YyUqt2HXf0ZOSPZuwDVIZ42/lYBZR6zcZlSGxVMdOtDjusuQB8SCum06Y+vyRp5aK+o+wOIBa0E9O7vBvwv6KOATIPC1ZDGGqOt/DywWYnFUJRW0RpgRLLeOAU4jeE7pahp9jB3ELqdEwg1ukb86n5u8UECMVh9KNsLVZg8nagUY2Tj6Th/sU9pObKsb9DfOpg2EakzW+bYmepI1Wp50hSFodkFBnlH9kQApl57wBGM4QAAs+ukeLPP2B8C0HlNfsDc1JKaocrWxwG/v+LayAguF3T0v6EeQlR5H/RpwW0/5UxRr2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a better API for filesystems to use than
invalidate_inode_pages2() / invalidate_inode_pages2_range().
However, the 'nowait' argument is unnecessary for them.  It's also
wrongly implemented as it will call invalidate_inode_pages2_range()
even after filemap_range_has_page() returns false.

Move the filemap_range_has_page() call into the two existing callers
and add kernel-doc.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 block/ioctl.c           | 14 ++++++++++----
 include/linux/pagemap.h |  2 +-
 mm/filemap.c            | 42 +++++++++++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 3d4ea1537457..db5238b817b4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -908,10 +908,16 @@ static int blkdev_cmd_discard(struct io_uring_cmd *cmd,
 	if (err)
 		return err;
 
-	err = filemap_invalidate_pages(bdev->bd_mapping, start,
-					start + len - 1, nowait);
-	if (err)
-		return err;
+	if (nowait) {
+		if (filemap_range_has_page(bdev->bd_mapping, start,
+					start + len - 1))
+			return -EAGAIN;
+	} else {
+		err = filemap_invalidate_pages(bdev->bd_mapping, start,
+					start + len - 1);
+		if (err)
+			return err;
+	}
 
 	while (true) {
 		bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..ed99c8ab196a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -33,7 +33,7 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
 void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
 int filemap_invalidate_pages(struct address_space *mapping,
-			     loff_t pos, loff_t end, bool nowait);
+		loff_t pos, loff_t end);
 
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
diff --git a/mm/filemap.c b/mm/filemap.c
index d721986d5f46..fedb521d773f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2911,20 +2911,27 @@ int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
 }
 EXPORT_SYMBOL_GPL(kiocb_write_and_wait);
 
+/**
+ * filemap_invalidate_pages - Invalidate pages from the page cache
+ * @mapping: Address space to invalidate
+ * @pos: First byte to invalidate
+ * @end: Last byte (inclusive) to invalidate
+ *
+ * Invalidates the folios containing @pos and @end from the page cache
+ * (as well as all folios between them), so may remove more pages from
+ * the page cache than you ask for.
+ *
+ * Context: May sleep.  Caller may wish to hold mapping_invalidate_lock to
+ * prevent new pages being instantiated in this range.
+ * Return: 0 on success or negative errno.
+ */
 int filemap_invalidate_pages(struct address_space *mapping,
-			     loff_t pos, loff_t end, bool nowait)
+		loff_t pos, loff_t end)
 {
-	int ret;
+	int ret = filemap_write_and_wait_range(mapping, pos, end);
 
-	if (nowait) {
-		/* we could block if there are any pages in the range */
-		if (filemap_range_has_page(mapping, pos, end))
-			return -EAGAIN;
-	} else {
-		ret = filemap_write_and_wait_range(mapping, pos, end);
-		if (ret)
-			return ret;
-	}
+	if (ret)
+		return ret;
 
 	/*
 	 * After a write we want buffered reads to be sure to go to disk to get
@@ -2935,14 +2942,21 @@ int filemap_invalidate_pages(struct address_space *mapping,
 	return invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
 					     end >> PAGE_SHIFT);
 }
+EXPORT_SYMBOL_GPL(filemap_invalidate_pages);
 
 int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
 {
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t end = iocb->ki_pos + count - 1;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* we could block if there are any pages in the range */
+		if (filemap_range_has_page(mapping, iocb->ki_pos, end))
+			return -EAGAIN;
+		return 0;
+	}
 
-	return filemap_invalidate_pages(mapping, iocb->ki_pos,
-					iocb->ki_pos + count - 1,
-					iocb->ki_flags & IOCB_NOWAIT);
+	return filemap_invalidate_pages(mapping, iocb->ki_pos, end);
 }
 EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
 
-- 
2.47.3



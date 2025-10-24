Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE61CCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142308E0056; Fri, 24 Oct 2025 04:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A3D8E0042; Fri, 24 Oct 2025 04:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056F18E0056; Fri, 24 Oct 2025 04:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E41EA8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:06:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B12CD5D785
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:06:20 +0000 (UTC)
X-FDA: 84032275320.23.9C684AA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3A85220003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:06:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4hfAQJA3;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf03.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293179; a=rsa-sha256;
	cv=none;
	b=3G+cjK1YI8zZpDJfNy24jNmPQlRSiH0kUOj2fXdkRoubPcrSUcSNjNCptLDUzrda5Gfcs2
	vBcofVap+LLA0aPPjhDJEGuD3rr5FVR+xbAs6q6LjbqrKPzei/DXmldFKslttgvW8V0cLt
	Ilynk/oZd/SIwXqu0Mkae2aWJwhKMPs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4hfAQJA3;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf03.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5xkr4XmJjPQvb2MdEVftXia+X6i5Gwk5N6/ltFfj3A=;
	b=B03dX0FtmuqOAOupSmvbbd5gfMz6FgcbKETVMP3XJ2xWVlKA7JzHyLEGBFWfLXkI8BbOTS
	5l2/MH+NpdIJp86qB6/Y8pSTN490xI/7alJX7vUR5FHrqDC0D0XNP4wTLPepzfovnH1F9l
	y+0541YNOqowaEyWQ1wOHUjCzb0A4/Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F5xkr4XmJjPQvb2MdEVftXia+X6i5Gwk5N6/ltFfj3A=; b=4hfAQJA34diibzRB9j6FpjgscA
	j2GSpM9W9Piz8C/KKTKK9nFxs6QPJ4VNLHk14XNgb3ptHW3IEgOcHsAQ1ttCparGnefefzrLVu7yh
	0aS9zBBClbDjUl72om/4U8UmjjTNstU+Li/IFwwucTfArM2fn6WZ5wgiyqoaNPVJ4AXbcghkrjxQV
	H8SMv331u/xD+JCEkcqGqBlEXwkADHQP4jMevGF35dVqCjlyfQv5oEXtAmyhTjhxl5zsAbHUrTnhH
	gUJwU/xWtwUn1DE3RIUdMBDINvpSbOLjQXaJqGl2QRdpICZM17BeHLnR/mu0jnxdb8LMTVu34rK/k
	8KQzvgMw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCoP-00000008cNL-2sV3;
	Fri, 24 Oct 2025 08:06:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 09/10] mm: remove __filemap_fdatawrite_range
Date: Fri, 24 Oct 2025 10:04:20 +0200
Message-ID: <20251024080431.324236-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A85220003
X-Stat-Signature: xyhhkkebujt1zinxjubri9owokooxw6t
X-HE-Tag: 1761293179-852985
X-HE-Meta: U2FsdGVkX1+OWe6h4xKcI2NzvV6ib2fQFsNDJMq7Uz2z1isESELGp2tG4X6mL1Ep2eSjBmEWdFl7L4HHQJFnlHkHnMcJ9qFKSjJvrDaXd//TQqwH1yvx3s004y05oMiustg6eqQMrttVekeGj9FBRVmh5cSjqa3LwngY9bTtAZROI21xfBN9i9bUbJ8fmXDOcZ5NwF3khCbCizh9ITXsKux07lpG/tL8G0XTE/dqvCaXU3qtZTvIetmDjhjqFtSXE3Ho0cRnPkUx9/RBzjtChUiTIuniZKGY4HuXWXm1J6ws5psSKqlug2SEBA7mGcgQZYRIWNIMG8P3bCvoqPbDo3gOFCiCf5HnBUgsOFD4rz+rmmXctoYXaQ2IWL5ItjmqeADxlG5wK05XOOrhG5mw3ShNeHzlSSqBgpMxSjpgjx3IYmpYDk91KbDaIPVI/9h9gQehtYUPj4nb9I8mXQPy6HurmdFvtEGPqIPJAC9a1u0AEE6hcDGFTlKuLOAF/QbKLJrMW7HxUcmAtQFVLDobgHA/taYFugLSOIV2sHmFkducURIIsDPZodU8BNRUZrKzJjrhb3AXUDS4gVswc0qRzRE8ddRca21HOUXPo1odx74At9gTCevvQmCl7Rbm7M1lsiH2eFQAnF+kUbbWafE5crlntXa4p2iTATFAY3y7JuD4eE425aXzCsM5zdx38yygUVQH2SmDtDOjmGLNjh5H5nOlIrCF2rl6bDGmJupk5XlPsLZCZIBE1GE83emsT0X6ax0eeCJA/JJnSJNsjSdmDhYac4IyQdx37vSoKD9jIHkd42j2a5IvVo1XZJnNXwWq+4cc0pzYZhSxakPann1bfHDhxVbl4L3Wq9pjS5rE6YopNnmsnbwwvKfSDXo9sxhrYOzIlT7MOV80JlPBYcbYQJTWA1yQb2gw15a/9i7eW1KV/TST8WLJr9Y1Ppvm8CGyJ0IF7oclWmj0kZarelD
 TwEw84Es
 fmief0x7+f7QjvFs0JiDBUHCnrtbQHXPySr34eOs2er7TucDjui+Sl6NM/15V6LD/eU8azz48Vj2okOqxyDCGgon88Z7bA/JgLt2RFU34CX62CDpF48FMqP5P6p8keJsR285+iSPWAhb3tP5CB69r2goKvn51lGI1zKQmZ8Z1ryOxsOIARxcMtj/GogDwhz/O62dNTuFM+Zdse7aaQIEkZLdQRkNXc0HZxnlcRiuvz9yRgAVGjCF2awH2KOm/vd2IoTcVWGz9UXhAY9UWuqo1bi69tNA+FW8liLymG4vV6zIOBrV2sxREBOrOkZdmWHWr2+uxFUYwn2Bh0ScrqQrgQXur9iIurPQwJO+AZYvk+uD3a3VjtNVoQ2PpDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use filemap_fdatawrite_range and filemap_fdatawrite_range_kick instead
of the low-level __filemap_fdatawrite_range that requires the caller
to know the internals of the writeback_control structure and remove
__filemap_fdatawrite_range now that it is trivial and only two callers
would be left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/sync.c               | 11 +++++------
 include/linux/pagemap.h |  2 --
 mm/fadvise.c            |  3 +--
 mm/filemap.c            | 25 +++++++------------------
 4 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 2955cd4c77a3..6d8b04e04c3c 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -280,14 +280,13 @@ int sync_file_range(struct file *file, loff_t offset, loff_t nbytes,
 	}
 
 	if (flags & SYNC_FILE_RANGE_WRITE) {
-		int sync_mode = WB_SYNC_NONE;
-
 		if ((flags & SYNC_FILE_RANGE_WRITE_AND_WAIT) ==
 			     SYNC_FILE_RANGE_WRITE_AND_WAIT)
-			sync_mode = WB_SYNC_ALL;
-
-		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
-						 sync_mode);
+			ret = filemap_fdatawrite_range(mapping, offset,
+					endbyte);
+		else
+			ret = filemap_fdatawrite_range_kick(mapping, offset,
+					endbyte);
 		if (ret < 0)
 			goto out;
 	}
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 678d8ae23d01..d0a7dd43c835 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -54,8 +54,6 @@ static inline int filemap_fdatawait(struct address_space *mapping)
 bool filemap_range_has_page(struct address_space *, loff_t lstart, loff_t lend);
 int filemap_write_and_wait_range(struct address_space *mapping,
 		loff_t lstart, loff_t lend);
-int __filemap_fdatawrite_range(struct address_space *mapping,
-		loff_t start, loff_t end, int sync_mode);
 int filemap_fdatawrite_range(struct address_space *mapping,
 		loff_t start, loff_t end);
 int filemap_check_errors(struct address_space *mapping);
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 588fe76c5a14..f1be619f0e58 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -111,8 +111,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_DONTNEED:
-		__filemap_fdatawrite_range(mapping, offset, endbyte,
-					   WB_SYNC_NONE);
+		filemap_fdatawrite_range_kick(mapping, offset, endbyte);
 
 		/*
 		 * First and last FULL page! Partial pages are deliberately
diff --git a/mm/filemap.c b/mm/filemap.c
index 7126d0587c94..f90f5bb2b825 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -392,32 +392,23 @@ static int filemap_writeback(struct address_space *mapping, loff_t start,
 }
 
 /**
- * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
+ * filemap_fdatawrite_range - start writeback on mapping dirty pages in range
  * @mapping:	address space structure to write
  * @start:	offset in bytes where the range starts
  * @end:	offset in bytes where the range ends (inclusive)
- * @sync_mode:	enable synchronous operation
  *
  * Start writeback against all of a mapping's dirty pages that lie
  * within the byte offsets <start, end> inclusive.
  *
- * If sync_mode is WB_SYNC_ALL then this is a "data integrity" operation, as
- * opposed to a regular memory cleansing writeback.  The difference between
- * these two operations is that if a dirty page/buffer is encountered, it must
- * be waited upon, and not just skipped over.
+ * This is a data integrity operation that waits upon dirty or in writeback
+ * pages.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
-				loff_t end, int sync_mode)
-{
-	return filemap_writeback(mapping, start, end, sync_mode, NULL);
-}
-
 int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 		loff_t end)
 {
-	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
+	return filemap_writeback(mapping, start, end, WB_SYNC_ALL, NULL);
 }
 EXPORT_SYMBOL(filemap_fdatawrite_range);
 
@@ -441,7 +432,7 @@ EXPORT_SYMBOL(filemap_fdatawrite);
 int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
 				  loff_t end)
 {
-	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_NONE);
+	return filemap_writeback(mapping, start, end, WB_SYNC_NONE, NULL);
 }
 EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
 
@@ -689,8 +680,7 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 		return 0;
 
 	if (mapping_needs_writeback(mapping)) {
-		err = __filemap_fdatawrite_range(mapping, lstart, lend,
-						 WB_SYNC_ALL);
+		err = filemap_fdatawrite_range(mapping, lstart, lend);
 		/*
 		 * Even if the above returned error, the pages may be
 		 * written partially (e.g. -ENOSPC), so we wait for it.
@@ -792,8 +782,7 @@ int file_write_and_wait_range(struct file *file, loff_t lstart, loff_t lend)
 		return 0;
 
 	if (mapping_needs_writeback(mapping)) {
-		err = __filemap_fdatawrite_range(mapping, lstart, lend,
-						 WB_SYNC_ALL);
+		err = filemap_fdatawrite_range(mapping, lstart, lend);
 		/* See comment of filemap_write_and_wait() */
 		if (err != -EIO)
 			__filemap_fdatawait_range(mapping, lstart, lend);
-- 
2.47.3



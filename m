Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC42CCD187
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1938D8E000E; Sun, 12 Oct 2025 22:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B0A8E0002; Sun, 12 Oct 2025 22:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8058E000E; Sun, 12 Oct 2025 22:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA7CB8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:59:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93C9CB7497
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:59:30 +0000 (UTC)
X-FDA: 83991585300.08.3C150D4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5F70A0005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:59:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RKhYVfWS;
	spf=none (imf25.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MI0vHZhtJ1k9QEFLwQMKaIXmWsfgPbtlLeEIYHV3Ov4=;
	b=cEMusHMpadQE9PWFVXE4IMAxzwP2StnJFE6UkKdYC9LCKYL8bDJWgoas14+8XPoBn6yGJp
	IU0LhuBusiw110675N+SQBAMs84lp/3mNXIIgh5wFtlbUGkNuShxHRHCEEESl3+tUh4FQm
	JodZVyOiSjQJIO+Xqe8t6H0FeSqshhw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RKhYVfWS;
	spf=none (imf25.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324369; a=rsa-sha256;
	cv=none;
	b=OlWg2AO3tRsULJFLuBYcJY4AaaQhtESZdlOGkSWKi3LtUOr2QZ1tHm8FoZ6ZIck1gDrCgB
	ysqOapfiz0/7pSETNRKE+Ctggdl6KpUUejgDaV73h8YBqYwlEUkOB0X/3acm0ha8FdfSPm
	aZ7oEOpmpDFOBpb4vkRagfw/Cew2KyY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MI0vHZhtJ1k9QEFLwQMKaIXmWsfgPbtlLeEIYHV3Ov4=; b=RKhYVfWS0EBFO0UM80v8hmdBKl
	ns8TwelL0DUYkZ0VBMaapzQENCJI2kHbtG+DjRkof8h4NJr9WSA+QCcmAbPr4mW3dmx+vueab6G2H
	mZV5g3rbo1tspoHLUCyUmxiOI3NVvsu7oJY9FPQZm3tYn4vR2Rt8Gb5HWYGSth0+5KyYIYr3Pf4vg
	kI590qr0NMriRzuTJBxKtLPxkdVlw4VRgV6PiFIZiHP1sDutUc4V273JL5CylFxsOdPl4/CcihQB+
	X1GxQSe6FFBfj+RQXF2KvIufIejJtnkYax8vKi7lf1gplPU8+tYEuw3LoX38gWSLgkhBt0pJWRKPs
	PP4yuq1A==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88mR-0000000C8QN-3xsq;
	Mon, 13 Oct 2025 02:59:24 +0000
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
	linux-mm@kvack.org
Subject: [PATCH 09/10] mm: remove __filemap_fdatawrite_range
Date: Mon, 13 Oct 2025 11:58:04 +0900
Message-ID: <20251013025808.4111128-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5F70A0005
X-Stat-Signature: aobj47hxis53zaizf6f56ipafns8wfxt
X-Rspam-User: 
X-HE-Tag: 1760324368-937302
X-HE-Meta: U2FsdGVkX1+JowZhDoERSy+MXAf86sj+JJ8d9qQ2QCgkCQZ5B/pHPNQWUlhcUR1JySo+OPRtcNN08SXmTy7agU9eaAuVjjrvtpZ5fQzyfrD2IE9vifI3tKzW53lOk6A5r6Xuq6s8N6lFAfZ2JB/bV9hpa027w042+oNBXOo7cw7/lSdtVBf71kjSLfVVbKD4afAxhGFwtKq/2//dyRV3taubzALBmAbyUNbrExL0PUOtj/6mlBIuYwxj3JmU1MnxXSe/mH44RUdeskNtXVFPvEbo0mHtXK7IH5lALU90lRMYXyU2PkgB6RGr/7MxvFqL5ztI18YS3LASuQTNIelKTgknBsvZmVvkQrroyEZWsRtR8ydUUEWG2mIGTSm67NMJZhdsXpTBsz44sjHsKlqF5vDpNdCn/OzlHTyK6g0izy9tgIhCAYQhoEnuVmsRzWeeytkcLeOJNMh3rrQ+bzq8bxZoQYbaAbcz/qYzSgC8QUWaIYy6cZvBQhpC7vuNd40FHr7spOQjYTjJBeaRgKSUCeNzFHIOAXTwRP10130KTFSCFzRSB7ka3ZAnLfQ7gYYKaWzRMJvhlkuj3ATbjn2qVQ//VgYzBOJJj0TcC3pV/oi7oXq8w+jIKVk50oAuenT4Z7KSJWyupdd38yTuQkpcBRXbFJZbYc8FcYi4xtFNe5qnh4C47EaVhSz0uysJ6juXnRfd/y9D5GQ12p2wofsryccRKtAZMVhthtkdeE+S7SeIWQ8Fbrlr9trdHUzl0RWSWwNmpnNHz7qmj/YsOENHGLCC4Ft5hzOG3xWnCJxU+VNcLXJrHnSyn+vwkC+yttAG6Cy5Yn8IkZocq6yFn9BumkdL3xU8hQRf+7ezw/sXgBb4RNp8mH/QW4KE4aBgSGIY5byOKggfdeHU5F16Jm6cyvLWDtCnz/G2UDTfsKll7d66M1/jOWql6wfepxV6WOFW9W4Q7szzhtxrvDYI81+
 /+L1JwYm
 4ftY/dIrpr6shcZr5gZzzwQVQ3zBDHXydQ9Qg8oSTJJngRJbPt3CzI48rT88ahw0rz4y2iiZoQ9stvmwmp0JMHgcbR81XOce75RWb0cRSRfO6alVTXMmal33QAgcfqpvVSGb1CLoSGHmc+ZPNQVtCHZBicz2HocHcbUH2Ewi1fEc/wvUGsT5MTThml3SUBIJ6l+v/AOasHtDon53SXLLxDHx6wY5OMwmeih/x9lj88+9H7TUeJH/y9qfs1UjIeDpwMGhIK9bu2KDWm0n7c3ODQ0Aho4FvwKbaPAuBHsGuTsFwTvyN4RMD2p1SitGhUQjZ4Zp1JJv1HzTZxtHBXu9dXle/YWjoajNsX0tahBo+SOLGt4a3/aUqxYxp8lP5JeoX7+LdEAEplhaayFpWXoz2HJrb6Vsx5VaDUrWUWoMQK7cTWUv6a529eN+waM8tdKxdDtg8BDY+ynmXwhuVIhi/vV4ROUjebPQwVlqXeTCH+HHV1HALhmpY0ilSsysAMu0pqs3B3HZCsLOq69s41ecrW5UbwBbB65OW/g+WWHrZXM5dx/f59LWbySXxwoHnlK8VMv2uf5uSemwS7Ja38c4y33Q+lX+D0hdbVO/K8+rPCjvmkw8=
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
---
 fs/fs-writeback.c       |  6 +++---
 fs/sync.c               | 11 +++++------
 include/linux/pagemap.h |  2 --
 mm/fadvise.c            |  3 +--
 mm/filemap.c            | 25 +++++++------------------
 5 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..8b002ab18103 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -807,9 +807,9 @@ static void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
  * @wbc: writeback_control of interest
  * @inode: target inode
  *
- * This function is to be used by __filemap_fdatawrite_range(), which is an
- * alternative entry point into writeback code, and first ensures @inode is
- * associated with a bdi_writeback and attaches it to @wbc.
+ * This function is to be used by filemap_fdatawrite*(), which write back data
+ * from arbitrary threads instead of the main writeback thread to ensure @inode
+ * is associated with a bdi_writeback and attached to @wbc.
  */
 void wbc_attach_fdatawrite_inode(struct writeback_control *wbc,
 		struct inode *inode)
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
index 742ba1dd3990..664f23f2330a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -55,8 +55,6 @@ static inline int filemap_fdatawait(struct address_space *mapping)
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
index 26b692dbf091..ec19ed127de2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -392,32 +392,23 @@ static int __filemap_fdatawrite(struct address_space *mapping, loff_t start,
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
-	return __filemap_fdatawrite(mapping, start, end, sync_mode, NULL);
-}
-
 int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 		loff_t end)
 {
-	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
+	return __filemap_fdatawrite(mapping, start, end, WB_SYNC_ALL, NULL);
 }
 EXPORT_SYMBOL(filemap_fdatawrite_range);
 
@@ -441,7 +432,7 @@ EXPORT_SYMBOL(filemap_fdatawrite);
 int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
 				  loff_t end)
 {
-	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_NONE);
+	return __filemap_fdatawrite(mapping, start, end, WB_SYNC_NONE, NULL);
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



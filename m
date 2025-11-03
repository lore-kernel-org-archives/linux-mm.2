Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20D7CCFA08
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 01:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE988E0016; Sun,  2 Nov 2025 20:49:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F818E0015; Sun,  2 Nov 2025 20:49:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD9C8E0016; Sun,  2 Nov 2025 20:49:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A509F8E0015
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:49:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77AF01A078C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:09 +0000 (UTC)
X-FDA: 84067612818.17.6ACC932
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E10454000E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=FP05s2qm;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762134547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=yoNGa3BIGUupq3nqv1c1Texjxp2LF49BQVW1KnxuAHE=;
	b=famcRb0AvveH1t4+7M8xWxuEu/8tPt6d7ovxZah/GUF2snCwgzngmLAEio2V9bLFRBxs6n
	mBKVWfQgj6gbF/nxyINU0ljj02h3zz4uiXykMVeoyiup8CH9IMza+k90c+1pj9sXpMQZ3Z
	ed1Z3kbA7f6K62b/cROObSacm/nOEVk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=FP05s2qm;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762134547; a=rsa-sha256;
	cv=none;
	b=TNhqf3F0vcL7onVPrTlpJvfTYVsgOiW5mlgy2nVD3MtUOtgx6K2518S6AdjTQfmcdblV3S
	BzbOC7PywJATNsyQBkARxyvGrEJNmAJhcYxrZD+eQmJu4ix02kC2YG81JDPTD22R58AxkL
	CrgWABcn35Jc09d7zEqbvGdyw49o/Io=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E77360288;
	Mon,  3 Nov 2025 01:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8866C116B1;
	Mon,  3 Nov 2025 01:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134547;
	bh=oD5MGG3WGGsNK9lAnNSf8zWYE8mFT+Bpvl/9vNMGYqg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=FP05s2qm1BM57b7XuRGGEFR69Np5D5EpyCbVrxW18WQRNZkMbIWHMz8hiO0ypbTD+
	 y8tgk1OSUdezYg0Ehcyl+1X5XAhT2oqwW9MZZsC1/RMgtWl+3OaHXYZLiPGSXaOM6B
	 KRBTsMztFj/Fa9xOr/++l6+/UXkuLVwERBZjnMX8=
Subject: Patch "filemap: add a kiocb_invalidate_post_direct_write helper" has been added to the 6.1-stable tree
To: adilger.kernel@dilger.ca,agruenba@redhat.com,akpm@linux-foundation.org,anna@kernel.org,axboe@kernel.dk,brauner@kernel.org,chao@kernel.org,djwong@kernel.org,dlemoal@kernel.org,gregkh@linuxfoundation.org,hare@suse.de,hch@infradead.org,hch@lst.de,idryomov@gmail.com,jaegeuk@kernel.org,jlayton@kernel.org,johannes.thumshirn@wdc.com,konishi.ryusuke@gmail.com,linux-f2fs-devel@lists.sourceforge.net,linux-mm@kvack.org,mcgrof@kernel.org,miklos@szeredi.hu,mngyadam@amazon.de,mszeredi@redhat.com,nagy@khwaternagy.com,trond.myklebust@hammerspace.com,tytso@mit.edu,viro@zeniv.linux.org.uk,willy@infradead.org,xiubli@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 03 Nov 2025 10:46:57 +0900
In-Reply-To: <20251021070353.96705-4-mngyadam@amazon.de>
Message-ID: <2025110357-cornbread-cold-7221@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Queue-Id: E10454000E
X-Rspamd-Server: rspam03
X-Stat-Signature: sr7here4criiwhrpnjim35eh3e3m9ruk
X-HE-Tag: 1762134547-469917
X-HE-Meta: U2FsdGVkX18FHIRU1APj9WEHjiNJbry/ORgpSfApMsJeMPNLfUGL/2ps5aXRUHdy/mB/juVLeRVzMj3c37VtcaWrIF0YKT62W5u9WruWHssmW9h8lgU+Zb0ysiFkXvTX0FdNyY3V3rvKWYIdZXdYInKPuJyZZQxqc2ksLz2q9fUPbxds0566Qfex+4fEAToZW2yuWIR04AOaCrAd6e30czF21iAtTl86x693mTXdp6PXcLBMCU616+bjZaveYBWHlpuBBfcOp+lwpfJJQB2Fb86VvKzO9zuYEMEQLaeiW4rOAO7oMZT7RZ+Jz2rmzci98P1tMwohOTLL6x7BYgDjGRarMu2umh2aHXXCQvbWH1cqFK4Wouik8EtoEdMVhIgqNphJ2sMkxs7T3ypcgGCSRNq1j3QlradG2+iWXj6YwGuKw4hE9GNe3O+M+cBGgDZWQx9q2bRem+ma0hy1X1VfaIWIDb4ttfy0jOeVBEL+dGEqJbOHq7dKlppqc5wndHlBg2RJOnAo1Igun8ve24ikSiFN26ga5tM0tqHD3YXGeVyoEoLay2QC2phCaj8/0BupAy83ZhMHzzhXVyrP+l6EtbpEdOCfa1zd1ETCKRVrvcjSyfpNq9tb0icLeWifdyZs9ya2C2qoVQs8v2Qc9hMZeoy16DRPXBuUkQ/Ju2vYayjLHZz1RURBB5HeVFdACq3ZVUKrQJyAZ7JoSr7dHsLhvIO2dbKeCvkYrDwzMgGmmVYqVktHWfzEl8Q9xgrrRFSOkGIlV45WntGLX76wBZzNrab3nOJO+2udRJVX3W+AKE+h93XKkNRT5e+0K4Li+PihxL/9UUt3hhAHfiH+U0qsbEUXV/sm4gQA5fiEhZV/VGwUGAb6hcHBeK7pgMkqzyXg8jW0RGp3h0uFvr9VTFkw1bC/MG16kkv8jeHKTyUR8tnwxkevONPgxJspXxkCGS2FWDInX+K3FRcCvAQKAJ5
 LFHDuH4S
 ZfFRg8/bkxMLY9fb+M5don9RxUbDXkHTO2QWc/KQafht5FIEKuNm3c+AZMVHRu2j5RLB7dyBmAJovaz3QSAo1wbkHXUNNU21HKoWkmE7mFXHDmEwCZia8e7P3SsjRduTZtHauLgK7llBNddy0tOXnYJtGL3WrIykQRxnHgCXDvZYTVpe6+XBAJ0Vq5OvB/2txz8BswNkaE6VOgb0ubf1H8oYfT0G9Y0s5IBvX6trvcbWwoIfN14MIDFwvEkkE87tLKGcRb8JAkDDlluS02Lx4vzQMaOgfqvOJgQST/dzSC6hKmPHsyKhnxTNF7VXtPI7A4r7JxyfoSTFxkgdnyjkG8FhzuXFN4IJwWej4ovyKjzniFNMCTlE/89cTuCozB4BTjy2NEmjbJLzRtiOpQbYzL7OdeWy+iHEFvZtbsmB7USnJ+6AhVthkMJjtP233mS0lfT8aarFITLn/4p1VMbmMYuy87GW5QHO/sWoLeBe63+DnRBa6uJJp6d7J/hr5UmnMhD7NITKvaOUHwjFOjLvmU+gY9tih0NoBsGYAll90Ju5Xk8uFwTMLqb8GCot1r3BXIoAGpioS4jJjlUlOmaIsbP+DRbexFQXsTj/xn1FwMLqXSC5KxoYqMWNBNvocteirf3TF4Goul+eraRkgRimOx8HZMHfTYJz7UGWyGCvaeLUajNFuPLI0QITxuzrTqn/9shlHnkO8hzI0NOPVqhcvIQfePtGyI/0Q4a7gbEDOpmiJKoSSKA8K8zIZhoU02CA9oum0mL7MxXpOf8KwOD1iPykY8fOTM7sHiFxPdNGkAUgoimCGN/9GAz/xuV20w7X7Zympbv6vW5vv1cGh0tv2JX9XzDoIrtJxtRT5XjT6BUxq8EIcN/tHEEjHfUsHGopj/oLvwbn13Wu3/MnGUic2oyV0kLYPx6oYTYNblA6m1E49NWV8/DDWlPzjrpUJwebuJs/1tNL/VoIhxWSeAMCrJtmH/zH1
 qSnXmRTm
 IX+YMXbJj5P19peUqRjYtXpR62wue0pSDwBmTThVJZAV9HLJir3xRop7UiYRW9hOkx6gbwnp8jBZHE74Z4Lzf2vhu4oVAHfaaX63t0dcqBwiPdlIIaQ0WUTXYp2llY+PGPRb5euXdP4WGIvpOm+ow5o0exODN7+aLOuLh1aIa89pAHKey3gVtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    filemap: add a kiocb_invalidate_post_direct_write helper

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-188297-greg=kroah.com@vger.kernel.org Tue Oct 21 16:13:23 2025
From: Mahmoud Adam <mngyadam@amazon.de>
Date: Tue, 21 Oct 2025 09:03:37 +0200
Subject: filemap: add a kiocb_invalidate_post_direct_write helper
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>, "Darrick J. Wong" <djwong@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, "Anna Schumaker" <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Brauner <brauner@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Matthew Wilcox <willy@infradead.org>, "Miklos Szeredi" <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Xiubo Li <xiubli@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Jeff Layton" <jlayton@kernel.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Luis Chamberlain <mcgrof@kern
 el.org>,
  <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Message-ID: <20251021070353.96705-4-mngyadam@amazon.de>

From: Christoph Hellwig <hch@lst.de>

commit c402a9a9430b670926decbb284b756ee6f47c1ec upstream.

Add a helper to invalidate page cache after a dio write.

Link: https://lkml.kernel.org/r/20230601145904.1385409-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/direct-io.c          |   10 ++--------
 fs/iomap/direct-io.c    |   12 ++----------
 include/linux/fs.h      |    5 -----
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   37 ++++++++++++++++++++-----------------
 5 files changed, 25 insertions(+), 40 deletions(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -286,14 +286,8 @@ static ssize_t dio_complete(struct dio *
 	 * zeros from unwritten extents.
 	 */
 	if (flags & DIO_COMPLETE_INVALIDATE &&
-	    ret > 0 && dio_op == REQ_OP_WRITE &&
-	    dio->inode->i_mapping->nrpages) {
-		err = invalidate_inode_pages2_range(dio->inode->i_mapping,
-					offset >> PAGE_SHIFT,
-					(offset + ret - 1) >> PAGE_SHIFT);
-		if (err)
-			dio_warn_stale_pagecache(dio->iocb->ki_filp);
-	}
+	    ret > 0 && dio_op == REQ_OP_WRITE)
+		kiocb_invalidate_post_direct_write(dio->iocb, ret);
 
 	inode_dio_end(dio->inode);
 
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -81,7 +81,6 @@ ssize_t iomap_dio_complete(struct iomap_
 {
 	const struct iomap_dio_ops *dops = dio->dops;
 	struct kiocb *iocb = dio->iocb;
-	struct inode *inode = file_inode(iocb->ki_filp);
 	loff_t offset = iocb->ki_pos;
 	ssize_t ret = dio->error;
 
@@ -108,15 +107,8 @@ ssize_t iomap_dio_complete(struct iomap_
 	 * ->end_io() when necessary, otherwise a racing buffer read would cache
 	 * zeros from unwritten extents.
 	 */
-	if (!dio->error && dio->size &&
-	    (dio->flags & IOMAP_DIO_WRITE) && inode->i_mapping->nrpages) {
-		int err;
-		err = invalidate_inode_pages2_range(inode->i_mapping,
-				offset >> PAGE_SHIFT,
-				(offset + dio->size - 1) >> PAGE_SHIFT);
-		if (err)
-			dio_warn_stale_pagecache(iocb->ki_filp);
-	}
+	if (!dio->error && dio->size && (dio->flags & IOMAP_DIO_WRITE))
+		kiocb_invalidate_post_direct_write(iocb, dio->size);
 
 	inode_dio_end(file_inode(iocb->ki_filp));
 	if (ret > 0) {
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3371,11 +3371,6 @@ static inline void inode_dio_end(struct
 		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
 }
 
-/*
- * Warn about a page cache invalidation failure diring a direct I/O write.
- */
-void dio_warn_stale_pagecache(struct file *filp);
-
 extern void inode_set_flags(struct inode *inode, unsigned int flags,
 			    unsigned int mask);
 
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -31,6 +31,7 @@ int invalidate_inode_pages2(struct addre
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
 int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3733,7 +3733,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
 /*
  * Warn about a page cache invalidation failure during a direct I/O write.
  */
-void dio_warn_stale_pagecache(struct file *filp)
+static void dio_warn_stale_pagecache(struct file *filp)
 {
 	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, DEFAULT_RATELIMIT_BURST);
 	char pathname[128];
@@ -3750,19 +3750,23 @@ void dio_warn_stale_pagecache(struct fil
 	}
 }
 
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+	if (mapping->nrpages &&
+	    invalidate_inode_pages2_range(mapping,
+			iocb->ki_pos >> PAGE_SHIFT,
+			(iocb->ki_pos + count - 1) >> PAGE_SHIFT))
+		dio_warn_stale_pagecache(iocb->ki_filp);
+}
+
 ssize_t
 generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct file	*file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode	*inode = mapping->host;
-	loff_t		pos = iocb->ki_pos;
-	ssize_t		written;
-	size_t		write_len;
-	pgoff_t		end;
-
-	write_len = iov_iter_count(from);
-	end = (pos + write_len - 1) >> PAGE_SHIFT;
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	size_t write_len = iov_iter_count(from);
+	ssize_t written;
 
 	/*
 	 * If a page can not be invalidated, return 0 to fall back
@@ -3772,7 +3776,7 @@ generic_file_direct_write(struct kiocb *
 	if (written) {
 		if (written == -EBUSY)
 			return 0;
-		goto out;
+		return written;
 	}
 
 	written = mapping->a_ops->direct_IO(iocb, from);
@@ -3794,11 +3798,11 @@ generic_file_direct_write(struct kiocb *
 	 *
 	 * Skip invalidation for async writes or if mapping has no pages.
 	 */
-	if (written > 0 && mapping->nrpages &&
-	    invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT, end))
-		dio_warn_stale_pagecache(file);
-
 	if (written > 0) {
+		struct inode *inode = mapping->host;
+		loff_t pos = iocb->ki_pos;
+
+		kiocb_invalidate_post_direct_write(iocb, written);
 		pos += written;
 		write_len -= written;
 		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
@@ -3809,7 +3813,6 @@ generic_file_direct_write(struct kiocb *
 	}
 	if (written != -EIOCBQUEUED)
 		iov_iter_revert(from, write_len - iov_iter_count(from));
-out:
 	return written;
 }
 EXPORT_SYMBOL(generic_file_direct_write);


Patches currently in stable-queue which might be from mngyadam@amazon.de are

queue-6.1/block-fix-race-between-set_blocksize-and-read-paths.patch
queue-6.1/filemap-add-a-kiocb_invalidate_pages-helper.patch
queue-6.1/fs-factor-out-a-direct_write_fallback-helper.patch
queue-6.1/direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
queue-6.1/filemap-update-ki_pos-in-generic_perform_write.patch
queue-6.1/filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
queue-6.1/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
queue-6.1/block-open-code-__generic_file_write_iter-for-blkdev-writes.patch


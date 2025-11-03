Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A28ACCF9E3
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 01:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB86E8E0011; Sun,  2 Nov 2025 20:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69958E0002; Sun,  2 Nov 2025 20:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A258E0011; Sun,  2 Nov 2025 20:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B16018E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:48:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FD6FC0AA6
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:48:58 +0000 (UTC)
X-FDA: 84067612356.22.CDABB92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ACDB41C000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:48:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=KtkocYiu;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762134536; a=rsa-sha256;
	cv=none;
	b=FViPGfnuQ7e+THwglFa00zhWa0nqU22xI8Mqybo8H4DMCicV/liEj+mgua6P8WbR1H4xGK
	5aV3Y+dY5mt1cqurRxjDnlnriObbGSRqPOGwaiEYEj3+4dSTWynngzadfOVOHHrshMgMRw
	Ehcp4d/TRd2lth4kBLeu0CkjmZYIlnw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=KtkocYiu;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762134536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=WmeC/8ZZQQkT4nDLFEB2O/tMWzlCDcbJzq8WmRi9EUE=;
	b=k95++xYZ8sK9u2UYn/3yLSeB7HyQUZwpfzXl5Y1cN/RJu2CYxMXiRb1JvYEfxS+2n6DFlR
	lacBNd+vn7ItQB8S+m/jdqvsEJmShTVTatzvFhzcU/cSn4Oi8M3sZoGCukNAbacH/Q8Ht4
	ex5R2Cvi8jl2PrBtmPXve+imlYLKiwQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CC7660282;
	Mon,  3 Nov 2025 01:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E594C4CEFB;
	Mon,  3 Nov 2025 01:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134535;
	bh=K+l6n/WGoGMMfGGoVu3pTyL0SCoEaujvnY6f8Mgxr6Q=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=KtkocYiudfdwgI/CFG913fw8BISy5rIXVHZqBo1KPWpdkr2pw40zlsnytuRqQNhQO
	 obVTAHRaUdZCKa6jxOzRFdvTsA5dcFU2iry0YCfW4Qd9rrEMgLD/U1roxcWqrmXPtE
	 yV1CbG0txjBpoxKP2suSUY8eufgHue0K9ZdvNSzE=
Subject: Patch "filemap: add a kiocb_invalidate_pages helper" has been added to the 6.1-stable tree
To: adilger.kernel@dilger.ca,agruenba@redhat.com,akpm@linux-foundation.org,anna@kernel.org,axboe@kernel.dk,brauner@kernel.org,chao@kernel.org,djwong@kernel.org,dlemoal@kernel.org,gregkh@linuxfoundation.org,hare@suse.de,hch@infradead.org,hch@lst.de,idryomov@gmail.com,jaegeuk@kernel.org,jlayton@kernel.org,johannes.thumshirn@wdc.com,konishi.ryusuke@gmail.com,linux-f2fs-devel@lists.sourceforge.net,linux-mm@kvack.org,mcgrof@kernel.org,miklos@szeredi.hu,mngyadam@amazon.de,mszeredi@redhat.com,nagy@khwaternagy.com,trond.myklebust@hammerspace.com,tytso@mit.edu,viro@zeniv.linux.org.uk,willy@infradead.org,xiubli@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 03 Nov 2025 10:46:56 +0900
In-Reply-To: <20251021070353.96705-3-mngyadam@amazon.de>
Message-ID: <2025110356-unabashed-boat-8cee@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ACDB41C000A
X-Stat-Signature: ms4xmi7odzobwiwuymuu8hpu5orw1cwg
X-HE-Tag: 1762134536-42709
X-HE-Meta: U2FsdGVkX195TlsZy7NVZVPDowPIvEmAuaCzmXO+MZPIyjhcxeFMKlfdC6zP3pknRmK3zDbYENewVsPLywSCLY6b9lV/ydaebVKAYPyB0yCyMz4QpT2yXHOy8cTel+Np6fyxOR9FPQ/F5leUS88YY3o+GNK0n++N0q9H+nDvt+XrUYq8Q0GEAB7euVUBnR66SzrCPLFX0BV+lPRJZMOuDDg/ldQHB6yEjiyktLIsK7Qbs5G6c6ICXLf2xpWMgslEpbP+WdLGqDLAImdKgxun0yVGS/bvN9zgroQa9wKNZvNx3aEtTQo3vPA35tJACaSLes3sQ8AOTMObIFQP1RnVeerK1A7wIx5wBaPHrtIeTcbjYEH7oQOSFXa9OAiOOHh4S3NNZ6I46l6QMBZEg6BneapSpjDhFeN9c7jj13MXGEn6JwQ0TmJtaqSerTl6cWMF45hXOvyufZPTbC7AEhgEZk++8lH10mce1LYOlvGROyOtHo6Dw8D/XNHEfk1bBfmhxeILL8xwDgsTjb+zDl4CYupLlYE4/oomdVuNTOUvsSi9FBBBToYQIMMp5mXzs+vHfp58eMd04MTSlpMxubVvYbq9B57IhBt9XULzbzx6P2VjJa8xrsx6eLWpzby436W8gRHVRDaSgBWcGgS1oP+Is8einPm4tnsiJhXgnLgvPKQmDPf+SzEi3YbUUhDVMRUtAmNLmIccZweXHpGcnCRjzdEeYG/4wSvbixhdaNIJJHFKJtHqNZcUs4iLi1+tgZJ4YL6FvYefK44Vi3w8RvNX93vs4924x3XZeyXCXVOM8Q4Cl4xgIyef3HNh9jBa8zQqH67bOajjk4NXqgeUi4AMgzjOGbGLbaPDXfIt0MobS07gHcR+z3P4ltJ8hQ3SPPqefQQjRBcy+VoKQgL2lFs2UvtoKYnQqlJjkmXKTr3Ij550uE7qnPjTmDZxOoOc2RkRIoWqUXN+CcW39K0Y7cT
 5PTckJiL
 f9n42g9dUm4XdYKsur7dirH0iwvlAir3wbHxq1r691b5iWimo0tAVOpVsrKkMznPDzLY3FnbRhr1zlBu90XRu1IRqT8h92HIk61xRb0dk6yYAebIV2001+3pgOdKV7btI7ER2PZ29VGZRrkvlqyXL6Ar0r/Z953rMDgIGD0yWTLxM6rfzcWn3eGJ0f3bU3NzuYCyiGxXnUdyOtuBOyXV9fKv4jp0H0yELhu7tSivGuKvGTn6wU/SccLvC9JEkAJCuHLD5fpJIBMCMX++wvYP2d56qsVWmUqfAlVXFJ950YzOYYWsakdaGModPPOzJ8CcxryT/OB+50ErXht9hjvkGSJuK1PB6hJhRSmg/lUE3yaU0xX4/+nTeOdsLFG3IPjH5Aiv0qJHTl6+WGMKtcpaOpjmcGt1Agx1uqTZfkc8wjUMC7exjLII/fZYPfD9d1QVkVDMFMPLkJeLB24Xsc09jCWfEUQS6eiZTbVqQ3//AVY6Tfgtp1sqIznyMPbpGD3o7nt1ajOfvN97e9wOtNMBJTGDaFqUvQlFP/whven9Tzq8BJeewmQiyzkrgI33QCskzJEyQbHlaOcws2l++xp9tIZnkCX76Ooq/G9UBkgt6mu66bBUhkmMvMmpEvi0nBYCPgo9+qqhdmECHQ3XuQ6yJ0LGtmyPQNPxTZYldmboFlS2/OqYLhpbfV9gvPei6rYtMcpHUZmiqvAc38PKMIIgjxWuairk5FCthe5qb9ga6+sz5GRHc8GUShOkClXJe/7ZsyKvgOikImgGq+yynUsnur09nLAfaGJ0T8r9fdW8ZSWVUpipjX8NUGbqTB8xsnl3Vu4UViIte32lItsKZDQmITuI8lgret8ZfLABe3QSQlnPtU6/UKR2BKNDFo1q7YwaI9mA1WcOWjycJjmc9NcDirDkDeSKoL5pAmZO4S2Gcz2we1YY1vybjoGKK/SypzlzuC9i4vKa7BEBq08Jm0fiJUbr+sa2k
 UdGTx7bE
 wOUHDx5+7mLyThLK7/4F2/YNQT54rGPWhPx1yYLT9rVeqvOqqa8ox8dB1/JV1Wi5xjw/JVOaWsj6R2ZIQqGfiUB/BXmQehRj3nUUFdI0OWLqEKatlejb9cJJ6j8Cm3jyDLjiAm/XYns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    filemap: add a kiocb_invalidate_pages helper

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     filemap-add-a-kiocb_invalidate_pages-helper.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-188296-greg=kroah.com@vger.kernel.org Tue Oct 21 16:11:59 2025
From: Mahmoud Adam <mngyadam@amazon.de>
Date: Tue, 21 Oct 2025 09:03:36 +0200
Subject: filemap: add a kiocb_invalidate_pages helper
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>, "Darrick J. Wong" <djwong@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, "Anna Schumaker" <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Brauner <brauner@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Matthew Wilcox <willy@infradead.org>, "Miklos Szeredi" <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>, Trond Myklebust <trond.myklebust@hammerspace.com>, Xiubo Li <xiubli@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Jeff Layton" <jlayton@kernel.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@infradead.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Luis Chamberlain <mcgrof@kern
 el.org>,
  <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Message-ID: <20251021070353.96705-3-mngyadam@amazon.de>

From: Christoph Hellwig <hch@lst.de>

commit e003f74afbd2feadbb9ffbf9135e2d2fb5d320a5 upstream.

Factor out a helper that calls filemap_write_and_wait_range and
invalidate_inode_pages2_range for the range covered by a write kiocb or
returns -EAGAIN if the kiocb is marked as nowait and there would be pages
to write or invalidate.

Link: https://lkml.kernel.org/r/20230601145904.1385409-6-hch@lst.de
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
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   48 ++++++++++++++++++++++++++++--------------------
 2 files changed, 29 insertions(+), 20 deletions(-)

--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -30,6 +30,7 @@ static inline void invalidate_remote_ino
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2839,6 +2839,33 @@ put_folios:
 }
 EXPORT_SYMBOL_GPL(filemap_read);
 
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t pos = iocb->ki_pos;
+	loff_t end = pos + count - 1;
+	int ret;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* we could block if there are any pages in the range */
+		if (filemap_range_has_page(mapping, pos, end))
+			return -EAGAIN;
+	} else {
+		ret = filemap_write_and_wait_range(mapping, pos, end);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * After a write we want buffered reads to be sure to go to disk to get
+	 * the new data.  We invalidate clean cached page from the region we're
+	 * about to write.  We do this *before* the write so that we can return
+	 * without clobbering -EIOCBQUEUED from ->direct_IO().
+	 */
+	return invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
+					     end >> PAGE_SHIFT);
+}
+
 /**
  * generic_file_read_iter - generic filesystem read routine
  * @iocb:	kernel I/O control block
@@ -3737,30 +3764,11 @@ generic_file_direct_write(struct kiocb *
 	write_len = iov_iter_count(from);
 	end = (pos + write_len - 1) >> PAGE_SHIFT;
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		/* If there are pages to writeback, return */
-		if (filemap_range_has_page(file->f_mapping, pos,
-					   pos + write_len - 1))
-			return -EAGAIN;
-	} else {
-		written = filemap_write_and_wait_range(mapping, pos,
-							pos + write_len - 1);
-		if (written)
-			goto out;
-	}
-
-	/*
-	 * After a write we want buffered reads to be sure to go to disk to get
-	 * the new data.  We invalidate clean cached page from the region we're
-	 * about to write.  We do this *before* the write so that we can return
-	 * without clobbering -EIOCBQUEUED from ->direct_IO().
-	 */
-	written = invalidate_inode_pages2_range(mapping,
-					pos >> PAGE_SHIFT, end);
 	/*
 	 * If a page can not be invalidated, return 0 to fall back
 	 * to buffered write.
 	 */
+	written = kiocb_invalidate_pages(iocb, write_len);
 	if (written) {
 		if (written == -EBUSY)
 			return 0;


Patches currently in stable-queue which might be from mngyadam@amazon.de are

queue-6.1/block-fix-race-between-set_blocksize-and-read-paths.patch
queue-6.1/filemap-add-a-kiocb_invalidate_pages-helper.patch
queue-6.1/fs-factor-out-a-direct_write_fallback-helper.patch
queue-6.1/direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
queue-6.1/filemap-update-ki_pos-in-generic_perform_write.patch
queue-6.1/filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
queue-6.1/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
queue-6.1/block-open-code-__generic_file_write_iter-for-blkdev-writes.patch


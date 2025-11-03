Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D79ECCFA04
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 01:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9868E0013; Sun,  2 Nov 2025 20:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1078E0002; Sun,  2 Nov 2025 20:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E0A8E0013; Sun,  2 Nov 2025 20:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 006038E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:49:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B031C140A32
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:02 +0000 (UTC)
X-FDA: 84067612524.29.591C8BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0B2AA1A0009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=nbvoeVZt;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762134541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=/MXTxbhVJZb/aKJlnz5Ar0qHYhtM+uQHxmwfG7X7yNg=;
	b=yfHwYkjWbjGJlqmo4U+xNXevR6SiFGRWLW/MfUw0OdLAE3T9yxox4mzr0eRH9qd6XJzwxH
	gAwk8S2lmHFikQpl0RUHFduggRWv8VKCX3X6R6tDnc383+5RE+1skj7GqlLqLd3eqY+F+K
	75wt3arwXKwai/gCkdGOtrAbcBMfX6E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=nbvoeVZt;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762134541; a=rsa-sha256;
	cv=none;
	b=k5E1oM6SkNfw7sRWPDzRcj2wFh27NWzuc/5+42DQvccdPQJKTTQuc69OzyWb4C+WxyGSSl
	L7gr7FX3RK9GuMXuFma/FIa01Dx/wMQKnJoKK19iV1TCkypgCJOeuKC24cVdTXyay8JVBd
	4Hd7rYsaY4jByRnTHGhQXXXW/kI21Vg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F00260283;
	Mon,  3 Nov 2025 01:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA21C4CEFB;
	Mon,  3 Nov 2025 01:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134540;
	bh=4yyEDFex+hFxF/7qryJOkq9qNYQH9VKVpDG2zfmDNTc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=nbvoeVZtikZi+yV3cKHBOWJ0EIVhO8NUBFAIlLkmALjnt6JqtvAzb1s9fv6fc6dQR
	 djFnluCmpGYQ2MKFc/Rl0nSW5EuCoS0OnBdvEZvOxl6OFIFJNIw2BB66nXZwDx7EnM
	 jgYn2WZhwdMygabB4+QF82hIBXJCpoAYDegKstzQ=
Subject: Patch "filemap: update ki_pos in generic_perform_write" has been added to the 6.1-stable tree
To: adilger.kernel@dilger.ca,agruenba@redhat.com,akpm@linux-foundation.org,anna@kernel.org,axboe@kernel.dk,brauner@kernel.org,chao@kernel.org,djwong@kernel.org,dlemoal@kernel.org,gregkh@linuxfoundation.org,hare@suse.de,hch@infradead.org,hch@lst.de,idryomov@gmail.com,jaegeuk@kernel.org,jlayton@kernel.org,johannes.thumshirn@wdc.com,konishi.ryusuke@gmail.com,linux-f2fs-devel@lists.sourceforge.net,linux-mm@kvack.org,mcgrof@kernel.org,miklos@szeredi.hu,mngyadam@amazon.de,mszeredi@redhat.com,nagy@khwaternagy.com,trond.myklebust@hammerspace.com,tytso@mit.edu,viro@zeniv.linux.org.uk,willy@infradead.org,xiubli@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 03 Nov 2025 10:46:57 +0900
In-Reply-To: <20251021070353.96705-5-mngyadam@amazon.de>
Message-ID: <2025110357-playgroup-surpass-150c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B2AA1A0009
X-Stat-Signature: 3g6f8w6p7mc5waiprcxqkj1fa1dbh6cb
X-Rspam-User: 
X-HE-Tag: 1762134540-496511
X-HE-Meta: U2FsdGVkX18/VvvHpHD3hMWKwbLwbtmNf0RBAzODFF8iVgoYpSbVydXnrh3/TXbMkiPn+qnD+bbgGtt74YT3UrKij4nyFlWJCFjvmccAFG8LHxyFml1cVH+xX/r1j1WGd3KSK7t9fSRKBnpca3uDacyRWV6Vn+pxPGqpLp6RgfsVNh3MYf70M9eqzNGrMl+OcWeUMw4iK6OF5XU8mYV9moMWJL03+PFA4oYznfu4vG42wEvkJFMakxrWOuxJPUq26pLsKOuMNpRVrSCLVtFu3PozyQfDOLYbRm9plSy7KLpL4hJYeLpSyNxG1rsb1eAxtGeHXGHNL31QMD0QT8a9crSwz1ctJEk7W3xfqKNph6eHbipccj55I2quI9jN5u7Y58Ogv209XcG1EmBOhUSjg9iZ84u4M0wkKsYK/7HkTVC55hZ9acnYOYsLPm62jarSdOO/Pav0DWH7awlV0HcC+CtaHwIWjAhBbY188txCzVsXNFMJ5+t4K22ZV0S+g+rGslSw/MMdVULfluLfTBtx36kRvjdxjIA4DYwHAt3dAZ4y00YNF0uIP/sFATlCF79XAveh0etd51/W6P+FkBQFOVTj7Xs4Eh6zcKS39O3RnhV6hionFwDpgJ1Ek8EbSu7vKMMRd6b+7uqKAnc+63UR9H5qKTk0saxgD+tyR/snX9xJcBfHyoHcVeeIbWFx5y5pcbG4GPXL8pCbkwNuKPrt9Smh5befKSDO2TqKGqd0a+VikDYF/K55M7bsnZHsO9YswyaF2dIvkFaFO3YmSLnD4kvSVm/7U1xT69K2rlq2kAAx31nHqJrqTJ8Z2fR5aeqDJLksEmF3QxnASSgnipxvMGM+xLrdICnsNRUblhtWLen/tIgTLEw56mimzpvXZZK/lpmOLlS59VVbEQoaOvvShNF7p+UJQIV8jWoGKRWytGHmGva8zh0P9UP0KwyL9k2IQ1TQZEFA05c6uRaP+3p
 6IRFLQji
 NQq8Vpca33ujp9kXxd0qml9TRqbF5JWlh11qYsywl48IJlPxjp42VmW+fBnkYPOS3fGf7+h65Gp0NE8pLL9hro7d1GJvHpb+d3uJGUeY4LDyrUav+YEyj3RC5Jy8tFpZyOYJ+vIySAgqGWCXEZShmVkGqhG0CIfG9trWyAUAcLUX8ya6tBiEG13I7qo0YfpZAFSaePFkDIk1ggWMl3+Odl6lJWhBBIu/EAwpqI3DFIZeysG6e9LrpHhdG1Vt8ATKWjItWZ2Ke5ZZhPduQ/JbTLnyfMAv1Ot0P3XJxp5pjcIyQKijM2IXrX919cA9DXPFKZbNEsudvGAcR7ejbGq3cVHQABvm7kwm6cowX7fwRO733SWush3cfDsiTGq7qpKacDuKdWBUiAlM/yKupj+5476pZ/qM3fz/svRoyzo5WRHrr0QkYeYqhj7oxAUL2DmiUypQo1WJBKrUC0aFTrc1jga+EU/2K5Z0VzDm1Vt7L+qyi0GTnS/kkEYHSLjTl3yOuiC+TY6UpuuIb62AxthscAgxAI7sOrjAf5oMq9gaTWI6SA3fH7GeHneIdAV7s6x1Lnq/qq8mkou9G/KGvIu8St3id5f3d9jDaOjgqrlDKri2NtquoZPW6WAGpUN1VXeWJb1cggPGS0MQnIg84u1/xaGHsQyy+zXokf20IXLIm1WjlQnW6fpM2U5O7a2El9XP0cCpaGZU9AF2F4VxogbvoqXUhpmiq/iGyT/NYSoHi5jb9I+w5c5KqpDRXCRJblw5u3TOdnkUOSkIPCJ01sbwQypFZXNB2/IvuUw4+p0DE8Ku5UatLhZKU5NNKxdwFPdq12jr3G8DeMXS2VfHu9R+uvd0MWRS7IejuBFqE7RBuFQc8m3F1V3cdMtEXKCZgW6Y4VULJKus+R5xml4er5f9TbbPHV48lJ7ZxUfzgkGhJWbCX8Jcav1cbyIM5hz9Lj2hCuoG65W0/Nipx1gcLkGsrU/5a+IEM
 IuYodVM6
 /L1yH1YcSFfl7qSsMigNlLOrLvPyru9XtUvfecWu3GtzC/6XnJIpgEcWC5pUqvxovIrtvKKL56iiBocbN1pk3JK8AEV3FuQUSr0U1NhYwAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    filemap: update ki_pos in generic_perform_write

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     filemap-update-ki_pos-in-generic_perform_write.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-188298-greg=kroah.com@vger.kernel.org Tue Oct 21 16:16:51 2025
From: Mahmoud Adam <mngyadam@amazon.de>
Date: Tue, 21 Oct 2025 09:03:38 +0200
Subject: filemap: update ki_pos in generic_perform_write
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig <hch@lst.de>, Xiubo Li <xiubli@redhat.com>, Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, "Anna Schumaker" <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Brauner <brauner@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Matthew Wilcox <willy@infradead.org>, "Miklos Szeredi" <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, "Trond Myklebust" <trond.myklebust@hammerspace.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@kernel.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@infradead.org>, "Ryusuke Konishi" <konishi.ryusuke@gmail.com>, Luis Chamberlain <mcgrof@kern
 el.org>,
  <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Message-ID: <20251021070353.96705-5-mngyadam@amazon.de>

From: Christoph Hellwig <hch@lst.de>

commit 182c25e9c157f37bd0ab5a82fe2417e2223df459 upstream.

All callers of generic_perform_write need to updated ki_pos, move it into
common code.

Link: https://lkml.kernel.org/r/20230601145904.1385409-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Theodore Ts'o <tytso@mit.edu>
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
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |    2 --
 fs/ext4/file.c |    9 +++------
 fs/f2fs/file.c |    1 -
 fs/nfs/file.c  |    1 -
 mm/filemap.c   |    8 ++++----
 5 files changed, 7 insertions(+), 14 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1891,8 +1891,6 @@ retry_snap:
 		 * can not run at the same time
 		 */
 		written = generic_perform_write(iocb, from);
-		if (likely(written >= 0))
-			iocb->ki_pos = pos + written;
 		ceph_end_io_write(inode);
 	}
 
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -287,12 +287,9 @@ static ssize_t ext4_buffered_write_iter(
 
 out:
 	inode_unlock(inode);
-	if (likely(ret > 0)) {
-		iocb->ki_pos += ret;
-		ret = generic_write_sync(iocb, ret);
-	}
-
-	return ret;
+	if (unlikely(ret <= 0))
+		return ret;
+	return generic_write_sync(iocb, ret);
 }
 
 static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4659,7 +4659,6 @@ static ssize_t f2fs_buffered_write_iter(
 	current->backing_dev_info = NULL;
 
 	if (ret > 0) {
-		iocb->ki_pos += ret;
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
 						APP_BUFFERED_IO, ret);
 	}
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -645,7 +645,6 @@ ssize_t nfs_file_write(struct kiocb *ioc
 		goto out;
 
 	written = result;
-	iocb->ki_pos += written;
 	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, written);
 
 	if (mntflags & NFS_MOUNT_WRITE_EAGER) {
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3891,7 +3891,10 @@ again:
 		balance_dirty_pages_ratelimited(mapping);
 	} while (iov_iter_count(i));
 
-	return written ? written : status;
+	if (!written)
+		return status;
+	iocb->ki_pos += written;
+	return written;
 }
 EXPORT_SYMBOL(generic_perform_write);
 
@@ -3970,7 +3973,6 @@ ssize_t __generic_file_write_iter(struct
 		endbyte = pos + status - 1;
 		err = filemap_write_and_wait_range(mapping, pos, endbyte);
 		if (err == 0) {
-			iocb->ki_pos = endbyte + 1;
 			written += status;
 			invalidate_mapping_pages(mapping,
 						 pos >> PAGE_SHIFT,
@@ -3983,8 +3985,6 @@ ssize_t __generic_file_write_iter(struct
 		}
 	} else {
 		written = generic_perform_write(iocb, from);
-		if (likely(written > 0))
-			iocb->ki_pos += written;
 	}
 out:
 	current->backing_dev_info = NULL;


Patches currently in stable-queue which might be from mngyadam@amazon.de are

queue-6.1/block-fix-race-between-set_blocksize-and-read-paths.patch
queue-6.1/filemap-add-a-kiocb_invalidate_pages-helper.patch
queue-6.1/fs-factor-out-a-direct_write_fallback-helper.patch
queue-6.1/direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
queue-6.1/filemap-update-ki_pos-in-generic_perform_write.patch
queue-6.1/filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
queue-6.1/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
queue-6.1/block-open-code-__generic_file_write_iter-for-blkdev-writes.patch


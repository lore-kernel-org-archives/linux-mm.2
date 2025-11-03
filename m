Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAEF0CCFA00
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 01:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666908E0012; Sun,  2 Nov 2025 20:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1468E0002; Sun,  2 Nov 2025 20:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7388E0012; Sun,  2 Nov 2025 20:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 369D48E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:49:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C52E1160A37
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:49:00 +0000 (UTC)
X-FDA: 84067612440.21.AE9C69F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id F33D84000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:48:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b="xPitT/Na";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762134539; a=rsa-sha256;
	cv=none;
	b=t1aVBB0oQyryqZZz25C9bVVHqA77EN7cfF7Wqe6KOlrFczLrkp38L+SNEQlA4TY4HAGvkR
	Z8AKQbDlHR1Asw9IHdco+ptd2SkWsCbD06e149m+LEJWU8Fm6O7tFD+hWYNN4Prtnz9uyw
	eilNHH2rAq5tc50PCGckq0PvbVKhQgI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b="xPitT/Na";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762134539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ng1L4mgaMfjyUoixnhV1UePdLKnKRGbfTBsi3P0YK14=;
	b=O+WKV/NdVp7AQ/LQHfKoicoNw9vcfwzYbTcY6/unSVVGQXQH+yuNnYvjytFDcw48SktJOo
	mxLTKOVrbgXrF3lH09noFOotiW/lWQgqOFelxvdbAwczZUBU0d3T+ESf+I/w99RQvuYWCT
	qJn6T8ljdRQyLE8so1hR1xA+9Ur968w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A28040590;
	Mon,  3 Nov 2025 01:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C27AC4CEFB;
	Mon,  3 Nov 2025 01:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134538;
	bh=zmE4vYPhLsLlNZClDX7jMxJnkyssWUT8qSU9Q8+p7ag=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=xPitT/Na85xDwv2HMLA4Egk9QxDKIa95C+3IASHiprddm75cMGFSNVjt6YsX9FPTZ
	 JyOpvuQAIlaQuOEBCn0JAp0ZH6IF6GCV2q2FHW+VJ0Yeq72GRLyuUCE2JFyJVSVh2w
	 ynhticRcUerSZwNOIZG0hrrkHQSBxCVnO8BeTPiM=
Subject: Patch "block: fix race between set_blocksize and read paths" has been added to the 6.1-stable tree
To: adilger.kernel@dilger.ca,akpm@linux-foundation.org,anna@kernel.org,axboe@kernel.dk,chao@kernel.org,djwong@kernel.org,dlemoal@kernel.org,gregkh@linuxfoundation.org,hare@suse.de,hch@infradead.org,hch@lst.de,idryomov@gmail.com,jaegeuk@kernel.org,jlayton@kernel.org,konishi.ryusuke@gmail.com,linux-f2fs-devel@lists.sourceforge.net,linux-mm@kvack.org,mcgrof@kernel.org,mngyadam@amazon.de,nagy@khwaternagy.com,shinichiro.kawasaki@wdc.com,trond.myklebust@hammerspace.com,tytso@mit.edu,viro@zeniv.linux.org.uk,willy@infradead.org,xiubli@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 03 Nov 2025 10:46:56 +0900
In-Reply-To: <20251021070353.96705-9-mngyadam@amazon.de>
Message-ID: <2025110356-shrapnel-squash-a5dc@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: mkx167mje8phe76zeptqe5h7rd3ywt9b
X-Rspamd-Queue-Id: F33D84000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762134538-829775
X-HE-Meta: U2FsdGVkX1//txoQ2VDmsn4GgU2X9u1ZVF2gigfRw589ZRUZjY5gjbfRPzhCkqgQNErxsIGVseayeufZ18zefhVPoT+24ig5pUBPxWEk89hC4o5zJjl6tcVBmBuPlpwVFCe+b0TkXj8lGn64t3liaBdZgQai1L4tYrn4peQXlkePngpb+2zt7nsGHMGgx/GQxMD8+O/AujMVGR3gtOf73JKhxMGghE4u+MzUNdFS9Bn97i3wSdz+9FSEAJNLErxkKiwDhL0J+YloVWBFNoo7ZUm/2iKbemjjb21uA6uYemJqJpgRAsXjQevaV+PY0u9zbjvx9dNEJ10I+fGFt12V5Gc+LI0AYLZpj0eGj9g7z1KZv4kMXnBLTxB50EXMZFkSZNNyBHvX8sJ0vz8wiuTWkPC52buORWjWXDmj9jJejSDa6YVVWiolByxV1+a94YaxNAUmQ2ipTKix69IzfhgZf2lRP8uZIT0/SWWsvU+gSc+E5axuiw5osRNtl/VnwSy3oU/soTa2yqUUzx1A60mEvpGmAtL9F8YhaJyx6z/U8rZsgshqEAkdMO2zqVTsMHBYVe9WnD1mSsS6ipUtznABomqNA8u9lX28CXKlHPeGFuhdbLAMjIh/U72oRSIMBfl5xcl009QlACHOX/zVRJ5EiWtEZkxNyVtt4HiQGuWZoK6yQOCqxgIZ9nwKZ4CiVqBP5RmICmafy+x7RtNuSJlI01zxIhpaKD3QACMl0De/kXn/Nm6pFPcs8aFMd/cgdDm7ZjsvnyI+YtdEz0aVplL/7n08Yh55Yh6SwaJ0df6rF3zI4pg4o6izPL59tNnmRmfemQSyf7ZqxWlje/knjfwG3b44JCAKaSDpXslNccqpjaV27m+z3qDj55zhKP0TQzX+16KVeij/t3+RYoj5dr/dYR8l+1uYPBOOlKXf+LqZYTdhzjsD8ceMKuV9w1A/s4UmI5A3vSloB0w+KLPaku7
 JjrvZjuG
 81WQojUCAG8Y13kfc6jUcvSMmffCAZsZ/XGL9IrTG1gmTALNSKKyRAcS1wbJXYDCjGL0oO4FY6VYTXTiRRW1WrM8HWB8/8KBaYBIX5PVhWLB4OBV3CsuaqfbCDTYX3yAGci9CqkQ6788b1rtPljXwTuJGhusXErarBOqyj09vaB7TKCJGrGiJhL/g65YTN3ldj5cPQEM7k566h8TVRrRCV7J+9swEqyUcGjYKfhOEBcSrFUvZfoxP+fO9HOqFJRdA2wYvWcIglFCTnIqERYwMpA/gSxCO9T7NX7zPPIlX7mnrTMLSCc1d/MX3/tMENs74k3dWDalhvz+lCTBSUf7J7fToSu2YKYVQmTMGImwKQN5jg/L++xf6wzCNgTIu2pbi2oiR9AjGYbNJZq0G/R8Qq723D8BIj8KzLR7V5EEoEu6zUPId4nN4v3ze0HIicih0KWltJ32L3z0tUiya120EipbtR6YAo9DfnH5QYVEAGetFyZFBazJ9UcvjvaaGneFNnXmRnpHMXf0nNqsn//Ux5nneXuibaCOw/emUfm6xfUZOQ+O7f+lgzLelpzDG1VrJ88tHMjsbW1/eHVK4gW4eEbXr8OrWlyg+qoaNGWjPAKwatcgFjE0SOPFiU0xYCHhAQwJjIqMbI736umizJVa9YBy0b+fNvnAjmxvFPGjoNe3BmgU2nmmTDfOEKqu9K0WbFMXTr2oQEPAw/Y/4Nq1Ynkx+j1A3CAoRQ2GFYUWfP2vteIW6W84/Jr2Co6fx1NKdi6DjhhDsVRW3VcdCSM91W5nwCBMvEnRVXM9GWRNVmczPbzCRP8cmcr3mn6SuBo+XR2lSPznZDTwcV1uDY5/C0uDD5MUTWlvD1qO6X69DEt11+ETdGQiKNGvJD1vHHvYp09JaSrNiJAw0HjyCZpO0n3iytklHRmN1sg171FlSN2XAlOyuyA+WWTcoTP4F3LV72sZEE1Dj0B/A8cxaZjGwdJSz9aLw
 M/kHEWBd
 OG3KLg6o7p9nUQbMw26J7T3iLe33aRzZY7owOaxat4XlEhaxSHzjR28FCdIBkFOy9dbRfDvjd1j+mpYYPzZBHCpQx32gYwr2QTbkM+oKgotYjopFdKeHfnNcQVHFHFxE17b2BcofsajJHytO8RZo9PQu4Uq0vQnPsUuredebAmSaSWApr0PVeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    block: fix race between set_blocksize and read paths

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     block-fix-race-between-set_blocksize-and-read-paths.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-188302-greg=kroah.com@vger.kernel.org Tue Oct 21 16:13:58 2025
From: Mahmoud Adam <mngyadam@amazon.de>
Date: Tue, 21 Oct 2025 09:03:42 +0200
Subject: block: fix race between set_blocksize and read paths
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "Jens Axboe" <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, "Ryusuke Konishi" <konishi.ryusuke@gmail.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Hannes Reinecke" <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>, <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <li
 nux-ext4
 @vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Message-ID: <20251021070353.96705-9-mngyadam@amazon.de>

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0e473a0d226479e8e925d5ba93f751d8df628e9 upstream.

With the new large sector size support, it's now the case that
set_blocksize can change i_blksize and the folio order in a manner that
conflicts with a concurrent reader and causes a kernel crash.

Specifically, let's say that udev-worker calls libblkid to detect the
labels on a block device.  The read call can create an order-0 folio to
read the first 4096 bytes from the disk.  But then udev is preempted.

Next, someone tries to mount an 8k-sectorsize filesystem from the same
block device.  The filesystem calls set_blksize, which sets i_blksize to
8192 and the minimum folio order to 1.

Now udev resumes, still holding the order-0 folio it allocated.  It then
tries to schedule a read bio and do_mpage_readahead tries to create
bufferheads for the folio.  Unfortunately, blocks_per_folio == 0 because
the page size is 4096 but the blocksize is 8192 so no bufferheads are
attached and the bh walk never sets bdev.  We then submit the bio with a
NULL block device and crash.

Therefore, truncate the page cache after flushing but before updating
i_blksize.  However, that's not enough -- we also need to lock out file
IO and page faults during the update.  Take both the i_rwsem and the
invalidate_lock in exclusive mode for invalidations, and in shared mode
for read/write operations.

I don't know if this is the correct fix, but xfs/259 found it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/174543795699.4139148.2086129139322431423.stgit@frogsfrogsfrogs
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[use bdev->bd_inode instead & fix small contextual changes]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bdev.c      |   17 +++++++++++++++++
 block/blk-zoned.c |    5 ++++-
 block/fops.c      |   16 ++++++++++++++++
 block/ioctl.c     |    6 ++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

--- a/block/bdev.c
+++ b/block/bdev.c
@@ -147,9 +147,26 @@ int set_blocksize(struct block_device *b
 
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_inode->i_blkbits != blksize_bits(size)) {
+		/*
+		 * Flush and truncate the pagecache before we reconfigure the
+		 * mapping geometry because folio sizes are variable now.  If a
+		 * reader has already allocated a folio whose size is smaller
+		 * than the new min_order but invokes readahead after the new
+		 * min_order becomes visible, readahead will think there are
+		 * "zero" blocks per folio and crash.  Take the inode and
+		 * invalidation locks to avoid racing with
+		 * read/write/fallocate.
+		 */
+		inode_lock(bdev->bd_inode);
+		filemap_invalidate_lock(bdev->bd_inode->i_mapping);
+
 		sync_blockdev(bdev);
+		kill_bdev(bdev);
+
 		bdev->bd_inode->i_blkbits = blksize_bits(size);
 		kill_bdev(bdev);
+		filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+		inode_unlock(bdev->bd_inode);
 	}
 	return 0;
 }
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -417,6 +417,7 @@ int blkdev_zone_mgmt_ioctl(struct block_
 		op = REQ_OP_ZONE_RESET;
 
 		/* Invalidate the page cache, including dirty pages. */
+		inode_lock(bdev->bd_inode);
 		filemap_invalidate_lock(bdev->bd_inode->i_mapping);
 		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
 		if (ret)
@@ -439,8 +440,10 @@ int blkdev_zone_mgmt_ioctl(struct block_
 			       GFP_KERNEL);
 
 fail:
-	if (cmd == BLKRESETZONE)
+	if (cmd == BLKRESETZONE) {
 		filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+		inode_unlock(bdev->bd_inode);
+	}
 
 	return ret;
 }
--- a/block/fops.c
+++ b/block/fops.c
@@ -592,7 +592,14 @@ static ssize_t blkdev_write_iter(struct
 			ret = direct_write_fallback(iocb, from, ret,
 					generic_perform_write(iocb, from));
 	} else {
+		/*
+		 * Take i_rwsem and invalidate_lock to avoid racing with
+		 * set_blocksize changing i_blkbits/folio order and punching
+		 * out the pagecache.
+		 */
+		inode_lock_shared(bd_inode);
 		ret = generic_perform_write(iocb, from);
+		inode_unlock_shared(bd_inode);
 	}
 
 	if (ret > 0)
@@ -605,6 +612,7 @@ static ssize_t blkdev_write_iter(struct
 static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct inode *bd_inode = bdev->bd_inode;
 	loff_t size = bdev_nr_bytes(bdev);
 	loff_t pos = iocb->ki_pos;
 	size_t shorted = 0;
@@ -652,7 +660,13 @@ static ssize_t blkdev_read_iter(struct k
 			goto reexpand;
 	}
 
+	/*
+	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
+	 * changing i_blkbits/folio order and punching out the pagecache.
+	 */
+	inode_lock_shared(bd_inode);
 	ret = filemap_read(iocb, to, ret);
+	inode_unlock_shared(bd_inode);
 
 reexpand:
 	if (unlikely(shorted))
@@ -695,6 +709,7 @@ static long blkdev_fallocate(struct file
 	if ((start | len) & (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 
 	/*
@@ -735,6 +750,7 @@ static long blkdev_fallocate(struct file
 
  fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return error;
 }
 
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -114,6 +114,7 @@ static int blk_ioctl_discard(struct bloc
 	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (err)
@@ -121,6 +122,7 @@ static int blk_ioctl_discard(struct bloc
 	err = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return err;
 }
 
@@ -146,12 +148,14 @@ static int blk_ioctl_secure_erase(struct
 	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	inode_lock(bdev->bd_inode);
 	filemap_invalidate_lock(bdev->bd_inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (!err)
 		err = blkdev_issue_secure_erase(bdev, start >> 9, len >> 9,
 						GFP_KERNEL);
 	filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+	inode_unlock(bdev->bd_inode);
 	return err;
 }
 
@@ -184,6 +188,7 @@ static int blk_ioctl_zeroout(struct bloc
 		return -EINVAL;
 
 	/* Invalidate the page cache, including dirty pages */
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end);
 	if (err)
@@ -194,6 +199,7 @@ static int blk_ioctl_zeroout(struct bloc
 
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return err;
 }
 


Patches currently in stable-queue which might be from mngyadam@amazon.de are

queue-6.1/block-fix-race-between-set_blocksize-and-read-paths.patch
queue-6.1/filemap-add-a-kiocb_invalidate_pages-helper.patch
queue-6.1/fs-factor-out-a-direct_write_fallback-helper.patch
queue-6.1/direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
queue-6.1/filemap-update-ki_pos-in-generic_perform_write.patch
queue-6.1/filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
queue-6.1/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
queue-6.1/block-open-code-__generic_file_write_iter-for-blkdev-writes.patch


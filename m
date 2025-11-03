Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F52CCFA00
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 01:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E908E0007; Sun,  2 Nov 2025 20:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C01A8E0002; Sun,  2 Nov 2025 20:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F174A8E0007; Sun,  2 Nov 2025 20:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DDEA88E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:48:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7959189541
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:48:54 +0000 (UTC)
X-FDA: 84067612188.27.5B2AD32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9BDCD4000E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:48:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=NKCIS4nU;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762134532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=LdxYvJPwRA4Ep/k/nBODjc430Es3F6j3UNp/gg1LTdI=;
	b=Ol5ltPLETbWyNYaHdJHHsQyK68TATOIY0NNUzwv5ji0OfYTVY2sv0T0WKS8eSyzrUqyoS8
	4bT+GpCyPDNsW2sZ9o0GOzcHBq+q7xLQ9TdFp8LE8cmbcZ5zusvWX7+VdQRJUsmLx9A7Xb
	eb3C7aW2rxe5qWa09VSeCto8WcTMUT0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=NKCIS4nU;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762134532; a=rsa-sha256;
	cv=none;
	b=7d6gLuhwlWTAuLpJUUy+zEEOpfwGaAv0RfhaC5YAYll2+unLRgnHKoAUct8a1ezkEoQUWg
	3ZdzMa9mwriofCHrRLIxeFAxzn+uBBMAjpIUJQcTnMqoNxVKZdDXPSafGDjlO5BOII/5E8
	MkeWqeZwZ4q7V+S6IXxFgn9M67ImwHs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56372419F8;
	Mon,  3 Nov 2025 01:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DF1C116C6;
	Mon,  3 Nov 2025 01:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762134531;
	bh=BQ+0lxQkpcXa/tD37ekUWLzbNim2icgZVv3J5UVRVrg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=NKCIS4nUJJRTzUf4zGcO36QcbhNBLyPrRYww5MJcr80mpPufA97nf0gKTvB0IktoS
	 qRe38UqFhM4KN94IYa+9fi14ACTmNO5pIDKxmmCoEFpOTMaj86QxIclwzEgRYonYms
	 J01tx+EqT5YO3ZE5gjywbQBqynkwRgJHWO6gw3Bo=
Subject: Patch "block: open code __generic_file_write_iter for blkdev writes" has been added to the 6.1-stable tree
To: adilger.kernel@dilger.ca,akpm@linux-foundation.org,anna@kernel.org,axboe@kernel.dk,brauner@kernel.org,chao@kernel.org,djwong@kernel.org,dlemoal@kernel.org,gregkh@linuxfoundation.org,hare@suse.de,hch@infradead.org,hch@lst.de,idryomov@gmail.com,jaegeuk@kernel.org,jlayton@kernel.org,johannes.thumshirn@wdc.com,konishi.ryusuke@gmail.com,linux-f2fs-devel@lists.sourceforge.net,linux-mm@kvack.org,mcgrof@kernel.org,mngyadam@amazon.de,nagy@khwaternagy.com,trond.myklebust@hammerspace.com,tytso@mit.edu,viro@zeniv.linux.org.uk,willy@infradead.org,xiubli@redhat.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 03 Nov 2025 10:46:56 +0900
In-Reply-To: <20251021070353.96705-8-mngyadam@amazon.de>
Message-ID: <2025110356-pushiness-kangaroo-bfbf@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9BDCD4000E
X-Stat-Signature: 6sf67kd9sj8y5zpaaasjqh48hrscoduo
X-Rspam-User: 
X-HE-Tag: 1762134532-601395
X-HE-Meta: U2FsdGVkX19Oya3SxkbvosLt6pJAZvrlCt94k7a2bLZwe8MU2sGpW/Zne0mrTKaRBkCtJYTo1EVYJ44NgPtnt2vLSDHX2XHUDkWBs+yz6SHzBjCqOfpiO6UP6Ciox6lZWG0vOW3RlUadTnAZH6PPD1JITungy/c+syn3og1SBlKez935rLBoMOD0lgIN4rZWnOOcGVmfbq73XctZsQcLB7nH85G2YQIb37bWKJi8kTfE9JK1bCk8DZOIWAtEemXyShaqel2PapFABML22n6e/refG+HfOfct0oFUVXZ4s50nKWK3g8qgCV1UZWImduU4aV3moqc7c7T4Ok6KX2OisWSflQfJuw9SHyQdqlg7fniR2WMFT/yBXDPqYDFcLYPvIwBNQRMF9N8Qj5yv8tS5sTDdTqN65Zl2KeyaQETBwutP5ryU81ZAs+ecfQoG9SWCjofACQCuhk8xkqjSDl2bbNo0E2mXAVvBCI5CUqYrWj4lCj/vyt2DY74sYSsqa/7quToTlUFgyX5PZt8jDi8QQYylOXm0pPkCmx/1O7FBr+gKQLJcDrHvBSHaD3z/AW4uCsC8FoN4dEHviy95E+tgVhFYURTNd9XUYV2VYajHR7h/7UVI8Fo4YIOwGef/Mmfo3GV+/zo+mocauRDb0TdiHvTe5OAfw/hWEZw8dbGwpNRoVwWIZBWGaaRqoFRFzJBsm1RYaQFJFw5re7PBm8tufjg1eRCTbzOjgFV1G8OsywcGGyyNw1yr20Op7DTqdfkA32fT7nhOx9COfq1ZQt3L8b2ZYdKI1O+L8SxRGkWSzOS/gWN5uxRPN/YhrtWZIXqD+mvAjJaOBg6qaHmyL4Vy+CFZDTQUTHpuBymcJQHTimJUfB7DcZ6vE2m9UbocLVrtu5kFCraIPUg2eAzVJ9hZu0AV2pzVukSiVQmxYTuePFCk6odZkC/P3XBDniSzEvMmMzCPh6/riZncz2obe++
 BsBuCcDY
 0GQKhJezHYKYbO13oE+zXP7MjEx1GqThg61Xs1v665fIpudPcED3HVl67RPmZ6/Nfm5xb/O3bw3ZkBPx1JL3BxrlAlcOeYvmUMVip1CXvCDO7PXcoh/fHT+DqJZaUPUwL3jCTHFhKRCS5EcQbgKvj57HRMu2Cnc9+CicH3W7XsE3fOBjW8gSHrNmsugjx8v4pUscXzwpoSRRmky8PTRs6AZXReE0XSgC4+JcjCsKyb5tkhQq9Fms18ZcLE5TbMSLXOrh+60C1P3ujvHQ2BEuVhxzddrC8cs6oGbkNv7UD4L6Yitocd175gq+034NfQrhmJUbn9oiIM18Hz1nr5TPTlYIUcpH9VW4UIOOlZLLEgHGKmNwKBhsV7wlNivzNz6IE51vjizGTrIQK0mOSM7U/Kl9jSDR44EGJB9Xb2ITBmTL0vdQIUg6+Ju0HapZYojebxW1djwZgjFk36Vpdz6JYh/uCkkLK8FdOSUC+ujfejD/rFHKr55W5DSRH/rMWPKyYrhPWsIbzYI/U5Db/u5v59tsyGehS7PoVup18OxFyjA2LYnQup7Rkv2oBUsgqd6Ec3qfOUUBCnecaF5RVdWCvysul+apeVgfBic7nta2bufY3FmLkaqte57C5cxWCPEQV6ErUYNPpSUPdhSTR5g2mUSq74kAmCNH/Fi2rlJfHYUBoiQ1eYr0wgTNlo8LxBM8LC8LfHL4LjGzpEw+23753+8n0xkz233om7M1Nx44oiSHkITzyFGhBxBopAHdR51SyMBFiQy8MYwiUYpMfSnpY8BRfVV1fhHySJZVyT+YCiTwhVSzF3GMZHqEF5LlFRfshRS0TPNaCv2nL84rOM+8rCcNfnHrJu7jrkgnNh3aYUIGUv8WGVKMuqFnfAXivhFePtUFm3Pab+a/Y4D6RGE6Y+03vU/oag3FJrzWOAr98jwjCMdBmvAjL7tB2rLM9fgpgLqbBPmpgrxGPqimAa4B8p2f8YDGk
 +HzowU3h
 RQ/IFd2rTiNDDAsTeIenvrqNT+zDo8G29nmfVxYXnzCjGaOTEkqQEIPLpsrHLtWWa1/0UuSOhk0M8XR94DUc9T5CAk/IAv4JOvQ41fZosa8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    block: open code __generic_file_write_iter for blkdev writes

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     block-open-code-__generic_file_write_iter-for-blkdev-writes.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-188301-greg=kroah.com@vger.kernel.org Tue Oct 21 16:18:34 2025
From: Mahmoud Adam <mngyadam@amazon.de>
Date: Tue, 21 Oct 2025 09:03:41 +0200
Subject: block: open code __generic_file_write_iter for blkdev writes
To: <stable@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, "Christian Brauner" <brauner@kernel.org>, Hannes Reinecke <hare@suse.de>, "Luis Chamberlain" <mcgrof@kernel.org>, Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, "Ryusuke Konishi" <konishi.ryusuke@gmail.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Damien Le Moal" <dlemoal@kernel.org>, <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org
 >, <linu
 x-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Message-ID: <20251021070353.96705-8-mngyadam@amazon.de>

From: Christoph Hellwig <hch@lst.de>

commit 727cfe976758b79f8d2f8051c75a5ccb14539a56 upstream.

Open code __generic_file_write_iter to remove the indirect call into
->direct_IO and to prepare using the iomap based write code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20230801172201.1923299-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[fix contextual changes]
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

--- a/block/fops.c
+++ b/block/fops.c
@@ -515,6 +515,30 @@ static int blkdev_close(struct inode *in
 	return 0;
 }
 
+static ssize_t
+blkdev_direct_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	size_t count = iov_iter_count(from);
+	ssize_t written;
+
+	written = kiocb_invalidate_pages(iocb, count);
+	if (written) {
+		if (written == -EBUSY)
+			return 0;
+		return written;
+	}
+
+	written = blkdev_direct_IO(iocb, from);
+	if (written > 0) {
+		kiocb_invalidate_post_direct_write(iocb, count);
+		iocb->ki_pos += written;
+		count -= written;
+	}
+	if (written != -EIOCBQUEUED)
+		iov_iter_revert(from, count - iov_iter_count(from));
+	return written;
+}
+
 /*
  * Write data to the block device.  Only intended for the block device itself
  * and the raw driver which basically is a fake block device.
@@ -524,7 +548,8 @@ static int blkdev_close(struct inode *in
  */
 static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct file *file = iocb->ki_filp;
+	struct block_device *bdev = file->private_data;
 	struct inode *bd_inode = bdev->bd_inode;
 	loff_t size = bdev_nr_bytes(bdev);
 	struct blk_plug plug;
@@ -553,7 +578,23 @@ static ssize_t blkdev_write_iter(struct
 	}
 
 	blk_start_plug(&plug);
-	ret = __generic_file_write_iter(iocb, from);
+	ret = file_remove_privs(file);
+	if (ret)
+		return ret;
+
+	ret = file_update_time(file);
+	if (ret)
+		return ret;
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		ret = blkdev_direct_write(iocb, from);
+		if (ret >= 0 && iov_iter_count(from))
+			ret = direct_write_fallback(iocb, from, ret,
+					generic_perform_write(iocb, from));
+	} else {
+		ret = generic_perform_write(iocb, from);
+	}
+
 	if (ret > 0)
 		ret = generic_write_sync(iocb, ret);
 	iov_iter_reexpand(from, iov_iter_count(from) + shorted);


Patches currently in stable-queue which might be from mngyadam@amazon.de are

queue-6.1/block-fix-race-between-set_blocksize-and-read-paths.patch
queue-6.1/filemap-add-a-kiocb_invalidate_pages-helper.patch
queue-6.1/fs-factor-out-a-direct_write_fallback-helper.patch
queue-6.1/direct_write_fallback-on-error-revert-the-ki_pos-update-from-buffered-write.patch
queue-6.1/filemap-update-ki_pos-in-generic_perform_write.patch
queue-6.1/filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
queue-6.1/nilfs2-fix-deadlock-warnings-caused-by-lock-dependency-in-init_nilfs.patch
queue-6.1/block-open-code-__generic_file_write_iter-for-blkdev-writes.patch


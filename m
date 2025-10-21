Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D0ECCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010088E000F; Tue, 21 Oct 2025 03:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29E78E0002; Tue, 21 Oct 2025 03:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41768E000F; Tue, 21 Oct 2025 03:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFF8C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:12:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9EEC91A0365
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:12:39 +0000 (UTC)
X-FDA: 84021253638.22.326EAD2
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 39EE01C000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:12:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=UU2KZMY6;
	spf=pass (imf21.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbsklnLadu0TimGCGccN0DzgzObfA2bbC0YKqZmM7XE=;
	b=v4yGyWTxoRBwfRKaGFB0VDQ9fQlUw/d9FHqq8yKdXgdNCtuYTXgaFNecfMGtgf7UfOLTPR
	XRF0QUJRs4HUecwGv7m0eMT++BZjK7KE2isKZjGtMGJn1m+AY6XDjrBvZ6Xg6tv/IbejaS
	pS5FNJPNBEKv8XJYp/iNhXKIQcYaOfM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=UU2KZMY6;
	spf=pass (imf21.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030757; a=rsa-sha256;
	cv=none;
	b=I8YgWqGamTuWvq8JbPiugmtUQKuG6irlW4ADTHMpubMULhgi1oXIyqrGDZUZgpc7WX/paC
	M/IQcblya7Xl7Tn99gxUJ04p6y7zbDHM4XX4vc9QFPfAx7Jl/yMaX5m30RIEVj7TkYw5Qw
	3L/Mum9JFvWQpHOxa86lpcrXx26TRSU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030757; x=1792566757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XbsklnLadu0TimGCGccN0DzgzObfA2bbC0YKqZmM7XE=;
  b=UU2KZMY665giYks3hP1Qx4eKnEn0yHsUihrPVKMC3hvXS8LKCDa+YV1I
   g0ZAEuZX70DC2Jt5q7RJQ06A8OE1i5pZaAGFwRDPbJqiItp5+vKSPhoAA
   aKgrPeVUTWoV4tgNPP96qUNO2E0PLGeS4uCR2rvDOoKRsk/5Vstcwq376
   MigDeEgEQFPZeClnVI5chVu9jTew1rlzQ4twYb5VEGrtc4aaH/P3TGKfZ
   XwdPexHUeva5VW7rTQ7BEG2mhLwJ9EcyfCq5410N/dnl4ZbUqKqou00zA
   eFUzksfSKd55kTnUFTqP4aw8csBvktv6HHUtZzYzyIcluykS9oCfSO1M6
   g==;
X-CSE-ConnectionGUID: eoJi007nQRij3hX+bGiZxw==
X-CSE-MsgGUID: vEwiZ/SEQsSkyB5yOtxRcg==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3930984"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:12:27 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:21179]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.203:2525] with esmtp (Farcaster)
 id 3389bf29-a6fa-4def-bde8-26368f7ce873; Tue, 21 Oct 2025 07:12:27 +0000 (UTC)
X-Farcaster-Flow-ID: 3389bf29-a6fa-4def-bde8-26368f7ce873
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:12:26 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:12:17 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, "Darrick J. Wong"
	<djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, Luis Chamberlain
	<mcgrof@kernel.org>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Jens Axboe" <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov
	<idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
	<chao@kernel.org>, Christoph Hellwig <hch@infradead.org>, Trond Myklebust
	<trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, "Ryusuke
 Konishi" <konishi.ryusuke@gmail.com>, "Matthew Wilcox (Oracle)"
	<willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Hannes
 Reinecke" <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.1 7/8] block: fix race between set_blocksize and read paths
Date: Tue, 21 Oct 2025 09:03:42 +0200
Message-ID: <20251021070353.96705-9-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D042UWB003.ant.amazon.com (10.13.139.135) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 39EE01C000E
X-Stat-Signature: ws3qhxarnp8eudsush7ykfcmexkokhug
X-Rspam-User: 
X-HE-Tag: 1761030756-915633
X-HE-Meta: U2FsdGVkX1+LECSl2piE7a4HGBE+CrZCfnuUECIr9XMUokado3LS4vGTrG7gKCzVdsH0naBXO42ZswxhYpN7Z8kfBoSZEg93XbLolKjVnF8cX6Xh/RnBJYwtlXlaTj8Yxz5QpB2ZzY/DzYMtDm4qcc3JG7SCd72U73CFHkd0ey602CLbRP2LLptvY8Bm8Ya1LiSIMh9lTLH/F266/Z91YjNzboY3TMoeBgdM+NYZ4/41dLWLA2/bs4wfphB/5NJB5g5hwSwySsfIyHFuHUk+fQnqmPonB8PwS/aFQMLVtRPe/2hLdzqOgzpOcUFzxuyIM7a7XrjN21mHLk6o7R87TaJFG4qJ6zqXWe83N33+4q7BmTOsvP/kFLXEiSG5yMgltlzXC+q4cHl0eEqmYJcv8VeekNGDBuuiZCAsYOE2YPZVnaOIAQNz/YnCiJnhVP3eu8b8bg+X1siemQlAAtu/k6mVfoTCKZLAa9jcLlzbAc/8vraxypXWFFbjLYbvQQtpy4zH0MhlEBoBvF9GyAcARXVFYJVFFGKUNlPKJlaDGX8GywnzXGsHz/aLCSzm/kIGaaWxLIeMEQD99D+URQwnI2vF73pZwOu410awEHGdApE3+T3T03JPWIx/TeEdJxQUHsjmvfZHl9t5p8rCjOFhCWRKPaUSDUKCZ4KDyt3MsKaIxEIf0rldynygW1HXWEbhDJbO+lpb5XZk7u5tJGC1uYSZO1tBXj6R4msHqluMGQ/wNbc5ozEb88ZR6/ER7++jZhnbq6zEpfvZWobSLZoryZrSFx4FDAetTayaJ68kbL6G5umlHY5aixXUuExR3eH3Oh7bT2Aj3dx49ahbCOnNIIsEgPYKrOt0y9OhYrUCQn+4qjXL1GN9cJeeinVbEWi8sr8vHyL0teWThhe9++wKDWud2/14NCDRTd38fSkFtqvZv5pvTW0MSKroriaMFyC5bq9BZ0qAxVzYew1EnMs
 goAB9Hjg
 DvsqJoBRpL65tlBdXfNMBUp/+kA8BJQK9jZLoZyOpZc5PTRYYUn6ZYw4xXvgptVENh+9f7DyCmH/X/YOX/DmJIV0MCCrjdhMr/j9g5tY0Up8yrF1wNNWEEPs4xT/Jilxl65p+EbQ7N/BgPfJux6myJTyq5tn+nZK6+rKkn+VT8hcWq2rVsAK5zhvu69/JfGB3UYRTq+Mc08mkKZxOR/plCLQkYdwmnCooLFJqrsLJqsQ+GgQ1mSQSEMKQdnMmhP2D21hxQAZaKWHEqyA+5dFHrORzunKDrfGsun+GQrI4pCiL+RuYwQXcY0G8y49LJyifCXabB3bm4rq/tY5OBpSMkkC24iP0osmdu1qAgoMNFk0wvGWU20yZwwqH5zQyZkOD9QGmHQjflNpCeHrMHwlhq9kGKFQpxL/DyWKoR4Phcu0jdkwUeRxm45VDuoOxMz3kYwXLXYpWICDCKPvCX77BAtZGlwnuf7m8HgJf2Bs1LpawpS6X2t1nT57FVxXTHV1PYzhaw6Qhe76RxhLT0wR2FUX6dijiXn2p4yRb0VU/rbDJVT00r/SUOtFqLuFr9aaGYomBkNvnIYqZZkt1z/Mki/AzclnbV9YEPWG/YxB/9PT0KmsY7Hz0b+/hVxH4SkNwBwtTBbAMyeZ0vyD2Ztr0Fnwi7tZb5Mv0vbP9UKDCs9LSCSZKr40Uo3f9sT/823ybp68qnXn3FlU7aOD+PEQz9XOxiZhQ8sQiBnaSWD3eYYh++FPfaVUxdz0T/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 block/bdev.c      | 17 +++++++++++++++++
 block/blk-zoned.c |  5 ++++-
 block/fops.c      | 16 ++++++++++++++++
 block/ioctl.c     |  6 ++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index b61502ec8da06c..5a631a0ca46a81 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -147,9 +147,26 @@ int set_blocksize(struct block_device *bdev, int size)
 
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
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index db829401d8d0ca..ef72612ca4645f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -417,6 +417,7 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 		op = REQ_OP_ZONE_RESET;
 
 		/* Invalidate the page cache, including dirty pages. */
+		inode_lock(bdev->bd_inode);
 		filemap_invalidate_lock(bdev->bd_inode->i_mapping);
 		ret = blkdev_truncate_zone_range(bdev, mode, &zrange);
 		if (ret)
@@ -439,8 +440,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
 			       GFP_KERNEL);
 
 fail:
-	if (cmd == BLKRESETZONE)
+	if (cmd == BLKRESETZONE) {
 		filemap_invalidate_unlock(bdev->bd_inode->i_mapping);
+		inode_unlock(bdev->bd_inode);
+	}
 
 	return ret;
 }
diff --git a/block/fops.c b/block/fops.c
index fb7a57ed42d995..2fc6ac6679ee63 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -592,7 +592,14 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
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
@@ -605,6 +612,7 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct inode *bd_inode = bdev->bd_inode;
 	loff_t size = bdev_nr_bytes(bdev);
 	loff_t pos = iocb->ki_pos;
 	size_t shorted = 0;
@@ -652,7 +660,13 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
@@ -695,6 +709,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	if ((start | len) & (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 
 	/*
@@ -735,6 +750,7 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 
  fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return error;
 }
 
diff --git a/block/ioctl.c b/block/ioctl.c
index 552da0ccbec09e..b37bbe9b3487d8 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -114,6 +114,7 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 	    end > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end - 1);
 	if (err)
@@ -121,6 +122,7 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
 	err = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return err;
 }
 
@@ -146,12 +148,14 @@ static int blk_ioctl_secure_erase(struct block_device *bdev, fmode_t mode,
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
 
@@ -184,6 +188,7 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 		return -EINVAL;
 
 	/* Invalidate the page cache, including dirty pages */
+	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 	err = truncate_bdev_range(bdev, mode, start, end);
 	if (err)
@@ -194,6 +199,7 @@ static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
 
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
+	inode_unlock(inode);
 	return err;
 }
 
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597



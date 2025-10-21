Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438E3CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E118E000E; Tue, 21 Oct 2025 03:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E728E0002; Tue, 21 Oct 2025 03:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDC58E000E; Tue, 21 Oct 2025 03:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1AE8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:12:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 149EE1603BE
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:12:10 +0000 (UTC)
X-FDA: 84021252420.17.1D36775
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf19.hostedemail.com (Postfix) with ESMTP id D9BBA1A000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:12:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=TaYoWfVu;
	spf=pass (imf19.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xox3qTc8hYU6L3c6JXOuETVCy0yWRIpRqh99YwnzkOo=;
	b=SW3KY+aVLF7UWaGNAUU9mhuyJyjoK7jWPIS9YdmPZRv0XhEg8nahPSzN1feNQ1lixRTyuM
	LmQMsg/GtFZ8XOAYPUiFO83FMy6J80cjqrfzQ310aPxyPAYZjvewnkaB733FUvBfMeXo8y
	r5vJhNpL23kb69iWodZy9K24lJxhZHA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=TaYoWfVu;
	spf=pass (imf19.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030728; a=rsa-sha256;
	cv=none;
	b=OZ6wK7yGnDXi4TzWXJKpPLfXXmXsoith/3JvGSTBFY0kgEB+qeU0WPA05xB0jM7/+zyGs4
	BXB+6zNPZFTNsxwBpiW3hhhOlCMGa/D8l5f+Dezs0zuBBts6SsO3W90xWtEy8Kr1nCDAFc
	3nPINgADEntcElg5ihYO9PvCD42rNJE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030728; x=1792566728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xox3qTc8hYU6L3c6JXOuETVCy0yWRIpRqh99YwnzkOo=;
  b=TaYoWfVuOcOThfgPcg1YbhtAFD77UlnFqDlNEUQ0qIOQopOy+Bq24Z2q
   D7U5ZPEk88mxgAU+iCvmG5YiTdizsqT2Ox3itzh8VZj63ZrZU80pYtTZO
   rH0/0VsI06j/i76F4GvC26QC/FkbOM/l+543HAh3d7K+2DBJ5Yutrw94Z
   66h66KsxNZomiZ9NGipOSZ9IbYwjud6EZGSpEF+m7TXZk2vlaDnjUvVwS
   CgaBV7EolfWVEYEaGWthi6+Hy10bSsiFlxcfIN1nr0EcZWB8Tjkb2ynr0
   h0PgDCiOlSQytrtywZEQGudq22Zp5KyjoeEQEkzOVUiNb/T304VMhGRHz
   A==;
X-CSE-ConnectionGUID: 6VGIvb/dQ++kJKWLFnmwYA==
X-CSE-MsgGUID: OwKsQXoZQsikLSKYYlhXrA==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3828837"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:11:57 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:11098]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.17.8:2525] with esmtp (Farcaster)
 id 6cec1b60-3232-473d-9f64-4d0e631f5a13; Tue, 21 Oct 2025 07:11:57 +0000 (UTC)
X-Farcaster-Flow-ID: 6cec1b60-3232-473d-9f64-4d0e631f5a13
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:11:57 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:11:48 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig
	<hch@lst.de>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, "Christian
 Brauner" <brauner@kernel.org>, Hannes Reinecke <hare@suse.de>, "Luis
 Chamberlain" <mcgrof@kernel.org>, Jens Axboe <axboe@kernel.dk>, Xiubo Li
	<xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Jeff Layton
	<jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o
	<tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, Trond Myklebust
	<trond.myklebust@hammerspace.com>, Anna Schumaker <anna@kernel.org>, "Ryusuke
 Konishi" <konishi.ryusuke@gmail.com>, "Matthew Wilcox (Oracle)"
	<willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Damien Le
 Moal" <dlemoal@kernel.org>, <linux-block@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ceph-devel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<linux-f2fs-devel@lists.sourceforge.net>, <linux-xfs@vger.kernel.org>,
	<linux-nfs@vger.kernel.org>, <linux-nilfs@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: [PATCH 6.1 6/8] block: open code __generic_file_write_iter for blkdev writes
Date: Tue, 21 Oct 2025 09:03:41 +0200
Message-ID: <20251021070353.96705-8-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pbgtorcidk6grcs74pmdsjnho3xtfkqd
X-Rspamd-Queue-Id: D9BBA1A000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761030727-403662
X-HE-Meta: U2FsdGVkX1+lj9Qdu5y28/3EveyDhCccQ3ul6DmGIEub+uFo6OEcHSPsSc4aFEUfPW/6vCMnqnbq0La+3TlQTl0Egq6tHwg7o51cwwplLQ8vHsBZ/ZjmFxH4cbEW2OJFejRq+XkdhBCMQla0rPvU3Ntohib4e8I35+XP9g3HEjWuU3yNRtCpxK6kFZnqgMe+VDFpy3IgghIx9NUXuBHjsKKYDJBHkL2XUEAgVLgCIP3yUWw9vXc/Rq9HVYKu0ldVZpnDxE8N/IHV+x0rqxCZnILl0jMj6IhpMiHLrBZw2WpJ8Xx8O8jo9ZybYCRCcO/nHdekGw3ejmw2LTj41FCWicfx7vcF9jmKVrjbCM62cj/iEXV0BwbStx5+vco1dsCKtrhrMDrYb1p+N1AOuwnGQl21NUzUcgrzL6WX8BlvWoEFzPLvthIG1DNb9uRyy5qpkgXVpoCmd3cLi2fP9QMHBsPmakiSDWWeoBBn5OnGwvdw6lp2dMNRmp0YHx9MEgklqBDZGcUpX7CUuuybWkE/QwZSVk/VGDfp45M+MkGPN2nFu3wc6qbOQvMbvnczlaZCXZqvm3fk1ThivnaHL2mVXM0+2VSCtBjQG5/6oBrQmVdrYPWf2CptYZes1RWkYqzjTJ1dNFFPQj4/o0KSPWjiRYe7Lp8RXSSISk5QvAon4RoufWbUJ8jY2mSQKuVSHj25qxKgaScQ9YZUoEotvG8Z6fzwoz2AMYN/TxJcdZ2nQ6egmAF5wMgwEpKJAji1Uk1Ef/97g//DOWz0VhPcLutqXcijMLLXVYunWo4zOxv3wddEFRpEqmtGa0ZcCzotAszcF9GnQkJqp0Xmb6F9tk47oXyadTRXXxwi1N0ErCDDzq3LULa2UwDMpK9OED4qZZ9oMqs8ccTNfK9yYYyRmsK59n0VuIS+b3o72VLpeTlG/g2JFAEzxS5FVo/T8/6GWa/pjUrc9HZ8ctnB3Dort+b
 a3GQLhvD
 oVCvFtZrGFEfICtcF2wfjoWRbBIvDXcqS9bWjZXybwaLOs5lbp/Is3FBplRjHZ3a5GttbPqnvwQXgSlu8a4jIlbALKc+4Ki5IpanwwHqs/wT04VIZQlhkk10jKTvvZmpO5o6JJ4ADOEeDrPY6HTNzRImOKZ4YE6btkzHiPuSbwX85+ceuosEdwmxR54f5BidMLWXN5d5zud1F5RXD4VBsMa/SCjS4mlgqusKtyIaea899vZYXZzKOm00MuuP2wRqaj9LCHj8FvtlGuepIFsC+T8AZPlgG8qkKnsL0W0MYaG0GlhS4kfFey9ruFUp2bTCO/gDNj0gfck1a3ZrrTfSxXmL7f3+SBAnp4D/gAbulCG1YsmtGzz0Lw+qaB7pU1rEV3bpbFRzIEoGALXiu5/IKI0BYjLuppuNhI0skT3twcX7AFhf6yHC4NSpI3s6I271NBuVVzK8mKTcWHMki1x+Jo2KQF+LiL9mD1wMletNt7QTMz2Nyxr2t1zHKG/f5RNdY+l4yfHfDoajv6MGPkf16blfzQH8TbIStKMYqLq+btmeGr6UQhrWqFOm1enDMEVDTTGHZ/NmDVOeT988ors/JcW72UmtLvmsqgwnI75BLMH4N9RWgf2CcT5eKC+pVBcmC2BIRB2/G2wMp21y2Z1sq5GNMScKKSXSgwwTYifFRQUXLvxl6TwvIOSn0goyl4fbp8WAGjWoyjSTDnktG8Dh8covy3XFh277lRS1qZr1ce/ji8V/QL3RJEbefnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 block/fops.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index b02fe200c3ecd0..fb7a57ed42d995 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -515,6 +515,30 @@ static int blkdev_close(struct inode *inode, struct file *filp)
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
@@ -524,7 +548,8 @@ static int blkdev_close(struct inode *inode, struct file *filp)
  */
 static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct block_device *bdev = iocb->ki_filp->private_data;
+	struct file *file = iocb->ki_filp;
+	struct block_device *bdev = file->private_data;
 	struct inode *bd_inode = bdev->bd_inode;
 	loff_t size = bdev_nr_bytes(bdev);
 	struct blk_plug plug;
@@ -553,7 +578,23 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
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
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597



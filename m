Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06FFCCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674AF8E000B; Tue, 21 Oct 2025 03:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CA68E0002; Tue, 21 Oct 2025 03:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562728E000B; Tue, 21 Oct 2025 03:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42E198E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:10:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6ED2C03D2
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:10:42 +0000 (UTC)
X-FDA: 84021248724.05.7D7F58A
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf10.hostedemail.com (Postfix) with ESMTP id 802B2C000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:10:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZR2VV172;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf10.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030640; a=rsa-sha256;
	cv=none;
	b=AaLJsb2syqf5pBFxZCzjp25hPsDs5HNxxjQDre+q7qk6hUDDRgc2kTyYfmFZSA97G2RyEv
	EkYBH+zB3Yw8xV/D7SHTfyBP70QE3E+GT1+OdhVNydSuUSKVd44lLXeYUj73O3pMKJ7CjN
	5Z60C3CKJnk9gYfz4XqoFFPZAAeEaZs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZR2VV172;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf10.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HA9qae2hxkl8hOt3UHdMdc2bodJDRIauUiWzAAKxlsQ=;
	b=dqWnudaXJtuC0WU3uHSCqD1HV/7JQkU7WWExHm8En3iUvgcG8fB+zD//8plGncfsBHOmPu
	uucNMuWMWKPBp4tIH1jbkss18uiCOyrkDigwKJ9Wlvb2tV2Eb+ozsn6YosmVzZ4UCNNZI4
	NpzW1ICZxiJmDscxWLeNJH94zVKAHlQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030640; x=1792566640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HA9qae2hxkl8hOt3UHdMdc2bodJDRIauUiWzAAKxlsQ=;
  b=ZR2VV172NElME0a3XKA9B1vVC8q010sJnP3bVPGUj+Qm672u8ODTOmSe
   bthdhcCH4adBKB6o+odGa3YBGB1/thRcpedPKK7doEKkMJ4iDV4/JPUWG
   TJpHkHm4ZTmhF4z/fp4ntILOBDUuyFRSkLopYr0diHnqNpcFjpT0ZaY/T
   Ed3X/BERD7kQ5WLqEk4jg+rDvuhqDR5Q8HyIvWoSrUt7OE/CsQlvF3gAT
   6/dU5wf8q5H57zs6zCtRekvg2ROJaTy8zeoqSl/m3xPhV0TM7v2lB1eB9
   A4ji13CvmCWVcWbnBE6pZ7aeXlJHAiFfs0Q3pku99DDsuMdjRMZzeqd3z
   g==;
X-CSE-ConnectionGUID: jh51iiDKQJqIacjSQTTaqQ==
X-CSE-MsgGUID: fUMgNCHbQ2Gy7BekZqIj0g==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3831851"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:10:31 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:19308]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.38.159:2525] with esmtp (Farcaster)
 id 76ee5b86-eab3-4d96-a848-ee94f9729fd2; Tue, 21 Oct 2025 07:10:30 +0000 (UTC)
X-Farcaster-Flow-ID: 76ee5b86-eab3-4d96-a848-ee94f9729fd2
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:10:29 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:10:18 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig
	<hch@lst.de>, Xiubo Li <xiubli@redhat.com>, Damien Le Moal
	<dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>, Theodore Ts'o
	<tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>, Al Viro
	<viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, "Anna
 Schumaker" <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Brauner
	<brauner@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn
	<johannes.thumshirn@wdc.com>, Matthew Wilcox <willy@infradead.org>, "Miklos
 Szeredi" <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, "Trond
 Myklebust" <trond.myklebust@hammerspace.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jeff Layton <jlayton@kernel.org>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Christoph Hellwig <hch@infradead.org>, "Ryusuke
 Konishi" <konishi.ryusuke@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.1 3/8] filemap: update ki_pos in generic_perform_write
Date: Tue, 21 Oct 2025 09:03:38 +0200
Message-ID: <20251021070353.96705-5-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 802B2C000D
X-Stat-Signature: 6xs18n4ms494w6w53a4a3y9yboaw9yhi
X-HE-Tag: 1761030640-806345
X-HE-Meta: U2FsdGVkX1/7YeW7ZkDeYcRCo4wlW+HioS1er6D0IjDrAeXZtrQU66o15Cl7fQHf1oTm/Br6qefMn8uougQJFO8wtyu5cSJGNXJ14MTMYhhVRYzEfgD9WNRPnR32JEJUuUoLwYPwfFeqMp+aTHX8e9wzUryNejKMykathu/OJ/43q4+TWcvAYkTIeIye7eEukyMpqJ42LyB63p07G2so2hHMi/2ZoN1eS9rv7i2JKqyyrsWI0q1+X+aJMNGBsTZnYHbTG0yGJQvVq3InPbWNWAf0n8d412kOVng78IgNwtoi+7TXZWqJwrchlgD/8qp8s2BmreoQYIhB7WpFHNwvT8MW3P0f88xEbFGIHMsnlhQhMx28oHfNVyGpx06Sj0fhUVhtgeJ+0FPMgHy6+Zby6cQe8RYXTdb3nc5dks+2Zbgp0JuOuMhJRfctMeR/DCYkEbWzy3j097i7a8DIiOtSMR1tLDzG95c/fVAYbthFsNvwRN8HVKfmY3cH3/k7l7dJHKwmHGn0HYkkG4yiEBbkV7bj2gL3eKrBkLkFgUWPTHzgLt00wSyl07gnUFj0DtpfZVGylcjuHLSFMjSsDLZuzPLwA9c3SgzSFUxU/k+vH1DgiO4rzUqlfGnmgxBbie+tlz0fJSP4OHgi704r+PLfAOqjhgg5DDwAWXkgY/N6P+EmKzF/D9Q5KuVMmX/R2bqxkAJW7QuSKixbPYbK53lJarDY/6bfZahPFy8vRCct3XJ/FZ/kG7DhxCCXla2ozKSIq5KXD1PX9aKvgveRm579yVjyIVBOGp+zPtGLZEu0g0xjRbesD2lln14+8iHZFwoorpDz4SJJewii/Wr4295E/36wl4fgj3XqRKoRz6L5Oev4jK+xEfTsOsH4++tjE+QXw2lRRv+sKudZU4ulLLAqxtQKN/H2uIWRqpglT1CLbXixk+u26//ozWAUfbc3joJQHqZig2UPMKR4sT2Zyti
 47Ba0HNW
 gRrgPwUkICwdRoGihy+Ijw42wGEm1sie62SSd0AFfbjIJyWyeCyWDKlYOZEOvkp8aVN3wauN+58Lfr2rbwn+ZFuisT8JAZAweA+0f9pxofVqpRisCAHXXgPLWWxf4d1wBef8+TGXhWuiPYrKcEQbxcUm0MyqP7pHtSFnfN2GiNinc3pI9sBwr05T7mEB5kH5Ip+UJjBhufY7eIdlOxlLBcBGVIAFw1iF/2F3N2TabaWPeOTbXdboYfPaEKtDgKYOq5iKw/ye1uSNrD1WszziFctpO3UNUTrxHFZ+j1h6exiE+JaJ9uXVRTE37Ywy1tY/ifwIBsq72ir9nNGV9ukwq9KJm/Folt87+peqQ3So0OSerYm6nt0pvj3POl85F812mWNE0inpsGwq1Xv/Pi4QeHPDJYyl+z/IOUbHWiRO8IWuMNZ16MuGGmgGgHZ67lFwccWqvOwJgp3K1eOEsjR+U/ROScbVSGes5i8R3Ir3NZmLNzixXza3v0OOy2gFOLmFDmFIRylLQ5Nojp0aqUgEzz7mJDRYJGJFGpMOBPREDxDUSHT3O3DgO5d4spuqvwXrsuqzZ3G0QJu08UfHAjBHeo/eI9tMTbI7YRboAHV9Y+U5PdRMjN5P5enVsPYQRpJHAo/abIV/we6dU7cezmPJKbcRsRJ+Njfb68SXelr5YPsuhSpfc8VyBjKiFy3qKIEo3gH95SFpuQRvU7g2jECMUlEzPXIC7ty8ddkSFBHCyRU9dQzAEEu1mIZ2ZHNPVieJJHGNBhgA6vwnkbP2gieedG7pA/FeO+DUnhKoTFDbATZkplrW1RJlb4pxDXWBY2b5/y0pzTb9rfX7PviTQYY9suLa6pktyL9otnh7e9/Dkw2KSDOlDHfUbo9gEesmzJAu5beCMbDvpfzncE+SbRYJ0CKiY1eum6iUSA2fly4BUrsy3km9uJGG1ZkxbKgobrE2ht7xmZMFDoeg7I0D1E3tA3w1EMGOM
 ghQNa6oC
 u+roUnOCVu/CI6DID6eZxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 fs/ceph/file.c | 2 --
 fs/ext4/file.c | 9 +++------
 fs/f2fs/file.c | 1 -
 fs/nfs/file.c  | 1 -
 mm/filemap.c   | 8 ++++----
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3336647e64df3a..5921bf278fff72 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1891,8 +1891,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * can not run at the same time
 		 */
 		written = generic_perform_write(iocb, from);
-		if (likely(written >= 0))
-			iocb->ki_pos = pos + written;
 		ceph_end_io_write(inode);
 	}
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 289b088f4ae58f..e84a144f3f8ed5 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -287,12 +287,9 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 
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
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5e2a0cb8d24d92..09b85d086d16a6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4661,7 +4661,6 @@ static ssize_t f2fs_buffered_write_iter(struct kiocb *iocb,
 	current->backing_dev_info = NULL;
 
 	if (ret > 0) {
-		iocb->ki_pos += ret;
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
 						APP_BUFFERED_IO, ret);
 	}
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index d8ec889a4b3f76..c1be636ef25729 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -645,7 +645,6 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 
 	written = result;
-	iocb->ki_pos += written;
 	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, written);
 
 	if (mntflags & NFS_MOUNT_WRITE_EAGER) {
diff --git a/mm/filemap.c b/mm/filemap.c
index 39484af4300e3c..e2045266d2f2c9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3891,7 +3891,10 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 		balance_dirty_pages_ratelimited(mapping);
 	} while (iov_iter_count(i));
 
-	return written ? written : status;
+	if (!written)
+		return status;
+	iocb->ki_pos += written;
+	return written;
 }
 EXPORT_SYMBOL(generic_perform_write);
 
@@ -3970,7 +3973,6 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		endbyte = pos + status - 1;
 		err = filemap_write_and_wait_range(mapping, pos, endbyte);
 		if (err == 0) {
-			iocb->ki_pos = endbyte + 1;
 			written += status;
 			invalidate_mapping_pages(mapping,
 						 pos >> PAGE_SHIFT,
@@ -3983,8 +3985,6 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		}
 	} else {
 		written = generic_perform_write(iocb, from);
-		if (likely(written > 0))
-			iocb->ki_pos += written;
 	}
 out:
 	current->backing_dev_info = NULL;
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597



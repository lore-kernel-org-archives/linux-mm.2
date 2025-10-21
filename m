Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C7EACCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8478E000A; Tue, 21 Oct 2025 03:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9805F8E0002; Tue, 21 Oct 2025 03:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8957F8E000A; Tue, 21 Oct 2025 03:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75A598E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:10:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36A7E140357
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:10:03 +0000 (UTC)
X-FDA: 84021247086.24.768B14E
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0C52A0008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:10:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=OUEiUTF5;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf15.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9ehURESYE/FlGbnKhMBWJDg3bnRGJGCmyBZSmWKczc=;
	b=oQywkPXteDYhZnbfqssrkAxSDYa6gHm6Embl7HwU/tkkDn0V3GLVXh5uWj+ah/OsJVWWvg
	FxlC4t+8a9OEUPfXtKE+jrdgF9r9yKai+G7nCCFVqhMWMU6bFXzUZzu8RU8p20DUrXBDaF
	UUcacjHTpKMdKdPlT00Adblpmi/wLRM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=OUEiUTF5;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf15.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030601; a=rsa-sha256;
	cv=none;
	b=gq2pantlUfh7jluxGP5gQQEyW/JZKxV8wl6Q7gBQkmVq9ODsdzsYpAYP+Rvdm0QvVx0TdY
	UgfPIWafRpwRQnUEdsDI/rQUkpgm2UxEgRbyG5jpeoN/jIpKw2tTdJ7tuT8NZIl7DOgduV
	ftBe8i2jj3pPlGM6TYO5JW1BrhIeJMg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030601; x=1792566601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c9ehURESYE/FlGbnKhMBWJDg3bnRGJGCmyBZSmWKczc=;
  b=OUEiUTF5SmI43Yw9z8EevXraLBPkhggOHJKGYoScuKZr7C+B4aOEafGw
   IitJdxCjtFNXg4RLgFVFV4w77fv96VR7YxFNV/aOY7t/SiSeORlY3DeNs
   LDj3K0L3NxC1pmXMwoWNklw5GPmusHKrFWIxSZO0tckcr7XoASuHJzW0k
   8qzXiSSUX3ddPT5IHh716odqu1kdTJOOzTsYBlF571Aq+SoMEl+l1nccC
   ylFc1HPBs6QX4UvrRlhf8DRYcutzL/GbO8QIrBkh6r2Zo8NvIs0n1ygZB
   thmxdsYLWryltjK/YSCFLsIqdRP+cG3jBYF7TmdION4g9XyQ7NVhaLKps
   A==;
X-CSE-ConnectionGUID: bVruJ4WDRMK5ZgB6aLYZ9g==
X-CSE-MsgGUID: ey+Ss73iRgm2E0Ht00LPgQ==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3939069"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:09:59 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:28056]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.58:2525] with esmtp (Farcaster)
 id 533d5b60-49a1-492a-8ab5-004364c4dd08; Tue, 21 Oct 2025 07:09:59 +0000 (UTC)
X-Farcaster-Flow-ID: 533d5b60-49a1-492a-8ab5-004364c4dd08
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:09:59 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:09:48 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <nagy@khwaternagy.com>, Christoph Hellwig
	<hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke
	<hare@suse.de>, "Darrick J. Wong" <djwong@kernel.org>, Al Viro
	<viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, "Anna
 Schumaker" <anna@kernel.org>, Chao Yu <chao@kernel.org>, Christian Brauner
	<brauner@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn
	<johannes.thumshirn@wdc.com>, Matthew Wilcox <willy@infradead.org>, "Miklos
 Szeredi" <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, "Theodore
 Ts'o" <tytso@mit.edu>, Trond Myklebust <trond.myklebust@hammerspace.com>,
	Xiubo Li <xiubli@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	"Jeff Layton" <jlayton@kernel.org>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Christoph Hellwig <hch@infradead.org>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 6.1 2/8] filemap: add a kiocb_invalidate_post_direct_write helper
Date: Tue, 21 Oct 2025 09:03:37 +0200
Message-ID: <20251021070353.96705-4-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D033UWA002.ant.amazon.com (10.13.139.10) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D0C52A0008
X-Rspamd-Server: rspam03
X-Stat-Signature: 3pjdw6xmy78d1k9tce1qxgm46g1otb83
X-HE-Tag: 1761030600-659358
X-HE-Meta: U2FsdGVkX19LO53ifeMxJQ+R3FjJRKl1ZZVQZvS84W/JcJ+X87sSka+GVRF4glKQouKThbOnEHeHVSU/LbUo9QTWpZ0pMh93zpCoVp0IIx+wLi7T0bqS0IqJcoJcNRpXovb+iTrHMtNXxgVE/gfmOjPtY9bOj16GGNqQAoGCM/x2mv3o6tgEyhCMZtnylP6EKu87aXk/JU78p+O0tZNreYOKeCIHDfdLUhkUsxTGCjv/+PqnVLc0aXt96tvnR2N7DFn/9zEuTZW9mTWhnE5yklflSNjOy49kgjxhf9xnHaRgfIQ7XC4n24N3Fod3NeGsWMK0F8rTVXrc+U2QbhnpX5YhSKnXVWT3ZAnPsVcgksGkfN+Cbpy1EwEvadLLRajIlk/AX/3Bx80uCVMMEvbn/W4KAFK+TVlU70rr3sBZSlKOFbwqdNESq4ETTp+iYJ+dKSF5OPjJCXV3L4cig349MPTRv6ZVJtX41trTChDYV2Fqp+k+n5Br6KwwK2eOcw7e0CeiPp3Ki+qh9pC/2lJRIrMKkSAi8B/EdlSPNdinGqdTYOpQPC19kIiAZ/WEf6boh6aYYz3ORed916KfUeLbMMuHSF5ZenOgPSbn8cOAlIshuAa685Xd/OaMmcUXQJv3xOSvsiuUWBaKBH5Plxz+AH/aMct7O1eiqLK2ZuB6+ndFK26qrRbk3ZVktqeEE7A4L1ZoAI4GqLU3rnKBzBsSeOKWTSHrSmMrl0o500Pw8Rgg2UwIbEfqnTfXVMNoaUVFeF13YEr7/tpnGG3lpSFZTUwrd+2jmKOCKh+V7yy0q9TeuyXhAQ9t84hT+JZe9JUQH0BpkCjRGMdkZz9zt0lGzY2aaT6bwMyx468TuIL7Jw6bWTZzagZuhN/wTm4HCmxU6J6HX0TBMLN2i/XBX8tBqpINmXBZFb+alt5C89zzKaGSpXoSykSiF8YDOZ+sKrmVeLYEtY/xMYgInZhlUhE
 OrWQsvfx
 pA+RV17lvWHenatM2SZK0tBPgHSpe0nS5+gB9zY2tepCPENi5NoU527NXZIebosAhxILpdZNSwe+Dl83oXaFt6C7ib6kzWyGZYGmBCS06FWPYOxsVA4qnnDxlkZ5vnDME+toOl8lbdpXLO6t9cE6GTsrwnnCeREy9sHWOOqzUyLD0CRbK2iYDsohCO+WP8A3VC7b1Wn4DJgs/N+KOBU83jYKCmVoAA6Tav7hv1LzZdKTy98rjzqvs9JRxCUgCAkY0yihBq3nZYRcJ8ny8zyn/zTN/GCUnekzkT9W21s+nN8rKYXKRWkOQsnvynt68zD/58XRhAg5IlSTbLFp2dv2waWuYGvGWyVNQrdStVPNKfQZu5Ws+2aWkfcTwLrN96fZKbPJrx+xNFG6G8cUGJ8ViEVgG/F1xsXixSxLv1dSpZ85/FwHjglEV1c6akuY3hpN5yAJt7peUllk1sDBRL1KXO0qZP0igzMMr19MrekfNXeB3KWqnWO36TVJm/yaYzM79/Ir87cUfInwRJtv1xj7wiGXOkE+csFzE9Ep/q4KmpwbNUacx7+jLtqm4k5K6Df9OgL6CnV3Ncxf6A5OroEPAz+kJoTL0xE5eNV5GdhqgecfQrDH84cG5pPG5q/D5qmJCPBrWw9WASoA/YRc5mrbsRIkLnhPhpi3BC0RQlaKR9LUgSNOm8mjdHM28wxkNW1+f7DS9ZyA7beK5CgsumO73sBUqn0byU5dcy5x7UCkelyFXRj+wuX06lkC0xRV/DRGXIG0ehmwUFnsBePazk8NCRwPLIJsXH/g/+ptD3TZG05LmVtSn0IY8xYkaZ1yhNR4rprXodeJI6a3Oq4W5WHGdF6xslhqp1PUIq8LhvhB5MZCkAtQgmJTe5Cm6IakFQrp8kt6ckHC22MTNrw9bKHiWnHSnd55Za19EypmBAtco5vZ5ic27YmqfsUCo01B32/9DT++1h3QyIV4/lv7fOtZTo05V+F64
 JHJViRMQ
 nLimYihGuuFYTthNB0YVo0vBhUgwUMV44568uKAKI5C+glkLkSEwBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 fs/direct-io.c          | 10 ++--------
 fs/iomap/direct-io.c    | 12 ++----------
 include/linux/fs.h      |  5 -----
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 37 ++++++++++++++++++++-----------------
 5 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 03d381377ae10a..514042f12aea76 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -286,14 +286,8 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, unsigned int flags)
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
 
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 105c4a1d20a20b..9acfc9e847cdcb 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -81,7 +81,6 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 {
 	const struct iomap_dio_ops *dops = dio->dops;
 	struct kiocb *iocb = dio->iocb;
-	struct inode *inode = file_inode(iocb->ki_filp);
 	loff_t offset = iocb->ki_pos;
 	ssize_t ret = dio->error;
 
@@ -108,15 +107,8 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 48758ab2910087..4e8a3e4f894c0f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3371,11 +3371,6 @@ static inline void inode_dio_end(struct inode *inode)
 		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
 }
 
-/*
- * Warn about a page cache invalidation failure diring a direct I/O write.
- */
-void dio_warn_stale_pagecache(struct file *filp);
-
 extern void inode_set_flags(struct inode *inode, unsigned int flags,
 			    unsigned int mask);
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index bb462e5a91e28d..dfaa0990186716 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -31,6 +31,7 @@ int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
 int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
diff --git a/mm/filemap.c b/mm/filemap.c
index 0923b8df285886..39484af4300e3c 100644
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
@@ -3750,19 +3750,23 @@ void dio_warn_stale_pagecache(struct file *filp)
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
@@ -3772,7 +3776,7 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	if (written) {
 		if (written == -EBUSY)
 			return 0;
-		goto out;
+		return written;
 	}
 
 	written = mapping->a_ops->direct_IO(iocb, from);
@@ -3794,11 +3798,11 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
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
@@ -3809,7 +3813,6 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	}
 	if (written != -EIOCBQUEUED)
 		iov_iter_revert(from, write_len - iov_iter_count(from));
-out:
 	return written;
 }
 EXPORT_SYMBOL(generic_file_direct_write);
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597



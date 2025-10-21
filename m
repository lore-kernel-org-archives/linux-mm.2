Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65ABDCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55AA8E0007; Tue, 21 Oct 2025 03:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C958E0002; Tue, 21 Oct 2025 03:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B658E0007; Tue, 21 Oct 2025 03:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBC68E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:09:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 192B4C03CD
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:09:44 +0000 (UTC)
X-FDA: 84021246288.04.9C399E0
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf18.hostedemail.com (Postfix) with ESMTP id DB5CF1C000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:09:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZtqEpz+l;
	spf=pass (imf18.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRrO90fketCOWk9bfh6aaz0EBHE6DKiahtipOxhwoDQ=;
	b=k5wWaic0/jjMqsEFyXlvxX1+aGrt62noj4kGKXWcyAUE7t+ivvbHjpH2+3j+8wdXxKv1zk
	c4QwULWLj7cWPxA9lZihu6Y+tC1hxKv/xp26GPLXjVkZuxut/Q98fvsvK7IGkcTh0+nM4+
	BQcCxiG5X3wY9j6UnFzxUSpFWj8H5mY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZtqEpz+l;
	spf=pass (imf18.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030582; a=rsa-sha256;
	cv=none;
	b=EocDJZvx6S7Q1p/1W4ruhf0UFH1kNeFKW+9RheQ8ljOa4yGifHJNBiY6nNCIaVFYHTqxZY
	zD9iErONTI/y2eainAVSJSxjKKFd2o6/FVOwRBwN8amuqPZ41GG2rd5LRiroKyEpi01Ja4
	fqajJmmf4SxYMZ95KaiqAVS9cohxBVA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761030582; x=1792566582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IRrO90fketCOWk9bfh6aaz0EBHE6DKiahtipOxhwoDQ=;
  b=ZtqEpz+l4yW5MbsWrlc94A6RmkneXM+n8pq2kcB7zoecMUNT89Mss+Ew
   g6OtpKKtMdphvP/TfSt3gUyL3rYuP4ZhTAe9E7TrIkCiBHV4dVyWxig2a
   N13vQZVjU3tgb2K7u3XpvbKezUTXrpd1J9QQULfgbBrDo3UMmmGwHOjcu
   rUujrpb5IIohtmkN/xrbi+aG1rOFuldaeNA1LwKKcc6nKCEjA9ioVqecx
   e/RgJfFY7X6zONfnHCOI9V/nAsVLQLPMzbwEwvk4dJ4YHeksmy5en8o7V
   SqCwoGUjY5zC8w9mEK9AN1E+dSEWo4dip4J1xk22bs6CRP6xVEUVaEKx2
   Q==;
X-CSE-ConnectionGUID: TslvYmjVRZ67KeFhlmCKUA==
X-CSE-MsgGUID: BZ4tqt3BSO+r/jg1BcNIPQ==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3938994"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:09:31 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:2712]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.203:2525] with esmtp (Farcaster)
 id 3b019c0e-37f5-4041-9549-5b8fdb60007b; Tue, 21 Oct 2025 07:09:31 +0000 (UTC)
X-Farcaster-Flow-ID: 3b019c0e-37f5-4041-9549-5b8fdb60007b
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:09:28 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:09:18 +0000
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
Subject: [PATCH 6.1 1/8] filemap: add a kiocb_invalidate_pages helper
Date: Tue, 21 Oct 2025 09:03:36 +0200
Message-ID: <20251021070353.96705-3-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB5CF1C000A
X-Stat-Signature: c7jb1pihxfg1ujpe48hk8jmsig4jzxce
X-Rspam-User: 
X-HE-Tag: 1761030581-226238
X-HE-Meta: U2FsdGVkX18aZVRo6SKryo1D4ONxnPv01058u4rPqnbiCM4HaiRE4TTYW1wN7G2+gjJ2U8ix/hdYQtXsPYw4xwTLY8g4Zgt2kMe077jmVjL7S8KwpZjjUF7oUInbD/qtsug7z0eezjNEMqM3r+9H1Lcnf+sfKn+nl2QOaAzoJ+57VWou2xD/Nkuj6otIRY27BovLJGtm012YrDtRoeEyYKVsoyrIW/8kAGWFnaacJlHGeONAwZnvjuxbfGw8ZPaDWkxgFm2Bvds999Qh29L13tEvNABExOqcXqzk5DlGM1nyvD232KMn26qbv6wHH4en1CwNmwk3q2p0+9G7b7K+mGvSopINDL6Gm49rx/8VlVcgSgqzmgO3ItBYQhvYVheXKSI+yc4b6O5hgRA6T4oX1ex3Rn3jYJHp6/qVAInLYc8npUr8thhBoO7dLw3n/J3IokrftAYSjZioZa56wfDIHjOBIZIJ1uXLzLEusuetd5MNoauLQtaT9cUlgf7H0zE2Tler/HUY0oSz6ImO4FN3ej+Gy1ZEIZ7M60EzY625qOcLkPQ+D+41+CPGAPknuC6N6kWPDG3KBncQu+NpI+d0xf1m90SqjqmxWEG86AI0ogOPv5y9BbByYhcjsiX8u4Tk/yQiRPcI+LJP8xJ9tzTQ9lfIUZR+uEwAJLOicXPPkQSuIbP4wyro2SdDB5bU8EthSV/EGlEunDRr2FumJfGXT7zx0Rg3cUZ6oyomcTpKxoNBNNiJlG+PSCgTCHr4jrTNrTgKBuDhZfLqlZq/uT00kqtpjXF2Daga6wyfWJfL7KlT/mqbqRsuZZ/NBrhVMQz+JU4PuUlQLBIaoIacDPl/wj7V+lFWcTy10ArH8zN3XQZd1jALPmc5+y6LaWlTGb7MLREk6ziN8lvrUwE9cl1e3j/qilDDLuEjoXtVulmqnDdKQp1b7M5A4u8OkOKpSgEA2TxY2SzCLeAIY1y65Az
 RJcE5NHQ
 XLtczeqs+aLJxVku99FYqr680qLC7xvLAQgj6c9jNB06CzEvb5wIBspIyvXda/KdIN/mfRcnggKwMqA3sRkCNjlzFe91JgHNfHhKOSlPLgcYaSFj94Cl6NZVLtvJFAqsq3XBVpmYlRcJ/TolG1CwIlKfYkZ5bVwNGI7uIE0BDnzeoxvlpdkjWyDQnYD5mJUg0UX8FKFBYUN/l1CwOdHjtWpNdJ54iQkwIYMHu2Ya7JNkqH+Q6svj/tkY6cMB7rTwKhqICsCnMFk+rG1YuBj8+qe9rA3TTIsl9UXnDiq4FDbKNKYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 48 ++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1be5a1fa6a3a84..bb462e5a91e28d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -30,6 +30,7 @@ static inline void invalidate_remote_inode(struct inode *inode)
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
diff --git a/mm/filemap.c b/mm/filemap.c
index 2ae6c6146d848a..0923b8df285886 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2839,6 +2839,33 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
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
@@ -3737,30 +3764,11 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
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
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597



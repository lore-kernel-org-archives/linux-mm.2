Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF523CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62DE96B00A8; Tue, 12 May 2026 01:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605A86B00AA; Tue, 12 May 2026 01:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542926B00AB; Tue, 12 May 2026 01:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 426E06B00A8
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:38:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CC2CC1966
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:38:07 +0000 (UTC)
X-FDA: 84757661814.19.D064E20
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3BD8C40004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:38:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LiH5UIQa;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf12.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3njmnPYKfXyGxBuvKgaH5GivvgicyjwAkMmByhnmVfs=;
	b=tM4KnhdDDOKBJw1QnFJPmyShD2608ywE+hVj7l3F61OIRNf6SteTO+pp40YqpY+AnvjKFH
	no8KKqOSHZpx/KmUuQOd5lw5R1NQfs0xbF4rJVyEmTpbH0ygV776zddDRdjyiKElBfImQM
	BxVkha0zOIRSeY6Ddu5y/Lc3rNwp6Xo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564285; a=rsa-sha256;
	cv=none;
	b=N4rXILBzfeRa5UUJWZIt+ZbOtN1mjaKrxAH5ymcRpyWgB89LfJqiLH4Py4mrHga4EEmEEA
	xrxmo8DyMHCy32Tf4gqDoCGTM/jA9Yu1WDKi88VaK3nPrChU+hkOs9DUDTEPX24xaa0PkO
	cUvZXDSQw8R5Cg+nTWtkY15EZtN7s/A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LiH5UIQa;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf12.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3njmnPYKfXyGxBuvKgaH5GivvgicyjwAkMmByhnmVfs=; b=LiH5UIQaX7gQOxBmNMmgiW2c9M
	Sw4TUVUPyiAW+otc+CLl1MH8cNxafrJTke/+5h9ekIgkCCE6wUvC0Wp/hsAmzQNABnrIxxB0la6W2
	K+LEhQeH/uU0PTzGQAOaFzioXzpzvrHVQb9T7pD4RjGUwIVj2SuL6wcODRIImWU8mDrJOyqjI519P
	iBAKU++IsFSrs/7KErD6eQrhXvg9hTd/dViywq3t2OWMC0EJF1+UjOFOKgyCW5nmJEynP6BjIbd8B
	EJroeuDhIKqm7kAp5yFSu5BfA2aMaik60jjBnsCTMAt7RoUPFZ2/yWx0pC0EtQgHohGzZbgEPGihn
	jJKGY1xg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfoa-0000000FfVQ-2Hu2;
	Tue, 12 May 2026 05:37:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 11/12] swap: move struct swap_extent to swapfile.c
Date: Tue, 12 May 2026 07:35:27 +0200
Message-ID: <20260512053625.2950900-12-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3BD8C40004
X-Stat-Signature: gjhsfa49rxrgfzpzafrh1extedmi1pkg
X-Rspam-User: 
X-HE-Tag: 1778564285-645141
X-HE-Meta: U2FsdGVkX1+dx81u1RXWi6hfZKpLOE42DftmR3Gam1EXOz+u7YTR0xPYm1WCyRtq769jgLexGHd4GoFjBTaJ8enAKEKBhmio0/P1K6AUHr0CMZMF7URwV1qXLoODHMHffAhyw5d4PycPQ/Oe464hRne7wuGom9cnZn9NwYxo4QbBVaYVSf/Xopm1RIwz0THAGc/QVHvKCaeHyqGyDXTbe6tMiGhu+LW4ic5CxuZKfEl9gpXygC3xC4J3boIDxSrlOUq+JyYBD8PKOT1y6w8v6zWYRZP8cTk0fxPvuY5FeiT7yU20QT3lOwiByHkhmsSRTtY15DW4W18BFxSFD1id+ZKqUtFaXmqKcS9bD0QkclSJXCmcz4V8QEIgzqLBjjn+ldIAG2vP3qmY21d63s78PpXNo0bJnNn/IZfn2YjjhDzZKeqKn6Bu6blJFLyEWGO5VhDmoXt0CLl8d9bS2XRu6TXgKHyHSnuJPjYhn2bnaGjn0VduX9oY5ORaOpgTsjKCADMdKkHuSVp+US1iNUTbkVF+FdpejgPH2M4HwTQ7zdEO0hGUueanzA9caVlCb5zJOUDfdCk9hP9s9nbFpAGaGt79aQbq8Pc7+fGQtlviySAFyjYg5vWSaztVSJ9REx7OvqrsC35PWb7JbEj2WOaIEqWjXRuXa2FuJXWF8pY/nIJ+BwFYI7F7PEQBIdJ8fhA4sf5NB5C/if7qrd2gaAcybiRsTosxra6Ljs09Qc7YGQA0kAU6PzevMvUxUUu95iUwwaNkpkbw1EopgZ/ZDqm4WR5Cuhfpu9+C9rlmgVeAMcQjd9wq+yerGGpHnJuCzAAukqlCSBVo5uA3ntfU38T4gzGJUZBkLanyF45bo82DvWfXLJrZuM1gGd8YLx7q6iBNGofExBAeRXQi9KJzDbme34AfE7pc3AwO5PEx9gY03v8Ne4c2Yqfya5q2rKvL99NOnLVeTNaAJPpe4ElPB0g
 1b0ToG6e
 WDOEZv8rLMRG0d1iF8EPMiBcqci7k+kYWBVRt+2MVpeCffipomJTlRZKHDdsq5rVUE9ewUeeIR94clMOYzjHfuG2B02K8MZrZLD/B5bVOO80QrhBbSAL4+67Zj8mYJ2dC0HAJmNtPRTlmtBMgk9tpq6xVQoQrLlYkYclrf6bEkfc8bJujREBnFNxRafWL4nLbqKu4ui3D8PaxLq+WCACI6CnE6EpoBsMTUoVe9DjG+3EtfvdyfD3bjSiXBDWNYPFzKHdiF8RtrU2PQF7zANsDvxlnLaZip8A8AJTCjcHFariEOCCGm/BygamJ4kKhxJ6j1mWQAKZMNRpzkHykVArh+ibBTl67EKVYmqFBb9UaHnKr9QOGiOtVk3fcHLH4yrJ8JCdvMWfW5DqN/vjY9wrTGxXM83o0+41D1H0zNjwtcIJj172oHa4zMo/j0qPR2rlzJtDY0jOWfPtGToEP4mqPbMnB++LJU43ZwPXU3xUYVd3B7x9YkfkDy5Qfz73zXZSwXmg+GARPfjQl/Mpqp5tPE/wefc+6TxBxBuVCXZpZCC7jAk2BasnmrToOV8aLHNCphhg/KBHmk5vz8oiMImrgw39zLv1GnvZuQDe7Lud0cMqx7fAVNT+LwCDtPFC8Yp1hg/B7r7SIxuh4/e7vGopTlKgZgy5jdsSJEHD1DtCAnTa/ya9PrpJRwmxOtHGiXuiBA2P3zrSiBmncZwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct swap_extent is only used inside of mm/swapfile.c, so move it
there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/swap.h | 15 ---------------
 mm/swapfile.c        | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 916889738f08..95237ee065c2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -178,21 +178,6 @@ struct sysinfo;
 struct writeback_control;
 struct zone;
 
-/*
- * A swap extent maps a range of a swapfile's PAGE_SIZE pages onto a range of
- * disk blocks.  A rbtree of swap extents maps the entire swapfile (Where the
- * term `swapfile' refers to either a blockdevice or an IS_REG file). Apart
- * from setup, they're handled identically.
- *
- * We always assume that blocks are of size PAGE_SIZE.
- */
-struct swap_extent {
-	struct rb_node rb_node;
-	pgoff_t start_page;
-	pgoff_t nr_pages;
-	sector_t start_block;
-};
-
 /*
  * Max bad pages in the new format..
  */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 26852c2ad36e..c0479533f9ef 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -260,6 +260,21 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	return ret;
 }
 
+/*
+ * A swap extent maps a range of a swapfile's PAGE_SIZE pages onto a range of
+ * disk blocks.  A rbtree of swap extents maps the entire swapfile (Where the
+ * term `swapfile' refers to either a blockdevice or an IS_REG file). Apart
+ * from setup, they're handled identically.
+ *
+ * We always assume that blocks are of size PAGE_SIZE.
+ */
+struct swap_extent {
+	struct rb_node rb_node;
+	pgoff_t start_page;
+	pgoff_t nr_pages;
+	sector_t start_block;
+};
+
 static inline struct swap_extent *first_se(struct swap_info_struct *sis)
 {
 	struct rb_node *rb = rb_first(&sis->swap_extent_root);
-- 
2.53.0



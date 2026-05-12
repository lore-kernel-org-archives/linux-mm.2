Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779D8CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCEEB6B009B; Tue, 12 May 2026 01:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA55F6B009D; Tue, 12 May 2026 01:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2D46B009E; Tue, 12 May 2026 01:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF91F6B009B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:37:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AF4DA0388
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:29 +0000 (UTC)
X-FDA: 84757660218.12.962BCD7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id C0542A0008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=y18jNN6I;
	spf=none (imf15.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/e1E43Aw8DTZbb0PWgWlLEg76+pOp+WQ5laY13dT/AY=;
	b=07mq77wxUaPGWEjjya6/C9T00a3cyQD/aCMpaR1yy+DpBpboqmYrNogpFP5O/Sm898GT7v
	QqpvNLt/Fd8sgyqtRIn/zmxPTw8IpOeitSeUmKhCAXMw7J6i/rBmnDwRUm6iXC6XranP6W
	suEgnLwz1ffo9rrQ0XXHDoxYFz4F39Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=y18jNN6I;
	spf=none (imf15.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564247; a=rsa-sha256;
	cv=none;
	b=TldLNEc1ZpSTu4XawzMuHIAj4c54m2sm0GexMSLT1a+ju/+1jtuWEhro4GcoD1esNvgCqC
	oxY45n4+ITdFkg2p7N38pS6rgoEewMlOGod02CNMS3kjrRZ9dkdSekrx98QGMZf63cmGre
	R2RxcCGi6Mep+MPn5QGOHKmx5i1e5y8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/e1E43Aw8DTZbb0PWgWlLEg76+pOp+WQ5laY13dT/AY=; b=y18jNN6IPZlAJzD9Y2fqbDV5I5
	t70jJrjHcSzL6K2knltP7wGbdjaIIuebiXhzNNCkcG+TLWtCjasTBkVdIyDBJPH7qVtppi1Fon0/0
	D3YfBN/M4uLOPTU6ZZ/Acm4ajvvztkJ12cvkz9SgK99YpZkHkU8u7N0mI63biJ5dye+9DgbDNQ5DC
	dagBVq3ZLbxhntKH6bFTm/9bdWz4oWSJNz8PFJpzqmFN+krxQpbSd4hNsgM3ardXVB8DmstwokTGd
	c9RKK2S6TJNMY4e0fhrn8HP1lGValwj8cZabS4qvNOPa3s8r3rd4r/Vdf2NtDTYPDX4p53/9swG+5
	RMk1SW8A==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfnz-0000000FfNY-1SOX;
	Tue, 12 May 2026 05:37:19 +0000
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
Subject: [PATCH 06/12] swap,block: move the block device swapon code into block/fops.c
Date: Tue, 12 May 2026 07:35:22 +0200
Message-ID: <20260512053625.2950900-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0542A0008
X-Rspam-User: 
X-Stat-Signature: kkmhg6t6jaqmc384gkjitfncg9gdx9ne
X-HE-Tag: 1778564247-823824
X-HE-Meta: U2FsdGVkX19J0oh/eP7Oo+jmkxzXIM9Eq5f6iSl7LUCCaVxbpsazgNJSC8WDGDei7yFOfz3S/pePz21/mAiKjrCcZ7JojBEX4WRAaXidd3pNKhRq/1LLQlMv32/+DiIZFIjHe1OEgEjfG/T7EiTwdaApC13d3Xq3BBT9dV7yo4PTkQaqhXbaecazspMN88xdn+OrGqM2IcBFMcfiQTe4Gkv7vhaqieRFmrs00E6rASuAeUJtw1wv6Orxru+j6sjovMwdbsKzPoHDWHYr44i7qFTj0ezZ8/5xFC7PtidehIutkhupL/0Z2Yq+1ZSP67E1f3PMfD4g5Dwnlfgfep91M9T4CsGWRfU9LIG2EZU+rb7KxF5TpDqSsAP6t9ShcF3mnBVv5mwfZkBrwwEcIBp3j9haABG3MRGHuWi1kmwc/F1mc+SDMISEb4D1ajXkEhLKCXzOA4r8QJD9Ko3ZNmMfMG7YpT/hv8xnfwa9ZjPKdcteAaOi35EUs58iahO74yevv3XiXuOhT8WczFQi3XX7973K1o7W9DjOqLy7qZOc8Y10azRawW8npwpkjtd8PTP62ElDWfJV69fle+9FCSgMjV04ywFb+++YCjQHtZ0slG/BHl1mxUGwuDPTBrkbN2Zas8Udlc95YBgUh9X3Vz6wWrGpxF3hR4hJoi/0wP60D16NyNBt9gFssZ7v6dK7xj69cG16tjV9fnRg8sskf9CaBNkCxlWZa1F4ZCkhQoSuB5CeVM+rLCZH93gUPZfFpNAezm7Qi0VV1ZFvgZ7QWqPB99VqYUmXy9qkrC0/rNuo6mSqk/X2YcU5ag5OXDsqSLnP/r/lCGl9Aecivb7j4fyhap1AZ8TYm/UYxVl9UwvtM5NtO6u7NBP0J8hlNl6e2Ex62zcVzHK+GR9M4my6mBoTG2K10wyIKITKwLvra3alsYXA/DkyMPcboTw1iVEbY8VAxRYc8oMNO12Dtguwz/Z
 TWZmFUDb
 VvSCOxcUMDJ6ahSZf/7GqX0RVe3nNHSt6Itld0mUcSgmfbUKxxTXQT4ystyhVZxbDIs0H5POx2ivQeRKdnzj3IZ2GY0Bea+L3oKjmSvtRXY/SGXzsJLD2sIXk8z3l0RsECQ79l2gMZ8LPJ8i2Suh/JbELDoK8aOWioX6ZbtzxkTZ+ycIxJduGv97ooZZBuOtg6chyBVQj1ZJv30hKLXf6o7tgICEATqDO6RAQnZ+ChmxivDbt9XAtMBPfy8lLg+JiHt1d9Yl834vOpqkJ9m1vJs82lXyYKhrSGnCighlsIb7tOxZo8jffKBp6kXcBJurd2Ma5DG+UPA3Vvj5SuHC8nraHEeodCXUuIj0g5R5YyNXEIyniVMorzxjrYL+bY7kCVlxT8Pdi1TzqctMUL9Ptyaa30a1Wd6oXZ9azvWwXcg1CjZZs1QdF6jaEpwfTM+/5hjyl6bFeluMqclI6rlYdgUrfk6ZLGj0GL8Wf/dS8cj3wDfGN9y721wJxJh51jqBjr2KIwRp72Mwve5D3r3CpdWAaSROcllhyJw2hyWVMU8U8j11soVExV9iwm+bbuiNe+HuZhC0BnR8eBxa3IRX4cdf8z5FLwiNINHkmDzBhcT9hUOk6neJw49uuTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the abstractions we have.  This is a preparation for
moving more special casing down into block/.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c  | 6 ++++++
 mm/swapfile.c | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index bb6642b45937..453141801684 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -949,6 +949,11 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
 	return generic_file_mmap_prepare(desc);
 }
 
+static int blkdev_swap_activate(struct file *file, struct swap_info_struct *sis)
+{
+	return add_swap_extent(sis, sis->max, 0);
+}
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_release,
@@ -965,6 +970,7 @@ const struct file_operations def_blk_fops = {
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
+	.swap_activate	= blkdev_swap_activate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC,
 };
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1b7fc03612f4..fbf11c8c5c69 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2781,13 +2781,8 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
 static int setup_swap_extents(struct swap_info_struct *sis,
 			      struct file *swap_file)
 {
-	struct address_space *mapping = swap_file->f_mapping;
-	struct inode *inode = mapping->host;
 	int ret, error = 0;
 
-	if (S_ISBLK(inode->i_mode))
-		return add_swap_extent(sis, sis->max, 0);
-
 	if (swap_file->f_op->swap_activate)
 		ret = swap_file->f_op->swap_activate(swap_file, sis);
 	else
-- 
2.53.0



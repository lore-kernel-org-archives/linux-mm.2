Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1510CCD187
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A34D8E0009; Sun, 12 Oct 2025 22:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A7F8E0002; Sun, 12 Oct 2025 22:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7B98E0009; Sun, 12 Oct 2025 22:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09E1C8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:58:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCEB385624
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:50 +0000 (UTC)
X-FDA: 83991583620.15.CAD3DFC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 312B01A0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=v1agg868;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf19.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324329; a=rsa-sha256;
	cv=none;
	b=w/LqDkbxWWuEaTEyCQIGVp09IVim/W9IFXO4b7GhyyRReStK4/kqkJZ+Jn2SdM4LpXEWIV
	yhVz5zWWJYeMvY5+dOqPWvEYlu9fuH1QaWOboM8UoSLm0u8v+4a8Ug3uckPwvvsmQiA28t
	U7uEKg2lnktS4/NSYqzp6XL/VwLFcXg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=v1agg868;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf19.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/DAAkWmq2Dxx5Ncu78XnJSF3nOk6rkN/CJQmqoQWpE=;
	b=QaXwo9eKy15nUD4B8i4jgv62p7IcNUVCnnAawgBt7mIcuTMZbDvYnVmhIsKaHEX46giZRX
	WRfewrZQLEGt2jQqrOhfDy5O+VeULUHXOPjEQ0gk/AHNOHJQRryucaMz+8E+MNjY09xZY7
	KEl9gPE+rQQcL5mcmliURmSHOIkz3Hg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=U/DAAkWmq2Dxx5Ncu78XnJSF3nOk6rkN/CJQmqoQWpE=; b=v1agg868KstaamClRF27PcxAmE
	NMKTaFWdSt0z5b2C9IP/DIDFPD7zXPVT89f4fnltVINDZ7ES6vsQPElxFC8Wahjh08WYsbT8Xx4U/
	PvrlxExKr7jaW23AlDsdD/3j2gQcVjYHULOZMyDMyzZAqBWpkyeLiMq2U9gSiO/Bb+vmTVicLSNbZ
	Qw50TbDFEfFk6Sf3Mmkw5eCgl+dyz4UEdgpPZcRfcYmq7GLBuF6TNzL/XPkSkZp7sBy4pqKdLpQdp
	AvSJJr70eSzdh+IVUoaoKh1XmeJJRiWgDBOsuQnXsHq40oDaH/Fwf5GzqpUljOMhy5j7WEKmQ12Wd
	6GjFwTpw==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88lo-0000000C8BU-2H5E;
	Mon, 13 Oct 2025 02:58:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/10] btrfs: use the local tmp_inode variable in start_delalloc_inodes
Date: Mon, 13 Oct 2025 11:57:59 +0900
Message-ID: <20251013025808.4111128-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: rp3ky9szxbzqeq3r3y9fgti5i6mi976h
X-Rspamd-Queue-Id: 312B01A0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760324329-272212
X-HE-Meta: U2FsdGVkX1+GeOrv83tcyKWAZ2L1rfzZaDwGsIILBGi+BJ9jEDNkufYkCKAymuN0gRt6xjR7GIRUPFv3yBW/ooURA7KWzPdwXnDpSFO51wWiBtBIyZgn2kf+qrOZcn3hxj1cyTkADoY/FmPf4VKw81giyvCc6pdoA/c5pHxIsiyhFYDKIbP22BjQw5VnAjIgRo/jWTyOreTM4Q6m+F3oDTnl6u4YPuZXb3Y8Iy3iG58FAh6AePLPphiZxe4P9Lk7kBKKAD6QqNtmrWBW8n/tQXtT2iOpO0pmIo2P3ySTh/Aq/5CtSBMSowv+BQ9bEpYm+7fCjtnksHmsrs7HWuWah0ceP7Xs/QUwW+1fwava6PBzE419Iguntito2KhYdHiaLpwnb3yqD+4GC24WY0k+I97l4G4atWA7H2gLu8Qetc6WGWnBM/DwUU6vYYDjcJxnlYZZ3NURuBVx0de1fYmYLMiARCqnH5esr2B16HCY7+ojQO/bTTznV+H+wH/nB3LvLsacu0/ghuZ4tPjVVbX8vI3fEgznxSXBWKhLAPw+TTUkxfd8wasdJU4Pq2nQ1ALzDQf5FGejeEHAiTMTslqvxyXycR5CRlRT8VqGvXxAzidUAgcTBTMJ2TuRkcnkN47dauYHuz4g8MqAkTbdHm+eMmSZ0+ydgIzjSSqpr5HvciajaV4rQWJRa3do+QyzAFLhuriHHec6uFsDnqMru90hML6Cj2UqqUpWFdiX+PgZTd5qw9VRxzP3/gIhr54/e+77d4W92IvLKvNBmBzOCPYIcsCQkLx9Qcdn9C9elUbs3/9VSvoJLMfmEF7TALJwe5aDEfUJ7pRNtiepgaipO2sP9LvX3HJlhWeH6nE1c0Sj5cwjSOhP0Me4i0lOMy5tIVXWn1lEtIuYtmJ4NlUCJ9tqNW4NUz3FaCZ2eIqzJQXS6hLLEPBjJ3qrdh5D8K+j7VJHOtJ9WsMyWvrWiYdiy5j
 IjDbBtll
 LzXiNgJvkXm4lb65aMOrEjaIaTR9l9KiADF4tNfN4MhlTHvWDqKd1rPtj4K00kzy5dAF4jYHQFn1A9Dkj6NX98hPXQf1gKGjISIFZb0xL4Yku+uTqnj2KO1qmyVVPPutuzT0h+uvOxQvbvpCFb/jp4p2kAEjAk7LG50kOElSSeVI76I3g8Te0yq9XSTVNevD93dkhPYfpddZoCiTtdJPkIA2XGJlLEP6R+wMzLxkPG2t0guVd+8m5Tbhz8G2+2Cj2KuYiwDDSjhVXZNbhwITQiMGN1JehEbtF20dEssDtZxPCckRH/npwgcV2REBnXI0zAgUWnu6Qz7hKsSlI8EwcTv3WB/fVWbQzzff6qem/tH7EwMXyRAL5iyKBSPf8tDYvGN7FXogBx6Ex3+I8ChHlFAArYDC/2nL69oBFRe0QZ8r9ZNb0/VXBySFEiJUVtk3Zh1x8gWjoYmieJiAF1x3WCV+zaNeRD2jYc1nR1ZPqJo/8EmmWQeJkaQrG2iOujz5k4ae0WzMpmpdY+B2tk3cU+eev12893/MPdMVTYBb2gZhM4w2A1qNwfV9Px9rj1axJwk23
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

start_delalloc_inodes has a struct inode * pointer available in the
main loop, use it instead of re-calculating it from the btrfs inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3b1b3a0553ee..9edb78fc57fc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8744,9 +8744,9 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 		if (snapshot)
 			set_bit(BTRFS_INODE_SNAPSHOT_FLUSH, &inode->runtime_flags);
 		if (full_flush) {
-			work = btrfs_alloc_delalloc_work(&inode->vfs_inode);
+			work = btrfs_alloc_delalloc_work(tmp_inode);
 			if (!work) {
-				iput(&inode->vfs_inode);
+				iput(tmp_inode);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -8754,7 +8754,7 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 			btrfs_queue_work(root->fs_info->flush_workers,
 					 &work->work);
 		} else {
-			ret = filemap_fdatawrite_wbc(inode->vfs_inode.i_mapping, wbc);
+			ret = filemap_fdatawrite_wbc(tmp_inode->i_mapping, wbc);
 			btrfs_add_delayed_iput(inode);
 			if (ret || wbc->nr_to_write <= 0)
 				goto out;
-- 
2.47.3



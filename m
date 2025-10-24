Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC30CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4818E004F; Fri, 24 Oct 2025 04:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B7D8E0042; Fri, 24 Oct 2025 04:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB20B8E004F; Fri, 24 Oct 2025 04:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B91828E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:05:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C765C0DFA
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:05 +0000 (UTC)
X-FDA: 84032272170.22.F8F1A81
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id D9CDB4001B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MidHAQ0k;
	spf=none (imf27.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHvBUxtcyVHjSYHDlnvJ4K1d0lqno9jHSlEtLibjOIA=;
	b=vhXUQTzUqdkDPQawBaRzYHhFrP/ZztrIsPSoQ0chXKVE2c0gjdlMBv67HE3TCwSkPbYvKN
	AWVY3zgJqth9WCVtAQbb4VTOiBpkeOU44KC11As6v6oetYIBzt0Dt7BTrpqXhFR3nsf4a6
	IBzfjEn+X2K6udeSrtg/4Yu0yQ43auY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MidHAQ0k;
	spf=none (imf27.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293103; a=rsa-sha256;
	cv=none;
	b=E7jhupkvzBh/xoU5aZgxNKczBNciOhsKM87BS1/Qufmd8gTh/0fCDl2cnWyNDyO303/vbY
	SON9AVp+kz0KlsGBcohMLHJHkNTgQSFlBQBcjOcFtiW6O/7OBbkMqa6P1TC4aXwj4q9sMG
	36fRffdksz6h8cxoJiF9MH+6FAo0EJg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KHvBUxtcyVHjSYHDlnvJ4K1d0lqno9jHSlEtLibjOIA=; b=MidHAQ0kwxqlWDee9nUjX5/ncS
	/gU4JQOWSPMGAiFiG4yaffjRRz4MElW+Z2WYhMwXUVZWakiREcYe+ziH2B8X5Bvu2XQYQIaQQzbWV
	N0oWMwaWHyESKD7PyHomOsoOu8Guy7O65qijonMdiYnIXEedKnA+c9bYddZVHcIKmin5nHQeKLk/o
	edDFzGriSX5Pvxb4yJYL5rzOvMPTjTefiX0tXNO2lWVqdvU1hyciL/1qDgrgJ9Q+HV05qIN8ISqE7
	COsFc0cdNiZBzaigQNjXMS5B/ZUACtZbvri47/aoS80VVCs6ZOyP+fUSiPnv/2atttMGFOsL2sVoP
	rnAZBExA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCnC-00000008c3M-2cmC;
	Fri, 24 Oct 2025 08:04:59 +0000
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
	linux-mm@kvack.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 02/10] 9p: don't opencode filemap_fdatawrite_range in v9fs_mmap_vm_close
Date: Fri, 24 Oct 2025 10:04:13 +0200
Message-ID: <20251024080431.324236-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: dpdmpgx3k1u4isqnfoyxdbbu5gepq69k
X-Rspamd-Queue-Id: D9CDB4001B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761293103-230046
X-HE-Meta: U2FsdGVkX18GlNDbZl1HiF9sJTaUvLhnuRAMBGYjnFdCHifxjcnyN+psjbTUPU5ft4EEqSwIBtGjJoMyDIEaCS/h5pla16NaS9HatQsy8YWCPzq+Z7W6s/esGlVz2klGuW8N8UThXlFzT1N6yxMMVRhvK/AqVeCHk/TO3Yffp3EvE5sGdp4zPFigaLfEarwHPBR5zgIIAtiziAPDFgfz0EyUIj7596td6ucnAY4YGUnQW3LKQICYnuiCqvcS5yGub0PmMxYB0R2yvaNUedj6t/bVh345CDtXekvoh9pluLCajK1k2E4NJnXcXFKeLzPrxU+/JZiQPdMO0A3e7YhDX4K1xlHcbsjVPzWneFmp/HaKD6v9p33B8Dn6jC5KYS/+rwhE2tgAn3Spa1zFBAw7fL7ktvQ3SMR7WDuo1JoJYcJyGh91l4qEEUBYSJPNlQ0xNa2y/VCTN0N1YZpiVtJH1fsM3hVrK8fMhYtuXS9UykFDZ+rVctAOklqRWk7pmSnqwZKJza6WkYznPOrWt8nqMspQHqyyOBZkexZ9bPah0xp66aoQstNGSfh3XuUJOWHXXpAr95zWVOEW71ad/U6c0JaC9QS9ntue3HFm/69nc77RDNJNY97cOGoRl2udtaY3xjPMpQEuiQBT5ICTOn5gIihBS1MTLJqtzxCWePeR6i58vkqdntxIsjuhGIGQhNWywD3NeZxkHth4e7vfQ4k/dEOsAXz72rej6waos7U5TyDQ4og80CxrELaQARuUg2QiaLL5CXGyDvlUbUGgCsOWFXFnKdAhWgW577tzRo0UO9Td8H7bfs8yKF+VkotsHgY8LfkKFHOqU/KXD+bU0D+TYBYaKMFq3MbI12uQwCSw/vJOJL9Sx5yJNaL+eP0wufxngNu/hbf7WTgRePXpn7YlL1nK++2B17IxwplbCEB5t31yiZSFmVbn7m34dLl0oYWz1X4JgzEV8fugQlrpPu2
 BAeTVkxh
 sg7z2kaUwGPGh+hDzoThn2f9ATeP3Ket4vaKBqFTHxFmzlzIz70WcbuOzc0uKNgpI7FHYJ/XKB4Yoz5NBgjpeiuZC0r8Sey9OVQ1UX4yTkhbOueb4ced6SogoHxjCvklpi28DcUQPidbjWJtBgEn6dvGKu8rVFvwgFvRKWCqC0otC9dJH6yDfZByBvIhJVAl28iS8oQ/c+tT/lbflrgXFB3vma8ZWgVyn8MZ2XQk7LmK2o6nkEkPAH5iA751BuZ+xI5NlvPKzxwJKtXofeKYBgIxuTTnGI8c7jvcAZQXP/XTsek+Dw2UNbcaQbLCuIC/S5QyeOOpztkAgBwOw3xTfb/MlfzZc/sl+ln3McsyebgRPdDbKgq8W8Ahp7cHO3e9Tj2y/UKsdaulNYQZ3BI0MKSv0TpMKHJZYTlCIcXA0K5q8/hmRldmf7h6G3JMRrZIFrBM9jZPSmI0hRmLp9CmdkxZ28+T4bmdFB/z4zvBGfduRUAoicap/vlRY4E4wLcyB8CEtcDcWMxhprcQ/kW4F47hQhBVbP6VUe42utbGli+CMuJ6GYHQKAGvSbCOjXNZaB6zEAjhwYFtKRi00/J9X6FaD4zMjbxuRpWFNte6ZIc63g/eS+n9OkfcaCqNsPKh+eGpPoJwcqeyrW4ivWH3lkoFR6v19V+/iLXq3wB6Nt3cfe6hHX+OCpvYRZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use filemap_fdatawrite_range instead of opencoding the logic using
filemap_fdatawrite_wbc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/9p/vfs_file.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index eb0b083da269..612a230bc012 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -483,24 +483,15 @@ v9fs_vm_page_mkwrite(struct vm_fault *vmf)
 
 static void v9fs_mmap_vm_close(struct vm_area_struct *vma)
 {
-	struct inode *inode;
-
-	struct writeback_control wbc = {
-		.nr_to_write = LONG_MAX,
-		.sync_mode = WB_SYNC_ALL,
-		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,
-		 /* absolute end, byte at end included */
-		.range_end = (loff_t)vma->vm_pgoff * PAGE_SIZE +
-			(vma->vm_end - vma->vm_start - 1),
-	};
-
 	if (!(vma->vm_flags & VM_SHARED))
 		return;
 
 	p9_debug(P9_DEBUG_VFS, "9p VMA close, %p, flushing", vma);
 
-	inode = file_inode(vma->vm_file);
-	filemap_fdatawrite_wbc(inode->i_mapping, &wbc);
+	filemap_fdatawrite_range(file_inode(vma->vm_file)->i_mapping,
+			(loff_t)vma->vm_pgoff * PAGE_SIZE,
+			(loff_t)vma->vm_pgoff * PAGE_SIZE +
+				(vma->vm_end - vma->vm_start - 1));
 }
 
 static const struct vm_operations_struct v9fs_mmap_file_vm_ops = {
-- 
2.47.3



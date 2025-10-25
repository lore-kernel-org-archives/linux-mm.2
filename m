Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1163CCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F5B8E012A; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFD58E0135; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DA78E012B; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A96CC8E0126
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69D5B13C529
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.18.DED72B0
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D93E40004
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jT+j//JaoDDLu+S808PhPq9oj3M5wcWCAtGt+NsyuwM=;
	b=0XtlWuD6L5ZUpsx54EoOoAZRZ1K+ZOvO15KEY0yIpv3PptVx8SzCdBYNFwr3PsQwriMMcW
	fI2l0k+jgj41tjFC49EmBOLyp13UASRPKRUvqCxvLpUwi5BbfG7Gp6lO1/ePAtefapvkbx
	Di9OIEBuD+TZaGzDotYpRodwI/dov3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=VwOUR6zdAIm7PkXa0R1MtnL5VMVk+k1JnpeMcr/A2sa4U5b+Iz9cFnCeL+OIDkLwES6Eht
	fiCVGEkFnYKxTzHJ2jHm/YvUc5KP4KEO4sBJlDrX39eDC4UbdOl5iXr0NZP3Iz7qoL0kHa
	ODvGV8En0dXfslUnCN69Q7jBBraeLzE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcL1mzHzYQtqD
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id DFB7E1A1B44
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S25;
	Sat, 25 Oct 2025 11:30:04 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	kernel@pankajraghav.com,
	mcgrof@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	libaokun1@huawei.com,
	libaokun@huaweicloud.com
Subject: [PATCH 21/25] ext4: make online defragmentation support large block size
Date: Sat, 25 Oct 2025 11:22:17 +0800
Message-Id: <20251025032221.2905818-22-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S25
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4kAF48Ww17CFyUCrykKrg_yoW5Wr15pF
	WfAr15Kw45X3ZYgws2grsrZ3s5K3ZrCr48WrW0v34FgFW7tryvga4DA3WkuFyYgrWkJrZ3
	ZFWjkry7W3y5J3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJIQAAsW
X-Rspamd-Server: rspam01
X-Stat-Signature: rck3kwx6oers7bskr8c9u4fci1jn8g8f
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D93E40004
X-HE-Tag: 1761363013-651633
X-HE-Meta: U2FsdGVkX1+UTr/4aRTbtFjRtGYpHF8QjKl0mmiYsxxQjRaUxI2M4hmb7/UDvG3HyF570oSMc/F5xq7WrDUHtqTuLDeadhJM6Ht9IO/sz1mak3hjtS0pTq50yqVx3n1TpfS3jZ3Ztq2yCT+8s5qNfmkA78jf4XXk/gwSxilupADV4c046GL4PQoH6e74B3+rU353O6/kXhc27KF0X13laXIX1JzREKX/ooDvywcxJ8ldmGDhAUAfFomuPXe7ebVqBHf+cXrvKask75MXTkrtsWFAgGrbRLb4c8DENEi3p43fRhmG5SKokJ8dIUyxf9eQwQwF4JTMV3armeQ8RP/psoHYUZU+LtZGcYEAscvAuVSiS7VJs2gg5t0Foy4yMgSY4NW5sfJZ1NaHux5YCIBRkgHbYY3ZPNbeit/8mCcIPH8he8GsWVOL7PYAC7P8Q+s9UFpXryy7UvdwcxoW3RSXYJ3MKf3CDReym3awMRfRPeOV7pD4CgWN4F6pk3pg8DGp8+Vbc4ceE3EIF0oMxwSJkRPZ9K2naPPJTApvNjBEgJL5DOK3+3x5JfrXPwp5pqup846AcknjaNx8O4YwRjucVoPlQ/DqOmMSPNeq44UslhYGlFkA3NyPDWaK4OdZQ91sMjeRb4JpR1+bO35mOg78vd3rd82z6atcCjh9O1fLiB1s9OAtmVWNHf6MFoqNtvSnH0mK8dOkgrrqXEv9ouFgQWLu1nFlpGQBDzXGEPaZNj0t1wpZVKZq7cnfRJBy+7ueRUH592wYtQjPVsEOqwVH4hn8cGV/w8TIX2txQ3eed3NW8f2+2ZzgKPC92g0b2XTPOYUlZzXhZ0yhe2UWznxfdC3scWhcQAPzf5M1ctqumKrJS4ISv12296hIVZuDJvwovJGMz8COAoZkbRVnVTHKWbxUDJpRINd4QwsjmCxwixFwVGkkwzI3fka78Q7RW0fUe1an277uqGUsqd1xFUE
 k+HMNkmg
 JpsNAfsl7wJZ7FRO5NyauGbPYfuDKgUGIsiZg0Q4lZIJztpL5YqFmy+EeAUgxDIqzSXrddI52Ppu4weTxTIvqlA4YBOm2EDUsd0qW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhihao Cheng <chengzhihao1@huawei.com>

There are several places assuming that block size <= PAGE_SIZE, modify
them to support large block size (bs > ps).

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/ext4/move_extent.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 4b091c21908f..cb55cd9e7eeb 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -270,7 +270,6 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	int i, err2, jblocks, retries = 0;
 	int replaced_count = 0;
 	int from;
-	int blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
 	struct super_block *sb = orig_inode->i_sb;
 	struct buffer_head *bh = NULL;
 
@@ -288,11 +287,11 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 		return 0;
 	}
 
-	orig_blk_offset = orig_page_offset * blocks_per_page +
-		data_offset_in_page;
+	orig_blk_offset = EXT4_P_TO_LBLK(orig_inode, orig_page_offset) +
+			  data_offset_in_page;
 
-	donor_blk_offset = donor_page_offset * blocks_per_page +
-		data_offset_in_page;
+	donor_blk_offset = EXT4_P_TO_LBLK(donor_inode, donor_page_offset) +
+			   data_offset_in_page;
 
 	/* Calculate data_size */
 	if ((orig_blk_offset + block_len_in_page - 1) ==
@@ -565,7 +564,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 	struct inode *orig_inode = file_inode(o_filp);
 	struct inode *donor_inode = file_inode(d_filp);
 	struct ext4_ext_path *path = NULL;
-	int blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
+	int blocks_per_page = 1;
 	ext4_lblk_t o_end, o_start = orig_blk;
 	ext4_lblk_t d_start = donor_blk;
 	int ret;
@@ -608,6 +607,9 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 		return -EOPNOTSUPP;
 	}
 
+	if (i_blocksize(orig_inode) < PAGE_SIZE)
+		blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
+
 	/* Protect orig and donor inodes against a truncate */
 	lock_two_nondirectories(orig_inode, donor_inode);
 
@@ -665,10 +667,8 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 		if (o_end - o_start < cur_len)
 			cur_len = o_end - o_start;
 
-		orig_page_index = o_start >> (PAGE_SHIFT -
-					       orig_inode->i_blkbits);
-		donor_page_index = d_start >> (PAGE_SHIFT -
-					       donor_inode->i_blkbits);
+		orig_page_index = EXT4_LBLK_TO_P(orig_inode, o_start);
+		donor_page_index = EXT4_LBLK_TO_P(donor_inode, d_start);
 		offset_in_page = o_start % blocks_per_page;
 		if (cur_len > blocks_per_page - offset_in_page)
 			cur_len = blocks_per_page - offset_in_page;
-- 
2.46.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC8DCCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAAE88E0127; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F0D8E0122; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38228E012A; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE2378E0126
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74E8712A683
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.08.80A869C
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id F142E4000C
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4qHcHwir3jEyfOkAWc8RYN0aqMzoY4t3/EA8X/FltzI=;
	b=FLXmNxTPWz276ShQ7xYQgnNw38G+QUTjYORDYoByVlh0owjpRaxtmE4uT3ijDbYFjxzYqm
	7I0sJoABAxyq8dhUJzHq7h4YZaG+jRbrhq2GpIzb6d+YAE/mOtZZzL6oOSgqafiX1FoF0S
	Gj9deL1khqFHoJqigII8yIdyyRX0YQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=xeDddYe0McmbGyAAhy/dBuWIllBvR/Ql9ANHn1bvPbSC4TVVjGSoniZP/qGKjizUg4gfaU
	Yo/utYTwwxHEWwoXwE/xfw3pkAqPeoFH7tlrK0ezF5eLrTPkpNA0bL6QWZfikOoGrd7mEw
	7XPA7Fig0NtJNEzP40wWElh77tktEtg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcK2wzNzYQtmy
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 138EE1A17F0
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S13;
	Sat, 25 Oct 2025 11:30:03 +0800 (CST)
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
Subject: [PATCH 09/25] ext4: add EXT4_LBLK_TO_B macro for logical block to bytes conversion
Date: Sat, 25 Oct 2025 11:22:05 +0800
Message-Id: <20251025032221.2905818-10-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S13
X-Coremail-Antispam: 1UD129KBjvJXoW3Ar4rKrW7Ar4xAF1UXw1kXwb_yoWxCFyrpF
	WDuF1rGF48uFyjgr4xKFWDZr17K3W7KrWUWFWru34Ygasrtw1FqF1ktF1fZa45trWxZ3ZI
	vF45K34UWw43GrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	x2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJHAAAsr
X-Rspam-User: 
X-Rspamd-Queue-Id: F142E4000C
X-Rspamd-Server: rspam02
X-Stat-Signature: orhrhcr53b31digyciuti8xu191kjwxk
X-HE-Tag: 1761363007-255405
X-HE-Meta: U2FsdGVkX19+I9f5ZHp5bWVgxcvYgOXKDa/n1vcBUe2Mhrc8AsgPNub0NWqOaztr0G5S6AHk7s2d2nI7qgYjmA+ZZsp4yc2Ix/z22serx/hwI8KXvyODN3JIkUDHO2UYr03tyZ5sBDPZlHZnJ+mHCFsQ2RAFLqKjUQc9IYyJquWymzAmWkXaQQN1w67fNm0eYaRqRoQaFITjqF+FyERtGphq+UHRvviQh3ss0xy2O77qxl18OYAHhWDPKQz83KE2BAASxVzY5tMHzetqFoys17NZGeJLfjrr4dtE8RzTGtAHVWM06/imqeR+iQDpMzIx4n5LG9drCQ++akgsG0Ivpkklta+YuAiBquAJz06I5PVqfyLS24y6QD3lyu+t34QNttWO6iFL39P1WfHscth/LVTnSYFve0iaPcs5vPD9zZrPNqUz8kagj9TT3hJzZVWPgXZNx2e7ME9vl/gH3qBHqEoTQwqTndWcB7u8dflcHy6lsm44Grew+08+lTzoUAjm4VEaMzPSbJqqYsX7JitxsmyK/ti1ATVD2gkh4RwOSAxaMPauJzY5wF6nm3l8vnxszbJeEcImKNb2qHdEajHWQbDRgL3Zmy65FDWl7sMzJyPoA7uDCy7H6o7BG/jq7M/9mUkF58baMLFRH1QCtnQaqb12GWkUt9TOwoqB5SsWMTAtA2s8oOkG9fZiYxtaNlHZ3AXQ5TP3NkZbVANypERL2YxEexhUPVLZnERIyNwc1oxV7Owgxz0P7JewBV+Uski+I6eBcIc1DWdFICo9miNYccEnShT1kBosIQ3EtG4wuzl0ky7JeBTcqTvEkpFf9TKgxXBOSDNT4bsqxLY5X4bZWOrnau0rKsh2z+QXUGmsbzE1+T/z2BIIrgVmRlAJKIGI3VsvqWQMiwbPXBtoh4XuvOcQj7h87vpIUytRoShTOyUQ2XfNz6iXHoPIdN1zM866L8zh/iDyjrEkVaLo+Yx
 sYL7uijL
 Hl22yYnhSeXCar7x9PwVkbHdaCS3ecClNwBib/PXY7DKuXwA3eL/ePWcbmNlseWIDqO9HD1XuB7+ML/deaA6ERCX1PWY8izndndoymAwb40muEYch+zIXt3msCfhMtt1wMDM2xtNcf04NPZnCr8SeZEC7zTRgWRGKvClUDKFTPpbwuvc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  1 +
 fs/ext4/extents.c |  2 +-
 fs/ext4/inode.c   | 20 +++++++++-----------
 fs/ext4/namei.c   |  8 +++-----
 fs/ext4/verity.c  |  2 +-
 5 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bca6c3709673..9b236f620b3a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -367,6 +367,7 @@ struct ext4_io_submit {
 								  blkbits))
 #define EXT4_B_TO_LBLK(inode, offset) \
 	(round_up((offset), i_blocksize(inode)) >> (inode)->i_blkbits)
+#define EXT4_LBLK_TO_B(inode, lblk) ((loff_t)(lblk) << (inode)->i_blkbits)
 
 /* Translate a block number to a cluster number */
 #define EXT4_B2C(sbi, blk)	((blk) >> (sbi)->s_cluster_bits)
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ca5499e9412b..da640c88b863 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4562,7 +4562,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 		 * allow a full retry cycle for any remaining allocations
 		 */
 		retries = 0;
-		epos = (loff_t)(map.m_lblk + ret) << blkbits;
+		epos = EXT4_LBLK_TO_B(inode, map.m_lblk + ret);
 		inode_set_ctime_current(inode);
 		if (new_size) {
 			if (epos > new_size)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 889761ed51dd..73c1da90b604 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -825,9 +825,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
 		    !ext4_is_quota_file(inode) &&
 		    ext4_should_order_data(inode)) {
-			loff_t start_byte =
-				(loff_t)map->m_lblk << inode->i_blkbits;
-			loff_t length = (loff_t)map->m_len << inode->i_blkbits;
+			loff_t start_byte = EXT4_LBLK_TO_B(inode, map->m_lblk);
+			loff_t length = EXT4_LBLK_TO_B(inode, map->m_len);
 
 			if (flags & EXT4_GET_BLOCKS_IO_SUBMIT)
 				ret = ext4_jbd2_inode_add_wait(handle, inode,
@@ -2225,7 +2224,6 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
 	ext4_lblk_t lblk = *m_lblk;
 	ext4_fsblk_t pblock = *m_pblk;
 	int err = 0;
-	int blkbits = mpd->inode->i_blkbits;
 	ssize_t io_end_size = 0;
 	struct ext4_io_end_vec *io_end_vec = ext4_last_io_end_vec(io_end);
 
@@ -2251,7 +2249,8 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
 					err = PTR_ERR(io_end_vec);
 					goto out;
 				}
-				io_end_vec->offset = (loff_t)mpd->map.m_lblk << blkbits;
+				io_end_vec->offset = EXT4_LBLK_TO_B(mpd->inode,
+								mpd->map.m_lblk);
 			}
 			*map_bh = true;
 			goto out;
@@ -2261,7 +2260,7 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
 			bh->b_blocknr = pblock++;
 		}
 		clear_buffer_unwritten(bh);
-		io_end_size += (1 << blkbits);
+		io_end_size += i_blocksize(mpd->inode);
 	} while (lblk++, (bh = bh->b_this_page) != head);
 
 	io_end_vec->size += io_end_size;
@@ -2463,7 +2462,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 	io_end_vec = ext4_alloc_io_end_vec(io_end);
 	if (IS_ERR(io_end_vec))
 		return PTR_ERR(io_end_vec);
-	io_end_vec->offset = ((loff_t)map->m_lblk) << inode->i_blkbits;
+	io_end_vec->offset = EXT4_LBLK_TO_B(inode, map->m_lblk);
 	do {
 		err = mpage_map_one_extent(handle, mpd);
 		if (err < 0) {
@@ -3503,8 +3502,8 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
 		iomap->dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
 	else
 		iomap->bdev = inode->i_sb->s_bdev;
-	iomap->offset = (u64) map->m_lblk << blkbits;
-	iomap->length = (u64) map->m_len << blkbits;
+	iomap->offset = EXT4_LBLK_TO_B(inode, map->m_lblk);
+	iomap->length = EXT4_LBLK_TO_B(inode, map->m_len);
 
 	if ((map->m_flags & EXT4_MAP_MAPPED) &&
 	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
@@ -3678,7 +3677,6 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
 			    unsigned int flags)
 {
 	handle_t *handle;
-	u8 blkbits = inode->i_blkbits;
 	int ret, dio_credits, m_flags = 0, retries = 0;
 	bool force_commit = false;
 
@@ -3737,7 +3735,7 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
 	 * i_disksize out to i_size. This could be beyond where direct I/O is
 	 * happening and thus expose allocated blocks to direct I/O reads.
 	 */
-	else if (((loff_t)map->m_lblk << blkbits) >= i_size_read(inode))
+	else if (EXT4_LBLK_TO_B(inode, map->m_lblk) >= i_size_read(inode))
 		m_flags = EXT4_GET_BLOCKS_CREATE;
 	else if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		m_flags = EXT4_GET_BLOCKS_IO_CREATE_EXT;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2cd36f59c9e3..78cefb7cc9a7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1076,7 +1076,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	for (; de < top; de = ext4_next_entry(de, dir->i_sb->s_blocksize)) {
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 				bh->b_data, bh->b_size,
-				(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
+				EXT4_LBLK_TO_B(dir, block)
 					 + ((char *)de - bh->b_data))) {
 			/* silently ignore the rest of the block */
 			break;
@@ -1630,7 +1630,7 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 		}
 		set_buffer_verified(bh);
 		i = search_dirblock(bh, dir, fname,
-			    block << EXT4_BLOCK_SIZE_BITS(sb), res_dir);
+				    EXT4_LBLK_TO_B(dir, block), res_dir);
 		if (i == 1) {
 			EXT4_I(dir)->i_dir_start_lookup = block;
 			ret = bh;
@@ -1710,7 +1710,6 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 			struct ext4_filename *fname,
 			struct ext4_dir_entry_2 **res_dir)
 {
-	struct super_block * sb = dir->i_sb;
 	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
 	struct buffer_head *bh;
 	ext4_lblk_t block;
@@ -1729,8 +1728,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 			goto errout;
 
 		retval = search_dirblock(bh, dir, fname,
-					 block << EXT4_BLOCK_SIZE_BITS(sb),
-					 res_dir);
+					 EXT4_LBLK_TO_B(dir, block), res_dir);
 		if (retval == 1)
 			goto success;
 		brelse(bh);
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index d9203228ce97..7a980a8059bd 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -302,7 +302,7 @@ static int ext4_get_verity_descriptor_location(struct inode *inode,
 
 	end_lblk = le32_to_cpu(last_extent->ee_block) +
 		   ext4_ext_get_actual_len(last_extent);
-	desc_size_pos = (u64)end_lblk << inode->i_blkbits;
+	desc_size_pos = EXT4_LBLK_TO_B(inode, end_lblk);
 	ext4_free_ext_path(path);
 
 	if (desc_size_pos < sizeof(desc_size_disk))
-- 
2.46.1



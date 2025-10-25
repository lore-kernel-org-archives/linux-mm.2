Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57513CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8498F8E0136; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD548E0135; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34138E0131; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2596C8E012C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE8C2892C6
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.25.027AE47
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id B01E98000C
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363015; a=rsa-sha256;
	cv=none;
	b=cghAejBThKXc2VTupcI5hmL0Y3uA4qbyKTQ7n2bbAKj+J+5UCObECJnyKzU1lLAEAf5huj
	7cDh+JyVa1BTOvE7fvFdogrP1x/PFVJ6n3X6RetcpdiRj0WDzbsSn91Q300Yu1115F7DET
	Dx4aujZfBE2pm94ITOHgmHd8bM49Z58=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=deJcKFIitdu35KoRUKG9JER4XNxGGDS+myASrqznf50=;
	b=KsxSe+l1txCmvdoZi6dolsg0sKFTPik4t7fjIr3KJ4dc5Y0m3U3qOHvfmfiT+NU5aoWAud
	6T570cTzbKp4+jQW1jER5cZDIsXjc/XlJLcFmTS6EPDl/1UlhfKaq5GTpc6FyeY5wSyx4j
	GJgD6TQXKrTbz0y3Qv/U0Z89gyt/Ayo=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcK4yG9zYQtns
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 54A031A101B
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S16;
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
Subject: [PATCH 12/25] ext4: support large block size in ext4_mb_get_buddy_page_lock()
Date: Sat, 25 Oct 2025 11:22:08 +0800
Message-Id: <20251025032221.2905818-13-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S16
X-Coremail-Antispam: 1UD129KBjvJXoWxJF13CF47GF4xuFyDGF1rWFg_yoWrZr4xpa
	y7Cwn8Jr4kW3srursrZ3sav3WFk395Zay7A34xWr1fuFy3Ja4xKFy8K3WUXFyUtFWxGFs5
	XF45Zry3WF1UX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	x2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I7AABsD
X-Stat-Signature: b8ti3ytrpxy6ufpsenc6zj1d7mw58gr3
X-Rspamd-Queue-Id: B01E98000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761363014-604520
X-HE-Meta: U2FsdGVkX1+S3hTlhGIKn14Hy41+wCTEwHuenCYzkcNOHHKmkqKcIp4t5hfoBMFC+6u7a/pEuLvmkM44eBZDCcTFdjKujy66WyuTO3NK+o4lQUs2HVKRdO2dwAS7Q0oU4/ublPTAMrRIyyWmtbtLvk5cmgzEDrYfL9bEt6XeB3Z3No/+5l5CouFZfnyHmgkEseRS6oRz/HkVEiP0wJfMOBjg0FydxshtGZe2M8YwlFnK66B0eJ2YGxAgKObYNtW44VAp3Ffw6XzKZdf8xYlxbjcQjM5EfwR4kk7Mf4MhqFwOV75rVX0vIqNceVfsjwEROJuRU2nR/MMU/58hWFpxmsx+f5XcIohXYDDRP+jEy7PS/N7ECIX/7ZHHfulFMW7pACDdU5ERYAB8n010LbeQNr2IWBJaKMGAAHsVikulic0HD2niTzVdIb9QoA5LOik/tIC2+cM6KePTYycdh1WsRzQJdmJlZ4v3uiwHRjMq10A5oWOSVKeY3/u4YuwALGMbDB1WYI+qbzprtE7rdXpJNEyVkjR1dZLcMqtXUHN5sTSxRtvoE4qZOJyrmonjoTkxJLr2e0cY7yXx4LOcLmmRed5i4HXeUC/GdgJ3SzGNvxQiG/V6x9n7DwHxJROMN4enkS3bAfxvNfBxNx3hyy3DCzB58uJzjA70K2h7xyWcxqe3LkHxw3rNQYlpH095+R1m51Qed8TsuuXfAKBkXCzyyVOry+/sUh5h5M9UgejdNmix0U6eNsfM71haUMZoBvpTOkIn/ghyGZvzXaflU5fP0d3fwSKys+HZYQui5R4UceU+J1lq07e2ZI1egYMnLWPIJMV2OPHxAG6zBesuRl6FmfqtcfmUQhwwWwyINF9Dvi7OEhPBZrreeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Currently, ext4_mb_get_buddy_page_lock() uses blocks_per_page to calculate
folio index and offset. However, when blocksize is larger than PAGE_SIZE,
blocks_per_page becomes zero, leading to a potential division-by-zero bug.

To support BS > PS, use bytes to compute folio index and offset within
folio to get rid of blocks_per_page.

Also, since ext4_mb_get_buddy_page_lock() already fully supports folio,
rename it to ext4_mb_get_buddy_folio_lock().

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/mballoc.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3494c6fe5bfb..d42d768a705a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1510,50 +1510,52 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
 }
 
 /*
- * Lock the buddy and bitmap pages. This make sure other parallel init_group
- * on the same buddy page doesn't happen whild holding the buddy page lock.
- * Return locked buddy and bitmap pages on e4b struct. If buddy and bitmap
- * are on the same page e4b->bd_buddy_folio is NULL and return value is 0.
+ * Lock the buddy and bitmap folios. This make sure other parallel init_group
+ * on the same buddy folio doesn't happen whild holding the buddy folio lock.
+ * Return locked buddy and bitmap folios on e4b struct. If buddy and bitmap
+ * are on the same folio e4b->bd_buddy_folio is NULL and return value is 0.
  */
-static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
+static int ext4_mb_get_buddy_folio_lock(struct super_block *sb,
 		ext4_group_t group, struct ext4_buddy *e4b, gfp_t gfp)
 {
 	struct inode *inode = EXT4_SB(sb)->s_buddy_cache;
-	int block, pnum, poff;
-	int blocks_per_page;
+	int block, pnum;
 	struct folio *folio;
 
 	e4b->bd_buddy_folio = NULL;
 	e4b->bd_bitmap_folio = NULL;
 
-	blocks_per_page = PAGE_SIZE / sb->s_blocksize;
 	/*
 	 * the buddy cache inode stores the block bitmap
 	 * and buddy information in consecutive blocks.
 	 * So for each group we need two blocks.
 	 */
 	block = group * 2;
-	pnum = block / blocks_per_page;
-	poff = block % blocks_per_page;
+	pnum = EXT4_LBLK_TO_P(inode, block);
 	folio = __filemap_get_folio(inode->i_mapping, pnum,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 	BUG_ON(folio->mapping != inode->i_mapping);
+	WARN_ON_ONCE(folio_size(folio) < sb->s_blocksize);
 	e4b->bd_bitmap_folio = folio;
-	e4b->bd_bitmap = folio_address(folio) + (poff * sb->s_blocksize);
+	e4b->bd_bitmap = folio_address(folio) +
+			 offset_in_folio(folio, EXT4_LBLK_TO_B(inode, block));
 
-	if (blocks_per_page >= 2) {
-		/* buddy and bitmap are on the same page */
+	block++;
+	pnum = EXT4_LBLK_TO_P(inode, block);
+	if (folio_contains(folio, pnum)) {
+		/* buddy and bitmap are on the same folio */
 		return 0;
 	}
 
-	/* blocks_per_page == 1, hence we need another page for the buddy */
-	folio = __filemap_get_folio(inode->i_mapping, block + 1,
+	/* we need another folio for the buddy */
+	folio = __filemap_get_folio(inode->i_mapping, pnum,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 	BUG_ON(folio->mapping != inode->i_mapping);
+	WARN_ON_ONCE(folio_size(folio) < sb->s_blocksize);
 	e4b->bd_buddy_folio = folio;
 	return 0;
 }
@@ -1592,14 +1594,14 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
 
 	/*
 	 * This ensures that we don't reinit the buddy cache
-	 * page which map to the group from which we are already
+	 * folio which map to the group from which we are already
 	 * allocating. If we are looking at the buddy cache we would
 	 * have taken a reference using ext4_mb_load_buddy and that
-	 * would have pinned buddy page to page cache.
-	 * The call to ext4_mb_get_buddy_page_lock will mark the
-	 * page accessed.
+	 * would have pinned buddy folio to page cache.
+	 * The call to ext4_mb_get_buddy_folio_lock will mark the
+	 * folio accessed.
 	 */
-	ret = ext4_mb_get_buddy_page_lock(sb, group, &e4b, gfp);
+	ret = ext4_mb_get_buddy_folio_lock(sb, group, &e4b, gfp);
 	if (ret || !EXT4_MB_GRP_NEED_INIT(this_grp)) {
 		/*
 		 * somebody initialized the group
-- 
2.46.1



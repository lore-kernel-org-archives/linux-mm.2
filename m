Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D34BCCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5C18E0130; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236818E0136; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27618E0137; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C67948E012F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D28112A660
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.21.FD79A8E
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id F012540002
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nj71ZBP4GVj2xM5JcA9JGkYO2oPeq/NZ1ZLN+B8PR88=;
	b=0Z4H2PZDZQVwSyHCSj7R+mxdng8exb0Hqo7K+ipc+ug6WUyULmSTItf4YWfOSyZC1ev94V
	TRXpam3nNT1jBnyiHgZ0rbHZiLJeTY3zTluAFZmlzL+fzC5PzyEe/3slfYVd87PN7cDoFP
	GLbmmcYMio7dVaYZeTGhLvYAi1Rmg1U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=Mk5hm813Iz7n5viFs/QJjyJ6huUDKd5lU2tp3WcgYj9UykhiaNeS2YsxQ9DByxEJgBcYo4
	UCJzy1/qQjzjVa5B2hK3M0wcndzG5+nJl5WDPxQrt3v7yv6K30usiSz3JyNgY952phCaTX
	03OpHze5aaLDlhi2775Nw7iW03aATpU=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcS4ywVzKHMNv
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 6434C1A117C
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S17;
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
Subject: [PATCH 13/25] ext4: support large block size in ext4_mb_init_cache()
Date: Sat, 25 Oct 2025 11:22:09 +0800
Message-Id: <20251025032221.2905818-14-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S17
X-Coremail-Antispam: 1UD129KBjvJXoWxZw1ktr1DWw4UKFyDGrWDXFb_yoWruFyrpa
	9xKr15Gr18Wa97W3ZrWayvvF1fG34xZF47GFWxXr1xCFW3Xw1FgFnrtr18XFyUtFZrJFZ5
	XF15Ar13ZF1UXw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I7AADsB
X-Rspamd-Queue-Id: F012540002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bc5i3anmdsihgq5b9qws4i8mgo45nb1k
X-HE-Tag: 1761363013-733320
X-HE-Meta: U2FsdGVkX196+1DrW2L0dxrS24BM+iP0HS4JLOge8IOeXYPO9sWcS8WgzXaIVKSb9i5TACVbzehi2MYuHw6aDW9GsiDr0OK76mwpRQN/snTO8UBqXQkj5RQFhmaGzIUSrLoqTJIBi0AdLju+WAoSiXhy02Wg2H2pZ+A8WOaP6EukJAMfGILlcFRshALPvZvXJV96OVg8e8SPixIOszf9vrWa6bYW7ClnZLj2Z0EqQUT7XoRN8zCzJMZL+itKcqF/G4IDqmDROG7li6IO0bcdrTc7QukjQ8BMEIN8OjiVqxhF/3g7vwdXNrvyPe77ySOi9gYO+DUkx83i1LnQ2pjeBJ/SWQrAIjuLGHhkYHNiC2kQUOQR0/iGXWmOQGJYNLcOPACSgtcl5jdGUAYKU+rCaianAQdpE302VaoEhzT3uSWeeiB0uNr3+gk67rI1VpM1c1QrWmgVpit1RSIh5K8l9o0OQE4BztWO7G/URlYQ+vyGrlwK6p8BcsPRBsbG4r2Xm50hZj7VqGMjubF+x32tCs8IURcuPrPxlD8nQC97Xsyv+Ws7cGvfoCZ+9zT2EG/Xs1lvYzvtmcLYG5zZar+u0vbnSEDgAjdmI/wGVwIvmwWwMIDXJg54Ok/bEbKYR55yJHSL+5In36C433JOaefN0ps7ezgDEMarox103sVg2Ga6pmucdikmF6Y+sbUv3jBZKpzYMuKUraFx4QKuQEtARfpeCSuBYF+m9fmj2PrG803GbFuB7Xq/NKZCE6lRbomTBGUG7Y+EAvx5eP9XBQhGnVZ6vGi3Qg2byjjyCL0Dmqwcd7c3yC1/5IXeK5nsv2R+qfOvwQ4Bs67n7WmDHf7XPHAy7knW3j/1Ew1AeLv0neUxTTTNJdJ3fmJIRDgaIS92oOvo9XddffaAHzKh49760O7Km3ENotgGDCG/ynnCq5HkXhpIy0tQIxOi+EPLmGIKqOO8/6F5n2P7S6rzrNj
 QIXwg5vH
 qC6ToPsaHnwhq7MtxBOM/snLIplZA86LIOoQqDsTz9kwS1LPT6cTGc5MXgg/ML1NXAejSNwQahb7XcPHnA+DtFV+ChLk+kto8Mpn8vuqeQILRBUPLkiikqFrGF+AuBJEyAioH/xITbZRz7hk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Currently, ext4_mb_init_cache() uses blocks_per_page to calculate the
folio index and offset. However, when blocksize is larger than PAGE_SIZE,
blocks_per_page becomes zero, leading to a potential division-by-zero bug.

Since we now have the folio, we know its exact size. This allows us to
convert {blocks, groups}_per_page to {blocks, groups}_per_folio, thus
supporting block sizes greater than page size.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/mballoc.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d42d768a705a..31f4c7d65eb4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1329,26 +1329,25 @@ static void mb_regenerate_buddy(struct ext4_buddy *e4b)
  * block bitmap and buddy information. The information are
  * stored in the inode as
  *
- * {                        page                        }
+ * {                        folio                        }
  * [ group 0 bitmap][ group 0 buddy] [group 1][ group 1]...
  *
  *
  * one block each for bitmap and buddy information.
- * So for each group we take up 2 blocks. A page can
- * contain blocks_per_page (PAGE_SIZE / blocksize)  blocks.
- * So it can have information regarding groups_per_page which
- * is blocks_per_page/2
+ * So for each group we take up 2 blocks. A folio can
+ * contain blocks_per_folio (folio_size / blocksize)  blocks.
+ * So it can have information regarding groups_per_folio which
+ * is blocks_per_folio/2
  *
  * Locking note:  This routine takes the block group lock of all groups
- * for this page; do not hold this lock when calling this routine!
+ * for this folio; do not hold this lock when calling this routine!
  */
-
 static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
 {
 	ext4_group_t ngroups;
 	unsigned int blocksize;
-	int blocks_per_page;
-	int groups_per_page;
+	int blocks_per_folio;
+	int groups_per_folio;
 	int err = 0;
 	int i;
 	ext4_group_t first_group, group;
@@ -1365,27 +1364,24 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
 	sb = inode->i_sb;
 	ngroups = ext4_get_groups_count(sb);
 	blocksize = i_blocksize(inode);
-	blocks_per_page = PAGE_SIZE / blocksize;
+	blocks_per_folio = folio_size(folio) / blocksize;
+	WARN_ON_ONCE(!blocks_per_folio);
+	groups_per_folio = DIV_ROUND_UP(blocks_per_folio, 2);
 
 	mb_debug(sb, "init folio %lu\n", folio->index);
 
-	groups_per_page = blocks_per_page >> 1;
-	if (groups_per_page == 0)
-		groups_per_page = 1;
-
 	/* allocate buffer_heads to read bitmaps */
-	if (groups_per_page > 1) {
-		i = sizeof(struct buffer_head *) * groups_per_page;
+	if (groups_per_folio > 1) {
+		i = sizeof(struct buffer_head *) * groups_per_folio;
 		bh = kzalloc(i, gfp);
 		if (bh == NULL)
 			return -ENOMEM;
 	} else
 		bh = &bhs;
 
-	first_group = folio->index * blocks_per_page / 2;
-
 	/* read all groups the folio covers into the cache */
-	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
+	first_group = EXT4_P_TO_LBLK(inode, folio->index) / 2;
+	for (i = 0, group = first_group; i < groups_per_folio; i++, group++) {
 		if (group >= ngroups)
 			break;
 
@@ -1393,7 +1389,7 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
 		if (!grinfo)
 			continue;
 		/*
-		 * If page is uptodate then we came here after online resize
+		 * If folio is uptodate then we came here after online resize
 		 * which added some new uninitialized group info structs, so
 		 * we must skip all initialized uptodate buddies on the folio,
 		 * which may be currently in use by an allocating task.
@@ -1413,7 +1409,7 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
 	}
 
 	/* wait for I/O completion */
-	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
+	for (i = 0, group = first_group; i < groups_per_folio; i++, group++) {
 		int err2;
 
 		if (!bh[i])
@@ -1423,8 +1419,8 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
 			err = err2;
 	}
 
-	first_block = folio->index * blocks_per_page;
-	for (i = 0; i < blocks_per_page; i++) {
+	first_block = EXT4_P_TO_LBLK(inode, folio->index);
+	for (i = 0; i < blocks_per_folio; i++) {
 		group = (first_block + i) >> 1;
 		if (group >= ngroups)
 			break;
@@ -1501,7 +1497,7 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
 
 out:
 	if (bh) {
-		for (i = 0; i < groups_per_page; i++)
+		for (i = 0; i < groups_per_folio; i++)
 			brelse(bh[i]);
 		if (bh != &bhs)
 			kfree(bh);
-- 
2.46.1



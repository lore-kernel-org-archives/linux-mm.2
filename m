Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7933CCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060D08E012C; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE51C8E0130; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590058E012D; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C52D58E012A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9218F12A682
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.08.25D3DFA
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 201F714000C
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=Y7GupSiUveuuDTMg5DMKMOnXQfonJeGuqvy24ZO7SYSAXOP7jsRLt3GtPFavVKc2aCjoeh
	4/fmCSRd5PPwQUKG40HgoAw2/pOzTBgzIJ2Oj79gpNRUJF2JMsHBhRvTjNaLo4C4peTWch
	piWxNNMVYcxFLDEumfAhcijX5aL7Z4w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMyCzWo3FLv3ep9dylvD+8TP9gEvKRlNTydLU9q5C3c=;
	b=uFEzyBKyrEAiJn/5vCx0L4vbEwtmnwh8ynEd/pwSxvuL8tlgpWC8PuLx5nwHwa8ypkwCL+
	c6eHwEc8xV1YNw8MevPpC460kIYi2y1mg1P0GptwZde1qd37bCgtzICNxkjwDo1C3k2IhR
	4KaTlkC+hQ3jOpyib0US3Fr09B9pj3Y=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcS43y2zKHMNv
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 462041A19C8
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S15;
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
Subject: [PATCH 11/25] ext4: support large block size in ext4_mb_load_buddy_gfp()
Date: Sat, 25 Oct 2025 11:22:07 +0800
Message-Id: <20251025032221.2905818-12-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S15
X-Coremail-Antispam: 1UD129KBjvJXoWxArykWFyUGry7JrW7Jr18Krg_yoWrJr43pF
	srGrn8Gr47WFnxWwsru34SqF1Fgas3uFWUGFWfWF1fZFy3t3WxKFnrK3WUJF1jgay7J3Z7
	XFW5ZryfuF17W3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJHQADsp
X-Rspam-User: 
X-Stat-Signature: e6j61un6fr36554xao599atwgue5c684
X-Rspamd-Queue-Id: 201F714000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761363013-762458
X-HE-Meta: U2FsdGVkX1+KRBKJfI9nd5MwYLloNuFxR2CaopkGVSPNMQzCrpi8Pm+nNsIOPvqQDCtYwMTtjJooi9WOTQoMF1F3+XZWSSDltW7RhiosIKLqHeCseoNzTo/EbaprceNpZuK4jqsFc3KUuSWT1kF9ql/7UP1G2yzLLEKrfNMEfg0bQxry4F1b7ZXZpE4K74aRI/wWiM4dXguIQcY8qNcTfP3k9SBp0EPOEItyPZwO+VlO+uozLcxaTYqFiRd8nogzINoWQoRc65ddfV1Co2ZANdI3JrYsVN2OuNm0szNA5gc6qnf+X/nBXEoxMeA/LbAK/bxkn5wOA4c5ZJxzQgGUoIDUAAAVdTJrJH8+vo5rruD+XZBGqLCNflUDTZ5rFyhsnfb6olBKdx6JNOtrjhXpD6s/mPJ7Dt6g5Hx4q+qVSEPmJjlChWxdajOFvmvSApy5piuJH37ebw/uEInc4bdURk463HTav+UnUZ1aJrbvR64m0vdt+UlhcpnS5lM4Iup54xD83DtqqGr680EeKH6rQ8vn40hKH/1j8HuMQbqzwhLxHUsc+KZw92PcrGtrKAHg5nJvK1wKP4qJWFv/90sYJFF7sBJ0QS78rxv3S7Wh7VxtY3SV7y9kiYyOSVrKLRdRihoEDYc9cFV7+Tod0zc2qb8YN61bCvJQX+W5x+m6l6pn3MlM2AWmnbvfJxf3czYTlBxL6pQ72Z8EpgCJxH0ZmNQBufEZFZPvz/PZO+w1vGja8isH1HV8fgpiDTT9eb35qFbxgm4FkTKmowvNOd1vFzGJ+zzdnTPRNbIZ9WuxO/0+ZUztTfBvrv9cp/UawsbFWNSolGWlnpPK8jeqsv9r/tjVG560PNVPcehb31TVMHSPs+fFPPBJqcLL/0O0qHgzWU3fa3PRD1y5Rz94sDCqBDOJIaC/aFtPw9s00JFOUKwJFEzjTJdGkuU4sjTy2BA8WWuLGQo1Jf/y3kDP0ug
 BUYtjfTW
 ueP6r7NR/KEAM7CFq35RR3O9AtdvSF4uityy7u32flEHjqXbinxKAdRbshpKc5HikeOiYpsDYlQkOxltWwqIBo9essCj0NIoVnQ9V6ha8uav5UA+5NeSjsdYm50lM4T3asdlSzEABSjMvb94awDR5WDB1/lBTn4fKBVaskxClzyPYIg0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Currently, ext4_mb_load_buddy_gfp() uses blocks_per_page to calculate the
folio index and offset. However, when blocksize is larger than PAGE_SIZE,
blocks_per_page becomes zero, leading to a potential division-by-zero bug.

To support BS > PS, use bytes to compute folio index and offset within
folio to get rid of blocks_per_page.

Also, if buddy and bitmap land in the same folio, we get that folio’s ref
instead of looking it up again before updating the buddy.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/mballoc.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6070d3c86678..3494c6fe5bfb 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1642,17 +1642,15 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
 
 /*
  * Locking note:  This routine calls ext4_mb_init_cache(), which takes the
- * block group lock of all groups for this page; do not hold the BG lock when
+ * block group lock of all groups for this folio; do not hold the BG lock when
  * calling this routine!
  */
 static noinline_for_stack int
 ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 		       struct ext4_buddy *e4b, gfp_t gfp)
 {
-	int blocks_per_page;
 	int block;
 	int pnum;
-	int poff;
 	struct folio *folio;
 	int ret;
 	struct ext4_group_info *grp;
@@ -1662,7 +1660,6 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	might_sleep();
 	mb_debug(sb, "load group %u\n", group);
 
-	blocks_per_page = PAGE_SIZE / sb->s_blocksize;
 	grp = ext4_get_group_info(sb, group);
 	if (!grp)
 		return -EFSCORRUPTED;
@@ -1690,8 +1687,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	 * So for each group we need two blocks.
 	 */
 	block = group * 2;
-	pnum = block / blocks_per_page;
-	poff = block % blocks_per_page;
+	pnum = EXT4_LBLK_TO_P(inode, block);
 
 	/* Avoid locking the folio in the fast path ... */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
@@ -1723,7 +1719,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 					goto err;
 				}
 				mb_cmp_bitmaps(e4b, folio_address(folio) +
-					       (poff * sb->s_blocksize));
+					offset_in_folio(folio,
+						EXT4_LBLK_TO_B(inode, block)));
 			}
 			folio_unlock(folio);
 		}
@@ -1739,12 +1736,18 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 
 	/* Folios marked accessed already */
 	e4b->bd_bitmap_folio = folio;
-	e4b->bd_bitmap = folio_address(folio) + (poff * sb->s_blocksize);
+	e4b->bd_bitmap = folio_address(folio) +
+			 offset_in_folio(folio, EXT4_LBLK_TO_B(inode, block));
 
 	block++;
-	pnum = block / blocks_per_page;
-	poff = block % blocks_per_page;
+	pnum = EXT4_LBLK_TO_P(inode, block);
+	/* buddy and bitmap are on the same folio? */
+	if (folio_contains(folio, pnum)) {
+		folio_get(folio);
+		goto update_buddy;
+	}
 
+	/* we need another folio for the buddy */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
 	if (IS_ERR(folio) || !folio_test_uptodate(folio)) {
 		if (!IS_ERR(folio))
@@ -1779,9 +1782,11 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 		goto err;
 	}
 
+update_buddy:
 	/* Folios marked accessed already */
 	e4b->bd_buddy_folio = folio;
-	e4b->bd_buddy = folio_address(folio) + (poff * sb->s_blocksize);
+	e4b->bd_buddy = folio_address(folio) +
+			offset_in_folio(folio, EXT4_LBLK_TO_B(inode, block));
 
 	return 0;
 
-- 
2.46.1



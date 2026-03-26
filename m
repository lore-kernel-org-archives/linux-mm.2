Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA0BF106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650E26B00C7; Thu, 26 Mar 2026 05:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4E06B00C3; Thu, 26 Mar 2026 05:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBFE6B00C7; Thu, 26 Mar 2026 05:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 232316B00C3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E34411B92DC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:56 +0000 (UTC)
X-FDA: 84587757912.22.674D019
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 93727180005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/uLEo7r";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1pa9WfLm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/uLEo7r";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1pa9WfLm;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=bpRfapNwShskaBHa2iW1wJlEEZL8CjDuwL5mIA3P6vzQ+1MXGTIdRHFFr1/2VbS1Ex+enB
	vGZx/vYWU3uXFoZsQjanUNAEx0FsdaRlRU48MGLWkpG69Ryolm1DfEQjCfbLP8N+Z7712o
	17D/GCDeZNjQGq41Ykd1tiWt8LBD2N0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518954; a=rsa-sha256;
	cv=none;
	b=46wESFOVt9dEgtqBOjeB1L973kIz0oTjg52K1uz1YtlYjrt1gzH2iDLK7GtcsrRK1yalQR
	xnTpbAmE9Ug+onGoBc8v7agbe66aSCI9IuvGbLkkLiQAJkbWMWk5238WJCrI130oafmQMm
	SqCiZQsMVKCOAUl8NekAAGnFmSlxrTw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/uLEo7r";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1pa9WfLm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/uLEo7r";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1pa9WfLm;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6953D4D283;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=g/uLEo7rXGrXHjkOzxqornYwO8D55hnybzSnvHf833t+3wYkpRy9Xo8XKdJahdOSvFwIWD
	VXeCcf7JE6FctkRkxZ53+CkZumAI5qtGdkniM/WZKLrjx2csNiHapmKERHPcNyV6svYgZK
	YuZYsIW+LgxeZTS7+JqMXWFI9n0278I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=1pa9WfLmFomg1L5oozQ22D1QK+lBooEk1mMezvcCzeBd+FqvWHJk0BeIWAc8GYsqDJyxa/
	vSfxw7SImiU1PYAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=g/uLEo7rXGrXHjkOzxqornYwO8D55hnybzSnvHf833t+3wYkpRy9Xo8XKdJahdOSvFwIWD
	VXeCcf7JE6FctkRkxZ53+CkZumAI5qtGdkniM/WZKLrjx2csNiHapmKERHPcNyV6svYgZK
	YuZYsIW+LgxeZTS7+JqMXWFI9n0278I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRtMeDaKzjnSe50bC9u1YlJqD3vALyRYeKO0i9ViSTQ=;
	b=1pa9WfLmFomg1L5oozQ22D1QK+lBooEk1mMezvcCzeBd+FqvWHJk0BeIWAc8GYsqDJyxa/
	vSfxw7SImiU1PYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F3AC4A0AC;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sng+F3UCxWniYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4C273A0C6B; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/42] hugetlbfs: Stop using i_private_data
Date: Thu, 26 Mar 2026 10:54:18 +0100
Message-ID: <20260326095354.16340-66-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3180; i=jack@suse.cz; h=from:subject; bh=TBJAp1vgW97AnNsMKdc/36W2ae98JPtniWixMTAK+B0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJGM589kUVC1RTs2x8EL+jKz9oU8EvkUQbFu rSC+eSRsTWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRgAKCRCcnaoHP2RA 2WjUCADE/11pgV1euunYPZejUo+EZ2IERerdr6bsaog5c+u38VVLzeV0BYVat0T9gAevVwwCkqM 1CqsKuiU9mK1rhYsqnlUI/NuF1zX0AGuGuf2HCnG+VqAE3GzgVDfEISrOpTWIxuIKCaWNwhytTi 3LP+HW/e4zs+18qAZnQvCvQdbGS1TxzqOJowuX3nmePKSxNsUnNZ9ty2jzeIWsJ5FuF0tWFoFVc 9/vV2Z3SUGFzejWTV1tl9PrTz4Itm4p5gOex4oO0EHOKi/fN25s4s0bsGV1JPYeJ+Jcw3CGD964 GiXNOqg6RfLB9u0KfhHYVum8ltGUKOwfWHLwbxpn8vvN79Lz
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: g7yzb31yqu48d15arwjqewbgrgnkdo8h
X-Rspamd-Queue-Id: 93727180005
X-Rspam-User: 
X-HE-Tag: 1774518954-747196
X-HE-Meta: U2FsdGVkX1+l/yHpUbeXyW1zQbhTJvGghvzpKEPwZtbWEUuAlYQMiom5YfXiVVC0tomBQP1F/888RfrpVJ0ibU/xfoz6C+KdkqJloQBnEjUp91R2ZSL8x4VWUquAIVeKBKR65nnklSvGb02Xebb8wZE6JvNaYRNrQLdG8/zurkgIC085lTP2Z5OQEoz5my/W7QOQJsxLRP7R/Hmjvq3vZNVTrJkRK6ic1T2jSACEztEhz3l2DyHjlB8IR16C1TDHBox24SB+RwkEJ4pgmNDXo9cUw//UF1B5/z4h5iwyvM6QtK8RVYl5jU5WoFVxtyoejvhRADvkk4TeEZrE1hJDqakSEmX/LRMlmLsrbDgwxe++BnLkLQ4uFHdVsvMvt8qlBlJyiFXJVw/eIQTpT1XhcGJyAPsPI1aC6b4H8scu45q0kIwDcCBSBEaOaKHFAXh9pgPFOSLtyzgc5fMDu9Be+8z5GpCdKP5E1EQVX/ve8dJq7kJI/j0t0zisS5/CPcMKtwL/pvHZfRe5XMqQOnGaxAM3lH/vgMNPkm11xlzKHhJwRxvGBwk0fTNxCVoJFh2jv/qrn5U73eYWwP74EY94m8UT+BSL+xca7ivcqKL6TvP1bBKV95Btb851yTFZ65nmLbu/dYgA+LX5GlIiSpEUIX1P19pX4KotQ5z1VuToFOAENfQponWQ7uurTUA+zl3Xk1QmIbP2DMWRXpImcLOv0V0fANPARN5B+FJNNmU+F6S6xW8e1VHDZTeC26xPW2Fvf4UMRSbm7fZspyiTud2c/1qqUS8YCN9xWROIsuWp5cNRE+hgXu+Ar9CifKzUQ71IXZrto1vEnONDDISVrX99jyipWnT/8UYL8XJMrN3g6hSgc/33sX8NnZkGOAorwwB6dGSvNEBiX+SK/AjC94SZ45BZi3FbV5q4l8NGk0G0nv9NSP/aOLXSwZWu8OjXL/21vlmJJcNtaEyGDhSdegR
 xNpZsLHN
 75debV1/q2txan8C4Vfa+7T1KtCXx5NErjzOywfM8L2/MN7YLSJ3cBXpFVk1+316MllxsXJ7Xpm6i8DvH2xmRQ33pdSoFjimFKXaoNKC0VEiGS9ZooZFbSjvwl7+uS4Sguh5MjYgmgx1En1bongmIPOT1vxDBLDMi4O5Bects6qiv8Zy0eh/vLQwJiRBUlnmMA+oMUOggL8OIQqwp4LxnX9kEhBMdWUAI6/2efKxM0TnxKh8LqeqjN1AuJMrhfujAtolj/xdXswEqhlUMAksOQ0Zjc9/b60TyWTC96UFaQITwRPFh6o+OMr9dsKBaPy81hQFu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using i_private_data for resv_map pointer add the pointer
into hugetlbfs private part of the inode.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/hugetlbfs/inode.c    | 11 +++--------
 include/linux/hugetlb.h |  1 +
 mm/hugetlb.c            | 10 +---------
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..6ad02493adfd 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -622,13 +622,7 @@ static void hugetlbfs_evict_inode(struct inode *inode)
 	trace_hugetlbfs_evict_inode(inode);
 	remove_inode_hugepages(inode, 0, LLONG_MAX);
 
-	/*
-	 * Get the resv_map from the address space embedded in the inode.
-	 * This is the address space which points to any resv_map allocated
-	 * at inode creation time.  If this is a device special inode,
-	 * i_mapping may not point to the original address space.
-	 */
-	resv_map = (struct resv_map *)(&inode->i_data)->i_private_data;
+	resv_map = HUGETLBFS_I(inode)->resv_map;
 	/* Only regular and link inodes have associated reserve maps */
 	if (resv_map)
 		resv_map_release(&resv_map->refs);
@@ -907,6 +901,7 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
 		simple_inode_init_ts(inode);
 		inode->i_op = &hugetlbfs_dir_inode_operations;
 		inode->i_fop = &simple_dir_operations;
+		HUGETLBFS_I(inode)->resv_map = NULL;
 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
 		inc_nlink(inode);
 		lockdep_annotate_inode_mutex_key(inode);
@@ -950,7 +945,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 				&hugetlbfs_i_mmap_rwsem_key);
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		simple_inode_init_ts(inode);
-		inode->i_mapping->i_private_data = resv_map;
+		info->resv_map = resv_map;
 		info->seals = F_SEAL_SEAL;
 		switch (mode & S_IFMT) {
 		default:
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..fc5462fe943f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -518,6 +518,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 
 struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
+	struct resv_map *resv_map;
 	unsigned int seals;
 };
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..2ced2c8633d8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1157,15 +1157,7 @@ void resv_map_release(struct kref *ref)
 
 static inline struct resv_map *inode_resv_map(struct inode *inode)
 {
-	/*
-	 * At inode evict time, i_mapping may not point to the original
-	 * address space within the inode.  This original address space
-	 * contains the pointer to the resv_map.  So, always use the
-	 * address space embedded within the inode.
-	 * The VERY common case is inode->mapping == &inode->i_data but,
-	 * this may not be true for device special inodes.
-	 */
-	return (struct resv_map *)(&inode->i_data)->i_private_data;
+	return HUGETLBFS_I(inode)->resv_map;
 }
 
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
-- 
2.51.0



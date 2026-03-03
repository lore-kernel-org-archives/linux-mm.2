Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04964EC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFAA6B012A; Tue,  3 Mar 2026 05:35:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B8C6B0128; Tue,  3 Mar 2026 05:35:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66AA26B012A; Tue,  3 Mar 2026 05:35:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2996B0127
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 123D5B83C6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:54 +0000 (UTC)
X-FDA: 84504396228.15.D6E2D12
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE4348000F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YPNl6puQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MySXVhPw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YPNl6puQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MySXVhPw;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=qldByrCzto1tGgFk/T7Bpqd0thoCrnpFoGFcqHEudfG0WOu78DRPA+m6BI2YjFWDb5enhR
	UOZVAkoz/JZweo0HOPN/EPw2GCUwEMW1ri7DiOTD6D8VQBNs+n3sd78ITVnmNpvhQ3S6rV
	mK5UOLakWIqcEkBYWMm3I6JFjtJo8jM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YPNl6puQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MySXVhPw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YPNl6puQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MySXVhPw;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534152; a=rsa-sha256;
	cv=none;
	b=6joNu/Y42jSPYMcgm62L5pDVUVfR50WdMa9xp8jrmFZgbQjPmg2p6QqC4sujgOahFjzx3i
	DwEGZ6Z04BvW8AVHgv1EbqQAHq0o1dsuyZbVn6ReXa1Dsp60hJHpJYgIIK8Vhvn9T8bnOv
	tK5xUZdao7MiNpcf7Hp/lzIZyyrlcI4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5CFF65BE2D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=YPNl6puQLgVKkD63r6SIjtVutZoZY061kfpbMYqVFc2f7+gRoL4+rtatybiqHH2ejyaFoo
	WYE3oomFZNscJP/Luqkf8x70U1BaM1mbf6S0Z8pM9EeOPMQN5BOU0rsVTwt6pQ7+inpn1b
	YTYnIYofqbTHtHgpXuzz8vGr3O5h47w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=MySXVhPwE6CN6puHiMqP6OrbSBNSa26DpHC97nbsPILgayNAPBOU/hREv1F29a1de5E9QL
	kHutncMOnjtEoHAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=YPNl6puQLgVKkD63r6SIjtVutZoZY061kfpbMYqVFc2f7+gRoL4+rtatybiqHH2ejyaFoo
	WYE3oomFZNscJP/Luqkf8x70U1BaM1mbf6S0Z8pM9EeOPMQN5BOU0rsVTwt6pQ7+inpn1b
	YTYnIYofqbTHtHgpXuzz8vGr3O5h47w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98i2n81N22OjNxKD8z5Vzb+jgcXij4nWl4IDEvXjQWE=;
	b=MySXVhPwE6CN6puHiMqP6OrbSBNSa26DpHC97nbsPILgayNAPBOU/hREv1F29a1de5E9QL
	kHutncMOnjtEoHAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5336D3EA6E;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8T9QFEW5pmmVFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 28334A0B7B; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
	Jan Kara <jack@suse.cz>
Subject: [PATCH 26/32] fat: Track metadata bhs in fs-private inode part
Date: Tue,  3 Mar 2026 11:34:15 +0100
Message-ID: <20260303103406.4355-58-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3643; i=jack@suse.cz; h=from:subject; bh=Klr3Q6lGdMhw22T2C4rNmSbbaDsuD4ARFy1ctXsRIyk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprk0Nb8WTsiqrQ3wqnPABtD09KVhX/JnKzkH3 rJjNnj+NYuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5NAAKCRCcnaoHP2RA 2eBUB/9c2t4EJuyg5ObQzoujC/9QbgxvCribk+6P6bTsMxvA37XBmEqV+SkD+FVEUhka6b0j9sg BQDNaItJOfnpGhaxyPNv5cRkSGtAh9a0J2GCubFQo0WoF5ecngxkUDsgnHN6d3j/3CHUtxsvDDf xYVv7/ISwTP1YGY7do1bbUKPFbsIqzt41T0c+ljeZbaDfOXP87RnDKnUtm/bygbnCZoDXmOsLKi oGHLeazAQ+eBGyiUnhxO9VGOdDQdT4QLSQxKNtZbvz0mrfyBBKA3t5x1imOElYSpOGzkEUhMyhb ybtTjz5zMRKRnsf03fWfeNTplX7eKUkP+c0mEDAG/OSot9gr
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b6tca5wkdz5mm8csdtj5446nnhemj5an
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: AE4348000F
X-HE-Tag: 1772534151-858285
X-HE-Meta: U2FsdGVkX19JJ2Slq4qiHF8BzGV1eW6DNIqTDKdiDxnG2Lq249AhDTCDkUnQWy/RXfNWbjPJ7zWTiPR+rYTSS9NLrzMugBCDh2XjTB/Bq/Y0e63aN2eo27AeLJiS4Hdfq0f9VmkANaVpQh/rlMXDsamt68nObIfgDLaMgZaYW2IYWM0oOa7GfPrB6WRt4HwTTSrLRidcDL1q/CbRMqa4Vp5LCVE3s3e1MvRIdj2NdkRoOLjcwuvSO8IGevUyxFNG460xM13SDQAvZW7snAhukUKFVTLR13utIJYhDFTr0V2CPCnHvtTDcyFah44wRmSBUGOPlF5d68mahpznTXxRCGpR7bAhbirXebSerNwdhLVvqeurl8D+ZjZytx0igOKkpUJ2SMwHnCpTY2Pow4sC1Tu5LQsHpVprLvNMgFfPzAP/wXPm2uRdm9+BHFcqsdCAixXmkGyDuQ7M/mtL6Y1/sF0P9167gJgZIhMZPULDpFFoR8oGQmge+l00j8USu2yb5JqWfDptmP8TqgNgSGwuXdaeZ9WM6WJCZID/j2GxSDJ4Rt4JetdQjxl3iuVt0wxhq7MkFEzNRK2C8XpB7uAOiyqY6Y2EMpMfoHzCmr6FwwbvkF9+hm8WkIOLWpCWR4ojiGgxbiiZS/NiGgfA0cfs44ZkC7w5zXe6uWIfqSSL4sALmBZQxyTr23A7KBEDpqx4xxXtk6A5NxTN/Bz1oO0yO2xI8ERadXQbNErwOpBWTCKozwr/9hjxIGXmfM+XfBKx7gzuLsSmaJiyvS0SzKTA7YvgaWTvxh2vid+OhaPCPj35vvBau6ycxfms0vKdyvyZobTuY7G/DxaQBGnmrAkC1q795paBP0pMkl9vHOfBWJ1OAtE4CyjXMn9orIexal5xG6eb9qOBuWSCv3aM2y4bAP2JygtXmzNvEWxFKbTmcdkNhUQUS/ZueMS/JhS/09Qn6kkn3NHMQtUs50xIKqa
 /pkeAol3
 Cl/KnFhRRKcjup6lPK3+31RbIRRDr8J6F1lp6qEO8atmZqhtgCHAaMcYHFvHY26/rJVjnAWVorP58zJDa7sxPuV5j4elG/Cb7W2pQ+FRWR5Cm6Lr9PQLH2Bd2+CYHbCMruHLfjgXu7yOu5SlvMqz0+/3ufVz8KFOZVZKkNNmnZ2I0hbELcFH5Ls7eJ5X6NOhhQ6iMLmZx41SYJBwEywAjmB1bZCriIv0ARwR/TZFLoiq6I/WoEvTUDqlkXVHekheIhrq3Dxyp2Tzbl7jnOP8GAop0gLlzBIHumLKHhakw8XW8vytmReu0imNOEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/fat.h         |  2 ++
 fs/fat/file.c        |  1 +
 fs/fat/inode.c       | 12 ++++++++++++
 fs/fat/namei_msdos.c |  1 +
 fs/fat/namei_vfat.c  |  1 +
 5 files changed, 17 insertions(+)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 0d269dba897b..2b2f6ad32f24 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -130,6 +130,7 @@ struct msdos_inode_info {
 	struct hlist_node i_dir_hash;	/* hash by i_logstart */
 	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
 	struct timespec64 i_crtime;	/* File creation (birth) time */
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
@@ -424,6 +425,7 @@ extern int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de);
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 			    struct inode *i2);
+struct mapping_metadata_bhs *fat_get_metadata_bhs(struct inode *inode);
 
 extern const struct fs_parameter_spec fat_param_spec[];
 int fat_init_fs_context(struct fs_context *fc, bool is_vfat);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 124d9c5431c8..da21636d3874 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -574,4 +574,5 @@ const struct inode_operations fat_file_inode_operations = {
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 	.update_time	= fat_update_time,
+	.get_metadata_bhs = fat_get_metadata_bhs,
 };
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ce88602b0d57..8561b8be5ca2 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -763,6 +763,7 @@ static struct inode *fat_alloc_inode(struct super_block *sb)
 	ei->i_pos = 0;
 	ei->i_crtime.tv_sec = 0;
 	ei->i_crtime.tv_nsec = 0;
+	mmb_init(&ei->i_metadata_bhs);
 
 	return &ei->vfs_inode;
 }
@@ -807,6 +808,12 @@ static void __exit fat_destroy_inodecache(void)
 	kmem_cache_destroy(fat_inode_cachep);
 }
 
+struct mapping_metadata_bhs *fat_get_metadata_bhs(struct inode *inode)
+{
+	return &MSDOS_I(inode)->i_metadata_bhs;
+}
+EXPORT_SYMBOL_GPL(fat_get_metadata_bhs);
+
 int fat_reconfigure(struct fs_context *fc)
 {
 	bool new_rdonly;
@@ -1531,6 +1538,10 @@ static int fat_read_static_bpb(struct super_block *sb,
 	return error;
 }
 
+static const struct inode_operations fat_table_inode_operations = {
+	.get_metadata_bhs = fat_get_metadata_bhs,
+};
+
 /*
  * Read the super block of an MS-DOS FS.
  */
@@ -1806,6 +1817,7 @@ int fat_fill_super(struct super_block *sb, struct fs_context *fc,
 	fat_inode = new_inode(sb);
 	if (!fat_inode)
 		goto out_fail;
+	fat_inode->i_op = &fat_table_inode_operations;
 	sbi->fat_inode = fat_inode;
 
 	fsinfo_inode = new_inode(sb);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 048c103b506a..1526b8910d51 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -643,6 +643,7 @@ static const struct inode_operations msdos_dir_inode_operations = {
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 	.update_time	= fat_update_time,
+	.get_metadata_bhs = fat_get_metadata_bhs,
 };
 
 static void setup(struct super_block *sb)
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 87dcdd86272b..ca5e0e9822a6 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1186,6 +1186,7 @@ static const struct inode_operations vfat_dir_inode_operations = {
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 	.update_time	= fat_update_time,
+	.get_metadata_bhs = fat_get_metadata_bhs,
 };
 
 static void setup(struct super_block *sb)
-- 
2.51.0



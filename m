Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B97EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B906B0111; Tue,  3 Mar 2026 05:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7166B0115; Tue,  3 Mar 2026 05:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1246B0113; Tue,  3 Mar 2026 05:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22F456B0114
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0C481B7D63
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:33 +0000 (UTC)
X-FDA: 84504395346.24.D579A93
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9419014000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jtt/X+Ov";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EMkHO91R;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jtt/X+Ov";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EMkHO91R;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=X9Ll3LZEm8/bcOOC4rwFO9dbzkFd5LraGFBbHYyyMfAfWtv9zQEt24hh2ALV37sjML7EwC
	1cZfNp/R1fONDnOD2zTdWWXPEOQ7D5OYv8ZvVp2BPf3F2ria71hjpFpElHgZFZLQmk/7/b
	bDKITRWBeuyGX0dVoG0BNDv5wVsvc5M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534131; a=rsa-sha256;
	cv=none;
	b=mSzLy4NeuJEocSVMtKbY8JOlevu4LTY/kBFOc8H90rHgxNPuxnD65UuXQHjQVx/FMBDJc1
	J6xKnJUg3TYIEzlMgBnE37nNsjFN6t6PIwkXXV606XctjdCmKmXwA1+mFT51KbCzcJb4dq
	WgeBWMPKLxJqeeaHbw2yuTWIUkvCOGM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jtt/X+Ov";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EMkHO91R;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jtt/X+Ov";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EMkHO91R;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 224ED3F91D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=jtt/X+OvIvVdUwKgh4xL9YMut+xDZKuIZtEun+84g+PdWambqB5wsvhS1yuwy140SEbKwd
	pmYPWXo9PVcYcMrjf1ri+Ic5X81lFQ8aW7H+7LVEbGKOzajngf06OtUCtiotuNpYBmWt6f
	ujK78jaX6vPeqcHdOzbprEs3H/oPSuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=EMkHO91R02qtxca70SAyvWqsQfbUkL+kwwvnUNtngPhUR/ktaM1jB/eEvdk/hzG8cEdSIO
	lEtUGv0YJBhjfmCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=jtt/X+OvIvVdUwKgh4xL9YMut+xDZKuIZtEun+84g+PdWambqB5wsvhS1yuwy140SEbKwd
	pmYPWXo9PVcYcMrjf1ri+Ic5X81lFQ8aW7H+7LVEbGKOzajngf06OtUCtiotuNpYBmWt6f
	ujK78jaX6vPeqcHdOzbprEs3H/oPSuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=EMkHO91R02qtxca70SAyvWqsQfbUkL+kwwvnUNtngPhUR/ktaM1jB/eEvdk/hzG8cEdSIO
	lEtUGv0YJBhjfmCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0840B3EA6D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id psQCAkW5pml3FQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B18C3A0A1B; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 13/32] aio: Stop using i_private_data and i_private_lock
Date: Tue,  3 Mar 2026 11:34:02 +0100
Message-ID: <20260303103406.4355-45-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4888; i=jack@suse.cz; h=from:subject; bh=mdP2kASBf0yhnD0I35SUu4LGJDwskVC25FLk12a/mT4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkpGGJT8GdQ+e+wtuFtTkXrw0gaAb7TMpeEt l5v77h9SHyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5KQAKCRCcnaoHP2RA 2aTrB/9cnXJIMvdimpOkyXF/Xu8esspG7p2Aqqbjb7vY+uDFQBpeazoobimlSn4T58sY/qKLVtR KguGgxbpJ+jBL8kZySyIV6xuoQBfW2uAtQMJOpwZUEy93PUsqIza42+evISAIYTwPrFmyNI21PA 5ORjSmMd47aR/Mkt1hvr6uD+NRbQuACWHGNeAbFnzcJfBY6aUVt/wlk7ILAkqlKH2JPNdGEVj6t 6ZrJ5EoMme75AROWoVpjwy9Z81RPwKeErABqEO4bGBzlswivLN8Zmo2flBeHAiOSMNwqngRWD0g N0ZKu/GYb5smtDSyZB486GaUWKLR5XX/GJ4+jXodaTd/C2R+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9419014000B
X-Stat-Signature: aer33s86kqrxh6dmatx1kdacxs5ixhnx
X-Rspam-User: 
X-HE-Tag: 1772534131-744556
X-HE-Meta: U2FsdGVkX18Uqn5wkhIQhmU7wEIXISZ0BR7T/ZweRPB6kN//MUKCYKOA2RLzPT0cu8+8Nwzpfdup3Shzt4ViKx900mzdy98knuR4YZA8zgZ+ObYn2xC4EGM47hYPIPNArQ81xts+ygp4jgRik08S7efwZbfSXb7Fbodr0x1Wksrk+l84brc8WWj23l8vRBr9invb7CgaK/4353vwYnW56tH7SSd6Y63U+IBuIFhF/M/hAyexMYkZfTmwF9HjdaRREc4veIgpDsSSQMY6HkLkkZ1V85OsVMQf0aUf7bZ9E43Evh3snh9kIGkvPaDgCW//FnskUS3bfYNSih33ZkEohG+ORDZs7VZb5RisSlLcJuIxmeoRIKo2yu6wzbTMj5PjaDP8T2X25MVM2N9L4N69Cl8gvKnHUg6JZUnI0w26UuvlQR8SaNJtAjNoUCfvbtJgeAadu07xE35pScoj2KJ6nAMlQ4UWYCZl3SV/55bjAgJs/46zmBuE+i+sL6WFSZ9YpglmjCQq+PFoBFyFA3IqvksoMMzkNcn0j/yc5jfD0cpSPl0vZGboX3jQDkIJ2x1GnRetgtnNVgjSIoVt10Z8SivhZt+Dp44Vf8bylJDwi9Q1qjNSepK8qzCihiu4LbjoF1SyPOsNG4jj7Ednzi8crBri1rQWN7W3EF6UIEMptWIEW9C3VEsNjGfzdg9lsEMtXQpVc1IjPAAOEiM+Samp9Xf8d/3ijge04/Jt+4HtA+csk7NpfHCiUxOcCSkwsVdFFCZKXOSBAqY96aJMTXor9sg16RwU88qNCN/HjUI+3waaY7wycWK9NTVUt/tLv15iDvzYO+z6iCb16xKei+DzyGc7bVtS8+/KlrzUWVHF477JDwmLQeQ5k7o14v4X7ItjQTxD44UwWCIrGtA76BNt3yF7m8u07UnZufNI9B1ESluVkZ805VLkvP8TftV0Fjrpj9uMu6WhpRFOlfxetC8
 WiNDrRk1
 nPxbzV9WMRlhGeFxI95bXPPYhF0Cht9+wRqQSgPN08RcQOyepULTCkcaLW7yDQhPu/PgYXNnQt/r3IPP+/ucqgXViqSlQ/zc+7jJo3KUCDDj87ojpB/zMJcFNXXhHbKhZMAsWt+/p763CTVjiBr9bR2PLC8rermK2XJaQtfLOBnPww7pTXTTiHwA2DLn8ODNHRJHGJT50igXDaFTi/p1O/3WOpS9bQl82QFv3Gi6xR4mVpgRYU05rHFmuZ0fdTFVIwerOqEHX+SZjETvfITAXFpacOEzqtx3OJ3wBZafAt9VQkmDvmAqqp+XlX0ANtP4uHxHdg6E6ztYaUj0dievkIWZUePJQwWRnDXwjqpYNuvEUexI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using i_private_data and i_private_lock, just create aio
inodes with appropriate necessary fields.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/aio.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 12 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index a07bdd1aaaa6..ba9b9fa2446b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -218,6 +218,17 @@ struct aio_kiocb {
 	struct eventfd_ctx	*ki_eventfd;
 };
 
+struct aio_inode_info {
+	struct inode vfs_inode;
+	spinlock_t migrate_lock;
+	struct kioctx *ctx;
+};
+
+static inline struct aio_inode_info *AIO_I(struct inode *inode)
+{
+	return container_of(inode, struct aio_inode_info, vfs_inode);
+}
+
 /*------ sysctl variables----*/
 static DEFINE_SPINLOCK(aio_nr_lock);
 static unsigned long aio_nr;		/* current system wide number of aio requests */
@@ -251,6 +262,7 @@ static void __init aio_sysctl_init(void)
 
 static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
+static struct kmem_cache	*aio_inode_cachep;
 
 static struct vfsmount *aio_mnt;
 
@@ -261,11 +273,12 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 {
 	struct file *file;
 	struct inode *inode = alloc_anon_inode(aio_mnt->mnt_sb);
+
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
 	inode->i_mapping->a_ops = &aio_ctx_aops;
-	inode->i_mapping->i_private_data = ctx;
+	AIO_I(inode)->ctx = ctx;
 	inode->i_size = PAGE_SIZE * nr_pages;
 
 	file = alloc_file_pseudo(inode, aio_mnt, "[aio]",
@@ -275,14 +288,49 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 	return file;
 }
 
+static struct inode *aio_alloc_inode(struct super_block *sb)
+{
+	struct aio_inode_info *ai;
+
+	ai = alloc_inode_sb(sb, aio_inode_cachep, GFP_KERNEL);
+	if (!ai)
+		return NULL;
+	ai->ctx = NULL;
+
+	return &ai->vfs_inode;
+}
+
+static void aio_free_inode(struct inode *inode)
+{
+	kmem_cache_free(aio_inode_cachep, AIO_I(inode));
+}
+
+static const struct super_operations aio_super_operations = {
+	.alloc_inode	= aio_alloc_inode,
+	.free_inode	= aio_free_inode,
+	.statfs		= simple_statfs,
+};
+
 static int aio_init_fs_context(struct fs_context *fc)
 {
-	if (!init_pseudo(fc, AIO_RING_MAGIC))
+	struct pseudo_fs_context *pfc;
+
+	pfc = init_pseudo(fc, AIO_RING_MAGIC);
+	if (!pfc)
 		return -ENOMEM;
 	fc->s_iflags |= SB_I_NOEXEC;
+	pfc->ops = &aio_super_operations;
 	return 0;
 }
 
+static void init_once(void *obj)
+{
+	struct aio_inode_info *ai = obj;
+
+	inode_init_once(&ai->vfs_inode);
+	spin_lock_init(&ai->migrate_lock);
+}
+
 /* aio_setup
  *	Creates the slab caches used by the aio routines, panic on
  *	failure as this is done early during the boot sequence.
@@ -294,6 +342,11 @@ static int __init aio_setup(void)
 		.init_fs_context = aio_init_fs_context,
 		.kill_sb	= kill_anon_super,
 	};
+
+	aio_inode_cachep = kmem_cache_create("aio_inode_cache",
+				sizeof(struct aio_inode_info), 0,
+				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_ACCOUNT),
+				init_once);
 	aio_mnt = kern_mount(&aio_fs);
 	if (IS_ERR(aio_mnt))
 		panic("Failed to create aio fs mount.");
@@ -308,17 +361,17 @@ __initcall(aio_setup);
 static void put_aio_ring_file(struct kioctx *ctx)
 {
 	struct file *aio_ring_file = ctx->aio_ring_file;
-	struct address_space *i_mapping;
 
 	if (aio_ring_file) {
-		truncate_setsize(file_inode(aio_ring_file), 0);
+		struct inode *inode = file_inode(aio_ring_file);
+
+		truncate_setsize(inode, 0);
 
 		/* Prevent further access to the kioctx from migratepages */
-		i_mapping = aio_ring_file->f_mapping;
-		spin_lock(&i_mapping->i_private_lock);
-		i_mapping->i_private_data = NULL;
+		spin_lock(&AIO_I(inode)->migrate_lock);
+		AIO_I(inode)->ctx = NULL;
 		ctx->aio_ring_file = NULL;
-		spin_unlock(&i_mapping->i_private_lock);
+		spin_unlock(&AIO_I(inode)->migrate_lock);
 
 		fput(aio_ring_file);
 	}
@@ -408,13 +461,14 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
 			struct folio *src, enum migrate_mode mode)
 {
 	struct kioctx *ctx;
+	struct aio_inode_info *ai = AIO_I(mapping->host);
 	unsigned long flags;
 	pgoff_t idx;
 	int rc = 0;
 
-	/* mapping->i_private_lock here protects against the kioctx teardown.  */
-	spin_lock(&mapping->i_private_lock);
-	ctx = mapping->i_private_data;
+	/* ai->migrate_lock here protects against the kioctx teardown.  */
+	spin_lock(&ai->migrate_lock);
+	ctx = ai->ctx;
 	if (!ctx) {
 		rc = -EINVAL;
 		goto out;
@@ -467,7 +521,7 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
 out_unlock:
 	mutex_unlock(&ctx->ring_lock);
 out:
-	spin_unlock(&mapping->i_private_lock);
+	spin_unlock(&ai->migrate_lock);
 	return rc;
 }
 #else
-- 
2.51.0



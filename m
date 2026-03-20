Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D161098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FFB36B00E4; Fri, 20 Mar 2026 09:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761A66B00E6; Fri, 20 Mar 2026 09:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB286B00E7; Fri, 20 Mar 2026 09:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45EA56B00E4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B00B140235
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:18 +0000 (UTC)
X-FDA: 84566558076.28.D62A539
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id AE98A40015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NnPjWetv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V1AUCraM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NnPjWetv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V1AUCraM;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=Xhu5CQdjPArnBHQHmPNhQxSn4bejrXG0EUSd3j6pU6zy0cczCePSjZ7c40ha+wUCR/tk0e
	jrLIN37NR2Aq2ffDVz3uYu2lnaF6OtZtt+Q5YTADOIQer0NNiinVMcBgl68jlU2OiCxmmD
	Ch/USYFaDWhg19LNeXnNnbOBEAW8OpM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NnPjWetv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V1AUCraM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NnPjWetv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V1AUCraM;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014196; a=rsa-sha256;
	cv=none;
	b=eMuCItGlJOudHQrhqfeEOURELtsleXLIl8Y/0MEiK2uYEZGxaEizz0aWDJruhLGGDc8HIO
	nhCenr75R/A37LiUYwFRm7wsW5ch1heJegZF3MDXdNEigY2YlvJR1mJOVjdBV/aUaxrE6u
	tE77UXOqL8O50xW0riuh5fgA3Gax/yg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 784D64D29D;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=NnPjWetvBmZtfTD3MTjGEYO7Q6u6qJgLQCH71ENSuqeMpffO19rjGmfA12TXdx8ewuvLBZ
	+VrcgZQDM8Aii7zC6EiyPWtSlZP8njw936/cZpnDWR0Pp8sX9SjyNW9jSCqVqURJkSxYdu
	tcSEnI2xNV86aIC2X6k36ClNBCIgLvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=V1AUCraMDhgLYYKySi22zLtem+w2pkUEPBh53U/gku9ZoZ9le/oHUzk9zsDOFJ9bzuBNKf
	FB4iMiX//hk8t2Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=NnPjWetvBmZtfTD3MTjGEYO7Q6u6qJgLQCH71ENSuqeMpffO19rjGmfA12TXdx8ewuvLBZ
	+VrcgZQDM8Aii7zC6EiyPWtSlZP8njw936/cZpnDWR0Pp8sX9SjyNW9jSCqVqURJkSxYdu
	tcSEnI2xNV86aIC2X6k36ClNBCIgLvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/R3AGN6dIap1MXQgjeMm6isvpHyScocBtEis1Qb+TE=;
	b=V1AUCraMDhgLYYKySi22zLtem+w2pkUEPBh53U/gku9ZoZ9le/oHUzk9zsDOFJ9bzuBNKf
	FB4iMiX//hk8t2Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 610824281D;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /v6uF5lOvWl6CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1B5CBA0B4E; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
	Jan Kara <jack@suse.cz>
Subject: [PATCH 23/41] aio: Stop using i_private_data and i_private_lock
Date: Fri, 20 Mar 2026 14:41:18 +0100
Message-ID: <20260320134100.20731-64-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4888; i=jack@suse.cz; h=from:subject; bh=mdP2kASBf0yhnD0I35SUu4LGJDwskVC25FLk12a/mT4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6AGGJT8GdQ+e+wtuFtTkXrw0gaAb7TMpeEt l5v77h9SHyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OgAAKCRCcnaoHP2RA 2b+PCACTnCG17oEenDQltzLldovJYV5viY+YhbnvX5R6+yyoQQ6SOBjIDorPklUNd2IET23qpLz Xx6dR8A++9iS5FuLNl5bb5uSpPbUNwR2vVlmgrpBI8v9r6Ydycp4WeYrn3qKlbgYIl/16X4uJUc w3kAub00KlyyTK6KcdiMcqO2/yk/8EfiKrK2LzD5m0q1t5PA4ncJU2KUrEXh9c75/+fhPdH+ZAQ AWG9YzLd+Od6tNs5qMw2w3wGIWJIf4+hePdrGJus2I0U3XeiXz8l8+OvOytctWZhd9HtvkpTuA3 g+EGzwn0dniI74zAM6AnGbsmTSpP4h/4ZdYD4/8HI15idmbF
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE98A40015
X-Stat-Signature: zb1otpxg96fieqfakzstpgwqxt7qen6b
X-Rspam-User: 
X-HE-Tag: 1774014195-141547
X-HE-Meta: U2FsdGVkX1/cKui0JaNgvFHgShzYFyxnf0Gbzq+bEn/GYC92VjI+hWb0Ncv0wDM0LaHyqjDCVPsqa/NaNCJ8m0nD5+97Dozisce2EaL1tXb/QNtVX7JR0KEFcwnkqDTDLRrZjGPSPQVcBXDl+XqbdCOM9hvq4PCIM++8853s21uJRPBahCdTEdZsSVjxJgo98TzaJ/GXE4UsdFPdJpSPwB/jD39xtF60iC4vjQAAYhQdwdkLNJcDNjX+pvt1j9QgF8oxxe3PTSSniTfnXIoIxPrKar5VGQkfM76WL5cAxpmSN5KCqP26LbB+EqzejwbqtXi8M4595zJ9089+sPXk7E4vlfHvbqA3gtkTLxVCJmoKSj+sBwKEomYr5ijWBOAIT0rk2dKDBKED6RksNs4IXtjgo7dgqnxku9XD1vIb4sPP92Ksx79ADovy9xn6JGVfrGI/VNP0k4MsPfLE7Cdo3xz20XT7NzNd9qC6+7xY1NszeZATzl0PD1T5X1woLkdK02FBQFHhbUJCV6yLEwyInankb9HmV9/mwTFo4DooDOdWhW8/GqUXcYXByYmGaNX27FcWC+mhc1mJqtVxuZwDepv+En4Gd1AwOyuYqoFMwjNlt433W8c7YxGndZCfTfAtzQB035ulrVzHAlrgZvCjW4Gc2Ingpcifp+I2PPmU5aVlV8SZ/gD4k1jMI7r3KwVCL7+Mm/zuGag2ABv3kGOK1XSWkbGge58csPIC+3zq3lDvs4rAJxzdcocPgYwcyz4SFY1FAjgUQ+YhhkRPZHY5dUJ48ZM95s6goDwsX2IxSvJ2szGlrFkWL6lvHoQIrxCeyuBMdMlL2T0Uykx7l5/f5elDYyRs1P3jIPfF9iIAf6Nu9ujJooO/3/2HpZAGjXpOvGUHG+zEmWzim1f+DoiJ0hby6DXVxm95bZF00080wHHkjzBBY3vYOMqXeZ9z8ZMIraqrVYo+jpSe2KQTbig
 BfHOhntn
 aacU7/i8+v3jBUXxiRbiQSCnMxpXX0byqRybTy4sV+LB/qx4gBnNfXB8vVg5RPPusPFOQh4nX4Ghn3DQ8dw5cZnfTiF8r+kK6US02QzVamJ3kpsc9CjaPhCYTIeIUEQ3T3VTBosTWG3JLQ6j6CHbVayLkPtcfu9F+8WKkcRw+pzgwu5JNNkB30JsUTzzF6cKvn4T9qkttm5EdQEp8bBsxOBqZEaEPs1XGlkt13cTH5cxRnl5IYZO6mJhJWe8icl4Ne44Ir7+ltN5LmzWYwtMof+sjcVAmSvWXVIrN4Lqte53erAiiAstNJTz39uJs0JbWQfa1r4CcYEXA7ZRbPjOnbeRmAWnOBwV8TqZBJcHZE+x9jro=
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



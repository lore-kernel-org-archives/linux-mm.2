Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45BB106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67BBA6B00DC; Thu, 26 Mar 2026 05:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654AD6B00DE; Thu, 26 Mar 2026 05:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5EF6B00DD; Thu, 26 Mar 2026 05:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4416B00DC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BE0C8CE76
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:21 +0000 (UTC)
X-FDA: 84587758962.05.76B53D8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C784180003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lzzUdzV2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EOzE3ciK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lzzUdzV2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EOzE3ciK;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518978; a=rsa-sha256;
	cv=none;
	b=2tbrIkk8CIZqToqrkzkPco8wDzQpe61rUR3zIeXVUjtmCZrrppArS7hU6nJ8UEtORXfa9v
	ImuNksTYN3geFlnCqqY36cit924Vfw9nWEzvK2tpSWJH8dl3NIaQaC1w1+gi1QN3kGtsAK
	Du1untZkrBeiN7aCuyxQR1lsufpO6jU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=nr9vX1Jg7lCyWMkBkeKeJAg4IBwC6X00RrbBzSmrkHY+2PB55svn6VFZ3NNR5opU9ap+rb
	JZQJ7TD/cR4HnqDcZVYz7OJtM0nIU1oRD9rcT4taPjFdVTc/AH4VcoqE6oGw4SnT5MSZIR
	2Ze/pzTQTaOpszZVQ+WSVR31sA4xwjA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lzzUdzV2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EOzE3ciK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lzzUdzV2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EOzE3ciK;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 734C15BDB2;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=lzzUdzV2vdw2G2ghZ3B7l+mibIyjeFDNh5AsYT0cktGv0jpIy6vBaVi5/LQZqy3O9at1oT
	qjl/55Blgpz4alFlLiAA5ZD52rXg3HcQQ4hjS7BwPVFSR2EaQ2UAPySHnCkp4d0KgVwkun
	V074UuMFTZUqnniaTVPZlQQkgmN4Al4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=EOzE3ciKzBBY4WRr+N5saYe2MAEvWXgadAbymraGD22syxh0/EIw0TmojrYNzjR2e0n+Qi
	QiCgtYUt1HM4WgDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=lzzUdzV2vdw2G2ghZ3B7l+mibIyjeFDNh5AsYT0cktGv0jpIy6vBaVi5/LQZqy3O9at1oT
	qjl/55Blgpz4alFlLiAA5ZD52rXg3HcQQ4hjS7BwPVFSR2EaQ2UAPySHnCkp4d0KgVwkun
	V074UuMFTZUqnniaTVPZlQQkgmN4Al4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TcoNuf/pjFj6YELW+wxD5QZ4FewIuZ5olErcEsXig/4=;
	b=EOzE3ciKzBBY4WRr+N5saYe2MAEvWXgadAbymraGD22syxh0/EIw0TmojrYNzjR2e0n+Qi
	QiCgtYUt1HM4WgDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B7664A0AB;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vdNUFnUCxWnfYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5524AA0C6F; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 25/42] aio: Stop using i_private_data and i_private_lock
Date: Thu, 26 Mar 2026 10:54:19 +0100
Message-ID: <20260326095354.16340-67-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4933; i=jack@suse.cz; h=from:subject; bh=uVsvQms5MSP6UW8c94a/Bcx7tH8LCDpqwFuYUMFVOS0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJHfYlHyc9pyzhKqNzmG959AJLLRBSkxfd4J Ho8ddDoFKmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRwAKCRCcnaoHP2RA 2e8LCADcX1JyhPYjfxFhFW3duvVAeolbUfDR/BpFBNlNo5wZwydfZeev+OUkldm98o5mdtThpsL v0jrRtf8BmUmm0MxMdnBUPIVz9boOFYRhsUI3I9h1V3E0T2ZODwmJnJDbnWuhiHHJLkfBzuFnaV RM1nmxsYeCqhY2NuIEDD7GRDZGbp2sFH0pg/HtcYtnZX5F1XDsVvQFlVM374jifOKCbXiq2TBNZ EBxAtmpfnPCWGnEEU5aOUI45y2rjH504PTJsYKT3vMTyiH8OLckfHoC8tJJozjKipdkjahiroy6 AYavddh5lPgcPMd0KN/CFO0xMAbxdrjdUl5KEG4Iyf6gTp7A
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C784180003
X-Stat-Signature: 8ka9y94hjcpariqjmsfbbh49cofmq6cc
X-HE-Tag: 1774518978-242172
X-HE-Meta: U2FsdGVkX1+UwOAYEUjrtX7yG8NUGn61CCS2EOXsh6vRwBsX6el/OEd7kQZIl6dvvNsZSu6niR3QDtmTFKF9hVb2OCyf1Gb/EOS8g1nvTkuh5U+4h7S3gWj1YcoxTmn+veZ/VdD+uGB3fY4iuVli+EW9iH9r7HgSi8voGsfiIAm8mOxq719M1J0Ko5rMNm07fLmVo0qbewGZfGotVIYz/jrP8ADOa1W1dbudXdyvfRNy/UQ+UtUh9kAWwBE/Qdcye5ENELnLErEZzAWWJ7HbnWz5akHToFv9yT+5r52Akt8tXRgGN1shLoYJl2+fTUQarGO4uECF2TkqQa5lH9JvwDn7RpUUpzp0HAn3+6KWRn+NDAIKR0eerwNdTcJZGVadxscn4kNIh0O5BS0LRHO7cngsu9+Sz78qw5/Nv0QHSnPUjLPNKulKrxghpn8KsL5rsPtn9P6wGH3Gp0SfVNZsVBLRpOyvqGxFAu2m+r4OW7GSVkYf0dXEcjeAC5QsZzs5vkIR/yTeRyHBL21zOLkOgAJwokD7QvHqNSOYTKptUI2j0WuNgFRwOl74akF90ZYUb8I9cZyu1HdPQM0FNIERa+YxmgF9A4HpHvMKkUV5QoxlvXVEuFTjwoicxbPF0n0vHrNzkF5FSunAN3lNqd6mxKa5Wyyh535GU7rPR2tgakB747yGSX5t8ri2t7b+/iFRYSEA5GLG6gfiGJtSY525WH8LGxqNdWrLv/tptSxLfEHtNjGJ9yMk1JElYuA1om/zmsaU+s9TwfVZpY/gbXxGCeSbMncQX2Je/CHc84LGX9+kr/e5n78JoF1S8PM0HWMyNhdPS+HxxeGkNj40e8Ig+N9m6u6ez4+idtzSMqDGxoVOE302AI4konDS414F+Yll11/6FgK9ynqZBwcHmdIg71U10KlPYKfXJRO1L6G6ChaM4HmQ2t1poj5HAQ3w5kZ7oubweApWg2ZxzqnmqD4
 feHk3W6q
 6EFMjXiBfc4i/UWc2isa6s2n2hlHgUaVWWqJ8O1Y1lDan5EDBSuTZZbUWUMYZeuXvTjh2m0rYnXLt52RZg/O04BrHBD1PIIbGLK3IDvX7N+Pya8rvg6DNFhZ7OFz5ElEhnhRYYnZSwFrXn/npxicq4GbuAQKgcf8kRQ6Gejqhf/MD5NNCUM4dCizA6ebeejptLELqt8Lxdigau/AKYUAillvUQOrMtOXFy2VcCtWrKSrqfhV2Wf9Kh3/vRFEWN+liqlsd3v2w/BLevvuLm7QwkPqQfXhofkX5PSPu2h77dFM/zKa30ypwZDuEAA6SJYp30Y7D/xv7ABNxsrs2hAlnjY37/Qp5Dvz3z0zMqIqYy74/4Js=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using i_private_data and i_private_lock, just create aio
inodes with appropriate necessary fields.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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



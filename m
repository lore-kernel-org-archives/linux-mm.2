Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5623BE7BDB4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1D266B008A; Mon, 16 Feb 2026 08:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB526B008C; Mon, 16 Feb 2026 08:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A283D6B0092; Mon, 16 Feb 2026 08:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC3F6B008A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D9E4140B7B
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:32 +0000 (UTC)
X-FDA: 84450409344.18.349C56D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 48AC54000E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gPG/x2PO";
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rt5UmJmHsIAoh4Thbk4mPtSWQHLnmkmlPNg6InxDdqw=;
	b=dSNj0dEWwJTHl34pvJxxW8zEGeW2zupDmYoQ0RzQ2pDZlP9xatkJdLFh7fMjRFwI9ITCuw
	pQLgMqTPuEZ58Nkb2wGjgDdm6ZARNVB+webf4rz4eaUSvN6Y+HPjF12ecBJwN5ajfakkMl
	y35h05hQIjD6i6Maw2IdSCic0wfBsKc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gPG/x2PO";
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248750; a=rsa-sha256;
	cv=none;
	b=YUWW7AbX284LD1VzG4GL6lqtf6CVVZZOI0vXhFGitdUgXBu/2QDUDc8Y40Rwxo4mZV8Cxi
	HX9MDL6P87/gPSmd90cfZR3pJfBvECIZEKB2LtayLjXkthY2Dk3SAYWNpUhw25aYEqgOGI
	tgoJzx0i7c8fzuj2Lr5NvO+OMMyL5pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC5DD61118;
	Mon, 16 Feb 2026 13:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EFEC2BC9E;
	Mon, 16 Feb 2026 13:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248749;
	bh=m6olJ1Aiin2fbb8rm99iZWNuSO99GG/M+f4atiTlDsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gPG/x2POnmd4b06vljpEiGw7e59h+pYTmb9s4b5qFyux5J9m4JQtKlmZKVsLLw+gg
	 Tt4nDAlCxEFQLmOaF5g+7xFDRotxNrma1plzKXtrMlfVJA4MKdWdHc9Cx2lZyWDUwc
	 4mDnwpPXF27lZ0RaX160QgrHS5ccJY8U3gh25nWDXtOS2PoAZxFR3JPWChdOon0yn2
	 dkJ6LPPEpOGd5Nywf6PmsHqNTogFPNDaIVZ2AqUufHRNru3uNtEYJeqIMvi9NAHPj9
	 mYfu9qzicHzMWQ593fE1sCWOOt5Fjk36jfvUPHQaGTWLcxblguHqOMjiJJfVN/997n
	 DTUmOtAy7mYrg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:31:59 +0100
Subject: [PATCH 03/14] shmem: adapt to rhashtable-based simple_xattrs with
 lazy allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-3-c2efa4f74cb7@kernel.org>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
In-Reply-To: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, 
 netdev@vger.kernel.org, Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=8768; i=brauner@kernel.org;
 h=from:subject:message-id; bh=m6olJ1Aiin2fbb8rm99iZWNuSO99GG/M+f4atiTlDsM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlolTFd/15cyltedzn5S1P/9iPSX13s9zVXoTd2Q3b
 L/b8e5lUEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE4g4x/JVYvCl5aWS7+zGj
 yvajU3lqnQOtH0+cbXIq2tSQ88Bm3nWMDN/k4vSdlk9uWZp1Lyfz9YYTN3bLdIbbMc/57H2wRK/
 nBiMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: qdpykekmub8r3u58droxd4qpep5pskhp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 48AC54000E
X-HE-Tag: 1771248750-416919
X-HE-Meta: U2FsdGVkX191K6AZAcbvWZtKhneLYQUQ0lmmOQaWhL+XVw4U8j9XYUQNox6+iZ0YYKlTuIyw3kEgNSKy5OvbMf9r3yV/B+r+g9nMN4LBQR8RBCYcPrY1J3vmITA3aNBImU2BIe6DKLo2YmZmbJnf0rzfPvkceij466wO/CiOrfYMvcBjFaX0Jckpieq5OcTgQ/345/n5DoWPZKkrx5pupjwuxdpb014zjoWVzlMtpXFRcx6LwFRxwOraEm0oX6dHoAxVSFXAe4AeV/qNQ28FGJk4TlX42sJYE7zsk736fLLIOywOyCwJmpki7rNpTq+VMCrDCBv4SK/qlACX7Dyz0TuGvsWpMFXhbJRG+cw1+8tUcH4afibmxqPhvI5AWphmamU08daUBGiRxe3yAz1irDY2O6ePA8F+5NOfeBuy/WwtC1kmn5wVMPNzq6iZLyrMyLaAImiozi4UDH5rMmZJja5tDQRfbpgDkTo4zaFGXYQsySOobaMRF0OCCBAx4BZSxWhXRq25vXwzPfNenekMUgCQogMaOz+jikm2ZtQLBoBsj9rntSJDRoeb4pHPkzLgI5Bsnfv2EJeOpnczsiBwVtrgyJeY0XOvK62hLihbkGiVFCOkgwfCmmq62lylN9b8r0vKY+dObhMEdVhPv4J0HTajF7rnEvF9eZQ3xoWH8AIkptYuaT2gqdu/UzrUQUaY5PrRinqyJsMgzaCw+fprmllnjCXY/DEIYodhCEY4+A+ZpZXH0A9TvrVPsXvFmls8l0aI6mMhCPMYAKAdG4XuymuFacRUY2nF3gPUOq+NJa24QZQo7VoqnMmHix/S+fhQE8rX8AE2/A5PZw9/FAKJGxm7ms8tPA3IH7m4WJZSdyAThaCb8dIYojqjqsCWwKGk6BEij+lMukZ0jr/TmTYq9fRIgPP6e66SoskXzoSbRCYWf2EMbhQjstDXFJ/qpEcCxQQE6AZ5sPs965szek1
 pcK8Gcuy
 yQUX4nuz5dxLaAsaVDuRULyZt4A+dskf3QuNQF/LAmp35z95Q5cNRRiekN+/Xt+xbhSCp4E0RJI6P759pIcDwn7gEHnG7S7C9P7sT5/a7xTOhficDHoziQ7vw22xdKXQJ8Od3MB+7uCpMbOE/FEtMZ8TRj9MkJa0+VXBviuNPZxv59oq0nV+qzMIJvK0s9i0zf2pk/0ULpRSjg5e2k0U6/kB+Vmv6mLuo1Wr0HR9TJWJsdXwGt9/gmnriwvL4bGuQ11dpZo5p3ItKaOOxcD61iFAr0sW+sot93try
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adapt tmpfs/shmem to use the rhashtable-based xattr path and switch
from an embedded struct to pointer-based lazy allocation.

Change shmem_inode_info.xattrs from embedded 'struct simple_xattrs' to
a pointer 'struct simple_xattrs *', initialized to NULL. This avoids
the rhashtable overhead for every tmpfs inode, which helps when a lot of
inodes exist.

The xattr store is allocated on first use:

- shmem_initxattrs(): Allocates via simple_xattrs_alloc() when
  security modules set initial xattrs during inode creation.

- shmem_xattr_handler_set(): Allocates on first setxattr, with a
  short-circuit for removal when no xattrs are stored yet.

All read paths (shmem_xattr_handler_get, shmem_listxattr) check for
NULL xattrs pointer and return -ENODATA or 0 respectively.

Replaced xattr entries are freed via simple_xattr_free_rcu() to allow
concurrent RCU readers to finish.

shmem_evict_inode() conditionally frees the xattr store only when
allocated.

Also change simple_xattr_add() from void to int to propagate
rhashtable insertion failures. shmem_initxattrs() is the only caller.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/xattr.c               | 26 +++++++++++++-------------
 include/linux/shmem_fs.h |  2 +-
 include/linux/xattr.h    |  4 ++--
 mm/shmem.c               | 44 +++++++++++++++++++++++++++++++-------------
 4 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 1d98ea459b7b..eb45ae0fd17f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1677,19 +1677,19 @@ static bool rbtree_simple_xattr_less(struct rb_node *new_node,
  * of matching xattrs is wanted. Should only be called during inode
  * initialization when a few distinct initial xattrs are supposed to be set.
  */
-void simple_xattr_add(struct simple_xattrs *xattrs,
-		      struct simple_xattr *new_xattr)
-{
-	if (xattrs->use_rhashtable) {
-		WARN_ON(rhashtable_insert_fast(&xattrs->ht,
-					       &new_xattr->hash_node,
-					       simple_xattr_params));
-	} else {
-		write_lock(&xattrs->lock);
-		rb_add(&new_xattr->rb_node, &xattrs->rb_root,
-		       rbtree_simple_xattr_less);
-		write_unlock(&xattrs->lock);
-	}
+int simple_xattr_add(struct simple_xattrs *xattrs,
+		     struct simple_xattr *new_xattr)
+{
+	if (xattrs->use_rhashtable)
+		return rhashtable_insert_fast(&xattrs->ht,
+					      &new_xattr->hash_node,
+					      simple_xattr_params);
+
+	write_lock(&xattrs->lock);
+	rb_add(&new_xattr->rb_node, &xattrs->rb_root,
+	       rbtree_simple_xattr_less);
+	write_unlock(&xattrs->lock);
+	return 0;
 }
 
 /**
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e2069b3179c4..53d325409a8b 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -48,7 +48,7 @@ struct shmem_inode_info {
 	};
 	struct timespec64	i_crtime;	/* file creation time */
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
-	struct simple_xattrs	xattrs;		/* list of xattrs */
+	struct simple_xattrs	*xattrs;	/* list of xattrs */
 	pgoff_t			fallocend;	/* highest fallocate endindex */
 	unsigned int		fsflags;	/* for FS_IOC_[SG]ETFLAGS */
 	atomic_t		stop_eviction;	/* hold when working on inode */
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index ee4fd40717a0..3063ecf0004d 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -142,8 +142,8 @@ struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,
 				      size_t size, int flags);
 ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 			  char *buffer, size_t size);
-void simple_xattr_add(struct simple_xattrs *xattrs,
-		      struct simple_xattr *new_xattr);
+int simple_xattr_add(struct simple_xattrs *xattrs,
+		     struct simple_xattr *new_xattr);
 int xattr_list_one(char **buffer, ssize_t *remaining_size, const char *name);
 
 DEFINE_CLASS(simple_xattr,
diff --git a/mm/shmem.c b/mm/shmem.c
index fc8020ce2e9f..8761c9b4f1c5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1426,7 +1426,10 @@ static void shmem_evict_inode(struct inode *inode)
 		}
 	}
 
-	simple_xattrs_free(&info->xattrs, sbinfo->max_inodes ? &freed : NULL);
+	if (info->xattrs) {
+		simple_xattrs_free(info->xattrs, sbinfo->max_inodes ? &freed : NULL);
+		kfree(info->xattrs);
+	}
 	shmem_free_inode(inode->i_sb, freed);
 	WARN_ON(inode->i_blocks);
 	clear_inode(inode);
@@ -3118,7 +3121,6 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 		shmem_set_inode_flags(inode, info->fsflags, NULL);
 	INIT_LIST_HEAD(&info->shrinklist);
 	INIT_LIST_HEAD(&info->swaplist);
-	simple_xattrs_init(&info->xattrs);
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
@@ -4270,10 +4272,13 @@ static int shmem_initxattrs(struct inode *inode,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	const struct xattr *xattr;
-	struct simple_xattr *new_xattr;
 	size_t ispace = 0;
 	size_t len;
 
+	CLASS(simple_xattrs, xattrs)();
+	if (IS_ERR(xattrs))
+		return PTR_ERR(xattrs);
+
 	if (sbinfo->max_inodes) {
 		for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 			ispace += simple_xattr_space(xattr->name,
@@ -4292,24 +4297,24 @@ static int shmem_initxattrs(struct inode *inode,
 	}
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		new_xattr = simple_xattr_alloc(xattr->value, xattr->value_len);
+		CLASS(simple_xattr, new_xattr)(xattr->value, xattr->value_len);
 		if (IS_ERR(new_xattr))
 			break;
 
 		len = strlen(xattr->name) + 1;
 		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
 					  GFP_KERNEL_ACCOUNT);
-		if (!new_xattr->name) {
-			kvfree(new_xattr);
+		if (!new_xattr->name)
 			break;
-		}
 
 		memcpy(new_xattr->name, XATTR_SECURITY_PREFIX,
 		       XATTR_SECURITY_PREFIX_LEN);
 		memcpy(new_xattr->name + XATTR_SECURITY_PREFIX_LEN,
 		       xattr->name, len);
 
-		simple_xattr_add(&info->xattrs, new_xattr);
+		if (simple_xattr_add(xattrs, new_xattr))
+			break;
+		retain_and_null_ptr(new_xattr);
 	}
 
 	if (xattr->name != NULL) {
@@ -4318,10 +4323,10 @@ static int shmem_initxattrs(struct inode *inode,
 			sbinfo->free_ispace += ispace;
 			raw_spin_unlock(&sbinfo->stat_lock);
 		}
-		simple_xattrs_free(&info->xattrs, NULL);
 		return -ENOMEM;
 	}
 
+	smp_store_release(&info->xattrs, no_free_ptr(xattrs));
 	return 0;
 }
 
@@ -4330,9 +4335,14 @@ static int shmem_xattr_handler_get(const struct xattr_handler *handler,
 				   const char *name, void *buffer, size_t size)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct simple_xattrs *xattrs;
+
+	xattrs = READ_ONCE(info->xattrs);
+	if (!xattrs)
+		return -ENODATA;
 
 	name = xattr_full_name(handler, name);
-	return simple_xattr_get(&info->xattrs, name, buffer, size);
+	return simple_xattr_get(xattrs, name, buffer, size);
 }
 
 static int shmem_xattr_handler_set(const struct xattr_handler *handler,
@@ -4343,10 +4353,16 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+	struct simple_xattrs *xattrs;
 	struct simple_xattr *old_xattr;
 	size_t ispace = 0;
 
 	name = xattr_full_name(handler, name);
+
+	xattrs = simple_xattrs_lazy_alloc(&info->xattrs, value, flags);
+	if (IS_ERR_OR_NULL(xattrs))
+		return PTR_ERR(xattrs);
+
 	if (value && sbinfo->max_inodes) {
 		ispace = simple_xattr_space(name, size);
 		raw_spin_lock(&sbinfo->stat_lock);
@@ -4359,13 +4375,13 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
 			return -ENOSPC;
 	}
 
-	old_xattr = simple_xattr_set(&info->xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
 	if (!IS_ERR(old_xattr)) {
 		ispace = 0;
 		if (old_xattr && sbinfo->max_inodes)
 			ispace = simple_xattr_space(old_xattr->name,
 						    old_xattr->size);
-		simple_xattr_free(old_xattr);
+		simple_xattr_free_rcu(old_xattr);
 		old_xattr = NULL;
 		inode_set_ctime_current(inode);
 		inode_inc_iversion(inode);
@@ -4406,7 +4422,9 @@ static const struct xattr_handler * const shmem_xattr_handlers[] = {
 static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
 	struct shmem_inode_info *info = SHMEM_I(d_inode(dentry));
-	return simple_xattr_list(d_inode(dentry), &info->xattrs, buffer, size);
+
+	return simple_xattr_list(d_inode(dentry), READ_ONCE(info->xattrs),
+				 buffer, size);
 }
 #endif /* CONFIG_TMPFS_XATTR */
 

-- 
2.47.3



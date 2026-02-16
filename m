Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE81E7BDAC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F82D6B008C; Mon, 16 Feb 2026 08:32:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AEEC6B0092; Mon, 16 Feb 2026 08:32:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF836B0093; Mon, 16 Feb 2026 08:32:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6CA6B008C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF2E1C39B2
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:35 +0000 (UTC)
X-FDA: 84450409470.27.FB955D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0DC878000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0hjoQA7;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJUiCiwwjAAVXI4hOxcw0VJGBoj7q3VIioud7oP3lrQ=;
	b=1G2AZPlOsUZrb5001jLMgZ9MFtolhrSFdLnXfwfZ91dsfL6Z3LGXBjChQweG96gBBR7qeI
	ya3WrbGPtfzciOcZ0cbct3H/n5LEm4eD7dKe7PPB8d8k/LoCPO0OZMmYriRpVlmOY+kqrL
	pe6LCI9KolMxC/U+Z3cybA5wnFXAYcs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0hjoQA7;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248754; a=rsa-sha256;
	cv=none;
	b=CmgsQaInztx2wkU8y1d4jUZSIIRynXIpowY/ocfLPr4gV3BImV0ZRMrFBRN9Pj6LQfZaTv
	RVj7zN/bKINVqmbsWv0e7IzLB2+63cQkuyl/1XQy5V53z+S7nh9R64WZA6XVcXn5CnHk1B
	USH0dv9bob7rd2B4DpR56Dm6Kwqcj+4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93EB7600BB;
	Mon, 16 Feb 2026 13:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F471C19424;
	Mon, 16 Feb 2026 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248753;
	bh=eNwIVI0p49LTJ3RM4G3gsM8NUnzeeg8PJjJ6WiNm1Tk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=h0hjoQA7I9EL5Q3WT1FOglHuQxa2kzLf4syPEH/qZTg8wH09A53Jgwcmti7giUaki
	 QXx1VmTmr5eBnYaL9MhvBpqjZb40AiS7nDPgg5BclHkp5y44XH5fdwIA6Ap4lQbs6c
	 f9L+bqfmVMtJDWF6CekrukBUTU32y1AngxBMBPLqsiXgBHlcNiQTnH68JQMxl9e45m
	 P8knq8EAcjIK/ZirgcGO0n6OR8dHxAcWlifBnq9N0B0HjaOEkIldzw3EoDJ13JKaOv
	 DU22jqn3TFCFem7mXmbJIBodfNdn0U7kGu7nNshvhOyRm05I14rvLFYqaO7AR+hx1N
	 vzVRcREh1hmeA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:00 +0100
Subject: [PATCH 04/14] kernfs: adapt to rhashtable-based simple_xattrs with
 lazy allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-4-c2efa4f74cb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6232; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eNwIVI0p49LTJ3RM4G3gsM8NUnzeeg8PJjJ6WiNm1Tk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlomT7ZjzLc5yvpfrvu0r/+Z/eB20Jvu+pvVEObVPl
 /l2nxQu6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIWw7Df5fidafm2ui9W37u
 9/LQxaxT1565fITzBtv7ahtDh6eb5n9jZPj2zKlncsQl+WVPD5t7Mem4ihhy3fxy8NS6V4nL+zK
 PT2UFAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 96wjyu6t53zufy7hyjsax7pxeufxaisp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0DC878000D
X-HE-Tag: 1771248753-624845
X-HE-Meta: U2FsdGVkX1+0aiyCqHBTqL6dwAcYyISGHwluKSR83OuWHp3J4XSbb5APobIaSEt8FngGld+gixmi/ihjqV8sL0pJB2eza/R7A0P6dAPFge5gAZRAwcKQAJcKYQoc9nhSt3rDhz84nQH07MmmRvUS10TlQLAYrOOqeavfRPzPrRWFmTb7kUZS4HnPAsaEhYFM1TA/gzVEFDpDVDUb+OZdYIp4UOEO4ujnxiDJNqbz5RO4VSIS4+SkLlQK09C8VF7MILLpE3AQ7FaQH2Vx10NHvp8iiR8JmcbAVVo5+o3Jvq0zhMTvfUAHQBOp1ZNR9G+zcZGAIhTTIWEJtBOUDZqosRP+rUU1fnVW59y7LC2hP34uGbB/dI952dYgc4HBYjUwEuEuWoCO69grLG47irL62CntnUWIc1R7GsfN7bzf+An84GNILBEpqwf9EVHmaPli13/It9d4AOsSdb4l6uXyQdHrkXy2WE3dF8v6UKMOxgn3DBshpTqMechdR5hEnUK1tKLT2SVEowAANx8oEzvQ4rAo66SLhUOkuEPmqQz3I+7zskoj2QovQBAZD+nPW5zqSRd/irNk1d01Ym6Ulu8tjxItak3fx6mZ4PBqbIBuXRHg5afqdTcQysJlsgZvpshNOnGI2C3NwxLsS1F9LfXRgMh4DNRZ36couoil3DhsQxKhbMB9jMuurb0bn34XTAmbRKjBnqF4L81A9l72vdFpy4JZWTyt5iQQxHCF4ok+VVwO94D05jK3wCSbyLPm8DAlby1H5sltLOO5ufxxlEJ1Ou0Lu0YbPrWKZPB/n0z2uK+uwavTMNw5E+K9ZSH5GuR9xlSl79N7OOrYqTSniP35/PdccaqfPbkfPhvTwvNPYk7cHa4OtyUhA+wzxfUZ3KAcSeCNkNEd8+eKQYhfofnxO8nbEnD2nBiYzN3Ko7gLiLIxe8uVlMNqCTEfOgUXBWe097kI38CZPDh53o/wBE4
 rSfvNy/P
 Kkz6osEmkI6yfMIGSKDoJcCm5cKSuha1k7ivbyvquD9KviN/S0Fu1aEg5fIw2T4yni3XJaU59/RjxluvQJ+Qle0IXTgfzmDNN581MQcAsmED3/i/lSobr8DDcp5mN3+ddNMuvmjqM3VbK7T3BHya4+2cXyb69ZZfiLJjUiwoe8L5Nzesjbt4bwd1iEMxgzHTyWAIWIz4HoRcUefNYvTF/C2yiYz7q8p6HVfdLJVfrFyRvzAdwU8vSj8bnCe2UzMsU1+Ha
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adapt kernfs to use the rhashtable-based xattr path and switch from an
embedded struct to pointer-based lazy allocation.

Change kernfs_iattrs.xattrs from embedded 'struct simple_xattrs' to a
pointer 'struct simple_xattrs *', initialized to NULL (zeroed by
kmem_cache_zalloc). Since kernfs_iattrs is already lazily allocated
itself, this adds a second level of lazy allocation specifically for
the xattr store.

The xattr store is allocated on first setxattr. Read paths
check for NULL and return -ENODATA or empty list.

Replaced xattr entries are freed via simple_xattr_free_rcu() to allow
concurrent RCU readers to finish.

The cleanup paths in kernfs_free_rcu() and __kernfs_new_node() error
handling conditionally free the xattr store only when allocated.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/kernfs/dir.c             | 15 +++++++++++----
 fs/kernfs/inode.c           | 34 +++++++++++++++++++++++++---------
 fs/kernfs/kernfs-internal.h |  2 +-
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 29baeeb97871..e5735c45fb99 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -547,10 +547,8 @@ static void kernfs_free_rcu(struct rcu_head *rcu)
 	/* If the whole node goes away, then name can't be used outside */
 	kfree_const(rcu_access_pointer(kn->name));
 
-	if (kn->iattr) {
-		simple_xattrs_free(&kn->iattr->xattrs, NULL);
+	if (kn->iattr)
 		kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
-	}
 
 	kmem_cache_free(kernfs_node_cache, kn);
 }
@@ -584,6 +582,12 @@ void kernfs_put(struct kernfs_node *kn)
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
 
+	if (kn->iattr && kn->iattr->xattrs) {
+		simple_xattrs_free(kn->iattr->xattrs, NULL);
+		kfree(kn->iattr->xattrs);
+		kn->iattr->xattrs = NULL;
+	}
+
 	spin_lock(&root->kernfs_idr_lock);
 	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
 	spin_unlock(&root->kernfs_idr_lock);
@@ -682,7 +686,10 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 
  err_out4:
 	if (kn->iattr) {
-		simple_xattrs_free(&kn->iattr->xattrs, NULL);
+		if (kn->iattr->xattrs) {
+			simple_xattrs_free(kn->iattr->xattrs, NULL);
+			kfree(kn->iattr->xattrs);
+		}
 		kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
 	}
  err_out3:
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index a36aaee98dce..dfc3315b5afc 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -45,7 +45,6 @@ static struct kernfs_iattrs *__kernfs_iattrs(struct kernfs_node *kn, bool alloc)
 	ret->ia_mtime = ret->ia_atime;
 	ret->ia_ctime = ret->ia_atime;
 
-	simple_xattrs_init(&ret->xattrs);
 	atomic_set(&ret->nr_user_xattrs, 0);
 	atomic_set(&ret->user_xattr_size, 0);
 
@@ -146,7 +145,8 @@ ssize_t kernfs_iop_listxattr(struct dentry *dentry, char *buf, size_t size)
 	if (!attrs)
 		return -ENOMEM;
 
-	return simple_xattr_list(d_inode(dentry), &attrs->xattrs, buf, size);
+	return simple_xattr_list(d_inode(dentry), READ_ONCE(attrs->xattrs),
+				 buf, size);
 }
 
 static inline void set_default_inode_attr(struct inode *inode, umode_t mode)
@@ -298,27 +298,38 @@ int kernfs_xattr_get(struct kernfs_node *kn, const char *name,
 		     void *value, size_t size)
 {
 	struct kernfs_iattrs *attrs = kernfs_iattrs_noalloc(kn);
+	struct simple_xattrs *xattrs;
+
 	if (!attrs)
 		return -ENODATA;
 
-	return simple_xattr_get(&attrs->xattrs, name, value, size);
+	xattrs = READ_ONCE(attrs->xattrs);
+	if (!xattrs)
+		return -ENODATA;
+
+	return simple_xattr_get(xattrs, name, value, size);
 }
 
 int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
 		     const void *value, size_t size, int flags)
 {
 	struct simple_xattr *old_xattr;
+	struct simple_xattrs *xattrs;
 	struct kernfs_iattrs *attrs;
 
 	attrs = kernfs_iattrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
-	old_xattr = simple_xattr_set(&attrs->xattrs, name, value, size, flags);
+	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
+	if (IS_ERR_OR_NULL(xattrs))
+		return PTR_ERR(xattrs);
+
+	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
 	if (IS_ERR(old_xattr))
 		return PTR_ERR(old_xattr);
 
-	simple_xattr_free(old_xattr);
+	simple_xattr_free_rcu(old_xattr);
 	return 0;
 }
 
@@ -376,7 +387,7 @@ static int kernfs_vfs_user_xattr_add(struct kernfs_node *kn,
 
 	ret = 0;
 	size = old_xattr->size;
-	simple_xattr_free(old_xattr);
+	simple_xattr_free_rcu(old_xattr);
 dec_size_out:
 	atomic_sub(size, sz);
 dec_count_out:
@@ -403,7 +414,7 @@ static int kernfs_vfs_user_xattr_rm(struct kernfs_node *kn,
 
 	atomic_sub(old_xattr->size, sz);
 	atomic_dec(nr);
-	simple_xattr_free(old_xattr);
+	simple_xattr_free_rcu(old_xattr);
 	return 0;
 }
 
@@ -415,6 +426,7 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 {
 	const char *full_name = xattr_full_name(handler, suffix);
 	struct kernfs_node *kn = inode->i_private;
+	struct simple_xattrs *xattrs;
 	struct kernfs_iattrs *attrs;
 
 	if (!(kernfs_root(kn)->flags & KERNFS_ROOT_SUPPORT_USER_XATTR))
@@ -424,11 +436,15 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 	if (!attrs)
 		return -ENOMEM;
 
+	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
+	if (IS_ERR_OR_NULL(xattrs))
+		return PTR_ERR(xattrs);
+
 	if (value)
-		return kernfs_vfs_user_xattr_add(kn, full_name, &attrs->xattrs,
+		return kernfs_vfs_user_xattr_add(kn, full_name, xattrs,
 						 value, size, flags);
 	else
-		return kernfs_vfs_user_xattr_rm(kn, full_name, &attrs->xattrs,
+		return kernfs_vfs_user_xattr_rm(kn, full_name, xattrs,
 						value, size, flags);
 
 }
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 6061b6f70d2a..1324ed8c0661 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -26,7 +26,7 @@ struct kernfs_iattrs {
 	struct timespec64	ia_mtime;
 	struct timespec64	ia_ctime;
 
-	struct simple_xattrs	xattrs;
+	struct simple_xattrs	*xattrs;
 	atomic_t		nr_user_xattrs;
 	atomic_t		user_xattr_size;
 };

-- 
2.47.3



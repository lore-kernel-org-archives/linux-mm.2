Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D42CE7BDB4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB1A6B0099; Mon, 16 Feb 2026 08:32:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2876B009B; Mon, 16 Feb 2026 08:32:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC076B009D; Mon, 16 Feb 2026 08:32:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2FF6B0099
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 558A81D126
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:54 +0000 (UTC)
X-FDA: 84450410268.20.341A6E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 820DE1C0014
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V62U8/Qj";
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rG6QeX1aY9KUOgal76WR6+d9AvQp08Y5coJDJXzYp4=;
	b=WQnPP749HlLHWbA1NL+25b4rzVNTHJxsnOlRVf9K36qTRtA5Vg3UiUmoZ9ELdLaV23L2d/
	ufVzaGU+DAL3LHuAEb1vSVXHA4Yie4Eyf7+rtZgoVEElRpwnlmKDple/qnXhwmU/TIyvHi
	pSSs8gPZFSxMluDQKZoF/W8S+H+SplI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V62U8/Qj";
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248772; a=rsa-sha256;
	cv=none;
	b=19wgPZzrjWT4KTXv8Z77NsOUao704HiJi4N71VfRdk7lwsheybB8rVY4siHuS+gi0ZLY/z
	gKfzko3ipoRa34Ync6M8WkhxPKu1vYzMQLZmAj49CihgpvfF+LXkiBev59w9XCPzK+0mf2
	2A7wb7Mo4DzSJxxhWNgUNFN1asCX6fw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B98AF409AB;
	Mon, 16 Feb 2026 13:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94854C19424;
	Mon, 16 Feb 2026 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248771;
	bh=JWJ0LlOygERvwjt59MZEWYplPXeoWPP4MOafVL9EkMk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=V62U8/QjirJ13wSb8V/oo5CuvZaDH10OxO/5NKTeBt8+ZgOx20ElbtNIMbkAYJvjn
	 rMuuc1cB7NxEEk15DoZ2yphohhqy9IDgs/3We3S/wYXe1JzFZaA/i0wmFfrhfjqSJ9
	 IBhW16W+de+jyBIraagX92JCVMklOXJtu/UPSBUjjGdHfh410Z3qjOuhMg7rPHP8In
	 bJMdhSvBBoztlVWVwKt03VIT8OwFCpyAGwcrGyhZTU4V5OqTYsHzqe2rgxdTacA4CX
	 O/Cdowq/Rlpr331x1Q70nz1KiWVKPoWKNnF+rasICFNc5CDBdBdaYglUNVcLCf2NUJ
	 mCFAt2/n2CE8w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:05 +0100
Subject: [PATCH 09/14] xattr: move user limits for xattrs to generic infra
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-9-c2efa4f74cb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8059; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JWJ0LlOygERvwjt59MZEWYplPXeoWPP4MOafVL9EkMk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlonTOp3LVHmeXSq9ZH9L4dZlfY+/PDvh8jdoxQxmQ
 VWXVbN2dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE2IaR4VdxSfXvMw+a81ma
 FLO7H8hxC0/uXFu5v3T1ntIJV7L7zRgZ9v9KE4phuq96yljdndEmj8/jm13Pl7qq3+3f9hwsq1n
 OBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Stat-Signature: 6e954cwc9f753hpyk75ddmksciziecfo
X-Rspam-User: 
X-Rspamd-Queue-Id: 820DE1C0014
X-HE-Tag: 1771248772-427337
X-HE-Meta: U2FsdGVkX1/U3SlDVo703ADV1XVEGGK3cUPIBUyNjtRJwAGJVAwQLFuSxbpZOuN+f+i2Tjoye1nh7I96XGpr312ff4fzVmdg0YVfn63Aquc07kJnkEtvYAGClrevAfip+Gi18fqPp/QKW3kuKHcxxXfmATrEyJMxzSLC+R/h7HOQ14a6/MPn/yQKsi0Xyq8JuISJvdipV64sMc+Bh5ZFEZJ/eF5sO7XhlLHywHWA94FWfzVLtFJas5ghCbhF3ywDALOK7RxVxHRC9W6ihXufCqKevm+Iczb8+0vPS6/JWvzuVQdNKLypJkVvdUG8aTdqgkoYHDo1u7L6uGjqiDbYstMIiYRMJIYMlek0pPOUUmc+TZBIwMvizbW0WULAn88PtmOnAp+YZP3gfzpWz4c/po0WOO7dRfQIWOsCJqTYzP+hccn+SwRb5FzCRL2VDivmypVDHM7TJCO9tkJmawD8LiJgkXzieh7bWIMaayZRLpOUhxgmN3Xvn8klDj6dfyUgvFnb1/CwtdEb++TRqYf/NnaC7WYwHcJzuH1mbz7E7vvHaPaJsEi3IZRzOtV3VfKQh6ZbHBJYtk29i1ugE6O5a6CnxjM6EjMoO0ArbGXeb4h4QHHY2Wc8xeMD1/QgIK9E84fKH4gi7gmnFnlITkrd3Cm5IPs26pEtGGbK1+asOFReIwJAz3DX4PAKsPoF+QqBbLJgmt47mYm9y+q5NpLKAuMyt3Sa2VL/zh4sMShpHk9eRa9mXkBLiJiAUFJ7IYIl0Lhvb87QDmjhVWFPNwiOdXouFndNsFc/vvn/hoDDEMsNVUPabD17duz2ldwCfYdgDdszZZFv5TG/097EQ7Dky2+hvnXbmCJ1flYYKnUuwWSvQISiXsoPxADPHFSPE1R+9EPc7bR3rfAQlk7oguV/BNHn9J6xy0I4l6lQdYhF2Zg9aUQvdwLSmB7H6puptWf4GrgHA2gMw2XlJAjS2x/
 DRox2ovE
 6eWkYNvsMj26oJg//oU7wB+OvxJ07/bzvAjlOS6p6/IKs6OVCLZMTGbLHAezD/pduotelwc9C/NsYcAeD4gV0YNzoY4L99Ao0ea2eKmeeXXOxSCcuv+ueXFidkf0PcycPse7TB89/GpaEKk86BJ1k9GXXzgigURBW3p7DKpDOMBkxUtH39GPm+i6khxTM5+Fw5q5cQhI3XGotjDKOVmSBLLdx4ZM6YZvP3W7XiWLnvp92P9cVyM+qma0t6da94ovJTI5Mj9wkGAZrgdzpF6gg58G2cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/kernfs/inode.c           | 75 ++-------------------------------------------
 fs/kernfs/kernfs-internal.h |  3 +-
 fs/xattr.c                  | 65 +++++++++++++++++++++++++++++++++++++++
 include/linux/kernfs.h      |  2 --
 include/linux/xattr.h       | 18 +++++++++++
 5 files changed, 87 insertions(+), 76 deletions(-)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index dfc3315b5afc..1de10500842d 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -45,8 +45,7 @@ static struct kernfs_iattrs *__kernfs_iattrs(struct kernfs_node *kn, bool alloc)
 	ret->ia_mtime = ret->ia_atime;
 	ret->ia_ctime = ret->ia_atime;
 
-	atomic_set(&ret->nr_user_xattrs, 0);
-	atomic_set(&ret->user_xattr_size, 0);
+	simple_xattr_limits_init(&ret->xattr_limits);
 
 	/* If someone raced us, recognize it. */
 	if (!try_cmpxchg(&kn->iattr, &attr, ret))
@@ -355,69 +354,6 @@ static int kernfs_vfs_xattr_set(const struct xattr_handler *handler,
 	return kernfs_xattr_set(kn, name, value, size, flags);
 }
 
-static int kernfs_vfs_user_xattr_add(struct kernfs_node *kn,
-				     const char *full_name,
-				     struct simple_xattrs *xattrs,
-				     const void *value, size_t size, int flags)
-{
-	struct kernfs_iattrs *attr = kernfs_iattrs_noalloc(kn);
-	atomic_t *sz = &attr->user_xattr_size;
-	atomic_t *nr = &attr->nr_user_xattrs;
-	struct simple_xattr *old_xattr;
-	int ret;
-
-	if (atomic_inc_return(nr) > KERNFS_MAX_USER_XATTRS) {
-		ret = -ENOSPC;
-		goto dec_count_out;
-	}
-
-	if (atomic_add_return(size, sz) > KERNFS_USER_XATTR_SIZE_LIMIT) {
-		ret = -ENOSPC;
-		goto dec_size_out;
-	}
-
-	old_xattr = simple_xattr_set(xattrs, full_name, value, size, flags);
-	if (!old_xattr)
-		return 0;
-
-	if (IS_ERR(old_xattr)) {
-		ret = PTR_ERR(old_xattr);
-		goto dec_size_out;
-	}
-
-	ret = 0;
-	size = old_xattr->size;
-	simple_xattr_free_rcu(old_xattr);
-dec_size_out:
-	atomic_sub(size, sz);
-dec_count_out:
-	atomic_dec(nr);
-	return ret;
-}
-
-static int kernfs_vfs_user_xattr_rm(struct kernfs_node *kn,
-				    const char *full_name,
-				    struct simple_xattrs *xattrs,
-				    const void *value, size_t size, int flags)
-{
-	struct kernfs_iattrs *attr = kernfs_iattrs_noalloc(kn);
-	atomic_t *sz = &attr->user_xattr_size;
-	atomic_t *nr = &attr->nr_user_xattrs;
-	struct simple_xattr *old_xattr;
-
-	old_xattr = simple_xattr_set(xattrs, full_name, value, size, flags);
-	if (!old_xattr)
-		return 0;
-
-	if (IS_ERR(old_xattr))
-		return PTR_ERR(old_xattr);
-
-	atomic_sub(old_xattr->size, sz);
-	atomic_dec(nr);
-	simple_xattr_free_rcu(old_xattr);
-	return 0;
-}
-
 static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 				     struct mnt_idmap *idmap,
 				     struct dentry *unused, struct inode *inode,
@@ -440,13 +376,8 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 	if (IS_ERR_OR_NULL(xattrs))
 		return PTR_ERR(xattrs);
 
-	if (value)
-		return kernfs_vfs_user_xattr_add(kn, full_name, xattrs,
-						 value, size, flags);
-	else
-		return kernfs_vfs_user_xattr_rm(kn, full_name, xattrs,
-						value, size, flags);
-
+	return simple_xattr_set_limited(xattrs, &attrs->xattr_limits,
+					full_name, value, size, flags);
 }
 
 static const struct xattr_handler kernfs_trusted_xattr_handler = {
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 1324ed8c0661..1d3831e3a270 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -27,8 +27,7 @@ struct kernfs_iattrs {
 	struct timespec64	ia_ctime;
 
 	struct simple_xattrs	*xattrs;
-	atomic_t		nr_user_xattrs;
-	atomic_t		user_xattr_size;
+	struct simple_xattr_limits xattr_limits;
 };
 
 struct kernfs_root {
diff --git a/fs/xattr.c b/fs/xattr.c
index 328ed7558dfc..5e559b1c651f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1427,6 +1427,71 @@ struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,
 	return old_xattr;
 }
 
+static inline void simple_xattr_limits_dec(struct simple_xattr_limits *limits,
+					   size_t size)
+{
+	atomic_sub(size, &limits->xattr_size);
+	atomic_dec(&limits->nr_xattrs);
+}
+
+static inline int simple_xattr_limits_inc(struct simple_xattr_limits *limits,
+					  size_t size)
+{
+	if (atomic_inc_return(&limits->nr_xattrs) > SIMPLE_XATTR_MAX_NR) {
+		atomic_dec(&limits->nr_xattrs);
+		return -ENOSPC;
+	}
+
+	if (atomic_add_return(size, &limits->xattr_size) <= SIMPLE_XATTR_MAX_SIZE)
+		return 0;
+
+	simple_xattr_limits_dec(limits, size);
+	return -ENOSPC;
+}
+
+/**
+ * simple_xattr_set_limited - set an xattr with per-inode user.* limits
+ * @xattrs: the header of the xattr object
+ * @limits: per-inode limit counters for user.* xattrs
+ * @name: the name of the xattr to set or remove
+ * @value: the value to store (NULL to remove)
+ * @size: the size of @value
+ * @flags: XATTR_CREATE, XATTR_REPLACE, or 0
+ *
+ * Like simple_xattr_set(), but enforces per-inode count and total value size
+ * limits for user.* xattrs. Uses speculative pre-increment of the atomic
+ * counters to avoid races without requiring external locks.
+ *
+ * Return: On success zero is returned. On failure a negative error code is
+ * returned.
+ */
+int simple_xattr_set_limited(struct simple_xattrs *xattrs,
+			     struct simple_xattr_limits *limits,
+			     const char *name, const void *value,
+			     size_t size, int flags)
+{
+	struct simple_xattr *old_xattr;
+	int ret;
+
+	if (value) {
+		ret = simple_xattr_limits_inc(limits, size);
+		if (ret)
+			return ret;
+	}
+
+	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	if (IS_ERR(old_xattr)) {
+		if (value)
+			simple_xattr_limits_dec(limits, size);
+		return PTR_ERR(old_xattr);
+	}
+	if (old_xattr) {
+		simple_xattr_limits_dec(limits, old_xattr->size);
+		simple_xattr_free_rcu(old_xattr);
+	}
+	return 0;
+}
+
 static bool xattr_is_trusted(const char *name)
 {
 	return !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index b5a5f32fdfd1..d8f57f0af5e4 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -99,8 +99,6 @@ enum kernfs_node_type {
 
 #define KERNFS_TYPE_MASK		0x000f
 #define KERNFS_FLAG_MASK		~KERNFS_TYPE_MASK
-#define KERNFS_MAX_USER_XATTRS		128
-#define KERNFS_USER_XATTR_SIZE_LIMIT	(128 << 10)
 
 enum kernfs_node_flag {
 	KERNFS_ACTIVATED	= 0x0010,
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index f60357d9f938..90a43a117127 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -118,6 +118,20 @@ struct simple_xattr {
 	char value[];
 };
 
+#define SIMPLE_XATTR_MAX_NR		128
+#define SIMPLE_XATTR_MAX_SIZE		(128 << 10)
+
+struct simple_xattr_limits {
+	atomic_t	nr_xattrs;	/* current user.* xattr count */
+	atomic_t	xattr_size;	/* current total user.* value bytes */
+};
+
+static inline void simple_xattr_limits_init(struct simple_xattr_limits *limits)
+{
+	atomic_set(&limits->nr_xattrs, 0);
+	atomic_set(&limits->xattr_size, 0);
+}
+
 int simple_xattrs_init(struct simple_xattrs *xattrs);
 struct simple_xattrs *simple_xattrs_alloc(void);
 struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
@@ -132,6 +146,10 @@ int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
 struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,
 				      const char *name, const void *value,
 				      size_t size, int flags);
+int simple_xattr_set_limited(struct simple_xattrs *xattrs,
+			     struct simple_xattr_limits *limits,
+			     const char *name, const void *value,
+			     size_t size, int flags);
 ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 			  char *buffer, size_t size);
 int simple_xattr_add(struct simple_xattrs *xattrs,

-- 
2.47.3



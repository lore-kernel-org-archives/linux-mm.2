Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3463DE7BDAC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94D8D6B009D; Mon, 16 Feb 2026 08:32:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904816B009E; Mon, 16 Feb 2026 08:32:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E0A6B009F; Mon, 16 Feb 2026 08:32:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFE96B009D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 359FF1A0C0C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:58 +0000 (UTC)
X-FDA: 84450410436.05.F4B5364
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C1FE40011
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D7ZNZED1;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tT3YOkpw5E0J0QYoPOOLeAnB5NKZusiZTKyYLTVhzNA=;
	b=IZgIGL0l2F4IUDHdO6O6GWuMlSJzd/YT4vdwNtmnpHhxkEdm+JRjdzJFPFSxdu+e5mLcpu
	0Zbm0lQdPwAC4LX4Bn9Gv0mF29qmOqkpuijUhBaJd6ak+8zfBExHDbNRfCVSd0GO6oL1xK
	hG/7smw4CAIRzcSWoh3sxYOluy/Jl0o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D7ZNZED1;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248776; a=rsa-sha256;
	cv=none;
	b=UXiyvDhdvEb7gnjPvsKNHE6fJ32Psp4FBJiKF06tXEWiZweaY/jeHYU7kjKiLwhJiF7ZYw
	KzPuaKBgL/h2YS9/HX5IrqBFBql3LF627djqQQGry3/zVaepTGbRAsJd4oTVilhFKwYlbY
	NgEWLABZe2cJt5CGlzMwFq0jEWMFFcs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9689E43330;
	Mon, 16 Feb 2026 13:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169F6C116C6;
	Mon, 16 Feb 2026 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248775;
	bh=og9OzjKrpi8J5E7G7hJ+vPxRQ2I1HIq12Wata8xWsm0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=D7ZNZED1zVSUgXHnknRdsN5fnqrXmOkp67JAmSwDSe+PK8bQFgt96/kDlQo6vPy+e
	 BtM+EBnrBA2O/wQT8jZWiwz0THc1m2jdshzViEFjOlNKWXKETkMPfJYUVAY/oKuMi/
	 YRcDj4uqfAisaXLvE2ZqQlmwx2Fl+UuQVZDRR3Q4A+zR0QqncNqtkl1HIUTW8eId3W
	 yG9hHZEZmservuk4/LjGzCfDRM3RUAxC0jqiXoa9nmmHcS4DFx3hpqMZNDPEvzwBwG
	 Xa3Y+eqrTklaWmhpza74vXKPcQ5ZuOpqpn8xVQ2kSwWVwU70MpzjPsF/vmJ982xeN9
	 Kg/3z4Ayz35Xg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:06 +0100
Subject: [PATCH 10/14] xattr,net: support limited amount of extended
 attributes on sockfs sockets
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-10-c2efa4f74cb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5847; i=brauner@kernel.org;
 h=from:subject:message-id; bh=og9OzjKrpi8J5E7G7hJ+vPxRQ2I1HIq12Wata8xWsm0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlomz2jXPdLuwPOdjplbdwIYlMzUXVL7iWrP81ndR0
 7p3z7RcOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyfyMjw+4fXYaf2bsnPbg7
 c/LP93saJ1y3nx97u7Of58fyldsl/AUZ/tnnXFZP07TV1dp5duaDLW6FUl8e2m9x/W+8nduoa31
 nBB8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C1FE40011
X-Stat-Signature: k1hiddkcuampem4y36ynisf6s3rf9cc3
X-Rspam-User: 
X-HE-Tag: 1771248776-757807
X-HE-Meta: U2FsdGVkX19T+onWOVXkNeGnhq2ki21iffphcZSDv/og78SdPfYd1mNJdq5waXCLGPQyWps1GXur6h8ncnQMRsaxBfWIfw431I0BBqIxLSkXSz+OcEgExk8eFz8U5UHQhvbtmE/FZ6sj9b12sAHz1/TP45npERiCdmS/5AzhEou9e6AhvH23NEBlYKMRy4CZhthyj+sWdAMtkm1e2mjodgti8b8wZsChDbN1nbU9wYeN8dcZW9sEQeyu/dy7xpwsMEHblG459wyjgHxfYwsE84fsA6PAEAQPRsnB10DQ5uW6z1hQtF+B+AyVPnx+A+3aeRWDU/Jpd+cvVouKbWO73wq99xjC6yDKPlnauuPicj4DdvVuWf5rN0xz63sVTLLea7vUvkmRlHqEJn+DvD6LUOti/3+YXgQyvpEVqM3oaC0eRp9torKbuIX8OG17t9bO/C5Kvlvrj7d8CoFnY86RKwqp/hJ/YaqP2GhaV+BCKwQKwA263pK7bJ7fGKkuUQezf7iwBbMxyPDyoZ1nkBmxgqnd4aZq9OqjaGfGPoSmRu59EPzsx9ewBncz7f8VPTXSfIe8v94dhBQHOHZuioEPyBmucs/zw2uuiYlErRjBOcAfKloEPNEYGEp3CItCIaOPO8SFPitIhMhg/7GAScS0Acd2vu1WYZmfEowTLDnSaJLpYMhmNxVOCGkjDNE0qXUu10U4H5hCOFZGz4alXP9D8emyXGCdI38mvqpoqMXpt8l044hpl1qoOcqBmSn6I1UZTockXicoG2bx6QIjf1n42rox911DaDsclM0QIlX95XSlAW/sNJuDLG/d+6d9CPL1+7PQWquoXqWgX4vuSugdUA2Uj98gMdNGJm7pYNO6FN69bUL+L1jR6YXIL1KmzFbf6LW2G3Qwczru0YDYwG7vKtrN3Xk7VRC/O0zDe4pG86TJ6Wn0r7jlShRhUWE6gNgECmgkhQ1ffCvBNVJAImF
 0lMI8BU0
 Y40ulAIxvPcubt7Af87FF86reNeMF7UlnxZshVmei0QP9xXnBDeD66P6KDlFF1nVk9JhxhoOFReIqVxVodxdCzKCswcDbw45UMrdXa/3vZkTgt8N8oAXLtBMhTfpjPZw+f23vPB9ltSL1kz0rAQL+NrTXfP5iQi8lojumgf06Mch5SskSnvLEMjBJJ9DGb7JpcnZB4EYM89q/A3xVsBaMwzcs3q2ULJxmzJ+HBpkNcsVpspfsd9vO6f/B5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we've generalized the infrastructure for user.* xattrs make it
possible to set up to 128 user.* extended attributes on a sockfs inode
or up to 128kib. kernfs (cgroupfs) has the same limits and it has proven
to be quite sufficient for nearly all use-cases.

This will allow containers to label sockets and will e.g., be used by
systemd and Gnome to find various sockets in containers where
high-privilege or more complicated solutions aren't available.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 net/socket.c | 119 +++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 92 insertions(+), 27 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 136b98c54fb3..7aa94fce7a8b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -315,45 +315,70 @@ static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
 
 static struct kmem_cache *sock_inode_cachep __ro_after_init;
 
+struct sockfs_inode {
+	struct simple_xattrs *xattrs;
+	struct simple_xattr_limits xattr_limits;
+	struct socket_alloc;
+};
+
+static struct sockfs_inode *SOCKFS_I(struct inode *inode)
+{
+	return container_of(inode, struct sockfs_inode, vfs_inode);
+}
+
 static struct inode *sock_alloc_inode(struct super_block *sb)
 {
-	struct socket_alloc *ei;
+	struct sockfs_inode *si;
 
-	ei = alloc_inode_sb(sb, sock_inode_cachep, GFP_KERNEL);
-	if (!ei)
+	si = alloc_inode_sb(sb, sock_inode_cachep, GFP_KERNEL);
+	if (!si)
 		return NULL;
-	init_waitqueue_head(&ei->socket.wq.wait);
-	ei->socket.wq.fasync_list = NULL;
-	ei->socket.wq.flags = 0;
+	si->xattrs = NULL;
+	simple_xattr_limits_init(&si->xattr_limits);
+
+	init_waitqueue_head(&si->socket.wq.wait);
+	si->socket.wq.fasync_list = NULL;
+	si->socket.wq.flags = 0;
+
+	si->socket.state = SS_UNCONNECTED;
+	si->socket.flags = 0;
+	si->socket.ops = NULL;
+	si->socket.sk = NULL;
+	si->socket.file = NULL;
 
-	ei->socket.state = SS_UNCONNECTED;
-	ei->socket.flags = 0;
-	ei->socket.ops = NULL;
-	ei->socket.sk = NULL;
-	ei->socket.file = NULL;
+	return &si->vfs_inode;
+}
+
+static void sock_evict_inode(struct inode *inode)
+{
+	struct sockfs_inode *si = SOCKFS_I(inode);
+	struct simple_xattrs *xattrs = si->xattrs;
 
-	return &ei->vfs_inode;
+	if (xattrs) {
+		simple_xattrs_free(xattrs, NULL);
+		kfree(xattrs);
+	}
+	clear_inode(inode);
 }
 
 static void sock_free_inode(struct inode *inode)
 {
-	struct socket_alloc *ei;
+	struct sockfs_inode *si = SOCKFS_I(inode);
 
-	ei = container_of(inode, struct socket_alloc, vfs_inode);
-	kmem_cache_free(sock_inode_cachep, ei);
+	kmem_cache_free(sock_inode_cachep, si);
 }
 
 static void init_once(void *foo)
 {
-	struct socket_alloc *ei = (struct socket_alloc *)foo;
+	struct sockfs_inode *si = (struct sockfs_inode *)foo;
 
-	inode_init_once(&ei->vfs_inode);
+	inode_init_once(&si->vfs_inode);
 }
 
 static void init_inodecache(void)
 {
 	sock_inode_cachep = kmem_cache_create("sock_inode_cache",
-					      sizeof(struct socket_alloc),
+					      sizeof(struct sockfs_inode),
 					      0,
 					      (SLAB_HWCACHE_ALIGN |
 					       SLAB_RECLAIM_ACCOUNT |
@@ -365,6 +390,7 @@ static void init_inodecache(void)
 static const struct super_operations sockfs_ops = {
 	.alloc_inode	= sock_alloc_inode,
 	.free_inode	= sock_free_inode,
+	.evict_inode	= sock_evict_inode,
 	.statfs		= simple_statfs,
 };
 
@@ -417,9 +443,48 @@ static const struct xattr_handler sockfs_security_xattr_handler = {
 	.set = sockfs_security_xattr_set,
 };
 
+static int sockfs_user_xattr_get(const struct xattr_handler *handler,
+				 struct dentry *dentry, struct inode *inode,
+				 const char *suffix, void *value, size_t size)
+{
+	const char *name = xattr_full_name(handler, suffix);
+	struct simple_xattrs *xattrs;
+
+	xattrs = READ_ONCE(SOCKFS_I(inode)->xattrs);
+	if (!xattrs)
+		return -ENODATA;
+
+	return simple_xattr_get(xattrs, name, value, size);
+}
+
+static int sockfs_user_xattr_set(const struct xattr_handler *handler,
+				 struct mnt_idmap *idmap,
+				 struct dentry *dentry, struct inode *inode,
+				 const char *suffix, const void *value,
+				 size_t size, int flags)
+{
+	const char *name = xattr_full_name(handler, suffix);
+	struct sockfs_inode *si = SOCKFS_I(inode);
+	struct simple_xattrs *xattrs;
+
+	xattrs = simple_xattrs_lazy_alloc(&si->xattrs, value, flags);
+	if (IS_ERR_OR_NULL(xattrs))
+		return PTR_ERR(xattrs);
+
+	return simple_xattr_set_limited(xattrs, &si->xattr_limits,
+					name, value, size, flags);
+}
+
+static const struct xattr_handler sockfs_user_xattr_handler = {
+	.prefix = XATTR_USER_PREFIX,
+	.get = sockfs_user_xattr_get,
+	.set = sockfs_user_xattr_set,
+};
+
 static const struct xattr_handler * const sockfs_xattr_handlers[] = {
 	&sockfs_xattr_handler,
 	&sockfs_security_xattr_handler,
+	&sockfs_user_xattr_handler,
 	NULL
 };
 
@@ -572,26 +637,26 @@ EXPORT_SYMBOL(sockfd_lookup);
 static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 				size_t size)
 {
-	ssize_t len;
-	ssize_t used = 0;
+	struct sockfs_inode *si = SOCKFS_I(d_inode(dentry));
+	ssize_t len, used;
 
-	len = security_inode_listsecurity(d_inode(dentry), buffer, size);
+	len = simple_xattr_list(d_inode(dentry), READ_ONCE(si->xattrs),
+				buffer, size);
 	if (len < 0)
 		return len;
-	used += len;
+
+	used = len;
 	if (buffer) {
-		if (size < used)
-			return -ERANGE;
 		buffer += len;
+		size -= len;
 	}
 
-	len = (XATTR_NAME_SOCKPROTONAME_LEN + 1);
+	len = XATTR_NAME_SOCKPROTONAME_LEN + 1;
 	used += len;
 	if (buffer) {
-		if (size < used)
+		if (size < len)
 			return -ERANGE;
 		memcpy(buffer, XATTR_NAME_SOCKPROTONAME, len);
-		buffer += len;
 	}
 
 	return used;

-- 
2.47.3



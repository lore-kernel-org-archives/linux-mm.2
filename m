Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B454AE7BDAC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E17F6B0089; Mon, 16 Feb 2026 08:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1916C6B008A; Mon, 16 Feb 2026 08:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064B16B008C; Mon, 16 Feb 2026 08:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2A7A6B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABEED160D65
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:28 +0000 (UTC)
X-FDA: 84450409176.21.BC7E9AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0446418001A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bz3aunfe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248747; a=rsa-sha256;
	cv=none;
	b=I/4fvRmiD6msVC363Q6+nozEB+x9450kMEmGcHoZntXSTzstUr5ViRsJQEbZJZ0UcVpffQ
	uRroiXIn4j29DXybB9vPIpFSKZIzVn1YBV5YaOq1pJkVSJlouKPHZP9e45nOdc5rThywvP
	Dvor7zgWqM+4SXpGaKzzvANrFViej5s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bz3aunfe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTz0JNxUbpYe1RVpv8mdyD7ObNq8FvGFLS2EgEplp38=;
	b=iZoBR0Mw+4YUjk5Zek5SakvnYfxn8+va1qyS5TA3GYWAXUOCMgho9OiKvPIOPOY8oz883a
	IPJYtJWuHjbN9xqt6zlWO4QHcQC329cVzTdIbBdsUYQF3/TcwAu/GJhJIcT0EhFGSYyoSy
	GrE+OYekhQO+4avdySbRfBx+NzAUnIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 210D2600BB;
	Mon, 16 Feb 2026 13:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6441EC116C6;
	Mon, 16 Feb 2026 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248745;
	bh=lRkBebN2DyEFUov+B67VPOUqf4avYVkt75F229kVmKA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Bz3aunfeQSsNjNdeZv+l+2mfzrW7SqsFW6w2aPYJHxtWTtGbJ7ueorBgxhU1gVxhe
	 g7waQLA/L1a0UJ+Z7yVV4usP1h3gmW7kll5xXeIGbTBVKW+FE+9Mg+vOjn2UCQfE8r
	 miev+Oy6HkW96xenVd2yAn1a7eOh6UJgf/0kKrLye9uWmIXVz8b7tAszmYhrAXmwl3
	 HIVv/u3LSzO72V2J4fSgA4x30W1u5dkG8+EZeY2yGHlI0BEdoAmw3Zne6vmOiSSnNL
	 k+vqxcKV+u+usSUMYKWvVXFGtazP4eypDw5dLaWQIEpiWv7fMIRmtkbvN81ZU9kfKr
	 JEx5TjayzWvuQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:31:58 +0100
Subject: [PATCH 02/14] xattr: add rhashtable-based simple_xattr
 infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-2-c2efa4f74cb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=19222; i=brauner@kernel.org;
 h=from:subject:message-id; bh=lRkBebN2DyEFUov+B67VPOUqf4avYVkt75F229kVmKA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlonTUGbJPHl0a927JS9eBklpqNh/vWX2ePZKztSD1
 Suv2xgUdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkbB7D/0TRXstZP6e4f2+8
 fqVuGfe6i/nm0dPiD/v8UshJe8sm+Inhv++u5+fNcmRdZl5a8PpBgq+44aeM5pZ3U3UZP/zXnyN
 dzQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0446418001A
X-Stat-Signature: j9tu3i7pmx7dch3hcpewqaxbfdzc4133
X-HE-Tag: 1771248746-582027
X-HE-Meta: U2FsdGVkX18NYCsiEzLPxb245Y34xN0YnX8vEFn9TxG4dEmGiWH8Qr5sxQEk3ny1w+3K4mpmVOnjC7Uz1ONZw9rr88bQna3gojeHDraZnRY22rY3FeQjArS63Nz6LX93kdvnL0y7pN0TR2odRsu9/gU4mi+cm8cz0xd5LXCZywCENeHL0r8OUdUOnj6sJUBjBqnrOM06rpsYM7SB75k24cT2hROLyAjTMyqX8FAiXX7R+Ma+mgLkxct2s7u9GeAPgISu1oHjax7DBWbbMPpT3ahPtgaXEPejtutDGWr+ibSaApqkfISqLiHKTAJOheEC8NHHVnoW6/V2NbVRaHUs5f5b2sb+7XSJtuigRcV5oLh8THiXX1WZ/3TZzimkrEoRlJCHw+kNB6WhlqUlqGD/pD1DIYXnOC7h5FyeNe2oKPwR5LEbiCDvhw171++n38LmJp01PGxGtjRnye6h9QGDbnsJs0CUab1GaBGnTt9NzxL1ZUBjIgwRTvOyha+JGIZD5y8o5Qleai+YRgMqL35fQW5aUE1fILcUQe/ERd6nomydeyjRaVx/uVe7ubIIvvw+xWM7rwz/txJsCGYOgJEYOxd6VU18/s/inVsCX3BudNu8kB4e0WdI08Vep7IochDBEd3a9SX/QzNJZxqSSCDnaKpR704/jI/ug1SLZzt/LHm18mWLphdX36xH1iLt0zVlioe5zXmdn7tkSifax7f53+oFLBJM1fHxSHo23gduRXfXSRAW5M/yfgjN7u0DL7jthtWMJWzGb9HS9dUYUzaKGXyadNs86SsG6cpT8MwC254ToRF0/UNqJfPimhd0czb0vu6TlHjzceGCaLcw2CyWfF05iYUUiQBZ/MK4P/9/mBCAjPfro39ziLajtw5MMDdkhccrMN8+jdGb9zJZlhWRjr3SbYEIJoVa51nAcVK8gyTNJ03huDTUVRxWka+RhJk0b4LXqiUsS2C32HPLkgN
 JWXX7Bk3
 yRH8A/kj6M/IsV2KbfVwY+Y1P+ptD8GEM/vCxNhbNhPyHktqjDUDAYAqHA8b9qF6qIk8EQRVYW++u5BBH1F7OJJHce0eVioD1naMuo/rbjjtNkNXD4ApPdjYqB8FNanD0VhfS3XBFAgdjzQi/KT71GxB8lrefTsXCzdUhjlK8wCx9qVio/kAOo9LVb/iENPlZXA8Oc0brFdS8mOnMrgxKwDFlrTiuF08SVpHC6IkSWnjAiBLKBYZ/ZRjD84/TvX3eraj1pN0y6njg4FRa77q8ERF/bDjh66D0XEkzZechpYcPxyE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add rhashtable support to the simple_xattr subsystem while keeping the
existing rbtree code fully functional. This allows consumers to be
migrated one at a time without breaking any intermediate build.

struct simple_xattrs gains a dispatch flag and a union holding either
the rbtree (rb_root + rwlock) or rhashtable state:

  struct simple_xattrs {
      bool use_rhashtable;
      union {
          struct { struct rb_root rb_root; rwlock_t lock; };
          struct rhashtable ht;
      };
  };

simple_xattrs_init() continues to set up the rbtree path for existing
embedded-struct callers.

Add simple_xattrs_alloc() which dynamically allocates a simple_xattrs
and initializes the rhashtable path. This is the entry point for
consumers switching to pointer-based lazy allocation.

The five core functions (get, set, list, add, free) dispatch based on
the use_rhashtable flag.

Existing callers continue to use the rbtree path unchanged. As each
consumer is converted it will switch to simple_xattrs_alloc() and the
rhashtable path. Once all consumers are converted a follow-up patch
will remove the rbtree code.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/xattr.c            | 439 ++++++++++++++++++++++++++++++++++++++------------
 include/linux/xattr.h |  25 ++-
 mm/shmem.c            |   2 +-
 3 files changed, 357 insertions(+), 109 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 9cbb1917bcb2..1d98ea459b7b 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -22,6 +22,7 @@
 #include <linux/audit.h>
 #include <linux/vmalloc.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/rhashtable.h>
 
 #include <linux/uaccess.h>
 
@@ -1228,22 +1229,25 @@ void simple_xattr_free_rcu(struct simple_xattr *xattr)
  * Allocate a new xattr object and initialize respective members. The caller is
  * responsible for handling the name of the xattr.
  *
- * Return: On success a new xattr object is returned. On failure NULL is
- * returned.
+ * Return: New xattr object on success, NULL if @value is NULL, ERR_PTR on
+ * failure.
  */
 struct simple_xattr *simple_xattr_alloc(const void *value, size_t size)
 {
 	struct simple_xattr *new_xattr;
 	size_t len;
 
+	if (!value)
+		return NULL;
+
 	/* wrap around? */
 	len = sizeof(*new_xattr) + size;
 	if (len < sizeof(*new_xattr))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	new_xattr = kvmalloc(len, GFP_KERNEL_ACCOUNT);
 	if (!new_xattr)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	new_xattr->size = size;
 	memcpy(new_xattr->value, value, size);
@@ -1287,6 +1291,33 @@ static int rbtree_simple_xattr_node_cmp(struct rb_node *new_node,
 	return rbtree_simple_xattr_cmp(xattr->name, node);
 }
 
+static u32 simple_xattr_hashfn(const void *data, u32 len, u32 seed)
+{
+	const char *name = data;
+	return jhash(name, strlen(name), seed);
+}
+
+static u32 simple_xattr_obj_hashfn(const void *obj, u32 len, u32 seed)
+{
+	const struct simple_xattr *xattr = obj;
+	return jhash(xattr->name, strlen(xattr->name), seed);
+}
+
+static int simple_xattr_obj_cmpfn(struct rhashtable_compare_arg *arg,
+				   const void *obj)
+{
+	const struct simple_xattr *xattr = obj;
+	return strcmp(xattr->name, arg->key);
+}
+
+static const struct rhashtable_params simple_xattr_params = {
+	.head_offset    = offsetof(struct simple_xattr, hash_node),
+	.hashfn         = simple_xattr_hashfn,
+	.obj_hashfn     = simple_xattr_obj_hashfn,
+	.obj_cmpfn      = simple_xattr_obj_cmpfn,
+	.automatic_shrinking = true,
+};
+
 /**
  * simple_xattr_get - get an xattr object
  * @xattrs: the header of the xattr object
@@ -1306,22 +1337,41 @@ int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
 		     void *buffer, size_t size)
 {
 	struct simple_xattr *xattr = NULL;
-	struct rb_node *rbp;
 	int ret = -ENODATA;
 
-	read_lock(&xattrs->lock);
-	rbp = rb_find(name, &xattrs->rb_root, rbtree_simple_xattr_cmp);
-	if (rbp) {
-		xattr = rb_entry(rbp, struct simple_xattr, rb_node);
-		ret = xattr->size;
-		if (buffer) {
-			if (size < xattr->size)
-				ret = -ERANGE;
-			else
-				memcpy(buffer, xattr->value, xattr->size);
+	if (xattrs->use_rhashtable) {
+		guard(rcu)();
+		xattr = rhashtable_lookup(&xattrs->ht, name,
+					  simple_xattr_params);
+		if (xattr) {
+			ret = xattr->size;
+			if (buffer) {
+				if (size < xattr->size)
+					ret = -ERANGE;
+				else
+					memcpy(buffer, xattr->value,
+					       xattr->size);
+			}
+		}
+	} else {
+		struct rb_node *rbp;
+
+		read_lock(&xattrs->lock);
+		rbp = rb_find(name, &xattrs->rb_root,
+			      rbtree_simple_xattr_cmp);
+		if (rbp) {
+			xattr = rb_entry(rbp, struct simple_xattr, rb_node);
+			ret = xattr->size;
+			if (buffer) {
+				if (size < xattr->size)
+					ret = -ERANGE;
+				else
+					memcpy(buffer, xattr->value,
+					       xattr->size);
+			}
 		}
+		read_unlock(&xattrs->lock);
 	}
-	read_unlock(&xattrs->lock);
 	return ret;
 }
 
@@ -1355,78 +1405,134 @@ struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,
 				      const char *name, const void *value,
 				      size_t size, int flags)
 {
-	struct simple_xattr *old_xattr = NULL, *new_xattr = NULL;
-	struct rb_node *parent = NULL, **rbp;
-	int err = 0, ret;
+	struct simple_xattr *old_xattr = NULL;
+	int err = 0;
 
-	/* value == NULL means remove */
-	if (value) {
-		new_xattr = simple_xattr_alloc(value, size);
-		if (!new_xattr)
-			return ERR_PTR(-ENOMEM);
+	CLASS(simple_xattr, new_xattr)(value, size);
+	if (IS_ERR(new_xattr))
+		return new_xattr;
 
+	if (new_xattr) {
 		new_xattr->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
-		if (!new_xattr->name) {
-			simple_xattr_free(new_xattr);
+		if (!new_xattr->name)
 			return ERR_PTR(-ENOMEM);
-		}
 	}
 
-	write_lock(&xattrs->lock);
-	rbp = &xattrs->rb_root.rb_node;
-	while (*rbp) {
-		parent = *rbp;
-		ret = rbtree_simple_xattr_cmp(name, *rbp);
-		if (ret < 0)
-			rbp = &(*rbp)->rb_left;
-		else if (ret > 0)
-			rbp = &(*rbp)->rb_right;
-		else
-			old_xattr = rb_entry(*rbp, struct simple_xattr, rb_node);
-		if (old_xattr)
-			break;
-	}
+	if (xattrs->use_rhashtable) {
+		/*
+		 * Lookup is safe without RCU here since writes are
+		 * serialized by the caller.
+		 */
+		old_xattr = rhashtable_lookup_fast(&xattrs->ht, name,
+						   simple_xattr_params);
+
+		if (old_xattr) {
+			/* Fail if XATTR_CREATE is requested and the xattr exists. */
+			if (flags & XATTR_CREATE)
+				return ERR_PTR(-EEXIST);
+
+			if (new_xattr) {
+				err = rhashtable_replace_fast(&xattrs->ht,
+							     &old_xattr->hash_node,
+							     &new_xattr->hash_node,
+							     simple_xattr_params);
+				if (err)
+					return ERR_PTR(err);
+			} else {
+				err = rhashtable_remove_fast(&xattrs->ht,
+							    &old_xattr->hash_node,
+							    simple_xattr_params);
+				if (err)
+					return ERR_PTR(err);
+			}
+		} else {
+			/* Fail if XATTR_REPLACE is requested but no xattr is found. */
+			if (flags & XATTR_REPLACE)
+				return ERR_PTR(-ENODATA);
+
+			/*
+			 * If XATTR_CREATE or no flags are specified together
+			 * with a new value simply insert it.
+			 */
+			if (new_xattr) {
+				err = rhashtable_insert_fast(&xattrs->ht,
+							    &new_xattr->hash_node,
+							    simple_xattr_params);
+				if (err)
+					return ERR_PTR(err);
+			}
 
-	if (old_xattr) {
-		/* Fail if XATTR_CREATE is requested and the xattr exists. */
-		if (flags & XATTR_CREATE) {
-			err = -EEXIST;
-			goto out_unlock;
+			/*
+			 * If XATTR_CREATE or no flags are specified and
+			 * neither an old or new xattr exist then we don't
+			 * need to do anything.
+			 */
 		}
-
-		if (new_xattr)
-			rb_replace_node(&old_xattr->rb_node,
-					&new_xattr->rb_node, &xattrs->rb_root);
-		else
-			rb_erase(&old_xattr->rb_node, &xattrs->rb_root);
 	} else {
-		/* Fail if XATTR_REPLACE is requested but no xattr is found. */
-		if (flags & XATTR_REPLACE) {
-			err = -ENODATA;
-			goto out_unlock;
-		}
+		struct rb_node *parent = NULL, **rbp;
+		int ret;
 
-		/*
-		 * If XATTR_CREATE or no flags are specified together with a
-		 * new value simply insert it.
-		 */
-		if (new_xattr) {
-			rb_link_node(&new_xattr->rb_node, parent, rbp);
-			rb_insert_color(&new_xattr->rb_node, &xattrs->rb_root);
+		write_lock(&xattrs->lock);
+		rbp = &xattrs->rb_root.rb_node;
+		while (*rbp) {
+			parent = *rbp;
+			ret = rbtree_simple_xattr_cmp(name, *rbp);
+			if (ret < 0)
+				rbp = &(*rbp)->rb_left;
+			else if (ret > 0)
+				rbp = &(*rbp)->rb_right;
+			else
+				old_xattr = rb_entry(*rbp, struct simple_xattr,
+						     rb_node);
+			if (old_xattr)
+				break;
 		}
 
-		/*
-		 * If XATTR_CREATE or no flags are specified and neither an
-		 * old or new xattr exist then we don't need to do anything.
-		 */
-	}
+		if (old_xattr) {
+			/* Fail if XATTR_CREATE is requested and the xattr exists. */
+			if (flags & XATTR_CREATE) {
+				err = -EEXIST;
+				goto out_unlock;
+			}
+
+			if (new_xattr)
+				rb_replace_node(&old_xattr->rb_node,
+						&new_xattr->rb_node,
+						&xattrs->rb_root);
+			else
+				rb_erase(&old_xattr->rb_node,
+					 &xattrs->rb_root);
+		} else {
+			/* Fail if XATTR_REPLACE is requested but no xattr is found. */
+			if (flags & XATTR_REPLACE) {
+				err = -ENODATA;
+				goto out_unlock;
+			}
+
+			/*
+			 * If XATTR_CREATE or no flags are specified together
+			 * with a new value simply insert it.
+			 */
+			if (new_xattr) {
+				rb_link_node(&new_xattr->rb_node, parent, rbp);
+				rb_insert_color(&new_xattr->rb_node,
+						&xattrs->rb_root);
+			}
+
+			/*
+			 * If XATTR_CREATE or no flags are specified and
+			 * neither an old or new xattr exist then we don't
+			 * need to do anything.
+			 */
+		}
 
 out_unlock:
-	write_unlock(&xattrs->lock);
-	if (!err)
-		return old_xattr;
-	simple_xattr_free(new_xattr);
-	return ERR_PTR(err);
+		write_unlock(&xattrs->lock);
+		if (err)
+			return ERR_PTR(err);
+	}
+	retain_and_null_ptr(new_xattr);
+	return old_xattr;
 }
 
 static bool xattr_is_trusted(const char *name)
@@ -1467,7 +1573,6 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 {
 	bool trusted = ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 	struct simple_xattr *xattr;
-	struct rb_node *rbp;
 	ssize_t remaining_size = size;
 	int err = 0;
 
@@ -1487,23 +1592,62 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 	remaining_size -= err;
 	err = 0;
 
-	read_lock(&xattrs->lock);
-	for (rbp = rb_first(&xattrs->rb_root); rbp; rbp = rb_next(rbp)) {
-		xattr = rb_entry(rbp, struct simple_xattr, rb_node);
+	if (!xattrs)
+		return size - remaining_size;
 
-		/* skip "trusted." attributes for unprivileged callers */
-		if (!trusted && xattr_is_trusted(xattr->name))
-			continue;
+	if (xattrs->use_rhashtable) {
+		struct rhashtable_iter iter;
 
-		/* skip MAC labels; these are provided by LSM above */
-		if (xattr_is_maclabel(xattr->name))
-			continue;
+		rhashtable_walk_enter(&xattrs->ht, &iter);
+		rhashtable_walk_start(&iter);
 
-		err = xattr_list_one(&buffer, &remaining_size, xattr->name);
-		if (err)
-			break;
+		while ((xattr = rhashtable_walk_next(&iter)) != NULL) {
+			if (IS_ERR(xattr)) {
+				if (PTR_ERR(xattr) == -EAGAIN)
+					continue;
+				err = PTR_ERR(xattr);
+				break;
+			}
+
+			/* skip "trusted." attributes for unprivileged callers */
+			if (!trusted && xattr_is_trusted(xattr->name))
+				continue;
+
+			/* skip MAC labels; these are provided by LSM above */
+			if (xattr_is_maclabel(xattr->name))
+				continue;
+
+			err = xattr_list_one(&buffer, &remaining_size,
+					     xattr->name);
+			if (err)
+				break;
+		}
+
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+	} else {
+		struct rb_node *rbp;
+
+		read_lock(&xattrs->lock);
+		for (rbp = rb_first(&xattrs->rb_root); rbp;
+		     rbp = rb_next(rbp)) {
+			xattr = rb_entry(rbp, struct simple_xattr, rb_node);
+
+			/* skip "trusted." attributes for unprivileged callers */
+			if (!trusted && xattr_is_trusted(xattr->name))
+				continue;
+
+			/* skip MAC labels; these are provided by LSM above */
+			if (xattr_is_maclabel(xattr->name))
+				continue;
+
+			err = xattr_list_one(&buffer, &remaining_size,
+					     xattr->name);
+			if (err)
+				break;
+		}
+		read_unlock(&xattrs->lock);
 	}
-	read_unlock(&xattrs->lock);
 
 	return err ? err : size - remaining_size;
 }
@@ -1536,9 +1680,16 @@ static bool rbtree_simple_xattr_less(struct rb_node *new_node,
 void simple_xattr_add(struct simple_xattrs *xattrs,
 		      struct simple_xattr *new_xattr)
 {
-	write_lock(&xattrs->lock);
-	rb_add(&new_xattr->rb_node, &xattrs->rb_root, rbtree_simple_xattr_less);
-	write_unlock(&xattrs->lock);
+	if (xattrs->use_rhashtable) {
+		WARN_ON(rhashtable_insert_fast(&xattrs->ht,
+					       &new_xattr->hash_node,
+					       simple_xattr_params));
+	} else {
+		write_lock(&xattrs->lock);
+		rb_add(&new_xattr->rb_node, &xattrs->rb_root,
+		       rbtree_simple_xattr_less);
+		write_unlock(&xattrs->lock);
+	}
 }
 
 /**
@@ -1549,10 +1700,80 @@ void simple_xattr_add(struct simple_xattrs *xattrs,
  */
 void simple_xattrs_init(struct simple_xattrs *xattrs)
 {
+	xattrs->use_rhashtable = false;
 	xattrs->rb_root = RB_ROOT;
 	rwlock_init(&xattrs->lock);
 }
 
+/**
+ * simple_xattrs_alloc - allocate and initialize a new xattr header
+ *
+ * Dynamically allocate a simple_xattrs header and initialize the
+ * underlying rhashtable. This is intended for consumers that want
+ * rhashtable-based xattr storage.
+ *
+ * Return: On success a new simple_xattrs is returned. On failure an
+ * ERR_PTR is returned.
+ */
+struct simple_xattrs *simple_xattrs_alloc(void)
+{
+	struct simple_xattrs *xattrs __free(kfree) = NULL;
+
+	xattrs = kzalloc(sizeof(*xattrs), GFP_KERNEL);
+	if (!xattrs)
+		return ERR_PTR(-ENOMEM);
+
+	xattrs->use_rhashtable = true;
+	if (rhashtable_init(&xattrs->ht, &simple_xattr_params))
+		return ERR_PTR(-ENOMEM);
+
+	return no_free_ptr(xattrs);
+}
+
+/**
+ * simple_xattrs_lazy_alloc - get or allocate xattrs for a set operation
+ * @xattrsp: pointer to the xattrs pointer (may point to NULL)
+ * @value: value being set (NULL means remove)
+ * @flags: xattr set flags
+ *
+ * For lazily-allocated xattrs on the write path. If no xattrs exist yet
+ * and this is a remove operation, returns the appropriate result without
+ * allocating. Otherwise ensures xattrs is allocated and published with
+ * store-release semantics.
+ *
+ * Return: On success a valid pointer to the xattrs is returned. On
+ * failure or early-exit an ERR_PTR or NULL is returned. Callers should
+ * check with IS_ERR_OR_NULL() and propagate with PTR_ERR() which
+ * correctly returns 0 for the NULL no-op case.
+ */
+struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
+					       const void *value, int flags)
+{
+	struct simple_xattrs *xattrs;
+
+	xattrs = READ_ONCE(*xattrsp);
+	if (xattrs)
+		return xattrs;
+
+	if (!value)
+		return (flags & XATTR_REPLACE) ? ERR_PTR(-ENODATA) : NULL;
+
+	xattrs = simple_xattrs_alloc();
+	if (!IS_ERR(xattrs))
+		smp_store_release(xattrsp, xattrs);
+	return xattrs;
+}
+
+static void simple_xattr_ht_free(void *ptr, void *arg)
+{
+	struct simple_xattr *xattr = ptr;
+	size_t *freed_space = arg;
+
+	if (freed_space)
+		*freed_space += simple_xattr_space(xattr->name, xattr->size);
+	simple_xattr_free(xattr);
+}
+
 /**
  * simple_xattrs_free - free xattrs
  * @xattrs: xattr header whose xattrs to destroy
@@ -1563,22 +1784,28 @@ void simple_xattrs_init(struct simple_xattrs *xattrs)
  */
 void simple_xattrs_free(struct simple_xattrs *xattrs, size_t *freed_space)
 {
-	struct rb_node *rbp;
-
 	if (freed_space)
 		*freed_space = 0;
-	rbp = rb_first(&xattrs->rb_root);
-	while (rbp) {
-		struct simple_xattr *xattr;
-		struct rb_node *rbp_next;
-
-		rbp_next = rb_next(rbp);
-		xattr = rb_entry(rbp, struct simple_xattr, rb_node);
-		rb_erase(&xattr->rb_node, &xattrs->rb_root);
-		if (freed_space)
-			*freed_space += simple_xattr_space(xattr->name,
-							   xattr->size);
-		simple_xattr_free(xattr);
-		rbp = rbp_next;
+
+	if (xattrs->use_rhashtable) {
+		rhashtable_free_and_destroy(&xattrs->ht,
+					    simple_xattr_ht_free, freed_space);
+	} else {
+		struct rb_node *rbp;
+
+		rbp = rb_first(&xattrs->rb_root);
+		while (rbp) {
+			struct simple_xattr *xattr;
+			struct rb_node *rbp_next;
+
+			rbp_next = rb_next(rbp);
+			xattr = rb_entry(rbp, struct simple_xattr, rb_node);
+			rb_erase(&xattr->rb_node, &xattrs->rb_root);
+			if (freed_space)
+				*freed_space += simple_xattr_space(xattr->name,
+								   xattr->size);
+			simple_xattr_free(xattr);
+			rbp = rbp_next;
+		}
 	}
 }
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 1328f2bfd2ce..ee4fd40717a0 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -107,8 +107,14 @@ static inline const char *xattr_prefix(const struct xattr_handler *handler)
 }
 
 struct simple_xattrs {
-	struct rb_root rb_root;
-	rwlock_t lock;
+	bool use_rhashtable;
+	union {
+		struct {
+			struct rb_root rb_root;
+			rwlock_t lock;
+		};
+		struct rhashtable ht;
+	};
 };
 
 struct simple_xattr {
@@ -121,6 +127,9 @@ struct simple_xattr {
 };
 
 void simple_xattrs_init(struct simple_xattrs *xattrs);
+struct simple_xattrs *simple_xattrs_alloc(void);
+struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
+					       const void *value, int flags);
 void simple_xattrs_free(struct simple_xattrs *xattrs, size_t *freed_space);
 size_t simple_xattr_space(const char *name, size_t size);
 struct simple_xattr *simple_xattr_alloc(const void *value, size_t size);
@@ -137,4 +146,16 @@ void simple_xattr_add(struct simple_xattrs *xattrs,
 		      struct simple_xattr *new_xattr);
 int xattr_list_one(char **buffer, ssize_t *remaining_size, const char *name);
 
+DEFINE_CLASS(simple_xattr,
+	     struct simple_xattr *,
+	     if (!IS_ERR_OR_NULL(_T)) simple_xattr_free(_T),
+	     simple_xattr_alloc(value, size),
+	     const void *value, size_t size)
+
+DEFINE_CLASS(simple_xattrs,
+            struct simple_xattrs *,
+            if (!IS_ERR_OR_NULL(_T)) { simple_xattrs_free(_T, NULL); kfree(_T); },
+            simple_xattrs_alloc(),
+            void)
+
 #endif	/* _LINUX_XATTR_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index 063b4c3e4ccb..fc8020ce2e9f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4293,7 +4293,7 @@ static int shmem_initxattrs(struct inode *inode,
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		new_xattr = simple_xattr_alloc(xattr->value, xattr->value_len);
-		if (!new_xattr)
+		if (IS_ERR(new_xattr))
 			break;
 
 		len = strlen(xattr->name) + 1;

-- 
2.47.3



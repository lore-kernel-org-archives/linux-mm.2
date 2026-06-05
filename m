Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D25CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD196B0096; Fri,  5 Jun 2026 09:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435BD6B0098; Fri,  5 Jun 2026 09:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CB76B0099; Fri,  5 Jun 2026 09:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2418B6B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:53:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E099E140124
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:34 +0000 (UTC)
X-FDA: 84846001548.07.B40E422
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA2EA120008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=beY5W228;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780667612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpzLNVlZSVD+4GUTp+kJ/L/4mCDoo2M0sTI+7GERLQA=;
	b=qRv4f9B1nIytGQZfYPv9dYVdi6GELqr7LHGs333dAqVJPzWyZ5HOU8J+QS/7WpbVMggM92
	zQKBnoM+YUsVxSnXZvQo4Rr341XsZijMzxzumzRXkSCSPfkVUIyoSns3FQoPM9kLao/CKd
	NUo+XkynAmYtPs1ZcT69qd6CbnunTzY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=beY5W228;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780667612;
	b=rSZRl3mt1E/sd/JPw/ox/Q04966nWUAB8c7cAG7u7k/AR83laT2Wt/ZCs09ZohL6/3Cs5N
	XM/2chmLHkMoLAZhhxPEUSwSgbj6KUXlt3TtYCZ9l1G86nDAXRDklGhvXRk4SHPDzS4D4P
	mF3cRFfvWSr0c++QZKgjsZP/8F+ZHoo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780667612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GpzLNVlZSVD+4GUTp+kJ/L/4mCDoo2M0sTI+7GERLQA=;
	b=beY5W228ZtE8J2NlGqiAkf+qnTjnYSGiRPGCL1oMnpLbVIhrCFy1PwmSM384BjScltvEKi
	6X1uKejC+ZVIWdYNNHIL3JyzxNHyTwigI+kCcnISxSh8m6gscXF6uR3I6SxCfwjIk/6W7H
	QAexmWZdL4SD70s4lS4Fy+xOegbIVuM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-hEVj0DeYPcKW0qCHn1cSug-1; Fri, 05 Jun 2026 09:53:28 -0400
X-MC-Unique: hEVj0DeYPcKW0qCHn1cSug-1
X-Mimecast-MFC-AGG-ID: hEVj0DeYPcKW0qCHn1cSug_1780667607
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a7aeaddbso16577535e9.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 06:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780667607; x=1781272407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GpzLNVlZSVD+4GUTp+kJ/L/4mCDoo2M0sTI+7GERLQA=;
        b=KGdwt8jIwpZHP698ikrDrI3yrbFhJoGkoeX7mo6Eys+5sBZAIDYfIRlDYUS2bNISpK
         q/grf/DjHmFzbGMgK2MIllRpZ8HSMk4EER4HyL3zz3ASthONkX9KyH67y1FkqBjpZFPS
         1GP5tAkG+rg9ZXxE8bkEinlB+TGBD6N4vtz+947KFhz0JN4XmS6bv1ITt6RT+rR9JBJu
         HTIf8SNC3QFAverKzvHkY2du68Zr+YhaYe+MRIV5rmP3X7iX9KIT1LLeFkHrwk1V6GNS
         6h58n5CgGTALtxpkIr6MFTE24YSsntSxqYmhicNczYt8Gy60HQArKavXtwqXYddvtldO
         cmSw==
X-Gm-Message-State: AOJu0Yx5uil6rDBU3IlWdedb0Z0unQj8ZrfuHvR6Bcr5fK1ibHwuaSsh
	8c8a2/XmMuSf09C0Ni7+5bLKdiB+RQg5MAuD7j5MClmYy8VdZp7ovosBkPEe3LqsPPGRO6kmfZb
	7EtppDgHajqa73kVgn4ZA4ljOPBa+GCTFWbTalWJ9RgPGRjotUxZ8CuKxwF6U
X-Gm-Gg: Acq92OEvmQE9dJT3qoC1cGfnNHFxkHC0O5ytm7wo6LLAgqaRsdGrOZ5GX/U1gD/dkY6
	EeDsOnutMv+FuMVNcKOg+CnqlprOEB8mND3qx9b3hEbAz5VjK/eT6lc3eweFI+emK2ySlSTcMSZ
	cXYcU4Dplhu/6Q1aM3zhKpB1OsuM0dtkH623ttrYinsaou39oVkQu2faIk08h2A69B8u5crxPpI
	tRoSYkO86rQGAbDXx2dCUKJk/AGFFIxuZ+63VcAHq2tyIvBRoJEwEDD28oK8Wgq3RXMqpr/JSSu
	rb7reWYWimc7aYgoH0T2krugNXYHDIyRVxyGRWorids4e8XlOwR6cGzwyu1h13MeniRNyCAp4V+
	Id2+pjRCUGUIue9gS4ikErR6FmjfLcVnFrqQuKTA1lJhCTLYsqeOPpCEbhg6y1vEaZcWoYpTthp
	TzclHwpg==
X-Received: by 2002:a05:600c:34d2:b0:48f:e230:29f4 with SMTP id 5b1f17b1804b1-490c2d1fb35mr47100705e9.15.1780667607233;
        Fri, 05 Jun 2026 06:53:27 -0700 (PDT)
X-Received: by 2002:a05:600c:34d2:b0:48f:e230:29f4 with SMTP id 5b1f17b1804b1-490c2d1fb35mr47100235e9.15.1780667606727;
        Fri, 05 Jun 2026 06:53:26 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-1-92.pool.digikabel.hu. [84.236.1.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cbfe4sm157999025e9.7.2026.06.05.06.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 06:53:26 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v4 3/4] simple_xattr: change interface to pass struct simple_xattrs **
Date: Fri,  5 Jun 2026 15:53:18 +0200
Message-ID: <20260605135322.2632068-4-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605135322.2632068-1-mszeredi@redhat.com>
References: <20260605135322.2632068-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KmBnJZQlqgKikoDOWnJJUDaPQo4gwwRYZbXK55osDj0_1780667607
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ggd5dj5oqyx4tpockcwc58tqc8i3o3n7
X-Rspamd-Queue-Id: BA2EA120008
X-HE-Tag: 1780667612-895132
X-HE-Meta: U2FsdGVkX19G2VIVlRNZhxtXX/c3K8slvDGYqRaYb9ZMRk/BaX6iKTZOaQHwWSGOvoxlmnIfQa5y0DihBE4pH7Ad5HhyblxZdaMbIv0nGzIyUgciBTsyNDP7J2heNCnT+V0UM4FZFbp6Bf8nIL31EtyFK9dfyqrfsSxNq0Gony8WNa8DmCEUrYN8Lbbydpga0eD0tmhTfG5Zkxb+Z7pQGNppr2qK3giZIsa6BbPI8vrhEM4wRlXdBDx26JHDZMHuS4wOcsnqQiD//Tc5uty1HflNJuB8yQpyWbtFMU09aTouvXpe1mPiEIEyySWStZE8F2+7uwUsuIu/r+IwuPEcp4p1rEsdGFa0tUwh4CNRwoUHEuHQPXLjsHMPqHPdXJef/Yct5+g0oHb6q1qphRiQ+sQOOxHpgySeHjJksh72WExpVUq10JI1XAX1dwXiNjpkA0pY3EO3Mo12GSmPHhFDcBR/6DEBIQSfDmBq85ol6gC8FyRWc6I7IATDN6RAOdFv6/xt7+7hFdTslBMZrk0/E9weEy4s7jrQq9q+L+H8A+ZWO8NORkc0vBNAb3jl56rCR9NFGaeBrl1Tx5FbTD12YkpL/xF8Ows9M6XooyLPNJVThym2ylgz3fmnuP6/KinzovcrEixGWPqNSEt0WXjWBpCUXdMTqNoHed23A+cjEE6Aor+5Mdg7V4j7vIleRZ1F3+TgHtwndfDVWIlbWQKe3eQUvjNbbgx4HtI+e1p0+DCb/dkKVV8WdZKtmiVTuWoHZZc/I4rlIQw2+OAtc7zp1cT0BE5/EsIuB7XzRlvN2pqwbsUoAZuAK+E6J7p2DJc7wu/8OEaTAU3zgE1kPmQFKwFbEvNysXqAJNjtENpdHhtg692JX/s4rRrWVy+ct0SoUDuWmTpgmvG/mlT4E18W7C0+dekZ0JKkcdlPMiTyR3dahFJCkSoGSm6S5BIPBji3e25SsKPq5gU242MMkO0
 TE44XRcK
 /fsuaXyLRWLd345rcGyj5Qxp1VSbqb3PyivAmCr81a77Oc2LdzfCysVjrGeNZrY/kp/Jt4TYQ/2a1Jz9SwfgN0gZ4jb/IDqFAR3o0hEdZjvL68fgqDyzRDSOcGFqSL/IQKazrzghBfEJcYcYGF92/AaVwl4H5D/FBed+mXsCPi8t8fEOlnmdd6CDIdfTxTf88nUMfAXFSDouEHMLOQHfuISuw73MtlVL7te5FWFlhdbUBtlenG6nvzPD6RBMWFQpUs2l/U/gBoWKDgnk49qsWPOh66hHlLDK4DkQIMIAERA9gH3XlL6gDJdSBHEauN6Ff2DYDxf8g9tfMgjlNHsJ5FELXTT5U9rmkLvUu5ZrnyjX4EAxhgpCL2vNfEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the simple_xattr API to accept pointer-to-pointer (struct
simple_xattrs **) instead of pointer.  This allows the functions to handle
lazy allocation internally without requiring callers to use
simple_xattrs_lazy_alloc().

The simple_xattr_set(), simple_xattr_set_limited() and simple_xattr_add()
functions now handle allocation when xattrs is NULL.  simple_xattrs_free()
now also frees the xattrs structure itself and sets the pointer to NULL.

This simplifies callers and removes the need for most callers to explicitly
manage xattrs allocation and lifetime.

In shmem_initxattrs(), the total required space for all initial xattrs
(ispace) is pre-calculated and deducted from sbinfo->free_ispace.

Since this patch modifies the function to add new xattrs directly to the
inode's &info->xattrs list rather than using a local temporary variable, a
failure means that the partially populated info->xattrs list remains
attached to the inode.

When the VFS caller handles the -ENOMEM error, it drops the newly created
inode via iput(), shmem_free_inode() adds freed to sbinfo->free_ispace a
second time, permanently inflating the tmpfs free space quota.

Fix by substracting already added xattrs from ispace.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/kernfs/dir.c       | 12 +++--------
 fs/kernfs/inode.c     | 24 ++++------------------
 fs/pidfs.c            | 37 ++++++----------------------------
 fs/xattr.c            | 46 ++++++++++++++++++++++++++++++++++---------
 include/linux/xattr.h | 21 ++++++--------------
 mm/shmem.c            | 34 ++++++++++----------------------
 net/socket.c          | 24 +++++-----------------
 7 files changed, 71 insertions(+), 127 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 4f9ade82b08a..368dc4a217d9 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -605,11 +605,8 @@ void kernfs_put(struct kernfs_node *kn)
 	if (kernfs_type(kn) == KERNFS_LINK)
 		kernfs_put(kn->symlink.target_kn);
 
-	if (kn->iattr && kn->iattr->xattrs) {
-		simple_xattrs_free(kn->iattr->xattrs, NULL);
-		kfree(kn->iattr->xattrs);
-		kn->iattr->xattrs = NULL;
-	}
+	if (kn->iattr)
+		simple_xattrs_free(&kn->iattr->xattrs, NULL);
 
 	spin_lock(&root->kernfs_idr_lock);
 	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
@@ -709,10 +706,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 
  err_out4:
 	if (kn->iattr) {
-		if (kn->iattr->xattrs) {
-			simple_xattrs_free(kn->iattr->xattrs, NULL);
-			kfree(kn->iattr->xattrs);
-		}
+		simple_xattrs_free(&kn->iattr->xattrs, NULL);
 		kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
 	}
  err_out3:
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index e676737d9531..f2298de6bc6f 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -144,8 +144,7 @@ ssize_t kernfs_iop_listxattr(struct dentry *dentry, char *buf, size_t size)
 	if (!attrs)
 		return -ENOMEM;
 
-	return simple_xattr_list(d_inode(dentry), READ_ONCE(attrs->xattrs),
-				 buf, size);
+	return simple_xattr_list(d_inode(dentry), &attrs->xattrs, buf, size);
 }
 
 static inline void set_default_inode_attr(struct inode *inode, umode_t mode)
@@ -297,23 +296,17 @@ int kernfs_xattr_get(struct kernfs_node *kn, const char *name,
 		     void *value, size_t size)
 {
 	struct kernfs_iattrs *attrs = kernfs_iattrs_noalloc(kn);
-	struct simple_xattrs *xattrs;
 
 	if (!attrs)
 		return -ENODATA;
 
-	xattrs = READ_ONCE(attrs->xattrs);
-	if (!xattrs)
-		return -ENODATA;
-
-	return simple_xattr_get(xattrs, name, value, size);
+	return simple_xattr_get(&attrs->xattrs, name, value, size);
 }
 
 int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
 		     const void *value, size_t size, int flags)
 {
 	struct simple_xattr *old_xattr;
-	struct simple_xattrs *xattrs;
 	struct kernfs_iattrs *attrs;
 
 	attrs = kernfs_iattrs(kn);
@@ -329,11 +322,7 @@ int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
 	 */
 	CLASS(kernfs_node_lock, lock)(kn);
 
-	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
-	if (IS_ERR_OR_NULL(xattrs))
-		return PTR_ERR(xattrs);
-
-	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&attrs->xattrs, name, value, size, flags);
 	if (IS_ERR(old_xattr))
 		return PTR_ERR(old_xattr);
 
@@ -371,7 +360,6 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 {
 	const char *full_name = xattr_full_name(handler, suffix);
 	struct kernfs_node *kn = inode->i_private;
-	struct simple_xattrs *xattrs;
 	struct kernfs_iattrs *attrs;
 
 	if (!(kernfs_root(kn)->flags & KERNFS_ROOT_SUPPORT_USER_XATTR))
@@ -384,11 +372,7 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 	/* See comment in kernfs_xattr_set() about locking. */
 	CLASS(kernfs_node_lock, lock)(kn);
 
-	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
-	if (IS_ERR_OR_NULL(xattrs))
-		return PTR_ERR(xattrs);
-
-	return simple_xattr_set_limited(xattrs, &attrs->xattr_limits,
+	return simple_xattr_set_limited(&attrs->xattrs, &attrs->xattr_limits,
 					full_name, value, size, flags);
 }
 
diff --git a/fs/pidfs.c b/fs/pidfs.c
index 1cce4f34a051..eb5105bddeca 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -196,12 +196,7 @@ static void pidfs_free_attr_work(struct work_struct *work)
 
 	head = llist_del_all(&pidfs_free_list);
 	llist_for_each_entry_safe(attr, next, head, pidfs_llist) {
-		struct simple_xattrs *xattrs = attr->xattrs;
-
-		if (xattrs) {
-			simple_xattrs_free(xattrs, NULL);
-			kfree(xattrs);
-		}
+		simple_xattrs_free(&attr->xattrs, NULL);
 		kfree(attr);
 	}
 }
@@ -815,14 +810,8 @@ static ssize_t pidfs_listxattr(struct dentry *dentry, char *buf, size_t size)
 {
 	struct inode *inode = d_inode(dentry);
 	struct pid *pid = inode->i_private;
-	struct pidfs_attr *attr = pid->attr;
-	struct simple_xattrs *xattrs;
-
-	xattrs = READ_ONCE(attr->xattrs);
-	if (!xattrs)
-		return 0;
 
-	return simple_xattr_list(inode, xattrs, buf, size);
+	return simple_xattr_list(inode, &pid->attr->xattrs, buf, size);
 }
 
 static const struct inode_operations pidfs_inode_operations = {
@@ -1057,16 +1046,9 @@ static int pidfs_xattr_get(const struct xattr_handler *handler,
 			   const char *suffix, void *value, size_t size)
 {
 	struct pid *pid = inode->i_private;
-	struct pidfs_attr *attr = pid->attr;
-	const char *name;
-	struct simple_xattrs *xattrs;
-
-	xattrs = READ_ONCE(attr->xattrs);
-	if (!xattrs)
-		return -ENODATA;
+	const char *name = xattr_full_name(handler, suffix);
 
-	name = xattr_full_name(handler, suffix);
-	return simple_xattr_get(xattrs, name, value, size);
+	return simple_xattr_get(&pid->attr->xattrs, name, value, size);
 }
 
 static int pidfs_xattr_set(const struct xattr_handler *handler,
@@ -1075,20 +1057,13 @@ static int pidfs_xattr_set(const struct xattr_handler *handler,
 			   const void *value, size_t size, int flags)
 {
 	struct pid *pid = inode->i_private;
-	struct pidfs_attr *attr = pid->attr;
-	const char *name;
-	struct simple_xattrs *xattrs;
+	const char *name = xattr_full_name(handler, suffix);
 	struct simple_xattr *old_xattr;
 
 	/* Ensure we're the only one to set @attr->xattrs. */
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
-	xattrs = simple_xattrs_lazy_alloc(&attr->xattrs, value, flags);
-	if (IS_ERR_OR_NULL(xattrs))
-		return PTR_ERR(xattrs);
-
-	name = xattr_full_name(handler, suffix);
-	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&pid->attr->xattrs, name, value, size, flags);
 	if (IS_ERR(old_xattr))
 		return PTR_ERR(old_xattr);
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 09ecbaaa1660..9ef7ad8a8f32 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1311,12 +1311,17 @@ static const struct rhashtable_params simple_xattr_params = {
  * Return: On success the length of the xattr value is returned. On error a
  * negative error code is returned.
  */
-int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
+int simple_xattr_get(struct simple_xattrs **xattrsp, const char *name,
 		     void *buffer, size_t size)
 {
+	struct simple_xattrs *xattrs;
 	struct simple_xattr *xattr;
 	int ret = -ENODATA;
 
+	xattrs = READ_ONCE(*xattrsp);
+	if (!xattrs)
+		return -ENODATA;
+
 	guard(rcu)();
 	xattr = rhashtable_lookup(&xattrs->ht, name, simple_xattr_params);
 	if (xattr) {
@@ -1331,6 +1336,9 @@ int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
 	return ret;
 }
 
+static struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
+						      const void *value, int flags);
+
 /**
  * simple_xattr_set - set an xattr object
  * @xattrs: the header of the xattr object
@@ -1362,13 +1370,18 @@ int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
  * Return: On success, the removed or replaced xattr is returned, to be freed
  * by the caller; or NULL if none. On failure a negative error code is returned.
  */
-struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,
+struct simple_xattr *simple_xattr_set(struct simple_xattrs **xattrsp,
 				      const char *name, const void *value,
 				      size_t size, int flags)
 {
+	struct simple_xattrs *xattrs;
 	struct simple_xattr *old_xattr = NULL;
 	int err;
 
+	xattrs = simple_xattrs_lazy_alloc(xattrsp, value, flags);
+	if (IS_ERR_OR_NULL(xattrs))
+		return ERR_CAST(xattrs);
+
 	CLASS(simple_xattr, new_xattr)(value, size);
 	if (IS_ERR(new_xattr))
 		return new_xattr;
@@ -1467,7 +1480,7 @@ static inline int simple_xattr_limits_inc(struct simple_xattr_limits *limits,
  * Return: On success zero is returned. On failure a negative error code is
  * returned.
  */
-int simple_xattr_set_limited(struct simple_xattrs *xattrs,
+int simple_xattr_set_limited(struct simple_xattrs **xattrs,
 			     struct simple_xattr_limits *limits,
 			     const char *name, const void *value,
 			     size_t size, int flags)
@@ -1527,10 +1540,11 @@ static bool xattr_is_maclabel(const char *name)
  * Return: On success the required size or the size of the copied xattrs is
  * returned. On error a negative error code is returned.
  */
-ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
+ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs **xattrsp,
 			  char *buffer, size_t size)
 {
 	bool trusted = ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
+	struct simple_xattrs *xattrs;
 	struct rhashtable_iter iter;
 	struct simple_xattr *xattr;
 	ssize_t remaining_size = size;
@@ -1552,6 +1566,7 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 	remaining_size -= err;
 	err = 0;
 
+	xattrs = READ_ONCE(*xattrsp);
 	if (!xattrs)
 		return size - remaining_size;
 
@@ -1597,9 +1612,15 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
  * Return: On success zero is returned. On failure a negative error code is
  * returned.
  */
-int simple_xattr_add(struct simple_xattrs *xattrs,
+int simple_xattr_add(struct simple_xattrs **xattrsp,
 		     struct simple_xattr *new_xattr)
 {
+	struct simple_xattrs *xattrs;
+
+	xattrs = simple_xattrs_lazy_alloc(xattrsp, new_xattr->value, 0);
+	if (IS_ERR(xattrs))
+		return PTR_ERR(xattrs);
+
 	return rhashtable_insert_fast(&xattrs->ht, &new_xattr->hash_node,
 				      simple_xattr_params);
 }
@@ -1629,7 +1650,7 @@ int simple_xattrs_init(struct simple_xattrs *xattrs)
  * Return: On success a new simple_xattrs is returned. On failure an
  * ERR_PTR is returned.
  */
-struct simple_xattrs *simple_xattrs_alloc(void)
+static struct simple_xattrs *simple_xattrs_alloc(void)
 {
 	struct simple_xattrs *xattrs __free(kfree) = NULL;
 	int ret;
@@ -1661,8 +1682,8 @@ struct simple_xattrs *simple_xattrs_alloc(void)
  * check with IS_ERR_OR_NULL() and propagate with PTR_ERR() which
  * correctly returns 0 for the NULL no-op case.
  */
-struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
-					       const void *value, int flags)
+static struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
+						      const void *value, int flags)
 {
 	struct simple_xattrs *xattrs;
 
@@ -1697,12 +1718,19 @@ static void simple_xattr_ht_free(void *ptr, void *arg)
  * Destroy all xattrs in @xattr. When this is called no one can hold a
  * reference to any of the xattrs anymore.
  */
-void simple_xattrs_free(struct simple_xattrs *xattrs, size_t *freed_space)
+void simple_xattrs_free(struct simple_xattrs **xattrsp, size_t *freed_space)
 {
+	struct simple_xattrs *xattrs = *xattrsp;
+
 	might_sleep();
 
+	if (!xattrs)
+		return;
+
 	if (freed_space)
 		*freed_space = 0;
 	rhashtable_free_and_destroy(&xattrs->ht, simple_xattr_ht_free,
 				    freed_space);
+	kfree(xattrs);
+	*xattrsp = NULL;
 }
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 8b6601367eae..ded446c1ef81 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -133,26 +133,23 @@ static inline void simple_xattr_limits_init(struct simple_xattr_limits *limits)
 }
 
 int simple_xattrs_init(struct simple_xattrs *xattrs);
-struct simple_xattrs *simple_xattrs_alloc(void);
-struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
-					       const void *value, int flags);
-void simple_xattrs_free(struct simple_xattrs *xattrs, size_t *freed_space);
+void simple_xattrs_free(struct simple_xattrs **xattrs, size_t *freed_space);
 size_t simple_xattr_space(const char *name, size_t size);
 struct simple_xattr *simple_xattr_alloc(const void *value, size_t size);
 void simple_xattr_free(struct simple_xattr *xattr);
 void simple_xattr_free_rcu(struct simple_xattr *xattr);
-int simple_xattr_get(struct simple_xattrs *xattrs, const char *name,
+int simple_xattr_get(struct simple_xattrs **xattrs, const char *name,
 		     void *buffer, size_t size);
-struct simple_xattr *simple_xattr_set(struct simple_xattrs *xattrs,
+struct simple_xattr *simple_xattr_set(struct simple_xattrs **xattrs,
 				      const char *name, const void *value,
 				      size_t size, int flags);
-int simple_xattr_set_limited(struct simple_xattrs *xattrs,
+int simple_xattr_set_limited(struct simple_xattrs **xattrs,
 			     struct simple_xattr_limits *limits,
 			     const char *name, const void *value,
 			     size_t size, int flags);
-ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
+ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs **xattrs,
 			  char *buffer, size_t size);
-int simple_xattr_add(struct simple_xattrs *xattrs,
+int simple_xattr_add(struct simple_xattrs **xattrs,
 		     struct simple_xattr *new_xattr);
 int xattr_list_one(char **buffer, ssize_t *remaining_size, const char *name);
 
@@ -162,10 +159,4 @@ DEFINE_CLASS(simple_xattr,
 	     simple_xattr_alloc(value, size),
 	     const void *value, size_t size)
 
-DEFINE_CLASS(simple_xattrs,
-            struct simple_xattrs *,
-            if (!IS_ERR_OR_NULL(_T)) { simple_xattrs_free(_T, NULL); kfree(_T); },
-            simple_xattrs_alloc(),
-            void)
-
 #endif	/* _LINUX_XATTR_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index c7897570fc9f..cf4ee9f41191 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1425,10 +1425,8 @@ static void shmem_evict_inode(struct inode *inode)
 		}
 	}
 
-	if (info->xattrs) {
-		simple_xattrs_free(info->xattrs, sbinfo->max_inodes ? &freed : NULL);
-		kfree(info->xattrs);
-	}
+	simple_xattrs_free(&info->xattrs, sbinfo->max_inodes ? &freed : NULL);
+
 	shmem_free_inode(inode->i_sb, freed);
 	WARN_ON(inode->i_blocks);
 	clear_inode(inode);
@@ -4233,10 +4231,6 @@ static int shmem_initxattrs(struct inode *inode,
 	const struct xattr *xattr;
 	size_t ispace = 0;
 
-	CLASS(simple_xattrs, xattrs)();
-	if (IS_ERR(xattrs))
-		return PTR_ERR(xattrs);
-
 	if (sbinfo->max_inodes) {
 		for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 			ispace += simple_xattr_space(xattr->name,
@@ -4264,8 +4258,11 @@ static int shmem_initxattrs(struct inode *inode,
 		if (!new_xattr->name)
 			break;
 
-		if (simple_xattr_add(xattrs, new_xattr))
+		if (simple_xattr_add(&info->xattrs, new_xattr))
 			break;
+
+		if (sbinfo->max_inodes)
+			ispace -= simple_xattr_space(new_xattr->name, new_xattr->size);
 		retain_and_null_ptr(new_xattr);
 	}
 
@@ -4277,8 +4274,8 @@ static int shmem_initxattrs(struct inode *inode,
 		}
 		return -ENOMEM;
 	}
+	WARN_ON(ispace);
 
-	smp_store_release(&info->xattrs, no_free_ptr(xattrs));
 	return 0;
 }
 
@@ -4287,14 +4284,9 @@ static int shmem_xattr_handler_get(const struct xattr_handler *handler,
 				   const char *name, void *buffer, size_t size)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct simple_xattrs *xattrs;
-
-	xattrs = READ_ONCE(info->xattrs);
-	if (!xattrs)
-		return -ENODATA;
 
 	name = xattr_full_name(handler, name);
-	return simple_xattr_get(xattrs, name, buffer, size);
+	return simple_xattr_get(&info->xattrs, name, buffer, size);
 }
 
 static int shmem_xattr_handler_set(const struct xattr_handler *handler,
@@ -4305,16 +4297,11 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-	struct simple_xattrs *xattrs;
 	struct simple_xattr *old_xattr;
 	size_t ispace = 0;
 
 	name = xattr_full_name(handler, name);
 
-	xattrs = simple_xattrs_lazy_alloc(&info->xattrs, value, flags);
-	if (IS_ERR_OR_NULL(xattrs))
-		return PTR_ERR(xattrs);
-
 	if (value && sbinfo->max_inodes) {
 		ispace = simple_xattr_space(name, size);
 		raw_spin_lock(&sbinfo->stat_lock);
@@ -4327,7 +4314,7 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
 			return -ENOSPC;
 	}
 
-	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&info->xattrs, name, value, size, flags);
 	if (!IS_ERR(old_xattr)) {
 		ispace = 0;
 		if (old_xattr && sbinfo->max_inodes)
@@ -4375,8 +4362,7 @@ static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
 	struct shmem_inode_info *info = SHMEM_I(d_inode(dentry));
 
-	return simple_xattr_list(d_inode(dentry), READ_ONCE(info->xattrs),
-				 buffer, size);
+	return simple_xattr_list(d_inode(dentry), &info->xattrs, buffer, size);
 }
 #endif /* CONFIG_TMPFS_XATTR */
 
diff --git a/net/socket.c b/net/socket.c
index 22a412fdec07..d3597c858345 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -347,12 +347,8 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
 static void sock_evict_inode(struct inode *inode)
 {
 	struct sockfs_inode *si = SOCKFS_I(inode);
-	struct simple_xattrs *xattrs = si->xattrs;
 
-	if (xattrs) {
-		simple_xattrs_free(xattrs, NULL);
-		kfree(xattrs);
-	}
+	simple_xattrs_free(&si->xattrs, NULL);
 	clear_inode(inode);
 }
 
@@ -443,13 +439,9 @@ static int sockfs_user_xattr_get(const struct xattr_handler *handler,
 				 const char *suffix, void *value, size_t size)
 {
 	const char *name = xattr_full_name(handler, suffix);
-	struct simple_xattrs *xattrs;
-
-	xattrs = READ_ONCE(SOCKFS_I(inode)->xattrs);
-	if (!xattrs)
-		return -ENODATA;
+	struct sockfs_inode *si = SOCKFS_I(inode);
 
-	return simple_xattr_get(xattrs, name, value, size);
+	return simple_xattr_get(&si->xattrs, name, value, size);
 }
 
 static int sockfs_user_xattr_set(const struct xattr_handler *handler,
@@ -460,13 +452,8 @@ static int sockfs_user_xattr_set(const struct xattr_handler *handler,
 {
 	const char *name = xattr_full_name(handler, suffix);
 	struct sockfs_inode *si = SOCKFS_I(inode);
-	struct simple_xattrs *xattrs;
-
-	xattrs = simple_xattrs_lazy_alloc(&si->xattrs, value, flags);
-	if (IS_ERR_OR_NULL(xattrs))
-		return PTR_ERR(xattrs);
 
-	return simple_xattr_set_limited(xattrs, &si->xattr_limits,
+	return simple_xattr_set_limited(&si->xattrs, &si->xattr_limits,
 					name, value, size, flags);
 }
 
@@ -635,8 +622,7 @@ static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 	struct sockfs_inode *si = SOCKFS_I(d_inode(dentry));
 	ssize_t len, used;
 
-	len = simple_xattr_list(d_inode(dentry), READ_ONCE(si->xattrs),
-				buffer, size);
+	len = simple_xattr_list(d_inode(dentry), &si->xattrs, buffer, size);
 	if (len < 0)
 		return len;
 
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E4E8CD6E79
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287466B008C; Fri,  5 Jun 2026 08:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239556B0092; Fri,  5 Jun 2026 08:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B506B0095; Fri,  5 Jun 2026 08:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4B526B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:33:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 868A7A0926
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:33:44 +0000 (UTC)
X-FDA: 84845800368.15.2791014
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 478B04000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:33:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XdDvE3Y4;
	spf=pass (imf01.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780662822;
	b=y1SadC+p0QabJLTLhDAYxAz1dSg8NOGPhHI+pn3KXAFTx8KMXcc6Z/gtOpTGuyL0vSTNc5
	ZZtbx5iQ5N2HyMv0RrXutZWlNaV+T1HEuS8UkyCoyz7W4j959aVXYox/k+43kRsX+BiTtl
	GThBdg96uBijTBNE/UozK6JOYHfqS5o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XdDvE3Y4;
	spf=pass (imf01.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780662822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMCycfkezZGxdvWXjAVekBGYpHl8hvUubSW802naxEE=;
	b=bTFBITbzfQD8eCw4Mkx6+OCHi8nvFygfqVHJIFfisNWKes69n49apQWzfQzXGOlILVhYGF
	ezKCTU9exin/oFEoyD20sv+CfmJpmX0bVv1S/15RU02D9ZYKaiEyIy+FL0N6nqzzz2z/Xw
	eS4JFesEPhbYn4D41lxnxCFFx+tKn2s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780662821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RMCycfkezZGxdvWXjAVekBGYpHl8hvUubSW802naxEE=;
	b=XdDvE3Y4KUQzhWH7Oypxp+DDhgYc379kPg/GImRq9UjuIVwcvcmMuuBCZzrcnL/L8YLDvr
	RkYbbJg3wQMuKg1Nzy0YiUjBs0RoKnM9ifpdzjd6HWEv21KywF1R5YAVsTZI4aTmQKKbMv
	jPAfaGSoJquAw1y+EJFiz4HES53EXtc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-FnOrI740Pyan_u0gxe-Lqg-1; Fri, 05 Jun 2026 08:33:39 -0400
X-MC-Unique: FnOrI740Pyan_u0gxe-Lqg-1
X-Mimecast-MFC-AGG-ID: FnOrI740Pyan_u0gxe-Lqg_1780662818
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45ef6417092so1506856f8f.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 05:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780662818; x=1781267618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RMCycfkezZGxdvWXjAVekBGYpHl8hvUubSW802naxEE=;
        b=fYZs3Aif15x6v/i7ZFMy/zd+4xWiqkBULkReqCUaSwycI1ldr/tXflIdRtX9vEGARC
         Y7q/zRGNGmzEifQiYI8v4hwy8AG7lYnDjbgTLPgCfi9v6whgbrPRbYlGb4+uGKtwCVZh
         U0gXKXM1BJsglbFGJ7QZncROQoTh16aDlry2XAStgLPa9W2JBPYoQE8JtYhMNho3/GY9
         ffkEOSpHSDHYzse2S6ghQotYaEqKV7jaEx+7fJIBm4C4ePFM8nsjMe1TNLoWsxJ9Fbpt
         m/PhzAFVMjKslCS4tzWOjt3Qh30J3wiFCp1+tyjqtq3manzHB7peUfpKmomnksJOGIHG
         6eLA==
X-Gm-Message-State: AOJu0YxTavkeTXnNdIkG0HfvmDfMkGm+nYIZ9v0NuUVxdwsoUkIB+/oY
	HGIxlICHMGgEmREDCDXEnN1v4VzfB6gQjLGEYXcpR3K1NDqT4pSYsHceMmv9MWzjziwHskFaipP
	aS1Amecu5RfknW8xOPeB0ryBfyYtbus1CZN5hEs7GIkvzQoJ+1V19Nd6W7Uqr
X-Gm-Gg: Acq92OGHmOHAMF5mhqZRlRfwoNGAZ2UKfhx87ku25jaOktooTTaOwqQ7JSjfU3t4myR
	xzcPOcubKQZZ5Re36Pb1q+sU4Q4qgmiO4Ce8f30ObUrvxO3ZJ7XeW5VWw6PxEcVzXKHdB4B8BBN
	lI8Pdfq78YpPOr7WsZ5j30dDRGqlPmHfpmkyDDHcAtWtNloVnD2ygP/ZcJNWBiqjUuwoqoYgqN2
	AmWkEqU7UemKixgjW0W5z3FX4aivqTrXsALrlsY0abfJpamAbJFMCzQDA3Vi8PLCHbTGzLbIggt
	7iT4ePpu842XEdU+4iqnH/oHAJl9WJFxLg1AxICSk0lVu5cBYZ0s1ctdQ8TPg4zGWUa+EIRWpVU
	1//a2MwFM6z3rN+6liU9EUsWpjEUjsXOWn/0DoTW2w5Gys59djUyyCnWSeqX2FDFOwHVFia9Wtm
	eSwZMHcg==
X-Received: by 2002:a05:6000:25c4:b0:43d:7c6c:a0dd with SMTP id ffacd0b85a97d-460306226c3mr6037478f8f.35.1780662817864;
        Fri, 05 Jun 2026 05:33:37 -0700 (PDT)
X-Received: by 2002:a05:6000:25c4:b0:43d:7c6c:a0dd with SMTP id ffacd0b85a97d-460306226c3mr6037405f8f.35.1780662817309;
        Fri, 05 Jun 2026 05:33:37 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-1-92.pool.digikabel.hu. [84.236.1.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda3651sm12702780f8f.32.2026.06.05.05.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 05:33:36 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v3 3/4] simple_xattr: change interface to pass struct simple_xattrs **
Date: Fri,  5 Jun 2026 14:33:28 +0200
Message-ID: <20260605123331.2621677-4-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605123331.2621677-1-mszeredi@redhat.com>
References: <20260605123331.2621677-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dKWRwxJJW2S0F1z0OLjZzBZxSgsLT8ZUAvI1v5wHHI8_1780662818
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 478B04000E
X-Rspam-User: 
X-Stat-Signature: dfbzd3tfj5ph7accu3gjfyhaoa8bs4gj
X-HE-Tag: 1780662822-775305
X-HE-Meta: U2FsdGVkX1+qhQWysx/cAxmC6usbDB6PLTHK/W7UzJQG4gD4VI+mDizVOpI7183ZlNDtl3he400o7rCc9AG1uQC0KrYS2nbTMxwB1CajagF/Zc80aZYaPe3f9zJtj8FTUsEV4/Fu0gP9/pwiJygyMLhIYvgVPt6XTwzs0U6OlXdEp5YUVWXXtS57BMt1X6mdyOyA0Rk3cHs40LIWdT55pXNM1GjOgJTZni0gXyGTvnjDtyk+lkfmEjY2kOro8zFJ/sM4RTHDlq0UWyr9DMMQWulDFe1WOgSk/0y2VWKHjjG9G1BHbe/4OS0JVNIDU/BH5Q7Y2J1YX+ZU3CLLMpFHMuTM50oMsYFiOELkjBPCBCSMNRvII1x9syFWvmaEM9MmoFY4PHVFLt1eFWyS4FHuM7KwPAy7mU+/Ehg+1bLhHqEC/ZwIM9pTTaGGgBqOh2g6uU2EJPlGoLd/Y5e5DX6xOTgha8OBVKeHOgssniEsByLA0U60lB8BwRJkvilFZqzXYWT4VUKhnPGbpMZpua1lkwMywQbH5BsPQ1Ie9bjB5iuUD87xmHoOGm8yVKxw9pSMcyNcIl5Z9CKvLnHNuEVlOxJSMFNR/HjaVHOPEIlNfTAt6CMLCpv0Vfh0exBDAMiZ0WoDZQplmSR0sJw/Cc6rQXn1VN2aX51ZcAI4T8D0hxs2RYuufz+BtwlmAw7NU89eZiPdaHVT6adSWg8e5RQZK42jwOyCjEPsT4QyvpgPozGW7WGtZSo+rCAGOsTRaW3mtRhFaicWgKgUwAoQbZYsdhL2UWYBSQsdbXAArECMFh5koyTXTVyMfMvJ4AjuTH5TpNcMIocCfTl00tW5Ih8orT7vgwNCiB1muvLp9uMiuF21YbcpBYjEG4P8qAAX03q0XloG+jZuZ0jAMHJjPvHiWvYR6GmuDWdBoQkajDGn6sCQQuxHFLZ4KX10RtOZsoqldWWgWQy5d+wDUBCvB8+
 0MzEkrAz
 d7Ey+ALwQn3JOwBrK2AO1chbmZwN798PuipiwywCrPv9Oba6oLVDBbpJ1JknRQxhFpkJ0uXqy0Q7LrDhDP2s5ANWjIiIMkmGLcjBL8ylz2OQiyqxPnpvucPHPzuZiagI9tX8fVA3vwh6rUESbTwZV+XvzQkmCCcfTmJ7UZd+uUpwCUzDhFV1V/WN3pmf+shFBkzUbtA3WLle0iFqPZtZn+TU05pPSBWkD4vqTBgUmAArU5449/o24eqL3f6fBwWVESaQtz9NKLPo7TGUTz05IhweUMgQHVYij8pzLY6NHo7fmnWZ2RQOfS6KvT5BXc839OpFlUmtZyaSHvxbxQeu205CMdMXKOXOPiQQe3luPoaI3dA2TSVu8ltZrGg==
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
 mm/shmem.c            | 33 +++++++++----------------------
 net/socket.c          | 24 +++++-----------------
 7 files changed, 70 insertions(+), 127 deletions(-)

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
index c7897570fc9f..9111d7efee9c 100644
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
@@ -4264,8 +4258,10 @@ static int shmem_initxattrs(struct inode *inode,
 		if (!new_xattr->name)
 			break;
 
-		if (simple_xattr_add(xattrs, new_xattr))
+		if (simple_xattr_add(&info->xattrs, new_xattr))
 			break;
+
+		ispace -= simple_xattr_space(new_xattr->name, new_xattr->size);
 		retain_and_null_ptr(new_xattr);
 	}
 
@@ -4277,8 +4273,8 @@ static int shmem_initxattrs(struct inode *inode,
 		}
 		return -ENOMEM;
 	}
+	WARN_ON(ispace);
 
-	smp_store_release(&info->xattrs, no_free_ptr(xattrs));
 	return 0;
 }
 
@@ -4287,14 +4283,9 @@ static int shmem_xattr_handler_get(const struct xattr_handler *handler,
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
@@ -4305,16 +4296,11 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
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
@@ -4327,7 +4313,7 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
 			return -ENOSPC;
 	}
 
-	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&info->xattrs, name, value, size, flags);
 	if (!IS_ERR(old_xattr)) {
 		ispace = 0;
 		if (old_xattr && sbinfo->max_inodes)
@@ -4375,8 +4361,7 @@ static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
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



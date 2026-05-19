Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E9E4CD4F52
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA366B0088; Tue, 19 May 2026 04:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91186B008C; Tue, 19 May 2026 04:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59B86B0092; Tue, 19 May 2026 04:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A099A6B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:13:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EA8114022D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:13:38 +0000 (UTC)
X-FDA: 84783455316.29.BAD62A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB993C000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:13:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c0uF1tKM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779178416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HtAA+X9/Ge/BthibqzJEwtAdlF34UfbOedEu4CxVLpw=;
	b=7svhdX+KGZVD2U+LTlhl/dmmZFfnST+J+L6Anq60xV1qyMEsbfhavuvqmuGWz/ywH4TY3p
	2F1/osRe8+5+TvbWE4DBbuUh8FXALwjhKE37t6o/z6hLQMTtqT6sNdSSQ/XAKDLN6NG+4X
	dwzs98JlynyvExCC3v4t/GFdTD5o7Zg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779178416; a=rsa-sha256;
	cv=none;
	b=t45CODcV7l5691LeSKQUNPEvkjyEWexqS4BpxnkOZQ7jxrPBULCSInhmTnforTEmq8JwK3
	5HjiSf5Fh2j2/gUTElpJDgCAjtEf+j3jhl5Mc8l2MzUreYqkpPT2rFpx/nrlSxd33EP7LL
	Svm1y/3kBowOhhOv9BnCSxq/8uiv1qU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c0uF1tKM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779178415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HtAA+X9/Ge/BthibqzJEwtAdlF34UfbOedEu4CxVLpw=;
	b=c0uF1tKMNXpShdLNppoZRzlzewYLerCEvNa+XPlswYOVNar0zmTHLzjrEZdxz1yabvs/Gc
	U8JY/fsH4PDNK6r59cZKavxrkdELVU/afYL/R4TbcGkGwZe+kJb/6Hhm5+TlXGHQOVa+y+
	gcZdYIPemJuZZes6nNaC+wwQBf0G2+Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-QmXZcwoCNtuUBTRZwXssDA-1; Tue, 19 May 2026 04:13:33 -0400
X-MC-Unique: QmXZcwoCNtuUBTRZwXssDA-1
X-Mimecast-MFC-AGG-ID: QmXZcwoCNtuUBTRZwXssDA_1779178412
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44a3aee3813so1439213f8f.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 01:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779178412; x=1779783212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HtAA+X9/Ge/BthibqzJEwtAdlF34UfbOedEu4CxVLpw=;
        b=Pdg/Ugydq9YBhYsczJiO/MJIxv/U8e7YExpT0Y9jSH/AkWOE9BL1lJqoBOdOZy6mzg
         bxsYtfmpDdG/9X5UsCMrE037kYTsB0u8WqwyWf2iIa/RMalsfHdvEWVshhjSPe3/myMc
         QLmV7oqrv9Gj7x2S2pRXJYCMzoLs5xIqfimn3EKI/uhzcm11SoEKrDVCvAWJSkntKOq6
         AnrD7HGy94Z5twHvX3G7N6OXJL5KSwp4UlGfCnvfhT07F5Zn4vJtNo+HVhVUhfSX9hAQ
         0kfeOB/s+jDzxAzKGjmk9pj02ZEkNRC0MPYfaPNLPxi6cP42MiDpCay2/045+xLXRIoE
         uVgw==
X-Gm-Message-State: AOJu0YynFzBsIENyCsED0jXRdyB2ZRKTcuHQjJYLLpvfEBZdY8seAsk2
	7QFzMg7lp/ybutY97d0iFu4rugXOTRLopf12qcfe9S5DumD16S8A0EXsZOUUk64HRKBg7odW+tK
	HM35ugEAIvZns2wU776rjcu9PZUdKZiqYjpQXDBZDjsXrLlR6r4EM
X-Gm-Gg: Acq92OEIczV4TVoVlSw59SAMHEfwLRgJ9/TgJmnx4sgxrfWKJmD+O2eNNEmEAyXbC67
	4TvDYSs+AejOsLCF2nNzPhjbSmt6JSXJ4EJydfSJw459+vurMYHZ7p0Wl6kceGQnQwM6HCCgfMV
	Yzaov/DGSFnFzTrf2CpCkEvG9e5x5baM0uL9xPMFa5wBcHOVJu2kMxNNOhHOYKGd/2tx0E7S1AC
	ykqHueqaL4oWh1HUdMmbewNcjsaTRjxGGIn0nN7XRNbmAT+9/JWMG/y4ggH2xBRGQbqyMm3DCqY
	mVQXqUbJDFk1iYdl2YIRzafeLiXs1W6NXasAGxbLdHuyYv1VpeD5NSDX153maoUOkHE2XelAvXO
	zYg7zNRNlzTxQ/YgycJvNQ15QUNhcn6kEJd52bMifYwsyIOa79hEi0elT0doUvPh/tyNXu/GI10
	oz
X-Received: by 2002:a05:6000:1ac7:b0:43d:762e:76c6 with SMTP id ffacd0b85a97d-45e5c35da8fmr29620033f8f.7.1779178412298;
        Tue, 19 May 2026 01:13:32 -0700 (PDT)
X-Received: by 2002:a05:6000:1ac7:b0:43d:762e:76c6 with SMTP id ffacd0b85a97d-45e5c35da8fmr29619632f8f.7.1779178408291;
        Tue, 19 May 2026 01:13:28 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (85-67-173-121.pool.digikabel.hu. [85.67.173.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe2464sm45189485f8f.32.2026.05.19.01.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 01:13:27 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 2/3] simple_xattr: change interface to pass struct simple_xattrs **
Date: Tue, 19 May 2026 10:13:22 +0200
Message-ID: <20260519081324.979769-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519081324.979769-1-mszeredi@redhat.com>
References: <20260519081324.979769-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R8aGJ3KOFQKaknuzxlJGNTHObwEzCM7kV3sxqxWq_II_1779178412
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB993C000B
X-Stat-Signature: c6tnqq8zwix54qkmxj65cfjaefpqb1m3
X-Rspam-User: 
X-HE-Tag: 1779178415-568109
X-HE-Meta: U2FsdGVkX1/+GRO3GF08X9sMZb5hpr1F+iOiMrTghSbI/Xzqm+NlmwH/zbisBp4ZhjL4VhkoODqdvd+2arN3WmcGq0xD8CZ9SL7LZKOnxK9QwSScm7nPFRsmVLsBEuMX8lYD6PPCDXW3chl1dQHcLQLBLkzjpCk/km2L6b2Qdta95py445O7ZwR+ejGOHBnTfSCKqlFaxGor6jNXCcUaiuoBaAO0mJbx6QFRCDP+80JWoVcA1ft/SH+bfarpfZR4YtEhqVuMFavDkUR7fm4kZhmmmwl7XgX8CRN6LhmGxgyx1BfpJXC/NwHt0O6OioQY3WLXjaazmPCZXT13ksUlOSCAyB5CgFJJFzDIr+8J4PuFdRLWNdjjP2hZRODerNNzWwe00UM1nHStfMtO8vVpvbdnOo3dRWrUvpXGDGRiFRAkWqdv1GXUIKUEqOcIwZQkkhKX4Zf5XGlQ+w0fL5bgNKsvyeMcb1oxpWvt4Wuy5MlG7bcQ38gcc07VIG2m0XH874xanXbg3CBEg2e8PtBsigSj3NF/rC4/Gu4CpfsVdXlli16SeN6fGl1f2x1+00FJXO9GXUbGRarEO0N66ddXa3wYKaxm/HWaE3Uao+DUy6BqpB5Ds7cSajEwYl31EtPCIn8UR+CVgwJClhmi/3fEDzjLy0GtDaQNzOgvVZ2dIqaOm50fT1NL9ITuAqtkk/kIV6s4nJheAv3jlwBaZb4W71jDAHyJKST/9+eMOWvuO+z0Fu9wVRJqW3EcMeYZfA6u8WONQ3598JbH+lbEQ45by/cvce4SzzZPZF8lQfLybLMDTC22ZLyOKvTo2w0N/xwwqnYbEG/vccYy3MmBHh1N2l7b6hKmNm2fwUaSVKTsBkgjXzMRBAyISXuUO3DrpjkGY1RfjHCLiarpLKsyJPU/cHMZmSZPbZCnFW10vqP5Kms4sjUwRSAj7qKDK68RANroyiRjaEtFTP3WkJOkTOE
 rrSTcf4k
 1X0eCWWvJdQRF5i+NBWciqQ21Z+3g2qlxH3ChBRvQljqFpeLPBXnnux2/3PHqzZ8sPPdMfqLE9CV9tfg+Iu9YwAHqxP0hRrE4LsuiyjgkWgZg08RBKiNAI0C0EKw3Ze30uHyBbMPlVbeWzq1FgwdA8iZlG8KuRGDBBNcWl3BUq17eFl/YZRW5JG7WF2IVFbsdWX2yuoPMamBMI3d5q9dPIvuUgFo+X0PPUZ8IJ7dilaQ9ZC9zkz+i75rSDqAuL8y0lF+WIvYUyI8SDZD0/MSbKPfqYUtpTnBTgp/M39IM4fXce5pMrVSncTm00lEP7tzIwlFjabwkCtikNvi4/7yrln45mhPIxqZEhsofxByYCkoOG65m9s6QxZJ0Lw==
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

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/kernfs/dir.c       | 12 +++--------
 fs/kernfs/inode.c     | 24 ++++------------------
 fs/pidfs.c            | 37 ++++++----------------------------
 fs/xattr.c            | 46 ++++++++++++++++++++++++++++++++++---------
 include/linux/xattr.h | 21 ++++++--------------
 mm/shmem.c            | 30 ++++++----------------------
 net/socket.c          | 24 +++++-----------------
 7 files changed, 67 insertions(+), 127 deletions(-)

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
index 38b28aa7cd02..65721b1b04f7 100644
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
@@ -297,34 +296,24 @@ int kernfs_xattr_get(struct kernfs_node *kn, const char *name,
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
 	if (!attrs)
 		return -ENOMEM;
 
-	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
-	if (IS_ERR_OR_NULL(xattrs))
-		return PTR_ERR(xattrs);
-
-	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&attrs->xattrs, name, value, size, flags);
 	if (IS_ERR(old_xattr))
 		return PTR_ERR(old_xattr);
 
@@ -362,7 +351,6 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 {
 	const char *full_name = xattr_full_name(handler, suffix);
 	struct kernfs_node *kn = inode->i_private;
-	struct simple_xattrs *xattrs;
 	struct kernfs_iattrs *attrs;
 
 	if (!(kernfs_root(kn)->flags & KERNFS_ROOT_SUPPORT_USER_XATTR))
@@ -372,11 +360,7 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 	if (!attrs)
 		return -ENOMEM;
 
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
index c7897570fc9f..9b401a58ac0e 100644
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
@@ -4264,7 +4258,7 @@ static int shmem_initxattrs(struct inode *inode,
 		if (!new_xattr->name)
 			break;
 
-		if (simple_xattr_add(xattrs, new_xattr))
+		if (simple_xattr_add(&info->xattrs, new_xattr))
 			break;
 		retain_and_null_ptr(new_xattr);
 	}
@@ -4278,7 +4272,6 @@ static int shmem_initxattrs(struct inode *inode,
 		return -ENOMEM;
 	}
 
-	smp_store_release(&info->xattrs, no_free_ptr(xattrs));
 	return 0;
 }
 
@@ -4287,14 +4280,9 @@ static int shmem_xattr_handler_get(const struct xattr_handler *handler,
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
@@ -4305,16 +4293,11 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
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
@@ -4327,7 +4310,7 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
 			return -ENOSPC;
 	}
 
-	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&info->xattrs, name, value, size, flags);
 	if (!IS_ERR(old_xattr)) {
 		ispace = 0;
 		if (old_xattr && sbinfo->max_inodes)
@@ -4375,8 +4358,7 @@ static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58149CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5D96B0465; Mon,  1 Jun 2026 12:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAB36B0467; Mon,  1 Jun 2026 12:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2576B0468; Mon,  1 Jun 2026 12:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2D96B0465
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:25:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A1321A0722
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:05 +0000 (UTC)
X-FDA: 84831868170.26.20DCBDE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7B4810000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ErlPMHMB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780331103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QURtQruj3XONTD9rc1EbWds+Sy81dzAUYZtsasZjmVE=;
	b=bauIDcmdydGm6BwepQPKf6L2cs2OZqTEiP/iumJVqxxjlWEaj5b9Useo6fPcCxSg91+oHe
	4y2GNceMrgfGTKKvFsM4fz+KTmtcU7VzvqBDH60cbIspEY5Os+xsq6wbTciQ7A1dk538cZ
	rZRl+jwDoXXX/AqUbjF4AtyM1UtWF5k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ErlPMHMB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780331103;
	b=Rc75YYOlh0TA9PnnrKK57zEsWXuzyaKXWKQk6qMI0Slh/7XcTLJA82K8JGD6jdhC7ZwOPB
	6DZuAFLKiUNuS0Rfn63QQMqSH9MS6kIvm5LxzSjj+ZpvWc0hllN7QOpLMB2/vxyBL2fi5z
	DF77qAluf7NIxwtXaF8C49W7L9iTC24=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780331102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QURtQruj3XONTD9rc1EbWds+Sy81dzAUYZtsasZjmVE=;
	b=ErlPMHMByl5c80MsC+HkiQzgNaoWjOFdhvKIX+md2Zy08TOsIIOmgeq390WNqrskdrQTAT
	oefhpzhZm5N5ZTYDoVxiOtDokfqwiaOvwOIjuGOp8pyKXCbDTZwYuYlqEVFfvJprxAvKgb
	MHED35dfp+f4xWwONUylxFJg7prTgns=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-OGQPi2hZMxqzQZf-ZobzYw-1; Mon, 01 Jun 2026 12:25:00 -0400
X-MC-Unique: OGQPi2hZMxqzQZf-ZobzYw-1
X-Mimecast-MFC-AGG-ID: OGQPi2hZMxqzQZf-ZobzYw_1780331100
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45eee3f9f03so3635592f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780331100; x=1780935900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QURtQruj3XONTD9rc1EbWds+Sy81dzAUYZtsasZjmVE=;
        b=nvRMiquEJWIDwDQjSigFc1m8dDrNvYrxHUUuAI46+1pVgh+Ua7FMXWARZ64DDfW/3c
         Iq171CK+8UCCQOYxVdXmyC6uKxse8XCKJcoh2jRCYEy8B8tPtFjS0Jx9yhTzHC+zC2lc
         M4o2byma2DPF9hMGJiH28q6fHFwqkKJ6Y/L6wwsGGtJtqM6PdX/hKRuALaSwBRwQJcX5
         A90+eNsvv0TtBlZU/NW+I4bEuh55hKRHSZ7P1ipyOENbdF0nWVuKiABMXOPkSagX8DGY
         cYTOGAA4Rpa7Mub79XJuhNjgPUaudW676F7IegDF8o0Gd83KEW6kCKnUC24b++Ymfoof
         P7EQ==
X-Gm-Message-State: AOJu0YxhpcpH2ZukJwK6rp2Oo6QelO9as88r9SJ8kQkUszy/opYCzxAC
	lr59QDGcBDydIS7nBZx4zX+s6+wkre5fhHVT9lhm1zxTFaZ+4FKhkmkGvi+Wncb1CbbRsW1EJZY
	Ieto1duCGDN605EoZ/q8mgwjVAz79g0F4LAr7MbkHNgGaQFg4csAh
X-Gm-Gg: Acq92OHksnx+z6yw6ILyDuytD0p64u31YSZ7UF8biG48VcGNcAWnH5Lrb7l+ZjTkrmf
	Q5QCj6y4fKhZ0l+chRrNHr+FM2YtBsrRHs+qKzqWmLeW7BL9aMaWcp/lP5QBvrCxYzWWHFDh3xd
	SxG1JAZycTO26zZjODax4vstcVBzlWb0mS/v1w+PA7YYcvR5zMh++kwKpOfoayXckMdDsbE91/m
	es1plWs0xFRmzpfn1s5oxOqHtmycLE9auuDaBg6BdohskB5sFttkGTkD2QBbPaVTQQw9Td6QiQU
	xipyBsTLmFQEirbKSfMPNjFNtNykBhsSm/DV9ydFMz+DE5zmoxENijHNVqwT0aTbxHq+CefBVXQ
	VCTVO7AhsdHpIHu2NKwLfH2WwtQ19QsvJjWJy2cXke/0BNXIUy7GcqAjIbpbZxtP0RFi/Kecu31
	01F3Xha5VFV+I=
X-Received: by 2002:a5d:50ce:0:b0:45e:ec18:f207 with SMTP id ffacd0b85a97d-45ef6b58394mr18102071f8f.25.1780331099453;
        Mon, 01 Jun 2026 09:24:59 -0700 (PDT)
X-Received: by 2002:a5d:50ce:0:b0:45e:ec18:f207 with SMTP id ffacd0b85a97d-45ef6b58394mr18102014f8f.25.1780331098886;
        Mon, 01 Jun 2026 09:24:58 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (85-67-174-180.pool.digikabel.hu. [85.67.174.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef356b129sm33036213f8f.32.2026.06.01.09.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 09:24:58 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 2/3] simple_xattr: change interface to pass struct simple_xattrs **
Date: Mon,  1 Jun 2026 18:24:49 +0200
Message-ID: <20260601162454.2116375-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601162454.2116375-1-mszeredi@redhat.com>
References: <20260601162454.2116375-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KNXO--kNB8jB16N1YDzSX861hPNw-RlmssWnN2MzuW4_1780331100
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7B4810000A
X-Stat-Signature: 6annz5juakesuzs1n5qwfejc8jwdn1gp
X-HE-Tag: 1780331102-693263
X-HE-Meta: U2FsdGVkX1+rfvHGF0Qm9X1RWazL7+EQr+7PQgGFgBTkLicpHMeMh2S8TdWxfNw5agQplXMF5keUstjTX7j3wZWPu7dtIoi10H+uXhUBxuLABIFU+RmvAZGmk/dLdZaIvdcxzGQhbxeYqvy4usbqMMVDx9tR2LMgYZcm4sNHeCZ+zbWzlbW01bjQ1t3pGzM3N3hzUNoCqyjFKC3+ZJ5BvFrYhoicMPbe2pIwE12qyGfx4JgAVwpTgn3YBMi2tqIKjTxMDqLvJWiPm/UlpdKFLjIRJJ2/Xz4qmPRdNfjaDvqfzb7wdCEK7t3yZ7h6oATiLP6Z18N0VsBSd5D739tRmiSiNJX6cVqRY+CgED+Z43wur7l1b46Sw+QSu0f8uZENZwt3bqyd9A43bBsuUv2Z4Xhanm9GhjhLqY/JoG3KCOi2ugyX+xTWnVL66ageHBt0AuDCGWP9/XyOGSwLb7JIszzXLlViZHwp/3MDbAjyns3Lgt4iRktQsdBynu0icSsSTHzHdQ4vE6ochq0lUF0i1YiBaA540MGFwTnE3QcjA6wY/J5rOMIpPzGWzCv1sHZxLWPSYQzaHsYNJM6ZngOzZfQq+9ycJdcBJy0Mwnq/3kkboLBLEPyC8NFM4sulePF9CVgcGfJVUs2cCs5jIOGD5374SDfJXHzwHgFRgEA4x51JACuf+w3n+/HCkTGS/PbUy/o9AxYBriMgou/ymsoLgVzInVkNx4f3YbPqs6fj3zxQl5M5r3NxZN+uqW/oZDbeuF8ka2s+05u8Z7AB75FiTEYvSgRzH+YKHr+KnpDt1C/+S4LEmn3GAunX5FI6VlrhLufBGK/ujdT5KKqxsVzrciUpdGi+Nsq2TLevDPfYNmGEpW4FDR2fgf+dKzaG2ddRR/buQKNJ20lPb3jU8c80Qt88E3DoWrLzA9RI0ACwifC5lbkcTp3dB/4hT09M+Gt0w9Og+MjWGOPOq3Ss5KW
 Be7PyB4d
 nI4YQJsgC5m1h1tzpcc3uiMk3LQp55EKK20Gopq0RgWzlRcsCWtENAP63xpkYJh78liKa8Q/94VwX9hTaFa/CZ1UWXhjTDQzSarfAog4l8YODZw8aZXN6lyywJvYhmEurgzMieRZB2WR2nsBj5Q+Jf7d9cdZfS5rMti6DYqnLxpKaFE7j9iGL8abRNhB7ciCHnBwcxrCQPmhbleCKHR4df67CeCUfWkBGRtdJTiKDkCHj5AtTubxYoimY24/yLTUJRNn1MMYhR3AHnve+6J1ZDGsx9//dCRTSCp+Vd66C6/IpCWeHDMl2/BnKc0Jz3g0hrzX9opqRiaKm36EUTNGprKFQ/+8mzvBpJz2QRAPk76MVt6edmzqAXnzTig==
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

Fix by leaving accounting of ispace to inode destruction time.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/kernfs/dir.c       | 12 +++--------
 fs/kernfs/inode.c     | 24 ++++------------------
 fs/pidfs.c            | 37 ++++++----------------------------
 fs/xattr.c            | 46 ++++++++++++++++++++++++++++++++++---------
 include/linux/xattr.h | 21 ++++++--------------
 mm/shmem.c            | 46 ++++++++++---------------------------------
 net/socket.c          | 24 +++++-----------------
 7 files changed, 71 insertions(+), 139 deletions(-)

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
index c7897570fc9f..e6babf4a9377 100644
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
@@ -4257,28 +4251,19 @@ static int shmem_initxattrs(struct inode *inode,
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		CLASS(simple_xattr, new_xattr)(xattr->value, xattr->value_len);
 		if (IS_ERR(new_xattr))
-			break;
+			return -ENOMEM;
 
 		new_xattr->name = kasprintf(GFP_KERNEL_ACCOUNT,
 					XATTR_SECURITY_PREFIX "%s", xattr->name);
 		if (!new_xattr->name)
-			break;
+			return -ENOMEM;
 
-		if (simple_xattr_add(xattrs, new_xattr))
-			break;
-		retain_and_null_ptr(new_xattr);
-	}
+		if (simple_xattr_add(&info->xattrs, new_xattr))
+			return -ENOMEM;
 
-	if (xattr->name != NULL) {
-		if (ispace) {
-			raw_spin_lock(&sbinfo->stat_lock);
-			sbinfo->free_ispace += ispace;
-			raw_spin_unlock(&sbinfo->stat_lock);
-		}
-		return -ENOMEM;
+		retain_and_null_ptr(new_xattr);
 	}
 
-	smp_store_release(&info->xattrs, no_free_ptr(xattrs));
 	return 0;
 }
 
@@ -4287,14 +4272,9 @@ static int shmem_xattr_handler_get(const struct xattr_handler *handler,
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
@@ -4305,16 +4285,11 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
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
@@ -4327,7 +4302,7 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
 			return -ENOSPC;
 	}
 
-	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&info->xattrs, name, value, size, flags);
 	if (!IS_ERR(old_xattr)) {
 		ispace = 0;
 		if (old_xattr && sbinfo->max_inodes)
@@ -4375,8 +4350,7 @@ static ssize_t shmem_listxattr(struct dentry *dentry, char *buffer, size_t size)
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



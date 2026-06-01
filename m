Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA7FECD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6503D6B0467; Mon,  1 Jun 2026 12:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628196B0469; Mon,  1 Jun 2026 12:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519066B046A; Mon,  1 Jun 2026 12:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33E606B0467
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:25:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2F33A0251
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:06 +0000 (UTC)
X-FDA: 84831868212.12.79F646F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id B42B410000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ks5+6wzA;
	spf=pass (imf05.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780331104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9AtmdzFoMiUOZTmD+IfJIhxvSvAbfVKtLBsqc+JWu0=;
	b=vNnPWEVL/b4LCCQBoL6BsrfEJ0PeP5JBUtOEyNIODh5APNHSNE7pvxeTWKeHgQXSXMMz0y
	J/48GmxxDFUkRPAFBxSPQPWoWa6FpIYT19hpyoaOHKyekO/SXUHsPXj++8ehjyRiNSu+0V
	v7Eu+RTkdIY1BMkKaIJfE3arJAn8TpQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780331104;
	b=AevQRaXMpoFwM5DfzSMC4AknRR+EKWDE+O1OVHflU8Q69WxUWk4spaXJBJqR+q9aac4PAi
	PSXgS+Qb+bWesTwSZjoqHfyAuPrXSBhcQE50DmBUeI+KUXuK8MD/ZHqutiQRTIqXW3tU8P
	u/npnhhpCthHMHBthLttelQFmDK7JMM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ks5+6wzA;
	spf=pass (imf05.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780331104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p9AtmdzFoMiUOZTmD+IfJIhxvSvAbfVKtLBsqc+JWu0=;
	b=Ks5+6wzAg3MX21lhW5+nkgvjtIn+ots/9e6pMtHEYAXxE1GzWoq8IvNyU5vyH5KTZbM6vm
	sKR3MsItPQm1HG9Psj6PDI6VxZiDWzmvDkTGGx4clSxlxY0J4FhkczzXlYAev932KkYAvx
	0iPB6lNb5wnpdRxleeNz38PwZ6y46OE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-h16gp0rHMtOKy5IaGB5piw-1; Mon, 01 Jun 2026 12:25:02 -0400
X-MC-Unique: h16gp0rHMtOKy5IaGB5piw-1
X-Mimecast-MFC-AGG-ID: h16gp0rHMtOKy5IaGB5piw_1780331101
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso12342265e9.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780331101; x=1780935901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p9AtmdzFoMiUOZTmD+IfJIhxvSvAbfVKtLBsqc+JWu0=;
        b=rJbRtmH1zH9MYXfNgY01ifNG1F78kqgAUdVJQsqIavjdEzWh1BDM1vwOwLChj6IQF7
         Nxa+WAG9oj0+pIxlL9GW3eFglfIQtsYWlxMMtNUSl+ez7FFxXUjv3aOExAULSWz9Cb6n
         ++qwVTmAHU5CKCi/Orkk4ZuqddKfkmTo4DHvsFWwbXV4XIwYiSr3wP1Q1XH5mxRapJV4
         wb1TmJrGkB2ORjiLQBZDkkwYrbu3kN8B+vIQPNB2nesgp1almoiSALEYm167gVjbJg6m
         2wXj57QhB6P8e11ubSEzaYpz/MvumgtjGYIz8C5j3XQ5ljwrq1M2yhaUz+ACIRLbzPtj
         aLbw==
X-Gm-Message-State: AOJu0Yy/P+GkYcnof8XaEUQ4AonKTDfc310YnQo1LXTDrzNxtsUXN9ay
	WqYiL8e+nYgOe8fTRnZ5Dk9bocWfeiB6q+N4Gx2oUmQyjCNQpP+NvOIqST/EvXByvAjwCcwSHu8
	m+0bVuj5FPbit7nDMy3Uj9FcdugDZNqmFucNsrCBiMKSIO/k/2T4Eb10m7BMh
X-Gm-Gg: Acq92OGplhgVdwHaAXFe8d8PvkU+FignX9NgSz+FUI82L1dnZY2jonyBS5mhFtqB8TT
	KE8proav3oXbas0rPXXeSRtKK2+TF8UelnjBNRRHhCHbSpVZ+CqGrYwc/pBAqXOSKTwx+Rdqizj
	G0aZaWRsxXFew2TJCzKdOEcr98/JUFg60QMOf0qCafXfe1GJCU+6Ug/K2sJZ54kvyF0tzuIoq4L
	VYRLb6MQVmSoMD0BYk4BkHW0IGnABgOV6YnMXnQy8UAkfRNF+0UTuyT+huWIt2M6JPnf2Z07Sw1
	znTVxMBYb18mTCzYba/yuApeA9UJqFf6VKM7Z91eknyRJd+BM8EAZh5vCwqAwTG51ASXOEA61gx
	07qM7UnJHjq+sgrTJWpaFXOh7VHXvzDv9iTapC1j+lGzog97YQbJ5FnIh/wKAH4/Oke94XluCHy
	YlFZuPLYuRF6E=
X-Received: by 2002:a05:600c:16c4:b0:490:50eb:b753 with SMTP id 5b1f17b1804b1-490a294b7bdmr128692295e9.32.1780331101039;
        Mon, 01 Jun 2026 09:25:01 -0700 (PDT)
X-Received: by 2002:a05:600c:16c4:b0:490:50eb:b753 with SMTP id 5b1f17b1804b1-490a294b7bdmr128691665e9.32.1780331100358;
        Mon, 01 Jun 2026 09:25:00 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (85-67-174-180.pool.digikabel.hu. [85.67.174.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef356b129sm33036213f8f.32.2026.06.01.09.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 09:24:59 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 3/3] simpe_xattr: use per-sb cache
Date: Mon,  1 Jun 2026 18:24:50 +0200
Message-ID: <20260601162454.2116375-4-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601162454.2116375-1-mszeredi@redhat.com>
References: <20260601162454.2116375-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G5GA5gn8A_7oyRqEgCUL42S0AOHW3Tel1hgIn5lnTg4_1780331101
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B42B410000F
X-Stat-Signature: skn83mqb4kyfp3py399cwntijpniept3
X-HE-Tag: 1780331104-186751
X-HE-Meta: U2FsdGVkX18hW289IJvXRMhkGs/LO82ZzuDZdYVYxHvm7M8jVgQmOBKcX/MfS3dRSrGwZk2CBMsQ7d1lrzCJBk9LqlUV9zqCPqOUeFxbSIrpW9+e0SyaN95DZjUMVZGJgB8gwVaUIv5rxYVnV+SXabonuyfKdYo1iP9CSkwJJsY6fT1AxN+iONeMeSi31qd2Q8QgT4/mSZcz1RcJBAvSrDc+a0aiypJm+hTHmTVMNJ6fv0uNmGqWP0/B5+UOurEegbgTGY7S6HkGY6BlNWBE2d4HVm8l3IY9y1Ewd/9aLV6mSAeaYG420j91Bbn7ZwxijZEmhM8Nn8t+NLr6InmDIAEbNHaMetFZtDSkaMz4HyZ0BdAFM7VmuSL9HIwYD5Xdym8hfi7VqxX8C4k0nFLIOXz0ErboAShuy/EpnTlE6O9PgKYk6qUHilhNJppudEfqDd+Zwt4xC7WXwI4WptsWoTDgnIYR0OAoW/FNFRmIZ5fwXcHhrw/3WAERbiFo24rJfAMcjiAUY8Hjpq77V2MZway8/cJpUzld1UKyZjO8L8oEBVysdc9wNtPI1Pm3WCHVEwWuFXw077xNbWhA6DMRzZPYhlo09/51FYaUkL5kV0t5wv5+VsB6PFERJviAkYr4kOAGu3lvybg1PTZgBIaeL8TW4HyBSi37JdlhJTUSfR5/PAQdHXyIEoVMQgp0aF+RjS6RFUln/H7akFO/wrqVyAVuEiRRxkd5y4N1ZVivCo5DPYbi3wZYep/HNdusMQUSq85qJ0K8/lCixuUmPz4ST46KqP6DcfSoMwaxrBb61+bbdfESlwT7Hb+uSNtmTcMnP6tMR83bgKJfV6ZcsxvTRRHUnkt7jspOT5j4K6aD0SRntLTDJ+piw8OFXm085FF6v9AA9d537gO0d4gcwcZa//hn+54MvL7qXSQkOQmzyNXYIHJo40czOJON/yik5VNwuq5QoNA79nlvf4nre/q
 F0QxdcU+
 +qSAkHAEdBUI+8C68NAuTmTYJxFRU+kjXi7z48ToqxAiJ+Ra681dryq4ZTVdfvwLhbGJsQHcfSrUuCuncOEJOcSwLeeO90pZClPsI+1Yco2L2Mx0p+/qlEpPjRDQ5BLD6CR/U0YEmLMrPyanXFt6GSX8N7YFZ5qNof9VTRhUxiQG3pRGUYM9vR1cD5nBP2tEOgnQ4fL+UH4DhlShP14ij0BTkmilGUiwT0upfcLATxO5inBwAKjNjTiGYWWlkokapD2NuH5ze3mN/KJd4nvvmr//ynOkDAPbGIjHloGrJAsGN+ELwWGN2Lu94to24zH24UDiSFIqsHkyhk3wxg2J2Nfb7GyrJd0yo3V6/kK2LPCgiLhKVX75E/5K3yjokLAZMPKEKxhbjB8jxbYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the hash table to the super block to remove excessive overhead in case
of small number of xattrs per inode.

Add linked list to the inode, used for listxattr and eviction.  Listxattr
uses rcu protection to iterate the list of xattrs.

Before being made per-sb, lazy allocation was protected by inode lock.  Now
inode lock no longer provides sufficient exclusion, so use cmpxchg() to
ensure atomicity.

Though I haven't found a description of this pattern, after some research
it seems that cmpxchg_release() and READ_ONCE() should provide the
necessary memory barriers.

Use simple_xattr_free_rcu() in simple_xattrs_free(). This is needed because
the hash table is now shared between inodes and lookup on a different inode
might be running the compare function on the just freed element within the
RCU grace period.

Following stats are based on slabinfo diff, after creating 100k empty
files, then adding a "user.test=foo" xattr to each:

v7.0 (no rhashtable):
  File creation: 993.40 bytes/file
  Xattr addition: 79.99 bytes/file

v7.1-rc2 (per-inode rhashtable):
  File creation: 939.73 bytes/file
  Xattr addition: 1296.08 bytes/file

v7.1-rc2 + this patch (per-sb rhashtable)
  File creation: 946.84 bytes/file
  Xattr addition: 111.86 bytes/file

The overhead of a single xattr is reduced to nearly v7.0 levels.  The per
xattr overhead is slightly larger due to the addition of three pointers to
struct simple_xattr.

Fixes: b32c4a213698 ("xattr: add rhashtable-based simple_xattr infrastructure")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/kernfs/dir.c             |   5 +-
 fs/kernfs/inode.c           |  10 +-
 fs/kernfs/kernfs-internal.h |   4 +-
 fs/pidfs.c                  |  14 +-
 fs/xattr.c                  | 283 +++++++++++++++++-------------------
 include/linux/shmem_fs.h    |   3 +-
 include/linux/xattr.h       |  26 ++--
 mm/shmem.c                  |  13 +-
 net/socket.c                |  12 +-
 9 files changed, 192 insertions(+), 178 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 368dc4a217d9..8ba2f2f3da9e 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -606,7 +606,7 @@ void kernfs_put(struct kernfs_node *kn)
 		kernfs_put(kn->symlink.target_kn);
 
 	if (kn->iattr)
-		simple_xattrs_free(&kn->iattr->xattrs, NULL);
+		simple_xattrs_free(&root->xa_cache, &kn->iattr->xattrs, NULL);
 
 	spin_lock(&root->kernfs_idr_lock);
 	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
@@ -621,6 +621,7 @@ void kernfs_put(struct kernfs_node *kn)
 	} else {
 		/* just released the root kn, free @root too */
 		idr_destroy(&root->ino_idr);
+		simple_xattr_cache_cleanup(&root->xa_cache);
 		kfree_rcu(root, rcu);
 	}
 }
@@ -706,7 +707,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 
  err_out4:
 	if (kn->iattr) {
-		simple_xattrs_free(&kn->iattr->xattrs, NULL);
+		simple_xattrs_free(&root->xa_cache, &kn->iattr->xattrs, NULL);
 		kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
 	}
  err_out3:
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 65721b1b04f7..41e471261a62 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -37,6 +37,7 @@ static struct kernfs_iattrs *__kernfs_iattrs(struct kernfs_node *kn, bool alloc)
 	if (!ret)
 		return NULL;
 
+	INIT_LIST_HEAD_RCU(&ret->xattrs);
 	/* assign default attributes */
 	ret->ia_uid = GLOBAL_ROOT_UID;
 	ret->ia_gid = GLOBAL_ROOT_GID;
@@ -296,11 +297,12 @@ int kernfs_xattr_get(struct kernfs_node *kn, const char *name,
 		     void *value, size_t size)
 {
 	struct kernfs_iattrs *attrs = kernfs_iattrs_noalloc(kn);
+	struct simple_xattr_cache *cache = &kernfs_root(kn)->xa_cache;
 
 	if (!attrs)
 		return -ENODATA;
 
-	return simple_xattr_get(&attrs->xattrs, name, value, size);
+	return simple_xattr_get(cache, &attrs->xattrs, name, value, size);
 }
 
 int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
@@ -308,12 +310,13 @@ int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
 {
 	struct simple_xattr *old_xattr;
 	struct kernfs_iattrs *attrs;
+	struct simple_xattr_cache *cache = &kernfs_root(kn)->xa_cache;
 
 	attrs = kernfs_iattrs(kn);
 	if (!attrs)
 		return -ENOMEM;
 
-	old_xattr = simple_xattr_set(&attrs->xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(cache, &attrs->xattrs, name, value, size, flags);
 	if (IS_ERR(old_xattr))
 		return PTR_ERR(old_xattr);
 
@@ -360,7 +363,8 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 	if (!attrs)
 		return -ENOMEM;
 
-	return simple_xattr_set_limited(&attrs->xattrs, &attrs->xattr_limits,
+	return simple_xattr_set_limited(&kernfs_root(kn)->xa_cache,
+					&attrs->xattrs, &attrs->xattr_limits,
 					full_name, value, size, flags);
 }
 
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 8d8912f50b05..4c8c9c3ed639 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -26,7 +26,7 @@ struct kernfs_iattrs {
 	struct timespec64	ia_mtime;
 	struct timespec64	ia_ctime;
 
-	struct simple_xattrs	*xattrs;
+	struct list_head	xattrs;
 	struct simple_xattr_limits xattr_limits;
 };
 
@@ -54,6 +54,8 @@ struct kernfs_root {
 	rwlock_t		kernfs_rename_lock;
 
 	struct rcu_head		rcu;
+
+	struct simple_xattr_cache xa_cache;
 };
 
 /* +1 to avoid triggering overflow warning when negating it */
diff --git a/fs/pidfs.c b/fs/pidfs.c
index eb5105bddeca..143d0aec16af 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -37,6 +37,8 @@ static struct kmem_cache *pidfs_attr_cachep __ro_after_init;
 
 static struct path pidfs_root_path = {};
 
+static struct simple_xattr_cache pidfs_xa_cache;
+
 void pidfs_get_root(struct path *path)
 {
 	*path = pidfs_root_path;
@@ -96,7 +98,7 @@ static const struct rhashtable_params pidfs_ino_ht_params = {
  * use file handles.
  */
 struct pidfs_attr {
-	struct simple_xattrs *xattrs;
+	struct list_head xattrs;
 	union {
 		struct pidfs_anon_attr;
 		struct llist_node pidfs_llist;
@@ -196,7 +198,7 @@ static void pidfs_free_attr_work(struct work_struct *work)
 
 	head = llist_del_all(&pidfs_free_list);
 	llist_for_each_entry_safe(attr, next, head, pidfs_llist) {
-		simple_xattrs_free(&attr->xattrs, NULL);
+		simple_xattrs_free(&pidfs_xa_cache, &attr->xattrs, NULL);
 		kfree(attr);
 	}
 }
@@ -224,7 +226,7 @@ void pidfs_free_pid(struct pid *pid)
 	if (IS_ERR(attr))
 		return;
 
-	if (likely(!attr->xattrs))
+	if (likely(list_empty(&attr->xattrs)))
 		kfree(attr);
 	else if (llist_add(&attr->pidfs_llist, &pidfs_free_list))
 		schedule_work(&pidfs_free_work);
@@ -1007,6 +1009,8 @@ int pidfs_register_pid(struct pid *pid)
 	if (!new_attr)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD_RCU(&new_attr->xattrs);
+
 	/* Synchronize with pidfs_exit(). */
 	guard(spinlock_irq)(&pid->wait_pidfd.lock);
 
@@ -1048,7 +1052,7 @@ static int pidfs_xattr_get(const struct xattr_handler *handler,
 	struct pid *pid = inode->i_private;
 	const char *name = xattr_full_name(handler, suffix);
 
-	return simple_xattr_get(&pid->attr->xattrs, name, value, size);
+	return simple_xattr_get(&pidfs_xa_cache, &pid->attr->xattrs, name, value, size);
 }
 
 static int pidfs_xattr_set(const struct xattr_handler *handler,
@@ -1063,7 +1067,7 @@ static int pidfs_xattr_set(const struct xattr_handler *handler,
 	/* Ensure we're the only one to set @attr->xattrs. */
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
-	old_xattr = simple_xattr_set(&pid->attr->xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&pidfs_xa_cache, &pid->attr->xattrs, name, value, size, flags);
 	if (IS_ERR(old_xattr))
 		return PTR_ERR(old_xattr);
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 9ef7ad8a8f32..89374cd9029a 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -28,6 +28,11 @@
 
 #include "internal.h"
 
+struct sx_key {
+	const struct list_head *parent;
+	const char *name;
+};
+
 static const char *
 strcmp_prefix(const char *a, const char *a_prefix)
 {
@@ -1269,23 +1274,32 @@ struct simple_xattr *simple_xattr_alloc(const void *value, size_t size)
 	return new_xattr;
 }
 
+static u32 sx_hashfn(const char *name, const struct list_head *parent, u32 seed)
+{
+	return jhash(name, strlen(name), jhash(&parent, sizeof(parent), seed));
+}
+
 static u32 simple_xattr_hashfn(const void *data, u32 len, u32 seed)
 {
-	const char *name = data;
-	return jhash(name, strlen(name), seed);
+	const struct sx_key *key = data;
+
+	return sx_hashfn(key->name, key->parent, seed);
 }
 
 static u32 simple_xattr_obj_hashfn(const void *obj, u32 len, u32 seed)
 {
 	const struct simple_xattr *xattr = obj;
-	return jhash(xattr->name, strlen(xattr->name), seed);
+
+	return sx_hashfn(xattr->name, xattr->parent, seed);
 }
 
 static int simple_xattr_obj_cmpfn(struct rhashtable_compare_arg *arg,
 				   const void *obj)
 {
 	const struct simple_xattr *xattr = obj;
-	return strcmp(xattr->name, arg->key);
+	const struct sx_key *key = arg->key;
+
+	return xattr->parent != key->parent || strcmp(xattr->name, key->name);
 }
 
 static const struct rhashtable_params simple_xattr_params = {
@@ -1298,6 +1312,7 @@ static const struct rhashtable_params simple_xattr_params = {
 
 /**
  * simple_xattr_get - get an xattr object
+ * @cache: anchor for the hash table
  * @xattrs: the header of the xattr object
  * @name: the name of the xattr to retrieve
  * @buffer: the buffer to store the value into
@@ -1311,19 +1326,19 @@ static const struct rhashtable_params simple_xattr_params = {
  * Return: On success the length of the xattr value is returned. On error a
  * negative error code is returned.
  */
-int simple_xattr_get(struct simple_xattrs **xattrsp, const char *name,
-		     void *buffer, size_t size)
+int simple_xattr_get(struct simple_xattr_cache *cache, struct list_head *xattrs,
+		     const char *name, void *buffer, size_t size)
 {
-	struct simple_xattrs *xattrs;
 	struct simple_xattr *xattr;
+	struct sx_key key = { .parent = xattrs, .name = name };
+	struct rhashtable *ht = READ_ONCE(cache->ht);
 	int ret = -ENODATA;
 
-	xattrs = READ_ONCE(*xattrsp);
-	if (!xattrs)
-		return -ENODATA;
+	if (!ht)
+		return ret;
 
 	guard(rcu)();
-	xattr = rhashtable_lookup(&xattrs->ht, name, simple_xattr_params);
+	xattr = rhashtable_lookup(ht, &key, simple_xattr_params);
 	if (xattr) {
 		ret = xattr->size;
 		if (buffer) {
@@ -1336,11 +1351,45 @@ int simple_xattr_get(struct simple_xattrs **xattrsp, const char *name,
 	return ret;
 }
 
-static struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
-						      const void *value, int flags);
+static struct rhashtable *simple_xattrs_lazy_alloc(struct simple_xattr_cache *cache,
+						   const void *value, int flags)
+{
+	struct rhashtable *oldht, *ht = READ_ONCE(cache->ht);
+	int err;
+
+	if (unlikely(!ht)) {
+		if (!value)
+			return (flags & XATTR_REPLACE) ? ERR_PTR(-ENODATA) : NULL;
+
+		ht = kzalloc_obj(*ht);
+		if (!ht)
+			return ERR_PTR(-ENOMEM);
+
+		err = rhashtable_init(ht, &simple_xattr_params);
+		if (err) {
+			kfree(ht);
+			return ERR_PTR(err);
+		}
+
+		/*
+		 * Provides release semantics on success, so that use of a
+		 * non-NULL READ_ONCE(cache->ht) will be ordered relative to the
+		 * above initialization, due to implicit address dependency.
+		 */
+		oldht = cmpxchg_release(&cache->ht, NULL, ht);
+		if (oldht) {
+			/* Race lost */
+			rhashtable_destroy(ht);
+			kfree(ht);
+			ht = oldht;
+		}
+	}
+	return ht;
+}
 
 /**
  * simple_xattr_set - set an xattr object
+ * @cache: anchor for the hash table
  * @xattrs: the header of the xattr object
  * @name: the name of the xattr to retrieve
  * @value: the value to store along the xattr
@@ -1370,50 +1419,58 @@ static struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xat
  * Return: On success, the removed or replaced xattr is returned, to be freed
  * by the caller; or NULL if none. On failure a negative error code is returned.
  */
-struct simple_xattr *simple_xattr_set(struct simple_xattrs **xattrsp,
+struct simple_xattr *simple_xattr_set(struct simple_xattr_cache *cache, struct list_head *xattrs,
 				      const char *name, const void *value,
 				      size_t size, int flags)
 {
-	struct simple_xattrs *xattrs;
+	struct sx_key key = { .parent = xattrs, .name = name };
 	struct simple_xattr *old_xattr = NULL;
+	struct rhashtable *ht;
 	int err;
 
-	xattrs = simple_xattrs_lazy_alloc(xattrsp, value, flags);
-	if (IS_ERR_OR_NULL(xattrs))
-		return ERR_CAST(xattrs);
+	ht = simple_xattrs_lazy_alloc(cache, value, flags);
+	if (IS_ERR_OR_NULL(ht))
+		return ERR_CAST(ht);
 
 	CLASS(simple_xattr, new_xattr)(value, size);
 	if (IS_ERR(new_xattr))
 		return new_xattr;
 
 	if (new_xattr) {
+		new_xattr->parent = xattrs;
 		new_xattr->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
 		if (!new_xattr->name)
 			return ERR_PTR(-ENOMEM);
 	}
 
-	/* Lookup is safe without RCU here since writes are serialized. */
-	old_xattr = rhashtable_lookup_fast(&xattrs->ht, name,
-					   simple_xattr_params);
-
+	/*
+	 * Hash table lookup/replace/remove will grab RCU read lock themselves.
+	 * This makes sure that hash table lookup is safe against concurrent
+	 * modification on another inode.
+	 */
+	old_xattr = rhashtable_lookup_fast(ht, &key, simple_xattr_params);
 	if (old_xattr) {
 		/* Fail if XATTR_CREATE is requested and the xattr exists. */
 		if (flags & XATTR_CREATE)
 			return ERR_PTR(-EEXIST);
 
 		if (new_xattr) {
-			err = rhashtable_replace_fast(&xattrs->ht,
+			err = rhashtable_replace_fast(ht,
 						      &old_xattr->hash_node,
 						      &new_xattr->hash_node,
 						      simple_xattr_params);
 			if (err)
 				return ERR_PTR(err);
+
+			list_replace_rcu(&old_xattr->node, &new_xattr->node);
 		} else {
-			err = rhashtable_remove_fast(&xattrs->ht,
+			err = rhashtable_remove_fast(ht,
 						     &old_xattr->hash_node,
 						     simple_xattr_params);
 			if (err)
 				return ERR_PTR(err);
+
+			list_del_rcu(&old_xattr->node);
 		}
 	} else {
 		/* Fail if XATTR_REPLACE is requested but no xattr is found. */
@@ -1425,11 +1482,13 @@ struct simple_xattr *simple_xattr_set(struct simple_xattrs **xattrsp,
 		 * new value simply insert it.
 		 */
 		if (new_xattr) {
-			err = rhashtable_insert_fast(&xattrs->ht,
+			err = rhashtable_insert_fast(ht,
 						     &new_xattr->hash_node,
 						     simple_xattr_params);
 			if (err)
 				return ERR_PTR(err);
+
+			list_add_tail_rcu(&new_xattr->node, xattrs);
 		}
 
 		/*
@@ -1466,6 +1525,7 @@ static inline int simple_xattr_limits_inc(struct simple_xattr_limits *limits,
 
 /**
  * simple_xattr_set_limited - set an xattr with per-inode user.* limits
+ * @cache: anchor for the hash table
  * @xattrs: the header of the xattr object
  * @limits: per-inode limit counters for user.* xattrs
  * @name: the name of the xattr to set or remove
@@ -1480,7 +1540,7 @@ static inline int simple_xattr_limits_inc(struct simple_xattr_limits *limits,
  * Return: On success zero is returned. On failure a negative error code is
  * returned.
  */
-int simple_xattr_set_limited(struct simple_xattrs **xattrs,
+int simple_xattr_set_limited(struct simple_xattr_cache *cache, struct list_head *xattrs,
 			     struct simple_xattr_limits *limits,
 			     const char *name, const void *value,
 			     size_t size, int flags)
@@ -1494,7 +1554,7 @@ int simple_xattr_set_limited(struct simple_xattrs **xattrs,
 			return ret;
 	}
 
-	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(cache, xattrs, name, value, size, flags);
 	if (IS_ERR(old_xattr)) {
 		if (value)
 			simple_xattr_limits_dec(limits, size);
@@ -1540,12 +1600,10 @@ static bool xattr_is_maclabel(const char *name)
  * Return: On success the required size or the size of the copied xattrs is
  * returned. On error a negative error code is returned.
  */
-ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs **xattrsp,
+ssize_t simple_xattr_list(struct inode *inode, struct list_head *xattrs,
 			  char *buffer, size_t size)
 {
 	bool trusted = ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
-	struct simple_xattrs *xattrs;
-	struct rhashtable_iter iter;
 	struct simple_xattr *xattr;
 	ssize_t remaining_size = size;
 	int err = 0;
@@ -1566,21 +1624,11 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs **xattrsp,
 	remaining_size -= err;
 	err = 0;
 
-	xattrs = READ_ONCE(*xattrsp);
 	if (!xattrs)
 		return size - remaining_size;
 
-	rhashtable_walk_enter(&xattrs->ht, &iter);
-	rhashtable_walk_start(&iter);
-
-	while ((xattr = rhashtable_walk_next(&iter)) != NULL) {
-		if (IS_ERR(xattr)) {
-			if (PTR_ERR(xattr) == -EAGAIN)
-				continue;
-			err = PTR_ERR(xattr);
-			break;
-		}
-
+	rcu_read_lock();
+	list_for_each_entry_rcu(xattr, xattrs, node) {
 		/* skip "trusted." attributes for unprivileged callers */
 		if (!trusted && xattr_is_trusted(xattr->name))
 			continue;
@@ -1593,15 +1641,14 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs **xattrsp,
 		if (err)
 			break;
 	}
-
-	rhashtable_walk_stop(&iter);
-	rhashtable_walk_exit(&iter);
+	rcu_read_unlock();
 
 	return err ? err : size - remaining_size;
 }
 
 /**
  * simple_xattr_add - add xattr objects
+ * @cache: anchor for the hash table
  * @xattrs: the header of the xattr object
  * @new_xattr: the xattr object to add
  *
@@ -1612,125 +1659,67 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs **xattrsp,
  * Return: On success zero is returned. On failure a negative error code is
  * returned.
  */
-int simple_xattr_add(struct simple_xattrs **xattrsp,
+int simple_xattr_add(struct simple_xattr_cache *cache, struct list_head *xattrs,
 		     struct simple_xattr *new_xattr)
 {
-	struct simple_xattrs *xattrs;
-
-	xattrs = simple_xattrs_lazy_alloc(xattrsp, new_xattr->value, 0);
-	if (IS_ERR(xattrs))
-		return PTR_ERR(xattrs);
-
-	return rhashtable_insert_fast(&xattrs->ht, &new_xattr->hash_node,
-				      simple_xattr_params);
-}
-
-/**
- * simple_xattrs_init - initialize new xattr header
- * @xattrs: header to initialize
- *
- * Initialize the rhashtable used to store xattr objects.
- *
- * Return: On success zero is returned. On failure a negative error code is
- * returned.
- */
-int simple_xattrs_init(struct simple_xattrs *xattrs)
-{
-	return rhashtable_init(&xattrs->ht, &simple_xattr_params);
-}
-
-/**
- * simple_xattrs_alloc - allocate and initialize a new xattr header
- *
- * Dynamically allocate a simple_xattrs header and initialize the
- * underlying rhashtable. This is intended for consumers that want
- * to lazily allocate xattr storage only when the first xattr is set,
- * avoiding the per-inode rhashtable overhead when no xattrs are used.
- *
- * Return: On success a new simple_xattrs is returned. On failure an
- * ERR_PTR is returned.
- */
-static struct simple_xattrs *simple_xattrs_alloc(void)
-{
-	struct simple_xattrs *xattrs __free(kfree) = NULL;
-	int ret;
+	struct rhashtable *ht;
+	int err;
 
-	xattrs = kzalloc(sizeof(*xattrs), GFP_KERNEL);
-	if (!xattrs)
-		return ERR_PTR(-ENOMEM);
+	ht = simple_xattrs_lazy_alloc(cache, new_xattr->value, 0);
+	if (IS_ERR(ht))
+		return PTR_ERR(ht);
 
-	ret = simple_xattrs_init(xattrs);
-	if (ret)
-		return ERR_PTR(ret);
+	new_xattr->parent = xattrs;
+	err = rhashtable_insert_fast(ht, &new_xattr->hash_node, simple_xattr_params);
+	if (err)
+		return err;
 
-	return no_free_ptr(xattrs);
+	list_add_tail_rcu(&new_xattr->node, xattrs);
+	return 0;
 }
 
 /**
- * simple_xattrs_lazy_alloc - get or allocate xattrs for a set operation
- * @xattrsp: pointer to the xattrs pointer (may point to NULL)
- * @value: value being set (NULL means remove)
- * @flags: xattr set flags
- *
- * For lazily-allocated xattrs on the write path. If no xattrs exist yet
- * and this is a remove operation, returns the appropriate result without
- * allocating. Otherwise ensures xattrs is allocated and published with
- * store-release semantics.
+ * simple_xattrs_free - free xattrs
+ * @cache: anchor for the hash table
+ * @xattrs: xattr header whose xattrs to destroy
+ * @freed_space: approximate number of bytes of memory freed from @xattrs
  *
- * Return: On success a valid pointer to the xattrs is returned. On
- * failure or early-exit an ERR_PTR or NULL is returned. Callers should
- * check with IS_ERR_OR_NULL() and propagate with PTR_ERR() which
- * correctly returns 0 for the NULL no-op case.
+ * Destroy all xattrs in @xattrs. When this is called no one can hold a
+ * reference to any of the xattrs anymore.
  */
-static struct simple_xattrs *simple_xattrs_lazy_alloc(struct simple_xattrs **xattrsp,
-						      const void *value, int flags)
+void simple_xattrs_free(struct simple_xattr_cache *cache, struct list_head *xattrs,
+			size_t *freed_space)
 {
-	struct simple_xattrs *xattrs;
-
-	xattrs = READ_ONCE(*xattrsp);
-	if (xattrs)
-		return xattrs;
-
-	if (!value)
-		return (flags & XATTR_REPLACE) ? ERR_PTR(-ENODATA) : NULL;
-
-	xattrs = simple_xattrs_alloc();
-	if (!IS_ERR(xattrs))
-		smp_store_release(xattrsp, xattrs);
-	return xattrs;
-}
+	if (freed_space)
+		*freed_space = 0;
 
-static void simple_xattr_ht_free(void *ptr, void *arg)
-{
-	struct simple_xattr *xattr = ptr;
-	size_t *freed_space = arg;
+	while (!list_empty(xattrs)) {
+		struct simple_xattr *xattr = list_first_entry(xattrs, typeof(*xattr), node);
 
-	if (freed_space)
-		*freed_space += simple_xattr_space(xattr->name, xattr->size);
-	simple_xattr_free(xattr);
+		rhashtable_remove_fast(cache->ht, &xattr->hash_node, simple_xattr_params);
+		list_del(&xattr->node);
+		if (freed_space)
+			*freed_space += simple_xattr_space(xattr->name, xattr->size);
+		/*
+		 * Free with RCU, since the xattr might still get accessed by
+		 * the hash compare function
+		 */
+		simple_xattr_free_rcu(xattr);
+	}
 }
 
 /**
- * simple_xattrs_free - free xattrs
- * @xattrs: xattr header whose xattrs to destroy
- * @freed_space: approximate number of bytes of memory freed from @xattrs
+ * simple_xattr_cache_cleanup - free the cache
+ * @cache: anchor for the hash table
  *
- * Destroy all xattrs in @xattr. When this is called no one can hold a
- * reference to any of the xattrs anymore.
+ * Destroy the cache table, which was lazily allocated on adding the first xattr.
  */
-void simple_xattrs_free(struct simple_xattrs **xattrsp, size_t *freed_space)
+void simple_xattr_cache_cleanup(struct simple_xattr_cache *cache)
 {
-	struct simple_xattrs *xattrs = *xattrsp;
-
-	might_sleep();
-
-	if (!xattrs)
-		return;
-
-	if (freed_space)
-		*freed_space = 0;
-	rhashtable_free_and_destroy(&xattrs->ht, simple_xattr_ht_free,
-				    freed_space);
-	kfree(xattrs);
-	*xattrsp = NULL;
+	if (cache->ht) {
+		WARN_ON(atomic_read(&cache->ht->nelems));
+		rhashtable_destroy(cache->ht);
+		kfree(cache->ht);
+		cache->ht = NULL;
+	}
 }
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 93a0ba872ebe..69b0177da156 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -48,7 +48,7 @@ struct shmem_inode_info {
 	};
 	struct timespec64	i_crtime;	/* file creation time */
 	struct shared_policy	policy;		/* NUMA memory alloc policy */
-	struct simple_xattrs	*xattrs;	/* list of xattrs */
+	struct list_head        xattrs;		/* list of xattrs */
 	pgoff_t			fallocend;	/* highest fallocate endindex */
 	unsigned int		fsflags;	/* for FS_IOC_[SG]ETFLAGS */
 	atomic_t		stop_eviction;	/* hold when working on inode */
@@ -89,6 +89,7 @@ struct shmem_sb_info {
 	struct list_head shrinklist;  /* List of shinkable inodes */
 	unsigned long shrinklist_len; /* Length of shrinklist */
 	struct shmem_quota_limits qlimits; /* Default quota limits */
+	struct simple_xattr_cache xa_cache;
 };
 
 static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index ded446c1ef81..7aaaf4f8aff5 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -106,12 +106,14 @@ static inline const char *xattr_prefix(const struct xattr_handler *handler)
 	return handler->prefix ?: handler->name;
 }
 
-struct simple_xattrs {
-	struct rhashtable ht;
+struct simple_xattr_cache {
+	struct rhashtable *ht;
 };
 
 struct simple_xattr {
 	struct rhash_head hash_node;
+	struct list_head *parent;
+	struct list_head node;
 	struct rcu_head rcu;
 	char *name;
 	size_t size;
@@ -132,27 +134,31 @@ static inline void simple_xattr_limits_init(struct simple_xattr_limits *limits)
 	atomic_set(&limits->xattr_size, 0);
 }
 
-int simple_xattrs_init(struct simple_xattrs *xattrs);
-void simple_xattrs_free(struct simple_xattrs **xattrs, size_t *freed_space);
+void simple_xattrs_free(struct simple_xattr_cache *cache, struct list_head *xattrs,
+			size_t *freed_space);
 size_t simple_xattr_space(const char *name, size_t size);
 struct simple_xattr *simple_xattr_alloc(const void *value, size_t size);
 void simple_xattr_free(struct simple_xattr *xattr);
 void simple_xattr_free_rcu(struct simple_xattr *xattr);
-int simple_xattr_get(struct simple_xattrs **xattrs, const char *name,
-		     void *buffer, size_t size);
-struct simple_xattr *simple_xattr_set(struct simple_xattrs **xattrs,
+int simple_xattr_get(struct simple_xattr_cache *cache, struct list_head *xattrs,
+		     const char *name, void *buffer, size_t size);
+struct simple_xattr *simple_xattr_set(struct simple_xattr_cache *cache,
+				      struct list_head *xattrs,
 				      const char *name, const void *value,
 				      size_t size, int flags);
-int simple_xattr_set_limited(struct simple_xattrs **xattrs,
+int simple_xattr_set_limited(struct simple_xattr_cache *cache,
+			     struct list_head *xattrs,
 			     struct simple_xattr_limits *limits,
 			     const char *name, const void *value,
 			     size_t size, int flags);
-ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs **xattrs,
+ssize_t simple_xattr_list(struct inode *inode, struct list_head *xattrs,
 			  char *buffer, size_t size);
-int simple_xattr_add(struct simple_xattrs **xattrs,
+int simple_xattr_add(struct simple_xattr_cache *cache, struct list_head *xattrs,
 		     struct simple_xattr *new_xattr);
 int xattr_list_one(char **buffer, ssize_t *remaining_size, const char *name);
 
+void simple_xattr_cache_cleanup(struct simple_xattr_cache *cache);
+
 DEFINE_CLASS(simple_xattr,
 	     struct simple_xattr *,
 	     if (!IS_ERR_OR_NULL(_T)) simple_xattr_free(_T),
diff --git a/mm/shmem.c b/mm/shmem.c
index e6babf4a9377..0be26fc854a5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1425,7 +1425,7 @@ static void shmem_evict_inode(struct inode *inode)
 		}
 	}
 
-	simple_xattrs_free(&info->xattrs, sbinfo->max_inodes ? &freed : NULL);
+	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
 
 	shmem_free_inode(inode->i_sb, freed);
 	WARN_ON(inode->i_blocks);
@@ -3084,6 +3084,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	inode->i_generation = get_random_u32();
 	info = SHMEM_I(inode);
 	memset(info, 0, (char *)inode - (char *)info);
+	INIT_LIST_HEAD_RCU(&info->xattrs);
 	spin_lock_init(&info->lock);
 	atomic_set(&info->stop_eviction, 0);
 	info->seals = F_SEAL_SEAL;
@@ -4258,7 +4259,7 @@ static int shmem_initxattrs(struct inode *inode,
 		if (!new_xattr->name)
 			return -ENOMEM;
 
-		if (simple_xattr_add(&info->xattrs, new_xattr))
+		if (simple_xattr_add(&sbinfo->xa_cache, &info->xattrs, new_xattr))
 			return -ENOMEM;
 
 		retain_and_null_ptr(new_xattr);
@@ -4271,10 +4272,11 @@ static int shmem_xattr_handler_get(const struct xattr_handler *handler,
 				   struct dentry *unused, struct inode *inode,
 				   const char *name, void *buffer, size_t size)
 {
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
 	name = xattr_full_name(handler, name);
-	return simple_xattr_get(&info->xattrs, name, buffer, size);
+	return simple_xattr_get(&sbinfo->xa_cache, &info->xattrs, name, buffer, size);
 }
 
 static int shmem_xattr_handler_set(const struct xattr_handler *handler,
@@ -4302,7 +4304,7 @@ static int shmem_xattr_handler_set(const struct xattr_handler *handler,
 			return -ENOSPC;
 	}
 
-	old_xattr = simple_xattr_set(&info->xattrs, name, value, size, flags);
+	old_xattr = simple_xattr_set(&sbinfo->xa_cache, &info->xattrs, name, value, size, flags);
 	if (!IS_ERR(old_xattr)) {
 		ispace = 0;
 		if (old_xattr && sbinfo->max_inodes)
@@ -4951,6 +4953,9 @@ static void shmem_put_super(struct super_block *sb)
 	free_percpu(sbinfo->ino_batch);
 	percpu_counter_destroy(&sbinfo->used_blocks);
 	mpol_put(sbinfo->mpol);
+#ifdef CONFIG_TMPFS_XATTR
+	simple_xattr_cache_cleanup(&sbinfo->xa_cache);
+#endif
 	kfree(sbinfo);
 	sb->s_fs_info = NULL;
 }
diff --git a/net/socket.c b/net/socket.c
index d3597c858345..a8014f930d9e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -310,8 +310,10 @@ static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
 
 static struct kmem_cache *sock_inode_cachep __ro_after_init;
 
+static struct simple_xattr_cache sockfs_xa_cache;
+
 struct sockfs_inode {
-	struct simple_xattrs *xattrs;
+	struct list_head xattrs;
 	struct simple_xattr_limits xattr_limits;
 	struct socket_alloc;
 };
@@ -328,7 +330,7 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
 	si = alloc_inode_sb(sb, sock_inode_cachep, GFP_KERNEL);
 	if (!si)
 		return NULL;
-	si->xattrs = NULL;
+	INIT_LIST_HEAD_RCU(&si->xattrs);
 	simple_xattr_limits_init(&si->xattr_limits);
 
 	init_waitqueue_head(&si->socket.wq.wait);
@@ -348,7 +350,7 @@ static void sock_evict_inode(struct inode *inode)
 {
 	struct sockfs_inode *si = SOCKFS_I(inode);
 
-	simple_xattrs_free(&si->xattrs, NULL);
+	simple_xattrs_free(&sockfs_xa_cache, &si->xattrs, NULL);
 	clear_inode(inode);
 }
 
@@ -441,7 +443,7 @@ static int sockfs_user_xattr_get(const struct xattr_handler *handler,
 	const char *name = xattr_full_name(handler, suffix);
 	struct sockfs_inode *si = SOCKFS_I(inode);
 
-	return simple_xattr_get(&si->xattrs, name, value, size);
+	return simple_xattr_get(&sockfs_xa_cache, &si->xattrs, name, value, size);
 }
 
 static int sockfs_user_xattr_set(const struct xattr_handler *handler,
@@ -453,7 +455,7 @@ static int sockfs_user_xattr_set(const struct xattr_handler *handler,
 	const char *name = xattr_full_name(handler, suffix);
 	struct sockfs_inode *si = SOCKFS_I(inode);
 
-	return simple_xattr_set_limited(&si->xattrs, &si->xattr_limits,
+	return simple_xattr_set_limited(&sockfs_xa_cache, &si->xattrs, &si->xattr_limits,
 					name, value, size, flags);
 }
 
-- 
2.54.0



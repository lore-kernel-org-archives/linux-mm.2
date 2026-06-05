Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 379E7CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ABF86B0088; Fri,  5 Jun 2026 09:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45CE26B008A; Fri,  5 Jun 2026 09:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373076B0092; Fri,  5 Jun 2026 09:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 293856B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:53:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C695DA00F9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:30 +0000 (UTC)
X-FDA: 84846001380.16.7AB4783
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 660A0A0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QN0MbZZS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780667608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TRPxFGECnjw+M8/0IvOgB7NTMDasli+evg1PYVSz64=;
	b=oZzgxZDPwa/1AVnfhHtrWzxCFtFSWDPgzXs04oN3Q+Irp5JVa2C718oBQnzTFuLfLMvaWx
	CVkQdL+qDPHSkAnRZVz8ZeWE5GKsrgMA56E5uJAO3fVnD/hfHKpcJEycISUQ8G53QC5IHU
	KsLgerdtzd9MLNinVYFQHzBryshdPJQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QN0MbZZS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780667608;
	b=DTTmM2Gl2T+3c3EAPvGSMuTqiWeBzb5+1MtO3QGNXarDuTNEB0M/tIXo5TMclMRQ1y7SMW
	aSwEIjzfBcD/oZ1rAOrCwBk2YRL3GNsKYvMfjEyzCG6980Ri08BGnqI1zP00LmjpNse1dV
	cmEnwHqFsiqeH6+NFmHryev4mQzntN0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780667607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8TRPxFGECnjw+M8/0IvOgB7NTMDasli+evg1PYVSz64=;
	b=QN0MbZZScJk7fNI7SMPc8nn+a4tb1OzQ3umrd7+mawaWUit0q7jm2faGdBiGRbPLhmd+x4
	jBZLy98ECZWSkhydSL4tHz3e9GgTksCS+/Wkk81sYxNlFRa02oN7ospoxjlmMIhzh8MENL
	V1gJdX62NMMXHcn3qFUN91YATfyI6yA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-lzawdh3_O1CgswWOBTLUXQ-1; Fri, 05 Jun 2026 09:53:26 -0400
X-MC-Unique: lzawdh3_O1CgswWOBTLUXQ-1
X-Mimecast-MFC-AGG-ID: lzawdh3_O1CgswWOBTLUXQ_1780667605
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490bae3a39bso19817225e9.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 06:53:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780667605; x=1781272405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8TRPxFGECnjw+M8/0IvOgB7NTMDasli+evg1PYVSz64=;
        b=foPy1tTXoeNmURQZYPq+Oo2QtqXxPrznrphXbFBpuCj4c4mwb6m9Eo1Hwmb9ia2P49
         iCu4iNWmQCpCeNsgaq2Q/CgUyYSc/l+tFcuQODC0lNKIJIriMI8blk6jhQz6GCJK/d5Z
         yiwQjSNrtls1s6OSZx+779c0p3O9DlVmGg+fv/ClKonLxC+UDJsNM/gWmwOwWhw6+wnu
         jFpkrgTPksDi3RFfb47OrHhLU9Zg7taAJRV49QKnKYrgqprONT7WmqcgiXFXUEAvFIAH
         7Nno2hl1DM4pYzPejgvwHYJAWhA9LQK0yP2NGBb2pVnZ3h7t44LcVjjDnpdCGJtDgg23
         uNWA==
X-Gm-Message-State: AOJu0YyZnJserQPscXAa75h0Gkwrmt9R658q943C4fhmWNAV+vI9E3Om
	HGTyJTPtqmbip0WfZj1rpd3AY0WVr/jsWEMN56xt+VWtDq7FJM1i6YlaNzV5mecnQjTfrX6nrbw
	600DkBa9XJ6IGyMkWNsX/p7BP1Ojee8+W5+JK9OxhB9eIVs6Yhwae
X-Gm-Gg: Acq92OHdx1lBBc9xGnAbtbim9yzu3xMCzUseVSjevGooHVL5uTOxZ6hxu5K/VPk6cIQ
	NoTVqz1FEopq+BVkaujWzY1DdchHp9zn1irR2bKzcnZaMNIHXOaN9rlryaajFUFhO0+umCj2Y7W
	RulUB5hVM3THO8fOGaQjFpuy588F4iWH59/xbG9da4U0YDCXhUFZDLwYnx0kpkUdcE8awyRVneF
	tQy1QQA3JZv4+em+mOaISoaLM8s/e0JP8B71oDE8PiebTsuAitZVJcpsOUEdJMRVDriBLWnXT9C
	V1/mDCL77KA94x4u+LUehQeBjV8XkRGkg6imUC/nguAIjhK8e8B338l6LSb+ivUD6E0zzOE20Mc
	WvbH/xdIP9Bm8T3bmwJGTgbq665B0WeOulmyEjSA5dtPTXclz7BJ4wDD+RQ++2sWGLTLTz5ic1c
	p9wKrwjQ==
X-Received: by 2002:a05:600c:674f:b0:490:6e11:c303 with SMTP id 5b1f17b1804b1-490c25ed266mr66310995e9.13.1780667605412;
        Fri, 05 Jun 2026 06:53:25 -0700 (PDT)
X-Received: by 2002:a05:600c:674f:b0:490:6e11:c303 with SMTP id 5b1f17b1804b1-490c25ed266mr66310545e9.13.1780667605025;
        Fri, 05 Jun 2026 06:53:25 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-1-92.pool.digikabel.hu. [84.236.1.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cbfe4sm157999025e9.7.2026.06.05.06.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 06:53:24 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 1/4] kernfs: fix xattr race condition with multiple superblocks
Date: Fri,  5 Jun 2026 15:53:16 +0200
Message-ID: <20260605135322.2632068-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605135322.2632068-1-mszeredi@redhat.com>
References: <20260605135322.2632068-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KDsPNzZ05y6Hsanwl49DyZFr3uoRjwFCs7o9w3g-a9g_1780667605
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: o78db7rtpehor1ehfpswpwxfziugeh7m
X-Rspamd-Queue-Id: 660A0A0005
X-HE-Tag: 1780667608-92171
X-HE-Meta: U2FsdGVkX1+3bsiA6rn0AGFT+a8Vqjxt7jWXs5YaA9D9+sUDOp7WSUNSwxdeA8Roy/6q/JWPQAu1tg9CSP3Qzm3wdlnNO1/gXrirnxh6oCpmiTJ08XNG0/HYqYZawuNjfUCOy6hc2NdtGHggirFFUB7zAvwBKl3fs6AKJHb6aFhDdHXGtYdEGRzcVKeGwTLZSAhe37Fg1k6x6gKTDWFAspljMvVtfaHIR7z74CKlPQG2A0DXq5FLpz7zErnk6Bu2DKij4A8gD6JkJE2FFbCsamp6noL0MN3nzKVdPN9FrkdaMKhaWNbblLpa/4gmSdBmEDYp5wTIynV6vRu9gRRap7ASp7yBmRGT4zUH7YLyaKuXnqYOzMP4rfJJVZ1WlbHOdHx1og7KnouTrGs1OB0DqHxi0me8i+ILJjnm4sssmR2HXGwPfxPMBVAc+F3q9aHEFmyXAP8Km/UvzokahMwOzsIw//eE76PeJTfSyIETDwzcPDF09AQTNWmfDVBBlo565q+kjaMQvMOcTyTaG3+DU6jD6/EeevYyXFZD8uGTypZHAxCFWAZa+JKBfxxTLDjcr8eZ+mghxqO1PqNNqdi87PrXzXjkFGivi0uM5Sbf1SEHP2q5KeSfv/HX84CQIy1/p2MbcUiT11SeGIpt9OFJU+bDCbeydI5iYYm6AVQicLoqVSMbYPYARW3/uX8McLu4f/BcX8yeO1j7Mzvno4TGUpDChwCNDdfciyGQQziuMGVuZdt10EA7ajX6TDZ0Dd9Woqu3vt0nszXImfws2pDHF2Sxdw7oHD5FOo14J8lTEUUY382hAgrrJ9lpeBIg5fQN4JFjxQvw7qfOXXo1E7vCNUv5j5s7FENBbtYQfJfyCQFxfj+26JjVvAdeqF8Nhjz0dTJagpbgoEucncxTP7krb0mzyyzX5HwMlsCXM7z9fsdkuXli+Yz+u3BxFHSdFGnK0bCuz/W/3DZ9NHVrz+Q
 iG8S7YH2
 /43OL4JzCPuLu4vPBQENk1z9DtcbKm7hjfBWM4qxKDFQj1VHOhEE/F9+rZMsQNLnpJI+ZezbI4rp7b2a/+bEJp4IdOgv9iQE1pniaA9qkuuaXanlTqdg9VxQii6livlyejfAlFg5zj2wr7lLaKYWX9SdKvlqRWHHJghL/rfi6ZqEFGZU8oruR9vUbXhnYb9lOav/tELRMzmB9L4MfpLTTI4+vlZyqSRk8Zrx1Cp9DbT+gi49V+ElbAxmjP8XRhHMBznI5PGKFT5oe8y2Eri3maLWBysRnmvzYxiMo5GRc15p646ZpfsfkjxJfostUAUrXdVpGrmZh6h1FimiffvNWwm61MUhNBGU+TPZO+WaUpPaukA64W5mCWKz/2cdt8Z5vLu3+LCyGZF9OD1Vc5dTO6oSMVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple superblocks with different namespaces can share the same
kernfs_node when kernfs_test_super() finds a matching root but
different namespace. This means multiple inodes from different
superblocks can reference the same kernfs_node->iattr->xattrs
structure.

The VFS layer only holds per-inode locks during xattr operations,
which is insufficient to serialize concurrent xattr modifications on
the shared kernfs_node. This can lead to race conditions in
simple_xattr_set() where the lookup->replace/remove sequence is not
atomic with respect to operations from other superblocks.

Fix this by protecting xattr operations with the existing hashed
kernfs_locks->open_file_mutex[] array, which is already used to
protect per-node open file data. The hashed mutex array provides
scalable per-node serialization (scaled by CPU count, up to 1024 locks
on 32+ CPU systems) with zero memory overhead.

Changes:
- Rename open_file_mutex[] to node_mutex[] to reflect dual purpose
- Add kernfs_node_lock_ptr() and kernfs_node_lock() helpers
- Protect simple_xattr_set() calls in kernfs_xattr_set() and
  kernfs_vfs_user_xattr_set() with the hashed mutex
- Update file.c to use new helpers via compatibility wrappers
- Update documentation to explain the extended lock usage

Fixes: b32c4a213698 ("xattr: add rhashtable-based simple_xattr infrastructure")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260601162454.2116375-1-mszeredi%40redhat.com
Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/kernfs/file.c            | 13 +++----------
 fs/kernfs/inode.c           | 12 ++++++++++++
 fs/kernfs/kernfs-internal.h | 20 ++++++++++++++++++++
 fs/kernfs/mount.c           |  2 +-
 include/linux/kernfs.h      | 11 ++++++++---
 5 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 1163aa769738..8e0e90c93372 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -40,22 +40,15 @@ struct kernfs_open_node {
 static DEFINE_SPINLOCK(kernfs_notify_lock);
 static struct kernfs_node *kernfs_notify_list = KERNFS_NOTIFY_EOL;
 
+/* Compatibility wrappers - use the common hashed node lock */
 static inline struct mutex *kernfs_open_file_mutex_ptr(struct kernfs_node *kn)
 {
-	int idx = hash_ptr(kn, NR_KERNFS_LOCK_BITS);
-
-	return &kernfs_locks->open_file_mutex[idx];
+	return kernfs_node_lock_ptr(kn);
 }
 
 static inline struct mutex *kernfs_open_file_mutex_lock(struct kernfs_node *kn)
 {
-	struct mutex *lock;
-
-	lock = kernfs_open_file_mutex_ptr(kn);
-
-	mutex_lock(lock);
-
-	return lock;
+	return kernfs_node_lock(kn);
 }
 
 /**
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 38b28aa7cd02..e676737d9531 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -320,6 +320,15 @@ int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
 	if (!attrs)
 		return -ENOMEM;
 
+	/*
+	 * Protect xattr modifications with the hashed per-node mutex.
+	 * Multiple superblocks (with different namespaces) can share the same
+	 * kernfs_node, so inode locking alone is insufficient. The hashed mutex
+	 * ensures serialization of concurrent xattr operations on the same node,
+	 * including the lazy allocation of the xattrs structure itself.
+	 */
+	CLASS(kernfs_node_lock, lock)(kn);
+
 	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
 	if (IS_ERR_OR_NULL(xattrs))
 		return PTR_ERR(xattrs);
@@ -372,6 +381,9 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
 	if (!attrs)
 		return -ENOMEM;
 
+	/* See comment in kernfs_xattr_set() about locking. */
+	CLASS(kernfs_node_lock, lock)(kn);
+
 	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
 	if (IS_ERR_OR_NULL(xattrs))
 		return PTR_ERR(xattrs);
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 8d8912f50b05..1dc6663553d1 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -211,4 +211,24 @@ extern const struct inode_operations kernfs_symlink_iops;
  * kernfs locks
  */
 extern struct kernfs_global_locks *kernfs_locks;
+
+/* Hashed mutex helpers - protect per-node data structures */
+static inline struct mutex *kernfs_node_lock_ptr(struct kernfs_node *kn)
+{
+	int idx = hash_ptr(kn, NR_KERNFS_LOCK_BITS);
+
+	return &kernfs_locks->node_mutex[idx];
+}
+
+static inline struct mutex *kernfs_node_lock(struct kernfs_node *kn)
+{
+	struct mutex *lock = kernfs_node_lock_ptr(kn);
+
+	mutex_lock(lock);
+	return lock;
+}
+
+DEFINE_CLASS(kernfs_node_lock, struct mutex *,
+	     mutex_unlock(_T), kernfs_node_lock(kn), struct kernfs_node *kn)
+
 #endif	/* __KERNFS_INTERNAL_H */
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 6e3217b6e481..f183a96778b9 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -446,7 +446,7 @@ static void __init kernfs_mutex_init(void)
 	int count;
 
 	for (count = 0; count < NR_KERNFS_LOCKS; count++)
-		mutex_init(&kernfs_locks->open_file_mutex[count]);
+		mutex_init(&kernfs_locks->node_mutex[count]);
 }
 
 static void __init kernfs_lock_init(void)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index e21b2f7f4159..351a5101c862 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -76,20 +76,25 @@ struct kernfs_iattrs;
  * kernfs_open_file.
  *
  * kernfs_open_files are chained at kernfs_open_node->files, which is
- * protected by kernfs_global_locks.open_file_mutex[i].
+ * protected by kernfs_global_locks.node_mutex[i].
  *
  * To reduce possible contention in sysfs access, arising due to single
- * locks, use an array of locks (e.g. open_file_mutex) and use kernfs_node
+ * locks, use an array of locks (e.g. node_mutex) and use kernfs_node
  * object address as hash keys to get the index of these locks.
  *
  * Hashed mutexes are safe to use here because operations using these don't
  * rely on global exclusion.
  *
+ * The hashed mutex array protects per-node data: the kernfs_open_node for
+ * open file management, and kernfs_node xattr operations (necessary because
+ * multiple superblocks with different namespaces can share the same
+ * kernfs_node, making per-inode locking insufficient).
+ *
  * In future we intend to replace other global locks with hashed ones as well.
  * kernfs_global_locks acts as a holder for all such hash tables.
  */
 struct kernfs_global_locks {
-	struct mutex open_file_mutex[NR_KERNFS_LOCKS];
+	struct mutex node_mutex[NR_KERNFS_LOCKS];
 };
 
 enum kernfs_node_type {
-- 
2.54.0



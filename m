Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F029CD6E77
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5636B0088; Fri,  5 Jun 2026 08:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CF66B008A; Fri,  5 Jun 2026 08:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B29B6B008C; Fri,  5 Jun 2026 08:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89D7D6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:33:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B09840BC2
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:33:40 +0000 (UTC)
X-FDA: 84845800200.10.AE9319D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id F3F6A10000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:33:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q175e08a;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780662818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TRPxFGECnjw+M8/0IvOgB7NTMDasli+evg1PYVSz64=;
	b=wfywkigPiAcpegKhPj0jFYYmmvLhj3Lr0dsYAzOiee76td2KPIXfR7NqlZIMZA8rnJTOKG
	N3xugPN3u1Gz8QdflLzLwEdyn+LPFvqEZpi6pbRHOqnISundO93DgPOOwAlcMt2JvpTIQ3
	0asdEBTkx1gn1vlc6SOnCXO1TT+QO9c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q175e08a;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780662818;
	b=O1qHLD5P+4sa0qQROSlfvAqtjNUBRfj/VDLId0gGl/glVHd7Edm9J8v1ytil9C4co7NYy0
	Dg2ZWoKtjVGargJBqfopaEnpP4sAu+p04/ir8aaxf+tWotfkjGEHzEEn1rKjCHlxMN8kr8
	tVRTJSrymOB+s1Y1dkwdWVwj389mdJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780662817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8TRPxFGECnjw+M8/0IvOgB7NTMDasli+evg1PYVSz64=;
	b=Q175e08aiqRzw2HSFuiflZ3OTCrlIQtdZ53QBcPmrUgns908K6Iwi5bqb9YN6FOVj1yNAm
	s4x7X4g7cop/86idwqFKN2fjoaAEuSIFEj6Z1pA6sIpQIpOnqcscr4YmjqMlbuYP0r89F0
	dA/62DZgk7b0hiqrgtWWVU8Ig8Da/VI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-sbKcDwn5NI6keOR9D-8lCQ-1; Fri, 05 Jun 2026 08:33:36 -0400
X-MC-Unique: sbKcDwn5NI6keOR9D-8lCQ-1
X-Mimecast-MFC-AGG-ID: sbKcDwn5NI6keOR9D-8lCQ_1780662815
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4600cf05f07so22904f8f.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 05:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780662815; x=1781267615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8TRPxFGECnjw+M8/0IvOgB7NTMDasli+evg1PYVSz64=;
        b=ZzgQsjL36rh3vyGDQ7SO00MYh3tFXHyJwe/iRzrpqtF5qxx1JTwMfK3LlwPr91fSN7
         R4vb4c8pDbbLzs06CKaWBHfow3X0LUm/rvRNp+pcClAAvCatLpHae6eLazDCV6/Wehoq
         8t1Cd8LB5t0P5fi2sihCUrxY7Tui3eQllGcmwwRmpezY4R6uS2CEEY6+LoJteWfuw/ha
         GYUkIvSzwlHUdldZi/5N6Z+/JfuItp4RuqOy8YHSGr65h9Uink8ZsqZxUN5JKiK4rkWB
         jtuELjF/B5jNj+Wkx9phwzdpHZ7wDXvkNZeKCJBwaj1aoMq81KhQ81hRTmIA6jKo6sHD
         Wk0A==
X-Gm-Message-State: AOJu0Yzxu4D6fk+GM3etheiyXIOb/vlcEj4XD7vQomNtjp/tkAnJb0Zm
	6zxUE+pjvghDw3PRbX451yAmfgbRh6GNP2v2i80T+Jjqw816x2Z1PQK2FyWa4nMFn4BG7aaQFUV
	p3d6J/CTc0PDGsvASdgpFbLNvdCYvDpc9ttDRVPtzmtMki8PoheXf
X-Gm-Gg: Acq92OHlPB59Gamn+KsVmfKbCdD0BUkouQ4i2NgzFFRIFpAci3qKw9WDR3tDO2tWQdU
	ftmfVvAAEGdQTKZihtNuUP6LAMbiG1DVBPu9Fhfn/yQUp6O4IkHx9Qtc0pPhxcq4nWpr8JVaJqd
	db5hBNRkz6NUc5JTP6NtaxISd+VECYFpJjZY4O7oZRV8dssxCdw+o8LxdjugJeIusc2bSJRVtlB
	/EdaP9oco6B01XnSrpUMu9coJiguqidWqNJc6ODtHCt9FXWIASmj42dkAZA0DQaahPXXBONwAD6
	OVvzi0zDuhh1T4wqb+zJpO6gWLvEc1IwkkfKBkJdXlzCftSqmWYdW/Hx+IfxdDHFp0HFyrzPeQp
	9zWOtrCQlwHECZChdb3+ipUGo5oTgvP5CJjkRKHXW1Hjd+YqTRtybvUa1QXMhtwUdj5Ijm/SDEX
	jSCDh/iw==
X-Received: by 2002:adf:e545:0:b0:45e:e44b:3136 with SMTP id ffacd0b85a97d-4603063a715mr4149804f8f.19.1780662814711;
        Fri, 05 Jun 2026 05:33:34 -0700 (PDT)
X-Received: by 2002:adf:e545:0:b0:45e:e44b:3136 with SMTP id ffacd0b85a97d-4603063a715mr4149758f8f.19.1780662814217;
        Fri, 05 Jun 2026 05:33:34 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-1-92.pool.digikabel.hu. [84.236.1.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda3651sm12702780f8f.32.2026.06.05.05.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 05:33:33 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 1/4] kernfs: fix xattr race condition with multiple superblocks
Date: Fri,  5 Jun 2026 14:33:26 +0200
Message-ID: <20260605123331.2621677-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605123331.2621677-1-mszeredi@redhat.com>
References: <20260605123331.2621677-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EI4nXkzQbx7BX9yKRbMgysNHdOZ6QhtmR4DOJeivAN8_1780662815
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7jh9dhwam4mazuabymyijw8my57bim6p
X-Rspamd-Queue-Id: F3F6A10000E
X-HE-Tag: 1780662817-408651
X-HE-Meta: U2FsdGVkX1+92spLlaG7M9YMdEDuKpytHlQFErB5wYqMFviWhovkLYbMWjGs2cbOodZpxqUf1WWOW8B00a1opwir2sEZh3OlcDixiA0IA5JKHnwLlqgyXhB440AmL/BowUyfBgFzpkeSxQfRJ6irsQTiqhxRzXb44VeSXPH9fjF/+Gja34/vZwqgvhLboRNd6IzHZKGksQb4Xl1Vems8PUP7/yFkVGVa32hUEakqGL8ARUFD3jIma3vTKG4iKg9Q60apFee0SJ+1r7HLYb5ArNwtIf2A+VBAWZuFtD9xlMMoxUAhZ8GNzYdtn9vP5HX4H34WS46Gm0OxvMpwDab3mwJ9AXs2Eo/CmJsTaZd01H7yT+/wbBywmvg7ledojU/KKG9Gh4l9Yfhw3cjg+hWHhyrzqY/Gip2ShgiZ8202yErDu3ARmeayDnBNdWmxHLJy5p45U195+nQ2j5oi8Rxh+bQtOb+68aeEdaLbnnub7nA4fYREqUtxLytncbk04Ru4MlcqXqOoSsOuWCpXSK2t/VVwETSD+dKhjyoWcr3Uacb5NowgY6fROUNJlnAOjPr0OZjL+uEOmvyStjlG85+xd0rkUE7/RCJfZUPRxoOtyLsIfCz9gc5zAj+z6K28UNxALowj0e+j7tuscT3tj1D5L4I7L1uc2fpMPPw7ydbcv1nzHUEY1Pv3WNc4MsUShXV74fjupp8xOCaR2stg8nc0RRuB7jeRtKoyFzP75jmoJnjcQxLfQsszFtk+PweT/8rQvguB83MaDwUzNMqNC1QU6NVOKUoFhlzcbJ627yd1WOBFQath08Y4NCZs2mgufv++r8JdOZuA0xJhWR1MCdca7DHHL1xY8tRz36H+jzw7VENJIxaZnwxjOAqapE0W0VEyc5OsLsUtbGTJw97yDy9jUy/1ROv4ToOs6v7G939njeeKVsPEQwzlonqQabWZdDj7J4wPBbTIvqyAUTZjthX
 BfI/0Tqk
 hMyBLTtULDwWoHLzYHDZAPE8iQh9hxOm2iRTwDwKLSLjrh81XCZPzx4stJ6IH7K/R75c65ppfjfZ+72DvIZKF6LkELYiU1JY365t1p7DWGl29YKUIVGE5HdZQBb8kkKkDSLYkNGe3Q+GDOOND3h0DJU4OlzOgqYsBhtYpcOI1oVxJy3cUQI0DtwD3qhHDLWLM3MFCDXSxxAe1WynD0W+Sp2StXzgm0uhdVZ6vH5dKnlql6anaSgskXTFka8tRVloGHS3FUYWqZuHu2T1Pal6rrwiC5ikoQlOfOj5S6Hl8/gvi76xNExAjcVCYH/XOS+yJ962+hEAnFl70LUncmPQYYjFUEQHJMkhCMv70QR6wxh066e5bqC5DhUXdxp7IYqeqvulQEv7WolRe8VFMdjzEWs7x6Q==
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



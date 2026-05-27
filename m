Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01BA0CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 12:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D02A6B0098; Wed, 27 May 2026 08:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4808B6B009B; Wed, 27 May 2026 08:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3967B6B009D; Wed, 27 May 2026 08:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CCD86B0098
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:01:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A3BE161A5F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:01:44 +0000 (UTC)
X-FDA: 84813060528.05.BC1E677
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 49B39140024
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:01:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qg5TorfR;
	spf=pass (imf26.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779883302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QbCz8rR6YzSa7i52By5W+WoT1arBQd3V3OYvXGtxm4=;
	b=O/Pnk5jGvK2wJQYQGa3cp9qNEh+9+1+YwNL5BmMfd+0a2ZNchOTesdYhg9fsGR25TBm8Ac
	IVZJV1lrg10vKAy0+OpX9G4BpR9t96f/svGqcs1EMjUwFOFBumZ9HJ37AEDdzBH9VTdNiG
	FKv0PqgF7mPGi1gvqdwfFdrBHaJ5kw0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qg5TorfR;
	spf=pass (imf26.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779883302; a=rsa-sha256;
	cv=none;
	b=34bFosnSrIS6wneNiyeLLCT3+tqHprG03EeNKrfMSyByBT3CllShq8C0fLpVN3u/vkfVq9
	r343VVc5tiRbVBhElZJTP1odATYoD7DQ7mtqGTwBuA4FQkOBXnHLMq410cqSz9TWnxHdT/
	jn6UuT4SP4gRa+6KdAuMJAP8wU0Rp/4=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b458ca2296so86998305ad.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 05:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779883301; x=1780488101; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QbCz8rR6YzSa7i52By5W+WoT1arBQd3V3OYvXGtxm4=;
        b=Qg5TorfRUG09+53PHIeBIyTkfEU12TBzBb94zBemXJKfeKUmjIPZq/jJCNKnk19T8v
         WnUaXQqcEczD+1blDBe0WEicZMxJRP76XXi/7rJF5gThruOwmDQiI5RQz1IVXgbz0Tji
         Y08nZGJrSaQ/T3GFRCbLSrX1CxexjWhUwMww7iEGL+9ZgNLW5vI8zCzlbEv6LvIW4H9f
         YqrnChoupuS72321PkRNXzMwB8kaqu3prtBi1AD7g+jDCKxFu9+ZCuSg3u7x+kq8KXpT
         4z0FZ5PaZyavhxxrW4fl+IzTXBsavj/k+mYRj7CpVruWNB9Jfy5yGzEnEFM6nnhDOHjn
         cNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779883301; x=1780488101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8QbCz8rR6YzSa7i52By5W+WoT1arBQd3V3OYvXGtxm4=;
        b=UYRUYjfunQIVmC1p5PbAxfNBgwnBjvrKnVVRsMipPBSDsGszOQ5yg9tCb6nIF3L8Vi
         gpmPHQK76QgvxOA1PtGuLa8g5whovQcse5k8nmzat7nXTfkgG5JgPz7dE3gPuuskN/Wy
         hZ4C3IUy0cX1g/cm/h/I62UnwWRfohwOD1LrVMKlzA6O9EuJCXbscurSe5LxFnBZX1YW
         pMW+DWKYtCPE6nQW9b+CG55/UDdnafMjrgEPRnrPwhGKS1Zeydl4gmVOmyCsB/vt4J91
         mCxNU9LtfST6ppGLp0d6K3YsNQiQ5Nm/mGe1sHd7CHbVBZh9bZPlzM30YlQjS2i5Oo/x
         QggA==
X-Forwarded-Encrypted: i=1; AFNElJ8g4hbQZORN4cOAGi7WtkNC96Yx2pwM+XCdOCSsl2va5Cys0kimTazrb1rxBvS/pgzkG9ZkYJUCGg==@kvack.org
X-Gm-Message-State: AOJu0Yy9OiUCe4gsW1L5M2O2LsEfj7No14W4yKtJQgc6Ey1/Cl2/06Zu
	DLE2J80tWAcIGL0+Lvckh57KC0linKdGAnPSE/9YjFG4oTYeysZxh4ph
X-Gm-Gg: Acq92OHFym4T9j1jbs/NgilIC46kB9ndrUBPuDBFSr7HEatk64B9z+QXDMAy7Yxd5IF
	WSfBamfby5Fpw8xpMTTtjXScKU2jbowbBI2+xr5w1GZOWA1Kh4OntB/kos9w8JylgvoZmXEiKY7
	S9MaLjWBjumzy0M1B/3yWCsoyWRX8XDXKfcLTJZJYZg2UjFuBhOen1YgqOo4aqc8E03OADgph08
	cwV4h1NWOWeoe7knDclWHga2V9zziQWsSwKu7eudBbsT5uxO2kGkbZZGsZ7QQk2WyQe5K1TxQWn
	jJP6aS1QdaU9fczSnw62tlX7hz49/+bXDfyQH7hkNguMZ0/5Pzu3ANBlq859WIfxWCXrC0mPzTi
	jBBRjN/kQQSsXkbWfWHrzn/Bm4Axh6shIsmR/vi9uD3vQEoWalTup4L3oWM5dQ7hUMfKasWpVRH
	XbJfwt6rZBhNMsOGiTOiN2OezQBYzaU1lE07LsUOojDE/74XMz
X-Received: by 2002:a17:903:19e8:b0:2bd:b6f4:4500 with SMTP id d9443c01a7336-2beb038c123mr252408395ad.11.1779883301141;
        Wed, 27 May 2026 05:01:41 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56b5886sm136250465ad.20.2026.05.27.05.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 05:01:40 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 2/3] mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
Date: Wed, 27 May 2026 19:59:29 +0800
Message-Id: <20260527115930.3138213-3-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527115930.3138213-1-haowenchao@xiaomi.com>
References: <20260527115930.3138213-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49B39140024
X-Stat-Signature: ytrngmscoixoqn3jy8c5qy4mis7rjit5
X-HE-Tag: 1779883302-329259
X-HE-Meta: U2FsdGVkX186ISbvMkvvM+I+gymv21xdmRqZ44z0l/ECEyhcUAN+IILClUVxo0Ftrc7T7ivasau37MS98Q5roNEEvRRZfDOwPyMBDgfdDi83yFRtBOI/uugF7yFQHA9VSVc8CZb0hwYoP95VfCmj9tAdauClQ2oacwlyxckkl1MWA/f9E2rdGjETlxW2XSS6SkNPrcZatza7iv6BuUTLaMnzQioSM4rybGDLPoxddR5FJrEuqNimvbMF42wvbu4wUr0mPxQhH/gPSYBcDxMr5H77myW3s9sUs0IyO8dxb0oT/d1AmqlGEq7Ng2mi3C0CyfeKs8e7wEhTVlUQjqwv92Ghsc55xbFqUzj0/oOv7j6WTs6L5Np6O3v3OJ+h/jQI0Fep5EWYEG2AWSQYPE5NnD7WwpD2cDOXyXR/Nk35HNDSDHfm3/Nux+0lYHDFLqU/BcDMHKpCV92QJgDp8SZ/PKyYwz6C9WRMbG7nxB0oL6jhowDawTEDUYLRWt9eNM4+OWznANDWLufLZkuepvpEk1LVKFOQ4ZT/oCeCAkXR9GsGXMIxO3c4yRwoJQExbj4uXOOxqoR2e0yajTju8Ra+PPux62caNIxdpns9xTAU/8QsZDTzLgdoYrn1qXJ/rPI4qya9ZbZnALh+Xp5dbN9eAaEpuPXAvaKP3uWXUBYDEyQtWW1eIbdDJ6iPfN8g/5P1Lm1nYCULXDsOFnKiH9U2PAEiIvZkZ7maCwCnlupn3ZM7XvpintP+E/24r3pQOHc0ZJj33aYr2q/eMiW/xNHLKW50t4gkBUk2MRiQa0DHfoCPUDfW95b7CV4KQZInPmJ1YjXgnihkxM00XdTGINyAyLNXeAIteWPjeOgVySoXOrY9pS3btwSYVYcIlq0f+HXFC4++5vhCNPqQKAdaH4+pDjxx+2A9kAphwfei8TGQMufz9QlCeoJPrZ5eOZioQvacwYrCZLGDSXE5WkIN81f
 wbFimiqX
 7ao0kCzMF92YWTRyyHJrLh+ORXU4ZK41PFcJ6uEw6B5ZhJuSk6kdhJRy/scEoWelA5ZxS+okeVwZ7c61F45kSkTVK3CAq4wtUSr7UPKiGVQnCG8+mdg0TBJ+8a5+9B8JrEaLMVu+UeZs17oBGPLr4khJo/FrL3HgIvMfTEqBXO41tnEZdabslfBf1sc4zVeR2pNR9CyhJgNummibb14AWidXu1+vtMQC17InVw1KlVoYlhCYMMS/ouX+yAHKzY2LVJ7py0ZLAY1iiA/rEfPqEli1kLlatJOBv+npk6VOIsB1e1iu3BEBIzwoqeRfxNZ5iXYqBfXy3jCox6OJUFhR6JvGwf1qCiInx9Yw8zI7ZBs6TQm20BAUQgXSlzQLj4X2MGikKHBenna8l75Y4ICOLeVfqPFTCAXxYgT4n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With class_idx encoded in obj, zs_free() can locate the size_class
without holding pool->lock on 64-bit systems.  Page migration also
takes class->lock and only rewrites the PFN field of obj, so:

  1. read obj locklessly,
  2. lock the size_class derived from obj's class_idx,
  3. re-read obj under class->lock to get a stable PFN.

This eliminates the rwlock read-side cacheline bouncing between
zs_free() and migration/compaction on multi-core systems.

On 32-bit systems pool->lock is preserved.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 67 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 12 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6b0014b43408..88d10f814da9 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -21,6 +21,10 @@
  *	pool->lock
  *	class->lock
  *	zspage->lock
+ *
+ * On 64-bit systems zs_free() does not take pool->lock; it locates
+ * the size_class using class_idx encoded in obj and serializes against
+ * page migration via class->lock.
  */
 
 #include <linux/module.h>
@@ -1432,10 +1436,59 @@ static void obj_free(int class_size, unsigned long obj)
 	mod_zspage_inuse(zspage, -1);
 }
 
+/*
+ * Resolve @handle to its zspage / size_class and acquire class->lock.
+ *
+ * 64-bit: class_idx is encoded in obj and is invariant under page
+ * migration, so the handle can be read locklessly to pick the
+ * size_class.  Once class->lock is held migration is blocked and the
+ * handle is re-read to obtain a stable PFN.
+ *
+ * 32-bit: the unlocked load of *(unsigned long *)handle is not
+ * single-copy atomic and class_idx is not encoded (ZS_OBJ_CLASS_BITS
+ * == 0), so fall back to pool->lock for the lookup.
+ */
+#if BITS_PER_LONG >= 64
+static inline void obj_handle_class_lock(struct zs_pool *pool, unsigned long handle,
+					 unsigned long *objp, struct zspage **zspagep,
+					 struct size_class **classp)
+	__acquires(&(*classp)->lock)
+{
+	struct zpdesc *f_zpdesc;
+	unsigned long obj;
+
+	obj = handle_to_obj(handle);
+	*classp = pool->size_class[obj_to_class_idx(obj)];
+	spin_lock(&(*classp)->lock);
+	/* Re-read under class->lock: PFN is now stable vs migration. */
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &f_zpdesc);
+	*zspagep = get_zspage(f_zpdesc);
+	*objp = obj;
+}
+#else
+static inline void obj_handle_class_lock(struct zs_pool *pool, unsigned long handle,
+					 unsigned long *objp, struct zspage **zspagep,
+					 struct size_class **classp)
+	__acquires(&(*classp)->lock)
+{
+	struct zpdesc *f_zpdesc;
+	unsigned long obj;
+
+	read_lock(&pool->lock);
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &f_zpdesc);
+	*zspagep = get_zspage(f_zpdesc);
+	*classp = zspage_class(pool, *zspagep);
+	spin_lock(&(*classp)->lock);
+	read_unlock(&pool->lock);
+	*objp = obj;
+}
+#endif
+
 void zs_free(struct zs_pool *pool, unsigned long handle)
 {
 	struct zspage *zspage;
-	struct zpdesc *f_zpdesc;
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
@@ -1443,17 +1496,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
 
-	/*
-	 * The pool->lock protects the race with zpage's migration
-	 * so it's safe to get the page from handle.
-	 */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
-	obj_to_zpdesc(obj, &f_zpdesc);
-	zspage = get_zspage(f_zpdesc);
-	class = zspage_class(pool, zspage);
-	spin_lock(&class->lock);
-	read_unlock(&pool->lock);
+	obj_handle_class_lock(pool, handle, &obj, &zspage, &class);
 
 	class_stat_sub(class, ZS_OBJS_INUSE, 1);
 	obj_free(class->size, obj);
-- 
2.34.1



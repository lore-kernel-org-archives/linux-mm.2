Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2A1CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7DA6B0092; Tue,  9 Jun 2026 07:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFC16B0093; Tue,  9 Jun 2026 07:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE5B6B0095; Tue,  9 Jun 2026 07:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD686B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:36:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D070CA050A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:36:03 +0000 (UTC)
X-FDA: 84860170206.05.C343767
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id E5317180002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:36:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ecuCVuUC;
	spf=pass (imf06.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781004962;
	b=ohcxf9arPYMK968/OFP7g8lpYJJ7vvjmj2oGu0dMJr2bg6RDCcyx9I/Wsvjn3FQj59l55S
	Im836KdnfnIy//ZpBColg1LN9jcQVs+NnteBDOzOoAI8v0aHR6AuNie+knFtoxoFDiuqcT
	QxpNp6Labp8hZDvRTrRKO9HSxlXf8Uw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ecuCVuUC;
	spf=pass (imf06.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781004962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKDSLwDdGTSyq9QGc1Jp5iLqo9aL/jeA2DLoFosrfnI=;
	b=v/8ctQK/Ndcc7c5TXNwQ1Pu6uoMzGMgKVVeIQrmEoVPvnNzmj6B5OMkLa0G6zJ2WoUmPnM
	iYhEo+xGoVwtzprnHuNTvuTrmZHzSAkYKgXW08wiBLvX1yH8JpiTfm60AFcG9uyzTqb4r0
	ojeQA+8oEQJNJgWe5XvWvN+ycEvkyfY=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36c68964315so2612274a91.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781004961; x=1781609761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKDSLwDdGTSyq9QGc1Jp5iLqo9aL/jeA2DLoFosrfnI=;
        b=ecuCVuUCsiFuAbsM5h1VbPg+tRGpsZCpdOuEd/oZtLlGLxad/hJ9IbvZYMvCnt7bIP
         n6w6Fl752vJfrGVMpnxEJiIjvqHVys/nhI17zexxUuhbxSbvpfYyuptLPwqmiYi3DbIr
         DlFm99m4uT/3QzRIX442eumrIgJlKqvp43B0027V6Bb39Fo9wUZA2gZwbxVp8FzCdepp
         gB8aC7NYJbPX/8kkQCaq3mD5agR4ih0ZdvR7dnUYJ31Det0SM4526/ELdAVjKmBVhrvu
         1nOv21eMgU2+ckK64k/YVxMQ6l77tNlwFXySKu6Qd+jKu3oG9ky4H81QdNB7otDysnEO
         J8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781004961; x=1781609761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AKDSLwDdGTSyq9QGc1Jp5iLqo9aL/jeA2DLoFosrfnI=;
        b=sl3Rv6WGDUg5VC0DwwXfchVh/S9nCMeMR5UVXQEb6smD+Cez4ALn/a5xfJANywwGsF
         cBXvhZC6P0TfC2TaLN2yimi3nR/il2iRADgd9uPDfxwCR4ybgiXWF2figh0t4/qAz/nC
         wBt7+wXjCL4qCgI/j9wCMiRtJ6yQoxoHoYy1VhJg6f7dmgSxmEWxefKx2fjeosypL5Xj
         mA0FNo3DnWO/XAVbfX53nb5gpthpvzXCkNKRrcCJPYxbHcAOsNImRVbjwdXvR25smWTG
         EhosCizXmUarx5c7c3L0LAqr4a7RgEbPIDubPCrF9BfSByIyVhdmxCd0Ok/z9Ym8zkhU
         8XFQ==
X-Forwarded-Encrypted: i=1; AFNElJ9XIHOEtFSMQYBHRtrxzxCFeKsdrrhdIa1hwjwTCfCLWriw39HsSDpZzZuLz7Idjy/XMrolXfCYTg==@kvack.org
X-Gm-Message-State: AOJu0Yyj455e7wS5xuRLahDUxRUQoHPaGT2qGYO+plBDxSMYf3IU3SZk
	M6GT0U8yvxSprWKkYQfhnZyZGR7xkmAcwQJYympscWJfA/4R0aCZDKAM
X-Gm-Gg: Acq92OEGCY5CfH3WDUzMc7KufywCScP4/mJJmyjpzzBZzRfSQMivNq0CGrXFHnFEVf0
	USqfr0EFY+n7odIgLzHYWv9xkD6JtCtmoR6wUz1c8w7xEFeFMJ/qqPXXcCaEU9iDKgYcb7a1uUB
	xzP+AxXDuVpHUQflR3oBug1YOBbpjapTxaNyVzzN3h3fGv8lciqsz6V3qqI1kQ64Ab7sg6ALTPR
	9EqKGKRdiSpsqONGwRoNtycOe4VqkIgFAVGiO2m/DcXiDP8RWOn6WCsVtm9qFvzWJHX3wHD22QG
	VpGv+WqGK5Cl48aTIzL4SfIQ9rCCNuddczS621h7PEeKGLe+KrK67vPsCy2YnEUdsKGnW4Jijsl
	6ZRgqFJTufqTnuPmaik8Ledxa8git4ZJe8RPdAySG+WSydWxNln5iI04KwKJlQANniFi06qBUQK
	b/slHkcPR01SwjZNKfpgLkaagk8+stREZJDYEvI3Ks4hyfeC2WKg==
X-Received: by 2002:a17:90b:2dc7:b0:36d:cf58:b79 with SMTP id 98e67ed59e1d1-375211ae901mr3093505a91.19.1781004960720;
        Tue, 09 Jun 2026 04:36:00 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c668e98sm19655292a91.5.2026.06.09.04.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:36:00 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v4 2/4] mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
Date: Tue,  9 Jun 2026 19:35:18 +0800
Message-Id: <20260609113520.3507783-3-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260609113520.3507783-1-haowenchao22@gmail.com>
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5317180002
X-Stat-Signature: w86aam3he4qhx7r1y559396s6i34w8np
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781004961-32556
X-HE-Meta: U2FsdGVkX1+Uxh3fpI72BYbSw/nLVVNw5+H/PmKhbyH/E76N0H/G3WT9qxO9Esk+DMAK0HZ13A+aZVUXzN5V81K30sMbUPoDXNtMLhgoS3RB25nnVCszbWQEvO9jbqkoXI1ZWSw+mdGKMYGWWnm116FVbIeAWKzDh9YkMsjm2UKoh9uRJVOKouEDQSJTmtneXx6Wo6VTGN3sAoReXRjXY8tr4mJSclabC2Va2O7nCmWbRlTDZzKkEZ5BYEJ0p9tduJIDdCTb7zu1Ga1ewmNSMyXj5f0jj/kxarLH72AuPDGTl4Gt5zjPHc11pAK4IW+UD3yD2HyQZwvuyOrhC0nZEe7ep/TjMF75pCU7AjUoY8xTOc2qXwxVjzZR8rzYCle5FCdQatuVkoYavM5cd5zapc1Kk3rfAudC8PecSMkGDmmAQ3RFhcns8dkJ1po8zg4WCJF6xY7AsvDylanTm7a1iPG5js5pki6ZSeS20lUI3AEmFkAIpnx/6HJhMSRWQGqMuq5d8iFxn1hV8rNvQ9YQeRQ73sBQptsK8OZm5oY+z2RlajnM1+EXl5RI9avZ6FKt1FStFEB4Nb4kfD6Y645KUWrYttfmR8DGl35ScHl0g4hr5YhZ64epcuFbwYgccFtZgP7v4IXIP+EvHNt2JY+2+E2Xh6MkwAXuWNozazg6hXw9in9z8TyYnJBbnvvAxPU2tvMCxEgiXx3DWB+TKPEEmpHb9t+fUSpV9AVtRVvp/BDw73PPaJmKDpo38p8H6l+tM9dWYMO5vEBpePPycOectpRPgS3QAOgfla2dMy1lSLmpvWCrkF0wKO/yA+jvRUPqU8/exQv77/I01E2XHqR5U8pgjpeGb5WgKz801+ExUeDrx3QXnwFpN095HY12XmtLahDsZzkfAYurn89AkqKkPxezUT7MLBaJlGKMf9ATG5N9LG8Tkak5XEoLZx6S+m+cklmA9/dNs05ufyR0b3F
 1gzPRaWs
 i+ovrbKt6lN5ArlMuN/KNo5hRDhHC3EqeRpa3qPYYTLZqswM88zWVUwW5UeN9nueJ9VS08XZm0g6G4DvfAt3I3EgwTM02xEwvb9czMnyd6Snn1uGyw5Xu0lYP4JPBCAlHdesNKAHvLYlbvl9TYuGXDFFUa38ICXTbxyIhpWXSVVESNKdI4v5jsRvhmtWtee9dHmSW5dBU5rT4WNdX6YYvGQ8LuRpM9NltVko+qWJNGe5oEHdZ7NnltncH3IC8nQ0uqU88MuTFIeDZXqoMbsRL5+0IaiQnp83mlvxRCvmu3JrBAlaaqYEERyZr9IK+Ni+SfRAQ0j8Q8H6hetGMYjYq01H4M2A+DZcy1VMBkTNLEOkyAl/YusVOqxOYXhYcFZ8DzaZZ3h8vyE6XKX5CMUqyqFFnvKMTmZ4MZF3m4iaNt5JMczu1wChdrBrxFNtv5ESFZEJQxHBhpO5cWeeeYgdySjtbyQ+IIbEZTFkUw6m2T3npCWnwJC/s4WL5AfANUk8+B+GsoyNf4NFwDJRrsqplLONhXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

With class_idx encoded in obj, zs_free() can locate the size_class
without holding pool->lock on 64-bit systems.  Page migration also
takes class->lock and only rewrites the PFN field of obj, so:

  1. read obj locklessly,
  2. lock the size_class derived from obj's class_idx,
  3. re-read obj under class->lock to get a stable PFN.

This eliminates the rwlock read-side cacheline bouncing between
zs_free() and migration/compaction on multi-core systems.

Annotate handle_to_obj()/record_obj() with READ_ONCE()/WRITE_ONCE() to
prevent load/store tearing on the lockless read path and silence KCSAN
data race reports.

When ZS_OBJ_CLASS_BITS == 0 (32-bit, or 64-bit with obj too narrow to
hold class_idx), zs_free() keeps pool->lock.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 75 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 15 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f84258d63917..fe20ab297542 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -21,6 +21,10 @@
  *	pool->lock
  *	class->lock
  *	zspage->lock
+ *
+ * When ZS_OBJ_CLASS_BITS > 0, zs_free() skips pool->lock; it picks
+ * the size_class from obj's encoded class_idx and serializes against
+ * page migration via class->lock.
  */
 
 #include <linux/module.h>
@@ -457,10 +461,13 @@ static void cache_free_zspage(struct zspage *zspage)
 	kmem_cache_free(zspage_cachep, zspage);
 }
 
-/* class->lock(which owns the handle) synchronizes races */
+/*
+ * Pairs with READ_ONCE() in handle_to_obj(): zs_free() may read the
+ * handle locklessly, so prevent store tearing here.
+ */
 static void record_obj(unsigned long handle, unsigned long obj)
 {
-	*(unsigned long *)handle = obj;
+	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
 
 static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
@@ -817,7 +824,7 @@ static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx
 
 static unsigned long handle_to_obj(unsigned long handle)
 {
-	return *(unsigned long *)handle;
+	return READ_ONCE(*(unsigned long *)handle);
 }
 
 static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
@@ -1451,10 +1458,58 @@ static void obj_free(int class_size, unsigned long obj)
 	mod_zspage_inuse(zspage, -1);
 }
 
+/*
+ * Resolve @handle to its zspage / size_class and acquire class->lock.
+ *
+ * When class_idx is encoded in obj (ZS_OBJ_CLASS_BITS > 0), it is
+ * invariant under page migration, so the handle can be read locklessly
+ * to pick the size_class.  Once class->lock is held migration is
+ * blocked and the handle is re-read to obtain a stable PFN.
+ *
+ * Otherwise (32-bit, or 64-bit fallback paths like UML where the
+ * encoding is disabled), fall back to pool->lock for the lookup.
+ */
+#if ZS_OBJ_CLASS_BITS > 0
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
@@ -1462,17 +1517,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
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



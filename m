Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95FDCDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5336B0093; Thu, 25 Jun 2026 21:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADE66B0095; Thu, 25 Jun 2026 21:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75F96B0096; Thu, 25 Jun 2026 21:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7473B6B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:54:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 019681A0329
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:57 +0000 (UTC)
X-FDA: 84920395434.09.6B4A19B
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 482C31C000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:54:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NHchhBPh;
	spf=pass (imf21.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782438895;
	b=AxsxL0Sx215P+MbDF/615uy7xVuORfjcJYlOziipCye//EYJtVFzcqqKIicEhncy7dpPPT
	8TUxrPJxWWvQfli2fOiVkSMEPs+x+tF+zWwN87kIYd8jnWYvLJva9i8hYUGPELDXfSC2dJ
	JheJVup1BxPxet8lCCosDZbzptXGIms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782438895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOGgumAUzRKaLXDbI9Lus6CsTT3DqObp/qlyzB6MNno=;
	b=EUsgbExluX2cmqLTPjM8mifWRiSNaTeVOrJQzt5fDvsaQL57N+IeHgUOXKa9Jvvih47c/P
	Ai04BcEvRbKf+gzpbsOJfSoxUs3e3z5vz+LPcP3DZVZc83OsIJXT8JEGnexRhxI6TViVZI
	HMb203dYSrsf1WaFbnbvTMaJPOmkqOw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NHchhBPh;
	spf=pass (imf21.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c80879c36eso1974845ad.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782438894; x=1783043694; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOGgumAUzRKaLXDbI9Lus6CsTT3DqObp/qlyzB6MNno=;
        b=NHchhBPh2/kFiEQ3HvkbXW7CCEdGdli9VWozkJqz1B2tB103zhjgTgtq03noR5JdvT
         d/sezxr2QnWTq9AoDy453CpWT8zVKTDRnzw/NrdgVNbLoF1lkxL4dHMBnPBlzx3EQz5O
         lVRTtDGtxQnCm6x9WKO7yrJFNmJC9mDIWGHP2N7UG0vYuA6I4Q5V7CR6nwZU9gllTxXl
         E2Kkd4Bb2vtP8ROg9oGLzEspOszLoZCtLc8Bqd6f0Dm0gb6EZDV4W5mMUfULWgH6F/BO
         hskR0p1wKPNanJCfVIbtK/uH7fcXj/o7AC26Unywi17kAqYjAd88ze1hUs9zVIUDYMTT
         2lEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782438894; x=1783043694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kOGgumAUzRKaLXDbI9Lus6CsTT3DqObp/qlyzB6MNno=;
        b=KH3NmJsFkXeP5tAnF6425sm96f0TWku9+GqB7G4t/yTYLhEprPSBlqJRhkVKv0u7jv
         fxv/ODj2Rrxm0DDZ/nEPVMnoTA0dGsOn1HaGGsk3k5TwDfVz7pebABgWSiyYZHX9UQ5G
         cW+m+YV9VV3UyrD+y/jzHrI/ZveE31e2QiZCyUl/zW/jGPGbbZHwrG0crz4pCVTxwlqL
         Ga80hEJfhDHvCMQq2nRBsms8h45CNMSurbUVycbQJgg6xjAF9R9SGmiHTFPrAt3aW5sn
         anqgHoMptJB1Nq9mRBobvVwmJzoDuXNZA7ohSPT/YXMs2DixZXF9xtVzLSb7NZKG6ppz
         zilg==
X-Forwarded-Encrypted: i=1; AHgh+Rqc2OSraBI9AdYTz5Qx5dr2IlCXwLI6yzSFU/3wvb69JPaBoun8JgpWgnKOputzihTbLXflb6cGpQ==@kvack.org
X-Gm-Message-State: AOJu0YyOalJIYApl2YsYmEdxltOVLXgd+rJy6AL949TIl+ohrpSdPUf7
	wlTXEOKqnhMFoeNfjmaitA0tQHfEYEcr5KwigLddmMiiQirZywcVup7I
X-Gm-Gg: AfdE7ckFwqQCHFRbJJ2s9gFzXDY/bQoHFdWP/PyVyzJwxHQCstVDiKFUXvYC1W6XDFF
	C9ng2nVsPTtpytkjtAttZ0mnxxk9Vi95FuWN50VQhcEtoIsqVRIZ7koqAPA+3LKqKaCEBmt2VKY
	vn7e6UAra/BQcSoP+4ROB+t1KerNqcO6q7slYcoIDKOPJuRZ4Sk0xXtvWawB9j2Aye/KGoTYPul
	Ky9pTSUodNX7D1IB/O1N21/dbvuntgaycRYh52ejwHtQPhKzMeCmRuBsL3/b/14RM8ijFk5Wie5
	5HS7VwrJ0wuOIU0gQggZ6G0HeRmLGWXjakqTpDpt8h5xlKPFYRdAWcDCQCXT5F0uIXo1+5XM1HL
	mvpXOQTJ4lR6uqlajTwx7uqRS+ch6ASaEKSdMPibqSBHK3lVHjeY4jrK9LpoFGbcs2qvuKjKrAW
	67j7bNXZg3qX5C7hrXtQMD3Le7xQt3
X-Received: by 2002:a17:903:946:b0:2c0:fa52:1c47 with SMTP id d9443c01a7336-2c7c400fd0bmr121185375ad.25.1782438894198;
        Thu, 25 Jun 2026 18:54:54 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63b2bd7sm29047005ad.48.2026.06.25.18.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 18:54:53 -0700 (PDT)
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
Subject: [PATCH v6 2/4] mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
Date: Fri, 26 Jun 2026 09:50:01 +0800
Message-Id: <20260626015003.2965881-3-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260626015003.2965881-1-haowenchao22@gmail.com>
References: <20260626015003.2965881-1-haowenchao22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 482C31C000B
X-Stat-Signature: hgnyoroe18ncbotwtqks18y953jmcez4
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782438895-342278
X-HE-Meta: U2FsdGVkX192EpjA6XhGHBQKlOk/r7jkgEJX5u0ornLvtByLOadA/EMoXsT1v298gWYItjh4VCnXzjwQZzbwOtGP/l/OiR/0f/u4lyychtYV3RQmJ1AbzRgbbwDUs36c4PSls/GrX09xaqonc/TEvIUnb/vmxRawf1XmIY/XjkRKbkKFuXY+Dg8qAYtKpkVpteGtZz3jixNSckua70zofK13Bbfnjad3b/ANl1x7S/a5QO2WOFBDyuZNG43i2nhrX1tOJiIMrdbnUuxkTQGTkDM4yAZX1pvyJUTBOKQbGWdBDs3TfD+FoRmgXSzJBk0jzy8z6/AN8Key02pFiPIdVM0YULpv2212AB6kauxZBJ247SoZIQEgwYJc1jgA7PdOF6qGO3B0KmaOtCRcOm/2giyuQXN9pRzfDMHlZsG/XBcm/1x3YjvvIhHUGKqhD5LYC1SoL+bk4h++/4IxEPQVETsmHdFmkxpuz+qlvOHmgiVn6GiuK1tXe50KIK0f4nOXpbMTy/VoSiGVBrTJitH4LEaVeETdrgrWY16ph5Rst1BlGHWnGG7wYfjop3h6IdhsqY6/2rNT/Jl4nJI7mPn5yxaqSj+F8S63A0Q2fIcK7EtSYh5i3/Ngc9aeRH6hLuydYj/6EiG22C52FBLRSHicQ9g0KCw/cLxDhJ13Jr3VhrjbbA08E4EaC9KaGFwlo1CSgRAxpFds2S1AIIKmzD22SPyFKWJpivGlE01VI9krXhosePImCPxpv+OcAtTuFqxBmRgDLLt5la0QoDndbpcW5/nnf1tQPX6wlx4oBqmSE27/hgX4phh3hBwso4FG8mg/Qta4S3LM/V5Gjfr8ZLcLZj7CK5iHmeaoGkuN3OQe2owiOM5k6wEhBTLQdakzJ6ydC/2V+Y6tGFCWx+KPLFlvz/tzNiZrXGABIcBtBlXLuxRuelJWjQzCyigqzTy6awuBzQS/9rYmkwBp++g+Yxs
 Ox4PZDKp
 LDJJU6iDjYFa1pKTzVBolm9UhGnsmjRlYcCRj344PiDxhXnGvCvj5UZStqB3f+csnRxS2moyBwl1WfsAl/vDtrrngycuKYlKOVAPL5rOe7Mnibp6y0HrAGSNyQ7S1JKb3qzfMXrS6a1+INtbcu8u/BTPdA0S0nCWV0Xb5jp22RLJdll7E2UpTrtBROwnBjst2SroFk1VawV8+ksBuXDdMv4oKOOS0GtwtG/0mjPGFibB/kYpUx7GDWsFVLidcTv3RXXrMqLVYN0hP59zoqNVeg/JZuUnZ9UNYet9kYZU6/duk/Ze06jhIxLuTcZHMgvc/3HwVXvqqKPS1K6UbYG7+5bS09piRzDUbVpohaelfSe1YVzFUnIIto12ygw5fwlZ1ecns8JCtqhuWjMqFysHvbcYwuIKPQHYP+fjKAFHPKEX6dGNuiEWx4HWxGRLEXuC/1NVzQJcIPXyxehpyI03ZwWDy+9wHX7xLGK/KrfI9UzpkfyFIOD+Y0AJnpGOx1mW0yZPeqc7HUIQL5uhbap/Hzi7ui982aMm0xmMbd9hSp20Sa5MqMr79TUIM7UaFsyRhNkHLlsA+pm1F1Mw=
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

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 75 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 60 insertions(+), 15 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index c4fc06b259af..210a777081b7 100644
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
@@ -463,10 +467,13 @@ static void cache_free_zspage(struct zspage *zspage)
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
@@ -823,7 +830,7 @@ static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx
 
 static unsigned long handle_to_obj(unsigned long handle)
 {
-	return *(unsigned long *)handle;
+	return READ_ONCE(*(unsigned long *)handle);
 }
 
 static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
@@ -1457,10 +1464,58 @@ static void obj_free(int class_size, unsigned long obj)
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
+static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long handle,
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
+static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long handle,
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
@@ -1468,17 +1523,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
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
+	obj_class_get_and_lock(pool, handle, &obj, &zspage, &class);
 
 	class_stat_sub(class, ZS_OBJS_INUSE, 1);
 	obj_free(class->size, obj);
-- 
2.34.1



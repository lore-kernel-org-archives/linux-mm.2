Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB3CD29DC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 03:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0D16B0005; Mon, 12 Jan 2026 22:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72AA6B0088; Mon, 12 Jan 2026 22:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DA46B008A; Mon, 12 Jan 2026 22:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 949506B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:47:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3334DBF20B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:47:03 +0000 (UTC)
X-FDA: 84325554726.12.F6A49D4
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6322B20002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:47:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EzXX2hQL;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768276021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OG8CS3/xgGfJ8PQ65WNk3vWPobqgC7PlowynwQH/ywQ=;
	b=iccXR5AsAw2xCaqix9CN8yOWuntQBkzjh31LbvZ7PcAotaaHI/TfGrkRWhv4lrkk/gBg+W
	Tp524c743AfrTgODf9uyA2kd31J3PSDTL2chbVfobV5F77dNAEqVPVKYU5Y/tK2VdEgksr
	3dEVtwYNKXt4XZedLit8oG0gZ1IRl9g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EzXX2hQL;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768276021; a=rsa-sha256;
	cv=none;
	b=GiWKt02QkDFGHv2wf3QFA1WHoe71jwvKGp6A/187hYw3pQhsY5XdO793iL375wdhD+Or0b
	amjU1aSZDilmLGEkdN1li4eeD+Kgx4Sx2nNzTUMB9vKPG2vbml+ArZhs+N2VxwDV6bi5ix
	ngAQhoKS4u7M0kjBOHXzcZljLikqGgY=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7f216280242so1728270b3a.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768276020; x=1768880820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OG8CS3/xgGfJ8PQ65WNk3vWPobqgC7PlowynwQH/ywQ=;
        b=EzXX2hQLbto51xKrNsCPtunVGKjDyBmYSRyFcZylYHClaZVN/SplrYyppHuaev0Da7
         Xht4SnJ8Bjf7QrEHb81rgAKvM5zuezuhMRlBqgLo9SgEBE7irCqu8Cld3QXZkd1lqt6i
         FTlfcOtgQQtwlnortQpBf2SLdsp2It/0jDrfI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768276020; x=1768880820;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OG8CS3/xgGfJ8PQ65WNk3vWPobqgC7PlowynwQH/ywQ=;
        b=TwPDLRjBZzqMcQKjgyplHQNEciosBVHzKIVn2tGBMGlVTx50W9PQnmofV1A1pIAFEH
         7l/dIth3Jw3DilKGPTYsX0kRrO4GcnZ/M+DH1ZtBoDJr8OMLKEYP3sF8HTS+eDBMLAln
         asdH3rZY59gcNIDUaT87aQSuCxLvR/kgKx922HtucEkfqSYTgA4FytevjlbA561mKf89
         lElg4OlXtz3CETlLtoFjYoBKJcSx9JPVVFC/tFSIxuEaYNu3Q68R/DjFi1TG1Zpt4e/d
         SXUc9Ki0NyiXqIlUQCrwtc5DKLJBZLkvOV4JoNXzT5UW5fyFyw7YZTAsW3ZpKCaRWrEC
         7M3A==
X-Forwarded-Encrypted: i=1; AJvYcCVDrglFQo/oJ0HAu8eIV5nd/nDKUqeS9FCUqMAZotxdiPAvEI6g23Tuf2blqc6YrJsJtkhKAPNHNg==@kvack.org
X-Gm-Message-State: AOJu0YyKzfd7LprZsyBIg34DwGhDJZJ9YEGLprlsHjYFqbi6kfC5oJTb
	TtKuVvW+0EOpvHz429PNTW20UhcQSsp0oB2jcODlVVvnl9Qkb1tyb9XTJwHSejB+Vg==
X-Gm-Gg: AY/fxX4WffAp9sKeNulX1z7viTKocJh5LSlkTsgqq+MJsgf04/0MqO/hUFsz7jmX2wz
	K+D7svjZL9TedO4MPL/s6u/9Qud3gp8vTomh//0PmWeJ15tXFz6Chf0chng7SmcASF5tmcCHtWZ
	d5ulkPQaYpE2d4NnhpquCsitOLFcnKcfwmRfv6IleIP+CldCGwXaBx98VsL6u6ksUS2egW04Omb
	kQgW3QZxd4bkGLXtxCRC0PF7eBWcnZOeA8cycqR8GKGwcM60YnNiq+xqDEeC8H3LQds9NEnKb61
	C5WbVIzyeMzg0UeNOmGVZU6IJRsT1MqOAWXUkV8bGZIE/nIYlCL7ylhBRaRQgYXnCkbpM/sG2B6
	E5Gsnc1eYMwQXKrVIjFREGjrwh3T+HxZA7813tzISAtnnw6C7phvfSySHBVWIk4ZC7Fal44n708
	g5Y1owAz2PgmIEpPn9Tb6JFi83qxAB3gK4kOfuN20HbIbXHqxTNh3jU8g/tfAlRTtHocKRkW0+u
	8iWO0VjHUY3
X-Received: by 2002:a05:6a00:6709:b0:7ab:2c18:34eb with SMTP id d2e1a72fcca58-81f6f762765mr1084097b3a.12.1768276020136;
        Mon, 12 Jan 2026 19:47:00 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:3c61:f146:e418:e233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81f3fc40c1csm7448287b3a.55.2026.01.12.19.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 19:46:59 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] zsmalloc: introduce SG-list based object read API
Date: Tue, 13 Jan 2026 12:46:45 +0900
Message-ID: <20260113034645.2729998-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6322B20002
X-Stat-Signature: jigszfa8hzj7nz85x5t1b8ebacxr79m7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768276021-757977
X-HE-Meta: U2FsdGVkX1+1+UjrU4JiL/nrYWzUnY2s1TLSb0YSm6T6w7ZcWasWCSKTnljc/q+DxP0r4mxLj6kN8bR/G3/qOvKLBpgPCpHaa4Jf1FQx0ETMFyvK9kEj3CBfCO+2NUu6bsPbFZrosyzuvwCKU1eHcyg2PUGJaDv/SpmWQMwH9DyrXSREx0sbwZ/MQ1L3LwYUKMDvSoQGcV79UkBAsSKlcaYAWZI08i1XfRutgg8VD8tEMQukWhQGwxqJnPgTONkp36Mas2ULn/wjJhDgfc/J0QhVNLreMDuQhjHkHwCRla6KWQQjKUBzY8L0lMIwqxU69RpZt0Lwf789/3LG5PDPrKqFpnhU4NQEKpPJeri8foF/xJLrZ+uels9KOJC6bWEFBGzGrxUb3dpoNX9rP3U+BxIDAoyu5K4TYwxaSubc30oBTAmvKczSJ7WKo555gG78jYhLgqUiHJQz/DPFCAx/VWKTCiL0URcFfUWXLRDGU/+qvQyxlx1H0tQDYuKdgA4T9cYDyVe1WtWLqT+NS3lcQ0Gtd4Uy6K4hZU5k2TgN6ZBa7btlxsH3+r4C8q6OjSYjsMHt1HN/rpGdgGBduJnAzOX1gEE9+qYJY7HJTZlk+OmrO80Nw6Ow5n6J/8BarZmwZ6R4wLLRF3XRUKoZuE/v7UqHf+knEwSFbv20RLGDQXp8pLbTt7MzZ44ai0O56/rduUuMlJVZODSCq5TjblQE8M4jnr2nIBsj75Fv52qVR9fkzMMYrLziNZECT1QId4grKU0zHDbTsorQ+++nyxwfVhvH38pxiq/bFXcDn4VYhI7iDTpg5m3mFzRniBLsJANww0wyh5Sn/VELwZIUIgRAhnGFn7/EdxGYuhFjizFamwwlxboXG56tkoO1IWIB2EGF9Q/f4l/P7HXqJJ506QD1r32pldCeVAqEfgshnBTi/R72i39WcVumBXOTsFMfNrd3NzDy2X+b6Wgst3Yhe/8
 Xg4aYr5x
 PPUwdzFuMjFO9dkM0taBgxbqNU2JWCbGGARxT4QZm7vNxq/P/367aIAgVZdISBLKFleqTo5OlWUiLJIbVaGet74CG63IkRlOLeWZS0w9VNA7DdoLJTwL8FSqtdsjBTHDkop33WsPNYtITTpQ7CmtjfFoELnuyweAcqpnoYwiItcrqtY2XgVfFqarA9dlZ77zFwFyD41rLmW2U4DtlVwZs+0o89Wqk2E28Lqat5JVDJhFMWrKOmyy27A0Tlc7DqxxSntbbZ8NHDEerJUxm88xzRKwjaxcS0dXTn+MwR4cTcCpRW8juN5SEnvrbQfgSkoqiAochDC4VNx3zUJfJbGAqUMxjD+7zl+JXhgD4/T7Eew14iAfDwAkFskkVOTEhqJ7RPs5Y71BySbcGsbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, zsmalloc performs address linearization on read
(which sometimes requires memcpy() to a local buffer).
Not all zsmalloc users need a linear address. For example,
Crypto API supports SG-list, performing linearization under
the hood, if needed. In addition, some compressors can have
native SG-list support, completely avoiding the linearization
step.

Provide an SG-list based zsmalloc read API:
- zs_obj_read_sg_begin()
- zs_obj_read_sg_end()

This API allows callers to obtain an SG representation
of the object (one entry for objects that are contained
in a single page and two entries for spanning objects),
avoiding the need for a bounce buffer and memcpy.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/linux/zsmalloc.h |  4 +++
 mm/zsmalloc.c            | 65 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 5565c3171007..11e614663dd3 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -22,6 +22,7 @@ struct zs_pool_stats {
 };
 
 struct zs_pool;
+struct scatterlist;
 
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
@@ -43,6 +44,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 			size_t mem_len, void *local_copy);
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 		     size_t mem_len, void *handle_mem);
+int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+		   struct scatterlist *sg, size_t mem_len);
+void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 16d5587a052a..5abb8bc0956a 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -30,6 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/sprintf.h>
 #include <linux/shrinker.h>
@@ -1146,6 +1147,70 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_end);
 
+int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+			 struct scatterlist *sg, size_t mem_len)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj, off;
+	unsigned int obj_idx;
+	struct size_class *class;
+
+	/* Guarantee we can get zspage from handle safely */
+	read_lock(&pool->lock);
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+
+	/* Make sure migration doesn't move any pages in this zspage */
+	zspage_read_lock(zspage);
+	read_unlock(&pool->lock);
+
+	class = zspage_class(pool, zspage);
+	off = offset_in_page(class->size * obj_idx);
+
+	if (!ZsHugePage(zspage))
+		off += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
+		/* this object is contained entirely within a page */
+		sg_init_table(sg, 1);
+		sg_set_page(sg, zpdesc_page(zpdesc), mem_len, off);
+	} else {
+		size_t sizes[2];
+
+		/* this object spans two pages */
+		sizes[0] = PAGE_SIZE - off;
+		sizes[1] = mem_len - sizes[0];
+
+		sg_init_table(sg, 2);
+		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
+
+		zpdesc = get_next_zpdesc(zpdesc);
+		sg = sg_next(sg);
+
+		sg_set_page(sg, zpdesc_page(zpdesc), sizes[1], 0);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
+
+void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj;
+	unsigned int obj_idx;
+
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+
+	zspage_read_unlock(zspage);
+}
+EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
+
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len)
 {
-- 
2.52.0.457.g6b5491de43-goog



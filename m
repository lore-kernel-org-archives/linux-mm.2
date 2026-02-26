Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7D3FCE08C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908AD6B020B; Thu, 26 Feb 2026 14:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B4E6B020C; Thu, 26 Feb 2026 14:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BEB36B020D; Thu, 26 Feb 2026 14:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61AE96B020B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20A71B3D3C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:49 +0000 (UTC)
X-FDA: 84487597698.19.AE44C26
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 47BD740003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LhexHG3+;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTFgJFJwcADBwm8xdyLgLzJR5Ju+0hDvZcOEI0tPhVw=;
	b=0YDrHfWZM0C9dUCm04rE0WffgSPiFZ+XuzVOsunTl5J/dLYhKww4PssDVnPjkHPXltgXlA
	g2PlKzgS3w+ODxEyJHU2XFJoIr9J7dHvCAHQYG6Jo7/J3M6jAbxPA2eZI0PABsCraEfGPn
	geGqm60ZBnhxxqYu6O/QYl6t7uDm7fU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LhexHG3+;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134187; a=rsa-sha256;
	cv=none;
	b=3Qh+I9hyhyE4Ty83HURNc7+dGMF7KduD472TUuWdzh/YOPPUBNM6s5WbCPof1/OAyTrjng
	DaJYXO41RZdUkzc3YK1afzlJuv+6dNuhhcuDcMWmWtzBhu42fcZkBT4QWJHzUufk6+cC0U
	ysC7+iIwTy9w9GeDys5ZREYcBDUkugY=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d195166b2cso1052282a34.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134186; x=1772738986; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTFgJFJwcADBwm8xdyLgLzJR5Ju+0hDvZcOEI0tPhVw=;
        b=LhexHG3+BzsO/EAwUP0P+JoGnuD/lrUJ2lOT5lZ/dC9nGmTPWoDgpFhkNby8JlmaR5
         sQoJ2PGDSc0xaIInL9Ln8pdFGMPAO77v7TMwvNW1KFCs3xN/R0leJByKfRwirjatUndr
         AzDhn7Sxvfx24+GN3m8nCLn99Itg+EPuX7YUllFV9Hmek3GjcUZg1A9XpM/JFg/Kp9hr
         +GHAiioq3sGjh2EoEuKqTcf41f7q100cTYtFsAK0omNn9+AIdV1M7hr/gKRyDAD7VU83
         tEc34JQrKJsjk5H7F19zHLJFKlyXpcIe/CJ6VBEAyYp+8Xr3C99RKYsTju7jSFoCWi+x
         j6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134186; x=1772738986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MTFgJFJwcADBwm8xdyLgLzJR5Ju+0hDvZcOEI0tPhVw=;
        b=bHrVRZh68d98BtAdIu70d7JfiKo5PBpq9bAjVHXsGpnAWtzS6aTXWrKbCBEvtm/aPu
         G5Yv3gQR/GfwlIMhybGykP5Yd+ekFnOkDmSHWfEwS0MO/rwgXr5UlKwiSuW0TZxk552r
         xocfoOC8V3gdaFT2EcfKE5+dgVbRTu0f6tzFAzb/fiuQOnUj0w0CZu/6IVxYckkBY4az
         fCOXQZ7im5OUXIhsmCL0Lk5h2VFxIJk9n84QL2nyE9fXtaoHKnnx5OLL4YmiFznxsb5D
         61wHwwnvANQxFojdRAMnNDlTRfKVIgSv/VJz5cLkkojj8Cvo46/bCTSnzC3RaNlQKRgo
         o+wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUR4kq1MCrtwkuTWN/MjIs3giLRH53/lUYFney7E4Y5OzFx6ReiwQWCWtLE18b1PpmZx7jh1KA9g==@kvack.org
X-Gm-Message-State: AOJu0Yw3S08YfO5ZCqLoz7F26ZntJosl59IJL4yhTKnhDmjgtdA9/iSe
	9PTn5hUMfH1a/ahZ36WF1WczH7NhB+p6+s9jnrZeSJblEsBqyOdtF0QE
X-Gm-Gg: ATEYQzyxtkYFldBlCGIAnJ/ePzZC5z5IKPyKUlvQFVDXVtzbm5ndGehQlbpOfQGmUHE
	VM2W/Hua9Fj1+0L9Dm3/r0tmPJw02WIxKzN9y42dYg3QXTLHT8hv8DomfwpqPKukyB6HtNLH6d6
	PGXLNDWaXzNxwW6Whok/DzLppiP5kjn8ijVfp2XSyB1DsY1IkPpxVBv5cASUrsab4a97rCoOz7m
	P/rjLsBXLJKspkewlqTykcJAVoN+2EwZgbTAOQcaHkSZi20QTEfrmN2AM8pm9jX5Ap/7WOnJCZi
	ZISZ0XDunm5PMqOkW46btpAwAAVxW8msaatRT3Zea4nYOK4bqvJ24Po4fG6TnaO+Wmnc1Yhg2p4
	sf2AJT1CkSeQ01q1kOFezUuIq7PmIm2DdfLRBeN1LcTH9zuaobzXI1s6j5xA0sWf3cCtSWhfJew
	TPbgCb6N8hZpk88UzbhRSK7A==
X-Received: by 2002:a05:6871:7402:b0:40e:9550:3242 with SMTP id 586e51a60fabf-41626de807cmr252273fac.16.1772134186118;
        Thu, 26 Feb 2026 11:29:46 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5f::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160d21196csm2606670fac.12.2026.02.26.11.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:45 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 4/8] mm/zsmalloc: Store obj_cgroup pointer in zpdesc
Date: Thu, 26 Feb 2026 11:29:27 -0800
Message-ID: <20260226192936.3190275-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 63dmkpqxshpgdiagq3qhcrsqfid3nr3h
X-Rspamd-Queue-Id: 47BD740003
X-Rspamd-Server: rspam10
X-HE-Tag: 1772134187-669051
X-HE-Meta: U2FsdGVkX1/TDEzE/G684RFc+pq0z518PmIrGTZwC+6aXnPVb0iy/dc0KIPfmdmY3YeDFKWs6FZFW0XANwdggVF0yogGAAE17vTnQU1O5vbrnfEs2YV6yfeEQW6uuFmHJ96eUY0fHR8vxB7EZ1U8i2h/z7BjXMeilsGiMboxyQwMe/k7eN2cL956N9/fpDo/EPg2g71bK6VC9uz8ZjnHGoWCpOin2oFLsqqPeipxnpnFnA7RDEv+l1ynH4l78jKtn2DAttD9fHyD28/jGU7OwjufjaAYgP1u+1+ee7oCaoGW41/LL9VJjHGXiwb1WhrPDlS/S1XTQ8RESF9juwWQ2fnT+IqJxSmxLYfFHitGSFveV5gKwxMFmPC9QzITjpQCzGnsjmNY2xBJZwaWDW1PWJQyB3RipLxOE1/BNdOXLiI8BJl0zJcWyYf+7O6IBHTz9biDUJHnwCNtyvDq3UrKJvjkO+OoLsMgE5IRS2WgbMOncbrs3D/AObN4mYCEc2TAAcV//6vmdFQ8i5FgwNLYO/HzVXOK2Vxq0mQ00lkYeW8V4qLqupRsTCPTX6sAtQbHMo7S4xezEsNTgUt9OIP4mQFs5sfV/PavV/i668/yLQFu8N/V8zqS4kYvpbI+vOiqlirqxa04R5hKic6G1HXD6m0SReLlBk1M6IxN4aYpGZ8CNM3Sh/qzuRchQtnvtIVryKAJ3fKTdusRrvoxn57RXMyKlOxKuQzy8A4HtjQ2jzVeHZtO0W0+nVFr0+4Y6SVoWF1HmoEO2GuEzScRqdkODdrA5+f/c83rO0HBnM3FeC/wKsmWurQ8GU9yarRR+lj0G7q6zsTHYayq6f2PXQpyJNuj/Elv3AXaBN4tIS+Z5Mie3JTTBUn0QVywTp3By469/znfUvqFOgWDeuc8wqe4oPdXLMwuCBIBE6tXFuRvyOM+20KR6HB6gviAUGb7fu+hd+OxNKvnqiqYUYUA1TR
 MulUIrsG
 fDo7uNXFPiwD5tV7tDUaS3ilCJHt+Jy/JyLUZ2EvwTexNIZ6or5zWpoSGzUdIs3CEYnyazhFGH5piFTTe1kJmBieN4+ZHenJ3KjsxTcH9pu0U+/EllYKD0vCE0uGI+rzclzKQEX6u6Q/mb0x3BM3XHLXY7SzSctZ+2QFkpZvfzOYVElPx/lpGJeBpHqKglbq+2FHZEnVeVXzDjpzpPcp2/XV1JPN/VzvtdjGQpJfPTylImXSfO6kUatTtQfjgEEg8YruSWtZJrjMGUa2XhxySzvQC9CpEBnDeP3vJPyd/vt0cajR5tDpYLjnu5vrcrsyMecVC+hkiUz23c++686kc9wCyWaT8LGhXSshf13YcR26eR5bIbVGo7H3Fqa0UjdaGaij1PtTStbLL9kDE8Iz5dV0IKco/l/zqe0HHGP5FTnPBjnAFP5fJTxapO9nxN7ZdFRYOZKk+H9pv0AMvPN1ioJ8heDPucw58NkldBGDS67i2Tyxdswyef2vTzPPPCVIl8l4XAUQe5tD+Aar0U2kH3QDKKNjBD/3BBFiGGfmoKe2KMXSx1z6NOhm6BUcKTltzl8W4PJVI+DlwJASea24t8C9b1x7onjCEEMQp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With each zswap-backing zpdesc now having an array of obj_cgroup pointers,
plumb the obj_cgroup pointer from the zswap / zram layer down to
zsmalloc.

Introduce two helper functions zpdesc_obj_cgroup and zpdesc_set_obj_cgroup,
which abstract the conversion of an object's zspage idx to its zpdesc
idx and the retrieval of the obj_cgroup pointer from the zpdesc.

From the zswap path, store the obj_cgroup pointer after compression when
writing the object and free when the object gets freed. Also handle the
migration of an object across zpdescs.

The lifetime and charging of the obj_cgroup is still handled in the
zswap layer.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 drivers/block/zram/zram_drv.c |  7 ++--
 include/linux/zsmalloc.h      |  3 +-
 mm/zsmalloc.c                 | 71 ++++++++++++++++++++++++++++++++++-
 mm/zswap.c                    |  6 +--
 4 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 60ee85679730..209668b14428 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2231,7 +2231,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	}
 
 	src = kmap_local_page(page);
-	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
+	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE, NULL);
 	kunmap_local(src);
 
 	slot_lock(zram, index);
@@ -2296,7 +2296,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 		return -ENOMEM;
 	}
 
-	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
+	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len, NULL);
 	zcomp_stream_put(zstrm);
 
 	slot_lock(zram, index);
@@ -2520,7 +2520,8 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 		return PTR_ERR((void *)handle_new);
 	}
 
-	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
+	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer,
+		     comp_len_new, NULL);
 	zcomp_stream_put(zstrm);
 
 	slot_free(zram, index);
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 8ef28b964bb0..22f3baa13f24 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -15,6 +15,7 @@
 #define _ZS_MALLOC_H_
 
 #include <linux/types.h>
+#include <linux/memcontrol.h>
 
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
@@ -48,7 +49,7 @@ void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
-		  void *handle_mem, size_t mem_len);
+		  void *handle_mem, size_t mem_len, struct obj_cgroup *objcg);
 
 extern const struct movable_operations zsmalloc_mops;
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7d56bb700e11..e5ae9a0fc78a 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -899,6 +899,41 @@ static void init_zspage(struct size_class *class, struct zspage *zspage)
 }
 
 #ifdef CONFIG_MEMCG
+/* idx is indexed per-zspage, not per-zpdesc. */
+static inline struct obj_cgroup *zpdesc_obj_cgroup(struct zpdesc *zpdesc,
+						   unsigned int idx,
+						   int size)
+{
+	struct obj_cgroup **objcgs = zpdesc_objcgs(zpdesc);
+	unsigned int off = offset_in_page(size * idx);
+	unsigned int zpdesc_idx = DIV_ROUND_UP(off, size);
+
+	if (!objcgs)
+		return NULL;
+
+	return objcgs[zpdesc_idx];
+}
+
+/* idx is indexed per-zspage, not per-zpdesc. */
+static inline void zpdesc_set_obj_cgroup(struct zpdesc *zpdesc,
+					 unsigned int idx, int size,
+					 struct obj_cgroup *objcg)
+{
+	struct obj_cgroup **objcgs = zpdesc_objcgs(zpdesc);
+	unsigned int off = offset_in_page(size * idx);
+	unsigned int zpdesc_idx = DIV_ROUND_UP(off, size);
+
+	if (!objcgs)
+		return;
+
+	objcgs[zpdesc_idx] = objcg;
+	if (off + size > PAGE_SIZE) {
+		/* object spans two pages */
+		objcgs = zpdesc_objcgs(get_next_zpdesc(zpdesc));
+		objcgs[0] = objcg;
+	}
+}
+
 static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
 				struct zpdesc *zpdescs[])
 {
@@ -927,12 +962,40 @@ static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
 
 	return true;
 }
+
+static void migrate_obj_objcg(unsigned long used_obj, unsigned long free_obj,
+			      int size)
+{
+	unsigned int s_obj_idx, d_obj_idx;
+	struct zpdesc *s_zpdesc, *d_zpdesc;
+	struct obj_cgroup *objcg;
+
+	obj_to_location(used_obj, &s_zpdesc, &s_obj_idx);
+	obj_to_location(free_obj, &d_zpdesc, &d_obj_idx);
+	objcg = zpdesc_obj_cgroup(s_zpdesc, s_obj_idx, size);
+
+	zpdesc_set_obj_cgroup(d_zpdesc, d_obj_idx, size, objcg);
+	zpdesc_set_obj_cgroup(s_zpdesc, s_obj_idx, size, NULL);
+}
 #else
+static inline struct obj_cgroup *zpdesc_obj_cgroup(struct zpdesc *zpdesc,
+						   unsigned int offset,
+						   int size)
+{
+	return NULL;
+}
+
+static inline void zpdesc_set_obj_cgroup(struct zpdesc *zpdesc,
+					 unsigned int offset, int size,
+					 struct obj_cgroup *objcg) {}
 static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
 				struct zpdesc *zpdescs[])
 {
 	return true;
 }
+
+static void migrate_obj_objcg(unsigned long used_obj, unsigned long free_obj,
+			      int size) {}
 #endif
 
 static void create_page_chain(struct size_class *class, struct zspage *zspage,
@@ -1221,7 +1284,7 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
 
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
-		  void *handle_mem, size_t mem_len)
+		  void *handle_mem, size_t mem_len, struct obj_cgroup *objcg)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1242,6 +1305,9 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
+	if (objcg)
+		zpdesc_set_obj_cgroup(zpdesc, obj_idx, class->size, objcg);
+
 	if (!ZsHugePage(zspage))
 		off += ZS_HANDLE_SIZE;
 
@@ -1415,6 +1481,8 @@ static void obj_free(int class_size, unsigned long obj)
 	f_offset = offset_in_page(class_size * f_objidx);
 	zspage = get_zspage(f_zpdesc);
 
+	zpdesc_set_obj_cgroup(f_zpdesc, f_objidx, class_size, NULL);
+
 	vaddr = kmap_local_zpdesc(f_zpdesc);
 	link = (struct link_free *)(vaddr + f_offset);
 
@@ -1587,6 +1655,7 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(pool, dst_zspage, handle);
 		zs_obj_copy(class, free_obj, used_obj);
+		migrate_obj_objcg(used_obj, free_obj, class->size);
 		obj_idx++;
 		obj_free(class->size, used_obj);
 
diff --git a/mm/zswap.c b/mm/zswap.c
index dd083110bfa0..1e2d60f47919 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -851,7 +851,7 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
 }
 
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+			   struct zswap_pool *pool, struct obj_cgroup *objcg)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -911,7 +911,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		goto unlock;
 	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
+	zs_obj_write(pool->zs_pool, handle, dst, dlen, objcg);
 	entry->handle = handle;
 	entry->length = dlen;
 
@@ -1413,7 +1413,7 @@ static bool zswap_store_page(struct page *page,
 		return false;
 	}
 
-	if (!zswap_compress(page, entry, pool))
+	if (!zswap_compress(page, entry, pool, objcg))
 		goto compress_failed;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
-- 
2.47.3



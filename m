Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 415A0FCE076
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125CC6B0208; Thu, 26 Feb 2026 14:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AF936B0209; Thu, 26 Feb 2026 14:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EFC6B020A; Thu, 26 Feb 2026 14:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D28A46B0208
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9935F140212
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:47 +0000 (UTC)
X-FDA: 84487597614.29.E10B6E0
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE9F6140008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PTInsm4G;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gW6bnOf4saMn/cuTsdPZSzO5iSHkVVIBXAzg98Lfp08=;
	b=J3G444lFs/7mBu03fCa9/hIO0dRArgpj1YqvSy5cocUFNZNdb3LqnT0yAasgMEzjlhiKwT
	D4D7OyfSn4gl4FtHykLB2b0+ka2ArstfUZOlcfkoaK/zRBApJcJvMjh3oFpv6RQYhbdIOt
	BakIPW7QvmRwig15o1gg523izdDdCcA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134185; a=rsa-sha256;
	cv=none;
	b=SpU9XRx5WP6EaVjq8DmxDbhHefdb4Hrgc0MI2hy4M28qrMNBp/q5IstIGvDVu9E+fZ6P8B
	3psEHP9R6fGUiEeFF2ISDUhegsDGJVe7FHOL7NWaMKWMqcyewoTHOA3slMWrxoB8RdjBuh
	gpDERCoZL9i8Ier0xEY2JpBzCy5idTk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PTInsm4G;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-463960df4f9so978969b6e.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134185; x=1772738985; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gW6bnOf4saMn/cuTsdPZSzO5iSHkVVIBXAzg98Lfp08=;
        b=PTInsm4GjQ4RQ3uCHJU7cFAJUo+u13ptjYeQW1BJ+JfWg3uHLWIams2ULOs4hml6Ww
         uLYdvgcEoGJqiBjSD78Jv+Un/MWz5h/v4+1+MK1EYBVRu/h4lUXzxKnRlFWUV1AwKMQ/
         6jcUsXkAjC5YoyhV7fHHxjxtRjnpxUJyw9Y76zGSq4nOLq0P5OIo0fe9FtFDoiFkIxLd
         zCZCT58iXbsjtv+eeb2OBvcrDlwi+7wUpruOsdJ15fSKohSDhuMyHDIkihGYLzZMrof2
         Pvor5FhXvR98F4P+DkH5zU6nVDUTN3ARNjfwo3QgdO0IIaLFtKLNyLt7ljbOOj6rLJw2
         80qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134185; x=1772738985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gW6bnOf4saMn/cuTsdPZSzO5iSHkVVIBXAzg98Lfp08=;
        b=MdlaSmMOb2qBwwRQH5VWKOSX4K3gKsTg41v3oVL453gKS50fGR/fWWEwaz7AIjAmzs
         m/C+GCo0yAth9PZLNfBxGy59VU/kDcinbV8N8HRhkXV2CBcVMiC7nF6WZEWkflh/+MK/
         XJLUeHGpZvrzFqM1Cmg3M/IdQ0c4ZEku/pOe2iiUrCRQtmZ0QeVxK64FUKhl3ehIhm5w
         Vzv6PNBg2E1YrO1PO4wRxFhkOF4wR8gLTiy+VK3gupi/ldaeE9hKdOCSXX/5S1fXidIe
         Anh5bBuxsXKJfz/sqzYuGVNaQOyQbD6SQ4eV/WwxCUhIeJPMF6+c1eMe06RfdDfO089g
         G43Q==
X-Forwarded-Encrypted: i=1; AJvYcCV4YmxtWsjDvXVBQuQSbxTcsnKKfZpw6nyLAmZqWt2iTl7fCPRww3kspOH/kzchxCC++zRKCVd8TQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6u+jJ/rpsVw9YiVteRN2ZYtZGd/ivNmJ284oNL6iuLA93unV7
	oYEy46JMCBRjKAsfDtWi13onn5MR7Hlxt+dQHwPNpK8ja3FR7gXm8kQF
X-Gm-Gg: ATEYQzxpXfZumdw3jPuhteIf9hF7Gshr1K8h/CgnK/ZdnI9f+sEeVF6lL4+rb+EBkKf
	bG0h2VC5bd3no862uEQkYnX9A985Wqi0Jemcb++wylTL20g2SnQxE1j0bjAgCvv5XfZ1sjGfwrO
	at91E9QFBoAgm4Z3SSWQc37cWlSldGLd9H/xVJ/pqlY7+xfsMnHjWlhnGBHvELnpq2yAfKllw51
	yuFHWRzRDlCQe3pAWdC5zMEQf2MmxjriRFSdNGlEx9fTxlrMeSSfbV8Jk3IRq7BV06vlsqsJ/ak
	3FWIQWUP/XhFofddePl5XDUCuTg+ve7oaZSF5uTkkp+AYRA20WmZWoLXG5YVbuYg2yXUxdDy4Kz
	qUSy58UQujvyl0CyMHYQQdmFZr55EirkZH3YB8ONe9iS4/f82rz+2Tajs/Xri834vpJ7qDOhUKe
	d3jCwnSfKa3y56ChOb1P2l
X-Received: by 2002:a05:6808:1907:b0:455:8400:f078 with SMTP id 5614622812f47-464be9d3740mr159972b6e.25.1772134184607;
        Thu, 26 Feb 2026 11:29:44 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb3ab494sm475167b6e.8.2026.02.26.11.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:44 -0800 (PST)
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
Subject: [PATCH 3/8] mm/zsmalloc: Introduce objcgs pointer in struct zpdesc
Date: Thu, 26 Feb 2026 11:29:26 -0800
Message-ID: <20260226192936.3190275-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE9F6140008
X-Stat-Signature: zt337trxpp8bx44ucf7tmsjne94fewmn
X-Rspam-User: 
X-HE-Tag: 1772134185-931554
X-HE-Meta: U2FsdGVkX19v7gaL5Ud5W9P9v/NNg0cXGWsbqrufbRlIZjV+eWd8tC0hX3/ADLeVtHN3uP7/YRQkMxk6DR0gP9zpx4gbqTb7gOzFEDvRYDRi0b5MC5NHs1iz+vZrJnXfpLxadxHscEXw/hueqjDjrjMzTTfaf4qT77PgSe5mXwLR51GVMXaiJZQRJPZiOV0d3m4r3MGNLrPQWfzynGcpMvZZ6O4wjFRos2HvSlD+zWyYPOr4+3vzWXwwkxnsR2/aFp26GVblifLG6GDwI7TH3MFhpkp3PkPz1f8OsJDDa1B2+6mQfc7UXNHP/Db3kWhfIqpghM/9RiBdg7BCGw0xsXMj0tRrGrEpy5Rn65JO58WKn/oCIyXnxjujixEY74Gceu2cWLh7jX+iLp+oc2E7+Bu29cuwOEKDk3BXagjxhSDpwLZIvtK/k7xqIyKGO+0G5qwsgVpDKLPevnSr3UOb3ZylZsWExsT4sfjKybvMMnIFF5wqjLTtk1nFuXqqWvt+Q/Zj5fFE4sRC0QvnhtjFxUy+P5+Bw/LtYTMEKsEV8K+l5Q8p9+RvMbl7buV5v+7moxAXTG1VkpTgbZl7APK/gRl9qKbBuOVtHouLx4AjyK9dDnq7iUeE6E5Sv+a7dk4eUO7pSR+wxdqZ1+bzWGQ+20zPTZC6d18ChDGkMkyx+nKCXJBVz2lfa42rv4YAlqelaPtLOk9JO2ggINoDVtJHbmnbI+t3zs+uWYvqlQIg2pyoFNBoKjrvVYinNqtZbIvueA5f/zXXIOEyW036x9e5YTGedJMj+DV0FazlgZ0Ty/hLDsPyuePLUS93Lc8ZXwLXU+4SmAdRveCzYAO67miGyc/ndbqX8SM0Rxb5ReQqjUeawPelR1VJScJeSXy/1Rtv70IjKCKlWS9ynglZv/hj6XYs/DsEZrHDw1tqJc37L0GjNiwsPSdRUicPdYvvR5sSt3uNPoHvlfP/49A0Ua0
 fuH8xw/s
 b3eFcQXnaDPafIfTjoWzcuMCyHk/V/JdgjjEvfRmO5yMxuu2Ev5qV/7VUXQz0O5z5OZ/cpB5ru9z1jJDHmVpPX7vxl36NqdhnRkX3Ak1Wtofz2LrEQz3A9SHLrrN9qRhZuPYdHk1L/98sNz8/csa2IOI/FToyvr3Crek38ZZU4lo/MlH1wNisivrmvrxldJPYbfNxmhU3LOThgQBpkZycjb8vv4nHf+JLP1vwYh4dOXT28zuhesptzxYBNimAdyFm7LA9VxXZYXCee2b/FeYPtPoQM8VbkblPvaKQdbhDMumCi62UAyar1vJB4D1peQa1uZM7gZ2kja6DUT0wzu3dPH+v4tYNwv92wDwqH4now/cP+5lkVwDsENquW6L6BXPSaXmigJfvowGckjzzXf3KKrgcZQUFjPvdXmgIEjSUkxwm6r9VDegXx5hXPQkSwTg+7u6EHAVvGPOQtps9yn+VytN/Shw1FV4i5zYa6JGWD0pUsXuisDtwbUdXhkGe7iJe4juKH2zadrMA2yntzHljD4jAe/HjaimSWyIf3s9JG8TNLCJtyd1pv28ZfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce an array of struct obj_cgroup pointers to zpdesc to keep track
of compressed objects' memcg ownership.

The 8 bytes required to add the array in struct zpdesc brings its size
up from 56 bytes to 64 bytes. However, in the current implementation,
struct zpdesc lays on top of struct page[1]. This allows the increased
size to remain invisible to the outside, since 64 bytes are used for
struct zpdesc anyways.

The newly added obj_cgroup array pointer overlays page->memcg_data,
which causes problems for functions that try to perform page charging by
checking the zeroness of page->memcg_data. To make sure that the
backing zpdesc's obj_cgroup ** is not interpreted as a mem_cgroup *,
follow SLUB's lead and use the MEMCG_DATA_OBJEXTS bit to tag the pointer.

Consumers of zsmalloc that do not perform memcg accounting (i.e. zram)
are completely unaffected by this patch, as the array to track the
obj_cgroup pointers are only allocated in the zswap path.

This patch temporarily increases the memory used by zswap by 8 bytes
per zswap_entry, since the obj_cgroup pointer is duplicated in the
zpdesc and in zswap_entry. In the following patches, we will redirect
memory charging operations to use the zpdesc's obj_cgroup instead, and
remove the pointer from zswap_entry. This will leave no net memory usage
increase for both zram and zswap.

In this patch, allocate / free the objcg pointer array for the zswap
path, and handle partial object migration and full zpdesc migration.

[1] In the (near) future, struct zpdesc may no longer overlay struct
page as we shift towards using memdescs. When this happens, the size
increase of struct zpdesc will no longer free. With that said, the
difference can be kept minimal.

All the changes that are being implemented are currently guarded under
CONFIG_MEMCG. We can optionally minimize the impact on zram users by
guarding these changes in CONFIG_MEMCG && CONFIG_ZSWAP as well.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 drivers/block/zram/zram_drv.c | 10 ++---
 include/linux/zsmalloc.h      |  2 +-
 mm/zpdesc.h                   | 25 +++++++++++-
 mm/zsmalloc.c                 | 74 +++++++++++++++++++++++++++++------
 mm/zswap.c                    |  2 +-
 5 files changed, 93 insertions(+), 20 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 61d3e2c74901..60ee85679730 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2220,8 +2220,8 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	 * like we do for compressible pages.
 	 */
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
-			   GFP_NOIO | __GFP_NOWARN |
-			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+			   GFP_NOIO | __GFP_NOWARN | __GFP_HIGHMEM |
+			   __GFP_MOVABLE, page_to_nid(page), false);
 	if (IS_ERR_VALUE(handle))
 		return PTR_ERR((void *)handle);
 
@@ -2283,8 +2283,8 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	}
 
 	handle = zs_malloc(zram->mem_pool, comp_len,
-			   GFP_NOIO | __GFP_NOWARN |
-			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+			   GFP_NOIO | __GFP_NOWARN | __GFP_HIGHMEM |
+			   __GFP_MOVABLE, page_to_nid(page), false);
 	if (IS_ERR_VALUE(handle)) {
 		zcomp_stream_put(zstrm);
 		return PTR_ERR((void *)handle);
@@ -2514,7 +2514,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
 			       GFP_NOIO | __GFP_NOWARN |
 			       __GFP_HIGHMEM | __GFP_MOVABLE,
-			       page_to_nid(page));
+			       page_to_nid(page), false);
 	if (IS_ERR_VALUE(handle_new)) {
 		zcomp_stream_put(zstrm);
 		return PTR_ERR((void *)handle_new);
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 478410c880b1..8ef28b964bb0 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -28,7 +28,7 @@ struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
-			const int nid);
+			const int nid, bool objcg);
 void zs_free(struct zs_pool *pool, unsigned long obj);
 
 size_t zs_huge_class_size(struct zs_pool *pool);
diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548..d10a73e4a90e 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -20,10 +20,12 @@
  * @zspage:		Points to the zspage this zpdesc is a part of.
  * @first_obj_offset:	First object offset in zsmalloc pool.
  * @_refcount:		The number of references to this zpdesc.
+ * @objcgs:		Array of objcgs pointers that the stored objs
+ *			belong to. Overlayed on top of page->memcg_data, and
+ *			will always have first bit set if it is a valid pointer.
  *
  * This struct overlays struct page for now. Do not modify without a good
- * understanding of the issues. In particular, do not expand into the overlap
- * with memcg_data.
+ * understanding of the issues.
  *
  * Page flags used:
  * * PG_private identifies the first component page.
@@ -47,6 +49,9 @@ struct zpdesc {
 	 */
 	unsigned int first_obj_offset;
 	atomic_t _refcount;
+#ifdef CONFIG_MEMCG
+	unsigned long objcgs;
+#endif
 };
 #define ZPDESC_MATCH(pg, zp) \
 	static_assert(offsetof(struct page, pg) == offsetof(struct zpdesc, zp))
@@ -59,6 +64,9 @@ ZPDESC_MATCH(__folio_index, handle);
 ZPDESC_MATCH(private, zspage);
 ZPDESC_MATCH(page_type, first_obj_offset);
 ZPDESC_MATCH(_refcount, _refcount);
+#ifdef CONFIG_MEMCG
+ZPDESC_MATCH(memcg_data, objcgs);
+#endif
 #undef ZPDESC_MATCH
 static_assert(sizeof(struct zpdesc) <= sizeof(struct page));
 
@@ -171,4 +179,17 @@ static inline bool zpdesc_is_locked(struct zpdesc *zpdesc)
 {
 	return folio_test_locked(zpdesc_folio(zpdesc));
 }
+
+#ifdef CONFIG_MEMCG
+static inline struct obj_cgroup **zpdesc_objcgs(struct zpdesc *zpdesc)
+{
+	return (struct obj_cgroup **)(zpdesc->objcgs & ~OBJEXTS_FLAGS_MASK);
+}
+
+static inline void zpdesc_set_objcgs(struct zpdesc *zpdesc,
+				     struct obj_cgroup **objcgs)
+{
+	zpdesc->objcgs = (unsigned long)objcgs | MEMCG_DATA_OBJEXTS;
+}
+#endif
 #endif
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7846f31bcc8b..7d56bb700e11 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -39,6 +39,7 @@
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/memcontrol.h>
 #include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
@@ -777,6 +778,10 @@ static void reset_zpdesc(struct zpdesc *zpdesc)
 	ClearPagePrivate(page);
 	zpdesc->zspage = NULL;
 	zpdesc->next = NULL;
+#ifdef CONFIG_MEMCG
+	kfree(zpdesc_objcgs(zpdesc));
+	zpdesc->objcgs = 0;
+#endif
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
 }
 
@@ -893,6 +898,43 @@ static void init_zspage(struct size_class *class, struct zspage *zspage)
 	set_freeobj(zspage, 0);
 }
 
+#ifdef CONFIG_MEMCG
+static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
+				struct zpdesc *zpdescs[])
+{
+	/*
+	 * Add 2 to objcgs_per_zpdesc to account for partial objs that may be
+	 * stored at the beginning or end of the zpdesc.
+	 */
+	int objcgs_per_zpdesc = (PAGE_SIZE / class->size) + 2;
+	int i;
+	struct obj_cgroup **objcgs;
+
+	for (i = 0; i < class->pages_per_zspage; i++) {
+		objcgs = kcalloc(objcgs_per_zpdesc, sizeof(struct obj_cgroup *),
+				 gfp & ~__GFP_HIGHMEM);
+		if (!objcgs) {
+			while (--i >= 0) {
+				kfree(zpdesc_objcgs(zpdescs[i]));
+				zpdescs[i]->objcgs = 0;
+			}
+
+			return false;
+		}
+
+		zpdesc_set_objcgs(zpdescs[i], objcgs);
+	}
+
+	return true;
+}
+#else
+static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
+				struct zpdesc *zpdescs[])
+{
+	return true;
+}
+#endif
+
 static void create_page_chain(struct size_class *class, struct zspage *zspage,
 				struct zpdesc *zpdescs[])
 {
@@ -931,7 +973,7 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
  */
 static struct zspage *alloc_zspage(struct zs_pool *pool,
 				   struct size_class *class,
-				   gfp_t gfp, const int nid)
+				   gfp_t gfp, const int nid, bool objcg)
 {
 	int i;
 	struct zpdesc *zpdescs[ZS_MAX_PAGES_PER_ZSPAGE];
@@ -952,24 +994,29 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 		struct zpdesc *zpdesc;
 
 		zpdesc = alloc_zpdesc(gfp, nid);
-		if (!zpdesc) {
-			while (--i >= 0) {
-				zpdesc_dec_zone_page_state(zpdescs[i]);
-				free_zpdesc(zpdescs[i]);
-			}
-			cache_free_zspage(zspage);
-			return NULL;
-		}
+		if (!zpdesc)
+			goto err;
 		__zpdesc_set_zsmalloc(zpdesc);
 
 		zpdesc_inc_zone_page_state(zpdesc);
 		zpdescs[i] = zpdesc;
 	}
 
+	if (objcg && !alloc_zspage_objcgs(class, gfp, zpdescs))
+		goto err;
+
 	create_page_chain(class, zspage, zpdescs);
 	init_zspage(class, zspage);
 
 	return zspage;
+
+err:
+	while (--i >= 0) {
+		zpdesc_dec_zone_page_state(zpdescs[i]);
+		free_zpdesc(zpdescs[i]);
+	}
+	cache_free_zspage(zspage);
+	return NULL;
 }
 
 static struct zspage *find_get_zspage(struct size_class *class)
@@ -1289,13 +1336,14 @@ static unsigned long obj_malloc(struct zs_pool *pool,
  * @size: size of block to allocate
  * @gfp: gfp flags when allocating object
  * @nid: The preferred node id to allocate new zspage (if needed)
+ * @objcg: Whether the zspage should track per-object memory charging.
  *
  * On success, handle to the allocated object is returned,
  * otherwise an ERR_PTR().
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
  */
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
-			const int nid)
+			const int nid, bool objcg)
 {
 	unsigned long handle;
 	struct size_class *class;
@@ -1330,7 +1378,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 
 	spin_unlock(&class->lock);
 
-	zspage = alloc_zspage(pool, class, gfp, nid);
+	zspage = alloc_zspage(pool, class, gfp, nid, objcg);
 	if (!zspage) {
 		cache_free_handle(handle);
 		return (unsigned long)ERR_PTR(-ENOMEM);
@@ -1672,6 +1720,10 @@ static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 	if (unlikely(ZsHugePage(zspage)))
 		newzpdesc->handle = oldzpdesc->handle;
 	__zpdesc_set_movable(newzpdesc);
+#ifdef CONFIG_MEMCG
+	zpdesc_set_objcgs(newzpdesc, zpdesc_objcgs(oldzpdesc));
+	oldzpdesc->objcgs = 0;
+#endif
 }
 
 static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
diff --git a/mm/zswap.c b/mm/zswap.c
index af3f0fbb0558..dd083110bfa0 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -905,7 +905,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
+	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page), true);
 	if (IS_ERR_VALUE(handle)) {
 		alloc_ret = PTR_ERR((void *)handle);
 		goto unlock;
-- 
2.47.3



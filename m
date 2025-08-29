Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBCBCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7782F6B0028; Fri, 29 Aug 2025 12:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7565D6B0029; Fri, 29 Aug 2025 12:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9A46B002A; Fri, 29 Aug 2025 12:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45CAB6B0028
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:22:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01A531DE7EF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:22:33 +0000 (UTC)
X-FDA: 83830313028.24.643A103
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id CEDE880005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:22:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="TA+G/J6d";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756484552; a=rsa-sha256;
	cv=none;
	b=2qT9Xc/WRJxMFyWtzYm0CinqVaGoZ/bNViMwrV/o/DJGKqw+Pr2THdEYG8Eb3M6Wfrerz1
	/zt0tPi+c+zWzH68tGkGqNVN7rdB3476YbmY+X6F+EbQwOAI0pXnUL5ClocM+6HYNzXyXY
	yZKqlhbV3muk6SfX8kIGt8p3lY9AqoM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="TA+G/J6d";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756484552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17CQ98MuUtL4N4kqO5j7p5dqQdWQb8rW4TV4oJdSx98=;
	b=IfMSUPMdZ9GZUTFWoOBaEyNeWe3sC6OOJMifEbYCn+CDvegSMs12cjlHReTwe6BrgdSu6y
	CO+AAb6XHe+pY5+PBbNfecrA226NQhFzmPKCj/YR7+TOhRi3r+ZixiFhRQGORHqABSla4H
	viEmvvg2iDcbgn1C7jsc6OQziaLVW0E=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b79ec2fbeso15254615e9.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756484550; x=1757089350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17CQ98MuUtL4N4kqO5j7p5dqQdWQb8rW4TV4oJdSx98=;
        b=TA+G/J6dgbMZP3UGacF/nwAG/qjDjCIyAJ4crcunEt05CYQtK2r8FcfbPnsOCaioh7
         CEgbaMi82Bux1Srjx2OHREdkwAoZAxPXfcmX/nBxFti385CDNL/2522b7m/VzlRRKC7D
         dzEOU6yP1D3Dmkud1lBqiDCRCMOMJwk7CahAZZG2ZAVDxi3sROPBCb+1KNhuJHgYrb2p
         MxtijT2jwRQoA6CMnjTpBYLWBRjetT9g4ue+YArrD3+Ruf0vRt7XS07SD5uNFV0JkViA
         FDakWuUPyUmIGtfwDFduoN7+4B1s9kSBj67QeB9TS28XTyun4HtRC3WXufHJdHir7XN1
         AIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756484550; x=1757089350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17CQ98MuUtL4N4kqO5j7p5dqQdWQb8rW4TV4oJdSx98=;
        b=kqpMs6goIiirMUzHmW+E3nejlT/dqR9ufwD09f3NDjSDl003F1moNo6uEJenAaIuVB
         B/ebwgsZL8Fa5BaBXC7ovC1wLXzlk//4ET8AbCfW9SEe2PhrCZFoKk/rb5Up57i690it
         imfzq3mjlVnO54QwTuwSB6w1pJ0dh/8kNoJgDLS6ucUzqpBIEhhvkSoOeCofOaVGpGi0
         Dc60IkgWskcMwVPUT8UgBpuZ1h2jBH8TK308mOfl5pnFC7q2l65JnluZegDx4rSs7jRU
         1J2cKLjFMeQDNdBItM37Pzehfwsr94MLg8rGhZLtnO4rapApmCXYNLOM26bU7biJeOok
         JT1w==
X-Forwarded-Encrypted: i=1; AJvYcCWBpcTjyBATGbG+2jg/D0TCT5mtlTN1+bHJKsdhb9/1rNgmS1OaxYWpkxELS76feqfk5ZOnHpeCsA==@kvack.org
X-Gm-Message-State: AOJu0YxRfXkSP1SUckWbYSmD8kXLm03ar9A115h1OvApq3N+gihSdX8L
	2t0eE0/WjZzCTVvDklo0tK+8hvxmwrWlFZB+rWmtfa7A1+hflQOUM1thaztBqO+kR04=
X-Gm-Gg: ASbGnctLcnmLgqScL5p2i6oiBK3Y6QnbzfywLAgYdQazBvj3HOqB4iUgCczOBdlam0e
	yI9p6WNLv1+5hF2l9daH9bMPaIWi7WcOQF4OoPZKLRpC883pnExVERH7CWVppvBCF2CjCYgl4Lr
	bObM7yjr2P+PdrI+nJLESLfMqrsGWNBUrOvCRmVxNWJHoQJwUerqnZB07Z9/ERFvpoIxCMO0/ct
	iqilRoD9SW+YA+7TfGpY/vw/xYfcZbgFS1+OYt+NkH8eHkdC++nzZ/AmUynI+ARC9LSJCa1DKif
	dZWqJoF2elKAvMBoVJ/tqdyuzIMEGGjWcD+D4nvaGhOi/kwsuQ+koXF056/6Qga3gNN/nwaApiq
	Q5rc=
X-Google-Smtp-Source: AGHT+IGiYw4FjHPC+6dgPLMR3aSXIAaXkZtWGmpJ4U5RD6XOlfpkT3JB+Sho4Mz3B/jAtL0xXsW3sQ==
X-Received: by 2002:a05:600c:4715:b0:458:f70d:ebd7 with SMTP id 5b1f17b1804b1-45b517c2f25mr225292705e9.20.1756484550046;
        Fri, 29 Aug 2025 09:22:30 -0700 (PDT)
Received: from localhost ([2620:10d:c092:600::1:954])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf33fb9431sm3901684f8f.44.2025.08.29.09.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 09:22:28 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosryahmed@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm: zswap: interact directly with zsmalloc
Date: Fri, 29 Aug 2025 17:15:26 +0100
Message-ID: <20250829162212.208258-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829162212.208258-1-hannes@cmpxchg.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: CEDE880005
X-Stat-Signature: mhhpexncx9ifbuegqdned1turqid3uct
X-HE-Tag: 1756484551-103717
X-HE-Meta: U2FsdGVkX1/Zh+gyFsCEgs8mOEn6NVhZD873ZPh+yIK1wXTH4tvTqZPI/HHSNMiMXFKqvi4TXypiy+iHn/MGsGdZNggjKuIf416viMs+6xOx8WEKobqAoDCHkgqLHrK6jD1oYsMhOAEy5vkVp0FzTZhYAB95gO+h3wjJRLpVOMUP3EUm/WyI0tG5Hbif4sm3TTMQPOpVjKppnF3KUTmGUrhh1iIHZgVaWHSox2ifIkg7u54woZ+hEg+9JAjkperdiGlqALTA5m5y7S4e07Ui70AlhLTtULok9HXdSHm6gGX3KblREznvfRw1UfDaxVhZAmi7hAYN+u2cjuYqxfamaGWHRudcXP+6DaCp3Hlz8HJXUbYxr4Rdy0mPB6rEnoDxETu/fjeNwWuZTCcyjMDt4K0UOEy/DHm4RxEswNg9tSf3d+Ko8yC52oXV30yHOEyK94XveROYmW/1aphmAr/AphMm3w2gaILSigE1nkB4f5t9DimAvyZq7FP1vsPtZgJGPqf+/Vp3HU2EsctblRNJly2YZLUCSxTnTyE8iSCIo0iP1b772ZHW8CPcy3z0Pyx1RMQbnSAzv28l6/rzJ9fqwmRXdIskAX3Ky1Og+mD+3AwuzXuCM6MKv+C4BguaUYJvxyHm7kZj2hoTxQvJuth66UN8syopGxsL9Lh4opoI8wAFNJQyrqg4AkBJWS9e+BJrjh8k918vSItzSe2ygQBJNqy3F8iYWSO1Wv/8i8d5So5JTi0tc0loRQ3KcQL7tk8NXCZr+q4ciqKT4bYwKQbuEnCj+ZgfyPilKhn7EvcQeUFVUuszU+7dCl7dJK10hqm6/6LwZsJdQVU+zvgpDZ2n/ipBIwnTA4VwKfZu6Ay8dW7NQSzCu/JWkDTmfvSe9jHlHM1UTqq9JPEC3lts0LaSdN6/xaR5zb4vm2TiYYimvSAafAoYuHeBrV24bfEbG39uQEe22J8IVBTjZCyHtZK
 JzVvQX8/
 NuWbBEF5En7u80fZl4EhNsizWoOaUkYonryaYNWwedfXZG9OGZTiJX4G4ZALuycu7r4jQop5ZFfLXBnpAsgouuywSefKFIHbF12dNh+opU7+Ra3co2T0+IoS3x9SKFORXfn+SCmz0ITaWsPwqyjHuQMbgv1NAFF9Eg1S0LeW9s6Hyn+h8yskP5FqHoDn+mNuYGU5pE/SbB54pCaEma7AW7LsTH49Yn1jNibGacJJlKSR/vq/aUHYw1XbZ/yCcit1n6bPbnd4kpXOKfyjBoJy4AyaDVK6+Gkk7pF1jb+YCzXUnyBf3ipAsHCRmXdX+37O47f/MfnzoH6VRoCSKVBty50aCLzBiRnQGtNl+/1ZHM9flcQ/X42WcP+H8nq2PNyaGKLuvt2n2uB2RcM3CYB5t7kGwjx7QEdSoxM8MVWMVKs9f1Idw9WZpfZO717x8z9V6htMx3PQ45L9SYieCY/uCU+fv2+olH+j/hhi6IQR7nukuueP3zAgxc/4VoXrAhAH5ctBE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap goes through the zpool layer to enable runtime-switching of
allocator backends for compressed data. However, since zbud and z3fold
were removed in 6.15, zsmalloc has been the only option available.

As such, the zpool indirection is unnecessary. Make zswap deal with
zsmalloc directly. This is comparable to zram, which also directly
interacts with zsmalloc and has never supported a different backend.

Note that this does not preclude future improvements and experiments
with different allocation strategies. Should it become necessary, it's
possible to provide an alternate implementation for the zsmalloc API,
selectable at compile time. However, zsmalloc is also rather mature
and feature rich, with years of widespread production exposure; it's
encouraged to make incremental improvements rather than fork it.

In any case, the complexity of runtime pluggability seems excessive
and unjustified at this time. Switch zswap to zsmalloc to remove the
last user of the zpool API.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zswap.c | 202 ++++++++++++++---------------------------------------
 1 file changed, 54 insertions(+), 148 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e5e1f5687f5e..c88ad61b232c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -25,7 +25,6 @@
 #include <linux/scatterlist.h>
 #include <linux/mempolicy.h>
 #include <linux/mempool.h>
-#include <linux/zpool.h>
 #include <crypto/acompress.h>
 #include <linux/zswap.h>
 #include <linux/mm_types.h>
@@ -35,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/list_lru.h>
+#include <linux/zsmalloc.h>
 
 #include "swap.h"
 #include "internal.h"
@@ -107,16 +107,6 @@ static const struct kernel_param_ops zswap_compressor_param_ops = {
 module_param_cb(compressor, &zswap_compressor_param_ops,
 		&zswap_compressor, 0644);
 
-/* Compressed storage zpool to use */
-static char *zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
-static int zswap_zpool_param_set(const char *, const struct kernel_param *);
-static const struct kernel_param_ops zswap_zpool_param_ops = {
-	.set =		zswap_zpool_param_set,
-	.get =		param_get_charp,
-	.free =		param_free_charp,
-};
-module_param_cb(zpool, &zswap_zpool_param_ops, &zswap_zpool_type, 0644);
-
 /* The maximum percentage of memory that the compressed pool can occupy */
 static unsigned int zswap_max_pool_percent = 20;
 module_param_named(max_pool_percent, zswap_max_pool_percent, uint, 0644);
@@ -161,7 +151,7 @@ struct crypto_acomp_ctx {
  * needs to be verified that it's still valid in the tree.
  */
 struct zswap_pool {
-	struct zpool *zpool;
+	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
@@ -193,7 +183,7 @@ static struct shrinker *zswap_shrinker;
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
  * pool - the zswap_pool the entry's data is in
- * handle - zpool allocation handle that stores the compressed page data
+ * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
  */
@@ -214,7 +204,7 @@ static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 static LIST_HEAD(zswap_pools);
 /* protects zswap_pools list modification */
 static DEFINE_SPINLOCK(zswap_pools_lock);
-/* pool counter to provide unique names to zpool */
+/* pool counter to provide unique names to zsmalloc */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
 
 enum zswap_init_type {
@@ -241,32 +231,22 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 		>> SWAP_ADDRESS_SPACE_SHIFT];
 }
 
-#define zswap_pool_debug(msg, p)				\
-	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
-		 zpool_get_type((p)->zpool))
+#define zswap_pool_debug(msg, p)			\
+	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
 /*********************************
 * pool functions
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
-static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
+static struct zswap_pool *zswap_pool_create(char *compressor)
 {
 	struct zswap_pool *pool;
 	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
-	gfp_t gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 	int ret, cpu;
 
-	if (!zswap_has_pool) {
-		/* if either are unset, pool initialization failed, and we
-		 * need both params to be set correctly before trying to
-		 * create a pool.
-		 */
-		if (!strcmp(type, ZSWAP_PARAM_UNSET))
-			return NULL;
-		if (!strcmp(compressor, ZSWAP_PARAM_UNSET))
-			return NULL;
-	}
+	if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
+		return NULL;
 
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
@@ -274,12 +254,9 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 
 	/* unique name for each pool specifically required by zsmalloc */
 	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
-	pool->zpool = zpool_create_pool(type, name, gfp);
-	if (!pool->zpool) {
-		pr_err("%s zpool not available\n", type);
+	pool->zs_pool = zs_create_pool(name);
+	if (!pool->zs_pool)
 		goto error;
-	}
-	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
 	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
@@ -315,52 +292,29 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
-	if (pool->zpool)
-		zpool_destroy_pool(pool->zpool);
+	if (pool->zs_pool)
+		zs_destroy_pool(pool->zs_pool);
 	kfree(pool);
 	return NULL;
 }
 
 static struct zswap_pool *__zswap_pool_create_fallback(void)
 {
-	bool has_comp, has_zpool;
-
-	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
-	if (!has_comp && strcmp(zswap_compressor,
-				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
+	if (!crypto_has_acomp(zswap_compressor, 0, 0) &&
+	    strcmp(zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
 		pr_err("compressor %s not available, using default %s\n",
 		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
 		param_free_charp(&zswap_compressor);
 		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
-		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
-	}
-	if (!has_comp) {
-		pr_err("default compressor %s not available\n",
-		       zswap_compressor);
-		param_free_charp(&zswap_compressor);
-		zswap_compressor = ZSWAP_PARAM_UNSET;
-	}
-
-	has_zpool = zpool_has_pool(zswap_zpool_type);
-	if (!has_zpool && strcmp(zswap_zpool_type,
-				 CONFIG_ZSWAP_ZPOOL_DEFAULT)) {
-		pr_err("zpool %s not available, using default %s\n",
-		       zswap_zpool_type, CONFIG_ZSWAP_ZPOOL_DEFAULT);
-		param_free_charp(&zswap_zpool_type);
-		zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
-		has_zpool = zpool_has_pool(zswap_zpool_type);
-	}
-	if (!has_zpool) {
-		pr_err("default zpool %s not available\n",
-		       zswap_zpool_type);
-		param_free_charp(&zswap_zpool_type);
-		zswap_zpool_type = ZSWAP_PARAM_UNSET;
+		if (!crypto_has_acomp(zswap_compressor, 0, 0)) {
+			pr_err("default compressor %s not available\n",
+			       zswap_compressor);
+			zswap_compressor = ZSWAP_PARAM_UNSET;
+			return NULL;
+		}
 	}
 
-	if (!has_comp || !has_zpool)
-		return NULL;
-
-	return zswap_pool_create(zswap_zpool_type, zswap_compressor);
+	return zswap_pool_create(zswap_compressor);
 }
 
 static void zswap_pool_destroy(struct zswap_pool *pool)
@@ -370,7 +324,7 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 	free_percpu(pool->acomp_ctx);
 
-	zpool_destroy_pool(pool->zpool);
+	zs_destroy_pool(pool->zs_pool);
 	kfree(pool);
 }
 
@@ -462,7 +416,7 @@ static struct zswap_pool *zswap_pool_current_get(void)
 }
 
 /* type and compressor must be null-terminated */
-static struct zswap_pool *zswap_pool_find_get(char *type, char *compressor)
+static struct zswap_pool *zswap_pool_find_get(char *compressor)
 {
 	struct zswap_pool *pool;
 
@@ -471,8 +425,6 @@ static struct zswap_pool *zswap_pool_find_get(char *type, char *compressor)
 	list_for_each_entry_rcu(pool, &zswap_pools, list) {
 		if (strcmp(pool->tfm_name, compressor))
 			continue;
-		if (strcmp(zpool_get_type(pool->zpool), type))
-			continue;
 		/* if we can't get it, it's about to be destroyed */
 		if (!zswap_pool_tryget(pool))
 			continue;
@@ -499,7 +451,7 @@ unsigned long zswap_total_pages(void)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pool, &zswap_pools, list)
-		total += zpool_get_total_pages(pool->zpool);
+		total += zs_get_total_pages(pool->zs_pool);
 	rcu_read_unlock();
 
 	return total;
@@ -524,33 +476,22 @@ static bool zswap_check_limits(void)
 * param callbacks
 **********************************/
 
-static bool zswap_pool_changed(const char *s, const struct kernel_param *kp)
-{
-	/* no change required */
-	if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
-		return false;
-	return true;
-}
-
-/* val must be a null-terminated string */
-static int __zswap_param_set(const char *val, const struct kernel_param *kp,
-			     char *type, char *compressor)
+static int zswap_compressor_param_set(const char *val, const struct kernel_param *kp)
 {
 	struct zswap_pool *pool, *put_pool = NULL;
 	char *s = strstrip((char *)val);
+	bool create_pool = false;
 	int ret = 0;
-	bool new_pool = false;
 
 	mutex_lock(&zswap_init_lock);
 	switch (zswap_init_state) {
 	case ZSWAP_UNINIT:
-		/* if this is load-time (pre-init) param setting,
-		 * don't create a pool; that's done during init.
-		 */
+		/* Handled in zswap_setup() */
 		ret = param_set_charp(s, kp);
 		break;
 	case ZSWAP_INIT_SUCCEED:
-		new_pool = zswap_pool_changed(s, kp);
+		if (!zswap_has_pool || strcmp(s, *(char **)kp->arg))
+			create_pool = true;
 		break;
 	case ZSWAP_INIT_FAILED:
 		pr_err("can't set param, initialization failed\n");
@@ -558,30 +499,17 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 	}
 	mutex_unlock(&zswap_init_lock);
 
-	/* no need to create a new pool, return directly */
-	if (!new_pool)
+	if (!create_pool)
 		return ret;
 
-	if (!type) {
-		if (!zpool_has_pool(s)) {
-			pr_err("zpool %s not available\n", s);
-			return -ENOENT;
-		}
-		type = s;
-	} else if (!compressor) {
-		if (!crypto_has_acomp(s, 0, 0)) {
-			pr_err("compressor %s not available\n", s);
-			return -ENOENT;
-		}
-		compressor = s;
-	} else {
-		WARN_ON(1);
-		return -EINVAL;
+	if (!crypto_has_acomp(s, 0, 0)) {
+		pr_err("compressor %s not available\n", s);
+		return -ENOENT;
 	}
 
 	spin_lock_bh(&zswap_pools_lock);
 
-	pool = zswap_pool_find_get(type, compressor);
+	pool = zswap_pool_find_get(s);
 	if (pool) {
 		zswap_pool_debug("using existing", pool);
 		WARN_ON(pool == zswap_pool_current());
@@ -591,7 +519,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 	spin_unlock_bh(&zswap_pools_lock);
 
 	if (!pool)
-		pool = zswap_pool_create(type, compressor);
+		pool = zswap_pool_create(s);
 	else {
 		/*
 		 * Restore the initial ref dropped by percpu_ref_kill()
@@ -616,7 +544,8 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
 	} else if (pool) {
-		/* add the possibly pre-existing pool to the end of the pools
+		/*
+		 * Add the possibly pre-existing pool to the end of the pools
 		 * list; if it's new (and empty) then it'll be removed and
 		 * destroyed by the put after we drop the lock
 		 */
@@ -626,18 +555,8 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 
 	spin_unlock_bh(&zswap_pools_lock);
 
-	if (!zswap_has_pool && !pool) {
-		/* if initial pool creation failed, and this pool creation also
-		 * failed, maybe both compressor and zpool params were bad.
-		 * Allow changing this param, so pool creation will succeed
-		 * when the other param is changed. We already verified this
-		 * param is ok in the zpool_has_pool() or crypto_has_acomp()
-		 * checks above.
-		 */
-		ret = param_set_charp(s, kp);
-	}
-
-	/* drop the ref from either the old current pool,
+	/*
+	 * Drop the ref from either the old current pool,
 	 * or the new pool we failed to add
 	 */
 	if (put_pool)
@@ -646,18 +565,6 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 	return ret;
 }
 
-static int zswap_compressor_param_set(const char *val,
-				      const struct kernel_param *kp)
-{
-	return __zswap_param_set(val, kp, zswap_zpool_type, NULL);
-}
-
-static int zswap_zpool_param_set(const char *val,
-				 const struct kernel_param *kp)
-{
-	return __zswap_param_set(val, kp, NULL, zswap_compressor);
-}
-
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
@@ -801,13 +708,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 }
 
 /*
- * Carries out the common pattern of freeing and entry's zpool allocation,
+ * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
 	zswap_lru_del(&zswap_list_lru, entry);
-	zpool_free(entry->pool->zpool, entry->handle);
+	zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
@@ -949,7 +856,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
 	unsigned long handle;
-	struct zpool *zpool;
 	gfp_t gfp;
 	u8 *dst;
 	bool mapped = false;
@@ -997,13 +903,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		mapped = true;
 	}
 
-	zpool = pool->zpool;
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	alloc_ret = zpool_malloc(zpool, dlen, gfp, &handle, page_to_nid(page));
-	if (alloc_ret)
+	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
+	if (IS_ERR_VALUE(handle)) {
+		alloc_ret = PTR_ERR((void *)handle);
 		goto unlock;
+	}
 
-	zpool_obj_write(zpool, handle, dst, dlen);
+	zs_obj_write(pool->zs_pool, handle, dst, dlen);
 	entry->handle = handle;
 	entry->length = dlen;
 
@@ -1023,14 +930,14 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
-	struct zpool *zpool = entry->pool->zpool;
+	struct zswap_pool *pool = entry->pool;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
-	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
+	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
@@ -1039,7 +946,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	}
 
 	/*
-	 * zpool_obj_read_begin() might return a kmap address of highmem when
+	 * zs_obj_read_begin() might return a kmap address of highmem when
 	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
 	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
 	 */
@@ -1059,7 +966,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	dlen = acomp_ctx->req->dlen;
 
 read_done:
-	zpool_obj_read_end(zpool, entry->handle, obj);
+	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
 	if (!decomp_ret && dlen == PAGE_SIZE)
@@ -1576,7 +1483,7 @@ static bool zswap_store_page(struct page *page,
 	return true;
 
 store_failed:
-	zpool_free(pool->zpool, entry->handle);
+	zs_free(pool->zs_pool, entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
@@ -1906,8 +1813,7 @@ static int zswap_setup(void)
 
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
-		pr_info("loaded using pool %s/%s\n", pool->tfm_name,
-			zpool_get_type(pool->zpool));
+		pr_info("loaded using pool %s\n", pool->tfm_name);
 		list_add(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
-- 
2.51.0



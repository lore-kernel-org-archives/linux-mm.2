Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18532D1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670EF6B0088; Thu,  8 Jan 2026 15:39:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649176B009B; Thu,  8 Jan 2026 15:39:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DA06B009D; Thu,  8 Jan 2026 15:39:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0916B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:39:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3EE41A8FD
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:39:12 +0000 (UTC)
X-FDA: 84309961344.14.EF3A347
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 242CD4000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:39:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rJ+tcba0;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767904751; a=rsa-sha256;
	cv=none;
	b=nWtFN4mt9WyqAN62YsyZmCyippfeH3TKdAXuQc3voHE5CvGxA3sbnWlVEFxV207y3FyV2u
	9bO/HRg4zTZgpqm7cK9US/TBqrHgtcACytGyvsW+vENUFTRUaJa3tmqkxhU97h/RINjORp
	45XiTCjLZrokdVLgWibGJVH2MMLSkkU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rJ+tcba0;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767904751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OTZsz9YEfzZ2R8Vdeqp1RCaOkKgwxKsmSu+J9FA9fQ=;
	b=rZvawyz3hNilRLTTOVuOLf2gt8RkDKpZi1bo6foxEj7hhB+O0fyOUwI/42TgBCqsgNh4tV
	E/gt8tAYsCMx0eph4Zqy8I/UW54PizV9gRhNGKqZZrrpaTn74jz767rrXVtH7bpS4O8Emj
	xy7ALLWdICX5caH+sLCV9V4sgnqYySY=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4fc42188805so37635931cf.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767904750; x=1768509550; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OTZsz9YEfzZ2R8Vdeqp1RCaOkKgwxKsmSu+J9FA9fQ=;
        b=rJ+tcba0IhtX1A/g9wTstWh5TqS+Dwl52FlR1TRJ7tp1Th/PHXXJXb2s5Bvqi8KpEY
         18Gl+aUlhf7ySjo2alN72ngtgkyn9gksPGplfOyaUFCDUbx9Ha9f4uVzLS6Lsve90bcY
         Hd1woPTtjVgCw2zr9oXD9Jf2/TQwOA/ApGahq9osYL/kPVSw5la6158QHi9KtaI3YYO+
         atqOm5Hf0aZHEzVyFGuCgK2S9/1igr0jLmZP0nGa2ljTEso1KvCFz9qTz6Tz6vGsuzDe
         93AysGN7QtZurej/ATfdgdxRm5Lk3H0JQOcQyxEZazSHNU5O3+UaPteqc+Bcb4QxwGCO
         rmRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904750; x=1768509550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5OTZsz9YEfzZ2R8Vdeqp1RCaOkKgwxKsmSu+J9FA9fQ=;
        b=w7xK9PzOavbNflupTLY3G+jtUKBXpU6ootnn6YwmOtqatCqZWkaJziajqpugsPdZZE
         apt7Os8xF8K1MFb4IqpntJClQEoXHVizYF6gn6rTHsENYmxx5Q7df62rWw9odQh3Wx5L
         tEU2NGdGk7Q1kqguLvwoh2Riej84MU/kOEQ1oZbPwr4fARsbr1itZPi6TDgfadvVZ2w2
         /AV+Xzwju3WH3IN4L42ty2KUI/YBBMBiFyZLSvddifYh2lURvm4IWNesrmTSVvFuqAQu
         xWoWAWehMZRcQ7zdqDu4a/CobLlAw8qt+gYL+11NsrcotreRHa/kALss3ssg0KcrUHSO
         28xw==
X-Gm-Message-State: AOJu0YzhWOnJI+zUnfs3aXLudY0MHJFXLFSQnMY0bBAFwHmLjMFbhEkM
	JXQ9UhOe9+OB2zlleM1xH/zi3eXmqf97URsG10JsV5sdSjuLx3xVKQ+JDsNaZjCGE+AMM+F+B1O
	7/gyG
X-Gm-Gg: AY/fxX7xcXMgyljJiv96IDasJWs7GxSioSBVOwLoTnFdnvh3eASnyIYQoOZ1kWw4+kb
	buJD0SFSBVl4mf9Y2nGoewBnMKa6xy35heKBhplUedyKh//JwUEVHAkLGummjKcDPioVreFZKax
	//M/lCRmJGJOYnDwZKuJaNfk+P89c7JMe7injuFAGzg9aDMbES2Ki8R24OpfYJ09oLyltqdLeNv
	QCRzgeIh1g14vJPdWJ2TgGGLJiGMFK3B6iigUkWFWR4kTO70tER6peCybmD92iSpU6WPnU83gts
	M39qhRiyY8Fnl5mVpqMtYqqtT1J9BYYFJep8O5LwWWijXLEbaj+LyYMkUFw1qmHwH9FZLbJRpGA
	keukRLF0ISjUIST/8i75vcnUfqR1jIEICcgr9GDGNmg7ffNcg3IMB/WIyVB8J5kYNraeTYWuu+P
	XBB0ONTtXGOMaClQ1xpjs34gwYHLXjrrILRuTYFu0aRkPrRhz8+0CIVMR494/s8qwvyv3hwBQBe
	cQ=
X-Google-Smtp-Source: AGHT+IHjrJedObjQLnkqlATuK0iiTd2ReDzXEhDuZpiEE8iScOlIeLDoodxwtlrvEQjvQ0kp+C8/HQ==
X-Received: by 2002:a05:622a:554:b0:4ee:26bd:13fa with SMTP id d75a77b69052e-4ffb4a38073mr98924131cf.80.1767904749843;
        Thu, 08 Jan 2026 12:39:09 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:39:09 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	zhengqi.arch@bytedance.com
Subject: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Date: Thu,  8 Jan 2026 15:37:54 -0500
Message-ID: <20260108203755.1163107-8-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108203755.1163107-1-gourry@gourry.net>
References: <20260108203755.1163107-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 242CD4000E
X-Stat-Signature: se644kzdmk43dztw1yqrysq3e8p78hwz
X-Rspam-User: 
X-HE-Tag: 1767904750-57759
X-HE-Meta: U2FsdGVkX19g/HTJfnn3NL9uaewRVXeJd1m6DwryGdYL31Vy6CppIeF2zy58u/GeqB90tmJxusQm7sKBZ8K6BBEqwWW1/JjunFUi5ZTvAUYT4whfrPJtVC4xCQRgal6KL3D+Os7R2HP1Z8AF4CLh07kjmhtU1tyy50Hl/ljL9L/ToDtvsYtd2oJBAcdzsUkzg4CiJKAFJdTIp5ve8vH75/o2Gj7juxG9zH2iKKKGFBeqc3mpI73zy1h3P4pB81YI71R6Ibo9oXnZjCUbrZ9iIBEMvSB0OHhUgWUYFp8T10zfrlJixUwYG1JHjzUqUs+g0sNlIXzQ1Pi9U6mPGlz9D/5UOvD1pKfCS8d2nIscRYfBbRlJO8MsFvJwCmJ72rrSoRIJxFc05tSKEA98jf9eMqCG1kR1j0zCh2YRfQHswjkBiwA5f4WyqlnbUzfHI6ags6KkAtsIkY2Stxa2PMsIQstzAmcRLij9vNYWDHvjpHrpOCE3VqwkwIfxdTLnVyTocXA7HUtMGzUaic0SR4fRDewFZuXJDz4O7Ai98Jk8v1MA1RCb3A6jQDEbdqxCFt2XuESlmxvy07h1lnWU9swlWxD2lzIh4J5MW3UK1TFhV/D9Hm03Gm+iAi1ZzhEAbEwBp0P5rCne1cxyNOpM2obEW89+jRYR2HE9jkzZvv7/Y5pIPFbk85C3OyAGf3khhPgnf8badcyWbRaGBbtC4mpXXF2r6b7omN2HH9KQ1wuCx6QYyYvoD6Yj5ioOeXW/JmXYqTcT385WUEcrKbKkRSiZRiaDKJLY4glHlzmxMfZJZSmBxsfdPBH9Sik9Cluxp5U56o/Kd2LbHngwZll+Ak/b9kq9nJtiHiw16gGVaTIoIIaow4Bd8m7q2Mt02/DPVIpV2OOpVjgs1mIUT0+medes62UcLBwwpUpEngGq8F7R9IH6rxYHYOtYtRjrCenySlBRNViGWwG+v2oNx4uT2Al
 XkKIHvNC
 KUUS0Pw1nUFuH89Ehm4YbxITD5OwOyWN5HXGdYmkmTwYM1C1m2Y9K5ws7MFbLmFKEo/b6UfPfMDGmqCwC0FNon7ztEIcpugsSWoqa6QJ0DBkm3qeVOJkTwdnkQUCQjY8zxvmBebs7yjVJ381WV3oT3nbO5AhYf4f7XR6Tq6DGP5WLozGEhj3uO7wbPfj43sJTlbvTZdDj9+lDnb0yyantO9cDjIQfY7ZKs9Fz3SHXjtrACGb4AK8lQZNVb2hcUZx4vsjU8dtZf/f8jlB2hMX3WPojaF6zKcwPaNyESQJpztQHL3jyqzLVL2TKUwK6wLm8t8veevf7sbOxMNrBeoSpw4HR1f4nz2vVWOyzWGuyNYYp3ecqMg2GA4r1Wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a private zswap-node is available, skip the entire software
compression process and memcpy directly to a compressed memory
folio, and store the newly allocated compressed memory page as
the zswap entry->handle.

On decompress we do the opposite: copy directly from the stored
page to the destination, and free the compressed memory page.

The driver callback is responsible for preventing run-away
compression ratio failures by checking that the allocated page is
safe to use (i.e. a compression ratio limit hasn't been crossed).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/zswap.h |   5 ++
 mm/zswap.c            | 106 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..4b52fe447e7e 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,8 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+void zswap_add_direct_node(int nid);
+void zswap_remove_direct_node(int nid);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +71,9 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline void zswap_add_direct_node(int nid) {}
+static inline void zswap_remove_direct_node(int nid) {}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index de8858ff1521..aada588c957e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -35,6 +35,7 @@
 #include <linux/workqueue.h>
 #include <linux/list_lru.h>
 #include <linux/zsmalloc.h>
+#include <linux/node.h>
 
 #include "swap.h"
 #include "internal.h"
@@ -190,6 +191,7 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
+	bool direct;
 	struct zswap_pool *pool;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
@@ -199,6 +201,20 @@ struct zswap_entry {
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
+/* Nodemask for compressed RAM nodes used by zswap_compress_direct */
+static nodemask_t zswap_direct_nodes = NODE_MASK_NONE;
+
+void zswap_add_direct_node(int nid)
+{
+	node_set(nid, zswap_direct_nodes);
+}
+
+void zswap_remove_direct_node(int nid)
+{
+	if (!node_online(nid))
+		node_clear(nid, zswap_direct_nodes);
+}
+
 /* RCU-protected iteration */
 static LIST_HEAD(zswap_pools);
 /* protects zswap_pools list modification */
@@ -716,7 +732,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 static void zswap_entry_free(struct zswap_entry *entry)
 {
 	zswap_lru_del(&zswap_list_lru, entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
+	if (entry->direct) {
+		struct page *page = (struct page *)entry->handle;
+
+		node_private_freed(page);
+		__free_page(page);
+	} else
+		zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
@@ -849,6 +871,58 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
 	mutex_unlock(&acomp_ctx->mutex);
 }
 
+static struct page *zswap_compress_direct(struct page *src,
+					  struct zswap_entry *entry)
+{
+	int nid;
+	struct page *dst;
+	gfp_t gfp;
+	nodemask_t tried_nodes = NODE_MASK_NONE;
+
+	if (nodes_empty(zswap_direct_nodes))
+		return NULL;
+
+	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE |
+	      __GFP_THISNODE;
+
+	for_each_node_mask(nid, zswap_direct_nodes) {
+		int ret;
+
+		/* Skip nodes we've already tried and failed */
+		if (node_isset(nid, tried_nodes))
+			continue;
+
+		dst = __alloc_pages(gfp, 0, nid, &zswap_direct_nodes);
+		if (!dst)
+			continue;
+
+		/*
+		 * Check with the device driver that this page is safe to use.
+		 * If the device reports an error (e.g., compression ratio is
+		 * too low and the page can't safely store data), free the page
+		 * and try another node.
+		 */
+		ret = node_private_allocated(dst);
+		if (ret) {
+			__free_page(dst);
+			node_set(nid, tried_nodes);
+			continue;
+		}
+
+		goto found;
+	}
+
+	return NULL;
+
+found:
+	/* If we fail to copy at this point just fallback */
+	if (copy_mc_highpage(dst, src)) {
+		__free_page(dst);
+		dst = NULL;
+	}
+	return dst;
+}
+
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
@@ -860,6 +934,17 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	gfp_t gfp;
 	u8 *dst;
 	bool mapped = false;
+	struct page *zpage;
+
+	/* Try to shunt directly to compressed ram */
+	zpage = zswap_compress_direct(page, entry);
+	if (zpage) {
+		entry->handle = (unsigned long)zpage;
+		entry->length = PAGE_SIZE;
+		entry->direct = true;
+		return true;
+	}
+	/* otherwise fallback to normal zswap */
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	dst = acomp_ctx->buffer;
@@ -913,6 +998,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	zs_obj_write(pool->zs_pool, handle, dst, dlen);
 	entry->handle = handle;
 	entry->length = dlen;
+	entry->direct = false;
 
 unlock:
 	if (mapped)
@@ -936,6 +1022,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
+	/* compressed ram page */
+	if (entry->direct) {
+		struct page *src = (struct page *)entry->handle;
+		struct folio *zfolio = page_folio(src);
+
+		memcpy_folio(folio, 0, zfolio, 0, PAGE_SIZE);
+		goto direct_done;
+	}
+
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
 
@@ -969,6 +1064,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
+direct_done:
 	if (!decomp_ret && dlen == PAGE_SIZE)
 		return true;
 
@@ -1483,7 +1579,13 @@ static bool zswap_store_page(struct page *page,
 	return true;
 
 store_failed:
-	zs_free(pool->zs_pool, entry->handle);
+	if (entry->direct) {
+		struct page *freepage = (struct page *)entry->handle;
+
+		node_private_freed(freepage);
+		__free_page(freepage);
+	} else
+		zs_free(pool->zs_pool, entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
-- 
2.52.0



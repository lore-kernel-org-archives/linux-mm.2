Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537A7CD3445
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF718E0019; Wed, 12 Nov 2025 14:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FCC8E0002; Wed, 12 Nov 2025 14:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967918E0019; Wed, 12 Nov 2025 14:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7258E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:30:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44622160695
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:25 +0000 (UTC)
X-FDA: 84102946410.19.278223A
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6EF61140009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T4FScfvV;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EE3olEnyRjl52kAEWnA02JLmmLDlTmwS9hIpIeJT8kY=;
	b=MoVFUD2lDHfTecfgIjJsmQx6YJT7Sqh7tFqzUHRCFaVGjHFCBYv2KnDjJr+tMC9XNGh+Q0
	eySD/R7fYayqUgVcSfsRL7leDWRTktxtezKCcClwP+bzM2PbBjeI1zn9wtILP9Hvki7giS
	GEsSLOAJEjsoz9S/hsMtIa8QfiZk63g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975823; a=rsa-sha256;
	cv=none;
	b=COtdy7uCDJq8LQ7k3YV5APMVDoHF1Vxu5UkhO02zuDepZFAy+d5CPleKe0PDzDmwkqkWIQ
	LBEBcNQSZbFvMzM+1uR/5yzWvZiH3GadakM1RJBytPy8HL5nnLDUgwrwpV6j0bIEjNkb11
	KEhGom7bchQ7QJ3qLGKbfk94vVHgytY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T4FScfvV;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4e88cacc5d9so9855181cf.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975822; x=1763580622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EE3olEnyRjl52kAEWnA02JLmmLDlTmwS9hIpIeJT8kY=;
        b=T4FScfvVCYDHzr78PMOcOxgAoFUIrvopoj7BomTKlBgHk3zPkgT3H86kETQ8ueBh2r
         8AHIcVmRUbK6/DaCLlybYmk/DKF4bQF2iIA70/O8uR9f9HPna0sa5IY56Kcgk0ii/U/t
         CFhBPQ4AOgDzdPEkU8wcuGbvST+h8/7EtEaENTQHyMrGj+y5NifqXZNNkvf4I7Sj55jZ
         ZNleTSa4zv0uBzYlGlcCs9nFmO1PrYYZbyL/5GeelwMH1ZGYuZyNNdDHCi3bJrHjY4vN
         NT2lYypsfU+0Imld48YmhMB4mYgCSpwBheKMhbFR9NM6q6d3xyqleXGgnlLwsroOQMNX
         YC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975822; x=1763580622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EE3olEnyRjl52kAEWnA02JLmmLDlTmwS9hIpIeJT8kY=;
        b=EVDhS1avlV4v3nNgaQLEf3um5bV0IuYI4NLvykjTENYCTeRQ3rCqY/7jV4Bgm5QtlR
         uQ6xfFrpogK6KxqklkE3kpX0iD1HsTRz8G+2ZQDaonzi7bNfXSpgE5aFX0nFTZLrX0/Z
         FFdnN7k5n/H2YIcgCovBSbMh+gdigy8TP11/w87VxjmNLBl/E6ePlb9MQMu5RAkty/YS
         O57bn+LMVvof4NncTgQMpPZm6wzqL2kLXLbI0SVk2LtAshkvHuZ8oIYgFh/1TW77pQOJ
         6Y5Hp9SrjKA+aabxdX3tNeiR8OUyur1IgunACp+EpPouixOxM3TVBmZdAkc+Q8zJiOHU
         tdLw==
X-Gm-Message-State: AOJu0YxmnQUrcr7/+x1Hof0pKilrY5I/x9DI3urC8AkmEv1MDL5H5QFW
	Ay8lIZWkOheDH2bf1BdVsw7iY2i6hB2NLTOsK8gkh5+zaoYfij6GvSy7IDNZwEqAkIK8JqNWe3w
	aID7L
X-Gm-Gg: ASbGnctGz3R2VUcS5waVmJk7bstijrs5dzvx50YaxAroYY2KxSFXyHspL0v5uUSn2dD
	cHT6dn+TIOXAVdVl7AISO0iFYGj36snyvz9c8JX2fO4Ea9BS2LEiDalXS6qNiUemCrRSVm5/DXx
	JoS1IUCFZUZ5k+jtz5axgjsgoS0O4Hez8igMSHmDBpuMC5Xxmw5SONG2TQISbgJSpPMLwP2KH6G
	kJPVxdsYJ41toKx1wN4lVSKIBng/nl1mshP1vuibBjn2mbY3hC6RIoaKlhhNZFzK8veWEQYBXdC
	ZRncNPS9pFlz5KM/jKJrTtD+2csVivFri0qfPFNHlALMShHDclFbtvGnw/x3hxSd4clOMPrJS8K
	KsuDs4ow8cDJh9Qrry8qYoRsZENWtsO4WxFOHJSfc5fF5AFjS9ZQRcj4AEmE5c8jXx39kufI/oW
	+YX8ixCzMTosjViSpFiSyoIEQZBf2PkNab7hK9bvSmd461xWZsJZVSCLqkG5e4AyJX
X-Google-Smtp-Source: AGHT+IEpkA9sHRf+vDkvWZyRaV+z+4MD09rdo9Mmp9OjAhV3qhp/e6NAADZhOGarPgun9sbSz0rc+w==
X-Received: by 2002:a05:622a:14f:b0:4e8:b980:4792 with SMTP id d75a77b69052e-4eddbcb30a2mr55332141cf.37.1762975821965;
        Wed, 12 Nov 2025 11:30:21 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:21 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 11/11] [HACK] mm/zswap: compressed ram integration example
Date: Wed, 12 Nov 2025 14:29:27 -0500
Message-ID: <20251112192936.2574429-12-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6EF61140009
X-Stat-Signature: mk4zna7i9unu63dqsxmf1rr57pfq336r
X-Rspam-User: 
X-HE-Tag: 1762975823-834929
X-HE-Meta: U2FsdGVkX182bCo6vgR+hFSBKWMpYw3qsfJIgIUGTtoUsClfsJgHKbUwuRaGklok6HuRk8RKwBjQPAUI0UWPrw3uNkPHpmCEbe69RZNENSJGTqlU03vZQZUmjMv9X6SR16UHzLwa8kw8FqwOBnpQCpnRNArnFAyURjbT/H5arPPkJyR5yODJh7wIXVfZj3W0Rt5dxo89QHTrus2vszscnR0dNC1Kkiyx3YY5byJ8FbPqtZfKoxWiDZR+SL1Kb+Hm3RtgVYMun9Fei+rKsZ9jWBpjsBtNs9OQCNiIJLuYkq1SBYpqrlMP3DD9oCmE3botOVPiGfP4H7S0MFBmJagKabTN5RFzYBAflCdbT7zGC6vdcwGOVYJu1TbVt/zSHML+jtqhBq/sCRkto8xhJWNVW+/DmFRYA9nbYBrdbLc61qXu/ZXW9DsE33DBMqrt6VGSu8Qu20fSqN0YTlmxtE5cgLWAeqDCF2HM3d86WC4bgtCE0BXiyFRVeoQHYwX5oPozSbE5qEV03BesBGb3llcUIPCstdxJeR2TqlL4/53kGV+thI71tdCnD6OwoZPbqr5P+W6tszB614ap8WmizadLwPRTjyj/iHpBdc3sZrc70Lmht0XD9N3IRSO6Pk5lF2d3qL/1NeSRueDp1SJiV9eYU+WFlAVI232ZTy75B2Ip2CK9EHQiJ7OBfCPCTXXFl2kpDyo9omcNETEY8jy9RAAuA/sTcRqeK7AMPEmnmH07k6D+PchSvYFGzLFwdIWom027D351FUfvrITLcRtK0vAnDp8qYA2QOzvhNhjGHJTuypkMVWa/vtfvxD28PQD/ddq+wGlVC7jMzg1vOdYI9RXvmUTjiaZDECfmS46LPyFwFyhQb2Wyl6L89hhtsbGe8hsUOgc+FB4aO/LhImEbrvRYg04z+gAXMM0lTbok7DoX5WiGtdXLqtXwgmGTmM4htCKbKw37AOIJCz48xQnkwvk
 5dDXq6sw
 U9BqOJJInbJyrav2jzFjc2muH6UsUeif6c8Ul3CuGA3UQB6x97Y6pN9CcY2BHK4O3SugbZ1gJ6yQ7ZOJ1uFiz1lb24uYeukCDkbUuJr3wXqVTed7/dGCXmZXvGzCu7ga4wvkZ0inBefs775/EMyXFMpI+XSSwTWOlEOTKYYauzeGQKKomtY6+oPH/5pJsu6GFGxP5j1/QPVC1v37iCPUz9jgbXMliNYxk0i2NBVxMzdivqhbx+U7eslOZKpMrQnjlALyLqepB/qGdSm5T0WKHajUOcYksgCwR+GDF1wR9GArtYXpMtX3UtzTahh5MLMwnrrxVEktrJQCtg+9DfukNll7WlAoPvHCzxLMWS6mEMVP2+UkXSqHtY5xKDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here is an example of how you might use a SPM memory node.

If there is compressed ram available (in this case, a bit present
in mt_spm_nodelist), we skip the entire software compression process
and memcpy directly to a compressed memory folio, and store the newly
allocated compressed memory page as the zswap entry->handle.

On decompress we do the opposite: copy directly from the stored
page to the destination, and free the compressed memory page.

Note: We do not integrate any compressed memory device checks at
this point because this is a stand-in to demonstrate how the SPM
node allocation mechanism works.

See the "TODO" comment in `zswap_compress_direct()` for more details

In reality, we would want to move this mechanism out of zswap into
its own component (cram.c?), and enable a more direct migrate_page()
call that actually re-maps the page read-only into any mappings, and
then provides a write-fault handler which promotes the page on write.

(Similar to a NUMA Hint Fault, but only on write-access)

This prevents any run-away compression ratio failures, since the
compression ratio would be checked on allocation, rather than allowed
to silently decrease on writes until the device becomes unstable.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/zswap.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..e6f48a4e90f1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -25,6 +25,7 @@
 #include <linux/scatterlist.h>
 #include <linux/mempolicy.h>
 #include <linux/mempool.h>
+#include <linux/memory-tiers.h>
 #include <crypto/acompress.h>
 #include <linux/zswap.h>
 #include <linux/mm_types.h>
@@ -191,6 +192,7 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
+	bool direct;
 	struct zswap_pool *pool;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
@@ -717,7 +719,8 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 static void zswap_entry_free(struct zswap_entry *entry)
 {
 	zswap_lru_del(&zswap_list_lru, entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
+	if (!entry->direct)
+		zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
@@ -851,6 +854,43 @@ static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
 	mutex_unlock(&acomp_ctx->mutex);
 }
 
+static struct page *zswap_compress_direct(struct page *src,
+					  struct zswap_entry *entry)
+{
+	int nid = first_node(mt_spm_nodelist);
+	struct page *dst;
+	gfp_t gfp;
+
+	if (nid == NUMA_NO_NODE)
+		return NULL;
+
+	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE |
+	      __GFP_SPM_NODE;
+	dst = __alloc_pages(gfp, 0, nid, &mt_spm_nodelist);
+	if (!dst)
+		return NULL;
+
+	/*
+	 * TODO: check that the page is safe to use
+	 *
+	 * In a real implementation, we would not be using ZSWAP to demonstrate this
+	 * and instead would implement a new component (compressed_ram, cram.c?)
+	 *
+	 * At this point we would check via some callback that the device's memory
+	 * is actually safe to use - and if not, free the page (without writing to
+	 * it), and kick off kswapd for that node to make room.
+	 *
+	 * Alternatively, if the compressed memory device(s) report a watermark
+	 * crossing via interrupt, a flag can be set that is checked here rather
+	 * that calling back into a device driver.
+	 *
+	 * In this case, we're testing with normal memory, so the memory is always
+	 * safe to use (i.e. no compression ratio to worry about).
+	 */
+	copy_mc_highpage(dst, src);
+	return dst;
+}
+
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
@@ -862,6 +902,19 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	gfp_t gfp;
 	u8 *dst;
 	bool mapped = false;
+	struct page *zpage;
+
+	/* Try to shunt directly to compressed ram */
+	if (!nodes_empty(mt_spm_nodelist)) {
+		zpage = zswap_compress_direct(page, entry);
+		if (zpage) {
+			entry->handle = (unsigned long)zpage;
+			entry->length = PAGE_SIZE;
+			entry->direct = true;
+			return true;
+		}
+		/* otherwise fallback to normal zswap */
+	}
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	dst = acomp_ctx->buffer;
@@ -939,6 +992,16 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
+	/* compressed ram page */
+	if (entry->direct) {
+		struct page *src = (struct page *)entry->handle;
+		struct folio *zfolio = page_folio(src);
+
+		memcpy_folio(folio, 0, zfolio, 0, PAGE_SIZE);
+		__free_page(src);
+		goto direct_done;
+	}
+
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
 
@@ -972,6 +1035,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
+direct_done:
 	if (!decomp_ret && dlen == PAGE_SIZE)
 		return true;
 
-- 
2.51.1



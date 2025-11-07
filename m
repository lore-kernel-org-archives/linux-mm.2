Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A470FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3088E002B; Fri,  7 Nov 2025 17:50:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0837B8E0006; Fri,  7 Nov 2025 17:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18FE8E002B; Fri,  7 Nov 2025 17:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1A9F8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:50:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98D90C062D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:33 +0000 (UTC)
X-FDA: 84085306746.23.92C6B58
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id C774A12000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vu30t8k6;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762555831; a=rsa-sha256;
	cv=none;
	b=o2D76Owm1NAOmHnICeegL8sDI03pEZkHHVdcLjoRfU3JvYIuVYMcGE247uVxxhUwaGMGJv
	/IxZ7HDB+X5U3xTJr3Fruzfc5XP7zXFa8tWR1gQ1RPA45eZ2eLAaL8YF6pMKdLx/s2+Uxk
	Sn7DUGlsKzB31+xMweHXQ4eYZkPQJmQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vu30t8k6;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762555831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9lQPmHHEcXtG9PcD1wB7xt838yvOXXROIsvBhfuZzo=;
	b=qC9mWcWnyKmpMUgnSLzTM6qKApbcxPV1bDGFPTUy0+vF5JcOOs6gy7Ou/dad8AY/EN0N9x
	y4hMC9nRhKRKCxE5n3oozzmlS8Pn870o4zibjDLKrFB47gw3u8L5s4UUPi8U5YFXGyjdhU
	HKhZDJmHC/5oukQRcZkZR9fcW3KmkXk=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ed79ad2846so12302371cf.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 14:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555830; x=1763160630; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t9lQPmHHEcXtG9PcD1wB7xt838yvOXXROIsvBhfuZzo=;
        b=Vu30t8k6o3RP6vkvFRfwWeNiTAPEgdS7tzA5PBoMwpC2VmvyYaL1QgtanVqcr0R7zD
         NQHgKx+qc5hplqTMJWZTzjj18bMEiZTUEkEXup4xA7P+lSbMLE24nZtKXqGXZ3wFpNwk
         qqckXAMLwWftSoTs0erPpc5xwfjlma1zeJrf8hP6jBZaJtRAaTrjqbAW06r+rMhG5+wk
         TQt/v+Bsa9sq6YVFj29XsD2R5wSiiutkKENo/ygCAD/SsQUBranX9lUtrTCyurAZ6zhU
         2DSBkUPI+ga+AlObQRrPNQN+ezEN1ytzV485rlc+Xys5+Ky1Xu5XsGmkwc5NHIenTSOz
         abYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555830; x=1763160630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t9lQPmHHEcXtG9PcD1wB7xt838yvOXXROIsvBhfuZzo=;
        b=nIDH0QwkhkyFaK0R/yoOXLIZgoMy5who7w62oVTaByaJn3qdFpHYRvkAJEe9PCcTG+
         Fv+kAr5B7e4X3/xj8N1nwfI8o4j0N7xtfER+1qPzW+VrbX08UVRLDnbFSezsz73b3K1R
         NQBYnIyuc4qcspNGxJF63l0j119FHQ1vnHzNGX8/fSWS4tA98EdVJudcpr6OMZlunG2q
         +2HxpoKJVwXKCLei0gcvOD9TPGNUEFOBCBFpJK3pcOMI/Dp6luETl6roHzmJH+EzYZt4
         AZ0lxHSFio1Qg57ez1IkVYC2NQ9ycTfFGZbZ12Vov+zKyJPfNX8cOJPXGrim245L0kq+
         zhKA==
X-Gm-Message-State: AOJu0Yz/HdbHYd+/xk4o9fOIDMTIbjhTyCZ8BjQXN4WPG3II6aw5OwXP
	1eU7jflq6lLFUAtUeyVeiRLwEH0QGGIfpYLMoG0n5b0xrAGXsqZO/tGsVC9xcUFTB3BHyb/Q6z2
	86MUu
X-Gm-Gg: ASbGnctl0hUzwK0XGQSK2Ybxo5nboJ7OkkmnvNpDH9naHWPDDECs/+3718yv7IJ91DN
	eEsSUi1bx2kr69G5sX08YytRMfgMiFrBF9ocZVmHA+49Kg/mz9k7qQRV4k2lwToXle5BnSEBixg
	vFi5i/OgDRihRpTS5Vm9OB7mN+GqV3qtNUXtFZifxOrAWRTdEIcpYzkgmUXtjlCUTitKP8dZnr3
	fXQDdVH1KJOYJbQtg3C4drgfT3CTHIU/EbZGgDBLIffaQYmVDxrGND40r+/SfW59hTokBI25Fvj
	oJ5BMaseQcxwD7n3PnAIo5W2HxqxRi8PDahh3foTQMGkK2/IGbSwHj5XIm9oyEJcViPY6AwvJMx
	ZSyPe7vch9A902bGWDE7hKo4A4Vd4ZKsPx+U3f8WBh+ab7Dn3X79oXsMVuRoYAfBUTMDBEe94gr
	7IaiTKMDp0E7I2OHcA5+FjiiF+mTAfxPUr1vC6+C248MCDMBDGK8VwRvXK72WZqsT2ZiEAchGlG
	25fBOydRKXVPQ==
X-Google-Smtp-Source: AGHT+IGiz0rmAqkF080s48owgkrlhIDOgmhn7Uh2wWe1SA/ZeGElIvqZ5FF6lfn2BTWxOTuvNIrg9w==
X-Received: by 2002:ac8:5e47:0:b0:4e8:9683:3a35 with SMTP id d75a77b69052e-4eda4d392e9mr11493571cf.0.1762555830443;
        Fri, 07 Nov 2025 14:50:30 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:29 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
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
Subject: [RFC PATCH 9/9] [HACK] mm/zswap: compressed ram integration example
Date: Fri,  7 Nov 2025 17:49:54 -0500
Message-ID: <20251107224956.477056-10-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C774A12000F
X-Stat-Signature: 5n4nynia5nrxtmjt61q9pp3ncauc3iic
X-HE-Tag: 1762555831-458868
X-HE-Meta: U2FsdGVkX185eEJtJPsoGzRWsn7QcnyKoxrRME588ncgTC21GS6YMv1ian7thcmnfW58z0Ht2CsARg7ALI7Ldb3Z67v293Rt6TsSBNUuA0p0tNGHz5d6OaHYFEM+xqLQwlyo7jQBHWqT5wpA+FG+WwJrnNaUX+FYHxOiTXTOFUgB2d4lSuWZL2lvzKkhnIjt1XaAiJxsxlIXPq8ZCzKYrne6DrRCk1cMkZ1z9+z1Wj4nFMhiJ8/J5AQgBoPqalpPz3yTmflWeA98P0TAmDm/x9CpayEVUOLMZH8hDV9y2YTHbndRVIfIJXNy8SHNc7LKtl1AEHyLmuE2EkXiO4JHpNPpPyIfXIuQzX7SMaFLC07y2a1/KvToSAkIULdtI08gerrsYJ3aI97NkXuUhWh87mnwoZYypGDnqkzTrelT+jpaWy2DX3ksa4TNRcVadxzJTSOLcGQc/UDLTKqeOTC6soCZHHhP5jm0i+KVIU9A5bXE9IJA7IkJYFCX5VsV4hkuNHOBSzBQC4+2g5O+luAfAzirYkwNLpbuiQOSpmn0pkCQvXMSzjeXkUnnwdMNoPd5u/czxu8avKD8ehhoieyFDzRyFhH6T63daomIwPjoGDd6Glwz8ijkb12ebUFJGjRO8EEUHHOi3HUkMTvA+kqKvto5Z+rYmfF+KQrhSvvmUSbX/S7WwiVqPe5tPG5HC8/tsT2CGRDSYMV3Ig+0a14i4WCzYOU7vKPpVYwUtZnstKuqcdL+HwPdHgj5xyAJzrGRNxkeMBZbyVBl/bfDa/32eXCxI2kJamKY7ws5g2m1lUNBJWqMGLB6BIi/HLZPt+IwYcR6Bv96wyNXMudK3LvKWmLoWhlfpjinpjTAMRr+u+n4DFXlCGJ3JxKYmWB9ne7obO3VEocLsSO9u7iTx8ejv11/hEuLE62eYsf9/XarQkdw8odr5tGC4DhoBwx/lu8dSwa4bd6yLPkPWpyJQSn
 0UqBCku/
 0OyKSPjRoScAG+kUSDiM9A6Bi+1DZAwCPMwoohe8/ULuNH98W697eCyspjnssPmOa945/wzD14gOiC8N75oo2rTHHV00m+V3z0QzEQp8TJJjTT7ff5j53HPUu4eH9BSPw1SXMejewVbUSrZlhP+YOU7OpwRMU5PoXwe8m9OAepXWZUF9+HrQT8ukRKqfplW4ZePUOIkRZz+tSCwA8YzwLf3hFFtKTU3e/6VcmSUB5afObATHaToTehL6xuxB7KLZZ4+HmoLu6V8FdOmhBfNlUuR7WDvq3cfEIq00RXK3NGVXxgcz53v5OeQbt86+ljI3gfel7n8QpeCja9FzcRi7K04isBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here is an example of how you might use a protected memory node.

We hack in an mt_compressed_nodelist to memory-tiers.c as a standin
for a proper compressed-ram component, and use that nodelist to
determine if compressed ram is available in the zswap_compress
function.

If there is compressed ram available, we skip the entire software
compression process and shunt memcpy directly to a compressed memory
folio, and store the newly allocated compressed memory page as the
zswap entry->handle.

On decompress we do the opposite: copy directly from the stored
compressed page to the new destination, and free the compressed
memory page.

Note: We do not integrate any compressed memory device checks at
this point because this is a stand-in to demonstrate how the protected
node allocation mechanism works.  See the "TODO" comment in
`zswap_compress_direct()` for more details on how that would work.

In reality, we would want to make this mechanism out of zswap into
its own component (cram.c?), and enable a more direct migrate_page()
call that actually re-maps the page read-only into any mappings, and
then provides a write-fault handler which promotes the page on write.

This prevents any run-away compression ratio failures, since the
compression ratio would be checked on allocation, rather than allowed
to silently decrease on writes until the device becomes unstable.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory-tiers.h |  1 +
 mm/memory-tiers.c            |  3 ++
 mm/memory_hotplug.c          |  2 ++
 mm/zswap.c                   | 65 +++++++++++++++++++++++++++++++++++-
 4 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 3d3f3687d134..ff2ab7990e8f 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -42,6 +42,7 @@ extern nodemask_t default_dram_nodes;
 extern nodemask_t default_sysram_nodelist;
 #define default_sysram_nodes (nodes_empty(default_sysram_nodelist) ? NULL : \
 			      &default_sysram_nodelist)
+extern nodemask_t mt_compressed_nodelist;
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index b2ee4f73ad54..907635611f17 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -51,6 +51,9 @@ nodemask_t default_dram_nodes = NODE_MASK_NONE;
 /* default_sysram_nodelist is the list of nodes with RAM at __init time */
 nodemask_t default_sysram_nodelist = NODE_MASK_NONE;
 
+/* compressed memory nodes */
+nodemask_t mt_compressed_nodelist = NODE_MASK_NONE;
+
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
 	.dev_name = "memory_tier",
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ceab56b7231d..8fcd894de93c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1592,6 +1592,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	/* At this point if not protected, we can add node to sysram nodes */
 	if (!(mhp_flags & MHP_PROTECTED_MEMORY))
 		node_set(nid, *default_sysram_nodes);
+	else /* HACK: We would create a proper interface for something like this */
+		node_set(nid, mt_compressed_nodelist);
 
 	/* create new memmap entry */
 	if (!strcmp(res->name, "System RAM"))
diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..09010ba2440c 100644
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
+	int nid = first_node(mt_compressed_nodelist);
+	struct page *dst;
+	gfp_t gfp;
+
+	if (nid == NUMA_NO_NODE)
+		return NULL;
+
+	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE |
+	      __GFP_PROTECTED;
+	dst = __alloc_pages(gfp, 0, nid, &mt_compressed_nodelist);
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
+	if (!nodes_empty(mt_compressed_nodelist)) {
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
@@ -939,6 +992,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
+	/* compressed ram page */
+	if (entry->direct) {
+		struct page *src = (struct page*)entry->handle;
+		struct folio *zfolio = page_folio(src);
+		memcpy_folio(folio, 0, zfolio, 0, PAGE_SIZE);
+		__free_page(src);
+		goto direct_done;
+	}
+
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
 
@@ -972,6 +1034,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
+direct_done:
 	if (!decomp_ret && dlen == PAGE_SIZE)
 		return true;
 
-- 
2.51.1



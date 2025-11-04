Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F6CCCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2288E0119; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A708E011A; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E6E8E0119; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB2358E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAB1A16041E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:53 +0000 (UTC)
X-FDA: 84072359826.18.9EC6316
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9161C40003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bW5ePSU+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247571; a=rsa-sha256;
	cv=none;
	b=eKCYy8Rqh6kKwxFAP/ESdoRLJU24/PWulIJuoVy8vji/ye3ECDqa2YVEz0EdCBebEjJvp4
	aAxC+VTkDbqqWgKI2kgZLrOihyagHjrxUle/sl6MuWZ1cHsxqsSjbZpJZ8HiIeCwGugmi/
	hq16JZFASq7vf1h/NRo3E1wqxh/dpxs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bW5ePSU+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFPMexAPAKD/eQEIu2dP+Pldp85C8BrC663dIhUlTQM=;
	b=bLlNloU5AqwZZUP1lOcGSp9aZcTLdb4w38JAAxQBVsKUBGnEBaqQ71hgu6ov36onkE6+sB
	FfCeVW6NsJv9otxftTkvxLwfZ8SZWTz9oPP6QsSngh0U7mz6w6IZPkSjdhHm1fTcO1j4xt
	Lf5muvRgcK8QrCCTbLKr4fvHW8fkhVM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247571; x=1793783571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7teW3SlROipyLBLJwFDaaCq8Z55GJjq54ZLgBEWHdGs=;
  b=bW5ePSU+quJ8tKjcLfFBxVsZn6KskwktFM01lt06i3GqG1m9YnN+2eGu
   Ha1OLncgFEaDUJB5T4mHhJLgqJSthz/cIb26TivuU3h2h9vRGlRidcvKQ
   VCQ7nwChG/hiVXE1PAVk/7j0fgxfyapuEkXHHkh5F3DM0ovJYxHWChntW
   AxMPFf8661vSF7k+QvLD6I9j13dgkOsb7TcQzYfpMKr9V2AqXCXOGJkZz
   g6K2vbiK+lk+Kyw6pWRbdIDO2wAns8ApOgZOAi3zbxPWqkLgq3LMTddQz
   CBEr1Qvcy7dtu0L/SOb6SIIJLIiCpOb6IEkJu89XM+FXG/wyD0JZupWV4
   w==;
X-CSE-ConnectionGUID: gXPjQNrKT/GBMjOHT7ASNA==
X-CSE-MsgGUID: MBQPe8C8T7K+JZ3G4fFLzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265202"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265202"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:39 -0800
X-CSE-ConnectionGUID: xaarhzxyQ32kLL6B5c6ojA==
X-CSE-MsgGUID: gt34vz07RAS1C5sPe4vQDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795833"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:40 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist from pool creation to deletion.
Date: Tue,  4 Nov 2025 01:12:32 -0800
Message-Id: <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9161C40003
X-Stat-Signature: uk3uez1qirqw4o3cdz3q8b1p3391zj3p
X-HE-Tag: 1762247571-769853
X-HE-Meta: U2FsdGVkX18Wjd3tJtbfmYrMWOKK6s8ImQrhUyBaXZ+RR9GPQHCZ3ZTGUWc0DzGno5ANGPSf40sIa+Q5VI3AcRsl1rQ+1QRZ8u8IzhnN6jbEgTGHmFSb/maRNIZEkHaX72VXBV/Z7jAbpcyIGLxZ5annUhqUp6/cja6kEPA6yK02FfeixiOeHEE5t9S7MmlW2GTghDzkVjE9uW/jrZMVkisKluwph3FMn4uJXLekaGz4TNOxcqSpLTwFPiBAa1rvfJeX19ChASwSpiA9jTlHjI0hmYu6BdTSKzHeSg087xliHV5Utmd18E4xAkNg1XfpuMfCpm/dtDivHswf+XDrucXGdDm0/QBwAUEQUZb0D6YXGIEVonhAfUx2HXXFs/Rk9fkM8GLzAw1jwJ2wXYc24bFtFCDMkvUFeJQ4Xdf7mkPALOHb06xhgF1JB80N8cJPf071vSq1WR05gImDaGrWYay/VfjanJEr6gNAFgsUrYNPpbfBOHHXqUvoKp2JpGq9j9ezpsD+MO1FolowNNaL/qs79feR4ZwyppRxMuVQwEs/JlpLvGkxd6XGHuQwFF/9NiJYiJzttSDodHO2t++jVUjARbQ6uyrBeBzbHZ75Xj4bg1Bfi6zhi/rp/su2JcVSsG4sWJM5RMKn4Q04WZQe2tkDzEdjGXq9Zg9WqSqGe+OPXAgmCW5lGJKJt4GWNLW3Jk1cqdjLRl45vKxElA5kruB9sWNe1kZ5ZbaZLt240Vvsex/8KY51E5yDPN1th5NEQm/RwUrukuokpo1AdI0ZjErqmw0AI5Th2TRMSQmlX6vU0SDV/cdXi2tun5lrQ1ByGHe3idKJmdfpsC6em0oar6LofdoDVnH0yUsaoOk17mblKjdQTNG1/WMQovtAtzuGkyD5BT9HTvEacEd1I4wg+10+5gGk2V7k/1iep7C3SN5NH2tlBs3P0N3ESEKpcpinWYQmJej3viq2OPQqTwP
 N3Nv70TN
 b7Us4aXJMAH7w03xP+R4Q7Q4bVVDFzpKTDcusszlDu/csZ/2NP4ZAz7HYbhHreFOr+6LDzV4gIZS1zwBr9bMhF1nmE7H83WLZfch0ro54+3cEHvKr9/2Q5VlakLTw3apA6tLjwlgpPMqyMv/0USx1SBqC4HESPSGP8VbjVvr4nJVUxofBRc9jlqm8fur1UKM+9HlQ3Dxd2bEKsK2NtiI9FL3mUOiM4qoNEE6f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch simplifies the zswap_pool's per-CPU acomp_ctx resource
management. Similar to the per-CPU acomp_ctx itself, the per-CPU
acomp_ctx's resources' (acomp, req, buffer) lifetime will also be from
pool creation to pool deletion. These resources will persist through CPU
hotplug operations instead of being destroyed/recreated. The
zswap_cpu_comp_dead() teardown callback has been deleted from the call
to cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE). As a result, CPU
offline hotplug operations will be no-ops as far as the acomp_ctx
resources are concerned.

This commit refactors the code from zswap_cpu_comp_dead() into a
new function acomp_ctx_dealloc() that is called to clean up acomp_ctx
resources from:

1) zswap_cpu_comp_prepare() when an error is encountered,
2) zswap_pool_create() when an error is encountered, and
3) from zswap_pool_destroy().

The main benefit of using the CPU hotplug multi state instance startup
callback to allocate the acomp_ctx resources is that it prevents the
cores from being offlined until the multi state instance addition call
returns.

  From Documentation/core-api/cpu_hotplug.rst:

    "The node list add/remove operations and the callback invocations are
     serialized against CPU hotplug operations."

Furthermore, zswap_[de]compress() cannot contend with
zswap_cpu_comp_prepare() because:

  - During pool creation/deletion, the pool is not in the zswap_pools
    list.

  - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
    out. zswap_cpu_comp_prepare() will be run on a control CPU,
    since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of "enum
    cpuhp_state". Thanks Yosry for sharing this observation!

  In both these cases, any recursions into zswap reclaim from
  zswap_cpu_comp_prepare() will be handled by the old pool.

The above two observations enable the following simplifications:

 1) zswap_cpu_comp_prepare(): CPU cannot be offlined. Reclaim cannot use
    the pool. Considerations for mutex init/locking and handling
    subsequent CPU hotplug online-offline-online:

    Should we lock the mutex of current CPU's acomp_ctx from start to
    end? It doesn't seem like this is required. The CPU hotplug
    operations acquire a "cpuhp_state_mutex" before proceeding, hence
    they are serialized against CPU hotplug operations.

    If the process gets migrated while zswap_cpu_comp_prepare() is
    running, it will complete on the new CPU. In case of failures, we
    pass the acomp_ctx pointer obtained at the start of
    zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
    only undergo migration. There appear to be no contention scenarios
    that might cause inconsistent values of acomp_ctx's members. Hence,
    it seems there is no need for mutex_lock(&acomp_ctx->mutex) in
    zswap_cpu_comp_prepare().

    Since the pool is not yet on zswap_pools list, we don't need to
    initialize the per-CPU acomp_ctx mutex in zswap_pool_create(). This
    has been restored to occur in zswap_cpu_comp_prepare().

    zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
    valid. If so, it returns success. This should handle any CPU
    hotplug online-offline transitions after pool creation is done.

 2) CPU offline vis-a-vis zswap ops: Let's suppose the process is
    migrated to another CPU before the current CPU is dysfunctional. If
    zswap_[de]compress() holds the acomp_ctx->mutex lock of the offlined
    CPU, that mutex will be released once it completes on the new
    CPU. Since there is no teardown callback, there is no possibility of
    UAF.

 3) Pool creation/deletion and process migration to another CPU:

    - During pool creation/deletion, the pool is not in the zswap_pools
      list. Hence it cannot contend with zswap ops on that CPU. However,
      the process can get migrated.

      Pool creation --> zswap_cpu_comp_prepare()
                                --> process migrated:
                                    * CPU offline: no-op.
                                    * zswap_cpu_comp_prepare() continues
                                      to run on the new CPU to finish
                                      allocating acomp_ctx resources for
                                      the offlined CPU.

      Pool deletion --> acomp_ctx_dealloc()
                                --> process migrated:
                                    * CPU offline: no-op.
                                    * acomp_ctx_dealloc() continues
                                      to run on the new CPU to finish
                                      de-allocating acomp_ctx resources
                                      for the offlined CPU.

 4) Pool deletion vis-a-vis CPU onlining:
    The call to cpuhp_state_remove_instance() cannot race with
    zswap_cpu_comp_prepare() because of hotplug synchronization.

This patch deletes acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock().
Instead, zswap_[de]compress() directly call
mutex_[un]lock(&acomp_ctx->mutex).

The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
offlining, and only deleting them when the pool is destroyed, is as
follows, on x86_64:

    IAA with 8 dst buffers for batching:    64.34 KB
    Software compressors with 1 dst buffer:  8.28 KB

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 164 +++++++++++++++++++++--------------------------------
 1 file changed, 64 insertions(+), 100 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4897ed689b9f..87d50786f61f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -242,6 +242,20 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
+static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
+{
+	if (IS_ERR_OR_NULL(acomp_ctx))
+		return;
+
+	if (!IS_ERR_OR_NULL(acomp_ctx->req))
+		acomp_request_free(acomp_ctx->req);
+
+	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+		crypto_free_acomp(acomp_ctx->acomp);
+
+	kfree(acomp_ctx->buffer);
+}
+
 static struct zswap_pool *zswap_pool_create(char *compressor)
 {
 	struct zswap_pool *pool;
@@ -263,19 +277,26 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
-	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
+	/* Many things rely on the zero-initialization. */
+	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
+					   GFP_KERNEL | __GFP_ZERO);
 	if (!pool->acomp_ctx) {
 		pr_err("percpu alloc failed\n");
 		goto error;
 	}
 
-	for_each_possible_cpu(cpu)
-		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
-
+	/*
+	 * This is serialized against CPU hotplug operations. Hence, cores
+	 * cannot be offlined until this finishes.
+	 * In case of errors, we need to goto "ref_fail" instead of "error"
+	 * because there is no teardown callback registered anymore, for
+	 * cpuhp_state_add_instance() to de-allocate resources as it rolls back
+	 * state on cores before the CPU on which error was encountered.
+	 */
 	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
 				       &pool->node);
 	if (ret)
-		goto error;
+		goto ref_fail;
 
 	/* being the current pool takes 1 ref; this func expects the
 	 * caller to always add the new pool as the current pool
@@ -292,6 +313,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+
+	for_each_possible_cpu(cpu)
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -322,9 +346,15 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
 
 static void zswap_pool_destroy(struct zswap_pool *pool)
 {
+	int cpu;
+
 	zswap_pool_debug("destroying", pool);
 
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+
+	for_each_possible_cpu(cpu)
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+
 	free_percpu(pool->acomp_ctx);
 
 	zs_destroy_pool(pool->zs_pool);
@@ -736,39 +766,35 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct crypto_acomp *acomp = NULL;
-	struct acomp_req *req = NULL;
-	u8 *buffer = NULL;
-	int ret;
+	int ret = -ENOMEM;
 
-	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!buffer) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	/*
+	 * To handle cases where the CPU goes through online-offline-online
+	 * transitions, we return if the acomp_ctx has already been initialized.
+	 */
+	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+		return 0;
 
-	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp)) {
+	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffer)
+		return ret;
+
+	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	if (IS_ERR(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
-		ret = PTR_ERR(acomp);
+				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
+		ret = PTR_ERR(acomp_ctx->acomp);
 		goto fail;
 	}
+	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
-	req = acomp_request_alloc(acomp);
-	if (!req) {
+	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
+	if (!acomp_ctx->req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
-		ret = -ENOMEM;
 		goto fail;
 	}
 
-	/*
-	 * Only hold the mutex after completing allocations, otherwise we may
-	 * recurse into zswap through reclaim and attempt to hold the mutex
-	 * again resulting in a deadlock.
-	 */
-	mutex_lock(&acomp_ctx->mutex);
 	crypto_init_wait(&acomp_ctx->wait);
 
 	/*
@@ -776,84 +802,19 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
-	acomp_ctx->buffer = buffer;
-	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
-	acomp_ctx->req = req;
-
 	acomp_request_set_unit_size(acomp_ctx->req, PAGE_SIZE);
 
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
 fail:
-	if (acomp)
-		crypto_free_acomp(acomp);
-	kfree(buffer);
+	acomp_ctx_dealloc(acomp_ctx);
 	return ret;
 }
 
-static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
-{
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct acomp_req *req;
-	struct crypto_acomp *acomp;
-	u8 *buffer;
-
-	if (IS_ERR_OR_NULL(acomp_ctx))
-		return 0;
-
-	mutex_lock(&acomp_ctx->mutex);
-	req = acomp_ctx->req;
-	acomp = acomp_ctx->acomp;
-	buffer = acomp_ctx->buffer;
-	acomp_ctx->req = NULL;
-	acomp_ctx->acomp = NULL;
-	acomp_ctx->buffer = NULL;
-	mutex_unlock(&acomp_ctx->mutex);
-
-	/*
-	 * Do the actual freeing after releasing the mutex to avoid subtle
-	 * locking dependencies causing deadlocks.
-	 */
-	if (!IS_ERR_OR_NULL(req))
-		acomp_request_free(req);
-	if (!IS_ERR_OR_NULL(acomp))
-		crypto_free_acomp(acomp);
-	kfree(buffer);
-
-	return 0;
-}
-
-static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
-{
-	struct crypto_acomp_ctx *acomp_ctx;
-
-	for (;;) {
-		acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-		mutex_lock(&acomp_ctx->mutex);
-		if (likely(acomp_ctx->req))
-			return acomp_ctx;
-		/*
-		 * It is possible that we were migrated to a different CPU after
-		 * getting the per-CPU ctx but before the mutex was acquired. If
-		 * the old CPU got offlined, zswap_cpu_comp_dead() could have
-		 * already freed ctx->req (among other things) and set it to
-		 * NULL. Just try again on the new CPU that we ended up on.
-		 */
-		mutex_unlock(&acomp_ctx->mutex);
-	}
-}
-
-static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
-{
-	mutex_unlock(&acomp_ctx->mutex);
-}
-
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
@@ -866,7 +827,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	u8 *dst;
 	bool mapped = false;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
@@ -929,7 +892,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -941,7 +904,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
 	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -972,7 +936,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 read_done:
 	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	if (!decomp_ret && dlen == PAGE_SIZE)
 		return true;
@@ -1798,7 +1762,7 @@ static int zswap_setup(void)
 	ret = cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE,
 				      "mm/zswap_pool:prepare",
 				      zswap_cpu_comp_prepare,
-				      zswap_cpu_comp_dead);
+				      NULL);
 	if (ret)
 		goto hp_fail;
 
-- 
2.27.0



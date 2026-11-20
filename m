Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4477606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hd1Q0BRo
Received: by kanga.kvack.org (Postfix)
	id 7C9966B0755; Thu, 19 Nov 2026 23:19:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2D36B0756; Thu, 19 Nov 2026 23:19:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690286B0757; Thu, 19 Nov 2026 23:19:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37ACE6B0755
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:19:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9340140CDC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:30 +0000 (UTC)
X-FDA: 85454193300.24.64C7158
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7D3BA000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hd1Q0BRo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795148369;
	b=Ql1xIMMpudJB1FV6XAKOFuQnoseobK4A3hNejjuC67zOnRWZSHUFlguVEb0XtXj5ogZIaY
	Ms9UsjSr5+f1nlipctxZunou2V5Braz1N6Cjax6rvLqqX1mi+O+ShXqB5DvoTAeeZfr2qp
	3ahj/f5VN9qgDDOukLyxWn0TbuqwUMo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDv05nkOneIbU+C75C/3/SwzM7ssV+xwiPDI9idFT20=;
	b=bePEX3eaVrxnLHRY1wVgdlJug6xILKcPT999qER1FEgjHWyMwSC5Mpy2a1XEyw/GS2AIpL
	OzCICEtroNpGPWwuRG1dXRiZhB1+osAQkZLCP0RxQnZpoabsOpjlZFfmkg9Kbyy8CtjHtc
	M4PA3u4D2AB6HEoroyk8ckp94dZmTjw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hd1Q0BRo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1b3ada81853so542640c88.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148368; x=1795753168; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jDv05nkOneIbU+C75C/3/SwzM7ssV+xwiPDI9idFT20=;
        b=hd1Q0BRoExW5+qSHpQ+zFBgdiVUYx/wRnqOS+OM2fZMkPw95iWvqb3YlIDwpWc/CqQ
         AHX8sAMuBzMmeBPNKvM4XvRnunaNrnxiKfKQXOhCQGDKUMNxxO6SORDwcTEfszhqPAvh
         fR4c5Z0dMvPr/w43p1j/ZnhC4DQVuH4WK/wD4G//WiDfnlZXChhuCSgnrZfK4uJMLInZ
         /DHF1jaKWWqLtR4ouSXpoZJjvQDOOeus2dBRnaz2w1DvlcJtIKY7jWD618tcocatY122
         +iiv6Ta7X5FUE23cdKXgbjnsrvmhUjOeLwUbYuXJk28KiZ7HFm/+4/FUWGaxgtJTlc/7
         z4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148368; x=1795753168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jDv05nkOneIbU+C75C/3/SwzM7ssV+xwiPDI9idFT20=;
        b=ZjRsUKF+ezEe5mhwDwKd8oh/lLj3EmVT+iyn6D7BCo/WuOxAnwC64ydMb1ZPdHoj8s
         5NUOfM4s9IaKYN7zqrE08yVXTxcYxu+Az/gT+1NuCgD4LbUhElBq6fkBN6H085cOwCWy
         BIu1JY7W1HoTPiU80HCVAFNb5CoCFY1i2SH62iTed3Tut51J9idUCVkvzwGCQSqGFuIm
         wGGnrBqK0qq5IaH9YZz5mqWW3B6udXw8K6j1QipUFs1UBqu/oJhcUDZfhfokb+FN5ONb
         qU3uUBU1Y0f2yIa69I+GAPb0kwdva1lLPXTXl2zX9VvMMj+pC7ATA93GTiGOhpMFwTk1
         lI9w==
X-Forwarded-Encrypted: i=1; AL+hErGN9yOsbd1qYSrE22k1Msbg6/N5veQFpbscjZYLPRsCuKs7xZjispMOS2+iuOdGnKfgxWR4e657Xg==@kvack.org
X-Gm-Message-State: APuU4Z8oC+xk+/R/5Yb97Nx30E5aDa38BgFrdJlP5Xtpjb+t1l46Wh0s
	Ws+ZyeP+ueLBVK7vtItz/b3F8JijgQtU4ugL7YC01YYH2Ez9aUpRqbJ3
X-Gm-Gg: AYBFou0Dn5tdNxvxZYdKj21O1DTQjK/ap4y/yppeB4DdDLzIjKaOjNURunw0sV/JQyf
	Ogkl6ETq5WjpQMswLQR6P8h3U0D6cNGhjsL99DcqzcYszdKGpOZlCcHwP8HRpW8Kk2hUvl36/XF
	Sb8hKl1MUFOsjb99CJJx0WfUCEIVX/IvEcxYb00xplnq5M+gVWUZftlsAOakKTuGiVA6km5wBXI
	zbMUkttJA7ztvL1Wp3h/8QoW3DsQvyb062QPXLr2mPZPET9VN4x7tSD8lSnLj5IA6uEZXzjIOLY
	4o0PwxM1ZgsaaUDi6aI+eSE2JFQSDsFh63SEU+nrFyuiKLQetzYwTIHOSNOFR7yRkXlHUct202A
	GAOtjZ8aPFhsJ2LhINdRuzhu1/MK1ZbVA3nS9JcukEFQSPHRBT2LFtgmrSm0CRLG/vypb938S7e
	0eN5NMc/klUSxZUvDsAkGvai8QFHdDU2CoUPc9UPFhTLq6WYrhsjGgIJdv8GU56+6wJK6pd6fMr
	rwO1MAm6A7s38zHf49Efg0h48coG1583CqCKtt0U0ggjVsoLGpSU5+C0FmzPi7eJUovAMFwU5US
	eNt1ZP3mTxgv+NeIC+OC8zfdS04EIWwVVn79CVyTAA==
X-Received: by 2002:a05:7022:3a8b:b0:15a:4155:3d9d with SMTP id a92af1059eb24-1b5568d6db3mr1940114c88.31.1795148367700;
        Thu, 19 Nov 2026 20:19:27 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:26 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v4 7/8] mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
Date: Thu, 19 Nov 2026 20:19:05 -0800
Message-Id: <20261120041906.5785-8-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7D3BA000A
X-Stat-Signature: pdiaim8ktbti4zr9sidph8ewrn9t1wcb
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795148368-179954
X-HE-Meta: U2FsdGVkX1/inzIz+GrwE+6LuAHq6WyQYYKFDJXdH9Itaj7nKnTkBBxscntiCxgn4jGlMSFWm2+tXvv5E68PSIZdGSXeSp8bTs7UsEXScpnh/GO41ULYI8aWU9sNxJ3fxkMwSGkv7exQqAxxC6Lqchp2jJp6NUfXqUXIRnQCcQT6GsIOTweU6KOLR+XAlaUmgrAn/yv8BMidKtMWaw0c8PYaH/dx4Hpcmdagv3Bo20Lryf4T94pejqW+ciWxSX17WnIzJHjrYvkCQx9uOBNoXOYnGzEFMiOVpC3rKLrRGz9Vw8y2d9VOoPsI0qR5iefCTr5Tpp02m8J2DudMuHaZREir7WKaK+hvpKR3N1YQCZqLDpm3TjQlp0lZ9NvPPzhL6JlpvkpCrBtZvQ1QvTWut7ayeUU2LodLFR370qY0bnQcU1QNmD9ex884eElPL8kDtLZa3QXgiEGETJThxudAuLpham0WP7RxVc4cojINhYb6iquqpjPNoFGMu+B/9hPKcqQes5B7VNONlpX2B3lm/fr9AMkfSJOn6PgYyRWMLLcoLxkWuS8ogqgQSyHEyp8MOL+EMnaaUZdV7H1UieC+gqvwaHuudXmpO4lyMslsZ4c80FUwxRHBnhfRqNGmpgfODubXZNAoddiZLw5dpyHk8hztvSe8LbFPFU1LTLhtUY8btzprvnCNmyd0iRILMU+r4lPEYZb0uYD5SEAtIS8ixccteMDqBjugk1LCK0lBS/KtQ7ctOM7Ep24peg1AkGpPkvTsgtVGubE70ajnAYa3XVH5E7NOoPjauu8p/L6ChUROhT3Nz6k/7GIzW0Pj5T0uchsxjPgr4V7qjzqhCj/XeeWXsTtB13tlYcU53XD3PxpdflUpduuhIPvxfHhlSVYoBmbwl6E1dv8voEePvUCPz0z3PvDijtpnblrO3GnAB0QF8tpxgtpvGnC/Z5ZgzhwJIz1YsoBM7xjgtfxhiKR
 qriZNojw
 9/T0RY8cccVoVfDhc8iC11yhL+88geFmMPQf/qQYwagzca5xcIVqr6Zd6wx6mIsWIi6giK08w57DK4Y9GbumU1D31xq81IF1T/nv1ohwmFG9aJGYN1drDONDgBIC17ts7kEvnOCIVVz9bL5L6SSm9SsGzlJYDQd1RgQpHuq/q3Fp39uqt0N2CkMsQuiV3e1H8Ei6W1a8yLgz+TyCARCf2YVrJyo/Hv8bEwpJr8mr6iJdhtsaMCUga0mFJzNlbltcGS4OKBJ5kTHdn8gimjYuXO2qo6Y1yMH9Ak5HeuyKM/rqwmfOZOHWSqNwJFd8SztseHozAfxbOng7wqSw1H49ZvL4vRLK0/uwm33Thd0MBKqwff4FAV6h962olstDnuQa1KDj1D50Ei3yKwq2ME7ztEf8wN0kFB0OtZ0jxJDhyLWGT3p9rk6/DDZysBkQJKaXlfFZ2Q56zAPrnode6Qv8Oe5MECHQjrabW3xgJANszN0P7d7wm9Z+LAffRMcf0yeJEkgUryRqm0RELr2B8EByDViWyzQePgXeI19Du11RsaOCHGtsrm7BSubm2Mc6LVa4cLn8nMzT3wh8JiGCCVmWg3hZGBOiBNk4P3qZwwg9ECbUsapTY495PkaiUh8cZsCIr0C7IdMUeCyxosgtOWfOpk5wLeFsgDtuczzIxgyAg4gtgVm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The various stages of zswap_store_pages() are broken down into routines
that work on a batch of data when a large folio is being processed:

 zswap_init_entries()
 zswap_tree_stores()

The struct zswap_store_context is used to pass constraints and data
among these batching components. The resulting code is highly simplified
and maintainable, where each of the batching sub-routines of
zswap_store() can be optimized modularly.

For instance, the zswap_tree_stores() now does the zswap atomics
counter increments, getting pool references, getting objcg references
and objcg zswap charging at the batch level. A new
obj_cgroup_charge_zswap_many() is added to enable batch charging of
compressed bytes for multiple pages/incompressible pages in the batch,
in order to accurately update the MEMCG_ZSWAP* counters.

The next commit will implement batching of zswap_compress().

Subsequent patch series will be submitted, that implement ideas building
upon this batching framework:

 1) Replacing zsmalloc with SLUB allocator, comprising of kmem_caches
    for a finite # of compressed size bins. This enables bulk allocation
    of compressed buffers in a batch that belong to the same size
    bin. It gets rid of significant zsmalloc latency overhead (locks,
    compressed data spanning zspages, etc.), without compromising memory
    efficiency.

 2) vmscan reclaim batching of hybrid any-order folios, that will submit
    a batch of folios to zswap_store()'s batching framework to optimize
    storing of batches of pages from different folios, in addition to
    within large folios.

Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/linux/memcontrol.h |  12 +++
 mm/memcontrol.c            |  23 ++++-
 mm/zswap.c                 | 181 +++++++++++++++++++++++++------------
 3 files changed, 153 insertions(+), 63 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..93f060818c14 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1244,6 +1244,11 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css)
 	return NULL;
 }
 
+static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
+				       unsigned long nr)
+{
+}
+
 static inline void obj_cgroup_get(struct obj_cgroup *objcg)
 {
 }
@@ -1921,6 +1926,8 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
+void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
+				  u8 nr_pages, u8 nr_incomp_pages);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
@@ -1932,6 +1939,11 @@ static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
 					   size_t size)
 {
 }
+static inline void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg,
+						size_t size, u8 nr_pages,
+						u8 nr_incomp_pages)
+{
+}
 static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
 					     size_t size)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..2236f5ba6304 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6345,6 +6345,23 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
  * compression and storage in zswap for this cgroup to go ahead.
  */
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
+{
+	obj_cgroup_charge_zswap_many(objcg, size, 1, (u8)(size == PAGE_SIZE));
+}
+
+/**
+ * obj_cgroup_charge_zswap_many - bulk charge compression backend memory
+ *                                from compressing a batch of pages.
+ * @objcg: the object cgroup
+ * @size: total compressed length of a batch of compressed objects
+ * @nr_pages: # of pages that were compressed to store in zswap
+ * @nr_incomp_pages: # of incompressible pages to store in zswap
+ *
+ * This forces the charge after obj_cgroup_may_zswap() allowed
+ * compression and storage in zswap for this cgroup to go ahead.
+ */
+void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
+				  u8 nr_pages, u8 nr_incomp_pages)
 {
 	struct mem_cgroup *memcg;
 
@@ -6363,9 +6380,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
-	if (size == PAGE_SIZE)
-		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
+	mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
+	if (nr_incomp_pages)
+		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pages);
 	rcu_read_unlock();
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index df59ab0c1029..5e1fb5624ffb 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -491,12 +491,12 @@ static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
 }
 
 /* The caller must already have a reference. */
-static void zswap_pool_get(struct zswap_pool *pool)
+static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
 {
-	percpu_ref_get(&pool->ref);
+	percpu_ref_get_many(&pool->ref, nr);
 }
 
-static void zswap_pool_put(struct zswap_pool *pool)
+static inline void zswap_pool_put(struct zswap_pool *pool)
 {
 	percpu_ref_put(&pool->ref);
 }
@@ -1603,55 +1603,60 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
+/* Functions called by zswap_store(), that operate on batches of pages. */
+
 /*
- * Store multiple pages in @zc->folio, starting from the page at index @start up
- * to the page at index @end-1.
+ * zswap_init_entries() co-locates most of the zswap entry fields' setup under
+ * the assumption that all phases of store processing will succeed. An important
+ * marker to simplify catch-all cleanup in zswap_store_pages() is done by
+ * initializing each entry's @handle to ERR_PTR(-EINVAL).
  */
-static bool zswap_store_pages(struct zswap_store_context *zc,
-			      long start,
-			      long end,
-			      struct zswap_pool *pool,
-			      struct obj_cgroup *objcg)
+static inline void zswap_init_entries(struct zswap_store_context *zc,
+				      struct zswap_pool *pool,
+				      struct obj_cgroup *objcg)
 {
-	u8 i, store_fail_idx = 0;
-	bool ret;
-
-	zc->nr_pages = end - start;
-	zc->folio_start = start;
-
-	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
-
-	ret = zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
-	if (unlikely(!ret))
-		return false;
+	struct zswap_entry *entry;
+	u8 i;
 
 	/*
 	 * We co-locate entry initialization as much as possible here to
 	 * minimize potential cache misses.
 	 */
 	for (i = 0; i < zc->nr_pages; ++i) {
+		entry = zc->entries[i];
 		/*
-		 * Set pool_idx before the xa_store() below publishes the entry, or a
-		 * concurrent reader could resolve a stale pool_idx left by slab reuse
-		 * to an unrelated live pool.
+		 * Set pool_idx before the xa_store() in zswap_tree_stores()
+		 * publishes the entry, or a concurrent reader could resolve a
+		 * stale pool_idx left by slab reuse to an unrelated live pool.
 		 */
-		zc->entries[i]->pool_idx = pool->idx;
-		zc->entries[i]->swpentry = folio_swap_entry(zc->folio,
+		entry->pool_idx = pool->idx;
+		entry->swpentry = folio_swap_entry(zc->folio,
 							zc->folio_start + i);
-		zc->entries[i]->objcg = objcg;
-		zc->entries[i]->referenced = true;
-		zc->entries[i]->nid = zc->nid;
-		INIT_LIST_HEAD(&zc->entries[i]->lru);
+		entry->objcg = objcg;
+		entry->referenced = true;
+		entry->nid = zc->nid;
+		INIT_LIST_HEAD(&entry->lru);
 	}
+}
 
-	for (i = 0; i < zc->nr_pages; ++i) {
-		if (!zswap_compress(zc->folio, zc->folio_start + i,
-				    zc->entries[i], pool, zc->wb_enabled))
-			goto store_pages_failed;
-	}
+/*
+ * zswap_tree_stores() stores the batch entries in xarray and adds them to the
+ * zswap LRU list. If an error occurs during xa_store(), localized state
+ * unwinding is done to erase prior batch entries from the xarray and delete
+ * them from the zswap LRU list. Remaining batch cleanup occurs in
+ * zswap_store_pages(). As batch entries are processed, we maintain aggregate
+ * statistics to do the accounting in one bulk operation.
+ */
+static bool zswap_tree_stores(struct zswap_store_context *zc,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
+{
+	u8 i, store_fail_idx = 0, nr_incomp = 0;
+	size_t total_batch_comp_length = 0;
+	struct zswap_entry *old, *entry;
 
 	for (i = 0; i < zc->nr_pages; ++i) {
-		struct zswap_entry *old, *entry = zc->entries[i];
+		entry = zc->entries[i];
 
 		old = xa_store(swap_zswap_tree(entry->swpentry),
 			       swp_offset(entry->swpentry),
@@ -1663,13 +1668,11 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			zswap_reject_alloc_fail++;
 			/*
 			 * Entries up to this point have been stored in the
-			 * xarray. zswap_store() will erase them from the xarray
-			 * and call zswap_entry_free(). Local cleanup in
-			 * 'store_pages_failed' only needs to happen for
-			 * entries from [@i to @nr_pages).
+			 * xarray. Local cleanup in 'tree_store_failed' needs to
+			 * erase entries up until now.
 			 */
 			store_fail_idx = i;
-			goto store_pages_failed;
+			goto tree_store_failed;
 		}
 
 		/*
@@ -1680,22 +1683,10 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		if (unlikely(old))
 			zswap_entry_free(old);
 
-		/*
-		 * The entry is successfully compressed and stored in the tree,
-		 * and further failures will be cleaned up in zswap_store().
-		 * Grab refs to the pool and objcg, charge zswap memory, and
-		 * increment zswap_stored_pages. The opposite actions will be
-		 * performed by zswap_entry_free() when the entry is removed
-		 * from the tree.
-		 */
-		zswap_pool_get(pool);
-		if (objcg) {
-			obj_cgroup_get(objcg);
-			obj_cgroup_charge_zswap(objcg, entry->length);
-		}
-		atomic_long_inc(&zswap_stored_pages);
+		total_batch_comp_length += entry->length;
+
 		if (unlikely(entry->length == PAGE_SIZE))
-			atomic_long_inc(&zswap_stored_incompressible_pages);
+			++nr_incomp;
 
 		/*
 		 * We finish by adding the entry to the LRU while it's already
@@ -1711,17 +1702,87 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			zswap_lru_add(entry);
 	}
 
+	/*
+	 * Each batch entry is successfully compressed and stored in the tree,
+	 * and further failures will be cleaned up in zswap_store().
+	 * Next, we do bulk accounting for the batch: grab refs to the pool and
+	 * objcg, charge zswap memory, increment zswap_stored_pages and
+	 * zswap_stored_incompressible_pages. The opposite actions will be
+	 * performed by zswap_entry_free() when the entry is removed from the
+	 * tree.
+	 */
+	zswap_pool_get_many(pool, zc->nr_pages);
+	if (objcg) {
+		obj_cgroup_get_many(objcg, zc->nr_pages);
+		obj_cgroup_charge_zswap_many(objcg, total_batch_comp_length,
+					     zc->nr_pages, nr_incomp);
+	}
+	atomic_long_add(zc->nr_pages, &zswap_stored_pages);
+	if (unlikely(nr_incomp))
+		atomic_long_add(nr_incomp, &zswap_stored_incompressible_pages);
+
+	return true;
+
+tree_store_failed:
+	for (i = 0; i < store_fail_idx; ++i) {
+		xa_erase(swap_zswap_tree(zc->entries[i]->swpentry),
+			 swp_offset(zc->entries[i]->swpentry));
+		zswap_lru_del(zc->entries[i]);
+	}
+
+	return false;
+}
+
+/*
+ * Store multiple pages in @zc->folio, starting from the page at index @start up
+ * to the page at index @end-1, i.e. @zc->nr_pages. Each phase of
+ * zswap_store_pages() does batch processing of @zc->nr_pages in the folio.
+ * State unwinding is kept to a minimum as a result of the batch processing: a
+ * batch proceeds to the next phase of store processing only if it passes this
+ * stage. The batch cleanup is consolidated under the @store_pages_failed
+ * label. Errors in storing a batch result in folio level cleanup occurring in
+ * zswap_store().
+ */
+static bool zswap_store_pages(struct zswap_store_context *zc,
+			      long start,
+			      long end,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
+{
+	bool ret;
+	u8 i;
+
+	zc->nr_pages = end - start;
+	zc->folio_start = start;
+
+	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
+
+	ret = zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
+	if (unlikely(!ret))
+		return false;
+
+	zswap_init_entries(zc, pool, objcg);
+
+	for (i = 0; i < zc->nr_pages; ++i) {
+		if (!zswap_compress(zc->folio, zc->folio_start + i,
+				    zc->entries[i], pool, zc->wb_enabled))
+			goto store_pages_failed;
+	}
+
+	ret = zswap_tree_stores(zc, pool, objcg);
+
+	if (unlikely(!ret))
+		goto store_pages_failed;
+
 	return true;
 
 store_pages_failed:
-	for (i = store_fail_idx; i < zc->nr_pages; ++i) {
+	for (i = 0; i < zc->nr_pages; ++i) {
 		if (zs_handle_is_allocated(&zc->entries[i]->handle))
 			zs_free(pool->zs_pool, &zc->entries[i]->handle);
 	}
 
-	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
-				       zc->nr_pages - store_fail_idx);
-
+	zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
 	return false;
 }
 
-- 
2.39.5



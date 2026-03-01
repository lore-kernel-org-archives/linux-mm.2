Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 920A2FD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EDED6B0005; Sat, 28 Feb 2026 20:17:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571076B0089; Sat, 28 Feb 2026 20:17:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FF26B008A; Sat, 28 Feb 2026 20:17:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33D6E6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:17:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C15BBB8D35
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:17:39 +0000 (UTC)
X-FDA: 84495731838.21.EAD2343
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id ED32A100009
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:17:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T78uilr6;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772327858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hFljTe8H5yfHVqQk+RtwscRldrSW3olqqHSatXxOv94=;
	b=BG6j4QiYVGscUhRRik66VH2adk0rpEhLdbEELv2NuFOxgpLmRzSV4Y4HSfQddhTKsFpdvX
	P6sup5VaBT2DDhEg3+LrHVD1yxnZgD4yGQiFLJyR3sWEb8SkbF1zUc8E1RnlDgEv9ZJBFh
	wQcnbfqnnkh99Bg6TdekOF/oXjJH8JA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T78uilr6;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772327858; a=rsa-sha256;
	cv=none;
	b=HK/ldxh58NWIioebln8BArbdeHVkPIb6C7XEoeQfFd6+cPLsD3Y8rPHz9Wy6AOkqMa/Dkz
	aDQ0jo8auLjsUvVS+Kmjo9Z1X6h6FKqwjmXZY47B1TZUEznEfQWnMmYDpB1BA16nNuaBFP
	bth/BbZ1PlJXk/Z3/dFus7YOwoBr75Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A91DA406FA;
	Sun,  1 Mar 2026 01:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1771CC19421;
	Sun,  1 Mar 2026 01:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772327856;
	bh=zcArhl0GoQilinOJ1PmLSQPty16J9IbWGZMnHeqUveY=;
	h=From:To:Cc:Subject:Date:From;
	b=T78uilr62xic7TU/6Tq2katOXgyevE6Gf9iSB08uO83ms218iti7Ar0/wNLmvpQCF
	 GRf1uYJmLeMbXlF+ln3R/Fex6BAokUrZc+GfWEor7ibGX8tE5IcX7Y+jRSAwV6rV+/
	 ZKH8fMc/i/JRe232AvuIIxdHGgEWTvVsX2KJ5Buc3pZDTXLMROmCktpFO8wTycyD3X
	 HveALLZv52mjPi9btj9Y8JOxO9NxM2UmPWjYoNyE/ToyTbtkblMxgDs/0drWJuIaSw
	 3xGkgQqzx5PWkSzDeTBmF/2lXMlVLukIqkdR42hKOD/nLY6TjZPaSIVYvRXoTA1eNP
	 vFLPtkfhAdcmA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	harry.yoo@oracle.com
Cc: Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/slab: use prandom if !allow_spin" failed to apply to 6.18-stable tree
Date: Sat, 28 Feb 2026 20:17:34 -0500
Message-ID: <20260301011734.1671547-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ED32A100009
X-Stat-Signature: q8y5erz8671sbu3oxj6u9fk5uzgfihj3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772327857-728401
X-HE-Meta: U2FsdGVkX18CuE7fll9zbzBOTkMkFIaQw2KgE5QtSmOghayI0TnxhA0piuKxD7spsHrHXlWqUroS0/459na45VyqnpTVq9W3lIueuvbWLRDhambO/CyZvjSuXN/HygT4fWpTl3P0vPdIiCxbd24RFSN3FlIfvK5+WgWXP1q8XrRH1IS7fCVp3g/6kF+gpGSuXnB9oFUvb81lqRNISfS+gWDE1X7S3Ifw8N1t1zUzg6T3GrvP0rGV+/HQCgmaaxtKvw7lIeE1wvN2Wl+wS7X2uQ7f3l/+zZNqrS5dfl3Q4UMTV+2Sa+yKAXDTpD4WOR1I+Er4GxT/XCACqBTJQJy6sYfykS5H8f1/fgfFM/sw++4MDhTLB54xKXOWKv1F3MgkPmQlKQCNfWK5FTTu7k3t2WN/h9vc5sk1unQmF26mItORlp8qaqLJytM5wqjGFFSZEVd46O8vSavOqbNmAj8xmmvA78u/cUL/LHnmENQmt/DG9HJKjxN6z0tPm5vkNlyHNn64YWIDJ6lw+/zrs7yz1/P3OaZ8k51dYXw9+xkVEb3OF1x80mbFZq7TXw6A10aRWk/lQzL7iqM0su1exmYmd1XuZU0PlyLUfLkoFqB9Wy+LhWg2ohHWIXC9nOmYPodn1yHu5Z9n1BwDzSc42z8srtR+nxArJrgyGQHWiFsdKK4WQYOGQ6kBqTy17/oG7m3vOkU3iklkf9wJUItOB/TAGO2o75+2qAHuxQkmn576zZ/SgP4KIGgO34rhw1+6lybswe2XjMUMFKjJJ7J2fu54sEovwNWw12qYlUMi1g6md6u34WE9cpx1ppEWk0a6geGf4muoLEEgwegdBS517AWoT1Bmagi4T+49q777dhFPceUAeXuaLsO96ujajhezxenJriUIvHVf0vX1ww06bzLrxifFinz96hwEvhfSCzdMnymq5RjjmCkqtJTWtyqyS0GUR5IBpxefh6lQVXIZDOs
 N+ARx1n0
 eVB0NAgvpDo40sFl6zRzbqOBNi+PNBG57IGiA6FKThevIa8QZp2bu1CbopUrmsEo40grONuFDdap6WERtKiQa7s8M5GhCLP3DZa737QTaBiTSad1vMm+ht0MyPPFHZ/HAbugU4je1Kz7c3PbCM6HZt9zuAmuRfQ9PgEfkK7DD+N+wK5F9t6COKcuZVqZEm/ZZPmJr4gT3/7G97S0WHF5WuB8z1PBpT9TrrpaSw2a7aNwP/BsVm25ZTyIsqNzE9Uvlr2+wxNioerFNWWxwu8HNW1VVxtd3rpGIIR9N1dDx3+wlVPJTRuSi6zCOXCnYNhqEdpMFniQGVD2k9ulxchLdlrdRCQ6Lb6jmmSA+St4G5s/+OFHFR2K9pINGz146Gd6YzZ+rYeyV7u1tZszCo4Pfq8Ew69Y/4gm58cZtHf9VXhncW0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From a1e244a9f177894969c6cd5ebbc6d72c19fc4a7a Mon Sep 17 00:00:00 2001
From: Harry Yoo <harry.yoo@oracle.com>
Date: Tue, 10 Feb 2026 17:19:00 +0900
Subject: [PATCH] mm/slab: use prandom if !allow_spin

When CONFIG_SLAB_FREELIST_RANDOM is enabled and get_random_u32()
is called in an NMI context, lockdep complains because it acquires
a local_lock:

  ================================
  WARNING: inconsistent lock state
  6.19.0-rc5-slab-for-next+ #325 Tainted: G                 N
  --------------------------------
  inconsistent {INITIAL USE} -> {IN-NMI} usage.
  kunit_try_catch/8312 [HC2[2]:SC0[0]:HE0:SE1] takes:
  ffff88a02ec49cc0 (batched_entropy_u32.lock){-.-.}-{3:3}, at: get_random_u32+0x7f/0x2e0
  {INITIAL USE} state was registered at:
    lock_acquire+0xd9/0x2f0
    get_random_u32+0x93/0x2e0
    __get_random_u32_below+0x17/0x70
    cache_random_seq_create+0x121/0x1c0
    init_cache_random_seq+0x5d/0x110
    do_kmem_cache_create+0x1e0/0xa30
    __kmem_cache_create_args+0x4ec/0x830
    create_kmalloc_caches+0xe6/0x130
    kmem_cache_init+0x1b1/0x660
    mm_core_init+0x1d8/0x4b0
    start_kernel+0x620/0xcd0
    x86_64_start_reservations+0x18/0x30
    x86_64_start_kernel+0xf3/0x140
    common_startup_64+0x13e/0x148
  irq event stamp: 76
  hardirqs last  enabled at (75): [<ffffffff8298b77a>] exc_nmi+0x11a/0x240
  hardirqs last disabled at (76): [<ffffffff8298b991>] sysvec_irq_work+0x11/0x110
  softirqs last  enabled at (0): [<ffffffff813b2dda>] copy_process+0xc7a/0x2350
  softirqs last disabled at (0): [<0000000000000000>] 0x0

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(batched_entropy_u32.lock);
    <Interrupt>
      lock(batched_entropy_u32.lock);

   *** DEADLOCK ***

Fix this by using pseudo-random number generator if !allow_spin.
This means kmalloc_nolock() users won't get truly random numbers,
but there is not much we can do about it.

Note that an NMI handler might interrupt prandom_u32_state() and
change the random state, but that's safe.

Link: https://lore.kernel.org/all/0c33bdee-6de8-4d9f-92ca-4f72c1b6fb9f@suse.cz
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20260210081900.329447-3-harry.yoo@oracle.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 90f0e66671300..591e41e5acc49 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -43,6 +43,7 @@
 #include <linux/prefetch.h>
 #include <linux/memcontrol.h>
 #include <linux/random.h>
+#include <linux/prandom.h>
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
 #include <linux/sort.h>
@@ -3311,8 +3312,11 @@ static void *next_freelist_entry(struct kmem_cache *s,
 	return (char *)start + idx;
 }
 
+static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
+
 /* Shuffle the single linked freelist based on a random pre-computed sequence */
-static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
+static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
+			     bool allow_spin)
 {
 	void *start;
 	void *cur;
@@ -3323,7 +3327,19 @@ static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
 		return false;
 
 	freelist_count = oo_objects(s->oo);
-	pos = get_random_u32_below(freelist_count);
+	if (allow_spin) {
+		pos = get_random_u32_below(freelist_count);
+	} else {
+		struct rnd_state *state;
+
+		/*
+		 * An interrupt or NMI handler might interrupt and change
+		 * the state in the middle, but that's safe.
+		 */
+		state = &get_cpu_var(slab_rnd_state);
+		pos = prandom_u32_state(state) % freelist_count;
+		put_cpu_var(slab_rnd_state);
+	}
 
 	page_limit = slab->objects * s->size;
 	start = fixup_red_left(s, slab_address(slab));
@@ -3350,7 +3366,8 @@ static inline int init_cache_random_seq(struct kmem_cache *s)
 	return 0;
 }
 static inline void init_freelist_randomization(void) { }
-static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
+static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
+				    bool allow_spin)
 {
 	return false;
 }
@@ -3441,7 +3458,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	alloc_slab_obj_exts_early(s, slab);
 	account_slab(slab, oo_order(oo), s, flags);
 
-	shuffle = shuffle_freelist(s, slab);
+	shuffle = shuffle_freelist(s, slab, allow_spin);
 
 	if (!shuffle) {
 		start = fixup_red_left(s, start);
@@ -8341,6 +8358,9 @@ void __init kmem_cache_init_late(void)
 {
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
 	WARN_ON(!flushwq);
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+	prandom_init_once(&slab_rnd_state);
+#endif
 }
 
 int do_kmem_cache_create(struct kmem_cache *s, const char *name,
-- 
2.51.0






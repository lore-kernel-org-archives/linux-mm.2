Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C783A606A32F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQG9sXiE
Received: by kanga.kvack.org (Postfix)
	id 8C6DD6B05B8; Sun, 15 Nov 2026 10:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D7B6B05B9; Sun, 15 Nov 2026 10:10:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1DB6B05BA; Sun, 15 Nov 2026 10:10:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E206B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:10:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C47E5A84A9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:36 +0000 (UTC)
X-FDA: 85437690072.26.77AAB3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 28B18A0016
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQG9sXiE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhLQyFlJTVqmSyEWQTJRy69VcFNeB6bgSqFN8dNPAm0=;
	b=vszocFxwTC5Xs8HeugEIoAEuXDBeL6fIUV3aeaI5yw8P3gDFdAgCZ7xLd18c4tjE2UlHcD
	H3e5eyBtuJPuHZqQyl6yAp3ivAoBkUKFXmwmshzmqD2c5WIkmSxSLgP34izpQbqBgNIGur
	Er32Ja7KtTGi1fTF9IxfsW5Qkba20RQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQG9sXiE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794755435;
	b=mj/MOUxLXgcsVhGbKFNNA+LhDCmQ/JiGucuJjf8YVvpndSwXaarQARG9xVt7Vg/JaN3jZY
	i4/orFMuVL1eZTCrvAAWD2MkfrmT5p5/lq+OKzpsO+DVtlmB5peu9wXEx3xgr3Bykv4wvO
	u2Dh196JCq070kqq/GpA2uBD2ssP4IA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7000745C05;
	Sun, 15 Nov 2026 15:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ACB1F000C4;
	Sun, 15 Nov 2026 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755434;
	bh=GhLQyFlJTVqmSyEWQTJRy69VcFNeB6bgSqFN8dNPAm0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hQG9sXiE+U22az+UEwlgIGfv2rH2zG23/scIb7H+C02Q/5k9hM0vqdMl+YLbEKpqa
	 2h3Em/gXnQ0dMWXjF/cIW9Z4nHOclMc+gVRPpO7yROE7sITl06NgpNM1S0I/DFZ9x3
	 pPkyQPu0OkQsTdv5NJVN1RLgQvJOXsd0YTaooOVyFRZYF0Cs+qgEU/bJCd/TKVZ6sr
	 y3e6wpmlrDYjpclYJqqs1GzcKuGz2AvBp4WcYNBlnlsjGUrEmV78BsPlj3MJZtLoC+
	 nkeHqvZ34HQHANfcrB5zCWk2gqkb+Tvb7MoGY7fFyFtQ/VqwJR7qTe53pSNt0/A6Cp
	 BQ+WOXjMKO3TA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:40 +0000
Subject: [PATCH for-next v3 6/7] mm/slab: refactor free_to_pcs()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-kmalloc-nolock-fixes-v3-6-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 28B18A0016
X-Stat-Signature: fx7z151szp9ut1eorfsgfsjc4ppndrya
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794755434-957965
X-HE-Meta: U2FsdGVkX1/HnwxGpe9OGl3PEbyTdBFrRoqDIYkTUsQvyzgKw5RD24XB6V6noUt2F3CxtgRuIhNUyGhRpl9v1A59md1QqbXUi+kyZRP+qmwHOluLx6cNg3t8WPoz1vH+i4jgWryaDLhfOwdmnpSwSBZVFMHkabLoQMyfp7dcCam+sWmDuTzUcMfaWoayxw6IkRHPZfz7D1GIeeR7zR45WCYLtDsUwO//xPkzLcBnFLsOaz3Sx182ZtaZaXhAPh0Y5I41yc55z1g/20UcfJeso3o2Ur+nTXCirxM2BW8RKn39ma0SFfdcEe+VPvRw5KY+NVjnyn9hcoeiNUf3avaE1J7ycIWe/CGpmr7Rg2hC9c7wvLoXMFtEsoplTtkTgDZ6vvDh9FooOFIrnZieuRg1wMKh5y9f25DHPw5yAiwAbZrMcr7Ew8muv+T5DTkQF505K6iUpBY5ON0zXj6htzpJ+jTOE17ternW137+ScNZeYwr3n0quhpN4KFGIuzCR+2tQ2eOFYoTWMdJBUsen1uRjoswsSIZhenrHM8TwKTbClvK7f655yoPnrkhhAYzhBu3n1lM9U85b2O0YA/QOKqhfgmGPvZ0G6bAj/MHOhxNPM1cshIYbtcD7P8H2L9AoxY54AScwMcmY3fy0hWUA0aLGq3AI5sXMToQiOKLAWhf5QJ6K//morlmm2vBgGOPumiVpELQ0pVsvlFhy4Qt9Bvsm6M0kNH/PYuifRbP8102jT0XSFFoo8F/CcqE93QFjWJhwMKUUYsNkSuAbD61nkWPxbHyj4YA8fn4KQdF00yuuWEqzezB2RXSQS50maJK/EX4AVShiS9dMAF+OzNC1U+NZZpD6Id6ydsu98UFIsDYfeUZDIQsE8VGzT24rIqKR7zc5/Fq8nO/rZ+vk52sLnqVaaSwBrbEs9mG0pwdgchSKv6bsQgDue5fEiI0CBhsUaV7Qr2KzoLpOjUSivp/+k1
 2kf3GgzY
 tpuHJK9tnhJfd591+q8Xs0HGuh4YyEQydJcTEn0nTB01JqdxCs4EvvyGLPAZbeUCbE/WKLJJw6e1hhluVbuCK1JCDv1GeYHrh2KsELajE29R/7El1yXTGS5KLjGY1Cvic4LBi+zY65ZbVoT8Y12BXPUj4YdRC2cN/T2JjwGx0v+i+GnXD4eDkPSmYmxBosg8/ORlVr0DMu0w8i0BvROfxKTYiyA9NC2ErGBidxTLT/2ds2mgXvvdJcJ8rQVoB+Z5JSi8rXlDGD1B82xo3Ew1zQZ7RBBZ73InJZXYegObg7fWTuPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every caller of free_to_pcs() has to call can_free_to_pcs() before it.
Refactor this by adding a slab parameter and calling can_free_to_pcs()
from free_to_pcs(). To do this, move can_free_to_pcs() above
free_to_pcs().

Note that can_free_to_pcs() cannot be folded into free_to_pcs() as
free_to_pcs_bulk() still needs it.

While at it, let free_to_pcs() take free_flags instead of allow_spin.

No functional change intended.

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 119 ++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 61 insertions(+), 58 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index aec9fb6e2235..fd3de3bee1de 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6148,15 +6148,71 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	return pcs;
 }
 
+static __always_inline bool can_free_to_pcs(struct slab *slab)
+{
+	int slab_node;
+	int numa_node;
+
+	if (!IS_ENABLED(CONFIG_NUMA))
+		goto check_pfmemalloc;
+
+	slab_node = slab_nid(slab);
+
+#ifdef CONFIG_HAVE_MEMORYLESS_NODES
+	/*
+	 * numa_mem_id() points to the closest node with memory so only allow
+	 * objects from that node to the percpu sheaves
+	 */
+	numa_node = numa_mem_id();
+
+	if (likely(slab_node == numa_node))
+		goto check_pfmemalloc;
+#else
+
+	/*
+	 * numa_mem_id() is only a wrapper to numa_node_id() which is where this
+	 * cpu belongs to, but it might be a memoryless node anyway. We don't
+	 * know what the closest node is.
+	 */
+	numa_node = numa_node_id();
+
+	/* freed object is from this cpu's node, proceed */
+	if (likely(slab_node == numa_node))
+		goto check_pfmemalloc;
+
+	/*
+	 * Freed object isn't from this cpu's node, but that node is memoryless
+	 * or only has ZONE_MOVABLE memory, which slab cannot allocate from.
+	 * Proceed as it's better to cache remote objects than falling back to
+	 * the slowpath for everything. The allocation side can never obtain
+	 * a local object anyway, if none exist. We don't have numa_mem_id() to
+	 * point to the closest node as we would on a proper memoryless node
+	 * setup.
+	 */
+	if (unlikely(!node_state(numa_node, N_NORMAL_MEMORY)))
+		goto check_pfmemalloc;
+#endif
+
+	return false;
+
+check_pfmemalloc:
+	return likely(!slab_test_pfmemalloc(slab));
+}
+
 /*
  * Free an object to the percpu sheaves.
  * The object is expected to have passed slab_free_hook() already.
  */
 static __fastpath_inline
-bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
+bool free_to_pcs(struct kmem_cache *s, struct slab *slab, void *object,
+		 unsigned int free_flags)
 {
+	bool allow_spin = free_flags_allow_spinning(free_flags);
 	struct slub_percpu_sheaves *pcs;
 
+	if (unlikely(!can_free_to_pcs(slab)))
+		return false;
+
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		return false;
 
@@ -6355,57 +6411,6 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	return false;
 }
 
-static __always_inline bool can_free_to_pcs(struct slab *slab)
-{
-	int slab_node;
-	int numa_node;
-
-	if (!IS_ENABLED(CONFIG_NUMA))
-		goto check_pfmemalloc;
-
-	slab_node = slab_nid(slab);
-
-#ifdef CONFIG_HAVE_MEMORYLESS_NODES
-	/*
-	 * numa_mem_id() points to the closest node with memory so only allow
-	 * objects from that node to the percpu sheaves
-	 */
-	numa_node = numa_mem_id();
-
-	if (likely(slab_node == numa_node))
-		goto check_pfmemalloc;
-#else
-
-	/*
-	 * numa_mem_id() is only a wrapper to numa_node_id() which is where this
-	 * cpu belongs to, but it might be a memoryless node anyway. We don't
-	 * know what the closest node is.
-	 */
-	numa_node = numa_node_id();
-
-	/* freed object is from this cpu's node, proceed */
-	if (likely(slab_node == numa_node))
-		goto check_pfmemalloc;
-
-	/*
-	 * Freed object isn't from this cpu's node, but that node is memoryless
-	 * or only has ZONE_MOVABLE memory, which slab cannot allocate from.
-	 * Proceed as it's better to cache remote objects than falling back to
-	 * the slowpath for everything. The allocation side can never obtain
-	 * a local object anyway, if none exist. We don't have numa_mem_id() to
-	 * point to the closest node as we would on a proper memoryless node
-	 * setup.
-	 */
-	if (unlikely(!node_state(numa_node, N_NORMAL_MEMORY)))
-		goto check_pfmemalloc;
-#endif
-
-	return false;
-
-check_pfmemalloc:
-	return likely(!slab_test_pfmemalloc(slab));
-}
-
 /*
  * Try to free as many objects (already processed by free hooks) as possible to
  * a single per-cpu sheaf.
@@ -6642,7 +6647,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	if (unlikely(!slab_free_hook(s, object, free_flags)))
 		return;
 
-	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
+	if (likely(free_to_pcs(s, slab, object, free_flags)))
 		return;
 
 	__slab_free(s, slab, object, object, 1, addr);
@@ -6656,7 +6661,6 @@ void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
 			      unsigned int alloc_flags)
 {
 	struct slab *slab = virt_to_slab(object);
-	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
 	unsigned int free_flags = to_free_flags(alloc_flags);
 
 	if (slab_want_init_on_free(s))
@@ -6667,11 +6671,10 @@ void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
 	if (unlikely(!slab_free_hook(s, object, free_flags)))
 		return;
 
-	if (likely(can_free_to_pcs(slab)) &&
-	    likely(free_to_pcs(s, object, allow_spin)))
+	if (likely(free_to_pcs(s, slab, object, free_flags)))
 		return;
 
-	if (likely(allow_spin))
+	if (likely(free_flags_allow_spinning(free_flags)))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
 	else
 		defer_free(s, object);
@@ -6991,7 +6994,7 @@ void kfree_nolock(const void *object)
 	if (unlikely(!slab_free_hook(s, x, free_flags)))
 		return;
 
-	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
+	if (likely(free_to_pcs(s, slab, x, free_flags)))
 		return;
 
 	/*

-- 
2.54.0



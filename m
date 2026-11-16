Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E58606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WyciufVo
Received: by kanga.kvack.org (Postfix)
	id 0085E6B05BD; Mon, 16 Nov 2026 01:47:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F218F6B05BE; Mon, 16 Nov 2026 01:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E37DD6B05BF; Mon, 16 Nov 2026 01:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD0E46B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C5CC1A08D2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:39 +0000 (UTC)
X-FDA: 85440051438.29.81883F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7C4B640005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyciufVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtLIbSo48K9CccVqc5phPEZBBM23ut66AAk1YeVVHH4=;
	b=DI+swqsYvgyr9CMSew1aAp+zpZrnZovkbMQZmzU5myQDpGAQQ8cJt7yfIwWeUOfrSV3OzP
	kmnIKBWt0Q2tKs3d+l2eJvq00RjkRDmLKfHswDQoF2vZSfhU3s0CTpleLEj+lJ/hno43Td
	78belo4d+vW1TkNiag0w/kAkMLbpWGA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyciufVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811657;
	b=M9HXY/LKq7vKI6IPMho0riQhn5IMO7GZxG6uJ6zoH8EXdjMsTzGfx7AxsF5mzVuJUvoGE+
	lgYTMlN8EQMqrWTJs6n1/BUss9G22LpI3RSgxWmEcPoOqF+VC2D8OLF8PL4UXtAmGI5gZu
	AhFIfL8y9Jtv58dvBZbt9O2w9S/Ekzw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1F9145A7D;
	Mon, 16 Nov 2026 06:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF81F000C4;
	Mon, 16 Nov 2026 06:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811656;
	bh=YtLIbSo48K9CccVqc5phPEZBBM23ut66AAk1YeVVHH4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WyciufVoqkp3MohcOppU5Y+0Cvp0Y58i56WSsRZke9g0zuhifQXzWP2NvUoym2HPm
	 UcR84Z7qj8ju8MAZIXLIf1pohaHngjJhQKIr3/lEqqs0s/jXGLqKzbiIiFUIec24bb
	 jlSUc4B7W1Mj8kdcRMXTcqMXgImk6RRsQR52rs3M/Q2kyvTHujplkvtAW3bGeqDeou
	 ApfHEr2Vur0ev8sp2hEoRVyMxCFmUbfPrYJVc6MoQCyaECcccNULkQHTX9pY+3q7yH
	 aYhocGpkPWiEtp7Y70+84cah8vrmzqcGNKn/ES0iGVX3b1mTFH1Fgov39+q4HIai6G
	 Y8UIctPOCUKFg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:13 +0100
Subject: [PATCH v4 05/10] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-5-227a4b3636a5@kernel.org>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
In-Reply-To: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C4B640005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qic33qh1funf7kd44j3rrupgpm5oaycu
X-HE-Tag: 1794811657-356638
X-HE-Meta: U2FsdGVkX1+Hn57Wtam5oUpQf6Tsk+R46lio7uA7XUvz6Pg9pizu3I1sS1ggAq5LudeVfOyTXBISuxX4oVCnHjrvKlbv56ae/RC5zN7Pp20uUWXcxd3K2MkppW/4zGsYEtvQ9TtAJpI2PbKJdXDy5NwBgmLBkd8GhgrNF/1sOY5eUPCpz28CRjaygk6D3kJ8luFxZxWOk2UzFPvNaWNOTJ4yeuF6YjdZkCjzSF0BdGjAKYJwIn12gM/+qH/b36/Bo059zbHk7bCMTMGA0+RnzNeKmp2+jp1v5uj7wM4HjeakF1+rZJKZBaNNyGCxY6uSeNMoxPu+WR4t4Q1duL+FQ6p+fP2dBuAm0GtFEouSyVlcbF8q+jnnIupnKHruKk08OkAfhsbOr5znh1KdZRqBNXO3WMO7htoU8traO3tyGuIIZoeq0c+Y5Cgld9Pl3Ye79wQxKAxvPsgDqVHrn/NbSbt3y7QIZdoQNVJ6agJ5C884tjr8KvuFRlIinA6UfbkRH/7clWyPetSlpxnm6q0NiyfMcPtRYePbaPTOTYkOUHTS2sZLSaLEkmhCoBpHnmEutVphQnY17P2SfqpEwDtQG1hIcGSMbNQQd92S5QdcDpWX7Fp723QLCA1TXGSo3u04vkTeIAozryj2PpbCCUpzvjl6hJsstedXUidYCbsknpKEF0iOulfVZV2j3bvpYjwujc8Y6i1Kxlh0YGf6RIy1fJDbUqv6QyBZxPvZytoWRcsEXk84QUSpgyah5Sn8kyFkm6oF4o4b+pCbFDsiI/9OXKW77SnvoeuTiZJlI/1G3KLHKq0KK3qLObm3Q+HPz7FVl04mdkO5hxaxyd9IsKqzEYMGpkg3OGCDiWrkq6Yp7t1ojYLYF4wLL+JtD+C50kcwurnaa0WM8FMjhF8u3v5Sqe++DJKJNDKk3rphgHJLxZZD8dfDecmbbQ57d+UJkDJNERNAN9uw8omhysuVzJ4
 iNP8YjGr
 MYqXIOnWJlxQLxcGzAvUnx0kFppQdC040z/OB23dpuRPBAOk4pwma5S/ob58TEGs+1TSwwCgU71D2Jx5cA9AuamX1w+mmfk6TzjvXUz8kLkDNS+r1YZA4nweed8u0nDcr+UHN+hz4qb1MACfLCrndCnQCh5O4p3Ns5J7stz/0OgYYmfLsvaO0zEZCCzjESDUUAyd31BBzMNl+2CSdxshojlLFVM+DOFcnpqNbWnAX/JB7Gx43ElL7eiIn2/svs03zhFTC0ze9M9eROgGe2m/gy2YAcuj5VwIyx9ovz2u+mVF5288kwsJGje3ABLCVthdiSgTPWWKwjwmEdw9EAB0rxNWFP1U3yTUAQjsfzBBEhB5kSrrjmtor4H1MOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

One (relatively minor) aspect of CONFIG_SLUB_TINY is the assumption that
letting reclaimable and non-reclaimable caches merge will save more
memory, which is more important on small systems than the page allocator
level fragmentation (where distinguishing reclaimable slabs should
help).

For now that has been achieved by #ifdefs that result in making the
SLAB_RECLAIM_ACCOUNT no-op and aliasing KMALLOC_RECLAIM to
KMALLOC_NORMAL on the enum values level.

With the goal of converting CONFIG_SLUB_TINY to a boot-time decision,
rework this so that SLAB_RECLAIM_ACCOUNT and KMALLOC_RECLAIM are
distinctly defined always. Now, creation of kmalloc-rcl caches is
avoided by assigning a pointer to the normal kmalloc cache on the
kmalloc_caches array level.

To prepare disconnecting of this boot-time decision (and the evaluation
of the need for kmalloc_no_objext) from CONFIG_SLUB_TINY, introduce a
slab_tiny_enabled variable that's initialized to the CONFIG_SLUB_TINY
state.

Since SLAB_RECLAIM_ACCOUNT is not 0 anymore, caches that differ only in
that flag would stop being mergeable. To avoid this potential impact on
memory footprint, start dropping the flag on cache creation when
slab_tiny_enabled is true.

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h | 10 ----------
 mm/slab.h            |  5 +++--
 mm/slab_common.c     | 15 +++++++++------
 mm/slub.c            |  2 ++
 4 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ed949e8522be..930dd64b9ad6 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -55,9 +55,7 @@ enum _slab_flag_bits {
 #ifdef CONFIG_KFENCE
 	_SLAB_SKIP_KFENCE,
 #endif
-#ifndef CONFIG_SLUB_TINY
 	_SLAB_RECLAIM_ACCOUNT,
-#endif
 	_SLAB_OBJECT_POISON,
 	_SLAB_CMPXCHG_DOUBLE,
 #ifdef CONFIG_SLAB_OBJ_EXT
@@ -241,11 +239,7 @@ enum _slab_flag_bits {
  * pages are allocated with __GFP_RECLAIMABLE, which affects grouping pages by
  * mobility, and are accounted in SReclaimable counter in /proc/meminfo
  */
-#ifndef CONFIG_SLUB_TINY
 #define SLAB_RECLAIM_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_RECLAIM_ACCOUNT)
-#else
-#define SLAB_RECLAIM_ACCOUNT	__SLAB_FLAG_UNUSED
-#endif
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
 /* Slab caches without obj_exts array */
@@ -724,11 +718,7 @@ enum kmalloc_cache_type {
 #endif
 	KMALLOC_PARTITION_START = KMALLOC_NORMAL,
 	KMALLOC_PARTITION_END = KMALLOC_PARTITION_START + KMALLOC_PARTITION_CACHES_NR,
-#ifdef CONFIG_SLUB_TINY
-	KMALLOC_RECLAIM = KMALLOC_NORMAL,
-#else
 	KMALLOC_RECLAIM,
-#endif
 #ifdef CONFIG_ZONE_DMA
 	KMALLOC_DMA,
 #endif
diff --git a/mm/slab.h b/mm/slab.h
index 79774e2be3bb..835d977634ec 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -396,6 +396,8 @@ extern const struct kmalloc_info_struct {
 	unsigned int size;
 } kmalloc_info[];
 
+extern bool slab_tiny_enabled;
+
 /* Kmalloc array related functions */
 void setup_kmalloc_cache_index_table(void);
 void create_kmalloc_caches(void);
@@ -576,8 +578,7 @@ static inline bool need_kmalloc_no_objext(void)
 	if (!mem_alloc_profiling_permanently_disabled())
 		return true;
 
-	if (!mem_cgroup_kmem_disabled() &&
-			(KMALLOC_NORMAL == KMALLOC_RECLAIM))
+	if (!mem_cgroup_kmem_disabled() && slab_tiny_enabled)
 		return true;
 
 	return false;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 4df73eda1090..bd31184e0642 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -352,6 +352,9 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 	if (args->sheaf_capacity)
 		flags |= SLAB_NO_MERGE;
 
+	if (slab_tiny_enabled)
+		flags &= ~SLAB_RECLAIM_ACCOUNT;
+
 	mutex_lock(&slab_mutex);
 
 	err = kmem_cache_sanity_check(name, object_size);
@@ -840,11 +843,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_CGROUP_NAME(sz)
 #endif
 
-#ifndef CONFIG_SLUB_TINY
 #define KMALLOC_RCL_NAME(sz)	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #sz,
-#else
-#define KMALLOC_RCL_NAME(sz)
-#endif
 
 #ifdef CONFIG_KMALLOC_PARTITION_CACHES
 #define __KMALLOC_PARTITION_CONCAT(a, b) a ## b
@@ -981,7 +980,11 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 	unsigned int aligned_size = kmalloc_info[idx].size;
 	int aligned_idx = idx;
 
-	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
+	if (type == KMALLOC_RECLAIM) {
+		if (slab_tiny_enabled) {
+			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
+			return;
+		}
 		flags |= SLAB_RECLAIM_ACCOUNT;
 	} else if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_CGROUP)) {
 		if (mem_cgroup_kmem_disabled()) {
@@ -1014,7 +1017,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 	 * KMALLOC_NO_OBJ_EXT cache.
 	 */
 	if (!mem_cgroup_kmem_disabled()) {
-		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
+		if (type == KMALLOC_NORMAL && !slab_tiny_enabled)
 			flags |= SLAB_NO_MERGE;
 		else if (!(flags & SLAB_NO_OBJ_EXT))
 			flags |= SLAB_MAY_ACCOUNT;
diff --git a/mm/slub.c b/mm/slub.c
index 3eff5ef4ac80..0238c990351c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -219,6 +219,8 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			slab_obj_ext_has_codetag_key);
 #endif
 
+bool slab_tiny_enabled __read_mostly = IS_ENABLED(CONFIG_SLUB_TINY);
+
 /* Structure holding extra parameters for slab allocations */
 struct slab_alloc_context {
 	unsigned long caller_addr;

-- 
2.56.0



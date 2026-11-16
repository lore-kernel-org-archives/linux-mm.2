Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56AC606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qq58fmit
Received: by kanga.kvack.org (Postfix)
	id 8934B6B05BB; Mon, 16 Nov 2026 01:47:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C846B05BC; Mon, 16 Nov 2026 01:47:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7DA6B05BD; Mon, 16 Nov 2026 01:47:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3346B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF8A6808EE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:35 +0000 (UTC)
X-FDA: 85440051270.23.857C833
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21B5E100004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qq58fmit;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6OoPVgHbPcVlyg0bdAKK6MSz7k2hURzUkdi2cy+F0Uk=;
	b=Sbq6dm4XP6jdDn9o72iBB9GuaIC3yBwvW1Rg7ictBiu8MidhKBgGbi8LkSnn5ZNxgWAFRQ
	nxGD6sha/PvhJED5LpB6/mgYaFuIosEHKLZQ7G0Lgi8NcFZ1tUDoNed4ajCMCmjk5lf9Mj
	zE7AGNLZnbmcAZfyIcX8qsoq5L2WhdQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811654;
	b=ly0dpg1ErQioJGkLCR6DwJtu2y79b1p3q1OcMf23Qxzb3kGIf+R/I8UolCVsw6JfLRW99r
	95Ba361L5CNkX3fQGLvOMWkTpW6F1PBsGVG5jH7A0DOsmJ6Qtr3TA/U7mFLOXcKpVeTB9Z
	pJw4mpw6ytOApD8NN2Ulkb3WazVoMbA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qq58fmit;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E3C2459C3;
	Mon, 16 Nov 2026 06:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF6F1F000CA;
	Mon, 16 Nov 2026 06:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811653;
	bh=6OoPVgHbPcVlyg0bdAKK6MSz7k2hURzUkdi2cy+F0Uk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Qq58fmitITyVdc9xLE0LoygJhD+cMGyXK6uYcmcjAeynFwpLwjWxf28Kfj6L9MqF3
	 eM29Y35OXqX8M/K3WycCts5xYTBRe7+Y1p6ZyoC/UVFYXsrZysmG9d4nfYe2DzzSf2
	 5oHmYsRKF+qXcy8HHZigQGgEjyKEdUj7apNZ+FUhJyZdOdzQHxhTukbTRYWB8PPxwm
	 dyPgXK5nGhpuzCc0jAM3Kk0+qv1Kd9Hr7mPeJjHUvJEfUFzhvgKtepgaB8dsAx6AOb
	 H2Pa+aX4JAwWXa1o6thbqkf5Jwoqjqfi8kq+zE3AexcrqSeWKjkXgPlNLFuZ05mnYU
	 LVVX/2HXlS6Cw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:12 +0100
Subject: [PATCH v4 04/10] mm, slab: introduce slab_debug=N
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-4-227a4b3636a5@kernel.org>
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
X-Stat-Signature: wfqf8ebew4q7x3nt5mb8eehrr37qis58
X-Rspamd-Queue-Id: 21B5E100004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794811653-48129
X-HE-Meta: U2FsdGVkX1+MlCNKNPCZtJpzuCOT3bFdyET0ajuqE2gzJgExVunwcWJMLl73Ir5Y3besVV4vsbJmW4gVNRs+oBP/Sfnit3YsgZc8HjppyQEAzrjpw0ZTpVbN6KAMFvLrD9TpJ14ivB0LQoDjfk8eMldkBpc89FDi1LT8go19qF+j31ciaiUF0ECjQ4soG/mqVEZUkcwNzJIvk18Uaz/D9/MH+D6X49Gv9JgaUgszMQrUR2bNlymv5wAtFGN+80TtS8wRlNok/UgcmMPpXf4kjjcsOfiDCyutDhRfZhA3DSFzQH0BoAaXgzXsC61r5se9CxJXRTVygWJ7hhskBwE+8EtoRUMcamFYp58hqC3/VHyWxxTy34UMSiaY8VWaq1oSBS4meevzJ2QqNDMlYMkSoDMkxCSD/XX1dM2G8Ev2InHQQQGi+uli1Wl7hF+l6B0YPEvIulx2pTrPZUZaesmGVLVK/lIJ6Cn+t2rcndH/jw/79c5sWqKBKNxgL76mKDaPXP+KGZe9aeNut/rKAnwrvWU8J0XX13LA8vRcK4ejakkIn4wrw5yBIdazYOeDI5pYX++QlyzsFitQeW4ZLA5Ur/vejLgU5M8dWetzXmj8WTC/fdAd1X9Z2gEFVkBUafj4FnLfzx2yIcoWeZ+nuMsH9j99GM5dSOhZTLg0UK+F7LsYkG1r3DTGLvVBMzGA8FHE0PuecR4DoS7l3/sl86cRjbbVqqerrbvU60nijxAvyhvCycxlcpblIsDQTuD9fougTd7PFLW8ATPxo1IdrPw6QolKNeUGjYjhythpW1uzKOPrs5h7EdJ1B5ScM0wntUqQWWA/yVRLEIq3NAuaxnbNtrNCGr966UQu1Ae6uS48FMtj1F2qdqt+f8d6MKwh0n6PKUkA5Ne1okKU01NL3TTjpqnJFI9w7bo6TFkJ7hr6dGmm0xe2CW9yACpV9DjbA2fiJgScgvBCzg4ORSQZFzs
 DqfMp9aX
 K/NfRCtkr5ZOnV2Zml/dPbJU4jQ1rpJswbHitEwVD+neyjUQvTkot1qf/C7s3RU/fqTkkffOQXTTFID5BrWFGwD4z4CX4/cf6N6PztuAQNsJEoeTubRDmzjyDbRB9qy3R8mubdhPypS7H/i2wby3VzEo6GnV1bv9mMTSHw9Jm2B1ONWo+0Vps6uR1X/rZPAeH5rzTc96NPhrFtMo6OVNPFcjeKxzCLFZUuI5R0+ktbzcGVymA/z1oY4cI/tBxXbwb1gGO2PCOcyrBdPBTea5/Tw1uwVkhHIOGvut8suaaIjWxyeIOlbMtRPjdhe4idkCejxxJ1jCqA+6k28Suj2TBGrxC+kce32lJgEbSmFe3itnNnjg2DviCkSykghiROSwsrBHtsu76pNaPSv2c/36ETGATX/Oc72Lx42HB3LSsv5AOb4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Enabling slab_debug has the side-effect of disabling all percpu caching
of objects (now via sheaves), which can be sometimes useful for saving
memory for e.g. kdump kernels. To make this possible without the
overhead (CPU or memory) of actual debugging options such as poisoning,
introduce a No-op debug option that only forces the debugging slow paths
and zero sheaf capacity. The new corresponding slab flag is
SLAB_DEBUG_NOOP.

This will also allow reimplementing CONFIG_SLUB_TINY as a boot-time
option.

Two details have to be considered, as suggested by Harry Yoo [1].

- While SLAB_DEBUG_NOOP is part of SLAB_DEBUG_FLAGS, it should not
  prevent cache merging as it doesn't affect object metadata, and lack
  of merging would go against the memory footprint reduction. Thus
  exclude the flag from SLAB_NEVER_MERGE.

  - However add the flag to SLAB_MERGE_SAME, per sashiko. This needs to
    be reflected in create_unique_id() as well, which an earlier version
    didn't. Add comments to help not forgetting this the next time.
    While at it, remove unnecessary SLAB_CONSISTENCY_CHECKS handling in
    create_unique_id(), as it's part of SLAB_NEVER_MERGE.

- SLAB_DEBUG_NOOP alone should not request disabling printk pointer
  hashing. Thus rework the call to hash_pointers_finalize() to not rely
  on the slub_debug static key state. Instead determine whether the
  global or per-cache slab_debug options include any flags that are not
  SLAB_DEBUG_NOOP. This does not change the fact that caches created
  with explicit debug flags (i.e. slub_kunit tests) later in boot have
  no effect on pointer hashing, which is determined in
  kmem_cache_init().

While documenting the new N option, remove obsolete SLAB references from
the F option description.

[1] https://lore.kernel.org/all/arUx56ee_nkxYP_f@thinkstation/
[2] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=2

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/admin-guide/mm/slab.rst | 13 +++++++++++--
 include/linux/slab.h                  |  5 ++++-
 mm/slab.h                             |  2 +-
 mm/slab_common.c                      | 13 +++++++++----
 mm/slub.c                             | 30 ++++++++++++++++++++++++------
 5 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/mm/slab.rst b/Documentation/admin-guide/mm/slab.rst
index 14429ab90611..0beeae71d472 100644
--- a/Documentation/admin-guide/mm/slab.rst
+++ b/Documentation/admin-guide/mm/slab.rst
@@ -45,12 +45,12 @@ of the first "select slabs" blocks that matches the slab's name are applied.
 
 Possible debug options are::
 
-	F		Sanity checks on (enables SLAB_DEBUG_CONSISTENCY_CHECKS
-			Sorry SLAB legacy issues)
+	F		Sanity (slab consistency) checks on alloc and free
 	Z		Red zoning
 	P		Poisoning (object and padding)
 	U		User tracking (free and alloc)
 	T		Trace (please only use on single slabs)
+	N		No-op (force debugging slowpaths without any checks)
 	A		Enable failslab filter mark for the cache
 	O		Switch debugging off for caches that would have
 			caused higher minimum slab orders
@@ -85,6 +85,15 @@ in low memory situations or if there's high fragmentation of memory.  To
 
 	slab_debug=O
 
+The No-op option can be useful to minimize slab memory overhead by forcing slab
+debugging slowpaths, which disables percpu object caching. This reduces SMP
+scalability significantly, but does not impose the extra cpu or memory overhead
+of debugging options that actually perform checks. This can be useful for e.g.
+kdump kernels where scalability is not a concern, but memory has to be
+pre-reserved from the production kernel. So for a kdump kernel you can use::
+
+	slab_debug=N
+
 You can apply different options to different list of slab names, using blocks
 of options. This will enable red zoning for dentry and user tracking for
 kmalloc. All other slabs will not get any debugging enabled::
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67a..ed949e8522be 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -35,6 +35,7 @@ enum _slab_flag_bits {
 	_SLAB_PANIC,
 	_SLAB_TYPESAFE_BY_RCU,
 	_SLAB_TRACE,
+	_SLAB_DEBUG_NOOP,
 #ifdef CONFIG_DEBUG_OBJECTS
 	_SLAB_DEBUG_OBJECTS,
 #endif
@@ -166,8 +167,10 @@ enum _slab_flag_bits {
  * Note that SLAB_TYPESAFE_BY_RCU was originally named SLAB_DESTROY_BY_RCU.
  */
 #define SLAB_TYPESAFE_BY_RCU	__SLAB_FLAG_BIT(_SLAB_TYPESAFE_BY_RCU)
-/* Trace allocations and frees */
+/* DEBUG: Trace allocations and frees */
 #define SLAB_TRACE		__SLAB_FLAG_BIT(_SLAB_TRACE)
+/* DEBUG: Force the debug slowpaths without actually doing anything */
+#define SLAB_DEBUG_NOOP		__SLAB_FLAG_BIT(_SLAB_DEBUG_NOOP)
 
 /* Flag to prevent checks on free */
 #ifdef CONFIG_DEBUG_OBJECTS
diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc..79774e2be3bb 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -476,7 +476,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
+			  SLAB_TRACE | SLAB_DEBUG_NOOP | SLAB_CONSISTENCY_CHECKS)
 
 #define SLAB_FLAGS_PERMITTED (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS)
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 01c64ef661e7..4df73eda1090 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -47,12 +47,17 @@ struct kmem_cache *kmem_cache;
  * Any flag that adds per-object metadata should be included,
  * since slab merging can update s->inuse that affects the metadata layout.
  */
-#define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
-		SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE | \
-		SLAB_OBJ_EXT_IN_OBJ)
+#define SLAB_NEVER_MERGE ((SLAB_DEBUG_FLAGS & ~SLAB_DEBUG_NOOP) | \
+		SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | SLAB_FAILSLAB | \
+		SLAB_NO_MERGE | SLAB_OBJ_EXT_IN_OBJ)
 
+/*
+ * Set of flags that caches need to both have or both not have in order to
+ * be mergeable. These need to be also reflected in create_unique_id().
+ */
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
-			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
+			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT | \
+			 SLAB_DEBUG_NOOP)
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
diff --git a/mm/slub.c b/mm/slub.c
index 30714557306d..3eff5ef4ac80 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1053,6 +1053,19 @@ static slab_flags_t slub_debug;
 static const char *slub_debug_string __ro_after_init;
 static int disable_higher_order_debug;
 
+/* Union of all slab debug flags enabled for specific caches only */
+static slab_flags_t slab_debug_per_cache_union __initdata;
+
+static inline bool __init slab_want_nohash_pointers(void)
+{
+	/*
+	 * If any debugging is enabled globally or per-cache, we would like
+	 * nohash pointers. The exception is no-op debugging that only forces
+	 * the slowpaths.
+	 */
+	return (slub_debug | slab_debug_per_cache_union) & ~SLAB_DEBUG_NOOP;
+}
+
 /*
  * Object debugging
  */
@@ -1898,6 +1911,9 @@ parse_slub_debug_flags(const char *str, slab_flags_t *flags, const char **slabs,
 		case 't':
 			*flags |= SLAB_TRACE;
 			break;
+		case 'n':
+			*flags |= SLAB_DEBUG_NOOP;
+			break;
 		case 'a':
 			*flags |= SLAB_FAILSLAB;
 			break;
@@ -1961,6 +1977,7 @@ static int __init setup_slub_debug(const char *str, const struct kernel_param *k
 			global_slub_debug_changed = true;
 		} else {
 			slab_list_specified = true;
+			slab_debug_per_cache_union |= flags;
 			if (flags & SLAB_STORE_USER)
 				stack_depot_request_early_init();
 		}
@@ -2069,6 +2086,8 @@ static inline void setup_object_debug(struct kmem_cache *s, void *object) {}
 static inline
 void setup_slab_debug(struct kmem_cache *s, struct slab *slab, void *addr) {}
 
+static inline bool __init slab_want_nohash_pointers(void) { return false; }
+
 static inline bool alloc_debug_processing(struct kmem_cache *s,
 	struct slab *slab, void *object, int orig_size) { return true; }
 
@@ -8755,7 +8774,7 @@ void __init kmem_cache_init(void)
 		slab_min_order = slab_max_order;
 
 	/* Inform pointer hashing choice about slub debugging state. */
-	hash_pointers_finalize(__slub_debug_enabled());
+	hash_pointers_finalize(slab_want_nohash_pointers());
 
 	kmem_cache_node = &boot_kmem_cache_node;
 	kmem_cache = &boot_kmem_cache;
@@ -9777,9 +9796,8 @@ static char *create_unique_id(struct kmem_cache *s)
 	/*
 	 * First flags affecting slabcache operations. We will only
 	 * get here for aliasable slabs so we do not need to support
-	 * too many flags. The flags here must cover all flags that
-	 * are matched during merging to guarantee that the id is
-	 * unique.
+	 * too many flags. The flags here must cover all flags from
+	 * SLAB_MERGE_SAME to guarantee that the id is unique.
 	 */
 	if (s->flags & SLAB_CACHE_DMA)
 		*p++ = 'd';
@@ -9787,10 +9805,10 @@ static char *create_unique_id(struct kmem_cache *s)
 		*p++ = 'D';
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		*p++ = 'a';
-	if (s->flags & SLAB_CONSISTENCY_CHECKS)
-		*p++ = 'F';
 	if (s->flags & SLAB_ACCOUNT)
 		*p++ = 'A';
+	if (s->flags & SLAB_DEBUG_NOOP)
+		*p++ = 'N';
 	if (p != name + 1)
 		*p++ = '-';
 	p += snprintf(p, ID_STR_LENGTH - (p - name), "%07u", s->size);

-- 
2.56.0



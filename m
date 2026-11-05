Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5789D606A333
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8NkHEK9
Received: by kanga.kvack.org (Postfix)
	id 71B286B05B5; Thu,  5 Nov 2026 03:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3396B05B6; Thu,  5 Nov 2026 03:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608826B05B7; Thu,  5 Nov 2026 03:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7606B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF00512048D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:12 +0000 (UTC)
X-FDA: 85400428344.09.C08A169
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1EA58120005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8NkHEK9;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iu5/0CAAr9pJxXMAISy8ciswj9EjhTb+ydO2NNeMnUk=;
	b=NndNjuJVielGRJrmE2JigexUW4ewo2Aij4792d30W+soOBbwZ78dJ5AJIo72w6XoG7+o1T
	FLFEQ1HNMUYp+UfstqjTo18DPWAWcOOCoI9kSYFkTx36mo9mUH81SZVAYGJOvhtbx5TRsV
	tkzqbtjwfS0xKLSu54+lSdtDl2Eq3iQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8NkHEK9;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868251;
	b=5Ow5EEpLAN3GQItTAKCmAvgYzhhIH96JJw2A3EiHbGZw//DyPfvSq5mVV1YWhuc3EyjQrs
	w5zoX5Fj8FBuGQxyo2DUaJ/nSw7W5qPeFjrwWN05lqRQ/C7Ufyp4qhD+kvyt3c/09eTSjL
	02rNh0JqlbbWEXf+pL4OVcr4g1gBWdQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D4B3404FA;
	Thu,  5 Nov 2026 08:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4BC1F000C1;
	Thu,  5 Nov 2026 08:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868250;
	bh=iu5/0CAAr9pJxXMAISy8ciswj9EjhTb+ydO2NNeMnUk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=J8NkHEK9iTuXRjMKFYOhhkSFbTFDWaiVXotj2Vg+7HJ50gV7IOrq0ejMqx0ZLoNo2
	 HOQf4oK4MigaUkAWernnrw3kZygxHgQGIOg4wniV+mvFICOlMsw35BkYaNBw/KRBAW
	 s7UGrRQOeOgYwoytt/Usiqup92jOp40YN5SkKdEKrR4pSdu81Sl9Uin4hEt7NxLh5S
	 hJLeMcc/OA/yqxsCFQ5rmlR+4K9VYKLKEzDf8CN9jTFvDSSW20jW/DT4OnERT7f44+
	 8OqOLOEC5/yZoEWPl8l0RkAicCgc0w8jUSSFJ9VxB4pK2Lj3rSBSqQbQlHMAwtSDey
	 pvuYJj7DgdFgQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:53 +0100
Subject: [PATCH v3 04/10] mm, slab: introduce slab_debug=N
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-4-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
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
X-Stat-Signature: wmwy446crrai3syust5r3q11yweqet3z
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1EA58120005
X-HE-Tag: 1793868250-302082
X-HE-Meta: U2FsdGVkX1+Vc5CakFa/2KIb5oRE4J1qijwf3hTGjE6H4wQRHn9INk00ueeCC1MtiQHjuOkV4Erg0mHZkNw8AmqJifSODJYanCzXjsVqgJRvjN+g9RdbWZwTCI6j+9mBFNl7W9ULQvf71Q7d8ZFkeV2WB7EhFwfcmQruLZjH8j2ixY3jzlk7XRsabUntMvzI3MHx7tKWpV/IxkfPiRTDmwmVQw6Jpx9LJE+Ms4a7VzFrSlTsXj5zkE2jYNWKpUzAWtmdQZFyJpoA+gUEvHf3lu7ZV3ZanCkR5Ej2DxttIigVZWaxbhRoCRBBqMXMoqw6zYHryvI/vjaTrXgE5H10u6wdbYqDxo6FL0dngPMatIIWQfTkajzB3EYJD5Jzu8KtvKLnMSFoLdDX8lFiLO4dG7Ef14ojhIfbb900a9sMA+Yhs1v7YLxOuR+a4h8KshragEII99ryoQ+CJeu224+Qu/M992GWGiQToHRyT1McZ1AhggEHfo/ixN4W89tJ9H0oioSOQPVJoWu5BQhJJy5Ab5XLD1VfrB/DYYfnutnG6W3F9WcGIBvryuimBK5sTc4ZJLhwmzaEmsqGO8QQiqPaZ/iEd5vY+GWG0/03aeB/GfPY6e3kRvV0e4rKpv+XBPYNoyXFisBTZIgzF2NxlJngUIu63lQkoEdFnBMkmxNrT9lBGsv0g+Hp7znw+fJcAA6cAVb14pcaGzSKX/pR8kp0ekfaZo20eiYxYFqz5Wwd15QK0pY1hm9eiC/LhuYDTnaPKW9WhYw6o6fvEJvji8NuPRQBwv0mMzk1LwkOX2/0i7aRko0uTQFmjQorokhXtUJ6ZkuixXz+ssZoUbhf8JQ9js+pbgNS6ueNmXmOssqZTtHrBhjwmWqa+TI1+qOYxl9GGBzDNjfMttZjO2G7GHo5qkeXamuxBVDFdLW+2tV6O0Q7OJKoomnETfjeUHHj/or1BmmTp2xHOu1ctbKdaHJ
 IB0mzohL
 +fkquqHY2GdSL71adnAAm4D/mlJuSl7zZwonMrVJddaUDhlbS8kBSv9QzoC6B8a9FEAVhvYfZRXT8vsDIg9tpNgTgXkVObRQQTaRPqFO3LWGr0tEeBgMQozqTwY7qRUEO0qzHFOM1X7hTJT2DEqzcHF/Nc5d3gPd3F9foIv+nXReS4XX2hRp5F8dSSalIo3qKu5+EuZE5eWbfk0deQZ6cZBPM+X0mp0rLsiXjp5bILjNc4zW+Kv2K5WTHTMTjWSvmn3Q9gyVj/7/R4o/fslI+ggsmQDHkmzlTBIik3AtwWZ6FqdLUGVv/rt1TZoSpa7I2qaNhTEKxBNpmTnUyjMNwrk69K9tuih+/hN3QMRHvNfkiXbZmIBW3+x8QYMLQA2RL9iC3RmIEusX0B9cwfACD+jQjpKtxiGbmpW1tibIOfareptI=
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

  - However add the flag to SLAB_MERGE_SAME, per sashiko.

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

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/admin-guide/mm/slab.rst | 13 +++++++++++--
 include/linux/slab.h                  |  5 ++++-
 mm/slab.h                             |  2 +-
 mm/slab_common.c                      |  9 +++++----
 mm/slub.c                             | 21 ++++++++++++++++++++-
 5 files changed, 41 insertions(+), 9 deletions(-)

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
index 01c64ef661e7..6036ce1ac333 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -47,12 +47,13 @@ struct kmem_cache *kmem_cache;
  * Any flag that adds per-object metadata should be included,
  * since slab merging can update s->inuse that affects the metadata layout.
  */
-#define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
-		SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE | \
-		SLAB_OBJ_EXT_IN_OBJ)
+#define SLAB_NEVER_MERGE ((SLAB_DEBUG_FLAGS & ~SLAB_DEBUG_NOOP) | \
+		SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | SLAB_FAILSLAB | \
+		SLAB_NO_MERGE | SLAB_OBJ_EXT_IN_OBJ)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
-			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
+			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT | \
+			 SLAB_DEBUG_NOOP)
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
diff --git a/mm/slub.c b/mm/slub.c
index 30714557306d..51daf361c601 100644
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

-- 
2.56.0



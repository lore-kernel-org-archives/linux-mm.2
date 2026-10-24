Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC58606A331
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RE4Lm+CA
Received: by kanga.kvack.org (Postfix)
	id 5B7F46B05B2; Sat, 24 Oct 2026 15:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590186B05B3; Sat, 24 Oct 2026 15:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDA46B05B4; Sat, 24 Oct 2026 15:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8F96B05B2
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C1021A0436
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:43 +0000 (UTC)
X-FDA: 85358454006.29.02A0BFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E22C240002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RE4Lm+CA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26zIWuZggzXFxjqRM6LN+qqHl4Ps2joqd/Wn4uHgStQ=;
	b=04RbSSPogrmLamTYOt6qkhc97iprwTjDUN/F+CLZ1i1rubS6ZQorNbA2iETIGRCqG4k7mj
	C0hhnBvZ0xFaxaRo0DX0LHv44/0okcmlha2FNSRxGuFzg3SYWNb6pKtoDOpxBB0UDHWO3h
	TF/sKFIrLhYSJhl0K5+MANJ95/csm60=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RE4Lm+CA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868862;
	b=Zf+e0OJsAZuNXf2SObqoMSYdITC7KsTbiVMPNaKGaKoSKNGO6M2wucYpE4WminqYJxKdHi
	dohwIxMA9fQzygNckEwivdiXIerJt08bOieg89ZwcMj/obVpEcWAHh2eCPe95NW1QloxeQ
	m4BOaMSJHhXy6F1frWi/dmeiI6LqjY0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36F0F44047;
	Sat, 24 Oct 2026 19:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F063B1F031E2;
	Sat, 24 Oct 2026 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868861;
	bh=26zIWuZggzXFxjqRM6LN+qqHl4Ps2joqd/Wn4uHgStQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RE4Lm+CAA+W0sM/Gyh9Zgkeh8XLjZkPxdq76b31QshuIhrOHWvqC4dQcvVQ+feZkN
	 0TXdnhWR1rNTuF14rUvXW6UMwOv8FBYPOXVedvIG2oLexmEj+LdeCK8iXnl5Rb6TV/
	 u5afTXnZehtfeAcDhkXeQTkD0YDoc2B467vjmkXfFnqpzPNZ1ZqwvPF/9srAas6nTh
	 BrKREQLBSJOt7XO/5EWzXTKO4bfjApxrJ9tCDB7SWdsUvm6jLgCtrPaa7oLjofYhJR
	 4VTVRu/zxAIYR8VM0b2EyxqtR5AkAwkikGqD1bqeKTIM+SvssVa2OkcK4Vy2SsCQr+
	 GlldKWlyUB20w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sat, 24 Oct 2026 21:07:24 +0200
Subject: [PATCH RFC v2 2/8] mm, slab: introduce slab_debug=N
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-slub_tiny_rework-v2-2-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
In-Reply-To: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: E22C240002
X-Stat-Signature: 5t4f8ro5cdqufe4heuanbtjnddyakg7m
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792868861-160710
X-HE-Meta: U2FsdGVkX1/GWuF3pbD40MXrv1XoDFoe3GSgCmpGR1hpS9QZtOxkXDqSzWqwwaMB78Ly4TUW4M5JsDgLRAj3ghm8i3WuZGCipLzuEgmQ9RsdFI4SP35IHGF+UJdyXag2Q7HfoNCs18i0lPiyZBVaVA2iTPp2bJjRdW/JLT3XIS44X3blMyjQfVMbTSNiYHKxpokdRxs+ocORe3WtFfthNQs6PX/f6HXsHME4Cd7zpQgHEyvznJL7clkmCEmq5hNE48d1m71mgZKAg1+C2Lrsje/KW4oBU2fG3H/mlI6BmbBK1tTqdIfSf7p++GcrtwItdjdxd07n2ElqhyqYfnfAp6beh4hmZP6MJWhFa8DMi0W/TPN63ir2yv4zc1lxAnibuYCmdqSrK9jZviFf/N+nAQedgBNSunXE5N2Cl7/8dDw1w8pcWywR89EzGgyl18ohZ/AO5XIcSDytGs/wb5jDv4BBCOFy1h209fkKiSqskp0e5uMZi5n+dlRUQT3X4SVy66JMMVwcylYnbzc4m3/sZAYGYafzI3hd3QUaZpABmD+brmp9zEV3y7oddWtmzMabnferMMiC2X2RByE1XMB8owGF2rtsWVS6ZPy6QDg356q9Cv4/NJc+utyuaR5e1jIOLdpegvL5/HiM8hYRJ8XYhk2Th236H0SCj9temxr888/qx6g9tM44F1lDfOZURoebkMirmh8vS4oKZ2ET0mU0FwJaBnbfRKFJIIvoMmWopAn5GzHsiKRS0l8SmJA6aJW1Qt+VS96iHQLQ4LUsK2Rju14BQefZRn0LCSLBKGIZRs9F0KfSCM8/23UO7mvkgCzYSFKvG+gHWREBnk0ZhNQYsx0SyAYV+xx4Kago4kx7AxEFNjvDTxibOMzQdeoz3+e4f7tSGt2/n6k0wdXNl9h5GLBfnMx27R3OTChfjkS2V2xwCuR12aqyVGzBVybAlcvrUNkdJBSUvgvRCOGTIN1
 tEyNffMq
 s9hxGQbaXNslc4TnpgW0wxOzAG0J79Xxn+C5fuqq0FShlnq+UOIE5x6OIqaw36escmyH+jpSCPcfn1nRaQfccZUiQUmnmeJzLscTgZWq3cngeIaF0DaP1/50110QojbgLCs9mKrnZ4sjULfTiCP7JYcwk7+ddIE1qOyRwN1qGoxpPSxjYh/ludztskrkccAq5PjSfPx3MnUPyju4mZvNeTU6hcL9ohRCi/eHgUPnX8KjVBNwzmPUHiae29D7h2xt+ExSF8qvDA4RfISqqmHIaS6zShjGQFHbTauvl
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

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/admin-guide/mm/slab.rst | 13 +++++++++++--
 include/linux/slab.h                  |  5 ++++-
 mm/slab.h                             |  2 +-
 mm/slab_common.c                      |  6 +++---
 mm/slub.c                             | 21 ++++++++++++++++++++-
 5 files changed, 39 insertions(+), 8 deletions(-)

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
index 01c64ef661e7..02dfe4351e8b 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -47,9 +47,9 @@ struct kmem_cache *kmem_cache;
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
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
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



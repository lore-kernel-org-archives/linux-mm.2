Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EDFCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB992900227; Fri, 15 Aug 2025 05:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91B78E0002; Fri, 15 Aug 2025 05:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9324C900227; Fri, 15 Aug 2025 05:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E92D8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:00:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58DCE1DE0AF
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:24 +0000 (UTC)
X-FDA: 83778395568.26.B430C80
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B01510000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248422; a=rsa-sha256;
	cv=none;
	b=gSrGdVOcZ/8sGKK6ApnnUSph/1HrCre+sdNbRd6kznE00i07O7bqChoTPM8bUHIlGvRR7i
	MK/K8upMEo59tCgNI+ZXOFaWDvOnAAbhA7WAkcMQiqcwWBm8NhMeeAwv7tg28NTkTo3R47
	3MhMc0fyg4xpFkp1o90lDiMb/DV4ZMc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N5QqvjacsNKoU/KDbuUz8UEJxJrhWXz1PmvASZ6OQA0=;
	b=fTXdQBTaD0poQN2QqJ2mi5DTnMXp+AjswkeieoykLbJKMj4urP9uYd99Qs9TPqdY3215fq
	PD4cHZEJP0EhHVAyBRnJhqQlStXYjNOkS17Z/eonTD8SdRpN53qoITvNQEygCnYx+oa0nz
	nRQ0gK30MruE1kyZYn5jhiv12t7r0G8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6A322C40;
	Fri, 15 Aug 2025 02:00:13 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A9B43F63F;
	Fri, 15 Aug 2025 02:00:17 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v2 3/8] slab: Introduce SLAB_SET_PKEY
Date: Fri, 15 Aug 2025 09:59:55 +0100
Message-ID: <20250815090000.2182450-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815090000.2182450-1-kevin.brodsky@arm.com>
References: <20250815090000.2182450-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B01510000D
X-Stat-Signature: egdenut9fqt9wnrm4yi68qbdy4sau69b
X-Rspam-User: 
X-HE-Tag: 1755248422-485882
X-HE-Meta: U2FsdGVkX18DGdYyknmYzbTXK7JDk4IRaIQy/HtvW2L7m17Tm+2pNqbdZTyH1Lh72sI86e5gtlKqNGiJzzBTCv6SOciRk6O3Qe3W1TdvhG1AKHm7W/OjMsfa9yu1wHkeDKE8qy7bXKQ+wk/udKVpCFxmQSYAPVT7BMD92cDvlkJhn+xG+4UZBkwohe0eogG5gSDmvhBdFNkXDzlJjca+uFIch2ewBFB2wSYNqM8dY/xdQxTytw+OabQpZuN/eUbbRxeYBIozwz1KZclJtJslBY2BR4kN6qdG5VqRN4U0byXfl9/l8ErDJwJ6TrMbzrBiv0fx3WzPVBY2mumJQ3oA2WnZn/74d8t865knyKH/qCFcKal/0h6MwrMDJ2+dRqGgmk/wYWE/aEXmCyYdtFHqku904VDPOPuRlQ4A3g+VCePSLtVXJNtJyj1tIrCfGbjmpMqq7d2fKqaz/SaFDuDy10hDNRFCZfkOAkuGYB2ZBHNQb3xfR+zgXcAwfEBTTjMAxmFRUBoAX5cYOei3RtMTwnINPqtQ60fposEOjUTncUD3nBenGscvFHJTnLczAMhg5uMefD4lIfDQHe20M6ylKtsqADAtqrLgj8yplEn2MsHE/NSBnJiAycKKUXy0+rwpVN1/4DudiVqaKTuDgvLt2UTQYZtLptwkMYayCBFLyMnxGU0ZF4RzqbYQtPnw9XGry3X1uebMae4a6iV+F+0oka6CFM1LPvnn3MLVihWYKfyrGK6FTWUPUDhfgode3MWBMMOfHjb8nEf14B8/rGek//dYoh0vFxY1iljfW9zyU0XUiZ5gInlQ545OPg28HEgNlKLm47jCuHvGRTiHxPkYGtAoszdwj+zlnZKsBwQwRiwSfhoeG/zkBRVhH71l0TuAP/V4OYZTvx6NZej7b9/dWOanD1HOPhgI3QsP8tBDEUYQodY+1jnKYHZdOFSAF0KLm8+xMDsJgeReLuUwNE/
 ZxgdeGc6
 QIzo86vay5Y7D/1DClwNbIFMCv9+ee8BlSX32g/wOQMGo9bn6HeSBJoN/Kar47f4SfIQqLKVDvOLl/eeMikKg3RekazHg7HGcz5JHV8+3L5LaIlgQg7zfUwVdoD+Sax/E0Qm03SnSGBZYw3ULQb46u7c6Nk/3Z9Sq85kOaEzugZNDmL59S4jD5Rq5hmf0SdJYR/R94m0A+Rc7H6XLGUtz77sBmcabP1RhtixJHogl5+aZziw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the SLAB_SET_PKEY flag to request a kmem_cache whose slabs
are mapped with a non-default pkey, if kernel pkeys (kpkeys) are
supported. The pkey to be used is specified via a new pkey field in
struct kmem_cache_args.

The setting/resetting of the pkey is done directly at the slab level
(allocate_slab/__free_slab) to avoid having to propagate the pkey
value down to the page level.

Memory mapped with a non-default pkey cannot be written to at the
default kpkeys level. This is handled by switching to the
unrestricted kpkeys level (granting write access to all pkeys) when
writing to a slab with SLAB_SET_PKEY.

The merging of slabs with SLAB_SET_PKEY is conservatively prevented,
though it should be possible to merge slabs with the same configured
pkey.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/slab.h | 21 ++++++++++++++++
 mm/slab.h            |  7 +++++-
 mm/slab_common.c     |  2 +-
 mm/slub.c            | 58 +++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index d5a8ab98035c..8cf8f655e794 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -59,6 +59,9 @@ enum _slab_flag_bits {
 	_SLAB_CMPXCHG_DOUBLE,
 #ifdef CONFIG_SLAB_OBJ_EXT
 	_SLAB_NO_OBJ_EXT,
+#endif
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+	_SLAB_SET_PKEY,
 #endif
 	_SLAB_FLAGS_LAST_BIT
 };
@@ -244,6 +247,12 @@ enum _slab_flag_bits {
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
 #endif
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+#define SLAB_SET_PKEY		__SLAB_FLAG_BIT(_SLAB_SET_PKEY)
+#else
+#define SLAB_SET_PKEY		__SLAB_FLAG_UNUSED
+#endif
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
@@ -335,6 +344,18 @@ struct kmem_cache_args {
 	 * %NULL means no constructor.
 	 */
 	void (*ctor)(void *);
+	/**
+	 * @pkey: The pkey to map the allocated pages with.
+	 *
+	 * If the SLAB flags include SLAB_SET_PKEY, and if kernel pkeys are
+	 * supported, objects are allocated in pages mapped with the protection
+	 * key specified by @pkey. Otherwise, this field is ignored.
+	 *
+	 * Note that if @pkey is a non-default pkey, some overhead is incurred
+	 * when internal slab functions switch the pkey register to write to the
+	 * slab (e.g. setting a free pointer).
+	 */
+	int pkey;
 };
 
 struct kmem_cache *__kmem_cache_create_args(const char *name,
diff --git a/mm/slab.h b/mm/slab.h
index 248b34c839b7..01c404f2f1db 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -287,6 +287,10 @@ struct kmem_cache {
 	unsigned int usersize;		/* Usercopy region size */
 #endif
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+	int pkey;
+#endif
+
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
@@ -438,7 +442,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
 			 SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			 SLAB_TEMPORARY | SLAB_ACCOUNT | \
-			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
+			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE | \
+			 SLAB_SET_PKEY)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
diff --git a/mm/slab_common.c b/mm/slab_common.c
index bfe7c40eeee1..7b26062629a1 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -47,7 +47,7 @@ struct kmem_cache *kmem_cache;
  */
 #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB | SLAB_NO_MERGE)
+		SLAB_FAILSLAB | SLAB_NO_MERGE | SLAB_SET_PKEY)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..f6aec6ed7135 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -44,6 +44,7 @@
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
 #include <linux/sort.h>
+#include <linux/set_memory.h>
 
 #include <linux/debugfs.h>
 #include <trace/events/kmem.h>
@@ -477,6 +478,15 @@ static nodemask_t slab_nodes;
 static struct workqueue_struct *flushwq;
 #endif
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+KPKEYS_GUARD_COND(kpkeys_slab_write,
+		    KPKEYS_LVL_UNRESTRICTED,
+		    unlikely(s->flags & SLAB_SET_PKEY),
+		    struct kmem_cache *s)
+#else
+KPKEYS_GUARD_NOOP(kpkeys_slab_write, struct kmem_cache *s)
+#endif
+
 /********************************************************************
  * 			Core slab cache functions
  *******************************************************************/
@@ -563,6 +573,8 @@ static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 	BUG_ON(object == fp); /* naive detection of double free or corruption */
 #endif
 
+	guard(kpkeys_slab_write)(s);
+
 	freeptr_addr = (unsigned long)kasan_reset_tag((void *)freeptr_addr);
 	*(freeptr_t *)freeptr_addr = freelist_ptr_encode(s, fp, freeptr_addr);
 }
@@ -802,6 +814,8 @@ static inline void set_orig_size(struct kmem_cache *s,
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
 
+	guard(kpkeys_slab_write)(s);
+
 	*(unsigned int *)p = orig_size;
 }
 
@@ -986,6 +1000,8 @@ static void set_track_update(struct kmem_cache *s, void *object,
 {
 	struct track *p = get_track(s, object, alloc);
 
+	guard(kpkeys_slab_write)(s);
+
 #ifdef CONFIG_STACKDEPOT
 	p->handle = handle;
 #endif
@@ -1010,6 +1026,8 @@ static void init_tracking(struct kmem_cache *s, void *object)
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
+	guard(kpkeys_slab_write)(s);
+
 	p = get_track(s, object, TRACK_ALLOC);
 	memset(p, 0, 2*sizeof(struct track));
 }
@@ -1191,6 +1209,8 @@ static void init_object(struct kmem_cache *s, void *object, u8 val)
 	u8 *p = kasan_reset_tag(object);
 	unsigned int poison_size = s->object_size;
 
+	guard(kpkeys_slab_write)(s);
+
 	if (s->flags & SLAB_RED_ZONE) {
 		/*
 		 * Here and below, avoid overwriting the KMSAN shadow. Keeping
@@ -2399,6 +2419,8 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 		int rsize;
 		unsigned int inuse, orig_size;
 
+		guard(kpkeys_slab_write)(s);
+
 		inuse = get_info_end(s);
 		orig_size = get_orig_size(s, x);
 		if (!kasan_has_integrated_init())
@@ -2631,6 +2653,8 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
 			    -(PAGE_SIZE << order));
 }
 
+static void __free_slab(struct kmem_cache *s, struct slab *slab);
+
 static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct slab *slab;
@@ -2681,6 +2705,18 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 	setup_slab_debug(s, slab, start);
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+	if (unlikely(s->flags & SLAB_SET_PKEY)) {
+		int ret = set_memory_pkey((unsigned long)start,
+					  1 << oo_order(oo), s->pkey);
+
+		if (WARN_ON(ret)) {
+			__free_slab(s, slab);
+			return NULL;
+		}
+	}
+#endif
+
 	shuffle = shuffle_freelist(s, slab);
 
 	if (!shuffle) {
@@ -2721,6 +2757,11 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
 	__folio_clear_slab(folio);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+	if (unlikely(s->flags & SLAB_SET_PKEY))
+		WARN_ON(set_memory_pkey((unsigned long)folio_address(folio),
+					pages, 0));
+#endif
 	free_frozen_pages(&folio->page, order);
 }
 
@@ -4118,9 +4159,11 @@ static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
 						   void *obj)
 {
 	if (unlikely(slab_want_init_on_free(s)) && obj &&
-	    !freeptr_outside_object(s))
+	    !freeptr_outside_object(s)) {
+		guard(kpkeys_slab_write)(s);
 		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
 			0, sizeof(void *));
+	}
 }
 
 static __fastpath_inline
@@ -4920,6 +4963,7 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 	/* Zero out spare memory. */
 	if (want_init_on_alloc(flags)) {
 		kasan_disable_current();
+		guard(kpkeys_slab_write)(s);
 		if (orig_size && orig_size < new_size)
 			memset(kasan_reset_tag(p) + orig_size, 0, new_size - orig_size);
 		else
@@ -4929,6 +4973,7 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 
 	/* Setup kmalloc redzone when needed */
 	if (s && slub_debug_orig_size(s)) {
+		guard(kpkeys_slab_write)(s);
 		set_orig_size(s, (void *)p, new_size);
 		if (s->flags & SLAB_RED_ZONE && new_size < ks)
 			memset_no_sanitize_memory(kasan_reset_tag(p) + new_size,
@@ -6410,6 +6455,17 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	s->useroffset = args->useroffset;
 	s->usersize = args->usersize;
 #endif
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+	s->pkey = args->pkey;
+
+	if (s->flags & SLAB_SET_PKEY) {
+		if (s->pkey >= arch_max_pkey())
+			goto out;
+
+		if (!arch_kpkeys_enabled() || s->pkey == KPKEYS_PKEY_DEFAULT)
+			s->flags &= ~SLAB_SET_PKEY;
+	}
+#endif
 
 	if (!calculate_sizes(args, s))
 		goto out;
-- 
2.47.0



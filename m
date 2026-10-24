Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE88606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nucx+XVY
Received: by kanga.kvack.org (Postfix)
	id E6B266B05B5; Sat, 24 Oct 2026 15:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43866B05B6; Sat, 24 Oct 2026 15:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F606B05B7; Sat, 24 Oct 2026 15:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9A0C6B05B5
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E077403B1
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:51 +0000 (UTC)
X-FDA: 85358454342.23.501A363
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 937C940005
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nucx+XVY;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsjt9E/SOoMFBDvFXKXQOgR8qFXU1RBSyugeCKhoESM=;
	b=iZ+fgtPfenq7z6BzOWYsGQ9nZhd9Sox4WkFNGJmZ4a7bQc61zOt/oSec/IiBJ+eDexfGxr
	OoHXQlL0gF+BC3nNCNnL4q4YQRT6H2d3sXlEnooC7rI1Di/Wfex46HDtgwB0b7zL4zjI30
	nDRfo+o0ti7BigUn+VBd1APdg+1X/Lk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nucx+XVY;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868869;
	b=F6eP0Oitlc+pmpKIC5TggKbNwyOF7mwaI9KkGI1n8WTVye0EU7BpUwP0SAbwtIiqHXIjNf
	IAqqB8GXgR9h2/813/p4GA29xyEB7CW/mSlN4nZbuhAaXQIiQwNzFaLRPVhwl+NtKJInqQ
	HDZoYCSEAVc/9Nc3Xg7DcM+zcjbVQ8Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AA0F6022B;
	Sat, 24 Oct 2026 19:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62ED1F031E0;
	Sat, 24 Oct 2026 19:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868868;
	bh=tsjt9E/SOoMFBDvFXKXQOgR8qFXU1RBSyugeCKhoESM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Nucx+XVYwwVGg4eFZl1aC9NIMOgjyNaPQuHlO6eke6iYmUq9BZBX/xuWu5caPvA4l
	 +p3rsn5fb8X9mpDFTSr1IAeCsh96BMCU5W7MxD4EVXSA8utmcRtUKaIkCx8UaxsU4F
	 9Tn17iLD7ivEjiFcV4JOF+7pdDig0WQ1hzxkcCzHndDaOjgHK2plIJ5pyHUTPFOLw/
	 X/1Hod65+UxoSDdJfvsdxvxhQg0ENvHJEwNuGUq3VdQ5rBWZrZeVHrvqhOvAr4Qfwe
	 HuWbQPvmBFmTJ9Q8XZh9iFxaKW+TOVERDv+qZl+SupDBhX+NwsXr5SvZAltP83GHS4
	 d4yAMmGOUsgyw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sat, 24 Oct 2026 21:07:27 +0200
Subject: [PATCH RFC v2 5/8] mm, slab: convert CONFIG_SLUB_TINY checks to
 kmem_cache_debug()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-slub_tiny_rework-v2-5-bf1419ab5ffd@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 937C940005
X-Stat-Signature: s789ykbfw6h74hobf1ac8mi1xmjyk9f1
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792868869-318099
X-HE-Meta: U2FsdGVkX1/68TJqsgs9iL0SUJqsCEEtkrD+nsTGeWPu7gOEg4Rqk2vmMJFZMdFFT9V345yB1FGrepEgqV8ybhP6S2Ns9pKHUJfYqvylvVVjSFake9V22vyPYd2WR4Bf9mZj9RCIYbrwOyJUAyg3Ln1ezMsXMYGTxTmD5CZiBvLnqJJ4Yx++7lw3rGB6Q4npcHg/AgRjiqHRUmAKtFh/uCnsOD62Aa6mReh9LCQAWeJcBnVb3doZAIOnRwM7HTmIsfFlWdoUAOF+Bl+gcE6bQ93ik4fw0TnLuh/9E5swRXrMrX+Y2lOqdxTh+mI2iwdqvojeFLfQmJOl9FnqMHwGlRm+hgiK5mdOryyjCYli23i2xao13AwF6nHyIOxu5dkSFxyExt0vpl4bPx4LePRLBUzEyPhdz9OKOVGllRJlgFyOgnvW5JZcoLnZWGiPYdewwi1cifbf4ttgzacsrE/QO6FJoa8Vae3Qx3/JfhqXviwE56dOKsym9rLXhrBgNXt7Czpk8pgqH1iX+W7cbWJ6N5+hTd6TSPIRdqRn/vRYGVp/wwkxOtGJUzbuOwVBgLVzZjk930ClTB0MLN5hzSLoP+TlWlqwIb0BxSIPu/kaiIGKwNknf0s89CfMVLYuiPF80xXOGi1H+Tg0LMqn3VF1Boo9365wy1MLAVOCeZgNKs25J/yxxs7QNHkhb4uyW1WHJdbVVAvaNKHXADU5MNzzysCX5BXrr9usu8w9hG8U1pao6P/9UPLeStKFYFGsXDsrIuujK92HH47qSuG+FocSX2uc5ZhqJA5EUIbLuiZTcuQuwLZt8lli265sS2n8+eZQPWnMI7jWuARbGH0aU7/cn78dlOR6nkCw+stOVUzjt4C4rhNfSAyEyEAfmi3UKAZ9JaKpdMVm7ObixILQoZ7xEDgokHBxi17r9tSlMPxkahsCyZnh1+RpCKq7mrN9ilGtUafkQUtW+278qfWCeFa
 1FDvqqM8
 fKz58/ONUYpc3A6NOzVgBjtnockIMKhDz71AsoVAG6uOrDHrYElaJegrU4IbMYavDjditCCBIC6WoZXCWt+bPvSj2Wp7EcPZi7T/jUbh+qHQdKuSxpQgLvMVN2UprYyCveQodx44T5ltbaxE9EOwzkAisV56Oq/D9+L6o+dWyOGKL011RYuRk4GeEjyKDYv5j2zrH4z/2foK2T5s6CZN0IfgIKoDak5Z+O0ZjpowFimg89vrJlKk25emTD3fKC8vFhlMIJJ4Bn3lUDNTtHF4oqkEAivhhJNEgA6Qw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_SLUB_TINY shares several slowpaths with debugging as both of them
avoid percpu caching of objects. With the goal of replacing the config
with a boot-time decision, extend this sharing by hooking
slab_tiny_enabled into kmem_cache_debug() check itself.

This is made possible by the new SLAB_DEBUG_NOOP debug flag. Make
slub_debug_enabled static key always available (not just with
CONFIG_SLUB_DEBUG enabled) and have slab_tiny_enabled add
SLAB_DEBUG_NOOP to all caches in kmem_cache_flags(). Do this also in the
CONFIG_SLUB_DEBUG variant, which is currently exclusive with
CONFIG_SLUB_TINY, but that will be lifted later.

Remove the various IS_ENABLED(CONFIG_SLUB_TINY) checks that
complement kmem_cache_debug() checks as they are no longer necessary.

While removing/adjusting the CONFIG_SLUB_DEBUG #ifdefs, also convert
CONFIG_SLUB_DEBUG_ON to *_STATIC_KEY_MAYBE().

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 18 ++++++------------
 mm/slub.c | 38 ++++++++++++++++++--------------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 835d977634ec..7ea057fda751 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -506,26 +506,20 @@ struct slabinfo {
 
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo);
 
-#ifdef CONFIG_SLUB_DEBUG
-#ifdef CONFIG_SLUB_DEBUG_ON
-DECLARE_STATIC_KEY_TRUE(slub_debug_enabled);
-#else
-DECLARE_STATIC_KEY_FALSE(slub_debug_enabled);
-#endif
-extern void print_tracking(struct kmem_cache *s, void *object);
-long validate_slab_cache(struct kmem_cache *s);
+DECLARE_STATIC_KEY_MAYBE(CONFIG_SLUB_DEBUG_ON, slub_debug_enabled);
+
 static inline bool __slub_debug_enabled(void)
 {
 	return static_branch_unlikely(&slub_debug_enabled);
 }
+
+#ifdef CONFIG_SLUB_DEBUG
+extern void print_tracking(struct kmem_cache *s, void *object);
+long validate_slab_cache(struct kmem_cache *s);
 #else
 static inline void print_tracking(struct kmem_cache *s, void *object)
 {
 }
-static inline bool __slub_debug_enabled(void)
-{
-	return false;
-}
 #endif
 
 /*
diff --git a/mm/slub.c b/mm/slub.c
index be4e1f193295..1b7626645068 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -202,13 +202,7 @@ enum slab_flags {
 #define __fastpath_inline
 #endif
 
-#ifdef CONFIG_SLUB_DEBUG
-#ifdef CONFIG_SLUB_DEBUG_ON
-DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
-#else
-DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
-#endif
-#endif		/* CONFIG_SLUB_DEBUG */
+DEFINE_STATIC_KEY_MAYBE(CONFIG_SLUB_DEBUG_ON, slub_debug_enabled);
 
 #ifdef CONFIG_NUMA
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
@@ -1041,11 +1035,7 @@ static inline void *restore_red_left(struct kmem_cache *s, void *p)
 /*
  * Debug settings:
  */
-#if defined(CONFIG_SLUB_DEBUG_ON)
-static slab_flags_t slub_debug = DEBUG_DEFAULT_FLAGS;
-#else
-static slab_flags_t slub_debug;
-#endif
+static slab_flags_t slub_debug = IS_ENABLED(CONFIG_SLUB_DEBUG_ON) ? DEBUG_DEFAULT_FLAGS : 0;
 
 static const char *slub_debug_string __ro_after_init;
 static int disable_higher_order_debug;
@@ -2032,6 +2022,9 @@ slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 	slab_flags_t block_flags;
 	slab_flags_t slub_debug_local = slub_debug;
 
+	if (slab_tiny_enabled)
+		flags |= SLAB_DEBUG_NOOP;
+
 	if (flags & SLAB_NO_USER_FLAGS)
 		return flags;
 
@@ -2104,6 +2097,9 @@ static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct slab *slab) {}
 slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 {
+	if (slab_tiny_enabled)
+		flags |= SLAB_DEBUG_NOOP;
+
 	return flags;
 }
 #define slub_debug 0
@@ -3964,7 +3960,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 		if (!pfmemalloc_match(slab, gfp_flags))
 			continue;
 
-		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+		if (kmem_cache_debug(s)) {
 			object = alloc_single_from_partial(s, n, slab,
 							ac->orig_size);
 			if (object)
@@ -4578,7 +4574,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 /*
  * Slow path. We failed to allocate via percpu sheaves or they are not available
- * due to bootstrap or debugging enabled or SLUB_TINY.
+ * due to bootstrap or debugging enabled.
  *
  * We try to allocate from partial slab lists and fall back to allocating a new
  * slab.
@@ -4632,7 +4628,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	stat(s, ALLOC_SLAB);
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		object = alloc_single_from_new_slab(s, slab, ac);
 
 		if (likely(object))
@@ -5861,7 +5857,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	unsigned long flags;
 	bool on_node_partial;
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		free_to_partial_list(s, slab, head, tail, cnt, addr);
 		return;
 	}
@@ -7573,7 +7569,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 {
 	int i;
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		const struct slab_alloc_context ac = {
 			.caller_addr = _RET_IP_,
 			.orig_size = s->object_size,
@@ -7874,7 +7870,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		 * cache.
 		 *
 		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
-		 * caches with debug enabled, and all caches with SLUB_TINY.
+		 * and caches with debugging enabled.
 		 * For kmalloc caches it's used temporarily during the initial
 		 * bootstrap.
 		 */
@@ -8691,7 +8687,7 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
 	capacity = calculate_sheaf_capacity(s, &empty_args);
 
-	/* capacity can be 0 due to debugging or SLUB_TINY */
+	/* capacity can be 0 due to debugging */
 	if (!capacity)
 		return;
 
@@ -8757,8 +8753,10 @@ void __init kmem_cache_init(void)
 
 	slab_obj_ext_has_codetag_init();
 
-	if (slab_tiny_enabled)
+	if (slab_tiny_enabled) {
 		slab_max_order = 1;
+		static_branch_enable(&slub_debug_enabled);
+	}
 
 	if (slab_max_order_param <= MAX_PAGE_ORDER)
 		slab_max_order = slab_max_order_param;

-- 
2.56.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB0BF8FA8A
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3D76B0088; Tue, 21 Apr 2026 10:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4C26B0089; Tue, 21 Apr 2026 10:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E25E6B008C; Tue, 21 Apr 2026 10:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2156B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:50:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A60F95D6A1
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:50:02 +0000 (UTC)
X-FDA: 84682847844.26.2248786
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF91F40006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:50:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oZxvH+b8;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776783000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=W2q9+8COZHUB8LqUfvKNVH9UUq+NacRgH2iGY75VTYo=;
	b=dpq+KVqTvvaDAAfoAKnFPD7xZSGvvWcqhaxGlkZSZ/02qx9UjGKYfRrE9c5XyziEYXzWn8
	PLYzvrDOiWESiyLrJ12zcG/TX4u+TQKX+Xpzmzu6C5pkM6S28G8iwg4iLhyvbQKZTd6k3J
	ASlFLW6dKJUKtuahxtpkyg51D7lmliI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776783000; a=rsa-sha256;
	cv=none;
	b=PE2ZfwffkbLOqHu6psoIZe+aolL2MA4giiHACN87IVvM4D0+USU1ApXXpX/9c1tCfIAtwE
	aU15Utaff1rRKTz5G1pNPGT2kWR7gMbLk4lbQVcHEww+NX7Hm0wLBOISI9ejG4O3k6sjGg
	s8Y1buUjsVeLT8NoysJ6H/IQZ5HSobc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oZxvH+b8;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A7ED6001A;
	Tue, 21 Apr 2026 14:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C60C2BCB6;
	Tue, 21 Apr 2026 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776783000;
	bh=4dlPrU8yFUaDBn0M4T8t9tx0LHAIhkl8Hlx1Qxruau8=;
	h=From:Date:Subject:To:Cc:From;
	b=oZxvH+b8ZlT7ophr0Aw/Gb8XXvVck8gU0A0pjZXtK5cggQZGAJ2Set2stRddi2vcQ
	 awLh0j599WbSKlR6PreGNP20Ejpz0AADLTKifhMTUgUiAGybJVRHNQUjgayzauRQWl
	 5Of7LPP92tdrQBBNUTIz9zyByhPSF1370LY+isBcOfy92yj7TprGXarUzhJSo76rbl
	 6LFOQYR0rsweptYyUPtKv7AufcUuFkC1vZEgZfIetqIsIlOTV1AYTwzr5fN2nvbou/
	 X/SpLmNWVxYS5cWY4W7Npa/Fn9C5lnfJUI1njEHfCSkTpyQKk75tJZgt4oYXWHecld
	 MPIls4QP5WocA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 21 Apr 2026 16:49:52 +0200
Subject: [PATCH RFC] mm, slab: add an optimistic
 __slab_try_return_freelist()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org>
X-B4-Tracking: v=1; b=H4sIAI+O52kC/yWMwQqCQBBAf0Xm3IBuQ1HXoA/wGh7acawJW2Vnl
 UD899Y6vsfjLWASVQzOxQJRZjUdQoZqVwA/7+EhqG1mcKU7lOQq9IRROu17HMakb7WknE2aYsC
 OqN37IzHTCfJh3MrP736D+nqB5i9t8i/htH1hXb+cheDDhAAAAA==
X-Change-ID: 20260421-b4-refill-optimistic-return-f44d3b74cc49
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6503; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=4dlPrU8yFUaDBn0M4T8t9tx0LHAIhkl8Hlx1Qxruau8=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBp546T+OHvSI+A1IGjQ7RTjXxVbAUXST8qJtnBh
 yLtAXdqAWeJAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaeeOkxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQu+CwddJFiJoOVgf+PlJMZ5LGHo8YS1NDWCjC3ldC0EzoReR
 5wMTonVKUzITZnslQcY3rauafZqIZ8h2d+LOxFltPVHFTilX6hKLRhByZa+4a1uUxtGFNSczDx2
 SnWJCMftuDm2vB517IRSeYRvtCW+JWqCl1eEKFTNkyjQ/AR6xLTxip/v+7xmTCcM40flnVMNoyB
 NOLrsJ1tSeWHP/a89DIlI7ll5Oy5xgPPOpbd9bVDuPr9vLtk226yr9oK5hcM5zJ/NcerYfwJ8nD
 7vtRJnL9D7eENqDLOhw+GWn86uFkAagtquL3uXTLToPE9jIVu5OEOpbpewLX5GhjD3qdAPogqZU
 9g4sx8ENFrQ==
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Stat-Signature: afdke8fmdt4sfd64hzeojwyjow15eoiw
X-Rspam-User: 
X-Rspamd-Queue-Id: DF91F40006
X-Rspamd-Server: rspam05
X-HE-Tag: 1776783000-949653
X-HE-Meta: U2FsdGVkX18+C4PLymV3TTvDW2bwBhh1M+Z50jwNCvtBuUSYh3sHM8PfM+X7ooeC3FVRmrnS3A2t9lUiCFWD9NUdo6LAF1xjgmTmtVDRXMMOVy9EnAyFH7Khy3lT0OV9NI/Y3mPgLrKeM8gVqN7vOzf3MvClA+o9oIy1al1/oKOUCoWRYJlnLOW65XYLCXd6qB0dmYFfDUEMLlomr1Ioun7GQ70XVfpcjdRYAbjKTvUsh0iUpRhFBOVLcOidKAIIdFpt+IMx1AV0J6mBfmj0xiwiIuJesMl9OyhIlfKqxZliJupocUlpHXNULHxDJOVbH/Teq/Vkduaqog9mXGITIG8lSnSxDu7WQD/XzdwZJH4QGxs6xF+l/hlG6iXOpBZMWCY9ew5l0SL5CX3ZoCNUNarq2lBtLK4wJa4/cBJPc2lFzCQ0YiUUpeNdBhWmDwFRpvfqbmSo0DkqY7gdK+djpRDz4UjU0vEUcJ5yUVusEfr+nZoNrZT0LGGSH/1DDKgPS0ydhuvZzV2optTtXdvm1YbxFR7jYUG9FNXhCrLsbhBQXQ8Iv/GwxAmE5NATNI8JyD85Gs/s1rjk9Fy/lEvZkix+yscA8LLaxB9M4TlSbdWRzziAagPGYQ0g9WwsM62M/SwbQ/I0ZFDjKSt4on9oR2EcDuH7WJgnl87uqqFvfR/XPJi2JTDr/JAb4AD/HUvTgR2M77cM0uKvGUuies2SabS8vhewuJcNoVoGrThXia0bY5U4TfKyngUAhh3aW4dmhjF47dTYR7UwUq05jJcUfynKXyVni3GO0ON6dbFiVQklHxyypQcQSOCD+lejpVkCWZgU2Yb9Z61ioMkEpo/l9aQvwPTKzpIYAV6F4+cqcZ9QjfMqZCCvAyx9KY3CHPvgCV4ZoKFiWAGD2LkkmpYVw13M2ZuG+ZVn0F6LRBWsuosBbO46jpAIiRrbZLAwqf8nor7XTgKfqHQf8R1uUfg
 +bVYIO2O
 ZGuGJTSLpyt47heNhO4qDgOEj+MHLI3OOvhmduI6kLXUtA+HSGkpvFYiSHrZmCKBK2RKkxMonxUFmmn6VY8fTq/YZMT6lL86xm6546F9qwqfdqXYRC8vLIgyKfw2ZeqIq79G1TaPwenbCXSz2NclgPd0q5MNBWMe/AIMJbLE+Z1MLiRxOKxeapWvUAz+cfOdQ+GjllNUl/ZQeI3c3yC3NmmPWP47Rn9odJSVdiBDnlUQDdmFipCj6kVTdGuQEVhUxiWThTaOdQmMnzZm4ohI6X++pmFIj7UCdRc+/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we end up returning extraneous objects during refill to a slab
where we just did a get_freelist_nofreeze(), it is likely no other CPU
has freed objects to it meanwhile. We can then reattach the remainder of
the freelist without having to walk the (potentially cache cold)
freelist to to find its tail to connect slab->freelist to it.

Add a __slab_try_return_freelist() function that does that. It's a bit
like __slab_free() but many situations from there cannot occur in this
specific scenario so it's simpler.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
I've got this idea during the discussions on refill spilling, but not
sure if I've mentioned it on-list. Anyway it seems like there should be
no downsides (in theory...) so please test if it indeed improves things
anywhere and then it could be a better baseline before trying anything
that comes with tradeoffs?

I've included SLUB_STAT items that show to me the optimistic path is
indeed successful, but maybe they don't need to make it in final version
due to being rather low-level.

Git version here:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/refill-optimistic-return

It's Linus' upstream few days ago with "mm/slub: defer freelist
construction until after bulk allocation from a new slab" which is
heading to 7.2 so also should be considered part of baseline.
---
 mm/slub.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 35b6cd0efc3b..176bc4936d03 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -373,6 +373,8 @@ enum stat_item {
 	SHEAF_PREFILL_OVERSIZE,	/* Allocation of oversize sheaf for prefill */
 	SHEAF_RETURN_FAST,	/* Sheaf return reattached spare sheaf */
 	SHEAF_RETURN_SLOW,	/* Sheaf return could not reattach spare */
+	REFILL_RETURN_FAST,
+	REFILL_RETURN_SLOW,
 	NR_SLUB_STAT_ITEMS
 };
 
@@ -4323,7 +4325,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
  * Assumes this is performed only for caches without debugging so we
  * don't need to worry about adding the slab to the full list.
  */
-static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
+static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab,
+					  unsigned int *count)
 {
 	struct freelist_counters old, new;
 
@@ -4339,6 +4342,7 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
 
 	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
 
+	*count = old.objects - old.inuse;
 	return old.freelist;
 }
 
@@ -5502,6 +5506,50 @@ static noinline void free_to_partial_list(
 	}
 }
 
+/*
+ * Try returning a (part of) freelist that we just detached from the slab.
+ * Optimistically assume the slab is still full so we don't need to know
+ * the tail of the freelist. Return to the partial list unconditionally even
+ * if it became empty.
+ *
+ * Fail if the slab isn't full anymore due to a cocurrent free.
+ *
+ * Can be only used for non-debug caches
+ */
+static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
+				       void *head, int cnt)
+{
+	struct freelist_counters old, new;
+	struct kmem_cache_node *n = NULL;
+	unsigned long flags;
+
+	old.freelist = slab->freelist;
+	old.counters = slab->counters;
+
+	if (old.freelist)
+		return false;
+
+	new.freelist = head;
+	new.counters = old.counters;
+	new.inuse -= cnt;
+
+	n = get_node(s, slab_nid(slab));
+
+	spin_lock_irqsave(&n->list_lock, flags);
+
+	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist")) {
+		spin_unlock_irqrestore(&n->list_lock, flags);
+		return false;
+	}
+
+	add_partial(n, slab, ADD_TO_HEAD);
+	stat(s, FREE_ADD_PARTIAL);
+
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	stat(s, REFILL_RETURN_FAST);
+	return true;
+}
+
 /*
  * Slow path handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
@@ -7113,34 +7161,40 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 
 	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
 
+		unsigned int count;
+
 		list_del(&slab->slab_list);
 
-		object = get_freelist_nofreeze(s, slab);
+		object = get_freelist_nofreeze(s, slab, &count);
 
-		while (object && refilled < max) {
+		while (count && refilled < max) {
 			p[refilled] = object;
 			object = get_freepointer(s, object);
 			maybe_wipe_obj_freeptr(s, p[refilled]);
 
 			refilled++;
+			count--;
 		}
 
 		/*
 		 * Freelist had more objects than we can accommodate, we need to
-		 * free them back. We can treat it like a detached freelist, just
-		 * need to find the tail object.
+		 * free them back. First we try to be optimistic and assume the
+		 * slab is stil full since we just detached its freelist.
+		 * Otherwise we must need to find the tail object.
 		 */
-		if (unlikely(object)) {
+		if (unlikely(count)) {
 			void *head = object;
 			void *tail;
-			int cnt = 0;
+
+			if (__slab_try_return_freelist(s, slab, head, count))
+				break;
 
 			do {
 				tail = object;
-				cnt++;
 				object = get_freepointer(s, object);
 			} while (object);
-			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
+			__slab_free(s, slab, head, tail, count, _RET_IP_);
+			stat(s, REFILL_RETURN_SLOW);
 		}
 
 		if (refilled >= max)
@@ -9366,6 +9420,8 @@ STAT_ATTR(SHEAF_PREFILL_SLOW, sheaf_prefill_slow);
 STAT_ATTR(SHEAF_PREFILL_OVERSIZE, sheaf_prefill_oversize);
 STAT_ATTR(SHEAF_RETURN_FAST, sheaf_return_fast);
 STAT_ATTR(SHEAF_RETURN_SLOW, sheaf_return_slow);
+STAT_ATTR(REFILL_RETURN_FAST, refill_return_fast);
+STAT_ATTR(REFILL_RETURN_SLOW, refill_return_slow);
 #endif	/* CONFIG_SLUB_STATS */
 
 #ifdef CONFIG_KFENCE
@@ -9454,6 +9510,8 @@ static const struct attribute *const slab_attrs[] = {
 	&sheaf_prefill_oversize_attr.attr,
 	&sheaf_return_fast_attr.attr,
 	&sheaf_return_slow_attr.attr,
+	&refill_return_fast_attr.attr,
+	&refill_return_slow_attr.attr,
 #endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,

---
base-commit: da993c58f9bde299a5e1a4e7900125b32dccd2a6
change-id: 20260421-b4-refill-optimistic-return-f44d3b74cc49

Best regards,
--  
Vlastimil Babka (SUSE) <vbabka@kernel.org>



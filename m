Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB745606A331
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oISKXA5E
Received: by kanga.kvack.org (Postfix)
	id E1CC96B05B3; Sun, 15 Nov 2026 10:10:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD136B05B4; Sun, 15 Nov 2026 10:10:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC556B05B5; Sun, 15 Nov 2026 10:10:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93E776B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:10:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18D8F1C40E7
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:22 +0000 (UTC)
X-FDA: 85437689484.06.E04C4E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 52FC618000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oISKXA5E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEpvJjswIVVnFhWoxB5UG1ML2CnsBWwLFbFU6DcBCqQ=;
	b=mhHdjjz9W/u19hIUrepGDsELkSjPHceSxJtkNAA+pYMwZVObTzASN0PpedzvD9N6T33Vc7
	TQ3TpZyh7Itx/ZXkC4mjnciVLlsiBn2a5+t6y9a4aaGEY3jfHF7oNGUOoA9bzPXTLtgUt7
	49PeoKsqKUj2vrx08qn7EFYWddSEIVA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oISKXA5E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794755420;
	b=eGUI/jvisCd9DdpSZyDyN5Bbiy0iO+SkzWcbl970vVgwKuuFkXEkQziR+WyizZpKvtv7MO
	dcYZIMmegBuT5sucK4yKdtXYrFzYoYOxCbAW0cVJ9qXybTVdz9axPOyl1WEmYS+FLV5X5u
	WZVk7gL+PRLTgWwvn4Lipviecn0CuuU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 943E643EC0;
	Sun, 15 Nov 2026 15:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D4C1F000C4;
	Sun, 15 Nov 2026 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755419;
	bh=LEpvJjswIVVnFhWoxB5UG1ML2CnsBWwLFbFU6DcBCqQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oISKXA5E2zGjU7JwWeZoNC5HOL9bMy/MNsoDXDI0q4Qa7509anBWcQy2sRuTOcKiz
	 QNKBCfG+ZHJEp/EjpaUQVdn8kaXnGax69xIJoVw9ZsPtmLypIJ4oLkhHh/paop12XR
	 h+Fmp5QJQS8Jybk0yaEVVcmXg3105bAOqyKoc93lczQaSBqUYqHJJPDHWI1d7WJzgG
	 0PQjEj8wZr5xfMBGKqoH14iLkiK/O5B5exn6l9gWC2dRfS+lBuqH5luUUaTVnxiBxe
	 4MGN2bq8r2BkNr27QIAtQrcpe87N6m43xl0o3P0+sxAullm34CtsWo2/tOaCDin4c0
	 pJ0AwTWrdR1/w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:36 +0000
Subject: [PATCH for-next v3 2/7] mm/slab: pass free_flags to
 slab_free_hook()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-kmalloc-nolock-fixes-v3-2-9034dd4ecaab@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52FC618000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ihimj8czo75m4ic16sxiwtrd8a64cwci
X-HE-Tag: 1794755420-603376
X-HE-Meta: U2FsdGVkX1/2oTreQ6WJk7Rhz81cB08tqLu2iIFnVp9CPRp7C4HD3KR4TWarpTQURphcEk7BIts2hxNV0GBHAYK764R7q0L6Ofy5aeFofF1u6gFlwWK6S8jXI0oYD8b8DTGpFDKPvkINUlXiyxUuZKG+JGiV0ixY9bagEbnmP+/9dNIG1DI5WyOLEyj0CC4sDFCRBkAEbvH5wswfPLRPs0SXKVA/1mChDhp8EBeUrGUehiRCh0xKFhsEDo/0qS3xPFGys8qf4v+AnhU1um2Ab2W3kH8CNt0otdA/vWE0TOtupY6bnwTpV/+gAk2qGlAvl1Oy8BO2OlZ7zAfI7BZMaVOsyvdgPcYMBm3XOoDoVRs9uwD9XgXhytRRyvh1p/koi6BriFHAX0nXUnLTQSwUglNJKL/DlxsylVKIbZsSinQqfmViVZWImrN6RDU51jm0EO9+OTLvH70NvOqwrE/ivIvEBRg/3omHQxgsvfXjwk3zshxu4OGDudjZj7yH+UWnjh1F9//KHRpMb/mupntQxy4dbtvkRhJYlR61H0kXZXD0aMrPq0XAgU8J/t1o2cryAGi9t6UQ3z0DrFW59Apklgmk2CoS1tTjuyBnzokDqJAEYxbcj2gCDSv4kdyuWHhj8bQXUda3S3VgJjGoCtqRuGBSCE1sC2IjYXaTUa4Hm7FvaDdW7nQtaf+UvHknDXKuTaQZKYpBbSaRn3DDx5fLcfKEieb1egfbImyrlZeyTRjQCRhpJvisPSyJf3ZVrb14oaNp73LANl3ZKqmXQeht1sfpWQ3DauTiSdx6tXfUwj6BjzswIMyWK4gHV1jjQVrlz3U1xb6NYNmpm3PXKiyiU/44aUdugSE8CM/lns5VIv93LuGQ/NczmXRYwwbjkav8/9tA6G5aTV/W3qB/lWHM2u82rKxoSF18IMR1sQsTZb4B/RMFaIK9sq3VJIVmQSMPXR78WbA/gxeZtVh5OKC
 vSZHlmpI
 XmawYstWZPpMu5E156s3TU7oU+Pl8UEVDENamQDqGb+XBS6I+rJjNSgKvyF6mRnd5idWnTtQv94TY1rYcPm6OXtabmcv+4YZfTz1hRMgtpazM6kdAlH4nexcVml5R0MIEAG94AvFNcwLQwR7UgGj2sT12LSQUGxIMNV5HUZpWOt0vgdHd/bpCk+/+B9Wii+k8LthWfmjUZqoRjqHUVlEum0wfIlF68gngwc6wPM+V0bR3rH6RxpAPTaz2grNQqOoqp/AIeREtudxw7nPmmHaUW2j3xWyHqiC2SKD3N5njjvAGdb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

slab_free_hook() takes two bools, init and after_rcu_delay, and a later
patch needs to tell it whether spinning is allowed.

Instead of adding a third bool, make it take free_flags. Add
SLAB_FREE_INIT and SLAB_FREE_AFTER_RCU_DELAY, and convert the callers.

No functional change intended.

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/f31885cd-57c2-428d-9760-a76a0137f989@kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slab.h |  6 ++++--
 mm/slub.c | 47 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc..15b0d98ae1d4 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -24,8 +24,10 @@
 #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
 #define SLAB_ALLOC_NO_OBJ_EXT	0x08 /* prevent obj_exts array allocation */
 
-#define SLAB_FREE_DEFAULT	0x00 /* no flags */
-#define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
+#define SLAB_FREE_DEFAULT		0x00 /* no flags */
+#define SLAB_FREE_NOLOCK		0x01 /* spinning not allowed */
+#define SLAB_FREE_INIT			0x02 /* zero the object on free */
+#define SLAB_FREE_AFTER_RCU_DELAY	0x04 /* RCU grace period has elapsed */
 
 static inline unsigned int to_alloc_flags(unsigned int free_flags)
 {
diff --git a/mm/slub.c b/mm/slub.c
index 86259c32cf59..761dc2affea2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2694,9 +2694,10 @@ struct rcu_delayed_free {
  * - __kcsan_check_access()
  */
 static __always_inline
-bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
-		    bool after_rcu_delay)
+bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 {
+	bool init = free_flags & SLAB_FREE_INIT;
+	bool after_rcu_delay = free_flags & SLAB_FREE_AFTER_RCU_DELAY;
 	/* Are the object contents still accessible? */
 	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
 
@@ -2786,10 +2787,10 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 	void *object;
 	void *next = *head;
 	void *old_tail = *tail;
-	bool init;
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
 
 	if (is_kfence_address(next)) {
-		slab_free_hook(s, next, false, false);
+		slab_free_hook(s, next, free_flags);
 		return false;
 	}
 
@@ -2797,14 +2798,15 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 	*head = NULL;
 	*tail = NULL;
 
-	init = slab_want_init_on_free(s);
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
 
 	do {
 		object = next;
 		next = get_freepointer(s, object);
 
 		/* If object's reuse doesn't have to be delayed */
-		if (likely(slab_free_hook(s, object, init, false))) {
+		if (likely(slab_free_hook(s, object, free_flags))) {
 			/* Move object to the new freelist */
 			set_freepointer(s, object, *head);
 			*head = object;
@@ -3025,18 +3027,21 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
 static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
 				     struct slab_sheaf *sheaf)
 {
-	bool init = slab_want_init_on_free(s);
+	unsigned int free_flags = SLAB_FREE_AFTER_RCU_DELAY;
 	void **p = &sheaf->objects[0];
 	unsigned int i = 0;
 	bool pfmemalloc = false;
 
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
 	while (i < sheaf->size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
 		memcg_slab_free_hook(s, slab, p + i, 1);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
-		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
+		if (unlikely(!slab_free_hook(s, p[i], free_flags))) {
 			p[i] = p[--sheaf->size];
 			continue;
 		}
@@ -6458,10 +6463,13 @@ static unsigned int __free_to_pcs_batch(struct kmem_cache *s, size_t size, void
  */
 static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 {
-	bool init = slab_want_init_on_free(s);
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
 	void **remote_objects = p;
 	unsigned int remote_nr = 0;
 
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
 	/*
 	 * Process the free hooks and separate out remote objects by
 	 * partitioning the 'p' array in place:
@@ -6476,7 +6484,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		memcg_slab_free_hook(s, slab, p + i, 1);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
-		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
+		if (unlikely(!slab_free_hook(s, p[i], free_flags))) {
 			p[i] = p[--size];
 			continue;
 		}
@@ -6600,10 +6608,15 @@ static __fastpath_inline
 void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	       unsigned long addr)
 {
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
+
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
 	memcg_slab_free_hook(s, slab, &object, 1);
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
+	if (unlikely(!slab_free_hook(s, object, free_flags)))
 		return;
 
 	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
@@ -6619,10 +6632,14 @@ static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
 	struct slab *slab = virt_to_slab(object);
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
+
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
 
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
+	if (likely(slab_free_hook(s, object, free_flags)))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
 }
 #endif
@@ -6651,6 +6668,7 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 	void *object = delayed_free->object;
 	struct slab *slab = virt_to_slab(object);
 	struct kmem_cache *s;
+	unsigned int free_flags = SLAB_FREE_AFTER_RCU_DELAY;
 
 	kfree(delayed_free);
 
@@ -6664,8 +6682,11 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 	if (WARN_ON(!(s->flags & SLAB_TYPESAFE_BY_RCU)))
 		return;
 
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
 	/* resume freeing */
-	if (slab_free_hook(s, object, slab_want_init_on_free(s), true)) {
+	if (slab_free_hook(s, object, free_flags)) {
 		__slab_free(s, slab, object, object, 1, _THIS_IP_);
 		stat(s, FREE_SLOWPATH);
 	}

-- 
2.54.0



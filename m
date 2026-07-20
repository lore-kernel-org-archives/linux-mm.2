Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C20B7C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0CB36B00A1; Mon, 20 Jul 2026 08:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBF1C6B00A2; Mon, 20 Jul 2026 08:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81616B00A3; Mon, 20 Jul 2026 08:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70A866B00A1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:45:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED98916015C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:41 +0000 (UTC)
X-FDA: 85009126482.19.F173231
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D96EA0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QzdowtEn;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7imT+FTw9hwkIa++YEpGORHLE52uWQJDNq1DlQ+ILo=;
	b=44MdOg+wb30NLzhACDX347KV6dFpOiUaeD1zY1UlbpxGKI1nBBsQRbhKSVwbllWksIkC8a
	t19m1huJW/ik3ih2cwIByLWHSsaqga3TCUHkijVpBvlIuiBZC7oWDf2KPfrE7ofzSuYFoi
	QWZSgC7+9VGHT6jmHYP/oxLOWRmmm/M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QzdowtEn;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551540;
	b=cRIiBBCXSog83hktt03GkWCB2jwLjkrSyHNzdB8uSgu4y84N49itYTDpkj7r/MkJvoloSn
	Co4r9jD+sAuc4nCqOIXic3q9ZQjoDLa6M4HI7ykPG7eHTNcLF/CHMWY7xiqOZBR+WdQVm2
	Z2k8qi4SKpGZIDm58dmwD0ahxxP/oyA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEB1760A8E;
	Mon, 20 Jul 2026 12:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969B01F00A3A;
	Mon, 20 Jul 2026 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551539;
	bh=M7imT+FTw9hwkIa++YEpGORHLE52uWQJDNq1DlQ+ILo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QzdowtEnOJWwFNbLbV2yvYoyji13SiHT3RbhpTWm01Vb0CDHB5GanlqnnhmLU6vjs
	 IJXAcAqXGPaRQtTnXRM86CdRaGkoeYL67caTz/cQ9bf9MZaBPdnjInjxYoJ9iJojxP
	 UgL2qymEknwnABdFsw/Qd2KPeYvlsNTC6T/Vk0cL85DgTHJqiVx3tnZeWg4vhZJUwG
	 NiB/PJe1cADxfsP6BVJEYuvxjevtnJODGAcFU/K+PTgq4fDfGVrTONKgUfm1BZn8d0
	 MBKdMb++oT+5U3U9rae8fsFDKfAEPB0U2X69dMIfXZycK26wj9STpnS/sNYSy+B0u+
	 +F7NhIDhZQwhA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 20 Jul 2026 21:44:31 +0900
Subject: [PATCH slab/for-next v4 2/8] mm/slab: handle the !allow_spin case
 in kfree_rcu_sheaf()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kfree_rcu_nolock-v4-2-964e03c41a4e@kernel.org>
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
In-Reply-To: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, 
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D96EA0003
X-Stat-Signature: i5w99hpxoz3tb5pn8x5neeths3cyx48j
X-HE-Tag: 1784551540-777078
X-HE-Meta: U2FsdGVkX1+HHbt24Bu+ijSByXmuAfYAhQk03fukL43RFdOkeM2n9lJ7sQQs/Y51ibupC7rQHxgqoz+kveHKw8W18E3TgFP/W63fVdxVwQwOwdttRA56/5RJasnVAIRZ0Mbs8Jj6vw6yhv+eVF4oRCR3cCgyJr476CjI2c5cPUe/draZ41v91x5l9YnUJkGcv2dyD9e41CjwEpcQGEh44xzbj7Cpf/UjLa8obglwwfHYspdIHQ7dS8h7mBF5rOiRS8zv+jeBfO0CisT7pwgqYN+rKScFB94JpWZqbGwoJV9YU8jhPlm+jzHrouP5COeYbbjiKk/Oy6k2fvz+XeWhoooizpXz0hKTjrU4zLY2Erc6wNsT4BCxh1FYtmpgb0DGnWU33ogNzdp/Asy+ljoQy90Rf6eRty4VVnI00uhVCgNx31PyjRip/V4Zlyvqwdi+h8syVVGCSdwBKiSwGLMdXZbh6zJ9gYTTt8P5eYcYjmmPcAswrkMNwvz56PUtvlwHuepcGjKWd8X3A75m8pato6UxNujTmWpr3j+U8RBfSRG5qA9vDsRKzQH66wzrhU3ebSQOR6XLzJlUHl2SZ9KGa/9slPPoz+bVfpq9evUUTgRZ+IzRbvHqNpfqSWU3rnzRst26OYxJwdf6GpcKDuV7vtW7MiY5vtnOjNFugnMNARzFIYQ5M1ujJTTqHKfP8M7rwhtPzQ+7tuLQk/hd3tEGBKAJiyTd9wUT7PAHTwykkSim+1WZf6bZZYjE/RpCNZvE4/zQwdY/9uG+JLHt3xmEbzWEuMxrcYahzFUh81ki7+yw3hmovj32dW2o0aLejfq7psfYczi+u7/Qy3YHoy/xAjm3+pyEmA+1Z5r4u/zt/m4qcYZxu9Qe9h8l3Jnkb7x8IzmGFBsiFCiytCrHEYUKPt2jA6vrrMiwKlAx2kkY7Gdk4uPZRLvSK4cVEF3n6HJkpLBGm6r1r6jZhUx7vEB
 iTST7wrA
 iw26M137JeTcCdcN2E2VN5ZP1jQI/KhyEAvfxPyKR/klaENRgBJn5S+yndouUOLdGAHo4zuWKW/YYBp8Jr1wh0DEn23uvYUdzraSO4YDy1SCuV0APXuZzrE2voPuQpsg9YD0d5nOOgoDO5vFSMBnMp48KqWHzZKTAjrLK/XIFMj/lufclEmqpDFxmNR5/dPpFHzk9l6fDr/8OnMeSpjw4vthH6i2r5RI+Yco2+yGNg+5WB/Iz9e7WHDPQ1jkTOC2KuvjsUnbOgkLJ6DLghK/fvdGR3Z394QZrVF8Vr4T3DKjdC4OCBcnNiXteE1xGmUFXWCGBlNSBTmEh9yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Try to get
an empty sheaf from pcs->spare or the barn even when spinning is not
allowed. Unlike __pcs_replace_full_main(), try harder to allocate
an empty sheaf because the fallback path will be more expensive than
kfree_nolock().

Now that slab has internal alloc_flags to describe context, introduce
free_flags analogously and convert free_flags to alloc_flags when
allocating memory in the free path. alloc_empty_sheaf() now strips
__GFP_RECLAIM when SLAB_ALLOC_NOLOCK is specified.

When trylock fails or the kernel observes non-NULL pcs->rcu_free after
lock acquisition, free the sheaf instead of putting it to the barn.
This is rare and not worth complicating the code.

Since call_rcu() cannot be called in an unknown context,
kfree_rcu_sheaf() fails when the rcu sheaf becomes full.

Link: https://lore.kernel.org/linux-mm/872bd673-3d45-4111-8a41-31185db3ece5@kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab.h        | 18 +++++++++++++++++-
 mm/slab_common.c |  2 +-
 mm/slub.c        | 36 ++++++++++++++++++++++++++++--------
 3 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 281a65233795..85ef2ebc9812 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -23,11 +23,27 @@
 #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
 #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
 
+#define SLAB_FREE_DEFAULT	0x00 /* no flags */
+#define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
+
+static inline unsigned int to_alloc_flags(unsigned int free_flags)
+{
+	if (free_flags & SLAB_FREE_NOLOCK)
+		return SLAB_ALLOC_NOLOCK;
+	else
+		return SLAB_ALLOC_DEFAULT;
+}
+
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
 	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
 }
 
+static inline bool free_flags_allow_spinning(const unsigned int free_flags)
+{
+	return !(free_flags & SLAB_FREE_NOLOCK);
+}
+
 void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
 				  unsigned int alloc_flags, int node)
 				  __assume_kmalloc_alignment __alloc_size(1);
@@ -429,7 +445,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
 }
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags);
 void flush_all_rcu_sheaves(void);
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index b6426d7ceec9..e07b4e6d6679 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1605,7 +1605,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj);
+		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
 
 	return false;
 }
diff --git a/mm/slub.c b/mm/slub.c
index e32a68677537..0c350274fbff 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2814,10 +2814,14 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 
+	if (alloc_flags & SLAB_ALLOC_NOLOCK)
+		gfp &= ~__GFP_RECLAIM;
+
 	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
 }
 
-static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
+static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
+			       bool allow_spin)
 {
 	/*
 	 * If the sheaf was created with SLAB_ALLOC_NO_RECURSE flag then its
@@ -2829,11 +2833,20 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 		mark_obj_codetag_empty(sheaf);
 
 	VM_WARN_ON_ONCE(sheaf->size > 0);
-	kfree(sheaf);
+
+	if (likely(allow_spin))
+		kfree(sheaf);
+	else
+		kfree_nolock(sheaf);
 
 	stat(s, SHEAF_FREE);
 }
 
+static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
+{
+	__free_empty_sheaf(s, sheaf, /* allow_spin = */ true);
+}
+
 static unsigned int
 refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 	       unsigned int max);
@@ -6044,10 +6057,11 @@ static void rcu_free_sheaf(struct rcu_head *head)
  */
 static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
+	bool allow_spin = free_flags_allow_spinning(free_flags);
 
 	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
 		return false;
@@ -6060,9 +6074,9 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(!pcs->rcu_free)) {
-
 		struct slab_sheaf *empty;
 		struct node_barn *barn;
+		unsigned int alloc_flags = to_alloc_flags(free_flags);
 
 		/* Bootstrap or debug cache, fall back */
 		if (unlikely(!cache_has_sheaves(s))) {
@@ -6082,7 +6096,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 		}
 
-		empty = barn_get_empty_sheaf(barn, true);
+		empty = barn_get_empty_sheaf(barn, allow_spin);
 
 		if (empty) {
 			pcs->rcu_free = empty;
@@ -6091,20 +6105,20 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 		local_unlock(&s->cpu_sheaves->lock);
 
-		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
+		empty = alloc_empty_sheaf(s, GFP_NOWAIT, alloc_flags);
 
 		if (!empty)
 			goto fail;
 
 		if (!local_trylock(&s->cpu_sheaves->lock)) {
-			barn_put_empty_sheaf(barn, empty);
+			__free_empty_sheaf(s, empty, allow_spin);
 			goto fail;
 		}
 
 		pcs = this_cpu_ptr(s->cpu_sheaves);
 
 		if (unlikely(pcs->rcu_free))
-			barn_put_empty_sheaf(barn, empty);
+			__free_empty_sheaf(s, empty, allow_spin);
 		else
 			pcs->rcu_free = empty;
 	}
@@ -6122,6 +6136,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
+		if (unlikely(!allow_spin)) {
+			/* call_rcu() cannot be called in an unknown context */
+			rcu_sheaf->size--;
+			local_unlock(&s->cpu_sheaves->lock);
+			goto fail;
+		}
 		pcs->rcu_free = NULL;
 		rcu_sheaf->node = numa_node_id();
 	}

-- 
2.53.0



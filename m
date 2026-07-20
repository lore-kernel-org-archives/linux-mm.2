Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2595FC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E49B6B00A4; Mon, 20 Jul 2026 08:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E7F6B00A5; Mon, 20 Jul 2026 08:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D376B00A6; Mon, 20 Jul 2026 08:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEA806B00A4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:46:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C40B16014C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:46:00 +0000 (UTC)
X-FDA: 85009127280.18.149B960
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB60D80005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j93iNg0a;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bu4nv7yTgUcNSgTheBamJjAfAc2vPVO37Yi1zmMWM20=;
	b=DIzQ0+z+cN3ORgtMYq1uWR277D5Ww+YVJVokQUuF8wVQ07PmEJys1AfLl/ef0u8fnSBrWp
	WrpZ+FMeN+lPZPv6MjNrfnFQLtnbUrplviADvVznXiCxVRLPthqVETFKJuuK9318rUX1cQ
	fhhIxooBn99GzEOkbgIhlFEubthGcJ0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j93iNg0a;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551558;
	b=bwWTsI0IcwiBZocxHl+n0ONmxQISAY1Z55NJs4x3K5POKaSmhhP8LXzKYDBBC/7YGXEd7I
	5NXw2/I5aaUWZl6xWidrpf8PV9AMaFrX4oZ29ZWzxsS2S4MJ8hw70+Ly9d6uvX8/WoSgYl
	N3RtJtw2Ez4lKefCfaecmdDTUjMVpJo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D82060A98;
	Mon, 20 Jul 2026 12:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472DE1F00A3D;
	Mon, 20 Jul 2026 12:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551558;
	bh=bu4nv7yTgUcNSgTheBamJjAfAc2vPVO37Yi1zmMWM20=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j93iNg0aWP450n0a3vmlN7SaoaGxWSkb3BUzwdA2rGcitaFkj5+dSMRAEPgJh7aJl
	 6ZLAxACbMa3fYYF/mJ/whZO48aCz5FNPlHdLCruy3FguwoIInFxB5BiAJgHZ9q7LUb
	 ufENV/Ga+9Xxe1KeECbeaPU2oA/D0QbA/FPqGaqW5PFGCs4lqTYh6+0lqI7H+HL2pc
	 utgb4ysvYjoWYv23sM/f9OL7I6EfsyQVKEgQnkZ2/YsHRQZJafAIFGKKd6wKdaEObW
	 4v41gtUlBdI91V2Ku/P1rQLoKXieIFD6k6jS7mV0AINyqNZXXCmLY5VCwGDo5+lmgH
	 tT1ZjcfeH+Pbg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 20 Jul 2026 21:44:34 +0900
Subject: [PATCH slab/for-next v4 5/8] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kfree_rcu_nolock-v4-5-964e03c41a4e@kernel.org>
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
X-Rspamd-Queue-Id: BB60D80005
X-Stat-Signature: zzhnrcjudnky7fgoqusf6xzeysatjx7g
X-HE-Tag: 1784551558-212336
X-HE-Meta: U2FsdGVkX19B0RiWHX5lWUCm9MhfE9G6iB/xf2Yyw2pfIB0eMVc/CwJ6jjMdFBSvWCQAYyPx81IRk303zBRj8yZmbusQZic5nxDkR2V13sVYYmC7fgVTPNPic5JYf45VA5GMew8AhAiHttWeU5CyXfRT1+G4OPqnlXnDU2fQZqoKZEC0i8zZ4KXf3XAy/2Ja8k5LQDDJ9dWu+X6uDKF5xyYVApULbGiwyC9HIppZHNUTtG/YNXVZV/5kfNFcEXwGZ9J4KqdRKBY+QY5YuUXo0lnqAfHyP4dn48YDJSmSqFiyQFELLBD0DYN7TyVMDVgWsrdo2FmY1ct8eef6R4dUow5Y21k7YFYr9chT99Gf0jezQJOCJ08Fq8LbOpDFPlM9OrZIBG2KMV5UlDlLX9Gx4OsC/usuipX5/E4fb9tsvubH3/ejqsro07fmVFOaNgqV22M4psxFYNClQqMSO/MxWsAeMYVGXDiFFzagOsiQHNOhuRioR90amwHwhctPLirun74V9X30e4VB4VTh1ZPnBfOHAtA/0xEoiQO1K+EbVf8Kg3ip8+Nk65ypU11iMkxJ0DF3qQdHXcc2+FQLZwiYd9deb2knqQPbgrpRTkfejeVXBY7ZtZt2FfeGxxY1I0H5oy8lmSSAbP8V2jaK4acYeb00kObVpbZwHfYwC+cSQMizXb7ireRVowqrznGY8XaOWgtDmmvtAQsbObZXQ07RQB3kphoUekJdW+oNwnhsR8MO75sjCmsOrqQ4tqwJrBW6JhIdHZBm5ClsCo11F/ujZzHVLVEnwll8+vIkDeX9D1UV8ovQRGn320z9AuRxaPa3ZJuGw7ydmNGdqCE3K53ocU/vP7qPxFQWCE5Y/9EsLOOvsypnR1hTs8S7Bup64BuyOc2xoTdNbfNJFWV3fifvRohYO0PKd5QtQfDLNThapBCWIO4OQNewkv71P1KqIh7M50QtpyJ1c53mo4BbNv/
 YoMemhdv
 85cppsQBMuT0UASyXgwIUaCW407Xz/VBLK4/zyacZs7xcfqnOYQ9Dls2TPbHyceKUqgpeaCn7wKb+NrAGGQPOOSzlcWs2FKq+37nupDhq1rD7r66SbHes68rrrS1eIQdDEAMEGulkzRXbztFTybdqLvOZOsNrA4hZEGZt2fwSYwnqcg/i8t1m28JdxBV5LeA3iHYU4bk6NNRAPs/7aJIVrU/AoYHfhNdhpMsYYVoHlY+A/53mdqAe0tNkqqXWqpNIVRqryNlcjTOITyZm2cjFVlAwjDebUM242vJaNl8wKLYVXU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As suggested by Vlastimil Babka [1], kfree_rcu_sheaf() can be used
on PREEMPT_RT if we always assume spinning is not allowed on PREEMPT_RT.
This is because local_trylock and spinlock_t are safe to use with
trylock and unlock as long as the kernel does not spin and the context
is not NMI and not hardirq.

Now that __kfree_rcu_sheaf() knows how to handle SLAB_FREE_NOLOCK,
relax the limitation and try the sheaves path on PREEMPT_RT as well.

Keep the lockdep map on non RT kernels. However, do not use the lockdep
map on PREEMPT_RT to avoid suppressing valid lockdep warnings.

As pointed by Vlastimil Babka [2], on PREEMPT_RT it is unnecessary to
defer call_rcu() under IRQ-disabled section or raw spinlock. However,
let us avoid adding more complexity as the scenario is not supposed
to be common on PREEMPT_RT, with a hope that call_rcu_nolock() will be
soon supported in RCU.

Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org [1]
Link: https://lore.kernel.org/linux-mm/40591888-3a87-433e-b3d2-cda1cab543be@kernel.org [2]
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab_common.c | 12 ++++++++++--
 mm/slub.c        | 17 ++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 9c9ae1384f47..8c631bf97cd5 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1595,6 +1595,14 @@ static bool kfree_rcu_sheaf(void *obj)
 {
 	struct kmem_cache *s;
 	struct slab *slab;
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
+
+	/*
+	 * It is not safe to spin on PREEMPT_RT because the kernel might be
+	 * holding a raw spinlock and slab acquires sleeping locks.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		free_flags = SLAB_FREE_NOLOCK;
 
 	if (is_vmalloc_addr(obj))
 		return false;
@@ -1605,7 +1613,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
+		return __kfree_rcu_sheaf(s, obj, free_flags);
 
 	return false;
 }
@@ -1954,7 +1962,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (kfree_rcu_sheaf(ptr))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index 8afa6b47b1f2..deac315d0f23 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6065,12 +6065,13 @@ static void rcu_free_sheaf(struct rcu_head *head)
  * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
  * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
  * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
- * this problem by bypassing the sheaves layer entirely on PREEMPT_RT.
+ * this problem by passing allow_spin = false on PREEMPT_RT.
  *
  * However, lockdep still complains that it is invalid to acquire spinlock_t
  * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
  * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
- * by temporarily raising the wait-type to LD_WAIT_CONFIG.
+ * by temporarily raising the wait-type to LD_WAIT_CONFIG. Skip the lockdep map
+ * on PREEMPT_RT to avoid suppressing valid lockdep warnings.
  */
 static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
 
@@ -6080,10 +6081,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	struct slab_sheaf *rcu_sheaf;
 	bool allow_spin = free_flags_allow_spinning(free_flags);
 
-	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
-		return false;
+	VM_WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT) && allow_spin);
 
-	lock_map_acquire_try(&kfree_rcu_sheaf_map);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		lock_map_acquire_try(&kfree_rcu_sheaf_map);
 
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		goto fail;
@@ -6181,12 +6182,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	local_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
-	lock_map_release(&kfree_rcu_sheaf_map);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		lock_map_release(&kfree_rcu_sheaf_map);
 	return true;
 
 fail:
 	stat(s, FREE_RCU_SHEAF_FAIL);
-	lock_map_release(&kfree_rcu_sheaf_map);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		lock_map_release(&kfree_rcu_sheaf_map);
 	return false;
 }
 

-- 
2.53.0



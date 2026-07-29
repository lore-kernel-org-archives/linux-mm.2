Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D17C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3691F6B00F7; Wed, 29 Jul 2026 10:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340AC6B00F9; Wed, 29 Jul 2026 10:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27EB36B00FA; Wed, 29 Jul 2026 10:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1D9C6B00F7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:19:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38999805E3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:30 +0000 (UTC)
X-FDA: 85041119940.04.16E5598
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7A7792000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQALvU7M;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1d0ZrPSWSgL++PjfVv8vMUfwjJ5v7z9zclam76ZWUk=;
	b=yxrpxx23+S5/o1EZ5QrjwlhaiMgADpBDykemfAYaAaAPTRxu+EU4Uz9KROAB0YXzKQqAiK
	J3C8ssJ5R5Q56pcJGVXAviLA213RdfVgumKVmXtENeFyXtlqPyBLLnNWg3QJhMQGcIy8O+
	tRFDiEWVllskK28r+iwcy40dG7CA6Jg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313288;
	b=OD8JiBnDpnLVb8t8A9G4pY8nFmXNVgd46Ts2MU8Is/Ro3FtFI6JrKrCkxXVWVXkOf8BN7I
	/OqSZe6RqYqcf/D0QNq+KsNi4IwXdq9F6/bJ18ADmSqw5GEIcKvYua01T2q3frvlbVyo4V
	Ck9b7simAhb8vU+p85MwJDF57jr/kRQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQALvU7M;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C506243FC1;
	Wed, 29 Jul 2026 08:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19FB1F00A3D;
	Wed, 29 Jul 2026 08:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313287;
	bh=P1d0ZrPSWSgL++PjfVv8vMUfwjJ5v7z9zclam76ZWUk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YQALvU7Mf+/wrx7QNvIxWBiRtcDpQNcVu02yMb9SFOq+jZZ1K6RyzBFlSB+QuvRIV
	 QhlKOTvfpfiVp7SMTencBUjwycP9IPRL0ctU+b9TX1tJ3yjQFl8kBQPGCTXgOHBhBe
	 d85OSsfSB2akNKuKdY/RO8uM7zIblYwjF8wZjOMxGG6LJO7IEEqWQg9czxk6ddYBEO
	 /yb6A0ZHge+Coj+C8PC2nEZcv0/sXoJWCmVpeyjGxD70yIJCF9y/Ze7ZI0kI61K6Hu
	 50BQWwOkMPRkdL/fL/aan5exTbDtzpgCrnzPTqv+9Ede933XDQlnHGKal8o0pOnMPR
	 Od4jTJxe0/0VQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 29 Jul 2026 17:20:13 +0900
Subject: [PATCH v5 5/8] mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-kfree_rcu_nolock-v5-5-a28cdcda9673@kernel.org>
References: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
In-Reply-To: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A7792000B
X-Stat-Signature: eqnmc3g596w7i8e8p587zgrn84hkpi3o
X-Rspam-User: 
X-HE-Tag: 1785313288-887159
X-HE-Meta: U2FsdGVkX19qUvsNAgIDHegd2emP9Al7eQdzLqhsKot0KbvdBrr43wrt44d1NtX8vhcOgSK37vOdzqSgKD1lHx1bF9tABnRPG5cPEG6LYIkmmhoBQiftyXs2kM/yzxUnvPPDSFcIP6EfkUMZ3624E8YQRi+8ApOISsb82BQR4qsSCF9vOU6qpKsvmidDRI725DROQjVjqiVqjI9qG59TtWq6iaeEeOEvDzlk8l7b1M6ii3/F2u5ZlBf4spa+9bcGtRk++ui7fvM588OtY82R6YUUNMxCAHaUkgeMDE8tvVuzkCy7DtldOulaisiDSazifyO/nzj7yYWTY47HkeZebY9A1a7FpoT6WPmXAV33i1Hb3Oe4636Pxv/QiuW3rQ/DiRvdHsOeKdB1Gx++PGoTosQ6qvPcixZm8WICiV7tIibdRI6zLSodXUoixjfryyWkATRVYpICQaOhtq1uBU/v3oAKvfBbd/Ab5copYN8sgSlfF109Gb4W2i2VNGf4++9p6dFUhPncLCFHIeJih5l0CsEe9Iz3IGbWvHwN8B3PQncSZya1C/WBwdarxYe+P3CE+EkA5UFPuqL+YdfJSwX0XGXD0kxeZEbyDX8Re0BROHpjzQ7jrDJ32o+6nzki6hu/p9yqK9nTTg9y4qb6oQQ4lH2/AjPrMw1wSeRQjNftyy6MOzIn06HF3Lwwy00ckpI0m1ULQxDhFriHLUsy/EFnU+4I+L7Qd6co972yEC/6Rkv+B0oU2rTcrgIEXSSJYN3newG/+urWBZIdnMp8SaBpJRsH9D/zVseoqkMyWgZoQWbIA9/B4qEHgmkGdf7X5vOZTwTFFmS/PZTSKnQucXDV9HWATqDSHgI/OaNDkWqboyo4nqR58kiPSaACYYXtLxet9YNJ0ShdgrjWS0GYQpqDi3cZ2QJ3GtP4xpqb84G3dL43hANhGWGZIpBOkyjsanu5xLbf87mtbvkDs2rlm7G
 yAE/cCi1
 6jDe2Y4YQONKDnxPCdl0gRxzpJpm/nFpzB+h3A9WpZKrokTFj5rlQlA9so5rAQfmpinoXuGXM7t1vf0c+jvI9H0O44I6JB6d4fNDfzC0wWgmz45UW64SvJDPyGDmwiy3UoCqm9cWIL0uCt1HQVvD1vC9HdJwc4kxtD/ZVGkQb14gqQCo6XVtrldZZxJvzANpsJMjEGxds7gexwl2S5xIK1VJDvS2QlpeoWed5qahLcY+W2UwEJetL/ndQMyGgnwhpoxIQXPw+FnME75X3j/9Pn1VXQTpZH8xEc9ole0ldPe4wCBE=
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
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab_common.c | 12 ++++++++++--
 mm/slub.c        | 17 ++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d81cc2136c68..9c2cca9add89 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1628,6 +1628,14 @@ static bool kfree_rcu_sheaf(void *obj)
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
@@ -1638,7 +1646,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
+		return __kfree_rcu_sheaf(s, obj, free_flags);
 
 	return false;
 }
@@ -1987,7 +1995,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (kfree_rcu_sheaf(ptr))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index 92c99ff34a2c..6c81722afb18 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6085,12 +6085,13 @@ static void rcu_free_sheaf(struct rcu_head *head)
  * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
  * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
  * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
- * this problem by bypassing the sheaves layer entirely on PREEMPT_RT.
+ * this problem by passing SLAB_FREE_NOLOCK on PREEMPT_RT.
  *
  * However, lockdep still complains that it is invalid to acquire spinlock_t
  * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
  * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
- * by temporarily raising the wait-type to LD_WAIT_CONFIG.
+ * by temporarily raising the wait-type to LD_WAIT_CONFIG. Skip the lockdep map
+ * on PREEMPT_RT to avoid suppressing valid lockdep warnings.
  */
 static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
 
@@ -6100,10 +6101,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
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
@@ -6202,12 +6203,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
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



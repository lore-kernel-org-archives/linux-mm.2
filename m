Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E01ECD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4CD16B009D; Mon, 15 Jun 2026 07:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6C26B009E; Mon, 15 Jun 2026 07:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C59E6B009F; Mon, 15 Jun 2026 07:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B67B6B009D
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:07:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4085B1C45CF
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:07:03 +0000 (UTC)
X-FDA: 84881869926.20.CFD1780
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9596340012
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:07:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaBD3ZhE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsslpcItYnCr71s4HsvSrZRmdgMuGce17m7B3R3mHoQ=;
	b=Wt4O4eAoqeKVFPNMtkw+YZ3SEWYzksmZ0dPuBRdf2NGPk70RJJ0X/cDUrouq64T5CqvKU1
	sPcsfTPRUGhoKz2B/f2ZIUugkbTg4AJFVH6uTLhqC1coG84SCv2M+2BTc7J3y6UzVLc2nH
	SnzYA3wnNJWQYJPW4durLaBYwWT58Qo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaBD3ZhE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521621;
	b=gwBUIo9yPMXAXrx7+RgNjv7BeHVVI8ZZejx6HsWS6C42gye9hBNqQyxjZWac40arBuSsuX
	S/sbzAjciCxSBOgL7Dgrr7+86MQNaAtFHff2zKAta8fCwBxrvUgJnDDt5WpXCr+BGx2Ddy
	uxN5Nfvt+blxNfz5LFSeils6hRvUq9Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 287C36008A;
	Mon, 15 Jun 2026 11:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63AD1F000E9;
	Mon, 15 Jun 2026 11:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521620;
	bh=UsslpcItYnCr71s4HsvSrZRmdgMuGce17m7B3R3mHoQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iaBD3ZhECsm1/HgsiHdbO7n4c8v5uRscT2sWbFMSF/T7P2GXp+JtLu1fLhD+v5/nX
	 QJuASVY9zKi4tsJf0UpPP6E5Wlsn08EqqN79f/pB+0OPIW7Y0CFo+vL7B5AulrIO5g
	 GW9nLY7cB5lrQrFcVnSDjlLyF9yht8hdgmPiIHYjZFiNM/1gdHUw6b9LsYUgKMyYlu
	 3PD+DUZDtKLcT/4y6cTeiB5yt9zyIgd7zsCwcC9YQYJh88XKli7UFIfpZgtUtIdkLC
	 w6Zn+zC0j1lCjRh3ld2RSrw5IasLHtPv/6Un2sjtrgfhrgaHSPvS6fxE2HUPjPPvM0
	 XWmTv2FuRld9w==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 15 Jun 2026 20:06:00 +0900
Subject: [PATCH for-next v3 6/9] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-kfree_rcu_nolock-v3-6-70a54f3775bb@kernel.org>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
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
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: yruya655eyk4ernkhi9nzqwbagrnotuj
X-Rspamd-Queue-Id: 9596340012
X-HE-Tag: 1781521621-494660
X-HE-Meta: U2FsdGVkX1+RGh81iPXPWrkyPs4+qWXCm++6nA5n4Si1i26iie7Hk5l+n60tdkEXVRMgmIrtiZ7ydmlogwEl0IjFKkV1WQiHy4YjGCCH3sttmtYdrrfc3oRXKZrxzwRVlNKqJ/6LJRm2oHjvHkObE9Rpe4VGRXniHCGQMqR4hq964shWYFX52qy144ILyC5UBvpB8q4csZxctLfGY0nEYpPGXx7ZqjonV8Lc4QHUobMoq2mRBK5kKbPaOqQfNWSSMJOvYpRShc4UicpASfn/SjMZNTPxPJ+xL/WBOjz4/cpeeMAAWqzvXKo5r7LIblXcosiB0jKI7+DTlrhBH8qUrjL2F1NU1bpcpYoXGdUiQImp0KpO0671Pl6+ejs+3Qu8625fIMxC95lDbingzezqSR3vykhpWjd+MMua78CYBGO5W0LvRmwk92ZHlIQPO37k7ZOTOh5aOH5/3qMRnwsyltylmiKh23Ov+yzWE26qJYgmxLvT1pnuF54fY98lJDQxInS6KPIhhg64n50iqU3LobWBrMR+q03fPBj+UUJqTJ/uj6OSC/XgLe5z8SyYcDfxzo1BFg71Bith8VTDTweWKiEQl6XirITerBTDPDYym/nuA82JM0hy5HiWYCKEkVqZ98HEUEhrAY340+YRL8wZNPSIR5Z3gXYCSt9sDVqrUY1RX6kUvgTKbckhUenFulT0Xc6cvIurIPbJREtYscME2zTlqxeguEch0bztgNLMDTUEbg6aMhu5jzfAZmckOIyB2n9gCscC7SovhwwECHytChQYAV2UiUaokQWa1paF3Dk2GRQ0diVqmkbK4AyrxBWai4mq63oGEXcfoi8IcwNzWiJgz16fQXdNQ6YBxfrNk+9GFWGYwU4FFG2PL1AsVRZi4HQ8eG3MIFNMUPu11kyuo7eGZMCC9Sl9HoZ+MKw6+xQNM7vZAgUc4OkaYegxuzO0l/cHyIhgW3/aCTNWTE5
 tVLTosgP
 /Bm/hnkwCu0dfURzeYYAgtB0uZfeLCPF4c6A/XBK6lR450SFtdV5m+v8ESj3GlabS6IN1GbwYAVmgOgYdPxJc7xvG6u9tjdXIEgfwdlT92UYusht5icN2TgXx0W5w8mAuLL+23BzRT9YnCE46uxcFXe2YHmLhyyPdwa9tms0AE3sJxoeBcdCK3QpmUZkswyuOCRlcCMXvPUvGioPXBEmP3/7AOB3TaemM5OHhEKh3XJwmTE2r5MVeQrFo6897k6hUSKpXYu+TCzAk3qM1H1k9reB3vSrgcaJnbPmE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As suggested by Vlastimil Babka, kfree_rcu_sheaf() can be used
on PREEMPT_RT if we always assume spinning is not allowed on PREEMPT_RT.
This is because local_trylock and spinlock_t are safe to use with
trylock variant as long as the kernel does not spin and the context is
not NMI and not hardirq.

Now that __kfree_rcu_sheaf() knows how to handle allow_spin = false,
relax the limitation and try the sheaves path on PREEMPT_RT as well.

Keep the lockdep map on non RT kernels. However, do not use the lockdep
map on PREEMPT_RT to avoid suppressing valid lockdep warnings.

Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab_common.c | 11 +++++++++--
 mm/slub.c        | 17 ++++++++++-------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 55546b8385ff..807924a94fb0 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1595,6 +1595,13 @@ static bool kfree_rcu_sheaf(void *obj)
 {
 	struct kmem_cache *s;
 	struct slab *slab;
+	bool allow_spin;
+
+	/*
+	 * It is not safe to spin on PREEMPT_RT because the kernel might be
+	 * holding a raw spinlock and slab acquires sleeping locks.
+	 */
+	allow_spin = !IS_ENABLED(CONFIG_PREEMPT_RT);
 
 	if (is_vmalloc_addr(obj))
 		return false;
@@ -1605,7 +1612,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj, /* allow_spin = */ true);
+		return __kfree_rcu_sheaf(s, obj, allow_spin);
 
 	return false;
 }
@@ -1954,7 +1961,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+	if (kfree_rcu_sheaf(ptr))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index ba593c1c53d5..4850629774b2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6082,12 +6082,13 @@ static void rcu_free_sheaf(struct rcu_head *head)
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
 
@@ -6096,10 +6097,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
 
-	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
-		return false;
+	VM_WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT) && allow_spin);
 
-	lock_map_acquire_try(&kfree_rcu_sheaf_map);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		lock_map_acquire_try(&kfree_rcu_sheaf_map);
 
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		goto fail;
@@ -6199,12 +6200,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
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



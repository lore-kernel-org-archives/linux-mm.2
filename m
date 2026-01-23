Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D08D625E5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F126B0402; Fri, 23 Jan 2026 01:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FD76B0404; Fri, 23 Jan 2026 01:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DC66B0405; Fri, 23 Jan 2026 01:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0BE26B0402
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B892D2907
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:38 +0000 (UTC)
X-FDA: 84362312916.03.82FF557
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2AB7A40002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r9SDwZF4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+KaEiaxB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zJYEOQ6n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="zu0/l55j";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxNrmkpJY7trZ5HkdIEifD6rdzJ14H6U8LzdlLiW4qU=;
	b=4H9sYGO3dy6BtabotZeSNJ2mex1XveE4n0bNE52vxtrICrY9NKtS4aSy+7SWLrgGTTBAex
	G2y7ZOuiMpE0MFMnoEOp/HDy5gJc43lN07vGirIfLJnhg20bJX67CaWFgJRl9G55S/TMXH
	E3IC3E/CllEcK6OrUxEb2SMdftA1Dcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151216; a=rsa-sha256;
	cv=none;
	b=ctWewQAhuciOTnh1AuzkqFc/lQGEomy1o7miQ0ndHffzJWQUPBjKlStefCR5F21D9CaGzW
	bHFH4SQF2tzLTZffqpbnB1bna+b5iOX3EuBqUNd7fDzZ1WcmKQjFO5tAedCw/sIF/JVs1k
	8oqAvzF9Mgz8p/TKqwmV004q8txkaKw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r9SDwZF4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+KaEiaxB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zJYEOQ6n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="zu0/l55j";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 75F555BCCC;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rxNrmkpJY7trZ5HkdIEifD6rdzJ14H6U8LzdlLiW4qU=;
	b=r9SDwZF4N5TMq/bCCut8xI+Pjln70vZFRv8koGZo5bEWihsI7fKqnL1MAPDEEzPwSmN7l+
	r0iNQ+d0swbjqe8AIVBrKHTklk1F4EUnDddtcPF+8QAgnj5FLLv6jcml2J5A4PKHvv7Sw6
	S1k6LKAOKca87eTdXUcsApg3/OJtd3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rxNrmkpJY7trZ5HkdIEifD6rdzJ14H6U8LzdlLiW4qU=;
	b=+KaEiaxBlb6Kw4QyXdzkq5GJf8zS2+XD4WH4j526MoG897CGza3rE4Sj1WYR+gG6abz9s5
	7yTAn/aqisq1kHBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rxNrmkpJY7trZ5HkdIEifD6rdzJ14H6U8LzdlLiW4qU=;
	b=zJYEOQ6nDd47AnNranBn7tPqVXbIkAhvbd9zVe17RexRVcQTM9EJzs06vFu09j0Q7B/ZXI
	gaPZG/jgBPl6rXhD+uudSyoEghq2zYI0U1v/IUNNXJ1WXK14CzDblR4RUeNtsIx3L8EIsy
	FBl4Jen84LBEIpc2hqptJA/EGg7qGiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rxNrmkpJY7trZ5HkdIEifD6rdzJ14H6U8LzdlLiW4qU=;
	b=zu0/l55j3CmO8XvZQyGq97d8ZgDFfpsrpT8z9vAdJ9GxBwBI137EYW4Um1l167fGHiea9P
	1hXa4iSb9V1zb+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42C03139E9;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qOsGENUac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:40 +0100
Subject: [PATCH v4 02/22] mm/slab: fix false lockdep warning in
 __kfree_rcu_sheaf()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-2-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>, "Paul E. McKenney" <paulmck@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 2AB7A40002
X-Stat-Signature: h5o4fm6nencas17mf4mdnokjpq73ip3h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769151215-294818
X-HE-Meta: U2FsdGVkX19G2ZFvdoGJZH32HzwQMVFf7AfNqYwiqLBsDXLvuas57yBrgkKRm2Hu3HdEhHsSQ7jEqdtPctXk/QZ0Su/0iRE/HUNMhIFKS/CrwzlAjAJ8MdTul5i+HCXWJ+9L05UTQfvjNmwhkdin3AhVsyVie+rHs4qPrsV+KIntiggY1JPvPbf5WWnwV0LuFk97nLSdUU2ZK7wfFD5aYoWyj8sC3UyOWX5yDmsG3AwOum6+/KDdpmPw7Rb/X9U0XLBh500o8ndhiZopH4PEnX0s3tmmbyq/E8ju+xRZA5DU/YmBBez2v1dL4DXet0RcldkrZq4rOa8e6DF+aM5DAPjj+lh7NEMBpQN+KfYhpCDCL0J37PWp64/ox+Q2qrDbu8Uf85OQG5Pos+IQbtfbJJp5ofXCp0IR7DtT+RNZArdBpEyNPDspT+E94E9Dpe3rSZOhVsg1XPzQoV5GQg8ZW183HYkCdrPMzIrw/teniB4KVyWraBy/UuhpP0PvZlm7qsrF6nOENsUTt9FBkG8jesPFA7zvGe8MKWwnjYLNuOQhDbY5Ur1+80m4SrUeecj5s3CTbv1B9eEXFjDcP+qe6Oq+olquG0LRfjCSCOjSiN/0jx9MDIJHQn+oHfzlPVE5Oj+cYux2y9YE/NW8PsOdUHtwXH8JNwJGr8NjNRGQRoB7K4huPind+cUzxhQMuqsvlqoEMV2B+SRYWGXVB59QSb+1xZQBQIl04Bf3UUX5tV+StGOfefS9amRidITjApbCY9rVNy1KuC3CXTDcciByqAjB0xuF7gXRo93k3wpX5FTJ4dErIMdzgEuBj0zGvXT4z6lb3ZGDBpxtKWVj4eUDESCSF8D+S5rWwlD14dCE2Q6L9XQ7Z3BDK8S5ohBDpEl/GiVmfU6Z2InFORIsgUI0yUlB5pu9yRCZ4CZuWrsQnvQioFaRYEOZjAcDzEYZCfH7lhDz7OzEW2tUeEiyXIw
 cz1A0E30
 qTOxG9hPvpIya1vT+BgWr8kirLBsgYJTstgOfiQYZ6ltS+WPHDXaTFGxDbWaxTXI8NlwQGIFCg+tGXp0wGJkfFIykiC0HvwUHlvr9SZ4TAffEJTPVglp86rWNFwfz8awFEkpVS/FSfYbTcfJh6UwaZeVgIswjEE9FeY3f1XrLYHNvgPMKmUoOC4n8MH1tYUh4Le0CSThpSSpiER2CLcQEMM/03XcxWIv7l+lFFoSvGJDYeoXV+h7cBtQtwYBCH0KEVXvnrwA7aFR27fs+eQnx4JpPO/GrczKZpvpRkTin5S9/SMAUBvuVPESRQH92HU18DSSdZGjCywfvTwFKHgigRyX9RoowUcL6Lyitwd9mXECRKhvk+PAF3KY2ON14Zn/DXP0JWwrfyZp/LuQDSXW6B0tfCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Harry Yoo <harry.yoo@oracle.com>

kvfree_call_rcu() can be called while holding a raw_spinlock_t.
Since __kfree_rcu_sheaf() may acquire a spinlock_t (which becomes a
sleeping lock on PREEMPT_RT) and violate lock nesting rules,
kvfree_call_rcu() bypasses the sheaves layer entirely on PREEMPT_RT.

However, lockdep still complains about acquiring spinlock_t while holding
raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a spinning lock.
This causes a false lockdep warning [1]:

 =============================
 [ BUG: Invalid wait context ]
 6.19.0-rc6-next-20260120 #21508 Not tainted
 -----------------------------
 migration/1/23 is trying to lock:
 ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
 other info that might help us debug this:
 context-{5:5}
 3 locks held by migration/1/23:
  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
 stack backtrace:
 CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
 Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
 Call Trace:
  <TASK>
  __dump_stack+0x22/0x30
  dump_stack_lvl+0x60/0x80
  dump_stack+0x19/0x24
  __lock_acquire+0xd3a/0x28e0
  ? __lock_acquire+0x5a9/0x28e0
  ? __lock_acquire+0x5a9/0x28e0
  ? barn_get_empty_sheaf+0x1d/0xb0
  lock_acquire+0xc3/0x270
  ? barn_get_empty_sheaf+0x1d/0xb0
  ? __kfree_rcu_sheaf+0x52/0x3d0
  _raw_spin_lock_irqsave+0x47/0x70
  ? barn_get_empty_sheaf+0x1d/0xb0
  barn_get_empty_sheaf+0x1d/0xb0
  ? __kfree_rcu_sheaf+0x52/0x3d0
  __kfree_rcu_sheaf+0x19f/0x3d0
  kvfree_call_rcu+0xaf/0x390
  set_cpus_allowed_force+0xc8/0xf0
  [...]
  </TASK>

This wasn't triggered until sheaves were enabled for all slab caches,
since kfree_rcu() wasn't being called with a raw spinlock held for
caches with sheaves (vma, maple node).

As suggested by Vlastimil Babka, fix this by using a lockdep map with
LD_WAIT_CONFIG wait type to tell lockdep that acquiring spinlock_t is valid
in this case, as those spinlocks won't be used on PREEMPT_RT.

Note that kfree_rcu_sheaf_map should be acquired using _try() variant,
otherwise the acquisition of the lockdep map itself will trigger an invalid
wait context warning.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Closes: https://lore.kernel.org/linux-mm/c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop [1]
Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index df71c156d13c..4eb60e99abd7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6268,11 +6268,26 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	free_empty_sheaf(s, sheaf);
 }
 
+/*
+ * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
+ * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
+ * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
+ * this problem by bypassing the sheaves layer entirely on PREEMPT_RT.
+ *
+ * However, lockdep still complains that it is invalid to acquire spinlock_t
+ * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
+ * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
+ * by temporarily raising the wait-type to LD_WAIT_CONFIG.
+ */
+static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
+
 bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
 
+	lock_map_acquire_try(&kfree_rcu_sheaf_map);
+
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		goto fail;
 
@@ -6349,10 +6364,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	local_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
+	lock_map_release(&kfree_rcu_sheaf_map);
 	return true;
 
 fail:
 	stat(s, FREE_RCU_SHEAF_FAIL);
+	lock_map_release(&kfree_rcu_sheaf_map);
 	return false;
 }
 

-- 
2.52.0



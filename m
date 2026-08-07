Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEF9C5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 13:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399526B0099; Fri,  7 Aug 2026 09:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36FE66B009B; Fri,  7 Aug 2026 09:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADA16B009D; Fri,  7 Aug 2026 09:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F33846B0099
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:51:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C54914038D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:51:14 +0000 (UTC)
X-FDA: 85074610068.03.5E424B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD25E40015
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:51:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PXYh6M2K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786110672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsBlNoLXapzvhaOZfFVgJmB3wffwQ8ZUd0cI3plKWLk=;
	b=WQzaqu7yTtOtKlWzBgzPzltjzH0ICeVm7++DeLRUrAMHsNDDkrt7n+I/m8IUgRDwcENUHF
	AD2NTkS6KEi/P22msvvcw+t6YNpuprmNHKohNcnmMLwlE7x9IkY54dEqaPDDWhfwOUKJFn
	nrWxEImYVlVUdc75h6E7AmsaqPLp5Ck=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PXYh6M2K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786110672;
	b=t0m1KmbuNASQNYk7dT6zuEbIKGKMJx4LZswsPKf9aJhC1AqzFXTE/E28FbsXOc9kUN2TgE
	6bVQqTHMy2VMj5iiKi2/JptKsbJZqr6Scw9deqAH5zkQ4Jy/Klie1CtRX1bVKYOtqtqO3K
	CZAkQk1a1RZM+3gLO9akN1w3b23FI8A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F20A043E71;
	Fri,  7 Aug 2026 13:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D01C1F00A3D;
	Fri,  7 Aug 2026 13:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110671;
	bh=JsBlNoLXapzvhaOZfFVgJmB3wffwQ8ZUd0cI3plKWLk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PXYh6M2KkgQHGOcPs4VHfkvwxJyfSKuED6zAeHwMz8mmUUgtOHTbSiQM5BJieAoLO
	 H/WV7XvvSbkldcw2ezKoX6DKUZtAcjDvgjCWVLh1TbnJnQlGY+u4pRC+AIJ1cr/4s+
	 JByHYpe+ebHxFnreqVNPxaZ5n/PFOCKp9FCVEt1gVdNWAjj4teAKaCf/xFOIYta2uQ
	 234zl/9rw3uirz1ArxlCvIIddHjOso0Sf2s3/7xSRv4/CUeZyw0WEXcN1ojHc4WL4H
	 w3jDfaKIq5AcnXo1qggs2ROLMdMYAzKmTRqpoIncaxXUWYTKO89frDEQNSedcwHZs4
	 lxnBzFqghs4Ig==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 07 Aug 2026 15:50:31 +0200
Subject: [PATCH RFC 5/5] sched: use kfree_nolock() instead of kfree_rcu()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-kfree_nolock_kmalloc-v1-5-ba993cbf7a60@kernel.org>
References: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
In-Reply-To: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
To: Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, bpf@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Dmitry Vyukov <dvyukov@google.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 kasan-dev@googlegroups.com, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
 Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: m3rsup1n154nc57hx6wohiewaephaj7u
X-Rspamd-Queue-Id: BD25E40015
X-HE-Tag: 1786110672-483662
X-HE-Meta: U2FsdGVkX18b8/RR1lXoompe1YeAxOokaG8LK0Q2jpz5Ht9PWKhcxIh/u7QmVonb4/55e9uFAJDB+62aS9rNE4guwpN2MNTsel4tENU2WptT0MpsADxey6n3nC/z9cqTpZk5C6lizPIRGaWkYIHfs163ovKcSsKAvBoFLPZrleh/2EEeT+4CG2bRYi8wlP/N2YofiPtmUUkffzoT43/DxexJeHidRkWsZStP4uDajZIOVxzld0wiwUkP0pVusV8dWDL2l8t3+q2mqMBVZqNt877Ar7Y0MwQH1LTyDlo2UQ64cu3nZAfLdU1SLARdQzgrS8eRrGx/T/b7q9qeHTZQug+bZOXddB5grQ0qhbrjw16ChFTvF/L/fhu19zSg3Tg61VtgcDVPZe7PA5Nj1Hu2yg/yvS4kynmrrPJFV6+WJCTETDMxE6Rkc38BCCnA/jjnlclUYtjtyBYNNgFqmAZRZ3ZsYjkEtnhz45yAGtiy7TKFx7eeU+30o7CaINvShKhXf0vPszjTBJaOocyS0581xzNiyI66l+syJv67gWEn05Y15eL6DvMUV5hHQULxcPiM/MrwcdmXyVY7FryP9yddyHZGrV9fEKInmq6RVxKdjykGtZxj/8fu/D1FVTM95UQSrveyFZvM8P3gS+b7i26WoxSekjLi6eksAh6bcEbwt//xvzCexkjxtPdgFKNs1ouTfrxfAK+gQOljYyjaDM/nN8GcEUKoLS2F2dMNaFW/DcFU+CIVt8vKj+DSLrxkFpkiHL7Y21T7+cANWEtLjoK543CNp8V72qdp8/WRFDFjTcVNjiKU/9Xk018g63x8IweLVoiMM+Punpw8ZvRjDOenhP7zs2Xm/1vk0gC2b3iez4MOpZ0uWJSDxC8vBsiJJn5a0Pgve7mtZ8XZv+/VAXXC3sV5OvOmfZSImI1AJ6NPh7hYZiOFEFrFx5fJ6LmcrTsShSytZQojUpdkiywnELO
 AOVWbZAp
 Hw0Gq+lbHvrYUFeB2FJvn8B3M+dWjG4fmLPCCcCwRiRW/h2JbwAJP1oqbRSUtOMwW83l7W4x2Ujr9aMQtMcOLr4KfcHExHCWYvbC2v7S8OU8miezQOqA55oMcMJ8ZQFoxtbl1ESyh1+zNLlFry2Wd1JBrTVTRjCiGve/pL5Okp1CYj+m70F1rE2goMJHnxTcRtJAWlAOix0ZahvTol4n3pkv1Eo5eCfCDe8Xp7OjKeMBMvCco3RqM049xIa1QEUqOLSmfdlgDc0X0oyeLhx+cEKr7ZIyMlvoxJBfr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In set_cpus_allowed_force() we use kfree_rcu() because kfree() is unsafe
under p->pi_lock.

With kfree_nolock() now being able to free arbitrary kmalloc() objects,
we can switch to kfree_nolock() and avoid the unnecessary rcu grace
period delay. Only in some cases the freeing might be deferred to
irq_work().

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 kernel/sched/core.c  | 9 ++-------
 kernel/sched/sched.h | 7 +------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96226707c2f6..d2929e4e23f1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2807,20 +2807,15 @@ void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *new_mas
 		.user_mask = NULL,
 		.flags     = SCA_USER,	/* clear the user requested mask */
 	};
-	union cpumask_rcuhead {
-		cpumask_t cpumask;
-		struct rcu_head rcu;
-	};
 
 	scoped_guard (__task_rq_lock, p)
 		do_set_cpus_allowed(p, &ac);
 
 	/*
 	 * Because this is called with p->pi_lock held, it is not possible
-	 * to use kfree() here (when PREEMPT_RT=y), therefore punt to using
-	 * kfree_rcu().
+	 * to use kfree() here (when PREEMPT_RT=y), thus use kfree_nolock()
 	 */
-	kfree_rcu((union cpumask_rcuhead *)ac.user_mask, rcu);
+	kfree_nolock(ac.user_mask);
 }
 
 int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 56acf502ba26..6a8d0578e963 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2886,12 +2886,7 @@ static inline bool task_allowed_on_cpu(struct task_struct *p, int cpu)
 
 static inline cpumask_t *alloc_user_cpus_ptr(int node)
 {
-	/*
-	 * See set_cpus_allowed_force() above for the rcu_head usage.
-	 */
-	int size = max_t(int, cpumask_size(), sizeof(struct rcu_head));
-
-	return kmalloc_node(size, GFP_KERNEL, node);
+	return kmalloc_node(cpumask_size(), GFP_KERNEL, node);
 }
 
 static inline struct task_struct *get_push_task(struct rq *rq)

-- 
2.55.0



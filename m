Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EB9CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C74E8E0025; Wed,  5 Nov 2025 16:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599028E0002; Wed,  5 Nov 2025 16:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE698E0025; Wed,  5 Nov 2025 16:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 399AF8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:06:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08C7A12C55D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:51 +0000 (UTC)
X-FDA: 84077787822.10.BD36B2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 489A740010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OLduUcG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376809; a=rsa-sha256;
	cv=none;
	b=ZxFf3G6KClMxe/Mio0YTvTzJfBSs3KOYBSgnAwPf1PAuNKfvlQtyfYeeHnITMMf2SzjXwp
	dhLetiRhvS54MlPul+NWwAIdaQNl+H/T1JandY9jVKRo31MOhPbBW6G8nEhDvjU1+BA4ow
	GLTXHB+AWK5su2fibWC+3ttYAcET6Uo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OLduUcG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+NjrrV9QIgonnxSfd7xcOESf1q0iJqHuWSGOcEGEYc=;
	b=tMJ9KyCrztL9aAT0qFMX8UsK//jTHNT0M4pa6i/tASDs2IIbniUn46NPFPficdTZX1YBoZ
	Js3wGLl0hZeaqiYXmoLuoQputbDo1XzkKaspYOT/5ePK4MRD2Teyod02YPG2evzQEg1LUh
	La6xbQynFuH2rFqd9GM3r6JkxWqQ0Us=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4955B409E3;
	Wed,  5 Nov 2025 21:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D176C116B1;
	Wed,  5 Nov 2025 21:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376808;
	bh=msWuzDTcgxqxV1VfqrsWjNwgWbBhxXt72Fo9MOZeVHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLduUcG/WX3sS+65TZ/jB9oleAmH7o+Ij6zm6G7vJRQPWAWn/kHN6E9NbiVBTETTK
	 /tSXg4kSg8acavMwtkMnD5cCSx1kzBA38/REmggw6d/dhe6YWgbA/cArl5URBF/xtS
	 g/5opQo0PL9RHjMmGs4LFg9IMBxDNjJsHV8PMg+doyGddTGf1j7R9RdBGuAap2AqwO
	 +X//Jgt6py+or3LRMvYCSO3DJr68NLAU5ynEv1K/hyNIgEWMRTuGBrgurdbL8p52vW
	 id04tI9qFZLhzJmCp7mudgZziC2RzYyNovODMsflC8Jdl6yqEsILrkfkUBWUyRVtKj
	 ZAphLjB/PodZQ==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 21/31] kthread: Refine naming of affinity related fields
Date: Wed,  5 Nov 2025 22:03:37 +0100
Message-ID: <20251105210348.35256-22-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 489A740010
X-Stat-Signature: 4s9x5u5gmreewdmr1rq795n5jqgus49r
X-HE-Tag: 1762376809-462228
X-HE-Meta: U2FsdGVkX1+IdQFQYTQnSMIIF5A05mz1WpZOPQcH4HbbMLiilydetUk7Kp+Rnj51TGLT5wU9EkvU7DUQNY7MnvNVFy4zAwg9O6naxcchFfyJCR/Na0pWO2ZN846SSmEOf0sLdRJj11hcK8OaW2+J2SH4ItPW1cJwoQKYhITtq7SqAnyll5rjuwnFFuHr+rektbS/9YyhKtCcZ/HLpKx5hu8sH5wy1mS77ay6uv7DLQ0qflSQ1IzKDH5u9SnvGlXuD5epiZuwb9ohJox3PlIXKciE53iLLHqQ1fPqen/eHjaCsbYtwye+LsqzxzXdcbkhsFUTPUM0lRJUmTRrgj+0G0RrdZDv0c3MMDRBEZtrm3Y1g7tm9ZCG3ruPKV4XyduxTW99Yx06WPwh16aZ5rNttynzpy8Vda+K1vAc2c6sJTCoslCALUeB8j9eFjBi9TNFjPsCtFybhPi1HGSiSp5wWHLIa+bxVUC+bklbNKOBXVojDxOP9V+V8IWoszJn/jnqiL82L0kF+VQVln99PFHlOrf1KgMlB3KeDNGbY3aL9f6C5YBIxAQM3SKOajqIa+Wj98QN/gaJwXg9vAtfEpEx2mg3PA4R2yM9HN/oTuUBaTFCX9pCDXY5c9hYOU8bbvzSNTEYOQZYLel/So5nRInRio+K4Ob5j2URi04Mrn6rkWr2YP9HTB8rMIPS46begFrfqzOfswkCJMmBEuV4FA2w4cPU+kI38zFjEjU/K1eFMPsKAVsmn1dvxX2WFMgcKR3omfn3MCNl6kPipxR+l4tXXWAN2uDbgIn2rTlOr4YkoxE9xYOaZgba4e2Jk5N3LBa3y1dUzweJ5Y0uPtm/mfXO4731mqrEAAl7Vk/NDpWdz+OGEasMfMjQn2s33khcQK5pSOlTBmxgo4K3okkpJZqkP3bjNqcpWM8iKjXAvtS6eeU4CbJ9e93kdrWVzYSBRKbFJGdWj3fSGI+naT4CXQV
 5op78T5L
 V56kNNFRt8N5LQ406dcPPiAyGS2QzFkgBCjeHoBacZnOPE+ytrVwwDPpW6mlSHQ5p2xsJ8MKgINChg56G/avThNk+4UNKhna9abm+NbtIud2aGSb3IOue67iujVjuRPRr+6PQu3nKqKF/ethJBu59nQKvd3fMz4D4EdFoSVR43bJ4yTK2B8zFLe2gcuKsDFRSLQdwoeZchKupJ75KYxRO/nh4MW4vQJ+lAAK+Qmt8TdVoj5Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kthreads preferred affinity related fields use "hotplug" as the base
of their naming because the affinity management was initially deemed to
deal with CPU hotplug.

The scope of this role is going to broaden now and also deal with
cpuset isolated partition updates.

Switch the naming accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 31b072e8d427..c4dd967e9e9c 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -35,8 +35,8 @@ static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
 
-static LIST_HEAD(kthreads_hotplug);
-static DEFINE_MUTEX(kthreads_hotplug_lock);
+static LIST_HEAD(kthread_affinity_list);
+static DEFINE_MUTEX(kthread_affinity_lock);
 
 struct kthread_create_info
 {
@@ -69,7 +69,7 @@ struct kthread {
 	/* To store the full name if task comm is truncated. */
 	char *full_name;
 	struct task_struct *task;
-	struct list_head hotplug_node;
+	struct list_head affinity_node;
 	struct cpumask *preferred_affinity;
 };
 
@@ -128,7 +128,7 @@ bool set_kthread_struct(struct task_struct *p)
 
 	init_completion(&kthread->exited);
 	init_completion(&kthread->parked);
-	INIT_LIST_HEAD(&kthread->hotplug_node);
+	INIT_LIST_HEAD(&kthread->affinity_node);
 	p->vfork_done = &kthread->exited;
 
 	kthread->task = p;
@@ -323,10 +323,10 @@ void __noreturn kthread_exit(long result)
 {
 	struct kthread *kthread = to_kthread(current);
 	kthread->result = result;
-	if (!list_empty(&kthread->hotplug_node)) {
-		mutex_lock(&kthreads_hotplug_lock);
-		list_del(&kthread->hotplug_node);
-		mutex_unlock(&kthreads_hotplug_lock);
+	if (!list_empty(&kthread->affinity_node)) {
+		mutex_lock(&kthread_affinity_lock);
+		list_del(&kthread->affinity_node);
+		mutex_unlock(&kthread_affinity_lock);
 
 		if (kthread->preferred_affinity) {
 			kfree(kthread->preferred_affinity);
@@ -390,9 +390,9 @@ static void kthread_affine_node(void)
 			return;
 		}
 
-		mutex_lock(&kthreads_hotplug_lock);
-		WARN_ON_ONCE(!list_empty(&kthread->hotplug_node));
-		list_add_tail(&kthread->hotplug_node, &kthreads_hotplug);
+		mutex_lock(&kthread_affinity_lock);
+		WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
+		list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
 		/*
 		 * The node cpumask is racy when read from kthread() but:
 		 * - a racing CPU going down will either fail on the subsequent
@@ -402,7 +402,7 @@ static void kthread_affine_node(void)
 		 */
 		kthread_fetch_affinity(kthread, affinity);
 		set_cpus_allowed_ptr(current, affinity);
-		mutex_unlock(&kthreads_hotplug_lock);
+		mutex_unlock(&kthread_affinity_lock);
 
 		free_cpumask_var(affinity);
 	}
@@ -876,10 +876,10 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 		goto out;
 	}
 
-	mutex_lock(&kthreads_hotplug_lock);
+	mutex_lock(&kthread_affinity_lock);
 	cpumask_copy(kthread->preferred_affinity, mask);
-	WARN_ON_ONCE(!list_empty(&kthread->hotplug_node));
-	list_add_tail(&kthread->hotplug_node, &kthreads_hotplug);
+	WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
+	list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
 	kthread_fetch_affinity(kthread, affinity);
 
 	/* It's safe because the task is inactive. */
@@ -887,7 +887,7 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 	do_set_cpus_allowed(p, affinity);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
-	mutex_unlock(&kthreads_hotplug_lock);
+	mutex_unlock(&kthread_affinity_lock);
 out:
 	free_cpumask_var(affinity);
 
@@ -908,9 +908,9 @@ static int kthreads_online_cpu(unsigned int cpu)
 	struct kthread *k;
 	int ret;
 
-	guard(mutex)(&kthreads_hotplug_lock);
+	guard(mutex)(&kthread_affinity_lock);
 
-	if (list_empty(&kthreads_hotplug))
+	if (list_empty(&kthread_affinity_list))
 		return 0;
 
 	if (!zalloc_cpumask_var(&affinity, GFP_KERNEL))
@@ -918,7 +918,7 @@ static int kthreads_online_cpu(unsigned int cpu)
 
 	ret = 0;
 
-	list_for_each_entry(k, &kthreads_hotplug, hotplug_node) {
+	list_for_each_entry(k, &kthread_affinity_list, affinity_node) {
 		if (WARN_ON_ONCE((k->task->flags & PF_NO_SETAFFINITY) ||
 				 kthread_is_per_cpu(k->task))) {
 			ret = -EINVAL;
-- 
2.51.0



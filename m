Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5635CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8368E0080; Mon, 13 Oct 2025 16:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A01F8E0036; Mon, 13 Oct 2025 16:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B59D8E0080; Mon, 13 Oct 2025 16:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A89C8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:34:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D09CFC0621
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:43 +0000 (UTC)
X-FDA: 83994244446.27.4996E23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 45B401A0010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ejb7EmjW;
	spf=pass (imf19.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+NjrrV9QIgonnxSfd7xcOESf1q0iJqHuWSGOcEGEYc=;
	b=mdKP3f4+HbPZeQALrlJCoUAA3dV2cKqw2yDRuaVkRY+EECBv7eBVZvtPriEkev+BnY+Go+
	CkZwhmgyuhnMoAbSg8FoVP5Zi8IFvpisvcAKLDH4NK0L7K7vjjoISbxOwaxz3HfMpIdUju
	mrikYbVl+11wUtqyiQaZ6waafYkHKEE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ejb7EmjW;
	spf=pass (imf19.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387682; a=rsa-sha256;
	cv=none;
	b=zW6Y4+NNQGe4sLc3NSrpP82Sa+LnLwr4Gx9IAW+AF6TxO9sXPZ2uK/pJUpHhxExeLBvVF5
	gPhyQgNhnqtUwaCHoefiXgsZqK+Szor0gCoCrEFOpMWAEV7i+NxHT+fgJYH+IwSEsnQrNF
	rbMhKfyA1kylfrQk3IxgesjZF4kxvXY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A461D61E2C;
	Mon, 13 Oct 2025 20:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D25C4CEE7;
	Mon, 13 Oct 2025 20:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387681;
	bh=msWuzDTcgxqxV1VfqrsWjNwgWbBhxXt72Fo9MOZeVHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ejb7EmjW60Ovs/XZMXDNlexB1TBkJC1NIZOifmttyCqAFrLEHc+rff2DpF0pNHC+t
	 uS2nUZak9II+I1xBV721AQ2QkHZR5Gc6o5EBV5nUFJJE50EYkieGZqpfJhoiUc164r
	 +MLyVJUa/siG1wA4p7oQT18VX+/6UKzzi9SjsEGj0s5bsLKUbdf/cJF6aASX9pz6tB
	 mbZ7PXlI/+h36+eu+CgQhOOUMJwHUySMhTrIng0O3uu7uwy4sQLLU4CouTLjHkr04j
	 TvSovq8K7SWrJs/sTKFvibEGVXoGkC/lH+hW9IQTLmAO0zvB0h+Xga2j7roJwJJDgj
	 6Z72GGXtL+IkA==
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
Subject: [PATCH 21/33] kthread: Refine naming of affinity related fields
Date: Mon, 13 Oct 2025 22:31:34 +0200
Message-ID: <20251013203146.10162-22-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u333msx9bw74qyfh4jb66rhzimira6rb
X-Rspamd-Queue-Id: 45B401A0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760387682-826445
X-HE-Meta: U2FsdGVkX19HWwykSpWQOMWRFpgvyY/VhECfSvG+mN2QjDNu+R1kxBCmBjp99y/809irTXc7WRPndJ6DSZDkLVQ/5WZEKTRoDZTLcqmK+OsgyrYyjmZYkyfMijUjwfCUEaI6CGKC6VfpwW2N16CvHEtLV73t12/9otFJ0hjYn2EQz1X9//hpbDi+rFYX2G3cb+rW+O6BpqZ28tq7YAKjUAyDQ9jH2wpqn/r/zcXoTxy+3NZJ3d81hEggG0+yLGJmCc+hnnfx3EoOpJMKFEnKUncepGqZbfD7sGyx6DiJLWFMTibeZZwMf79gHOOcxknIxTLpQMnmntGmDWQYEsqaiatbf4z6faVP1ESuKltifXVBuq7Jwwk7wnDahz6qBJ9H6mW173W3czBnw3b1jB8YRTsVHd42+2DQwn9FO0PXMz2xck4hvgbfg4oEvDM0S7/Q/q6JqNebb9nSWFDAE+A6RrtCfRwqscNp8t8wwJQCN/1d365srOVXuwSCx8zntVUAlZ03Mcsb+MyXVTAjNURLNKrtegjKffYjwldD7NqWODRR3ARZnrTmpxCh6Gq6XdGy9pBa+K7JueCrgekw8ZqDtUIHqY2imUgeyBDRHjtmSW0Lw+Uq8b2jwTfDtYB36m/IrYZ598XTVCWt2yUmmn/wXVJ7DjtKa2Etsd77+MJsDNy0Ye+5G40Xqpt4N9MZirHt4FN7XuzSUHMKYzMJnX9HsL25wekreelJXuyt+Ve3EWZiSkdvlZeX+t3rJBhWhDCMmzhrRQbNBOOBDw6GNGjfXcsyWv5yf+2v4RUMUlRiHEWz9GbBae1p/xYZRdcqlPFvZ7fwT8YUJ4uU3LlQ219aIxvFDiZzdou9IMl7W+8vAQcT6ECJhqp9Zjq+ODTXCe3vN8EYXbz7SoLnBnjqiSKb4GbdJbkEc1bnK0pAnOQMiOa6491y+Qs6RrpS+aGTaVZpztzzTOnm3wRkMaFsAbQ
 qUplkc5V
 ikkjwfSV6MikuUwtJlc0AFZmkoLtB2ujwE76NElYBMUIEexeCBFy71YvV3k6iBtp/AW6HyVsNxpkzDIkDmTlMBDXsqjC0A9EzzaZVghhOtKPyAporMTNR5kT/lURtZfyyTg9FGHPmt3Qr5IqpWmHFO0MJo1ZK9QTV0vYRNgknIaaUFCddssFpICBqpY7HyRI81kMt3ibQe4evzPOf3I92p3ZY7EJdeRrdw6Gb2p1MalOREM4=
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



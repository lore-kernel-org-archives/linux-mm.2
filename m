Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E9CD7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1E26B00BE; Sun, 25 Jan 2026 17:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D416B00C0; Sun, 25 Jan 2026 17:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772186B00C1; Sun, 25 Jan 2026 17:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 634216B00BE
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:49:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F063C2060
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:10 +0000 (UTC)
X-FDA: 84371978460.24.F503D2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 77384140007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cQouXDHb;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ta9Qma4wwycxicKBPaHTDueDxthkRH6/qUe89KkYso=;
	b=E7QqsmWMagARoy6Sv4BdW0FPrv+SNAuKRuqCPxpBxI1aOwW8oaLYO7G/n23yz9w3+Rb/Fq
	xdDjdEPd0JLVIPv2AOtr3MnY9zv0TwS++SK16ttkeM/DXmVqgZ/AwkWQ/6aUXfRW3+fVSV
	7MImRVTLassZeQNAKjlixa52ZM4W+EQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cQouXDHb;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381348; a=rsa-sha256;
	cv=none;
	b=O1hVEnRxhtQXPWNFUVaWlhVcv6inOHAR5ezYSX/2HHBG816W9FNnHUYUGJwn+3jkRvwqcp
	ygYrkcipTVOUKJetkopzGzHoenvvNJfnbE24ELYWCgIczIp9Ea2LnxTmnTVwi32cZCqnKl
	wBMGPNLLY2xuR6u4OS5nfHxoDuWNkz0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EB4841957;
	Sun, 25 Jan 2026 22:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9561C2BC86;
	Sun, 25 Jan 2026 22:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381347;
	bh=9wXcGCZqYAJGFwoghpjYmoH+2WL5WXQJ0azxL3BmHRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQouXDHboX2piB9wKNa/rwB+1F8SE/r3ji8PH2PfYH+Ao9MzAGQkY75UpLFHDMnzX
	 LU3p6BhhfDe5PRwyQs0ilEtyiExo1MxmhHXrWDm1yM1a+rBpQGGWW8IDZ/5WG+ppbJ
	 GUGs13jkP/5BZozejUS8/83/9Q7ctbohhB0rZcTDdkfDQSDBgUwCERxUPpOoySLZmv
	 dQZzqTBKEAiaC9Aoew9VslxlGUKZpc/Ikdw/1bVZZ8Yym0cbtFhFh1fm++2z3FKcPy
	 HMGXY6hMpoxGfgGHnh61TDuP3lkTJ84dHJmT6QzFjgotcCPgCnYhnlfh26DqeebYYC
	 aeD0u+uricWXw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
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
Subject: [PATCH 24/33] kthread: Refine naming of affinity related fields
Date: Sun, 25 Jan 2026 23:45:31 +0100
Message-ID: <20260125224541.50226-25-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77384140007
X-Stat-Signature: uph4doh46brry6jdysxy3iyapy4jr3n3
X-Rspam-User: 
X-HE-Tag: 1769381348-829141
X-HE-Meta: U2FsdGVkX19h07v+/ki5C3eq4+2jJWZ04dHw2Ezf//SYRMrDF24nYWwWa5GPowgzsR2lfRpPi1lsj5rYpj4FxbFcMCKNmeJgKvt4E9Po/1wab8iP0gPjvYIOUneyZpYUIMuZl7kYgiDkWMHUZgag+62TvZZ62+7zTmF44WNJ5OQ0IedEqIySH283ztzpdlLhJvLK4z66Ofy+bynUG/jKR3asKtHhuXo+ViPXU14KhS33pINVD+Tx2jsOXL04pkxwiHPWliS49yUIMLr8qk/yQ/nM0PuV6/KWL6sc1xL592DmwybomVUhHvFUJWcKYf7l+1KZRG4ZyWOlF09E3uH0hmNW2SiZwxTzQxSpJx7CeYPjbK/U6Q3YEzySUE219ssXtddF6SitvPdBtc2WkVyl8+VvGKrK0VhtqI5MakstJl4jggDcET17czIdSvxWM4i3k1GbLawpMH5Oi4BVMiOssQvdKZ+ji5oxr8ThGG2TRcEfggHZFTS4NNa0cMhvP3zkPZbC+Isrg8W7xwbExPFNubjUq/A6IkfDP3a7z2nGb1ENGGyCV8LFyPrr+9Wvvk8PfChO3tMCfQsn6bspNv2fmaFVEjFQbE2MfSOpz0OOZyYNk9W+UHO8eVIPKLsuBDYy9zmCjXGp4PzpiLNf04F0yjtz+vtnu55ypvdHRPASJ7C0efetdEj/SlYAWFZGZcEZGFezzF2IN30FGOoTQkd4RbbzZl1n/nWWiNxl5/3qN+JvxRHJIxzwbEagIRtKOTfWi3j/0FCWDkjBihd/XuhOmSNuGnxZFthIwRyo68agrBMjvbuzr3CFLeLRGLuaO7/xjYHBSP/Odx1xJ8ai4ptny7vOfiVEl+4VcJqRn8/f/TZeG/VAUnIAYm98FrMaFphoL4ZForu/0exLVCwwhyh1JcdErvY6c5fItifvSE+kU+AN2VZuP6Mt2UAVe728vQrQUsOB1sS6r+fLxWrxYyp
 m/xYPGN9
 eDKEgR2cXVuxnvieLVaaYR4ft21L3/9o1rhIGgKsQ5S8fYWgEa3OCqFv79u4u+Gf/xvxC9XenbUJJrQmYWEfKDINHmiFP7NPLKkmU1406wwHAz8XSgKBv0XTUyBperfPanPPj4nPlcfHEo098sGu4qt1jyggzMKM6fPmxlBJM/GIlUi9KPBjy+QxSN/jPmo4ZX9SkE+nuoFnZ7dpwHzofgfYYrl4u1t/yZHpC
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
Acked-by: Waiman Long <longman@redhat.com>
---
 kernel/kthread.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 99a3808d086f..f1e4f1f35cae 100644
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
@@ -873,16 +873,16 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
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
 
 	scoped_guard (raw_spinlock_irqsave, &p->pi_lock)
 		set_cpus_allowed_force(p, affinity);
 
-	mutex_unlock(&kthreads_hotplug_lock);
+	mutex_unlock(&kthread_affinity_lock);
 out:
 	free_cpumask_var(affinity);
 
@@ -903,9 +903,9 @@ static int kthreads_online_cpu(unsigned int cpu)
 	struct kthread *k;
 	int ret;
 
-	guard(mutex)(&kthreads_hotplug_lock);
+	guard(mutex)(&kthread_affinity_lock);
 
-	if (list_empty(&kthreads_hotplug))
+	if (list_empty(&kthread_affinity_list))
 		return 0;
 
 	if (!zalloc_cpumask_var(&affinity, GFP_KERNEL))
@@ -913,7 +913,7 @@ static int kthreads_online_cpu(unsigned int cpu)
 
 	ret = 0;
 
-	list_for_each_entry(k, &kthreads_hotplug, hotplug_node) {
+	list_for_each_entry(k, &kthread_affinity_list, affinity_node) {
 		if (WARN_ON_ONCE((k->task->flags & PF_NO_SETAFFINITY) ||
 				 kthread_is_per_cpu(k->task))) {
 			ret = -EINVAL;
-- 
2.51.1



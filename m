Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 040F8EEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EDCA6B00BF; Thu,  1 Jan 2026 17:17:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CFBE6B00C1; Thu,  1 Jan 2026 17:17:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBE86B00C2; Thu,  1 Jan 2026 17:17:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C61F6B00BF
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:17:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 064041A176D
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:33 +0000 (UTC)
X-FDA: 84284807586.23.6CA2704
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4559B20002
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9oq21WU;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ta9Qma4wwycxicKBPaHTDueDxthkRH6/qUe89KkYso=;
	b=p0G+l0tTaKfqC3DK5/Cs3xn54hXIC6CxXQfhHAH7IPiujjB3450CtBKQcfxcqgTYzH1Ynh
	UGtRYgU5SPgOoPRcDh4n9Y0mP8r3+Z6ACksyoxdn3Fhy4po+7M9SUYWx88weDEN2lxUYj7
	bNYItUBZfXOfV3/muIeXMbfA6AsXNHA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9oq21WU;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305851; a=rsa-sha256;
	cv=none;
	b=hNz82LqHOSWnIEqPPatAQgRgvkHvgESkNXSho0bES9qked7wCNdAS5GDNRsW+ZefRiA545
	zLE+Qum29DE5lpavp1aEtvMLsl3P15dxISa9ox2bUhdlakIPRQL4ciug+7KF1F2zUdsaPw
	cC9zD7URZ3MZmdQwITJJcJqdGA6Fa2A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 625F44376C;
	Thu,  1 Jan 2026 22:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC3FC116D0;
	Thu,  1 Jan 2026 22:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305850;
	bh=9wXcGCZqYAJGFwoghpjYmoH+2WL5WXQJ0azxL3BmHRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9oq21WUCSC9/OwMtP02aP+LKfuyP4kYwo32TkRpa0R3GEVyItpW2xdt5TsQ8px7w
	 KOYa0zIReJE24qH3uyrQI69LumAM1w2VW5Muq6an21EFetBZwX+ghiR8MGoLll8pZa
	 Grf0QhLyYxz+6c5k0RlzzEvY1FgNVf13Dx8LwwDOAUsBeBeestfbDJ/bcBkfyyk46T
	 B1qvUJ1xauqWykSaNT1jWVtE2ZlOOpKgPYpyqjW2SijootHw/wpYpnEeS0pAVzKwMj
	 Qd/25qKpu/WlwmyRYUyxMwRydQAHhEqa7Oj+MF5/FNfpGrT+4s9srD9geS0nLM5iM1
	 8o6BlmW893OEQ==
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
Date: Thu,  1 Jan 2026 23:13:49 +0100
Message-ID: <20260101221359.22298-25-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4559B20002
X-Stat-Signature: 1gi8nptdqq4sdnxynzhrt7ku88baxsm1
X-HE-Tag: 1767305851-953334
X-HE-Meta: U2FsdGVkX1/zE7YXTPCeDEJeopxlbchZ7PAIORQbxmK0QboY39xc0yy/N4431BcWsAQVWXoo4mqgbi8DpQMvwKZe34dc0zzd8lJeu+QGv19tMoNoHu3q9grSwJmT9xqN87lMRSODBDQBrgJ4TAQpifYnju6wnAfOKxel3jT+vOeNJUYTebMaK+OFcjfnOaqs9xpvvUcL9AG+bqudmr+OfRHGm5Cf2259k+iAamFGZsLmNCt4maqXgq1+AMQS/oWn58KQBvs7Sfav+429NtECkCYctGHFOXJPQbclfXatRjCYyfGKtnrkQF/3AJzRdqLD5uhGuOAKa0YHhGhzKqqL+MH/hQjAkAn7t5bw7u+hz7iWSYpc1phrAWyvfDDG53AaQBj3PdRvbQeuy2tOkoeEOhjPwh7b5O9It2SIXZaUjvpLySrxjLv+EMIDo9A/KkdYFYph71lMkL9Eig4sTH0umiJVx2+vgkGdq8KJ0sH7Z6bfIp9oGae5AGV9Hv2FXDKiZuJ4lAo8CuLzKTT/RM/h7nvq20PklYPmE1o54+W4ZuriPc0tUz07DKRPpdJSy+kgXSppaMUtTlsHxOmOJ8WtAyDTRF9fyPQlMviXMnSCmfdSENgDoYukGSe7wRuDhC7zMw/ZHeJhc4jbASx6wlis6HiDh7mPGg+wHmYme5CFQZuXfRCwGX6YU4/Q4yT0bj8LzHdahjkLUmg/7Q9UuAoB+E5orM6W4wTrIvCwu5Gw1cCAKOmaL1kK5432oUe4Y7TFgy2Njz1pyRkV9vqsKmot9dQKm5c5l32+XyF9RQtUzdTBs3/vVZVx7EykRvPQsrGHn44rs8zKQfxgbuamTYQGoCnG1WsSAB4xIOnSZ09/C6rYHpU+gdV+QC+FF+3+/Qp1bmt8z1fuzKHWtdDTX/0v6jaAygBL2EPy2MP1B0+H4apQfuipYZUJIuFG5KTzWzAyS1rm8I0fP+/x6oVk5B5
 3M7V7jvC
 KS6Eczc8pGqKR8swU9TONleAj4r1wtHowRBGqhTI49V7fXO4f0XPcgLs19WzjkneEjAas5n/0HG/KNSnzvLF+Pb7TI7EhHuTp3NN7fo4twkPeux1v8uSmz0Eke989NgMPBtYF6LMMZ1hTNRogpJUqFGu7Tftevfk7V/p27aS76JpgNT6SHk6ZNsjLmneSmTf4pKu8IVXQFH8tvkLiv5fzENgz8Ta1mPi+LRm5n0HH9taRkkL3DohWMw/3SKpxeKVekm+U
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



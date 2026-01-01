Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928BDEEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016FE6B00CA; Thu,  1 Jan 2026 17:18:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D256B00CC; Thu,  1 Jan 2026 17:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10446B00CD; Thu,  1 Jan 2026 17:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D14806B00CA
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:18:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B69E14158C
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:22 +0000 (UTC)
X-FDA: 84284809644.22.CD18228
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E1CAA140003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lLr6Du+0;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MQWOQFqz/c0rpZHCOwe6Oxj/ZM0gLP5u2oSWOxcIoQ=;
	b=Vdz86cOo0b+oWWiFQ5Llone1xg65XXgUiOoRrgKVUO8bBDg4txnywCu42TFZVunZyuAcFU
	0GNi9KYO57V8D22VTYM2ZZBH7ZgCuMsLkEqnzB6lla6xvCTjqyaLT9Fv0aEFhKzL95Q2SK
	//Bbj8IAZKp/feyyUoB8XMNcnWkWfDM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lLr6Du+0;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305901; a=rsa-sha256;
	cv=none;
	b=mmenG9it2EvVjRmGiE0kL69/wToVTXfQbLEOnTYEUqUQSnhtHANOiIMX2EhuoZiyZ1JjmO
	YJNLtWet4RzHeHQxrsk6ktjeOmUTY9Pvmr0FxRXPucOC2QYl+KZlMgqS+9wy1D5SDg029u
	5qtWXWqfp+1McvR8MIC5ofvEYapjKEA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1171F43708;
	Thu,  1 Jan 2026 22:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B6BC19421;
	Thu,  1 Jan 2026 22:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305899;
	bh=QnBszBWMBdPelj3/EhAAmslkOo78Vo1wD+/ritolIOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLr6Du+01wQ7rIsDvS1hnMGCTOQP6300d3yx50NlnX8+avtAXSlGCdkGmfu3LFiDl
	 azt4pnazHojiE8FIkTc8eQiAtnQlzmCAZpzik2cI9zC74FVSrQKjSbRuK9sp0ycKbW
	 m08MDz87hJAnUGp2fmbKZIT7kYaCL6sSWxwFGJrmTbJEblx45AD5uoLRtBz9DaOO6L
	 GcEwDlnD0V8R9VRbFP3SwmZalMesMJ5z43tF5XfG0mzHUJtS6j90E7KYcvGkmSWTIP
	 VGOmhH6ofE1DWvbSzc8WLhvLuUnsizMZWDW343vyFdt+/nvWsWuH6zDYMNCvyzksnC
	 tO+3TXnOPkOqA==
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
Subject: [PATCH 30/33] kthread: Honour kthreads preferred affinity after cpuset changes
Date: Thu,  1 Jan 2026 23:13:55 +0100
Message-ID: <20260101221359.22298-31-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: w8xdxqsaw6we6r11iwj9k7xbdw31qywz
X-Rspam-User: 
X-Rspamd-Queue-Id: E1CAA140003
X-HE-Tag: 1767305900-678744
X-HE-Meta: U2FsdGVkX182JklbbNwl7w18TmxkMWOQek2JazHE/JFdrwWAulfD9w4Mvy7Qo+QWcB0j70II53BJmkXrM4wC175Tde/y8qmex9da4AFwD2LuVU/HOZP79xynmMfm4/Bf1QRMhCdLaba5YgRFhy4CpsZ/3JlLrBtTKYEy9UnqG8pT623EvIjru4y8vDFOJvyC+kfkeN4sZCo+6/SLC+3nPm9IzqgyPH9zDmscH8T/injoSCnTdtVSf1APM4u36b8aKycOoMasFWZw8xrENCNv4qIGAleTkvLkYAFyJm9S6MC5DYfbAITHiiXL5fbOqp5+Xns32RzNFKompFUxorEw3Y8SVovekFz9rz4ERH/LtTHb3aW3OwtoKodWidXJP7XzFwZqFBJPt4kKpob8eTzN1hXf/8sLtbSg/bhOC75pqDMAT4josO4awjicI0er0kpJnFS/AvSg7NUTvwDhhQiQfWmENCgf1UyE0UFwtamHFh674LGLvnzPQT2mBLXoD7Ufs8+VJnzcLcg3CPz5cc3cuzPRawI2W+ncJQBVi3bx5uyiG+lwbXRRgaZ85F0nWWJKKjbnBEyR+ahJTM09Gd1qZntDIKB87bLyFdp2ElQleWZFzgQaKahMnTDPg2i9MYKdmc1ymhU40RiGNm7q7BcAxo/+FzUyKaAp0uO0E3z62CAFnjoxdpUEuPjYBsH/X2m3+23AT2D0IUrpu01vDEZZHVjCRKc1WREk3GLaKJXkN8bpWXVBFUaprF3bTGiY2pkfVxgPTdNhwU2ZHbMtU1aEWk4FFCxahCBZWei5tHarmoLCMPPOZqEsoalm1LMf3iOujxvYw9LiPoHBUeMmsOGLTvmzSXopArHCE7erUsIbeuqtFA40/3RZGhvhsWXMMw0Z2lYylQA+uUa9FfVwa1Ih6XxhbRc7VWzilz5etLO8VJJJ16PzX8tQKGNfRZpIZHnab2klHiVx1fuvpsh0Pz1
 atYWmXvc
 GhOkbb9m0yTh0HIt/V/5d2vDG0ZZhuCNagrHQe6XInzUEstP10qbvZR5Fi71IlDP6TC4GU+X3ehOF5uwOwX/M3J9/cu39Sj3G8vitAktXOSy79jZF/N3a24NmXUfI4NubcgwTeQkBAlK0n3VM0I9WpFLgSmwvxh+A3AZ5NyqZ0CZkGaaNpFxpqlolY5iLUZq7S3162KJxxha35iTHqTu60Mw7ENBunqza1Jcq1ExwN4UoIO0C4sFrdSunUDLW9FFR2ibcscV4kWz1d7hHN5NUJrX3+P0cD7nt7p5xREzSiX8/ukg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cpuset isolated partitions get updated, unbound kthreads get
indifferently affine to all non isolated CPUs, regardless of their
individual affinity preferences.

For example kswapd is a per-node kthread that prefers to be affine to
the node it refers to. Whenever an isolated partition is created,
updated or deleted, kswapd's node affinity is going to be broken if any
CPU in the related node is not isolated because kswapd will be affine
globally.

Fix this with letting the consolidated kthread managed affinity code do
the affinity update on behalf of cpuset.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 include/linux/kthread.h  |  1 +
 kernel/cgroup/cpuset.c   |  5 ++---
 kernel/kthread.c         | 41 ++++++++++++++++++++++++++++++----------
 kernel/sched/isolation.c |  3 +++
 4 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 8d27403888ce..c92c1149ee6e 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -100,6 +100,7 @@ void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
 void kthread_exit(long result) __noreturn;
 void kthread_complete_and_exit(struct completion *, long) __noreturn;
+int kthreads_update_housekeeping(void);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4c9aa3f80553..3280f457232f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1208,11 +1208,10 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
 		if (top_cs) {
 			/*
+			 * PF_KTHREAD tasks are handled by housekeeping.
 			 * PF_NO_SETAFFINITY tasks are ignored.
-			 * All per cpu kthreads should have PF_NO_SETAFFINITY
-			 * flag set, see kthread_set_per_cpu().
 			 */
-			if (task->flags & PF_NO_SETAFFINITY)
+			if (task->flags & (PF_KTHREAD | PF_NO_SETAFFINITY))
 				continue;
 			cpumask_andnot(new_cpus, possible_mask, subpartitions_cpus);
 		} else {
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 968fa5868d21..03008154249c 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -891,14 +891,7 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 }
 EXPORT_SYMBOL_GPL(kthread_affine_preferred);
 
-/*
- * Re-affine kthreads according to their preferences
- * and the newly online CPU. The CPU down part is handled
- * by select_fallback_rq() which default re-affines to
- * housekeepers from other nodes in case the preferred
- * affinity doesn't apply anymore.
- */
-static int kthreads_online_cpu(unsigned int cpu)
+static int kthreads_update_affinity(bool force)
 {
 	cpumask_var_t affinity;
 	struct kthread *k;
@@ -924,7 +917,8 @@ static int kthreads_online_cpu(unsigned int cpu)
 		/*
 		 * Unbound kthreads without preferred affinity are already affine
 		 * to housekeeping, whether those CPUs are online or not. So no need
-		 * to handle newly online CPUs for them.
+		 * to handle newly online CPUs for them. However housekeeping changes
+		 * have to be applied.
 		 *
 		 * But kthreads with a preferred affinity or node are different:
 		 * if none of their preferred CPUs are online and part of
@@ -932,7 +926,7 @@ static int kthreads_online_cpu(unsigned int cpu)
 		 * But as soon as one of their preferred CPU becomes online, they must
 		 * be affine to them.
 		 */
-		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
+		if (force || k->preferred_affinity || k->node != NUMA_NO_NODE) {
 			kthread_fetch_affinity(k, affinity);
 			set_cpus_allowed_ptr(k->task, affinity);
 		}
@@ -943,6 +937,33 @@ static int kthreads_online_cpu(unsigned int cpu)
 	return ret;
 }
 
+/**
+ * kthreads_update_housekeeping - Update kthreads affinity on cpuset change
+ *
+ * When cpuset changes a partition type to/from "isolated" or updates related
+ * cpumasks, propagate the housekeeping cpumask change to preferred kthreads
+ * affinity.
+ *
+ * Returns 0 if successful, -ENOMEM if temporary mask couldn't
+ * be allocated or -EINVAL in case of internal error.
+ */
+int kthreads_update_housekeeping(void)
+{
+	return kthreads_update_affinity(true);
+}
+
+/*
+ * Re-affine kthreads according to their preferences
+ * and the newly online CPU. The CPU down part is handled
+ * by select_fallback_rq() which default re-affines to
+ * housekeepers from other nodes in case the preferred
+ * affinity doesn't apply anymore.
+ */
+static int kthreads_online_cpu(unsigned int cpu)
+{
+	return kthreads_update_affinity(false);
+}
+
 static int kthreads_init(void)
 {
 	return cpuhp_setup_state(CPUHP_AP_KTHREADS_ONLINE, "kthreads:online",
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 61580023cf9d..d8642eee8d77 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -154,6 +154,9 @@ int housekeeping_update(struct cpumask *isol_mask)
 	err = tmigr_isolated_exclude_cpumask(isol_mask);
 	WARN_ON_ONCE(err < 0);
 
+	err = kthreads_update_housekeeping();
+	WARN_ON_ONCE(err < 0);
+
 	kfree(old);
 
 	return 0;
-- 
2.51.1



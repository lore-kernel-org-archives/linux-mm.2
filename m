Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C05CE7545D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1DFE6B00C6; Wed, 24 Dec 2025 08:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB156B00C7; Wed, 24 Dec 2025 08:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE78C6B00C8; Wed, 24 Dec 2025 08:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE2826B00C6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:49:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77BB613777E
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:51 +0000 (UTC)
X-FDA: 84254497782.30.516EC0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8E77100002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZoygBZyi;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxIt8vNB5blCJp9VDlklSkmQg+C1v1KRRvLOfNr68sE=;
	b=5xwBokg4U5vTbw6EIQtgAJ0HYJYUzzKQbHWshHTqoJTuc5Tacevt/K6KJiSAbt9n+c2KLs
	+rFe9AXIVhdeI6THFVMAQntOWDatVLl1JDVBgL0LDBvXf8W3Cdo0eT7446qkLGddrMLxXT
	Fwopipz2MUaimYiNtfyH6a00o9ZpxCU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZoygBZyi;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584189; a=rsa-sha256;
	cv=none;
	b=fYVUYclTgOlDke+hT6+a/NlQ4710nrnO46vvaGBwp0RLykPP7Z5IPBXfSI+XWv6GvIyFzy
	Rp6G8uVzyT9aW/qNWzXZD5TWkhleu4YD+ileiv3rfv2lLaNrYK9062/rijXR+jBpQtlbTR
	wuCPrqIzDqJZJsMn3+obhtP0s6gq09Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD4E243349;
	Wed, 24 Dec 2025 13:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E46BC19422;
	Wed, 24 Dec 2025 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584188;
	bh=sw6MyS8XqmroWQyDRlNzbTxLt+uSOqs1spT/Rd2OXLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoygBZyiup7dAVNFXwCiyncd7i/UOKYIpP+C5o/jVlTap/VpHzIPQcXn43Umtq2fO
	 g1MF9WdFOXrjDU3wVwKCiYJ0r35o2bxJYkO8WmvOJfn0TEZQXBPf+xoVorkQbTHx8G
	 db5lUG9ISL7mWlfwaFv39ZguHmBpalcjJA+C2nybaklRZpeuTDripT4dQ4xk/Nm/ci
	 CRnIfMoJ9Xf/nmMPgmtUSpqVUBDfeOwyez4+kpW+hf8N38D3wAEHrMoDsXUXEVN9yU
	 vdsRAUf9IS5RlObYhHQjMh7wQiA9Ssg/j/O9ye17VXlui7DgxNb6BmOrj/VajfbVa3
	 0e4P9m1QKOurA==
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
Date: Wed, 24 Dec 2025 14:45:17 +0100
Message-ID: <20251224134520.33231-31-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7krji4x3fr4yy1q6robknwb5zajgosur
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8E77100002
X-HE-Tag: 1766584189-854814
X-HE-Meta: U2FsdGVkX18LdLw3Fvn6tcGxX/VJaX3CYTrbCU6X88objm/+Y5MvPY+leXZWIwWgW32Wq9PreJqZ6AZt/AtF8wp8jHzBetW1iy62GBtEkurLs1skFxxto7v1W2K0cbnPGfBPjupUfmbdEty1E0sl5qLWO/1a5nxOiMOAzqIlXbRItzPlt595AuwOLVjPdyA9L080wydKdcebWr9kh4m/FiFx3rlWCxSXc+a+AaxQXYOmpzaJJqNww0evUEEFaC6Ljwq4634us+ooQjlc+YMlSa1mW9YQWd3G2k6PXeMCCljvF7JEoX3QKjPlK3C56gG/+bmfYckOHNXvsfpsDFPnFzxskclT4tMUiV5aL6Eg1r6KgoGrFxiy3ULtTdA/A2VaJelyzQXeyKq1h86lvXI9hKuw2oN4qtcHNhuuWIzf8YMS7mSKoJixgUDE3nWm9WxuOw8EFewFKFaK+yxL5pQ+0syyU3sxMzwnmS3Cj+ueG+K/+YpcuxxTHZWSOirB4CKSiA2rActmghr6a6fwolyfTmKfJ5c3S33mtYNIrhDFWCymexPP9b3Gx3V/MGBP/RRo1Q+u1nff5shpfZHqEGetBYwoOAzzM/1fAtk93tD5E7HUuyYmuQskg2CwQSTET5UUN4wUI0ONeliLHmytqfcb3X73+WrgMRpJMkiggaU3bAmW/HTVuoxHOe8dxG7CQiLhuJEc8SpTz2jcJBi71oA66kZcnzfj4A/32875cg328I0rfqwJ9LqA9Cxxipg9+MGvt6qfmuPXa13SdL/SM1UrfkRdb+VhCbdeHpgnRKoWOz2nrMr7pNUaAo7iBYFV3aHhOVjfsPqfQfJBG6RSrhEg6SD8IzmKuD6EvISVSWMlG2YPrggwx56SBPJNToUu3DFHpBcAEYAyGouKlupNqx7tau3SMhjwSeNTfUNHjM9QgrcoY2kdVdMsdVMjKrFgAeTHobHtfrpD1wQYB3Mvncr
 24a64QwD
 kaJinCVWZ51xmKAPb4PMFCVxkiMNJHr2hcdxlUqaIIql1NdqkdS+OnXlhYFeMyXiUbgalysAc3eUc+5R1xtldFbP0ATQ87ANmRKRAscMi7HPO7atWRx8qHTN2E0aqp/rqrzlObh2eTr3bbg949iaiyQ8NNroxsfQfd7eadt+hIYC7y3mkqmL/E8BxNL5l7djzw/5Jjt7IBme5ongWssjtzaJtewt1ButiiG3jJpUfL5Y+Q91rnIjoG/0z+DTizJuhb0BqkaIkNx9lTPhQIeSZZqf1/w==
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
index 1cc83a3c25f6..c8cfaf5cd4a1 100644
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
index 84a257d05918..c499474866b8 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -157,6 +157,9 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
 	err = tmigr_isolated_exclude_cpumask(isol_mask);
 	WARN_ON_ONCE(err < 0);
 
+	err = kthreads_update_housekeeping();
+	WARN_ON_ONCE(err < 0);
+
 	kfree(old);
 
 	return err;
-- 
2.51.1



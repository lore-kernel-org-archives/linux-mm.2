Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D34E4D2CE01
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 02:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFFA36B0007; Thu,  4 Dec 2025 21:25:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB03B6B00D5; Thu,  4 Dec 2025 21:25:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6396B00E3; Thu,  4 Dec 2025 21:25:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 880D56B0007
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:25:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DACC4C0422
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:25:05 +0000 (UTC)
X-FDA: 84183824970.11.36154FB
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 08A2918000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:25:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jniu2i4T;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764901504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KAZkzowfBam2M1V24QpnRECZ6TDi4HphjwzU/c/0E4c=;
	b=4U3Aexw4YnHAsKp3Est5uO1+nvIoNhcwj+30Bw6VCLCYE07fOGIfnI8fbOUjmE5i+PjO6M
	JmcACVS/KAZ+CXDJnzGxCww3ExngHLM8lJRh286JJVt0vsH5Xj4xOBWa4Ej5kDZbicmOH2
	KFS4j5UlDrN5BadHtrS0NmnpMvmyU1c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jniu2i4T;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764901504; a=rsa-sha256;
	cv=none;
	b=csLkoGmuDxGC/b17WuK0jDvF0sBC6lP4qr0SA2+iRziW066XO9bN7vu++D27YAOjqoCNFn
	BsW/fIuxPYJcY1gM/mn1g3f5cGacyLVDBQoWfA3tud5LkuYh094LtRgU74i0ieyd0FMm4N
	8D3iD4CjeQYCgjdbdTj75oVFs3UAr9k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764901501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KAZkzowfBam2M1V24QpnRECZ6TDi4HphjwzU/c/0E4c=;
	b=Jniu2i4T5OR3rn521UQaQZq9Mc0MaK4h8AyAbHn1oXSSA8VQjdK7q7Fn0/vyaN5wPc2e+7
	o+J3FIJgjLXm9VbI/krrDQMUybZD4PzFvy3o9gJnLiirYj88wrN2hYgy9cL/84RZBgYsAu
	M9jq+KBisBbUkBz87Zw1g0gutwllHJM=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
Date: Thu,  4 Dec 2025 18:24:37 -0800
Message-ID: <20251205022437.1743547-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 08A2918000D
X-Stat-Signature: mogyug7or1xzcp6korpk83iwucmz4jwd
X-Rspam-User: 
X-HE-Tag: 1764901503-927936
X-HE-Meta: U2FsdGVkX1+kLPepMLkyvHl+GTSoHBrYWaa1rooDivYpLTkxXXKUVFshKjyT6yh20Hjn2VAZKKCl8GZjxW9H0c9otNvwF2km0xKRhNsp98Ts1ZEziIJnRVXgQdjS3yOstF7L/axKJBsdRXgmMvmxnEJrs2dq7PPgolbX5xLQHuul8mswiNmoMb75x41r578xFBLV5IZtrQ01+u252ojd7VJPRLrRi6Oj/ylTjbcs76otkL6wsyDvkUhQ5Gy7MCdAHuwCUkC75p4AknUfqUMsBIqT2ZG1DvUKDxA1JMI84Dh4ZpBu2tpYyK62RGQEb54wc9djaJ8kLE9h6QOIAC8KgiXuzNMAuZYLBmV4wxHC6T0/38IsIKSanEij/qbY4AgwxSYBcCea6VsOkmMd+O6DQy2mdsoxQtqo/lGkpfIEGzlp2SnNtNQP3+neOzZM6OROe4vCe1gBvJgmqttPPCJq1Bry9/YdIPHNZC+usIeLq/RpdZm7yXyeibY6pHTI4nLac7X2uArFs83qgBmcG3Ls/J9fDNrG/ovrNSED5gXVSF2Hb5TPcYA4YnSqkAY/bu/crUfdkBGF13EztJJAyZh+nYHTc89V7ksObQ1zzIS3Z+R7JfccLRtWAntReu6W5gY0Y6BjN8myTJIuErBQ8AgNAmXHn0mErSaLCtp8oV+zmlTVg3WR2eHXZj1lHpVI9KEaM7jWn6i6YCMZwJTpZm3Pi7w8Np33QrIOAPJZyBzXnrFu2MOvVNqJW98vnGizlHqLqL5BckHf9OALXtrTPfLkJ9CS1H5aXgcYZNmZN6fTAdUQfnPjpOk2p4U/54OApqqixLxPLFYQQGpe1uff0Onar7NIvNgYGmoUm6GEtF+piYMG4MYUGX1tJKWU4JreZvYvNyj/rENH5vzokRXDFEbDoFl0FPqXLAw1B4uR0f9BexHNPNSsg8t36G7UP3fYTQLkdMOlPZrMPSCcCLvUNgW
 kCqak1wQ
 9H3AoqnOoGBH8XXmLKz6MNiK8hsdI+2mWoxMRWgznqTK69NAmgPILIzKgmRwW7uD5nKhCYJrTEMtZysG1/KWYiQMs2pk8ZMBEa4pVTw4DkR+zGbeBvJviYK4jKy8uKspe4SS8IGmzlRcB0+mwiySiUzRTCeJnGAVu+nrSxx8OUi7TieTfH4HUW5U//Ro4PMystdx8PvFLigHiJytW9OVqp4185PtFrdmvfGIpH0BQrvm+G0vGTzDYVV2nTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On x86-64, this_cpu_cmpxchg() uses CMPXCHG without LOCK prefix which
means it is only safe for the local CPU and not for multiple CPUs.
Recently the commit 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi
safe") make css_rstat_updated lockless and uses lockless list to allow
reentrancy. Since css_rstat_updated can invoked from process context,
IRQ and NMI, it uses this_cpu_cmpxchg() to select the winner which will
inset the lockless lnode into the global per-cpu lockless list.

However the commit missed one case where lockless node of a cgroup can
be accessed and modified by another CPU doing the flushing. Basically
llist_del_first_init() in css_process_update_tree().

On a cursory look, it can be questioned how css_process_update_tree()
can see a lockless node in global lockless list where the updater is at
this_cpu_cmpxchg() and before llist_add() call in css_rstat_updated().
This can indeed happen in the presence of IRQs/NMI.

Consider this scenario: Updater for cgroup stat C on CPU A in process
context is after llist_on_list() check and before this_cpu_cmpxchg() in
css_rstat_updated() where it get interrupted by IRQ/NMI. In the IRQ/NMI
context, a new updater calls css_rstat_updated() for same cgroup C and
successfully inserts rstatc_pcpu->lnode.

Now concurrently CPU B is running the flusher and it calls
llist_del_first_init() for CPU A and got rstatc_pcpu->lnode of cgroup C
which was added by the IRQ/NMI updater.

Now imagine CPU B calling init_llist_node() on cgroup C's
rstatc_pcpu->lnode of CPU A and on CPU A, the process context updater
calling this_cpu_cmpxchg(rstatc_pcpu->lnode) concurrently.

The CMPXCNG without LOCK on CPU A is not safe and thus we need LOCK
prefix.

In Meta's fleet running the kernel with the commit 36df6e3dbd7e, we are
observing on some machines the memcg stats are getting skewed by more
than the actual memory on the system. On close inspection, we noticed
that lockless node for a workload for specific CPU was in the bad state
and thus all the updates on that CPU for that cgroup was being lost. At
the moment, we are not sure if this CMPXCHG without LOCK is the cause of
that but this needs to be fixed irrespective.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Fixes: 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe")
---
 kernel/cgroup/rstat.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 91b34ebd5370..99aa7e557f92 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -71,8 +71,7 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 {
 	struct llist_head *lhead;
 	struct css_rstat_cpu *rstatc;
-	struct css_rstat_cpu __percpu *rstatc_pcpu;
-	struct llist_node *self;
+	struct llist_node *expected;
 
 	/*
 	 * Since bpf programs can call this function, prevent access to
@@ -113,9 +112,8 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 	 * successful and the winner will eventually add the per-cpu lnode to
 	 * the llist.
 	 */
-	self = &rstatc->lnode;
-	rstatc_pcpu = css->rstat_cpu;
-	if (this_cpu_cmpxchg(rstatc_pcpu->lnode.next, self, NULL) != self)
+	expected = &rstatc->lnode;
+	if (!try_cmpxchg(&rstatc->lnode.next, &expected, NULL))
 		return;
 
 	lhead = ss_lhead_cpu(css->ss, cpu);
-- 
2.47.3



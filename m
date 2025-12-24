Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E567E7545D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59C96B00BF; Wed, 24 Dec 2025 08:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FB46B00C0; Wed, 24 Dec 2025 08:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BF06B00C1; Wed, 24 Dec 2025 08:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7156B00BF
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:48:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66DF81A0225
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:59 +0000 (UTC)
X-FDA: 84254495598.28.32B263F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E798E4000F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NyRzL6z5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584137; a=rsa-sha256;
	cv=none;
	b=QKwJrDZMnh8lwQgtZGROynq8XeXlVE6UNJhOPx8Vr7RcfQdFt2enmINs3H5LisFQfKv4DN
	WATyFahCE/1eghCxiBUxgyRy8BEv10gzO3Z66391DsBliQkPS+XhWSOay7kRqUDtQ44cdC
	z8+cu1rOhKs44cHZJqr4thjP8WXJcEY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NyRzL6z5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlrWhAOcB5ZojhifL9pR+Jw2f+8cjxe/d8XcV/qKo4A=;
	b=wDo8dV1hYgEBXV48K+f5QAMybEqfwbG+qiThILxuI/NY6M6Ut7p07tUaMsTWQgyVMGJE3H
	571wnIAd/Fxt8KIuAcMbYF4eUedOJi8dzQ3Il32c2JKtvEdRczSvsrrx+/uEjEc8+g079c
	NsUee/AIB86eGW9/xb9QrfKZtG+aMAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7418060134;
	Wed, 24 Dec 2025 13:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612C9C116D0;
	Wed, 24 Dec 2025 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584137;
	bh=xyhATY1zVFGVtiCd57WQG2O0PBgMfm2nst85/O2cEbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyRzL6z5R5v0G5V60c/cMOAmlf2X4K/bgFhayrJykk2mRvNnX5g4eb9eVwjP9B3uD
	 YmMjEnLxAniTSnyzgpbIVbN45S/BowGe8CXoFq/R/cpy/hHlmDhKZvyGI1o12xe/xk
	 lsSJcWzOeAq7LUns5a50t3eL2K51xPottSbxSRwYPRSjK5pwvbbTlYaDLUI4MUQG+N
	 GawSYe+yi7seRcKX0BL+qCRl5mLupLaOEV4Y/yru4Om0oG70W0wLXJ3KEAxlnYkADM
	 avr5NumTqcyaDshTroFYBWKkdaUs71T6FSO720HlWg306E1oHDl/aVXY7PpKMC8mvI
	 b1VfpzLQZ6Kaw==
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
Date: Wed, 24 Dec 2025 14:45:11 +0100
Message-ID: <20251224134520.33231-25-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E798E4000F
X-Stat-Signature: bura83xe3hamdci195f38uttfapdubh3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766584137-800386
X-HE-Meta: U2FsdGVkX1/gtKKNteOGqpyD/5XMqER0yrSIiX7E3YzAqfnd9xfdaGnakl3Gv7i6OSkMrKpboHSX58kqPxm3ilaxijwK7l3xRc3sUESOS2qbM9at4NAI1TlGf0nxF4c+lqqnsNqMq1x7ql/5urUpjDN0GNHWvy0zr2PtNo1UUX4XGeEkhCKaH9SjST25TjKHmnU7VFm9kAN5VEGY9wRkWNBPYnCm0dX6ydp6254Dy33ymLAYA9S1ekcVYFJVOcwUNZHUfnFB54JWz9+ZPnzp35e4WZtPmBGuoxDnBDmo2LtStEYw748J68H2jwx8ifnnpVRomz+kET7J8hWrgTvPwoFD4PSakHo5uefXZk1vuQPb94p31mf1Q41zeif6CUFHQqplfbf0y6elPfwQz1PlgLrFF4cJHXZYzxyqqaSNWIwb/2MjQCL/1UZGBh+se0LInPRgE+84q11wfDmHopjQMMd0Al/JlFv3rWBcu3L2x27GPNW3A8MsyhRqqB4UB2+gnliGFsClzoPoDWa0M/keJra4pevkL/ccvF2y+JcjnFxebYJMPFp4BggOwN94V85PkCK33qjcfVHz3zLP51B8Yqwi0DN6CiVDt7y8BOtWGZCTyYP+lzz65BQkGAnjsOunENtheli8hYbakveDJGrINmMRIRZOLZ7iGPIVmkQhdBLeeIRrZLknggrR+7lBg00Ag6Lb1BI6Hj78Iy2DZwXypGKm2xEdAqFr+MnoAxgsRrioLj4vpeJ8KfyYF6BHbnMh3eGg9U9+9TbgLBIHnO8xlBF5H/NJgTp4ng7YXjaOTj1R8MbN3tIQwsIZnVx+ldfViza436eeKvoUHdHRCsTI20kAS1BgjQQVTwWGkvWTVPhWh3WW8DJD5nt/JAsco/Uj9q52M4ovbehDZKiP+l5B0pSu7rS2bit8didkHIi660IIDS1U8Ydz2pOWUdXpthc/7GBgI6Og6kBZLuomhO3
 BWWmchg0
 l5RVPo9tpBKos7f1Mtt4Q+BHVs68gvOYdGBaszV/6sbXfNiqg1kJq48wMcZI2MIUmEQiwHEs7ev/92EgUW5DRCw0M3H19cDZa3E1yYKJslgNp+1RylvF9PZQ20mYqLDsXNVFnSwrw8wMEnecJx+JNcMd9kT49RJ/EfaBT9UuuVGG1Mf+h6AehLg230RrwXAfpy2fh
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



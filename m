Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E371CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26BE8E0068; Mon, 13 Oct 2025 16:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE088E0036; Mon, 13 Oct 2025 16:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A140F8E0068; Mon, 13 Oct 2025 16:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6E28E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:32:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 319E11605D8
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:17 +0000 (UTC)
X-FDA: 83994238314.19.6699450
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9140A100002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b25AQpoE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucvmGdln0eqXccg+XKAlaJPI55ctMmMl9RgMkth7GwU=;
	b=e7dz+QYmXZQ7krrN4y2dWF5QW2Y9j7mnzvdvDqKnBJiugu8q5pEXHChHlzjbUZ/W/H8mkX
	QIeXA/OOdjVd+EFWf7vfCtuPSeX64TXVHwwotUx+h3BVGP3lH9e5FWuofiOj7l5TK3QLjD
	qWx2OFu2zS2gIwE4zqItg5zAfauYsuY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387535; a=rsa-sha256;
	cv=none;
	b=R5RP4vjFFlEnPWJufHhRZKHmFNmmLR1XiTVyx3cH/5zCSjIUlUCrxMzo7I12xtu4zGKDK0
	4/ZBJ365Sy9kBS+eszj9mkjkNrhf50IHYBRSByMMEtqHnkFrZaogh3ysPoAM2/peMetQSf
	/NwxJzusBCmOnzp1aGufM6vo+iNqSP4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b25AQpoE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E4584172A;
	Mon, 13 Oct 2025 20:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B4AC116C6;
	Mon, 13 Oct 2025 20:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387534;
	bh=bjPVH71yYHRT38x+a2qhkcGYmz0Liwe3xJMHVBXj3C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b25AQpoE2Gaccq6xqz9Wp4kTc+E9b5qQGmXxn4aXI8OOn1B6UWNO90qdLaRbPI+WV
	 5aT/vU5QYvbKG49S3wjZ41D44+GQQW0ZOcp7K4hq883Qob1sALGR40UhGm0KN2PlN9
	 lve9n4RO7Czep7SFLzwH/NsLIsfatogAOXApPZHKKTObGY2vqfYCGn3UbQ6SZZ4CW/
	 jRAmfvkvLzSH2xaloDMzLSTzfa/vxerXiq24jTwgeXFCtmkcBbFweebJdJHNI5fUog
	 vGDyVAFB2RxSJMOn45X+ySzq3gIoohBiCt8cSMxIiRZ9K3OOIGCMlH9XqW0LQd1h1e
	 TfzyOayYLeI3A==
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
Subject: [PATCH 02/33] cpu: Revert "cpu/hotplug: Prevent self deadlock on CPU hot-unplug"
Date: Mon, 13 Oct 2025 22:31:15 +0200
Message-ID: <20251013203146.10162-3-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: qoqouq8kg64n3gzqfzrmmjqehbp5ok4a
X-Rspam-User: 
X-Rspamd-Queue-Id: 9140A100002
X-HE-Tag: 1760387535-389787
X-HE-Meta: U2FsdGVkX18CJ7XzK5HCraZADZNGC6naDV9B1aclY9jv/OOYWzDt1rJe9tukR63QI8b+VXacFkpOpHgdykqYKTGdQP/1IRKVGrIMqBfnPbfp5jCL8MC4BG0QMl/0e5F0RUiHJjFlFuPoUBtZDOj/8yZHKlIPWkC/A5uFbvDYmDy5RJIyQAuNEpou+R/UGjxMDdExTCiaGnzQ8I8jL1TfSMvgnNC2JlKanptUeyeCgw5APjWaFoNRVf/RVkVcNbp/Wj+t0nMovEscZG2UgMvcEqVy9PXYQE72p8eriURowIklOm/e9YYel9VjHzeFuikNK9OxwDRJNNJHTyU9zeBE67Qq2xfYMyh9xI6OJsuv87u5nokuBT9lpZhAA2j97rUbbDJjIBcQ3VtqId2NW07yfnL81acwKR2cXL3otm0iDjeEY5JlgpPc22UzrkHMUVtrbCPW9D52f+bhtXwJ3bCGzbPHUxb+3SZNn41Ma7I1veBJKKjpAWaL4zU74jp5oOYzM0qbLF80CJC3nWsIzkbPS0qNwoj9yPyCfkTdndyLuAj5Yk+bULVp30NGHo4eGwQ17gFOaeW7W6Eqzyhz66bDK7I+tY9b4nwhYmIGqxjwIw3bTyUv+6zpMe3eem7s/jSsvPlAzR5wW9GrBEQ+baRnAoFRIT+uyiMAFrXLeGJDMxfiq5c/BP+n26L1Bm54ov/36I3gAB5sKEXH3/cMiCKGus+euhhYuo2qj2Z7EEOZaBFp/XmZ4afnybMgHwleZhj2GBjI3no2FkornylucfQKFtDxwnq7qa30R5JsV01x5AR8gxqKOQjtkl/YAL+tt3SDBwIh1ax3No5Dx32BoFLaX/6IhPUEsuFUY9/UZY8KgH+xptariQhPBH5KNAzXTgl1RJFKLe3vUKxicx6G5Nr1uenoeR7eRpGB3MgaEpG0hNiIqHncGmBd4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1) The commit:

	2b8272ff4a70 ("cpu/hotplug: Prevent self deadlock on CPU hot-unplug")

was added to fix an issue where the hotplug control task (BP) was
throttled between CPUHP_AP_IDLE_DEAD and CPUHP_HRTIMERS_PREPARE waiting
in the hrtimer blindspot for the bandwidth callback queued in the dead
CPU.

2) Later on, the commit:

	38685e2a0476 ("cpu/hotplug: Don't offline the last non-isolated CPU")

plugged on the target selection for the workqueue offloaded CPU down
process to prevent from destroying the last CPU domain.

3) Finally:

	5c0930ccaad5 ("hrtimers: Push pending hrtimers away from outgoing CPU earlier")

removed entirely the conditions for the race exposed and partially fixed
in 1). The offloading of the CPU down process to a workqueue on another
CPU then becomes unnecessary. But the last CPU belonging to scheduler
domains must still remain online.

Therefore revert the now obsolete commit
2b8272ff4a70b866106ae13c36be7ecbef5d5da2 and move the housekeeping check
under the cpu_hotplug_lock write held. Since HK_TYPE_DOMAIN will include
both isolcpus and cpuset isolated partition, the hotplug lock will
synchronize against concurrent cpuset partition updates.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/cpu.c | 37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index db9f6c539b28..453a806af2ee 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1410,6 +1410,16 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen,
 
 	cpus_write_lock();
 
+	/*
+	 * Keep at least one housekeeping cpu onlined to avoid generating
+	 * an empty sched_domain span.
+	 */
+	if (cpumask_any_and(cpu_online_mask,
+			    housekeeping_cpumask(HK_TYPE_DOMAIN)) >= nr_cpu_ids) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	cpuhp_tasks_frozen = tasks_frozen;
 
 	prev_state = cpuhp_set_state(cpu, st, target);
@@ -1456,22 +1466,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen,
 	return ret;
 }
 
-struct cpu_down_work {
-	unsigned int		cpu;
-	enum cpuhp_state	target;
-};
-
-static long __cpu_down_maps_locked(void *arg)
-{
-	struct cpu_down_work *work = arg;
-
-	return _cpu_down(work->cpu, 0, work->target);
-}
-
 static int cpu_down_maps_locked(unsigned int cpu, enum cpuhp_state target)
 {
-	struct cpu_down_work work = { .cpu = cpu, .target = target, };
-
 	/*
 	 * If the platform does not support hotplug, report it explicitly to
 	 * differentiate it from a transient offlining failure.
@@ -1480,18 +1476,7 @@ static int cpu_down_maps_locked(unsigned int cpu, enum cpuhp_state target)
 		return -EOPNOTSUPP;
 	if (cpu_hotplug_disabled)
 		return -EBUSY;
-
-	/*
-	 * Ensure that the control task does not run on the to be offlined
-	 * CPU to prevent a deadlock against cfs_b->period_timer.
-	 * Also keep at least one housekeeping cpu onlined to avoid generating
-	 * an empty sched_domain span.
-	 */
-	for_each_cpu_and(cpu, cpu_online_mask, housekeeping_cpumask(HK_TYPE_DOMAIN)) {
-		if (cpu != work.cpu)
-			return work_on_cpu(cpu, __cpu_down_maps_locked, &work);
-	}
-	return -EBUSY;
+	return _cpu_down(cpu, 0, target);
 }
 
 static int cpu_down(unsigned int cpu, enum cpuhp_state target)
-- 
2.51.0



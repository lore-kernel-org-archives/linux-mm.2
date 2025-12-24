Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B64CE75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7446B0092; Wed, 24 Dec 2025 08:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8A56B0093; Wed, 24 Dec 2025 08:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE626B0095; Wed, 24 Dec 2025 08:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18B286B0092
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:45:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B049A12A78
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:45:51 +0000 (UTC)
X-FDA: 84254487702.15.239A02D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2131718001A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:45:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H7mMb30Q;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766583950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mykHzv7B8kPpGCQz2I8/IOEXpAkCsSLvoDKqARyITa8=;
	b=zwA2l4ivQ8eqBGwJZLLaeqeGnpnJM3P3dv7kEwERw8RvLCDjFgMcAl/GF4QJ/p1OyRyNog
	HFtAGRcRKGsCzWtINE80LqwpwR/iBDqL/ypah8AUoMjgHOP2/5ZU80VkSXq0ImfsFHFHop
	iF+SbpPgYWiFNrVqRM99wfPU0DKhSDg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766583950; a=rsa-sha256;
	cv=none;
	b=3AF/wsayMJZL1OxsF+Fn1OX2SOcvMlT14fbMicIjNBaF4bALhVK76ZzQq/YAg7mLqLq3sQ
	b9ceA7nc1aJnpfOFYvUubtchX5+DdY+ZGzaYbLPf7I/ikcCjyUCdF16AXEQ4V46IFP9V9u
	jAXtJ9G7hkyG900EhbR2wUS6EKV9dfs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H7mMb30Q;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50EF260051;
	Wed, 24 Dec 2025 13:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC57C4CEFB;
	Wed, 24 Dec 2025 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766583949;
	bh=11kVg/bDOXpa/yvnQMWYkjqm5C/SPwrAAGSvfZEuxSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7mMb30Qrj92/uviIhc1fyEu+nlpB/xOX1eLU8tjIzv3vuprkqSRobPPuypYr4P86
	 KKG/T/ugcEL7chZ7jENBr+nDTaB3fIQi73GMI/yU4M9CSLpe5XHRfs2aG3MH798ZKl
	 4W/s54uzqvvTq1KFo01rD6iLvt2JZgIB7Zox3EjCQFHqsDBeakRVEyKAdhPX9plzTc
	 aF7Nqm7+o5LRlE4Mh0g/fVhpHlIWeUJo9F24g6Tw54kHme7x7rVQ5M2lw44yP9OcQP
	 8I1gtwsfIgFGPD3ffd6khrIbcSTp71xzfbRWYvyWJ0QW3FHw2OXLZOVvnkrZ4PQwN7
	 u8QBR2FBdMU/w==
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
Subject: [PATCH 02/33] cpu: Revert "cpu/hotplug: Prevent self deadlock on CPU hot-unplug"
Date: Wed, 24 Dec 2025 14:44:49 +0100
Message-ID: <20251224134520.33231-3-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rn881rmbbyuus5afuwhzxey41c8r8uqk
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2131718001A
X-Rspam-User: 
X-HE-Tag: 1766583949-867542
X-HE-Meta: U2FsdGVkX1/aEVcv4fydTymD7lo/am/u0kPQhpcfteNTh3x4Gye0WCOIatdm7Xxb+wuiaYpc+aGEdKb6hMRmS72uQ07yORGu/uJgX9R926PN+jk2rEK/EdkJZe030FTr6ds4qKto/C2PmwvBgsyqW6kz4vgHSEGQhpfKALM5PUuQy4Of0NlAq3Rnlqn1lHIXb9SD6cNEzpM05BeiCbjsk6YgMDEOzlDwC5t2krpSwtBExPOEbZ/Abj7pnWaY310N4las6bonJxT8b4zKUfy7F+F6Ld/BjntK0N5WPQqICfbqttEGPG3jHpm7hAA7t29kzVOv4qtJox09kHaiV0vYG/Dx9JlkJsXKBjWTAYGuOdzbfw4L+VpithFx1jWkSAsAK9roRwkwqSPVsRrn9d0n0pMIgBTk/uLKkNAuHlxyOhtZ0A5ti6m9BdqwVQWqOaM4IozqD3QLD9VJkiLAFvBW6lOUvu0PIByL7Fg74ygRO0Sj9NcEpaoDnI2rXpEC2rhjmi+42igng0+5Oop/1fQAjJU8b8HPVkpGRKMmWsbQYWP3qthafIw4D+OHCncKzgW9aY086ubJuUaX2ncFsXgfNA0hN1XyBThh4GM8AhTxgU8LKfg7Se4UyzmEJb+ZdfP7MgPh/0/WStSSLbaYsz5fXJtGN7pLiYo/wE0uNdcrTBy0wFnQeBjGV+4jk78Xz5LfYAbMC8i87KmsbK8XLe4/lOC9lSnPEA7Im55CVMxrtU8dJc/U0wDl/5ZlkUqf9RKa7ScHHmiW5XNItBy74bQn58mdkOYoAduX65NKuxea3jXge6XRhgbH5qDA/ZTRAm6lmGSD6MV8uwLOVL+pjlkYZEnhuf65/EQ0SILxiKAfXz8AgJ2BMITT753pIIzq/d0OzKTlD6CZnVVYjtP/4axJUczUERwCwyTXbLXoQWZXOx1/cdKGf+kJfS/NT1SX5aMIUFKf8rGpadJq9rF2i0w
 1MqHFpZs
 8qVniGBWr6AeLStwYRcWS87PalrKVIicsU5hmdpJVldYAnYRzXeBje2dJmpIGwQ7BjNW4RTK6irF0/EAGmLwzHB66JVft6p9Fywa1NHGDnocndUeOosl8HRn9cYn1WUXeCSQyGwVYTu/2fOzxly6lJZYX2wndlP1CFkWOXzVj6VXD7ghdoKgzLMoGJujCUZv2G9mvlIhYYcGMF+syp0PzVhK3q2E/tq4A8nOdot3CWmzf1DY=
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
index 8df2d773fe3b..40b8496f47c5 100644
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
2.51.1



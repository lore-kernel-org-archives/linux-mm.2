Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89389EEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7036B008A; Thu,  1 Jan 2026 17:14:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE6F6B008C; Thu,  1 Jan 2026 17:14:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB2B6B0092; Thu,  1 Jan 2026 17:14:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD2DE6B008A
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:14:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A3BACE517
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:31 +0000 (UTC)
X-FDA: 84284799942.24.6211C71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9398EA0007
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHSOvnWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305669; a=rsa-sha256;
	cv=none;
	b=p6ziA9j1oBO9XqJ1sIEf4AmsEqLgFI6H0mRhj8m1AROIggTzp9BSFhaOpYLUkNQvDJqU3u
	0Qw/zofrPFO85uQK23EesvWyfEUo1wzT49NBLZyO60R16hzx5gZcaqB3t63Akno3xZ5YOb
	me4h+hxNEqUxVW0m4OOFYeUPzh7H31k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHSOvnWD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mykHzv7B8kPpGCQz2I8/IOEXpAkCsSLvoDKqARyITa8=;
	b=nj71apcO3cObpcUfxZsweOKrivyaz7+3SfX0+jRiUZU+5f5PSaPZzTw7fVaRIw2ocIBUkl
	/SRuBnA/vRwVLXhbb+azuydSsKH80go8BmiWWmsTqxVsFCpsDITG2XnL2uXkAFNJ50v+f/
	dm1b+EWqKKCo/rfzzsRydUO3C+aje08=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5C8442A26;
	Thu,  1 Jan 2026 22:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12890C4CEF7;
	Thu,  1 Jan 2026 22:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305668;
	bh=11kVg/bDOXpa/yvnQMWYkjqm5C/SPwrAAGSvfZEuxSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHSOvnWDEEPIMqCYfMXBMg4MhIZsJJORIQ+k+i2tF7q45UMX7h186aWMrbCkNouBS
	 YVe51t94JfY7Ya8ZYWgrtim+Isr2ohIK9SZBwk3V0aqrpcydYDAOBy/9UQEV5FFqoi
	 l5U51qfy7YC/g141GXTax/12TYrlkQBoiEdRejLUgcGnxCQuFIC55/BPIp8JTC1/Cl
	 yOMdT0opdcsidMPDTHNZ7eRIUZqxlEPCmISKqtdr4YhJIaX5A6URq2unH6cUD+UvH3
	 K09zD+gnJ7kO1hWnE2OLNvZv0d6N1BLXHyRR+taO3yl/k1d9yGSN7XO2H4St6TmVva
	 Gh9Lts/6aUEKQ==
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
Date: Thu,  1 Jan 2026 23:13:27 +0100
Message-ID: <20260101221359.22298-3-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9398EA0007
X-Stat-Signature: ptt3mz8ekjdkr4ym9nczesjfgxmuyh9w
X-Rspam-User: 
X-HE-Tag: 1767305669-249965
X-HE-Meta: U2FsdGVkX1/oBb+hH64lk0RDkRPA1c6i9Y9TQZvYTpvniOaOIw4uCjRfXjqrCmQESlizQQsWk45IZ7wl7gc44MZMXqm4J6yHZ8ggUrvporAvd2knMxClJT2yzDS9KqVKqGqqXJKipUVfP8Po9kM7FLuGVR+rS6iv7zDiT16c1eLn893wkaspmLAOYYRvdsdflran2bktMo/SQ6VlSQUMfeCwUv5x4eT0h7WBU4OuV/qIvHIBId8kqHkW4QtZRPhKIufLdWcEP48VdoBOVdt4IgIcgpOicpvERTIc8ZEBu+XwQNPhiWOUNwCzph7k982OwurUbE9JltyqXjjCus7dzA7hfPpXWU+nlKQDQkX+RPz2C3VwzZVo7SZ0l8ZfxHj6Yn+2g4DnrSxY7N0Kwzi+ajhY4EsGnN2QJtdNTHaLsFLMqM5xtn5fOsQWEwatKfG6hjCHPkJvywd8vjbWssgXeTcd6nswPMelfICa/IrpuZ5KyvO4dA1N9VkeJPJDAcOUWQ3T/+gVRRNxqY0umAJwULrdMbSEZR+8UBGFW8lbNK5+tKZiV+sy7IGOHjM9SED+3n9EUok+6z0y4pVkzL0HLeflL5egB4Z9bMG8Pr54MMPKdwNWdG5iw6S49tAOONkeZvF7ooNcb+ZI+Hxqs+XC9n3TycrM+TMTUQd4249TU+NpkeMC7LnqqwrQGyQPSjwWyxXSqi/WQtO25zcAATcIfzkM1Wst+HfORyRfaEyi/xinNz7X7YaSacxoxzpbhoU+XiXng7QH8x+DD/KHdbQUi9J99q6AgQ1oGbQtHIgPr3xhM4xcir/U/4WoSaz3vq4FVnyqUm85wYR7ONl72oN6xMVIbZIo8RhVfQFVMJfUE4B1BHjuVgEwIe9eM+1AQF/iyUMQsmmMhbhrQe/LE1RALMvG6XDfJgOhei/EB3OaTsi3pXqA2ftrdq7kx7Uat3goND/5Tj633VQIFv25kZl
 35gnnlvH
 2K2WpwYtjTmukAW5IVMnwClrRXkHKRXKuDiOxc5hJOgbWGgZAxzH+Xy4sJWWeZ2oe+Pit0wWMBklBa+RNpU0ST1xz5e83LTLNMFSA6+5YYbs7cW31iC+xLwAbam2ZGXe210ZPBlkOemrgpbwm4fW6s8XmKsRTgxGj2DQvu9aKYfB3DGewckRn4tx4RxLRZKdxsS0xERMyfkw+BC5XOc+i7V16gXUtNcESci0Voa4p9j9k9Zg=
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



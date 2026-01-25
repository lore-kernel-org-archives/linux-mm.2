Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A48CE63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6D36B008A; Sun, 25 Jan 2026 17:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A446B008C; Sun, 25 Jan 2026 17:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8746B0092; Sun, 25 Jan 2026 17:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70BE66B008A
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:46:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 069C85976D
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:12 +0000 (UTC)
X-FDA: 84371970984.09.7EC0DA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 583FCC0008
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJRAwobl;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mykHzv7B8kPpGCQz2I8/IOEXpAkCsSLvoDKqARyITa8=;
	b=EEEAZttxicAZvPkGic+X3BLvPldHhqoZdBkH6BYGS0yTPk6CWDBeaHbv7dkVmoQysFrfhy
	86477dig2clEFTeTWwkyj3RuWRwY56wuNcENMdnaVqubVQfg6h4sUwaAzGdnD6tQr9jfio
	M90f0RFAJ3eVqFvYL7LZV2dfEyjPyYM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381170; a=rsa-sha256;
	cv=none;
	b=3yxCMQpAkoIPuGgMCdhsQ8wtAB+EuSn5+0vKLjnTTLfZtI+UFriGapZr2uennkasPj9fRq
	VXIhgxf3h+4fT5R74nj9cRrhshTMuincsrCImI4ztN+LKMWC50Dcv4XZRL1oyZO6y2lyp3
	beNTl/AfT4F0fQY11dvTuoip0pUqSdM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJRAwobl;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56FA0443BC;
	Sun, 25 Jan 2026 22:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49895C4CEF1;
	Sun, 25 Jan 2026 22:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381169;
	bh=11kVg/bDOXpa/yvnQMWYkjqm5C/SPwrAAGSvfZEuxSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJRAwoblsccMiodobRnpFQtGpl7gdxJB6n0JNacQjkT3UO8ssdSlLJfivDoMQVuXT
	 wCi8OStM8FmLsLva1RcHux2JzK4oEe1rcGtTC1CLlg5MJP2qceYP0hMKyY/acCEiYE
	 3XRxxxD/co2sos47qIivFwk3U2q8xCW3LoQ7QmT/Emn4nLa69E7qOgq4BXVQluLogP
	 td5NDbweSjT7mCDWSEgJ4Cp1IY7VhKyObYeNMJOhIPoENPXIX1ZEV04RF1G+8hC8Qy
	 cnZVjB3llXMwhAv+AzXVrxjs3FZ08WV6sZe3qFJOe68oPw2I3yp6MU1lf8URxD2gKE
	 a2mPuA1WIz3xw==
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
Date: Sun, 25 Jan 2026 23:45:09 +0100
Message-ID: <20260125224541.50226-3-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 583FCC0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wh1xefkpkgh985nuzjbk9qi7ixpwy5cf
X-HE-Tag: 1769381170-552213
X-HE-Meta: U2FsdGVkX1+KDMKKMPw5/8AL9+h6YupqxTgamozPH9em+9bdVzfmk6aB0mAIgEt1KLtizk5z6OlG6u289wff23V/26YdSom8gQaDfhY/v6aOM8PTncn/ahgV3Qvn3gz5jXjWS3SKQ3EeekuFupqnj8FrPECrX/5ublInPIIrcApQXRZuc/G/glfhb6wdTsqVZy53lomjurI2Ow4YktJUMVW6yAC/N8rHyr+kO9ZoIEVr/0AgtjHD40EhWMDRohqeEiAlCV4FR6JvsqsQX18P6cBhtZ8l7xyDxZZgPXnhiWZJNX5oAqh6TNrKh01GbvS+0b9fdG8YfC7KALKwMQdMkFlTxZP+Q9AwyJWV78oyPdL8YgMRkIJwNBql5Dc2pv9IPdG4p5VzO4HWoFPMyRmCF2Xycb2YLUJrQL39sr9b1CjnVehoYQy7FVHtb7ftqycuinKxoAOGfguM4guuNznKKfH8ghOOyGQaGn+VjH7Zcm/6fLHDbq6iz/WKp2dM33KNYvg/k7I4IUqNKParjC8sK5j9wCNqxM3OvF3KXFX5GTDqxrE1c5liTgI5vDLUrRPpmjj2fa2RXoJ8FzBlXAnyTk9iHpwA2MV9ouzMmAO80vDKm3D17KAjR04iZhmttMs0NyhPcfbF7aH8/tF1G+6Xq1RBVX4w2lmQ1bkr6hHvuRtZYh2VHdTa42PBfCFMe3dHLQVmdgrNnK9sUAzrCzm5EHra28lqv0esMBnDvsHSfBxbqgwiR1xTnqjIrRKIzLdv7oCC09ZYAhExpJMqTPekNfV2znyNSuqW2fXt6c0AZBxo0bM+L8npT7F1jbBMPB6NzWvI9anoiPQjulzVgROwZTQ+LPqAioGRqS2x6PbtU32HcPNBipkd/XU1JOVk8omBRc2BtzxTs4yV/C/BpjTQvYP1V4pI4mNgj9AFwIFpkPOxlrIOUy6LQn38r/LmtPAvEE08aVsToD3CL7Y86dM
 mdX4uv0O
 NUp1kU8XiXSbuKd0JwwMXNUsAMbPL9DVZRTI03j348lcfUu6qCp4yvHT/BuA+N8CSb3506VejdGkLzOSx/t6D1jtkcNWCFNWUkdSxlVSQjYeNFaXCUiMyvJLdBDgUv4tD9fQTXz6+bHgQF1VJO965ICe38oq5N39TP3VdUgWjqFIjOl4jY816sLQxvofTzaF9iRdvw1gKqGkmTDa2FC+dzbkyDuGv/lGkY8eIkQXnRKE6Vi8=
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



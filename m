Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8196ACCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35428E000F; Wed,  5 Nov 2025 16:04:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D058E0002; Wed,  5 Nov 2025 16:04:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22948E000F; Wed,  5 Nov 2025 16:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B19E98E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:04:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BA1F12C544
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:20 +0000 (UTC)
X-FDA: 84077781480.09.09EE3FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA1B940003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDYIWONq;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucvmGdln0eqXccg+XKAlaJPI55ctMmMl9RgMkth7GwU=;
	b=XedgKH92S7evDskm5Zzo02Hquexw/Xz8pwHdg5hlBSVhPZbEKN6d1S+tzFr4Hky/x8Gl87
	kGZV9/DI+tte+BMBzcYjSp5Nc6DR5Th4dHCI4IiQGS57HFz0Kg/DgHN+kDWtqOmdGSxQuu
	F9f42pez8NM3LCF3lbMPpv8RFFyfECY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376658; a=rsa-sha256;
	cv=none;
	b=be5KUTBAi6wDb0yKyBLJI5TKgVKtIXUhFJegcKzb9FwqlSytrzHpVibOkbO5toB9AqcIjR
	8yR9xx8tnXRpf7JryCTUXCX0q8CQlbp4vhkOlze6dH4Tv+8yY3Fe0ScJuRnqAc1zKBcNxx
	Yr2wVgexZeQ8JbAuFQVCpYY9XKGLDXk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KDYIWONq;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5397360220;
	Wed,  5 Nov 2025 21:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED49C19425;
	Wed,  5 Nov 2025 21:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376658;
	bh=bjPVH71yYHRT38x+a2qhkcGYmz0Liwe3xJMHVBXj3C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDYIWONqcQ26ibQzAQkdgLQwpYLoizfgpJwRPDhmDxEYw8bbVT5NCfytM6LWq/UIk
	 d3X9McPNu5W7bwRl1V4OhMilC81nOdPW0GZNtyyKiVvnVvZwjU3V4eRlGb4PCDwa2w
	 oLLKKfw8RYLb9vZQfM9ezsSGTdJpcGLScxRA+EnGQR74nwdqy+MCCwX4jkhZ/5Hcyj
	 KRU9HMvlEYMMfEozwi7kZ2BnBbFbAgiVNuly1Yw+eyZFhmbmRTg4/XmokIJptUndAK
	 okt1ReWDWQxCFWQKpgouktVbzoKoG6YAN9jd11ycTU0odnnKgj2EXJdv1rMNICKGX4
	 CB4eyIRSu0e+Q==
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
Subject: [PATCH 02/31] cpu: Revert "cpu/hotplug: Prevent self deadlock on CPU hot-unplug"
Date: Wed,  5 Nov 2025 22:03:18 +0100
Message-ID: <20251105210348.35256-3-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA1B940003
X-Stat-Signature: 9zfh9asdq381mqupz8cqxq9izwwpyurg
X-Rspam-User: 
X-HE-Tag: 1762376658-589628
X-HE-Meta: U2FsdGVkX1/mH0e6/vqi3YFFtRJeqK07H2IGFsmhQmka7Yol5oVDrXHTExTFLTJ3wjJ3P7GC9XtNNJ5FmGng0/WNsGEQ7RTmI3B/awbjPSKF34M8CPdQKSjhWWupPj1HsxAD6NLPK3Auhyjy4K1OLvJd4HofvLiDoJijnqWAgm5oSy6dSikmyxYc9GaEyBnc3MTmhf4p/K4NI2qkLqyQH5IIRC0H/2pSXvqC7LT82Hk00aevfr4WA6E2AFGrRVD7PsuoYO/xlxg9znWw7rADT0oeTvubrmdXADlF+uyBBo8r6uFwFygZa0xwU1+9L8jXy7+JcN5yGhuUJJiKwMcw/knKSdy25mn0xI3tbGUmE04YB+Vlm26GwfrIxrlpVv2yRcW6Zx2aUePOMv6ieG9zApRpS+WX7/vQhAleJ65rgf3VQ9Div/njXRn1dKmP8Soe4+7Bxybos1dF2rFpz0anAGVkgGyDD9k0SeanGxQEoQjU/VtYzBlcSdFURGplBQAGdF6kd2Lp0xFfya9wRsSvgU7u/AXij2VOpUeciLaQYebwsRCNiWVILPbLqs2updj6912mxApak0OCCeWQrVuAfZVVpUDPxVbiirXngH1cJxR2EAlXzw7m6fd9n/W2w9T5e0vQE11svzOsfDUPcN40Nxew9S8pjpONo9Hcm5BsrOlV8ipteKBwQOfld+u4dkPNLrmZ7LXLBer+i+hGjq6lfRHlMW2xFBq9If0GcgGo0FZGwfAFzunWZ8Ee8Ps2UfbgwVWax97666aocuti3MIxdoQa/sQ/ZKJ6O2GAmaZPM4hrdhzvqBT2LdlbEFvufxAip9Lc4YMVCs/F2vipeq57GhHNiTN7yYl2DFOwyPfZiRfzY9AYL+/eu8soZm8di23yyOHYucQnl1pqAy1fZmt/3PTxi4QnCMqYkOzBG1bRP4XYairNFq0lC4KOVX3Zlf1L8aCkeAn7bdz5OS017FH
 a2SxKNuU
 uKqwVtEYtUnnTeUVw0O1+Xf6JmZCJW/APEd29g5GKDzsVErvjhOPrZqboJD+eNIDhNsHm7ZEtqP+zfrm/rq9ZxrP92pAdRxVs/UgEXNX6bvdPPXX1yOGA6t8jibFxW2Q3jeWCcrc3fVhx8n8BEr9gv59XS+BuSKAtq2n2XLXoVAAYtTmIEE1bMeF+o61hpfG+Ha6+SpVZQGemETQrStFIjPcII5FtMF7B2pk0i2bvUBNYIwM=
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



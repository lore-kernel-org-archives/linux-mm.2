Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C78CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208228E008C; Mon, 13 Oct 2025 16:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B89E8E0036; Mon, 13 Oct 2025 16:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0809D8E008C; Mon, 13 Oct 2025 16:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E38868E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:36:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B020B47049
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:36:15 +0000 (UTC)
X-FDA: 83994248310.27.768C4BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F058DC0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:36:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MNXB3QYp;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1PNdgknOyyk2mzZmr1xYTl18CtGDJfdBKGGVXljgnw=;
	b=ejXbAXc5PeVQ9uN+yxfvKySxmh9DhuZwdUpte/eThZHQ50ZzedzSH0P5QK9Nodq561q3uP
	1ifiQdoheXeH1GnPzPGbfEX8hwBrdJf/uBKxi9pTq6BwMZ56tekvNG+OZYY3luIIJHXLrs
	tbWr+BxLun8qHIM9GjPSkCXRE7LpFng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MNXB3QYp;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387774; a=rsa-sha256;
	cv=none;
	b=3NtYHXDu+Z00BlQOZtxZGC20Hy+I7qBK0zToruWrm+gBT6MJ8codqnc6gws751kibz/F6x
	1987nozaylC69hbAz+w8Ax/7ooXxJaIlOXsj5aTc/2cbWcZYxQZeufbaU2U28nGSBy3LUt
	/lDDHVTxg/Dh10j4YZ+Ui2lAS4d36TI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E313941E40;
	Mon, 13 Oct 2025 20:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE06C4CEFE;
	Mon, 13 Oct 2025 20:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387772;
	bh=Jrc2SP9zuO/q8lVKXeMSZQ2TjjYp5fXU9+UkI2oxxh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNXB3QYpRdiFAXcP7KGkH3KNjLbcjQHAsJUVDtmk1f1HjTTwa3KUIDoyy0ULi5OFa
	 G1hHGn/dxaQZ5Faqttp9F5o8lS4K3lzl0oO8h4XvBxDmB4CI1ocOlhB7mpTBWczRpe
	 cbVl6Dc2oGcHw4ioesDHnycePL5mRzpUCYfbh5z7fE5bL75KqCXtrMmz/4W+3XrleP
	 oMKdy9NKWu7KiOETV1Hlg3Uaq2OhxJGJs/UZbbod9e6FJHRwmIGt7Ub1FGi7gJ7Djf
	 hDJsEwtgnaPJvOgCNXijznnVNxp9lEDzhx4vKFkdU9oGt6aKkRvBpZLinF55YVRxcr
	 7ZyPgB0llmwOw==
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
Subject: [PATCH 33/33] doc: Add housekeeping documentation
Date: Mon, 13 Oct 2025 22:31:46 +0200
Message-ID: <20251013203146.10162-34-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a4pb5qup7jznfxkpc4jox1ek9g7oxa8r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F058DC0002
X-HE-Tag: 1760387773-435231
X-HE-Meta: U2FsdGVkX1+t3zuGj/tFzYkFDNM62J8lIdej5M1MoAUYbLwDwMNDWRHrgSlvCpH2tUuExi41MGkFpP6poBf0YDHpMOT2fV/ch9bQrPLVY5Tt10xUlHDgC/8mI8TwpAdQKFl6sscBbP7XK7H7F6kBvB3mxzeKkd3dgCiPj8RGo1EUTGe5jM0B/nWvtsLCOYdsseAwvS//H6U6tNEMKdPmTrfuvvUTM7jY8wI46P0UsLW9VhpKeEeWJBiI5QHtFJCVPHCWKHI5nJZxezbJuUQlyJDA1cwkWBpDurpgA0FO6wjkSfEwzJYfj54zd5mrOlTowbHKhvK5ssKd2fTu8eI/FGPuw7BGi+NVThzSfW2t4OXxSgt0wlO116eGBjFiVZ3pYG77LFc31XlZmooQIqyjKhnAGT9IQ3uwxxPfH/eCMgGpKAFsPPP8FxBaHQ/eEYuccb4SmXVol/QyvBrEfRmxc7Y8x+Y/FEJpIvhR+EzmY0TuVin49mlHx+z6bz9Xb3vm1cFYaZfPwT7C8PnrIB+OAWhg3poS6Xvi4cqIFA4/X27/MmZw6Drz9pHwlLLjgQNjt6oZzY5tcH1OXOS8d6kga8XjnFMrxzK+4TrsgawM4wmrcZltsesyyE0KCr7696PcKSUa6RDMoQjMSKtnJsA80HvHH9Hsyego2XL2EB/x9f4e1Xl7T7fgD5kPd5QwpEpiFvf03oTbYPCTMx5ub4FXMHOeX1F3HffwCwNX8/8CZFLlAhnB/SryQrHcaHEW/Uos3e2aCfTNsDlu5DOmAA0qMhzRLbW4MuKL5WG7AwAo3USJRWhfZX9FvcZf7vaI2wArNbPhXrB8NscpDbUshONT3SCyX/YzNeb2Dnl+cITXO305w2xWim/E2YL206ZuHUaT3w9v8cap3PDj6cRuss2PzrEU3FOzdZx8axLr7+mcmA6Qi4H+BYhYo61g1vVIwgNfq8gku9O2HzPPHcAocYW
 8E7Bvf1x
 dJzpKCVHV8r0zDHCvVrya6sdfXXyge9ZOGo5Nx+ByVvaN4xw1SYsf4SfPsq/oS/NFduzVd6pBJ2bbE/n4RLOp8tSq0bLvut4JRkP55HxPsw6o2/VnJCTAuiuHQmQyd7j2K4r9dwVTqSVS1V9DmMwR21J+N5o96rBme8GjPB4vCizzUFAzDbVlxM6Xd4xocZeaLfPhbvO01l9g5DHfdCK2egtaPJ+RJYeSRPxJQrUdE2t+WtE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 Documentation/cpu_isolation/housekeeping.rst | 111 +++++++++++++++++++
 1 file changed, 111 insertions(+)
 create mode 100644 Documentation/cpu_isolation/housekeeping.rst

diff --git a/Documentation/cpu_isolation/housekeeping.rst b/Documentation/cpu_isolation/housekeeping.rst
new file mode 100644
index 000000000000..e5417302774c
--- /dev/null
+++ b/Documentation/cpu_isolation/housekeeping.rst
@@ -0,0 +1,111 @@
+======================================
+Housekeeping
+======================================
+
+
+CPU Isolation moves away kernel work that may otherwise run on any CPU.
+The purpose of its related features is to reduce the OS jitter that some
+extreme workloads can't stand, such as in some DPDK usecases.
+
+The kernel work moved away by CPU isolation is commonly described as
+"housekeeping" because it includes ground work that performs cleanups,
+statistics maintainance and actions relying on them, memory release,
+various deferrals etc...
+
+Sometimes housekeeping is just some unbound work (unbound workqueues,
+unbound timers, ...) that gets easily assigned to non-isolated CPUs.
+But sometimes housekeeping is tied to a specific CPU and requires
+elaborated tricks to be offloaded to non-isolated CPUs (RCU_NOCB, remote
+scheduler tick, etc...).
+
+Thus, a housekeeping CPU can be considered as the reverse of an isolated
+CPU. It is simply a CPU that can execute housekeeping work. There must
+always be at least one online housekeeping CPU at any time. The CPUs that
+are not	isolated are automatically assigned as housekeeping.
+
+Housekeeping is currently divided in four features described
+by the ``enum hk_type type``:
+
+1.	HK_TYPE_DOMAIN matches the work moved away by scheduler domain
+	isolation performed through ``isolcpus=domain`` boot parameter or
+	isolated cpuset partitions in cgroup v2. This includes scheduler
+	load balancing, unbound workqueues and timers.
+
+2.	HK_TYPE_KERNEL_NOISE matches the work moved away by tick isolation
+	performed through ``nohz_full=`` or ``isolcpus=nohz`` boot
+	parameters. This includes remote scheduler tick, vmstat and lockup
+	watchdog.
+
+3.	HK_TYPE_MANAGED_IRQ matches the IRQ handlers moved away by managed
+	IRQ isolation performed through ``isolcpus=managed_irq``.
+
+4.	HK_TYPE_DOMAIN_BOOT matches the work moved away by scheduler domain
+	isolation performed through ``isolcpus=domain`` only. It is similar
+	to HK_TYPE_DOMAIN except it ignores the isolation performed by
+	cpusets.
+
+
+Housekeeping cpumasks
+=================================
+
+Housekeeping cpumasks include the CPUs that can execute the work moved
+away by the matching isolation feature. These cpumasks are returned by
+the following function::
+
+	const struct cpumask *housekeeping_cpumask(enum hk_type type)
+
+By default, if neither ``nohz_full=``, nor ``isolcpus``, nor cpuset's
+isolated partitions are used, which covers most usecases, this function
+returns the cpu_possible_mask.
+
+Otherwise the function returns the cpumask complement of the isolation
+feature. For example:
+
+With isolcpus=domain,7 the following will return a mask with all possible
+CPUs except 7::
+
+	housekeeping_cpumask(HK_TYPE_DOMAIN)
+
+Similarly with nohz_full=5,6 the following will return a mask with all
+possible CPUs except 5,6::
+
+	housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)
+
+
+Synchronization against cpusets
+=================================
+
+Cpuset can modify the HK_TYPE_DOMAIN housekeeping cpumask while creating,
+modifying or deleting an isolated partition.
+
+The users of HK_TYPE_DOMAIN cpumask must then make sure to synchronize
+properly against cpuset in order to make sure that:
+
+1.	The cpumask snapshot stays coherent.
+
+2.	No housekeeping work is queued on a newly made isolated CPU.
+
+3.	Pending housekeeping work that was queued to a non isolated
+	CPU which just turned isolated through cpuset must be flushed
+	before the related created/modified isolated partition is made
+	available to userspace.
+
+This synchronization is maintained by an RCU based scheme. The cpuset update
+side waits for an RCU grace period after updating the HK_TYPE_DOMAIN
+cpumask and before flushing pending works. On the read side, care must be
+taken to gather the housekeeping target election and the work enqueue within
+the same RCU read side critical section.
+
+A typical layout example would look like this on the update side
+(``housekeeping_update()``)::
+
+	rcu_assign_pointer(housekeeping_cpumasks[type], trial);
+	synchronize_rcu();
+	flush_workqueue(example_workqueue);
+
+And then on the read side::
+
+	rcu_read_lock();
+	cpu = housekeeping_any_cpu(HK_TYPE_DOMAIN);
+	queue_work_on(cpu, example_workqueue, work);
+	rcu_read_unlock();
-- 
2.51.0



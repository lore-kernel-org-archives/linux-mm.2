Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED63E7545D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB19D6B00CF; Wed, 24 Dec 2025 08:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65126B00D1; Wed, 24 Dec 2025 08:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984CF6B00D2; Wed, 24 Dec 2025 08:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 854F26B00CF
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:50:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62495137339
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:50:16 +0000 (UTC)
X-FDA: 84254498832.15.3755D7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9B513100002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:50:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ahi82J95;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DzR/7++HQoBO8hfUtZdzGi5JYMWhENpMmrWTTSRkVk=;
	b=QvvgX6LqrUhbbce4g/m+VlHSF+5qWdLrYn6BbLd/1JtY2F6yJiFmJhu/x97sE4/d3jj2Hs
	EwONy2zPdRtL74L2ZFx46oKLrENRRd5CyQ+QHJebQBWe7h4Kr190hgQSGyPxzcprlyAjnE
	vAcu2+oH2fmIIjspMdgAoyTJVW1hnCA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ahi82J95;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584214; a=rsa-sha256;
	cv=none;
	b=gJ7zeadC/DEOk2Zy+K9cIUCi1rxZy2KGmh5KUqs3M3glgcix7EBkrr5U8o2/EnOw/Fkah5
	CyhhOc70oUVpfE2sUI93ARPjlQTynVbWuq3aDqd6kuI6IkMzZI8h2vQQA4mc+0b6AGredi
	s805gOg+lTeyZPxydTV/SqTebLDedCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8618435D6;
	Wed, 24 Dec 2025 13:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270F1C4CEF7;
	Wed, 24 Dec 2025 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584213;
	bh=1ThumxDDgpI14i4xI2NJUZlN8OnswY2btiiSypM7sVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahi82J95Ib/ppDRG2oGNZ9HCy4FO7NwJKzhKKQKG1+UUAadEdmqhM1slQjgCbxhV+
	 /dcBOeXszn7WHt9ZEfzUfR2usAGjc5uAN/OK3ZHVMN6a/GtbA6m05cxKc30/svswW9
	 lMaao3gqVfU1DJmnwW9fYJagoqE1abjZ+rGDbjrrUpMuwLIh6DIVlL9d2y7zHGdY30
	 tfIgeKXtzkXkTpfedG0igUK8LV3+nv7+Y8XcfzegBKyVjUAwe8f8Df0/Q+XXlp1ix+
	 v4BjeCOmS/tbEvleYYDEWcXyh76TNTsAYQ91xgEDVBUpifl3dY9W3RGxk+qIejrkj/
	 y+oyfRg4KoKWA==
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
Subject: [PATCH 33/33] doc: Add housekeeping documentation
Date: Wed, 24 Dec 2025 14:45:20 +0100
Message-ID: <20251224134520.33231-34-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9B513100002
X-Stat-Signature: woz3i13cx1rz9wzhs8745mczsujhdxen
X-Rspam-User: 
X-HE-Tag: 1766584214-465084
X-HE-Meta: U2FsdGVkX18r+CVR4N/L1okU2IlUMJ/7FE3ECh0H+cqDZZxA+xsnu43H5DHts8kzFLpTEOaxjAUw6y414VpYUwI0jbHjNYvXV7NasfKYKzK9dr66IXARV2RVkyFt95J/9GrdqQUFet7HFDHmy8cJmzQ2GTGUBYDKonT+J3wASNO7YF1krpPIszZZSvwPqKhJkeQCev+ZK6Fl1IM6mmd9iAi/IW6JICrg2MOBeCYxMp5QB1s/UAjl6AL6n89CXYVUnK1LeIozjzRWVtb5JPmnxY+1uA03//D/F0B0n6FOArDPLBghoSAUvlDGjtB6y4Dr4Hpw9I8gFtn7VcHoqADGHh3tMfRkhcevrEX4AhswXOwdwUk1qKpcYUmDlrJM3KERjcAEJf2NhuWxqjktUxftPjTZqA81Eg3ud/sc2TANDJqv+gd2NiOKb9ig07miIQmcRORUFEt9k84hunrqABhyMI6M2zpwIVZJ7Bppf/Oaghjms9O8CQWI/HhrdRlQP2mpxgQSTUbPjmAnZtAWjfjNmnZX6DHfwjPvsmb070NMMQ6Gobm8y0TrNjFBrZ3zI8l1oC1wVemqkQhSFNiuhrYREt8/Dp6PY5L+yS0yjDCDUzqQaS9Xc/CIWoF5fuBWQ7HNnzrimSD1NETFkzDhCMS86UOpfvWRvAKlhP5Ppi4rg5eoLtol1xiIfSQVxvF6T4i/1meE9vqmjGSaCkzRESlWlEEwPfV2syUBjNB6TGkh924gNLeuo8wiyl79QnpKPZR3MeQLS3xtuGtOi2ygcQjvwjAlx203G4o/+MzI8WeFSNijhMGHgWW4bYYFwZzDcNRz8rvm1GIZNiMWd55zHb8waF7x89qjrQZBkbdC5LDFSl8N8dJdPvJRU6Kq1eOLwEjJHW4xztbS2Xn3eFE0VdkrB+zgYQVqSHjGfNG14Js5sb9mv6dMZ4LDrRXpnfZJNKfDrFwId3SPXRlblgcve1b
 4nQqJz9i
 vO2DHxruzvdAt2j6KR8lz2idEie2mjo7zW0f/YPc16rN0Zs1huay8vOdi/j1m7OVFm6kSWVd+EJkJNQnLJY3K11Bm/cNr7SK1XGrHrR9keawIEl8f3759G4d3Uf9fLkYcXa/xIntSHWJ+SZhJ+/lZZrjwHRwdKCAZlne6kWGf/J5u8HcSNYCnPaXT43tUArjn/NY80ShMfAJRM9fMJk5htzTkAqABw2+NL43XWuG2m2mnqCg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 Documentation/core-api/housekeeping.rst | 111 ++++++++++++++++++++++++
 Documentation/core-api/index.rst        |   1 +
 2 files changed, 112 insertions(+)
 create mode 100644 Documentation/core-api/housekeeping.rst

diff --git a/Documentation/core-api/housekeeping.rst b/Documentation/core-api/housekeeping.rst
new file mode 100644
index 000000000000..e5417302774c
--- /dev/null
+++ b/Documentation/core-api/housekeeping.rst
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
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 5eb0fbbbc323..79fe7735692e 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -25,6 +25,7 @@ it.
    symbol-namespaces
    asm-annotations
    real-time/index
+   housekeeping.rst
 
 Data structures and low-level utilities
 =======================================
-- 
2.51.1



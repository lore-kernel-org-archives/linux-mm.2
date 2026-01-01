Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA45DEEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177CC6B00D0; Thu,  1 Jan 2026 17:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12BAE6B00D2; Thu,  1 Jan 2026 17:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058326B00D3; Thu,  1 Jan 2026 17:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8FBC6B00D0
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:18:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC16B1AAE05
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:47 +0000 (UTC)
X-FDA: 84284810694.01.3B2C46F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D54EA0007
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ch0+O6T9;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMEZtpjkMJvKy0j2B2A5Z2PL6g1rPUGZICiE2R96ChU=;
	b=U5m25TPdc/qe99acxf+IRsL6xeunYYqVtNPLKPvNFaCUQ/anoDKoGZ38byP4GkUulgkrIr
	Cf8XGGPrNRfSKuWMMfK3IYYrQ5ZwwV0pDzylR8Qfdc3SjnO0pV4CmFQddS94zm7j83HwRb
	zn4ernJPD8lOuTAPPO4SJCMW7YJvw3c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ch0+O6T9;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305926; a=rsa-sha256;
	cv=none;
	b=qgIRo9iavh98+uptTH+q4+A3znuCQC6dOfyUuBpyOZ9iL6zx2ObE+4U+nUZxfr/a3AF/GN
	tiIVBfRE/EWXcCTx/rj4bjyUun/VzKyNgz2ugblUlA0uhRntef/w4OkBWi54zMlHvccqVw
	+0QJ9Kv5oqlekvn+vlK0sgOXJCi8Pow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A121960054;
	Thu,  1 Jan 2026 22:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5258EC4CEF7;
	Thu,  1 Jan 2026 22:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305925;
	bh=soOg+pSguRYShDvlBT6z+CExBTh9mpEwKqBDpU+MvVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ch0+O6T98cz7FFkRIvS/lrnNxuwEZVtNVKFC3b2uDV4OOAyrOCUNOhusqCS6JNycr
	 JUpM4y18xsCFl5PanmWQQ56Xf4q84aK9WKNz43EhMZ1cwGEt+l7YTfU8aIyG79LZFm
	 umUER4Ke8sqCA4evjdGE7hKCxtUMzlRqiHgbST3rqhEnSWxUWB0Ay/pY7a418yRReV
	 VyWeUpgJ1b01hgn0Knsfb6k0nIunjAL6AWFL2SPFbQ9xuquSJrz5ncySl9dYIZ6+Q+
	 kw65NtkT6BzpNxo/bs+0zFugLdB4vJmfSkrCoHMfujB2EbbJKcG3Fx7qcV66bUr8Dx
	 F9u1AJrAhWhAQ==
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
Date: Thu,  1 Jan 2026 23:13:58 +0100
Message-ID: <20260101221359.22298-34-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: whxfjtj66yurryq54hehn4qe17q1hg8x
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D54EA0007
X-HE-Tag: 1767305926-109777
X-HE-Meta: U2FsdGVkX18EyThJAlg3oHgyepdj/4wgZoKBl6Jkcokz9qGosdysM8aoRo/WRNqnRWhQgSs7ve+7CiPbes6SJzKQltg+BF0u+Viv+OXIOw06tgI9eKucPEehDnpDn++DAnlCq/yix7l3pSOxYYCQmsCO/z/AI0Pm3H1W0FHvqF3n4scdAqnoTbr+UPn8sZS3xmbDIXyQl9g/gbymgjSt1905UwUBccYR2lu+imAHr+sJnMlcBZAWM9552R/QrzidiijO9lHfifL56EU7MY6p8uHqKwGlurtkV6d1uBihtWYZ8fgL2TY6qYbJ8nduY2ja8RaYhELyRZvlBBDcqnLN8XG5P+CKLA4i9J+har/Q5MwBMOZh36s5xTXKf+Vbzas8DAcQfL7nJ5BpKWViE+guZ3tko30vSzwKvD3XyD+Ui3XT5pcvzH6JUTyK/k/phLc6BwvISxxZGnDLQadv6607xomFK35yu90M9PvyItYf6u17OyvwKk0i/NMtt4iG4+Q+R34C9SQTL9cTGPoCqzsUqJ8wDYvgACDmqxwDgW+MGXK4jDY/Fdj+13CbeY20d4rCSRth+g1OuNcitKrQkckyW1dWOCBKbjq7WS0ZdAxm6DshT3GfGFeL8OwvkyROgKF8GR9juBIJF7EEzDmCSRUmUhyIJ6z8GfEvR4qW9HxDoatb2VYYyiSNKwOWWzodH+tGO/i/f11vJgQuo4+MhenitOWAHcr0s7FXvhZ0NP2ohY4TBARq+uqI3qU8VAdWtV3Y062Hy7LONN26iJeuE8dA9Uc+crnpwxqiD3/zRT8tWYvMbHZLfFe6gE1FZgHC95ES+VKE8Oz7IRlslzRpMLSzAITFu4IXb4hQzPeDip3CSwuBoa+Msz4GpAcoVym2qsjey4s826UImks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
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



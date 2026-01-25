Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9CBD7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6606B00CE; Sun, 25 Jan 2026 17:50:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A97F6B00CF; Sun, 25 Jan 2026 17:50:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76BB56B00D0; Sun, 25 Jan 2026 17:50:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 617B96B00CE
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:50:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B4AFBA312
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:50:23 +0000 (UTC)
X-FDA: 84371981526.13.02EA08D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A61471C0007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:50:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9eNU6FB;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMEZtpjkMJvKy0j2B2A5Z2PL6g1rPUGZICiE2R96ChU=;
	b=7cvf48HSx94isCSJgfvZDLHbKxyWbQZLSG5nalw5W8MtM1r6qyR7tTfKfPA+hgcJmvtYeb
	od8mZu+YNv+0Vc8hXV1SoIfJVJMGyRd8/nX9TPEGwb54utIQOEf+1u3DLaRvUZ+5Tukc3P
	vgsyqEn/mP3vxemBfPXe3Pq5s06EQfM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9eNU6FB;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381421; a=rsa-sha256;
	cv=none;
	b=FFVZCQn1V7fTFQ9lsaNj5DA+RGXl6am39BDz4ikEgRTyyak2Zh7y/FuCQGttzyr5zIqB0D
	cnqrkBr99uTTfmbeWkg7ssnJvhqPoHnYgjVb19TYzTuLJUHsumlWBnwpVqOQswYrJp0qVa
	iOBZUjOWmZh+hBzJcD0r3C6hWoM1EvM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32A1460127;
	Sun, 25 Jan 2026 22:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F9BC16AAE;
	Sun, 25 Jan 2026 22:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381420;
	bh=soOg+pSguRYShDvlBT6z+CExBTh9mpEwKqBDpU+MvVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9eNU6FBgsG9hyVi/+uWzwzBcb3jcShb7uOmQsjIIjUrQdwd6h2E2hlOYXFcXB/ql
	 qdKPPIOMoMFnsXK4JR327RdmvVp12tzAKc3mdCuECy36dJ+ULwoOd7XxIR96MFfnRS
	 Tf/BhWFSthB4dknZzQT+VDMKWaiGk1piYc4/1SvoEyWQPVWOMbGzCOX50wyM0HhBgo
	 zQY6jjB6xI7BeQI9xaby26nk/VdbQlcrksM8alFh3VGgf4VPNgHrdrPRTG1yHtNs6B
	 LJOghmDwx1hiHEaoiXnunqOam5DBew91Q1zeucjxGqoQn4ndm/rwNY/R4fMGcCaLal
	 ZHqk/ey3wxMIw==
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
Date: Sun, 25 Jan 2026 23:45:40 +0100
Message-ID: <20260125224541.50226-34-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A61471C0007
X-Stat-Signature: d7e8qnqyodzq8wkyxg5k79e5w7csypy7
X-Rspam-User: 
X-HE-Tag: 1769381421-886136
X-HE-Meta: U2FsdGVkX19MUYW+OCcj5q//bIHV2ePdolKSCgGvlxwZeRv9v9LqMbmOBhzFmcajXi0/21M2c0gVQrFBb3nKtcsOj1zCJxo1jyscepP4XAKClnlHjeqMVoSn9naAr11cxkXWMKZtZdt8yD8fqwOk9He7jAH0+AeNDkNRkT2YeQLGJq1ClVbNMalVDotXaCmpuFsFogr4F6k1tOEQhREtIE77qgExTxyvY6hsgJ09hqDJvljOjbsNaQSVcpfdsGA71BLOOQq0az/BY0CWdoUkcv8oRKrge2KmDvJ2bjFmbP9azXGnpreHToVsv7d1L0yjeEFZ7ZlCCsWrry1PZ2Y1folj7iTD4n1lSnzP2sPSC6XRUqy90h3A35bjM12mhipd7pGvtX3ucQ1LuMjouE9I6gIepOC9mjmr6EAP14MdGI/krpqul2CFfw2StlAsCTk8dwYYBEdkg9cXiBDJ/y14823q06Ot7+UHkytATh9Hf+1NPooolwSpU6ARIVC1Z5UjBEUN72H9KUt5oE6/Rc/IkWREcSuu7UQ1kZOdLvHvFSROT/+zXU0vc+4+xrEEVEmBPjjmpChzobXXFgJzXzKqe/6/Mkprxts/UTha6eIqCqgzWF3LYpJGLw4+eXyxDLXvbn3f0RvYQZhpXZyGYGfqrCAYS9M087qyYPEVJf1S8ljip175Bf5PB2ya6wFuf07yjFcwX9H/8FzCv+sV6+R4niMe0hbK11q8eO0kVFfu4PVlc8NnJr+8HlnKab3gBPDIcflyKT8bX41R9xlmU1E5/XNRqojny8ScwCzo625PrslYqXpEgbU1eE5m7j6t/EUIl6MDs7pOVmyu3PkFdZ7s+V4SlgyRexbb5qZik/Lr7NwNZy+VAK9hwjdmfAEuXBVqdwJurQnmb/CDlV6YP094qSWpbYou+Tx8p+FrABdzByHJ9zFpkfhJRSJfQl1Q7m+rk38gHpuxDAR8PiRL3g0
 agnuKDDR
 /3V/M2fAlZp9nt+GBnp/2BCDT221VDaTrz+01oyDI81uggVihmjGbbxHIGhMaVMzqk49qyriGqzvREShQ8y7+LOCAIxITg86c5aJ5if7kR8p9XZ0Ria9h2a1J3RcGCtHPdu06evqgTuPjXBvxnU6Q/pZCRdiiEmEt4nfw/p6MZU0y4DIfNzCb7pjaZ8xMlnl7Z8n+1iZ3vx6+QaZd5JSVKG1/HGht0T5w3vGS
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



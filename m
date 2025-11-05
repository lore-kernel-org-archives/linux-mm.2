Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BF8CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01C88E002F; Wed,  5 Nov 2025 16:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9738E0002; Wed,  5 Nov 2025 16:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFD18E002F; Wed,  5 Nov 2025 16:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDEF88E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:08:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D33613B043
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:08:09 +0000 (UTC)
X-FDA: 84077791098.01.47D7054
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0247240011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:08:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MvMmy9z/";
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1PNdgknOyyk2mzZmr1xYTl18CtGDJfdBKGGVXljgnw=;
	b=8qQYDPjs32pufeky7JHVUdyUV9XQ1Y3dYTdoqOICzZzl/JQMOizIQGrSbUWb0BVWu8FkUj
	yz9FYsj5Vgrf45rWkZuIB8bqQ7IFl9GX/Xe+wMiygsY3yu5Qv5/rtX2hrvMLH2qzQLZFag
	niYlMXPkWQmJ47F/1fFXyAPrjdqiYZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376888; a=rsa-sha256;
	cv=none;
	b=OVq2D7bDtVQjBebuHosu9ofxw9StGexskwfoO9J+KtClIEcZWJkuEopkYY+rIa3U62iPHX
	ZLFObvIpWRvZ2Lip+dsUy5pUhOB/ofbhkprBOQN2M6GVwfalg0gOdIk7kbr1P6SB/D0IXH
	Q5TDXK2SbK8L21pEWKGiTwjOODVI40g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MvMmy9z/";
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CF136021F;
	Wed,  5 Nov 2025 21:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4C2C116C6;
	Wed,  5 Nov 2025 21:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376887;
	bh=Jrc2SP9zuO/q8lVKXeMSZQ2TjjYp5fXU9+UkI2oxxh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvMmy9z/Tgk53O6EbE+zG2oKCMSZwHnfkHuPoSeCh479KVbDuJNzsb/Q95ddbdX1O
	 YQTf2wfL/dngH/FTqEV6nyuyONeRGG6HmXIoUpQYnvRwoBce1dGez5Rnclx/R54AJG
	 jF46uVQGSBmc+QMKekLAz3yISaEfO/lEUBh/VXH4j9x5/+pRiLN7gYF1+fWkOKQ36F
	 j1wBHxPHnmeF1FuhdLWetNBKgWb0hoEHcy6zOXnoMX7DeUEMTwVgqvZecZg7n+SX65
	 jdNVvmiqi+lM6qGacp0TkqxYpP3U9TZXPPfxP2T1eiIo+XV5uRXCcGxIxzrr4Zr+Kh
	 OUYcrvQZvJ2Zg==
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
Subject: [PATCH 31/31] doc: Add housekeeping documentation
Date: Wed,  5 Nov 2025 22:03:47 +0100
Message-ID: <20251105210348.35256-32-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: euyh837889h4kp67kwo7y46ersn6w8xc
X-Rspam-User: 
X-Rspamd-Queue-Id: 0247240011
X-Rspamd-Server: rspam01
X-HE-Tag: 1762376887-608877
X-HE-Meta: U2FsdGVkX18g1PsGE5Pw0UTvCOGbcrzCZ4Tok7kNxdeZ0PraNCnejRWuix98X7IXwbxTVlzslwMtEFe7PwPeAzv/jD6KBvjv8PIVlJvux84VOJOLi81XinsGUEGHhzVMM3TUyxO0svp/qaIJxffDMUXcTcKX+3ZrEHPiXjF0fQ5NSmO3cHFCRzWVyWpMS/3AFpBd5pqlvx4T6fDSfeRIhkKjyumRorvk+Av6up/G++UJieXbpMorzxMtOl1PPf8ZwDum3t4d9joDye7rG6LeDHF9GE5vNC1rVvD1AICzfodSdsjjh4aNvqd7uY8BmrNF/KDQKKMuIEWuAbrs49hak7AIxXrjKD+LooQhOcQcSjGFwnbReZZWTChu6fGiPCsb7twvH3uaE/+oPjsJOuNv8AfGgIn3g/Qcars65kfqRUsYrkTI+FV/ggSvCz/zQ7UTpd7P7EdPNX9QhxC7l6jRcnm7Ldb8dcyzBXsI5fMYS2ZUSjO9nyrCU/3kKE1GnNg1jyzMi8o0mFOdOLmvFFKj1rpDICM8ZmW7mJ3W5rweaIH3azwPXl7OQgCsxa9YZXs8tQDmXDX0iq4Wj0zfubBeWn0wgGRe028wfwh6Nv4Glju5BjytxWNeBrCB7dRzbGQS9zFHDr9IzaOWkMaGYgrb3TpFhzuSm32AA5mneSoe3IiWCDMypd2FAhhLn/BTocq6aihrLZvRGsBSoqrzQ8WFFs4plYI2bnajzjWc7cXHB24r0m1bOTydCsbIpirQ7swRZx9Gth/ENxmBC1rcvsBHHcLIEWYma2jIDnHYu4CtcGPZ1VdVXalB4b7KjR6p08VkHOYiZq1mhuKN84euvZd8YWtTWMVfaIWzaUpE5VfPWHjAcXc0JDUS+V2+JUrCzMVoriN0szkQr06+AzHMHXTH6xlb6fhYqUCbtQMZfJoE4s9EOyanvrPZ/e3r6ZIebBc3jdn9WloyduamVqy8xe8
 cSNzXTWQ
 tLJVZHClwGaVi9RquOiWkDVwApxCCMOIQqQ3MrTXusGgK2YvnvqIcd9AvSwpLlqo1BPlwdlKkCQbuIGts2XJJy3o1Syl9SmFWYvxBOumz8UdlpWN8139P2LbdJDQt2mWCmod4F/KTF2Sw2t234eZuN36J3jsO3fJDW8hK6jN/Lsz1glrhwe6EpgGAO1R/kNphRqWy7okTxI+ls1PxrA4s3ek49qWN1i/R0pep6A8oD0+/Zyg=
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



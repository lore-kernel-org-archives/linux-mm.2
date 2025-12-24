Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993BCE75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2926B0088; Wed, 24 Dec 2025 08:48:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08FBD6B00BB; Wed, 24 Dec 2025 08:48:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4B16B00BD; Wed, 24 Dec 2025 08:48:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA1976B00BB
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:48:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A453A89881
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:33 +0000 (UTC)
X-FDA: 84254494506.20.63C50C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F0661C0004
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NTnApWWX;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAqfyFkYxWQURn8MtHZJTlFTLli6VXWIVJyNhVe7Z5A=;
	b=4ehNjcQWpqW4l7/LC+dwU3EqIOf2YnBc6aXZnSFd/XLy2pelMqGaFIYyBigYnDkDFlXkZJ
	W30m9JxghdmZ7HjaRtqcntYWWz7yZ6Q1kYcBEUkqjXXEJyi21MRWlrByzzAuGNEGaEcuYA
	UZj95AG6EvoOWqSWwlLNPGVyKjqcvPo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NTnApWWX;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584112; a=rsa-sha256;
	cv=none;
	b=34eb7sGMhZAKU7iaRWRr+3/T3gTNH5/h5Gh+6BnNtbHQyj8Z/4cFvw3iPg6KT9eFRzouGS
	3MJwUvCHOrOReQVZ/+ghm0iKzU4L5HrWZzwBMBvolvP64SKAz3stgrDqjMMamIXNjpvxvq
	6NtM1/W3vgeHXj9Ck081+ZojBeFvuUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A94A6016C;
	Wed, 24 Dec 2025 13:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE8CC4CEFB;
	Wed, 24 Dec 2025 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584111;
	bh=n9XB9dCeDsXUL0E43Pc7dHYz3Tf4gkdsgPdoYnidBEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTnApWWXZalcit1DZtIrSv8YqGy/AEmuaJ1ytLbSOaQU1DGlwp+biEHefzJy/4Gr8
	 u0Bi9AwumLMTn7DNXMDWk7PORMipAXsQ/Apt5dWRZBLC5MH1S4snhe4dO7FLifm5jF
	 uj3v2ym/lu5ULC2Mnc7XbpMTRp7shSHNnyh6JMMTcjr6bqgSKPZaA8GLCFnJhbkx+k
	 8VyVanmC6kvrjiM5tGk9aO3ks+bsgsHiYXd/li6Mq1Us1/Drr5efu46JOO9V1qAnQ+
	 gQ78yMl9xL0xdnHFkYIyYGgHL7PQCR4qcwqnia7IWcK5mjoHZQjc6gu2UFjw4OPcaF
	 Fyi7um4IAANIw==
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
Subject: [PATCH 21/33] cpuset: Remove cpuset_cpu_is_isolated()
Date: Wed, 24 Dec 2025 14:45:08 +0100
Message-ID: <20251224134520.33231-22-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F0661C0004
X-Stat-Signature: 1cbr5h594y166wfh1y5pyw17x6a7s766
X-HE-Tag: 1766584111-85694
X-HE-Meta: U2FsdGVkX1+DVVCh8v1NwlIdUw4acUkeXZHqfWfa/sHCTYzMD9B3Ufx7ciUFBVwxtj58oJk/Lvx+CABdPzelEfHQXxDkQl0/JonDUCa3NXzCDkafECyPkB2/wDCo2nAOGCNh7Nk4RLXnS81clI1Yi4eq21iUXTcuN1bkEOhGTmA6LS3aYrkTFQj3Ji6RW9pTxuMQ26oqkyiNohfylUB7ofK82W+wvzPtOuMSoEXp7JRvuoWkUqo4fwepHtZvNseBWKwg48pF9J3IeVxmczh+j4PhZ/kF4SRpTJkBXG3iex+u4d+lSe2AqOt0GYeV9g3pxNNyvhFkZVTkhS2jkrBRC7osu4mUEngNUZYltSsBXeRXgnxgAVfVz4SisLyXBXDx4kyFTdYesKuFR9ro/wdl4k47bWiLLRJVj5pcIw/qM1s+wRcGtIMd3Xm2e2O/DvOECUbqh2r4CeGcFhd1r4lXPqqJcXwpMaU+pREPj+SLOcvOpaN0AMhrfsiaD0vWkXLPMwhMLUPntjzG0GFIufXouG1+zwJdvl2PTWzFosTUQ7uzvS+6o+4llZ0bTx9xFA+M4XrelJ+Qai4jUsWMOJc2Q1Rrhy5rqYSPhFpt55iyH2bJBu9uZYbbK7QAXdr8qHLiPE5sG+1Zb8Yhdi0C7OWmXOX2sNJYVo32nTuHtKL6Op+j0Zi0F3HeGSGNWkHgo3EuPWQW2jvzKdgJHQDt3q1I8hsAbqIjaYeSwtPGF6lLJC3xHOE0OtA9XK7TFQjrb1FhctxMqstNedyZ7B2jwzgsAXW5c9M6vz9IzUh+pM7xooVruPGYmpTuIr/n+SOfnmoOA7vx9Svu11lR/Oze8s521HkjxTKj3kQF6E89Ayckeg3gBje3cBcoFwd8vbeKaWWXeW4a5HnwCh36M7QEKl3dnlBl8UdhX4uCcclXInZYxhaoEyD7GT+CJmRnIhgrb+3LXzDBxTexRU64ru/jnvR
 3dILaU82
 8vGxMgdeYPFrUl+cr4uKLKacFssTsP2dtT8nC8bqP8qaKMHmI9udMP3Kpv8hq8Lio5ZCpTfnkM040gR5oXBEbBBWmmobfLuAghCTBFDnhwR9KwoOvHual0yOnLJFPQAeIJJ9ZLRgjOX2sLNRMcSskChNWE9Onymr0aNK+lL2uhmNLGQjB67UWZ2WedYjoxb5Av5uIGHHX2xYd5Jzt5z7DplGs7a6lnDcdaN5iu09liafnNlyyGmJWP7dLPaY431MdTmGXP7hxA+RLWqt/IkfmSEyJF3P3FzxlalYTqd2+zu5lGPo8HApu71WcnlBklGUnsqM8y2UIYmajT6lVUuOIbjucU7EdSJxTadi4uI7T7mNniQw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The set of cpuset isolated CPUs is now included in HK_TYPE_DOMAIN
housekeeping cpumask. There is no usecase left interested in just
checking what is isolated by cpuset and not by the isolcpus= kernel
boot parameter.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/cpuset.h          |  6 ------
 include/linux/sched/isolation.h |  4 +---
 kernel/cgroup/cpuset.c          | 12 ------------
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 1c49ffd2ca9b..a4aa2f1767d0 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -79,7 +79,6 @@ extern void cpuset_unlock(void);
 extern void cpuset_cpus_allowed_locked(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
-extern bool cpuset_cpu_is_isolated(int cpu);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -215,11 +214,6 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
 	return false;
 }
 
-static inline bool cpuset_cpu_is_isolated(int cpu)
-{
-	return false;
-}
-
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
 	return node_possible_map;
diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 6842a1ba4d13..19905adbb705 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -2,7 +2,6 @@
 #define _LINUX_SCHED_ISOLATION_H
 
 #include <linux/cpumask.h>
-#include <linux/cpuset.h>
 #include <linux/init.h>
 #include <linux/tick.h>
 
@@ -84,8 +83,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 static inline bool cpu_is_isolated(int cpu)
 {
 	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
-	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK) ||
-	       cpuset_cpu_is_isolated(cpu);
+	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 25ac6c98113c..cd6119c02beb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -29,7 +29,6 @@
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/memory.h>
-#include <linux/export.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/deadline.h>
@@ -1490,17 +1489,6 @@ static void update_isolation_cpumasks(void)
 	isolated_cpus_updating = false;
 }
 
-/**
- * cpuset_cpu_is_isolated - Check if the given CPU is isolated
- * @cpu: the CPU number to be checked
- * Return: true if CPU is used in an isolated partition, false otherwise
- */
-bool cpuset_cpu_is_isolated(int cpu)
-{
-	return cpumask_test_cpu(cpu, isolated_cpus);
-}
-EXPORT_SYMBOL_GPL(cpuset_cpu_is_isolated);
-
 /**
  * rm_siblings_excl_cpus - Remove exclusive CPUs that are used by sibling cpusets
  * @parent: Parent cpuset containing all siblings
-- 
2.51.1



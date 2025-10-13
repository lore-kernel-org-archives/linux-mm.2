Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDEBECCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E218E0078; Mon, 13 Oct 2025 16:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424688E0036; Mon, 13 Oct 2025 16:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A198E0078; Mon, 13 Oct 2025 16:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 229A18E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:33:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E44E61605E9
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:43 +0000 (UTC)
X-FDA: 83994241926.27.4BD9BCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4A0521C000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kMPyVftY;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJyY9iiPaITFRDOTyIUc/nGpefxbz5qQ8u5Ctbbjk4w=;
	b=G0R9IsX1AJuKSbyU/+0hobAw74tICv02rgQl/3aCPtOZrH5mzKUvk5aEk6s+do/aaBS6ck
	gRmelJkMClDA2q0CyX1Igl4Sm3gu26ocs6i1pmV7Z/hHVAyzE5GyqqgWxM9ifYJOof0Gzf
	7bdNPSnLJYNwwHA25tTEnhP6vJ1Xzj8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kMPyVftY;
	spf=pass (imf21.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387622; a=rsa-sha256;
	cv=none;
	b=2214BL//1Lsqfi2nJeiq+xDm0ex5BBftjHIpkqegotDSR9ingGy08ckvtqqTez+so61Ghv
	fqc7ypco3p4cjqCdiCUrYeGBLHWOXZYGqn52RyhubX1jfEkk55MTvLbyjkP6C9VmNn6A8Y
	hsznbsXB/seGnAkhLa8RWloiSeVyKao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BCF8861E1B;
	Mon, 13 Oct 2025 20:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E1FC4CEE7;
	Mon, 13 Oct 2025 20:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387621;
	bh=mOrMHInwUUAF5x2TPu0KohmBJDCPDZeedSNBGf5P0qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMPyVftYiGwonaPxPkSe84brMb9jqYboCwHd2zZBPRDl08dCi7W9fE2s2bthYnXhd
	 sumWJ+6bP3nbIGMrekCn/4W0sfHr/ZjeJqracwuQnQZtgB0r8+ROWsq6904EhhmAJz
	 lYhFT7jbWsj8yiFQ9tWF3MRKSvUn29nSSC6k9CZUmDsbtednhzyAjB/ypOW2I2fxDM
	 0HwfUM3M36s1BBQZiiZIkw4s2Z8YOmSjMugkiJIGNXGi0yn6c+xcd06HDEvL9Oao85
	 CB+af609sbR8m1MH9ROYKIki0Ke9Od/QppZoiPx17IV5O6heaqv8H11HIHNsJ/wiVc
	 h7ERmhn8Bw7ew==
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
Subject: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Date: Mon, 13 Oct 2025 22:31:26 +0200
Message-ID: <20251013203146.10162-14-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4A0521C000E
X-Stat-Signature: y1sc8916it5gbbngmwku1b7uca1m9zci
X-Rspam-User: 
X-HE-Tag: 1760387622-308617
X-HE-Meta: U2FsdGVkX18t6i8CgPJElHaPtbD0YKAlB/NJMmNYV2DvAV8msldiWgTSpxzULx/wAe4virTsN6W+E3MwrvW47aTPjaHT8Df9BKoIKNCJvNLUcZMl/IoppnkeQCBWS+AAwLwqSqOQJd7j0TrFP3WrH8VZD023KjS2falCd0nmNJQI4sxpuwaRkxGouGvoZnjIm2n+ozx1uIMcllgoo/zbO4mROvM7kapVXbEHwlRBEWVLZ51KPcsaQj6wmO1j0A3xAs0r1KiSfYbl28NU2q256p7FRn2GTqL32gmyaFxKW9n22Xtk8KLmFeuFXDtsCmYv/qckERxl4QwVJpchlmdiOLNqUNcNaqMcmv8d2YFuMFg6Ruhumuu/DhxZlqO/cU3Sj1twHfr2HVycsp4wANBFd+A+dC4FWejLf5LPXRlkFt/VF6Ezdffymj45VRdQWLeiBweA3r5Rk/gWJ6/EPVhDfEODwkVqeQGSKL58SUEvCJuJGEjJgTdssFrQiMPQDnHqky74v+eULK1/Vjg2VZxgT9a0pJz7CkGPcEGcpQot0E3YfJtdjrE19fFMTr90xqVM7Zmczq5KTcBN6oPSowOBWrtv2kWKm8snNalyTELRzNkF5Ul/CY2rruie77jsfPGIrhfpoge+LCV8L1M5mRE0I45fFGceyLPFUq923zZVfSJCUp+RjCKuoCglORZXP7epMzlWuRyzXpJsavzgEuPlMnTQLrqCqKhoRIXma44sKSTldrFNidBNMn2XFIRte42pYa1uY+tIhdW7sYOdq7t7w2xcSx4DdSxoSOFQFrmciu/ABcVcZ9Mkz8OMGOq4MpYHLAAJgpK/TmEEuQOW4dzxUWVyRdOMCMw1N86+0JyP2ewQtY7yAOeLLd5JE7ZTaJKhZZtHdeuQyDdUpT+vdOWTgTfMEhpf/UrunTBF7O80yq4GwwQ/M5B10b1IavFzUKThEw4oDTLAHcNoHDsIKV5
 yws/v0KJ
 gD7qWN2fY2sw22yXhruu/GeWizeJ0kFOTk1ZrNL69ZnWnBD5XsA2vdBB3WuQqGcYb4RtpaZ0KtT+WuMq2Y0nigiV9D5yB63bY3+cZUY5xAgWmbFPPrgDor7Z2XKnxgNc4Z58zehXUfhpQbyOk6RAMHmjtm15btToIJTftnGd7zXBgAaigBqfsIDGGgl4g+8edvMQuHCVOFWbzCC/XnI3Uu+j7FfaXqDcJZJzRvDKF5PKq7gBXSnkoMqPI9rlTe/PjktEFJDS6YTzpRkp95k38jPbj/EulmsuxeqvsqyiyCNHBOIvZYnGNxfQaf5g4sKtmP/3g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Until now, HK_TYPE_DOMAIN used to only include boot defined isolated
CPUs passed through isolcpus= boot option. Users interested in also
knowing the runtime defined isolated CPUs through cpuset must use
different APIs: cpuset_cpu_is_isolated(), cpu_is_isolated(), etc...

There are many drawbacks to that approach:

1) Most interested subsystems want to know about all isolated CPUs, not
  just those defined on boot time.

2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized with
  concurrent cpuset changes.

3) Further cpuset modifications are not propagated to subsystems

Solve 1) and 2) and centralize all isolated CPUs within the
HK_TYPE_DOMAIN housekeeping cpumask.

Subsystems can rely on RCU to synchronize against concurrent changes.

The propagation mentioned in 3) will be handled in further patches.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/sched/isolation.h |  2 +
 kernel/cgroup/cpuset.c          |  2 +
 kernel/sched/isolation.c        | 75 ++++++++++++++++++++++++++++++---
 kernel/sched/sched.h            |  1 +
 4 files changed, 74 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index da22b038942a..94d5c835121b 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -32,6 +32,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
+extern int housekeeping_update(struct cpumask *mask, enum hk_type type);
 extern void __init housekeeping_init(void);
 
 #else
@@ -59,6 +60,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+static inline int housekeeping_update(struct cpumask *mask, enum hk_type type) { return 0; }
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index aa1ac7bcf2ea..b04a4242f2fa 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1403,6 +1403,8 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
 
 	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
+	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
+	WARN_ON_ONCE(ret < 0);
 }
 
 /**
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index b46c20b5437f..95d69c2102f6 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -29,18 +29,48 @@ static struct housekeeping housekeeping;
 
 bool housekeeping_enabled(enum hk_type type)
 {
-	return !!(housekeeping.flags & BIT(type));
+	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
 }
 EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
+static bool housekeeping_dereference_check(enum hk_type type)
+{
+	if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {
+		/* Cpuset isn't even writable yet? */
+		if (system_state <= SYSTEM_SCHEDULING)
+			return true;
+
+		/* CPU hotplug write locked, so cpuset partition can't be overwritten */
+		if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
+			return true;
+
+		/* Cpuset lock held, partitions not writable */
+		if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
+			return true;
+
+		return false;
+	}
+
+	return true;
+}
+
+static inline struct cpumask *housekeeping_cpumask_dereference(enum hk_type type)
+{
+	return rcu_dereference_check(housekeeping.cpumasks[type],
+				     housekeeping_dereference_check(type));
+}
+
 const struct cpumask *housekeeping_cpumask(enum hk_type type)
 {
+	const struct cpumask *mask = NULL;
+
 	if (static_branch_unlikely(&housekeeping_overridden)) {
-		if (housekeeping.flags & BIT(type)) {
-			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
-		}
+		if (READ_ONCE(housekeeping.flags) & BIT(type))
+			mask = housekeeping_cpumask_dereference(type);
 	}
-	return cpu_possible_mask;
+	if (!mask)
+		mask = cpu_possible_mask;
+	return mask;
 }
 EXPORT_SYMBOL_GPL(housekeeping_cpumask);
 
@@ -80,12 +110,45 @@ EXPORT_SYMBOL_GPL(housekeeping_affine);
 
 bool housekeeping_test_cpu(int cpu, enum hk_type type)
 {
-	if (housekeeping.flags & BIT(type))
+	if (READ_ONCE(housekeeping.flags) & BIT(type))
 		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
 	return true;
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
+int housekeeping_update(struct cpumask *mask, enum hk_type type)
+{
+	struct cpumask *trial, *old = NULL;
+
+	if (type != HK_TYPE_DOMAIN)
+		return -ENOTSUPP;
+
+	trial = kmalloc(sizeof(*trial), GFP_KERNEL);
+	if (!trial)
+		return -ENOMEM;
+
+	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), mask);
+	if (!cpumask_intersects(trial, cpu_online_mask)) {
+		kfree(trial);
+		return -EINVAL;
+	}
+
+	if (!housekeeping.flags)
+		static_branch_enable(&housekeeping_overridden);
+
+	if (!(housekeeping.flags & BIT(type)))
+		old = housekeeping_cpumask_dereference(type);
+	else
+		WRITE_ONCE(housekeeping.flags, housekeeping.flags | BIT(type));
+	rcu_assign_pointer(housekeeping.cpumasks[type], trial);
+
+	synchronize_rcu();
+
+	kfree(old);
+
+	return 0;
+}
+
 void __init housekeeping_init(void)
 {
 	enum hk_type type;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0c0ef8999fd6..8fac8aa451c6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -30,6 +30,7 @@
 #include <linux/context_tracking.h>
 #include <linux/cpufreq.h>
 #include <linux/cpumask_api.h>
+#include <linux/cpuset.h>
 #include <linux/ctype.h>
 #include <linux/file.h>
 #include <linux/fs_api.h>
-- 
2.51.0



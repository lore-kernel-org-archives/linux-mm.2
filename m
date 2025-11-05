Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8D1CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77A48E0022; Wed,  5 Nov 2025 16:06:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4ECC8E0002; Wed,  5 Nov 2025 16:06:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64B98E0022; Wed,  5 Nov 2025 16:06:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A545F8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:06:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68FD287C1C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:27 +0000 (UTC)
X-FDA: 84077786814.21.856AD25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE36F100018
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rA4n9pw2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376785; a=rsa-sha256;
	cv=none;
	b=FzxPZifsMFBU4P1hWAgqVisWo/nQ/4RKEfU5t7Uah5yKiNfpvKDL47gOJlP/gdSwKK6qoA
	gv2lxqkVX3fyBOHdfnoidlj4n395DUbwG2qWv8Mrcu1fmJrOMarqKcN78aJ9Ta5YyEg3hg
	0Auv5iO7mESxPQHnKEfJMpOlC2v4Dzs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rA4n9pw2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfHcNOjs1vVxo7ZbicdZoCFdzxjO2ktx5+teVjDma8g=;
	b=pmpd6aqCj8HMp4/PFwo/IwID9MTW/iy9Z2HaIrZZ6K5poT//OBz8AKdaoC/FuE9eXOrFjQ
	2rz0dpOYTa1zv3SvyAwvBllsEFBqT4z96l2weLozitnJ6RIx1CQE4nhhxxuyqA45GJwJSw
	A8aV4sGMfeljcKmvILLOZ0oTMGcUcIU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DABCD409E3;
	Wed,  5 Nov 2025 21:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A479C116D0;
	Wed,  5 Nov 2025 21:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376784;
	bh=1PXFAoSc5EaQ1yzCGftJTnGf1OCO/kq+1cRjiff+B0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rA4n9pw2FOv+9hxUmMxi6GGt4SJ3mYCQWb06W9IiZHm52r67O+JOAmfjrIMDYzNSR
	 7hhMjSR+V0LaaEHgGb4EMGkqcbc7bh4k157CK1CGKnWGgH60SQaTfVEcf14bx2R1a7
	 W6AmRByimN4vv61qfnqKvrVtt84nUxX+ewRIrIERljtsHj4WPpzYQzQ3ro10IQ6UaJ
	 i2NEpKm2VX4EY/sin6yFQF7A7VLkFpIueTpaU6/WWugVABg+bzYoul5wol8HkxJPqI
	 0HmF/ZV2mQzCZGdW4X6JtSqcQOvv8qs5gwBPd8rNVz7Y8l7f4Pvcd6F+y4NHWaQkyb
	 mwjWG2dqzoj+Q==
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
Subject: [PATCH 18/31] cpuset: Remove cpuset_cpu_is_isolated()
Date: Wed,  5 Nov 2025 22:03:34 +0100
Message-ID: <20251105210348.35256-19-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE36F100018
X-Rspamd-Server: rspam07
X-Stat-Signature: xcqx5e6xj1f5ej9441efrt9jjwkqk6jg
X-Rspam-User: 
X-HE-Tag: 1762376785-16417
X-HE-Meta: U2FsdGVkX18CUXytrsa+84RDb37glI+AlVYE/H0n/HlSZXA8ih/W85dUrbSEdvjNX+vFDY4Xhs07iEjQ6MuLV3NBW3Sw2x9fCQbbiqOFBOSbmdxNPOy9sqTeAy7evLiNgousmM5+wjHNjEdW36a0l7XMHb7D1fzfmWpN4HJG7WYSy/Aw5JyW9cO9bJYxsthxrR0jOKCaPMRreFJFMnqCeIbUu82BXeTiW2DUN0Svry1r5BIoCLVruoAGkNRGvzRqWNcJ9nXq5bdyO1tor4PqkCkSpguLPZYTzaMrXdCafqJHgPIXOwImugSkGdTBaa56Q9rUhZosIZT9RcBQFHzYSrD0EYhDOuhVuilPCLheihExhLsdSy37A0zOxXXx7FjO2uTA+cm73rZN6JQk0OY56B+2TJFDaY8fb5fIHvPFfx106mpr3fJO+aoCqmvC/FG3jL+Z8PrXEAcRKMHXeOfIZfnmUDgWxhiWsMQZ+SJKIoyothBJWpxUYmS3TILNFCkXTomwyeomOXhZ0YDdY2R83LcWY7r8oMQr1oosdQARkFagDxdRN6fSRt/7AFZgzszpx8r+0A3cubH/yrgu/nGQ7mclVVMgQuRptN7RhF1e4pVfXDQ6e3+DcuVL2IGqYBRQeh4YHQ1hl2WFnJeCedmAuAMUd+Ik8HDSCe4z5S1IfxSWwMSoXHfH985PEg2u1jhDOs91q8OaWQVT20ai19LU0dmNj3F6hkigpt2JmygcTVI4eroDYIE/RAncJMAPoU8V3lvs1w9Y+q1Pmr+jw2hmAvFgexXOqlEQZHryBmPc2RIpoSYxn5M63tuUH/aVaZUteta7EkyWeFsxfgqFM92KF3yX2gQ5zbMg8+muXNvILQne8S5u11olCr42nNVmRrJEPohyOdj8+aXtbrnuNRmMqQiUm6MQBeFovmVPyzXEsr/pdv65RpW1V7Ql/8S6ga5TUK5MNYwTgIGz4Ngq2E5
 YjMK89PY
 viRuQ9oud8T25NHzY6/vkJLagv92vVdhDc7IUFd4EHvgoDHDn6KW6eV4tsoRIO5EMXwtRjK9cT/y9eNg24bCFOuYyVnmismZbiOSsW8E4xly/QDBZUmjJL+NlHyi6r5MFrlCpAels7UIUZ0VvyHFwTWxNICpWUFz+2ml1AvpBGp+7jLP0G3jKKxR4W5IexBojr6Pj1dRPxrzxzAl7wvENc0kv1gmdKakykldXS1cu2NldPf9rAc6yKThdK1s6krYYvf3k/v9JLkd+N6Rtz1Y3H5+CqQtt69/+jHfcrn6k0MwpqH6ZiF8xw/IyJdJuU8K1C+MU
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
index 051d36fec578..a10775a4f702 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -78,7 +78,6 @@ extern void cpuset_lock(void);
 extern void cpuset_unlock(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
-extern bool cpuset_cpu_is_isolated(int cpu);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -208,11 +207,6 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
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
index aaf2a672f8dc..a127629adb32 100644
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
index ea102e4695a5..e19d3375a4ec 100644
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
@@ -1405,17 +1404,6 @@ static void update_housekeeping_cpumask(bool isolcpus_updated)
 	WARN_ON_ONCE(ret < 0);
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
2.51.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83272EEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2896B00B9; Thu,  1 Jan 2026 17:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80ED6B00BB; Thu,  1 Jan 2026 17:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86D56B00BC; Thu,  1 Jan 2026 17:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5B8B6B00B9
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:17:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93AA113CC21
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:08 +0000 (UTC)
X-FDA: 84284806536.06.F9B9223
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D75081C0003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJLuCa3i;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/1G4+sZ3iljLQtCbrDC0cE7D38NTHdeMPyplnQEilI=;
	b=I/xg7MEFyvqe2Pno/UJJWfuc10OusjpjXz1/NOL+fJa5LQxthexvehpG/duN+5CFfvuY//
	DdoH3sCG3yyiysO6y92WjTIPJAfW8Ygx0ccYLVBRrbN97gFDiOFuD7k0ZdlA+nDBRS7kfR
	iggjOYgAwCcX919uBDNbLhuKbWJ54bY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJLuCa3i;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305827; a=rsa-sha256;
	cv=none;
	b=HZW9WpJs+fsc3L9BKkOmEDiEhsx3m77aHJO9zRabKcFt5QzpkObq69wP5olmg8hIsfBe6W
	i3ppczyQLKiSX47m3KxJNmYPlj/e6N7U+oJm68sFU1KWvi8/U+yl1F7gaWdbFVw0u07RQy
	1MNK789E2qQ1w/rIFlIv/TAceStdN9k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F7CB40AF4;
	Thu,  1 Jan 2026 22:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9211BC4CEF7;
	Thu,  1 Jan 2026 22:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305826;
	bh=MZh/70k9lOhqSg5WVM7HlPDgI+aR1XcYP1gqEcla7CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJLuCa3iG6Sm7iktwt0+ApaoTltF7T5PkNGYT+0FP+cENPGotvk+AtxV9gYfGxoRh
	 FYbq6OQBiHVnSQG5nNAU0YiaAfhwF5/3MnrpsYLCnxojpjheLBAiqwStH81QUYHdxU
	 QpWa/jJVwJAJswYmswDQWTt2J83Doun9lTzIbCxG8voxdXKjRZqTSyWamEjR/gAGoX
	 APgwNFXFMvnndf4ZCm/g3oTfWdIkJ1NSL9gGsqGDP0ElfG70njnTdR88WFR1+jKsPv
	 73vkg+OOaDpu4dw9cDanjVgYrwdaQjwrdcCXTitveYJo3cHiOsWXE4POuBaBb5mXgm
	 rWMcFaLv1toEw==
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
Date: Thu,  1 Jan 2026 23:13:46 +0100
Message-ID: <20260101221359.22298-22-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ydfrzoo7dtqonneen56qeyqw6cniosh5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D75081C0003
X-HE-Tag: 1767305826-731642
X-HE-Meta: U2FsdGVkX1+xqU27dIjM6pbB/Gm3GZSbyNXpFtQr1d2eGEmgqrM9eZhWUlch9zQYWLrl5dC4zrDLAZ8P+qnBz4RCgl+yfFqyDSt7q/0DEl7daes/cEy4jOotvCY2UgUu5voRvAebOC1kIQJHKsX2fsQbreWZgr3dYWdaBuwt5CuVM6BYNTVllnwinY+5jzk6HEuXWbtWJIIcOK8n5Ci9/jpdbYh8bzfWBrBB6KpqN0+sqHDPIpkD74PzHH+vDudTRpXPXhvi1bfzKdCLkDuc2lC3hrliNUAWPfJT0EB0sdSu4+XRwoc1zO1CthCzdcjfoweAttGT1tl9az6HWPMI35NufUTklcG0uVgrNQ/m568May7Ri8KYzAHY2wuSoTXIv+GOeMtrFZ4tDrGxGDvBAoUHOZlOI3C3TU7g2fKEqV6W8KQ1Eoly6uCUKm3fGB5sTEb+TMTY9UGeIx4yioX2dsaCrq8CWbqW4nl31N82IaLCImdgUtZX0buPkNUVhUw9SCQt1v32V8LCAUnx12X1XPQSuYt64sgKOtt6RFU6xAbz+9Rb8uqFkmp6AmpS2uRnFE1+j371CXP02el+e/Yk34Niy2n8ieXrVZZXc5/F+8cTWv0P1eNUsmNNKzacWSMrQmCXBPJrxwvo86hc/sFahtSi1Koq19u3tvkiYRyy7sonQaEAeHFLHJriKorX3Wy066NMynVHS9qgELWwe6CnLe7gBgpNbjhvoFu5iC+84cvHBImoFNoUMPXiy2tZw/JU4SjFzUjHLfhyPOvAGJyA6gfZZ1pZGgtDMINX1rSNJYmZHFYZKkMa/UEcQPc/OV/gLrBOdZNKl02hHzBlStOa0BHovV2OyNDu6pN3scQjIYXiFV6gBm4AMlVCeZczxtbBjiktW48v1/d5DQ3q049hSemOqcwAqcRS2jwhdslc3Mporr9dwhUEwECfJiQ4Mh2+OjIiZjDureIgI25FH7i
 15pSX/7I
 AHtB18COB48tW+xTWBZXy9iNmuJM8lpIKxs8CckXTzaiH4IoqKlmnRtIqUm09XJxFGVOznPCyBj84zmGim3cD7Opr749NUi9tPwwcwycRugfykRdqXe3NTECdjtlvX8iEqWsgyfVhLYSzbcan4EV88kWD/Udk59vPa4shIqFTu0FF7yZU2WejXDyd1+URPrC96d0BzyzVlyZwmIOd3K/CVQOuxHgb7nneclEB1axvuHmTT1c7Ki61sa5WL3TL7wSFcyWfhyoUuYmDeR6GkzyMyFpa+OeOYVqhy8b5vVhdAI2UH1dNTH1ED1dOV7P5e6qxZ+So8Unfg495ukHXbAtysa/gv0K2DD9pR5CP
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
Reviewed-by: Waiman Long <longman@redhat.com>
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
index d8d9baf44516..d0fb0f647318 100644
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
index 12a47922b7ce..de693acc9254 100644
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



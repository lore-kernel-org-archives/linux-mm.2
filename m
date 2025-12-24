Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2287E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3440E6B00A5; Wed, 24 Dec 2025 08:47:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30AAB6B00A7; Wed, 24 Dec 2025 08:47:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D6A6B00A8; Wed, 24 Dec 2025 08:47:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCC06B00A5
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:47:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C360F57946
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:00 +0000 (UTC)
X-FDA: 84254490600.16.A78332E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 394F4140003
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=REhxuoO3;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wizuhTN6mGlwa9nDLf8YTsLN8D8vmBJXyWiJsoAfY8=;
	b=O4cuOPjVLzhmXOEOGzUO9JY+b8aroWR4H9KcVbvWUgOtNQ+quzLX6qytHVPDA6YuiIy/bv
	5mhd6h4LxzRKCy3kIhLFY90wQPFXq/NSIUCrnJ3QjRdnmk5TErCtJic67Ba+g7wNuzHfCa
	hBna3rjkkf0FRqNrXhd93YDgtDgYI6s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=REhxuoO3;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584019; a=rsa-sha256;
	cv=none;
	b=s52AwUr/euPqs7rD/tAtz/2NX6pW3UTy5NSSY4lER3nJeRVTEfwn3uWnLI/IC97zRSodYm
	nrFdfNn4hwuCqX0cfmDcRNQMdnrq7dBuDiOPJ4CamrIKG87U1c7T5h6e6vp4tF1vvt2z8+
	S8kOZdfsmkV94f0WRxssQfeiE07P2G0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96066600AD;
	Wed, 24 Dec 2025 13:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E85BC116D0;
	Wed, 24 Dec 2025 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584018;
	bh=cfBsUi49kwBpo1bGsw5oqJU14C2/JcinY0oHFYzJ/us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REhxuoO3IX20hXtECaAueG16NscS9v1kyy5t+tUn35175JOSmkEnv4SvDaoazf7ww
	 YBpD3lRKkH2447ENW80qcP37hFyQ1nh1kM6Hopa6gcqmxGAx4vr2zZBbYP3naQ8kNq
	 JrEdcRRdPKO2q4yT5ATlv4ZznyMVYjlX6EfL2jmCsj2VIQBRGH8y3lO6py7ylcjmZo
	 efrxzY9JDKc8YjWfLnEDN1BYAYTzeNsIu534qaYrwScoI/mx5NKToLKPBHQZGg6upA
	 tyOavV43+aqYi1yHJHwWrGKQTWYuBo3NPayKJq0vqYJU7MJ+xYxwhGTXnBMYZ4J8UH
	 wWeA2GZaq/CLg==
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
Subject: [PATCH 10/33] timers/migration: Prevent from lockdep false positive warning
Date: Wed, 24 Dec 2025 14:44:57 +0100
Message-ID: <20251224134520.33231-11-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 394F4140003
X-Stat-Signature: 7eu3whogfawoseeeozqi98r7ecupgity
X-Rspam-User: 
X-HE-Tag: 1766584019-934612
X-HE-Meta: U2FsdGVkX18ymx/NJZgJh1eijetoF2V0JRFJMjpGTS+SmoGeG5hUTH4+qhclm4V5W5mjKRVcMb8xsKQMSliEx8ynsbZJsIR/cm13SD+bSpUuuPE0VYk2fxxQ0w5yiNSgbgbB+8ArNlxkEOwku8P7lPVQvNipAkrKx8E2z9Sn03EFh5wt4of7po2LnStj5nHypStZPGw65PmJoFwozX+WJlRJcp0dpwpqYzLNHwyq5QygxRnBbOosfjrgp+gFMxl3g9m+Wol88AUXET1k3JwUF8z6l40khlpa/IZf6uh33/avyhJYfZsyZIz6+Y62/euf3GTSmnE3SMFWunaRbU2KDDGwzIA/Lt7+natU1zrPRhrK0252su+q7qy3LyWvIL6lpHkp14Um2G+AmPXWiAOvW+7/y86tk9F0UAt464WC4ZHwNYY5rvMjImrXeNccvqFv9uiFku1PY1JI7xu0aDNa3wS7ySZGo1xUxZg/qcmJDEHWmm3RQn7yluHexbKEcHHCuNOvUXAyy0ouCLp5CpqVRj4BMvy0XpjAaHUHJFogkCpyU+4KHW2iUa6F5a9/qR2Sb1FyFa8bhE0l6j8nwwAxMvWvk1TgBrz+qO+rRsM6r2FB8JyFvFDFUKUBx5OlAsQ6OhDsMu2x1IXjelT4NhwPEgCfm33TngBwzPbBEzDTaAkiiVb3Hn5UoyBILrbXczW1jEtJn7twTB8tt46aUPpEBxMKbVBaxgGaYSCxHqCMfV24g9lvK3Q6ULkwrUn263/RIEHdvIaKuQ6MxZBXabC9tb3lXBPFi8BYcOXCAB9eFtCKYc5BJx28OGUWzWpW79zk9EU1ZTMromh/b7sLpEvQY8mR66QRXJzexHj/NjgyUXpJWJ6rYnM+9gEhiCH7sFH2/B6LQJw+lN13COD4nRiF6W+boHi+Anu+ehOgxR5bSrgO7gKMjVMjryx/PCW4zWyviVxsUN1KRJz8qcXH+rd
 rNpZUFf8
 GosBFTRXuzLN5gsre2CgI1Qjz2kbV5JQy7F6YMxiqQ2kDRXsjbfNSVcz5RcCBPIeDLXlFJ6WzqC7R5u/i712x+e09LjuozaYiJ3hRutRGASUc+RO2J+ejT+aSCszW81Z9rd2ZWRver61e85OhqcFyWBXl3cZYjBVuJTaq+couHzFTtq/vNLCxGxhuyWy0XdK9CmGt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Testing housekeeping_cpu() will soon require that either the RCU "lock"
is held or the cpuset mutex.

When CPUs get isolated through cpuset, the change is propagated to
timer migration such that isolation is also performed from the migration
tree. However that propagation is done using workqueue which tests if
the target is actually isolated before proceeding.

Lockdep doesn't know that the workqueue caller holds cpuset mutex and
that it waits for the work, making the housekeeping cpumask read safe.

Shut down the future warning by removing this test. It is unecessary
beyond hotplug, the workqueue is already targeted towards isolated CPUs.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/time/timer_migration.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 18dda1aa782d..3879575a4975 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -1497,7 +1497,7 @@ static int tmigr_clear_cpu_available(unsigned int cpu)
 	return 0;
 }
 
-static int tmigr_set_cpu_available(unsigned int cpu)
+static int __tmigr_set_cpu_available(unsigned int cpu)
 {
 	struct tmigr_cpu *tmc = this_cpu_ptr(&tmigr_cpu);
 
@@ -1505,9 +1505,6 @@ static int tmigr_set_cpu_available(unsigned int cpu)
 	if (WARN_ON_ONCE(!tmc->tmgroup))
 		return -EINVAL;
 
-	if (tmigr_is_isolated(cpu))
-		return 0;
-
 	guard(mutex)(&tmigr_available_mutex);
 
 	cpumask_set_cpu(cpu, tmigr_available_cpumask);
@@ -1523,6 +1520,14 @@ static int tmigr_set_cpu_available(unsigned int cpu)
 	return 0;
 }
 
+static int tmigr_set_cpu_available(unsigned int cpu)
+{
+	if (tmigr_is_isolated(cpu))
+		return 0;
+
+	return __tmigr_set_cpu_available(cpu);
+}
+
 static void tmigr_cpu_isolate(struct work_struct *ignored)
 {
 	tmigr_clear_cpu_available(smp_processor_id());
@@ -1530,7 +1535,12 @@ static void tmigr_cpu_isolate(struct work_struct *ignored)
 
 static void tmigr_cpu_unisolate(struct work_struct *ignored)
 {
-	tmigr_set_cpu_available(smp_processor_id());
+	/*
+	 * Don't call tmigr_is_isolated() ->housekeeping_cpu() directly because
+	 * the cpuset mutex is correctly held by the workqueue caller but lockdep
+	 * doesn't know that.
+	 */
+	__tmigr_set_cpu_available(smp_processor_id());
 }
 
 /**
-- 
2.51.1



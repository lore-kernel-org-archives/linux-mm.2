Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C81EEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91926B0088; Thu,  1 Jan 2026 17:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E250B6B00A4; Thu,  1 Jan 2026 17:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B956B00A6; Thu,  1 Jan 2026 17:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C55D46B0088
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:15:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B03F5FA7F
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:38 +0000 (UTC)
X-FDA: 84284802756.30.79EC633
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1AC0980008
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nlQMgj1n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305737; a=rsa-sha256;
	cv=none;
	b=DEZZlKYeyFxOgxvkcXER961NDgs5Qtvgg5SPO44a3pjK0ZJclGsfGUJaAZAMNPihXObGKY
	ISVFgSQu1nXJlgx6UPMzX55GYu3gVQ4+Qr06JYKwNIY1huqGfIG0QkfiDGdSonm7EO0RQg
	ksP4i66g0Nc9map/F2jIHBQVrXrKj1Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nlQMgj1n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wizuhTN6mGlwa9nDLf8YTsLN8D8vmBJXyWiJsoAfY8=;
	b=mPBIqyAnd0mYWFBvsePeLvN0/Nd2Io++Q5dxlwLkY2jm5gYo62/6OY90/tSfRyIMfKCmJA
	pMiW9VRsRRNGfqMTGSqVZjZeywEClLs4/cIvHTA0HdKMSQv78/0VqEFg06UnvvRYNlREZk
	ql2cEf6JW2pOB3eBrFPyMSBMq42CJyA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89AB0600B0;
	Thu,  1 Jan 2026 22:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208B9C116D0;
	Thu,  1 Jan 2026 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305736;
	bh=cfBsUi49kwBpo1bGsw5oqJU14C2/JcinY0oHFYzJ/us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlQMgj1nTTXW18RtyL+xyRQjFuVUjFVIkw9w4/qbqxrf81g8r3KSDa05VKVN/bxA/
	 vIKSiCe2IhhaJyJCtEzi9RsJO0Kbx8cxJXCZHBVgFZymaDNc7SBubaq2+9W8AmTG/R
	 Eq6yt71iRpiTnQdzSIiKHmq7FzyJIJ71LVV0/jxsh8Dr0Psex4G5jmxaJgSgs/9rC7
	 WvO1V9EwXxqIAxixAFfaI6OkeVse14raZBGXjJ1BvNu7ayX38rhmGCtOOAwATE9ajn
	 kudc2CaRsC2rzY4fk5JPxN5Wf/5Y1n6opCaB/29876e/JqEDRp56ZY7BLWOVS3cV8r
	 BETHMalvbdJ4w==
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
Date: Thu,  1 Jan 2026 23:13:35 +0100
Message-ID: <20260101221359.22298-11-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1AC0980008
X-Stat-Signature: 71rju1fuceok85hr1dbeei9jqy4x153i
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767305736-704810
X-HE-Meta: U2FsdGVkX1/3dSNqBkh/dbgbYWylwt9aWp6lcgC00NP1Zak7ZXX1K7ihWivyvvi6FbXWHdki5AfKf8eUxSb62iQRYD/jm9LYVbdybXmo14s4g1t5Ae/5oF4tU7w1isi9yCvHkaU6AODQbiUIuQ7qnrM5wgkKFvU2vfZR+wZPjgzDrmj3uxXsDW1KRBYZ2c7bIYBV8ecwHnMBVEG75DdbhitCUu2288MKZZne9JXlKxBgrQXswC0JUttcUZJiOb+u3Wo3uMbqdD/Tb9NhBWN38SqSEpK9KnbmFQ/k5CryxaUHTwkkn/etyjDwHm7zfw+U0+C3laHl4yMIM7vsPiMAjWVMch8BLtRN3opoph9Tuv3Nh7q+US6BxIgSx2oL5HGzgBF68vWXp+gwKjl1G2rynCMIE0P/7ASGOortEJGl8PzlK+O3KUg8LfCLdTdNrWgxr/tw66keMeTB+2+RQtiRjbNjjrf0pzhMckbfxjFnWE4O7rUGSH5s1lo82Sp8UeSTQUDBQsa1nFk0rRJBzAOUD7CANC/WRDAji9BhPa9FDaG3sTSlGpGHrVVJWvaF4Y28pAr/SymLATLMtptUWBuUoHy+anySSzPQH7cT9rMVMLwGHXesUFPHrLz2UiBg28rI0jLWZ8RJbz5/km1u6CYzEcF/1zvv3rrnzjXDf+bby19Eth0ghiIWTm0eslFw1e8siI0lNBGbfAXXvmEv/1YeCzm3lCbv4AvD4Bwr5GMobiK1RRp9CDbwPH5c1vznOORJJSb3Lq8Joxqyy625wIA8JvLJn46IVpZGvry7qx+AKUvS7ZITdfH8/51ma2u8vLxneVWkE1G2vWDQ6FMr+0zeVA8p/ma3jLyaCc+DMOOvvIWABuoGGJ15i6YgFrBHQF6MquSGTRi9uCI=
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



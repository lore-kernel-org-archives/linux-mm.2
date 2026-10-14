Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE02CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67566B00C4; Wed, 14 Oct 2026 05:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A0F6B00C5; Wed, 14 Oct 2026 05:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57E26B00C6; Wed, 14 Oct 2026 05:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96F276B00C4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:45:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 297C3120472
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:45:31 +0000 (UTC)
X-FDA: 85320749262.16.7766A0C
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id F2B78C0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:45:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=JmgUkH8O;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2XQA7j4tYm2Zsyj3FeGcSE0tdyDSiJaEUUcQjCd3Vc=;
	b=1h1cPogYT4AK4+Ur4xPppzX6aniPI79+oFR+D6YxZDNWSj68h1q/2t1RDRxNCyUEZ4gFQj
	shRm3N31EFiEDZe66k3kx7t7buQ1WqOA1FfxowrRJb52CJmccvErN63wcurrnoLgX5Ub6P
	mYD5o+3OsWR1ybSCsU8QgJymwP7nwvY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=JmgUkH8O;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971129;
	b=bEwe28go/tV7GNzXgsowVhxP8r6W5zcraeZ8+ofyhvpzqRNVds6VAkOVM+pPf/INC38MSu
	12I2jSnPljthyt9/5lEiBZPpAhyu8Bhv1vnNZipDW+RzogmZ0w+z7SHqVigNxkPNGTd4ON
	lEl7FpKP6HoBrd3E+7sWPIH9GEktYR4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791971123; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=U2XQA7j4tYm2Zsyj3FeGcSE0tdyDSiJaEUUcQjCd3Vc=;
 b=JmgUkH8OhSzXZmANuSFVgonctsEvOsfPiMwQieXTykwtgwSPPiwHCBu7Kx3VuRKJnqfaCw
 pMqBFrbH5hI2OmUb1aiLJjath1XBpE9Aspahbr0dUrKTGQt+Yac0UZfjH0gm+ubZb0W1Yz
 0IZ2X7QOypJygCql/mnCokKvk2kaHU818ptY5PMy1BkASfXFYFMaOHxGkmyol4Bv+BSlBQ
 am29FgWQ6mpOF6b8VZRbggF4dPIDue5bInI/c0P1qzJQmPBeOufX3xi0IX2PrzWO+vQJcZ
 wesFdtrIe/N8zD7EeNafMHMAnQZGyiSKgYkevDGY1XQL1Bb20OH3iGlCW6Emxw==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26acf4f31+72253f+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH 2/6] sched/numa: fix scan-period ratio denominator checks
Date: Wed, 14 Oct 2026 17:43:43 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <mgorman@suse.de>, 
	<riel@redhat.com>, <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261014094347.99157-3-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20261014094347.99157-1-lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Stat-Signature: 6r48hh1qfr53bzftyjy4miue71wbx58q
X-Rspam-User: 
X-Rspamd-Queue-Id: F2B78C0004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791971128-965823
X-HE-Meta: U2FsdGVkX184fcJXnbufqvasflcfa8cTsnnhnO5237d7q4btxxawIq3JfEj0Y6rjEZkAJYbByppUzqzPfOl7/vHwGJSUiG6FNZL478FXbweOV1qSGFpXvRpzpxdRhY1dBj9tr9w53ZWZfYhb8qazxAqBnbHPEpuYLV7e8U3+MPDoJzZq5Luo5KCRpXmwtHgeNq0I4oM4Ef2EVq+8wVMjOBKyWjtdb2C52jsYwiV/Atl9Jw9AQuEJ1kp150XHLeE9oBFq2QSfA481lZghcCU++L3SBbsQDz+bKPiFZHFJb4LlMqFJftEOJDQVQ+k1z6iOtlWeoVa2USel+hfitIctlGuOTyVx0bU80iwupj/AxsZiOi6J1HnFC4KQckFbGdpj0/S9mi3USAzWCP3Yoz32oMsKoPSNJkqTEo0Dhi0ZTzV3Srnq0kkXtgOS+O0yWXBc/h9e6yf13H44RqghOC0abSwHlBWUhZ+pffBqo50qH+kv9FzpXNHVFWuo/y+YXr2qH4UVvaIn6yQsFCHwSeYdMJqev1nBhGs0g3S3V3eqfsHqpS86wycbdLYiv1YR3avdQiAGQgffEJiugXY/8YcHPSpn/KLahHVgzyt1PLf2lxt+xEehDkQ6YjmC3JuT4ep4RP0i83K1TGY4x7Iyo96c3vAcJFHg4VzPvJTON4uzVZ2c88M+vZqxEz06pnTyUtJHrzTaOxcX8syfLHjh9kDLmQETLGTghZ5mXPUsvi781bU16moAMAAcIHy7a5zyMBeymeQ3aF/Fbhp5+HbXkUrhojSmwt8TJCuF81oQOAWhlgZNOt9ZGx5WkWjpa54zKjkM/7v1ropztZugK+Cui1gANYkRnxlXpnreypSFfvwqPH3CiLAK0YU1IrxSmpi8aPRU9Zo2Tzi8DrqhXKIXHn6wDdFjS21i7hGRZ57BvG2Q0mPapulMvt2ymsU0u72O4vRSikBqoCj7HAQcBQrb7if
 Q6HmKgfv
 3IOWm0S/Cv4yKKP1qk42hGyVvxkZqC9JhTZIxhlIBX3nDNlDyuBJfCYkXbCrogHpqnNmoSy/jgyyePSUbxxTEORH+EZf+Dus4Q2MuKOOXESMfG3gtCi+0vBapT8NbFJAdwHBbD2PIqAfw1Ei9cwaPpPBwo+1QWqWoG1Fb8BXxHkSNbFLvs/pDH8l9lJB7QaBoPZMSRH9npPOPcQnxt20+pfCyHRfEcvCObECzAis5T+LTcC23xw4pagWQJZBSIETQCnQ/GvDpdM4etIOMPdRx29Ev7UYzgvSq5DSOY7K2DcLl0Ah09S/4LzNVZEYzIxxAT05r177Z5eR8v00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

update_task_scan_period() scales the scan period with two ratios:
local/(local + remote) and private/(private + shared).

The existing guard only checks local + shared. That normally implies
that both ratio denominators are non-zero because the locality and type
counters are updated from the same hint faults. Memory hotplug can make
that assumption fragile because task_numa_placement() folds the
private/shared buffers by walking online nodes, while the locality counters
were already charged when the fault was recorded.

The divide-by-zero was reproduced on v7.3-rc1 in a QEMU guest by
hot-removing a NUMA node after NUMA balancing had collected fault feedback.
The next NUMA hint fault enters task_numa_placement() with locality
feedback that was charged before node1 was removed. The per-node
private/shared buffers for node1 are skipped by for_each_online_node(), so
update_task_scan_period() can see local > 0 while private and shared are
both 0. The old local + shared guard lets that state pass, and the
subsequent private/(private + shared) calculation divides by zero.

Keep the slow-scan fallback for empty or unusable samples, but test the
actual denominators before calculating the ratios.

Fixes: 37ec97deb3a8 ("sched/numa: Slow down scan rate if shared faults dominate")
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 kernel/sched/fair.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1053437933ee..76532b8202dc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3698,6 +3698,8 @@ static void update_task_scan_period(struct task_struct *p,
 
 	unsigned long remote = p->numa_faults_locality[0];
 	unsigned long local = p->numa_faults_locality[1];
+	unsigned long locality_faults = local + remote;
+	unsigned long type_faults = private + shared;
 
 	/*
 	 * If there were no record hinting faults then either the task is
@@ -3706,7 +3708,7 @@ static void update_task_scan_period(struct task_struct *p,
 	 * migration then it implies we are migrating too quickly or the local
 	 * node is overloaded. In either case, scan slower
 	 */
-	if (local + shared == 0 || p->numa_faults_locality[2]) {
+	if (!locality_faults || !type_faults || p->numa_faults_locality[2]) {
 		p->numa_scan_period = min(p->numa_scan_period_max,
 			p->numa_scan_period << 1);
 
@@ -3723,8 +3725,8 @@ static void update_task_scan_period(struct task_struct *p,
 	 *	 >= NUMA_PERIOD_THRESHOLD scan period increases (scan slower)
 	 */
 	period_slot = DIV_ROUND_UP(p->numa_scan_period, NUMA_PERIOD_SLOTS);
-	lr_ratio = (local * NUMA_PERIOD_SLOTS) / (local + remote);
-	ps_ratio = (private * NUMA_PERIOD_SLOTS) / (private + shared);
+	lr_ratio = (local * NUMA_PERIOD_SLOTS) / locality_faults;
+	ps_ratio = (private * NUMA_PERIOD_SLOTS) / type_faults;
 
 	if (ps_ratio >= NUMA_PERIOD_THRESHOLD) {
 		/*
-- 
2.20.1


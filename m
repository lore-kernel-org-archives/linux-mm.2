Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0CF1CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5868E0026; Wed,  5 Nov 2025 16:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375D48E0002; Wed,  5 Nov 2025 16:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266398E0026; Wed,  5 Nov 2025 16:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14E518E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:06:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D50B586DE3
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:58 +0000 (UTC)
X-FDA: 84077788116.08.BC7D8D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 33B45180012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hz7xihx1;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/5p17bEYjP5oa/1Rjsmx4OqATDgvK7mhADuOlJWGrlQ=;
	b=H4lUGuzQrcXk8K0IpApd3IXGNM8iBeBpDhFGgNyRqXSTbEJoQzWwR3aAdolU6nTYstjQ8g
	2MDBiBZMVovRt5R+e675l3zwK2Jp/PhQuHhTpZYGcnxfcLfKZRgc7N03cLr3/xZjxFP9Mi
	GS/r7eYTp6xnNDvB213xRF3aTab8fcA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376817; a=rsa-sha256;
	cv=none;
	b=PGc4VSwZWAy5TzvvehABQmZScUcGrT3Flv/ba8lNn5z1VYI8AcpBkwDF3ZO7zb7D1I7Vdo
	XJuO7owFS5+8o/m4C/aotl4NNtUFODz6sNikThl0STF0IU2BOQNI+z1g0lWSHwPQFh/dhd
	EI4bReiCRtgTmzg1IwR0ySTY48/zHdc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hz7xihx1;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EAD5409E3;
	Wed,  5 Nov 2025 21:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918F2C116B1;
	Wed,  5 Nov 2025 21:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376816;
	bh=rc90r/VJRIFUeghTYji80GjIJHgeRfSLzAtAWtKNZdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hz7xihx1glmCXa1xYOTXCOtZCwF0OTEG4MDXz4ESiFKIT/eSzyLgw6tdM/A/8ArrJ
	 IEd6sw+KI8CCzzGQUHk4lbghlqPOFoH0V+bJWqxwNfBrriit2+q0O9a/xMKNAVftG1
	 pdEtz6CY10kisa6Dvp3UjaeNE1tQMLiHK0nc3QJKfijSBQW1LtHsUNCwdyFZvY3JRx
	 30ZUh5GLz8QEnuL2xArNJEP1+nfwTiM+E7KRZVU84r9zqRWV8rANivY1p/SX18pPk8
	 Q13aJlDvbtRaohmyRA5PXJR2bE/8UKI4+NRSo21D37HRxvequjK1Me/ZODpo/5OSaB
	 S5lgY0KgQyIzw==
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
Subject: [PATCH 22/31] kthread: Include unbound kthreads in the managed affinity list
Date: Wed,  5 Nov 2025 22:03:38 +0100
Message-ID: <20251105210348.35256-23-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ph3xmdpqyuoppdh7j1nmd3z6e8fz9cf3
X-Rspam-User: 
X-Rspamd-Queue-Id: 33B45180012
X-Rspamd-Server: rspam01
X-HE-Tag: 1762376817-142732
X-HE-Meta: U2FsdGVkX1+bP08uuHqgvRpUpow6LvYMDGDP2JAImrXAvbtdgR5t9YqULysiLTJ+yaj6vXy9z/3Bqo9qpNmwac+Zc3KvXuR9HM78ETizCshZHty6bvyHScd9JFBoovoHkwqkYTrD7ANr5wWTPU9PWW1rs4RAKtKmufNryDqjz1GE+Cx1bgsXoHutenMMlDAsOsMkgU4mQ5UaB3pvjaV66Kx1zT7Yut4RbW/VXQreSK9l2AHmtyhzHnN3VjD6xcedEDrAx9auz3ZaZf1BbSDycAss7v4QhoeimfisR1uFMlUl5Mk4gahAQgNGlu7UW1BYRAn8lovW3F8WZX+bj8j43+nZsQRn/2nSQw0FloHhesOvmxqswiCakgoGrBIGZE93e4uz4+pDjvlqcffre9C8n7x8T3337ezXcs+SQgJw8D4jg/0IdDPKhlcBecMl2C7DR0wd1jklwn/jwrHSGyiTbeJFt6bWRY9Os0Vc30Y1Y9kUj4wfWplq2OEaHre/gS3lrKl3KGOChfcRUxi+aknNt2hH11nSpcCLsVZm+cvecTLy0SMnsGvVMP5uhA+lu0bM9asD1idItW1DSx77CeEXG/pJcK7nAb5dj9IfxhQKBQQY1Ians9zPbisqmuyDTuykIDKV6xZtpJzJbnfUs14CHasv+CRzeODDLU5KtQpGwXrCBuvF+KfLBRU3iOw6jeQySxxKIsdmmcA/Bk//qtsIEgQq41d7I2Hii2jQEsTpQ7mYcwGCLJ/1fbg1lojtrGYLZ2rbsjzLuoRiCBZN7B4uWBCFO8tuPcWg7qf48/vWz6DAeCKt3yn0aWASfQhFD+1X8aISdHH9t+wqlFmBzEY2ia3CjMRJtdGbEdwS9X/yxNvNtiFbJ9fksF0X1DOx6BS4um/9efKHYgh2ezXC2fPzPBNQ2kAImRaaCC48zubS4ZYeIA9NQjKBrIdh4ajC1QtrzmNbAjtfy2YkKOkMZMc
 Y1f9ONw6
 iUa7MAxQ2ZRhYF9+Z09Y3tNbQXGWqMlroi1z6aU8fsdOuRscN9bq0HpC6EUNgE96MmiFsYSRYIQCCnWTawt9Ar3rzCHz8eiSV9pfhB64OIrcy2IzIrRbZGRqdu+94q3qus4CZ7jmPbDYRkM2qMKOoAtXmyV7MrHd3jfwzDDSoYVNVtdlAyWVqj7V47ejG8f5S5y9nBGLXTLZLEeKKeXru9K1xVEf8xZId1oE5EZwLx/yccScYOPa6pPc2ICI5+9fkMsduT6u6FTvGv5Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The managed affinity list currently contains only unbound kthreads that
have affinity preferences. Unbound kthreads globally affine by default
are outside of the list because their affinity is automatically managed
by the scheduler (through the fallback housekeeping mask) and by cpuset.

However in order to preserve the preferred affinity of kthreads, cpuset
will delegate the isolated partition update propagation to the
housekeeping and kthread code.

Prepare for that with including all unbound kthreads in the managed
affinity list.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 70 ++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index c4dd967e9e9c..b4794241420f 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -365,9 +365,10 @@ static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpum
 	if (kthread->preferred_affinity) {
 		pref = kthread->preferred_affinity;
 	} else {
-		if (WARN_ON_ONCE(kthread->node == NUMA_NO_NODE))
-			return;
-		pref = cpumask_of_node(kthread->node);
+		if (kthread->node == NUMA_NO_NODE)
+			pref = housekeeping_cpumask(HK_TYPE_KTHREAD);
+		else
+			pref = cpumask_of_node(kthread->node);
 	}
 
 	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_KTHREAD));
@@ -380,32 +381,29 @@ static void kthread_affine_node(void)
 	struct kthread *kthread = to_kthread(current);
 	cpumask_var_t affinity;
 
-	WARN_ON_ONCE(kthread_is_per_cpu(current));
+	if (WARN_ON_ONCE(kthread_is_per_cpu(current)))
+		return;
 
-	if (kthread->node == NUMA_NO_NODE) {
-		housekeeping_affine(current, HK_TYPE_KTHREAD);
-	} else {
-		if (!zalloc_cpumask_var(&affinity, GFP_KERNEL)) {
-			WARN_ON_ONCE(1);
-			return;
-		}
-
-		mutex_lock(&kthread_affinity_lock);
-		WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
-		list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
-		/*
-		 * The node cpumask is racy when read from kthread() but:
-		 * - a racing CPU going down will either fail on the subsequent
-		 *   call to set_cpus_allowed_ptr() or be migrated to housekeepers
-		 *   afterwards by the scheduler.
-		 * - a racing CPU going up will be handled by kthreads_online_cpu()
-		 */
-		kthread_fetch_affinity(kthread, affinity);
-		set_cpus_allowed_ptr(current, affinity);
-		mutex_unlock(&kthread_affinity_lock);
-
-		free_cpumask_var(affinity);
+	if (!zalloc_cpumask_var(&affinity, GFP_KERNEL)) {
+		WARN_ON_ONCE(1);
+		return;
 	}
+
+	mutex_lock(&kthread_affinity_lock);
+	WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
+	list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
+	/*
+	 * The node cpumask is racy when read from kthread() but:
+	 * - a racing CPU going down will either fail on the subsequent
+	 *   call to set_cpus_allowed_ptr() or be migrated to housekeepers
+	 *   afterwards by the scheduler.
+	 * - a racing CPU going up will be handled by kthreads_online_cpu()
+	 */
+	kthread_fetch_affinity(kthread, affinity);
+	set_cpus_allowed_ptr(current, affinity);
+	mutex_unlock(&kthread_affinity_lock);
+
+	free_cpumask_var(affinity);
 }
 
 static int kthread(void *_create)
@@ -924,8 +922,22 @@ static int kthreads_online_cpu(unsigned int cpu)
 			ret = -EINVAL;
 			continue;
 		}
-		kthread_fetch_affinity(k, affinity);
-		set_cpus_allowed_ptr(k->task, affinity);
+
+		/*
+		 * Unbound kthreads without preferred affinity are already affine
+		 * to housekeeping, whether those CPUs are online or not. So no need
+		 * to handle newly online CPUs for them.
+		 *
+		 * But kthreads with a preferred affinity or node are different:
+		 * if none of their preferred CPUs are online and part of
+		 * housekeeping at the same time, they must be affine to housekeeping.
+		 * But as soon as one of their preferred CPU becomes online, they must
+		 * be affine to them.
+		 */
+		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
+			kthread_fetch_affinity(k, affinity);
+			set_cpus_allowed_ptr(k->task, affinity);
+		}
 	}
 
 	free_cpumask_var(affinity);
-- 
2.51.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B348E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E6C6B00C0; Wed, 24 Dec 2025 08:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5DA6B00C1; Wed, 24 Dec 2025 08:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EEC66B00C2; Wed, 24 Dec 2025 08:49:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 714A06B00C0
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:49:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CE17B69EC
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:08 +0000 (UTC)
X-FDA: 84254495976.16.EFCF39B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D08C140008
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kaBuFHVD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584146; a=rsa-sha256;
	cv=none;
	b=XquJ/LSBupQ7ceLI2oO9V2NAb3KBWOl+scSK+RHkjZTNoP70zKFGglTpS7IlIhZ+p+tqP5
	kW/+8k8eDRCgtxohnLZRsMQUufmKXGYb+0Kf1g8MeP93Imz36yk4nWvHGr+gfZupPIB8/d
	TlSXfdvZizO6Mid92j3vqSU7t6funok=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kaBuFHVD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ym0clnOXcCkHRqDykTV1fJDIYWiu2wzmH3T6iBeqLuA=;
	b=dKvaV8+vpVmtMLiJkGYh4c282xk4ccZoJCnm9arjScjUR/Y0xXwpc8YOTPqt4adtpHF1IC
	KPO3sphgxSUgeAQTiemQxlRvCP750IgL6WdeuZrPU4s6IFNKXWscqlcqDsG+2c5hiQmeSl
	svdtzlWdHoeEMyjRcBx6kdlLoJboDQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B997540AD6;
	Wed, 24 Dec 2025 13:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CAAC4CEFB;
	Wed, 24 Dec 2025 13:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584145;
	bh=IvvJgMcd52cz0eUXtHfqF0Ab2ynthHHbFGfYcVS7MhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaBuFHVDB+r1+wmFnnz/WXtOLPFboUNL1OfEf6O7xFqhEpPyvk1qxpu41Pur1Xjn9
	 6Rg/yUgFRgX0/0gJgIgcozT2cXOLTx/lYiYTwV9KoYdAINweW494Xw02UR6s97sqtC
	 NX5Bw1Wwzz+XMvfy7tMlFM3xcXriho5wAtb5tZlZIZOzyb4lLYEb7qc3dZ9nHWDeKN
	 KetC6eCqsdmW/FfngzqvExoTcqJPGM7FqyMUw6eKtvSUjB7/W5w8L5kCb8slh2rNCn
	 TAQ9olUE/bT5wEZ82t0sE2yzV8RLX0WCBKZAUWIxrXslvPmpaK+/563Fyd67a6KXJr
	 ib8CaUU8B1QDw==
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
Subject: [PATCH 25/33] kthread: Include unbound kthreads in the managed affinity list
Date: Wed, 24 Dec 2025 14:45:12 +0100
Message-ID: <20251224134520.33231-26-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D08C140008
X-Stat-Signature: k9kqpi4xqpsyy4n4mutqpcin5b6qcgp8
X-Rspam-User: 
X-HE-Tag: 1766584146-451481
X-HE-Meta: U2FsdGVkX19PfR5YD4anYByqzQzKgNrkbKJQ/m8nPZ3TsGYaJQFI09PYN7iA0ON087xirZIy5Ybu9QQxzr4aepjsylmIGinp+pDI7TWduIgIykzeLoOJvm35hk7NHuj6IFtRlJMWyJ/UZVhghO8NOd+kBc/72WH3bwbqLJyzjV2yc18VlQuJ6FOuhZYgWhZV6MeV2hy86Akw0/iRtcWdUdj2L1lN6ymXoT/tY6hM6IM9fOPca4mqXQEl6bupIWOtwqVNvu0TzCqhooJLo2bhVik0UQI2ZwJwbpXI85HFEci1yIgKRzhxIKfExHPsqY385qYecPyPBRZbHZODSj3TFwLSSRQmFTegK+WNpq3m6s9+RFJiBT0DZHwlJv1/AhpyoKCPoeOgMnl8etAlNBg4QHLdlKqJciz/83gbEoKXu3NneE66Uuj3adpgcbekgOVcsMNFYtCdphPhd/i7HDLWlWIoSflwQIciU7Xm5W46yh5bNH3MHpPlBzFT05DDdBU8NsIpwl4sHinaOJjNbuu/JBOKtKkRIw6A45OFtqOnF4jEG7p+R7tgvp3SDWcvnnb+WquUqga3lOjV5EQq4OzIhuUCuXUxKgQsRsevPx2B5/IlAWuNnx2vB5JRJ4xh9gmmouf7haN8e4zJomj6xVr87o490HXc/1riGM3K5SwsxZ/RysHcnTP1ASZVJV85YP5jVtWD4EUILQqnYiVxTsUTFPvaRTFGaLYFPhQfwwmh6pO9toZwzfzak1k9MD++m0yHo6M8xOanvnMzS7Wiu6KSEul74DI0iyW1sD4LwZo+88sfeECZFX1F7qegg+1nI7/jrk3h2CPRk8RpI7Wp/9PkPUN7aU8K8KeQCMowh8P2ZkcSWQ1myHlMENZuAOWGPm+cfUM3Cw8Th+1r9ealmgkGP9U34JET6Tfxn0S3tIPPBERw5Tf5fA5YcSHMLCR2wQEP3rv2cOhSAxUngxfwtjM
 UpKdJ59H
 V/yXTY2UmNaGogg5zZLMlXU5Ny/+eS3vZwxjv5BQT7BO96xsMxbSxXxrdPwzSmIftiKhy4wNwnUTUlT8H3fhaiAkvNCGEyqOUCjP2EgWTPqH4nZBVutWNWM6scBuHhtHG7H0Ctx6SrPyIEG8ec5qvy5WngNjVbt20hIDqmfmaI6rZ5zRu5ngKUIOIlw0b6by8dpPpXv+aA05sqvJUzYMIr7/JHtUlTswISbo503Wr5wMZii5SfaZdtByGTCqwQQA6eQCoGpcKIVQkHJk=
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
index f1e4f1f35cae..51c0908d3d02 100644
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
@@ -919,8 +917,22 @@ static int kthreads_online_cpu(unsigned int cpu)
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
2.51.1



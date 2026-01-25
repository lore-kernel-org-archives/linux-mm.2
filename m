Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A3BE63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44136B00C0; Sun, 25 Jan 2026 17:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EA56B00C1; Sun, 25 Jan 2026 17:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D896B00C2; Sun, 25 Jan 2026 17:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 939FA6B00C0
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:49:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6DA461405AB
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:18 +0000 (UTC)
X-FDA: 84371978796.08.D53D352
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA92E20002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UgViSQhG;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qz+DGGx2ncZ3Mxc9/jgxTMCGdzAmp3ATkT9oSs7t3lw=;
	b=pEyoasTVMB1YZiiEDB4pUlywXt/08I4LDo6w2gwt+2gufJ1pgDIrqMBk84EfTsMF4KA2SR
	TwAOaWt4/MjDYSSWRsVIKMHBaM+otLJGxEQcwGHHOZG/4FNv4VrQqrxA+1fFX/e8ujV5R8
	uvC8V6EPf0eAuMORgNACgHWKUu7gbyo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UgViSQhG;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381356; a=rsa-sha256;
	cv=none;
	b=Fq9D/+iiWVM+KDIgxVFpp1yVM5sRsVpZ9mHtcDe8NNePtNY8n2pnN5MQ0s8ClNVAxZyu5Z
	Ri7ndIcUzJ2M3pkxkHNbj3SJGdWn4bkp43jp2toOKQtueCGOIQxgXx346yJmRd1pSyTxAw
	MSdhAlvnoJqP8r/Tx4uAzK5NWXS8Fzw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1881443D8;
	Sun, 25 Jan 2026 22:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ECDC2BC87;
	Sun, 25 Jan 2026 22:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381355;
	bh=FQiUYX134QuRdMK2UHqgCPVDFLi7Mj4zGAJtAEtu0Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgViSQhGT3Wuke/Yit+vSr4vsPQsGUB9TksMilPkbw8ucPH88dnfcU8EQRgMLb06e
	 lN2gyJnxemaInoGQz3B75xDql7Evl1TQQ4zZmMsXAnbD1Urr7NwOnt6wOnaYCOQeeQ
	 sgfXCryqqyMrpzQwx8K3coFYao2XKspATR/APoqQUbITIoNDoEi47ehdm2MK1mENnZ
	 ywxEht8+8pss3W8QMkb/rQLYybf1dBhLQUt9LxeRxUkMJZvTICvHfAVqI24kffYkw6
	 adk3FM+FdCMT9PgkO4j8TJQKImvmwOStO+j50JTiTr4NKwPRgOc7x/stxI36amWxYC
	 ikhAsOpNxxM2A==
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
Date: Sun, 25 Jan 2026 23:45:32 +0100
Message-ID: <20260125224541.50226-26-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA92E20002
X-Stat-Signature: nt8z3wpyzfd4q4pxzyoqucgw4e3st5xu
X-Rspam-User: 
X-HE-Tag: 1769381356-362430
X-HE-Meta: U2FsdGVkX1/ynLJ0zKoH73ndBS3mzBMuiC4MY39mhFCXwSBfh1fDlGWBQABpbDdh89S8QZU4yXX9Lh5vpbjNLj+RmJWKaC6KbbIOy9OgnLIZdmg58GpXQ9rXivhyt9Gjv4Baa95790aLMmo/PpWTVnl2j8EFZOnlUDLdtjnX8YcouSRpw/yDI1K1J7E0jbaoUFDMZrA9J0z5FzmYyNrYu1Mbm/V71rlDYQTla8LKoYPjgB+wmNH2UmFuKmSa3h25afm8D1zA3rm5va9z8/9ryGuT1URt0kBO+2fO143zVjDswhy0eTWOr6/92ppCKIYXR1UO8hK2p8lKV6JWJ86P7MTlkAAmCW4XphLizgWtKjrANQtPcncsSQb6WKATlBB8rAWtw3h1fPejne04+7KIPpuDqy65sxIwOwDbC3fCiFImVqUY8v5xl/Mpxhx/4lmK4fF/oXy5ZIiADu77VtMzHCps4/PM7skQIAKA5yNpJU9dro8xs9Z76WNTvSRvR3UR++ykilI0B+7vRROi6ZftRDrfGNpEY3oCpOibheQbnuKlA8yDV9E0igrUWDVNh9RA0+4wBtXja+unz5a+amDY3yJmNwNWQJEcxwzTnsW7hHqDJNFk0D+yOEbtnuQiTzYoJ+5Hs8NIZuP+6jgIsqH7kf9LOtGmv8oXCooua1OpFdb3PeSS2MzEnx1W8fMv2zhJp4I7D4SOxIbdF0KYz2DUCAOeeN1V5Jl1P6oRaeI41qx4KxzM3eN1VohlTRC/f3iidWrImp3xmrTLTLGFnWkS2Q+ha2MSlOAtXGn+eZ/daC5EzrZ5r7bEvmAtrZHp/2LemVZwDaDMCsh312qxQSaPG+t1u8wCOm9FfxFkoL6Y6p//v/sKlUybDIvG8eB8rnZQYsODQTDKR3/6nynkTQ0xBNSSxUZMIK8Rj+HHWZMJoD7McvX8idGhOHs6Y+fo8KrPvj2cm7+ijcyrzRQL+FL
 6wqYaU8N
 5/U7DAGBd2P7DDBaOxZtcdXQyu+YGHicUWT0r8+cXw2U5ddqIqXmPvxRqzBX518RgTV786qQJgYIXawnNP/3qaZIC1AnWSqbaRrVD+XWG4158lOBk6JmfIuJqG9lffXoWWJIoxwT/77ep1Z41muJgt8KpZgVXZvqYZyx+R2lAptSR8um1OeW+GrOC49DTDqapY5Zb8lINjz9F/vngok4PmtNe8Q0sYofgYuRkK3zrRqhBDSQ2ADXX3IkPUbLANCx7lquK/4tYmeiqSfQbnU12ssAU//M5/ytMvVMs4ISQJEhx0R4=
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
Reviewed-by: Waiman Long <longman@redhat.com>
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



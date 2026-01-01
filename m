Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A331EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8DD86B00C1; Thu,  1 Jan 2026 17:17:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F116B00C2; Thu,  1 Jan 2026 17:17:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57546B00C3; Thu,  1 Jan 2026 17:17:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0AA96B00C1
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:17:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8949DD0A7F
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:40 +0000 (UTC)
X-FDA: 84284807880.25.B3DF0FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 06446180006
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XUUyVasV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305859; a=rsa-sha256;
	cv=none;
	b=J4Yr/+khBGvuLkmHA74g7dDb72cpLWOtHlj6NJWrrJJInJCk2kTSwgc+29AC3kUdQUL2ZG
	yJW1frFk8BFmfMVgfhycEtqYKkwNOBBSAU67tzhOAbmz7EC95uxO4g9ffsrvqJzj7lEFCC
	s/YVPn/fqY5G8wKOMRCoABEM01U68IE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XUUyVasV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qz+DGGx2ncZ3Mxc9/jgxTMCGdzAmp3ATkT9oSs7t3lw=;
	b=w5d23hrLtupzp6F8c60Bc4iWna/GMam5UwEu37eT2axX3PQDnXqe9Zy/e0+Dvw8pfct1GL
	2KcnCmfPp3t/2iII9i+IGZwLtMV6fxn768kDk/K5W9nvv5LYMhFuxf1R65Ikhhgw2hcHZF
	+VsphMoOh3ZHndzYL9EV/eowmajjofI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 890D660054;
	Thu,  1 Jan 2026 22:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE941C4CEF7;
	Thu,  1 Jan 2026 22:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305858;
	bh=FQiUYX134QuRdMK2UHqgCPVDFLi7Mj4zGAJtAEtu0Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUUyVasV1u3U2OAhlAsfAFSvZ4/84T9b+/Yagnb//7l06XW+pfb5SupHsl14EiZpO
	 A7lsNvE8Gz+f+oav882CaJu+Xr395Aa7paTMq2wgWOtR+SCJ7KEkBgm/Nqga2j78Uv
	 n0MCp/pybncPc+ax+ldjdWVCiUZtymea0X7ESH0dyW5NSBWCHbzy4fDnSkNN0RchSd
	 9li0iyITeAlfDOmRXA/n5dUyWiFv4oc1wW0hluBRrDSwHC9VV3yDZGdZ3gy3FS4xaB
	 r1/38N02msJBlnvE+rPs8/2v5u9pgbKK9m+UOQpt8txpDDJyrkxcvJloMMe3jpoqJf
	 D1of5SnkyyUJA==
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
Date: Thu,  1 Jan 2026 23:13:50 +0100
Message-ID: <20260101221359.22298-26-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06446180006
X-Stat-Signature: wxqnibq4skmzfnjhu3e7ttfnzz3y3n6i
X-Rspam-User: 
X-HE-Tag: 1767305858-242230
X-HE-Meta: U2FsdGVkX19zKhy9C8ju2c/pD221qNc5xiVS5wOwNJmcQaIm9Mjoirl8Vh11Dy1uqdnFgBZ67YOmbvUbQXbRNStpFMicFVQUcoxmiZ3uJQiJV+3fQf8fETrdta3qAf/cVAHkKSJK7K08J3iNznO/7Ad5rKrYLPSkXK2DKHGHagI88GeQbuPAbrZzM4HXopgb1pkZAkNhcHjN5qj2BZdsBY6/auM7cFkOmZJbJ+JQYoneYEcCYzfzDGSnte/iScc2bloXSdrbJxxPbmlTXUz4K3Yye8wB0TloM/bzAEPrNlcSm8hET6z4m92fuak1aNu44lbYpBUk2w2EwMVNKoYO8tPLptvIIuwv4RT6aDRTWlKl81YFZO73iGmB5zdt4C84262RhgeVPNFPGHzzt/e2vbcEyrccfZSxZBIKcmDZkTsULSxDF/SP9iVIotjsyJq3AS6xOI6wTGxVfYygrh6discj0zPnM5yhiUFe/CZYpyY+kKUUStB5lgq39JCfQSAMVCvqDFhEKpAaqQG/hIrZXcVs5Mmn19s1XaUbkEh7NdDVPkMf9erNAmJTmD+aRf13J/sVM3gXN6tcPt+F67BM7jF8mStHHKMQCxwPGG3CiDQ1AWq4FaO19dTip4WR+VUjGpfGZamP+u+QJSq4xxwhmsN0gi05OH13gSI3zgTrFUHbALdTD8sV7tpsofnI8W/LIj2koiydXV2TP8G064nBS+44jwjpqUmL7tviayCvjUUcXSUCdzohFJIjmyqVtML7KaBtLl56ZF5iQKc8j29aQHbeI92HPAsW25mbmwJ4+HapsJHNu6zSJW9KcUi5mEv3GkV9pq4WG9Vmicy590VNpqeBNk1qKsGc1vJCVca0HjqnKz4/k9xmS9Xg4EG2kXAwz5UX8gx1dMZ7uLShmW04WewoRiOPM8rfhz9sDs/QcrUIsFpFIr7LujGZJEIj0UmoXagSEpp0QPu+SEgff81
 5t55L4cu
 HGgjIcbkELHSSu8ZAXj0lIy832ZxytL8p0S6JoZHIAyaDqrBgHKa0s3bcNBc0W5X5Zi1f9wzPRVo5hg73TyOuoEnHwyjlfESDdq25RWXpyF0HM/8IT375DUHqWQlFearR/MaVAvHy9Wkz6z1th31u3T+mc7rG9rEm6jyUJe/gHp2AH/bEsagYtnXq3Y1n0P7Af7xHxPMg2bR3GgfDQ+tUBK2vw7FeJNB3g23s3lGQcYtV/FwwCCg1VczYscSbrJXUs9pL08GxvihCj2jAiG2MC4VizzJ7CHos7/0A
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



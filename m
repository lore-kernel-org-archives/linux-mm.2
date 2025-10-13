Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D198CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADEBC8E0081; Mon, 13 Oct 2025 16:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EB68E0036; Mon, 13 Oct 2025 16:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E7C8E0081; Mon, 13 Oct 2025 16:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86A9C8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:34:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 337CBB98B0
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:52 +0000 (UTC)
X-FDA: 83994244824.30.8A31938
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F42B80009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FlWnXIVA;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjXzrtpIfUA703v7hTfqrFWL3OdycjReoaqNyPYULCo=;
	b=K4+MNazYZMoua1mzb8YK7sbYbiLh8h+tumpbrMVwUAmEswJCQGptKMK+1lUlhcki2d1t7z
	Sd8pOONYxWqXFG8b8XnhpiBf21pFPLFGNmvZVpdGnLU64SPI2ohkAP/5Z2FZcX3wpTCQ+5
	BKdYghCMY+sGmKd9MkBsAHgVLOgIqYM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FlWnXIVA;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387690; a=rsa-sha256;
	cv=none;
	b=KIPe1LZOiJB58kyEsLDlw1DMy463v2gCV8d/Vxvg0Kx9lvONEzDP32r62FDgq02YsWN3Kt
	BgOJOAyt2vuWeYBmgSZ5uXZB5xux5+ACvb8es00V4xcqcO4KPsEOjLSuvOlfDJD5dvewa4
	TkPWwy7wxWsKekO8biwOnio3mr3/jZo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 956A54056C;
	Mon, 13 Oct 2025 20:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D4DC116C6;
	Mon, 13 Oct 2025 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387689;
	bh=W/GX3bsXC+QdFnHRurPxesapj10VViVlroe7jMIjDmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlWnXIVAP2Ij6p3E+OsHq1UO8TCgas4xdaQsesB6f8nT+O0NhutJTpnutZ+uMCvIH
	 0FzQHCbUDKgkvem8Lm96wp1vBcPFJDROAzK0UkUIqiHw0nKtaTIJk6DzlDrxnkJ0WY
	 BhfPS0VXltoczaVOIrbLLOxzEKB/+GuelPr1iAeTG8xOtEdrXXcm6OfxwGUdAofqlP
	 RY95V3F3Za/aij4C2gr/Ni2eATVA5FvpOQqpN/5uragnqfKZduKFAbhdPJ1gmyYHVl
	 rePbbxqzAjJj6mw4uS0e7EHYWfqUF5FEySZiiG0Jr+HiDYL//GqqaEPfSOw2NkToNw
	 Fr3qLlqIM4xMg==
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
Subject: [PATCH 22/33] kthread: Include unbound kthreads in the managed affinity list
Date: Mon, 13 Oct 2025 22:31:35 +0200
Message-ID: <20251013203146.10162-23-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F42B80009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: onohx4aqiucedmj1eu43jys5u1itskws
X-HE-Tag: 1760387690-368585
X-HE-Meta: U2FsdGVkX1/e6q3sq0LhEHkFJlcUYDZn8qINoXEXnPymPsc274fbrpg3cVUc5w26ielVVrQPwGe5BzZW4XCykHq5JU7/MCJp6mrVdzqX54Zs7wHqw1tXRqKGM3vyGj+1XgT7Ik6rDRYVRPbplWtBXvnDWt6jj61reeELxNI9IVdvmjY6HfcNU6gMW5sr0esIHGVJHKu6Mg58ANPlERkbmq58wtUWSWHluXynz7g8meOxsEiYYIkWpKY4K8oDzeb/AtH7Nrn6aP3LuxpXcfrB5QmQxbLsc2Ay6NecGgb0pjFsHpUoZLjd9bPlexBeD7i3P+DpwWSGqJJhWTSaxu8NujCEZg2IGIXQVKsWMe9VGEJi5UJSWH4Ki+fFM8s+o5VZOcm5TJmERiZiZgiPX5hrI30fXbO6BIJTnkYlKot9svzxGIK4alGBCseUlVX1g66o3aPAdD4Un2tqcKRSaa0Sq3ODq7XVn7yFLKNhtpngS6CuMoWNoV7JyXhNmYwdjnlXR1Qox2zC0b6IXKahYqGwYLxFTz8q28OLyPnb/B1sRbmaO70T+6dxxUI9EU4BB5nixCOc+4CBujRKH7GqgphCneHHE9il6V688Hc1eH8L3E7OeHB//mLmYcvBSbetC4uY+vzVd0a0DJymA6bXiMa+GRFand4DhWqeQDodv2sMdEByOCRoaLcpPWWsT7yOpb9R6PnMcKzI6KaDIIXcMqIxLRHKOjfs+pkqmPFa3A/F9OTZ/8/4u9HWQRVcMiKu3EhXfqnglWILOt/7Erf7EzKamO3EZMaJSg52qrhcGgNhRY0hdK8mSSacPaQUUeGtUtHl6AtATJVKbPiEApo199flGf3+Vscnkegv1dSz0R5Qj+BL3IGtO7rkkU1lQ4/9v6rlAp2WNnG63wlsLZJrM3Ce/2bYaVUzZDriAxLSi9f07LNn4tEVGZ7ysikZvWSup8nQDyv2jVMDCtOe4X20zm2
 rCKrUi63
 /ZDedZKuU8sQfIdht3aB8h83iYQw4rdNljrstMLnyd2ybV30VPnFWc17LguPG9gqQTzYkFIeE13LtGxIPymvQ3DJ0I+4qtH4yE2IFld9TieBUhZh5FiS4XTjMsYeO/Dh0HpNkPaQVDDqbzm53AejX8Imu0zNww0hejH0nEgVadreOQXWNii45SrUVXaASqx043VAJESwleUxCddljEW9QM7H0DZq9M7Mu1Htr8xLAsBfgOhphbZ2uxPMCnXkh0e7USMD4dnXzgt3/7M0=
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
 kernel/kthread.c | 59 ++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index c4dd967e9e9c..cba3d297f267 100644
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
@@ -924,8 +922,11 @@ static int kthreads_online_cpu(unsigned int cpu)
 			ret = -EINVAL;
 			continue;
 		}
-		kthread_fetch_affinity(k, affinity);
-		set_cpus_allowed_ptr(k->task, affinity);
+
+		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
+			kthread_fetch_affinity(k, affinity);
+			set_cpus_allowed_ptr(k->task, affinity);
+		}
 	}
 
 	free_cpumask_var(affinity);
-- 
2.51.0



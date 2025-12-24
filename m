Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DCCBE75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79DEE6B0096; Wed, 24 Dec 2025 08:46:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F786B0098; Wed, 24 Dec 2025 08:46:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B176B0099; Wed, 24 Dec 2025 08:46:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55F056B0096
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:46:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E05AE1601FB
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:09 +0000 (UTC)
X-FDA: 84254488458.18.D24AEBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E20314001F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=evUDJBdS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766583968; a=rsa-sha256;
	cv=none;
	b=nYK+Sya8NbyoxP7MIzHM6azKwnubeILa7gW7j0fY5NsYXm9oNixXG2sbqQ89rOYhed+ZzD
	ymYI1JgyJw8OZkIYc1B4auJeISKS4HY64iDak/lmw0CXfs7rl0NxIbG7YUUtXxrz9h7py9
	NP1LUP9n994W+Ps8TxQe4i2pj2FrNyI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=evUDJBdS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766583968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NxPIB+sKOAQabBh8M/jSikEflAZ+lcyW9sJi6TniPc=;
	b=FOrONu4uV+U5MDJWOkDBBHxx7y3Lu3+KWKZJHewVl6Zq7taoXXWh/Ufkn+/nUNA3D7+Fy2
	HjhbXdDG1ITl9qkBABKuluIYan3n8VJEIZFObDFaNuhx8n9hgpmfbqB51kGfr8zAtbuGe3
	MFZiJA7C3kEYewVTIpK8nvE7hBFGOOw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A7E24368D;
	Wed, 24 Dec 2025 13:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17469C4CEFB;
	Wed, 24 Dec 2025 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766583967;
	bh=gBHkj0y4jQxeMV2qzbEciSScfrXq1yZennkNx/2Itiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evUDJBdSDfWTSettVdnrBmEWuArMIbMTOqJKbYP3p9elzByKiCT7UXNvzG/XZrMOj
	 BA9LFmcovhu6mXlJ60rnaVM8FmAA7/x9xbspH5+9InXVw2X7s7ugla6lGwjCX4FfcJ
	 JC2v9n+hQov6cJNLR2BVz5QIH/VJCx1TFceMK/mt3xc7TDmk+CCAqBDdJv15d5KIXB
	 T+BcmVnTwkiL+nUwRVs3a/Omke+zPfDhsJkfrmITuRWexeqomKaWoRJcx5EmZh0yk5
	 +F3C3hJ0nXTfy0QBGT1xSH3YFrqmpt5fEheIK3FTUGtSRTNE3hajKZX++/AoBioaWf
	 tH5bzsMsmAY+w==
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
Subject: [PATCH 04/33] mm: vmstat: Prepare to protect against concurrent isolated cpuset change
Date: Wed, 24 Dec 2025 14:44:51 +0100
Message-ID: <20251224134520.33231-5-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E20314001F
X-Stat-Signature: djwr9pj5s8xkd7cgcgrzf9ox7i3h5eih
X-Rspam-User: 
X-HE-Tag: 1766583967-485838
X-HE-Meta: U2FsdGVkX1/4O4r1BVGUM7dZ3aZV+ZAWRxPruf7YgYG5zTLMWmsBR6UfX/RmO6i4pcNij9olsbsByQDakH0iSwTMJWDf3pktWENJnc0JNoJkkbA2RdUDnHJzmVrtf5NfzRLCm7Eq0gEUtDZ9e3b+L5ymKYdkSX7xJ9jZZyN8PyDu18WoKO+KnSBi8daRPkMcH5qNlkKVVRAVSX7pubT63CQ6Ei1Y9I/jcwUj1PQWjSxcO9uv+9TtSMrc5zx5jy3UlOJ/DFVkLJOdAzxfh9RMHgZY/KzRqabL7pcWUeJMXS4mI9M/Y3TY30aEwCeZ/4PnCuVfOlVOWOnmUnHc2mKuz2mnIRoI7ro+2tciTvHE25UA5HbXsNVi3lMtXuZ0xUnIqJQK2rCK6KC9SmpUWELKo8B4WoIddJLljpZqhwaryRwFzW5cUMEIRgfkGube2nhWHcX2/B6cMdhCUvI1JC5uJIFIe21zh719zOgearB0y5hJk4QizpyQW8ZMINoGXXXILDoIemKk9NL/06Zrn1RFFSaAWcdZiuFxogLU1H+bscyT+s+8g5yfJfJzQxY/nDZmEvSZXxGFLUez/namrvxQGORO3kCefrWrbdwYwu5pT/yE9yRyZ4FwrqjivnDdP0TD8JRPgMMyoq3Dp1qUD/J5FGZw3Ja/p8L1yfiZH5ciGBJ/DpNlkkmliy5VwF29doAKpDu0S7CZw3q9++Rc0n4Ll1d5wnP2rEXbioyb4LW4BuYiYtY9VGQJkXQFzlZThiCSnpR0V833yYsLOVSYzc1COcsNFYI6eqblhZvVYrGmtare1Vwm733BXQybQmMIcqyTj2lwfPUSZe+vMchDyE6qy6/QCNe0FYj3D/QJ695sfGf95fu7+saUfWkDn/iGWtgU0Mx0CTFdX97KMSvFcW0yHZ0qRRDmb5PsQyFnKjV8XrEHtB0t4bLid7kh/8VzKEo56wL2fjAfIVaN8wmUV0Y
 5ahivDBa
 RuKcgSbp9EyS6h0R/4obzEe8VMV+s+mPr0xOwk01wOTY8VLD4vMuLaMxx78sDjsPtXt5cuKcQofFWEXyL6BYyo58e73wFq/IoJIu8N40/kuq4eZdUvPP8DWJ9u2f2pRHS2NJvs/HBS1dFE3IefQc2W2l9G/WBm8rIFlnRWTBoaaX3oY3roznocpflthqMyTWhN/Pji7AP55DZctPnkJFsOxhg8y8USEsxdjzYcF2hf/u92pFCrYzsB8GmDZMJgC0vtMLXNNwjgp2T9xw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
runtime. In order to synchronize against vmstat workqueue to make sure
that no asynchronous vmstat work is pending or executing on a newly made
isolated CPU, target and queue a vmstat work under the same RCU read
side critical section.

Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a vmstat
workqueue flush will also be issued in a further change to make sure
that no work remains pending after a CPU has been made isolated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 mm/vmstat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..ed19c0d42de6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2144,11 +2144,13 @@ static void vmstat_shepherd(struct work_struct *w)
 		 * infrastructure ever noticing. Skip regular flushing from vmstat_shepherd
 		 * for all isolated CPUs to avoid interference with the isolated workload.
 		 */
-		if (cpu_is_isolated(cpu))
-			continue;
+		scoped_guard(rcu) {
+			if (cpu_is_isolated(cpu))
+				continue;
 
-		if (!delayed_work_pending(dw) && need_update(cpu))
-			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+			if (!delayed_work_pending(dw) && need_update(cpu))
+				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+		}
 
 		cond_resched();
 	}
-- 
2.51.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85601E7545E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47216B00C2; Wed, 24 Dec 2025 08:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EC66B00C3; Wed, 24 Dec 2025 08:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14876B00C4; Wed, 24 Dec 2025 08:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFE196B00C2
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:49:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74660C0889
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:25 +0000 (UTC)
X-FDA: 84254496690.26.8664632
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3F36180006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5nMJGU7;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584163; a=rsa-sha256;
	cv=none;
	b=2Msx0MPYl6MqHi4BBs2O6CEOkrffuw2p3pyta6HhOjhIKjMKCvmxYa9yT72jTIaMwK7lL4
	T2aJ4RBTJRj2bU+jGWOYeXdRSlfWJG+gngWzNKcGZPBx7VlykoT/WkeW2tE7359lSU60kr
	a5dT/FqMFNte+TV7X/CO0eGDLlcKhfY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5nMJGU7;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaBB3ZAidEzu+R4QKreMGrQqZKFKqkZxWTvMIWrUJi8=;
	b=MJmChvVxQEFV0Uk/vZ3WSl4EINQCg1rkYCUPLiajztp08oDQcdcvXb+OK7mhFquZZ4yYl/
	LgmQCmRzYUA9syaRnnySWi8UMLrrH3aoiweW0pIp4E/Z/bVVixu8G8d45Ug8UlsI0RCj2c
	zMYWTipYk9cy+wpESuCYVrjWaQWqBqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53B20600AD;
	Wed, 24 Dec 2025 13:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D148C19422;
	Wed, 24 Dec 2025 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584163;
	bh=ENIdUvl8EYDtGu4SEnJQoOMyqCQID6RqOP4IIi52OKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5nMJGU7u1DH0JY08fgyPGDPpgKN8a8XlXRA7QVvtQppd+ytoY69BFhVMltQ23cU/
	 EI69ztN/Eq+S6IUsh6uy3SbC1D07oMdavhWJN3/AiyBPCttozyUuh3XWjyMnS47FHW
	 XHN9PS6WwvJhEjdb9GFI3YR1+11G/AF84ulnRcD1PerMS7JVK2t3NPmY5/1D5R6dYR
	 m0FVn+H9Ta83gahzHDJQ9ONnH+JIdQJhkZbulzIouua4dDtOG7MgurzpZve+xNFkVR
	 vc0MdghWXVXVHevpJ7RCMqOo2w7nBsjUk2lPDZYtG/HiEXu+SbNdzvxyX6MwRfR6Mz
	 M/mKgvQ1Rf4Ug==
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
Subject: [PATCH 27/33] kthread: Rely on HK_TYPE_DOMAIN for preferred affinity management
Date: Wed, 24 Dec 2025 14:45:14 +0100
Message-ID: <20251224134520.33231-28-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E3F36180006
X-Rspamd-Server: rspam04
X-Stat-Signature: gno8xynmnkgjh6sfxy5infbbi7t6oht7
X-HE-Tag: 1766584163-395656
X-HE-Meta: U2FsdGVkX1+8HH/BwkVh4JS3kJ2OODQasuucF3qqGhf4lhn0cYU72AGv5tLPAPHAtl6O4xq5By27En4UnLCph0JIRI2D39oshLE8fbwDHC+fhIG8n5hSQmHJ8i0KZHJEX8p5MEXt2v2TNmsQAKmFiB0FnAfWPA4nIpSbER8ftZ7TSUvRtFrWyRG2vaTe2sXr7xw0Bo36EGZZSDLQAJxNHdnzUViGxta+1kRxLYg483VPc8FbrBz5VyCwMtmwKITIvelEf2Kor272cI8jceHDzMsaE6xKhpIg69h7sq/QYAgO/fnBY5o0w9wL9/fnp2fYwt1fZ6ix8ADO9Xq0l2Y9OHvrkT6gCdkFGbvozFk7bLdj7B1tt18sEwBaLrNdOMaeJ9IGQdItYzAwJfCTrTQKdPPu2rc0RSt21+LRkw40GV/44Hp4Ek01yePKHMimOnh9hraywvKzFHZojbPWSswkzPA8/UG5Luau+u8L74egVs1nP+JR2Mgb6Hem0sZPgtuX3gg76Y2tmH4rRNvqgGd74g8+UHvlvnYEuDTw3E/TpkIt1OozeoquSbL5cZxf0Fi0KVYvkqH/+/4Ar2+5IU33oIAbqEpye1Y/4m52RaK3BWvUNx+sVGMBosAZvZqWay2inZ+D+zvo6yiAECHz0E/WH765ftzkGuHcntHY7yoBMAzuTFuxA04ehB2RHIpi75l4zpFpa4agrJrnHlBI2TCL8bGcKBgF5GSA6g426Zogh2mQpiRINid9XXYqlxM7mUwdD330m7zdg1SaBYiRlAvco5qYgvD/19VcXPVDtDnOQIe83pyQJ6oyAC1h/QvIixxCnlIWA32lIwv6x7DGSXMp/h1BcwDIuudbIuAdldK685GWI71//kYCFqqLy1aEwmLcACpBhWhn8HsRhdcxj30Vk6h6j1DFzcLgHaWraKLyWpjOMMfP+B2HoHGOPtDAFzeqv6aC6G8V4wL1HN7uVnQ
 3ZkbpG/U
 FUF/1MP2TuzJtSnmoTBH3c/1cNX5iQNGQ3nEyKaeSz/shU3H6E8NrqJLrNWJQ63DPZzH+CHRt11ZSj3jpt90Y9Z4f9EVYJ51C+sNene6ljnW7xr51Ug81WSL2PSy/sJnW6gK4RqoUaEcUKQcS+cGQkFLqHp9bbbf/ugZ58M9LRlwju0YiLRUmpDLiE+ClAyViy+7Bf4OdOB5rkej+HmsMmlc3UdV0FRi64ugi233kfa3nmdQt9HUr4txZK7lfz1YTo+PnpsTfPzkeax/rupqDIHB81bGpLrVgjwTP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unbound kthreads want to run neither on nohz_full CPUs nor on domain
isolated CPUs. And since nohz_full implies domain isolation, checking
the latter is enough to verify both.

Therefore exclude kthreads from domain isolation.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 85ccf5bb17c9..968fa5868d21 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -362,18 +362,20 @@ static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpum
 {
 	const struct cpumask *pref;
 
+	guard(rcu)();
+
 	if (kthread->preferred_affinity) {
 		pref = kthread->preferred_affinity;
 	} else {
 		if (kthread->node == NUMA_NO_NODE)
-			pref = housekeeping_cpumask(HK_TYPE_KTHREAD);
+			pref = housekeeping_cpumask(HK_TYPE_DOMAIN);
 		else
 			pref = cpumask_of_node(kthread->node);
 	}
 
-	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_KTHREAD));
+	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_DOMAIN));
 	if (cpumask_empty(cpumask))
-		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_KTHREAD));
+		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
 }
 
 static void kthread_affine_node(void)
-- 
2.51.1



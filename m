Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D869CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24F06B0093; Wed, 24 Jun 2026 09:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5AA6B0095; Wed, 24 Jun 2026 09:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CA26B0096; Wed, 24 Jun 2026 09:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A62346B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:12:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DC0D167031
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:24 +0000 (UTC)
X-FDA: 84914845008.21.A638300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5967414000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eu00yjuV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782306742;
	b=dmzaDpX7AzSUAua+yEVTvk3SSLb2P3ceyLaNIqIfgYZ2sMwL8L9NOIuYb1NkMYCm0IZixc
	WL5YtjRzT9OAX4BBXqWsPwyUbGJkVtu97UbPW0VdtU/NLQ7vaGZxuG4cyqUF9gnQTcBFf0
	YqhtjYRQp66Kis71TebcKMwPaXLiYG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782306742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvfxPtzoYVrETEzytIgiJXDO6q4wD9otLoJUFguuBTI=;
	b=FK4e6nzQ8EtyqokcFkPOSQYuEVkIjPc9b4N3xEqzkhlD5bZZ8snuV1ypKJF2u4gRBIB89u
	Q74QqtmEAibek06c3JuV57xdNR/pup6gV3sghQL8DQJcZtRJOY7uG19NKf+L/65ON8ft07
	EgMQCxg3NRd/Q8+28ex5Vo75PYDOUG8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eu00yjuV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E89966021A;
	Wed, 24 Jun 2026 13:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2403F1F000E9;
	Wed, 24 Jun 2026 13:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782306741;
	bh=lvfxPtzoYVrETEzytIgiJXDO6q4wD9otLoJUFguuBTI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Eu00yjuVHuuYZ7bvilLZYLvl9LR6tdm3Bp17QItdQ5RoopaTaAS35R0brw0AkNO0q
	 lrMp7IOUR5wQwrcdhBJWfMOqL7yXV/LVEMXG9sBCnd3/ziydWZAdsRZmb/HYY1iHzK
	 JIh3JrRilhTb6AOop2cWLnMgpoJzRYv2qkD9m6sddfs2WrVpMEEapGgTtD2Ghrwt6R
	 TNDGP/6TLsrZV/YIvjhFrTdyMe9dhM+IY4kXLhxaIqrs40qAI6oQex7rdhwhv7uBEO
	 WcJBATJzFKext9+XgKDABSyySRNpr8xoo+DgFFnT23LOnQBQszdW0SJpJDNF6lsoU5
	 ZOfZAmlbwPBvw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 24 Jun 2026 22:11:41 +0900
Subject: [PATCH RFC 4/4] mm/slab: serialize defer_free_barrier()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260624-kmalloc-nolock-fixes-v1-4-fdf4d17351dd@kernel.org>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5967414000D
X-Rspam-User: 
X-Stat-Signature: oc89pw7zc87ux56kkjhqw3wqx4kfb9ks
X-HE-Tag: 1782306742-545278
X-HE-Meta: U2FsdGVkX1+66ubLRHh5xtkf722pdueqfHnHViY58EUQfdrQyBMTPt6MBAJ2w7s7DS50gfBPQ8Zb2ZD9N+E6ZSd3r5J/573ED5Asy/dvIPmqgXmutXT0cDewo9FNXqM6KmY9CvU1iiY5MQm8M3f5+RF5NifSF79YuysrgC6zodHw3O+vd3NLtwONTBaZSP/nzBY8qxLGNqsEyMF5nK/dE1ta7bN8pMyNfMTi6QcU+reyk8xIPJnY33wnXPIYDnbN11Nb+QbGCsbnC2cTwp8VNL2c1N+Xg5cu2zu0mBhee7DCjEPfonL1/zWgeQ+p3koUlAaE/Xb7t405+n/qcUYr2hpUcI+kKiiLhkKhFl0BfPnYt7nJalbabRowtE/t+pp1262bCdCMHaiArIqsLMKiclXOTjz/2OqkgCuCrESAgd9oEgtXhaKbH6OztcDpeKy+0Pf9PW5/GAx2O1pk4O6bH1Ef/LV3F8XNE6URoV1MRxdEIhIcDCGsI29eKC3Vhn3BzNyQ6n8aXZEarwlmDGnZz6Nq2wNcBXI597lcpwvmpRrk4irbSH5wLr/6oANn0bVlwZBkPOMnnp0LpNF6I7NUkHgMxWMANyj01pTpTRv/vZoAwDp14jae31Qia2k9Rt2GS7D71Ud5NS5jS7f/mj3Io9wVV4vGwAO36+fNvEZ/e+b3PrlePMTj1emM0CCCtqyGdGwlJIX5nb5BjsYJAnKa8AWlhQM64kBcpt+niR3uz4Ti+tJxJyfMiHAxXkIV2AMUd4imX6q2Gt5qV/Mk0yS7+IUgQ9+vHppH8d/VsQBuvCBxOqSlIMo9VnNRZijC8A3MH6BKU4DJBcLykeyVMVt6K8xkMdTYZMK4uHL+h7up7gFWPL5rn1SsEgfOANCqle+YVmey9UvaiECZp+fs0tRNzqnKxi6YAT0S86KEWDpGeF3J38rRjlcxaj/8DWvYzjb4T5tT1glsetaQWtRLSgT
 ErwJGysQ
 hNqhVOdVi+Hqp6UibzcVxbqyAZXufweGcYmVsgQqF/52sXNOcZ1jOQj39+Tr1HMpgUtYXtc/QHhgVEeTTAQhRoB60LgoT+Wg0+BlBsYJuuq/w5FNNofAl5jono6xRzN3XobHS2vez+0Uo0oIgNDFgADBAd4AJs0jcdgSr4rrrWVAnUMSdNWfpkGIU8uH6vaK63faKrQc2jmJiFN2Jw0c60J/NWwJX/x2zan5LQaQrz3vBy1Lk0rcgSxKQFTIdXTsbPdMrpWWtsY3My7n5QeG6X0Fn7zO02mKMHSuPZ6MpRXQCKeSONlbSsTqd90qddQPeT2iW2+bP6KKHDdcQKOWiAGMTqJlESAIC1wEG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

irq_work_sync() uses rcuwait instead of busy waiting in two cases:

  1. The kernel is using PREEMPT_RT and the irq work does not run in a
     hardirq context.

  2. The architecture cannot send inter-processor interrupts to make
     busy waiting reasonably short.

However, rcuwait.h says:
> The caller is responsible for locking around rcuwait_wait_event(),
> and [prepare_to/finish]_rcuwait() such that writes to @task are
> properly serialized.

Since defer_free_barrier() calls irq_work_sync() without any locks,
it can potentially cause a hang as writes to @task are not serialized.

Fix this by calling defer_free_barrier() under slab_mutex and
cpus_read_lock() and add lockdep asserts.

Now that defer_free_barrier() is called inside cpus_read_lock(), iterate
over online cpus instead of possible cpus.

Reported-by: Sashiko <sashiko+bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab_common.c | 5 ++---
 mm/slub.c        | 6 +++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 388eb5980859..27f77273fabe 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -550,11 +550,10 @@ void kmem_cache_destroy(struct kmem_cache *s)
 		rcu_barrier();
 	}
 
-	/* Wait for deferred work from kmalloc/kfree_nolock() */
-	defer_free_barrier();
-
 	cpus_read_lock();
 	mutex_lock(&slab_mutex);
+	/* Wait for deferred work from kmalloc/kfree_nolock() */
+	defer_free_barrier();
 
 	s->refcount--;
 	if (s->refcount) {
diff --git a/mm/slub.c b/mm/slub.c
index 4a3618e3967e..52c8d3f33782 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6411,7 +6411,11 @@ void defer_free_barrier(void)
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu)
+	/* irq_work_sync() may use rcuwait that requires serialization */
+	lockdep_assert_held(&slab_mutex);
+	lockdep_assert_cpus_held();
+
+	for_each_online_cpu(cpu)
 		irq_work_sync(&per_cpu_ptr(&defer_free_objects, cpu)->work);
 }
 

-- 
2.53.0



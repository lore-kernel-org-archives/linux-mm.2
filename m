Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A75C4E75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2046B0098; Wed, 24 Dec 2025 08:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182CA6B0099; Wed, 24 Dec 2025 08:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E4C6B009B; Wed, 24 Dec 2025 08:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8FE66B0098
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:46:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB889C08C6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:17 +0000 (UTC)
X-FDA: 84254488794.02.D5B0F9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3A3A440005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=htqHmciL;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766583976; a=rsa-sha256;
	cv=none;
	b=coC7KGrgD3bEqUZKeOjBbt9To5Fs8/U7TfrlHIdsXpMcub67R1SXFVSVGsKBDzBhgldIlh
	0xZwbZJ5t6ZsUbdhFOjSl6G3jNWscqrbfjZAPQArjwNGhPur0eEwHFGXoDPKEtoR39A6hy
	DT0GDyaSznVPtVq50frCUlapgjQgo6Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=htqHmciL;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766583976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfMR/Z1RHvJoXzr86CrgTofptafDgStvJi/kxysDsOY=;
	b=x/aMjo9TyaT59xZafvzxg5a4VJfljK4sZVUm7AE/mz1tOdWwB6NRKaNPxzvOex75q8oyh3
	wL1npqX3cOtqcBWLd8sUVtf1qIiWpdCIzQkKAYsHyHrVMeZYkNNXoNNrcHxfyBmlMwgvC5
	+dV1k7kUjlL9VyNrd1lKdm2SvvgZ0II=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C13EE60135;
	Wed, 24 Dec 2025 13:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6704AC116D0;
	Wed, 24 Dec 2025 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766583975;
	bh=oYIDljVusPRyc5ygPH/YiE7a9Fhd9e2pU1qivro5W4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htqHmciLhDIlwaAafpUU2VX1XDfcCQEG/G/wYBGqRb079YKOzQ4bLKuDSO20ILSbT
	 x2ty2FrkhGcjZGmNhcNmU/XB8AIWGPf/OFBLStI85bMZdQFAmzFShHb3qUa+DBeXsL
	 5uUPDkZhhIXRn+GO1UNkvMkdEkkexiOP29/cwdP3Gid83GGZU3YG/Q0/T9P1LqjAKU
	 F1HAzDo2rY5jq99eUCywOkGr05yck1Ixww1LbBMc0+QCaK7qNicMaB53+WM1SMi1LB
	 MZmedPl3zj6CvYqKtcScMTcR2Amms6hosgoprArwalGEXKya77EoHgIlGEufV9r9EB
	 qCBxAiEKpDJQQ==
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
Subject: [PATCH 05/33] sched/isolation: Save boot defined domain flags
Date: Wed, 24 Dec 2025 14:44:52 +0100
Message-ID: <20251224134520.33231-6-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A3A440005
X-Rspamd-Server: rspam04
X-Stat-Signature: yrmxcidkpr5fu9ggf8ufm4huymd4sd43
X-HE-Tag: 1766583976-637676
X-HE-Meta: U2FsdGVkX189RMred6gYciGW0tQH3WlQ0MtVTX5L58/8szh6YzAsuiOoHRP4nmvwGMm1dfHgt8R1gj2MGx/4IdnxeIx8rsXIMkv2sc9k4eVQZ0Vhh7OlXbaq6O3aBtVFOUlbw7q7zUBoskgCH4kqaIPmqEW1frM8CTp2LouqEGbvrahclPZQvBQzLdGwQh318n0Bd9id8NajggoE6l2vOQFRQQ7Z/G8z67x9Gn52Zfxg0ToPOg4e6DjqQpt2/J9/mnuMVHFqKGujQLI650DFWscXapJBRKlj0BdvPgbx4CKD0foOromJhJ4RCI0/mAKK3hJXSTwzL8n2tFt+y5VQTmqjIO/zuxc4wjiLkBSQMPZK2H1OjqjJUNrxrLa/Q3BjCFn9FenWvady/OC3DU4kp9HiuViEZGYVdwux6YYwycrjPglGhFk1lLusl+AcyfWZAqzOOSBEam8EGCbCXGn74DuFnQ8SiRUpRyoUyP0XVyXgAse0YuuFkrYgUxDPseK5wzf4Fw7bjrwvHLgSydPn7HWhUHiLHCov08G5XKKbADEFgir0sCdYQDnJLkXX6LM51nCaChNtqnD6XsdFlYyD5kXkbaKEm5p4YodaWBGOkS0tj+mH2gXLnYaQ9haaWzfWjBfFq7WcQOx58xfOSKYwR32aVgOFRKC6hXcg9jRPER4mxygU34FW0xM3JBdAC0pgvF44fVEVujn0BFg247DjLrEIfsaCWi2VQYxHqgv1E2Q9Q9bIbqDDwaiXpfF19KtNiXCoLtkcbk1uRVxMztL0Rb98NjW8DEf9lrGtDFj6P7wqWKs6bdkwT/15kc5ybArD3dBr3huw9Mju8KHM8v4+fD/ymM6MSFdVQgXrhOl5+WSwVSLgxm+B63QNzcauNSnXTVe5rnGnqrZGTjYvJFgVw0quI0+w3Swq3feZgxV9oSHtlvY++CLDyAPOsgcsStA5CTKFooJSEo+bPRYHuJS
 ndy8gnDi
 MsOsBjNTHLYB1aw+RHHmxpgOkprzTMXRdCYjmqTwFfRuIADWPw60bxWysGrvSs9zNP/GxAvIpK7z5OEsmBkO7XeycOkGzCiRJCOgcNW3VTZldZiWTb0VJ4hiNz8WSADqNfSUrq8ZQtDy4euFo8tm8bm3fEycF/bFDbuuCSjN3vfI38ytNtDOsVjX9TY0kk5d30NMmr0ZxPqle9wiYESOkOSWdNXh/7hDGAR2Fn4KZoby9Z6Ozi5VWV8kKS/RO3XllpHs89VwS4F/fF3sywzaTt1CKvVRJEnM4M77K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
but also cpuset isolated partitions.

Housekeeping still needs a way to record what was initially passed
to isolcpus= in order to keep these CPUs isolated after a cpuset
isolated partition is modified or destroyed while containing some of
them.

Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
---
 include/linux/sched/isolation.h | 4 ++++
 kernel/sched/isolation.c        | 5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8501f4709b5..109a2149e21a 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -7,8 +7,12 @@
 #include <linux/tick.h>
 
 enum hk_type {
+	/* Revert of boot-time isolcpus= argument */
+	HK_TYPE_DOMAIN_BOOT,
 	HK_TYPE_DOMAIN,
+	/* Revert of boot-time isolcpus=managed_irq argument */
 	HK_TYPE_MANAGED_IRQ,
+	/* Revert of boot-time nohz_full= or isolcpus=nohz arguments */
 	HK_TYPE_KERNEL_NOISE,
 	HK_TYPE_MAX,
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 3ad0d6df6a0a..11a623fa6320 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -11,6 +11,7 @@
 #include "sched.h"
 
 enum hk_flags {
+	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
@@ -239,7 +240,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 		if (!strncmp(str, "domain,", 7)) {
 			str += 7;
-			flags |= HK_FLAG_DOMAIN;
+			flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 			continue;
 		}
 
@@ -269,7 +270,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 	/* Default behaviour for isolcpus without flags */
 	if (!flags)
-		flags |= HK_FLAG_DOMAIN;
+		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 
 	return housekeeping_setup(str, flags);
 }
-- 
2.51.1



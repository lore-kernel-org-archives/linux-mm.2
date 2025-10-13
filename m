Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7803CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475F48E007E; Mon, 13 Oct 2025 16:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425638E0036; Mon, 13 Oct 2025 16:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314878E007E; Mon, 13 Oct 2025 16:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EB8C8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:34:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA0551A05CE
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:28 +0000 (UTC)
X-FDA: 83994243816.28.D3949CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 39EC81C000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIqfo6Gi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387667; a=rsa-sha256;
	cv=none;
	b=vvqJx/x/WlXtsr+Eujp1fQx3duzc+H4jRqu6jPNNlU4HgkHY8Kca8FkRpyT/RAzxGxMgqB
	4swuhMon5mqJW2dCI8vN4/2Zuqd1FWhIUgC7V0ZtrmMggNp3bXcx9sI9wXsBb9o4cP2zZ3
	EcJMvZdGRu3qvebFBPj2BImTVlSXIio=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIqfo6Gi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6xSePBdSAfXbIrbgqNKw5l84lZlag0xzdDLqSYpGok=;
	b=wFhq9+d6xr+g1ajw2wjlBNaIvOH8sLSyy/HmF2xvHtweT4ya4jtjtGLuE9Y22BVmm22d6q
	cA1ingAaQ6Rpy4Rib1hPSrtrAcUdBF+Orm3blLft5w8U+9+nd4Ma2bmvmMw959PRPKyoZu
	XO2kHLWng9rhfxg7WA8TsyCgSqJe8Rk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12C5C48C0C;
	Mon, 13 Oct 2025 20:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506C6C4CEE7;
	Mon, 13 Oct 2025 20:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387665;
	bh=TsDxN2BInLxMlytlUzRu0aLqwxbBAplotzVpHgLAL/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIqfo6Gi5gmdQ7vxGe7RqxhiF87X33Q1XJxWoIlbndC3g6WBMuC8hkzSgerCI62/Q
	 BXhf3bGN2nKsvv6D2OslGLIIzuqA1eL4gsae4q7JMxc0SaZgp03l+SdE7qOD7/+E2O
	 fWv5/7ygc7kJGvfCu94f3nf2F+3QJ/8qFmo7JdAwthJVd6bd/p9jcDjrDAEGdH+EK2
	 FGTVklbzEtrI2ReuVUwyzc37WdN9ldJnwgNmpzpAoyGWZIKe+ecidj07oosdP8oW6q
	 KxPv1ONdv2Lk2L0qCLRhWjoKzj4jYjx8EZEcRNsktGgBitJCVs7MEegUbPWKt9ME3+
	 awN/5ogOZslPA==
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
Subject: [PATCH 19/33] sched/isolation: Remove HK_TYPE_TICK test from cpu_is_isolated()
Date: Mon, 13 Oct 2025 22:31:32 +0200
Message-ID: <20251013203146.10162-20-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m9eknt43uwkafe8sjqeiqd14q7rx9u6z
X-Rspamd-Queue-Id: 39EC81C000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760387666-96721
X-HE-Meta: U2FsdGVkX18w0nmvmJ0Av7wnJv5JlTcgUjtiNlejfMwdK7jXZ/0GE7VjRnRW2smEtoBN8sELiDZjqnAuCfjlFQR+fVzzdk+9EwLOR3q8/wy8fq6zmnZTjrMGiF7ct3XAbQK1HEervUparTfYq2P0xiAjsE0coMG1Yj/QeV7yRMcPeUycAQjU008z7y3XlEarab3Q7lSa+YSXWVTE5ItEx8feYUmDiaHV/HkKJnKr4GlYwkZh15p+ZFDITqw7tIVmcnh7oJpZU3WkX/Stcfm2FGe7pSTHJWSpZ6La50d+N7iKiH9dRyweu9zkL7yNy8BAYsVPb2aCWL6Z2epYf92yNTLG3OTVQVlhLMVNa69vQruhd/NJG6ZY1xtOCfk0dLGcTPkl3l0FD6++Em2Q+JHM33DqOBPeChRs0eF4e4+wF+BzyM5En9Zx8dVemPS3bbZEIRJANoH37fcxkbVAG/pdYod9LH5uuUPHAEw4MseJPbVxiaqeuDEETidHU4sPLTc56/4LLfGios2S1jELO5ROzIysT4CO2T/v0fDlGplUUl+gnSBsa8HGCXX8AB3fRS9SZPwok8W53C9GGnwSTzR3tVA0ZRM4qsKij9ANDaKwzEtU2F4Rb76VMtd4udgmosmFODMeW9wtFaSjtBlaM5gC9zZXCDWMXRbUENQlVOmnnTtuI4ICJYhe94OZTu4A8JZCvQ0jAJVeqmdi5eN5GmYFL/dUImbwDDBf97vd5D0WxD0xAm3PpeJBXt+ZfoKV717GFfMNR6oUUNrrY20AxysDEkTxEEHlQxXtV/xdHhRXqVfIaZzZhZO84sPBMKJ93mRge06LkPulRCqsAht6i5Y8NIKBuhlQrqSJNRySJt6HWu1CDUAyLQ/w7wYSk/5rDe5jNCg0OK5KDluZG130t0S48Ft3F45ad47y4XOq39vyUUP30XLj++ACt3l0lKK7v/AvGwWdmlpfK9YB0SC7xUV
 hIpVzEdM
 aWJ0H9tf+D292v+yzbjWq3RzmMN+wiMx0R8ZI01U/T1CqrNVEbZFyIe94NSJ2K0VXUn8cCp11Y4oZRohoHD3s+41jF7C42tng1IyOpiz3uWHAUQ4v2Lbii4LqmToRPsCvZ301vIs8wvT+33X0AgQ5bvqs/a4tZOtW1AZRF4a35LEfsksgE80ertAQ8trl7Tbj3CmLgT1p5HSgqx2vZYumRMPo7ZGHf+asztQkWE/wQIw6QxY3g9wAoLSZu9rRLT60KxhEV/ZqhoLNnSXmnT13bxhaON3UYYmzEBJSrba0AV2nz9qhQlI9jDFNXCeEm72S1/Tj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It doesn't make sense to use nohz_full without also isolating the
related CPUs from the domain topology, either through the use of
isolcpus= or cpuset isolated partitions.

And now HK_TYPE_DOMAIN includes all kinds of domain isolated CPUs.

This means that HK_TYPE_KERNEL_NOISE (of which HK_TYPE_TICK is only an
alias) should always be a subset of HK_TYPE_DOMAIN.

Therefore if a CPU is not HK_TYPE_DOMAIN, it shouldn't be
HK_TYPE_KERNEL_NOISE either. Testing the former is then enough.

Simplify cpu_is_isolated() accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/sched/isolation.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 0f50c152cf68..eef539820de2 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -75,8 +75,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 
 static inline bool cpu_is_isolated(int cpu)
 {
-	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
-	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
+	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.51.0



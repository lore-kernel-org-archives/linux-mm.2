Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E93D64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206656B00A1; Wed, 17 Dec 2025 02:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6EE6B00A3; Wed, 17 Dec 2025 02:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0586B00A4; Wed, 17 Dec 2025 02:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F04836B00A1
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:31:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF7CA136CAF
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:05 +0000 (UTC)
X-FDA: 84228141690.22.6EBCEE4
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0D4AE14000E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vm1diLNu;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956664; a=rsa-sha256;
	cv=none;
	b=PbqLg75hfAkBc525hyFOZ48bbAWBjQr76gRpNPbrHurgFuGX7A5bpdCxd6IckSjcE2IXuJ
	B6wEU5BErxQAffZwo3osiDtEPL7/QY/jC6hsiTyGkw26rzzPjBGOrhEpHN76fWB52FWkcB
	UEdYvEbbwtMiAZJlRQHKEcp11w+Wxus=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vm1diLNu;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKohFIfUqUoJgtR0v3jBFvc4zN9jyjHuINauLbc6uS8=;
	b=gu8PT8rOn/qyfF/OXxT0DNNc7vLCSfCJ6zt0NLbVSFqxzRd9YrHgqIsrUM2OsuUJnF9dRJ
	qlM//s0qKER5kddXn0B2WR0VpdAkNu3jg7+qzLY6pNLPlKSZB89Rd/upfieVqglu1s4uJz
	zK97F6d2jMvTPwKZf0SeReUkEdVJpik=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WKohFIfUqUoJgtR0v3jBFvc4zN9jyjHuINauLbc6uS8=;
	b=Vm1diLNu7R5n3RF3dF3GkU5FENNVYHqQ/FI+Kuws9mzfZAlFuI50n5b4rAfXOETi4aKA4D
	w353FHFeu0RHicJH2cE8lKXmT6xoKaStiAgtLBTHiJ1oNcNpWYzzxEUCjkQt0o7QBP1yko
	IJGaIa+hPaBFrWjsA4Ls4pWDa3l2niM=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 11/28] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
Date: Wed, 17 Dec 2025 15:27:35 +0800
Message-ID: <5f8032bc300b7c12e61446ba4f3d28fba5a7d9d5.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D4AE14000E
X-Rspamd-Server: rspam04
X-Stat-Signature: nnycpzxbfry15gcyd6mfiri3877xm1uf
X-HE-Tag: 1765956663-476316
X-HE-Meta: U2FsdGVkX190U5D4OQHta6BjEQ7INTUgtN1MBR8Y8OOrVerkNSuyLl/wYs01krlLTmo+gD+MDwVLDfOhetdDGQfawoJuABOoJMVsaQwGJKvzQPKD01Q4bdcRSQOILebQ/1/fFu6Qk6JeOX3vKanyJiqJTk8A5yKwhZhQJSaQYbUoqnur88RiczANEKF9siFCIIHhexd41VboPkqaHaRTb7TKcPD+J4qkEF7MMl/pAuMvDJlroL4uM873Ns7MzlqLf5JRxBKmAz0tdyuGwWGrs90ZTRksy/TCX9V+K74GnGxKoUhwXcgZvdLAGt+t3WpL1Ii9NTFvQeJ/hhOr8nWAz16/TP7HmSdkOy+ww2sc1iYy8FCoOPmtIB92lUsqv04EelWBEI+Kjriu7Gsj12Ihh08x9lh5UtCCnpvgGECDcIZYzv/ac9QSbGcjdpTLaE93N3hHS9nKXkhEQqax/pWCXjf46vp6qBAm+k4Wv+s1QVMF9Kr5QmQQgIa74Qt6BvaoxnM5YMUMt3OiWtyKZynCytK7IXTtm3RjUbS5M6K4JH4qWNhb6/bNBTvwqgKKoPRvhw3+7TeN7xZECfvKntnVg4WG4kx7m9osDh/FzWtiFBka0MPfO2d3IfB7MtV6i/BiQECeySuq2rW+qfgCg1WBOYBCJAeN6cCZf/QLiQ83pvifWw3T1aam3ydP3NBUkryOGWB/NxnmXVC6KGPbWSnNq2rjAwAno4RdjGNoOOuDbFa54p/gbSJJacUQVzwsPvpFRHl+DIZxFzdsSVwmHPpwpq7hNNHrvovzb5TLxRUz6igsXdWkGoGbqK62u3c/xhG+kp4XOE3wRYcaPuVPIfm37y1Kp7zGEjqZnoiVtFCwdjD3Cto6pVsDNv77zlxS9vZpJ9MjRdzpgZjs0yXYDhpK0BKKOR0XDIs+Ap0OGI0Z+GHZCt2nUQFErMPD1PFj9EGcs4RrhjGyejgLT+qHrS1
 j8rX9DM/
 U6LBVB7N4P6YzTdyi/y57xJYu4NmaYnz9qHSng/7+s2iVaQAmOlkLm2tomeWxjlbQTjeMc76Z+wYUcUJiBagN8MxZ1cSm4kKUCfDobnLpg3Z0jKuR8FGAoHS/+l04nPo8FLenXZ2ZAK0tLGhxR4901PLpFTS5DdfBhBmLHIGNM/gqCdS8dM9GBXzEw4XzTKJfAzR7KN/15C7ieNKrnm5rvmrFonvKfYd293UPKMSuQ6/O7gc+Dk+Jcsh4pVKsItn60TbLGpkVhGe0XU9YgT2h5Xuxi7KKAN/NMcB1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in count_memcg_folio_events().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/memcontrol.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bc526e0d37e0b..69c4bcfb3c3cd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -974,10 +974,15 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
-	if (memcg)
-		count_memcg_events(memcg, idx, nr);
+	if (!folio_memcg_charged(folio))
+		return;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	count_memcg_events(memcg, idx, nr);
+	rcu_read_unlock();
 }
 
 static inline void count_memcg_events_mm(struct mm_struct *mm,
-- 
2.20.1



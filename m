Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B544F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37516B00A7; Thu,  5 Mar 2026 06:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE4D6B00A9; Thu,  5 Mar 2026 06:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA626B00AA; Thu,  5 Mar 2026 06:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF166B00A7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:56:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 547A3160977
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:07 +0000 (UTC)
X-FDA: 84511855974.13.6F4B49F
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9DA89100011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sp5oK5oF;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFugfqe6/ZOVEb7BRYdC4hEvLiQEcyW+5o69Lqfswgk=;
	b=nNlMVQmQWns6416phFrxVxqjXi1+2LxbsI0n7Tl9gPneeR37IWvhcOJGcutuT/nawz9nCy
	hwGHoX6FluGLGoO9TItIUwTf5h159oNx/ctJ2Vgf8gCCmQKDnsyfDDVpebk8IHfGmrJk0D
	CyIho8Z/KnGfStnd/GJ95xdqDsFrb4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711765; a=rsa-sha256;
	cv=none;
	b=Z3QBK5FzeeDSUd74U7b76Th0nKPPCs9tDV2nA+nIZJSxK99SAdPNdnZuqk43dzVRVENVQe
	8lAXPfGtLN2FCHslvUnt1sf48FWDNex8mBK4LAeCpcz7kK24setN00JspjmQ8qUF/o4xUx
	7MBo9bPVFZMJgPMBu18Ox7SM7RxSjQE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sp5oK5oF;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFugfqe6/ZOVEb7BRYdC4hEvLiQEcyW+5o69Lqfswgk=;
	b=Sp5oK5oFjJ4WgSWliPpVc97gKNr6NqbPwLiwIZw2Z5SdXlWR5qqaGTuz0QH15VeaTPFeTL
	DhNfLnKGRBoCG/NKALOxn+6rpvwZ+0MFsAYZK5mRe2jhWsni/vOgmp0glTUg1xHKOXNwk2
	OXk+yVV6975l6Mvz8Y7qKdWdSI/kOaA=
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
	yosry.ahmed@linux.dev,
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
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 11/33] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
Date: Thu,  5 Mar 2026 19:52:29 +0800
Message-ID: <dea6aa0389367f7fd6b715c8837a2cf7506bd889.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DA89100011
X-Stat-Signature: aso6pwxk3zd4n9soyjpui1denstnaz9c
X-Rspam-User: 
X-HE-Tag: 1772711765-836959
X-HE-Meta: U2FsdGVkX1+8OU+XQGhN0lxmS55hI5M4iUuu3IxuIeXn9Vp2zvwEjLK9w8pMhLmsprZBWPTtlKW9s6J2WApImvtbUQgoe8o6RL4XO7E9TMyLtPsKqiMqSIK3+E6q5FIeC8k7I6tWP3YtomKRydu3mTj5oF/DzB1x/VQB0+Hj+7pyemyXN85LVStLDg3KIUuM5TB1/X8qTYfIjlATm42yRz++eFuOO3ZGo3LWNRaHh/q59chQxMOtSQCHAo2QRMeC82wcye9DrDpG0lWFFccyK34LZATi9dTO4/KlpPJKgfVg3FEuIEZ0V1O9oJyq0ZORwy8oo9LtVM9gN2aw2LcKRMtfpplsnaXyHdYh3y5UmJRaZrpX4kAbut/XrrRAG/hs5zP06Ug17N55ts3U1HecX4cdWZRyJIWNRGos168sWg6BSy12X0wPNJ0h/bj3DhVePxjITjK1EOQlSWqpoa20sgutcpEMGDMKJzizM4E4tq2LRxgoQdJ1K/OiYULEfrxb+clHeZsb4uMczm9PA1miYPvIObMDblbavHGMhxJQOo7sWiiNKRM7sYzbadyyAedTYY+KfPL++GGqqRuXVKIjYXFvoAGqGIzj9D2TuGLsjs3f56M77cKn3Ur2fowpZLg01Gg3t62Vmh5GIuVIbCPlOV7hdUk+C150LvK7AX+H9DTsz2ZmNVecBUwv4uq28nHPozEOqQNbNUR9JerFfI+3F6sQLissUVKQ2MaHIhTWWzu4JWmad2PEon7PxZ8HPsdks+MkYCL3WmTUc7SITN0V4fd3HJ42u1SEDQjSLQE4wA98PqQhjVRfU9id/5ZfWhuAgObQvsD8TaYnfaR54lC6y8tEnzZUwVO71eTccLIe8THTbdbbxTm3ZKEh6XieR9HWYka+0qpa1/2RH87Z8AP2c8Du04asTs3mnBvmGv9CFYIVz5hvAbydBxqk8Uu5teNfbgca86VG1FpBiSPKlNn
 pge5vwwI
 o+Ft3GTKE5OIVLGYjfpsbOQQg9aEBV2U30W06dRCuoHRaEMJRZEI98ROKQKYqAr0qrnZfx/HmMMZ/dQUQ5m43r3LkT4DBAeo/AqlJPcY6hwQFp1pO+wsZUzL6LlhBCLJXhgOIuTwA7uHOQc5g7qlfeLqblHQ04cYjLoDI5RPGXiEE2W9D/J6Cb3cQvYv5VBpK7GHPduw7YLHaFXxOsGFR5jK6nEIr9bY2N5VzqKlsyPQUBR+dr6wsnwe7kPTrBx/JkYcGs9P1Relc0YW006l+CLLDzjtfeicsLPqeFGvHgGmfNs46cSH4TKCUMnB84TTPEimE3qLppD1Ctbr74BWrXOUFxjvHu8rgOJt0
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 20d38262b984b..0fdfb8044458e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -976,10 +976,15 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
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



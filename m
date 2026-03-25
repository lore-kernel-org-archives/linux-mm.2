Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 489ED103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B029F6B0096; Wed, 25 Mar 2026 10:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9AC6B0098; Wed, 25 Mar 2026 10:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16966B0099; Wed, 25 Mar 2026 10:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9223A6B0096
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:14:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BB6BBBB74
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:14:27 +0000 (UTC)
X-FDA: 84584780574.02.25F2788
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6EBAB4000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:14:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZAJ6icaC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448065; a=rsa-sha256;
	cv=none;
	b=WOoykMsUk34F4YCoL+btX4FqHvNJqrYg4uMBP2XZGGN8SPyioF/U2jPLKTkQYSbpYLXRSm
	XMYjNWVpSZ7/2K56LnsRVlseA7iE017uZHda755cAe5owmvhOTj8pM81TeBHspnUgCjzd7
	LzCk8MSBAVMin0cUgCbRHgquqhso9WI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZAJ6icaC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oW5WwMfr6eST7PZhdxPXZ5zdHEpOxSHtk2D9WvewHSs=;
	b=U+CmJjubk/NUVhRhyqeQm1MPoiYmrEMb1O1WubKSMB0hnbw+Rg/eoGfFZJCvescxQgGkye
	WyZ8+dG5S6BS+sVHin8X0hiuZ+V6CVjk17YscecC+OxcAGVql9jhIrs6BrftmErnWixAPw
	ZvS6NMV+ni/XEEyxY3+0hmQaVAxB4NQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774448063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oW5WwMfr6eST7PZhdxPXZ5zdHEpOxSHtk2D9WvewHSs=;
	b=ZAJ6icaC2Mog6ze6nBhzlho9byETaTdXK5NdsvWgh2j5dvfkw0tycDQ3PcNU8Lgtukt+Gf
	0S6coAB4SLLUVt5wVSQ9M7s1JWKqERa4uU2JNlbXBakpMS67d7CEtNOlEoLZSl4h/LGIuW
	wSzf3MXy5Wc+ZTr/0Vhtg0FVzh4ikTc=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 3/4] mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
Date: Wed, 25 Mar 2026 22:13:24 +0800
Message-ID: <c5b169a3056ee634f6a38cc8cb349d6be541df6d.1774447069.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774447069.git.zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6EBAB4000D
X-Stat-Signature: 787xicenqd6qoz4fk6gnkzz5gez4gcue
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774448065-232110
X-HE-Meta: U2FsdGVkX1/vusJ0BsgZ4+30HJ4PkmjnxG+9sfi7MD88M2P5mkuQgEjQmYL7QL5uylAsyZGDBHaThMoFMHm2Z6h1BY2DzFZpIFqB+6kXQXU2S62vOd1xAdntxraiJzHRx+vDPzkyEzqJ93yp0+GeVbZKLsjkoHYNwMoqY8HkwMsFi9IQhMAHIKgSIgRhClvoXdSPHxz09Mz9ep8nUtlLEhGlaEmwZ80pvJqBsP5QOSmFOVVSAgnEm5lVX3nLqvmrzOSpLzjbOGDvgw8Wlunicp/N3a7RluX+KLCpYD9Q0gHFwi0LCL2GNOy5Z7bhXUUxg4OzFZqbeqdj9nQVn1R/Kl0S/592+cCTZvgjdOjXe0u8Yz8ywUEttZgS0cA4b5YCp2s79WYeyk9DLcBY9Qn6h3OyJlfKa1Mg/ioH3+qBUxzC/FRV72pBu6L2gQtvIioVhnWQV0isooTBClrMJlb3Pib1yfsot7/3kULX4Tb/fXv71P1ABB+ICNJn4qbC2t/jS2wXkB9SRBdmm8IfzrUHjTjQWumKSTVVYIIAcFYjE/Chuf17c/g/Gk/D3cuFHCFE+bKEV11o9PXZxYJazPEH4rCPebL9XkqmL5wXdbuuq+1zHjpeH58bn3exJJx2YS/HwqA3j7rj3YqHJ0vK7irlStMEAJT2K04oCvamiNMY1xtT6pjSiV2aQhRhuod7n0gHGjLIcwCIznwBz+zjRk+rJTh65xJ10h/oJbUQKsTO7td/EQe2Y8UHe+Uo9EYZUp2BifIS2sUva/xIOe5dvCNqAI94CMQ3vylCciRv9/LiPmAeIeB3yz92SVoe8j++gssUA8R25hFM3naJqrIwK7v+uheWluiXSsYKLQzSU8PrmvAMQZdUBl4FE+mviB4y1Rv1fYYxaNdY4Xc4yPR+VPwD5GBXmkFxLk2tG/u2zUN9Ta4U6200ClpUvs9CPQfqh/yRf6k66NyDZgkh3OX2wuB
 cb10BfT+
 FqGPhp9i/AsYNqBBt0XycniFADlqX4AyzesN9R0QZOEupepQI0ykFXXGx7LPXgRGeiNzoC6KqvfCH0Xy6iuchhsQyh8kPHDPyhv3xPjeJq3LC5g10sFALNwOFhg99z5FJimdsjfXbQLw/rt8g0YE5rx9BO5UcX61uE6O8u/VZVKHwsilG6IejGev7jLgRyGoMa6Uz3bGgbEbOKezJhiQTbnE8gseTF1sPuYZbs1Ej7ol0OOM02J9+MH+7qAvrMHB4F70T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The nr_pages parameter of mem_cgroup_update_lru_size() represents a page
count. During the reparenting of LRU folios, the value passed to it can
potentially exceed the maximum value of a 32-bit integer. It should be
declared as long instead of int to match the types used in lruvec size
accounting and to prevent possible overflow.

Update the parameter type to long to ensure correctness.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h | 2 +-
 mm/memcontrol.c            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0861589695298..dc3fa687759b4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -878,7 +878,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 }
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-		int zid, int nr_pages);
+		int zid, long nr_pages);
 
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a78550f6174e..04076a139dbe3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1466,7 +1466,7 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
  * to or just after a page is removed from an lru list.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				int zid, int nr_pages)
+				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
@@ -1483,7 +1483,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 
 	size = *lru_size;
 	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %d): lru_size %ld\n",
+		"%s(%p, %d, %ld): lru_size %ld\n",
 		__func__, lruvec, lru, nr_pages, size)) {
 		VM_BUG_ON(1);
 		*lru_size = 0;
-- 
2.20.1



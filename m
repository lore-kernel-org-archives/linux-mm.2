Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F70E7AD4B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64EC46B008A; Thu, 25 Dec 2025 18:21:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F27C6B008C; Thu, 25 Dec 2025 18:21:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F2F6B0092; Thu, 25 Dec 2025 18:21:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 445976B008A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:21:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2547BA21C
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:38 +0000 (UTC)
X-FDA: 84259567476.27.1E216D9
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A7AAA0009
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V1Ud422M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766704897; a=rsa-sha256;
	cv=none;
	b=Q3epXS1MJFyFbr3OsukxETjq6qXaYY5SygiJT1XoJYvDGTBN+oklUJb273+BoK/pRtMKig
	2yFFBmdP1vLBgHCDZkRQdq51rBD8LSBbjDzj36xT5fWXhP0NsQR3hQhlOl2zKYCRJAKnJM
	+DPprE55AVSoSAByU5BfhvsyJf7+LNU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V1Ud422M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766704897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0ch+6yI2tUKJ64buXx3qfBV9aEKwt068abp9sUTgOs=;
	b=HTi3bXdTBpsqlp2uEa+D0EfyqffSzxwvVubp20WsIc1h91ZA+Vx0usYJodelUYhNeUwbdN
	g617g71UGVn9wG5iO8YPNBgzODPztVURs1Mey4P6HRHfiqIz0h3YllgJRbdS3MvLPm4Xyi
	t9s0fEKnFpeuQI/pNL1xc5n9vSUA6Zc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766704895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0ch+6yI2tUKJ64buXx3qfBV9aEKwt068abp9sUTgOs=;
	b=V1Ud422Myo3TSvF6ot7WDW/igs4tzP3Spgllu6/P7t+yRgxB7sI+zS3mDjX1I21L2u889u
	tqjQR3Orgezg0Y9YJj/O86Yg0JdwIfK39WId2zS0EWkLKrgb9HIm3GEFOB+HcLG+3E5+Sb
	Gr+pB7+MPupund5xTwfR5NYHdHmprNI=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] memcg: expose mem_cgroup_ino() and mem_cgroup_get_from_ino() unconditionally
Date: Thu, 25 Dec 2025 15:21:10 -0800
Message-ID: <20251225232116.294540-3-shakeel.butt@linux.dev>
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3A7AAA0009
X-Stat-Signature: bhi3m57zsjszzcksn8bn81b9bdtn8nkb
X-Rspam-User: 
X-HE-Tag: 1766704896-139888
X-HE-Meta: U2FsdGVkX18ruC66xqMndsUDrJLrJclpCbEiE1fvyn6Pc4my+RJQH9ZkNMmpOhFDukx9266RTrBAKZPuACQztq5PCXuC3JtFE9Zjrn8fr6I1s1o04SLZjm03KKL7XqXto/P6pq9+HDbHKud+xBV1G7YQIIstBwzdRNopJzsCVStLsQBxhxSY8O5puaXHnBCfVw71f1g+d6XuUIuEpZAZfqsh59iYpkQyA8RPXALPqqARlL+uyXC+BD39xG2f5IiVsrkieX74KIOQaXsGMsyofdsBK5IYn9WJnCP9wawTeqmNJfZBnFBg6fEz/melePvypqsWmokd8rl+ZTXFL4AoJ0Qc8+nJGt2DtuvfavaCo3khNJ9Wdw/9f/GA9xLudOmEi6SImsUMpYALP2JhJoMIs/+/AMUrZ0OcO1ZhUeb/eI/1iSV32ew+kAL2WNfn/ok3Kb5uC1rW3himyiQdpi9iCI2WaaC6lpJBP+zqYk2yS6sRn0/HCb6R6Xkt6xrT6G4thw13qeVfns74mZxzNiNdygrWfEC1GdP+vSbNeUIws4oIke9zWd9p2ovGWNhUbiECb9KaumQJsG0iDGkgZPYzLIhFcTimIHToKaRu52XAewbhk3lLJbDNHAohq7fANyMVPifNKBcr6Z+/hYG0Kw3Ae5+b3UySoAQRUKjNPWvAKXJeKMyvxzcaFF6tF1IelpflLlf/Ec8KoNbtnVnKI0C2ZcWJ5ZznMsG6SIMCfhDafD1c/OQEhyRnT4eHvZwFoFjIH9K+XhZsXXam3T7ODlEj/35uwr2fcS4wNmz+bDEw7aGAKxqTXqh75a+2diG3zpaYHCw4M4hvDVFZYDCmFRG5Ncp/tbV2CbyRIl5agUsecNO9PCZmKtOgXIsvAJyj/BR76OCHTEBNv4RsBjTU34XF7fQ8JtaDEdn037JewZAq4Qi4xoHLuhRIFqxm8ri1Fl5k/nt4bfg8ocG9YtAQxf+
 HohFJwcU
 6EpOKUPFrI9cs4/h+KxL4KAVG2KPrXA9Erzmchby2qIf+Q2iYC1wok544Aq1DHAE0113uh9TN7ok1TFBUAKDNuXRJmvu+rEwt28+tubZh7BheuPemmZ0tGqH9MPyXM2loi3WKXYDb7E0sK514RZY8n8aLlfzynR7TEEEZF60GlBE7pQ7nlfOXFBAs09ku/puJn/LHtgYb5x1QLe6VwAmAxjFdGV0chtu+2gczVF8IjcjBrpwZGFS5oBHI2CCFx45P9qL6ZTLpNySH+6Fbqi2pIBa/rA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the CONFIG_SHRINKER_DEBUG guards around mem_cgroup_ino() and
mem_cgroup_get_from_ino(). These APIs provide a way to get a memcg's
cgroup inode number and to look up a memcg from an inode number
respectively.

Making these functions unconditionally available allows other in-kernel
users to leverage them without requiring CONFIG_SHRINKER_DEBUG to be
enabled.

No functional change for existing users.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 4 ----
 mm/memcontrol.c            | 2 --
 2 files changed, 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1c4224bcfb23..77f32be26ea8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -836,14 +836,12 @@ static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
 
-#ifdef CONFIG_SHRINKER_DEBUG
 static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
 }
 
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1308,7 +1306,6 @@ static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return NULL;
 }
 
-#ifdef CONFIG_SHRINKER_DEBUG
 static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return 0;
@@ -1318,7 +1315,6 @@ static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	return NULL;
 }
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 25ad8433df2e..e85816960e38 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3620,7 +3620,6 @@ struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 	return mem_cgroup_from_private_id(id);
 }
 
-#ifdef CONFIG_SHRINKER_DEBUG
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	struct cgroup *cgrp;
@@ -3641,7 +3640,6 @@ struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 
 	return memcg;
 }
-#endif
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
 {
-- 
2.47.3



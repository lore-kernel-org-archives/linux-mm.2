Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5143CC624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705B16B00AF; Wed,  2 Sep 2026 13:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBFA6B00B0; Wed,  2 Sep 2026 13:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6197C6B00B2; Wed,  2 Sep 2026 13:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32C026B00AF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:43:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8ECCE80299
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:39 +0000 (UTC)
X-FDA: 85169544558.28.67359D6
Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	by imf05.hostedemail.com (Postfix) with ESMTP id 95848100003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UN6z/n1c";
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5yd/d/ED+bXHvYjaqPRmnzOaJ0+lLur0uDPz8mTtDg=;
	b=kPXV36KlzQlh2Ta75n+JL1Z/Y07Id5Jny6UB01xB/ITTCDn1mKdfLZ16uRUddXpVQcQNAR
	TdZSMN5c9iZbFv9eji23vqkqR2K6qo0phbslM5gnFU9/6QMbPIIT/BvInY+fuAOwCrjIhN
	UJX13xp2HECCk7PO6iCfojWxILk3WFU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371017;
	b=pbeBWpr7iPaTqpihRi3ymEL8jyYgj/KKxuXx+lEWq7Atkcj1Vuxjh5Cd7e08okDdKZ5KwG
	YHfqcCcGTmSRtePKFQBA1KQvyqtiMTqmoutnAeuh0+Po6t/dSKFyA5iLAX+AEEuX5DtaCH
	STS9WkRnqfL2VhZZsCUqeuN5UuWoksE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UN6z/n1c";
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4dRS80kpsGVD4l2ygd1KyYake2c32jhgx7HQ68nHlXg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371016; v=1; x=1788975816;
 b=UN6z/n1cHLAg5WD6cn13vdsgGfCAFlp51wmF5wGTPtc2h4fSOQouzU3xsZzUh80+Wh5YzKez
 WrUvYCHCz/aNBPZAQozQyk3k29v+OOdcnwrv31LNdjHPs5QmUS4Kjpb8ojDolKZp38PBJNa5xFm
 /kaj7sQg4DOINw0JE7s/1QoI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6cb6e875af4750b6;
	Wed, 02 Sep 2026 17:43:36 +0000
X-Mizu-Trace-ID: 6cb6e875af4750b6
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] memcg: remove mem_cgroup->soft_limit
Date: Wed,  2 Sep 2026 10:43:10 -0700
Message-ID: <20260902174311.1772372-8-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95848100003
X-Stat-Signature: rfhi8xs34ph7m5xzty4yr6x4szogcrou
X-HE-Tag: 1788371017-838553
X-HE-Meta: U2FsdGVkX18dvwPs9a4WqQ+kGZi1HB1vJfpWChIu8Yu9Wtar61ceHXA7gxUW1rj3iEPLikaZDDA2hkyEroOJwkBplfx/uUTQLj6REnEchjr4JnvYXY4uBgRp+NPTSkYlJvOJECIw6m04/XyyLOiA60h6HtokvuuKTQm6Cz0gYCixhX/D1UPH2ikf2l7EOeVOWVdA8UT01F3Q0cC0jfwQm9rf/OWCXXL6VCsddbfi4ytUifU4EjAbOzPe90rpbUuNuJSAPhzd8xZ67SHbPNxTmDxgMO2n3Y67b+99QHaYtTA6N9/5ytLpyUy1oFQ+4Olf5Hb9c6HMdBdyxEuN4uv122HwJfHZzkOQ5nEmNK+aleLzMGZlMd0BY4xF6TNoljlGTGUbX4X+T05MGGFtGb9Oek83h6+Te4FEdVB7kEH3lNy3NuyVnJBq5HI4JOUje236d8s9sxjDiui+d7qL0gIpAfAZmDjFsvccGWWYFDvRoOHkqm9xwrey9ezn+IxKR0uyaT/b7a+nYbjeuEdeHlKhA0lyX6byqkK+Mo+VvaNGOf9o/5GjyeG/28T5sZPo9k54fsmbcK7UHY3segQBcRIarTKNDr6FWWZ8bF3x3UcLlBRjsqDdY4gB842SlfAJqyUIivNEO3Bnx19Ujajzya2hyLuplt4tsAyXTNJKvID2dCWH8NQhp5kYirOE/I8Q6CnMxQHPSiKcWZUoH+3M35+ZHVfYSlfrbd5NzaFYMuEARMW1yPDNefIZZbE4tR7hH/XVSmJfNXMlBNUDXkTP3rn5aV2skUFMzARwkaEJpjcr7/s1K/wcif+6TJof86s4M0QmDUSv+YhlUSy46ioDoW+4vkSOrsnAiAu3CKzp7plWxIp7Zc1kF59UVvUfwd9vR8iBmhzY382RcDEDQmjw60fY+aQMHyI6Qx1r0OWNW/TmsZ3ibCDYjuJaGSzZoMROQxvRGlmuG7M8yIbbbjmDypU
 0nK0+4eP
 K1aDb/ihoPLzH0Osv5q9J3rvnoGa7UAYOIDUfGslw+Pkz87kLOxmfa5voKRv2bMihDS3vQ64dyVUVUtD6oO8pz+yDFsBAjvEPtojRpmU9oxDu18JMBUAxXl8rWDymOvOkqHJmTNUV3JHGUjWueND6kcVHwEORktUCrRkXBHuIRNFWm48Q5w9AV2VrjkcbOCN/mEl97zdRWdW6y1wiwzHCFVPow9EytJeajS6ZlCU8M+36LobGMQCsXVyTaSFGJmzH4lMxwwx2JdtgidsZODFHOtPCNtH0NjM4XH0sMFe/d92ZKlS9S4u/lDbrpxg9knb+3nU5rLzht3YNDuuRRUdOnTPxuHU/I6d8wog6TjbDKxRiDaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nothing reads it anymore, so the field and the helper that reset it on
css alloc and css reset can go.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/memcontrol.h | 2 --
 mm/memcontrol-v1.h         | 6 ------
 mm/memcontrol.c            | 2 --
 3 files changed, 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1eababed16f5..c79992643556 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -280,8 +280,6 @@ struct mem_cgroup {
 
 	struct memcg1_events_percpu __percpu *events_percpu;
 
-	unsigned long soft_limit;
-
 	/* protected by memcg_oom_lock */
 	bool oom_lock;
 	int under_oom;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index fd611e66859a..f48d0e22e615 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -42,11 +42,6 @@ void memcg1_free_events(struct mem_cgroup *memcg);
 
 void memcg1_memcg_init(struct mem_cgroup *memcg);
 
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
-{
-	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
-}
-
 struct cgroup_taskset;
 void memcg1_css_offline(struct mem_cgroup *memcg);
 
@@ -97,7 +92,6 @@ static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true;
 static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
 
 static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
 static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29def0376819..bce3962dba57 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4257,7 +4257,6 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 	WRITE_ONCE(memcg->zswap_writeback, true);
@@ -4464,7 +4463,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
 }
-- 
2.53.0-Meta



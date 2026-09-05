Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C873AC79F89
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 03:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD286B0088; Fri,  4 Sep 2026 23:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95DAC6B008A; Fri,  4 Sep 2026 23:05:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8738C6B008C; Fri,  4 Sep 2026 23:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 645AD6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:05:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74197A0268
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:38 +0000 (UTC)
X-FDA: 85178218356.07.ACF1CBD
Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CF8440004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:05:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HStncYxp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788577536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bo+8lh0FS2/pAt/EZWnp4rB5jU6RaywoYOp8R0OCvAk=;
	b=nBLyyDb6UVF/iirZ3qU033VSHjE1NoxtkDucNtNZIapR1yMl1+WxSZvIylfx53JjzQtbyY
	CLdNjYC4758wJkDLq2NktiCcEvzKsfPEIFAMiOIKEzGd1vNeObs6huaWCZmOCntFL6QEwB
	69rPsIdhlTbeSuEojZSUUOJogub4nGM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HStncYxp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788577536;
	b=h0hSStYg17e7FwBpInFzADqPb+3QW0+GYJy58Du8sUFixRMk5RYCHb7BdKQqqt3arKcRwG
	icbM5vsDjZK+H++5GMXLGCyysWa12FYz/HxNUU6WSrZSTmPtWWyGrNEFQETEcZKly3BoqS
	RTz64L5v7oDzf6rtVq37e4NE7o6n2iA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4cZX4eIodO4viC5cG7gCwbR+5LjlqeMBqsKEP1IuJbU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788577534; v=1; x=1789182334;
 b=HStncYxpeld1YLlCwl6XNjWg7noZwHELol0QfrhhNhDcwG5Nex6VFG/f5wgHptKm4yBSz6AZ
 xOrBGAxAwmM+M1mT1xfYaKl5sSNo/atEDBARzOgxDpIytIt6+aiZJXUo7UwwIIADrdHeWIoI5jS
 ybgErSBCQ4LHcpEr0Cw3EtqY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f57d9d5b3f90c8ed;
	Sat, 05 Sep 2026 03:05:34 +0000
X-Mizu-Trace-ID: f57d9d5b3f90c8ed
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] memcg: move per-node objcg to the read-mostly fields
Date: Fri,  4 Sep 2026 20:05:17 -0700
Message-ID: <20260905030522.1887837-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260905030522.1887837-1-shakeel.butt@linux.dev>
References: <20260905030522.1887837-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mp7os5ax1jej9nwapj5noczkxk1mydja
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5CF8440004
X-Rspam-User: 
X-HE-Tag: 1788577536-733315
X-HE-Meta: U2FsdGVkX183j8/zF9E2qXC3CBEQ6yhBJmAhNN9UFOZqjJ8Nx+H1wT0n6Pa2zXPj2knaY34kYbal0+10mzuP5vbg1Os6roOzSz4C1E8pdDgITbpemzrblbSBD+WFyOIzWFSu7sPhxXAJcMY25XRdftIrsah12Jrgwehdn1JV9J5ejjB0mv++x2tbQ9IoVc7V1yuMlLQ//8hwQSmzOG/KRD9ZHEgBvfHfPjflbt1po6pEgb022qqXHTU8up5w/pOwBX+UWm+Rkp4cZV3Wj0r3ZP45ajpU/2/vvy0bNay5y1LrsoyoHCUaPxgg18OxWZhlw7uPs5jJZ+CjqrewFUnLLXmc59a1EjTOkcErtuHKWxT+iSR9SA9arp3H5Y+cAV8KrcRtXlOLCd2CU4LL7gZW9x6igXLqGa771y7NTNNkgvZifQyKiEeLxaNGMGQfMbu8AXzc4h3u8W9EbV+T3Ad+Mv5HoOJ2ELjJwU6oydJnMQAkmp+FK9hlCk1qn29xoO6CykOKxceLHVcdw7C7+bbMs3XnVznx8VOYA1Jdj+5GLvRiyKZ4i7HPUzfnGqmlOe9UjhXf8aePyscwEdEOYO1DriiG9EQwr6u4oblsyMxk+ouiKSIs1dDXr9GmWMeB4vWIm0DogyuBog9VTDvASHpXBbvIHtAhASWrFFHdGz0nTQ/OCwkHm/CTaCN/L7gv3FY3TR49yatDBoQhi+m1qt8W7x0yfxD5CU0PjXlfWwyonOEdiNdc1TF2GDBBQt4IbyC21kIWbSAfjDe8VfHDZuuZtDLjWaQbDP00vkS9HMj/qdk93+fIoqBHJdKiBU2HwfAC/VaBlMabIU0d2VadNLhWQ5h+N2GgA8TYjhD1Gpzk5w4ijwfVmqKEodQ+8QnySsDf3ok8rcijcd6jq7x5LW1d8Os2XpI4ho5g4/Hh7CvXHqocRemhYwNbFS8xh+1NfDcMgyxlMZjtagD7Q3etJx7
 eXQsbvvn
 T2uC39Q8QGc/BMWV0OQWfL0BTzAOi+CJKsJ9i5Gbbym3LFKWJspExDrgPnklhs+3WOqssXIYOyVIwTrvmfOUaxZzunOf7hQDUn/sSl6sjMH3cJdnt2ddVKG2HevKDb1AExQmLFjYAKiS7nptUMJY2rqpiXZ8HnXeJ4aBWYQVFMb0sHE6WPfFtWhZMdCLK4uhCc2IXo1tqdyN7CsJh4yEiVJB0Zyj+TKMXIFg0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

current_obj_cgroup() reads memcg->nodeinfo[nid]->objcg on every
accounted allocation. The field sits at the end of struct
mem_cgroup_per_node, on the same cache line as lru_zone_size[] and
iter. lru_zone_size[] is written on every LRU add and remove, and iter
is written on every reclaim iteration.

Move objcg next to the other read-mostly pointers at the start of the
struct.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f932b1ddda8c..ac575fcc5f1e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -94,6 +94,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
+	struct obj_cgroup __rcu		*objcg;
 
 	CACHELINE_PADDING(_pad1_);
 
@@ -104,11 +105,9 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
-	 * objcg is wiped out as a part of the objcg repaprenting process.
 	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of live of memcg.
+	 * objcg until the end of life of memcg.
 	 */
-	struct obj_cgroup __rcu	*objcg;
 	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
-- 
2.53.0-Meta



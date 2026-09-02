Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511E3C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EC8E6B0095; Wed,  2 Sep 2026 05:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FF26B0099; Wed,  2 Sep 2026 05:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6256B0095; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABA356B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0383A1C00D6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:02 +0000 (UTC)
X-FDA: 85168353606.27.D204B0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0876840005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gByp5JTp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788342661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGOWP3y6O1Ebdm1hNj6V1bMjE15uBtpSi1DLYN/sWL0=;
	b=3jmB6lBJlcqSsook/CsZQfXvCglKoi4hJxThFHY9EJp0Ms15Hm/o1d+yWTIfCzp2wHqDBx
	02Brr11IxLUq3kO8bknYrPqoJzPg952sDJRadtno5qk/1V9sMHgRV2FFcUNoVeQHGIV/Ja
	O4773XEYR3PJB+J17sWrgM/FtByiMqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788342661;
	b=pRxSvRl7CoJJTglEZHE5ve0YU/PeEABO7ARPlAjmxg4XttQ5ENZz+FK2fhKsRLYk6LlAUJ
	9SkJLnNKdjBs53KiSiFaES+DojtxamUIjmcvsLaBP4IbTjP1lLmudaeAWmSElO9BF0wQac
	YdSDiwPgAz+c5pj62FkfVoWs7KSrMLE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gByp5JTp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 070A843E40;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD5F4C2BCF7;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342659;
	bh=vtnU28IgD/9fgw3eMgLAM3NVwlFuTiAvZXPJld3OpeU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gByp5JTpDlVjfW5kz0pfLwTAfCAariuUpiKFZtmgw8E9BcB+R1A1jNKcU6+4HExwC
	 B77g6ObRdX5yrtpzLB1+ZtODjNoEHqpGsBPhRUBxBzx2UkOFWO4mPlER6TKcZvk1xa
	 y5OiBKOiayTOJ9fxnWVGGTOXbKYq5ae/BvZqIa3eYqjARogmmFjgagsS4RktK0BgCN
	 lrVbz/VpSqNy8rycuVlV6d26TDdDHlJqvGvf16a96ImNRzXPyI3ESutqL5/tnujd3D
	 ct0ahjylmIr3RuwZlRAXIH9HkClgmnNjItWy8xSnhAyz7y/I4e+9psM8itACE9J4fm
	 zXezbIcNEpwpQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A10C624D0;
	Wed,  2 Sep 2026 09:50:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 17:50:54 +0800
Subject: [PATCH v5 1/6] mm/memcontrol: move the lru_zone_size sanity check
 to the reader side
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-mglru-flags-cleanup-v5-1-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=4138;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=QI6bvhReGHb4fOvBljBjwiJV5Y8Bw1C5l29qeBm+tPA=;
 b=zq0mgu+IKjbAnDIaSkFgx6KtQr5EysUe2PZDWpe8eFGP89GdZJw9RhoxJ5PBrmbNBR5CRJC7N
 NNim/6E9hoaCYsBGaC7VgOuRQeEsD+geKaWaOzKjSEnNcKCREhoD5eE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0876840005
X-Stat-Signature: dh8ido1x134q5ysa4udxy9kaj4e9cxss
X-Rspam-User: 
X-HE-Tag: 1788342660-694417
X-HE-Meta: U2FsdGVkX19x7QQtwxIf8X4G7wPSaSX7mOHB6ArCxqFVvIlPjY0RYvytcITbT3F4tDDjxP95095lVXsd8smFH3nhn/Casee5gJWU9MG2FNPI0T5oyEWwhUHpJ9hmhVviXs1KD9st0hrjitTon47IpPLIuaBs28Q5lWlgAFu5EDAx9hxtNPBRBLo4PzP1BdEFDFceU7efWSNdLM+/KipMQ/7ASC5tP+k7JYJ2kalQ9+MyFBAQ/vchiLpbmtAO8VfL+Poswo+i+q34h7k1MaMzMl3j7tVb2YcYFvNklk6URBvHudYYpEuXc19lk+oYFYb8Rl8pr+akJdk1f3lDKxyI2mgnjwkODqgYdaGGn1E8FHP+8/tvsf6rFJbownhVcuwy4phwP0l+wqEJSMZVOoUGe7y1fERN9ytEHbSSadjY/mH25U8FRinOV7Kdd+lK2hFDuCUy+JQOdZ6pk1zie7yk4Ryx9XRMbH9l04//VEhl0ETv6OiuJMrQqBvIbeDf7QO7kyf7IKi3zAOSSqrD6KNp2nUrUw4UV0imKJrd9q4Rrt4mlnTOfBfDaPjPFd635Nbd1TZQCgaI/rcA/T03evnqBaLo3h1apEh5CpO3Pws1+OkC+Qm5pAL8dwNRl1OXjovg2gSRcJSlSDbSI5ivygyjCq6qwEV20So9RuxeQY3bgCHSFckGYn+vO2smyvSZwTo4w5cJUF362J0rNgr8vicolzRKVm8oqKUMcWkJBbetC4OwznoxnngovX+XPNpLCKpT8CF3xUtYaYmKWWiQWFk8hSBWrrbcsYfyhDWq0aeLbxFRmjYgKZ9UYY2eVDtlmlzKKFf94KUnZMXV4Nr7Txz2+j9VUMc//KIW5MzEw6Ltfk9iYMWULGGgxbCb8iMkFqZVb83TZKr5PFvhXrYdAs3WcHGHiscNUS9j7crMmFJFp8WOkxEaWVFS3Q0izK/ivsIef5FR5yvjr2logAUGhOf
 e79H5m+b
 eu4HDipR2SOfC5IqAQjWIaj2jnFb7nzIktk+qjpNgdAOrTjO34BxDjAPzegOf6gjPTSi1zqKFCJUEcwaSBJr5gQh4K7171gBKcv2HSeC3bV8b2C4qeamRkuOZzgLYN1oRBHTRkg+Etd/U7wT3zCl8W3aPfUJqhGyyTD50E0z2dH7OhaGqJnEz5/8vj+K/MZ63yl2Bx0KtQQepjeyqMY2amz2CLgi7xUsyvzyTMAZ4wWFv8hqTNOwFOG9NaCynf8goBzR9dYG2n7ZnLsA3BKfYVUcbXE56wQ8ZCHv1wKtkewVpyxBwvPUvhN2s4kDfoVmE1S8TC/IdsW9yQz8HTIY505FLMuAACyCWUNG3gWy8VjrRWN3fVU/h1LqyUe2XEWUjOaYCfEVcb6pj+TRDyJULGwoXxkPzWYl3zK8BGdKDOTk2XtBxNlHL5W/iwiNAwm0qsDXOnNuZ8aUj6mc8t9CCxvj4X3Mn2M4Tz4NDdm3Im9kKLFlVPeontMXK2pmdz784lvZkvcvBehSZINs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of using an unsigned long and checking the counter value at
the updater side, turn the counter into a signed long and check at the
reader side. This reduces overhead and simplifies the code.

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
added a sanity check for memcg counter underflow: lru_zone_size is
unsigned, so an underflow wraps it around and returns an enormously
large number, then the memcg shrinker loops almost forever as the
calculated number of folios to shrink is huge. It also checked if a
zero value matches the empty LRU list, so the positive and negative
deltas had to be handled separately. However that emptiness check was
already removed by commit b4536f0c829c ("mm, memcg: fix the active list
aging for lowmem requests when memcg is enabled"), so handling the
deltas separately is no longer needed.

The remaining update-side check is costly and cannot really catch the
leak it is after anyway. It runs on every LRU folio, and if a folio was
removed without updating the counter while other folios remain on the
LRU, the WARN only triggers much later, from a likely innocent
callsite. While readers are much rarer than writers, only the reclaim
and reparenting paths read it, once per batch.

Checking at the reader side instead leaves the update path a plain
addition, and puts the warning where the value is actually consumed.

Note this changes the behavior on underflow: the correction is removed
and a negative value is kept. A massive leak of the LRU size counter
would indicate that something else has gone very wrong, and one should
fix that leaking site instead. Besides, the original behavior might
cause false positives, or make things worse if the accounting happens
after the actual insertion: the value is not leaked, just delayed, so
force-fixing it would cause a bigger problem. The warning now only kicks
in when a consumer actually uses it, in which case the reader gets zero.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..86780ef65eaf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -902,10 +902,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..0a65ab8df27a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
-	unsigned long *lru_size;
-	long size;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	lru_size = &mz->lru_zone_size[zid][lru];
-
-	if (nr_pages < 0)
-		*lru_size += nr_pages;
-
-	size = *lru_size;
-	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %ld): lru_size %ld\n",
-		__func__, lruvec, lru, nr_pages, size)) {
-		VM_BUG_ON(1);
-		*lru_size = 0;
-	}
-
-	if (nr_pages > 0)
-		*lru_size += nr_pages;
+	mz->lru_zone_size[zid][lru] += nr_pages;
 }
 
 /**

-- 
2.55.0




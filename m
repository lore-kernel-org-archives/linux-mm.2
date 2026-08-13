Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA77C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97AC6B0248; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC6E6B024A; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CF06B024C; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 773F46B024B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:52:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D28A7C054D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:52:15 +0000 (UTC)
X-FDA: 85095629430.04.3493AEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D35B11C0005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fF3ITC1F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611133;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMa7HzIyBzNDGytCD5MNEmVwgRkTJmlXz+94c5jzgVg=;
	b=s3v0/y7Q5CeYtbl9YYFYN7be14avMX2JQafW30X9Paz0TLT8Gg+zBKuggeNzegnet6o1K1
	ONqXubd8A+IYxfWDvwlbwK9FNU7g+eWl+TkDdiddWs08jYnQwJ43ruFKbJ9QQajaa0c0ev
	VWpecMkBW46ySc756znWCZc+lhMjuSc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fF3ITC1F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611133;
	b=0uPvQKHZRlXKfTC+mu4VeErLvK95rvyzFBxaa69PXLItW51EU3aiNpqrGtGcwDEpLEAhRS
	xTktZGA8HEOg1iUHMt0oIa3BSzD1yyPSNkdfEm4+/0smY1rro/JMPXpBM4ActdQmhS0Jar
	zFRRSNrydAebmV2k13RAyCCrt3QdMlM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00DCA43F3D;
	Thu, 13 Aug 2026 08:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2653C2BD04;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786611132;
	bh=meapVXEGFdDb6NF7sii95w8iasCv07pp1/gAqS5rawg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fF3ITC1FGfkSq+//ZPnwjAjYDzwqhnID02bRoPebzrOkwCsZkcIoaLMNULErC4KM/
	 J4HjoSjFkzSgDho8I3gN+xfJGQtvFyq/UuIwnHVUeXUJLroRG0jg0cZV9gKBw+1NmM
	 LH59MDg4B8EiF1uFv4ZCuqOyP5a6IVByqZO59CIinw1Ti9wy46GK5YWHmcrKO0Rzun
	 xDW/71H7UFy8nFxLvVDPhn3txw2pPMdlOBCIbHMzLpHqgkK7oELkFSDPJneKoOLB85
	 1v1WCRmMPEHpAyZv9pikwgrcFqx07I6Ikzefyg4+wrVawxS8Egz8SDX4dGTnEgUEoH
	 4K6ab0qMorjpQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F93C5DF67;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 16:52:06 +0800
Subject: [PATCH RFC 5/5] memcg: filter out reparented memcgs got using
 memcgid
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-memcgid-objcg-v1-5-83d21c685b77@tencent.com>
References: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
In-Reply-To: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bfguo@icloud.com>, 
 Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786611130; l=2805;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=zY1JXeipRRE4x+8HShYlKEllHTJG9Rn8M3UwjRUwSJk=;
 b=CusELUTT7HqgDWh2KGQvd8fGGqtxEXggEBLMydLTG5KzIJxwbuc5HVMPhaTVT/r1MjFsRGMGg
 Wp/8xlAWmeCC0QRq+pJq/R8DkaLIDm1Gd2BHzegRT2mnbwkdEmg/i4o
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Stat-Signature: d1sjm9te4x8t3z1zb1odqjgtzshh1pi8
X-Rspamd-Queue-Id: D35B11C0005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786611133-867132
X-HE-Meta: U2FsdGVkX190phsiCqhzxAFQOq+yucDNxKk6w5i8VBgt5Sq2zykKjzvkHNMVxSXEmXpoQz2qwKue9aNcbwgWUyZSmcUhkKh6yrfU52ZJ8rV0OqzWKBqFjJsBCM7gt7cncZbbv8KyiLcApWg0Hd4KbWsnaznnXHCRd2h/4etdQR5TFeVRXbU9v59xBdsXOryUZ6NgZiwCvlASrCcv8fVxhnLV7MOTwWgb9mJvXW9LRzB+4Gth+1Xc+CwmaXmR8pkVn840IChZ5VBxPftogqOYN+wNDy5TEmbi2VPAIWj9W9c2ZegkGkKg2+SjzksX/UfQd6324X+dVfeC4xZiQnCpy7sf9mx4rolb/OdyZmLn4hc3YnlwFqFhk22nIBd1GzwN0HtmqGjGETqUSU7Yhd9sNTOFwVFIc2af/b6mxI/MWE5onVDiGEEGqvTYBggfVJJpysMueo5agPIvy31v/JedM1E2DD7PYIatMGR86jmXi5bzM8ZTCHzkrOGkvcbbgA3KZBlaZQqJGiXVxihtRPySQH8qS01gnVp1/fzORsPz4vgOzyd/S7TPtsrabZ8Ae90OLa+M3FgMYcTlRg+noKgx1IVJ7wWeBSJzgLd/iZZ1ry1LC1nO2wCKPGd9jh3YHwEOWqsfhiP19rBFx4TZcQgbnzceD8gVnSAMaFh6+pL4kkxJR6DtdAdV2Dr2Aad7F/YkzPhfVdXC5SsnEhOq8gSE4rvmdfbkZGY05dHoHf1HSuu28xabUldJpITDhL0+KashmcNZiGttRDkk7Vupa1OfRqpGNDNzTwNqPiBcw8H/0UPA5Q+fAjjDPZhhayAO8vJSDbBeeB52uovQEnlz/U7KDGUPp3YlNWeH74tFiIhq1r9qJI2QKsQ1Rdw6XUC7cyFgCcg9j+OivWMF2Tf0csq6WtlVIaWleOHw7Senj6UUAK/vs3LqjodCAF+rAo4Q7jlCCuf0xK0NXyyvtIEKrVZ
 cOyhjcI2
 AhDTTyBr9+MSgxdw4/FszDxCiHQ9EvyV/yVmI80SkDesaecNwqbYm6bi7tkNdc/M8XDm4gLrM4TmNkeSHvdR4bs7Eta6vOvjwqo9I86KygEFLJ89n5e6FbHpVSYsW1BJMJ/zOFoyEocY5f3XJECPys8ZR67/j3JoRqEVcoLP17gr649Z/76jmpNFtgxmP6gWS1V03ESMDcPMbDcClxn1394VMq7CSp41F65ieKFe8ZJBGxT0YOxk+F2QXFLB99s5AeOnnouRi7um/M7bOH091pUFygXj+2ixnJ+4WNo/yT/6xZuPkwMsOj6hTdP5xRUAebDI3uoGje8QvuQNkC7890qZlQ33YMjFrYob7Xb0SVZoKuv6oGqJ9V7i7AEokME3pvil3XbeLmJwgsv3Xb3YoXeGDhMWLQkaFLU6HoqMdeFqbfUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

mem_cgroup_from_private_id() looks up the objcg that owns the id and
returns the objcg's current memcg.  After reparenting, that memcg can
differ from the one the id originally belonged to.

Callers such as the list lru and workingset refault code expect to get
back exactly the memcg referred to by the memcgid, so check that the
returned memcg still owns the id and return NULL otherwise, letting
the callers skip the entry.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/list_lru.c   | 2 +-
 mm/memcontrol.c | 9 ++++++++-
 mm/workingset.c | 6 +++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..bc956267f6835 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -428,7 +428,7 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
 		xa_for_each(&lru->xa, index, mlru) {
 			rcu_read_lock();
 			memcg = mem_cgroup_from_private_id(index);
-			if (!mem_cgroup_tryget(memcg)) {
+			if (!memcg || !mem_cgroup_tryget(memcg)) {
 				rcu_read_unlock();
 				continue;
 			}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fdf2e0d1f17e5..e7555eca77019 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3999,17 +3999,24 @@ void mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
  * @id: the memcg id to look up
  *
  * Caller must hold rcu_read_lock().
+ *
+ * @return: the memcg, or NULL if the memcg is already reparented.
  */
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 {
 	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	objcg = xa_load(&mem_cgroup_private_ids, id);
 	if (!objcg)
 		return NULL;
 
-	return obj_cgroup_memcg(objcg);
+	memcg = obj_cgroup_memcg(objcg);
+	if (mem_cgroup_private_id(memcg) != id)
+		return NULL;
+
+	return memcg;
 }
 
 /**
diff --git a/mm/workingset.c b/mm/workingset.c
index f351798e723ac..b6e22536a5240 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -283,6 +283,10 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 	memcg = mem_cgroup_from_private_id(memcg_id);
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
+	/* reparented memcg loses its max_seq */
+	if (!memcg)
+		return false;
+
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
 	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
 
@@ -470,7 +474,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_private_id(memcgid);
-	if (!mem_cgroup_tryget(eviction_memcg))
+	if (!eviction_memcg || !mem_cgroup_tryget(eviction_memcg))
 		eviction_memcg = NULL;
 	rcu_read_unlock();
 

-- 
2.43.7




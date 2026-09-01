Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9CC5C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6433B6B00E9; Tue,  1 Sep 2026 04:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A496B00EA; Tue,  1 Sep 2026 04:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421256B00EF; Tue,  1 Sep 2026 04:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ADA46B00E9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:58:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 985E0402B9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:22 +0000 (UTC)
X-FDA: 85164592044.19.F8A3B33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9DD9780005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNWnrYfv;
	spf=pass (imf02.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253100;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reT41DI9L58vB5tW43FpDTDkgqLuJHUon3Tn4iHb51o=;
	b=BB6bVoZmDBhLPai+2/DXOv45McHXjTC8qqTYor9BVJ/jQU73NWXR0rdxo+OoN/0QKmxb12
	YaFwatvOCIWKUvTMU8klNXWVBlWthgPpekzVKRJaZ8xG86UPo4JNjb0Y/COf5v6PL5ALiW
	wL4nxGDwDkzBgCtV4gK+4UeB3+APFlc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNWnrYfv;
	spf=pass (imf02.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253100;
	b=w/dkJUtCau1MDAbf813+ooegBZeHal4wjJi/1eB2IwfFInc5HYnLoUVzKm7mP1Co8CXXNv
	99Bo2PaLQQQoUCSYGlP4Jllv5Z69MjNyA4PbZzgJNZFUL/nYM0RBLremDLkOOZ7x9sjbGA
	DbgSuUOTvuHZY+GzCjfD7HBHoHfsVF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51A45419F3;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34C27C2BCF5;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253097;
	bh=RhjZ8Agl3sbbRZCe+duMO20xLmPNeawkGM6PaCP7BIU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eNWnrYfvyw2Nw5Ae/WmE6KRgB71Jmk+QUTfqxG0E0jixwesnQjD286+bgs/Nvdlfj
	 JQeNVGKl8C5wwutpJCWWcf9U+ZCTtimqNGsIYzcE8SYk056VbTH1qjVxo5vHkFsyd0
	 Cg0TsSSs1sdFrqf7Yh9/2RrnyTCGy9IvN8AS7pLTNs0YSRZ/x85Ry9pLPZpFxbsIr4
	 r8THGowmgpumSPzeFm7QROsdrBgAeWPQRHmkDGcZIWlocVEdLgSZjif6F4QPw8v6hA
	 5NQ+VShwIhVaApCOCBvMQ6I33biHNj7UkXxpCtbAGPtMs4mJb05aKvzXC/cEXrbgMx
	 g9xg7zfjtkRBA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DA7C624CF;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:05 +0800
Subject: [PATCH RFC v2 6/6] mm/memcg: filter out reparented memcgs got from
 memcgid
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=2534;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=lyLjAgWvu8z4Mx3sqViPTPHcL3MXNW/gr5r9+kucGwg=;
 b=5xj+J76UVmxnZQVNFQ+zRSPDR6UAzTih6ycgAZjO5VvTHyXssOM33/ei2NDEyHihaq21+da96
 MKCaUTHN9j0A6KLo/1zLukpvbxwxLE1BM6WpuN+T9oeiSyyRVaMXTp2
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Stat-Signature: kpucjmuwcuzichm1t1fx8rbzjxnnuc5j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DD9780005
X-Rspam-User: 
X-HE-Tag: 1788253100-65027
X-HE-Meta: U2FsdGVkX1+YEyQH+3JQ/kB6QcOFEAkAF5crOAgbqI2yC+CJNHE0+xAZ1TfVZtR7peThly5XrfnQabGd2e6Cy3wMwt88iN6s7YHaM+ZjSz/Ug9L7jSAUiLBVGU5k2E4ktCC3DjTRfaZZpc25sDQTiCV8EZP9OjRcPZ9eIcLhx4J7KIh4utc+IQZqvrgP0ZTkEP11emUBxReWp89x8Fj5jE4hKXbrmVoXMbYL35cM2oRHVPiUrbNZet9LBUHaGSeBygTrxS4ZP+GGJ7QXsVUsh+St+DIzonUnLgny7PvWVq+2axYOnC6YUY+8x3BC+HmJ8i7SbElEtddgGAFgZt1SO/DjJxMaBli38eiOso05nuMwwt+tn8fcCQnzNAgS+wzu/DNSWLZSRa534zRPo+TDSju2qITFWsBrbATk13jRmzXYkXdkTXUf/BmQ5/LhjsYoL5wlNbz6YnQmCznJp7ZNJz2KIn7QOejIN6bnybTGZmYKvhuN4hK0UwrbOv+/01DsBt6kDZH8xj/uppPTuAg4SrieNLESxon73BCvI4KOL7FgeyjfyPRTmDcH3g+GiV9M6LyquFnyVir8kEyD9vO/lLHysiO4hdIhURRpAsyKerNGKCtanrhMqzHb+BAM+iCBSSRpQf6qx4F54eM2vEk37NnwHIu8QqibbCJzpEgWLwSA6PH/2oaH/088sCCCESOpUaRZfQFhtf942RShyx7g0g+5B0CTMpx+4Khk0zwi8bvQjxYWVwVRSriWmUZOPPEoKmQRFItaTW0hagc+8/491/xBb+QK6fWkCvqdRLUUD3zd8skprYgBdOAcjdYFovQsIOcfI/0Ugw181Vd2xgUBuVNidjDN3DeXdrDUod4kQDeAP+aArQBooDbxfKEihLRhi3TE8cvG0p9yhKrRP2SnI0peNUN8zLvQIhY4p2ivqNr92AmfqqVhbFbIYxF6/rOBjMtWvtjjeS0oH/6qxeW
 LN9MJhJ6
 3NojKcjP2MswXMFHlC1qCwTQ99JB+5PAgNMpr1jKSEekNoO3kdt+1UBK87blJsnSoXXOFffM3oa6fmCXVNlCaoJZTtKW2/6gLWCCeoziOqnhPsswlNNLrAbi0zgVrrrWnIjOxbKP5Jxtk9cD1DNxhvX7mAUih+DIGs5D7W4uB98C6Bd8/FqDUfAx+G1AH6oSSPAAv6J7aOippKIYDm0PmEPv/7hipM4WQNgDyYNFeCBRCBFAlTgACRwHbnA3Cgc5z6NFtqTWeKAX3zN0/V5DrHgHLWuY/s+arWBEaeSC/fYrRaUAlrx4EadjMHP+JBkLa/eMJeSaDAj6YpzbNKs27taFs0eTEIrX0aflVN2eUNP9q6X6UAvEk5ScdBFBhxSigrjRfWqFQXjPW458Mauhj3HxbmCwEYpFsAXJHb/x2D3KgF6Y=
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
returned memcg still owns the id and return NULL otherwise. In this
case, make list_lru just skip and workingset tests use the root (as the
comments said in workingset.c:460).

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/list_lru.c   | 2 +-
 mm/memcontrol.c | 9 ++++++++-
 mm/workingset.c | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

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
index 38d2b00657a7a..84dcab3acb8a2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4112,17 +4112,24 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
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
 
 struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae5..4e9b7b163c01e 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -470,7 +470,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_private_id(memcgid);
-	if (!mem_cgroup_tryget(eviction_memcg))
+	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
 		eviction_memcg = NULL;
 	rcu_read_unlock();
 

-- 
2.43.7




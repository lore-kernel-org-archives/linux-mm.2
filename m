Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD2FFD29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7D76B00C3; Wed, 14 Jan 2026 06:36:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482236B00C5; Wed, 14 Jan 2026 06:36:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B206B00C6; Wed, 14 Jan 2026 06:36:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 286CE6B00C3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:36:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAF3DB9A3A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:19 +0000 (UTC)
X-FDA: 84330366078.29.91B9FC5
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 485BFA0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q96h2Xw2;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCn71o4CGVG6ZCimcBHoYvDX6iNx84ttSjck4drbD9c=;
	b=8i32eDzDsMQJP22MCswPVc9M4LO3Hh41F0EFSvzYLxXOWNjbxW28c0wOEdC7ok7kI/M8PD
	Ri5H3MI5K7Le2jGesYPRXwDmtCCHx+UZaEp0v5y57z2mPjuyeirmB3wQc7Zhl2equbzFej
	cZ4ADnGbLfsvfImglRNaI4J1Qp0pVyY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q96h2Xw2;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390578; a=rsa-sha256;
	cv=none;
	b=aSQUsE28YLWWmHODPc4FuiZIkXnHNmve69Io3yI5flnsKhIKsfm6TMXo+cCbwmFQBrMWi2
	uAYXAzKvxRotXBdEqC9yDlB+x+IEteI+F24clsD7IWaW06emokZz/RXcXpBtGkM0DEvG98
	6Rselti3F2iqIfx8cld86wGbZKEvlfk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rCn71o4CGVG6ZCimcBHoYvDX6iNx84ttSjck4drbD9c=;
	b=Q96h2Xw2FW89SLH/7JvVfXdzJRpn9+6lVcUlq55C3OXjGlnp637HPE+22QxBSQ77rM7yha
	3Sw67e034q/9edHVNRxG3QNikHhUw4iSAMurkyZnCcIiTfUHRWAE1njcGzgltkUpE6TFfq
	cGAVi5cmgo6AsI55+TYXghSBv9ZzWr8=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 27/30] mm: memcontrol: refactor memcg_reparent_objcgs()
Date: Wed, 14 Jan 2026 19:32:54 +0800
Message-ID: <843e9537bf6b99cc7f19744a6f53b92338c96bfe.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: h49w5dh5kuzc4rn4shmf7frxu65ayf8t
X-Rspam-User: 
X-Rspamd-Queue-Id: 485BFA0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768390578-59120
X-HE-Meta: U2FsdGVkX18IfjsXFBs8+YS5R5mUv3JoEpF6F38YEXWKlzB4Tyu1H9KH49WBe/HKxsTloon7YnEnX14xcijhNbscK0rkNKL07Y0yBzWU4Vz1fVNw3GQLRnzEkUMspw6vzou/UrD3sHAbdsZX828ZmTM+GZRH3MZAXBDodP1wGonibzf46w5zsqe7vb51qzaP0omTBUwdqcveDCNnR7ip9KUy3cHmZMuV1KQxBPCCk5Kkt2lTi+A1rh5jCqkAWtFyOMPXB3r0APFgHsk1EhiVP5VH4hpTR/VwmH8J8ggHSe4uEIypWgow9+y/c+lGaoq24AK0XbEnN81DokE6BSHnMubNW4dVkfu0Ppmi4xQpEbxT4LGj3XdPvkvVEaNvHIXOsIzFIlnv3/BlR21+JcSpBEtDa9D8zfUNM2TTOvlkyF3aHQ3JtvLER3WkSzPw+OviF2QEyMXKEJsUrYMUodWAk/XPYWE6Ri3a7+yZGKGiy0fqOXc6H6IMRWVEy8LcaMAuixWej2of5B7nbkOi3FLXLB2pqI6qzJKT1d6GPpahSprD9YVeN6QYGY2SBgq/Irj5u0rnaRJb6roTA5NFJpxGAd/yu/PpV1cxv4GErW9zI4PX2U3jyXYwT66yluPtHaSRUtEwc1cDuyjc0YyIEdcZ5VSp4ZCTlOJz0m0zWp+3Snjy/l35Hng8I/qCyjWHikGTz5vLWD0kl9EYejkpP1ueaftfJIx1bquEyrbD33CbLl/+9dIcwtl9IR+YoGLF7KZNV86wm3d/NLH74ACr5JMAXshJUSv8Yy9Q9ppd+ynT5HM4gqDcB5Yxuu/V8VNNL6Tz3iqJ6yKjAnyDPEShn3WoFBU3It3D0ofXkGDoTLFvdz9O3Nd4oqUVQhJqdutKxUrj422e6BvVfzdWrtwQJ1zXL9sSmtPhYNf8qlQNnlmZSLZ5fnrAcgx80qSN+sE7RWjQ5wU/nfoOY7Dq2HcOhl4
 PMuRp5J8
 q/D3DuUTiWlubsFkE+hN8QjqRZ072OA1iNGk7Zu2+gJXy52Lbfv3G/v/D/F9Kqn1Qo/E1hdKZgMC/7R8L+P+CNpWDq6p2g4ll/N02aORMfo2EbHGqmBv4GyXzFHEBOOKnC/ZAtvot3rrQ17ty3Xkl+fljof72DKSc7e3wIvi82eTV2naxJ0h2iHS00rF4YGWctsSe7t0zQXpAJsy/UxEytz4xngeCEOrNrTXGgqKLSUHqDyismMeUAtDLX3GxPVW3T5nkBbHkTwUVuVOQL3UeBjcbSGgxTxYuAvnYziZmTd8CAVOU2fgesIZdF59zTutuO5+wsWAFu0+DDKI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
LRU folios here.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a1573600d4188..70583394f421f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -208,15 +208,12 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memcg,
+							 struct mem_cgroup *parent)
 {
 	struct obj_cgroup *objcg, *iter;
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
-
-	spin_lock_irq(&objcg_lock);
-
 	/* 1) Ready to reparent active objcg. */
 	list_add(&objcg->list, &memcg->objcg_list);
 	/* 2) Reparent active objcg and already reparented objcgs to parent. */
@@ -225,7 +222,29 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 	/* 3) Move already reparented objcgs to the parent's list */
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
+	return objcg;
+}
+
+static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	spin_lock_irq(&objcg_lock);
+}
+
+static inline void reparent_unlocks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	spin_unlock_irq(&objcg_lock);
+}
+
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+{
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+
+	reparent_locks(memcg, parent);
+
+	objcg = __memcg_reparent_objcgs(memcg, parent);
+
+	reparent_unlocks(memcg, parent);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
-- 
2.20.1



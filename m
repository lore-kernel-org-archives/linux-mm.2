Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93DE0F30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1C06B00B1; Thu,  5 Mar 2026 06:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C436B00B3; Thu,  5 Mar 2026 06:56:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBDB36B00B4; Thu,  5 Mar 2026 06:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBDC26B00B1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:56:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8EBB1A0795
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:57 +0000 (UTC)
X-FDA: 84511858074.30.EE35145
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3227AA000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fe+nMrSJ;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbG23+zJ5fPDETZsA4JYiiScdZSpnAwzCU/omjW9+7Y=;
	b=tP3wTarbeEmfTP4nE0VEbnUEjEbSB14aE+BKh9s6QdH0ZlzMQFLS2fHAV7xliPw0MnjZIZ
	JOwps22d6NxlnGjc57Nr+4ceT3RClggLiDHbo/7dnwUETbgftu6C4J5PWeySyWYKLOJjGM
	Jaqmi+0gj+MVX3mx6Pp5RlBO3ZoxpCg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711816; a=rsa-sha256;
	cv=none;
	b=6AxJ7cxh6uBHvjfNN73GSC3Ixr40yCkn/Uuunzndd5n5pwDtbWG7kIt/9bCJ9iKse5C8NO
	xDnLW5Ns3fNJ1K/OamhG5rSpzBeioeyMsJh0dwxfY3/XG9JX26YzSlP+nnIDrDZ+foiLdU
	9cvSkCroApDl0jwkBp3A5pekT05U/7w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fe+nMrSJ;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbG23+zJ5fPDETZsA4JYiiScdZSpnAwzCU/omjW9+7Y=;
	b=fe+nMrSJbiyNEjT8QnfP2jiU7zSCtJUFDhUkZ6xW8MCf6wGdRSGgSko4Kwhc4zPQBedWa5
	DmrzF7ubIzkhASX91nLHrdY9b0eWVYN48Ccc0XZJ8LXDN4O7BgEnue4o3MoZ2JmNDreaDv
	bQfDWzg57Ggq6hClfYxiaK4sGUfw26M=
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
Subject: [PATCH v6 16/33] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
Date: Thu,  5 Mar 2026 19:52:34 +0800
Message-ID: <f37e8ae2d84ddc690813d834cd75735d52d1bc78.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3227AA000B
X-Stat-Signature: gighfhax4se6kma8pztrj9qu61w3ukn8
X-Rspam-User: 
X-HE-Tag: 1772711815-297178
X-HE-Meta: U2FsdGVkX19I86lqxlC/AMbisGfH+I7xk6+L1JczOEf9yDBoLc19cqlp5lw7b0SgyLAJgAszyI2xokKs02K7KpfTuy+2aH4LkU1TYvsnh9+mOjGtIQuqxOHZtvkLino5yRtmorOT6wb9d9UOwU/AzuGsTNYtzAW8A8iLvyTV8SpPiOMtMsg+K0YE5kGZSIkqqoI9niNY1RhaKkdzsdQ4qcaQKeZr1MM4lTqw6KGtEJMLUuEOj+vWV8MALw7OejefcsC0TpPqw/Q+/AP3+CRfWBRlOaRWgnhv9E8FFsDh8I5yHWT/LZI3Vjlt0fNTNSZFs7mLwlm9EaDVN0MkMUiDb7TgD5ABYCVwYhrdFs1sTjrSE4lqhWETRP7wnq30NghdukY3fcfaEh7T6SL7i4ErcM2t5+LkFqRbLXXdIYz+XKIr4DK9TFMoETyK+ENJOEau3hj8F8hg4a5XI5Q+Wl9Eayzo/DYRgZ6erTexr/8bSFw7eWKt2Kj4KzL3XLyZ7OZPNX05uWECqDQstFOZ3v34YWJ92uJEBwrPx6m4OdcYM4J2M/OddUxPeZQSGpheVkjCvnRyXAKPsNsthoqe53spRBpq3kHmITxbxdBZkjtASO+l3jNcjnf3EF8QwWHgQlZ90+F35ysXDmn9SypT6oQIxoF55bvxPhVCY09+OPM2v0alLIi92Zx+LL8j4ClTZRd9dsQVB70MLQIxVJyH3ppHUYgMJ5bdMIf9Nvu+Jtn7mX8FX7C3d/BzX8WRHvGOER++WG+6obmDOCigcJotuwzQ2t4zngs79D8MwvJAPxzZ4Wy819ETCAU/G+00UXjIv45OLB/Mn3heD5kSl+b6gQL5JpDkaQNH5IfyOhqJNOmhy1JqSazeURDXoy1GIGbiJgjWejhvTJ5umCRw6UTQsBJHxd5T7vb5m5f9
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
against the release of the memory cgroup in lru_gen_eviction().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 5e8b6e62a6175..6971aa163e466 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -244,12 +244,15 @@ static void *lru_gen_eviction(struct folio *folio)
 	int refs = folio_lru_refs(folio);
 	bool workingset = folio_test_workingset(folio);
 	int tier = lru_tier_from_refs(refs, workingset);
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	unsigned short memcg_id;
 
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
 		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
 
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
@@ -257,8 +260,10 @@ static void *lru_gen_eviction(struct folio *folio)
 
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
+	memcg_id = mem_cgroup_private_id(memcg);
+	rcu_read_unlock();
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset, type);
+	return pack_shadow(memcg_id, pgdat, token, workingset, type);
 }
 
 /*
-- 
2.20.1



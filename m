Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C87BEFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8C06B00AC; Wed, 25 Feb 2026 02:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2BB6B00AD; Wed, 25 Feb 2026 02:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC366B00AE; Wed, 25 Feb 2026 02:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC60D6B00AC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:54:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 758F41A03ED
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:09 +0000 (UTC)
X-FDA: 84482215818.12.3A918EC
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id ACDE42000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:54:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BMUSbSUB;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006047; a=rsa-sha256;
	cv=none;
	b=4O5OzJVs2f1amMtxJIsLEJvrmCMUPO+MOv7St5RknReExv41VbFkDBSTIa+yV3G/TML3cP
	ajppke7hzE8xIKNyW2GgSJnT5ayRS0BZ3nSd9SS8CLHRyATjYSs4RzCavU7iX2vvMvR8Y3
	f/JtDl3CSyDy2gDYIPQOI2+EYykRO2c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BMUSbSUB;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbG23+zJ5fPDETZsA4JYiiScdZSpnAwzCU/omjW9+7Y=;
	b=bFgG9nTwSDmUFKKBBSdEPCghvlkyNlQ28xTKFs86Bre8YY3LMwAFFbBEBH4EgO2sdxQGKm
	yEUOw7oe0YhGQDERvGJ9paLLhykdtoC86SLE46zOf4Ziy9AvYFnlygqMOXYRMJEz5kab1H
	5Tc5XeOtjKW5BJCfbnb9TDGULE9Gkxg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbG23+zJ5fPDETZsA4JYiiScdZSpnAwzCU/omjW9+7Y=;
	b=BMUSbSUB9b0CUfjuJnGDI/tuLRw6TRcPbpRrczT3aPDD23ATtsAMtWmpYfqNGVaUEeW2UU
	cwQM30u+/x52CKIC/AfFvG8864Aefndlz0CohgHCbBn2zaNN0YUa5uarz2XuosEkn/GP8o
	UUDHi4ztvEyVObtAm5KBYOel08RHm+8=
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
Subject: [PATCH v5 16/32] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
Date: Wed, 25 Feb 2026 15:52:59 +0800
Message-ID: <f37e8ae2d84ddc690813d834cd75735d52d1bc78.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ACDE42000D
X-Stat-Signature: hwmxnisp818c51s34t1roaihffs4jh73
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772006047-277513
X-HE-Meta: U2FsdGVkX18cjDazu1ivxScE2ODl7QWTYpVpgjx0N0LJIFcuqK5DpQiGQvwAm1ca3UU8aCIPmvpDpLWVbT1lliJ3FNd0DNZD9YslfbeffOYZrEv5UBDVznzj/m588ihizVfINDHRQcLIyYQkb2CodMB0jbXCNRl2zwNSNRlvzwSNMXvBPXa9L5KB4IUm5c/Y1YBlEO597PqOO6bK1Yi3gQ1Rd5iBDA1bPLi5PnP/ltzXoLpA8EiSRBmV/WkJNo16fCqC4dsTHLc3KfB6fwsRwQMKXWLkjjzkUAIYmQ4dr4yDw9tsvMWkQezUWBM91JTxYkyV92LmjMbvQbdYAhERSQV8Zowox082yRqxME32k5XiMjJViOv84UuPpi7J9SGOu2g/Z/gFRrhJxoO5o9volnoCPFYi/tpyhsfrDX0sTva9qDyzEgKXS4Ppg6H1yT0AjuebbYeUE3WAtjTa6iiqMWPrxoYbmoW9DQnN4Iby1ZM3/T6XNdna4ZOjPuf0orgdnGULUvwgjxmWNUiCN798n11Sgf8ee0J0c+1mF39vQDKigMQQroTJDMZde1u28KQIyGCI0GdwVGIl99RfTtm9jockFQb+U96LYuNSmnCNihLAW17pb00xk5xNlkyXzLYOgEEEn4ZDSO5zmDFzYpLjRZZzJyqD1xSwwYxCaENV3P+LO3ddHEIrfmWiMYzcXIxz0A69U4cQcANDjQYW6TSkwJNR9+fNyKy8azNAycQe5CGRMn8Dyl5oJZQYSsXX2nXMQXs+74jZtSbl4RfaYXuef88LuCIe/yf3ofMfdAoZz/NeCEw7ZVPTD+SRETirOZhrre//HI+1bZjLcoklqyEyowsCs9CTLMiG1orqbK70pDZsC32s5UuvFMNJFez2mNHVJAJW6TefTbVufi4Yz5IkHAWHruUf9cnC2/rSOGV3FBwC6Zc0RykIVC3vzmDAZD3FyXQf4LE00G+AMvtS5eL
 m0Rl9ann
 LKutmKAAnY/oYWeI53d4mTJHKz+lIx3+qqU42xAYXB2VUrq/b8HcDnvNW20qBFG7xolJAOx0rixGdwQzTyXrZMwfcdEE1znwqhpurg60kO21vl65ofJK6Owi8UaIiOz3GW/oLLptoPcoy5QqDhB9/YdCpQYv//yZqxuiL/RBZILlASYv8d85nwnHTmQ4NouAZFYu36SuQczTydllw63IRYlGvL+kIIa1WEfUdTM7AswcRj3YPD9H2ur6Yv5lI5TaSIlZWlseIYoSOpNJNLBfwogJqUsh4Bj2TtBW8yd/EJaO6e5WUhSVtTzhA1l280fyxw1P5
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



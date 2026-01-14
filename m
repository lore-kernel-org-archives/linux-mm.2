Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58700D29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE896B00AB; Wed, 14 Jan 2026 06:34:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B629F6B00AD; Wed, 14 Jan 2026 06:34:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC456B00AE; Wed, 14 Jan 2026 06:34:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95F8E6B00AB
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:34:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4990014046D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:38 +0000 (UTC)
X-FDA: 84330361836.20.DFED86A
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf10.hostedemail.com (Postfix) with ESMTP id 849F2C000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RZa0bHSM;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rymsx9n8FiJjOLGrnYBXKfgUUaI2hrPCz4qLX634Ge8=;
	b=aTz6A0rEdg5KKYZHKn13Owc+IgfpYQEAkMjEmSupZrApg4kj5Nr1EwGgbwLFWsxJibKdqf
	ZY84b6g/OCpPFa3/LhIR5d39goIEyXTU0DS7c8ycL2oGnLNzCxxbxRmasu3zpTyb8n5gGc
	yO0BeO8vPafmzKheRwK83PAdq1Vmcs4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RZa0bHSM;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390476; a=rsa-sha256;
	cv=none;
	b=RFyJ58MR0aRLmOkIqPQH09/ewM36aPeTRQgo15opQ8FIfK6KwqJQQk3vc8+tUSIJd3VyPB
	tHFGXkwgJGZ2XfRsrr3Ej8Jc9ozMOOCb6l3vZEIT02kSvmemHYf86Yq7hYqojXonusbhSh
	sPhuSP/3tpzBQQ56pImWhPV3k4OwgzU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rymsx9n8FiJjOLGrnYBXKfgUUaI2hrPCz4qLX634Ge8=;
	b=RZa0bHSMnBv4z04m8iKhHmvmezJQtBM0Vg+Wh8tydTdx82myO67skK7NKMcKtapdBXXvPK
	gzNs5lgORvLMJ4DeCHCRGu1sQsfPuhxgBXJCi/5SEUvHrRmXXlc6H9qlhjc+QVTOAcN3fo
	gE6vn04RhlOKnnFL0K2Z3ynvb9c+4kk=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 16/30] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
Date: Wed, 14 Jan 2026 19:32:43 +0800
Message-ID: <a673d7a2babdb37d60d51f19c72319b326eed260.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: t3cyhijrxhq9kynfthi6943e196mn9ks
X-Rspam-User: 
X-Rspamd-Queue-Id: 849F2C000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768390476-939125
X-HE-Meta: U2FsdGVkX18PbyHwKqtni+kWY+ugB/wCvDbh+bd7aSAZEjvahQREVOxL987xyhhoZgR6m8caN8Ei1tgNZYiYf5bip4Pe7PR4OaasKnNxTERcFDI7eg7qmAi1ki7yR6GqXiK/JOxyj+K9C3MfMI5xYwPLKg40ABtowa/811PRh7XZ7GO2ST9N21bF5m+e3ZZa2/6XfGDmwnWeCNHZFq8K1kIc24t13Fi9ZerDfWaCBxxyL1oJQ+ze3Y6GmhjX/oks2rIU3iep6pKuktcpFhDi0Ibk0zTZytGo7m6X/GhoWJgQqhtyaPMLeg3nyv1Wv6JvYJpwCXKxU1gXV8Cj7CHiUIVxH1J3Ar8ECfn4kY4YwsKPYqdCdKjWWo2XLdtEKbWkrt0eFWfv5yVglJAXMJHg8Hgx1eGo+p/YYcplE3fj19VVlKyQWUGE9ZusV2cAjy5PsED1+tpBahCAnxao0mHnVifNFqxIusOtpLcYVsPSPw31Vq0w5M4LvGJVoXdjF5lcFezA4z+Y7jnkDFxRr3PZf33qgIoQA4SakytH0Ypo7tx4cyx8fhD7pIiIqpHyGZvrB8iaFRwtezGUhh3jGnmxk6YtciyNxp21DRaiIYPsl1IcKzoLqawDD4dOflPV5BxscJUl5QAI8OptrBgnzDRvBtu6k+YYIiOjE56G9FOgpRyZTH4t7/WjRae+YTTzpA0M2c6k6Bi8fxCsp0E89VvpplZjMx5LivN0TLiCc6OnuZfDDahijNhc9/gzodrZAg/7adY2GncFDpalPXqS53r+kndJUNhB741/3kxwbOaKxEZxHDl6bA1N2PoE4OZTCfghByFuXyy7ND0UXwd6Sb94hpIeYqAe3nysPTzYHTImQNyi1TfGVDgGtzn9KzZuvTFIfKu7lBPAcFwpOag6xj/7Y20P3DwaAKHuumlvyGa+bDQukQzr3teG1zMaeiT1uwJ4WxBIJXnbgRkIdkuNV+T
 CdgqZA8o
 8EjCfTgd+ZO0V4m2tY07qeIon7QyJeG0n9xjb2q0QfYWFiVArjWx550lbSdqZhQkMP9yd7WNuGhztr05VheSVS5gUNo50tWqHvj2OBc4tqdJLy9wI4tBls0Nz3hB9vIjZoDLtc6JV+GybD1wFDr+nqd0zoYYuBd1nrwcb8Lx2NCWJ+v2bkSPPGp2/SYUbolw2f46M0bJgNT8H/Iykiz3CS3HXbTgth+Ol7AQM1lPykZw1+9bXk5+nnnvNsBR9aUJji4FNQ2+wYQBtdHMyH07KiGImrJ8o4T4UxkbD//2+7W1cr8AZUUJXkVX6p6xok0XDoADs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index ed12744d93a29..79b40f058cd48 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -241,11 +241,14 @@ static void *lru_gen_eviction(struct folio *folio)
 	int refs = folio_lru_refs(folio);
 	bool workingset = folio_test_workingset(folio);
 	int tier = lru_tier_from_refs(refs, workingset);
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	unsigned short memcg_id;
 
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
 
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
@@ -253,8 +256,10 @@ static void *lru_gen_eviction(struct folio *folio)
 
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
+	memcg_id = mem_cgroup_private_id(memcg);
+	rcu_read_unlock();
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset);
+	return pack_shadow(memcg_id, pgdat, token, workingset);
 }
 
 /*
-- 
2.20.1



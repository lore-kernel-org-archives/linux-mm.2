Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E456EFD205
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F118D6B008A; Wed, 25 Feb 2026 02:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFC96B008C; Wed, 25 Feb 2026 02:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29C76B0092; Wed, 25 Feb 2026 02:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D054C6B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:49:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71DCE140424
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:49:59 +0000 (UTC)
X-FDA: 84482205318.30.964E188
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id ACBD11A0006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:49:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nyD9rwcx;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005797; a=rsa-sha256;
	cv=none;
	b=dDmMHkrC5vTLmJfbn6xqFQdzce1kGbUgy6z0GGNXp+vkdqZU03fi3ynN2eF0TcOpIbaEG8
	2Y3VfXJrC6GS/wM0DEobGRQ1gzi1nuF9ZR4dAMZegJ83i3OZV+kH6BlulYgfkTJxShJW81
	4b8/5QDdtj8QTVAhHKNlHSUR3ni3G5I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nyD9rwcx;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DH3ne046D93m9UmkRfI664mjum+ALgiIemSaapH9p/k=;
	b=0NwwuVGjd7wcO2Bk8u0uvr7ib1DLsgEidTfafDk6ASf/QWmXJMt8nsoKC6Rv+0t4MHlEyT
	RtNFatyExVGEiw97pj8ZubO+tS9qGrUUlNb3V9LdqNGTSPSek7C3rr1MjRnz6r/J5/91+1
	o73oBNkTnbaJtbdU8TqOO3HLQHIQCrI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DH3ne046D93m9UmkRfI664mjum+ALgiIemSaapH9p/k=;
	b=nyD9rwcx6snCszxYX3LPfmB3eeeogHDTXQ073VtwDdKlZzAJSnA62UX8UAHIYwqn6+KGTm
	OH/2s/cP+wmvY/QxRuV6KHuH7FQ8fe7CClgI3hWPSiYEEtF+23SFQNqa9Xsqj5wSMNK3yJ
	+u8gjSbC0aen2xx4ioc8nLWp4m9dhMc=
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
Subject: [PATCH v5 02/32] mm: workingset: use folio_lruvec() in workingset_refault()
Date: Wed, 25 Feb 2026 15:48:35 +0800
Message-ID: <11bd2fbbf082f4f7972a1113ca42a61fbe2876a9.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ACBD11A0006
X-Stat-Signature: 9htj1mjtkrksges6bsnmjpojf4hhgcqy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772005797-492012
X-HE-Meta: U2FsdGVkX18exG5ray8rHsCK8jRLyF9y7BwLgfC4uz0jq6uyByw+rSqv6NOHwsOdTcnKeKWaWN7eTYMsbAa+HeRZfOYMe3gEKP9n/3rHx8hoq1O3jKEFBdvymyxrM7SIxAyFlkCrySpuGQ2vHJLAnmHMCsR+ZNwkBMxYHFfwXSWvBjuLItVIgkFQnAgLNShBZ2a+/6UwjVaklD7ka8vY3qS2WsUbq9f1QYA+LQsP7Aypauvh+OeQK6JtuMuKi1ofwtE3GjewtLJHqpxA0yytYQzniDI/IFVKzoOTQ8wT5oDfBjiF1dswzoF6m6T//Io/cfnGpB1Mg83aesb5jpUKnBmEwDsmHurGoZCt3gGr6mgqu11fDqxXoKzkGunz9INs/rRdm13PCSNj4mAWI9a3D2LXpHExSbhBJvoTqY+5ZuPJt610HSyV4v/KoFW3xKcv5JhXbTgRRc7GmIpTc3/Fn82/fl8V3E2ifCK4ZKSfC+WEtSPsC4KSyWrhSWx4qzHYLcoxQvRG20t+DAIeeNKq2pjSUvxDd7iSBKXajDOlNq1n70u02i1UtHeJZ5vc1vd1fcZO2MPhK0sS3Q5vmQ3HvQGWGgPOKkNFHY2ZWXgsOMMU+YUN4XQQAplYixeil2rAygWx+KJg5WOIkBhRgDCLyn8LAHbJaVBWX2XICuJbE0J2uoLogFVlkoKPiS9vlbaF+sidP96UTKqvTDwJcGB/khdWAQ7eqh5UVaAH/21PPwXtNify+IX3H/l1NpWqxr1d1CBI+j8+P/Ki/7rr4z37SwzldUG4jD8BmdftLvxYV725xXAOqkJwIcXT864lSrRxehVeR2LitNiVGCl4YgdlQk1blae4mwme2dW+h46CGj6KK51QGWPGtEXG4l2zznLXNegO/K7J7qOvHYz3pt0tAHB1NlKwtQTjhfyRP3Bh65cTt5hNW24tpTYzVQXoM1/43AbvD1mpT8wi76KpQjU
 TYwKrtyo
 YXGIjauCGQdA7eWORs6pQiqSP8nl+4BGpjUzoNDNvdgf36zjcOZSUDVk744KhmuKzvVLPRERdh2GLZBfmJ29ljkWE/FwAup73e6IAa4FRFnMAyNvyGVslh2buwhcZXeWAHUq+p3rEvLvbmwAoTb3R0FMkHoe7ZGNq8We4olP0U9nUlwek1v8tkOHS4+Sdme5tSIQhLFmc74i3UPvSVh88Ww0yf22nNYhdX9avo9mFJyNz5u0TnYQOsj58puZuZLO3+KmWNtIp+Nq8txi21xMjc4qI+KWTQVCYSNzocHOcWZ/ejx42MZDfLdQpQwCPcCT3aUoK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

Use folio_lruvec() to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 37a94979900f1..5e8b6e62a6175 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -541,8 +541,6 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
-	struct pglist_data *pgdat;
-	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -564,10 +562,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	memcg = folio_memcg(folio);
-	pgdat = folio_pgdat(folio);
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-
+	lruvec = folio_lruvec(folio);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-- 
2.20.1



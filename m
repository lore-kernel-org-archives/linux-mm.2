Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C572D64086
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C55A6B008A; Wed, 17 Dec 2025 02:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0902F6B008C; Wed, 17 Dec 2025 02:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F084F6B0092; Wed, 17 Dec 2025 02:29:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0CCD6B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:29:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9228860836
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:03 +0000 (UTC)
X-FDA: 84228136566.16.06B1169
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf24.hostedemail.com (Postfix) with ESMTP id 143F4180012
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HzWVNay8;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTqh+R9AqZ6ZGZqMsV71qrw0XbHGmnb9j25C52g1tSo=;
	b=BU9zZviKbpAnwV7d842W7H67V8z7ERMSj0ppRjphoIl/+7r852dpXzGi3O5/y7tjxrN8tP
	Ghwz0Xe90jQYlu3AZsehOn13sD6nSXGDGwjVHtsHKpOBnfqqkwB3HtEX+ZfRC2EbagRYDt
	hkUjjfUhyrmw95/V7XitushegdsLgzA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956542; a=rsa-sha256;
	cv=none;
	b=Yfb2fh4PYWY8Orkg4i9m2Qig/vL/RqZkUPr5o9NKZKMn4Og6mVwlaQMw5LtQD9BWZTZlv7
	QpBNQwyMKBFJTNaN6HymVsht7FqCg6NcwXxG9tRMy55HUtkkcjNSNgxkJ+0LI0C+NXyWma
	KAPkzbj3W7Pp0BSYzUIiGDDXyp4AWZM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HzWVNay8;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OTqh+R9AqZ6ZGZqMsV71qrw0XbHGmnb9j25C52g1tSo=;
	b=HzWVNay8nSdGORHcukbBXgAzr4n9E8zTAuZ3u9psS9ZbHKHC+kPQLttd9NUck2y7Un5PnU
	wguQekl8agZMRrWohpjuuXBgzV0tm6QYsctXzvnjUqRyPG3qVudTG9pjvg2VZCLkuSNrrs
	4cXYorAWepxqxVXWPDP/ut7O1GjqHvQ=
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
Subject: [PATCH v2 02/28] mm: workingset: use folio_lruvec() in workingset_refault()
Date: Wed, 17 Dec 2025 15:27:26 +0800
Message-ID: <08c00b5f429b44a6df3f3798e43046ebd5825415.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: no75m6ufbygqz4uffqgom57gtz5hdpth
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 143F4180012
X-Rspam-User: 
X-HE-Tag: 1765956541-625055
X-HE-Meta: U2FsdGVkX18uRj+9444u9u0w4eZVhz3NE+vy6AOrl7C7bdBJFSkTq0mhT54Av8cO7NPFhJKPuMj1AaOeW2sAOfau9U+6UInN3a31GN4o18LVadrIA9SBfij6JQcytJpcp95/YvKyv1xSYwKNuQXUIwUDWhANlpsiYDUhr8xdnLygMmgpt9ysz1K8FiS13MGIxzCe5Z7N4SfhQQkdty0sYckr1ToSED/mGY7UV93ud++orbbObH8iveafIKjdEcY85OlvYfdVFFnS1YQzcHVeaABeSpvlv8jujR5dg6W9sqPG6DfQ/YYkIvbLcVnOW5bNsM0IBIKbi92LEFlXihgTCsFmn3M0JZHSKLrJ+r4HOT+CpK20tOnfB+caOYloRHGrL4SIUZ4/kzySqjr/fDBUui2Ao+PAsIMviDPqhlA0BAQjFrGNskeRCQX7WTUl9HXqMZZOllFjBInqevLWtubf3Mk82vx0Z1XZm9L/7icDJlg5c9kiDwTGtvQKALUWtuARE/rbh7FSpAGoUrnMJfPdz2j68otKkuZIgWfOU1Fqx6M5qdGhyTRUHcP0L0OsjfNu77gw1GV5W+hWjzicTXvS3rYWjY3OqTsE21MBMK0WbHigoJmEgtNqUAPZo7s2xcrjPwMO47PRR9b5VJsb7NiDwCOucWsvQfz88bt8hqBqOGFwvdKYfrpPGEbTsvuNKq1bZjr/PQ4kvhNRxVp2Ah3eyWA/suPxSWvo0cc7zmQYTPP/3fA2fi3Uc9OAQlBx0nOJ1sTOz6KVZwV3RwLdNvQB3HkCSqQ02SCetkbCf5JkK94gCZvtr42zkokvh5L60IDlmtB7buy8m5BDNF4zOwnvLPRu8I3bHLL/wpw9lNi33XaXVxYRYX76J6S6qXtIq2lj3zu/xi1cFqMKnT2wsTuPg3VNcJIppKzC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 mm/workingset.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index e9f05634747a7..e41b44e29944b 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -534,8 +534,6 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
-	struct pglist_data *pgdat;
-	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -557,10 +555,7 @@ void workingset_refault(struct folio *folio, void *shadow)
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



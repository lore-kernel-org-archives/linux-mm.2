Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78D4D29FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34B436B008C; Wed, 14 Jan 2026 06:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3225A6B0092; Wed, 14 Jan 2026 06:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C0A6B0093; Wed, 14 Jan 2026 06:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16D4A6B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:27:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB31F8BB45
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:27:55 +0000 (UTC)
X-FDA: 84330344910.25.DBDC8AD
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 370CEC0010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:27:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rUMulgyM;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390074; a=rsa-sha256;
	cv=none;
	b=5aP3uVxaMke8T/XfcAbGwXYfNTOIWyTONfvy7ja4eQ2YVOQDEYDJF/Y6bQ1GAT3FBNY/2Q
	WPy27r7op2koTywgulF8eyL0DBEgfdliPRwAet4/2V0+Lm3caDp8oYUMp29oIf4LOVGY57
	2YKtTpS1FVapYpglQBJ/JZm3aUnZjH0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rUMulgyM;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/ZtRh+PZKPvv3IjQqGSMfDaDrKWTZ3Ss0PAhqLZQg4=;
	b=KZTH/piI0fZTwv1UV/WGt8NZf2lBv3kRTIqjWOJLeqR9zAGsiQ2jP8Qd7M+6aph+jyRpQH
	QKEMxb79PyZ8kpJanNnljCt1CU13zXhlH9WPTfA5oGZ3DLTnrGFJCcgwJ+FueGlGbnEv0F
	1uYJP4pekULxeVths5tIM2ZphFvjopk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/ZtRh+PZKPvv3IjQqGSMfDaDrKWTZ3Ss0PAhqLZQg4=;
	b=rUMulgyMmeG2q0uLVtNo59BFmQUuVtf6FeoC5CeQhsdAh8/gapWGceHwAjqpzX+yuyySg2
	oHVzG8B7SWzrcM6BG6ZqAqvbrcobovjWNHsmyThirWhLmS7/X/0bdMih8yoxhkZs6qScL3
	c0kWXK++8CQRpnUzQSZW7her3QzrPjs=
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
Subject: [PATCH v3 02/30] mm: workingset: use folio_lruvec() in workingset_refault()
Date: Wed, 14 Jan 2026 19:26:45 +0800
Message-ID: <09fe58a0b1c0ef35093991fe339a668a6da31f60.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: c7mwmjimjew7oq7jujj4uuwwoeoazo7i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 370CEC0010
X-Rspam-User: 
X-HE-Tag: 1768390074-125160
X-HE-Meta: U2FsdGVkX19cviOvg/qHYhHvYfr6yyy5hcGFINp3W6iJJXsVo+ziOZlsFzPWM3ib7Ww1ji0OBm8opQhoGNcy4LPdjzOb+STSL58PVqSq0dkgm6DxU0nlX5Z86etyFdkufntw3UniI5qdfz0aI1a5YRGs6dnRSaD4XeUt6dzHzlTC7smerfZ4nVLRvqrLquIVuuaDLiwRrpMMdiVxwCmj6HNxwp+kvxsSZX3V4poZriUtCXgxMVkRCzzFp8Ocg1FmmF1/bkoEyJQWeY/US4u1hbw1roKdm1NMwK+6OdOp0UXzwchxqGJBhCz6SK52eULeqjDYai0d+BgliBW4Ut9nI2l4BaRL60dixMO7tyA5KQPGgbS1i09uTH6dFvutCiV6jS8x+jLnWLr7fQQ8IPP9C5iqwHcyGQP7R4C/+KqM8FvMc2TEBUaI3XgTWaxHWsZvDjDcc4jfkfUrwGz33Il+/OUDrKk+eMhNfk9Q06Lamb+nPOHl8jc0mFXbNYIMewCPg7cM0BAoejp+1WrVxj5dMKg5WZvtuKjxmOBGG1VwJeIJXOCzbLVdJ0kGP0ciQqEQYna/c5GdhpnzEUAeLBJ0/9jg3B5bz9zjsckxbLWWZgI0hMzklZV9O/qEbxvFTqcuYLREEpAV4dDJ/qJB7jWBOGQOb/PK8oT+Vi9SkQ2NsE5ztUWF3MGRxeUeLZ2rGhLgMsOSV9OJoJDYq2vFEyD+1N2nnGJ6g/AxRqbKOurOe17kHnuYY381Tp+tAgVYdim06Ge8/eNpmQCv6z1OFRJffLlI2WEyHl1LUfR6Ez2AEfGKU9jNzxGIgYTTl7cOk+Ba0YgiVPcU/T5zBTfGrX6AnZKalda07vBnJ2bdLyBVbCNfodeX7h9guoG+xufcK+a3M15C7fkG/NLcNFmIIx23DsLj287pKwqZZeU63Jm7U4rHz83U8GkMnWHwGPJw0WEzOf7k9I8Qab46dcWNevB
 N9SpxLGD
 JLPmdbDQRsyPTyKWP1gXBBOOeE7pWro5O3YMKR2pSbQkIKmRalk5iZN8JortPKTS6muzZngNuhFjBiaoMXMGXU72OEvmbpB4EsP+LBitlLoZcKMvBm5gZml3Z3OKVKgmAyKRp+Piup5wB15hv2bCzX6WAFD20JkmpwrrLvK4O1P8gSvG3iKFi/j4FJt/N8YOkbukkNtJJ2gnK2eRWe27wWvAqF3dcZpeGpDiIF5R2e2hQwFoQX6+ctnlKjhcFyjKAo//j0hz2NTprSDKJe1eB0RrYMw==
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 13422d3047158..ed12744d93a29 100644
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



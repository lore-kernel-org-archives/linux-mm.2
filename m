Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3F9FE91298
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 08:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0903A6B0093; Thu,  5 Feb 2026 03:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064906B0096; Thu,  5 Feb 2026 03:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3976B0098; Thu,  5 Feb 2026 03:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE5926B0093
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:56:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6C94B9183
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:45 +0000 (UTC)
X-FDA: 84409797570.03.F716CB7
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id F0E751C0010
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mrRpODm6;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770281804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/ZtRh+PZKPvv3IjQqGSMfDaDrKWTZ3Ss0PAhqLZQg4=;
	b=jD16ZWT5nOW6IGiJzWn5i15wML6Jqx88o9a4bZRw4jeXlwrN2GirFHE8rypdVk6u8NsNaA
	3JoVUqDMP/3UH1g6ZvuXLdr9tCviMBSAaSc8aYJTcBVqsXoskUtOZ0aOfE2pFTKnJN06Rg
	SRReiNQ4IdxAxdbJC9eTcLjmmidCjBk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mrRpODm6;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770281804; a=rsa-sha256;
	cv=none;
	b=sdT+depsbyR3YnXmB+kuMgq//kKrs2dweg0dLRd1m2hI4yS5AEhD3JsnduwSEDMJ+tGoFs
	JsuO87L1golegwamZoB+fIL7IiAcPybOXMf+ywRicft3Ws/KZ8pkkx4sWhwklaSWhdkeId
	95r1CUBb5w/s0U+tNVHDloKTKkm8AFI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770281802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/ZtRh+PZKPvv3IjQqGSMfDaDrKWTZ3Ss0PAhqLZQg4=;
	b=mrRpODm6Hra4KkUO1FlT4nkooqcHFQ/lKsguxYtgkV2UdPPYT6fOLOPKzJOpfggMIGq89q
	GaoilPLEKDhhowTXRn1F5GxBtOxMdQvHzb3xMj9lEZsvZ1xinnP0OocftfbjlCWfsjAYQW
	FJq+AqtmOxrmlwvuviDc/Nfmt6vPblM=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 02/31] mm: workingset: use folio_lruvec() in workingset_refault()
Date: Thu,  5 Feb 2026 16:54:31 +0800
Message-ID: <ebeec4d468aca5d314ccb6a0324ee4c8731fbc2a.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F0E751C0010
X-Stat-Signature: tku779exfjfjjmkwc8x6poqyrg1s5dkx
X-Rspam-User: 
X-HE-Tag: 1770281803-46401
X-HE-Meta: U2FsdGVkX1/9yhBJZKcHqD660jFmlJ58BE4lJ1VCWDagBe6h9yUkkqCWSU2huTfpWmn/evRyEVeFxmQbAWMYAHDHEPz2ckLdjQJSgBU5e9B4VAXZRT0nYEtPVQGItwCCxWAAL7aDq1bC/31RT/3nt7hQ5wmiG7blWymmT5DFIUWLvrL+7ZkQ0TrsmM8bk9carNIO230KRhGR+3JtPfo4G/3bBkbQ7WLRfekKUQDKC0IYcXs+MisRfftq2iJoociexAFgqUMfXaA3hW+oS8F6jHuaulm9VTH4SRoyaUKCxb8MCqLzhw2v9s7oPtljlo68ihw8tcRbY85IxWEn2IigCY7D9Sz3R8M3k11qB6DFvOGTNc6VmNpC2fvGGejaqTXMJH+UVslk0+v4fM2KFHtLPR6hLVyqXFI6FwpDOPHX9zro0TzjC+uKodhsQvukXvep6tb2QXOLRiFbam00iIR67GpKyULDHD1sYDTNxUxibb6xF27e1yf+KaycFFT1JFu7CMJecKkBwSL9FY3FqZiz3l44mIQI5zfAz1jTkBcqHA57vQChOuETCos8UkRPwMz7xWM547kK5tRdL5QkXUS4Q4MBjbo3IXcQ05WxjTlX7nQdqGdRBY5JIlthdbhGXgr3XGUowZC6gd+StR6kD5h5+h73fzzo/KhQtJr5EUHDPLY+JMqUrhQ0Xj23twDwAZB5gVrKZNQ4YLBKF27GWsemCxtNu///HICny2PFdj2fapQuF5op/Ies4TjTQ3Jp81e5UDh/8KUurJPO2RV6tK/jNN2RCIJ6/r6xFMdYHNqGpEOuMx4nPDaohesSuDnJsOU7/CdJ3PzzSg/mw6dWpXkdg13RuUXvHMk78TbdEQI2RkVS6/hsEmwd0Awa0deZDEj4fs1brfcUt8vy/IvrlQlY8rMBGIpLktdIKyZ88XQipzmggWZiClqW7bwxmBSW2YhiMJ7Gf14xiRYhcLTUKCt
 K9NGEjzn
 EkhRrI3rH2rE1xWVCm4tzmVbP4O9l+usn5QS+XweQf1SsC/k5mr/Open3Prp49rkDo90yAlmlKWJ5HwqCtLQf8IjV1edcaxVsLctdNDJJIqSAatKEXYtzIgIujjmA0RlsxVJ82YUUqT8KEhRPEgqmHyFZ974vdvZPGjNvheEPwN45AGopATOs7z5loQlUNZYT9rWHLXM3dnG9rN8Sdx9WLnp+rDf5AuDr1zUVhBC3Li8vEeb3dk0eX5us2IY3Ihon6gxRmGD5Awq/ou3B2En3BN7jqw==
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



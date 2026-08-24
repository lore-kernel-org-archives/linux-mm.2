Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A894C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225176B0092; Mon, 24 Aug 2026 11:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC4E6B0096; Mon, 24 Aug 2026 11:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112AE6B009B; Mon, 24 Aug 2026 11:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E43F76B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:17:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66A38120179
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:17:16 +0000 (UTC)
X-FDA: 85136516472.20.6A4E908
Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36D9418000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:17:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jGVmdoyk;
	spf=pass (imf24.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o8tvupUJVjge7VOyr/MeB94nMe8nrwxkndMSq/x/HPI=;
	b=hIff9fmhibElsf2P3XnMr5bsLhgIk4/Z4tyKfdkLAO+f/1EuqcyYJ2qvq1TTrhM/xaUM1+
	z9HCKkuKM1+tbtWbiNimJmk7cBz+A6mwODMWRFNoXWKV7CSuinUmIXPtPJy51k+wvBMjbf
	4HNfeqEen9BjgWS3KkfSH/98ZFFFW+c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jGVmdoyk;
	spf=pass (imf24.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787584634;
	b=BebLoozHtJsJS1X/0gwH2TrEHVzNRkAHpeTKuTwuZCqEz+N1kXh74q0nm5NY9CKeajYWnC
	lh1rNru1o6lzpJpZ6I3w1k9fMMJwEEM++d1SyoxBTsoKd15gxWM0Kvs8J4zLYa6FdsS+DR
	IhRVP77dAWyZ9yNzigwlHooglhOEzRU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nnwfma3LbW6bRtCanP0A2+TZGElDcT1LY0t8uIBYNdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787584632; v=1; x=1788189432;
 b=jGVmdoyk8i6VDSE2dDi8JPMshONAglUlAhOXivBFC504KtL5eys06Xtn9mbAs4O1b2grzMSs
 teMVgoHAkmIKRifNXCn2YnvWuWLj7jrTF5KrQOmQyGChOsuwYp3YjWQnBtbd8NTy91I8CxZ9AS7
 GfpZk1yjXbxLCZjWQe5G1iEY=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (113.218.252.84)
	by smtp.migadu.com with ESMTPS id ebdc5268ff231481;
	Mon, 24 Aug 2026 15:17:12 +0000
X-Mizu-Trace-ID: ebdc5268ff231481
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm/hugetlb: use hugetlb_vmemmap_optimizable() in boolean contexts
Date: Mon, 24 Aug 2026 23:16:55 +0800
Message-ID: <20260824151655.30840-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d1p4anyn478egjekcg4uoj5do8qdko77
X-Rspamd-Queue-Id: 36D9418000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787584633-235769
X-HE-Meta: U2FsdGVkX1/XVHlFNjFz757YEUyIs/980nsii9RjnqhRq/l1FvAkEgO2/Y/dMCDi7wCKqrCS6GddxukWH6RudkdKyMBSBBzl/MXWOFcecipqGKs+7bC+3tPoxxYynv8fmd7hA0s0TbO3N80d3BXgh83Gk3hvtSApgxQncVN1zQlm0eCRS3+33DKR2V2JKoZwICAUYn47XseHak8SM6uc36cqTjjrj9j96w4JJLJHgTUpsEPRSnxBduKnPT259HTJlgtWWNF2ZcavbjEtVg8bSmIU8KrZasYDYHNz3VGGT2YSSLnYFU3xEMEqJv9XpXxX+blNvOi6h4ZbP+73A6UnarcXLZqnTc3+pblBWMdmAm3kID79LgYFiuZYk8eya0NQAm24h6QfpTVlxjj5KT5Yz0cAB25rIAqsSezJJXWTx8+uf3DC3UthYPhgYGH5PzM6Ma44e6pMvVQEDOn1SWpUdt5/f/iw1Ndf0NJ+wlsP+d2HGuoZur9PwlXNpokuWkDbc9PCRQvVJrOnpYgVv+3Vav411E1AWIELKEBPaQPWu3G/i05CEv25A0wd+2YrnzJU7szI2kbHvv5Wf87uDkxR/3sfhOMvBdehq+Y8KbXcKc6c3xjDNVHHayTJaGxjt90F79zoEcdK5ocL9U7vad6R6d9Fbf3acAbcVD8OlaR9RjsKC81mQAWdtHUCGkWs7LHcd9XTFLXyItmKFKCKVdNFmf+7QyeLf9WLTZkxpcDcVQa9PYcmFP//+53iSLfQSxA4Ohb0Cc4LC++ZobQoclkH4JSEjml3DTZu/DHbSS/4f1VRNhqGThGpWRaqA7aN3Ed/up5D2oIPuFt6xhCFlgKQmIHsYvuZmfmM1+jaeVmHjrnb7A1l2MvLvr6pguWIKtjtcTssNMMELa9s3Ug8P7Uqp16Fv3lJ6BXlKxlP8h3fATW1Nxorsy1k70u5gCDgjnz7eiupWp2tzTl8mdeHiN7
 cWm234sf
 vBaO6Acfv245DAvl7kVyJCMqcKTX1WBTdGbQ3Xy/mLU73q2xSZ4hsuCD/D+gHpos5rYU1GXcWZSvezm8ldph94jzy0uePywYCEQpan215OJ83Kfamr4FxwCooC6+9O/667nSxwa0NkGBAUd6QqwlaeOW8Z7eBz7P7VI+Yk6n0oo/9c9wMvvIa3Ve89qMWbCthMS2M2avnad8k4y19v5KwShtoPWCgPHFkuCHusVRVxueXzZ6/z0+BoZMfy26HgW38KdWbl/jeh1xllykwhQxjPvRf9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

The two boot-time sites in hugetlb_hstate_alloc_pages_onenode() and
hugetlb_pages_alloc_boot_node() only need to know whether HVO is
applicable, not the exact optimizable size. Switch them from
hugetlb_vmemmap_optimizable_size() to hugetlb_vmemmap_optimizable()
to make intent explicit.

No functional change intended.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a03a75fd7fa8..885f721999e6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3416,7 +3416,7 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
 					&node_states[N_MEMORY], NULL);
 			if (!folio && !list_empty(&folio_list) &&
-			    hugetlb_vmemmap_optimizable_size(h)) {
+			    hugetlb_vmemmap_optimizable(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
@@ -3485,7 +3485,7 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
 	for (i = 0; i < num; ++i) {
 		struct folio *folio;
 
-		if (hugetlb_vmemmap_optimizable_size(h) &&
+		if (hugetlb_vmemmap_optimizable(h) &&
 		    (si_mem_available() == 0) && !list_empty(&folio_list)) {
 			prep_and_add_allocated_folios(h, &folio_list);
 			INIT_LIST_HEAD(&folio_list);
-- 
2.50.1 (Apple Git-155)



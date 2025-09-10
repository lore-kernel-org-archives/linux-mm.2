Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C50BCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4B28E0013; Wed, 10 Sep 2025 09:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DCE8E0012; Wed, 10 Sep 2025 09:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883AE8E0013; Wed, 10 Sep 2025 09:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD958E0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:40:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 384FB140889
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:12 +0000 (UTC)
X-FDA: 83873449464.11.BA192FA
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf05.hostedemail.com (Postfix) with ESMTP id 04BA610000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0n2uz7jJM5FlImJmgKckeH3tmuRBBKhKx7s+z17BDqI=;
	b=Tz9LRI/ARWm0ZAGpp6Km6NyyVgYnzCJMLvXPCUgJAiadGrb1ijhnL7y1gwU223tLyXbqaF
	jUscp7mVLgO4XVsnKmIIerqPafV+nmk7rcPuqO0A3oIJgCGc7KEXFzr6zQ4jVJCKUDUoMt
	3FpPupLF0xAB186v6S6woJ1Y4rPzX3U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511610; a=rsa-sha256;
	cv=none;
	b=vdcAHlSEf3SRfI7KKEFwziC/q8nYeccLUYTqLuCC+xA+LFDpQDQ7cixR4C8piyJq3UJEcM
	peDpNrRk3+YRzPdumhJ4c79uN4wmMP/621aWPcdoterhtWavy/OuyRUseZhaW+J4QbAVba
	Dy6Ri8fVZKaE6TcckVn2zhNi7mdfbeM=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cMMDK2nYgz2TTFb;
	Wed, 10 Sep 2025 21:36:49 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 874391400FD;
	Wed, 10 Sep 2025 21:40:05 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 21:40:04 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 4/5] mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:57 +0800
Message-ID: <20250910133958.301467-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
References: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: rwtbq7ao85sdu3xi3nfs97wzajnh61km
X-Rspam-User: 
X-Rspamd-Queue-Id: 04BA610000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1757511609-933796
X-HE-Meta: U2FsdGVkX19y7ae3eCDQc+if9czhgd/EZouIrT3KNopox6bdIKFY8h4291sOJamMCCh4zKpgO/telpD1aoVwS39OCklpRnLBrubBan/xzrwJIB0Ft9JMvbIsrw+3mdbvTFJEaLzPc3fmkQnz2L4lImX0odvaD63QPjd25NHafzLfcGBf4jkbPlcPOiCqk6qmaL0Yk5Kg5QccSkBLMx49S8SnRw2k9kyCBdRZ/AIeeBXpZAkUf0FpmatBpRPdU7N3Ih+t1F7h2Nn3DjaAYWYdS42bYREr+o/bqG/VsRgownYbfm1CWj+CsbvkFFd0M53fUpaamQKq8YXnhwCfVol0N0FnExpqCfSI85KkUq1YRW+83SgLzJBYbcCVBbH6pGjY8DfXnNf8AtuaCoB94oodI0fHxsfP9JnPWwL0jYjXANF63J8BQDsz0KeZJ914Nd4PQqMAApKiphktW5UJ0P7kcjsg+8Gq+ba/i0A7YsWnU6Str+aq7EeNcPydHL+lAR4MBZk0shx+423x2H7XNELZHZ5uGIcFzZMw9HcpBdsJz2+F+AMF0KbIC9CceJoU29vOo8ohl63If4RD7G9PLrk9tJCBCUxL/YzSuNsQ7QTTZUZtB/gmncaJYhqMnG0fU/R3plBoBlWzq2XKGmQGO1hxSF8VPcPR1KJk4BEruQcDW/QDhztbHKfN0ZFvgXzTpy2fVQtP9iFeo7Vlzqj0dWFH/R7AKsUI8bqvCf8fPeXEHUZ45kNTu/Afg7pFkWSVTW7rj04ogU0XquhkaeqqTRF9heHsWCYqnYlcdebCMD2vxVwZQFrn7dhezWXKgu6vAhtDuT6BT5e48awHH4HeQnKqWon9orVtu/8JQr9CcZKSnzUugZlzlVCxfFhJqeVKQH6FPinBzOmAz7GsVGUHfrz/TGiMp++gip5HDik6sWS/hW9kWMqDhjlL8N/TAjYgToVFl930gvYbhEU91TOqmcY
 iSOZL9Dd
 zYwvwAIm7J5H8UxBBXdPu4ZygzsB+LpkVaCveaet76OzT3fxL6yaNox0ma/z2wA5TKUXS/5WNIGg5DTRyn6K+pffDhTJECSbN3zpL8OKE/xNHdekUumf2MJU3itrtejLewq6UvryiRhALrUXGOR+8m7NfR/MmUifwEpTnoiQjOlIEO0hzSXXhrRZ8TfF8tt2Mi1wI2uIcm+ZMsKfXFhJGRktk8lHxo0bHPB5tk731t1dIqFpExBYCXcN9RWT6Dn4HoZ6dXBfWnV4O6JDGM6Bm8/U/vW62Y+ZtMZ37swmRa2EngkJffuUT3sVt+wpBhjF4YLhZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The struct hstate is never used since commit d67e32f26713 ("hugetlb:
restructure pool allocations”), remove it.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b98736ad60d3..28519a73eab7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1896,7 +1896,7 @@ static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
-static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
+static void init_new_hugetlb_folio(struct folio *folio)
 {
 	__folio_set_hugetlb(folio);
 	INIT_LIST_HEAD(&folio->lru);
@@ -1985,7 +1985,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
 						  node_alloc_noretry);
 	if (folio)
-		init_new_hugetlb_folio(h, folio);
+		init_new_hugetlb_folio(folio);
 	return folio;
 }
 
@@ -3404,7 +3404,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 
 		hugetlb_folio_init_vmemmap(folio, h,
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
-		init_new_hugetlb_folio(h, folio);
+		init_new_hugetlb_folio(folio);
 
 		if (hugetlb_bootmem_page_prehvo(m))
 			/*
@@ -4016,7 +4016,7 @@ static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
 			prep_compound_page(page, dst->order);
 
 			new_folio->mapping = NULL;
-			init_new_hugetlb_folio(dst, new_folio);
+			init_new_hugetlb_folio(new_folio);
 			/* Copy the CMA flag so that it is freed correctly */
 			if (cma)
 				folio_set_hugetlb_cma(new_folio);
-- 
2.27.0



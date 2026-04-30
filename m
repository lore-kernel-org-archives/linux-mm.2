Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A31CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AD46B0096; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A826E6B0098; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775056B009E; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 401656B009D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 085EA1C009C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:58 +0000 (UTC)
X-FDA: 84716346036.26.E624BD1
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4EFC180007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YOvCBOn0;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QlCxWH+Y7W9QsBlG/iTMnUBj0keGEMtOuPZJKk1hPQ=;
	b=OsBS1JQK2Jc/FapAZKJDIZiISuSBMH7ICgTLl+QsQt5lsT6itUwGjm+G2cM5MXIUHNW1mL
	Kk2eJpSwcXglotoTvdJJj/7GSRUQaT9zv3ncnUNtzSm6LirCVxlXwTivZiwHIPV7ld9TJ2
	joiS+2yY3nnJSEIs3PJNYZCBHSn3Ko4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580576; a=rsa-sha256;
	cv=none;
	b=5xNQvCB8OQsbKF8tEUALQlaB94Uks+PH4I4es4c5U4VPc4sfakh8XiJm8200E0dKFXMmKF
	b8vunCYOYS3FBzQFMsOGR23FGb/YxkL/FcoWkpSnObXX5fM9gQ/RPH9n/cwF1RP0RTXt4W
	HCbkop3wXf3EMfGMiNrByN3SPZyHJOM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YOvCBOn0;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6QlCxWH+Y7W9QsBlG/iTMnUBj0keGEMtOuPZJKk1hPQ=; b=YOvCBOn0/Z9zKbBcuslksNs0pY
	NC7KreDKPX+ruw5dKlBiUiRjpyw2hePSWp7e4JeyyA47RWV570IVvgILwoUbLIs6eH7WOYD2ggfR1
	HvswcaW+B1C7OiPN8OV4V0Y9Jn7fozGpejYSuPadWCJGupg0vqOKC2KOKhM57aVXfNBmsRB3U3tm1
	BSzK5e6vIDkkq1npK5srjK+uvY5yha2+uH/a8PgX6Vhu5Yx1DJgsLtkFXKDL/uDWsPJRR6XzhwwCb
	zDc771zbMmrX93TzTX5FF3yf/64rK9jJX9Y+YkEv294YzzGQGAwU9dk6Q2e18IPVgPgxeKJbw32Cn
	RccK2hGg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2BX0;
	Thu, 30 Apr 2026 16:22:40 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 04/45] mm: mm_init: fix zone assignment for pages in unavailable ranges
Date: Thu, 30 Apr 2026 16:20:33 -0400
Message-ID: <20260430202233.111010-5-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4EFC180007
X-Stat-Signature: 667riwd9bzduyuanxy3hg319im4pq7an
X-Rspam-User: 
X-HE-Tag: 1777580576-14428
X-HE-Meta: U2FsdGVkX198FmgVR5/OsLn+GII/ZL4SUS0Dv+YSauIM6KajVqZg6O0tHnsCJaztTqc6qY33Bjlm2tGTUtqc2S4CnaG36SyU35rrVK9JdgDp5/1SqH6GsY48x0QO6AWYschLtNPvjCCczUC2LQ3gpQ+7pRtkU90wPRYY/s/UrDsLK/dqT8R1rnSSROs58DKPqAkA8luuHrjEKkxEAtZvT+pft8oHTkMPURq5fvOrLjR/eIRp+R44Noz+SNZraKXKsYLtFxa1XVJFYPN2IvXSSJFBuIw63CqaJy7CU5Z//UoX7B1NPf2Rk4pRuUpClYIRWlJ+ltYT+nWNdb7fkWkh+7ABKeM+glwAWc99CzH/8k76OepZpJkuqSYq0kEte6mQPKVQBDa9NUFlNWKLmRgeCvplDgf6RjY6jJIW8G/6nXDLHwc2E7ATWoZtR00K6MrVq058aoHFIxG69BgBnOlcpkJDOpDwaDROeDrY/CGiwzu5j4yndwAd/6D6Kq/t4rez7UYgl8GM42tiuya6xiOr3fBkyujV81jJPnIeriLUXjpdXset0WwKOTmk7ifKIH8RQqfTUhY5CvBUMGyv5J9zBlRVVEd618RDZN8mqb9zd7XHISxeLPL2ntR72vQZaoql/soR1MykpGLMbJqKXy9FgFXOSU+yz8oK7r5G4fgVpwN0UM1vgofrZ+5K2p8Y3zKFl2PyW3dAa/rTs46y/ZbzMIlDnrXWO3Y+72+m661zUnaBDSs/YR2vDwJ81v8657ooErbYnjnw0Jfn7X6Vp4hgRLPpmMAT0Qq1luvhZ1VAAHMWqn9200aMPDGUw+YEV6dFb0rZkCXeO4njqPQUanlncbcm2qjRwbACFCUFs1uCF23jE1GUozPw9z0HZqcw4r/X69eGKcLCCwMHI6YcCwXOf9l9yKofZALZQxae9h9udXs0b45TzhI/8T4m+2OJLxk/9izBMY1cl5LibQb01VH
 XKO1vHu8
 w2l2ipT7avQV3jZEk3Wll/hy9k0AnonJLPWyb0jxGP1PyNd7UgoeqdF6xZQM+gW5NKlovb4uhNizYgwDbxUlHAzIXfakHKsPOEzdTeQhPiaRU316cMWZHVKS6/7u7B4zhFJeECPhYyWsrVqgUyundmLi3Kk1DpOB3n9goqt6PhF8WW0vsfpLHHqPG7yhsviTHsMMtiNnthgDViNNbTN2ZuUV79xk29t5isqkBGvw6jRtInH/RciNqo7k7F01czo4q7dYiV1Fx8/6b945ybZ+5nSCxqfxynx9UcbLx3EpmbySiCBW7LFsU+I9hReYBdh39wd2cVO2WKObBlPVXN5wMZmf33F3eiHrCsnD0n9kNRPjTyKeNb6f8/1Idj60zJlLr5s0oAcxEVdZn0FEWZB6rvb2UyZ80k1vkTlDK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

init_unavailable_range() initializes struct pages for memory holes between
memblock regions.  It receives a zone ID from its caller, but that zone ID
is simply the last zone processed in memmap_init()'s iteration — it does
not necessarily match the zone that actually spans each PFN in the hole.

When an unavailable range straddles a zone boundary (e.g. a hole between
DMA32 and Normal), all pages in the hole get tagged with the wrong zone in
page->flags.  Any later page_zone() call on such a page returns the wrong
zone, which can cause accounting confusion or crashes when code assumes the
returned zone is valid for that page.

Fix by looking up the correct zone for each PFN in the hole.  This is init-
only code running once at boot, so the per-page zone lookup has no
performance impact.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/mm_init.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f3751fe6e5c3..b3f83452de72 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -848,9 +848,27 @@ static void __init init_unavailable_range(unsigned long spfn,
 {
 	unsigned long pfn;
 	u64 pgcnt = 0;
+	pg_data_t *pgdat = NODE_DATA(node);
+	int zid = zone;
 
 	for_each_valid_pfn(pfn, spfn, epfn) {
-		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
+		/*
+		 * The caller's zone may not match the PFN when unavailable
+		 * ranges straddle zone boundaries.  Look up the correct zone
+		 * so page->flags encodes the right zone for page_zone().
+		 */
+		if (!zone_spans_pfn(&pgdat->node_zones[zid], pfn)) {
+			int z;
+
+			for (z = 0; z < MAX_NR_ZONES; z++) {
+				if (zone_spans_pfn(&pgdat->node_zones[z], pfn)) {
+					zid = z;
+					break;
+				}
+			}
+		}
+
+		__init_single_page(pfn_to_page(pfn), pfn, zid, node);
 		__SetPageReserved(pfn_to_page(pfn));
 		pgcnt++;
 	}
-- 
2.52.0



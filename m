Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C83C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B910D6B009E; Mon,  7 Sep 2026 08:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65976B009F; Mon,  7 Sep 2026 08:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DB76B00A0; Mon,  7 Sep 2026 08:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84B676B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:10:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47E53160142
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:10:06 +0000 (UTC)
X-FDA: 85186848012.04.D081867
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3EA8240006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:10:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788783004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=1KtdU5MvJQqenL1tnMAEyG7OGb5BpCvnIMEP3kvwb+E=;
	b=39Moj0cb7HECn0svIP/Ti13AEkHpXEwf8uUgkWDUD063gzkgqlfJr8CC/TzwJw712cweI6
	w+o+hqZSviyh8YR99ZVb8q+Zj3JE+cm4JZb1HGNOX+GghHTvDtZtq3z6ixzytW4Tb7/6jY
	yyCC1C6ya2wBcIzgzm8j7ThvwO/7rHQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788783004;
	b=IkFZfU6BWYdIWXVLxuaDnTBGxhUL/wWe4MkhAMnSKnEPt6BExUS4sBhyWQa2h8XbuTYQDj
	cDxu1E88UsCFLKjEongpyF4rx//b5fhPV8bpun5ewDMejCkq+rESjzZnX/VdXB7KWmFAVt
	kLgB5PeGK+NE34XXvynrOy7kbh6w30Q=
X-UUID: 0945cbbaaab511f19a56ed5b684f684d-20260907
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:21fe8680-272e-4999-b108-5fef9e18dad1,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:225d1d5d4746b72c03c14b3ad1e5a414,BulkI
	D:nil,BulkQuantity:0,SF:102|123|850|865|898,TC:nil,Content:0|15|50|99,EDM:
	5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0945cbbaaab511f19a56ed5b684f684d-20260907
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1539729262; Mon, 07 Sep 2026 20:09:54 +0800
From: liuqiqi@kylinos.cn
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [PATCH] mm: page_alloc: add trace_mm_page_alloc to bulk allocation path
Date: Mon,  7 Sep 2026 20:09:49 +0800
Message-Id: <20260907120949.418450-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ycmcju4o3kkb3oz1hado6ph6smgyr7sa
X-Rspamd-Queue-Id: 3EA8240006
X-HE-Tag: 1788783002-29516
X-HE-Meta: U2FsdGVkX18Dqm9dfb0Z47B2ae7CFem8bI2s5jajJ6yqr6DT9SluPEIzLp2bJruHZrd6Jl5v2m1uqgX3g7JPHwXmf/mFRcOBag3lKFsuSR49fW4VywwbUkoaRyQlyApttpUuhWp4UUhSwbsn5swEI2yumTBNS66ebjQ/MARA1lgetvlqcAbsqbmgmEslqLLFh8JEMcaJiIqRi+mAoBnFA4U0TUcCPrjyYsW5TAC+veUf1p+ymO4oP1bgYw09yar2vJbq1F9L9wCr0auiyhENJUwYcrQReVWxhVI31fc2IUnHOlLnCt/l1ABqp3oZ1Axy3VEVZWpq+RmZGb7peZ7NcfAd75sODTYrT1F6wDzq/2PgN3ZGnOb27DRjK692b7F0nwW2qmWIGV0EoS8A2/P37nFBZx3v7l7Fal8rNvQl4ey2nd5jANP7p3ddWkeB7ey+COTx9oVOTSLxdN5iNyYv+MainWc1tmT4jo+iuCkc2hij1Klagpo1Hrgtxafpvs8PuBDMgPNs6f7GQi8fas94NGEQurgEX/lAxFmTbrdXPfru4n3ccrHnywdDa8SOKhCVwxS7ypduf9CeLzxAts5Jyk8IMoPITGN5RfPdTTgWHMIXXyzF09/qxbK8E9t3RZmaJloiCa5wX3HJlW6aqOQD/tD5Q4gn9Wyjh2I4QKfgftuvL1tRVogXA8x693U/BQqHUOD9vI1sL9ePOy2Zva3QUTvjy+GhDW/fZDQYXMBKCx+pyCiYa5z6suNl1GQgWhne3KWHR6ZHmXwhrzjpjKKdUYDPTjtS0qELaseTYZCdRb9NCcGajEHePsTVt2dz0dCDcebc+qVDmH6TZRmSmoAdYclSJUUr7jJHRaS+h8bzWmEi7L5orKEv2e0LtW8U+S1U9JSZVA+5UJMZzk/RlNIOIZJMOSJgbDBxNlAsb4vHMBEUpsBn4yS6yasY89YKCfIIAw2W97TiKxqbCeKmQ4u
 Kcilskqe
 rysGZRgm8eHf6OBpHQq9QU4qkBTRw68YRH2NdcV9GVaRSs+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiqi Liu <liuqiqi@kylinos.cn>

The bulk allocation path in alloc_pages_bulk_noprof() does not fire
trace_mm_page_alloc for each allocated page, leaving bulk-allocated
pages invisible to ftrace, BPF, and perf. Only the fallback path via
__alloc_frozen_pages_noprof() is traced.

Add trace_mm_page_alloc() after set_page_refcounted() in the bulk loop
to match the standard allocation path. The tracepoint is gated by
static key, so there is no overhead when tracing is disabled.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..d17c21775cb2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5280,6 +5280,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
 		set_page_refcounted(page);
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
 		page_array[nr_populated++] = page;
 	}
 
-- 
2.25.1



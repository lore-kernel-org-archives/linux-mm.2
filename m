Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A08C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595176B008C; Sun, 13 Sep 2026 22:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545D06B0092; Sun, 13 Sep 2026 22:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B226B0093; Sun, 13 Sep 2026 22:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171946B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:46:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91A4A80EA1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:46:09 +0000 (UTC)
X-FDA: 85210828458.18.13B3F42
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59E57A0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:46:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789353967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=2+Ar385qYLGHnkpqpRXsQxijh/WUqSm2AZzcE8JmdP4=;
	b=Yb6R9U+9LVj5k83BaBHHx2b8Q/LcfZBXTmec/B3I0FdpQAj6TGLdLdHYWJ5Hpkx5wipNiu
	rcS1o9ZIL1vsjFoiLtVAl9eS1qaWd9WYPuc3zbGlkiuj7saibjPtmTj0HN/s9hMov57qbO
	zD4tZ7kObhkfTpLkS+iFR+pwJtd4Htc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789353967;
	b=68ZWMVXKlz3Xg/5nr97/qFSmUATYG+IRmkPyZSaJwJ47Xwy1PuBtsp1AdjZC7hnzC3G+h7
	i/xA6/l82lGc16Mq4igvowzmhBwzg28HMpuYObC5cH7PoR/3PPLuSfLTkfDtvxn9UgT4O9
	oAvaXS0FuNZUiTaVKW38m0LXjp3k58w=
X-UUID: 6ad32522afe611f19a56ed5b684f684d-20260914
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:bbe0c4a3-3b29-4f5b-9302-20e446aab4f0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:828b17566f75bd7eb8976c8866957840,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50|99,EDM:-3,I
	P:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
	,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6ad32522afe611f19a56ed5b684f684d-20260914
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1935826873; Mon, 14 Sep 2026 10:45:59 +0800
From: Qiqi Liu <liuqiqi@kylinos.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_alloc: apply per-task GFP context in bulk allocator
Date: Mon, 14 Sep 2026 10:45:55 +0800
Message-Id: <20260914024555.138125-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i7exy9h3fti9khapnm3k8rf1qsdwjemf
X-Rspamd-Queue-Id: 59E57A0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789353965-23794
X-HE-Meta: U2FsdGVkX18Gcu8DVcNZ8kiaGd5mjwIgpq2TDY+D4Ad4j2GNtJFQuHDHyVhk4BmVLwK3NioERkZXD1wqnMXneJiHDke2KHFf4ix5mPp0oBP2KH712s53iZf8ZUct5ObfQ9iM+dIEvMKIi61HMRW2WFdbdpvzGOuoZOQkUAhSIjeCqbnGuAeuLyz1/bBZtibNjQsAfgcX/N82Xiwvnjvzuq778Ocz0IyKeEmDXxC6AGeZ+HWDcQdjdBsWbPnh93qxS3ICp4zGAwdh2G2dkWOmRc6b491Dp03EncY1sYeaMRPW1s3trhcgLhxO0uq6hMwSNIs37i0J4pM1txtVbZQSnesA0hy3CLwaRtINpB+hC94MSsBAgXOhZV9E1Z+OWy8kvKgMnDSnj5LSX12Kz1eeM+GDr2swjdltGJKIcGa8HxGQGPNFH9mutH3wfRkzwc+F9rhwJE2wfI83/JL1xyviK0uLcIUEIb1aW/DDTmuJEs/7Bq5OUhvpQ3N2LmOWpbGyDv7iSOKXIRzV62Zor2PI47jbVUD1FJ0VoWtf+WyvibFdClwmY/1OlxTieSvzv41GRFdcqUBAOPC/LVOkupDaw5MQ6UgnOraJDjOGnUIOeTlfbgsmV188Updnv0SIZHWt8A1uHRZvb8act2kr6tMsMJoPjXYWLfvEO47uL5MUuP0r51zqtigdHzXkhTpNcMGQuMStMbD7NvLPmLRPS7OPKBg3Up6y41Bu2ym4iV3K2dDT1i/mFW77CRLUibDTW10h/a5WXyPIq6MAkzh9KOYiaXBa4PfkqDYKNSRSbxw8GDlOUNdy5GWdnx8dinMn0390TvOE77IjHiTVqHgDYqppEdZVpPKlYO1/PhGR0iP7ExNMKV93+owbmgkNaVTCydEQ338g3cJLV8vCEqZHkwmcJJ6OtBzPRWp09R8w/SScwquTrasc+3CdW4ST59vEsCssY+2ToQaRnePOI/TaA8P
 aNdEyTlo
 GEDKBtBT1sUEHvqHdFNzcPEUbrQwQWh+fLekOUQ4hQ7t4mEPlPwKd2mZ7wX0ZZQsNAiRC1s8Vh3gDcI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pages_bulk_noprof() does not call current_gfp_context(), so
per-task scoped allocation constraints (PF_MEMALLOC_NOIO,
PF_MEMALLOC_NOFS, PF_MEMALLOC_PIN) are not applied on the bulk fast
path.

The most direct consequence is PF_MEMALLOC_PIN: without clearing
__GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for the
PCP list, and a task under memalloc_pin_save() receives movable
pages from the bulk allocator.

Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Cc: stable@vger.kernel.org
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..3be7288a1aa7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5207,6 +5207,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
+	gfp = current_gfp_context(gfp);
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
-- 
2.25.1



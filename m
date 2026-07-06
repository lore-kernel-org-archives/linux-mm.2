Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A6AC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42616B00DA; Mon,  6 Jul 2026 11:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AA56B00DD; Mon,  6 Jul 2026 11:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30936B00DE; Mon,  6 Jul 2026 11:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A64376B00DA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:45:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13233C03FE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:45:26 +0000 (UTC)
X-FDA: 84958776252.22.6B012A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id EDABE40005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:45:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OXv89XG3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84lc5B0NBz+7Y8WKAyou2vvafhNe1K13yiHHAsSIXuM=;
	b=uliQzp0zG/+UqLH+jiZDZ05qnukaw2E78J6Qnj9xy5vMGtGBW7ImHLxLZRkmayuer+wM2f
	m3zmanfKNhFyt53H3nnR8IMObWocTRcMbrztVy6ebAgN38b4GFzHITskEuQMDfVMMch/zx
	Dzs2A+WbfrSARFjwbsszppSq0kpY55I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OXv89XG3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352724;
	b=BEtIo790DJSUGvGNwnBOxtdLjvax9jhlOIcKJyyFRiYlc6gQfZkZ4hzORZRCWzUmmKOq2T
	BSfaCgGDU7IWy/6vIGkj1efeCjwcCc9Q6QzgMzh0V5H5FFG//sAC2cA8dLdJlb260y1FvV
	bjPzq/eondkkGRKEbz+AsC6kUIFhJ3o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=84lc5B0NBz+7Y8WKAyou2vvafhNe1K13yiHHAsSIXuM=;
	b=OXv89XG3w1MAfj7Wlkn/6jcrCnUiBKMh3MZL3qTTLttTVfWMO1SLA9wT6TxaGCuIfu2UHw
	AycsotV9jHKU5krvDYXbDgo9Hu7sYEDd1sF6IV3eufQT40e6e6+d8APSnrbr3mUTYPVXxG
	nwbZn2vEpOw8p1eVlDVxX3AotEofXrw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-zMc_VIbXM2uh8MIKARxtqQ-1; Mon,
 06 Jul 2026 11:45:16 -0400
X-MC-Unique: zMc_VIbXM2uh8MIKARxtqQ-1
X-Mimecast-MFC-AGG-ID: zMc_VIbXM2uh8MIKARxtqQ_1783352714
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E978718052D3;
	Mon,  6 Jul 2026 15:45:13 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 31B6D195604B;
	Mon,  6 Jul 2026 15:45:06 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 7/8] mm/khugepaged: clarify a comment regarding max_ptes_none check
Date: Mon,  6 Jul 2026 09:44:54 -0600
Message-ID: <20260706154500.39178-8-npache@redhat.com>
In-Reply-To: <20260706154500.39178-1-npache@redhat.com>
References: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: Q1MvE9EDBwAh60hGfa15O1IvaSA0LCydzF42VEz_5lU_1783352714
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: EDABE40005
X-Stat-Signature: 1mgmxzhiahk4zyowjo5xt9zy13mysn8x
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783352723-376247
X-HE-Meta: U2FsdGVkX19dsm2t00TX6dWmn5PbBSHxLYyR42flRV6RRoOOFBdrBBlRcWrl1BQCtvzwXSmrq8U4pGrcT3xZG+4M3trxYrdYv995rx6Wkoq8zrVio1eHQpdUvUPWFYvqCSy1bAs6cGwCflEgcTAmW3TI9KtY+hzAYFoqSFxREpn3aI9YKg/9dLHdvQbH+Oz3i/RYT0sf0SlEcDqzBma9OxjduegpXB1CX5WCxUNWmxNAmYrjGrkLAWDGt7EAqJKTy3Gl4xDzY+sew+y4k0vfp42axvN05fAQoolsr7YbhVxGWgK70L/Bu2OfgZ/RSi6UaTPDS2SpDaEhFeSGejbDPPaCs+qVBM5H7UPRfEvt7Er/toJsf/1VK+Uve+0ViYYm1hvqQeygUnNsKmd9AqYP6LjNUlBkzuDbrQecCUF5hejEUsBTzJdUpX13P+1WulrO1H4CjoSOSDI7VBAMQfWCcrQE18y36+TwBSkbYwSJlHpljdaOohhd282u1ViiuA8rKBUQZNwfYDcZxYN/I8Us1LVSAlT0LowjeSdxKTE67xjFRWDCVJuzt8uSyVfGK5QRjVxFZ5Tr3Fo4zsr7bs92twFKf1QnReoQr+Dt/gEMwgp32TTPZyst0t4p8Uzz+R6/yCLQK6BF+HNLE3o8t7oe8T68R+l8Ti4s+FAUTAdlecv7SdZzTrmFotXyxKGvcTmVCyIt+/HJyzDe7Dh0UX5iAZb38c54Yp3YP6bZ6E8loWZt8l7IgFidkdtS32gitsIK1SrzY/6tELrY1RGiYlqIn/yPTzl8ZsL9qGxHrfiaGifnFX5UQNqomq5BM87uEVU6AAPbg1CslzV8d0tssyO4102q19ncOQTitrhePNowvbirjedvgMmU4XfhWi+4+6OPuHRNI9eI6vS4UIy+7Nqp5txjyS/lPfttCs+B4R/aoVrF4bCZGvfbN4P1eQFkndD+EBg7Dfy3qHD77XCH0Be
 2xCGcAYQ
 8yoqaCr8GTVI9ctMOnTWoQuPevbmRiZGlEFmBjBOqWSpkSrN90qwPvrWBukbrkCYpDzLs/GigHwCkiPSt0XFMswxHkQKTRn5cxqF5DV/hdJq+quj9MzNWLIV6MX+XABT+4KcvJ3jr+U35sim60hKRCqfYlDSLOvaUbNHUWTYs9Djia2O40pRVbWDiQqwShz/6uvY/t64Pw62DIfKbhQ6wSlCIV1/qs9wsiXCvAd1vJQUuSc8cEnQYwD8n5kvm15l/BHkQe8/Rrr+kxc9S/gMWsKsStyKr3myVyHFYVC0V9ddLWKS0LUWZz//Eh4aW2CIVEH2hkyvjcH2jtcp4Y+ESVqsanmLBwhVnmlCoTV1yJ0IFGMyHqN05mg0jEwopPuJ1edADwyMpK/2cCowMo2SA54unJLG/NhOWgItZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While reading collapse_scan_pmd, one may be confused on where the deferred
max_ptes_none check is done. Expand on this current comment by explaining
which function the max_ptes_none check is now done.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3c6f1254deca..388045a524a3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1728,7 +1728,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
-	 * scan all pages to populate the bitmap for mTHP collapse.
+	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
+	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
 		ctx.max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
-- 
2.54.0



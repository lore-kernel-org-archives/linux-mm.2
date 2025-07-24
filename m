Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A3DC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 08:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C468E004A; Thu, 24 Jul 2025 04:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A145F6B0248; Thu, 24 Jul 2025 04:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951578E004A; Thu, 24 Jul 2025 04:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82C206B0246
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:01:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34E34130862
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:01:12 +0000 (UTC)
X-FDA: 83698412784.24.67DEDAC
Received: from mailgw02.mediatek.com (mailgw02.mediatek.com [216.200.240.185])
	by imf18.hostedemail.com (Postfix) with ESMTP id 611DD1C000F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:01:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=BcSedB6t;
	dmarc=pass (policy=quarantine) header.from=mediatek.com;
	spf=pass (imf18.hostedemail.com: domain of akash.tyagi@mediatek.com designates 216.200.240.185 as permitted sender) smtp.mailfrom=akash.tyagi@mediatek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753344070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QDGF9T5dTNs+C/JVlj3oE/CVOJhjvBeXRBAQW6usNB8=;
	b=YtMLjpUAcGWyAHp0zzC4tMkTrXl2BcCjpSttGYpC8B1Ua9LG4UMnCq8N/lu1zbHaGv3p+n
	V5tKjUz2dRfKkQ0RI5XjZekhCbRuHf2yof0gkyg+P8e0ZrEFuP+5TC4sPqleuSO4PkS36O
	dfAP5UEZ5nBmyhxOssDYOwYAdSlgRuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753344070; a=rsa-sha256;
	cv=none;
	b=08IZwAZqumVK0CkiNjK5URTUVBQNo1Fa23kKiNoQg40/EdmSyVNlxUkJsT8e1ia+/u1Lll
	NogUOCBvhyR6bnNROpiaPjdziIILW0CUFPCUDC9uJGfP3T+u/pIXEIuFm4HjRBJRajoito
	3EefATu/ZJ+8AUyHvhjDt6FF5RUhqas=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=BcSedB6t;
	dmarc=pass (policy=quarantine) header.from=mediatek.com;
	spf=pass (imf18.hostedemail.com: domain of akash.tyagi@mediatek.com designates 216.200.240.185 as permitted sender) smtp.mailfrom=akash.tyagi@mediatek.com
X-UUID: 575d361a686411f09eb0dd999d3936bf-20250724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=QDGF9T5dTNs+C/JVlj3oE/CVOJhjvBeXRBAQW6usNB8=;
	b=BcSedB6tSKn2tEMmMJiplfjWBmFTmQfxrVosTXKr0KBap5GJJRZzvu0pojphUTFp53ANjPzwIpjF+Ov9BvqqVabpEE7gRROMpVy7Fe7j6VPFoGh90DBNw2Qf4Th9nnOzwZGmEBAKyIz3Srui3jNL6vpfiyOQCTPvd8KNztz7rFs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:3988cce7-0239-4388-9149-f825a87161d4,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:bd32200f-6968-429c-a74d-a1cce2b698bd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 575d361a686411f09eb0dd999d3936bf-20250724
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <akash.tyagi@mediatek.com>)
	(musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1860014632; Thu, 24 Jul 2025 01:01:02 -0700
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 24 Jul 2025 16:00:57 +0800
Received: from mtisdccf01.mediatek.inc (10.18.1.155) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 24 Jul 2025 16:00:55 +0800
From: akash.tyagi <akash.tyagi@mediatek.com>
To: <akpm@linux-foundation.org>, <vbabka@suse.cz>, <matthias.bgg@gmail.com>,
	<angelogioacchino.delregno@collabora.com>
CC: <surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<akash.tyagi@mediatek.com>
Subject: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
Date: Thu, 24 Jul 2025 13:23:01 +0530
Message-ID: <20250724075301.1151817-1-akash.tyagi@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 611DD1C000F
X-Stat-Signature: ysjuu6byujqr8cgwwdt7ezccnnxonq4x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753344069-873656
X-HE-Meta: U2FsdGVkX19NtlSNbMZYbFxeEKQGr1yqXU7J3UNGyfrHCOviS2pWSOz5n5qAtvnHjq1Qu0ROLopqGL4EuuKMZGJsfUpqwHY7FAzLje97MneE4yRP/ESzsgs5RSk5AdpIuXOIAKToYaGVRXNFyN4EgIk30thBWxAl2c/zDTARVjqbUAAQLYSz1OCJT8ycM7jKFnfIBT1rf0tQSg0T26k+fVQc4VVx2uUUCRVawvERTC5VC0jK/rjIqalLrRBk9mg5ZoUkwPb+mcry+CQ4bPhoNBTML979ihJYIFQb5iT7oPbKXcEsvETBQcBBV2bFKeVTEf8arSzgS2GJgzMW8eSgYaLQwrH+gIYVmTaJbBsIzzFfnPZwOwxuwKNB+VTxGhjjTJj7vz/clQBpp+hD4sRKto4ljFKNoWHAiJZQiNcu1UDxXIAyiW/1847B6lKzZqliUc7HH3kQuCfKAfQaAbU4lwe+GX9MgdcBnif+UfMx8HIe+BsthuIPlXboAOTr+hzvlIyOa/M8nLPllF5fozIwIqumu2XFHzOOqOTrh4vmE7/uj/x9NrBXkoxnBBAnQFNDz1tR3jHVaUdPMtOx/NA3hFib3nBhFXOYSsO4JAnKrkoGjJY9E6EJFmZ6UGJrx6atwiz2vnpiBjSVa7MresqzdWxpOuOJhEtWhE9GniY/sPhbpGY8++5mUVPFyaKbKPJ5e+s4XJDZAQ6hhHlvNjZHXcY1ziYEBUG+druPPqNT5g6cj+xGNQb68OTcAlk0MDJtqon2EGf6Kw0roX9GFCz8zlq6U/FzKZSOJQ8sW4n0WNc1PJoaYceOVP8shIa9xkyLdr/udmuxv08Y8H47JVXPyi61SXKJ8GdQA2f1Fn9fst4ZlcV1TufJ0+ZR7QwleS4umHX+dyzcORzAqatWBKEWxq/2Qu00Nyel0myM5YWifPzP7Qf4KmMB48tn9SHwJGlBjVSiTZQdMCK7Lk8oC95
 v5cI1+E8
 LmKvFjmqzRa9//Ur45nk9deGSAPNVfvtBoRedaBGctpKWcAbsc+rgFfWILRMr8P8jUojmXw8km07yAKjZWCUw8/AwQ1BTCk1ajwpiycUryZVK7DjTtNLrvFZ+tN3ug9sYqGyKK9C+GmUsARfxtWLkMcPI5IMehxNmjCsLFh2Y12dOGj3dhZdU9rIvYhkuwt8j0FwPDQ/A/90ImcXLLbCK7E+c0r4qrgYEwROGboeVeoLAO35jPlj5StoJKfFZpXqcer3zX4vDyAfs59KxDsAvHd+LiX/U2anN0Injl2fx5jOtdly7g8KHB3TqRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, THP CMA pages share PCP lists with UNMOVABLE and RECLAIMABLE
pages. This may result in CMA THP pages being allocated from the PCP
list for other migratetypes. When this occurs, these pages may fail to
be isolated, leading to CMA allocation failures when drivers request
them.

This patch introduces a dedicated PCP list for the THP CMA migratetype,
ensuring that CMA THP pages are not mixed with other migratetypes and
remain available for CMA allocations as intended.

Signed-off-by: akash.tyagi <akash.tyagi@mediatek.com>
---
 include/linux/mmzone.h | 10 ++++++++--
 mm/page_alloc.c        |  5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 283913d42d7b..dd93088ce851 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -696,11 +696,17 @@ enum zone_watermarks {
 
 /*
  * One per migratetype for each PAGE_ALLOC_COSTLY_ORDER. Two additional lists
- * are added for THP. One PCP list is used by GPF_MOVABLE, and the other PCP list
- * is used by GFP_UNMOVABLE and GFP_RECLAIMABLE.
+ * are added for THP: one for GFP_MOVABLE, and one for GFP_UNMOVABLE and
+ * GFP_RECLAIMABLE. With CMA enabled, an extra THP PCP list is added for
+ * MIGRATE_CMA, allowing further distinction between MIGRATE_MOVABLE and
+ * MIGRATE_CMA for THP allocations.
  */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_CMA
+#define NR_PCP_THP 3
+#else
 #define NR_PCP_THP 2
+#endif
 #else
 #define NR_PCP_THP 0
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2ef3c07266b3..35f8041afbcc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -519,6 +519,11 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
 		VM_BUG_ON(order != HPAGE_PMD_ORDER);
 
+#ifdef CONFIG_CMA
+		if (migratetype == MIGRATE_CMA)
+			return NR_LOWORDER_PCP_LISTS + 2;
+#endif
+
 		movable = migratetype == MIGRATE_MOVABLE;
 
 		return NR_LOWORDER_PCP_LISTS + movable;
-- 
2.18.0



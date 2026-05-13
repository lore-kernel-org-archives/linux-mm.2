Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9065ECD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0799D6B00D2; Wed, 13 May 2026 09:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0297C6B00D3; Wed, 13 May 2026 09:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E826D6B00D4; Wed, 13 May 2026 09:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D989C6B00D2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A51211C001B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:32 +0000 (UTC)
X-FDA: 84762430704.08.8E416E0
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id C7BA8C0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NksJwfyo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677830; a=rsa-sha256;
	cv=none;
	b=7eEL5FMmZRbT7vSixHkkoa2/G6y57UQzZigMI8LWJM79pUVVMpY5HHV5UrMCljFeq4XTr+
	YQFCtoaRglXH8j45rHvjYYB91pDvl15F+x8lsjb2wmPPBPcFXWd4pvaZ5J1fRP5ilmjr/3
	uIDURF+vATgzimkX84QAs5oJbY6hF74=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NksJwfyo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1XolciG0Jcg/XeXppdFYJHitey8LmRb9A3PbbH2+hw=;
	b=3AWTMg7hrP+SKtKHjHfOK7I2u+yqJvCE3e9Rvm3/9QgtOz2PEV6JdbLwFBGaNNvtsiJZ3Y
	HU0PTQMhZHxX227ATLAUaq6QRVLCr2azuLz5TygG48Zl8m6YB+mpIM0fXi141o7c2CODTE
	3cJFtOtDE/frYJyOwMqPajFhdMBuPWs=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ba856db1c0so45832565ad.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677830; x=1779282630; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1XolciG0Jcg/XeXppdFYJHitey8LmRb9A3PbbH2+hw=;
        b=NksJwfyokzNVSf986N2r088K5eLR1jKyNDH8tJvdsMIU3mT9LFFtHPDtc4xwWens24
         d91RiQjRd3ZZHKdBhi0cGKc8JNAdHnd+yl2xSa6N97c4d+TOUOEgjnRhesbZmWibDtgm
         XzrHyNDqzi408bPjOAdnJI8TXrXVoD2EM1QekcX+BtWeDJC15g1eBvsY4Lz63ufhwT9a
         biRcYwWBLH2iUCLf2ec82+eQ3vqhnA//vm8PoSfHTdixVpDfI30bL1E8dYif/WHnl6nj
         XZ0RxCHUweZkODSAfYJ4hvJUgBfY2Oss6YPrPeE+3juAX8be5PsxhW09uebyIpIohKmg
         qyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677830; x=1779282630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u1XolciG0Jcg/XeXppdFYJHitey8LmRb9A3PbbH2+hw=;
        b=eDmt3NGMd1OX3TvQjfPWzIgS1X+gfVxxL84EJOHVX8DXV7eht+597ra40gUxNN61JQ
         owY2ug0fFird2t641wTrQ+BQo1HN5LFoKLEc2dL93EK5rSDJH6KmwgCbEXhfeI2r1DX2
         02nFD+V6p+krIbMdjeDe94L0artJ5L5PjGu+oHtfwwi5thfAoyZyEbPcifQDAlSGI5IO
         KVy9zQDRuCL5/XOynvP8znUEWj3llmfsP5gk+u0Ps6VTvJLfKTPbD0mNls90Ox2DRgxn
         Fh6artkQeS7sxXq7b3iKX44j9+qEuVIlhGTy8UCJXCLPPjCUCC0CA5M646QkJS3iwaqn
         teQg==
X-Forwarded-Encrypted: i=1; AFNElJ+8/wHaZ5NAXN4e1Bxz78alSRhl/K0IxfJ2fzQGmJvCWm8l0OGwWgITfH3vTOW1q1FBfw8GL/2eNw==@kvack.org
X-Gm-Message-State: AOJu0YzqZssJxvpPgZ8IF4UopJVNYn45HNinsRiwa1+BNnvZQSp/WawH
	JnwS3hxQCRSEam1KI+Xny0yp+Iw+iW1LVZgrl9VgWFIf905NCpuWLPSgSAwSUQiNk0A=
X-Gm-Gg: Acq92OGRp8JDy8lYzyBZzcobWXvfzxeWKgUKMsow/lpOWDknwh1S+QNWmFOAN08CWAs
	jN+7ulDZ4r/el/u6fNc3Zh9PCJKCwDFaWLMEFwnMETaoTKGr7xpsgq0bhXZdPqAuhlR/1wtxVXL
	5/dLw5tyjjArD6LSCxobJVWyUOpslwgfps0WPCaCufQeK4exZrffepgPCHu5+HJd3FAyta55Viw
	Bp6du/RDlzEKmxsmOxr7CWPQILSLZuiSd5JG1tJGgVkgKVEPeZUySvD9k84GIPWpVBfOj2+hRAc
	wK8Hi93ELyMUCpbWBMZ7lhFvfB0PuXRMYCC0Iwv51ax0uelcdAu/wr9MFmubiumA80Tp96/t35F
	ed3YC2f/8xEc2gg8meOTRfBPLvkOXOa6OLYxl+8L8TPzvXV/7mjDC+koLRfLHbzRRCB5qbIk7R1
	I1QbwCGWYWd46MPPxsivcZl5QlaFLzdasqkNKZKEKrIWaKPQMsy3gH4RwYuEU=
X-Received: by 2002:a17:903:17c6:b0:2bc:8f62:990b with SMTP id d9443c01a7336-2bd2773e38fmr35514035ad.41.1778677829549;
        Wed, 13 May 2026 06:10:29 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:29 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 32/69] mm/mm_init: Factor out pfn_to_zone() as a shared helper
Date: Wed, 13 May 2026 21:05:00 +0800
Message-ID: <20260513130542.35604-33-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x9wkp3w3crod7jujcadwj71chq65i5is
X-Rspam-User: 
X-Rspamd-Queue-Id: C7BA8C0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778677830-300786
X-HE-Meta: U2FsdGVkX1+bSzh9s+D2AA/5Yp8cIfv00slQOjer5Koz2OihpLOJIIE4akTZ99d87sj8IKj+01OGOsrH02HjCh3bqX2iZ2JQUM1FoSo8iKlcArhkVxNC7xjjp93k8m86qQNAm7BUsZg5Dj821hxc5I5Gg03GOOAKEj8lxp8NuLX/STiHyl+wmyRrtaxcxIiupmb3Wq/uAovJPzAIouFTHXtBt4/ybqD+N2jazR7EU2tCMLHevijlhrCjysWOxEJiOS3SRaRBcGoBbecZCujY1SFbaSB+tUHgTNKGPuSpsa82XQt4Ln5nfT4lA8ZKdsyDdj62v4DDuY71xiuVf+bGJoY8aGxmK4RrobXoSBaiecVq1SP7GOU8HzFrW45lyBwrwLCTnEBmcG1OstHpj1el3V18OYUKMnp4aduRxFRWiA/DfKvWpHoR6e+DOdvoEjmJw+LITARae+fbrBI25l7bFd+6OnkRWF0MFuCVoT0VxuwYLjx4Eh+fdKWXleDa8H308qXdZ7mC5PlYSY1SDmaLuDhZYhkzCsyw4A0g58912Wy2Z2IgQs1dllwlfhGJ0yp7HTVOWX41fAej5FSCUtvrZIyhIBzoSEQbqhXKiS+g7lPUV0rheXDJew84pansI1NimyBrIsrxxfvR1poljioZJnB2+yinptLc6vze5jW+b1zVhaJ7/KVCjHptiGJtxXi2ErTULUFDKuadsZCVbkHEow+Cu/JXaswX5C0IyxIEhX3ZjeMWJRv5kzQ18gyTP/YmJ1W/8xYTBaLrGx8Eh+2N5KRB0O1sUasGoR7LRYikVyH0wIxfVubmN8i5PoAPiTM5h2bk0AAaoUlol9btLCFm7pH37p0nauWd9yvwt2irLAgW/YLil3KfxoLOa/PqD5x7PwZtVrggAlnK2kOmEbcpCFf9Dg53ZegDS43jQ5rz/CKALx2jeNRJa9I3YL3YrDZF0fmUn8bUh5dhmrCacTP
 hjHG2yBp
 eGgDHLAQoXrHLt5tnQyHNPMOjgKL0E6caO0Jylkmh00FhIPdbYojQ3yxls7T/cpokzIrTzybdK418GlzTME2vLrCZhruua9wvjv7UtnkV/ODDj/D6+pwOMeS1E4ucata6FMmmBvXbU2kyH7RFwi1xRdaUE2dyAay8BJAci+6M5qDjPaPIPYlO0KoG+sDPkUWqGy7sJgW30gQjFpRc6QK16IZUUMTYeesaGEn8fFRKDO4eSdpG7iobw1/b8vbGBMK8BH4h02N3U3FX2xJWWOjtbRexUZ7OpZzjlgnYtfH6N990Wo7CYDVhx0+jtpuqpKDgG/2VYEDaII99NwUdnFjN0QnC4YCfY8Zy7Bi3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pfn_to_zone() in sparse-vmemmap.c duplicates the zone lookup logic in
__init_page_from_nid().

Move it to mm_init.c, declare it in mm/internal.h, and reuse it from
__init_page_from_nid() instead of open-coding the zone walk there.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h       |  1 +
 mm/mm_init.c        | 28 ++++++++++++++++------------
 mm/sparse-vmemmap.c | 14 --------------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index bf30617c78d8..18276cd15622 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1354,6 +1354,7 @@ static inline bool deferred_pages_enabled(void)
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
+struct zone *pfn_to_zone(unsigned long pfn, int nid);
 void init_deferred_page(unsigned long pfn, int nid);
 
 enum mminit_level {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6723c604eefd..35c99e5c215c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -686,25 +686,29 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	}
 }
 
+struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	for (enum zone_type zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
 static void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 {
-	pg_data_t *pgdat;
-	int zid;
-
-	pgdat = NODE_DATA(nid);
-
-	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-
-		if (zone_spans_pfn(zone, pfn))
-			break;
-	}
-	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
+	struct zone *zone = pfn_to_zone(pfn, nid);
 
+	__init_single_page(pfn_to_page(pfn), pfn, zone_idx(zone), nid);
 	if (pageblock_aligned(pfn)) {
 		enum migratetype mt =
 			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b86634903fc0..f1c3b2d0f23c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -138,20 +138,6 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-static struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
-{
-	pg_data_t *pgdat = NODE_DATA(nid);
-
-	for (enum zone_type zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		struct zone *zone = &pgdat->node_zones[zone_type];
-
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
-}
-
 static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone);
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-- 
2.54.0



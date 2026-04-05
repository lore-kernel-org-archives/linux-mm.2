Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8284BF3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4726B00CA; Sun,  5 Apr 2026 08:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB7E6B00CB; Sun,  5 Apr 2026 08:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1DE6B00CC; Sun,  5 Apr 2026 08:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1A2C6B00CA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B01C160A60
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:34 +0000 (UTC)
X-FDA: 84624501108.30.34FA99B
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8D5CC0002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OUsMEkv9;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxlpdrP2oi+I/kPwst+8wcAG9djYXbVqK5QGAlYJoDc=;
	b=oi0hnMFqlLRA4tX++cnunEmeUONAHKvfhRj/1La5vk4GU1ap2ZIerzK9u7iB5JbSSSTnFZ
	2uzKEzyzjQ8miNWz2jpcjVBujf5TZOnmhMx/Ok2ZUZmlAXIfQoeteHHALbAtzEz9aA8e03
	7TujPSZXt0tuc7koxTQTkwwjh1G/gMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393792; a=rsa-sha256;
	cv=none;
	b=NY6sJeZBnb+/+5QpocwmkjCbYo3077TPu5Vt8uWx2MmweWmGQMr3ZYhtHj44qSBPjrxTxH
	SAUAnfP31rULlM2oTcsGC+Kjdp9hjl3M1nyYiPVtq3NibS/8ew/dMAA4BjHMQzSO3thN/+
	W3Vrc1LSCH2YtqX4YswdhSM+XTLD1U0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OUsMEkv9;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-358d80f60ccso1933917a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393792; x=1775998592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cxlpdrP2oi+I/kPwst+8wcAG9djYXbVqK5QGAlYJoDc=;
        b=OUsMEkv9CcnRKlOxa9g2BofXLwyKV0OAL/HPwK4pP0GqNho+cfHLja5hdg7qwrvF8t
         fa3OqZ99ZxNzMtn85zSJOgkb9xO9U1xWxyA0gIzfJ7vTzviiDDfmeTNoos5znV2e4cHQ
         U3PM7ZwXXPlnenoYQdSVqsIaS5SE7zBg1MiKlbpRE35WJftK+sQGJ6mZifw8DrUtJBQK
         LhaWxTmMOeg3+FqmLOsjkzbZs1Q5TZrflQnCn1frQQTw7g+dE5JsTeOf1ha/S+/Ilyxg
         9Kb9DV0pFJa3kOYr1lVO0RqJSbbmm5u9jUlqdfrybaJ9kxnNkETeUHa/ubRqkVoOHC53
         d2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393792; x=1775998592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cxlpdrP2oi+I/kPwst+8wcAG9djYXbVqK5QGAlYJoDc=;
        b=kk2dbYyI7p3uKsm/RiMC9bk2zoGNGEXmn0O7rFXTIVinI1OuiCGr/5w0rDkbQtTPMV
         KT1cVLtDC3pFLSU+R2bQ2aRRkPExPoVfjuf5bjvIF2qM+NjgF3IqMNWXYU5XN0Kb73FU
         HUbZJLR9Txe9VISo2begIrckOfa27ao6c7A+qjfvrl7CGB7LdYda29v9LZWeN3DgQv3U
         MUlGzCE/FOD0epoUpM3df4//2BC1wukRvO0F7ttFLQU3URTMw7C6UJQ9icPOiNeEmtbP
         zTRdKwNeKFxE/XObSBH2k8ui01nP64DTnI1KwMfxWj2zt8fObcOw2HbqlUxUP5PVUByV
         qA8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWvJ91NxHMVUcQEDlWsxU90eAz90CORkDidu7OrwPH08dKYa5eLBx/e3XbjA1eEHBd1Q0mBK/TNhQ==@kvack.org
X-Gm-Message-State: AOJu0YzR63GdVRHnMZ40CapLKH8Rr8pTaIgBO+rU/vLUq8NXpg8oo3yk
	utrPcQXdJtYZvRJx5T8tTvkuMhOcWjvlsEiVfAyB6DKADntcLqSbto1inaFRRquceMA=
X-Gm-Gg: AeBDievgIGdi41wDup1SDg+nAeg/bM1HYKC4W5mZwkkJE80/1mT6fQlePX1NAXYzpCT
	zsvRuB8hS6oQMBBVi+MsQ16eNOtZYI2hn22Mcy72Yic+xHBwoiMuGCGkWnyiNs/ZeZep1Dex/8i
	cxIVbJjk77tGCf5rtZO4aEGtWvH+nN79k+Z1RQC55l8c7PUHpplXd9RtIqQMUv8xkTDoXDKqRzM
	c4u+HUuNLSKiUwHSxkPFGsPc/TkXeGgBGkYOTq95392iBKeczbEwf5nBdoXYLu76rGWBXm/5A7a
	U5VS7EPx9REaBdoiJkRWnBQtfpcH4VwY9UOUDZJlsxPF2PcTWFU5g/Lv9UjVaHAn92pgO7Be5vI
	LSu/xQ94/FfP7H8kYzCIL33W4wAunO2qgUn+OOld/1tJuSWpf27l78Iy7t4TUYCL0y3jQ/Bxnux
	F3ieU9KJdVkaVIFS27cwD0ajQV41rWwsElyLXwwKSuSUM=
X-Received: by 2002:a17:90b:52c7:b0:359:8dfd:64c8 with SMTP id 98e67ed59e1d1-35de69702cdmr7776655a91.24.1775393791575;
        Sun, 05 Apr 2026 05:56:31 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:31 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 29/49] mm: extract pfn_to_zone() helper
Date: Sun,  5 Apr 2026 20:52:20 +0800
Message-Id: <20260405125240.2558577-30-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8D5CC0002
X-Stat-Signature: pw91qpwz1zxt34ohjwohdg61kga8qtzo
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775393792-834133
X-HE-Meta: U2FsdGVkX19W9H5aBC/Ni8RXKBRsLRqilHFus3rCmgmIJcha4eb4AHMb8NeucybDd3INuvXcMTXAYkRe9aut8+oDlSJZpD6HY3+tEs92/WOrjfWqk7Bv0kMeM9dHDd6zPq1zBLDyEYYY7SFecJ+/5235i5qZKZ8ku1c7rPb0xfztomVCyLmhpniqZHfDzE4N+pKvIlAZ8xlQzpQOQVoU/IRWfC5E5UtYRDDhKXeIh2p9gpMqxJ71yOQgoAjPTC/z0kaCBmteOiFtp0VlU9yYVw8VRdwDro07jxiH3Xzgq4lxVbHA9a58AT7LS+69yi8bTk3lhAufD9l6Sye/1hqIOJHz0fBUQuNm4IllMJve68IWyhv5PTdgp/xL5fN1colc6WoBD5qlRmkAyulxiqFpUHhR4FgAsixhujQqTWs89eGODFeD9Zpi+qkjloTU6GXFFOZIBuT+FMi3zeptmoEgPVLysBLwJii5RrFXbN1S52lFlcPIS9twBfWajU2R/XiEoAz8fuJjD8G+cJlYSuR7Dh8Nl5AeYVkLMMbGCiPT0NFVlMnWaVB4aYuD/N/LK759VO9/Ky7/c6crSnSgAvHgm6NBA3hbaPzo31uOohjFLdQYfoRLC6qH6vefiuo5pDpth1AYh5Un5ypbaJRkz8GLt0xJ2XAQPoqy5JyuhJIxkNDu9R3nu/g3uKAhi8RZ48WEYLAP/dt9WHUaa3JpYMiNH5z4I29ARrqg9cb97fqKRiZLmaR1V+sxa2gdIHMujFSIkPINJ+8WJeB3xCGWWS5fXn6IE18HUKdXq61M53cYBjvXkJXUEUEZ00uupqhZ15jUFA9BnF4yESawMNHC3OD6WDCgONMrNKoi7jz1i//Sbs3ZOKQlaFdCGPSkHfkyr7An0AK45kaQCoz4kTgjj18B65Zd0rSFnQfwxfVEdNk1ZUpHLyQixc0sepC2xcel+Qe2/6QoUU2O5XeUSO9X/25
 GBygDN0H
 991dO3QZiEleUlB6FIBASp3/pr0MsUV9AIkDtsMc7temqdYbUG4tgHsXW6WvnX7HsnkOeTNb1jmOy6On1Bc525amMY1SiMzcuIjs+O1nq1FfBtiKw8BxwpXxAn3E1ILUz57dk2Itlbz2IYqtygGaCIyV464njnPequyLZ3A1dgCG1nENF0pTQxk563rQnEqoSFhUMJ0pf+04VaDypmPPCQa5nq2zGEdqCmetNnCAzS5LIpdrM3QSBfQbN3gRVwzfyDj60dLpKGDwv8fskZxZaKHUJczTxgl9e94O9ncoJkK9a98nhUORDrewGarBawGuqeLMHeBqPUUf9NWbFoAVDBWeIx++hQsunwcl8Z2C43oC3vptmcu+QIimFjHYWV7rLeccRmv70cnlTnco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract pfn_to_zone() from sparse-vmemmap.c to mm_init.c and use it
in __init_page_from_nid(). This removes duplicated code for finding
the zone for a given PFN.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h       |  1 +
 mm/mm_init.c        | 28 ++++++++++++++++------------
 mm/sparse-vmemmap.c | 14 --------------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 27c06250d6b8..b569d8309f4d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1350,6 +1350,7 @@ static inline bool deferred_pages_enabled(void)
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
+struct zone *pfn_to_zone(unsigned long pfn, int nid);
 void init_deferred_page(unsigned long pfn, int nid);
 
 enum mminit_level {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index b47f65425bc1..e47d08b63154 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -687,24 +687,28 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
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
+	__init_single_page(pfn_to_page(pfn), pfn,
+			   zone_idx(pfn_to_zone(pfn, nid)), nid);
 
 	if (pageblock_aligned(pfn))
 		init_pageblock_migratetype(pfn_to_page(pfn), MIGRATE_MOVABLE,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index d266bcf45b5c..9da49b0d03f0 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -143,20 +143,6 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
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
2.20.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83FB0C55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD906B00AE; Mon,  3 Aug 2026 23:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E346B00B0; Mon,  3 Aug 2026 23:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B6D6B00B1; Mon,  3 Aug 2026 23:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4606B00AE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB92716089F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:39 +0000 (UTC)
X-FDA: 85062225318.11.78B3B6F
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 284C6140003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fUsc1bCA;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815798;
	b=7eofKaZ+4da6v/mnroCSLxcCwN0yTNYsfuWSuPJPgOck3Aq7mDrmyxv6C5JuZy5CdKQUjk
	wnBEkRCfEyrzufwBxR8lHpv+oKUPmanzPZxXIcqeTZyBEkWvXbfZR6ZhbXuR8m7y1gbSFw
	SCCjYvS4db0tFRnMUX9ewqttJgVUIis=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fUsc1bCA;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kX0jaK+msJLtgVaqNEWt9m21jyQQ3JvP88rAHTiy+Ko=;
	b=Ukqid6tcZv0iT6IG7lnWx126ASZPZSUX0hfQci58pv4Fu4210vKeJALwjQCXwoapskEbod
	jDwdEAGairLkozOedOLgDVa2kSaNDIXqh1ICs4qFhud0FkkDUsHcazFTPcmZu1ZoshTnYr
	qtGPu3WKcDrOwiAZf53LYm7i00mHYYY=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cedda2ce6fso34381915ad.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815797; x=1786420597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kX0jaK+msJLtgVaqNEWt9m21jyQQ3JvP88rAHTiy+Ko=;
        b=fUsc1bCAHjxYp49JFKoa2yvbJsd01e9x1zABMXbUnHI+eldyJLkmUCAZhpECRQn/YY
         0gGE5Mwor6SbDN08bDiyUF1KxPMOae+llEVUNiAsBZxeCHPYKHlww5zwMWM0gxuHa4MF
         GXNSlZnLJo943xzbWbMgFsZAiGQZlxvgBBrPOiMzSzQ99vpbLoFMB2fBIpMhL5142mqq
         eZGypWnCUinK4GjVlS7KkLCMg7ELc1JuAqbDSCHYxF3DWXyK4rBk1xgRwRe+F3wcj/Yu
         tiTAEgdjDUfdnQ6DdAX3BcdPAVVjKlkpnlFb2i2zCxEgrxAqJbSxqdqsNhDwpv0S30kD
         S86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815797; x=1786420597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kX0jaK+msJLtgVaqNEWt9m21jyQQ3JvP88rAHTiy+Ko=;
        b=q0YkHhmS9vysvgqlTAGtCmISU8HohZRc7CpihFkKbaU0ya/2nz1jUOJ3nG0T5U4EOS
         Mii8XK+466fT99ZZrPNVXjulF+97RkCPtvZKTcwzyuaSDRXKBX59zjbszB7a2kVHdJdZ
         T6S0qBbaNCSl38fPP2iFl0UUkV++laPDOO/wWbxr6d1NZnd/RZJcuL8sFlyMzBK5Z+1V
         17whG2BjYWtrK0fPz2/N03XdVCrbiM1Recwc2eBA1tD4/nfjKL+OInxTiJCRxGezg0U9
         QY5SSa77Pb4DcOwpvNdNw3wqbAzaP6wxDbuvRvDVdNPq+x7Lmjj2NfptX9dIvLqyYOk6
         fOuQ==
X-Forwarded-Encrypted: i=1; AHgh+RqmNdBP+BLH8gAmj3bHNYrIWZomTuJZnQo0QFMm8xvoJdf0DZ10/NWC695i8bpWE03kg6Nd5fUCTg==@kvack.org
X-Gm-Message-State: AOJu0Yzpfal4lqkTMVyLMF4gI3Zv2N3JYoGqJsJPLzkFBQN8Oe5CC/pw
	7wyqJwJra18exHGSkM0U2AJTE+QklBAueGcyi83cNx5bw3r0OgHAsp2riy4JBSlFsQfaR0JXryF
	f+Nt82oqPHA==
X-Gm-Gg: AR+sD11XFkYz6XCA5tJVTmnrFmZkamClmhtZFvxMtkZH6m/9J9ual0mPFH0KpUPXByk
	5z+HTzQaaRaNJqCufBAUXC0eK5XjaQ7jUBzfZpk+LmVfP3EFcm7xqDe7csIBb20bemvPl1xa0Cs
	ldVJLbGMkTeNLHTjte59X8D19pPZ93+tqabBHzbGpoYalSxRU0P3tim0Lkd53QjXXsMVXF+YvTk
	GIkuvj40nzGmNy9zc8xHdTVFw43J+y3KDNJpMELtH5E6YBGwtoHJUEc0kx4N8LZmDG2cLcCz0Hr
	NaRF/ETJJl9VIcxB5JhJMeRBe8Ub97jOwaTuszO9tm1lTCMB102gFTwXFSH3kXqoawPDhiKbwHp
	/o6j1ZknB6OLl6dTX36ZG6d32KpMOljue56L5w05jbtFCdrOhMptCftFT9zxmRWHHyNeD2mjQVV
	eLpMyfg7PQ0/C+L00S9ux8Coh9dibErwJP1ap1M17VqPWQrPODnk19eY8xVetdlLkEsaXy+6bqj
	LI2gVTM
X-Received: by 2002:a17:903:1108:b0:2cf:9f0b:b562 with SMTP id d9443c01a7336-2d05242bbb5mr121614555ad.22.1785815796949;
        Mon, 03 Aug 2026 20:56:36 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:36 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 12/17] mm/sparse: inline usemap allocation into sparse_init_nid()
Date: Tue,  4 Aug 2026 11:55:30 +0800
Message-ID: <20260804035535.2846016-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 284C6140003
X-Stat-Signature: 5x5jchmz4ofkyfkt5p7jzx6my8uq5nc3
X-Rspam-User: 
X-HE-Tag: 1785815798-700594
X-HE-Meta: U2FsdGVkX19rlMbirr3ojA3LQ/N4h6jVyvMN2O6u6idpYxaO4FoVOBPmg4RtuSkSjiyRB4tWOS77wIB+fB5e5Qbth+CXLEsmIafzWRbusS4LDAZZolOhNSh97VfaU7fy4AiiMw0olaSozyZesHojpi+UabEy/KgeESjaKnu3bOoy8kO6FzBuMugBHeCSIzaW0wQ1clu3eUfkmJOIB9Bkr2onFWfXgnKfQEaUoGDx06nHMM57IqICMnO0NAOiuJMnPu1Dy2/d4DtBr+CBxcr1tT+Ik8ixBThd7LUUD2LpW1KVjC0Y+EesuswZZntva2/l7gJFNCE0eh2EF65RT8bXgCVFhCzmTA/rW/wo1LCaN+2X5NPkcjgC678gpgbDN5DRVGTTu2ziYeJ3pkGROu8oQ7gLDFxsxQ4jR79A5mmIAsmqyUeqtKUYetO/eqDiLkQYNPuM5wcxKc5IwKm37YgQHIT/7DI+Ya+1rk1tgmgo0Xx0SfH03qKvw2vQkgOxEet1/74bYPd73bOSKP6MoQU76pLelsj5XQe11IlTMPjkHWllWe9qJy+JBsRNOs1QqcN0shKnjXnsXLbHjvMQ3Vo3eVJY/2lde+1F0nXWXQdGKAxWHdTItF3S8hu5ByPgfjV4Cw/a/GoXobSi20n9Bd/YSkKWlWfubssV0IulNQWNjMNhDzuNK1iNRmdRw8ieAYO9O+G1CImbJYbpoDCifyfDDyH6PmBxN2vVWCJofrYB/knIjA3m3qLx5efgpdKasAJF2iAxDEG8Qj+Bzsx65O+lyBS9yISvhmKaIckUE8YkFU+FPaV6bZqw/IL0aGpbU5/oxF4OM0KW/RSX7f+g2s9i/PJfDE04PNySkSbdPUGI034lMexJr9Bayf2aijcmn6gxP3WQMS+eIV5V6Y1KWSz/fw5FtHw5AmjqGS+KG5xeTvDrcnAQlk2XFb9OU8UNYUD3Xv3bfccN7T7nDxAs49Q
 j46RPh39
 b1ogsLfJBtWVR9yDLvG6tMVJIdl8nRxNQiM1YhwQCDExxAU2br0bAIIAhB1ePJe9aTuneXS/BL167ow+xWTKS4RJtzniI+fpV1G1ITtGKMsqeF8aRi5VZI6BrdMaT8BKrcaTK/E0grTnXoJltiLmfaqTXj9MkwLKs8hcZIniHbW5scFATMwRhet0w01Avi0vwzcyOOqfUtY7r2ZhKz/cVCoJF6owYKG+6TiF1p1vsjBSqrQUBuLTq+t2KC5qaX2lT7WmtZDfrAINUnooTDJYZLDh85OU8eegqtT7F/XVK7/Iz3jks0/+nBuDnG3teNezMJvqrTgwYNd4uFdV3yixKfOg6hNXWaYx7yr9PVplmEZHrrel2ETePiZ41RWaeUMLWCo2QK5EF5Xs6i4pwKwHfUpkUQub72s1DOBSIlBHoJbDzhPGolQw6Dfx+IwmqgnPonZQOQQGJsrfVK2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing SPARSEMEM_VMEMMAP_PREINIT, sparse_init_nid() no longer
needs the transient sparse_usagebuf state and its helper wrappers.

Allocate the usemap buffer directly in sparse_init_nid(), pass it to
sparse_init_one_section(), and drop sparse_usage_init(),
sparse_usage_fini(), and sparse_init_early_section().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mmzone.h |  3 ---
 mm/sparse.c            | 46 +++++++-----------------------------------
 2 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index db019fea5152..bcf536ec46af 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2225,9 +2225,6 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 }
 #endif
 
-void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-			       unsigned long flags);
-
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 /**
  * pfn_valid - check if there is a valid memory map entry for a PFN
diff --git a/mm/sparse.c b/mm/sparse.c
index f0d9b7263bb2..743112ac84b1 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -245,42 +245,6 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-static void *sparse_usagebuf __meminitdata;
-static void *sparse_usagebuf_end __meminitdata;
-
-/*
- * Helper function that is used for generic section initialization, and
- * can also be used by any hooks added above.
- */
-void __init sparse_init_early_section(int nid, struct page *map,
-				      unsigned long pnum, unsigned long flags)
-{
-	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
-			sparse_usagebuf, SECTION_IS_EARLY | flags);
-	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
-}
-
-static int __init sparse_usage_init(int nid, unsigned long map_count)
-{
-	unsigned long size;
-
-	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
-	if (!sparse_usagebuf) {
-		sparse_usagebuf_end = NULL;
-		return -ENOMEM;
-	}
-
-	sparse_usagebuf_end = sparse_usagebuf + size;
-	return 0;
-}
-
-static void __init sparse_usage_fini(void)
-{
-	sparse_usagebuf = sparse_usagebuf_end = NULL;
-}
-
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
@@ -290,8 +254,11 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
+	struct mem_section_usage *usage;
 
-	if (sparse_usage_init(nid, map_count))
+	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+				    SMP_CACHE_BYTES, nid);
+	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -307,9 +274,10 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			panic("Failed to allocate memmap for section %lu\n", pnum);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
-		sparse_init_early_section(nid, map, pnum, 0);
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
+					SECTION_IS_EARLY);
+		usage = (void *)usage + mem_section_usage_size();
 	}
-	sparse_usage_fini();
 }
 
 /*
-- 
2.54.0



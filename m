Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C187C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6066B00AE; Thu, 10 Sep 2026 02:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FFC6B00AF; Thu, 10 Sep 2026 02:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA9F6B00B0; Thu, 10 Sep 2026 02:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E766D6B00AE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A6C84042E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:21 +0000 (UTC)
X-FDA: 85196888322.21.9C3CFF8
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id BA1CAA0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WA4Y+PQE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPTybuwUCG6mUc8qxpUjNdpd18RIivFekac/tDH8nBI=;
	b=TuidwGLak4CgYDqyMmyl1ZIbPgaN6b3i4krBWj41Oj4+P/b66Rz4UhzIMak2xf0s1BtI96
	EV+cEWIMLslmDnHq/oX8gKFKJjHz8q+njM+rjBl+WIUsZkTcw1zrH7Be60k5IkbNfP/n40
	MeioL3FIL10Q4+pY0mP7lCLkUGdXqWA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022059;
	b=tapU4AFco+1PrwikXXLRjYteoX+OZP784TEErlpj++B75cOMHPZN8cV0OfSIMBYyFn9J9W
	bVjQlM2vI0TeUm1Ua8pqW27/F42plOtMV8mIO179MQhWk7pqX9V3e0+eF3HAfA9+rTXOJW
	KFp7lAIugwEzynXLY14KnuJocca0a/o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WA4Y+PQE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb750so1848199a91.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022059; x=1789626859; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mPTybuwUCG6mUc8qxpUjNdpd18RIivFekac/tDH8nBI=;
        b=WA4Y+PQEkPWI1yFIj8JBSBnM0I7ty1s9OXAd+pFXdwU2WmsrSyNhADs6YChYpDoRsU
         izX7JVN9iL6qP3uUNMxRei0x9O2tLWQwBi2bWRQjKe76uHuKdD29mXUGdTrM3jkT0yBE
         FtsQiaYIdbgwMur+Ht2u2h6tInNLbAsg5WaoO5SwQNUufaIwUFvT8+NZlN2LGfdgS84L
         SebA/0KFxjnskGR5u639xFda7khOhSU+FZP4gI8nBG1h6PQPQbEcwslWW02tWuiIQukv
         rNkWkrUxGL8GLIwwd5BNtybFrp2wTmQzBbbFia4isq/lD9yPvvp7KCXLZhSOxu7kAlRq
         tskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022059; x=1789626859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mPTybuwUCG6mUc8qxpUjNdpd18RIivFekac/tDH8nBI=;
        b=XUpektYgxyikAwJVVui17ST9A7eymmac3bXWXc50Kzt5IdxvDvpCHqAnV4hM/dG452
         9vbz+BfLTH9GMHuqaH/3vNCzZ8aCe2TZivyCx1p3yQf3aU/PD9VteVR+a3kQ99ZorMlr
         o67WOj1JbUuF3FeK4yqMUY+4LXnF6106D/hqRVZGKf+O0izhpJuY44svyESnAFL1hWgb
         vZpXayz016obYzEQ2QASBuc9ZtvW+W06ua25NoPe8E9MnqgksymdP0GFOqMwysOqVK83
         tNHtXhx6ZivB+vkEPLg7sN4FmsWIhDpySVEjm5h7K+NX8gAktoroR1GinFldjVcFHMKt
         ba9w==
X-Forwarded-Encrypted: i=1; AKwUvBy+KHXjdGI38KtRg3ijKq0om4q6upeND4HiImuHqv+1Giu+msTy9A7gcu7gr+z/ObkbMGAZAcwyXw==@kvack.org
X-Gm-Message-State: AFuF++lw3/vXqL7V3WM2pS2IWjFc6YFeY5mmnxF1sEGx0kNW3onC1TRY
	Pnnai6bcpN4g27UbpeiK+oU6ehyvdvsbStdvlBZeQbCmtVQzOiONb63eUl+to/6hnC8=
X-Gm-Gg: AYBFou3vAkqptRZRC/S1VTIYxi6DOn2LHvqCMOF+xrwfy3JCsBc6dsvssImNXpgGHJV
	ccRhbIf6FVs2IBq00gzFNYhSWAB1GQ8ZRF7jxydyEmxq/VKmWgpxW1paScv69tx/TKTp6Ng9k2Z
	r703Bpb8/40Phb1g5Ik13zYBLZj/WIHkyyxJFU8xcU3c6Vq9/tSHUnnG5o3TdPSAL39bsd9QAee
	IdE5xMQthKd5guYpMXryHrg5OTseRKd+boLsm0cpcjiyXtnlncqxtgDaYnu/dYc6qZg6T+5HhWj
	INdE1KGGFdB7TiGFBsDDLNT74vEgy+s2ryHAMssLpMjYmEaAIrC6ZgD7JpIBLnONSF24/y7uW9k
	1DfYRjIjkj0x0JRBkspw9oMqwyDYTCExungAuyiVWyKHx+V2L/oN+2elQTyCtMnt94XT4II5Vuu
	pbGtAJzfHtRoG2I30LUcWQvzmb8+SE8IOsL4+U7P4fAjuGdKPXwqyQc65dPX+BTsbm3KonJSefg
	nqA2uz557QHU5G8Kz+cagHaDn7eW4IdsGHLPE3OYRCCXg==
X-Received: by 2002:a17:90b:1d45:b0:38f:2168:b9cb with SMTP id 98e67ed59e1d1-39bac1d89b4mr15210275a91.9.1789022058554;
        Wed, 09 Sep 2026 23:34:18 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.34.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:34:18 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 14/17] mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Thu, 10 Sep 2026 14:32:53 +0800
Message-ID: <20260910063256.64386-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA1CAA0007
X-Stat-Signature: ddtw59ng46kzaotnxxdmkqqthr1938ze
X-HE-Tag: 1789022059-677980
X-HE-Meta: U2FsdGVkX1+qXdQQHRyw25CmSOIxRSMTAz5fPGsljBz2L+106QCQef+xTOX5r+ubJrM5HtlbhJJViLyuE833yw/zklqdJTr8YSDU7MDdgnX4ynwedQ/BCHdZWwxz4kARvUN2RsjwJojJD8djqESFYCm73w6vjWH2FOmbM+OcI5bCaR4I0MwCxdqvnL4tGPO15Gy3dxm31UnFDVcWFbKVV45k1z4TLKDtaUMPhVh8f5B3Vkd0MiAIEJypwghzpEGTJlN2cxCnjcsXKZmpVALR5ZO+D0nl/xG1QaCSOobiUOy6jOMJGKb9ww7MjgisL9sTC5oymKm0Ds9BdLYC7YmickQUBYSrgT4d11CeZsPi8jXxFwwenkSHxz0OQEHjqPaQVwllo91jR6pY/qu30Vd/xPw+sw6NdvURS7r93fu6EmEwTT89q+4kkuK5/ZGEAShMoQNf5dQU9xkY/3/DkyD5kZCV+tFGEHkXKHB0pYWs/txQZEHX/PxJWENXq/+nb+miOQghiZGuFVaZnuYAmAbqqclYIQfr+M3/9syVeT4EZrR6R1R0vzIpA0179F1fdFG5mS5UCOI9bIaeNv0TZK5WCmT4tMd+ZkQg5+MCialhGZEVuFz10rbeeu5ItV/7tMmBo5SGsxV0/Cnbig+Lu4ePvh8P4ybK0JY1Mlv9OCd3xa36c9H9k651/LR4g4PiJcZZkgzrpywgE3vMr3k9dOkcg7gIbtMYiKUW74+9qdyNG+pAxvz/mZ6yj941aooaNkFg6z/C5HlmFYdDZouypzshKnOgNFNMore6BGFeOHisk4U4omPqKTehWCGieQxPw3oSj+f9lTjztwzFmlK0jknr2h6TNGLXDz6rQfIz7RRqXF2uTIW8Ws6sj5j3HJpQGZkcV/ObLOCgTKzq52LQt46Z+ftEQun/nrtg/8ly5VBSEQivMTBUDKD22J/N2S2ze11wTBekfb8kuoRUR7G5hxU
 oP96Wgcn
 p2U8nhP6NvDgVl88kfJDlwFPi5tp8c6EoZ1w+VLz9joTi0yZMG5eWGTDZ5YczrEuWN31QZuPEuJpLzJ1HVb0mx47FHd/hTz/z2Q15dKvnVGiMFPhG0m3TpH9nkRHsX53KfflGJMQ7ezHyB4DK+az0rAPuw+KnBvlIhky42z+o2Z0nm7lvdCcpTcDJ/dCQLWvgB3t3EXAqXp8BkkJZ89zJnuQpu7IjZjYbcQRn6gKjFJKL9vnL6KHJaGj+xsSrWhDjy2+nyE80OWWaOFvm7PQQNhL6FbBfm/rSUqwWr+s10+wvvBPTSBi7bWJFCUi6yASPrp4G6143QtMkp7ebgYjGKFSqMqzYM0kgPNrT+6WMVm17JOw3shS14XgPBAIjYVYogscTFfOWRoeKaPSQ6iaN5kdVP6uPWcvai4syVTrp7S0Omq0HQclEgqz6NFKRYxN+FbzjFAjknecgLH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had
already gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the compound page order stored in section metadata.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state
directly when deciding whether to mark a folio as vmemmap-optimized.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Use the compound page order helper names
  (suggested by David Hildenbrand)
- Collect Acked-by from Qi Zheng

v3:
- Use the order-based helper for the bootmem vmemmap-optimized check

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  5 ++---
 mm/hugetlb.c            | 16 +++-------------
 mm/hugetlb_vmemmap.c    |  2 --
 3 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fe28f98e1b22..3559041a5a57 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,9 +675,8 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ee5567fcdbe9..fbc2ecafef9e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3220,11 +3220,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
 {
 	return m->flags & HUGE_BOOTMEM_CMA;
@@ -3299,6 +3294,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
+		const unsigned long pfn = folio_pfn(folio);
 
 		h = m->hstate;
 		/*
@@ -3316,15 +3312,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			folio_set_hugetlb_vmemmap_optimized(folio);
-		section_set_compound_order_range(folio_pfn(folio),
-						 folio_nr_pages(folio), 0);
+		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d1b031dcd177..fba0c5a7d46f 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -715,8 +715,6 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 
 	section_set_compound_order_range(pfn, pages_per_huge_page(h),
 					 huge_page_order(h));
-	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
-- 
2.54.0



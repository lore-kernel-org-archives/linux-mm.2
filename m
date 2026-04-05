Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DEBEEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE4A6B00CD; Sun,  5 Apr 2026 08:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5F86B00CE; Sun,  5 Apr 2026 08:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03036B00CF; Sun,  5 Apr 2026 08:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A54856B00CD
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D2B1BC926
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:47 +0000 (UTC)
X-FDA: 84624501654.05.335DA68
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD31FA0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TCDK0xrx;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Tl0DYENAt+V70Fu8vSLfAcsd763D1dzR7HZC3FaIa4=;
	b=BTd3CkGBSfHXOWmp3eQvVvruYGlh1Y71pHUtciCTxWmD9U6Jw8t+eFcoPMy3sExpJ3inYb
	Y5Lc5GIn/YdHMmHjjKLmzHkZilAkLBatYZSWiBUT3q8NFECidgPY0RKbeJ3XelyoUWCY78
	vpHgHUc50cKob3vZqO64e6l79oNlUxA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393805; a=rsa-sha256;
	cv=none;
	b=5W+moLqnjQ2h7xjK2MqUrOYV8hZGlNCFGIBtAqj3E5OkJxMapoKXap9El0qeLHhJ4Fuzp1
	KBSjhj6hVWy++VywfgQeL2PfGsn9UlOEBzXmV3viW8/fiERlzYC3K27ogc8ey50v09yU79
	eAWw+qsVnIobKle0d716hY86TpJjyKE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TCDK0xrx;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35d9827661bso1534886a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393804; x=1775998604; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Tl0DYENAt+V70Fu8vSLfAcsd763D1dzR7HZC3FaIa4=;
        b=TCDK0xrx1mzINWNpaX00b+tUw7L/iE5EVFOZoaBQJDwOhLUZ6/BqWts1mfXVSRNBvx
         P6TwtuMmd48dZZhFCFM6nyQVhAj31EWRhMw6lB8fSxME9sqrEid8Hg+hTxtL1g2TR1Wi
         5ujWoQL6eDpxcb2uHmAzU8dXjbhZv/gA+3mQSyQpiUsWuWFPezR/zt93ExbgUFau0Mev
         HxEFsLPRSMLVpoTGep2NrcBtyKvAyV0FdgFKuPh1BI6igcXPa7fnOQqShzOjljjEs2i/
         Vfxop4qO3mCITfHls4tgxognV6tw9fu4iTW5GGahYwKTsByMKxgkoB7RMqenM2PAs/mQ
         kLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393804; x=1775998604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Tl0DYENAt+V70Fu8vSLfAcsd763D1dzR7HZC3FaIa4=;
        b=Hd2+c6kPQ36ryaA4bTFQVAV25bZcVuVPacLGoB8rtiyu0sRye+j8m/O6nSKaqrmvp1
         yMfkac99zOalnbLAOGngm0Ql5rb/muWijtMfGaZZadvM2Kf7F6JraOq7F8AUg1HncC5R
         wXsoBgJjUaCZknUKJe1tVvOD2ss3TkX0Dy4OrZzb6nQayhU3SBqsJvaJRZAaelkqiJon
         /fSaAZZVUePQGBmrV83nf1VwguikxQPFbLMXajqFDumeuMwXNCzT+quT0tach7AW6UML
         myk5V86w/5IzSJ+ykp6zqVY6TVTCzqmCWS6CyhFLNhu7+wusyS3CumG/UmzdEKYYVBZ8
         D1yQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3AqT+1pb4B4JG3K9SQnCIB4eznXezQvN7XqLXKYtgKFpmnAJqYOKf5b+Bn8uRpqk69YVdc5TaIg==@kvack.org
X-Gm-Message-State: AOJu0Yxs+toRMJnLYI1twWZuOuTHSqsMj0nejd9zjd8trkHx7fmklOl0
	ezrqu/bdKeS3pPqZNcYbx+b0fSCslyCzZ7P24ZXBubLrYN+PK3KkKWbi/1fVtoji8MI=
X-Gm-Gg: AeBDievmMboRaY+k7ICdgSTEZGm4uzCXDiwRVdoB9hlhMTo9ndU3nu8CFvW1drMKGwa
	a0kMQiD8y3zE0He5352UZGO/b18vF6+Tpc8r+wu+IcckzN9GhECoMUax6IORBaHg/34yHW8flYx
	OPa6lL5KnBrxu3nBG62Gy7fgNIl3aAZ1AnSzuCjF+xZ7SmTfSMsHKgVco/lhh5/M7NMvzoiwu4u
	RQZbAbSybTPvklGvkc9RYcnljjhhrGppUj5vz02PXX/qDZSBMhFV0lDToyJDs47hLgBZZ+6NdbH
	5CPzVhVZaCCtg8SrEW7cuRTTpVkKmWrVPWK9Z7YG3H/fprh6+xNNwuIdCBsMGuLWEsOgmZQzEoO
	Ks4zFYC3ZInQSsIMkhwk3qagSYFYDCsEeqqWNyglFsxvJBKbFE5OPs11Ks1QG9OJYUWnVzwbDKX
	eQwWsgxEvPvHfVEr++2FwfP+zLv9Qfv4pGKsn3ErhwLz4=
X-Received: by 2002:a17:90b:1cd0:b0:35c:812:612a with SMTP id 98e67ed59e1d1-35de69cece4mr8333640a91.29.1775393804441;
        Sun, 05 Apr 2026 05:56:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:44 -0700 (PDT)
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
Subject: [PATCH 31/49] mm/hugetlb: remove HUGE_BOOTMEM_HVO flag and simplify pre-HVO logic
Date: Sun,  5 Apr 2026 20:52:22 +0800
Message-Id: <20260405125240.2558577-32-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD31FA0005
X-Stat-Signature: 97sjhm9ig99zqnxsczy8kbdb7zd9qmnf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775393805-334652
X-HE-Meta: U2FsdGVkX1/dvdNqKSx9meOO8rFeSWqD/yjH/gux+Jnbbh8kTo3PbYc5H5SZdyCiDS0V+rFMi/LSQER7+Is9Lrltq9S+6eazqCn8MOLTjPRtTF1VtOliUjWQ+4mgTrv9FJRIzL/zqtUYWwe8fwYNsbKx2cXnyW+Ga5xsnxhjt1+SGB9JRhN8JInSjLi1AzcxwcT5yq1JVvkj23bFX1TWWFtlsef/v65dqFg4OpVmOV2aF2TMpHw7gQ1oSDW6ptctK1OVZosQB/X+z5ZG1rrw685UmSq5o3Anbp0fmjzGWyicF6fZBADQef6OGzWi6Z7bL+HONuBwH8cT9zY9o+rd8MEYZ5mtz1ylkD/McTPEY7fGl0Y9WBGDhM1qjjOjd1L1g0FP4/XahTHgQnutouglkBDZduWY6pz8rPHyweOi1rPQUkSbISG57GBOaqScwyHk1yUIQUJFzEhtqeE3g8ipgiolZgEq0PT0BJUNYKA8lKIeryTzasD9KpqsdGxw71ZHtxX4BWLqNVcDwEeMw7fiKonUed4MasO8tlTs+kgkvyTvWh/mo/EiKePJMaH/4F7MW02BLpbug9wuiIByWgqHSktuIRRdf6gjcZwcyK43d6qdgSYMKwwspKyx10fEj9/R0OKjcyYfjiFx0xk7EIMrhR022enD1UICl9bnLPXJ0ICXLwl8GU8Ju5+zRgqO3+FYUFoxHfa3aN3tK1JkfRc1y9mU9xr42zUVgsrX+iQuNamh2GRCqMCCORDz9pj3fP9AQWTlnL6rqbDuewHwSA4g1v936iouYLECrm7qt1m7YsodbHFssaVnvNK5NW7cShw1zc4k2xI1a5oFFmY1DOVbJICgtm+pFBBryUxxE9VoEIPtewcHhjhLesRk+N7Kn+w5mMynq2o7Nvder6Sr4s+luc/02wSHVllobUJu8Rr/o2FGpg9HGLh52eECc3j7a2Q+53tqf5EQxwO7ijaxFUh
 b4eHO1vi
 gLM3RsLxI9MHD7jONsoFiuVFKm7GKrUfrGoY/Jbb6f+efxlT1GxEOeRJnW68ONxZPs/rJc9QJUI9mmjjob4rUtlzPKsOIyatzy3bbyqah85WgJg/rFiKn+7/mNDytn0oMrK78KOQCcMhKtnJs51xhz3VQ+dwQ2mUPTJ7x2kCM+FdEov8W0w79WSJs7xGcmNJLn7tIfiWnA+7/utwye2ZP8DVtvPRM6SWGLBP9vs1eay1rEn3c1yAhkdVenrl0hR7DCp+B5Nl0M2F7dorwFr5S6hIP+cqR617QKsBvGbDInXfx5ztXA+tWlObKxpXyXxpZNxOBJDiJWdWgnYKGztqRBCCddDbggUOeTfKsEtlRNSXd3HI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pre-HVO feature is used to optimize the vmemmap pages of HugeTLB
bootmem pages. Previously, the HUGE_BOOTMEM_HVO flag was used to
indicate whether a bootmem page has been pre-optimized.

However, we can directly determine if a huge page is pre-optimized by
checking its section's optimization status using
section_vmemmap_optimizable(). The pre-initialization mechanism of
vmemmap has been completely removed in previous patches, making the
HUGE_BOOTMEM_HVO flag and its related checks redundant.

By directly using section_vmemmap_optimizable(), we can safely remove
the HUGE_BOOTMEM_HVO flag, clean up the associated state maintenance in
struct huge_bootmem_page, and simplify the bootmem page optimization
checks in the hugetlb initialization path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |  5 ++---
 mm/hugetlb.c            | 16 ++--------------
 mm/hugetlb_vmemmap.c    |  5 -----
 3 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 23d95ed6121f..6bedeaee9b79 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -695,9 +695,8 @@ struct huge_bootmem_page {
 	struct cma *cma;
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dff94ab7040a..59728e942384 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3193,11 +3193,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3284,16 +3279,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m)) {
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (section_vmemmap_optimizable(__pfn_to_section(folio_pfn(folio))))
 			folio_set_hugetlb_vmemmap_optimized(folio);
-			section_set_order_pfn_range(folio_pfn(folio),
-						    pages_per_huge_page(h), 0);
-		}
+		section_set_order_pfn_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
 		if (hugetlb_bootmem_page_earlycma(m))
 			folio_set_hugetlb_cma(folio);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 8c567b8c67cc..a190b9b94346 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -711,12 +711,7 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	if (!hugetlb_vmemmap_optimizable(h))
-		return;
-
 	section_set_order_pfn_range(pfn, pages_per_huge_page(h), huge_page_order(h));
-	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
-- 
2.20.1



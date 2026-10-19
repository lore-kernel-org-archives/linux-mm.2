Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B6E609A544
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gdL6Ahjm
Received: by kanga.kvack.org (Postfix)
	id 8B45A6B02C0; Mon, 19 Oct 2026 11:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B2C6B02C1; Mon, 19 Oct 2026 11:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CE66B02C2; Mon, 19 Oct 2026 11:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 313466B02C0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:49:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B11034073B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:54 +0000 (UTC)
X-FDA: 85339811508.03.F54641B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C097418000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gdL6Ahjm;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792424992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ed7Ai2/v+4UUMnde8ZmMAQuE9IFX/8DJI4RqAxylpU4=;
	b=QyHUwsRhUsgvOHDB/kDvRH0jysCBZKiG6phaFyXsW7Cp8uHFynFTFelRNbaDoE2nbP2VwJ
	Q3HfOiWcDWH1F26J+tbfvwuNaIL2KbzwM5Nnz0vTFzvU8hi5OrTBwhzvxW+1UcfcHISNuR
	UnbB2SmwaIcpCvNIg32MRGfA2cbfVdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792424992;
	b=4wcBQkpig+YJxBc34pxcW7sU/u1L1gDuOP0/t/0X1dEIXHISCy6pLqgPtquenm+s4vg9Q8
	TEck1TnZgLPFAFKTMvs6L71VAPXrs8U5qol3W0H37azLfjZfbrTGeiYK5WYOZsOv3P9IzF
	BsD4Inh+M8QG/EvDRljAnU3LAncWw4k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gdL6Ahjm;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59A4860D93;
	Mon, 19 Oct 2026 15:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345BF1F000C6;
	Mon, 19 Oct 2026 15:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792424992;
	bh=Ed7Ai2/v+4UUMnde8ZmMAQuE9IFX/8DJI4RqAxylpU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdL6AhjmraDfPiXt+fFNLaMaxpN30JVdcAK0zGfQ+z1Wz7xWWN2IXu5TuuxJzZP+G
	 8MJ+m/8Mtcn2f5BeIdRlqB9cL2VKZAfNp5GO28cSd/IIubtp+9iGnvJ0CuR7CRJfe6
	 BRwTwk0TAbKppOvS4ruswEujZd0Bhh2e+/F23tJ9UfwMa9eIyaxCqiuZNdNMKPE9/3
	 Wdzav8b4661mlkHH/YPgwUntpXdQ7OjFWEFVMCG2ntuxP/NJafMne8BWLtMao53bXV
	 SAOVhoVX8BmgYchydf0KOkpnRNcJWrRp+cDDDyBdxXOQzq0KJePrfS5QkvzniqbLib
	 raGQm2E5bWRWw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 273C5198003A;
	Mon, 19 Oct 2026 11:49:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 19 Oct 2026 11:49:47 -0400
X-ME-Sender: <xms:FzzWantOCua-VDu9iB8EwtxWSoCGDpT96WqpNrlxnEn7UKNqTWK-wg>
    <xme:FzzWatv_Ju_rpZSEV57r6-hD_rA7nAgAiPM7uaYqTps1TgDveSu9w-sn32URKMhAQ
    fvjmRFZmTmXFRF5CDARGA7PUoPLwG_7fRz_2k63AUPETp4A3Kd-2ADF>
X-ME-Received: <xmr:FzzWatYBqskvnaMIj2tsnerI3l6B-PeSqJVOtjXksSDBg9GLrNbyWqvjywc>
X-ME-Proxy-Cause: dmFkZTESqR4vElUNfwe4Wb1kabMg9MdYUtHyNIvlHi5jfGRsEd0tjiYfzpqh5FemuLlMuA
    +QzWL/iolJzzDzQk8vzuoT2/u2xyL/YZG/CihU2eaSQe3uAw7YKu/Z/hQfgMIJpEQrBQkK
    hH3KJVpCmjg+gNXnnOIkdBMKpJa1pvTLqzuojrt68Uovke10kpOzVhZrNEf3d58NDgoR+6
    GBwzdAiHoLFFDGJo3/r+XBHeUTBbw+IeFaYdgC0j5JEQlKAOMB5I7tBUfVMuw5hMfUnXf2
    vE1DwOk7N/x2FbtU++Y3QX/1ODQhD5sTVGp3EMvK4jUTItTZrn4RBPsK+PhnbeHfl8JcGw
    mU66hr8sFGivOaQBw7U2atwUF2x3djrLkSB9Q3mnaguXHMvDkpm7rhqSFA0ohGFqfUUH1u
    dxHChWUAxw09NAyZDTfJM81AqrT9LU2Vh5Twlr1hurWQ1i4hXLhrWSLYZwnEQegkEOZsBW
    2ssW6OwYwuRhSe6+I65NTvx7Vr9rCb4mR/BhnMrDjmQO1o94/n4xqYxXyl9y9h78FGtvT7
    ndUWzFlFeeSkNndSFl40rBwl3kdQCD+HNz5+1/tpvq8eqN0/fc81tAtElmtYU/Zb+HGtUw
    CDw5XP+G/fbauiZeq64n2XnYIQyFVBZPncpoGy7aFOK5fl3W6hqS5IiGwv9Q
X-ME-Proxy: <xmx:FzzWal4oGKJQQJBEBE_yVeldJUaYWuKnhcJjbWSKmyDIBRA65HOEYA>
    <xmx:FzzWaokyTijrjl6aD7KDcLDxKUXbdkwf1NZJCVWkj1_eMiqH2txszw>
    <xmx:FzzWatqsVxRihyrJ4Jt5z8Lt5-RTgWqjFAgg6S6tYKJ9x5MJ-7wDQw>
    <xmx:FzzWar-uGBsOc8BtyYgrUS4o9fz3asXLU8t5GuWBuNrxzAZH8Zg85A>
    <xmx:FzzWau5GcTO7SpAEjdAlUNM67V5k3ysS3WfSFY9UICjkvvPSLfOddevA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:49:42 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 04/18] mm: count the pages waiting for a grace period
Date: Mon, 19 Oct 2026 16:48:57 +0100
Message-ID: <20261019154913.1765974-5-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C097418000A
X-Stat-Signature: p4wdepbo1j3rjyesxow7sk16jxgd8d5t
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792424992-227992
X-HE-Meta: U2FsdGVkX18nnBEzNuHdcrPVPbpQ2cdDSQK6NnTQ6rPdD5AyS86nd89qhRGS6vKu/kCwz2jODQjJ8TbFKb1O/DsmdLPwF+GfGE2tGQLENdgXbEKm2tD45CaCcqwgj0OKimfchtVTmP9IiuXY1BXTdgw4SpnTWkCf72D4VMV1D6qE6EzzniDoo1mmxlZghpP8osVn9w/KLfiX6dT4HTPPZiUmrcY2+eYBJRYAT2Wjyvuks3sSC5Ja0sIDV3f+aDm7aX7H12F/BNs7UBRqoRa+0Ebh/sl7XPNGV00DH760XwR4WXYdLZeaKOQTjv7Jpgd5D+cAn+yHhD3dZU445rf2+AF+anQ95ZmRpo/iKOHz1kJEFoTPjaBfO8d9ahDPKVure8DGOpACfjci+4HtsNCc6yXWZb3yeGnDfclqftCSt3vDk2GgfbgLa8UL+caimPcYnDTVBbmD6AN6ryZN9CXezpvEgtmfAlcmNOmkLpFHe3iCbOM6T18wa+/WJMm9hodSm1dMzGanGrurpWeNqyyR1MRGdMfwMTjWhTvaz7GT0qDluBbQR2TvziJnAQ6wsGgFyd4/k72xLd5+g6ApTxvOhOvcZLUbv2+8FeyvL6ikiWWssCwyTOmW+nCb9kPpFulF/qAWcO1AhZxqa0etKuHDsJguEUbwI3ua4O57Op6jpPXvTJV9RMxgnFTbSVWodoxegKI2tMktAL2OnBjTnMcrbQuXJFT9HqmOaeg5wnn2wEElprc5I0xkruZ2D35LH6Xitxd6XyQ5n5s9jJvBzQzK8XP2JL+KB7WJFJzZKJRL9icIJC5OiBc6sF4/WEGGtEYycHr2aGNe94QItGlBnrGQKUyZN8Vzot3hMBdNKTWRDflDw6vOrqodTuIExHnPH+k8hlC61y1e5+zYLu4SBDZozUUeurdP2LgPo+GjJG9gvQOBB3xzWZTQ27HdPDN42Eyin47dFN5/LBCyII7cBNm
 ucCWhyae
 0qFTskgPsZtWnqWcUASwGidB4ey1aDCflCnpq7wZpCxsMqYerueXtZeFsGkx0SuXaERpaDc6epxSCaGHHjWUMO7bqZCeyXojPPg8ZgNiBwbErNtiPKCDsfD4YJ0sveIXRgfjt1vX4JDVrvzQZoT643m5BBJWPzXwWcidqx+Z2CeO71sWV+SlmEOjZCTrWgBrCxIZtL5XGFBymhtPaJIQXmRzQ0OqkyXn1T2tNeI7jCmXns4NdYA0oxgAkBlKjmhFdnLhG0KoMF6wyrRUNeAth6yeIQEgTjSoKYwGgVjHpRHB5+BnoHK3X/AD3xsZBxr8OzDKbRr3BTRqVCYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Deferred folios have refcount 0 and are not on the free lists, so no
counter shows them.  Memory that waits for a grace period is missing
from the free count and from every LRU count.

Count it per zone in NR_FREE_RCU_PAGES: nr_free_rcu in /proc/vmstat,
free_rcu in show_free_areas().  Preparation for freeing the waiting
pages sooner when they hold back memory that is needed.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/mmzone.h | 1 +
 mm/page_alloc.c        | 4 ++++
 mm/show_mem.c          | 9 ++++++---
 mm/vmstat.c            | 2 ++
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..3336b9e5ee99 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -228,6 +228,7 @@ enum zone_stat_item {
 	NR_ZSPAGES,		/* allocated in zsmalloc */
 #endif
 	NR_FREE_CMA_PAGES,
+	NR_FREE_RCU_PAGES,	/* freed, waiting for an RCU grace period */
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	NR_UNACCEPTED,
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a371e92da273..15bb66e36304 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1348,6 +1348,8 @@ static void rcu_free_pages(struct list_head *list)
 
 	folio_batch_init(&fbatch);
 	list_for_each_entry_safe(folio, next, list, lru) {
+		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
+				    -folio_nr_pages(folio));
 		if (!folio_batch_add(&fbatch, folio)) {
 			free_unref_folios(&fbatch);
 			cond_resched_tasks_rcu_qs();
@@ -1375,9 +1377,11 @@ static void rcu_free_workfn(struct work_struct *work)
 static void rcu_free_defer(struct folio *folio)
 {
 	struct rcu_free_pcpu *r = raw_cpu_ptr(&rcu_free_pcpu);
+	struct zone *zone = folio_zone(folio);
 	unsigned long flags;
 
 	spin_lock_irqsave(&r->lock, flags);
+	__mod_zone_page_state(zone, NR_FREE_RCU_PAGES, folio_nr_pages(folio));
 	list_add_tail(&folio->lru, &r->pending);
 	rcu_free_start(r);
 	spin_unlock_irqrestore(&r->lock, flags);
diff --git a/mm/show_mem.c b/mm/show_mem.c
index b938cbcd774a..0d3bddbda108 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -204,7 +204,7 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 		" mapped:%lu shmem:%lu pagetables:%lu\n"
 		" sec_pagetables:%lu bounce:%lu\n"
 		" kernel_misc_reclaimable:%lu\n"
-		" free:%lu free_pcp:%lu free_cma:%lu\n",
+		" free:%lu free_pcp:%lu free_cma:%lu free_rcu:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
 		global_node_page_state(NR_INACTIVE_ANON),
 		global_node_page_state(NR_ISOLATED_ANON),
@@ -224,7 +224,8 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
 		global_zone_page_state(NR_FREE_PAGES),
 		free_pcp,
-		global_zone_page_state(NR_FREE_CMA_PAGES));
+		global_zone_page_state(NR_FREE_CMA_PAGES),
+		global_zone_page_state(NR_FREE_RCU_PAGES));
 
 	for_each_online_pgdat(pgdat) {
 		if (show_mem_node_skip(filter, pgdat->node_id, nodemask))
@@ -325,6 +326,7 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 			" free_pcp:%lukB"
 			" local_pcp:%lukB"
 			" free_cma:%lukB"
+			" free_rcu:%lukB"
 			"\n",
 			zone->name,
 			K(zone_page_state(zone, NR_FREE_PAGES)),
@@ -351,7 +353,8 @@ static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
 			0UL,
 			K(free_pcp),
 			K((unsigned long)this_cpu_read(zone->per_cpu_pageset->count)),
-			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
+			K(zone_page_state(zone, NR_FREE_CMA_PAGES)),
+			K(zone_page_state(zone, NR_FREE_RCU_PAGES)));
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
 			printk(KERN_CONT " %ld", zone->lowmem_reserve[i]);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 66ed017bde46..64068d73d6d2 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1212,6 +1212,7 @@ const char * const vmstat_text[] = {
 	[I(NR_ZSPAGES)]				= "nr_zspages",
 #endif
 	[I(NR_FREE_CMA_PAGES)]			= "nr_free_cma",
+	[I(NR_FREE_RCU_PAGES)]			= "nr_free_rcu",
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	[I(NR_UNACCEPTED)]			= "nr_unaccepted",
 #endif
@@ -2023,6 +2024,7 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
 		switch (i) {
 		case NR_ZONE_WRITE_PENDING:
 		case NR_FREE_CMA_PAGES:
+		case NR_FREE_RCU_PAGES:
 			continue;
 		}
 		val = atomic_long_read(&vm_zone_stat[i]);
-- 
2.54.0



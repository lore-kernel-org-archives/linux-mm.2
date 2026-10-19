Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F49F609A579
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IO1bSDKP
Received: by kanga.kvack.org (Postfix)
	id 8DAE16B02C4; Mon, 19 Oct 2026 11:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CB96B02C5; Mon, 19 Oct 2026 11:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753396B02C6; Mon, 19 Oct 2026 11:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 323046B02C4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93854A0781
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:13 +0000 (UTC)
X-FDA: 85339812306.10.10F8139
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9B166A000F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IO1bSDKP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIYW0lKY8r5WbgU97oH0sqdYNOmLWzVfRBL2C79VgiY=;
	b=AZZP+cK4jEAFCZLUrjv6rPEPgHRPS4gNoyN6iSTebxxxPtQ8FZVmq2TocuVWlxpWow7B4C
	AnZB76OFm58kMzLl0bf5V62+BFfjf/+lLZCwE+dzMhuXetEPqlVQqgAwC5bnfwpcVOk0ta
	4m/p6DJv87i77FUNLwwDR/a2iZqBiBs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IO1bSDKP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425011;
	b=qPqwY9u+pT/U80fhkPcY79OJOIcthL7IgT3Ab2oikduSQyeR+pAJcLZLkO2VvkFgB8X4PD
	zICklg51ZpLroIbR11S6Tjugkodp2cecnRZqHS7xytEYuZrvTVEGit5IecKHQvtfmsSZ98
	kEn4qUxlMA3OfrqkWAeY/pSf/pqSxb0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B38E60A8C;
	Mon, 19 Oct 2026 15:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F321F000C6;
	Mon, 19 Oct 2026 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425010;
	bh=JIYW0lKY8r5WbgU97oH0sqdYNOmLWzVfRBL2C79VgiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IO1bSDKPLcp5IZ4j9DF2iUY/nVHpZ2Ua0hkxJ6hhDfn4XuI+p75xy/G4r12EwpmwA
	 u9N5UFn4VQTIPcGtGn+FunQM+L/IUiwrGwWSdASYj22meM02+hUe9iJdx4w2g9/hpm
	 6EvB+V2jVdcwqhAuOd1RGButeU0lqT8lGyfFWLVsHnWAMzjvnX/fXhxjElIFl1wDRL
	 CJTXpI5NNpvcFFihmZEID+cEwWNKcW1me9dnqOYGh90fzo+k4IG0wHY+XhfWK3ozkn
	 F2STF+Yn1sN26tiX/PEvx0pNYiohQ5Ov6fO8BwCeRW0izBfF0UVQjPYxlSmBYAE0q7
	 w7OKXhO8OSpqg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5C68E1980047;
	Mon, 19 Oct 2026 11:50:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 19 Oct 2026 11:50:08 -0400
X-ME-Sender: <xms:KzzWaq2lTI6dLRfP62uXpQXMn8_acHRa54NMXdgTD-WoThywbrSZng>
    <xme:KzzWaiUM1eukMYRUhELWiDlsX76CyWwwqpiBCcQzGIeO5cTVXpuFqHmy9BV8vsR0C
    WMowq0G623oHJIwuahUxFyUtOd-kqIwYkCr7JlcDCcYlkEbQJOVHQNp>
X-ME-Received: <xmr:KzzWali5Bz8kXGXrP0nbvODy2zgeQyZ6Baw6DyzchOg375U0aFlZ9XHLdjA>
X-ME-Proxy-Cause: dmFkZTFpjrG+2jfVBfklNRE95oThC60xlhUtv5sioyJrfpDDHbEB/2cXkTI411oJriXTLs
    N7RLfOUdBbmoibSFu4zT/f1BKPPyxkEYUp5eDeafGhPQjcnfJv/29ZtYwE6q77Fr7A6zQu
    C94bEu3EPqJJ50fLC5xP9PtYZOq3sS+jMfKkgkZFNUAdZxkDiyHArLijwBk9MwzijLWdvR
    4raSXvkSyIGvp9XYd2doZUGuEANzDQejgJzzg3ARZCjBL2yZfXIvLZCg0AMujDeTHEemYv
    cvWt94P7AS+P1mtikHZvyS9eAaK3Fy2/TwDlvaPXULPDsZK9f0sj0aca+uCBBoNs4d3uh7
    RoQzewG/TY6u0dk9M/RDUi+4K1yv+yK67j7jmtVzymHX894+Uihg0lcvs6emCinqbM6wyi
    +gUxb773pqkq1jVVcdmSvAhK/XxD/KPCg7Hxilx6E+9oYQ5WMSaJWUvVlcniwS0w+KhrFB
    aoikZIMYd0Nt7GpLtgtIaE3vQKln+pJStVB0vtonatrWvsHTRAgHwTcxLdOTPe/K6HQPJR
    iuTIfSH64MefXniZjMOLCO5Col3kGmDlFai90qTMVtRjt8vCPwHCFc3lid8qi/aWvaM4wi
    UDelk5nM3XO9TE5wjafiWBoWVJEtmtWZsXCTxgC48VOvrEqJLpl2xs9xf8yA
X-ME-Proxy: <xmx:KzzWargWtrUdbQgWlyLvDyj2Sh9WS2ythi6pZMOd2Wsvz6_ZhGhiIg>
    <xmx:KzzWatuKqS1ChJwAImpgrQb5jS0sXRsqBayf8up18aNXoL3EpLm9UA>
    <xmx:KzzWasTzLfXJWgsa7vWNhOzbf8t3G4NQleJe7kFJZjBlXivczFykRg>
    <xmx:KzzWamEcw6XHsPbckM2mv5_oUhFq5uFaBjpv_Uw7xLhjwfQtNPdSeg>
    <xmx:KzzWauiA2en7YXSRag6_TQGTMYyPKCsLXaQw5TAYPN6_31Ex2FRtRRgv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:02 -0400 (EDT)
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
Subject: [RFC PATCH 07/18] mm: free the pages waiting for a grace period before isolation fails
Date: Mon, 19 Oct 2026 16:49:00 +0100
Message-ID: <20261019154913.1765974-8-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B166A000F
X-Rspam-User: 
X-Stat-Signature: rk1wzab1d7taauqt3d43akbmfa4g9iuf
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792425011-289613
X-HE-Meta: U2FsdGVkX1/PMHG9KJPxsa0PAUrotI+5qiZCu8kDBXLo6ZzLn1eCkjv64Hsh5pjNFx2euJwpz+7nQrkdtlokl7xksxoUc/ylfIncm174bv32NGni61Vd8t3d7muMsseW39bE/xMJZgaPKzUEW0524+r3dDAD8KsHDq5kFghLvKmM5jjJd7X9q+4VawJ+FynTj9WSc4H2TgcE5Itjahp2ggZgHKX6BI5oAsVA6Dc4KdlbGmI1+g37Vp1q+R8+afV4qvGhU50x+3c1qNxCAKrt14bp01SvIsNsLI6kUaefTgCkj0VmQientmZ/UDMSTfeMYvCq7+5CYuUEHZ+LIoqocP2qF+kWMQUY6sSXgzjmZDNwSvcRbTrDim5nCzNcu6LJ/ZlxfX+HwHok3Vii2O+1rOg4jt7yhdfO11GHhiEYtWq3M2lFerchL1tUZMf75fcexmyWTu8QEUQ1AiVeYAeZGuu6BpdYGotqLr82vbeXK3dlGaX2/BocfzpoX9nWFSYro8E9v4blssXN1gP/jaB0kwH4sZFPd+5XJGKkk0oKftXHaFA/0X6256bMLAWgyE8UW9wgmHX1S6mNHkw0PIWh/b0T9zzlaDDB0GYwR1Czfo95LIAO4BLiIcXCXOgQtCGcI2dk/QSrT0Oaifc+n5LNTQ06xIeGC4jVt7xfpS/XKaOKzeJ8wL9ZoDKhOGwAY8UuPNq2UifUx/SwTegD1zKNpMKz1VwlRltyGUD2VG6LGlma1cpeY33EvVXaO8ki3izvlNNda+YMn9mh3vWzCgmjBTyG71F4UiRtIC4mv+qXXgirXuklWRL32ruDfjv/aFsUwrIqYooOnVe1y2Afv8AUs0Pa6AfL/IAU7s46wU2aad3KRsm1vFiU9OYkwHy3Gjd13/6ClkNHEvzdDp1cpCvJo6SNvBjnXBr2o815z8pSv2OqEHoVkUK9b+48od9MWOIrGB9ifxoaaH9ILN0VJXI
 bzCKc7wn
 bmK7kaDp7PnS3iw5VLpqneLQ087rbioR+ImiZNhC7NoyN4wFwVmlTwy/hEDrjov+ArygXAyh7HMhFMpgtL8Ko7S29fvUQaSKbF0B/nbVAgX2ng/Ens1BsshLR4/EDXaDZEVSbpv/ZtiT8VdcSftfnZa4/D5gaPO4BwgxTfGoTz7KHIyVZL6FtRb9ZrimLsXX6wZ19sgJP4/SU/IqZoGiQC2tEyXd313afHu5bonn5wfU3o67Ul5sdxRH+MrdciPDpFW1CFzZAbN/vj9c9K8meJks9N2GaRa4dAg8aBRatP569tSLCsxerPzED9y46qF8W+DYS+cYisH0BRc/NDqKTAO75xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

alloc_contig_range() and offline_pages() migrate the folios out of a
range and then check with test_pages_isolated() that every page is free.
A migrated folio that had PG_rcu_free waits for a grace period after its
free, so the check fails.  alloc_contig_range() returns -EBUSY, and a
CMA or gigantic page allocation can fail; offline_pages() retries until
the grace period ends.

When the check fails and the zone has pages waiting, free them first.
alloc_contig_range() then finds the start of the free range again, as
the freed folio can merge with a free buddy below it.
offline_pages() does so only after a pass that migrated folios: an
offline stuck on a busy page would otherwise start an expedited grace
period on every retry.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory_hotplug.c |  7 +++++++
 mm/page_alloc.c     | 28 +++++++++++++++++++++++++++-
 mm/page_alloc.h     |  1 +
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078a..a8f0c95627ee 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1967,6 +1967,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 		.nid = NUMA_NO_NODE,
 	};
 	unsigned long flags;
+	bool migrated;
 	char *reason;
 	int ret;
 	unsigned long normal_pages = 0;
@@ -2050,6 +2051,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 
 	do {
 		pfn = start_pfn;
+		migrated = false;
 		do {
 			/*
 			 * Historically we always checked for any signal and
@@ -2071,6 +2073,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 				 * out
 				 */
 				do_migrate_range(pfn, end_pfn);
+				migrated = true;
 			}
 		} while (!ret);
 
@@ -2092,6 +2095,10 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 
 		ret = test_pages_isolated(start_pfn, end_pfn,
 					  PB_ISOLATE_MODE_MEM_OFFLINE);
+		/* What this pass migrated can wait for a grace period */
+		if (ret && migrated &&
+		    zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES))
+			rcu_free_sync();
 
 	} while (ret);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bec9128d80db..e63628e64cbb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1468,6 +1468,23 @@ static void rcu_free_drain(void)
 	mutex_unlock(&lock);
 }
 
+/* Free every waiting folio, including those a work took off the lists */
+void rcu_free_sync(void)
+{
+	int cpu;
+
+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+		return;
+
+	rcu_free_drain();
+	for_each_possible_cpu(cpu) {
+		struct rcu_free_pcpu *r = per_cpu_ptr(&rcu_free_pcpu, cpu);
+
+		flush_work(&r->rwork.work);
+		flush_work(&r->expedite);
+	}
+}
+
 static void __init rcu_free_init(void)
 {
 	int cpu;
@@ -7632,7 +7649,16 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	outer_start = find_large_buddy(start);
 
 	/* Make sure the range is really isolated. */
-	if (test_pages_isolated(outer_start, end, mode)) {
+	ret = test_pages_isolated(outer_start, end, mode);
+	if (ret && zone_page_state_snapshot(cc.zone, NR_FREE_RCU_PAGES)) {
+		rcu_free_sync();
+
+		/* A freed folio can merge with a free buddy below start */
+		outer_start = find_large_buddy(start);
+		ret = test_pages_isolated(outer_start, end, mode);
+	}
+
+	if (ret) {
 		ret = -EBUSY;
 		goto done;
 	}
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..f9e200581e2f 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -235,6 +235,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
+void rcu_free_sync(void);
 
 #ifdef CONFIG_NUMA
 struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
-- 
2.54.0



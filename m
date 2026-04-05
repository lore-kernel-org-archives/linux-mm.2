Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B388F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9064F6B00B8; Sun,  5 Apr 2026 08:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7036B00BA; Sun,  5 Apr 2026 08:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6216B00BB; Sun,  5 Apr 2026 08:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68BC96B00B8
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E07B1609F6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:37 +0000 (UTC)
X-FDA: 84624498714.12.445AEE1
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 327CD1C000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VMi05ajN;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLG7p8wcALm1QMUUetEVr6LzElxTKf6AgyaW2eyLe0w=;
	b=mEPxFdlPvka3ByLJtsxbvmLRkyhgjTKlopGHT9nfoCqYYeQbjfY7ISmiu+CQtXaEPQm3kr
	Kcrm3Yr0tDg3xzIBE7ZgPjdfKaa7+kNPq2CTzp2Xhf2hiz6fyseBpQNQp2bt3M6hJ7J0re
	NSV2TPhB2Te1MnEJUzqIRvZINlHtUC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393735; a=rsa-sha256;
	cv=none;
	b=pFWk8M8qUR+uBmvDS1eKRMz9OxvEwD0dbXojp9Y+eSjS6uJbcQXNM1Y9CwG0+5vaA+x6NR
	tP8YHrx2/1vNyupcZcv8gJEMXk7J4HccJfS1IaG6YoVl8H3dJh/7T56GPj3qbV57R6+nL0
	EQlASJ8GTqcf/rNk7Ns8MCLwI2F5nfs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VMi05ajN;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35d96be7c13so1889929a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393734; x=1775998534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLG7p8wcALm1QMUUetEVr6LzElxTKf6AgyaW2eyLe0w=;
        b=VMi05ajN3OpkURbSz1OdaiEVScZveCeKefaU+g3+xdiQSZu/Ho0doSPdvtoNfhtszu
         ES7FYd2PG+hdOC4J/8fmRSIOh646ZkcOSBpZQ10rcLgfFL13iBLZrZIxLOhqq501e8v5
         IAtc669dqhw89CGNIfDXZ3IoLrHVaedvCe5V93kCNq1D19Ztvus2BAjU3JSSYKCEnO7x
         934wDCpvfJiWgTnv9ipY55gjS75d9akoRlUKN1EHrOnJmBCBHkfk9LeHffJaKn+VtOJ0
         nq5w3/pyoXuMtqxjDP46mJpGJBdpcJdB3CsMdHH5YwnefkgnAjNwZAOGRpUnR07a0f4v
         2YKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393734; x=1775998534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kLG7p8wcALm1QMUUetEVr6LzElxTKf6AgyaW2eyLe0w=;
        b=D7gsHcUs5AmW8GGCmPnnu5p8VCPOHeUrIU2My3KivYo0ZIFoUCOw9yWMdYKSn1BGHp
         Y8EwtNc4GBqWyb3f0dru3i2YOLtu3nmOrSa3T3YP75IbiYeLX5Jy36ZOWsWitfJPqEjZ
         AzprrE9Rcwffd/dWdSh1BPvY0igOGGGxN210d/f64dx8XYC1xrRS0OByRxFhpbuxjMYf
         RxLpFaQpUMy9k2d2oFevY7vribGyZPX9oy/qmFxUlwc5zUh8Hg/RPpwlRKYN98mMA4+Z
         SANEXfP+lbSezkQwPc5apVCYiTYmjJng0vlfSDz95ddYDIHiAKJOFl4h7eVCCHq24m8t
         p9Dg==
X-Forwarded-Encrypted: i=1; AJvYcCVa+uWLVwTCTE2Y+4ijPZBi/tGwFAsQmbDI6KrZRH4yh1rgybf3eGVewOzoSlQLe0hsYdyvGqLUuA==@kvack.org
X-Gm-Message-State: AOJu0YywcQ4rSFjcnKrbWyCTrA/ejZ3XHImfLwbKsmGNdW9TdfDi7DHn
	tYNcMDVwx4KfQxqwR8Q+5fzAaCjI7HcOU2pF3oHC59pK8FFPL5m6SzPB6MZ6mwKxCl0=
X-Gm-Gg: AeBDies1WBQ1rqr1XvJMKTRU4ovvdgZQ8D/hWWWVRTEkhFzHqhN2Zjgw/oPlXypaDR1
	0vzdo2IvjK6NpEmUlDOloM4foBnN70skl+H7IpBQLtro2VloGULY88p1m8bkPMrokbjBY8x74nR
	W6n9F6hF1m9c5FHOQ2H7JvZFv3OlDZ6QdlNid4iHLVHYUGfv1RQ9i8Ii7jz2+ww1thoxSWfH44T
	g1gvrmndD4whapBjVXfrjOj1b48eKfiZvbnqPTMEnStpIeSgqV9a03/Ig01zjVvfavKEER8lINh
	8Jr8bhXElpHp4H4MpA2YaCHxOpjiTYg8ZhA4sLta0jJMG9qpSwaTuyyqt4zUsn6hv7Rt5kAMVj/
	Kawoed5/ktpWTMF1RztHTcdJenr8kf150PkppIe7ybFrp1YCBchgQGhOA71G3FiB/jiNCzt/FW+
	phxaJ6diWDXv5/zgR0Xt4eGKeiHFxAcYCa7Jqw2LDwz6E=
X-Received: by 2002:a17:90b:1e49:b0:35d:9d5d:10bb with SMTP id 98e67ed59e1d1-35de57b10a3mr7106976a91.0.1775393733924;
        Sun, 05 Apr 2026 05:55:33 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:33 -0700 (PDT)
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
Subject: [PATCH 20/49] mm: rename vmemmap optimization macros to generic names
Date: Sun,  5 Apr 2026 20:52:11 +0800
Message-Id: <20260405125240.2558577-21-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ngo5hfifa781ccsmqkyfkret18n8kzho
X-Rspamd-Queue-Id: 327CD1C000A
X-Rspam-User: 
X-HE-Tag: 1775393735-52860
X-HE-Meta: U2FsdGVkX18iS9NOVDkov+UggD0WawSwSZaKw/3snXexvPyJcFn/WZ6J11UeQT29lF5TgVY1It9bNM1mCIzbcaJSs+Ph5apiJpRIYnTZQkUdYfixRNTnsWmo09omzL4RFxO50bjvfvWuVgASte7H4JGxpgN0PX27VLtGyuUKqj7V1DvmxKuV5Qs9iULvyE7LGTKysuj4yl8zeSBnRqswX5gOTz65m2bUjPV2qofceeawDk2y8r18xdBs2isp8NsO23cDSozNuTD9xd9G6G/y7RlZo6onwJlGM/UVwyPZ8miSat4Pp2OUOMroe193zaHMPjJotMOG2fJHq9TLVgjfDiHeX7ePQUFBG6fpRJjzenTnvFirby+w/X+lDnW8Opdjxi5VUhVosBaSjpTFo6UjaKqn5nKcI0yfuf3ntrJv1CH/1a6Sua+8k63Mw7myPpfAhVh3Y5V6c8ftApuUuPjrlaQ/95ef4aL8zU7JZlezJdpQTGbq9ZVkuG+xUlMwHeU2RwvC7A34Yw06OQErSeukeUH0QBh8yn+59YUH/SRjxITvIO7N1C3sWecvH3l2dp+ILWfs6t/7kQNhsuJQ5XxWltGD6QimDtEQ1zoGtAjIUPRToeXlYi6N8Z4Jzmri5HldPOQG0rsVLfJm+KAnisW63Cgkkwq7a/jxcDVNT2D/j7I0KovkKGWb5/diqB+M1L8JJaXT64LgB1R8+uDCNONPhzfslHm2MKTbdCEb3eKNyJK0ccpPKidPgdVeyb5oO9iWR0mdZNk/VG8PgLAQrkFoa2lOG4+rDgdhdEzhgGPZ+HWVgTb9uKi9+zi4EPSZi5hLBBazFC1YaUHzumOBm79FgwU+7ETW8X1CHywh22vTsUEUqgWDKyz+/UMfDXV/xSITfL+wKp3nS9KTmXLyMQbqk5thJY7G5qgbHmvPFPBytiErHmazGUG029vbUND7IJNqIU28tJ2HCiBC1ty32Fy
 W4lN5h16
 OCTPXHXPz5P2+/JdOLKd0LpdukpcTyG27rf3KC3XD1uk11JZNLe6mjCrClm5+9hKKLgLql1baBVr0GTfyU5ONRPEgEh4O6EeyF4UTD4eJ5T9la3ladF3QaFOHQJLDfX3wnRvf/U79c4yF3qF09LqAoKb3yUkxfoj7GPXcUFVFW/i1m7ZcrwRPjFdoTyNwBD4Uh349UiNthS7vB/J9YoUjaPB0zf56tJb5kJ2s0XhDkkSv/g6Tbd3PUBlGGX1b/jUx5MM/ajE0lBaS/CJcH2G0T7Ms+ipprWFwAVzmIbtqjdEVvw18l0W7zyWT1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for unifying the vmemmap optimization paths for both
DAX and HugeTLB, rename the existing vmemmap tail page macros to
more generic, semantic-based names.

The original names (e.g., VMEMMAP_TAIL_MIN_ORDER) fail to clearly express
the actual requirement: it represents the minimum order of a folio that
can satisfy the vmemmap optimization. To provide a broader and clearer
abstraction for other users like DAX, replace them with newly introduced
macros like OPTIMIZABLE_FOLIO_MIN_ORDER and NR_OPTIMIZABLE_FOLIO_SIZES.

These new macros, along with OPTIMIZED_FOLIO_VMEMMAP_PAGES,
OPTIMIZED_FOLIO_VMEMMAP_SIZE, and OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS,
are explicitly bound to the 'folio' concept. This systematic naming
makes it clearer to describe the properties of a vmemmap-optimized
folio rather than just raw pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h | 18 ++++++++++--------
 mm/hugetlb_vmemmap.c   |  6 +++---
 mm/sparse-vmemmap.c    |  4 ++--
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8ee9dc60120a..378feaf4e4ed 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -107,13 +107,15 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/*
- * vmemmap optimization (like HVO) is only possible for page orders that fill
- * two or more pages with struct pages.
- */
-#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
-#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
-#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
+/* The number of vmemmap pages required by a vmemmap-optimized folio. */
+#define OPTIMIZED_FOLIO_VMEMMAP_PAGES		1
+#define OPTIMIZED_FOLIO_VMEMMAP_SIZE		(OPTIMIZED_FOLIO_VMEMMAP_PAGES * PAGE_SIZE)
+#define OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS	(OPTIMIZED_FOLIO_VMEMMAP_SIZE / sizeof(struct page))
+#define OPTIMIZABLE_FOLIO_MIN_ORDER		(ilog2(OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS) + 1)
+
+#define __NR_OPTIMIZABLE_FOLIO_SIZES		(MAX_FOLIO_ORDER - OPTIMIZABLE_FOLIO_MIN_ORDER + 1)
+#define NR_OPTIMIZABLE_FOLIO_SIZES		\
+	(__NR_OPTIMIZABLE_FOLIO_SIZES > 0 ? __NR_OPTIMIZABLE_FOLIO_SIZES : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1144,7 +1146,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+	struct page *vmemmap_tails[NR_OPTIMIZABLE_FOLIO_SIZES];
 #endif
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 535f0369a496..d6dd47c232e0 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -495,7 +495,7 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 
 static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
-	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	const unsigned int idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
 	struct page *tail, *p;
 	int node = zone_to_nid(zone);
 
@@ -828,7 +828,7 @@ static int __init hugetlb_vmemmap_init(void)
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < NR_OPTIMIZABLE_FOLIO_SIZES; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -836,7 +836,7 @@ static int __init hugetlb_vmemmap_init(void)
 			if (!tail)
 				continue;
 
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			order = i + OPTIMIZABLE_FOLIO_MIN_ORDER;
 			p = page_to_virt(tail);
 			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
 				init_compound_tail(p + j, NULL, order, zone);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3fdb6808e8ab..9f70559df4e8 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -330,12 +330,12 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	unsigned int idx;
 	int node = zone_to_nid(zone);
 
-	if (WARN_ON_ONCE(order < VMEMMAP_TAIL_MIN_ORDER))
+	if (WARN_ON_ONCE(order < OPTIMIZABLE_FOLIO_MIN_ORDER))
 		return NULL;
 	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
 		return NULL;
 
-	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-- 
2.20.1



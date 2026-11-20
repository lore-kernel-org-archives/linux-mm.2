Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0545606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=f4kpIFVS
Received: by kanga.kvack.org (Postfix)
	id BC75C6B05BC; Fri, 20 Nov 2026 05:09:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F3F6B05BD; Fri, 20 Nov 2026 05:09:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4D66B05BE; Fri, 20 Nov 2026 05:09:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F95B6B05BC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:09:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B065140CEC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:54 +0000 (UTC)
X-FDA: 85455076308.24.E780F41
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2CE6C40006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=f4kpIFVS;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169392;
	b=KSF0abb0ARJn76+M2fvrB3YdeXYGlHlIVU2W+aNbLFFev8DOYeztQLcmwjJmWc0T3bYJdQ
	1Fk7QPChEkdKdPLyXBGwaQ8UwlghmQVAcwSMjrD+gJHuhbPZmxru9RxFNvnGA6AdsNf9IX
	u30yAhIsEuR2guFcbNLP5Ru3oglLkYA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWd0+k3NeF/ERhQrwDikiXwm9apd9cQ0pzw+sZaX1u0=;
	b=s7ysc9SH+im9NIBP8AWFLTtCL29NIlWvhMjbQY2HC9/7dLxlA213sCsmB6bJsVgDnWaCJD
	c123RMRoHl2TP5rjxU4h+SAt8mnhOUcw8C/bpul4J/9wNGRwxBjuIGe5Rqg1mODKJjsNwz
	y+iT2B0HNpG8Ae6juUX92bPbKQ9TvQY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=f4kpIFVS;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b179528d56so370773a91.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169391; x=1795774191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bWd0+k3NeF/ERhQrwDikiXwm9apd9cQ0pzw+sZaX1u0=;
        b=f4kpIFVSlfrvl121QYxqpntJFM0TYC9c3Tkud6Kjy0o6LK4nVZ5TQGDVf9wAPkezZh
         desaU3aFpDEg/xQN1k2/PzB69AnW53OxI/nL5MDakSERKr42/foJaL2Ba+jTRBBosLNk
         vSybe4KsfFV+Jm9GGpiVj0GaTrsQn+g367g2HeMYCihXEFrJtGCzkiNwv33FEMbFKWnN
         gzQHzi2wSgHQB+fyWmWOm5W1ivm24JepP9/FKopBJFfcaY7uW8caev/RSWJ4CxirhAoJ
         7lF1y20/vggmqnq/uc+wHHE84a8xqQuimgAKIxuc27dHEtUsKoRMVXJEEfV6fBq9AGmK
         vzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169391; x=1795774191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bWd0+k3NeF/ERhQrwDikiXwm9apd9cQ0pzw+sZaX1u0=;
        b=Z644T8oi1lCrPgDt628RpGpbBAl8Zo00ZfIQITO9m/wfGMz5RZWAoOk8RtA6pUXexd
         FuOqEC2ZYnetTh39rDLapAB2OLjXsiDGABj3qbRrcjxkfa2QAWa+LHbewmjcDfRxkqcy
         iHsH4EycdPMec6a0lFzU/lwvUiqb/rSegQIIfyyDQTj+NtKJSh5KPXjZ5BxrbX3eyRe7
         HdNGsY0Bse9gAKAWqHdMH3YfGyWph28CRibpi0ilxeonh3jCY/Ly9Ns8yFpVbjynJx/J
         6kwZhx0xA5mZsQwN0O8ucX4wn9+ohqOSmEi8aDb4NaZ8scAMGrq6SUqRYLIokfhgzI/u
         1tOg==
X-Forwarded-Encrypted: i=1; AL+hErEQBfHAv1X/S68DTfXCH+nWCYTyziugAfuRMSz0ss/kiNam63ZIaCGtgtI4WNCKzRFGMER2xgSZQA==@kvack.org
X-Gm-Message-State: APuU4Z/2/kjxoR5cw2ZlhCf/pP84WOQrXDRQve5rvdmeD/KGiFtdJoZn
	7oR2wmd3WVC8Al5oCNKCUSs+/OZ87d0F+r4WIA8lqLCyWWILqDxFYjt3CGt57VtO088=
X-Gm-Gg: AZFdTZfRg8Yz3tBwSMXgfCb+nosTPpXjuu+opti0zX78UBLKlYxWc8Za7urzjNpgTEG
	/fYUXlGG4tap16ZHoFZcgIpc1QJFIwTWkP7dMnxAJXzLtQLvyl7WeCT9xiSbYbGSsYLxGJz9tof
	jPHmKbx4HHzAujKaLZSZZoA77hbTYHDV7ji+e1EisEPmZIjOVCPHVnaSvfzpMMHYEeOeqSEKTEq
	pslC6YjCwozuahWyXpNGbBc5V/kkj7i6wk5EL/fARH+bYS5Om9f3RoUgeEHfKOQe8rciNGN+UZ7
	PDQx0aCt5HrTLj+n6Wo5FfE1NnVw1yxlXPG87nhjVn+zEMLxsEA3ur52THZm1Ac7bchkuONvGNo
	BrzdgAxi1glsq1oRY9or3U3Vxh+7fvuTHFneCaPiLwT04lRMFSLC6tXmjLRdPjUzzInhU5YbH23
	xeM1wz5uTyXKmWge/Hr7CnJnCllpNBw6kWs6NNWUYEIofE3j+UAfUKRvPyDXFvtpLzIvma8bJQH
	oMOkqosrYEq7tfyvoAycadwUOrx/NrPJyRW3LxUSL8hrxdNcnOPRCMGxe39Jd6JBgo9Fqh9FAWT
	hwqW3s8wdjNN6zCtBJspI2r4qqS8W8a13rqZwLxTAcfPdRsJvBKbT8CsFeehErsKsIXQcg==
X-Received: by 2002:a17:90b:384d:b0:3b3:be94:8dce with SMTP id 98e67ed59e1d1-3b41c9d2026mr2111415a91.31.1795169390766;
        Fri, 20 Nov 2026 02:09:50 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.09.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:09:50 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 05/11] mm/hugetlb: drop boot-time HVO handling for gigantic folios
Date: Fri, 20 Nov 2026 18:08:50 +0800
Message-ID: <20261120100856.16929-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: hyo3wre4czsrq7md3j4g35y1mn8dekqc
X-Rspamd-Queue-Id: 2CE6C40006
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795169392-707908
X-HE-Meta: U2FsdGVkX19Cuyjjmazw3Ck1zm+maeH0LNyimrZ+4D6MMIwmnnpHdh7/InmAwajGhWAwd+Oc3gR/G67R5KzzUzSotOxxhq4mX625GHZI4NOhauXN/cyxsCiWfJa5eeLymorQdaimq7X7MuFs+kTw+Jp4AA/lDrdNOcqasMTNd70twZIQ9xEWjQlYtz6G7Z6JbXguaM5vrqusbHrb+Y/7TuF9Q7r0z1E9mHJCnG2tsFrnQu4OnsZHu9hQraTIw9F+tnUH+Htn+AnQqWrRDRG1kNh1DBOQV5peop+tZzKsW9507ioOfTTO1x4eVdKet2/wV0ZUS/x+Du8dg20BOkUo3aQnNBlCmxejoDPAJYO5i8AAmbdYMLpaPoZk8IXqdr3gWcqAz2Y6bt1OyKRJN2xG+/5lwkbp+vjMfCbsFWlVpcg1dGR9NDCViqa9br3NNt7Nm6gVQ04CABVXyqzNtbz2B85g6ezGSjqPUijwi7ggNtB6rEvqpdmpkAG1sILhxUIqQUZzXhxmZnmHP1UjWWSEqGKx3ucEZmFtsV8bEtlzDRMYQ00uf5rDJKd19xG6FWXCDWHlP+KC/YeVnFgbGd6OJ6X+VZUHrP+4TEGNl/48XZwTRA2Azeu5WwIgPuZ68bpsWTfwLGvGhcGrF5cyEEUbZ3tYOFRlMBl/MgDrFfN+AZJ9xAx3YreNFQO5iv/mBmIt26gTJyluA5iSE883aLqzU3g7pmOtkpq5SH93h8LW4PRExoAGeh+WiD2SztPGBjvnos7UD+TXg9SOaw4RuA7e/LjYNRhtVgxfNc99uSj+NJ5jazb6rpOtRepPX1xOlynQDLWrYfR4p8j3eKEvHJwtuA2aTtCagdTYKCs0zF+hcr1yFUXxr0plQrhmLmKafdsE+MoMqeDCGnRONkCqqcnEVvjWfxrNajZxyKvticK218DvZAsYhxrvEVuaeT9Hscf/38I+TJF95FXrx+nD4O0
 ME1iM7AF
 5+PXi2OhuaysxQWUz2M2zPCHGkeo4l+2YlxBcxf56DJPv8rwhY+pWh+qvp5+R13Op3pCk0r9fsuXYyTnrO312tVkH+klnqQR3a2MPLkSEk5yh+/6gUqsdxZR5SLftqJfinOxsSeXHqKAHLCxd/SU3u5e1BtSoXiE8mw7AEi5bs3yoeeV3xlzRNu5mEZZVrvKSG26wngCIupukzROyrDqv8MjDCXVrTR3AB5E8QpvqEZgbqViIR92rItwn1cGmRyrIHya4EDMND7Lg348p7XnwjKQqF/vptcD9ji4Q09zLvP4Qg3rCE3p7fcNAUPIsBhtdX+GC8lApJvhcQgOK5SDZKPspzjy1Qwd+s2qMoll3g4hZQ9wcQ7FqHdp21D8TJzGKaXi2BbscD7cfXHcZzswNLtYhIxRQ/ZT8EQzI1beW4KOu4JwpbJDf1WnIjO+XKTF7rPIFLOIoUsneTjqbYxSTmS4SE6mfl4qYSePHDFEFrzbicXpkIgSRMMFk4mbVGMf5F5qE6ZxurWNJd5VUEbSqV85OeMzzkMRibQ9w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

HugeTLB HVO is currently supported on x86-64, riscv64, and LoongArch.
On x86-64 and riscv64, gigantic HugeTLB pages are larger than the
section size, so the existing section-based vmemmap optimization
infrastructure is already sufficient to cover the whole folio.  On
LoongArch, HugeTLB HVO is supported without gigantic HugeTLB pages.

Therefore, boot-time HugeTLB HVO folios can rely on the section-based
vmemmap optimization infrastructure directly, without the extra bulk
optimization and fallback handling.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c         | 25 +++++++------------------
 mm/hugetlb_vmemmap.c | 19 +------------------
 2 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c01ae4067e64..8b2bf571e781 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3402,21 +3402,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
 
-	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_folios(h, folio_list);
-
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * If HVO fails, initialize all tail struct pages
-			 * We do not worry about potential long lock hold
-			 * time as this is early in boot and there should
-			 * be no contention.
-			 */
-			hugetlb_folio_init_tail_vmemmap(folio, h,
-					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
-					pages_per_huge_page(h));
-		}
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
@@ -3440,6 +3426,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = folio_pfn(folio);
+		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		unsigned long nr_struct_pages = nr_pages;
 
 		h = m->hstate;
 		/*
@@ -3453,13 +3441,14 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(folio_ref_count(folio) != 1);
 
-		hugetlb_folio_init_vmemmap(folio, h,
-					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
+		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+		hugetlb_folio_init_vmemmap(folio, h, nr_struct_pages);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			folio_set_hugetlb_vmemmap_optimized(folio);
-		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
+		section_set_compound_order_range(pfn, nr_pages, 0);
 
 		list_add(&folio->lru, &folio_list);
 
@@ -3474,7 +3463,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		if (hugetlb_early_cma(h))
 			folio_set_hugetlb_cma(folio);
 		else
-			adjust_managed_page_count(page, pages_per_huge_page(h));
+			adjust_managed_page_count(page, nr_pages);
 		cond_resched();
 	}
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 5852b0a1c479..09b9fd83c198 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -565,7 +565,6 @@ static int hugetlb_vmemmap_pteify_folio(const struct hstate *h, struct folio *fo
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
-	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
@@ -574,18 +573,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 
 	down_write(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret;
-
-		/*
-		 * Bootmem gigantic folios may already be marked optimized when
-		 * their vmemmap layout was prepared earlier, so skip them here.
-		 */
-		if (folio_test_hugetlb_vmemmap_optimized(folio))
-			continue;
-
-		nr_to_optimize++;
-
-		ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
+		int ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
@@ -597,11 +585,6 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 			break;
 	}
 
-	if (!nr_to_optimize) {
-		up_write(&vmemmap_remap_rwsem);
-		return;
-	}
-
 	flush_tlb_all();
 	downgrade_write(&vmemmap_remap_rwsem);
 
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCE3EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869216B00A4; Sun,  5 Apr 2026 08:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8402E6B00A6; Sun,  5 Apr 2026 08:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F7C6B00A7; Sun,  5 Apr 2026 08:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63A476B00A4
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29AF313BF87
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:30 +0000 (UTC)
X-FDA: 84624495900.15.E0D311A
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 540FD16000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=K1ecl8ho;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQZVpg6xJPTStuz2eFGC89hf7AN4wP07MvFFryn7lXk=;
	b=m5qfWXqQbHK0PRmaZgCizVJ3hLigFQSNHWPQZeU56lTo8Tqjzj45olqsVKLL5DNj7ybOQ1
	EQlNJS5GjFfz8NnHmxy0gXHl0o/oBN7WE+AZJuwLEbCHBmUNXAdozA3+M+2uijsIVK2Jeg
	BqFxMct/r07gWf1ZIrcYzWDJtE/2FQY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=K1ecl8ho;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393668; a=rsa-sha256;
	cv=none;
	b=HZrhOO0FhnN6fK9l48eDYyRuoSAQxVs3zcG4shzIpqixBl79qRE9uynvzEi65StMv2cY+o
	Hf4+TkYg5r/dR8tK7Tb940Uuvdfn+d6r2aNCzzkGxTAoeZKC1rd72rcDZhRHN05bKw/K0E
	VpfJyJWJbtfKVoL8j+hzW64Y87T9CDA=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35c2fe0d90fso1787863a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393667; x=1775998467; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQZVpg6xJPTStuz2eFGC89hf7AN4wP07MvFFryn7lXk=;
        b=K1ecl8hodSg5Sy5+cXiVWgKClK73uNo1oUiMuuN/Qm95eQ2HgxYb2o23ehp3qg4nIK
         jS1BEseHlncDJrUFNGGWj1Ply7D7XOCn5yc5C0xgFsiUDbSwjvWmdYy8XWxf9WZ2Z0vv
         TMHNnQ+GwsQ2xsOrNtKFiu3fABn4YI3IMZfypQziO8KJWBUyHxMgzYHjjjgl+TgI0Pk7
         XXskfVaevxOLOd2WBd7tRfj0IUGFSpTtFWHNzi8N/Wi05en5bUIKLHReXGF0oW9Y779v
         I8am2JhG0giy9k4oZO905L7TwST6N+e7/J1rlKD2GPQn/rRY8vdV/4G3Lv9QYFQArUny
         gsjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393667; x=1775998467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uQZVpg6xJPTStuz2eFGC89hf7AN4wP07MvFFryn7lXk=;
        b=cCfuxLsLR7a6bkT1bf0AtpllBW90bcRUJZcv2nuwB960TF4R09Zid7ibL+J5PQG3Qe
         eBcZnQZRZJ33WH2eME2O1cbmVMkNB8TKik3zrojx6qg6Z8aKupT5o/DrfqtEcB1AdVf/
         0TYO+EjZ6xtu1ac1Z2qjTkWYOUfWEKf9u7975SCqeP1Ej8ySR1LGdfET+K1WnqmGmIsC
         H8PnEyPtyXXIl+yszQtlco3wOn3w+xIDmNsz7+rRH74Jk60sxpkWIf0Q0q0PQseuRlcA
         CRYFapZ1NM8+u7s1663Lz/SS1EF/jAUYRbIuZU4xMFQ4qFk5Rvaehn7Wu/b3yPz32wSp
         pLVw==
X-Forwarded-Encrypted: i=1; AJvYcCWnSj9503nWtMqSe5EoOvWaZEOy8bKcRCkYFrGME4zMpUmKVsVNpN1iK5mNQNf7qPvn9suP/D9nAg==@kvack.org
X-Gm-Message-State: AOJu0YzO0QMDsn/D6EJOoRepUM9JDwAGIXjSIM6Hbm0VkiY0a5D+KJEr
	WTfZ1W6sVdjsisHdYJN+HAb+Sax0bCjP53Fp6vQ0bpn50J4x8o0KjRJKrg3KdcHQWrU=
X-Gm-Gg: AeBDievhH0NDMDWssu5zg6o/4jL1Rqc3duDFMOHpelf6vPx3VmbI1PyWgs7K1oZvl3U
	yYn2l2+nGNqyRvLGLl6/nPoCMR4WHpo1ASY5ruWr88mWpJoXzTVtyDEUeDBAW+u7ek+D9Koj/sT
	IyBRKT9edtPVe+And8WxT86ZHoRGa86fcSzOTNzmskZqBl4KAhSe7bYYQGDe1DnIiEqsaswaePm
	3Zosz6/fE/QxamuLiKgFaTXZ3yp1esLnkE4y07Xy6Y07+42xrVQdTh1IIAvU9YXq+jUV1eiOwrO
	GqiSG/1DoxHsOTRh0QlE6CsoHQ2CIgNii3A6WBsgF7f3ZGKHc/LQ6AJmGgqPVZe+HtN3zoUXVwC
	nLMVxI+5NgzrzZCjHg9ahtSHjKA0I8p1mREhDQS9oJlay5cjvFP/B4BRG54J9j88B2kXKGgcYBv
	eq8U9gzH9bFFA71wsDODvpa9bRV2v7tIgkMtcq4WoRonM=
X-Received: by 2002:a17:90b:2b50:b0:35d:a6eb:197f with SMTP id 98e67ed59e1d1-35de660a696mr8364134a91.0.1775393667087;
        Sun, 05 Apr 2026 05:54:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:26 -0700 (PDT)
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
Subject: [PATCH 10/49] mm: move subsection_map_init() into sparse_init()
Date: Sun,  5 Apr 2026 20:52:01 +0800
Message-Id: <20260405125240.2558577-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nsp38wsfnxrmkws6u8addpm5oj9cp59b
X-Rspamd-Queue-Id: 540FD16000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775393668-658112
X-HE-Meta: U2FsdGVkX19QYCajxOTdsbXF6bNe5JjcpNzcnO3wOQA+gPqJp32vOYvOLMaL+YN1JAOB/zKbvMI8cml51rOi84B4oHRzXoeUluRs3sNwIH1Hr/lQAgBILZTewRMe6+5hEX/d1OmwKg8P3iePqSJb472rfs1rW6/RmEmrYpi5AdxOsvhPcDqMdP4QXqFW+bWjTaz+bHoA4/VVOf0athnHOyVXdMhVf8AbaGobI0VYXizkBjmyVtsejcXNxH3gvD4CyzM77O+RUaAYvGJErXjvGr18NhUCr+xkfEnHMjOm8lNTEEY+isQnCwTumPlKfpKGXGDZhFwr6okd2DHcj9WWcyX5Z+CHStBhYI8VBC1afvIdfYGyu5xNwWvCQJ+2oBN6cdVAAV8fGw4oQW6j/73f+40l3zlrmWWP74yTQTfOxQTCSfbSaMokGP1d+Ba9DHoQXqBplWA4lRuXPQpt8kLg6xwN4XBKED9NBAZsxdYAbRlyVyKwi99T0f03GWsGY7hG5ovjwM+iN+Wu6Z/JSxmQ/d7GUZO2WbuqCha2XIEwxRSTuOGU7eXQHP89nORzk0dmmloM9sahLd15DpCisxpdNk473Zrq3zleLxLNFSh+HdCRVGkD37e+jP8Cpq9aSbd/jlrn7ErYeUhykzfdf8fKEQ1N25wBKc29kII78vdU9KfFAPi0WBRlqnI83iiFofjMQRoboJAJ/XRzyFUyn70u0XQHDcCoIp0bhACIlPWV5fgR3/hPdDr4oAKIhX75vbwKNBDkHid5v5H6W4etdYZHLhCXCiYUZAmRmSuVRFB2Y+aVDfnmOcwgqsEPRJZ7Y+mqoPSH73+HhC3MFOhW9vM8awGX/w/pJDxAVesffb+qykfnJr5XCATd0sBYtosy0as0GtPjU3f4oZKUL7x9YFfphtxh/CLpvyrfUIQGv4OR1mlaItd+zyU83bQHufWIkvhHez933aZ5sPVhBwtCO5L
 RHPQg2Zr
 7ePuymxYM5uldD7/vtpo+5VZC3B4fTAPI4RLyN6JnlnMR5Y9mjdAuma3R/Hx54ED1wuFiTUztnTkj3Mf1LarvghWuJanssNhHWruFKnwskACWdiGkvETbLXfv8vqZHpQTygbwiuNqwDHz73i7BCZXHHtrg866LVn+pxegOzDyRljWrUFKzcIg4I7hisHIa1zR7BB/VEtqmnqEE2k3+53h3Blq+56svdZ6jPvh2sZVEauJn0cLEVADvZtNgW9caV5ff/dXzm/sOt71wOnJec07UHfJ0pgh06G7PyEj4f5b95JUiPSXHah5WbybMiUwdYujmAYWUFNjkKFUHV+XwhXi4E7OYQvOBPpgwU9h3Brj9tqPk0xVCuX2KA46XMyFIxoD+o5jVQDB5bohSHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the initialization of the subsection map from free_area_init()
into sparse_init(). This encapsulates the logic within the sparse
memory initialization code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h       |  5 ++---
 mm/mm_init.c        | 10 ++--------
 mm/sparse-vmemmap.c | 11 ++++++++++-
 mm/sparse.c         |  1 +
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index edb1c04d0617..d70075d0e788 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1004,10 +1004,9 @@ static inline void sparse_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
+void sparse_init_subsection_map(void);
 #else
-static inline void sparse_init_subsection_map(unsigned long pfn,
-		unsigned long nr_pages)
+static inline void sparse_init_subsection_map(void)
 {
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index a92c5053f63d..5ca4503e7622 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1857,18 +1857,12 @@ static void __init free_area_init(void)
 			       (u64)zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
-	/*
-	 * Print out the early node map, and initialize the
-	 * subsection-map relative to active online memory ranges to
-	 * enable future "sub-section" extensions of the memory map.
-	 */
+	/* Print out the early node map. */
 	pr_info("Early memory node ranges\n");
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			((u64)end_pfn << PAGE_SHIFT) - 1);
-		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
-	}
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 0ee03db0b22f..b7201c235419 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -603,7 +603,7 @@ static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 	bitmap_set(map, idx, end - idx + 1);
 }
 
-void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
+static void __init sparse_init_subsection_map_range(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
@@ -626,6 +626,15 @@ void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages
 	}
 }
 
+void __init sparse_init_subsection_map(void)
+{
+	int i, nid;
+	unsigned long start, end;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
+		sparse_init_subsection_map_range(start, end - start);
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 /* Mark all memory sections within the pfn range as online */
diff --git a/mm/sparse.c b/mm/sparse.c
index 5c12b979a618..c7f91dc2e5b5 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -424,5 +424,6 @@ void __init sparse_init(void)
 	}
 	/* cover the last node */
 	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
 }
-- 
2.20.1



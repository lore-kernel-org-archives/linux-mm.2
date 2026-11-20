Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2622606A337
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=QT4+/ooE
Received: by kanga.kvack.org (Postfix)
	id CB22D6B05BF; Fri, 20 Nov 2026 05:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88E16B05C0; Fri, 20 Nov 2026 05:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F076B05C1; Fri, 20 Nov 2026 05:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 970796B05BF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:10:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2985840E37
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:10 +0000 (UTC)
X-FDA: 85455076980.23.7AC9127
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id D9E284000F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="QT4+/ooE";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169408;
	b=Gc4T4LpcnaupILzGeWCbHn+RR34XkvGglBtYLue61DG54tE82eYc50pPeBAEWltuVDxvyF
	5Fp9ITUfZsCR5oaL9XEg+ZeK3V7kmu96ZHZf2I5ODQ14K/AT9NKf8za3AkB1p9Xdi6afYG
	/+FNKo0uCv81q/pMaCQWGgApnkH/cYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpB4Cf8Msxqted62VSuaCjYK1J3mdOhPDcGy1wxJblA=;
	b=ms6+RuYqIuxIeUpfaDddfRmutZGtIzK64+fzWp52C+18/+mNugub2FRPnsoy3OKbYABdjA
	Lkq3pF6Uh7YqC9SdOEJPqGoWozOvgSnQ3JYF7UjeuE51S2VXM2hN3aW86mToLrnb9kTWjG
	HlxuPU0OP4qch2CXVusrPfzERBq/G1Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="QT4+/ooE";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdb684859cbso443688a12.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169407; x=1795774207; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BpB4Cf8Msxqted62VSuaCjYK1J3mdOhPDcGy1wxJblA=;
        b=QT4+/ooEm48k/43hVUqq2JQCuw4AphOVUhUtGsPNwmq526tBh2Mr8odAS/QgHOemoi
         esOXeNZd156d48H49SSXeqWdLbyuVl9lz4raqAHRkfYQ32JevB8ACEWPnrHQ5UBth75M
         gAzUHu187wHBYHO9NdFNMKnaOp6Q11vDfMp/CDHQXiMgces6fxTiLoEx522gSGPiVlAx
         SPl6zDNfrHSag1SIc/Br2T3KI5me0TPE1wcKQO0vfmlsyaUWPVD5MOqAK/mqth2h+3c4
         uAoZAjoRZhfGBQEWB/0Em4EXy3b1lUs38JThbl1Bw9zXJVfPAvK32Do2nHfiLsRQAlmd
         aACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169407; x=1795774207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BpB4Cf8Msxqted62VSuaCjYK1J3mdOhPDcGy1wxJblA=;
        b=OIj8cl3Y3sqwiPYdUcxOmQZWGfzUBQPMk36YNtdsTHU3ADnawNThiY1gKeiHgE2KS1
         Ga+KD2bysyIpo0CgdbLPjbl/HfAeyb6l63/ACcVZyL/UrslpKuobMWMwBCtn79/+mrXB
         OvIq7WL9ms+6nXI2sVG7KaRTrOd20LA/9W1HCPYc/Mu9DBr4eUOYyMKmNNQidrucTd5+
         M6eBDcuOozTzw2ANWsaxj/cs4O7aNQgWUi6CF3/E5R8C1sFIE9ENAPQUQinhKsq7yHog
         EVaK14xN7IuVXecd5Xyngm/0dlVEUGOe26td6jMIc2uzZsdnFpSPTUqaPTIPR3TMbM2a
         Rpog==
X-Forwarded-Encrypted: i=1; AL+hErEkjBGj7fUBzTwKUqWW5YDo+695n+MoxOzuSB4AveDlVypzmtUbftmL4yenc+UAdoKee+AGWsiRUA==@kvack.org
X-Gm-Message-State: APuU4Z+syOSLNthb847zaLlE1J0blSG0qCR0tUe7KvlPkUbh7vdq3Ix1
	QDpPW9PioaTZ5CMVRZMa4690OflKi1w6gjKz0g5HVhfReSOpZ78j6B1H1dYgP0TYGiM=
X-Gm-Gg: AZFdTZdLoT2V+qsy7kTty6vNkBO3n4EqGrd7q7pnWXTVYyq84ZX32od1SMJdB/Yhf0c
	nlU9zZ6Qfl46rtz0uHJxUM/2KD1fAUlQRgsi74VfPEwwMYEqIi08jWSmVoMgvu9ijtFIIecXIHQ
	65AN8wM9AxGvpIETDzSJ86Ntk5ozAjaXysJ5lrI+3Fu0hOmsbyHy0pIFV4YtxKNGCEu0avB/zyN
	3jvS2n7KzWwT9whvJ3bKrtDaguFUOzbqJGWDTouOqWRuXMHB/rLc10NPPAvOXYTNZQsKTLZLiBT
	OTXN82YzTvGhCYkAWoas49gELaK7UWIA4czosJFadQ6wnIGSNe0gNpwQK+BR4h06YV9xV6oWSPC
	YZWws9dk7XTuNb/+R34p3v17DskCYAwx9WyMgjyt+DuSBX4LH4cE0oMMInuKdIRw0BdskE4t6Qf
	owR/e+s40Wl/WigMSmv5xDSyDACP2HfahcMpwLNoU25hc6AyeoLEhCM3jamKKioSNhJ5QhaMi++
	aJB89BdXPZwFHtE7MmqhCL1m3IN3F/AkgE6FQCTmF3JFmw2QwfkNXyMoyNnrM7NEoUd/jWkqMR/
	r9Nx+T1x4AcKwmH50Uk0bA18oJbyQh78hQsw9ULSsIFRq4pEf2VDOexPSPiXt+BOCsrTOrUERW5
	eZjw3gCsaAdhXEL8=
X-Received: by 2002:a17:90b:388c:b0:3b0:a378:1cf with SMTP id 98e67ed59e1d1-3b41c9b2d39mr2369530a91.22.1795169406584;
        Fri, 20 Nov 2026 02:10:06 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.09.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:10:05 -0800 (PST)
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
Subject: [PATCH v3 07/11] mm/hugetlb: use common compound page initialization helper
Date: Fri, 20 Nov 2026 18:08:52 +0800
Message-ID: <20261120100856.16929-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: gq7mx98wbat3kpds44bcak1jdw7ayodw
X-Rspamd-Queue-Id: D9E284000F
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795169407-317733
X-HE-Meta: U2FsdGVkX1/8D5jRe8TlLYp01KsLydWVxt2nB3awgdRubA3moGccdfm2Yvk7xrB7K/b27s1lDOIVvKK0F+c7B1mIhVhC0P91O+A+wj2WEoEN7l9gp+ZOg3exrhyICWdE10dczzWybHnirk8UVa0g6Y51nJdX838nxHuhyLUCzrknqEqOpQiKbCVctOJCcTxpbVzMDUNA8qbe/jEyPYk39ghsw0IKeZqojtoNpTjC4bdZzOOVel9G02ipK0glTx3u7HpK2Iz9tkGjfBx/ssmZ25IEUe0DMrJNurVx+B6xUODq09zinNxxeP611VfoHYBE73BOqhsQhtjxQo18nK/v2AyqUYDobbJdAOFecOsPhZOAS1fd5phkLDjP4E1l5KArMn2Olw6sTmJ25eYeZM/G5TNQdGYWwZNIncUYiUcKY4x9TsRk/4TTmpaN6Yfe4Ei8wP+RSrXu5EeAsg1BikMBhfszOunsACu4Ch8MIuxJkX+pqn7ZB29yXryUE/hiQphN4L9RDBbcT9os7/3e4qhGkDTmOElLZhyuJSHG2PFrh3XipwJ8x5DimfgF912D8ebhrFbdb1UQMyOGttQRViS1C4SB9MFNwaN4yR+wY5pdiyDY9n2ua3gHFMSln3vz1YyyBt4k0RKvygDGKVzSVub9HtIAoGCkqd6tAcUNp95WriGb4ADs+0uby5UyxIHWpgZCsWsEN9mi9QKfYDdAJ3JYGEN0dhFCqENv8bqATZxLzSNjBKbg3QZuLK9rRVxWsz57tIy3knbwZZ9i+YLtYoUEz1wz1vyu1QEzuvjOeAhVRVEs4PbjKwXblv1C4NXvPR3vvdUCMtTf4OQO2nt+IRPVz0E4zS/JnzC/GIO7uwxVoJTzRvdAqOtcOWZbmUwvcR4LgTnMHuTvgF81EnpXgP+58auztHYzgfHihhYpKv2Ujzya/YK5ewZHdxtC2P15KZL/THtSPTG4i2PTd+7zeHJ
 +a+E+0OQ
 NdcL6fMYo/SBJFXpaoLTnQIO0AwLnTEtM/re2whiJm8cHYShPcN4i0nhtY8sQy3W4byG2DAgho64Dwk73sScaxT7we90MeJL6lkhWYEgrb/RgCwJfsvjxrfMpF6wk6aMbkoXhYB1p9WIFG+pazqWm8gzZgzfckoRqcTHoWeXn2LWQzirZlk/7VfT3nZk9MNf9CNY8BRwPp/TM6Ygg8UzV4Ru03ZE5ZMV/uIwU3qmmuGrHir9n93piV4hzj33o8BkdIzPOHoA6rBe/poRP634tDlsFtZNVxkrfwfIUVZzOJaYBmZTMDyAyRb3ZgTQKNqI/fkg5MPDlgor3lR95OzbnIglvIJgzbbptrT/hdpYhG0nQhBk7kIxfoa03ZqSXvOU1u/lMXxvuLPHZEl/DxSFvSAUb0jLKunrhi6IO/QWfZA0cVXPvMlhDwEJrsZK1IHC5h+bQ9gx3JIHiRHBgGlR5b6h/MNKlpowK0syBgKh9B/rriuKiKT/qT/pafm7yd1cjVhhqno1pl/umqADRS1hrkbNOmV9w/c4ss0mO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time gigantic hugetlb folios currently use a separate path to
initialize their compound struct pages.

Use memmap_init_compound_page() for these folios so that HugeTLB and
ZONE_DEVICE share the common compound page initialization path. This
removes the HugeTLB-specific implementation and improves initialization
performance.

ZONE_DEVICE initializes struct pages by walking one contiguous memory
range. Boot-time HugeTLB instead initializes multiple disjoint ranges,
one for each contiguous hugepage. Measurements showed that memcpy()
performed better than memcpy_nontemporal() for the latter access pattern.
Therefore, use memcpy() for normal memory while retaining
memcpy_nontemporal() for ZONE_DEVICE.

The initialization time for 64 boot-time 1G hugepages with 4K base
pages was measured as follows:

  arch    without this patch  with this patch  reduction
  x86-64          195.60 ms          170.40 ms      12.88%
  arm64           374.40 ms          237.60 ms      36.54%

Co-developed-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v3:
- Integrate the template-copy optimization into the common helper switch
  (suggested by Mike Rapoport)
- Use memcpy() for normal memory and keep memcpy_nontemporal() for
  ZONE_DEVICE
- Update performance results for the integrated implementation (measured
  by Li Zhe)
- Add Co-developed-by for Li Zhe
---
 mm/hugetlb.c | 52 ++--------------------------------------------------
 mm/mm_init.c | 10 ++++++----
 2 files changed, 8 insertions(+), 54 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2a94f8f60870..6a613d9c9332 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3319,50 +3319,6 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return true;
 }
 
-/* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
-static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
-					struct hstate *h,
-					unsigned long start_page_number,
-					unsigned long end_page_number)
-{
-	enum zone_type zone = folio_zonenum(folio);
-	int nid = folio_nid(folio);
-	struct page *page = folio_page(folio, start_page_number);
-	unsigned long head_pfn = folio_pfn(folio);
-	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	unsigned int order = huge_page_order(h);
-
-	/*
-	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
-	 * we must initialize them ourselves here.
-	 */
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
-	}
-}
-
-static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
-					      unsigned long pfn,
-					      struct hstate *h,
-					      enum zone_type zone, int nid,
-					      unsigned long nr_pages)
-{
-	struct page *head = &folio->page;
-
-	/*
-	 * This is an open-coded prep_compound_page() whereby we avoid
-	 * walking pages twice by initializing/preparing+freezing them in the
-	 * same go.
-	 */
-	__init_single_page(head, pfn, zone, nid);
-	__folio_set_head(folio);
-	set_page_count(head, 0);
-	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(head, huge_page_order(h));
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3420,8 +3376,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = PHYS_PFN(__pa(m));
 		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
-		const enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
-		unsigned long nr_struct_pages = nr_pages;
+		const struct zone *zone = pfn_to_zone(pfn, nid);
 
 		h = m->hstate;
 		/*
@@ -3433,10 +3388,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-
-		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-		hugetlb_folio_init_vmemmap(folio, pfn, h, zone, nid, nr_struct_pages);
+		memmap_init_compound_page(page, pfn, zone, huge_page_order(h));
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3e645302377e..8bf350d5a695 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -722,16 +722,18 @@ static void __meminit memmap_init_page_from_template(struct page *page,
 		unsigned long pfn, const struct zone *zone, struct page *template)
 {
 	/*
-	 * Refresh PFN-dependent fields in the template before the non-temporal
-	 * copy, so the destination page does not need cached stores after
-	 * memcpy_nontemporal().
+	 * Refresh PFN-dependent fields in the template before copying it, so
+	 * the destination page does not need follow-up stores.
 	 */
 	set_page_section_from_pfn(template, pfn);
 #ifdef WANT_PAGE_VIRTUAL
 	if (!is_highmem_idx(zone_idx(zone)))
 		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
-	memcpy_nontemporal(page, template, sizeof(*page));
+	if (zone_is_zone_device(zone))
+		memcpy_nontemporal(page, template, sizeof(*page));
+	else
+		memcpy(page, template, sizeof(*page));
 	vmemmap_optimization_verify_zone(page);
 }
 
-- 
2.54.0



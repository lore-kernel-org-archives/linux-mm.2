Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA11606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=RXS25dYf
Received: by kanga.kvack.org (Postfix)
	id 6D3CB6B067B; Thu, 12 Nov 2026 22:36:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D3B6B067E; Thu, 12 Nov 2026 22:36:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570786B067B; Thu, 12 Nov 2026 22:36:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F11446B067B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:36:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC3471A0395
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:25 +0000 (UTC)
X-FDA: 85428683130.08.CE60A57
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2BD1F80002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RXS25dYf;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbL+rkfXz3c48YpcD0yByu0+R0Meu6xgHsW1cv593pY=;
	b=Aubky4Lkq6BkU0Q1qXGLHN6YhzaZUO38XRaqJ+Z6mpQmKOVVkBSOSATT0S+K+7nncqKThg
	Pp93PkqLsxMjf7b/lvvzQrKDXvvnI9khkEOwUMdcFWHzYUY5M73oYtnxwwyLFvxeX3hRWG
	iH3JjhfR4yPEr6FRsTLuywpfw1pY9PY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540984;
	b=PUc3WiYV71z7em867loO8h7xkIqzboCks0kVv2wtahiPTgXzFNzZP+RTyV32dBg921dCdM
	n2rRiKvQnuuTjEN8Yj0tsliMA80GjU1nz/vgkpT54Ywt8BIYUgpmEE7dYlEtxaR82E4BpJ
	TpJm3hRPWDZBVIECrg3b57jNvAeNiRg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RXS25dYf;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso1349839eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540983; x=1795145783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gbL+rkfXz3c48YpcD0yByu0+R0Meu6xgHsW1cv593pY=;
        b=RXS25dYf6oSerVCTlDy+jKdyqRZkUj+E7Qs/+/L58zQFwpa7He2jXQTKoGvWz4iRsD
         E9IVRZHH4QrhzeBsbot27PvnAkGBDxMeTn4qY4MJul5lFyC0uh2YUCXvZKkhmJjSJob4
         K9J2R1LYBKa/1hDlDAt+8+0IAlmNWGd/LU5Ik3F8Jyr7akyAeMCwYo5xppnM53PYIaYn
         bdwDQOejqLDRh2c19saK+fkgyRPBD/Uo41CKxCdZEDsGcgZ97B9vWbphj/IS88ZkYyXb
         9a0LMOel+XdA9zbcOUCXdNWJDA9vmGHJU6kYYSxJ8luDHszqq4FwiB/IymBXBTOMAPUM
         r80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540983; x=1795145783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gbL+rkfXz3c48YpcD0yByu0+R0Meu6xgHsW1cv593pY=;
        b=i3wpXYzRTzQhES2ZuUtqKMAbVEcFrkz3JPlMK4Wgz7ztF0pUmbf4Y7wNKjEI9P334F
         Fqb4cL7b3+uyJyydYYDJALYzCJGKF9b0ZCXnX/2RYhUUcTfH/WB+OLVG2WB8IAnh8nZ0
         Arod27b9TI6H5AQOEtUe09Gqqc91cJNGGH27nTiwG6Ys8xJ0GGUNLjVd+ll6z+m/ybK+
         PzT+cLgc1386LX4KrP2UMyDm78EdNAVSR/OYycWhU/+olfjsbhIZ+7l7dJVF/kAQHwaK
         J3QLdKVOneMS4mizg31sD366FQVh5BYnwfKGVPjgdzS7HDDJeRG+RqkvnCw3UIr+Vw+7
         jRXw==
X-Forwarded-Encrypted: i=1; AL+hErEuIGuHNrr07ORm2Ut4FhY5qLOLkcs31eddYJx7NQMQSNLzKeOhTA4rGRyzJE9kBZ9z6iHRMGsdLw==@kvack.org
X-Gm-Message-State: APuU4Z8GEcBHFV9u4msE2MKZIYRZNTysA8uRFYHYi8Ef40VWiozCwTFp
	lmbnlZUG7HF9XN0s1tt/a5mLfySFSDdD2YPUGSsePyeWYbedhoe2es312HyNfzkXWA4=
X-Gm-Gg: AYBFou0n/lIERH+HMOvv5GkTqXeV9KvlRZv3WUciSP45tOxN1gIN4AimVnXbZzGlaAJ
	4WwrDYtV01lvF87nbVnBhGNMsahb+SH34XxW0E7MQKU25PWB4OSRnj8BnhouavTCEm2P9GfiI8n
	ZZwbMtqcfIXokEnsRe/te7UMMnzYRlUTdZwJ3jfQHCDt4qXqYBA2XnQoZe8Op0++Ki0rMsWublo
	ruC+MnIUsV71iBF9Hkco0OgK1+C/3w4Xd/+C1ClkMcctbLZ2g9P+NI4mdZ/nGqx8gTVwi63KcYl
	vYZVqhElGwMb48xtFOaxdKb/D/g7cPsQ18pCH2cI7UxLV9DTmpAMFoD+E0YDBSJ0PsTf6mXCDUg
	EzLUkcwOLelX2TjZac2Ma5F2xXLajoVojNktgGz+ayx9MqeS9WftUn3BmwouxeCKZukPteA8/Rn
	p6K2n9nPlXSc8eVyYDW+/wWAuM9z2c3CGhVHAaDXRN7Kr9pC/x7aO7gjDB0l7FrGhZS7xqk4h9G
	8fpmuHzIp43YvAk4Asx2gRQk8UFSv8U2Ntu47Ko4zpHxaf5SjaBDIFqB6gHLyTnMYSribbntJAD
	nO/UQ2RVEZOEiojwLlFa05XIoCnOWypEGTIVq5ym3B8q1mpB4yeADamMH5gvdg==
X-Received: by 2002:a05:7301:db11:b0:369:fe4c:b48f with SMTP id 5a478bee46e88-3796047be6bmr1058848eec.0.1794540982398;
        Thu, 12 Nov 2026 19:36:22 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.36.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:36:21 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 14/14] mm/mm_init: move pageblock migratetype init to memmap helpers
Date: Fri, 13 Nov 2026 11:34:42 +0800
Message-ID: <20261113033442.62970-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9fd8ykob71yrxmtciouagw7ib6c5domb
X-Rspamd-Queue-Id: 2BD1F80002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794540984-493345
X-HE-Meta: U2FsdGVkX18BJEFbn+hQycqw0A75vb33eWgp8jETMdUkqb+ORaUC+etxjF3in3gzbAMmKTM8VxYQ2355oEe/nyrP9dQIBGVfWfgg5rCNHNZCjJ3E6mUmCm/D6r9tJcLJLNs0528QI5WdkAX0wcIKl9mYu0hv/Tyk0wMrYT4joLf/h2WiSVGTb9qUMfIRadsalN72yDO4ro+tbyCXGJZQBnTAnCZK3mgwmYFBzsPiRKZfAlk5Ekm5S7RLQDII6Py3RRuoPQu9rku6uIY7Y2zFTyEKa9tqDDpL8x+R2ykCd4G5R14HeZHz9z1XwkKfSUWOUb01fOZSMm7BdP/wSi6kfLANMlWrTYIEhBjqlggnb7UmWQIQDNWBT3vKsasBDA0DExkd75N+KWkKdlg293AD3M3UsLo0HztWkrribOuK96aL1SDNj4SX79PLyOD61Tn6F+M+TdCnvH7GiVBb5ebLWKBaOIT3doVbaVGVKz49YUjiuNn3F5NwKvcLUy0t03hlMXToNCwRPy8ngcjX7LAFk8OZYLp7fo8KokRB19vuEXOlEVME6IY3m+hwaB/wYnuIDSGOUNn7GKI7JeEf1pPtgcT2NmoqGAhJGdhVxHMxmnj/KX4uO6JiechPAxJdqkiovrw3ldhpK2BPhtYqr5f/qtNfcxeR3aUo04KwjSXwf9XEZ0yMZwoqhQXjV9vOplWlAXagek/id78bwllBDyqY+Z4DRvcGByh9vdf0nVGUyfKkiE0SipRuHWeFMqF75bPKEimxNDEErVIb7Rf9WrA5CPNxZjbFJUm3fcvGHiT47ra8ayXDWU68rnETMLmbsaGjONYlsqZvg0ZRSYBZx0PzCgZt2TgrbxGhqarAhD5vaNfxwrC/rXXOFu8ngl3dzQVfsLSDLQ2sJqw+YIPoZZvsKMPibmciUQlfqWAO4IP3NszkttKPN4LIDwpZQT7PowVfEIQ77iKmBE6Q6jqnpyz
 Bi/WqUlv
 sSnJ7OBfiwYqZyNMJ1AXEsdaOkVymRSrr5/tsguJkw1gprignoFkfrQqqDBefrG4qt9zx5FhQp40cgtaeGvSafAavRhtnSVp60zkWp1fIrEJdr4F+i7lC0WIHAHjgZ+zSYqttPR+V9pgkVPCwWyeuCgxR+P+tJSVL1MWwg2mpTqhAouL3Ok+50DznaG0cxnyDZgrOPS/Z0wJszzRs8z5ewZegszCuSxvsTtiG0lBeGhuMegsL7ln2aB5PwnZvHgJ/T0PMMA3fRssxyHUOhKQBGUr1wCEBFec6Olfsx85bzO/q0csUaZpK4ffl5dEMCgK5QUiNWWuY+G1ewGgGFIAlbIWrvPhW5DlaNcZH9O6su2ZGX6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ZONE_DEVICE memmap initialization already initializes pageblock
migratetype after all struct pages have been initialized, while hugetlb
bootmem folios have their own duplicate bootmem-specific initialization.

Move the MIGRATE_MOVABLE pageblock initialization into the frozen memmap
initialization helpers instead, so the ZONE_DEVICE and hugetlb bootmem
paths can share the same initialization.

The old hugetlb_bootmem_init_migratetype() skipped CMA folios via
folio_test_hugetlb_cma(), but the shared helper always initializes
pageblocks as MIGRATE_MOVABLE. This is safe because cma_activate_area()
later overrides the migratetype for CMA pageblocks.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Fix the helper name in the commit message (reported by Sashiko).
---
 mm/hugetlb.c | 25 -------------------------
 mm/mm_init.c | 11 ++++++-----
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f70c1373235f..a2b0912290f4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3249,30 +3249,6 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return true;
 }
 
-/*
- * memblock-allocated pageblocks might not have the migrate type set
- * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
- * here, or MIGRATE_CMA if this was a page allocated through an early CMA
- * reservation.
- *
- * In case of vmemmap optimized folios, the tail vmemmap pages are mapped
- * read-only, but that's ok - for sparse vmemmap this does not write to
- * the page structure.
- */
-static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
-							  struct hstate *h)
-{
-	unsigned long nr_pages = pages_per_huge_page(h), i;
-
-	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
-
-	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
-		if (!folio_test_hugetlb_cma(folio))
-			init_pageblock_migratetype(folio_page(folio, i),
-					  MIGRATE_MOVABLE, false);
-	}
-}
-
 static void __init prep_and_add_bootmem_folios(struct hstate *h,
 					struct list_head *folio_list)
 {
@@ -3280,7 +3256,6 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	struct folio *folio, *tmp_f;
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
 		account_new_hugetlb_folio(h, folio);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9a51cecee547..e402c5ed3152 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -759,6 +759,9 @@ void __meminit memmap_init_compound_page_frozen(struct page *head,
 	for (unsigned long i = 1; i < nr_pages; i++)
 		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
 	prep_compound_head(head, order);
+
+	pageblock_migratetype_init_range(pfn, 1UL << order, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 }
 
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
@@ -1119,6 +1122,9 @@ static void memmap_init_zone_device_basepages(unsigned long start, unsigned long
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
+
+	pageblock_migratetype_init_range(start, end - start, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
@@ -1156,13 +1162,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		memmap_init_compound_page_frozen(head, pfn, zone, pgmap->vmemmap_shift);
 		memmap_init_zone_device_head_fields(head, pgmap);
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
-			cond_resched();
 	}
 out:
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
-					 /* isolate */ false, /* atomic */ false);
-
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
-- 
2.54.0



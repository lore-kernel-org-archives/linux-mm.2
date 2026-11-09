Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E8D606A334
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=BkN+oTVC
Received: by kanga.kvack.org (Postfix)
	id 79BE96B05DA; Mon,  9 Nov 2026 04:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773FA6B05DB; Mon,  9 Nov 2026 04:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689BA6B05DC; Mon,  9 Nov 2026 04:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4DA6B05DA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:59:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D94C7A7EA8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:59:08 +0000 (UTC)
X-FDA: 85415132376.09.0CC81EF
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3E50C0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:59:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BkN+oTVC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPiscvubWXhHlJMFPIJv7vibxHEUj/a3SUt82Fx330I=;
	b=iiPqewBOavrRzeOZTTVZEH6gx/W3Kb8st4AsbsofSnTTAJJY1dIVyKTIpVbXOoNWeHAlzR
	MAOvt0SBS54gfjJ4r+Ay/REMjYA4sUlbW0LyKAj3nncqTaYxlQqgZcqenOgqezMuDDX6Ak
	y5pzHnpC/ItisyDgfV2yJG9UOBPaTto=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BkN+oTVC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218347;
	b=CWVg2sL1oIddNwZ8/gDD73WAAdhht+SkRu1wXFxeEfd024/6NQzA9XKKQWbe4i/gYUt8Be
	4LxIql9vusZpXaFdMUQ7DYBVTXorriPgrOEMxy8ewhb9eqQBVDoNvRPO7SVwMwSbV1NN7C
	Z3RecFxhLthvlob0St1ZX/8gUVK3VGk=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1a8cc11ac42so484323c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218346; x=1794823146; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YPiscvubWXhHlJMFPIJv7vibxHEUj/a3SUt82Fx330I=;
        b=BkN+oTVCdtJG4+yYV+M1UGmEB/1akcvGKHLxeVmDubIwiK9XD8deb6e5IpBhcgRFmn
         0JQCTiORQz7qm3mCb1i6phCOV1qWgR0Y0bo1zwbEsFLW+AaPTttS4QFDyo3w7v/O6C8b
         VUw0bzr7dQAEB1UrDogtgYR7bKpnaXBG8CwbsUiEqABRV4tccfUtq0yr0/7eqCyfH7dS
         6D/gp8IDwOOChscxFfhBbXAjoUSoSHrKKpn3RZNFZg7KR7eNOvd/RXYaF2cVgL+JF3bt
         q45q3Xt4wK1zKksqusd6ZOfCQhVfNEX1nQA+GvPnyp+X/kdhMEKFLqoG4V4jZgDi4m+Q
         6dPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218346; x=1794823146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YPiscvubWXhHlJMFPIJv7vibxHEUj/a3SUt82Fx330I=;
        b=inP5q04TSWOf7EW3ZVfbUg/1gA1kGd0Ig7l3JYGueRFWCawDWrjepAb0N3/vCrXlsO
         a6PQEwuHXVY8YKgBhLrnxXmY77oC6RCfFfLg/+NdFRpBORFgQA4HjzHcyuYdegzcqGje
         xrMrPxYXkWqzLhYOMpAFZVgdn+5fpBVXPoe8EwFqKQpOBx2FCzzOx8ZnYpSKV5YAH4Lo
         59kuCUwB/cllT50zp0NJDyilDmeJkA3KkHIIrwoSmKv6i9aO3a+on3SwQbpd/su5CKZ0
         4AvFUyPq+eFtvqdFJPwnTScUH7J9L/Oj5ak0MClY0OgMplRGYyFNMYODGl+nH3Ex9kEA
         /6SA==
X-Forwarded-Encrypted: i=1; AL+hErG2Xq5F2NZpbbWMnTTuCWGGFvpxHTpylUCVWDfridLLjL8MZIqjSCbsuxlm+C2sA3b7U/86ZAyBOQ==@kvack.org
X-Gm-Message-State: APuU4Z+IzNPRm3s1HwfBRTqN3Al2xj4HhHgpF6DYWGQ3qTRlWJPPF+qZ
	/KhseL4UsrAseehCq8ezD/bTvnjpD58Y8kDIcfIAbP9ae3C9c2hx73hEioeXZO6/bGc=
X-Gm-Gg: AYBFou2ZBS+CRvmkSA4UIJkhey8xWhMyx/UDu9vrQUmkijpMzugeelmCIk6TXUOhROg
	iTaI4KKfuSrB5LYO+UFh8VpgF5VYeorW0np/gXwrT77DzdLaIY4ieuMKP8//cmm4VT2Z6l2/eI+
	smlmd/wSQRWbCFiXxQRaBlSB8O/hiuIlXRh5dM2eKH5d9ylfO6BQsj3IQUYsm17bTXPktLjYnvg
	2SZdR+bVCZqMJhjr0wGxJz1R+vOjnCMFefndIryvoNVDuojTskBltDnzYZp74o3TTIs9iP81Sr0
	tTRvTfkfBUukffeAtQViDwfLdorE6SDZ8HkwTBC+fAS0YV5oxXdfuYcTb8qTUgxE1vPaBimgGXw
	FGsztptSomRNXjzjC5+U5c8I5n/82rbKJ0IqP12grL+W7WcCSEXIww//OGRzO81BPqlIgU+v8KA
	chqQ6X0OUlplZGACTTDH4xlGA11v6g7IEhQ6VH7YSp9GAnG4N8/VIVuehYr58TfxBwA8AnhysEx
	lAgL54JmT94SmVuv/6s8+/dZt+ZW1dgU9zepoxgdXGfSuojH12qAaY7UYbj2VW2ZqE8S/M0dHse
	zXkqQOM0yd2qR6zWCogLZapc5g6hAM6VNG5uMmYlvKn45zGuueNNYM5xEriX5w==
X-Received: by 2002:a05:7022:1505:b0:1b2:cb38:5412 with SMTP id a92af1059eb24-1b39fed4847mr6729682c88.42.1794218345436;
        Mon, 09 Nov 2026 01:59:05 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.59.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:59:04 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH 11/11] mm/mm_init: move pageblock migratetype init to memmap helpers
Date: Mon,  9 Nov 2026 17:58:06 +0800
Message-ID: <20261109095807.41547-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3E50C0005
X-Stat-Signature: qgweraadkr54jjkpqbjdnt7pb8zyak1x
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794218346-813093
X-HE-Meta: U2FsdGVkX19M3QJYtuoRTquQdHzY30zg1UwSDhKbTo+IZvkRUiEBeR8PCOfto7c2iDmnqGUtu+7sMSjplKVsMRWbyVTmu2T9XdiaEo7ZCEJfApC8aPfIK4HcJX7U/7Hq+d/cah/x8zW/4JdEvPMX4GQylk3zgfa9/41FY7GIES+g6+n/rtDoVCvJ70NY5+EcyrTRTqZxoU6LY5SeRl7ZL6cP2L/6k4UJUYVHpX8M9tNUnsGCW4gRLhrNQCX8zYu68qfxgeTieGsE8N2LW1LN90186cPOlFVhqPmZ9H+i0xwkNXwrtTCAq2eleUa3YJSNGTUtXctWdob2cKurQB3l8SoPtO3CB8zaMsTmFzEoH2btcisUgvKKYqM7sBAKaQlNtsyTdfxL8oRLAnrAGx+MelD9rrtrnlWjdX6UA+uwqbhFKkPlBUcOuc+z+CQ6WU8AAHIwOQpeScPdww13/wE6FaGUiMfN40y5IazyPFbyo8DPvNxPMBPGjjP5SMWH04EskBpqGOH2DbQbAFb3hwuv9/xg+GgpmIFMpT+GpOgD0kd5Rqclagguk4eWdeDdv5M+1joO40wjmhOMqDNE8nxcQjVLY7QxH0yPloJeSYbSOZX/XUKHmNN41yHB9dWglbMqA5KEHH63hdb1aZJpF8zBy3Hff2fM6OFhNyN5AfpwyDmZwUbuXQSMpTNPHGaoQZx4Nj907YjQn9Ck7Bt59HUAtC6IqMcL81N/ie0I2LhOR3NNDHk/YJMujiuMKzJ5Oo59Re2Vt9cqy6CFApr5JtxPYLsGSA0rrbJ0aAMEdVmDz0t6B0f+VTp2U2jPHEOzNvJtAoVRPm7dJlKLWQjvAq0jjIENmXPIkWy7ySuivlCvCoy8jdJcZQ4jQltG+P5gP8j0A07DCmVLbp78LHjYDFeb1x8E7myshOD1v6WMzwwPbWBhWxRZxfxwkJzjXS4+8ERFAoi1ZW5/TMpZtXnYQnT
 iOknbEaN
 rfZgRzwlDS5QGswchMDeBvwuWJ7b2dv2V5KcrTw8Or3nRMCowyt81ycJQPWrMWrkg49gipsH9gizcUY9SA8Rriqn/adnh2vc0fMXHpuQVRy9AOnmp7yqTMQ17mYXR9sscCXwwBURXU17Svj3K4Lf+3gYCMOOQa/ZrlaNyTgUOzV9dnRX2IYFaHONlh3M3RZcpDhCjinhE0l4g+W61mHN+WpmXe/01VVwl+VjulW4VLo/A/BskDODvOX84T2ehhaSuwmws3/UAZ4hatefMxYXVg3xYzp6ITlWrpSOOu9bpZrJHr5GooTXaS3MldN0jA30m8ZOZYazAXB/k0L8VKh6XZV6YBkK/AFKRZOZvZHVEogebMJU=
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
initialization helpers instead. This makes memmap_init_page_frozen()
initialize the pageblock for single pages and
memmap_init_compound_page_frozen() initialize the whole range for compound
pages, so the ZONE_DEVICE and hugetlb bootmem paths can share the same
initialization.

The old hugetlb_bootmem_init_migratetype() skipped CMA folios via
folio_test_hugetlb_cma(), but the shared helper always initializes
pageblocks as MIGRATE_MOVABLE. This is safe because cma_activate_area()
later overrides the migratetype for CMA pageblocks.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 25 -------------------------
 mm/mm_init.c | 11 ++++++-----
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ee47a3b09df3..5dfe9091b5ca 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3222,30 +3222,6 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
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
@@ -3253,7 +3229,6 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	struct folio *folio, *tmp_f;
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
 		account_new_hugetlb_folio(h, folio);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 61a720bb44dc..e05db8abde2f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -751,6 +751,9 @@ void __meminit memmap_init_compound_page_frozen(struct page *head,
 	for (unsigned long i = 1; i < nr_pages; i++)
 		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
 	prep_compound_head(head, order);
+
+	pageblock_migratetype_init_range(pfn, 1UL << order, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 }
 
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
@@ -1110,6 +1113,9 @@ static void memmap_init_zone_device_basepages(unsigned long start, unsigned long
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
+
+	pageblock_migratetype_init_range(start, end - start, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
@@ -1150,13 +1156,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		memmap_init_compound_page_frozen(head, pfn, zone, pgmap->vmemmap_shift);
 		memmap_init_zone_device_head_page(head, pgmap);
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



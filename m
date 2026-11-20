Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35427606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=lTbZNw0Y
Received: by kanga.kvack.org (Postfix)
	id 5124D6B05C6; Fri, 20 Nov 2026 05:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9A66B05C7; Fri, 20 Nov 2026 05:10:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400336B05C8; Fri, 20 Nov 2026 05:10:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16BF96B05C6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:10:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAE3C1C49B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:41 +0000 (UTC)
X-FDA: 85455078282.19.B9F229D
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA9ADC0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lTbZNw0Y;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169440;
	b=IcIsPxeHhnzL199MkQ9InvE4KvSQvwFpANj9bPXwOcQWXsqBlDkCohASTEUSvfM8lk1dzP
	IWtms4OkfjrAquCDf+USc5PW1hdx1ReuGLCPDD1nTCejo8c5dYvUDHLPZhJe12WGt7U1+R
	IEPUErzdsxUCYTkt8Rft2yZxZ8oWSPc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMd2ZKHygottbgUutQoHwDYpPTm4RywCiNppj+OXuXU=;
	b=2d3rK4NYjGzYrvBox6zZxbWeLk0wASkliOlejvCp2MpRQivywPehRklJKcsA8vKDnvTDhi
	b4OLV/W1LMDjPi9qEGvvrrtq5LhFt/Xe65cieF+U+2jxeqdD1v1Lx23Vq7xF8VZDD5JEdX
	FnyBMGR4xuJ5J9A5NAQ7gjpVSgOYL5o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lTbZNw0Y;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3b41188c8b9so596311a91.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169439; x=1795774239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WMd2ZKHygottbgUutQoHwDYpPTm4RywCiNppj+OXuXU=;
        b=lTbZNw0YTSfNa+y/Du4TEXiHno0TzkTEdz2q1US8C44pvfR3JtjZv3Jcz+QRhDFAdM
         J3z9irtjr2/0n+m45QKMrjJVv1W09r/n88MkK5Qaa+jhoS9OldqfgNCGv4xGs1/NwJgp
         sU51uICsOAjhsgmAYPRCCLdNtfkdaGtYWcZ9xHaco00atVws9s41AwpkbYQNwXriOEE8
         rgw62wERc9EiThzIc7bO2IKycf5DMX2jMA1aW6pPdJkaX5Ez5RVLTlhIQGKw6VVb8aeW
         +4BA/dUsCQFFQbzx2VH6N0Y/LuuscaFDqHPW7i1TK6AhT28zsM6RmTD0H0wLhlnG7K0S
         o+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169439; x=1795774239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WMd2ZKHygottbgUutQoHwDYpPTm4RywCiNppj+OXuXU=;
        b=vpsO28xyBrEfT5nTi9Sj93NwTGFkvOiJ+cofeiLMtuAESKqHM2oKLtzOO2rs46xC7U
         X2d3BszkEUDFY2Kmtfyr/LmO5KmAkviY0HCQA2BE2b5VZWmcbYVrBcQ3nqnS09CVi64S
         KDHAjAcZq3UCMr/ebRhiBuBO3wlc4030hq42EZtoALjS5fUlO7v1AaH9DYFZrtTomCHl
         452c7n7zy0BynPwOQP+rs5xzpidKDMN1FFqCnbLEEfuGvoDG6+E0wC9RPClo80aqliHe
         +QtzAKdCyRmAgLTekoIBQLsFbM/Tqnvj+jnIJwLcUPj9sOxeUXYHbl38PZOz/GY3cgsz
         ie7w==
X-Forwarded-Encrypted: i=1; AL+hErHFa6gyeed1P2fvBt5z2cAHiFAIUlHJIhDLlJFF29HRctMat6RZrTbt/IoZmJV5Eou5wZGIJIE0CA==@kvack.org
X-Gm-Message-State: APuU4Z+jtlbUh2UaaWMmiNa5oVaHLWWfeinIcQ0y84xTlUJmde3virW5
	NeXqWsNJO4WVdrwvHFniF0iRsd6UapFwlR0bpxf9vJEjvDpmbQ/jy8ky8jG6Vd0AmnY=
X-Gm-Gg: AZFdTZfkookomieCSbGSv6KbcjM3H8yvcYq7IRRPpePt3p3uozU290YWg2MVAN59ANt
	7rHZvkyLPIGp7DeipKPHwYR82FIAh3vM7E32cj2+CuFq+T9XDNAtg+/A1FjUFn6Qhqlrzw5bQ9L
	/DrsKBpioiwIEbw1e20ooKO90oijkeBVgTWVtE8kJiXmBZ+g2jTQd+NqVtCW1+Oxsz4txwwiaX/
	6LX7F+m0EDycnd0nQI+EW8FfdevqTxgO3c739RnZGOhjg5IztO51ukJKhhjw0XhliGpCxZp0u+A
	cMKH+FxvQaafvuX6nzwAhaqAqdhcfVeSQxDgFWXUxN+MtI4UbWeSP78i4YsoisBH56HZrx/DvWp
	28FnBl454tHW8lhyRikni9SJE4jrSMMdzoY2pO41CSwwjvAl3p6/cUIa49NPQ4/+CCzuFEimaHQ
	e0uPZ0A7Auo2aq4QR7AbSDVAEf4ADG6rFPfNn8umJYSiXXd1rFNsDAg3IjzCIpQmSnePuGegdPZ
	HLsbZzVlaDVsCq0+yadveGZvod4nEJwNLk9JLTgIukkJ5PhXLT7XZ3YoghK+tcoc+3N+ZZ2XMy6
	W4LhVNmYLSmOPYhaSW2a9k3FKtKIAc7mCeJLRxwQqfjcrz+AvnwMImcD6t3qF4cAwOLWIgyQWQm
	yZHa8wuvl2soDiWM=
X-Received: by 2002:a17:90b:1dcd:b0:3a6:e901:e79b with SMTP id 98e67ed59e1d1-3b41c8d9bdfmr2328610a91.15.1795169438641;
        Fri, 20 Nov 2026 02:10:38 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.10.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:10:38 -0800 (PST)
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
Subject: [PATCH v3 11/11] mm/mm_init: move pageblock migratetype init to memmap helpers
Date: Fri, 20 Nov 2026 18:08:56 +0800
Message-ID: <20261120100856.16929-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e3cpjgyar3e9fsrmca9j9qqhqh971o7o
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EA9ADC0008
X-HE-Tag: 1795169439-291343
X-HE-Meta: U2FsdGVkX1/LkUj6z0uRsB5JIRpQkWSN0+GfxzUBl/C9P77DKt+mvQ5boatgOeQ8qvJCmqSJRRCsrNVQBmEhegSdh+WrPRqA8yGXTxwOsx0/tSG7Scmo0gdvbMsJogDcK3CnWXykOYQv4rl2jkgBH+qlQ2O6wR8ImBc+qEo6EWiYoprzHDqn/tImgn8DTXVg7gdtcascAi3p6IOSRNPt9V2YywK8yKc87qiiOzlm/T+gGGRvKQdRaSlYJ3CVmVbBjp4/LP1JO/g3YbQv2yYgmk4BcEw+98MlkRpsEfUpCBI+/AtpCbIUQ2eYBibodYLwRTdVKJkbh6KjBOKB8NukKgsHfeb2RvlGNAVuaFsMNmpt8KLwrOWkT7zm4KOHnMJWuzHMxajEEiN2qBZ3P2uS6KUdeD5dOt9+2aw/pDQ7qoCr6+yBvpKO5yyIoZJAsIagNEQ8ZsnhN6KevH6OchhoIXL1F6q9PdKL1Sb4q8wZpuP6XXYecTmLGs7EsXlXwSSiPgYe6mRvR92mvSbVNxbe7wLG8y35oQfAJQ7ux83HXVvUbgHEH3ZmGv9rLJhxYIsQ4TaGwilfJOblflw8v66rMLCnuEAtEB2jqe40ArnPwyA9cLVuhAaya9ynIzChTJtS+drmNHc97cBbVSgRaQFcbK2auWYibCQVNBs8KHpDxyJXR9HP+ZAK1nf/DkcZ/Hi6fN2oX3weY+ObgpB1SYYPpRb6n8sZtQVH4leUFGoVK4AqDkJEtlBLynVwvR7ADTeM7rEgasKacy9QfeeXkY3F93j7JgKTwjoJ85UJVypievwLN991IOVnk+kv295iCyNNxdJULvWxNL+DX3xJPfXPd70IcRq3V/v46vV3Xqp/GUcrPI1f1XY+9PqEgpSv+fwtQrK5nErgvAkm2ixw+SqUlJCrWfXpdDXYzBaa7PGRyfM/eqET2q4TofGdCJh5iLw9HgGmlNrUuHKf1l0Yig1
 jgC5m5rn
 ovx6822woy5Xr4CuvgMBlCsSZeZf989rzv1WE3LAGiCS+6vVVz9gR979IRmfi859HU2UpWedxGJfgPzLy1Uj9dFftUK+re45V78CzeuoiWWsXPvnnAPhHExXo9S/1c/qpMT0ir53eqbcQvqmhp2uTkaqQK4uL07RsgRR8vzkB/kbtWJ+u/RHkIi0dIs7sWgJs2R7LAkU8YstWnPMrMBYjSP0+HBAcDHsxUTd3B1WY8N04DcbShtCyZ8RfCNPAW6/pxdZQ6A+lFCH3GLTgEuYLqyPpqNX/bvqMYuIqcTC7xcHlyhV89S7ATKmT37y1D+XvYq/3l5jlaXOiTvqnpaFuF+3BiR60wkdED/3EtMwsoDNnHk2vjWGEImneT7rZHexDt8pJNzQa0SkzBElMF91bSG+r2APGY0Pi6l49ydJcgXGBzDZeqWVNqVaBr0VIQNK8x8cWeqYukZMb6nnwHErfgTQPqyHyPa0d7yknUSPFDzIhp72/N8fW2mVNX4k0vfisZ7L14A2l+UCLa67e9uWQ7nSG2wmmeLC114nXDEUZodz0PLKewgxkcDkHAMBkSKCoIMPboSun0p0qmxE=
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
index 7de65b540438..72839e98f998 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3319,30 +3319,6 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
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
@@ -3350,7 +3326,6 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	struct folio *folio, *tmp_f;
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
 		account_new_hugetlb_folio(h, folio);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index e0686b87fdb1..a340ba7f0a74 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -757,6 +757,9 @@ void __meminit memmap_init_compound_page(struct page *head, unsigned long pfn,
 	for (unsigned long i = 1; i < nr_pages; i++)
 		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
 	prep_compound_head(head, order);
+
+	pageblock_migratetype_init_range(pfn, 1UL << order, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 }
 
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
@@ -1110,6 +1113,9 @@ static void memmap_init_zone_device_pages(unsigned long start, unsigned long end
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
+
+	pageblock_migratetype_init_range(start, end - start, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
@@ -1147,13 +1153,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		memmap_init_compound_page(head, pfn, zone, pgmap->vmemmap_shift);
 		memmap_init_zone_device_folio(page_folio(head), pgmap);
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



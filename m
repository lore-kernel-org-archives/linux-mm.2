Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C956CAC5B6
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E698E001F; Wed, 24 Sep 2025 11:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B653D8E001E; Wed, 24 Sep 2025 11:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E288E001F; Wed, 24 Sep 2025 11:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 940928E001E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52F1087966
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:31 +0000 (UTC)
X-FDA: 83924455062.24.B419298
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 302092001B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZwXtSzWX;
	spf=pass (imf13.hostedemail.com: domain of 3iwfUaAgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iwfUaAgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xK9DdWzysI7MLQZmTS4EgkDsy0LNYBhIo28kzW1svBA=;
	b=irgPBKmlA6c0nZBQKbhz2tAwTPz9DKahcycuClyQjtQhQvYznWjXktghotZvrdlboBhd4a
	gET0VQneRQ71hSmF6ARF/UfZmbmvJdIeQDmLb+F22aOxosGrkVi9fH/sc18mrRDjhU5uDB
	z9/rw+XDy+sDK1MLnQYFj09xzAzeVKs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZwXtSzWX;
	spf=pass (imf13.hostedemail.com: domain of 3iwfUaAgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iwfUaAgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726029; a=rsa-sha256;
	cv=none;
	b=P3aT+Q7N1mZs4xXo3nHbhQLVbpksXXi2D1FEwouPP+RLFL+dezTV550j1/+nJdILDiNzD8
	yRtTFdStEZCrCgjhtDVoh30pIQiS5/ftfU3fXMjwXUsnbRwT9tvhsvJ6VeOT22pJ8l15E6
	NXK/m0NprHkYDd/OAWbLsPV7pcv7f80=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so65920985e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726027; x=1759330827; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xK9DdWzysI7MLQZmTS4EgkDsy0LNYBhIo28kzW1svBA=;
        b=ZwXtSzWX/s/j3N9D7DENdvwICJD0mSNa6gxjieosvrmtWu0Xf6+dQNayGiOY306eDu
         Kgthz9ktp0t5cFxBz9bKA+7EsHPC/mUXu0J/yIgkaGgjw8Hr1ERhQmo6zJLQxopQYdEq
         oaSVtq6tZ0Gl7+KOr86wZNTGn9ED2lXqKqjNkZvxcI5EFHc9No5wLgIt4YsLruG0y6LN
         aJYgq5b+EBnMfc/PgLx9MwkVypfFP/dYIQvw5GahTgxUJNf94J+sYxIqxYt30WT92X/D
         L5bpjWRkYdSFj4imPJnXTxX45dCb/op9BhQjAT4M8jokCjzttJUhd0jvB0Jrwpb+f0Z9
         KcKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726027; x=1759330827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xK9DdWzysI7MLQZmTS4EgkDsy0LNYBhIo28kzW1svBA=;
        b=ekjXZyjjLoziRChSUQiL+KdAgHmzsbD2194iAnY4MwxvxbAfCWG/3AT8rCQdB2f5sf
         1+/KXo9GIoJqnTWGnAB7p00/Lj07Q8pwvoIE32pf89JA5BE7/8LD/5rdLaDo2Dz8SOpJ
         TUH/+zflkIiUu3rQWaN2O8U7V7JD7XlMIh7h7DXNb/ZcZweGjql5KN4stAQn9t6/KQMp
         tiG5I+tZF30AqFwqSGDZWFg08ywasHZPwbcpFdDzyKOjVes45EjkOnFkoEG0z0RZjt1i
         w424+Vngcs0FuZ6jBizUM3UAzsAAaBuxwq4gJTO7ER+cfEvC6Uqj8guNPoidRCHTz1a1
         ui+w==
X-Forwarded-Encrypted: i=1; AJvYcCVM1w/JKD1TcLHOeXpofbAG4yObHiQN4ByLp10Wsp4vH7Ke0d8yaQi4l9etIQ1bT3GMyl9MN93eIQ==@kvack.org
X-Gm-Message-State: AOJu0YziLJet5At0OIr3HVIMJS/xvx6ggBWTSMSZ5VgK3siTIYLj51PE
	ffF8k3RjT0w1nmx8VXNtRWbsQO0OmBFUzR2U6iIHQMF/umiuDDJjYy04tCka+1MXJ2OthTh58Vk
	/tyJsVUGXVF0vow==
X-Google-Smtp-Source: AGHT+IHRBeDpUtgF245mJUc5ipAYXCdMHfAb0w1ma3Resd3ql66vcD7C0WlHnlWorox4xP6DwHfNcUDqpn/NkQ==
X-Received: from wmrn38.prod.google.com ([2002:a05:600c:5026:b0:46c:f222:92c9])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c163:b0:45d:cf5f:cff8 with SMTP id 5b1f17b1804b1-46e329b9b49mr1939205e9.11.1758726027581;
 Wed, 24 Sep 2025 08:00:27 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:54 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-19-2d861768041f@google.com>
Subject: [PATCH 19/21] mm/asi: bad_page() when ASI mappings are wrong
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 302092001B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: k7yga7o4wtiatmckzncgxohgb38epunc
X-HE-Tag: 1758726028-562381
X-HE-Meta: U2FsdGVkX1+PXbLFjKnvu6GEez+vfLWwO9Txwz6oi5BwaBAph2xQWk9EkwP9APZILbyZJfsAfQk+DJmGV03AYF9IFxoLcmvlHxIR7SXJYaMAZGSP4cjh5FTtTa8lT4UmaBI7ukmvU+CdiormgPk/5r7tO9m/ZSjOt+tvVERy/pUQbYZ5vMADx2MrDwGNTYYOGrMZDjjZl/RREamHmm5c87j4Ho0MHae13oB+5fkCo+vDMLYrouBz5oGzneu0ixJtaBU67vSyH0xXod4/GBWSal4qbyAN0YbGj7WYD5y//bEi6Yh7m10digD6+9mHlTFhP/yRhaiuqeEVWGC/JK9BAyOTz5rB4JDNUE+7It2Ai2FXwwxra9ioNo6F62q5oamQby3fuADNeMYIAgOjxukWefIQvpNAhIN0NzWqObsxrl9gKKeNvslz5fQLDJemucbif/rTdpg8PgESewZytGApcJ/9ItKNnz2kjRBLL7lIGaBNqqE32whPYPH9vcCXq18tTpuVkJFzYI7Nb3Qj9vuc+Ea8UqNTPT1J82Wi25qPVuBLZcdIdI0LfRVZjR/V6gP9QlO6uiexScuoFhkU8aqCSd86M4RVM0gLeSwvtVj51X8c1S324XyojYjN2Yl5UPc9tWk9gu2ZEUOYNitd/tP+YLnseIw9HaXJD8YWC+2KJHRrTGNyeOXCdmAlaB6JpUmyjacJUDHs3fuzlu8F3WvznGNuRuntWACE3xhJbkAgBgoYoXUTjfbB23M8AIQyXOThrULQ1Sz5xBig+SDZzZQ84S8jTkQU8YDtwCyMulGS7vbjDsNyrTGXGZXzpdTYa6vnaXXgaPRrRb2FDtz2CJKiUX1FThmUwE58M5Qlkcrx4cmx1gP88BscFMBd4aB/sVRKeuo5EYMQWzwJR2sCIKhmccG9PVwzIdV8lTUBkbWMt7Y5j6lFyH7Hxa5nrReQilw1+Dv7Z48CtRzN1x2rIz0
 1N3X00dr
 JZ3Nem3YpVcwdOMZTf94hNq/fNp8+7GaLb4rHj84SSA8WHrhzPd/LMAlIy/D2DIt44LilfBxgH3YBbhg/qCIy3HrsyRgOsRu8y1ycbabYAwBdoxrLmjfM5XCr02NRgDGR6ko4PnoytcMWMcgn6g4GPtHAlin0Zlsz5rfRJzj4sSEjGzw9QzYAB9lF5wK6Xl/6JB33O0PHHMcgc/rB+SaPu2tP2G5d2xq1Xwd+FRFXU3XhyWtoLYbftqnabgh3fqcSR+kjJ7sECcgEHiAnu5MOQql0ARuwnBUSluoyaQjZFGOF6BXgQz/Ui3jxXb1dkCvVkHehJtc+/9AtsGEOZ4n1xXhRPDiYDIMV2NkeUUAu3kIKykSldlq/v3txQCwun2D5Ui70THK3qqKa2GoDA0/g30pgf7cyl+T6kXNhG8DVkIhElSg+2G67a7FcWtWCscK//7vMus13ZsGe/5eo/E2++lcNGa033F8PV+iywJpC1QQLbU2fYscBxC2v1RBMruFjDU3c6reVjrsgNz6rbo/0eYzQaPUHgZfDH35CFn/F7C0zyecl0N4w3ReR4dbTpWlA/oTtRYG1MwkZh4T1vbjiRldIq4UzsJDZ1Ua4xE8ddMJN6/FiBlQBG0RhVyI2iBs9FcxfaCajz6yNjZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bad_page() checks that fire when the page allocator thinks a page is
mapped/unmapped in ASI restricted address space, but the pagetables
disagree.

This requires adding an accessor for set_memory.c to walk the page
tables and report the state.

This is implemented with the assumption that the mapping is at pageblock
granularity. That means it doesn't need to be repeated for each order-0
page. As a result of this special order-awareness, it can't go into
free_page_is_bad() and needs to be separately integrated into
free_pages_prepare(). The alloc side is easier - there it just goes into
check_new_pages().

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/set_memory.h |  3 +++
 arch/x86/mm/pat/set_memory.c      | 31 +++++++++++++++++++++++++++
 include/linux/set_memory.h        |  2 ++
 mm/page_alloc.c                   | 45 ++++++++++++++++++++++++++++++++++-----
 4 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 396580693e7d1317537148c0c219296e2b7c13fd..3870fa8cf51c0ece0dedf4d7876c4d14111deffd 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -94,12 +94,15 @@ bool kernel_page_present(struct page *page);
 
 #ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
 int set_direct_map_sensitive(struct page *page, int num_pageblocks, bool sensitive);
+bool direct_map_sensitive(struct page *page);
 #else /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
 static inline
 int set_direct_map_sensitive(struct page *page, int num_pageblocks, bool sensitive)
 {
 	return 0;
 }
+
+static inline bool direct_map_sensitive(struct page *page) { return false; }
 #endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
 
 extern int kernel_set_to_readonly;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 88fb65574d4fa0089fa31a9a06fe096c408991e6..d4c3219374f889f9a60c459f0559e5ffb472073d 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2721,6 +2721,37 @@ int set_direct_map_sensitive(struct page *page, int num_pageblocks, bool sensiti
 
 	return __change_page_attr_set_clr(&cpa, 1);
 }
+
+/*
+ * Walk the pagetable to check if the page is mapped into all ASI restricted
+ * address spaces.
+ */
+bool direct_map_sensitive(struct page *page)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	pgd_t *pgd = pgd_offset_pgd(asi_nonsensitive_pgd, addr);
+	unsigned int level;
+	bool nx, rw;
+	pte_t *pte = lookup_address_in_pgd_attr(pgd, addr, &level, &nx, &rw);
+
+	switch (level) {
+	case PG_LEVEL_4K:
+		/*
+		 * lookup_address_in_pgd_attr() still returns the PTE for
+		 * non-present 4K pages.
+		 */
+		return !pte_present(*pte);
+	case PG_LEVEL_2M:
+		/*
+		 * pmd_present() checks PSE to deal with some hugetlb
+		 * logic. That's not relevant for the direct map so just
+		 * explicitly check the real P bit.
+		 */
+		return !(pmd_flags(*(pmd_t *)pte) & _PAGE_PRESENT);
+	default:
+		return !pte;
+	}
+}
 #endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index db4225c046c47c114293af8b504886b103dc94ce..6f42d6a35feceeae4623c2da50cfac54e3533228 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -50,6 +50,8 @@ static inline int set_direct_map_sensitive(struct page *page,
 	return 0;
 }
 
+static inline bool direct_map_sensitive(struct page *page) { return false; }
+
 #else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 /*
  * Some architectures, e.g. ARM64 can disable direct map modifications at
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8e3556643b0ff2fe1d35a678937270356006d34..68bc3cc5ed7e7f1adb8dda90edc2e001f9a1c3c5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -15,6 +15,7 @@
  *          (lots of bits borrowed from Ingo Molnar & Andrew Morton)
  */
 
+#include <linux/asi.h>
 #include <linux/stddef.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
@@ -1161,6 +1162,33 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 	return bad_reason;
 }
 
+static bool page_asi_mapping_bad(struct page *page, unsigned int order, bool sensitive)
+{
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+	if (asi_enabled_static()) {
+		struct page *block_page = page;
+
+		/*
+		 * ASI mappings are at pageblock granularity. Check they match
+		 * the requested sensitivity.
+		 */
+		while (block_page < page + (1 << order)) {
+			if (direct_map_sensitive(block_page) != sensitive) {
+				bad_page(page,
+					sensitive ?
+					"page unexpectedly nonsensitive" :
+					"page unexpectedly sensitive");
+				return true;
+			}
+
+			block_page += pageblock_nr_pages;
+		}
+	}
+#endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
+	return false;
+}
+
 static inline bool free_page_is_bad(struct page *page)
 {
 	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)))
@@ -1471,8 +1499,14 @@ __always_inline bool free_pages_prepare(struct page *page,
 		page->page_type = UINT_MAX;
 
 	if (is_check_pages_enabled()) {
+		freetype_t ft = get_pageblock_freetype(page);
+
 		if (free_page_is_bad(page))
 			bad++;
+
+		if (!bad)
+			bad += page_asi_mapping_bad(page, order,
+						    freetype_sensitive(ft));
 		if (bad)
 			return false;
 	}
@@ -1840,7 +1874,8 @@ static bool check_new_page(struct page *page)
 	return true;
 }
 
-static inline bool check_new_pages(struct page *page, unsigned int order)
+static inline bool check_new_pages(struct page *page, unsigned int order,
+				   bool sensitive)
 {
 	if (!is_check_pages_enabled())
 		return false;
@@ -1852,7 +1887,7 @@ static inline bool check_new_pages(struct page *page, unsigned int order)
 			return true;
 	}
 
-	return false;
+	return page_asi_mapping_bad(page, order, sensitive);
 }
 
 static inline bool should_skip_kasan_unpoison(gfp_t flags)
@@ -3393,7 +3428,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 		if (!page)
 			return NULL;
 
-	} while (check_new_pages(page, order));
+	} while (check_new_pages(page, order, freetype_sensitive(freetype)));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone, 1);
@@ -3478,7 +3513,7 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
-	} while (check_new_pages(page, order));
+	} while (check_new_pages(page, order, freetype_sensitive(freetype)));
 
 	return page;
 }
@@ -7231,7 +7266,7 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 
-		check_new_pages(head, order);
+		check_new_pages(head, order, gfp_mask & __GFP_SENSITIVE);
 		prep_new_page(head, order, gfp_mask, 0);
 		set_page_refcounted(head);
 	} else {

-- 
2.50.1



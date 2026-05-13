Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D73FCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5090F6B0095; Wed, 13 May 2026 09:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0C56B0096; Wed, 13 May 2026 09:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6D66B0098; Wed, 13 May 2026 09:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDEF6B0095
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE065A082A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:03 +0000 (UTC)
X-FDA: 84762424446.11.1E78325
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1B520180014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=llitVS3u;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmVa4U0u+W/oPX/GlMpJ9lsDnm/CfX2AcDL6FiyA9T4=;
	b=bqGKYIT3iaOlEikS5IeywQhNs6u9lT8JRazAaCb1iDG9DiExpxQ5OQxGpW+FdU/Yl8kUnB
	Cx07ZHOlGVwIO1xcHzpidIWsnDaNbTaQu6XXdnTtbvIvf9yssxJ0f+OABTYmoIl8Ur4LDW
	qV04P/rgzlC2uvZqnYQy5i3AB0oof+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677682; a=rsa-sha256;
	cv=none;
	b=34tQ6K8G+y2XTj5tOnn7+7HqqZ5haVFjz7pmdjbX8P3x3MfqCCb3ie3KRIuhrxYyrN20fD
	p0yAbXrXeYdI9dnbA/mZQ22xhSVaE7tIVXioTve4TOe8yN9cYIzf/h6rsj6XpHHSSoY/Y2
	M0i8xvxVe0JoQsHAc0rAzaJFsm98UgQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=llitVS3u;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2adff872068so36260615ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677681; x=1779282481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UmVa4U0u+W/oPX/GlMpJ9lsDnm/CfX2AcDL6FiyA9T4=;
        b=llitVS3uVgmO1fQqtJ5P5z2P87Jwv4mpos0Rp+wSLbO9VwQDwbVqgDDdzqIEcAKCtq
         p94tguUQQhLG/fKi0t9LQnnB/SqnORG5aAWDJEC+dUHYP3j8Dz6oB08QBqAejoVBJj5o
         6dkkxkP6Dyc+poHtDUbmuBJ+qC52g3F6ZKsiwJ1iHx3cfpx7CpAaFIz2T/MbDytDkXS3
         56RJJdiAWgn6LnVSgS+y423lQj8l6Z3FZtRtRialOFgA023n4/YcNmXu5uIyCKTQlX4r
         lccdjtFzBn0mEFR/bSDO2J0tIR5eK4SeeICjN6bR94znG0T/KiaSca+Y317MWCxo7jTd
         42/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677681; x=1779282481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UmVa4U0u+W/oPX/GlMpJ9lsDnm/CfX2AcDL6FiyA9T4=;
        b=l4VhL1uhS3zkNUyMgmi6YcaEcHICAhkbBB0nZ+7cscePGptR0bfxn1PslA+6WMMg6c
         MYFwXeiUTtGD7SctZyKQXIYlkw1lvjsamrdBbXfV9GZmubluzvwLJwQNvon1Y5oGyS72
         b2L1KPaTdB7hnbzvC7qumQpEvlno1EOO+g9cmdnsUkchMoChNY57BcVIRR3PLxHkc4Iz
         rSCR4EGbBOyHHh+uunA9x65RDNsa5QOL98oUFFW0//DKtsqvuGybu1fUVCkfsVDQFVmR
         rMmFGU5EJ6gkqC3iQDceAoLfkvNV7JQ/+nMp63Z4+cAF7BfopFJ435Nlwy11yMfc/Rj+
         swGg==
X-Forwarded-Encrypted: i=1; AFNElJ+uGUG8Lm2QmQ6qwWK1J9pd+7Saq2NPXex3uqIygbyRexw23udM/CSApDdE0cMgPNFlUWreX7PAQQ==@kvack.org
X-Gm-Message-State: AOJu0Yygr2BYnwTwam7q4ifcjEXTaIc5q1bZ+d+2/aAZ4SwZ9dWiqxTH
	LaDKrEaPnNSHTnoq0rRU69V6Elu+tpdBmXl6pV7uTl86FbzfSYzVOqJOGX03juq5NUM=
X-Gm-Gg: Acq92OEgpG9/1n5hF1slbVvlzXGPOXM7prPVzuu8t9nNVucFPkmnBgtfDxPNqW5Skiz
	gWze3Q1hTS9eO/Sd9t4IQpbdB1HNcpyhJDIpYh9xj/MolMGBvf5RYRBpAIdN9IHVRJwuuweNPGt
	bFZ1VHP25ifpV3IItw55JuGD/rRuabwF2gN82IKRZuwmklskPjNribnrMs93ZjxdQsGkuxajs3c
	yqGjxcMjscnQcIjYOiv/5N1cGZfD0tZFMqvsUBI+kMNvyVmmstq+Vve2KnZfoQ56xuk2bGqMe6q
	W9okVbmBcCjUzp0jBJ4wsjFGELeeW6YkvqklqcnCVNKjSdFJg1W6YI0dquftJkRaT1tAYJOPvZR
	7Y6jdUa6L8p50UviI09RsX9gYgv/SYVh9LN/r63CskkwntmVIZWFp2yXgSQGXRHXZqpI65EpZE5
	k6Wai+0MNZXVANQSKCyaKQpZwyCiRbksUP5pXeNwCyT65jGjznE4MBffsI6wg=
X-Received: by 2002:a17:903:94d:b0:2b9:f59e:aca5 with SMTP id d9443c01a7336-2bd27702f8dmr38772485ad.39.1778677680317;
        Wed, 13 May 2026 06:08:00 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.07.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:07:59 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 05/69] mm/mm_init: Simplify deferred_free_pages() migratetype init
Date: Wed, 13 May 2026 21:04:33 +0800
Message-ID: <20260513130542.35604-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1B520180014
X-Stat-Signature: oxoco96aefqntuy5ccowzmf1559wkt74
X-Rspam-User: 
X-HE-Tag: 1778677681-831552
X-HE-Meta: U2FsdGVkX1+BLy1eEbzX2S36lu7C+Uh6KvZxcTApAldhHBBGuJKsyB7OQFuJmbACIh2nnned4I9J10E/gmVMKNe6J/0Mc97446gyfieFUEq0ADD5XPp+IdkcxXGCi3Eb4WMurk1Jqnl3iKmjKiGsDTAn98gPegc1FllahVOh9TQbn9xAZVA8RBl4A79TQ6nFtS1Mb2ikmIrJ1w5MwqWrUqWfYtYo4SbDeinPtUW7y1NX2tIMx3ypXpFF4ejt8N4qn7otwCdNAHFMQUz1Wk8LgGMaLXIoKd9g3uXUpLuW1+5JaWBEzNPPx4lAvOjIPZvFCQW1i4y6OV9WQbfDBVWDbvADMnnuv2+KdSF6fV3ZDr/God/9S8Y7CjzSd1Rottpg9i7hshnq53FFz31s+P5AsdIKm7ox0SohkTMc7UEwhAxuneoUVUNZkU7V+4r6flJMB+W32qBJnAPgoXmwDm+3fzcXTS9OyRZ82Q2PA67aELPP7V59JmcfPURud3y9KjVJhwDfUA2XyeBR8JeMmD39sIml5BnJ32iOQI2ef80Zx9Ks2ee8WTjdUibyRPnzPVbxOEMQD1QrT1GjBUvEbmy2EQpb7uROQx9NXcAK2OEI/8cQWWrentPYA3XKc89SN/5AO4GIRSk8FE/TTOrYDuLo99WQMfYRdpm41vWbq4M0MmMfazaNMV1sh4/i5gPJ0vLtCsJBoDWcAsDpRUbalVwi8TV4Qk5k0VtJpVPhYhmT/yqKkpgyrgBfApBOKdGF1D871zmGbXswsCDdimvSuYvdFr74ak1QoLngmBcKfse5gjIb1N9SK+GpWx4d6LCSx1E2bx7Q6QeYVVS2N0nxYLCmCryUeT/LTL1u5aYd24CUM/Ud8BI9fXgZs/61wtdH+FcHgtMttBBlgwX7S/ZsBt3wYWY6EdT6UXOYkkHpFiGlmHrmpBqNm6wAE+qQbd3XKeDvPBXeLnsA8YAtVgueo0a
 RGsvX+qr
 FnlB3a/odTf1+4LCDqn8SgK5rSrwB+3k+mLKzMxnv4gxSCLCAJa1Wh3pKpro5IqfuXRK52PGEAc9lpVQ4P2cB5sIPgK8pox9U6arDsi3EjT6rLNBkhQDkvYg4fCgT38Rn4tFoGRfmIBtBN56LzfZnPHs5P6IfcEF9x/vy8XkBpOqHBDxtTOHcx2+B5pYwYq0Ryp2M0W2icOuiSgNwgAA/DJbgClLa1HazXQ9q0gTX2wK/SrKER0+RoLu5rUdg3Qp4Wjwhtj8zvt5Oq5RsIXlHxAGMxR2c6tAiUL+OXD/PY7M7k1tqBWQkLJukfcN3YXWM0MhXV9azR0AcvK5IU3v20UiEU36MncHrETWdq1VHHCH5wPvl22pGZuG+jSqRy6iyCy9+JcjWIzUfSwsIxVCvfijBR1maIfBwm1/8r8lY2hDX5SHeSM5asNSvVkENs3Luohvk8nRlsYs3wJq4LpBATguKdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

deferred_free_pages() open-codes two loops to initialize the pageblock
migratetype for a range of pages.

Replace them with pageblock_migratetype_init_range() to remove the
duplication and make the code clearer (Note that deferred_free_pages()
may be called from atomic context).

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v1->v2:
- Add Acked-by from Mike Rapoport
---
 mm/mm_init.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5a910cc5534c..96e0f2d8c3ea 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,15 +674,15 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_ZONE_DEVICE
+#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype)
+		unsigned long nr_pages, int migratetype, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
 }
@@ -1142,7 +1142,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1993,12 +1993,12 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
+	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -2006,11 +2006,8 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, mt, false);
-		__free_pages_core(page, 0, MEMINIT_EARLY);
-	}
+	for (i = 0; i < nr_pages; i++)
+		__free_pages_core(page + i, 0, MEMINIT_EARLY);
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9FE1099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1C76B00B1; Fri, 20 Mar 2026 14:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976A26B00CD; Fri, 20 Mar 2026 14:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8406C6B00CE; Fri, 20 Mar 2026 14:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC5E6B00B1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A00614033C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:53 +0000 (UTC)
X-FDA: 84567265146.20.497CA29
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5601240010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AqPrulUP;
	spf=pass (imf27.hostedemail.com: domain of 3tZC9aQgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3tZC9aQgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2RN1mWexhEznLePJIj6qOnpFYEhHscYECWiTyyR7gk4=;
	b=kAaLBUeqK/+AHQUYOeAbPc2Y6iBg5i4W/d5w6WEw0zD3qAVs61ANT4R5gwWBcJHDKhEHvT
	mGrn2rXggaUl+na3s/BaSvrLm8c+9TORKhXaJtZUSpn245meu9hlYOgFlGURO7LiZ1nbAw
	tfL32LVlOYpKOuPoH5jR3TiAgOCgmFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031031; a=rsa-sha256;
	cv=none;
	b=vWiqi/iJGIrFJWHqOtnM5XD0qHG+XKccAZN0sXkStcyc6PR7yX73k/vpspk/J1cSmnrbPE
	y4wRib05pUA6uo6GJkFlrhJECBZ6uiqW8hFhcSY3Cbz/vDQmvhZgB6RjXSU5TuBUgwaCQo
	C9b3QZl0BlIH5lU0h1PsF3RtTPumbN4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AqPrulUP;
	spf=pass (imf27.hostedemail.com: domain of 3tZC9aQgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3tZC9aQgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485c45885e6so31980145e9.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031030; x=1774635830; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2RN1mWexhEznLePJIj6qOnpFYEhHscYECWiTyyR7gk4=;
        b=AqPrulUPmoX/vcbytQ2k5Sb3TAmivsGrOqd+GZNS9xUiYJUvvpdFXYVj4nO699v4ti
         i12aaKINaoUtjwX2h9xRZ+Uos2oA/lz+VeHyf/78f8VjA0k+vewOKgZWi9mV5gOAA83C
         KDArzdMcYDNbGqvaLvGvjMMEIJukI8o0+OQGOR29lGfOexyC8OYGiI3yWRATQZng3wY2
         6PQdPEVG6NJWpAqjkCYv2v0nBuKNA/5d18JzF1O8wZF8/JqbkdmkIf+inuEL4VbRSrIU
         CUJTO3mWJndrI+R4A+kC9x4xixQRmnjZVQmX7E7s3Y+PFFHUKBzIP9ropDpk2Bq3Ctyl
         5pWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031030; x=1774635830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2RN1mWexhEznLePJIj6qOnpFYEhHscYECWiTyyR7gk4=;
        b=T5O1bdlLEBVWTWYOpPFJtMQbHJlDpUJyt0oM4nhE3YEJ1F7qPEX54KTYs7UIwJ9rAR
         pzyp5uPuNtrKKnah3aITfVmjH7uojPkdLbeh/YcOU5bE8nsvo5uZONE2WVynCuaYhsqq
         UfQijsZjkNhbXsSEvvq2RM/Td7Ktb7iv9qXaHTIfTOg1qvavF53h43ZtqRn7+hqXSjab
         SfTECSN6m7vd2Y1tyodSLNyR8XGzYQjpapkUio2aNRK+MvBAJ9EPkV48MVrH8Tt3+itX
         Opf10i1yndWBq7wOSQDQ8MVPY1g9hE+XKDCAgMg9/D4SI6ZtCBuc29H3B5uGh00sQ5nk
         mp+w==
X-Gm-Message-State: AOJu0YyTTjnNtHXSzJC/zSENhDDPYK1C/oF2csO9Vce9kPz8hEfONfSI
	N26OT+vpmzEyUtvR2Uj5pEFB8RAr/4qsCmKs5xc67p6PZxDplyVw3CPFsYby4t47BAvMs+aqr4O
	qffoWccmhQgvsIg==
X-Received: from wmaj7.prod.google.com ([2002:a05:600c:6c07:b0:480:4a03:7b6f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3d90:b0:485:3c8f:e4d9 with SMTP id 5b1f17b1804b1-486fee1d9e6mr53990165e9.26.1774031029696;
 Fri, 20 Mar 2026 11:23:49 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:32 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-8-28bf1bd54f41@google.com>
Subject: [PATCH v2 08/22] mm: introduce for_each_free_list()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5601240010
X-Stat-Signature: ft8ch6eunwefzw8sgdwm9bp8rn8eok7d
X-HE-Tag: 1774031031-419108
X-HE-Meta: U2FsdGVkX1+EATbbv83rfDexUUJpyLqpUF7ReDdHeWE1Iq2omx0OZfu5xFS1F79gZomnz+J7fQIcJDBfRskY+l/o09cky2/8kFbTJ655nnUsWbC0rdMEeSrn034xjiw4YkkMq7xy2t/7+w0p/cybOkELDGWH9QFhV0jCi94rmOAtSR38uQh3xKrF4753KNw+OqHeQHhB90rRwr/z5U2L5TN4XGLIt7O28JuIi6ceDiE9daJOSdrRv6CajpAH3TMJxRRS++iy9niiE7+6TdoGR6IqWtuNnfJn7WyiAeEquu3DZk7E7cL77lLCDtv2T3qDJdGy12kMlnMNFO8aYTA6PSHdbakMGOt9wb+wisV0lBf25CIMFQvaDZVfBuk+XoOTmC52pxFp5ibTjfdx4+z1TUWaKyQ08n/BlKdVIthSIfK3FqNUrBikU3r0DfI+bO/s4A+imTjYd85hUXGET/vfECH//qehgHmLw0w33tjfSYCxy4Zw3xpoVoPtlZAWz9ay5GsvQscJeU3sSZ2EIXheJLU76itRzdSG2E1//V/i40FieGC3kPfZFyDgncpNGjjtU/Dkaj4qFeLHe5FIlT+bVZIy8VHgWfdqDgNYv8ua69H9czrDlNmMgo3kSTvL6ANkoR/3WPlxRUxvq/KjQll52v2z++PGNQs8F1AT6BPkVZUaGt6GRNmj1Bifa3+u015dDmBfI0lHrx95qerHjHhWiIY96tFM1jnFBHHQXIh0mGkz5GPr+nVk4HfHm96FPnREBUMIfjd+TMulp41qntyOcQUUhQVwFH/IUHEH6A09DBKCRGaZrKWjzD24R/EFOSTZdHqFnar0ss9/YrU8GDA/FxoHChv3tpahijuVii431KJVe+klSyztbeJfTom1pCc5uKBFPuK7XtSPyizAdT56IK5bDp10cvyW3XUqHTHcoemELo3KwdrRDWhv9ws42GsaUpDinopKy4nV5jXJf4d
 W4kx4ZJF
 m/0diPIfFBsHUH9fhLLQpCjWdRguYQQ0n6y8Gr7ecJsTMEP1PuDNtnAJQ1xq8A6OIx/WDWfhWWyxK0IexCd163hE166H0WIZeXgHIpgoG0nPLco0P6hyGvxR+hA3D0cirWxrKfTnaqVWVUDNyj00DB21T3UyTSz00sWubdPOfOORT1tmmGWMENGvTLbrcHFy4wto9UQLEZboLZVpRYbHelV6bx33RnA/1m/BTgJUI5Jnbpt6SlcbBmZ7Sgtx8CtkFDChrRKgt+2KO+3BPYcVRvj/2t9UPX4XOzd7TdAxZW0hD1xzyUYoNy+iI90zYpRUCXZCviB+Cl3kdDk5hTKXS82QGfzjX2NjmWHWg0egujWnDzFAPOC/JUzsmybiPsxbhe6v+86/WMD5zgLKZTeC850vwC+wIWFn6W5h+X7HbxMrCcpLnbHHNKp0hZSVB77TwOrkORlErj0egz00RaTiAuCN0/Tbz/QUswpWV6Ywd41FnjPAQsMfqXnEzLzfIF1HIjjdD/7QZb05dZ+btX2erPFx5gby+zHfR7BVrTnG+sNRPQ7RP180/00mz25gCRH2fdqQx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later patches will rearrange the free areas, but there are a couple of
places that iterate over them with the assumption that they have the
current structure.

It seems ideally, code outside of mm should not be directly aware of
struct free_area in the first place, but that awareness seems relatively
harmless so just make the minimal change.

Now instead of letting users manually iterate over the free lists, just
provide a macro to do that. Then adopt that macro in a couple of places.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mmzone.h  |  7 +++++--
 kernel/power/snapshot.c |  8 ++++----
 mm/mm_init.c            | 11 +++++++----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7bd0134c241ce..c49e3cdf4f6bb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -177,9 +177,12 @@ static inline bool migratetype_is_mergeable(int mt)
 	return mt < MIGRATE_PCPTYPES;
 }
 
-#define for_each_migratetype_order(order, type) \
+#define for_each_free_list(list, zone, order) \
 	for (order = 0; order < NR_PAGE_ORDERS; order++) \
-		for (type = 0; type < MIGRATE_TYPES; type++)
+		for (unsigned int type = 0; \
+		     list = &zone->free_area[order].free_list[type], \
+		     type < MIGRATE_TYPES; \
+		     type++) \
 
 extern int page_group_by_mobility_disabled;
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 7dcccf378cc2f..abd33ca13eec4 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1245,8 +1245,9 @@ unsigned int snapshot_additional_pages(struct zone *zone)
 static void mark_free_pages(struct zone *zone)
 {
 	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
+	struct list_head *free_list;
 	unsigned long flags;
-	unsigned int order, t;
+	unsigned int order;
 	struct page *page;
 
 	if (zone_is_empty(zone))
@@ -1270,9 +1271,8 @@ static void mark_free_pages(struct zone *zone)
 			swsusp_unset_page_free(page);
 	}
 
-	for_each_migratetype_order(order, t) {
-		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], buddy_list) {
+	for_each_free_list(free_list, zone, order) {
+		list_for_each_entry(page, free_list, buddy_list) {
 			unsigned long i;
 
 			pfn = page_to_pfn(page);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 969048f9b320c..f6f9455bc42b6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1445,11 +1445,14 @@ static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx,
 
 static void __meminit zone_init_free_lists(struct zone *zone)
 {
-	unsigned int order, t;
-	for_each_migratetype_order(order, t) {
-		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
+	struct list_head *list;
+	unsigned int order;
+
+	for_each_free_list(list, zone, order)
+		INIT_LIST_HEAD(list);
+
+	for (order = 0; order < NR_PAGE_ORDERS; order++)
 		zone->free_area[order].nr_free = 0;
-	}
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	INIT_LIST_HEAD(&zone->unaccepted_pages);

-- 
2.51.2



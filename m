Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 334D9CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3C158E0018; Wed, 24 Sep 2025 11:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB898E0012; Wed, 24 Sep 2025 11:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB228E0018; Wed, 24 Sep 2025 11:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA8038E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6287E16086C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:23 +0000 (UTC)
X-FDA: 83924454726.06.DACE23D
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 545E714000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NxztC/Oq";
	spf=pass (imf09.hostedemail.com: domain of 3gwfUaAgKCDAVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3gwfUaAgKCDAVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FAWLg0cAZSQEdsXqkfb3D+Y+KS6zrWexbvzTaWhCuA=;
	b=vD3rNaj5VY4Mo3936dSx8MEBfsGsGsXIGR0BXF6lP5xGYGwByXZPzEUu9tSvCRaM9ZCRMO
	wLliSFScwnWCZaDePyrztyVhd6h3NmaBGyrXfjkDOEI0SPGdbic4WpUTdfH+U2xLYoxtjL
	Sx3vqAQo//L3Dl3lAU5bVjZTMnPvwWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726021; a=rsa-sha256;
	cv=none;
	b=bmhoTUk7b7lliEdc27/JJFC7u3Es2yJ4zHTyduJzqWOgrx5VnpaHH7SVyVxOAirZPIAbcQ
	yiZvsdUdBvA0U3Jp21Su6UhbevRZN1L1wMHXYqEr5YG/ZuQhLGqQ54AkTn5PeA7KpfYh+W
	6F0gPF/hwQWrgViZ8hLHayK6GLHNc54=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NxztC/Oq";
	spf=pass (imf09.hostedemail.com: domain of 3gwfUaAgKCDAVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3gwfUaAgKCDAVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46d8ef3526dso21391075e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726020; x=1759330820; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FAWLg0cAZSQEdsXqkfb3D+Y+KS6zrWexbvzTaWhCuA=;
        b=NxztC/OqiR3GimSKtU1D52Cdmlzl2TE84subMRYRA/uyaf/5mYQMvztvikY1KLDltW
         gPA2lykmLT1NUU4wXyvvEkJ7/eZO6STtiBjfA3IhmLUiXe8eZ5hKg8EhhAQhROsgsQne
         v+6IVeRj9/Ue4fDVD3o+I9P16icNUkXFiD107va1sKhVkafrH8r2xIYKBS0YQOFc2rSq
         25t3+1Pnm7l6pwvSwNTF2zihsqbIKbgwXpAoXndbT9ZZ3x+X6HKw+wkakjnQbfgSJm61
         +gs7/2p2rNhpq0nd/CGs4uHkD0Er3ol02SXvP80l2Rvnn1oo1J6TU3c+Ef9rcCPxsqdO
         o2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726020; x=1759330820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FAWLg0cAZSQEdsXqkfb3D+Y+KS6zrWexbvzTaWhCuA=;
        b=jrgdyW5qSxPmHcumg9iVxx7r3nnV0OnuDLeNKIoxCup+vM3JOsmmrupVnR6z29PPa+
         Z3KmlEZ3KY+wTc8SfQMToiRPhcAuSd0D9h8z7ePtVNszSZiiokgL8kiDHSrJkWt9QEpA
         HVVQWmBZtLSGvyMjHutKn8YY9iP0pje5O1HXTzlLV0gVva9Jss+oz3b16fGAFv4tk1DG
         q3IJ/nQ0VzsPHuz8OT2ghW3zD0ohH8qcmsZceoRBYJ9BC3V0J4sox6SmNFw49vJlQ+BB
         u0uG5WNmXtoRRD7T6BxujqyGcHBsvm6+dCA78sdlgUTxyNiXsTOkyKRjVO0K4ZsR0nXY
         g3CQ==
X-Forwarded-Encrypted: i=1; AJvYcCX723VxIik/5HaERacYf2kdBrniQaUEgSM5k5rUW/ZukAWsSudEc/CHysUnrQwrR2o1D/J7AgqSLQ==@kvack.org
X-Gm-Message-State: AOJu0YwH4q5d1bf5ge2uKY9BJF9qs/A/tE+eV63yb6uQwboD9OTIlhOx
	brq+9IebPLNW4AzW7i6kdmwz+2c4Xf0TYyijbW47i/AVYA6wAobkzxaQANiRMefl627vrhCWGoF
	peJRcy5IGULXLsw==
X-Google-Smtp-Source: AGHT+IEd3Rjl3nI9f3Je8VbfFMCNjxpjDcsgVNyf8yRf3esq/kDU/77UhI5eXqehOFhjda6lFEvLmXxGBzJK+Q==
X-Received: from wmrm14.prod.google.com ([2002:a05:600c:37ce:b0:46e:2f1b:4ceb])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4353:b0:46e:2c3c:d6b with SMTP id 5b1f17b1804b1-46e329f8ac5mr968665e9.22.1758726019835;
 Wed, 24 Sep 2025 08:00:19 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:47 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-12-2d861768041f@google.com>
Subject: [PATCH 12/21] mm/asi: encode sensitivity in freetypes and pageblocks
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
X-Rspamd-Queue-Id: 545E714000F
X-Stat-Signature: jmtmyfnzyud8u5bxxjdpra6zme33p6k6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758726021-772555
X-HE-Meta: U2FsdGVkX1+5nrEg0yKgyoaRHnQ91ZBOa9npx2Talq5D5PPsQzL2s1nxTQFQ9aQCsW9Rvz/Jl1F8/OTyDqUuE0hLpEtREcljtJvJ9KLpo3nUc3MzMzFE0km0NH9bDXyGv2clH//lEHcKFzuP7sb6jhy2hC0PYjqwaCednDSIfWeJXtvJdc1lP7J7ddf6zxDVm2yJWPVsN/WWkzm67ZjTOBi0xTDZM6+xX6cTj0MFkk34n4NCqkh0OJdtcCXncbxh8UpwRNFcsyRENjCuy/TMR9xoTKZIobSb410ANajGJ/suf/1bR11fceZ26K1+t+BTwxz+//5hKWqO7w7ym0o/LPId3xAOxiyOCcW6G8AX3BkxhzoqXsHtRTrv9rZJzU9s8cAhAnfn9WHAJvXOX0qaZJ8BFeDoh7qiKbdulhsgD5g19+IvqXlJk0yFnP8+xEp3b4Z0U7iLCxD0hVNu0XBI2UPOQD8s6KTb0XkogsHdM35TAmM02x40pDwYtUEdT0oEJ0vj2XlGqXHgRAz0QbntoYpAXPYOpbHAeVgD8mxEgX8XdfhB6iCCZ+vfptxoayat1AfQVlpsfug/Ohw6ym3uUBT0sX1TO8PLxJRaR4CMZR69r3AXofkt1ueui3efJ5lCX+cenh8SKgZtJI5AA+oHRoafMq3u4UDrW+D/I0XPs/Or3XTyYmBWJV7822z3nDq+MKlPImRgz+F9wksyRlgEWQ61rj8quhQbbqJeKNhjDivWeK1BSjRcTf5eiSdMexNURwO8fAqok21F1QZbtOqwcoKHqNKBCWpHSZ9W1/QJSqYDL6SlKSoBMmhMEovRuqi1hT0Ytm+4fZLhWteYKVWaYXif+8gbE5Wc55b6hobxE4/sc8qCMyGXPet0lXf90AI4giTNfuvukssduAQ+5fUmNGF3Gfs25Vqil22yWCsqdBIZ0a/1QF0p2lpwjsQDfbrk4H+R/j4t6GXj3rUoqbx
 8JsVKAiR
 c7VcQVo9JE+NKVzMCKuwmKEoVrrJx1NiAY8Lz5bT0ubUOey84lxuQxOHh34ZGT7usMA6Hfz+Ldu8pBK6cNQ1d3FjuVL8+fowPmVcI76m1UYP1MSstwqGlTf2StxOCzifWX+u7/+kMHER9oSJWQcFVfr4hwmdbUk6rKSbD4laXHsw0hylifB/FMsbIKxTq08AzS4cQtq4mc4hg7enYKvEyKMtLtOdKRJPPoVmZaTdwZtaxZyFFKlJMrPbv/Wx7mSOIfWTOOeRkcRohxnqC3JVU8SYtMrWnw7pKThfgK89Labiz7vZLqabSGiF78lmrfYZrRwqe6hEDiHD35fbaiE7TXoGB1N7hwUMe5yTolPBsYT4S4bK8fgq3WMx373pTkGJqbGQaDYJB/1QGGd7FgK7/tCQG0V4wLx8PgKhm2hT7oHoxu9WtqhygjV1ifZ8zTeqJIenJNSRRk3DZ4DO4OR0fFc6EbWRkoJ++jTpBbXrJXvXFYM5GwVyqDVgrTjDexGlHz2p6YVQlEmVjOanRW7uciHE/p7bQIy/7NWkZ+NYHxVm5qTGK4iFBz3gIzaIcmWxp2oWaRHlVuk3zqKCiigY2PbGyGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that there is a higher-level concept for encoding the "type" of a
collection of freelists, use this to encode sensitivity, i.e. whether
pages are currently mapped into ASI restricted address spaces.

Just like with migratetypes, the sensitivity of a page needs to be
looked up from the pageblock flags when it is freed, so add a bit for
that too.

Increase the number of freelists and update the pcplist index-mapping
logic to encode sensitivity as another dimension. Then update
NR_SENSITIVITIES and code that iterates over freelists to be aware of
the new set of lists.

Blocks of differing sensitivity cannot be merged, so update
__free_one_page() to reflect that.

Finally, update __move_freepages_block_isolate() to be aware that it of
which sensitivity's freelists it needs to manipulate.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h             |   2 +-
 include/linux/mmzone.h          |  31 ++++++++++--
 include/linux/pageblock-flags.h |  18 +++++++
 mm/internal.h                   |  10 +++-
 mm/page_alloc.c                 | 104 ++++++++++++++++++++++++++--------------
 5 files changed, 123 insertions(+), 42 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index a275171c5a6aecafd7783e57ce7d4316c5e56655..a186a932f19e7c450e6e6b9a5f6e592f6e8f2bed 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -35,7 +35,7 @@ static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
 			>> GFP_MOVABLE_SHIFT;
 	}
 
-	return migrate_to_freetype(migratetype, false);
+	return migrate_to_freetype(migratetype, gfp_flags & __GFP_SENSITIVE);
 }
 #undef GFP_MOVABLE_MASK
 #undef GFP_MOVABLE_SHIFT
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 56310722f38b788154ee15845b6877ed7e70d6b7..c16e2c1581c8ec0cb241ab340f8e8f65717b0cdb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -5,6 +5,7 @@
 #ifndef __ASSEMBLY__
 #ifndef __GENERATING_BOUNDS_H
 
+#include <linux/asi.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/list_nulls.h>
@@ -123,7 +124,11 @@ static inline bool migratetype_is_mergeable(int mt)
 	return mt < MIGRATE_PCPTYPES;
 }
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+#define NR_SENSITIVITIES 2
+#else
 #define NR_SENSITIVITIES 1
+#endif
 
 /*
  * A freetype is the index used to identify free lists (free area lists and
@@ -141,18 +146,30 @@ static inline freetype_t migrate_to_freetype(enum migratetype mt, bool sensitive
 {
 	freetype_t freetype;
 
-	freetype.type = mt;
+	/*
+	 * When ASI is off, .sensitive is meaningless. Set it to false so that
+	 * freetype values are the same when asi=off as when ASI is
+	 * compiled out.
+	 */
+	if (!asi_enabled_static())
+		sensitive = false;
+
+	freetype.type = (MIGRATE_TYPES * sensitive) + mt;
 	return freetype;
 }
 
 static inline enum migratetype free_to_migratetype(freetype_t freetype)
 {
-	return freetype.type;
+	VM_WARN_ON_ONCE(!asi_enabled_static() && freetype.type >= MIGRATE_TYPES);
+	return freetype.type % MIGRATE_TYPES;
 }
 
 static inline bool freetype_sensitive(freetype_t freetype)
 {
-	return false;
+	bool sensitive = freetype.type / MIGRATE_TYPES;
+
+	VM_WARN_ON_ONCE(!asi_enabled_static() && sensitive);
+	return sensitive;
 }
 
 /* Convenience helper, return the freetype modified to have the migratetype. */
@@ -174,10 +191,14 @@ static inline bool freetypes_equal(freetype_t a, freetype_t b)
 
 #define for_each_free_list(list, zone) \
 	for (unsigned int order = 0; order < NR_PAGE_ORDERS; order++) \
-		for (unsigned int type = 0; \
-		     list = &zone->free_area[order].free_list[type], \
+		for (unsigned int type = 0;\
 		     type < MIGRATE_TYPES; \
 		     type++) \
+			for (int sensitive = 0; \
+			     list = free_area_list(&zone->free_area[order], \
+						   migrate_to_freetype(type, sensitive)), \
+			     sensitive < NR_SENSITIVITIES; \
+			     sensitive++)
 
 extern int page_group_by_mobility_disabled;
 
diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 13457e920e892c1c5083e0dc63e2ecfbed88f60e..289542ce027ca937cbad8dfed37cd2b35e5f3ab5 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -18,6 +18,14 @@ enum pageblock_bits {
 	PB_migrate_0,
 	PB_migrate_1,
 	PB_migrate_2,
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+	/*
+	 * Block is mapped into restricted address spaces. Having a
+	 * "nonsensitive" flag instead of a "sensitive" flag is convenient
+	 * so that the initial value of 0 is correct at boot.
+	 */
+	PB_nonsensitive,
+#endif
 	PB_compact_skip,/* If set the block is skipped by compaction */
 
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -44,6 +52,16 @@ enum pageblock_bits {
 #define PAGEBLOCK_ISO_MASK		0
 #endif
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+#define PAGEBLOCK_NONSENSITIVE_MASK	BIT(PB_nonsensitive)
+#else
+#define PAGEBLOCK_NONSENSITIVE_MASK	0
+#endif
+
+#define PAGEBLOCK_FREETYPE_MASK (PAGEBLOCK_MIGRATETYPE_MASK | \
+				 PAGEBLOCK_ISO_MASK | \
+				 PAGEBLOCK_NONSENSITIVE_MASK)
+
 #if defined(CONFIG_HUGETLB_PAGE)
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
diff --git a/mm/internal.h b/mm/internal.h
index 50ff6671f19d38a59c9f07e66d347baf85ddf085..0401412220a76a233e14a7ee7d64c1194fc3759d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -960,7 +960,15 @@ static inline bool free_area_empty(struct free_area *area, freetype_t freetype)
 
 static inline bool free_areas_empty(struct free_area *area, int migratetype)
 {
-	return free_area_empty(area, migrate_to_freetype(migratetype, false));
+	bool sensitive;
+
+	for_each_sensitivity(sensitive) {
+		freetype_t ft = migrate_to_freetype(migratetype, sensitive);
+
+		if (!free_area_empty(area, ft))
+			return false;
+	}
+	return true;
 }
 
 /* mm/util.c */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4ce81f8d4e59966b7c0c2902e24aa2f4639a0e59..5943b821089b72fd148bd93ee035c0e70e45ec91 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -365,11 +365,8 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 	unsigned long *bitmap;
 	unsigned long word_bitidx;
 
-#ifdef CONFIG_MEMORY_ISOLATION
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 8);
-#else
-	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
-#endif
+	/* NR_PAGEBLOCK_BITS must divide word size. */
+	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4 && NR_PAGEBLOCK_BITS != 8);
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
@@ -442,9 +439,18 @@ __always_inline freetype_t
 __get_pfnblock_freetype(const struct page *page, unsigned long pfn,
 			bool ignore_iso)
 {
-	int mt = get_pfnblock_migratetype(page, pfn);
+	unsigned long mask = PAGEBLOCK_FREETYPE_MASK;
+	enum migratetype migratetype;
+	unsigned long flags;
 
-	return migrate_to_freetype(mt, false);
+	flags = __get_pfnblock_flags_mask(page, pfn, mask);
+
+	migratetype = flags & PAGEBLOCK_MIGRATETYPE_MASK;
+#ifdef CONFIG_MEMORY_ISOLATION
+	if (!ignore_iso && flags & BIT(PB_migrate_isolate))
+		migratetype = MIGRATE_ISOLATE;
+#endif
+	return migrate_to_freetype(migratetype, !(flags & PAGEBLOCK_NONSENSITIVE_MASK));
 }
 
 /**
@@ -601,7 +607,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
+				  PAGEBLOCK_FREETYPE_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -685,29 +691,39 @@ static void bad_page(struct page *page, const char *reason)
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static inline unsigned int order_to_pindex(int migratetype, int order)
+static inline unsigned int order_to_pindex(freetype_t freetype, int order)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+	int migratetype = free_to_migratetype(freetype);
+	/* pindex if the freetype is nonsensitive */
+	int pindex_ns;
+
+	VM_BUG_ON(!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		  order > PAGE_ALLOC_COSTLY_ORDER);
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    order > PAGE_ALLOC_COSTLY_ORDER) {
 		bool movable = migratetype == MIGRATE_MOVABLE;
 
-		if (order > PAGE_ALLOC_COSTLY_ORDER) {
-			VM_BUG_ON(order != HPAGE_PMD_ORDER);
-
-			return NR_LOWORDER_PCP_LISTS + movable;
-		}
+		VM_BUG_ON(order != HPAGE_PMD_ORDER);
+		pindex_ns = NR_LOWORDER_PCP_LISTS + movable;
 	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+		pindex_ns = (MIGRATE_PCPTYPES * order) + migratetype;
 	}
 
-	return (MIGRATE_PCPTYPES * order) + migratetype;
+	return (NR_PCP_LISTS_PER_SENSITIVITY * freetype_sensitive(freetype))
+		+ pindex_ns;
 }
 
-static inline int pindex_to_order(unsigned int pindex)
+inline int pindex_to_order(unsigned int pindex)
 {
-	int order = pindex / MIGRATE_PCPTYPES;
+	/* pindex if the freetype is nonsensitive */
+	int pindex_ns = (pindex % NR_PCP_LISTS_PER_SENSITIVITY);
+	int order = pindex_ns / MIGRATE_PCPTYPES;
+
+	VM_BUG_ON(pindex >= NR_PCP_LISTS);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-		if (pindex >= NR_LOWORDER_PCP_LISTS)
+		if (pindex_ns >= NR_LOWORDER_PCP_LISTS)
 			order = HPAGE_PMD_ORDER;
 	} else {
 		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
@@ -950,6 +966,26 @@ buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
 			NULL) != NULL;
 }
 
+/*
+ * Can pages of these two freetypes be combined into a single higher-order free
+ * page?
+ */
+static inline bool can_merge_freetypes(freetype_t a, freetype_t b)
+{
+	if (freetypes_equal(a, b))
+		return true;
+
+	if (!migratetype_is_mergeable(free_to_migratetype(a)) ||
+	    !migratetype_is_mergeable(free_to_migratetype(b)))
+		return false;
+
+	/*
+	 * Mustn't merge differing sensitivities, changing the sensitivity
+	 * requires changing pagetables.
+	 */
+	return freetype_sensitive(a) == freetype_sensitive(b);
+}
+
 /*
  * Freeing function for a buddy system allocator.
  *
@@ -1018,9 +1054,7 @@ static inline void __free_one_page(struct page *page,
 			buddy_ft = get_pfnblock_freetype(buddy, buddy_pfn);
 			buddy_mt = free_to_migratetype(buddy_ft);
 
-			if (migratetype != buddy_mt &&
-			    (!migratetype_is_mergeable(migratetype) ||
-			     !migratetype_is_mergeable(buddy_mt)))
+			if (!can_merge_freetypes(freetype, buddy_ft))
 				goto done_merging;
 		}
 
@@ -1037,7 +1071,9 @@ static inline void __free_one_page(struct page *page,
 			/*
 			 * Match buddy type. This ensures that an
 			 * expand() down the line puts the sub-blocks
-			 * on the right freelists.
+			 * on the right freelists. Sensitivity is
+			 * already set correctly because of
+			 * can_merge_freetypes().
 			 */
 			set_pageblock_migratetype(buddy, migratetype);
 		}
@@ -2174,18 +2210,16 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 	}
 
 move:
-	/* Use PAGEBLOCK_MIGRATETYPE_MASK to get non-isolate migratetype */
+	block_ft = __get_pfnblock_freetype(page, page_to_pfn(page), true);
 	if (isolate) {
-		from_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						    PAGEBLOCK_MIGRATETYPE_MASK);
-		to_mt = MIGRATE_ISOLATE;
+		from_ft = block_ft;
+		to_ft = freetype_with_migrate(block_ft, MIGRATE_ISOLATE);
 	} else {
-		from_mt = MIGRATE_ISOLATE;
-		to_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						  PAGEBLOCK_MIGRATETYPE_MASK);
+		from_ft = freetype_with_migrate(block_ft, MIGRATE_ISOLATE);
+		to_ft = block_ft;
 	}
 
-	__move_freepages_block(zone, start_pfn, from_mt, to_mt);
+	__move_freepages_block(zone, start_pfn, from_ft, to_ft);
 	toggle_pageblock_isolate(pfn_to_page(start_pfn), isolate);
 
 	return true;
@@ -2895,7 +2929,7 @@ static void free_frozen_page_commit(struct zone *zone,
 	 */
 	pcp->alloc_factor >>= 1;
 	__count_vm_events(PGFREE, 1 << order);
-	pindex = order_to_pindex(free_to_migratetype(freetype), order);
+	pindex = order_to_pindex(freetype, order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
@@ -3380,7 +3414,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 * frees.
 	 */
 	pcp->free_count >>= 1;
-	list = &pcp->lists[order_to_pindex(free_to_migratetype(freetype), order)];
+	list = &pcp->lists[order_to_pindex(freetype, order)];
 	page = __rmqueue_pcplist(zone, order, freetype, alloc_flags, pcp, list);
 	pcp_spin_unlock(pcp);
 	pcp_trylock_finish(UP_flags);
@@ -5176,7 +5210,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed_irq;
 
 	/* Attempt the batch allocation */
-	pcp_list = &pcp->lists[order_to_pindex(free_to_migratetype(ac.freetype), 0)];
+	pcp_list = &pcp->lists[order_to_pindex(ac.freetype, 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */

-- 
2.50.1



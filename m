Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6ADE606A336
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=YvuNse7N
Received: by kanga.kvack.org (Postfix)
	id D95F46B05B2; Sun,  1 Nov 2026 22:26:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46056B05B3; Sun,  1 Nov 2026 22:26:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35606B05B4; Sun,  1 Nov 2026 22:26:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB4C6B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDF601A0BB2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:29 +0000 (UTC)
X-FDA: 85388741298.18.4D7277A
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id AE74940003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YvuNse7N;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793589988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5KGtvw7DpJGGNS4rFHN4nrIn7gUZjudz5jjNah3jeg=;
	b=HuBYCHFalTlbwwHt5xIf4G7gT8rmwxyJUJzO1/nfgwBBX0yXbjsZn7hQokWpD/iOd24QDD
	7ASDAIh/JsM2OZWI/DtlwGWLbTCM5u1SY2Ph1A1G3FQ1hBH4ybytPxIQ3k/5XyDRNmQoRS
	JKufQ3fqvNlgOnZjw8DsKX/OGbzA2SE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YvuNse7N;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793589988;
	b=fpFonBflrKjJFco2dJgHIKABsyOubUdBmBfgygc3DD6zRpJB43X7q/QHBu6cxqRak9oh/n
	TAgPjZydIyvHyrhXZIwBSXmnxLwLpvxOrf90uoGXP6SwsVFX6rjEr6pS6wRVn6Fpw/8yEn
	TwbO+4d9rgl5uBXTGf9Y8yKIFP+sxv4=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ad787b79ffso1423302a91.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793589986; x=1794194786; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G5KGtvw7DpJGGNS4rFHN4nrIn7gUZjudz5jjNah3jeg=;
        b=YvuNse7NU4PFTW8FpfBCwGGtFub1qPm2dC1VJZ5WYN8me+vAEOUA961WDQwQ/X7KoJ
         wCgh1u2EFrA2k1DfBW7zxgqv8PPILKsP1tzq/tf4GXheKts8XYpHlUcPui/e2ETvRy6t
         L9vaoi/1dYTjtc/HyfAc84pH1+d3a8nVkTMVWfhrut3WDVtRu5XIUj9wqWFbVKtvBTwE
         8m2Pj0TRoVqTkLMw8JwEw6IScG82w7J5vY3RmjOmho19ESU9L8/mupFnYAsnQk16DCS4
         VZidBTQjEQjE42Hqntjkv407V1AS8sVfJycj2xzygr8Cl2lHwwSBsnB5eVbk6IPMF8ig
         uP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793589986; x=1794194786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G5KGtvw7DpJGGNS4rFHN4nrIn7gUZjudz5jjNah3jeg=;
        b=s6ea0nFzAXdgMPwQJ5KfrePXjBxdrgROHmVCjRJ/LJXUJ/ecIXBgJZnZm/SDXxZsC4
         bh9d+o6LUtNzHqSr3iW47PR5J+hWVd8BI53QGOrJaORnDqBvVZlylQ0AfyDojI9QuFP9
         CBDq6i7hUHb+LwatMpTLoiUculMPcWcyLcOAVk/JuaD7j+8O7QR2uZFSNzd+dxut0O0y
         cbTAsn4pY8Lqgcz6yJvNCZdtwbCi7ay0iBtJPlKt9VVN0npsgS1q19llfZ+u1gvz3C+9
         TBq1+CP+jwtNx+OFaab573mDv7xeqKSN/ip3JsMkkpphP27WI6S94CuXTY6lNWRiio45
         iwGw==
X-Forwarded-Encrypted: i=1; AKwUvBwtB9Yov7Y08hJuwWTUqidnI6KPZ3cKYJ1ft4kUi1HYH5EEATYGOrzDzWtEdt3+72pzAxw7kbEsnw==@kvack.org
X-Gm-Message-State: APuU4Z9P8AJGX/amC04oHhnAYNnIb0P56uggxvz986NESVZKR3cbwgfK
	i6OzYuIZmhrngzd2yuK+nPhBrNYC3e44Q9H9awcGQZUnl6zCgPXZTXhupzmadwyVxCo=
X-Gm-Gg: AYBFou0R04q0yS1tRPcB6whf43+dzGLbshMTWBbydrvCrsNmGJLutIezXZnD7Ado1Sy
	PLLEb5FihZQ0ldome8506+dxiRIuTJK6M5MYW0XxfXFqpTnPTBBDf6ImiNF2HBaBvI7MDJy/+U1
	AL9hPdjQTXD4zH5GGA6Q6vTTx3RZxj0VeRVAGnkG/oJQy2uCNJAOo3IPu3+B8Qiq6tCwTZGyI2w
	S8b8o3aZ9OfkODiLdTP4efSgzzwe0ULO3ReKkc0Pz6ckVe0ufPTIq3ULCE55sL4ciAsS5TyfNHQ
	NXV1t6MWftEbPlKy9ynzTIEipdvIXGIaC88sxliTHlcSyfhxnu7gpGidF9iNreElzkGxXRHQmAH
	exjd3cc0JCpZFdDyXc5YSlTck/XJtHt1BZT19mousJA6D3Fea94ifN5Ms+4toJlrrsmOs0AxmKw
	ou4fqMVTRdQmzAFWUq7ldSEgx2N2xA8dKXwKVM/84NBqnuvf+uGwPaEd0LGyKxzO2BmZSFmUa+7
	NTTcPXzUGOVsxaTte9GZ/NiWMNd3csrrNSEPaLFhvP5c3v+wtpdYm4H3nfpL+HKS2/Kd6RdGPgW
	DYy7r1Jlg9CgO85Q/Ee/6XLhIlT8/lkeb3ZbjO7aQD+b2gDqvA==
X-Received: by 2002:a17:90b:3807:b0:3ab:413:49bc with SMTP id 98e67ed59e1d1-3ae897994cfmr7194939a91.37.1793589986178;
        Sun, 01 Nov 2026 19:26:26 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:25 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 01/12] mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
Date: Mon,  2 Nov 2026 11:25:14 +0800
Message-ID: <20261102032525.3597743-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE74940003
X-Stat-Signature: og55mz9j75skmxh7ifxxmnbouxe3rgbr
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793589987-901420
X-HE-Meta: U2FsdGVkX18X1/YhS6P66ufmhsPSAUeEvJWc+9NdGNsOMlM3t5C3XZoqYX9l3qdUf51+UgfYhNsr8Hs4pNZLr4RaaF5eDebz/mwa6MUd8gCinrDpfMVImXGVDT7+m+tTGuB8iMkbbHV2NORO5gBtGmqg1V4KSRPBr8srLGziM5gE14jc26RyfuRwUNDnARnw5aus78JNVnSHAl4rvjum8RP2zXElCQ4lRbjLkh+GjbLTVvJJgxyFZ2O0WiH1dhCRd5wRHmQrJb/OlOV9pJapzEyRMUyZQySyhRfoAc+VzKhVgH3Q1WOEvNss7ci+H0te9q/TpoR6ci1xYNuExuAywYtyEb3eaIq3IXlqN33WmUi0WfmFafaguFpPq5Ti1TbranhXH47RIu3kKJhbYEe3smMXIF6zpctsaJEFwlLwJqCeOPzpudxwbg9mh6J/ToalxUuOYpLNvnGXeckGeTEtdeVSrovG/IO6/Dzf9hX5nf9xqQ3oXTVrdson8HUvOClu58hVHpug2jHNViu5aKlPvCm2J8tEgOnh87RJ+oQdMrhFxoJSyeOI7Tid/hyklPRp9/hUtxokdhokwuoc5DCEjZx5aumOHjjdmoTtBowjz+rNN4kGu0KdfltPBfuPcHu3JGnlHbB1iy7DlENLWqbKoUZ9o/b2k2v0hAkWjdIPi1MxcptYks9NZL0d/x28YkLqExMoQwE3nDkIGxu5siS3BUj09x2QmYIM6yL+81rRmBfwG7Jb5bJwXxBwatDuT7G62XP2tf1AFEB+mFkiTIgESFq3yNDdotWxE9/UNEAywTAWfiAcEyzWtkDSH0N1nXwfQ/jq/79sjopSAADdb6J8UfR8eoV/0PiVlGl8r+LH4QS4Rxw5w2g15/OzxI3SoNOwNX967ifqf/AcIN4jwsXof23xtnUXwhC3QndZ//crfcTwDmBqCN3oUZjAyjpLJ9zjTu2a3CMlRYkv2sMRh2J
 OKanZil5
 5poBxaIiviuDEp8lGGJMVlFpiWFccM1wTz3688ZfYFNKQ50FMPzGWYF+cg0vYObBN6onR5yAZU8CIUngqhgM0eabUTlRrbzR2IG+CgIIJaUlLFEKZxEAgmroWkvb3P8o2RkgTv54N7r/B5PusmoxPqkCUZgv7cCwPdiWMSkxfqRzESPIlnT6Xo3vgn23Kw7CdaaaI1ruwGZI6Xz8A+TIq7/RV/EWI64R+7zO7GFdnY5/9/WIbaaba4d3nSzl3aYtuJE9Efkb2dNxJfwhUmAXNNM7VxIhgg0ecZ7Et96WzRFj4pKcVs8mxrNs8xxirml6jXvFKaF6PTXk5Hi7D+l0kGbnMUceGFAL5vfCM69+DrSrQytrBzkN7XsO4Ya4TkxOA6pK6liwDRlJCMM1Pe5gsgNZZpn6Xe9gchlRtAtti9F2fGRsfx2y3A+f5t2LG2oSioJud
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap optimization is no longer HugeTLB-specific, so the remaining
HugeTLB-local reserve macros are redundant.

Replace them with the generic definitions to remove duplication and keep
the HugeTLB vmemmap code aligned with the common optimization macros.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 include/linux/vmemmap-optimization.h |  4 ++--
 mm/hugetlb.c                         |  4 ++--
 mm/hugetlb_vmemmap.c                 |  6 +++---
 mm/hugetlb_vmemmap.h                 | 10 ++--------
 4 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index fa9e9abd6656..065840f3c241 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -27,8 +27,8 @@
 
 /* The number of retained vmemmap pages with HVO enabled. */
 #define VMEMMAP_OPTIMIZATION_PAGES		1
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
-	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_SIZE		(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE)
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ff9dbfbc7a96..7c26be15a741 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3301,7 +3301,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * be no contention.
 			 */
 			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
 					pages_per_huge_page(h));
 		}
 		hugetlb_bootmem_init_migratetype(folio, h);
@@ -3341,7 +3341,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index b8ce014ba6e6..4b73d6ec8dce 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -408,7 +408,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -676,8 +676,8 @@ static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
+	/* VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index d717d0d10960..d057e8b12bf1 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,13 +9,7 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-
-/*
- * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/mm/vmemmap_dedup.rst.
- */
-#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
-#define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
+#include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
@@ -37,7 +31,7 @@ static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+	int size = hugetlb_vmemmap_size(h) - VMEMMAP_OPTIMIZATION_SIZE;
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
-- 
2.54.0



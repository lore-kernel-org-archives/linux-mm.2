Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5907CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AAA6B00BD; Wed, 13 May 2026 09:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271C76B00BF; Wed, 13 May 2026 09:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188936B00C0; Wed, 13 May 2026 09:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 070ED6B00BD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6F4A140A80
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:32 +0000 (UTC)
X-FDA: 84762428184.25.9AD126F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED38714000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Uty+ipUo;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/meEdlZTZDHs3WMdtJ4iXM2mc4vrDnOJRWI7aUMJSw=;
	b=BDC1N7vHpcILA8QvSrdnuNCXok05NisNvTlgQWjYb87y/kK+46iIZfJ95NdLP2IhS2Iyrl
	q/zssuKYjxa5nGh+Ac0g/RydLSkU4qmD88I0UfktJ9ayLckGfiWUXljITE716GSCNm2Zwz
	yDTSaNtYd3SKgIfHCp2FMScuc2jXDwM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Uty+ipUo;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677771; a=rsa-sha256;
	cv=none;
	b=Kk/ZWAEVlA3LgFKuc/cOlfCdNFkszQYCT+VYkMrWkuWph8cQMjJVY3+YF77U+w1/C99R5p
	lCAE+kcs1x51F2qdVS4bE/KS0Yu25Me5QZ2upCLgLkpOnB7sBs7MA/y4IvAspNB4DooeQU
	B24I3tSr3G3MOf+SQXjhkBlGvM33HPA=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ba1e9d3687so44377575ad.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677770; x=1779282570; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G/meEdlZTZDHs3WMdtJ4iXM2mc4vrDnOJRWI7aUMJSw=;
        b=Uty+ipUomzMdahQfJZ3kVzFrRYVPEI25LJuSeV0ZI8fuFYVyjjm9c5EjNYUTJB/Y3J
         VMYy6c1It464cjrhd7sJHVNm/fi5nYNKlRpiebr+H/GVQ06wZl9zI13OAlfbFhCy6Y4v
         wQ/LuEepePR9HJBSHlbjmTQGVz1FA0bd0olz0kzBCR/QToJObsw3uYQdi4J+DMfMmuVz
         g6q3ji1lsXn2ha2d4CyiAeo1xkLBzIYz/Ryc3OzQL8aTv1KmaWgYrSk4VBk3sYiXGC/P
         aZCDGcfjVxbmHb+na5GngC5qNpBy/bv59l4/rmmYz226GMvQH1vJQTSQ3Vpo3IpGI/iB
         mdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677770; x=1779282570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G/meEdlZTZDHs3WMdtJ4iXM2mc4vrDnOJRWI7aUMJSw=;
        b=kjVw701A1s/yRCPtTHKANEiscRc81uTR5h0rrERpcQRlyfXwnWPjjX58/ORa5q1VZc
         Ch7TS+cS+4Eq7gh/yAepykS45j2t25Rgw+3bhAe/NPoBgMX+sGtF5xLqoE2mWbJbYYoj
         iO2IxGINvGfqzSv9zCG3pKA7NAmEFVIsPeH/qgux3JeymAguqggUNMMo4IlZLkNjNguE
         9VHFVqgw+V85vCgyYCPkm4toLqCOZKp7shtqwB2N49uxCum1XLgrp0FVfPTAG7ZHjXwP
         e+zDWcjnz32WonU0c9DcqZj8DVxVbNPuPor+gCT/21ln+44T6cPqg5lInrjTPUWo/4El
         A9cw==
X-Forwarded-Encrypted: i=1; AFNElJ+B+URfWLliygqa29AKEqKLGpH1am/mPkTukcKjN6RuF4KzbDLUTab7E9YKlm50V0JWBZpDLrqFOg==@kvack.org
X-Gm-Message-State: AOJu0YyCbF83HSIUgM1nfRNJ+5EPGER9uRKJGjURjOcGMT3FzAaSnpGX
	q8+6gEd8i2zz7I9tjOgY2Pzx7PnvPnvD/q7KTyQFyTIRq36zQDIIsSEDmB2x9RFW5aI=
X-Gm-Gg: Acq92OFAKtocoUY/DIMknnXE/BQXiBDLlG8bBzlvRNeQl2bxNXB+ncNeSOSfOxHVmYb
	iNu/A5FKfcWjqpBVoVE2lq/4LR+SrPwTIimW2/JMJ5moXmvkw+RHoQ++wB+VcNF7duils+qDk9r
	ICRc76aBo3K9os3lqyuvEOswEff79p+eWDkrA6w5dh08eB+PW4VF8L/uQUvrua3XLXmKQpuVcyv
	ObsoNG+MPFYWqcMyQ6twuFrWzPGwnCKSP7a00HDQVYhR3OXCOybfk7nLkSyyt0+lq4ZeQbur+Y+
	qCse86w8SK1kQIff1VnBpU+iC29BMxBi75FIPpD1anlhpa9g67pTAsP+CyZ7SM0cdKXML6dhduW
	pB2fgCxQ7UcL8PYHrdrZ/ZWrWWIm2+/2kBJXyX73rYywDmev0fbkVSwif+aO1Y6OjuLkOEXKV7z
	guIrVw9qfXGJn1QLYgji7xKbsrSo8srbXVjoydqRhArcVlE/XbYyRbWCIYmp4=
X-Received: by 2002:a17:903:38c8:b0:2b0:6f21:8289 with SMTP id d9443c01a7336-2bd30210f0dmr30869055ad.25.1778677769571;
        Wed, 13 May 2026 06:09:29 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:28 -0700 (PDT)
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
Subject: [PATCH v2 21/69] mm: Rename vmemmap optimization macros around folio semantics
Date: Wed, 13 May 2026 21:04:49 +0800
Message-ID: <20260513130542.35604-22-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jsew9ao4a1kp1b5q84sm15ws83ux6k3a
X-Rspamd-Queue-Id: ED38714000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778677770-657632
X-HE-Meta: U2FsdGVkX1+QfUD8sUzbHyHzR0F+UwELjIfQ/BZL2EzshhSVoj00uOmsNfzQjYG29qAhd1vmYdvEsBBkz5HG2gC7ywxiqfPfXYEzeyZht+NteWpr1eaEtCdkWC6xx4gieg2FJf4mb+hDEY1RubFb6PQVfr9+SBVSQqS9Nx3kS3P1nC79OUvShAb17iirOivZM1kjrY5zssfA2zjcTsn9VypO6eIPevQV9+hYsippMmRuvXeApxZWMCaduV9eyEgxkOdVJDqDflzzLJYtzYD8uvq1isj8LwhTQWdRiCqO+m8IVzCBvDEhCuAA6NiULQzPYNtiHjoZWf8jxV93w5MJSdowQ2r+fjn7OaP6YZJWi33MsVptzohZC1ndtbEz/x4uYwowu/AH7bB+BsH4/TYAItlxzzR7QYH0nymm32AOw27XuGJtLH9iRz89Dc1gVRpkrsWTkHdFSCdQAPAPZ2B50QBtMra3b3cpsfXQ4pnrsquRSSujUNcxqnv/wQOyTcsf7vfJdRNQqK0gk+zKFWxi0nuXb2Q5ekd1Te0jrdZHk+P+Olme2NCK92sRoHdySajaMtppdTAR0vY7wRO8uTztdxp4qefRZTfXn0ppR3LhAM9lYMAYDHqt+cB94iTt5v4NKJQn/1HPFXB4On00376tUN8NpkElTWJ/30jmh1LPQdlxlZVbzIFKEcBIynv39B+QL6LfltMrZ6rvm4DkOrKIz6vX0ocAyAOczAs8Fw4dp1uii77GqG/kxclxPNTbFcaAuJTRiWwHlkYR7ageiJdDuRWgOvebWI8HUF0DzEo4whcwuKg6lDj5/hjZQN9HWnWUhtGrA3KAnXNo9kzPNIIR4UfyT1gVlHECkkbjc4jrw63POPK0A7+08IvUHJ4aveGfU0RBf5ye/KLxk5jGSejLVbtt+6rkqoAP7GfR25nHgQNK6WCO8K4wF8bMKsfjd/Nfbd+2Xu82Gh39o23xpvu
 RnkaIThw
 u2CHQsAwNsTjx/bUNRrI7irc/Za2iHCGiOBjVB2qUUUz3+AKEQaWMwoBvREOvfvPu/MPihvdMdNsLlVgnKPxp8MGNmQgOKs2jPE+V9rsr4ASVBL8Ucgzg/hkiooAOzj/Wvfla/iAv4h9mbzfy4LJ42+TFZ6UOlfS6ULqldgl8DGRqZBy9KyWbwsBl6FNkCeGq/0/NtVSBpOZa30O9d6dMamVJdaITnPvvCrYrlwx/WaBU+kOUROBg0Isl001a7XoZecqDqHtC7PU7JF5Ij7BxuApFET9hVV/HNqDvWa2SPzCCCrtqNSMA2y02pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing vmemmap optimization macros are named in terms of tail
pages, but they actually describe which folio sizes can use the
optimization and how much vmemmap backing an optimized folio keeps.

Rename them to reflect that meaning directly. This makes the names work
for both HugeTLB and other folio-based users such as DAX.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h | 18 ++++++++++--------
 mm/hugetlb.c           |  4 ++--
 mm/hugetlb_vmemmap.c   |  2 +-
 mm/sparse-vmemmap.c    |  4 ++--
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 362e16497533..40b1cea98b82 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -107,13 +107,15 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/*
- * vmemmap optimization (like HVO) is only possible for page orders that fill
- * two or more pages with struct pages.
- */
-#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
-#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
-#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
+/* The number of vmemmap pages required by a vmemmap-optimized folio. */
+#define OPTIMIZED_FOLIO_VMEMMAP_PAGES		1
+#define OPTIMIZED_FOLIO_VMEMMAP_SIZE		(OPTIMIZED_FOLIO_VMEMMAP_PAGES * PAGE_SIZE)
+#define OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES	(OPTIMIZED_FOLIO_VMEMMAP_SIZE / sizeof(struct page))
+#define OPTIMIZABLE_FOLIO_MIN_ORDER		(ilog2(OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES) + 1)
+
+#define __NR_OPTIMIZABLE_FOLIO_ORDERS		(MAX_FOLIO_ORDER - OPTIMIZABLE_FOLIO_MIN_ORDER + 1)
+#define NR_OPTIMIZABLE_FOLIO_ORDERS		\
+	(__NR_OPTIMIZABLE_FOLIO_ORDERS > 0 ? __NR_OPTIMIZABLE_FOLIO_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1146,7 +1148,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+	struct page *vmemmap_tails[NR_OPTIMIZABLE_FOLIO_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1f0a0e31d624..53448b05ca11 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3318,7 +3318,7 @@ void __init hugetlb_struct_page_init(void)
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < NR_OPTIMIZABLE_FOLIO_ORDERS; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -3326,7 +3326,7 @@ void __init hugetlb_struct_page_init(void)
 			if (!tail)
 				continue;
 
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			order = i + OPTIMIZABLE_FOLIO_MIN_ORDER;
 			p = page_to_virt(tail);
 			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
 				init_compound_tail(p + j, NULL, order, zone);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 952216a49bcb..e9906d32a64c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -495,7 +495,7 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 
 static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
-	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	const unsigned int idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
 	struct page *tail, *p;
 	int node = zone_to_nid(zone);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index d7e9fb47f7ee..39529245d790 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -318,12 +318,12 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	unsigned int idx;
 	int node = zone_to_nid(zone);
 
-	if (WARN_ON_ONCE(order < VMEMMAP_TAIL_MIN_ORDER))
+	if (WARN_ON_ONCE(order < OPTIMIZABLE_FOLIO_MIN_ORDER))
 		return NULL;
 	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
 		return NULL;
 
-	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-- 
2.54.0



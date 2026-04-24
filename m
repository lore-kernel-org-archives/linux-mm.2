Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B019F9936A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39906B00A0; Thu, 23 Apr 2026 22:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB716B00A2; Thu, 23 Apr 2026 22:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA496B00A4; Thu, 23 Apr 2026 22:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA9596B00A0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:56:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9301A160BEA
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:04 +0000 (UTC)
X-FDA: 84691935048.01.D8BB984
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id B2C921A0012
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E3Gy4yK5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776999362; a=rsa-sha256;
	cv=none;
	b=Pd2xQLsEnJs0XeCCbc1fH6ZqL5T5Oamaqr8+7BSOgM8F5nG1TcoCpMHvC7qG1vpMGpIGkV
	qmE1r1aOBy7z2LnWoF+2hx4B5BT49izw3O7H55ym8AtQHLpKYtWGNT1H4lnf8ovyhqFZ2H
	UAlJCGeuEZ+ftaeukr/sA7QKX27ehf4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E3Gy4yK5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
	b=pac9f8UtVDru6AxwnBq6jhCsKIoZ9MKh86zqIuT7OQp4TjP2HHzRkae2go2tvDoFrZ3Dum
	rCujp4CuQ7Tn1hAwmjM2FANLqcED1vDuLkRJWI64f0V0pLOfKh9NWktIxgTU9SVCU9H/Gv
	D2z4HHE89m+7xBYMKVXbx+sOBqYumNU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b4583f0a1aso46454905ad.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776999361; x=1777604161; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
        b=E3Gy4yK5MGsIuQVlgIsAMQn5a+pkpnxOGyWtenOK6skq4JhVvo+yMV+/lRj2wMqb+n
         WDbLXy7iJLLrijPe8HwrSaRO+q+6tPZr8bZ3dxgTk/EFXCSHJVhn67CO3nxUTZuS0b9P
         GX0hIe8kwWW2iIf6dRctLH2I7/T8MXXaN0rhGGkk+KNBhMciVzQAy8r/llPgF+u2plWg
         0hLRD+3h6Vtmtl6ifGjKu/Idw+/bNpuQrJjjFQxc4lzvxt93lB0Rn5saUYhSB7i+bcck
         q6N6bePrafkXaWKyiBFOZMMLPQkHdjIgPGF9pMfCIBpNTbhn0kHqNllU2o/n2kF9hTWv
         9qAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776999361; x=1777604161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
        b=PA1GE38WcpQmJexYsTiR4eEzdlUGDZQ1ykl9OGBh9MRUlCWpJoHOy1+R2hQJwUa6y8
         78XeNupy9ucRsNP8KXoK8IqLxTW8Feub/QA1GYAFtIX7/wYt8MGrRRwhm3YV2tbxM28K
         thxC40t2fuh8ahcJGd9rnZqPMe89KtYfsoCPaSmHtI4kUZ6sP/LuH2h6tuvVFJ07JvKi
         757a1JaMOS9XMKWOyOz3XzSoAS+j4fCHPw0FG86f9gp0iqfBES1gnv32w1vg39c1IGRD
         gQq/RDU5vZTjkmdYDxI2qnDqz9TFF9sLag1f615ssB14+o4OjZh8QyY5IgvP0zWp9L8p
         PWeg==
X-Forwarded-Encrypted: i=1; AFNElJ+STg+dBfWlz/HAV4dv5ZabXqFeHsFc+oIVn2X04rSnE4q0U525/k19hEUwcNcUkJCTneo0xCQrsA==@kvack.org
X-Gm-Message-State: AOJu0YwwFQsuDhgn0lWVkJpsCLUhCZC8aTtzOc+0i1pDn+I7gzobdtDq
	dH60OiMZofjDcQERhreMya2qxa4rzPF66MtDF8Fa20IojXRZb8vZbJALd8OBEDE7WIc=
X-Gm-Gg: AeBDietYsLh6ED9MN6rGAGoZGQcXaG+cuKs3stGdOh4HKQ9XZ6q/uDAuQvJ2C3BvTxX
	4+OAVM0qtqmBUiwmr0gZwAwn1AIze3EcZnHOnGBuHMNfwMbaL4HhfVFgCM42FMPQilb1aj3zHIZ
	DIlSG8oj3gULYClykAa068jXAHCSYxOcirHA6qEqFzr6d3BDgAb4aRKrZEaunn1+bu7fgBTo+zW
	kLMjsW0JA4cuyUwLiJnTBc/0K28FL2sSXENMrA4pbDGO8csfeCYuNlLjlVJ8XEmqpX2vrKIIhnC
	TWsa2xaKgXxE/fxy9Hasfkr8bv8DemIjt9VCiZ3tJtmBYpNsZmaeauMcFvPI1TVTH5RR/+cgeQb
	Y9jLK0taNSGRceIUNLddthsT/E1HJncBlW14lG0gOfPEmMwhgRuzP1zYFGgljTJxX5oytjcyWSc
	NgLO9yuTS/x893YjmzYwqa0z4um4pmNJqWzTy88LvaFRBvQmQvnZjRrAs=
X-Received: by 2002:a17:903:1b03:b0:2ae:ac0c:5a2a with SMTP id d9443c01a7336-2b5f9e7a9a0mr309495685ad.6.1776999361448;
        Thu, 23 Apr 2026 19:56:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20d33sm221668325ad.63.2026.04.23.19.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 19:56:01 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v6 1/7] mm/sparse-vmemmap: Fix vmemmap accounting underflow
Date: Fri, 24 Apr 2026 10:55:41 +0800
Message-Id: <20260424025547.3806072-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260424025547.3806072-1-songmuchun@bytedance.com>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: q5o6hgufhrqi8fo6oaxabwo9n67qjaoh
X-Rspam-User: 
X-Rspamd-Queue-Id: B2C921A0012
X-HE-Tag: 1776999362-730773
X-HE-Meta: U2FsdGVkX1/ogoBeaRX37CW+GIhDf9SqwtYnjhoZGWhfZ4XwHs0b6cvcZIPROmIaWY4Fd1HLvPSg54RUAcVumt6tc6xDrrcGaf5C5KtsAZ4OhalL3Ycfq/u1ty/TJxheJeDOlhAlzq6AJ5KgOogrmfO3XCbxzSCJpDkbqkoWlf9MSRo4PZ6Q0L1zplc/tZYg7s9lVcMXyncfN9/3ZHPgjU4o3QQ9+C0TGWiKHxiJIDBFOIpmuflX0hc42jDlefg5ZWXcjf+OUI6yLz8No4so+ZkPxuQilH6CsnTd+KxmlROqG469NH6BAVgcgL9MvoUI1FRhuVH+IwmALkd3W7rBvePTkjNLsnVpkGebe0nssojYUffTlWgXZVABaek+VWtuup75ObfuAIUBiT4if0w8aj7inU7hbQJk+G7Xz9+zeN72QDjWjH+WDI/nunWJLBxXDLbJDZ2xlcUgiaficBqCkW7vsLSw0Vwe6KvJ5Wf9EayRgj6hSMkYdX1tm5cguynIXQAVkK7WF8TDhAXDmKNI3O8NyC60hA00uleqs1XkfpfRg62DWq4/7K2n5GJr/cGHW8rTom1hv5psBlJLSUjGpSCRrXi78+9DdByjriZzQ2F5mG6G/cNLVB1mrvMi5gMcgeH/oTSiMOxgET/96GHtxlAUI2iSjMSPbvM4m5s/8wjQZ5T7zklK8si/EYPZv4Ygc6uEJZp86rlholjc5iS3/Dh+vMdnhKGVyRSubCj5OW3tDQ7XGngeJoOvfoPffVukPvbWz+O7d8amRFoZqsA9sWos/TBkTVm073+WOyCGCMneyTQgOo89qSe0PoCMPf+hsZfqSolfsKZDRg0jkXlfC/hlA+SSoSRNcocWNP42gImiiKQVyYU8xoyEMk+uNqjbA8ClhYeI+0j8S5csLAytmDVXLcTMLEfs7UioOzfG0Ne1rHHJTzTL8T0HlE0Q3SymFN2KvBDmDLifoDu3uTG
 IUdKKs0v
 Qwlf1oXsjVRJwytqctysNmuRtPtC4WKH2qrh6GP15CvtE0T49DRQStZbX1qroxs2CvIycm19RMh188kWp8IiwsV7dT6Txn5cYXk6AVBayUlof55enr44kFfRGpOco5DtezOFN6t8gGmm7/s1jxr/dETLSp0lJZu4Pei6T4JKQu8tR+xGbk8qVja2D/LN9b8aV9GzDbKzSGpNyZ3QAy0sm0U/9I0L6/VV63yBsuw2tJWqRjOfYdDPeq3zbOr66GRnUIHraCFnvHTnXT7Ucr0p+kt3MmzgfelIdpmlgHMpf2Z5iyrGHJo37uou43nkxng1anKHCWHkQjp09cKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state. This
causes a vmemmap accounting imbalance.

Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
memmap pages are accounted for only after populate_section_memmap()
succeeds. However, the failure path unconditionally calls
section_deactivate(), which decreases the vmemmap count. Consequently,
a failure in populate_section_memmap() leads to an accounting underflow,
incorrectly reducing the system's tracked vmemmap usage.

Fix this more thoroughly by moving all accounting calls into the lower
level functions that actually perform the vmemmap allocation and freeing:

  - populate_section_memmap() accounts for newly allocated vmemmap pages
  - depopulate_section_memmap() unaccounts when vmemmap is freed

This ensures proper accounting in all code paths, including error
handling and early section cases.

Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse-vmemmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..a7b11248b989 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -656,7 +656,12 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						      pgmap);
+
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return page;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -665,13 +670,17 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
+
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						  PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
@@ -774,14 +783,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+	else if (memmap)
 		free_map_bootmem(memmap);
-	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -826,7 +831,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
-- 
2.20.1



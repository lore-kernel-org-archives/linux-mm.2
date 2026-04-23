Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC7CCF99362
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CEB6B0005; Thu, 23 Apr 2026 06:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344AD6B008A; Thu, 23 Apr 2026 06:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282656B008C; Thu, 23 Apr 2026 06:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13E0F6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:17:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85062A044D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:17:15 +0000 (UTC)
X-FDA: 84689418030.19.1653087
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7EBD120009
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:17:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RFBGSqV6;
	spf=pass (imf29.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776939434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=frTACpmb1gU5Mm8qKaOFRKyGA2qpKu8YjMm3OEI1sRk=;
	b=wSgAYrGTWZjbM+pl1JYxWxdgT6AN6E9bAUtVoLvO2B4n4xLZgCNTigeNxVT51CZ/WeaHj3
	PsOnK7FfbZGXf2FttJuHg/eC2dEjympC9CXPthjjsni0RSc5gOOl/R87xQ9hj8Toki3RbB
	plDWbv39PJ08nuRmqeIOJ4aBxW4E8Og=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RFBGSqV6;
	spf=pass (imf29.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776939434; a=rsa-sha256;
	cv=none;
	b=zSk7d53+6lfVJsNOtcIZcs3MbUzET73hY7Pvuq3W9PWXD1I6uEY32hMcTJQ6JAjyDUNEL0
	4yETGRAVnQzQg3x0nowNzLT0yUT/C2ycp8z+kkejl4wdsvft0F3TfhpXAtqa976rh0MsR2
	vLXANrehd6JQ7oXUtzXnVCM2aosXuP4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776939431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=frTACpmb1gU5Mm8qKaOFRKyGA2qpKu8YjMm3OEI1sRk=;
	b=RFBGSqV6C3/UOfVb5Ri5/Q1xNHhh/iCrwlSGDATjPreLK/lQht/Jm22KdnT72G0IKGmK8V
	KiliIqndRTcelBTAif8Q098q+wpJRGwDUorsvarcxVoXy43W3KXa1qwwQMKJBx545G7KTJ
	Y43PUIB4IY9o/RL/kV3uDZla7eRHLKA=
From: Kaitao cheng <kaitao.cheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chengkaitao <chengkaitao@kylinos.cn>
Subject: [PATCH] mm: Convert vmemmap_p?d_populate() to static functions
Date: Thu, 23 Apr 2026 18:14:41 +0800
Message-ID: <20260423101441.7089-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hk84p5cyujn75npuczszj6cbaa8uwzbr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7EBD120009
X-HE-Tag: 1776939433-697026
X-HE-Meta: U2FsdGVkX193pPWKSXT2JX5WeQbwjwqEA8Lj7HT2eVGX/eVAxNk7N5Ah2jaykhLOJOjtMl6oU7LLZXa/BTyNSIdLTScIV2fBk612FtHTSdkRK1kjUcbK0pKe5IFh2Xut3CTH5bgcr9Rhqi9OYyO9CQ4rWoIOFSO26yqliHUmw5H+7x+l0ILc55hgez8U2cz9DWbP5dbOvOPg3IyJNJWxhV/iOSX+OFcS5S3D5MevsiIFwiy2Py2OcWfP68keeTs5l9d4JDzCZM6ZRiztCklNRnWKWEVo2o7uygezktzudHHNuKrXuICmiOI6KDVrKLrTWkSoMeK9L7JCS2LYZAOjOVAM7oJd1rfkg+LPVU4Pa/5i58CgvlDA96s9KBB4BDcmKkcmsoh99BXylZZt0nqVuEC2cXd/V1y0mdBXkuj4D5yn/c14ig4xgWejaGHsHuyJclXgySEtlIMDji9wsRQdfg9+uZO/Rwh/lFyVJHMhPxJweztZjIaznJcOFGShQF+gSsjzEvPThsoBJAjUJh7tBHg2oZa9mtky8K0CXD6CiZHtYH2bNKGmxaqmrbYDvM6SqAVoalgpm7CGQn51KaNmhuzD69Ea3SDnbPWhddI99T2OKFr31kgXhdilF2KxVgG6npQLuI+j62qLUMvhnA8dIzj+rESgA0YF97r0WgkJnH2wpl+QHLz+LrN0OCw3S7C/xvU0hQ8jLwcu0uZpiuJfxJW0qu6ReNao9O7TZCSHLQ/oUWBeYiDJTxvE39QLhX7LI6iptQUODaKyQurdEOEO1kuXmDp39egsGu7eUXV05UFBZpXNvN6l3cV7mcct7ZbfCqa+UX6+X5s0AhwWIrNxiGk2a79GJqVX4TiL4Cyye7pLSz+r2+8wkF8xxYEScTbu+3i2LQm7VmsxlzlyIlYYSdVS3M1lB9eV5lU+jvwaZ9iKOVrARSi3KqWTTkrCobWIEtp4YTVQu6YYWe0qFZ8
 mrIAmjkm
 rrHD+EzBQJ+GNE+7L3FX15WZlUftiGvvTlJa478h9dW3DhqWgwIt1awhWexiFiQMA8e0IdOKa16MuuK8twzRAEpX28GGtlsR43DDdkZuzynwXP0rr3rNiMuBB+iWtkuWqRdOXNwVKNyN4PuXqkCTj7rBvpYCjpR6FzNKS1kea+r/RERhoYD8Jsn+J6cgy5kO1zzc8qFhzjLLbO5Pkq1DVaT03FAiatKFV1OVopedOAS+wlYkuRGrP6vjcnUoV2PjXDP2pl8TK1ecnqVZqklf9If9b1OpxL2ekkgEFmioH7hXlEbXpFKDPgUQVt/pp3UeENpEID1zEO791hqdWzfYVRqG79y3oSzBZLK/sVkVKkWQvk64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

Since the vmemmap_p?d_populate functions are unused outside the mm
subsystem, we can remove their external declarations and convert
them to static functions.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
---
 include/linux/mm.h  |  7 -------
 mm/sparse-vmemmap.c | 10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..1d76da6e0791 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4860,13 +4860,6 @@ unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
-pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
-p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
-pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
-pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
-pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap, unsigned long ptpfn,
-			    unsigned long flags);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..3c35d2303a61 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -151,7 +151,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
+static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
 {
@@ -195,7 +195,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
+static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
@@ -208,7 +208,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 	return pmd;
 }
 
-pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
+static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	if (pud_none(*pud)) {
@@ -221,7 +221,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 	return pud;
 }
 
-p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
+static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d)) {
@@ -234,7 +234,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 	return p4d;
 }
 
-pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
+static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd)) {
-- 
2.50.1 (Apple Git-155)



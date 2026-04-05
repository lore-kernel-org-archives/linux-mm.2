Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A823F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841E36B00A1; Sun,  5 Apr 2026 08:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818E96B00A2; Sun,  5 Apr 2026 08:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72EE26B00A3; Sun,  5 Apr 2026 08:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6542E6B00A1
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E704F13BE40
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:17 +0000 (UTC)
X-FDA: 84624495354.30.63D4F38
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B05F140002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i0pyi0wg;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393656; a=rsa-sha256;
	cv=none;
	b=Kj2d2Xg5oBwtPk9oIcX4X7gRgHm/OJnhMs3B0XCvrDZEJkZjf1lbnAzYFsuJq5qkQHuQFS
	nQxhFvinom4zTct22BeI8NGQ2skPE60B9oB7SF8RCxqhQq3P1MHAsSnkEiRtVzI/YO9QpA
	ozNsG2RumfBxjHTW+1Ju8bBFwExZOsk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i0pyi0wg;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oG1BlwIWBanSrBSTwRxoxLhn0mTG5YlmPdthc1egVX8=;
	b=OQmqICChI3NjbxdZIYxxIv1GxuuCPkTH+AoXXNkn+YWT86naDhFUWiQDAyF/EAdnzPOmZb
	UJZVmCFCxATtn/lGsTDzYdG5tEiukn4KrjIIVob2XAMpkymtl+j9NK2WnWmPhx31rt/jAJ
	DF7sz4s6+JnEx7qQA6EWzTwrrNrOXrE=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35d971fbcddso1861103a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393655; x=1775998455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oG1BlwIWBanSrBSTwRxoxLhn0mTG5YlmPdthc1egVX8=;
        b=i0pyi0wgniFLBVDOvCOvbA2Jr0yYVAOuDte1ov8DkVsaLTnU8j47yA341sg/VteZZr
         7Un214JhKzmBQy2o4+QgibMnpGV9I0mibR3XjhdQOEPTmoYf0DyXuNQRfFmc3w/3ZfW8
         Ydxd0InUAU0eymQUJeRB+72OLhf2hwB7I12W04xALtGZE9BF0w1ifYmWzvkcQ2YV+nr4
         fLioRc6BFe2g1v39tVfQcZ3vVPxK3Za3ClYSqFedndX26RRoooytz5mJYthh+tqxMeKn
         sbe7StfEFZ3aB+/AbRHlG7TYQaa7AOMC/smS43Bk2lLFKI/73jY0TlCqcjFKk3mCu1/u
         zBdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393655; x=1775998455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oG1BlwIWBanSrBSTwRxoxLhn0mTG5YlmPdthc1egVX8=;
        b=ZfpSmtPB0SA+rOfQV3z/96XOIIBjxaCoqxbIHZu8X8o5T3KOxsWGgI8jN4/G5R93gV
         g5JdD5h9427l8i0+r9l972i+jytgYdYPJ3Z7RFoj6AKEagH8fnq9lMaDz+wDUnsEPtqB
         KvK6x3Vc+puw4JFJDN9RUVNn6G+zYvA+Yeba+ar9aJm7nk8iyo3TTCvODB8u3wT2xBAN
         klJWYgJYERhcc9r7Pj9MvuifcFu77xkSC8fjkbzsGwuhL14+R6wBHFQXPoRXVJNTqTiR
         O13zLKSWqk9jL8XTFZS2OxTb2lzkdAQYoBWlxBpIsjBQ9K8WZYht4k9mkdKdVQnJDClF
         vERA==
X-Forwarded-Encrypted: i=1; AJvYcCVwjrszkQ5g23JKXyZ1iUwVNnN4BgWXZoCgU3kdQIIrITx9+8tigvjZgjEpZ4v+gfVO/bS6kypg1Q==@kvack.org
X-Gm-Message-State: AOJu0YxxK0aiIrSyIF5glgQT7IPDfuF5bbwHdYu2TIRLQtRfsVc7ZWEw
	89CaeP25YzZwIho/xBX5aricN+f7tlMDcgniuV5hvaSCSuZf53R111bN288e868foxc=
X-Gm-Gg: AeBDievwDE0Xjk1ULnC/aHNQg0TaLsq9uWQ+wROSp3aaMPmZkaZi0MoLXWJ4WCZtjHq
	7jbQR3xBn2EH4wkV5p4MY3T3Nlg/5lgOEtvOYAlOoR6L4+3HVB3YEFTtX2OU+UtChg6s/1PQtVl
	LfcuQQBO7Qkq6KI/e5CmEY12fn7JBYtzE3oZWDYKg8dCsPIf8DwcpuWy2ssWnzCrlbu/WwDU3xD
	tTNrPA0HtOamq66xlRH1JZpTpgKZmAg3kuRwRoerIFnd/AuaTbEN7PAv3WTpwScocxXrG9m5dR9
	KySj+eO42q4T6xIWzbA78atX4AUZ3mGUNOFOJUCyBBtPentUY59hYrPPQBbzk6KQl2M/Rfnzco7
	UNyl0oTTOvRThDG51hGwLHZDiXW342830EmVeZAf2v0/Cxs8IfYoGmHqN5GZvItwCkkjvSeeOcj
	RdLqy6iyM9fbk4IcB+9aDnQVJR0940C6guEdN2yVWHUrw=
X-Received: by 2002:a17:90b:52c7:b0:35b:a44f:b80 with SMTP id 98e67ed59e1d1-35de591e934mr6077709a91.1.1775393654892;
        Sun, 05 Apr 2026 05:54:14 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:14 -0700 (PDT)
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
	Chengkaitao <chengkaitao@kylinos.cn>
Subject: [PATCH 08/49] mm: Convert vmemmap_p?d_populate() to static functions
Date: Sun,  5 Apr 2026 20:51:59 +0800
Message-Id: <20260405125240.2558577-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w6idmxt9eokr94bqnbioxgooztjizd7y
X-Rspamd-Queue-Id: 1B05F140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775393655-666752
X-HE-Meta: U2FsdGVkX18eLwrPdnci5OXz8xbUcRmJOcmqZ3O5ieco/4fUqZ9hNWvNk9AfG7HPUx+JKJfN5+Hz3Lhb2KVT6/n8GbusF58klqgm/30881hxZ7DCFWtdNySP/9DzRIxzotLAFugtJwuWelfV/vFvm39A98Re3ubJqtxcyZvOedpOVygffo8W6Oce8D/Qd8ria2sR+3VJt6FXqg+8qmc5w6/hVce39g1pdICUkjl+nm2VHEe87xGZsnBusSgxYAVMvvBCktyl7aV1eRkihJroLmbh3TKH3fVu0jp9UWtFp8bT4cZXPU9dLIrylVIHJ4FxT11WezdBziErxPPLIQqR63hY6xJmoEffB0OgD852HmDzuU1/NWyMAPVO2IPNFIVCl2mltA+2INdge8C1E5FFTbemwUc2RHlv/0QV9iflkjjadBQO5JQZIxPNz5hb+0J77FIEpjMMslyF29HCFEDATXk7E4zMNS8DNWy55hnVk7iC4mXl7WRDOAQ96x75+9suIWF+b1IOvsE7Pjk+BddY2ANQvbP0kvuT+dfBJNDyOPOqzBCNW9rivFupcjyYfZ6/5HAvY5O6XxGDXxOzumDSrbmMVS0GNH9+n2Z0RVSRMk4f7RpTLYHUqqEKCf2oy4KrZqiANGOxbKESLmU2rj0FZupBKNIKksC2frgRTPI0V76VZE1LIXUg5FHX6Mxh4TUhRlgT8rD0ws59NsmufV7slo0DdGMlqXHWv2EapOngfP9ThO3jwXcs3gbZWMFpFGjDKr0y3ohPoyfTWBV+h49kLNnIyYcUnj61Q4SZXL7kX0FuePZJathJmPxgfyN5va0FtMxWpoagyVfVbdDZE7y/njV14H10R8ccZlMjNqm5uzH9H9rIxP5OjzsrCVEnCTjIB83oIqNNHUguesaFziKprF9OzYxnvYK/k6rEGCrlVFqX3ydM/mT14k84Y8hzgJUDjoy2w6SHDvmq45doN/J
 OPZAMNPm
 0+7GLSdLH8TofW/Ch+sO2dwJHf0y9P77w1lqYZTCjLz3bTiVEsqRbiWd3zXDF0IOUAQvNEV85cg0J+GVEqI+/IH1NzNQhJTQanhbjGz9x6IVxSoXfP+960Lm0Incy1lK/hhBRLADXZliDtCvXFNN0hkwZ13h0kBa/L6emSBfEe7PV4vHEMPqzQ7m3KjEYlwzPD3OG4nhNhyBBqHJkcxz9dchuHIVQF341RhAETvD8cw49IxZ0lu7BhokP+FghQIKjVmB8Yjw6/Tpy7CWHGHTpLWNqgme4FCzSnhsRCaMmUZVWj4rQwaCRdFDB8oBrN4rYbtV2p1zvC2S3BeDV4coW/slWkkg2HeeSNZYP9pUAO52gyRqieAvNASd3bzbkOysaa8o+5dhIsgKKVAHofVTLfQxZjMiSHdtYnx+z87/b29YaRdA=
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
---
 include/linux/mm.h  |  7 -------
 mm/sparse-vmemmap.c | 10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bebc5f892f81..aa8c05de7585 100644
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
index d3096de04cc6..0ee03db0b22f 100644
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
2.20.1



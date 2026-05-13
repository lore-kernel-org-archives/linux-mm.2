Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFE9CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D8A6B0096; Wed, 13 May 2026 09:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975076B0098; Wed, 13 May 2026 09:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863A56B0099; Wed, 13 May 2026 09:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7739C6B0096
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D7BC1C1DBA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:09 +0000 (UTC)
X-FDA: 84762424698.29.4B63E7A
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53C1BC0012
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bg2KuUaX;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FGAY5sLEWcL6nfZSRVARbstApRC9v1d8J6Ir2cANyU=;
	b=oX66ouKH6DKEvn7jO9cHPp3fAUhiW+uhzTb7SUfOOrphqjFAiKJ75YBpSJtkiIyCiTGNr9
	vNm3EjJZsRtwMnKnDFjM95NAKZxLLaDPSheyQ0z+zd3glKC+4mgwSbof0f1/plV8bPaeU8
	AxcdYDqGqVY7c2MvXcBxdwXhYioWo0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677687; a=rsa-sha256;
	cv=none;
	b=VJ+mp1DOWw5KFzudCCHWj9ktkliWuhph0tvVUpryxdGDzd9l4tt3oC/QTkslM/uqcXPG/W
	mc3u1VltupPHk1vn5T1l/Lm21FmjD8j+cix//xgNv8f5JQByTTOx4fawImaspjghBovr6K
	EdRJYfX1KmXJsT/CFv3Pb3oMIH3CKME=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bg2KuUaX;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2bc85eda6b6so20766765ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677686; x=1779282486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4FGAY5sLEWcL6nfZSRVARbstApRC9v1d8J6Ir2cANyU=;
        b=bg2KuUaXFUKn4SALcqytMQWExB4rxsAe9xckGx5XQki+l0tX5lGj3l62kaxXQfrCJU
         DiNnP5D93MsV+5bBqU8+n8LFRd+s5FgFV2wjwDO7syrRNLvO4tk9NZMyLqpuiBWvCxqx
         1SJySLkMuDB2LFzifyWwTesa4sM9FPWvbE9/r5Qr+lNH08RayGXaJ01nPuseXgsEXEoK
         AGKrUmXJYpxEAPL2ramuSpw3kyTfn7GJNsv/UzDNZZ7hEfZL1BoKHVAnOQw/pbcPlLAd
         7kZuISShV0bNTr2AomGQRxbxAqR2gStLn96CDDYM4QsYBOM6+pCUp1vHeW2AO/qOQMAH
         FzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677686; x=1779282486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4FGAY5sLEWcL6nfZSRVARbstApRC9v1d8J6Ir2cANyU=;
        b=LsEbBnvNb/Su/86ZTAjFecuF4YEVNNBOasP0ntb+X8uqc9KUHsVe5v0u6VWUhzDj6a
         CV9abW+mYqjQXPPMvT/eXr+punhC2zJFULV4yt6QOcfUncgm61nBShQhBe7bVlUyCAEE
         /8dhq63FtHs9fgYlLp+pO7zxbP3X2ihPjWeqNeE5ynH/zpC8xf3WLFrSWK34S7MGy0f9
         7ggwirBWrWXozQs6VmYxOv4D4NnLdJ2cyiHu/bmtmzyuBtW8ojN6q/m8wnzv+sQAS+uU
         AEU9o2VXjAubEBq5ixmkl6Wt74rowsvjmlKHNqlvGiHMxutjDZ9fHBUKOfZFsFRw2xhb
         uWPw==
X-Forwarded-Encrypted: i=1; AFNElJ9MwB5ERQVOghjkVyQMJwKfuFSLMZ9dYC2XfBcC1itYt/pPfFq8d2DRvEmKxFJEbOs+U6nyq3bSRQ==@kvack.org
X-Gm-Message-State: AOJu0YyU2ksLZQuplZ4EhKujyCADMVwSpOL2/kf/VVr0YyeoseUiU+nX
	rNMMalGcPmNh05fXztOWKLv6hX12pW6orPKIduZNIEJ09JoY8xD13mRlRXP2d64xNwE=
X-Gm-Gg: Acq92OFbFW9quOGH3DLQ/zYjopYzqnJlsTBhDqDjNOiSCzVJ9L9yIwDuRkIqDUM40+U
	oPE+ESqJyZ7vjZn9Xta0oDvUQ6n0BlBiajpkW1uSRaHWpR0JzwDt/0pFG390wbWmOu1af7gNrvH
	CFPZDff3d7mWWdeIHPgaM/Ww0qYL+vgCLGe+cSEznaXB1hvKCV+iKsjdGtXfjf2XqyZLFPyxi3L
	h1NO9DaRlQma4pfaw3ENAMsuv4LrJ00gvRCTQ84wVH6U/QAR480A6A1VoQd/TLQQKdbhr42IJUE
	3lWlzPRyOmBw21q7508VQ0N5K6RZl0zWxxkd5qTycEMeuXmtARM773T0i6by4TILtE4iv5RVlB6
	MgwwzaA6v8u0gL6uRn7j3fcp1GpRWpSpH+Iza9xcg7pK4EF3rgrMT8jOVtUWUHhjekGkyudEcbf
	7RCKFV64mAnV2NGO7weIXnmTXVoDmmjhy3l/sgVsaaTvezO0KqXNEFkS4vzgo=
X-Received: by 2002:a17:903:bca:b0:2b0:ac1e:9737 with SMTP id d9443c01a7336-2bd27121cc3mr28132885ad.12.1778677685927;
        Wed, 13 May 2026 06:08:05 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:05 -0700 (PDT)
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
Subject: [PATCH v2 06/69] mm/sparse: Panic on memmap and usemap allocation failure
Date: Wed, 13 May 2026 21:04:34 +0800
Message-ID: <20260513130542.35604-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 53C1BC0012
X-Stat-Signature: to81rzwxmmgyrwpsw1yxs3wphix6nkxg
X-Rspam-User: 
X-HE-Tag: 1778677687-722903
X-HE-Meta: U2FsdGVkX1++bCFnUWmfO+mdaW56cSdTZbzob1tC1ux0s4aTMaLBAkczSHQwbgVjlB8tSsNkVtponaUCPcMVBS/cfIJuQ8jaGTfdI5PQ85GK4wo5+0m7nCZ2OUHIiRyw0BsfAjwJssFW2/B/th02cCvHU36UTYGPDGd6zR49s4EWDylPSRA70zGq4GqY+3pJg57af4mnr23MwXkJr99D05TFmp+Ne2X0l7F+a2EU04TleS0AMOkkZPk8G+AFSNTfUafwAO9eikO99/Y6O95JNDGoED/J7Spe5RDUek7j4/p+BZaRbCs0s2kLmQUJknRcgqvsJi0qLqsJRtpK4wmqHiE8H4a3hbNDtYHAx8pNlqjPPKDf3w1cuBPCAWWSjp9QzE72ZQ5fPzNVXVnYyvGjBQX1RObAKwA5D9XEiWIPVtGe/dK76UZALu92xxz/xZBU5dELIDGhCy8g3yFa2GlrUuzoxa1xmijx0jn7UPKFB54S/cjHlUsYRe//B+0zaZHwyD/0gZp8A8anx0/7HaGFBB+gZ/mcShCTnrFbj3YM7yHr0VIfeb46n2RR6vMq11+aEret0PVzFMPp4cJUYQ5i94DlsceHw5zJBOqe+3DYMxe4LIGK413lg6w6ONSfUJS6kT31LiwMyRA+D9qIDtokxOoExUaKkqGHY1mGbig1sLnQkL+fbma44x9eM7pzRwCaqu6QjQ3ACJwsUT0lj3spCXMwLL8FcltRxMYBl308P84AZYqP7b6qCFdGOJIGvgUOYv6TMQDdNKZmWKyK0oUF5rvuPU0DRWvVXrDg2LnNo7jRK9hLqp2B3JLQRR2m0CCb3oVhmVhFLQHlD5t5+Kj/Ec3l5LS51Z9kiVNIKLb5QNE5CeHH2M+XmbrB+rUzVFCJcimHmnh6y22bKiMzPtxHMr8PMd66cy4FOoJvJTdB562RqkpLnKMPOPwU+R8eXXfwjdnb3A4uj1KLx8csLLQ
 JB5SmPHP
 W5jyU28PAiqU94vl7Pz3+wzNd97eNjc6gXgXlN1YBDfmHwfM91xb8NrpJmLVOGBvzz/DiF0W/QQhDDLZQbEPac/ChR6ODZjlfd0D8Ra9oJdsN5K6uQqFEoLq367uqK/9P4O4ih0S+W2O1nkBcD3hcVSkN4c6lc7ufyHMHQu7WrBKMHam0s/qqrSaIl5hSAnQPj1pRlmYCO7KrnT9Dc6hBqsvXNRgw70AUfsR+VbeNw4ADWAYw5TOXD7aquuIdc0rVacP/wTFQKFyFuokKgAml2RuLnZHCfC3uTGkw+vremS0ZQhK0HF+X0ZoVL8u7hID2sCtzRbirkmkJUvz/5eWTtFFfNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vmemmap or usemap allocation fails, sparse_init_nid() currently
marks the section non-present and continues. Later boot-time code can
still walk PFNs in that section without checking for this partial setup,
which leads to invalid accesses. subsection_map_init() can also touch an
unallocated usemap.

Auditing and fixing all early PFN walkers for this case is not worth the
complexity. These allocation failures are expected to be fatal anyway,
and other memory models already treat them that way.

Make memmap and usemap allocation failures panic immediately instead of
trying to recover and crashing later in less obvious ways. This is also
consistent with how other memory model configurations handle memmap
allocation failures.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v1->v2:
- Add Acked-by from Mike Rapoport
- I refrained from adding panic() to memmap_alloc() as it wouldn't simplify
  the code. However, panic() is still required in sparse_init_nid() because
  the architecture-specific vmemmap_populate() bypasses memmap_alloc().
---
 mm/sparse.c | 44 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 16ac6df3c89f..c92bbc3f3aa3 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -239,15 +239,8 @@ struct page __init *__populate_section_memmap(unsigned long pfn,
 		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
-	struct page *map;
-	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
 
-	map = memmap_alloc(size, size, addr, nid, false);
-	if (!map)
-		panic("%s: Failed to allocate %lu bytes align=0x%lx nid=%d from=%pa\n",
-		      __func__, size, PAGE_SIZE, nid, &addr);
-
-	return map;
+	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
@@ -300,17 +293,14 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
-	struct page *map;
-	struct mem_section *ms;
 
-	if (sparse_usage_init(nid, map_count)) {
-		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
-		goto failed;
-	}
+	if (sparse_usage_init(nid, map_count))
+		panic("Failed to allocate usemap for node %d\n", nid);
 
 	sparse_vmemmap_init_nid_early(nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
+		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
 
 		if (pnum >= pnum_end)
@@ -318,34 +308,18 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms)) {
+			struct page *map;
+
 			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-					nid, NULL, NULL);
-			if (!map) {
-				pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
-				       __func__, nid);
-				pnum_begin = pnum;
-				sparse_usage_fini();
-				goto failed;
-			}
+							nid, NULL, NULL);
+			if (!map)
+				panic("Failed to allocate memmap for section %lu\n", pnum);
 			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
 							   PAGE_SIZE));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
 	sparse_usage_fini();
-	return;
-failed:
-	/*
-	 * We failed to allocate, mark all the following pnums as not present,
-	 * except the ones already initialized earlier.
-	 */
-	for_each_present_section_nr(pnum_begin, pnum) {
-		if (pnum >= pnum_end)
-			break;
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms))
-			ms->section_mem_map = 0;
-	}
 }
 
 /*
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF43C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FA56B00AE; Tue, 25 Aug 2026 04:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178736B00AF; Tue, 25 Aug 2026 04:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F7B6B00B0; Tue, 25 Aug 2026 04:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D21B46B00AE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F16012038B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:56 +0000 (UTC)
X-FDA: 85139169192.27.7BFBF28
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6922D140002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AiXFL9AV;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aBi/OVal72WiVaYLeIQyM3DGjjDwsK1rIANekiC/6s=;
	b=pfvePrNwINDp2HABBt1S3cJHUerUJ8E0LdO4BnzHvD8EnGHvgYpqyEmueNv4rAacsQQkCL
	BG7pr4loLryMISUSIzhww0eftpzQhnI7+c7w1QskDiO1mzueGZBP5c1TYEj6gMThG4S5j3
	Lo6B8+FlSnJtySwwblCkHIJX8G8nsxk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AiXFL9AV;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647794;
	b=UcR6nLrykqkRRar0+dCVmVMWCOd99ThtvcPXB6M94eeKm/E3fSdpaNbv88y/8sYgkA0lv/
	ummoFU+i4J2Vm4Qmb6CGxPdRsKTmT5ldg7ejsbkEzN8zg/nicFXFVfsUFB90ApuVxDQ/+m
	cJwd2V7Sq/uSJp07kfXcT5cI7yFZkRs=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-381b831d535so6636042a91.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647793; x=1788252593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3aBi/OVal72WiVaYLeIQyM3DGjjDwsK1rIANekiC/6s=;
        b=AiXFL9AVWkhFGcx33afcciTUXyjI7js3gnNWFUOAhCEEbUQvFNy7SPP39EJMBDzfed
         H51RQL17BDC6qUW6Hceo73ji3iPQCYltcoQtgdYjuNjFmC04MnTgcDw1F/5DdJ60/TXN
         8H6B3NEbVklotnxrOWy1g00tRUittLe7a4lMDhYz8R9tcVz1b9P3TbmV6qDdJVheK6gB
         NUOILjt7t9lnn6ZDb604jwtoDdEhGTsB77p7L1AEmMIQSeg7kEMtE+oxP4c2rc4pp0ZX
         pAi44n38HLo3yq2izoHNCA0+CDlu4KGZPKWmJaB2rAIekY8C2JEHnDj1pgcKp+HHWFDc
         vAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647793; x=1788252593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3aBi/OVal72WiVaYLeIQyM3DGjjDwsK1rIANekiC/6s=;
        b=LIm6haQ8Gzpp05tRBae9jY+10ygbWpozHJzQuEqrHH9wlzNgxjgCFL1cLVijUvr1Lw
         MiMsGR0Iyx9YnCFwec9KVoKYGkPz5gDzGIBvxYeC9IbjOliyiWvocq0wSH4cziOQptAK
         fMs+5oAvQqBrMsA5EdYI6s78MFC3y7ItbABKFzGn0N10Q+5FRXyNcK8riZxlZ8FtUEGi
         zDul8YHGuOWI0exy1+F/1wXRLXKRpHy+S5jbsmc8C0rX/vVG/PWtlnL0AzG6XjRwh1R5
         1/c5I06M6A68cEXdF6VFlBZJGAUyEbWOuQH8p9r/Z0CQj42XxHC1j3WwLydh82XOVKkC
         5Sqg==
X-Forwarded-Encrypted: i=1; AHgh+Rouj2x6SnrG4efibnou8FlHrNV+KGpBX4SbOf+YXS7hIigbbgQVXCRSVE2cZyZAh9WdRrcPba5GAA==@kvack.org
X-Gm-Message-State: AFuF++m0N3Ak/3HTx92dWhJlf8Lg5GP1HqSg0TwV5XZpZnRcXe+hHnhQ
	Wjfne7yeSgY3899MOtxKxZuf4pSVBrjA5nS60V1UvQq5DqRLnsalfnvDVIoldo/0Uwg=
X-Gm-Gg: AR+sD12+AAl/GnncEbUHMi7f2v68jcZZ7oTAFaDzrnIySl1G11eUfrkVgOeM4NYf28J
	oVSO5eBNDkyumQ1cPDdctFeZtoDaHlkFTcLNeqN7ueTaCUCR+6oDHWlzhk+iSVrKV52gRrWBLaQ
	3B2IsEV3HdIJSX0z9IkmiGt1vUgqgiEojN5oOTLS/iueIkphc0qFFifh29BmDGEDg0jBTLRDa2N
	cd7+OCgWm3C2EKenV6yUax2AMlPhPiMyCIkoBoP+hLvicd28qpSmf0BO/HuUcmBKjJ8c7AVXUex
	VTsnjrP2fzbjDIWupkp2P0X73g7vbC7EP9Jm5x+FeGp0cEOUOrB4oPoYskVSXTghZF3mqANYnS0
	zhc8opfK1sgorrwQsy7h7Sio0I7OY646CSGn2qfG7JejkfEbw06V20JOn8Z6q2ca/dKlOK1D9Ta
	T2ScMwKVh6w6T2dT4K/YsEaGUEg6f1tmRU81nejJpsGXZreOYDiaHbLsrTyH7ejWkkADzehk726
	5ssn/SqF46vicwJhlKcnnBgew==
X-Received: by 2002:a17:90b:56c8:b0:38a:c3f:3b87 with SMTP id 98e67ed59e1d1-3964652108bmr10807861a91.12.1787647793182;
        Tue, 25 Aug 2026 01:49:53 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:52 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 13/17] mm/sparse: remove section_map_size()
Date: Tue, 25 Aug 2026 16:46:04 +0800
Message-ID: <20260825084608.47437-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6922D140002
X-Stat-Signature: gmf4tjpw4k6te9zye93uuc8mhd6on6aj
X-Rspam-User: 
X-HE-Tag: 1787647794-620050
X-HE-Meta: U2FsdGVkX1/BDfuiv7R8U7Iov0TIWAmXatR07a2KYA/YECoySBr2RgE53f5v9KTe4nCU7DbQ99J3YHjd5v7O2CLuPS34j5FDtrL0p3xuMptBwEdRce+i9DZIwcJYw2RaPuVo90SB9zR78D2v9h76hE6+efR3Gnoj+IlcekI7ACFVFyInuEqnqSp21mocFHyF3Oyng9ENlM7wcEB5Qj+tFsJnG4GF5/sOudaw63tmzktTMBk6pY+xI0X9BjutFIuaWAIQaSys1lYC5aj0vIQRZtFIz++kdkiBhOK67dP+yCFjoCA+B0myhhtL3XWIV+OCueYbTUdV0vhQBVOeOMlZ3Lxk9butMBKnm1xQbaGXCzsUKXwIs2gtMDvEteRLY8woj48lVwodP9433HOeVnf5XOKiB4PQkGliQbyNSevpJ9cQe9pMIQbadFYA96Zj1Q4dCiWn2KmnQNlrKgE1nBOOf31AjuazfGQxrsP78gvhjxQcWSvti/MtuL50x0XL/clgZ3PXt5Zzjp7PY+kHjlk4K7XRiL68N7KSWuR4srTP1t96ipCwxSOtrYRimihvZG0890vp7EGkew00Sv8D6TrO5nSlhonPkGSULIMOK5qeKlPbpxLKzwSvkgnU8DJc9BEXCGhdyIpzlwez/dZowewlYuG5W3yodqldYRJB+JgS5XuZccu1gnJtlPCAt7TRHLEO1yvqvqSlyeW/vQRVXTuC8CChZ+2KL6iRS8xYqKcbrGQILo1FxDTyl0n+P/z0l1NDaTBRTbPFurOX7/6Bnqup3WhjFG4HqH0GL1wpoa0JdUd3bWkZWCDMrXRULWn0znxa+Qi8cRSBDM0/JQuLt1Fx60EriCOwkk/vG3lcWb5P0ggBHXB9tqvntntZ+/C7sYQTQN4KnfrvK8LVgPEg2byfUzWK3cMSQ+ijUxbr1TyheY1nL1WAX9lu7Vk0/2+0oAUBcAnzNAjQ+X9/JH6tvPw
 A6XPMUPB
 oGsqLdYE8/V8gIE43oGZ30qjlxnrG+tKdUarzG8fGF+lwjyaN2R+YbmHB+oU/xyPJAo62iadML17WYSUh8DBwE8/HE+gJ6VjwSDdSaO4bDs5HT6WgjYfr90bzpvnAPXWWt4aL+Pn8RAKwcKZ1xBlsMCN7acy9rV+rtynAXXxLXdOf1QZFGzcCsae4DX5Cv0voX1JSd/BOGSvz3YlxfikLh5vMVVkt12pGNul+29O0sYj3E3lrYnaEHSTWNaprMoUP06NgYJo3dptVll4pje44g4ehszE1aFPNHoYv6eQPkxvC241cjW9bBmpCRhTwXsysOfbd8i/DmyTuN7usa9pb7ges31zdkVO6q3pS8/D5QS+HN8VLn6uYDQEQfiApZf2h/QkCaig1pHI1ePSRCH7S3bvLHnsc3OhMVjXU7ZrGqOhvth03EoQ889d+sC/wccOq7dBGyzRPDJAZ2js=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_map_size() no longer provides any shared logic.

After the sparse-vmemmap changes, its only remaining user is the
!CONFIG_SPARSEMEM_VMEMMAP path in __populate_section_memmap(), which can
compute the size inline with PAGE_ALIGN(sizeof(struct page) *
PAGES_PER_SECTION).

Remove section_map_size() and inline the remaining calculation.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mm.h |  1 -
 mm/sparse.c        | 15 ++-------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 441bd39eab73..b19711b6dbc6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5140,7 +5140,6 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 }
 #endif
 
-unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
diff --git a/mm/sparse.c b/mm/sparse.c
index 7096d8e13802..9349ed6326c0 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -209,23 +209,12 @@ void __init sparse_sections_init(void)
 		memory_present(nid, start, end);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-unsigned long __init section_map_size(void)
-{
-	return ALIGN(sizeof(struct page) * PAGES_PER_SECTION, PMD_SIZE);
-}
-
-#else
-unsigned long __init section_map_size(void)
-{
-	return PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
-}
-
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	unsigned long size = section_map_size();
+	unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
 	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
-- 
2.54.0



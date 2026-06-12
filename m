Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 923C3CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06E46B00B7; Fri, 12 Jun 2026 00:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEDB6B00B9; Fri, 12 Jun 2026 00:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6CF06B00BA; Fri, 12 Jun 2026 00:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3CCF6B00B7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62B9214048E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:40 +0000 (UTC)
X-FDA: 84869909040.22.EBE8887
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8640440010
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Na/a1Y+p";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCx1RUengY48xTOlIsoUMtEFNjaipzvLjVymwrQ/1F0=;
	b=YwkXW7xIcGz7JFOUyaYcdUjU57QdDBMC7dxELGKwH2hzXypFA9D32jllhmTt5CCH6+5r9d
	UbHyV7BvOTRMSIJbMOCoxx6WXRWvM4vQdCJll83GAK5byAJd3zwmLFMtBYGSuage0fVnW7
	B0f3fNc7WmWRHjEGkgIVZ3cOBGgPXPY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Na/a1Y+p";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236838;
	b=cbT594LAlaHOTVrT2Khl3zrqcUbMM2yDxn9K5eb5SV7ci+XZAnjEfGne2I7VTN6Pex4IF9
	pBON5IuJfgC/ZkZ4zfkrU51rfEuBzxjGPdPHOSbP+tdDe4mQNGdvoBWwJZHKz00w9m6BZ/
	/Nbh6B7pf/xvB8cDUfit5whv5DoCWa4=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84237c55ef9so426153b3a.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236837; x=1781841637; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCx1RUengY48xTOlIsoUMtEFNjaipzvLjVymwrQ/1F0=;
        b=Na/a1Y+p1eQhg6eVsgD+17Ao9bnyCpAFosFSLSy2PyI4dKxrWLKbHZ2dyOPyQcdY5Y
         +P3cUo/DsACZOXTpDFVA2kQ/35G15uvkC0jAxTjpUde2FM9dEUZJPvFn8JKiucVw8xLa
         4+QA0QEhwI83zaY5b8Iy8xnLacvYd5IdWFhtfQz9fEHVwlrzamfCsWmQDTLG2NH5KWW0
         e1QWpafZQ4CEnC0ZoYfvdli75lNy1aHXd3+2Q0A2h/H2ugw3yfxsShsDH6MZrFrUM+BR
         x+yoW6chQmzXuCnIkNp4s0TQV0GKVOkbReSrxtTN7vJb6MWvYYnrBjNoELmjElFkqIea
         H3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236837; x=1781841637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jCx1RUengY48xTOlIsoUMtEFNjaipzvLjVymwrQ/1F0=;
        b=hO6+Cj42CN7PPYkjy8QchRBbkfqnlYUaim3H7T5YR+t3ECQmefPVKxDcrtxbl2qLYJ
         sxl4BIzYB7ZA3MbcdcjNq3kPRnm6Dm5ZjAYhzgQERXJM5GG+JnCU/kM2gBym6k7LUoPg
         yxdEnxhpsg4eaZZSYGeTKVXGL2lmyfYc8XD4MVaQHAiCH+nTBYWsPbyyTXm9c6Ug4Q1U
         Nt5k4pDurVbiRvR5a39fyuyrlT635ggYlgFZMbLSa/LxRRuZVIiK1L6UhpPNMwLxbd7j
         ZFJtHw12/eG/nzWgb2EFG+xOs6NdPI5m844+cok0b24RsHBBhzpfghNjQmYqjKNTNnov
         HGsw==
X-Forwarded-Encrypted: i=1; AFNElJ86C28J0v2TEcJZYS/8sc0pJ3K2tgphOjSNlq8RLZ5FVX4nVqBRvhSCAjgaQLsHYWEggUTn7iN2Ug==@kvack.org
X-Gm-Message-State: AOJu0YwBkAiKN2wpQ1HPJqVnGN7ZnXLnpndzu3DX6v/8OS1LcljOE99N
	QKjaOS33yu/sttsLVqiZckI0RSewHl5es/uyjFP5Vr4scZrrfYNOWuOD59A0YEP/gYU=
X-Gm-Gg: Acq92OFev5xHHDka+G9IP8RAc2y//Sg2oHOJl25xpBRPMOSmSqWH+Suf+f9N5W0QslH
	yhi1gVLvdmXnlias4ZMwoB9DQHco4S6ux0ghvU9x9efWQkKrPCgcdROjyi1LFwo0C6GaFPLlW7w
	vIlcByluvkKGFLLfTHAfguiLI9NwiX/8YDStIYfR5cDNFHjZBnrOzuVudSVr2vMXe8tX3J+rr+T
	jyaFX0G9iUimlLQmdxoN2y3NGZcWjnbCliejNEI0xcwXyN6+7YZvEHCtvPk/qsrl47dCGhEpEXt
	W2lTFL4oDTUDf2XDp0N1WWm7wu7wxlzmyZloibrGLSWwnKrP78eOpcITmdg5cjhtRGITjc3T1nd
	n/JU6G2ruH1e+iGgkCw3McoUvff2qTU4vquboN8HBJZGQ/cfqqYFXo06kHLV14ng152BLQcdaVi
	dRUBkGSktbp0vfhylb0fLJxQe0gRrEt88Rz4/8ujOhL6A=
X-Received: by 2002:a05:6a00:2e92:b0:842:4f24:f3a2 with SMTP id d2e1a72fcca58-8434ce43264mr1187972b3a.28.1781236836875;
        Thu, 11 Jun 2026 21:00:36 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:36 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 17/19] mm/sparse-vmemmap: Remove sparse_vmemmap_init_nid_late()
Date: Fri, 12 Jun 2026 11:59:01 +0800
Message-ID: <20260612035903.2468601-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8640440010
X-Stat-Signature: pn7snspwo4qbow86xeb69dsmdtwicfxb
X-HE-Tag: 1781236838-417581
X-HE-Meta: U2FsdGVkX1/WYn1Qk4fDd4jyV5F4DhgAYlS2FLy7zUHXdjORDvB7Pn1rid7/KMJzRu5P+O5ygh4YDklr3NBuwtUKRoYGq0J6lloH9g6xLgEQRjPRCx0avN0lvehK6hYrnjQ6wsS5dAZaL0NgvCYKqZbv3hqPCvJglhD9N++zVPhUNvj4jWq+IFHKgKasbPom7dMwPzxct8dVIcS4drcpvtVfLre75QRzdDrZ4SKNn4fZjNVJaQnexEMgNfzimEGdSSiqlHgnopF2sp+L8fvi6WU9+39dT0c6am6T+i0jP/X4jmsz6NmC4iDoM1/pEW8ukRS73OHZFy9W4r4L45SnhxJa4uc4HgFPbk3iywRUyB2y6oRM8n3YK2NLTG3glg/m7sxz0vlMsCQl2BzfW6iORudybnhfqJ7nWXbgoEeU/4s12hwEGvUf/j8YI/0Fli0GaJ4br8hU4bcu5QlyJywQVYfSBk1sbq1L57ovhhV4PycxmtFZ8t5VnC8psQillLq99TZApzr+3l+cjTjz6GQrbX/kbm8EIPMQsh8QqWNU9W5FVYVQTJr9wdyquvyBpRkuMl6zI0+ck3jQaqKeNHmWbf+FYIK0xlskVr51TJdeLKtyx+aaWvVAKfaQIU4H5MZSKjRhit7fikbaW4+Q9cYy+diH+o+sjdE++iUCrSUW5KBGtHP7jxy5AywhinTUrIaS4iomBJBXa5pEKDXNi4kJFcJeIxE83x+DSOL2pM/cXYsXTlMsiBPDYg7oQxvBPdZTnUu/ifHmcg9w8GtzXL5xEZV///6XPYcFJ7u+w0j+kEmOMrXSTH4oVqtcbzHNdrzCAqMFstVvnULDpDAoquSRG0x6RWKWZJQ83zXQHOIjCfjex+/BN6l97fObbZehf/LH6b0OAWZwRAS344mE7IenZTkHUS/WG92zfIflvUbm+EvZzXexTwTN9QKcWVI61nhf+Ni+iRvM0/Fq1Taisuz
 7ZfvHO1J
 +JQ7ES3D+SgaeTEfwicWI2lCXuLyLJbaPo5/tf93UM0HZa2hxQU6Tvyj9nWqZNUr4AJa9foCA5mUrqA6yTC+i49wjX0/Z5ali3GzN9VqciCWlJtb9bLaGb/8imkMEEc07fwlmZtG50f1pHvcoKGpaKUKspZpzy8TU3t/bpLeOkM+Of6I5MGjwsZGBmOBXi4NakiC/fTZvM+riXMuJ0I9DgrQFzgzynx7tUOJYW7ngwmlN21DIZU71KYmIySf/4DDnpkp/S0cPc18sPrfGPzvMyIwGB/V4Ptg1sYTK3BrzN9O6WdDJmnqYbnNhxMVRa/fNq9aM2M+0rpvKU4Qn/ZgTZzag6SGMeGhv4exPDEEJbDRRfC2+N3fyvwtHT3X+PJ20sZpo+nWt3vOzGo1cD5lPGpnFakAHOtjfxfsqUYAmoH4r4ZA6t6etCf9T4Rk+X2/7X2k4ogbkxRS9xQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_vmemmap_init_late() no longer has any users, so the remaining
late-init path in sparse_vmemmap_init_nid_late() is dead code.

Remove sparse_vmemmap_init_nid_late() and its declarations.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

---
v3->v4:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mmzone.h |  7 -------
 mm/hugetlb_vmemmap.c   |  4 ----
 mm/hugetlb_vmemmap.h   |  5 -----
 mm/sparse-vmemmap.c    | 11 -----------
 mm/sparse.c            |  1 -
 5 files changed, 28 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..db9bdf62b170 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2156,8 +2156,6 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 }
 
 void sparse_vmemmap_init_nid_early(int nid);
-void sparse_vmemmap_init_nid_late(int nid);
-
 #else
 static inline int preinited_vmemmap_section(const struct mem_section *section)
 {
@@ -2166,10 +2164,6 @@ static inline int preinited_vmemmap_section(const struct mem_section *section)
 static inline void sparse_vmemmap_init_nid_early(int nid)
 {
 }
-
-static inline void sparse_vmemmap_init_nid_late(int nid)
-{
-}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
@@ -2374,7 +2368,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 
 #else
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
-#define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ee4fbd5fed0d..eefd6b5f9706 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -808,10 +808,6 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		m->flags |= HUGE_BOOTMEM_HVO;
 	}
 }
-
-void __init hugetlb_vmemmap_init_late(int nid)
-{
-}
 #endif
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 18b490825215..7ac49c52457d 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -29,7 +29,6 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
 void hugetlb_vmemmap_init_early(int nid);
-void hugetlb_vmemmap_init_late(int nid);
 #endif
 
 
@@ -81,10 +80,6 @@ static inline void hugetlb_vmemmap_init_early(int nid)
 {
 }
 
-static inline void hugetlb_vmemmap_init_late(int nid)
-{
-}
-
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 0b4019a93188..515a404b66c0 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -579,17 +579,6 @@ void __init sparse_vmemmap_init_nid_early(int nid)
 {
 	hugetlb_vmemmap_init_early(nid);
 }
-
-/*
- * This is called just before the initialization of page structures
- * through memmap_init. Zones are now initialized, so any work that
- * needs to be done that needs zone information can be done from
- * here.
- */
-void __init sparse_vmemmap_init_nid_late(int nid)
-{
-	hugetlb_vmemmap_init_late(nid);
-}
 #endif
 
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
diff --git a/mm/sparse.c b/mm/sparse.c
index 3917a47153d8..324213d8bdcb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -320,7 +320,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		}
 	}
 	sparse_usage_fini();
-	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
-- 
2.54.0



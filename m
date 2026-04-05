Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803B5EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D176B00B0; Sun,  5 Apr 2026 08:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34656B00B2; Sun,  5 Apr 2026 08:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B9A6B00B3; Sun,  5 Apr 2026 08:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6DC36B00B0
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 959191B8F6A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:09 +0000 (UTC)
X-FDA: 84624497538.21.EE784C3
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id C191EC0009
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ChBahACp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393707; a=rsa-sha256;
	cv=none;
	b=WoNTLPLTIVnXYsP61a7LhaxpOSOqbp88gviZLuf7Pi3So9uzTz45OQbMJ/wHsslrlqe0hd
	zMuEKECD3rMtGGQLNbXUc+CmWBchfX5yMLhDp0Oz6i8g+VGFR8w2AuNWRtpSdpqwlhiX3Z
	KPdhvJVb7m6T9HQIALAHu6H4loHIh7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ChBahACp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62kILe3INi6GkTRPTI+nnexklobUpHFgUm7h2fdMoGM=;
	b=FbjCLRtymkXBE8FULD3LGvLUVcvkm/ADmN/R45b9UxMsPNvuM6dQmj0q14YBU+YVc6tv7f
	JXi7gH3OZrPqI26DVpyMKnMwmElhHdJj1bSstO7yOajSni/4JsYH3fRigcLhVFcitPkPkH
	8lEcHl1UFNP4J9ET3pawk7cOwamykUE=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35d96be7c13so1889818a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393707; x=1775998507; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62kILe3INi6GkTRPTI+nnexklobUpHFgUm7h2fdMoGM=;
        b=ChBahACpHScz64RjF8Nz7dlVeqRSPJa224wUB2rdvJZNTV42zhjUvi7C+mFr8hnn7w
         C1jlonfjKkcoDWhASB8LLKKXbNqkQPN3j1IW5Fu9RwLl/Akuh8MzI9pFmJh9XUIjaPQR
         yLfyI9LrV5wLtLKW9pRO6VcNnozvHKMl07XVOrimJIWB7hrIGLfJSSGPKjCEI2AVlC3M
         hnBeNKC6CdsJ/9XDLazh7iLDRYy7xgV4saJld1Mh8gwcPqwCfzOp0dnyfb6EbFgGptK6
         lxIISYOGmClRgG2pub5+VfRVSUEPGJbhSdp7MCk5CyrK8UD/N1JaVxjmo0QnMdtDRDMj
         zulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393707; x=1775998507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=62kILe3INi6GkTRPTI+nnexklobUpHFgUm7h2fdMoGM=;
        b=gKqzADOKuzXUva0gtYDCoQxWt3LCD8ZLuQammzH4TFC6osdS6bb1AFYi9TnbFGD6VY
         UP7z/mT8442WfKN78krwnzyQvY+EZ5DL2SGyHZd2m1RYWd3NnMDZ3t0Sz4Sgis7hFb24
         CHYZDoFCZCw21Afl+xXYUERgY3ciJrY1hOxEXRLhCsmIwgC3Zyr4xJT1H6YdriKmQ10h
         Xy+OO/CxLxlDKfeJk/IH3IevqkrYTaGEdS0NMvzYaiCv0gl8iuJfND/MMJE8yRBkkZA4
         bMxy28jxXtQ8Ma8AD+Tg1Eb+69cM4CNlaF9ynSHGpEFe1xwNxJY58fi+q+21j3mKK0ro
         G/Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWoimjSYzYYRF8yZjL2SsHnr7qzKfRiAWcdnkCXXUfGLVDxeHRBLKWYxrgp7zR55qouA/VwOhMGNA==@kvack.org
X-Gm-Message-State: AOJu0YyTB6YwHYpz3GzhG/0ks8uTmr33OzHBhGTBJDz1bSJKrr6ysULC
	dJKPJ26j+xnZzQNytd8gv2/SFxPITaxA4gF3IXcaT/sT4QbxwFM+QLuQo+RzlDh7EOA=
X-Gm-Gg: AeBDieuLeQq/7NVJdv90VjEog9mqr+sTghAkqlqUHf7fGqYUyEuV9NjQU5WUeEkpEUB
	z8rdwTvAp00Ub8KapoIVGhmO6iyBAPNkKN9FsWANF26Kwxt8WeiF4o9EHlJbV7JK47Fg93+e8/I
	gj2hk7OqhpHRjH5AmCaQ24EgT7GobbZMOKp9LoJ6H/SB4SWGnzudVinOTfYEfn68wO2pTDLneln
	BYbKBpJRTggmfUvFgrsFWQI/IASYrkEmTPeGNRIRD8pQTeexkjGT1i0Jk1U9gkR7J1W2ZzcjG4D
	Sst1BV8uSUPRAobFu+NppnkicbrXyLbwl5V8iJZ4Sf57klnUf90oLB0Gz7DyJSNQ8gs+U659sJ4
	5EJlp7SRexE/MjA/9SWYsi/1BVMgkgfn3WjZVCf34zQwgHsp8GEge1YwcmfBT/fHx8Z328oTDyV
	cxswKfZWsfI44Mzbu25ls0lw4WCyGmhWioYcqsYjrjZqM=
X-Received: by 2002:a17:90b:3d4b:b0:35d:9fe9:f830 with SMTP id 98e67ed59e1d1-35de5c42865mr7039662a91.12.1775393706456;
        Sun, 05 Apr 2026 05:55:06 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:06 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 16/49] mm/hugetlb: initialize vmemmap optimization in early stage
Date: Sun,  5 Apr 2026 20:52:07 +0800
Message-Id: <20260405125240.2558577-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C191EC0009
X-Stat-Signature: ejoiajuxz7c8w37uy1ykxwmy97b9j6mp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775393707-252434
X-HE-Meta: U2FsdGVkX1+WHDBmdqmNY1AAKt2Czbw/w5joQxgSmqD+4KYwbK84cswkqjNoBFJ/RwDznD1hy6Bu1Rt01tQEf4Pz6eKbmEmrX0FrfSRGi2MNuEG1IEU8wbR5iPC9uvaNv5hN8y4qBtgs0WaecDn23AYG68GPbe+M93fjc1UU/6lFc5BIFXCFkRlXmn131K1BiijH4a4xqIcTsx1T3+oJ50AuaRAT7wbUSIjPzwk4+D0WJDpKFLigDHnU5/kz8FhnuarOIlwKX2jm/aZjUN4bnAc2RAwTmWPJMFyd4ETEjQPJex7UOGB7UhTlGC00mGqGfDUCbA1R9/XRb/69gTDTvOwvb5xGBJmRbp3A97UaDBrw+aBpdB9RE9njNjtSSGE2p6hR+5v2C63L6AwT6S3J5dtP7mugg6SypMNugTDnur+Dn8XixQrwRs0MB+IS/3SzYYDmxKTrq7e51pl4jVEeM7Pqgct73XmRXhsRIltVsZjIxycR3/rCOE26JP0NCnBWiLFgG2AZUCqUkAAtaUW2hGQ6YLd5Jh00lCSPCL+S5Abc0nwOjFi7uWNON0R0TPP//cl7HeEDQT93A3NfZNiEqDb1D+qT6gVuFOLWhFe4cYs4ZzNLhxq0X8wkX3XLYPNqlgIfuvoouofB5CYFyit+dm1wiXbDdSjN0nk/fFwZzOVphTst802SWawJ6zmRqPh5n7LpFEIkMlpjaaD5e8lqmwkBexXk6+r5ixh3dK38Xs5B7A2VTKdGK2kvhNHOfuk5SnZWE6ixD71AeH2ACF0wFlMV4Xu36K5rSbnXCQcvdZYOAzzkVquXy1r9D4eNAzGISTVI89ibItDNsj73pHe2mLIz+NCfhJJlpPyV/BMDzkhCM+s/ACT/cdPy0h5jYIlB9uaDh8zLERXsLxnkD+xNNGGPSe+IzAU91Wwpw+Rr00G8q29omXqITycriLVAcofonh46KGXhyI0MRLJBPCp
 Ln+Bu6gY
 woldsK6+SqypNBGPkEj4FgLPQH2JWFI6GeWmJWADbzt40QGrERxv5HYRB+vtwEUZPAJAQtGONqOHkkRGatZixfoWQkn+ebfoLrfzLCIUPMBeGTxStyJWbQNcAgV6WXFuxG2h9s+lt5I3iTbsBmdDwpAIjEh1N+3dAH33AXLWZ5zF+dg/9gNmY0dxdbw183Daf9Qhg2vj1QWUqNSpO3bSDkFOunF6ruMQNZFGYcjUNza+4e3KfFhyg097CfqVO2kTTJuMNWBGRjDfE+VVzqwYZg5K7PWRMbnJrD8eXmrb9Iwf55z/rHL1FrQGendCt84EkRmE1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move pfn_to_zone() to be available for hugetlb_vmemmap_init_early().
Populate vmemmap HVO in hugetlb_vmemmap_init_early() for bootmem allocated
huge pages.

The zone information is already available in hugetlb_vmemmap_init_early(),
so there is no need to wait for hugetlb_vmemmap_init_late() to access it.
This prepares for the removal of hugetlb_vmemmap_init_late().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 50b7123f3bdd..e25c70453928 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -745,6 +745,20 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 	return true;
 }
 
+static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
+{
+	struct zone *zone;
+	enum zone_type zone_type;
+
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		zone = &NODE_DATA(nid)->node_zones[zone_type];
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
@@ -752,6 +766,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
+	unsigned long start, end;
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
@@ -761,6 +776,8 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	section_size = (1UL << PA_SECTION_SHIFT);
 
 	list_for_each_entry(m, &huge_boot_pages[nid], list) {
+		struct zone *zone;
+
 		if (!vmemmap_should_optimize_bootmem_page(m))
 			continue;
 
@@ -769,6 +786,13 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		paddr = virt_to_phys(m);
 		pfn = PHYS_PFN(paddr);
 		map = pfn_to_page(pfn);
+		start = (unsigned long)map;
+		end = start + nr_pages * sizeof(struct page);
+		zone = pfn_to_zone(nid, pfn);
+
+		BUG_ON(vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
+					    zone, HUGETLB_VMEMMAP_RESERVE_SIZE));
+		memmap_boot_pages_add(HUGETLB_VMEMMAP_RESERVE_SIZE / PAGE_SIZE);
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -784,20 +808,6 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	}
 }
 
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
-{
-	struct zone *zone;
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		zone = &NODE_DATA(nid)->node_zones[zone_type];
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
-}
-
 void __init hugetlb_vmemmap_init_late(int nid)
 {
 	struct huge_bootmem_page *m, *tm;
-- 
2.20.1



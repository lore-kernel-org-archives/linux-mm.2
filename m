Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586DDCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13A96B00EA; Wed, 13 May 2026 09:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4026B00EC; Wed, 13 May 2026 09:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB28D6B00ED; Wed, 13 May 2026 09:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9926F6B00EA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63C55160109
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:37 +0000 (UTC)
X-FDA: 84762433434.21.1571CCE
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F832140011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fv3IsYm2;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3qZ6fKvu/W22OcYYEqHvfVb2RH2sc3ZeigSJrIXA9w=;
	b=CWNzshbQ6MU9kiUjcPOdwzg5wRuVxVaj4Q8IwG6KovREsZ1rOq5F+DFRXP9+ssGwg05j13
	qqur5kjibCBiMvwzbsD+vrwMd/pRZxTAQ1Cz+5rf5bh7tJfxLRA7UuwI6FkV8d1vHs3ONk
	Ke6lO5Z3k7LyWG44VM/6CFbA16OfQ5s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fv3IsYm2;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677895; a=rsa-sha256;
	cv=none;
	b=PwUThSsv6qk71zLVgZCw0sTEzR0wB422lsko/9/ESl62vPkOT8ybNwvrOWeH0tgwzG52kT
	x8+45ZsDCYJ2NBvFCSUl1U174If+/5Ppj0eFKf+DycSLq4Zm6E0XHjBWlCmG3o4ecSVaeu
	u9Y8P2Yisy9oK721nVGN5hvPRSOexxc=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso67491325ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677894; x=1779282694; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r3qZ6fKvu/W22OcYYEqHvfVb2RH2sc3ZeigSJrIXA9w=;
        b=Fv3IsYm2N0+PXU1YkzbV9zMlsQI+vZza5/o6VNUtw/QujHPvkaeXVJ8+OxWP/lE7XS
         c1CAeArfYn4EzUpLKCnahygz6f6YSgxtBL/UAC5Sb7z2unCdZfARAxEBjSmaRaYDnhn9
         7hoisF3YccVQIM6Jomjn2q6XGMSW60L4od0nLRw3eUOhxvYAY6K5rL6IzC4a2sMZ4bHp
         ZpvqvZMTXWEmwnvbg5IuWu/moOgDsQwVLWZKbj5RKbLJzRurXhREyxQ17v9ePUeo9hO+
         v1FEHCTjzWXYOy6lR34n+97KaRZ0vUhVVTa0RJzfBV5Egvencq8qDhVD2+bjTqzzhWWN
         +QYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677894; x=1779282694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r3qZ6fKvu/W22OcYYEqHvfVb2RH2sc3ZeigSJrIXA9w=;
        b=JSSnWCEcPBYPJ/whO6f1qLfvF/vKvTKOMr8/aNDdvDZhSol9GyE0ZRiUF8BLNvTli3
         5EK+1v9gYliNMhzhYFQGbn1DiyDj95aO2wxF8ja9RUj3IfvvvS5KJBl95EqykDwk7wZB
         /sczbUK3wiyY5gyk3LWJ6cadUJiT7zowEVh1bv65/O1vzeaHJs0q7guf6JSl4fyMBuy8
         mdFKek3e7uGDxPnciur5oX8w7hC+ZkOJ8uP6Y5YQ7coMZfPm8ifvI2t7qepPeVatmiM2
         gZjA8FYo7KbxdkTuXsLv1qYH3SHdkWLLquJJLLERsm3Vykt7pKkw/rpeB32Ji+VmKNx9
         6BOw==
X-Forwarded-Encrypted: i=1; AFNElJ+aODBBExc3kFmRxSuGiNXkEaU0fhEyf6h4Ti+regEdUykOMD6S8kohiWBPO+U+z4k+EJah/lAWAg==@kvack.org
X-Gm-Message-State: AOJu0YwnJA0SKKDMjXIx3K3QhvGYpJqDWqhTShZaqjDn+gO+ICxreNUH
	EhhQ9n/473IIrXNqc4BNVf7vO//Kc05gKB66veITL+ZWuA/0XgY1gx+nqf+uh52M8lo=
X-Gm-Gg: Acq92OEgWU0bim7U6eKnrANMuLD0EGWnIRIRdwLnq3zbkoyfIh0nL65rYmZI/dt9jdf
	4zqB6FFpP1V9WgWxrzBUzS6OotHx8InFcL4ykEx1M0LQUq1iLHTJUlHxoE5kv3bzD/Cld28f2Gl
	+Y8oNVIvbzDFi64FWobe/mHWbCQFGDazT7mz+sjr+KtaqOeIqxmsXSH5PLLb03ZCHWlZocM7AYN
	ZKjtpCOyZkKehDelfv1uapFOOMovg7j3wwJqALpfTVqMRNlGNc9i6MBpE9zToAQXxwyhT9Bz1zc
	bQNgqjhfJ7i2vUWTUvGZwmJVMTPocESLynLt5wcUSj6Hp09eiiukzFh7hXpeS1s3yVaDFCikm2m
	Md0KzZYPvQyK0Wo226LQ7Lu6qM5nU1Jw1GZSG8uJc/rAzZctFGO2YiTuup62F7uW9pVLPhlWFzw
	RLFAwcjo/iLGEx/zFZGvj78q73ooeE/7Kw7fpEQ9SV67RiqDd+mocb4/aDlRE=
X-Received: by 2002:a17:902:8648:b0:2b4:5dff:30fd with SMTP id d9443c01a7336-2bd2f4f734fmr21340805ad.4.1778677894343;
        Wed, 13 May 2026 06:11:34 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.11.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:34 -0700 (PDT)
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
Subject: [PATCH v2 44/69] mm/sparse-vmemmap: Remove the unused ptpfn argument
Date: Wed, 13 May 2026 21:05:12 +0800
Message-ID: <20260513130542.35604-45-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hk4z1aqj4sfp5rz1gx771ui5tuusfrfn
X-Rspamd-Queue-Id: 8F832140011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778677895-224184
X-HE-Meta: U2FsdGVkX1+boKSdSPOVYBwNuX9wmUBfCsntVYZ8gKpMu9i7yncpanfQq/TqvMGk9eHYT03LyCAugqc63ItD6V9h27RMIIOXPiYo6vBZOt0cldOXZnHSBuB6XZsFfU04Vvqn8u3AtkAJ/GlLr25eZVFf95KtW6qsi1oPi+29UgV92SMKwvGhNEAHAenvSb4sR9Zf94aP07S6KEf5FjFekuoaKPdPxQSJYpY809Q92IRomx6NIlLLtloHfoXSBKYzcAGCzkurmcj8Zh9SYBjid3aWZVsL/woKrv20mEEbIS58P52P01Iav8z/HER4AqCAACIc0hyvtjI7d84cY8SpcNGX1rVzk8vOmciEjMFPhoC7gCtNea8TxGNfuVYCt2SSDnwd6HijDcwK5f6OPUS+rT8yVUf3VGSgLW7ea5stFpGyIfciHfof/4SHO7GGjMfm0G3jypAFMq9ejYZNQEbPpnj4kgURinuSafoXVY9tSsYUtdyptBM6JH0HQ7+rVtEB8AUTvswT8VZrdi+foXr+2NRLIyPtIy/xIN2vzfegq9Hce20fUdB9ADOThZcz68jo2toR/XiKh1pH3UhP7Yzc5mRWxDqmCD0M0msI9N8XazkRtlHbvd48esIO9F2vTUmohLpKbC8Wo9M+tnFTK+6GDcU/yqKnANFiDopEx32PVRMHUSkT3sbKDn6ls9DV1t8ytStZEtuZQyHJiXOX+aDrog0mkqpsI8hBOS0Xf9bgedW/oT/avvasMEDIoW9g0I+jviun2JhIAUkKms/ejKLdBXmnvqi1hHYawPxfuKdIGqsnmRhyECRs95BsgkLaAAmJ5mdgwWZ59dhVAYh/q8St/NUZjRmzmYuBYKrZaj74Sowva/+wrQ4iE4lNgLK3heub9KuCs3y+zlNalgWnpru+vKzh2EDp+vS7T6UmBmyqI+uQwDIZTRUQ882PpAUEVuIEma2b/4LkbfBzZKrrd1k
 FWz/L/0a
 G8r7ksHflURG5u9FXwJXR398/RCasrkuj3+iIdXQWZvKR9+Jc/HENsxzc98/olgEQv5IevOTnvXDzRyVr5pkiPds3ard9eJ1V/pN+ANIjooxSHrazPK0L4sDaKLe/k5DHb4yn3EogXl2kXoQXIdUJddPNU6ppgTHIXWqCqlRtfxFRjKWmIZnEzq9xY26QIjS2d402poqoYyqreg4pMdkmW78RYEXQNKV8joySezF9nhnalcusxjLYEPCaYGTaNqI/xXkDjBJ2I2S8T1k4IpQh79Wcz68jQ6x2beVrBmDmKHg+mDiCQ7WZ4TPen6+5R5BOK+Ot8V8J6IQhpxw69CXCB8cWrGVdE4CZUky2vpfKAECgnOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_pte_populate() no longer uses ptpfn as an input.  It computes
the PFN locally in both cases before building the PTE.

Drop the argument and inline the PFN computation at the PTE creation
sites.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 4833a2295abb..182d0c7dd1e7 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -124,8 +124,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+					      struct vmem_altmap *altmap)
 {
 	pte_t entry, *pte = pte_offset_kernel(pmd, addr);
 	struct page *page = (struct page *)addr;
@@ -158,15 +157,15 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		 */
 		if (slab_is_available())
 			get_page(page);
-		ptpfn = page_to_pfn(page);
+
+		entry = pfn_pte(page_to_pfn(page), PAGE_KERNEL);
 	} else {
 		void *vaddr = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 		if (!vaddr)
 			return NULL;
-		ptpfn = PHYS_PFN(__pa(vaddr));
+		entry = pfn_pte(PHYS_PFN(__pa(vaddr)), PAGE_KERNEL);
 	}
-	entry = pfn_pte(ptpfn, PAGE_KERNEL);
 	set_pte_at(&init_mm, addr, pte, entry);
 
 	return pte;
@@ -235,8 +234,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+						  struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -256,7 +254,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -268,7 +266,7 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
 	for (; start < end; start += PAGE_SIZE)
-		if (!vmemmap_populate_address(start, node, altmap, -1))
+		if (!vmemmap_populate_address(start, node, altmap))
 			return -ENOMEM;
 
 	return 0;
-- 
2.54.0



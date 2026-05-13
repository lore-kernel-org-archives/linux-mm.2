Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30334CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97AE06B00E2; Wed, 13 May 2026 09:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952586B00E4; Wed, 13 May 2026 09:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868706B00E5; Wed, 13 May 2026 09:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 733C96B00E2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C51585957
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:16 +0000 (UTC)
X-FDA: 84762432552.29.E765B77
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0DCDB20011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="h/5hFrUM";
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zm8LOv4zY1TsfsxyQCLJwzqDtIAwoZz5LOnZLOy8d38=;
	b=CNE2NhtziEVpSGVjMuT0eKrBfuWdsQWNafUc0/fcxAjTD32NFM8mDN98FpPEasvQPMNxfB
	YghObDa9GxpPKni1DymBezwgKYXRPmuAFe2SV9kHRZInkhBC5QW2CHiQ4Q1CqGY6taYtoa
	aHS9UFNU5Jxba9TbHF7fPnM6pqYPrQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677874; a=rsa-sha256;
	cv=none;
	b=FbQ2ttZOoYKKOzo3ENcX4eZvrZitTSmUTMEi4lBUtmYpBnSS7oRzCIhFwIvd3+UpcLGbI3
	suGg9akjfxoEsX+FbDa9Oi81mXl+bSMawg87yU6CnI4eEC5NL6eyJ0MfgYmHolsXL7eNCE
	Kd6mHpQ50sKQdU9z6ti6h7AJYubjnCQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="h/5hFrUM";
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c8025500cc7so4884239a12.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677873; x=1779282673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zm8LOv4zY1TsfsxyQCLJwzqDtIAwoZz5LOnZLOy8d38=;
        b=h/5hFrUMczm10WzyoTik9BBN2f9ZhWB5hMkjTc/3eNRa3UFR6X38zuM7Evbrg3PHzC
         dSKUKtjemNorDxpiNmX2ltxNFvr5NwlufGXej5DW5RwuPDs40gqVJi8zJDuQ/TWmFYDD
         F0kvNQBNgRrbRwjLleYyAUUQYP85dFEDtyoL58/oE8P7SLQomGRb5zqY889k+D+IR9Y+
         Uh3iBCIjDdDXgpMshwMoxvL3OlsTNZ3UxSz9NPWzEhL+Gz8lSRQLco7+Twblcuz4qL8P
         nKdDIl0f49+f/VyOnXIMIj83Z4Oj36mD2lSPGsyZ9RFmAEcEYkGfHf1mV5Do6yfwHXyJ
         ZUfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677873; x=1779282673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zm8LOv4zY1TsfsxyQCLJwzqDtIAwoZz5LOnZLOy8d38=;
        b=oqfYyDXvnDbcDDeKwKIBzjBab8VVeKxALn6ERllBLqqaciDg8P4sYOjYFYzya9DJ13
         FjuWFmB1qFGLnSH61o/ya73hGnWB/WfXpN3VwrACQpVgMbWAqE0fnjxuvl3fs2GGUjb6
         lOqGXI7EcOKwTPlcKkzSw861CkJr7AJsSJU52bSV09ZfQ0bAUv2wY6qZ54cv84DD9q3O
         0O+UA7+lJiNvoS5Gm5S6PQnpamAmO+QfkeBa8ohBJ4vv/xp/rbq73mJ0NfsepR1VnlAF
         jwyQNpPyELzioclBttrF6+wfjhFXlmwCC4BrnM5oqLpbrouo8TYDo9+ldlpOWPRVehgz
         s82A==
X-Forwarded-Encrypted: i=1; AFNElJ9HHEw9/ok7IzOdVKSk3vnm0qo8b0vcmdQJp0iiSoMzEnkiQO84POC6s0Wix1Rwoyq/p6gSqJtuxg==@kvack.org
X-Gm-Message-State: AOJu0Yy0azkmEnU7Thmf0TwGS31iVet6s7oH5iOXu6K9M0YiSvdmcMNi
	U1QhkVifhwBgXFvzC6DjAoP1wtpCVB9h9DO6eb9ZOzGOvb6cZv70VTZVUI9Mh+15A20=
X-Gm-Gg: Acq92OFA/9f6ROftm5u9YGVW/1Od87/HSt45zgMqefWmfoYB0QFO71VSC3NhIIuwW+h
	VH2O2qGW3oUmMrd6+ykrrZRAhU+r99f+lJzpFenkkL6g0gC7dhbGWL/grdalmc5GNYgS6pr96sY
	9buGuqNiRb2LwHutt7/+bHgwC383nZZampNio47fajSdkS4ij13Jx84IKeQuniQPxSjPCP4pyoe
	VAEgbk5I+Olse8smDW980Qo0jjScztRYzts0NeIMDU5FOc2724TdE6vWBkB2SUTvYiOeYnJRjNJ
	l5AHfilPdGRiBEH2YqFG5gC/OxZK7dvj6H8eU+tMD0gYHyCuovJsGqobD+BuUHufP7ROYedAfwb
	b+kXyFlXQV0soMYX9CnrPnxdy5aUijnk7WjGMNYOqyFq75TdAlLR2erAI8FrK8n6T1lunCO+1zy
	7e0rgVyQzdpSL2LEDEf+XHZOvmjoOa5XjG3efqYZIkdsu6cJ7MBJFeG/XBufxsvejnyfl36A==
X-Received: by 2002:a17:903:986:b0:2ba:6ca2:bd9 with SMTP id d9443c01a7336-2bd30640442mr29210365ad.41.1778677872675;
        Wed, 13 May 2026 06:11:12 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.11.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:12 -0700 (PDT)
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
Subject: [PATCH v2 40/69] powerpc/mm: Switch DAX to vmemmap_shared_tail_page()
Date: Wed, 13 May 2026 21:05:08 +0800
Message-ID: <20260513130542.35604-41-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DCDB20011
X-Rspam-User: 
X-Stat-Signature: dju5mi886zczkdbnoix46x88krec7k35
X-HE-Tag: 1778677873-792193
X-HE-Meta: U2FsdGVkX1873TwEzHl485qDyCgxF98ga4WEKHrnk/ksJXL8lmkdTFthrhWjyougjKaxpbzTHJjW/RD5PFLty+Nhfl43mX57Z4GgLHwIpbrymfSHDhJ9s3xOnvmiLgd/iu0auHsaxh7t43Hgm0fwfOGhMTQ6asEx2VFO1ZIU2WPSQoJmeP35DPoyKT1/vKHtNNquAUV5RWaVv8xLrOhrVdBI1D294tAGHvKr9Whs+vsH9hOQlucqtlCaY8mvHj5pvs42/O26IV3wXsq+QQj1kvXUlqqAFTP2hPH1ff8fihSGER1Jhqq6qxBGRKSbwXcVWuKrG4TZ5AMI41IhU4oxJT5Xsxv3UUhtm/M1uXqcPS7YE6Z313F8NCsSgJfpJuI21Njo0SLCQke3eRMUuqoiqGas9HVbfMkwIq0r0wRMqHXxV3uVQqSOF0y7NHGWM6Pngn4WWZUJgcHaUjcNNckGTaUGujmUJXSz2kGQ1d8ve5eX16YmBVqNUGZKfgQfOm3vEkN3+l4K30AoguABCaMuLdQ8c7DFk3BsGux1odsnJASrTNK+VFN03ILOQMUtEALNyZQeW+F/loni2Fxh0cE2qVO0r55YyBnmyggfeT4uf45oCWF+d63IfdLktsn3MdriSTwBOEax+MqKrDsKhTMcR8iCp2UFfxSRYAEK84E6Pkm0cqUjanTNs1GZTwkbNK5QC4tu2FBINik/xqPrl5gV39sU0JfbINLiDVkP5dIed/lnuFxpxzKvEs/gZ0ydmZrRpLno0uxWqMcfbtMZxWlR0/5jQj37pmsdhY35ld+DoCks+FF1drvqMLLbPN7xmPG1GJqF6+6c6PeK42fmuayHn1ZmqdfWqjC0m9TtJ8ZLftKSvFpipAMa4WCTo3mi1OAZ6dhUFwwUuyFtVWVuhIjguAyVNnNDbyU2i8gJvH9dTPZFtT9kp82E3MWOfbaPGv5DmNjYg5gZOS/zLCik6hd
 Oo9PvJww
 nmGw6BuPQj/yBrB8XmF3ME7IURxxjpKniFnl7wWP0jUH/HNqYMVbMZBnI49y+t1P7tB3japq/+xY9G7mahT3b6bQH0WG4T7tQcAVr8/ylhXzu4f9wRoRpMEaVP/N3uTpVSb9+wfC4EnFdoVnN7tfEICIypW+nlzkwxuTZzAxdQXNyu8Oe73g+FamGSHIul/rFeB6HOy3jrwn837ix8FHcIHJgsN/4QB//AeEuxBjSpncAEll2n2D7WUygHirJ2X525r3uMuR1soGS5fxJxML+JMmaCtpHa+/Mi47Q6OyjES+u/XX9njr6VJdB7LlZ3DJHAwvMXzuLYKEOh11ilQXXTOyE9L4H39mWO3wg/gmj7suFV0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

powerpc compound vmemmap population still finds a reusable tail page by
walking the vmemmap page tables.

Switch it to the common vmemmap_shared_tail_page() helper instead, so it
can use the shared tail page directly without probing or populating
neighboring mappings.

This removes the powerpc-specific tail-page lookup and its fallback path
and aligns the radix vmemmap optimization path with the generic shared
tail-page scheme.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 76 ++----------------------
 1 file changed, 6 insertions(+), 70 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index cf692b2b5f7b..95e65ac8cdea 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1250,59 +1250,6 @@ static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int
 	return pte;
 }
 
-static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
-						    unsigned long pfn_offset, int node)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long map_addr;
-
-	/* the second vmemmap page which we use for duplication */
-	map_addr = addr - pfn_offset * sizeof(struct page) + PAGE_SIZE;
-	pgd = pgd_offset_k(map_addr);
-	p4d = p4d_offset(pgd, map_addr);
-	pud = vmemmap_pud_alloc(p4d, node, map_addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, map_addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, map_addr);
-	if (!pte)
-		return NULL;
-	/*
-	 * Check if there exist a mapping to the left
-	 */
-	if (pte_none(*pte)) {
-		/*
-		 * Populate the head page vmemmap page.
-		 * It can fall in different pmd, hence
-		 * vmemmap_populate_address()
-		 */
-		pte = radix__vmemmap_populate_address(map_addr - PAGE_SIZE, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		/*
-		 * Populate the tail pages vmemmap page
-		 */
-		pte = radix__vmemmap_pte_populate(pmd, map_addr, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		vmemmap_verify(pte, node, map_addr, map_addr + PAGE_SIZE);
-		return pte;
-	}
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1320,6 +1267,11 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	struct page *tail_page;
+
+	tail_page = vmemmap_shared_tail_page(pgmap->vmemmap_shift, device_zone(node));
+	if (!tail_page)
+		return -ENOMEM;
 
 	for (addr = start; addr < end; addr = next) {
 
@@ -1352,7 +1304,6 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
 			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
-			pte_t *tail_page_pte;
 
 			/*
 			 * if the address is aligned to huge page size it is the
@@ -1377,23 +1328,8 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
-			/*
-			 * get the 2nd mapping details
-			 * Also create it if that doesn't exist
-			 */
-			tail_page_pte = vmemmap_compound_tail_page(addr, pfn_offset, node);
-			if (!tail_page_pte) {
-
-				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-				next = addr + PAGE_SIZE;
-				continue;
-			}
 
-			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, pte_page(*tail_page_pte));
+			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
 			if (!pte)
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-- 
2.54.0



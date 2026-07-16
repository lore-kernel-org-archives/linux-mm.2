Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55766C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53CD16B00CC; Thu, 16 Jul 2026 10:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED0A6B00CD; Thu, 16 Jul 2026 10:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402E56B00CE; Thu, 16 Jul 2026 10:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18A876B00CC
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:51:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A30571A01D7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:50 +0000 (UTC)
X-FDA: 84994929180.13.57CD61E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5FA8A000F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0SZi0x2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213509;
	b=EpvkBCwVgLQ+oSgpo+FyggHMogWyccJbMBOUZkK4yf8cvdHHttYMFVC5Z5emOHxSTyQwmQ
	35NFJRhQsBY+6WtUfmPm28WoO23u5BPszsrAZS+GW2KfQ2QxeEJM+N1o7oNo9lYGu0TaU4
	kHAkgrgSH0QDiC+umKSd2SsSOc7xNkA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0SZi0x2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZlNFNL1P95DigwrQPayUj7ZSeB6mvVJmhz6Pdb9Szo=;
	b=UkPQ38behl+mR5m3jpXGdN4csdvK8FM00hRyK28A+gSoYUcp8F3own1zmFCjUVCvZ4/4JD
	dj/9IIglLY+B8ypABhuRN0DA+8rBli/QHDCzneiv20/OQ6fvkdLKTEa8mxkVmUi1CtOmz9
	ulvmaamnTaab8BMUXIQ9/KSiF1NqaQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4354A41E5E;
	Thu, 16 Jul 2026 14:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD141F00ACA;
	Thu, 16 Jul 2026 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213508;
	bh=KZlNFNL1P95DigwrQPayUj7ZSeB6mvVJmhz6Pdb9Szo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D0SZi0x2ewDGHd4eKA2+QySHkSYaEz8HLpB/rttMpOzGvhmU37FSYLPQ1UK9ZFIrl
	 kOxUr+0fL5BewjN/mjLpF4WwMH9z61zVTmUfwLhPsBkHROtw6i6OcaWEECVxYj0CTU
	 XLHAbhmJ5llRz7zx1Wu1WPljC1MkGN7Lk2ps7As4zzKP1PWPnnP16nH4RdmmX4TYCa
	 PCEZJ+SmdyL8S51HNX/yv5dS4ImqdWx6mIBPvVy8zMXVSX9pBQo06+cUG9PAnurR4d
	 tiBBetK5d9UFdLYb/wdboi314HiMLMGPNAgNnfeyBBQTvrCIyBHgh6Nu6yFXi4N4Wr
	 7wcSxB2Z/7PkA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:05 +0200
Subject: [PATCH v2 06/10] x86/mm: stop marking page tables as
 MIX_SECTION_INFO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-6-4afc76c73d61@kernel.org>
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: E5FA8A000F
X-Rspam-User: 
X-Stat-Signature: 95tjzx93gasyus9hdi4mxo36gsdoje9r
X-Rspamd-Server: rspam03
X-HE-Tag: 1784213508-673425
X-HE-Meta: U2FsdGVkX1+2nVoBhQPZOAGAD9DtBl3CzFz6KQBqoOWvn8Zp9e6ruEdJVYAe0dHmOm6MabeagYQZmkrTJdUCqqOfWyZZrP77JS/PscrC2KB937xDcWhL/C8KBGsPgvVzNYO59wz8Vx+Y8/LbTdoV3H0W/8IGEClBU25EmaWvQqfy/O96dPUVh+BuT9hLWqTbFc65ZL0x5SQ0OEVAWDLLrPBe+5cSJX5KHk40bdUuI2NDHl2TLvWY13jqX11Y+adrR01VnVhQF3sd932pFWZ8XGMqYErzxTS+WChGcbj/zqFnYy97tpKoisNdL7CfQqeWGSHAVOWTroLfX45V0nmefcQai2G9rDZ+dU2jOrlg0HeXUNAEs25jWIu9cqlQwBbvX7Q7JZaWkh+RvTu4OD7U75kkUmLY7Wyc8a+c//eAbrlLQhHBKzjODHqoRxDuzIVuuXT3cbYfYsKG7rhS43jjvByLDPkHQfjFBHqc7WWdnOrEGdmaKkl2JN/uGTUL2NbGB2+I1H+tFX5YEnbj+QtTWuJLxeTGPF87hJ2UoKv7v7rFkfVmjxC/+85fMqizKOaAftgo8VYc6JoLz+vkEnmk/A2cHrOHvWbrZj9H1x4h3moG1xlshtukxSVZab6DBL3IPHU2NGjNAcNIUsmZMJUIK7xo92LnyVnQtzM8Uxjnx2JOPLt7+ka8kCCxRoTZVu6v5eQ2Eo2N44n76UNdeC8fPlPfflVfe9E/ZHha1Y9bLMWsDq9xziIwuck2kurvprYQik0fuiApi6avS7OVUz4mlyeQBdW9SYJYW54wtaVjoOQT8KkJ038TySj199XJ2rAmW7SBlfNnrNrzl+DBeT8DrRaH5mears/n2QM5iSqBx3TjF5vP3+LNxCI9ivfkdlXizTYdR48SVZADaPpNQupJ7ZZdLxVXCb3hCODc9kc6xDvhPabEwFfhKxDf6YWz0t/akPMHbFvSKk7AC1eKVo2
 UfdE6ZdY
 c2c0ZoSxoYk/Ji0wkNy89kuNEA25NrhAmG7nGQyoRO3q5izsxDzh3lfVUup7s7xDPZub1hHYn3e181BOG6HL37WUieVx1ArTCm3LD/mRVBi2mCjG4v3CnAfOu7oj9ljWkUcBqCBuSUAALSrTI1RUbkgAHmuF8m1N2cgGd/XVkYYxA0q816iitxD93Opjrvq2ZXlf2WAMYU1VSVmN2bYEVrzNGEdWV9pdadce22hDYUcWVFPdwFS1H2JqaCqAjGBwSEoJ3fri0k5af65ix0BOgwArCPAqBxUOIlQUZYsNrEOpT14I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no good reason to mark boot page tables as MIX_SECTION_INFO: we
only free boot page tables when they are completely empty, and memory
offlining/hotunplug doesn't benefit from it in any way.

So just stop marking page tables as MIX_SECTION_INFO. In
free_pagetable(), we can now simply free reserved pages directly.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/mm/init_64.c | 59 ++-------------------------------------------------
 1 file changed, 2 insertions(+), 57 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 82bb0384b8ab0..1b17dcf781e66 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1002,21 +1002,10 @@ int arch_add_memory(int nid, u64 start, u64 size,
 
 static void __meminit free_pagetable(struct page *page)
 {
-	/* bootmem page has reserved flag */
-	if (PageReserved(page)) {
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-		enum bootmem_type type = bootmem_type(page);
-
-		if (type == MIX_SECTION_INFO)
-			put_page_bootmem(page);
-		else
-			free_reserved_page(page);
-#else
+	if (PageReserved(page))
 		free_reserved_page(page);
-#endif
-	} else {
+	else
 		pagetable_free(page_ptdesc(page));
-	}
 }
 
 static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
@@ -1579,50 +1568,6 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long nr_pages)
 {
-	unsigned long addr = (unsigned long)start_page;
-	unsigned long end = (unsigned long)(start_page + nr_pages);
-	unsigned long next;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	for (; addr < end; addr = next) {
-		pgd = pgd_offset_k(addr);
-		if (pgd_none(*pgd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, pgd_page(*pgd), MIX_SECTION_INFO);
-
-		p4d = p4d_offset(pgd, addr);
-		if (p4d_none(*p4d)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, p4d_page(*p4d), MIX_SECTION_INFO);
-
-		pud = pud_offset(p4d, addr);
-		if (pud_none(*pud)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
-
-		pmd = pmd_offset(pud, addr);
-		if (pmd_none(*pmd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-
-		if (!boot_cpu_has(X86_FEATURE_PSE) || !pmd_leaf(*pmd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			get_page_bootmem(section_nr, pmd_page(*pmd),
-					 MIX_SECTION_INFO);
-		} else {
-			next = pmd_addr_end(addr, end);
-		}
-	}
 }
 #endif
 

-- 
2.43.0



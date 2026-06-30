Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AECC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E49E6B00C4; Tue, 30 Jun 2026 09:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB6C6B00C5; Tue, 30 Jun 2026 09:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685186B00C6; Tue, 30 Jun 2026 09:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 423A66B00C4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0D091C6F9D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:54:08 +0000 (UTC)
X-FDA: 84936722976.09.2B640E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id C0BC4180010
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:54:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fiyz70s4;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782827647;
	b=u1mZTLScCSNk6VjjSkRPvfrKirv+7KAfqydthmmlBU6JjFf9/Qkqg904xxFII/UpAWWMC/
	Zb4ufrv1jnXfdAyjVrfw92S/fczFc4HSdnSa/cAZSVm//BpFnUwgr4t8HZLpFqxX/PnPS3
	H6+H5tmT1+FVUxw/w8lr7wXT/hOPMFo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782827647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLHXcI/HKqO5FoP5ekHLJyOWMc2esg2pwNnV2oeU7xY=;
	b=FtOLbwCfFzaOTwDTzXujU2KbnUDuU7BOd/i8SPvVcdCnbgEq2yr+PIsqRYfpmaGrk6bxSL
	x4i5vWUsANVKZIr0eI2oIY0rgz47eeW8Md5xmR2rNCR6mYzY5MwoKN9g3p5UTxDNl4fW8F
	Zpe2sVLRAA8/TZrYIYz3KxnKpeFmYZ8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fiyz70s4;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B1BC1C01;
	Tue, 30 Jun 2026 06:54:01 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E86503F66F;
	Tue, 30 Jun 2026 06:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782827645; bh=bRjeMLBRn+jxQAm2ekNeaSxDem01aFIboF+1jmwc+uU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fiyz70s4+uUmNIjX6xDSUdsEK140AT1ai79NuNO+FWxq+cbpgHt9EB8jc7BkLtcU9
	 0K71n9prgUrk/y4KNQgNrLb42LI0u/iktK1roYgs9wWn3PE9SaEULIHo9SXT8C4g/+
	 gn+oSZCYkUxpoyK2BiuJDr9vOdIKKu/7eKYah7ME=
Message-ID: <cf369aa5-e540-4c3b-85d6-0e9e159496ed@arm.com>
Date: Tue, 30 Jun 2026 19:23:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com, apopple@nvidia.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 mel@csn.ul.ie, nao.horiguchi@gmail.com, ak@linux.intel.com,
 j-nomura@ce.jp.nec.com, pfalcato@suse.de, dave.hansen@intel.com,
 tglx@kernel.org, jpoimboe@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <0fabee2a-edb7-41c8-91ec-8cf0646c9e83@kernel.org>
 <20260629074802.42727-1-lance.yang@linux.dev>
 <a1c6c3dd-8db1-4db6-b032-e350bacc4577@kernel.org>
 <6fdc0cbd-0880-4594-bf33-a2993ac2fe60@arm.com>
 <1fb04774-1ac6-472a-bbc8-52fceb69b018@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <1fb04774-1ac6-472a-bbc8-52fceb69b018@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0BC4180010
X-Rspam-User: 
X-Stat-Signature: g9ak56qi9awf1csgzp9jia6e1ken9ju7
X-HE-Tag: 1782827646-286815
X-HE-Meta: U2FsdGVkX18y4v+wJpsBSWfAJ0Z7hB/WlXzYGZ4nng9iDCI/svH9adOBaOREFvZSHkE7yH1JoxY7TC10fke2FpHuQW9OtwfNnu/YRGTweyNLtnLbkHcpr5Zudihqp8el255ffLWbAoRakHSBZ+dsxS7sqL752c5FCMizYfsW+Hxobb5UqEjwvzeMriv4qdF9tfRGwNMVO8qqx+gD7u/lYwdDes8bLI2w8qKfAHmJKX+r8tIqIYv6xzLwwi88jv6TalGtIVoUMWg+bcEY5a7AGoHNM98b3LIJKZx2Y4hX7FqyGnSoHYtBvC+iUDLTIQb3mTUvnYPlI9hW+SmDoK0AjPE5SdewWC3EJD/eZe+LOsLaHw6q4ilqlUDEPfaImuQBXGLnYJ6MnyQCCUDgyBZqlJlFYNfHOc/MZtpy7O5wvDGU1yMhLQ+I/vy+Wp8dRL7iIuVImIgUhBGkUzq53GSA4TkAPEZbaPgA+hmqlVctaI5+b19QEf9w5jaSNSWnnITBMLf/xpsbq7cJEHgYGZ9IIVwgRp4Hi4KhLrlbVmF8PlpBI6CJLKBTC0lrE3Q6/RMLQELGwYWEIvtdF0/TB5klA8sYDEU6ucs9OVttwG8ONfhRZPqqNbtq2E0/W0xudhhtlHNKc0Q+IjZMtNikzBb5nxvLIx4ofzl+IkhdNkJ8duMTZ/3K/oXN8XZ4KH2vCbzPUEWNCskGahHkwIoUHMW75uOk/cCwR1r5ACg1PLQogK2BwRWVrdwqe8QQExwdniuDZfnDHzoMyyxit/Z0YokcAdzomRug9SJQ/ZLdJr7bmwcolMPcugkkhmADY7hyt5s/lYYtY8xB+cl5yUfezTC+BOiq8Wk2qy5updfH2WXSz+O44zHzyM0z9D7wt/SpWkkKR6nou+7FHWggslk3op6aglXvBAPABriq3ZtUE8CecVQS8uUa0qOuSVqoADldN+zErdOChgKrGJeiofzoTFI
 2mKVJTEN
 6nNAXghLYXUGbgcoVWRS9taJ2n1yFmtZWeDnz4UXGT07H1oLh4/k/rdK5dVZQ6I+x3SXimZTuSPQYHgbxfVgIHYpCQB257SL+q1UISpX6+3+u1odxJyDU1IRZdIF9sud9PxN3+o41Cb61fUrtYJz4WmcynP5A0pXR8FO6RYJvRjitKJ4/hmlVIaPAz+AM4w/rAFJ7M6PhSLXXVP4+uCLUDEn+u0vLPazaI4vbQP+VsD3RfqqPRMEMr11jTP70lURXwpyzURmlGQPzEtrjVdSF5oz1BD3NzRcL37PL3BLyNmIK2OvwJqUN/HlqLpVco8RSmWLbX5K8VMjM40hf4GQpBbGzEAn4HrkdDC2JI+MjVISs2k0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/06/26 6:16 pm, David Hildenbrand (Arm) wrote:
> On 6/30/26 13:34, Dev Jain wrote:
>>
>>
>> On 29/06/26 1:35 pm, David Hildenbrand (Arm) wrote:
>>> On 6/29/26 09:48, Lance Yang wrote:
>>>>
>>>> >from pagewalk code (where some users like pagemap need the actual address).
>>>>
>>>> Indeed ...
>>>>
>>>>
>>>> Kinda lean toward option 1, even if it's more invasive. If we pass the
>>>> hstate down, each arch can figure out the right addr from there.
>>>>
>>>>
>>>> AFAICT, for huge_ptep_get() the addr users are arm64 and powerpc, riscv
>>>> doesn't really care about addr there. Looks mostly arm64-specific ... 
>>> powerpc handles it correctly in the weird "span two PMD entries" case by
>>> aligning the PMD down.
>>>
>>> Risc-v copied from arm64, but can simply derive the #entries from the PTE value.
>>> it doesn't have to re-walk the table using the address.
>>>
>>> But I think the following is required to fix, no?
>>
>> We don't receive an unaligned ptep in huge_ptep_get, and riscv derives the
>> number of cont ptes from the pte itself, so why is the below required?
> 
> Let me look at the actual report once more ...
> 
> I thought for a second that the problem would be having the ptep not point at the
> start of the hugetlb page mapping. But that should always be the case.
> So yes, riscv does not have any problems.
> 
> And IIUC, arm64 only has a problem when CONT_PTES != CONT_PMDS (16 kernel?).
> 
> Yeah, aligning the ptep down doesn't solve anything, it's already properly aligned.
> 
> To fix it inside arm64 code, we'd have to teach find_num_contig() to
> ignore the ptep and instead look for the cont bit, maybe?
> 
> But I'm sure I messed this up as I am working on 10 things at the same time :D
> 
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index d477a9dd1b472..d1d03795c135e 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -76,7 +76,7 @@ bool arch_hugetlb_migration_supported(struct hstate *h)
>  #endif
>  
>  static int find_num_contig(struct mm_struct *mm, unsigned long addr,
> -                          pte_t *ptep, size_t *pgsize)
> +                          size_t *pgsize)
>  {
>         pgd_t *pgdp = pgd_offset(mm, addr);
>         p4d_t *p4dp;
> @@ -87,7 +87,7 @@ static int find_num_contig(struct mm_struct *mm, unsigned long addr,
>         p4dp = p4d_offset(pgdp, addr);
>         pudp = pud_offset(p4dp, addr);
>         pmdp = pmd_offset(pudp, addr);
> -       if ((pte_t *)pmdp == ptep) {
> +       if (pmd_cont(*pmdp)) {

We can simply do this right:

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index b8432886085af..a35fa373263dc 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -87,7 +87,7 @@ static int find_num_contig(struct mm_struct *mm, unsigned long addr,
 	p4dp = p4d_offset(pgdp, addr);
 	pudp = pud_offset(p4dp, addr);
 	pmdp = pmd_offset(pudp, addr);
-	if ((pte_t *)pmdp == ptep) {
+	if ((pte_t *)PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS) == ptep) {
 		*pgsize = PMD_SIZE;
 		return CONT_PMDS;
 	}


>                 *pgsize = PMD_SIZE;
>                 return CONT_PMDS;
>         }
> @@ -131,7 +131,7 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>         if (!pte_present(orig_pte) || !pte_cont(orig_pte))
>                 return orig_pte;
>  
> -       ncontig = find_num_contig(mm, addr, ptep, &pgsize);
> +       ncontig = find_num_contig(mm, addr, &pgsize);
>         for (i = 0; i < ncontig; i++, ptep++) {
>                 pte_t pte = __ptep_get(ptep);
>  
> @@ -475,7 +475,7 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
>                 return;
>         }
>  
> -       ncontig = find_num_contig(mm, addr, ptep, &pgsize);
> +       ncontig = find_num_contig(mm, addr, &pgsize);
>  
>         pte = get_clear_contig_flush(mm, addr, ptep, pgsize, ncontig);
>         pte = pte_wrprotect(pte);
> diff --git a/mm/memory.c b/mm/memory.c
> 
> 



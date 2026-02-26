Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F3EFCE06D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 623076B0088; Thu, 26 Feb 2026 07:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9EA6B0089; Thu, 26 Feb 2026 07:49:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5274C6B008A; Thu, 26 Feb 2026 07:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 400BC6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:49:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD74B13C0BD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:49:56 +0000 (UTC)
X-FDA: 84486589992.29.2DE7418
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 92ABDC0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:49:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772110195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BcQzBIoel8ouA37v+xJmTro0U9klZrqKYw4HmUnjPwY=;
	b=jCF6UxsJ098aIMK+4iabxIeXbOhw/YwvXe/evTMmHx186MFcGtmF8GsSKlUT2bGNg3qzoM
	GKQB6M4U4TywUL56ROxm16qOpZyLf9TH605M6t2y4mphmPgecBkTe9rYCfDLn1maGJWOUL
	s/puwJUDJi2ao+VKVObGjAakpbpqbpM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772110195; a=rsa-sha256;
	cv=none;
	b=E0OLdAcddYxu4vL9iMZB3sSH6kH4FmNhpJeEs94ppYHROgIcqJAutAlWp6jVbc5lOqasdL
	Y8zcanZUK/+K9os+ALYOC2N+AzHGXiBHaDmgWTF/XM1+3AoKFTutad75oy1YCHI6soH+uO
	ZqKhY3YmsaY0schQVfzW8A1ecaJ5EBc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A9E91516;
	Thu, 26 Feb 2026 04:49:47 -0800 (PST)
Received: from [10.163.173.11] (unknown [10.163.173.11])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D99D43F73B;
	Thu, 26 Feb 2026 04:49:48 -0800 (PST)
Message-ID: <75c09e05-1b8a-4009-bbb3-07924b76b532@arm.com>
Date: Thu, 26 Feb 2026 18:19:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 01/16] mm: Abstract printing of pxd_val()
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260226123442.759447-1-usama.arif@linux.dev>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260226123442.759447-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92ABDC0011
X-Stat-Signature: eygiccqnw76yir3pdjqauyp5g8af5aiq
X-Rspam-User: 
X-HE-Tag: 1772110194-267671
X-HE-Meta: U2FsdGVkX18RNue9NOR0fuG1/jnxKyNfj7TR3glyl70kN1bfIbQ1/oOovb50HGp6UzDHG3rWFUhP6Js7mFyz/LtebF2qlKVpfpiKNrsbVWdcMzRguIKwq1F9xruk/Kf3l/Bx1WF4RcHLG3+R3txMxpw8KyvLXu22F4T4udd3zep0kDq6857rWXrutHWWbpZ3x49TgOQ8kxeIUp4yE2HrKo8KrKgjbHUhT4m5bkgDhgR+KFlSQQus5t4IhlFqsQi+R1DtE3ZGqrrwLSueShKsTCDmHx+MlsUEX8zN922HK2Zd0boMQobehAjZvnw8uf36IQie0yAtTRRhHVrVSvjwcEpzHVdgU+JojedXpA3wOUH3CmMTpn1+x9YqhriA0aWs0Jjj7UlnuJ49X5mRn2fyxGpdZoJd4/xP1uo6MVxA0mHLqKXFbk7/MAHFMDJG9K8ZMmHjf5dW2onRYr8jyFHLfewZH+xkM3uDM4Yf8GP113ba1DDj7Uk0BWhbndcBRotQBEci5xPqydyWHFzw227NCdnc2s4e6eCOwTnM5x/3sBtLWYI60YIzytlJgAp/bwshpqM01pYxzSA2gd7Dpy1H2Em1Zo2T5UKMljqte1fvBkIp6fQ/R4zGmMVC/K4M9jQwXhXWaP6VkDm+wfiywXzjMLF7IJro0nAxjCxHgoiA3qfRwjbsHmLxprslJRsyNH7FkdcF0rdPG50vsQ3FgQFg6UiWYsUCHgziOmnTIV1RorpyjP++CG54lmafufNOjIv/h7TSNJUzF4ad9W/ypMz0DlkvVIkp0UYF0MY1yV+++21OXrcaocfzLAaAH6h5J0dLU0Pz4g9YP5/8wIipGVHLOwgWOKLK9jMCQTEIByyXg5GsKe5fOdb7rZO7xhEcGC2TZ6njwgnQ1tYgLvIY/ypXfbTX7z4LtEUY8dUMRpi2V3ZKYqCVl1FyPe1e4AzMjJVccoa6TAkeBhzKxJb/tiy
 Vx5F/x99
 6rmCK/QibccjYmPInW0Aij7DVZ/0VsaVNJLmbCXgL1nLtxlK37oLfUmRtatV5eVSa91jRmVLL++QC8mSWThVtPxKwoiASqbpesszjjEkOJwzUR6INB72wbOQ7FlirnqPP650YoubOjcRl51itB32UfNFHEkqA+wNm8salQdxX5pRKuV5Ruxt559TEUDUTMOgaKq3HjkvdHloQo5MsYvTx4YjZX6CY2asHqmk2R0K06ifQcit8bu2H7GfezGZ5LDJmG8lGJrwcQAGgVVsqkRg4FDodggAeWYwCLNu8nQrZ8fJf71f8m57HkvvZJMGTUJYIK0K5bhrvsPHEoXSG1W4ou0jpUjQ3qfwpzHJu06cqo+GuNDQsQ/TsmZ+nTu4Bc+CooQtf5q7xYP7x8Qh6re9gpJg4vbAZpouXIwl4knHk2Jl7reysOnvL6FxzPIXgm7gQdcCF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/02/26 6:04 PM, Usama Arif wrote:
> On Tue, 24 Feb 2026 10:41:38 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
>> Ahead of adding support for D128 pgtables, refactor places that print
>> PTE values to use the new __PRIpte format specifier and __PRIpte_args()
>> macro to prepare the argument(s). When using D128 pgtables in future,
>> we can simply redefine __PRIpte and __PTIpte_args().
>>
>> Besides there is also an assumption about pxd_val() being always capped
>> at 'unsigned long long' size but that will not work for D128 pgtables.
>> Just increase its size to u128 if the compiler supports via a separate
>> data type pxdval_t which also defaults to existing 'unsigned long long'.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  include/linux/pgtable.h |  5 +++++
>>  mm/memory.c             | 29 +++++++++++++++++++----------
>>  2 files changed, 24 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index a50df42a893f..da17139a1279 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -17,6 +17,11 @@
>>  #include <asm-generic/pgtable_uffd.h>
>>  #include <linux/page_table_check.h>
>>  
>> +#ifndef __PRIpte
>> +#define __PRIpte		"016llx"
>> +#define __PRIpte_args(val)	((u64)val)
>> +#endif
>> +
>>  #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
>>  	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
>>  #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 07778814b4a8..cfc3077fc52f 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -532,9 +532,15 @@ static bool is_bad_page_map_ratelimited(void)
>>  	return false;
>>  }
>>  
>> +#ifdef __SIZEOF_INT128__
>> +	typedef u128 pxdval_t;
>> +#else
>> +	typedef unsigned long long pxdval_t;
>> +#endif
>> +
>>  static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
>>  {
>> -	unsigned long long pgdv, p4dv, pudv, pmdv;
>> +	pxdval_t pgdv, p4dv, pudv, pmdv;
>>  	p4d_t p4d, *p4dp;
>>  	pud_t pud, *pudp;
>>  	pmd_t pmd, *pmdp;
>> @@ -548,7 +554,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>>  	pgdv = pgd_val(*pgdp);
>>  
>>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
>> -		pr_alert("pgd:%08llx\n", pgdv);
>> +		pr_alert("pgd:%" __PRIpte "\n", __PRIpte_args(pgdv));
>>  		return;
>>  	}
>>  
>> @@ -557,7 +563,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>>  	p4dv = p4d_val(p4d);
>>  
>>  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
>> -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
>> +		pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "\n",
> 
> Hi Anshuman,
> 
> The original format had a space between values ("pgd:%08llx p4d:%08llx").
> The replacement loses the space separator producing output like
> "pgd:123p4d:456" instead of "pgd:123 p4d:456". The same issue exists
> in other places in this commit.

There needs to be a forward single space before p4d starts.

pr_alert("pgd:%" __PRIpte " p4d:%" __PRIpte "\n"

			  ^^^
Will fix all the instances.

> 
>> +			 __PRIpte_args(pgdv), __PRIpte_args(p4dv));
>>  		return;
>>  	}
>>  
>> @@ -566,7 +573,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>>  	pudv = pud_val(pud);
>>  
>>  	if (!pud_present(pud) || pud_leaf(pud)) {
>> -		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
>> +		pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "pud:%" __PRIpte "\n",
>> +			 __PRIpte_args(pgdv), __PRIpte_args(p4dv), __PRIpte_args(pudv));
>>  		return;
>>  	}
>>  
>> @@ -580,8 +588,9 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>>  	 * doing another map would be bad. print_bad_page_map() should
>>  	 * already take care of printing the PTE.
>>  	 */
>> -	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
>> -		 p4dv, pudv, pmdv);
>> +	pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "pud:%" __PRIpte "pmd:%" __PRIpte "\n",
>> +		 __PRIpte_args(pgdv), __PRIpte_args(p4dv),
>> +		 __PRIpte_args(pudv), __PRIpte_args(pmdv));
>>  }
>>  
>>  /*
>> @@ -597,7 +606,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>>   * page table lock.
>>   */
>>  static void print_bad_page_map(struct vm_area_struct *vma,
>> -		unsigned long addr, unsigned long long entry, struct page *page,
>> +		unsigned long addr, pxdval_t entry, struct page *page,
>>  		enum pgtable_level level)
>>  {
>>  	struct address_space *mapping;
>> @@ -609,8 +618,8 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>>  	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
>>  	index = linear_page_index(vma, addr);
>>  
>> -	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
>> -		 pgtable_level_to_str(level), entry);
>> +	pr_alert("BUG: Bad page map in process %s  %s:%" __PRIpte, current->comm,
>> +		 pgtable_level_to_str(level), __PRIpte_args(entry));
>>  	__print_bad_page_map_pgtable(vma->vm_mm, addr);
>>  	if (page)
>>  		dump_page(page, "bad page map");
>> @@ -695,7 +704,7 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>>   */
>>  static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>>  		unsigned long addr, unsigned long pfn, bool special,
>> -		unsigned long long entry, enum pgtable_level level)
>> +		pxdval_t entry, enum pgtable_level level)
>>  {
>>  	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>>  		if (unlikely(special)) {
>> -- 
>> 2.43.0
>>
>>



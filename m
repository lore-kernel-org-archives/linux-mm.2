Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D4E5CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E496B0098; Wed, 24 Jun 2026 10:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A2F6B00AD; Wed, 24 Jun 2026 10:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4E36B00B0; Wed, 24 Jun 2026 10:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABA836B0098
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:32:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38857A035D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:32:48 +0000 (UTC)
X-FDA: 84915047616.20.384C81D
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4119810000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:32:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UMJJQgr7;
	spf=pass (imf14.hostedemail.com: domain of abarnas@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782311566;
	b=GsTUgVHySqP6frHDUDd/ED7P2y4Bfh6m9dST3rPqL1boMK+VU0CExhWZDG9ldO96InaEun
	/tuALbxTsHcN+0TO0/Fxfd9cN33FQOQWTBGDjbeRyVkHuQYu6iywFYpTz2RZlBkgMajdXq
	rtybUDQPIRTicd8seDNZaXD1AwZ+toE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZY3mpmKpMn6hPTo5zempi8aavh2AOA9wO8Ai718llA=;
	b=Qkr8vB/mhOY3P8AkBdZSsznr8bn0rRXD8/v4dHP/4mw2/kA0E2NuzhqrnM081JIrC6ywO0
	zk63NiOtm5Kh6WZvv6QaOurUT2UDBeAZwy/eKoMPtBaw4xS02XA0waeVXyer1gtvVzZtH3
	TvQCmn3/mmV5mSxO9b9+KgGAy3E6Mc0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UMJJQgr7;
	spf=pass (imf14.hostedemail.com: domain of abarnas@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-463b2f6fc9dso1258586f8f.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782311565; x=1782916365; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0ZY3mpmKpMn6hPTo5zempi8aavh2AOA9wO8Ai718llA=;
        b=UMJJQgr7UQ0kT7oM2gCcQppIGMuUNPSN4zXe5G5khYmEFjj6PGSAA5iANt8ekQ2wRj
         o1QMGiNTpLx2plhGytC93yYm2oZPHT1Q1OiQPklHSjLcqxFquVHnnJog3ORF0v4zYRwE
         Ms3121mzDWUO9HfDwRegF0ucluQrKnCB9/SQBWBpwAtfWqw9B4IB8acTpqd7hzBOAOBJ
         tXUES8Futljop1pK3uaDCTA4/32PCrPSAqblUHWf0qCegjVaL5pfKbsw2I7Z7XCLZeUm
         it3sSpiVlTA6tGehxqfqvez45izH8DG/PfSZ3EaddPf/pZSfIOAVA1lcPf2KE86VkeWe
         TtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782311565; x=1782916365;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZY3mpmKpMn6hPTo5zempi8aavh2AOA9wO8Ai718llA=;
        b=OVwiiw3QOPySwrU7YhgTOhA8+ZKJ6JfeZtiKKz9iA4xSkE3v933x3+VH+BgSxgCYtw
         U+y2P0fD86zMu5TpvgD28EtbXEeWydmQKoahB89fKGN/uuCwVxMKrNsCRolt3zfPs1eW
         gdH9QjXBtVRQcWOQDC1cQDdwfmV6w+cbKtb0cRexnEEVmmDDk+9n3twY7NjiUPla2Hv2
         4HAuAy8bFFZaJHrizqHM/f9q2cXImHkbxi13NrjATYKGabwBm1Btw2ClW8Ney/GgI3/7
         1PbDYfiq7SRwznS4HPYSVKaLjpGN6cdN9LctA6RXdeOwYbeSPn766yblVsiRBsTRnSMZ
         JXog==
X-Forwarded-Encrypted: i=1; AFNElJ+G7gJVsT/T1v3NwPzU8rXLklyhb1hj4CZHmzAeK+s6xHJj1vDiwth7ZxhKFM/TsTmGpBThFZ+RWA==@kvack.org
X-Gm-Message-State: AOJu0YyIK7HDHs7nJCnztqmT32pqjiKgBKcOG1TDkRs+RHauXi5GGVmX
	l9AnMbnbim5mAl1MVbRrA4vD9kqs6r9BtRdOb4uIMWHXQwZ2i4LGGwsP4M3OZYnQFT8R7L8FTo9
	sQeuTlw==
X-Gm-Gg: AfdE7clwnRKVxHEd1vljl74m2/NqaJRWeejhzIhyANN60joUe9XbklvKqubCUmEQBzd
	bOrB+5zxJzqJhdBgnbQlBqw8aUmeHzMAwT9pqPwWkrrn6uhbe+XZDcddGEUBNOWDBK1IPY85yv+
	eAK9doaCa+lNPqk+zyQoQucjlAe7mCoP4k3R9b4/AZaZTrEE8b0HHCsbQEz5p6I45q2HiInd2jt
	zF5QUNCeTZnS/iXsfgKdQwV2aETuMJQtXlYT65pjU9zc2yMFVkmNzGnurNegHHQf7U42U3iHG4q
	yaH7OEzsTr4ZWs0cbyZnyFpO212VlqXZfFHTznjoZWNhcUNFOZCcsKhkNwJwmW2iMUGSpbFKbcA
	HBPNoz1r4GQXRdfyidqg69i3bigoCYv2wdVoHmLZnX1Y2a67idkapTdZv7p+fuWn0kG9nLUBFwh
	vwWaMz6JfGejNFpYBhwpIoFJYlY9+qbhH0nPPSaJNk8BBXyH8=
X-Received: by 2002:a05:600c:1553:b0:490:cb90:3e13 with SMTP id 5b1f17b1804b1-49260872798mr53816085e9.21.1782311562517;
        Wed, 24 Jun 2026 07:32:42 -0700 (PDT)
Received: from google.com (97.113.76.34.bc.googleusercontent.com. [34.76.113.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd154fdsm428332795e9.1.2026.06.24.07.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:32:41 -0700 (PDT)
Date: Wed, 24 Jun 2026 14:32:39 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [RFC PATCH 6/6] arm64: mm: support PMD page coalescing in the
 linear map
Message-ID: <ajvqh8Ac0Sj5UzP_@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-7-abarnas@google.com>
 <799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com>
X-Stat-Signature: 8hxmthin3i3e7gcsq3hgd4iwckamzba4
X-Rspamd-Queue-Id: 4119810000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782311565-284016
X-HE-Meta: U2FsdGVkX1+cKeF8Ni84aIsuCDVuV1y0NTzrnMdexexOXpnKfLNRnvOPfvH61K7G4IWPkt8hIY9fYuFu9tDJsF6/LBLCmFzvbv4UFVcQhGd1QWacNzYdXpGvg2MCf8gunSI8aLacpj9iVsXMs0AVe315rVc5JIEuzOnfwPulyszgElB6jzGPo5YH0PlWHeiuWp65noZxFcTFxd8i3qDYP+pofPqQSJLwXaKKStV4gDEcxPyjTYvNPJM4HcmVxL+ok6ycgaljuMrvjQQKVOFDRFLn2seg4BdvRpUPsI5X780yPAAG0MTa64pjlq1Fix/F4QwQwp9y/N3XpwLw1OO3KKSICQ2wKDEnfefxLzyvFF0jCA5MxORjfwhLsC5HAbnhWap6d/YIvqv18K5fsgWf2EBPJ63d9RH4Hpwd4YVj2FacRqPNyuqnBIH18xX2+3mVWBP19L1biKSdUDsIAbqXxhsJgaFMLO/XoN9zC90AAsBcW8CY/HOXSvwRlMZKVp1aVL4ySkTcPwEI8LWxI1pjLhIseDz1DGvNKa3A65S5Yvw//nDldJW9P3JN+MbWNWMg6mEQRRh+EjHdmhq7dV/BqeQpIVlB9iXSGOVXlkcUq8Gv3e+ZZUPjFrmQlZH8NmRTfGtekqNc5snQlA+8l2jkXoa6rESPiCGY8G8k4d771zWFfXaF84VjNKuThpzAF4MKIA91kT97kPfpCe/AUTh6aMtvMGRaRlAcx+ecVzPQsuwfJHuAt6qTCDZUZH0hB8Se95n0vRGJQvcgSsfHJSKe7HkJjbcs9u80Fs5zDHpBENVRbiZzZbF7A39eYcd+E9F7Ypkxk8Afuw1lo+zehLC/sxzG0Pijf8G05+MLSs4/WA4S5Jh4Pxa+y3h7MtlvKfGQI4GwtSyNMj3DPa5BAVrVShCpENdeligkEtjVcxtti0LrAZbEVTFO6XioNhDpeuRCUt6O1N90pNLmO27y5oZ
 8NWeT5Zi
 +zfzKIft+IQKRkegQWjT+uoeagXUWwoiD23ZeV+IGX34F+4CZ7XdGOANrs+FXwVl7TOEzCmS/8Yu8DfXw0BgxK+j3/ZEeCwmjDKKZkueQBRJh+MsaWZin/40NhxM6ph+ZBxUpmUOlwSwMHBM3Ur/DZxT79XwV8UOBQf/5OXuktmHANi4CIYHQyTwkQLmtPoTsd2yTAJlQMH56MzXIBkiAXNyf8MXnt9/MfD4VL0taLe2cTCizfnWgiPONyrJMPrIK/USw8fyvF7+RhQCTdokORifoBmWs/5hhZhxjmp29Fn66nGYFoSmy5H9oStqj5I7ZGI8Q9Lj9z75/Oz/JACbi8DGIseXBbezBh9/Vwhy4XPc3938vl0JtNh55YtEMxPftrZQKFJvAFEXf7s+tbb+GKBicvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 02:40:40PM +0100, Ryan Roberts wrote:
>On 11/06/2026 14:01, Adrian Barnaś wrote:
>> Implement PMD block coalescing to merge fragmented linear mapping regions
>> back into huge pages when restoring the read-only attribute.
>>
>> When memory allocated with VM_ALLOW_HUGE_VMAP (such as for the execmem
>> ROX cache) has its permissions modified, the PMD block mapping is split
>> into individual PTEs. Without this change, when that memory have its RO
>> attribute subsequently cleared and set the mapping remains permanently
>> fragmented into 4K pages.
>
>I'd like to make sure I understand this correctly: So the execmem ROX cache is
>allocated using vmalloc_huge such that all it's backing memory are PMD-sized
>pages. It is initially poisoned with a faulting instruction and marked ROX. When
>a module is loaded, it's text is copied into a portion of the ROX cache and
>executed from there? To do that, the required number of (4K) pages are allocated
>from ROX cache, and the permissions are changed on that sub-region to RW,
>meaning we have to split the mapping from a PMD to (cont)PTEs in both vmalloc
>space and in the linear map. After the text is copied, the sub-region is
>switched back to ROX. But without that change, the 2M region is now mapped by
>(cont)PTEs for all of time?

That is correct.

>
>>
>> Signed-off-by: Adrian Barnaś <abarnas@google.com>
>> ---
>>  arch/arm64/include/asm/mmu.h |  1 +
>>  arch/arm64/mm/mmu.c          | 95 ++++++++++++++++++++++++++++++++++++
>>  arch/arm64/mm/pageattr.c     |  7 +++
>>  3 files changed, 103 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
>> index 137a173df1ff..19158bacb2df 100644
>> --- a/arch/arm64/include/asm/mmu.h
>> +++ b/arch/arm64/include/asm/mmu.h
>> @@ -80,6 +80,7 @@ extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
>>  extern void mark_linear_text_alias_ro(void);
>>  extern int split_kernel_leaf_mapping(unsigned long start, unsigned long end);
>>  extern void linear_map_maybe_split_to_ptes(void);
>> +void try_collapse_kernel_pmd(unsigned long addr);
>>
>>  /*
>>   * This check is triggered during the early boot before the cpufeature
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index a6a00accf4f9..d74226fa1c9b 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -769,6 +769,101 @@ static inline bool force_pte_mapping(void)
>>
>>  static DEFINE_MUTEX(pgtable_split_lock);
>>
>> +static inline bool __pte_can_be_collapsed(pte_t pte, unsigned long pfn, pgprot_t prot)
>> +{
>> +	if (!pte_valid(pte))
>> +		return false;
>> +	if (pte_pfn(pte) != pfn)
>> +		return false;
>> +	if ((pgprot_val(pte_pgprot(pte)) & ~PTE_CONT) != pgprot_val(prot))
>
>Do we want to permit differing values for access and dirty? We do for user
>space, but I think for kernel, those bits are always set? In which case, what
>you're doing is correct.
>
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>> +static void __try_collapse_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr)
>> +{
>> +	pte_t *ptep;
>> +	pte_t first_pte;
>> +	unsigned long pfn;
>> +	pgprot_t prot;
>> +	int i;
>> +
>> +	ptep = (pte_t *)pmd_page_vaddr(pmd);
>> +	first_pte = __ptep_get(ptep);
>> +
>> +	if (!pte_valid(first_pte))
>> +		return;
>> +
>> +	prot = pte_pgprot(first_pte);
>> +	prot = __pgprot(pgprot_val(prot) & ~PTE_CONT);
>> +	pfn = pte_pfn(first_pte);
>> +
>> +	if (!IS_ALIGNED(pfn, PMD_SIZE >> PAGE_SHIFT))
>> +		return;
>> +
>> +	for (i = 1; i < PTRS_PER_PTE; i++) {
>> +		if (!__pte_can_be_collapsed(__ptep_get(ptep + i), pfn + i, prot))
>> +			return;
>> +	}
>> +
>> +	set_pmd(pmdp, pmd_mkhuge(pfn_pmd(pfn, prot)));
>> +
>> +	__flush_tlb_kernel_pgtable(addr);
>> +
>
>nit: suggest adding the same comment that other sites has, since this is not
>obvious:
>
>/* See comment in pud_free_pmd_page for static key logic */
>
>> +	if (static_branch_unlikely(&arm64_ptdump_lock_key)) {
>> +		mmap_read_lock(&init_mm);
>> +		mmap_read_unlock(&init_mm);
>> +	}
>> +
>> +	pte_free_kernel(NULL, ptep);
>
>Ooh, fun. Per my comments below we definitely have opportunity for racy pte
>table accesses (beyond ptdump). I _think_ if you fix that then this will be safe.
>
>> +}
>> +
>> +void try_collapse_kernel_pmd(unsigned long addr)
>> +{
>> +	pgd_t *pgdp;
>> +	p4d_t *p4dp;
>> +	pud_t *pudp;
>> +	pmd_t *pmdp;
>> +	pmd_t pmd;
>> +
>> +	/*
>> +	 * collapse_pmd expects exact address of block to be collapsed
>> +	 */
>> +	if (WARN_ON(ALIGN_DOWN(addr, PMD_SIZE) != addr))
>> +		return;
>> +
>> +	mutex_lock(&pgtable_split_lock);
>
>I don't think this is safe in general. Let's say we have a 2M region split into
>512 x 4K PTEs. It's possible that the first 1M is one object and the second 1M
>is another object. Different CPUs could set_memory_*() on those 2 objects
>concurrently. If one of them then calls this function, we could end up
>collapsing the whole 2M while the other is trying to modify the PTEs and they
>will race.
>
>Note that splitting _is_ safe (and protected by this lock) because you'd have 2
>objects backed by the same PMD, so they would both have to split before
>modifying the PTEs.
>
>I think you'd need to ensure mutual exclusion at a higher level if doing this;
>probably execmem is the place that can ensure that no objects within a 2M region
>are racily trying to modify their permissions?
>
>> +
>> +	pgdp = pgd_offset_k(addr);
>> +	if (pgd_none(READ_ONCE(*pgdp)))
>
>nit: use the getters (e.g. pXdp_get()) instead of READ_ONCE().
>
>> +		goto out;
>> +
>> +	p4dp = p4d_offset(pgdp, addr);
>> +	if (p4d_none(READ_ONCE(*p4dp)))
>> +		goto out;
>> +
>> +	pudp = pud_offset(p4dp, addr);
>> +	if (pud_none(READ_ONCE(*pudp)))
>> +		goto out;
>> +
>> +	if (pud_leaf(READ_ONCE(*pudp)))
>> +		goto out;
>> +
>> +	pmdp = pmd_offset(pudp, addr);
>> +	pmd = pmdp_get(pmdp);
>> +
>> +	if (!pmd_table(pmd))
>> +		goto out;
>> +
>> +	lazy_mmu_mode_enable();
>> +	__try_collapse_pmd(pmdp, pmd, addr);
>> +	lazy_mmu_mode_disable();
>> +
>> +out:
>> +	mutex_unlock(&pgtable_split_lock);
>> +}
>> +
>>  int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
>>  {
>>  	int ret;
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index eaefdf90b0d5..11e0b60264c3 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -200,6 +200,13 @@ static int change_memory_common(unsigned long addr, int numpages,
>>  			if (ret)
>>  				return ret;
>>  		}
>
>The loop here in the unchanged code, calls __change_memory_common() for each
>PAGE_SIZE page in the linear alias. Perhaps it should be area->page_order aware?
>That way, if we are changing the permissions of the whole 2M chunk of vmalloc
>space and it's backed by a 2M page, then we won't split the mapping to PTEs in
>the linear map. Similarly, if we are changing permissions on a sub-region of the
>2M area, we might be able to split only as far as contpte and still have some
>performance benefit?
>

This is out of scope of execmem (as you noted we are mostly changing permision
for only a part of the block) but your sugestion seems to be valid for other
cases.

>> +		/*
>> +		 * When setting a read-only flag on the linear region, the memory
>> +		 * may have been backed by a PMD before being split. Try to
>> +		 * collapse it back into a PMD to restore huge page performance.
>> +		 */
>> +		if (pgprot_val(set_mask) == PTE_RDONLY && area->flags & VM_ALLOW_HUGE_VMAP)
>> +			try_collapse_kernel_pmd((u64)page_address(area->pages[0]));
>
>try_collapse_kernel_pmd() requires a PMD-aligned address. VM_ALLOW_HUGE_VMAP
>doesn't guarrantee that - it only says that it's _allowed_ to be huge (and 64K
>would still be huge). vmalloc may have failed to allocate a PMD-sized page and
>reverted to something smaller (64K contpte or 4K). You need to look at
>area->page_order, I think.
>
Agree.

>You're only calling this for the linear alias. Don't you want to call it for the
>vmalloc range too? I assume the module text executes using the vmalloc address
>so you'd want it mapped by a single PMD for best performance?
>

I think it is a good idea to have them both (linear alias and vmalloc area)
mapped as PMD. 

>But in general, I don't really like the idea of special-casing a collapse to pmd
>here for just execmem. I think we should either investigate a general purpose
>collapse mechanism or execmem should have extra hooks added to request specific
>collapse.>

>Thanks,
>Ryan
>
>
>>  	}
>>
>>  	/*
>


I will rethink this based on your suggestion and try to properly fix the
concurrency issues.

I am also wondering if we should avoid splitting linear aliases altogether. 
I think I understand why it was done originally (to restrict writing through
linear mapping aliases for read-only vmalloc areas). However, it is not 
necessary to make them writable when the vmalloc area is writable. Maybe 
we should create a special case for execmem to prevent this. WDYT?

Thank you for the review,
Adrian



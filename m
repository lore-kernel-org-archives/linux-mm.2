Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6743E606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUIMehYn
Received: by kanga.kvack.org (Postfix)
	id 729226B05B4; Mon, 16 Nov 2026 09:38:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700156B05B5; Mon, 16 Nov 2026 09:38:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2196B05B6; Mon, 16 Nov 2026 09:38:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 297D16B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:38:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2762120121
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:38:35 +0000 (UTC)
X-FDA: 85441238190.05.371642E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CAD7BC0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:38:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUIMehYn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794839914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuZbrEms8/XjVfQuEiWI77RY5HstSttO4i4AHQMMfTc=;
	b=au8QiYbXZyU51nDawgJJ/2H0okKrQtJaY2U8PXgHf3tyWlWKHtzNgeYUf5zRdDMGDxRNKm
	Sb8oYxdUzfYC7RWroioTd5v71cwALekPqZAyu3g6sCm4ZXlwr0SprJyVTEsWxVZiA1NQHR
	rKB5K1ogVhwOSCEB1AxYZdrWyX/hA1c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SUIMehYn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794839914;
	b=vWDCLoyZ4V/lAPSTEiDRHJCNE4ofnwsf4flQCc5WFe4Xcj+0rhGHho4+L9tmDu7wZSFZet
	kdVl8EB8tG6l/DQhYB0oxexceDEGKZFSSMvM1Xp7M/cvk71jBtjxbSPqtrn6xGZ3gk1SbD
	K+58Tlh2llJ3XdlTs9/2MtC+N1QmDGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 023CD407CC;
	Mon, 16 Nov 2026 14:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4A61F000C5;
	Mon, 16 Nov 2026 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794839912;
	bh=LuZbrEms8/XjVfQuEiWI77RY5HstSttO4i4AHQMMfTc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SUIMehYnz+NkUe0s2KVDqKyd60bR9BnVVKhVRKxgUTq24AJFSodw6eK+Vn7iSNqB9
	 17mHZrB0TFnYq1Ka3dPkUDWrLOyKFdNgUT2fPUkmOujGS+6Zadkn0ReXMB8AFsj1zC
	 h3qWLOnwIIpEFujVi8NKJIzw6UMpUcI0RWu+ogFDlwh2cqrt/fePQtDrcohX9d2QQq
	 +r6SwrPXbN1mL/8Jx+j2n/YKQ3qdkiPOYHAe2l0jR4SN8KLBgImGZIQ3jTh4lPKbRU
	 ZCGuM7VZwsht7BN4YjxY1QKsdOAfGB112ToEvM0u/nMhIrpJsZzoxyK/Pqu+7wL0XC
	 z21YKetd2m2uw==
Message-ID: <c32e4671-e785-400a-973a-7f973af08e2b@kernel.org>
Date: Mon, 16 Nov 2026 15:38:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: flush dirty file PMDs before removing
 rmap
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Will Deacon <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jan Kara <jack@suse.cz>, Ross Zwisler <zwisler@kernel.org>,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261113-dirty_file_pmd-v1-1-8c11f2a2e65f@kernel.org>
 <avrxOt_GyXLXNqtR@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avrxOt_GyXLXNqtR@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CAD7BC0003
X-Stat-Signature: 1pxadryuynhzx1aymuo8e33gqmr89abz
X-Rspam-User: 
X-HE-Tag: 1794839913-937629
X-HE-Meta: U2FsdGVkX191NoNvtvZ0yR9DzHni+Nd+KjyZloKlSbhcVQf3xEK+nUeyPrvLOauo3Cr+2fFXVB00EWDrF8BBV/cYoc/+qKmynbpJitSl6BY0LtfOb0C5QGG/zNqJSo+Rb1uSwegFQrfKLPPgqzEUMZEjccyFl4WbWOUA6JdrkBDn+hZhSo52VA6pR3pn2Q8sjNuQcQ2aBH94i9qdJZ9cZh+Gs6EofNtG/FjmWyE8miGoLjK+OEm2LR2ceO8BnfYEOmjC4xHbRMbXRvMNsnYFFgL+TW/0w63ZzTa7dH4agMhCA2ZUeNFpmy1KTCvMg2tWtDP/CEqL1h1e2mFiyVxr8JAVDVQYqdN4P5RE1s/F0p1RbgtS1MHsduMa4y7lqzSmMVVNnhlycihILMtHSfJPiNVoOL/rpRExaFL8AOwiNgWKhnggCWL9RRL08AIlrGaE8XnIvbs3w6yViDMm53CvGQBUM4KMJ1ymfHPdYaUTo0e6zj5plHVA1xjgfCM/RG42aV/4HnPkD1+plrQEQ94eie/BXlJ8tRWt72d1y4uupMKdfESa77DisdIFTd2XAleC2qg1Nn9JmT990YZ8Aw4UUZLrmdSpVJos7WHStNNBwE2VUJ6blPz4exRQeOirkfH/62lYAJSI+ICJXLZO0RnARSUr48XSqBomQB6JM3za+UdSWncZKGfwHoIdR9KtZVRl9YD9riO9414ZeU5KW0HMWxoZEQXPkLk6Uy2gcBRr/DxADEO92Ahpy0xsGlKeJDQNSTRhwMyK7ubgaHtOH1UTLfvdNlOin/5Wnc4LgqxueGdOA5kJ/RgxM5HhXIgqKW3CIza1xkIDZtXQ79F0WMCSJrEtPlGuGTmHiVDJmXKHpjqU0yDPybJvKNhD61c6XuTOBxZwBSVSazRP2dm3CX44VeP1FRCdPv801P+rDCkItGf9CMaZi9yRoJltvLH4iM7Fq//vxZE9TGQkgG86zaO
 fqZ2GnvH
 23mYSEEln5uLvqA6bfcnIM7ZITGgue7WbbaTNutPFacVllDbq/1EJ/18vMS1LPuF8YWxKXdIw8yn/CI+OFtCh1chtfEIfEm0mr2M/Xjc2joVfOBJ2aklmhu1GFnan5B1gIXcGzRbwK4D18jdsgyT/mN8tcnQbibDgO8ZU/2adZ7g71tb58V5ottXd1TT51ZslN6kixFzQsTi/PjiaBLhLdwuLw4f2oA6AC7KG8WhNfvE8iac03PkRmzP8hg6K1rw5sVgaJqFUTctl5+FytorP44uoo8N8rcX5Mvc0+RMZDfZvDjT7wnjhMn8Sfs/jqRkBDJJMfA+Qs3te0zDuYizYQZjvlu3+eWug72eqaCPOOhF5GoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 13:25, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 13, 2026 at 06:15:26PM +0100, David Hildenbrand (Arm) wrote:
>> Unmapping a file PMD can lose concurrent stores when it races with
>> writeback. zap_huge_pmd() removes rmap and drops the PMD lock before the
>> gather flushes the TLB. Writeback can then clean the folio while another
>> CPU can still write through a stale writable TLB entry. Those stores do
>> not fault and dirty the folio again. Filesystem DAX has the same problem
>> with its dirty tags.
>>
>> Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
>> has been flushed") fixed the same race for PTEs by adding delayed rmap
>> removal to the mmu_gather infrastructure. The PMD path still removes
>> rmap before flushing.
>>
>> Flush the TLB under the PMD lock before removing rmap for dirty file
>> PMDs. Skip the early flush at address-space teardown, when no users
>> remain, and for mappings without writeback, including shmem and device
>> DAX.
>>
>> Use tlb_can_delay_rmap() to share the PTE path's architecture checks.
>> On s390, clearing the entry already handles TLB synchronization, and
>> __tlb_remove_page_size() immediately drops the mapping reference, so
>> rmap must be removed first. UP cannot have concurrent stores from
>> another CPU while holding the page table lock. Make the predicate
>> side-effect-free and set the gather's delayed_rmap flag when an entry
>> is actually queued for delayed rmap removal.
>>
>> Queue the folio before the early flush, while the gather still has a
>> valid range. Keep batching references and drain a full batch only after
>> dropping the PMD lock. The early flush resets the gather's TLB state,
>> so draining the batch does not flush that range again.
>>
>> Although writing to files through mmap is generally discouraged,
>> unmapping such mappings may become slower: each dirty file PMD now
>> requires a TLB flush under the PMD lock. Future work should properly
>> extend the delayed-rmap machinery to PMDs and hold the PMD spinlock
>> across multiple entries, so their TLB invalidations and rmap removals
>> can be batched.
>>
>> Fixes: 4b4bb46d00b3 ("dax: clear dirty entry tags on cache flush")
>> Cc: stable@vger.kernel.org
>> Reported-by: Kiryl Shutsemau <kas@kernel.org>
>> Link: https://lore.kernel.org/linux-mm/aoWw_iKEDLjKL2jr@thinkstation/
>> Reported-by: Chris Mason <mason@kernel.org>
>> Suggested-by: Lance Yang <lance.yang@linux.dev>
>> Suggested-by: Usama Arif <usama.arif@linux.dev>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  include/asm-generic/tlb.h | 10 +++-------
>>  mm/huge_memory.c          | 38 ++++++++++++++++++++++++++++++--------
>>  mm/memory.c               |  2 +-
>>  mm/mmu_gather.c           |  2 ++
>>  4 files changed, 36 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
>> index 4bba02fd5d543..2dcf4ce0de589 100644
>> --- a/include/asm-generic/tlb.h
>> +++ b/include/asm-generic/tlb.h
>> @@ -250,11 +250,7 @@ bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
>>  		unsigned int nr_pages, bool delay_rmap);
>>
>>  #ifdef CONFIG_SMP
>> -/*
>> - * This both sets 'delayed_rmap', and returns true. It would be an inline
>> - * function, except we define it before the 'struct mmu_gather'.
>> - */
>> -#define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
>> +#define tlb_can_delay_rmap() (true)
>>  extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
>>  #endif
>>
>> @@ -267,8 +263,8 @@ extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
>>   * remote TLBs to flush and is not preemptible due to this
>>   * all happening under the page table lock.
>>   */
>> -#ifndef tlb_delay_rmap
>> -#define tlb_delay_rmap(tlb) (false)
>> +#ifndef tlb_can_delay_rmap
>> +#define tlb_can_delay_rmap() (false)
>>  static inline void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
>>  #endif
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 7791872f14af7..600a68a54ecf8 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2508,10 +2508,12 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>>  	mm_dec_nr_ptes(mm);
>>  }
>>
>> -static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>> -		pmd_t pmdval, struct folio *folio, bool is_present)
>> +static void zap_huge_pmd_folio(struct mmu_gather *tlb, struct vm_area_struct *vma,
>> +		pmd_t pmdval, struct folio *folio, bool is_present, bool *force_flush)
>>  {
>>  	const bool is_device_private = pmd_is_device_private_entry(pmdval);
>> +	struct mm_struct *mm = tlb->mm;
>> +	bool delay_rmap = false;
>>
>>  	if (folio_test_anon(folio)) {
>>  		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
>> @@ -2519,23 +2521,41 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>>  		add_mm_counter(mm, mm_counter_file(folio),
>>  			       -HPAGE_PMD_NR);
>>
>> -		if (is_present && pmd_dirty(pmdval))
>> +		if (is_present && pmd_dirty(pmdval)) {
>>  			folio_mark_dirty(folio);
>> +			/*
>> +			 * Remove rmap after the TLB flush if other CPUs could
>> +			 * still write to a mapping that supports writeback.
>> +			 */
>> +			if (!tlb->fullmm && vma->vm_file &&
>> +			    mapping_can_writeback(vma->vm_file->f_mapping))
>> +				delay_rmap = tlb_can_delay_rmap();
> 
> Claude flagged an issue here - for UP arches this is false, so
> zap_huge_pmd_folio() doesn't flush under the PMD lock or defer the rmap removal.

Yes, and that's a preexisting issue in the PTE case. Let me dig.

-- 
Cheers,

David


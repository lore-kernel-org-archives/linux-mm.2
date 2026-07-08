Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C14DC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 15:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088B86B0005; Wed,  8 Jul 2026 11:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011586B0088; Wed,  8 Jul 2026 11:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CF66B008A; Wed,  8 Jul 2026 11:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA0E86B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:27:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FA19C0558
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:27:16 +0000 (UTC)
X-FDA: 84965988072.26.708422F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7DF7620005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:27:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DtIuHDz4;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783524434;
	b=yqucLQgD/5NqmXmT4b16dZ/orqdebUpkKTP4245ecPGfMttyk89svypsGc7p5rYtPnqsiX
	zElu7LlIjUtVqmX3B74qsiH9FSOdxylVj3zflkdYtcKlsxeMEIBw/bHPxsJRXdVcsWVi6H
	huEkVZIo2VGs5iYIjX1rk1RUGaS65M8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DtIuHDz4;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783524434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6H66oQKu4+AFEkauauvVyBVXr6c/W/wZzKm2MLUgm4=;
	b=HkWSm/M8uG0424A2aRfywe37oE6ZEtqf41FFLo1uZAlRD3ZeCJZl2NCfihxtHxjS4ZhQlG
	aMAw4371KQ9K3DLV5Zk34fpcL+uVtZ/w62tX0fIaZHwfZPsiq42jZtp/SqoTCKUri8MHV8
	2PsNIlgT8gPNKTqNxg4rZwJvhGTFMOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11BF160008;
	Wed,  8 Jul 2026 15:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B15E1F000E9;
	Wed,  8 Jul 2026 15:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783524433;
	bh=d6H66oQKu4+AFEkauauvVyBVXr6c/W/wZzKm2MLUgm4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DtIuHDz4q0OKUO3gPfm+8lKay5WivKisN0Dk+GKdB+UTpg5Pz33kxFgwvsHFF/nGL
	 UL2svqSefT97edjrbE5kQ/YY+6/rMImYYNuijAP+WzCZRgvYz9kCq+AtPEmFScgG7Y
	 OyForKqp9VdK7e5vGLiqgp6C4XqNeXwuh9LhUCO4iyYNg4lEzWkbmRXSq18+4jchgP
	 0/QEIH+VgPg4ZB4qqmh8st4tNNOlw1wwG6zFDuk2AfcEbsIdtnzC7z3JzQQL8FXW63
	 ec/Ojr+zZqSP4tUgyuqthZahTLLNfSGiGWtJSg1J6Pm09iivlMbrPsVPg/SvUcQCf4
	 4iXpqwdmoaeJQ==
Message-ID: <521fbaf3-ea07-4794-8bec-ac12020e04d7@kernel.org>
Date: Wed, 8 Jul 2026 17:27:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] x86/mm: stop marking page tables as
 MIX_SECTION_INFO
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
 linux-s390@vger.kernel.org
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-6-156ce4986598@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708-bootmem_info_part2-v1-6-156ce4986598@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7DF7620005
X-Stat-Signature: c4utfhgqcmrtnws4yj3mdjjqqme6d1yk
X-HE-Tag: 1783524434-71184
X-HE-Meta: U2FsdGVkX18wp35WCJMhMf2tZWnOXOvSOw1Jb2c3CIFXYidF+KKC5i03djgsc4f2Pe+0EaiWUA3SG4pT/6yB2+BA6M/hIGIqfauViG1pBJFrHLNqY6TgNQVYaZiLsuFCe8QfcpKyPxhvFcRta10gLcLUZX0PT4ejdBsnc+f0+6SVizJgjuo6fQVfWgEgirYP+VRbbierOp7e+m8xExOjLKmRUHdEgeMZjTMz3I8lLpGz9itARk+rFUzJIiJSyqkvcZia8OfDrOd0ehiuyGPy3dz17tVhkqLTbmfKJ65lWBaywB7fVk2xisT/3Jonf7DwLTQlvrS5xQ1w5CsmyZBWKxImPR5K0w63SzoW4hvyitSve3TzxKmOyaJGRmL1QN7j+f+INqhqpSAn7JmC2MDewgts6ICXdy3KMrN8PRYfpBnAkjylLe1i3HJ1jEwfL+YJhU89NS3s2CxbwGD7ZgnYQQUNK5sFDusYhFGpEgfR3Xdu0yljCEhfEk2iyh1GY9N2xD7n9Gr8bsXXY1dX8VxPA31xb/8qwVczDEuFaq2E3ApZxqKkvPrMbTTLehKEeRUUx3jmuoi40C1Fb8Np6kraZ8hyy/A1EBD/0T6e/WFlObImCAI1oY8bwj+Gq0No0fJhfzfiYitKRDMfpPvjJkUv/IGIHis4NwJvwIPQhGUg3uQkhA2d3PeeF0oGH/OWCW4xxakAhJRdY3UYNgqxQKYiQcigja2Vqok1/VQZJUsCru9ZlYy75tjUJH0F34HrEUNrfS8fNoDIt3vih8jiJRKMDvx8yBQEcGb4SUH4CG4ztv4HzaDObxtyv5SzFEtWeLXpQc//FitlUKszguz6V7NrD9DWl+pDC3Us2VilmhaQNEs3TmNmw5eByiq9KxLWSdbGW0gUJhRwxOcPKEc5Q5PBEdXewNmvLb93KFmThY7a7a9VswD47MmXFqGFNu0b1gJDXwyvImdukqPyG9odzHb
 tfOm1nXO
 HqNWw2I5ebV7RZmfvtV+3J/BAUh4nDBQ1Bbs/8PK481JpXFCeOCJ50debMHo6VEtIjQH2lP75r/nnYooLL/Pj4fUUkgaYUi3BVz4XfwGrWMSTDwcEqFNEJ1SZaTgsBrLpTT3j5cGqNs53Xm/vQU3P+caGncpL2OmRgjjX5cTz3gcv6xTy4lOkMTIkiEH55Pf/UV8ULrPYRpbFqeC/xLo7R48pwbyRtjqAvbjP1wQvJkxrSS5LOxsCoiKXwZmn4o5RkP+bfFPAFvOYn6GxsMpG7h6Gx+DILi/0NrQJs/C2yPIGI7cYGNvDSLhYwtQRd19KcRcP8bsnlqXnZmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 16:11, David Hildenbrand (Arm) wrote:
> There is no good reason to mark boot page tables as MIX_SECTION_INFO: we
> only free boot page tables when they are completely empty, and memory
> offlining/hotunplug doesn't benefit from it in any way.
> 
> So just stop marking page tables as MIX_SECTION_INFO. In
> free_pagetable(), we can now simply free reserved pages directly.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/x86/mm/init_64.c | 59 ++-------------------------------------------------
>  1 file changed, 2 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 82bb0384b8ab0..1b17dcf781e66 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1002,21 +1002,10 @@ int arch_add_memory(int nid, u64 start, u64 size,
>  
>  static void __meminit free_pagetable(struct page *page)
>  {
> -	/* bootmem page has reserved flag */
> -	if (PageReserved(page)) {
> -#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
> -		enum bootmem_type type = bootmem_type(page);
> -
> -		if (type == MIX_SECTION_INFO)
> -			put_page_bootmem(page);
> -		else
> -			free_reserved_page(page);
> -#else
> +	if (PageReserved(page))
>  		free_reserved_page(page);
> -#endif
> -	} else {
> +	else
>  		pagetable_free(page_ptdesc(page));
> -	}
>  }
>  
>  static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
> @@ -1579,50 +1568,6 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
>  void register_page_bootmem_memmap(unsigned long section_nr,
>  				  struct page *start_page, unsigned long nr_pages)
>  {
> -	unsigned long addr = (unsigned long)start_page;
> -	unsigned long end = (unsigned long)(start_page + nr_pages);
> -	unsigned long next;
> -	pgd_t *pgd;
> -	p4d_t *p4d;
> -	pud_t *pud;
> -	pmd_t *pmd;
> -
> -	for (; addr < end; addr = next) {
> -		pgd = pgd_offset_k(addr);
> -		if (pgd_none(*pgd)) {
> -			next = (addr + PAGE_SIZE) & PAGE_MASK;
> -			continue;
> -		}
> -		get_page_bootmem(section_nr, pgd_page(*pgd), MIX_SECTION_INFO);
> -
> -		p4d = p4d_offset(pgd, addr);
> -		if (p4d_none(*p4d)) {
> -			next = (addr + PAGE_SIZE) & PAGE_MASK;
> -			continue;
> -		}
> -		get_page_bootmem(section_nr, p4d_page(*p4d), MIX_SECTION_INFO);
> -
> -		pud = pud_offset(p4d, addr);
> -		if (pud_none(*pud)) {
> -			next = (addr + PAGE_SIZE) & PAGE_MASK;
> -			continue;
> -		}
> -		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
> -
> -		pmd = pmd_offset(pud, addr);
> -		if (pmd_none(*pmd)) {
> -			next = (addr + PAGE_SIZE) & PAGE_MASK;
> -			continue;
> -		}
> -
> -		if (!boot_cpu_has(X86_FEATURE_PSE) || !pmd_leaf(*pmd)) {
> -			next = (addr + PAGE_SIZE) & PAGE_MASK;
> -			get_page_bootmem(section_nr, pmd_page(*pmd),
> -					 MIX_SECTION_INFO);
> -		} else {
> -			next = pmd_addr_end(addr, end);
> -		}
> -	}
>  }
>  #endif
>  
> 

Sashiko being rather useless:

New issues:
- [Low] The patch leaves the entire bootmem_info infrastructure as dead code
without removing it.

-> It's not aware of other patches in the series? Surprising.


Pre-existing issues:
- [High] Kernel page table pages and vmemmap pages are freed to the buddy
allocator before their parent entries are cleared and before the TLB is flushed,
creating a dangling pointer window.

-> Reported two times in previous patches and I will not fix that.


-- 
Cheers,

David


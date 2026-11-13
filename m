Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E549606EB45
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H2qrb7Rp
Received: by kanga.kvack.org (Postfix)
	id AECAF6B05B9; Fri, 13 Nov 2026 10:06:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A850C6B05BA; Fri, 13 Nov 2026 10:06:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974776B05BB; Fri, 13 Nov 2026 10:06:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 710066B05B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:06:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0254D1602F1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:06:49 +0000 (UTC)
X-FDA: 85430422980.12.9234EAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 39B0E140003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:06:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H2qrb7Rp;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794582408;
	b=wRfjXUyQsCMg3UjQ7SHNuqNDFMsRZLGSevvwEl6czAX0jQRebQWtuoWvxu+52GIyvoyckZ
	ZSn6C4EckKS0YZFNcpmbjDhA43Z2vbRipATejbiRz1cajjO/uYU4p7z2Ak7DXt6C9OJ58z
	cGnEwjUDobMa76hXzUw6+Mc/rq2aZbs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H2qrb7Rp;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794582408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8CAID1ghut0Mz9KCvy4wmmXQMXhDupoD4LdqfioSZU=;
	b=uD0EI+HY1ORv6m7qBua62vKHWpY92g6ZuB6AQdWAchdlHMkoqAXplFAl7wnfhIZeb/kbAj
	rmP9pZjxTRuYA2vKYCH6m6WAzxDmNLZca/t2MPTsqyOIIUpTxEzO1I9R5y7uaoDCxaprt7
	HPk+qfM4Htk/2buT6HRi+X6gD4jV71o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65BB242389;
	Fri, 13 Nov 2026 15:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDF51F000C4;
	Fri, 13 Nov 2026 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794582407;
	bh=D8CAID1ghut0Mz9KCvy4wmmXQMXhDupoD4LdqfioSZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H2qrb7Rpd2r+cC4CaEtlaiTSlfIPhvlmkvqkSxsrfLBKEv87ZIbv5camVEplogWCH
	 4C1Fkwjrzi5iHrDnQ/ipXSSy4npS9M/dyFiKIAZhVZU93LufHbQWL4qYfY/NrcMwA2
	 HNhexJwbr5tR2/BY34bADOnB6Fxh5jUFZRIdW5uokP1/cXyBLOshfN1EGY+iYqBxeA
	 8UwsUQLbH9D84lSPYVny9RBnMaoiK1WOsIpbro6uhE0cRvxBkqmt8DXAJhWzTtSGHk
	 150BUC6aY0tAE1xYfuGOqomLuK/mNQqsOv63n+N911YEQ/qLiF4gFpO3b1LjoGM+wP
	 U6OPJu7ZDnpng==
Message-ID: <0825ce63-da12-41c5-956a-039080f53571@kernel.org>
Date: Fri, 13 Nov 2026 16:06:36 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/huge_memory: use the large-page PAT encoding
 for huge pfn mappings
To: Eliav Farber <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, William Kucharski <william.kucharski@linux.dev>,
 Vishal Moola <vishal.moola@gmail.com>, Alex Williamson <alex@shazbot.org>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261112051440.16140-1-farbere@amazon.com>
 <20261112051440.16140-5-farbere@amazon.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112051440.16140-5-farbere@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 39B0E140003
X-Stat-Signature: waodyu67wd1twe3zkjanz3wcw9t9ea47
X-Rspam-User: 
X-HE-Tag: 1794582408-880582
X-HE-Meta: U2FsdGVkX1/Ys7C7MEGF8TZuAodGgEwfBP+5GU1kVG/LZX10cGXjrSreQEIqwL87XWoUG+R+hyH4G4Nx7Ng0TNn2t0OfkZATQD9NfLM+69o5G9xBxP89RPYs62khDMbQ4BfSU9MuC8LfgaKKRiOgZR/jvUfYVFfDT3SHI5pdqGiz81tKJz5/d7r2jWRseEpbQJhygrMImCdtgHC2I/7b1ef7VsWl2ZgSrHqGtp4Df1kcpgmscVJ1zZFYTtsrT23sASXMTX4XzfI+sbwKDmTENxYxNQ63IhpYwNOEuHK6bbCFnBmSGMscUfZoQerDHPkqkdALGPjxykZLNi9Sd4nKxnttlC1SFwNLWdBSiQyxdcDAEeKq9MAhipKFuayFqLQ6GnGYgzYqSj4N7DOMfxWlYov0dLSzFuk3PTXIriHMxH+rlZ4d7GqgOsJ5/J9ZBFWNNbIBcafND09tOeHOB3oDa9yaS5JXTg6d4ju0saM71wEP6kMIKi/v05RjgmvqqvDYkhhRDDLsGPs1CibdHr5gxw/R8Dbh3QiKr9YRHd+kgU4dMPTe9cKrBRM25qk6FQBAckpQG335pkDJ39RnXs3KBe60TJRiJimngfGh8dFP3kuyWOjNOkqmSVDQ0X5UL+8uzZGqt8r5xrD0WBLE/mkaP725bFHQ9ibP2H38ZFIXmP1rnBdDQLsguiZbGN/YyvfpBv5tylqtNflJ9o1VRjY8Ajly/3qDbZ+MjUg+wjKs1jeMIHRjikNjNAMwWKycRZ3Pe9uNOBESkGRhyxeDLbdN3dBEkZlxm11QXWZf+l1vJXWUnhXr7eOvhaXCIlkZuZ2uPln1P6ZsltameroggcYHdC319N24LrNgh+MWZZOg2V5RRoiCshs9L42Eczhd1Bi/FLHqVMS827gTfrcKuIZW8tcnyUUZdlIHScTe2oQxog1bHGgrKnD9avh1Qi0htNtz/eakYTRelIHFvCkNsay
 sjJ9LySs
 vVc8DSOnltDDL9xGFSNQAMtmVlfWT5LlBWPjcWC5UIe2mZeaZwYhBv7rhq1jInXeCER1X+zRaGpZkcHpR/X5dUGa5VQ7nnsVIHPESqfWPkPYOXm//b597evB5sCfaZVa9XdEbnPHwlBHrPZtSfRzAnXzyIAleFcxqi51+XUDj0Uj+xbnJL3TtMpG/scG4sqDeiAbMt39L6dlrnLAVUwHLJXwh3HFRm0GfIGwqEPZ4Y5PC11AaGzMmTlnZ2n0gPO57bAUmpROBSknen/TUlbQeP1d7OnL++/JQewiy8FJJpWH6/M2hrPtYa7McDW4OPT8cdOoMfh3hsx1b3Hw5Gs3OJjUhPLeAiLFpUc5S1KHQw9MCrvgvGWteP/o2wb0SB3hBGtI+S+MC8AOh9pUF216g+JAfgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 06:14, Eliav Farber wrote:
> insert_pmd() and insert_pud() build the entry from the pgprot that
> vmf_insert_pfn_pmd()/_pud() took from vma->vm_page_prot and passed
> through pfnmap_setup_cachemode_pfn(). That pgprot carries the PTE-level
> cache mode encoding, but x86 keeps the high PAT bit at bit 7 for a PTE
> (_PAGE_BIT_PAT) and at bit 12 for a PMD or PUD (_PAGE_BIT_PAT_LARGE),
> where bit 7 is _PAGE_PSE.
> 
> A memtype that needs that bit, write-through or write-protect, loses it:
> the cache mode index of the huge entry drops from 4-7 to 0-3. With the
> PAT slots Linux programs, write-through (slot 7) becomes UC (slot 3),
> and write-protect (slot 5) becomes write-combining (slot 1), which loses
> the write protection. The other x86 paths that build a large entry from
> a PTE pgprot convert it first, see populate_pmd() and populate_pud().
> 
> Convert in the two huge pfn paths. Add a generic pgprot_4k_2_large()
> that returns its argument unchanged, so that only architectures which
> encode the levels differently have to define it, and x86's existing
> definition is picked up.
> 
> The folio paths keep using vma->vm_page_prot as is. They map
> struct-page-backed memory, which x86 maps write-back.
> 
> Fixes: 5cad465d7fa6 ("mm: add vmf_insert_pfn_pmd()")
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> ---
> v2: Corrected the second paragraph of the commit message. It said a
>     write-through range ends up write-back; with the PAT slots Linux
>     programs, write-through (slot 7) ends up UC (slot 3) and
>     write-protect (slot 5) ends up write-combining (slot 1).
>     Changed Fixes: from 6857be5fecae to 5cad465d7fa6 ("mm: add
>     vmf_insert_pfn_pmd()"), which is the commit that introduced the
>     unconverted pgprot. Both pointed out by Jose A. Perez de Azpillaga.
>     No code change.
> 
>  arch/x86/include/asm/pgtable_types.h | 2 ++
>  include/linux/pgtable.h              | 9 +++++++++
>  mm/huge_memory.c                     | 4 ++--
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index b1a669e775f4..b1ffd72e47ef 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -497,6 +497,8 @@ static inline pgprotval_t protval_4k_2_large(pgprotval_t val)
>  	return (val & ~(_PAGE_PAT | _PAGE_PAT_LARGE)) |
>  		((val & _PAGE_PAT) << (_PAGE_BIT_PAT_LARGE - _PAGE_BIT_PAT));
>  }
> +
> +#define pgprot_4k_2_large pgprot_4k_2_large
>  static inline pgprot_t pgprot_4k_2_large(pgprot_t pgprot)
>  {
>  	return __pgprot(protval_4k_2_large(pgprot_val(pgprot)));
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 780fe849ff8b..112814d31f0c 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1787,6 +1787,15 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
>  #define pgprot_mhp(prot)	(prot)
>  #endif
>  
> +/*
> + * Convert a pgprot built for a PTE so that it can be used in a PMD or PUD
> + * entry. Only needed on architectures that encode attributes differently
> + * between the levels; elsewhere the pgprot is used as is.
> + */
> +#ifndef pgprot_4k_2_large
> +#define pgprot_4k_2_large(prot)	(prot)
> +#endif
> +
>  #ifdef CONFIG_MMU
>  #ifndef pgprot_modify
>  #define pgprot_modify pgprot_modify
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 052c50dadc48..945d480c1512 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1675,7 +1675,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>  			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
>  		}
>  	} else {
> -		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
> +		entry = pmd_mkhuge(pfn_pmd(fop.pfn, pgprot_4k_2_large(prot)));

What on earth is 4k terminology doing in common code?! :)

-- 
Cheers,

David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37410C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391C86B00DB; Thu, 16 Jul 2026 10:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341756B00DD; Thu, 16 Jul 2026 10:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258ED6B00DE; Thu, 16 Jul 2026 10:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBFA96B00DB
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 725AFA0125
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:35:16 +0000 (UTC)
X-FDA: 84994887432.11.4CD0A8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BB8B82000A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:35:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYlxmFvG;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784212514;
	b=dqkjrUl0EBcFwSTkBucowmMSXa3XfIweYRsMFTdLBJqte8ffbzp81JEsCLlk32jmeHWT+/
	hV8s6xdvEPjdZRVLlzSec3FMTBsQ4P7Xcvn8xK7pNUS5h2KajBfhehi/5vU3BGFWb+Lj2S
	ShxoAczJUoz7qx6jGsMx9O5w7wNF/2Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYlxmFvG;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owL0nd8B/GkhADkuaO+4Eg/4RAiod9IX3PPfyfCcTxk=;
	b=7SPPlA1zJElr5EvYr8PmivK8NU0Q9pb8zzv3lZOZEX8b/+fAWIPgp7T6Q6CsGfIYys0p85
	GwuI0g7yMAEraJcnrjY4LG+dv2N0ZZEh6lfPNkYvxqz0pVtDVgT186W8I8AQcIOJ0CYTSS
	KBQDuNOMnzai5nsVYsLPQQgD6B+BXKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E54084025B;
	Thu, 16 Jul 2026 14:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D751F00A3A;
	Thu, 16 Jul 2026 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784212513;
	bh=owL0nd8B/GkhADkuaO+4Eg/4RAiod9IX3PPfyfCcTxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TYlxmFvGLxHWeT01YkmwxlcgTHqg69p9kYqzkpfVWAyU/yPb54wA0i73F2a96tCJ5
	 LGjAT/oucnWqtZufo0UFt0+B+76fr6OQ3DKvtHsAPZgI4AeEHZs6BCGeizthUniTQo
	 qHp8bxcCi/YnqiiFwp+Rj1lx3ZyUg0FMr9CAAx1uyKaFWytHu84pzRLn4gMuniMeTO
	 I5bd+ZZnWjRJKhr451fMyYjmw983hJvfVYZMiEAStxwRTZ8ncyASF1+PjVX7ipokGa
	 A/7Bu75qciiIuHD9sO7gy1Ft33Jn+OW5xJ8Nz0scRRZ6bt6JNWxFjl+Md+Alc94CTi
	 xMH8O2h0ExKIQ==
Date: Thu, 16 Jul 2026 15:35:01 +0100
From: Will Deacon <will@kernel.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Juergen Gross <jgross@suse.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Peter Xu <peterx@redhat.com>, Luiz Capitulino <luizcap@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rohan McLure <rmclure@linux.ibm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Baoquan He <bhe@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Coiby Xu <coxu@redhat.com>, Dan Williams <djbw@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Rik van Riel <riel@surriel.com>, wangkefeng.wang@huawei.com,
	chenjun102@huawei.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH mm-unstable RFC v4 2/7] arm64/mm: use PTE-level pgprot
 for huge PFN helpers
Message-ID: <aljsFdYEH1CvYhft@willie-the-truck>
References: <20260526145003.88445-1-yintirui@huawei.com>
 <20260526145003.88445-3-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526145003.88445-3-yintirui@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB8B82000A
X-Stat-Signature: dj8sp7wyib6i1xosmoc8je8n1e1r58wk
X-HE-Tag: 1784212514-781189
X-HE-Meta: U2FsdGVkX1/kO/6x6zLU46cTNu41kialSiM28QCdCwMKeCRvDINWw2JBNEOodLmNrGZ1hE+n+jHDFHoIPmldVl37h5x6OiTHR5COGWuN7PgNKZdxl/4XaAKUkKhUAEhJObYlqyxQOAf+26O/cp0tmgH+91FHRlZ3732NWCG8+w8n2yVlsuBtMN5gC4akmYXRqEu6OXTGdxY98Ajnqj47GazWyer9u1+88/8b+LuEFmLBxMGRk/dOHHG9c/RLvEDFTURUP3JpzjUEedkEcbn7ucUn3xPnDLbdvLM8a/f7t0Vgo5fyDrSbd3NOhX4Mv+r++/G/OgEi9DAxpaQAHhZntZTULT3ke/dbWUpria9nV49kQTqkeLxIroOtBsNcdmQTsM4qCx+FNtpl7I58gu2fA5/UX4NPW8pl95+fSF/3UHxr6LrnPLc5ZeLkpA5hdcdOS67sjgJ745jQAfI/kl+ytSIyE8PdpkfCA/AWayw5yU/9wH1T8RsmN1vp9EIk5q7n9r2VVy7oRTiheCSGEnZv3X88r2RCrFd0BB9cpS9CX+vvOyDMuGvpJGnF8xPoYpyj0jDfb17npMXjliEd2PE9UD/RBpPsKEwgKDpA8T0qFKwrHOdvXdIKdfCVeLcB1sx3p2WsbxFNEpASDQeBQLtr7Tp1aBLosA8VF+e+2Emv5VhN/x0bSKrTy9CP9uZ6TaC6ODmT402utNabr13j+ywkAZ9Qww+Pd6X0AnvfobZX3HyGqaVYkxeqeZ9nicHwwUrdjNF1jUbwzZCeAvIwPA1ChWiLCY03jaYxR54J5JRv9JymuD0nS6BDTvjLI1TN5UO26LzpBdSnP0t4A3lAQLbHPyDKJX8KDxt2ASRsOgqLzVrZr/w/+sVqhdZP5scPl1dc6Fsby1TdZ7MWiSNtdkvoeVLNp7OOnJJUiXFQ5a5ijLdjICkYH+NJgsZm5oaqL9Iehl8rKGYZ2zJaZKeg4/i
 7c/Schhk
 hhnjxM2e1ELUHJFJIFZlzEmKA+0Ph1MbzhUwKek9II2nCmRs6zhhxVcU8JSDr7m1Tsvh3UYq+dkLHoNxN3baj+Ay1WtQ74fPb6l7WFYa0IpUWMuJPVrH4sM1GPfod6xrXOIgqDSHIZI7hQCWrxsEWe/Z/PLa15g/9hU/oJYDzhwL8f1OXAWwDpcY1e94VKrVv0sj9UXJsDufMIl141WjEi+kyZbXKaAC4UYWc0Iu0C98H3fVxACB4hs01Et+yLesyOgyU7VbapUq1L574DgiL8QpUyamKTRLrlEf5A6s6MJPy5Z06Lw0EUqYm305N2bWShx30CxWsJ3fhQef4TrDXgMp1VzTx/YcKa/kmHe/6cdpxOYVFw1O3FsIrIuHzxfBWnY1FoDdXwNks132O4L0aKsAGog9tyYJls3U7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 10:49:58PM +0800, Yin Tirui wrote:
> Make the arm64 PMD/PUD PFN helpers use PTE-level pgprot_t as the basic
> format.
> 
> pfn_pmd() and pfn_pud() now translate PTE-level attributes into block
> entries. pmd_pgprot() and pud_pgprot() translate block descriptor
> attributes back into PTE-level attributes.
> 
> Remove mk_pmd_sect_prot() and mk_pud_sect_prot().
> 
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 48 ++++++++++++++++++++++----------
>  arch/arm64/mm/mmu.c              |  4 +--
>  2 files changed, 36 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 4dfa42b7d053..c3ee12e14f86 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -511,16 +511,6 @@ static inline pmd_t pte_pmd(pte_t pte)
>  	return __pmd(pte_val(pte));
>  }
>  
> -static inline pgprot_t mk_pud_sect_prot(pgprot_t prot)
> -{
> -	return __pgprot((pgprot_val(prot) & ~PUD_TYPE_MASK) | PUD_TYPE_SECT);
> -}
> -
> -static inline pgprot_t mk_pmd_sect_prot(pgprot_t prot)
> -{
> -	return __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
> -}
> -
>  static inline pte_t pte_swp_mkexclusive(pte_t pte)
>  {
>  	return set_pte_bit(pte, __pgprot(PTE_SWP_EXCLUSIVE));
> @@ -628,7 +618,13 @@ static inline pmd_t pmd_mkspecial(pmd_t pmd)
>  #define __pmd_to_phys(pmd)	__pte_to_phys(pmd_pte(pmd))
>  #define __phys_to_pmd_val(phys)	__phys_to_pte_val(phys)
>  #define pmd_pfn(pmd)		((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT)
> -#define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
> +static inline pmd_t pfn_pmd(unsigned long pfn, pgprot_t prot)
> +{
> +	pmd_t pmd = __pmd(__phys_to_pmd_val((phys_addr_t)pfn << PAGE_SHIFT) |
> +			  pgprot_val(prot));
> +
> +	return pmd_mkhuge(pmd);
> +}

There's a slight potential difference in behaviour here, in that the old
mk_pXd_sect_prot() helpers would always return a pgprot_t with the valid
bit set, whereas pXd_mkhuge() preserve it from the input prot.

I couldn't find any places that cared about this, though, so:

Acked-by: Will Deacon <will@kernel.org>

Will


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 125B1FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793676B008C; Tue, 28 Apr 2026 03:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743C86B0092; Tue, 28 Apr 2026 03:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632BA6B0093; Tue, 28 Apr 2026 03:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2C16B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:31:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1AC711B95AC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:31:33 +0000 (UTC)
X-FDA: 84707144466.03.59025D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CEBBC4000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:31:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CVnvaBDj;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777361491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMWWXBt0H8FUH6gYap1afdCvnPjjFas3H4vg06N54js=;
	b=0Mds4420EeVa7So9M2gDFIbCUkI+sqBErmmXpywQJddRQcpiTr8SDAcQgzTs5Ueyo4pC8S
	1TWwiFSAPbg8rdeYUYEZcMHZyQ43cy56Xs8OOn6llw9+/2NStV7eyQcGezmPV5bpvkdJG3
	Go0Hs/Y5G5/9seV7OsYpiNgQH2IYr1Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CVnvaBDj;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777361491; a=rsa-sha256;
	cv=none;
	b=XXy9DE/0qrlKLwIVIrROeymVsHt0aqBOFaOsCE+iLhiX6DTJOV52fIg5aqqI3iTLq8bPat
	bzndEJWp60q9vbl3TBix8v+nKrdhKb7Jw2mTGhk3o2oJDj8rUKkkjlrebgexTDEEOt9Nzr
	xM2QyFSj92oIhbFoKl1tiZuuYQkr+4M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8116840026;
	Tue, 28 Apr 2026 07:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E87C2BCAF;
	Tue, 28 Apr 2026 07:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777361488;
	bh=xV2f8Ehs2QX5rw4Q715j9yMyngPX6sqnJ8NY9F+asyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CVnvaBDjTn1o/2v+QpYU3O6WYRNiAGm6NTsiljZtdtji+vqLHyVPkdVCxi4Iapy7t
	 K7nq9Ja+qgzkDp1c2i9Cl1jy2e3n52hTs0YML53u33P6lUVheDejIwYxxLgcBph/k7
	 UW23Rrs5VQPJrX0E1nR8rRESg1bZVPaAmABbWZcQNpW9cs80rCvI9vARmwviKhHPzr
	 FwAki4R9DE7zxLfsAPqlOV9/xMkksNpCcSYybRwNPmbMv3lA1KHU7kC8wZRE6lkmIX
	 iTSLl1NfNuhTXTvtmJLzoYc2maxXL2mhT1LsUE9fKOFytdhw0gJDZG642O5hI+GJZS
	 uRyV/MwreZrtw==
Date: Tue, 28 Apr 2026 09:31:18 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Chengkaitao <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 08/49] mm: Convert vmemmap_p?d_populate() to static
 functions
Message-ID: <afBiRvBPx4Vm5ECs@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-9-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-9-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CEBBC4000F
X-Stat-Signature: ufezjg6okaq8rjokwq91ukfi8gydrg4e
X-HE-Tag: 1777361490-832271
X-HE-Meta: U2FsdGVkX1+XGeFEckqNoM2Ogf169E3aNd3C0LToHw+zX870pQjkHKhnReTgbCWpo5P10UTpEajUTrQN6FhJCmmiXHYGYO+FJWS36GwYcFGyrn0RWHmZuU2clCSi6OKQQW5drAZQ6ANG3AhmAc3XEih6J5ICMCPtx23FmCwR9C2KwoyfBISf1vph4tQvV+IbPN08Y3MlXY/a00hJt7sFkFWNSM8gFk8zwQ9or0wqDQPRX2nGCXtb3IrzI7Fcl9mwiDj4E0ZfzQqfvn5KBCn32taxWBaMZjWzeM71w3HmVTqbHHhgX77vHsx6V7oxRAVCBBuovxi4HbReu6frQfKQvc/a3M6B6bnT92VRVNv57+SXrdCY4UR2db6AioVoC9RCWwis+WFe4/hxTJl2KHFa/3Xh0Rwri5uJHKzpk1SAFqSUqDnAYKUw+VHF023fg2lwTFEbH4aCfg975oANnL8RpjWkacAYIHCdCXY/XsAjgEJiIPecyD00M+F0Z+4GukwDtLFwN8eJsAyYCv5WH9ulFsjIynrRhBZwjB5m/Q/y+ErgBc85/8QE3/n3GMBDWJofOZkjKjq5fBV49c6PMKD3wEyMe3+rjLyVNZKTK3krKJtwl2GCg6d0yTX425YnxzDydQTSbgNgM/AINlaVlvT/OeKWJ/VyRd42cszP3aHuQsa8MCyeZWe0llJFHQYgOIL6QhccfHoHgGkvTZymVMzDK8Qv6jcsPDeNXi/mXZcwbjT6m8iwc9Qw2L7c2YsCrqZCNkXWjuBkwXV6VsHloscZk4T8RTbEqrKBG7eFXPNjkFP0pMsOUXNr0+4omxOB7WN8h+14YqfKLiwyaL9uXGytw2JzBgXHq8ARJ7ymEKx+LxpHmlpZPULV/NY/vRjYhfW1ToconMdExVlSVUx3Qqc1fOvnturBru5lmwPauuPlomsKg7XiACHeB/pYFcjnnIYqi0p1PxDkCzfyklIpyNG
 hJB7tLHg
 T72mrq/ljOVEuLZQDxgemQqHRfc+KQpLIW7hEirjUmBD9EgdTKFNXE41vEX8zU8LPvlicL6XWqB22AvOaGDfokKEe/NbZ9qcgOcJFad+zTjsTJI3TXwM6D3Zgl+aSKEZYKv4h3hdf9XOiVRbIDL5exIO6N3WBNbrWLgoLMkayGioIWhucVRnBp5Zvy88RgtsL6o3J1gB3sKxvp3etzGzC2r6piXHBEdx0JgmKFz6W3T9ptqtRwexBcazGZWOLcHTFRLM5BI6YVLnfuqOBdui8L5CHfsnsJ7bHwgQYAgxm92kSgxyZKCFWs8ZqnZgWh19zQqbhG00/GWPXwI3ZVnrwb7jshN3JUQ4Aw6t7uqYmBkQMKy4xDsN/XgS5DWk7RqJAhwTFkFeLZReJuBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:51:59PM +0800, Muchun Song wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> Since the vmemmap_p?d_populate functions are unused outside the mm
> subsystem, we can remove their external declarations and convert
> them to static functions.

I think this is already merged
 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> ---
>  include/linux/mm.h  |  7 -------
>  mm/sparse-vmemmap.c | 10 +++++-----
>  2 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index bebc5f892f81..aa8c05de7585 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4860,13 +4860,6 @@ unsigned long section_map_size(void);
>  struct page * __populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap);
> -pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
> -p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
> -pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
> -pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
> -pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> -			    struct vmem_altmap *altmap, unsigned long ptpfn,
> -			    unsigned long flags);
>  void *vmemmap_alloc_block(unsigned long size, int node);
>  struct vmem_altmap;
>  void *vmemmap_alloc_block_buf(unsigned long size, int node,
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index d3096de04cc6..0ee03db0b22f 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -151,7 +151,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
>  			start, end - 1);
>  }
>  
> -pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> +static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>  				       struct vmem_altmap *altmap,
>  				       unsigned long ptpfn, unsigned long flags)
>  {
> @@ -195,7 +195,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
>  	return p;
>  }
>  
> -pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
> +static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
>  {
>  	pmd_t *pmd = pmd_offset(pud, addr);
>  	if (pmd_none(*pmd)) {
> @@ -208,7 +208,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
>  	return pmd;
>  }
>  
> -pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
> +static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
>  {
>  	pud_t *pud = pud_offset(p4d, addr);
>  	if (pud_none(*pud)) {
> @@ -221,7 +221,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
>  	return pud;
>  }
>  
> -p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
> +static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>  {
>  	p4d_t *p4d = p4d_offset(pgd, addr);
>  	if (p4d_none(*p4d)) {
> @@ -234,7 +234,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>  	return p4d;
>  }
>  
> -pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
> +static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>  {
>  	pgd_t *pgd = pgd_offset_k(addr);
>  	if (pgd_none(*pgd)) {
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.


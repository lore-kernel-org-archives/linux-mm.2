Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB97CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302266B008A; Wed, 13 May 2026 04:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2826B0096; Wed, 13 May 2026 04:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A326B0098; Wed, 13 May 2026 04:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 064A96B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:39:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0A52160727
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:39:09 +0000 (UTC)
X-FDA: 84761746818.22.D964C7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F063240008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:39:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5o2b94C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fVaLKvJlkGuL0KZ6ciDHgUX0KlxSF3IahtcRNvgMz0=;
	b=FtS2Hq6qpjKgkdyS+HCX65ySDZDHOzVq5JMwQusQeE/h/yscAl6iq5dhdMYdE35UofL2Mr
	C91hzXN/iCuWjSCaTdByaamKrkBIJWVNoo5ddq2l7PhKes8tZh9wTTRSYnXYj0z29nn7FD
	n3I+9lRRnlBK2Sl+Fmt3wFKlqE0Zghk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661548; a=rsa-sha256;
	cv=none;
	b=Pu2iCOp7XNgocyNbWc20RHi6SKuiKjigTs6LJmJYckoWZvFTmn27r+TvBJPPR0eG5mb4QS
	Tt3NzWuW0ihLTPOdXTV2IwTnb2NkKjc4RqbdR3rOQuweHwMm29A90IqdgJKY6Ejis3X0Gc
	VAbLePVyUlRzpNryjluvpdz92BrenBo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5o2b94C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B13DF40545;
	Wed, 13 May 2026 08:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C496EC2BCB7;
	Wed, 13 May 2026 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778661546;
	bh=A+alEkVbDEYYLkoEGrsz9cm8DsNiefv/WIMetnJZ4aA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i5o2b94CuXzH2xo1vE/DUzE4IguK5/np+Jsb57LZ3NB3zL8hSI80f7ACMbgEeHtAP
	 qV9dcRBrrPGWTvrCfK3ozf6Q/Nh4quN4g1L//ckWLJ5IZBF9wcexyyeHeoSRxNtPFH
	 5N9yNX4d6ez9CMAHkKOf9Q8JiXvXQhoxZZdpf8TvK+Byg36ZnOCAuDu9QuNuCfrEwH
	 Qm78NZa6NaXCcHKglUgtQMONd4VPk8qQQ87YzAm64xITK4kwsanSFW8xhr76ovDxnp
	 r4CIUxQc9Mt49yJ2jK7gSCRV3umP23VsjLZA5UF5Ta5xnIWTZ1tKagj3rn4mhxaYzQ
	 HWhG0Vzd8dUdQ==
Date: Wed, 13 May 2026 11:38:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 6/8] mm/bootmem_info: stop marking mem_section_usage as
 MIX_SECTION_INFO
Message-ID: <agQ4oL4pKP0D51gn@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-6-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-6-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F063240008
X-Stat-Signature: y51fag6q1em7ebz3397b6nxn35tr8n6o
X-Rspam-User: 
X-HE-Tag: 1778661547-362955
X-HE-Meta: U2FsdGVkX19IZ8XUnmcT84baSXDTbFQSFUgLmASNhi8RM8bsPe/vxalMHuCKcc1iU8TV5mkCdRIT18YjRKq7nM6aMowrwo0M3GGfa/oXuFWN5B3Y4Qu7doJRsduC/67IHRlkscNUuQCjnCMrxP7/f7hKis3xM8DDyYDsKVCJ6rAqsjCbYMlzRVGHdHIZJ2Sf1z8pCMUEUuToEx/h5WiMgALAV8L91RtCrQvw7afQ0fZhW2O4FHVFQZ//GAZ/UZScDE17UQJ2BqWu9PJT3uUjZUHGigxLt+TipoJ17L9pZQqTRKYOHypoENPchvUjw+SrTfVTPh5rVB9SIPOmH0s6/07SO+3FYEejk2k9L6+ECQV3m9jNQYPkaWmU8FhSvs0tft1/kbBYIgzzt/tzUGgIiUNqvhUVUVbsk6XnCGcoy9mQoW9YrGRMXorlbbc/ISHZscjX6JG2G9hEMzTpBV5B3IVOOG14+gEJS48tJVP2EmeMmagxLg9S1TTy7Jm/5IOsT/dy0CT2kg61p6oURW4PMn+oaxeHgqwHaCJchj0dEca247sZac33WCLzEk+je2Prq7wuJCMm6Rj+DlZaTQwKeG/0IIU9o1isKX3AtkeGvlnQ8Nk2kjNOMisherNgf8oXJ2/BcEN5RU/Ikt2BG8hGV+H306zKIph7W0hznkKgl/bUQYYIOy3tCeILlo2O/+WPPL/N4F7R3QpESpCJbMtlvia+5asXUm4fDIx/Z+7++HIhDN1D8N5Eh9qpnVlfcmecQXLE8daNbX26BJJ6f4mDrp+ZqfGxt8SqINXLNbQdBh/Ak7VE0keUTVncwJjg79mf8sT2AoQZRJbRAPgKZZzP6J1yCbLxuFYNtqEh6ym3ZUABmeLKLydLJd44gwnO+gon2ZIx8jcLY0k6boexxt2ahPSGW8goCFg4Z4mEHpLKWJwGK2SOt0/5lRcDLcZ3maxdKJdjQXyYTbXlubyGFK9
 +rfyn0VR
 mop08USHvZevBVwS1KNKTd1bIAgyz3IdimANLazT2xSWB2mJCmGzNYerbXohRcdyPOaO3aunY2/YDoDRr2SztDo8HOgRerx6B8D1ye3uqIIf7GD5zUzPBaYh4tg0hVYxkGRFAzrV7xpr9jzXyhP8Ugobvsiq0VPLs+JhNfgR9PS5Io/vKBv64jRhpTIzjuXuKDEGLcw5oXML3TB/DwmodK7UhgHjMDpKoxfftmAOXuDxd9SxQw/HPYFrs2oTmMcCbop4xQr+1TvqdVBOb8pn7O4BL1TqFnHhjdbLhbHZsJJp60fxO2ynqpGwkrA4MbfeGxcyxmOnmRaS+4yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:34PM +0200, David Hildenbrand (Arm) wrote:
> We never free the ms->usage data for boot memory sections (see
> section_deactivate()). And to identify whether ms->usage was allocated
> from memblock, we simply identify it by looking at PG_reserved.
> 
> Consequently, there is no need to mark ms->usage as MIX_SECTION_INFO.
> Let's just stop doing that.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/bootmem_info.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index cce1d560f094..0fa78db7fbc0 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -38,10 +38,8 @@ void put_page_bootmem(struct page *page)
>  
>  static void __init register_page_bootmem_info_section(unsigned long start_pfn)
>  {
> -	unsigned long mapsize, section_nr, i;
> +	unsigned long section_nr;
>  	struct mem_section *ms;
> -	struct mem_section_usage *usage;
> -	struct page *page;
>  
>  	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
>  	section_nr = pfn_to_section_nr(start_pfn);
> @@ -50,14 +48,6 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
>  	if (!preinited_vmemmap_section(ms))
>  		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
>  					     PAGES_PER_SECTION);
> -
> -	usage = ms->usage;
> -	page = virt_to_page(usage);
> -
> -	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
> -
> -	for (i = 0; i < mapsize; i++, page++)
> -		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
>  }
>  
>  void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D339D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 21:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF676B0088; Sun, 28 Dec 2025 16:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D6F6B0089; Sun, 28 Dec 2025 16:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6FA96B008A; Sun, 28 Dec 2025 16:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B631C6B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 16:00:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 513541A0100
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:00:49 +0000 (UTC)
X-FDA: 84270099018.15.A99A651
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 86F6020005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:00:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Pz/cWfeG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766955647; a=rsa-sha256;
	cv=none;
	b=MFmsyrtwWrfvLUJSRnANwcQTL2jSSVZnmdMCmlX/kBvpn7ScuQHPElKJlEYkyY2KZ16LfI
	f7Fv8hXSH5NfRnz4iqWg0fKGIAbH/kJoWG8SZWuwyOywYgCeUmJLN3/Bi71Z54LKskUq3c
	xkeZDsiHZ2vjOYFpeyaP/MIlyiSjsNM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Pz/cWfeG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766955647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FL/ttYVsXIfy/l6B8REAWwQ+ehHvYv3s5r8rlHYbqOg=;
	b=QEPKzGF/mPWGOwz7Glxh6bEdn/FwuF7kkK3ivldhU6uNRX/veTK3nPJHj0qOA1UxUw/Avw
	NIgJyAYvWo1tKlJ0w3TpHnyECXo3cfWhufvnmnwY9b4phoLzQ3763dLfSoGyBivlhImaJg
	ccb/DYpzk4AlYssjlB5/3tfDzJWLMyE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3212044393;
	Sun, 28 Dec 2025 21:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC60C4CEFB;
	Sun, 28 Dec 2025 21:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766955646;
	bh=D9/7cYqcpU72WPvnsrQXQKGY0dbbqapVo4LdFuNSb08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pz/cWfeGaOlqPEHlhhXG6Lhj7deT0Ud3PVeSR++oVG9RaxfSe/r9CBg21L+ZJX9fV
	 XD/HLmJ1qAMgMZZTYDr7uAq0zlTAViAAOki//bTr89HHkLv7xq3gHkIgnYIzcXpA9h
	 Rh89PbVbTYFRainlKrNqWQmW5eWLqzSPH58V+EQEeILIaDf+h6mvlnVUnMn/X/fGs7
	 DXfUZNpk8756GqH+F9viNvqnMyWCLIJTML+MJv+/8jnNTUq/bdLQa77F+ZUI4L5Ixf
	 RHzeGLjDaIVdoGo2bNcsobT/N9AjN3ELRmMstIE/hZAxSGtvfmFKnwdhfF1D9lZOlV
	 Ng5tRyZKD/uaA==
Date: Sun, 28 Dec 2025 23:00:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: chengkaitao <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, kevin.brodsky@arm.com, dave.hansen@linux.intel.com,
	ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org,
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 2/3] mm: Convert vmemmap_p?d_populate() to static
 functions
Message-ID: <aVGadJAlS0Z6LLEl@kernel.org>
References: <20251219115812.65855-1-pilgrimtao@gmail.com>
 <20251219115812.65855-3-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219115812.65855-3-pilgrimtao@gmail.com>
X-Rspamd-Queue-Id: 86F6020005
X-Stat-Signature: o73oppqcugwh5ufonatgmdxu7geqqhhs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766955647-421748
X-HE-Meta: U2FsdGVkX189nrcZE/KuUwP0vKLDRr5ir82coZUNxW0ecNQsZN9+F8zUhWDYGJh2FP4unktfS2516MNH668Jd8ALhI+JNSf7n3Cvpcn2XAbLZ3O2C6huSeyv8hZipsZAwdcb6D4N9OzOcT2xr6MhOS8r26shSiseGaz/FQpdCq/IO/G4ZYikZywlGaHhFJ2DzIPbxovOc4h/6r4lPBec+4tJs03IDg6fpihaV0TGZbbqLSgQvjqLPSxV46Ma19lydZJ5LNm7nWhxK2rGDf7Olxn1nsqAqAuk3t1LGh2nkUqUuqcsYCSLrkZPt143QF3f9GqwZeinn7qGOUGSdqV3fzrgNV9RkHIHabEBmquRJ7AsR6xE9YWi0+v7uKgC4w273wDnPudF+cT3j5kAg8gMKoO6Pz5HfF023R9nXQXxkgCA9g3sASpjFmCRMD/qLhRPf2l90JiOqALSwG0rsDfN2uvrGTCq9NOUxlTvo1DjZislXOrS5GdIIlUyATPYY5ecrlsCoBDWWDjHYxP5/dmfl1QtCTd87CoIyRKlfhFxzpDUu0lxTK+d8Ii6kMF2OFciZ7TNGNj6qg3B+9fUdBDJP7SI/eNZJ0CPrsRIllC7N8bf7qeAKHESnsejbBZe0B3sm7dpfXVZS5IyFrdMGw//bqqQoITuxSk0Kd78Klk/xjHJudCXig+LF3YYnYqERdEzIVJfO57UFki6BTqcODe5+do8v4Rf2cQGylbeGuh3EEXTVqUqESQEj3BcDUD0eJdaGg+TgVa0fT3oW5ckg9h3kke8tKviJ2k7b6jNovy4EhJ412bIZVDx+uIf1U2lUSOtsu/ZBPW/m8cUvg/A8+OHaUsJcT9N2iBrDhgOlsCn5xk/usejPriTAEcxKf0sT+0GPJIcYEzGWJZ2aOp+vV7hZNKlvNWmLIyTSBjrecGRZ1rgRouh165oi15D2jvnZUFAF6zAlAKuI474lSF3ZkZ
 Use3pDuT
 krT/yapHEuKCiFELMZgyEqP9TwquHeBA5f5T9pENyb6hdW3tEldI9GuDkPcD8MWWoRm9nzIDPfene6UmjZrdKOxm7VjLsxT5N1D2mn9/bnxsmDJd0Z/FhxqjQ53+OFU3UZdKKVNUmbkLVeYHqcV+BItVe9xYcDei0dsX1bRTSBhX7ZcvnZnlclvFsjAKBi3LK/x0ubB4z3z8XYZPcrNHXnzM5/nnm7R569hKtdgwAiZRe3hN50uEJeRfbK7H7hHijV+dc50bUylINPNBbqKg9hwttoppviQO0dm7Uaby9FBBm7wTNzISiRGPjWY2U144p86HFNM83y1w7nGtZIPUtnL3gouZ2SUYCZmBF1f9GQU25cB3e+n0xsH4Xn/dP+kbGPQn9VMiHBiUr/reg9h96+39jwxi3NdU5sfcC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 07:58:11PM +0800, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> Since the vmemmap_p?d_populate functions are unused outside the mm
> subsystem, we can remove their external declarations and convert
> them to static functions.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h  |  7 -------
>  mm/sparse-vmemmap.c | 10 +++++-----
>  2 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..d98a38a6ac0e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4234,13 +4234,6 @@ unsigned long section_map_size(void);
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
> index 37522d6cb398..67f9a08c2376 100644
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
> 2.50.1 (Apple Git-155)
> 

-- 
Sincerely yours,
Mike.


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982D4C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3FE6B0088; Wed,  8 Jul 2026 07:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894376B008A; Wed,  8 Jul 2026 07:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D34D6B0092; Wed,  8 Jul 2026 07:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50BB86B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:22:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB553168E3E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:22:57 +0000 (UTC)
X-FDA: 84965372394.25.756B779
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8D39010000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:22:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vQCzO3dZ;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNusTgFoYEWtfC3hyq4hueMQRgZDWrjvIb+ueq77QQ0=;
	b=N8Rv/koN12PKFY3N85i24PkKhV9AQO3iA0gH4ojvwr3U6fXL+mmDa2zf9pSoiLQifC22ng
	8oGW47VMP7x/G2bQC0gitHVA5keat5kWD93MDdkZYNg5ZwtX3eY5JHTZKlpTHF4en9DVhS
	3BvG9/6o9DF2cqXupmd7QC2e5dNzWcg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vQCzO3dZ;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509776;
	b=u+FzFWkEAbx3aHaxxfKd2YDu+WgQ+p4havYYBNnd+bN9ENZJEU+O0tmYKxlEHgmQJTLTEy
	xh8zka9yJ439eAtbfeZH8WPGaPV9Kh1hqdvDAif5asTLubHa1Ysanjae5cxnU1zpLs57fk
	CTgDK5i8FpQI8ljDRu7B4JNwIrNXIeU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E80531E5E;
	Wed,  8 Jul 2026 04:22:49 -0700 (PDT)
Received: from [10.1.30.54] (unknown [10.1.30.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 015703F85F;
	Wed,  8 Jul 2026 04:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783509774; bh=WNKx6DA64Vfj+VZ3Aw8GSPXJVs8F2PFjs2bXpy0x2Wk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vQCzO3dZCih/23JdFtak4M2W2HckgEDhkWfTSjXAmV3wJlNuce/sEtUpZEo+Tig+L
	 FGdKxGF4czZDpCHqIzXBH1zWBMucrMC+maILZyfyGpdEjiWNHCSGlM6z1UgNA24vej
	 ixRdQo1teULi/MDW2jKxMgePegRRzurL5dMcC6w4=
Message-ID: <25cde246-540f-4ab4-b541-0b7313c57954@arm.com>
Date: Wed, 8 Jul 2026 12:22:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260708032824.969752-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D39010000A
X-Stat-Signature: ez1nnu8ow9i3nw5kderruu8myeqryo46
X-HE-Tag: 1783509775-734796
X-HE-Meta: U2FsdGVkX1/EhLLuM7dSMOsdcKB6Xg9Ll1xquNmWQzdWRXQeOAuqW7kWYEFy/Evo2zpIBGwpRPV6BgtfttCH9GckjiWh+4dqEzxjwfcyoZfvFf9/9AQ68udMu+qkBMPJ4BCcMWaEqoZwZCYyHrrm/ZASX3pbvGiPLusb0VcpmfbIcWB0YieZYjgzPlbwPrpcA82KQ9JKa4frOudLOuymDQnlDdugUY8oBt53Mw5YZHgwHqU/618k1HNnZTh/sScIqv/cgZuDBIcB+A7cI9GrLtpUg7cruEnnVhfKonMmREbrIq24E+EZVeW1WkhKlx4dWrYq3vLanRECls7FRzZtu7b8HwuXW7qRziJAfUpxD/n9CrgpDqS6/7g0zwSi22e+qAPaFmc7HgAQFeINradpg9U5p2hwX5D30aCmikr95QiFcwCksvMxPir7SAgmPNCWyDmTBF4uSIvK57kHL7hKUHBOE4i5TqAeD4TTran9QXSRZV7eNQ0hNppp2Z0pPS05hdLoqdwd5zlSW+LvAdBoIgKFQElLP1p5UPnZAWIRdvQjYWIOq15y34m15i1yxjakqVWK6iZFjJahm8qnAcy64jAc0SMTFyNkfz9LvRV66veyK3CSdzdsfDaraPOqBv8yLAz1G3+f9REC2dhrX81SKtk9+RmbfLniGw1aVsvduxP5of8hCPsc88eNNhOlxem2J0U3AyCFkKiM9K/5E6uy0/0YITVWoVozj1wYrU8fMqjfJbEvFu9VIWDX9eCJ42IIGSY3TXiTVYOOTO3432MLayrCNJah/rBDDjlhQeKTMF/EvkdIzdaJjPvT/ilEiktMXmhua2y0s65SQWyS0w7BJAfCAfcE70zCo0Qjz6mpREoMtvWSiK+THSmj9GbKknYkTOoU+vFH4Ei3q2STdTJilvTGicy4CSLJ4nzag4lf7ESDjFzyabDpJ/RUOnyNfA1Xq1EimnYmELbbb7Kmomt
 MHKatoWG
 QrGS/D5gYh0ZYpfhshMtuIqtXmf/yiaQXkzq+NVz6DXg/NUJ2lpFQrlJWaRdAfNR2akxjmUAnQQGPTn5hX3RQo57SuBjS2KDDhxZyjguyfG15TC7v6K7pD5pJXUZ9zqaXc5+NLncJtLv1gW9Il8dtBAy2ing1OMXmu+ZPikSOTPb6/RFR3pbvhWqL5DNHJ068ROxuD7uLzQu8gr5Fgz1zsphLG8rli5ZEwFw9nFv7Vysk3D2Z+c+/eVm5tKz8orRiH2kR6ICfg5E7dR9lAzwp2xiGQFgXhV1zwkA2bnQThgQN5IcYtOhdL9Hx98994YH/jrgHmkc1rdOSV5CllDXtUf/1JV9N0FZ5CB3TO50/zCr8Dx+6AhzxDT4vXUreBPIqA21gIjcBM8VbzjJRb9KyBx/fk8cNHbTb4XUy4YMOaDFX9a4+8VQclxxZEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/2026 04:28, Anshuman Khandual wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> Bad page map reporting currently stores page table entry values in an
> unsigned long long and prints them with fixed 64-bit-oriented format
> strings. This is inconsistent across call sites and does not work well for
> architectures where page table entry values are not naturally represented
> as 64-bit values, such as 32-bit or 128-bit entries.
> 
> Introduce a common helper to convert raw page table entry values into a
> fixed-width hexadecimal string based on the actual entry size. Use it for
> bad page map reporting and for dumping the page table walk in
> __print_bad_page_map_pgtable().
> 
> Pass page table entry values to the reporting path as raw bytes together
> with their size, instead of forcing them through an unsigned long long.
> It keeps the printed output consistent and avoids truncation or misleading
> formatting for non-64-bit page table entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This patch applies on v7.2-rc2
> 
> Changes in V2:
> 
> - Dropped space after ":" during print per Matthew
> - Dropped CONFIG_CPU_BIG_ENDIAN per David
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20260707041703.658021-1-anshuman.khandual@arm.com/
> 
>  mm/memory.c | 98 ++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 75 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..a2b63af82792 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -519,9 +519,48 @@ static bool is_bad_page_map_ratelimited(void)
>  	return false;
>  }
>  
> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */

Not sure if it's worth doing something like this?:

#define PTVAL_STR_MAX						\
	(MAX(MAX(MAX(MAX(sizeof(pteval_t), sizeof(pmdval_t)), 	\
	    	     sizeof(pudval_t)), 			\
		 sizeof(p4dval_t)), 				\
    	     sizeof(pgdval_t)) + 1)

Would probably save stack space for 32bit arches?

> +
> +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> +{
> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> +		snprintf(buf, buf_size, "overflow");
> +		return;
> +	}
> +
> +	switch (entry_size) {
> +	case sizeof(u32):
> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> +		break;
> +	case sizeof(u64):
> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
> +		break;
> +#if defined(__SIZEOF_INT128__)
> +	case sizeof(u128):
> +		snprintf(buf, buf_size, "%016llx%016llx",
> +			 (unsigned long long)(*(const u128 *)entry >> 64),
> +			 (unsigned long long)*(const u128 *)entry);
> +		break;
> +#endif
> +	default:
> +		snprintf(buf, buf_size, "unsupported");
> +		break;
> +	}
> +}
> +
> +#define ptval_to_str(buf, val)								\
> +	do {										\
> +		__auto_type __val = (val);						\
> +											\
> +		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
> +	} while (0)

I think arm64 code also does pte printing, which you also need to fix up for
D128 support. Perhaps this could be moved to a header for reuse?

Also not sure if it's worth returning buf so that this pattern would be possible:

char pmd_str[PTVAL_STR_MAX];
pr_err("pmd=%s\n, ptval_to_str(pmd_str, pmd_val(*pmdp));

Although perhaps that's a bit busy and should be discouraged...

Thanks,
Ryan


> +
>  static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
>  {
> -	unsigned long long pgdv, p4dv, pudv, pmdv;
> +	char pgd_str[PTVAL_STR_MAX];
> +	char p4d_str[PTVAL_STR_MAX];
> +	char pud_str[PTVAL_STR_MAX];
> +	char pmd_str[PTVAL_STR_MAX];
>  	p4d_t p4d, *p4dp;
>  	pud_t pud, *pudp;
>  	pmd_t pmd, *pmdp;
> @@ -532,34 +571,34 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * see locking requirements for print_bad_page_map().
>  	 */
>  	pgdp = pgd_offset(mm, addr);
> -	pgdv = pgd_val(*pgdp);
> +	ptval_to_str(pgd_str, pgd_val(*pgdp));
>  
>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> -		pr_alert("pgd:%08llx\n", pgdv);
> +		pr_alert("pgd:%s\n", pgd_str);
>  		return;
>  	}
>  
>  	p4dp = p4d_offset(pgdp, addr);
>  	p4d = p4dp_get(p4dp);
> -	p4dv = p4d_val(p4d);
> +	ptval_to_str(p4d_str, p4d_val(p4d));
>  
>  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
> -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
> +		pr_alert("pgd:%s p4d:%s\n", pgd_str, p4d_str);
>  		return;
>  	}
>  
>  	pudp = pud_offset(p4dp, addr);
>  	pud = pudp_get(pudp);
> -	pudv = pud_val(pud);
> +	ptval_to_str(pud_str, pud_val(pud));
>  
>  	if (!pud_present(pud) || pud_leaf(pud)) {
> -		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
> +		pr_alert("pgd:%s p4d:%s pud:%s\n", pgd_str, p4d_str, pud_str);
>  		return;
>  	}
>  
>  	pmdp = pmd_offset(pudp, addr);
>  	pmd = pmdp_get(pmdp);
> -	pmdv = pmd_val(pmd);
> +	ptval_to_str(pmd_str, pmd_val(pmd));
>  
>  	/*
>  	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
> @@ -567,8 +606,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * doing another map would be bad. print_bad_page_map() should
>  	 * already take care of printing the PTE.
>  	 */
> -	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
> -		 p4dv, pudv, pmdv);
> +	pr_alert("pgd:%s p4d:%s pud:%s pmd:%s\n", pgd_str, p4d_str, pud_str, pmd_str);
>  }
>  
>  /*
> @@ -584,10 +622,11 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>   * page table lock.
>   */
>  static void print_bad_page_map(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long long entry, struct page *page,
> -		enum pgtable_level level)
> +		unsigned long addr, const void *entry, size_t entry_size,
> +		struct page *page, enum pgtable_level level)
>  {
>  	struct address_space *mapping;
> +	char entry_str[PTVAL_STR_MAX];
>  	pgoff_t index;
>  
>  	if (is_bad_page_map_ratelimited())
> @@ -596,8 +635,9 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>  	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
>  	index = linear_page_index(vma, addr);
>  
> -	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
> -		 pgtable_level_to_str(level), entry);
> +	ptval_bytes_to_hex_str(entry_str, sizeof(entry_str), entry, entry_size);
> +	pr_alert("BUG: Bad page map in process %s  %s:%s", current->comm,
> +		 pgtable_level_to_str(level), entry_str);
>  	__print_bad_page_map_pgtable(vma->vm_mm, addr);
>  	if (page)
>  		dump_page(page, "bad page map");
> @@ -627,8 +667,13 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
>  	}
>  }
>  
> -#define print_bad_pte(vma, addr, pte, page) \
> -	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
> +static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
> +			  pte_t pte, struct page *page)
> +{
> +	__auto_type entry = pte_val(pte);
> +
> +	print_bad_page_map(vma, addr, &entry, sizeof(entry), page, PGTABLE_LEVEL_PTE);
> +}
>  
>  /**
>   * __vm_normal_page() - Get the "struct page" associated with a page table entry.
> @@ -636,8 +681,9 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
>   * @addr: The address where the page table entry is mapped.
>   * @pfn: The PFN stored in the page table entry.
>   * @special: Whether the page table entry is marked "special".
> - * @level: The page table level for error reporting purposes only.
>   * @entry: The page table entry value for error reporting purposes only.
> + * @entry_size: The size of @entry.
> + * @level: The page table level for error reporting purposes only.
>   *
>   * "Special" mappings do not wish to be associated with a "struct page" (either
>   * it doesn't exist, or it exists but they don't want to touch it). In this
> @@ -697,7 +743,7 @@ static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
>   */
>  static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>  		unsigned long addr, unsigned long pfn, bool special,
> -		unsigned long long entry, enum pgtable_level level)
> +		const void *entry, size_t entry_size, enum pgtable_level level)
>  {
>  	if (pgtable_level_has_pxx_special(level)) {
>  		if (unlikely(special)) {
> @@ -710,7 +756,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>  			if (is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
>  				return NULL;
>  
> -			print_bad_page_map(vma, addr, entry, NULL, level);
> +			print_bad_page_map(vma, addr, entry, entry_size, NULL, level);
>  			return NULL;
>  		}
>  		/*
> @@ -741,7 +787,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>  
>  	if (unlikely(pfn > highest_memmap_pfn)) {
>  		/* Corrupted page table entry. */
> -		print_bad_page_map(vma, addr, entry, NULL, level);
> +		print_bad_page_map(vma, addr, entry, entry_size, NULL, level);
>  		return NULL;
>  	}
>  	/*
> @@ -767,8 +813,10 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>  struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>  			    pte_t pte)
>  {
> +	__auto_type entry = pte_val(pte);
> +
>  	return __vm_normal_page(vma, addr, pte_pfn(pte), pte_special(pte),
> -				pte_val(pte), PGTABLE_LEVEL_PTE);
> +				&entry, sizeof(entry), PGTABLE_LEVEL_PTE);
>  }
>  
>  /**
> @@ -809,8 +857,10 @@ struct folio *vm_normal_folio(struct vm_area_struct *vma, unsigned long addr,
>  struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>  				pmd_t pmd)
>  {
> +	__auto_type entry = pmd_val(pmd);
> +
>  	return __vm_normal_page(vma, addr, pmd_pfn(pmd), pmd_special(pmd),
> -				pmd_val(pmd), PGTABLE_LEVEL_PMD);
> +				&entry, sizeof(entry), PGTABLE_LEVEL_PMD);
>  }
>  
>  /**
> @@ -850,8 +900,10 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
>  struct page *vm_normal_page_pud(struct vm_area_struct *vma,
>  		unsigned long addr, pud_t pud)
>  {
> +	__auto_type entry = pud_val(pud);
> +
>  	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
> -				pud_val(pud), PGTABLE_LEVEL_PUD);
> +				&entry, sizeof(entry), PGTABLE_LEVEL_PUD);
>  }
>  #endif
>  



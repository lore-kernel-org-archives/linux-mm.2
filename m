Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE88FCE068
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA096B0099; Thu, 26 Feb 2026 07:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1336B009D; Thu, 26 Feb 2026 07:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD546B009F; Thu, 26 Feb 2026 07:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0974D6B0099
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:35:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3B9C160BBE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:35:00 +0000 (UTC)
X-FDA: 84486552360.27.AA501CD
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf12.hostedemail.com (Postfix) with ESMTP id CDDB04000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:34:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=REmHYhHJ;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772109299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toSZr/wk0D+ZLB4X3GL8tdvy8Pfuhw55RvV5q/azapM=;
	b=Z8CsLMMrSjJbx2E3oscIbHspYV7ZbWNBwt1gHElSl0Yp1G/QJvpUOD7DxjCEW636aAOZRv
	1Q5BRsjvT88dxUDaNix5kH0LUSej8KCTO1FEuO3+gja1KE0Mu8nns4Xcn61rIMWF/benI+
	Axn08PV43+8ANBFI0nFZCXCuXBuT84M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772109299; a=rsa-sha256;
	cv=none;
	b=iWE/SiwOjXp7eU+JybtX0DZ2endV1XK4nUC6CrLjE0Vvu9SWNXTsyzMHuUYVZibhOZlGSn
	wxyu7HGPRm1HZ0aQ7V1lO28pG//uwAs0mF8kwn0WsINOcenhjd+i8dmSGG7bB9QMpWWi48
	3yJqhR1xr4nxJRtyYXMYwcEPxd7Syes=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=REmHYhHJ;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772109296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=toSZr/wk0D+ZLB4X3GL8tdvy8Pfuhw55RvV5q/azapM=;
	b=REmHYhHJH8JbL1SxuExvYSceF4yEaGJbivS6xDSQE9K5ymP6CJpeL9wvMbAGx4KwMpl8dy
	MWnJSF//2NEorFNH5fXDdJKyHs3HYayyJfEAYar4KO3O74WyeZCZPvZW7JPNOeZezeXh/z
	XzDcaAvgPUfvzAW3HYyp9mg/OUKgolU=
From: Usama Arif <usama.arif@linux.dev>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC V1 01/16] mm: Abstract printing of pxd_val()
Date: Thu, 26 Feb 2026 04:34:39 -0800
Message-ID: <20260226123442.759447-1-usama.arif@linux.dev>
In-Reply-To: <20260224051153.3150613-2-anshuman.khandual@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Stat-Signature: yd9wtx9uzefu3pccodjpozejgfpg1q9i
X-Rspamd-Queue-Id: CDDB04000D
X-Rspam-User: 
X-HE-Tag: 1772109298-311390
X-HE-Meta: U2FsdGVkX18xx4cf34I0Ac8+v/pkWXX9pOIVwe+Sjvm0qPweFtgPrZNvf+/Oe/xp/aIlTDuHX8aef7deYyxC9uG2TJ6D9Oq8Tgx/f15Aa+KpIl6rVcIB1WShnSIuOljQGEWBctAF37zo8fXGPRRBlIfoxDCrgLg0AaO5zfxVK816utu/eSc6+VwPy6W5u+IbpjaZ8xRsWrv+zLJCHuDiX7eWFg4kv3excRU9mb/qspKU+hpEojlLwKk8kAVh30umT8x7I01Q2dtMrCJz9cscf5Cz9PFgarQOcJP1jkO7cpwiQVfUqkGWeapLE0sFDkzyhaVR+b6PEb61qPYs49+FSCFMzVdb7mEGu5pUWS4AulZOvK7EJJSGuVoOikOxuk8vlG7iX9mf9fprc8ETkfmloEil0PHfMMfFzi8FAbZLxFYgCEdkO3erY6LtBC/aUyxTb/ncNCdixEL07nspIBfj8KNyyFPEkGbe5xXHOo378RPIFY0KybEclLFtQLx87nFyMBkRyTzonjth2FlkcSG2+u6m4B9piWcnOfFBNbmVHtqTo6rOgV+j317zm3cIhIz4mFpOwVyrDX8pfoL/EMy6ho+K+DVJXd7vf+fgroVc5Wc0w/wqTFyKEqscQEs1pQpTqdT6tV+pP36ezK19uvP66LQEjfvPB6NE50VVX8HHHk7DzYXuUlTu0tFsiyQ5Lt57aX0WZ5BxhfBAbFGaGnebzFPh4oxTpRxTVVbou5m2CDKdOfEzAbBbsgWPByHW1xVV8Id7i5SXY1yIy9HgDPH5Z+BBuL39aDdePc4F4yhLR9ySooee//viiTmfi2TcA/ML1gB6jHUw9TrRK67q2hfhSLAYfpV7ZMG9mZgWv/OmmtQ4Zni6abpn57G54/0TCDWd3UsbBnYXwe6lCYYrYxu7AMI1xCKqnuncPZGw9hUm7ZpLeXYPE1/AYWLOdgsKPvpdK5RNkLLV5sff863Tpjk
 DlTllSI3
 SZpxXiPKVOtFd5KI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 10:41:38 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Ahead of adding support for D128 pgtables, refactor places that print
> PTE values to use the new __PRIpte format specifier and __PRIpte_args()
> macro to prepare the argument(s). When using D128 pgtables in future,
> we can simply redefine __PRIpte and __PTIpte_args().
> 
> Besides there is also an assumption about pxd_val() being always capped
> at 'unsigned long long' size but that will not work for D128 pgtables.
> Just increase its size to u128 if the compiler supports via a separate
> data type pxdval_t which also defaults to existing 'unsigned long long'.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  include/linux/pgtable.h |  5 +++++
>  mm/memory.c             | 29 +++++++++++++++++++----------
>  2 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index a50df42a893f..da17139a1279 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -17,6 +17,11 @@
>  #include <asm-generic/pgtable_uffd.h>
>  #include <linux/page_table_check.h>
>  
> +#ifndef __PRIpte
> +#define __PRIpte		"016llx"
> +#define __PRIpte_args(val)	((u64)val)
> +#endif
> +
>  #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
>  	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
>  #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..cfc3077fc52f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -532,9 +532,15 @@ static bool is_bad_page_map_ratelimited(void)
>  	return false;
>  }
>  
> +#ifdef __SIZEOF_INT128__
> +	typedef u128 pxdval_t;
> +#else
> +	typedef unsigned long long pxdval_t;
> +#endif
> +
>  static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
>  {
> -	unsigned long long pgdv, p4dv, pudv, pmdv;
> +	pxdval_t pgdv, p4dv, pudv, pmdv;
>  	p4d_t p4d, *p4dp;
>  	pud_t pud, *pudp;
>  	pmd_t pmd, *pmdp;
> @@ -548,7 +554,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	pgdv = pgd_val(*pgdp);
>  
>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> -		pr_alert("pgd:%08llx\n", pgdv);
> +		pr_alert("pgd:%" __PRIpte "\n", __PRIpte_args(pgdv));
>  		return;
>  	}
>  
> @@ -557,7 +563,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	p4dv = p4d_val(p4d);
>  
>  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
> -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
> +		pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "\n",

Hi Anshuman,

The original format had a space between values ("pgd:%08llx p4d:%08llx").
The replacement loses the space separator producing output like
"pgd:123p4d:456" instead of "pgd:123 p4d:456". The same issue exists
in other places in this commit.

> +			 __PRIpte_args(pgdv), __PRIpte_args(p4dv));
>  		return;
>  	}
>  
> @@ -566,7 +573,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	pudv = pud_val(pud);
>  
>  	if (!pud_present(pud) || pud_leaf(pud)) {
> -		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
> +		pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "pud:%" __PRIpte "\n",
> +			 __PRIpte_args(pgdv), __PRIpte_args(p4dv), __PRIpte_args(pudv));
>  		return;
>  	}
>  
> @@ -580,8 +588,9 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * doing another map would be bad. print_bad_page_map() should
>  	 * already take care of printing the PTE.
>  	 */
> -	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
> -		 p4dv, pudv, pmdv);
> +	pr_alert("pgd:%" __PRIpte "p4d:%" __PRIpte "pud:%" __PRIpte "pmd:%" __PRIpte "\n",
> +		 __PRIpte_args(pgdv), __PRIpte_args(p4dv),
> +		 __PRIpte_args(pudv), __PRIpte_args(pmdv));
>  }
>  
>  /*
> @@ -597,7 +606,7 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>   * page table lock.
>   */
>  static void print_bad_page_map(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long long entry, struct page *page,
> +		unsigned long addr, pxdval_t entry, struct page *page,
>  		enum pgtable_level level)
>  {
>  	struct address_space *mapping;
> @@ -609,8 +618,8 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>  	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
>  	index = linear_page_index(vma, addr);
>  
> -	pr_alert("BUG: Bad page map in process %s  %s:%08llx", current->comm,
> -		 pgtable_level_to_str(level), entry);
> +	pr_alert("BUG: Bad page map in process %s  %s:%" __PRIpte, current->comm,
> +		 pgtable_level_to_str(level), __PRIpte_args(entry));
>  	__print_bad_page_map_pgtable(vma->vm_mm, addr);
>  	if (page)
>  		dump_page(page, "bad page map");
> @@ -695,7 +704,7 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>   */
>  static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>  		unsigned long addr, unsigned long pfn, bool special,
> -		unsigned long long entry, enum pgtable_level level)
> +		pxdval_t entry, enum pgtable_level level)
>  {
>  	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
>  		if (unlikely(special)) {
> -- 
> 2.43.0
> 
> 


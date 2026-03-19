Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D82C108E1F3
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F606B0484; Thu, 19 Mar 2026 07:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17856B0486; Thu, 19 Mar 2026 07:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954316B0487; Thu, 19 Mar 2026 07:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 869DC6B0484
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:33:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17A4158F62
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:33:28 +0000 (UTC)
X-FDA: 84562602096.02.E593A4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A9B01C0003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:33:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5RAsODp;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773920006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mk709h9QfQc31Mgzs3E6Rn/BwgzT7JyFrCPkHY171vU=;
	b=wZ49uHrkrRMaJSOrbI3QNYJvR65iYreAvOUQfWFkB+ssgkH5Y3mQgTDGwMGJxqCvABjBpg
	xntsT4jpGVag7quY9dgr7eaUkNeJmwyq4DOmEvL5YeYLCqxcRfk1tdSsBuqOhUBpVnCVoQ
	1KUD9KGB6SHwytAPriRkU+9fOxEYpTY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5RAsODp;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773920006; a=rsa-sha256;
	cv=none;
	b=iViFLe2IsjiKCcReVCY2b4g/bbBoCYWJ7SPtJ7aeTsvt389SAvoNb6M0bhkhmUV9uxV/oF
	SX9W6Jy9TcHjdMJOCaIBR40HB87N6UqfGIC0QAvNfXdfNAgrBwxpUwWpuK+ijaB9ODtMs4
	xizQsFQJjTXbTUszuqIkgUTrhTZ5ihY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6820B4013F;
	Thu, 19 Mar 2026 11:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A02EC19424;
	Thu, 19 Mar 2026 11:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773920005;
	bh=d9ciODzpu+mpFYsWr5+dAHTFxxRafO6FyAjxRDFDoaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C5RAsODpS2GkyED+enTEiBFq+aNwmkq3byYmpW6u8DjqN6x04s5ra+g2foF3lHDfP
	 09q9l45FghZx+GE9y/2fOJMu2e+A2NuuQB/jRCdVWLq+Kz/TuW8L0nWrf3if3t2jok
	 hPY3ztfM8xrxIS1Ex+VFrhyTltMtNjuqQHNw08d9272GUzVyYJKiZvCTPsVs2Q3uUc
	 iJZn0XUvYa5hlEjti3gjxL7A5jeyAJ0WFVJ8MabPChK/gzaf5s/dKfFKeXZ1Wiud1f
	 3L5kIqzT5ORF7KT+RXPSqHN3a7yUzWUvaNNvuKsyY7MMRz9LZmNMAvev6YXjafap09
	 PPKt2mBe15wjw==
Date: Thu, 19 Mar 2026 11:33:18 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm: change to return bool for
 pmdp_clear_flush_young()
Message-ID: <60e7cc1b-1459-44d8-8088-30b7ba3e9b44@lucifer.local>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <eb513ed809685f78e0abdeb7f7b6ebdec0fcca18.1773890510.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb513ed809685f78e0abdeb7f7b6ebdec0fcca18.1773890510.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A9B01C0003
X-Stat-Signature: rs1nbk1tcgeksbag9myqrud7izbh66co
X-Rspam-User: 
X-HE-Tag: 1773920006-986870
X-HE-Meta: U2FsdGVkX18FFgo7QaKlgdn6rQOr7IgLdW3Wat9sih4JVIMx5ggTnFlzR1ccO/TY7B+vksn0Nxu7AwfmTMbJewXpmLm//tPuCGnyKKeqb6SdPd9sU05ad5EkU+S1o7DDICKXcFSU8Zx5q5MkRko8fmQgygijbayCejWrsuL69tR2/duvBu90+FXHEm3fa3pUQXMTExJ9fc9VuN4RxwOY/V+QPYnElVerKgnyAPVWtK0OJE0phcW5zX0YQwlH/hMiVMYWzhZpohNBvD9OvsnixQ+sYNrKeTXdojZZcf3eGbe/HNMO28L8XByOsPi1gnHlOUOHtleafKZWSCqeo8viPd7QoK7yHYzmJmgZ/bZTsHcEIG4IV7pdwZOQknjoOzDZ//jssbrPSKIQu/nWF7/vxJ7BEgsptO6Ws14j/sNzmEYrXO6gx/rYGKmqUC9TmW3kry1lLE+3sxbXWYzs9kUYlA10aE8gOlpfmHReJSQIn+hshosjAUrbhG/iydNXc7lmnZtikYCSQiV27bqNRhZhxtPTmIi2ZqmBDUNp71I5ZW5mkyh/T+oKEp/EAsnOa6dBNXszjjLS/dqpOcLUuPN7NX689b7PnDVET1AYOL/0lkmbuiAIW94HZ5z+qt6KFBJTtmugd6njl3UlBMs1PW0MPXlucvypXoYDJshrWinVzU/HNOXpvH8HTUhkVwK/dFdJOqwTCj7Y9wr1AcH+nALOwQNFhMY5d2YJUCmNR49RQE9vJmz899gJreMo6I1rlKK3/Wop9MLXXVcz+aPCMEIKyyl+NXfGLJ3YGx9whpJlvGZPLG6TV0C6wMbIrkAekKCW5uqZnv2gqb59TCm0MwlDqEnvTlZ4+Jn1iNReKqC1x1Zrdqn11nl/bPwwvUYm9poI3fnpe6y2BS4AWIOQZtBguxw9CalN6IARhGTOKSBpnlppgQhSHDHwW8X3OVNPkIof+bywZvA46Rw4UUPoxTQ
 MJXCfX6S
 ENQDJeTDO3+c9OZNFRKvbk6camephrH+ZFNWFNJa66XoBnVZeGkUnj588ZwnXXwquSRUmkeFT9G9PHoe6kJj7FEUP0LWaBclBbmvFSndsbmigb/IBG7a+Ug0GWQGYR2jXteQKoAIxmHEBfTbXRCrLDsIbcJJTKLBIlketjFu1V3IrW4i6CXBlzxJb8PFTP0WgHLiaX5dzzT/PB4uzMwFm3KudL3XygHThJaMLgA0mch/QOU/3zt3dY+4+woz6MxyyeGsfKzGwaeDXmgQVQmN9Lui4a65SxDegR63hfie7Hx44T+/CIPY5s2lkKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:24:03AM +0800, Baolin Wang wrote:
> The pmdp_clear_flush_young() is used to clear the young flag and flush the
> TLB, returning whether the young flag was set for this PMD entry. Change
> the return type to bool to make the intention clearer.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Some nits, but otherwise LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  arch/s390/include/asm/pgtable.h |  4 ++--
>  arch/x86/include/asm/pgtable.h  |  4 ++--
>  arch/x86/mm/pgtable.c           |  6 +++---
>  include/linux/pgtable.h         | 10 +++++-----
>  mm/pgtable-generic.c            |  7 ++++---
>  5 files changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 1f5efb7be71d..90bba85ca4b8 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1693,8 +1693,8 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  }
>
>  #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
> -static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
> -					 unsigned long addr, pmd_t *pmdp)
> +static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
> +					  unsigned long addr, pmd_t *pmdp)

Same indentation comment as with other patches, 2 tabs you know the drill :)
applies to all such in this patch.

>  {
>  	VM_BUG_ON(addr & ~HPAGE_MASK);
>  	return pmdp_test_and_clear_young(vma, addr, pmdp);
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index bd02ee730a23..f9439449c9bd 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1301,8 +1301,8 @@ extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
>  				     unsigned long addr, pud_t *pudp);
>
>  #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
> -extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
> -				  unsigned long address, pmd_t *pmdp);
> +extern bool pmdp_clear_flush_young(struct vm_area_struct *vma,
> +				   unsigned long address, pmd_t *pmdp);

Drop the extern please!

>
>
>  #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 10a5e0b2be36..8c336edf0e65 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -503,10 +503,10 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
>  }
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -int pmdp_clear_flush_young(struct vm_area_struct *vma,
> -			   unsigned long address, pmd_t *pmdp)
> +bool pmdp_clear_flush_young(struct vm_area_struct *vma,
> +			    unsigned long address, pmd_t *pmdp)
>  {
> -	int young;
> +	bool young;
>
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index e53220b0a9a3..8b8838f19af3 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -536,18 +536,18 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
>
>  #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
> -				  unsigned long address, pmd_t *pmdp);
> +bool pmdp_clear_flush_young(struct vm_area_struct *vma,
> +		unsigned long address, pmd_t *pmdp);

Ahh! Here you drop the extern :) AND use 2 tabs :)) thanks!

>  #else
>  /*
>   * Despite relevant to THP only, this API is called from generic rmap code
>   * under PageTransHuge(), hence needs a dummy implementation for !THP
>   */
> -static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
> -					 unsigned long address, pmd_t *pmdp)
> +static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
> +		unsigned long address, pmd_t *pmdp)
>  {
>  	BUILD_BUG();
> -	return 0;
> +	return false;
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  #endif
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index db0ee918b08a..b91b1a98029c 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -124,10 +124,11 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
>  #endif
>
>  #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
> -int pmdp_clear_flush_young(struct vm_area_struct *vma,
> -			   unsigned long address, pmd_t *pmdp)
> +bool pmdp_clear_flush_young(struct vm_area_struct *vma,
> +		unsigned long address, pmd_t *pmdp)
>  {
> -	int young;
> +	bool young;
> +
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>  	young = pmdp_test_and_clear_young(vma, address, pmdp);
>  	if (young)
> --
> 2.47.3
>


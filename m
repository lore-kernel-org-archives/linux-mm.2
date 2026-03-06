Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45E9CF513F8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 04:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBEC6B0005; Thu,  5 Mar 2026 23:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6733E6B0089; Thu,  5 Mar 2026 23:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F8E6B008A; Thu,  5 Mar 2026 23:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 474916B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 23:25:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E71E18B678
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 04:25:55 +0000 (UTC)
X-FDA: 84514350270.01.912204A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5134240005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 04:25:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aFzYSKfN;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772771154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvulmaWHVHLTxELsaUcupjwHmyR9DBqU5/UhJVjUTkk=;
	b=mwYisePAvJJB0a0EV1bzHrpDBRU6cfoYoqxeV6AQSFVikDdIsZIyRbyoZPNKynxaK3pqYF
	zyrlZwqM1cMGL7XauplJxCNqrgapSl354bZr7xlSv4oYYEFN/4nIRNCMXpTMEyPdoqD1z3
	ch8A+pmdrgVIi70ozlHFdZRWpk2y/4k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=aFzYSKfN;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772771154; a=rsa-sha256;
	cv=none;
	b=7NVLKFersb5SiNriQd5ygvxm8AYaoww67FDs0JTc6vlOzTQU+k3XLFdRBZgTJ7oIHJ1gNe
	IhmtpBjc7R2ZsDmIOJ6HYOLIEcC//y9U74LGm8POwtuMhzMgWb92pI2ba8RbHlu475Zhoy
	Iyhu/8yFe72M6yd6D8Mv2OPHQ2dXS98=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=jvulmaWHVHLTxELsaUcupjwHmyR9DBqU5/UhJVjUTkk=; b=aFzYSKfNpDK4g1CCGvw7X8T2jh
	fISPftxcZZHFmW/uVYj00QjQoeOE+cnxCCfNGf60xcAITo155VewGg8b94KHAJDmgSmxDFO2xybGm
	lS9KOpNbj3XTlNAgb2fA1YpjhDE8FN/l3OVKD83XpfLFxTVQpOieJ3IMP0XnnrB3IRERiRApue4lg
	IdqoYajTIgG3LUGOW+QUYzwKSVc1bAPidLbWXo4yK4LXIhi9nuTQLcc/2qb5TalHrcpKGAtk2TQV7
	IhT7WXpVDek3hi1swmixTb654rh4P0qCodoYra7NlWmKoya92mTQQ1VcLMa/i8nueZDSJfFlNUaF3
	4LBCnnHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyMkv-0000000G8pR-0PfW;
	Fri, 06 Mar 2026 04:25:41 +0000
Date: Fri, 6 Mar 2026 04:25:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, david@kernel.org,
	catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	anshuman.khandual@arm.com, rmclure@linux.ibm.com,
	kevin.brodsky@arm.com, apopple@nvidia.com, ajd@linux.ibm.com,
	pasha.tatashin@soleen.com, bhe@redhat.com, thuth@redhat.com,
	coxu@redhat.com, dan.j.williams@intel.com, yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com, conor.dooley@microchip.com,
	Jonathan.Cameron@huawei.com, riel@surriel.com,
	Kefeng Wang <wangkefeng.wang@huawei.com>, chenjun102@huawei.com
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
Message-ID: <aapXRN4KjWtUUJ0g@casper.infradead.org>
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
 <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
 <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5134240005
X-Rspamd-Server: rspam08
X-Stat-Signature: fj1p9i9numgr6e9u696rgic5kirsi3c3
X-HE-Tag: 1772771153-730750
X-HE-Meta: U2FsdGVkX18OAq6+3x6MhEhAyPAZ1c3DIy7XJsqIE0ghpbFcJPmnoxb/j3x8plnPBWAzyG9TDtTKHQIFrwr8o15GwW5ECPj6nKL5S8Vh5gY+0iydRtnGUsXP2xb7Tcn7j01w3OF0BykbRknaka1YRyylVe7n+FHPXIoCTlIc9DAe+DyX5yDpclTuOg7H0WFU3f/RtRaFWsxkGpunNaUVILo+comDF5riXFkukox8DbSUmJR/LOBTpLT+PunnIxjxwdbJ6b5eP+qRSg/s0vVP9CVGW5UfODYIE9IwQPyYFib27gDylvi7tEjUs0D+DmuHRJysqyJQCl7i1NjG2gMhsozD1JQcNaCIhO/VcLoa2zdLZPMRV44zLf+nHa9MJhPqPKkC+hOh+zXogYMrdFx4GV77CtnnjiSt/Ta3vKaDsVvTZbYSA+1kdF6kEoUZG1bC52a+lMqE2yJD+yKuQ61wxcgo0QOOA/N3iRLY0TdtoMYGFAgaDFbjkhbWLIC0Dhc0HgK0cKNt7nZHmHm02e+C7vuatlIK5C+cozAYzNaiqhRJvYLuEMva/gS+thl8RfJ4oRtIdF8NcatcQGjrh15s1HOFhRra9/J0sLxhShjUoewvldvh1Km0DWB+7E1H+1SyEh1Az5owQGZWA+H1q9/6nIm9saO/wchSD5J1ZdpxoutOOY0kYRcPRwilEY5QY3zhoUX0ErOvoRRsr0aob6ikKaPyZT4djfiRtcR27DcSbhw6uNskzOoH9KtKfWB3fbMK5ygcXB5c1/ogzFJ2TSErXrF9mCFGfrggJuZjTbacjPklyoX400zQaz6HKR1QwWSjIAnzlZNJ+e3XtimjBu7Cag0PGlbDWdO1eMymhi5k0D1A0zQU4Hd5ULR+CTE/WjxK2lBs8/K6+3883ipSaI03u6+Pi6Lw7bTPjuT/+ONgF2X5NKDCHKu15AnxOv2aDbqyPYGV6JMw8rVJBotkG/W
 +fFYtOEP
 mFQep
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 05:38:46PM +0800, Yin Tirui wrote:
> On 3/4/2026 3:52 PM, Jürgen Groß wrote:
> > Today it can either be used for a large page (which should be a pmd,
> > of course), or - much worse - you'd strip the _PAGE_PAT bit, which is
> > at the same position in PTEs.
> > 
> > So basically you are removing the ability to use some cache modes.
> > 
> > NACK!
> > 
> > 
> > Juergen
> 
> Hi Willy and Jürgen,
> 
> Following up on the x86 _PAGE_PSE and _PAGE_PAT aliasing issue.
> 
> To achieve the goal of keeping pfn_pte() pure and completely eradicating the
> pte_clrhuge() anti-pattern, we need a way to ensure pfn_pte() never receives
> a pgprot with the huge bit set.
> 
> @Jürgen:
> Just to be absolutely certain: is there any safe way to filter out the huge
> page attributes directly inside x86's pfn_pte() without breaking PAT? Or
> does the hardware bit-aliasing make this strictly impossible at the
> pfn_pte() level?
> 
> @Willy @Jürgen:
> Assuming it is impossible to filter this safely inside pfn_pte() on x86, we
> must translate the pgprot before passing it down. To maintain strict
> type-safety and still drop pte_clrhuge(), I plan to introduce two
> arch-neutral wrappers:
> 
> x86:
> /* Translates large prot to 4K. Shifts PAT back to bit 7, inherently
> clearing _PAGE_PSE */
> #define pgprot_huge_to_pte(prot)    pgprot_large_2_4k(prot)
> /* Translates 4K prot to large. Shifts PAT to bit 12, strictly sets
> _PAGE_PSE */
> #define pgprot_pte_to_huge(prot)
> __pgprot(pgprot_val(pgprot_4k_2_large(prot)) | _PAGE_PSE)

I don't think we should have pgprot_large_2_4k().  Or rather, I think it
should be embedded in pmd_pgprot() / pud_pgprot().  That is, we should
have an 'ideal' pgprot which, on x86, perhaps matches that used by the
4k level.  pfn_pmd() should be converting from the ideal pgprot to
that actually used by PMDs (and setting _PAGE_PSE?)

> arm64:
> /*
>  * Drops Block marker, enforces Page marker.
>  * Strictly preserves the PTE_VALID bit to avoid validating PROT_NONE pages.
>  */
> #define pgprot_huge_to_pte(prot) \
>       __pgprot((pgprot_val(prot) & ~(PMD_TYPE_MASK & ~PTE_VALID)) | \
>              (PTE_TYPE_PAGE & ~PTE_VALID))
> /*
>  * Drops Page marker, sets Block marker.
>  * Strictly preserves the PTE_VALID bit.
>  */
> #define pgprot_pte_to_huge(prot) \
>       __pgprot((pgprot_val(prot) & ~(PTE_TYPE_MASK & ~PTE_VALID)) | \
>              (PMD_TYPE_SECT & ~PTE_VALID))
> 
> Usage:
> 1.  Creating a huge pfnmap (remap_try_huge_pmd)
> pgprot_t huge_prot = pgprot_pte_to_huge(prot);
> 
> /* No need for pmd_mkhuge() */
> pmd_t entry = pmd_mkspecial(pfn_pmd(pfn, huge_prot));
> set_pmd_at(mm, addr, pmd, entry);
> 
> 2. Splitting a huge pfnmap (__split_huge_pmd_locked)
> pgprot_t small_prot = pgprot_huge_to_pte(pmd_pgprot(old_pmd));
> 
> /* No need for pte_clrhuge() */
> pte_t entry = pfn_pte(pmd_pfn(old_pmd), small_prot);
> set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
> 
> 
> Willy, is there a better architectural approach to handle this and satisfy
> the type-safety requirement given the x86 hardware constraints?
> 
> -- 
> Thanks,
> Yin Tirui
> 
> 


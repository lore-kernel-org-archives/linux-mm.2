Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CBE60A2633
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CLtGwEGI
Received: by kanga.kvack.org (Postfix)
	id 311D16B00EF; Tue, 10 Nov 2026 06:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB9C6B05B0; Tue, 10 Nov 2026 06:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB9D6B05B1; Tue, 10 Nov 2026 06:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E187C6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:02:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68C4D14057E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:02 +0000 (UTC)
X-FDA: 85418919684.12.ED66CF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id AEEF31A0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLtGwEGI;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794308520;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvI60T/QPMZ57qjxn74c02kD5YtFy/D6JhNIDT7eK8o=;
	b=w0s2UwCRo9cuyOAiG3g/WvNiGN7kJOl01an3ACNDDT0PUl11+958/ENPUs8fzpIJAvLK4g
	j4aKGbiYYjmdTChzaECv+rlwO3+sXr12A0YZEWYLP4JJo42gHXA8Yve2JRWmAI9F9IWhLg
	vvSr5IWbZeP6/UfDKaT3bWWKeyqJ5Gs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794308520;
	b=zJHBKeXWmeLqApIQjeC2/EAGZTxQa2zAhalcqPDxmqsFeuljqN5Dac09mrbUFocxRuioNo
	kZTQmRdO+5SvZ+tcZVVBpWDaKBSA3LZ16Cwt6dSe5/YgC1WTQOTvYDcgoN3JMDKTzN8Wlv
	VqcunMnMQMYJwbk9RSEoaXQlj5tD174=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLtGwEGI;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8D894357E;
	Tue, 10 Nov 2026 11:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1B01F0089F;
	Tue, 10 Nov 2026 11:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794308519;
	bh=xvI60T/QPMZ57qjxn74c02kD5YtFy/D6JhNIDT7eK8o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CLtGwEGIl0VjGtNr3vLS7SW4PObBFLP68aGxn5RDB1aSPPIs+1u/+Yk7yhV1zTXTL
	 g7QydUYkeG6egXJVdUxjzLwGlUA9oJ0HRpteMwS+UTyYKHlwmt1DcMsZ5N12kvu67A
	 SJrp9J1NQ3MJarosnrng/9lfnWj68dIefCpoBojeFHrBgb0hIGeSsfzEz6a72/MHZ6
	 YC8ENkzUynnt1utYu6qtug+uXoT2YVSZOtMj7aVSGjcZgu6qXNY5FEM5egAOG2ToUE
	 eQQBYRp2BfiPxH9Q8hSN9NZaCOmSNV6/440Tw25UAFTRWpNamoNl6YaVATtxrnoWg9
	 r6RKdzdWHescg==
Message-ID: <sashiko-outbox-206911@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] riscv: mm: allocate split linear mapping page
 tables via the standard page table allocation APIs
Reply-To: sashiko-reviews@lists.linux.dev
To: li.hanting@zte.com.cn, palmer@dabbelt.com, pjw@kernel.org, aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, rppt@kernel.org
In-Reply-To: <202611091101.6A9B1Nf3015337@mse-db.zte.com.cn>
References: <202611091101.6A9B1Nf3015337@mse-db.zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 11:01:58 +0000
X-Stat-Signature: qfjaq94z511ea9ski4pai1655k69ewxo
X-Rspamd-Queue-Id: AEEF31A0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794308520-329618
X-HE-Meta: U2FsdGVkX18AqiSYuUnmdNlMYhqQ++rFBAnNacvJHhDXpAlSjNtWdiUiJ6JmSbI33xXNkJePdu1efGTtcv8IdJZqjuGhmBPgpQdhu/L/T05obxf7DvmA55AjUjeWPatiFT6CpS/Hc/RdToWuTYOiT6i8f8Z7zInQ81WgZ7edKuCeimBOpdYhhS325H7IjqmvfwClwW1XTdEazspXMQRYXJ7wp3EBaVRiz+efG72UAaIHesuleEydvYmRu32eMA0hIqSQfkc0fe8J8BbXUn1RlRpkmT5cX/qyxBgcKeepObe6uXQp1hp5r6wHxTmh9aNXF0uEN6j61hZud8CqxpYTHJq9cvKGmZj78dj5FwkJCFQT26k09/4lwVLBeEn/yJkvMlHDmtmJH23tFSoV+h4vE432PrJD1Yb4MPtYJ3bpj3TzvtKlPcBOxWEQUdirDWG6a+Fd5SaWYc1WQI84l46NvMp6cdZt27dsQFngGonq1cKlLj/vxTtYhhjM4/3Kg2KojG88QZE5zhtsn0eR/NYKHqzcFe+UZdFPMBerqc4WQNOOMgGCRgKm0H8Y9mUedn5fFK9gbwKZ7Gfl0lBrkbMS1VwIDlrgh2vq7J7blqICyy7i5ofeqIcHxPfCGAHFetB8ZG2fPjcc8hNvm/7ilseaOoYj/ZFikfEGLDh/CIrSt6/kTgny98dcLiFtXQd0aQZa24YtNYDM64AHXzg8uuxrcfIOtoh9xyXlCVxS4b05RgbgbzuiI0S3g+IIZRjZksnRd6m/a9epU9IKLWgzQUTuIq3CS41NTHixkATqVOD67xwHESSU91AChKrBtLa71wTOH8yjaJEtRoCllmYnxML+6oN1mWU/ZVZKnT38LxZviSR+K6DUuFArSE+vwpyw9s89/a5v2SpB5SsE2Er25mk5JadC0GZCeFssoRCfgzgtwQWlt8MV/INE0zHdqE8W9zmevlN0Ck3odZveBwRCmop
 JYydixoR
 MIk0s/dtHHHEPB9HZwYZozynfI/QBbUOrynPsJ300cik2ag17qx2/CXFGoz7Aw5suwrZ4Is/G/Q3teMz6FR5+qJKjOIryV3dSVzsBywoeADUovrDeVfzEGCsKecihVN9R2Q7hc1JQG42aphAeXgZxDM3r0IJyr2uE613BLurfWP/e63L3GElxXvJK1kDaBC88isNwgRDvJUvtwdLLyf6j0SpKMXam17AnbKa43zXvRVSdEjvEEsc7/n0ySwPBQzR0c0XSiVL+3/ZRUNoLxMBpoqiEghjUYBdrsTh5k0fIQgyXuDKcrs/aCJor7yM1Eh9ILSceScY6uQJYrBOmxpRZS3+XelHP4PT+WN24Nat7VeIm8vMNskfLfdBidpgZgmz/M+2jMT0m6xchUE0298dqXCuY2Vt676artz6sAxtmdREo/eYF6r5SvD37PYyBJ1yXd+GB/RlXCUwUDjh+t/U5HD91LFZQkbAjHvpYpdvBWY0dAKHnu9cUgu1eAFi4nrsCAHZaLpyv8DV2QmLFXrs2TwJ2f5iQp9isjesi+mB17ei18jWsO5faii1MW7u1VExZSRQmdQLLnj8BrEP0JIUe8YdFZbqvvit/5s5Jym3G4DdqVn7w3f/yQANFVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Low] riscv: mm: alloc_kernel_pgtable() duplicates pmd_alloc_one() and
  pud_alloc_one()
- [Low] riscv: mm: inaccurate comment and changelog on freeing linear
  map page tables
- [Low] riscv: mm: missing Fixes trailer for 311cd2f6e253 and RFC text
  in changelog
--

commit 1708f72f80d7427a70293de6013d47c497785abe
Author: li.hanting@zte.com.cn <li.hanting@zte.com.cn>

> riscv: mm: allocate split linear mapping page tables via the standard pag=
e table allocation APIs
>
> Hi,
>
> Commit 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel
> page tables") recently fixed a latent inconsistency in the x86 CPA code
> (assigned CVE-2026-97525): __split_large_page() allocated the new PTE
> page with a bare pagetable_alloc(), bypassing pte_alloc_one_kernel(), so
> the page table constructor never ran and the resulting page was neither
> flagged PG_table, nor accounted in NR_PAGETABLE, nor marked as a kernel
> page table.
>
> While looking at the fallout of that commit, I noticed that RISC-V
> open-codes the same pattern when splitting the linear mapping on behalf
> of set_memory_*(): __split_linear_mapping_{pmd,pud,p4d}() allocate the
> new page table pages with bare alloc_page(GFP_KERNEL) - three call
> sites in arch/riscv/mm/pageattr.c, introduced by 311cd2f6e253 ("riscv:
> Fix set_memory_XX() and set_direct_map_XX() by splitting huge linear
> mappings").
>
> The consequences are the same as on pre-fix x86: page tables that live
> in init_mm without the PG_table flag, without NR_PAGETABLE accounting
> and without the kernel ptdesc marking.
>
> To be clear about severity: this is a latent inconsistency, not an
> exploitable bug today. RISC-V never collapses the split linear mapping
> back, and these page tables are never freed, so there is no free-path
> mismatch of the kind the x86 fix was concerned about. But the
> accounting mismatch is real (/proc/vmstat under-counts kernel page
> tables), and any future work that frees these tables - linear map
> memory hotplug, collapse support or anything similar - would inherit
> the exact bug class the x86 fix addressed.
>
> This RFC aligns the three sites with the standard allocation paths:
>
>  - the PTE level switches to pte_alloc_one_kernel(), exactly like the
>    x86 fix;
>
>  - the PMD and PUD levels have no *_alloc_one_kernel() variant today,
>    so a small local helper wraps pagetable_alloc() +
>    __pagetable_ctor() + ptdesc_set_kernel(), mirroring what the
>    generic PTE path does. GFP_PGTABLE_KERNEL also brings in
>    __GFP_ZERO, which the open-coded allocation was missing.
>
> No functional change is intended; the observable difference is that
> split linear mapping page tables now show up in
> /proc/vmstat:nr_page_table_pages.
>
> Open questions:
>
>  1. Would it make sense to provide generic pmd_alloc_one_kernel() /
>     pud_alloc_one_kernel() variants in asm-generic/pgalloc.h so that
>     architectures do not have to open-code this dance? This is the
>     main reason this is an RFC rather than a regular patch.
>
>  2. Since these tables are never freed today, is it preferable to take
>     this alignment now (my preference: it removes a trap for any
>     future free-path work), or defer it until such work actually
>     lands?
>
>     (Note: the generic CPA rework series "[PATCH RFC 00/18] arch, mm:
>     create a generic set_memory/change_page_attr core" would eventually
>     replace this code entirely; this patch is intended as a small fix in
>     the meantime. The series author has said he is waiting for such
>     fixes to settle before posting a non-RFC version.)
>
> Comments welcome.
>
> Signed-off-by: Hanting Li <li.hanting@zte.com.cn>

[Severity: Low]
Should this include a Fixes: tag for the commit that introduced the open-co=
ded
alloc_page(GFP_KERNEL) calls:

  Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() =
by splitting huge linear mappings")

Also, the conversational notes ("Hi,", "Open questions:", "Comments welcome=
.")
belong below the "---" tear line so they do not end up in the git changelog.

> diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
> index 5b3cf326455db..f5608414b6fc0 100644
> --- a/arch/riscv/mm/pageattr.c
> +++ b/arch/riscv/mm/pageattr.c

[ ... ]

> @@ -93,6 +95,26 @@ static const struct mm_walk_ops pageattr_ops =3D {
>  };
> =20
>  #ifdef CONFIG_64BIT
> +/*
> + * Kernel page tables allocated for the split linear mapping are never
> + * freed today, but they must still go through the page table constructor
> + * so that they are flagged PG_table, accounted in NR_PAGETABLE and mark=
ed
> + * as kernel page tables, like any other kernel page table allocated via
> + * the standard allocation APIs.
> + */

[Severity: Low]
Is this comment (and the corresponding statement in the commit message)
accurate that split linear mapping page tables are never freed today?

Under CONFIG_MEMORY_HOTPLUG, arch_remove_memory() -> remove_linear_mapping()
walks the linear mapping and frees empty non-reserved PTE, PMD, and PUD page
tables via free_pte_table(), free_pmd_table(), and free_pud_table() ->
free_pgtable_page():

arch/riscv/mm/init.c:free_pgtable_page() {
	if (PageReserved(page))
		free_reserved_page(page);
	else
		pagetable_free(page_ptdesc(page));
}

If hotplugged memory has its linear mapping split via set_memory_*() or
set_direct_map_*() and is later hot-removed, those split page tables are fr=
eed
through pagetable_free(), which checks PageTable() and ptdesc_test_kernel().

> +static struct ptdesc *alloc_kernel_pgtable(void)
> +{
> +	struct ptdesc *ptdesc =3D pagetable_alloc(GFP_PGTABLE_KERNEL, 0);
> +
> +	if (!ptdesc)
> +		return NULL;
> +
> +	__pagetable_ctor(ptdesc);
> +	ptdesc_set_kernel(ptdesc);
> +
> +	return ptdesc;
> +}

[ ... ]

> @@ -149,24 +170,25 @@ static int __split_linear_mapping_pud(p4d_t *p4dp,
>  			continue;
> =20
>  		if (pud_leaf(pudp_get(pudp))) {
> -			struct page *pmd_page;
> +			struct ptdesc *ptdesc;
>  			unsigned long pfn =3D _pud_pfn(pudp_get(pudp));
>  			pgprot_t prot =3D __pgprot(pud_val(pudp_get(pudp)) & ~_PAGE_PFN_MASK);
>  			pmd_t *pmdp_new;
>  			int i;
> =20
> -			pmd_page =3D alloc_page(GFP_KERNEL);
> -			if (!pmd_page)
> +			ptdesc =3D alloc_kernel_pgtable();
> +			if (!ptdesc)
>  				return -ENOMEM;
> =20
> -			pmdp_new =3D (pmd_t *)page_address(pmd_page);
> -			for (i =3D 0; i < PTRS_PER_PMD; ++i, ++pmdp_new)
> -				set_pmd(pmdp_new,
> +			pmdp_new =3D (pmd_t *)ptdesc_address(ptdesc);

[ ... ]

> @@ -198,23 +220,23 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
>  			continue;
> =20
>  		if (p4d_leaf(p4dp_get(p4dp))) {
> -			struct page *pud_page;
> +			struct ptdesc *ptdesc;
>  			unsigned long pfn =3D _p4d_pfn(p4dp_get(p4dp));
>  			pgprot_t prot =3D __pgprot(p4d_val(p4dp_get(p4dp)) & ~_PAGE_PFN_MASK);
>  			pud_t *pudp_new;
>  			int i;
> =20
> -			pud_page =3D alloc_page(GFP_KERNEL);
> -			if (!pud_page)
> +			ptdesc =3D alloc_kernel_pgtable();
> +			if (!ptdesc)
>  				return -ENOMEM;
> =20
>  			/*
>  			 * Fill the pud level with leaf puds that have the same
>  			 * protections as the leaf p4d.
>  			 */
> -			pudp_new =3D (pud_t *)page_address(pud_page);
> -			for (i =3D 0; i < PTRS_PER_PUD; ++i, ++pudp_new)
> -				set_pud(pudp_new,
> +			pudp_new =3D (pud_t *)ptdesc_address(ptdesc);

[Severity: Low]
Can __split_linear_mapping_pud() and __split_linear_mapping_p4d() use the
existing generic pmd_alloc_one(&init_mm, vaddr) and pud_alloc_one(&init_mm,
vaddr) helpers instead of introducing alloc_kernel_pgtable()?

Unlike pte_alloc_one(), which returns pgtable_t and unconditionally uses
GFP_PGTABLE_USER, the generic pmd_alloc_one() and pud_alloc_one() in
include/asm-generic/pgalloc.h already check for mm =3D=3D &init_mm, select
GFP_PGTABLE_KERNEL, run the level-specific constructors pagetable_pmd_ctor()
and pagetable_pud_ctor() along with pmd_init() and pud_init(), call
ptdesc_set_kernel(), and return pmd_t * and pud_t * directly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/202611091101.6A9B1N=
f3015337@mse-db.zte.com.cn?part=3D1


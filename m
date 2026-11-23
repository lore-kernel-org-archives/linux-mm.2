Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC3A606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 02:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ga/B/e0Q
Received: by kanga.kvack.org (Postfix)
	id 6FCB16B00EF; Sun, 22 Nov 2026 21:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687166B05B0; Sun, 22 Nov 2026 21:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F4D6B05B1; Sun, 22 Nov 2026 21:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21EB16B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:47:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1412616075C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:47:53 +0000 (UTC)
X-FDA: 85464848826.30.B9DBE23
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id BFE18140005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:47:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ga/B/e0Q";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795402071;
	b=rUFjPAlRZPPbA64pNpEQxW+gfGvR0MHPJVfHUN2Brms5lxfO9IdcDtixJoYbxIty2o3pjt
	vnJpR88HB0z8YeLOQiGxFwl120CKR26qZGNf+5e8qnb8H8rKwSmGJ6gZ83ri9ezNJlGeXS
	5c8V9Ib3dW2ECBXvjWPONnHCWs6sM8I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795402071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keQB3M+G/U6WjdBKTwroAHxhrPCNUChEnSJ8dtIR1rc=;
	b=S6Z8qkIvs6FHCoCipbxWD5fvxYjfjvKdap3W5ZV1WZTmQdLH1xU7DHBpYldwp1S/JbbYcF
	y93rvJeI5+PsoSHJdmj29wr/7529/T8O+AMZSsAc8LTGKYAfJSdJgursk70wr4IuDDA/uC
	MD4Bqeg4NiNG0IsclDfmsOYXc4A++8g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ga/B/e0Q";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nnvohv3LVojod6b27B4KpgPlDmXt/sOZCq2yD9lZsww=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795402069; v=1; x=1796006869;
 b=Ga/B/e0Q+iDrVW4V4INlBxV/wc6ryReoF+UEJYDF38S6ftoZJzuySM5mmqv0TU2km5+hymL2
 pNuSvl+z+BTMIJLKPVqqVD0S/UVrDUCkYfAyerQiDIIrfOA+L4kWpD07WEghtTqjYVC9VS6Rra1
 fRCRFY7TqCMjED8li8u/Y16U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6a387cbfdc5f01e9;
	Mon, 23 Nov 2026 02:47:48 +0000
X-Mizu-Trace-ID: 6a387cbfdc5f01e9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 04/19] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261122184453.2668189-5-jthoughton@google.com>
Date: Mon, 23 Nov 2026 10:47:33 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4508589C-2E30-4DAB-9465-73121835D0D8@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-5-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BFE18140005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1i6n9mej8arym9wribo53ia5cfjjnxtd
X-HE-Tag: 1795402070-60931
X-HE-Meta: U2FsdGVkX18RohcrFlks5ulPNeXW2NiSkpYVXiPOg67AoxHnat8KAFozFiqWTd6m0ol4Eb/DSOAL4sW6BlyDLPtRpf6AWde0fEO3NLMDEnbIgNKO/LwI3P1059el0cixSdFSzEI91IIqZNetXqoDa4NmvQ2UOTtalG1xoOSXGCEEc3PbrADtpe5HU00B8ma9IVxZrpaxbYLLVGHCyrtxRD/KBdOXeNKWPOH2Zr4/J9NVMVkBVw3E0DWMAgUTZfL4HVmQVIgpRmh/u8Xz8P2zbCkt8LYfl9Q0jUCYgQiDQgmw5H9TJJ0VWSBnUMnWeS2hlLv5T+RkR79kJQwg15KYavcvTdxhvVA7lyDXKIDAszw8yrCz5lNMAUxF6oO4I66hFaki8dfjBCN4kHSyBzgOCSOEjuGbaCYICcKq+odfLBVSKY+Zk2aUgghzpzkz7mDFgJEo3lsfPUpaOBWkMO9NKuQNemrsV7MSSpzqyAECthW7KYqINdS0SL7bj29/VcDjMsMGmqcsctjStHwA1niqGgLdmn4u7insVcpWagtmG89PGeROhsLr1EZd3T9+Kmh2bcUfc8NsW5o1t0QxD/jdBwHlEv7Lf0fwPlYcsfqvLnfZsmkFIgVkksQa0WmbRPFeiXqkhl3TfmxDvo8KXL7i7rVLNWVTM3rWt2aMfLcSdWTclANsxGgB3NnjvFkHrbO+/gtx3hamlSsnPFokK/ThgZdDdUTCw2/T/BOR6ecmJmMwb2EzGlfm4YCzVzNfXAjXwSDFD8FdEd/EEfFZWAwVVas0byD7MjCUYPYRoh6eTfsOBXm/x2Y6vR6/TFPLPeylqEvmWNvroW61KWGorH5ArDDjpRBtGe7ev98dVWBZdaYQH/UDktnsxKS6RGAme4SZz58kTlLh0q/PRgsyqOrJHYTVi1kLiRlUVI7lKmhBnj2X34K8VNoY0Dxk2fzHjBK46s90ty1e/4Jbaeb7CQH
 sXT5Ohca
 xfzAKTsNe2BgVw2Bw/p9oHe1kq7Thc4kwnqtr+uGgwI1zGDUU9irJmwv3AYGrRNtVL0Zb4pRZIYzkd1kFgrMIuVuJocO+rCrm2/XL9+C7KcxOhtIOHFKVEpzIVS6Ou2YqnHRKe2J2VgTtcMf20nYN32+vgQL3p4ZxugC570UPDf3xYNaaeY//H1nJSA7M5eufl4mDx0SKFvKh3yriPGdNWUkRLD/39Dw+eGHEGrqwi0KdzxtrUqKji7FONSjZX8RCl87YvhOTlM/MLq+GzJP23lJX0CcTHQVC7/95PemkQUs66XiTzs01TTF4uA0fm+t1mqy/rUmOhNx4DeZQEiiQohpAYRcwwqJsKvngzIOOyP8dcaTwKbvXIHoRV3Wqr86WhRgIJALSp21/PKNJBnHTJHaBRcaG5PjE33YDhfilC/XRVHbXgtYFhm0zD3YcTrMhL3dM2aCH+OZ/bW+x/t74dFJtH8iYzG8YjBm70sQ7JhA21/LP8ybczLdHeQxBegt9XAJgrZFYoR68iVDkuePFNjOqpjJWQcOC4AzQLxSCxZknRrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>=20
> set_pte_at() cannot be used to replace in-use vmemmap PTEs on arm64, =
so
> replace it with a more specific routine, try_update_vmemmap_pte().
>=20
> try_update_vmemmap_pte() is used for modifying page table entries such
> that there is a guarantee that no fault will be taken.
>=20
> For the generic implementation, please note one difference: set_pte()
> does not invoke page_table_check_ptes_set(), but set_pte_at(), the =
call
> we are about to replace, does. However, this is a functional no-op
> because page_table_check_ptes_set() does nothing for init_mm PTEs, =
which
> vmemmap PTEs are.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> arch/loongarch/include/asm/pgtable.h |  2 ++
> arch/riscv/include/asm/pgtable.h     |  2 ++
> arch/x86/include/asm/pgtable.h       |  2 ++
> include/linux/pgtable.h              | 22 +++++++++++++++++++
> mm/hugetlb_vmemmap.c                 | 32 +++++++++++++++++++++++-----
> 5 files changed, 55 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/loongarch/include/asm/pgtable.h =
b/arch/loongarch/include/asm/pgtable.h
> index f87603135131..123eda3f6035 100644
> --- a/arch/loongarch/include/asm/pgtable.h
> +++ b/arch/loongarch/include/asm/pgtable.h
> @@ -633,6 +633,8 @@ static inline long pmd_protnone(pmd_t pmd)
> #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) !=3D 0)
> #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) !=3D 0)
>=20
> +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
> +
> /*
>  * We provide our own get_unmapped area to cope with the virtual =
aliasing
>  * constraints placed on us by the cache architecture.
> diff --git a/arch/riscv/include/asm/pgtable.h =
b/arch/riscv/include/asm/pgtable.h
> index 2ebd5fa5adc5..c8d05bc12cc8 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -1172,6 +1172,8 @@ static inline pud_t pud_modify(pud_t pud, =
pgprot_t newprot)
>=20
> #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>=20
> +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
> +
> /*
>  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs =
that
>  * are !pte_none() && !pte_present().
> diff --git a/arch/x86/include/asm/pgtable.h =
b/arch/x86/include/asm/pgtable.h
> index 000fc6c1ca37..271cdc61de3a 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1372,6 +1372,8 @@ static inline pmd_t pmdp_establish(struct =
vm_area_struct *vma,
> }
> #endif
>=20
> +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
> +
> #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> static inline pud_t pudp_establish(struct vm_area_struct *vma,
> 		unsigned long address, pud_t *pudp, pud_t pud)
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index bc1353f03b08..ab33df268955 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -458,6 +458,28 @@ static inline void set_ptes(struct mm_struct *mm, =
unsigned long addr,
> #endif
> #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, =
1)
>=20
> +#ifdef ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE

Why not ARCH_WANTS_VMEMMAP_UPDATE_PTE? Then x86, loogarch and RISC-V do =
not need define
this macro in their ptable.h.

> +/*
> + * try_update_vmemmap_pte - Remap PTEs used by the vmemmap.
> + * @addr: Base address of the remapped PTE.
> + * @ptep: Page table pointer to be overwritten.
> + * @pte: Page table entry to write.
> + *
> + * This function is only to be used to update PTEs that map the =
vmemmap. The
> + * only valid transitions supported by this function are: leaf-level
> + * (PAGE_SIZE), valid-to-valid. The pfn and prot bits may be changed.
> + *
> + * Implementations of this function must ensure that, while the =
update is taking
> + * place, CPUs will not fault on the remapped virtual address.
> + */
> +static inline int try_update_vmemmap_pte(unsigned long addr, pte_t =
*ptep,
> +					 pte_t pte)

Please rename it to vmemmap_update_pte, all HVO-related helpers will be =
prefixed
with vmemmap.

Again, I still recommend having this function return void. That will =
make the
overall code simpler. If we actually run into related issues in the =
future, we
can add support for it then. I don't want to introduce unnecessary code
maintenance now.

Thanks,
Muchun

> +{
> +	set_pte(ptep, pte);
> +	return 0;
> +}
> +#endif
> +
> #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
> extern int ptep_set_access_flags(struct vm_area_struct *vma,
> 				 unsigned long address, pte_t *ptep,
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 2e9cf8d39c89..b4d0311bcc4a 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -218,15 +218,19 @@ static int alloc_vmemmap_page_list(struct =
list_head *head,
> 	return -ENOMEM;
> }
>=20
> +/*
> + * Copy @src into the first page on @vmemmap_pages and return it. The =
page is
> + * left on the list; the caller must remove it only once it has =
successfully
> + * been installed in the vmemmap.
> + */
> static struct page *vmemmap_dup_page_from_list(const struct page *src,
> 		struct list_head *vmemmap_pages)
> {
> 	struct page *dst =3D list_first_entry(vmemmap_pages, struct =
page, lru);
>=20
> -	list_del(&dst->lru);
> 	copy_page(page_address(dst), page_address(src));
>=20
> -	/* Ensure updates to @dst page are visible before set_pte_at(). =
*/
> +	/* Ensure updates to @dst page are visible before =
try_update_vmemmap_pte(). */
> 	smp_wmb();
>=20
> 	return dst;
> @@ -248,6 +252,8 @@ static int vmemmap_optimize_pte(pte_t *pte, =
unsigned long addr,
> 	const struct page *page =3D (const struct page *)addr;
> 	const struct folio *folio =3D page_folio(page);
> 	struct page *src =3D pte_page(ptep_get(pte)), *dst;
> +	bool dup =3D false;
> +	int ret;
>=20
> 	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), =
folio_order(folio)))) {
> 		dst =3D folio_vmemmap_shared_tail_page(folio);
> @@ -255,16 +261,27 @@ static int vmemmap_optimize_pte(pte_t *pte, =
unsigned long addr,
> 			return -ENOMEM;
> 	} else {
> 		dst =3D vmemmap_dup_page_from_list(src, =
walk->vmemmap_pages);
> +		dup =3D true;
> 	}
>=20
> -	list_add(&src->lru, walk->vmemmap_pages);
> 	/*
> 	 * Map the shared tail page writable intentionally. A lockless =
get that
> 	 * read a non-zero refcount before the remap can still do its =
cmpxchg
> 	 * after it. The refcount is zero, so the cmpxchg fails and =
leaves the
> 	 * page unchanged.
> 	 */
> -	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
> +	ret =3D try_update_vmemmap_pte(addr, pte, mk_pte(dst, =
PAGE_KERNEL));
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * We successfully overwrote the vmemmap PTE, so the page that =
was just
> +	 * unmapped can be freed, and if we mapped a duplicated page, =
remove it
> +	 * from the list so that it doesn't get freed later.
> +	 */
> +	if (dup)
> +		list_del(&dst->lru);
> +	list_add(&src->lru, walk->vmemmap_pages);
>=20
> 	return 0;
> }
> @@ -275,6 +292,7 @@ static int vmemmap_restore_pte(pte_t *pte, =
unsigned long addr,
> 	const struct page *page =3D (const struct page *)addr;
> 	const struct folio *folio =3D page_folio(page);
> 	struct page *src =3D pte_page(ptep_get(pte)), *dst, *tail;
> +	int ret;
>=20
> 	if (unlikely(!vmemmap_optimizable_pfn(page_to_pfn(page), =
folio_order(folio))))
> 		return 0;
> @@ -291,7 +309,11 @@ static int vmemmap_restore_pte(pte_t *pte, =
unsigned long addr,
> 		return 0;
>=20
> 	dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
> -	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
> +	ret =3D try_update_vmemmap_pte(addr, pte, mk_pte(dst, =
PAGE_KERNEL));
> +	if (ret)
> +		return ret;
> +
> +	list_del(&dst->lru);
>=20
> 	return 0;
> }
> --=20
> 2.56.1.809.ga0b61035b5-goog
>=20



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27017606A68B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t6cAU+2B
Received: by kanga.kvack.org (Postfix)
	id C51DE6B05BC; Mon, 23 Nov 2026 21:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C029A6B05C0; Mon, 23 Nov 2026 21:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC98D6B05C1; Mon, 23 Nov 2026 21:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5590D6B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:29:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 980B9A0785
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:29:44 +0000 (UTC)
X-FDA: 85468431888.12.AE7F74D
Received: from mta1.migadu.com (out-162.mta1.migadu.com [95.215.58.162])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6C23820007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:29:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t6cAU+2B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795487382;
	b=AmnX60wos70wkR1swu6oBEupsI7TEq7AnDZTDTe+qi3jDJnoyj8M/KM+cX/pa1tfoUQttM
	v0ldMMsVNOrBKn+Qi6WzDFaKHo9zwLR4HtFmESvbCDmmgPWdPL2M6nS7bjUTkrh1+iyfaM
	JNFbzhJ5heX8KPWifK0KESq4oCY4574=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795487382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18r5tD9y2ALIX7X7Kv9k6QsRP9npRMqolTYhIPTl4so=;
	b=M8T1QWdvxd7Nf6QogYqgqFu6aMoQBISmZxKlfA3csS7NsqFRb7Hft6HOGlNtORaATI4mE/
	lPmKEIYtG8HxrOPdlriW8cqSsQJ2Bt4HTLf9ffGYuwHjVk+MA9mvZXBhkHmbTnJgVgWHpw
	1LKk7J0hw9IE24QJzrz2ahKMUXVzONI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t6cAU+2B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.162 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bKdavHn4Gjkl6Bx3sYPvnFvwvriR5ITOlurhR8mBhXw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795487381; v=1; x=1796092181;
 b=t6cAU+2Bv3v1WcGrFVBGWgpe8IFNzbhM2ln3PsfgIirTnzYYZFzT2Zqzyt+Rku3+xT7EKtmH
 OvViD/l6cknN8+M4I46IYyN8V50z4iUVGVd2EmagOWuRL6HyyBtwUfHSFoNsbn1/QvyUuHvCfL0
 9heleEeqkkj80GZqvmXAtp3o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 42d52afc46ba6af1;
	Tue, 24 Nov 2026 02:29:40 +0000
X-Mizu-Trace-ID: 42d52afc46ba6af1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 04/19] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HUstWR2pajfYYzRqL7HziVfzZAXJas6MqJkK6pVxSzXEg@mail.gmail.com>
Date: Tue, 24 Nov 2026 10:29:22 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
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
Message-Id: <4A195604-B83B-4608-B32E-5F6CC85AE96F@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-5-jthoughton@google.com>
 <4508589C-2E30-4DAB-9465-73121835D0D8@linux.dev>
 <CADrL8HUstWR2pajfYYzRqL7HziVfzZAXJas6MqJkK6pVxSzXEg@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 6C23820007
X-Stat-Signature: 7ii8ydnnidfefp5uuhim6xc7rk1exdto
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795487382-821006
X-HE-Meta: U2FsdGVkX19QxO7xptq06Kr+hOhd7tCEVdC6/8AQ1yp1sEhYW3UuI4rt7w2rx7+judIFIgsMi+2PcKOXsQ2e2wTGAw+329a40l6ZLydpJY5qsh8/8efKWvidtBQYpW+gbrWvC1CFVY1zg2V29Eh0lPsBs/wQHjQC0bdNW3QdqwVSIJNwqbZT0v5qgqXpVvs/A6BmFP5Q+lpdhscv8RwEEk2zy0cY5DKL8NPaKsdLBYmWpkBZ0AhWqbVO4WoonfMuOS1vAAFMoPvpZ7BApbZ0SpLyXEUPCYzR6y0MPahIjXZA13cXESGw4GEXpUMpWH8HpkYqpdjcLKjnh/RFfd/snBlEwnGEHAlsZBvj3m2hutAmj5s+a22Wp+DSmsBanthgf6E4qrRSGxw9lN1cELL3Xw1UIIUVi/Fsb++zI2jB+BM3edM7OebKGTQqR69vZn9b5w6T/Eny60BHNo2j+lva984BLT08oqno1FiZa+Brzc3d4oh+Hx/smoUp5Xk+GK3QLyINOF97b26FoOdpv0mrPefbLdy4g68dXbdQtPvS7gfP2/WDu4BhRsLl60BW8GpybiTyItrXAHYs1eKGzeJBm3aNEi2s5ae/Tqwx2sfZ5YLMIArxUCdW72j6lB5Th/UDbiKaWovSavSGOdeS5nQBAlqv+MwK+pGmXP/ZoWkbcIqjH42sBkoleXkFwDD4hDPVFeI4R147g+tymuOu4nSEgbEYt0ArUowXGzRmoJo2sgU2QSY4qjn37hInJwVNUDTAhKTbiH7uX5E2jioptssWZHrj1AwQ50qM/kgSpeuKNOTvKUhAA/mQ/afeFDD6Pgr1DrwIvcOJhyxfx6234r3LjI8+mgSpSpHfMD0lTBKOcpJBqHIB9hY5x9jGvxXS/9F7mW5tHNCSyRstcjVsEbZDt2bBVQtyEDKtp4I1NuSUKWdHK0rNpf8v3eixYzAEpxXcNsZQjI+pHZmf+B38nWi
 4nkUrTSp
 Fqm/lwcmx3PVena/SP6JvfCx1aTLQrU82vdHwYyyPIJzaMVA2gz8JnpofT5fMzOPYHse/tr5CyhGveoSsKDcMKhjFslR9gqJyU8rh7Yq9s234Yoio8ZYEnZwhmgLA3HPUpK45Uk7Tnmnay5P0+JQZgX1FnjC6+KE20lhxtDGGljXQMeq0X9zbR1ULyPXcaIHdDYESlU5wZI00RZT0XqNPOiK2AUKqVvAtVyDbhNOO5nrU55cFfifaJa+CxUhU/orZ3EFrWmUArMi+7ZDltTPvyzIyQBk051/ZEm7t81paqcouTmU0U2JumqawcEyuoHrWj3NgxAX7VWER3OzSeQMP718a3rADRD+Zj/+1/yxmBT850XKf9iMTiBvGZI1RLChJakTDUtsEtwMnlkYl6eGU8+qHbTNszp3APkT3ZGsVSJBQx3EqYWwZFvHC0NO5loSn1+B3CTVjVS+2+K3vsPY3+nj8MIRe0P2fWfcE9BgMV9GpQsWh6CsIy6DpbVyI2Du6mFUkinolFbustdZwRfvxcsNVG/ihsZ2NJzS3cDGAV0gKPqWGgr9GU0+za432mHiNbTjEkhCGml+S/SzekifMSj96mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 24, 2026, at 04:48, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Sun, Nov 22, 2026 at 9:47=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>=20
>>=20
>>> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> set_pte_at() cannot be used to replace in-use vmemmap PTEs on arm64, =
so
>>> replace it with a more specific routine, try_update_vmemmap_pte().
>>>=20
>>> try_update_vmemmap_pte() is used for modifying page table entries =
such
>>> that there is a guarantee that no fault will be taken.
>>>=20
>>> For the generic implementation, please note one difference: =
set_pte()
>>> does not invoke page_table_check_ptes_set(), but set_pte_at(), the =
call
>>> we are about to replace, does. However, this is a functional no-op
>>> because page_table_check_ptes_set() does nothing for init_mm PTEs, =
which
>>> vmemmap PTEs are.
>>>=20
>>> Signed-off-by: James Houghton <jthoughton@google.com>
>>> ---
>>> arch/loongarch/include/asm/pgtable.h |  2 ++
>>> arch/riscv/include/asm/pgtable.h     |  2 ++
>>> arch/x86/include/asm/pgtable.h       |  2 ++
>>> include/linux/pgtable.h              | 22 +++++++++++++++++++
>>> mm/hugetlb_vmemmap.c                 | 32 =
+++++++++++++++++++++++-----
>>> 5 files changed, 55 insertions(+), 5 deletions(-)
>>>=20
>>> diff --git a/arch/loongarch/include/asm/pgtable.h =
b/arch/loongarch/include/asm/pgtable.h
>>> index f87603135131..123eda3f6035 100644
>>> --- a/arch/loongarch/include/asm/pgtable.h
>>> +++ b/arch/loongarch/include/asm/pgtable.h
>>> @@ -633,6 +633,8 @@ static inline long pmd_protnone(pmd_t pmd)
>>> #define pmd_leaf(pmd)         ((pmd_val(pmd) & _PAGE_HUGE) !=3D 0)
>>> #define pud_leaf(pud)         ((pud_val(pud) & _PAGE_HUGE) !=3D 0)
>>>=20
>>> +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
>>> +
>>> /*
>>> * We provide our own get_unmapped area to cope with the virtual =
aliasing
>>> * constraints placed on us by the cache architecture.
>>> diff --git a/arch/riscv/include/asm/pgtable.h =
b/arch/riscv/include/asm/pgtable.h
>>> index 2ebd5fa5adc5..c8d05bc12cc8 100644
>>> --- a/arch/riscv/include/asm/pgtable.h
>>> +++ b/arch/riscv/include/asm/pgtable.h
>>> @@ -1172,6 +1172,8 @@ static inline pud_t pud_modify(pud_t pud, =
pgprot_t newprot)
>>>=20
>>> #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>>=20
>>> +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
>>> +
>>> /*
>>> * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs =
that
>>> * are !pte_none() && !pte_present().
>>> diff --git a/arch/x86/include/asm/pgtable.h =
b/arch/x86/include/asm/pgtable.h
>>> index 000fc6c1ca37..271cdc61de3a 100644
>>> --- a/arch/x86/include/asm/pgtable.h
>>> +++ b/arch/x86/include/asm/pgtable.h
>>> @@ -1372,6 +1372,8 @@ static inline pmd_t pmdp_establish(struct =
vm_area_struct *vma,
>>> }
>>> #endif
>>>=20
>>> +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
>>> +
>>> #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>> static inline pud_t pudp_establish(struct vm_area_struct *vma,
>>>              unsigned long address, pud_t *pudp, pud_t pud)
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index bc1353f03b08..ab33df268955 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -458,6 +458,28 @@ static inline void set_ptes(struct mm_struct =
*mm, unsigned long addr,
>>> #endif
>>> #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, =
pte, 1)
>>>=20
>>> +#ifdef ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
>>=20
>> Why not ARCH_WANTS_VMEMMAP_UPDATE_PTE? Then x86, loogarch and RISC-V =
do not need define
>> this macro in their ptable.h.
>=20
> You're basically asking to make this opt-out instead of opt-in, right?

Yes, exactly.

>=20
> I like making the different architectures explicitly opt in to the
> generic implementation; it forces any new architecture to decide if
> the generic implementation is correct for them. But I don't feel
> strongly.

We already have an opt-in config: ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP.
It already forces new architectures to pay attention to it.

Thanks,
Muchun

>=20
> I'll switch it to opt-out in v4 unless you or someone else tells me =
otherwise.
>=20
>>=20
>>> +/*
>>> + * try_update_vmemmap_pte - Remap PTEs used by the vmemmap.
>>> + * @addr: Base address of the remapped PTE.
>>> + * @ptep: Page table pointer to be overwritten.
>>> + * @pte: Page table entry to write.
>>> + *
>>> + * This function is only to be used to update PTEs that map the =
vmemmap. The
>>> + * only valid transitions supported by this function are: =
leaf-level
>>> + * (PAGE_SIZE), valid-to-valid. The pfn and prot bits may be =
changed.
>>> + *
>>> + * Implementations of this function must ensure that, while the =
update is taking
>>> + * place, CPUs will not fault on the remapped virtual address.
>>> + */
>>> +static inline int try_update_vmemmap_pte(unsigned long addr, pte_t =
*ptep,
>>> +                                      pte_t pte)
>>=20
>> Please rename it to vmemmap_update_pte, all HVO-related helpers will =
be prefixed
>> with vmemmap.
>=20
> Okay, will do.
>=20
>>=20
>> Again, I still recommend having this function return void. That will =
make the
>> overall code simpler. If we actually run into related issues in the =
future, we
>> can add support for it then. I don't want to introduce unnecessary =
code
>> maintenance now.
>=20
> Thanks. I will just point back to my reply from v2[1]. I hope Catalin
> or Will have thoughts on this.
>=20
> [1] =
https://lore.kernel.org/linux-mm/CADrL8HWNaurYHGnpvC9qwr6bVU74YhhucCuhoVYc=
vqmSX+R6+Q@mail.gmail.com/
>=20
>>=20
>> Thanks,
>> Muchun
>>=20
>>> +{
>>> +     set_pte(ptep, pte);
>>> +     return 0;
>>> +}
>>> +#endif
>>> +
>>> #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
>>> extern int ptep_set_access_flags(struct vm_area_struct *vma,
>>>                               unsigned long address, pte_t *ptep,
>>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>>> index 2e9cf8d39c89..b4d0311bcc4a 100644
>>> --- a/mm/hugetlb_vmemmap.c
>>> +++ b/mm/hugetlb_vmemmap.c
>>> @@ -218,15 +218,19 @@ static int alloc_vmemmap_page_list(struct =
list_head *head,
>>>      return -ENOMEM;
>>> }
>>>=20
>>> +/*
>>> + * Copy @src into the first page on @vmemmap_pages and return it. =
The page is
>>> + * left on the list; the caller must remove it only once it has =
successfully
>>> + * been installed in the vmemmap.
>>> + */
>>> static struct page *vmemmap_dup_page_from_list(const struct page =
*src,
>>>              struct list_head *vmemmap_pages)
>>> {
>>>      struct page *dst =3D list_first_entry(vmemmap_pages, struct =
page, lru);
>>>=20
>>> -     list_del(&dst->lru);
>>>      copy_page(page_address(dst), page_address(src));
>>>=20
>>> -     /* Ensure updates to @dst page are visible before =
set_pte_at(). */
>>> +     /* Ensure updates to @dst page are visible before =
try_update_vmemmap_pte(). */
>>>      smp_wmb();
>>>=20
>>>      return dst;
>>> @@ -248,6 +252,8 @@ static int vmemmap_optimize_pte(pte_t *pte, =
unsigned long addr,
>>>      const struct page *page =3D (const struct page *)addr;
>>>      const struct folio *folio =3D page_folio(page);
>>>      struct page *src =3D pte_page(ptep_get(pte)), *dst;
>>> +     bool dup =3D false;
>>> +     int ret;
>>>=20
>>>      if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), =
folio_order(folio)))) {
>>>              dst =3D folio_vmemmap_shared_tail_page(folio);
>>> @@ -255,16 +261,27 @@ static int vmemmap_optimize_pte(pte_t *pte, =
unsigned long addr,
>>>                      return -ENOMEM;
>>>      } else {
>>>              dst =3D vmemmap_dup_page_from_list(src, =
walk->vmemmap_pages);
>>> +             dup =3D true;
>>>      }
>>>=20
>>> -     list_add(&src->lru, walk->vmemmap_pages);
>>>      /*
>>>       * Map the shared tail page writable intentionally. A lockless =
get that
>>>       * read a non-zero refcount before the remap can still do its =
cmpxchg
>>>       * after it. The refcount is zero, so the cmpxchg fails and =
leaves the
>>>       * page unchanged.
>>>       */
>>> -     set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
>>> +     ret =3D try_update_vmemmap_pte(addr, pte, mk_pte(dst, =
PAGE_KERNEL));
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     /*
>>> +      * We successfully overwrote the vmemmap PTE, so the page that =
was just
>>> +      * unmapped can be freed, and if we mapped a duplicated page, =
remove it
>>> +      * from the list so that it doesn't get freed later.
>>> +      */
>>> +     if (dup)
>>> +             list_del(&dst->lru);
>>> +     list_add(&src->lru, walk->vmemmap_pages);
>>>=20
>>>      return 0;
>>> }
>>> @@ -275,6 +292,7 @@ static int vmemmap_restore_pte(pte_t *pte, =
unsigned long addr,
>>>      const struct page *page =3D (const struct page *)addr;
>>>      const struct folio *folio =3D page_folio(page);
>>>      struct page *src =3D pte_page(ptep_get(pte)), *dst, *tail;
>>> +     int ret;
>>>=20
>>>      if (unlikely(!vmemmap_optimizable_pfn(page_to_pfn(page), =
folio_order(folio))))
>>>              return 0;
>>> @@ -291,7 +309,11 @@ static int vmemmap_restore_pte(pte_t *pte, =
unsigned long addr,
>>>              return 0;
>>>=20
>>>      dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
>>> -     set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
>>> +     ret =3D try_update_vmemmap_pte(addr, pte, mk_pte(dst, =
PAGE_KERNEL));
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     list_del(&dst->lru);
>>>=20
>>>      return 0;
>>> }
>>> --
>>> 2.56.1.809.ga0b61035b5-goog




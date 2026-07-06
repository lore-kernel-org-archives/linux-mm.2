Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0F4C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 05:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E632B6B009E; Mon,  6 Jul 2026 01:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A506B009F; Mon,  6 Jul 2026 01:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02FD6B00A0; Mon,  6 Jul 2026 01:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 989A16B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:38:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 105CB1C72FF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:38:53 +0000 (UTC)
X-FDA: 84957247746.19.3929F80
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2602940007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:38:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ReOqUr2E;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783316331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUAU5zbAPO0Js6yoKRIHKJlwUkpSoy0U+ADQkMAFvw4=;
	b=hcZkXC2EnOY6ozzU2oVOqSJyjNOOQ4mqwbZFN0vDHMvzIY3dnUlDG2ZvTb0YCbMo3fehqd
	cNChn1T99vlUXd2FufdoVcXw1esM+JbLLLotfDEaClMlNyUFNyRSsIZ4jDZuU0Sc4mXo7q
	6QC7evqAlTt1EuAL/UqkcGNf7tdtLxI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ReOqUr2E;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783316331;
	b=p+DUtnVfoXv5TJzaBG9iQdTDEhwjQAU9q9RTF74dtJX/bp5b1UhKZndyq/6n0THuBqV8CG
	VYuX8lcKAEXCk+5rUo9oWNAJ7yScOoTo3pH8/1nEPoKJ53UEA4YbzbU2bKnH6zcK7PUnEk
	ii7UKngwCKCUnSQL+cm2XETWSj79/Y8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783316328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pUAU5zbAPO0Js6yoKRIHKJlwUkpSoy0U+ADQkMAFvw4=;
	b=ReOqUr2ENps7GNtouB5b1kq70v6+GMA+MmHm4Lu4YoiIGaj08ODM4aUZ27AuI6XXzvyxq7
	hAlCU/HhLOoI89xWph7v0c5H5EQhaPUoGzux1IrgOXvxHWDJXc0zZaYyaDWGRsec874IAy
	SoEyYaa7fdTGn8n6VgHu24jYI0pKsgU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <5fac578c-ff97-4721-96f3-8ba495f0556a@iscas.ac.cn>
Date: Mon, 6 Jul 2026 13:38:06 +0800
Cc: linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <214FC970-465A-4E45-98C0-17978D63DE89@linux.dev>
References: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
 <7B0CB4ED-C190-4F49-97EE-E1F14F08DED2@linux.dev>
 <5fac578c-ff97-4721-96f3-8ba495f0556a@iscas.ac.cn>
To: Vivian Wang <wangruikang@iscas.ac.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2602940007
X-Stat-Signature: 7ccjgoz8mxqiz75x11z69sd6t3nczgxn
X-Rspam-User: 
X-HE-Tag: 1783316330-36917
X-HE-Meta: U2FsdGVkX1/2bchKGGTLKHbHiXL3MjfYiuPH4dxRRD09VC3p/l+5jd/c0nh/LO7efDJ3dTMhq3d3kKef4cRZHcKA9sL01qs7EmcYCB4EPYANzlXcmry1FCvCekCF0m/9zgcsV3v1tGBzRg4qo8r9QQfBlCEzqvDSKovewJpVw/W+37HeFGj0CER4Rcsd+pB2Eq+zjO+KjqndZEWs3yubmWqMbRxiSIX07AcX6j3bvebIGDTeN8sxndeiFKNg2ZWJ0k77y5Ec0qY609HJ4YgHjPWsOzKmVrddNF0wz3BX2xfh8ej/lJ8iX4xQn/Qc3u5WlZCE8wkXkn9sWiK1D17McotvcoF+kWKpSIXXBefJExuj/b4xsrmk9bH4lsqQek/XARmv/rC39cG3T3ilpIMGrpCUQ0dMe3AoaJPHBi7V0IJ4+kXMffzZt5UlUf0NjkgHCI5JER5VrdHN0g+g4YQUYcdjOTg0dKKa/S4gLE02O4zAoGwAF/+JgAf371bor7BNogf0yvNelJjjjQvNYWW2ChcWNe4G0zdImeTIKUeFlrvNVCy2YEIRi5fLuWcHgb4KgkbbsRRsHLp/swtQsjXSoaYnPPg3ANjwztkuR84ajIJ+ez30xSSgVwZrOKKpMlewcWcU6ICb+dUkaD/2FFTX0O6JE6DXf/d4WEs40KY64xORvqL66Vb39n9RFZAL/e0qlbcLdRIMfrAFxBpn4mNVzajpt9VTFzJ9kphuJOfptHdUI0HbAkgTLGy0Jhm/BS+dssfRMhOq7d7gHMuqX42mDTJonolD8f+JbclEQNwNNTvkfeSHKyOUzNn1hOGz8rmHzKISdnpvV4oYm9XfJk4I/J7zqGzD6U8w31sdaajLxOoEenp1Z7bc95QscG71eDE+ZffnxpKUTo1eLOHQ3HloTTkhos+n6oWUzWy1rDQjGZ1dt9G4EFPlw68gK1FZBFAvOJLj6bSyvZI1xxcL6I4
 03PO0Bqf
 EDkNwpROUUmNNectAn2g1bjl1fVZwmgmd4nd1MuAKzpfFoSEyFht9GfyBmX5aOSwtbrDVInIVscZvYrOF0AiA1JyS/k0dviEmd2HNVMTrT9kEyhNr0ozzsP5iRDIIVIggEtWa7E7uDwukZG2Cvpy23fJ/n6H9Nva/ym9ETOJK2DKuKLj3RIalUbyL1PnoStz4XariqOMhxNyJtFwezd1pkUv0t+s2YEBhGqZVgaw4TeUDaUiReOY9eNWisycS86B21uhrWBLa3LdyD8ABE+gsQkHOg52sSmcIW7EUawy9dPEyDQqwqxKYb2Zo420OyN37T4ITqZaDVezcgwPE/obQTsokLUn8BbMQBx0h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 6, 2026, at 13:04, Vivian Wang <wangruikang@iscas.ac.cn> wrote:
>=20
> [ powerpc maintainers: Thoughts on replacing the ptesync in
> vmemmap_set_pmd() with a flush_cache_vmap() post-vmemmap-hotplug in =
the
> generic code? ]
>=20
> On 7/6/26 11:00, Muchun Song wrote:
>>> On Jun 30, 2026, at 15:51, Vivian Wang <wangruikang@iscas.ac.cn> =
wrote:
>>>=20
>>> section_activate() does not flush TLB after populating new vmemmap
>>> pages. On most architectures, this is okay. However it is a problem =
on
>>> RISC-V since there the TLB caching non-present entries is permitted,
>>> which causes spurious faults on some hardwares.
>>>=20
>>> This seems to be most easily reproduced with DEBUG_VM=3Dy and
>>> PAGE_POISONING=3Dy, which causes these newly mapped struct pages to =
be
>>> poisoned i.e. written to immediately after mapping.
>>>=20
>>> Add a hook vmemmap_populate_finalize() in =
__populate_section_memmap()
>>> after population, to allow architectures to handle such situations =
as
>>> needed. Then implement it on RISC-V to arrange for the existing
>>> exception handler code to deal with these faults if they happen.
>>>=20
>>> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
>>> ---
>>> Changes in v4:
>>> - Rebase on v7.2-rc1, drop dependencies
>>> - (No code changes otherwise)
>>> - (A concurrency fix for mark_new_valid_map was sent independently)
>>> =
https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-valid-map-orderi=
ng-v1-1-60d8c10c6292@iscas.ac.cn/
>>> - Link to v3: =
https://patch.msgid.link/20260605-mark-after-vmemmap-populate-v3-1-a06001a=
c9264@iscas.ac.cn
>>>=20
>>> Changes in v3:
>>> - Merged back into one patch (Mike)
>>> - (No code changes otherwise.)
>>> - Link to v2: =
https://patch.msgid.link/20260604-mark-after-vmemmap-populate-v2-0-ab6a7d0=
3b434@iscas.ac.cn
>>>=20
>>> Changes in v2:
>>> - Split patch in two, hook point and riscv hook=20
>>> - Explain hook necessity in patch 1 message (Mike)
>>> - Make hook #define based (Mike)
>>> - Call finalize hook only on populate success
>>> - Link to v1: =
https://patch.msgid.link/20260525-mark-after-vmemmap-populate-v1-1-e698d85=
9ba16@iscas.ac.cn
>>> ---
>>> arch/riscv/include/asm/pgtable.h | 4 ++++
>>> arch/riscv/mm/init.c             | 6 ++++++
>>> mm/sparse-vmemmap.c              | 8 ++++++++
>>> 3 files changed, 18 insertions(+)
>>>=20
>>> diff --git a/arch/riscv/include/asm/pgtable.h =
b/arch/riscv/include/asm/pgtable.h
>>> index 5d5756bda82e..6b000c990ba7 100644
>>> --- a/arch/riscv/include/asm/pgtable.h
>>> +++ b/arch/riscv/include/asm/pgtable.h
>>> @@ -1253,6 +1253,10 @@ static inline pte_t =
pte_swp_clear_exclusive(pte_t pte)
>>> #define TASK_SIZE FIXADDR_START
>>> #endif
>>>=20
>>> +/* Needed on SPARSEMEM_VMEMMAP */
>>> +#define vmemmap_populate_finalize vmemmap_populate_finalize
>>> +void __meminit vmemmap_populate_finalize(void);
>>> +
>>> #else /* CONFIG_MMU */
>>>=20
>>> #define PAGE_SHARED __pgprot(0)
>>> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
>>> index 5b1b3c88b4d1..800cb5c007d1 100644
>>> --- a/arch/riscv/mm/init.c
>>> +++ b/arch/riscv/mm/init.c
>>> @@ -1372,6 +1372,12 @@ int __meminit vmemmap_populate(unsigned long =
start, unsigned long end, int node,
>>> */
>>> return vmemmap_populate_hugepages(start, end, node, altmap);
>>> }
>>> +
>>> +void __meminit vmemmap_populate_finalize(void)
>>> +{
>>> +  /* Avoid faults on cached non-present TLB entries. */
>>> +  mark_new_valid_map();
>>> +}
>>> #endif
>>>=20
>>> #if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>> index 99e2be39671b..290cafcfd723 100644
>>> --- a/mm/sparse-vmemmap.c
>>> +++ b/mm/sparse-vmemmap.c
>>> @@ -544,6 +544,12 @@ static int __meminit =
vmemmap_populate_compound_pages(unsigned long start_pfn,
>>>=20
>>> #endif
>>>=20
>>> +#ifndef vmemmap_populate_finalize
>>> +static void __meminit vmemmap_populate_finalize(void)
>>> +{
>>> +}
>>> +#endif
>>> +
>>> struct page * __meminit __populate_section_memmap(unsigned long pfn,
>>> unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>>> struct dev_pagemap *pgmap)
>>> @@ -564,6 +570,8 @@ struct page * __meminit =
__populate_section_memmap(unsigned long pfn,
>>> if (r < 0)
>>> return NULL;
>>>=20
>>> +  vmemmap_populate_finalize();
>> Does the hook of flush_cache_vmap() work for you?  =46rom the =
document of
>> cachetlb.rst, it said:=20
>>=20
>> 6) ``void flush_cache_vmap(unsigned long start, unsigned long end)``
>>    ``void flush_cache_vunmap(unsigned long start, unsigned long =
end)``
>>=20
>> Here in these two interfaces we are flushing a specific range
>> of (kernel) virtual addresses from the cache. After running,
>> there will be no entries in the cache for the kernel address
>> space for virtual addresses in the range 'start' to 'end-1'.
>>=20
>> It seems that flush_cache_vmap() is supposed to be called after a new =
kernel
>> mapping has been installed, but before this address range is =
accessed.
>=20
> Good point. I had initially avoided flush_cache_vmap() because, to be
> honest, it looked scary. But the combination of "have vmemmap" and =
"have
> flush_cache_vmap()" is much less scary.
>=20
> I'd need to drop the address range check in RISC-V's =
flush_cache_vmap(),
> but might as well.

No. Please a new check for vmemmap address range.

>=20
>> Therefore, invoking flush_cache_vmap() here aligns perfectly with its =
interface
>> definition. But how would this change impact other architectures? =
Currently,
>> among architectures where CONFIG_SPARSEMEM=3Dy, only RISC-V and =
PowerPC provide
>> a concrete implementation for flush_cache_vmap().
>>=20
>> For PowerPC, the implementation is as follows:
>>=20
>> static inline void flush_cache_vmap(unsigned long start, unsigned =
long end)
>> {
>> asm volatile("ptesync" ::: "memory");
>> }
>>=20
>> Here, flush_cache_vmap() is also intended to supply the ptesync =
instruction
>> that the kernel address mapping lacks. However, flush_cache_vmap() is =
not
>> called in the __populate_section_memmap() path. So, how does PowerPC =
ensure
>> ptesync is executed there? The answer lies in the =
architecture-specific
>> vmemmap_set_pmd(), which injects the necessary ptesync.
>>=20
>> If we choose to reuse flush_cache_vmap() in the generic path, it =
yields the
>> following benefits:
>>=20
>> - Avoids architectural churn: We do not need to introduce a new hook
>>  like vmemmap_populate_finalize().
>> - Cleans up arch code: PowerPC can deprecate its custom =
vmemmap_set_pmd()
>>  and migrate to the generic implementation.
>>=20
>> Let me know if this rationale makes sense, or if there are any hidden =
edge
>> cases I might have overlooked regarding other architectures.
>>=20
>> Thanks,
>> Muchun
>=20
> At least on the face of it, it makes sense. The main thing is I don't
> know much about powerpc. So I'm also hoping powerpc maintainers could
> chime in.=20

You do not need to know about powerpc since the change of powerpc is not
a part of this patch. It should be a separate code clean up for powerpc.

>=20
> I also don't know how this would affect new archs, but if they need
> flush_cache_vmap() they *probably* also want this treatment for =
vmemmap
> hotplug? I guess we can deal with that when it happens.
>=20
> Thanks,
> Vivian "dramforever" Wang




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C938CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744516B0092; Tue, 29 Sep 2026 04:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDB76B0093; Tue, 29 Sep 2026 04:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD046B0096; Tue, 29 Sep 2026 04:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39FAC6B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:05:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEB168043D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:05:21 +0000 (UTC)
X-FDA: 85266064842.20.A6C7D79
Received: from mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A22040005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:05:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rkra5USm;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Mlt1fFOz6NghvkWPanzDnDPyiI0rfJLtgaUYtvsfBg=;
	b=U2eK8bK/gUvZzSfw7yVvK9CMoeF4xvrSnc2MrBZJIJwL2BVPQRsgTqc5054GlJForPrZEH
	ilcAX+8zJS4NBLUyKcLTWDeyqp47HF1RwyIlaxEctMVICtpIzYOY4Qb4mfLlGzbZUdOdua
	BB1YLR7jaoBFwv3RYLHBPC93Qz92wTo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rkra5USm;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669119;
	b=ybSxJVRJAEVKHbJE71/wrV9smGPDUtWsiwIWDWA6rLC5B5RvE/JLPeFKBVNMogFYru6U15
	yyvaQahXomnME3+zJjj41reD75s3vzmDrboHwD+jz0pOGjmeOwLfzA/I1lVZ74NjTc0iE1
	RQ4moAAdVldlS/LLNazIwZCtGhxnkJY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Cu3PmaM4+usDuxduqOqsYpNfFf0tzadb722O33EBlFs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790669115; v=1; x=1791273915;
 b=rkra5USmTKLDQMwVuLTXXc35rx0Di+HOZEYy3FBvfIihW6eIYe/VpiTna+mfiyk2FYD8tNjT
 SmZdPelyA0fS50BU1DZfboBkU5L/KBBDsyj8LHv94z9kLoPAn6PPdqgHIXZ9atZxQ+Le6KL5eLd
 gKeqb8+wM/2nHrxH3YMVk1zU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id dcefedb6d7c8165b;
	Tue, 29 Sep 2026 08:05:14 +0000
X-Mizu-Trace-ID: dcefedb6d7c8165b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 05/12] mm/sparse-vmemmap: prepare DAX vmemmap
 population for compound page orders
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <deecea10-589f-4e2c-9c17-5e5dd4e81250@kernel.org>
Date: Tue, 29 Sep 2026 16:04:55 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <77523FDF-D7CC-4B79-AF35-DF2E6673F0A1@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-6-songmuchun@bytedance.com>
 <deecea10-589f-4e2c-9c17-5e5dd4e81250@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A22040005
X-Stat-Signature: tac5oszmxaow8qntbdaw8zii8rgxjydn
X-Rspam-User: 
X-HE-Tag: 1790669116-365287
X-HE-Meta: U2FsdGVkX1/sqqgAvnE58qxR7MKSKU/aRjHOug7qMYfcoKfPPeNLrwFYXNb8kRElr5U6aUDf6VyiUllXvPZ9yN9t5o9e/XzKv/OCpy44TjVPU07vxehFI6NKhQdOzrdUNdo+n/h9fGclicYIdWANm9H6AYhaQEQh4xz/0xEX61yPVciV8R3hwbLqg0oSDBR5k8i+MPOCPW7Q5eqvWZ1vDS5K6oVF3voYanW1GaVGVOE/w76iPMXviC4CxetsuN+E9JSYrAGhzu05UU+icqAAT2AhjbiyE4yaYSatESwik53WPPODVeTgzDPkyeOoof8Id9dYYSKBSKUJ51K9x7kIGUtdnej5xxlbbQZ+EZcyrkyyz9nypHOl+WT0Pj/2/TcPP3HorI4AMo5qaoIj6LNMdsM/0fSbGcQGx4O4rFi9Oi7ydylNgDnFqKMksHK7WlQH2ys4N/X7isWRfSRsvTiUlMWhv7v+9qyRM+vMEm5CkDgLlQt/zyXiLnZJuB2sQ+NgVasityVMipDKyRG7dGZQ+NgPBIgvfoQ9W8nhBbAHVfZfxljPZmbA7BDBbyUL4xhxpWniv16zOeIGMHXED+7ggpoDOxoqVs19VmRlqcLtoH0z/autGleYOGkKQrEHh8WTPyzVtXZ7nuajMyBli1RTfjsDNZ3XruIsxdTTqj17Apccv1wXPIP1usZieVMpzRiINrUF93X4KFnWbC5JZECD8f72SryA0uZVF2TmVmsl3FJYj97+z898T2MngGIyN2bJdMq0p5pO4KF5NhVv3p7Qn6O8iATNWsfJHEgjh75HW48bK80KuZaXCytBwkPsTg1ZbUm2p4llinmyelor+7qh5vVCtUB9/PM2j3h5lbcdV9yt+nfTHcRMUCHU+SsuiicziEU262wq75OSTkYHLNPY+srb0irSJcSVdFWTM57nju7nY62yq0s+NJiIo3gXaRGY0Dn4dkoMNlCgZNolt/8
 1XPXSVO2
 WDHJIVdXpUoktxcNmj4sYoVZKBtYHGhKaEknpXzc38fLDurBXjBHdHCExxxpcaphOuYkuPw3Rf7JFwFrRD9faqhtlH8T/gQGGbav4Gw1sfchvPmeSTNSkDJVp55h+UX06Vp5w5lhIUDUKCRINbFQW9FtKHtPPnN3rZb1K4CrYeFjPqyVg8KnnKnfn+vHJNi6ykQJrCtLKr+AeSjA0A+gZNbb6OxsujKEZFJbJ+4WlcJX4yGTsMAlBZxTi/5Wkz2Ddq7p2CCEr885rh6c6fM6dw04vQc+gc7YJ3ErU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 15:24, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/27/26 04:54, Muchun Song wrote:
>> Device DAX still uses vmemmap_populate_compound_pages() to populate =
its
>> compound-page vmemmap mappings. That helper allocates the head and =
first
>> tail vmemmap pages explicitly, then reuses the first tail page for =
the
>> remaining tail page mappings.
>>=20
>> Device DAX is being moved to the section-based vmemmap optimization
>> infrastructure, but it cannot switch to the generic section-based
>> population path yet. Once a later patch records the DAX compound page
>> order in section metadata, DAX head and first-tail PFNs can look
>> optimizable to the generic helpers as well.
>>=20
>> Add a DAX-specific population flag for this transition. It keeps DAX
>=20
> Well, you're not adding flag, your reusing an existing one and =
renaming it?
>=20
> And then you're specifying it on more paths.

You're right. The commit message need to be more precise.

>=20
> [...]
>=20
>> mm/sparse-vmemmap.c | 27 +++++++++++++++------------
>> 1 file changed, 15 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index e4dae98ba7f8..2457ea2c6dca 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -35,8 +35,8 @@
>> /*
>>  * Flags for vmemmap_populate_range and friends.
>>  */
>> -/* Get a ref on the head page struct page, for ZONE_DEVICE compound =
pages */
>> -#define VMEMMAP_POPULATE_PAGEREF 0x0001
>> +/* Vmemmap population for ZONE_DEVICE compound pages */
>> +#define VMEMMAP_POPULATE_DAX 0x0001
>=20
> Cleaner.
>=20
>>=20
>> #include "internal.h"
>> #include "mm_init.h"
>> @@ -243,13 +243,17 @@ static inline struct page =
*vmemmap_shared_tail_page(unsigned int order,
>> #endif
>>=20
>> static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
>> -  			struct vmem_altmap *altmap)
>> + 			struct vmem_altmap *altmap, unsigned long flags)
>> {
>> 	struct zone *zone;
>> 	struct page *page;
>> 	const unsigned int order =3D pfn_to_section_compound_order(pfn);
>>=20
>> - 	if (!vmemmap_optimizable_pfn(pfn))
>> + 	/*
>> + 	 * Device DAX still relies on vmemmap_populate_compound_pages() =
for
>> + 	 * head/first-tail allocation and tail-page reuse.
>> +	 */
>> + 	if (!vmemmap_optimizable_pfn(pfn) || flags & =
VMEMMAP_POPULATE_DAX)
>> 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>>=20
>> zone =3D pfn_to_zone(pfn, node);
>> @@ -271,7 +275,7 @@ static pte_t * __meminit =
vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>> 		pte_t entry;
>>=20
>> 		if (ptpfn =3D=3D (unsigned long)-1) {
>> - 			void *p =3D vmemmap_alloc_pte(pfn, node, =
altmap);
>> + 			void *p =3D vmemmap_alloc_pte(pfn, node, altmap, =
flags);
>>=20
>> 		if (!p)
>> 			return NULL;
>> @@ -286,7 +290,7 @@ static pte_t * __meminit =
vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>> 			 * and through vmemmap_populate_compound_pages() =
when
>> 			 * slab is available.
>>  			 */
>> - 			if (flags & VMEMMAP_POPULATE_PAGEREF)
>> + 			if (flags & VMEMMAP_POPULATE_DAX)
>> 				get_page(pfn_to_page(ptpfn));
>> 		}
>> 		entry =3D pfn_pte(ptpfn, PAGE_KERNEL);
>> @@ -546,6 +550,7 @@ static int __meminit =
vmemmap_populate_compound_pages(unsigned long start_pfn,
>> 	unsigned long size, addr;
>> 	pte_t *pte;
>> 	int rc;
>> + 	unsigned long flags =3D VMEMMAP_POPULATE_DAX;
>=20
> const and at the top?

No problem.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David




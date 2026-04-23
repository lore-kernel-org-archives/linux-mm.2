Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A106FAD3EE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926676B0005; Wed, 22 Apr 2026 22:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FDFA6B008A; Wed, 22 Apr 2026 22:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83ABB6B0092; Wed, 22 Apr 2026 22:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 753826B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:15:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0764DC1B1C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:15:06 +0000 (UTC)
X-FDA: 84688203012.18.38F13DB
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3333940006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:15:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ba9Y5yxV;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776910504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0/01H4xiCJnfs36bIwGAXpJVzm4AGBrMPoyje3Rvz4=;
	b=n7abVWhW1SnRJeeJc1zipiDSionzTBno8gCm6SydMCvx/piZyXXN+VlDTVjRjBoekTxuAK
	ORu6szO6fhTF6bqL8tg6J5aXyd0XQZkqfNi32B3wu9zuhrnvCBWTQgKZjMwy9HjH6WrG+F
	EdEb+cVvEb1VifwqwxtMtdDoTPIoZOM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ba9Y5yxV;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776910504; a=rsa-sha256;
	cv=none;
	b=0YTzwlQLe1Yi0OUGW0tdrqTt+fxpS2lY50fh4xrqnfeRSz4Q+Zf9g+KnLJ91GeXzDbnQO1
	enrUCExGK7vtaGa3ZXOccBgzcgr6T241+WZdlprHMNLTKlDXfi1yXEfLI0A6fWP7X1FIoR
	9tE6kl04fnLTUuoAyLtEJncI/QPwj/4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776910501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n0/01H4xiCJnfs36bIwGAXpJVzm4AGBrMPoyje3Rvz4=;
	b=ba9Y5yxVcom61fXlDbNnPGxckX72Wg1DbZmfHjnu0lMfj/YISK/8hzvjV9zBBmkDvDlXmc
	SbmfdF/oUXqzKRiVmBSDlEqxaH+CHmnwrQ4CWf04UEYAcEGyU3JbHjLzN4e806O8Lolewg
	chajDmzvd9vVnRWQ7EpP9ylApOsyss0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v4 2/5] mm/sparse-vmemmap: Pass @pgmap argument to memory
 deactivation paths
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <fc80afb9-6e97-481f-8136-d684ff3690a7@kernel.org>
Date: Thu, 23 Apr 2026 10:14:16 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3745D308-DF29-477C-A25F-CDA63400D5ED@linux.dev>
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
 <20260422081420.4009847-3-songmuchun@bytedance.com>
 <fc80afb9-6e97-481f-8136-d684ff3690a7@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: n4157ghhwxydj6o75zo41wkpoozxsqzc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3333940006
X-HE-Tag: 1776910503-790948
X-HE-Meta: U2FsdGVkX1/ozu/nL1bU/y8sXQVlouXBiNwWMEyeWZvk+c53mRgz/WCOenTFNg4EtZqs3gh6W9o0IQ4+BISKf6hI+nwxXvb1LJOI/6wAo9svviOspmOJEgYCsVlVG/0nxLEyLIH+B72AGbG6PRuUhqd5B9v0xEL7BOp7TtRRZtiW2bKOn3VkRRJPibBw1Il6xEV0k0CI0AiSMlJlrYoniWaows9uq6VeGFkpXhlnZWRxjhh7vQORNfA46FUqtDnsXBJbd7tjYbGF309TXwBSZugP+RTQLf+U/Tc9gK/HcPnGukJIOE3f6029ehE0lm8OcOS4ZHCDd/tWAbNuzHLryZ1rL1gmqa2ova382V2q+62fe6tvUyYHZT3b71fAdJkJXuXopH2uaYayzD+9s1VOqzHbQ8VByJOyYHE70vxaSTDaaGH5MXHa+o2KQ/sQV1YrIHMz52BrTE2AIZ3Zum6eCcw7fi3P7aib2XfiPOzteMkSWLbYuz6shkTwLrh60JBa7CcGUOwZLMWgnBpggSAYPE2lFKgHzw7H9kShvpkiUC9ic2xMyPJCFWUP0wrsVWxHypaWuxd2412NfY07oca5V9CP0fhcxGYbDFm1/yh2vBOwsPhHGqess16WNrsWy8J7n/h8cIEO0keLNmsOjQVaacsMXS5ZRxhpFiJEG+OQAAAuaHnXy5oWus260C51DiUrUTw56oruIXfwjtCdzMIvnV99cRZTfJXzEfUt1kvBrAN6XHpzE0Pg2gNYhpjQgO/+mMwG8zIikWYhHNGNOKHAc1xHgpk5j1Xpo78vziMQCf3EJRleTxZiK9xhO+MPtAtLGw0OZ29cH7och+ceN/T201yGuKg85hdCuil/CPuuF+7FSgV7FnJGa7rft6yWeLPxMV1owLVm57sjRZO4u9QUvIlnP0qQd5fcaiSwu1XGgwDuBpqaP+QJ+NPf5zHA0r2joMqDe7SQTrxHODvpO0O
 4pQCujm7
 ycKAa3OPFy0PiCdUvKl2z/oiTlIzX1SbxEp3XsBNYpveCViCet9F2AmDWm0j4ezUfqYYP2+LwHUdYJzvuYT1ZPMORfyWlOPVAnax5IcC310haPbgw5uAA6ka9v8cry0ywfCb+fc40P2IVXhx6PBC9XJqfIxInaDr8yjmIXnKfmYG3vBz1l85Jmmh6Mptj6MFfHPP9DThhHUKpC08PZu/VZDa2aZspCIphpZJ1En2bVi6Gcc0u+IfLeiJW3Kbd6nRCTUCWIMUom294p6hOBifi5it+NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 23, 2026, at 02:50, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/22/26 10:14, Muchun Song wrote:
>> Currently, the memory hot-remove call chain -- arch_remove_memory(),
>> __remove_pages(), sparse_remove_section() and section_deactivate() --
>> does not carry the struct dev_pagemap pointer. This prevents the =
lower
>> levels from knowing whether the section was originally populated with
>> vmemmap optimizations (e.g., DAX with vmemmap optimization enabled).
>>=20
>> Without this information, we cannot call vmemmap_can_optimize() to
>> determine if the vmemmap pages were optimized. As a result, the =
vmemmap
>> page accounting during teardown will mistakenly assume a =
non-optimized
>> allocation, leading to incorrect memmap statistics.
>>=20
>> To lay the groundwork for fixing the vmemmap page accounting, we need
>> to pass the @pgmap pointer down to the deactivation location. Plumb =
the
>> @pgmap argument through the APIs of arch_remove_memory(), =
__remove_pages()
>> and sparse_remove_section(), mirroring the corresponding *_activate()
>> paths.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>=20
>=20
> [...]
>=20
>> static void depopulate_section_memmap(unsigned long pfn, unsigned =
long nr_pages,
>> - 		struct vmem_altmap *altmap)
>> + 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>> {
>> 	unsigned long start =3D (unsigned long) pfn_to_page(pfn);
>> 	unsigned long end =3D start + nr_pages * sizeof(struct page);
>> @@ -746,7 +746,7 @@ static int fill_subsection_map(unsigned long pfn, =
unsigned long nr_pages)
>>  * usage map, but still need to free the vmemmap range.
>>  */
>> static void section_deactivate(unsigned long pfn, unsigned long =
nr_pages,
>> - 		struct vmem_altmap *altmap)
>> + 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>> {
>> 	struct mem_section *ms =3D __pfn_to_section(pfn);
>> 	bool section_is_early =3D early_section(ms);
>> @@ -784,7 +784,7 @@ static void section_deactivate(unsigned long pfn, =
unsigned long nr_pages,
>>  * section_activate() and pfn_valid() .
>>  */
>> 	if (!section_is_early)
>> - 		depopulate_section_memmap(pfn, nr_pages, altmap);
>> + 		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
>> 	else if (memmap)
>> 		free_map_bootmem(memmap);
>>=20
>> @@ -828,7 +828,7 @@ static struct page * __meminit =
section_activate(int nid, unsigned long pfn,
>>=20
>> 	memmap =3D populate_section_memmap(pfn, nr_pages, nid, altmap, =
pgmap);
>> 	if (!memmap) {
>> - 		section_deactivate(pfn, nr_pages, altmap);
>> + 		section_deactivate(pfn, nr_pages, altmap, pgmap);
>> 		return ERR_PTR(-ENOMEM);
>> 	}
>>=20
>> @@ -889,13 +889,13 @@ int __meminit sparse_add_section(int nid, =
unsigned long start_pfn,
>> }
>>=20
>> void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
>> -    			   struct vmem_altmap *altmap)
>> +    			   struct vmem_altmap *altmap, struct =
dev_pagemap *pgmap)
>=20
> While at it, could switch to two-tab indent here as well.

OK.

>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

Muchun.

>=20
> --=20
> Cheers,
>=20
> David




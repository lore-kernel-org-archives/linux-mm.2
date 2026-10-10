Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F1ECA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7026B0098; Fri,  9 Oct 2026 23:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E926B0099; Fri,  9 Oct 2026 23:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB996B009B; Fri,  9 Oct 2026 23:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 319A46B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:50:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9458EC0737
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:50:41 +0000 (UTC)
X-FDA: 85305339882.09.CFD1E00
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8241CC0002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:50:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oXXbzJ4J;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791604239;
	b=gqA7QJvs0S2wJKZydnYIynRGJBuxUXcd+/cgryJL/tJef9qGos+g0eC45exil/8688PVfR
	GH4RqIUYPdKuflftC3MD1zmFZe7vAz5Klt0sYIbigd/4qyF5tmR+JSD1r0Z2/BHsCbPfTl
	hiMCIpHN+GeFJBb8YeBCIMQ/gffMxoo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oXXbzJ4J;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791604239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiOsm0VLiWvZ3CXjkpAdill8SJJnyR3xUUM9KZWiffY=;
	b=xFvkTZXC/03hpNCg2gAx8kvh36JLt7I+I/ZfMHlr2yL10vsmpaisZHB6GcgUz+mBsanlnF
	UUjwrkMawynPoHGT0fP/4eZQAc+MxBXDRhYJNM70D03C6vWmPuawmpOwIPPgFNqrDhJxb/
	RrJF1azO3KLeks0X6ljzLXeJMjLQSmk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ejj+1mQ7GORhSID6jODIShDthWwWtiPSHyMLfZ3/AqU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791604238; v=1; x=1792209038;
 b=oXXbzJ4JEVIIlXmLSFRm9OK+stur3MstaTSM8R7gazaCRKIGrKwCfpn8L2p7Dj5L16p8FS71
 p+ORylMMHzgTMoR/YNm9X2+lSyxkj632ly8gHzZ2g0ei1Jyxvu/lJPvz/2amZ+UA2nLFH41br1x
 pIxXRgA80hDqODcHgG5tXZrI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9484aa877343ee44;
	Sat, 10 Oct 2026 03:50:15 +0000
X-Mizu-Trace-ID: 9484aa877343ee44
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/4] x86/mm: fix missing pgtable destructor for vmemmap
 tables
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <39ae6c48-7fcc-41d5-bfaf-fe626071861e@kernel.org>
Date: Sat, 10 Oct 2026 11:49:57 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 osalvador@suse.de,
 dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 catalin.marinas@arm.com,
 will@kernel.org,
 mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org,
 pjw@kernel.org,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
 alex@ghiti.fr,
 linux-riscv@lists.infradead.org,
 agordeev@linux.ibm.com,
 kevin.brodsky@arm.com,
 bjorn@rivosinc.com,
 apopple@nvidia.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <98481914-D123-4F58-97FA-C2F34469D34C@linux.dev>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-2-songmuchun@bytedance.com>
 <b8769c67-1683-4d84-94c9-916c305dafc0@kernel.org>
 <39ae6c48-7fcc-41d5-bfaf-fe626071861e@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: mnyfn588g9dqw1gbiomcz47c1yk8kt46
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8241CC0002
X-HE-Tag: 1791604239-96779
X-HE-Meta: U2FsdGVkX1/t6KOJqW64BsXH3LnoX3EPIhst4Lw4BxfhNaSst4pI3KPbC6KM7D5hiHfnczJJ4tVUgMJ3ICL4HzJ/K9eKsojGhx7KT02gMcS+oMzZertE36UYflL7tuX31hlro9mvlgHuXoLphWHoLkVvYMIPDGDsz2BZLylcR0Q06cdUisDcR0KjcdMp6CU3YicPyl4VRPuuvYWmHTz7f9heQXuxOszTzLq7/wpXrD1DBlsHn2CqidITO/CEKMDegGc8KA01v9F40oribjyt3SMM5dSZ/dVUlQcYt2Mw0aSwUwNjkh2VoiDaVrgWL3jo9Fl/qK48mmJFUqlckP3sAaPZE+RdqZBU/JiCxRB9j4c68qEbumDXCnn8g+7Nq2GzcaPelsIB7akBQXCxRo8BmDxdkEOTYlgNmFnmfZBfkHZDEh+bErqhwyesBirJT0X4tajQNU0WNeKwz4JS1rMR1nVm/lG4sxM8kVAMto94//xV8gCDDOiqbbk7hkDdSOl+8+gR8bu2nbn3B95EFxRoz1Qguh1bpV9S0Xd/SteyPGhgc+PyHJPsOGfs5a0WI3aaXqQ5sFwnjL0zbJqgs8XYE+tr6At0Pw+P4wdWOmo2HHqaj5IKyRZztLrEfsKTdcRuDz7Y07G2UluwIc0wXNCHtHnH+y7uQPbs5rhGVAXhZ7Dr2Xb3XXecFafwBC3vklB+oJ6BwY0ELLoBEH7sMtYgPQ34NXVOtx1alINx52k6XpommoBQmkkeaG/8IKtCO4n0++in/zoAwPp7aHb24Z8IJRn+26p3yRJS2gWtIqa02j4uXwLJJKgELm8RnYD6bCHGQsjgZCsnavQd7V9A5YLp0CAbi67iWiR4mPu9+Q4SU+di2gvPGwvQQwU+AjNS0kv6P7QVQZD1gtSKib+GO7VV+aaHgBwzpZsGBjDd8rDrBfAL807+I5P+bDrHV/U0fJ1b9/nunA0zWBFzCjRvko/
 BFaypvep
 bFVx2Eywb0TxVb9VDHbwwZfvtDBu35L1XniS/qNuHG+3hi44dgljyZgfsmM/jomUVAIRcniF0dC/p9WXCV+7NmQ/1R2JsRjm0JzjXtfy+ajDI+0fqPnNA0pnMHIscpspISwFEgYpbWTXLQLmIZ4Rk9m41S/ae6a/CjJaaT2xRRN6gatijOqoH9g1yaG0NfhcbgiwvXmnVLJOpChJdkV7gobNJkCwznyvVDUd41Vcnlk1Jqy35FyFHIEsTk3pu12h/5as/6M6SftCsHfoYACTtORQkYndZNtC4frkrR+GJRZBJI1CnNUl8ZncpVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 04:36, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/9/26 22:33, David Hildenbrand (Arm) wrote:
>> On 10/8/26 09:30, Muchun Song wrote:
>>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>>> pte_alloc_one_kernel() runs the page-table constructor for kernel =
PTE
>>> tables.
>>>=20
>>> HugeTLB vmemmap optimization uses pte_alloc_one_kernel() when =
splitting
>>> a PMD. Restoring the vmemmap backing pages does not collapse the PTE
>>> table, so a later memory hot-remove eventually frees that table =
through
>>> free_pagetable(). That path currently calls pagetable_free() =
directly
>>> without decrementing NR_PAGETABLE.
>>>=20
>>> Use PageTable() to identify constructor-backed tables and run the
>>> matching destructor before freeing them. Keep reserved and
>>> constructor-free tables on their existing paths. This also prepares
>>> vmemmap teardown for generic runtime allocations through the normal
>>> pgalloc helpers.
>>>=20
>>> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
>>> Cc: stable@vger.kernel.org
>>> Assisted-by: LLM
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>> arch/x86/mm/init_64.c | 2 ++
>>> 1 file changed, 2 insertions(+)
>>>=20
>>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>>> index 70e682180291..a3ea627157ab 100644
>>> --- a/arch/x86/mm/init_64.c
>>> +++ b/arch/x86/mm/init_64.c
>>> @@ -1003,6 +1003,8 @@ static void __meminit free_pagetable(struct =
page *page)
>>> {
>>> 	if (PageReserved(page))
>>> 		free_reserved_page(page);
>>> + 	else if (PageTable(page))
>>> + 		pagetable_dtor_free(page_ptdesc(page));
>>> 	else
>>> 		pagetable_free(page_ptdesc(page));
>>> }
>>=20
>> pagetable_free() will do ptdesc_test_kernel(pt) -> =
pagetable_free_kernel(pt) ->
>> pagetable_dtor_free().
>=20
> Ah, behavior depends on CONFIG_ASYNC_KERNEL_PGTABLE_FREE$ ...
>=20
> Why not do the right thing in pagetable_free() instead?

Good point. More easy to this issue on different architecture. I'll fix
pagetable_free next version.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D94F0CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010DA6B008A; Mon, 12 Oct 2026 09:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03B46B009D; Mon, 12 Oct 2026 09:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1B586B009E; Mon, 12 Oct 2026 09:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF5CC6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:29:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E2C7140D22
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:29:59 +0000 (UTC)
X-FDA: 85314057318.21.0D35686
Received: from mta1.migadu.com (out-142.mta1.migadu.com [95.215.58.142])
	by imf17.hostedemail.com (Postfix) with ESMTP id 190A140009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:29:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HKcQEqzM;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.142 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791811797;
	b=YaBqZEm/zqw8eEJMOrlHl9PpMS3XjVa+dhu+3nQ7/7dloixvEg+zAzSFDhwjrkSAOgL+V/
	rhfelxd8a+iucXZpytmN0Lm+cc1DSWV9XaEUEy4b7QMIJCsVkO+9ha0gy3NtO3B43RqwMF
	k+/KL16PDh8Arl/LpXBFpqso5GRu5aQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HKcQEqzM;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.142 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nua+XVEY2vij3Fr22xOyNCUp1hfLgqE/Wz0Aff8l2UY=;
	b=AgYZHVOWOhsFT7f7Bk9hPBEia5xR7ygeuE7dNDkCYLzUcc3l32QJ9f/RDkUZh9BfVbURfb
	0VbieCU7Irs5pRcvxlnLwgM3hRApwSUg38xa29isZqXvSW8JpLpfpyJbfN9fhv+ZE6p6XC
	nZl2PR1WR1YNEQ0DmXj1i6LEuzcN3aY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GGn8drrlO6i+jPM1cQp3kvDlxLXSPfm+i8X2a7OAoPo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791811795; v=1; x=1792416595;
 b=HKcQEqzMc0b9qa3T1l/MT1XX0glz8eLZEWBDc5AJJkcuEAlLFd65BvG/PK8qVzy9Mf/fZPNW
 8dO6QDotEkdH3rj8UjNe2IE6iaeogMiaoXnpuJZZMWnJAHGZ7ImhKIfqy5LwDxPo2JXY+v+V0D/
 FTFz2JY0x35Bi0yTNwGvHeEk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d7c9edd7e757cc90;
	Mon, 12 Oct 2026 13:29:55 +0000
X-Mizu-Trace-ID: d7c9edd7e757cc90
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <919fcaa9-5ebe-4940-b4fc-59ea0c655ec3@kernel.org>
Date: Mon, 12 Oct 2026 21:29:35 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Dave Hansen <dave.hansen@intel.com>,
 Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org,
 linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <77D942CF-B657-4735-9B95-1C6B38DD0F46@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
 <919fcaa9-5ebe-4940-b4fc-59ea0c655ec3@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 190A140009
X-Stat-Signature: 8k73tzk7o13y4arjp3sw8s53h6i9d8st
X-HE-Tag: 1791811796-633944
X-HE-Meta: U2FsdGVkX1+fJiOQHjtfG2MN4cPslXZbV+qWBlsnQNGPTOwP9/vAtugdjJLGTtJpFEomewPiziHgNlCqAOblR3WRaTK+O56CrUKY61RF2Qw2dxZ5YH61i8skxkLXXZJUkRgPh9LUb80KO5FQEYK2Kc9O6QyrPj9XI2ebuih/poeEVdmf6bSmhlnNzMbXQ0bAkwGV8N8O/UNdh/McjcTVCPokVZyvNPlE4G0hgRfNZaZOOtxAeTbrsxc1W9YFPl3vtoC28BR2xqqjpnMl4CoQ+rgzyzkrvlFJREl7KuOF3HkePGRe7Te1TwDmH7eZUuJpszJ0bkz5BehYHKBMXMtd3f4Ajve/r4GM0aIicIbs6zbtqXG8ir8Dc3N0Zn7O5XJLysEMnaAojJbxLbiB8+nkTDabwridv6zZXu0P3QjTsT3Lcurm1kDhCr28o8KS6HGlT63+NgLT2n+Mqm6O30h0FtpcbZJISyWQWqXTCaUwq0YQfCIP5Mkuq/z3sTwB75IOpoekZK6MBa8Na8Up051W1gKoaHpz5mS622+vvAgVIIDFISe2Tgnp+cypDexYXu4Pc496aID7HP3z4sBrHPp+ZDSaY6GEuYGvd6wZgWsuuheKsXxiP1R46GW850vQLEDZfYJJVq9SUoXzD7Y9UapcaS9bAEosXi0UjSYvCOUKxsoE6E5w5t2E5oe/XGwLD7PZEGOHpG6GmTUQ6KBoXReqdogpDSB3srHOWTJg4Lg3foJkJtdQCnmZVUnrd+GU1hnpn9MvKTUzZK1CliHc3YFZW1FFnmN6CYqXIg9ufZvBBkoFaXPpSsE4JClXPPJpaGiHwmEx8ktr7w6uAHf9H+QbKvKQu+7RBBd5BDixDFnFsbpVrg0gTs3YGRU8xYEPHi9RbC4PeTwkd5WAaClONiQAt4c62MGpyEqGCrIr6OzkyFp7q9YHHlYNHwEHNukTHd7ThSH3rC4ow2r/LxQc3C8
 ottEbPHe
 sKD0pYJr+C4AjBidMFhwuUYrD+TauvTCzdsQP3NPF7RDWsJTD1Uq51mccg1ar7V4NxX2czI7edrHNFFrrChJgbxm07eB858MW68ooVxvzuhFm+wRhD/SZrbo8Tco3KImsEDEJ68skCi5hzfOwS6h3EQjjs2RKwWBrwaKfB+VT7Q0Juh409aBbPVbJu7QSxUTZc+xRACxZ4dRfwv6xoNklzWnO0EXeFA9mJL2AT043evb/0Vffai5wPjA7cZqTUES90SrQwxjAgUc19swOjtGtMNrnyYKhgCUGouOfZURVz9Y00c0nwl3pDGKOEma3J3js4mv3f54BwK68zvvIbJAx+CibhqIidv7Rhn9kRlP1pFEA8S0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 12, 2026, at 21:27, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/10/26 13:24, Muchun Song wrote:
>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
>> tables.
>>=20
>> HVO (HugeTLB Vmemmap Optimization) uses pte_alloc_one_kernel() when
>> splitting a PMD. Restoring the vmemmap backing pages does not =
collapse
>> the PTE table, so a later memory hot-remove eventually frees it =
through
>> pagetable_free() on x86-64. That releases the page without running =
the
>> matching destructor and leaves NR_PAGETABLE elevated.
>>=20
>> Make pagetable_free() detect constructor-backed pages and run the
>> destructor before releasing their memory to fix the problem.
>>=20
>> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v2:
>> - Move destructor handling from x86 into pagetable_free() (suggested =
by
>>  David Hildenbrand)
>> - Trim and update the commit message (requested by Dave Hansen)
>> ---
>> include/linux/mm.h | 37 ++++++++++++++++++++-----------------
>> 1 file changed, 20 insertions(+), 17 deletions(-)
>>=20
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 5cca90fc1df6..771a7d60b0a5 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3969,23 +3969,6 @@ static inline void =
pagetable_free_kernel(struct ptdesc *pt)
>> __pagetable_free(pt);
>> }
>> #endif
>> -/**
>> - * pagetable_free - Free pagetables
>> - * @pt: The page table descriptor
>> - *
>> - * pagetable_free frees the memory of all page tables described by a =
page
>> - * table descriptor and the memory for the descriptor itself.
>> - */
>> -static inline void pagetable_free(struct ptdesc *pt)
>> -{
>> - if (ptdesc_test_kernel(pt)) {
>> - ptdesc_clear_kernel(pt);
>> - pagetable_free_kernel(pt);
>> - } else {
>> - __pagetable_free(pt);
>> - }
>> -}
>> -
>> #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
>> #if ALLOC_SPLIT_PTLOCKS
>> void __init ptlock_cache_init(void);
>> @@ -4078,6 +4061,26 @@ static inline void pagetable_dtor(struct =
ptdesc *ptdesc)
>> lruvec_stat_sub_folio(folio, NR_PAGETABLE);
>> }
>>=20
>> +/**
>> + * pagetable_free - Free pagetables
>> + * @pt: The page table descriptor
>> + *
>> + * pagetable_free frees the memory of all page tables described by a =
page
>> + * table descriptor and the memory for the descriptor itself.
>> + */
>> +static inline void pagetable_free(struct ptdesc *pt)
>> +{
>> + if (PageTable(ptdesc_page(pt)))
>> + pagetable_dtor(pt);
>=20
>=20
> We do have
>=20
> static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
> {
> 	pagetable_dtor(ptdesc);
> 	pagetable_free(ptdesc);
> }
>=20
> ... can we now get rid of pagetable_dtor_free() and simply use =
pagetable_free() ?
> (separate cleanup)

You're right, that's exactly my plan.

>=20
>> +
>> + 	if (ptdesc_test_kernel(pt)) {
>> + 		ptdesc_clear_kernel(pt);
>> + 		pagetable_free_kernel(pt);
>> + 	} else {
>> + 		__pagetable_free(pt);
>> + 	}
>=20
>=20
> This goes into the right direction. I'm still confused, but the less =
freeing
> functions we have the better.
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks David.

>=20
> --=20
> Cheers,
>=20
> David



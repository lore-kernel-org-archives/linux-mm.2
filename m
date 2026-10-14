Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35ED1CC6B1F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 02:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86766B0088; Tue, 13 Oct 2026 22:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37936B008A; Tue, 13 Oct 2026 22:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C266F6B008C; Tue, 13 Oct 2026 22:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA2F6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:37:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B03B803E2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:37:34 +0000 (UTC)
X-FDA: 85319670828.14.8891567
Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5CA46140002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:37:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SuKgG0h1;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791945452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dxd8Y6Lrt4s4PWsOCLBeyi346J8MZaF1zshRzm5udds=;
	b=r1UpcuZG4/LFceLWpkJwUEAx++vFxMh3JPuRRdJiI6+EG4lcgXyh47bzEgaSAQp1jjASab
	ynTy/jxBu2P7lSUgrQf7az0GtovELR34DPOLZiRqNst/AgQKTmQEDAXli6gFil/HhVbawU
	2gyA2U9WmUXsdaZPa7DN4xUTzJ47bEs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SuKgG0h1;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791945452;
	b=1iJMKnGyTwfpjceHG/IsvRMl4Fy4D3TNCZAmvUq7B1YlvPtKeNNQYrH58AVxYI7Azca6ue
	i+AapjRjBtp+2ZEcdEQsifOyDsYkH0/KpWvM7ICxucoxr4iI7n4Q6SwG3j7Uhio5jPI+u6
	zpw+4rcLB1Num5mhfEJUaj6CgqurcB0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7UUTt82RGwkEsPz4m1IMAXE3gzzct3/wWyS9tYPd83k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791945448; v=1; x=1792550248;
 b=SuKgG0h1oLdHqaaJ9RHrwR/s04x1jK5Mwqs5ZzfmH0XRLckS0tHu2iba+7mwMZGIMKTwlbiO
 huUqRETO+zV2D+xoIvimg0dmf4nPISBkwfV51fkak4Bxb2YH7ZLI6YFPMxEPo+2+jE1iQOwEt0x
 1gqWhvXrcPj0282aAU5le8mQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 48e5c038101e18a7;
	Wed, 14 Oct 2026 02:37:27 +0000
X-Mizu-Trace-ID: 48e5c038101e18a7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <2552e0bd-0e50-4dd5-a3d9-00e9204eb2c2@arm.com>
Date: Wed, 14 Oct 2026 10:37:04 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
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
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org,
 linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6DB87EB4-93BB-4861-AC17-159DCD1E442B@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
 <2552e0bd-0e50-4dd5-a3d9-00e9204eb2c2@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5CA46140002
X-Rspam-User: 
X-Stat-Signature: bjty51wn1cn5ah7i8font678djdinwou
X-HE-Tag: 1791945450-573133
X-HE-Meta: U2FsdGVkX18ntbjdFdjxIgstnT5v96d+TSBOp1HoToaIefM9TvPcWFf0TCJPFodcmDIfDw27rGXj9lt1kymKGGvCKhxDR+G5Ed4iDfgAdvzEvvJ9VCt4Msgp/fxMnBsqo/c45PQXaTA47wjDEAcrOnhig8tHgkcs3HlEyiw0wmAcujiiE2NRN9IsAxyy+OwJxPKcsh67qEYWsfSh8bWPk2xEJs7M7dornPcHVYwNiSArCw1IZ0JJwfkNrhbqQNwfRbaM1ZfjaK/mdeMMIh3rKll9sPoPZhbUUzNXF/ib/2VXLCWLTvCNn6X1J1ZwLoN756XVxTrpCXRx08iDNvcAEUYo57TQGjImoFYFFWmBydQeBpFoEu8biBr7/4hXlymBVcdsCxdSPgFbFW3Q2rQBcwio5set0h2B/WGmARZLBxHtagrpMQSUHktPmfpmmcuiQalt6Fjube1Bh9HnpQWCb++OgPuLrrMP9MGTEOZLkP1IG10SVSbWML1um6liJ5YxvujbWIQHnFr8U3DFDMiHcdM4MtedXUdkVCXAW8GbKfEcQZed+x+ajWqrOG5FndDrzwX1qg/ctipJ7KDlramAqegVTfFJy9G3YLCGslflTZlg++TTwi8KYiiCsvhxfF6/CVtb5Ia/sfnZJ7wH9tT8IdoXOiRJ+ZeJXzGI3akeqwwgJymV+/yLQTKA2nT9zmTwRu1fdUWqC1jiQieyOV5W8dQJvXNa0XT6QjMZWAgx3QOZjkD9cSTru4ubIo5AYX6gfLYmY/7pEsB8J/P5NYU3eWZ92G1T8Z4dWG3htgi7XxLh/+GhO7FIAFGLBFtPjxbklCT3ZC0ZtxKew17UhPAv/ia5qR9WzqkLQTXGlh2Mn3phJQt3iZsXimunHgW63lQTtgR3yBtl1XwX9v29xVyAEuhVNJb/Dwt2cEKIAKWXhPb3KbR6PW2i/yN3m9o+kNZ9z74RLpYy3u+EY+VbQMZ
 Gv5uvgns
 J39GAvBLYI2E118oOtIOwClxd9pYaADANmF3rrjzzZdKBZFa7JBxIJjIFD7fEPFxqqa1GXP/3Kk3O3gi4pg18lxWU2jqj3tzCw/n5+okmnv5FxcENAndHXtN7RAhMnkfUYZsah3t5wdnzu8GuARwFevN6gDPsHtbmBei/gSpQmKA0fH9iyrk156Q9Fan8Geioz2kI3Zsi8MmQsIKWJsxh0zNe2opXThvr4+MxLtiT1dzVZmX0c39aHpUrGOZKJBQQbR5aMHqkT5kNpQVP0DwTNWG5wb9aYZiQdMuvHpmvYUy2XKIrzRYSOEe7LAj1gY0jKnm4oTN+yM8dm6Y+SC/vjY+XeJOchxhjEARdGMz1R7xhfPjEbQq1LpFo4mSep3EzLuu/4KwYBwxj1QMbo1hAhfvdJgzVAJ0UXRJo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 13, 2026, at 23:46, Kevin Brodsky <kevin.brodsky@arm.com> =
wrote:
>=20
> On 10/10/2026 13:24, Muchun Song wrote:
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
>> - 	if (ptdesc_test_kernel(pt)) {
>> - 		ptdesc_clear_kernel(pt);
>> - 		pagetable_free_kernel(pt);
>> - 	} else {
>> - 		__pagetable_free(pt);
>> - 	}
>> -}
>> -
>> #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
>> #if ALLOC_SPLIT_PTLOCKS
>> void __init ptlock_cache_init(void);
>> @@ -4078,6 +4061,26 @@ static inline void pagetable_dtor(struct =
ptdesc *ptdesc)
>> 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
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
>> + 	if (PageTable(ptdesc_page(pt)))
>> + 		pagetable_dtor(pt);
>=20
> Took me a while to understand why this is fine. Currently we have:
>=20
>     ptdesc =3D pagetable_alloc();
>     pagetable_*_ctor(mm, ptdesc);
>     [...]
>     pagetable_dtor(ptdesc);
>     pagetable_free(ptdesc);
>=20
> All good, nice and balanced.
>=20
> Now we're saying that pagetable_free() should call the dtor. But of
> course, in most cases, the dtor has already been called. Yes, this is
> fine because in that case PageTable(page) returns false. Still, the
> casual reader is likely to be confused (like I was).
>=20
> The commit message should really explain this. I'm not a big fan of =
the

Maybe I should mention that pagetable_free() is supposed to free page
table page from now on.

> asymmetry we're creating between explicit alloc+ctor and free =
implicitly
> calling dtor, but I suppose it's safer this way. (And looking at the
> rest of the series, it does bring some nice cleanups.)

Make sense. That's my plan.

>=20
> I understand this is a bugfix series so its scope is limited, but if
> time allows please post a follow-up series removing all those explicit
> dtor calls that are no longer required.
>=20
> Now don't get me wrong, I am absolutely in favour of moving as much
> handling as possible out of the ctor/dtor and into
> pagetable_{alloc,free}; a series I posted earlier [1] was a step in =
that

Excellent work.

> direction. It unfortunately had many issues, including the unmatched
> alloc/free calls [2]. The work you're doing in this series, and your
> plan to use pagetable_alloc() for vmemmap, are exactly what I was
> planning to do next, so thank you for taking care of that :)
> With the commit message improved:
>=20
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

Thanks.

>=20
> - Kevin
>=20
> [1]
> =
https://lore.kernel.org/linux-mm/20260714-remove_pgtable_cdtor-v1-0-44be8a=
7685d7@arm.com/
> [2]
> =
https://lore.kernel.org/linux-mm/6d167aaa-e9b0-4687-970c-1c67d0df6344@arm.=
com/
>=20
>> +
>> + if (ptdesc_test_kernel(pt)) {
>> + 	ptdesc_clear_kernel(pt);
>> + 	pagetable_free_kernel(pt);
>> + } else {
>> + 	__pagetable_free(pt);
>> + }
>> +}
>> +
>> static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
>> {
>> 	pagetable_dtor(ptdesc);




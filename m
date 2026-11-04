Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F55606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t/rnVYY3
Received: by kanga.kvack.org (Postfix)
	id 0285C6B00EF; Wed,  4 Nov 2026 02:07:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20856B05B1; Wed,  4 Nov 2026 02:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31826B05B2; Wed,  4 Nov 2026 02:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C38E96B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:07:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FB24140634
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:07:54 +0000 (UTC)
X-FDA: 85396556868.06.5D9838C
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0516B20005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:07:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="t/rnVYY3";
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793776072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgFroUGFKpdEpsdgtkKaDpgGtTJdhJhgl9e77IsbomE=;
	b=sO9lOLORvgszB7kDYkebPbgQPqs8KIbu8GtpZiPrKFaXlqJU6qafWLvZip4cCSGXtvQUxV
	wQiWs+id37dsfVG61ne2xEg9S733IefyZl/naLydPwOd6Nzd2OFTUdwZeW2iS5VkaW2mZ8
	Ljh+MYtymhR64J+N99u12NtUiCUcj5E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793776072;
	b=ieFNsxenr40CDMgroTYbDZQaJffDM9GpRMdgTvjbevysI0t6zBx0Uc21OXnnhASH6w6rKz
	DslGYgN5d9g9I5WB2IkRWZ6Nxy4StR8luBXWAsW2lTl4uao/y0V5VJwnLzpBy8oQPFDpat
	EUNCMYlLL+jeBngaMENcIp2FRHHPS10=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="t/rnVYY3";
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2flBiNkjPpyfuO38KJqLh8zZK1p8JBEOfsDzZidYjyA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793776070; v=1; x=1794380870;
 b=t/rnVYY3owlF9B/6NtFckGgyA19CWUTTyL3pLVIOvGqUnGJ7tCi4XaPVtlcwIyaMDW+FPOjN
 pbPizGmJMRRX7D15+nJszteY5KsCV/DKFJvFaLVh97yAEU0fAycrNFIIbq4ikhJpcNZ8CUQ93h+
 gLcCCIEDi8GKMqxs4WsHoIvk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e13f75cac8a9b814;
	Wed, 04 Nov 2026 07:07:50 +0000
X-Mizu-Trace-ID: e13f75cac8a9b814
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/4] mm: hugetlb: skip CMA allocations under
 PF_MEMALLOC_PIN
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <8b7f6573-ed12-494f-9210-d6f6dbf01567@linux.dev>
Date: Wed, 4 Nov 2026 15:07:23 +0800
Cc: osalvador@suse.de,
 David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2DE679F1-C87F-4222-A710-C87CDE86D333@linux.dev>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
 <4EC5E593-7537-4659-879C-95ECC2224D2F@linux.dev>
 <8b7f6573-ed12-494f-9210-d6f6dbf01567@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 56594pectj3grr6zmkaiph1hyk1frdju
X-Rspamd-Queue-Id: 0516B20005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793776071-323658
X-HE-Meta: U2FsdGVkX1+KteXq8j0to+Z8md4sbGNlTvQuHYAtVmB0GW/mluug16hDKhzSHhHBC625Q//WyWhyf4XGlu1Th3GoGkkdLJ3f2Q1oshGHyMLyCsxh2lwhLhegBOeE1MzoXhktZ1Oo+3asS/2GoRu7wOu4r2irTBwbilJDaz6k4c11ghxTldgQLmmZOR7xvnoqEKqhWyhOPwABycgbMovG9pZLiG53qNTIYx8jfcpPaVo6YrrEQhRjBe7LHsku12WvTdkKa9HURKe1ETBAFRfSPuXy66api3qeueyAxItvgshi7OwTgZEWQW74pPj6RlK9CDyj+2Fm/96J6bbXwGi4eoKBAyFmjHmGUdpZRQ1cQSk9z6bZjOyEcO6yHWm2hZ8UUsXSL5Fb6io0dL+VsD4c1T148h88sJT6LQ8b286U2hJ7zrb0MVcrUD3LXIPzNAWAbH+1pamXgwaXYQ5tr0d+AOEcZCjyZxwLXFvpKU1X83EKSavFTXEQejHZnVWjiuB6gBXo44HU2aJksUBi35fMyXPTg1TWuqzeHFKDqSZYIqGHS8eRQYV4d/OcFJm7dktJhCUabcdvZxQ3Jl13n+0YYht82tNehQqV+7BWexI5FuCfOBit4fEEp5XE5PS+wjLXSKt2lB6AW9Fcult4yryRV7S/0ExmiAxoub/29ltEFnAhnDifqhKuYX6aILwCu/1yxO9BFT19GsAEhDL3Xdg6CDAc5PZWRcsS28F1DyZt70pKOs2Ytr6FORokQBnXOrI+sGzz727Fq3k8jzWnbrzlpfIaUTHsD26LrJcTI/w/UR9kQL4pnkkXvzkKDnaQv4uiEkcqHtNatT3f+pr+riif0p8D0H2jEkl1BHNLDZEmxsF58QwJw8QBNgPO0PTBh4XkM4aI1cwlcz1VHHMD2I/FhmbxY9BC1pjM2JDkpt43uCtncLRauWjLH6UKhvSenbILQyP9NBe5Ul4UobNiSaY
 /zYz+xR3
 fUVG3czbHHX+lc7tOdVfPH5ZqAi0jU2mkoMNkIWCN+XS7huzjVs1cVHVke0drKTb51PBYR3AXrjrrSwqIU6fysxeSE6JgiLbV6heymoXbcOB/zdVxbsXOWaSmtV3wS0pvNzyqoCa99b3RCcJyouUhLmms3kX4YU9QR36MG5jKisvUmybt+oiFAcjV5N1ITT5jPR4jlitU2plxPVmr5ytZ7WawZF2S5/D3H0yHwxTZBCOiQ1z1GyHbG9b8bE3p3QyoxJYxDqFk74k83LSpb5G3CzZOS1Rrvmfa4SYu2ZFXAT/oCFwL1xBUfrCCWQlk8qNn6pMPoECGUEyiPr1ZdUVwsBafCUQAvYHde0lTXUDqTN2kc2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 4, 2026, at 11:27, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> Hi Muchun,

Hi,

>=20
> On 11/3/26 6:56 PM, Muchun Song wrote:
>>> On Nov 3, 2026, at 16:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>=20
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>=20
>>> With gigantic overcommit enabled, a fault during long-term pinning
>>> can allocate a fresh HugeTLB folio from CMA despite PF_MEMALLOC_PIN.
>>>=20
>>> The folio must then be migrated before it can be pinned. However,
>>> fresh gigantic migration targets are not supported, so pinning fails
>>> when the HugeTLB pool has no suitable target, even if the original
>>> fault could have allocated pinnable memory outside CMA.
>>>=20
>>> Honor PF_MEMALLOC_PIN in the HugeTLB CMA allocator so the fault can
>>> try the non-CMA fallback, or fail when allocation is restricted to =
CMA.
>> Wait... I think my Acked-by got ahead of me here. :)
>> There seems to be a rather odd distinction that GUP is missing.
>> The usual reason long-term GUP must migrate a page out of a
>> MIGRATE_CMA pageblock is that the page was only borrowed from CMA by =
the
>> normal page allocator.  The corresponding CMA bitmap range is still
>> available, so a future CMA allocation relies on being able to migrate
>> that page away.  A long-term pin would prevent that.
>> However, a HugeTLB folio returned by
>> hugetlb_cma_alloc_frozen_folio() is different.  It is the actual CMA
>> allocation, not merely a movable page that happens to reside in a
>> MIGRATE_CMA pageblock.  Its range has already been marked allocated =
in
>> the hugetlb CMA bitmap.
>> Therefore, CMA cannot allocate that range again until the HugeTLB =
folio
>> is freed anyway.  Long-term pinning the folio does not seem to make =
the
>> CMA area any less available than keeping the HugeTLB folio mapped for
>> the same amount of time.
>> folio_is_longterm_pinnable() currently only sees MIGRATE_CMA and does
>> not distinguish these two cases.  In that light, rejecting
>> PF_MEMALLOC_PIN in hugetlb_cma_alloc_frozen_folio() looks like =
working
>> around an overly broad GUP classification.  It also means that
>> hugetlb_cma_only users will fail the fault, while other users may =
consume
>> a gigantic contiguous range outside the dedicated hugetlb CMA area =
even
>> when that area has free space.
>> Would it make more sense to fix the long-term GUP check instead, so =
that
>> an explicitly CMA-allocated HugeTLB folio is considered pinnable, =
while
>> ordinary pages merely borrowed from MIGRATE_CMA pageblocks remain =
unpinnable?
>=20
> Make sense!
>=20
> I'll replace this patch with an exception for HPG_cma folios in the
> MIGRATE_CMA check. This also lets the HugeTLB allocator select =
preallocated
> CMA folios during long-term pinning. MIGRATE_ISOLATE and ZONE_MOVABLE
> remain restricted.
>=20
> Fresh CMA allocations under PF_MEMALLOC_PIN also need to skip ranges
> in ZONE_MOVABLE. Returning -EBUSY here lets CMA try its remaining =
ranges.
>=20
> The incremental diff against this patch is below.
>=20
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 8555d38a97b1..7fd1b6e65b58 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -21,11 +21,13 @@
> #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
>=20
> struct cma;
> +struct folio;
>=20
> extern unsigned long totalcma_pages;
> extern phys_addr_t cma_get_base(const struct cma *cma);
> extern unsigned long cma_get_size(const struct cma *cma);
> extern const char *cma_get_name(const struct cma *cma);
> +bool cma_folio_is_pinnable(struct folio *folio);
>=20
> extern int __init cma_declare_contiguous_nid(phys_addr_t base,
> 			phys_addr_t size, phys_addr_t limit,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cb993a1d0728..d15810be7d96 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3,6 +3,7 @@
> #define _LINUX_MM_H
>=20
> #include <linux/args.h>
> +#include <linux/cma.h>
> #include <linux/errno.h>
> #include <linux/mmdebug.h>
> #include <linux/gfp.h>
> @@ -2975,14 +2976,16 @@ static inline bool is_zero_folio(const struct =
folio *folio)
> 	return is_zero_page(&folio->page);
> }
>=20
> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
> +/* Borrowed CMA pages and ZONE_MOVABLE folios cannot be pinned long =
term. */
> #ifdef CONFIG_MIGRATION
> static inline bool folio_is_longterm_pinnable(struct folio *folio)
> {
> #ifdef CONFIG_CMA
> 	int mt =3D folio_migratetype(folio);
>=20
> -	if (mt =3D=3D MIGRATE_CMA || mt =3D=3D MIGRATE_ISOLATE)
> +	if (mt =3D=3D MIGRATE_ISOLATE)
> +		return false;
> +	if (mt =3D=3D MIGRATE_CMA && !cma_folio_is_pinnable(folio))
> 		return false;

Actually, we do not need cma_folio_is_pinnable(), does the following =
work for you?

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2982,6 +2982,9 @@ static inline bool =
folio_is_longterm_pinnable(struct folio *folio)
 #ifdef CONFIG_CMA
        int mt =3D folio_migratetype(folio);

+       if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
+               return true;
+
        if (mt =3D=3D MIGRATE_CMA || mt =3D=3D MIGRATE_ISOLATE)
                return false;
 #endif

> #endif
> /* The zero page can be "pinned" but gets special handling. */
> diff --git a/mm/cma.c b/mm/cma.c
> index a10ea37a261d..c2814f54f86a 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -27,6 +27,7 @@
> #include <linux/log2.h>
> #include <linux/cma.h>
> #include <linux/highmem.h>
> +#include <linux/hugetlb.h>
> #include <linux/io.h>
> #include <linux/kmemleak.h>
> #include <trace/events/cma.h>
> @@ -55,6 +56,12 @@ const char *cma_get_name(const struct cma *cma)
> }
> EXPORT_SYMBOL_GPL(cma_get_name);
>=20
> +bool cma_folio_is_pinnable(struct folio *folio)
> +{
> +	/* Explicit HugeTLB CMA allocations own their bitmap ranges. */
> +	return folio_test_hugetlb(folio) && =
folio_test_hugetlb_cma(folio);
> +}
> +
> static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
> 					     unsigned int align_order)
> {
> @@ -792,6 +799,11 @@ static int cma_range_alloc(struct cma *cma, =
struct cma_memrange *cmr,
> 	int ret =3D -EBUSY;
> 	struct page *page =3D NULL;
>=20
> + 	/* Each range lies within one zone; try other ranges if needed. =
*/
> +	if ((current->flags & PF_MEMALLOC_PIN) &&
> + 	    is_zone_movable_page(pfn_to_page(cmr->base_pfn)))
> +		return -EBUSY;

I don't know why we need this.

Thanks,
Muchun

> +
> 	mask =3D cma_bitmap_aligned_mask(cma, align);
> 	offset =3D cma_bitmap_aligned_offset(cma, cmr, align);
> 	bitmap_maxno =3D cma_bitmap_maxno(cma, cmr);
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index dde1c866406f..95fd2d190f0d 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -62,9 +62,6 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> 	if (!hugetlb_cma_size)
> 		return NULL;
>=20
> -	if (current->flags & PF_MEMALLOC_PIN)
> -		return NULL;
> -
> retry_cpuset:
> 	if (!nodemask) {
> 		cpuset_mems_cookie =3D read_mems_allowed_begin();
>=20
> Thanks,
> Qi
>=20
>> Thanks,
>> Muchun
>>>=20
>>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic =
hugepages")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>> mm/hugetlb_cma.c | 3 +++
>>> 1 file changed, 3 insertions(+)
>>>=20
>>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>>> index 95fd2d190f0d2..dde1c866406fb 100644
>>> --- a/mm/hugetlb_cma.c
>>> +++ b/mm/hugetlb_cma.c
>>> @@ -62,6 +62,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
>>> 	if (!hugetlb_cma_size)
>>> 		return NULL;
>>>=20
>>> +	if (current->flags & PF_MEMALLOC_PIN)
>>> +		return NULL;
>>> +
>>> retry_cpuset:
>>> 	if (!nodemask) {
>>> 		cpuset_mems_cookie =3D read_mems_allowed_begin();
>>> --=20
>>> 2.54.0




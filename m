Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F011A606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BKlOJh3L
Received: by kanga.kvack.org (Postfix)
	id 058DC6B05B3; Wed,  4 Nov 2026 01:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A836B05B4; Wed,  4 Nov 2026 01:52:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB666B05B5; Wed,  4 Nov 2026 01:52:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95A596B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:52:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D48B1C3ACB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:52:00 +0000 (UTC)
X-FDA: 85396516800.25.20A7B2B
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6EBBD120005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:51:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKlOJh3L;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793775118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7jUyy8Gw62Mrsm2NdWwANOlQB/3RrOBIWSL1UsbH2U=;
	b=0G8nNenFQkVE9Dm9TpJ5oGiW5YBICmCigYAsNuI552Wu8O2x1TEilLgd8Ae8DETTrbWqGQ
	O39r6ZahwAuhFWUmJ/fwoT4dNZVMYD0qmgP5kyJAqcOk7GV1GpQxFwmkdH+et7ImmeHrDh
	0QCz/9JcmsRShYaZF6XM642EyVGgtxQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKlOJh3L;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793775118;
	b=GW5vfvNgcpFqvNm6T9nODf9YpxAvZ5yTh7SDINjtHnxiFMgNefC4f0QuFpzsBWfs9q0awV
	q4Vfu568grWleeW4ZPorFpTTCU9HCwkI5pAYoWbMjpjTi08SgeuWn5P34UtVsCHfhR2DfU
	mh3YXg2O9Ny/vGTw6Q2o/oC2CUAHpjk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ljz/LclQ0UJiJzuNyth4XAWDfGd5wGDccwNu0d77uuo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793775115; v=1; x=1794379915;
 b=BKlOJh3Lr+VxtlnAKinUY5OC6Vv0QJDltk3kO4Jmp9SH5JvReVpKWz/SWOLf8jZkR2aC2flL
 dPDva73kVAzxDcQ5i4/FiXm8oynLX6S8XwpP1tJ6vv7PohotWmljjv2zRvoGAy20J8gLGgqPTq3
 zeSo/kNEgpCX+hd3ZzvNJGcw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8da350dcc4f59400;
	Wed, 04 Nov 2026 06:51:55 +0000
X-Mizu-Trace-ID: 8da350dcc4f59400
X-Migadu-Flow: FLOW_OUT
From: Muchun Song <muchun.song@linux.dev>
Message-Id: <04F17535-617D-42C4-AAEA-A1E119250FB5@linux.dev>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_C6A7CAFA-B34D-44B6-A22E-E592A77FCA23"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/4] mm: hugetlb: skip CMA allocations under
 PF_MEMALLOC_PIN
Date: Wed, 4 Nov 2026 14:51:25 +0800
In-Reply-To: <8b7f6573-ed12-494f-9210-d6f6dbf01567@linux.dev>
Cc: osalvador@suse.de,
 David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
 <4EC5E593-7537-4659-879C-95ECC2224D2F@linux.dev>
 <8b7f6573-ed12-494f-9210-d6f6dbf01567@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 5dgb1wrxh5ahya1myt57qtn8z85szpq6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6EBBD120005
X-HE-Tag: 1793775117-983017
X-HE-Meta: U2FsdGVkX19hlilwKVu1BG1+ldQJDcUFn400Azssii34GNWKcsYxV4X2jvZ7dv5g1xHLaTnjBxbh1XZHdMmqzyAaFvW7ulZ8Y+xBapi1+50LsRJpo3x58NxUpg1xcRcqPNx5RZvTaycvsrzgLdK2+IovNpI78anQNf0FnxLFBFqrNvuysuRWDcQmEX1TebBBW+4zfTjIiVIsN2PHXZazC1RDA4iZhv4F09yt2NWnLC5tkuGlSj4JqcjUbMxnGEdEEps1uO/45nlpev0+GLGDDCOCBYmIXlvkE3WjGcdIzdjwLxYlpOUhA9EXoFQ9bNMQUQBUiccNdM3RBX4J7izHlN1kZpnKr9RRHdYVVZHTmydks0A0Olqey7NYs6WBNMALG1ReyQckxzpqO5g9wiOY3t6ZPp6A8daAYIHD7kpd60dxnnHZjDDwLtnpu+w5yl9FkFl2E+OP5DdO2Nwx5Gg6ODvdiBeHEU6IoiEXaQ6HsQe7/z2k5+QxmXo9fgG8trUZrnylDcAahCrwGM/i5ied94jqzB1cs/Vf706r4RcVONq+3+SbEX9TwwonmgryPffT70I2oCb1/8gIve7QjMGl/wBfgwbTVY4HHAZSXowsZyRyVEl+/aIcdwpdOeEQpGBnOJSoV9swey7aBOaUjAKoJj5OTPr+Baeu5foFB8GZKiF/lsNH9JtB7Tx4LRi+d0y1fYgWIFEC2mUYiOK421sufCiOiPbXTM5pecBV3PzKHd1LI3QuzgPvT83chy2gPtwEaRPtQy/TybxCQy/H10SW6o9VsbHyMPBgc1nVsCpeZyIj6xx+PJOLDpNgLeU6lCZcC1v+yIgQNYhDXbgWtBsVweEP6XcaaCo6Md8UxgfGIZWVwx+QUebuWgZnUIxqFVzK4qd7F73Xd3Zu4C/Cn/ZLPpRkAN//gOOXKfmVq0nDl/sbrVHgSJjraR833j1f6Tfaze1OenYxcg09oJIhuBT
 thrYQYXO
 LFI0fJBw5BiAoefoxRlyYjoLna5Nol8IIlP0a5k1s3UqUwG2aETMirFKOdKnf+wKQjn/evaOV9uJUTkmZlYOqZRR3TVGZflcD9DoQKtw7Os+0kH9Ee3h0Gh750WP6t3OlLQt5b0Uq/eOBtLpTVveVzebJ/cGm71M039YhYQnyXfXJv/74x9jHSZfiQMdVwXiiJkufq4UD830ST9hykTCjb/cR0rhBWVCi1HbEGw1PEDMuSp3C2ZC9YF5HRz+v83aeR8kzDEnd7I0dy1EyTRCpaGRb8Y0eB1rtOYsaZSLsvQ1JbnFKro2Spax4L4PzOkiaW2LmXLsOdXhYiZ6akC44R/CFUPcYeyis1NJ47ywA6EESmuHoMzuv3e+kY/WqQIqHbsVkdK01SQFEP07kypt14h+HjnO2tlFIQpaWk2oO4pMEtJCl+SwhIvLA4vbQRyVVFhC4mzLNl2lKbZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_C6A7CAFA-B34D-44B6-A22E-E592A77FCA23
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



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
> 	/* The zero page can be "pinned" but gets special handling. */
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
> +	/* Each range lies within one zone; try other ranges if needed. =
*/
> +	if ((current->flags & PF_MEMALLOC_PIN) &&
> +	    is_zone_movable_page(pfn_to_page(cmr->base_pfn)))
> +		return -EBUSY;
> +

I don't know why we need this.

Thanks.

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


--Apple-Mail=_C6A7CAFA-B34D-44B6-A22E-E592A77FCA23
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Nov 4, 2026, at 11:27, Qi Zheng =
&lt;qi.zheng@linux.dev&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Hi Muchun,</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div>Hi,<br><br><blockquote =
type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">On 11/3/26 6:56 PM, Muchun Song =
wrote:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite">On Nov 3, 2026, at 16:01, Qi Zheng =
&lt;qi.zheng@linux.dev&gt; wrote:<br><br>From: Qi Zheng =
&lt;zhengqi.arch@bytedance.com&gt;<br><br>With gigantic overcommit =
enabled, a fault during long-term pinning<br>can allocate a fresh =
HugeTLB folio from CMA despite PF_MEMALLOC_PIN.<br><br>The folio must =
then be migrated before it can be pinned. However,<br>fresh gigantic =
migration targets are not supported, so pinning fails<br>when the =
HugeTLB pool has no suitable target, even if the original<br>fault could =
have allocated pinnable memory outside CMA.<br><br>Honor PF_MEMALLOC_PIN =
in the HugeTLB CMA allocator so the fault can<br>try the non-CMA =
fallback, or fail when allocation is restricted to =
CMA.<br></blockquote>Wait... I think my Acked-by got ahead of me here. =
:)<br>There seems to be a rather odd distinction that GUP is =
missing.<br>The usual reason long-term GUP must migrate a page out of =
a<br>MIGRATE_CMA pageblock is that the page was only borrowed from CMA =
by the<br>normal page allocator. &nbsp;The corresponding CMA bitmap =
range is still<br>available, so a future CMA allocation relies on being =
able to migrate<br>that page away. &nbsp;A long-term pin would prevent =
that.<br>However, a HugeTLB folio returned =
by<br>hugetlb_cma_alloc_frozen_folio() is different. &nbsp;It is the =
actual CMA<br>allocation, not merely a movable page that happens to =
reside in a<br>MIGRATE_CMA pageblock. &nbsp;Its range has already been =
marked allocated in<br>the hugetlb CMA bitmap.<br>Therefore, CMA cannot =
allocate that range again until the HugeTLB folio<br>is freed anyway. =
&nbsp;Long-term pinning the folio does not seem to make the<br>CMA area =
any less available than keeping the HugeTLB folio mapped for<br>the same =
amount of time.<br>folio_is_longterm_pinnable() currently only sees =
MIGRATE_CMA and does<br>not distinguish these two cases. &nbsp;In that =
light, rejecting<br>PF_MEMALLOC_PIN in hugetlb_cma_alloc_frozen_folio() =
looks like working<br>around an overly broad GUP classification. =
&nbsp;It also means that<br>hugetlb_cma_only users will fail the fault, =
while other users may consume<br>a gigantic contiguous range outside the =
dedicated hugetlb CMA area even<br>when that area has free =
space.<br>Would it make more sense to fix the long-term GUP check =
instead, so that<br>an explicitly CMA-allocated HugeTLB folio is =
considered pinnable, while<br>ordinary pages merely borrowed from =
MIGRATE_CMA pageblocks remain unpinnable?<br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Make sense!</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">I'll replace this patch with an exception =
for HPG_cma folios in the</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">MIGRATE_CMA check. This also lets the =
HugeTLB allocator select preallocated</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">CMA folios during long-term pinning. =
MIGRATE_ISOLATE and ZONE_MOVABLE</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">remain restricted.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Fresh CMA allocations under PF_MEMALLOC_PIN =
also need to skip ranges</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">in ZONE_MOVABLE. Returning -EBUSY here lets =
CMA try its remaining ranges.</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">The incremental diff against this patch is =
below.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">diff --git a/include/linux/cma.h =
b/include/linux/cma.h</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">index 8555d38a97b1..7fd1b6e65b58 =
100644</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">--- a/include/linux/cma.h</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+++ b/include/linux/cma.h</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">@@ -21,11 +21,13 @@</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE =
* CMA_MIN_ALIGNMENT_PAGES)</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">struct cma;</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+struct folio;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">extern unsigned long =
totalcma_pages;</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">extern phys_addr_t cma_get_base(const =
struct cma *cma);</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">extern unsigned long cma_get_size(const =
struct cma *cma);</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">extern const char *cma_get_name(const =
struct cma *cma);</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+bool cma_folio_is_pinnable(struct folio =
*folio);</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">extern int __init =
cma_declare_contiguous_nid(phys_addr_t base,</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">phys_addr_t size, phys_addr_t =
limit,</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">diff --git a/include/linux/mm.h =
b/include/linux/mm.h</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">index cb993a1d0728..d15810be7d96 =
100644</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">--- a/include/linux/mm.h</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+++ b/include/linux/mm.h</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">@@ -3,6 +3,7 @@</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#define _LINUX_MM_H</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/args.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+#include &lt;linux/cma.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/errno.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/mmdebug.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/gfp.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">@@ -2975,14 +2976,16 @@ static inline bool =
is_zero_folio(const struct folio *folio)</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">return =
is_zero_page(&amp;folio-&gt;page);</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">}</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">-/* MIGRATE_CMA and ZONE_MOVABLE do not =
allow pin folios */</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+/* Borrowed CMA pages and ZONE_MOVABLE =
folios cannot be pinned long term. */</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#ifdef CONFIG_MIGRATION</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">static inline bool =
folio_is_longterm_pinnable(struct folio *folio)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">{</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#ifdef CONFIG_CMA</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">int mt =3D =
folio_migratetype(folio);</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">-</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">if (mt =3D=3D MIGRATE_CMA || mt =3D=3D =
MIGRATE_ISOLATE)</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">if (mt =3D=3D MIGRATE_ISOLATE)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">return false;</span><br style=3D"caret-color:=
 rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">if (mt =3D=3D MIGRATE_CMA &amp;&amp; =
!cma_folio_is_pinnable(folio))</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">return false;</span><br style=3D"caret-color:=
 rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Actually, we do not need =
cma_folio_is_pinnable(), does the following work for =
you?</div><div><br></div><div><div>--- =
a/include/linux/mm.h</div><div>+++ b/include/linux/mm.h</div><div>@@ =
-2982,6 +2982,9 @@ static inline bool folio_is_longterm_pinnable(struct =
folio *folio)</div><div>&nbsp;#ifdef CONFIG_CMA</div><div>&nbsp; &nbsp; =
&nbsp; &nbsp; int mt =3D =
folio_migratetype(folio);</div><div><br></div><div>+ &nbsp; &nbsp; =
&nbsp; if (folio_test_hugetlb(folio) &amp;&amp; =
folio_test_hugetlb_cma(folio))</div><div>+ &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; return true;</div><div>+</div><div>&nbsp; &nbsp; =
&nbsp; &nbsp; if (mt =3D=3D MIGRATE_CMA || mt =3D=3D =
MIGRATE_ISOLATE)</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; return =
false;</div><div>&nbsp;#endif</div></div><br><blockquote =
type=3D"cite"><div><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#endif</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">/* The zero page can be "pinned" but gets =
special handling. */</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">diff --git a/mm/cma.c b/mm/cma.c</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">index a10ea37a261d..c2814f54f86a =
100644</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">--- a/mm/cma.c</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+++ b/mm/cma.c</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">@@ -27,6 +27,7 @@</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/log2.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/cma.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/highmem.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+#include &lt;linux/hugetlb.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/io.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include &lt;linux/kmemleak.h&gt;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">#include =
&lt;trace/events/cma.h&gt;</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">@@ -55,6 +56,12 @@ const char =
*cma_get_name(const struct cma *cma)</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">}</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">EXPORT_SYMBOL_GPL(cma_get_name);</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+bool cma_folio_is_pinnable(struct folio =
*folio)</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+{</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">/* Explicit HugeTLB CMA allocations own =
their bitmap ranges. */</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">return folio_test_hugetlb(folio) &amp;&amp; =
folio_test_hugetlb_cma(folio);</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+}</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">static unsigned long =
cma_bitmap_aligned_mask(const struct cma *cma,</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;"><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;unsig=
ned int align_order)</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">{</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">@@ -792,6 +799,11 @@ static int =
cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">int ret =3D -EBUSY;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">struct page *page =3D NULL;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">/* Each range lies within one zone; try =
other ranges if needed. */</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">if ((current-&gt;flags &amp; =
PF_MEMALLOC_PIN) &amp;&amp;</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;"><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;is_zone_mov=
able_page(pfn_to_page(cmr-&gt;base_pfn)))</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">return -EBUSY;</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>I don't know why we need =
this.</div><div><br></div><div>Thanks.</div><br><blockquote =
type=3D"cite"><div><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">mask =3D cma_bitmap_aligned_mask(cma, =
align);</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">offset =3D cma_bitmap_aligned_offset(cma, =
cmr, align);</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">bitmap_maxno =3D cma_bitmap_maxno(cma, =
cmr);</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">diff --git a/mm/hugetlb_cma.c =
b/mm/hugetlb_cma.c</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">index dde1c866406f..95fd2d190f0d =
100644</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">--- a/mm/hugetlb_cma.c</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">+++ b/mm/hugetlb_cma.c</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">@@ -62,9 +62,6 @@ struct folio =
*hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">if (!hugetlb_cma_size)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">return NULL;</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">-</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">if (current-&gt;flags &amp; =
PF_MEMALLOC_PIN)</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">-</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">return NULL;</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">-</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">retry_cpuset:</span><br style=3D"caret-color:=
 rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">if (!nodemask) {</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">cpuset_mems_cookie =3D =
read_mems_allowed_begin();</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Thanks,</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Qi</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;">Thanks,<br>Muchun<br><blockquote type=3D"cite"><br>Fixes: =
eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic =
hugepages")<br>Cc: stable@vger.kernel.org<br>Signed-off-by: Qi Zheng =
&lt;zhengqi.arch@bytedance.com&gt;<br>---<br>mm/hugetlb_cma.c | 3 =
+++<br>1 file changed, 3 insertions(+)<br><br>diff --git =
a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c<br>index =
95fd2d190f0d2..dde1c866406fb 100644<br>--- a/mm/hugetlb_cma.c<br>+++ =
b/mm/hugetlb_cma.c<br>@@ -62,6 +62,9 @@ struct folio =
*hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(!hugetlb_cma_size)<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>return NULL;<br><br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(current-&gt;flags &amp; PF_MEMALLOC_PIN)<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>return =
NULL;<br>+<br>retry_cpuset:<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (!nodemask) {<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>cpuset_mems_cookie =3D read_mems_allowed_begin();<br>--<span =
class=3D"Apple-converted-space">&nbsp;</span><br>2.54.0</blockquote></bloc=
kquote></div></blockquote></div><br></body></html>=

--Apple-Mail=_C6A7CAFA-B34D-44B6-A22E-E592A77FCA23--


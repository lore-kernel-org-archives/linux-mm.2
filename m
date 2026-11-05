Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3495606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Jv2JoSDW
Received: by kanga.kvack.org (Postfix)
	id 8C87D6B05B3; Thu,  5 Nov 2026 00:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AC86B05B7; Thu,  5 Nov 2026 00:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790226B05B8; Thu,  5 Nov 2026 00:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 512BB6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:14:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D761F402AD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:14:17 +0000 (UTC)
X-FDA: 85399899354.17.1FE4628
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1A5B440007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:14:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jv2JoSDW;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793855656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEqA3W+i3V3yHQk0EklCgzFHb8brEsF0K0ZpN1y8TEQ=;
	b=E/vnAyv4GNJWNBorCcRR5WTCVgpoqGwNMvFW9KDSPqBjJX8vLFXvfJH40ja7X1KAe1zYv6
	9fpC7GO2aRSgu1Jw8+wKY8KKUOn1feiAgd6O/SQtFYUpxeNo7y8VxCDTJQk5yioE1i3OBy
	M2M8cXxJc0rnWPdsfMA95bGSE45V8Cg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793855656;
	b=y85FGZqP19rx9kZEsvU/gyIKNunHAOW/jJAie7QV1XcnMK7Q8XvAf/4xfII3jKd7cv7CwN
	NhmyWx9ESoAaRnEq9MbOoI7azdQuthWakvhpEYqa5sW7gU6if5rntXxFhU5AHIPOfR7O88
	KhYD4abT/EYLYKPIUKQbHj8jcVP+trw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jv2JoSDW;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xnhL49rU8Si9Gh8RiV1Fb+XbOATfd6SeIOCBPYd10uQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793855650; v=1; x=1794460450;
 b=Jv2JoSDWT8rRWOQPcqzFEkz0+ZUPr1snGqvUef4+jCsKVoJHOTVZo2HCYgK/Zy8xaFT4GN/i
 /cB/738Q14uaxOMvSUEIDrroWkDHCDcWwFyjDGJqNZZtdoTUnY8L2MjZwbUymCqjA6nXNXt9+Qk
 pAktt9j85Nu4FhP17wVMQfhQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f77242cba51ecc71;
	Thu, 05 Nov 2026 05:14:10 +0000
X-Mizu-Trace-ID: f77242cba51ecc71
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 2/4] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
Date: Thu, 5 Nov 2026 13:13:57 +0800
Cc: osalvador@suse.de,
 David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8F5F930D-A05E-4255-8E70-2567921A92A0@linux.dev>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: w4bkce5aajswcbxfafms3cwwbkzkuntu
X-Rspamd-Queue-Id: 1A5B440007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793855653-846606
X-HE-Meta: U2FsdGVkX1+TIXzeq5lGM/wQVUiBLmO/yZ2GBHORGcDDGQ1ACNlyIC0M6BqKdUlg1El3jR8tAm8elTrAkLuV61pmUcCN6sZ7rcZTWgU3qjBJXgSEy/GMcGux3dF8sU/xfY7sTeampZJvM/wG9smy6jmyLFtVUI2l8i6eEQUApTCCs22XvUNzwcPG3XdR1PNsVj76SikNPhTjcB6FrgIwv+1BTcVOr6ue7qjuwx5TAIoVSi3ZxSDsUPNKN4Tn2v6LG/wh4iDXU9QxFkGvGtYuMMQRbnCACafnExJPFcDyHiMY02ZjaTl3CZ431Bm343o/cPdQsod0nArDQdB50fK/xkTHp1jqC5TczQBRFKygeatFVkMyEv/8Y9bDQBqJzXo7Uh9u96Akjrp3KdVTL0BI7DGXBye+NmYVrJ/Ne0xiBIQ5Lno4pQW9O4YOgOv2/xRAuwQ2YF1MjFpTwC+U76/T2vtGtIrE8uQGl+TvRIIXHvOzhSu+EQn6SHo6MU35ONO3ykK/z1dypt6+nyv2DSsFn7sIcR9e/HJrUDIKEmhfafD6lPOmVTxyzcxP1gE6QQpg9boPCOMdiv/PVu1wfyaqRdBidaT7hJiS1ChUJFZ6FmKtnnUcWaXX8FjbgUZyhfG0FXQHXL9qdcEJNj+GL4D0uM6VFKAtC4aBunOSx6bEwPh7jZmhVZ9INkuF4l80BFExoNphP8W97xPTZw42S1MRp2t9IR0DM3I28zgh2qS85mepfO9vQwNjiTidQv9/x+KJayM8TOcrfv/PrzLrxkYbImu9AlQPucFk65ZJpWtTHKIiVbwn+BTMOjiAOJQ/IXvcmTI6AwQLM/atCjSvZSWwX5PFcObilQcBYkAurXHdNucI9RjdeqZvHgzKTbjBpBrkFqje37Rq7HTkZeR05I5Xx2ZVaQ9Zu2M9Wmvs05RzV1DZd5IVT068DgtJ5QpCMKW0x5jivrDO5+g4NdAt0MA
 YaQ6wBVi
 zEhQb7QXtaMU7tIotiloprc5FfyGtQPKMrVY1efNGYAYtGRVJK404sIBTsCjfAabuS1E7TLnMDEkHMEhaNdIHevIHGUNXV46Qi7/AtO4EBv2a4f3TzDi4Tqkyz5JHTL004vIMxBL2+nsAtbSBmBQjulw+lIymLP2imw0IJh5u3SXntocTsJngN9qu3+L7LHT5CEQDnvfUdjmeX3/v9nr3pNrDVIMtwIiE23EBKHhkkXfU5JLexpxwiE/iLxR8SjmeKpoibZrSQeUIN0RaOfmahNcX+h5yT4uWXZLg3OCJMyG32HP0zR3HLi/hLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 5, 2026, at 12:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
> unpinnable, causing unnecessary migration or pinning failures.
>=20
> These folios already own their CMA bitmap ranges, and memory blocks
> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>=20
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic =
hugepages using cma")
> Cc: stable@vger.kernel.org
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

But a nit bellow.

> ---
> include/linux/mm.h | 29 +----------------------------
> mm/gup.c           | 31 +++++++++++++++++++++++++++++++
> 2 files changed, 32 insertions(+), 28 deletions(-)
>=20
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2d0b8a4c9974f..75dd40265d3f4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct =
folio *folio)
> 	return is_zero_page(&folio->page);
> }
>=20
> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
> #ifdef CONFIG_MIGRATION
> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
> -{
> -#ifdef CONFIG_CMA
> -	int mt =3D folio_migratetype(folio);
> -
> -	if (mt =3D=3D MIGRATE_CMA || mt =3D=3D MIGRATE_ISOLATE)
> -		return false;
> -#endif
> -	/* The zero page can be "pinned" but gets special handling. */
> -	if (is_zero_folio(folio))
> -		return true;
> -
> -	/* Coherent device memory must always allow eviction. */
> -	if (folio_is_device_coherent(folio))
> -		return false;
> -
> -	/*
> -	 * Filesystems can only tolerate transient delays to truncate =
and
> -	 * hole-punch operations
> -	 */
> -	if (folio_is_fsdax(folio))
> -		return false;
> -
> -	/* Otherwise, non-movable zone folios can be pinned. */
> -	return !folio_is_zone_movable(folio);
> -
> -}
> +bool folio_is_longterm_pinnable(struct folio *folio);
> #else
> static inline bool folio_is_longterm_pinnable(struct folio *folio)
> {
> diff --git a/mm/gup.c b/mm/gup.c
> index 2b405cce2ca5c..e8503141bb275 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long addr, =
int *locked)
>=20
> #ifdef CONFIG_MIGRATION
>=20
> +bool folio_is_longterm_pinnable(struct folio *folio)
> +{
> +#ifdef CONFIG_CMA
> +	int mt =3D folio_migratetype(folio);
> +
> +	/* Explicit HugeTLB CMA allocations own their bitmap ranges. */

The description of "bitmap ranges" is weird, making me think what's the =
meaning of
bitmap. Please use more generic description here.

> +	if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
> +		return true;
> +
> +	if (mt =3D=3D MIGRATE_CMA || mt =3D=3D MIGRATE_ISOLATE)
> +		return false;
> +#endif
> +	/* The zero page can be "pinned" but gets special handling. */
> +	if (is_zero_folio(folio))
> +		return true;
> +
> +	/* Coherent device memory must always allow eviction. */
> +	if (folio_is_device_coherent(folio))
> +		return false;
> +
> +	/*
> +	 * Filesystems can only tolerate transient delays to truncate =
and
> +	 * hole-punch operations
> +	 */
> +	if (folio_is_fsdax(folio))
> +		return false;
> +
> +	/* Otherwise, non-movable zone folios can be pinned. */
> +	return !folio_is_zone_movable(folio);
> +}
> +
> /*
>  * An array of either pages or folios ("pofs"). Although it may seem =
tempting to
>  * avoid this complication, by simply interpreting a list of folios as =
a list of
> --=20
> 2.54.0
>=20



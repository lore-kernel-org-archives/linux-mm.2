Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B13D606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Kcr8dbbk
Received: by kanga.kvack.org (Postfix)
	id 7D81D6B05B9; Wed, 11 Nov 2026 02:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A2C6B05BA; Wed, 11 Nov 2026 02:43:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629286B05BB; Wed, 11 Nov 2026 02:43:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39C9F6B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:43:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C5C6160165
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:43:16 +0000 (UTC)
X-FDA: 85422047592.26.7AC8395
Received: from mta1.migadu.com (out-236.mta1.migadu.com [95.215.58.236])
	by imf11.hostedemail.com (Postfix) with ESMTP id 15AA240006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:43:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kcr8dbbk;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.236 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794382994;
	b=E8lR6VvKkRrxwaQYrF1woMZHOKwMKrYzetMacG1zctOt76rdB/wsJJdyMrbgJrtgAAtt1E
	dyW7tJ7IPhskLa972H7p1GWx8WUUGOLOjwVG1x32FiGyilwm0QHe+0p5A60L7ZW5nTPtA7
	iWmfoBV8FPSnVmWhfee8CDeRo60fD6I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kcr8dbbk;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.236 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794382994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfxdzkdgDHIptdiFFicHU4j+CsK16rJHdQjUlG9Ac2o=;
	b=sgf0HzkypEg5bOhl3IxY0bV3l2VkuJhX3kxZqCtSPHlIC8Dk4KxMb4mrsB7UhD+i5ODXgA
	saIoYp4gl2ibDS8cVv+pkYyAW2XLks+qAgaP55EQYbGtUrm7SgKoyj/KDvXvtRMISNGjAW
	h1wBiPmd3W2gSl/2QNj+5pTk9dzMoIQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2ou7idqYN0vwf8nRLylpa5vOfvnrhR/VXDNnnd6BgTQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794382992; v=1; x=1794987792;
 b=Kcr8dbbk8h+TSq+Yyw2YDIeSvwq6yLwpn8tc9FoowpR6nJsm66vFNZV0q63S6RgLxmroBChc
 WecxsGdtXIm0yDJpOcwWcwvoeDE1fmBqgl2/rqwDO3dDRbmCq7NHYAHz0g9Pc24beyB4ykRUhPD
 IYs1LeyW5IqEBhh54uHO5AjM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 12f4ebcce8353a82;
	Wed, 11 Nov 2026 07:43:12 +0000
X-Mizu-Trace-ID: 12f4ebcce8353a82
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v4 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <503c9f6d869e3206c6fd591de962c3d619b73825.1794379433.git.zhengqi.arch@bytedance.com>
Date: Wed, 11 Nov 2026 15:42:56 +0800
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
Message-Id: <80FED512-77D2-4D49-BAE5-745CE1F711CA@linux.dev>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <503c9f6d869e3206c6fd591de962c3d619b73825.1794379433.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: r9dtixh5jg8tm4frye9t4jrouuegrtkx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15AA240006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794382993-923069
X-HE-Meta: U2FsdGVkX18nCMkJrq+4g/glzCuQC+D5TiStk6UmxuOacmzVngvOu4kPAySaQmNAASMv3g5axzAVtZ0BnGkp15oG8tnCyD/PDQ7C5s1iS7+wadldzvbEciTIrgWU6epDfOGm7j+8wM5OF6hOD7i3vTUwFZpfHXTYjlC0b/BcC7UyXciIKedADyQ6XMgU/gU9jPf2FQsWaa+OAg7nB+jBuuTEzfCzN4SGfe6uqiHZcs91rzUNon0hjK+aE2Pj7Yz6os3U8G9VDr9LBrATgdxyb/Hm6tv01t2qoklf7EXMBEs8k0F3aeLlwaQ3RKlVhE+tLxtyYMtth1cMdyXyA5jzI20spImuo9mLqAx7ptQQTAjS+PdrjNkPEveuE9zPf/qHUXk/uk5/wBWTpdIrSJ+LYQoWpGkSqmpZQBPfsdeTlxVZuCgLSOyL8Fv7bjcAwLEL1Dep+MtHhoD1KOdPLXcccHTBaw4C8ffA9D2yYVB3Tu7vEPFlhka9/OAIr3zNddjtcmClY1wT7+f6qklx4CKYN5hgZeDnSSXVid/CRR6NYq79D/8buOy9zQRGmu+iEGZSoCOvUakYhSYop1eGhZRhEHPEL47W2V93aF3DCm1zWRHxjZA1JZo+Pvzmb61szGMkLtzHalVuFf2WgaLcdnZ5K3yscDShkOzrFmN4LE9LsMdRfrnZCJVkPfxGqg418qLf8WL3bC4xaRpf4lGBht6KLnuetYy4hKg5VX/W4kjH1RQvJgc+54uV13yLmWSBN0dfOHoWKcbf710Y6IgmW1he1hrjSYUAS4OkZqY8ovHLG0GPpfbTlzCvTtZ55LYJDStpjWEqdcxntDVQmHc6Ffwsmebd+iSmHrkmeYP3guNjdQMuTb9fxs0V3e7QsgyE86YRgzx7ojSKqSvL2IBFA9AuOLSxdTqoiQuxzq+b2VXsJOtFsCt2rHGiwJakglnA7HvdfmuBWaprVlIA/86wzFw
 UJdEj+lE
 xcWjoVcLs7a//llTwmab6rRzmXhqT9/AVwym92NaO7eATbKCbVY7Uoeup7qP/SXAjTXOfMtdbxAobZaaeMpcwYTlDyp3krmEwUQSzLE35Jbvc/6REmW2DoNHKy7exDTxoh52ai4bFLkUHVylKogRmOPrHqUY8Erex0C2jx4xNbQVHJoVLML1CI3isqjDVM5cxtxqPwR/Wvja918cd0evFFikuMcp9aC97nxsZeNJ+/hU3snHU1Wh6P6Ugcuo4kpuDGK73eMcKM5D8Ywuviu00Ra8jjk0YaveLxwTn5gxfy4YdTk+SjPusPy+Qg+/TnOf+KZSygAiN7RE5QOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 11, 2026, at 14:46, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
> unpinnable, causing unnecessary migration or pinning failures.
>=20
> These folios already own their CMA bitmap ranges, and memory blocks

Commit message needs updating to bitmap as well.

> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>=20
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic =
hugepages using cma")
> Cc: stable@vger.kernel.org
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
> include/linux/mm.h | 29 +----------------------------
> mm/gup.c           | 31 +++++++++++++++++++++++++++++++
> 2 files changed, 32 insertions(+), 28 deletions(-)
>=20
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b0da9be413098..47d1d96bfc7fd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2954,35 +2954,8 @@ static inline bool is_zero_folio(const struct =
folio *folio)
> 	return is_zero_page(&folio->page);
> }
>=20
> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
> #ifdef CONFIG_MIGRATION
> -static inline bool folio_is_longterm_pinnable(struct folio *folio)

I think David prefer to move this function first, then fix it in a =
separate patch,
right?

Thanks,
Muchun

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
> index ebbfee09b7278..fdafc5a1b78ed 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2219,6 +2219,37 @@ struct page *get_dump_page(unsigned long addr, =
int *locked)
>=20
> #ifdef CONFIG_MIGRATION
>=20
> +bool folio_is_longterm_pinnable(struct folio *folio)
> +{
> +#ifdef CONFIG_CMA
> +	int mt =3D folio_migratetype(folio);
> +
> +	/* These HugeTLB folios own the CMA memory, so they can be =
long-term pinned. */
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



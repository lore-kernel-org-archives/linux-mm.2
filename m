Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADAACDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0B36B0092; Thu, 25 Jun 2026 00:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B166B0095; Thu, 25 Jun 2026 00:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6C96B0096; Thu, 25 Jun 2026 00:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0A4A6B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:51:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 705141A057E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:51:32 +0000 (UTC)
X-FDA: 84917211624.12.D55BE6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BEB95C0003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:51:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZUZXS2dQ;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782363090;
	b=XPAq+Nc5lNUxwT4ob7zuUTM1a4VbQVspkcRLARezDfGcFtVhJenRGDkv0EBCkrGoC2HR6d
	ZLRIM/2EzEO74HkZ/kHAlg7gV717p1OhoWsbJuiqrCtezfpf50P57/5LzSaGacPsAIMuD0
	c8K2jYpVIHl5NO8hucfNXVlfIoC/kA8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782363090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96w+rsl6BOwVKY7GU6276Rywonwxs1d6SSBwDoM0CvU=;
	b=wGelLNVEdkbPIVDZijwR9/WdCkhxTCaQwcMYmyuxhiZ/XND8rV1clsv7T1M0FoG8UC4Dr1
	3rUToaaYv7UN6/c8Jb+mCCe8QWhsmUJPolAocy/ZpN5lOQNVRDdDwH37a4MsVa/CV9pE+v
	m4mP+LqVSDIvTHXI6W14pRodPcsJjEs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZUZXS2dQ;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D5A940059;
	Thu, 25 Jun 2026 04:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D24A1F000E9;
	Thu, 25 Jun 2026 04:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782363089;
	bh=96w+rsl6BOwVKY7GU6276Rywonwxs1d6SSBwDoM0CvU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZUZXS2dQ52zkcxNQhGk3y0nKRE3vzT95ctXaiu8oEKRl4GN1K2t7h8rnVwPJ1YcdR
	 cxsahTM0/kN1iIVLL2R5TeuQ7GETeC/y5RBnFg6AmtyROxe7JvHJ6EBGcGEZoXy36K
	 L+RHz9Wz2A5B8UUreg3594HkncHAhLo6a385kkQ9jzrEfE6mRB/tW4oXU4Hd9nvDSI
	 pOuajqwGVcd57TDCPVeX2YW3HXaRlCx19HyzFE2GEIBh1+08TuCHEESd9af8s7l8Mn
	 8WdqdU8I8qjqzGUs55J3eXVbCt7qgB5klYPtdTrjUWIj3c7Afux22hwtDyF2UEZbjf
	 m0CmxZgDjRnHw==
Message-ID: <3b24c25e-2cae-4cc9-883f-ec8e1449d965@kernel.org>
Date: Thu, 25 Jun 2026 13:51:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: bypass watermark when PCP has pages for
 allocation
To: suhua <suhua.tanke@gmail.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com
Cc: linux-mm@kvack.org
References: <20260623132917.104234-1-suhua.tanke@gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260623132917.104234-1-suhua.tanke@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------f079T8lhIYG4XaFk1IKflkjK"
X-Rspam-User: 
X-Stat-Signature: kewz98b5skfrutiax5tjfb3awiib3xt9
X-Rspamd-Queue-Id: BEB95C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782363090-439033
X-HE-Meta: U2FsdGVkX1/zixSraoGPUhyror5Bc/rpGyrKMejq041tisOrm9OphjeVDg7jHWgJh/lDaLhQSKy1Bk8WxUH4YlmRlVn7y9lDUqCEtl5u+PaXBBJikTsHk94dDldBBJ5QtYHumq3Z3pln9Kvu+FV52JwS8N+aYM4N9a0RcJXPhvmsekv2SuqiuioIpYPiwl/pnNTVuxByCDZkgladFUo+4Jg9B3SbJzIRbTEyIo5fdnOWlBiM/sbdbhb6+gsUMr2suEksfT+2fMHIVXPl33odSbOtMZsi5mq7zNwnDcciR/WLJB8NPaJerP7svgbkSFsEH797Nqd2AwANE4cmDAe7im7fGykRQwrO8yuQdJwod+awEmFRmkZuxODhAyuekiudKufMmfNPiIcVjfMLw0pIG10HuJJWfFCwLdu5hp08ellqc6Q/N+um6OJJRocEZXLNiDRZdf5fPyNXI4p6A87/q1cKEOU3V5gFI9t3aDVawRUldFd2sU9eVN2KN+XrnwL+q1QGWq+RrASDKBsW0EiZh2lkMrABf80bQeEFrHRWZVD8sTe7d0Ra/ENNBeV8vLOiGmeDFpLI+X4A6kV12EnsknsWHQPLTDcRn6f/YNTmRze8jHMplcFqhX2XL6b7HAkuS1fvMBfyTKWgOr46Y66KQWnJytEiMWtODYIZ31hyFJEtuoAuozhOmBfX/VSq0unZFSpZo4bdytm7ol7R4Vqa5pNtHZvkFdTpFhJi0SRqRLGGR18g/7llAefW9xFOfEmTOcN0FZSBTHYUQAS7YcsfZgHm+P1tM09r9cNg+yzd9zLgZWostj29AUYYoSg8oUsggTi47OJgXCgwH9KvtKPNp3N2rQby2Wd926mAPTbdpOd6QlcJNzSPC5+hE/zsS7bz0LxB9WdbOGD8u9KPiQiHyEsEph0m/uqRWzHIkmQDHWdj+OQYrqDsfEyeuCDjPaJ2RRP1QBk8gSC554KsWfF
 WXdyr/P/
 zCMLsM5S4r0KiaGU59XQz2WKsJKmRjJK+bvzqbrMXlMZfS5H1sGSVKVDIJjF8E+fqbRxF+ILizrs5wbgsFZUwU/YSG3j1IzuQgVwcuZO6vmkj3ZX/9Sf5eN9H+FolQ69pM7XfRMMYGh09t68WplM+Rl2YiKskdN8HSDJT/NHMceppb+4jhuYImv+OfK5Qu4K4HGD7ZYIOZfy0/RjMpq+kQySPWhjG/h21T0Bk4pWOchQPSUeDS9Qaxeyl9aQs5j7WAlkBDhn/qU6OaTwy91VFu28zpcbO90AmdmF6OwXBOJ0qdtErlEvi4F3VI0VexB5JHB8yTbZy47FX+1zVs09/eRuhBhCgybSNOQbMlNW68VYLVAn0Eg1dt6zE3SybNJH1fG1+I+MTP4dSy6mEbm1vom4uTj1X1nw20XGqlws5CIeHzIz0xT97jgZ/jOGBI1a/vm1EBdwzVtIt7Wz10908OqRBKUpokP6r8xo/s5jMZjFSI+7C1iyLLvbk3+gqCJXMawkAPHFE3uYDyi70h/XurMvToOd2dmwN0STLp/m0wIYeSjC/G6Xj0rGhXik5tp0c3yWC88NiJaD/gdQKV3Nm4f8sUC20i4+SgG2y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------f079T8lhIYG4XaFk1IKflkjK
Content-Type: multipart/mixed; boundary="------------OMXkJxZW8Waa80TWPA0UVNLb";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: suhua <suhua.tanke@gmail.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com
Cc: linux-mm@kvack.org
Message-ID: <3b24c25e-2cae-4cc9-883f-ec8e1449d965@kernel.org>
Subject: Re: [PATCH] mm/page_alloc: bypass watermark when PCP has pages for
 allocation
References: <20260623132917.104234-1-suhua.tanke@gmail.com>
In-Reply-To: <20260623132917.104234-1-suhua.tanke@gmail.com>

--------------OMXkJxZW8Waa80TWPA0UVNLb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 10:29 PM, suhua wrote:
> NR_FREE_PAGES only tracks buddy system pages, not pages cached in
> per-cpu (PCP) lists. The watermark check in get_page_from_freelist()
> uses zone_page_state(z, NR_FREE_PAGES), so PCP pages are invisible
> to it. When the watermark check fails, the allocator falls through
> to the slowpath (reclaim/compaction/OOM) even though PCP may still
> have cached pages that can satisfy the allocation directly.

When you hit the watermark, the system is low on memory.
Why do you think it's reasonable to ignore that and allocate memory?

> Add pcp_has_pages() which checks if the current CPU's PCP list has
> pages for the requested order and migratetype. If so, skip the
> watermark check and jump to rmqueue(), which will try PCP first via
> rmqueue_pcplist(). This is more direct than draining PCP to buddy:
> no page movement overhead, just a list_empty check.

You shouldn't bypass the watermark check just because you can.

--=20
Cheers,
Harry / Hyeonggon

> Signed-off-by: suhua <suhua.tanke@gmail.com>
> ---
>  mm/page_alloc.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>=20
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f..70f5d0dc2485 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3784,6 +3784,32 @@ static inline unsigned int gfp_to_alloc_flags_cm=
a(gfp_t gfp_mask,
>  	return alloc_flags;
>  }
> =20
> +/*
> + * Check if the current CPU's PCP list has pages for the given order a=
nd
> + * migratetype. This is useful when watermark checks fail but PCP may
> + * still have cached pages that can satisfy the allocation directly.
> + */
> +static bool pcp_has_pages(struct zone *zone, unsigned int order,
> +			  int migratetype)
> +{
> +	struct per_cpu_pages *pcp;
> +	bool has_pages;
> +	int pindex;
> +
> +	if (!pcp_allowed_order(order))
> +		return false;
> +
> +	pcp =3D pcp_spin_trylock(zone->per_cpu_pageset);
> +	if (!pcp)
> +		return false;
> +
> +	pindex =3D order_to_pindex(migratetype, order);
> +	has_pages =3D !list_empty(&pcp->lists[pindex]);
> +	pcp_spin_unlock(pcp);
> +
> +	return has_pages;
> +}
> +
>  /*
>   * get_page_from_freelist goes through the zonelist trying to allocate=

>   * a page.
> @@ -3912,6 +3938,16 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned =
int order, int alloc_flags,
>  				if (_deferred_grow_zone(zone, order))
>  					goto try_this_zone;
>  			}
> +
> +			/*
> +			 * NR_FREE_PAGES does not account for PCP pages.
> +			 * If PCP has cached pages for this order and
> +			 * migratetype, skip watermark and let rmqueue
> +			 * allocate directly from PCP.
> +			 */
> +			if (pcp_has_pages(zone, order, ac->migratetype))
> +				goto try_this_zone;
> +
>  			/* Checked here to keep the fast path fast */
>  			BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
>  			if (alloc_flags & ALLOC_NO_WATERMARKS)

--------------OMXkJxZW8Waa80TWPA0UVNLb--

--------------f079T8lhIYG4XaFk1IKflkjK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajyzzAAKCRCGXBN6rc5S
1kbjAP92Kfy2JTJuJfdOMjvkeUi4EmjIKseZNSVYp6fLYdlbQwD+LX6L3MszC64B
0+rO2KS/SpJwog7P7xp1V6BFoZr+LAw=
=2i4G
-----END PGP SIGNATURE-----

--------------f079T8lhIYG4XaFk1IKflkjK--


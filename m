Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBD7C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776C36B0093; Tue, 21 Jul 2026 01:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74FC86B0095; Tue, 21 Jul 2026 01:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664786B0096; Tue, 21 Jul 2026 01:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3630C6B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:03:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DCE8140363
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:03:24 +0000 (UTC)
X-FDA: 85011590328.16.B04F00A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC0D240003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:03:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/+FvBBd";
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784610203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yL7QhE7xap8/XcGHCblR4GvLd+vs1TKDkVYo+vOFs48=;
	b=LCaVjhIxthbttxph7h4RQoNqTzRfujm33GZAP9i0kOiDoxK2Su1+96WYUs5TcemDXlwLSc
	6ijwT1/nlulb914edLHGMXNwOq/hhcXNU6HCMvfMBEUvHf1Z1VfAwtMUV64Kc2FipOvsWC
	jBnGjWU0p8DvcTdDocTTI7uk2FWxoTE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/+FvBBd";
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784610203;
	b=1gGrPEwmiX06qihUTMZoKgV+j7pndm9rf9iBU1zor2wjCk1cOjPGYJ115aJGJcvhJY9vZ0
	cVAzjKz4dm31uqvTZC2Z4vU81zeWklbXKSQ990nElVr7Fw3mZsFSNou+/7cvTBFcu4vobB
	qsB6w8O7mWM30ZnR04WIY3xXts1abxM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6164660A7A;
	Tue, 21 Jul 2026 05:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36F81F000E9;
	Tue, 21 Jul 2026 05:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784610202;
	bh=yL7QhE7xap8/XcGHCblR4GvLd+vs1TKDkVYo+vOFs48=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A/+FvBBdCq1YbkKYfBH1h73jKORqxBWSQppcc8yzKws5C/sp4cMqSiHp8DpCta/Io
	 qgh0c+KQVrTeIpJZ/JW0/2QIOf0ohcZG6v8pA1tRtaYMA6FIkoYixakEjFaPo/8z0X
	 aiDW8eXdivI/nTxWzWqptEChsvLeDSMNzJ1Jg/cYKvTq+sXUUf+/XjbrsHbaIYe9LC
	 tKLpmKxvstU/8FwUnRzKwe4hje65XGnG+WxNn0Qg/Z3Fcpin7g5Xd9RRIc6qVdXeAf
	 UdAzAInZ7St3PAp8ixwjfHP0IazV3kOoXAYmTM2D5R2crCcDTaf5Yi27eLz+0mLox3
	 TMUrLCROczK4A==
Message-ID: <c490cb17-2ca3-4f6f-aa55-8a5f8c037196@kernel.org>
Date: Tue, 21 Jul 2026 14:03:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------u6dQlMPgp5OPkjpABcZEdPVJ"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC0D240003
X-Stat-Signature: oqy7cyex8xtswdjz8mkex6nkir7416xg
X-HE-Tag: 1784610202-422281
X-HE-Meta: U2FsdGVkX1893nx/uODhKQnAipojciAECguOGwP6Kk0XdhpwFSnkf//KppyMS1tsy0SHEJEoAjAwBTNA2vQ030rpQ69W5ZZ0Xa63yv2YXIJxD2KgCwzy4uAgqdElfriMkTSrDLdnQziMyBwfLV5gS++rWYTi9n/sVIPlLzqzlGP3X7xvqo0d5zsYFVVcxQ2vh1gN7nA51OgD1l7GhDUET4xX0jj48khrNSngisUSrNwurse3wDpWkAJBQrYDIOMg31PfxW0j3mLwQFO6FtY6tvcqMiVNNObN7mjJWkEbpx1Ed9UxuZag7npF8t5N48JL05S0bR5FHM3bc58KxyS2z6KFeU9KiJn7eerd1qXaBITuFIqa3CP563Mn0pNWsM/FKR9KG2PQgUT7Br+dgg0o/7/mvxK4/jqP6Ub0F6K1wwADcNSsA4mllL5Ry2StEgEKYbZj3V4r3WRlmwajItKG/YjKyJLrx09PtAgQjobC9QzQDcVrjA24oUd4lFGS3AKS9pucGQXJNFKMM4Wr+twPzIUCd5TW5V56Gxyl4eifwTiXT/j8xzJeKD9IdoMwsvAcnUzDU46gnPxz/O96eSKnV+Rc3Ly7vGTH+Edz6Gj7V6brvSTYooPLGqP2V7s+pndPbKA0Zeh96Ate3ThoEBl8AbiBpTPvBlhQpLbHPNLSS0Nago4NTJzCq4kviQF6UlBrfJn2sv/HkvPXPZBl0nN3ldObs4npyOB4orjAohTe55o5u6KrEhpMvEcp+m+/lszEygfpwKuTws55gt0wIgXzRry8R1czkIVfI9kKPd6FxxXEKuwTnMtfz4RImm/Yz+7vh7I4qf2F6PJ8wDXl5iEw33/p8IT8K7PPlm1qxMQaEZ9AWusw4uAIGhDOdXIQRBCcOUE5v0isOhbTiHHVDRxN0lnB/zvA5AMcWcTDbukEVOWqzxAAapbQ5wR5oudOa2/OeJYutd0Yg58+WaDxrS+
 U1TuYZ8+
 YeYvF4+pyHqmOoYVZIKNc0pLSsPdc7uSjI9h0pyFqebFOZLH+RzlPxWqCvNMC0gRDs/WXP52KKsms8sgQW0TjMSSz7i54DWnlq3qsZz4oHR8ccY/StmarA2LWDhDygyTeInThTwoZnXpmTxEf06YbDik3XzoTcOEnWtJi20lDYUzAoXY5+yOYrOvRta2VrJPwGTPPBdLmkoTNmb6/ezrf4IWfOyF10N9WjzpEJEulv+inUhclCPSedmeerxBMeXvgfGShKgLpas7njYFMrq2dvmu7VqcGch5WkNITldZ+BMHcDV7mDVgelY+6grYfXtTnuwCvKCck7zgnDPpHUJjPHogXkDK6PSSiPjmYjIfQTpu7uebcShXJ1DMpjV2ZOkEWZC4Kv0XrgYZEVmhuu10uzwu+HvgcUkAPdc1yzq4MBjrWCUxXlDG76sb66KRr3ksM9VIWyedfqMhk3WB5gCKRXGXnS8aYRxml8GxclJ/mch5UpPDK5CvN0rTOcDR6sLdyBYsNiXvOB05w5iyv4p+3jwXgw2RDWLhjzRsu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------u6dQlMPgp5OPkjpABcZEdPVJ
Content-Type: multipart/mixed; boundary="------------F5vY0xrhNe7uLF58JxD6r8qZ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <c490cb17-2ca3-4f6f-aa55-8a5f8c037196@kernel.org>
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
References: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
In-Reply-To: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>

--------------F5vY0xrhNe7uLF58JxD6r8qZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/21/26 9:45 AM, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
>=20
> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> placing it in the barn. Without an explicit restriction, this refill ma=
y
> draw objects from pfmemalloc slabs and consume emergency reserves.
>=20
> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
> non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
> because this refill is a best-effort attempt and failure is acceptable.=

> If the refill fails, flush and free the sheaf instead.
>=20
> Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocations=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

> Changes in v3:
> - Replace =E2=80=9Cnormal memory=E2=80=9D with the more precise =E2=80=9C=
non-pfmemalloc slabs=E2=80=9D,
>   and add Fixes: and Cc: stable@vger.kernel.org, as suggested by Harry.=

> - Link to v2: https://lore.kernel.org/all/20260720211127124sYtTNbvsxCXN=
9_pDh-pwt@zte.com.cn/
>=20
> Changes in v2:
> - Add __GFP_NOWARN as suggested by Hao.
> - Link to v1: https://lore.kernel.org/all/20260719113701797vZ3R8NxiqYt8=
dEfeUxtON@zte.com.cn/
>=20
> ---
>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 53b4976d3831..357b7522c817 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s=
, gfp_t gfp,
>  	 * simply flush and free it.
>  	 */
>  	if (!barn || data_race(barn->nr_full) >=3D MAX_FULL_SHEAVES ||
> -	    refill_sheaf(s, sheaf, gfp)) {
> +	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
>  		sheaf_flush_unused(s, sheaf);
>  		free_empty_sheaf(s, sheaf);
>  		return;

--=20
Cheers,
Harry / Hyeonggon

--------------F5vY0xrhNe7uLF58JxD6r8qZ--

--------------u6dQlMPgp5OPkjpABcZEdPVJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal79kgAKCRCGXBN6rc5S
1sysAP0bLAe71suWu01qjf0IJEMD72FgCsyul/qZocwTW4mnoQD9F1YuVGXav7BX
FGTXMAHMF5tDbJMquxnqzzWItq0ihQY=
=1FCG
-----END PGP SIGNATURE-----

--------------u6dQlMPgp5OPkjpABcZEdPVJ--


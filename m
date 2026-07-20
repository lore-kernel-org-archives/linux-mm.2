Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33B55C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365B16B00B2; Mon, 20 Jul 2026 10:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3166F6B00B3; Mon, 20 Jul 2026 10:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205BA6B00B4; Mon, 20 Jul 2026 10:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDF486B00B2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:17:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E3921401B9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:37 +0000 (UTC)
X-FDA: 85009358154.16.556A4AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC7B41C0010
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AbSIsfXs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bcg+lq4YYVZFe9NUBLJTEPf7ouJ+niHtp2yRG82CKTY=;
	b=BdfGqxmoz3PxLnALQkQyAZgq08b2H7EuKbLyARWN+AIzp/jRIzLIHMHybl8BsAqizb3/j6
	v02Vn25g2KKsf7o5C+osEKapE+Uo3G6Ihz5PXlY7L7mitWeoK879pyNXXe7xvHDt/DK5QM
	cNDP8LRJRNIr6jUMkTlgcq6YoWrgQoY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AbSIsfXs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557055;
	b=4R5JsP0hwWB9b1NXB6fdhrnd0nLLiPAiZHwxnobKCLL5HitnVK6Xsk7HBDI2LQvBmoieQU
	tmlnHwX/fLFHiZT0Iu4EimrNU9VqBcBGV7EXvcuBvDj6erbWvtoguCvLJNSenU6nWTzOpV
	b+lyIod/rPtEDknGUkfaV+2CnLfwuGc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 180B4401CE;
	Mon, 20 Jul 2026 14:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4E21F000E9;
	Mon, 20 Jul 2026 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557055;
	bh=Bcg+lq4YYVZFe9NUBLJTEPf7ouJ+niHtp2yRG82CKTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AbSIsfXsTm2pEHE0IhoMOmYWOzpgccCL+cwyYwc3EBZlQXevSkmZMQT9DAkyTaoN2
	 pk9RzrmeBTk0pru8CDGx0ovU+nnAoy1uDCu/0gZ6Qchz/EEvumGNEmurbcl7NZtwvI
	 AH+38QgBOeTbmyvU34y0y+97xFIBupMQgIR7QwSY0iBC7iAoD9C0imzhS9IqayGr5F
	 bwjZHDhVguSrYLKNfB98zFH5AWMdDoTkVd5NAem2eLP0fwq0BFCinys1jVXrLIVYfk
	 aMzp33zKlRIV4c+922gFHvpuE9PWmS2ZTt8du9/iZKNbOLiLc+ii3xHWA00h1J7Ufw
	 rHlvqTYJcsR7A==
Message-ID: <32ffd484-6fb4-418e-b30a-7e2344dfe35f@kernel.org>
Date: Mon, 20 Jul 2026 23:17:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: prevent pfmemalloc objects from entering the
 barn
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------a7k9JHHmnpHlPMfnRu0AhtCJ"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC7B41C0010
X-Rspam-User: 
X-Stat-Signature: xdj8nnjmfzbwyb3iidd99qcfw4dqcakr
X-HE-Tag: 1784557055-327888
X-HE-Meta: U2FsdGVkX1/8o6t0oSitdgTAIqsF66lrmCiblT077odkuVcMlWlBZfeoWBQzEdXREBCfJsbqZagv559zWuYpnSivtkxMGD2mNKJZySl+P5nHrGgSV2S1uvaZPs/g2jsstc9JVveahIJkw5BBn0OkBEAN66TLqrSz4Woouq4MSkKAH44j4nljautMpzkdFyk23R6sfEStsel5SuGVqRBsF1qIWq8mEwMTEZtMDh51XienlLFOd+VAsV0R3iCSkpFG0gi9ePx9SypTNtJu+oWyVROSsqKx5Rm+5xmabT2XKWy8nnZ8zT4an/MQTvmQUfYr3eGc/yJIr0q0Wf6aZUHQda9yTgXsg3XHGqvPez0zrN5ARONdlDTaSJfoktq0G+FQNfjFLskFJvS1nn9BjlhAsW3kmKheNB4ZyzbAvNHsTCGzPOk9yRW85JRA+EPvAGlYf7t6MtReDRFwWnjwJMlZ8BXuHeR6f+qjYk1KQCvDJecdrfGC3lYG29hzUQKfSOZ5+zciBiFYLOe/SCW6PvYnkOXUOYXx1p42hHnuO0OmASUeB0nXmjUxY8pJgj1Pwm5OrYfrEp+qrxqHPt6wMSwmvsx1bEh4K3P/khb4WRMzqpW5KxgQfs/NW6gN/SUDhPRGieFOh+zTl59zn8veTShQnW4s9nDQ5WgbPM6ZRfm6W8r6h9GzQcg8qYJmaC0A7FWKIOD82NadquK2cOUYkAVETy0gLY71nbmpEMdHpNVD10JkaPbjukbYtuQqsGVQxWIgDFvT6qpd63y2OygPEMWWfjXbsMqqN817A1ELWnjfuQ+NblyWbevOFQCZ8ZxMXFXoUTgfzBqDO+2benlxdad2+S0uKqvdnZPJZjMvXVE4fBEixZRlZnTAjJIPDFNAy66bqJ9LEMKkFaVKiXG97ecnbt1UuyPn3zRjbC2TbLndXyDiRLXzMpfEvYMswSZJS37rINWajhXLiX4SMtq7AxU
 jrhSxmQs
 dnsLLtu0veTFKQyRvuzcDsh9wi7BiXCSHwtpewGT08HaT5vLZrih96n/2+kn6HxAv9cWkaxrBVQD20z/0W19kZVsgJSV62YkmLCk9f94MJf2AISXdcmdLV21pVjcjxgRvhJYBqZj7tmRexy2RvlJxTBljLWeC+E/tDxNOEQyW8I+rtUss1xJDET4KEDNUBWrjfsoeUciNAIcZeiq5g4LL9Outm/GBNC5C1jTyVUs4e1fihDi9osjCkiYofYP/UkToU5F/DyWMtT/vQvjb+nJDndO7BJJ6NbG/C5RyD2V0Q/KCit0vYMb7aC9Ql3dEvTpYoojBZiUGNVKia4Hl1vGf1/AsTmGVEXmtis2BFDRyz5l7MQWW2G1TC86OcjDFPp5r84iEAiywdw6q39HlxUVS04j53c4+C4ypDqPj9y/5zNiWPW4YC9C7CG8HFw5SyY3HPCjhaP7AGSWLTe6/MYYIIwCukq/ttf7tOl6LqcfMnzOs1Nd6gE5wA6skRDgWl0yQ53wZHuOxd2b9smsZP7Hf/wPFl3j8uW+cPO4n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------a7k9JHHmnpHlPMfnRu0AhtCJ
Content-Type: multipart/mixed; boundary="------------URmXiOWeRnM7023fUf4kisMU";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <32ffd484-6fb4-418e-b30a-7e2344dfe35f@kernel.org>
Subject: Re: [PATCH v2] mm/slub: prevent pfmemalloc objects from entering the
 barn
References: <20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn>
In-Reply-To: <20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn>

--------------URmXiOWeRnM7023fUf4kisMU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 10:11 PM, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
>=20
> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> placing it in the barn. Without an explicit restriction, this refill ma=
y
> draw objects from pfmemalloc slabs and consume emergency reserves.
>=20
> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
> normal memory. Also add __GFP_NOWARN, as suggested by Hao Li, because t=
his

normal memory -> non-pfmemalloc slabs?

> refill is a best-effort attempt and failure is acceptable. If the refil=
l
> fails, flush and free the sheaf instead.
>
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---

Overall looks good to me.

Probably worth adding Fixes: and Cc: stable to make processes' life
slightly easier under low memory situations?

Given that the API is not widely used yet I'm not sure how bad it would
be in practice, but the fix is quite simple.

> Changes in v2:
> - add __GFP_NOWARN as suggested by Hao.
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


--------------URmXiOWeRnM7023fUf4kisMU--

--------------a7k9JHHmnpHlPMfnRu0AhtCJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal4t9AAKCRCGXBN6rc5S
1tiRAP9uy7YoCzN7G79L8h0HvO3ST9NZoN48h2vB9G0bq4jkQQEAoNuZ8D/in+Fy
tqqPNLkBMGA1aasMpcs+zqafFkJMeQ4=
=v6oj
-----END PGP SIGNATURE-----

--------------a7k9JHHmnpHlPMfnRu0AhtCJ--


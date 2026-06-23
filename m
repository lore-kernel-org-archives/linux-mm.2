Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76487CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4426B6B0088; Tue, 23 Jun 2026 04:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4028A6B008C; Tue, 23 Jun 2026 04:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316C36B0092; Tue, 23 Jun 2026 04:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06D6F6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:42:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D5828DD36
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:42:46 +0000 (UTC)
X-FDA: 84910536732.19.A265920
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC7842000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:42:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kH1EY9Ft;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782204164;
	b=kMcf4B5INz+ueU1NKPGapRVaruKqO4ps9EcO879uMc73XDWFBdP2JHhk8MjaBEiSqF7ebB
	ahJiJ59CVgjwvlu+rz6znHmZQZQF4e876DWJVhEG/8Sc1sqeXD1qF7o//R3QmSZYqwoD0M
	cahhHpP+fZ/2BqZaIckSp7fY6GydOZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782204164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvtWN1xiCjJwXiB3+SIzkmRkMwl7Gqj7f6Y9+Y6EJHc=;
	b=jpP2818OIjsH6qYlGAxrcyKlXOx4MWKGqpkGy2yoozxs8AaCrPn7lNu8Ew70E4aFWuOr7F
	p8DMfsaDJWRAOJz14yFa9wsn5Uu1bxkNJ8aEdm8NyExfI81op9LoAlhcwbXLKYkISMuEZO
	ANxF/qHTlSQJgcoN5rzlMC7Nil5pciE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kH1EY9Ft;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC070407DC;
	Tue, 23 Jun 2026 08:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7D61F000E9;
	Tue, 23 Jun 2026 08:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782204163;
	bh=WvtWN1xiCjJwXiB3+SIzkmRkMwl7Gqj7f6Y9+Y6EJHc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kH1EY9Ft+UdI/ni3u57iqoC8MmP0qyZL/qIE/vbffZbyFWP2v014OtRjw+jgb0Zix
	 bKYQ4IgnCcmiMrvMRlBqQ7shfTmaZHA+9LmWCXohb/d3qwyD3IOKkn6BQN1Z8zwYHM
	 JUsCpm8HNwZMNC0EQvV4UOZDCHp+7PZPAnEM4pMJzVOevfOU5K7Hgrmv7qrub9pQpd
	 ppn1BjZ74vV6ZH7Q2Ug6Mz2CbEPUin3vpbK/IGNMqSQ8Lo0tu2FB56fQkJJNzb4ht7
	 cYqEczV8M2k0mH43v0pPgfAF0T6p7HGpapbsXmqNtxWEfTpTiQhen6xkQJ+1GyysNV
	 zxUWOpUpcOH5A==
Message-ID: <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
Date: Tue, 23 Jun 2026 17:42:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260623082614.81621-1-guopeng.zhang@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------LgOrC2BRSzJunWsHWQMW456l"
X-Rspam-User: 
X-Stat-Signature: 98x4qqgpsf1w4cjcj91xcjrstnco3acm
X-Rspamd-Queue-Id: BC7842000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782204164-912614
X-HE-Meta: U2FsdGVkX1+BxuWJSYpZAeCyZnK0Ab7X6pr+MijIHA5aOdwpWmyjttBfheJlB2ttng3M1rX+Z2nocy18Zp2YF1Z6eGBu2STWjuHHmHysVCXNyyfrtgkOl9cFB9oec10v//crXWiF95Ehs2wbzfp6GxUPPIh5/n7+dO89+CGoEMWQBK9U45+M2lo/D4n21NRQ4uN4FysgjPmCanJ4z5GsHqPsycE07GU5klRU2AlgKCXTYUb7tmO4sICCxFhSQfztJaWg+QNZxHmH1eDJCJHqST7/co5wHg+Ti5QyS9vyhQa58i9Gu2xVT42NnbDetlqU2M6a5+Irf/+gGhWrOViGj+y3XNjdGrjCKM4Bm7g1UiRJe5C0JTOUWFEfgNV0UiF5/YCiztHnV3mhy5AvArAn5siuyMKIBuNKRqWmHyO1ZtqU9WLfPaBwFaNeG70mqURJEZOXftkwKc6ixsFlj7EQqdU5fw7iW1NjlrOnCeRdrTAlstnC/F6PUkmj+CSETVAZ5r29TTxIK7B5B0p9j+ZLfYZzZxlEVK6H04Z+LhrDEqhXPY/96nje5fCRhQ1QTjvunYueZ5ZFQ6QmKNB1TPyd+rIKZWfTYjvDCFHZdSmd7nF2UVHQMHDuLmH24do7oMQPb1Rnmancrj6R3Zz+TwtJz2IgGExHITYV+lc9bBPfkfcwIO7IUaV4Idh26df1xsW83VrNFI047g+B6JvubM58USzJHWcJoJj5pEJl8lpD4o9GgmMaIbn5GvRZibW1WH4ZL0wXbWqhoyv7VuSVmpB/sJ4AvrYvZp9LYK3jdIXxaIuJLx3S84wwh6zE1wWNSSpYBEcA5Cj8PoKcx6imB0lyyqll8qwl00ejnpZmR4JJS6/7fl13wIVcavu9/Mc/eodu/XeMvDscC3sjfCkiqdIujG5GAgrRGgjvYN6hGfrl7XsveI4In4eTpSaxen2C0OHcbRokMH+EmSBE1PxQCCT
 pWHO0E49
 GBGuQNFlRKMFB6w/y/TWNRItEc0LtztXQJ7/JgOGk91sx+pPgHf3FCrveo9CnrDuTBEXipCT9LyTcVrvFUOD03iq8wV6dJizbb7hXyduqzNQLJzgf5qeM2UIZoIBa56gPBQiM5vMX7rdm0lXZGVvFs5BhqZ7y6MQ1MgmkUWbCB7DE5Y8sDaxOTAtSMZpaTwO2mkiLPHnOIYv7I67cXtrQh+L9VKtbLNKErTc0i8jLCve/6Z+T8UwgvnXCl7ScFtDt3OT15hQt2o4FqZU3+HnPCiMN/Rl3MtTHjsXa3YWGS9F87+ZUO/W0r/7IfrbV1Ftmfl016YujCHrgLgRO7EpKRfXzxUePIo0RqMPRgDKdqh/Tuxah1PiNKQbS+lFs7uUNrgRAyl9IYhghd+H5Yi6wrkTDRQvw2BrbOw//1xFGfQ4DEQLyuqWDt+hzXkZ1WULloUWQRyGyvR07fk0lEL0QUt3R5wb/9TKXkLra2sCqBA8Z1Oa/5MChO6KIZJxMeE+ke2utahMqvWDLORwwzPu6muR5Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------LgOrC2BRSzJunWsHWQMW456l
Content-Type: multipart/mixed; boundary="------------3PVOusf7gTMSTMxMX4UWEjnM";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
Message-ID: <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
In-Reply-To: <20260623082614.81621-1-guopeng.zhang@linux.dev>

--------------3PVOusf7gTMSTMxMX4UWEjnM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 5:26 PM, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>=20
> A patch filename was accidentally inserted into the comment describing
> the nr_bytes field of struct obj_stock_pcp. Remove it.

nit: perhaps add something like
"Fix a typo in the comment (target -> targets)"?

> No functional change.
>=20
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---

FWIW,
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..3eedfc4e84a0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
>  	/*
>  	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)=

>  	 * keep nr_bytes to unsigned int as uint16_t cannot represent the ful=
l
> -e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-pa=
ge remainder. Such archs are not cacheline optimization target.
> +	 * sub-page remainder. Such archs are not cacheline optimization targ=
ets.
>  	 */
>  	unsigned int nr_bytes[NR_OBJ_STOCK];
>  #else

--=20
Cheers,
Harry / Hyeonggon

--------------3PVOusf7gTMSTMxMX4UWEjnM--

--------------LgOrC2BRSzJunWsHWQMW456l
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajpHAAAKCRCGXBN6rc5S
1l19AP9QHR1322qFfoOBeJdfJ6IA6ZpZt3Tz6oa0N59Be08okAEA9sJXP5B7C9O9
pgwT4jOiILEhQIen/p8J71ZxryzPoQQ=
=MJe0
-----END PGP SIGNATURE-----

--------------LgOrC2BRSzJunWsHWQMW456l--


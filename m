Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B721CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 05:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E312D6B0088; Fri, 19 Jun 2026 01:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E093B6B008A; Fri, 19 Jun 2026 01:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF95C6B008C; Fri, 19 Jun 2026 01:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAAE16B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:19:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24EC08D49B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:19:06 +0000 (UTC)
X-FDA: 84895508292.01.02D0446
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5D4EEC0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:19:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHSq15pi;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781846344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0WQXKZa/yAPHQbUs9dLkQN2esDMhYBXPa9Lzf4iMSw=;
	b=B5iJuR58J0IvyoqQ3sEANugUFqkF6MHlGCNcrmjJRB5HNuk/hJwIHb6sLJLpvssXud/heM
	WN0QZDLEK69RYdGy4BAx1Hy/I1uHTZlxw1E9nC5ygyzueKH1NeXLZDE1K5X+mlAuhcrNBD
	qvt4lJp6CpVB0GeDR3fTIuWQPo3H3EI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781846344;
	b=Rh4Zx5mx46h6B4peEsD0j571fz3HhU1aXvD1C1EaXljXaKMnBHGlSNvBO+zqGUtY7uGaSf
	7KYVB94rCNAIP+dERwHUQWzqCAGG8f2LySVQZHpML6eVNUVFMv1bAnVja7+bWzLkA0XPT/
	5UdKjGK/4XaWurzj9LqvQkxJns5NuJo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHSq15pi;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66AAD4093C;
	Fri, 19 Jun 2026 05:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB4F1F000E9;
	Fri, 19 Jun 2026 05:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781846343;
	bh=n0WQXKZa/yAPHQbUs9dLkQN2esDMhYBXPa9Lzf4iMSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aHSq15piz7ld4db3e46JH3zywFyou9Lf3nDfq+LVIm+k3H3ga6j2j4IIyBfRGdLsA
	 1jk+CKcHK6momeyF3IxCxQPhE8LSXJgpwzhhKKegYFSOQdNkTuw0depL2nkkf66pEx
	 Tkk7BDabM25+Sbk2H5lnco1x7xko06vhe1Zz888SNY2VS8PvV7q77a8W8Ku08MLOVO
	 jv5FXWtsctGR87yD+DBMRmtArRPqGzf0PhPkCiWywMLVDw9h0F0V4JZFHE3pZQaTvj
	 dql2Qu5PDMsRwd/e1PAChINPTgk2FFyc/Iyj0tV8Fgd+9LpdLNjG8DwpKN9jTPNPyo
	 /4OwhRgUdx3Rg==
Message-ID: <b270ce60-b335-4f26-bf43-c8e7003237c7@kernel.org>
Date: Fri, 19 Jun 2026 14:18:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm/slabinfo: fix total_objects attribute name
To: Vlastimil Babka <vbabka@suse.com>,
 Yichong Chen <chenyichong@uniontech.com>, akpm@linux-foundation.org,
 Harry Yoo <harry.yoo@oracle.com>
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
 Hao Li <hao.li@linux.dev>
References: <96556748872BB47E+20260612071359.649946-1-chenyichong@uniontech.com>
 <65f68f41-226f-43ae-8bfc-b9a321bfe5fe@suse.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <65f68f41-226f-43ae-8bfc-b9a321bfe5fe@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------LFY6cLE1Bu0c2UNxfoLl1Cto"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D4EEC0002
X-Stat-Signature: 4n5qc6c4ipcu67ocjmnpk1hzxmk5oadd
X-HE-Tag: 1781846344-789896
X-HE-Meta: U2FsdGVkX1933g1TNFBmQsgueI+EPtipPF9qi1VBRWKFYcwpidbn6f5CcguYs01pGrPc+A5qCg0sVk2aN7Z52RRp41uI2M/zmToCShieWYVGrX7lfTYbqUaYQ7AnISWzVvukFTN8pWtA/LeC5MifEOP9xnsnefc3FYA9bRb++4P/3Jx+yLUFy3uhEvNyFeni/3XV6sjzFyQFRCXrFq2813sYWdmb/clNNhiSal/kacaVCwIyG/bScNvQSIN3VgU0tJpEB4K37m2BX2qothDnXFz1myugLZw7PR7tmTW5fgk5V0oADGg7B5m/9lCUjol8I43J65WrVFYRhZw9bX1QX312lh/Jv5rcvZtGODf44VeVArrRTVOCmYH9RlgHt5vkyW/cSejI3n+ogV1QRKJdKoZZfiL4dq4Hop6LyO5PIck0j+sHOuomee3xXN8CoZ2IdAmDc0jlhdk9423wTEFhBAI0h5mDZVMp9RDJeKjb4mjwKQVheIQPrCTYt+a8fpqulKYiyRIi9ZVGrJjMgru5Tp7VagJKROgf6rNs86wFjJh5dGKLhAHhF90maiprp8YmY+44qHaKbUEN14p7w4arU5p93SEEqa95gW1GqMRnpGfREz2YRb00rzmkj2YeYyAihedpKfU/wukC4b5kSjVxZKi3ViAcZURXglSQzVK/u9xgXy5Ftu/XJ+ufL05vkMXCS6G3yOBPdV9lKZsKqLUFgjmhbXcwwl2P0hp/T344beYlK12z7VVFgeRNU7bAdJGW12/0bf50oEIUVQHREb6lTxqgItQUeBzhWEe+muZMXiNwL+VFGmfGKxRRKlFdTbDQvZZ/6+cbbOezuOD1GLYcrC2OYorkTlmOf3apU5LGM6ig3lBY+zsxEALUoVI1pH57+Tz7wWkEWysROImntSHseHVZf8/WKE8FYyN0QHDer0o6QSjz/hXFNP5All1BFOCGSPwOCSbE95CmmMK33NR
 xfsqQVKy
 jjJ+8HN2bQNw3CuvuZjkHEWBSrxzHJy7iS1v4AGt4RPWsHZk/DDK8FBAY7Vx0pPPCxCUAOCx/9ivZEcK+6wMIAp4u+QSpgLCFsAidOKxbUZDXvYFgen4Yoxe/3HrNZFX4Pc+AYYL5jrNefPB+rT5GOJ5dffXIh0sxuPzFrZzrnlvspsb1Rn/rT77jn8/FcCJQdpQjigC2/4zo1zwrPzfFysLhITc1LS77ZWIm2eEeHepG8RGh2Fh3ouXzpfiT8Sq3eRbi7YhxOW/7TLBY6rVAiV6WhINt4TvkWMFLnbQZLn6SjxcW+Ir7BQ0hLAV5SsQ00GsWGpl2UZa2j3P15m1BOnsGn1L+w6nW1olW9+dIfyxS/sbX8k8XUK/4FgXfJ8Ri8i5IEjuEktSp5jusd41OkW0MrgY/MXCbDd/D58GLAobGjfUHw6huAvr9WGAdJuv9b8UJ6x6hWA2BvDRLo1L/+CdK9yRIJN9+6WC45VfoSdnF4VivQ1vCFoMcxD1nNNnA1lO/QJIKhSgm1Mu0TNVpoEsGNGbE3py/xWJJj4wcWbpUUkzF5AbjMd/jUFQYzp8xgid2PUQiy7ebK78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------LFY6cLE1Bu0c2UNxfoLl1Cto
Content-Type: multipart/mixed; boundary="------------bzR0xRRP6eTD0Reb1mV1IqiT";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Vlastimil Babka <vbabka@suse.com>,
 Yichong Chen <chenyichong@uniontech.com>, akpm@linux-foundation.org,
 Harry Yoo <harry.yoo@oracle.com>
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
 Hao Li <hao.li@linux.dev>
Message-ID: <b270ce60-b335-4f26-bf43-c8e7003237c7@kernel.org>
Subject: Re: [PATCH] tools/mm/slabinfo: fix total_objects attribute name
References: <96556748872BB47E+20260612071359.649946-1-chenyichong@uniontech.com>
 <65f68f41-226f-43ae-8bfc-b9a321bfe5fe@suse.com>
In-Reply-To: <65f68f41-226f-43ae-8bfc-b9a321bfe5fe@suse.com>

--------------bzR0xRRP6eTD0Reb1mV1IqiT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/18/26 6:18 PM, Vlastimil Babka wrote:
> On 6/12/26 09:13, Yichong Chen wrote:
>> SLUB exports the total_objects sysfs attribute, but slabinfo tries to =
read
>> objects_total. As a result, the lookup fails and the field remains zer=
o.
>>
>> Use the correct attribute name and rename the corresponding structure
>> member to match.
>>
>> Fixes: 205ab99dd103 ("slub: Update statistics handling for variable or=
der slabs")
>=20
> Huh, it has never worked correctly, since 2008.

slabinfo.c needs some love :)

> Applied to slab/for-next, thanks!

FWIW,
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

>> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
>> ---
>>  tools/mm/slabinfo.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
>> index 54c7265ab52d..f4077746d6df 100644
>> --- a/tools/mm/slabinfo.c
>> +++ b/tools/mm/slabinfo.c
>> @@ -33,7 +33,7 @@ struct slabinfo {
>>  	unsigned int hwcache_align, object_size, objs_per_slab;
>>  	unsigned int sanity_checks, slab_size, store_user, trace;
>>  	int order, poison, reclaim_account, red_zone;
>> -	unsigned long partial, objects, slabs, objects_partial, objects_tota=
l;
>> +	unsigned long partial, objects, slabs, objects_partial, total_object=
s;
>>  	unsigned long alloc_fastpath, alloc_slowpath;
>>  	unsigned long free_fastpath, free_slowpath;
>>  	unsigned long free_frozen, free_add_partial, free_remove_partial;
>> @@ -1263,7 +1263,7 @@ static void read_slab_dir(void)
>>  			slab->object_size =3D get_obj("object_size");
>>  			slab->objects =3D get_obj("objects");
>>  			slab->objects_partial =3D get_obj("objects_partial");
>> -			slab->objects_total =3D get_obj("objects_total");
>> +			slab->total_objects =3D get_obj("total_objects");
>>  			slab->objs_per_slab =3D get_obj("objs_per_slab");
>>  			slab->order =3D get_obj("order");
>>  			slab->partial =3D get_obj("partial");

--=20
Cheers,
Harry / Hyeonggon

--------------bzR0xRRP6eTD0Reb1mV1IqiT--

--------------LFY6cLE1Bu0c2UNxfoLl1Cto
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajTRPwAKCRCGXBN6rc5S
1hQxAQC5C2t9YzgCVPUaklGgWHjPIVj1tDL4vS7pZxKrRpySCAEAlw6zlPfzHnYE
n3ysAn49QVu4bQ2l8bNTJy245zLozQI=
=uudy
-----END PGP SIGNATURE-----

--------------LFY6cLE1Bu0c2UNxfoLl1Cto--


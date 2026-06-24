Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B2D4CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 04:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF126B0088; Wed, 24 Jun 2026 00:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7616B008A; Wed, 24 Jun 2026 00:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7066A6B008C; Wed, 24 Jun 2026 00:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6B96B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:32:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B521E140227
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:32:19 +0000 (UTC)
X-FDA: 84913534398.16.C2B2DE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0601C40002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:32:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OI/OFz9D";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782275538;
	b=Vfo/bu/T47RMoDiU/SNmzAUi7iAEDUy72ZN8NtwE4CLL6hyr5jiUrp7yzPTCzmvcQkWQgx
	fXxkg1IahgnJNhNJJ5a5e1Va1iffr61H0mcnPRjO3FtbS2mH4D3hFjT7S5LXqhquRrJ4ja
	SEk5NBtxG0b/KKGXYQDXu+oS6u9MzrM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782275538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBhmepcwPAdQionL9hmPZMgzcc89UpJpdK93qrjxZJo=;
	b=jRARxrVP3zyWBfGnzSnfZ4HCfTR4a4qy9hXKt2e/gL+05bSeXMygUfmXcr4k8sC77TL/GG
	HkFszeF0EO99j00hJdu0ZFC3wDm8MFMvBP5XpNSui0JjhsttawG7P2thgwQ+/OmFLAa39a
	55mYhHHHNKtHz1WIZzTvL9k3DcZ59N4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OI/OFz9D";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20FA7403D3;
	Wed, 24 Jun 2026 04:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BA01F000E9;
	Wed, 24 Jun 2026 04:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782275537;
	bh=LBhmepcwPAdQionL9hmPZMgzcc89UpJpdK93qrjxZJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OI/OFz9DymW+iYnLZeYRRldiKNHw0HgtGF2VlN4i5hyPAVwJe+ax1XsOyElWBq/aS
	 U7rq4r8fhPlyoIrJydvW6RGcIywyyj2L79UgobqC1ckM/VGQ6caHxeef6n7HGFpIbk
	 Nhvx2luzsJbOQMsiAHbHXyEjKfKS8Mi/gnI40pLklfLuRoAbrX+F652MWVp2PWrxCI
	 zk7IEcI1E+Yn7Os6gUiz2tzGST3u4ZEwX49xcKc2AtnbUugo00+Fjrb0MoDCtsx2G8
	 xjd4GMt6eldAY+RFljA354JxREf70W+lAlFg4CYlgIJwf7SskbkPVPEaVZ36kQcHXc
	 9Fr0klbnH5fNA==
Message-ID: <a3393f60-4ada-4768-a369-900350c97cf6@kernel.org>
Date: Wed, 24 Jun 2026 13:32:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
To: Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
 <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
 <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------9edyMpZu0YLeoI6wTH0LWs7N"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0601C40002
X-Rspam-User: 
X-Stat-Signature: e1debd4hiy59zestp7z6ogwqxr6a77s9
X-HE-Tag: 1782275537-242264
X-HE-Meta: U2FsdGVkX1/Pslq0Gyhs6zgqH2TXPcqnZ0Yx4xOPq6zrqaagjGiZmMBdLV75TAlRQCm/PR7VyqeX1fyrw8gxkH/GSL1SneRFco6eP/hm8UOrZgwrgeS+Rwn7VRtrW/WQ0vGWhDwtB3ExbHVCIvb6NaprGKiE13YojeMfSclTYrK+PUTB5HjPi+vlI7W+YWY9CWzFQVr092n9upsEcWuCrZJXPccfDgEG8QCZqyDBNHxlIxj4w4tHpMdRvQjd4sYG3Id3UcvMJIwcUYmLlSNbvPCSh8jvrSz9aaDyD4MySKk9EQe6xVd6KKudpSembsfcrKLwRI7kjYNOsU0rHFy/4hSfkTOjBfePC6FYDNpv3lEisrtNxgrlSGfPup7guHspq8ZhF+8zv2zXx7/wCqYsss536WjL2YQnqfUHCU2ExkPAcVYIJCMdPupk8QKxLzrs2cmJTh8NuwiKLA7crRWfs5wbLsc+kA4y3kmo0kuzs3Om6mrMb43qAcfArjgj0fytaIe0N8Ih6/tww44BpjYZCmlC7ahKkRJNCTpni9tWYki3hwsUz2bKttBoXmv/5+Uzad3cYzqOdEfBrX6SCYmnZdrDELlpghalJmItsL2uaaIMuYmVKxwsdZLmmPXiHHnRQ9bODpRdfzNKO2S4qy8Et+ihy93Ok40Wjd8z7xEGSgSBSrh5myA/LBrivgLZMfSFUN2MAecKXhHsMpj0KGPWvN2WT3GzjQCMOmVFKsy7U2oSyui7BCdsQiOdj3ezHUrCFQxMtKZWaYw8old3lP4WrM8iFB4NB9TKmvSOPyUO4W9c7lrH6wIZnknV/Q3eSeM7CLNA2toNUP0r/yDExvM8PL1Bjy+I5JMjZJuulid57LDFtSFo+UiYZ41nPvCaL/8d/hxdkaoOvdhyJOpi6irkQOdtX9ggjAUaSskrFQrSgz7phVUbxNz6UfqBneJyAHst7IO2yLSSGS5Ev9hzHjM
 NS54NKQX
 zHLrMBx9NIeHZVPe+qCLJQvd5ROiza2JiJwqQcnY1Li6EZzfto2fe/l4e3TTqt8HZb+1Di7ut+dcVOrCUhQwqtN7BJ7+zVyGL6IfbohKyZlD6wr6lvzNrTJx4fkSssxZmat2soJb2N3ePIGHbp8Rsm+eicx7QAGLeSnnnrUjetP8UJmajx1soCxcA2XvnkIUJ6oPpZxQ1GzVq1QEldup+OFKPEhEe23GjbsWbm8dXOWyKntOmzq4UoL2M6WJ4azkaCtljGZmSwBe/Qza9LzkumzLB/oYt4KV/L8Z/FUHJ7VRYoCE73UXXiai1oJwlkbaV4Welz4dYgmWPOYobzy3fP+rj2F1UUB3QMykJIzbpRpCoKUnQgdpdVXSXFiaMsyoQhSa8hM/ZaV7GMroI2GUhVTS811p8HLRYffB0QQF/UnSAR5Unby/CO+14JmmRjSP1aEov2VU/WazAgfec7TtuIOHXrDQg6c6iA9M6+K8lN3V+76a4Ed3CZaMxfrX9iJKirimOS10tTeBVtNLWhYb9VSerBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------9edyMpZu0YLeoI6wTH0LWs7N
Content-Type: multipart/mixed; boundary="------------QRl4NJCYxXXLAPrioGkZRTFF";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <a3393f60-4ada-4768-a369-900350c97cf6@kernel.org>
Subject: Re: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
References: <20260623082614.81621-1-guopeng.zhang@linux.dev>
 <82703e62-4061-4241-b12b-c46b927cc67d@kernel.org>
 <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>
In-Reply-To: <5be54565-00be-4c05-91ca-0825fa925167@kylinos.cn>

--------------QRl4NJCYxXXLAPrioGkZRTFF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/23/26 6:02 PM, Guopeng Zhang wrote:
> =E5=9C=A8 2026/6/23 16:42, Harry Yoo =E5=86=99=E9=81=93:
>>
>> On 6/23/26 5:26 PM, Guopeng Zhang wrote:
>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>
>>> A patch filename was accidentally inserted into the comment describin=
g
>>> the nr_bytes field of struct obj_stock_pcp. Remove it.
>> nit: perhaps add something like
>> "Fix a typo in the comment (target -> targets)"?
> Hi Harry,

Hi Guopeng,

> Thanks for the review and the Ack.
>=20
> Yes, I also fixed the "target -> targets" typo, but missed mentioning i=
t
> in the commit message.

No worries :)
It's not a big deal, just wanted to mention.

> I'll be more careful about describing all changes
> clearly next time.

Thanks!

> If a respin is needed, I'll add it to the commit
> message and carry your Acked-by.

I guess it's okay to not respin for this.

Thanks!

> Thanks,
> Guopeng
>=20
>>> No functional change.
>>>
>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>> ---
>> FWIW,
>> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>>
>> Thanks!
>>
>>>  mm/memcontrol.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 6dc4888a90f3..3eedfc4e84a0 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
>>>  	/*
>>>  	 * On rare archs with 256KiB base page size (hexagon and powerpc 44=
x)
>>>  	 * keep nr_bytes to unsigned int as uint16_t cannot represent the f=
ull
>>> -e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-=
page remainder. Such archs are not cacheline optimization target.
>>> +	 * sub-page remainder. Such archs are not cacheline optimization ta=
rgets.
>>>  	 */
>>>  	unsigned int nr_bytes[NR_OBJ_STOCK];
>>>  #else

--=20
Cheers,
Harry / Hyeonggon

--------------QRl4NJCYxXXLAPrioGkZRTFF--

--------------9edyMpZu0YLeoI6wTH0LWs7N
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajtdyQAKCRCGXBN6rc5S
1vnvAP9byEYeRrjQ2Dz1Xv7nHkARJWKR43ZTTZCNji2vF2IMAAEAloDAjd2BL2GK
jiEpldoBcQUH1F0yDwUYGCFqNNuI6wI=
=MgY7
-----END PGP SIGNATURE-----

--------------9edyMpZu0YLeoI6wTH0LWs7N--


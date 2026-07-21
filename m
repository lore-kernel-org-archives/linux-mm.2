Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B86DC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083A96B0099; Tue, 21 Jul 2026 11:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C006B009D; Tue, 21 Jul 2026 11:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB43B6B009E; Tue, 21 Jul 2026 11:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB0536B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:42:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EA371C0182
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:42:21 +0000 (UTC)
X-FDA: 85013200482.30.1ED7C7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A54F920003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:42:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KW2YAXJC;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784648539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62OF6NSssJksSpHLhyQP/rtfjuUGRZH7myJpUU0DmfM=;
	b=kSYZdEAgpvKoRZ6YlRNHGak9oJB6hInErF+c9i2d6ljedb7E4tE96AT3oWbJrOI+2dCBf9
	BU1mq8SjnpYKEO0Bb6K5mMj+iwsY4UpX8SUEqlsVyxchcsyQIDiM03xBKlEJnesMl5E3xj
	Z8zFqWcXzahYqpp5mlFqGyGFDm04EGI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784648539;
	b=3SwY/DFZ4yXgPPC0LCJT9jiyM7oj9iN00JRqbwwqWgqXxSvorWLc+Rzs1+tAFp3/vN3a3b
	5jxicetXC00TNYS6woepBSac3Puv6zIukNyDolVvDZ0za/lV41a6O6SO56bFc1YkVaWNgv
	FxO8Nx0Mygx5Qg78d4GHqrciLKtB+OA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KW2YAXJC;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C49D40AAD;
	Tue, 21 Jul 2026 15:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7701F00A3A;
	Tue, 21 Jul 2026 15:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784648538;
	bh=62OF6NSssJksSpHLhyQP/rtfjuUGRZH7myJpUU0DmfM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KW2YAXJCNl8qhVsFRzwOAYPlM2AWvmsNX+Tlkjsxa3a1k+SYEadjOodVb+Usmz+bq
	 LHm2JGHEnPvDDzUUdaCM2PlAjMq00MF/ah2bpPK/D+nOQSRkLJp0N1nvFWbjnl+Ari
	 EnohuB0idMlXpGF2dQTIRDzCeh2I5k3Z+gVOmoSZAzHVc3N8fnJdvcBIZnA/ThOQ7a
	 UGUnfEJQ2iF+YuWmTPmv+mrNU8etsXXQFxoGTc6P9B+c90lz/9IDZ66S4R150Wj/LD
	 NBPMcrJ58izFbj6bQQqiiQ75uWpXkT8ddrQiZkWC0sfg0vE8hVvfpJLEOSefxrTV6/
	 YWvfAy9rOkocg==
Message-ID: <ffb9d393-6bb5-4f95-bb9d-0f2e21d7a95a@kernel.org>
Date: Wed, 22 Jul 2026 00:42:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
To: hu.shengming@zte.com.cn, vbabka@kernel.org
Cc: akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260721170439864YfrJGliTZWCikCX-HcPzl@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260721170439864YfrJGliTZWCikCX-HcPzl@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3tg7DmIrLoZVRKTFmyx5wMJE"
X-Rspamd-Queue-Id: A54F920003
X-Stat-Signature: 7ugj8ej8eqiyoucg1zappx16ps5q79e9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784648539-210014
X-HE-Meta: U2FsdGVkX18ShWaQunfyMf+N2TE/Kt47BsynGVe0DIE1tdvsIEVS6etqJtJhedzi/KC5EpEigCQSwqxIik5KKcprZhz+YtlgRoR+eOgPRlrHwG49SgU7ojitTLu3GoDbRdllRAPkPc/qXyT9Xu5bxUtelkRxIWGsz4RiEgFncsh5XH2gcFZsDNJvoeKrGFvLK9X5mKPyqYE5Q7ebYrJbeTz3N6vYh8+gXp94BTJergH32QwWc9jWm6AM6blqc7i9enTQEhR3+YSxr8uSRATdzS/3QMWj3SJJKZwX7cQYKl81C8gxH3rhSC6gHLO4+0xV8a0f5Lm/6kXvci8znU9iQ3wJ5YFpxIMPX9uttctE+E+0NnQOKSdGXr66u6BlgXc7U64nOHOUQE/e0k/8TShLnkv6jJXDGvZtEYYm6pRmPsNViHTxviKu3AcT3gDIhrTf21DJcQH2JqNdiD7vhVjA+48NTmCuCaB062KmDU0dk11Ee5hmMaF3gi8ipmI1RhDdHcDcNVDOLtlJeWZlXJoG9iIma9EOuGW6Rp+Ao0i4OPKngFspvlSCdkG0u67TAEuNZ35Ic3zLvBUukg2yNsHjhtkKEZTKerfi/Vjh7WPA9yffsnVNQxbztIEexYfBBQjuev4ecO63XWSryJ2HYSkDLBy66PXyWGtz/TZEbl+f3FsnWEPB/YC3x3/5cUHnwfuMJQ99v9bCJci8+AT70GJH4Q9jEcaB7oO7H3DnQqA9d6ZLuqnKa/aBhs04CMgtgAw+0AQgX5L2l/dCivcqg/cR7b8lVQHCGhLyFhbupZr9Z9HXYuwBdIIJ7cD57u8TB76jTc0JM3fzjDzgZnJI/RVQOqf23Dd69EBEx4hh7eOBHsvwcIoPdsCGcLA3HdEMpBxkgcJ4kcRjABxy7LHYynyHTpeQp+amCLeqsRQzVaBoSolxUPyEsiuHe0MSlq98AMkoE9+uos9jdS8ZqUS5moE
 xzfr3q9T
 9FgIRD/HMwrfJTg8XjyLzRRpTAbptRlajSwk20H7BViDO6lsrI0xQlHDYVoE/wByDKr6P7OyyrmMnEFLI/gPVJirORuXh0BcEVzTStQ5MEub2GNRU9A9xnrwD3gZNmiQT/5fXeeboBLZAZcx+25cyj6AwDKvk1hCsTl9QnZup6y4VF2cmCDPxJMKEkBDaFl05KzthYbxDiuzQCvjLoKc7hpuZi4qxVEpFxtIfkym53HTEDieTHq/c+3B/Kt0bsWlQJL6MlLVQDCTGQfs/6e1eRGYH+A3da6fEhI1EFa6H/1BOyTtv8gcO40Rjv8TChd93Ihyv4mRm1GYZZslcjTR9DdYeK1rbYHrx2cIUtXGZfqa8lfWogBroj/u69XZUfWG40cDkn9hU73s0VPAtEwPw4eg2mLgP4XH6Ftn4+vATyW6SdU3gxbBObio1C4DK5ieesto/X2Fx3b3LFcUkW+RuGk9Jqbmb0vJKPr53WjVACvP+TcvUNyA7hl/lkMJ08gTjP+/h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3tg7DmIrLoZVRKTFmyx5wMJE
Content-Type: multipart/mixed; boundary="------------sknT1z40q0AKvdHcsxeuBT70";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn, vbabka@kernel.org
Cc: akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <ffb9d393-6bb5-4f95-bb9d-0f2e21d7a95a@kernel.org>
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
References: <20260721170439864YfrJGliTZWCikCX-HcPzl@zte.com.cn>
In-Reply-To: <20260721170439864YfrJGliTZWCikCX-HcPzl@zte.com.cn>

--------------sknT1z40q0AKvdHcsxeuBT70
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/21/26 6:04 PM, hu.shengming@zte.com.cn wrote:
> Vlastimil wrote:
>> On 7/21/26 09:34, Vlastimil Babka (SUSE) wrote:
>>> On 7/21/26 02:45, hu.shengming@zte.com.cn wrote:
>>>> From: Shengming Hu <hu.shengming@zte.com.cn>
>>>>
>>>> kmem_cache_return_sheaf() may refill a partially consumed sheaf befo=
re
>>>> placing it in the barn. Without an explicit restriction, this refill=
 may
>>>> draw objects from pfmemalloc slabs and consume emergency reserves.
>>>>
>>>> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from=

>>>> non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,=

>>>> because this refill is a best-effort attempt and failure is acceptab=
le..
>>>> If the refill fails, flush and free the sheaf instead.
>>>>
>>>> Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocati=
ons")
>>>
>>> Wonder if 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with
>>> sheaves") is a better match. Until that commit we just didn't care, a=
nd it
>>> seems like this is a case that commit missed?
>=20
> Agreed, 1ce20c28eafd is a better match. Thanks for catching this.

Agreed, thanks!

--=20
Cheers,
Harry / Hyeonggon


--------------sknT1z40q0AKvdHcsxeuBT70--

--------------3tg7DmIrLoZVRKTFmyx5wMJE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal+TUwAKCRCGXBN6rc5S
1pTOAQCaYmEPjb3oa7nqKKas83R+C6PdrboJ4y0zaJuND5YOVwEAmvNtaHdwKxXE
oGimas2EKd6CfXp885aX53GRy6KGYwY=
=TL4q
-----END PGP SIGNATURE-----

--------------3tg7DmIrLoZVRKTFmyx5wMJE--


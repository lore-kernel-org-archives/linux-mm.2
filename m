Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE1BFC44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F6E6B008C; Wed, 15 Jul 2026 22:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CFC46B0092; Wed, 15 Jul 2026 22:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1BC6B0093; Wed, 15 Jul 2026 22:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5C56B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:10:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7EA41A03A4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:10:24 +0000 (UTC)
X-FDA: 84993010368.09.FD6B297
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A1CF80009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:10:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZ+ft7uO;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784167823;
	b=hvFOiqGfyiEh/eW5cOuxWtQyc7IXmv+McYLUj10uXhqZfgapXG0Q+lurLImnuB6Wkt9yYz
	Gi4wTfAcx79NeM8ifWTZVJNL+XeH0X2UL/ycSI4pSKmAJN4mEyDahv5B41YXlCZE7expat
	moaUFptZAQIg8XADDegs+uXLytiMZVM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZ+ft7uO;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784167823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dwgw+pYgZ2OOIDPwWzrI+VmqmUDlicKkSlmRoSyasLc=;
	b=K7SnyibqQfVmUiMLicHR8QyLHr5j+UCswuREmD5b/PHC+4d2WDgfMaq5nMis8AVMUN4MAa
	CV+FN8enr0PCrTeOWEvjUXbifRZv41s02T19M4UofHJnn7IlcFjANS45ybOkACEiz07koU
	vgdlKkSXFzP/QFy3LmQuHIb32nV/gOQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89B4360054;
	Thu, 16 Jul 2026 02:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5333C1F000E9;
	Thu, 16 Jul 2026 02:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784167822;
	bh=Dwgw+pYgZ2OOIDPwWzrI+VmqmUDlicKkSlmRoSyasLc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LZ+ft7uOZkBd27+/82RNKYawDSnuYWQ9iytbjMqNXrOf6yaKiVMajTddbylMdz0x5
	 +xy+ODTU4l9hmBpnLftNf3KQbr9i2dp8gScKNmfZO4jJc3MUyrswzV/G6YyOeQIbdd
	 N6ShiJ6bOUePT2ASg1vCDQvCnce/su7LZLTtYyaD80zkWtQhR+K3NLnXhOJZFtBU/s
	 sUQglse9xTNtDRAQKI2bd+JTC+QxX5/9DfeguyeP8YxtwrHscHwdrgXrdmlkefalw0
	 B/B4tLuCtQnd64Xse+xcRqZ47Hi7Or0VAF1lpH/pu9RHndaxMDY2ObrfJOMUM1rcin
	 SZUdHMCDAVISg==
Message-ID: <072337b6-30b8-41fa-a27d-7beb00e01c24@kernel.org>
Date: Thu, 16 Jul 2026 11:10:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3] net: skb: isolate skb data area allocations
 into a separate bucket
To: Pedro Falcato <pfalcato@suse.de>
Cc: Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@kernel.org>
References: <20260702170728.168755-1-pfalcato@suse.de>
 <04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com>
 <ak4w2k4Woj55E0On@pedro-suse>
 <529e3997-d26f-4d8e-ad90-3329fe90e555@kernel.org>
 <aldpAY6nXwgayHL0@pedro-suse.lan>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <aldpAY6nXwgayHL0@pedro-suse.lan>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------nAdHAmQ4m2vnhCex5aHUduqE"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A1CF80009
X-Stat-Signature: wia7m5tznnybxew9w6atcd5d4hqpof4z
X-HE-Tag: 1784167822-865018
X-HE-Meta: U2FsdGVkX19VzhuyUoIR/VnKmtiqb4Y62NPOqCUTbN1HZg77GzMZJYPrzwWI/nxI+lWwx37bbIOpjFAqB4onlUkwL6JjHRkJh0UeuiLtU7wy/iEWKKlpW47nRllR/i0VZpNn3WVPOhl5ca7PLFtVaj3Y5mX5ntusrGehPCM9D3bLCTGHcxg6Wx8XINTV1Cmk2gKh8Q9yB4LJ1M3zB8rUTdUuokJxoesDUMGVpl8ewPVKINKmP3A4h9nDg4DkcP9PJcSO2kgAP1J+lq5q/USV19lYdrjNoqH2ZV0PoPPA3ghdTHKDgwxskH2IFf6S14mDNodOYiTtVYiH8vyiDowiBC2bxeXaY15g5aSl3j3ltSk+UsvbsQ+sAao026Oz0R+YEKtkc/T9dbavv4L9Cf0IiBPHrsFD22CEQeO8/xpCpqNqZa4UZ2/D2NrVc6bP5vteqLQK78sibTCB5WYb8M9/XB/Pmw/sUBAwo50GWjYV1eo9508gXyzFzsJwpDxLPr4jN599q8TBgpXdHO7F8LmVF5D6WhtKZblAOg7qPysDzZX50nOneon8+Fjd1paivr4pfbt9bTk7t2D8nc0/eAaPufxbj2mTFkfWz4kAoYnYBtuhdqP7xiFNi6bqcrJ3VNlp0wr6XZF224P2IODiGGLtxJ+Yck2JXPEKwku2W119IBti/QMhetZyLVL5CmfSVMsLv9BbwYoksk4oVAq8G5J2XG77VmYSSR2F72VWcGmJcIvR1LARSoONXoM2zsCclfGeddVCEUapzD4z9N1rTbC7AkluOlPiZYAH+wp7eWUl5E3nd2KfXkNAu2ZhTcxL8XFvcUFMrG+ytDavFiv8c5qhdfsnBVJhQS2yhYWzdPxdA6eBCwGAt7CVhZi5+RMx1jkh2t3nTZgwCLp3vK7r6CbsU7g1MDqjyjZV3+jk/Wmsi8pP3W6MlggsHsrBUXbzNlYOdBNIigKqfwSJXl9ocnm
 nGacpb+A
 uAqyblelFj+Wc+yQdyp4FQQNfapSL8vTEd1BpfPVWj5OpFP5m5hnq0LF4T8Acv4ttij51rncTEjcTSJmXyUMCr7JxExYqlv9UWm6qnJtIuAttzS7DYnaFZbjqL5gxy0mdGDn8WkR33rugHuu7pt6yaoqzxIDgpFgeD8fyDMa3Auptv3eO6GT2qs1+zb70SIajEUJZuQ8mRH0iwvMSZ/4bTTVlT18+lH2FS7gV6Nh21WU0GbMp8oDmM7Ij7fprifiEyCrkdcgXmDjJDyN5QbD1CkxRK3ryqJU8QPGBpZ7qVS1yiMRerHltmQwADWG6nY0K4OxQmJp6nI5kKOi3i3ueaWkKsC9iyQP1vhizwK7Hlyxj3DTrHb/rk7hAIDK7C6zHLCzzfWtdydzpSZDF3kcz3DzOGaRxm5uQ1pYtIX2Wr61wJa+JeW0qm7/bYo1s+IUsqEEliHRLuXCsc1RFBwgTJd/ZMokfebVHPFrF/WxJ6g2NVCppTnmwsJLqE2GqZq4WZC0g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------nAdHAmQ4m2vnhCex5aHUduqE
Content-Type: multipart/mixed; boundary="------------vIh7QuKEpqskM0EoX5rWRCbB";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@kernel.org>
Message-ID: <072337b6-30b8-41fa-a27d-7beb00e01c24@kernel.org>
Subject: Re: [PATCH net-next v3] net: skb: isolate skb data area allocations
 into a separate bucket
References: <20260702170728.168755-1-pfalcato@suse.de>
 <04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com>
 <ak4w2k4Woj55E0On@pedro-suse>
 <529e3997-d26f-4d8e-ad90-3329fe90e555@kernel.org>
 <aldpAY6nXwgayHL0@pedro-suse.lan>
In-Reply-To: <aldpAY6nXwgayHL0@pedro-suse.lan>

--------------vIh7QuKEpqskM0EoX5rWRCbB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/15/26 8:07 PM, Pedro Falcato wrote:
> On Wed, Jul 08, 2026 at 10:27:54PM +0900, Harry Yoo wrote:
>> On 7/8/26 8:16 PM, Pedro Falcato wrote:
>>> On Wed, Jul 08, 2026 at 10:30:50AM +0200, Paolo Abeni wrote:
>>>> On 7/2/26 7:07 PM, Pedro Falcato wrote:> @@ -586,6 +586,8 @@ struct
>>>> sk_buff *napi_build_skb(void *data, unsigned int frag_size)
>>>>>  }
>>>>>  EXPORT_SYMBOL(napi_build_skb);
>>>>> =20
>>>>> +static kmem_buckets *skb_data_buckets __ro_after_init;
>>>>> +
>>>>>  static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int =
node)
>>>>>  {
>>>>>  	if (!gfp_pfmemalloc_allowed(flags))
>>>>> @@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size=
, gfp_t flags, int node)
>>>>>  	if (!obj_size)
>>>>>  		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
>>>>>  					     flags, node);
>>>>> -	return kmalloc_node_track_caller(obj_size, flags, node);
>>>>> +	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj=
_size,
>>>>> +						    flags, node);
>>>>
>>>> Sashiko noted that some drivers may require GFP_DMA buckets, and the=

>>>> above may break them:
>>>>
>>>> https://sashiko.dev/#/patchset/20260702170728.168755-1-pfalcato%40su=
se.de
>>>
>>> Oh, this is really awkward. Adding linux-mm and slab maintainers for =
input here.
>>>
>>> Considering the current slab bucketing does not seem to duplicate DMA=
 or
>>> CGROUP caches, could it make sense to duplicate those as well?
>>
>> Could we specify what kmalloc types the user needs when creating
>> kmem_buckets and duplicate caches for the requested kmalloc types only=
?
>=20
> Perhaps. But do the users themselves know? alloc_skb() allows users to =
specify
> random __GFP flags. We're bound to see some random caller do
> alloc_skb(__GFP_ACCOUNT) ;)

Other users don't expose the buckets to drivers, so I thought only
alloc_skb() would create the buckets for each kmalloc type.

> In all honesty, I'm not quite sure what the best way forward here is. T=
he most
> transparent way is to bucket those other kmalloc types as well, but tha=
t might
> very trivially result in a lot more caches (and possibly memory usage) =
for no
> great reason. So perhaps specifying caches might do.

Another direction could be merging those buckets.

If we want to protect kmalloc objects from user-controllable
allocations, can we create buckets for each kmalloc type during the boot
process and let the kmem_buckets users share them?

That doesn't sound like creating too many kmalloc caches, while
providing a decent separation. We already have two buckets users,
one w/ SLAB_ACCOUNT and the other w/o SLAB_ACCOUNT.

If you really want each bucket to have a separate set of caches, you
have to sacrifice some memory for security :)

--=20
Cheers,
Harry / Hyeonggon

--------------vIh7QuKEpqskM0EoX5rWRCbB--

--------------nAdHAmQ4m2vnhCex5aHUduqE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalg9hwAKCRCGXBN6rc5S
1qiTAQDBTgHUQNlbhhV0KovqNCHl2aAaCrah376xCdTsuaTvSAD8Cg9gheKulpHN
2nrpaiNOraIrtk8ZpVzV4Gwnh3mEJQI=
=PjPB
-----END PGP SIGNATURE-----

--------------nAdHAmQ4m2vnhCex5aHUduqE--


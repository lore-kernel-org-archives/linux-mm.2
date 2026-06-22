Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7717CCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 12:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BE16B0088; Mon, 22 Jun 2026 08:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5626B008A; Mon, 22 Jun 2026 08:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CC76B008C; Mon, 22 Jun 2026 08:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06A666B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:42:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76370A015F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:42:35 +0000 (UTC)
X-FDA: 84907512270.19.D41F7B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C53F41C000E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:42:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KiUQC1bI;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782132153;
	b=qqqHEGXoCR3xqVuWDrx1RU49ou2nC5ENvHHhdOc0fSwberB6SToCLrSu1no7ERXq/VOB1J
	h3yN4mBaEGxv/gvqWxDEy1mKVEWejzoZPIZHgOqU0XTDlgKZyLNiYi/FAYBfNtl/SbbnB8
	LwKQJbkj3h53TNXVM6y8vGmp/p9WK2E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KiUQC1bI;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782132153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBB9HIOJyh0+Q0tdVfj5BPTOtaz69ZBxp/hs1U8uyTg=;
	b=aPmYF4t+PN+DJjYprri4KGf4CZAtshMJlPNDvym4+yCREM6zedhLKfLariRutoVc94qP/z
	UrIt65wjAxhZ19K4MitCVlL+y9HznxX+xiTsIIvtyD3Yt01MdsbBPBvdv8ESckLnNeCjyA
	6T85kHNO/cbc7K/UUYwRU2vyBlRsUU0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A4C96008A;
	Mon, 22 Jun 2026 12:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA621F00A3A;
	Mon, 22 Jun 2026 12:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782132153;
	bh=sBB9HIOJyh0+Q0tdVfj5BPTOtaz69ZBxp/hs1U8uyTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KiUQC1bI/NhfyctJLPMotIQzxW83XndStg/PtDhr/qg5jbTQLrqw2JqVnJBpjLAYh
	 Eela41QyhwlZebJRBHeTf1rc0/F76YSzr2jWcDtiK2vpuUZqJyOh9d1kh1cuN6xBR+
	 dc/6MlJL9RYmhezFY20KznZRo/RqADe2wR+wxCdoqA3w76THZZXJBlYHRBj5eNwEL8
	 rjyLcShGMbmu3AjyHYavIQA2rk7oFcwlbwrahiS6dDeSr5/eT2VqC4vrbcOqinm5FE
	 +Yu2Llh8Tm6gfVg/3xoRPl4lWkTKrzlUKYw3REicBtT/iT5QaiRNXHqePtqljF92q3
	 NsFFXorFVrqvw==
Message-ID: <2208123f-8a51-483b-aa93-c35d8d053d25@kernel.org>
Date: Mon, 22 Jun 2026 21:42:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net, glider@google.com,
 andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org> <ajVByfkLbetzA8bB@arm.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ajVByfkLbetzA8bB@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------PC6AVe6DTCIpK9DJB7Cd0h9E"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C53F41C000E
X-Stat-Signature: 715f5qqdo35szt4kiyfd3zf5o1ebxnrr
X-Rspam-User: 
X-HE-Tag: 1782132153-62904
X-HE-Meta: U2FsdGVkX1+VGExedxp9TSzuMnF6RHsdw1M2dOeB4YrYl6Wbs4x0axbi46C2MqdPSeZzJwRPNCfmDokz16FswgFU+24IkSqlWBBw5nbD99WCldn14uFprLyL0IMzxlIwOYyEX0ELWYgNrhqHhni6gfIRI3dT4UsXzXXrn4ZlguQVF8fmdJbpA1Xvkd7qUEMhhFmp1Kmynam95J1gT8DxzNMzl6RMT/5C32Q8v7KjFcN/Hk7xUIl9cPFzt34ldxCXiuf44mrc8PaG0fteW1LmcE7cpVTJpiLPIzCC5Curr06IY7BpBHY+R1oZdMOY7ki6EK4pN0nJTwcalGs1KnkYgGXSHDU6OK/BvRKw+9XSt75QODABf6WBRVd7RNZrIheC7xz/8XYrBKmrh45hWmO0F/MLcyjFG/caRCiIFxEiSPkzV0BzohO7AQzpJFNQDVd4lypJQznZhu/9fYURf7jcfd34/c3XHrC7gGCCgdn3ku85pxJIAKN7l620DMvG7hBWxRH0QsKvyknXwCVNEk7wedD8ESgHpA0S9hEStE39mNQqZ2r2YnE0Nc0dKEAA2WVkgFP5V7Zvp/q1pWi6O1i1gIQT9M7aGV7AU6r6A0ITyZh8n6JoUaeJ/3+rX+E2nGQwDDhWjB8hgklkXn+UeHvloAdLO/EdFvFiva0UCn27FtAo9UCSiHUFp8Tz4eN0XZyjvyn0LFnwDAi+XnDIcfJq+7+EhWdyjgBu5vNuKwNxzY8nas5cYNaqBSPR8/SeHH0FG/Bdb28oWncIPkJG8Qo8NhWpT9ivqWHoVsiq8I7RnxwpJ/Ct3hRVR0q9y6+7FUA0cJTv7So/u2x6pPpk9W7+GUaYqmbVmlj15QgZAP8UorcPLTxjujpVGqdDpfv/yzi0fdiCxVgauK86wAtoHVorC6fkcf878tlgden8ZQuu+s3HhzM6DTA5NWDv5aMm1FYxfxW7ztVGm+HCFI6af3j
 SQrwNY8s
 RSpjaZEMEIHQDoY8Gup12VB4Pqcy2MrwIDt86YLXbF6SNbpeX3DKsfT8AuZy3webxxhOMCTiXjmAuuLfMAM/5IFORqcu1V8r+NptUS54nWc7Lt3KTlNBmkO63z58Ifc7Uulwe8rD1XqrZQqbn1eNZBZlm4C+ygp0k7r1eSH8jTdqLBjuM4q5L9G1astPEIiLVVrkSZMJM1XYUMEN2imT5eqY/Ugi4pl72BOg5WAqrqlxRw3K9kyRqbBH2iMqeMcBBmEHu/GaqBsQ5E447CbKJECqCgtoZTY1TEKmbPA82CMfpT3ZmshQfAycLJJrISo+jJs4UboI+ee1BzjICdISbg1+M2UhdbNeaGoMPtlKIG986E1qYtQZzU0ekFuww6OrzQcrls/If1Jbbm5Z+YwLXjw5h9LtjXtueLY+C/NGMOLO0+ylKP5H0JKe8qZBwhfWbd3BULw5Po+6Z7W2cTScEX+UPC24bu8ksxNOosVGfo0BevX9PCrLjLSVW6P6SXvqN/kV3yW+bLvaZmrMFao4NO7UoSNRm5jK2xTWS7EK9Otf+ve4yT5pC1qF/DXK+dPsivN+ZChDCbiFx3e0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------PC6AVe6DTCIpK9DJB7Cd0h9E
Content-Type: multipart/mixed; boundary="------------DucNVyWowjWn2Qipbe0sleBO";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net, glider@google.com,
 andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org
Message-ID: <2208123f-8a51-483b-aa93-c35d8d053d25@kernel.org>
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org> <ajVByfkLbetzA8bB@arm.com>
In-Reply-To: <ajVByfkLbetzA8bB@arm.com>

--------------DucNVyWowjWn2Qipbe0sleBO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

On 6/19/26 10:19 PM, Catalin Marinas wrote:
> On Thu, Jun 18, 2026 at 10:35:15PM +0900, Harry Yoo wrote:
>> On 6/12/26 1:44 PM, Dev Jain wrote:
>>> Introduce a boot option to tag only at allocation time of the objects=
=2E This
>>> reduces KASAN MTE overhead, the tradeoff being reduced ability of
>>> catching bugs.
>>
>> I think most of overhead when enabling MTE comes from loading and
>> validing tags for every memory access (either in SYNC or ASYNC mode),
>> rather than from storing tags.
>=20
> I guess it depends on the workload. Lots of allocations for short-lived=

> buffers (e.g. network traffic) may notice the additional tagging more
> than the actual tag checking.

Agreed. Likely depends on lifetime and size of objects.

> Of course, it would be nice to get some numbers from those who have
> access to MTE capable hardware.

Agreed! (I don't have one, unfortunately. It's pretty new hardware
feature)

>>> Now, when a memory object will be freed, it will retain the random ta=
g it
>>> had at allocation time. This compromises on catching UAF bugs, till t=
he
>>> time the object is not reallocated, at which point it will have a new=

>>> random tag.
>>>
>>> Hence, not catching "use-after-free-before-reallocation" and not catc=
hing
>>> "double-free" will be the compromise for reduced KASAN overhead.
>>
>> I doubt users who care about security enough to enable HW_TAGS KASAN
>> are willing to compromise on security just to save a few instructions
>> to store tags in the free path.
>>
>> To me, it looks like too much of a compromise on security for little
>> performance gain.
>=20
> I don't think there's much compromise on security for use-after-free.

I think it depends... OH, WAIT! I see what you mean.

You mean use-after-free before reallocation does not lead to much
compromise on security because objects are initialized after allocation?

You're probably right.

Hmm, but stores to e.g.) free pointer, fields initialized by
constructor or accessed by SLAB_TYPESAFE_BY_RCU semantics after free
will be undiscovered if they happen before reallocation.

Not sure what are security implications of that,
but sounds worth discussing.

> The buffer will be re-tagged later so use-after-realloc should be
> caught, especially if we ensure that a different tag will be used (I
> don't think Dev's patches do this).

Agreed that it'll be nice to ensure that.

--=20
Cheers,
Harry / Hyeonggon

--------------DucNVyWowjWn2Qipbe0sleBO--

--------------PC6AVe6DTCIpK9DJB7Cd0h9E
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajktogAKCRCGXBN6rc5S
1mwdAQCV/v9TESQBXaNvWWnvoxqvNG1qbVtP+p+94ya719IJXQD/fT2zvm7NaU5r
ozgxj903g6vHgfHpqx9u07IM7QQCrwQ=
=GrWq
-----END PGP SIGNATURE-----

--------------PC6AVe6DTCIpK9DJB7Cd0h9E--


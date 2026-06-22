Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B2CACDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 12:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72D16B0088; Mon, 22 Jun 2026 08:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49806B008A; Mon, 22 Jun 2026 08:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D387C6B008C; Mon, 22 Jun 2026 08:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADD266B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:56:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EA7CA0165
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:56:38 +0000 (UTC)
X-FDA: 84907547676.04.22464CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9942618000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:56:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhTXUQv3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782132996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2iDIuaF1VKCPijPKmXFMyUN8rIqLYAfStTAg8/YV8I=;
	b=oyNwt/i/Ytq/YXxmsc5GHYizizbV8swJCS9SvlLTjYZXFEpQMQsQ/cwYKTBKNEsrXNW2PH
	XNDd14QY8s5Ti61IBjMsRmItdB1QbpE1+rsibEEXM8MpvpBbejU5j2ZYZsyG4zTzfzxkR3
	69M6MjJ78ecFtqqQV6TEo1JUBX0RLkU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhTXUQv3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782132996;
	b=ynldeyhSGFmdVe1rsXeMXkLvbh7kmKqwet9arBU416Pmt9djJZTPhEK/v31xQ1ZiUO9BWw
	qQT9ib0UWdB8Mn9dfNIL+DHfP9E6tgUgE3qpLWFSgRqKU4VtcxgtmFKvlQ/Vy85BnyoT33
	qmVrdx887LpLMk+mZca5do5C7+QPD+w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35A69601F0;
	Mon, 22 Jun 2026 12:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C321F000E9;
	Mon, 22 Jun 2026 12:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782132995;
	bh=l2iDIuaF1VKCPijPKmXFMyUN8rIqLYAfStTAg8/YV8I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dhTXUQv3s+G3948VNEUzwG8LXH8B99YNS4TcI8bDdEjy3NoNMQW8qC1bUUBSBq0Gl
	 9CS1dv+dU1cEQKaafkSSnUFEbNMHMoE6bXWDLVN7hboEaUaa0dWkHmM3ceKJRehheI
	 62XYgsevyO2fp8MahzfXuYboKooKO40EB5EXQNxnRy3bIhPev9AIkS9Bp6dEnSFUlM
	 AjZ2wghBrD6limeBOmkB7AGjF4ZSY0kPfNw6svzcq0JIoX8gZWxztnmnWbaGHMOIDY
	 oHJqQ4QcmtGnNGHxzYYAGiy5TkFXhUSIZiiK6+1TAFqEmqIuNPWL3IkLCH3FgkliFd
	 sxlx9gq6SF69w==
Message-ID: <4ab3bf02-70b9-4748-a12e-2bd564fec53d@kernel.org>
Date: Mon, 22 Jun 2026 21:56:24 +0900
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
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
 <2a7d21fa-28c1-446c-97f5-2513f29157d3@kernel.org> <ajU-b32dmwS7XOg4@arm.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ajU-b32dmwS7XOg4@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------upsrUBOQYnFEnSXIs0AYK6aO"
X-Rspam-User: 
X-Stat-Signature: yu97ibh9mbgm3ac1g38qx49oc84ig4gt
X-Rspamd-Queue-Id: 9942618000C
X-Rspamd-Server: rspam11
X-HE-Tag: 1782132996-265524
X-HE-Meta: U2FsdGVkX1/juHn+0dmmfGTYgq0lN7uAYszkSE9joLHPWHRH7V2C98pcxBE4yE0IFEdJMIPw8szSxuihqxMQWF5vaTApfsVmNiJf1UhCF6sBS5GtFHsSrtJamAGg60dmep4y8lfkXZVM10pkt1CEP6OeGZeCE3obyAqfjNktP6Nn77kEa3Ni7Bpg+9z+BHhgzbHbc0O/M+zesyH3vHMTcwqkduIuhq1k7ad8/j/wZ7pUx0vt1vtGcvg/Rj7FYtkUFSYo2XCfMyEwb/qIjNXHI0YIAW2T64Wce7sHNJ1FGZFIedK8VPavztC2l/BjAGgQ0lWBL0uj1QkEZNpS4PcL0EHyk8kJy1/E4bqaeWkyXqvdvUlY2VzW8Rr9anFLckqQUs5Nh6ITiBYG8x6WZhiTcOGK92WVjP6loFtqHfO89jWeaDlapzcUzF4qqcwBsLJD5B49idXk+TO/bwIVbfKJjIHLRh7YBPZXyWQN3mE8IjXN7inf1PgFXzBpGGFdz+tYDoNF8bUJNh9rucUU42m92mhn8fb6A5Jv7wpXndThUYMXAL0hrTvOIwTEN3e5yc53acwPRk6Tl3swxdwdwxZMWCDXK+TBhL6MDthXTISi3EiRcquGilnogsPbKWifKQ/roeUl+OnzragRAqHwS9nuzFfUvx+Fe+6y3g0/7xBZA+PCpLuqQO/cznkKrnFXGJKLAX8uxmK66IwqrLmKuAV4cy+cigcHa7asZaE4lavqNryBAmX7JrhpdbM8+IfRl8am6yFbFfLgIccXR+JJM1f1/EoT+NsZguIsjdEckMZ+lZHAXKAu6DXTC2b/wopl14jyUCvwnQXhEXxfQp6LGiyUbn0E7sWl3dzj1zycoplET7dQt4zpjAvDAWkbFestB3SwwBJr/WSZicIRnb/4/4RiWeQR/EEKimCBS6KzpLEh33rImRnm/yOOWrignFyItEi7pVSmWLGlgrreotLMU6G
 DVE7Lql3
 HEJrTF0Tbb1DI//6BgR3wUt0//AIo7x+6gu9KS3074sC6NcvQUSWX4kbS4b91nUzfNXssw54Rm9+j/Pk3C3R/OjooxfnPATsdtbgea84/eGZuXWvryzVA7m3nTLUQjcnW+ktqRzwXtX9kDno8c6510MiRpvh+F5uUgLELxBE1pnFhyMXe5YKem9IBE7Cn214FABJwgpJDsFrHwfaQvFRjycKL+fWQojMOlFee0509zqRoJ6w/Wk2G7zsH3CX6fPe4m/Ru5AJnSsoYLyS0jsOTDt1sP26ZKKLETRRAYz0r2HzZL6KQ4BG17ux1Y9fzz5gzEVAO0BQHTWKCDciyNBQpelYvpHQaI1QqMmAB3xhPf3IIWX2PIm1jzNvtvR3+By2w/019o/lR4GQl5AKHc5jt+L4tC5b6AyitAGtwFZY+ZxdpGX6+M3ucG5M7YoECSLFK2bBGz9mj+RfFZhU4lDziWBoRAWXSjyKegcj8757jlcrPzG7EEvYh+YCHPvMKBclbom/8aAyhfxQje/KWG1jejGjXNOWCXVOyv/kaqErGmWaAwHbg6Kwjf4YXY1PeeJ+2BqYRMpOv5fCOjQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------upsrUBOQYnFEnSXIs0AYK6aO
Content-Type: multipart/mixed; boundary="------------Ps3zmfE9YngvIs8RaS9wbP7c";
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
Message-ID: <4ab3bf02-70b9-4748-a12e-2bd564fec53d@kernel.org>
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
 <2a7d21fa-28c1-446c-97f5-2513f29157d3@kernel.org> <ajU-b32dmwS7XOg4@arm.com>
In-Reply-To: <ajU-b32dmwS7XOg4@arm.com>

--------------Ps3zmfE9YngvIs8RaS9wbP7c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/19/26 10:04 PM, Catalin Marinas wrote:
> On Thu, Jun 18, 2026 at 11:05:43PM +0900, Harry Yoo wrote:
>> On 6/18/26 10:35 PM, Harry Yoo wrote:
>>> On 6/12/26 1:44 PM, Dev Jain wrote:
>>>> Introduce a boot option to tag only at allocation time of the object=
s. This
>>>> reduces KASAN MTE overhead, the tradeoff being reduced ability of
>>>> catching bugs.
>>>
>>> I think most of overhead when enabling MTE comes from loading and
>>> validing tags for every memory access (either in SYNC or ASYNC mode),=

>>> rather than from storing tags.
>>
>> Is there any reason not to use STGM instead of STG + DC GVA when
>> setting/clearing tags for large sizes when we know they are properly
>> aligned?
>=20
> STGM is intended for copying tags when paired with LDGM. Have you seen
> hardware where STGM is faster than STG or DC GVA?

No, I haven't. It was a question I had after learning that there are
multiple ways to store tags ;)

> For properly aligned
> buffers, I'd expect DC GVA to behave at least on par with STGM.

Thanks for answering!

--=20
Cheers,
Harry / Hyeonggon

--------------Ps3zmfE9YngvIs8RaS9wbP7c--

--------------upsrUBOQYnFEnSXIs0AYK6aO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajkw+AAKCRCGXBN6rc5S
1qvyAPsF0DurImeEtMtFke9YXQWImsgXI+xfZ4SEz1mY+wbGswEA158qtw/Yf70R
7SKOnegedFGVqJzsq5p+vAkSpPMfJQw=
=RsAK
-----END PGP SIGNATURE-----

--------------upsrUBOQYnFEnSXIs0AYK6aO--


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C99DC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8823B6B007B; Tue, 21 Jul 2026 10:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80AF16B0095; Tue, 21 Jul 2026 10:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD2A6B00C2; Tue, 21 Jul 2026 10:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C23F6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:27:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9F22120190
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:27:52 +0000 (UTC)
X-FDA: 85013012784.12.92F865E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0BA6FA0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:27:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fJzDy6Ig;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784644071;
	b=g1FvNHBj70A4Sr6y3ae1K8hrfHw+Qs6J4lSvlMBcmRSx5SmAGn9JSGaN++7FZTgOZyymvC
	unyhYvLT4r3E1bmvqaobZjQvyfQDUnNTP1GFTRWrN3ecuIgpOYmCsuZq8ZL80BRHlH2gKX
	Trd8etxmtQ3IrqdH8HR5IN9063oa5VQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fJzDy6Ig;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784644071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hbBadusRREWVUqTtdhXuQ+80Xw3Ko8XAXx4ac8NSeM=;
	b=zBwbF9ITlqmRhdDMRHlAj8URHJEt97TRPiyI3Yc6QgdNXvckhH/1aIjjVhPZp4rsP+yVyF
	GUqlM8HJ6W5fIXUeHzm8CbyXlmTQWfU4WgQHklpZXUOT/8gLHLPSX0JMxJSmQYYTY35Ywc
	Ns26135WPblM7jSe6sNMAWC9W6hrl14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F91040AA5;
	Tue, 21 Jul 2026 14:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73BE1F000E9;
	Tue, 21 Jul 2026 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784644070;
	bh=/hbBadusRREWVUqTtdhXuQ+80Xw3Ko8XAXx4ac8NSeM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fJzDy6IgiEZtb7HFq1XLK0UmH47YMcm7bZ9lqLlVBZuDHTWD2xm+6k1HR9qjc7REv
	 w+dJnrMqxyxXemFx74Y1FkXKEeGb9jjP2npUg1Hyh3cXr217iizQcEGP9wfEs5B5LP
	 JoX+JtAB0/dnOvq93/lws2jxLYWOAalFUo7fSXAllM7l8DHbrYHWtGFNpyVC9ZL52u
	 OMxPw+xY1x8iYA8lWhCDyb0YQH7oSonpA4MGFhh/xA9cu92tguJz3r5rPEarLnwsq9
	 gi7XPi8wMIEIn10Zx8jb6WBk+3eAeNda0sOJ56BsqZJHS8c/rcrsAjHR7UGoHIpnNN
	 OhRiMhevVqy6A==
Message-ID: <85ddd27a-ade6-4f27-80ab-cb91caa4e171@kernel.org>
Date: Tue, 21 Jul 2026 23:27:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
To: hu.shengming@zte.com.cn, vbabka@kernel.org
Cc: akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260721171753509I9L8xNy2kiOGQFKloTnrG@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260721171753509I9L8xNy2kiOGQFKloTnrG@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------6NUTL4gdv4n2o3m1W8I1bwuM"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0BA6FA0009
X-Stat-Signature: dmn1skqebsnp6asbs8jx4ipnt7yzfzf3
X-Rspam-User: 
X-HE-Tag: 1784644070-459062
X-HE-Meta: U2FsdGVkX18hNQD/dVeVjlSo9ywwJUss0W/2zxQgq8gQO5ziBh6PJauBviad2nxk3a+lge6sy9p2uYU8dqU0lGTZCW9TZgzUmNZGZBBUeB0ohxyZjsHVm+sEC9CFDGDFka+yqNx5sYH3zlFQerjZCZ6TNdTT05m/P7WvispCfv3IsxJTpI/1YvDMZU+IqS+fNFQzstG1if7RBPtQbLbLctfNamq9Bs6ym0APROU0P/eY4ZSR0uK2pOkVm/I0cYjqd+FyHX9rpRt3bkyAmyMCxgqpwE3b7t9LWbkrzwbJ91G3K3nwoxwaBI4J08FS0KwBCEtQZzwkpk1NyhuosfgpPmthDi6dDfXoPTD3lzBoaz4aR3XnuNvLYjoCkNiIEEIF0u8DRPnbkAaB7krfMJC9ljLwHedVNzEgcjxziOWaFycQItwJs7h9Tj3F3pfzZrfE9Tnp9ddZ4kpU8pNtfBPOrFMHUh6bnUmP2uCdmBZZwcjoHI7BdK8qt07Nfa9kTIO2E96/hW6XtOmyUwyMQPwXOwXmrhedlAtiQpcfV35B+KaGJQ3onHdFpMiICYczgKZYI4sZa+HLUAdeTNceoFcyTZICrlwPeusw98Y5HtymhKZ6dngFhG0nl5UnhBVM3CLB/rfZXtFGRDmtT7c8Tr2YuaRcaRIxLrIun9wKXWhZWMGLnX99BCBGB4iaFttW/ZKmm2cP3Hff0wvizJM93epgRcLEahMH6/HagetgQfbbUo/jAKJcuDm9IscErBoISxBzAo/EoBLhbLRHAKSyU5SgDkphTCsaAljw/g6BS5+/aSkIJaGdpHaEsShnyTBOh6/UhBjT4LM0xv+hJoKgSkLBjK+bOrvnR3LlD9rC1kglIGFi1Ax4zKiX1MYSNKEOnO/R0eiziiJyOJBbXiTVoGYZE4iaNEzCPJ/UOfQ60ngbqTOZAWiXED+yrTel9BiBlJn6gqDmWJWuNAs8Uv7TRr8
 /g7STiJ/
 W0JAPRnb1lxDCIqYmQ0oeSdcZbG+2NYmVL5brmB6RtCIv/CYhSx1O2ku/9NKbtybATOW52k02jJsmGoPqvP5nAIi46O4+j0qJ6D9rqyxU+IBpdknob48XsHXdc3SlAAg02DdR/wsyb4nUdksDwmHxjw+CAzAGgtjsT/qwqGYzUFkBSde6RWf8TVRb4ibjXCUrApthNJz3kR2Fm4FPI3g4cNPYzqKKX+oxJ8+rA9xt3UBtkF4AnbCq67/r/tKIDiesEKWybqXED7KswK3e6K/FhofTODrS7fHk9lBq8IrOhqO5rllyGYZUWr1jouSo0y5NITLz8bCHoFxiJrBenx8rp1XUnXVjBAN7ctT4GbAAiUnJtLSmABiXl4KnbSOq6BH1ENZD7Lc31McAfPBJ+mONtHZ/A7r/gHdCQgWshcpfaetLh6ClRzCdIq3TZOa+SaR2SSYjl8J5R7bpGtaSSF2rhPeHtKhNOpVqeAn89dgeaUdS9TgFAeTcbo1fNpWfVAmlA98C24uT4brop0O79XKpyjsC0Rp2wHCYoe21LfPYFpO7/FZctN511nGx4yibaqL+A080SBphK2ZACBzIxTv38FQshA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------6NUTL4gdv4n2o3m1W8I1bwuM
Content-Type: multipart/mixed; boundary="------------jgzpjNmUZ6ZOyMcxhrm0Gj91";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn, vbabka@kernel.org
Cc: akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <85ddd27a-ade6-4f27-80ab-cb91caa4e171@kernel.org>
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
References: <20260721171753509I9L8xNy2kiOGQFKloTnrG@zte.com.cn>
In-Reply-To: <20260721171753509I9L8xNy2kiOGQFKloTnrG@zte.com.cn>

--------------jgzpjNmUZ6ZOyMcxhrm0Gj91
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/21/26 6:17 PM, hu.shengming@zte.com.cn wrote:
> Vlastimil wrote:
>> On 7/21/26 02:45, hu.shengming@zte.com.cn wrote:
>>> From: Shengming Hu <hu.shengming@zte.com.cn>
>>>
>>> kmem_cache_return_sheaf() may refill a partially consumed sheaf befor=
e
>>> placing it in the barn. Without an explicit restriction, this refill =
may
>>> draw objects from pfmemalloc slabs and consume emergency reserves.
>>>
>>> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
>>> non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
>>> because this refill is a best-effort attempt and failure is acceptabl=
e.
>>> If the refill fails, flush and free the sheaf instead.
>>>
>>> Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocatio=
ns")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
>>
>> Ah so per sashiko [1] we should consider adding also a __GFP_NORETRY t=
o
>> avoid an OOM kill. Seems reasonable that an API for returning memory s=
hould
>> not cause an OOM kill... it's unusual enough that it takes gfp flags

Ideally the caller should not specify gfp flags that could invoke
OOMs.... but even GFP_KERNEL for non-costly order could invoke them.

> but I
> thought defaulting to GFP_NOWAIT would be an unnecessary limitation.

I think it's reasonable to drop gfp parameter and default to GFP_NOWAIT
rather than relying on the callers to avoid OOMs or implicitly
overriding the behavior.

It wouldn't be too limiting given that it's for returning memory (!) and
other free APIs don't take GFP flags and assume GFP_NOWAIT e.g.) when
allocating a new sheaf.

> I can add __GFP_NORETRY locally if others agree.
>
>> [1]
>> https://sashiko.dev/#/patchset/20260721084522552ZPa16p1SRj3PYat3sqxuN%=
40zte.com.cn
>=20
> Agreed, adding __GFP_NORETRY seems reasonable, since this best-effort
> refill should not trigger the OOM killer.
>=20
> However, I wonder whether the same scope consideration that Harry raise=
d
> for __GFP_NOFAIL also applies here, and whether __GFP_NORETRY should be=

> discussed separately rather than folded into this pfmemalloc fix.

Agreed that this is an independent issue.

> The earlier discussion is here:
>=20
> [2]
> https://lore.kernel.org/linux-mm/33a1cb67-8d23-4b51-b4d8-9e95e8de00c7@k=
ernel.org/
>=20
> --
> With Best Regards,
> Shengming

--=20
Cheers,
Harry / Hyeonggon


--------------jgzpjNmUZ6ZOyMcxhrm0Gj91--

--------------6NUTL4gdv4n2o3m1W8I1bwuM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal+B2wAKCRCGXBN6rc5S
1kN6AP45uf+4RVMMyJ3mYREKVcE6UcDqjuDX/Ms9a7X7JjYBJgEA62nxQ3AvVp4J
kyckf9WSiNv7BKqpy488q5sKTSbPQAg=
=lhZl
-----END PGP SIGNATURE-----

--------------6NUTL4gdv4n2o3m1W8I1bwuM--


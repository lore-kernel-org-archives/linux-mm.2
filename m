Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D25CD8CBF
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111716B0092; Tue,  9 Jun 2026 09:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9AA6B0093; Tue,  9 Jun 2026 09:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026196B0095; Tue,  9 Jun 2026 09:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E72FB6B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:54:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9ABE01C23E7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:54:43 +0000 (UTC)
X-FDA: 84860519646.01.CFC49F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AEA504000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:54:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crpKqVn1;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781013281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgkuRymXgQquqyekcZ0fsD/A7mXWgkkGEwrlai+T3Ys=;
	b=SuKcY6CkVSIDx7Pif2jucBUbhfZ5bQR2Neh/kfX7S5QpLzcm+thJXB8X39pBZClNFmms7v
	+wonl/saoSCTa4loasB0skzkGqKabYY5Q8ayBXWaSy7tmWlQ0lIociH59zRORtROXIogch
	bFedzUYUnVvhpB0ThwVYS+QGDnkm8Jk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781013281;
	b=C3QYKP+eLYzLHSnfrxmKN5u1xbCgwifIIP1AvkUR4zGnpwYQHHi3N2iD8ZgUU7q6eKx3vE
	U9dE0aaJQ2HhQ8OVAo1dbNr8Tx2cwAkQYh+P6jKJ5Dn7azVYjQVX9JJmZiAcoszFfZpYo2
	7FIlLzRKkYzF5x69edZLtU0PoPVqoiE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=crpKqVn1;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0A0F43E9D;
	Tue,  9 Jun 2026 13:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612CE1F00893;
	Tue,  9 Jun 2026 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781013280;
	bh=mgkuRymXgQquqyekcZ0fsD/A7mXWgkkGEwrlai+T3Ys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=crpKqVn1JWgYYIiLt8y4v0XMABNcx+oc+u28Cu7f6kEwae/cC9sENy69hKtuy4bqV
	 2afTNlO7RRMw7rUrE2AMYUVuETWhPzE5mfW1LQjUvgNgLwSWpQS97R5PwvN0jf/2+p
	 PQZQBt/2Z0xeyM5lv2+q2Xk/ACPBgincxLhUiZENZiIGceQddsRc0nZueEsWwKs0P9
	 qRSqWvMCbstOXC7RD3SmmF+p4nrjlGeaFGcP+UlOuRI8ihLvAALCKr8u+hvXDG6MVV
	 0OZyjvlXmf9NNTbobcyEMw/t8S5Tzeg/rON3AylWffcoMExEfA5pDFozSjEikCZbwF
	 19eWSe3M3l14g==
Message-ID: <78ce28fd-62eb-4197-b167-73be7bd86217@kernel.org>
Date: Tue, 9 Jun 2026 22:54:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/8] mm/slab: enable runtime sheaves tuning
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
 <agr8Nzr8rnDBTuVX@pedro-suse>
 <682945f5-2d00-4bc8-8e23-59189b4472c6@kernel.org>
 <e8f0e69f-c846-423c-9ee7-cbc62675697f@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <e8f0e69f-c846-423c-9ee7-cbc62675697f@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------2XWiTgcVnut66LZ1X3d9Xaqq"
X-Rspamd-Queue-Id: AEA504000B
X-Rspam-User: 
X-Stat-Signature: fxihjrsz96s8ncqqyifkd9qzfxxyiizw
X-Rspamd-Server: rspam08
X-HE-Tag: 1781013281-655503
X-HE-Meta: U2FsdGVkX18EVTIF1K5oe7WQsg2eWu1V4XoOWotBjbNMe5lZk+WLgqEzuf2XsT6vkItxAYjavjGsIh8EdI/CBanaGqHNbesVIXfySU00yqsFEoHwRFmJ6FORNxHLwnIKMHcRX3C4xAZWytrKHeNc+gL6u+u8W1olCeDHFaWHq9Qz3vOwmp4cwx+zKHH9ub2WHYzHvNdT4ncyHdCQ2BjBAaE39em56p3z7DSTbnKJFSdGdB7kIK3ytZLc159AHAqOmeaGhUqCsZ8/CXXAXbZ+NgN1tvKVRD79hrK6PlO/dSQQ6JKgfwRFOjsk+5DiVW2PIw6nvHaNmw4/ayXAx3/f36Bt1KvevXQZbYg7oPHDSu9Ea8UQudLRUu6UUZHF1DOqAOv8Orkk80dfTIQwazsudpsVrdL5r57IZid7j2vu2YbyCqI+Y2SNpzqYRp+A+vydso8LoRtnx/nfoO/6Ipu6CQrTqkVdP4/l1i2bBKkkvl8XVAz9za4t+MqSdOit7zVpOKdeMoNUWD+M5ymTBpEjjLFir7PctIrhuyX4q6ZaUy0IyQBMHKLPxAYiufMNFGMXvyH+uVHRA7W817ONdZWpdQ9Vw3j9UwuXlCUdI7BD0AETZbZa8SnMfodH7UqG/utcr1BmRbxar33lzvoOWJuBRaAwXxx3IccsR8RAPpxyo4/HMyF9GFnh/MRcyZffzbSYd6Cwrtl//8vu4y24X5cN7C+EnSFYLfi7ViAanwja2l1295NLktvu+Lb3jfFEJdxSl55h6Sh26jewvRpHXDFokANPMT5IygSDlplG2T3XkSJ0W1lhkBfNLa5fs0MzyWcqeIg3euj8D7wkZds9Zoa+aiCfGJEyAhxcEdbnTpUTU3eyZs4soBInKwWB0slVSBYW2SBROr2hcl1fgEc/oBPWOKKESBVsRKmWbbQkCPsanayzL3Bt8HYH9ghIkAHvWVBqc0sPom6ejqtZfa3t2OK
 E1KoCTUB
 4j9YtVSNqXRR9kV82azXaJxxlaRvHhXejmiceuH//ldNy3j7nR3bZYR0G5Smyu7ubeHdyQPkO6k3xRTQpqxmZmBKTJJm1MVFq/cl5a3CenwX2JetZVnKXsLvSGiKCzwwTxb7sqXwN1kbX3oZ8PT6QSzoaCnhOhikL7vPYy7gAZEeVVwPOQIRZ1Vrq5f1NkNKFWlU4dCFCLe9al2o+qUR9dMJxLzPawgI6a8ILlhzCjYjDMW3JTHXXtlvOYNb+9nzEsjKu8tROoiAGVidbEVaTz0Gx+0W3jlIb1g1ldXip3r3njp68MgwNhN+Np/jk01BCGDIRiwbTJWxNPPblXx8HHqll9DHjrEMlIbGu/R08oneDyLqpd4TXZ808XwiqMv2XcJZtivNgTgrVqu2HlBPalnMY5+zx6Np+iLEcyp9ixWYHkOSj0jfNKVEXK5+QFxmdciP8KBN9fmVQD8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------2XWiTgcVnut66LZ1X3d9Xaqq
Content-Type: multipart/mixed; boundary="------------TiMeMR5Lo7gpXV0wWewZC1LH";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>
Message-ID: <78ce28fd-62eb-4197-b167-73be7bd86217@kernel.org>
Subject: Re: [PATCH RFC 0/8] mm/slab: enable runtime sheaves tuning
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
 <agr8Nzr8rnDBTuVX@pedro-suse>
 <682945f5-2d00-4bc8-8e23-59189b4472c6@kernel.org>
 <e8f0e69f-c846-423c-9ee7-cbc62675697f@kernel.org>
In-Reply-To: <e8f0e69f-c846-423c-9ee7-cbc62675697f@kernel.org>

--------------TiMeMR5Lo7gpXV0wWewZC1LH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/9/26 9:52 PM, Vlastimil Babka (SUSE) wrote:
> On 5/20/26 06:35, Harry Yoo wrote:
>>
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>
>>>> 1. Allocations and frees can happen concurrently at any point betwee=
n
>>>>     these steps, and we cannot introduce heavyweight synchronization=

>>>>     mechanisms on the fastpath.
>>>>
>>>> 2. Currently, cache_has_sheaves() checks whether a cache has sheaves=
=2E
>>>>     This works now because sheaves cannot be enabled or disabled onc=
e
>>>>     the cache is created.
>>>>
>>>>     The question "Does this cache has sheaves?" should be split into=

>>>>     "Does this cache support sheaves?" and "Does this CPU actually h=
as
>>>>      sheaves enabled right now?".
>>>>
>>>> 3. Once the sheaf capacity update is complete, no sheaf with stale
>>>>     capacity must remain.
>>>
>>> Why? I don't see a huge problem with having multiple sheaves with dif=
ferent
>>> capacities, as long as you adequately, opportunistically kill the she=
aves
>>> if they don't have the desired size (say, once a sheaf is fully empty=
).
>>
>> Haha, you got me.
>>
>> Right, enforcing a single capacity at any given point introduced so mu=
ch=20
>> complexity that I started wondering myself about whether this is reall=
y=20
>> essential.
>>
>> My main concern was that the performance characteristics would become =

>> too unpredictable, but actually, users can avoid that by disabling=20
>> sheaves, shrinking it, and re-enabling it. So that's not an enough=20
>> justification.
>=20
> My concern would have been that we would need to track capacity per she=
af if
> we allowed sheaves with different capacities to coexist.
> But patch 3 here already does that, so it seems it's necessary anyway..=
=2E

It is challenging to avoid that because, let's say, a CPU releases local
lock, goes to sleep to reclaim memory to allocate a sheaf, re-acquire
the lock, and install it. But sheaf capacity might change or sheaves can
be disabled in the meantime.

Probably wrapping the entire alloc/free path with something like
SRCU-fast might help avoid that... but that sounds quite ambitious (to me=
).

--=20
Cheers,
Harry / Hyeonggon


--------------TiMeMR5Lo7gpXV0wWewZC1LH--

--------------2XWiTgcVnut66LZ1X3d9Xaqq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaigbHAAKCRCGXBN6rc5S
1sTJAQCXB3/zmPYt9ZMQc+w1or2ioE4hbAopvJA0ha8uY+bcqwD/c60gL7CZMR58
ReFwFzstlLLXK7lZVyYwZoe/kx8aRgI=
=KobS
-----END PGP SIGNATURE-----

--------------2XWiTgcVnut66LZ1X3d9Xaqq--


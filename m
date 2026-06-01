Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB548CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF596B03D3; Mon,  1 Jun 2026 10:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFD16B03D5; Mon,  1 Jun 2026 10:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F4B6B03D6; Mon,  1 Jun 2026 10:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E98046B03D3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:36:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 964DE406A9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:36:54 +0000 (UTC)
X-FDA: 84831595548.12.97CDCD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D22CA14000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:36:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCK4GrMp;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRKpWRkZ4ryEYnP0BvmhMwCXktSUqM4/n/CosorTgos=;
	b=JRmzQvBhGhf2SdR6EAz3/8f4y/yysaHRhZFh/ZnLjN0KFRcJOhk+1bAMNbNNUpTsoNMd7l
	e0JNjzoNaH9si/A+SurpdfO5KFDELxvMTT6rrQqnAcv9jZJhy6gxXdtk2bHSQBIi6nHEu5
	7Ue1w6ngA3z0xT2vmTm1PlegktkzSEo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCK4GrMp;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324612; a=rsa-sha256;
	cv=none;
	b=EejTEFcLopi2LXeqxe1R+chUiPrRp1TqmJugC9Fd8ieRimYRFo24OWHpO2GEL9ErzL5wwj
	ybgPE/5BfOaU9HYU4Hz/n3r8ZhGw+/l8ppxUUcEsqg2Vku8WvEBEkYxZwi3V1jNgeYxvsv
	cp9fZIE0B4W4vHymZib1eo1E1LbIGgs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1529D43765;
	Mon,  1 Jun 2026 14:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57D21F00893;
	Mon,  1 Jun 2026 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780324612;
	bh=zRKpWRkZ4ryEYnP0BvmhMwCXktSUqM4/n/CosorTgos=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=eCK4GrMpxysTYwY8EZJPpFuHiu6VI7DBD6K8Ki/npJnVOVcQyYNc8CspSCpdBTNwj
	 E4tajNF8aT6REAYDpHRIYfSQwP3xp6Yk02g8sTnsWdevTyV/qYfUnbmKW4MFPbi4P8
	 FGaYSB4UU6JqunyueTw62Uo5hVVSLr35lE+cB2lCBRMzeBQQaqKgOCQOAqdMcKNbY+
	 Tu+5fT2iB4Fa9Md11n7OTlnOK9DKLUuRiY7Aw8JBkscNLQEnjYJQsOi90s0ZqFmXY1
	 rOkV5utFG9Cwi3X0t3yk9ATrXANpSERrXu7/CMYNMOHLG+MEe1751D5DsTzFSPsCWT
	 tCgc2S9wLCspg==
Message-ID: <acc86e41-21d7-4b1b-b5de-fdc02064a959@kernel.org>
Date: Mon, 1 Jun 2026 23:36:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf,slab: Add slub-backed allocator for
 bpf_arena
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, vbabka@suse.cz, harry.yoo@oracle.com, david@kernel.org,
 tj@kernel.org, roman.gushchin@linux.dev, peterz@infradead.org,
 linux-mm@kvack.org, Hao Li <hao.li@linux.dev>
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
 <20260530011345.99342-4-alexei.starovoitov@gmail.com>
 <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>
Content-Language: en-US
In-Reply-To: <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------diUOyBzkGLryZKA9cu0CPqC5"
X-Rspamd-Server: rspam12
X-Stat-Signature: g5rcbnjc73m9ieun3hujfn9rcex9zmts
X-Rspam-User: 
X-Rspamd-Queue-Id: D22CA14000A
X-HE-Tag: 1780324612-393934
X-HE-Meta: U2FsdGVkX18DlZTTh/TKFMtEqnXEVzOHnSKNckJjJu6ZQRpK5U4A8eTAwZudb+4hqb1LB8li57/8FZmRNleB2LF/m0q5x1pctZR8axwZdigNqNdM5ctr7usbg+WE/TR9QmU6nKrue1s5blPC2HRzZoUaAKkIQBv/E/tFTgTURvtjFBRZi5OMW7cnTlusUvNRAyBVC0qy7NcHptY6yu1shb6YHRV82WiNw3Oglt5EFayAv157MKg9PoerT3jXEyaMQwZP1Ds7y21vtdA85l85v1nALUO4hNaBldS62hUILNp4ADCEnKA3Z2Piz96NWBKziF+MtA7eKFctkrB4f+WNNqq+zN+vZpD2mXDCMKqy6NNgez6asqoATx5mboG4hNr+mbkYXzezEmDySms/JRtIAN6dL2WaOkvPRtxDTQO8aa+dTlXdPCTdd4MfrpcsnnWnrxYhFYVkwbkWYaJQuxdMMLX3+DUhXPx41cWxlNi/1YuDwUKjMEJK5EicJ/yYP9F+Cg7tD5ZSqBhDde7RjgqwsGZMrndGpft9J/SFuXBpEMrQFIY9Fk0me/3VqIg9Gu3UFoFnztPkWpzlHfeNefaOLUkQO9ny4FsSsxLcBxH31iycs2J9RroNY2v12Tv+HZYSfg94K7m3zro4y7MmMS1TSLOPv4fSPb/0R4cUifA6H2ng4avV5ZwU4T7qJ5fudPNJ5qLmN12w+TNWkPZ6H/k8BS94+IuCSW7KuxGDOA2bebOWbKAWeMB3GmxpLla7dhfj2iKfYDJfASWx1U2Hgmq3RoDoy4qCXDPBqiRLJBsHJMOgsBo3fgsmXO8FDELzFOatXzQzh6lMdKZJlesXllD8Y1L3JIOpWWB1/FKTuDEfG6IxDgaf7b0fWi+pKHu67Y4OjVrM+KBbnde6dHZ6mJmUSM6Ya4f0zdno79MudALRwXrFgtNw0pq2oZu9YtJNYcj+yHXEp6j3aVY1c6FGRt5
 dEQl+Iaj
 6qpVL8flx7tmdmpieM2ZHFcacTwfccaaoZJp0d8JeHI8V4QGp3IreO4s//etY67sTYEtzKmW/16UZZUbS7rEGBtHpAQj5lkYpmn0/N/bUerIJMwEeYdldilzZ7+qlvONMEEKJ04nGPTvFfZZ4vJLI2SOUkudCBvTN+MLklO8nKouKepQjx+57IqJpcyUGvcrgr7552j0t6mMRNYUUtRc3cv2nb1RQpIP4YZaAHa9whBFgZ7UAD5mtufSGmbBwUxl5Q2Ol2jlSwpKlLt40jemhMORPZUFzNmuynoDPPYmUDmh9G5ZbeNUNaQ4qteDBfpbpjAQofEZV38y62prLbTW1xx+H4e03chOE20ly1t9gEWPJgSTvRXAWBmXV05Uw4dPzWE/yaj5Bck783q+eisZW2jgEYWBf5sEQcOgPNRIUjWxR+YWjFmBhTVg5sGk4cN+MCV/8pqf/IDF+i3W+w5WcEE6uIvIPWIcUUtU1+G3bZV4BtU20bWlTQh6cqgzl2sUoZKm1Zj3FJINEFB5M4Q8QTGz70XtHh9/wH5FWeOLFHP6yLhJOkBZts9Aig3NycVMaGG8u+BfKmFfSQYOWof1amTkqNmDPXdZCUgctGSoJCmechi6UtlT/gDY0EaY04y3EwJnMqwgRmHlFs2VmpvJ0ZOPBZTBZkp4K3iUdhp2swnnENB7ifL39pHFU2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------diUOyBzkGLryZKA9cu0CPqC5
Content-Type: multipart/mixed; boundary="------------a3oHRHPtqA3xITJLmDGgU0kC";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, vbabka@suse.cz, harry.yoo@oracle.com, david@kernel.org,
 tj@kernel.org, roman.gushchin@linux.dev, peterz@infradead.org,
 linux-mm@kvack.org, Hao Li <hao.li@linux.dev>
Message-ID: <acc86e41-21d7-4b1b-b5de-fdc02064a959@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf,slab: Add slub-backed allocator for
 bpf_arena
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
 <20260530011345.99342-4-alexei.starovoitov@gmail.com>
 <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>
In-Reply-To: <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>

--------------a3oHRHPtqA3xITJLmDGgU0kC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/1/26 11:06 PM, Vlastimil Babka (SUSE) wrote:
> On 5/30/26 03:13, Alexei Starovoitov wrote:
>> slub side:
>>
>>   - get_freepointer() clamps the decoded pointer to the same slab
>>     page via (object & ~slab_mask) | (decoded & slab_mask), NULL
>>     preserved. Worst case under BPF corruption: chain aliases within
>>     one arena page.
>
> Can't say I'm happy about this part. We potentially let BPF programs co=
rrupt
> the metadata and hope we catch any issue that would become fatal?

I wonder if it would be better to perform cheap sanity checks to
discover obvious memory corruptions (which would be beneficial for
others too).

It can't still detect very subtle memory corruptions though...

> And IIRC from the LSF/MM discussion it's not just cases where the verif=
ier
> would hypotethically have a bug, as the potentially UAF accesses are no=
t
> validated by the verifier at all, hence the different address space and=

> 32bit arena size trick, right?

That's my understanding too.

> I'm far from sure the masking is enough to contain all the bad things t=
hat
> can happen as a result of a corrupted freelist. Even the hardened versi=
on
> wouldn't help much I think, if a malicious program can both read and wr=
ite,
> it doesn't have to know the secret seed to craft valid freepointers.

I hope "a malicious program" doesn't have CAP_BPF, or am I being too
hopeful?

> The "freelist is outside of the arena" approach we discussed made more =
sense
> to me, even if there's memory overhead. I don't think it has to be 16 b=
ytes
> per object, could be just 8.

--=20
Cheers,
Harry / Hyeonggon


--------------a3oHRHPtqA3xITJLmDGgU0kC--

--------------diUOyBzkGLryZKA9cu0CPqC5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah2Y+gAKCRCGXBN6rc5S
1rTRAPwO738syvKPEULll5+d2OMQJ04suk9k5ggwZJAtm191IgD+In4NjXn/rkxr
Y2mrVQOjT3d7N9BKDBsUydTmYc1hNAU=
=FNwU
-----END PGP SIGNATURE-----

--------------diUOyBzkGLryZKA9cu0CPqC5--


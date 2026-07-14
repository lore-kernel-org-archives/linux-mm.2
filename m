Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6313EC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406EC6B0005; Tue, 14 Jul 2026 07:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DEB16B0088; Tue, 14 Jul 2026 07:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6C76B008A; Tue, 14 Jul 2026 07:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0573E6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:53:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67EC180328
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:53:28 +0000 (UTC)
X-FDA: 84987222096.01.7C9165B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C66B5A0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:53:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUG61eQr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784030006;
	b=dsEPGMva6pbToVcaY+bOhTJIzw9q36fP0Dae9m/j2LlIYi23Bi6NijP44NvknHzgjrwioa
	xpFOpHY/UPC1Q5Zo7O6RQs68STFjtswGD8RHoI0TqJ8y9aWnDdyqnk5Gqh2Yy4NiSKYX93
	/KmQHuB/exqUzGo7wymok/sxVBIGzbQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUG61eQr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784030006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Nf0pzzNTeJOpKeQGGtmDhdnC8W2GgOPVML5TCxAQKQ=;
	b=ZaiaW22jqI3pMJj22Ce+zmadj4yO88K38Dh6R1+zhTCFnfD4BEcru9I2p25whRkRaRuZn5
	QIXP4lpjZGipPsbSJ1nu/BMh9Evr8u7cQDrpzWjO/qWVIHVe7UMeV4HF4b2doM51kbgcZb
	wGg2e5o5RMMajVLWV11YrUZ9FJ8iuG0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5386760254;
	Tue, 14 Jul 2026 11:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4375B1F00A3A;
	Tue, 14 Jul 2026 11:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784030006;
	bh=2Nf0pzzNTeJOpKeQGGtmDhdnC8W2GgOPVML5TCxAQKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HUG61eQr+qwcx4Kq4681RkPJCJLDTNpPf4qw0k95lvgmE6lqKcMDXgaVntE9jLqLd
	 MsT/5cMj0tdbasDEma3t28y9h5wLSoG5fMXfGniSmj682PlBXb6WlE9qq4LWXspiFM
	 CxQ1C+vistKAF2WILYIfoxuA7dm9uuPDFKKxYO4yoXmGqnylYtKXZNXyOsE2F13+w+
	 5JZSD/J0TPhTgIrsO/ZPxX3oaQbEcwwdTS5iZ2Tn2jNmLJMXzXuL3E8+VxVKNcDXZD
	 gZz/o+sDq8I10tXaIv0mNVqnDmokH8GR0hZA+pMbq/PPLtpQYFoBXgVAh5EVc2mLZy
	 bER0gxU5+g+2w==
Message-ID: <67930986-152e-483e-a00d-210fe5769a10@kernel.org>
Date: Tue, 14 Jul 2026 20:53:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, sashiko-bot@kernel.org,
 stable@vger.kernel.org
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
 <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
 <DJXILB94G82L.37YBL62YO9XBK@linux.dev>
 <4c969202-a8ed-41a8-9e9a-281a12f6dde3@kernel.org>
 <DJY7A190TSH2.B1XHHIACRSYW@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <DJY7A190TSH2.B1XHHIACRSYW@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ku0sMi9hUnR02QaV2h2WUqQg"
X-Rspamd-Queue-Id: C66B5A0004
X-Rspam-User: 
X-Stat-Signature: kjgp769t6wr5jffu3jixberx11p6cfc5
X-Rspamd-Server: rspam03
X-HE-Tag: 1784030006-416444
X-HE-Meta: U2FsdGVkX1/R8Cv45uvnXyDRN72dTYdN1rk4n0AfzYFbJJoBf77gRsN+BtJTzy6QmrZ11f6Qt9q9Q1FDjoMRx0c3AtYmOhSJxqdtP9iBhZm42TwmI371akl9LChAz4ViepWvsb246OqGrp0ebBuA60+tsjHlXqEKaesFs6cI9mDm9Bzowdcg3a0JqfJWwRT4wIRh82BnIHrzeG4FfjqoyoPljAYkG8O0W+W9Gt5hZV11y//uXtXB9HPEKx95X6jWaNSglzI6eex/Jm+wE8aRVKyc2Rn8biQ5cJ8PWvkEMkjfFPQjsYiLOhb2mD0u5Dfr1r10rZUXJR4ogXbHjziLEU0ALWTXYiKrhs2yz/+ZnRpL/X4HJKeYLxPKmKezEad8+Jw4u9Sk7RkyLol5XG0NitFTc+SYMxScf6X62UMiNR31iDcE4xy68l+o10VEMsVXiummIlHEUkb5uLxKewLKI5vjm7cVwZxWhKeNlL2lR2HTcwGKuqO/Huk4+30jm4RZV/yYd+UiHXBzKfhe1CzYTn8zhmsjhSwU7ssi8CTvgG+bd6fTJh+H9SjmpbgFWohehgpDZiWSusAGtbUhQvQj6jb9ODdvE51N0p+/Yiqyn/sQ/KYqX7S4sxSJiMftjl8WVyPrXEiEdOT5CoaI2qyZ7I+XTZchgdkhmn590xVRS60I6jeNcfMlwNYbrQ89bN4z/pNglqCO80Pq5FGh2t4vsZhZp+Kqp86I35rplPmWGduxi6qjBwWJmm7l6sCjj0e3ePyBTRGhGu6Nu3Pe1zR5FoxtOI00FjTOZSDy6Xhk83NAsOCu/2pqpvsE0dRXqEjAXEan5srfSgoH66YK7zj79vXgCqNKoI4fR9JHuApzyw/UCCj07F6CnjG/5iGa1KWioJoP9M0+B1sHJsetezzuR8T6r6n3K7pBSFuJKdvIwyMgoSDX+IBzL6lZK79FH3X7gQSSeWhr+hT/f4UZAuz
 Yxya/egO
 ciCFm/fAR08zAaubisbbaNuK5uyh55basWbfAx3QuRK5SQ+1rprCcBqNbXK3rgWb9gGp5iiU3BiwxGJECj2/NoQp9egVLhDL08R+oWV7GzTqiKQ5qjW+g5aQsDkUFSfmMGo1x78p+jxqx1BWFrwDZ84bAEOUWQe4/q51JdpX0qdYBcD9NLkbwDZnBRNEX6Stdq522SQ4nccD4El9nkFVPfqJpGBGB+Oisp2CbjGApxGj6e3iEOTEKqfRwwBG8ZcYsvoWEKYXOC2GzxpkP1S4YOceB3pIr+0DmLoOfi+ZgLDzVPP8b91XQ1EE+ZCHewBQxEZAFb2fQENe/9f8Nai2t7Lok2A0Z5Pkbd93nidTT5f8susQoSBRrbYr9rAqDvAYSzX5FFB1X3gx/VGiTfhiL6okzOcLEFmh8surGf0XweIWtYRSbEx1ZB0DZo32w7cSQktBph5FJyxJD6NF0Xl27IcZ+KjNVzSlv5SfiKD0iYFw7GMDNYWHMMuhgrX04k+GkY4Y6jZNzQ4uso8BUSzeqp8+Bmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ku0sMi9hUnR02QaV2h2WUqQg
Content-Type: multipart/mixed; boundary="------------4kdqt064WgNYuyI40EikPph1";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, sashiko-bot@kernel.org,
 stable@vger.kernel.org
Message-ID: <67930986-152e-483e-a00d-210fe5769a10@kernel.org>
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
 <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
 <DJXILB94G82L.37YBL62YO9XBK@linux.dev>
 <4c969202-a8ed-41a8-9e9a-281a12f6dde3@kernel.org>
 <DJY7A190TSH2.B1XHHIACRSYW@linux.dev>
In-Reply-To: <DJY7A190TSH2.B1XHHIACRSYW@linux.dev>

--------------4kdqt064WgNYuyI40EikPph1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/14/26 6:52 PM, Brendan Jackman wrote:
> On Mon Jul 13, 2026 at 4:15 PM UTC, Harry Yoo wrote:
>> On 7/13/26 11:31 PM, Brendan Jackman wrote:
>>> On Sat Jul 11, 2026 at 12:03 AM UTC, Andrew Morton wrote:
>>>> On Fri, 10 Jul 2026 10:42:20 +0000 Brendan Jackman <jackmanb@google.=
com> wrote:
>>>>> As noted in can_spin_trylock(), using this is unsafe in this contex=
t.
>>>>> commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
>>>>> alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc =
side
>>>>> but missed the free side.
>>
>> Ouch, do we allow alloc_pages() -> free_pages_nolock()?
>> Didn't notice.
>=20
> We don't explicitly disallow that but I'd say it's "forbidden by
> default"...
>=20
> But I think that's unrelated? It doesn't mean you can't use
> free_pages_nolock() from NMI, right? (Would be weird to alloc from
> another context and then free in NMI, but I don't think it's "forbidden=

> by default" in the way that using unmatched APIs is).

If you can't free pages that are not allocated via alloc_pages_nolock(),
and if alloc_pages_nolock() always fails, you can't really use
free_pages_nolock().

But yeah BPF seems to do that and also the comment says:

/*
 * Can be called while holding raw_spin_lock or from IRQ and NMI for any
 * page type (not only those that came from alloc_pages_nolock)
 */

--=20
Cheers,
Harry / Hyeonggon


--------------4kdqt064WgNYuyI40EikPph1--

--------------ku0sMi9hUnR02QaV2h2WUqQg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalYjLAAKCRCGXBN6rc5S
1onsAP9oH3K4pQoIax+qSGFDjZf1pwd025OJ8HYNXHVk+I8vEwEAiu05mhpZJWF4
zStwwbYgpqkkPFWKzpHYUtNrcO/tdwU=
=BfyU
-----END PGP SIGNATURE-----

--------------ku0sMi9hUnR02QaV2h2WUqQg--


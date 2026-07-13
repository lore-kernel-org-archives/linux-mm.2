Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10049C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB326B00B8; Mon, 13 Jul 2026 12:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BD96B0120; Mon, 13 Jul 2026 12:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1929F6B013F; Mon, 13 Jul 2026 12:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E354B6B00B8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:36:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B7651C828C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:36:04 +0000 (UTC)
X-FDA: 84984305448.14.0CAF08F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DC6011A000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:36:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Obx6Tkms;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRPyrtQaOLd9COn8sv5ADcnnOp/BEaTfGAlyXEAZSo8=;
	b=jG81G3I9CGNV4ywcvEyiFLTC8p1z73d1ggy+39y99e5QUvw9kXVa7sqmxg43hkdPz89ynr
	HmDKQY7QdOMZsLlvKdonBmRoarOny62J2/6Qv7KPFHZoe6bODHIx3xFA8RUPgneeItF4Xj
	qVfcqYka7z94p5qbENVBRDbDMz9GzCI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Obx6Tkms;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960562;
	b=stel1HjY/AuR8ZBn0mzvg0k76bgkl7CoJbnJr2UsetOCbIy7mtPCzVwTCp2ZJ7Lf+QdUrU
	20uQgLUvMYH5kn1Qihc8MtrTlcBVbg39jUQck35wocsRznWM02xeKPmgcFwgehcrH4eXkG
	jBLQB38TIRBqIoiYbN94+flw8LGlYVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BF27600AE;
	Mon, 13 Jul 2026 16:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A381F000E9;
	Mon, 13 Jul 2026 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783960562;
	bh=yRPyrtQaOLd9COn8sv5ADcnnOp/BEaTfGAlyXEAZSo8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Obx6TkmsSssAInEyPTzVsGrHYu63MyyyvLI/KLJXOPeN5ILQPiKuh25XCBIfr3IfC
	 knHxBaXUMwp029rpzJukgH+URYG/UyybB7hODhK4YXyMDy3WxdyHwzuL/H2QAznti1
	 SGv02ruPklnPa4kuiksfAWmU0TB/vs8EMij53UamdHrXgWdiQc1Ik4ovvW2Ws8g4Ac
	 1E2o4dXlntrHknVRcmFWv5g6/rD+4Y5bwX+W5C/CWfnEJPyKx9nyNsOTYHpt0gbRe2
	 G3SZdtpwLehgMWJzjtRacRiM7K5Wm7o7cEVNW7GwMAGGlpWZDlbwHbfdAQc2R3GMyq
	 jpUX+RbAVykoQ==
Message-ID: <0cf0a46b-bdc6-4abb-802e-1c9a3aeeb949@kernel.org>
Date: Tue, 14 Jul 2026 01:35:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
To: Zi Yan <ziy@nvidia.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-2-affb5fe5ed00@google.com>
 <0048210a-e186-49c7-9897-32c9b66336c6@kernel.org>
 <DJUYCPR6Z66E.LC3RMX9CEX29@nvidia.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <DJUYCPR6Z66E.LC3RMX9CEX29@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qyDoBBKI4CFV1ErawcmtQ8PZ"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC6011A000C
X-Stat-Signature: q68b87ebnjebgsd38s7qtqp3jhnwtjbz
X-HE-Tag: 1783960562-569238
X-HE-Meta: U2FsdGVkX1/ZLeGu3k/W8AAA9rCkYN5XFwCVVqrKVoqxqBVxZSrKY5oL7N9IiKTJCZ+um28MhoFPJ49TuHMRQoluo2NeuqGmiFC2uwNzac0GWe874xeRXixC0PdMc0I3NoUR3uq5GGMV2fQpCfdw5ufFLj2kuMG7l2PH3xfP2S34r5gGGQ2/GDkcDjkvE8M22qW0i5ni3PpdUbEjZ7Ehm8pgthV3bYjBy79cbXobwx6DzzCZU0Xb/uiyj9FGNLVcfqX7zT+TRRy1CpzHeuTPpeysD4K4pRvmrfZ6zJCTCF4c7xyODZrmFKRujCHnJ4Xuct6S3Eotbs6bx5+/TaNwfrXXbUYitXeeyOU7eweAlCH0xTPCjo/EsyyVjYzUgIF2WK+B3NkwbOI/PR7rPI1xPGd5MUM8AWsDrqY9B2ZN+qMzi58DJvK+rIJ6oFS9j5q5bjDwedSv9R7yXZKRL/rowYTGwQ9vqBjNN3QGK/6uq1dajwjOTGKc5H0TUQs/d1CWGxg5ceqD5IyJWUGQH0IqNMRQPPaSZhFwqfeBKaFmWaxs+IyuJiZVLGTwF1W8s09D+UEDrZOAQgIMOkBf6NxN3v6+dQ/QaGMonRZ0wojt7slw0cQjCGib4bNi0h3QQrTzecGB/w0ZLeXhe6EjGt2gFVHGv/zCFH3t2QIAme2rw2cffSkwbZ4aqCcavQa5KWhbspL4bDY0LCkBPme1A29z3wNaHn+ghrbsytCyVm/mxmWW2wTZUKFDOxJXatJe58FvT9vKP3uC8uUs4ZUT7+Ea64e+Y5UUHsq2JKLMUrw9hDptSOFU50+JSmen65tGA/3Ts2s+435ahJFKNc6ZChkyXJeCJgCUbmxe5M3hIawdSvJsAR8E6P1A9ma5nByp+fHYMA4V0y3yrSy+aUVP9sFaEtiE+BuJhD21ANkVhqaqM21tO/wZdp+3qDog+zA7IrzvamgpeVuBfNus3vyy1ZM
 sMcD91yI
 3iooD3iRfoqy67rzKmz1kYvKoa62TZUgEJytTPXS2PsMskZzUKkSe2PTt+qU63ZXftkyJ0ho189xijBFTuFMBOLxFE/H9oZ1fVGoTrla9R5ijdvjolMXSzAC7qp3JaDbUDyMb7G2GF/lIndWd7k5D4KO5vQAcucqTW/up/qYtCrTO/1ssSL51Yvgflk6BBvtOQCWy7LYMp+RPPEI6W1xO2xJhRhhF5jogfUvpQuborDyDVYCAFfKP72U9spQ6eLr4g5AxeR8DzyxGY3oR8OhRL9g0q0iO3Jq55tqUO9rkGpy4amVacaBlmlVmaYOMDgrzkD60vUXbciAgMph08WY/ox46KN/vJuYfoqstqYwR6TDi07aWdz6JiIsPkXoEvcrA+KYcKVaKz3hkL6ynvA2Q2IW9g2wBdU3qFu/sOIAdPt3a1la1eqEYyILzoMFHHsVQOGz+XsZS7RzvhI/hppYztJ1mjJ0u06Hjc+9WEmZEbees5Zzq4AVx3W4yRtpYOgINgRmh7DGMAvya3nh3dtloa4GAKfjVHO42yw6UBmQMZTkyNHHRcSXHgxOwwDjmOerQI7Dy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------qyDoBBKI4CFV1ErawcmtQ8PZ
Content-Type: multipart/mixed; boundary="------------Fq0CsMv87TD2rsvZ09eDJYci";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Zi Yan <ziy@nvidia.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Message-ID: <0cf0a46b-bdc6-4abb-802e-1c9a3aeeb949@kernel.org>
Subject: Re: [PATCH 2/2] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-2-affb5fe5ed00@google.com>
 <0048210a-e186-49c7-9897-32c9b66336c6@kernel.org>
 <DJUYCPR6Z66E.LC3RMX9CEX29@nvidia.com>
In-Reply-To: <DJUYCPR6Z66E.LC3RMX9CEX29@nvidia.com>

--------------Fq0CsMv87TD2rsvZ09eDJYci
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/10/26 11:14 PM, Zi Yan wrote:
> On Fri Jul 10, 2026 at 8:40 AM EDT, Vlastimil Babka (SUSE) wrote:
>> On 7/10/26 12:42, Brendan Jackman wrote:
>>> As discussed in the linked patch, the there is some inconsistency bet=
ween
>>> "trylock" and "nolock" nomenclature, let's align it. Since "nolock" i=
s
>>> used in the public API it seems to have more mindshare so do that.
>>>
>>> The linked patch did this for the ALLOC_ flag but forgot about FPI_.
>>>
>>> Link: https://lore.kernel.org/all/20260703-alloc-trylock-v5-1-c87b714=
e19d3@google.com/
>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>
>> Naming things is hard. Maybe it should have all been called "nospin". =
I
>> don't know anymore :)
>> _nolock() functions and ALLOC_NOLOCK are part of API, FPI_ is internal=
 so
>> it's not that urgent. Furthermore:
>=20
> I had a similar concern when reading ALLOC_TRYLOCK -> ALLOC_NOLOCK[1],
> since the name is _NOLOCK, but the comment says spin_trylock.
>=20
> I agree that "nospin" is better and less confusing. But whether we want=

> to churn it again, TBD. :)
>=20
> [1] https://lore.kernel.org/all/DJOZN5H048UX.1ZVSFD48QZN05@nvidia.com/

Agreed, "nospin" is a better name!

At some point I realized "NOLOCK? well, we're using locks, but without
spinning. should be NOSPIN?", then thought it's bit late to change the
name without churn :)

--=20
Cheers,
Harry / Hyeonggon


--------------Fq0CsMv87TD2rsvZ09eDJYci--

--------------qyDoBBKI4CFV1ErawcmtQ8PZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalUT5wAKCRCGXBN6rc5S
1h/7AQCF5kASlmfGZSwsQDL+wbn4ZkmiaE9YxS5ntJj8j7Ik6wEA/deiUAuWtErF
6frBc+P/wyv/2HHN8j9qaE1Wo6yDZg0=
=iyK0
-----END PGP SIGNATURE-----

--------------qyDoBBKI4CFV1ErawcmtQ8PZ--


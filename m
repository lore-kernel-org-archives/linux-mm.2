Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4794CD98D2
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 06:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1D626B0005; Sat, 13 Jun 2026 02:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD3C6B008A; Sat, 13 Jun 2026 02:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2B06B008C; Sat, 13 Jun 2026 02:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7366B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 02:02:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3491CA0309
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 06:02:06 +0000 (UTC)
X-FDA: 84873843852.16.3B8FF14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 962CA180004
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 06:02:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gn8YLTHL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781330524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM1mm9BLVP7BwrpS2cLQRgYuPWTuEt/5Kbci/3Gxbh8=;
	b=jDO11k6Jec/FZUkBjuISDukvKWA0uAukAbt5EwcuG8XuPAISUPjypxXKTMjbKoxekHogIM
	FagGvCf7cDUnOonNrpp42C7jK7NMvI+1nPe1sFCAdv7ZCNz6OevjdQUFU2HtfOdQ6YM+KA
	nIAi7tgOSXc3USdT7sFvM7kDsxlOo24=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gn8YLTHL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781330524;
	b=yekl+IwKT2Ru4YMdnrgN43dZAvX9U83aTvOqfFS+momJk4Ys01MM2w2TzmO0ZLLsZ/4Adq
	Nt5s0pHvcO3Zx5lDoXbc+vxKds06sR6kKoEbvoRB7241jrggh+SOyQ3JqoqEngvQ/jcSxS
	5weSkpsOsruCNsoWA8OQNDatmJVRtFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D943B60018;
	Sat, 13 Jun 2026 06:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540F51F000E9;
	Sat, 13 Jun 2026 06:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781330523;
	bh=iM1mm9BLVP7BwrpS2cLQRgYuPWTuEt/5Kbci/3Gxbh8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gn8YLTHLhVP/c8feGWDahVIvnchCQMGLG4RFcYZz7U5vfzJMPAYwSWpO3l+bum5Yp
	 yYVZeGUpLpWQoiIWZ3CagYJH7uDtAj4a+3bgZazJV6VjvOSZcm/eYHWvNCrghC3OmA
	 HDcOfIOqAfhMOvk+KSkc5lfarC27x23VLGwwNMOS8ehWwrYScuB72B06B3AghzSClX
	 U1P3lGcR8zBvX+xJofkA+hEFEnCvbkWuyY2d3JFfdE87mGglKoTbXro2Nw98nfQnII
	 /Ssza1aGy6TMF9xqrzXbqcIGQJ86rWyNHK4Wg5IJ54jgzSUUT+Bmq517mdRx5NnOtc
	 vZazN7fU3JOdg==
Message-ID: <763e61e9-9270-4057-938f-daf9184a41ae@kernel.org>
Date: Sat, 13 Jun 2026 15:01:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Pengpeng Hou <pengpeng@iscas.ac.cn>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
 <55b1b674-6487-4585-8a0d-919373e66d3a@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <55b1b674-6487-4585-8a0d-919373e66d3a@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Pry6HKXvR97fF73yGuINWk3U"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: abwdzy8ycrgawkjfahmdiwrr9dzodm4b
X-Rspamd-Queue-Id: 962CA180004
X-HE-Tag: 1781330524-433115
X-HE-Meta: U2FsdGVkX19X3v6JWIhOPA/DQUIe6+KFidrVGaRbznMej/yoFemcBN7no5TQB/b2MHwcmz9MI+RTXjga4nPCjd7Jch97yRBqWBTcXpATMt5PfzjwOzhsNrhlUFPOrBtUSg94PC5wjtayTB+R2rFt5olco/jlzGT6YmV3qt/PsaJFlCo2UQxnqdxuGZ8wT262wDyDMmPn6Am7HaWsh+ubsSlltYUKz3KS1fMdWqrgQA3D4h/W+IrjYl2dH43OJpFxO11Nn55zeDuxcllVyzZcOYVKyer+aqN9ZrMbeNtU9UOpTbJk6gL12F1XRMd0dsxKbrXrbZsg28Xb7KL+co+dtkW2pboQITaMQtMC0crFDY/6oJNkV0ExfNu8CWQ8vPQnXBtdShw9+gLCaGGr4IdgFGLR+llQSdqap56Ixk7eu9FoeXm/HUgosNUiO/qsfclOCfO51I6XiEu5n+5RCsCEfEoMdivDxcSAkjjom9OfS6cymxcCvROR5MKh+ARpPm4bh56TpJzcoMT04xAlZsWIZLRF/+bs4HAVUHfMjyjH1tvBhjxEUdJ0rjsdfEMfglu8MeA6qB2rn9yLmsM4HqlDRldfrPqs4C1cfnM0qoRlbTqGPO62wQkb0uCN0k1SV2JMyGxe1V9zUSxvhH5YyCA3lnr8ZzpwfsLO/FeSNr1G0pUZaH+nG95bKWYtQ1T7Ewsf14hBQvh60ecqJxh5KPCWA1mA3B3aC4lANVGXcd1vWeNlcnx7ulyDb4EEP1tv8HT6pPwrkM4BL/HdguW+jejrpFj4j/QT62TtUy6Y6ghB6RkEkKRM+xt4CuUQHyXNfWXThcgtFO9+quJ0ot9D/kY3hIPDsZ2MXsU87aF8gvUpb5koaLy0jv+ER8zvh5vuukR9wSKDL41UJYSp5P3s411A1DlVGw1OAvEvdCU/w08SRJcw7d3t0DHpCAWIIHLwxihzqijjPur/R4JzKR/zUjH
 VEubt1Dw
 qu1fHziF/6EWrTcJgFeNqOVRMsqZ1gXFimaLXaH275WE9cUiuzhI7EcItB8Igec3CKUiG51X9NwsLkrehr5FtLDCAJUs2Tgt9LJE2QPk2AXMRcajbV3HeWVITFG+HJVL7IHOVgLH3/ez5rQ6JIKJPr+F58wjKtHo5U2GRFp3U7xEhE4JPCoWnHT1B19XVFQTUTzZN5/V6AcmcztVAf1S153an/Krg8i3sIGS1Dtw89n25KIx83jPs470QjZtuej/7LxlLFbM98ufKyjfhzMwduf7iDeHfkZ+p6TKXglmqNv25IfBF0bUZZkJH0KefpHtzUfRcY/4B8T3Z0Tc8+Pa8m4+ZZ4ohGDaW/dRkY8LRFW1Bc9BKPHNhHl3xmxuqKovsvYhpr0glK0+QSDEmduRTSypmC2hwSwcJXFNOm9qW3rsqBmuTQkbQHdFuodlPqP07Sn1TFiqWVyOp4cE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Pry6HKXvR97fF73yGuINWk3U
Content-Type: multipart/mixed; boundary="------------l598mhoMA2K7tROMKi453KGs";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Pengpeng Hou <pengpeng@iscas.ac.cn>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <763e61e9-9270-4057-938f-daf9184a41ae@kernel.org>
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
 <55b1b674-6487-4585-8a0d-919373e66d3a@kernel.org>
In-Reply-To: <55b1b674-6487-4585-8a0d-919373e66d3a@kernel.org>

--------------l598mhoMA2K7tROMKi453KGs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/12/26 2:28 AM, Vlastimil Babka (SUSE) wrote:
> On 6/11/26 08:39, Pengpeng Hou wrote:
>> SLAB_STORE_USER currently stores one allocation track and one free tra=
ck
>> for an object. This is useful, but it loses part of the previous lifet=
ime
>> when the object is reused: the new allocation overwrites the allocatio=
n
>> track, and a later stale free can overwrite the free track.
>>
>> For free-after-reuse bugs, the report can therefore contain the victim=

>> allocation and the stale free, while the earlier alloc/free pair that
>> explains where the stale pointer came from is no longer available.
>>
>> This RFC adds an opt-in SLUB debug option to keep one previous complet=
ed
>> object lifetime. The option is disabled by default, is not part of the=

>> default debug flags, and only takes effect when user tracking is alrea=
dy
>> enabled:
>=20
> Sounds useful!
>=20
>> This is sent as RFC because the user-visible interface and the cost/be=
nefit
>> tradeoff should be agreed on before this becomes a normal patch series=
=2E
>> In particular, feedback would be useful on:
>>
>> - whether a separate H option is preferable to extending U directly
>=20
> I think before we converted U to stackdepot, the memory overhead of the=

> stacks was higher than U+H with stackdepot. So I think it would be
> acceptable to extend directly. If a user is willing to pay the current =
U
> overhead to debug something in production, the addition of U+H shouldn'=
t
> make it suddenly unacceptable.

Agreed on extending U directly rather than having a separate option.

>> - whether H should require U, as implemented here, or imply U
>> - whether the extra per-object metadata is useful enough for this debu=
g path
>=20
> One could think of scenarios where even longer object history would be
> needed to find the culprit. But adding one extra lifetime probably has =
the
> biggest impact.

Heh, I was actually wondering if it would make sense to have e.g.) a
hash table (per cache) where each bucket can store N "extra" lifetime
history of objects with the same key, with each element storing
stackdepot handles and the object address :P

--=20
Cheers,
Harry / Hyeonggon

--------------l598mhoMA2K7tROMKi453KGs--

--------------Pry6HKXvR97fF73yGuINWk3U
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaizyVgAKCRCGXBN6rc5S
1nUOAQDlXaaQEVOEBZ0HQ9jcCa19uWCiFVFiHV7ZykbZB16pHwEA6DzCrVGXhxz6
+icLtlCrRsP9S6bLj647cUaoi+NAdQQ=
=LQMZ
-----END PGP SIGNATURE-----

--------------Pry6HKXvR97fF73yGuINWk3U--


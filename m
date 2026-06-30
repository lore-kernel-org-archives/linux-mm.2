Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B6FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8952E6B00E4; Tue, 30 Jun 2026 11:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86CC26B00FB; Tue, 30 Jun 2026 11:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AABC6B00FD; Tue, 30 Jun 2026 11:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 413D76B00E4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:27:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B46B8140507
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:27:29 +0000 (UTC)
X-FDA: 84936958218.07.1998507
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0802B180003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:27:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7aOivSE;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782833248;
	b=UXJn9Zmy5QTI0v6SO2LMJ0pDPuXbc9lGY4XYgUbazoK8jigIVABxI/1g7YIX+9FRPcI2MH
	+gv9BLHr2k17ziZwYG+7JurO9M2KIF3/tvWHX5j7KgimFei00htRf8szehxs5n38KHAnlD
	I0Se7g0+0KaG3bqH+zNo3OcamU4BSRY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782833248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqY9/FD+SFdpA+iZEIeadSnbTIK2eXJ5fOqFXcgJf4U=;
	b=Sw4d577F84FT660QasaR2p7o9gkkl9dUyEuIYUgrEYXxXhbExHEz/utokxiw87cXKKlzW7
	OwfW38L3bbrCYs8GB2cVmogeqHHVfF5VUaC1EjvFIIzZtAEIA4LtfVf5ncGiES0e7VVs4/
	U3VTIsy4WBTuQRdEzWIS4bbEaUOEl2g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7aOivSE;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 760DB60018;
	Tue, 30 Jun 2026 15:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E5B1F000E9;
	Tue, 30 Jun 2026 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782833247;
	bh=bqY9/FD+SFdpA+iZEIeadSnbTIK2eXJ5fOqFXcgJf4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k7aOivSEBgq6tZRBRw3RtgeEr4RL4zSfJrCMvk4KTmvsrf+2CelqCFSaNkXHys8Sf
	 r5KS3Vk4hMBeK4+q5c1IuFesi+wmICd2Yo7Hir3L6/B+WfrUl4TIeJWSLvP1jSu2/7
	 PRu9hNtJBgUTJIykXG8Vse/XPcyw/rEuSdNzlXFfgIkYy7CsSZ5x+6Eg9yfFzJYLdS
	 mTeXv48HxhCmPeaP3O7BYszLn6knqxn3x51AioyVsZYLuTQpcPn3pDLNbDZOXnTwp8
	 TX+FaGD54QnMdnT4t2pn9wpQv7CiMVvDq4pAgIoIaonOQI9HuiIAXpW1QUaj5RlQd4
	 u5X/LnufgG7Aw==
Message-ID: <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
Date: Wed, 1 Jul 2026 00:27:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------skVAWTxerAh0fKLUMQDzBRaE"
X-Stat-Signature: f4amcn9udkznpqe7rmuwrb463mqdzdqq
X-Rspam-User: 
X-Rspamd-Queue-Id: 0802B180003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782833247-374191
X-HE-Meta: U2FsdGVkX1/4Ae65yWcZ79XNKRNt9Hrh6+PLQVZKvDe8ZeoIdc8qV2GfGk5AyEde+toT/a/lTSnl8GRy/bp+wJW+2WLje2Wy6U8254QONs/2Fk25j4S530uRlXqyBW6tjvyhS8O1LRmoeckDZw3LubGqpkB9xASCZ4P7n9h4h0Qj/sclRDj74p2zgRUZnYVQDdAwVvqi8IKAxRmm+dJV2nwRslhPPNgHvR1CguSq7tvSXhNhe8NBzOgLEJJkyv+Zr9YALBXXgYScaefLGO5S9m5kx8TtoATKfABOenl1BlYExsYJBGiA82bpydlyXvenM/9+l5OIkhxZFHx9WlRqsWv7v1vEndAf56IBpswjVrp9bw1Ijdqom/q7TSBipfbZegu8/E7xUrqaxxxhLHLbPkLiXa0KDdoIuwWDn+LPcGHtOPjmp+QODNOw6ROD0nEcqxKWVPNEmBGi9qOi1uy4xtnAHYjzlpspgjX8LTy9Ugl+Rc9kLOF57Kz72jcDKHihyeQgPfMmK+Zy9BXrPfBXELd1ZAPHGKBbDk4xc/u0T22TEFixm58Kkz9BD/V8GU3MRKmKkBM/qu6NcRqHszGMVei7PmUhy6n243XBicINQQv4OUE+QmJqT+n5O90ddewfHOKljo+ixAKn1RUAb8JlfCnIXsnJ7jOhEwdiCgXnhhw34smH9EPuLEhuuM3HoceOFHoL79RuCAFFf2yrOQOlSa/d9/+dDOuK4m7gKSyCAzeaYY1W3k9CtklXejiM/1QcnPejs7kAIc4LRIvNanKhMBo/AqRIiBqZNrgprQseds4gEDbqIjvLgrREHpNqTQ/kbOwF2w+up4nPlQWYoiPE7z6jy+ljbKBC/naPrkyNMHn8oX7j1z/UVShLaRx2C0dc25ayzMouA2yHVCIObNOSYGHoyt4QEmRsMWsGARmY8tWI7vwM76sl80m+W7/j9mCliEF4DAB6xqcUCEglKoJ
 Ryb0GC1e
 iIfABdVJ9YELscufjaAQFdYuiVyQAsGZy6s5cs1Nim+vfqVPj9iieGlYPRDp1EVsP2ggKZ6seRyTdaT5Zn4XFiD0PPcLPFwym0wpmoWjkjxNKPdkZl4lCS2WqNQPvo/sgaIUdZnQbRfeG0bIJoLdJv2mWN7Ee+WNTtGFT6pUGLyHDWw6LR9y7tpKSr8AWlFOdYgNdh+x0ZJmaytEwzFgZ01v9jbvmxT3HC+C9MB2xFfCAOfCGpOvp1Yw4cLwvfm0UcjWTvz5mQvg74pCHHLEl50GH75EqCyIOcVYySBLH7D+0v6Gvym2jtKCKSyj4peJNuIzb0SriYjElXaieL8Djez1MyHEImgU8fg/0rk2X37AETaWpq17zNKqPOfEaNpQWdlKDWg9FrPQ286au49NQKa6yyXn7MMDKTZx/JJTBSNQYQdwiBxSmpaR3XR5usaZyCtAkSp3JFRxQbIkwXewm+qd7pF0wsRpudWpggTkjmK15H/qI5COnJ5z3aHMSjDtaDpm9V89vU5+b31mNH+gGOVV3y6ccLhigW8Wh/hfH/Ax+0XI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------skVAWTxerAh0fKLUMQDzBRaE
Content-Type: multipart/mixed; boundary="------------Sm6xLvjEBt7qrU3afTmO0DHi";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
Message-ID: <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
In-Reply-To: <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>

--------------Sm6xLvjEBt7qrU3afTmO0DHi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/30/26 11:52 PM, Suren Baghdasaryan wrote:
> On Tue, Jun 30, 2026 at 7:36=E2=80=AFAM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
>>
>> On Tue, Jun 30, 2026 at 04:03:30PM +0900, Harry Yoo wrote:
>>>
>>>
>>> On 6/30/26 3:12 PM, Vlastimil Babka (SUSE) wrote:
>>>> On 6/30/26 07:29, Suren Baghdasaryan wrote:
>>>>> On Mon, Jun 29, 2026 at 9:42=E2=80=AFPM Harry Yoo <harry@kernel.org=
> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 6/30/26 1:39 PM, Suren Baghdasaryan wrote:
>>>>>>> On Mon, Jun 29, 2026 at 9:38=E2=80=AFPM Suren Baghdasaryan <suren=
b@google.com> wrote:
>>>>>>>>
>>>>>>
>>>>>> Ah, here I meant backporting either the kmalloc_flags()+KMALLOC_TY=
PE or
>>>>>> SLAB_BUCKETS approach.
>>>>>>
>>>>>>>> Yes, it's worth backporting, so we can merge Shakeel's change as=
 is
>>>>>>
>>>>>> Right.
>>>>>>
>>>>>>>> and then once Vlastimil's patch is merged we can implement the n=
ew
>>>>>>
>>>>>> Vlastimil's patch has already landed mainline, by the way :)
>>>>>
>>>>> Nice! I suggest posting Shakeel's patch CC'ing stable for backports=

>>>>> and then following up with the fix using KMALLOC_TYPE. Vlastimil,
>>>>> WDYT?
>>>>
>>>> Sounded like a plan, but then I realized I misunderstood the amount =
of the
>>>> wastage. E.g. on my system kmalloc-8k with 4 objects per slab would =
have
>>>> obj_ext size of 64, but now it's 16k? That's ridiculous.
>>>
>>> Right.
>>
>> Yeah I should have given more thought on wastage.
>=20
> Ugh! I didn't realize the wastage was that high.

Ouch!

>>> ...which is why I was assuming either the KMALLOC_TYPE or SLAB_BUCKET=
S
>>> approach would be backported as a follow-up. Err, should have
>>> communicated clearly, apologies.
>>
>> Harry, do you want to take a stab at prototyping these? If these look =
simple
>> enough, we can request backports of this.

Ack, let's see what would be the minimal changes to resolve this.

> I'll also give it some thought to see if there is maybe a different
> way to fix this that would be easy to backport.

Thanks, let's discuss!

>>>> We could say it's for a debugging feature, but also it's running in
>>>> production fleets (and Android?), so probably not that easy to dismi=
ss.
>>>
>>> I think a key factor is when it's enabled in production.
>>>
>>> kconfigs says Android selects MEM_ALLOC_PROFILING, but not
>>> MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
>>>
>>> I assumed that turning it on by default in the entire fleet
>>> would be bit hard to justify... (please correct me,
>>> if it's not the case)
>>
>> Actually we have memory profiling enabled by default across Meta fleet=
=2E So, the
>> issue is very real.

I see, thanks for clarifying.

>> At the moment, we are seeing this issue on a specific
>> type of machine and we have disabled memory profiling for those machin=
es.
>> Internally we did discuss to simply disable memory allocation profilin=
g for
>> kmalloc-normal caches but to me that was a big hammer and thus suggest=
ed the
>> current approach.

--=20
Cheers,
Harry / Hyeonggon

--------------Sm6xLvjEBt7qrU3afTmO0DHi--

--------------skVAWTxerAh0fKLUMQDzBRaE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakPgVQAKCRCGXBN6rc5S
1kRkAP0cCyz+MOuScd4bBw4i+wwekcvOlfmYceS8T/EMfZsBGAEA2SuKBS6mNz/o
Zk4R3X5gR8S1OGqYJJs8lIT4me06jgQ=
=3A81
-----END PGP SIGNATURE-----

--------------skVAWTxerAh0fKLUMQDzBRaE--


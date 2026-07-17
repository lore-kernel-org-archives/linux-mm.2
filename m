Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F297EC44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 04:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AAD46B00A2; Fri, 17 Jul 2026 00:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782156B00A3; Fri, 17 Jul 2026 00:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1EB6B00A4; Fri, 17 Jul 2026 00:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 371856B00A2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:09:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8306D1603E6
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 04:09:48 +0000 (UTC)
X-FDA: 84996940056.14.2D1182C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id F17AA20002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 04:09:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnsCwBS3;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784261387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edGbSK8TjCQzoqJgD44mkiQBfxhpKtjMEjrxayeSpPo=;
	b=Cu6CL/Gk+symZbzRssnzfgwoc9tCWodEfyyvjn0lplVghiBNTXEAVdpSkWWbgqvH2aAgpj
	y2zhg0rFK2Hjp7nAPZEiWJKLYpQ0AIgWiRfEb3lZrZwYjAQhoT23jOVqhVSJG6LIge7Kxw
	W/6/uDz4ScyClZpbyRt4FcR5vR1RHWk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WnsCwBS3;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784261387;
	b=yUFbvVojHMA9bSXFJZhJ3RJkZM3hq8EZEC/K4ZJ9npB1zM8f9AFBSTitueCmkve0kWp3l3
	QUDXMvgFGr+7CI7LiwsIzWcLZ1rMZktfE6dukdEQp92yJqlTfZwPZdkQ+ut5z4gxQXbUbx
	XKoNlvQ1kGdBeS6dm2kKBis0MbjMK6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76F9E60A5E;
	Fri, 17 Jul 2026 04:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F201F000E9;
	Fri, 17 Jul 2026 04:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784261386;
	bh=edGbSK8TjCQzoqJgD44mkiQBfxhpKtjMEjrxayeSpPo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WnsCwBS36OJEP3bzOpRdgkN9Rt6YpelKHYJxHxSpP6gjDw9UPV89RzQ+Pxry/c3Iw
	 FhsE2r6SRCAQpdy1mnkvDUwXsWWbwhTwX8jHcqsfhy8Z28L7adsvGtprh6WVovXmCG
	 OWRGjysCgfEBIBX/dZG5/xSmXPMGZstbn9RzT2DsuEX10FO9nvjN41vOdaGUtDSfws
	 DwKtw6p5qODsdWl+wgElVTWFS2fmSISHopXe9K80SYJ5dH9hTUEtMtcLApjLyNyLfe
	 bYcL9/HfYZXvP/KyfstIEU5f8JItU3hn+wKdyxSGJIX/Oy61DW9AVMMTdQbE2QoSky
	 +/WeFSRdhIXAw==
Message-ID: <eb9984b7-27e6-4747-8f7a-9408582c3acd@kernel.org>
Date: Fri, 17 Jul 2026 13:09:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <alkdRqYW_Pg8r4sH@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <alkdRqYW_Pg8r4sH@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Jiwqshj8DHDXqCQJEX0Nuazd"
X-Stat-Signature: 13983bxqsb3z1ezxdd3wntcxs11ukzdz
X-Rspamd-Queue-Id: F17AA20002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784261386-495940
X-HE-Meta: U2FsdGVkX18KupEBw0XpXaYsHCZ5kahGeyTIKckCUqaHHPDpsEON5/w9JngJV65jyYbbDUwkN2pjn2lB0uwsfs7ENyHNFBwVMFmXQ+S3adiMjHq/p6dXTGx4AGqIQSxxNj07CkDsdrFn+DIKRxrdjlGrMScfGVwPYA0jvDm/Ykvh1pRD6Z5aaPtdqBbt9h1GVra4Xng6hYK9AQpLSzUyLF96mFgJoTq1knT+sbBM07ICiw95bvYT27Ae+LIeUZg3RF4skdwiWjuTZYauZrrLtG0lk97BjhiJdoULIKokpL0l6MlIhVeGoCg93FxUe0vJqeENhe2CJpuhMXjjm7eG59wlVRIR3PNDI39JEKg5/jX7Ptt6r8Le2xuibFTe7/zQXhi6XEcAhV28Yw93zKTq4Y63s5PUIgKCSSm+e0hkabjq63uRifhuvkm5C7hx2xP2Ry+CdszjDCOWHVoZQIM8gqGnxxGcYlgghWu2rJcj+KnY0G3UVMki7t31BPOT+B6egeOWM4MMEk6toJiPGMvTpjSxj0YuYS0irWp1CaNwNxQSwdyWIENW/IstmMs78adR3MlruODlgVQSnaJVweYTW6C7n09vtb7usHlO+/LlKjHT1RkLK+jEnCR8YiLS68VFeuYdm3mqC2vSWCCFD+PVAXs7kMBxbZN3kPNAe8fIS8eLiUe3OSyuL1FjFTgAsCQAIoS4nV+hhBncdtdz1VF+AmcUZVuFRBDE/2kUHv6kz0iraWsr3j3t5Itw/Yr+96/Hx6WQ6+DcuNHS/KM7vw0EksjprSshDvthKtVgynFeE7a01skTsBX50cT5Se5Tr21phcYiY5ZmRVL3R186dRy2KeDOTjDiNBLgmGnoNh8rmpaXtEHSX1zUn2oK/cOeRtauTWAm1aZRu0Fvck2WRTtfoEv1lj5VrA72CIIn2clOh9XWCB9sCo8VnQWaUSJgaxcW+3wpLo/68myBbR1yaWV
 /5jAQ3px
 v2T/jBDVGSUKLFTne7NjUeuzmL4BvhNZua2H0/H6PnmZFhDsR6EH4flia1nsXk800GUNSavdOoL4SZGM+Ks/I3Q8UB13xKtDZ989Fj4lySVgqxALrs6m/BxoJlyeZir/DnUOmukCQbdIX6/UsK2muKWs754zBSrgRErUXDbIhyrRfKekVNXOIm/RmyynWz/wMX8MjsvKJhgHAJF3Y3x7rg6ezcjUWLMg08B+MsJbmYU1bBAWvQX9D7/9AuvgEd/VP8awmpXSlL/rU43rgMpGomnud486JcEsBkGIJeqGGP3CLc1m4SqNcecvSGxBDbJRMKG9iIOsaebbmhCV/hOuzueSaFUuxuy6d+HJpZArwr7KKPp1UGqTgD9cz7PRBCvFknMq5ChA/UQZZnL56aYDB9ikgFzE1Es9gFgsfNiCKk6aws7S8o+R9rBGDK4OYAoLCr7cCuCyWyX+ERsO7QQVYhybNchLpkUOcnSgT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Jiwqshj8DHDXqCQJEX0Nuazd
Content-Type: multipart/mixed; boundary="------------MKPm6oOgpMGWbq99AxRL9FA0";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <eb9984b7-27e6-4747-8f7a-9408582c3acd@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <alkdRqYW_Pg8r4sH@linux.dev>
In-Reply-To: <alkdRqYW_Pg8r4sH@linux.dev>

--------------MKPm6oOgpMGWbq99AxRL9FA0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/17/26 3:05 AM, Shakeel Butt wrote:
> On Mon, Jul 13, 2026 at 11:28:48PM +0900, Harry Yoo (Oracle) wrote:
>> This is a follow-up fix after the recent discussion [1].
>> See patch 4 for the detailed description on the bug.
>>
>> Based on slab/for-next-fixes (af9ea231c0b45) and is available at
>> git.kernel.org [2].
>>
>> Instead preventing cycles by bumping up the allocation size of obj_ext=
s
>> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and=

>> disallow formation of cycles between kmalloc types when allocating
>> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
>> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all oth=
er
>> obj_exts arrays are served from normal kmalloc caches.
>>
>> I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
>> KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
>> sheaves for those caches. So I introduced a new slab alloc flag
>> SLAB_ALLOC_NO_OBJ_EXT.
>>
>> To avoid huge confusion, I had to decouple "disallowing sheaves"
>> semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
>>
>> While this cannot be directly backported to v6.18 and v6.12 due to lac=
k
>> of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
>> particularily challenging to backport it. Instead of a new slab alloc
>> flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
>> kmalloc caches don't have sheaves in v6.18 anyway.
>=20
> Hi Harry,

Hi Shakeel,

> are you planning to send the backports to stable once this merges into
> linus tree?

If somebody wants to give it a try, that would be great! Otherwise I
will send backports although it might take some time as I'll be
working on and off for a while :)

--=20
Cheers,
Harry / Hyeonggon

--------------MKPm6oOgpMGWbq99AxRL9FA0--

--------------Jiwqshj8DHDXqCQJEX0Nuazd
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalmq+wAKCRCGXBN6rc5S
1qmHAQD+ufBk+XgySKJ85ury9U++anJWJL1IaC/8hVQx4p66pAEA8wo/1GOFFady
eGF8ls3ggok50tIUz7P10M+D0UTQYwY=
=RP2N
-----END PGP SIGNATURE-----

--------------Jiwqshj8DHDXqCQJEX0Nuazd--


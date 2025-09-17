Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FE2CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 06:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657388E0002; Wed, 17 Sep 2025 02:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F3D8E0001; Wed, 17 Sep 2025 02:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6348E0002; Wed, 17 Sep 2025 02:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC5C8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:27:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2490B92C5
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:27:39 +0000 (UTC)
X-FDA: 83897761038.28.614DB79
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8CF2120008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:27:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=F4wjIh8z;
	spf=pass (imf03.hostedemail.com: domain of deller@gmx.de designates 212.227.17.22 as permitted sender) smtp.mailfrom=deller@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758090457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgHbGS1Eo/NYp/d/kiwk0P2tMfA78VX2y50K67XVTo0=;
	b=HOQr2CcUIPzcaGMQoO3OYNrsZqRcha1PGq885C6nsFNkMq95MzvFk2uwsxFKcWb3ppIAKv
	KHGslRg6WZFlSGUcUj4WYNyJhm0WkyMFcK2RXuk4rSeK1KGsYKdEhpK15hfyb/9G2IwZxr
	g9fsM5MwKA+IyWnBUpMSJLhgIx+25N8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=F4wjIh8z;
	spf=pass (imf03.hostedemail.com: domain of deller@gmx.de designates 212.227.17.22 as permitted sender) smtp.mailfrom=deller@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758090457; a=rsa-sha256;
	cv=none;
	b=lasBuSnZRUF6JDWonJh2fhBmIvMwtHb+qtjvjClQNVYGYQJB2NFE98BVQczNPdDmE1CHSe
	A/c2sEy1g/XegkLVRTK2nMmZgpCB3J88x7XqYwPdmSDjm03FTBP7J8/U46HA+UAFTWUOGd
	uVCuiXM6WyXXnPujvIrSZ+Xgy4Wth5k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1758090438; x=1758695238; i=deller@gmx.de;
	bh=BgHbGS1Eo/NYp/d/kiwk0P2tMfA78VX2y50K67XVTo0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=F4wjIh8zq+X4pOKP5zpRvWVKFtBl+60XjcpmLVHT0Ojsh+z9UFQb613jAxZPZ4se
	 /C8ll7KCnFV2kLgvSVv8bsMRUKg1Re6u786qHneBo9mkxFMlmb6DBsRym4Y0A/N0E
	 UmjE0gcHqqty4hcNreK9Bwa85vjgYfPMIGwx4AulmDpi2uq3Gz4/swjf0//ZTs3Pp
	 kKTYC6x8f+XR2EAZ68NZSZf7ZBzmxNcMEwQAVr4CuymdBXc8nOFFnftvJNPJ7H5bC
	 vwryRJ51iDRDM83M3IJan6O6wge+jrPM7boLcs6ZyTFRz+9G0nYAn5QedHVxkMANb
	 B5iRvYQJITTZIN18Uw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.55] ([109.250.63.58]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MPGRp-1ukf8K3an7-00LzUQ; Wed, 17
 Sep 2025 08:27:17 +0200
Message-ID: <6aa9fd2f-4a7c-49db-91ee-67cf2f561957@gmx.de>
Date: Wed, 17 Sep 2025 08:27:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
To: Mina Almasry <almasrymina@google.com>,
 =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc: Helge Deller <deller@kernel.org>, David Hildenbrand <david@redhat.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 "David S. Miller" <davem@davemloft.net>,
 Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org,
 Linux parisc List <linux-parisc@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk>
 <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
 <CAHS8izMjKub2cPa9Qqiga96XQ7piq3h0Vb_p+9RzNbBXXeGQrw@mail.gmail.com>
 <87y0qerbld.fsf@toke.dk>
 <CAHS8izOY3aSe96aUQBV76ZRpqj5mXwkPenNvmN6yN0cJmceLUA@mail.gmail.com>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <CAHS8izOY3aSe96aUQBV76ZRpqj5mXwkPenNvmN6yN0cJmceLUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4+fwHU54tyonjWnP/umRiDkexNHK9Wts2ptVu5jzIJ3ITwwN5DI
 75dut9PhVhAuIy0Cjmhhg38jAOmvmaiP6/7DIaHyUAn2TpRv3Jy4uMEObFz3cBF0KzCtlAZ
 GLZZDFBy3uteMwX0SzAX/24VQvAAvM1yBwIT/y3FDgxxV+aY/cjEUZ1ACqXF/256OC1NQg6
 GJo+j4ievkb57jg7XRxNw==
UI-OutboundReport: notjunk:1;M01:P0:kG/X0+TuUWo=;fi/NleBtQTRCTslF71Z6yB1tuz5
 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
X-Rspamd-Queue-Id: 8CF2120008
X-Stat-Signature: 7n5s9yo31k4h1f64qdas7ea1aez7dm71
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758090457-133575
X-HE-Meta: U2FsdGVkX19SDa8bcvY03DjFZxN4cs6oRYzklJtykTB3fFBUw8ySDomnsAFLnuxP/9Ng0aUxqfcqr6amXI1UO3Y8yODMbrBQRoP/OxQqfJsUK+HzTHFcQpEMECMLFDJUJd/Fk7HZgGiaiPS2e1x4h3QhfiOt/gN3PYoG/CDSt+4DJkylrS4WiAZgImCPFAuZammC/294H2Es2TfWOobsLBxCE3eppx4+JCjsOn9xD0sbqJrhlY9y1NaHBz6rmFNcX4BSoMtaoEWcMC8SpkHeygNGfUCA04ZL03z+l5Ghf+X2Mfsm/Kxyw1jesGOGx/Jd9q+WZXFUHpINx/1Xqyn4ieW7SPrGsDAl7xcechZgpxISCkrdensvcKUDuAnnJpyD5hcESbyZI++XSI+PIDPzBu/aOs2MgBr78Si1SEtgbShIIP52SiS4KhJdAKEGl/YVCbCv9JosPx6RXJDlR6bi5SIWnYlvGZXnf+lcqZRzyCS8nuRFh5RgoQOB0fIGowlcED2k3ynLU4Yfc1evhm7aKi8vxE7lFhlO3pcS8qn5ejlkT2flfNQbeScMfNItx0mqG6GP3OzMGVbCcFYTN/2D1SjBSjRmXTywj4iAtIaHAeiZsyNi3WRZXPRfXM3bDv/VHK0GNgJr44zj81uNa2gi8VO2X41NjdeTA1eoskZqxnJHSv7iDLgqZ82ZKbWt8MN8gT0uDgG+duBuaE3Pu6mhRmW/KXe+o9gg5YvSZy6TtrcYW6Yolvx5tKmhTOBjCiWoZOW6+7ELeZSgyPmTaiEZ3VCVxQy0T4FnrIbxrXHBFNhubd0kSOrZnWOPwUi7F/hBcZvLKJ0E5J6Ei/syx6VMQSv5n8sLZ4EnCMdptpqRNtzcK4WFhxX+SBJmCD0M4O/NsP/YUFMiN256nd3+UYw1S2ggNk0KmAhLjeZUv75LDoyxxS3NHsX4+HKmOrx/5y8NSBdSJO+K6h+UKEudrAl
 PIjMNFpK
 A0PvEbhBFxyM0i7xVf5WEYj+Z+/e1NZC5wKsj1iSULxy3HmRFdb9gjsN2wRE677FGrpnaLAWvBxMVLUuBg+iDoS4trZlY5p9tnjPt5lST54fy6h2dlPsgkCBWAFqwXnWEvw/EjMzRrkttNS7eUOIGH/8GAsiVieimLJwzbx47siScsWiM4qSfyy9eor8T2SAER0EVz7RQnziRKW5RKXUQTsxDEe88vO9QvSrlEpFZJBHStRI4WXsDP/f5z2we0bWKBm36VTTvAY+X+aHRMoZrpBjd85pKuhLxIFUbeGNC5i4SRCQe3SWwzjRbDCEeRiTiX5jNegZ/nrnkxi8LZGIY7TYkQ5Xcdq7MTLSKArEzv0Q6fbfwhrd8SaDLzHcGEj+xDxQt461/qCqF0xC9NEOR/s187ScjI0fzkNmrp1Jkwot2maPZsSg819qSaTaQGnf+X5KSkx1hnujcl3RU8aU39mJbqPTCH3s4X0cH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 00:21, Mina Almasry wrote:
> On Tue, Sep 16, 2025 at 2:27=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen=
 <toke@redhat.com> wrote:
>>
>> Mina Almasry <almasrymina@google.com> writes:
>>
>>> On Mon, Sep 15, 2025 at 6:08=E2=80=AFAM Helge Deller <deller@gmx.de> w=
rote:
>>>>
>>>> On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>>> Helge Deller <deller@kernel.org> writes:
>>>>>
>>>>>> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap t=
hem when
>>>>>> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc0=
00007c on
>>>>>> 32-bit platforms.
>>>>>>
>>>>>> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify =
page pool
>>>>>> pages, but the remaining bits are not sufficient to unambiguously i=
dentify
>>>>>> such pages any longer.
>>>>>
>>>>> Why not? What values end up in pp_magic that are mistaken for the
>>>>> pp_signature?
>>>>
>>>> As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
>>>> And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA is =
zero on 32-bit platforms).
>>>> That means, that before page_pool_page_is_pp() could clearly identify=
 such pages,
>>>> as the (value & 0xFFFFFFFC) =3D=3D 0x40.
>>>> So, basically only the 0x40 value indicated a PP page.
>>>>
>>>> Now with the mask a whole bunch of pointers suddenly qualify as being=
 a pp page,
>>>> just showing a few examples:
>>>> 0x01111040
>>>> 0x082330C0
>>>> 0x03264040
>>>> 0x0ad686c0 ....
>>>>
>>>> For me it crashes immediately at bootup when memblocked pages are han=
ded
>>>> over to become normal pages.
>>>>
>>>
>>> I tried to take a look to double check here and AFAICT Helge is correc=
t.
>>>
>>> Before the breaking patch with PP_MAGIC_MASK=3D=3D0xFFFFFFFC, basicall=
y
>>> 0x40 is the only pointer that may be mistaken as a valid pp_magic.
>>> AFAICT each bit we 0 in the PP_MAGIC_MASK (aside from the 3 least
>>> significant bits), doubles the number of pointers that can be mistaken
>>> for pp_magic. So with 0xFFFFFFFC, only one value (0x40) can be
>>> mistaken as a valid pp_magic, with  0xc000007c AFAICT 2^22 values can
>>> be mistaken as pp_magic?
>>>
>>> I don't know that there is any bits we can take away from
>>> PP_MAGIC_MASK I think? As each bit doubles the probablity :(
>>>
>>> I would usually say we can check the 3 least significant bits to tell
>>> if pp_magic is a pointer or not, but pp_magic is unioned with
>>> page->lru I believe which will use those bits.
>>
>> So if the pointers stored in the same field can be any arbitrary value,
>> you are quite right, there is no safe value. The critical assumption in
>> the bit stuffing scheme is that the pointers stored in the field will
>> always be above PAGE_OFFSET, and that PAGE_OFFSET has one (or both) of
>> the two top-most bits set (that is what the VMSPLIT reference in the
>> comment above the PP_DMA_INDEX_SHIFT definition is alluding to).
>>
>=20
> I see... but where does the 'PAGE_OFFSET has one (or both) of the two
> top-most bits set)' assumption come from? Is it from this code?
>=20
> /*
>   * PAGE_OFFSET -- the first address of the first page of memory.
>   * When not using MMU this corresponds to the first free page in
>   * physical memory (aligned on a page boundary).
>   */
> #ifdef CONFIG_MMU
> #ifdef CONFIG_64BIT
> ....
> #else
> #define PAGE_OFFSET _AC(0xc0000000, UL)
> #endif /* CONFIG_64BIT */
> #else
> #define PAGE_OFFSET ((unsigned long)phys_ram_base)
> #endif /* CONFIG_MMU */
>=20
> It looks like with !CONFIG_MMU we use phys_ram_base and I'm unable to
> confirm that all the values of this have the first 2 bits set. I
> wonder if his setup is !CONFIG_MMU indeed.

Btw, on 32-bit parisc we have PAGE_OFFSET =3D 0x10000000.
Other architectures seem to have other values than 0xc0000000 too.

Helge


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25CC2CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80FE98E0006; Mon, 15 Sep 2025 09:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7E38E0001; Mon, 15 Sep 2025 09:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF5A8E0006; Mon, 15 Sep 2025 09:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 554108E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:08:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AA8213B73B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:08:51 +0000 (UTC)
X-FDA: 83891514462.15.F6CBC58
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3DCC18000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:08:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=HWzwaYsp;
	spf=pass (imf16.hostedemail.com: domain of deller@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=deller@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757941729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqeRMhOL1SMTCDs5vqQc3eJUpMrwSaAVBTq69H6u/n0=;
	b=xPCpgkm/s9qoG0XGjdVnAszx5erbjbe6nE5PxfdqvBh/PmOtlIzf0NRt4LSpbRFeH2kpgw
	xOPYZQfe3JJR+LR5uIdADViZhdTIhR/wYmJCOiLwTYLHRgsFkaXLY90DygQ+B4X7zMUPTW
	k6V0bf83WDje6S7aWhjep4j+vLyzG8I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=HWzwaYsp;
	spf=pass (imf16.hostedemail.com: domain of deller@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=deller@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757941729; a=rsa-sha256;
	cv=none;
	b=7n2KnvIJYClB4nOMP8my4RBsGFAvoSimAwZMcSl/YKhEqtwGDZnb0+hJ41PYWAs1VkRY7c
	kxTm/LBbGFlye/GiUcWC8T5bZeBMxNVPpG9bUZInuKXl9dsW0b0/AOYFuij3rPoGtkWQ5Q
	FN6nUuDIqgWev++KjT/MCrz5Wdw8Lck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1757941723; x=1758546523; i=deller@gmx.de;
	bh=CqeRMhOL1SMTCDs5vqQc3eJUpMrwSaAVBTq69H6u/n0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HWzwaYspH3cCdZEYTBQEHLiFNuj4io6hPR7HOkAOUNx+PJiQMe3oBsHYjK4gdayW
	 8yBRIwIr6N5fGv4gLmGA5yqBTPnbo4k7yRNRGhcD+7O1Xz9k7EkpmcTAttZwbya+S
	 2nUeD7OzuYVZUXNmWNFF4Vl0Z5OnfvujD8WBEZKOPu3PLTincrZ7EqKAFx2NGGGEf
	 21z22ICncnyfZVmmc9XuTOH9xUSviH+mTDCQnVHDnU7CoGaInQdzo4nTXDQZ7m5nd
	 iGRwrFWjn6ZcirRRxeyf+nFRI0xUS7ulrc9ObKvl0xi9rX7Gkp4F3uD9d/KsolU5I
	 rbvBshbT4g8rx3PTbw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [10.8.0.6] ([78.94.87.245]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mof9F-1uaOmY0Bpp-00qJYh; Mon, 15
 Sep 2025 15:08:43 +0200
Message-ID: <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
Date: Mon, 15 Sep 2025 15:08:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
 Helge Deller <deller@kernel.org>, David Hildenbrand <david@redhat.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 "David S. Miller" <davem@davemloft.net>,
 Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org,
 Linux parisc List <linux-parisc@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <87zfawvt2f.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gX0nUwOgJWIAJNQ4LAxGpAiMl68G0xBqSqjCby/EHlxW4jyjK6g
 0ymovSAslw7alGycTbS9/YX/ndac1PpMpGJ2ImSQTGz+Htrxz1S7SMx41HMigZ5cw+RYbnS
 55PN9JFA58Pm8/qIXm8hRvp2qWVeObIp9pKjkyd/ZavX+TKUsYJWkMMVv0jEIhlZ1qAZCX/
 OjYcpgJ7IaGmUPirjSxUQ==
UI-OutboundReport: notjunk:1;M01:P0:s5y4m8bEIAo=;H+M5gelKnQySMXMQY78NR93PJ8q
 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
 eelJ40a3RodWbLa3oMk9CbdH3HlvWbTw==
X-Stat-Signature: efzyn5mz1xx955eakk51xx54d3yafhao
X-Rspam-User: 
X-Rspamd-Queue-Id: D3DCC18000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757941728-621513
X-HE-Meta: U2FsdGVkX1/5jSK/bT8sKdC3/+m5HmL8u+gOQS96iMv6zYgOUHRNfFMWVUI3pkRiQxv7BfbvcTl7sQF7rZDkvCmRDILWUPmxl80gZoZdbvSz4/6s19AplbDJK8lISJ/c6gM0uFnEel1+X2+Fmq+D4P+UiN5DP4AWKWyAnjUnHa/uP8fd6lZpRWhEgWfTaqc6qrcEyi8Ci2Cm3j9WJVppz8TcKTWiyJnPTo7iqUoWiPQ0QYXT1aot2W9aLQGPjJAcnJT5DuD4JuHIj3Xv7Qhjd5q02fShGnA5rCAXzBcvai8Uh9HKH2hqL6hRxkDiOeUBBD8U0rRnLbEyvlcXbS57Ai9q5EMYevi7/OMbbJ//lZj9Fwgeanx4ntae60nPwVvSc17enwY/5+8Rr5LLsv7tE0piLktmr7e4mCrzsDuPFak0JUHLAmMleTdzJsIt3ELA0x5aUwpdxBdCvezXArKs0VXQmYg7V54fAoT9r0FTsnR1eXO+8QZycckQKF6VBUrGm7/lR/+wVHnEXhc/347zyeFZ5hLpYZf0nTBB/qtj7+PnIjXSJqT9Frp3OgugDDAHRjTfRZ2O935n6qL8W+n7ORR2PR/e7KeJHu2rxUd+uQWGjYeYtLGiXFULruX+ctllynEgMfsnmRDC0ZKryZIQlJLvLVWF1v32lT442Vn5y+Y47r3Z2iVmxNDvdOehwjk+Dfp1M4iJbbLYXu9/dPPkbwI7nsT+DUSRz1xweKTZQLxdhRbXQYgLwfetFZXbF+wHusLfqg3aYfg9cUXG6dNddWVpHwJeFJ303/jKAzusVOTiMG1xdQcPyGOWPKluiRlbaGvsa+j4fI67QnGyaCukarlkgNo/ly05Tvsx46od0HroQx4CTWQi0rP3zqQv5qXvG4Q11kqTAsZxYRYb/N+J24Sb1ot/K0gl7m22w4dXIxtULA2hhjO/q1Pc62u0TFG2+8trW/VM6+paaXONNjB
 lDPdYHqP
 6gypGOcSdsk/i7nVcp8jNOogdsQLp356TjhNys33Yo9lq8Zvkx8sCs1nNmh2Jtt6GwLSo7qmmdAD+r+0U0ESMmQ9Ny4N5oePiwbKR+KhRxM8lrBnGNHGF4BXfJ1oajqHAhuivkYUOUxK2gIUQNLsH9cxgPw8tSP4S0NvLFwxWQkFCp7u87KrWL1R0rFImVpugneiz+SMwOIHrp2bUN3XJD7oBxaZCj8cs74QhNqplYGquQdo8Ch/Id+eqK2rWhRh73W5/3espGqWhiEZJxWo64upWyNhL3i8wX90TQbtYtd6oAq1DsC3E5r1bGj01bihjh2MXRbdF2wTjna2khPru3/L4Gwl+jWXs01NMFk/QElsU/sIskCOyWRivV9HxS1KQdfdXnBEMdsJfIeZRAc1b25h+JOEW9MfeQpVW/Usv3Vblf8fe/b7ANUp9J/SOA/8L7EKfcfgkOV55bO42SKa2NU55jS/coDNR0qK5ddKIEdNlYg0lgXDtGGfoGmfyaOS5RX1Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Helge Deller <deller@kernel.org> writes:
>=20
>> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them =
when
>> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc00000=
7c on
>> 32-bit platforms.
>>
>> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify page=
 pool
>> pages, but the remaining bits are not sufficient to unambiguously ident=
ify
>> such pages any longer.
>=20
> Why not? What values end up in pp_magic that are mistaken for the
> pp_signature?

As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA is zero =
on 32-bit platforms).
That means, that before page_pool_page_is_pp() could clearly identify such=
 pages,
as the (value & 0xFFFFFFFC) =3D=3D 0x40.
So, basically only the 0x40 value indicated a PP page.

Now with the mask a whole bunch of pointers suddenly qualify as being a pp=
 page,
just showing a few examples:
0x01111040
0x082330C0
0x03264040
0x0ad686c0 ....

For me it crashes immediately at bootup when memblocked pages are handed
over to become normal pages.

> As indicated by the comment above the definition of the PP_DMA_INDEX_*
> definitions, I did put some care into ensuring that the values would not
> get mistaken, see specifically this:
>=20
> (...) On arches where POISON_POINTER_DELTA is
>   * 0, we make sure that we leave the six topmost bits empty, as that gu=
arantees
>   * we won't mistake a valid kernel pointer for a value we set, regardle=
ss of the
>   * VMSPLIT setting.
>=20
> So if that does not hold, I'd like to understand why not?

Because on 32-bit arches POISON_POINTER_DELTA is zero, and as such
you basically can't take away any of the remaining low 32 (30) bits.
 =20
>> So page_pool_page_is_pp() now sometimes wrongly reports pages as page p=
ool
>> pages and as such triggers a kernel BUG as it believes it found a page =
pool
>> leak.
>>
>> There are patches upcoming where page_pool_page_is_pp() will not depend=
 on
>> PP_MAGIC_MASK and instead use page flags to identify page pool pages. U=
ntil
>> those patches are merged, the easiest temporary fix is to disable the c=
heck
>> on 32-bit platforms.
>=20
> As Jesper pointed out, we also use this check internally in the network
> stack, and the patch as proposed will at least trigger the
> DEBUG_NET_WARN_ON_ONCE() in include/net/netmem.h.

Interestingly it did not triggered this warning for me.
Need to look into this.

> I think a better
> solution would be, as Jesper also alludes to, simply adding more bits to
> the mask. For instance, the patch below reserves (somewhat arbitrarily)
> six bits instead of two, changing the mask to 0xfc00007c; would that
> work?

That just shifting the main problem and you may be lucky for short time.
page_pool_page_is_pp() need to *reliably* detect pp pages, all other is gu=
essing.
I don't believe there is any way to really fix it for 32-bit other than
reverting your change, or to disable the check (on 32-bit).

Helge

>=20
> -Toke
>=20
> diff --git i/include/linux/mm.h w/include/linux/mm.h
> index 1ae97a0b8ec7..17cb8157ba08 100644
> --- i/include/linux/mm.h
> +++ w/include/linux/mm.h
> @@ -4159,12 +4159,12 @@ int arch_lock_shadow_stack_status(struct task_st=
ruct *t, unsigned long status);
>    * since this value becomes part of PP_SIGNATURE; meaning we can just =
use the
>    * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA)=
, and the
>    * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER=
_DELTA is
> - * 0, we make sure that we leave the two topmost bits empty, as that gu=
arantees
> + * 0, we make sure that we leave the six topmost bits empty, as that gu=
arantees
>    * we won't mistake a valid kernel pointer for a value we set, regardl=
ess of the
>    * VMSPLIT setting.
>    *
>    * Altogether, this means that the number of bits available is constra=
ined by
> - * the size of an unsigned long (at the upper end, subtracting two bits=
 per the
> + * the size of an unsigned long (at the upper end, subtracting six bits=
 per the
>    * above), and the definition of PP_SIGNATURE (with or without
>    * POISON_POINTER_DELTA).
>    */
> @@ -4175,8 +4175,8 @@ int arch_lock_shadow_stack_status(struct task_stru=
ct *t, unsigned long status);
>    */
>   #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA=
_INDEX_SHIFT)
>   #else
> -/* Always leave out the topmost two; see above. */
> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - =
2)
> +/* Always leave out the topmost six; see above. */
> +#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - =
6)
>   #endif
>  =20
>   #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHI=
FT - 1, \
>=20



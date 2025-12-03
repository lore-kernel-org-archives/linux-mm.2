Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF171D15DB3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 16:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A8D6B002C; Wed,  3 Dec 2025 11:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34506B002D; Wed,  3 Dec 2025 11:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E713F6B002E; Wed,  3 Dec 2025 11:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D64566B002C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:43:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A9711606BD
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:43:55 +0000 (UTC)
X-FDA: 84178731630.18.366845C
Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2582A40006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:43:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=ChzS+WEs;
	spf=pass (imf04.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.29 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764780233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxrvBXGpA1Q+nnlGY6f0s+0LHNsraSWWBUdSBcXFF08=;
	b=K3X25ldcfTYEBQHxLjQ/DmYpO3X8kNu4k1kHiTP3By1lOGfblxmJ+/QNTw9NAeKzxaQJFR
	cePqlXUAeIIki5CVMw0+l7/zjp/IRoD6L1qj5KWoz3XTjAEn2fev3yciyKcklJ2IbJnY9I
	p45go+1U2xYhQRFu5AIlvOLTvYtz8NQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764780233; a=rsa-sha256;
	cv=none;
	b=sS9I8HmEWbLwXxkFrbu61mDBVDWbv17NkHOKOwkcc6KxBy3PrN1aGX6ZacYzNuF+TdZ8fx
	2cdWwequ1fDpBjjGlg2kbRe1GrIkYdy3Tt5Hck0Jlej3DjV6oACblz0QolcRDtrrGNCGYY
	b4WalJPQ58kDSMIltTD2e8jrYPt7Qis=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=ChzS+WEs;
	spf=pass (imf04.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.29 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764780229; x=1765039429;
	bh=nxrvBXGpA1Q+nnlGY6f0s+0LHNsraSWWBUdSBcXFF08=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ChzS+WEsjeMWAL/FoYDDx8ErAUE1ldyouBZhZrMc58wd/Wb4ajYmXBHagzFO1uJWR
	 yBsOF7rUr7qHvjP/Cmu7iJyqfrl4VeW1O6XfEIuY92AtHWK4p+apC3NOTLchtUsG9r
	 IpvoR1lHrM8kKfm10b9mZbwaw6BudNM/yH1N0kpnzwBtdSxMsM8A1CGMU2cceRRDTT
	 zfs6HhYi3HYFAf29GkWCDS7nDiDWB3LTRBr3n3hQGfGCdI7mET+u1qWgxIbZAiFYGj
	 arZx81GcvT/9nDR1Z9Nxm9NZ9TyJEo5YFcqptxFOTr6uyzCx1scz7coSnQ3oo9E89J
	 xDFqpt2Dj2KyQ==
Date: Wed, 03 Dec 2025 16:43:43 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] kasan: Refactor pcpu kasan vmalloc unpoison
Message-ID: <bi7dif47rpmdymfu3fkuz432vv5p2tmabk5snpqo27f5fitq5x@xap7rkeqejrj>
In-Reply-To: <CA+fCnZcNoLERGmjyVV=ykD62hPRkPua4AqKE083BBm6OHmGtPw@mail.gmail.com>
References: <cover.1764685296.git.m.wieczorretman@pm.me> <3907c330d802e5b86bfe003485220de972aaac18.1764685296.git.m.wieczorretman@pm.me> <CA+fCnZcNoLERGmjyVV=ykD62hPRkPua4AqKE083BBm6OHmGtPw@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 0dd43d3234ed39ac31442c89bad75ed3613a9e3d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2582A40006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: s5b8sagbq3s5y13q4xo3frb86ywe4dxc
X-HE-Tag: 1764780232-729025
X-HE-Meta: U2FsdGVkX1/ykRrOR/N8wSnTOvvyswh7ETgsO9VFzSk2fvB8trAf0mybcv95lONPUJlEPCWtkNtmkYNlNx2PTKhajkDBY8Ng3s3DZH9RtTaxkFQzGFHFcsuMR5wb4KYLeVUmM/WPqOFfEYWAec6cOje35jhraluk2YS924cmE8pCRiINj+ZpiOAzVxbniGT1EVrPb2TvOW+1XeYN+qkIRhQmz2O6PmvhJgxIMf9XcFgkUTMKCLCYXLZkATqbTy4vZPqqlTjxjIWGgsyx3mkuwXLvdBhqB0O8cV/L3a5haHsI1JgMHbDTlHABDeO8IaLotXVKjc+JFrNQR2sN40Z/9G5Ku2Xy3HXbFmy3ni8lmPmRYWy9NlkBryZdWl2/U6bStPn60EIn9krcyWjtoU2dyC73s0Mj4VNnCsUtV9M2iBE575z+NzSSeABp/DTS8vYEE6F9JOViFsbFcfvyB2rGO457L9/TSHz8sUhEBCD6p4gLhQE4z8T2ldOPD1jgQQL+5Kq5rFLLv8djKiz88uA6yjEA1hPq+6LxLMakD9FDwQL7xebhynR/gd7KoWP7ieRI60PECYggDqiFSbKNQKi00QnGQhDsSO5RdAA8kJCldeboZjpkLXa+nYSzlF+3aqE/FHupst3tElipA00wPYoWd7ZG7e/VJ4Yr4hlA+i2oaN43gq5W6ArpBl3Pxwcepi81fzFPpZq2Dtz9kCvxhwPwm17QsavWt4iT0mzzHdsjfCrpbxN8nXDEH7vF0muIBhI4WwNl3T8KaZ/FnGqeCA3TnDZTeBZ93dUCk9caylYCaITvetJUJfi5vUFbnygMXHIpgEEmONO0dE/I46avSEMPhWWTpg3xQ40DW4KjxO8sIqwnbcDWGDSGbgkjFjsQbk0kslTjwzqfc0Rd0KU2DSgbybPU7AqwvjgeP8Hj8QqLnQlD4hWnJXjuxWOnVHh3FkXGCIJqxaxSj3t0z5M80e0
 MaGGazAH
 woXJSxuXU/i3bqn3gvjK7IDNK1zgHw7UTgfKHhIENcDlPmUc+JHVvQyaAWFazjAtHHNH3gIKgaIQF20at2AddYrfFkQNRrl+J0SIhcKdTYBb9mMuDeE1atVb9CRyylJ/Hj32GS5V+652BCs18G21AYqIiakRadgTOm7remEXpsK5/PdzkgLO/uD5scZ5+Rsm6g0LF+ufwIs82ulJawbJenIs6jUN4rFAYyXoz11ZgR0qfaukDkPGpy9MmtcM2vxfx9NmHLDSu/qF2ReW/YG1bxsYLUIu3M0ilEwK431zvANixUKlNdavV8+lbXEeiDJmRIBoR7vhPeqFstbq+dEF5tjr35fNXtoFsBzzzJog+mgqPbnk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-03 at 16:53:04 +0100, Andrey Konovalov wrote:
>On Tue, Dec 2, 2025 at 3:29=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
...
>> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
>> index d4c14359feaf..7884ea7d13f9 100644
>> --- a/mm/kasan/common.c
>> +++ b/mm/kasan/common.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/string.h>
>>  #include <linux/types.h>
>>  #include <linux/bug.h>
>> +#include <linux/vmalloc.h>
>>
>>  #include "kasan.h"
>>  #include "../slab.h"
>> @@ -582,3 +583,19 @@ bool __kasan_check_byte(const void *address, unsign=
ed long ip)
>>         }
>>         return true;
>>  }
>> +
>> +#ifdef CONFIG_KASAN_VMALLOC
>> +void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
>> +                              kasan_vmalloc_flags_t flags)
>
>kasan_unpoison_vmap_areas() needs to be defined in
>inclunde/linux/kasan.h and call __kasan_unpoison_vmap_areas() when
>kasan_enabled() =3D=3D true, similar to the other wrappers.
>
>And check my comment for patch #2: with that, you should not need to
>add so many new __helpers: just __kasan_unpoison_vmalloc and
>__kasan_unpoison_vmap_areas should suffice.

Okay, I think I see what you mean. I was trying to avoid using
__kasan_unpoison_vmalloc() here so that it compiled properly, but that
was before I added the ifdef guard. Now there is not reason not to use
it here.

I'll make the changes you mentioned.

Kind regards
Maciej Wiecz=C3=B3r-Retman

>
>> +{
>> +       unsigned long size;
>> +       void *addr;
>> +       int area;
>> +
>> +       for (area =3D 0 ; area < nr_vms ; area++) {
>> +               size =3D vms[area]->size;
>> +               addr =3D vms[area]->addr;
>> +               vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, si=
ze, flags);
>> +       }
>> +}
>> +#endif



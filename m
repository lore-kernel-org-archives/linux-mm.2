Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E751E94603
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 21:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F9F6B0088; Mon,  9 Feb 2026 16:31:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6E56B0096; Mon,  9 Feb 2026 16:31:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1366B0098; Mon,  9 Feb 2026 16:31:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6758F6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:31:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E774B7FC7
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:31:09 +0000 (UTC)
X-FDA: 84426213858.12.BCAE4CC
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id DDBE540011
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:31:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=urnt54EW;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770672666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0AvKEQHpnF67TyP/4JPdmnd+xlqI7vmxwxbGw1qfIo=;
	b=RxoyappPmLdvj0IUmzXORc7jV37PCikiCzJz1vYLUxuAuOdqhjT8cdCKhi1/l17php10T3
	fWqluLARdqjy/OewlMmiGS6iUUBUMc8143dvVze8SCcUr0fcJe0ZxXr/nmHwj1kVui3vea
	jPCWqy6gcH7UOYS8knaipiUYz8kmg0E=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=urnt54EW;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770672666; a=rsa-sha256;
	cv=pass;
	b=VF+IMBTtEoLr1jgrAuDS0ycSaNDPu8drVuZTC/n97CK6AW+buA3monTi6AtfNNCC3SFMmx
	foEhrEJGKNE4tlYVOSgVsnVovnTZLECtH99cDXJEL17t0zYGh6SdaXi80W8cV4KalVQ2E4
	wpS5MX3zBMZjgNEWO/9Qopo7Ayh8fsE=
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-94aaa5d3bfcso1544288241.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 13:31:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770672665; cv=none;
        d=google.com; s=arc-20240605;
        b=eLnoLZStOavBhvCGglD9Ospz9B0K0ya3Zda4/yT045+nkz71FPdOZjQym2fOBbIfTv
         /fQiiCD75erbqnmmvI1KRweB8w0cQf75J0VMqoiwRrwA4DTxx7MpVoNJQIILCIu1ogcm
         kkUsOBTZmygflk2VB+PkFzd5a4CFEjvYPbIyyJdN1xGfS6PEz6yUa0TFmgzJ7lJDK0hL
         XhJs3FBwRFjsEtATXys18XrcG8i2KVzOnnXQuE3e1KtB/9bw8odJKpOOeLlZ+aLJTex/
         Uswm8Ae1RWQXB3H7eCbOJhUWhzp2k4KT92U3mYaOvnh+q3W7LmNMii2/OfUGKO5msITj
         DPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=q0AvKEQHpnF67TyP/4JPdmnd+xlqI7vmxwxbGw1qfIo=;
        fh=TOjVlyxQXSihK/2oj4RP7dh13y/rebG/eqJ/VLF904g=;
        b=MB7mHqKMha8kFGtUjrH0OugBkBUCBruLQhUElOIkj7FAA6yYbiUFQUGFI2bGCq4u2a
         qwDSVQOPaxn1UjIB6WE5zGXFGF/WgwioIg4C1sKCEpuajXNanVpd8d6a8vlI2Iv6DsvG
         576T1jsC7zh1Fybv3Dw0+WeZZEODcZUlb+ydPMmYV4viVGbfFMocDvf4kMrnSvGYcVrX
         BGplfXFerpo2ZsVooSd9LAHCcggWX++u3NLrH2MGolu77wIL3gYxcGvcp5obIQRzSV4q
         2oe9VQlLWGfK/LYqayuQ8JzN7aVC0hu9sGYcd5c/P0SbTdv82m8g3pT+VjiXlraT/2DU
         j4Og==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770672665; x=1771277465; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q0AvKEQHpnF67TyP/4JPdmnd+xlqI7vmxwxbGw1qfIo=;
        b=urnt54EWYFURiL1R0e4HHg+RCip7qqFhVS5YzquRhwrZ/FO4m3b4n9MdLCyftCGPhR
         5ZLk3xG0Svl8RPe6FJ35c0UMdsddTTuBsNgC0m2HVh80+xCmljWIhKAIu0YvVr4DOSNB
         Sp5W7/YNec3wwplORdWbmjtdl/sm2VwxibyZ7pMrnfA4ETnnM1RVdKTHuNRh9/Sz0OVg
         7MZHZluCc8iMj1Zfg0LB7hGWS9VvHfzgmP+UTsRetUDUzvKbUYaQdNCVAgQZvp0SSCAm
         L4HwUZfr4uQKwS8YgYRRjcKCpqazNPOaUxeKX4UbioL+iAtKAxNqFUOsWUclCzxOeeCP
         Od9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770672665; x=1771277465;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q0AvKEQHpnF67TyP/4JPdmnd+xlqI7vmxwxbGw1qfIo=;
        b=oQKptYUmcdxbmEuHYrZ6XcRh2ZyRkV8me9PJhuL2kgnVhfbbJl7J3JrG38iW7E6oXL
         FEEvSzdFxbTMkmEcg8SBbRufRiyzavF04H9nhIWNj4fC7zMU0YXCaQsFEoeG6H8TnDCz
         PAaMqp9FlHguppcHKi38aX7UBmybQxD/keJAid3c4+WnUf3KdX2PJkRqOdv+iGy/Lrnf
         0z+/hHaGRNwT5k82qudQiIE73/uMiHD9Iyrx631iFKv0XP0BF5HuANdbxZuBWZCI6cgZ
         M9hef01sNIjIBuYtfQrnLKk5ROBwJSffHfUWjVXsO/hE6D/2VBhV2pi7DeOKhgU1GH9l
         etdw==
X-Forwarded-Encrypted: i=1; AJvYcCWmbiNSIyfeFzot0Okm0hMckoi82vbZ5zXQMX0HhgN4wb3zAcospcO1JbKdfmHp4pT9UvUlW6t3XQ==@kvack.org
X-Gm-Message-State: AOJu0YxYIemq249NQjoOxwFRP0LNCPwwVF957qKCVz4bxbfPgRup9KmZ
	JRjhoeg+4X5yqbGFFOWLoZzassqjb0vt2GpHH99dif44pSsZ3QVn1V/X8ssX7BZ9rqF9YsaM6e4
	Gbh6ccAZsItvryM5rHiCvydvPLH9tkh+Ht9tRafg7
X-Gm-Gg: AZuq6aLKihmx1fwtYX+Jt1xioDR7pSK+I8bPOuOlCYuFtBxrVpb/vFjEUj4yar/N8WP
	D1L3iHqWNhJXlRxl/usmm6rUzYe1/YmmsLh6CgBnTjHgLzFbE4ajU4uw3Z99jVsl0D/g2wCzUAB
	vLdZBso4UUTqxNrCdh4wUxgwi/3ECpFsbrximMJWH5eRLaQOCOrcWCoVp1nlKccIwWRYQgUlRpK
	ymhkpTQqttLZseEtXOikrIri8EuwLPyuiIPPxfBCdZAS05qZYOK9pf1JurGVJV69QuyXb67kPnI
	pyQcq/yALWqoebJ+GqZJ/jGFEw==
X-Received: by 2002:a05:6102:3a0f:b0:5db:e77e:7828 with SMTP id
 ada2fe7eead31-5fae8aa38a4mr3912095137.16.1770672664459; Mon, 09 Feb 2026
 13:31:04 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Feb 2026 13:31:03 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Feb 2026 13:31:03 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
MIME-Version: 1.0
Date: Mon, 9 Feb 2026 13:31:03 -0800
X-Gm-Features: AZwV_QgRwEvDfaK1jCk2MnuIKz01GJiL0sqR53ifx0868omMJyUbolvlsiea6Nw
Message-ID: <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, 
	pbonzini@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DDBE540011
X-Stat-Signature: 6pwik1ngpfqzz5fp77c84n3etkk6zjhu
X-Rspam-User: 
X-HE-Tag: 1770672666-933128
X-HE-Meta: U2FsdGVkX1+2IleQVhB9TQhHd+e2bc8u0H/fCfMDZC6+e4v2e5WJebLqnpqXMVVEkeDMdloWgqC4y8oNV+Lriu2eRQRyXnCUaCIpsSERthvvuLF8rxWt5oGobpCZF0MVwzdm1cfPz3PzOSNx5jl4EJHclRWAc/b2CO7LdASFO9YUKRNOp0byciTQO9qGEUQzUajBBGn30Ncb34CuQzcf0NISinTzIlf1d7nlNvkrnQPIOpInHRfwTaidjUOrU9B6TA+smlsuSHOzzyNybRqBC8JR/JYU6ebJ4clPyEfD26B6zMPEC4lD1VJQFQwBqtmFyPimgQfDmR/ZEZhUH6npD57/KVfeiFNvNfB0UjOI+h0oEDa2umj23ujNVwT2wQf6pfcoS1fDAM1iiF0/3WA38y+E+grOMnRDkyw/UOZpc3nl7Kgd7IsOFi8nhKxrhUCaj0aNdITUH4o5lzWFs/EougOGdoinqTKN0/f8l7WH1wc/siV1jGW930nJG0GduWlPrK8V5oX4wMWHoGlW85pNlt9i9fjp9gx5+7SbRPEE/YlVDrJeyTZg7VcxSpbIUmk0o76TWXQDX//XKB4pYgGHIado/CohE0u5TURTzR+FNdNI5unpFjierJ3O0NHVxsfDKuA98I38LX4vc1BVbUNVc6m1qzG/S03QKbL1hSiLoGWGciF6RPIoh6KogEwHIS+1KtvSyus/WcB8edmE9wHv+DuNpyh19TXAaYBjIZ9gQQ75WTPuaAjKLXccm/VN2wWFIRYcp+RMDOg9qb2UKXf/faLkeg9CazKgcA+lNfebv3PExi+daYHkCSDtOEZqTQLeeCR2UKroiXvI4P+iPwtLpkuTf+fUkoVOkPmh+LIF0RZ7Gj0oeK8tXHVam8Nh4YE1rtS5gsg4bsKFuW1iiJj0tMpLFnHvhjuIFZh7gqb4QuG8Z2SOS6CytNUgp2vU8dOAvpwYmzA8cfyaytqgciS
 PMOTSBRE
 //VrRkaMTqOIo0OKFGYTS5nvB7xyprPed04XmgUv0GIBkfJDmSoQYTvfJPpv9chR7gYiyOIWrS0cj1zyWIbEfeYMoAkxfrgwClHaklcZrPUDcanW26fGhwQ43T6BHQz1fPo6iOe3sYRUCqFUHdV/pA7c7TSPjo9glUukwpCXFcqK4eIqieat+QEjr9Wb4+lSdQ7x/Aj1YWtNBuc4FvVbozrblvzD2uizhUpW7ltxHg5h0d/LvkeDvyCSdaXhGjVD4/Yat4mhjNzQ82PxLEuXWVFJCREFasbqPMHkHS0ZHjW9pLmyAvZfDR33+muQW2On7TJUM9hWX+F50tM83fhqQ3qMGUKaPIcuWm1mAswHiZP0GZ1QTS6q8UPQ51t8qlAkBRAFANasGx77C9SVhIF+0dxUV8zqQM4qtMtJL663DoVP6cE/puu+JR5sqvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 2/9/26 20:45, David Hildenbrand (Arm) wrote:
>> On 2/9/26 19:22, Ackerley Tng wrote:
>>> Deepanshu Kartikey <kartikey406@gmail.com> writes:
>>>
>>>> On Mon, Feb 9, 2026 at 4:12=E2=80=AFPM David Hildenbrand (Arm)
>>>> <david@kernel.org> wrote:
>>>>
>>>> Hi David,
>>>>
>>>> Thanks for the suggestion. I looked into the get_write_access() path.
>>>>
>>>> Both guest_memfd and secretmem use alloc_file_pseudo() which skips
>>>> calling get_write_access(), so i_writecount stays 0. That's why
>>>> file_thp_enabled() sees them as read-only files.
>>>>
>>>> We could add get_write_access() after alloc_file_pseudo() in both, but
>>>> I think that would be a hack rather than a proper fix:
>>>>
>>>> - i_writecount has a specific semantic: tracking how many fds have the
>>>> file open for writing. We'd be bumping it just to influence
>>>> file_thp_enabled() behavior.
>>>>
>>>
>>> I agree re-using i_writecount feels odd since it is abusing the idea of
>>> being written to. I might have misunderstood the full context of
>>> i_writecount though.
>>
>> i_writecount means "the file is open with write access" IIUC. So one can
>> mmap(PROT_WRITE) it etc.
>>
>> And that's kind of the thing: the virtual file is open with write
>> access. That's why I am still wondering whether mimicking that is
>> actually the right fix.
>>
>>>
>>>> - It doesn't express the actual intent. The real issue is that
>>>> CONFIG_READ_ONLY_THP_FOR_FS was never meant for pseudo-filesystem
>>>> backed files.
>>>>
>>>> I think the AS_NO_READ_ONLY_THP_FOR_FS flag you suggested earlier is
>>>> the cleaner approach. It is explicit, has no side effects, and is easy
>>>> to rip out when CONFIG_READ_ONLY_THP_FOR_FS goes away.
>>>>
>>>
>>> I was considering other address space flags and I think the best might
>>> be to make khugepaged respect AS_FOLIO_ORDER_MAX and have somewhere in
>>> __vma_thp_allowable_orders() check the maximum allowed order for the
>>> address space.
>>
>> The thing is that CONFIG_READ_ONLY_THP_FOR_FS explicitly bypasses these
>> folio order checks.

Ah that's true.

>> Changing it would degrade filesystems that do not
>> support large folios yet. IOW, it would be similar to ripping out
>> CONFIG_READ_ONLY_THP_FOR_FS. Which we plan for one of the next releases =
:)
>>
>>>
>>> khugepaged is about consolidating memory to huge pages, so if the
>>> address space doesn't allow a larger folio order, then khugepaged shoul=
d
>>> not operate on that memory.
>>>
>>> The other options are
>>>
>>> + AS_UNEVICTABLE: Sounds like khugepaged should respect AS_UNEVICTABLE,
>>> =C2=A0=C2=A0 but IIUC evictability is more closely related to swapping =
and
>>> =C2=A0=C2=A0 khugepaged might operate on swappable memory?
>> Right, it does not really make sense
>>
>>> + AS_INACCESSIBLE: This is only used by guest_memfd, and is mostly used
>>> =C2=A0=C2=A0 to block migration. khugepaged kind of migrates the memory=
 contents
>>> =C2=A0=C2=A0 too, but someday we want guest_memfd to support migration,=
 and at that
>>> =C2=A0=C2=A0 time we would still want to block khugepaged, so I don't t=
hink we want
>>> =C2=A0=C2=A0 to reuse a flag that couples khugepaged to migration.
>>
>> It could be used at least for the time being and to fix the issue.
>
> mapping_inaccessible(mapping) indeed looks like the easiest fix, given th=
at
> shmem "somehow" works, lol.
>

I could also check shmem, but I'm not sure which conditions to set up
shmem for, since shmem could be used in so many ways. Any suggestions?
Off the top of my head, shmem lots of special-casing in the khugepaged
flow...

> BUT, something just occurred to me.
>
> We added the mc-handling in
>
> commit 98c76c9f1ef7599b39bfd4bd99b8a760d4a8cd3b
> Author: Jiaqi Yan <jiaqiyan@google.com>
> Date:   Wed Mar 29 08:11:19 2023 -0700
>
>      mm/khugepaged: recover from poisoned anonymous memory
>
> ..
>
> So I assume kernels before that would crash when collapsing?
>
> Looking at 5.15.199, it does not contain 98c76c9f1e [1].
>
> So I suspect we need a fix+stable backport.
>
> Who volunteers to try a secretmem reproducer on a stable kernel? :)
>

I could give this a shot. 5.15.199 doesn't have AS_INACCESSIBLE. Should
we backport AS_INACCESSIBLE there or could the fix for 5.15.199 just be
special-casing secretmem like you suggested below?

>
> The following is a bit nasty as well but should do the trick until we rip
> out the CONFIG_READ_ONLY_THP_FOR_FS stuff.
>
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 03886d4ccecc..4ac1cb36b861 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -40,6 +40,7 @@
>   #include <linux/pgalloc.h>
>   #include <linux/pgalloc_tag.h>
>   #include <linux/pagewalk.h>
> +#include <linux/secretmem.h>
>
>   #include <asm/tlb.h>
>   #include "internal.h"
> @@ -94,6 +95,10 @@ static inline bool file_thp_enabled(struct vm_area_str=
uct *vma)
>
>          inode =3D file_inode(vma->vm_file);
>
> +       if (mapping_inaccessible(inode->i_mapping) ||
> +           secretmem_mapping(inode->i_mapping))
> +               return false;
> +

Regarding the degradation of filesystems that don't support large folios
yet: Do you mean having the collapse function respect AS_FOLIO_ORDER_MAX
would disable collapsing for filesystems that actually want pages to be
collapsed, but don't update max folio order and hence appear to not
support large folios yet?

What about a check like this instead

	if (!mapping_large_folio_support())
        	return false;

And then when CONFIG_READ_ONLY_THP_FOR_FS is removed, part of that work
would involve getting filesystems to update AS_FOLIO_ORDER_MAX?

>          return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode)=
;
>   }
>
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree=
/mm/khugepaged.c?h=3Dv5.15.199
>
> --
> Cheers,
>
> David


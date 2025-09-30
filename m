Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E46BCCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 11:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AACE8E0003; Tue, 30 Sep 2025 07:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95BE98E0002; Tue, 30 Sep 2025 07:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A8E8E0003; Tue, 30 Sep 2025 07:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D13D8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:30:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16B0B11AB1B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:30:51 +0000 (UTC)
X-FDA: 83945699502.26.5D8A210
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D3234000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:30:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IF5ht6We;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759231848; a=rsa-sha256;
	cv=none;
	b=VuCLCVMW8imZebdnrK3NheTJklxGLY766DduMvIplNcRbHu7k+PUxuLTSHTGLiSFpVarNe
	W5+VUlIlT8Ug+kFfhvqqsCfaElqj0PLwS2nrQEJ7QZIuOqu4a6gwCSiA8M0FrgChd+j1Gp
	W6CbKTQY/WerZ24f0goLi5IfrreIcFI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IF5ht6We;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759231848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjpJIKEkeLAVBOh01dbuSi//HbjFIpX6T8dNbupqv0s=;
	b=u40Ux32IQevtNJe6jBg6HZYhdVggUzi1O7tKsmK4LdrsYnb1ZID/hyHpt/cw2H4QQ0TrIo
	tvClnn39eg+z/xH+wWeCbvcPU9vFUPbAFbt63R8PWGy/WQd6uH/fXBLMYg4wcR5Dv6hcD8
	00PJUfDm3VHQatgPxO00YW2uJe/taDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759231847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HjpJIKEkeLAVBOh01dbuSi//HbjFIpX6T8dNbupqv0s=;
	b=IF5ht6We429Yr0kN8+v5suiAkjv41ddrjRimZPHV66vQO18WJvSZ7GgO+xzdi51A1Xyl9s
	PD8js1xWmL1q9lN0Tiv1rVQi4QDPO1JRz721A3bpqxZ8zVeUSzv5SPoDFHVsAyeFh2Qjb+
	y7IrAMI1yFBfi3SipMsdRcO1bEeu2F4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-jqXsewfEMPiJESXAqxGhbQ-1; Tue, 30 Sep 2025 07:30:46 -0400
X-MC-Unique: jqXsewfEMPiJESXAqxGhbQ-1
X-Mimecast-MFC-AGG-ID: jqXsewfEMPiJESXAqxGhbQ_1759231845
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b2e6b2bb443so589438266b.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759231845; x=1759836645;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=60uGyvQqOvx3NZbN7PM8fFSOU0EVqBan1owFG0+88fM=;
        b=Nj5wFYfrcfa0Hst+g9NM+CD+ixToia8+hjsO+J/y8cY8+rmZsz3GypsA1IJ5nyz8hV
         vgEoXVzrtfATYYYb1rAafD7jz/GTWn1+2X/DWfVzQJsELV8f2vFT8b0j51cSvsh9F7Ms
         /W/VqA+sfVnagbRvI+A4Oah6GE/BEnbGTXaiWp1n6z1dmCL/ljDHgxUnGDf+E+ZCs0xJ
         mTdlaHH1YTHRZqtWc4LyNAJPeVlC1SGvnfjqfeurmmKkhjAMAIh6JtckZlF18m+eTBSf
         DL0O3NaGBoR0gYbTWhjRUM5KgZlXytIYd3cGTOIxKryDb9a+DTRP7ezH0WFiORXmFKiH
         2n2w==
X-Forwarded-Encrypted: i=1; AJvYcCXKZ5LiqAwVJvp7U2fexqB1eMLA7sC2BYRj+yWshAcnwf65sJXzYXJeCRPRKM2JYKC8Jm75n+JEKg==@kvack.org
X-Gm-Message-State: AOJu0YwGgl99jKSOLexaPJMDs7qDAMcgVtMQeFFLXsuYHlP4lFYI6Uq8
	zMcboU+PmLf02j6Z/mOcOVqSKaZRQEtbG5RotPQBq3/UMUfPUSAVYw6mZhE8k4zFAOZvSv/a9sW
	b+1njLZ/Qw/EXZiSuOTAlSAX0O4e83r+6B3XHRn3UetPNV3ASmN68
X-Gm-Gg: ASbGncsrvoRAWzxDehXpTBDknYHd8G9aOFSY2vgzENVHZDOlPIrRM9foxEm8N5a052l
	oNNwmWx04uxgQ7ypDSXlCsotqom11Vkpc0pH7JzOQBtGEsUWdzLBCufCqFnqSkpq3BdKwUvEPuo
	mgqhUNUpaHRBKjtT+3qXn3ed0CJTqY7gqVRyD7gWdp+e2utJT9s6A54mnzUuLNRCchhGufe3UR4
	6HYPJFKNc3ZyRGAgZLS+Bb8GUzOwMDrx8jSuouBkK328IY3SKhxYrgAa5QCdvbGz252zZXhEe/k
	UHnQisfm9a1zCJPIKRc+F2uL6Hi0Xi2iu35CBIPbmGBylTjjrrgZHSyUWK7duOcCYsj98Q==
X-Received: by 2002:a17:907:94cf:b0:b3d:73e1:d810 with SMTP id a640c23a62f3a-b3d73e1ef38mr857566166b.49.1759231844933;
        Tue, 30 Sep 2025 04:30:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoB1+OY95A0NTLqmIVmGw9vxLbsBNmzGnI34+lOhNkGW9jiRWgh55f3njKeLEh37AJ/qzJWA==
X-Received: by 2002:a17:907:94cf:b0:b3d:73e1:d810 with SMTP id a640c23a62f3a-b3d73e1ef38mr857561366b.49.1759231844384;
        Tue, 30 Sep 2025 04:30:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b40ac59a4b5sm278533166b.22.2025.09.30.04.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 04:30:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id B956E2777F9; Tue, 30 Sep 2025 13:30:42 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>, Mina Almasry <almasrymina@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Jakub Kicinski
 <kuba@kernel.org>, Helge Deller <deller@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Simon Horman
 <horms@kernel.org>, linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] page_pool: Fix PP_MAGIC_MASK to avoid crashing on
 some 32-bit arches
In-Reply-To: <0dc3f975-c769-4a78-9211-80869509cfd2@redhat.com>
References: <20250926113841.376461-1-toke@redhat.com>
 <CAHS8izMsRq4tfx8603R3HLKPYGqEsLqvPH8qfENFnzeB5Ja8AA@mail.gmail.com>
 <873484o02h.fsf@toke.dk> <0dc3f975-c769-4a78-9211-80869509cfd2@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 30 Sep 2025 13:30:42 +0200
Message-ID: <87ms6cmb31.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _XTIN3397jmYejbRpRzNpfypOvqCEqqdauIgF6-YpWQ_1759231845
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9D3234000B
X-Stat-Signature: 9c7pxhdju76ipwixcjrnomzaozsbc181
X-Rspam-User: 
X-HE-Tag: 1759231848-309571
X-HE-Meta: U2FsdGVkX18Qb77H/99m3Td1XoqZ2wHJvUsWC9ziFxO0gsAFhU+aW4fXYcYkMkvW6ZKUzCZ3yGAj29b44Urd/pa2nrGBerA5W31KyPItbtsXw6dVy16cBICpJWiFck5LNBQ0L2NXdGR3cHXR/UDRe1BsHb1L/s09WVRW9is0p084/P42Qak8eJnKwFHJh8HLW/k90aONDrMW1Mjn9XzveapFhxYgM9qtsAwfDt0BHE0gjPAMiE78L3wW5aaDiRr4l6DvK9XlQ0znV9be0w4nlT1ewM0PdNUeuxap7f/aTvZKD6gi4NUJIhdYYkooKdaHb4YEm4FuFG8jFJOzBOtW4s5XydzCdfr5rGG7H2ahMRNF9BakZ3GEPj2iycsQd8uK7E+hml0XcsGFyflyqzdp22xsCUfpoyH2cdp/M74RUX7YnItcauhksU3vIriuQDYyOud+ZRvuI1weFQpeMDWVsurUicSZaOqvKF+/LenxrxaBuC2MCShYyhQWtIkME7BAiIz7pnQxPnlIcmifPcK8nISumk5jNtnM5MvZzSjXW2j7jJu9629J4XYGOhXwCp/HnSFtfRejyF88cScBtVJ2Pdw3IHcCv3RiAfxrNaU2N757geBNhgHaKxYIrwaWTOeWeqFtnqR4lSHcNCp1+Go46jbJP0EIDhuH92Ed36VyODElEB/AQ5pkJPuLRj9yG5uywuduSb1Qoxt6OuHChZ5fMsAkGFvp1cNfqG3BWlbqG2dmg5thasXh/AVFDFivCiI0kYBfZCbQf+tKu+Jflk5J//QzzV9vGuqMH3rKszdB4AtAGrj4TrDsQuENprjCLWoqmmUJk9jGWhBidALqsgjhSBpTbexg4S058FbOBd/Aws3lOR6DhScx1g2NNReu165Alpo22wl9GbVsxZMhi97oh9036bStouc3beh8wCvHEcQjc/28qF6i7wzQWhFG/WzLlShtYWqzd7CARPV2tCJ
 ZEYBmOE+
 1eKHQa8rwq+uH2IGZAktXIjRqFEBuWdtWi9jbI9DEQhXEecjwRJYaQ6BqJQAxah3hDYUW61jenb4InUjpUV+G/iG1rUUUoy21J/3txh+S/nlIgpGcqgY1rz/U6cpvU7Kf9WzDL04rC4S9KZGUxXJtZJ36z8nVlxq6uuH65394ifZGKOTSHr5KYDaF6sZA4MaNKYdqlzCBUXHw1kfX/kSQnkQofvUZpWOWlqQxhBOvmcm1K4LfgE5dZ48nQqmjUtT2Y++DIoRA/DrKIYjyykUTHaMdYBtCVXSmUtC9KEthh0LRVDCFHTgj0Hwq/Vn9+FhYrmj5gZrbeZ8EWL8tLifHCTQWPVeY0opXR7KAsEhCTvIy9jcGptBmM4yiqxNMkbkRAeSV+t5i91dtWRX8Le8vQJhQS57Cv49jdNLwAvHBtb+60xscL1JAJiXe2ZsV6Rv4RoDKcKCaM20wvLNZIMHVHZqo0d4a6sTZVv1H1LHuAn6kpxo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Paolo Abeni <pabeni@redhat.com> writes:

> On 9/30/25 9:45 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Mina Almasry <almasrymina@google.com> writes:
>>> On Fri, Sep 26, 2025 at 4:40=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgense=
n <toke@redhat.com> wrote:
>>>>
>>>> Helge reported that the introduction of PP_MAGIC_MASK let to crashes o=
n
>>>> boot on his 32-bit parisc machine. The cause of this is the mask is se=
t
>>>> too wide, so the page_pool_page_is_pp() incurs false positives which
>>>> crashes the machine.
>>>>
>>>> Just disabling the check in page_pool_is_pp() will lead to the page_po=
ol
>>>> code itself malfunctioning; so instead of doing this, this patch chang=
es
>>>> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
>>>> pointers for page_pool-tagged pages.
>>>>
>>>> The fix relies on the kernel pointers that alias with the pp_magic fie=
ld
>>>> always being above PAGE_OFFSET. With this assumption, we can use the
>>>> lowest bit of the value of PAGE_OFFSET as the upper bound of the
>>>> PP_DMA_INDEX_MASK, which should avoid the false positives.
>>>>
>>>> Because we cannot rely on PAGE_OFFSET always being a compile-time
>>>> constant, nor on it always being >0, we fall back to disabling the
>>>> dma_index storage when there are no bits available. This leaves us in
>>>> the situation we were in before the patch in the Fixes tag, but only o=
n
>>>> a subset of architecture configurations. This seems to be the best we
>>>> can do until the transition to page types in complete for page_pool
>>>> pages.
>>>>
>>>> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
>>>> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them=
 when destroying the pool")
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>> ---
>>>> Sorry for the delay on getting this out. I have only compile-tested it=
,
>>>> since I don't have any hardware that triggers the original bug. Helge,=
 I'm
>>>> hoping you can take it for a spin?
>>>>
>>>>  include/linux/mm.h   | 18 +++++------
>>>>  net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++-------------=
-
>>>>  2 files changed, 62 insertions(+), 32 deletions(-)
>>>>
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index 1ae97a0b8ec7..28541cb40f69 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct task_=
struct *t, unsigned long status);
>>>>   * since this value becomes part of PP_SIGNATURE; meaning we can just=
 use the
>>>>   * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA=
), and the
>>>>   * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTE=
R_DELTA is
>>>> - * 0, we make sure that we leave the two topmost bits empty, as that =
guarantees
>>>> - * we won't mistake a valid kernel pointer for a value we set, regard=
less of the
>>>> - * VMSPLIT setting.
>>>> + * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that va=
lue is
>>>> + * known at compile-time.
>>>>   *
>>>> - * Altogether, this means that the number of bits available is constr=
ained by
>>>> - * the size of an unsigned long (at the upper end, subtracting two bi=
ts per the
>>>> - * above), and the definition of PP_SIGNATURE (with or without
>>>> - * POISON_POINTER_DELTA).
>>>> + * If the value of PAGE_OFFSET is not known at compile time, or if it=
 is too
>>>> + * small to leave some bits available above PP_SIGNATURE, we define t=
he number
>>>> + * of bits to be 0, which turns off the DMA index tracking altogether=
 (see
>>>> + * page_pool_register_dma_index()).
>>>>   */
>>>>  #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_D=
ELTA))
>>>>  #if POISON_POINTER_DELTA > 0
>>>> @@ -4175,8 +4174,9 @@ int arch_lock_shadow_stack_status(struct task_st=
ruct *t, unsigned long status);
>>>>   */
>>>>  #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DM=
A_INDEX_SHIFT)
>>>>  #else
>>>> -/* Always leave out the topmost two; see above. */
>>>> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT =
- 2)
>>>> +/* Constrain to the lowest bit of PAGE_OFFSET if known; see above. */
>>>> +#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && PAGE=
_OFFSET > PP_SIGNATURE) ? \
>>>> +                             MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDE=
X_SHIFT) : 0)
>>>
>>> Do you have to watch out for an underflow of __ffs(PAGE_OFFSET) -
>>> PP_DMA_INDEX_SHIFT (at which point we'll presumably use 32 here
>>> instead of the expected 0)? Or is that guaranteed to be positive for
>>> some reason I'm not immediately grasping.
>>=20
>> That's what the 'PAGE_OFFSET > PP_SIGNATURE' in the ternary operator is
>> for. I'm assuming that PAGE_OFFSET is always a "round" number (e.g.,
>> 0xc0000000), in which case that condition should be sufficient, no?
>
> IDK if such assumption is obviously true. I think it would be safer to
> somehow express it with a build time constraint.

Alright, I'll respin and constrain it further.

-Toke



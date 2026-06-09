Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2815CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06DA66B00AB; Tue,  9 Jun 2026 10:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045EB6B00AC; Tue,  9 Jun 2026 10:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D776B00AD; Tue,  9 Jun 2026 10:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC4E46B00AB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:41:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C01D1405C7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:41:17 +0000 (UTC)
X-FDA: 84860636994.25.257A544
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE07D1C000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:41:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a4DzZPZh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781016075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cs6tgEzoVHYpv7k21ybqH49sF46z7hX0J0ePiR98zrw=;
	b=XrtPEEYhJHqYTp8K6zhIH5m9jiBGlZswGltQeSTN077HojZj4Ak6iSZbot9BaHrUI9XdZl
	TVzbrNzBhUgJdkjj988O3+hVqWWY5T1Z8z765MCfBQ+lYK/xXYv8iqqcQiEGiMufRTSm2P
	bRhsutb+XylbBMkp14iC3y6sImN6PUE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a4DzZPZh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781016075;
	b=1+nAbP1P4v0NN6Qg1rnziJFZMPHAS9m2DxUtM5Owt9fgNJSX2xuWRYIHqLVdpwqrbIlEG5
	4L6AUOML7vMk9/7Tr0HtCz7Ddxg0LZifHdikYXz1konR15vjQrhR/5m+YxxCSEPczz2OOf
	QGB93p2Y6RV3GqMATfIlcuzaR9i20Xs=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5177d1ff061so2300861cf.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 07:41:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781016075; cv=none;
        d=google.com; s=arc-20240605;
        b=JRTMrWkbd9MQYu+09Luxwp/AqlWdojp6dUniuYMA7YyjL+jjBb+zo8gAMxm0DM7IxL
         oHcJuQzj7IxlpM66hz+JxvMt0Z6sQKo8V0Rp9x/qIrSMNZNH6/z4wEyhZM7hhBh0O9+u
         MAi7IYsQpU86xR02EXlGqwbpWpxK9O6ougAq5azESkMDEFZOlcNuvIniFQ5zpSC0bh+C
         2M2eHtCvfIi/VI58axhCNFu7GXr7hPMtAlFd3SHE6DZqSrlYWVUaSvZi/ourrgY5DV9/
         KM/IdzydSY5xFjatdULeLa5DKxv6bqls28PRPJzZTiZcSWPrsZV+9iy9ux7hlPteD1nt
         dvKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cs6tgEzoVHYpv7k21ybqH49sF46z7hX0J0ePiR98zrw=;
        fh=pHZi/rsk/GIsBujV5RlZiuFG5tmQz2rm+CUN0sV9mCU=;
        b=fpaTHYWIg1exgSGjc/Q1W1xQG0+fADOkwhHqy33m8CBk+NYQFrdgxPaAjICVh9n7q8
         eTLrmUJUhGq+fUkOfIBmf7+IjYMuW7GUZyDMDikMg2f2J0LetT8xqla1L+pkPmc6YNhq
         0lXQwi5D6Wk1m4wUo0eMqFFxjZPTiowgZYY4Tfj0hScmPEVKl9Dt00nlVqjfZ53XSMxO
         dKiVM0XwBu9teGwAwyApErjIbFEMBATRNIql8tjE4nkvWs4c+NR4YbT8dVpWdHEC/W5f
         ml9pMvWv09QLUeOOYGoAgMQrF6sXcNd1AWebLuqG8QTsB8MpBWN5VAaF7ByAWxBm3gjV
         NJ6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781016075; x=1781620875; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cs6tgEzoVHYpv7k21ybqH49sF46z7hX0J0ePiR98zrw=;
        b=a4DzZPZhYJKqLuyy4JKlnKCMtu70I/M9ScHXENca2TIdK5EjsCk9+UZp/WFOKVQp1s
         8NHPJRxWn36StJp6uKICZ+Q9C126mL1koERWPYEh3TqxWmwDfQ7WRUiGIJ+FCf0AkK0H
         pSlXLpScXMhnW3VeMNAUzC2wnZvn8Tye7LyDQC2eOJrzF46fSuuwSVgO6RhTkjDrClbR
         fP+1F0MUFJkDGUc6rLfZsEiXoUBkX6EUeI3MR5flP6ZswLdV2EjRpE7e3kgmX7+6vLi6
         X4jJMRsiyl5NUlELOeuVMBYgRtqymMJ0FxK4hbZbKRyC03UQhti3RXm449tpDIQ+Rv62
         IY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781016075; x=1781620875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cs6tgEzoVHYpv7k21ybqH49sF46z7hX0J0ePiR98zrw=;
        b=YvzvcZXPNjMjEkWCa2YjYmEQypVS/bNVaxMrT1Gq/Ih17x5LVIjdhQHrzTWTgnRNb6
         JI7R5PGOPMM7/5UNGxe1S7OpT7+sSD66LRQQI5e6458mjlemxOU3U4M044QNGP1LuObr
         0PoIHYPA/Y29RpnT0w65vLmfccah2PBrmIMoR//EYmpM+phkXZOusOCrSWZOU5oAqHAx
         y8fM/IkPrkyxAj15iTp3NPmVqob3ztMGJKmcta+ILoObAbnRkGn4YaY5YurFNvrKgSqp
         81f7cM1iffD9ne+XxDXxwIBlciwbyQm+smEh/4OybnXekaD0TANjmlBl2kNzKUTJon4a
         cnIg==
X-Forwarded-Encrypted: i=1; AFNElJ/2u/4w+5N+tUXdnGyU8DX80uBaAEa0JT+lZLDGSc8hBV9mJbIOuLfYZTfTCxs8i1ee2Lrn07hPog==@kvack.org
X-Gm-Message-State: AOJu0YzzGov5SWW5Md7LXeV1isJxYg9VjFtfbXuUTh7+tBDhNolknx9D
	RnU0ABs+h0acGnaGn15toNQb7ykQWszSogRxnT7cgcEfnwuuUMGIoSRskU3IpBn03tDHEs/E38n
	UMa5iZGTn7m92SkpP9NgpEBdHJywfHKnHaGEVqkrc
X-Gm-Gg: Acq92OHpFChIzn5kbM3IYmMPOlnn4k29+FEaNLdkH3wow5ZNmJwiBhPYOYXswuB6n38
	t+3LZhIEJT1XVMayzkuQh8YWCV2Mii+GL6vN84K3ZRQINZHb9XFEn/uo/nyajIiOhpOIBydxD4C
	paCkdoh5X8VEQ/my1AOkX2ij/Co9/+O2UOk2W6N3CZBGZUhmR8dMMTYr9lX6ezird4yfYe0Pkox
	i3mAjkM9sY0h/MqYGtZl94ejXedWRNQ7hgPZjUxAtEn8ffaUHCnRynlNZe6JHIP5MkEWQ3c84cI
	xefQuvCPTpzJMVsZ+s7alJeRsbgkghaYGPgenX1dMQaRwwxE
X-Received: by 2002:a05:622a:aa4a:20b0:517:5ec3:b59c with SMTP id
 d75a77b69052e-51798027065mr33863531cf.2.1781016074112; Tue, 09 Jun 2026
 07:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
 <1ec17313-cd2b-4389-a05d-998757af30b3@linux.dev> <a58e659e-5f54-4511-9a29-dc921002d102@linux.dev>
 <CAJuCfpHtdd=9D68cfRp4HDHHHCZdzTNP_RH9i2D-f9tJXht56A@mail.gmail.com> <ebcbe4a8-127b-4d12-83f1-dec93f0a9c61@linux.dev>
In-Reply-To: <ebcbe4a8-127b-4d12-83f1-dec93f0a9c61@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Jun 2026 07:41:01 -0700
X-Gm-Features: AVVi8Cd8Mw9UFnLHYjZB_VFyvF_jL4KOSZdNa8eQSyaG7dF5Q3xsZiPC-kanxu4
Message-ID: <CAJuCfpGbxO0zu_UAWCYNNv8RHgT=E4AF0tgG-kWoLXECOL3byA@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] alloc_tag: add accuracy based filtering to ioctl
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AE07D1C000E
X-Rspam-User: 
X-Stat-Signature: 8ku6i6tb8afn6uc7dncqnni4musde3y5
X-Rspamd-Server: rspam09
X-HE-Tag: 1781016075-387979
X-HE-Meta: U2FsdGVkX19ILnXIT6lx+Gzvs6XbCVLnbuHQ63YgFq/cDVfdDgyyGA1dtYHTy/F4vc4vZgY8O9fe//TPjK1D8QWhhKAyvFSEE4HzVFADi7jcWLfFEKym/BvVEKZ62eXqEPTtUUHJzaVEolQF15V4wn5Bpj5SvaeBYk3WXnUmJPG96gswHXTxXLzvH2N1UgASS5jq1slmfoREDpFLWuDr14tkGsrgtKgGDXVXyM+HNe0Z3IZoPD8dYRRl52HagpvuQW6zCzMMnlBbrTTiAwd7c4SxGk5725j5O+g8EX2ZF/7P+H4LCPY/lXa/l4IxQYkJk/HWG8sDEOv+2EW+jIz9XrBPvJSlzMAYXW2iINg3GByJfLMJNQjOVo6uodsdR/qStwl2nAmqTmlnc9MHdoYJaAytzFKK4yEGJiCGCbDtv3qgUgyY25FLtUlB5TpWtfGqky5SOCh0iWI9fniffr/PbkmWcNFBfYIOq7r5tfRM+AJpNz3OXKUPuK9HBpkka+jhKVGXjJlZjrf7wMyclfzQSVKcw/1mLLDNjREl6+WhWSYVkbNVrzYz1qYAqLqfeLFk/NG+nHNHr5bw0LlvwIq3sFu07GauHnh/6eOorwjkURiBIBhRHPKdsl09YUjzJeZgQ+kd7xw3o0Sf0tyhLWmJ3osKD5RRBAjNtiudLgpSjr9yjcVlcMsSn2LP5AsUY76weZvKxQQ9j1Ikb5HmtQ7R5t8LgA07o1fKSM8QF1v/9ZDBlMiOLX1VhWgLLuvy47U8uchgq3j7kVyDXjlsUxEWy1tlj38eXnKMLTD/Aux7jcmgP5YH8CKCwpgZXSSunXc1URjGUHnYleEDAxPKLd3FpDh0ZhLLHdMGnLj0AXuW4egAlVk1fr9e5IjTrtbmI31kBFqHKYIPbq94B3c8xT9cstmRZr1/0sLmRvhIOYp3ncIZ8MQ9xBylkPKLV1YEi0PHzn2el6SPNV2p3WOvWkq
 qvJF0Fp2
 eu1dgvvgN05eRCd4ZhcrR+OiDTPGiFulV+nO3FR2yzw4jKGYYDLm4vHNlogvetc9AEfcPpFZ1eUNDV67VpJge0sji8kBnelhnxjm29oORMBfGu14nRfNduLpyN6SfVs/TyWttJUOTR/WlY/i8mB7M3F78OSrhdpxrB5fxXHjBTP6miok7mtnFmzxzb8WVx9f9Wa+2xD4GCMpXglXW/A/6QwslsMf2iXnnynj0seaZCRA0cOrCrmUnF0Bz/JwlPYyJnRJEgtH6q0bE51Z2H8Au/iuA9vP6viRdFfEs9us5canoqiSm0THBEDw9zIVMHvjY71wEW9xLIa8JJo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 6:26=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> On 2026/6/9 04:55, Suren Baghdasaryan wrote:
> > On Mon, Jun 8, 2026 at 1:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >>
> >> On 2026/6/8 14:22, Hao Ge wrote:
> >>> Hi Abhishek
> >>>
> >>>
> >>> On 2026/6/6 07:36, Abhishek Bapat wrote:
> >>>> Extend the allocinfo filtering mechanism to allow users to filter ta=
gs
> >>>> based on their accuracy.
> >>>>
> >>>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> >>>> ---
> >>>>    include/uapi/linux/alloc_tag.h | 3 +++
> >>>>    lib/alloc_tag.c                | 8 ++++++++
> >>>>    2 files changed, 11 insertions(+)
> >>>>
> >>>> diff --git a/include/uapi/linux/alloc_tag.h
> >>>> b/include/uapi/linux/alloc_tag.h
> >>>> index 0e648192df4d..42445bdb11c5 100644
> >>>> --- a/include/uapi/linux/alloc_tag.h
> >>>> +++ b/include/uapi/linux/alloc_tag.h
> >>>> @@ -20,6 +20,7 @@ struct allocinfo_tag {
> >>>>        char function[ALLOCINFO_STR_SIZE];
> >>>>        char filename[ALLOCINFO_STR_SIZE];
> >>>>        __u64 lineno;
> >>>> +    __u64 inaccurate;
> >>>
> >>> I was wondering if it would make sense to define inaccurate as a flag=
s
> >>> field
> >>>
> >>> (e.g. __u64 flags with ALLOCINFO_TAG_F_INACCURATE (1 <<0)),
> >>>
> >>> so that only bit 0 is used today and the upper bits are reserved for
> >>> future use,
> >>>
> >>> aligning with current kernel codebase.
> >>>
> >>> This design also allows for better extensibility if we need to
> >>>
> >>> add new flags for any reason in the future.
> >>>
> >>> We also need to add flag validity checks if we go this route.
> >>>
> >> And I've reviewed the issue reported by Sashiko, and I think it's vali=
d.
> >>
> >> When we expand the allocinfo_tag_data structure
> >>
> >> struct allocinfo_tag_data{
> >>
> >>       char modname[64];
> >>
> >>       char function[64];
> >>
> >>       char filename[64];
> >>
> >>       __u64 lineno;
> >>
> >>       __u64 inaccurate;
> >>
> >>       __u64 bytes;
> >>
> >>       __u64 calls;
> >>
> >>       __u8 accurate;
> >>     /* padding */
> >>
> >> }
> >>
> >> I think user space may see two fields related to inaccuracy.
> > Yes but one field (inside allocinfo_tag) is the input parameter which
> > user provides to specify the filtering criteria and the other is the
> > returned tag information. It's similar to any other tag attribute
> > which you can be included in the filters.
> >
> >> How do you like these modifications?
> >>
> >>
> >> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc=
_tag.h
> >> --- a/include/uapi/linux/alloc_tag.h
> >> +++ b/include/uapi/linux/alloc_tag.h
> >> @@ -20,7 +20,6 @@ struct allocinfo_tag {
> >>        char function[ALLOCINFO_STR_SIZE];
> >>        char filename[ALLOCINFO_STR_SIZE];
> >>        __u64 lineno;
> >> -    __u64 inaccurate;
> >>    };
> >>
> >>    /* The alignment ensures 32-bit compatible interfaces are not broke=
n */
> >> @@ -40,7 +39,7 @@ enum {
> >>        ALLOCINFO_FILTER_FUNCTION,
> >>        ALLOCINFO_FILTER_FILENAME,
> >>        ALLOCINFO_FILTER_LINENO,
> >> -    ALLOCINFO_FILTER_INACCURATE,
> >> +    ALLOCINFO_FILTER_FLAGS,
> >>        ALLOCINFO_FILTER_MIN_SIZE,
> >>        ALLOCINFO_FILTER_MAX_SIZE,
> >>        __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> >> @@ -50,16 +49,20 @@ enum {
> >>    #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
> >> ALLOCINFO_FILTER_FUNCTION)
> >>    #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
> >> ALLOCINFO_FILTER_FILENAME)
> >>    #define ALLOCINFO_FILTER_MASK_LINENO        (1 << ALLOCINFO_FILTER_=
LINENO)
> >> -#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
> >> ALLOCINFO_FILTER_INACCURATE)
> >> +#define ALLOCINFO_FILTER_MASK_FLAGS        (1 << ALLOCINFO_FILTER_FLA=
GS)
> >>    #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
> >> ALLOCINFO_FILTER_MIN_SIZE)
> >>    #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
> >> ALLOCINFO_FILTER_MAX_SIZE)
> >>
> >>    #define ALLOCINFO_FILTER_MASKS \
> >>        ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> >>
> >> +#define ALLOCINFO_FILTER_F_INACCURATE    (1ULL << 0)
> >> +#define ALLOCINFO_FILTER_FLAGS_ALL ALLOCINFO_FILTER_F_INACCURATE
> >> +
> >>    struct allocinfo_filter {
> >>        __u64 mask; /* bitmask of the filter fields used */
> >>        struct allocinfo_tag fields;
> >> +    __u64 flags; /* bitmask of ALLOCINFO_FILTER_F_* */
> >>        __u64 min_size;
> >>        __u64 max_size;
> >>    };
> >> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >> --- a/lib/alloc_tag.c
> >> +++ b/lib/alloc_tag.c
> >> @@ -249,8 +249,6 @@ static bool matches_filter(struct codetag *ct,
> >> struct allocinfo_filter *filter,
> >>                   struct alloc_tag_counters *counters,
> >>                   bool *fetched_counters)
> >>    {
> >> -    bool inaccurate;
> >> -
> >>        if (!filter || !filter->mask)
> >>            return true;
> >>
> >> @@ -277,10 +275,11 @@ static bool matches_filter(struct codetag *ct,
> >> struct allocinfo_filter *filter,
> >>            ct->lineno !=3D filter->fields.lineno)
> >>            return false;
> >>
> >> -    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> >> -        inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> >> -        if (inaccurate !=3D !!(filter->fields.inaccurate))
> >> -            return false;
> >> +    if (filter->mask & ALLOCINFO_FILTER_MASK_FLAGS) {
> >> +        if (filter->flags & ALLOCINFO_FILTER_F_INACCURATE) {
> >> +            if (!(ct->flags & CODETAG_FLAG_INACCURATE))
> > How would you filter records which have only accurate data?
>
>
> Sorry, I overlooked this case.
>
> Since allocinfo_tag_data exposes both inaccurate (from allocinfo_tag) and
>
> accurate (from allocinfo_counter), userspace developers might mistakenly
> read
>
> inaccurate instead of accurate when checking accuracy.
>
> How about we add a comment to clarify?
>
> struct allocinfo_tag {
>
>      /* ... */
>
>      __u64 lineno;
>
>      /* filter criteria only; see allocinfo_counter.accurate for actual
> accuracy */
>
>      __u64 inaccurate;

I think we had comments showing which block of parameters are inputs
and which ones are outputs but I'm not opposed to an additional
reminder here.

>
> };
>
>
> LGTM for the rest.
>
>
> Thanks
>
> Best Regards
>
> Hao
>
> > Overall I would prefer ALLOCINFO_FILTER_MASK_INACCURATE rather than
> > ALLOCINFO_FILTER_MASK_FLAGS. The fact that this attribute is a
> > single-bit flag is a technical detail. It's still a tag attribuite
> > like file and module names and IMO deserves its own filter.
> >
> >
> >
> >> +                return false;
> >> +        }
> >>        }
> >>
> >>        if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> >> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> >> @@ -318,6 +317,10 @@ static int allocinfo_ioctl_get_at(struct seq_file
> >> *m, void __user *arg)
> >>        if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> >>            return -EINVAL;
> >>
> >> +    if ((params.filter.mask & ALLOCINFO_FILTER_MASK_FLAGS) &&
> >> +        (params.filter.flags & ~ALLOCINFO_FILTER_FLAGS_ALL))
> >> +        return -EINVAL;
> >> +
> >>        if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> >>            (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> >>            params.filter.min_size > params.filter.max_size)
> >>
> >>
> >> Thanks
> >>
> >> Best Regards
> >>
> >> Hao
> >>
> >>
> >>> Thanks
> >>>
> >>> Best Regards
> >>>
> >>> Hao
> >>>
> >>>
> >>>>    };
> >>>>      /* The alignment ensures 32-bit compatible interfaces are not
> >>>> broken */
> >>>> @@ -39,6 +40,7 @@ enum {
> >>>>        ALLOCINFO_FILTER_FUNCTION,
> >>>>        ALLOCINFO_FILTER_FILENAME,
> >>>>        ALLOCINFO_FILTER_LINENO,
> >>>> +    ALLOCINFO_FILTER_INACCURATE,
> >>>>        ALLOCINFO_FILTER_MIN_SIZE,
> >>>>        ALLOCINFO_FILTER_MAX_SIZE,
> >>>>        __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> >>>> @@ -48,6 +50,7 @@ enum {
> >>>>    #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
> >>>> ALLOCINFO_FILTER_FUNCTION)
> >>>>    #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
> >>>> ALLOCINFO_FILTER_FILENAME)
> >>>>    #define ALLOCINFO_FILTER_MASK_LINENO        (1 <<
> >>>> ALLOCINFO_FILTER_LINENO)
> >>>> +#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
> >>>> ALLOCINFO_FILTER_INACCURATE)
> >>>>    #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
> >>>> ALLOCINFO_FILTER_MIN_SIZE)
> >>>>    #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
> >>>> ALLOCINFO_FILTER_MAX_SIZE)
> >>>>    diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>>> index ddc6946f56ab..cbcd12c4ef9c 100644
> >>>> --- a/lib/alloc_tag.c
> >>>> +++ b/lib/alloc_tag.c
> >>>> @@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct,
> >>>> struct allocinfo_filter *filter,
> >>>>                   struct alloc_tag_counters *counters,
> >>>>                   bool *fetched_counters)
> >>>>    {
> >>>> +    bool inaccurate;
> >>>> +
> >>>>        if (!filter || !filter->mask)
> >>>>            return true;
> >>>>    @@ -275,6 +277,12 @@ static bool matches_filter(struct codetag *c=
t,
> >>>> struct allocinfo_filter *filter,
> >>>>            ct->lineno !=3D filter->fields.lineno)
> >>>>            return false;
> >>>>    +    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> >>>> +        inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> >>>> +        if (inaccurate !=3D !!(filter->fields.inaccurate))
> >>>> +            return false;
> >>>> +    }
> >>>> +
> >>>>        if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> >>>> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> >>>>            if (!*fetched_counters) {
> >>>>                *counters =3D allocinfo_prefetch_counters(ct);


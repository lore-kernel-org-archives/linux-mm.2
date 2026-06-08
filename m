Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB49CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7176B0005; Mon,  8 Jun 2026 16:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8886B0088; Mon,  8 Jun 2026 16:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596A16B0092; Mon,  8 Jun 2026 16:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 448356B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:55:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAF431402E9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:55:53 +0000 (UTC)
X-FDA: 84857952186.10.EEEE46E
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id D30951C0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:55:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TgCG9WG0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAZgpIOhuy89l4nHzFqDDK0sSW6SMmaa0ddVIDTKLoY=;
	b=c1l56FY0y93jhKhJ5lFzXf3PCMUEi5ibrMev/6JR3XkhmmU3tfFORaE6a9YSoFdyCpjAGu
	C7BOGNYPDwMwdhFyBlav9CDQE3tS0aXDKfbRqAHln/PR4/DvD2uRL2mq+hQucGo2lgTlah
	3B5g2ZsnyN/kcxEvIXrXvCjj7UPpLRQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TgCG9WG0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780952152;
	b=IGfEtRz9riSAF6RQX8yUVmZQVGM9UPl5jcWw6uxhCgzIMdMJJeOWpu6Tu36nS6+vmUxsUm
	SkPJV488Lh/Gg6vcBxHQu46qKZrwKl2SuBPjY5/OX0j7N0/mII9aAWh29N8zf+t9HFgKae
	b8XeMb/TqpLFmTE59iHondD8D5tLcFY=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-68bd7ec2371so31828a12.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:55:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780952150; cv=none;
        d=google.com; s=arc-20240605;
        b=dlRTGmKh3UZZMUfWmNaz72p1rstWd0EVSamSkCofXRIm/KeThFY2SMCLvW8NTekkdr
         Em7uY39co6fhGf4D71eS2UpDMdUUJrnIEsGj8SxjWzHr+cLcJIM18/rO8Zx2iwabsNUS
         3ZA8iFPJjj7Kbcnvb95LtbN4XZEWc2nWpN+EhxoY6ggebbuuVUARV3FqQWEnKA+EhvsP
         yA5+udJNekQf27Mlq0pulf9PrzJqtcNvUNfYMdJ5qXDqJ/Lkwq38xz8AdFeASTiCBmxo
         qgcxKYVJ/eFZsCwkIXcQ/UoRAHmBuUz03ydjven5d5MqAYD5Gjl5bJN2VQn70IJDvqRx
         LAMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RAZgpIOhuy89l4nHzFqDDK0sSW6SMmaa0ddVIDTKLoY=;
        fh=T2tCi3ncr7bFqItR+FfPyKrhVDJgHy6d5RR4e1c3xx4=;
        b=TkpgR1uNiI+UVoT/N7LxHNjehHh7lImgv9WfyEsVUAvpEfBKZjEN7IsYSfn/juzsvT
         oinetKEtoDJXlP5DnPIVsmRYBrcgQt5+GquVqkvezhIKnlylaxfc9h0Q0KsJgkOi2heb
         yhjy09OLXn/tBbl1KGvMcYr7ICGPmy0wc3r4gOjvD/T4owes5N3HXTleb3J1AlD1Gg6D
         XTsGLmUNnHPUTNXkfgVrPH43JgnWJ2cOo0IbReYahOrZiEBxogequE3f3iHc2MNoByne
         yNFUchJ1JXkZpmpqlYReYgC2MV08Ik6axAKxgXX8zDpojPJbjpyDsHltyZT5KnDkdkbM
         AG5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780952150; x=1781556950; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RAZgpIOhuy89l4nHzFqDDK0sSW6SMmaa0ddVIDTKLoY=;
        b=TgCG9WG0lXA5v/DMUUaOeuz5rw+C9khlU0G55P4ayp31pnnNtPp1kAjiZiv+hN5wFG
         iQ+mGg1cI63bEjuW9T8CZPriPCaf5N03qn4E4IYPW9EUOSPeHLglakycB5UpDQeUro63
         NOFeT6xpno+Z2sXVybfHOmexKeyoI9k2K8jXKuOicrlULJJZgpg5pApIrcIZ4LpWb6Pv
         6YdvwbYAmYADTl2BGfBSE4B8tzbpxUnti8E8HqYJslkEzuACSF1xtClXDOFSBoBow9Kr
         019istjrNNYaO8GCv9heDy2T+8/Vs08oCoMfAjaBQidR1ery5MjOCTFA/TD8qrTLwYwH
         6BQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780952150; x=1781556950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RAZgpIOhuy89l4nHzFqDDK0sSW6SMmaa0ddVIDTKLoY=;
        b=H4xkWVAlk6QbV2Pdth/H5+vgH+GCkScXlf/VV/nbwym3nkd2KDHsRpUwiy5hxdk8kc
         RyNJs8wlqGC4+1rzFVPA7mDLBhamb/LA3fm5scU+kRN8NbR1hYzM3bJgh3nPMfnN//gr
         X9lgaMPGze+9dJvfVag75x8D29KI1RjtKlLXP6cWEg6Gi2HD/GfU34on4o/qeZSQXI2D
         nU3xl8A/aIhQX2n28a6/8Nv3P62sPxYitNkwb3A/9nQiux0m2jcUeOA1ZAXPsC0YAuWR
         65YLvi+A0hMGO5T91ME2WIGax3xFZFyV+gw8Qe30UH4ALKqGb2NPHTya2J5MiZKdmuty
         2rNA==
X-Forwarded-Encrypted: i=1; AFNElJ9kX8rHMyiLT4oBbbzbH6svh1wuqu8/Ws8Zymy1yVWAp/IKQKrXJB15TQjKilhejOIKzDxu69gnqg==@kvack.org
X-Gm-Message-State: AOJu0YzuBo0tTqWI1h+dGmm8AFGqOtZHXe0Sv0xLVGBTDQOCZEq/l9ZL
	VRdDhVoJsRzHUGQ3osMM5O70sa0rYTUZ1IqkXEDtVRmDMIwSWXvrB4n/Yqwc4tjeUtJTNc52Kry
	cFh0NEhYXOYE6r9ZMFNdXqL/2AdzpXUz/mRsJ/Wzk
X-Gm-Gg: Acq92OFCg74YsENVzWCjMM+32tyV6upgqrEcAZ56sXrarKDdGulUZzdJZ+7y27ZdMmc
	CWcPOnjGcvg02nbM3CQ86hIn6Vwy48Jz4BMQIWkWFKL7DNcjLO6efNSdFXPRFHtIhR8KZsBLjqU
	G5Nn0GTw8bQkbZpi36nTKoIJXGz/pVfgdT0NW8fJCLet2l7+le0DBTTQ8vpl3Beq+sULLZhM731
	ee2N1AWQCr+WE9nvKH6F4Rwpj/Izo820VS1uzXatMcOWJOgLk9V37iMwSalr+yR79eiZWR3+lvz
	ovoUbwZf+KMs4sFU4Xkqvc0AXcU=
X-Received: by 2002:aa7:d952:0:b0:672:117e:55d4 with SMTP id
 4fb4d7f45d1cf-68fe0f40f43mr162696a12.0.1780952149635; Mon, 08 Jun 2026
 13:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
 <1ec17313-cd2b-4389-a05d-998757af30b3@linux.dev> <a58e659e-5f54-4511-9a29-dc921002d102@linux.dev>
In-Reply-To: <a58e659e-5f54-4511-9a29-dc921002d102@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Jun 2026 13:55:37 -0700
X-Gm-Features: AVVi8Cdov9dGMj4FbL-YcJWyyyPjXlU7BsBAN55M7jfwf-TpkziPB4nTd6bIPm0
Message-ID: <CAJuCfpHtdd=9D68cfRp4HDHHHCZdzTNP_RH9i2D-f9tJXht56A@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] alloc_tag: add accuracy based filtering to ioctl
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D30951C0008
X-Stat-Signature: 9tach4n4f9b3jw4st7gzd1od84p467ky
X-HE-Tag: 1780952151-785424
X-HE-Meta: U2FsdGVkX1/aLzXcviN/B4ncTQ0VYglv36KhrrW+yf3Y7PwuyrdwxzC7wQAqp4RdY1JEV+wKwYyCGQjBipuDU13M7ybeueH/1/RaJWKgQWzYy60xZQIth2yms/eegUaEUcRh20nI7axBI6/wLyxGGL5Ud2W44H030Lb49lqC4nfuWeZzKL3nM/31jPD3x5VTyW4PL8pF+lwooZ/f4/OHcYG8ee4+JNQpraHiVkgLCD88Z3BdqQvtjWZK4GoED4PQ4CbKl6Vr6dMnTj9Gwig8CUwxpG2twCmVKEsCVAlAFcpe454U77jqDKz9xX8mg6b/OKjWrg41lPAJzW4Apbef3QvPDZqmJVsYrhu34A6unxRnrzRzw+70T3o1avtNZsVhdmPLbI2ty3NtrzYVP8AyDC3kU6YeAMtAGEwOFWxobamznrmLhdCtOnvPPkswLEYgr4oBiqPxEcb+js0rt/smJGUkxW6L8WhfOGudDGo3i3O8Lamyb6bc6K3PqqQkBQAhlYtv2s9fPRwNqHt7HGb0HXQgYhYpHmV7gr729WK3ded8dvXjsWvFeurOX/TDKYwSqPzbVBH53wnQQ/ItxM8PlpFnRKWkkJ6pPsgXIdkqAUIzwCNVQ1p3RwRkGdlygAhMXcb9EHupqnn5Ec8YJtTTJWKpUSLShEDuFqZtu+3HoEXLG6+ufU6pRb4E2govbX67rn0j7qkl1xuX5q/3TnvTxUI5UpyFt9YREsTs4Owl7WbSxMr8GosUFHZdDoIQMjhPtxeZKqPXfZ/S9aiskm7zOTOR3nmT1l0A+YUWzFvUeOhBkkYLf0OWVvgfEidoVieTIVYdadoSFUst8L2VD+jTWRRohSzqLTzwJdfKPiuyMMhg+pHZ1SY04CcZfIGUgexXxJVGkXrHN3+XUTDoe/WoSSbZm9rbA67yMUTCVXO2RehyH2n0Qf3k1Mcl+B9TUgr24Jj5FPd6dewPYJXBPcP
 DQEDgYKF
 Y0q86phL2nKkpzhCtyC6/5PoLpaQJf7EdCxlFYdrB0xqU/+WXxNG0xPzxiErMDBvEhi/B56uG239/SfmwOGsJH5ociZxX39aZD1H3s3MUs9tWGdo53Xa6jxyJS7yKV+gim0KDY5uIZbn4O9/PaHl3Xl1rmdJBm7PkV4T9tOysGJcC8FrS5EPHcRGSjO4omUt5Q0RL+E4NT0nPd+3bfiqzCZ/TP6noP/9hduvVudIN3z9Q+24+bqkCLg+pRdsCtJ4eFaM/Kz81RaYz06kQpHohjf4daSQTX83ISNBPP2IFdldphHGJkfsMgRgK7A3fUhyxtwGUEMg8BMRz+QA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 1:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/6/8 14:22, Hao Ge wrote:
> > Hi Abhishek
> >
> >
> > On 2026/6/6 07:36, Abhishek Bapat wrote:
> >> Extend the allocinfo filtering mechanism to allow users to filter tags
> >> based on their accuracy.
> >>
> >> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> >> ---
> >>   include/uapi/linux/alloc_tag.h | 3 +++
> >>   lib/alloc_tag.c                | 8 ++++++++
> >>   2 files changed, 11 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/alloc_tag.h
> >> b/include/uapi/linux/alloc_tag.h
> >> index 0e648192df4d..42445bdb11c5 100644
> >> --- a/include/uapi/linux/alloc_tag.h
> >> +++ b/include/uapi/linux/alloc_tag.h
> >> @@ -20,6 +20,7 @@ struct allocinfo_tag {
> >>       char function[ALLOCINFO_STR_SIZE];
> >>       char filename[ALLOCINFO_STR_SIZE];
> >>       __u64 lineno;
> >> +    __u64 inaccurate;
> >
> >
> > I was wondering if it would make sense to define inaccurate as a flags
> > field
> >
> > (e.g. __u64 flags with ALLOCINFO_TAG_F_INACCURATE (1 <<0)),
> >
> > so that only bit 0 is used today and the upper bits are reserved for
> > future use,
> >
> > aligning with current kernel codebase.
> >
> > This design also allows for better extensibility if we need to
> >
> > add new flags for any reason in the future.
> >
> > We also need to add flag validity checks if we go this route.
> >
> And I've reviewed the issue reported by Sashiko, and I think it's valid.
>
> When we expand the allocinfo_tag_data structure
>
> struct allocinfo_tag_data{
>
>      char modname[64];
>
>      char function[64];
>
>      char filename[64];
>
>      __u64 lineno;
>
>      __u64 inaccurate;
>
>      __u64 bytes;
>
>      __u64 calls;
>
>      __u8 accurate;
>    /* padding */
>
> }
>
> I think user space may see two fields related to inaccuracy.

Yes but one field (inside allocinfo_tag) is the input parameter which
user provides to specify the filtering criteria and the other is the
returned tag information. It's similar to any other tag attribute
which you can be included in the filters.

>
> How do you like these modifications?
>
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -20,7 +20,6 @@ struct allocinfo_tag {
>       char function[ALLOCINFO_STR_SIZE];
>       char filename[ALLOCINFO_STR_SIZE];
>       __u64 lineno;
> -    __u64 inaccurate;
>   };
>
>   /* The alignment ensures 32-bit compatible interfaces are not broken */
> @@ -40,7 +39,7 @@ enum {
>       ALLOCINFO_FILTER_FUNCTION,
>       ALLOCINFO_FILTER_FILENAME,
>       ALLOCINFO_FILTER_LINENO,
> -    ALLOCINFO_FILTER_INACCURATE,
> +    ALLOCINFO_FILTER_FLAGS,
>       ALLOCINFO_FILTER_MIN_SIZE,
>       ALLOCINFO_FILTER_MAX_SIZE,
>       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> @@ -50,16 +49,20 @@ enum {
>   #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
> ALLOCINFO_FILTER_FUNCTION)
>   #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
> ALLOCINFO_FILTER_FILENAME)
>   #define ALLOCINFO_FILTER_MASK_LINENO        (1 << ALLOCINFO_FILTER_LINE=
NO)
> -#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
> ALLOCINFO_FILTER_INACCURATE)
> +#define ALLOCINFO_FILTER_MASK_FLAGS        (1 << ALLOCINFO_FILTER_FLAGS)
>   #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
> ALLOCINFO_FILTER_MIN_SIZE)
>   #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
> ALLOCINFO_FILTER_MAX_SIZE)
>
>   #define ALLOCINFO_FILTER_MASKS \
>       ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
>
> +#define ALLOCINFO_FILTER_F_INACCURATE    (1ULL << 0)
> +#define ALLOCINFO_FILTER_FLAGS_ALL ALLOCINFO_FILTER_F_INACCURATE
> +
>   struct allocinfo_filter {
>       __u64 mask; /* bitmask of the filter fields used */
>       struct allocinfo_tag fields;
> +    __u64 flags; /* bitmask of ALLOCINFO_FILTER_F_* */
>       __u64 min_size;
>       __u64 max_size;
>   };
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -249,8 +249,6 @@ static bool matches_filter(struct codetag *ct,
> struct allocinfo_filter *filter,
>                  struct alloc_tag_counters *counters,
>                  bool *fetched_counters)
>   {
> -    bool inaccurate;
> -
>       if (!filter || !filter->mask)
>           return true;
>
> @@ -277,10 +275,11 @@ static bool matches_filter(struct codetag *ct,
> struct allocinfo_filter *filter,
>           ct->lineno !=3D filter->fields.lineno)
>           return false;
>
> -    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> -        inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> -        if (inaccurate !=3D !!(filter->fields.inaccurate))
> -            return false;
> +    if (filter->mask & ALLOCINFO_FILTER_MASK_FLAGS) {
> +        if (filter->flags & ALLOCINFO_FILTER_F_INACCURATE) {
> +            if (!(ct->flags & CODETAG_FLAG_INACCURATE))

How would you filter records which have only accurate data?

Overall I would prefer ALLOCINFO_FILTER_MASK_INACCURATE rather than
ALLOCINFO_FILTER_MASK_FLAGS. The fact that this attribute is a
single-bit flag is a technical detail. It's still a tag attribuite
like file and module names and IMO deserves its own filter.



> +                return false;
> +        }
>       }
>
>       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> @@ -318,6 +317,10 @@ static int allocinfo_ioctl_get_at(struct seq_file
> *m, void __user *arg)
>       if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
>           return -EINVAL;
>
> +    if ((params.filter.mask & ALLOCINFO_FILTER_MASK_FLAGS) &&
> +        (params.filter.flags & ~ALLOCINFO_FILTER_FLAGS_ALL))
> +        return -EINVAL;
> +
>       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
>           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
>           params.filter.min_size > params.filter.max_size)
>
>
> Thanks
>
> Best Regards
>
> Hao
>
>
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
> >
> >>   };
> >>     /* The alignment ensures 32-bit compatible interfaces are not
> >> broken */
> >> @@ -39,6 +40,7 @@ enum {
> >>       ALLOCINFO_FILTER_FUNCTION,
> >>       ALLOCINFO_FILTER_FILENAME,
> >>       ALLOCINFO_FILTER_LINENO,
> >> +    ALLOCINFO_FILTER_INACCURATE,
> >>       ALLOCINFO_FILTER_MIN_SIZE,
> >>       ALLOCINFO_FILTER_MAX_SIZE,
> >>       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> >> @@ -48,6 +50,7 @@ enum {
> >>   #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
> >> ALLOCINFO_FILTER_FUNCTION)
> >>   #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
> >> ALLOCINFO_FILTER_FILENAME)
> >>   #define ALLOCINFO_FILTER_MASK_LINENO        (1 <<
> >> ALLOCINFO_FILTER_LINENO)
> >> +#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
> >> ALLOCINFO_FILTER_INACCURATE)
> >>   #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
> >> ALLOCINFO_FILTER_MIN_SIZE)
> >>   #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
> >> ALLOCINFO_FILTER_MAX_SIZE)
> >>   diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >> index ddc6946f56ab..cbcd12c4ef9c 100644
> >> --- a/lib/alloc_tag.c
> >> +++ b/lib/alloc_tag.c
> >> @@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct,
> >> struct allocinfo_filter *filter,
> >>                  struct alloc_tag_counters *counters,
> >>                  bool *fetched_counters)
> >>   {
> >> +    bool inaccurate;
> >> +
> >>       if (!filter || !filter->mask)
> >>           return true;
> >>   @@ -275,6 +277,12 @@ static bool matches_filter(struct codetag *ct,
> >> struct allocinfo_filter *filter,
> >>           ct->lineno !=3D filter->fields.lineno)
> >>           return false;
> >>   +    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> >> +        inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> >> +        if (inaccurate !=3D !!(filter->fields.inaccurate))
> >> +            return false;
> >> +    }
> >> +
> >>       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
> >> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> >>           if (!*fetched_counters) {
> >>               *counters =3D allocinfo_prefetch_counters(ct);


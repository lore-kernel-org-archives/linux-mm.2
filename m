Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5280B606ACC6
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=aY+TLYR9
Received: by kanga.kvack.org (Postfix)
	id 4EC726B0971; Thu, 22 Oct 2026 11:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3826B0973; Thu, 22 Oct 2026 11:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2E56B0974; Thu, 22 Oct 2026 11:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171FA6B0971
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:26:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A35F7A7069
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:26:55 +0000 (UTC)
X-FDA: 85350639990.27.A0C936C
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id A3C934000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:26:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aY+TLYR9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792682813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKY9lXCqmIHp0E1eSfDqDHg5eGZHzHb0/xVe+f4AVFI=;
	b=4wTV4CmiNV6EX+d5eMjpIZEAqIheP8ETivUAd278ybv4mpQQpcaLt3eKVCSChP/4fsdXlM
	vxwtKs1K4tsDcyfZ5m997aWYD/YdNvdluNt9ed2JTXLI55VhLUBFnKtdkJGfAJrV0Vw+jA
	wYRQtqiqyjsDS32Hnvcaxy3Dypj/e64=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aY+TLYR9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792682813;
	b=KyBG1WbrCX8lTk/IFckPFD12stvTQ9hlSU/HXmPtnYrsImE8ybyEX25MPY2QOiKUAe4CGE
	PbB6hVm5IpqSbsRxOMPdKrRlr5v2D/6vFnamlqiX32bwwqZqmQshgnNFKuJksVWA4XrSZP
	9rgCH65NdRjovD2dRG4ml5w7gEtItJk=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5337fa12431so326851cf.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:26:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792682813; cv=none;
        d=google.com; s=arc-20260327;
        b=n5hFI/bIPyQ3cMfFIEtC5mZktjT/vQ54zc2c2DukU2QQQiZxO6/S1AAIhLKBCmN/qa
         grl6OGDV4S4+EvTt0/LVu15kc7KjGS29pwxjM8cE2IZAswl9R9mXa4KRoURPH4KHUQlA
         U73b1OggaMYruxHussvNAZL0NVhlySDm8ha0Wicujs0LteKazHbA+3X83pepIlSS05n4
         5aIymuip14gFn4phqaUIjg5/FNBX/sHCoDyUrErvg24qDOoNOew4UftF2CM6g6JgKr+B
         kAx4zcHrw4z+xNeiTttiYvI75tP9j+PBYsfhzAXQ2ne2Ojna6jX8y2pFeewAtCXebITU
         M3wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kKY9lXCqmIHp0E1eSfDqDHg5eGZHzHb0/xVe+f4AVFI=;
        fh=RueqDN0icBEGEO3WqktvFnQCzBE4EU/m5KYyAeuuL1M=;
        b=pfQDdVtsc7Fy+zkx4U2FWdHgd5YdSlfAatCCszq92cXxxn620Y/si45aQFv87/6hmj
         gbeOpD1Pg5ZoXSAr5B018MnaSXHt2lqdOAkx9XHJFH/kfEYadHbOVPeUx3l9HhCvcTXT
         HbSEYuZv8xCYJKeRDRtQYju6ja32+3SpDrDFCFc0kCbUAddcWbw2ogxoQIfDBoDC3qbX
         Jv227N7uRCz0GIUWhio6jpw3Do4h4Hu7TSs64ced/9DY+F1b8U9DGXpuYpMVQGW722L4
         cH4X3SuoiXPTnLXgnI7ILR08krtCFiMSYGd+vmEK8fnPliPvlVqWzb94u0KyG9xf2FUf
         DXrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792682813; x=1793287613; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kKY9lXCqmIHp0E1eSfDqDHg5eGZHzHb0/xVe+f4AVFI=;
        b=aY+TLYR95hou1bhBnta0xEn2DzqWD8G7pb9TAN9Qb+DAQJhnaautSenbQG8TpbEU1r
         eVWVZ/VJMJmRbL3MNrjma3SiWrBzlrFMOkZjI6u+I1j6DwcVF2izDbCvT4PY/iE4y4tN
         AIm0o8vk3XtVCS/DxW/2ehItnylnqyNT2fXQJkj0oOY3N82QttAqdxU+6+O7eicGODDo
         qrYhr6q1MNMBwiNCAfXhdM6sxynfjcMKjUmCdPLkIVjSMp+VQZwcW9bH3+PAd4ycgZhH
         imgXsDU20XzRqM8px/fq16dgl5j5Ds2g1fIvh8K04CMHOt5RqIksS4Q8Y+nLeVRdsGQm
         ifWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792682813; x=1793287613;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kKY9lXCqmIHp0E1eSfDqDHg5eGZHzHb0/xVe+f4AVFI=;
        b=zuoTif31nuKD218b/Yp4r8MqIMMzlSNYfd7KKg9hLxay/Pzs8a9fjLoktpcgqXgW8A
         6bnrE9K7pK3g7/0/3eLGJ7BclibroOTaKN5agdctonTqjK5mQncfqAmVT5HANTzyDXnF
         yKPrujxdPtJJjQsvkBw1CLsmyIEX1Gzj7ZPHsRrOkAC9I/038kvlnE4WyjqqiisbGRDj
         gZegN8Sbh4uVPW6eNOEXh6YvzXWFzv2RXuUCWKWanYsQIX/xGFt/Gn6oa6GiiYx7nvG+
         5YJfvbS04l9/zLZNFfiNDBjQpscAXSzoRdiye1p6ziKwhauokdjZ3qPPwg6IuQzyrKS2
         9bRQ==
X-Forwarded-Encrypted: i=1; AKwUvBx70/wkg0UUuYG0YLMbcEW9IMuvnDmzEhZIhDpLkWhv927kpUBv02ioWGnkNtZVjwClK5wdUdSTcA==@kvack.org
X-Gm-Message-State: AFq9FYIJEjjPrFck7BwwlZkbwtMHJT78oclKZk23pxGCsURJp9jvDc2h
	6zmI8PAHX2CHKz0TR3ExZR0WImIfdfxkfpRXKgZqdaMuo3gBgn7BcbkHVC3SDeRk86lnS1ZYb9F
	vMT7G227UnBhFaMH12NXLOvwikhLifYs2/0n+cUUDVlPGIOSPwzsaNA8y
X-Gm-Gg: AYBFou3ubKqUk2339RwQBKaXj6+/GZfH6gsWyNVU9cklRMm0CKoY8iedVuL4wegBfTq
	2kGlDZSGJMHBdASOxdShKgTExNa1gDuFIues7Rys8SvDe9i9KRfJGebEauC+UprM+hKkP1SxS60
	NBH5ge72I3SxfV3xXyKqXWO6Uvu01QsGguc9uxWpqUOv7txk1/XmkoE3FSd0J25uC+4mD7VrEjg
	vfBpHrTPvc48USRDmJ6szrEiwUPIwRGfHHClIZ1+Jh55YJZfKFiRvP/1KxrkLZZVCRtuniI+j4G
	NsmK07nwut+w9neq6jmmODwKISaBAY0wT7YWQE32Ee1UbeE85aEXmkDAYUUkYpVBF7rgsSXFY6k
	u+qPgDVvrwG+b0F3T0C2JFj5h0itkP3z6/ZPJ0x6xttXY/Rozd8+YNjOxjbKfMaum
X-Received: by 2002:a05:622a:e314:10b0:532:a17b:9581 with SMTP id
 d75a77b69052e-536aeaf3b92mr12054111cf.3.1792682812079; Thu, 22 Oct 2026
 08:26:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1792439751.git.abhishekbapat@google.com>
 <9e49a8f68e4e7d25c5a9a73c1926f68e468ef320.1792439751.git.abhishekbapat@google.com>
 <98855929-df9c-4615-84ea-b90acba8c2ae@linux.dev>
In-Reply-To: <98855929-df9c-4615-84ea-b90acba8c2ae@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Oct 2026 15:26:40 +0000
X-Gm-Features: AclHuK98Q_RR2pQhVQuaYAm5_PHt843ZOWGZFsQ6emeYuT-eX4QwHRsne4e1aO0
Message-ID: <CAJuCfpFDT7ZiUaSwcxr5sLNOm7gNr0kibJHzcuMev2fLkJFOMA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] alloc_tag: Extend allocinfo_filter to support
 tracing queries
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A3C934000B
X-Stat-Signature: 9qp1wztnq47rf4gkcq5ny8wcfz9hgpae
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792682813-887226
X-HE-Meta: U2FsdGVkX1/88SHpr3W1MZ1TwxWsSsVj31lG5WqPtfUv6YQHbsDI0/PXoM9Oe11bv8RJzRcMdPfPdNJ1WtyAJ3vX7uHZNlshqP/S7b4CmVd8UQpzjihTBf0yxBs/swdBCM3Aksosv+59BQ99gvgobhscXOaayiCnVnT98JqnZ68+2N5XtG0ivrC+hlWA/cd6KxDjKrvdWYY9QPmrwJNFv4J4dnWHyqkOn6jbBbOaJo/POQliQrxOCxmiak1pYPlXjkGE6DpiL13ezMwoWdyCkQIPVBnIBsIdkhCFnHNbk9FzDNtEoo2JJuJISCR8h6DTcu4cOQnd6lx3HiOz/13kz3ZQ7BtuR0YWOZGXkuw1oc7lY0yagNhhzUFyiNX9fyokSNqzHzvjATpjnc6Kadj9cyrTlG6criXlxcAzed4ZDjIM9NfiuhbgyZ/tFlw3XOMmFPXqIFb4wXwGWQ57V87v733dJ98ev9nRJ1y05D5G/sOsI/f3dYT3UXArx1AgTQPy1vczRFgHQI71ArI+w0DAVHuTSFryMKxKpIJtJ9jm2IRrFQkQhhBN2WAlyE/lw6pkU/+TgxOfqkUR2JmzHxCQGlt0M4DCyaSP+Gi6vUTIo1E6hiYqVK3ReniTmuYUjmn9EcSdazX0K1//rHA+KwCXgnLun4jlLwu1URE7q4o9oWM5iqr3aW8fCDo83talA/g1eyJXOUo4jKzsFDgDrwIEN7vFm/jf/F6rmCDh+WD70AEoSPiD7fnaGk1C2J0ax++YlvkJfZaZGnI1TMuxJ6+xw9Q3J0BcKWHsrSkiyAXpToPlkjlC5AUurFhXGtjELD6iodUkmoxQMFGKfZNxm6SXaLTZGL6awL+BCUz6TKK/mvnH6VD4WiHzCeFYHkLkvM19OcMQK2zstRG+gj+pHfjS4sqbmQUGLI1k1yQM8cWFo9Ga0eYfmEMOPrNPBKEd3VXNf18gwD37TNE2JdIB84R
 LAySS4BD
 v4UlCrP2uF0cGIKs+r3GzAyAr2U44u8VS0/b7+GyMneRGGNRNmiTkhFh64MgQWZgjn87m60lAQO76zTxQz6W53K6j+LyloeMjGb+q/A6szKNACmnYFsAeTvewT+fqStRRBHN78z5gGfq3Kx85BaYfdggwZlfOQqYJPat0dKO1q7CWDAU4jvuTLyg0eNmkiuUEtVFkZVojzLNyAgn8H69n85N+Ns8v5UlTY5yNpmtjTL3+9YH6jpkJxYRWcykXwe+K8rf8znXlkRYdyIFOS44BUXcS+q/ToY/1UYdLUN8Nn+wxJZJgnvqtczPm6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 7:43=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
>
>
> On 2026/10/20 04:00, Abhishek Bapat wrote:
> > Extend the allocinfo filtering mechanism to allow users to filter tags
> > based on their trace state.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > Acked-by: Suren Baghdasaryan <surenb@google.com>
>
> Acked-by: Hao Ge <hao.ge@linux.dev>
>
> > ---
> >  include/uapi/linux/alloc_tag.h | 8 ++++++--
> >  mm/alloc_tag.c                 | 8 ++++++++
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index dafcba2f7e2c..a96054ac2237 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -38,7 +38,8 @@ struct allocinfo_counter {
> >       __u64 bytes;
> >       __u64 calls;
> >       __u8 accurate;
> > -     __u8 pad[7];
> > +     __u8 trace_on;
> > +     __u8 pad[6];
> >  } __attribute__((aligned(8)));
> >
> >  struct allocinfo_tag_data {
> > @@ -54,7 +55,8 @@ enum {
> >       ALLOCINFO_FILTER_INACCURATE,
> >       ALLOCINFO_FILTER_MIN_SIZE,
> >       ALLOCINFO_FILTER_MAX_SIZE,
> > -     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > +     ALLOCINFO_FILTER_TRACE_ON,
> > +     __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_TRACE_ON
> >  };
> >
> >  #define ALLOCINFO_FILTER_MASK_MODNAME                (1 << ALLOCINFO_F=
ILTER_MODNAME)
> > @@ -64,6 +66,7 @@ enum {
> >  #define ALLOCINFO_FILTER_MASK_INACCURATE     (1 << ALLOCINFO_FILTER_IN=
ACCURATE)
> >  #define ALLOCINFO_FILTER_MASK_MIN_SIZE               (1 << ALLOCINFO_F=
ILTER_MIN_SIZE)
> >  #define ALLOCINFO_FILTER_MASK_MAX_SIZE               (1 << ALLOCINFO_F=
ILTER_MAX_SIZE)
> > +#define ALLOCINFO_FILTER_MASK_TRACE_ON               (1 << ALLOCINFO_F=
ILTER_TRACE_ON)
> >
> >  #define ALLOCINFO_FILTER_MASKS \
> >       ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > @@ -75,6 +78,7 @@ struct allocinfo_filter {
> >       __u64 max_size;
> >       /* filter criteria only; see allocinfo_counter.accurate for actua=
l accuracy */
> >       __u64 inaccurate;
> > +     __u64 tracing;
> >  };
> >
> >  struct allocinfo_get_at {
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index 9ff9dd04d692..0d4d267c065f 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -250,6 +250,7 @@ static void allocinfo_to_params(struct codetag *ct,
> >       data->counter.bytes =3D counters->bytes;
> >       data->counter.calls =3D counters->calls;
> >       data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to_alloc_t=
ag(ct));
> > +     data->counter.trace_on =3D alloc_tag_is_traced(ct_to_alloc_tag(ct=
));
> >  }
> >
> >  /*
> > @@ -323,6 +324,13 @@ static bool matches_filter(struct codetag *ct, str=
uct allocinfo_filter *filter,
> >                       return false;
> >       }
> >
> > +     if (filter->mask & ALLOCINFO_FILTER_MASK_TRACE_ON) {
> > +             bool tracing =3D alloc_tag_is_traced(ct_to_alloc_tag(ct))=
;
> > +
> > +             if (tracing !=3D !!(filter->tracing))
>
> I recall Suren had a small nit on this hunk in the previous version.
> I don't see this change here, did I miss something?

Yeah but Abhishek replied to my comment citing similar usage of !! in
other places in this file, so let's keep this consistent.

>
> > +                     return false;
> > +     }
> > +
> >       return true;
> >  }
> >


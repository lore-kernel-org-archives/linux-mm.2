Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A369B109192F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE85A6B04B4; Thu, 19 Mar 2026 19:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98AA6B04B6; Thu, 19 Mar 2026 19:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E056B04B9; Thu, 19 Mar 2026 19:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5E516B04B4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:44:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 516D8BAE8B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:44:21 +0000 (UTC)
X-FDA: 84564443922.24.A74E333
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3CEAF40008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:44:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qq20vhzb;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+uSbuBbEvwoTJfsFA5CUVKHHaR4vM8XqUDpN2lgnG8=;
	b=d+UaTmlfV8bhNb+WctLv3awCi+1wmuLonj74BGsbkQlTYO4Uu8u7H9WA04CBV7ZNkq79M6
	Z8RuhLX4ng0ZjSrZ2KP1oO1T1rejcBGKi96b7owgjDrQzNUtYjdND/X8KeWs/GV3wkodYB
	saUKgwDGy1y75j/aa6Mjr6Lz1q4LAoo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qq20vhzb;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773963859; a=rsa-sha256;
	cv=pass;
	b=QHtnujlHI4pStxYXFtvtVEFZ9LMZFtL04N5XF9tyuWmAr18o4sssWh/lHK4F5vp4Nltkcu
	RLJVzr7/l6ojjPPrGLzX8/MszLh1XDGcCMK8d1CBphyCGOU5onrqc8G978LHYuHJSWd6Ca
	LCLl/SMfr4xOyJ4a7cV2Gsx/HoSKdLE=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6628cc1bd69so2475a12.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:44:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773963858; cv=none;
        d=google.com; s=arc-20240605;
        b=c2WA2ODd5idLDgE9Y1rzgG+Kc6qrX8yfu9mmxWIA3Bn0iluU0Vl6r3GHpXjN9EAZrU
         qBmGDHcERiTqThaghAvst2gPp7WCpx0BbxSK9xLEb5ANumUGKJalQ+o8mZFwB1F0TBNT
         KkLKbA9eJfx64yhU0q1/qwOM8ku3hndR4zC6HMo3jcdKYTLSxLxYOW5JuSBO5XG09yYA
         dhShFY26v0pK69oanW+C8QAxczckvQyntqj2AAP5dDrVSNtUvsXR9WZpjT67FrKRQgIQ
         joGnbvuDfCPNnNNbWIj5S4pgKO9wCGr27MIatbyHOq1SJVOl18Dy8gFDxOToCoW7VYKd
         V0xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o+uSbuBbEvwoTJfsFA5CUVKHHaR4vM8XqUDpN2lgnG8=;
        fh=pQW5Hdjbm2+97BRm9gy2oAmjqIo+Tt/lBHtZeq9HESc=;
        b=HPbRVCXxoZfUInoxLlrcAw0GnEgNCmKEvA3WfCZFLDtiYdkqa0ILqSDpoK6YS3+t9u
         uCHFMXo3ogLiHZ6aEFOY7OQYdk9RbRGDZdNvH+lFJ9T+DhmsXR2/pETtUY/q7JdvNIHv
         GnfNrICVNsg1QQkWr1CBKEJ7twR58VsQdBR9H9PZBC+jKiJ5W8rkXtflF9AqmLq2m0vo
         aW1IZrg6p6HXYYSQlsz9JYk6eFrXGh5wFJuQSv6yYTyIx1gS4m/S7ieZyCNoqqbucTI0
         6KF+odia9yD9CjaVbnCpxmyG+xaYA09YOz45EYbMgXIj7mhRwJG6K9SqAS2blLoxnqcm
         H+rQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963858; x=1774568658; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+uSbuBbEvwoTJfsFA5CUVKHHaR4vM8XqUDpN2lgnG8=;
        b=qq20vhzbwhmkXF5cduo8Nx+wHXQHWA9CcFwoZbZ/AjdeVIOY8xVxBnLidkD/VPJxAs
         WRSlREbGtL8D3hZi+JN1EF9ItbY4ByP4rok5/0LjK4fKZLxtSzABu25YXqCX5LEwq8rb
         EF26e/IutWgKP4wFkIP4uXSJgxJIfeqnyts4mDgSO7EgNy2cTlucaquIOinN+WXw7u6e
         xWa2lLwc4JPl1p0xl6TsKM5Sj0FYqyLkdYEbjmv88GLH9ZGSm+GXwOvZ7bhL+DdoDjMc
         qLVwMpTwhvUtmOwBwaQANd5NlxUrIBs8TxM7aFN7pTnkQAEUvouHfAiTSzHyLsQGyYyh
         8Z6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963858; x=1774568658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o+uSbuBbEvwoTJfsFA5CUVKHHaR4vM8XqUDpN2lgnG8=;
        b=luFN208DDbMBwGZVwphgFqkOmOVY/NtP6v+hmu+zbPu2SGHEuNFWEy0jxR6lj340Mk
         0hZMrRlHpdNwMyrdeFKxueeABGY8t1bqKBABPZ/yPv/DBAITMa3B01o78voW+IlpzprM
         GdDgj3GO6DgmmBFKUwVYeRBTfwtBAaDNEpe/ddf6HPdDZQA+zuSICFjf/TSeVZZBRg0N
         yP3WFWRqUWqwOFpPg2y+RM0M5zlU5eJEKW+sH3yu0CYkbtHhaXFQ0mG39O7/AbY73bmT
         fyM5qF+JEwGlBu5HlSO7/TzPCu35kiPh2XRDW+Ew4JNsnmCb7ECLUUg9glt0FwcvwNNI
         uc/A==
X-Forwarded-Encrypted: i=1; AJvYcCWHY0wyqfsgtEMBDiMU0IEmJQNVBePrpEviLAvHt3IA84c2e+9Q7ctkBfB8jkJqdgwBnE2fiFoiAQ==@kvack.org
X-Gm-Message-State: AOJu0YxIQO4OLEFj/itQXS1ghhtf6Xh72E8NvW7J025F1QwSvKWfzB73
	Gk2MLz8jRJT5Kz8J6jQnsLmXpDJsAWaXbQUwpVoq/2TGVgxCpzn2dNFfKbfGY/EX45elwsXiYrn
	N+p3O5WyCwVOztXH34EQDwhrDLOHNdk/Ktivcfbj1
X-Gm-Gg: ATEYQzzV9kBFBEQEQNjo3TD36g9irSP5vCzHItXkY9cqH3kpDXBrzj+X4daaBkNe+qM
	MNC24xFqRHeKJrcRvubeCj3tKPs/E9sOJWngdcU2GeQclluItPjs+UMUamx21AHSCyNhUSzT8uv
	MzaNE3xQS0uA477savJAppiTiswKQpUhyhiByJB0FQhUC2OTPsABLG/EtekO5FUF1vT1EoMhWJr
	am1/CIdqirhbt9O71fHgROcJ+JMmmW4dwnDwUHcrTMVSfNKeI90o9dtyAHw1gvuZWvXs7M59bRe
	K0Sypg==
X-Received: by 2002:aa7:d583:0:b0:665:4aee:2091 with SMTP id
 4fb4d7f45d1cf-668e51fcf4bmr10623a12.1.1773963857253; Thu, 19 Mar 2026
 16:44:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260319083153.2488005-1-hao.ge@linux.dev> <20260319152808.fce61386fdf2934d7a3b0edb@linux-foundation.org>
In-Reply-To: <20260319152808.fce61386fdf2934d7a3b0edb@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Mar 2026 16:44:04 -0700
X-Gm-Features: AaiRm51-Lg-rX_oGUTXwPHYQl6IMNXHbffEI4NAEaqzQkS1MaGbx_lAxoUDwDaw
Message-ID: <CAJuCfpG5OG66mgfn3ez5ZXTjj7VC8yuK3L2u83uOZhyBbRH2Lw@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>, Kent Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CEAF40008
X-Stat-Signature: s9qbunqozf7d391hoery6my5tdrhjpoi
X-Rspam-User: 
X-HE-Tag: 1773963859-543664
X-HE-Meta: U2FsdGVkX1+pPBN1RdaURBIQo+mYWS44L7K8tevzUpSwR9Uzlo2DLVs6YJF7omLXDxdRfXEmBrJxW8msa7kmFZff1h9svUsLaTkTScnr/mCGyrJi7DfTuRQ5ZLqbFjI3rXJ0TFZbDs74rCvtg6ygUMJf4cEaM1blMSe4NXcfTLGcSZgcBuPKoDCKFKLXOOT2tZTHKBykBAfC79ootIbevwR9ksq+kHneCM2Q6digLEP50nzkuf4UpEm77jr49/wncK7aGtk9Stq8oHWx3Al56a4NqoUYRwXL0Whve2XZ32X1WHgJITdCdSX/ub7JdnDe+CZ9H3pU+iMDCG2DAVB1Mdjk9FIj90XEevSZn4hfHHfVSPSBBJy1GV+JA3LARQYKsBrEZ6xQ4GNfTdA8jgF7wQmDcpOaJEPEVZdDC48BDLgY8cvEjqld35UHJYFtzSGw7dpNj97G3501DlrPWOaWmjZEJrUVJhWniq+NRKs9HlWG0igz+CZUEJi+iVivx40Nc4LhSPOCHvthUJS4MB05AbQqpix5WzhWnOa1/IUzvZv0tZVT/v3I/r1zKj3f9ZnRX7qYaDuc7J0ZwfcWVdWmXgBQEkSKZgflP2gd7vsc5r2Rf/fqzYJQq3plNbx2RcdHTzDzrFrnA3d5fjE/k4TZb0X6Zl9LJLF9f7s7XXifOVq4fH/zQS249Cw4ndILglpfAfvT0ymsSNwqJeyi8zAjTJXsYxH3ZG/8SJch8o6W/9iXXcmNQVGGzjjbaTvjb9Kyez56ZlyxAvw6BCGxTQoC2xChfNO0AAlEW232VS7riOqdwtt+12Tb4460/VRVEye96UTTXCunsJiNON32nDU7gcw4zS6GS2F2aLr+l4q/0N7Be3ZSlZbX1XceAuW5n14bUTQTliIdEjtm1mDkfT29DKLT2lLdTiE/vQg8hkXbWRtNSAhbYzfEy2RlNU2Al7pMcHzcPwC3NvZzkP8ddKB
 PJcikT+x
 uv2ip1KlUNe/RKS2K3BkfCCnRURoVDdmVSXVFuqlQkk9OEhRJdYZN2r0jwocmYL6lLTSgbOljEuVy6J5ObX8QsJVlhuIonyRfp42/hwWO0nQZSuNuqeFdFIxLHq9wEGQOvDDv2P7aZ6lqkUMVBqWYCSWF1OcrBnY/RgjmGvL90+Buml61rD8bpvCTxBuVfNjXjwC9uFBFzU4fWNebpDyQruAUKMdge1tgVWfRff90gaBUxFKdwlnAnZM5cAZ/2L+2J19Zsu4FaDV+1ISZJi4dXQRsaKX1JTyCGN4UO7rFNKcLIy7GrGr3YwZDl3nPIkNTACie6dSlpohLlPEylOn72vV4WI9wuO4qLSqrZyu4RQmdnxvmQXCDarbfPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 3:28=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>
> > Due to initialization ordering, page_ext is allocated and initialized
> > relatively late during boot. Some pages have already been allocated
> > and freed before page_ext becomes available, leaving their codetag
> > uninitialized.

Hi Hao,
Thanks for the report.
Hmm. So, we are allocating pages before page_ext is initialized...

> >
> > A clear example is in init_section_page_ext(): alloc_page_ext() calls
> > kmemleak_alloc(). If the slab cache has no free objects, it falls back
> > to the buddy allocator to allocate memory. However, at this point page_=
ext
> > is not yet fully initialized, so these newly allocated pages have no
> > codetag set. These pages may later be reclaimed by KASAN,which causes
> > the warning to trigger when they are freed because their codetag ref is
> > still empty.
> >
> > Use a global array to track pages allocated before page_ext is fully
> > initialized, similar to how kmemleak tracks early allocations.
> > When page_ext initialization completes, set their codetag
> > to empty to avoid warnings when they are freed later.
> >
> > ...
> >
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -74,6 +74,9 @@ static inline void set_codetag_empty(union codetag_re=
f *ref)
> >
> >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> >
> > +bool mem_profiling_is_available(void);
> > +void alloc_tag_add_early_pfn(unsigned long pfn);
> > +
> >  #define ALLOC_TAG_SECTION_NAME       "alloc_tags"
> >
> >  struct codetag_bytes {
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index 58991ab09d84..a5bf4e72c154 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/module.h>
> >  #include <linux/page_ext.h>
> > +#include <linux/pgalloc_tag.h>
> >  #include <linux/proc_fs.h>
> >  #include <linux/seq_buf.h>
> >  #include <linux/seq_file.h>
> > @@ -26,6 +27,82 @@ static bool mem_profiling_support;
> >
> >  static struct codetag_type *alloc_tag_cttype;
> >
> > +/*
> > + * State of the alloc_tag
> > + *
> > + * This is used to describe the states of the alloc_tag during bootup.
> > + *
> > + * When we need to allocate page_ext to store codetag, we face an
> > + * initialization timing problem:
> > + *
> > + * Due to initialization order, pages may be allocated via buddy syste=
m
> > + * before page_ext is fully allocated and initialized. Although these
> > + * pages call the allocation hooks, the codetag will not be set becaus=
e
> > + * page_ext is not yet available.
> > + *
> > + * When these pages are later free to the buddy system, it triggers
> > + * warnings because their codetag is actually empty if
> > + * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
> > + *
> > + * Additionally, in this situation, we cannot record detailed allocati=
on
> > + * information for these pages.
> > + */
> > +enum mem_profiling_state {
> > +     DOWN,                   /* No mem_profiling functionality yet */
> > +     UP                      /* Everything is working */
> > +};
> > +
> > +static enum mem_profiling_state mem_profiling_state =3D DOWN;
> > +
> > +bool mem_profiling_is_available(void)
> > +{
> > +     return mem_profiling_state =3D=3D UP;
> > +}
> > +
> > +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> > +
> > +#define EARLY_ALLOC_PFN_MAX          256
> > +
> > +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];
>
> It's unfortunate that this isn't __initdata.
>
> > +static unsigned int early_pfn_count;
> > +static DEFINE_SPINLOCK(early_pfn_lock);
> > +
> >
> > ...
> >
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, struct=
 task_struct *task,
> >               alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
> >               update_page_tag_ref(handle, &ref);
> >               put_page_tag_ref(handle);
> > +     } else {

This branch can be marked as "unlikely".

> > +             /*
> > +              * page_ext is not available yet, record the pfn so we ca=
n
> > +              * clear the tag ref later when page_ext is initialized.
> > +              */
> > +             if (!mem_profiling_is_available())
> > +                     alloc_tag_add_early_pfn(page_to_pfn(page));
> >       }
> >  }
>
> All because of this, I believe.  Is this fixable?
>
> If we take that `else', we know we're running in __init code, yes?  I
> don't see how `__init pgalloc_tag_add_early()' could be made to work.
> hrm.  Something clever, please.

We can have a pointer to a function that is initialized to point to
alloc_tag_add_early_pfn, which is defined as __init and uses
early_pfns which now can be defined as __initdata. After
clear_early_alloc_pfn_tag_refs() is done we reset that pointer to
NULL. __pgalloc_tag_add() instead of calling alloc_tag_add_early_pfn()
directly checks that pointer and if it's not NULL then calls the
function that it points to. This way __pgalloc_tag_add() which is not
an __init function will be invoking alloc_tag_add_early_pfn() __init
function only until we are done with initialization. I haven't tried
this but I think that should work. This also eliminates the need for
mem_profiling_state variable since we can use this function pointer
instead.


>


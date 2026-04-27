Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3353FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5F36B0095; Mon, 27 Apr 2026 14:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D4E6B009B; Mon, 27 Apr 2026 14:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B636B009F; Mon, 27 Apr 2026 14:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 356EB6B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:23:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC75C8AE2D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:23:50 +0000 (UTC)
X-FDA: 84705159420.11.B95A905
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF1A7180007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:23:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fXG0pvXw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777314228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3P4/BmwQ2wc/76nqXXSEP0k6pcEgKoUm2JzOuE4s7E=;
	b=DZzUA447V6H5VfIS6Q73JsHCqJLuO4clrk+aCLifBydTfuc0z9PYNshEPUw6xNTPwlW0Ru
	vPO9IecLN7R7HWylkpWqnKVEYf6tpUcH+Nr6k9A+SROuQtuS9YweH2d54NlpYQllMYWc5G
	sFHaGruVUzQz51TmTUxtAIY3tYp1LEM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777314228; a=rsa-sha256;
	cv=pass;
	b=pQo6PgUJvoVcfuLjt43FwAzP3ldV7d68tIAyYnodzXplEsBOE6NXcYlKmPV2PaBLQSpr/V
	vBoPHDJs+4fo8Yrzipl5EHyCjyIUx2FhmycvhQBjftGYy9z2X5zGywhIfQAsBYLTOzVZLD
	MCwyWVlSLR8zRsB85hn0wtCnrkLcOaY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fXG0pvXw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50d6b393d60so88581cf.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:23:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777314228; cv=none;
        d=google.com; s=arc-20240605;
        b=FMfRIArUBxVAHx/Mm0XtUgZ7SfSBN4JjbCDyW/HARQAAFqGj3MVv+fLkCPbChcLGFs
         V1jr5MDxlWqmyCuaSWvL9/CVgaPJ3AVhB34rk5RmvDvFR71wy1LfwxvbgNFFBDYWFSgt
         vqmcAP7YcwWrPbWXpIt788thES3MzO/GtJFbIKzCbNTnpL3lrf6HXHgeGD3rTUtpDQl0
         drNuDA9XIKzcpCPHHiWJg13ErXhY4nE1AoOerYr1vbyZhQKTdpXnH2ZMoJqOMGgFvRKr
         xBAEYEDkKNxfKBZjk8vydo9Wk6DCyvAFEhUigJg0kx1IFghiZkgPJMFZ4YBSRQDrykK1
         Dp4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K3P4/BmwQ2wc/76nqXXSEP0k6pcEgKoUm2JzOuE4s7E=;
        fh=IQK9qgwighTYQJ+t6C9UYcwh+TnE/zsIuB3YKnVdddI=;
        b=hZPjmXKC3A6gcx7x46sHOognLTFQHvFvFqO7LuRcNyjaxZCaCjxQgiCEWe28prPiyJ
         dworZHVx2SLOooikOr3eOoh3rSxgfI5UFzeLZZkjun+v62zUQNA3ICRbgBcnY1CpSC8s
         oaD7RuvLGv9FBBVR7dsJw8icQB0/HJmz5xRX0JzqL6uRJDB1V3mxjkuF2tWr3h3Oy/4X
         NxjHn7PFwhfcMSK99Ms8kYn6HDH5zXmysZ3PbAl6H8vlwSRKzJhE8kusr43q5uLnvFql
         LRePsfW4ilxABG4GEimSHK2UCbkiRyJPHkwBMH8nPPSHlEDx/vBzn5uKGYtteV5CTo6S
         LHlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777314228; x=1777919028; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3P4/BmwQ2wc/76nqXXSEP0k6pcEgKoUm2JzOuE4s7E=;
        b=fXG0pvXw1TG8Ya2lLsGfEWuAEU1LX98r7bZ1W3MbMb7QKDZiLT/NISMIiJwccVFbmm
         toZ6XahLEBqSos59eBIbyljtLoUbTcYKZPU0+yA+CJZsWZvBtuhQLzQmjOh55SenFh+d
         dN0kQ5wx42N1qD4CtPbTzTFjbEwYfft5UfsNL4h3SlsB6wdeySotG1KwtlEbT1BlqR5W
         oq14J0Uo7x402qkg6JFRswYEElTS2EAuzFQv82RZAmpakdQgLPm5Kug6UbDauIl3GqKe
         4gqqyTJImyLJjcwSYaq5Op/Dh+va7buYcLWZRzCqpjb4YfKiq9q0Rc9LcY1TZnxVQCOV
         p1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314228; x=1777919028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K3P4/BmwQ2wc/76nqXXSEP0k6pcEgKoUm2JzOuE4s7E=;
        b=VnN5IMa+a5BQM+vWq2J72lr/mAQx/j8qBWQXHD0BWUgI2L1oMl/ns/8g82UpRl2RQy
         N9K0/uHmv6MqI2yT+q1108Qt3tLPpu+6b3Llfvw+WEH+R9XoZqCAG/UUeHssxWr6wpsQ
         3tdsCAaT4UF6LwKAym7EpD9LereH4LzUrNYPuJEihNZz1oqOy6py/3zQP74mTr+Vjpko
         etISik2QdcZLEodro+6UwxZ8lYreFkKR+QuSqHL1+YVm+2Me8yqM5GgowFzLv1jgjP6Q
         cB8qmIehOXtC9m55z6W+xYPqS+lWpBuuod59x4MuEenIKQzYGcmfZyykV4QMZH5fmXnD
         5PIA==
X-Forwarded-Encrypted: i=1; AFNElJ9N4/Zh5LT5Kj8SV3COuZCwStiAdPovU3oJveOszY8yKPvERShmzl8kBGBDrGCQqDBSJm5kJ0+tzg==@kvack.org
X-Gm-Message-State: AOJu0YzWdGh9rV1kXiTDl1IS5fPNBXWrxVoWnFK8SHJwER5BOzVh1Hu0
	ZzMIoM0zSJbWfqJZCr54bn8g4RdZ3EnryDoOFgfbWs4io2UWgbYLl8J8wq2A5QM9V08vbJP7ct5
	8WSx4r1DguuDLbhGUj3jnMZTrCX5HlSqpOhVi7NC6
X-Gm-Gg: AeBDievA1aTu5JCdWx/0mcExOMP/dZWg3Cg/2CPaTCJas9MkjLOF3AtiEXN6VCw3C+1
	fUbYFmxq8WSOkAnMJJtnEEKmkTNIvLTCy0p3UDBy+9fvSpSYN0gsRr0O4YEODKreSnQ3xercnUO
	6jWcBXb72Ut5gVT/tn/rfXOhve/Yjhtmj53SItWnBiNR67/VisImvG2p7B1q8Po2q6xfbh6bWmR
	+TNbRMlJgchkIFzEK0xwp6Fs1V+4Umw2M2A/TzIYnIOkdsZbxnCua6hnOwkb2ScS2Bk/jhhFWYC
	UCNHwW/dSH8j/ZzmRac2XRoJpl/IoEC3GNUOlA==
X-Received: by 2002:a05:622a:494:b0:50e:6360:96e with SMTP id
 d75a77b69052e-5100c923b1emr1498431cf.0.1777314226220; Mon, 27 Apr 2026
 11:23:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260423083756.157902-1-hao.ge@linux.dev> <CAJuCfpEy=rDFRhS+X-a5t-UquPi7veMRmyZzxR_9Z-WKagwFaw@mail.gmail.com>
In-Reply-To: <CAJuCfpEy=rDFRhS+X-a5t-UquPi7veMRmyZzxR_9Z-WKagwFaw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Apr 2026 11:23:33 -0700
X-Gm-Features: AVHnY4Lv4hXT6OXcvKOfVGq1IG9JTCS0de1BBI0n-ic8vo4ZOqLoj5UP3Z6-HpI
Message-ID: <CAJuCfpEL0fLQi5GFwxTAQGDAtEuGb6WCGO8icuTWjcs8=KRX3w@mail.gmail.com>
Subject: Re: [PATCH v3] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF1A7180007
X-Stat-Signature: aknhb8fmopn8wmqibpxjdfnf6x1kf1bx
X-Rspam-User: 
X-HE-Tag: 1777314228-542429
X-HE-Meta: U2FsdGVkX18SAH9C76S5OuiYXt7QnGBgMmiXV5LP7SiA9oa/QANJcbY0zNA/tZ/j1EqfwWAiVeDSTFOyxt82Fcx34cgsnq/W/I6sxqhvlVtMArz3pgO8EL/7N9ZEoZlV5z0qQb1QZ8KuMDrRXFLVAkokGu/pZQaYcmeu+icN+xlKTS4EHqxbHyIfFxLfPIL9vuacMyLAdFEtyoNHXlomPUrJmd2fQx+V5s+WCcWB5YJB0bWTWXlmEG2UHxX0BVhozpUb/PgS+L8wcNp3htdbie1cgmOaLYjuDKCbkT3Kt8g5K+A9hMbbts/MLzDDv9vFb0kM6kyGRc67+ecJjDKcQqwA9c9m750kQlJHhsqSTpDGRdFx2POS8Ny9XwiUWpLnMsLlZAjClJtNMAwiwt9omxqqCX0gMSet8dKaHjQDFRZ3e1HWJ+hiEF1lF2btMyrA/InU522xoAb9BiT5aYKVfp9Yei/ih1BTh6FOS+EkENG0UzXQcVke2K4GzvyH3mxmjVqofQYTIpzfESqoNCja8GYTmbW2peGbQjpUx2jmV9gu+XVXDHC9krUpa9wdUqtOxL6Xv+NHS2L10kIN/PLHS/sWMuo+b1owwKHjEVt7PhSQlgKQTsmSQaQZPewXrCD1MQ+eEMQzp2mxxImqAI641uF7UJBWQ+t82GKB3Rem/0RMrF8XhAdHzfwjz0d4zcq+HVaE/MQ+Q4Ytz4h/5evPZKc5rIj6YO2FXjp1USYJnoU+pmAAyHRDoZGmf66aRwJGVU0t2rhYNxkUG8NeiEFVz2u8fh4JeHTugf4Tlx2g8rqYXTTDraaVAMjR07ZzacGLsxTsA31EPMzGeorDPl3hlI0uyb/e7Iw3S02WZOSUk8dp4QCAl3UfEnfY3X55rYcH4hAWbQVfoub1Wa1vFbCqypp+NL50OSS4WKs0kUvABIpdMtAM6aE9Hrp07W5G8VdpuEVwsWdYGOvqz8kVa39
 ydXm4xaq
 2RmMO13R3bsS3l5mEAJ1o2NDpyHjx1zixoVhEmlvZAr/Y5YfrahnB2m3WCjKWUxs8zBSvfvBRYgStRWN5Ap6OfHgHWR5klpBVuXYBbC20yMA9ipRSqvzC8ZEQfMzILcLwOIdjX7yPnpOhfHuoqhItc74bi16/wiGlvLmoTna9pdRse/j5UgllIRZRnE+z3lBZzh9tw4EIOMqNYDQ1i8LiFC3oFL1MNfVEEzpwi9QZ3+yedJYJzokvQji7tfK6FeaVze6UEgUcZjgjeRmyj/xRi6CPkdk5bntqcItIJHuBXaTvU2XiSPipyMLF7gjDv1qDdoLueQxtePTY+7UP7W02ImO0tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 9:02=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Apr 23, 2026 at 1:39=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Pages allocated before page_ext is available have their codetag left
> > uninitialized. Track these early PFNs and clear their codetag in
> > clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> > warnings when they are freed later.
> >
> > Currently a fixed-size array of 8192 entries is used, with a warning if
> > the limit is exceeded. However, the number of early allocations depends
> > on the number of CPUs and can be larger than 8192.
> >
> > Replace the fixed-size array with a dynamically allocated linked list
> > of pages. Each page stores PFNs in its page body and uses page->lru
> > to link to the next page, with page->private tracking the number of
> > used slots.
> >
> > The list pages themselves are allocated via alloc_page(), which would
> > trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
> > indefinitely. Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
> > bit) and pass gfp_flags through pgalloc_tag_add() so that the early pat=
h
> > can skip recording allocations that carry this flag.
> >
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> > v3:
> > - Simplify linked list: use page->lru for chaining and page->private as
> >   slot counter, removing the early_pfn_node struct and freelist (sugges=
ted
> >   by Suren Baghdasaryan)
> > - Pass gfp_flags through alloc_tag_add_early_pfn() but strip
> >   __GFP_DIRECT_RECLAIM instead of selecting GFP_KERNEL/GFP_ATOMIC,
> >   because __alloc_tag_add_early_pfn() is invoked under rcu_read_lock().
> >
> > v2:
> > - Use cmpxchg to atomically update early_pfn_pages, preventing page lea=
k under concurrent allocation
> > - Pass gfp_flags through the full call chain and use gfpflags_allow_blo=
cking()
> >   to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC i=
n process context
> > ---
> >  include/linux/alloc_tag.h |  22 ++++++-
> >  lib/alloc_tag.c           | 118 +++++++++++++++++++++-----------------
> >  mm/page_alloc.c           |  23 ++++----
> >  3 files changed, 97 insertions(+), 66 deletions(-)
> >
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index 02de2ede560f..ce9b478033bf 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag_=
read(struct alloc_tag *tag)
> >  }
> >
> >  #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> > +/*
> > + * Skip early PFN recording for a page allocation.  Reuses the
> > + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoi=
d
> > + * recursion when allocating pages for the early PFN tracking list
> > + * itself.
> > + *
> > + * Callers must set the codetag to CODETAG_EMPTY (via
> > + * clear_page_tag_ref()) before freeing pages allocated with this
> > + * flag once page_ext becomes available, otherwise
> > + * alloc_tag_sub_check() will trigger a warning.
>
> nit: Callers must... sounds like someone who uses
> __alloc_tag_add_early_pfn() has to do something extra, however
> clear_page_tag_ref() is done by clear_early_alloc_pfn_tag_refs(), so
> callers don't really need to do this. I suggest rephrasing as:
>
> Codetags of the pages allocated with __GFP_NO_CODETAG should be
> cleared (via clear_page_tag_ref()) before freeing the pages to prevent
> alloc_tag_sub_check() from triggering a warning.
>
> > + */
> > +#define __GFP_NO_CODETAG       __GFP_NO_OBJ_EXT
> > +
> > +static inline bool should_record_early_pfn(gfp_t gfp_flags)
> > +{
> > +       return !(gfp_flags & __GFP_NO_CODETAG);
> > +}
> >  static inline void alloc_tag_add_check(union codetag_ref *ref, struct =
alloc_tag *tag)
> >  {
> >         WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
> > @@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union code=
tag_ref *ref)
> >  {
> >         WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
> >  }
> > -void alloc_tag_add_early_pfn(unsigned long pfn);
> > +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
> >  #else
> >  static inline void alloc_tag_add_check(union codetag_ref *ref, struct =
alloc_tag *tag) {}
> >  static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> > -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> > +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gf=
p_flags) {}
> > +static inline bool should_record_early_pfn(gfp_t gfp_flags) { return f=
alse; }
> >  #endif
> >
> >  /* Caller should verify both ref and tag to be valid */
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index ed1bdcf1f8ab..a00dc5a867e4 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -766,45 +766,49 @@ static __init bool need_page_alloc_tagging(void)
> >   * Some pages are allocated before page_ext becomes available, leaving
> >   * their codetag uninitialized. Track these early PFNs so we can clear
> >   * their codetag refs later to avoid warnings when they are freed.
> > - *
> > - * Early allocations include:
> > - *   - Base allocations independent of CPU count
> > - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_ini=
t,
> > - *     such as trace ring buffers, scheduler per-cpu data)
> > - *
> > - * For simplicity, we fix the size to 8192.
> > - * If insufficient, a warning will be triggered to alert the user.
> > - *
> > - * TODO: Replace fixed-size array with dynamic allocation using
> > - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> >   */
> > -#define EARLY_ALLOC_PFN_MAX            8192
> > +#define EARLY_PFNS_PER_PAGE            (PAGE_SIZE / sizeof(unsigned lo=
ng))
> >
> > -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> > -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> > +static struct page *early_pfn_current __initdata;
>
> So, instead of using early_pfn_current as the head page and then
> page->lru.next directly, I would suggest having "struct llist_head
> early_pfn_head;" as the list head and either using page->pcp_llist to
> link the pages or even better, adding a "struct llist_node llist;"
> into the union containing "struct list_head lru;". Note that
> llist_add() uses try_cmpxchg(), so the link addition is atomic.
> And you should probably use folios rather than pages to follow the new tr=
ends.

Please ignore that last suggestion about using folios. I checked with
Matthew and he says to use folios when needed, not whenever we can.
So, using pages here seems fine.

>
> >
> > -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> > +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t =
gfp_flags)
> >  {
> > -       int old_idx, new_idx;
> > +       struct page *page;
> > +       unsigned long idx;
> >
> >         do {
> > -               old_idx =3D atomic_read(&early_pfn_count);
> > -               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> > -                       pr_warn_once("Early page allocations before pag=
e_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> > -                                     EARLY_ALLOC_PFN_MAX);
> > -                       return;
> > +               page =3D READ_ONCE(early_pfn_current);
> > +               if (!page || READ_ONCE(page->private) >=3D EARLY_PFNS_P=
ER_PAGE) {
> > +                       gfp_t gfp =3D gfp_flags & ~__GFP_DIRECT_RECLAIM=
;
> > +                       struct page *new =3D alloc_page(gfp | __GFP_NO_=
CODETAG);
> > +
> > +                       if (!new) {
> > +                               pr_warn_once("early PFN tracking page a=
llocation failed\n");
> > +                               return;
> > +                       }
> > +                       new->lru.next =3D (struct list_head *)page;
> > +                       if (cmpxchg(&early_pfn_current, page, new) !=3D=
 page) {
> > +                               __free_page(new);
> > +                               continue;
> > +                       }
> > +                       page =3D new;
> >                 }
> > -               new_idx =3D old_idx + 1;
> > -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_id=
x));
> > +               idx =3D READ_ONCE(page->private);
> > +               if (idx >=3D EARLY_PFNS_PER_PAGE)
> > +                       continue;
> > +               if (cmpxchg(&page->private, idx, idx + 1) !=3D idx)
> > +                       continue;
> > +               break;
>
> nit: This would read more easily:
>
>                if (cmpxchg(&page->private, idx, idx + 1) =3D=3D idx)
>                         break;
>
>
> > +       } while (1);
> >
> > -       early_pfns[old_idx] =3D pfn;
> > +       ((unsigned long *)page_address(page))[idx] =3D pfn;
> >  }
> >
> > -typedef void alloc_tag_add_func(unsigned long pfn);
> > +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
> >  static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata=
 =3D
> >         RCU_INITIALIZER(__alloc_tag_add_early_pfn);
> >
> > -void alloc_tag_add_early_pfn(unsigned long pfn)
> > +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> >  {
> >         alloc_tag_add_func *alloc_tag_add;
> >
> > @@ -814,13 +818,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
> >         rcu_read_lock();
> >         alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr);
> >         if (alloc_tag_add)
> > -               alloc_tag_add(pfn);
> > +               alloc_tag_add(pfn, gfp_flags);
> >         rcu_read_unlock();
> >  }
> >
> >  static void __init clear_early_alloc_pfn_tag_refs(void)
> >  {
> > -       unsigned int i;
> > +       struct page *page, *next;
> > +       unsigned long i;
> >
> >         if (static_key_enabled(&mem_profiling_compressed))
> >                 return;
> > @@ -829,37 +834,42 @@ static void __init clear_early_alloc_pfn_tag_refs=
(void)
> >         /* Make sure we are not racing with __alloc_tag_add_early_pfn()=
 */
> >         synchronize_rcu();
> >
> > -       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> > -               unsigned long pfn =3D early_pfns[i];
> > -
> > -               if (pfn_valid(pfn)) {
> > -                       struct page *page =3D pfn_to_page(pfn);
> > -                       union pgtag_ref_handle handle;
> > -                       union codetag_ref ref;
> > -
> > -                       if (get_page_tag_ref(page, &ref, &handle)) {
> > -                               /*
> > -                                * An early-allocated page could be fre=
ed and reallocated
> > -                                * after its page_ext is initialized bu=
t before we clear it.
> > -                                * In that case, it already has a valid=
 tag set.
> > -                                * We should not overwrite that valid t=
ag with CODETAG_EMPTY.
> > -                                *
> > -                                * Note: there is still a small race wi=
ndow between checking
> > -                                * ref.ct and calling set_codetag_empty=
(). We accept this
> > -                                * race as it's unlikely and the extra =
complexity of atomic
> > -                                * cmpxchg is not worth it for this deb=
ug-only code path.
> > -                                */
> > -                               if (ref.ct) {
> > +       for (page =3D early_pfn_current; page; page =3D next) {
> > +               for (i =3D 0; i < page->private; i++) {
> > +                       unsigned long pfn =3D ((unsigned long *)page_ad=
dress(page))[i];
>
> This page_address() can be done in the outer loop since the page does
> not change inside the inner loop.
>
> > +
> > +                       if (pfn_valid(pfn)) {
> > +                               union pgtag_ref_handle handle;
> > +                               union codetag_ref ref;
> > +
> > +                               if (get_page_tag_ref(pfn_to_page(pfn), =
&ref, &handle)) {
> > +                                       /*
> > +                                        * An early-allocated page coul=
d be freed and reallocated
> > +                                        * after its page_ext is initia=
lized but before we clear it.
> > +                                        * In that case, it already has=
 a valid tag set.
> > +                                        * We should not overwrite that=
 valid tag
> > +                                        * with CODETAG_EMPTY.
> > +                                        *
> > +                                        * Note: there is still a small=
 race window between checking
> > +                                        * ref.ct and calling set_codet=
ag_empty(). We accept this
> > +                                        * race as it's unlikely and th=
e extra complexity of atomic
> > +                                        * cmpxchg is not worth it for =
this debug-only code path.
> > +                                        */
> > +                                       if (ref.ct) {
> > +                                               put_page_tag_ref(handle=
);
> > +                                               continue;
> > +                                       }
> > +
> > +                                       set_codetag_empty(&ref);
> > +                                       update_page_tag_ref(handle, &re=
f);
> >                                         put_page_tag_ref(handle);
> > -                                       continue;
> >                                 }
> > -
> > -                               set_codetag_empty(&ref);
> > -                               update_page_tag_ref(handle, &ref);
> > -                               put_page_tag_ref(handle);
> >                         }
> >                 }
> >
> > +               next =3D (struct page *)page->lru.next;
> > +               clear_page_tag_ref(page);
> > +               __free_page(page);
> >         }
> >  }
> >  #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 04494bc2e46f..5b7b234967a5 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
> >  /* Should be called only if mem_alloc_profiling_enabled() */
> >  static noinline
> >  void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> > -                      unsigned int nr)
> > +                      unsigned int nr, gfp_t gfp_flags)
> >  {
> >         union pgtag_ref_handle handle;
> >         union codetag_ref ref;
> > @@ -1294,21 +1294,24 @@ void __pgalloc_tag_add(struct page *page, struc=
t task_struct *task,
> >                 update_page_tag_ref(handle, &ref);
> >                 put_page_tag_ref(handle);
> >         } else {
> > -               /*
> > -                * page_ext is not available yet, record the pfn so we =
can
> > -                * clear the tag ref later when page_ext is initialized=
.
> > -                */
> > -               alloc_tag_add_early_pfn(page_to_pfn(page));
> > +
> >                 if (task->alloc_tag)
> >                         alloc_tag_set_inaccurate(task->alloc_tag);
> > +
> > +               /*
> > +                * page_ext is not available yet, record the pfn so the
> > +                * tag ref can be cleared later when page_ext is initia=
lized.
> > +                */
> > +               if (should_record_early_pfn(gfp_flags))
> > +                       alloc_tag_add_early_pfn(page_to_pfn(page), gfp_=
flags);
>
> Any reason for changing the order of alloc_tag_add_early_pfn() and
> alloc_tag_set_inaccurate()? I liked the previous version where we
> explain why this is done at the very beginning of the block. You could
> also call should_record_early_pfn() from inside
> alloc_tag_add_early_pfn(), which would keep both
> should_record_early_pfn() and __GFP_NO_CODETAG definitions local to
> alloc_tag.c.
>
> >         }
> >  }
> >
> >  static inline void pgalloc_tag_add(struct page *page, struct task_stru=
ct *task,
> > -                                  unsigned int nr)
> > +                                  unsigned int nr, gfp_t gfp_flags)
> >  {
> >         if (mem_alloc_profiling_enabled())
> > -               __pgalloc_tag_add(page, task, nr);
> > +               __pgalloc_tag_add(page, task, nr, gfp_flags);
> >  }
> >
> >  /* Should be called only if mem_alloc_profiling_enabled() */
> > @@ -1341,7 +1344,7 @@ static inline void pgalloc_tag_sub_pages(struct a=
lloc_tag *tag, unsigned int nr)
> >  #else /* CONFIG_MEM_ALLOC_PROFILING */
> >
> >  static inline void pgalloc_tag_add(struct page *page, struct task_stru=
ct *task,
> > -                                  unsigned int nr) {}
> > +                                  unsigned int nr, gfp_t gfp_flags) {}
> >  static inline void pgalloc_tag_sub(struct page *page, unsigned int nr)=
 {}
> >  static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsign=
ed int nr) {}
> >
> > @@ -1896,7 +1899,7 @@ inline void post_alloc_hook(struct page *page, un=
signed int order,
> >
> >         set_page_owner(page, order, gfp_flags);
> >         page_table_check_alloc(page, order);
> > -       pgalloc_tag_add(page, current, 1 << order);
> > +       pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> >  }
> >
> >  static void prep_new_page(struct page *page, unsigned int order, gfp_t=
 gfp_flags,
> > --
> > 2.25.1
> >


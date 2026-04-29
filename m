Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8F1FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 05:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182416B0005; Wed, 29 Apr 2026 01:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132EA6B008A; Wed, 29 Apr 2026 01:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C926B008C; Wed, 29 Apr 2026 01:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE4346B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:47:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52A86A04DC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:47:39 +0000 (UTC)
X-FDA: 84710511438.27.8311DB8
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D8F6100003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:47:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nNbTeMhO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777441657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5lIdBHfyO4Np/Qn+Xl2v7shQN61DnpA+zZt1njHyVg=;
	b=x0az9DqTqqHKlNUkNpVw0Q4+BxFyvTi2jytoxdPKr0qlT+9QgS7g8N1WOIBH+MHXos+9xv
	ihJGpELUYUwNEIfozxIn28z2oSRoC4sWbVOmPTsHLL+BUEnihuSYN1nxXk1QjFMSkQnHPm
	iBaONzNOgk6DakS4co8a58AYLXq0IjA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777441657; a=rsa-sha256;
	cv=pass;
	b=0slEj7qlOYLD8zO+KcAH5AQPOpFQSt/J/u03h9708HzunqtQ5IEBsgcxcvmAhsWKK4Dubp
	QeSqXdXGJoYSL3EEHLTxWx5L4DT/ejJRHFaaKMEDn/vGL2JuCAMM0mUSWGSQUO545WQU4e
	F5uuMxxX4R0KoHTzPsKLbrAbcIIqYG8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nNbTeMhO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50d6b393d60so333471cf.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:47:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777441656; cv=none;
        d=google.com; s=arc-20240605;
        b=CMgEzGZ8NgtGal4Zk1pwpWsecj9hAbz55TR0flGUsVRN4iPC16QO1WjTMCBzUN8CnF
         LKyqE29q3tJAc/Y6hj6FMAV1Win17zqzYrprYsswk0AR8FMbaM0T3eaHgZulPUx77Zqp
         AKUQMuiump9o4tJ77WZ8Dp5onAK2Fp8vAtCFSLv4phvM0KNrj7iYJFslMbArnFMsf7IA
         Rq024Ex7buKt8nEMtoaN67t39cUKxi9k53hhGlv2Cea1Ccijatwb75JPC3lVwI8ntHjg
         G67N/OgapA7PDNzhy7RpwAKgWANXDd+fEfvwrBv/mCclU/QkIRhoHm18AY30BWnlsDde
         prNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d5lIdBHfyO4Np/Qn+Xl2v7shQN61DnpA+zZt1njHyVg=;
        fh=rmVvxuBcya4Fvt+DoLlt+EHpF6nI9UcruGwPNAN5U/A=;
        b=KX7K6dQENS18iHkH2UFzYCmGeR4mG5J2WTYy6C+vVSWivSMH0hGlbrg/2rmpSWKe6E
         s4gVvB18pw2P2VN7X22wYuSo0FRyyztanmxP1glrlueHgCOuxFePNLpKxRrlzrfU8CD3
         uGSMsprKR7v4PfukvlOW2YWmciOCWwqmMHP01GF6Pov66cF95loFLQ8AGd+ltpteX1hi
         j1r+8FsZQAK0sXKB3UW57vz5P63TJ+/bWqdNibUBh5dNsWrkoVVJ0ZcXAnL4m1BPiqT2
         yF1YxT8xomb/P3hsZuLqzEl4NhUufbs3J/1QKUE4rt+lXXWa0aRH3mnu1PE2Z10mJFft
         +AMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777441656; x=1778046456; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d5lIdBHfyO4Np/Qn+Xl2v7shQN61DnpA+zZt1njHyVg=;
        b=nNbTeMhOzsDTIEXhECtnmdDxYGbAJ7o7KJpfP+hoVJRpjOscWeFgP4O17WZZwRWnHi
         +tifQNMUllfODSb3IhCCgS4tLxpBkc0lRXeTU3ha2hAIisiY+d4oHBSQc6fu+bGZWoNB
         Ta9O+bdBrATCtktqNcHFV9T8uH1xA1snySYPRdvqnKyofBE/NMqq7hiRrrPRlvpG/z4o
         XgoilCortBxoxS0N5zz0/ycleyF/ttVYrOTGKP4AS8m43vo1xuIwA8hEkHqhWnpkF7FU
         gSsIHTX0cKi2npZ3q1Nnw3ap4FoQMieurD35TYx4ybuPLBhj5D0xlo1Dmr2kfA/OArZ9
         RrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777441656; x=1778046456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d5lIdBHfyO4Np/Qn+Xl2v7shQN61DnpA+zZt1njHyVg=;
        b=WNIcHjRBrJj9zF9WIcdPaR8Q/Ya3r55BqQjb9swxsTLls6lONNjOAvOx55nvj23MT1
         o8fzvlq4S3FQHZRPFxgXBYI4fbsDqTiRHPkSGg5AL3Ajc6EG1VdvPOn1Bs8ezZuD90x/
         CFlgpWjKyxHD+vXD2JGj8/ShoRzpVa1aolIxHHC/rrciWxbFUcw9IpAbF5+N6v6RvAY/
         mTy/rYTbon2nLI8JVYT+ldDtinMjBKUxZe3Gjkw6iI5HPq7Rq4UU/BCa+Xz4ffiBgP2X
         OjKYW1zkUvA+55dykXXpyEynm+ZsBM9VTWNWN7huOxDjpCqfwzIBqX8elJp8ZP7Lgkn8
         mOCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+0Vzk6NkzPfRsmP4KCNwJlAl03+tQw8QvIkmYYqHIiQV47K+HjnzsNa6FTPBzMIMCePnlyhYgh5w==@kvack.org
X-Gm-Message-State: AOJu0YynKtTOCRkcRkxHNUjOjPk0Iete42a7Q3a78ZZGikh++H62+qwL
	PdBo07n7z/MfM0+p5qCaj5JvMhaRB3v6wYvNnacFVU7ddXbtOPNNNTRTGsDAOmQydUAn6aCLXfo
	ILHoeiiyQax0T+d43Uce8H3f6g2GXT+DC+xFFyY65
X-Gm-Gg: AeBDievk6UAC8ujnHUDVBGrOTgrFHAbHTCy0nQSYO2EALX6x9sO+H08dOxlzvC1sd9G
	vCiZjpdseDSZPC+r+r9OSXR+oN+XGbt5pUnota+/pxs2RvBW+ePAXi1uHZzDojcEGzTi4w0WTbi
	4Gf/45amwEYOdbt3ueZEQXzZ5PeV90Hcn/NvobVsocyyac2Lm5rF9pDtzYHC++W0UqmjTr4rKa7
	w6vjf2prvbOdwbozFQvk/0Jq+13fOtnkAOrTkIVTnM8YT7Ect2wOpsPSxX9Y9sdoeeprQUc5QfX
	iE9t52D1/12ClgOlfllumTjn0kg=
X-Received: by 2002:ac8:5742:0:b0:50e:41f3:6467 with SMTP id
 d75a77b69052e-5101948b00emr8923781cf.12.1777441655416; Tue, 28 Apr 2026
 22:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260423083756.157902-1-hao.ge@linux.dev> <CAJuCfpEy=rDFRhS+X-a5t-UquPi7veMRmyZzxR_9Z-WKagwFaw@mail.gmail.com>
 <b4735edb-55f9-4562-a0d0-a10e1788979a@linux.dev>
In-Reply-To: <b4735edb-55f9-4562-a0d0-a10e1788979a@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Apr 2026 22:47:23 -0700
X-Gm-Features: AVHnY4Jpm6BaUHwOMiV6FpmM5XfVhfmiyj9_ru9lsVodtcgGuBDYJvmwkG53dvY
Message-ID: <CAJuCfpHNgajyeYf5NFQL+4uLb57xw979Bf1Neqx2_u0=7NLJew@mail.gmail.com>
Subject: Re: [PATCH v3] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D8F6100003
X-Stat-Signature: xqrird87wyx33yjspxbjjpkxybbtz9uc
X-Rspam-User: 
X-HE-Tag: 1777441657-76551
X-HE-Meta: U2FsdGVkX1/qAX81tQy/GlkDhB4EZACamMafZfHHVINVVEPy7O2d4XeycCTi8swaIvoJE1x5IUdql03hDZeNn64zIAD0vtB1D/Zeg4qseIbDPBmRj5nI/a//P7sDK5HjPPjCf7sHu/Rjo+URGhpb9Qc36HqgEJmRLSG6kGzkNwf1X+Sxthr0P5j8NTIdfkz1gt/a8z4hnI6GkM66H4UIMoWrd8HZKbHY81HSBexpn8/hzGrDzkN3SjCXxgpNF3OKLA0AGtJuAQD2lMdiOGEgiOvy4fhatWXJ0b0jeult6zqWJsxAg4ehLlEDSDgauCI7amSz4gD5NmDoyjSTOD5zwHryvyR5WKwEPaEctC/qtJ/DXdnkX9f9plcXnBUn1dP3l5aWiR3eWs1Qw4vtiBgp58EXHm1GMmXvdUaCttopDifCHoSZje8ADERwND6fT2APAuvtsjxCFPdkXnl5QDjPW9EZImAckUely2jypxbu0PKXH4bg2RTncnOSLE02h1RfvqkQus7rMZ3W9lv9/CifqTrWexsQE9WlwUJYW2xDQrR1swM/f8lljZz4JZgHFONWfYKzgVRYp5+m7j7bcbvGSSOx3b2Shi/H137YYoEkODHShC5IxhAjKiPdpr6mMLCbiqhc/NQ2Zb/ta/kP3cUo8B0RecT+4o+1NunDUJZDGRfYWlCR7h/XIpXWzWfcInn4u+4611Fg/fyZ9mXu6zmkuq3jUQciiZNrc+9TujlOtdlRYRj7O2wIVopH+JWk8b/jAPYegaxU/OLaqEFDpTW3e2pM8L/VoRUtVWJNsLST/xjaARNwtEnEspCLaXx2vtM9kdm/OWsXh27zHtqF+qkhUylyIqdYq+vJ+1akmHRaxsikrWxYpCq0GNDAb7odhtQ3qEJqOh2q/oEPOW4RwIguhWwcaUEffixDDpFYu7DAAFu1WV4idABlx+Om9oGQRWmfZgsoSShguJ6Y4NPHRdM
 KvZb44CS
 TogQyY2HI9jnMhyvqD8Bn47e2PDs1el7y6Xu9FtbO7NeseW2HgDj/J4BTMrCTJg8UZzJ4aFEhxMR96XNWFvxN5O30k6hibbDu7jQqRICLwGClB7VWy4LxrcAPJ45wJDZRvfD4sarEhZJXTdlYaOprs7DlQ5mz/bav9PtXVdwhV2XxSa3t+r34oFXFCnmqHvvQJFBaZ4tbEcyWG4Z+w8eTZJpkB/vpfxP277s4PWE66bz4pnBjeVJLlqbzl8xNpnKrfRXEfOVOicM9+lhZq4qcv2zf4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 8:01=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> Thanks a lot for your review and suggestions.
>
>
> On 2026/4/28 00:02, Suren Baghdasaryan wrote:
> > On Thu, Apr 23, 2026 at 1:39=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote=
:
> >> Pages allocated before page_ext is available have their codetag left
> >> uninitialized. Track these early PFNs and clear their codetag in
> >> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> >> warnings when they are freed later.
> >>
> >> Currently a fixed-size array of 8192 entries is used, with a warning i=
f
> >> the limit is exceeded. However, the number of early allocations depend=
s
> >> on the number of CPUs and can be larger than 8192.
> >>
> >> Replace the fixed-size array with a dynamically allocated linked list
> >> of pages. Each page stores PFNs in its page body and uses page->lru
> >> to link to the next page, with page->private tracking the number of
> >> used slots.
> >>
> >> The list pages themselves are allocated via alloc_page(), which would
> >> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
> >> indefinitely. Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
> >> bit) and pass gfp_flags through pgalloc_tag_add() so that the early pa=
th
> >> can skip recording allocations that carry this flag.
> >>
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---
> >> v3:
> >> - Simplify linked list: use page->lru for chaining and page->private a=
s
> >>    slot counter, removing the early_pfn_node struct and freelist (sugg=
ested
> >>    by Suren Baghdasaryan)
> >> - Pass gfp_flags through alloc_tag_add_early_pfn() but strip
> >>    __GFP_DIRECT_RECLAIM instead of selecting GFP_KERNEL/GFP_ATOMIC,
> >>    because __alloc_tag_add_early_pfn() is invoked under rcu_read_lock(=
).
> >>
> >> v2:
> >> - Use cmpxchg to atomically update early_pfn_pages, preventing page le=
ak under concurrent allocation
> >> - Pass gfp_flags through the full call chain and use gfpflags_allow_bl=
ocking()
> >>    to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC=
 in process context
> >> ---
> >>   include/linux/alloc_tag.h |  22 ++++++-
> >>   lib/alloc_tag.c           | 118 +++++++++++++++++++++---------------=
--
> >>   mm/page_alloc.c           |  23 ++++----
> >>   3 files changed, 97 insertions(+), 66 deletions(-)
> >>
> >> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> >> index 02de2ede560f..ce9b478033bf 100644
> >> --- a/include/linux/alloc_tag.h
> >> +++ b/include/linux/alloc_tag.h
> >> @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag=
_read(struct alloc_tag *tag)
> >>   }
> >>
> >>   #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >> +/*
> >> + * Skip early PFN recording for a page allocation.  Reuses the
> >> + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avo=
id
> >> + * recursion when allocating pages for the early PFN tracking list
> >> + * itself.
> >> + *
> >> + * Callers must set the codetag to CODETAG_EMPTY (via
> >> + * clear_page_tag_ref()) before freeing pages allocated with this
> >> + * flag once page_ext becomes available, otherwise
> >> + * alloc_tag_sub_check() will trigger a warning.
> > nit: Callers must... sounds like someone who uses
> > __alloc_tag_add_early_pfn() has to do something extra, however
> > clear_page_tag_ref() is done by clear_early_alloc_pfn_tag_refs(), so
> > callers don't really need to do this. I suggest rephrasing as:
> >
> > Codetags of the pages allocated with __GFP_NO_CODETAG should be
> > cleared (via clear_page_tag_ref()) before freeing the pages to prevent
> > alloc_tag_sub_check() from triggering a warning.
>
> That's reasonable.
>
> I will adjust the wording in v2.
> >> + */
> >> +#define __GFP_NO_CODETAG       __GFP_NO_OBJ_EXT
> >> +
> >> +static inline bool should_record_early_pfn(gfp_t gfp_flags)
> >> +{
> >> +       return !(gfp_flags & __GFP_NO_CODETAG);
> >> +}
> >>   static inline void alloc_tag_add_check(union codetag_ref *ref, struc=
t alloc_tag *tag)
> >>   {
> >>          WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
> >> @@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union cod=
etag_ref *ref)
> >>   {
> >>          WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
> >>   }
> >> -void alloc_tag_add_early_pfn(unsigned long pfn);
> >> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
> >>   #else
> >>   static inline void alloc_tag_add_check(union codetag_ref *ref, struc=
t alloc_tag *tag) {}
> >>   static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> >> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> >> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t g=
fp_flags) {}
> >> +static inline bool should_record_early_pfn(gfp_t gfp_flags) { return =
false; }
> >>   #endif
> >>
> >>   /* Caller should verify both ref and tag to be valid */
> >> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >> index ed1bdcf1f8ab..a00dc5a867e4 100644
> >> --- a/lib/alloc_tag.c
> >> +++ b/lib/alloc_tag.c
> >> @@ -766,45 +766,49 @@ static __init bool need_page_alloc_tagging(void)
> >>    * Some pages are allocated before page_ext becomes available, leavi=
ng
> >>    * their codetag uninitialized. Track these early PFNs so we can cle=
ar
> >>    * their codetag refs later to avoid warnings when they are freed.
> >> - *
> >> - * Early allocations include:
> >> - *   - Base allocations independent of CPU count
> >> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_in=
it,
> >> - *     such as trace ring buffers, scheduler per-cpu data)
> >> - *
> >> - * For simplicity, we fix the size to 8192.
> >> - * If insufficient, a warning will be triggered to alert the user.
> >> - *
> >> - * TODO: Replace fixed-size array with dynamic allocation using
> >> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> >>    */
> >> -#define EARLY_ALLOC_PFN_MAX            8192
> >> +#define EARLY_PFNS_PER_PAGE            (PAGE_SIZE / sizeof(unsigned l=
ong))
> >>
> >> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> >> -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> >> +static struct page *early_pfn_current __initdata;
> > So, instead of using early_pfn_current as the head page and then
> > page->lru.next directly, I would suggest having "struct llist_head
> > early_pfn_head;" as the list head and either using page->pcp_llist to
> > link the pages or even better, adding a "struct llist_node llist;"
> > into the union containing "struct list_head lru;". Note that
> > llist_add() uses try_cmpxchg(), so the link addition is atomic.
>
> Adding a struct llist_node into the page union only for the
> CONFIG_MEM_ALLOC_PROFILING_DEBUG feature,
>
> which may not be quite appropriate from a design perspective.
>
> > And you should probably use folios rather than pages to follow the new =
trends.
> >
> >> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> >> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t=
 gfp_flags)
> >>   {
> >> -       int old_idx, new_idx;
> >> +       struct page *page;
> >> +       unsigned long idx;
> >>
> >>          do {
> >> -               old_idx =3D atomic_read(&early_pfn_count);
> >> -               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> >> -                       pr_warn_once("Early page allocations before pa=
ge_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> >> -                                     EARLY_ALLOC_PFN_MAX);
> >> -                       return;
> >> +               page =3D READ_ONCE(early_pfn_current);
> >> +               if (!page || READ_ONCE(page->private) >=3D EARLY_PFNS_=
PER_PAGE) {
> >> +                       gfp_t gfp =3D gfp_flags & ~__GFP_DIRECT_RECLAI=
M;
> >> +                       struct page *new =3D alloc_page(gfp | __GFP_NO=
_CODETAG);
> >> +
> >> +                       if (!new) {
> >> +                               pr_warn_once("early PFN tracking page =
allocation failed\n");
> >> +                               return;
> >> +                       }
> >> +                       new->lru.next =3D (struct list_head *)page;
> >> +                       if (cmpxchg(&early_pfn_current, page, new) !=
=3D page) {
> >> +                               __free_page(new);
> >> +                               continue;
> >> +                       }
>
>
> I also considered using llist_head initially.  like this
>
> static LLIST_HEAD(early_pfn_pages);
>
> static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t
> gfp_flags)
> {
>          struct page *page;
>          unsigned long idx;
>
>          do {
>                  page =3D llist_first(&early_pfn_pages);
>                  if (!page || READ_ONCE(page->private) >=3D
> EARLY_PFNS_PER_PAGE) {
>                          gfp_t gfp =3D gfp_flags & ~__GFP_DIRECT_RECLAIM;
>                          struct page *new =3D alloc_page(gfp |
> __GFP_NO_CODETAG);
>
>                          if (!new) {
>                                  pr_warn_once("early PFN tracking page
> allocation failed\n");
>                                  return;
>                          }
>                          new->private =3D 0;
>                          llist_add(&new->pcp_llist, &early_pfn_pages);
>                          page =3D new;
>                  }
>                  idx =3D READ_ONCE(page->private);
>                  if (idx >=3D EARLY_PFNS_PER_PAGE)
>                          continue;
>                  if (cmpxchg(&page->private, idx, idx + 1) =3D=3D idx)
>                          break;
>          } while (1);
>
>          ((unsigned long *)page_address(page))[idx] =3D pfn;
> }
>
>
> The problem is that llist_add() retries internally until it succeeds.
>
> When multiple CPUs concurrently see that the head page is NULL or full ,
>
> they each allocate a new tracking page and all insertions succeed:
>
> CPU0: head page A is full or NULL, allocates B, llist_add(B) =E2=86=92 he=
ad=3DB=E2=86=92A
>
> CPU1: head page A is full or NULL, allocates C, llist_add(C) =E2=86=92 he=
ad=3DC=E2=86=92B=E2=86=92A
>
> CPU0: claims slot 0 in B
>
> CPU1: claims slot 0 in C
>
> Now the head is C. Once C fills up, a new page D is allocated and
> becomes the new head. But B still has ~511 unused slots and will never
>
> be the head again =E2=80=94 we only ever look at llist_first(). Those slo=
ts are
> permanently wasted.
>
> That's why I used struct page *early_pfn_current with direct cmpxchg =E2=
=80=94
> the loser frees its page and retries, avoiding the waste.
>
> That said, I may be missing something. Is there a way to use llist that
> avoids this? I'd appreciate your thoughts.

No, I think you are right, that retry logic in llist_add() does not
work for our case. I think the code you have works, but the way it
uses page attributes is kinda hacky and confusing. If we have to open
code the linked list handling then maybe just do this:

struct pfn_arr_hdr {
    struct pfn_arr *next;
    atomic_t count;
};

#define PFN_ARR_SIZE ((PAGE_SIZE - sizeof(struct pfn_arr_hdr)) /
sizeof(unsigned long))

struct pfn_arr {
    struct pfn_arr_hdr hdr;
    unsigned long pfns[PFN_ARR_SIZE];
};

So, instead of allocating pages, you use kmalloc() to allocate struct
pfn_arr and fill pfn_arr.pfns until it's full using pfn_arr.hdr.count
to track the array size. When current pfn_arr is full, you allocate a
new pfn_arr and link them via pfn_arr.hdr.next atomically, the way you
are doing with pages. That seems cleaner to me. WDYT?


>
>
> >> +                       page =3D new;
> >>                  }
> >> -               new_idx =3D old_idx + 1;
> >> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_i=
dx));
> >> +               idx =3D READ_ONCE(page->private);
> >> +               if (idx >=3D EARLY_PFNS_PER_PAGE)
> >> +                       continue;
> >> +               if (cmpxchg(&page->private, idx, idx + 1) !=3D idx)
> >> +                       continue;
> >> +               break;
> > nit: This would read more easily:
> >
> >                 if (cmpxchg(&page->private, idx, idx + 1) =3D=3D idx)
> >                          break;
> will fix in the next version.
> >
> >> +       } while (1);
> >>
> >> -       early_pfns[old_idx] =3D pfn;
> >> +       ((unsigned long *)page_address(page))[idx] =3D pfn;
> >>   }
> >>
> >> -typedef void alloc_tag_add_func(unsigned long pfn);
> >> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
> >>   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refda=
ta =3D
> >>          RCU_INITIALIZER(__alloc_tag_add_early_pfn);
> >>
> >> -void alloc_tag_add_early_pfn(unsigned long pfn)
> >> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> >>   {
> >>          alloc_tag_add_func *alloc_tag_add;
> >>
> >> @@ -814,13 +818,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
> >>          rcu_read_lock();
> >>          alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr=
);
> >>          if (alloc_tag_add)
> >> -               alloc_tag_add(pfn);
> >> +               alloc_tag_add(pfn, gfp_flags);
> >>          rcu_read_unlock();
> >>   }
> >>
> >>   static void __init clear_early_alloc_pfn_tag_refs(void)
> >>   {
> >> -       unsigned int i;
> >> +       struct page *page, *next;
> >> +       unsigned long i;
> >>
> >>          if (static_key_enabled(&mem_profiling_compressed))
> >>                  return;
> >> @@ -829,37 +834,42 @@ static void __init clear_early_alloc_pfn_tag_ref=
s(void)
> >>          /* Make sure we are not racing with __alloc_tag_add_early_pfn=
() */
> >>          synchronize_rcu();
> >>
> >> -       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> >> -               unsigned long pfn =3D early_pfns[i];
> >> -
> >> -               if (pfn_valid(pfn)) {
> >> -                       struct page *page =3D pfn_to_page(pfn);
> >> -                       union pgtag_ref_handle handle;
> >> -                       union codetag_ref ref;
> >> -
> >> -                       if (get_page_tag_ref(page, &ref, &handle)) {
> >> -                               /*
> >> -                                * An early-allocated page could be fr=
eed and reallocated
> >> -                                * after its page_ext is initialized b=
ut before we clear it.
> >> -                                * In that case, it already has a vali=
d tag set.
> >> -                                * We should not overwrite that valid =
tag with CODETAG_EMPTY.
> >> -                                *
> >> -                                * Note: there is still a small race w=
indow between checking
> >> -                                * ref.ct and calling set_codetag_empt=
y(). We accept this
> >> -                                * race as it's unlikely and the extra=
 complexity of atomic
> >> -                                * cmpxchg is not worth it for this de=
bug-only code path.
> >> -                                */
> >> -                               if (ref.ct) {
> >> +       for (page =3D early_pfn_current; page; page =3D next) {
> >> +               for (i =3D 0; i < page->private; i++) {
> >> +                       unsigned long pfn =3D ((unsigned long *)page_a=
ddress(page))[i];
> > This page_address() can be done in the outer loop since the page does
> > not change inside the inner loop.
> will fix in the next version.
> >> +
> >> +                       if (pfn_valid(pfn)) {
> >> +                               union pgtag_ref_handle handle;
> >> +                               union codetag_ref ref;
> >> +
> >> +                               if (get_page_tag_ref(pfn_to_page(pfn),=
 &ref, &handle)) {
> >> +                                       /*
> >> +                                        * An early-allocated page cou=
ld be freed and reallocated
> >> +                                        * after its page_ext is initi=
alized but before we clear it.
> >> +                                        * In that case, it already ha=
s a valid tag set.
> >> +                                        * We should not overwrite tha=
t valid tag
> >> +                                        * with CODETAG_EMPTY.
> >> +                                        *
> >> +                                        * Note: there is still a smal=
l race window between checking
> >> +                                        * ref.ct and calling set_code=
tag_empty(). We accept this
> >> +                                        * race as it's unlikely and t=
he extra complexity of atomic
> >> +                                        * cmpxchg is not worth it for=
 this debug-only code path.
> >> +                                        */
> >> +                                       if (ref.ct) {
> >> +                                               put_page_tag_ref(handl=
e);
> >> +                                               continue;
> >> +                                       }
> >> +
> >> +                                       set_codetag_empty(&ref);
> >> +                                       update_page_tag_ref(handle, &r=
ef);
> >>                                          put_page_tag_ref(handle);
> >> -                                       continue;
> >>                                  }
> >> -
> >> -                               set_codetag_empty(&ref);
> >> -                               update_page_tag_ref(handle, &ref);
> >> -                               put_page_tag_ref(handle);
> >>                          }
> >>                  }
> >>
> >> +               next =3D (struct page *)page->lru.next;
> >> +               clear_page_tag_ref(page);
> >> +               __free_page(page);
> >>          }
> >>   }
> >>   #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 04494bc2e46f..5b7b234967a5 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
> >>   /* Should be called only if mem_alloc_profiling_enabled() */
> >>   static noinline
> >>   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> >> -                      unsigned int nr)
> >> +                      unsigned int nr, gfp_t gfp_flags)
> >>   {
> >>          union pgtag_ref_handle handle;
> >>          union codetag_ref ref;
> >> @@ -1294,21 +1294,24 @@ void __pgalloc_tag_add(struct page *page, stru=
ct task_struct *task,
> >>                  update_page_tag_ref(handle, &ref);
> >>                  put_page_tag_ref(handle);
> >>          } else {
> >> -               /*
> >> -                * page_ext is not available yet, record the pfn so we=
 can
> >> -                * clear the tag ref later when page_ext is initialize=
d.
> >> -                */
> >> -               alloc_tag_add_early_pfn(page_to_pfn(page));
> >> +
> >>                  if (task->alloc_tag)
> >>                          alloc_tag_set_inaccurate(task->alloc_tag);
> >> +
> >> +               /*
> >> +                * page_ext is not available yet, record the pfn so th=
e
> >> +                * tag ref can be cleared later when page_ext is initi=
alized.
> >> +                */
> >> +               if (should_record_early_pfn(gfp_flags))
> >> +                       alloc_tag_add_early_pfn(page_to_pfn(page), gfp=
_flags);
> > Any reason for changing the order of alloc_tag_add_early_pfn() and
> > alloc_tag_set_inaccurate()? I liked the previous version where we
> > explain why this is done at the very beginning of the block. You could
> > also call should_record_early_pfn() from inside
> > alloc_tag_add_early_pfn(), which would keep both
> > should_record_early_pfn() and __GFP_NO_CODETAG definitions local to
> > alloc_tag.c.
> >
> will fix in the next version.
>
> Thanks
>
> Best regards.
>
> Hao
>
> >>          }
> >>   }
> >>
> >>   static inline void pgalloc_tag_add(struct page *page, struct task_st=
ruct *task,
> >> -                                  unsigned int nr)
> >> +                                  unsigned int nr, gfp_t gfp_flags)
> >>   {
> >>          if (mem_alloc_profiling_enabled())
> >> -               __pgalloc_tag_add(page, task, nr);
> >> +               __pgalloc_tag_add(page, task, nr, gfp_flags);
> >>   }
> >>
> >>   /* Should be called only if mem_alloc_profiling_enabled() */
> >> @@ -1341,7 +1344,7 @@ static inline void pgalloc_tag_sub_pages(struct =
alloc_tag *tag, unsigned int nr)
> >>   #else /* CONFIG_MEM_ALLOC_PROFILING */
> >>
> >>   static inline void pgalloc_tag_add(struct page *page, struct task_st=
ruct *task,
> >> -                                  unsigned int nr) {}
> >> +                                  unsigned int nr, gfp_t gfp_flags) {=
}
> >>   static inline void pgalloc_tag_sub(struct page *page, unsigned int n=
r) {}
> >>   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsi=
gned int nr) {}
> >>
> >> @@ -1896,7 +1899,7 @@ inline void post_alloc_hook(struct page *page, u=
nsigned int order,
> >>
> >>          set_page_owner(page, order, gfp_flags);
> >>          page_table_check_alloc(page, order);
> >> -       pgalloc_tag_add(page, current, 1 << order);
> >> +       pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> >>   }
> >>
> >>   static void prep_new_page(struct page *page, unsigned int order, gfp=
_t gfp_flags,
> >> --
> >> 2.25.1
> >>


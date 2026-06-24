Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06FF8CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46066B0088; Wed, 24 Jun 2026 12:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD00B6B008A; Wed, 24 Jun 2026 12:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A702B6B008C; Wed, 24 Jun 2026 12:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6725E6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:47:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4684140210
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:47:29 +0000 (UTC)
X-FDA: 84915387018.24.12A0040
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6AC24000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:47:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tJYDFnc2;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782319647;
	b=4M39OX4mY6qP9l1eI5R6yUnTmuemjTkHYJrR2tzu+yN/K1RSAS1gEHnnV2/2iMcUjQVF47
	O+FC/ZQQIqxj3o+OtFTZhWXK9wqrfvEDEV1+HECclux48T2dhfOPCSaJYMQdQzX/7PSKvf
	L0DzIhKfeRYjIKVxUoAeL6b0rweONI8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782319647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+9Je2o9tTfENlu3j1udpfuNRxN2OWHhCJKeRxmpxgw=;
	b=r5j1JXBknoNTxRqaIT18skhWm9rzNDwBDQl/Iu1SQZd71UyOE1ri3KlHXNSEl5Nkh/YwGh
	SL0CeP+XHt4RqiE4fGkF3+BD7YHuNeh7bW/mrJK6Eu4jMOnnQ23/VpJipIhwiIPjM/iI36
	K44TlUxQX1ly+isj3o5yH+YxuEq0uMk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tJYDFnc2;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5177d1ff061so344701cf.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:47:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782319647; cv=none;
        d=google.com; s=arc-20260327;
        b=mv6qQY1AuljUe6vn9CqVeJptvy/gJJ1iOp3P7hO8B7UGV7putqxWB9HPRck/y8roA6
         9fKCKSQwxuQVkM8ExVp5dRorh3MdAKdqVP/cf0Gbm256sZvX7LBLi9/M3MB66XJRXqo/
         eLSkolbbUrKMSifYaz6NqhJSS5WKwIKHba0WejplldGKAnKzVLI/Oi4zd0/iVIt9fwB7
         lwZbFvqKIsri3zHcOw2N+UBfO7Dnj+vlIUXkTJeG7lfYAb1D2bVqbXuIxcFwQgJSpVi4
         oKStaCESlPjvCuvESdwAgwye1Zdqxra8qvmmCkzUq9H+Lo+rb9gOPh7ieAyvxdsLpErS
         gBgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8+9Je2o9tTfENlu3j1udpfuNRxN2OWHhCJKeRxmpxgw=;
        fh=O4PMg0VkQ30oEU7oIEwjhHYdrBrBOJdGC1rkos1qCq4=;
        b=hxgpgdKdxf/n7Bo5Y9tf0fhvUeET02AClEW4OzpnaZWq7yeiqv2gR90++A+S7fl4tw
         HQ42NqgKyGCmggbVm8FYGwe7b6G3eNIELMp65a1CmOzAJhINKOBg8AsdCwe9RvKu38qr
         8p2KYuVKjx4Sa8eJ6AFZh5FuDZavczvCjEdh5RLcJqht1nfTWiFu7zx1qJRHTtv4yzuB
         y6u8UzPcdoD+USzzKjZr7cN3fVkGwd2KDBncPOxZEfX7Xx3lZbaF/wH0ChWHQ/P3FQi/
         +Yr4wDwVWSfpAtnqBgzcU3hNSZ3wYJARnfoC4tJX0MN7h7SNU69uZ+ryw2s4vsv3SbkE
         iG7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782319647; x=1782924447; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8+9Je2o9tTfENlu3j1udpfuNRxN2OWHhCJKeRxmpxgw=;
        b=tJYDFnc2aTu+MZ9mR7UtdVd1SeWmOOhE2b1JtrBHGN1jJ1tZoKTwiHogv8TarvPI06
         jtsZ5xvgJVORx38bocjmUUMNnNr1q2QEvKfRRHtgfL6QGFf9nK9l5TEaR1wvdfjWZ48m
         eW5PkODkSmdIB4dfd++sYLllt1deGj4z8Fhd/n99RPmdlZhvF4xVF4YgXDuIPcKKAPDA
         JDatcYM+0m7epvTvyy1lEhpHv7gQVGcCENTvSKiUoYjR6cWbdm9w/n0ovq3MG2JsR0lL
         FXYaiwIGXOiBREFVrowEGMSjHTMAx36UxZ50DVkXjW+S9s05YUuTTtCDFRLio2nIeUCv
         7NbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782319647; x=1782924447;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8+9Je2o9tTfENlu3j1udpfuNRxN2OWHhCJKeRxmpxgw=;
        b=dQa7tuh8wdr4JLq/Cwt25xJ52m72R+uvqhLn2tXTkGGCS54w8QmnYeI7cTlzPrZ7Jy
         Jcu2bX1tUSm6eHkRsHSG9n7X9HjaV7pNB9lEh6i+I5Ee4yPQ9o/nVeZHuBlcQtmf5MSn
         I2ZAVFZogko8X7j8e7tJHVe7C9sdOBn0mqwxK3I06GfdRuavuRtVVHIFtnP9YrhsCHJr
         5pMRuVjVdsUfxjfMR9Clo+eOOz1UdZ02k7zvqVGziB+7FzBTpRYQVi49qltgYHE+5pNZ
         Bjg/jfG9tVnSUdVzqmQq7S7imzPnO3gExUR/sD/T2zT/UlMarU6e5f5xSgRPBGbes7gq
         wn6A==
X-Forwarded-Encrypted: i=1; AFNElJ9KvZa6TgZQNRyx8vZfDiVLG+Hz9/VcdWih5bxXRpgayN+TTZ1ig9Wwu1l6CyDGfmFcY7x3Tt3LVg==@kvack.org
X-Gm-Message-State: AOJu0YymOHfQmSmnRx1k/N4pDLb0fADikIfO2wjpT6RnGkpPynCfn8rU
	4/RBdIccXRu/RsKBXyPtxHfEmfWKVOcgZ30JsCxnysd5sl+opgCA/eKYimSy2VRPlsK10CD3Z8z
	f7NgaM7asyeSjV1tkqBiyrc16IiDBh0PuvX08EUUERf99Qv8OVmPHfYRDojs=
X-Gm-Gg: AfdE7cmw93awNzhyfnmjWCF7rRY93zCrxkaAzSqa6L9+6HI4g7xjEInU0QW6Pka8qk2
	4Hk7a8G+PLv7ophTi6Ka2KBrix6klHC93rsUOXHcensrIC3fPaLOf7KyCSfi/pe+98OOPf+mdQi
	pLd4D0Mc891KtFIDZOsXabVq7LTJNO3/YL8QFj+nyxMImu/ij3JVXmTewko7H4y7ecjIIE5m4oB
	dE58Gf+BCouzqVGqecd9E/k0bdvhDik2oL7mclLKo6coOkBSFewiEw+aneltLJB0QQmgPpqAY2F
	E0YCwOKj9/n69hJ10DPxZprWUr0=
X-Received: by 2002:a05:622a:60a:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-51a62873f9fmr8907821cf.7.1782319645769; Wed, 24 Jun 2026
 09:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-13-31f31367d420@google.com> <6e312b15-d2b5-4137-aa3f-720ec214c7ab@linux.dev>
In-Reply-To: <6e312b15-d2b5-4137-aa3f-720ec214c7ab@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Jun 2026 09:47:14 -0700
X-Gm-Features: AVVi8CcoPlV9iEQoX6YLmAnyKKjtQFFDDFPv2rTtxc_qS18Jw0c0_advHmaKHFw
Message-ID: <CAJuCfpF9-CS-gt1S=tRNaK10yNnnod9DLEe-Y5L3ad5u60Gagg@mail.gmail.com>
Subject: Re: [PATCH v2 13/13] mm: remove __GFP_NO_CODETAG
To: Hao Ge <hao.ge@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Alistair Popple <apopple@nvidia.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6AC24000B
X-Rspam-User: 
X-Stat-Signature: w19qjjyqfsic9csbd574xr9h3kq31gh3
X-HE-Tag: 1782319647-872647
X-HE-Meta: U2FsdGVkX19fA/D3lmyKB3y9ahYoJ2qXuVZPvUUDIvcVh9oFWLYZ+0ELxGUnM8b3VDeidZXn7D5JP810xvR7Z1J2mhZpRcH9cry99DtyO73kTQVggRA2WBbQVptLs0m/bnI8DyDofPvfh2idJcr4w2Qx16tzugpKkampyFEgNkfaIDSOQ/hv0/JZmA+UjrshMsYCXtobWLaomsASJFCxbZvnCOTG9ZkqqSvhwSW27vgDWc8iRjXcu7DbWi2I6B/rkS3Vm2M2GIjdvEe8lWbFF2NSwqfjPV8BCLDoX/lm40toSHr1FyVD32IwAmQQPSY0YI3lc7xZP9zxAJr/ydWfvreSflhYLAN5Ljdrwt/dEDoE3Cm/zIipnmwK+RP4xDlhjwiWVVv7+nCR1DElp02WlR9kK9gId4KtU6Qm+vix+No4xWRfDp60E/DTMd9ib0aMp7vXqnOtq95jtAu5AfhLyDqD5AdyqGM7RlukYDa5o8GBluQL+mcrP5MGGx8CdV+zJ2CcZ0U+y/SqWBSQn+2U7jV6zK+vDZxkBidt7HklXrEnzSB6Z3rXxleVxJd2mr3o2foxaVSslk7LjMTQeLA9KoNn39agl+E9T46tmnBs+LF+w67jeKehtp2V33xm8c0twm3MJjM8/WSJYDQr71Gx/Nhmi4pUR7fa/KimjoAtf2wzkFguAYAQoHYSarTqswH7ABghLfzpUVKDV7DOItEkBW33vkmJCqtmfBAkRLA2L5RQB2sleJJglO9SQbRtFENsGfmvX0fKs2nSGMiPJvgMyZ+8bSZ7w8UiW9mRewnP82rSQ5fY+f0wuk0p1tNR2v6oTmPnlejExDo0P+8bPXYK8oEwZG9AcLFRfjaRdxYehlX7hYhQjZb3wDE8mi1hIx7J0rVRAbjyc/7tXYAkGIEKenpZesIG1udRurpA3+wpNdGp6+wmYTGn7pKg64IQCcGCn4Qlo9HrVYisnfg9BFq
 XHYobaYw
 3J/cddnvIqqWCsIlE4GfnM4B7yfrRcNl6IkdBzLPwPhbKo6zNFU8tfSq+9ao6s+voNBeTHdzZFpoTBiNgJZPU3BlRVoAlAQ+gadjsrRHCkxidoaz2Ek4BsHV9f2JT+cqm1JYw/T2zDTbiLZ2//D+FTygWMzhVs7/J12jRGmTeTRg1bR+2yIc/qLSdACCNd7FhwXPVLZ8S/whXLY+fyisg3G3wPIb4qhqFbIYaQvtr0JnRPN2dH9WCCxOV6OayV79KvQZqEaAMw6OuU8gd4lMTV5SFgKbwOeaCVWffCZhuRfb3hyKgI/NsgUzSXpEv3kigYMqI90m8g9usuEby5cXoC0QvtV0yR1H0si3P0SncB+FVhAv05FZ/brw8Ytnx0BJYEXOAofPm5Ci4zxorfpR7cp42vz5X9UPwpGSR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 12:57=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Brendan
>
>
> On 2026/6/22 18:01, Brendan Jackman wrote:
> > Now that alloc_pages has an entrypoint that allows passing alloc_flags,
> > we can take advantage of this to start removing GFP flags that are only
> > used for mm-internal stuff.
> >
> > This requires also plumbing the alloc_flags into some more of the
> > allocator code, in particular __alloc_pages[_noprof]() gets an
> > alloc_flags arg to go along with its callees, and we now need to pass
> > those flags deeper into the allocator so they can reach the alloc_tag
> > code.
> >
> > To try and keep the new ALLOC_NO_CODETAG's scope nice and narrow, don't
> > define it in mm/internal.h, instead just define a "reserved bit" and
> > then use that in places that don't care about what it means.

I don't understand why you want to narrow down visibility of one of
the alloc_flag bits. We don't do that for any other flags, and this
seems like an unnecessary complexity.

> >
> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
>
> Nit: The title says "remove __GFP_NO_CODETAG" but the flag isn't really
> removed =E2=80=94 it's migrated from gfp_t to alloc_flags as
>
> ALLOC_NO_CODETAG. Something like "mm: replace __GFP_NO_CODETAG with an
> alloc_flag" would be more accurate.
>
>
> Additionally, as Lorenzo pointed out in another thread, you will likely
> need to rebase this series later.
>
> I noticed Vlastimil has already landed the slab changes removing
> __GFP_NO_OBJ_EXT into mainline:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?=
id=3D335c347686e76df9d2c7d7f61b5ea627a4c5cb4c
>
> For v3, it might make sense to fold in Vlastimil's patch so the full
> removal of __GFP_NO_OBJ_EXT can be completed end-to-end
>
> https://lore.kernel.org/all/20260609-slab_alloc_flags-v1-15-2bf4a4b9b526@=
kernel.org/

I think Vlastimil's patch will be merged before this one, so this
patch could remove __GFP_NO_OBJ_EXT complely, saying that its last
user (__GFP_NO_CODETAG) is gone.

>
>
> > ---
> >   mm/alloc_tag.c       | 18 ++++++++++--------
> >   mm/compaction.c      |  4 ++--
> >   mm/internal.h        |  8 ++++++--
> >   mm/page_alloc.c      | 42 ++++++++++++++++++++++++------------------
> >   mm/page_frag_cache.c |  4 ++--
> >   5 files changed, 44 insertions(+), 32 deletions(-)
> >
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index d9be1cf5187d9..61a6cba32ff35 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -15,6 +15,8 @@
> >   #include <linux/vmalloc.h>
> >   #include <linux/kmemleak.h>
> >
> > +#include "internal.h"
> > +
> >   #define ALLOCINFO_FILE_NAME         "allocinfo"
> >   #define MODULE_ALLOC_TAG_VMAP_SIZE  (100000UL * sizeof(struct alloc_t=
ag))
> >   #define SECTION_START(NAME)         (CODETAG_SECTION_START_PREFIX NAM=
E)
> > @@ -785,16 +787,15 @@ struct pfn_pool {
> >                                        sizeof(unsigned long))
> >
> >   /*
> > - * Skip early PFN recording for a page allocation.  Reuses the
> > - * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoi=
d
> > - * recursion when allocating pages for the early PFN tracking list
> > - * itself.
> > + * Skip early PFN recording for a page allocation.  Used by
> > + * __alloc_tag_add_early_pfn() to avoid recursion when allocating page=
s for the
> > + * early PFN tracking list itself.
> >    *
> >    * Codetags of the pages allocated with __GFP_NO_CODETAG should be
> >    * cleared (via clear_page_tag_ref()) before freeing the pages to pre=
vent
> >    * alloc_tag_sub_check() from triggering a warning.
> >    */
> > -#define __GFP_NO_CODETAG             __GFP_NO_OBJ_EXT
> > +#define ALLOC_NO_CODETAG             __ALLOC_ALLOC_TAG
> >
> >   static struct pfn_pool *current_pfn_pool __initdata;
> >
> > @@ -806,7 +807,8 @@ static void __init __alloc_tag_add_early_pfn(unsign=
ed long pfn)
> >       do {
> >               pool =3D READ_ONCE(current_pfn_pool);
> >               if (!pool || atomic_read(&pool->count) >=3D PFN_POOL_SIZE=
) {
> > -                     struct page *new_page =3D alloc_page(__GFP_HIGH |=
 __GFP_NO_CODETAG);
> > +                     struct page *new_page =3D __alloc_pages(__GFP_HIG=
H, 0, numa_mem_id(),
> > +                                                           NULL, ALLOC=
_NO_CODETAG);
> >                       struct pfn_pool *new;
> >
> >                       if (!new_page) {
> > @@ -837,7 +839,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
> >   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdat=
a =3D
> >       RCU_INITIALIZER(__alloc_tag_add_early_pfn);
> >
> > -void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> > +void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_fla=
gs)
>
>
> alloc_tag_add_early_pfn is actually declared in include/linux/alloc_tag.h=
,
>
> so we need to update this header in sync as well.
>
> include/linux/alloc_tag.h:166:void alloc_tag_add_early_pfn(unsigned long
> pfn, gfp_t gfp_flags);
> include/linux/alloc_tag.h:170:static inline void
> alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
>
>
> >   {
> >       alloc_tag_add_func *alloc_tag_add;
> >
> > @@ -845,7 +847,7 @@ void alloc_tag_add_early_pfn(unsigned long pfn, gfp=
_t gfp_flags)
> >               return;
> >
> >       /* Skip allocations for the tracking list itself to avoid recursi=
on. */
> > -     if (gfp_flags & __GFP_NO_CODETAG)
> > +     if (alloc_flags & ALLOC_NO_CODETAG)
> >               return;
> >
> >       rcu_read_lock();
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index b776f35ad0200..e90ebd2c54f48 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -82,7 +82,7 @@ static inline bool is_via_compact_memory(int order) {=
 return false; }
> >
> >   static struct page *mark_allocated_noprof(struct page *page, unsigned=
 int order, gfp_t gfp_flags)
> >   {
> > -     post_alloc_hook(page, order, __GFP_MOVABLE);
> > +     post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
> >       set_page_refcounted(page);
> >       return page;
> >   }
> > @@ -1850,7 +1850,7 @@ static struct folio *compaction_alloc_noprof(stru=
ct folio *src, unsigned long da
> >       }
> >       dst =3D (struct folio *)freepage;
> >
> > -     post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
> > +     post_alloc_hook(&dst->page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
> >       set_page_refcounted(&dst->page);
> >       if (order)
> >               prep_compound_page(&dst->page, order);
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 0847b55bfc147..a45bedb9ada5f 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -684,6 +684,8 @@ struct alloc_context {
> >        */
> >       enum zone_type highest_zoneidx;
> >       bool spread_dirty_pages;
> > +     /* Only flags that are global to the whole allocation go here. */
> > +     unsigned int alloc_flags;
> >   };
> >
> >   /*
> > @@ -907,7 +909,8 @@ static inline void init_compound_tail(struct page *=
tail,
> >       prep_compound_tail(tail, head, order);
> >   }
> >
> > -void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_=
flags);
> > +void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_=
flags,
> > +                  unsigned int alloc_flags);
> >   extern bool free_pages_prepare(struct page *page, unsigned int order)=
;
> >
> >   extern int user_min_free_kbytes;
> > @@ -1481,6 +1484,7 @@ unsigned int reclaim_clean_pages_from_list(struct=
 zone *zone,
> >   #define ALLOC_HIGHATOMIC    0x200 /* Allows access to MIGRATE_HIGHATO=
MIC */
> >   #define ALLOC_NOLOCK                0x400 /* Only use spin_trylock in=
 allocation path */
> >   #define ALLOC_KSWAPD                0x800 /* allow waking of kswapd, =
__GFP_KSWAPD_RECLAIM set */
> > +#define __ALLOC_ALLOC_TAG      0x1000 /* Reserved bit for use by alloc=
_tag code */
> >
> >   /* Flags that allow allocations below the min watermark. */
> >   #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHA=
TOMIC|ALLOC_OOM)
> > @@ -1956,7 +1960,7 @@ bool may_expand_vm(struct mm_struct *mm, const vm=
a_flags_t *vma_flags,
> >                  unsigned long npages);
> >
> >   struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int =
preferred_nid,
> > -             nodemask_t *nodemask);
> > +             nodemask_t *nodemask, unsigned int alloc_flags);
> >   #define __alloc_pages(...)                  alloc_hooks(__alloc_pages=
_noprof(__VA_ARGS__))
> >
> >   #endif      /* __MM_INTERNAL_H */
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d99e4ea8307ea..d50fd9c77a2e8 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1246,7 +1246,7 @@ void __clear_page_tag_ref(struct page *page)
> >   /* Should be called only if mem_alloc_profiling_enabled() */
> >   static noinline
> >   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> > -                    unsigned int nr, gfp_t gfp_flags)
> > +                    unsigned int nr, unsigned int alloc_flags)
> >   {
> >       union pgtag_ref_handle handle;
> >       union codetag_ref ref;
> > @@ -1260,17 +1260,17 @@ void __pgalloc_tag_add(struct page *page, struc=
t task_struct *task,
> >                * page_ext is not available yet, record the pfn so we ca=
n
> >                * clear the tag ref later when page_ext is initialized.
> >                */
> > -             alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
> > +             alloc_tag_add_early_pfn(page_to_pfn(page), alloc_flags);
> >               if (task->alloc_tag)
> >                       alloc_tag_set_inaccurate(task->alloc_tag);
> >       }
> >   }
> >
> >   static inline void pgalloc_tag_add(struct page *page, struct task_str=
uct *task,
> > -                                unsigned int nr, gfp_t gfp_flags)
> > +                                unsigned int nr, unsigned int alloc_fl=
ags)
>
>
> The pgalloc_tag_add() stub in the non-CONFIG_MEM_ALLOC_PROFILING build
> could use the same parameter types for consistency

Umm, correction. It *should* use the same parameter type. It's
unfortunate that the compiler doesn't catch this...

>
>
> Thanks
>
> Best Regards
>
> Hao
>
>
> >   {
> >       if (mem_alloc_profiling_enabled())
> > -             __pgalloc_tag_add(page, task, nr, gfp_flags);
> > +             __pgalloc_tag_add(page, task, nr, alloc_flags);
> >   }
> >
> >   /* Should be called only if mem_alloc_profiling_enabled() */
> > @@ -1807,7 +1807,7 @@ static inline bool should_skip_init(gfp_t flags)
> >   }
> >
> >   inline void post_alloc_hook(struct page *page, unsigned int order,
> > -                             gfp_t gfp_flags)
> > +                             gfp_t gfp_flags, unsigned int alloc_flags=
)
> >   {
> >       const bool zero_tags =3D gfp_flags & __GFP_ZEROTAGS;
> >       bool init =3D !want_init_on_free() && want_init_on_alloc(gfp_flag=
s) &&
> > @@ -1858,13 +1858,13 @@ inline void post_alloc_hook(struct page *page, =
unsigned int order,
> >
> >       set_page_owner(page, order, gfp_flags);
> >       page_table_check_alloc(page, order);
> > -     pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> > +     pgalloc_tag_add(page, current, 1 << order, alloc_flags);
> >   }
> >
> >   static void prep_new_page(struct page *page, unsigned int order, gfp_=
t gfp_flags,
> >                                                       unsigned int allo=
c_flags)
> >   {
> > -     post_alloc_hook(page, order, gfp_flags);
> > +     post_alloc_hook(page, order, gfp_flags, alloc_flags);
> >
> >       if (order && (gfp_flags & __GFP_COMP))
> >               prep_compound_page(page, order);
> > @@ -4773,8 +4773,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned =
int order,
> >        * The fast path uses conservative alloc_flags to succeed only un=
til
> >        * kswapd needs to be woken up, and to avoid the cost of setting =
up
> >        * alloc_flags precisely. So we do that now.
> > +      *
> > +      * Can't just or alloc_flags if it contains WMARK bits, but those=
 flags
> > +      * shouldn't be set in ac->alloc_flags.
> >        */
> > -     alloc_flags =3D slowpath_alloc_flags(gfp_mask, order);
> > +     VM_WARN_ON(ac->alloc_flags & ALLOC_WMARK_MASK);
> > +     alloc_flags =3D ac->alloc_flags | slowpath_alloc_flags(gfp_mask, =
order);
> >
> >       /*
> >        * We need to recalculate the starting point for the zonelist ite=
rator
> > @@ -4816,7 +4820,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned i=
nt order,
> >       reserve_flags =3D __gfp_pfmemalloc_flags(gfp_mask);
> >       if (reserve_flags)
> >               alloc_flags =3D cma_alloc_flags(gfp_mask, reserve_flags) =
|
> > -                                       (alloc_flags & ALLOC_KSWAPD);
> > +                             ac->alloc_flags | (alloc_flags & ALLOC_KS=
WAPD);
> >
> >       /*
> >        * Reset the nodemask and zonelist iterators if memory policies c=
an be
> > @@ -5218,7 +5222,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, =
int preferred_nid,
> >       return nr_populated;
> >
> >   failed:
> > -     page =3D __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
> > +     page =3D __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, AL=
LOC_DEFAULT);
> >       if (page)
> >               page_array[nr_populated++] =3D page;
> >       goto out;
> > @@ -5326,11 +5330,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t =
gfp, unsigned int order,
> >   {
> >       struct page *page;
> >       gfp_t alloc_gfp; /* The gfp_t that was actually used for allocati=
on */
> > -     struct alloc_context ac =3D { };
> > +     struct alloc_context ac =3D {
> > +             .alloc_flags =3D alloc_flags,
> > +     };
> >       unsigned int fastpath_alloc_flags =3D alloc_flags;
> >
> >       /* Other flags could be supported later if needed. */
> > -     if (WARN_ON(alloc_flags & ~ALLOC_NOLOCK))
> > +     if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | __ALLOC_ALLOC_TAG)))
> >               return NULL;
> >
> >       if (!alloc_order_allowed(gfp, order, alloc_flags))
> > @@ -5398,12 +5404,12 @@ struct page *__alloc_frozen_pages_noprof(gfp_t =
gfp, unsigned int order,
> >   EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
> >
> >   struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
> > -             int preferred_nid, nodemask_t *nodemask)
> > +             int preferred_nid, nodemask_t *nodemask, unsigned int all=
oc_flags)
> >   {
> >       struct page *page;
> >
> >       page =3D __alloc_frozen_pages_noprof(gfp, order, preferred_nid, n=
odemask,
> > -                                        ALLOC_DEFAULT);
> > +                                        alloc_flags);
> >       if (page)
> >               set_page_refcounted(page);
> >       return page;
> > @@ -5418,14 +5424,14 @@ struct page *alloc_pages_node_noprof(int nid, g=
fp_t gfp_mask, unsigned int order
> >       VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
> >       warn_if_node_offline(nid, gfp_mask);
> >
> > -     return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
> > +     return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEF=
AULT);
> >   }
> >
> >   struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int=
 preferred_nid,
> >               nodemask_t *nodemask)
> >   {
> >       struct page *page =3D __alloc_pages_noprof(gfp | __GFP_COMP, orde=
r,
> > -                                     preferred_nid, nodemask);
> > +                                     preferred_nid, nodemask, ALLOC_DE=
FAULT);
> >       return page_rmappable_folio(page);
> >   }
> >   EXPORT_SYMBOL(__folio_alloc_noprof);
> > @@ -7107,7 +7113,7 @@ static void split_free_frozen_pages(struct list_h=
ead *list, gfp_t gfp_mask)
> >               list_for_each_entry_safe(page, next, &list[order], lru) {
> >                       int i;
> >
> > -                     post_alloc_hook(page, order, gfp_mask);
> > +                     post_alloc_hook(page, order, gfp_mask, ALLOC_DEFA=
ULT);
> >                       if (!order)
> >                               continue;
> >
> > @@ -7312,7 +7318,7 @@ int alloc_contig_frozen_range_noprof(unsigned lon=
g start, unsigned long end,
> >               struct page *head =3D pfn_to_page(start);
> >
> >               check_new_pages(head, order);
> > -             prep_new_page(head, order, gfp_mask, 0);
> > +             prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
> >       } else {
> >               ret =3D -EINVAL;
> >               WARN(true, "PFN range: requested [%lu, %lu), allocated [%=
lu, %lu)\n",
> > diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
> > index d2423f30577e4..d9573170e0719 100644
> > --- a/mm/page_frag_cache.c
> > +++ b/mm/page_frag_cache.c
> > @@ -57,10 +57,10 @@ static struct page *__page_frag_cache_refill(struct=
 page_frag_cache *nc,
> >       gfp_mask =3D (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
> >                  __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
> >       page =3D __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
> > -                          numa_mem_id(), NULL);
> > +                          numa_mem_id(), NULL, ALLOC_DEFAULT);
> >   #endif
> >       if (unlikely(!page)) {
> > -             page =3D __alloc_pages(gfp, 0, numa_mem_id(), NULL);
> > +             page =3D __alloc_pages(gfp, 0, numa_mem_id(), NULL, ALLOC=
_DEFAULT);
> >               order =3D 0;
> >       }
> >
> >


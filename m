Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE586C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32AB6B00B1; Mon,  6 Jul 2026 14:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A746B00C2; Mon,  6 Jul 2026 14:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCF66B00C4; Mon,  6 Jul 2026 14:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B55E6B00B1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:28:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E97581201CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:28:43 +0000 (UTC)
X-FDA: 84959187726.23.5C0464F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6B73A20004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:28:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DIl/fhfI";
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33zy+d4yennwdrD0MnMHA1IqKApRwE8j9BcF6Z0iXAU=;
	b=BCeBI+tleFJkfeIRUCIefK9wv9Yqigw8bqJTweYq5xGWi8Y6dnLJ9aw9DOyuhTFZ+4K/iu
	2hsZCxFnBY0YBX22W2wSAX5rO/+hPClMkQRQlITVTsh3EEec0g+eY83qCm7BPyMZYA9W2b
	mHm7vZA+IvgsxOCYYll6mZ9jsLmJMtY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DIl/fhfI";
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362521;
	b=Yh3hykt7Lf3b+Uvh8uWNnVzDepIuNM7DLbEzXTFGD/F1fqaMgc/MlnbWqbEAEUPzpXDw4B
	NPkZ9puObhOYBjUtPqQcPnPAPSnpBEIgOnx+rmAj8y/tBaFpg1vaZgewGp3vHnMFPYi+AB
	VdvUWQPwmE9/ToPmuUhF9yLztc17+KE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783362520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33zy+d4yennwdrD0MnMHA1IqKApRwE8j9BcF6Z0iXAU=;
	b=DIl/fhfIzzFPf/HnwSCcSyAu8u4jPPhDnPPW0T6ES91HylIE5bihWfr5HnWxwJ38AnTzQ2
	CADn/4dMCyPkz2vG+VMLIa5evmvxYuvq2vUUhbrvA7Jdz+mi7ICbVKM3u1BQmp1WXn7UOX
	iravGD/K5vlTk5Mxj5X8i6SqjXpEgPU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-d2QkC8ooNT-xqZxYMs-FdA-1; Mon, 06 Jul 2026 14:28:39 -0400
X-MC-Unique: d2QkC8ooNT-xqZxYMs-FdA-1
X-Mimecast-MFC-AGG-ID: d2QkC8ooNT-xqZxYMs-FdA_1783362518
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-39ada0874c0so22698451fa.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362518; x=1783967318;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=33zy+d4yennwdrD0MnMHA1IqKApRwE8j9BcF6Z0iXAU=;
        b=DVTc88JKK/xS9IRHEnSoaZ37yLxDosefXKJurnlCgMsV0Onwcy+Ssq7LMSHGrYrIAN
         mW05pf3nd3WMwVCjvATiXfeLkJ5XY0GqzodTlwTdG6Wb7n5QbYQKvkO5WIwXyI0RyIBg
         YndpA+6BGgOJ9R2m8zIM01CFEBJOg6r/aHYMWW8RU7WSHfyo3PIqoYAT7abWymdG1WH5
         ZV+vXNhtY8N1zRU7o2jVsYAKmaAiI1rg+jhMLFdAwHnaHGrLk5mEipjiE7kEsaBxFs7g
         mW7Mhw9xvbQLqAnC/uRp1YF+jF1SMBQPFc4oEoZLnJsdE3aR5zP0rwt/nf0TrwQeJZOh
         wAdA==
X-Forwarded-Encrypted: i=1; AHgh+Rq552AO2Nt8l7MyUGQKY1Wdgt7u9sUfRC7vO7WwvQ0GxgH3DFjdflSVMpFeTY7MYqpLHOI6E/3OGQ==@kvack.org
X-Gm-Message-State: AOJu0YxcnW/6+Mil8/Ll2QHaPLhgquPB9mhmEfuLW8I14QufjaI/qgQ0
	p4H5qLVnNeqhMFOvGG/brL1+CHJcECDKHj5wySIZfc1SXvywS5VF9IqPoeQxC3eFKNl7TUtVGt/
	HVXwRWQfe7J3+GMGM+HI7hig5qprQ4tttWHzxF6e+LrUWurvq7JVD7kqgojN062aYdUdSDZr3bQ
	LA8gpqno/o4t7fm5oP8u+ikL3ThUA=
X-Gm-Gg: AfdE7ckh57Do6RSj5NK320oL4y8mQSOAROJ59IBs50x0QtdO4vjHdmIa5A9qppnj0bY
	0WeDSi4nJgBdwjoORw/rUaYPVY+GG8Iuo9gH+iImnPslD00AvnfWpaQjYuT1zkbpjRmDWDIOEev
	UE8ZWYyX9jkGP0eKnUu7jDaXVpnAE+9/9uzwGpH+nchxjnxmNVMk8xKIUyofgcE8G0
X-Received: by 2002:a2e:7a02:0:b0:396:7a05:6ed7 with SMTP id 38308e7fff4ca-39c5fd2fdb4mr3469721fa.2.1783362517809;
        Mon, 06 Jul 2026 11:28:37 -0700 (PDT)
X-Received: by 2002:a2e:7a02:0:b0:396:7a05:6ed7 with SMTP id
 38308e7fff4ca-39c5fd2fdb4mr3469661fa.2.1783362517222; Mon, 06 Jul 2026
 11:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260706154500.39178-6-npache@redhat.com> <20260706174849.939490-1-usama.arif@linux.dev>
In-Reply-To: <20260706174849.939490-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Mon, 6 Jul 2026 12:29:47 -0600
X-Gm-Features: AVVi8CdVDHmZBsUQxsnlnAreAvd7DeSBfwwmvmZHKdLG52P9AfudUCCQoHtl6RI
Message-ID: <CAA1CXcBDQHtYqYMYMDm36hVCMPMGC9MMMDdeetpX89iFpfg6wQ@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/khugepaged: Refactor the PTE state checks into a helper
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ETG3PRU_-2EiIC3EUtkHDSiGH2HGHBbFHwm4SyULgY4_1783362518
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B73A20004
X-Stat-Signature: iiepcnsyzp58nu9q63wra7xzgysgtz3p
X-HE-Tag: 1783362521-441792
X-HE-Meta: U2FsdGVkX18RaiVtuRgcth0hkVcp42bnm+I3ucJs3Ou7XcW4/JsVX27AQAT0m2d/QnSt3XfBt4XmUJGs91GEvWx6HFdMT6iSr75RcRb1Vg/0PBWZqVO9pRro/rmOfh0QD8OZb7qFhisUSZ+QbIzYcJTp0p88uEbhnB8mVdQFdFmu5/vTxt787y0U8zcnc1fBqj5SchUwka9cQtHiio96O5MBel3s4eDZ7zN6bbNCS2QsOv2TeGCu7peN8YW1UkBeGuh1C1uAMh1vcV4LGtTZ8HCZRkTUDlhlDHagSgmDs2wS+jmiWl3T8rWTuH55PFJQ6bL4+49P8jtdRjWieJ0AheTth9f5wXGA6i3IGqvkvn4kq7/xcrY5hg9jYmwm76pzN5nylXTFvtAjvUy+b5Upe6uPZp9Inns01O0ysASBgPmfuPtUpnROWvZnWB4Do81+lAXofP2//R2o0Tv4G7gmpwRCRMYAQcUYM4zIk74uLuZ6A7BN3j8nFaYl2fPgKu9zHJKuKwU2yUY3FJ6W3L3wwneNEICRSxdW0Vqkk/s4DZXGR2iP3M8LYTSkJJnZYV/5Y5n+vb8AYZ/PpeU0XPtdl6+IVNeGhXP7707jNxboEl/sDK9yU8YHiupXuL/+t0YaBak82ciVFEJLnV/Eow0aevuc0SxkKqTocfehYQBw5d2pUkTAJy8ygOaeKJEwyB6kJOyrBGbf6+8UJYKigxHj5tA3YjTw+eHMpm07YKDa3LKxQUYb5JZKUASe39SSAIgeRRAc4/kzGASk1bGdBZETh9pCoSbG5Tzq3VJR784R7hAXT4lFPO2CecF3Lw0Zn75YVv9bkJhXtFul+OxzptUEaZGw++dgEKuEGiDbf34iMjScmjs/DdLkd5nFytP/rG+0rTsQ1R9JwOM4kaWq0V9Nu8CBPBWqCFPS99AC7Zxa2odvgJ/tjoHOol7pqOYPgADu/BH1mjrAu4vlgmXPDJD
 bUKF6diB
 Zb0aYu9/uRD/4sHsudadkb3wnEJArFsTqU0tMwTE2WTnEhvjAPBX+umGf3gkH14m+GJU2mTbnn6t9f0D2gdOr22zWzQIQOkVy0ZfSa3Ohf3WEb7Bpk2CIz4KHMXisYorbWmYeerfDYBo50IIIF+kZAIg2zWMNcD818hWQcJ3BT7A50SiStKT4LgO77G4cvxQjuyrMYjrniWrDYpk+NQvdrPM9wIywl79ra0s2WrC+vtJCsVn22poHCDPBC2jMAPOWHAfv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 11:49=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> On Mon,  6 Jul 2026 09:44:52 -0600 Nico Pache <npache@redhat.com> wrote:
>
> > For anonymous collapse, the collapse_scan_pmd() and
> > __collapse_huge_page_isolate() functions share a large portion of their
> > logic. These functions both check the state of the PTEs and verify the
> > following:
> >       - max_pte_* values are not exceeded
> >       - uffd is not active
> >       - lazyfree properties
> >       - non-anonymous
> >
> > Merge these checks into a helper collapse_check_pte() to reduce code
> > duplication. We also add a helper struct for this function called
> > pte_check_context which allows us to pass the required parameters in a
> > clean and elegant manner.
> >
> > A helper function is also introduced pte_check_fail() to provide a clea=
n
> > interface to set the pte_check_context failure results and return
> > PTE_CHECK_FAIL state. This helps reduce code duplications across the ne=
w
> > collapse_check_pte function.
> >
> > Two slight modifications are done to the original functionality. We now
> > warn (instead of crash) if the anon test fails, and we leverage the
> > vm_normal_folio function instead of page->folio, this should be
> > functionally equivalent.
> >
> > No other functional changes intended.
> >
> > This patch is heavily based off work done by Lance Yang, but modified t=
o
> > deal with conflicts and feedback received during the review cycle [1].
> >
> > [1] https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux=
.dev/
> > Suggested-by: David Hildenbrand <david@kernel.org>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 295 +++++++++++++++++++++++++-----------------------
> >  1 file changed, 155 insertions(+), 140 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 676f75773a6c..c4ea2dc1591b 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -63,6 +63,12 @@ enum scan_result {
> >       SCAN_PAGE_DIRTY_OR_WRITEBACK,
> >  };
> >
> > +enum pte_check_result {
> > +     PTE_CHECK_SUCCEED,
> > +     PTE_CHECK_FAIL,
> > +     PTE_CHECK_CONTINUE,
> > +};
> > +
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/huge_memory.h>
> >
> > @@ -117,6 +123,20 @@ struct collapse_control {
> >       DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
> >  };
> >
> > +struct pte_check_context {
> > +     struct collapse_control *cc;
> > +     struct vm_area_struct *vma;
> > +     unsigned int order;
> > +     struct folio *folio;
> > +     int none_or_zero;
> > +     int shared;
> > +     int unmapped;
> > +     enum scan_result result;
> > +     unsigned int max_ptes_none;
> > +     unsigned int max_ptes_swap;
> > +     unsigned int max_ptes_shared;
> > +};
> > +
> >  /**
> >   * struct khugepaged_scan - cursor for scanning
> >   * @mm_head: the head of the mm list to scan
> > @@ -700,74 +720,130 @@ static void count_collapse_event(unsigned int or=
der, enum vm_event_item vm_event
> >       count_mthp_stat(order, mthp_event);
> >  }
> >
> > +/*
> > + * pte_check_fail() - A simple helper to set the pte_check_context res=
ult and
> > + * return PTE_CHECK_FAIL.
> > + */
> > +static enum pte_check_result pte_check_fail(struct pte_check_context *=
ctx,
> > +             enum scan_result result)
> > +{
> > +     ctx->result =3D result;
> > +     return PTE_CHECK_FAIL;
> > +}
> > +
> > +/*
> > + * collapse_check_pte() - Check if a PTE is suitable for collapse
> > + *
> > + * Check if a PTE is suitable for collapse based on the following crit=
eria:
> > + * - max_pte_* values are not exceeded
> > + * - uffd is not active
> > + * - lazyfree properties are not present
> > + * - only anonymous pages are present
> > + *
> > + * a helper struct pte_check_context is used to pass and store relevan=
t
> > + * information between the collapse_check_pte() function and the calle=
r.
> > + *
> > + * Return: PTE_CHECK_SUCCEED if the PTE is suitable for collapse,
> > + *         PTE_CHECK_FAIL if the PTE is not suitable for collapse,
> > + *         PTE_CHECK_CONTINUE if the scan should continue to check the=
 next PTE.
> > + */
> > +static enum pte_check_result collapse_check_pte(pte_t pteval,
> > +             unsigned long addr, struct pte_check_context *ctx)
> > +{
> > +     if (pte_none_or_zero(pteval)) {
> > +             if (++ctx->none_or_zero > ctx->max_ptes_none) {
> > +                     count_collapse_event(ctx->order, THP_SCAN_EXCEED_=
NONE_PTE,
> > +                                     MTHP_STAT_COLLAPSE_EXCEED_NONE);
> > +                     return pte_check_fail(ctx, SCAN_EXCEED_NONE_PTE);
> > +             }
> > +             return PTE_CHECK_CONTINUE;
> > +     }
> > +     if (!pte_present(pteval)) {
> > +             if (ctx->unmapped =3D=3D -1)
> > +                     return pte_check_fail(ctx, SCAN_PTE_NON_PRESENT);
> > +             if (++ctx->unmapped > ctx->max_ptes_swap) {
> > +                     count_collapse_event(ctx->order, THP_SCAN_EXCEED_=
SWAP_PTE,
> > +                                     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> > +                     return pte_check_fail(ctx, SCAN_EXCEED_SWAP_PTE);
> > +             }
> > +             if (pte_swp_uffd_wp_any(pteval))
> > +                     return pte_check_fail(ctx, SCAN_PTE_UFFD_WP);
> > +             return PTE_CHECK_CONTINUE;
> > +     }
> > +     /*
> > +      * Don't collapse if any of the small PTEs are armed with uffd
> > +      * write protection. Marking the new huge pmd as write protected
> > +      * could bring userfault messages that fall outside of the
> > +      * registered range.
> > +      */
> > +     if (pte_uffd_wp(pteval))
> > +             return pte_check_fail(ctx, SCAN_PTE_UFFD_WP);
> > +
> > +     ctx->folio =3D vm_normal_folio(ctx->vma, addr, pteval);
> > +     if (unlikely(!ctx->folio) || unlikely(folio_is_zone_device(ctx->f=
olio)))
> > +             return pte_check_fail(ctx, SCAN_PAGE_NULL);
> > +
> > +     /*
> > +      * If the vma has the VM_DROPPABLE flag, the collapse will
> > +      * preserve the lazyfree property without needing to skip.
> > +      */
> > +     if (ctx->cc->is_khugepaged && !(ctx->vma->vm_flags & VM_DROPPABLE=
) &&
> > +         folio_test_lazyfree(ctx->folio) && !pte_dirty(pteval))
> > +             return pte_check_fail(ctx, SCAN_PAGE_LAZYFREE);
> > +
> > +     if (folio_maybe_mapped_shared(ctx->folio)) {
> > +             /*
> > +              * TODO: Support shared pages without leading to further
> > +              * mTHP collapses. Currently bringing in new pages via
> > +              * shared may cause a future higher order collapse on a
> > +              * rescan of the same range.
> > +              */
> > +             if (++ctx->shared > ctx->max_ptes_shared) {
> > +                     count_collapse_event(ctx->order, THP_SCAN_EXCEED_=
SHARED_PTE,
> > +                                     MTHP_STAT_COLLAPSE_EXCEED_SHARED)=
;
> > +                     return pte_check_fail(ctx, SCAN_EXCEED_SHARED_PTE=
);
> > +             }
> > +     }
> > +
> > +     if (!folio_test_anon(ctx->folio)) {
> > +             VM_WARN_ON_FOLIO(!folio_test_anon(ctx->folio), ctx->folio=
);
> > +             return pte_check_fail(ctx, SCAN_PAGE_ANON);
> > +     }
>
> The order folio_maybe_mapped_shared() and !folio_test_anon() check is fli=
pped
> from what it was. Can we keep original ordering? The commit message says
> no other functional change inteded, but this could result in different co=
llapse
> even counters getting incremented.

Good catch, I didn't realize i reordered it.

It might make even more sense to move it to right after we get the
folio. All other checks are pointless are we somehow landed on a
!(anon) page.

Does that sound better?

>
>
> > +     return PTE_CHECK_SUCCEED;
> > +}
> > +
> >  static enum scan_result __collapse_huge_page_isolate(struct vm_area_st=
ruct *vma,
> >               unsigned long start_addr, pte_t *pte, struct collapse_con=
trol *cc,
> >               unsigned int order, struct list_head *compound_pagelist)
> >  {
> > -     const unsigned int max_ptes_none =3D collapse_max_ptes_none(cc, v=
ma, order);
> > -     const unsigned int max_ptes_shared =3D collapse_max_ptes_shared(c=
c, order);
> >       const unsigned long nr_pages =3D 1UL << order;
> > -     struct page *page =3D NULL;
> >       struct folio *folio =3D NULL;
> >       unsigned long addr =3D start_addr;
> > -     pte_t *_pte;
> > -     int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> > +     pte_t *_pte, pteval;
> > +     int referenced =3D 0;
> >       enum scan_result result =3D SCAN_FAIL;
> > +     enum pte_check_result pte_check;
> > +     struct pte_check_context ctx =3D {
> > +             .cc =3D cc,
> > +             .vma =3D vma,
> > +             .order =3D order,
> > +             .unmapped =3D -1, /* don't check swap PTEs */
> > +             .max_ptes_none =3D collapse_max_ptes_none(cc, vma, order)=
,
> > +             .max_ptes_shared =3D collapse_max_ptes_shared(cc, order),
> > +     };
> >
> >       for (_pte =3D pte; _pte < pte + nr_pages;
> >            _pte++, addr +=3D PAGE_SIZE) {
> > -             pte_t pteval =3D ptep_get(_pte);
> > -             if (pte_none_or_zero(pteval)) {
> > -                     if (++none_or_zero > max_ptes_none) {
> > -                             result =3D SCAN_EXCEED_NONE_PTE;
> > -                             count_collapse_event(order, THP_SCAN_EXCE=
ED_NONE_PTE,
> > -                                             MTHP_STAT_COLLAPSE_EXCEED=
_NONE);
> > -                             goto out;
> > -                     }
> > -                     continue;
> > -             }
> > -             if (!pte_present(pteval)) {
> > -                     result =3D SCAN_PTE_NON_PRESENT;
> > -                     goto out;
> > -             }
> > -             if (pte_uffd_wp(pteval)) {
> > -                     result =3D SCAN_PTE_UFFD_WP;
> > -                     goto out;
> > -             }
> > -             page =3D vm_normal_page(vma, addr, pteval);
> > -             if (unlikely(!page) || unlikely(is_zone_device_page(page)=
)) {
> > -                     result =3D SCAN_PAGE_NULL;
> > -                     goto out;
> > -             }
> > -
> > -             folio =3D page_folio(page);
> > -             VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> > -
> > -             /*
> > -              * If the vma has the VM_DROPPABLE flag, the collapse wil=
l
> > -              * preserve the lazyfree property without needing to skip=
.
> > -              */
> > -             if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) =
&&
> > -                 folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> > -                     result =3D SCAN_PAGE_LAZYFREE;
> > +             pteval =3D ptep_get(_pte);
> > +             pte_check =3D collapse_check_pte(pteval, addr, &ctx);
> > +             if (pte_check =3D=3D PTE_CHECK_FAIL) {
> > +                     result =3D ctx.result;
> >                       goto out;
> >               }
> > +             if (pte_check =3D=3D PTE_CHECK_CONTINUE)
> > +                     continue;
> > +             folio =3D ctx.folio;
> >
> > -             /* See collapse_scan_pmd(). */
> > -             if (folio_maybe_mapped_shared(folio)) {
> > -                     /*
> > -                      * TODO: Support shared pages without leading to =
further
> > -                      * mTHP collapses. Currently bringing in new page=
s via
> > -                      * shared may cause a future higher order collaps=
e on a
> > -                      * rescan of the same range.
> > -                      */
> > -                     if (++shared > max_ptes_shared) {
> > -                             result =3D SCAN_EXCEED_SHARED_PTE;
> > -                             count_collapse_event(order, THP_SCAN_EXCE=
ED_SHARED_PTE,
> > -                                             MTHP_STAT_COLLAPSE_EXCEED=
_SHARED);
> > -                             goto out;
> > -                     }
> > -             }
> >               /*
> >                * TODO: In some cases of partially-mapped folios, we'd a=
ctually
> >                * want to collapse.
> > @@ -844,13 +920,13 @@ static enum scan_result __collapse_huge_page_isol=
ate(struct vm_area_struct *vma,
> >               result =3D SCAN_LACK_REFERENCED_PAGE;
> >       } else {
> >               result =3D SCAN_SUCCEED;
> > -             trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> > +             trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_ze=
ro,
> >                                                   referenced, result, o=
rder);
> >               return result;
> >       }
> >  out:
> >       release_pte_pages(pte, _pte, compound_pagelist);
> > -     trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> > +     trace_mm_collapse_huge_page_isolate(folio, ctx.none_or_zero,
> >                                           referenced, result, order);
> >       return result;
> >  }
> > @@ -1616,24 +1692,30 @@ static enum scan_result collapse_scan_pmd(struc=
t mm_struct *mm,
> >               struct vm_area_struct *vma, unsigned long start_addr,
> >               bool *lock_dropped, struct collapse_control *cc)
> >  {
> > -     const unsigned int max_ptes_shared =3D collapse_max_ptes_shared(c=
c, HPAGE_PMD_ORDER);
> > -     const unsigned int max_ptes_swap =3D collapse_max_ptes_swap(cc, H=
PAGE_PMD_ORDER);
> > -     unsigned int max_ptes_none =3D collapse_max_ptes_none(cc, vma, HP=
AGE_PMD_ORDER);
> >       enum tva_type tva_flags =3D cc->is_khugepaged ? TVA_KHUGEPAGED : =
TVA_FORCED_COLLAPSE;
> >       pmd_t *pmd;
> >       pte_t *pte, *_pte, pteval;
> >       int i;
> > -     int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> > -     enum scan_result result =3D SCAN_FAIL;
> > -     struct page *page =3D NULL;
> >       struct folio *folio =3D NULL;
> > +     int referenced =3D 0;
> > +     enum scan_result result =3D SCAN_FAIL;
> >       unsigned long addr;
> >       unsigned long enabled_orders;
> >       spinlock_t *ptl;
> > -     int node =3D NUMA_NO_NODE, unmapped =3D 0;
> > +     int node =3D NUMA_NO_NODE;
> > +     enum pte_check_result pte_check;
> >
> >       VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >
> > +     struct pte_check_context ctx =3D {
> > +             .cc =3D cc,
> > +             .vma =3D vma,
> > +             .order =3D HPAGE_PMD_ORDER,
> > +             .max_ptes_none =3D collapse_max_ptes_none(cc, vma, HPAGE_=
PMD_ORDER),
> > +             .max_ptes_swap =3D collapse_max_ptes_swap(cc, HPAGE_PMD_O=
RDER),
> > +             .max_ptes_shared =3D collapse_max_ptes_shared(cc, HPAGE_P=
MD_ORDER),
> > +     };
> > +
> >       result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >       if (result !=3D SCAN_SUCCEED) {
> >               cc->progress++;
> > @@ -1649,7 +1731,7 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >        * scan all pages to populate the bitmap for mTHP collapse.
> >        */
> >       if (enabled_orders !=3D BIT(HPAGE_PMD_ORDER))
> > -             max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT;
> > +             ctx.max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT;
> >
> >       pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >       if (!pte) {
> > @@ -1665,81 +1747,14 @@ static enum scan_result collapse_scan_pmd(struc=
t mm_struct *mm,
> >
> >               cc->progress++;
> >
> > -             if (pte_none_or_zero(pteval)) {
> > -                     if (++none_or_zero > max_ptes_none) {
> > -                             result =3D SCAN_EXCEED_NONE_PTE;
> > -                             count_collapse_event(HPAGE_PMD_ORDER, THP=
_SCAN_EXCEED_NONE_PTE,
> > -                                             MTHP_STAT_COLLAPSE_EXCEED=
_NONE);
> > -                             goto out_unmap;
> > -                     }
> > -                     continue;
> > -             }
> > -             if (!pte_present(pteval)) {
> > -                     if (++unmapped > max_ptes_swap) {
> > -                             result =3D SCAN_EXCEED_SWAP_PTE;
> > -                             count_collapse_event(HPAGE_PMD_ORDER, THP=
_SCAN_EXCEED_SWAP_PTE,
> > -                                             MTHP_STAT_COLLAPSE_EXCEED=
_SWAP);
> > -                             goto out_unmap;
> > -                     }
> > -                     /*
> > -                      * Always be strict with uffd-wp
> > -                      * enabled swap entries.  Please see
> > -                      * comment below for pte_uffd_wp().
> > -                      */
> > -                     if (pte_swp_uffd_wp_any(pteval)) {
> > -                             result =3D SCAN_PTE_UFFD_WP;
> > -                             goto out_unmap;
> > -                     }
> > -                     continue;
> > -             }
> > -             if (pte_uffd_wp(pteval)) {
> > -                     /*
> > -                      * Don't collapse the page if any of the small
> > -                      * PTEs are armed with uffd write protection.
> > -                      * Here we can also mark the new huge pmd as
> > -                      * write protected if any of the small ones is
> > -                      * marked but that could bring unknown
> > -                      * userfault messages that falls outside of
> > -                      * the registered range.  So, just be simple.
> > -                      */
> > -                     result =3D SCAN_PTE_UFFD_WP;
> > -                     goto out_unmap;
> > -             }
> > -
> > -             page =3D vm_normal_page(vma, addr, pteval);
> > -             if (unlikely(!page) || unlikely(is_zone_device_page(page)=
)) {
> > -                     result =3D SCAN_PAGE_NULL;
> > -                     goto out_unmap;
> > -             }
> > -             folio =3D page_folio(page);
> > -
> > -             /*
> > -              * If the vma has the VM_DROPPABLE flag, the collapse wil=
l
> > -              * preserve the lazyfree property without needing to skip=
.
> > -              */
> > -             if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) =
&&
> > -                 folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> > -                     result =3D SCAN_PAGE_LAZYFREE;
> > -                     goto out_unmap;
> > -             }
> > -
> > -             if (!folio_test_anon(folio)) {
> > -                     result =3D SCAN_PAGE_ANON;
> > +             pte_check =3D collapse_check_pte(pteval, addr, &ctx);
> > +             if (pte_check =3D=3D PTE_CHECK_FAIL) {
> > +                     result =3D ctx.result;
> >                       goto out_unmap;
> >               }
> > -
> > -             /*
> > -              * We treat a single page as shared if any part of the TH=
P
> > -              * is shared.
> > -              */
> > -             if (folio_maybe_mapped_shared(folio)) {
> > -                     if (++shared > max_ptes_shared) {
> > -                             result =3D SCAN_EXCEED_SHARED_PTE;
> > -                             count_collapse_event(HPAGE_PMD_ORDER, THP=
_SCAN_EXCEED_SHARED_PTE,
> > -                                             MTHP_STAT_COLLAPSE_EXCEED=
_SHARED);
> > -                             goto out_unmap;
> > -                     }
> > -             }
> > +             if (pte_check =3D=3D PTE_CHECK_CONTINUE)
> > +                     continue;
> > +             folio =3D ctx.folio;
> >
> >               /* Set bit for occupied pages */
> >               __set_bit(i, cc->mthp_present_ptes);
> > @@ -1781,7 +1796,7 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >       }
> >       if (cc->is_khugepaged &&
> >                  (!referenced ||
> > -                 (unmapped && referenced < HPAGE_PMD_NR / 2))) {
> > +                 (ctx.unmapped && referenced < HPAGE_PMD_NR / 2))) {
> >               result =3D SCAN_LACK_REFERENCED_PAGE;
> >       } else {
> >               result =3D SCAN_SUCCEED;
> > @@ -1792,13 +1807,13 @@ static enum scan_result collapse_scan_pmd(struc=
t mm_struct *mm,
> >               /* collapse_huge_page expects the lock to be dropped befo=
re calling */
> >               mmap_read_unlock(mm);
> >               result =3D mthp_collapse(mm, start_addr, referenced,
> > -                                    unmapped, cc, enabled_orders);
> > +                                    ctx.unmapped, cc, enabled_orders);
> >               /* mmap_lock was released above, set lock_dropped */
> >               *lock_dropped =3D true;
> >       }
> >  out:
> >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > -                                  none_or_zero, result, unmapped);
> > +                                  ctx.none_or_zero, result, ctx.unmapp=
ed);
> >       return result;
> >  }
> >
> > --
> > 2.54.0
> >
> >
>



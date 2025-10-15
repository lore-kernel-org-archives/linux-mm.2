Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD110CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F538E0087; Wed, 15 Oct 2025 14:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116FA8E000C; Wed, 15 Oct 2025 14:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005798E0087; Wed, 15 Oct 2025 14:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E032C8E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:54:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B0DCC0274
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:54:34 +0000 (UTC)
X-FDA: 84001249668.11.AE2DE66
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9711DC000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:54:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XjfrC+HO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.166.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJqtUlUUzdHm8UIHRbAwoG+Ib2OL2NTfoQttTWYvsVA=;
	b=zwaip7dvp9FwFwBHh1sP5SkQVz8W4MOaAHjv5D6gIQ1Ne5B2aXk4MC1lViViSQL7uDWr1A
	hkw1PbtIljlmkH+D0QIOdOcY280AEMQvISbX367OdHSZRXjhCc2Dp4WkC7KuaeC5F/1Z3/
	nepUbIE7vxFTW1rvMoRarVE7nnUXRhk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554472; a=rsa-sha256;
	cv=none;
	b=lURRCzJn+xtrokW5n9EnJD6oO5sRhUJ+XLW++6r2Aa+FnZTCy2H0z/JAaKzhzNk/D27lxa
	YTchNAgcNsva8IqoB3i7Iv8Gi9VSVM0+mFJk0MOJMXu+KnSaUgn7xb2JxjnGvMg2TawsfM
	knxxkYhD1zBqbQ/SGwXdTR7vvWWe9NE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XjfrC+HO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.166.170 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-42f8e736ecaso99885ab.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554472; x=1761159272; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJqtUlUUzdHm8UIHRbAwoG+Ib2OL2NTfoQttTWYvsVA=;
        b=XjfrC+HOScfe6CvmaEGHXYV8zAgd9r162fnGoAhpHz87cIeB31mG6ZeblnlW+BQ9J+
         ZDtDUFlUf2m1/2YUhUeor6tO1br+2A+K8cphhv67vOIePX9zcmRXG2q+RwAWWw8BCy2s
         /MFbSWeyyUcOVNhc93YyU+q5NBISqZY6RrkBRvvZUC/S3PREv78QvucU5UFjhZA/8Bx4
         eyjfnF18qshP4yBFATauG5bkUMFBhfB2FiM00477RXo7XSZL50lX+e2rf1E+FBjA7d0b
         G97I2QmPhQLPiUaa5tdEO2PVxYd35XGGxWk7a5M9mPbJWZ9geG8CUGHsba7sSV8KM1fo
         mdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554472; x=1761159272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xJqtUlUUzdHm8UIHRbAwoG+Ib2OL2NTfoQttTWYvsVA=;
        b=oCCPK02ASkEuTA8FvFlj9CmCcESdc258rVC7YnSO0cDZoDlFbJZoyu3vZobj8cEnYt
         dgBG1WDuXRLVehPjKn8gStZHQievnxKsa2cEfavQKKYOBP2Cd5LJ2QlL09jAn+nAdeQP
         FBNnbXZT/ccap1dy9DNKNFe4QjmvveA3pndk2vysFyoXRr4pIuOtVsLGtdIDqTOsHKG7
         ZZzunEKbWzQFBMX6g8vfOj4COeY1eBIo60xUxJg4x9Q4ohRhrP3DSrZPnyiwhy8re+cv
         meLwVgDWU+gKOyGoPQeOMiRB9/VPZuuIvZytNhTJKO89CufV2fZ+h+RUfog6/yQNVXXi
         /IHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuD2Ot47D2onv5PfmfdY8qXrrpxdNb2l9qJ3jnaDrtTJBSROUNVD4aK3Ph/WnX/UxueJnByJqCXA==@kvack.org
X-Gm-Message-State: AOJu0YynfvmEN4TkIR7ZkOmR9qjgzb7ryYI2CyrUZFh4Q1jbiZK4iZXr
	Q9ImV9iAfElKnPBa7DUIUd07v5QQFUWNAjSZNerQ+kejCVjMZGA4llnf4RV3G1QKWUe2bmoYoCz
	3S/701l8/K6QYJB+gJKOT5xknMFTD7pGfLqRFe18J
X-Gm-Gg: ASbGncvTM15omPLnBCu8tJ/tpvRDGhuKbse7ruHt4Mno9/svGCVlBxNPE5lsRPer+Dq
	0QqSXna2/bMhyzPlgxrudQIsVaHtG4Ew7k4bOv6PvAmmEfhNvIEobAmlVlU9Zw4DMsyzV8sYZT0
	vPCk95SAMNAwNgqCfrmQdYHCU+rCHAeRIXJ+5uw6Z2o9BqNoVHz61ku4NQS65Ps9WP8oiiMguux
	Dfe3ksndIsg0drNtuebz4RtDV4i1Rj/L7G38LIw682uKZbKoQ6Sx/OFtVtaubE=
X-Google-Smtp-Source: AGHT+IHN/Cj7TZnn7sOw6L+jNnHTKiV+9kX3nTieIVtBfflK97jV5CC1cM7tjHiU8hMgwKXTQQ/8srXGHITEFpNEDE4=
X-Received: by 2002:a05:622a:4d0e:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4e884c27ba7mr8548201cf.1.1760554471168; Wed, 15 Oct 2025
 11:54:31 -0700 (PDT)
MIME-Version: 1.0
References: <20251015-b4-pcp-lock-cleanup-v2-1-740d999595d5@suse.cz>
In-Reply-To: <20251015-b4-pcp-lock-cleanup-v2-1-740d999595d5@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Oct 2025 11:54:19 -0700
X-Gm-Features: AS18NWBcaZXOhYjN3z_WXQTDHg1hl-Cyr9VA3WP9aqbCYSWLXKZh0FpG_6daS6E
Message-ID: <CAJuCfpELB-LX55qZYBfrSVx1+EHE0TWLiHd2AUuU1BK-JTWntQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_alloc: simplify and cleanup pcp locking
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: dh73ef6o5ewgj4tqh5rgmhjrjomjxgaz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9711DC000A
X-HE-Tag: 1760554472-504405
X-HE-Meta: U2FsdGVkX1+Vl4h72k6D/QdlXFsywM0GM1TFe1EvDegizA6FjhbfAqpr1qM3TBJxedtDYKxrF4IoPtCkbcizC/E3Nw6bzy8+aj7+SwFXYFKLcRK5rlWY+BfoirS/4zhGtFoWK7nMZc0FjnF847ChnXjzJ0zNdr7H0B8I/OoZVdhmBDzlac5X1KDcsfqB/ubCY9rAclOTPFJS1XGOiws5psO45314tVyvdJptvG/6ApRfNnVt0TUz+uWc8+RwbctEODzP9trjQzfJ4XxHhT8w3z8+XMdQRrmasxfQd5Ogd7Zu0P8wqT0Rs24EsyT0RpzlJR/TunPETGMjFFHMkLJNJlgBhMWqiwtVY33TbI+WLji0okmghslbvEoj8GS0VgODOe/QvDEWIO1LqLkse/roSEEet35vGmtZtlxxYoMPS27cCuYl2QwFt5Tit9ViNCQMVvRnJycU7kuEkIlYaL9nQULRxD+Ni/gram6qXCmuwrROjONxKfq38X2XhiyOqrYZfCdLSSju6ZL+ng6TUPpOua9rlhhdZQPXckNdgUBDUnq6Ym+3O0ofvwxm2CqPMUvYtNAOXKC6RfKGCrVcxaeutMUVtxcRpQC5I2myxDFKUeEBp57VTvKB0DSDogFCCufrDThbZyo0oNu8SsZp9ALkVYLSW71dDExQbHIQIhtRPwA7PxjzU2dUhaM+oxw+7Ml3PocJxXwF+O4d3K1u8C6IW2qsRyzeOIKc1LcUnbq5b9vl93avovU+Lp3QXwpXpGXT079+eEysRv1vQ/MLxWb6bvpuknWMHVj+7n+5o3pU0A82eJcRuIuxv5dyUzMzdW34AtfY4eSdxAo7aGCLijRS+itAaP84fi43Pg+WS15HDiC3JfNIUtf+CdVQ7kmfdhELIsw5kUY0eLXzXCWxuuA4DcOByVFojTkygUETFqpOv3frOlJFM//XyZV9NLPs8SRQTAoZr8d9AMR0MXEdvvj
 V+wY8Mpt
 c8Gip8zgTPAvyu9N/6g+bev9gWs9Ul4REri6jWEliZKUaVtCpIhZPcKId3ow1HcFClURj4KOTHYaNZbBZdra3cAV1seCc2ovulzNI23jvT6sVNc2+VvzNH5PgQIPaR1MlNwjEVC3E3WkKuP17l9dR9v0RXJU84JDdG6d5vrov8VYIThS2aThmSPWkNDaFFpLBJbgCyUAklC/QIAMCb6gqrT2ai/o5jOCVJPaioEMh6qs6npr34sZbxjvzc1gkV5u/vKaLAWTmsbcGPcRvE8XF618t8tRWEC2VNL+eGlaS2+fGI0FPOcnhUpN0By+aTgCtai9ZgMV5ZeZ+tCG7idSrNhuTAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:50=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> The pcp locking relies on pcp_spin_trylock() which has to be used
> together with pcp_trylock_prepare()/pcp_trylock_finish() to work
> properly on !SMP !RT configs. This is tedious and error-prone.
>
> We can remove pcp_spin_lock() and underlying pcpu_spin_lock() because we
> don't use it. Afterwards pcp_spin_unlock() is only used together with
> pcp_spin_trylock(). Therefore we can add the UP_flags parameter to them
> both and handle pcp_trylock_prepare()/finish() within.
>
> Additionally for the configs where pcp_trylock_prepare()/finish() are
> no-op (SMP || RT) make them pass &UP_flags to a no-op inline function.
> This ensures typechecking and makes the local variable "used" so we can
> remove the __maybe_unused attributes.
>
> In my compile testing, bloat-o-meter reported no change on SMP config,
> so the compiler is capable of optimizing away the no-ops same as before,
> and we have simplified the code using pcp_spin_trylock().
>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

You are fast :)

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
> based on mm-new
> Changed my mind and did as Joshua suggested, for consistency. Thanks!
> ---
> Changes in v2:
> - Convert also pcp_trylock_finish() to noop function, per Joshua.
> - Link to v1: https://lore.kernel.org/r/20251015-b4-pcp-lock-cleanup-v1-1=
-878e0e7dcfb2@suse.cz
> ---
>  mm/page_alloc.c | 99 +++++++++++++++++++++++----------------------------=
------
>  1 file changed, 40 insertions(+), 59 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0155a66d7367..fb91c566327c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -99,9 +99,12 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
>  /*
>   * On SMP, spin_trylock is sufficient protection.
>   * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
> + * Pass flags to a no-op inline function to typecheck and silence the un=
used
> + * variable warning.
>   */
> -#define pcp_trylock_prepare(flags)     do { } while (0)
> -#define pcp_trylock_finish(flag)       do { } while (0)
> +static inline void __pcp_trylock_noop(unsigned long *flags) { }
> +#define pcp_trylock_prepare(flags)     __pcp_trylock_noop(&(flags))
> +#define pcp_trylock_finish(flags)      __pcp_trylock_noop(&(flags))
>  #else
>
>  /* UP spin_trylock always succeeds so disable IRQs to prevent re-entranc=
y. */
> @@ -129,15 +132,6 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
>   * Generic helper to lookup and a per-cpu variable with an embedded spin=
lock.
>   * Return value should be used with equivalent unlock helper.
>   */
> -#define pcpu_spin_lock(type, member, ptr)                              \
> -({                                                                     \
> -       type *_ret;                                                     \
> -       pcpu_task_pin();                                                \
> -       _ret =3D this_cpu_ptr(ptr);                                      =
 \
> -       spin_lock(&_ret->member);                                       \
> -       _ret;                                                           \
> -})
> -
>  #define pcpu_spin_trylock(type, member, ptr)                           \
>  ({                                                                     \
>         type *_ret;                                                     \
> @@ -157,14 +151,21 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
>  })
>
>  /* struct per_cpu_pages specific helpers. */
> -#define pcp_spin_lock(ptr)                                             \
> -       pcpu_spin_lock(struct per_cpu_pages, lock, ptr)
> -
> -#define pcp_spin_trylock(ptr)                                          \
> -       pcpu_spin_trylock(struct per_cpu_pages, lock, ptr)
> +#define pcp_spin_trylock(ptr, UP_flags)                                 =
       \
> +({                                                                     \
> +       struct per_cpu_pages *__ret;                                    \
> +       pcp_trylock_prepare(UP_flags);                                  \
> +       __ret =3D pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);    =
 \
> +       if (!__ret)                                                     \
> +               pcp_trylock_finish(UP_flags);                           \
> +       __ret;                                                          \
> +})
>
> -#define pcp_spin_unlock(ptr)                                           \
> -       pcpu_spin_unlock(lock, ptr)
> +#define pcp_spin_unlock(ptr, UP_flags)                                 \
> +({                                                                     \
> +       pcpu_spin_unlock(lock, ptr);                                    \
> +       pcp_trylock_finish(UP_flags);                                   \
> +})
>
>  #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
>  DEFINE_PER_CPU(int, numa_node);
> @@ -2887,13 +2888,10 @@ static bool free_frozen_page_commit(struct zone *=
zone,
>                 if (to_free =3D=3D 0 || pcp->count =3D=3D 0)
>                         break;
>
> -               pcp_spin_unlock(pcp);
> -               pcp_trylock_finish(*UP_flags);
> +               pcp_spin_unlock(pcp, *UP_flags);
>
> -               pcp_trylock_prepare(*UP_flags);
> -               pcp =3D pcp_spin_trylock(zone->per_cpu_pageset);
> +               pcp =3D pcp_spin_trylock(zone->per_cpu_pageset, *UP_flags=
);
>                 if (!pcp) {
> -                       pcp_trylock_finish(*UP_flags);
>                         ret =3D false;
>                         break;
>                 }
> @@ -2904,8 +2902,7 @@ static bool free_frozen_page_commit(struct zone *zo=
ne,
>                  * returned in an unlocked state.
>                  */
>                 if (smp_processor_id() !=3D cpu) {
> -                       pcp_spin_unlock(pcp);
> -                       pcp_trylock_finish(*UP_flags);
> +                       pcp_spin_unlock(pcp, *UP_flags);
>                         ret =3D false;
>                         break;
>                 }
> @@ -2937,7 +2934,7 @@ static bool free_frozen_page_commit(struct zone *zo=
ne,
>  static void __free_frozen_pages(struct page *page, unsigned int order,
>                                 fpi_t fpi_flags)
>  {
> -       unsigned long __maybe_unused UP_flags;
> +       unsigned long UP_flags;
>         struct per_cpu_pages *pcp;
>         struct zone *zone;
>         unsigned long pfn =3D page_to_pfn(page);
> @@ -2973,17 +2970,15 @@ static void __free_frozen_pages(struct page *page=
, unsigned int order,
>                 add_page_to_zone_llist(zone, page, order);
>                 return;
>         }
> -       pcp_trylock_prepare(UP_flags);
> -       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset);
> +       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
>         if (pcp) {
>                 if (!free_frozen_page_commit(zone, pcp, page, migratetype=
,
>                                                 order, fpi_flags, &UP_fla=
gs))
>                         return;
> -               pcp_spin_unlock(pcp);
> +               pcp_spin_unlock(pcp, UP_flags);
>         } else {
>                 free_one_page(zone, page, pfn, order, fpi_flags);
>         }
> -       pcp_trylock_finish(UP_flags);
>  }
>
>  void free_frozen_pages(struct page *page, unsigned int order)
> @@ -2996,7 +2991,7 @@ void free_frozen_pages(struct page *page, unsigned =
int order)
>   */
>  void free_unref_folios(struct folio_batch *folios)
>  {
> -       unsigned long __maybe_unused UP_flags;
> +       unsigned long UP_flags;
>         struct per_cpu_pages *pcp =3D NULL;
>         struct zone *locked_zone =3D NULL;
>         int i, j;
> @@ -3039,8 +3034,7 @@ void free_unref_folios(struct folio_batch *folios)
>                 if (zone !=3D locked_zone ||
>                     is_migrate_isolate(migratetype)) {
>                         if (pcp) {
> -                               pcp_spin_unlock(pcp);
> -                               pcp_trylock_finish(UP_flags);
> +                               pcp_spin_unlock(pcp, UP_flags);
>                                 locked_zone =3D NULL;
>                                 pcp =3D NULL;
>                         }
> @@ -3059,10 +3053,8 @@ void free_unref_folios(struct folio_batch *folios)
>                          * trylock is necessary as folios may be getting =
freed
>                          * from IRQ or SoftIRQ context after an IO comple=
tion.
>                          */
> -                       pcp_trylock_prepare(UP_flags);
> -                       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset);
> +                       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset, U=
P_flags);
>                         if (unlikely(!pcp)) {
> -                               pcp_trylock_finish(UP_flags);
>                                 free_one_page(zone, &folio->page, pfn,
>                                               order, FPI_NONE);
>                                 continue;
> @@ -3085,10 +3077,8 @@ void free_unref_folios(struct folio_batch *folios)
>                 }
>         }
>
> -       if (pcp) {
> -               pcp_spin_unlock(pcp);
> -               pcp_trylock_finish(UP_flags);
> -       }
> +       if (pcp)
> +               pcp_spin_unlock(pcp, UP_flags);
>         folio_batch_reinit(folios);
>  }
>
> @@ -3339,15 +3329,12 @@ static struct page *rmqueue_pcplist(struct zone *=
preferred_zone,
>         struct per_cpu_pages *pcp;
>         struct list_head *list;
>         struct page *page;
> -       unsigned long __maybe_unused UP_flags;
> +       unsigned long UP_flags;
>
>         /* spin_trylock may fail due to a parallel drain or IRQ reentranc=
y. */
> -       pcp_trylock_prepare(UP_flags);
> -       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset);
> -       if (!pcp) {
> -               pcp_trylock_finish(UP_flags);
> +       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
> +       if (!pcp)
>                 return NULL;
> -       }
>
>         /*
>          * On allocation, reduce the number of pages that are batch freed=
.
> @@ -3357,8 +3344,7 @@ static struct page *rmqueue_pcplist(struct zone *pr=
eferred_zone,
>         pcp->free_count >>=3D 1;
>         list =3D &pcp->lists[order_to_pindex(migratetype, order)];
>         page =3D __rmqueue_pcplist(zone, order, migratetype, alloc_flags,=
 pcp, list);
> -       pcp_spin_unlock(pcp);
> -       pcp_trylock_finish(UP_flags);
> +       pcp_spin_unlock(pcp, UP_flags);
>         if (page) {
>                 __count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << o=
rder);
>                 zone_statistics(preferred_zone, zone, 1);
> @@ -5045,7 +5031,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>                         struct page **page_array)
>  {
>         struct page *page;
> -       unsigned long __maybe_unused UP_flags;
> +       unsigned long UP_flags;
>         struct zone *zone;
>         struct zoneref *z;
>         struct per_cpu_pages *pcp;
> @@ -5139,10 +5125,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, i=
nt preferred_nid,
>                 goto failed;
>
>         /* spin_trylock may fail due to a parallel drain or IRQ reentranc=
y. */
> -       pcp_trylock_prepare(UP_flags);
> -       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset);
> +       pcp =3D pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
>         if (!pcp)
> -               goto failed_irq;
> +               goto failed;
>
>         /* Attempt the batch allocation */
>         pcp_list =3D &pcp->lists[order_to_pindex(ac.migratetype, 0)];
> @@ -5159,8 +5144,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>                 if (unlikely(!page)) {
>                         /* Try and allocate at least one page */
>                         if (!nr_account) {
> -                               pcp_spin_unlock(pcp);
> -                               goto failed_irq;
> +                               pcp_spin_unlock(pcp, UP_flags);
> +                               goto failed;
>                         }
>                         break;
>                 }
> @@ -5171,8 +5156,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>                 page_array[nr_populated++] =3D page;
>         }
>
> -       pcp_spin_unlock(pcp);
> -       pcp_trylock_finish(UP_flags);
> +       pcp_spin_unlock(pcp, UP_flags);
>
>         __count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
>         zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_acc=
ount);
> @@ -5180,9 +5164,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>  out:
>         return nr_populated;
>
> -failed_irq:
> -       pcp_trylock_finish(UP_flags);
> -
>  failed:
>         page =3D __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
>         if (page)
>
> ---
> base-commit: 550b531346a7e4e7ad31813d0d1d6a6d8c10a06f
> change-id: 20251015-b4-pcp-lock-cleanup-9b70b417a20e
>
> Best regards,
> --
> Vlastimil Babka <vbabka@suse.cz>
>


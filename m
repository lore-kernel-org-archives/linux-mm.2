Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 530B1CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AB126B00A1; Wed, 24 Jun 2026 11:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C006B00BC; Wed, 24 Jun 2026 11:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FCE26B00BD; Wed, 24 Jun 2026 11:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 033A36B00A1
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:03:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 903C71A037E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:03:21 +0000 (UTC)
X-FDA: 84915124602.07.26C7794
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8534940010
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:03:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nxp2rkRm;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782313399;
	b=p6WgtGXoaSM+3eeZWZun22iZiUqWnRlkPHpgBrZHre6Rk6mKw+fqHw96TNlLKjczsScCNI
	Lr6OsYxMF+h41lYvKBEcxOvgFa3B8VPPrJHet6VrIjsjCrgbLDR8sXr8HzMPEQuLnuIZP/
	4iEn1uozo/8paBiI8nR61pdKsVTU7mc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlyV7kfKSj2GGDVWeOXvQhnQwHq/DAA8kHWMpboRygM=;
	b=0G1gC2qkVy366kENjEvD9plXfwf3evhFecWJBkEFzB/UNzPvcoFOhp7HNuJqxLiuhZaZit
	bSLK3BJmdP/7QwLQJgHwiWN507zWCO2utQYUVxEI04dyUeq2tRWptb3JfsSJTt2LBGJpBM
	fa1JFR43Ej8yan/Wu5yZDaM8jCLZW7A=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nxp2rkRm;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5177d1ff061so299481cf.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782313398; cv=none;
        d=google.com; s=arc-20260327;
        b=rbrUdcBhLihOvTVINrbUodmcT7w9pqFMeGYxKhp39EGiGf5xDo/y8zmS1KjomT/EDW
         6WjBATuPaOUUNPphSXQPbyIBXlZMrJ9XgPFNiSPTiJSQJv6qGqvIg2cCaAGqPPc9ENek
         Ktiaky4BphNX/og2nKrxsROEoPVXfzMgeJnqTotLBKyxOS4iThLj8Ib4xm4NC8dW4wCk
         3FGxWSVxdLtnyR2TTBoHIBpWcafuYpx27OGVLRzOi3qbA+Qs/6W9X9GTvogW213Sqk2X
         n3IW+EW1UoRIWtJ8rQMFmqgqCUb68WO+VQfT+ZNkw0jdCpMnL9/0ILMtYtPvK/O3WOQP
         PMiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dlyV7kfKSj2GGDVWeOXvQhnQwHq/DAA8kHWMpboRygM=;
        fh=ni9wAx1YY8DepWX3IPZsOBRhpJxW5iWJxtjKV+9Ezgg=;
        b=dsdBRIm0IKTERxVLskE3bbDxTD8/Zkz+pOZR+YVwu5JgkiRKpDArh01ryua+vtDUoG
         5iXFhfbMW5KTnj15UPp2gXwa+lQax3LGprzVkGqHQ27LviNCRPwHT4FGdKyjyOvSrTVs
         OSU2WArtlKWM8ng1XhAnrRvddme5byIhVHBJr+jT4ixrOH6gwMWrJJaCyo5R5HjArDLV
         +elfxWzHFuukV6X5cEkQ0Wvyo/xH+bfoFVhhrmxA204d1H4B1IBsw3wvwuzzvyV1WDfD
         qBaIf4f/11zzCvX05tny5l6Sp/XXkI8vrunzmGda0FqvPoFOQXtUjAVcPLjzONrMBOTf
         +FnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782313398; x=1782918198; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dlyV7kfKSj2GGDVWeOXvQhnQwHq/DAA8kHWMpboRygM=;
        b=nxp2rkRm19jwWakoEPZ80lUC7ZJOlXPhYiAmrnYPOZvnVquu7/A2sTUZoIp9ohMCi6
         yxxmqFZ7karGDxpO0lhRozqWC1VFsYdduSh52GQiNP+571oIMbI6dd8BA4AysVYays5j
         MjlmWrjKx7ZIy/EUN7OqO0YPbvhP6BBGiQcuknjL2CLWlgl7wzDx/nk57PHayPJyevmy
         m9aTyGE+qVgKARvbNQsrBUlYPoidecgUsTVGe8H1/NYWG1JCsCasCAO3NdMNkKNIC0Tc
         BvGu2RGxFyXXlluUFW0cqOe4xaCYQ9VjdMmAGPfTSwcM0Gx0CpTF4QzkJhdZDatPeqeW
         bmZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313398; x=1782918198;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dlyV7kfKSj2GGDVWeOXvQhnQwHq/DAA8kHWMpboRygM=;
        b=JiziiZbXDc/GIQP4eLjKRxUFk5ctsHdpyBTVw/tFU0w2g6XHiB+YVltjS1FJYgAbkf
         TxeeWnCHenbAFAnae+alenqrYBvUrvzRhNv1IwOcinw52RT0PTUn9j2BJ44irO4Ehw7p
         DSC9rly4MpdIgR2gXPyn+TdDonddZ8Jy2b8rNg5YHfB9Y4PqZ4Ud4JVvkyNoSrIf6+yk
         BLiCt9i1JPpLqBnvLMHotUFpIccvwvGM6vl2KxTB4uRC6zcXIbMJuPc5y+P4uQdIB7ev
         AxNUTgLpmqQdkKA64C3TS7P8fh7mTI3fBZUehOBj+lpp5OAwBx2kny8xVTCHzd3CPEj1
         R+Hg==
X-Forwarded-Encrypted: i=1; AFNElJ+fXjoUK2/Ox1+jCYFRmyMUmRxxH8XMMTcOJ9gYYixf+hvEbj4snsfHOSOkwiv4i47h/2n03o0PFQ==@kvack.org
X-Gm-Message-State: AOJu0YwJKP1FhVFaDE2VcGIbaW9MMb/miX+8b/5z+hlXAH7dcZn7kjor
	/WbgKdN69LDD7ngOL+aQQa717ci8FyQXxRCdpOuSS0DFCQXIyXHeyveiB2fPR6duKz96HIG+pg5
	ZM0IQ85GloLUKHLf+Bk6cIG+4McCpK8yQbTZLZ5uC
X-Gm-Gg: AfdE7cntFD81Cf0lUIKNZQ8mVUAW5p3RwFgArxBLQfGks0R2fMdnWTMI5zEEllmzS2s
	yRoWOMysasrkpCcH3hdJrkSi6Ez2Vff5nrXH3ibjD0dD0P3U0Lmvi66RwnT33OBXPNZs7Fn2Hxl
	UNduQn19mXDYAL7f98PKucnEmG+OWrpkelTgpjgBKFevzhtR67/rJIExTRgF7jlajuHyNm3Cm7p
	PzjQ7j/o4n0CV4f6+HfJuVG4V6nJ1UYdD4do+hcpNEyZtibPdEWQTxEEN82TMJ8rlSAuMdmlu9T
	7+3mwPQHBRCyu/vQ0Qe2/YI92Mc=
X-Received: by 2002:a05:622a:111:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-51a628921bfmr8601831cf.15.1782313397499; Wed, 24 Jun 2026
 08:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com> <20260622-alloc-trylock-v2-2-31f31367d420@google.com>
In-Reply-To: <20260622-alloc-trylock-v2-2-31f31367d420@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Jun 2026 08:03:05 -0700
X-Gm-Features: AVVi8CfyEwqAEU2r2L-YA31JVfrUZe0if-g-xPd3BqEiAahIxAzXLBzOfAkdwLA
Message-ID: <CAJuCfpGagFf4RaCNJqu4Y1oqOXXOWSkP1UGuT9LA-9EbDN4Njw@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] mm/page_alloc: some renames to clarify
 alloc_flags scopes
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8534940010
X-Stat-Signature: tq3wwxmx6ad1zzwkgdu8igmo9uerj966
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782313399-68375
X-HE-Meta: U2FsdGVkX19IPl5hUZ8by7v4RP2uqYzF2MD3fCTZVk4SAzPNYN1vDE3gialCB4ECtSj/aH3ho/CW6X+2btc/TTarhAhj63SaRYKxRc+h6aAGaC0SJkNn7wBUtBVrl1fo7NNi+63xgmSt/nm6WOckttHC6DbDbpgG/+Od6U96bsB+JTFRz0z9B8wg7g2RrtfZ3HdAzOPkmIW1xYVf8yech9Iw/wytWfalEp1/wpVjE9qGkUzIvcLNPWVIL6OOWAnEiA41vonSh8bDLWR4E97hI/SAlgdpZw1Eredz2dwiJOlzgzy/jxW+NxIEy356+vMPUFfRfpkTM/BUdYuQSOKKKwvxJvWPSEMSjnKOOkp52FaBcWpHkiqG0A7xeNYd8zD3/ymooIwX/8ZunNE+HnxuhBGdg9+lts4bTpH4cJIQmsSSFmQGerLtjEF9ebtGnDmPf6Pcnmas1NLbUBNQTjpIvLwprSSmBFN36MIfcINiT9PGpgy/OzvGeJvHue/lg901tsdzuiBkfVxy8usyWZT3dLT85WMGg7IAVQkTM0+kjkbtsiNHWTjCzJMtC7cuzJ7BnNZ7kmDjBVqW8JRnmNpZBisHI9iqK0Z0B45j8/R1sIlkIHlUEPkRFOgMnIBv8zyWKDYrcmMTRp83m26IVTzFCw/59K6u61nGbadwDsOIX1O/4y/2L/qIbeuiUxaPkDoGofYI8lxMI5u4rLh0/6kdUK+s44lMYsIYy/zmrglIqomrpdwZZYEuB/5PSntsGyrHcTusy3oOCIS32vybK4G/uzFgNwsx8T/Kjj/YrlTFFMY/gXaN8CjKMXF+CTTVMqQBHQPz3pbw5HtkTHyxS2oup5DKxK6dSGkLtEwp3Z1uHIa2PmNZSdSsQvbsDbx3gdpdZee8Asurf8EvajWLz4d4Z5SzkX5dufbllzwVzAOO89EtT5/KbuejB9K04+T5BEKO++aoLdpQLTu9hJvNlXo
 SbYEBW/B
 roEOEs8x4u9bb7HJszDyMYjcnMpnvS1Ko2fAT5CnYLq2KI165BxkWJonSQ/jeH3TH+lBT90c7awPdJTrrdkKpAVEshwcKPE2IHlXcuqeKzhURsiZHFB1boOk9bvelgG2RSMQONdLSYUlEhn0uwb0RvVFhMOtEf4mDhirgeQwORwmyw/Y481Tnpg8H1tfyS2kd+R9TYG2711TtsUBeT42nJKh1wwDfseO4V68ZXn8895QOUa9+HTPrdd9582QodmURqY41f9kO1w9BxgAql00FhFm/0deOp2hO0oq5zTv/IuCcIJkcWFdxPMCOHo78fKHwsGvyin1TQ/tY1wNFFjDfq7Y1psYDYw9q80UrMX0KrKatC+iZd6ptfss9uBde14N4wyZ03ErmNB3d+8tKJi90eLPqRBo8DM3Fv+Mdm4yGHcsFnbMBq20mi/LrAsCWy2Rt6A7KYhnxud2NWWJmkWzfCylob1g5CUvnEgEa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:01=E2=80=AFAM Brendan Jackman <jackmanb@google.co=
m> wrote:
>
> It's pretty confusing that:
>
> - The slowpath and fastpath have a totally distinct set of alloc_flags.
>
> - gfp_to_alloc_flags() sounds generic but it only influences the
>   slowpath.
>
> - prepare_alloc_pages() is generic in that it sets up the
>   alloc_context, but the alloc_flags it generates are only used for the
>   fastpath.

I understand you want to clarify the usage but this particular point
seems to be an implementation detail. IOW, if tomorrow
__alloc_frozen_pages_noprof() is changed to use alloc_flags when
calling __alloc_pages_slowpath(), would we be renaming it back? So, I
would suggest keeping alloc_flags as is in prepare_alloc_pages() and
its callers. The rest LGTM.

>
> Rename some variables to highlight which alloc_flags are
> fastpath-specific. Rename gfp_to_alloc_flags() to highlight that it's
> slowpath-specific.
>
> gfp_to_alloc_flags_cma()'s current name is actually fine, but rename it
> anyway, just for consistency.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6c4eb6908bd95..bc05d75a41627 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3771,8 +3771,8 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp=
_mask)
>  }
>
>  /* Must be called after current_gfp_context() which can change gfp_mask =
*/
> -static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
> -                                                 unsigned int alloc_flag=
s)
> +static inline unsigned int cma_alloc_flags(gfp_t gfp_mask,
> +                                          unsigned int alloc_flags)
>  {
>  #ifdef CONFIG_CMA
>         if (gfp_migratetype(gfp_mask) =3D=3D MIGRATE_MOVABLE)
> @@ -4471,7 +4471,7 @@ static void wake_all_kswapds(unsigned int order, gf=
p_t gfp_mask,
>  }
>
>  static inline unsigned int
> -gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
> +slowpath_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  {
>         unsigned int alloc_flags =3D ALLOC_WMARK_MIN | ALLOC_CPUSET;
>
> @@ -4508,7 +4508,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int ord=
er)
>         } else if (unlikely(rt_or_dl_task(current)) && in_task())
>                 alloc_flags |=3D ALLOC_MIN_RESERVE;
>
> -       alloc_flags =3D gfp_to_alloc_flags_cma(gfp_mask, alloc_flags);
> +       alloc_flags =3D cma_alloc_flags(gfp_mask, alloc_flags);
>
>         if (defrag_mode)
>                 alloc_flags |=3D ALLOC_NOFRAGMENT;
> @@ -4774,7 +4774,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int=
 order,
>          * kswapd needs to be woken up, and to avoid the cost of setting =
up
>          * alloc_flags precisely. So we do that now.
>          */
> -       alloc_flags =3D gfp_to_alloc_flags(gfp_mask, order);
> +       alloc_flags =3D slowpath_alloc_flags(gfp_mask, order);
>
>         /*
>          * We need to recalculate the starting point for the zonelist ite=
rator
> @@ -4815,7 +4815,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int=
 order,
>
>         reserve_flags =3D __gfp_pfmemalloc_flags(gfp_mask);
>         if (reserve_flags)
> -               alloc_flags =3D gfp_to_alloc_flags_cma(gfp_mask, reserve_=
flags) |
> +               alloc_flags =3D cma_alloc_flags(gfp_mask, reserve_flags) =
|
>                                           (alloc_flags & ALLOC_KSWAPD);
>
>         /*
> @@ -5017,7 +5017,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int=
 order,
>  static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int orde=
r,
>                 int preferred_nid, nodemask_t *nodemask,
>                 struct alloc_context *ac, gfp_t *alloc_gfp,
> -               unsigned int *alloc_flags)
> +               unsigned int *fastpath_alloc_flags)
>  {
>         ac->highest_zoneidx =3D gfp_zone(gfp_mask);
>         ac->zonelist =3D node_zonelist(preferred_nid, gfp_mask);
> @@ -5033,7 +5033,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_ma=
sk, unsigned int order,
>                 if (in_task() && !ac->nodemask)
>                         ac->nodemask =3D &cpuset_current_mems_allowed;
>                 else
> -                       *alloc_flags |=3D ALLOC_CPUSET;
> +                       *fastpath_alloc_flags |=3D ALLOC_CPUSET;
>         }
>
>         might_alloc(gfp_mask);
> @@ -5042,11 +5042,11 @@ static inline bool prepare_alloc_pages(gfp_t gfp_=
mask, unsigned int order,
>          * Don't invoke should_fail logic, since it may call
>          * get_random_u32() and printk() which need to spin_lock.
>          */
> -       if (!(*alloc_flags & ALLOC_NOLOCK) &&
> +       if (!(*fastpath_alloc_flags & ALLOC_NOLOCK) &&
>             should_fail_alloc_page(gfp_mask, order))
>                 return false;
>
> -       *alloc_flags =3D gfp_to_alloc_flags_cma(gfp_mask, *alloc_flags);
> +       *fastpath_alloc_flags =3D cma_alloc_flags(gfp_mask, *fastpath_all=
oc_flags);
>
>         /* Dirty zone balancing only done in the fast path */
>         ac->spread_dirty_pages =3D (gfp_mask & __GFP_WRITE);
> @@ -5260,7 +5260,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp,=
 unsigned int order,
>                 int preferred_nid, nodemask_t *nodemask)
>  {
>         struct page *page;
> -       unsigned int alloc_flags =3D ALLOC_WMARK_LOW;
> +       unsigned int fastpath_alloc_flags =3D ALLOC_WMARK_LOW;
>         gfp_t alloc_gfp; /* The gfp_t that was actually used for allocati=
on */
>         struct alloc_context ac =3D { };
>
> @@ -5282,17 +5282,17 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gf=
p, unsigned int order,
>         gfp =3D current_gfp_context(gfp);
>         alloc_gfp =3D gfp;
>         if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac=
,
> -                       &alloc_gfp, &alloc_flags))
> +                       &alloc_gfp, &fastpath_alloc_flags))
>                 return NULL;
>
>         /*
>          * Forbid the first pass from falling back to types that fragment
>          * memory until all local zones are considered.
>          */
> -       alloc_flags |=3D alloc_flags_nofragment(zonelist_zone(ac.preferre=
d_zoneref), gfp);
> +       fastpath_alloc_flags |=3D alloc_flags_nofragment(zonelist_zone(ac=
.preferred_zoneref), gfp);
>
>         /* First allocation attempt */
> -       page =3D get_page_from_freelist(alloc_gfp, order, alloc_flags, &a=
c);
> +       page =3D get_page_from_freelist(alloc_gfp, order, fastpath_alloc_=
flags, &ac);
>         if (likely(page))
>                 goto out;
>
>
> --
> 2.54.0
>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38D1CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64746B0092; Wed, 17 Jun 2026 10:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3BDE6B0096; Wed, 17 Jun 2026 10:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951406B0099; Wed, 17 Jun 2026 10:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5738E6B0092
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C82298DDCA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:31 +0000 (UTC)
X-FDA: 84889685622.13.E7873A7
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id D2D57140007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KpaaWb44;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhQaVfAQOt3padp74Km2bFuDFtNkF12cIPOSV2s4BpU=;
	b=8qAmztWF/eZ90nSIGDk0Yclmg3c0qdwI4Wo1nKBcXIbjVkV86nUcmqeCHjZHH6tjg/xgdA
	c50JieHjVbxysNliaKaJJmDltIlZ0YCDLHDCfr/gi4Zc0FNBTYz1c64HWHZLp9dQ6CDXb3
	8gRvHeNoI1JcUvl0p6y0Zc/sZmnYHUY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KpaaWb44;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781707709;
	b=XU61TIzj4ORp+MSvp++tL6bI0gOBEkH6awYyk0Je533vzvWdLr/Pmod9yOyGHkoo4gq0Vo
	n8agQyXM6PE5UUBaWT3Zy1e3/poTZ1hooS5nEUeooPXn5FY2UotFsQxEhj+u8yK8ATEXR5
	MUpRtoaeV432walGkqCx9nr4JK17pJQ=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5177d1ff061so267881cf.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:48:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781707709; cv=none;
        d=google.com; s=arc-20240605;
        b=Jd8hvQn38UizUXW1VSczMFEr9ufqKexbrEIcA7Ct0IyLq6ZwqmiL5xsUbp1rgKt8Tn
         pRyylf4I+N6jTWSELnaP9dz7gRnWci2Xkqfx00KpxxM6e8uxiukZrYN7WlUGn1tXHQLK
         AO//i+IDApMaJfMwCpx3c0vzKZyPcX6ZL8tXYLpElTDdufBznxAQ05k1vbeqNAE+zr6c
         3ED43l8wj5NYTi69KshqfdDO7fDp7f+3IJALa9bY78fRwoMAt4S/QMjRo3NmEzfFaXID
         HnaTYXeh7NYj/Xtue+Tp+js1lO0PwcT2rhrWavIKS2jIbL83NdU/oleQ+x6SPyvs95Bq
         R3Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XhQaVfAQOt3padp74Km2bFuDFtNkF12cIPOSV2s4BpU=;
        fh=q3TgIiy58YNSz/grs2K2CyVbntbAQeKVrIZ6WOotgVI=;
        b=EUj7YXfIyEY6FzRV22Arg0WM09QZgff4IEMNrvT4i4OS+l7MHMKpXweOjyj301YU7h
         6jzjG4VbHZDwfKX9JOHmy+WREg2YY9svXpSS7+mVs+Z0roS+G/gVaOwRq6KvzQWPQbtj
         KFJMZO5JY6HRLQbE+02jOFh+NX17CnZSeNUiVbs+NJkqGdjJK8yIMg/kngCpqeMdgum2
         pUhpynDGsjGglSEyRc18FlyGqsalfQeMD+QuJd1MejIlSX59KXntqNPc/+syPCqvZIbr
         1VtEsNnXV3FLHqXpJEXsaG79VDecur6ZE8agjyb8KE+8cF+TWugCAAZMDCy1M2o73s8y
         v27A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707709; x=1782312509; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XhQaVfAQOt3padp74Km2bFuDFtNkF12cIPOSV2s4BpU=;
        b=KpaaWb44rDTDyPxvE81qxGmWs3VTKX0X2AOYO3LIOoKLOx/e15BYYcbKH6Qub9l6aC
         qE+6skpUhO8hNkdyVI46+yMSFTpos1XI5+yG/t1Z89uZ18U5LKL6SepTikzkvU8Dratg
         lalYJNVPOo/gnGDYmzIhnKoH7EnkzGhzF72uxGqpe7t3M5ZEKfrdVgrvNysW978f7CtL
         9K9cbkcmuXmuJganIqhEi92HlxJRycz28WlHgFUDmT8+j0/oxO9P2Y6Abs6sG+PV6wHt
         URimMMbehHGKzJI0TZ7aJh3RzapkLOSSH8weuytf0EGzJbkpPqaO4q9IJQ2qd5cUNQuV
         d0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707709; x=1782312509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XhQaVfAQOt3padp74Km2bFuDFtNkF12cIPOSV2s4BpU=;
        b=Y0mrogZdv3lj2VP3y8O3N9fiRo00LOEflVgMJCAnyXttruotCPvUR7xPoTZNPfSfo6
         a7gEssQO6CTJas7NWynWJ31Wk0KYwOCREzCckKuK+tL6ZdT0yOz4S7zli1XHibtNdNti
         deyJNpT1JgWOCnJIQRsZK5Q3iX6q23aqc/yW1n5FqWHumrZbWC8bAhTF+aqVhsDMCkMh
         wW/f2GfZHoKolyYLhXQ8eXnKixFljLOrSwEMAjysYYgfspKW/I/FQ5qaLUQHeageu18N
         yXblJh+7Gt708q0qKNf2dOQvE1UR8DQ66o6na2iMccADW8SLwo0ffvZHi+vswLxjT9op
         0GFA==
X-Forwarded-Encrypted: i=1; AFNElJ8hloxRpm38/RAWNCtQzt2cqi6C2wMG+LOMdE+bKJ7+Dx1e8WkQpdxjgrkjMMyuVvKx9aBaqQug6A==@kvack.org
X-Gm-Message-State: AOJu0YyipEHYMWPVJIJ+6LyMFXVwKexJYP4kO7ZXf7m01pt7gcOzMKM6
	94pFbsKAYbStykCNx+yM6EcVQo4vDTG5hqQzcfBq5QpL7q50cBYWUhSlkXCZS3H8JEiCaxrbQ0C
	S/zX0gBUKahzTYWJQCuSJITeYxdP08tE7cLtb+ZFH
X-Gm-Gg: Acq92OETFvfyshIgsZZs4je94y9hdjyaicZx09dABmcE2l4Cpg95TWZCP/RcM4qmjZC
	j8SCYxTY+qdqcwZkjhef2hYUbVDNd12Owxua1Mz9tMA+WHoXEeduHKH2g3IB8PoGMLObKovyMib
	3twNQhmwj2V1BoXFdM1hLh0wRbE20R/sNCBd+dCCrAc6eKefcUGnJGv7BUAzhwiYAWocz+hX26w
	V/w3Nu3Qjg4syaEsllHKm7euhxc+lbz7zoYweIq4/u0tc1eeyy6IjQfAGio0R/wz70CqdxRpACP
	9/+nTtN/ggAYl6pYSXv4pvmJXms=
X-Received: by 2002:a05:622a:2589:b0:517:99ea:ab77 with SMTP id
 d75a77b69052e-519adac7249mr8262361cf.23.1781707708059; Wed, 17 Jun 2026
 07:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-8-ce1146d140fb@kernel.org> <e9beb94a-6508-4bd0-b641-41e718990f7b@kernel.org>
In-Reply-To: <e9beb94a-6508-4bd0-b641-41e718990f7b@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 07:48:15 -0700
X-Gm-Features: AVVi8Cfwx7Hy97TQzo9j3Ib9iva_orAIE7OvChCK-GCxierIP-7yyp4HmbiYDGw
Message-ID: <CAJuCfpEMf=n5UL7FCfptLqDm9PiE5b0BSLUfraew4dcpiZv-6A@mail.gmail.com>
Subject: Re: [PATCH v3 08/15] mm/slab: pass alloc_flags through
 slab_post_alloc_hook() chain
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: c5puaxm811ma1fq7cmxyoh11mcxbab63
X-Rspamd-Queue-Id: D2D57140007
X-HE-Tag: 1781707709-568104
X-HE-Meta: U2FsdGVkX1/OupcD5aR+eWTXIyEVJIcIWptspADz2iO0M6tZFYximOY/XsrpkrYGCHvT0570/WAa3WlHoIecNuJPT1osagdx4toxnAfzC3qLRHBPWN79lGJQU4bbo4OSF/DD8QVcfWnzYoJ1igsBSzwiSKMbI1eb4y2Sqa10BRf73BoNryp9PA09+8O4oXIlfIMtkLsqavy6C1m5f3xWms8BkkUiqMpk4H5bV857j3Ckx2xA/dri4vHYADv5kAjgP3lSQQmaG0SfqvK8HKKfBrBqgW/aGP/nzBvQyZo5yb/kWvspifdrgoPzzhVA3FJ8WhlEPP0K1eeVEXncbzTNm6DVjm+kBV2LLpDy1epjqcrcyelvyvetb3o8/6bbHZSiFl2nWSnBiGOs9NKH2xkeL2CT0tGVJFuNVUf6kn10m7tiLokgSjofyxxlNKfmIjPaIzye+HOaJDGSY5dAd/dXkp6qfNYqe38TYd8r26JlQTiiQbzjABOYoxARNPGbUSC8RhQqmY/jGGmtOMjUaavEe/2hHI+TTsy68VZBW+pKRiti1XWBR1ePUGbGW7CSUOtrCCG+5Qglas6CZ34HpRejBoL7SKIfrDFj0eaA3TgtEwIOS4AhfQLb4lvyWc9bcF7t6ksiY7IsWtrtcDI88UfOX4IVe5mD56uvMMEWA38H4ihwx9qlpwawbFCWABdL0rnp5afSVBkTN87W5quGhN0Uhg6FWN31glU+j97YYe9JjZvlz2kRW6vAwEhzDczelkYp36R/WRF3hko3cIcdyinOz1gJLq88uCJTVPZl0EDb3qMfj+y6UTve5LS/5tvIv/RVDsfgxfcpzvF42KnAioGy1r6iq8Wc5UcTLmriV4IEdx/uBlpVJloPW7vT0TRVj7HJj4eu9rs8yw7YtWO4wgXU4lLSSKYPLlhLIuu30sDdJFBFWn6K1T2Fl/dAVl7PblAAC7L/dGj+KlkTChxTZ5d
 rSyc+wgG
 ILplSCil3D2VwQTxy26FU3gm2xa2K4IndKiVfg3F8j9BjBdqs1zBQ5sZtLtRIQVyXOtUyKBV4FNhtRjl4WdDfz7C3F1KTt/D5NcMQVDLldpjz3oxXY+PTwEn6SEVTPqsv+J7WQrNjrL8Fm7XqO3MAEyecepr1Wkv5oN2l38A5lU4+pZ8Pj2xEqiqUNNGeJkne8OV8ksClbBgZqrQMDKmQcrq5R5hLIVjKdMt47fKKzsOO+SMfmBeSfZtqj40xkqACU/guvsJcvesn8UMSLZ/qSHTWzlQ9GTXz6uhX4IMbOX8dGJSHRWDtHkAwadY4PRuBOEVmN5D4MOhxlGoLw9McDjRHu+cSl9WN+XsuFmt/kTd/rDEjkTA+eLbq8c/irxpxZey0ZinemswpDyGCIsRCZu7cUbirbboPYKFi8ttNTZr/Yks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 12:37=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote=
:
>
>
>
> On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> > Convert the whole following call stack to pass either slab_alloc_contex=
t
> > (thus including alloc_flags) or just alloc_flags as necessary:
> >
> > slab_post_alloc_hook()
> >   alloc_tagging_slab_alloc_hook()
> >     __alloc_tagging_slab_alloc_hook()
> >       prepare_slab_obj_exts_hook()
> >         alloc_slab_obj_exts()
> >   memcg_slab_post_alloc_hook()
> >     __memcg_slab_post_alloc_hook()
> >       alloc_slab_obj_exts()
> >
> > Converting all these at once avoids unnecessary churn and is mostly
> > mechanical.
> >
> > This ultimately allows to decide if spinning is allowed using
> > alloc_flags in alloc_slab_obj_exts(), as well as slab_post_alloc_hook()=
.
> > Aside from alloc_from_pcs_bulk() (to be handled next) there is nothing
> > else in slab itself relying on gfpflags_allow_spinning() which can
> > be false even if not called from kmalloc_nolock().
> >
> > A followup change will also use the alloc_flags availability in the cal=
l
> > stack above to remove the __GFP_NO_OBJ_EXT flag.
> >
> > For alloc_slab_obj_exts(), also replace the suboptimal "bool new_slab"
> > parameter with a SLAB_ALLOC_NEW_SLAB flag with identical functionality.
> >
> > To further reduce the number of parameters of slab_post_alloc_hook(),
> > also make 'struct list_lru *lru' (which is NULL for most callers) a new
> > field of slab_alloc_context.
> >
> > Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-9-7190909db=
118@kernel.org
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


>
> --
> Cheers,
> Harry / Hyeonggon


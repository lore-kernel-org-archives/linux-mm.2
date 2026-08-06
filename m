Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D64CC5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D4D6B008A; Thu,  6 Aug 2026 13:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E186B0092; Thu,  6 Aug 2026 13:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515826B0093; Thu,  6 Aug 2026 13:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 282CF6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:34:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7CFA12018B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:34:21 +0000 (UTC)
X-FDA: 85071543522.04.0442F2D
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6466C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:34:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tmn7sukO;
	spf=pass (imf10.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786037659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCR1qDDMxpWT1q1y9n/hXUXouwY3dKUCkqkjzOyCS4w=;
	b=3CN/SBMSuGvXBYb16NEh+oUCuEzNpV1rifMo0rxTsv+W5Jz8dGbNqiMEuS0FFUgQzgMZ1v
	17rqTMj3pZen6k08clpt/SUwQ3cZdvsADsxilbNOfPivG2K4HOCgGFar1yr+/qbsn8A0a7
	DXaJOhvGfhmaN8GIZJCtdZDhtOixFGU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786037659;
	b=09DkPTTv3MGTxriVtV+GIFf2A1hHUwJMCvLc4oaQFcDVWCeLaNZP7QLpBuf4v3j6cJEly7
	h/CIRJz7oMcuPr6qVCx7YwO4ktD5HdXSKnM+5Esrta5uP5S7bXDxhtymUBwCzeCVrErSFR
	2z3bmSqwLw/WfYPBeQiV+KaXV9WUOUM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tmn7sukO;
	spf=pass (imf10.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b2a8173142so534e87.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 10:34:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786037658; cv=none;
        d=google.com; s=arc-20260327;
        b=nADeM/FuoJjcBByMNq3sb4wL7rNOlRab9oL6s5hPhDtYGvjZs/CochBUAqsQ4DmfPn
         qIbpORAvmSisoWlb0B6pXuEFCONHaeF9U21oavRkMrKf/YXGIJulAYuDJfpawx986BJT
         uHc4+u8fj8YXYKAnUm2plPGgEjsS79KapjDUP5c8MNnDg6+umWThi2JhI+RvRvWq2dl4
         cCgRjrkUCqslfv9HMRdEWywOVFm9BEJqHyO6w+lhIehH9BPvLN/xJe7546WMi66nEKTh
         g50zc6rWlhw53PdBAZmviZNT2shZNEgIYitTmLZ301CYQu75PV5Nqfaigkne4sdImXzk
         qgyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XCR1qDDMxpWT1q1y9n/hXUXouwY3dKUCkqkjzOyCS4w=;
        fh=NsvPZuqBxpWUZ2PybecrfhrxdYyQsA2klqkWBkumJnA=;
        b=ZeVGaAMyj7ZYk/170NU9UrZKMcIw5X451CMRJr0WdQ5F4KRRT1zU6YXwNXDUBO0ADn
         /VWQTe3ZseM18PpmZ9WRfegNrm0YcEbnE6/nY5ST3pCcnhRWuFI/yPHxu4IbqV6oD40F
         dkMCYfUTgIGsOMNSyV12QOJmSbig5+kyfFMwBDbPQ+u6JsqImHGrGbhLpXmojGIm6ENl
         j1kTEkRNzC9/AMujuX6byoXWPpnlxv1j7i5XrIAP0eOhtTPPUSvamPT49v+X1KFOPNOy
         VzhAUv04DuS7w6hOd7ai1SWpu93zqbrakJGZx1dAG0ra9bpBDqIRAkBqWNRuNZYBwAyI
         mD0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786037658; x=1786642458; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XCR1qDDMxpWT1q1y9n/hXUXouwY3dKUCkqkjzOyCS4w=;
        b=tmn7sukORmmxUbRXxCujj/TLsBDkFp527+liHnixavrHqMFuqf7zUbd4NteqF/XyFE
         BFK/rvnfWR00BExNH/t3jjRlolGRzWn6u/OCUE3GdG4tFMrmbvvdBJ7cToX2bLJR7vTP
         888L1eHdIWaPrSnNhLPwsFqZVGywi/lfejS0X47s4cbGSUD349cot+bAdGeyLfnTigN6
         QuSB0vSyHVJkneHTF3VtHIig3/MTNX4pb6xJiUVC+tlQwOBTS8jVZ01LwuPa1lOBqZ1C
         vIAV0ZSzWXJuohCrwEEx16FACvMXcpzUwAraROPhV0x/gdjUB23OsYBSgElpZih0E1ix
         gV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786037658; x=1786642458;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XCR1qDDMxpWT1q1y9n/hXUXouwY3dKUCkqkjzOyCS4w=;
        b=WncsiSS0vTjUzyxSBP7PbZN8RBXGJysUpvQrgtO2c/6y0yZx0A0Wm4gSJjaHZg+AUu
         WehDfqMqZbqTk56g8t+9QzszUKCeohUUJKaqE5uOFk26v1Y4+pxN2Yh5waVhrE+aVFZ9
         IlLp4WevNsfTzTzvnlcPzWxIKe7bPgC0HBFqAPIivFdEU6mm/3jSxf76hkreCDDMzfBd
         d/B9F8h8eiqBYfgP3366SmUOkpaAfwAjM728HrJ0YAChL6fe0TQ5jD9Sr/vGdXAhnzrX
         euRebmFFrz04qeckXqaw4WzfTfkkud8r97ow4JESQUH6dmukZAbcwaYIdoD75S6GAXQw
         k6RQ==
X-Forwarded-Encrypted: i=1; AHgh+RpqZc+ayLiAxY4W8c6p8FEKVP9hfYE9j7VgOrE9XmHmQllWCJfrLwx+3waDS615HhntlIOvhVvPeQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8m72JkLalEA4Rzwqt+2Ax9gxdVddagW+sRJcJslSJP2LYMf3Z
	FBCyYDIJw8JFBJJnecV8P74ZE2wLL3VSfsoyPoBplju7+hleRRNZ0mopLFfzhGszxdbiTxucjJF
	UuwPsoQqNfSRhSKhqYeB7b6k2FBSyzUJPibPrhM78
X-Gm-Gg: AR+sD108/ibhDSy3LhoSrjyCBROnPPJxQSU0ZaVTSYGuOfUrHfcTwvf3a1EePE+NXCp
	0gc7ikt9JFAz62ktTwD7ZEG1JFy+IThxSmfpN5oaLmR8IEd0pPejC54dMkTkbPzGQ8tnzNNPBDU
	iSmjc/ECorf1Oa3/Kr2N8HJzM1AxV9M1EBmHM/5WucWTobAaydFrrgqwZY8xSJBfuA4L4ztQ/eb
	dlPzW044uhPmUlbxvF1iRNm0Wy0CoJy09yk9iye1yZ3DmKFOZHZA/n5vNlcZfzDhuZ86rXS/x6n
	r1yxX5ZZSoyP8a4FYB+W6/IdOpViJyLQZJL7co0ffD+4dHfZjLQUav7QrqeSMOnxuhM5oh9uKHy
	qO8Wk0nFwbIh8HiF1DyAhHyoTTqvsnc6BWA==
X-Received: by 2002:a05:6512:12ce:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5b304c0a61fmr5648e87.2.1786037657162; Thu, 06 Aug 2026 10:34:17
 -0700 (PDT)
MIME-Version: 1.0
References: <20260806085651.4068433-1-souravpanda@google.com> <0dee4ba8-d68d-453d-91d8-b2c937c8682f@linux.dev>
In-Reply-To: <0dee4ba8-d68d-453d-91d8-b2c937c8682f@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Thu, 6 Aug 2026 10:34:05 -0700
X-Gm-Features: AUfX_myHLkZTN8cmRvp69rUZfFNnysxcafWTpodoWq3X9xVetJKBAM59AgqrLb4
Message-ID: <CANruzcQeg8Fcwi7_2QoKXERwX=q-7xdAaforPm9YKQUBssgWHA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
To: Usama Arif <usama.arif@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	rientjes@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zf9g1dubfdmz57h9w7x3m9owj6pk7rqg
X-Rspamd-Queue-Id: A6466C0002
X-HE-Tag: 1786037659-445928
X-HE-Meta: U2FsdGVkX194N2VVR76fz+dJSRI7iblzi3rxyotrcw4z/d3VP7NnnPJ0Y3TZJ7msY+oaGR3OCHnY4TUlV3TIesnmuzkgeRzFNJ8LLdvuJHA0qjdRDk/kQyOwxIenVckseku91DV5e+35lE0nRV6GUoi0RrCgwGQ0K/ayPKMz/Lb/K6xbuqrHm3sMf2zaip5kBaqMokNR9QuIP7yqV0gYc5PEXVdNlDu7qvPiaVg/2ShqnwMKADpgqewJdER57ZXHmC0ienQfU1gBpQ4YTERL6woiGOxhQkGtFxiFcucXcwE8W1K+xSXaG+LIlsVMWt0PQC1z0oXQ75HUqT/Ze0Q3hhm/6B52LqiCP56Fr0axJobPYarwgx/C2GwebiowBTHqEBYvbqq82AH5v4G4zj4X0Mddj334S49NsxPEeYxyLypDAzBJI+qhdETdWmUo99HXe0uekm4aL3ftXKq/Hw6BCPPx/OuNYJ+m86XF5AP6Vy3Rk81JKNLdrDUHkZNgww50CfZf2aUw8x3RG7N8r03csM7AJninyGSxcXAkYr0nzpPo7mXHuhIxTCoCrdxDqnoXOwnzrgwEPDNwsC3w47SE8KojFM7vl8dL9caZgi8VvZIknDmIYcFba9zGmkDA96mV5oLbTGZaIjKH1RSwx8cXUM2gkszx+xbxHNaiShLGEXxDU3x9EF/Rla6cvXPD5De6IfoENDW23HngATfIkXbVF+dNT3xPDTYXrKcguD1U8qHPUkl4NgJTKYq/YVhqC5rHaPXhj8+ECEcbh/KLe3Rg8CuT/qMDxEiUEev3fKA+EoxoCzuB0MtsQhtMs1++6bKBe7w4VJ6VdfFC2+PpVsu1Na4QnNcKZqALA8lmdt+vyWo9PBANcSCIkVRaJNufq+kYbPHN3B93pGmreu8fNJ/Ol0SFMbvuYPPh7c/CIqZq/ZJEj9X7EGzRuJ2bpA1oxBOHi1DnRJwMRRxFi14XXPF
 Dg3Ugh9N
 AJdt5M6qcm4H7oB0+PnUHekXoSU24+2MiEJy+MtwNUlJ1mXE1j3elLRkOAZERjOiWoyhu6m6NQlRfcgWghqP8Japo0kG+RDIA4/+aU5ujD9BLNkB8sAjoCy/GZaHTtFkuEvt2KM0eBrH2Ypx345RKx1/GR8yhBXKQsZ3AFt8n4yZIva1r/bBIO1C/7IpW3s1b/AMrFOgCvkKfEISJ7VrWE9cQ2H1sLGmkHbV6ko6tVQliV2aFAd5O7LKzTRSEPS7wsAdQfN5BQW4WB4gfrm2hHsHoy+e8KOPdlS06lEY8GjSIwheaIG/eRAB0y9wbLd8CX1jyiPY7V6lIYc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 5:15=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
>
>
> On 06/08/2026 09:56, Sourav Panda wrote:
> > Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
> > hugetlb_cma=3D2G or hugetlb_cma=3D0:1G,1:1G). This can be restrictive i=
n
> > heterogeneous environments or when deploying common kernel command line=
s
> > across machines with different memory capacities.
> >
> > Add support for percentage-based hugetlb_cma reservation (e.g.,
> > hugetlb_cma=3D20% or hugetlb_cma=3D0:20%,1:10%).
> >
> > The percentage is calculated against the total memory (for global
> > settings) or against the node-specific memory (for node-specific
> > settings) using memblock APIs during early boot.
> >
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > ---
> > Link: https://lore.kernel.org/linux-mm/20260729163148.3271755-1-souravp=
anda@google.com/ [v3]
> > Link: https://lore.kernel.org/linux-mm/20260628190155.3655895-1-souravp=
anda@google.com/ [v2]
> > Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravp=
anda@google.com/ [v1]
> >
> > v4:
> > - Clear global hugetlb_cma_percent and hugetlb_cma_size when node-speci=
fic parameters are parsed so the last command line configuration wins (Usam=
a Arif).
> > - Warn when ALIGN_DOWN rounds down a non-zero percentage-derived reserv=
ation size to 0 MiB (Usama Arif).
> >
> > v3:
> > - Enhance pr_info logs to explicitly show percentage-derived sizes per =
Andrew Morton"s suggestions.
> > - Explicitly align percentage-derived sizes down to the gigantic page s=
ize to prevent allocation failures (Usama Arif).
> >
> >  .../admin-guide/kernel-parameters.txt         |   7 +-
> >  mm/hugetlb_cma.c                              | 141 +++++++++++++++++-
> >  2 files changed, 138 insertions(+), 10 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Document=
ation/admin-guide/kernel-parameters.txt
> > index 5a05b48d1684..846940ce2858 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2064,8 +2064,11 @@ Kernel parameters
> >       hugetlb_cma=3D    [HW,CMA,EARLY] The size of a CMA area used for =
allocation
> >                       of gigantic hugepages. Or using node format, the =
size
> >                       of a CMA area per node can be specified.
> > -                     Format: nn[KMGTPE] or (node format)
> > -                             <node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
> > +                     The size can be an absolute value (e.g., 2G) or a
> > +                     percentage of the total memory or node memory (e.=
g., 20%).
>
> I think it would be good to add something like below in the doc as well:
>
> Percentage-derived sizes are rounded down to a multiple of the
> architecture's gigantic hugepage size and may become zero.
>
>
> And thanks for the patch! This is very useful to have in a heterogeneous =
fleet.
>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Thanks for the reviews Usama :)

I will send v5 today with the documentation change.

>
>
> > +                     Format: nn[KMGTPE] or nn% or (node format)
> > +                             <node>:nn[KMGTPE][,<node>:nn[KMGTPE]] or
> > +                             <node>:nn%[,<node>:nn%]
> >
> >                       Reserve a CMA area of given size and allocate gig=
antic
> >                       hugepages using the CMA allocator. If enabled, th=
e
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index 7693ccefd0c6..2ca014a0a3b8 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -9,6 +9,9 @@
> >  #include <asm/setup.h>
> >
> >  #include <linux/hugetlb.h>
> > +#include <linux/memblock.h>
> > +#include <linux/math.h>
> > +#include <linux/math64.h>
> >  #include "internal.h"
> >  #include "hugetlb_cma.h"
> >
> > @@ -18,6 +21,28 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NU=
MNODES] __initdata;
> >  static bool hugetlb_cma_only __ro_after_init;
> >  static unsigned long hugetlb_cma_size __ro_after_init;
> >
> > +static unsigned int hugetlb_cma_percent __initdata;
> > +static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initda=
ta;
> > +
> > +#ifdef CONFIG_NUMA
> > +static phys_addr_t __init memblock_node_memory_size(int nid)
> > +{
> > +     struct memblock_region *reg;
> > +     phys_addr_t size =3D 0;
> > +
> > +     for_each_mem_region(reg) {
> > +             if (reg->nid =3D=3D nid)
> > +                     size +=3D reg->size;
> > +     }
> > +     return size;
> > +}
> > +#else
> > +static phys_addr_t __init memblock_node_memory_size(int nid)
> > +{
> > +     return memblock_phys_mem_size();
> > +}
> > +#endif
> > +
> >  void hugetlb_cma_free_frozen_folio(struct folio *folio)
> >  {
> >       WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
> > @@ -100,14 +125,31 @@ static int __init cmdline_parse_hugetlb_cma(char =
*p)
> >                       break;
> >
> >               if (s[count] =3D=3D ':') {
> > +                     char *next;
> > +
> >                       if (tmp >=3D MAX_NUMNODES)
> >                               break;
> >                       nid =3D array_index_nospec(tmp, MAX_NUMNODES);
> >
> > +                     hugetlb_cma_size =3D 0;
> > +                     hugetlb_cma_percent =3D 0;
> > +
> >                       s +=3D count + 1;
> > -                     tmp =3D memparse(s, &s);
> > -                     hugetlb_cma_size_in_node[nid] =3D tmp;
> > -                     hugetlb_cma_size +=3D tmp;
> > +                     tmp =3D memparse(s, &next);
> > +                     if (*next =3D=3D '%') {
> > +                             if (tmp > 100) {
> > +                                     pr_warn("hugetlb_cma: invalid per=
centage %lu for node %d\n",
> > +                                             tmp, nid);
> > +                                     break;
> > +                             }
> > +                             hugetlb_cma_percent_in_node[nid] =3D tmp;
> > +                             hugetlb_cma_size_in_node[nid] =3D 0;
> > +                             s =3D next + 1;
> > +                     } else {
> > +                             hugetlb_cma_size_in_node[nid] =3D tmp;
> > +                             hugetlb_cma_percent_in_node[nid] =3D 0;
> > +                             s =3D next;
> > +                     }
> >
> >                       /*
> >                        * Skip the separator if have one, otherwise
> > @@ -118,7 +160,28 @@ static int __init cmdline_parse_hugetlb_cma(char *=
p)
> >                       else
> >                               break;
> >               } else {
> > -                     hugetlb_cma_size =3D memparse(p, &p);
> > +                     char *next;
> > +
> > +                     tmp =3D memparse(p, &next);
> > +                     if (*next =3D=3D '%') {
> > +                             if (tmp > 100) {
> > +                                     pr_warn("hugetlb_cma: invalid per=
centage %lu\n", tmp);
> > +                             } else {
> > +                                     hugetlb_cma_percent =3D tmp;
> > +                                     hugetlb_cma_size =3D 0;
> > +                                     for (nid =3D 0; nid < MAX_NUMNODE=
S; nid++) {
> > +                                             hugetlb_cma_size_in_node[=
nid] =3D 0;
> > +                                             hugetlb_cma_percent_in_no=
de[nid] =3D 0;
> > +                                     }
> > +                             }
> > +                     } else {
> > +                             hugetlb_cma_size =3D tmp;
> > +                             hugetlb_cma_percent =3D 0;
> > +                             for (nid =3D 0; nid < MAX_NUMNODES; nid++=
) {
> > +                                     hugetlb_cma_size_in_node[nid] =3D=
 0;
> > +                                     hugetlb_cma_percent_in_node[nid] =
=3D 0;
> > +                             }
> > +                     }
> >                       break;
> >               }
> >       }
> > @@ -144,8 +207,36 @@ void __init hugetlb_cma_reserve(void)
> >  {
> >       unsigned long size, reserved, per_node, order;
> >       bool node_specific_cma_alloc =3D false;
> > +     bool has_node_specific_param =3D false;
> >       int nid;
> >
> > +     for (nid =3D 0; nid < MAX_NUMNODES; nid++) {
> > +             if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_=
in_node[nid]) {
> > +                     has_node_specific_param =3D true;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     if (has_node_specific_param) {
> > +             hugetlb_cma_size =3D 0;
> > +             for (nid =3D 0; nid < MAX_NUMNODES; nid++) {
> > +                     if (hugetlb_cma_percent_in_node[nid]) {
> > +                             phys_addr_t node_gfp_mem =3D memblock_nod=
e_memory_size(nid);
> > +                             u64 s;
> > +
> > +                             s =3D mul_u64_u32_div((u64)node_gfp_mem,
> > +                                                 hugetlb_cma_percent_i=
n_node[nid],
> > +                                                 100);
> > +
> > +                             hugetlb_cma_size_in_node[nid] =3D s;
> > +                     }
> > +                     hugetlb_cma_size +=3D hugetlb_cma_size_in_node[ni=
d];
> > +             }
> > +     } else if (hugetlb_cma_percent) {
> > +             hugetlb_cma_size =3D mul_u64_u32_div((u64)memblock_phys_m=
em_size(),
> > +                                                hugetlb_cma_percent, 1=
00);
> > +     }
> > +
> >       if (!hugetlb_cma_size)
> >               return;
> >
> > @@ -163,6 +254,32 @@ void __init hugetlb_cma_reserve(void)
> >        */
> >       VM_WARN_ON(order <=3D MAX_PAGE_ORDER);
> >
> > +     if (hugetlb_cma_percent) {
> > +             unsigned long orig_size =3D hugetlb_cma_size;
> > +
> > +             hugetlb_cma_size =3D ALIGN_DOWN(hugetlb_cma_size, PAGE_SI=
ZE << order);
> > +             if (orig_size && !hugetlb_cma_size)
> > +                     pr_warn("hugetlb_cma: reservation size rounded do=
wn to 0 from %lu MiB (%u%%)\n",
> > +                             orig_size / SZ_1M, hugetlb_cma_percent);
> > +     } else if (has_node_specific_param) {
> > +             hugetlb_cma_size =3D 0;
> > +             for (nid =3D 0; nid < MAX_NUMNODES; nid++) {
> > +                     if (hugetlb_cma_percent_in_node[nid]) {
> > +                             unsigned long orig_size =3D hugetlb_cma_s=
ize_in_node[nid];
> > +
> > +                             hugetlb_cma_size_in_node[nid] =3D
> > +                                     ALIGN_DOWN(hugetlb_cma_size_in_no=
de[nid],
> > +                                                PAGE_SIZE << order);
> > +                             if (orig_size && !hugetlb_cma_size_in_nod=
e[nid])
> > +                                     pr_warn("hugetlb_cma: reservation=
 size rounded down to 0 from %lu MiB (%u%%) on node %d\n",
> > +                                             orig_size / SZ_1M,
> > +                                             hugetlb_cma_percent_in_no=
de[nid],
> > +                                             nid);
> > +                     }
> > +                     hugetlb_cma_size +=3D hugetlb_cma_size_in_node[ni=
d];
> > +             }
> > +     }
> > +
> >       hugetlb_bootmem_set_nodes();
> >
> >       for (nid =3D 0; nid < MAX_NUMNODES; nid++) {
> > @@ -205,8 +322,12 @@ void __init hugetlb_cma_reserve(void)
> >               per_node =3D DIV_ROUND_UP(hugetlb_cma_size,
> >                                       nodes_weight(hugetlb_bootmem_node=
s));
> >               per_node =3D round_up(per_node, PAGE_SIZE << order);
> > -             pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per =
node\n",
> > -                     hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
> > +             if (hugetlb_cma_percent)
> > +                     pr_info("hugetlb_cma: reserve %lu MiB (%u%%), up =
to %lu MiB per node\n",
> > +                             hugetlb_cma_size / SZ_1M, hugetlb_cma_per=
cent, per_node / SZ_1M);
> > +             else
> > +                     pr_info("hugetlb_cma: reserve %lu MiB, up to %lu =
MiB per node\n",
> > +                             hugetlb_cma_size / SZ_1M, per_node / SZ_1=
M);
> >       }
> >
> >       reserved =3D 0;
> > @@ -241,8 +362,12 @@ void __init hugetlb_cma_reserve(void)
> >               }
> >
> >               reserved +=3D size;
> > -             pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
> > -                     size / SZ_1M, nid);
> > +             if (hugetlb_cma_percent_in_node[nid])
> > +                     pr_info("hugetlb_cma: reserved %lu MiB (%u%%) on =
node %d\n",
> > +                             size / SZ_1M, hugetlb_cma_percent_in_node=
[nid], nid);
> > +             else
> > +                     pr_info("hugetlb_cma: reserved %lu MiB on node %d=
\n",
> > +                             size / SZ_1M, nid);
> >
> >               if (reserved >=3D hugetlb_cma_size)
> >                       break;
>


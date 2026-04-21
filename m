Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87DEF89242
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D0E6B0088; Tue, 21 Apr 2026 06:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54346B0089; Tue, 21 Apr 2026 06:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A3A6B008A; Tue, 21 Apr 2026 06:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C6AE86B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:20:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 675F25C7DB
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:20:44 +0000 (UTC)
X-FDA: 84682169208.17.EF52AD8
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6653940009
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:20:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JkDLIsxB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776766842; a=rsa-sha256;
	cv=pass;
	b=aitW26KdYGGFzlsGV7NZK3++My3OQpIeakv58FgZ1DdDXvTVVuYooX73zh+xJqIjZzATIG
	z4l64bIDQ7J9t6L2qtIBiNhKxnQsyLt08t5ilr0RNFYrUqdG4TK345/Z+NI/OEOrtITz5l
	FL4+wrsStxbZ/TQNeUzXihjvDyUzvMI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JkDLIsxB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of mclapinski@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776766842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UwrSYvYD9ILrCcSxLJXG2HqJQ3UPcUaYWwodyo07Yk=;
	b=BDy8DmbYV6OzZiix/Af7g21gM5LVTgj7Vm7yJ+S2Fq8uPKpYk4gR1gF/IBtnLf4bmGiP3x
	8QD+4UWFbvncFnu6qSrKix4gXY1hnnocFcVI5l//lsojrh+caYHhF8v3BQMHB04IeSWWt4
	5Q9q3nceEh6pciTeDHefPxCOf3mcjtc=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-126ea4e9697so25433c88.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776766841; cv=none;
        d=google.com; s=arc-20240605;
        b=bcc8p9pfzS1/otRjkZ4CtgIbeA5VoqVCDIXR5WGxH97SId6t9CCDRrS85rCiLofgl+
         SM4NJ5uf2l2DyhmIFlvB61cT1OCNco2YzjEGDnuTDMitxsqkMEpyx5TYR+24N6JrZUYz
         ghkLn2iJUxZY/ph3bmyD1rZbi+QVtzMnmhUBsSwQhFfP25IANFmGr+KpktyF8SWmO6Sg
         wBWFRvBPIwoz+VaBXTKV+WBsvZqdWsWQl+8qObzv1fMjIESqbxkghlraXm0vp5VuC3Ci
         dvCKGd98A/3y5eFV+IHio6kLUdKMWyu3MLCzVTrrsQQE3XYuQ0izgpnf65FMYaj5ICAm
         wBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1UwrSYvYD9ILrCcSxLJXG2HqJQ3UPcUaYWwodyo07Yk=;
        fh=Hau7MBscaDVxTgGKOxRIu0TPZaKTzGTdjHv6XoZQuNA=;
        b=VEfDJFjy1oNACB2YR6/jW8ZpscpUBy4fp9+l+s4/YJWkmM5ySOBSW9ZAAkJ2BX9WrW
         8dbITobbo0Po0J2oSmkxkDt/jPhWf/oirveOVlXYiMQSXiQDErGjMlqkgtChQiI63R9g
         zITIZUOIY+DqKHSNaSFJR6XYn4/nYYPa6SszAVW/ATeI81lAMuP2kGCwz1JUul1LaEmc
         3R5iA5+fgqjv34HhYod3/zjV1ypyT9svWZi1BYMsORvSavurZ5gcvbZu+nTXrvKfGdfZ
         TiNFalBxMq65e7qC7laNTM2KV4zFsSXKC8O2h9a+JExqcc2mxCOxZTL8l4NrRP2kVtqe
         +w6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776766841; x=1777371641; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1UwrSYvYD9ILrCcSxLJXG2HqJQ3UPcUaYWwodyo07Yk=;
        b=JkDLIsxB94KCvkIsCwvWsGfui/zOf8VX5Zt9FHpiI92aho1abY3r0XyuiEWkrEj2t9
         3l5CUTYMgAmvYeeYxvii23IV+WZQxQ8ru0V9Ds1VsH18yeuY+RcjoitCKjdwA7wHe/Rh
         gsqKuWLgit1RqMX1PSXaIMm5iE1cZi23U3GFfVrQsoxRepdfUCwxqrr4dH13P4axTU2J
         WdQFgppcypLvkhUKvKpt6P0TLk9tWMsmANGeYgI+zBJqkHj7E3R53lG6zhTMtIuaC8uC
         /GEI9Cnh19JuLIMttGpV/7BY1/JUTdc7ZB1g6sHUXDwEhqsgkdrIspc+ns/mnEi9DgEK
         lNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776766841; x=1777371641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1UwrSYvYD9ILrCcSxLJXG2HqJQ3UPcUaYWwodyo07Yk=;
        b=d8Y5hlW50OsVn0rzAxNBwqMPx96ybphNI5Jo8wKTTpoOJRtrCi9C5GFcPhg8B4+C4p
         pgcegR2Q/wbUQCz3xDO8xmzs62uETiuPlTgY6rY9siWoKv+xVAk/LEzrMKli/ItiKlhM
         VyQhowMft1BEyL01NO9FvAQjET3FNX+hjZ8rusA81MZEu4eN2IkL+bCI82gJCW0FmUdI
         qurQ0L3ULq+4WEB2zPJhr79oMoe8To4NMHD9safZE+2r1PHUSW+NhJHmqtpkxEoqGzyI
         V06C1y1Y3kBdfjN+uNTSv98NefAg/h+x43es0RwJjvk7WJ2qGgxzuVfLPdB1kadWbyeJ
         BawA==
X-Forwarded-Encrypted: i=1; AFNElJ8LG/xvIKd8esQ1rx/4g4xBWWDkset36UqKOkgtMd54mu2K+bGYV0qCtADjIKNlnCM2OADUORWUXw==@kvack.org
X-Gm-Message-State: AOJu0YyCpoqZfWfDviB7HrOforZuRGMSNKEvQl9TR/bRVsvBy8uTPrfY
	AD6uK1Cmony394lKRacm3xhgyH36tx1vZRSQC/PlSVi7cCiFiffoQwiH1ij+mBbA++CQSvyGTUZ
	IrDVGdV2IIYbP7EeiNtKFTzytoeA7iaF2RyFUCH13
X-Gm-Gg: AeBDievdozyc+kX5ycSDiydicIOm6cwsaiMcvvi3W1oyDGs76SAD6LMU6LE7nUjivsF
	g9Oj/5rOvJDjTJshhxZUppCbwUJuUIDpGgEDBYcV3EHHbYeDcJY074km+BPuZUypR4garHOCLN9
	vSlN8JSOvH8v+o6fksLwlTow4OsalAdDkpbRjEH7IE0UsPMPyUWFzFmKXQLECmK8TpuugklLNnY
	lV6g+MHZfWnx1uwSkB9yWUOtyyP43KJRehEZiTda2SGeNrOkiNdUqaJRnRlE4LWsd7l9rMHz61r
	Q9RBhCQifvETyoEp3+cd2cy9VD0=
X-Received: by 2002:a05:7022:e1a:b0:12c:8f55:cd0d with SMTP id
 a92af1059eb24-12c8f55d347mr302206c88.8.1776766840115; Tue, 21 Apr 2026
 03:20:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260416110654.247398-1-mclapinski@google.com>
 <20260416110654.247398-2-mclapinski@google.com> <aeD2Fzr6yr4pu9-X@kernel.org>
 <CAAi7L5d-ujEa7R21Lmd37X9451KBmK8ZhagSKbJde15aQLi2MQ@mail.gmail.com>
 <aeEKksfLxQ0A7Jun@kernel.org> <CAAi7L5cp3B0DFEQex5EqFdLDkqVWwRw228-pgp0PnhfgLP=e6Q@mail.gmail.com>
 <aecUW-Xgm5MPMyVr@kernel.org>
In-Reply-To: <aecUW-Xgm5MPMyVr@kernel.org>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Tue, 21 Apr 2026 12:20:27 +0200
X-Gm-Features: AQROBzDs3jAHPn3oOPv3D-suXf1b7CCQl5aO-frumb4b7YD1JXID7aO_RKQeeO4
Message-ID: <CAAi7L5d8x1MB1f6A_h2acj1CYU1wf7DijS1TENC+Lurx5wLhKw@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: spn83ptxtx1td9xewdudbwea5kxbwec7
X-Rspam-User: 
X-Rspamd-Queue-Id: 6653940009
X-HE-Tag: 1776766842-264684
X-HE-Meta: U2FsdGVkX1+vWUgYJS3YUcGONAcbpSMGWbTVXZiCwe+GkXViJmX1opGi47HuZq4gYd7kkf95eXymnhqJ8WKvWDcMUripDx46Uj6u856o9VuRAUCsutqupNcvmm2OhGn594BKM+c/tflcgOMN8Rp+EL00MuTFbwJB9Eoo+v3CV7uZLzkbMBo/E3fgV8E9y7l5wH5VYQrtAq8IDZy2WyVEE3r4MPlbLrWud/mtxICPICdYwKcM1kNozbm/I+dhCR05ui9szLMPt5PUOrxYNGfSNz3gwREuepbZ3Ft+/clCZEpwYzHEmTP2PLgbX0IvUPoqjoSnA2qB33QuXlNBa+8fRvPN3ZViv0Hyxoar1ey2WWF0Jqq2O2l62F161p4YU+dvZpVIGPRjEai1LfOxgW8wNEQWFt9d5zsT+V7vx91KB17nHerpRKWt1l6x4jK06HAkuoWBmOBTzbNwtdD5LvPIuXGpTEc/3jnkRSdthmReDMybzV0n1osNfvj8ha5KHZoD1NxS0ZA1eSgNiSwIFPIxJ8jAyHouY/5WXE/cI3kFnwl+1ODPadtOMcwV/f9qrYFLL/Ydi0gOvnDd2TBu6MYatnNRlADm7KEaCdBxaPwQVIzc0RFpUEyFNG2QSry13BZY0lJQop7kD8YVgfW8uNucR7LhvFa3LeTxMoEFuBoVANKdG4Wb0cCGtOfTWMePUafG2mJ7Rufx6db+qli+UKN/H8BXkrnk26DUbBz7OfeM106rppnofJVeDrLgaov6uEi6VUr1r9JbgAuz4gfmktFT/3KYe0EcxTdkBOaoLRF64tqS0Ozn2qcqyesuuz0W2HzM7V695SB/yt8zLa9V27D42B55JAKXf1ehtRtxEerTWJ9PDQ9aLA0ZtmnoZP18+PRFLeBqb9w+9NYC23SbsTEAoP1gG64apA1pYZcIfh5jnWsvqWdfjtaFz/YsF8dKyVhOj7eKQwh+cN9NX45vCQ0
 +cspewgM
 vrWchAWluj8e3jFL/eovdYrXco9T9Jt2egf3rG/SrgkA6sdDTLzgKRPNz3ychyZqJSeZ77Usj/+pxPoGNrk4vpmfXSY30FQtPeAuDkL3rDPSVY505CSXv0zt6qzujPHl5NUEZnPfs3u5mOIIqb8KCNPgyX0M5efjHlNgv4w+IDrE9nCH7aW/QnEAi50PCbGc2I3D0mT9QRsF8T+bS7ih1HNjHgjFvQe2RDlgftFcbcIR3wa16z6Jjr7jTXG9kqPjHPicAg2OC/uUiatLbY1M99sSMHdV/D2m9YfMsm0xYA8NBt8S+u92vlxNRK3OwfEgftFKALFc7ZkC7CTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 8:08=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Apr 20, 2026 at 03:11:03PM +0200, Micha=C5=82 C=C5=82api=C5=84ski=
 wrote:
> > On Thu, Apr 16, 2026 at 6:13=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Thu, Apr 16, 2026 at 05:06:10PM +0200, Micha=C5=82 C=C5=82api=C5=
=84ski wrote:
> > > > On Thu, Apr 16, 2026 at 4:45=E2=80=AFPM Mike Rapoport <rppt@kernel.=
org> wrote:
> > > > >
> > > > > Hi Michal,
> > > > >
> > > > > On Thu, Apr 16, 2026 at 01:06:53PM +0200, Michal Clapinski wrote:
> > > > > > @@ -2262,6 +2253,12 @@ static void __init memmap_init_reserved_=
range(phys_addr_t start,
> > > > > >                * access it yet.
> > > > > >                */
> > > > > >               __SetPageReserved(page);
> > > > > > +
> > > > > > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> > > > >
> > > > > No need for #ifdef here, there's a stub returning false for
> > > > > CONFIG_MEMBLOCK_KHO_SCRATCH=3Dn case.
> > > >
> > > > In all 3 places the #ifdef is there because MIGRATE_CMA might be
> > > > undefined. I already broke mm-new branch in the past because of tha=
t.
> > >
> > > Hmm, that hurts :/
> > >
> > > The best I can think of is to add a static inline in memblock.h and i=
fdefs
> > > around it.
> >
> > Sorry, I don't understand what you mean. What would that static inline =
contain?
>
> Something like this:
>
> #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
> static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
>                                                        enum migratetype m=
t)
> {
>         if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)))
>                 return MIGRATE_CMA
>         return mt;
> }
> #else
> static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
>                                                        enum migratetype m=
t)
> {
>         return mt;
> }
> #endif

How would I use it for this code?

+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
+                 pageblock_aligned(pfn))
+                     init_pageblock_migratetype(page, MIGRATE_CMA, false);
+#endif

It doesn't invoke init_pageblock_migratetype unless pfn is kho scratch.

> Can't say I'm happy about the name, but could not think of something
> better.
>
> > > > > > +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn))=
 &&
> > > > > > +                 pageblock_aligned(pfn))
> > > > > > +                     init_pageblock_migratetype(page, MIGRATE_=
CMA, false);
> > > > > > +#endif
> > > > > >       }
> > > > > >  }
> > >
> > > --
> > > Sincerely yours,
> > > Mike.
>
> --
> Sincerely yours,
> Mike.


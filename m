Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76BA0CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 20:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41E48E0009; Thu, 11 Sep 2025 16:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19A68E0001; Thu, 11 Sep 2025 16:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EF48E0009; Thu, 11 Sep 2025 16:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B273E8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:00:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64C3611A67C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:00:09 +0000 (UTC)
X-FDA: 83878035738.15.4DFDE89
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 833B540016
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:00:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UZUEEi7p;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757620807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkD+pqXJNdt1OuxKV0bNOvEmBbohC30JPJ9RYIj7i1A=;
	b=xaxMTlJ6wtJK15x9swV0EVGMKXKKozOfrtWIyrTVkU75QmgEDCUOrcLmqzZHPFtQLWWa0A
	Rss3Ki2pVhbkJXxTu8pj/sK270kZrBONB3eTTow0ict2y12YHCeA6jPm2duItyXFF7qXDY
	oLIjWvZXXedJ6EFPk8DGe3JuLDOcygQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UZUEEi7p;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757620807; a=rsa-sha256;
	cv=none;
	b=WAAJnSGQYu0n07VeFkOpe75aI4tyfQ7z129qqmssjD8miJa5gg1keXfxmKaeuLpPY/Mw6K
	Rv63qObCASftVKNrmEafS5Os0cjLepkgXJelzYCB721yRJDFrblZspPbJgvLTEUsvqL927
	2mqIIsoYvDbH3noaoba0J95EnHsEBg0=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so114511cf.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757620806; x=1758225606; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkD+pqXJNdt1OuxKV0bNOvEmBbohC30JPJ9RYIj7i1A=;
        b=UZUEEi7pnRtDHYOfHfzKII3kNSfIOD79ZLfwz1/V0TNSwJOt0d9gr9KOCyMzV5aNEx
         d5uyfB+TvK0QysAdApCuNrf/67cEbIeq5wlskqn69N51CULL1hTB4iCkMs+zdfoWR2Qh
         JLe4GdrP7ThEy6s+2Y7RxanwzSGGGi4OOdnYKyaU1PxGsuJVQI+N4aQbCJWHIGCr7ccX
         mqqrLxykWRJDD8c7PJ/y6TD2teauDqiN5AetCFDmAtDZf+e3ZiQDOeRAo2FHV5jwognp
         Y5aEiqRUVpb3eNNXtFE8VBwwxQfe65QZ9IeiTq1rI0LhX+kWnmNowMVVsVsVxVL5uaWr
         h5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757620806; x=1758225606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nkD+pqXJNdt1OuxKV0bNOvEmBbohC30JPJ9RYIj7i1A=;
        b=ix/422HNG5flJumeI8zROdrPOeQeeQFxXLkzLGZeOAVbuf5i/TYkJyHGHgXXOCwQfe
         ZmtoCh9nKMau9Fo1ZReG5OYCO0idzTd7wwwEtyqLjGm3BOrpQOtqVqwTJ5qMoIA+Mw9R
         /bYi8iqX3VhULo2F4341qP1KGNtdHA/qQKCFIyFKMNFbZ9+u5JYQfcY4lV/a9f7skfYm
         zbIGU+VAHkbvD8hi2OgbR7w3RLLhL1Fnv6789lch4tW9fB/VtzC0LPGHzngIBAwFKCIZ
         9XUJTE3a/y04UDsWPmNrl9n2rwe5xqjJfYOHlaR27xdsyCXMdAMoPkWhuiXDqyQ+EajY
         G0UA==
X-Forwarded-Encrypted: i=1; AJvYcCUCxBrTl+lhuFCTL/slMhK3KtGzLbebE+sMSvSYx60K/prjGoRjjcB3d5do9HsI8NF6SQU+yb/6Cg==@kvack.org
X-Gm-Message-State: AOJu0YwF9CZiDeDCtctSpZZrCO+QvnIM5i32jxLd4cmilAxhfjKybuFu
	Kcl74P5Uq/MwkWLhIMZDza1PNCA8Rwf6kYMxjeKrYRpkU1MyBap8XEzYX6O0oqj/54DZ732esKc
	D3+I1/3uQh/J9BeIrUN3u7MLFrkpv1qr0tKQvk2zC
X-Gm-Gg: ASbGnct+5cJNpbi2NpTDgI6o32E8EXrtG9HQCgp6HkGyK+SgeLriHH4tWAyIaMGVh36
	pHpjCBkSgjJic47BG5+LtKk5F4WFhRxRtiU2sgrsh62FlHDlscR0yLXnzc608KXzFl/hrPt/h6Z
	0dg29zB3305xFqSFMH+50Yk69TvXuRKKrLidVmRWWNEo9ZtoEX7Vfo/uPeC2PaxKlZUod2PXR86
	dLZxhWT7/I+eXXXeE/L09PLbp2WvR+jbmH53b1yLKS4
X-Google-Smtp-Source: AGHT+IHeZdkJlTd9IT+e9NkcdPZieCLN2ZSRzHHSXRONjxP05vm+rLHhuto45i9N4ikCBCZuHo8DRlbYui5sC/nKXZg=
X-Received: by 2002:ac8:7e91:0:b0:4a7:179e:5fec with SMTP id
 d75a77b69052e-4b626f02352mr13514471cf.15.1757620805688; Thu, 11 Sep 2025
 13:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250909234942.1104356-1-surenb@google.com> <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com> <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <CAJuCfpGezf06eR7WnzizpwTaxZ5Rm8jbeW4y87zcr6LZuJ9MZA@mail.gmail.com>
 <aMMF8elYvlPoOF+J@devbig569.cln6.facebook.com> <613698f0.a994.19939d88e1c.Coremail.00107082@163.com>
 <CAJuCfpE=0jpana5qryqwPsuoj_8tCEMWFMcEBTB5-9Lyu_j-Tw@mail.gmail.com> <aMMaP6XgGfX3nVVE@devbig569.cln6.facebook.com>
In-Reply-To: <aMMaP6XgGfX3nVVE@devbig569.cln6.facebook.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 12:59:53 -0700
X-Gm-Features: AS18NWDz0STp3NcTsDYvOn1BA7IJ898f8PoI3t-xf78EI7SQvF9-df4h9s1yOGA
Message-ID: <CAJuCfpEFsqO0U9Lp2ssqD53FgmtVZKsMRSQhZzhLRq_a2jD=SA@mail.gmail.com>
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Yueyang Pan <pyyjason@gmail.com>
Cc: David Wang <00107082@163.com>, Usama Arif <usamaarif642@gmail.com>, akpm@linux-foundation.org, 
	kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com, 
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 833B540016
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ei7yef3afedpkzeksmkycxf3i4f4wnbk
X-HE-Tag: 1757620807-702756
X-HE-Meta: U2FsdGVkX1+wYpAgiUPMGNNj1c9ql1F2WcHbL2EkqrA7WoCvqv3C/otlXn9WiFF6gp8wmGWpqemN32VqZIKU8t3q7jvWQ19suY2/9sIF2AZoos0EjywhlXY4wKEbhaV7VZferNX5Xb0C0DiRoCPmkzksMIRfFBY3aH1QPE5oM/beQ6wbrgctOIZlnJrW3Z3qekKs1YdQzBD1ZTe2MlAANlaUoUCloOAkxV36Dji8N4JDQbFImc1Urfn9Ji4n6NTFJm2rg84m8CskZVUeg2RGxMn4C0y64hV6Ke97WV5LRX7wKjH4+8jB2sHzCzozTwOf0VJs7MXzDX31r0Hf54lX3tnLX65roN3mwlprBbjOxvbsydYOqCWuU62XQESzwR9JRRBtbPc3V/KStuuKB7aL3csEg4l1pASXARRGUhWYLOgtdLQSiou+56mtigu+fKNbSzxWMNj8uXruJxmH94fDdIYUdAeBD19f/0uHaYZfTg+IR+RQTOQylnGK2vN10zcAjHYgWxD4Tt7phXaBfKChemKBxuimQYKGxe09tnEPa5aGLKFD6SAj0v5C1Hc+RkHsEXjUh70uH8lToQjPxMSbIcSrRPOAuGotwijDFLrl2xjvwYS8zkoDf0i/2QtLtBD7XkPQtBbI2F+pMlACzlqAjSys71OxDEtvinoiTlDwvFydTytF9oRIXV0lA5ifbfqBsQBsLq9XZa1boL8RjoE7G8wiilRtTZOU+SgmOW90NbtYnbXK0hZaYAGwpnmIr7Tmo7MnrffA1fsIDU/O1rcRXk2AaaF+PdTgd8Oj0MkSw7Lhz55UEI4bP2nf6Ezf1wuHguqKkeCe/yFswHTD4twDvR2cR7lBHm4OmZzQma3TPe/YYyByVseMrjlU0Qb+RxF5Vy8T2MwVjt0Gdr0pBwskdsT8xKFQinJLjxHylkemBZZVGA1By/HgqC5hC6kgd7h2V65ZE9Udh8w41BOKKaT
 e7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 11:51=E2=80=AFAM Yueyang Pan <pyyjason@gmail.com> w=
rote:
>
> On Thu, Sep 11, 2025 at 11:13:58AM -0700, Suren Baghdasaryan wrote:
> > On Thu, Sep 11, 2025 at 10:35=E2=80=AFAM David Wang <00107082@163.com> =
wrote:
> > >
> > >
> > > At 2025-09-12 01:25:05, "Yueyang Pan" <pyyjason@gmail.com> wrote:
> > > >On Thu, Sep 11, 2025 at 09:18:29AM -0700, Suren Baghdasaryan wrote:
> > > >> On Thu, Sep 11, 2025 at 9:00=E2=80=AFAM Usama Arif <usamaarif642@g=
mail.com> wrote:
> > > >> >
> > > >> >
> > > >> >
> > > >> > On 11/09/2025 16:47, Yueyang Pan wrote:
> > > >> > > On Thu, Sep 11, 2025 at 11:03:50PM +0800, David Wang wrote:
> > > >> > >>
> > > >> > >> At 2025-09-10 07:49:42, "Suren Baghdasaryan" <surenb@google.c=
om> wrote:
> > > >> > >>> While rare, memory allocation profiling can contain inaccura=
te counters
> > > >> > >>> if slab object extension vector allocation fails. That alloc=
ation might
> > > >> > >>> succeed later but prior to that, slab allocations that would=
 have used
> > > >> > >>> that object extension vector will not be accounted for. To i=
ndicate
> > > >> > >>> incorrect counters, mark them with an asterisk in the /proc/=
allocinfo
> > > >> > >>> output.
> > > >> > >>> Bump up /proc/allocinfo version to reflect change in the fil=
e format.
> > > >> > >>>
> > > >> > >>> Example output with invalid counters:
> > > >> > >>> allocinfo - version: 2.0
> > > >> > >>>           0        0 arch/x86/kernel/kdebugfs.c:105 func:cre=
ate_setup_data_nodes
> > > >> > >>>           0        0 arch/x86/kernel/alternative.c:2090 func=
:alternatives_smp_module_add
> > > >> > >>>          0*       0* arch/x86/kernel/alternative.c:127 func:=
__its_alloc
> > > >> > >>>           0        0 arch/x86/kernel/fpu/regset.c:160 func:x=
stateregs_set
> > > >> > >>>           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:=
fpstate_realloc
> > > >> > >>>           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 fu=
nc:arch_enable_hybrid_capacity_scale
> > > >> > >>>           0        0 arch/x86/kernel/cpu/amd_cache_disable.c=
:258 func:init_amd_l3_attrs
> > > >> > >>>      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 fun=
c:mce_device_create
> > > >> > >>>       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 f=
unc:mce_gen_pool_create
> > > >> > >>>           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func=
:mce_threshold_create_device
> > > >> > >>>
> > > >> > >>
> > > >> > >> Hi,
> > > >> > >> The changes may  break some client tools, mine included....
> > > >> > >> I don't mind adjusting my tools, but still
> > > >> > >> Is it acceptable  to change
> > > >> > >>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 fun=
c:mce_device_create
> > > >> > >> to
> > > >> > >>       +49152      +48 arch/x86/kernel/cpu/mce/core.c:2709 fun=
c:mce_device_create*
> > > >> > >>
> > > >> > >> The '+' sign make it still standout when view from a terminal=
, and client tools, not all of them though, might not need any changes.
> > > >> > >> And when client want to filter out inaccurate data items, it =
could be done by checking the tailing '*" of func name.
> > > >> > >
> > > >> > > I agree with David on this point. We already have monitoring t=
ool built on top
> > > >> > > of this output across meta fleet. Ideally we would like to kee=
p the format of
> > > >> > > of size and calls the same, even for future version, because a=
dding a * will
> > > >> > > change the format from int to str, which leads to change over =
the regex parser
> > > >> > > many places.
> > > >> > >
> > > >> > > I think simply adding * to the end of function name or filenam=
e is sufficient
> > > >> > > as they are already str.
> > > >> > >
> > > >> >
> > > >> > Instead of:
> > > >> >
> > > >> > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_dev=
ice_create
> > > >> >
> > > >> > Could we do something like:
> > > >> >
> > > >> > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_devic=
e_create(inaccurate)
> > > >>
> > > >> If there is a postprocessing then this would break sometimes later
> > > >> when the function name is parsed, right? So IMO that just postpone=
s
> > > >> the breakage.
> > > >>
> > > >> >
> > > >> > This should hopefully not require any changes to the tools that =
are consuming this file.
> > > >> > I think it might be better to use "(inaccurate)" (without any sp=
ace after function name) or
> > > >> > some other text instead of "+" or "*" to prevent breaking such t=
ools. I dont think we need
> > > >> > to even increment allocinfo version number as well then?
> > > >>
> > > >> I'm wondering if we add a new column at the end like this:
> > > >>
> > > >> 49152      48 arch/x86/kernel/cpu/mce/core.c:2709
> > > >> func:mce_device_create [inaccurate]
> > > >>
> > > >> would that break the parsing tools?
> > > >> Well-designed parsers usually throw away additional fields which t=
hey
> > > >> don't know how to parse. WDYT?
> > > >>
> > > >
> > > >It would break the parse now as we count the number of string to dec=
ide if
> > > >there is an optional module name or not. I don't think it is a big
> > > >deal to fix though.
> >
> > Uh, right. We do have module name as an optional field...
> >
> > >
> > > The inconsistent of module name is really inconvenient for parsing...=
..
> > > Could we make changes to make it consistent, something like:
> > >
> > > diff --git a/lib/codetag.c b/lib/codetag.c
> > > index 545911cebd25..b8a4595adc95 100644
> > > --- a/lib/codetag.c
> > > +++ b/lib/codetag.c
> > > @@ -124,7 +124,7 @@ void codetag_to_text(struct seq_buf *out, struct =
codetag *ct)
> > >                                ct->filename, ct->lineno,
> > >                                ct->modname, ct->function);
> > >         else
> > > -               seq_buf_printf(out, "%s:%u func:%s",
> > > +               seq_buf_printf(out, "%s:%u [kernel] func:%s",
> >
> > Yeah, until someone creates a module called "kernel" :)
> > We could keep the name empty like this:
> >
> > +               seq_buf_printf(out, "%s:%u [] func:%s",
> >
> > but I'm not sure that's the best solution.
> >
>
> I guess the best option would be to decide how the format can evolve
> in the future with some rules in comment or doc. But I am sure who
> will decide the rules...
>
> > If we are really concerned about parsers, I could add an ioctl
> > interface to query the counters which are inaccurate. Would that be
> > better?
>
> I think this would be nice as we just need to add functionality on
> top of the parser when we do need it. I guess most of the time we don't
> care about that temporary imprecision.

We don't care about it until it happens :) I think it would be nice to
have a very visible indication that some values are inaccurate. ioclt
would not do that unfortunately...
Another option is to use the "[]" where we currently encode only
module name to express extra info:

No module, accurate counters:
0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes

Module, accurate counters:
0        0 arch/x86/kernel/kdebugfs.c:105 [my_module]
func:create_setup_data_nodes

No module, inaccurate counters:
0        0 arch/x86/kernel/kdebugfs.c:105 [,inaccurate]
func:create_setup_data_nodes

Module, inaccurate counters:
0        0 arch/x86/kernel/kdebugfs.c:105 [my_module,inaccurate]
func:create_setup_data_nodes

Then the rule for parsers would be that whatever is in [] can be
extended with additional values. If they do not recognize the value,
just ignore it.

>
> >
> > BTW, I have other ideas for ioctls, like filtering-out 0-sized
> > allocations and such.
>
> You mean using ioctl to control if we only print out the non zero
> ones?

Correct.

>
> >
> > >                                ct->filename, ct->lineno, ct->function=
);
> > >  }
> > >
> > >
> > >
> > >
> > > >
> > > >I think one more important thing is probably to reach a consensus on
> > > >what format can be changed in the future, for example say, we can
> > > >keep adding columns but not change the format the type of one column=
.
> > > >With such consensus in mind, it will be easier to design the parser.
> > > >And I guess many companies will build parser upon this info for flee=
t-
> > > >wise collection.
> > > >
> > > >> >
> > > >> > >>
> > > >> > >> (There would be some corner cases, for example, the '+' sign =
may not needed when the value reach a negative value if some underflow bug =
happened)
> > > >> > >>
> > > >> > >>
> > > >> > >> Thanks
> > > >> > >> David.
> > > >> > >>
> > > >> > >>
> > > >> > >>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > > >> > >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > >> > >>> ---
> > > >> > >>
> > > >> > >
> > > >> > > Thanks
> > > >> > > Pan
> > > >> >
> > > >
> > > >Thanks
> > > >Pan
>
> Thanks
> Pan


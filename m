Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF573CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 18:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4A68E0002; Thu, 11 Sep 2025 14:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0942F6B0010; Thu, 11 Sep 2025 14:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E988E0002; Thu, 11 Sep 2025 14:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D42C06B000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:14:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABC8E16054A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:14:12 +0000 (UTC)
X-FDA: 83877768744.25.B0EC926
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA19D40002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:14:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gYB7YyR4;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757614450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYuyVJpGyCom5XGCNmTvUskGhre4nTEkWgBI+lNGdkI=;
	b=tXGsSgIxojnVU7pOQK6s40T2JB9SS0ew+vxMCa3Nqpd1uZg/sjPVfxLqd6+XxKWJaMzdW9
	Ogp1i5zmTHY6fnY0dHXq+KOg41lgQFeMQDp8TpZgvw3a4Qg/L9IcXUc4sIruR44kcnjZH0
	yok5yzX8DTKMLDCltTbCSfM36YZ4Ptk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757614450; a=rsa-sha256;
	cv=none;
	b=ezMSOtWiOOfxIiAQakvj2MDV9QdS9g5yNclIgBgiAufpFNva1wzq4uKRGOw5h1UlOW/jF0
	C3GiiOF4SyRiuS8tZHpSibtysn5zRAnqVUvS04VjyU1W16qEec8l7XQCotK3NbJGiykLUj
	RmO2fFmXKkrsnCCkOUZh8R54oWVumow=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gYB7YyR4;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so60391cf.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757614450; x=1758219250; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kYuyVJpGyCom5XGCNmTvUskGhre4nTEkWgBI+lNGdkI=;
        b=gYB7YyR4m9g9v+LQYp8iwpjtYbe/XCVXsBAtzn/oN+YJgJbKQBRPXkGzpCt5iDvdSN
         v+lPjPqHRQjLBGxCsCrFhIUHgvmt1VZcTma9C60Q+eRfJv+qX3U+s2lHaBSbHgm0Jaro
         NqROfnramfvy+0kRHKF6ROvk9dxkwD6caFHXKtQYWVVAGQpqHTUqOdpSgaO/MvpjHxjW
         0sjJaYMsA9kUlKjF9ttnnwKFDZ8l1ZlFY5NQvAsbqGDScau7+v+LSxs5JDgYE94WrXaN
         wYE20545C7N3m3m/An73Zl39XfvIh3VDNQj2vDm3eewnpCVtzgfQZzyWK933MCP7KcX4
         Lbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757614450; x=1758219250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kYuyVJpGyCom5XGCNmTvUskGhre4nTEkWgBI+lNGdkI=;
        b=Mw2JVTssmV3+nLNaAfT+HbdryEPGQtmIfJaneEx6WeQJUSUypyBNs8saZ9xLrRe6dn
         yeaJzwlVKxBTiLzXz6XbgsedRNasvButqQI4DGI6RSs1f+N/wlVaR39Nj3sbTH6KZL6N
         Sqbcbqh57Z6h0YwQFMNshCaWil1gIoBd+1lfH4DWT16YTzCAUrk1rQoQlUai1aSxg3YW
         +L+K4MIHVunXdyjuKi0Y6zVOzyneJjI0Qb38TgP0dbRw0pYEBwAK/sc5J7jmRIx+W+V8
         ++9Nh7U0MjVNwpg+ma1wUzZ3FvDju/ksIYCl1346NTrUK3jPR/2ikWtX9GmdCCTHReOl
         YtIQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0NNmAOETfgoAPmLYiiZVCcP0f7rd/bx96jwxKkXwVn9keA3a6981k+81GCUXFLRC96jAe0sCbDw==@kvack.org
X-Gm-Message-State: AOJu0Yxu2YF3PLtTBkNqFdxkME1Lykg5v4bvZsSZ0d0DSXG89rMTORCl
	3GLpD31Jx831Y99IKJHihJVeFY9VdFsp+Wzl5NG6aZXSUowv4n4zgyPx33N9SrWLuTbGxglc1zf
	lzZ5lgQj6ksGpOx9X1w7t+zyIT9k4AsKQCuIjgOfk
X-Gm-Gg: ASbGncuHzzGCf8KHljtDKpA6YyD3MVne9dFAouxA/+dEASo4mB05CKH/ZDkv1HCjCKs
	hG9oJj0PFCShthK3K8Rrb+rTq//8gB30BqNfhCUosZFFiEOCEhgXQuxmm1wuGOIBoAeIaVsn173
	ZGZoexbrVlnKBXopovRDvxyPyVPxjE/8cgruplwb9qvHqUfqUEfIXNG+vyGwgzLIX5FL1P3ThZ3
	+x8uatz/KbV8LXexviOPRD84nBx6vt8f1JaNoJbWmwyGzIp3kgdeDs=
X-Google-Smtp-Source: AGHT+IEfmP8Mzcp+tLHgB0yN8VNfCmikWRVFOPkK+vcAUGS90y7vDqAImVckmIyQNbuuZf1qwMNh/sDAnqwPonFPq4A=
X-Received: by 2002:a05:622a:14c:b0:4b4:9863:5d76 with SMTP id
 d75a77b69052e-4b6252075bbmr14516441cf.8.1757614449314; Thu, 11 Sep 2025
 11:14:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250909234942.1104356-1-surenb@google.com> <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com> <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <CAJuCfpGezf06eR7WnzizpwTaxZ5Rm8jbeW4y87zcr6LZuJ9MZA@mail.gmail.com>
 <aMMF8elYvlPoOF+J@devbig569.cln6.facebook.com> <613698f0.a994.19939d88e1c.Coremail.00107082@163.com>
In-Reply-To: <613698f0.a994.19939d88e1c.Coremail.00107082@163.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 11:13:58 -0700
X-Gm-Features: AS18NWDzjAQUnGQpp0t_fVd91PRT6EI5nxydqFU4J6hwgGgdW_Y4eforaE3zbl0
Message-ID: <CAJuCfpE=0jpana5qryqwPsuoj_8tCEMWFMcEBTB5-9Lyu_j-Tw@mail.gmail.com>
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: David Wang <00107082@163.com>
Cc: Yueyang Pan <pyyjason@gmail.com>, Usama Arif <usamaarif642@gmail.com>, 
	akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u3u1h7r5xhwc5bsskujm65q6ogwc3tph
X-Rspamd-Queue-Id: CA19D40002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757614450-188918
X-HE-Meta: U2FsdGVkX1/02h+rgshYSxZuHv/k/YnYHxGFhkvx0c5+LrEXN6w3vN384uMshBdXQp5uodjNVyFnyD+REiayKwsBECv0b74SNWnFvvsKC1In8vH5v//aHCgw0ccA0OSzp8FYLxAMo0vu8TcUOevMPvUmfFvXortwfFsYi8+jQERiGVuTne6tUPrrN+YYKy+pfuZS9kc+kxsczTa7pT9EZa6rYVuAkuvLSew5MoNTpGbbOVWkkdBz73U9UK7TDh+/kClJRfJAcn0NwDQxtc97n/fdYKkVdGDIXYf8seBcEUrsmKjASYkeRP5DLDd3KZH+vZBID86fz/wi5xvgm+i/azkexMW6axqSlM9m1qTMhOcH60V+qW5O5wqyrpXWXNT9LjPd8n8tO4A/nvQYGCFOw3kj72MrXYzqs8lKYe9q2hx079MNAbwF6WnqTIga6ftDnh7PnRZrQAsiOWk6JH0fBAJ8Q6+bmWLUPMeHmo4sUR+qQEiBqirSM1jtoWt6BlUSbdL1/D6VDsPZXV4HjL5e8jwZY6uQMAPYoHUM6W2uzU0om6cPBezEneesdYtYBfrLeOdSlYvJq5mWzrWPM0azz3PU6w3iEhtIGTGk92NGerkNWkmgmYBPJDZSAo9/1d/G/2Ivn7jnqNTdtld3p8dHi+MMp/hl3xptNKPlngkDIfk2sGJuVOS9QNhJY8DsDMUjSkETjvHD7WykzY+3LBIYo+R+nKzJ8Z8YZ6HY6uPTk2PJfyweqTu34UaJktqe8T8oVVZEzuCxVTi+DsjORGfZ+BMiVnzYe4p+bVWmxqOSsaY1eE4KgayKR0HYaS6tpl09CLKaa6uGi0gjYPRllJ/rJL24oVxnzjKhx88KB+URdjShSmt7A7Pd9qbbWG2I1jxmseTF+TPzEuULhUArI6O++1lWBjvNlzEf+9/Lf4RBcP9n5tAf3oAh4EINvZ11TypTDwdub+I2eqguKSUsG0e
 YUOipiVe
 Xsue1jiqRm2Kqzg9gdCS5l8i/wfKRw/cpXegBePzUO4aUb7WIpCaj8fUm+Uf2pe60toi4dz3jIyIbijROMEjA1AqIqjoRR41EdqFKb2V+Osvn/anIdlYAewNjVbKQ1ye8NZoOo8Git0al3GI3CmXrCmRALoJy6OVvKzh2xZgiPbffh5FEuDLUWGsEEl5Z9Kq8osn6xU7UBNweNuQbI6Zh581D0VZVOwYpP9VlPKXihtsr0y0VlOrjP8Cio/nnlF5wO4X0iwn2wdsuAob1S09CVLbEqGGF+c47TE54UrQrqmfzWx3wUB8OME0iN60blYmZy6v9FHPdjZoQzIY+S65uXK9bDqqdY3azAw/yPFwBFPnXDpDZYT7sE1uGPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:35=E2=80=AFAM David Wang <00107082@163.com> wrot=
e:
>
>
> At 2025-09-12 01:25:05, "Yueyang Pan" <pyyjason@gmail.com> wrote:
> >On Thu, Sep 11, 2025 at 09:18:29AM -0700, Suren Baghdasaryan wrote:
> >> On Thu, Sep 11, 2025 at 9:00=E2=80=AFAM Usama Arif <usamaarif642@gmail=
.com> wrote:
> >> >
> >> >
> >> >
> >> > On 11/09/2025 16:47, Yueyang Pan wrote:
> >> > > On Thu, Sep 11, 2025 at 11:03:50PM +0800, David Wang wrote:
> >> > >>
> >> > >> At 2025-09-10 07:49:42, "Suren Baghdasaryan" <surenb@google.com> =
wrote:
> >> > >>> While rare, memory allocation profiling can contain inaccurate c=
ounters
> >> > >>> if slab object extension vector allocation fails. That allocatio=
n might
> >> > >>> succeed later but prior to that, slab allocations that would hav=
e used
> >> > >>> that object extension vector will not be accounted for. To indic=
ate
> >> > >>> incorrect counters, mark them with an asterisk in the /proc/allo=
cinfo
> >> > >>> output.
> >> > >>> Bump up /proc/allocinfo version to reflect change in the file fo=
rmat.
> >> > >>>
> >> > >>> Example output with invalid counters:
> >> > >>> allocinfo - version: 2.0
> >> > >>>           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_=
setup_data_nodes
> >> > >>>           0        0 arch/x86/kernel/alternative.c:2090 func:alt=
ernatives_smp_module_add
> >> > >>>          0*       0* arch/x86/kernel/alternative.c:127 func:__it=
s_alloc
> >> > >>>           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstat=
eregs_set
> >> > >>>           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpst=
ate_realloc
> >> > >>>           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:a=
rch_enable_hybrid_capacity_scale
> >> > >>>           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258=
 func:init_amd_l3_attrs
> >> > >>>      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mc=
e_device_create
> >> > >>>       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:=
mce_gen_pool_create
> >> > >>>           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce=
_threshold_create_device
> >> > >>>
> >> > >>
> >> > >> Hi,
> >> > >> The changes may  break some client tools, mine included....
> >> > >> I don't mind adjusting my tools, but still
> >> > >> Is it acceptable  to change
> >> > >>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mc=
e_device_create
> >> > >> to
> >> > >>       +49152      +48 arch/x86/kernel/cpu/mce/core.c:2709 func:mc=
e_device_create*
> >> > >>
> >> > >> The '+' sign make it still standout when view from a terminal, an=
d client tools, not all of them though, might not need any changes.
> >> > >> And when client want to filter out inaccurate data items, it coul=
d be done by checking the tailing '*" of func name.
> >> > >
> >> > > I agree with David on this point. We already have monitoring tool =
built on top
> >> > > of this output across meta fleet. Ideally we would like to keep th=
e format of
> >> > > of size and calls the same, even for future version, because addin=
g a * will
> >> > > change the format from int to str, which leads to change over the =
regex parser
> >> > > many places.
> >> > >
> >> > > I think simply adding * to the end of function name or filename is=
 sufficient
> >> > > as they are already str.
> >> > >
> >> >
> >> > Instead of:
> >> >
> >> > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_=
create
> >> >
> >> > Could we do something like:
> >> >
> >> > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_cr=
eate(inaccurate)
> >>
> >> If there is a postprocessing then this would break sometimes later
> >> when the function name is parsed, right? So IMO that just postpones
> >> the breakage.
> >>
> >> >
> >> > This should hopefully not require any changes to the tools that are =
consuming this file.
> >> > I think it might be better to use "(inaccurate)" (without any space =
after function name) or
> >> > some other text instead of "+" or "*" to prevent breaking such tools=
. I dont think we need
> >> > to even increment allocinfo version number as well then?
> >>
> >> I'm wondering if we add a new column at the end like this:
> >>
> >> 49152      48 arch/x86/kernel/cpu/mce/core.c:2709
> >> func:mce_device_create [inaccurate]
> >>
> >> would that break the parsing tools?
> >> Well-designed parsers usually throw away additional fields which they
> >> don't know how to parse. WDYT?
> >>
> >
> >It would break the parse now as we count the number of string to decide =
if
> >there is an optional module name or not. I don't think it is a big
> >deal to fix though.

Uh, right. We do have module name as an optional field...

>
> The inconsistent of module name is really inconvenient for parsing.....
> Could we make changes to make it consistent, something like:
>
> diff --git a/lib/codetag.c b/lib/codetag.c
> index 545911cebd25..b8a4595adc95 100644
> --- a/lib/codetag.c
> +++ b/lib/codetag.c
> @@ -124,7 +124,7 @@ void codetag_to_text(struct seq_buf *out, struct code=
tag *ct)
>                                ct->filename, ct->lineno,
>                                ct->modname, ct->function);
>         else
> -               seq_buf_printf(out, "%s:%u func:%s",
> +               seq_buf_printf(out, "%s:%u [kernel] func:%s",

Yeah, until someone creates a module called "kernel" :)
We could keep the name empty like this:

+               seq_buf_printf(out, "%s:%u [] func:%s",

but I'm not sure that's the best solution.

If we are really concerned about parsers, I could add an ioctl
interface to query the counters which are inaccurate. Would that be
better?

BTW, I have other ideas for ioctls, like filtering-out 0-sized
allocations and such.

>                                ct->filename, ct->lineno, ct->function);
>  }
>
>
>
>
> >
> >I think one more important thing is probably to reach a consensus on
> >what format can be changed in the future, for example say, we can
> >keep adding columns but not change the format the type of one column.
> >With such consensus in mind, it will be easier to design the parser.
> >And I guess many companies will build parser upon this info for fleet-
> >wise collection.
> >
> >> >
> >> > >>
> >> > >> (There would be some corner cases, for example, the '+' sign may =
not needed when the value reach a negative value if some underflow bug happ=
ened)
> >> > >>
> >> > >>
> >> > >> Thanks
> >> > >> David.
> >> > >>
> >> > >>
> >> > >>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >> > >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >> > >>> ---
> >> > >>
> >> > >
> >> > > Thanks
> >> > > Pan
> >> >
> >
> >Thanks
> >Pan


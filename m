Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4089C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7166B0128; Thu, 16 Jul 2026 11:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFC76B013C; Thu, 16 Jul 2026 11:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADAB6B013D; Thu, 16 Jul 2026 11:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB8D36B0128
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:27:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 582DB1A0202
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:27:38 +0000 (UTC)
X-FDA: 84995019396.29.BEE54E5
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6C35E40006
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:27:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OFdfO8le;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784215656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1F/olKLrWB4qqHnjLjJSF9FomuDg/Zv/XEA7HymFvKM=;
	b=XHUADL5yfVNqsvBZXI+ZjzhlXh/0mdN3EG7KYZ85jScwpzOB1nS71YFzJ+nK9mE/wQkui7
	skc/WwZj0kUChhUrlzuqwW0jZ0blQMuZSXkJsusEXzanCjSO/LJyoUxBOT3Exo9z0c2bd6
	6cdVdFe20K0EHoXWo1klnOt+z5nVCL4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784215656;
	b=1vs43GXrdSp2h75H/UGxj/oYAuN6kfHm3BW8Nk+s0zu3v0cDMdLGg629u6K+hd6Y5XE4Nn
	g1xldYRCYE7K1X4PjtabQCCw0vv1UZ/dI4fNc0WXNdzB9u8qF5/EnKRZtTQCqVsBArZ9D1
	i6+zZqeh5bz9HCVSZ5t0fA02rdW3TIc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OFdfO8le;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10e86e52so29911cf.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 08:27:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215656; cv=none;
        d=google.com; s=arc-20260327;
        b=W8vBNOq8Njtq0ePWkIgzB0N5A6gK1T+biy+SsUHUBu7qjwn7n8ISgja8UHZv9ucr5X
         HM0Qb/QSGZgtz9lNdrISsVCpd9AVzN3YjH7NAMY9zjUy2zxag5Wy9O8jXUm2W/ViS5jh
         4JQhTm9xCuCjXP/Rwj8Q2Skced8ef7Q+pJY6nzd5OmY/VfgeX1J1g6ScMWbKs7rU0b3C
         5h0XFCbKV+yNvsBBwChIBlPGOEG9gQBm9mXi95+ePe2JGZb2k6GbFZwmZE2x2ANAYJJq
         Hl+zHJyFb3EnYVI/xogkpHhr7k4b8LisxjmIEvbBPMDpw3tSmpbXDPaQG41wAxQdBmLA
         Eo+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1F/olKLrWB4qqHnjLjJSF9FomuDg/Zv/XEA7HymFvKM=;
        fh=ejXlgl8hy9vFbJLTcQPpsook/tpRNAgtia39Oucu3E4=;
        b=MgWonVR5eAbQ0GLWntB81WRJG9brfl094fKjtDVd0Lj6t/V19RE5b5hSCn3oVteTrr
         kmcBZb546gZcJPCMesMeptjheRvQJJDU92tHUgJosbUaH+YpTh+/PkJxf2CmHpMh+/3a
         /Nh0rzFwNc2CRa5V5vYnOVHTXUrtAHF2UwrtRi9DWh0HiF5VERcGFi4KPEGwQit0kmn0
         HhkESN0tliVqKvP4XBXPtNXTSy1cbIC4UmlwUTC5eWg1n6y6u+wLR2Dd3I3kze/Sr6nf
         RUZmCE3k128P9fGkyIi//JFKLGE42E5W2dN4lyDoU14SydWP7gcj6U7JcsqnoJqhzDUh
         ix6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215656; x=1784820456; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1F/olKLrWB4qqHnjLjJSF9FomuDg/Zv/XEA7HymFvKM=;
        b=OFdfO8leocvZE3yYKnxx5s8tOXZ/ADQQ1WGZbbP4Yi9aKbbkU08ffhXVPBcRABwU0T
         h1QX4dttaSthV7QT9tNkFO1WVXHIycavgeFatZGJpZyPOhCD57QIDNi6trr1S4Ux9GdN
         6w9KvkboS75CSP8dQQ5nFX4zMgv9Vs6QzvCu7iUY15lqpZ8eUFa+JUxLjRLPbrsbVNvq
         bFA8yqpRc4ZrmUCwrgleGHQlHgHExPwSTOwf2z2ixzDJ8IU8r8HGUQPErLbjAGVaiUuz
         UD4Ix5X4kxI12CsdnDdMEaCCVMPYPZK1mSWfVwZMuKcs9sJo6o7dYT+dAvegchXrYf33
         sj3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215656; x=1784820456;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1F/olKLrWB4qqHnjLjJSF9FomuDg/Zv/XEA7HymFvKM=;
        b=KtLOveGvdBQta/HX1h2D5G/Fq1DBvmcZJIl/J8QwJJaHZNiEm8a8g+lKWYJg6REB4b
         vWoDB+JjeaLl6gaqqeszL39KqQLJMIQARJ45zBswn+GpYpMH+QCxS8snznQHke0VkFPo
         wfJEnsJf900SYmE9xM77lmyLKOmrwawYt7yYvSvYtKYLPe5mUR8QCPAfW7QcR7V0PfKT
         oWw2xW5R8tdgmwEWKLSWTbdhXzPgJdNE9MIVBOBG6HPL1jwg1zzlf/W/Vip65hxFiiuf
         OElR+YKfAThGJ5cgXXc/PE2xqCl+T+LG1t/0eyxRFFOkh9m3uVSXDRJCrTPb9JEAcDg/
         saYw==
X-Forwarded-Encrypted: i=1; AHgh+RqZvImqI/6BllIoKoemVzovSnk4FmL35cIOKZjLtRz4MkaW6NGHv6uQVP/Nm6FYaFfh19II4g6vSQ==@kvack.org
X-Gm-Message-State: AOJu0YwzMF8XTqKFKi75ajzgbXw6dlB8+oHjx/fT3Bb+haclkqYg7XJE
	hi25//L9tq72v3M1cuZIbUvMV9C6wRiVira84iOnVsG5NF9bWddmnYhJXGt3HTEqnMsjBglBzww
	LECiN+sQZ28KT+MSZi23TckqlEGuAoJiixWgVjh/m
X-Gm-Gg: AfdE7clBFNtFl0emXSfcPm7lUHBUTBdBI0qtG9czE4IqWmjn0fMzQ6X5j1lAuc3BtZX
	QtP5pNBNY4BCwIRZSgXRjT0534Qy7G6A4bBpsouWSwRyqFped/yS5m8X7OByTQTaN3ee9y5Zx30
	ClFWz+w2RRkXFhOfzdse96C6hHZ0CbxYHJj2Ve53m+usTNCRKaSbP4ajnDG4waZ2VG/0sir7osc
	GMHBzbi5A0dxOOffADyTCV9VqbScn6OMWT9FVYIM4+SNTjY8Sf97698o1SlQ1lGgKLoY3MjL5tF
	x3SHknOcgb/bock=
X-Received: by 2002:a05:622a:94:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-51f7d273976mr9799081cf.4.1784215654893; Thu, 16 Jul 2026
 08:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org> <CAJuCfpEJV=OgCmQ9=tuMHOjMMh8bgHrpFe1gLtTXjagAenKZsg@mail.gmail.com>
 <eb3fc4d3-c8bd-44e9-88ba-7fb974a58aa3@kernel.org>
In-Reply-To: <eb3fc4d3-c8bd-44e9-88ba-7fb974a58aa3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 16 Jul 2026 08:27:22 -0700
X-Gm-Features: AUfX_my_bAm9pMs_cq2llYbd6SUBazq-pBVNFKSQG59fVdB5bXaPSKf2ohfyPJ4
Message-ID: <CAJuCfpFX-9Cahs5ZCTU+P2g5eLnhR_2mhrUR9JhF8ZG6cj8=AA@mail.gmail.com>
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C35E40006
X-Stat-Signature: zfc7kesppfii7phzj7o1jtunib8npqik
X-HE-Tag: 1784215656-312838
X-HE-Meta: U2FsdGVkX1+srrU5cgmD1RH+yz/6xzH7OW3UauCyEQ0FWl9UYpp5jWEjfyShmylpQ/RTFyV2LEWV3TJsPzBcIoP7xPXvo3D80ST7xLhzxwqL4LEaSGLrVOCNYx7GW8aGqvHb3iC094RUmpWNS5OUh43u4nDLU9rsXARpYhyZV2iN+5zoaU689FrM/7Aw4+1qMakcARci5RzBAJGFQRHDklRyPyyjc+nBUwG0THvQ3V5JZFwuODUCuBgL/JzlUaNoPDzazngmen0owQ/9MpJLAXFtj2+eic2cIXvv6M7+vQy/ATVf9LzyX/7ufIVC7onjnjB+YlCIBT/QSB6V1uPTtW/SkFdUWiEy4Smd+NUdoD/AZU6RPeCg3r4uwvQTwJJsHw6OBShHbbbvN8VJl6JvwaLttVoqbH4wvwjlBZI4DQTgJchHRMAabze6dkYd8ZQjNHR1XC4qzPt+g60xKFPLZnJp3lr3Qj+GKXFq4uqAtOaF8gqEMoaf1QHic8Sg+TH42mapzmLqaOwvu3C87J7J5yWirRCZWFPLE7UAgaW7GHuhXtaIGEAmMJ3HpjnRRP7XU32t//BX+BXuuDcqt0ZH26WV3GVK5Q0SqhRBVnT4dOP6yNczgjlKGrGp2v5m2km7uZc/6U6KnqVpyZ12qHuTFd0OH7p48Fatyn0q+5JkWWoXbvqotR8V+Etutaxjj6qRLIWAjlYbfKRtb5QRp6qtejl3GqfZjsQvGgqDnRBW2O3jNNlbghUDMzg4Pv+kgUCSofDZ6P/eS29wJuFN7OQHzEgJuMrR6LI8Fhi8LZ3cntH6pN0/BmXirKVbiByOP58/D4Mbb3TZ56TIIQuZS5+nSZ5CHL+O3z6OSsxhv8fILYg7aZexI/xhxOZ5QhxPkhsJYlJW9GIeckizKqSjp48wxxlx9EBuEHXLJpH88SY2s5i7imRFNc8Fcu5FLkYTIUHkKIXqksPcPLjiihXVQmj
 eVb+MRlB
 VKYzyY7x8Qz1KhwtgsTNkrAf7dmSsUcmWmOk5kGbE65GCm6No9UH2vkg8RdBGTy4B3mSTF2IoLHu/XIhnwK3rtaQpa6hahdxq+fN586fbhY4f6dtzbgegAg6L/TwWULH2G1JxWZycOKmKiRnW9j1vzGIWKhMtvYfR/P7BwZzXFx8/3IrBADAX9kyoZKe78Ajc4LHCjoYFqk9mcPwPPSs7IRCDpW58FcjxKR7ooHpD/286kN5be+bpSsYS0r5VjLqJLrELq71H+FLVp6V4hnuLleho1PKcMTDr24f4s8FXegj5FPX7koqRsKWATg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 6:58=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/16/26 03:27, Suren Baghdasaryan wrote:
> > On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
> >>   */
> >>  struct slabobj_ext {
> >>  #ifdef CONFIG_MEMCG
> >> -       struct obj_cgroup *objcg;
> >> +       struct obj_cgroup *_objcg;
> >>  #endif
> >>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> >>         union codetag_ref ref;
> >> @@ -661,6 +661,13 @@ slab_obj_ext(struct kmem_cache *s, struct slab *s=
lab, unsigned long obj_exts,
> >>         return kasan_reset_tag(obj_ext);
> >>  }
> >>
> >> +#ifdef CONFIG_MEMCG
> >> +static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_=
ext *obj_ext)
> >
> > I understand why you need to return obj_cgroup** but maybe instead we
> > can have a separate setter function and just return a pointer here?
>
> Yeah I rewrote it now and it looks better. Thanks! It ended up like this =
due
> to some previous attempt I made.
>
> > That would also help catch cases when someone wants to set
> > obj_ext._objcg that was optimized away (for that the setter would need
> > an additional parameter to identify whether we allocated optimized
> > objext vector).
>
> It would need passing the slab parameter to assert
> slab_obj_ext_has_codetag() in debug mode. I don't think it's worth it giv=
en
> the get/set is only called from few specialized places.

Sounds good.

>
> >
> >> +{
> >> +       return &obj_ext->_objcg;
> >> +}
> >> +#endif
> >> +
> >>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
> >>                         gfp_t gfp, unsigned int alloc_flags);
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 5e3f53bcd0d3..48e10198a3ce 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2523,7 +2523,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags=
)
> >>         if (obj_exts) {
> >>                 get_slab_obj_exts(obj_exts);
> >>                 obj_ext =3D slab_obj_ext(s, slab, obj_exts, p);
> >> -               if (unlikely(obj_ext->objcg)) {
> >> +               if (unlikely(*slab_obj_ext_objcgp(obj_ext))) {
> >>                         put_slab_obj_exts(obj_exts);
> >>                         return true;
> >>                 }
> >>
> >> --
> >> 2.55.0
> >>
>


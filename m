Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBECCCA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272C98E0007; Fri, 12 Sep 2025 20:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223888E0001; Fri, 12 Sep 2025 20:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB948E0007; Fri, 12 Sep 2025 20:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F39A38E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:08:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9607E13BF69
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:08:14 +0000 (UTC)
X-FDA: 83882289708.30.A6CDBD1
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id D3AD11C0010
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:08:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="U7K/WvEO";
	spf=pass (imf21.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757722092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oarCFVaYBfWe/dEymvNS5bjL3XCSyA2+fYOAmVQlg5Q=;
	b=MPPclEM3QUqjl5/0vbJz6t4iob7iQ4Hs/okW4ApkfFOYQkP/Srvlnz2KRIpXJdi3c/5Je7
	a+YecybA4UDKFb5NYIM1oKUDdrxHyC0QZQ0YP8ym/oVErnq+aQqboeXtC1gVSN1TS+ScoF
	kEHWfgs4WZ1rMpAXMmR+CYfeIMkIVsY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757722092; a=rsa-sha256;
	cv=none;
	b=vlc90lD8ba33LJy2cxQda2n3cXZ45sO/Z130CyswXpdwM2N2Fv3vTMohJ+CnR5elN9g+6g
	EBtzDgQEx5Iu7016FdZhwF5Zupe7vBsgqC/54vvhTVztRPMApi2OfMOMwn3K9oooEHMHq+
	082PxWIY8qa9BgTRTWoC9Gmb0gCLC/A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="U7K/WvEO";
	spf=pass (imf21.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45df0cde41bso18389625e9.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757722091; x=1758326891; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oarCFVaYBfWe/dEymvNS5bjL3XCSyA2+fYOAmVQlg5Q=;
        b=U7K/WvEOke57lZqaF0jqsxQF0wtZ1Uriju+f/+Yr+aIN+FNoEmUuTt1Jxkg2f04cPN
         T1zhTziT6buH/eyLdGDnjEw3m/mFYRZS7ISFBHWTJ2DU9QDfwH7dCyt259l9Pw0TjorK
         pKCs6fBBHdj7E8yoAOx1uB0/A7xtOnBOrCKO3seD1pZPJhyJKwH7qdHWC+WMwn32gDPb
         5aH2WIrJg96b/PArKG8lB0/F2VjDTbkODxhDTKTxSw8MTJ0dJYQFk6ChBWP7+Y5KJqwq
         GHaWaWfgfoqAvF9usRjVkiKMlORQxOSC5jQoFAZmmfrMdiykcsUeuQmEb4evF0B8wAWY
         PxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757722091; x=1758326891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oarCFVaYBfWe/dEymvNS5bjL3XCSyA2+fYOAmVQlg5Q=;
        b=j6yDs/eGHOGfg+q/Vz+p1cWnHo5mSmq0dIXz7C9LaTDT5yH9NZFHvvwPFaveSu2F+t
         gxmygL6fwy/hHbVYiPo4FrZWfdehE1J1SBytosk2koKLb9bJY8a3uz4xCDenxPvAOT5s
         mzZxrI6OvFwQrETPZwz9rq0fXqip0xXmoPNB5Sqze5oWh4srkFJ8/fE6WwOD+3X9RqyP
         Mno++xuREtlYQijjk1fm2aAwPYpx/qNDz1SoX5kCqV6IhWj2LLna1AD9/vGV/AUI2agx
         tcRquxxgHC/JOpw0rHNJ8wON97xNPmFUu5yF/KVv1HcKeZgGlsmMKuHgw4mjZGmZGg67
         OT3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMLWzFau0OwzXp+wVfF+0plmAJ0V4cgH/4cvvJCN56isTgybqc7Ujvzo+/FuarAauOHntp9pW3MA==@kvack.org
X-Gm-Message-State: AOJu0Yw0YxViaOlTeuQhniEuXTNklyOE/5RjxkIMSVP/crMesjTzRHLV
	6ZZZE3UXDJUOvKF9Lk833zEiZ21JRjJvQqJHBTjumfygJX/5N37k1MClt33EMqRmfcaKzSMjBfL
	Pz3fPPzs2ZIUqsdrD4QqL92/GZc+j2j4=
X-Gm-Gg: ASbGncshsrQAMh2wTi6cIqr8qwBpqbCq5I/OSrb3N4swLH5DRSCOFY+aW8GzY6WEUj/
	hVPbAXSLDOYF5rzaWHxZu2Xnlm2HPBtarxsLplWpQCCKiCOK0V0O4f9oJiadHD9aTHOlMztI1B+
	G2WOG5i/6lV/iasgAQfrLlmePW3R13QFaD7lUjnhjNGB0rJe94EPXYbHw0IdFg0CbKJ6I1Jcdmx
	yOPTunAaDUiFDdwTtjQnvKT57kjX/6+8ePUhLU3zmbi7u0=
X-Google-Smtp-Source: AGHT+IGs+Xusqht/8VJHegMGPb9jp1iG1FiTVIwbkOnWYvsoVG9viYUph7imP1ifYwIEbTOxvv/ltAkVzWvCpvR4B2o=
X-Received: by 2002:a05:6000:186a:b0:3d8:afc6:e8f8 with SMTP id
 ffacd0b85a97d-3e76579dc26mr4995623f8f.2.1757722090851; Fri, 12 Sep 2025
 17:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com> <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com> <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
In-Reply-To: <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 12 Sep 2025 17:07:59 -0700
X-Gm-Features: AS18NWCwWrkehvUmDDVjVIsB98WyNlLefJiTWEE2sdpB7_QgIyHcNpFJxwLW6m4
Message-ID: <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8hy1puteehbs5equ1gr79sd1rmz7mkjh
X-Rspamd-Queue-Id: D3AD11C0010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757722092-170871
X-HE-Meta: U2FsdGVkX18nmjqMcqU2NiU4Wl8Ie5s8Og8KB0egKQNTG/tnERBGvNkzKFFqHIy+aJ33VaOYEHN6C9q498LOsl9HJC98Q8/1tFTppezmjGgJ9Lpr8nyajzq1pUyqi2UlJjNkr2qSF6SN+RC201I4njkUNsJDoZlpfkGxoMeVsM+fp/wyudot7OQYJeT/ZrdnHV2mnvpPYEK5BtTOx2l8Ta8dHHhzwVzuQ/kxyLr3dKJew8TSyeotZdt9Gu0iADMVBcOFJfyQcuGkukoYZGGhP0+X4typG3bD/bQYh5tUKEwwuRTtObUGt8yIM6HFLD1JlqEBPpeX3NWy+AvW//aw56wcRA3q5Y1hIDmeyT8rPH6FYprFqrhOnWRr2DuII2n4AE9Ocgtm0qxLubBPthNxhb1xycCaevyasbnshrQehI6xzOwZE2l7tXmrq/2EP+Atxr3SFZkdOepW19pzr85WS+z3Ja+XOruKeK93jylIPyuZZNmRwV0z8f9SWwRvKDHBAdWqy45wgcj9Undhl3or6sv1jzrPPo4uUNW6IQ42twT03ILU6QHEN9VDhe8PgkphoROOTILV45fPdOvkDo8HO+TmuD76qwenQccvUnznfolrLgz3qGRqIzmZ9Brh3MFz1WXVUVflk5nG2e9mh7bMb55qXqICPccSiKeIynnUq4GKWm8We2z+VJ6kAk5GMPtWeD1j5WoXL/ruFqQBrHKgt5tBPlGST1uJAWgYR8w3X4i3CnyL1n9hHgVImA96nbS7WFx+NaflSzJOYg2lTvzVqWuyjtS6U5kNmy9AJk360vkRmbTR9imLZk2rd3hKZb99Hd6Mc8yu2oqJHPGfQqOuN+GmLfEDWa6GAZ+RIpOe1B7CB4cQhH6uGL3iW7NzbI+ko67ucP+BoD17+BqUKGFa4PM/G9t9rXpwT0vjAMqXE4aSd38vGhjWBloHayk2o9Lzr33xJu6AlUkDJKbEXIS
 TPN72vaD
 laQ/w3irGg683KZmSXf4S29JVb47RDyf+4WWVm0+WINoVK1+zgsA7YBJ+i6RJiUfQ46VJulndeXNZbSLpVerxpdi47PRlHUlqrwQo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 5:02=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 12, 2025 at 02:59:08PM -0700, Alexei Starovoitov wrote:
> > On Fri, Sep 12, 2025 at 2:44=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Fri, Sep 12, 2025 at 02:31:47PM -0700, Alexei Starovoitov wrote:
> > > > On Fri, Sep 12, 2025 at 2:29=E2=80=AFPM Shakeel Butt <shakeel.butt@=
linux.dev> wrote:
> > > > >
> > > > > On Fri, Sep 12, 2025 at 02:24:26PM -0700, Alexei Starovoitov wrot=
e:
> > > > > > On Fri, Sep 12, 2025 at 2:03=E2=80=AFPM Suren Baghdasaryan <sur=
enb@google.com> wrote:
> > > > > > >
> > > > > > > On Fri, Sep 12, 2025 at 12:27=E2=80=AFPM Shakeel Butt <shakee=
l.butt@linux.dev> wrote:
> > > > > > > >
> > > > > > > > +Suren, Roman
> > > > > > > >
> > > > > > > > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoito=
v wrote:
> > > > > > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > > > > > >
> > > > > > > > > Since the combination of valid upper bits in slab->obj_ex=
ts with
> > > > > > > > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > > > > > > > use OBJEXTS_ALLOC_FAIL =3D=3D (1ull << 0) as a magic sent=
inel
> > > > > > > > > instead of (1ull << 2) to free up bit 2.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > > > > >
> > > > > > > > Are we low on bits that we need to do this or is this good =
to have
> > > > > > > > optimization but not required?
> > > > > > >
> > > > > > > That's a good question. After this change MEMCG_DATA_OBJEXTS =
and
> > > > > > > OBJEXTS_ALLOC_FAIL will have the same value and they are used=
 with the
> > > > > > > same field (page->memcg_data and slab->obj_exts are aliases).=
 Even if
> > > > > > > page_memcg_data_flags can never be used for slab pages I thin=
k
> > > > > > > overlapping these bits is not a good idea and creates additio=
nal
> > > > > > > risks. Unless there is a good reason to do this I would advis=
e against
> > > > > > > it.
> > > > > >
> > > > > > Completely disagree. You both missed the long discussion
> > > > > > during v4. The other alternative was to increase alignment
> > > > > > and waste memory. Saving the bit is obviously cleaner.
> > > > > > The next patch is using the saved bit.
> > > > >
> > > > > I will check out that discussion and it would be good to summariz=
e that
> > > > > in the commit message.
> > > >
> > > > Disgaree. It's not a job of a small commit to summarize all options
> > > > that were discussed on the list. That's what the cover letter is fo=
r
> > > > and there there are links to all previous threads.
> > >
> > > Currently the commit message is only telling what the patch is doing =
and
> > > is missing the 'why' part and I think adding the 'why' part would mak=
e it
> > > better for future readers i.e. less effort to find why this is being
> > > done this way. (Anyways this is just a nit from me)
> >
> > I think 'why' here is obvious. Free the bit to use it later.
> > From time to time people add a sentence like
> > "this bit will be used in the next patch",
> > but I never do this and sometimes remove it from other people's
> > commits, since "in the next patch" is plenty ambiguous and not helpful.
>
> Yes, the part about the freed bit being used in later patch was clear.
> The part about if we really need it was not obvious and if I understand
> the discussion at [1] (relevant text below), it was not required but
> good to have.
> ```
>         > I was going to say "add a new flag to enum objext_flags",
>         > but all lower 3 bits of slab->obj_exts pointer are already in u=
se? oh...
>         >
>         > Maybe need a magic trick to add one more flag,
>         > like always align the size with 16?
>         >
>         > In practice that should not lead to increase in memory consumpt=
ion
>         > anyway because most of the kmalloc-* sizes are already at least
>         > 16 bytes aligned.
>
>         Yes. That's an option, but I think we can do better.
>         OBJEXTS_ALLOC_FAIL doesn't need to consume the bit.
> ```
>
> Anyways no objection from me but Harry had a followup request [2]:
> ```
>         This will work, but it would be helpful to add a comment clarifyi=
ng that
>         when bit 0 is set with valid upper bits, it indicates
>         MEMCG_DATA_OBJEXTS, but when the upper bits are all zero, it indi=
cates
>         OBJEXTS_ALLOC_FAIL.
>
>         When someone looks at the code without checking history it might =
not
>         be obvious at first glance.
> ```
>
> I think the above requested comment would be really useful.

... and that comment was added. pretty much verbatim copy paste
of the above. Don't you see it in the patch?

> Suren is
> fixing the condition of VM_BUG_ON_PAGE() in slab_obj_exts(). With this
> patch, I think, that condition will need to be changed again.

That's orthogonal and I'm not convinced it's correct.
slab_obj_exts() is doing the right thing. afaict.


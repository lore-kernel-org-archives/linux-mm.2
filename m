Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED7E4C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F166E6B0133; Thu, 23 Jul 2026 04:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7B86B0135; Thu, 23 Jul 2026 04:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE666B0136; Thu, 23 Jul 2026 04:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF4FD6B0133
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:10:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 287431A03FB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:10:49 +0000 (UTC)
X-FDA: 85019320218.13.E60385E
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3EE89C0004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:10:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GnE8E3wa;
	spf=pass (imf10.hostedemail.com: domain of jyescas@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utY3y1MXpjBaz472phkuaQXhtUJ5TF0pPb5fcOjfRSY=;
	b=cq2LZBXyeI+ZCwNP1feqX7CazoMx2okdwEi1BNaf+mgBTX9WlJ3MszDO+2BhDUmEa/4GdB
	SDiY1fxE4+igWHqdLmV6plP4BZsJTApLAzBzBbqNCw4O+0TAT6q73oGBE34JYBeBuOLORL
	2QecEeXhRA8fsdtXti1ciGlpkYnH2gU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784794247;
	b=hM1CiLROkdA+NvB7Vf99Xi6Rl1GaYPllprbha41jKzaQymzmw4LLKQxhFq9p/KiMnVqR64
	qeTeEBVjK4Hr8hUKWuF3qg5O7cAD43gmBtC2D7LZW/1bIeGR1Olumnmzqd5obu/nURD3hU
	hhJZvPbxY3Wh6C2SdwuY0siU0EtOGhg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GnE8E3wa;
	spf=pass (imf10.hostedemail.com: domain of jyescas@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954bb689dfso24355e9.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:10:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784794246; cv=none;
        d=google.com; s=arc-20260327;
        b=Q3rN/wVPiO3ggkabBOgqbKX/y6HaT5qcVgiGrv4JCbfnV/v1AG4hhCFQIHlw6srSh6
         d9rrE5mXbLvSdLa18s3+dyQQmlYBkcHtVl08nUj7ccAQnFo0lk4ZEkmQn9+Z6PNAX0Pt
         6GvAqt/qc8lLmjLUuosjdqQJp5S4ojz5wvH1CyXp5Z6JPQvciozmtCYB2owsNZG3yMwO
         +uwI9AwHnKvNLz74d6USap/cyT/GlSsrA317heEnpQ5dA1XJXck2nfnlKv3dafqb5w2b
         lYI/woB1QtmGMjzVcopGuv2AcjmeQSFabSRmpuey077Z1w57NgGkCa1DUUQggSKDMmew
         C1pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=utY3y1MXpjBaz472phkuaQXhtUJ5TF0pPb5fcOjfRSY=;
        fh=UBZFjpc2ClDU4aCVJCyv9L+Ozs5RkdXva3jNRlgGE5M=;
        b=LWGec/f+F0YH3sjsj/wDUn2P56LjFHV6Ubzg3sDR1/OSGt4X2ZtvoBKPPLUdv2dcDr
         2AQFRv7EIeYLzXi7sjcZrMqCFWeYLb+sAgZ9jiH24gIaXQmdeiryZIaPDjTqajVyv9nU
         N3vym2gZDrSh84kLnOdZrSxdcZlLaXqRk1HBKwYipZws2yu4B5p2go+Cda3SibMorHyB
         bJqF/8HCyb7mA/Ax6Mi2o724jG1Mv6lxWV6xOXej8b4gZOPDtQyZp68fA+bw4u9rD4bq
         vr3cn4NFI5ycwrSZoAP/MCFSWC5LVhP8kFK4S5Wnt7J6tRlEJoS1ou2zCEJ/ZMDJK+V5
         OmXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784794246; x=1785399046; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=utY3y1MXpjBaz472phkuaQXhtUJ5TF0pPb5fcOjfRSY=;
        b=GnE8E3waxHQHjLwRhJZGyofqGe+/IKDFOE9ITsR7E+hzzU59WmUA1CgyT7wXpPyMHL
         W1ft2uiGKFteB4HTMcvcYLs8UdJqg0Cgotxu8URcx18gJQYiaaeNoYsgwfaPKH5mHvrU
         duwsOaYM2Euwu/JWRG2BuPKIgjwQcP0mW6TBlGkpClos9cGwVj6TgQ7gAyHTf8FCdbFJ
         1QXpL4/skVK8Bt+C4657qaum7p82dJa/5leHykMxomU7ikev24hvkhC+r6D+JKtge+5G
         JRbkKRP6vSUYwDWH9pZoZScnV0j/xpshnjC3aLvfkAtLLBi2NowMHjOPzx8Lxvr8rkxx
         OSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784794246; x=1785399046;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=utY3y1MXpjBaz472phkuaQXhtUJ5TF0pPb5fcOjfRSY=;
        b=NcLFOtSV7HtgDWzSK2wPH4POoz+EbghgXQ+v7g3PUmipkGxItnyoEpNRij0aEVR4zB
         U1tHE4xow2ovQs3Wl+xDyr+qBXhbhnsVAzdOuZyhpedXSSMq9HgREL/1N1okzhgolIzl
         Hv4SQyJYzcCa8ts9E4Z+C0PfIpn/74UnJvNeiWxKflj6+LkXcURSAmetxwZzz1XMg+8u
         6FQQmDJ3PwcUT/dOJmkVIMQs2PTUJ9/nsblyT2FWXaS6XRZNsYpGWZC4UG3laPb1lLLU
         tZrdWwU/5vCPC5LtW5m1jaYKFsESd6Cwsg3/neBpsfRwaHWGMWWJz/j2e8/ap2nwDaLE
         p+3g==
X-Forwarded-Encrypted: i=1; AHgh+RrdTXfZJ660jRPP9mXBzptMkb1ImzIWtA6xTkkG42upqarpdy9vyAbsmYcQce/JZA1AsHAiKxdj/w==@kvack.org
X-Gm-Message-State: AOJu0YxLTn0i88HHINtwebQg6ye0Kgric5jHB7oAvgTPVlve76lCEzKY
	2OXSGoZ/Rx7VtfG4cY5soj+zjBeZCLLRYupXTVmrFOqV4wdaYH4EPIEYpXCg6vclmABdR+1uONH
	liFvvIt7v5hS5JsYHBtin5/vY5sMnLuHQFDZOP2aT
X-Gm-Gg: AR+sD12FewgZRkUF34jt6P5/Stla3QdexojXGtvtyfiB/NhxU2shKieRwSiLnhpl8yy
	2FYAWo1XnpfkRwS8g+0Wn3sKQm1ws37sNiy+uJIdenzRLn6JUR1lfRVlhZEp28oqQ36BDIsNKxM
	FVmdBQ/oztw6xU23K4xNYa2vU/8r4GixnpQwfoqb7I7uul9n8fByqIH7CpfqU9gRra6cHUo12jF
	m6AyZky2hqB+1eH1/1lDP0+PbosLDA0GhXSCv32tQHfj/hlqYMthkdvnDUozA0=
X-Received: by 2002:a05:600c:4652:b0:493:ae5f:d29f with SMTP id
 5b1f17b1804b1-49573dbf606mr546705e9.3.1784794244846; Thu, 23 Jul 2026
 01:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org> <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
 <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org> <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
 <e63e0ab9-75bd-4a7f-9400-a8f87c80d1f0@kernel.org> <CAJDx_rjk-5pp5Z884bnTBss19Xk0msEayR=GAMG2wWCk+WOZ=A@mail.gmail.com>
 <aa8e148f-252f-4d81-89db-b1702d9b6888@kernel.org> <CAJDx_rjgyi-L-1j2kpi1NeKj+Huynd6ZFqJDmYqN8i8L3KyBfw@mail.gmail.com>
 <60cd723d-82f0-410a-9a7b-c4d75a5c94e4@kernel.org> <CAJDx_rj-zuesuhrHROrEx0JK=wx+=89DN7Qd-sMWtxUrJ3mdCw@mail.gmail.com>
In-Reply-To: <CAJDx_rj-zuesuhrHROrEx0JK=wx+=89DN7Qd-sMWtxUrJ3mdCw@mail.gmail.com>
From: Juan Yescas <jyescas@google.com>
Date: Thu, 23 Jul 2026 01:10:33 -0700
X-Gm-Features: AUfX_mygGfbPtNPDSeQikxzr1Vx3E8TliT6XI4cafBpeMRUTvpZAprnuZfCCw4E
Message-ID: <CAJDx_rhQXpc9s80GaKL9FR5yeYjrKZg3DzsiqTEsNqTTMs6NOQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via debugfs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	android-mm <android-mm@google.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, lsf-pc@lists.linux-foundation.org
Content-Type: multipart/alternative; boundary="000000000000f77152065742ca5f"
X-Stat-Signature: cgob5ypzrdtgoq349353qwoyft9h3eeo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3EE89C0004
X-HE-Tag: 1784794247-337549
X-HE-Meta: U2FsdGVkX196Mu4uLAxpOS1F+ftK6VwTXSHyzDietGv3kOByUYP7ZQFlLT2i+ukZdeysP/Vk93ReQfqDFC3HFLvG0re5t4YAqPdjY8qZjDYeVO7TO024Kno2WS62gHaEfChaeOl1VypUOeJ9sjxvWhI3TpkgO0L+fKRyiV84QvuTa5/kJPALDRxbwMvP5yblBA7vr3ZpCkod6id3Q8uqIalMkHRNBj/lSrXAIFxZL3eJ4AARQBiFb1BH/ZrwYCpQJLhaGfPU4dNCEAiV5wYxwZypwNy1v8fEaDDGfKdo3+NcUvYBNSVU8W9mLhbwYilRZ8OkbukSCGpfutUpTCZMyu/kcy4ISwLLMoE/p5jnJPvZ61fb9A3M5qsTL+5Ub5PFhIoZRW+uNnTh/LpqD++W6oYBzs1La37HEVoa0fzUN/owJK+P6zgnqIEPLt1U5lX3+mZXnJmDpA0zFCTgIOGlhye0J4IyEJJsqdhndyBjHr8e5eAvN6E0iATQuQ/zllbcHbc+LjIcE9uwsp8W3GACec3XK+l5o+6DE9gyr6mR4BGAto9ftcM8UieyB1f0thQft0Fw1mLW3jwdzaBnMJIFZUEThsXum6w21/PGu1XP9qYOcqYTvcp2uXBwP1DQyUvHOxmSCQQtuYVlisV295U7YrrYFRlZNLu7qd5NN+OjWo7jkNu1AQqdJKPjMUmWuZ8Z7X2crcErp1Lt/xHknWzg5XxmEi7sSoeFalQe3GK7Aym7xN9ZJoD3xl0l8bv1jVNURuxKVTMgNGBDTdUoThLrwlgN3Zj/+poYUbY28yq577TtAAB0u9j5eStwmoRWtXtvyj4z6UHuPVlKOkn/MKNVGe3BjaR8Y7/UD9zo25SDOoS9GpR9SSUvDmpknRBNuNPVUkgRmuflec6OkcvDYsEcUJxN1Td1jjHNhacF8MX8mcgWzkht/YfvXz66DqVgcICbXez1I5Rjd516/PiOLTL
 HBXuo5yG
 tI3t0gLu890rIITlB6X6/bDrNh2u1hi/u1ZFWv33DRJHi23sI6sT7C24tdxMcoE6bETN6/ut8/bYSEoHCIjdzSudrgGLaT/pOwqd9P2ZpS7hdE+Pd2r7pHWTsKF+KQ57CxRjY41bAU5rNXCSL/mH2qIqiLjxy30zEESp47TAeoX9r1LkHnBJdLTEyuW9bhJ/KRHIW5W476cjSbKBbbR5BrN3b1ThtNmAv+iAdXPDOxIRA+R4gv3oiRTg5zzmQhcS7oxkP8+gGgbeuiccAgGSgx6Fd/8XJtXCe8DQhWLV7zUYZXuZivwpbHgUJDQU9zqaVTe0bPULF2/fm0NbPr7stfJTdMKKNPZ8LwIXQ0qqKLlaNDt6A9I4IBA0wgE6MkiCbH6CeysK1yoc3Nsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f77152065742ca5f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David/MM team,

The patch-set with the Page Alloc Hogger is here:

https://lore.kernel.org/all/20260723074854.1013941-1-jyescas@google.com/

When you have a couple of minutes, please take a look at it

Thanks
Juan


On Thu, Apr 30, 2026 at 5:19=E2=80=AFPM Juan Yescas <jyescas@google.com> wr=
ote:

> On Fri, Apr 24, 2026 at 5:34=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > >> So maybe you really want a debug mechanism to migrate a (movable) us=
er
> > >> space page into a CMA area?
> > >>
> > > One intent of this driver is to debug CMA issues (pinned MOVABLE
> pages). This
> > > The driver will allow easy reproduction of the case you just
> > > mentioned. For example,
> > > I will allocate most of the MOVABLE pages and then trigger a CMA
> > > allocation, that might trigger a migration.
> > >
> > > However, the driver's main goal is to put the system into low-memory
> conditions.
> > > so we can reproduce OOO, kswad, lmkd issues seeing in the devices.
> >
> > (Late reply ...)
> >
> Thanks David
>
> > But there are other ways to trigger low-memory conditions, no?
> >
> That is right. However, in the user space we can mostly allocate
> MOVABLE memory. If we want
> to allocate CMA, we need a driver that makes that request or uses dmabufs=
.
>
> > So I think the real missing piece you are looking for is getting a
> movable
> > userspace page allocated on CMA memory, to then try allocating from CMA
> to see
> > if migration works.
> >
> > And you can do a bunch of things to make CMA's life has hard as possibl=
e.
> > O_DIRECT the userspace page, trigger low-memory conditions etc.
> >
> I'll look into that too and see which one actually works better.
>
> Thanks again for your suggestions :)
>
> > --
> > Cheers,
> >
> > David
>

--000000000000f77152065742ca5f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi David/MM team,<div><br></div><div>The patch-set with th=
e Page Alloc Hogger is here:</div><div><br></div><div><a href=3D"https://lo=
re.kernel.org/all/20260723074854.1013941-1-jyescas@google.com/">https://lor=
e.kernel.org/all/20260723074854.1013941-1-jyescas@google.com/</a></div><div=
><br></div><div>When you have a couple of minutes, please take a look at it=
</div><div><br></div><div>Thanks</div><div>Juan</div><div><br></div></div><=
br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=
=3D"gmail_attr">On Thu, Apr 30, 2026 at 5:19=E2=80=AFPM Juan Yescas &lt;<a =
href=3D"mailto:jyescas@google.com">jyescas@google.com</a>&gt; wrote:<br></d=
iv><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bord=
er-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri, Apr 24, 2026 a=
t 5:34=E2=80=AFAM David Hildenbrand (Arm)<br>
&lt;<a href=3D"mailto:david@kernel.org" target=3D"_blank">david@kernel.org<=
/a>&gt; wrote:<br>
&gt;<br>
&gt; &gt;&gt; So maybe you really want a debug mechanism to migrate a (mova=
ble) user<br>
&gt; &gt;&gt; space page into a CMA area?<br>
&gt; &gt;&gt;<br>
&gt; &gt; One intent of this driver is to debug CMA issues (pinned MOVABLE =
pages). This<br>
&gt; &gt; The driver will allow easy reproduction of the case you just<br>
&gt; &gt; mentioned. For example,<br>
&gt; &gt; I will allocate most of the MOVABLE pages and then trigger a CMA<=
br>
&gt; &gt; allocation, that might trigger a migration.<br>
&gt; &gt;<br>
&gt; &gt; However, the driver&#39;s main goal is to put the system into low=
-memory conditions.<br>
&gt; &gt; so we can reproduce OOO, kswad, lmkd issues seeing in the devices=
.<br>
&gt;<br>
&gt; (Late reply ...)<br>
&gt;<br>
Thanks David<br>
<br>
&gt; But there are other ways to trigger low-memory conditions, no?<br>
&gt;<br>
That is right. However, in the user space we can mostly allocate<br>
MOVABLE memory. If we want<br>
to allocate CMA, we need a driver that makes that request or uses dmabufs.<=
br>
<br>
&gt; So I think the real missing piece you are looking for is getting a mov=
able<br>
&gt; userspace page allocated on CMA memory, to then try allocating from CM=
A to see<br>
&gt; if migration works.<br>
&gt;<br>
&gt; And you can do a bunch of things to make CMA&#39;s life has hard as po=
ssible.<br>
&gt; O_DIRECT the userspace page, trigger low-memory conditions etc.<br>
&gt;<br>
I&#39;ll look into that too and see which one actually works better.<br>
<br>
Thanks again for your suggestions :)<br>
<br>
&gt; --<br>
&gt; Cheers,<br>
&gt;<br>
&gt; David<br>
</blockquote></div>

--000000000000f77152065742ca5f--


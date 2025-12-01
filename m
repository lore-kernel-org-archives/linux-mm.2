Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCF4D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 16:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28E1F6B002D; Mon,  1 Dec 2025 11:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265A36B002F; Mon,  1 Dec 2025 11:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C386B0030; Mon,  1 Dec 2025 11:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05FBD6B002D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:58:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 765CA12CD2
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:58:01 +0000 (UTC)
X-FDA: 84171509562.05.366FCE7
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E3674000F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:57:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cmlMIkJK;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764608279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkvWJrwlmiNdHgjUhorEV+q7WgGubFI+mIY+NNvMyLc=;
	b=0/8LKRcCuWpV4xRum+86PCRbwovIwcW9L04HTcygCEBriwcCBxAze1AzgKZmHkCKR1kCbE
	Fol0oBLIitUZT0myY+EkVtUHJ555NTs6rMvnhHVt8mHw80fROZK7Te+gwLIjYRJAKks3nv
	WsBLHMHg8n0GSXavCH5gFFcXkr9isB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764608279; a=rsa-sha256;
	cv=none;
	b=Ivcohh9DVeLUndE2wGMCC9QpDuCtkSaPhss3u709q51/T/0Nub88tyjVahE3GHygV4bYtF
	jUHZ8OfcSXYSBUN7ql20eJ2exFEZMvxIbYjCEv4FV8VMazb5+IOEsZ5bOIbnbkcbxM7/WC
	s+fgSn7ij7QKhHNF0GhaUb2xS1F3yyw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cmlMIkJK;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b21fa7b91bso371033885a.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 08:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764608279; x=1765213079; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkvWJrwlmiNdHgjUhorEV+q7WgGubFI+mIY+NNvMyLc=;
        b=cmlMIkJKEE8nkV2mkeDbFn9mRRAKuWnoGMr7tHUwdUm5QQCe4hXMbB1C4JKMuJJH0m
         pgssSGbW83L7JnnyjZc21hMQmJ8tCRWTjLtJZKBhyLilQLh5mbu6wcyRcTXoVXYSXYSO
         l2zJf6rUV9qO4J6MeLjp8peQ01gJmdjW2SBM74lSEPB9QxO93pPh+ujGubKWt4Y97Vnm
         stu8WGKirOrBlC9vFNFVr+mEjmS7jVt8RUe0OrGd6C0Klf/+jsbYLf4d2MmtmFv9M8VL
         n4Eev15pXphK9na7CfkV8SUYD271bPLmR29EaL9rXRXJ3tx9hwU4WCVfCTvYkJEIUxDs
         X+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764608279; x=1765213079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qkvWJrwlmiNdHgjUhorEV+q7WgGubFI+mIY+NNvMyLc=;
        b=Xom6fcog4jzS3Jij9VWxPr+Z1q7kbx861KtnOD8owoLpL6VaTbalsqklcs2AGhQgMu
         UUSdri0woxesHSufHYGU22EWLJwoW9pSuI5D9iqI+35PxKm5P7/hxs8EBQuy5yYvZ2rF
         ryZP19JTdi6OPqX9Vy0JOg1GpR8PTaGwkFclPDJxiub6BkrpFKrf9iJ7lvql+MJ5G/YM
         WthECVuq09F1nMGaLqr6JAogmWS/MNtho+lkb60gUpdoXN1cgmCkCbqH1oBl4Hqe1Xti
         GIWavIvRdZdSXX4Z5cllAW0oA5yFmsI9hU5BDhBO6aJDQGX9Ed0HExdH8e7OJgSzqoC2
         BMWA==
X-Forwarded-Encrypted: i=1; AJvYcCWwqq9wZFx5zNJ8PXFQxWD3dIYbFZWwaCa5IAg9SvCJvL7r8A68GtGAWBWJymj0aEHSWwH2jdffHg==@kvack.org
X-Gm-Message-State: AOJu0YywKyI7SCKdg8nbP80DzfrH/amEexDN2tTgZ21eg5AjY9uEFVCR
	eFZ6IPkb+0RiLNEidvxAm0suQpvDLWxS1d5y1XjOUaO1zspnwBFMzIn4Iu0KXLSwMjKIHbyJwb1
	qdhRazxE+6ycudsyXIj9vVRdB6a9UfuSyT/+7r1U=
X-Gm-Gg: ASbGncuOi434bU+7F8RNQxv8M6jLPHtKf52HxoYnK5yvXz+f2+7Sh6yf24rGQcH+JRS
	05WyCJHUWE5czzo2C/GO6OeB17Kihcmm19ajtSIO9XkCm3k/bV02p2wVjztuTEivy0vx4+bRFoz
	UYGO8DeiokvMLfwqjwRMs2A3JE7jNtYhclmplJkWR0L8Lt+zkIhfz9d+ekwMKEt4PsEGT5fMt9a
	dL8HQ6t8f4B/O/jViB9NW0BxOnXN5C/2b19PeLBmnLbOqFozh4O5L8p0m5ksm9wDB2Yj+zt5NQD
	sR5h
X-Google-Smtp-Source: AGHT+IHamfJ56do34KTHloOqyg4CL7wLBYonp9p4OPZxpY/sikqm0enpVT+NHGV/Fsmk+dRxzzdE8dB0HZWv6DDmN+U=
X-Received: by 2002:a05:620a:4049:b0:8b2:ea2b:923c with SMTP id
 af79cd13be357-8b4ebd53b32mr4182690185a.14.1764608278419; Mon, 01 Dec 2025
 08:57:58 -0800 (PST)
MIME-Version: 1.0
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org> <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com> <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
 <66c62243a510421db938235a99a242bf@honor.com> <CAGsJ_4x0aVkDf-AhhGbBLU=LCxYFqYoFL0ovij-vFEQeJ46jYQ@mail.gmail.com>
 <dc8ce4f329d74a24bde62c93818df44a@honor.com> <CAGsJ_4w16G+AngPu48SEy1H+ZuE1AQngiY=cSfEs9V6=OUKX_Q@mail.gmail.com>
 <48ba80e93270438994db78f74a7acdb9@honor.com>
In-Reply-To: <48ba80e93270438994db78f74a7acdb9@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Dec 2025 00:57:46 +0800
X-Gm-Features: AWmQ_bmAmfQs_Zv2TM5O3X6YMmxuU19fTmG2_9jDINF8_95jDxDouPDEnUbDAVI
Message-ID: <CAGsJ_4yY5MxOYjkQx07U2UzgL8mCZWCaVXyJ7e6hQ8UyVCcC8g@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
To: wangzicheng <wangzicheng@honor.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"david@redhat.com" <david@redhat.com>, "axelrasmussen@google.com" <axelrasmussen@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "mhocko@kernel.org" <mhocko@kernel.org>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wangtao <tao.wangtao@honor.com>, 
	wangzhen 00021541 <wangzhen5@honor.com>, zhongjinji 00025326 <zhongjinji@honor.com>, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9E3674000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: q1kr5ndphah3m4zjm4zw8r7yoqsyofo6
X-HE-Tag: 1764608279-688176
X-HE-Meta: U2FsdGVkX1+SimK2Y9aA+mAP8D5URs/Z5MPbZRzf5BkBoBm3plA6IlIH4xI5PFUHjPSK7MAr5lO/tuw0/hy4lq+shd+mDD4eVt1NraZxnIdyDl70rJKks1RycSxIRAsO9zti57Kpk3Kqzws2NKopKbAEmtFzqzDFaA6K97N1qg2YWH+wrkEzIpvsi3DNv4jDjt0ryWkQngkh4ZSsMcaloxPvoCoRz1DM2s/OJ3wUrFNyG5fe64cpcQyFTtd6/wEj0aeX0NkDZbWWKKzjoFsTRLUopdfrkPhnSp23Da5gR+Pfhp9mz03U7xPNpzClJINPhzZ7SSM2R1YgetHG6n4/zsJl7QbQAvTvIeWenTKnDR9Fh3rSN1gI5Wr27ksdH8HioR30sHZ+tbQkadeFUzY1CQmoabpug17dewVgr/DwobuG/iQyUrX/etNM3n4G4cr+lWxn/bVypNZIIVzud/1v7qND0ANYywghPSnzFXvNPa+0aDRLNpR95rCp91JkECY9At0tTsN28DROAG2GGkTBYjjz86Ommr/G32RW0Z6aYdQQBIkJFVntfjb3vJBh5FEhdmeHaK4fx6BFx0Bu5CtNoatOcIeD+fszJmTdjj/EAE2OXxWi00dR6pudFwJmfkW4tvC4ImIXii8lfmt43ShTchuy9/1G2P9KTcX+o3TpbEZJSv38OeEoefY88ZjCwrOr0nTIwiIL4bTvwCcYVJY4xFjOoEYIxGuuregm6HXOBqza1UDyj2PwgFq6LO3tAgby3UCIfww8IdiVF9+bRYf4HB+6YPo4EzXflyv0Wxdx3lgXBLMvilss5lCV/P18PWjOr8/8RVqpGaNAqCFWrOxl2ZlquLxyLExe+R9IL2UBSr3mIUtrEvZ+z0en+RQ75ozksONcLQf9ez87qkQPIE7NhfV3ai2WSJwvijZIoLFQUaE0YwiIdAiV1/a+ItkTQVtBVhwpfxpxVICyZ680smw
 OUxhihhT
 5FIae++sE97Hjqwn53GrMEnQTzBtZbVuUhDSJrH3TSJhh0jXQgAhO3jo9fhlYIcot0xm5ni+qXlQTOBgBuFC5Hu3CU0a/4mRB7sCgVxNLz+iRyCGwRBhUsK9+mm5G+8+N6LaIxHpaNMBaBuAmfAHcO6jEbbVImg8GxWK0+HzdbfUnFq956EuC28wF2DNOQcc8c7fr7ZcetKTkUmFihYD4uYLAulLfbUC1zMSjnfIs6bAiKg5pUbewCJpg7PZUtQkrzcjcGe5CdmZ4tjMZRMY7SC3IGegvsVRWIFAUHoxXnijKqKFwD9hnKMJ9OPe7LxU1/50zPxURH8gRAAWhCfxhxXVaXic1Hmuzmlz4V0YIHISSX6F96hombdZLnNF+wghk0t7/gQVkMA9bldoUvtl16i2smuVLj2Cap5snbEvkUuRhn6E2MyOdWTx2eeklma3hLcne1SLsuv6EAwcaC2WVZcJ46f/ySYTL+yRwiKZtoftE1N7E3wHXZ4TEdRg7a5/3V6tP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 9:32=E2=80=AFPM wangzicheng <wangzicheng@honor.com> =
wrote:
>
> Hi Barry,
>
> Thank you for the follow-up questions.
>
> It seems that our main testbed (kernel v6.6/v6.12 for latest devices),
> don't have SWAPPINESS_ANON_ONLY/201 - related patches yet.

Then please check with Suren whether it is possible to backport this to
the Android common kernel.
My understanding is that this should already be present in the Android 6.12
kernel.

>
> Since the max swappiness is 200, there are quite scenarios that file
> pages are the only option.
>
> Quote from kairui's reply:
> > Right, we are seeing similar problems on our server too. To workaround
> > it we force an age iteration before reclaiming when it happens, which
> > isn't the best choice. When the LRU is long and the opposite type of
> > the folios we want to reclaim is piling up in the oldest gen, a forced
> > age will have to move all these folios, which leads to long tailing
> > issues. Let's work on a reasonable solution for that.
>

We all agree that MGLRU has this generation issue. You mentioned it, I agre=
ed
and noted that both Kairui and I had observed it. Then Kairui replied that =
he
had indeed seen it as well. Now you are using Kairui=E2=80=99s reply to arg=
ue against
me, and I honestly don=E2=80=99t understand the logic behind your responses=
.

> Again, thank you for your guidance. We will carefully evaluate the
> Patchset[1] you recommended.
>
> > Hi Zicheng,
> >
> > On Mon, Dec 1, 2025 at 5:55=E2=80=AFPM wangzicheng <wangzicheng@honor.c=
om>
> > wrote:
> > >
> > > Hi Barry,
> > >
> > > Thank you for the comment, actually we do know the cgroup file.
> > >
> > > What we really need is to *proactive aging 2~3 gens* before proactive
> > reclaim.
> > > (especially after cold launches when no anon pages in the oldest gens=
)
> > >
> > > The proactive aging also helps distribute the anon and file pages eve=
nly in
> > > MGLRU gens. And reclaiming won't fall into file caches.
> >
> > I=E2=80=99m not quite sure what you mean by =E2=80=9Creclaiming won=E2=
=80=99t fall into file caches.=E2=80=9D
> >
> > I assume you mean you configured a high swappiness for MGLRU proactive
> > reclamation, so when both anon and file have four generations,
> > `get_type_to_scan()` effectively always returns anon?
> >
> > >
> > > > Also note that memcg already has an interface for proactive reclama=
tion,
> > > > so I=E2=80=99m not certain whether your patchset can coexist with i=
t or extend
> > > > it to meet your requirements=E2=80=94which seems quite impossible t=
o me
> > > >
> > > > memory.reclaim
> > > >         A write-only nested-keyed file which exists for all cgroups=
.
> > > >
> > > >         This is a simple interface to trigger memory reclaim in the
> > > >         target cgroup.
> > > >
> > > >         Example::
> > > >
> > > >           echo "1G" > memory.reclaim
> > > >
> > > >         Please note that the kernel can over or under reclaim from
> > > >         the target cgroup. If less bytes are reclaimed than the
> > > >         specified amount, -EAGAIN is returned.
> > > >
> > > This remind me that adding a `memor.aging` under memcg directories
> > > rather than adding new procfs files is also a great option.
> >
> > I still don=E2=80=99t understand why. Aging is something MGLRU itself s=
hould
> > handle; components outside MGLRU, such as cgroup v2, do not need to be
> > aware of this concept at all. Exposing it will likely lead to another
> > immediate NAK.
> >
> > In short, aging should remain within MGLRU=E2=80=99s internal scope.
>
> I would like to express a different point of view. We are working on some=
thing
> Interesting on it, will be shared once ready.

You are always welcome to share, but please understand that memory.aging is
not of interest to any module outside the scope of MGLRU itself. An interfa=
ce
is an interface, and internal implementation should remain internal. In oth=
er
words, there is no reason for cgroupv2 to be aware of what =E2=80=9Caging=
=E2=80=9D is.

You may submit your new code as a "fix" for the generation issue without
introducing a new interface. That would be a good starting point for
discussing how to resolve the problem.

>
> >
> > But it seems you do want some policy control for your proactive
> > reclamation, such as always reclaiming anon pages or reclaiming them
> > more aggressively than file pages. I assume Zhongkun=E2=80=99s patch [1=
] we
> > mentioned earlier should provide support for that, correct?
> >
> > As a workaround, you can set `swappiness=3Dmax` for `memory.reclaim`
> > before
> > we internally improve the handling of the aging issue. In short,
> > =E2=80=9Cproactive aging=E2=80=9D and similar mechanisms should be hand=
led automatically
> > and internally within the scope of the MGLRU code.
>
> Sure, we will make a careful evaluation.

Thanks
Barry


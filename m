Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D0C0CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47F58E003B; Wed, 15 Oct 2025 12:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8068E0005; Wed, 15 Oct 2025 12:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7148E003B; Wed, 15 Oct 2025 12:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79FF28E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:39:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15B4857825
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:39:21 +0000 (UTC)
X-FDA: 84000908922.02.B2AA237
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1D484100013
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:39:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=D6YURhqx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760546359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzhM5CGB+RoDFW8y/0jUZz7oHPU/o/zMoGAuCJ5t4mg=;
	b=f9zK8XAklBIRXkZLqKOV+vs+gdVJ7sI0WsFn6ppnCiT21EmtNIapSUuY8yPcn+vxUk0NPA
	4SUTUrWf08s4iZxf5RM/JilJh6zJkO++Jg3IV9yATs9nEJsZTXDhx1P1k3QPohfXs7kNdU
	RdHh9S0ES+eYUP3GzwpTva6Rld9HD0U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=D6YURhqx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760546359; a=rsa-sha256;
	cv=none;
	b=IQPFSuhyndduuyA13f71VjBjCJIgfDjU8mzmKwU7OAveQFDhpyLP6xA2qrTAgKepPLHY9h
	+fWGMJkWqX0QNrjrGceOnMlDFgbK2S0EDJQIWf3fHRsHCkve6uMszao165ivc6MOLAo81n
	Sgx6qbMeGNBCNa1i0UrHwBaxhaDm6lI=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso10309a12.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760546357; x=1761151157; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzhM5CGB+RoDFW8y/0jUZz7oHPU/o/zMoGAuCJ5t4mg=;
        b=D6YURhqxY3sNOPamWJFTp5KuCFTTmepfW6kPq0Gk7vISX4Zfi9iZzo0zTFlOFWtIIr
         klOp3nQXw9yU7bgdO5omqGC01C368T09j7ggK2O/M+E7HbiK26mtoIFz5sFxoFg+rkZU
         5fcCk9nRt13Nm4M8gY2zQoMG7s2Y5j5QMR9Ud+qSfZOy8NmCSUcbE89pSveu2/pp8gjm
         Lvbpx7R1bZeTVLwqMhXHILNOgTKrAVjTXGH7/vadsVwQljFHJH0obVygUluOJwYPuAXO
         IX/ilsodaPkp6IaFGq5aaey7sb5w/sHM/VDs9k/yxBwv4CD627WrhHPtOfSodlNoV5Mc
         yDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760546357; x=1761151157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nzhM5CGB+RoDFW8y/0jUZz7oHPU/o/zMoGAuCJ5t4mg=;
        b=kBKAUv5RTDDny3urOSky541NNBx0NApkJQqFs6S/BgYVye6YI+xT+UWDZ/yKkJCfI2
         razpXj76U9BMqA9moxreehinlC+8b7CV7iWka+aM1mLimADgU8djMAkHJE1dwgKSX3+C
         i0zW3GdrFuBA4ih7MPfPc7aOh8dVAgSilPPT0lShBPjosCRYZOtQVZLD1b6du4sWfm2u
         9LOQkA/PPDhk2TDK155VDZM5evTozTRSq6Sg5WReiCFjM0JvjDlNTngee6Y6RArh+Dag
         lP79dgtlFSdUloZQ1yFiw8CtHTAgbqtMbk21jvCkBGJ/aPLCwh4DwpUKXZjmHuuXQLND
         yDZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW5Xh2biC+dLk/xb9dhkhcdY/3K2ijTpAVL5YPsh+LaHlxayZ/GoTUvtgyGA3fLL/3pxalCWkTkA==@kvack.org
X-Gm-Message-State: AOJu0YwaN5a6Glf7r5r3kvD+NAUg2sEfGDHoNXZAROkCYxgk2k32AzI2
	FvZSISzMdvdOgn/awBIErluR/t4t/eYaqGQEgNJJgugT4gnM5yw3SFaifTtpCeu7/z6hZm5lOpZ
	o8lm4Z9lL1Vp9BM/wdcA2MhU2Ly9vnAx5amfRXvI8
X-Gm-Gg: ASbGncth1chKA3yJ0R7PjBsJMnzjNR0j37AXBc5OaHbD3+7StexirpOrGO1pKeWbTHn
	Cu0ivinxVc2NGZnQAH3lFxvMe/EtkhKfLFv90oRBWgzqSUkdmmo61JgpOC34YgCfi4CA9bK6a12
	+0FSQSHbsK/A/W5gQSm8dRLR0k4ehtVctz8v3oyQ8bkQ9OErdhIHl7DRx5FhMSqES3jlM7aRz8Z
	0+GLQITXblH9ThFfCJQC74XGE+HprAraytn4TUfiMLpTH7O8GrdGb6Rx8LKmKg=
X-Google-Smtp-Source: AGHT+IFiVuLYivP034AwNyXAkpK0U9cc8NbdifZyjw09pfdEvHJuVDozucJsWtjEL9bmQH3yJFcdpbpk6wFGjPz12kI=
X-Received: by 2002:a05:6402:3246:20b0:634:38d4:410a with SMTP id
 4fb4d7f45d1cf-63bebfa2921mr142406a12.2.1760546357234; Wed, 15 Oct 2025
 09:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
 <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
 <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
 <CANn89iKC_y6Fae9E5ETOE46y-RCqD6cLHnp=7GynL_=sh3noKg@mail.gmail.com>
 <CAGsJ_4x5v=M0=jYGOqy1rHL9aVg-76OgiE0qQMdEu70FhZcmUg@mail.gmail.com>
 <CANn89iJYaNZ+fkKosRVx+8i17HJAB4th645ySMWQEAo6WoCg3w@mail.gmail.com> <CAGsJ_4wYrQuhGY6FuZJzQJjQfx6udRAbP4XZvEevknrpqnkv8g@mail.gmail.com>
In-Reply-To: <CAGsJ_4wYrQuhGY6FuZJzQJjQfx6udRAbP4XZvEevknrpqnkv8g@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Oct 2025 09:39:03 -0700
X-Gm-Features: AS18NWDCakq1h-mH7wphh8y1dVf2NhsytSCg4Cqtn1Pb9vJqQi_9SQu-IJteMNE
Message-ID: <CAJuCfpGf8Hj1QAgNtbRwsBwTOZTidt9sGLwX8PYhiHWYyE9Z1A@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Barry Song <21cnbao@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D484100013
X-Rspamd-Server: rspam03
X-Stat-Signature: uh9qurq3o94i3cor3b3e6k8hdrmt799q
X-HE-Tag: 1760546358-619811
X-HE-Meta: U2FsdGVkX18abRaWVetsCZUN/029wZKvcyUdk9ap1fBxR8FyJnIU6mE3aNYGANul03WPfpL9H9c4PuZjv//G/VPIwHTcgXQdpll2BIoNLGMF0q/4BMfm550uhiR6qrOgbYCiNgkRcgomjrYs48q9LSVmrwoZUrnDiC829j8EfCEuLYVpA1lS9M1Ayhre/W9lVhAvfEwudnBdHFKaHDhBu8lJmiT8F7/gpmJl7uHeKUzFI3FWjO3/I0s1SbuY32lK4k9HkR6DFiUkDCQ/BDXmrjNAsGfB5GrjmAXxNXeFl22r1q7C8UJhnvTSWqdy14/o0kAzRSXEP8hC4Xu13HDdEwCK+aTaiaQA3IgOtvRXY4Qh8ul+9wpgoUJzhdjj2r6aJ3tBuQPIhaqndb7zoyfiB+/3BiBaXVvk29JQe4nOe/tKZ6JO3Ijgk9vgWjm5bCYykISLDhb/59GLrFebjE1zmxm87TM9d0jfHipLZDFwBsZRk+A/igNXKG1MfLdkhQCQRFGi75wjbXpoPvlWDZ7ITe/6VQR46Q6gQ+gZK3K2Hh8k7eRg5zKbRGjBxatd7ZH1orsYEQO090EMVZf6AlNjXoD+hEKhAAJlxDXCD7SxIsh5TZrID+cDnq46ud8AYhkEZU032Nh7Q+tFa8C4w9MtSaWoJi4hGIrNr6B5czjyaOicj/5laFUPKjakVmvNbCwbP26gcvu+tIQ9qrXB/l71z5krbVfOSYYLJL9HCKJ0VgU/DwCed9gWxwMPpa9W6TveEfchOTfGqjsQPAxr2RqV+fN96Drhx5c8gRz/D3UQXJhP/XqMr8PIXarnWwhyyQSUmxtj4l56jbmFvj5sbz9iw3DTU0SV2srKZE7iRRI55YwXhgL5PgexTl2cPngfjf3INKD8PU4MABlChPO5FyxLFdsjseMpLnOaGFsck66bo6wNX7500SMFjYPhYAlfOzCHvydJJvya3zlhew96nla
 J7tTfRoS
 2qxCjiB67NJnNq4L/ZIKT3PfCQV3ACu3e/10pzAVb9O6RHJebWWBDlVU0lJfa0XYynrtcNa2sxNfED5RUAWY6+dNx5Kz2yHt2lGQJvoDYd6LzolC9i1QjeKlvbvUqDGOgNI4CCLYt1K3jUKVzKjl+wyBvSK/iMK4iK8ZaMZplj1XVEwf4KgQA+DiCnbFYOoL7Jq+snUxzeJcy47GAo9sSQfS+OyMMYrV6ARKZ245zMczfSXxM8zuahIMb3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 12:35=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
>
> On Wed, Oct 15, 2025 at 2:39=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
>
> > > >
> > > > Tell them they are wrong.
> > >
> > > Well, we checked Qualcomm and MTK, and it seems both set these values
> > > relatively high. In other words, all the AOSP products we examined al=
so
> > > use high values for these settings. Nobody is using tcp_wmem[0]=3D409=
6.
> > >
> >
> > The (fine and safe) default should be PAGE_SIZE.
> >
> > Perhaps they are dealing with systems with PAGE_SIZE=3D65536, but then
> > the skb_page_frag_refill() would be a non issue there, because it would
> > only allocate order-0 pages.
>
> I am 100% sure that all of them handle PAGE_SIZE=3D4096. Google is workin=
g on
> 16KB page size for Android, but it is not ready yet(Please correct me
> if 16KB has been
> ready, Suren).

It is ready but it is new, so it will take some time before we see it
in production devices.

>
> >
> > > We=E2=80=99ll need some time to understand why these are configured t=
his way in
> > > AOSP hardware.
> > >
> > > >
> > > > >
> > > > > It might be worth exploring these settings further, but I can=E2=
=80=99t quite see
> > > > > their connection to high-order allocations, since high-order allo=
cations are
> > > > > kernel macros.
> > > > >
> > > > > #define SKB_FRAG_PAGE_ORDER     get_order(32768)
> > > > > #define PAGE_FRAG_CACHE_MAX_SIZE        __ALIGN_MASK(32768, ~PAGE=
_MASK)
> > > > > #define PAGE_FRAG_CACHE_MAX_ORDER       get_order(PAGE_FRAG_CACHE=
_MAX_SIZE)
> > > > >
> > > > > Is there anything I=E2=80=99m missing?
> > > >
> > > > What is your question exactly ? You read these macros just fine. Wh=
at
> > > > is your point ?
> > >
> > > My question is whether these settings influence how often high-order
> > > allocations occur. In other words, would lowering these values make
> > > high-order allocations less frequent? If so, why?
> >
> > Because almost all of the buffers stored in TCP write queues are using
> > order-3 pages
> > on arches with 4K pages.
> >
> > I am a bit confused because you posted a patch changing skb_page_frag_r=
efill()
> > without realizing its first user is TCP.
> >
> > Look for sk_page_frag_refill() in tcp_sendmsg_locked()
>
> Sure. Let me review the code further. The problem was observed on the MM
> side, causing over-reclamation and phone heating, while the source of the
> allocations lies in network activity. I am not a network expert and may b=
e
> missing many network details, so I am raising this RFC to both lists to s=
ee
> if the network and MM folks can discuss together to find a solution.
>
> As you can see, the discussion has absolutely forked into two branches. :=
-)
>
> Thanks
> Barry


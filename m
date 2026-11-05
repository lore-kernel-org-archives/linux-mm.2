Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A3C606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EqgbKL+C
Received: by kanga.kvack.org (Postfix)
	id 47EC56B05B7; Thu,  5 Nov 2026 10:40:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E586B05B8; Thu,  5 Nov 2026 10:40:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D226B05B9; Thu,  5 Nov 2026 10:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0328E6B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:40:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 877D01A0ADF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:40:07 +0000 (UTC)
X-FDA: 85401476454.22.0FF6C4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A45F11C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:40:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqgbKL+C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793893205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDZV0+pjHqmTjjQUQ4uC9YSnJ7Vm1jvBfF5OI0JOMto=;
	b=0Z+sW4e4z9mpPeUjHo5Yfw0Td2nQFWTc5R5Tgj2F+nS5qgAmTXYt7sHVnodyB9w9Gz6ZTL
	mVqzIIvwRVK6wFRz04IHeYYXKLIvSfVwBucSQ4Y4ABrhwSKXtjmtbEOhFFZWfFDYVoodW2
	UiRDnTCuetSg46nAeJmttpat0YGAMkI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793893205;
	b=laDjY7bKu44QrBhSPzFc3AjzeclsPYWowxVnjn0oAWvSrVRAFTVszSKt/uXMzBNbhHq6wl
	H96II+zETepgx1dZx6fmF2P7spInkJyBSpxWTRPOWss2vvNk8gxMHXfmV7GK4hmpQYVqXY
	alLdJubxQgBNrSUQzN3FbB3BKINkShw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqgbKL+C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38BE260A68
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41221F00A18
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793893203;
	bh=PDZV0+pjHqmTjjQUQ4uC9YSnJ7Vm1jvBfF5OI0JOMto=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EqgbKL+C5NvEF8nHOZcg7HYI6aeL/KWezyfGE9tktcf6hCt/fZBzlmpHSzhGpqKTA
	 1Bp7+DHi1qlvjwdiLqtkslWRSj7IRkXqEU5FF4UDEqh72a5AZ9VK2IpnMJa/BqFDJQ
	 0YyM+nmtaIqfaqc/VTFjuCGeZMoqLp9EQlC0N9kYC/2TT8uwrGpX3XmIrQ+zrzgfBT
	 PyuHKNJ9Pz6091Y0Mz2Wv5WdjdI3yk2qWu7xU0DvRo/JQ8nBzMzTD/MF6ZYWXWUQpk
	 JJWjtgQQxqcA1jIAW3nP4e+dnq+0gjyOOoy9S6/NmfQ3h6Oy4bUdBi3gTPQ5Dreh8J
	 K1uOZb7LV23Mg==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4697404c2bso32491966b.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 07:40:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxZ7oS16SHtofyJrarTLbquYczJbjWa302krQKpu+T8PxMMP5uy+9AZL5iNPvjkatZNQXkkF7tPRg==@kvack.org
X-Gm-Message-State: APuU4Z+3kBBA48OEUN6D0ggWVPHknW4ot6xcQBfP1Mt9EesQ/pW7kYmi
	ov51TPFlJHMm+b8Hyh323FJHiZ3iNJCvIzuHto9g8gySwGsmEUtkcDWYSmi1u+pljWaIzc1H6DR
	furPODIpVv7WX8YkKN5rk3N/6bSSmNTU=
X-Received: by 2002:a17:906:9fd0:b0:c40:80eb:c54e with SMTP id
 a640c23a62f3a-c4d3449c0c7mr1350366b.4.1793893202865; Thu, 05 Nov 2026
 07:40:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com> <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
In-Reply-To: <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 5 Nov 2026 07:39:50 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
X-Gm-Features: AclHuK-nHEy3W7VEoyAO170_A3kmjjHwVOoZaVi1Y45j7hC5yeix6KXpEhEkBoE
Message-ID: <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Wiseman <chriswiseman@google.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5misu7n4d7r5wkuws3h3mdgcinj5tnnc
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A45F11C0004
X-HE-Tag: 1793893205-313278
X-HE-Meta: U2FsdGVkX1+gpuIxY61QfgCVwkd/dKeF1ipd4g+kxoRanqLuh8QhQhRn51nG7gHQEpqWSW2HeFwcWbDTkugdYKoWyr6TrT+sPjNzB3IpRk/Z+FcE1pW3EWmzNuBvQNb9s4vyGsCs0+nILNQbRaDXPLLLP74G+O/WNGbdEZCKhy9JJi66gkX+S81tlAYDmAbIfjwYCz9JofLhPKEWQ8IecfKp0nGNTU/uHF3I6oqyHPwosIZgyCNmHnxpJs5AGn8QIO7vmP+RA0VOpmUvqntw4kmBMhA9ZI3chOHhS4OjqVVxixUyJbMmRSwdbcbyjzLw3eauDn2/jIPu44mKz+l86QI2anZeRitPDvsAs840SGTmQLpaUw3IwDzxdY3A1CYcfWkXmnR/mxrw1g5PePihW4eUFVucRwRFnxFQjQBlVSGjQxu0hvJBq8FLIU2IsP93kf4xutLO6a6Jpaatp0NScCNpdWK46Uixx1RBR9aEj1vrVHJ4/42YdHgHlZsGcFiDgBRmi25GjkvLHmfDWaRY9XgX2l41aHHzOWiBFcP4eLku1oQuhmbW3VzHOzklU9mciwMa6bh3ghYr28K44uCdy9sI+oFr7zX6QKsAm8iD8kdVlifFjqIVV1guskVRz2W1JegXb1e+17ACKCypJF5gKFR6gYBYd+u1VdYe35Lr7AGtJtTcpYFzQaFk5EkoNnu3lzcY7eijJ+HvqaE35Q1omQqnpmxHaedLYlxDbMyubnuwS6FFsch1Q5r71bxommufIHSakxAdkhnj3nf1eklNEKf6o4ABg+b6g0Z1lcPcQgeE6kL26rV5Bws5O6CyOQIskCj3U4oHqCQW3MANBswfnjFvYDuBcLJ9mu9C3oC8p+0ToipUGeMeT0NUhF4U1MhyHD5wlxmZs8oMxa3HtOvUq4xHK+8ZgfW+A1a3zCTa1eviA4wOaoVLBZBRI954lG8kJkWbDf53Y0k+n/MLF60
 6aOQbh5K
 ayinZLEORZlRx//KWS46M9FxdDleQ5YBFaVHlqDMpX5DvGMnc0/s8Sps0y6baQX83cceEmxG+GznXdW9GqOTt6tUZLAvMIQNucbXypMoO88L3oXT6xPv7VkBsNbWQVujBLZlc1yk38DDqBH+mOq/3deEMM1lxdRWn3F2WnH2h7krpW4pcTwqDk6gjKE0KFJd5ZoEOEfi2vcBNfEbSBoDZyajIpNYQ7L9E38niiKp0Ok6Etbf6mbYt2fxlv4vGcII6eo3VALheduM8rP2FoTrMEu/EGkc1kxWngad0hTVHaCauTL3ucLIAufhnuNXAWw+2hGJX+LgBJ4Tf+7/DN9RDyBF7JGhLGK8hosGLerbCLBjohZD1ojIvvrYh83HXp2KMb2HnbNtnz4OTNfIOLkfNmJX6UQOunbYFHCBEjt2OZtkoBXi/Gxs0C5boL9AsU0QxXpgd9boO8XnMJ1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 7:38=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Thu, Nov 5, 2026 at 7:08=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > On Thu, Nov 5, 2026 at 6:36=E2=80=AFAM Chris Wiseman <chriswiseman@goog=
le.com> wrote:
> > >
> > > On Wed, Nov 4, 2026 at 9:05 PM Sergey Senozhatsky <senozhatsky@chromi=
um.org> wrote:
> > > >
> > > > On (26/11/05 09:10), Xueyuan Chen wrote:
> > > > [..]
> > > > > > SGTM, but I'll let Sergey chime in!
> > > > >
> > > > > Thanks, Nhat and Chris, for the discussion.
> > > > >
> > > > > If Sergey has no objections, I'd be happy to send a follow-up ser=
ies
> > > > > to make the shrinker configurable and add the unlocked pre-check =
as
> > > > > Nhat suggested.
> > > >
> > > > Thanks.  Sounds like you and Chris will to have "Rock-Paper-Scissor=
s"
> > > > to determine who sends a oatch ;)  Just joking, let's first figure
> > > > out how exactly we want that zsmalloc-shrinker thing to behave wrt
> > > > zswap expectations.
> > >
> > > Haha, Xueyuan is welcome to send the patches!
> > >
> > > Dumb question on the zswap side - aren't the zswap shrinker and the
> > > zsmalloc shrinker independent?  Even if zswap's shrinker is turned of=
f
> > > at runtime, normal swap-ins still free slots and leave fragmentation
> > > behind, and unlike zram, zswap doesn't have a manual sysfs compact kn=
ob.
> > > Would it be simpler to just keep CONFIG_ZSMALLOC_SHRINKER as its own
> > > standalone config rather than tying it to zswap's runtime knob?
> >
> > Yeah those 2 shrinkers are independent! I think we should just let
> > ZSMALLOC_SHRINKER default to the value of ZSWAP_DEFAULT_ON.
> > zswap_load() (i.e zswap-in) by itself is enough to create
> > fragmentation. The zswap shrinker is just another trigger (and it's
> > also irrelevant if zswap is disabled anyway).
>
> If zram doesn't benefit from zsmalloc shrinker, especially during
> reclaim, I wonder how much zswap benefits. AFAICT, it was hooked up
> before zsmalloc was hooked into compaction, and compaction seems like
> the right place to do this although it technically is freeing pages
> from the page allocator's perspective.
>
> I wonder if this is something we can collect some data about, and
> maybe kill it off instead of putting off behind a config option. If
> hooking it into compaction is not enough, maybe we should add a
> similar interface in zswap to do proactive pool compaction from
> userspace, or maybe move the interface to zsmalloc itself.

Never mind the compaction argument, this is just to move zsmalloc
pages around, it doesn't help with internal fragmentation. -ENOCOFFEE.

I still think we should check if the zsmalloc shrinker actually helps
zswap or not tho!


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD8ECD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18026B00A3; Wed, 20 May 2026 14:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC94B6B00A4; Wed, 20 May 2026 14:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB86F6B00A5; Wed, 20 May 2026 14:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAD356B00A3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:38:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FFD5403D5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:38:06 +0000 (UTC)
X-FDA: 84788657772.25.D390A6F
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1F4EEC000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:38:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C3pFqCyd;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779302284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BAuf7MbQZyunGAyUzpAv9eVVSXT8WNUhWVQaJEfQARA=;
	b=Z7BReO6x3EHbKwwXQfLlVbuzYWv0pmfWdOqC8gKv1iOKLwTz0/d+Os75/CU9Sdkyq30u2t
	gLiJaL1PfTD/+c7+LrjF7GBb8dGnZWnOdvvfJLE7H7+TVqmTw+v7SPwGtpULYJs5Iq8CjU
	PnQWPbSs5Lu27Dtej2PMcBWbJSvJ6jk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C3pFqCyd;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779302284; a=rsa-sha256;
	cv=pass;
	b=poJigu61FZaUKAklCcyoWZy4Sgwp2eujlqrnCnuSKMO5JqQdEj6USN69RvIgHCqQ0DHbqn
	8qyWgXblx+Se43ErWQ48Pj0wBqI1W6a/KvDzCprORCFYulEYKAP6Q9XGSQ+V9Tt6cinpcJ
	pmaNoNyqP+OBAvJ3cpOGzAmR4KTXrdU=
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-133466cf955so17324749c88.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:38:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779302283; cv=none;
        d=google.com; s=arc-20240605;
        b=DTM3rwz70UjiBaq7nqgaa9G49NfBHRt9mY6ucBUCWypSGMSOs0OYsRPES9tLhA9JLd
         fDBJn14v4caIUY75V9s5bb/X6GspbaaeocuTWk1u1xhDmLsUG2abbyMYIVM0Pb2mfSoC
         YJ/JxO14/gmQr2wNFMunFzpgCv0130c6t0fwATjzfWRkvzIq45gbTJjk6iiBhqPgB2n5
         p0FZifbiKpST3i4Ck/ZclCu3By6ZEzF1wM/P7GPpl/j5G4QHgoPTZZ2yuaiNypz+0UnK
         cR7vJ8AB45+CGBjpH0huuBZJSqtS3S97d8WQtDTjUErkU3qBANqDXTf+XxYioV5+bbnU
         hpcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BAuf7MbQZyunGAyUzpAv9eVVSXT8WNUhWVQaJEfQARA=;
        fh=KH22578oCg5fFjghJJQRdiADaZUCAohcPE44XORHCG4=;
        b=fMYqLTsuoVAUQRW8iSdjgWLjDHjZwACaivi8qhInm7c5xirVo0PRW7+lz24Qg2+OZA
         h7h9NTNDYDFc8y7JprRRZrJWCBeJcN+NCRLmDK+pNh2a5kqkQZ8m7FCf3tDc/y6K20NZ
         c1DupQJIuf8GkkHdvDTJZaMp4U+HepuunD23earwQlVWS4YhZc0jDQ0QnncgdwcqsxCv
         mZD3LJqv6/OR+YJray9dQMW73KQGOvR/P5vkxnyCNXQqdPI4RyqlbesCrdHdnDWf66fI
         KvOY6neEEdFZfVrhEX6xOQxErHz44Pbtni8jXcx8FgyeqXFwjYbG8womrlN+yCH6yiDD
         pT4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779302283; x=1779907083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BAuf7MbQZyunGAyUzpAv9eVVSXT8WNUhWVQaJEfQARA=;
        b=C3pFqCydN9g/f1CS26yrIajBTE2TcmhcrG4L7Ocdli34jeeGQj3+XYSGVI0rO6wFaK
         BdA9XHbkN72TQLoE5wjyC+RAGGbcewBhNRNcB5O+v5RgfCS/ZYyvRmLZupw6DkHJh+xn
         VpmdkaoGovKT+WjDiAIEWIXq0t2M7YO7zygFCXQDQELQffiMwHLdYnxHNeD8XuE+6gdh
         vCFreUCIoReySdWXsEMx6Rl3nu0viSgUFt6k7m+sR3ianXWkJiZiH/ih3uJVA7nvirzM
         CRQ2JR1gEaoHsfr4SV0NLln480gr7JP/3/Ji2pigXNIQl5eYQXFVEKXTeYTcSXbEdD/Y
         iiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779302283; x=1779907083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BAuf7MbQZyunGAyUzpAv9eVVSXT8WNUhWVQaJEfQARA=;
        b=fhvBH/6VLE9KfYH9PT4svvBl1qxtPOrpmQeKCmsKHS9FxNycQLRctbGKgUSgWG1XWS
         VbPFpoo/6xp5e1Sjc54lm/ILOaaTBSZL+Um3ed5qm+uFbKHvZOmeqOavlmOJHuX1e5NS
         mrWskobmpU8u44UkNuwbPBNLpVR/FqsH3dPL+Voab/xcqzZJK7HEYRAZ0Lpj9Zk/UoEM
         Gj9gJOk87GMmW+NDEpuDXUyD9ct4NkDeaBIGV6PoNS8ftBkQUmMjEtESXrJDlPqv7A4P
         nc+ydhzHJHiQzKoiK6UVwG6+hz5Ir6ngPh7UFd1rhku5CD4Xb6fShxcNkAVd+Z6AamDJ
         8WBA==
X-Forwarded-Encrypted: i=1; AFNElJ+5kJH3DJhBAV/53I6UZ9p87CTms1RQvIPA0gGhF6/OuO6S0eCJ+V7EAsVgEt5V9Sx6yRmokatRJg==@kvack.org
X-Gm-Message-State: AOJu0YysyBaDtWLM9IS1l0wes9AxMh+i/wtLZYJvIRGjNJXWY/xq8Nge
	1//i01WIr3qUnHZ+CrJWDDKQqiuMAIhFebfI4B9v834Zj8JyWS4Wq4qJZ8xCJ8MPysjIWtRguI9
	Z/yhyD45XbPiV0kjIbXg39PCqJ0S+JQ==
X-Gm-Gg: Acq92OH1PyhCETAmoQDIXCya+D95Bc+UeBauwxR1V6HZRRLQP16kJefd+EvFq3NLiSl
	V/475+RP0HtLUgixIDzADFC22e+1GTD5pBpaPtHCaDEua6UjC6Q2YlTON67Uk+TIRc3yedISMu6
	Qsfxpf/XAwVigTn1DPXGptxUpaiZImrSSsUFAtOh2V2kNbBVyiZFDkWT048XqsxcauI3qoMWtrJ
	3Nw7WBxhOibpCdVquE0ihC5dU5pDI0FSXiJAiCDgjor/YrItoQahhWm6CrUo7jgwcH+kOeHfgOT
	ucg3Y/kwXuV1pXgi
X-Received: by 2002:a05:7022:6b9b:b0:130:9b78:b17b with SMTP id
 a92af1059eb24-13504a4fd4amr11166328c88.38.1779302282639; Wed, 20 May 2026
 11:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260516210357.2247-4-ravis.opensrc@gmail.com> <20260517184705.4652-1-sj@kernel.org>
In-Reply-To: <20260517184705.4652-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 20 May 2026 11:37:50 -0700
X-Gm-Features: AVHnY4JJcjwwRzJzIvyxW5twV6UCxEviLZFBxwk7zstZSFSrNzLAY-O0iJAod6c
Message-ID: <CALa+Y14AKLXSP8HhOMQomXczok-BS7aderfj_tYG9qdS9bKgvg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] mm/damon/core: floor effective quota size at
 minimum region size
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1F4EEC000B
X-Stat-Signature: jo8mtczm7wiyg3rbo5k9jfxp4ciuw3bg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779302283-826588
X-HE-Meta: U2FsdGVkX1/Rpood8bnzxDjXR6gXb1eqS+vVQnHLVwzIFLF+wV4PIxSvF/TnfwbeBjLzXvZzUec/zCjc84jgsxj+rTzPYnSuOilA7Ldz6yTEpXwalG19XFKrAOMBs9FUhDg/Pf/NZXwoDQl6IVy1EeUQGHsbIBZH9nDS/cDKBL1tVBWadJVZBVXAMEJgvCOvxvKKUu6R3UAESix76azx9AtQc5gpLVi4y4oCyA8+chDC0vY4zGy/48ukQESpBons+SXp5DxROAQf03zAryZYP47oSCmvCW+h8gMcsHp1dJS1DaQC+hHhea4sOwX6GCLnjffFHw4OfEcaNqo42d1I8x17PuSfhsfHtF2bLoTQormLzpc8a9uPbHRl84yfKK3ohAQM9/Pdtj/OTLQsUkZ9FQ/+My0/CoZ2kVIIFvMDiBNnfH4RsUGulOjTFLZYIcuU+x/iFoRxtmHazYuuf4CJc2+IoRzxiTFRn4c7wYHMBrPNh8ahWWLeCTJ4hgtN9TM6HeLXC4gpUABlC6DwGfHHnrnAMxagZyax+mxg6hAEzdHADKCcjcGCIkR1U0O8KI3l0oxsYNkO3IeaXSQGPRO4KRKnLXmpFwYDFIFPc54L5wbO2yMKjUq+3yK+vdAainGqjyPB1X0p4rANJZ9DTLSfuydpnBJupgVKJtY0HGvrff7OV1g7RB4o3ZICUP7QuMqIgwDmtMLpPKajCq1uUNWNiOfNRfdSlLRDFO5ZzZXt4gOfynJvPzG20O/daMw8sQL+2Ize7i15GAEiZAUJb7ndWYBfJEZ550wszFP2UVFae5Z/Gm/VL8kJz9pgMkfp5L5VxvtkUdu+Rug9fo2TLxI0C1GyJdgyBB8NECft/C8lQzMtJ1uLQDpAZIptE3WZCc++m6WQKWaSHF12Zu2heqgeO3rXUZQwpPTS5AtYEp/9Br8ldZdHbJymXt+sLviOvAezCJelwL4A2erJ9HMH+k2
 ykETU9MM
 IMzMRSKssVUd127Y+9tNb4w6/MsvSBaC8NK0G5lcBNi/W6mAqWzgkts1H4fJcj1BCAOaLlnrE1ZqWvJITKxPdimHTFtU6PTnTnjvfzvQuEI762HW2cUoRZJyI189UjUtRww5XokPTbPHs6cX0oTeuxRe4r153K7aJzsQ6dId5e+F8yVr+jB3XTkl1lpLNEEI8oT6Ysz25w73Hu8eh/IR+csaHflpRjVeTNhUbQKEmhREZ7xi4iUT2hnS91jvoRad9W4pcIkBcSp3ZojPdjwRAS55dacCIulgKwITLW+9Hs2JgP7SnMrJ7F6acO6DE8+EwHWjuirEEv1+AtbCXl8RNiCy/YpZmgg0g0WeKxPB3m6Ck8RDuqOqXS2F28hjFKzHqUPH4V2c4OWROR9WPXjFVjSCnQFReMeCYE6twwkbR09ZQK1wufjKpsBqMS6nuf/HP//jD0a19CzPe8mX675qZNwbMCZXoOOkLGuqDNFB9OA8gXlbvrxXCjJXLQ+f6/123nWUFHRU69iac+UkyRWLLmjwqYffz/73nKCVwVpCLZSP1ESrZlCkSOtq6uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 11:47=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> On Sat, 16 May 2026 14:03:55 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > The CONSIST quota goal tuner initializes esz_bp to 0, producing an
> > effective quota size (esz) of 1 byte on the first tick.
> > damos_quota_is_full() rejects all regions when esz < min_region_sz
> > (default PAGE_SIZE =3D 4096), so no regions can be tried and no
> > feedback reaches the tuner =E2=80=94 a bootstrapping deadlock.
>
> That depend on whether the goal is already [over]-achieved.  If the goal =
is
> achieved, the tuner will think no change is needed, so keep the
> effectively-zero quota.  If the goal is over-achived, the tuner will thin=
k the
> DAMOS scheme should be less aggressive, but it is already effectively-zer=
o
> quota, so keep having effectively-zero quota.
>
> If the ogal is under-achived, the logic will iteratively increase the int=
ernal
> esz (esz_bp), until it exceeds the min_region_sz, and finally start makin=
g some
> effects.
>
> So, unless the goal is already [over]-achieved, there is no deadlock.  If=
 the
> goal is already [over]-achieved, why we would want to make DAMOS do somet=
hing?
>
> Am I missing something?
>

Hello SJ,

You're not missing anything; you're right.  Stock DAMON's
feed-loop tuner ramps esz_bp out of the seed quickly under an
under-achieved goal -- on the order of ten-some ticks at the
1000ms reset_interval the in-tree DAMON modules use, so the
floor isn't gating anything that wouldn't bootstrap on its own.
No deadlock.

I owe a clearer accounting of where this patch and patch 1 came
from, since the same origin story applies to both.  Both came
from a parallel debug effort and should not have been carried
into this set.

The work that produced this series came out of an effort to
enable hardware-sampled hotness as a DAMON access source -- the
companion AMD IBS RFC

  https://lore.kernel.org/linux-mm/20260516223439.4033-1-ravis.opensrc@gmai=
l.com/

-- and to characterise its closed-loop convergence with the
existing CONSIST tuner on a heterogeneous DRAM+CXL setup.  Early
in that effort I was hitting random NMI-context hangs on the per-CPU
report path that prevented runs from completing, and while
debugging those hangs I wasn't sure which direction the
convergence anomalies were coming from -- the sampling backend,
the report-ring path, the tuner shape, or the quota controller.

I made two controller-side experiments as scaffolding while I
narrowed the problem down:

  - A per-tick growth cap on the goal-feedback tuner
    ("max_delta_bp" at 5%/tick) to slow how fast esz could grow
    on a transient.  That cap stretches the bootstrap above
    from ~13s to several minutes, so I added a floor at
    min_region_sz to short-cut the bootstrap.  That landed here
    as patch 3.

  - A separate access-rate seeding helper (clear-on-migration)
    for the goal-feedback loop.  Some early versions of that
    helper left the access-rate fields in inconsistent states
    and damon_moving_sum() landed in an underflow path I hadn't
    seen before.  I added a saturating-subtract guard to that
    function.  That landed here as patch 1.

Once cpuhp-related fixes on the per-CPU sampling path landed
and the NMI stability problem was actually resolved, the
convergence anomalies were tracked down to the sampling/ring
side, not the controller side.  I dropped the max_delta_bp knob
and fixed the seeding helper to maintain its invariants.
Patches 1 and 3 were carried into this set even though their
justifications had gone away:

  - Patch 1: with the seeding helper fixed, stock callers don't
    reach the underflow path -- the invariant holds at every
    aggregation boundary in stock DAMON, as you noted.  Belongs
    with the seeding helper if and when that work goes upstream.

  - Patch 3 (this one): with max_delta_bp dropped, the slow
    bootstrap doesn't happen -- the ~13s ramp is fast enough
    that there's no problem to solve.  Once stability was
    sorted I also moved the closed-loop runs in the companion
    RFC to the temporal tuner, where the bootstrap concern
    this patch addresses doesn't even arise (esz_bp saturates
    to ULONG_MAX immediately when score=3D0).

Apologies;both should have come out when
max_delta_bp and the seeding helper did.

Dropping patches 1 and 3.

Patches 2, 4, and 5 are independent of this scaffolding; I'll
reply on each thread separately with the relevant context.

Thanks again for the careful review.

Best,
Ravi

> I'd like to discuss this high level thing first, before digging deep into=
 the
> details.
>
>
> Thanks,
> SJ
>
> [...]


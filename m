Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A1F109C028
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0906B008C; Wed, 25 Mar 2026 11:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688CF6B0098; Wed, 25 Mar 2026 11:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DAF6B009B; Wed, 25 Mar 2026 11:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49DA86B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:25:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17B0E1A0497
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:25:45 +0000 (UTC)
X-FDA: 84584960250.12.6B75756
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 16E9840014
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:25:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kxkBnysV;
	spf=pass (imf07.hostedemail.com: domain of edumazet@google.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZgVnh0vBzrzdLKpRyko+vKpC3HHuo/gtjQSZOYIEAU=;
	b=GMdGuq07CNuEihPcFjxkbtm6s6w0e1EBD4+rUhJRADsP7FuSX5Z8djntyLr34Ywb5CQX8h
	V5S1AJJZcXCdYa8QICSh4tVRhU4fA0Qwo6OdcTSlqNno9nrR2GWaX5dixXeW+hkoUIb2Yv
	DZau/nx7OA+vKCvzV7phjfGMYGrqYwQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kxkBnysV;
	spf=pass (imf07.hostedemail.com: domain of edumazet@google.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774452343; a=rsa-sha256;
	cv=pass;
	b=nUti8LiEIrsNwdbcNPtuPR0bEg24bpjxC33H0x43pKX091FKXyMYHh9avvx07s7BOfbDu+
	rPal0Pd5ZYmnNPKUVQYu223xOYUSvufVM+ioV8txQJZAKpwNRySxNQ59ZO2e13uwUa9ErJ
	sD9JqCSiYUKX7mN8QXq3Zp/oHX9Rjro=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79801df3e42so15645457b3.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:25:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774452342; cv=none;
        d=google.com; s=arc-20240605;
        b=QHgp3gMTSCc33b8cfmALbfqbxRYHQ+alga2IG0boOxO9/Ivm1KHuRbsE2FRA5HGJP8
         RGOtMPCaPnTwTeZJlPhdSSDcXrXD+3PE09cxGAvRWbdLwTTlhWzS9u0aNhbJFKHw2RLU
         GAvNGYQkFLc1vigXZvmbkg5SInfibQjn07E0ja+r16GhRntfi7Ma3aeUJOHlOnrEwNBb
         NyQ3PaQlvcvq6KIOa5+4GtiETLggl8t+raP5YZGZWpNNwbLkB3IEI0tX/MXctynY4xiP
         3aazfNI2ofPur1GCq3dZ2yzLeek2+Pw5Sn6GPzRbmqyZCwc/XmQu8yl8pECfORcqJyaB
         AFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/ZgVnh0vBzrzdLKpRyko+vKpC3HHuo/gtjQSZOYIEAU=;
        fh=wi2K3IIlK6N+O575ATDnjdxbddqCXhWCFRqv6saR5rA=;
        b=OMFpr1qXIQGS1qh0MopjGqRDt8NnUX/69NUaEvsJlfQPFNys17uan59J4lVWffFo1l
         f4LfS/Zo2r1f0LR2jXE6IT/76XWY/fE4VN7IWcR7lntm7odu4zIZjG0DGlLj8U6KhdTu
         tYUV1yU/08JPB6o7vTW7fFK+rNuWiL0l76IfNKv7UNNqpnRiWAdlraCxwAWtuRyooA9W
         6bUi6OWrPz25An4y/sgE0j7dRVyoQvx6i/HoR/l2hVbb/6iYiN0LvaJCUooCt1Tctsx6
         ScRo1B1KbBvblVyNZ214PmDkZDY5CiPmHr2cEGKFgO2f8e8gC3EvXWkPPB/8cLUoHh5y
         XxLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774452342; x=1775057142; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZgVnh0vBzrzdLKpRyko+vKpC3HHuo/gtjQSZOYIEAU=;
        b=kxkBnysVS87M/AFiHtlgjfaRhISkSw1MId4EhBAAjs7geYOiJmY0hobhvlwkUa4Lvg
         KwKx1kGgCv3GmWnssVGKRxpZhfvCLGt6P9+AY81PGfLyEcYyIr5hXQAag2iWDvEx9Th5
         tk+cOr5FSGEzQ3JXRbMkqgPjpzhVuV3DhxrenmVOOtku1MdsZZ/+Rsi1EWftdo3rbd6k
         VskjSRVnQICUzqibfA4dFYodDtsNjXUf2aJp3MWY9PNJcqqg76ZrfClGqQ0TJ04a6ypv
         94U/tz+dyZXDSaJU3eOhhK26uEHbwxuhDgIXe2jzNnOeXBLJOhYODwDdxjHvlEO6yytT
         +81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774452342; x=1775057142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/ZgVnh0vBzrzdLKpRyko+vKpC3HHuo/gtjQSZOYIEAU=;
        b=CjVklYSq2+38sd//DSqqlR8t0KTOeBP5AH+oNjpAr2p2KAMQ8zADTtrf7MYoOAakpv
         o57iUpK83R6CTnx9ujSoFuqrwmmt2/UE5Uz0hZmt7/LrxAZDJfV8GHIEle3h4zbowdSu
         CBQ/EBo7kX9Pt42slAWwewBtRC27rBAUcl/DQ8PcrtV76+t4lvpgNmAHbwA+DE7fqt82
         AmwG0glfPgns0k/L/c6nKCM4gvRwK5F5C2ybj/g4CUws9OK6TeNRfNsnCPYSf96o+P6/
         wqORLMjNUs8Vna/qdXeqPyqrJnWmdsF+ayWD5/n691wSGFiySzAfW6osfCdXhHc97VP7
         zWnA==
X-Forwarded-Encrypted: i=1; AJvYcCX6f9k5PH37RyOnmb8zZ2ruZqeI32RSRFX9UZJxN0YcQf5Sncv0aoEqG+PPZ19FSeU6zbFdJJcGSQ==@kvack.org
X-Gm-Message-State: AOJu0YzXceaNXJBvOJVmrxKzBukhcrkPo1XqadA+ezgvU6l34vwz71rf
	lNElR4MkCmVVCOQQe+9UIu8e/+PU7RW60AsZFefA1OiLaoxss7rUHx61Dohc6J6POk50p/zDgLh
	JJkA9s24OrvJWICanuduZw4PFiQDA8MvSsN47dXma
X-Gm-Gg: ATEYQzwSgft+GsbJ0EpzjAfore0Bnrm0jacRiJ23rXdxr6Y3w9Wkez3OIfuv3Vc5Pfi
	U+hkp/pid0OoOLD1GnabuBnTQdFQcfM7tsYnWdU96uIKowH7/mJYXhlh3PzqROdO8elp+UXQTzt
	zzsV7hh9nxfiYbsfY5DGJGaR2zETDtuKFjd90dskHaMbfJWj1uBKMBNb+buXTtMvs1ADgd+Xf5b
	sCGjfKdUQVztcOy0OyuaeufC3F5f5Z6daCHzeDg8Bqq+YeND0EcAui3XSEvrooG0eurShSHHRDN
	o9TJB8tk29Gu05A+Cqru4Qsk1BmbZNQzIyLTS3XrW2wTNF4=
X-Received: by 2002:a05:690c:12:b0:79a:c5b5:d094 with SMTP id
 00721157ae682-79ac5b5e61cmr56555727b3.22.1774452341523; Wed, 25 Mar 2026
 08:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260313124756.52461-1-naup96721@gmail.com> <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx> <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
 <c892e7ce-473d-41e5-aa99-b95e0366c3fd@kernel.org> <20260325151445.GH3738010@noisy.programming.kicks-ass.net>
 <CANn89iLnJv9_HRV1vuURFM5uVA-y4SqBsBRD24kSJe7UmBtXSQ@mail.gmail.com> <20260325152206.GH3738786@noisy.programming.kicks-ass.net>
In-Reply-To: <20260325152206.GH3738786@noisy.programming.kicks-ass.net>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 25 Mar 2026 08:25:29 -0700
X-Gm-Features: AQROBzD6WOJq9HMl9PviVje0X7fhAoychNxXs72Q_9-4-I9MLN_UexI4AEBhPts
Message-ID: <CANn89i+cJ+BOs_swGU4vHbKPHVV+vqmHjaSywUxDzBu=nXfmtQ@mail.gmail.com>
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
To: Peter Zijlstra <peterz@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Hao-Yu Yang <naup96721@gmail.com>, 
	mingo@redhat.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 16E9840014
X-Stat-Signature: z1ffdc9retemd8fsd4g7j4nfrks7yj9t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774452342-54669
X-HE-Meta: U2FsdGVkX19gcKVe3OmGiT8W+Gvrhkn/2QQ2pcf84jQt6FHIcRQK3piNc4iLTFVln2FD++DIduhpCyeqVLr76Xf1R9fE+/MA0nF5qBisYFtO/y+zRdlZPRWheo1BgBrIFs3hNgQ7jv0pRk2289a35ojBt0am2GpI0r76E7Tj8TuILCWJuaCiugDLZhzID+SBhpWddbjdwRNesA6ABACuenNylG3KZ0plq1dsv27pt5hAxOREOWKARNzgizlz0iLRy7gnsNJxLeTRtoU+JoLsldCUK6XL+832wJVNFeV246NTB39HPZfMvWDVeGkGIWHbrOOW7Xvd2Zc0Zm6ENuouEQBSkDh+eppaIbsmfirdtRV4kJJodXkG00aUWvrMLvdmAJoWGFAWQslQbX36PsuJn58S+Q84yCpOhMm/KBfWvZu1UfTlsmrDS9PmZ9lP/tX7+64NMTKFQAX1rwOfeyLckfjllOdhol4n5A3J3J/Xe/rvKnxnqRCN94ilk9LIkqU1Rh6EmkCQYRg5ZYWhYu03Wx8pVWkQxQV0bWVa2pUdgk13NLUPuPvH2/SDS5qFWI6VlOvMfDwEWQat8ZYlT6oWJuN3tZDkNbRE8+5u2Z8t/DXzvIYGlRwzukDmzwvw8Vb7Hq+UM6V26lpUiad7/n/2idRsw6BIPuqVjLiAQ+QG6sCNPyimQMq6hXpFpMIi1XyZ/oV6KPmz7YF15RF3R1ZTmjkL1Q49JO76YrboBCx7KZmoYIwnXInLq3xmS7nP4k6ITf6J5h2hyfF/u2GOs7GF57uiHqy+RuIbTNKRTBHYCqEBRR9p3wkb1lV/eqSx/HQx6HxZO7sgFypjGRwSG6oTQn1rS/edrcHYVkUUc3x5QwyTc2/Dx/FVxqxMmPcufQ8URwBtn28hbhJzr/zUGExXM9Vx3Wa1QXcOpITEiqhEEg6KfY27I6j7csJzjT1MM6vyH2ADlByKJqzspIQF9Ol
 xeVnvqF1
 npcuyOEecCK6KqMEsPe9HXJYXHClBvjYg7mI07Uh9+U53S9+vz9+wElgPxlwbnj/fF1D4csTEZkCkSOFmaAOAKnb1tfeva+XvdARrZiYt80LKqhPBfuqnDLiJmSEXieJCTczPPsODey1m6BFsld2qedDYj1/DlYsR3eHxa4cUYekAf+5nfExDpBS+QLcTc1uZk9DuBpSdEqAQjTzNqnBSUm8w3zvc+GNCN4QVqeTfW41MO3xayT2q9mkKP/riHude1DUOqGsqHeqZL1VB1Ukp3CxB/tNDaGFKubQILz0+Hv+AXWmoNE5auq6yJEmgocAZ0YhNN3ycfaFIKDl07cDSEtefmigC4kAH35oneiiArQ9PCH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 8:22=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:

> Fair enough. Like so then..
>
> --- a/kernel/futex/core.c
> +++ b/kernel/futex/core.c
> @@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm
>         if (!vma)
>                 return FUTEX_NO_NODE;
>
> -       mpol =3D vma_policy(vma);
> +       mpol =3D READ_ONCE(vma->vm_policy);
>         if (!mpol)
>                 return FUTEX_NO_NODE;
>
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1026,7 +1026,7 @@ static int vma_replace_policy(struct vm_
>         }
>
>         old =3D vma->vm_policy;
> -       vma->vm_policy =3D new; /* protected by mmap_lock */
> +       WRITE_ONCE(vma->vm_policy, new); /* protected by mmap_lock */
>         mpol_put(old);
>
>         return 0;

LGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>


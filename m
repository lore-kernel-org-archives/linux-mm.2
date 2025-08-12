Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BAEC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C34A90000A; Tue, 12 Aug 2025 13:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099A88E0168; Tue, 12 Aug 2025 13:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA9690000A; Tue, 12 Aug 2025 13:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA4AC8E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:15:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11D5DC0134
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:15:07 +0000 (UTC)
X-FDA: 83768755854.21.74CCF3E
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1274AC0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:15:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LPXXHVWQ;
	spf=pass (imf28.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755018905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emH/9/qIpMML7VwyXCdOqP+butuG+Y1J3ry+obz5qAU=;
	b=upOfEBoSAn8dSPt3dWqb3eS/7vl1CF92RA8J+5vJ+YRZehqfrK8oPkkJNHWxfa9YrYKWE2
	SItUqxrGZPmegZ0K/Z+ZA4M7x9E3obiwbpYOkq+FXP4trG1oHBp8LrSZkN2xi+hMAdguKt
	14g9Ib2KLRYFdVHnYye9F+xhlNM/3G8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755018905; a=rsa-sha256;
	cv=none;
	b=oHm7d08pRTvaLGQh+B4lmeOrT78QeO3zPs85+ICaHLYinQSWQhcWnFat98G/Dd1soQKi0u
	1Q/n7nmYoGGi/I2skDSWWDECpwN8sVap6T+7p1tRePpE7EVOhi30UnDdqometmen6GMcYM
	AJTAfp995SsNGXTAXVYh1ecLO8OaGXQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LPXXHVWQ;
	spf=pass (imf28.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b78127c5d1so3710924f8f.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755018903; x=1755623703; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=emH/9/qIpMML7VwyXCdOqP+butuG+Y1J3ry+obz5qAU=;
        b=LPXXHVWQ73U8oxSHq2n7ufSi5ygYgTc30StjDKUfkLtQ/Lb5fdmq+aRAvQIUvi5hRF
         O9y2ruT0bbq/O9yHhpkoS3pHMctD3wmrYBrAY8P/MBKqEtL3hvs8AEGYW7KFhxuWUtTm
         x8WruFS2fVl/XfeKPRtHURyqY7KgQ3HR35HZ9hBdRn/RybQIOfmEVWz+m73viT63XprQ
         oNxdKpFgYLtFtr48NlByjDsnE2RdTudfUJQFCbIREHjfLMtDjebCdmDngE3PL+1N+5Lz
         BCILVH4hOQ/O4Bd5vr75KGUkBY1BVHcY8mKErb2c1khjhcd+86XsQ662ymFjwhEn1NZu
         qwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755018903; x=1755623703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=emH/9/qIpMML7VwyXCdOqP+butuG+Y1J3ry+obz5qAU=;
        b=It1ceVjx+CJ315HUMD6UmRnFMsnNEkUCi41siECOyfgNlwYcimXYT2CyyokaNn0ZzY
         UgQmgknsJ5vHLRbJT5UktsuDnHlaN6nLmNGRzU5R9QbdVolYdrHBrDKDq5XNKP5Uqc8m
         rjTfmJ4HvxhAUota+s7V5fCrUCrHiJ8Wdf0y9SHHrbas+GSVOYqbQXEtf/Slj75+0vRk
         DJSP2z4Fyu8sjaKVwMh5cDljWSoPKRtvOv53BWk+nF2U2CC4VhcB8V7ln4GvbM7v5DNb
         XrdhnEKNcJZoJjQ6lBvw4R9gLPryL2IeGC9FWhWy5eqoYfnz+Y1WsXhbOV5i/RENoz2i
         1h9Q==
X-Gm-Message-State: AOJu0YzZvKFxxPQgYx8U5i0lVYD9n7f/CuAlb197eovmuin4TheL7h9g
	bPNN4cm3zW3F1O49On/OKOIoP9nikadeuW8c286o2o9KjFWkvHcPqmsEh4UsUhhQRspQ76+kg9q
	IwiMvo/Lc4r2WnPUt9hd6bKGZXg78v+w=
X-Gm-Gg: ASbGnctRzcS0CCpoFS/jPSyJ+J0RlmIzZ12KrCgYUgOKWMnFwwxB7ZSl76TTLqfn69l
	dTZjePJ757qnu1cP3wgZINJAM8RI9I8DhBy7xZy6RHbM8KRAdB11TFsi7mWZ+TAufcRwzpPS058
	uvCL510vADICOPtx0aK2lKUGa90hl637FeQFT2+Bl2TGXnftY5iXOHIWY8C1yse/d45jkhR/2EI
	SrTRSvoLg==
X-Google-Smtp-Source: AGHT+IGscrYxQbMP7OG5PufoX/l5kbYx6BXGvLE32aEZsthI+SSXhiJax8zZreBUwk0pOZEPsu00PUEuLZoC4WM5glQ=
X-Received: by 2002:a05:6000:2386:b0:3b7:7489:3ddb with SMTP id
 ffacd0b85a97d-3b91730553amr137411f8f.34.1755018903312; Tue, 12 Aug 2025
 10:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250812124941.69508-1-bhe@redhat.com> <CA+fCnZcAa62uXqnUwxFmDYh1xPqKBOQqOT55kU8iY_pgQg2+NA@mail.gmail.com>
In-Reply-To: <CA+fCnZcAa62uXqnUwxFmDYh1xPqKBOQqOT55kU8iY_pgQg2+NA@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 12 Aug 2025 19:14:52 +0200
X-Gm-Features: Ac12FXxbfIp4CjdMiDbk99JZKDZitEGnh3AeOJx4PqX8F5dQQ1jZuZRm61N9EdU
Message-ID: <CA+fCnZdKy-AQr+L3w=gfaw9EnFvKd0Gz4LtAZciYDP_SiWrL2A@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	elver@google.com, snovitoll@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1274AC0008
X-Stat-Signature: 1zgtcyiye7q3a1xjugcfama536ukeiki
X-Rspam-User: 
X-HE-Tag: 1755018904-934814
X-HE-Meta: U2FsdGVkX192ta7NV2yEr8/7ihQ73MxkmD4Mm9jt+kurviuTBN29GFVgjKT6o8TK9hlfV0K7XPKR0KF31RkNm6p5hMXnMXRvwt2pkDaVyym9YobYtCokm335okvAdBZAisKZjcK7uKhlpiwcxTFm1FJx6Tv+OqlTvjOUEOgSEwpNkQnyp+sumXqta4jXFp6H8GNEAZAAKJYTuwx3+NFixHI0bFhO/qFIFz5NHRXvTiThDUXSt660sxaAC+mWtJvJQHuSv05QvxPgVRUe7ras5/JtCl9ZVSawOjbyJBeV2B4nFCy2EsieNp4HL8C3B5DPlANIH4BR5j5gQArc4zTePU7e5KLadBoj/utXm3JCTysLB/L/VQDU/Ef4kD4n1GUqLXol6B83A1S3TC6ZrPfgOF27O1dVYPOKsCnxsD+7yAqbBvCSZeHPbLR5XHti8PUfByhpZ2VCBL/Ve1Xg6ayk2GS+kbkupxiVqgZEwwcOvnCKaYDIaLAhSrhxtBhaitH+hXeTxCh02QMa+FfWTZeWVsx8P4qX1flRi6OgL3p8AvmlrMXTHdLQ0yrzTFriH0/AqaD87QPN6DRrx5DHV751m0B/356pq4JcngSUau5t6aIbDbyowLsEofYPt9rqSqVPIF6Cucssu9Qpm3mgAXzmuPmx6o7VrmdC9UCF0iC1tcaj8TGFztKebHUN47LCbWy4ACVTpp+Oco2faIoXWEzBjE/0UBnapBssZDmsGufsZUdqcuggRpB6WAvqTXyPVfG3luSADkJ0jkjSfl0Pz160YDsWxuD8gp49A2MOPUxtdj8wnzH/KpPxw0XD+jDd9Hsm3x1mst9P5puULTnmEkXVzmhj/8Hd+OsIozzp3vT/iEa5kYMcL4EGNjgrfY3bG9xOWCARAWvUGa1R6ZlXyj4GXUWMP2G/S3e/pp+LxEe8m1iB0QDnGefm1t5xAAfzbu5AvPw0mf7qOHzptUdHMiU
 db6k4LPR
 8aErtw74SEX9CZ3UFQYpA+KFYd1HagTBiDQaAXHy1b4CLxjPCyb8L9GoHudSAIyDRcZO+tKV/aBZOqvSEBlOB07b4nkiSakqzEAmojDvrBUt6kzTMLsCjtXzG4SD4Zj3/WEMfpDrFq12D1/2jyeD0OiWylpmIu9qL9NTvHNQOMAxfn/TL+4d19Q0B+gYif+H3JZeyO0CCneJGrPmXVy6pvvgHgvo5l8lY8wlbYpXKWrV+GpAEkgDr9epfhNt/OsANnuD4Y2eTV7L+RwdnW4NuZtkXPSY7sMwMEQD08Z/2T8fTRSWchxAxLz0683ARJFyicDYGaaUzB7ooZFHnGHdNM60MHdTn+8xooFYYNRbkeaDexb6246xo37Co+uitrYP9+vcMlwTfCC3VKLPWhFKN2Aus4MEaxUhLeiManRaoDp6hGrfeLivSNQur9Parx+oOdrOK/D2+1fPf6dsYu+u3Q5A5I2XLDknxeAyA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 6:57=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Tue, Aug 12, 2025 at 2:49=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote=
:
> >
> > Currently only hw_tags mode of kasan can be enabled or disabled with
> > kernel parameter kasan=3Don|off for built kernel. For kasan generic and
> > sw_tags mode, there's no way to disable them once kernel is built.
> > This is not convenient sometime, e.g in system kdump is configured.
> > When the 1st kernel has KASAN enabled and crash triggered to switch to
> > kdump kernel, the generic or sw_tags mode will cost much extra memory
> > for kasan shadow while in fact it's meaningless to have kasan in kdump
> > kernel.
> >
> > So this patchset moves the kasan=3Don|off out of hw_tags scope and into
> > common code to make it visible in generic and sw_tags mode too. Then we
> > can add kasan=3Doff in kdump kernel to reduce the unneeded meomry cost =
for
> > kasan.
>
> Hi Baoquan,
>
> Could you clarify what are you trying to achieve by disabling
> Generic/SW_TAGS KASAN via command-line? Do you want not to see any
> KASAN reports produced? Or gain back the performance?
>
> Because for the no reports goal, it would be much easier to add a
> command-line parameter to silent the reports.
>
> And the performance goal can only be partially achieved, as you cannot
> remove the compiler instrumentation without rebuilding the kernel.
> (What are the boot times for KASAN_GENERIC=3Dn vs KASAN_GENERIC=3Dy +
> kasan=3Doff vs KASAN_GENERIC=3Dy btw?)
>
> Thank you!

Ah, you don't want the shadow memory for kdump, sorry, I somehow missed tha=
t.

I'm not familiar with the internals of kdump, but would it be
possible/reasonable to teach kdump to ignore the KASAN shadow region?


Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D8060A260B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cnjpIbVN
Received: by kanga.kvack.org (Postfix)
	id 3E9706B05B4; Fri, 20 Nov 2026 13:53:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373506B05B5; Fri, 20 Nov 2026 13:53:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261896B05B6; Fri, 20 Nov 2026 13:53:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD5CA6B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:53:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F0EB140115
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:53:40 +0000 (UTC)
X-FDA: 85456396200.10.C50768E
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 195AE1C0006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:53:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cnjpIbVN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795200818;
	b=n5Ica1werIUjTUl2Ybsvua2ic0QfBE6Be2wqHfdSBymSZE/hg2UAI+lUgbO1PmEpKHUxHN
	NhGLHpqRfLl8y1A4UjuHmLKGVEhItmuBIpji+QgtSAM72NTlDisBbIsoC/GHW8oA3JFvEQ
	sIKj5wdXwqFmd8f90jIgnGogm3iZjs8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sT5pKOPeQasJwUhxA6x5muNzyWLPJdu9Xt2Zxrlxh4=;
	b=detOXjjLgZNixSnjJDsSA6dpnUl/M393nlGsN0nf1Mlp6mJE1ExUcsf/GgImTassuHhisR
	hHifzUS+J6G4u2wyN1OFYhVLezXUT38Cfk+QwZ9r1hPuckhfyZkbvqEjcmJOZEJvlotj2a
	gu4rSt6s1dooPNI1PjVSbCjcqAWyxWg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cnjpIbVN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e3b22e971so704262f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:53:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795200817; cv=none;
        d=google.com; s=arc-20260327;
        b=k6K8g+D/x+56yi3RatzMcdycl2IBjMQrhzsL83AvRDqyMlGFKwRwAWhhS+REqhIibe
         L8qH98SzE+bTvMoe3mV5pLVOnXekGwbtweyme5czSQek5YgvYONX/IfXVuh39tc1ehTd
         J2aEXQ5phDkHzfwDIWe1SSmB7MxfdRDApUX7a8wx0smhyRLTNRH4UWnh5OSEVrsQWbcq
         xiGkgeU5GiVDI74qUvyUnnahBUuP7tBvo051t5QB6nxxI116XM2/GF4vXCC1fLmrJfEl
         DFSzK+Kvy/0wYFQfXRIRkgd7+F1/QafqhkFGKtJ1n74edSJtB7Czv/SqegDze/QzcIuA
         Lh8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9sT5pKOPeQasJwUhxA6x5muNzyWLPJdu9Xt2Zxrlxh4=;
        fh=vKoO9M0OYai0T3DMiCNDl/dBLCYJ9lONSjhWZkcyyWY=;
        b=kOFcqnWUgmRbghoyhQDS42RC8h+iz3MUOfwvto8dxzKoOI3MxYksvIuVFYhflBsQSm
         v8KNJnpgY7RphF95GLWmeGt47l4+Fzw2L7SNA8YBP2wiYMfQ3axKsLM2euwhFbBWaIyA
         ZQ1rL1Ucc9G5j/yUUxv20wEaNenx193R/Ed9PHKYkzMSuP6jGQ2GnghjQvJMyc9M5eLb
         cRMKxxTPI+rK09ZS3V1j8McME9McVDTBqq01+ng33TNOkXSmr6w+24ORkKeJofUnuGV4
         jikKcx3GkBBSfc7HTOLIMqYxGNrK3vJwiMy2jXW7X/cSI521BcEdXFYLLtmT3/vyn+0U
         5Gtw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795200817; x=1795805617; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9sT5pKOPeQasJwUhxA6x5muNzyWLPJdu9Xt2Zxrlxh4=;
        b=cnjpIbVN2Rt7ArQPrdB55GoNgMUsE0gsFSdYT0l613dIs2DKjAsto0W6dpjxr6P4vp
         p55TI6RX/c7Bdwsr8bhKWzVgHMPluvQgWauy0F8IXmpW38Nies7hZ4LTxt+VUvlQ/3tq
         mMoQbVIm+4XmFHY/IeakShQaedAHL1s25/4xeHTzumr9p3LvlqppNQMv3IVw/Cr3xIaJ
         EE4NS+YZU0l2TZz/EM/9N1haYzWBM3OynnhUfoiVujp7E5C6FAcEQfmTgwP9QV4PT7Fv
         3kDpTqKWUKz1r/JdZuj7EZE91Is2ecNF1FwP9iJ4tH2wc+4+eNo9DtaC5QD9VvTxBvTV
         2GJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795200817; x=1795805617;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9sT5pKOPeQasJwUhxA6x5muNzyWLPJdu9Xt2Zxrlxh4=;
        b=Jv8Y1rR2Aeniw3kqUPRG15iiUqi9GZXQJOw/1/Zz62D+sw1mi6D9NjzAeSJw/cbSJa
         /4eh5SMsQo+K2rK9ZfdvzF4HNiEofLP57U6ZhqAmtKt7RuQmYJQYxy8t8GRNXMymtAd7
         HWxamqOvJFSUlAdnWBYFgUJU/fQBLVfYJKI15HVcqZHfiYk2LroGXLgAwFUrrwnHob2k
         gamp7qdwPTcBZ5YCQIgSEHS1uRtiod7/vC8GTJHY9C9WQsKmg5yOa4edztK947NKfLYn
         5of2PApClpgayw9hDY/sE7OtMMGKwMblUdSCp429ePtUZ131w5hdJ2UrkYfBY4ipm412
         5bnA==
X-Forwarded-Encrypted: i=1; AL+hErFwJj+x3PeqL2wVNM/WKE7trbzEK1ZXFHNunqvxHnmx2HuE5/mGaUh+eKNRQaPyDx/f/F8SxsWJpA==@kvack.org
X-Gm-Message-State: APuU4Z+7BX92oXB9aWUNPpSdSAJ1Wk9L8zrbt0l8Eq6jNnL7XbrfyTM3
	mifHXRly84zbJ/YM65xN92GX5GO82x9hopJf36WA4KALXJAoqfRNYjDhDbqni77b34RCvzb1T8e
	MMEiVW0Lb4t5b4NhgvHxZdo6TGoJMIZY=
X-Gm-Gg: AZFdTZciC3/q8XHWrTUS9oNEvU+rN7kLOTd9uYxrgH63VgqYNL3pL+nGQoi40ljpaTN
	oxl3pf93zmUw5RkV8BvqDT2lRQDOMxU2shMCt2DS6yeyyV5uiXOA9HAzzlHfJ2lgywVfU3Lw2QV
	eBfhvcwwbWsqcYO2xygftywSgoFQF1KkaJ2XyMuhFUe5wybNEVuoAAkbyLuJMDlkDEl0tIJGAS7
	3RSjSEIUSqFsl3/Ntyfoaty/Ti0p5UOfRzvoxNPZzMIGi8vZjrJGAi8x0WqyCaoR/8NH1MKZV8w
	b91ki8a5SImKVf29Ux2lBBO9BWdbG8KyAR7s9zbEiMAIGlfn0L8eYie4HIEGLniNOrzmDW0TcpZ
	zyzw7E4dL8GBMfhCz/OwasLTeO6AfPttBRBXW7Nb4YNUgVv+nNKVST5ib2EY4CIxUGYc4/1Dn91
	hRLdEY/Hd+BwHIJ/CR32A=
X-Received: by 2002:a05:6000:2883:b0:4a4:39bb:970d with SMTP id
 ffacd0b85a97d-4abab02c469mr8089761f8f.2.1795200816511; Fri, 20 Nov 2026
 10:53:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
 <179438454803.6.16655549133383619919.zswap-rstat-counters@gmail.com>
 <CAJnrk1YzYswBKv5F3=FF_o_4Pywgw0ifLq0tXYSWO7TARnFRJQ@mail.gmail.com> <CANGjgdnTjbou-XFqip7B_cGjrfZzZpan3dFuAk1-rU3bJOu8NA@mail.gmail.com>
In-Reply-To: <CANGjgdnTjbou-XFqip7B_cGjrfZzZpan3dFuAk1-rU3bJOu8NA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 20 Nov 2026 10:53:24 -0800
X-Gm-Features: Aa3M54oX3M667iXU9--_PVn5exl7P5ruO3wAPnPpv8aIQlT07cgivJguladt78o
Message-ID: <CAJnrk1YRBkoMppbn-GitdTXaNmpCf8kM2WHWvSfNPzNygoqw+g@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 195AE1C0006
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: x8cxy99f97rb4b7um8m9fnhbnuch8zoa
X-HE-Tag: 1795200817-72115
X-HE-Meta: U2FsdGVkX182/25KciTPxy0FDdCx4IsrVT6WnWVKfQbv6zIdhee2KU35xuBJfqRPlDddKm2bznUTE3RHWvIlgbL+2lL69ZJcTiNXrVHtIxAV//1Sl67n1RvxDsR+0Pc1+hHzxxn7vwxP9Gw1OmKXQXE0hJQx7r8gAuzfGCnc4wz4knGT19L964m4e/eGwnpvcPc3Oz1mK6uUmTu47rv0zpzW2pSlY0k1hTm+Jxb/70A6o3Mo+EPPz4A171W8eHuUWD0G6YoojLpxKQdRyd+GTni4jAI1pDgNRGq2Izh3m6MoyBspA5gYxOWColzFltLg9RwuB19o032+ODw4SQbimvGfnkjfRrtPTsRTMVXkJpBD8KwhxvlSTy1wV8yfMZVBCgbWnNINaQ4y+MYwSQEwlH2hD4bdO6MG6t2VibBSGWCnXQlU4hMrTPHGqEWZn6Wnr1WivnCasjanespMAzt6cl6EeTeHDygm/ZBRNFVyF1R06uXukBxKxRpG5SJdkycinTE7o39nCMqXwTGnC/qszLAHiqNMo9vaKDLBj+PTGZBEy1PqSTNVXkxmFLutUqqk3lgaz3oTHpEI/qRs9Q62yoUeuUQ6u/xcMFmNJuMtSGnnr6bIXN/7kg1xDiAn31ZbhQJPJDVw7yFc1K9x8xYc0KPs+cgIwJsNA0eQ0EwhqlIKXXhjUyvquy3asUKh15DFxkPDo39zg2EAl7XrB8iYfH5HK0kXhT4PrzYz2ufpVWdepR9px5xV3ybDWbS87WtWrwgkeyt3ixiZ0BjbnqnLzstNqfRzbmPROMUFNMGrG/z/rFwcisZ1IBUVaoWwkbnQznj7tzGN7elB6+aSvf7xYPt3dJcXIjxKx5ArUlCc3jK3u65AiBrvfoPf/pKA+NisDJODLofIg6i6/9YRbI5VRgdK0flSJyAamM52Y58iY8wRWNblCO/iPdbZf50Wxa9xilP7fnjul8IppOY/QG7
 OcKQBIJH
 GMiJU4BCEC58JyAG1Hj+e9wj0kb8vKGyZx7u02DCWtjSvjYkW6w6dg3SUwMGoyax8mQ1rS2C7481x/kiS1lN+Pig4hXJwuA7GzM71A09YbI8iDBKls/YJuweSQhn/AKZfcyEIVo86agHjkIQgfS5ckDMJV+uulPUGyJwzaHZ+iIrQcWgxuzEQwhlF2VfZMK323inmdzIahXM9CIvh14vj3sBFjCJXRiMILwXyEZ+q57yaQK5xtgJf6A9PIBwrjYye771Oo1EFy5jWgbB9S83BFqqXmP5O+RkNhWim/HjrYgreA1/V4sy9/oRU0ZxcEl3C9nSjgsuWGgYy01NJisv0zGDsvgN4QnArM+e4jWbbkhcpMIdAHigeEq+IMi1b+c68N6j6mo5nJV+EmO1eNAC3TestLrmykrzumupmU+ZWMV/mY5xTyvP7TEtLUqpPZdfT/DJL/ECwvJkxCcFtl75IoVXBVWbZ3DbhO48G7Wmo5vh9CTJjP0zTy8orzQBVc0Ssgm7vT7m4IiPlNzRdvrNPNDoUXGiAI+NxohCZJb/Tsk5iy00z3My083YgDTsrtWOn+Bu3ln3kvRAv/v9syZaFNHs8zjil+vppdQ27BgEmbFkmPl+9+7tbbRUiJJNmAEnNLXwXhnt/dcE2ci572xh4rgpEqcBJkfq2nh+ETpzbFesAOazto+kzDq//1W8/3SlqOGmp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 5:38=E2=80=AFAM Chengfeng Lin <lin2530632123@gmail.=
com> wrote:
>
> Hi Joanne,
>
> I tested the non-forced flush in our setup. It delivered PAGEOUT CPU
> savings similar to those of the hierarchical per-CPU counter variant.
>
> The only change in the non-forced variant was:
>
>     __mem_cgroup_flush_stats(memcg, true);
>     -> mem_cgroup_flush_stats(memcg);
>
> Both variants used the same MM base, 2967f3ccdb5f, and the unchanged
> reproducers attached to my previous mail: 32 MiB with one worker, and
> 256 MiB with eight workers. The finite memory.zswap.max remained 64 MiB;
> compressed occupancy was about 18.75 MiB in the larger test, below the ca=
p.
> The hardware was the same i7-12700KF with microcode 0x3e.
>
> I ran five separate boots: baseline, non-forced, baseline, counters,
> baseline. Each boot had two warmups and nine measured program runs per
> condition, including an unlimited control. Reductions below are relative
> to the mean of each variant's two adjacent baselines:
>
> Finite-limit PAGEOUT CPU   Non-forced             Counter variant
> 1 worker / 32 MiB          12.640 ms (-45.72%)     13.276 ms (-43.04%)
> 8 workers / 256 MiB       202.784 ms (-84.03%)    207.455 ms (-83.55%)
>
> These are summed worker CPU times, not elapsed times. Whole-program CPU
> reductions (non-forced / counters) were 22.57% / 20.97% with one worker
> and 61.82% / 59.97% with eight.
> The counter variant is the same hierarchical per-CPU adaptation tested in
> my previous mail; it retains the existing rstat updates.
>
> PAGEOUT CVs (non-forced / counters) were 4.65% / 4.33% with one worker
> and 2.91% / 9.26% with eight. The maximum absolute PAGEOUT baseline drift
> in these finite-limit comparisons was 1.69%. The small mean differences
> do not establish that one variant is faster.
>
> Separate instrumented admission runs also confirmed that non-forced does
> not mean no flush: the limit check performed 53 / 818 actual rstat flushe=
s
> for one / eight workers, versus 8192 / 65536 with forced flushing and zer=
o
> with counters, while successful stores remained 8192 / 65536.
>
> So the simpler change appears sufficient for the main benefit in this
> below-cap workload.
>

Thank you for your work with testing this, Chengfeng. When I come back
from vacation in three weeks, I will submit this change as part of a
larger series and I'll make sure your email is cc'ed on that.

Thanks,
Joanne


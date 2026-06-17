Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B844CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C286B0088; Wed, 17 Jun 2026 13:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162F26B0092; Wed, 17 Jun 2026 13:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051696B0093; Wed, 17 Jun 2026 13:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBD2F6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:51:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42B98166584
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:51:06 +0000 (UTC)
X-FDA: 84890145732.12.AE3B205
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32A87180003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:51:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A1zK33B0;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781718664;
	b=K3wp5alMVpDNVJG0uKkDhzvLDM2XrmOtpU2K2FgHtK0VoMv8w/kR4c5CKcnzi7VNBjPN4g
	KUcNu2WBgCXRsuAF9MjQ1nKRnGA6UldUprd4FhIq6kf2AdjsGG9DR48MeKM7vy9fdxRKW7
	GoLffozcj3Cn9/ElLiuV2aqIdCogcZg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A1zK33B0;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781718664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5M46FUNO5/BKeHWB2nQReT0UM4b5206qQCZ+wsNihY=;
	b=LgdbcZxx2OPezk9u0F1JBJQh1DTXsamCQEOwr0weXW2gRJdsvOxlkett5qoZMXycR1PaIP
	Bx44z8ilapgMfn46CM9XAp1APPAsBaKzsaa854xfavg9xEvwoKTuakMPPcoo48zgMhjSyw
	cbrI8yIu2ZxqQSHZ8VAi+LxqqeLzfC4=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-460662fcb4eso81875f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781718663; cv=none;
        d=google.com; s=arc-20240605;
        b=FWFLz5PwQdcmO6Y1nu8MCD7VWibKAMK0nn/f5+oV3fcV+As9cB9HDrfdwuppFE+6kF
         PcG62FTRLlFXMerhV108Fjf08A1BGfrqQr/6UKIey+iTEL2G0dVmqQC7ZBR/QqYSfj7F
         85OqXTCvfR2ZKQrq4FCSJkxM21uCpyuYqS4PYmsUarrImEzNioMGHSQuCxxdehkkdXR2
         wm2DNMmYuOnsWQcZyBzCHjmI4NFD4V6nN3XoqcEIvlSXZn0s9u0TmH2f0x3A3cZPNzS4
         4zi+f/N5fxKOOBp331Zwekibur9SUyMsM52KkNnSPS7hsUWH0Cqhi41Xb+4Mgb3sDNWK
         hYvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K5M46FUNO5/BKeHWB2nQReT0UM4b5206qQCZ+wsNihY=;
        fh=48b+Xeca/rkl54Zay2i8dX8/QhaxdbaH7OvxQaY/ib4=;
        b=Vh3IGa+nt1wt7E3lUnmHx3Q3ynyOSv7k1qCGiOitFgooVog7qeUkfdL9YC4pnFsKiv
         4xoZbdzC1QW25w4jZfxCVjouN+5FmD7r/Cq4RBbCfvM2kTeAvoONDR6gjHjWTiH95CuJ
         u7zBLTvEnVdP+ulD4jKw3gb2iNWHKja0ja4UII92oCKu3YwFHcEdm9Ys3QT9z6O8ISNq
         xlJ3oEybO75kOfOF35/LP35I64PJakUUgpffe/3m1i/UzUhj5q4Vdwe/kAnUDR+4sQWf
         /iuutUClWmDJBtKw/1keUzT29cI+R43XifbprIkqAv5MdfuU8Y+bw2iLW2V0RtGKOz7N
         4meg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781718662; x=1782323462; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5M46FUNO5/BKeHWB2nQReT0UM4b5206qQCZ+wsNihY=;
        b=A1zK33B09GhHNu9Yxnl/TUi0aY8OQPZ47GdrQsEQRfnqotcOSLsxYjZ/ASBTYdnXti
         YajFDHwfPUit66N9fI64/zqR6FrD6TAKRfuFQ29eOh4A0dQJPtYNmm1koE+2QfNrGXaU
         NCewO4hq4dyj8+FxX3SbmxkIBzxjhs8pRCXtaGwTIbfX3NO6Q43hVYzWhaGZ9hzCDrn1
         ht6n0oaREtx8pfS/8xh4QcuUsG1AQDGiX+bj75kCEKVrSTE5dUSSAQcdYcWmrXSELwi1
         LYeNmfSp5LWqpnA9wVDG2CahEr1SnE/xhg1Vy2zD7hChNeNrHGVMUmfeIKg6bKuK7MpW
         AZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781718663; x=1782323463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K5M46FUNO5/BKeHWB2nQReT0UM4b5206qQCZ+wsNihY=;
        b=pgx+GoePM5f5SIP4W8kXpFKCKT2vMalTQ7qIRb/vtqxhVTNvVdhlXxLnIM3TbKRVGw
         VC5gDF+flMuukImGntyeQwZDM8VE4fQcDudIqcYQ8eVOgekfI+bDfJF41KkHKBFZq7IE
         4Jn3mKN12uwN4sVZHClBgipfjtjnNkL06rYKNCgff7eMk8771sB+WTtNfCha8QH5Md4R
         esVoULihcuBmvrhPYOivmAT2czwk+1HcI2plXxpal9o2Q7tpS6IxoJmhN++7Y/Htmt7m
         ZIiB+TavWxfDFqElP9gPbu/YaRI8h9W9wf9EY7o3MM77D5115qMn7eFYL7KUlrsAopz1
         NNeA==
X-Forwarded-Encrypted: i=1; AFNElJ+yc2DL1QTw7BJRrGgOUkAQH+9yrNiy0dbOFrYp2d0HM6E5NUA/hHR9enyGqP4Eo4euiQHXtKRyEA==@kvack.org
X-Gm-Message-State: AOJu0YwVuaCQ462VoW3KJIp3uy6TRPRddM0dq365Zh+3yMBvb9S7+jgy
	EzwEO+Ez1mkYQuY5c3+0MXLv4fQlQjC8ThaKpUHHjE0wSUEX/Gns6Ggsk73mzu08aREwfTctpfU
	QTfeX8ysQNeOtiZLxpygdl9Di/MeTEmI=
X-Gm-Gg: AfdE7cmEXsQe+IoOpI2ZNjmwxH7XEaJ9rwId1BZqx6A3ZeNQgtwNfeu4jCXWFKjlFjI
	HnTas8f+1Ha4Kx0OkZQpVPIFiR8BkYIW7n0uHCdVYaBDdb+xzPfBbKwyWNjh+gWQaWWv26DO8an
	DB7SpyJcMMh7CLRgiStSVPQKAZyImuNz0p4F61NgWfB66GrD3w3vyVBDe6GsVfOS8i9Pvy9BLV3
	DQdUIh4lVSiCzGw1x2F7J0gExpwRNzhtpHefN17BSic4+taZ26nfbcWaSFa3gLkGxjnIb6kJE5s
	b18utjma+xJofbTgH3D/86SlK5o38+4VOjq74IDEaA==
X-Received: by 2002:a5d:6f03:0:b0:43f:e2b7:7160 with SMTP id
 ffacd0b85a97d-46235e9ac2bmr8193407f8f.4.1781718662538; Wed, 17 Jun 2026
 10:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260617053447.2831896-1-youngjun.park@lge.com>
In-Reply-To: <20260617053447.2831896-1-youngjun.park@lge.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 17 Jun 2026 13:50:49 -0400
X-Gm-Features: AVVi8CdnA42VDDU-EPXTa97wiw6DuLQNhC24odjJipl6r3Yjtt7VVim8JDQ6fKY
Message-ID: <CAKEwX=NfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnnr6J6PQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/4] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32A87180003
X-Rspam-User: 
X-Stat-Signature: oot6mywj3xbyufuyb8fnpfjpxgn79ptb
X-HE-Tag: 1781718663-39198
X-HE-Meta: U2FsdGVkX1+X1RLpKbnTcGd+22v75YfBS2wTqIYSp59+6u0bbsW0JChj9b5DPas31IwnKjaLU5Ps82lSb9JNoFTTcQWqdn8D90LoA03MWXiLSCV7M88Pmf2Hj6b93cmTlMG/Wxv/3ybkcWbSgDnGALJhgQDxRpIwZ5OwyyfkZCI1QpsNSBzy2ytQWA6/LKabQnuxz+44BxMGq7hhqQhWfdgu/qu40QhQU/XObhqS5uYEb4mrctrJb5oGOlkaHysbJ0kkDvbY5kxOqsQ8tcoM/X8mSvTJ8wI+cNKX0eRMsIhmiXwEFxy4UauZHNrRcTJHsqg9CPb0LdZ6GS/QtJCojioVBsFRqMjfgFXs1qqhnraIbXV8YFLbWWYKt31BROJc6awaKJW3FKHNVLSeLUz/yuRDe8Vj26qkCfAxRYrmKh2plj4/VdOmb1rs/6yoDP/Wy3e65MApS0T0viOdT+AFCziWqo0vb95+wrUdVhMs530nqsiLOQSwgn6kIssZYQCVvT/abvY56t3kjSJ5bSxuzADmRv1r5LX9W3+P1p6f5o7abkV5tUcwsEmbsoQZWYsRA2xqpU6RAzPIn9TnYR4xyvcf6mMwidMcV/l69tXCOuhlVss/ikUsHb3RmwiuXv9Q/jYnLT+aY/sDCetXnVDAsyY7zbaiJ2mvcik8vPbWmiQaT3SuD1qbkzRUuaJwLORyLhy8HUbJKkKFfX7pewabIB4nQx1FLdjNfeDMVrlS1qAAKGdFVzgmAujzFVkGYTl+c3dtRrWAfcL0wh4agMRCUk/gYu/lp60pR7ov7LjcSan9BF1IJJ/woUbfh0N9Orn1rpATS0CXK6SxJmlhbK8moScIM7fz1VvZGQKnKAtMDnQsJ68c4KvR/mQbD+/y24OJQVgmRS+0z01Hi75jLhys7T6P/9NcroZbb2EMCtSJrKN9VeLKstV3h58KA9O+dc8M66JvxvL7gwuIjZZsSXn
 EiblZ2NS
 EsGkOZxV7UrjOLx3o/a0o1Ss4d98vNt0aLePfRFPcFItlA1zu5niqeIHhgcFXH4Y5uEe0F7BUdB75CVbN2UZ2a9cA+ylaV9WBcwPPdI7QBGaCtu9STZ6VhLsioqoP7Y9y3IngkXq1fMIEb2gWsNJ8Fq07NzleMxqxLpdJv4J7rlsT+vSucCGZZ9H66n+2qSEVF+Pt7gdC1BfMsVWq2r9oElc1y4lsV1xW6V9PBO6OP2rTzR74RowPt8UpvJicOo6d4OS2TBG+fKcX7ZOeXSjEDRlY0M+9+Mmp3dEBp66/tjtKJP7/6XP58QBPXSgd7C8DEjcjlo8Vyy8j6EMZiGVra3dO6HCpsstAR1eJKO6gbZznspTGjeV3ZggsK7RQhzoPzMAdLuycW6GnWoZs+kcagsPxZRhTbXTRNU+MuVondlSSuaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 1:34=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> This is the v8 series of the swap tier patchset.
>
> Great thanks to Shakeel Butt and Yosry for the reviews and discussions [1=
].
> The main change in this version is the interface change to use
> memory.swap.tiers.max with '0' (disable) and 'max' (enable) values.
> This mechanism was suggested by Shakeel and Yosry

I like this interface too :)

>
> This change allows for future extensions to control swap
> between tiers and aligns better with existing memcg interfaces.
> Even with this memcg interface change, only patch #3 needed updates.
> Internally, patch #3 still uses the existing mask processing method
> (which is implementation-efficient), so only the user-facing interface
> was modified.
>
> We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for =
their
> valuable feedback.
>
> Here is a brief summary of our tentative conclusions. Please correct me
> if anything is misrepresented (details in references):
>
> * Zswap tiering [2]:
>   Tiering applies only to the vswap + zswap combo. Zswap itself will
>   not be tiered, as the current architecture requires a physical device
>   for zswap allocation.

I think Yosry wants zswap as a tier, right?

Just that without vswap, maybe don't allow it to be an tier of itself?

> * Vswap tiering [3]:
>   Vswap should be handled transparently to the user. Vswap itself will
>   not be tiered. But, someday supported if there is strong and real useca=
se.
> * Relationship with zswap.writeback [4]:
>   If zswap tiering is introduced, it could replace the zswap-only tier.
>   However, since zswap cannot be tiered independently, it is still
>   needed for non-vswap cases. Separately, the internal logic could
>   potentially be integrated into the tiering logic.
> * Tier demotion [5]:
>   A separate interface like memory.swap.tiers.demotion might be needed.
>   For now, we only support 0/max to enable/disable tiers. In the future,
>   we could introduce an "auto" mode to automatically scale the limit
>   based on swapfile size and memory.swap.max, similar to the direction
>   memory tiering is heading in.
>
> I plan to apply the swap tier infrastructure and the first use case
> (cgroup-based swap control) first, and continue following up on the
> discussions above.
>
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> Swap Tiers group swap devices into performance classes (e.g. NVMe,
> HDD, Network) and allow per-memcg selection of which tiers to use.
> This mechanism was suggested by Chris Li.
>
>
> #2: Inter-tier promotion and demotion:
>   Promotion and demotion apply between tiers, not within a single
>   tier. The current interface defines only tier assignment; it does
>   not yet define when or how pages move between tiers. Two triggering
>   models are possible:
>
>   (a) User-triggered: userspace explicitly initiates migration between
>       tiers (e.g. via a new interface or existing move_pages semantics).
>   (b) Kernel-triggered: the kernel moves pages between tiers at
>       appropriate points such as reclaim or refault.

We'll likely need some kernel-triggered mechanism, or we'd have LRU inversi=
on :)

Cold pages will fill up fast tiers first, and more recent/warm pages
will land on slow tiers...

We'll also need to enforce isolation/fairness to make sure no wordload
hoard the fast tiers too (but that probably requires demotion
support).

>
> #3: Per-VMA, per-process swap and BPF:
>   Not just for memcg based swap, possible to extend Per-VMA or per-proces=
s
>   swap. Or we can use it as BPF program.
>
> #4: Zswap and vswap tiering:
>   Tiering applies to the vswap + zswap combination.
>
> #5: Vswap on/off control:
>   Currently not supported. If a strong use case arises where vswap needs
>   to be controlled by memcg, the tier interface could be used for it.

+1.

Also, per-si/per-tier per-CPU allocation caching? :) Kairui already
has a patch for it, IIUC, but if not it's pretty critical I'd say.

BTW, can we add some selftests, to make sure the new interface works
as expected, and to have example programs for new users to model their
scripts after? :)


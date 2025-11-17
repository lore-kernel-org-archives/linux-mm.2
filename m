Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B51D9CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7318E0005; Mon, 17 Nov 2025 17:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE818E0002; Mon, 17 Nov 2025 17:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3C98E0005; Mon, 17 Nov 2025 17:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A63C58E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:18:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47C3312E062
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:18:01 +0000 (UTC)
X-FDA: 84121512762.06.28F51B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6466212000F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:17:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/JAI73A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763417879; a=rsa-sha256;
	cv=none;
	b=ANitsHyX/AmH350wI7pdBQ/t7cjInwNzz/TG4WBpi+gQbLcxIv5pMmrH0UZMl/ry777HDX
	a+HEXO0NRMpx6L39W50PmlZTs/MdorNReDe8b2pR1uYpnPKI0hm1ToLHRA7oBWal9haCnQ
	QtUTzW1hMeTRTw6WtZH4wgsEOyX/6qo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/JAI73A";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763417879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4G0o6feNFQCHQWlQ0wS7QBi/MIpqVPgOdk0C2pfULw=;
	b=piEAiblHuPleqfdxtiHkMzmnOIpt7IGEzDqnPYuzIrKIt9ltEXXdtD3Nrqy/f0+cYekP3X
	YzAHAwL9Hqh5eGqO2paOS4ifNcU7QD4Mvv8Q1wTykZXsT4FlgtHV+5SmFEpVXfGfs+smDr
	40xe2W6laT9FGyNxjEGVM8uBVv+81Z8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8546F601B0
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A20CC4AF11
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763417878;
	bh=Iv3NFR3+Iu7BTy0EYf2sC8D85e61Z7PXncB5P+SpuqY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=j/JAI73A3Url87p0yOhA4GnLmRiY/hwUsqIW0Im+c0MvGkdD3hZvS7Nm12jr5u/U1
	 hcXS0I+WPbIK5fTcqN8X4zKpzZ/1WYkDU/deCprl4rFR05E8yGv2KVMEFa40X/68s2
	 b4TmruhZqmdD75lRi5x7ziNGPm93x4jTcVEMZAtb6rkvstXXyyCjBeRliZf7U35aOz
	 EOP6nPrPSLYHnUuP78h86ApZwhYyFJ3u7duKGVjvM2OfmfDpb5rVE4yGfQVBXLKUqs
	 byQgEI8/nrpEp3DvncsQqhz3pzE0eQGpsHPxJ+Js6rnE+Vcg2Ef78WLm9v3vBA3BnF
	 z6CtrnZ9qbukw==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-787c9f90eccso51518687b3.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:17:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVHotvFwOukKsxoxws2GiN9TzZomw63RR9ygg6US3S62fG/YZlDOluqp9COnkdYapsM6Z5diEQPDg==@kvack.org
X-Gm-Message-State: AOJu0YwOlrm+fqYg+OJeu72HMWrox6Rv62qgtnaQguFu+lfPP1cHOZV0
	i9pMhIAe6e5eSogyO3Netvl52buJ5TcE6B3qB2JBYYtiAgg967zUammrFnJ/bS9Csg9TdJg595g
	FsrCtK82mE6qJ0k/5DMPgkJ/78LqtM+jkG1x8+MqDOg==
X-Google-Smtp-Source: AGHT+IFC3T7bPUsKWDSyc/zJmJY47BiOoIQaYL1jmAtft8112JY1ZeeYBWqU8Y48NcMEHH3fevNY3w9fgaSuVPuG/8Q=
X-Received: by 2002:a05:690e:c45:b0:63f:b2ca:80e1 with SMTP id
 956f58d0204a3-641e727ff0cmr11828503d50.0.1763417875019; Mon, 17 Nov 2025
 14:17:55 -0800 (PST)
MIME-Version: 1.0
References: <CACePvbUBEQsgoei=ykeM6uX_GWaFywZEXY7dGt+T6Pt4zhiGsA@mail.gmail.com>
 <20251115172431.83156-1-sj@kernel.org>
In-Reply-To: <20251115172431.83156-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 17 Nov 2025 14:17:43 -0800
X-Gmail-Original-Message-ID: <CACePvbVkBPJBaowW0tQrL0mPqSq5kM1hNx91BX_JroM8ruS7sQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmnY8z0jUWMzSN-Fi5TsGwGO41754NgluCVPEwQpNeRJicXbhNgs-x2yx0
Message-ID: <CACePvbVkBPJBaowW0tQrL0mPqSq5kM1hNx91BX_JroM8ruS7sQ@mail.gmail.com>
Subject: Re: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
To: SeongJae Park <sj@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6466212000F
X-Stat-Signature: ijdapp56zci89qx5mspw6kq1p9p15hzs
X-HE-Tag: 1763417879-486418
X-HE-Meta: U2FsdGVkX1/en0GAYSUk0ozhVFVuTwsK1paKbhvm2CTjc9HFnGmZ2mt6PeIU1zGp2ykS6Nx316xd9Lc9BY+rOZg4H5rQ+lIH025u5aK5d8Rtv6zAD5/MBvkAf/zP89wswXnyoUbpsG76Fgf6GytbXM46+YdERwDbhLTncCweusZQ+QQmHHngb4FQKkHcjjM4R8vJIh+13ayawQ3MwRF8y2x481sAxX7UUg77GooVayX34g8VB11pme5XVnttL7ZzbCbCz5J7QDsKRBni6Ol1VrS8YNGkxzDyVc9cNA3UNDJz/RSk72RoyF6T4IYckxdewuqkIPE3qkJ/Z8dG3yskD4nfVA4tQLoG3p1SP6V10ZR8+qcLqw5sfuHcXVVh0M9vxV2H6ZRjY/emIPzsrKMTtmDKy3VPv1bptj7MoTmKbCUNmUL3Zk0rAT3dxtMLEU75sjBkwKODZfRlJ0f1w4Wz/AWtFp7bH/siT3PXFNwvErGd3LXeZg6vMp4/3c/O8ejrDFXVGn8/XNe1hiW1AU81Fw9/JBiQV9UHnDJtFicwoXJp18SIU9VMWudWSXc1QxnSkxTk+1y86Jvm4GJyRzL/nwUy+oDIwoZAI3EIvp/jAZL9iVu84/cSKgiMIeTXBma7t105B21j8dti3lqXpy1ERQo3VIn7KYEys5Gv0YulB/6QqgUS2SgSmvTtBEZ92HQw3sbQDQ06Y9NVEsbUYvy3MyJ8YzugWwkZ1TZ3tEl70dU7+lXAMyyZQ9c05iBRxgBU5/pcQugwZ2mbK7QyICMewSjyOuGngZjl3/JC5e+0gopLyjxwf6+qfABY16sXC4VMQ1vBRpRR34KvDAs9de28wosYF+wniizxnNmzuBMHjMkhPS9Kalb1L15HeHy0Qo8AP6R+QQXIfwpVHAk09cs9l1DapAYMdmtLBFpTsA6Y+qSsHPwph7I/KoQ3J/R3edWnlSLkVwYNI3hL9Q5Nz6x
 SfWZ/uoi
 1xp3tKfZIqmzJu8zBeEPv8GkWANYhE8mphzaRf25Q7U/7L4DCJqDzLiwGf8Y4htZbbIxi4ZqwjzofI4VrLatptWRDpropdJKLJPKfW8viz/NwXW2zwsVFoGAutCuyy9szMk5T1N4P6LTeFhCaRs5sFxaVqfYhXSfUWMun2hPXixI8uCdCvMMmGdy7tGaQ/pLHuZhCwZ67zAhp3YKUp++MBuQ5aoBOII6Yau0SxPWMGEjk9sXDXqjVlnVtyGQfCPwa5vukvTeTvqVvNAcil9wwxBSGBRPVWYQLg+VjU/XsCf/JWqAapyvqXaXyV1FV3u+vD0Zl63OK+Bu+2i8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 9:24=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Sat, 15 Nov 2025 07:13:49 -0800 Chris Li <chrisl@kernel.org> wrote:
> > Thank you for your interest. Please keep in mind that this patch
> > series is RFC. I suspect the current series will go through a lot of
> > overhaul before it gets merged in. I predict the end result will
> > likely have less than half of the code resemble what it is in the
> > series right  now.
>
> Sure, I belive this work will greatly evolve :)

Yes, we can use any eyes that can help to review or spot bugs.

> > > Nevertheless, I'm curious if there is simpler and more flexible ways =
to achieve
> > > the goal (control of swap device to use).  For example, extending exi=
sting
> > Simplicity is one of my primary design principles. The current design
> > is close to the simplest within the design constraints.
>
> I agree the concept is very simple.  But, I was thinking there _could_ be
> complexity for its implementation and required changes to existing code.
> Especially I'm curious about how the control logic for tiers maangement w=
ould
> be implemented in a simple but optimum and flexible way.  Hence I was laz=
ily
> thinking what if we just let users make the control.

The selection of the swap device will be at the swap allocator. The
good news is that we just rewrite the whole swap allocator so it is an
easier code base to work with for us than the previous swap allocator.
I haven't imagined how to implement swap file selection on the
previous allocator, I am just glad that I don't need to worry about
it.

Some feedback on the madvise API that selects one specific device.
That might sound simple, because you only need to remember one swap
file. However, the less than ideal part is that, you are pinned to one
swap file, if that swap file is full, you are stuck. If that swap file
has been swapoff, you are stuck.

I believe that allowing selection of a tier class, e.g. a QoS aspect
of the swap latency expectation, is better fit what the user really
wants to do. So I see selecting swapfile vs swap tier is a separate
issue of how to select the swap device (madvise vs memory.swap.tiers).
Your argument is that selecting a tier is more complex than selecting
a swap file directly. I agree from an implementation point of view.
However the tiers offer better flexibility and free users from the
swapfile pinning. e.g. round robin on a few swap files of the same
tier is better than pinning to one swap file. That has been proven
from Baoquan's test benchmark.

Another feedback is that user space isn't the primary one to perform
swap out by madivse PAGEOUT. A lot of swap happens due to the cgroup
memory usage hitting the memory cgroup limit, which triggers the swap
out from the memory cgroup that hit the limit. That is an existing
usage case and we have a need to select which swap file anyway. If we
extend the madvise for per swapfile selection, that is a question that
must have an answer for native swap out (by the kernel not madvise)
anyway.  I can see  the user space wants to set the POLICY about a VMA
if it ever gets swapped out, what speed of swap file it goes to. That
is a follow up after we have the swapfile selection at the memory
cgroup level.

> I'm not saying tiers approach's control part implementation will, or is,
> complex or suboptimum.  I didn't read this series thoroughly yet.
>
> Even if it is at the moment, as you pointed out, I believe it will evolve=
 to a
> simple and optimum one.  That's why I am willing to try to get time for r=
eading
> this series and learn from it, and contribute back to the evolution if I =
find
> something :)
>
> >
> > > proactive pageout features, such as memory.reclaim, MADV_PAGEOUT or
> > > DAMOS_PAGEOUT, to let users specify the swap device to use.  Doing su=
ch
> >
> > In my mind that is a later phase. No, per VMA swapfile is not simpler
> > to use, nor is the API simpler to code. There are much more VMA than
> > memcg in the system, no even the same magnitude. It is a higher burden
> > for both user space and kernel to maintain all the per VMA mapping.
> > The VMA and mmap path is much more complex to hack. Doing it on the
> > memcg level as the first step is the right approach.
> >
> > > extension for MADV_PAGEOUT may be challenging, but it might be doable=
 for
> > > memory.reclaim and DAMOS_PAGEOUT.  Have you considered this kind of o=
ptions?
> >
> > Yes, as YoungJun points out, that has been considered here, but in a
> > later phase. Borrow the link in his email here:
> > https://lore.kernel.org/linux-mm/CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T=
7GFsm9VDr2e_g@mail.gmail.com/
>
> Thank you for kindly sharing your opinion and previous discussion!  I
> understand you believe sub-cgroup (e.g., vma level) control of swap tiers=
 can
> be useful, but there is no expected use case, and you concern about its
> complexity in terms of implementation and interface.  That all makes sens=
e to
> me.

There is some usage request from Android wanting to protect some VMA
never getting swapped into slower tiers. Otherwise it can cause
jankiness. Still I consider the cgroup swap file selection is a more
common one.

> Nonetheless, I'm not saying about sub-cgroup control.  As I also replied =
[1] to
> Youngjun, memory.reclaim and DAMOS_PAGEOUT based extension would work in =
cgroup
> level.  And to my humble perspective, doing the extension could be doable=
, at
> least for DAMOS_PAGEOUT.

I would do it one thing at a time and start from the mem cgroup level
swap file selection e.g. "memory.swap.tiers". However, if you are
passionate about VMA level swap file selection, please feel free to
submit patches for it.

> Hmm, I feel like my mail might be read like I'm suggesting you to use
> DAMOS_PAGEOUT.  The decision is yours and I will respect it, of course.  =
I'm
> saying this though, because I am uncautiously but definitely biased as DA=
MON
> maintainer. ;)  Again, the decision is yours and I will respect it.
>
> [1] https://lore.kernel.org/20251115165637.82966-1-sj@kernel.org

Sorry I haven't read much about the DAMOS_PAGEOUT yet. After reading
the above thread, I still don't feel I have a good sense of
DAMOS_PAGEOUT. Who is the actual user that requested that feature and
what is the typical usage work flow and life cycle? BTW, I am still
considering the per VMA swap policy should happen after the
memory.swap.tiers given my current understanding.

Chris


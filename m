Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27DEFCD0435
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC566B008A; Mon,  5 Jan 2026 22:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894076B0093; Mon,  5 Jan 2026 22:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C97F6B0095; Mon,  5 Jan 2026 22:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68EDC6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:14:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36AAF13AA06
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:14:37 +0000 (UTC)
X-FDA: 84300071394.03.255D565
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf14.hostedemail.com (Postfix) with ESMTP id 363CC100002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:14:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L4SeUm1j;
	spf=pass (imf14.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767669275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSIXmXHDZZDTd4tsk6VB8G6eA4XEfbMhwVQl2vQbAZs=;
	b=uIVNsfUjjI2kO6GrtyStcmEPlZ53ZbD5MrpEqU6ywZ0mWwVSWoAGnBgQ3OrU/c0wEVhXEe
	cRmcsMfLTxodqPx43nco+czzHqZFpyWe1dwLmoR7DNRmpZg3jn23uITu9FIeC2VOknUBso
	3zeJzLPCi0dWnG9eX8WLS9V6pfNn9no=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767669275; a=rsa-sha256;
	cv=none;
	b=2CYECVuzLaz7VXYNDSoKKnNo+5XF6mlaJ3CAC11zax9C/Y93pYBH+UonGHc3dtrm2y6r1g
	fUxulTNmZg+290vMzgiGxdhnPMaZww2o8FvCuWlbQzxiw3NyDY3JIh9uiiEDyLX8oYshg+
	0Pmntoq4B0wTYLTr+dx+jDd29TeOWbI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L4SeUm1j;
	spf=pass (imf14.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767669272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SSIXmXHDZZDTd4tsk6VB8G6eA4XEfbMhwVQl2vQbAZs=;
	b=L4SeUm1j/nAU67n5ezffzmjCAaPcy9UI1hOi8JJXpVKrGChdsu2EFiAaRVNxAAogheJBV2
	46PNCMSxVk70AuM1bZ9lNDF2H/zmLT84KOpu/+AECdoBYf0wv8i/6YNjscf5lh4OVuGL1T
	lnrfComLSWTDt2PpK8hY7rvDVs6apkM=
Date: Tue, 06 Jan 2026 03:14:29 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <d9ed02ebcf71057e42c808beb68f8eb489394750@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm/memcg: scale memory.high penalty based on refault
 recency
To: "Shakeel Butt" <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand" <david@kernel.org>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Hui Zhu" <hui.zhu@linux.dev>
In-Reply-To: <qlzvksuvo22rrngdihyeepwhphretoenre3gvkako7kgsgw3sy@l775pvzorcdh>
References: <20251229033957.296257-1-jiayuan.chen@linux.dev>
 <qlzvksuvo22rrngdihyeepwhphretoenre3gvkako7kgsgw3sy@l775pvzorcdh>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pnrw817zr51p6xnr36k1yctmr1oqfjbe
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 363CC100002
X-Rspam-User: 
X-HE-Tag: 1767669274-193461
X-HE-Meta: U2FsdGVkX19DlkQN1jHzSlNhsH83KT/OAf2HW80KZoNvJ9KmirSFSnQHXwmOfi6YdOjWzs69svy4nO0Xd04+exJiRhL9hzkA0K5xHUR2DabVyN58+2OBjoqULEf7nBcaZUh5phLxjeQcrigBbdGPI7REzkh6fdobUZhSmIg6uF4ek/sRrTAk5qq9TOO8dKzlKPeeQauuULmCjoh7/DhXrShmWvdnbzCSydrRGsIGaT3vW2eO75lf1/YZAbR4C6lsEWzrHKDN/s/fqm0BEh2HU/lOCLpJQUyoGIuCLHedHukTd6h/d8vIrv4RvkFTninKkJVRwxVgCLzhSTALZVT5DMphid16c/2XLnMLUAkpQxprwVw3/Lz0oCsYcw8vPb1tNV7mTMk2ymKGFi93dT6PgqkCrkG2S8Ak4PGGS2X5ny06PImuy7zKdzmVLpQ0CyVbTT78Y8MQ0pUVpzSVnpHGB2Dc9r1mK8HU8Viwgu6LBJnX8rGOd6lAYEOLRqF8+wwTHUlm1h2OXTS8L0bR8bsm8urz7UxLhnnlXCpXdjGLbW95LTXxXAniTYncyI8i12S0oqkmBsBy1IXeH3dx0h+2YOxRZIoZ9it+Dt3WmdNA4aPsm9Rf8agdhe9rafMHGDT27hA4zvKNfBxuG580/nOQw7UnLgEnb9YcQc7gd2wDjrEL560GO6fmb06OcxrNUPx1kraMkVfgNP9iPJnQwW/Uh/cuZCo5mrfhA+aHVwF/OvbLgLVHCms4iIlw60d/Fj8AeaNSUubtPsECXPnOGg7toW7lffG5GFGwEpd9B6KWbrLoUC/jCrrZPodtO0+2gXECIgTT2Rw2aZgbTFFqyTPocUWUv01VivJNKrXtr6zaKQ0nBuFNbqaiiuN7VwAabamJStG/zrWGkmTitl2YiGNp7RYM8pBbeq7PC4V0K9WRuQhAK7TDGR9iQanaSeKjMpmkAdB9LCkKOVjM03G3xD/
 +RkdrWT8
 P1aNsVr+CZvuxLMyAvr3+sjRLi/cY+KbtgsY3jJPpCrT4EArrpGWhNGag2LmTw5hAAHz4ajnzManbOzIi7w9lHDtUhWpNarbIygYZjvkhAm8EyJVm/03odkIIcEQapMVUehcDPZJHeccXA+KCpGa9uotxdsbIxwm21W56wZbCB3EtzpHaVbT8+e31BYViJk2gs8eeMFTng0SIyJXvohYIewk3S8dWHMKK/+CVkamjJFluXoVwBYtxRfVvo0YZr5kzfd/Fjy4AQTbq3ztphUIFYgc8bGYHbLtbbrD0JFwkeCVLcjRldpTWDXVUqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 6, 2026 at 01:08, "Shakeel Butt" <shakeel.butt@linux.dev mailto:s=
hakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux=
.dev%3E > wrote:


>=20
>=20+Hui Zhu
>=20
>=20Hi Jiayuan,
>=20
>=20On Mon, Dec 29, 2025 at 11:39:55AM +0800, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >=20=20
>=20>  Problem
> >  -------
> >  We observed an issue in production where a workload continuously
> >  triggering memory.high also generates massive disk IO READ, causing
> >  system-wide performance degradation.
> >=20=20
>=20>  This happens because memory.high penalty is currently based solely=
 on
> >  the overage amount, not the actual impact of that overage:
> >=20=20
>=20>  1. A memcg over memory.high reclaiming cold/unused pages
> >  =E2=86=92 minimal system impact, light penalty is appropriate
> >=20=20
>=20>  2. A memcg over memory.high with hot pages being continuously
> >  reclaimed and refaulted =E2=86=92 severe IO pressure, needs heavy pe=
nalty
> >=20=20
>=20>  Both cases receive identical penalties today. Users are forced to
> >  combine memory.high with io.max as a workaround, but this is:
> >  - The wrong abstraction level (memory policy shouldn't require IO tu=
ning)
> >  - Hard to configure correctly across different storage devices
> >  - Unintuitive for users who only want memory control
> >=20
>=20Thanks for raising and reporting this use-case. Overall I am supporti=
ve
> of making memory.high more useful but instead of adding more more
> heuristic in the kernel, I would prefer to make the enforcement of
> memory.high more flexible with BPF.
>=20
>=20At the moment, Hui Zhu is working on adding BPF support for memcg but=
 it
> is very generic and I would prefer to start with specific and real
> use-case. I think your use-case is real and will be beneficial to many
> other users. Can you please followup on that Hui's RFC to present your
> use-case? I will also try to push the effort from the review side.
>=20
>=20thanks,
> Shakeel
>

Hi Shakeel,

Thanks for the feedback and pointing to Hui's RFC.

I noticed Michal has already forwarded my patch to that thread, and
Hui has responded. I'll wait to see how that discussion evolves and
whether there's an opportunity to integrate my use-case into his
BPF framework.

You're right that my timestamp-based approach is heuristic. It was
designed as a simple, low-overhead approximation to detect active
thrashing without the cost of flushing refault counters on every
charge. But I agree that a more flexible BPF-based solution could
be cleaner in the long term.

I'll follow up on Hui's thread once there's more progress.

Thanks,
Jiayuan


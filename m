Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F99C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C1C6B00CB; Mon, 21 Sep 2026 12:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43CF26B00CC; Mon, 21 Sep 2026 12:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C326B00CD; Mon, 21 Sep 2026 12:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0430E6B00CB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:33:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B27BFA0228
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:33:11 +0000 (UTC)
X-FDA: 85238314182.22.85811DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B455AA000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:33:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSWszFqe;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790008389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSsGiUnjBfIVH4aIMRBngHnw0miI+1j+1kMwtWAY0nk=;
	b=AFzoh+EHm5Se0xZq7e3aSZxbsQmkHquQcc3mVURHqvt8Q1JAXe/nT5WmISZfUTKojo4Z2w
	jnG3bdjmKdVYhSXhgUOynUyc1f3gD9SroFrV7r93RISg/kNBD+CrSkn3dtfvXh7xibgSxU
	peZ9yM1CT//6+EPNaZ6UD6UyipPVBG0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSWszFqe;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790008389;
	b=kD5NsWO2X4Tkns8jjVEpiHtp/3mJ47PL33PZO6eUuUCkFpKYSPpauSDyEikqJDUjBjs+tD
	HtOlR7Ymgnpx+nko71PJrIvSY22QgRHPu6DrV8BLbpd6vK3ZZCnq3dx8HtLXyfXGVhsDQY
	9yUDFUyt9McrRU04GUQJ0N7i7FbsofU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0C0C43890
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BDB1F008A5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790008388;
	bh=mSsGiUnjBfIVH4aIMRBngHnw0miI+1j+1kMwtWAY0nk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZSWszFqeIM3oVci5qOaLvTHaRQQQPkw47ACjVetKpvbozZKK9k6Rg/o3N8qwPbV1E
	 0p+J0WkQfdJ7V58nHfKMqCyqtdK0hGUVP90qkpYqocQmlZdSfKHAQBSoRcFCBPRu63
	 PZKBNX0Jj5WXR694WZe8S9+UTk4fW3In1lwiA5oQXrEeXkW8MXkHsjRpHnTe7jkmLn
	 x3/j4WaxdpFKqDceTl7gLz+qnkqgkftKYTvKHfistiCSP9BbmYRZcGm+eFuLEzTMN7
	 Ht5fXeeCgfdYH0EZBJrahhyqhOjE5DdezwFkwu4qqjDgW5Tu+diwd2J0h+skpfx/Q0
	 jCkgDsKTQ/lAA==
Received: by mail-qv2-f29.google.com with SMTP id 6a1803df08f44-90cdfc9b6ebso28560196d6.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:33:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx8/IbnclfjctHOne0uTROYQfzJi0WhdGATnTeadOMlCaKzg7ntFknOfnnVwL98q3o7iUh3R13zyQ==@kvack.org
X-Gm-Message-State: AFuF++nbDi9c61cg7gN43jreh6L2OLAIp41dr0S+PxDwOaeTUEbbvPlM
	6a4BEa+V1WkYOplkJCTYIzi8piKb3o0GoFdiDERAdDBvrs3BzorqYXXHBGzclI9hB+1BYORSYCa
	gowbFR0OSEfOhTW7uJNSepceQoCUW+kaCJewa2d40sQ==
X-Received: by 2002:a05:6214:3189:b0:8ef:4ed2:316 with SMTP id
 6a1803df08f44-913fc89c6b1mr13626766d6.1.1790008388078; Mon, 21 Sep 2026
 09:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com> <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
In-Reply-To: <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 06:32:56 -1000
X-Gmail-Original-Message-ID: <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
X-Gm-Features: AcwNN1Wls7uTlMdzUx2NaKrVB2a8frk5ExiBQUGh6oMRZW91iPxl9mt8PiW6wP8
Message-ID: <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Kairui Song <ryncsn@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: hmogct9ch4amwzj7sb5yfueyx4ii494w
X-Rspamd-Queue-Id: B455AA000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1790008389-59577
X-HE-Meta: U2FsdGVkX19SGfUX7Qx3CXQGzpsH6bkiTrsBBS7D/SiGDMi1yv9UJPWyiCb/JFlB1iRoYCNC6Q6sjJeYtGAF8P9xaEImDAe8shlWyoaLdZ2E1Z1Sj0Y+C1ZVTcYakh4UXi4HAwGqNRU+UJtNPiEahI2w4xkqn7M67MzQMujsKWU86UReuFlKvjF9ITdOLlSJ9T4C7Hgz/TQxaCS5kbmsQ1gxugOl1aD/+91Q/t5BGiNxUP9WZAxLYOKQ7jTselQY8gEq6Q3DiD8hkdNpMqWGo95Rr33D3KYMXzKdRZiOefwejbbcgSVXAnfoFgNSkBt7z7hnftn+/ANkrYPsX3UGU7MxXgOayMEyZSgHjOA68O5Rd39HtQcUJ5JLHP4RMBfGyHhx3N0S4WkwijEcDrGXNnutiaZxxuXaheX080SzniNzXgHtK+1JA5Sz5oGP60YHGrv5jFsjGm9UzDIVV7QF6HNBQnyWnhWWntq8vc52ao1z+I1S2op7IhEaAu86nUCTwcvAbNOL3hrM4ViTaD7o5TfRSlCm442l76ehCXCjztO4bT0aPHoiUU/rJ+Ocemq/RHLpW1nLSPuuLJmLAmA1EDvRDrieWhFq1JX2PRXyMqHt/GNZN4bBt+sW0ENUrjdpcDBxRm78fuBUYYLfK6cbeWD2vEMsThKLiu5vTw7rbzN00d2ni/I7FfnKxQZHQAzuSRzdRvMopt1yXRthcXoMTIMWxMHp1UhwmboY1aiGjB8xSnIACqw307Adv+sPUVLK95+DoL18/FqEkbWPdE5HAX2cRS3g5Vf8JqisGi7z1AUHFeWl/cwVFmFQjnAQOpN7kgfHNuMyuALQyxWCTpxJj+IM3Ct72bvSbJRqKGSASoQP+QIBcjJAGXaRx0hVzEu75/etEp7l7ZfVWHJX4wpUCEs8oqNgQ0d3ItJj0zfCZ7LpYzg2vAQg6p8FoB+W8Xbe8l2mXE+9MB+UNzBnKgN
 ivEjRO8C
 XCGl6IzNsd4fNZd36uZoXsJ1xAZlS9sJBtAwtZBLF4+p6K6yZKyQbBGYGuQ2gFDOPyl7JpToxmuwBNoPj634RzL95Of9EDfsNBMyNg6pp3xfFabg2HZOFLku2UcfDgKhPV7+KAo3VuMvlE5wU+e8SnPDZUg+je+o4RUuQZNJL0cqPsf26ftAkuQ19e9bpQr1W+8CpwiPw0GV1ZjO7ju2tEiZNekqg0w1iO4iKvHfVXCkTxU5UfGbIZ+LR7itYFrZtkLOR1WdNJPoTRcCbeiESdBY2KBIFDRBUc/y94jAZsYgRBKESvd1wMewH6E2hImO6lPfWr4Y0WEqdbcnxr3ZJrARq7dz79BjS2Ax5t3KmNjgtPC8Efg1KuoVXzWUA1KMj9gFiraXLnh2o6AhYRJHQsnoJeHLMZNoHRtcFZpZPTYACrPdrstQ1zXVwbz182jhfAE/u4oKITAEZAemZFM87cNsF5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 3:27=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Mon, Sep 21, 2026 at 12:01:18PM +0200, Kairui Song wrote:
> > > First of all, the traditional swap counter has a very well-defined
> > > meaning. It is the size of the memory that, when accessed, requires a
> > > page fault. A page fault adds significant latency to memory access
> >
> > Yeah I agree on this. Swap just about makes resources not directly
> > accessible by the CPU act as RAM, whether that is storage on disk,
> > compressed memory, or a network resource, all accessed through a page
> > fault. I hope we won't make this fuzzy in the future by introducing
> > too many magics.
>
> Hm.  The counters are already fuzzy - the accounting is already doing
> two different jobs.
>
> Suppose we want to allow 24GB of logically swapped memory, backed by up
> to 8GB of compressed RAM at a 3:1 ratio, but permit only 4GB of physical
> swap.
>
> Today we have:
>   memory.swap.max  =3D ?     /* logical memory requiring a fault */
>   memory.zswap.max =3D 8 GB  /* RAM consumed by compressed data */
>
> If memory.swap.max is 4 GB, zswap stops after 4 GB of logical pages,
> despite consuming only 1.33GB of RAM.
>
> If memory.swap.max is 24 GB, zswap may reach 8GB of memory consumption,
> but the cgroup may also consume up to 24GB of physical swap instead of
> the desired 4GB limit.
>
> memory.swap.max is simply overloaded - there is no way for us to express
> both limits.
>
> Could we preserve the existing swap semantics and add a physical swap
> counter instead?
>
>   memory.swap.max  =3D 24GB  /* logical swapped memory */
>   memory.zswap.max =3D  8GB  /* compressed RAM limit */
>   memory.pswap.max =3D  4GB  /* physical storage limit */
>
> These limits would be independent and compose naturally.
>
> For a zswap-only workload where we care about RAM consumption but cannot
> predict the compression ratio:
>
>   memory.swap.max  =3D max
>   memory.zswap.max =3D 8GB
>   memory.pswap.max =3D 0
>
> For a workload that performs poorly after more than 7GB of its logical
> memory requires swap faults:
>
>   memory.swap.max  =3D 7GB   /* workload-specific latency/SLO limit */
>   memory.zswap.max =3D 8GB   /* uniform compressed-RAM allowance */
>   memory.pswap.max =3D 0     /* zswap only */
>
> In short:
>
>   memory.swap   =3D logical swap       - workload/SLO limit
>   memory.pswap  =3D physical swap      - storage limit
>   memory.zswap  =3D compressed memory  - RAM limit
>
> This would preserve the existing memory.swap semantics while allowing
> both backing resources to be constrained independently.

It sounds like you want memory.tiers have limit enforced.

I suppose it is possible. Again I want to see how people would
actually use this feature.

Chris


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A20CFDEE45
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528166B009D; Thu, 23 Apr 2026 16:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1076B009E; Thu, 23 Apr 2026 16:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3787C6B009F; Thu, 23 Apr 2026 16:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 220676B009D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:48:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD792C1E83
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:48:06 +0000 (UTC)
X-FDA: 84691007772.06.5DA8006
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D82F140004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:48:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rx89kRCS;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776977284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZDdlWnnmZL0XkbmLmxoEnk709HEQgmgR/yJgX91nRY=;
	b=i78Y81IcZ92iBB5kT1pqnlFyTeUDsMGGPlhImrsnPnbB151Ykhmlg/sQae5bCf+3ghn1Bf
	KvtAX6ANhIOrE1fYz2wPIik/2uOYMDPB7Gdc/PfeMfmRmSmoTq/s172iSYxyNH3N91yv08
	vBYh+lG0UYb/h+wk2iRLk/YDU6GL/ok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776977284; a=rsa-sha256;
	cv=none;
	b=xp3fxYv2L26K209IGOvpmnnJf9I0KqOUavDPwxOM5IR2TO2QgJP7VHOfHxw6+bsNGL2Ilf
	ATbG/2YQ6cowosmTzHyOpdpGbwFWjG2YMHh0iV6s0E4/P7S0e/Oij63UaDc5q/XpH2Cu1V
	ZZRBH6xaXvt9xUzpw554oiBxID0IbX4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rx89kRCS;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBB546111B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C69DC2BCF6
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776977283;
	bh=jZDdlWnnmZL0XkbmLmxoEnk709HEQgmgR/yJgX91nRY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Rx89kRCSlMrd7yHaiWXgQNZ6WFzc+/CKBSqW6tv6BpFT+A/XF9LFoVuRmekZJCcrW
	 PucoZ+X0h55vGSz9jfRis3+KCvMSGCNSz9d+5It5kj3mDn/0Lxh+DK6iVMDORGNcke
	 aXsxJBoQ49XvPZLLdxUiYoJ5kF2I5hTANUyf6QqSx22z9Ym8DmMOYvNwgQdbRS8v/Q
	 m8izcosAHWgz/ZY6Mc5154h2tsCRHenWgtEmselaULHpCVGDLHOTix8xjAPEy4oIZZ
	 oS79eyKyxiTPY2mWKPU3eVuO8lKJ+WF9QfF0VJEdaYEFuj/xwKjsdE6N9NL1k3Vzsk
	 16A0t+tpNvBQg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so981607766b.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:48:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+kwa1xAxpv/A/uF2dNf/ShE76S8n1yg2OIUvPLKQKsmwYp1DNqLy8RUun/sf/6IjOLRhe4HetLyA==@kvack.org
X-Gm-Message-State: AOJu0YxLX1zU4/eIe5OcKyO8bZtpuZECN+4AdDRVa8W0huak1cmM1Zhz
	lvfoQ7Tml9Ky8mQP8pKKWVuwtAqQvB67Sa3bWavsepmvuvz3BHUIcrBZK9VVPVTOynXskS8Gl6Q
	U8iypiyPEVwkSUgl0L5u7rJ7UoUeAINs=
X-Received: by 2002:a17:907:3c90:b0:bac:7f7d:2bf8 with SMTP id
 a640c23a62f3a-bac7f7d3864mr226153866b.0.1776977282033; Thu, 23 Apr 2026
 13:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
In-Reply-To: <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 23 Apr 2026 13:47:50 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
X-Gm-Features: AQROBzCGOvAuB5Pa5DHTHxdTW2aSpPlTxrehClW5Vv-d-Qe-2m8TRnW986l3LBY
Message-ID: <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9und5a88996u35icjqgktsrzimz71kg6
X-Rspam-User: 
X-Rspamd-Queue-Id: D82F140004
X-Rspamd-Server: rspam05
X-HE-Tag: 1776977284-600133
X-HE-Meta: U2FsdGVkX19Xua1E5c2Bbv9Nz2Ay2cSz6RvUUIoMRysyl4B8NrvTS/GdP3YAJ8ZQuZd+wN6XDCcXKVgahUC9Ndgzxi3FzVFWX2XqmFaufZKb2a7j15QfOpaYDSmig3O2m3vRLyuE68p0vlCEdkJqFDO0YRFuEq03ri5ouuelP0FCAJPSib2DAGazHQcXZr5nauRIGtEVFiIb7WFuoPWqpIbaXbCiUoiWQrQRY9/gJaXYO85Z58mJf7cbGmY6ZOpItXS0f3SMzduNynkMby6xZt1t+V2YDaE2akpkMVveclVyoHbbe+l1Zrxl1paPFgcZzvCclo2ofelTymewebBZOgdU2nxlpPZIMaSXn08V78TM76y0DatXgSUkFUPZ5pVL8kib6oQceDmVTBYin33SDYwvR9TkTkJMcbmPSSQ6RwX2YxKybV0LrGaJCo5ebOS0Oe64Y7HeaxBM7IoabEbDNZ08n3+Re16uZRm9e5RvqedErBGOc3A9t7ZcbxafJazYt9X/w8WiQ69y2bDmqLVzT8m024neDbdY+CdyDwddtGpHJHuXiqrMH7AWoTHLXFYO5rupL2E7yrg4GHiw7lkNZ04Z29DcFrGgcu8yMg+gPWUzqlqK3xlFnDk1hAPdxCTNLkgCwKtvMYQ0TjMqSOBrSzki6JJsLMf1Wes85bBgToy77+xpbgbUKINMKrXqVSwIvBL9aN7nLqlUzVJ/3iaOHyepUL/UKT0rDPU5JmBlGBVQwjyoR59lwo7OMtezd6xm/HRWyUoeHjND1OpfLLPzp7mNhDKn8o7jDn/EOOq7jzKxwHVps87gEn814vm2PayQzBedjBlfs2/HfE2DXo0EA6NQUk5/CH3E+RShWbIznRW2/zkxMV1VCgsv/hEF69ueAwETvdtFZG/r8qxIg7Cplm6OU5nZc9LB7hZbTo8LmTiaSvjM+f6Bsy94NT3V3YkdiDTGjOuGcDtUEFyQd8e
 tT3tfbLm
 3Iv2G8Im2Hu0Uxi8TQbxqpLlSJnUMnf6x+Fl9MLTC81Wx2NG/8pC4Mnf/eixQVCqd+Hy6viHWPhhoG5iKMAkpNyeZQl7tesiW9A696/uvjRd3m7AIC0iXwt94rukCsgaYvmWa6uLPcszq1ege60se5SFHtCXcsp/R8QFxdjkltS3a/nVH8jxxXsI1lBgpyYmrlrdf9KQ1Fw6qhdGERll+fNtVXJjp+gUHhGvQkukwov0zCfHPkXZBQSGB1M5OO/oEnMbaYSaeYKBJE3ZtCYlc5/NhKVxkT69Qo9CqTfFCdvXIhTth9llh1oYy0vT/ci0PeZY0Dq7z3frE1Ea6A90dGCTqAh+xe2ud6FrKayFNo79mHz84dIdBbn+v2ABtghqjydfIzBXmShCKkA8jlGGWOlnZ+PW9rU9GxjUHoujulNRZPH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Yes, this absolutely works. In fact, I previously posted a working RFC
> > > based on this idea. In that series, clusters are dynamically
> > > allocated, allowing the swap space to be dynamically sized
> > > (essentially infinite) while reusing all the existing infrastructure:
> > > https://lore.kernel.org/all/20260220-swap-table-p4-v1-0-104795d19815@tencent.com/
> >
> > There are a few aspects that I don't agree with in this RFC, and I think
> > Nhat and Johannes raised most of them. Mostly that I don't want to
> > expose ghost swapfiles or similar to userspace.
> >
> > I think userspace's view of swapfiles should remain the same and reflect
> > the physical swap slots. The virtual swap layer should be completely
> > transparent in this case. Userspace shouldn't need to configure it in
> > any way.
>
> That approach is definitely doable. For example, with that RFC we
> could simply drop the interface I introduced and enable it via a
> different knob, and that would be very close to it. :)
>
> Using a swapfile to represent the virtual layer externally just made
> it more flexible.

I think it makes it less flexible to be honest. Once it's exposed to
userspace there's little we can change about it, and userspace needs
to set it up.

> I agree that the RFC design was a bit confusing and
> could be improved. There is no technical difficulty in hiding it from
> userspace; it's mostly a design choice. And even if we don't use a
> swapfile to represent it internally, all the other infrastructure can
> still be reused without much modification.

Yeah that's what I was getting at. It doesn't even need to be a
swapfile in the kernel, at the very least it should be named
differently to avoid confusion with actual swapfiles.

> Using a swapfile does have its benefits, though. For example, the
> virtual layer could act as an ordinary tier following YoungJun's
> design:
> https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.park@lge.com/

Hmm I didn't look too closely at this but I don't understand how
making it a swapfile helps with tiering? If anything, I think it makes
tiering more difficult. For tiering to work, we need an
abstraction/redirection layer, such that we don't need to update the
page tables (or shmem pagecache) if we demote/promote pages. That is
exactly the use case for a virtual swap layer. The page tables point
at a virtual swap ID and the backend could change transparently (e.g.
for zswap writeback, or tiering).

If we make the virtual layer a swapfile, how do we demote/promote
without updating page tables?

IOW, I think the whole reason we want a virtual layer is to separate
the backends, which would facilitate tiering. If the virtual layer is
itself a swapfile, wouldn't it become one of the tiers?

> It also means we wouldn't need to introduce things like a new,
> virtual-specific swapoff mechanism.

We don't *need* to introduce this, at least not initially. Only if we
have a good use case for it.

> > In an ideal world, the only noticeable change from userspace is that
> > with zswap, compressed pages would stop using slots in the swapfile and
> > charging the memcg for them -- and that zswap would work even without a
> > swapfile, by just enabling it. This is admittedly a user-visible
> > behavioral change, but I am hoping that's a good one that we can live
> > with.
>
> Totally agree with the ideal end goal for zswap. just not sure if
> that's the right place to start for this usage, zswap doesn't always
> apply. For instance, we have SSDs with built-in compression,
> software-based storage stacks with built-in compression and
> deduplication, swap over RDMA, and, most notably, ZRAM users. They
> don't necessarily need zswap or a virtual layer, and the upper layer
> better be as much simplified as possible.

Right, it's not necessarily zswap at all. As I mentioned above, the
same logic applies for swap tiering. You can actually consider zswap
one of the tiers (more-or-less). If you have one swapfile (or one
tier) like the ones you mention above, the virtual layer just always
points to a single backend (e.g. the slot in the swapfile). There
might be some additional overhead, but I think it would be minimal if
we use the cluster-based approach you have been pushing to eliminate
static overhead and make it all dynamic based on actual usage.

At a high-level, if we have a single tier/swapfile, I think the only
additional overhead would be the reverse mapping from the swap slot to
the virtual swap layer, which would be 8 bytes or so for every swapped
out entry, right?

I think this was discussed before but I still wonder if we really need
a reverse mapping, if it's only to optimize swapoff then I don't think
it's a requirement. We can still scan the virtual swap layer to look
for slots to swapin. It would still be better than scanning the page
tables as we do today. But I think there were other use cases for the
reverse mapping, I just forgot what they were.


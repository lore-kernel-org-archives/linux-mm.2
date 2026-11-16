Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD34606A883
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkckWrFr
Received: by kanga.kvack.org (Postfix)
	id 8EDCC6B05C2; Mon, 16 Nov 2026 15:04:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C50D6B05C3; Mon, 16 Nov 2026 15:04:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8027B6B05C4; Mon, 16 Nov 2026 15:04:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 506376B05C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA2A8801FA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:52 +0000 (UTC)
X-FDA: 85442060424.19.B77EA4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E292D40010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkckWrFr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1O1HZxpH9G+QLlqP5hHi+3OIw9Mj+HNTrQPUqx/Be4=;
	b=Oyclns3bfPJN6MQjLN6anQgaj2FMI2hvTFuaLGTtociiTURlERD4hS94t3oNjPTinw9u5j
	Io9WkiGru5uN1ZiUWxGxGFA0CQVNDJbdLHYHtcR5tVw96b0cTNte7qVploaGZr5IERrE9K
	Ev+GGstAugxjo8lC4PJOQPcMNcOsllg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkckWrFr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859491;
	b=1MHw7LG3DRE5t2VEjLUODhXNzSm48Cs+ngxS6Dn7bCYX1uGqFDoYNNE/NZm2CUN3nd3qvm
	exo485dpk93VgyfbQPI/auDAW/xduHxVhRe9k65YQJ5DQEpsq9vWp4g6gvhW9a3/QpR8BK
	qe3mKLe31dtpGBm5JO+AmUSugCTQUUc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6782F467C9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1B61F0092C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794859489;
	bh=l1O1HZxpH9G+QLlqP5hHi+3OIw9Mj+HNTrQPUqx/Be4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BkckWrFr9tlTlp2/HgpPCsgRrHm6mXU8p99lK6aelhAkoxLvDvNuiWQziNMeGdXAj
	 +ORximax4Kex8zGBcBcLWA7p7CKV9BRI0/E6mJzfI5pYFuVb+PwdtAO/JsyonyJsW2
	 H9m1Fi9w/PsSeALr7xQ6r4VNCuGhDwQctkoUf+hQ2LeN2Non0dX2OGoMlAUF+sfoFj
	 kpV4XCB/24G1JAgcwXOpFi2PSO6i0vfEAYSHF4Y4E+aXIzKeh+z2RtfEq34pCDaTDX
	 Ono/Fq8vnf1NZz9yx+v+8za/umYNM19GASNZEwWrouJqhd9Gv94SNGqlCiEdVQHum5
	 XP0GuPlE40L1A==
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-99b49d6a5caso745274241.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEjsVzuCltKt+9F5EQvLjd/EsOJ0lcg5+GeQnU8hGMoutfEiW6D2Qvb2AMtePs7pEEIY+tk4idhCg==@kvack.org
X-Gm-Message-State: APuU4Z/Ww2Ri79QkO2eEnDe5djStpuuulZKrLvFBRLx0U2hyCBWWsxs/
	Xp23bsCOkoFIO71LmOByV0ezRaoDNjCQn5+m5QdA0fhkHAe7UB18yT5aDl2m1EgRx/snh0cSSRd
	WZklB2hrqlbkdAAsgs2YWehT0WVbdeLc=
X-Received: by 2002:a05:6102:3ec5:b0:7ce:645a:13a4 with SMTP id
 ada2fe7eead31-7d64d6f7957mr3166761137.20.1794859488504; Mon, 16 Nov 2026
 12:04:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106235904.1092712-1-tjmercier@google.com> <CABdmKX1gdOH8R6qyjw6XN5VdpAZKVR8NZ=R7Y9Db-BEhUrX-1Q@mail.gmail.com>
In-Reply-To: <CABdmKX1gdOH8R6qyjw6XN5VdpAZKVR8NZ=R7Y9Db-BEhUrX-1Q@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 04:04:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w4rNzvaOK9f4D56opW7TtUWL_6srxJoyWXWDzhfgm4ug@mail.gmail.com>
X-Gm-Features: Aa3M54q72RthsGLTye2AqvS3UPHJXHKdMiJkUDrG0cZhY05KIR-RudBK2Cdn7-Q
Message-ID: <CAGsJ_4w4rNzvaOK9f4D56opW7TtUWL_6srxJoyWXWDzhfgm4ug@mail.gmail.com>
Subject: Re: [PATCH] mm: workingset: compare shadow nodes node-wide without
 kmem accounting
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jaewon Kim <jaewon31.kim@samsung.com>, 
	Jaeseon Sim <jason.sim@samsung.com>, Youngchan Kim <ycshark.kim@samsung.com>, 
	Dmitry Skiba <dskiba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E292D40010
X-Stat-Signature: 6n7x7iipt1sxzit8kmr1jwyiin9mkeut
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794859490-606944
X-HE-Meta: U2FsdGVkX1+H37FxxUJLLWLxqNurRULptgM4ggbGpu5QCUNFxOaawJV7JR4WwYLh/HxCIVqy7r4kIadG9BS7DeM40QpXaPutu3r+LmqbW97zeDAiULy3GK4V0+WOyATe/GOPKX4a+ramOyJALvfYn/n2vT+DPtYKbCZhPA6n56OTyVnX8CSbx749MiuxaQysUuy7F5dwnnjxKyT7ksepHmHILWEKkP2+qcGpnm8SMhtHtT2DiN1wrnP724tuorerEkAzPeQNPwlL7obtCnQptGys0g8JwKDaO5YUxuz/HwIA8ihpjSccT3soMevqNANI3CsqbXhaSVCamaVR1R6mtvYZFoU64acLafXrHoO3wWuE/ii72jBXq6IfBvKLE2hOuJdwdM/wUAaDJTVtT3bh3L06bpP2UFi/TM0Pwhx/It/sE4q+vouqlp8St1FcrgZ4Uq1Oa9CS7HmaT+H6vDm+nw3OuGWmPi9J8LGq0DcMebNo2ITpxkdRDgmXSiwnHPysTz6Bs4JdqQ2l1TsxOo9kuChV4mCA9iuWOX+Q3skPwE7MNglfST1fmxaeIIOPS6YuHMWSa/2vXxANi9s2eiOAN9A9jog6MNa4ryDVUssmjcfa09Qyb4iEPr+sTD+9QcOuWbIcKAiWNwk/RB8qNtuQ/Sw5kh0BHw11qTW5aWa++C608KrCphgmL1dmefrw2ZsCJ3+jjYy4xjyhYhTmzDHz42W7vxzU8QgdE4XrNYJR4JgTISyWbXsap4z2rsoO4pL0clEJQBwPjV0vZntg5elfhYvfN1EjCGjE611dC6Fd27zPISbPBVXaLdsy7yyJF27LVEdsIDq8lDvaF/rgRIP6/kYG99rUysBqjS5CxtS5hP8x/FiM3+gqX7kVD+KgV1/E3yz/nM6F0R+iW2mH8L9qSs+jvx+mAqQhwK6WnX8o+s0irsNlCkwdPzb+6hh+2C4CrXXQxjpiuef5Kim2Jqw
 ppWnU5Cg
 OzO2mbyb8HvulANGZsi35cOK8AHhUzlLixbyvFfiKG9oyOJCvxHwiQ7rutCbhXM1lkz0d6HanDKFlXSgZbtU1nUkCYYCzy3QbG2bvLcTjgp/j38y0PHIP8eLEbC6A3cRRLzvAC366EYLLXzHnadOoguK7tWEEPydgNTo/E2W156Bxf96D/FE82e4eTk6qby+RVH81xcb3BUBhketN4sYMAX2+p0degIB5gdVX4VI/5ijCQBX742k81SKi6DQyWBXcQfUt4QDJgmjxILg5OXaLbGyrIpPRIuGUWZtalFt5Vqrm5ynnqNKfFw7PMv8xunYFqF+BbQOVjx+B+boa1Vy6qkoRo/AAme2U3w+LZadLAY16TdE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 1:40=E2=80=AFAM T.J. Mercier <tjmercier@google.com>=
 wrote:
>
> On Fri, Nov 6, 2026 at 3:59=E2=80=AFPM T.J. Mercier <tjmercier@google.com=
> wrote:
> >
> > count_shadow_nodes() limits the number of xarray nodes holding shadow
> > entries to 1/8th of the pages that could be using them. For a memcg, it
> > counts the LRU and slab pages local to that memcg.
> >
> > With kmem accounting disabled (cgroup.memory=3Dnokmem), shadow nodes ar=
e
> > not charged to any memcg and __list_lru_init() makes the shadow_nodes
> > list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
> > single list. shrinker_alloc() falls back to a non-memcg-aware shadow
> > node shrinker, which shrink_slab() only invokes for the root memcg.
> > count_shadow_nodes() therefore compares every shadow node on the NUMA
> > node against the pages local to the root memcg.
> >
> > When most tasks run in child memcgs, the root memcg only holds a small
> > fraction of all pages, so the shadow node limit derived from the root
> > memcg page count is far below the number of shadow nodes on the NUMA
> > node. Since the shrinker has seeks =3D=3D 0, every root shrink_slab() c=
all
> > trims about half of the "excess" shadow nodes. Most refault information
> > is thrown away, so refaults of recently evicted file folios are not
> > detected. Refaulted folios lose PG_workingset and the workingset_refaul=
t
> > and workingset_restore stats drop.
> >
> > In testing on devices with kmem accounting disabled, moving tasks from
> > the root memcg into per-application memcgs dropped workingset_nodes fro=
m
> > ~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
> > pgsteal_file rose by ~12%.
> >
> > When kmem accounting is disabled, compare the shadow nodes against the
> > whole NUMA node, as is done without memcg. Behavior with kmem
> > accounting enabled is unchanged.
> >
> > Cc: Jaewon Kim <jaewon31.kim@samsung.com>
> > Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
> > Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
> > Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
>
> I'm guessing there aren't many other nokmem users?
>

Out of curiosity, is `cgroup.memory=3Dnokmem` commonly used
on Android devices? If so, what's the rationale behind it?

As for the patch itself, it makes sense to me.

Reviewed-by: Barry Song <baohua@kernel.org>


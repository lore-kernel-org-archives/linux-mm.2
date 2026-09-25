Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFABC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 13:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885B56B0088; Fri, 25 Sep 2026 09:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FFE6B008A; Fri, 25 Sep 2026 09:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FE4B6B008C; Fri, 25 Sep 2026 09:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA776B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:15:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7BDA40614
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:15:37 +0000 (UTC)
X-FDA: 85252331514.17.A018A13
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1B42A0013
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:15:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/EgZses";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790342135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6UEC69eQqwCWcd1A6+Wn40mq06Knc91URsacVS3+bE=;
	b=ZLzNlFCAzD5pXYgzadKIRQa1MG4D6OTu+z2irnPdPi3oIAQz0VfoPpbPFSQjBmnkB/OupL
	vvZqRf4UVIEU1MXM9Zj2FGTaIVHuvZAszMF2UNE8YCJvzxpdmtKg3q9hbUY5LWz6Iddch0
	2WJp4Z9yaKkfzQ3o9clEmI+oXtaLjto=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T/EgZses";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790342135;
	b=yxbhLPnzNJr958UZEuzeK/R7OjdGmSV6twdz11o2jmcy3ni4PFkQS+uW2f9nbojw2aLaQw
	Mg00tRcocpDjFtPfxSZPP3NdEJPHVSD9IfW60QO90qNPIOcCyQtri/Sb1t8BuPy5MH/3Iw
	joty0sy0zW/o3Zuc2y15jfwVFTkV8WY=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccda24afso489987a91.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790342135; x=1790946935; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h6UEC69eQqwCWcd1A6+Wn40mq06Knc91URsacVS3+bE=;
        b=T/EgZsesBoS3O07KjnEQ+jfh6aVORmplzQS1NSjYhI7SsKl2CmPn196iFGWp9HclrX
         GNARkztJNyglfVS2NpgakK3hCWDgwjOfEf4lzy+5XEDMVSM3phKKVDeCtYfcGYin8eOM
         +qCg/NdlYBUP1ygpOHp7IGJ3GYDLyTpzZHTfHeBkt5BiHHPr3qasZMjFZY6s+zXDklqh
         ksqC9wQNlYA5C0WPYhfB7hmkpHkqDFtIWXkDwo4oAwbB5aaWLGWvvdHc9fH9zayKvZb9
         +aPGU2acpY/u3+98Gvt2UnaxtBUX7KNeO1FMk6O5PWEKppb0FxrDKLVkMKAlGReyQjo6
         i/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790342135; x=1790946935;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h6UEC69eQqwCWcd1A6+Wn40mq06Knc91URsacVS3+bE=;
        b=afvcgTa594FqHLZyyHCWFzRfHSuWFoNvMHvcs9iOZn4fKzmk8DyEGWhldBok+kFYml
         MJulOdE6G9dUY4lgH0tubC9E3uAvMF839RyN+4d5XjU1YRKSaudUgEkcxDSfQTn9/utq
         3EjrzfNzYhCfcWczB9ZPmYaJoa94jKyRoS+nmsFNlYScxvKUK3mB21RiMMfvd7ZjFOcm
         OfK2/MQJ/YNtv/dF89adsOubNRD1jmFOyQPMS0FiZOtb5XiaoWrq/j5A2q4bwiYNn9fA
         hbmcRaQt2hz4JyCsGJhMFfwbOVCvULmgTa7QQVyFG/zuciZLHhGnYyUZGOVHGift7qYD
         3Oug==
X-Forwarded-Encrypted: i=1; AKwUvBz4f1wia8bRrgsdZFC7zoyYU4qT4rUUFHYcjpOTiWA+zYg2p6lbv7W0YDnFZ/e+h70yhyVrEWhEzg==@kvack.org
X-Gm-Message-State: AFuF++nJaPWU3vJksPRcVqUcwEHlzhn6BcniOFs9UzgnRxooRBguI0KX
	c3WvKu5+F2fFZnuZ18MBEpBoMFgC1TsdDTfsk372MaTeaU2DPLG7TSy3
X-Gm-Gg: AYBFou1OZe8FgF0EGuGZAbJRhs5VX1y1QOrgLE31FgSJ7+pORQX86+1jkE/43QF3dSe
	TcaR2XvA+rrDRIYUfubcq6VLlg4Xa9/N+41FoaoAM2XOQFWJqIDP8QQufcUSoeHJokUAqIxk/0m
	cr0tp1mj8DaTlAdvLgj7+g2eTBqxcLIg1LJJocY5AdiDMFAJG7I+khZmwItZzwpdQ48XjoPuUMg
	qfFncBuD8A09ApWXDdvq3QDRaZGZcEDt6Q94LexcJYD0yFMEHE5DnvrcOb+VC4/Wki7mlc+mkFT
	lA5epRQoP+PYsoA2oNBqHNX+RSvPpLJWysr9N5lu8usdSYF7r8kxurmKofWp4EFIcNQke5MdxhE
	6kpMJgIqwmhvTy4O2Dt4denHscmUXPC9sL8b98UF2iUbDX52IhMt8/tVHsDyt5IKkvsheSnWKR5
	2E+8lj8eVaLeBE8sRIehaeSr3LKbaX05vtMlANi+027FEPaPweiTzX1BH8nZaC9vM+7vRS1NzGh
	2p5Ks7UclQxJ6pjrfGZn4dTYpMYG8XryClgp70Rjl4hevBH5g==
X-Received: by 2002:a17:90a:d603:b0:39e:6c68:1550 with SMTP id 98e67ed59e1d1-3a098969ba9mr4326406a91.24.1790342133557;
        Fri, 25 Sep 2026 06:15:33 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99dcd78sm4675782a91.15.2026.09.25.06.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 06:15:32 -0700 (PDT)
Date: Fri, 25 Sep 2026 21:15:17 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arUcil9kxUPiymXI@KASONG-MC4>
References: <aqQrPLPXHXiuKup0@linux.dev>
 <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
X-Rspamd-Queue-Id: C1B42A0013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qz18nt6z5ybza9tm5eznxnidcr4nqn1i
X-HE-Tag: 1790342135-707033
X-HE-Meta: U2FsdGVkX18a91IVhwy+KYm4cWT21b0+91iNQx1bJEHGog9IYcXTaCMTgOKy8/GweJxd5SyEXa22dZ8SrtPWMUR4qu6AtZI8ioyt3URsWSiaqTuUHluaT1yzCWR0sPNRlNQ4e/LpNVQJyu3zh20Jw2EbT4pj7g2xc4WwCU+fSntubghjLGiKqaauCX0H+DQpGkMwGN404V5NshC2L+62fMA1BVIh/u7yELXgTZs15v4kP5Nc7R5ml+WCYCiUx9AXSPbBkvEAkKnpHZeMrMoxcJfJaGvqFF3Jnlguuf3h4XuQS1FYy06Rz/cABan2eShKb0bQt9gzkoHnwR90r7v0+YzcriXtBRHrAejz7SiEV0jtLIsAP9y4G/ruH88jeGD2M7fT/MZbYZ5ofB9kvDH3XBw8phoLvNkDmVAKdA+bWkqQJ5Z6YIdsFnZKLOrLZMzRx2xp2Jj2uno63zk28KZv4wTRbtLR/worAF75TYt3zU+3B6HVEFyLMHXSsNgsR+rlBFuljALTiJSHe70RjJYlkHL+B1jmmOhgirnuNwv21Y3Fhbjk5iqpW7aTEJkUfQVuNWOIfnN4rzyeBt39waHRHIy+kyCFDHrdGYGO8dASeNVeUhI8omqMg4AO0WwTecdLpcIF3/uxzJGQZGnU4jYZ/PclOgBVKypttNC8p2/I6K+Wg9Yv0PjjcEZoOvzdppmWxRtJtRhjAvmVgyySZ1nNvQjOOOyadegZnBL3/QQRPlSfgcPHE29LHSNMrC5sSmH1mDBIF7gX7D8LckwlMiJZE7y4u4GN9xR7ZntEnvu31Hs1tyoQAekXQIHfOwBRYXhghjSV/iAaVI8rZwgseeCC5bW9zMUBa7H4qCGfgdqdJHZFTrig7Dwwtof2rkSRTqnvIpRzfDjZkCaBZMwtopyy/7Bllibs1XMSp43iunbEa9y9EUSfBxUd6+q0qhk778AXQJPDN0AOQYxz6dplt10
 OzeHupKi
 iui5wBmVlwg5JToaKHTkXpv4QfhoreY88cGDzyiVB8QsZIeWfWHWNPCJNiUfAhCjzUQ6e8WXMXeQFOQE+a+fFpKSVx6wkO6qpXKZbo5Q4JmRbFwPEJc6mDzIfCw8U3/NW3JWOrBfEjx/7f2/MDfxFHR10pTEKMSqjwSAkGybLJxn3h15qCAfts1HpePfhB3Af+AYvpKWnyuIoZJ3ceTx4mYS7+9xIFq/9zXk/N7CwhqK6iELYVCakGI802JzCqgasqT7fpDDe9l5CNpg/n5B8Nn60dq5+qPiHNWPMPo/O23TfiDTanCDJeHzg2qzHw5HP7J9EbgzAKtkKCulPnErltnbFCfG1T6O7+XVZ9jhzUrKiFOO9Jt7r6Sb2kGsfceV9Vw60QE/8sdZvWj1hEY7gt0RQLVgw+yvaYI4dl48LHFWyTCoNg5Q0vd+oFu1EUUyNL6GKlSRMF6X8T7JnS4E14f2maT+ppLCpNU4CdtNhfuuQXQUtH6fmO5gkeBuhhzKEye9KX/E6G56ycqivh+xGhM5NMV8Uj1m4wf7yEfulMhfnSzWl1nwMerkqmbiwi4pXTSpLtOUz32fxvj/CBZfSR6Tcag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 09:44:37PM +0100, Chris Li wrote:
> It seems you are talking about a different topic: the vswap charging issue.
> There is a golden rule that we should follow: don't break existing
> users. At least with the same persistence, this rule should apply
> universally.
> In the swap tiers discussion, the UAPI was such a big deal that we
> couldn't implement new UAPI. On the other hand here we argue for
> liberally changing user-space visible behavior.
> 
> BTW, I already shared that changing swap counter charging will break
> our and others' existing deployments.

Hi all

As I read the threads and try to clean up the requirement, just
realized that I forgot and ignored something previously. I think I can
share a few things here.

I also see that Rik mentioning that:

> It adds up anonymous, file, accounted slab, and
> (after compression) zswap memory use for a cgroup,
> and can be limited with all the usual cgroup
> limits.

That's very true, and that's also the one reason we can't
migrate some workload to zswap easily (at least yet) :D
See below.

The discussion on this can be saw two years before (I know
things are different for V2, so see below):
https://lore.kernel.org/linux-mm/CAMgjq7AYA91f4g-bknUZOMg6hApTD-X5LqjcTBN2u-Lu8pjs+w@mail.gmail.com/

An minor update for that, memsw in V1 serves pretty well (we also
modded that part and would try push to upstream if doable), and as
memsw is missing in V2, we can still workaround that using
memory.current and memory.swap.current. BUt missing the offloaded
part in memory.swap seems a problem.

First a little bit off topic, I'll be really happy if we can make
both compressed memory and swap as separate counters (I even once
tried to implement a zpool accounting to account compressed memory
in some unified way, but, well, zpool got killed before I post
that :P), or at least a way to do that, e.g. something like nokmem.
Due to our real usage:

With compressed memory staying in a separate counter (which
we manged to do that with ZRAM) the memory.current + memory.swap
(or, memsw for cgv1) could be the exactly planned or sold size of a
container, the scheduler (e.g. from k8s level) is fully aware of
the packing rate of a host based on this reading. and can make
scheduling decisions based on that. And can control it by
adjusting the limit two combined.

But with compression as a fixed part in memory.current, first the
compression rate is totally uncontrollable, both the user and us
will be fully *unaware* of how much memory they can *actually* use,
that makes the planning really awkward. memory.max stops being the
bound of what we planned or sold, anything compressed lets the raw
footprint go past it by however much the compression ratio happens
to give, so what we oversold is bounded by the workload's data and
not by anything we configure. We can substract the zswap reading
though with adaption, however it's hard to change the performance,
OOM behavior or reclaim behavior:

As you may considering compression is trading CPU time with memory,
then two things here: the user could use more memory than we expected
by burning the CPU. And, some users has a leaking application, the
application could goes super slow or experiencing high CPU usage due
to memory being compressed. They really just want to get OOM killed
in time when ever the application leaks beyound a threshold (and
yes that is a real and actually practical model for many applications).
And, we can't simply disable memory compression for them.

In many cases we just want a best effort compression to make space
for low priority tasks, and do not want ordinary containers to use
compression at the cost of lose of performance. While still has
a fixed limit as usual. So simply disable memory compression is also
not the plan, we do need compression to make place for other
applications, we just don't want their real raw usage to exceed
memory.max, and we can dynamically adjust memory.swap.max to
control the oversold part, compression or physical.

And this is not about residency, so memory.min/low don't help here:
it's about overselling, and about not leaving a container thrashing in
compress/decompress loops instead of being killed.

And if the memory compression is really fully transparent (not
doable by software), yeah, that's great as there is nothing to do
with reclaim.  But, for now, we have to go through page fault / folio
allocation / map it again. So For example, if we already have
memory.max == memory.current or under high pressure, then now
doing any read from the compressed part would need to some
require further eviction first to make place for the decompressed
new data, this is not like any kind of "real" memory, something
feels not right here.

Another thing is that I think we has been assuming that physical
swap is slower than compressed memory, which is not always true either.
They all need to be read through page fault, the page fault could
be the real blocker here rather than IO or de-compression.

I also want to separate two things that I think got bundled together
here: not requiring a physical slot behind a compressed entry, and not
charging the raw size to the swap counter. The first one is great, yeah,
and it's exactly the part we want, it's what makes compression usable
without provisioning disk. The second one is a policy change, maybe it's
not needed for the first stage, charging a cgroup for the
memories it has offloaded doesn't require any slot to exist behind them.
If someone wants to run memory compression with no disk at all,
memory.swap.max defaults to max, so that still works fine, right?

And I'm not saying "keep everything as it is forever": it is that the
raw offloaded size (the entries, whatever the backing ends up being)
should stays accounted and enforceable, and that anything which wants
to describe physical storage gets its own counter.

And I'm not asking the compression layer to have an opinion on how
much compression or ratio is too much, just think we need a sane limit
for container schedulers to sets on top of it.

And "it's opt-in so nobody breaks" doesn't really hold for us: we do
want generic compression solution, that's the whole point, so we would
be turning the knob on and losing the counter at the same time. If we
want one generic solution for memory compression, this is not opt-in.

And if we check again, currently, with upstream kernel,
using ZRAM, we have:

memory.max: control the raw usage of application.
memory.swap.current/max: controls the offloaded size/limit of a application.
With (memory.max + memory.swap.max) <= planned usage (and this is memsw).

We can keep the compressed part in memory.current of course, as already
did in upstream with ZSWAP, and things can be further adapted, we
still have:

memory.max: control the real usage of application.
memory.swap.current/max: controls the offloaded size/limit of a application.
With (memory.max - <compress memory> + memory.swap.max) <= planned usage.

Things are not too crazy, but if we lose the compressed raw size in
memory.swap, things seem to be out of control: the raw footprint can go
past memory.max by whatever the compression ratio happens to give, and
nothing bounds it in raw terms, memory.zswap.max is in compressed bytes
and zero-filled entries are not covered by anything. I can't see a very
clean offloading model for us here.  And we note, use use both kind
of deployments, pure compression and hybrid writeback.

Just for reference. Maybe a seperate counter, tiering, is a better idea
than changing the swap counter?


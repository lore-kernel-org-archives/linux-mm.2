Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D54FC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497006B0096; Fri, 11 Sep 2026 12:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E346B0098; Fri, 11 Sep 2026 12:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3850B6B0099; Fri, 11 Sep 2026 12:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1428F6B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:57:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA6811A031B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:57:50 +0000 (UTC)
X-FDA: 85202088300.02.88F7A23
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf17.hostedemail.com (Postfix) with ESMTP id B112640003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:57:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GYPp2Vak;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3G70g5xjg3njVB0Ao8zue+pNyHQGRtR9l9P4/x23hB8=;
	b=AZ/HkFm+a9VRShSCyG4FcLMjs6vPK9kOeAntDT/bD5QYoNQIdqX9ZSfJLBPoDK5gK1NMQZ
	kJqexzxLqFHUoC+Q9SePw3Qqj+j2wH8j+QBGxgx83qjvZdTN0yIbmGJ9eqz9jikLbyDGB7
	LBtYXEpvZGqAkpd0RFkJtHBMFz8wzWk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GYPp2Vak;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789145868;
	b=KpsqljYmKdBCt4gwjH4bGDFK8flmvmx7c95lO+qeulDLZ5WWrqT+Gno7HAVku3mvEb0MA/
	O8Dxc1NVdLierhf17eio6UsMwnXAiwpLNVqnE6PoZdCBvWHARhWtzr7+Zfaa8bhOwxoL3W
	RMu9cVvI0a6hCTP77ePT6Tt48CJf0mU=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b2522so67557f8f.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:57:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789145867; cv=none;
        d=google.com; s=arc-20260327;
        b=aDWTU7o4mY6FNLI1qmCN+J+Xhk8/nvZokfMPRsdkjryFH/cd/nlFz4UC0b6CDAcMtF
         idhzJIrGr3l0akTvZ4fUcJU1PfnPFZC+5rmSL1vweFZF6Ws9C7HKaLYMPUEbpgUywiy1
         vLJV9F84k2DpVNq7G0KPTrbW9etF/2flBbhoUSqcj3UNEtPYPkV3Z+aapHrsLQ/J8qI+
         oqPHNIUK0plWZTNOj4a/yWLinNwEwzsBX9mGMEUpqnFWrygX+0emWmna1EOb1Q9sCQbO
         1TPH0wciItPNukN4cGG4GXYt/JGj2zQJzHcL0IXxF63G4P2j2zjLV8tk0O4SkcpJ6LPZ
         1f4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3G70g5xjg3njVB0Ao8zue+pNyHQGRtR9l9P4/x23hB8=;
        fh=ph0qxMy5CkqIYBYcpO1Yuvjs4XCxVk/abU//JOEPbwc=;
        b=gGAwT0+fK6kMkjCjE8i39klq0tjM7u+FNHLyuhRItgZgTIVeZ094HSfrq+4j0xfTj9
         QlVhFQoCoKuXZD/seeyWTzdFLE2VW3WEEZrRNyWvuhV+9yHtYymKtAUlsx6uPLZHUeCd
         jIO1CvHiHp9cR93kPYMCUDsn1SCQ9n5IXLb8outby4yzdQFNmOGlG+Wn+wqY6gN+Hpn2
         OfnKCijhKt5fzSC/x7IxLChZLxg1lc7Fkom486W/uVgNbxnwdbNcgpxf20sA7l025RCx
         eNvO4E8uTI+ZCZIpJ/2gUsW3+sqfN8m2zey/6DsA88NFFoaW0VXWB5uNbTbV6mKYR10A
         miIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789145867; x=1789750667; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3G70g5xjg3njVB0Ao8zue+pNyHQGRtR9l9P4/x23hB8=;
        b=GYPp2VakFJBBLusym5dHemWPbiwcbhVgI9L3Zg6/D2FP0WR4p1ZtjTLSvP1dm9jE+K
         gJrmboL//qaUHd6d/83v5yMGmyu3Qr4fx6IFqgk/ysbJGy1SA5br+HJmjHEVkSGPySxL
         BqyBZ0MEH1S0vxssOUwi10QubURSXFuioxFB+dtg8p7Wvi3RpdAQUIyGkaoyRRhli3jp
         w4pkFn8oVJI72kdsuu+jolQ03ecoCd4F5A7hN4/qFW8nTEPKroZwPbPtUTErUnV1tKxq
         880Hrjwrs+vCwPzNU4HcrLfzzlZJb+91jBg4JdSvRafAcXP3vfYwW3zLyDGu7UH3ylcK
         7vmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145867; x=1789750667;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3G70g5xjg3njVB0Ao8zue+pNyHQGRtR9l9P4/x23hB8=;
        b=ieqjlnSDE2C3/4uKd0tkocQuxPO9qNs5AX8hiO0tgumZrgrMFZxpwwyF2nXOc0EKH3
         gjDLkW+bZK/DdCPnxAxd8kKI5s4GSMFvtkP5IhzY1Z4sf1bwm8KUKIyGxnqB7nOTGHEq
         hEWAzbST+Z2Ry74ihMNCHoD7xbqGtSLfuM1yF4HvURG/Qjeta04MCsbkxLvGZpNtP0H7
         QWrV0pBOkvdgXaykIjHzOzRNjfeuJOeftLOJpItcq71sHrpeP9CM824LHSI5pmdZHVjz
         6VinzpBNwmT/MIkSQc7CgdIpSuYVjpLv7IAhTkl6b/6br480DYFrIpxEblR2AHk8uE+e
         GVEg==
X-Forwarded-Encrypted: i=1; AKwUvBzBeO2OJLm783mkl5Pr7Ky8y1EBz18AoyEPQi2KuAIOFcqL+n8aa2uMZlYnVmJOB3iyCU9+KuxQeA==@kvack.org
X-Gm-Message-State: AFuF++lEZz349Ky++j66FhwQnhk22GAjnW3pxBznzbPVoxDwSADu5B15
	jtWpO4DKslv/C/xdchCEouTbryV7Issm8lpQcAqXf0HQQ9xj0f0PRX012+ebXD8rczFMhlJguJg
	9uPBnhau5ctG3h/wzV7SLpOCiNoszZ1I=
X-Gm-Gg: AYBFou2z5NJvRB+dI+Knij4kxyMK3iLSzOG04XpQp/81KHVx1sFbS/MFRrB5beQJ5t3
	EQIqtnrxxGP/6LdlOfMxdthgQBxpUZT1XkEk9hAENVOspna3R4VnOKTnypewdyjAhqTJzgEh5L8
	16vkJeO10rg4h7hYyr2QLy2OsE1tc8P+9pbG0JICpPVRcGWTsjuu1Vk6xcBmLjT3/ZQldH/XEzC
	lpaN0dBo98bPusKETbVxYdnxr0X1VasAp0ExT+ZA8tDnQ34QJ59IMAEBADQAaaJj/BFWniYKbPw
	lOjWPeELnWXpJ+kuWYXzMGol0lIneGYNnzPm1WfgQdt2ePoRHI/+j0MXpR+dW9+okFF+pYbH5JI
	jHYbCLMZd0Zo=
X-Received: by 2002:a05:6000:240b:b0:482:ea08:8c8a with SMTP id
 ffacd0b85a97d-486eb33c4f5mr10751769f8f.20.1789145866856; Fri, 11 Sep 2026
 09:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com> <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
In-Reply-To: <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 11 Sep 2026 09:57:35 -0700
X-Gm-Features: AcwNN1WArL_JByzG5ZwCWzeldSKlDzHuBhpFh51SZKu7QF3uO9ezUafnCe2ZS5c
Message-ID: <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B112640003
X-Stat-Signature: s1pr84oyowwn5a77jfp78py7ysbqb67x
X-Rspam-User: 
X-HE-Tag: 1789145868-688638
X-HE-Meta: U2FsdGVkX1+OBTa5B2MbS5lXNZY4E6sPut/6WOvI0hqJY4eO2NkhlQxgrKqnYiL7lO/PxhY90j/LkEilc7LCmT9mdukQCM2/HdUihRKS9j05jniAnbPfGlgsbd27oNKLGejezsX5OtYB59F0P8xdHF+ZoBEXf12JLKmBu79aCLgXOvgBje31WD6xCDnfVLTxWazvw2vv9TAjeoUzRM2ckFqWltOlIdzKFglMpiMD+FeGtPN9oBYWQfFR8fled/2Hyh/chH3U7DJA8ZBxOVYSErlusAk70MuHVGP5JdaMtxssrgs9erg1Zd1n2/1jtUBQsUcyt93+On7s9YNywFOIcMufxW8Qb833w7nDkV9UF6+BlcxMGxb9Iz8vC/6JGSjyhHByi2k8SLl1XAxV+0meMbbaNbMxXpU9INFUbUcCIvGA9kCZOrqnAwOGMzmVkSohA0/S6QNi+9BVnvISlaOaay2UvczeyhqXi2YejchNGZnoXALBwEmvdwl+c19jpk9vDVJJEKBm6HlR2JFq5tkDMjrCUn7krYu/S/j1Vow7GhTgP3ZD+5MCTjVkbryqyHgKTsDHzVz60u7ELQOJkrrpujZ0eoLxZ63/6rehtuBUQ8Da3Ii0G++LqUPRWzOPZ06VRrdDJvxW3KMR65fkAAEGTOuOZSQs9V42J0sc+nILhnGnArSUkrgjOGGIWsGdA2qgrpy/L7fKa+xJQvH/Ic5aF7bv0CT56oUanN7+HOutUQ7z19yXci7xDUhagZrHGH6/mMddH79jeH8fgLkxdrh3R1c3TTGLU+3SikQVJvt4DGJvqBWmF4X0Dk/Zb1ashT1jMluSTJlerLXB29qX/pHbSHn2ziO/z5yTx5CUnzh/whYFHtd+u+kJoo7Opl0kdgemsKnmiEY/C/5UNZepxVo9k6uZBe9ctU/celaWxdwfLl1/1V35pzsX35NNGD3ZJU7P2sV8LDZ4neFdlAKIhH+
 YWfL6EZN
 /gH5eXs/xNOQODJObkXAVJdfzGEzfBBiqxZlTWrZCDFo2otey8ZlEIBjEWXpvV3i1T1PJQNoWJWuyBiOWLA1GX3TkOWsTAW2gDkqXeR2WXWX899l5gDCwJOV+uzgGuUfuyS1aAv+0yNXqMhdISt869zAftpqTaNqJ+pSuZDM4u29ZcVZnH+/dIaQT8gihyxat6NWowwG+1B15WTV1soeoFAS0jqS9rgCAYalOKrwG/kKLClfsNRR92AcPgLburpDq5ZXT9QJKtGE1RQTgShXq3GXEhsCKZFOa/DasFpfzEpdoTP4xCOkIcPpsKUCU/4rj0kCr0lG+TEG0iPMob174gM6H5QlMqBHw3M/jsDs8tbazY219ZSJ66z/Aw3MquqYpQgD5J/g+HhKg3Qbc+mB5HYxIUv09HNqUJongrzVQMLp6V2gqMHrWbAAMA3/y5G48I6FYvU5u7tpU4X7akg8U+qmV00iNLAR+DPM5lB9gzhWU1M8iClpYX9YbSEeO4QIdqQcHQNjqtrl60YqbbtxTKS4egQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 9:10=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
>> >
> > >
> > > > 4. Data structure (xarray vs sparse vmalloc array). Even with xarra=
y, vswap
> > > >    is already on par with or beating baseline. I like the sparse ar=
ray
> > > >    idea, but why are we landing an optimization before the feature =
itself,
> > > >    without any A/B data showing the difference matters?
> > >
> > > This is where I'd push back a little. To be clear, my concern isn't t=
he
> > > size of the win, it's that VM_SPARSE isn't purely an optimization. It
> > > changes the cluster/metadata layout and avoids RCU conventions,
> > > could help avoid some future sleep while atomic limitations and
> > > it's tangled with the initial size issue too. So bolting it on afterw=
ards
> > > could mean rewriting the parts of vswap that touch it and could be
> > > costly some conflict in ideas. That's why I'd rather we agree on
> > > it now, not that it has to land first.
> >
> > I don't think the current code differs significantly from the existing
> > model, no?
> >
> > For the most part, RCU played quite nicely with the current swap code.
> > Practically, it's just:
> >
> > 1. If you have a reference to the swap entry, you can assume entry and
> > the cluster owning it is safe.
> >
> > 2. If you don't, then do not assume it's safe once you exit the rcu
> > read section.
> >
> > What conflicts specifically do you have in mind here :)
>
> Yeah you're right. I'm just a bit worried if that RCU period will be
> extended, and it's always better to make the convention as simple as
> possible. I'm already trying to get rid of the local lock, in that
> swap queue series, that is not so painful and still a bit troublesome
> for a few new use cases.

Completely understood. Your inquiry made me give it a double take - I
took Baoquan's code and hacked it on top of my vswap patch series, and
it seems reasonably simple :)

https://lore.kernel.org/all/20260910232704.3364879-1-nphamcs@gmail.com/

Seems to slot in quite nicely. I mean, we're converging to the *same*
architecture, just different data structure. We can switch down the
line - it just would require a lot more testing, benchmarking,
evaluating, etc. to adopt this.

> >
> > I think a lot of these wins come from the fact that the zswap's xarray
> > specifically is *really* bad in certain paths. For instance, in the
> > free path (swap_range_free() -> zswap_invalidate()), there is no
> > batching behavior, so we walk the tree from scratch for each entry
> > rather than using an xas iterator for the entire batch. That goes away
> > in the current vswap model, because the xarray manages cluster rather
> > than entries, so you just do one tree walk + one flat array walk.
>
> Right but with vswap replacing zswap, isn't the performance is still
> basically unchanged according to your test (or just a little bit
> faster)? My test still doesn't show a measurable improvement.

Yeah in my test it also improves in some cases but not others. But
FWIW, the xarray-less approach does not outperform the xarray-version
yet :) I tested with the old coupled design, only replacing xarray
with a per-cluster flat array - so basically Baoquan's design but
without the vmalloc overhead. It performs basically on par with the
xarray (where it wins, it matches xarray's wins, etc.).

And I tried my best to keep the old code intact (all the
swap_is_vswap() that Baoquan disliked was for that too haha). That
make sure physical-swapfile-only users, and those who still disable
vswap at boottime, has no overhead.

>
> > zswap and swapfile coupled, but only remove the xarray and replace it
> > with the flat array in swapfile's cluster struct. I observe the same
> > win, basically (especially on the usemem benchmark).
>
> Yeah, merging the zswap xarray into cluster should buy a lot of
> performance gain, the only concern is the cluster it self is in a
> xarray tree so if your vswap space gets huge, could that somehow
> become an issue? Zswap used a split xarray, and swap also used to have
> a 64M partition for the swap cache xarray, which is gone after the
> swap table.

Hmm not in my testing so far, both in production and synth-benchs, and
we have some pretty big swap users.

As long as the xarray does not lock us into any model, we can always
optimize further IMHO. There are several axes of scaling - another one
is raising the size of the cluster.

>
> ...
>
> > > We were also discussing the limitation of the global cluster cache in
> > > that thread, so I paused my other work for a while and posted the swa=
p
> > > queue series first. That one is orthogonal on purpose, and helps both
> > > swap tier and vswap, it reduces the overhead enough to cancel out
> > > the layering cost due to missing caching for either:
> > > https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-resend-0-6=
8d3d925578c@gmail.com/
> > > (this is V2, V1 is earlier - thanks to Lian for keeping this going!)
> >
> > Ah that! I sort of tabled that as a nice-idea-but-still-optimization :P
> >
> > I'll spend some time thinking about the design and reviewing it. In
> > the long run, it will get things more simple, but another thing that
> > should not be a blocker, correct?
>
> Right, definitely not a blocker. I think the swap queue could be
> merged after tiering and other stuff, as an optimization, just to
> demonstrate that we don't need another layer of cache; we can just use
> the devices directly without any cache above them. It will also
> deprecate plist; with the only plist rotate user is gone, we can get
> rid of a large chunk of common plist code.

Look forward to seeing more of this! It was a personal request from
me, so I appreciate that you look into this.

>
> ...
>
> > > The two interfaces aren't equivalent, xswap has its limitations, but =
a
> > > couple of xswap's properties look genuinely better to me. Runtime
> > > on/off rather than a boot parameter is better, more flexibility and
> >
> > I would also like to point out - I *do* have a runtime parameter in an
> > older version of vswap (v3). There is also not a lot of engagement
> > from folks in that version - no one expressed any interest in that
> > runtime knob in particular. Only Johannes made the case that a boot
> > parameter is superior, so I switched over. I think his reasoning makes
> > sense at the time FWIW, and it also removes the need for CONFIG_VSWAP
> > (which in turns remove a bunch of useless stubs - saving 100 LoCs), so
> > I figure folks will prefer less code and less userspace decisions :)
> >
> > v3: https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.=
com/
>
> Ah, thanks for the reminder.
>
> > Regardless - do you have a specific use case in mind where a runtime
> > knob would be useful?
>
> A boot time bool will cause real trouble for us, at least. We have
> many VMs with fixed boot images and fixed cmdlines. However, the VM
> itself is used by different customers, some are ZRAM only users, and
> quite a lot don't want any kind of compression (e.g. their data is
> dense compression is just waste of CPU) and prefer plain swap. So I do
> hope we can have a runtime tunable instead of modifying the cmdline
> and rebooting or rebuilding the base image for different cases, and we
> have already seen that a runtime toggle isn't hard at all.

Ah yeah I see. But before moving back to runtime parameter, do you
think we can come up with a heuristics for this that have does not
require userspace input? In v4, I'm doing this at folio_alloc_swap()
time:

a. If the cgroup enables zswap, then always go vswap.

b. If zswap is not available for the cgroup, then bypass vswap, and go
straight for physical swap entries. My intuition is that we are not
buying anything for these zram users, as we need a physical swap slot
anyway. Thanks to your design, both can co-exist in the system now -
that's something I actually did not envision possible in the original
version of vswap. Pretty cool eh :)

Would something like this fix it for you? ZRAM users will not get
vswap indirection overhead at all, because it would bypass vswap :)
Down the line we can revisit this decision - for e.g, if there is a
use case for vswap-on-top-of-swapfile. There might be other interface
that makes more sense.

>
> > > doesn't conflict with what vswap is trying to do. Some other of these
> > > differences involve design decisions rather than just surface knobs,
> > > and those are the parts we're stuck with once they ship.
> > >
> > > So a few current interface difference of vswap and xswap I've noticed=
 are:
> > >
> > >  - default size: somehow also tangled with VM_SPARSE, which
> > > needs an initial virtual value. It's super cheap if not zero cost
> > > (the only cost is occupying some vmalloc area, which is fine
> > > I guess?). But we still have to pick a number, could be large
> > > enough to satisfy everyone?
> >
> > 8PB? ;)
>
> Right I saw that at V1 :).
>
> I'm not sure if this is the reason that is in conflict with VM_SPARSE
> in your mind? Techically, at least for 64 bit, we can just apply the
> same limit to VM_SPARSE, for 64 bit machines we have a lot of virtual
> space to consume and that should be fine (VM_SPARSE is just the
> cluster map, which is much smaller compared to swap space).
>
> And another thing is do we really need that much in any case? Will
> things like, e.g. 64 times the physical memory (max pfn) be enough? I
> know Baoquan suggest just use the physical memory size. So that could
> be tunable, it's really easy to tune, just a number.

Potentially, but we have many users at Meta. There's a huge diversity
of machine types, workingset size, access patterns (both frequency and
file:anon split), compressibility, etc.

Tuning even just one number, but for a combinatorial explosions of
these factors, cost a lot of time and effort. This is a per-host
property, which often means big hosts with multiple services
co-located cannot decide alone.

And even if sysadmin lets users decide this value, it's very likely
they'll get that wrong (improper tuning or just copy the config from
another place), which in turns cost engineering hours to go chase that
down.

So I always lean towards as plug-and-play as possible. And as I said
earlier, it's easier to add knobs than to remove them (or ask users to
stop using them).

>
> For things like an extremely high amount of zero folio swap, I think
> remapping the zero folio it self is definately a better idea instead
> of wasting a lot of SWAP entries and metadata in the long term
>

I don't disagree here.

We tried doing that in the past, but it was slightly buggy. It might
be solvable, we just don't have the manpower to deal with this yet :(


> > >  - boot vs runtime toggle: I believe a runtime toggle is better. It
> > > can still be tuned on boot via cmdline, but it offers the extra
> > > ability to turn it on without modifying a base VM boot image or
> > > kernel.
> > >  - growth / limits: as talked above.
> > >  - charging semantics
> > >  - there could be other longterm design decisions on top of these as
> > > we talked in above.
> > >
> > > Once these settle, I think the picture will be clean. Your writeback
> > > logic and swap table integration are solid, while Baoquan's VM_SPARSE=
,
> > > previous preparation with swap ops give us a structural foundation. A
> > > clean long-term architecture means getting the core structure right,
> > > let's try not treating this as a race between series.
> >
> > I've reached out to Baoquan as well, but I figured there's value in
> > both discussions in big and small groups, and especially since there's
> > a chance some of us might not be coming to LPC. Let's see what we come
> > up with.
>
> I'll be there this year if nothing goes wrong :), I hope we can come
> up with something.

I'm excited to see you and the rest of the swap cabal too :)


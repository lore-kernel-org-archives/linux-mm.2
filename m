Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E100CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109A0900251; Fri, 15 Aug 2025 11:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E21890024B; Fri, 15 Aug 2025 11:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E2C900251; Fri, 15 Aug 2025 11:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1E7890024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:10:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57AE814012B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:10:25 +0000 (UTC)
X-FDA: 83779328010.10.8D5BA50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6613740003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:10:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJNyW0os;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755270623; a=rsa-sha256;
	cv=none;
	b=uGlhyyGauuXXZm/TwyKJkL9UMpvltSw3XVk9WNYVWjiC2jdkfi1+Fh7t9H99Cllndcf8N1
	ZN4i0/z/LkEcGSz8mJVuWzOKrr6MtgAt5MjDr4kF4fHxXMOxswFbAqwxxu43UX10YMcaKe
	vnGfddDMFZKD0NGxil6BF1oSirtESB8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJNyW0os;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755270623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPVsKPeicanKuWIsOH7c0PREAW8FxRcmf8EIQ7kymMU=;
	b=inwbxTie5TpRBkF4jpt4Aoi7if7N44rofiK3fuyha5kbRh+oCDPtiWNjn7U5SIi91vZHk4
	+BPM9pVo9GReSv23p44iwlcZ96jHKIFdKZRoiHzTcHEhNvfp/TyD0zPn2zaKugknGCUbmO
	HI6JTjODxBhINjvolTnIq80hIob5ZtM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 102C646117
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9653C4CEFC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755270621;
	bh=fGDwaVSvPH8pm2BAhxS+J5h/sgd3Il31C8JSmXIzOUc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XJNyW0os+xxrhkJvYpZsokPkFKsGLhk47WqtFAIrqesvSAaZr18FTX3x6QBLz1+jn
	 cpQoPNPcJFlJwzjxvlBpGpE6e63WDAlg1CdXqQiwx9tUu+neTcZ4wQqO+8J3Zkvlmf
	 5rB+oPsYATfeLP9t/A6HfqGlhgFrvNbwnKgMjeEk+68xPqMrAT+EGzFZY35vzrGs2r
	 pRtMVKRLedR7oYImdff6nJAN/UbYgmluYC9b8PZ+llFIH9/1sSbnSx5+6VkC/3QG1M
	 H83CuPaY2fuJCAgEjcsP6SVLPbJZ9D24jJ7OEclcDmPk5DrmPd6XEZKk0wsbYEecDP
	 ESCY4XMCYCEyg==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so61665e9.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:10:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXZI9sav+F4Jy59GtoOpeSnt9uOPWzC7k2ELQN+f2+pufFRsgpCg1rdy0z+/4qGFWZ7xPWl9C+p2g==@kvack.org
X-Gm-Message-State: AOJu0YyjvhoJ8Cvm8AuKaGHE87TTzF7bt1RaLyctIbYan2KOgw9d3Se2
	RElBk9r0cfniZtEsmUvhrE/0L+GziAmBgJgHId6MDhjzdvOJ1fSo84bs2GMhHZETrRuQG9AemvT
	mG7l47Ps68MrhN1K+ny5zVSPJjd+kRTTjNn1mpzjc
X-Google-Smtp-Source: AGHT+IG/Z8MebvAbTWGT9RmBQgvG1DLMFgUD0Xtc1EusOb89eQmpS0MfrZue4XkJq0FF4+vgGgs58TCUtMWhT5S+eqQ=
X-Received: by 2002:a05:600c:18a3:b0:439:8f59:2c56 with SMTP id
 5b1f17b1804b1-45a20980c41mr1461135e9.2.1755270620316; Fri, 15 Aug 2025
 08:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com> <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
 <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330> <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
 <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
In-Reply-To: <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 Aug 2025 08:10:09 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
X-Gm-Features: Ac12FXxaQMgJCxryg4vXQEsqpIxPtgndj7TaEMxwJoTPbnI-r8lKXY393MbSlPo
Message-ID: <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: YoungJun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, kasong@tencent.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6613740003
X-Stat-Signature: e13g1h9z4a4ebq8t58ynk5n74w6831xj
X-Rspam-User: 
X-HE-Tag: 1755270623-123203
X-HE-Meta: U2FsdGVkX1/i2UUqIf3VhxhdmQ5wvjnn+Jn0XWE+QTUcTf4YjIYZ9IUX22goBDZ0GNo2lQsHzQX88xZ2iDjJoWAjuEnsW59WNDjXJg9RpqLcrWDTC9SM2Wj/rxtVUX4uBdy3txYmiUYK+s5rnVuc1wef1QkwV/uPsMXw6TpEpAddTcH3VP+VZa/dd9CrlB+ZdtwrX2hAx54I7gNuL8cOLwdj68Sd0mRWtxNkHoCBg2XGpitqtwIfKp1fh/OhinZMHLf93LUU7aTLeuZ+LB1me8UsAFnKbkXj7hHMkAV0Jfhoc+sFH4FVXsm/UeC2QTe2R3+ynj/uU+ZDzeScOBtZ3qu0fe1DSmouuTSqW4c91C64Bubsswy+OdVia36szFBu4HzNBrApkmp2pmxx9v3+nXdcCv4kmdJuIfJQu0W7aiHFQmswhjPMH7ZMuEYophWygWE82QhNO6GEk0Tet7sH/X+nXCjMFCrHfA2S2tzKbGnbXslFJq02yS3y5d0RY97RIf77xpXb2cy0NQJPC884NdiYD3Go45qPtCCiLnCGxTmebjzrkjxlNcnamYOUXkImMwbuS7y1Gu8r7wTXoxoaIrPTRzs2C05Tcce6P59w0t4WYb7KzcyyLRjDQEH61qxL29YVRJRW850KoZpeb8A1qIBIhFxgtQxPeo+AdOQWl260X5MIMyRy561HvA94X5h+E+HZwSnNNX/m2T01sb4OLMKHfX54+8wPaqwWu9n2cYZR8HiePk7mH/k0KGWpTJ07okkjbypnmDL3Yo8hZR0byvGnn8uIegkBZt2m5hr7eOcWm4xqYNcO+g7rSeZ1j/UlW+Oqr6nA/yf9251kfX8wDV/g8kwtJyCjtkQTb9lQ/FXm+ZKYDdnEILpEhzZLET5Om3tXg/foLP/uZvulZjD6u5vcOQ9rszH2qzbAWJ+0dPZ6uPWHq7EXfJQAvE5GSKCtsMxYN90HtbZpSZc72yX
 zNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal and YoungJun,

I am sorry for the late reply. I have briefly read through the patches
series the overall impression:
1)  Priority is not the best way to select which swap file to use per cgrou=
p.
The priority is assigned to one device, it is a per swap file local
change. The effect you want to see is actually a global one, how this
swap device compares to other devices. You actually want  a list at
the end result. Adjusting per swap file priority is backwards. A lot
of unnecessary usage complexity and code complexity come from that.
2)  This series is too complicated for what it does.

I have a similar idea, "swap.tiers," first mentioned earlier here:
https://lore.kernel.org/linux-mm/CAF8kJuNFtejEtjQHg5UBGduvFNn3AaGn4ffyoOrEn=
XfHpx6Ubg@mail.gmail.com/

I will outline the line in more detail in the last part of my reply.

BTW, YoungJun and Michal, do you have the per cgroup swap file control
proposal for this year's LPC? If you want to, I am happy to work with
you on the swap tiers topic as a secondary. I probably don't have the
time to do it as a primary.

On Thu, Aug 14, 2025 at 7:03=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Wed, Jul 23, 2025 at 03:41:47AM +0900, YoungJun Park <youngjun.park@lg=
e.com> wrote:
> >
> > After thinking through these tradeoffs, I'm inclined to think that
> > preserving the NUMA autobind option might be the better path forward.
> > What are your thoughts on this?

The swap allocator has gone through a complete rewrite. We need to
revisit whether the NUMA autobinding thing is still beneficial in the
new swap allocator. We need more data points. Personally I would like
to decouple the NUMA to the swap device. If the swap device needs more
sharding, we can do more sharding without NUMA nodes. Using NUMA nodes
is just one way of sharding. Should not be the only way to do
sharding. Coupling the swap device with NUMA nodes makes things really
complicated. It would need a lot of performance difference to justify
that kind of complexity.

> > Thank you again for your helpful feedback.
>
> Let me share my mental model in order to help forming the design.
>
> I find these per-cgroup swap priorities similar to cpuset -- instead of
> having a configured cpumask (bitmask) for each cgroup, you have
> weight-mask for individual swap devices (or distribution over the
> devices, I hope it's not too big deviation from priority ranking).

+1. The swap tiers I have in mind is very close to what you describe

> Then you have the hierarchy, so you need a method how to combine
> child+parent masks (or global/root) to obtain effective weight-mask (and
> effective ranking) for each cgroup.

Yes, swap tiers has a hierarchy module story as well. Will talk about
that in a later part of the email.

>
> Furthermore, there's the NUMA autobinding which adds another weight-mask
> to the game but this time it's not configured but it depends on "who is
> asking". (Tasks running on node N would have autobind shifted towards
> devices associated to node N. Is that how autobinding works?)

Again, I really wish the swap file selection decouples from the NUMA nodes.

> From the hierarchy point of view, you have to compound weight-masks in
> top-down preference (so that higher cgroups can override lower) and
> autobind weight-mask that is only conceivable at the very bottom
> (not a cgroup but depending on the task's NUMA placement).

I want to abandon weight adjusting, focus on opt in or out.

> There I see conflict between the ends a tad. I think the attempted
> reconciliation was to allow emptiness of a single slot in the

I think adjusting a single swap file to impact the relative order is backwa=
rds.

> weight-mask but it may not be practical for the compounding (that's why
> you came up with the four variants). So another option would be to allow
> whole weight-mask being empty (or uniform) so that it'd be identity in
> the compounding operation.
> The conflict exists also in the current non-percg priorities -- there
> are the global priorities and autobind priorities. IIUC, the global
> level either defines a weight (user prio) or it is empty (defer to NUMA
> autobinding).
>
> [I leveled rankings and weight-masks of devices but I left a loophole of
> how the empty slots in the latter would be converted to (and from)
> rankings. This e-mail is already too long.]

OK. I want to abandon the weight-adjustment approach. Here I outline
the swap tiers idea as follows. I can probably start a new thread for
that later.

1) No per cgroup swap priority adjustment. The swap file priority is
global to the system.
Per cgroup swap file ordering adjustment is bad from the LRU point of
view. We should make the swap file ordering matching to the swap
device service performance. Fast swap tier zram, zswap store hotter
data, slower tier hard drive store colder data.  SSD in between. It is
important to maintain the fast slow tier match to the hot cold LRU
ordering.

2) There is a simple mapping of global swap tier names into priority range
The name itself is customizable.
e.g. 100+ is the "compress_ram" tier. 50-99 is the "SSD" tier, 0-55 is
the "hdd" tier.
The detailed mechanization and API is TBD.
The end result is a simple tier name lookup will get the priority range.
By default all swap tiers are available for global usage without
cgroup. That matches the current global swap on behavior.

3) Each cgroup will have "swap.tiers" (name TBD) to opt in/out of the tier.
It is a list of tiers including the default tier who shall not be named.

Here are a few examples:
e.g. consider the following cgroup hierarchy a/b/c/d, a as the first
level cgroup.
a/swap.tiers: "- +compress_ram"
it means who shall not be named is set to opt out,  optin in
compress_ram only, no ssd, no hard.
Who shall not be named, if specified, has to be the first one listed
in the "swap.tiers".

a/b/swap.tiers: "+ssd"
For b cgroup, who shall not be named is not specified, the tier is
appended to the parent "a/swap.tiers". The effective "a/b/swap.tiers"
become "- +compress_ram +ssd"
a/b can use both zswap and ssd.

Every time the who shall not be named is changed, it can drop the
parent swap.tiers chain, starting from scratch.

a/b/c/swap.tiers: "-"

For c, it turns off all swap. The effective "a/b/c/swap.tiers" become
"- +compress_ram +ssd -" which simplify as "-", because the second "-"
overwrites all previous optin/optout results.
In other words, if the current cgroup does not specify the who shall
not be named, it will walk the parent chain until it does. The global
"/" for non cgroup is on.

a/b/c/d/swap.tiers: "- +hdd"
For d, only hdd swap, nothing else.

More example:
 "- +ssd +hdd -ssd" will simplify to: "- +hdd", which means hdd only.
 "+ -hdd": No hdd for you! Use everything else.

Let me know what you think about the above "swap.tiers"(name TBD) proposal.

Chris


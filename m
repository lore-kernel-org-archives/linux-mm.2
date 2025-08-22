Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0369CCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 16:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E41844014A; Fri, 22 Aug 2025 12:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB638E009D; Fri, 22 Aug 2025 12:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D12B44014A; Fri, 22 Aug 2025 12:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 081748E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:48:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C35E01DBCE2
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:48:48 +0000 (UTC)
X-FDA: 83804977536.03.1E1D256
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf25.hostedemail.com (Postfix) with ESMTP id D6CE2A0007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:48:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgyipajJ;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755881326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQTfNoEQ1b01mdo+yJDeY23k4M6Ll38SMkv+zOuhP/8=;
	b=VCjXiKyDp8SyXiFWuyDgN2/+XEQ+8dHO20bjB1FD9VnsX6FdNi7ilEg7HwrjhhXZikX2HP
	5Qquk7Pl63R7OyrSKzLzFxvbWRrTTPFpmx07LPVofyfKtSMAl9sNTEoIBfhvabuS+MAAUP
	KUY7l3PerhifcrY2qHawdGdhIikaQto=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgyipajJ;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755881326; a=rsa-sha256;
	cv=none;
	b=GnLhUmd7Jao9uG0qOfGBFCikfk/BTeoLmPwsoQEFkF2ZOBhK2iSdH0CkeNcDP9O9QPGUuN
	e6CfG5YSEwpqppQ7zRu7+4wASLUFyIH1GaChRd8+fho7/6tLfzgrmQyB5lHbxzeJqMXNxU
	f+N+i6eWrLNcxFrsYpZ5X+CJW1vdU1Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 1E08AA58AE5
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7DFC116B1
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755881325;
	bh=TYQIQp1NujBukq4LQ/crsbFhjOljGgADOcjgjYHCdAM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TgyipajJ2g8nbnedK0RV54hnypJ3DaUalN56+ZaiY0hXPaOPINmqflvVqqA6Ade8A
	 42/Pzaf9zZoLZOtkhVdYjiopjSXHiHsLvT1kKoheRpc8UbDEmqBzeT6voLYzeTxprf
	 FPLIL2j+W9LfErkKxV44We00MXb3LWMwwozQZ6B8VrmPki6m0eYV/nt4sxw4Z46SyD
	 X33XlOikFYMJg9xt6Vh4wVV5bjM52KrM/H4yrwLbBhm7DsX3J+TFros4HZtLw/SR4a
	 QPhCKjY8odgbFwOUI6ttH9vZkSFA1CcDhUc/f8Hx/dOM2VwAH4aZhmvIuQ4LCyQS6F
	 i/5IvaIYhEPGA==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so705e9.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUcvvTGMZPiVP1vZ+maV1GZH6QlMhYJbomuIEULiqXJ3Nk3dJvlrgByb+94YTThdCWxJtixYfLcJg==@kvack.org
X-Gm-Message-State: AOJu0YwzMzsGh7Iktzi3d+faEaYqxw9bpz9Z4Wu8b7BtnsccUp2lBXAT
	Sbn7YBcFxu/3+SMrDhoo2WwiE2aB7iQsXG7AFkE5Y2FcEyRvYWE4EWCemkZt9cHbDhip9Ln8H+e
	7qz778f7fyem6M3Qe21SQfaTRvmRPTrpI3H1PqITx
X-Google-Smtp-Source: AGHT+IEQGkNZ+YIeD4Ab6wByDF43LtG+ePKPKlcWbnTXJJTA28r5qb3dOjGqLRBrrTV3SgP9gvvGQquS1jK3YV4hBNQ=
X-Received: by 2002:a05:600c:4aa9:b0:456:4607:b193 with SMTP id
 5b1f17b1804b1-45b52128a6emr1291465e9.7.1755881324322; Fri, 22 Aug 2025
 09:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330> <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
 <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
 <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
 <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330> <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
 <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330> <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
 <aKXeLCr9DgQ2YfCq@yjaykim-PowerEdge-T330> <CAF8kJuM4f2W6w29VcHY5mgXVMYmTF4yORKaFky6bCjS1xRek9Q@mail.gmail.com>
 <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330>
In-Reply-To: <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 22 Aug 2025 09:48:33 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
X-Gm-Features: Ac12FXwV8Pu536bYTbqPyLV4-nVlSFp8jYXrfNMlVJBoyvYT3NOOf-bufZ6u1ZI
Message-ID: <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
To: YoungJun Park <youngjun.park@lge.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D6CE2A0007
X-Stat-Signature: ot3abnfq5574rmzzynsawygx83xdw9z6
X-Rspam-User: 
X-HE-Tag: 1755881326-294997
X-HE-Meta: U2FsdGVkX1+ETcTSFZRtaEdvQhTxJk6h8oSZJgFY/sgq3iR3+k9k0fRmfz7Wjw6RCXwSuBZGpXVFpMUfFkz2xvPbtRqmOMgOOgXv7DoDrU8sqhB6IQ/oK5Hf9tmXqs4EOnzC+w1EI0w90fepswqbzQTUUkp+aOauCxCwi0IEwiugBNUSVxOlSsAgozHURvgrMltxjE4aRJvbugA/svqgI8foy0fp1rdtTSg9IPl8t4uo2wlvwllD0iQltg6Akb92wE1LKNW1FFbM+bPQmHE1zgGsdsCb9dHn0VDQ2gGpL9UT0hruUOefGD7gv14hc1xsrvoNdIhtVq47qZQql/hxKZTmftPGQEUGNOOQSO1HdHCAvrZklTJrG2M2BarXMKIXpK3ttPZ12sSYKTrD7A8h7FyqhGasCsUy3tt8fJdZhcCcCh1NbJeplIkIM6ti4XRTibuxWmi8Ybq6FRauJfwiSIG5DV9QT3E5fwD8aOMmKGqye2N8bTQxRN5dlfUsL8REovShXv8RZxTiZP3DCz842b1OXNdtMSTB3Z0wy5lPFfz7O2Ap7SPz9cqRO/kve9Y6zDOGlM4UldNVtgiEjapiVPaBQINAkTpv+ojl0kQCjX1o9E6rBSBqNS9uEvu3qLkTTazGfZW5S8Bpifjm6irXln2aB3Qxc6MCDgfmbb+hI0vvKoo3tibLjF3DConebazj1105qYY010giSSrdB3vyOI4NCu910Ej55iS3SWbNPEr2wletJt+wgDzI9Yieh5XV2O2CVMR6sHS6xCv/HZWlSUwJ++F4Ho1++TgdhKYNuL04FSUdLasqroBUDAUqnTnfUhMTnls04Hprf1Qloc09EsMJAPjktAZd5EBqRYaQBwMRjJ9R/yXWZr3ENJli0qHc4ZySFWXPN7S4paN4QB4YFJj63Pez868lQ6E/sG61rCVH7kjugoBg5IibfF4cazVw+L+R5QOnXERN4Y3zXh6
 P3KjJDSA
 yGVz/CIExI9ZA2hjPSPd4dh4haxwd+KRYUfcOLS8mCkkxzXEg8NrhwrnIF2Fvczg5bR39MyWZeERY9NZ5h5+Bic7tLCbOYnRg2zgTLo0xEzbSOo8gawTTbUFO0q8PDAyZOBoiTpIRhHSAybMakAgU8Qm3uoPMEa6C+Qwq2ORRAx1gpLOtebx9eGrR6XDuAt9zIwWm8kElO/zRsSL9oebT6Eph0t43LNJ6ymKZ+5JohDEemv4xnrtJfunafLrgp6Cm49nhH0qDzXvmNCVhJwrb6WJdg23TvCVrVqtoENzy2c3beRHQaNLm5qCXmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:45=E2=80=AFPM YoungJun Park <youngjun.park@lge.c=
om> wrote:
>
> I still believe that the priority based approach has more flexibility,
> and can cover more usage scenarios. That opinion has not changed.

I agree with you on that. It is more flexible that way, no question about i=
t.

I am open to considering your usage scenarios and revisit the
swap.tiers limitation. I just haven't seen the real usage scenario
yet.

> However, from this discussion I came to clearly understand and agree on
> three points:
>
> 1. The swap.tier idea can be implemented in a much simpler way, and
> 2. It can cover the most important use cases I initially needed, as well
>    as common performance scenarios, without causing LRU inversion.
Glad we are aligned on this.

> 3. The really really needed usage scenario of arbitrary ordering does not=
 exist.
> the usage scenario I suggest is imaginary.(just has possibility)
Wow, that is surprise for me to see that from you. I was expecting
some very complex or special usage case demand on the arbitrary
ordering. If it is just an imaginary usage scenario, I am very glad we
did not pay the price of extra complexity for imaginary usage.

> I have also considered the situation where I might need to revisit my
> original idea in the future. I believe this would still be manageable
> within the swap.tier framework. For example:

Sure, having an incremental improvement is a good thing. We can always
come back and revisit if the reasoning for the previous decision is
still valid or not.

> * If after swap.tier is merged, an arbitrate ordering use case arises
>   (which you do not consider concrete), it could be solved by allowing
>   cgroups to remap the tier order individually.

Ack.

> * If reviewers later decide to go back to the priority based direction,
>   I think it will still be possible. By then, much of the work would
>   already be done in patch v2, so switching back would not be
>   impossible.

I really doubt that we need to get back to the pure priority approach.

> And also, since I highly respect you for long-time contributions and
> deep thinking in the swap layer, I decided to move the idea forward
> based on swap.tier.

Thank you. I really appreciate you taking the feedback with flexibility.

> For now, I would like to share the first major direction change I am
> considering, and get feedback on how to proceed. If you think this path
> is promising, please advise whether I should continue as patch v2, or
> send a new RFC series or new patch series.
>
> -----------------------------------------------------------------------
> 1. Interface
> -----------------------------------------------------------------------
>
> In the initial thread you replied with the following examples:
>
> > Here are a few examples:
> > e.g. consider the following cgroup hierarchy a/b/c/d, a as the first
> > level cgroup.
> > a/swap.tiers: "- +compress_ram"
> > it means who shall not be named is set to opt out, optin in
> > compress_ram only, no ssd, no hard.
> > Who shall not be named, if specified, has to be the first one listed
> > in the "swap.tiers".
> >
> > a/b/swap.tiers: "+ssd"
> > For b cgroup, who shall not be named is not specified, the tier is
> > appended to the parent "a/swap.tiers". The effective "a/b/swap.tiers"
> > become "- +compress_ram +ssd"
> > a/b can use both zswap and ssd.
> >
> > Every time the who shall not be named is changed, it can drop the
> > parent swap.tiers chain, starting from scratch.
> >
> > a/b/c/swap.tiers: "-"
> >
> > For c, it turns off all swap. The effective "a/b/c/swap.tiers" become
> > "- +compress_ram +ssd -" which simplify as "-", because the second "-"
> > overwrites all previous optin/optout results.
> > In other words, if the current cgroup does not specify the who shall
> > not be named, it will walk the parent chain until it does. The global
> > "/" for non cgroup is on.
> >
> > a/b/c/d/swap.tiers: "- +hdd"
> > For d, only hdd swap, nothing else.
> >
> > More example:
> > "- +ssd +hdd -ssd" will simplify to: "- +hdd", which means hdd only.
> > "+ -hdd": No hdd for you! Use everything else.
> >
> > Let me know what you think about the above "swap.tiers"(name TBD)
> > proposal.
>
> My opinion is that instead of mapping priority into named concepts, it
> may be simpler to represent it as plain integers.

In my mind, the tier name is just a look up to a bit in the bit mask.
Give it a name so it is easier to distinguish with the other number
e.g. priority number.

> (The integers are assigned in sequential order, as explained in the follo=
wing reply.)
> This would make the interface almost identical to the cpuset style sugges=
ted by Koutn=C3=BD.
>
> For example:
>
>   echo 1-8,9-10 > a/swap.tier   # parent allows tier range 1=E2=80=938 an=
d 9-10

swap.tiers, it can have more than one tier.

How do you express the default tier who shall not name? There are
actually 3 states associated with default. It is not binary.
1) default not specified: look up parent chain for default.
2) default specified as on. Override parent default.
3) default specified as off. Override parent default.

e.g. "- +zswap +ssd" means default off, allow zswap and sdd tiers.

>   echo 1-4,9    > a/b/swap.tier # child uses tier 1-4 and 9 within parent=
's range
>   echo 20   > a/b/swap.tier # invalid: parent only allowed 1-8 and 9-10

How are you going to store the list of ranges? Just  a bitmask integer
or a list?
I feel the tier name is more readable. The number to which actual
device mapping is non trivial to track for humans.
Adding a name to a tier object is trivial. Using the name is more convenien=
t.
We might be able to support both if we make up a rule that tier names
can't be pure numbers.

I want to add another usage case into consideration. The swap.tiers
does not have to be per cgroup. It can be per VMA. We can extend the
"madvise" syscall so the user space can advise to the kernel, I only
want this memory  range which contains my private key swap to zswap,
not hdd. So that if there is an unexpected power off event,  my
private key will not end up in the hdd. In RAM or zswap is fine
because they will be gone when power off.
>
> named concepts can be dealt with by some userland based software solution=
.
> kernel just gives simple integer mapping concept.
> userland software can abstract it as a "named" tier to user.

The kernel will need to manage the tier object anyway, which range it
covers, having a name there is trivial. I consider it just convenient
for system admins. Pure tier number map to another priority number is
a bit cryptic.

> Regarding the mapping of names to ranges, as you also mentioned:
>
> > There is a simple mapping of global swap tier names into priority
> > range
> > The name itself is customizable.
> > e.g. 100+ is the "compress_ram" tier. 50-99 is the "SSD" tier,
> > 0-55 is the "hdd" tier.
> > The detailed mechanization and API is TBD.
> > The end result is a simple tier name lookup will get the priority
> > range.
> > By default all swap tiers are available for global usage without
> > cgroup. That matches the current global swap on behavior.
>
> One idea would be to provide a /proc/swaptier interface:

Maybe stay away from  '/proc'. Maybe some thing like "/sys/kernel/mm/swap"
>
>   echo "100 40" > /proc/swaptier
>
> This would mean:
> * >=3D100 : tier 1
> * 40=E2=80=9399 : tier 2
> * <40   : tier 3
>
> How do you feel about this approach?
Sounds fine. Maybe we can have
"ssd:100 zswap:40 hdd" for the same thing but give a name to the tier
as well.You can still reference the tier by numbers.

>
> -----------------------------------------------------------------------
> 2. NUMA autobind
> -----------------------------------------------------------------------
>
> If NUMA autobind is in use, perhaps it is best to simply disallow
> swaptier settings. I expect workloads depending on autobind would rely
> on it globally, rather than per-cgroup. Therefore, when a negative
> priority is present, tier grouping could reject the configuration.

Can you elaborate on that. Just brainstorming, can we keep the
swap.tiers and assign NUMA autobind range to tier as well? It is just
negative ranges, we can assign negative ranges to say "NUMA" tier.
Then if the swap.tiers contain "ssd NUMA" then it is as if the system
only configures ssd and numa globally. Frankly I don't think the NUMA
autobind swap matters any more in the new swap allocator. It can also
make up rules that if swap.tiers was used, no NUMA autobinds for that
cgroup.

>
> -----------------------------------------------------------------------
> 3. Implementation
> -----------------------------------------------------------------------
>
> My initial thought is to implement a simple bitmask check. That is, in
> the slow swap path, check whether the cgroup has selected the given
> tier. This is simple, but I worry it might lose the optimization of the
> current priority list, where devices are dynamically tracked as they
> become available or unavailable.
>
> So perhaps a better design is to make swap tier an object, and have
> each cgroup traverse only the priority list of the tiers it selected. I
> would like feedback on whether this design makes sense.

I feel that that has the risk of  premature optimization. I suggest
just going with the simplest bitmask check first then optimize as
follow up when needed. The bitmask check should still work with the
dynamic lists of swap devices but I doubt how much of a difference
that NUMA autobind makes now.

Chris


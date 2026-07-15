Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F89FC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2176F6B00A1; Wed, 15 Jul 2026 17:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFD46B00A2; Wed, 15 Jul 2026 17:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CA86B00A3; Wed, 15 Jul 2026 17:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D40D06B00A1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:21:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C4D914030A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:21:01 +0000 (UTC)
X-FDA: 84992281122.20.3329274
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 70DE380004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdQNywBl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HeGlrD8Ps0r+6IpCT3XTVXqJwpSuRwh0o0cHslUZZM=;
	b=moOSrDzJ+CGr/T62BjNrm7m07SOTxwGMpfjzdsly/YpI6biAE9YXDpbogWyWfISa3ljRts
	cYX6/20nxHowNSqVpYgMTQMYGNqTf42PTiAp6It/CkcOvU2Vk3f+7Su3Rf6B8AVN4QmeOJ
	RmgaUoNj5loE8Db0Iihc/DoMi43e+/Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdQNywBl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150459;
	b=2cDFrgCt/oW0VzT0l3XgRbopWF1i09702wUpzue/Qo3gM5XJJu4urOccKlMiPTFdBje9uX
	qOWNHDOD0OaL+2n8616OVhDcCprUP0QvvlsKJi1aT6Zqu05MmtH1v465+ZzU41QyPkWLl4
	i/UcmAMMtxqteVhEs21dM0RIrvI4OOY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89CF643BF1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E571F00ADB
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784150458;
	bh=8HeGlrD8Ps0r+6IpCT3XTVXqJwpSuRwh0o0cHslUZZM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KdQNywBlJnNiarHdP8TjljFYW589E2ba9rqb6R6rkzQC+Wm69feEMnyQ5KBUFDwLw
	 L2fZZxBCJ1W4Up34HL9N00RUjJk3BN2nYAtH6czeAuNDIpyeGSFefvtpRGnytw2pan
	 SdEyzu4Irdc5iFejraoa4pYcy+sSb4iwDs+NuSTmJGyFMtBGgQGMMWz2wG/kU2mo8T
	 MD7W+CBLD5XWGPjjd9tevk2C3/+g9eg0hURj/bZblOPMYS5SLuYV9JH2H+G91jm+QP
	 lrh/AsvRhsFwYZzNMC8FAAkdg4rkvHAs0W1vjwjMy989iuVJ+Efu3vqsE8dDDgVqRB
	 HhPH/cRy3a29w==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81e9d8f3289so36262917b3.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpxYQy6deVO6eci7ZaZVn5I5HPpHTduWG9RejnJZ1OkdURZdR6Ff64UftfBwmdO2grYvVk3RkdKEQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/RnY+7xnhrs3qBo8PKk9r8S5hr4H/GUtcbs6NbBS0Efq0AWWS
	5/kByzCDq5HxcVQd/DltxgC1ob08h6q85ErgHfhdL1usbxsrSuOPtPdUDngvVnUs6YzAwgpsEDG
	4Br3HUK2df5Kn6OWQQwPQTrbGgBcYuM7cfI0N06AOGQ==
X-Received: by 2002:a05:690c:610e:b0:80c:16ad:2f10 with SMTP id
 00721157ae682-81ecfa39be6mr37441897b3.33.1784150457537; Wed, 15 Jul 2026
 14:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev> <alcebHobUCUyO70k@yjaykim-PowerEdge-T330>
In-Reply-To: <alcebHobUCUyO70k@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 14:20:46 -0700
X-Gmail-Original-Message-ID: <CACePvbVuS9xnKSxN_8X+kdyoU-b+bJGUsMK_38HJ=KtGhsoDDw@mail.gmail.com>
X-Gm-Features: AUfX_mxrwC-Njpb1o31UwMZjEDCbBt-qNnFIqtzYDXg3SfZvK6I_kRISd80m4_Q
Message-ID: <CACePvbVuS9xnKSxN_8X+kdyoU-b+bJGUsMK_38HJ=KtGhsoDDw@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70DE380004
X-Stat-Signature: 1o9bkaw8zzhdt56waxszjggogp1e5359
X-HE-Tag: 1784150459-336562
X-HE-Meta: U2FsdGVkX1+nWiezAh3plUsBc07FIlMVavVXlT+6DflOzKp1GBcSmYnDYGRKduq4vCqRE8pAxiPtI8L7GRonhdEUA43ZIJEMx0+j/DGKWRvKk7sO6AHl1Muab309LBvBNJT/O4lgSLRNpm0DzemsaAgUZuW0bMa8bhlISDEy5apZL2+sPcikqDfiUWE6K9ilNBlo5e+wxzHIW8vLufjenvZON1l7kT8oF4zVyBVzDjY2cpDowGfMCvP9Mz/ApN1WPaCCP2W4U3PVgeO2Y2TRxaiojXkgaVgNzG8V9pfdo6HIcvbA6ryluujxMWLANwCNI6S8eds1mnPwU7HHrPTH9PDT+i5J2aFPY55+WU0ju1RRpwjaF4dlRbJZV0Mxfro7be9nHf3XWrfRBaN90iWNUcG0LEe54H1fG4N4MrhC+VrU6XFLfUSOjHkyHhV29qVV0W8596lDypZRryNUf2dJWzStuAGayFtNDN5MKtmR/xboEUpJzACpF1+YgsQGZTvvIcaPCL8z5EZDOtLDWqg/9mqvojUq0kbD2Z3IfHE1rnER7uMxfpDaCK4dvGmaf2lc9ht2XhtiplmaZPBGlM/R8sWOLNhuuLTHhdwTEcQ0oEpnsRup1/f6QvR3+/8sTOloje74+EX5ikc7Z1bXyJIruJ8KyKe82HA0upjaOY5ifmzCEy8sjlV9XJESwO1Fzm+OQUoZv/6TOgBEOs7z7MMjx7isDgMbSTglOIUWgv/mdE5cxwJWBJz5hf4QurKthhS5+d4VCiUe4TQdszERmAShXi/hY5NH5j3U8vu+zfok7twxkdyoGs8zzfhVWaCGjdX0S1P2MDqfEh0QC6/SgswAdur1VZSNgnTkE3O7fdvw/uF8JB3K/b0E/qG79OOkWhum74ogqxz76hgMo1h1uWnw9ax4Ihj2n+VlUZ4eFH6297aN95f025offBCEmUlORSlzMqg++J0DEG54l55tMt/
 7JP3Cd7K
 Y5afQSK60BNZzi+do4SlHZACEgqVTjDZ5O3eCpSE1cfWwKULze9CQBds7dibTzMwmu5duhXphgrwbMJPZrjdDtzuMN/aFw4suE1aMKZXvDsvGtHaw4t3cR+Vfq8rjMuDEhzvmzifq/Ae+u9HtNOCkyuYos+S6InuwNd74n5Lr9B+HeWW46tKmHvkrZoXfWBMn/cY6aczrsLoTNBF64wb5VqE9zCYX8anD/cU7QRRdnWKf585xEbiojENO48gQHXPqpBdozLhEV25L9/d7vgeuVkX4vAB8T6eOEecp2W7gPh+VHX2mGTfext2YovyXWMsr2XT/MEjB3pS8/1F6Ip5DAnhhv7R8UQ7hAT7ih1+7VmpPPS6cAxCrXLe+eYhcHmGKKlhy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 10:45=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> On Tue, Jul 14, 2026 at 01:44:28PM -0700, Shakeel Butt wrote:
> > Hi Youngjun,
> >
> > Thanks for keep pushing this effort.
>
> Hi Shakeel
> Huge thanks again for suggestion.
>
> > > Right, that's the plan.
> > >
> > > > but I would check all
> > > > user-visible behaviors related to zswap (e.g. interaction with othe=
r
> > > > zswap interfaces) to make sure nothing breaks or changes in a
> > > > meaningful way when zswap is introduced as a tier later.
>
> At now, the answer is there are nothing breaks or changes as a first revi=
ew.
> I think it'll be better to introduce zswap tier after this patch.

I am fine with that.

> (Details are going on the below)
>
> > > Fair point. Let me review this more and get back to you!
> >
> > Please do report back what you find.
> >
> > Yosry, what is needed to enable zswap as a swap tier? What will be the =
minimum
> > requirements for that? If that is not too much, we can make that part o=
f this
> > series.
> >
> > Shakeel
>
> I tried to verify what changes once the zswap tier is introduced.
> Please correct me if I'm wrong!
>
> First observation: before the zswap tier is introduced, some of this
> is already possible today:
>
>   - a "zswap-only" tier equivalent on cgroup: memory.zswap.writeback =3D =
0
>   - disabling zswap entirely on cgroup: memory.zswap.max =3D 0
>   - disabling swap (and zswap) entirely on cgroup: memory.swap.max =3D 0
>
> Given that, my take is that introducing the tier concept itself
> doesn't change any user-visible zswap behavior, since on/off control
> for the zswap tier is basically already possible today through other
> knobs. So this isn't really a user-facing problem; it's more
> something we need to think through carefully in the patch that
> introduces the tier concept itself. That's what the points below are
> about.
>
> The cgroup interface knobs and the zswap-global knobs need a
> different kind of review, so let's start with the global ones. The
> zswap-global knobs (compressor, max_pool_percent,
> accept_threshold_percent, shrinker_enabled) look fine with tiers.
> They're zswap-internal tuning, orthogonal to the tier concept, so
> tiers shouldn't change their behavior. The remaining one, "enabled",
> does overlap in spirit with the tier on/off knob: enabled =3D false is
> basically the same as disabling zswap for every cgroup. But like the
> other overlaps below, this doesn't look like a real problem.
>
> The part that needs more thought is the overlap between
> memory.zswap.max / memory.zswap.writeback, memory.swap.max, and the
> new tier on/off knob. Since all of the above is already possible
> today, adding a tier on top means we should make sure it doesn't
> create confusing overlap.
>
> 1) memory.swap.max vs. tier on/off
>
>    memory.swap.max =3D 0 disables swap (and zswap) entirely, and
>    memory.swap.max =3D max leaves everything enabled, so one knob can
>    make the other a no-op. I don't think this is confusing in
>    practice; they're just two independent ways to reach the same end
>    state.
>
>    Conceptually, the tier knob controls on/off/auto-scale, while
>    memory.swap.max controls pure quantity, so they cover different
>    concerns and can coexist. Even if the tier knob later takes a
>    numeric value, that number would apply per tier, while swap.max is
>    a total budget that doesn't care how the tiers split it up, so
>    they still shouldn't step on each other.

Ack.

> 2) memory.zswap.max vs. zswap tier on/off
>
>    memory.zswap.max =3D 0 looks semantically equivalent to turning the
>    zswap tier off. Could memory.zswap.max simply be folded into
>    memory.<zswap_tier_name>.max?
>
>    Yosry pointed out:
>
>    > > memory.zswap.max integrates naturally (it's
>    > > memory.<tier_name>.max).
>    > Not really. memory.zswap.max is in terms of memory usage
>    > (compressed size), not swap usage (uncompressed size).
>
>    I'm not sure where the tier limit would actually apply here: is it
>    checked in zswap_store() against the pre-compression size, while
>    memory.zswap.max keeps tracking the compressed size? If so, once
>    you give the tier limit a number, wouldn't its usage end up
>    meaning basically the same thing as memory.zswap.max? For limit =3D
>    0 the two already look identical to me (both just block zswap
>    usage). I'd like to understand what benefit a non-zero tier limit
>    (uncompressed) gives us over the existing memory.zswap.max
>    (compressed), once tiers exist. Let me know if I'm missing
>    something here.
>
>    Also note the mixed states this creates:
>
>      - memory.zswap.max has room, but the tier is off, so zswap can't
>        be used.
>      - memory.zswap.max =3D 0, but the tier is on, so zswap still can't
>        be used.

I this is more of the zswap interal behavior, I don't have a strong
preference.  I will let the zswap experts comment  on that.
>
>    Both knobs can independently block zswap usage, which seems worth
>    flagging even if it's not harmful by itself.
>
>    On top of that, the tier knob is likely to stay on/off/auto-scale
>    without a numeric limit, while memory.zswap.max only handles the
>    numeric side, so the two should coexist as is. If the tier ever
>    gains its own numeric limit, we'd need to revisit unifying it with
>    memory.zswap.max.

Ack.

>
> 3) memory.zswap.writeback vs. a "zswap-only" tier
>
>    memory.zswap.writeback =3D 0 can act like a zswap-only tier today,
>    because zswap still borrows a slot from the real swap device to
>    store data; writeback =3D 0 just skips writing that data out to the
>    device . A tier restriction works differently: it applies at
>    allocation time, so a zswap-only tier would block allocating any
>    slot from another device. Since zswap currently depends on that
>    very slot to store anything, this would break zswap instead of
>    giving us a working zswap-only mode, so the tier restriction can't
>    substitute for memory.zswap.writeback here.

zswap.writeback =3D 0 will disable the other swap device after that.
That is the incompatible part of the interface with swap tiers. I
think if you want to use swap tiers other than zswap, you will have to
leave the writeback =3D true.

>    With vswap, this changes: tier off and writeback =3D 0 converge to
>    the same effect(right now the pure zswap only tier),
>    since zswap no longer needs to borrow a slot from
>    another device. Even so, memory.zswap.writeback still needs to
>    stay, since vswap itself can be disabled at compile time or
>    runtime, and we'd still need a way to express zswap-only behavior
>    without it. I'd like to unify the two eventually, but for now they
>    have to stay separate. I'll keep thinking about it.
>
> How do you think?

I think with vswap/Xswap/ghostswapfile it is a totally different
world. It would better to create conceptually separate entities rather
than cling to the current zswap. They can share code, but the mental
concept is different. The zswap behavior of borrowing a swap slot from
the other swap device will likely need to change there. It is another
can of worms I don't want to open right now. We should defer that to
later.

Chris


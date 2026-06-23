Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C2C9CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECAE6B008A; Tue, 23 Jun 2026 16:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C54E6B008C; Tue, 23 Jun 2026 16:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5516B0092; Tue, 23 Jun 2026 16:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA0586B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:06:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 613E84013E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:45 +0000 (UTC)
X-FDA: 84912260370.14.76DB1F9
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 74053A001A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:35 +0000 (UTC)
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782245195;
	b=BYRkkg7E0qp47T58nYVbyC6bD3bD/6IdcQP+xa3xiBIWJhBOVtGXR3ORql15MLbQGXthoV
	VCwq4NGEz4cO0PrpLjLu6ELNJs3pogmtRnHsFRFFCdDbkeE/Ghe4Va/YxSJpHQFl+G9RAt
	NAsBaYMR5UfkxIZA7bAgmgC4JLx5i4Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782245195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0c+c0GezDF20x3hAeTTFLEap852z6Me2B2PImW6++o=;
	b=XYeI02wUtUzEczobwmDSbf+dKebvtfMyEZf5jT6pj54CxtXFKaiFAw13ubdfKIRkBUNOaE
	EGHzgYb+naF8ClwuSLUvmF572sSNb3Xl72T0j13zX+j9xGkL3Gqh4DqZkOkY4T2IChvsZt
	M+vkbqHMqjTMY6z9iygTy9aR/S8lZYQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1863AC02E9
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:35 +0000 (UTC)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC39B1C05CD
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:34 +0000 (UTC)
X-FDA: 84912259908.26.E4CA3F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4437A120017
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:25 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782245185;
	b=urFFyF9RpzQHP7OlDwGByxM29XL8W2XF7Xg5g8vIO0kmollAD3K0zTQdjNK9KQ9THPa7JL
	0CoqCnJ/QuZFphl3PHedBSaRY5iqHWVb4TFf575isz/NNqfE3SGKHP2WhB/Q/XsQOgZAo1
	xP10xk2hQBh+pFv2GFvX3w3hlNMTJiA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782245185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0c+c0GezDF20x3hAeTTFLEap852z6Me2B2PImW6++o=;
	b=mFIszUSHmyor1LhehUIorlxu1LYpUOOHM8S6qr+XP89/7QsqaW49mDv/RhR83/qVu08OwN
	6G1BPkhN9VRDrn8N1wwBfmXxzzrZl1CeRQ0SqsLgHCvwqb37YNgd7ooBlsSCNIZhmnLZ5d
	qSv4zyFd7FjbwDpyjOlKEQxO98AVdbE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=At2K8OkT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 379584414C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDF61F00A3F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782245184;
	bh=s0c+c0GezDF20x3hAeTTFLEap852z6Me2B2PImW6++o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=At2K8OkTQB8kqxiHpfXww+8Y7Us/giY/uxflP3MKqQzAFolSur8E4EdLzGA1M7byj
	 3GOtZ7wYAdWJU/BzvTkJ2fh+6hH8RqdzJEnUtk3pePkRjA1nCLUn8Adu4ChfyUe7xE
	 5Gw0WeVa0rjZXsPfYtQrK0dMMZTyQuBd3SpEOJmVvDQ9HPPxVxh8HRrwqNNa5BEqTA
	 8qmgxNARZ6CYwJdmFq3UxEBWZ1y+Y0JzpWr48B/w+4fV+uKZkZJuq6asz2Czi3CW/K
	 Kq6XbxGrnMhvvuacNPFJU4Y9s55IhZ7+SA1YLelkbX8wuEXnYmaZRLoKBDzODr/dOS
	 goEvZIq0+aK0g==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-697e93b0d9bso342193a12.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:06:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/WMEf8kPmtP9uwe0C0XTjlHLJwbsHEe4Q2oPITd9b4o7AscTWZwCochn05oLwHWjfFfeWejRpCAg==@kvack.org
X-Gm-Message-State: AOJu0YwModX4/6RMSwnZXfC2bV0JWeo8N7fM4nwq7ib/Z9Zt/9SuWLvg
	UeB2pw/HDzc31693lDajlqvAumy2MA9DA/nt+OKS+2KEhxWlOiu1kL38DaWXIryUxYuZhQJtEOn
	PI/Dd7vFBkJnVJyxHN/jGr5ngz1IdKd0=
X-Received: by 2002:a17:907:94c7:b0:bd5:2859:ed0a with SMTP id
 a640c23a62f3a-c119fa32082mr3741666b.42.1782245183053; Tue, 23 Jun 2026
 13:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zOQQwDxmHGsRw_9k2eu6r=HU_HiXxbB4cbpwhc1GGgHOw@mail.gmail.com>
 <20260623185618.1488231-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260623185618.1488231-1-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 23 Jun 2026 13:06:10 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPwHYj284gyyjqnH6Z-NNLLbftKqzoOKycaMzm3+ifSdA@mail.gmail.com>
X-Gm-Features: AVVi8CfBRCr8pOqLd32ZXICvdYS2E-O7_kRR6ISoNTbshVt_za8XIuRuAYI0wRM
Message-ID: <CAO9r8zPwHYj284gyyjqnH6Z-NNLLbftKqzoOKycaMzm3+ifSdA@mail.gmail.com>
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Youngjun Park <her0gyugyu@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	akpm@linux-foundation.org, chrisl@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1782245185-686113
X-HE-Meta: U2FsdGVkX18UHfBlsUYyC2HtF+Aebrz77Dhu/Fx6o5wXSy0tqH9rLrfk5I7zIxozXvMX59Ai4cFvAU+b4RuZhUVf7MKA2CkaBt4B1ofZ49FlvbazbwfdYOwiH8jhRwBdcZrvbTKaQxXniN70QF6RSYZfwD4ExFhpc5PqMd1II5MvJA6kUDgbZRuwwoq7Y14gWN2zssz66lOQN2Hw4Vj3k4Bx2MGRD6a9f7xaCdOT1Oprpn3sUCJMqabycxKHF/nTmR22GtewLf87r8TRyfuYqT0EZjRO+5We/lNs/F/SyS6PF+ydemqRkoCe6qCA0E0g+2m3CZmQWQaxDKbOKfRISeUgQ0K0cdSWxTfQUDiBDLWVzbWHxqeuWLLF55CQ2NXkJLdgj+6fcCaYth/jg+LOkL0ztwny/Zfv
X-HE-Tag: 1782245195-875144
X-HE-Meta: U2FsdGVkX19160tZciKJVJxXDHSb1FFHPkqWcCy3bLQZ7gcXA3yZfd1LJ/dy8oYWuiQni7Ftn5IhqWfiLuxt9Jva2hXdTIE/+zyAf6ExY4+USiqFERCIQsYwoRt2l18dEBi9k2CO708owPYZdQNMnmWxHMVowm1tT6JCo59xBUZ6PXLoZDgpFfhXMGgNKI2UynZxZEXnC1+n5VODyE8iH4O8P2hXaQbuSgY6WIXRofsV11w/BVG0eR2w3PBWzJVzdYjJWaYf2S05IM2s2yBOEDV1kh5fmcJkqowspVwi7vr0VOgH+SJ6N/NW/C8hhxVrIGFuW+UuvTAXouOMv8kb5kUtq9lRnZPYez2OSgePU63V8fiUDH4CJZSu7tibeCvtI3DV3m9//t0KNNfwYoXA6DqYNrkrpjYE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 11:56=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> On Tue, 23 Jun 2026 11:10:32 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > > To get back to the question of how the auto-tuning should work, the
> > > main question is to which ratio we scale the swap limits to.
> > > Do we set the swap limits proportional to how much swap is present
> > > in the system, or how much swap is available to the cgroup?
> > >
> > > So if we have 3 swap tiers A, B, C, with 50G, 30G, and 20G capacity
> > > respectively, how much should a cgroup with swap.max =3D 10G have if
> > > it is limited to tiers A and B?
> > >
> > > This is what I was getting at earlier when I said we have to calculat=
e
> > > different ratios for different cgroups, based on what tiers they have
> > > access to.
> >
> > That's a good question. I think the case that is particularly
> > interesting is whether or not the limits of other tiers should change
> > when another tier is disabled/enabled.
> >
> > So basically in your example, assuming everything starts as "max",
> > when swap.max is set to 10G, the autoscaled limits would be: (tier A,
> > 5G), (tier B, 3G), (tier C, 2G). Now the question becomes, if
> > userspace sets the limit of tier C to 0, should the limits for tiers A
> > and B change?
> >
> > On one hand, it's simpler to just keep the autoscaled limits unchanged
> > in this case. However, this means that the effective swap limit is now
> > 8G, which is not great :/
> >
> > The alternative is to recalculate all the limits when one of them
> > changes, in which case the limits of A and B would change to 6.25G and
> > 3.75G. But I don't know if this will work well if we allow custom
> > limits. What happens if the limit of tier C is written as 1 (or 4096)
> > instead of 0? It's effectively the same scenario, but the tier is
> > technically allowed.
>
> I think the one problem with this is that it becomes quite easy to
> accidentally overcommit. As a toy example, if you have 10 workloads and
> 100G swap (as in the example I gave above), intuitively setting
> swap.max =3D 10G for all 10 workloads shouldn't ever cause any contention
> on capacity. But if you start excluding some tiers from some workloads,
> you actually get overcommitting on the tiers that can service the
> most workloads.
>
> I am not sure how concerning swap overcommit was, but at least in the
> memory tiering scenario accidental overcommitting of toptier memory
> seemed bad enough that I wanted to avoid the problem entirely.
>
> > The more I think about it, the more I realize it may be best to drop
> > the autoscaling thing. I imagine memory tiering might run into similar
> > issues too :/
>
> And that's why I didn't include opt-in/opt-out for any of the tiers;
> if you have system-wide ratios, there's no need to change the ratios
> at all, and as long as the sum of your memory.limit for each workload
> is under the total capacity, all tiers will also not be overcommitted.

I think eventually there may be use cases to opt some memcgs out for
some memory tiers. For example, limit sensitive workloads to the top
tier (or vice versa).

>
> Now, all of these complications aside, I think we might be overthinking
> a bit here : -) The auto-scaling should just provide some sort of
> "reasonable" default, the users can always override the per-tier
> limits if they are unhappy with the autoscaled values.

I agree, but it seems like both options are not ideal here. I think it
might make more sense to not present a default value at all, have
"max" be the default for all the tiers, even if memory.max or swap.max
isn't. Userspace can set the limits if they need to. Autoscaling the
limits in userspace should be easy.

>
> In fact, maybe it even makes sense to have sum of swap tier limits >
> swap.max.
>
> (I actually recall having a really similar discussion when I was working
> on weighted interleave auto-tuning a year ago, on how weights should be
> set when switching between manually-set limits and relying on
> auto-scaled defaults [1]. I don't think there's a need to follow this
> convention, but we should think about what the expected behavior should
> be if a user manually sets a limit, but later wants to go back to
> auto-scaling limits).
>
> Anyways, I think these are important questions. Youngjun, Nhat, Shakeel,
> any thoughts from you all? : -)
>
> [1] https://lore.kernel.org/all/8734hbiq7j.fsf@DESKTOP-5N7EMDA/



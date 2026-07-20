Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811AAC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58ADD6B008A; Mon, 20 Jul 2026 14:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C136B008C; Mon, 20 Jul 2026 14:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42E1B6B0092; Mon, 20 Jul 2026 14:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 109DB6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:28:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 994D0C027C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:28:12 +0000 (UTC)
X-FDA: 85009989624.17.85336B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AC6BC40008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:28:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bXU+1bw2;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784572090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUeBkszSLZpLeY1vHXaZpZdp8DfNcwXz6wfLvsS0W58=;
	b=h9OMR61GahrrKCjYr/LlFJLyWkcdTMJNdILjJ0QddAlDfJ5ek3hg+9GhNAeloBOg2StQZe
	MsshBDsPtiXVWMAf+/tcyXqDZHnW3zuaMbBh9MXOmbZW8xq5prXt7rt7QgCZoPRbxS6ek5
	R8gFrd8z2kWZbZ5OVFsKmhK72mqeUjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784572090;
	b=KOKfOJKGUVW5jAqAVWtjIGJzvP6p3TyTJSLgWttIxCH4hCB+zcLe5gdGhWLCwfXcHWAliX
	9xT24IRpILv9zVvabmhdmCeMFh+vcNOTRqNgWDfeogleN0kWNddk6bOyqCUxktoqs8Xxh/
	HlF4y0+1/FcaC1BFZqRCVUalNuYdyOI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bXU+1bw2;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF7ED43F61
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0681F01560
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784572089;
	bh=mUeBkszSLZpLeY1vHXaZpZdp8DfNcwXz6wfLvsS0W58=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bXU+1bw26GpVEQj8Red5SgxnSsTT441TVJj+/EQu9yxUKDrfqoW+6P6ayEDf//y86
	 G89Zxf7JmdLA1isnRI8S7nnCi2WPrBVDSPrdeyv7kn8JsdTxHWssY6O0Es0nXoM7xP
	 ZuxzeUptUJwEYK32I6SNA87KTKVawMZp+A0qChBecfvs8QxiH4OU54bSixg+BfcDxj
	 a91aSMEIqmK5gnybeWLLZah128WDJGccZopRbZ87XhEBKrsHFNebqSq7ALSuEILllY
	 85y+wtzew0S8ieNTqhp3/YggzY407OisbKAkUCgrAlvgZgvQdZrmwaDu7UnaXRvv34
	 NDqsigfYGg8ZQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-698aa7ba3e6so9156126a12.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:28:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoCGeBlMR0qABPmXW24wZpWENeNQOLd8BmyuzDXwT8BNdeUaiulE3EZgC72UfBFJ1IhPr2qWcgEag==@kvack.org
X-Gm-Message-State: AOJu0Yx3CIZUvuHdbQxtPgnLhcscoyZUuiJHvYPorfbp7/0dP38FkvHa
	8k7x8YVH9jRM7CqSpB9DZBIXHUWkYOU737GuSsqtzgkfXYF0Y8V1G4TMzNkitwll705J4JPlgKY
	ljWkiddRHE0SfSVVRrH+VPzrmOlRqdBo=
X-Received: by 2002:a17:907:1c9d:b0:c16:a9e0:d5eb with SMTP id
 a640c23a62f3a-c16b4869776mr668320166b.56.1784572088428; Mon, 20 Jul 2026
 11:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com> <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
In-Reply-To: <aluXhRMXkbPRsPcM@yjaykim-PowerEdge-T330>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 20 Jul 2026 11:27:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOK-3OzwsMQFY6GNv7foiw0Jnj2W6Cm0LCMmtX+2r5=nw@mail.gmail.com>
X-Gm-Features: AUfX_mw9GHQtD5pj7EfdilJONa1y4rj2U6Pri3MtJr_pXGOknXtYE_h7WWAL0-Q
Message-ID: <CAO9r8zOK-3OzwsMQFY6GNv7foiw0Jnj2W6Cm0LCMmtX+2r5=nw@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC6BC40008
X-Stat-Signature: 1jb1t7o9ddacwszwx5wfru61zuphjaot
X-HE-Tag: 1784572090-392218
X-HE-Meta: U2FsdGVkX1/U/rBMIwXEvLTdLf05aAvT5+gW7sjeyOpZF98LJ3+D5bMnQC4IU8g35WXOEquIfdzh8EU9tZepSJtKwLpzm2iCjZN99d1Q8jTRU14pb63Bo3EZUh8mQVlH2vO5uqMxKtIKqaEI3utRNFMb3dAcY2xb6x+xtOS157DYGqlckmXSXb3VETws2CG2hoLDm5QMKfNlhTLIgN88dB5dM9azZ6Bvrm4s9WZKljKa2RNJ7fmr5p8iZi/Lb6X/9kb7Iw85d0FgWvRxSnVcie6m6S1K3lzVI4MZVLi0NPLDaDVCsTTu3FXEnnL4h1cqKZfLes54pPqaAlApkPWQfMkVNG2rBXNvR1uk8UfaE7svbNcRvBiAD/R9ARYvLgc3UPi72pfJOWfFdG4f9rE2L4PXxmVhgcr+JwFC5PfaXu6v5yNWzcogkVbhuprP9tWIytum59Ky0A6URs/woJ+X3nyjiYRWvl/T07QwPQb6lZivVLHDDOEnILwk61qyobprAo/PaO6rX7LoL6BKBh7aum6W+IYQ1WMHq8m+NfjSzJM+DPF+EL4lqlCJROZSBfQGkrjZCAcs1cTkgXqwqqeEGMWjNoyoyla6gdOugsktiJnsA1QCYZPoqmEaqqcgix9Z8mONg83bwprHq+GZYf8irTVvFBB8YKvullgjdKgoxM3fBYFgwlMX5GnMMMFAXZvg+g6m8cAPxmh0RlCw1vLpF3N4ENYKkx/UFUu6HtOI6q2jKTeZc7yp17xsogGsyGO3FCwE2qYZXfATqmk4PH1f/2FuHThP6OejJKmv4wVC7PYGyfsIyzPD9uisE1L4cms69JrA6QawflKnZxGKHzyr34xx3ij6ux6ZRrZ3Kcc1iFt28tYKj5Xjig/891GpfyyoYE1sKgEZOMjpGN1ril6KcEKOPsSXUdSQp2TX4Cau7CPo/9wVsR+XA7somC1iark3YR7zZ0h2Pue4fFjZmE8
 3U97GfMM
 YGZPTwkqL7jkINAVMij9ycBI8ij73kTfAMX2u1CP/LePRWj8/GdqI5ul3QiFivPkrvQHyZrU4K0TV8616F3MEcfaejHPwmi1cNFd6oHw91B/i3lSTq5wNCS+mmVAD7tpLgCli5hh6VF9fBhj6FmM4RDDCDkOGGwc2gpfSderFivO4RZmRE4yKR3WVuoVzMnq9TQd+J09HX9iyr29oRYt5ALHMix7ujYjGrJnx/acJgAIvn4iCwPexYecmS5/LAB60xZNIwl1xeyHadsuIjLV1L1ZQ19pFobbYlsDS1Ijan5dx9gQxQ/nETn6PpsMR9Bp6IULNMxEf+nQMbZp1G0f0TTdc4FErJVLKuw2sUXNeYuGWMEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hello Yosry, Shakeel,
>
> I have been working through this in detail at the implementation level.
> For now I am adding on/off control of zswap through the tier interface.
>
> > From zswap's perspective, we just need to skip zswap is zswap as a
> > tier is disallowed. Could just be a check in zswap_store() similar to
> > the check if zswap is enabled. I am assuming that if a swap tier is
> > disabled, nothing happens to the existing swapped out pages in this
> > tier, but new pages do not get swapped out to it. This is the same
> > behavior that happens if zswap is disabled at runtime.
>
> This part works as you described, with no real issues.
>
> > From the tiering perspective, we need to accept "zswap" as a possible
> > tier, or maybe creating it as a tier by default if zswap is configured
> > would be better to avoid handling the case where the user doesn't
> > create a tier for zswap. We also need to disallow zswap being the only
> > tier as that combination cannot work without vswap.
>
> I tried to forbid this at the implementation level as you suggested
> , and that is where I ran into trouble.
> A few code paths can end up with zswap as the only
> tier, and they are awkward to handle.  Below is each case and what
> handling it would take:
>
> 1) A write turns off the last device tier while zswap stays on.
>    -> rejected with -EINVAL.  The write does not take effect.
>
> 2) The last device tier is removed via /sys/kernel/mm/swap/tiers.
>    -> the file goes empty, so zswap is not shown either.
>
> 3) A cgroup has zswap and one device tier on, and that tier is removed.
>    -> the cgroup's zswap entry is reset to 0, which the user never
>       asked for.
>
> 4) A cgroup has zswap and device tiers on, and swapoff empties them.
>    -> the cgroup's zswap entry is reset to 0.
>
> So the problem is that in (3) and (4), memory.swap.tiers.max has to
> change on its own independently of what the user wrote
> and it is not like just error handling situation as (1).
>
> There is also a consistency point.  memory.swap.tiers.max already
> accepts a child enabling a tier that its parent has disabled: the write
> succeeds, no error is returned, and the difference is resolved
> internally.  The user's setting is kept as written, and only the
> effective behavior is constrained.  By that logic, accepting a
> zswap-only setting and guaranteeing only that it cannot do anything
> would fit how the interface already behaves.
>
> Having thought it over, I think one of these two directions would be
> better than enforcing the rule as above.
>
> 1. Allow zswap-only in memory.swap.tiers.max.  As you say, it cannot
>    work without vswap, so today the setting does nothing and there is
>    nothing to prevent.  Once vswap/xswap lands it becomes meaningful on its
>    own, with no interface change needed.
>
> 2. Expose memory.swap.tiers.max.effective, like cpuset.  We already
>    track the user-set and the effective-set separately.  Exposing
>    the effective one would show that a zswap-only setting is not in
>    effect, giving the user visibility instead of rewriting what they
>    wrote.  It would also help the parent-off/child-on case, where the
>    child could see from the effective value that the tier is off.
>
> What do you think? or any other ideas?

Hmm yes, seems like enforcing this rule comes with a lot of complexity
for little gain. It's possible today to enable zswap without adding
any swap devices, which would render zswap useless anyway. I suppose
in the same way, we can just do (1) and allow users to disallow all
tiers except zswap for a cgroup, which would effectively disable zswap
in the same way (albeit a bit less clear). We can document this
clearly in the memcg docs.

Shakeel, any objections to this?


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB51CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12FA6B0088; Thu, 11 Jun 2026 13:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC40D6B0099; Thu, 11 Jun 2026 13:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA256B009B; Thu, 11 Jun 2026 13:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDB2C6B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:45:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7359BC116A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:45:09 +0000 (UTC)
X-FDA: 84868357938.01.6B194A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id BDC86C0004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:45:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLvD1dja;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781199907;
	b=LOze4O43kY3k+Tx3YWsdb3AYkBdaAHidPqz15+78zOxc0dyxZvGLk6XXXIhb/0yl4cBAzg
	fClC+z4viN3ETKMpoBeWDzc4LeeRV2x34ZGmrmuzSsHotjVpVK7ukQlyhnFH6Rba8T6KV5
	n9ReWKMqAcQGWfolRm39yJg6BFtg6ug=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PLvD1dja;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781199907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8cxqvFMDkblWaaUu15Mc6reR5WFsyNDXWf8l/ksL/Y=;
	b=nxlXrHdDqxcU+f71MwCSsrrDb+a1f1O/19klctIAJupT7jkaS2LhCccDEwb+fS7tkFReOk
	6Ij3I3rKkBBV3/zYGE/70+auY3A5UFaSw0cckMdQ2fXMJ5oqAcKC5JbPJoHDd9SbJRk+au
	C9kvbP1UeHYcLdXuKrRCyQlHlGhJ/XM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49306600AA;
	Thu, 11 Jun 2026 17:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CCE1F00893;
	Thu, 11 Jun 2026 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781199907;
	bh=y8cxqvFMDkblWaaUu15Mc6reR5WFsyNDXWf8l/ksL/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PLvD1dja2zpwPeg3XS5BQsZ1Ozpipc8Xk4694DeZWeAkXOqUza9BthUuNRHH5iiz9
	 d/UkZONrEgpHIPrtRY8wUZ2xc0MrCunp/dn7DpCChmOToGAc8HDCUpvzIU6fHDkGh3
	 /MxJqjk1oULyhbETFfuTD4BncjvhVYKmmuT1M8AZkHGK0FAqan6zklx4pgEg/YK5f5
	 c9k6QFnMWdZtvNg0y5Y/TvJiV6j/k00MtSfMB5J4j0FXyNAso7w0suH2MJILUIMnVn
	 gtWdG8vSAahiQEDTTrE/ZxJAhQK4L9Rrl+y+7g/b589PBI/XGkWA8cPf2nzt9huMHm
	 IDiCU/i8FOMKQ==
Date: Thu, 11 Jun 2026 17:45:04 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, 
	chrisl@kernel.org, kasong@tencent.com, baoquan.he@linux.dev
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <airzE7jD9UtyR17J@google.com>
References: <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
 <aicJBVT4pBvmyooT@linux.dev>
 <aicZ-5GX9De3MAU7@linux.dev>
 <CAO9r8zNBJ-BsXyKFveA92jbwMu63uFVTY5CuT4fRHTBVcOjhPw@mail.gmail.com>
 <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
X-Rspamd-Queue-Id: BDC86C0004
X-Stat-Signature: 583eon3a9p1fusebykr1ak3beky5xkzu
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781199907-897974
X-HE-Meta: U2FsdGVkX1/7Pycit+aeGinoOk8SpJ0TjLYonOmm/aOveTx9gTbmS+GhKq1y9bwe/8KFACHsuWqK6jHjLZRXvuSsPGWr2hL4hfAab4SWy/2EXbaHNIeC4+uzWAoWA1RSypGgutRn8CsSTc795sNEao3vCG/QDtWOwFKwCwZrZwJXxBbL77qg2lrjosD2uKI7sbZCOR+gZ+V/EbJ+ki7+SsqHwjK1LvVelWKf+DDgDXWtATiL0H/7ASmOqYx+6peDx7nvjVGIOsCplxv8fnNcl7nRbkIvU8x2C+EGik2UvuW1Cj9Q6zgcwCJe1FXkR0xcJpdYcZiWXDHtfPjkAaBxvx2Opex86IWC4J4Eecrr80NlNXSc2xPX2/0eZ6klSeMqICYLTJUlpILXFwog1zLnCm8dLzQJhCi1I6L+mjhbtR+J4nm5WkIZCCa8zukgc9ShHHvDzV9AnD5Y5vff/jdC0gkef7p+frcfKuLMTQiE8ahpGj8UuDzVNgjaeiycrTNDus0DiTDLhUlqI4ezyvMMi7rPSOFJQ+L+3PRCK9lXb0cIVL8MtlrpIAf3THt1toz/uhFgZMi5cbkE4NaXb+gTUndkYMAna0TsOKXZUcbBYm59LwekpPVHEuSo/NfciwNdLKhxHfuU2netjPL5Zc9aiaAta4/J5OisB0WHtVkZhsbTTJG+0OvqyVtoAGNixIqgzVjTIB3LMyDoMF/HmO/R1lNmEZQFkjgCpM9L+/40BHPK0x8mEGigZEoBBpwHdi7QaMcucWvSmSZx3DAQAuU3czHnXkJ/Ni00f29Kt3BCvGgPkWGZ9rMflWv2u2RVOadjAqSUR3n2VYNSpPFuTbLgLE0sVQ3NXlIdxIiRdVz9zc53I937KDONc6LW8GBQM6WVvGGqeeIIqaCx//G/BQ19dH2IACVwFDGZKkTXjqo9oe8LvsvQC9tAz9Knj/Gka1M1JmeMeJhy9UW7ZYu3KLQ
 ou4kRpeE
 QQG73TrIt3OZbSOqKRcbRSFTquQVarPy3/kVYDeM78lvk6SxlEGqqXOCoq9vZwAYvyUfp1vmyaAaTXhVxOXPZ/BIVNwrwfU7jFSCXBKCnnlzmhb47X1s8Nf9EnwY9mzQ11O6uz8SZ8IGi7f3jXUk/Cr0dxWk7DuHb7YlJR5y4yG16h9Eztxw7oYwcvLGLfalpNHyNJmhYozlfMcrmFUe1+9V6YvcVr7tF1zD9p3K7pJ9Tbtz6uwK080yBK6Nm2QfTFuMxLo4eDWhvlGfRv2Bi65ZkkV6Cd0EfbvVUbTeMM2XT3DsADEd/e5nrawGuB+GOuEZT5201cgq19wFCbXoxd64FF2FhGGxA6DHFGoobATW9/9tCMDoDB2OnpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 01:19:13PM +0900, YoungJun Park wrote:
> On Mon, Jun 08, 2026 at 03:27:07PM -0700, Yosry Ahmed wrote:
> 
> +Chris +Kairui +Baoquan
> 
> Hello
> 
> Thanks for inviting me to the discussion, Shakeel.
> 
> > > > > Youngjun is working on swap tiers. At the moment he is more interested in
> > > > > allowing a specific swap device to a memcg or not. I can imagine in future there
> > > > > will be use-cases where there will be a need to demote data on higher tier swap
> > > > > to lower tier swap. What would be the appropriate interface?
> 
> Speaking of my work on swap tiers, I recently submitted a patch and am
> currently considering memcg integration:
> https://lore.kernel.org/linux-mm/20260527062247.3440692-1-youngjun.park@lge.com/
> 
> The future use-cases imagined above seem to align with this
> direction. (BTW, I am currently waiting for reviews/feedback from the memcg
> folks on this patch. Any reviews would be highly appreciated!)
> 
> We could potentially assign a target tier
> for writeback within the existing memory.zswap.writeback interface. 
> 
> For instance, '0' could mean disabled, while non-zero values could represent
> specific tiers, which would maintain backward compatibility with the current
> version. Alternatively, if zswap is treated as the default top tier, 
> the `memory.swap.tiers` interface could potentially replace `memory.zswap.writeback`.
> 
> Furthermore, this could be expanded so that each swap tier can demote data
> user-triggered demotion between swap tiers.
> 
> Based on the current patch's ideas combined with my swap tiers concept:
> 
> Assuming a hierarchy like:
> zswap -> tier1 (SSD swap) -> tier2 (HDD swap) -> tier3 (Network swap)
> 
> We could configure the active tiers via a setting like `memory.swap.tiers`
> (tier2 enabled, tier3 enabled).
> 
> For example, the concept of `echo "100M zswap_writeback_only > memory.reclaim"`
> could be extended. A user could run `echo "100M tier2 > memory.reclaim"`
> to explicitly trigger demotion from tier2 to tier3.
> (BTW, if we combine these features, my personal preference for the keyword
> format would be `<size> <demote_prefix><tier_name>`. I think it would be
> better to explicitly indicate that it is a swap demotion by using a specific
> prefix followed by the tier name. 
> Or make demote prefix another key is also possible)

I am not sure if proactive demotion between swap tiers would be driven
by memory.reclaim, I am guessing a new interface might be more suitable.
But yes, you are right that it's very possible that
'zswap_writeback_only' with memory.reclaim will become obsolete once
swap tiering matures and starts supporting things like proactive
demotion.

Part of me wants to wait until the swap tiering interfaces are figured
out so that we don't end up with redundant interfaces, but I also don't
want to hold Hao's work since it doesn't directly depend on swap
tiering.

Shakeel, how do you want to handle this? I think there's a few options:

1. Add zswap_writeback_only now, and when we have swap tiering demotion
it becomes a redundant interface, like memory.zswap.writeback -- or
maybe we try to deprecate both of them at that point. It's difficult to
remove interfaces tho, but maybe easier to stop supporting
zswap_writeback_only.

2. Add zswap_writeback_only behind an experimental config option, to
unblock development but have a line of sight to dropping support once we
have a swap tiering interface.

3. Wait until we figure out the swap tiering interfaces and then add
the proactive zswap writeback as part of it.

WDYT?


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C149C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550776B008A; Thu, 30 Jul 2026 13:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500746B008C; Thu, 30 Jul 2026 13:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418C36B0092; Thu, 30 Jul 2026 13:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16D616B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:59:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9405714023D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:59:58 +0000 (UTC)
X-FDA: 85046206476.15.6CB48C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A7F7E140005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:59:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UshECIue;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785434395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZrCgdyXy0gel21g6+l3wAl91/gQK/6PxbGO/1UYQNI=;
	b=wg3OiYKKu/JiguafxYGtgSFKtU0GSbfWzqnboWhYdyRIlaa18uyTT7eFks01gl1ead6fs+
	pgZtxMOF2QLPwCd51jyGgpIXvMXSFEsVpv4lShUkEClOvCoUcwtgCD8NmMExeZLHeRaRBt
	QaSnvFhtkG2r4HD3iBcsR110ZInAI+o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UshECIue;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785434395;
	b=BW/o1OK8DuNuFp9cmHVbrwe+Cp38sM2y/Jze/+kZljOytExNLwAfGJ7rGaWxxw2X7xo9dA
	+NKBjWnK4yGfemJd0mPmSJCIPCfbxGI3nd2Fby7l1KVZmL3MCcYIWmnlz76cB0usRWmMVk
	83dCw4Ntsq+jUu8guDr1RnhB1GB2Buk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E888843B0F;
	Thu, 30 Jul 2026 17:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACE51F000E9;
	Thu, 30 Jul 2026 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785434393;
	bh=YZrCgdyXy0gel21g6+l3wAl91/gQK/6PxbGO/1UYQNI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UshECIueGJWRMP+SZQFVcW0KEfohxvJ8oK09e7hIWV+2DIe4dmG2UVxZALb6bPcT5
	 0U1hW+6R6guYUtI0aiN5wXC8mVznh7PRZkBVADUy807+Y/d5CepvjAv+YyE6B+dn2q
	 66ns3oQYRRGuNTh6RCVt577rqxUpB9uVhkPVSXhs=
Date: Thu, 30 Jul 2026 10:59:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
Message-Id: <20260730105952.7878a648c43c32b5e649d96d@linux-foundation.org>
In-Reply-To: <CAO9r8zMPxdn=MOFD9mbrzed+C9HhOB5DpHG4QS0OJzqV_gLvsQ@mail.gmail.com>
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
	<20260729084206.77793-2-jiahao.kernel@gmail.com>
	<20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
	<CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
	<20260729181756.a37e0cc7ea3f6013959d1d25@linux-foundation.org>
	<CAO9r8zMPxdn=MOFD9mbrzed+C9HhOB5DpHG4QS0OJzqV_gLvsQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7F7E140005
X-Rspam-User: 
X-Stat-Signature: s5otewx8smat9pygap7kqwgqcp3nn1rf
X-HE-Tag: 1785434395-325961
X-HE-Meta: U2FsdGVkX1/roaNtDIecHwWrcl51CN9O3O2N00TfJ7ELDi6Ipw+uY0hSCdQUeAs3Wx6V6leZ2reaaDIll1OoP2Qu3uS2y+QEvoZGGZxittXVBP80ocoH5c8ykHbsSzugPwq7LrJx0S7Yx1wJm9G7J10CIiNjwBy+VBF30bKa/R97bTC2nR4pAzIuMg2v9TlZvhdbrQp0qLxTejbcrzJCJfAb5sNGqqr6KoFUGfrjDeG5cJTXCzhrdjaYN0lKCB6h2qFPL6ULae6rzSxqUTt75vu49n22CQgk0EbjCxOJw3QeINj5a/hiBTwFxW4OChkZ6pa4AXM37/QWRYJI+WW2whvOnJC9bL20c/Vrov7Bk5TzTRfAOmymXmOFBfehmy8MUkin3EChwBvzOW9RTVNplyYku4LBy3Dob2U1bIUky8jlsqXCCqUoZO1LGdItIDpAwhbRjX6naGbj4Is5fz/THOTI4PlV+95O+0cQWglGf6L3Qrd9+5vZYu/1yVMhcBSOWJe07zqax0sFgj6X50g3AocL/agZgZz+mG17YzikxbIEbQI3AJX5oh3DL4GAkr1RqfgoUkTmM6+CAxidO274Ay9GVkiKvvNCp5L2/hshfRQvcl5QDmTrRXB3DKQC3eQMUtVcifjb5ixrzYO6UJc40xLd4Y/plvW6hw1UwU/PeBk175rJ99bxRREEvskrxSAJrovVXxc0ZaG8O6meunNXsN5VL+gXqzHp2chj2q2BOhzC2H6Ke3K2ZkTdwDISElNYAzEbwVvnFRW25HcxXvb/LHwhMSYduNHr0F1igrJeWTAcYxtYy5NC4LB/zZGO+uTjdmJWUY5tP1wVDRLDzJZjiT/os8ZOaHCp/EiwaZpSrPcR5t3ext10JGEvpzOLhRGsh+G+9rP8jWuMOx/V+sJ3gdSCWCbTgMaX8Gfp+jgfHp9UNhHr4yf3HjjpVScwnds0n0G2JGdb89gMX0HTh05
 JxKHE95B
 icCsofVySvXGrbO1YmndKaOCiui7vpnkH+SNuAAAKuybeRjAi3HdpneXex05esZNPQkR9tj2olIgryF5owgtb8QvRsjkYhJDyOgeIoBk5smp7mcUHqIflUcZZIqaf4wGmjN3QopYjEoqGtdb3Zz53k2vcY8HTknkyj7T69OZ1W9flkBprT3SQ2grpmVN/bccgibkQS5nmX7HpGdj2LKxAp3xsLuOKuWuRyYGmq8dDc9NhW2ohfiB6B8kCvXFwjomeGlHxUrI4XiGiKFOpfz6oePbr3SIoJwyo8eKCnu3nn23OWWmCmNyT8jYocy58NdZ1s8JmwpiTZS8T5F7CnfOFqPoAg0McDMWRe2Gz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 09:52:38 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> > > >
> > > > How does this affect users?  What behavior do they observe when it
> > > > occurs?
> > >
> > > I think the first paragraph sums it up pretty well, especially the
> > > last sentence "hotter pages with higher fault latency".
> >
> > How do users observe that?
> >
> > See, what I'm looking for here is an explanation for why we're
> > proposing a backport.  How are our users harmed by the current code and
> > how does this change benefit them?
> 
> It's a potential performance regression when using zswap with memcg
> disabled. Sorry I just realized you were looking for a high level
> description not detailed symptoms :)

Are we able to guess how significant this is?  It should have
significant impact to justify a backport.

Sorry to push - I'm forever trying to train people to describe the
userspace-visible effects so we can make these backporting decisions!

And to justify those decisions to -stable maintainers

And so that someone who is experiencing a slowdown in some private
kernel branch can look at the changelog and decide whether this might
fix it for them.



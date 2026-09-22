Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E332EC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97786B00A6; Tue, 22 Sep 2026 02:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EF76B00B1; Tue, 22 Sep 2026 02:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD3E6B00B2; Tue, 22 Sep 2026 02:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A91036B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:28:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF79F1C2763
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:28:54 +0000 (UTC)
X-FDA: 85240420188.04.D9CD939
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3F61220002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:28:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjggewUa;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790058533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjA0mTADx3qPlEwSKVVtyou7JKb+m4+dYOfU+1IXyeQ=;
	b=EaaqUdj2veAlCs2MGAMg87YDNDInulQHn4ubl2BWPGb1MX1UNpF+d59LLqsZt53m+esPLO
	9dfaFuN3KF6X9uWdQEJoAfWjX8loox0Lq18gjTK1RUDYVCM+Duagg8QWtBoLtJYKfH7aHU
	hK00Y0ytCnQ7xFflPNiwD8bvGt3r9tY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjggewUa;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790058533;
	b=hYSHwkovmk/Da6cUJrqic0PjT9441dDZoXJvvokZk5b475cwZdO9LTB7qg4SfbVXZnGRvx
	JoE6s9bAxh7YiKrmMOwBqeK9LbLwgKPYCAUAgH681zzK7EIa9g2PrSkqFoxmQg+hm6QWAY
	2n0d0l66akhf2GcDA17Lcn10DnpxHjo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BF88406AD;
	Tue, 22 Sep 2026 06:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0C71F000FF;
	Tue, 22 Sep 2026 06:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790058532;
	bh=KjA0mTADx3qPlEwSKVVtyou7JKb+m4+dYOfU+1IXyeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjggewUa2OW/a72buV+ty3YEX1MFFXvoolgOwh9ZjB4lLNQ6G4BvvqISxjw6HvDsD
	 tDRRE06ta1+TL+CPaAxBAO8ftW2LhJgfgevibZnFrVZGWtjY4O8lOpSNDtMPtREPb+
	 tP86oUglV47fuyh6r1jOjCjygHP9Xc0HgMguKMmGs6yInel/r5uvZjbHTOfAjG3TBr
	 yHcS1TsYuYWW6qyfOmUHnz+kgtsq3L8jlXwzHwB2/6m8W3MrNUcpRHyRf0hjHerVeW
	 atTXG0I0yxMLlDPd4cT3NNHGxx1ZeSm+D6GSUek+kossuNakz8X403hEIf6aDpBuxH
	 NsBnE5cDkauag==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/damon: preserve temporal quota state for unmeasured PSI goals
Date: Mon, 21 Sep 2026 23:28:47 -0700
Message-ID: <20260922062847.42316-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <arF2epnyKAdkwSG-@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F61220002
X-Stat-Signature: cncq5oc6z7pigiojcsidr5871m76gya5
X-Rspam-User: 
X-HE-Tag: 1790058533-944785
X-HE-Meta: U2FsdGVkX18GklFxaQpUoKsSywJ61l+OK2hUF/J5cQw9a70iKT38cTX3SLdNTT9Gr4TbT8kxjKYsMJtOc7y6jY+hlbc6nfS/0njJweVG8Kn/XknZFJCAUhK6vnSPheLdxInnNQlmmv9Wog/SYK+BsJyP04XFwbor/eIXV+cvM69NYypvLdliOwAW2ayvrpN0SuTVx147BFffeYHoOzJcJUWkhcto5KPsSPzncJh8B3Hai+wjHH0IGcwBhuG9vFUOKp2Jkm7pUxeVxfLSm1fi05aMz76HoMc6Y70IYrPTzM98AQOeNBHLUFdAsaaMOmhPJ/FnMpeZsmmTQ1BCFmFGfM5XKm2b5xgN0RoGaqj5V/BCpXoYmmAB9KM7VYCMxHXuU7tyWc14LPAmRD93yLweM5KoOmrR/nO24zaqzt+dIyyBBgW4JqpQp9OJ89HT6BITpB7BwBFFLtumRhUWg+C6JwyjkZQJHep9tdnMKZfISXDujGMtGZUsStzgTFlqRNunT9cwAcet/3iJplEP+7bHjpz1k0W+Kt+9XYkgt/0Ji7P1TOLWwS1vmbVpmLk03IepE/0aGY4EBPyjyFcabdyPVyesJlR8sJeUhM51thwgir6slvq9SF0nSa3Yz3QJ/tJms/DPFIqxw5i5X4KB6uA9jwZqKCV67OmWnT0nDWhPZVZ1tteavQs00QMdG426k+ca7JKxInp14wMNI71Z+mPQ9NLFi+GwIqzcQBgUSxSAToM0lQP7bVtxWzftl16mh2vRSZBJVWx0sUCjJT6yX4TQYwyUVXwRbto/PCPoB+QMwmUPUMpt/D+DBZtqxgNu147wic9Eo9FKs8vApkZ/f/6/VwIhZLSxplUZhCeIBtHv4rC/qIK9AV4kFvCSRq25Z/ZZq8DGhivZVN0+cnWxen49ANr2qNEuU+gIQqsvQ8kM6ljTmBRL3IxbL/wFD9WP7NY2Vi+rzGOT/3gXyH595ua
 rf4lHmMG
 fI/8XdybJmscBzicFB19I8zAx7AwB+6OuWTc2JeWSKB5XI7uP2x15W7dz23+U+L3XJQVqkLNpOdxTPvWAZs+e9AQq55KKjtdFqL2XsXwQpzUZ5ZROJdpIUHd2kNm3gzdklffqmCqlYqzYu4bldywswtM8w5tXjo9aDwlUX6FmzyjOp+pAca3fWDRxVVQ8LJkdUHBkg1+49PDzFSWiJs94o74aR6Pxothk+66HBfSn4NAJ7ovNy3IENf5vrkmu/W+qPxVcM6Kf3Eeashzt7+kL5x+Z0P0rNHJlWgxPVnwJO++FaP+sKl9Nt5n7vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 20:39:27 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> On Mon, Sep 21, 2026 at 09:47:48AM +0100, SJ Park wrote:
> > The patch 1 has wrong Fixes: tag, as I replied to it with two options to path
> > forward.  Speculatively assuming your preferrence is option 2 (adding this
> > series with fixed 'Fixes:' tag), I applied this series to damon/next [1] tree
> > with the suggested Fixes: tag modification.  Let me know if you want the
> > options 1 (squash it into the incomplete fix [2] before it is merged into the
> > mainline).
> > 
> > Unless you want option 1, and if this series is not added to mm.git in short
> > term (~1 week?) with option 1 update, I will ask mm.git maintainer (Andrew
> > Morton) to pick this.  So, no action from your side is needed for now unless
> > you want option 1.  If it seems I forgot doing that or you cannot wait for my
> > action, please feel free to ping me or Andrew.
> > 
> 
> Hello SJ,
> 
> Thanks for reviewing both patches!
> 
> I used b73198a47ffe in Fixes because that commit introduced the problem
> with the temporal tuner.
> 
> I thought a Fixes tag could also point to a commit that is still in a
> maintainer tree. The tip handbook describes that for tip [1], though mm
> may handle it differently.

You could do use a commit hash that is still in a maintainer tree.  I also
sometimes do so.  But in the case it is better to explicitly mention it is for
squashing on mm-unstable.  And if it was the intention, in this patch series,
you were better to split the kunit patch.

> 
> The hash can still change in mm-unstable, so the tag may need updating.
> 
> I also found this reply from Andrew [2]. He says he tracks these fixes
> by filename and folds them into the original patch before moving it to
> non-rebasing git.
> 
> Maybe squashing is indeed simpler here, also for backports.
> 
> So either option is fine with me. I'll leave that to you and Andrew.

Thank you for clarifying, Karl.  I was initially tempted to keep what I did
(option 2), but maybe that's only because I am too lazy.  Let's do squash.
Unless others raise other opinion, I will repost patch 1 with updated commit
message tomorrow.

I will keep patch 2 in damon/next and repost for mm.git merge as I explained in
the earlier reply.


Thanks,
SJ

[...]


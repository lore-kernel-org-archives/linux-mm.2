Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C016D58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2BFC6B008C; Sun, 22 Mar 2026 17:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC816B0092; Sun, 22 Mar 2026 17:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19626B0093; Sun, 22 Mar 2026 17:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2E1D6B008C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:44:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7777E1A08F0
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:44:30 +0000 (UTC)
X-FDA: 84575028300.09.8F03C43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CC10E1C0003
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:44:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iHHshZQo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFk79P6GNUdpyMH+zbilVmP0RmYUgXZQW+Ydd9TkdZc=;
	b=A38JsbVT/Ii/qsVBj2Bmmbeg3BxFlLFvTwZ+agl+kmrDXgvcJ4Otuvc0pLDf7NjKXeXNLT
	ZzoWaCfifae7pRpg7tvQVkns3gXcKE2PyJ/yu40Wte60qVCBCCjL/h9b5nc7feVluZto5F
	zLWeHdmWW+XYFtSOPgTWnyzPx6EDdTI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iHHshZQo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774215868; a=rsa-sha256;
	cv=none;
	b=754hla3878flOzrh1/aounT2+gU+m33c3lnQPqqVoPjqfe9cFA9mTY3qMIup8O2c4EnbvH
	j11E4DG2pf+yn4rdC820S8HYZBUr1WInHrrZFKouZTj08t7ZsU14+wb5utvRQCZ1A138mb
	Udb3gla6vwcHMhYRlw1SFi7EjokRXT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2D6D442C9;
	Sun, 22 Mar 2026 21:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D92C19424;
	Sun, 22 Mar 2026 21:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774215867;
	bh=22RzMTpANs3aKprCXCb35XmpMBHsIxXACgA4rqRNcMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHHshZQoqOMcpa8OyO5OiO1LbWZ5eagie6TbiHb1yFVPhcIPtleZSqsHGRQlFfbUK
	 qRsySpCNK02ERdUNrIK/abyn+VWfwN1XC9GFu7DWosG9rplJCbO1r7njwSmtTHJryx
	 ic2vXJEZRbsrJwWpC2c3bNfdxeVzTGjPtXCcY6tMH5DSgA6X5rViag4yh1QKB22Pda
	 VSdTZRCBpZ8hXQkBn8jYEEDzqYeueBofFpFdANyz5kbkmkoMVLdpwk8hD2xEVoJh+Q
	 WX/clgUBwm7tT7y+gIhYcwv+beWoH5nDs9L4ByuGofp70tnV6oTXrtQFr8e6nt2m6L
	 dv/g+x6t3/LZQ==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme and region loops
Date: Sun, 22 Mar 2026 14:44:18 -0700
Message-ID: <20260322214419.89419-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322184641.251966-2-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC10E1C0003
X-Stat-Signature: xpecg145dobxz3yocqxeiqymt6n3fq1g
X-Rspam-User: 
X-HE-Tag: 1774215868-828469
X-HE-Meta: U2FsdGVkX1/SR2afAJJOcGGWhdQLRMTKgTBTCHDOg+EQQTYaaUEEssOM9YwCO+MgVLxdN+Juf3JSn+fnJjqp7Y77Y47US/ZYiJZ8+4mtIuzKxZhyzkxjS8H0RVLn98sQeB4djBvBrXRCivW5ni01DXHrg5IeX2POvl3g9AcmN21FyuOGsyWDXaQfZjBG2iUsMhNyOdTQqeAJwzCA1rWUoEVTov6WZxyEn3mnqnVPaaRO4l5DNpSBcX5LbFD9Mwq75ThZKyiW3JpDzLK2DyxVWEG9UaVJ4wqOtK52RLSZgfnU7qGj2YjbWDoSLCnQkMFztCsFbWEabfG7iivjfn75+k3e4cNwHtFapMpAOJB8xnZQ+79t7wS4mtqSId3t4NUCFRPeWunHiaH5Otj40KfRC9K8bfG9elwdQ/4SQ+JGpGFmSZiIXaeClbeY/6awpoZcCq5zS3ZT5+rDQKFBr7nHbPsvU1ffAktPs4v8XQ3GzWMYyViwPxiieKcwktcb1A+hN3hZU7ijJJXaWbXxZJ7bWEvZFb8J45KhidxcXFeS0o2FEzL1b7ruuyNldLA1pmhvaCI+VQ+1CDgLD8XdKDoBHbE4PBWsiJ7nuxHSCg2NIK+HgoJMUYyGM6fCqY0ZsQqqrZXiO188xRsYuASjVyLznxTF6UgCNfmA7IG/Sr16IXkRynJJzOExQ56230tjY9iKYH0c17SIHoJJ1il5aNjCekc2ezIJWPV3wbBxYmR0pI7flPT+cTFMx9FpU9Y5/S74cwQhUTdICgTszVlDHNxJQR8hlOtBDDJH5Sl6upi2dSQCmYTCaN0bMBvBQHpAEaAc311YUZiyQKojqXSO3HGEUyQ5ee513FNClMEhhHUANTRf4syc7Rtc6WkoGydMtLzYqR8mrmJBZTriy/rkSKgmLOVuXTYKHfszTl6pzptPXh6elv+SWDQ97qWix/RglCfpICpSZx2fA/4G9pCMOXT
 BlaN/7qX
 H7ocO2onV3V4JxOtzen1iXCPy2P8T+iSUknSyHiMl72Uj3VS8e28PMqQZslW6QnfHXvnld4vg87zkB/CaEqReUE6kJj1V1u6Mt/8KTdlZqBmAWephJw36jTrv9Ko3ezeek8XLw2vJMEOeCa2XE4El9PZfFX/tDgQKh8SNDi6rJThFq2ju5KaqC2yU7Kn78gcoqWxS0Wp6Ea+jN/tMWooykE8A5MjJmUe8xDnaGXsdkJZNvNIPMMQH7L8PdTsIFRPPWZ8eaI/lpA+xBZtJV+1zCkb1tfDLD3CucsbsauUmY9qUhabH2NKMAWPMHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Josh,

On Sun, 22 Mar 2026 18:46:40 +0000 Josh Law <objecting@objecting.org> wrote:

> Currently, kdamond_apply_schemes() iterates over all targets, then over all
> regions, and finally calls damon_do_apply_schemes() which iterates over
> all schemes. This nested structure causes scheme-level invariants (such as
> time intervals, activation status, and quota limits) to be evaluated inside
> the innermost loop for every single region.
> 
> If a scheme is inactive, has not reached its apply interval, or has already
> fulfilled its quota (quota->charged_sz >= quota->esz), the kernel still
> needlessly iterates through thousands of regions only to repeatedly
> evaluate these same scheme-level conditions and continue.
> 
> This patch inlines damon_do_apply_schemes() into kdamond_apply_schemes()
> and inverts the loop ordering. It now iterates over schemes on the outside,
> and targets/regions on the inside.
> 
> This allows the code to evaluate scheme-level limits once per scheme.
> If a scheme's quota is met or it is inactive, we completely bypass the
> O(Targets * Regions) inner loop for that scheme. This drastically reduces
> unnecessary branching, cache thrashing, and CPU overhead in the kdamond
> hot path.

That makes sense in high level.  But, this will make a kind of behavioral
difference that could be user-visible.  I am failing at finding a clear use
case that really depends on the old behavior.  But, still it feels like not a
small change to me.

So, I'd like to be conservative to this change, unless there are good evidences
showing very clear and impactful real world benefits.  Can you share such
evidences if you have?


Thanks,
SJ

[...]


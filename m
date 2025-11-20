Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C03CFA441
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 19:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2B86B002B; Thu, 20 Nov 2025 14:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673D86B002C; Thu, 20 Nov 2025 14:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589106B002D; Thu, 20 Nov 2025 14:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42CCD6B002B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:01:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFB12889CA
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:00:59 +0000 (UTC)
X-FDA: 84131902638.10.6C8911B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DFC6440025
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:00:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kTYd1Rrj;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763665258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=SNy++gIKDXHiABs2FKScjYTouINK7FlnQLWJNe2gtyI=;
	b=1p1TR0PaeGzw+hxvhWdfFmFG3J5gneZA75X1uW2MtgQMjqX0B0sqcy5cGos2vlaExSrBlr
	3Pwl92HlEPFAWjUiu2/eAXQGz6oWu9+Cig6rmcOdvNP5+tUZmgWrJ+K7ttv6C8dBqKIQ8l
	zqoob6Fk8wdb8CuPRltj6V1U70480+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763665258; a=rsa-sha256;
	cv=none;
	b=Gj1bVFO/DWH3RQXb9D/owiAp92jaoxlapX6c8YslWFWO8OM9VjJ7WTxqMrR8g+vGEPf785
	AeAkyHgRFAma5NJWs5MuwhYU0Ns7BsIxqWXv/FVmMmJOhNqODz2TUWH9cSBOHfVUDkHdYn
	O12fqKMcCgUqN3d7REdv/Ofpsm8xQe8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kTYd1Rrj;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFA134043D;
	Thu, 20 Nov 2025 19:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7F9C4CEF1;
	Thu, 20 Nov 2025 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763665256;
	bh=kELsnnBohxJHoarvZULV6BJ8ak7sRkdRSqNlBh+vPAs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kTYd1RrjHfC8Yw1DLkxv7EeQCxMEOIG+jqT4a0IMs2KHemnwfVJVbPk8BqEdE57ZX
	 vbkEI6bIsBqx8e3sraP6ni72x5uaEsCMr4azagdB3flUAhEBMJyoTPnvRRbVfcx5bc
	 WmZUv11Rf8yB0TOf63kJSn8V4aoVR26uT9mGrtbKOpKhBY7KoDWnfZLDC1VdXWawS5
	 TjkOV9sdMHUckE0EtjZqzUo4v4mirr+H+QuryjvNfs+SPieH5sBaQC7eskpFITf4TA
	 jKkQ8E+aViWYl14cr/y7wH7Age8JUvU2LCV/47QICEASA7LKKxf6b70G5JBKYVAPwm
	 OYwh0VoM+uqMw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 344103A40FE6;
	Thu, 20 Nov 2025 19:00:23 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.18-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz>
References: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc7
X-PR-Tracked-Commit-Id: ec33b59542d96830e3c89845ff833cf7b25ef172
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c966813ea1206abc50a4447cb05cd7419e506806
Message-Id: <176366522189.1750999.1155185347979582811.pr-tracker-bot@kernel.org>
Date: Thu, 20 Nov 2025 19:00:21 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DFC6440025
X-Stat-Signature: 675wfn8szsjas9w5g95otmuuyu1fu8qi
X-Rspam-User: 
X-HE-Tag: 1763665257-847394
X-HE-Meta: U2FsdGVkX1+GKiQG1jwMHkINbv3aRwCgqvX9/3KYMuqaSgN8W8OfEia4+AQH0Ky6pwyWfrL0GiduFrEw++uDwT3jJh8CE2zk9LyWeqwxWIp/qc0IuFnOK+GErePE8XVGLmUCkbj+Tzs30iTJYZe7iw60jsouNtbr2nDqGtqUpIxPYC2+0IqImCNeUzGIprAcHdTuLlIRHTscgquOfB9KGcnt1UcpGNb2xVDKoV/5gZ/VV4TjWhuFoVzcwufTfXfebnONSv5CDlaCwwKjTJGQGo3XWCj4x7ebUjcBuFmgBLvdkMxzHWSRHojcX58m5tPmA6ng/MPgTlkD4Rx0XrDrRMIVkSyrlS4mz1QXtzc5Q6Q89MO+mE0NRwSMGY+ek91UD/cTTTjuyYHDv9UdD2RXOqINN/DGMFIZLR/kPHy4Xw6uY+z88pELKopUJH1p1L9OhR3ZMrXbtf9dTRR3HaIs0MLZ1wlF1Y5oXtQ2WBiZ5XaARiHqdyZhjyZ4ocLpAVK3kg8IyyTPkEHdvIAK7KHOv9z3quRglr0M6Arfdm/5byj0BqVj4uCOCeqh2F0AUreX6yx3X3TZZFYWOq94CyG2iCrbYBLpuSqSvdzzrmVqGm8ICz7kCb1QgvSz6vmVG1DqY+fbDAr+GVIWRPG5SKRHriRe96mli/01PZ5WF2+d0Rl2vUndAhrT8UEG4Q+yJmmF1xFp2YGd7JOEKafeJz6FFyVOx5kQYP0Zu337w/4ZJ3TWzB21RjbwLKurSTfCthU0GO/3ZbkhE5P6p7mDtzcX/o1iaERiGFsFW8508hPnJjAy50XkRmUDWQN5z0NhdOXYTbRu7Ic2VB1hFLPgcujbnMnMTy2Z0G+Ms3L0sZjuqTeECHvNDBOnUwcFEL5QRAtAhTjzxzalJ/E4J4kc2cQnGvCwdRY/HFzj4AD0OJ4ff6po2+XRbiIOabL9fjQ64CNldZpcThiGpk1XiHl626D
 xYqm07Sa
 0MjD6mds/AQSJfALXktMBU6/WkfeLbrkIiAQ/HBELsvWxLWzeeT0731G2vAvKl5ycjhArBwSr6dQQwWAKY3lYF9+qMH28aYlq9JWPEozCKxqvLXxODfOKrvAJEJEJao/emxyQ13hBLY73Dd7Xrq1iJt6yhwrNmLgHJiz2kYiONpCFR4Qt0AUdEPr48IcM+P/do2+A0dvFxXpar4lJeXcvUtXGhjgEm5nuHbNGPqLfcz/VZdai2y/9SJkFX7O2e7tdfLMOVJTvIZF6QoPSeMtJ45XO7N1zHaHmkdvN2NXBPZ4DtTsTa1O7hslhtaTCmqLWOXNz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 20 Nov 2025 19:45:02 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c966813ea1206abc50a4447cb05cd7419e506806

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED76CEEA850
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB236B0089; Thu, 12 Feb 2026 16:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4746D6B008A; Thu, 12 Feb 2026 16:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36CF56B008C; Thu, 12 Feb 2026 16:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED636B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:00:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6211140307
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:00:24 +0000 (UTC)
X-FDA: 84437022768.29.2187C81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D712D18000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:00:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFKV2XFj;
	spf=pass (imf16.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770930022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=BVfVe8foWRuNeksfuxyJWcPM530a+a6hGeJ4tddt42s=;
	b=buR1Xc3DuFUU8EpS1YybEY2j5xaYZxLrb0JdYTB7h8a/hc0FJG/VcV+pMqCjwclpf5M8Mg
	LiOdpmKWgviRJQL9zLUwlIHjcURwbC9rHp+e2eXXctDfe3eO2arbGLrWMKzKTmL2/5qIjn
	hy3AYbqGkk8YusDE2Gj3rL3J4opEq2A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFKV2XFj;
	spf=pass (imf16.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770930022; a=rsa-sha256;
	cv=none;
	b=PWRvi5pz0lwysyVmjInb5MobOyMKFV6sgEpw6lRBkvdkO9t1cUUJ/iZFpRxSh/6NfbRmiD
	zt9iOixZNhX+EJ13w18tm2gDFre8bkD55GnfacbalXwCJoZrqLMZk4x5K3sRECKcjECmLc
	f1uZF0xnJMjdGCU6GujKqUx8Cird948=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 299CA6091C;
	Thu, 12 Feb 2026 21:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26FFC19421;
	Thu, 12 Feb 2026 21:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770930021;
	bh=V64I1236CIfrgUaqmjRGFTjLIvjPIpIm0axC06vlKX8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eFKV2XFjiY676JVAmRjorHshK1QZHX9irf2LGJkHXf731tGNGMAuC/sKlCn5Jvh6e
	 yFx/tRht1y9cRmRTKNz60K5kfHgkRuWUwWqQUvEflGTs1NvXEC1m8qXzlr5at+Gkgq
	 v+iBYFCNa6jlMZ/t0ajB5+2GUW+tn7sE5TMae7fPrmUNQUge26uUE0L3gzpGpvmnB1
	 08OQvZZo9YnSUMBwooaD5500E/VzlyvrDHMHkj8qYkAz9Ais/zS0eyDXqtEztl4K1l
	 T9OePkOBWSqb3A2jDHPwQvh6jUB+LkHtJEx0UW2MWdSK5jhgX/M3jziv31Y7ci0o1L
	 NRTNJNj4rHxDg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5FC9A3800347;
	Thu, 12 Feb 2026 21:00:17 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
References: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-12-10-48
X-PR-Tracked-Commit-Id: 0dddf20b4fd4afd59767acc144ad4da60259f21f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 136114e0abf03005e182d75761ab694648e6d388
Message-Id: <177093001626.1706748.10510676231178541216.pr-tracker-bot@kernel.org>
Date: Thu, 12 Feb 2026 21:00:16 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, mm-commits@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D712D18000D
X-Stat-Signature: u8ny7ik8oy3kepgzj3erguroiiwrgiu3
X-Rspam-User: 
X-HE-Tag: 1770930022-520059
X-HE-Meta: U2FsdGVkX19BZd/fC9gHSxOt5N+RsoGRuJr8MXq6U3IK7eTVcUkX+O7+uEWTkuPmmENvlxR6LPe2VMBMI6ZIb2DNTdtyrkJKxEB3GKW/K3dil1ebi8JnepxHpQwtCpRE527mBZbPU3k/y/+25vP4O1vQuTC8+OXkhjyN5pauizGkmhVxGbcMxN56js8Iwm16+R6QeTbzlSPFANIW7sxuqbOzwpVxxgmouVydckhldV71efdPGbdHH+k1fnp8drp010T+elWBnDOf5OiZdA59b3KoZy8opNh+a/K3c5kLfgTtEGeqCz/IRXoUAYHkqGJj75fIBqBi2IBzhNmwczMBoGeKiWwPAn4e4RtZflqeJBPbOxHTV/MvfgfD8+ZS3TTvCvuA9kIfw+rjXiJ7gQVhaAPoDa6NEJ+WcEl6ohBAb/V9HK1qSpCxYZA8w6pzIDFTran9TgSswKM0z5g5v7vaIsa6HLoX2tLS8xqimBxnhKzz3aJXx4e/ZTrT9ShtYEboXkAFvw5BAF4Epe94VqNp93hC5DGC3Qb2hqoO4sYevmiUn7UC5XuKFhIq6ucoXhelDdSzy+gEE41dJPCwCc7ulH4nOQX7gV3ayEJGPikWMMJIoywEIHozfigIPV1SOxYfbJxuIzHRBEnGKo00XDaT0106XumvUwW6MJflk39hEyAWf1NweT3g2M9pxIXB+J7OWa9kvqMy4Aj0qTY591C1h/hY9snEuGacj3nVjuaBp9TwTo5dyKeEXHlP3/E0m5TySoAMlBC9Vj+cmwIXoP0cweNaU/w4eb2gkVZOqWVQ7eCkw0tA+qmm8y+UohDjBeM152bCnEwR/7N8TCHsXvYenz09leS3KvcotFv4+43BBIyAmZEf918vKafS9Iw7gOZG/MTmAEKg6q9QDUvWYb0BM/iY2MyYZrFb8kHCk3g4C2pmsoWNFUyIo9UngJmj3B+ZCY1m+ahEzsWmIVVGD0o
 vItyc55p
 UAI8X/+NOKCkw5AnbS/VrK4MvIUbhuwY4b4vLk8kJeeVsGnFoV6b4MgUq0zgWVAm3PPGXhfF8czOoH3SVG3SNMkGIa0/ycY4a+OZIs166IO7nRrzDO4qpP1fx6Y9l2eWJxK+R6JhXxn98WlGhM25GyYk1XLvOEZ8jkYQHYq3pha90hozN4LVvFuB8mdl+9O0KJMpCmrn8G/dMN4zpdBSL18Xaus76867O8/b2kNWfHt8ESp1JcxZQKH/mn9VIL7hM542sEViecfCoTX54/9S1tKNh+/LmdZHxQRblK4i5+rGh1/8g2upD5TkLWLnHOm+z9PZd6Gqi5+lCsYx9wJN9ZF7p/3Byq6JEnhpVYBGNk4WxVSXrNXhnJc7Cv+99HuXMXisvQ48H57PGzZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 12 Feb 2026 10:49:56 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-12-10-48

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/136114e0abf03005e182d75761ab694648e6d388

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


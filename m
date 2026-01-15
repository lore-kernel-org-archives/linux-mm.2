Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A463D4661F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731DD6B00F0; Thu, 15 Jan 2026 15:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DFA66B00FB; Thu, 15 Jan 2026 15:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6094C6B00FC; Thu, 15 Jan 2026 15:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E24B6B00F0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:13:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BF35C1D51
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:13:23 +0000 (UTC)
X-FDA: 84335297886.22.9433A46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3FB571C0004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:13:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m3N/HOct";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768508001; a=rsa-sha256;
	cv=none;
	b=GnJfNT8dK+1crJhhMQ0eUtrqCfmoze+Tgzqn3pDPksUO9268pMh/T08r+KVycsOqDbP2Bd
	EDzukkLge3Iaee5eUCycqb1WdREHuqfxMjvAOtsmnqaoXOBDbOESa2PRYFnQpEZMpp+2Xv
	QevjHXZNuEmJ5IsLJVhPxCqBoTw2gqs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m3N/HOct";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768508001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=bYmKAewmxrz5oqft9NUoLZVqUstz+yEXA+Rd3ez9C9o=;
	b=6AMfUgb8XvZ7F97RiY5dXd2gj4nq5Prq5zhcUh383KYIzUX006exUhS7axgEmZvfY0ckOu
	NYHfDHH/HrFMCtQnp0ye9tKy1QeQyDUwhNtVoI0AGNZnueJq5xojY+GRuZFiK7cR8VwPen
	rptDgD2wfTXWZw1aL2T7Mhk/PeUm880=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4337842155;
	Thu, 15 Jan 2026 20:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21474C116D0;
	Thu, 15 Jan 2026 20:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768508000;
	bh=DyEw4wdK9i63jquzZL/QXi85unjtuB7rL3sRfLLuuhI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=m3N/HOctEwVHBtIRawEdgcshJHCWMqwlMAMj8EkHjnJXFivVoJsfDe5HYPYObE0t+
	 mYgO9TtzGevBv+ELLMs9N7fFzAvMRwjRkN0mWVT6FuVz4px5NO/uZ/LHPfwXnBiK2i
	 zgLJr4WJG0SFrHeeH3nusUr7uU1ZHi6wyRnLHPLh6aqRg8ze8d8oCKstPlOujqwIVC
	 EOIG1WzF4TfBqkKSyqbkuuMU7v/cVs0mveS2ePko6Ydj94oEKUaD+WzUeCUw3OY62i
	 p7lT6oaSKUOo8kWgcY0VtXs23cMVk9ypY17dNwtV9jtHHNbm1H62rJM8hBugJoGnfJ
	 BKNCxI40F/CXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78E19380A97F;
	Thu, 15 Jan 2026 20:09:53 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.19-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260115080645.3744d9e4178884f988d6366d@linux-foundation.org>
References: <20260115080645.3744d9e4178884f988d6366d@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260115080645.3744d9e4178884f988d6366d@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-15-08-03
X-PR-Tracked-Commit-Id: 3e8e590fd65d0572584ab7bba89a35e6d19931f1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 13b2d15d991b3f0f4ebfffbed081dbff27ac1c9d
Message-Id: <176850779212.4151234.10322330701377620588.pr-tracker-bot@kernel.org>
Date: Thu, 15 Jan 2026 20:09:52 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 3FB571C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: 9snfwmegccn6iup4b681n8g19t3co7p8
X-Rspam-User: 
X-HE-Tag: 1768508001-626555
X-HE-Meta: U2FsdGVkX19bgbtW0u7fbwNzF20pK+lQO3epvW4ntE3sSq4h09rCIdx8H6iZuGn3HwboD0PceyBsI29m+sLxwXje3IzOVllwouhg05qJsnShF3Dz1UDkFLAQAgkcOxqZr2b8ixh+aJxhG7vatRdMGFJolBesWpKNyhybniTvAD/x30WAJikqX0Jad3BIPxG+XEFld5yaUBnDUq5NBNI/57x/juTE2aATssJFWCB4EFtyGcMCFqAYWtNkXuaMQK5Yar8PNoK82Q4l0dYMKNx0tgsjOUpZvB1vE4zC+IuLE5MV7YWBiGIqv/j61bKfOlNKVTiF9QcPbMWuPTp7n10VVX9Bld1KftddQ5v5m4Bb3a5HdnfEQ9XbJK46NHOQkmKAXpxsQeSRAD5/NQDjUA06Q9yWIzvFTzd2QBi2fmvczGk6RmWaUQaGytfgA3hdLNkV5oJcPqPqS80G7UTFj7a+QH0r3rDPnN0dDsvVsaJM4j1clmlMBkd+ogF+idxAXQ0l1/36+NwiMSM/JIHkx5co3zZfhiLsOG/wqWZTFtkQ9AEzlDPqlsq2xVESRyhu0cwicgJya/tORv33v3UfdgyJGA2WfzcONYG9JZl48V9cQEqwLXw0vWsLmfRVhCcYYJg90QtMFsf++7lGD6qQAM0C2JCuhhJpZTJzNv1SFSysCbZVKQBjzXjAzYJjMZOuR9/r8gTXJmB1+KxCrnU67MTez9Fnb6nIIhz3KYXypEUr6Za8GviE0ILmor/jFGqenqMjuH8KfJRqSp++dk5xz6n7xFo3Fe21rAsoWHsWknG66hv1Czx6ckX6cB4GtnUnnhoiEvwdryAL9Sh5lkCyOOAiPY6amHtwpTTGR4sGUXNHS6+V45F+iYK4L1F/qJCAFtaq2DobnyqGI3hC/5tnXUCTxFM02OyB5qAEOJloQnniMfuyTeL9f1h5qCqYvdX0a5Gtt2QqcbgcgrqUJQfSZFK
 AU0yJ9pS
 nrkgt33D8WLycOit63FbePvRk6Py+eTpTKOdA5F94Oox9EB7CYOVghuOpejTS/mSfJGys8qdjXMH25Z4AUnXmgJoKZOxDn/jhvBYyrr1DbZnJ6cS6MFBCDOoUFa1Xg6tR/gQXt4GtLoMEj7lpmrWHbqBclPP4UJ6M4/QfJbyXEP4ubE1D3CKRz7wDeZHQohvjfUgq3hpTeq74Omv7ColJT3UusxdSDGX9s821uxbMaoIm5kecQbrbULPpAnqbg69aldJ8q99em+tgBAevSg1KZ4dl/eC3MiW+M3uzN/oSN6ndLrIA8B95p7g4hfdddIDjwn5h0XYByXfzad0lcWW4M5/Zv8TOU8RU8dRZXGwZKJG+gRQfIc2w0oTGULmknThctefaOLvWwXWse+g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 15 Jan 2026 08:06:45 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-15-08-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/13b2d15d991b3f0f4ebfffbed081dbff27ac1c9d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


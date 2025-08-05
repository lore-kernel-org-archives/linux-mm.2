Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50DCC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 13:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE0F6B009A; Tue,  5 Aug 2025 09:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277A16B00A2; Tue,  5 Aug 2025 09:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166606B00A5; Tue,  5 Aug 2025 09:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02FE56B009A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:40:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7885F135CCD
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:40:26 +0000 (UTC)
X-FDA: 83742813252.04.25E4D6E
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id B536240008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:40:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AA3YcoFF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754401224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=hfPMKYIhkvnvFNk7Sbkrl1UPX6fsMKMeXpaL9xSWfZw=;
	b=bNLnJ7s3b040pbuuEwmaCZNZVd3J5yI+AdALkPQyeIzi3RzfOq39PPF6pCF1DX9IDCw5KR
	WJUYxGWTUJbja93fQVpbDJDZ+lMFnhHrHlVqWDIlIarOx7yjqYBJ153BA88aHZRQrd655e
	UHEnV89y8xdKV56GZC4kM2Ovmhv/ddk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754401224; a=rsa-sha256;
	cv=none;
	b=KYXL7GJaXPWtpIBChBD/HoYaR7Jd/jRGXcCRvpaBqG9uGTAKGOVw5t+O3NtKJszDTZS2QM
	iVChMcECLZjTWXoko4NBQtXKj81qsGb8UCTAoyYwan69Bzyavys+jHui3LzMJdNKZI5O1k
	/7XALUWeciJh91aTuQjRriFnz2SGWRU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AA3YcoFF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 8DDAF5C58A6;
	Tue,  5 Aug 2025 13:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386A9C4CEF0;
	Tue,  5 Aug 2025 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754401223;
	bh=bb3JgIx5onPUl2cZwI6V/I7YOYcFnp3aaOkl3S6nAnE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AA3YcoFFaEPVIICBB3GrrT6/hOw8t35kpBTvMwnXCDqnAOeIA4n3XBi1TQtdKqjjA
	 AztAAgwOWtYv0nqQUxs0ScO9NfrBytd+6xAOkGTWoouZaJvR2xVv/48tQzIForSr3H
	 a+TJsNXBtpXR/0mMSTLPTZnweprLg12hKbNE1sI+gPwouRlpIlKvsueDwrbXINOQh1
	 euoR3F0VmMszcVKtOXc90M6Cp4TPQe6grqPpJmiRjTnB0htoGhtwkAYu5QVRcm3Nh+
	 WRF/Lc/Ue3gLmF8/aPADZ9wpVZtij5/n44aSMTwI+E3LOhdGZQy6QDhA+JPuHMHUZn
	 xOmxDIABqEShw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 74879383BF56;
	Tue,  5 Aug 2025 13:40:38 +0000 (UTC)
Subject: Re: [GIT PULL] Additional MM updates for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250804185852.038ce90aa6f9a177c492b675@linux-foundation.org>
References: <20250804185852.038ce90aa6f9a177c492b675@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250804185852.038ce90aa6f9a177c492b675@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-08-03-12-35
X-PR-Tracked-Commit-Id: a2152fef29020e740ba0276930f3a24440012505
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: da23ea194db94257123f1534d487f3cdc9b5626d
Message-Id: <175440123814.2024406.414993637909226297.pr-tracker-bot@kernel.org>
Date: Tue, 05 Aug 2025 13:40:38 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: xij48i8jjbo7p6ho6nwxwrs49r8uxgb3
X-Rspamd-Queue-Id: B536240008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754401224-42482
X-HE-Meta: U2FsdGVkX1+O83poX4Zgy9WJqkKyDtq4Aaer14UnHABwdcTXcl9cFy7wOUNYYDOiWpA23Lri2oikcZjm/GWQuTZxkGpOjwW377T3XtrbejngnNCUEZy/4eRZB5uReI37DJo479DEyT6IXJdnWB0adl769j7m0F8EKklFN3JMQtNth3vqYwNfusj7Cj8KqoWvH9m8UTkEt62TEDPe8JlwicEnF6p3664ePolREEIy7fn0CDMgqkot7cD3nUW5BcGpQOr9f9Hjl/Zk2WWq3AkNB78r1jaoI939lLxVgYBhClGN/DGc4xAkO6Tzw+u4RzdowH23Xgewfxn0bPBPWyEhRB5fYR0BTxnMOXZCmYRfWkWrteb+IpdSUk6061+6ndqYmLoCLZZsqUqp9pWFkm/AKDLBDpT0Mx3d44pa2tZQ4T3FyKZ7ooJswUeHgkKDILUEYJ6Ysctrn/XndYEwUnyIGHAwTa56UdzoxGTmj1WPq8d+Zv6PyuVk6NtPAS+hjvXtk25G7KFyD6NjlQSt5sbXo4Xn8BJB4XXc7RC0oeGlwqTGnxHpuKTLmRYQiB+H7xa0lJBCl/W+B97cBnL/2To1sfB7O3M9qnKaYEgmXvcAF84zK/l52SA55fKDrX4TtolBWHmvRXejMCm/Q7Mk5eGY/N0L3TpAq4BIV8U4wA6LEcNp9+8//RZYXhG9SHikUNatoQUsxtZNqPKdr/RZMF0k/0N5UI2dqRCJ2pG1FmfcshfzrR+Okd3SXc39Y8m/GrNL+oxNqJlz3AqnR2QqOoDMYML2q1ztkACeaNRoSgUhqw8KDQdDIOBBSiIaYNvLW21nNOdR8mOXTsnmv7nOjq39E7tu0HEZgWfKit0N8zyW7sE3sOjY3ikE/ZPfM6b5lAYwleZvIQFEk7BfCePsyzszSyU6Ch0z1Biqc8A86gWzBEPDxVI7CCCGHl3flzPY/+U3WHi/BrD+5f+hnvPiHpB
 rFIG9ohU
 0H6OjdiXe+EaVHzgtBg7D3wZWhRbrBNIkZ99/dGCOk66AqwSU7wS9brnatY70AnT0N2uqj1+QAf7eTI4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 4 Aug 2025 18:58:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-08-03-12-35

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/da23ea194db94257123f1534d487f3cdc9b5626d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13659C98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128876B008C; Thu, 24 Sep 2026 09:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8F26B0092; Thu, 24 Sep 2026 09:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FDD6B0093; Thu, 24 Sep 2026 09:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3C896B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:32:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B322A038C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:32:43 +0000 (UTC)
X-FDA: 85248745806.12.94E5F68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 953A920004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:32:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XASWSYle;
	spf=pass (imf13.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790256761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=rmAO1mDlJDIcWdfL3VZ4kivpJ6SFPym2jsVT6xZ2kIk=;
	b=xGrLf4G4jmTcU+Ta9lOtD2NnSSrXn8m7dAipYFM3QeWKoNCIdVBochLwkUJT0R7AO3isXC
	BvLfnL2U0QKhe3HD9rAPgmwWrwbUnqRxSISI4Qte/uHxlekTbqTmO6BH8fxgg2kaaVY/FR
	BhsHgzArPppjYpOeRAKa9tBlojwKLi4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XASWSYle;
	spf=pass (imf13.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790256761;
	b=CVMaFxElUtQ/sBS2ab6Hh60cOG1Rkja2EYH3KZ+6P5hixi3qyCnNZba2Ad7ePAyS5vQ7IV
	+NtTFulQ+j2LUcGQrvYAiU4rA91/tS7Ksl0Ygaj/esUmHJ2YSIw/HDXUVpDmNWhwr2ZId6
	RM/lpwiidUZ65iSaamFgcqm3sG/Beyg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E1CA41B64;
	Thu, 24 Sep 2026 13:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423451F000FF;
	Thu, 24 Sep 2026 13:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790256759;
	bh=rmAO1mDlJDIcWdfL3VZ4kivpJ6SFPym2jsVT6xZ2kIk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=XASWSYle/lU9Z/u/2vIj7U2digTZPh3Woko79BXNlkYMizE0GltCm+XWKkzS0iR/X
	 htq5sqZr1sa8X6TSomaOBJbSOI2DpbjZezFgx2pd9XT6R6poZSGx+AWikBUxsS6Rmf
	 Splhj9FDwL+m8iDpgbArgtSd34FWWRjoh8ywnQIATld7unImnI3cQ7KXUyOYneU8rG
	 tPSE0+5HrawVSw0zX+8X1xt7GC46QPYms7brDGLf4P5f34bBmS9d2UOr27j9X3XtNY
	 iBxw3CgVZvOyQd5trPZnDk4W7iG1x5o5bWRVBxAbyz9axriUspQZr+AjihKTuejBFV
	 Pa2Wip1g7hJpw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939FE39FD333;
	Thu, 24 Sep 2026 13:31:29 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: add missing HugeTLB flag name
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260924073316.2325178-1-rppt@kernel.org>
References: <20260924073316.2325178-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260924073316.2325178-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git tags/fixes-2026-09-24
X-PR-Tracked-Commit-Id: ba13f1f32d96d7ce9069ae4f32404ecde8da89c4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e2936d228b96346d474f368f1bb0172582035577
Message-Id: <179025668828.1550318.12391350899948810959.pr-tracker-bot@kernel.org>
Date: Thu, 24 Sep 2026 13:31:28 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 953A920004
X-Stat-Signature: z8or4fzhhw8ybnu916zceft4gjtjoif5
X-HE-Tag: 1790256761-723064
X-HE-Meta: U2FsdGVkX181CMPHh28dFbs9dGTV/FF/BHDpD0UwsCrsZ0go29GkxJWlP+ondi/RsNWq+BmQT4tJlPq3NQXwLKyRymprVLYnynmQdpMZXN2wYm+7PPHTVrV2aY+pQmg/PrKJz61eB3p3z7zRPXbV//D49NJsBRE9KuopY1V389RaPJcOSqzNwc/CsPPittcqzGpD3WJGy7gpz6E34hWlXzSSapDgAaojQoxAYTxpfWRW0bDrtPa+TyYb7vb7pj01rzHZCE0oxSQOd3QBWy8gPjnW18bufKNJ3Fd+G/Z3MJithHtl8A52ChQByDsPXUGAOX/doYVxKln2jDQ/CL2YzMz52YxlbdNNaAFz6DTJwM9uDcsJnI4vAWMsQptsI0/2YZbgsaDc2c6W2zLLwT4bbFCJJSYw8aPBkPb5ZTcOsw/PNgI8gkJ8znnbQf2PnZmVrkX2irJNlL69m2WH3YXPlCxCwHjR7s7fxBcU3unxqKBMla6nL7lx8srs0UYHcVM2vwbLwd7M+UVkt12nC/7Ujo5Rn9DaiMZ+WktMyWmCeM+sQC59qw11j5VgdO8SaTAoxFW2bE4H3Z2732RIxDqjnl1KrCiXT5hU0DUlBEAVtwk1kjQlHXE3ZRPy+6yjXTMUvNNWAZuUk0v5JeFe3aNn7H/Bu/JfITkZhtNrYWn4BHexreskX5c4GZkADNq34lmYfA5zBbe8w04J1r7AkUMseoseOtKqmtJpM7dmV2I5cmbSltXBv6eH2T/08osxvL/X3XHeflCh3fOI1IQuvWYIy1j73TKzJIEkC0W9UUj8UQ2aBRAELuS/zDJ1yDF0Ewp7ESG474kSj38Wr+i5hCW9eQ1WOcZc9LY+5n2oggk/TDJ2Cwy2dppY6+Gi6Xd55DqIWZvUuKzPrtYDqgdM77w9NozShyOsm9/CRzIkX+zABJRJ7KNiHp9UYq9PyaGaqblYweAACZTb0AdcL0q4Jgb
 awvhmpWJ
 r+ifPvpobOf+WaBSqntXvW/tORneLX8PGxyBf0J2bLlTZAuDb9lqXib9mBp0AaDkn6cbq/OZalZN3P73jf0xjrdvo/jgxn6M1Y4JX4aILImqYWZZFKihfhyQwUBIDZzgu9zYzWtDK7rkFOWfhCORL8X3dhFLgeZJj/R+XNYeSw2rcpsyUuM6q9P/TZwczfCkqwaMlzOwgVWNMmntNB2BwCT8FHRUV7jJidWP5QOGWn4AREx8eeJxHzqLjf3poPxp+cwLmNyFOGRKO/q+nTKG1f/5XhciGkyNdwsxXchVCX4PUpiGAgFFMPRPMlzvUX7EudZKusS3V+uFmKDbygNL4mBY3XYO8mzTlbKFZ25q/3YJutqwovrX0kY/yzr11jpm5k6xJPShKFmHeX5vv7qtSUiCiPCLF8qqvqaXTM+IuYh8gfSrpe6kJ2INICg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 24 Sep 2026 10:33:07 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git tags/fixes-2026-09-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e2936d228b96346d474f368f1bb0172582035577

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


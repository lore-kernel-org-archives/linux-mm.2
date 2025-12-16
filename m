Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 177A0D5C0CD
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BEF66B008C; Tue, 16 Dec 2025 03:07:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BEB6B009E; Tue, 16 Dec 2025 03:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2876B00AE; Tue, 16 Dec 2025 03:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52C3E6B008C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:07:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0347E60339
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:07:19 +0000 (UTC)
X-FDA: 84224604240.23.EDBA25B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3401A4000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:07:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+vvzMYd;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872438; a=rsa-sha256;
	cv=none;
	b=XXJFho2wGIyybjtdpDAuB8aiJRrPDd+k7sQ/bjK6/A1xZh4zqx0bNkOtXLpyCbpLyrbyrh
	1Ww6WBDDY1K4xgx3spcYXXkL6QiW5EJO5yYp66fz1WjklBTRqxmM4IJD5Fm+YTTcbnepxZ
	ASsVrwvUUSXfK5dDxZ2/Zyu+xkTEXzk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+vvzMYd;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=LXLFZ+JtfmSrhEYXIkUeejuX8hHYQcLnW5/8Fy13Uco=;
	b=XL+S387aUTMIQ8Q7touGvCxOB097JdFYXM8AkF5NNczV/mbPApu0XXBoLv57s34aJihO5b
	QrEpDkpJBx9ij9Ei+ZO9iaRtNxxbI/TbFKLAB1jY6LgBFsHhQD1HfQdqgZX2g3SsbsdpZ2
	lGEkigSCPKrxPbLJzgVFLEIgNENo9n0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B1CF43D6A;
	Tue, 16 Dec 2025 08:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D98AC113D0;
	Tue, 16 Dec 2025 08:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872437;
	bh=prl0xPcs9eTAp3WELwBowrKZC8N7y78AAhNo8WcVa7s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=b+vvzMYdPweUqzHvcvzItdi7UfxBYhBENSizk4F0/GcvLl96119F6dWS+yXrLe2da
	 iHR3lmkUN6aG3TZouXwDMaSwpeD7YpEN6a8iomyPD4dPu1Kf1iXbBQcl2ygcWqQJst
	 upuhy/gKAeF/stlKjjMkbDO9oYQb10ieuz9zXwwvv921yzr47dT3fEJiarCP+hQB4C
	 itjlqS7fPw1vK5QN8iXjeWnwvaHZiXMNN5bPJPfYj8sbVBRZMUHoEN0XJG6IZw7778
	 FM98+LJ9PTjGgYgFpUEcj//NxF4FH8hP0N531LvKH/nvG2PrajJP+7FrChvqG3Kl9N
	 OfNpT2+I+mICQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3BC31380CECA;
	Tue, 16 Dec 2025 08:04:09 +0000 (UTC)
Subject: Re: [git pull] shmem rename fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251216060257.GP1712166@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
 <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
 <20251213072241.GH1712166@ZenIV>
 <20251214032734.GL1712166@ZenIV> <20251216060257.GP1712166@ZenIV>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251216060257.GP1712166@ZenIV>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git tags/pull-fixes
X-PR-Tracked-Commit-Id: e1b4c6a58304fd490124cc2b454d80edc786665c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 40fbbd64bba6c6e7a72885d2f59b6a3be9991eeb
Message-Id: <176587224785.917451.17926462470930519580.pr-tracker-bot@kernel.org>
Date: Tue, 16 Dec 2025 08:04:07 +0000
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chuck Lever <chuck.lever@oracle.com>, Hugh Dickins <hughd@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3401A4000B
X-Rspamd-Server: rspam04
X-Stat-Signature: kui6d3hry5fq1ajrjc7irxi18ynuwzou
X-HE-Tag: 1765872438-368324
X-HE-Meta: U2FsdGVkX19NVqvs+z1sLHsOdyd/AHnvSHzcfYCBF7Or37Yz2s/jL6I44t6RNdpAlCKotUorsTQnlXa/B1KciSQkzrfDchIKPueBm4XyrGsS0MzabTjt8hQyYXDN2zQwoDTpjGq42OXhqC30yRW/cqkk9hWAWFMtq6whNz2yQTKxZ+/ibA/3qPXaUiMhVqw0PHmO+PAst8guKV+7y4qYMaoE01xIgqCusinz4uEFGqprBsW4v3XUM59DE8vqh/RKQlZDwpPuzNUE/u46a5ZpODj6YMdPE42hlKfdBHHwDe6IHRYUoS3IIYX95J4R71NhHPtAlotX1OjwDpQYSfvMUz0U75sTZPXNNS+R1VdBXRwLXFDrth2kvq2G30KeAEOmKN0WN8TGiXOZfBalpcJEiWQCe6jqWpAwm272jYvQHUiyd30sdybVNYW22Xr2EZ/zpSd4Q/3nRNcJ3sCgNmFDwGJNaNhkyvpXYs3U52l8Yrxrdt4hSwYlNYsnAhkB89WLYps/cbjcp5XsNVkNaQCSy858rVLME0kEGF0uPaEb82DYBjpvLoxtqgXqGBWyD/9GOvRF/m2uSJCR/V9KcgHlasmqJ1fxQR1AzemuUi0SJbMJPECmL/r+bjMiaceZjlHLu1QQ6Inb95rmgTnv9Jqm7SswkE5Otmr/MrLcm/9DsakxUmrzfBezKmUqTrV2yts//KzGq/TKMU+hfrBCTut7UOEYTOmYAibwYW/5NIzMRd8enhgt2n/dhm2zi4U4WJGMo63qy4VJexN3JwiVWl3MVdKBYvXJkyGS8N+kdMXGHA1zbL4l/GI95dKsEuS0Rj74tAV/YQ9dW1ReyCU54vpDW3BuW0IR7wXRL5zIRG9vEvzJ7ziPuYuiuHRr73wLfBZgCyslgTaz61QKUIn2r1V2Yu4WcZ7qxYibG/0dkAObr/scEZ2e73Dsr1GHvwOdAFKcb3fp0E0BgoSgsKLeI67
 8Q8tO0oy
 0+KJy2Dy/n7oUb8kJZywXP9NuyaW+BbRvpkB8PzCn5CaF0L09xScXWZgwU8QIBS1b4a4S8AoG2bDObfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Tue, 16 Dec 2025 06:02:57 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git tags/pull-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/40fbbd64bba6c6e7a72885d2f59b6a3be9991eeb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575D4C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89576B008A; Thu, 31 Jul 2025 19:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39946B009C; Thu, 31 Jul 2025 19:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28E96B00A7; Thu, 31 Jul 2025 19:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE2EC6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:46:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 733E6135410
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:46:53 +0000 (UTC)
X-FDA: 83726197506.23.257611B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf24.hostedemail.com (Postfix) with ESMTP id 917B8180009
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:46:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OgGhgrEF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754005611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ZMOzr7pqZtrppFljC18A6bswb/Tue5wljrWgMUW83f4=;
	b=fe3FI+/rEnJbzhmsreI73rfOzRUrZLwD5Me44F4YLq12zy6CRCmmCsUP/ihfqAfMys/Nnw
	IE5B3GFVQZsDPaUM0YBtySnLJ93UKHQq/ByiTWSJ/7yyKKc6jfUkXiTDGEv4mUZiION2Yc
	VREDPiht3m2r4OzbARi99PI+yv9aS2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754005611; a=rsa-sha256;
	cv=none;
	b=jANqLtGbsJqg+CSfQ0I3YDteoFtdRVdqqF8ji8cWMTSuu4kr+G/7wHc3jpok4ogZZphfUO
	ulOiiK8RpROXQdeD3UC5xqmLguX8OYmZl4MbDlmxMmFx/tn+QLarMhcBRCEdiADuyCKP+J
	2BSncmxBDpyg/8uTZ8HQFUHqL5moylg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OgGhgrEF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id BF1465C6620;
	Thu, 31 Jul 2025 23:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8FFC4CEEF;
	Thu, 31 Jul 2025 23:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754005610;
	bh=/8AimOShOs5/QptszMVNP7lJiKeFsOBtVZXlzHQ9/Wo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OgGhgrEF+3FnRkKZf7+0/72jB6bltFGUkwPZVTmRsslG/stkis2vjybypcqcoGOsG
	 3e4saSKRZdMRJVaGxAnrng0ZrL60bTQNexVDsolDmVVJKRgrBbcvUMYPUngBz6YCqR
	 AMkCXBqtMH+39BBZh7r4dxlSvh+m9LUURuHqJ5GjelqeygFifYGiCYA3+UfFq5pYhN
	 h0CuhhYsKjS77EhUj0qnhBQBZtF60eL+xwPOphR3B2fLztXchn7O/ECIZ5jGTjX1Y9
	 /I4euSrBW5cTBabarH0t3N9mDnBFubA2XYnzZHwYCVlAK/Swo3Ll934h6bpnAPfwrs
	 sBSD1JuN4GsOA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E01383BF51;
	Thu, 31 Jul 2025 23:47:07 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250730152806.16f5c618e3af0d3b8dea3159@linux-foundation.org>
References: <20250730152806.16f5c618e3af0d3b8dea3159@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250730152806.16f5c618e3af0d3b8dea3159@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-07-30-15-25
X-PR-Tracked-Commit-Id: af915c3c13b64d196d1c305016092f5da20942c4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: beace86e61e465dba204a268ab3f3377153a4973
Message-Id: <175400562579.3358753.8024804640119746893.pr-tracker-bot@kernel.org>
Date: Thu, 31 Jul 2025 23:47:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: bnzdm19wzfdui7qch3yuyuds78cokxxr
X-Rspamd-Queue-Id: 917B8180009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754005611-595741
X-HE-Meta: U2FsdGVkX1+7iRyRUGMENd9xwIGNmrrBwa6tgV/yLlQdJkRWVxFjtR50bUwDX/G9LoMzyVHNZDEVxIASD8Wk339zZYNlTKRoF1E99bE9g/SOwk9ih5XsyXN1bmMn4ntWxgZoYY36ONGBGdSef3/xaeNB6BNZc0fgLnSEPZMbGig56U8MwNeYeQFIoxvxzvbwqi3AN+n9BC74AKJ2A30bA9B3jYzUsvRhStCx/ul8V633PuEnU7J3ocidE29Mg/yOKmsbLc3Fit9KYmduzLs3n93h6oLIpuiUxtaTPy1E/MzSaYULOZT4DLRU+AFXaM5mUSHxFRiIG7Fu8rUL4r4sAXqal5k8IHl8XkuuqTgbZ2RcO45fvnCFgYL1eTZz+1Ck58DBrN9u19S4EJiKAlpaPFToSUdsx7s2TOsmPLpmXrDWK5IYbQHZ4CJbPGb/JnmDQhTA0qWx7b7fcekn50elgUQADtnv+VfwqAydFJ0cs48otdq/JW03XYV0wM42EPqi1r0sj+IwPKEYyOF9UzMkdWhneey2ozS9h0Um684vdNj83hHJ7EG0ICykGgX1qkqOmI02cggsWPEBVXftJgWwMBFUg7DfpfNjM1Oxpat9yZ3WSMT2Bay4BjTndJPqu+qEatmEHzqkpnPWgVaNDBfgbTZ8kneq3eRuVs0qxH6o8ib4YH8fm1ajL7/zkcjtAO6eLSGhvGGV2an1Vctj2CVkanNlQLYLkHL5w8ridYWndTEhTjkoOfdhT0+IriHWNJim9cRaArDGcouMcbGxnEgcWfU9TTiVObXZmOYJwE4SxDADsLKvNq8G50vwUNYqjc6KDoVy/lVUnPzVWFRxA0sHUNyxek6ls8wQxa+bhZ7jUm9Ws3m7CJAsTYXaNhhMcd+olLgHDz+vyRmZ6b8wn9La0fxVfz2wsAln4ghSxH34hqCPH/djGgQ8xSN5SuDUjFF0qTu4fZsV1zoW0ww+JIc
 sLq0oEgo
 QrT7EdIGNny8im//3xYi7om+mkpkE0SJ1f+r69IEwLtBu9R9r5CRYkr9FY1wF6wANY0wvcf/L3VpRnz7TqX0FYH7Bm6Ec0qvZoSdf0JtZCRf0x2k/jgk/xsH4mFJmeIVop1ruo6uAQwqjhFH42zdCPkPZqhQrD8xZ9o96hkwbYWxwNFDb/h4B/dMPD+rdpEIZWHD8q7mF1lfYYe8b9Zzxfd2Yd0LVLPP6dLo+eUOz5Wp+S9g/Uy1AtoQbkojvXLs88TCT17MvuuxQMsdHHkGJpIimIbTxIelJ8z6uxP8DfH9LQYrAweKLkFq0SdQ6JC1UZfI5fHEJLxFY2JQ7EIl0ZXVnIPg/njrKWJxa/6NMWeB3OPQZUEhibWc/OjaasM5opQxjeQWxLmgl23M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 30 Jul 2025 15:28:06 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-07-30-15-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/beace86e61e465dba204a268ab3f3377153a4973

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


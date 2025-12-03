Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0FCCD1BDFC
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 21:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1517D6B002A; Wed,  3 Dec 2025 16:53:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129266B002B; Wed,  3 Dec 2025 16:53:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0655E6B002C; Wed,  3 Dec 2025 16:53:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5BD76B002A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 16:53:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE9DEC077A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:53:01 +0000 (UTC)
X-FDA: 84179510562.25.D261C11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20B6714000C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:52:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fx5a8HDj;
	spf=pass (imf23.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764798780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ABx7s9TOUkZ6YTsyH5ONjXOodHIqa0GImrvGGA0UWZE=;
	b=Ji1O/YWSxN29U0mUZBNteB0C98MApr+me4zU9gDomxIoxDYVZI+8/J/AVbuC2ofYdGeP6B
	aPQOnxR0Gdhs04Xmnx7x3JovvC41VQckVSO0txVBUy85WcihJ0DCCA8wPmC0gGBbrZeieh
	+9nq2tg1mqY/jdijNE4lTEZRDegBY6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764798780; a=rsa-sha256;
	cv=none;
	b=T49dyRflBeo1J39uc4efBrNOvl9ny6xLQ5DTCDgU90tDIpNlzvA7ymAyqCNUnjnnebaKz5
	4FqM+Hk455NLHHJmPk4IEDvKDZJ3wjA28szI+f4eDHsWKuXu27dnzheIHj3cZWmKNC66nu
	K41rjmrX8TGhGu4XaBJ3OfXy9XmyoFA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fx5a8HDj;
	spf=pass (imf23.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D87B2440CA;
	Wed,  3 Dec 2025 21:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA269C4CEF5;
	Wed,  3 Dec 2025 21:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764798778;
	bh=UFjiXoKcfZ3okOf0qYA53wES/ej5Oqteqrh/IurkTDc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fx5a8HDj3RVmF1lcInfg6NmCJ1dJp7P5O2ptvNfcZCehkq3Hvql75gsI/ZhomQMe7
	 B6oJw6OUvbrggFK0DbNKLqpYGOizuHaXHYGDnK9OI5tX0v1Yv5jQ/q/VdQdqOQAYMK
	 YjWwrsqDbXlZFUGLDInf/xQJaTwojeXAf9RLVwBRzF4P6c+xpNh3FxcM0HYBPNf5cV
	 vjhpzLgvAO5K6NiacG6dgotw/2b50Ssx7/mzZTtuf/KMvLlvjRXx0FwHPpbnVjJ/q6
	 8LEn+J7EkKrobCaoDNjLhCow7kQcLktz5EuAOWc4S4N3pPD/hCsZwhDNjxPID2aBxL
	 oWizc0i3znWZw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B598B3AA9A81;
	Wed,  3 Dec 2025 21:49:58 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <1444c957-08c6-46f1-bcf7-da5211bfff1a@suse.cz>
References: <1444c957-08c6-46f1-bcf7-da5211bfff1a@suse.cz>
X-PR-Tracked-List-Id: <linux-kbuild.vger.kernel.org>
X-PR-Tracked-Message-Id: <1444c957-08c6-46f1-bcf7-da5211bfff1a@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19
X-PR-Tracked-Commit-Id: a8ec08bf32595ea4b109e3c7f679d4457d1c58c0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b687034b1a4d85333ced0fe07f67b17276cccdc8
Message-Id: <176479859732.93177.16237702615670932988.pr-tracker-bot@kernel.org>
Date: Wed, 03 Dec 2025 21:49:57 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
X-Rspamd-Queue-Id: 20B6714000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: iapp4co4onbnoqnig6z9hu1zs4nrd51u
X-HE-Tag: 1764798779-545719
X-HE-Meta: U2FsdGVkX19izFcCpvQjj3i3BmSPKWd+O0SuvOVyTLd3Lld2IL/FkGFefpQOkVwqsbHlwCr5tlZTYqlXCQa1Psk3Xtc+IQzGbqfSnMrUViALCCBR4CaiaZneca11B7i2aUOYSt/878ImHCIh+A5TbHYLWEKtbvGxQYPBhqS9V4Dgkt6/xKxpyXqrA5CPzR+0ndqYOHAIdiiO8IU0If5uJm8EiwpD/PUW8BwHazeyyFU2th/lplXW1r1trB4vNNVRS6CxfcSgFsisrHAwkXbSYp7KM/VGjjeCY9fvQ9OBc6pbcbMZZRSqAtDhyHQJ692Df5ucE350ueivKS0V9jaNsblBuYq27UEXffjYdLtxgcALaO52AmdG2zTxfxj6gCtBNiYyWZqTCVuloQvrCaALW0zzBKh2vL6wjnRLwycoTmn9lthNrFFIMLkRlS9SUccdH0jwvCKQc0p+cw60tyDOQyK1ZaVt/aSDAjHZlnocYzY+n0RAZuM7tk0GaeiLpSoQnBWwoFEgZ3hH7t/sRmYs+S1AEGmZBrEL3WZH7zDArXaJh7Y/i/AzV5nFRYkVhkQF51nrrwbfhEtrNxyerR09S18uKtyfhoieD3+LbBIT73YKFoLVksNdBdpTD5QIldb4rYqFqiRr9BlkapO4yIhAsipCOD+EDtY6Tx2h6l5A0ISuDN8zGbBXEZFOrfbCbZU5B61ExSkBCmwSsSRdvF35JXQSN2ROiQztZijycQQtFtYD8tS66romYSwoO8rTqiEuiOdCgq6eB+4aBHsKKh8wixnwMm3C+D20IfzhWNRFZyF5O3CZnyO6NFVAneQZteZLAzlhOyDddDTe5WnXugw8MNNEMlEiRXsw+sAsTkZqY5vCT9MclEm8YjhfppkGnkbu6ekRsKo/p4lw7gJVIU714c/HxQe2lrAQW0KctBVCv7nDeeybJS43q8ijEr5YMMZuwB13U7QfsvT+vuwicd/
 QLZ7LJDI
 Epej+kGn992FKeddEiEEvEqfu+MOV7fxrNvMKPe+kFmNKVkybAMdlzuzRfCxKJmLRGZ2K6htWm15HpAuhdpGdjgcOjWcWFENHoAxipdn6OEogJ6VoXsj3oBBMde4oRBC+J6yG4L9q35qF9wU6OH1ooqcokqMtWgnmHBUqIjjPYHefh0bjEs2Em/HsCp5O1n2Ub2D0IA0teRWfWT6UP3ZghdcB4PCvZIk7sdjbKLVHQyvvc926oNmLw0Yf1IQiyuIRow1wF0u2IzhFXMEcKa1Vtf5mhnmkpelYL97H7XsaKZI2wLQtOHUgPzqkwPZ8y0DpqAdT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 30 Nov 2025 22:20:34 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b687034b1a4d85333ced0fe07f67b17276cccdc8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


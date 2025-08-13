Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4796C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 15:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8249000A7; Wed, 13 Aug 2025 11:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3986C900088; Wed, 13 Aug 2025 11:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE7B9000A7; Wed, 13 Aug 2025 11:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13DAB900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:42:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D101B1DCE99
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:42:10 +0000 (UTC)
X-FDA: 83772150420.29.A26DF9E
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0EC5240014
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:42:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mm3RA4Cy;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755099729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=KLaKhiNKJnwLm2h8sKq2qt/e3iQDmklwhZl9VlMOe0Q=;
	b=SCr3IdW3cCy0oiyofh+5tLzpcg52m/cFuqR48HC4s4jLAT3IYHue/mV9uKr496dP08Ubaj
	u7KaksSZnS2wGfMfwQITFXT7LIWgjFN63MzfvCIERudB1BpDslBLQEdbZcDBTQx2n/7WQX
	DoexvgeTer/WjTvKnFiDaGhoQnAPuWU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mm3RA4Cy;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755099729; a=rsa-sha256;
	cv=none;
	b=32B8x19Kp/zMUEsKb1Xkk1kOm1zEpxzWI9lixSRCYqyOG2OILp65ssrnvmSB6lDGX9YOpH
	l9OfdI3+tCQkADN0IdAa5WOO2/PoopHzguVe4QhsGn4gygh9Itf9SsTNj1BUdNF5lUTdxJ
	oz6E3E+vzBJ69x6hJDNvPO16Mk/MTG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 61085A57DE7;
	Wed, 13 Aug 2025 15:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D34CC4CEEB;
	Wed, 13 Aug 2025 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755099728;
	bh=KoILjMIrf0f+axn90tPHLT7lB7OEvJPVViVyLgwUa9I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mm3RA4CyMDL3VYfRduA5zbpAYDZlAU63kivBJOaDKlbVMV0TYNHO/79OQVXJm3yi7
	 c+tNZ3BcdM0yYMUxURFP1j9wW9hoY9adbX0Kfw6uSnEfT1PxAIum779R9lgTCkL2t2
	 LrA0PReHLzygBTade+WMvs7y2A4yy9443u0qC2aOACHo8XZRgnbgHvl30Xx01MgjAV
	 puAX8mnOzPeQ4q8ckgNSnzzIC4bLAY963vsyGFPLcR88jeOZMO95NDZoRINb89EL08
	 8DQJdEGrSuj3JK8d3/VvW/xmsxsjmHuUl8ghWEBGrBBChueDixfyP6DrsRo3pjmvFo
	 7A3KuwNdGTUTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 044A139D0C33;
	Wed, 13 Aug 2025 15:42:21 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250812205256.7782e2e483a8b12774e65dcd@linux-foundation.org>
References: <20250812205256.7782e2e483a8b12774e65dcd@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250812205256.7782e2e483a8b12774e65dcd@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-12-20-50
X-PR-Tracked-Commit-Id: c0e1b774f68bdbea1618e356e30672c7f1e32509
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 91325f31afc1026de28665cf1a7b6e157fa4d39d
Message-Id: <175509973969.3638460.11919114009221754348.pr-tracker-bot@kernel.org>
Date: Wed, 13 Aug 2025 15:42:19 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 0EC5240014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: j9jq741qczdn9i859h5g63iaoiowqkir
X-HE-Tag: 1755099728-763039
X-HE-Meta: U2FsdGVkX1/rApfZ1tMjgGIbfVGl5+/CaWa7sWT03eGsaFBf4tbGpbnYX28M6v2cc095ZV3AYFcPXDgxhjLeBdXcrBE3fwZUDTUCtrADHiRmlfkWi6Z4wLKBI4ljGlHCkpweN4y0/xqw3qe3zDEvfTBI5g3aOQIEdRjQcxT38WNMQ9SYrMYEuf+OkGx1Yz6imds9vSVJZ8i7hPslwkh9jK2huqmqZG3yNiEY6seV25fpQDNrn15ct1lCbR2oaPxDTKEA4uC3AF5mBSujGrkzqIBD16ag6s1r0g8ldlQ8wzrRD25LOvDZW7cYrH/FM+wIB8zZCLqyNT1FF7JQSVJbD4HxUtzCP6snWmmm9H0SeY7Av+FyAtHouRdRM+dUtq5+8+T1LgU+HKEt9qzV8gBUn4vgCXATfZ/gsQ7uw9k5a+bZfH4x0PrgonlCWfwg+u2zoNiyToZMct2rBNNLos/+lSmjsbVu+KiLnZs9d/KIudmJFOZrUFjJzh/080imG2LSRYWIv6v/wsWEXK70uuLxGYy2o9DTszDm52JTFfFHbVJnkl6VbZF11udbhE18cPJtCvV+xK2tQFUK/SXikn/tCApEPV1JW9dIyrNn3mcf2OtXgjwrhIZ4u7poYqWFeSlYIDoSc3eJUFFn48aLXZXy1l4CsfVe0sEQH3Yb1CPikTsG2GwmYccDwSLvDBhdx0L6A3YQ1nrP4jSK/cJS/QpJ0wIBvcFNjNKnDwjpm0QSR0TSt2Uk/JiD6I3jpk+Wg4uC2EaihUYaxzb+pEwOZY4PeLKTEQTuJa7KmoF6IIfBJ4CqHqiPBwK9axmBwPG1lCWNdyOF3jJNlur0UFuUiuOOWBn/fVby0dnfiNjXXKPIMPMaB3JcR1NQzPkQEZPfn0B0X1Dk+sb6HBWnz0JRiltBk7Mpntl2bV8zZysjUpTHJhJtNPka38Jf4tK3tq5KkjKoZjPDNhZLbPd+slydIJf
 4ngVdeJ9
 6VxVgLVKohtmQgaYUanYDbp/xp8Z8qtAa1pcd448ozOpjjiFEZshh1uR/6sByA6dixNkb8pr6GOnrHRW6SF9N3XeB+p1PYKxIaA7OY2vv2IAy5iClmFTwjL6EHDusnJE4qM7rqSuikSVkvbxd8xjTixaiWv4/e26+ocToPay908FBZ7dUafm/n5Nk1WX9b3mtJBcGXub1ICqbqYwZTq6Fvpm+KVSwhsH9Sx048BwPUSzjNjWUxS0rEhItxW4UWYMLD7X81MPJkoOWpm6HxJ1WiWvD5BvjyyzGOK7ieQJvq9yGeRb56SevxhKeoZokaT9SAjhsRnYewH17SnVUB8SGzpsVZAV1Z1QU/fGJnWJMyi2J8FhxHtLxTuRJ0FYfm2QNlONSxTyfREC0INk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Tue, 12 Aug 2025 20:52:56 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-12-20-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/91325f31afc1026de28665cf1a7b6e157fa4d39d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


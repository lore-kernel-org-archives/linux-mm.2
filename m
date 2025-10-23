Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6857CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30368E000B; Wed, 22 Oct 2025 21:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0978E0002; Wed, 22 Oct 2025 21:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1DE38E000B; Wed, 22 Oct 2025 21:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2CF88E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:09:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C31BBC608
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:09:58 +0000 (UTC)
X-FDA: 84027597276.11.F368CEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2CDB91C000F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:09:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZEou8pA;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761181796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=XTrSUTbF6VxwZUeGxjrCRBqv9qiyO6S3UPSZQsaoyy4=;
	b=Ljak3xPg+qFgQVaOlcRWQXY4CfiC9M1Yp32GvwJ+YmZ/wc02QYk6A/MNAQv2qhGWnTAMqT
	gkaEzBMWmreiPHddJ8+cDo9rwoKe5CqjA/yBnn2r53LVEeXT8csnZWtg8NjCnMZ6sIpmNQ
	l+pdkrfEDxq8fjuX3DDkjHMLrnP0fHg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZEou8pA;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761181796; a=rsa-sha256;
	cv=none;
	b=y75sDjPRTceA8Lc5+Y3fLsdtu2TFPlsyou1NHlLCq4gbmPSDhyr2nxCwam/YKbpbcYzLqe
	yVfkxH+Gw0pexOar/R8Gxo3SPoQK7nqRdNQg6AY1LRLrFd11pxJt/kXQOu2KwK2ikNycug
	/weMsX0ApoPookUh+V3ykNPBO9+b//0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A36D943754;
	Thu, 23 Oct 2025 01:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81531C4CEE7;
	Thu, 23 Oct 2025 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761181794;
	bh=G0zO/gc9MN6KlY2clwE0hRQpkFOp+B6rix9cfRycwNw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XZEou8pAzZph6RaP/px9DGaj9wzQQc7PRiwczqZxTJB/LCw8fpxiylSf4ejqXI4br
	 xiycTQOUNmMLB9zR/boxz8raYOnd9CbfSoWK4nuxknmjkxME7j5HrOSiNRejJJ8Ahk
	 CmU4dTDke+RL58d43bNFLo6mxbtlFzf4qHpQYjoF4JWcykYwRN2eF3+dudSCZ5DlEo
	 JCNwHqcoxMsTHMgB/CrSXQ0RIwRHRSwvlQkMuIb9dNA7VWRXYaDNp2eidYCGA8H2bt
	 5DGHDe5cMy+9dWObcwiFxLnqHpUT3DZFWJVwOGpjTIVHHIonRlASXJBaQ1cU2pJMRP
	 KgdfaPQ8yQswg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7134A3809A00;
	Thu, 23 Oct 2025 01:09:36 +0000 (UTC)
Subject: Re: [GIT PULL]  hotfixes for 6.18-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251022124548.a2bd1335de33d5d2b7b2fcb2@linux-foundation.org>
References: <20251022124548.a2bd1335de33d5d2b7b2fcb2@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251022124548.a2bd1335de33d5d2b7b2fcb2@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-22-12-43
X-PR-Tracked-Commit-Id: 9aa12167ef1149d9980713b120ddcb31cf17222d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f3ad9c6105f32d1755c0bd54a7f98c892f3ceb7
Message-Id: <176118177496.2361762.8429864278657439386.pr-tracker-bot@kernel.org>
Date: Thu, 23 Oct 2025 01:09:34 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CDB91C000F
X-Stat-Signature: bt7mytxz6bpxia4sueiej365pqnnt8na
X-Rspam-User: 
X-HE-Tag: 1761181795-963882
X-HE-Meta: U2FsdGVkX18EE0bW2XL9tfwsqZNXv5X+SSQSnvZm6pokVL+4BJKZbqf4zuMMVk4ye6fFylDQDETLP0LZQBQkyuAwRdNCkLUzVGyCq+OBP8jExplva921zqv6Qz89+IL7ciln2Ijj1u3WVFszYGPlY98L9WtqhCnfYN5Gcm/UinmyU8HnpIe8qqaiF1WTnACvsRVRRCct5jPEuy4TtRB3EUu6cssRMGfApXGjXGBR1cv6bf41o8AieAw7sT3GtgbrMvF4H9X0XJ89R2BMk+EGdbbI42c2LAmPRJC16YT4n8++HgbYMnAFusaxXW38oY53yJLkaZRN5ieDB8fmHAkerGT1RKMyR/HB63D5U0EP0GAD6/CWezZJ3TILoIyUgc6c044KEY44CRpmhQwQe2gLKfhJnKcXmMZYKsvndWkioMvzagYJh49cjE3y1RexDthX4tLqAYgkMBkj2WjWHK9LN19tV0L6VXp/2XC4mh97if4g/UvXC09Y+bRx0xUaFZytXKaXNSddTm5AeSbVRqSsB2EATz132OAqRU2DDCz4wRZNl/gehViRgPrXSTaS3H+TwlyTRX6TJxt9ab1zNKbFHcnVRa5LdR8ZEK2IVoiXrwDPvrn+PcyAdgZXxyaShv7z652R6gyD8VS5tlkiuY0CWCZE68+oI2GZFmqGeuazIji1lzxAQUs4pGe3a1Fcdj/6nOuXW4jb9KwyECp1WCq4C77Uic16v4g6VI5CZJzXOvExsDR3kdS2j0gd3nGgnziSvFO/dLc4mxtkmEBQoxvf8Rp/S7NjhjcCY+/93yXCjY2jed8jSwxHEZBeK+Sy4AQasGl/gzzsQeXenfpf18BA+ISy4h24Dz+uHuvaZbMDH/5cNNziDhFm5mkzj6D8h6KZurf2JnypuRrey51ngrBjfML3YcmLgv/nDCOnVmb7631ssxGHfI4Hx23hh29tdQoy0VKpWu4yII6XnSN8ED8
 QOapKVIn
 zImM0iQOXc8+Buczz2KajH9kb3HUQgA0BR1S80pIoExm14neBWjrYCmPP3s7cIjbZs+kR+15CkQXynGBWJddMkn88dWBwsXzahAkCS29wL/nPPRLaR+iKsFDDyHxaG7QdufJlHFsQzi2XaaY3YqjNuzB39wlPi0l1+pzCGSLvCDOGqMABNwzyapaAyjl1n+wT3XqFC3NboyzQeRn6QDecAWHLrbuGladncJiT7SXNdBC3OmCpjdIo7g8jp6DISfcdAhoo3WUs3pck8zn4awUG0F4BWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 22 Oct 2025 12:45:48 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-22-12-43

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f3ad9c6105f32d1755c0bd54a7f98c892f3ceb7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


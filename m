Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13B9EA71A2
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF65B6B0317; Sun, 19 Apr 2026 11:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7A16B0318; Sun, 19 Apr 2026 11:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD366B0319; Sun, 19 Apr 2026 11:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA9FB6B0317
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:42:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CFE8160723
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:42:47 +0000 (UTC)
X-FDA: 84675723174.15.9197902
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 56E9340005
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:42:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUkZf8h4;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776613365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=c1mvF7+MqhDYg38GQtlxyvzo7ZCkIYuyZ0k0aC92wyA=;
	b=laAnGQlxLAJbzdrdI1uJXF1n14ezHw5o5kLUt7gujHrdP3GzUDlidJLZSycNfEoYf5MZPJ
	orWq1bsqJTkOMUEx7OBHMeZm//qvEtn2pF5sp9k904WRYFN374SBBmEFFD3RKBJIjxukL3
	02QUG4UlOwR6iOTbUeS58A6EVoXF9d0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUkZf8h4;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776613365; a=rsa-sha256;
	cv=none;
	b=GQ/7ZASm3dROrf45pltCMw2ShPpTTMGKeFktUwmfX0OyPgxKtXSwDN7wnuD+NCImmkfqHV
	cEDH/Hd0UW9W35MEZXujyKoXS0UqJv+mvIt+N7SjgKYC92oiMrIbh8bkWOI5vD1O8l9doV
	+rICVKwnCE09goyKxezX67CGZc3MugI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D1BF60055;
	Sun, 19 Apr 2026 15:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244DDC2BCAF;
	Sun, 19 Apr 2026 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776613364;
	bh=xvRKjYBnCdzdh4bvLjdYo241YniLSW/CTCHzePGo0Y0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qUkZf8h4LJ3DLxhk1q+D4zi2lfcNGRyBbujxLHAm3ggNKXV/lAK9hfYHDnc4eC9Ek
	 18E9yE7XwpBISHSuLadheCUJp/MVz2l2a3sVtdXFDwIvMEP3AFWWI6aWs81Vrs2GC2
	 d5LB3U3VOszgSJh8LRz3VtO1mX4XrWsxuOYS82QLT94Lnyu65Vr0e/KWk1vcG4F2m9
	 LXhnY/KELmxCsXaEWZXLXAf/wmKPSblYPGYQaWAHhL3yCdourGDxg81dsWK65UeJW7
	 hxesVjrmh/N6bi0y3keNpLC0UVQJS+rx0zvXS/sqJf175s/WguRNSqdi6/PWMVFU9T
	 ifxZm4WkfKcxA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02EB5380CEF9;
	Sun, 19 Apr 2026 15:42:11 +0000 (UTC)
Subject: Re: [GIT PULL] Additional MM updates for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org>
References: <20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-18-02-14
X-PR-Tracked-Commit-Id: 0b5e8d7999076ac3c490fc18376a404e2626abff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 40735a683bf844a453d7a0f91e5e3daa0abc659b
Message-Id: <177661332946.800150.16573212022538901755.pr-tracker-bot@kernel.org>
Date: Sun, 19 Apr 2026 15:42:09 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
X-Stat-Signature: 7azjxonrax7q9m66b6yag44fe1qwhk58
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 56E9340005
X-HE-Tag: 1776613365-817019
X-HE-Meta: U2FsdGVkX1/wsDIgkIuv7WUguN6OvvOpZawHtfYwh2A+dq7XA9G5NObBCROiv10S0WO321tbXc703q7XUBcAVqhYEQtubyh5155+fdam4GiWb/9ata0ieNyEs9EBv4Ek0ihc1ItyyOrNVVKirn3RhBQ7LYl4lC3qX2YhaoW8zRVsqR/yNddV0H7D5UQanc6Gxw4ACeknbQVY8J2pudYKrgjfTJO/FABr0Wr8JmpzCc0Ed0LMyj2a8LUiUwxHSA/CBBACag51DHhDwWLqkeKHvyV03tMYd2QdJT1S0U38KzojkxOjRmfW+PdpyadHigStTCl9pwychcrasl4SCJzi6U8ty7aUciZ+6wYGrX4IOFKnV9+dACyURl0ab7HD6WL1Dt9LPhegDvZApVTKNu9Eaexa26CnSB9Ch6LcVkVfR1rpDNw0EuepzNn4PZT0hZb4cLYKfdkdz2Mj7fmlZGqK0ddnHDdoR35K3M/3bL7wWy4UVHTuWxHnOIemkHd1TdiQum3tO1tDPKyQsA3U73tddVNVYRKBv6eVVHnVwHJ/ow1OzownoN+NXkP/H41FR0HoYmnCOyK/Z1e4cSJZW2dTmLKOD8baVvEM6qnNNz3z/mpDwNnuAGAseHBSO8zmXDKQRX/IkqyhMOBMZJYZXGgbTf7yXP0jE1VrMS05tJdcMTD7VUG8rVsfwqPtNhHESwz0EnxwYLoPa9QiCJEb4MWQ8TydlDyEorZFmZLXBwuyNyLN4e+/EjNZAEl7bFHBjoFmaBDIqWet5Qi1Z3eq3gcn5oW3ynNHhSjRFrTs5ftp6qJTXcaHSoKdBJN9o2UnozyVSZi/OSptzS7nmCs0Hj+nym1KwZHLNVGk0vRkzZffA9dajrFtR+z0u6dL9/feGuWKfIDRdr57nnlQTkx8PZmElqyCYUt4agcng74Cv4jkifCaLOlwPGKeSnsKjA1G3jziHWRabhoKxNEqrT50dIr
 nf/SOLGX
 6xIQRrVqma9rUHaEg/RMxPjY8M9xBVzU44aFi6sgm8qPEJtrx6cJUQp3D87mJTE5Jgzmp3putryZealW7KMZPq8yYU4m0wJyYXH+/aP1NaaMvEFj8Ti21vpW9WbKEc5DLbf7P9V57Pe2KGUAar7rBUxRTD1kUkSb90xHJWELsEej9Ed8KkIO2g56Zp+tLo99ILdJXcHW9i7nNL4KyHbq37fD0buG+uJ2QfXzZFiouJ/yTv+PwRGO4jhqLjV8PiPsP8JhW8KHNZbv+TzFzkn1/B96FxxhhS3eGBUj0N6wczhVque/jWmM1hSpFN9elnDAjW1Wevzs7aTXHtZP3lXCZWt2NoAdyhKFYVJrHhD4FUOlk3CRm95xGMaKhRzdlASm6XfHmtD5xjuwPUr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 18 Apr 2026 22:38:23 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-18-02-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/40735a683bf844a453d7a0f91e5e3daa0abc659b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


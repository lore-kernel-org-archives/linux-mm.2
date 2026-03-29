Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CDEF3D612
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 16:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD5A6B0088; Sun, 29 Mar 2026 12:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E626B0092; Sun, 29 Mar 2026 12:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074B46B0096; Sun, 29 Mar 2026 12:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E81786B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 12:43:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9051413B082
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 16:43:12 +0000 (UTC)
X-FDA: 84599670624.01.1C1383F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A3DFB40006
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 16:43:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qdpJPPWM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774802590; a=rsa-sha256;
	cv=none;
	b=l+shpwvK4CA1yClwrPea66vawC9z+Zx4Av6M11N7r8r1YK9G7hPWOs9fvU8qGCPHiqyMAC
	WQS7cR7I7es3TShpu6XJqFbtjNfCdv0d/7YNQhYyBO7onkF6vc79Enh9ItitheyuAvllx/
	VEdq6b22hS9xzeH6Yj8xdbGTrG9AOYI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qdpJPPWM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774802590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=umMP+xhxxJrHle7zZCwUXhC5gL4USzcP88jmZTDE2fw=;
	b=YQbZudLkP2MKdxVqfdogYghHPnZBqxSNuLcQoxVK3ZRMk+6PBjNYEZ6Hw1MhXfNiKwzw2k
	cs5x/sexyN0wPZWSlPmr2Pw2HQ2859X3Ptp6WlPeB0wWvCBOzpfuaxuKqhUsAnL37aDxp3
	PjCchn8SVu6uElmgYAK6PMEXWbzhefE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A492342ABF;
	Sun, 29 Mar 2026 16:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89916C116C6;
	Sun, 29 Mar 2026 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774802589;
	bh=84gDbC7L/bu+sVbfFzM59BLcSHCoaYv4jdvcr0O6YKs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qdpJPPWMzlSl8o4WjeY3OuWIidMRaV0gI6ZhqoaKfwZ3jwFjYbdjq2RBeLTuFYWw6
	 0b9vScg12qXt/aWXrkfNQHOp8eSBMDFNfyD2c+uLM9wN+jmB0Ty/0wk9TYR8JTNSAg
	 Gmh6KGXCZa/QVwb2xcmZDmLyH5dWcS+Bs27gRUEdwH0iBQXw8PwQDbe4H/EcHq3tAQ
	 bWzYxFckp6Lo+CqWB+8+OuoRlLYItWPYqmrpk/s+leFKxvio5UG85axhE5T0k9ohVG
	 05GIEcQ7jL5LaVcLAJNoY9LrQ/f7oEz9HIuUCIae/SKHkyC3XF2YAqBn6+A26vjH7d
	 5WRgSXRxgS0Tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0CF393000F;
	Sun, 29 Mar 2026 16:42:55 +0000 (UTC)
Subject: Re: [GIT PULL] Additional hotfixes for 7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260328104905.4f602f792bacc66ff1495ecd@linux-foundation.org>
References: <20260328104905.4f602f792bacc66ff1495ecd@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260328104905.4f602f792bacc66ff1495ecd@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-28-10-45
X-PR-Tracked-Commit-Id: 2697dd8ae721db4f6a53d4f4cbd438212a80f8dc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0bcb517f0a70ae4fc59ce87bd27573043416aa94
Message-Id: <177480257400.408055.217569697494671186.pr-tracker-bot@kernel.org>
Date: Sun, 29 Mar 2026 16:42:54 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Stat-Signature: taq4sc4etzcjjoiuc89h9tbwoe45fp6q
X-Rspamd-Queue-Id: A3DFB40006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774802590-247907
X-HE-Meta: U2FsdGVkX1/Tt5SbtmagNICi04m3w0yWf7Krz4AnaZp6ZMHdXKIwhy2vxMjVpeyRF4uRCMnJ8+GAP+zRz8eFii85zQdIa4jkYdmg8wT1KNJlTlalImLykdGj16sciU9BCR0sWzk/AlXx9colv1wqR2hNVAZghykCmvMTIjIvJ1OshNgpiP+vvG7HNoe/L6vOkaqQ/vAELfr+Ehm2yodVsMeUe27bsWkER2t5Bos/pB0Xtol7JuKfBQp0+K7jT8kutjTPrECllU1ZQOmp7LnmevrXxBxH+c5L9boMF8IfEkTNmOoTqUPEKFHKgOYSSZC0q9faxL/jR2oqRSffvz/xkrIWtPEmv5Sf8gnqEcW9l9y9R8B9LNu2YQIaYOwnG1WMST6GivhT7648IESafNP6EPYtNbDt+/AeW3CLkM6qRL/46x/N72QlInPsP2QyfJkLeHFzlzHx7UXMSN4SYLDvuUc5Jw3bZLSnYtfgY5tisQ9QZPNwYkA1bitjnA0lfoxkfTiIROfG0KzxQGzOJo+eEpqQs5cKtmR3o5SFyc7g5OQhBDAmFmN6ZUSH4frkI6MqZUeBLE7RvQBV/yFjkAs30zjl4nSv5WdjusNv6c5gZX/JmPRLerU/upGhHjzZcttToVRveV8ZqJdTsVAkOmtcd5+PpgpdHFlMjVTSXQI25xE5Yy3xsFTR62NOOcuh9WQdnUiWC3IoUf2XB/FiAN2pCn2gnGwr27xHwAtOJa9EtBg5AdvB8zjEU7SLu84xaP33k/Uoq3MvZk95vl2XL/ThBwGdoZZKUhAAnQ0r4yNaEsYsp0HZwbxfj09UiGokCOoiOupeVGTd+kyXYUqZ29ZFHqjQZU9TAkf7kX3aXNj9CskLgboboBg4iYB+oIvURAfcFgE0CxcM7z3g8zRmL2uOKsBdPX4isFgilfuHoAvSr9DZ7kvYsut5Q1f94UYxMQ7xxsuzl/JAf834kKTujok
 O3XcBgi6
 uHSS63xWs0grWBBtuGRcAwUTULvnVFhBRrKkAHXmkq5T35K7pgjIYL7ahVK+O/0IXkI+k/QGbPsPNdx6bXHAuiu24bLXu50sE+6y5O91ir4EYrJNNs9DAlaQuzoA/FKv8pE9g/I7ycg3gyPTDu6A1ZBOdVNNV3/XYNikLiKlSWBFTgcCxoeWrSIXi+ntktH6r8x/J35L9UfYd/AjUOto0xbUPWIfKNAo25lTPNajn7rrWxdhRv/voAF+aUjIKSQeu3mtwnSlbS9JMET4r9pv7MZGdUum5xyIL3v2XCVnwFdMSvpM7Wk98hhl1CxT5eMLURs+lTPvbYeYebKEDhL0aKUGFs02J1AY7+0m8qiW31O3//hxLrtDmhNdIUG+d99YswujMQw2J93VavHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 28 Mar 2026 10:49:05 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-28-10-45

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0bcb517f0a70ae4fc59ce87bd27573043416aa94

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


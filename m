Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBBBDC5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAFB96B00A4; Thu, 20 Aug 2026 23:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60C26B00A5; Thu, 20 Aug 2026 23:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9ECE6B00A6; Thu, 20 Aug 2026 23:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A92336B00A4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:11:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CB688019D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:11:11 +0000 (UTC)
X-FDA: 85123800342.04.2D58002
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D469720006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:11:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GHFbIj+j;
	spf=pass (imf13.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787281869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=/vJgYywuEJWZEkQKz8Bj/wRfo7NzO/GxYPEKUCdHC74=;
	b=mLtr7iGu8exhOG7EY6UXbNGnkLhMUl466CHzzw5fVKm4VO1BK7RovU4SSRi2zgDqJfj0nd
	QSvA1/uxWPqKf5o/YbhJcwejl5Mhon+5OkQbMKI1V31mu5XQf0jPlBKOMFjSMXpGXn9Axs
	ocDwbUsqCCehCtTG2Jwi1N1n3WQGzV8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787281869;
	b=HNsSJehxiTacvT+2t70z1iRYYBfawI9NlCCCae3eZX8FUxq/awFZFZC9S0UEegOip8iBJj
	sSYkY6j9bup/7B/k0EHDnxmLKQ1r1uFkj/DG+0CQ1OkDlAPKi/bzDqhLSp1CxbD8dt6/HR
	8VbeaVh0Jsmxg7LaMcki3dTRfEBogeA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GHFbIj+j;
	spf=pass (imf13.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FDDB60A58;
	Fri, 21 Aug 2026 03:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE03E1F00AC4;
	Fri, 21 Aug 2026 03:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787281868;
	bh=/vJgYywuEJWZEkQKz8Bj/wRfo7NzO/GxYPEKUCdHC74=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=GHFbIj+jKw801WtVy7IMdhU7xpQ187sKsLpPKElsjl+yGwPhv2cRtJsISYfPREIFP
	 XU+xBddmtsjPaXkPDbRnB30TfvS+EHpXbBnGH4xOP0e/Zly41dITOP8MUf3/hMw2vk
	 +r3gg1EbJK/ncWtk0krZSiUAyJwDcAcc7IX0tRRdlvyU/M2kS8kjq1dyBGplDYU7dV
	 mAFNzjfJTLG7hdwjrENeeByD/0HAx9FjJn4xddAx29ja3XNZ3cO0o58op7Gnimk5Gh
	 E2Y8S/SunAMCFCBTVheZLOdlAstm1E1U5SQK1lKHDTVCx1kMuMDij0PhGcYxYQE2Xf
	 JjLm0K0XWAX4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19B7A3924A4B;
	Fri, 21 Aug 2026 03:10:20 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
References: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/anSSANY5zZu4kytE@sirena.org.uk Thanks.
X-PR-Tracked-Commit-Id: 08745c62350126bc31b09548137be87e2866f628
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ed3b875bea55a3ec4837113356df2ead11115af9
Message-Id: <178728181878.600189.588163658498005550.pr-tracker-bot@kernel.org>
Date: Fri, 21 Aug 2026 03:10:18 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Stat-Signature: ds6b5dhqdmxr11tkt5g4k1dxse3x4o6d
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D469720006
X-HE-Tag: 1787281869-694308
X-HE-Meta: U2FsdGVkX1+7dHVYoxqGXdELbq6D+fKPt2XXInCMy/HR3BkNrwxkQaGuzcaap9a1sHqfc6Xw0geZrY8EOz9hSQiQtdFdwiP+WZ5AMj9Bxd/2PfwAUX07cpqlx6glbxYOFYvC7yX/aYZ/wD/kcODZPM0JUmZlwnnzcgYlRB2wI0CPqxu9z+z87dfYU66WHBCKgKi/LLGbANTOOebrl44oqczdae7jOg/Vkmm8zqut6TQXctr+W+FU5eeJENnu6xNPa2dN3qKrXz9zCiw4M8m8H9Ej4I25ft/MY8oE1WzvQNSDInmRGFJGeqksgTGNChDniSmz4xqWEPGZzvjwwbYrAwSeeSaY1HVhpOHbYBVejieLxYmutJhN0UepQa2jtE9EjcJoiWEE890px5EaJUVO3mkDHx9mR8YqlbZWFm/v0So1VLjT/ZkJ2tUzObt+sLH44JFCAGx0MH3BByKiira92sfAS5IkBCCTUfmDg+bzqfD4iYbFw3KawmgcjITbIKi+iOELWrSBDTTN6pdUAGzxVcnXWKIYT0mK0RyR5RXnXIDA4xH9Wo7KCpz3BMl1uIA1jskThLZU8+t8qlMGByP9TWZEj74Qt3fh3hJlKvw5Y6S+oKENNRm2rwr5qHATFV1qYlp3qCooYwwj4Ulb+PkCiOMWMGVRFllX0wMzqXOXzbISK6EvPhVpAjGUpNutOY0kjIMf+u5/9N+q9S5ooVjRdYKbwQkiuaLCxyU8VJn7OK/xkacmDdf7ZoHx70ibEUJyNoG0O5aIUD/RfVtR33TIKK41q1w16jCt1CubUZTBxwnFu8Pzx+jzJD80Sj3E7jcHYgELCNphn1QcrIPSyXAjs+dxDejy8pOQniwk9RY4EEPq4KgVe2DrcVwodU+AMYBBVmt74KL9/3Zo+7SNzHYEvMIC8mQgI8+PhcBeHHrVwdldUoSwpkhs0hhh2ZpCOtyDptSpdkK2zIT+n3QGpRc
 S6D2Gq8M
 5WovPTkl2mhgZ6vdhntJkhSTuyjP7/9nRdivCVoafZONp7aNmuDs21nhMq2mUqCIIa2E1G4Tzf/XxvU6HtujsLWDLaMbRQBilGjNOxdRLP1fbmqkpY97XfR0PJElYRRIJOTlpm1bMLF2iay3WUVmgUCYh27ne/QtZ18cSH4z6Y1IuHym7JJ/NszbMNEOZFnbPG2GrvFdsqEKtJ6ShHHlcrIshxkkgXZ+CLj79UuZp8teJZw8GV7gTlvoz1DDlvh+xhVBTD8Ylye67PJA98LcI8KLC1piN5QmUN7T3OGyEIN0VT8BskeAc9J6jMvd/NqxHnnai2G7K5AHEHQEYxtxaX1/VEACNQtCJ6K47rMGajtfZz5b3oPbAvHOymg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Tue, 18 Aug 2026 22:07:11 -0700:

> https://lore.kernel.org/anSSANY5zZu4kytE@sirena.org.uk Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ed3b875bea55a3ec4837113356df2ead11115af9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


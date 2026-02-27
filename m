Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E6BFD9E2D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 01:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B1B6B0088; Thu, 26 Feb 2026 20:56:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7EE6B0089; Thu, 26 Feb 2026 20:56:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED396B008A; Thu, 26 Feb 2026 20:56:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB3296B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:56:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56B9914043A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:56:35 +0000 (UTC)
X-FDA: 84488572350.26.5794D1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8A001100002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:56:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jOwcbfPL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772157393; a=rsa-sha256;
	cv=none;
	b=5V8f/n4GN/GUf1B1YTkmlgoNggN9X19Zq2l5xM6URO3P0imJUuXEhWhV47rO5cWNNKs5FO
	ykuiGs58MEmc1S0lsjVYr1bGqhiAc6bZh25mr4NKakS4DjWcj57YpaUFxk7qb3TPZ1m8p+
	K21Jh5uQmcEKWlzwDnN4I2Njtnh6MdQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jOwcbfPL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772157393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=g51X3zn2A1AUDtEHkcm9e2IpH2b/zLTEQgdE3xxs7Rw=;
	b=sEn6emyonY0KqNnZD0Z2aDmRzdsn7+7SvLZS7kfEQrMGwcHepbUPcK1Dp+OOQyBd+MWFYu
	u/wXkiQ7BsRUV5QRBPAqB08o8mfGNYwBXgqsrWkLzsTQH9hmqwgLSx6xfFdOtO2J3Kym0O
	x+KEBxUcJidLHOWGvOGTRwgokDptFiY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1EC760054;
	Fri, 27 Feb 2026 01:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9486EC116C6;
	Fri, 27 Feb 2026 01:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772157392;
	bh=CeL0o7iDozDNHrlUHISLQBri+jPvgiHF2jv/vUiwOI0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jOwcbfPLMmfGhgKBn9tXEONS+8aPggiAFkMKwpdRnvywOBjMFPNNqN5yJu0hYeZtm
	 /aolv9y+KqwMzjGTmuLWvxymdqskRnMKmVp0JiQ7jtum04hp7qswBa8k2AFV/6sZ+G
	 hd1W2Nagsgd1bbkSuvQ3hYlZ34kc6Bs8gttkNScZVY2Qx6wX/hkahmLFUjUjel6spd
	 5uOxVrtcx1v48NHhPtb9qq1eM7myBgKiznNUXaJWkTHmb3wcIpFYvefUbQUWywdrix
	 VfA12tPcw+9VoJZg05j9WPMsuEjl8hFY976am8jwZPrASSQBTx10vsGg4c2ce93ngx
	 CG3Md51cpKcFg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02F28393109B;
	Fri, 27 Feb 2026 01:56:38 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260226141633.fd525fd4a4fe2c0cc07596f5@linux-foundation.org>
References: <20260226141633.fd525fd4a4fe2c0cc07596f5@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260226141633.fd525fd4a4fe2c0cc07596f5@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-26-14-14
X-PR-Tracked-Commit-Id: 410aed670cddac1de4f0c2865f30ec623fd20f78
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 69062f234a2837d2302a41c2ba125521630deea8
Message-Id: <177215739659.1937342.143122209456192930.pr-tracker-bot@kernel.org>
Date: Fri, 27 Feb 2026 01:56:36 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A001100002
X-Stat-Signature: kuowtbk65xbx8oznz47s9fe54y51pho3
X-Rspam-User: 
X-HE-Tag: 1772157393-950350
X-HE-Meta: U2FsdGVkX19PgG/08dnucQ0Pq8PQt+gEajSn4l2MUMEtNamhNWN7JudIH0f6P/J8oEhEpCUmZO8mM/kwR2v/Dj9OJb4ZkZT3cossG8opKeZqNCokBWE4qu8IJY+vEAyr6ZmE2l7kCW2mdp/l1ZJNh3/9NVxb6sF3+VUiR5ZgMlZ+uHY4LO9OBQrdzO+EH3DRsacOWpKVtLcjRYD19HqAbS+VtacyLbvIZEGjVehv34F1/ruAvw+U+OrXOfww306/EhUXkBOUGgG+w43LesUKinZBO6UIv2AJX9mSI6WvR62dPWPIDcSUPolkZg4u+PSsKPZ1tujNbhzYXKbqjw6qJ175iao537FOdHvLvHCejEeS5ztUNLypoOOgrodKzehFTfELTsRQDK6GjEWcAKQgFYlOE5w5oPUEBwHDWeuEaUsH3cBIdT/jgOQqdCseU2URzEZdUpsU3CzsGkBWxdYwuCKU0q1tIU19VfZzCLRj/6iUTKAvd/LX1fwg+JLPY6zi6vKRnrqDyTQ22ISNcVG6NBjRq7Qgb2GMuIX4ig7Hr7qYXB9XtDRAocMFlbdD4127gybb8LOvbk+CUc27mjQLPFoRF3VE5+SLWFCWtzH3k8fwwOt5Z6Rr2h5itxttS4z4FLQTrQ/DGa9P2kOb3vhK0YtppBzRsmzR0Uzs3ClOb9rChy1ZNikoDCVtbmsCU5tiQwsY3eNMpAR3NBn8UuSsCjwR2o6rdU9kL8yM733BFxYC8yPztl2rowClcLlBpTxNSIS0bl59h6Ht9o1OW++5TCITSoPpqUBRIKcrFEsQ3JSjhS5oNpPLv5NTYOVqVYgx2PNJHekecRvq4kbf16NGoWhFKjEwYyrtqqfMUIErJmjoMYJ1NmPqrE+BKSvS9CNrsKHlNf1nlPZz1XDaTev8cWkT08phZt6mYFh97V0AHTiqjc1rnjIZjLjMD1kBIOL7+OsFTYsTj1zuBSg61X/
 6rR9o1So
 k2GgkJp8lbQ5/Rf40Q+5gZOdzD1AcHJ/1E0ycAZ3Zo+ORgyCURGJH0hReiPqPe3CTyPMHfzdnUtWoK+6kauA1iuefYDt+4gL2HQ5Ga05Dgw+DV3PoJic0UcuRbs5hdnASV7ZrTBO7ojmyReWhJz/ghgxSOy2jyhAsG4tz81jLDhvlJEeuf0WGzhZpHZkIEuYgUge7GwzWNrIU7yWvND6h/LY6T9JhnylBYFMJziXbtgInLEZOwjJGqTiNMB6At/V8lQzrVp2EUjXVeVFhABWQM8T2zAAuRh0I3OHrNat4uNKkk23m0AA58gA/l4FXFtTegr12Ql0G6kbmy3XgN0zkG9ylqlOjQWiAfpDs8L9k+E6fVrODlfLVSfbW+y9ewaItDQ2hOgHWbqBX3Wc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 26 Feb 2026 14:16:33 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-26-14-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/69062f234a2837d2302a41c2ba125521630deea8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


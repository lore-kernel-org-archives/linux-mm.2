Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D69ECD994
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 17:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55596B0005; Thu,  5 Feb 2026 12:47:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C6D6B008A; Thu,  5 Feb 2026 12:47:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E18D6B0092; Thu,  5 Feb 2026 12:47:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A79A6B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:47:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24A66140604
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:47:37 +0000 (UTC)
X-FDA: 84411135354.24.D7AED95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 335AF1C000F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:47:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q4fUHG5z;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770313655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Rk+Hy8gqN5V/yxCfiLckqfU+g56jgumgP7yOl2yTrWs=;
	b=ShgQiWY9ixEXR/zWPZgdb9WLmAaxecxXAZF3wp6xIw36uzPfsSNeQfxziXaQTmbBnN+mhX
	wpMRwFVaOVczxFJpgaiAhX9fN8IBL3HLxveUbrifkcaSbr5by/y5cLK6RbPNMeZ7KJgCw2
	DK1HY+H6jM3CccWzVLclLQrUBDbOJGk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q4fUHG5z;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770313655; a=rsa-sha256;
	cv=none;
	b=xpfj+JCdjZNBGDWqKljXjMYNGrbGD+Z2BFANgofBVeEOPEHm3D4IAb8Q0tJG23xbbTyOAZ
	VByKN6Q1PGQDzQa4zrbK8TNH7Kwq3yfeJM1VZsJUB2+bqIfAdLVq9C57wG3QrwKwBy/ZhT
	2HBgFjuPZsnkAzAPa6XuRs/EsPVIvTY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB4D240766;
	Thu,  5 Feb 2026 17:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A84C4CEF7;
	Thu,  5 Feb 2026 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770313653;
	bh=5r1cNZ711fosLU2hxpv3v6DnKR9J2b5R52KaPdq0rVo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=q4fUHG5znFTlwjO0exqdqWYPybtLtceqqwji/A3KMZxuiEKE2hbX60kTvHm60cIPz
	 mQZelkJeXnuFkGjO7y1C1Uye7UJmXCpm1ZAo2qGMXWMT5+pT2XWUCNNM7Klnh5yf2e
	 8dKMmS3997S2a2MIyf8NRe/WKjXM2QPUehzY1Xl4njLzgiXSF6rPHp6FfC0MdjbJxf
	 qxqK9rP/i3mh23zLt2cO4KaXOtJxprLkrE7TWdVb30issxYhE8Kg2KWPy43ywAIj53
	 YFZ2lMfLTdQvsh5Zfa2upgfaPKokscRVLzI3LhDhU3YOSw7zrXDsXyQF6usE00DUAc
	 E3vjo2h4gq+qA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C26233808200;
	Thu,  5 Feb 2026 17:47:32 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 6.19-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260204155838.05fd9b9d9b43b493fd0b74a4@linux-foundation.org>
References: <20260204155838.05fd9b9d9b43b493fd0b74a4@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260204155838.05fd9b9d9b43b493fd0b74a4@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-04-15-55
X-PR-Tracked-Commit-Id: 1a47837bfafed7e9ef93f5dfdea6d70869b0c3ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b20624608f350c5dadd74577629e90715d351e2c
Message-Id: <177031365139.509822.8597681757742011770.pr-tracker-bot@kernel.org>
Date: Thu, 05 Feb 2026 17:47:31 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: 335AF1C000F
X-Rspamd-Server: rspam07
X-Stat-Signature: drgsxwzoognhj96y9t7yoffmwz3giag9
X-HE-Tag: 1770313655-992859
X-HE-Meta: U2FsdGVkX18ES3RaCLTEG4psal/YTMxGWRztIIK+cRcCGUHujGA4cobIuLGbueuMZUiRzamDVzIdjUO9fRmBXQ5T95OBbOfCaT2/vmGxS9ISwn/Lwtaz0357JfZeEXNVkoMHXiMOISLUeyyNpMrjrOUbsYTy/Knlxl/CXBo556VJ1G1XuVuUnuwt5xhet71mN8b9uuc31FTBbELAkJh8oOzFfOB1pv+8Fefux6kTNDTMrYPx8EYDLPR2UBJ1yreWg4rykV8SIIq+CavTFfwKwpbHTt59d5ltIqgcCcNG+wivLx4ApW7GTnhillb/viTM5UC+8K2B/uN/RX2f94qRmS02AtCT2NlXHWintmuIHza6ozp4i/tvZn4MO17ab9q87yu4infQCTG0feseoJk6Kenqe7emOe4HxLm92J0D7nivFCwPxXKfcLOeM/VsfdXDyKp3nNRJyb6Rwn7SPxpezBfMrx2UTuaH1sozbMv6ClT6vCAtU929STsnPyRrI9kGjxP+CV5KoAhgvNGEGBH7FNsqaBuWlnIOZy4e54haYZl4+dFhNWXb2BnngN756XCb37pbJebe5LcFHQC2SMaLCiqnAyNUGAdal2AXrGBv2zGLpw90HtOv4WRcM/nmHfb1WOT+JXLjXpy0pnzuCCHmXhA7uUaUtsNxdbZWa6gj5fe9FNuqv12OEiVlAYTFxiFikN8au2W6Fio9dbwe39K5Z37+6F5n7Jk6cHAJZ80GOeB5Z8PyEKllazEVKtNum6ZciOtBS2Pslv8U2SpTJ0gUu5u61L3plJhfFMCxbEx6cB/+Qs4XiePpm1xzip8dhtpnU3oHkCQsjm9HAF/IFOeQeTmmw3oEeJAyYjB/sINeKSmpBwLaztUAAngpboCcpc7YgmyNZsCDoErdVD6s3wxgJCVYrswG5xkzsC331471F08pCLSTo7Rs2GjsOnPNmJDSFnxs8L8AuKX3XZnzKzL
 VtbXMoK6
 nWHt+edCBx3UKjD3ZL2BK7LCIMC+/KxX5xQthlXtTrxszCwedGv6TQNtQEkkzLYQD4pyogVxgKPNaVQ8aR0mHUTa3b0YpEKAuxb2uD4ZkzvceOw5d/NWBfUWqj7loch6NPJlGPrD46qL6hmb2L1lH0MDKN2KSb8IY7dWgqPI/5rhG4SWQPrWBEM70uaclgfnLGotLnZAQHRyYR+oG5KVMYx1evRSJgJDrn0aj3AEI/sOEH8gLBQ7dtOJsjOpWmtGMGvTbkiSwMhjgBGSIo1EBUysG0DJfzfeqdp+BZJnJysvozAJJqmc9LTebzNoX3NOqb3DuFcQ5A4Wwh7jimb+GObSCZzYEhBpFNHhYlbWo8L0U7vIM3gx0ZZnsSO87u09QuS2qvFaW3LxGX08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 4 Feb 2026 15:58:38 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-04-15-55

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b20624608f350c5dadd74577629e90715d351e2c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


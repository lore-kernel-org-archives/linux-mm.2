Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AB1CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEB28E0019; Tue, 11 Nov 2025 14:11:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6EDE8E0008; Tue, 11 Nov 2025 14:11:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5DB88E0019; Tue, 11 Nov 2025 14:11:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A01458E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:11:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71E6186BCC
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:11:04 +0000 (UTC)
X-FDA: 84099268848.25.AC8DA1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9CF391C000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:11:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cme46EXd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762888262; a=rsa-sha256;
	cv=none;
	b=uoOAfmxP9+ZA85S0mCL0BIOh1Acef/HPc/epVCfe+m7X54srUxCAHB0Vt4Uv9LFfBvgMPT
	01KZjs2j/4NSatMadU+qUWXKx33AhpfKl5wNOTbVtabz0FvQ4Mj+TDAA7tYxtSUv2IY38o
	f7b4vHJWwmhTK0rnqT3K+Bvv+VOHYHg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cme46EXd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762888262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=nDQCy7jD8dUY1khsHpn75SNWWzfw8cUhpoL9NIM595g=;
	b=x1mYn7iJ/BA2QQ78g6u6KGQwODePkBgqPl5wIdFQmHudDjw+WahaRb8mYmqii3NVFF3hUa
	h0S9moN25/tZy8t6q8SItpyq5bVuRTmfLxfYnIIiE7vuwkIJAH274cJ/Xj0c1iLBgAW1m3
	+gaJsTPf79YO7y5AwyUagpt9wFsUtJw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26BE760202;
	Tue, 11 Nov 2025 19:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC92BC113D0;
	Tue, 11 Nov 2025 19:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762888261;
	bh=gAe4sPr7e7v3nBPzgMetHpFdrlCpKdnQw8fJdSJDi6M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Cme46EXdpW99bLE8zU9hrxWaBet1uQ0s6yfJ2bYpjT8O4qmNcEgo5p4aPjhj7XafW
	 wV/KivrEJk5Mr2FnEyKS+M8vBVgwfpNIkOzIQ8hY6KDDUwiDnfbhST9Uk5Y5S8A2fc
	 vwROQbG26dRpoZuFfTnykZAyA5ZDeKAOHhEUPdVF/Y7mPrSsTzkd/BQ6+MngDQBIWY
	 WItR99TfsQIY0DkoDu6mXz79kNd5vg2Yl3A++jCGwfq8pleF7nIb5gZppxhk/60UB/
	 sC+5SqFo9/HOK11I7Nd/Dx/LaHHlOCMh1Kh+poON528+9ojQL5yfvRX3LJi5EdUnZ+
	 WQTiRklc9+bNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3405F380CFEF;
	Tue, 11 Nov 2025 19:10:33 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.18-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251110193247.b023ed17d73a8a82510d7002@linux-foundation.org>
References: <20251110193247.b023ed17d73a8a82510d7002@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251110193247.b023ed17d73a8a82510d7002@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-10-19-30
X-PR-Tracked-Commit-Id: b05addf6f0596edb1f82ab4059438c7ef2d2686d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 537d196186e0a0ce28e494ca1881885accc35a12
Message-Id: <176288823187.3549715.10391095070329025115.pr-tracker-bot@kernel.org>
Date: Tue, 11 Nov 2025 19:10:31 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
X-Rspamd-Queue-Id: 9CF391C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: t7n7dokjrpo7mfopghkwfrsrgwkydrww
X-Rspam-User: 
X-HE-Tag: 1762888262-259267
X-HE-Meta: U2FsdGVkX18B/HEiPeRiUgbt1qBjBdh4jxEPi06Lst5bJg/38R8Sk0LueFPuP+0r5zxJkbVMtQqVOdddgtfl4OM1ONbjsWYNOlvqjJbxSVV+GAEmqCt0LBJeIJl4Dm0uI4+zisTAxfQxQ83JTir8hxbtgaXCBb/7pKZm7aA4iph0z/WNswdmNamDmtvldObqVXM0mMOOTqWq4ivXbStt080kBZ+MDL1TH9h11kd0OHK14VWwrbrZDl/Sbz6JJlr2K+tTpyRx+CJcvYkmwsASVlJPZx1qIdKoADyu1HcQUBxbRnNbxOZK5HwWmnKZ40+dTRszbDj9jau4OyndLwccB577UHAjlvImP66QPw/PYQgHZmfzcR4pZITbmZE0SW5h2mgTInjSZdyqJPvyvhDlSRveEDe3AYOKiYm+QdzQfBSGNeNkd44KS5MemYcUHM5s+Me3lkzztLPxLiFGlztfLDYQivOuoXXj4vS5/zY/1hR/mwWroZw4mF0xeJ4gwebvZAIdh+ldhwkNJJ6NPkjS/4ooan8+tOAcvK13bwo7Fc/UNlV9TOFfvesC9+tqCkUbbEgK4XHBkJJfVpk1Fkv+tEWmxFFFAIj3puWVxzhknAy+E0Dge3xNOkWUafuBoAU18UMl8n5ymgRwfu1dh41NjMVJhCGk1JA2cS6bWcHG9UkpOBGb970ca/pnqwpXgobC5PjidYa5xC+iCbD00w9IdCn4FXbHT0uRWloPjFTsA66KS2dJ89cOFMuMPb7XSRRMeMCxTohC74C7sQvNSSS67WcsfVcQXOEp4c1cGE0HhUCmEgY4kJjuseSsXglpkLXmjowqINW+jK/qMN7WRKm7RJp9ZgFCc8uk3Epbhmw3nqBcpcibXK1sv7h7POUIAcMUbYckmH8Z3Fg+/IUA0iegz2l4Y9BcoVOt9ey3cKTZrb/to6yGezeP0pfGu4WfcnHJNrflLi7643/wxJ7+cl8
 OdFboiwg
 JPqjKKnN3ZlhUCZyv9Ce9sySh1AKHgd6M/QR2Jzh8W40Bker/SCkR1wqePj6q0heo9+NKvtpgDwpAOcIoG5fxqDHLLK8yM2mqTb/0Ye7C+5mZ4TO1OLSocMhAyn/eK32eLTfoHsmEfQy4sTf9HySDsoPV4LWX7Uk7Blma64hQwiQM5U2PN7CQd1SVkR4l58oF6L3JylHWLKpedTgayE1XLHowr7O/h6SZLnPKRaaQ3XfYV6SZJANXReSg1N40+F2Xjakvl9tpxshFIiTgQRBaOVe7SWGRdUwE0LYNmjqElVe4rRM8TaI1XDiG/PSjz/XSKUOuvxINS5FLZbk8txHSL+j8nZ114YRp2JYyaEQVMcJPD8jHgp/hue36/n1GnKHvPwGr+Ymyu4qwJ8o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 10 Nov 2025 19:32:47 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-10-19-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/537d196186e0a0ce28e494ca1881885accc35a12

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


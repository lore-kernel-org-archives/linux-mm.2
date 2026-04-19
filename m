Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880FBEA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 21:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906B06B0351; Sun, 19 Apr 2026 17:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B89A6B0352; Sun, 19 Apr 2026 17:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE646B0353; Sun, 19 Apr 2026 17:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2956B0351
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 17:54:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02A9B1A05D2
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 21:54:38 +0000 (UTC)
X-FDA: 84676660278.14.0EB0F10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D05680002
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 21:54:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oEUvKiYE;
	spf=pass (imf02.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776635677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=WUbJCSWHI5a/tA22KPApz2p6VA9rHWW3v6iQQUqO1R0=;
	b=7u1KNRGLiLEx9r4UssA61+IqyrRZ+8vASpFDE4z0epMfPh/UKiosqM/68yf6Wbq4Ziu+TC
	+gOgCdMUL7Mnz8nKwaAR5OEGoQBZ6Ju7v2DA46jL46E/UP32wPWsBc2MiVD0qQfLBkPwJM
	nYppc1CXGoDF0qFbStyduaJ8SBKlR14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776635677; a=rsa-sha256;
	cv=none;
	b=vdhHVAlzNcBeSoXlrtG5nTPB5/ueqazTOy6vWrVQ11fZ8BX1q8COPjTLfjNa/R5IMlWa7x
	7FXw/FxN1piZab/laqykEGaiuuLm4tPPhKNnfAjqrWzEwzZSfsYROuohn3nN8Urv6wsdBS
	V0D8frb1IAxchjrfX4tGxzl6pjM7ngY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oEUvKiYE;
	spf=pass (imf02.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7371060103;
	Sun, 19 Apr 2026 21:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B462C2BCB4;
	Sun, 19 Apr 2026 21:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776635676;
	bh=xp8O3ZLidwKRYT26LD2n40Clhacjz4g/4YMmM1g5G9k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oEUvKiYEmKbKaEulKKqkBTPmg6aHx2ksXrdPDuFReNGuUS56iu4mYKE0lvPOFwPa5
	 Ugi1OjgBhRZl1pUlOrfO88xV+CwZQWTIkOHE0tB7tB4f2h2IK6qAy/RyxQfLtysZty
	 yqxC772Eov56wzbAoEIVkDmBKRjOcHXVuQJSwk8lUtYwbIZJvIx2e2fXYEpeKc9weA
	 7+HkGO7K+Pm4r9sSS2sAp11MEhaDy5qx2NJ6xlYCPUnuXnuPXqd5f5OFELAbkGHpXA
	 GqjcSX/ZQaBpkrgW8+RTCFptlSweZnQ/SlOnt8bE6Swn4ddV6YphvpjPgNxBmxeRkD
	 iZadYCDDjkegA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9DD3380CEFC;
	Sun, 19 Apr 2026 21:54:02 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260419115803.3114199cdc346ba9654958f9@linux-foundation.org>
References: <20260419115803.3114199cdc346ba9654958f9@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260419115803.3114199cdc346ba9654958f9@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-19-00-14
X-PR-Tracked-Commit-Id: 95093e5cb4c5b50a5b1a4b79f2942b62744bd66a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c1f49dea2b8f335813d3b348fd39117fb8efb428
Message-Id: <177663564117.895827.10985364203298298867.pr-tracker-bot@kernel.org>
Date: Sun, 19 Apr 2026 21:54:01 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: hu1mx7oqweui6thm6f3etqm6fytmg166
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D05680002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776635677-697335
X-HE-Meta: U2FsdGVkX1/0mrsqcXVXWr1e9zIbJVH+xpKrjKr5EdF1bl6ez7o7FEJXipqCvAUk6yF6VEUlpbeKVYL8PsJaTDWFwCCBkyRBsqHi7+5kazytoNH2XF1mx0a756R2sQhFeDw9HaO/VlItZAWzER0Wz/qYoJZHSnAhL53KtJnbFbkE+zKFUXvTGWrip4VaE9YCeJZQP8bRJ4jjF2BgKcBy4fHTbCcDQR07c4CRYzwVSD/hcDGLe2eQhk/QexBfP5LcwzIkN9Dd+OHV03hz0S4U/D0+xDrQjP8sYqVLCLL6kkYrqFIyeqbi5XNZxR7ZKvO0JwQSDhCCe2nABw//uO/20rQENToaE+jiMXSRAh2VVuy5vAHK1w5SQeC7Z8+WuSl43bbdJEdu6Fg/hXNzWcLgFd2ti5e0Ri7KZsmFtYJkjha++aqMBme2f/qadvs3PuPKPL46h7n7CNr7mheFCFQ6ji8tOG1yK+PbJYZQJHfuYCp6MwivapRP2096WRCY8GAsPsX5CxXD5/uh+s/gfym/xyY/g0I4UK4eaGOCQ/EXUQUr6vYrsYPnpRZIj2d4IZlV5jSGZcCxniSrzThOS+V1ajtx6sbSPfutmGZ9pMkIUwX6aZf/DaQbUfOLBK2KC8A1FLjdr1pOSobsoO0buOujhTpp7oKIaSiBWvXRq0/wMWMpFH7VgM2ILfJssWQBwKYQVn481aURkOv6+o3yw+C5t+zgBIg4Q4zvJuz8fx6OtiiTzja7wuL6vxy+dfzTiHin7U4aLAnDlaBLYH7/y+fsU38SHoYeVC05KByiQ+GXggxcxDEo8Z3og2KTiH4PmthPqG3JMH86IMiZDL5aVC9ccp0rd2LguI7RzdeI95hJL8pw8hi6r79dNqjX9sFhDQ9x6L+mXVCsMHxAXbPYD9mpTdhzirNDwsTJDpBn6tZc1I330LNghn0NyUqY80ageu/kBL1izaIhrsHYOYTcQa8
 LHAZ2hPR
 Q1B9lf/3yDMGa/nqD4vwnFiotXj8NVFIkiXc++vngtZMoooWNRNP2O85dZ/GBzStZY+SjeCTGTVHMjRMGDs38KPOw++Nxwe9gT7pBwdLtpz0X71zZkcfk56Bk6BCm7lKz+y0OV+sEkqzGTa0Ac86muPAlqWBoQObOHgBFNLgMa854ficsotfrnyDzh97jXam0PV4CqyZD3q5fWj2eAPC82dmQnVG1WMYORpyucvrux+3OfLo7pI35Bz79RzpAYLNhDNgAx9eao/dBf2CW7SxP2BA1Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 19 Apr 2026 11:58:03 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-19-00-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c1f49dea2b8f335813d3b348fd39117fb8efb428

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


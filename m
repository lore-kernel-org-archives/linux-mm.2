Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42409D1119B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2026B0010; Wed, 26 Nov 2025 16:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992C86B0023; Wed, 26 Nov 2025 16:13:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8346B0029; Wed, 26 Nov 2025 16:13:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 78E3E6B0010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:13:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DC2F140790
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:13:47 +0000 (UTC)
X-FDA: 84154010094.14.01BC4A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3058C40003
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:13:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPWTd1Wl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764191625; a=rsa-sha256;
	cv=none;
	b=3mYK3CO4X+H01nnj7z9xZtcylSCqU0N5retNtrX/pMYRja1M7b4pQKn+MYBjPRT+gRd5XB
	rpsND0CqvBWXV9q1KULgDZIODSlu/mi84Aepwn/NQSx0o9O4cqMNuKYAMuSX9gDhBxW5e6
	OYDNnuqNLyHMxsHWvSIrxzMciu01LKY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPWTd1Wl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764191625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=8hBLrtMsHNJvf6PdEEwN+gYUeU7F1kJgGRkwy19xEB8=;
	b=Jlvv5qlizZGGS57MkHMoqJX6HVhXLaGo3WalhAqC2ev1/XAAIelByQyjeQIs6C7TZMdUlG
	OLvyBZZbdCuuL9jYfX2NlbONpsJJnNocEgZixC4U86F708Txbb6eY43UjV3mX6oCTY0hap
	YA+tI2R+6xvprLwX00fVNhdRkBtZfEQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7735439B1;
	Wed, 26 Nov 2025 21:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5400C4CEF7;
	Wed, 26 Nov 2025 21:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764191623;
	bh=CHaXt7Mj5E5nPYnWOBYVSOk/Kdq19B0is7PCYQwmKUw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EPWTd1WlcShHd1m8qu545g/pne8wyirk+8gd2+8TsH65io4QyFb35w5qXZ2fYQ1c8
	 Dz8O+uVAc8GFx6a5AeBBPtWSAYiabwojilyMBQi8kQIaXEgPRE4FrPe6BJiNnIUbud
	 dMMM0FvAxlAXcgJmzwZjsjqbcpCxHuY+9rfOi/GD8sJjmyJmmCeSiOiOzPFReMBg6n
	 xHBOUg1ndE15giQtfYxeJ/tlkuhD8fTAJGUJs0tXJTzcqN+RhrSQ9evEzGGdfiFo5/
	 9AByGXU7JYoMxAepuvK4xOfWekcTM/ge6AYr1XGTNRqiUfWntWRsOsDTs/fvJEXdVg
	 EvwVCoVDqOc2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE8B5380CEF4;
	Wed, 26 Nov 2025 21:13:06 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 6.18-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251126115356.e5fb496a181886475567ed74@linux-foundation.org>
References: <20251126115356.e5fb496a181886475567ed74@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251126115356.e5fb496a181886475567ed74@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-26-11-51
X-PR-Tracked-Commit-Id: 7c9580f44f90f7a4c11fc7831efe323ebe446091
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9eb220edddb20a019d1630347555bc4ae1514e61
Message-Id: <176419158535.1847725.8946913720051022935.pr-tracker-bot@kernel.org>
Date: Wed, 26 Nov 2025 21:13:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3058C40003
X-Stat-Signature: gapcsq1nr7fdimn4buj8xxkaffpdqn7t
X-Rspam-User: 
X-HE-Tag: 1764191625-659007
X-HE-Meta: U2FsdGVkX1/LK5pnb942E5+7OQrvEPKNbuf4laGHs44HdLLuyxvagNveUmvDy1gGKkNpDTQYPkh0BrcX6fOHAQOvCF4Chj4iGTEy8U85nWZKsvnzbslt8dsTFXLoGEqM2NrhOR2+efA9ZZC86/JFxpy3tvnld3kSAtcz42e7B9r8VEFqRSt46LVsAJWwa8VKaFx4rmaYH2nJBxhQfoVgBPa8f7KU87kUT9qWXG4gFtVIHUAhZM5TQEWOEl6w9zzy311x1R5n2fSGLahpzVhPPSCe+pPQh1GZwtsfRhG0aMwYlnmHRaUnRTqU/OqHAw1dIJFGdga2OfsLlVgiScoTkRjAJxybndc7eCqrXi6phQnBXpQU0EiF6zHnU4mnNfdF6RUrq1wZqBo6KJM3hKai/fyAnJdL4L/tCaAHDqZmU5Y5UjOBAxwIu1rF5xBWCj7v2AM6nIG/9rQvsnSuzINaltC2AjSIztc1xNcWBt7SHc6/4W7NA9k/GHESfZ+/EyDHjy6Izp87+tZbzk1yB9Ti3RcYaK1RG6/TzHBBXhVrAYKXn9P7E/6jLI2yC12tmLdBKe95ZI9bhJnFPKnyVIzLeK1stpNdwitliuPPRfiX2ZIwqsYNkJSvKyhUc1yERXcGeBMwk4DhL9r7U//YNloote0O3eSfUo3HhkqrOBcYJ8Ad0tdJLFc5uBaUkZg1ZxgsSX0K/5IZq8O/l4I15tEtikyXHduRMrZ8P0xf8dIV1noMz7PEPCN1m5ew3Mbq8S19gkzzF3Go56qasy2G0zt9f/8U0Qbf/EETdOK1qWtA7h0QrJ93PBgPj0LN12qvwOCiXNfZByR3+L3WHIIdtSQXM8jcp013vEvqJOkGpIbppOnx3cJI76IY+ufCRqpj1JLmfF6mkrBIXpSF8sSvWJ+zGfFVkl2DN4XdRQezXVb+Qd2/6d55SqRW0aHLpdBLS2mmjaEUm0wikmGpR7S9Dng
 YNVpjjpv
 hcN5oVDTsPEGI6NqL+3P5OX1wDJ2/ekW1/MF4v6P4YoGKbFFLCTRbnzGnCcR8nWd7rO3hYREe3XiaqsutGU8/j/fb/6Yjoq9RM+Asi4D9+7zv/J3JVH8gkxeWesNa6ndX1feNo8eKu79jioM+eQObRw23A4IyTVOuTvRB71JkFTKBVTvVsel47/iB1LmmF33nW41vtrlCI0URmnlS4zlh6q4I79KY4WJsf+FSqeVDavOVYlXNyFcHoSQL4fDjjyhaUTnupz8Gn5ZB11g5yEAuXVcquA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 26 Nov 2025 11:53:56 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-26-11-51

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9eb220edddb20a019d1630347555bc4ae1514e61

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


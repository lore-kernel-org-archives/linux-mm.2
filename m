Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E390EF428E0
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 20:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504626B0005; Wed, 15 Apr 2026 16:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5376B0089; Wed, 15 Apr 2026 16:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2576B008A; Wed, 15 Apr 2026 16:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 326E76B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:36:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C565313B39D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:36:26 +0000 (UTC)
X-FDA: 84661947972.23.8F34F91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EE6B74000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:36:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P0hmam+1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776285385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=MdfbOYI3NbYsa5xwBhaXMKUw04TrPErg85dFC1MZE50=;
	b=FrH7B9KbNkTotDYPpqk4NZNaZ3ydBdyQ4/y/INP39nmlhtxFywHqYTvLWDL0Q34kzURuWu
	DsM9EX996+0FJoYcXHFoH5gGGNIpAmL8612Ns/ZrtDM6a3v5w0NUrwcIaWy/fA8Jt7fCBz
	2/3o++A5iL+W+B0/Tg4r5h4dnuvmJvU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P0hmam+1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776285385; a=rsa-sha256;
	cv=none;
	b=GGCUD0YD5L8UGiKcC47nC+x8LDt/mlLwZrT8r0z1vmAamgCjn/G3p7B5tkPTaJIx9CVAUn
	Spzqx4z2lJhR2B1KKyUbgCip7NL63o+5L3sCr+IcTP4pPnUBFm3RcESle2frenemDXFk2T
	OPY/m8q6YKPkDAuejBWwMLpdr7IeTr8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9299543BC1;
	Wed, 15 Apr 2026 20:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726E6C19424;
	Wed, 15 Apr 2026 20:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776285383;
	bh=OkRyaHALJZOsKAIGUFjgJClYOhFEvIOKQGIAQaZ/Pp4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=P0hmam+17tT+WnD5WOZw5wb+n/Z5UVQXtRYsuYF7TTTGFZCjTiQXzBkODzcqQsVea
	 Cts48hBL/MF88YwyAbuy9rJ/lF+j+ga21uEvHZt5O8vqQjaR5dmqOWQgsXzGo1n9Fp
	 AMjkRYxGlOAFHUpweDJOFVEUed8HDP0sF1sOljJFCWJpgzmrrPxQJo8p2Fdv5ef2jc
	 c034aYf+OxFGgj5ULeqY+fw91xJkegP996q1TVcQ4PhRJTx06xuoRKXkg3pSSsJ2Eo
	 Rv0DqVVXZBOGaACeiqx24KBUn9yAgGXb2o5S+Fcq3N2NHRy6Rb1asM76FLX7iNldIF
	 ToQM+5K65JrEw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02F3E380A963;
	Wed, 15 Apr 2026 20:35:54 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-13-21-45
X-PR-Tracked-Commit-Id: 3bac01168982ec3e3bf87efdc1807c7933590a85
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 334fbe734e687404f346eba7d5d96ed2b44d35ab
Message-Id: <177628535256.2427174.3960720777414312619.pr-tracker-bot@kernel.org>
Date: Wed, 15 Apr 2026 20:35:52 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EE6B74000F
X-Stat-Signature: m4qo9oargrqttgmu8ects659eoaw76tr
X-HE-Tag: 1776285384-62786
X-HE-Meta: U2FsdGVkX19kNGeGNMZ/Qa+6qSLBCtqGGztat/DsMwgWz1A8VC0LeOUhAs3HhCzm1BPLzoPonhN2TAFfI5DaeNzcQ/Lg8wHfoSyQ5pc8lVv5DDN4uZa8kAtmHy0qTR/5yvIQB1bgxM5O4YkgfK/g5NkpF8JznLR7rhqaZFsxVwEGG+r10hXPWn32wYOqdpjsspxI+zKIGN+UQqtR7uRpRlUh0YnDfVXuO2Hh+DA53JBl7Nm4yZJAdE61Uef0vb8KoHjDg8G5NkgP/c5e2RcfPLWpYB8p7AZAZj/jNowaiZn/lymLowDT8Olz8EkyIXOAEYvNaii2eO09tsB0Xdm7PtmEElE/nA45qpPehqv5DRgEkRpjGQ178WHnarj+RzvOva8s6FEEbSq9R3GlyEIcPMwJEANsUiawncrBR4hP9ade5+oOxuhB4Q94DTnbjUuanyyFpZkY+9AmyoJnFnbyvcRm4e8yMQ4006fx0hUT8GgCvKyGQtnlu5hlpVoANYEFR+53m6+bP/+EZ3LNlicGm5BT72I/Rtkq10MmPS3FqaNWgFoSILROQTEAto2VxHu5v/s5mIZ+B/Ij4vpFwWtfgr1hJ7uNMKj8lzQDzmqK3ntEsEjhF6g/ccwO+ns+xD42RCmb+weWMi/ahX715aoIPGZOF1W7hWl5y0W3O6cOOoZ6rHytc+FfFcMdBLeSXPPRPV4v/NfjpgjCdLjdZCF5F3VTYiAsThPiD23hDFbxDduL6SSmQuas2312xkfJXuZS/vpCtSm1+yleghyfRsyFpW9IaMLm1mfidMr3+sLUJxxFyMnKex8bOtb56uWbfqQpYAZn+0SLVSGwFiaMQQeBHYugv6/XW74RK/nmlF2nUOvfA2UbwObI/qeWgOroSMvIw0bWgVMUgD3KrTlK3BwVGpy1E+tXURWgMLTtsda2fEl6gECPvDswuFNWPfOJqk9e/rI3GiaFZpbSb9N7YPW
 FWXRAHaH
 mFIdTXPf9O6ULeCzdcHqUAngPMPM6wt67pHZQRQF5JK1jUY3zuViIWVlNfttNR6lVt085r+m9tdGKSuxq6x5uhdXC2BqxRRfbRg1Xy6xxaX6typohLHGotjimxigcB4fazFJffrik51Mmfu/r1V06JbLFBG7EQ/AobLSA9YABUC5hSiQivx5Rt5P77x8hqnZlEZSGr7H3tz+nMucuDALTrpunio9+7YppTnKGMGpaafVKToaUm6YYgVK1NkOxQyTv63i2yxaI9Nba3hyODIv9OYTjTjLM4BsyY+ARM4pRgOm7fLQ6Q3Wcv2Xl7bgBcELRnuiO6pi6F7kCaCPMVFl9FiAv9s+IAYEeNiYBScMHACxD+3jLncFAJdnn92lqHWcTS7+8OlJY6G0dcTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 13 Apr 2026 21:49:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-13-21-45

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/334fbe734e687404f346eba7d5d96ed2b44d35ab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


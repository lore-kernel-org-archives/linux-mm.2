Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C630CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 21:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9478C6B0088; Sun, 21 Jun 2026 17:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8BE6B008A; Sun, 21 Jun 2026 17:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E76A6B008C; Sun, 21 Jun 2026 17:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC866B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 17:09:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8CD2A04F5
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:09:25 +0000 (UTC)
X-FDA: 84905160690.10.3996663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0647C20005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:09:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7iWdAqP;
	spf=pass (imf13.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782076164;
	b=ZqGaKaixMDQK4SCoi4FlvJsoRaRR7N9mOMambGu50DOoXLdiIkrAudjXa+v9wwD1d/lT5R
	ZUYZteVOMjDroK7FensvaDAaI1Qeloj5KuKya7CQd6Ieswe+TClPu9XEHGCrIMTZmkkZjs
	Xk1pRMb48gNBF7bcRHdL69tWQ9v9Oc8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7iWdAqP;
	spf=pass (imf13.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782076164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=tNI3BTKWQnW0XLih6fm4AoyOHw6aYAjSTdAk+RAUuAQ=;
	b=xDDqMZ7FJdj8WOq6mz5S3q0GXFFkIsE99uAmgH4jbEjRretZYhwdigq7oj+6bufUCTZlaF
	DQkKLr1tJNLwvReODD02RUoNOWengRm59RbQHt9vohfhhi7kiqIeoT6lHfA7Rr0JXIHlMf
	FVRPLprUWbLeQZ5GWsFaByjBSMujb9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA9F640171;
	Sun, 21 Jun 2026 21:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24DC1F000E9;
	Sun, 21 Jun 2026 21:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782076162;
	bh=tNI3BTKWQnW0XLih6fm4AoyOHw6aYAjSTdAk+RAUuAQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=M7iWdAqP88wEpBAFWK3jfZqrkR9wgkDFAKs2qEzu/U+mrG8zzSX37GE/UU0azjkWc
	 XBgrKeFMbtdqk/NioyncdEka9EYK6QdUuze6ZQJEWu0XV9KEvNvzxL1wVeSv/OhAGX
	 QMBJFlko6FXKUsZLo5AuXMkLL9mZ8i3WKFZ76fAkvKFhPaWvMMGiMbYvNOf8+D7jkH
	 XAqGwZVtY6Jern2cawFChkktOfBjtZxujyzs1BZJSxwhKwGGjCUzv0UPJ1+Nb9rjsG
	 d+kp7bnZhmC8Q2u+6Y5M/+SaL5kaW6g04ElbUe+yIy5+K64issE1bKqUzdSPiS3NIQ
	 07wCp4gEqIyuQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56BB23AAA6E4;
	Sun, 21 Jun 2026 21:09:15 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260621102749.186ffe45cf2fd65838bc3ccc@linux-foundation.org>
References: <20260621102749.186ffe45cf2fd65838bc3ccc@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260621102749.186ffe45cf2fd65838bc3ccc@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-06-21-10-22
X-PR-Tracked-Commit-Id: ff6f26c58421614b02694ac9d219ac61d924bc68
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e05544060b9fef5d4d0e0172944e6956c55080f
Message-Id: <178207615376.500153.10811916983795748695.pr-tracker-bot@kernel.org>
Date: Sun, 21 Jun 2026 21:09:13 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0647C20005
X-Stat-Signature: q49mzyto9k319mikqdtrtgcn5myuzoxc
X-HE-Tag: 1782076163-381370
X-HE-Meta: U2FsdGVkX19rjpmKY4Fo5G9HRSGbwh0y48CW32EXH5I7ZufU7Il+n25emyNr9GEb2EQ38fCxpzXlMTcidlh7sLXdGTbe3CxOgsjmXPyqKSQ0EEi/CTZz11GtSuq2ik5MXrlfej6o0h0Yog/ejijLJsT+lG2O2Ah7DdbvbRbcef0pzeXypcGhj56pMHFlr6lGMZPhIiiZeobqakHORIRArYl6pq2y/XRqGFO7hLMTFxsSlMWqRALNADH3AIsnTGM+DiZiQ0SzOkJGczoarEQrlm7vwtzHEPYJXoxx4SnKu+79XOx8daTRDWEB5J4RU8mjjheKIekLQjQuJ9q6PszEXGeftvWm35c2RXpUAcqZymvrxO5GT1/nGlDRav6fjUbuXBeaBhjnW1fkpFRQ/5K2gPFcHmHb8MYLr/wWD4lERy9YgrN1f8hz5h+b0wZPcpY55fLEPoc1qdxJdZPh1kFYFqy6SVyuYXcqUfNZ+Tus4OvgHpG5sWWEzUxNT2rAi1WjDVYQwmYP4knqXCjDM1s6IHFBU5Y2KNqo3K4HXRxdiCYcJLAUJNupKDiYGa343Luo+ykTONrRGnN7uaTh7Sy+zlNetR9uFIPUpwwm31VIasVIT56B52I2B1d3RZ1SKHZyV7Tb/fWgt/q3wHG7Q1JO3ieaJBJQmf89wQPjhfNjxt17KIl3Dpq+kwxbSDaES26qNhanr4ga+Kfj04E64exjaj60N1mphHPpt7oBpY0La19oqwqMUkjD7GBIlqV4P9UCWdUqsNbDP6ViQMZTovZJapfLhVFaCoV4+mqky5XVXADZjpb1epHLahOuW7yJiVrAkK5xcxE4LFnvOL8LQ4fcg0QvwX8F7c4A+Zxlm8JByHSBLCZJ3cVVx6T4kWsj0I682feCgPgOr2LSY/W2JnWRZDij/ATa5/sHaaN2HKZt2ZfsIPXW/QmkT50TUs7jWBVq+JtITkOtanMJcvtTXjl
 IzRU9H57
 GKLN3YygFZoEwuFAL/F5US/dDpPk+HD5Mmtf4qpl+F0EG81L4hdm1bLk35Dx8wBMuQw59gvAJwk9dV+pg+O4PtfItKj3anfBUqn3f03ijY0B2Vo3GClgBQEbUJComNwzWNPqs+hlH9VNAnnKubkPZ+BJmDlwzuixqmwG38okT5kz5Jcd6f2dDdZkv5zaQI/mk+TyZPNGae0ukchKTPDkn+sXGwuR/1/P+2IYuo2baKXwEDTPw/vr1++0p5zODXrnQ85Oy75Artq1d/qr9ZkqWlU5VbydOIOUJRmGxwKlESE7DzL+3P41IRICrIyHFovVMG9LG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 21 Jun 2026 10:27:49 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-06-21-10-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e05544060b9fef5d4d0e0172944e6956c55080f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


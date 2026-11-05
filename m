Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53D0606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSK3RUep
Received: by kanga.kvack.org (Postfix)
	id BF6EF6B05B1; Thu,  5 Nov 2026 16:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6B86B05B2; Thu,  5 Nov 2026 16:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21346B05B4; Thu,  5 Nov 2026 16:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB6C6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:37:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D63411A0C7B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:37:39 +0000 (UTC)
X-FDA: 85402377438.27.E238015
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 13C60180006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:37:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSK3RUep;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=MqdUX2Td33+rRaomDoEmSN7ivph1Gnk8nEs76vR+Yzs=;
	b=txho6QJZcxu6AmOYDau6JzhudE3tdAsq1Sz5n/w4q92qItA+jGDfB4GlZCdpl9K842aSEy
	/iZRLB+0bx4YC1IugeaCY8FpcXhHgitc9dtAVI+QQARdDAND5CqU4aYuUo3NM4ATAYUsrN
	SsZfZXd7TNL0GqxI9P5QntHWMWlwRT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914658;
	b=V969ykNigyx2h6+a67sXuRNtveP4PTH/ULYmDXOk3zKlJ188dE0BM5x0JgGKIM7PZvBRMO
	HA6VFreCj9qFgV0p4I2E0C1OyMt4921LuZDFHkr5p9AVniSXDQt3l650wu4LOTEiMFJNQB
	OPuAlUB7uQpFdKAuLGb+pka91OJraY4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSK3RUep;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4562A43D91;
	Thu,  5 Nov 2026 21:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291BA1F008A1;
	Thu,  5 Nov 2026 21:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914657;
	bh=MqdUX2Td33+rRaomDoEmSN7ivph1Gnk8nEs76vR+Yzs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=fSK3RUep5yDq4Y3rrxxl7whyQRZOdKKBSHFpctJ26dYpC9Y2TISpYzLZGJHHKaOgE
	 5CDgq3F3n2laURcMXm10OW60J7JL0Pk+nkLl1jZMpf04Zw3F7rppjSaeorni/RcWX8
	 Nya7+HDD6rUB2ZdiSFqzYqXP3U3W8X2XcM4XPziaEVG3sHRYydkNuLBTX26L1eGoko
	 UjIHFGIbHWo1dMlH1Bgg8Zrc9/kdUF60c4btXQgHekq7Fg6I8+fOlXmIy/wmzweNkm
	 BT3xX9Iwq5nksYGG+iot4tbwPokxSfCkYbiCPt8PdwhM8g7HpqezKCF16Yjr3KsXww
	 sMlTT+B/6d6ww==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 21049391B19C;
	Thu,  5 Nov 2026 21:37:37 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM hotfixes for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261104202749.a5b9ab39d3169f80b5089a14@linux-foundation.org>
References: <20261104202749.a5b9ab39d3169f80b5089a14@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261104202749.a5b9ab39d3169f80b5089a14@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-04-20-26
X-PR-Tracked-Commit-Id: 5b4696e0bfc358619adaeab25ad35b4979af8331
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 46a062865b6b6b9a2ba199101b44feb925455c66
Message-Id: <179391465578.190890.11695255160827231010.pr-tracker-bot@kernel.org>
Date: Thu, 05 Nov 2026 21:37:35 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: 3fm17d9riy4at5bcewrs1qho9kqqwzdk
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13C60180006
X-HE-Tag: 1793914657-514879
X-HE-Meta: U2FsdGVkX1/giDsNNl+ox1anV7noSRst73XPpG/Ty+trHCWqTaWm4KxU5rCXUkS5W9M72E++Z2LeToTtZhNm/IL7Pqfv8Q81XUxvztevudcn77Vc3yylKuSigK3cbIg++Rphr5TTMEuc4rOdsDDBOqLIo/vhxspI+kjUZaIp8Cra03wFfxVaja5sutSR4OuDhYGv16b5ZuVqJjBe83orUF6Z6J1a8c7Yurh+18g0UD/3tSCk9HEqPXukGCtTmxX3t0VIbhtg83RgjFH3PBFBu9D6fTCH/VW0hOQHlSZd9BZGVVdROjnLc7oCpXaI0zKE8VG+hLu3fBkXjHDJ0y05pJHNec73hH2WCCQV46hNo9TD29ff9Qh8/+Smu2uHBepBRWe/khO40yJNEN/LJUb1x/TpWZ7OZEOKy0WOy3TIL2clai92vxObraGAeZdsXeB4nfPgFTP3qX0q5wGAiaF6Fi+XGbgVbUbXMyARqfCQ16dhb1ELSDnGFcyEQiS4askwMOdt6fOGYUKX/Dmr/ErAyIJrmUc0DtxnD7xMmr6gDIBdovH+z1M3/A1HDFfbFsbmh6oRI5zYOPiUpVsVmF5Hg3YeVI0VeGAtEplw+6wGn7amNHZJsahnB1I5ET12lWWbqcG4DRxHCaFSzOOwFiU8JgKwz/hNh6RVp6VnaYE+BJfL/9JYQGPOTuNVGTcfmC+RwlRMg/S7e9KgnFIvsVsiCdVulTQHHFJmhy47g6CdL4570kwLP9FmhfyDH7ky1Y3U8QKW/8oIjSY5lJI7i/l0pYTQVuolRb8rAXcyopAZrWSE7MHjX6ERAHfiH9IMDEnBUkSkcfgHXLFus1udcwKiErxLtu7WR4D2M4W57QLN0unllPt+udHZLm6HdkuX3lPtPkUMUOv7VoeIa4TjBxxGufvfvc3qrks01ulGL42reiYv4TiNbmRLJAzO/JNHwMUundDkc9YVFq5h/mWTAGB
 BPKDtehO
 CIfSQTrNDN/L6wF/5+kS86Ng56ENBm7TI85jqskKBFM876Qm5RXfCrXyTShR4/2PF+QUezK5l050s0h07cJjxFbJPgeWZmurAo8gtnKr4uUdNtupSzHksInPNq1TKXdTW6Xw5VDSxXTsCf/HUM5iI764Ctl53XXkOAb5OxlJQo0YeGzAec+tnrrFv2eh0w9CDynGGDAnZ7VTSI1NUIKOnjlvgi7BwaiDU4p6mqO+RjroXtwFgRCHajMk23YOzSnfyLLQ7gPJYWaIndk4AM9fHKw0ucaQJbAICmELKrfZI4fyMr765zdvULBPSfF33r0qRoW+9iWk919gjcce3b8p9ux6J/8YG9ngYS4pgD7pYB77ZSP8xeCx0zZ+QHMrvdi6IIgLvqNECOfXWY/RsigVh+7pMsRJ4WlS8VoAYd8tj8XiS3Jh3q4FR0SS0dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Wed, 4 Nov 2026 20:27:49 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-04-20-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/46a062865b6b6b9a2ba199101b44feb925455c66

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


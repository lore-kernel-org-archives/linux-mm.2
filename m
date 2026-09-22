Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60470C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3306C6B0095; Tue, 22 Sep 2026 13:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0F26B0096; Tue, 22 Sep 2026 13:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21ED86B009D; Tue, 22 Sep 2026 13:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1CBD6B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:11:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF94F1A0586
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:11:55 +0000 (UTC)
X-FDA: 85242040590.20.B595ABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3222F40013
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:11:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k6E1qPB4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=t/k4e0hVfI9hDMz8Wm7fg+eHHKsPTG2TwJP/59CoEi4=;
	b=moyUEXTsuBGxeaA+w9ZTflTewPzI5gjKt+KbViWdWLbrIuK9Pg9Bxiexm6H9UhgmQD+z1x
	DiAhQ7hCA31mBhcoHQQAFTczbcHbwtzGQc6HN3/AQGPlMqqB6Q5BM4u4IjQlphhsSGoQ7h
	i+x+9m0ULHRNNCaASkKYvpanfa3F4Ac=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k6E1qPB4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097114;
	b=LowMyrDTTYOhOr1qggY2UDheFUEVFtlJR8OjIUljra3ry3Jgb+dDEzutAgyR2lWkWD5r7c
	6ijrAfODYBlDM2BN7+gHYxEVJx3sMcGku/ivFHzIhqcAoWfbROzbi3+eur/uvhyUY54daT
	zyjOL1WBpU7zySmsIebQ72kSYDZ5psk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FB86600E2;
	Tue, 22 Sep 2026 17:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581911F000FF;
	Tue, 22 Sep 2026 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790097113;
	bh=t/k4e0hVfI9hDMz8Wm7fg+eHHKsPTG2TwJP/59CoEi4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=k6E1qPB4+vpZRBFXXk2nbd234TILU5Jc80JiM0QEFz1edo1+L33lYKuuArKZAWr4D
	 VyFlQqIRSar+aV6l6KKNfuafV9quBCdJ1DaHSx9xaWp+YO20mQdVsIozbVELgtQu22
	 Ykl9tQ00nVoqVt8U0QrAPg1PrN4HHv1hZiOuf4nfwHpbA+FXvWasuFIEdBbGlU+Hr1
	 4iPlVKM6E6hacGt81kRpbVjMLldCef5Sgm25619o5pVVLcDMEyf9QatuDT+LbgzUZC
	 IPwpm7Q5Ik3OMxG/u7DckHoerJdKkqaUuLMGxrnbqMFN1+6gmwtoDqI8bBfvEq4d62
	 ZVwaP0i92hdag==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93B2A3811A56;
	Tue, 22 Sep 2026 17:10:45 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.3-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260921171728.57318b258faaa20e78c81b73@linux-foundation.org>
References: <20260921171728.57318b258faaa20e78c81b73@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260921171728.57318b258faaa20e78c81b73@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-21-17-08
X-PR-Tracked-Commit-Id: 692dd08e03f4a5523650e055f033f846bee43a0c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a52a93358ac2bef65f15e0069cd410a2b59ae03b
Message-Id: <179009704407.4190423.13832222731277666906.pr-tracker-bot@kernel.org>
Date: Tue, 22 Sep 2026 17:10:44 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 3222F40013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3zh35gdjqmkd415jznfgqnmstwnst39o
X-HE-Tag: 1790097114-977837
X-HE-Meta: U2FsdGVkX1/P0xjvM+GLZj6QkcT6xY8X7u5FnNTFrwipnZtJ/UI2po+6cVKpMEJv9mse/NmQNZCEaQ1lDi7v1nCWwc62Qub1z+lEpmI3bRC3NrStdGF0zKhVww0qE4OCBOjLLRc77J9DAb3uQolfBxgkP+p56f+u/uM0P+PpapS3yBMdUTuPO4FPEIrVOQlJWqS/jgDJ724Xi23zlE3mkN6jTjzYgWl5DpoegRHMOEh873ueEugzKFjZk91WCnDDFUeWT5z9DfbbbAQhiwvuspUMer7ZHYog0lrUALM+TyyXrB+1QlBOnR3hlGGyqdFWHNZbKqrnUlFRCjOXKn29/yCLm0JlIDYNSB7eeJ59GIRtTFAO2lVGV+dLeN69C7MuuJC7JZDqI8KhgC0x182zHXCnMQz8necLGcXY7wdySB84c8ffCa2SgO6BR1+Jaa7lPZlg9clggYFBo7NG2xZWd2rvvnW1I/BNcvd3zGBcUDrcZHLvv0mlZqvqvH18WgLbi9Zq2eh4Em+dBTlk9MBGidv9xX+DGh8vl2CouLVWbMmhDQy0DxPiume1nYmVP21hmSizu3MygACgnZCa/2i6eov3t9EPdKtGStcIhZR4U4QI5jrSTaPINp37UFPW2a1V553/frFzuccbZL2R7TJxuMhFUvFvYhTqC2jPfHzlZylRCzuscjgm3BWzxI0xX/R7/9NeTWyHPUMQWaDeUqyoDdJSYuDgH1h9WhQjfHOIMuRCd6ytmdEQiIc5HUvpdtZtmyAZoOF6KDV8eF7aerfTUmTpeJOir7KGnV0iTXKkU2sStC/jtGHLZt3CTR3JEg5Mx0slA52SSiGO+sBqRp4xIBbBSY7iGV1vjA1T+Bi5QKnyiP0yd9X2CDyun4149nuJHsL1vkLnl33qa+n9JpORgS6WbC6CeV3aPGO/cp00mjLvayjtsr6T8I4fgsukkzDesY4F+92Km1J82N5q8+j
 UXyhkdAG
 9j3TXHttx0i63u4/GSAOe2V08Zrr7r3DWgn9k5wZGumxoMaAblBqkH1IsX8D9offhjcdJKhQLUf0SCcT8d8sDJoh6GG0kEDOZdz4jOHM6JezodRE/RxG5eFhmGX8ogT0121G8NIdiNUJuOIQyo1J6VpdcC372qXYPxTUgKHnMZdnVEr5+HolhwwQWk3kSr2e8ckGqVF3v06DEFVrG75Q0dqsVuCmbtG5QxiEJZ1mSM/EZmSKur8ouLUBoUE1Kfxg21qeCjRh4K0ZBqISgHSMBkfm+dg4dooxN3wrJ2eXK5U7PIVhC9PmuqUMa1nukzoTCzJchZuzoqiilC1xEpGsWQGHUMg6c6x43IvhscRiAZrtgBkDvD2y7hC4pNAK5jFmvutv5f5rN50KrB7dz0FLMv4813tqH+0JKt6RcGxvv9NMHn6E3/bM1AwtsDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 21 Sep 2026 17:17:28 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-21-17-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a52a93358ac2bef65f15e0069cd410a2b59ae03b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 202E9CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168106B00C2; Tue, 26 May 2026 11:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F21E6B00C6; Tue, 26 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBAE6B00C9; Tue, 26 May 2026 11:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9CF26B00C2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:54:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7618014041E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:54:49 +0000 (UTC)
X-FDA: 84810019098.10.8529A4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9E3C2160010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:54:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwGgf5eY;
	spf=pass (imf08.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779810887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=mjTjLcUf3D3RpHdforEePIUHCwUbuLTqLgsCOgyF/uQ=;
	b=6QWpOmNrBwpjlixN52t5MNlihTNHMXj4DGLLktsCKr5traUj5YVY7sv+pYB7+fdO0eqsai
	YhgtE/a4b7iEEorIvPcfWqyqgTYt7nqZMuGMhUQTtHsMxsfx5Fprgw5arzPBiqTtvMtvBM
	4jEoo5odZcvLTSaAurXgUZYc7U29fv4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwGgf5eY;
	spf=pass (imf08.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779810887; a=rsa-sha256;
	cv=none;
	b=ughyqgyf/7JajKSg+ZG/0DWdaKFJOLv8TRwQaH7ziEPDfnknuqgg7OXR8Zhu8YU/VNJh74
	VEHVGYAoWDcyrHDGNzLRvd4fiIk9ghSzeEo7Ozthnr1LDYv22dnH2QSPpFPSQDDmjrBdy7
	IFVfB7qUTitijVDDRsVaEeLzmiSCEng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E992600AB;
	Tue, 26 May 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B711F000E9;
	Tue, 26 May 2026 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779810886;
	bh=mjTjLcUf3D3RpHdforEePIUHCwUbuLTqLgsCOgyF/uQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=TwGgf5eYPo8x81cmujdnoOfMNKzw8AGuohgG1b0mkf7HduN6SB+brzvWeN3KokGFd
	 yWPshT7SJK4udoqPAYn3zyZ5suXDwn5Ts5muoqwnUu2Hd0/Qn/yN5NwtBMkf0dUIh8
	 y1jMN0wlHxm7JlqVnhVeNhBvfIR3zDi3mN5vSilxbGL5S7d6b6hu0A6NysLcnIRpti
	 Xho5JKlddVz2Q+A47KvQpScz9eb/q9vV8Vp33LKlNGzwZy+bPsIX5lmClXe9wc3kXs
	 +0l4+bEX71oJ3ipy22Fx4Ft0V1TnbyJvS0AaetD6xvbW8ZMgO19HrO8eMhRZBGwWUs
	 CnksU9A/U9OUA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F020D380CEDF;
	Tue, 26 May 2026 15:54:53 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260525162455.b407390573351c2d352baa16@linux-foundation.org>
References: <20260525162455.b407390573351c2d352baa16@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260525162455.b407390573351c2d352baa16@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-25-16-22
X-PR-Tracked-Commit-Id: 54cf41c969da6637cce790b7400da1451609db9b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d60ec36cab338dfe2ae40d73e9c8d6c4af70d2b8
Message-Id: <177981089259.3872742.1490966349452710325.pr-tracker-bot@kernel.org>
Date: Tue, 26 May 2026 15:54:52 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E3C2160010
X-Stat-Signature: tc4zauwk81hqgxht3ttdktzw39qyphjq
X-HE-Tag: 1779810887-32874
X-HE-Meta: U2FsdGVkX1+/5om5/xoNPRQMtCeCoxNXdrJ2O3XL85RlG9+1SMCrloRtdcPQ1lgsTV/RMcIOm5kOVTQ31p8WDY/6MxdmdZoVkBp8Trp6R1mQVGs/iN51MSag66FaxyZQEvr0ekdaKD4srHMmiHn/Sj48Ulqrm4XeP9V6pDe4ASQKciPQ8KTXlFH/vFepAu2ACUPBw4GtO4VKMAl+7lPsjvCfYkBkjoVu0L5WiDYMcG4C+fnlIgXLhmzQpERMJhjZzEOJUhFwyVCg1fI3e1HinkLdW5qFY4mog9oQH7FvpGHIIckGQD5BPDso4swcF6RLhiAPjLIGKvbpPSOrarw+j6ur8saoVyz9C96PbM6ktLuBZR8UtwUKiphi1uiPO9K08w6RP+jL1HA0o5k7LWE9ELv9kf/xvXUq0jsr4d8UtEqfmEMy3Kw0zVAe3ElHi43eiDFNcY7lN75j/fnZzKar2ZKfl4trUxCv98L3JMiZNKHBItpyVk0znn2c+nU8sKa0DWAim2Azscl/DXtHbNg0H3b32x4hFVLJyGaUSEQwZlvUvyBAnYCXi5nUpkgb7UMGNsulElTiROef4vqI1fxCra78CB/B9yS9Y6lTw57m1ipTLN7DvLn6jQj0rtkKQtQPxFTEyBDr0US4BWqxCIz42YriXxQADy3ZNX7ALQMLwfIWA4ENv9c/O0CuAjVD/3uJfnQ61ubVBvZa6A5uFYqOqrW+wHg1bqKRIPBhZ/VNeCW75mSmgVYObAaDzDqb57LF9II4QGNvmdndoW2OrRUB0vzubOy4rMmT27hkork8NYc1InRd5rqNmSiAD8Tp7y5bkEBxF2L1miQiGxu5GhtMQlJzI1tBNk/nqX846y1fvp8F3ALRh/wMGvjM0TJhWsYrZa+2d7TEXYYS5+8O8KONiUo2dSdzywP3xkKKgwt4zKRu2XxfHl4UAadRYLsBiK/1K1dyIkMdVLjBPg/fser
 2/Ai4h/T
 Hy9CA2m0YGzfDpg7kOiQw6ZUCxHQ6JAKE2qGwQxg/TWbFRY7pd/vAAbkzkMFkxZXolscARWCYJxMyO1OdeL7m5sjPyxZZTZhMiivTp3ENCaPgdGVqzGbGLilSHhU/aBs35apRxpKfM2mb2v/sSfs9Ry+w0JCqrOLMO734fEVAlliN7jYfxL7QDbmhZJrl2fS0xr74DKiiN0fPc80W9RgqcDEZL31TgZ2jHsJKzVWXmV5y0X7KTaPG4qgdpuMuWpRvJsfM8060Yn45Xbofium97NmV/Wum9G2xK207mnZRU4hlM6eGl9DANIAo8/YeMpm/5NNvCONUYr+qmVkvILpWyN6g6MONJ9T2pfmjnoppxppvqmYWB6wSb0qTEpLQz/AaxQ1WNj1fN0PK6AM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 25 May 2026 16:24:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-25-16-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d60ec36cab338dfe2ae40d73e9c8d6c4af70d2b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


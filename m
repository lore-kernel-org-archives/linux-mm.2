Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C9FCCA476
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 18:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32EB88E000C; Sat, 11 Oct 2025 14:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1CF8E0002; Sat, 11 Oct 2025 14:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1527A8E000C; Sat, 11 Oct 2025 14:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF49D8E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 14:38:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DDE05A556
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:38:06 +0000 (UTC)
X-FDA: 83986692972.18.20D2265
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B1846140007
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:38:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/KaeOHS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760207884; a=rsa-sha256;
	cv=none;
	b=hKLbu+IRZdLmvSJlOomxBgl5FwZI8jWoSSDdRirHgKlv0jwWkGQ0pG9xI81iimSTi8if89
	IfQdafzRx71D+o4TZ+WqBiIqTjEzWUB+kAovF4BXqTy5ZjwR6Y64AN7TxMeFSJqAxm70Y9
	d7J2j2IftDSnFQxotGU6BHNrA0O/fJI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/KaeOHS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760207884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=jtW9Gk/S0XB58MzYPY4kSF93Uk8zHdFEIkXYlft3Btk=;
	b=UoH7N5vp/bldgzuZ7jUO+3KXFg83S95BHh/IiZjtPD/6rOnUeO0vAip19BUH/YDBjqTm/k
	fFpFmDQUK+hssbFY65bocDnKXnXnW8j5Zed8N/t1EB5E3R/ipffCUEXuL3BvAimdCUcICE
	qrYbY2xq6/byzjXfhkLPxqCzAcr7Hgw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E0DD6046A;
	Sat, 11 Oct 2025 18:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15F4C4CEF4;
	Sat, 11 Oct 2025 18:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760207883;
	bh=nRjeBVE7S7W06TYisUW9cjD4R1lazQGWNP3bOhZYVRM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A/KaeOHSyO8pGw0GJTXAgRTGeOPJ36PqqGzlUw0SrKtjaMETHbMCu+KeFizk+apVO
	 qcr1XNzfr0/3Z9+auob7JuCLB2i0q72UT1bfLn7Hz06qXg/yVuv6WJIBZq7e7eiHsH
	 7k1HW7I+D0as8OU1HQYbeazVqj17VSI+SX8hpTtCHiaALB3ZuZZtTjdOjdoBMslBSV
	 2DE6ahIdy1ZSvE3Y5NQuGC1pckZ2qFDeRO5B78+irSai96FEP09GHn/YLr0pj1O877
	 iriCzslOfyeS72lStUkGHKA+kRGhV6FfU46qLRxOMZWvbUVSnduiSin8wjBNvefSfR
	 tcnOiO9VFL9Ow==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD993809A18;
	Sat, 11 Oct 2025 18:37:51 +0000 (UTC)
Subject: Re: [GIT PULL] additional non-MM updates for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251010150844.1ac58a5f9b89aa1e7e260ace@linux-foundation.org>
References: <20251010150844.1ac58a5f9b89aa1e7e260ace@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251010150844.1ac58a5f9b89aa1e7e260ace@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-10-15-03
X-PR-Tracked-Commit-Id: 90eb9ae35727a662789c850efaf225ffe5511fae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ae13bd23102805383bf04f26e0b043f3d02c9b15
Message-Id: <176020787065.1422231.10057956075404154756.pr-tracker-bot@kernel.org>
Date: Sat, 11 Oct 2025 18:37:50 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: ruy6i9ap9nqgctzmkth1gsz9fq5fa8nt
X-Rspamd-Queue-Id: B1846140007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760207884-19965
X-HE-Meta: U2FsdGVkX1/DzgQg/DLjlD6N/LF0KRLp7FT+U7E+XbPsK3Am6ZTuaWBqaLYZh9zO5C4cbqY+UaudhDtsJ513ZOTq4ZEHI0Krmzm+yG2xLiAInN2ZqqgCQPr6PWtEce1puHMNAa2EJg5EjqPjaF2UUbO+YVOpOLRsZWVSfzb1CbFL4zZZrxijzG2+3rMScD7tL7AVd1o803FX4BzeoFlJVat68lLF1xnwMg9i2b6K7SE6Y4EEZ1d567cFQnFTw6zC5v59v1f6Qj40kfDxC8YsRzca6eNJGTmcKSP0Cv3ckc+On/X/phYYQ+eowSCXmjnwLatNU92zHRvwx7Ym2WjW3aPmi/xpxt+qK+5oiz93s52T/U/0/GIdIl2O3cHD6/lD1PaG27lUB12j94xck/3+uE1AsPnBSnaebPWmkCKt8iuKikM4qrb7v+ZIuttT3U/0xBJ5+1oFifaPl1eDFlh3XPBw7cyvSwTRPupDhS6sln7Vzuh0kPEHPZMToQ6enOAruD2Yl+uFzIs+V5VPofZF78fzAky7do3UaODwAEqtD9KiZwfMtanSVrWL4PMwTzypDJ+/NxbvTsV1erzSry9qPlKygHrHLbX5pEPgrpl6o0hbE38TOB8gcHupMMxW21McN/gBDCpXUzC64PbVGai9dDdmjGd29Dw8R3JfvDc/kHSykWcM5IuaQ+3+uvSMvI9sb6AbG0yIkDbrjePw5/aKho00d/jaD+rHvhzKdhCSBDtlI73h1pLB+ySmYhwT0tUL+emKFXrHP4RQzVHRvLuc2SbdtmqNFP2kOMUS0vtGT8KzZ1jGOBZ4AYw1DnaJSDyroBeQuAm3wr0gukOXiKl2a1yl5pHXQs8YKo9y/55MlIxrsn6vz9KJsyZ2d6qeds8f+03CqewL9sKJwadVUUbiWi7PJe/3NgC9PaJ0yo8gSfcFhlO6vihJE1Nfc+zWUiq7CoZct8bab+nL6cnAWXk
 Z8WvuqO+
 flNkcCUsVhVStVXQu22rxLgu0vcXb82ItmMGQaTvWaC3YmVZDaXqgqg5Hij6HIuyWNFTJV8AxjUJnp3Y5VYMJ0EkRBc7Oa5MBRJ764oWk9+KV8tv/JMJ87X9H8m62Qde0Bfn3TmsySyX74EjRU/lPsfR7jN3PM8EtX7tPoD0Jrru6GFtZQ9m26x5uVZGzIstR2K5G3ZZSSeiKOTJDecuSorn7mbqERDwMMpymxjNBaE01hp1zNKvjbiwleCHp3Ov0vTlnGgs8jubCbU3g4qntBILQa00UFxnIBWcTzdMehc1PRBPNAcnprDjMLt5TaLtb0pgG+H60cSpR2OT5UuQkOYPMMbeLJhP+oLTaYoEkvhd1udCPrNlKUHgZnWrfnE+BBkjiU+VqiDaZ3vs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 10 Oct 2025 15:08:44 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-10-15-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ae13bd23102805383bf04f26e0b043f3d02c9b15

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


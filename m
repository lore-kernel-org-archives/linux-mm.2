Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C04C61DFD
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 18:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2796B0088; Sat, 21 Feb 2026 13:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B607F6B0089; Sat, 21 Feb 2026 13:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C266B008A; Sat, 21 Feb 2026 13:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 923F16B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 13:31:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43327C1FDC
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:31:46 +0000 (UTC)
X-FDA: 84469307412.13.527E21E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7D3374000D
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:31:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uQ58nDhT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771698704; a=rsa-sha256;
	cv=none;
	b=WDd0wpd9Vlny2M20Qcnfdy409pcbq8ZA8HXdF75neYCge3NrrCykJAQUhd4aLHC9PU99OD
	PcSWEnTQ0oRWbp0eCPMsa3PMjgIacgUgCFyBJksFdGuffKWTSto5ZYxpnhDZ7qy1s3Gwam
	kkypJN/vYwQPlXWHBBZ+VdsRWVm5dlQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uQ58nDhT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771698704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CpSEyt2Bz6jF1nDVa6tVNFmBKBC4/1g00X4HNf6NDxo=;
	b=ov5FZsSxQkmCTJ4MUrWqzMsy/QmrJ2RkBGiY6ddQynNl1DHR8+j/nJblLuLBkhuIGN7+Um
	6hf2Fj8TVFtGaWfe4Ai5uUjeG1ruMnKn4zO9mbA4m/deuEOm3l9Uz4+XeE/v5cP3tIWf0G
	elELknpnVBTq/1siTC3H82VBuNNhgUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DFA8C60097;
	Sat, 21 Feb 2026 18:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9796FC4CEF7;
	Sat, 21 Feb 2026 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771698703;
	bh=eu2Qd1miG4+A86SNTgiVxIiJHHSHvccLdVNaE0DdCW0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uQ58nDhT8vcOVJYkpLg77asutNk5QsAqPCbCKnh6gsdLXo4OL1YlJi3DhIZ5U76ig
	 5v0mDMWq6j0Fucf5mqrioi6U8eJre1OjpJaeW36yEgnxpU+Ierd7Cax3otWzmjKtB2
	 zaHhBfQGHPStZ3csMHymXNAmDob5LVLF4T6lj4QmdYXQlkSkwqSf75bIDjiz8d9Sau
	 lEO3Z2Wnzid4hMfnFuE0+F6DO78LnXAVT0Y9QsPb9dTnhiYqWnNC57gwb+EY54Omk+
	 wvpH35BPAGyibG5hg7wJyGkL7EURoLzuIgSO8XXSr9bfMmDjsP/6A7B7ZRiGH2OKUN
	 +jFtLMOmhTShw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FEF73808200;
	Sat, 21 Feb 2026 18:31:52 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: numa_memblks: fix detection of NUMA node for
 CXL windows
From: pr-tracker-bot@kernel.org
In-Reply-To: <aZmMhdk7rrvJ6nzS@kernel.org>
References: <aZmMhdk7rrvJ6nzS@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aZmMhdk7rrvJ6nzS@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/fixes-2026-02-21
X-PR-Tracked-Commit-Id: f043a93fff9e3e3e648b6525483f59104b0819fa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 817c16e5655958c34035a10c8c4b93e33e529624
Message-Id: <177169871094.1180555.12921561342220457943.pr-tracker-bot@kernel.org>
Date: Sat, 21 Feb 2026 18:31:50 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Cui Chao <cuichao1753@phytium.com.cn>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D3374000D
X-Stat-Signature: t1xmb8p9wiuejrp4a14ousp59qjh4db4
X-HE-Tag: 1771698704-918723
X-HE-Meta: U2FsdGVkX1/xtqWor+YcAJCZkot3GIVIMx15NAS4N5U9R6gC3OQqHcJuTw/QfKyOHdW3Vlcj60iAFHhWGcpy5fAS9kGfhZ0qejs8QdCL40JhH5O90bBISAseWYTU7trotdoM4OzQpjfXCpqSwIrXcoxJOY9n5+esxo7/a6ORPXsRa7K2bI0BjvkBhNkFUtyvXLmN/jilex5RNbhZCLvUshSFmGklLKCg4BiUYVXQeRCdUFr9wtaot8G5ALKbzNt2IWk0ikezAPv8R4ebk4Mp+jyyO7eSvmHh3tKpco0ndair5rP5JMf99EFzki2PVy4aIb1v8dCGsyLH5eZ8xNcZRmMsWfPkz17lZB1Vq6qaCHUhvL8cdPOGSrU/Wjx5ik546QIqHkfNgqpSy5pXCloxB+a4tEKD4BMWDIXWffpd9wZDW9uLedaz6GlnKddse8KZXsMcZ5f3fZWsJC6kyrt4z6dMp7JdcTsz0LR0fXQcDXXc0FIX9gcBh5yW0HrUieGOKHr4ibg124+kA1bbJwNQC9sCkbiJA2n0iHYZoxMasVVsJhitVj+dvXSG33lsDGVJVnSiBprg44tLleUiJ/k+gbSfyNqUf7jsQCUNj9Mhz+vi4jLm3AwEq6tVAIoLcKjoptO/134FEQBL/TjQeMd+jgwv0yA/Qbpnvfp9A8z1pUp0gDO1AMLRPJbUwbuzkzLZ9ObaEQhM/ZAc1dQEhu4HJggZA/d9mqTBiBlvprK8iN7TiEMnG3ljAal4t5FC1gXZqtXdfM1yBYrBWMxzuePXMjk6JDWpdX95u+rMdiOf6662ZIoFpyldCGKXLfdJvBQjCUjjFlY37VAeVorEgBhMjf+NYWS4ca/Gyl4klhNhIOlr+B/wUOFMAtS44syqg1ZRwmVb6GENYzOA2ap+XwQDY+XyxCM3/SeR7pi5nfVJgKrJkBRcsIB0FWtyHIzueNfDWaHxBy3kNPFrTLNqWbU
 ONOiPDnC
 AZiwb/HaQm36Cx5NYtRFSswqNMgu/n5nXbLC22EZY/RntLonEcRi9I+T63m1ZNJRPDaSQ6ONRNPjEeVAVxd6vnkFF+ShR1UtmMgWL1UpGiBDYTyMMhbklZ7eUDo8EM5m9Kac84DilbcsX03kFfQHGU+d3Fv7m3YHCBwTEhar3R0KfjKKJBqFsHeEQxhbelCjUPfTDUMvOFSuM4UfD7HbFQJefIH35iNVV8Yx/k5tAOABfnjv5oLCcB8Kbefp53FvtRkQfPn34oPTYy/cKZl0KWaw01XnpTc/x7IijD96qhNbo0EKILRYFgtTLmjatAZ8rt9PVJaT38FMoDUfkH2rbgjGJ9pSU34/B26bcZ3SMV5bOn9ajCN7qHW4sLoHUdvgOVM4Dpnlu8ANma1uRuc96lLw3miG5jySZIynWBBOfaYaPOywbNm5AoDvoGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 21 Feb 2026 12:44:21 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/fixes-2026-02-21

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/817c16e5655958c34035a10c8c4b93e33e529624

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


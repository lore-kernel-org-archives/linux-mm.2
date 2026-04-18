Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE7AF99C8E
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 18:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938AA6B02DD; Sat, 18 Apr 2026 14:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E99C6B02DE; Sat, 18 Apr 2026 14:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE796B02DF; Sat, 18 Apr 2026 14:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F27F6B02DD
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:41:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8D5B1604C6
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 18:41:31 +0000 (UTC)
X-FDA: 84672544782.19.5B51548
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C09774000B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 18:41:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hj9luaRt;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776537689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=zOb790tO5glBj0NgRg2VpNsz5MmqLWowNmcxA02de/4=;
	b=AqLqC3Al/iAPjt5JlIbsGo4B1wYtQVc+K1FBvDF73AHmAt1zkb+1oEWCYhkjSvaf3awm+w
	3RVTauSFkt8GVkuiYrour9LXdjU3H3EcDe7yWGfIZJKHH7FQ21j7bcRmW0tMqV4KoMX4e1
	zmqS+0oRkJoL9Uz5kbECKpIxoXqZpQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776537689; a=rsa-sha256;
	cv=none;
	b=jvZ6icBlsvM2GvdlIWroLiuBR5I/33TrGJJ11Z/pf6DDdNXSGY/6Kag/wAqQQ9s49w7lR1
	tNqxGsFl20KUQdNBnmfIRA5ONQlAerEZ+mqklBKfb/YEaTSEBQf6r/jz1EGyHSSJi9/rNc
	Ky1s16r/Fs8sWT9dmRmVQJ8pJ9b0w8M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hj9luaRt;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BA156013A;
	Sat, 18 Apr 2026 18:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90730C19424;
	Sat, 18 Apr 2026 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776537688;
	bh=aasStn9uAtIhN+YhUXRTIQIXD/8k24zeDMYnYaJgIDE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Hj9luaRtrpIyIP7HIC+CnJSrMzsx2vHRzl50sD7bTvB8rmZyOywHQ4ApVUdrRnOyg
	 WMSaEsZYYQBTMredcCcsfbjrLpM8ThiP76PHLXiaR4qpGoSMKk9tBhAQ6kql9BvJiN
	 aaMkCdzsYyJMPEboQny2nWagE7ZagXCCvpURYlcqXaICCd1w5Q058IuFaLi/uAhfqN
	 cdo5L1JjtoU80X9jylY3Q0LPy3FbhcmthRQLVEg/+ZcA3ATBJ1Mbpz5NYXbR/McsqF
	 +FHPcXTnUR/Qh4KK1rkB6iIL8FHRAJ71uOJ5avOLy7ixSroGuzmpckkc5T2Rw6CvNV
	 hVW1YpFG2hFQA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 40029380CEDD;
	Sat, 18 Apr 2026 18:40:56 +0000 (UTC)
Subject: Re: [GIT PULL] memblock updates for v7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aeNIFuabuGbdVvDW@kernel.org>
References: <aeNIFuabuGbdVvDW@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <aeNIFuabuGbdVvDW@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.1-rc1
X-PR-Tracked-Commit-Id: d5759519805c54786c00765ca1303e6d7a0676ca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9055c64567e9fc2a58d9382205bf3082f7bea141
Message-Id: <177653765485.499435.15116654756139167436.pr-tracker-bot@kernel.org>
Date: Sat, 18 Apr 2026 18:40:54 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Stat-Signature: qfkdfmz91nbhpq1gw8tmjrschqzpe7yp
X-Rspam-User: 
X-Rspamd-Queue-Id: C09774000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1776537689-177786
X-HE-Meta: U2FsdGVkX1+h3xPBTypBq8Si3NrrAsVWPga0QvywVraJT2R0QazqOSeKs4oUMdGx2Z+ykTHiuog1yf31F49x8oefd4JIzxiQ/2VV7pfKm3o/+SuiJ6G4SCq6umWNn1E6vOyaze+ETXt4LxhGvtmoPLFqVGjwKImZpAtL6cKCjgw69ICGokf7gvrshMdou2twKJBiaq++fFnlNk0c22AsPYYueESSSmI30TQJ1MlUHZsAMYsb4DQB9VNYTZ1JQk5CULC1KZtGr/jdT2KSYHSQi6sUD2hHcQ/x5iIFVPdJ+nmhR/jcdAd69rw+Hv3x+52Pcs6yggKROxXP9086N+ls/JZuEBaodSvFoyy4X1cpcK/0ONpG3wut8ChleDqD67H4/ZJwFhy51YY+qWQvVsIXr3AnUcsRQkbEgr2l88uTk7b7J68fJIQ+9eQiNoONeU+FuUAmNVxoKuQX93sTDktciG2iPtgqdMx/iDsQliQoHKlAS5bpAAYnL7lZhBVKNEe6dmGnnJFyJYOmgjqbLHIT6cU8FlPJ6byOVNbNV/BdRIeQxETrPG2NF27pYn26UZq3jVgewTNC5fPKHL2dUEtD2eC/XJ1J08IKr3Wrt0fQYrpkN9i527uG8NZzjvtU0FsueENxNuAirvyG8f+KgFikUKsk+BUUT43F66+WLXYmesJ44X/NzycJ/e+poLjglcq+cxXziSXEgoTdkyMH6cpaVFEQ+O3dMXGEc3RnrM9v5yAzKrILfhw4YNHnmiSGI4HhVI7a73Si0oXEO3wtj7g1aJN9mDawsDXHLFs6zhn/OD/GUt9ZKe7TsnD3N8UZRo7EihlEJN1Glhis4IbeX08TZrCbogbRgPnqy5TUCqm4v+bDYOsKCQJYmzBTKOzITlyhPly3FlQXRPqXfOJAxB6Se/utuHIVXOXnXguxRc0LftrBDrTvvcdqIGDDWHE2Tuq4Rj84BT14hTtA7/gaSs1
 +p3SDNHZ
 iVAebcWFejWfcJLn6lUh7/xf1U9qNywmdCp+9BmcaxI67z11/Dau6JyZ+ncvdyF1bKh0yLt9+1qVM00E+aHB9gcUvA7ohbhpizV/fdEMq51VBlz9plu2CdQ7ZNt4Clbu93IbBURCx9CTfmRsc/SljesfqtqmGWH3BjPKInjga1nnz8qRJ0G3muKYFZAIX/QArg3Dbj6QVZWhmYqYMl82RMJjjaLmVUflAKRlOaeg2okbRRHEq511OpbZn0QrKrRp+wW+EbsZ8HYgW3xjqStF7zKUBtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 18 Apr 2026 12:00:06 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.1-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9055c64567e9fc2a58d9382205bf3082f7bea141

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


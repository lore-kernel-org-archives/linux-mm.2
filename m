Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 693F3606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W31G7A/z
Received: by kanga.kvack.org (Postfix)
	id 8697D6B090D; Tue, 27 Oct 2026 18:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AA66B090F; Tue, 27 Oct 2026 18:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7309B6B0910; Tue, 27 Oct 2026 18:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE3B6B090D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:31:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7A81120B9E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:31:03 +0000 (UTC)
X-FDA: 85369852806.16.4FFB927
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E06564000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:31:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W31G7A/z";
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793140262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=j2aaTu/ejA+h6yETxrpfv6ILgHiEOxegmW4KZtHlbN8=;
	b=JR4nEoVBp/bml/joqy7XL4dLJe3fOG9d/UuU8fyrZEILEvgeHzHZVqinAbcJqYnWP4NrhM
	/cbUQkLFsJHai4v806OwgydXkA2e0Acg35VjMEs2NZNsiR0TJOcMGhl1ZawXfRKcAlYTqW
	n+NcZ4Ec4em3Hu6SNvS/FI7RvYna4hs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793140262;
	b=b6Ny+D9zoK4iDRy8cSf/rrbLgCnxFCMAF8njL122C9n1VGEZtuOm1FyxGY+zizmNEhh0+M
	TKX5sZHv3It2EpJJdY10B+cCR+hZuAbTQvkGVysBdw+U0WzQ4oTZNQ/TEb3+j1QvgdTBse
	nkB5v5xyFHIZpDxdP3MbbxqCPpxJ0TI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W31G7A/z";
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C31FB40630;
	Tue, 27 Oct 2026 22:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73C31F01825;
	Tue, 27 Oct 2026 22:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793140260;
	bh=j2aaTu/ejA+h6yETxrpfv6ILgHiEOxegmW4KZtHlbN8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=W31G7A/ze4tUfIqB3Kiq31CY7BH4DPbWKb77AiVJXJ/wMVQsqIhGOzMScObhWa8VS
	 M9AsbOs63a8DZYhmjTQbLAR+YzoFfNYM8UmbbRQ/iyX75PrP3Gj/dKsVXK+m7wrBwm
	 7ey7yFbZlO91ZZ9nYmotT33/RuXd0dEDZkfjjTh/i/jJBw0jIuv1jaNpyR6OfXz9n/
	 BZ+1VEQKDcU0Ejo1iMLjQQNn2zYdb/IJ38HEJXiTA1S/sBM6li2uT9/dfxAYEttuN/
	 VqdFqreYAyVvcrJASNK1ElYd1Rj/buvwhn19xH4eR8g2L1Sz2CLlVlJPu2vKIi5RUO
	 LMMPDDGNSrurA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9592D3AA940C;
	Tue, 27 Oct 2026 22:31:00 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261025202725.34c617497b6d9a2be352cf4f@linux-foundation.org>
References: <20261025202725.34c617497b6d9a2be352cf4f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261025202725.34c617497b6d9a2be352cf4f@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/as93Q-hDP5cW6gaj@sirena.org.uk Thanks.
X-PR-Tracked-Commit-Id: b6232ca8d194c60ee603586e42b5ea584d4b7be9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7d1f84f1b94e79cb95d974ab3ec54cb3a4d64f5b
Message-Id: <179314025939.360848.2970216075715902545.pr-tracker-bot@kernel.org>
Date: Tue, 27 Oct 2026 22:30:59 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E06564000C
X-Stat-Signature: 4xhtzcajsganyz7cif8e5a59eeu3hsqu
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793140261-270365
X-HE-Meta: U2FsdGVkX18LeVhxYeN7nlpEw/8+JbW29KUrAB8FWTHv5ntcY9KMUpZOkTGezh0FvJwvuwhYUzDFXg+UnawErZKI9y83BFZDde8W5gA85+elGGCPZbvLTWDNzJ4Weufhc+9rB11SQeeTRvIm7Q10WOznSoCrxYhQKRUPF1ZI0w34aXQ0JIeyvdON1cGdkWU7ZyH7bozsA5Kpfn7OarQnCSNPMFNd5WvOT0F9jiR7gqcUStVYcjGE49W81NO44rG7gXVzV0o6NPfy+kY/p3eXLGHm1Xcc6KTS+af3HG4obNBs2vjMLcsg5qKYgsx/meqrgM7VxGmBNSZPz2+96jKq6Y40Io8MCPciH6MZ8bxNdQnUrQZ4esYAjEsvmACHP+w/2knHYVBb1Nzn3OaojLBnQppyIShTjz/9pmL3J1TBChGp4EteU/94P7L76GLRtUtKgQjyNff4Q7MZJEOPldvRaexlCJjZnMPx5n8wx1dqjbGmX4vju5VZpBR7QaXlEypLJ8gYN3vywS8eqLpv/WuhYF7yUAIEg1iIS/2Kslwyi3Dt2rHVC4aeQFAhz7l6jlxWHzrFJdWYHcCYTDbwALQiAb98k4CId8lYgJKs11e5fzAAio/vtdulVhK7bquFao9cC9HNUjlQFm7YTeHms6fTFgd0ZEhtATY06ZCl9+cFpqdSao8MaZocfVP3ixf+ZNO1hzO3yzScMef+ke3zisa28Xs8Eqet6f9yszLRLim18dZonuQ/m+TZ5RiuPxAC8zekANbk0r3Ho4Tmn6SnmiZWLxic8dNPjGSXJN59l8c2DeRu1X1TGbuqpVV7Le2OJuW29DVUyS94J7g9v5oUMWt2E3J5byncNFNaB9ukk8yxnxboyARsx0mXc1L42S+Bq3EyueZj5aBAF6Rl8m4su/wIQKhxHMLfwdBPIN39Uszwt+U+NMmeA/o5NXO8u92oDyeULdCy3yrL8hU1VlFyo8b
 cII9R2vQ
 vQFfhvq+HwdzTBka1wgTjIkzU7LNerRoTj2XmMJPtOsC+6RuBZ5dRkKJSVz4alc/4E5qvtNVBt+5tM//tqdwjpjcTebk6uYjxY6L8W5NdtH2s8nrjkKYusb3IxKhalgeucJBFsQntE8I3CV40bg0v6etYrlOfiRbgeSwwwGz/V9ZGKx6zV1AWEe6/30f8qBwBNE2mOwnFQpVztt5QaYpziUKblmlHYbtxRe82ROsG8xQCgz1a1luXAGIeXccXMpFqiW1DQVK9WAbLPu7UGs2k2KQUZUtyrb8gcqopeBGa7uzpgmdDJX3qaoIIxnnoqwyv+eaMuPguwr8rbV8F4Zl6uZPj8EafA8WdvvGvfYBonKkXRtCjN6NBWU5DAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Sun, 25 Oct 2026 20:27:25 -0700:

> https://lore.kernel.org/as93Q-hDP5cW6gaj@sirena.org.uk Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7d1f84f1b94e79cb95d974ab3ec54cb3a4d64f5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


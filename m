Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5FED606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 03:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4ES+d2e
Received: by kanga.kvack.org (Postfix)
	id CCFB46B05B4; Sun, 25 Oct 2026 23:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA78C6B05B5; Sun, 25 Oct 2026 23:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD9C6B05B6; Sun, 25 Oct 2026 23:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99DE06B05B4
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:47:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F4511606AA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:47:29 +0000 (UTC)
X-FDA: 85363392618.10.B1A9706
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3963AC0005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:47:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4ES+d2e;
	spf=pass (imf22.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792986447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CCYuejVUIALst/S5gU64ycEPiY+AtDXMAMmJCZRifsY=;
	b=7tA7kiQirTXr9NlRcnxhf7MS/E7OuY2l/ULoyhFCqUuCkGCIG940iPrD0pFGtti9SKO7of
	s+30pXQL0pNiSRUdjKfKC3H9Fwy8jVMPhmeTnrDxkseQ6zDr+D3tPZMV+LCaXvQ/MhOE4S
	SVPReujRQKlwPVdCXDu/2wj7Tx822w0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792986447;
	b=s8QzRuATQKWKeQFLqGvTwZbdbqk5tMCd995gR9qpe+RJjwy9gQpOAMOADck5Bjb8cliwiq
	Blqh358nZjdM4DDulrP/wuQBbdiK7Gm2ui7zc3PHe8WRTxGu05Wk/ZY/hkZrKUNYhTaOv5
	HITUqPYkoG5dyLAJuieTRUClnxKR7AE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4ES+d2e;
	spf=pass (imf22.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70481407F9;
	Mon, 26 Oct 2026 03:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508B01F01825;
	Mon, 26 Oct 2026 03:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792986446;
	bh=CCYuejVUIALst/S5gU64ycEPiY+AtDXMAMmJCZRifsY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=P4ES+d2e/n32tJu0yNxQayVAkboLWrPCuuL/3JtQ23sQPlUlH3QOzGpauLRebrjJf
	 7x8kQvV1o7fuBTKoywyMX1UlSMunuAC8gu5BQb/1mTpr6jyTXZmW6gADYONx31hUVc
	 hCdfipO9MQRi5kdHQDZPdBfYq6ZcYjjfqWyD/zYNBfKhGFM6m+nY3OSj6q46ISmADA
	 yf/KtTyRQxvxd3/6dK5WMNJ2i5uljom+28qRnsIsqzbRsj3Z9AZ+D5hDCz7P8Nf4gB
	 dnV9pgDGe52Kk826S1x3tZTplJGQ4mUKa90JM+k4cLGAltugJfKNvukOjighzPcn1g
	 M7jaeBYWWc6vw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 4446039EA761;
	Mon, 26 Oct 2026 03:47:26 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261024112131.3384572-1-rppt@kernel.org>
References: <20261024112131.3384572-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261024112131.3384572-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git tags/memblock-v7.4-rc1
X-PR-Tracked-Commit-Id: 7933ad3f669670ca5f5f13de2b5cb0f92b91abf5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 394023fbe34fccec5d4db2576169d21e14c8d3d4
Message-Id: <179298644480.2442679.9705025768273724945.pr-tracker-bot@kernel.org>
Date: Mon, 26 Oct 2026 03:47:24 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3963AC0005
X-Stat-Signature: 3q3q7tbz8sobceryg9ntuhyzn4xtq6bh
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792986447-611062
X-HE-Meta: U2FsdGVkX1/vvMUiP+rFywn8AqGi+1OMJpbFu/cAFt7P7YNtbIKD7r+wJvAAmrWqCDHizRNw38ASwN4fZD4BFyXH7sjPO0dZIUFde/jdGh2INvtQfAeJc4yaijf3YAqLB71r+xf10ZiqQ1qJr4mpM1MM8SO+TfO6px8POklGxLhPHXKEXztjeCj+91gHkL9iw4RlnYQiFososhIMGUrvA/3wqSA6YbXZ/9QZcnNQVPl3HR0QOX3+03qkVaz3QEGGtV5fKSDkPOhWh+g4NOAa9CQw2A5AqJzxX0V/zf+jYEZgMFsv4Jd6P/aK03c3LWov0mUcXkzPW6OVO0+hJOuzRBaYY9UcmOk1WaCh0T1bw7V9MLz19tH+Xb3Q1u+77npysr3hyYxXeIRji9NsEr0HGf6a6G4qIlhqBpP2G5U9zBMIy4q76SxgDMBAga0oXEB8IwwWCP8+3/fuM/JYb32jakmBCJx8xX2ZZZ4SyCEo64XbgomQy8Fp7gZQKeCaEOfolFfRJyZxWaUatqrC8xoTh/pxkJ1J/8cwGaiF61UbbFCtpg5JMILK7qSsQS0zdI2fqmL17KKaqzZPXZT7Ujv2MUXgMzIG7oTriwJ7gRB7ox4M1mhGzWzyKf9ODtMb3MEy060zkNW5HlFY+bDy0hlK6UFi9LbO8srb2jM3N9tFNiSp2WjlRlZzBqRTxumrdEvNaoNL/L5CHNHfbOecVq9aeatA52PZKosbxFm+F2B/GF82qL2axLJphQ2mN5F2gL3lD05MxyXsruX7wfMnUIAwmAHXeygtIU6rCPs0U8RS8KAnN86HtkFRLcaGjRuoyLDXxE6mOBpie0qroUz+fqbXGL587zK1XNG52CXV7roqNl7FXOm4/MQNgTijzAmnOBoPpuw4K2j/Aq9QKOQy1vqqLMk66PBBKWwRpqVLI+ZpkU6RPjrAO/5P/rjbmZFOAd2dcXoPUV5awJDWUwr8726
 n3c/tuF/
 xmV7pqGu7p9u1+w9oBT3da6Jp0DcLHwbBAzo1n3Rmsg4DeHY1c2EpsE/8EBJ8GNReVLIbXslvEQkX1QfXPgW0kYpcaClCxRo5eQK4od3J5Fnb+AJoYccM/saPJeboy57badnyTzqIZhbXm3llic/j55zLuhYnzC8LMku8zjr/SToHAqWB6FeRYlUubAWWr9/LRHNG6SC0dinx4Wdp37DBfwanZgSGwCj6Ea8KZ0Ca6KkdizK57PIfwD31pQGD31EjXQLj8AnkltprQ+HZmbeXxiqyTI7tNlH2D4mkc0mNaqQgKVyfK5v1spjRW/2duYrsSit8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Sat, 24 Oct 2026 14:21:29 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git tags/memblock-v7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/394023fbe34fccec5d4db2576169d21e14c8d3d4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


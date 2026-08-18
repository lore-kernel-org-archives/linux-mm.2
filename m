Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15044C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 19:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8A06B018E; Tue, 18 Aug 2026 15:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88F76B018F; Tue, 18 Aug 2026 15:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77636B0190; Tue, 18 Aug 2026 15:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89E0C6B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:15:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24FB1A2D2F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:15:31 +0000 (UTC)
X-FDA: 85115344062.30.ED86EA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 51CCC18000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:15:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5hqtfBp;
	spf=pass (imf06.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787080529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=nY5VBegzMQyaQMJtL0wT6QHBF7wvnKQUbhWRpeTUJhE=;
	b=XlIuFESXy2XGvDF4pbB6r+NF5ffe6jwO/R3lPkyqAxZ7FqkXs6LASycAum/Q/Cvh4pal4O
	5EZqkOhQgVJleKDUBvlySLdzqRGQFFhMovZxFlAj6OrfuIOexzlJPj6tQxnO2auTOIFmov
	w8I5uzNZrAKfLXAfXvW4mseEl2usdyg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5hqtfBp;
	spf=pass (imf06.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787080529;
	b=gnRt8mBFu3mNUhO9RnpAeHcv3v486chEEs58guSYmAwlE4RqePSVkyPNUvTrpKLEWj8gE5
	KolgttPtdQDBX2NTm47qGGpxLSnMDNUqefawJTd2WJMr47/ceepxrekhXav0iy9jStSoBz
	So57BtW6GqdBlaZOs9g6IxR4ZRQhzTY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 343A1409BC;
	Tue, 18 Aug 2026 19:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183611F0155A;
	Tue, 18 Aug 2026 19:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787080528;
	bh=nY5VBegzMQyaQMJtL0wT6QHBF7wvnKQUbhWRpeTUJhE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=b5hqtfBpcVhsEOKlch0SH2F7LVwZLgFcRDFOC8vFQ5A8ZmL2kFaRENDEqvOZKFqEp
	 RrUVORz/+wwL5S5q3EuHz0oljnIvdUbYYF7ESA3R7oIZDE2a5DMJ089UviXGb35m6Y
	 LFloF1idwdFtLgauXa812Hmyh3uYa1rMG8BJT5Ph/0FvoaRVu5Dml4CMNQ/QlDHH0I
	 aU7h65HEcQFH+AyvTlDsvzK1iSnsHmEiaz00OZZY7K7aH54sCd3NXOpeWLj1o6qlVq
	 RWwSY0FFggNoj/eUvWrQf1PPOIjuP7MomrTIGFjlQ+zEJwrDqDhBPQRhXQpxO3yEdC
	 UbvT8BMESr11w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A1D3927051;
	Tue, 18 Aug 2026 19:14:40 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: updates for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260813110636.2482716-1-rppt@kernel.org>
References: <20260813110636.2482716-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260813110636.2482716-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.3-rc1
X-PR-Tracked-Commit-Id: b3c1ec1a9ad84ec2f14d343d28c6032feaec5b79
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 38fda1d9d2f5df55bd1c095aec07de3699091316
Message-Id: <178708047951.2235733.4565536526691859768.pr-tracker-bot@kernel.org>
Date: Tue, 18 Aug 2026 19:14:39 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 51CCC18000B
X-Stat-Signature: 9gr9d1mpjp86gpzz66m5cu6j9pid16im
X-Rspam-User: 
X-HE-Tag: 1787080529-902105
X-HE-Meta: U2FsdGVkX18OP1OmffCRgzlNnQpr+JJjoikmcOzH9OB6oM9ZyJojJjvg8j/AlgwANn5ikQjLg2maXG9klZ2R6QRHcQtpXxzxZBMPZuowRa/Tl4BNXW/xzhkGtKdmjZPGgvauOGJNhFmO2H43k5fFBqLgw6haFUQ3XFu8GjHQU/ja1FYDeyTRHDxZkWln3lbN46HwUb7/vjZFMRORc6Spp1DTeO9h1y+yKpLOHquEgY1t1exGr1YkkMZZwHFyICu5mKn+7gBU6K7QE4gXrta9W4IiaYnkHe6W2XwfiA/vNQVQdDGxrx5Fj9ibq6UR+gchPHG5ZOXZUM34uXPZiZjD7Dqi2+NvFyO2DxuJ6K1w+U29O42g+6I97NLwK2Hd9j4M9pQdZLc+QIBzxEsFVw4RS4oKzvQDHceIgmgEUiLIg6u5FB0GbwgGG2YbhQDBmQBTiSa+nF6KSgI4Xwybbuxu1GTLdtc2H41trUiUYsPYKVFml2I04fsOAR2cGyTPk8eiSv5nF5w51Ws0Hf8LpLBfh66QRJYtzc3sbDWrrpb5lXjFnU3Ksm12nnHigxLDZ62ijrbUlxT2rM5xSx4Fx0eoFFWX92tjQLgc3+GkE8aZ1jvF8mqGxcWa2J+/pwBg1vXCLNW7Ua05tHiFtRjehKumFnM+8cMbjlS1dhmfVWjFZkSZfSyGtYo9Sj1bbkt1FyiBP/xt0hC/xGEnl+UefvgXHi/YZ1hhupWyxdReGvEcwzMlBDvE49lBT2nIG5dS0TmZIIpqMVGz75dyxt6150R3MHU/1W7/qgMimmLoVq4wpYyoKp4joNjiIP9G1j1yu24VqD+jEwaOAJcHi8fdOt3YIIOvmEJSefzOB62pOLaObZsDu8f0I5RrGHMKcCV/MkA+uxelwhuEoSkGCC39BWmKiB2QF1GKGzRc7ewtS2QvadX0sjCITP89hY8/Av86uhgebp4R6IAFNI3AElrGLbY
 9BxEhfVD
 XsNfuAs/FpXLjmX9jp1OTnVdemDzMsactyLkZa1/V+kfiRMc4Zfe5kcwMjLjq/8HCdgxs7wJDx9UGYviqBawzeAmPcXpz4pGnhbi55Vx9babyLz6w5g5WMOO+YHLXO1nhv5NflVADwPuy9abGyt/XffYpc8Z+ZUoJ7Ma45WyAb8r+YzqBKYf7WdKeAIYP1hd60zaAgGjbqh5uxHbbSVeWu+c2tPnb6E/s2p/h+SNrBB8WfggPMubs2b9qhAFp0YG6L7lBtTQjjZEAIEF1+Oa2ZXExghTVy5uxolnP+gr/WtWVgF8XwVtNMcMeAF5Vj7mwGUHM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 13 Aug 2026 14:06:17 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v7.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/38fda1d9d2f5df55bd1c095aec07de3699091316

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D6A107BCD3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 17:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692E46B0088; Fri, 13 Mar 2026 13:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F4E6B0089; Fri, 13 Mar 2026 13:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BCF6B008A; Fri, 13 Mar 2026 13:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4096B6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:33:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E550D16024B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:33:44 +0000 (UTC)
X-FDA: 84541737168.14.012C86E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0293418000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:33:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pi2MzXFF;
	spf=pass (imf16.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773423223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=3n6CN9ARH9FxJqFGFm98BMLktFWdOFr146GD7NEFu0U=;
	b=6r+JvgLmkgllPf+dkovFrCkW+dPwZf3SBR1F1StG2UBcPxT6Ozua4EE8oYFpURdTRlXVjY
	y8k92YBaHEzrEFtra5vBdcAVSTVnggAPgImaeBZQwBgsc10FjvDbULZYry0kRd1MfK5/nI
	pSn2HrLhtE68nO6SNQs2cFKvVRbr9rc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773423223; a=rsa-sha256;
	cv=none;
	b=YmOz3j6LVcx9WcraqBXinE/GgBxRZYHCLJUazLbTv/RVz6g/Q42nHes/tOZHKUVcMOxRjl
	TNQh+2VtCIXJKhekGYdKCftIm46eyHM+RDwtN6Jpi1C+M+xpW9tyTkktN1FgLqrE2YGZu+
	wm6u9rcoKOOHmOibIVFWqmMPPyB7yrw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pi2MzXFF;
	spf=pass (imf16.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4E3D40476;
	Fri, 13 Mar 2026 17:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817D5C19421;
	Fri, 13 Mar 2026 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773423221;
	bh=7ShSj02bqj1TI3ZHP2vWU/nhihC9uap650Pw5Eb15IE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pi2MzXFFqvAQmeWnUeDiKYPSzz8xpC3DJOVVYsP4vApg4QiQi9Pt3KHk2Avrzj17i
	 YkL1xR/qO2eCdjk3e+J256j4bjb4rdHFvNgbxfSuDDYzy7ugb7hDnN+IP/ZY+82xsC
	 EqkUVvGwHBsePisTLTLEh8pxYj09CUnE0r8lWF+P5K0eo4fwPzoOxlkyeduVnHunVV
	 AdhaaOChoj44vMaZUrCb9WH91PpcHUECylqK/zf23gW5xuM3vOIYQ6PgvoxeYytUrA
	 xiUKFaTEmkQXapYFSUB24NREY0y33aBp9fyL/rNUHPKp5pcRSxqZp6LxhVQqte2QTt
	 6o8A6KNgPGpXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D3E43808200;
	Fri, 13 Mar 2026 17:33:37 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 7.0-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <77adefa6-8aa8-44ad-bb01-9f1fe33c8f7d@kernel.org>
References: <77adefa6-8aa8-44ad-bb01-9f1fe33c8f7d@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <77adefa6-8aa8-44ad-bb01-9f1fe33c8f7d@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc3
X-PR-Tracked-Commit-Id: 464b1c115852fe025635ae2065e00caced184d92
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8174dafb2d9a85c895d3bfb9cc3e7c236107c93f
Message-Id: <177342321596.1438840.2158170484186398971.pr-tracker-bot@kernel.org>
Date: Fri, 13 Mar 2026 17:33:35 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0293418000B
X-Stat-Signature: 5onf74ftz5fnqepa85yhxuquyq6x95xg
X-HE-Tag: 1773423222-28252
X-HE-Meta: U2FsdGVkX1+ZWaDhoDfKrxnpjIk6f+G22msBhAeLYC1Gbhw789SVJnH1DoVOquDrbmm79VHuEK/4oGkimqXxejw1oYXBOuymbKN3qwwElL2F+BiBp/RbOxuoQFkwBwqhpwrFjtfjgEvCJWbiOoUsKvAwpcexAkTF+6Xix7rizgwSjB/lTv4oYVvswJdbYq3jkPyMo7TeyRfCEBrlOg5icxWRjI7t9gxgmEWk2Z2UnAhLeFWgDZrmbUcrONi+IplJMH82HqvMZ0I2ztbu5EA7flVcpGXbW3tmimHFlwqafBu5r6tciD3Tqow5IT80oUNKOVEAc2CQOpf2feZ5gcUVhH6GKtNEg3bjKG2g/nUM9MZfjq4hVJrorRMH39ouf7RJDr9dPnnA/Q9SjhtMPnCUDhJv548XlHsR+g3dDUAN440BTuAOA77xQ1Bm7HXEiM43EXC7L4c2OVd95x6YCdpWPsfiVqweBxxd4vERQo7njYzxdcDKmHjsW94ENMHekBR5B9BTSEV1QeJ0wGEXb6Kuca2qUYONyyN01bg1kpNmLZ3ABvigjXnseyJnz9ygY4+4v2AYOO+82ZIdCQgvfNChzeyz4EfBrV6d2Ae9VkWWu5r7XRiybyzcSXt0i1o3mOU95/FLpSb8I6gC5s/WUKEEryzhQ8WkaRx3v7bt7ZiYnWJGQnPdW4z2tOfnPXt4zTRSnivL96rYT5/adsmyFWPXpMeh/sfTr1nXLRXYYYFyWsmnwG+7BTBMr+mdtp7Eek7QB74uKzikqdpC4yGD9VVawomUwKLRwZUsrGfIw095nRmzaJPIZDTY1jABGOuhx5AzV7fRHeGQ6HqQQnWvP5JRCUX4AXFa52g2OXVf2mYFS/rgcB06WqbeZlccbEywzVC/xns/DIQWhh3ybZ+4aUR4MfMdLCDhYHifAwE2Nm2pYBcsZnQDX/xHXl8h3yxaP5pV5I37bwDkquar+Km6GIj
 sHuMQyXU
 7GFTzHOJd7RQqRqpZqz5sPfPCfsc2F18JOa3aXqdvh5yqI26oT0MY6MPpwJg94Y4Zt6D0P+dMtfqyEdKKQijhLYYMhWzJTVreuKRjFx/PPFD9sTCjGc3n6biCf+kV/FviPW2oVuE2bioajDIbXZ04loX4d0BlcjgV3ziT/+KkU7jRnN1X6AtK4rtJ68oWCaK/yd0kP69ZfKCU5zsAgsEIaGCrvRBmHfM4znIPZfzyzLLrLWEWu41cQTQVEfxRTYXE8hZVzMZdLp0QFNN/8C4UtyFfPIb6Ey/QIWn8/zPuo6+CaZXmANt2ONTVB6xiyoFziAwNzQf68YT3dOkCs/Kj8vy5vWPkSY51iHBxTmF93cNoeTcUE1VMxGIwPgfDHVBi+UdFX3cDLDp2MMSaz1Lz0KJYdgy1y9vBGI5+LfbJoyOSlHeJ5M9m+0DQxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 13 Mar 2026 10:20:23 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8174dafb2d9a85c895d3bfb9cc3e7c236107c93f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


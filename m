Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D1BECD6F7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 23:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3F66B0005; Wed, 11 Feb 2026 18:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571626B0089; Wed, 11 Feb 2026 18:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7816B008A; Wed, 11 Feb 2026 18:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9946B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:44:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA8F7D6974
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:44:31 +0000 (UTC)
X-FDA: 84433807542.14.CCB8E62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 036C6C0007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:44:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PzRysyHa;
	spf=pass (imf22.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770853470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=MVT66SdgAeLsY7O1ZMTiNAlHu9FreeBafk/1l+dafeE=;
	b=15ZHbopZzPjz6XooV0zv1cf6uxMrIc1WgtKkiBk6j2VCyi0uZJXR7NoqQ30n7noPNYAE2A
	BpRC3y2PPiOlXJkHwhGstsbMtvIL1HnWmPTCGeIAx0WK0+9EmZDg2ugbA7Tgz8RgoN1UFH
	YnV4pfea2DqwuFq0GGV7fQkTAWmdgvo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PzRysyHa;
	spf=pass (imf22.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770853470; a=rsa-sha256;
	cv=none;
	b=QIZ1VwVxTCHp7P9oUXIIlE5yJVXpSGjXVn0u/HcTn/lBbgMwIZ9wno8ABJYqqxQqOTIv7h
	apNwnnmCevxbYRvHoSmcNnaEhclvy00x+3b5SzrIZj6tHRoGIDz8b9bYWKG1m5Sf3a9kNT
	JslwG73jyokjyY0iik36zDY0qR53ukI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA82A43CD9;
	Wed, 11 Feb 2026 23:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940DFC4CEF7;
	Wed, 11 Feb 2026 23:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770853468;
	bh=7XVYufdB16hLDho08GeyvovGM9CxPREwQvZ47I0sRSY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PzRysyHa0CN2dBxUUBbkRG/6BVYm5RfDLdwzp1kBjHg7y6Is9snbCB/D+xhbqq3UQ
	 2VNwNBjwxayPNahIKFS5tppXpPvBVqPEHlODqpvYDO7fXQkV2QG03r73EcgkMiFTgB
	 mV9Sccl8Acyoy96m1tzstdhVOQjL4jbix7TesAla+kXQk6TGgzRVDkWUCpgFSN4NlY
	 4Rty4X372wT42B3ZKIIxnl3Vhgv58iCHHStLpsiS4n/yAXwGun24HjwnQs4KXAQYUB
	 BZnK1kcqjk2bXD5VHrr5sEt57CXUzBau+oVlpNFcsiHgN0Vx5IRgM9OhgPuPCKsujO
	 ecsWQreblWHMA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8530239EF966;
	Wed, 11 Feb 2026 23:44:24 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 7.0
From: pr-tracker-bot@kernel.org
In-Reply-To: <34ac32fe-e082-485b-bead-4e6b9ae6a153@suse.cz>
References: <34ac32fe-e082-485b-bead-4e6b9ae6a153@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <34ac32fe-e082-485b-bead-4e6b9ae6a153@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0
X-PR-Tracked-Commit-Id: 815c8e35511d0b9a214e9f644983fe477af9d5cb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 148f95f75c513936d466bcc7e6bf73298da2212b
Message-Id: <177085346308.796778.14229901480613806393.pr-tracker-bot@kernel.org>
Date: Wed, 11 Feb 2026 23:44:23 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 036C6C0007
X-Stat-Signature: qjt1k3umzmguxzadntos71i98ibq6dbc
X-Rspam-User: 
X-HE-Tag: 1770853469-232987
X-HE-Meta: U2FsdGVkX19mCqWMcNtGQZl3TD0t/sR2G/Nd9uRbsuEi2925aRpQPGAKxSbaUcWc3CBX4f8+KL6cyxWTpLb6Rn3Mv1yfUur6TBjE2xR5oJHsYQ34k475yTUIGP8dbU23Bt5qzHJUtIncQFE/0vRdCRGOEQyoXVKETeLMwWsy5rImoLPpOKQZU7T9Z2saS9mpdg2HFwgxDks8A1VUHjStSJEkhQBvutobWs53nfwiYYcQC1+ocZkbTtJk2VLVYeITbEeojOdutek7w/+V4Sp71Z/cNp6MEt7RT80PzicL+9HCTVW2qstSCu3a7tVTGNi8gcoDmexALQJnQUoh4qt3mJYcGy1cNs+6Xs6HXl1mX7OhEiMCmSFEWBKuu8wpznKG3NiU8Ko5tXw4t1jHz+91qGYrVtNLd35qoh0qBTEVfEnhfvU4fyJt9NdioAjE+FO1F+1T9rzoBFVU6yDagC9W+6wpUGYIRNzhw+MnMZnr1wnNbvquIiM3AiMvN0pQNxUqO4fJZ5vpXQQYb1LTHD51SLbMddKq1XWbC7lfYMQUse9A8RHaijD9U6Vo5SvC3ShZWQyrJf/Gg1IwtKpg5QY0iQDIsfNZ1ub3LGjRo6bv1VQNPojpafxaAt0QcsM/KOVXprk9aLSMryiPZiqjlakrIca6WJ382GJPOzZ7APiaJ0fl7Nc08xsKCrTyvGH9LxkxGIrLUhzP+jN/2+fBZtOxpJ7RrwBdiAaSbAVcOIEueWIZXb+iYNR8waEDVKKkPY3YR/5NdpGKsU/nhn4FmQVYTyO6MQNjKQJJ2IfP56PcbceYcQlAdPIWf7goM1PJdFD038ra1xygRIVo5MZCAu/IxP8FLAZE9ciPuWZfqQWCbcGLP8BQHJoSOO9GeMUudFWZja1zUNWK3HMvDvuinhWJEI5By9mQNHvuytWnU2OE5MkIxn2U+nYuTQ5Q1ojHd8D+7Dd3B01qobCvHC1faE+
 dZRbpVMG
 tDjhQPz1dVPu1KTR8clONGmD5G5Iu8aN/Pvv21ejuIW7W1ON48UYA3ufbsVIh+Dy2tlHwu8W1P2unaKA2YglMkW4gEvC28aKxvT4mj9ra+Khs+BBxhMVQvRrCiFFVe3Mfy+OIN6WSuH7jsfq0YJiiYp7E3QTb4fMrsaOsCRvfBZwdPMVA9KpojmSTtiZr3IHpvz1x0J7ySqnG+PtDAHOmjpC36jwr5XgobFhTqDLhwE44f039qbNdWL6uYJQ4ftPJHlgFww+Hs/TNsK3GNpiFfhRDE2APvER3TBfITTdDtZFGlTsQ/iOpmrHvF8uj39+M/YR3rnYw825hf7xsC4O8Nac44qC2LOst6bToeT2z2wTSI66wsG2nWg6LFKuwfj1rSviuBAPT6aysL+HfUgJBTiNV30qjvAzQ9g2ZswOKLFx6FcNG9FI8BxUHvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Tue, 10 Feb 2026 09:43:31 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/148f95f75c513936d466bcc7e6bf73298da2212b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


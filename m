Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10608FF5136
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 19:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD956B0088; Tue,  7 Apr 2026 15:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7DF86B0089; Tue,  7 Apr 2026 15:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B945B6B008A; Tue,  7 Apr 2026 15:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A65FD6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:27:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B95314027B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 19:27:15 +0000 (UTC)
X-FDA: 84632743230.28.EB0F70F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4049540002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 19:27:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ji7895+Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775590033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=YRyq8P25tDg/ozd6WhuWkMNpNQd/DqGyxMZx0qqNOGE=;
	b=RuGvcRYJV1RvhxghNISYARqqUq8Ci4QRprpBQ24Dk9a0T6LMGPILuTKeeiuirobSFGP7/c
	a2H5c9O14Dln4Jgz4+yLVnpbvfSJ4s3F1qji1fCdsFZ57uIHKjtO6J196MKqvs4iM6sYci
	gMskw/RTawtUbAsR4K8quXcO5ldk8v0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775590033; a=rsa-sha256;
	cv=none;
	b=y85/vBUHq80upXAD76lrU4ZQKYksBLa5lNkFQzwDlTK2+3m5kArh3iCOo8UAVlwxa1ImV8
	otW5JIMIlMMevQWGTGPSEjPOUUonwQwfWL1YpIVmy8CZ0P5ZRLZRYCCdqGeEENSw8FYSGE
	eJUbBwDL+bx52OuEGghHe/z+tq7EXsk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ji7895+Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 869F9600AC;
	Tue,  7 Apr 2026 19:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0A7C116C6;
	Tue,  7 Apr 2026 19:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775590032;
	bh=kWHAI7aObyXj6dvQDOMtmoAXbU5XnD34DfBNqB63Fuk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ji7895+QUsE+yknJwq04P/tYQ09vHzFAyMlfKY6P9ohknz3L2WPq12Qcw+TbbbZ+v
	 BaR3hN/4v52VEtnIWLmVOJ2Md90rNWymPkwA5qxemKcSuxw8ehTbL0oiZEw6qbTr5W
	 NPeHiWNiQcFvFKgtf4FnMQRMr0gMisW8ptTqxyeeKO3GIfF6NJWhHJ44+Hgr7L+u6Q
	 tcf2FI9ZseCSAuVxjAaa3VuHNizTbKZ2ZJkBVOVjV6yEJNvJ1SLiTLQtx5rCxUHhVl
	 KBrxS5ze/4MBMwD1Q4dCIsXParBa7IL+LuIziIeKsmrBuwXdriwo7aAOMvlldsPBIa
	 0y8UCRLEpvZhQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02E083809A33;
	Tue,  7 Apr 2026 19:26:51 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 7.0-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260406204005.a7bd01cfb84ce72be88c9c4f@linux-foundation.org>
References: <20260406204005.a7bd01cfb84ce72be88c9c4f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260406204005.a7bd01cfb84ce72be88c9c4f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-06-15-27
X-PR-Tracked-Commit-Id: 7bc5da4842bed3252d26e742213741a4d0ac1b14
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 66d64899eae85dc9b96c5433933787cdcd9b21e4
Message-Id: <177559000961.4123438.10274665543837779264.pr-tracker-bot@kernel.org>
Date: Tue, 07 Apr 2026 19:26:49 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
X-Rspamd-Queue-Id: 4049540002
X-Stat-Signature: e761y9ujr5b6cbw7fg8iars7zo5ssd15
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775590033-790746
X-HE-Meta: U2FsdGVkX18EqqJjw3KTEu+KalE9hW73Y9cUULPveDNXTR2939dJk4HFYS5haAHx7bTBGFKgk04lAlddYkX8JRXA8rLZewzJ1jhQ/I005pSjWpZiPKLukkgvjpvDfuYVFcuAz3O7ZKNAP5lwn1IKfT0ek3NHRVidnwGB4vDptFUBsXjPcEreUsrsNxhOmGGD9rm7Rb0N0DUYJxWQRygKiN746PLCoQRnoCJStKtGbunor6kmZ6He0zdoPYW2/QeglFLYSszmQgIZO8fvgYbIrlxGZZLc1cyXqDoaBM2ALjURwfkpRLlYP8cBFw883EbvYkuDzHxXgxXIuuHuhKqyh4EQCrfreIPv35y4W/38hNStg247GjlWgS5K/ACfaNmG2BFt+M9synewYBkPrFWp1ChMPHDNo/0XWMvJzX8/+zSUtUFhCTRsfvBdyqHH2emFd3O7EGQAjY+AOuOl6CnuZho5Z3jjuYdELJ8vxes5b0qftxlfbqlqFqkLnv4aIMqkC9vdivRQeeTrSJQ7HWhLNlX08OVtEuEolW28fpzaYYRxkxTy5UwGu1SgOn5Jy60TlFyDrIIOA1DpOLZEdtG5BnvJwEYwSjNIyScOmLLxomCtWGkpMfYJoKLc/0+TKsXpxFzUjIwlErsT+p1B1qeuflTq/YuoxNK9ATcipYOZbuy6arWV8pvKOzmlY12/1syqA3sDEl5EB+jmGMmPJgh3b+V1Hep1GFWzp8s6KmnXh7cKSozmbi9XFlkjYRDIMHVTPF+77z0QAH3JSG/kdvplCevhlAjGKmJl5IxhwohEfhCzqf1KvHWG8rWnK7DLmVlYXDqG37UXBnXC4A+e6Jpl6nBr3dSQe8ieRNnlgaPalJUzlGEYKVDttxqURTe4QUS5rj1BKQGx8BBoNcezW7/YnSH36A1blz42vjy2HjoTFSx8pNMS1gKXE6iXbcKYlu7HcCNV5KVvE7sH0a7xZT3
 2FOWYr4l
 tN/DcRZqGrem5Gem9u6fhPWXicCJ1iVpCOR1viklBwQam+m2LvgP6IdlB4HGA5Rriqb1Hkiu8j5UhvHWI3AxunJHj6E/ujBvhcxuY8dfv4v8yhov+OK3JjAcnNgOC7OqasuJmjd8MSuZyrs8s8T3Jr1nwn4ZXVCU1HmqjiXw8Rq0WMGtdH2qbXGdJEmC8POV9ebH6QXWGRSVY4aU1v637PKLzwQX3AVqV2MRtny9c8g1pSWsQDzeNZn1LkuPXx4+yxEtOXDm28i0rO0+QE6l9XNR0PEosBA9LUNQb4C+G8reVI1J7p8y3LS2EAxkEqiHVlKo/pIC7wAswSYda2IDcdv9FzNAG9Jryt6BtDAcdWp6sz7F5GcZxE3KKZsqVq/IlAnXi6V2NI00Bcns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 6 Apr 2026 20:40:05 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-06-15-27

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/66d64899eae85dc9b96c5433933787cdcd9b21e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C036CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 18:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2786B0088; Tue,  2 Jun 2026 14:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73106B008A; Tue,  2 Jun 2026 14:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988CA6B008C; Tue,  2 Jun 2026 14:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 839D96B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:09:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24FBE162E31
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:09:11 +0000 (UTC)
X-FDA: 84835759302.24.1F98982
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5B7491C0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:09:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nmy8Ion6;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780423749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=f82i8cmK1u0wtDqDHUpqQz8R7QLi4aPEQxEJdlSUoAw=;
	b=HtDCWO6L7MG6P28cWUz8i/1B/P1QURTJvMji0OxpusWOcCiy6mf6mtI1f+8bADl40N1a0w
	c5zpTXv8ewtaQ8ltkzRMyDYjlMXeVMxVxSW9ThF226XL/O6TLhPm6FsoFjczB2+0nmqBRH
	BMrjxEVWAlyHnps6vm/dlZm+2hBs77s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nmy8Ion6;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780423749;
	b=vdn4rLZI0MzhZj+0qbAo4ADnxzIcbXKHgZ7qPlEWaCEg31NYQCefxEqIpVz7AbwUkJQ4cU
	2kCuHhfsHhvHAMwd0zDD0tyUHPlflmcu4Xbj1gbTsJMsXNmC4aaIK/51MHKw0Lg2M42jeK
	Cjl1kVXwmLZqCEVlPUDcj91Z7F0qi2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1C3B60120;
	Tue,  2 Jun 2026 18:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762891F0089C;
	Tue,  2 Jun 2026 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780423748;
	bh=f82i8cmK1u0wtDqDHUpqQz8R7QLi4aPEQxEJdlSUoAw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Nmy8Ion6SeolbtPN/jhpseRHXPahnVBJjmHbtL21QGF/vJuNUMpcZhKsdBK3ybDEy
	 IuinTEdyuhvcLy4q50LCzDH8QW7Mumup416kN/c6dY1HJwojOWmbctNg+5oyNlO3t9
	 Qf0j63/B2xdzvja66DIiZUqdA3Stnoyn10iRVGGCbfoLeEpMKqbdUugFze9h4dJRJA
	 yAW4zAHsvi4SWUaeATHAuRVvP3+frpfHAxp2aK3kSRV60jyrquZCP/wWrhQgYgONd3
	 GNAlxtDXHPfPcrLiVsit9fYA1LnBzS9X4FdPWbK+oYnmeikc1pQOW83/enXGZ9uKYH
	 xXmEsqTX8VG1A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93B823811A6C;
	Tue,  2 Jun 2026 18:09:11 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260601210527.ad1549849df4d9d58b12cffe@linux-foundation.org>
References: <20260601210527.ad1549849df4d9d58b12cffe@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260601210527.ad1549849df4d9d58b12cffe@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-01-20-58
X-PR-Tracked-Commit-Id: 9d7bea186ba5a002456471edf36cc9b69f809397
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4a694a77c3d60bc974c6ef7fb98cdb872b5330ea
Message-Id: <178042375002.983785.8559277558601300819.pr-tracker-bot@kernel.org>
Date: Tue, 02 Jun 2026 18:09:10 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B7491C0002
X-Stat-Signature: knex77opc5ker9efs9qmhru37bqkbpe5
X-Rspam-User: 
X-HE-Tag: 1780423749-726018
X-HE-Meta: U2FsdGVkX1/LeU6KYR2JuV1ZDTntSZDE7gPxY0iUukrB1+rgSm1ce8VXxQiDZefqF5iImS1LhCNIqYnOuUyQq6jnzbiim4lvWgjTmlEI9MJ0sA5Pc/80vA6yoEhNSQZMFCtQDu0X9GOvpHF+sTPRlBhgDlzFNqmi1jf2Zk7n07bRFafjTG3OzHLb0QWbNz3X3fL7Vla3Ry81jXwpKE9adNZefNV0GAG3i2JGo1QzmiiZR5eWGU0vlAiBwG5qqMniLMiZPeeE9kXKa7iVGhmZ9IeLJ5NMrawQhnAJKHwXLznI+Hpb1DupcecnddvHAdpUChzOwsl6cVQc8JXdQxds0FJ3Kpc6jMLBcfEj30Imtkdy2eiFI4WA/4ihhXai/f2UONkoxg8Gc1DvTsDNww5l1zvdbwcQAvyYrfSi6CJchLTc1QDL3UX3qwyi+BtTg1focosPC1m07YK56qWU5riT3kwIRl434GM9d29uATzNi+wJkkLgZub4uJ8Nse+7rqfTjEybvpJxFLmYT8bMyfHgAktHZmYcE17CmJdXY/owKxAJ7iNrB30/tcn5jb9Yfn5nGv60UUq7hABCR+n1Zrge99ea6/f+vxhAyq6LnjAVDKiYdS04sQMxy4fj78iHtBizPygeQhSmSzIJ0A++y5VYIzGXjd9Ht694dcqzgCgbyd4p+a7MfPL/f4spm9k0iqkU7X/EFLUAT4zQ7+zs4J5Ybt7yMOXd20VH9BhUelxGOfmBXqIrHuShnjEApHqrKsF1uxh+TDLi8y6EeaPpSUKUy6v6s9WZ+XreEL0a945Z50MIz4f6YZMucDk0gan5xqd21fS1s7ZwMcV6GhVNlakjHCHJvXNePzG/SjD4Tvfg4ZG1R/JIVYJdLO3kWVljH9GYVbb2MHrDb4tmRl2B5gR6+jpJy997T2B2WPJzj0QNTOqQVY4AODA+qHPmEbpDrCPldHslppCPKoD76E3llmD
 GMIszaNM
 Rv268/oy/poHzDuiWXrUao1nQ5jtRcul0hUZgHQBJheMZk10+iTxR4dHgPaNy29/83HWHzbL3jtL59mxTbByp8JM0Kx5orv+38VhROa4AXrTYdFChNNjcjOC7bMPnSJUvhy6QwTY2ceSHocs5MyFou1QvPcA1OwWdjUPKzUel810pQpwGkO2UqndZEqyXhhUvrwKD7civ9bb4L+tMEDnrJjgHh7Xd+wUjX9Z51Pq++Ksjo0sicj0dV5Fq+LiADpaveolaFjLEWVdXX7f9N+qM1KzprqxRgovUYmiOd6ldjEifOcg8AtiUWC2zBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 1 Jun 2026 21:05:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-01-20-58

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4a694a77c3d60bc974c6ef7fb98cdb872b5330ea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


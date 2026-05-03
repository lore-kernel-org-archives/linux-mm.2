Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D360FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C34D6B0005; Sun,  3 May 2026 13:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79ABF6B008A; Sun,  3 May 2026 13:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7786B0092; Sun,  3 May 2026 13:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7036B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:00:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03B96140689
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:00:23 +0000 (UTC)
X-FDA: 84726721968.13.4981443
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07BCCA0011
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:00:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aXPlZl6B;
	spf=pass (imf25.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777827622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=W7bkjxfjD5mvunwtijixamQ6dvZWhv2KAl7woQ75EOg=;
	b=dZLhb1ZIYTcCNHJx9GG2vrXOPdS3WmN9hf9CpmOOB0yHcBG1EnDzdXgWsCQZP1/N/0kZlf
	94iWkzTmvh64MdYPoLoMyWIykP+KtldHWXY34dQmm8WeMuR9fzQbjGL+E7mhZfFFksTaZg
	MG27v9KMJ3TqBKsp5PvJBTsYofRPCjs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aXPlZl6B;
	spf=pass (imf25.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777827622; a=rsa-sha256;
	cv=none;
	b=L4rpUbT8u/28xtXrTOpABLuhuqXLKPmJxkxDz/PDOe3Udetm7xX18OE6vvaSBcDW1jTG1U
	jRA+4sG56msC72TFm5tDeSQlCeyc8LH7GXmCGoXiLfdSdANW5d5lQP160UJqQKNqTaiPYr
	PguP1WA/v/0FmD0hJtRMadu7T8iXhPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E90B643793;
	Sun,  3 May 2026 17:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56B8C2BCB4;
	Sun,  3 May 2026 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777827620;
	bh=VRJWbbS8CFtd90S28KpTit+S81UV4+YzCcVwuBUGJJM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=aXPlZl6B2zKsdCRFsertjOBi+gCv+UxfpjHrWhpMFHV6fLiXUsdqiKHqxqfYjV66O
	 v5DuYYjIyI+50LqU3v0/S5QFG9+5VChnGlvRRPovVW2WpluuKlPxgIYbF3Gi4jb94X
	 r2EMzvBj1CD/zuvXgH8h1qZ8SjYZIa/RMnlb2pANlyPPxwFo2PB99pzXPXEU+gKjvC
	 pKwkW5d7+k9tkzLn7IUI5MBJD29FKH0/RNllHqo9n6So9hgOY1NDRDqHYdJ5eLeleG
	 lDkU/68b9Fv9njZX5Pv+/xoUlwOOgMAZzyaMEX458+Nc8+sdtP+5HXVb8B83ym9F/J
	 22NbR3O96Tnpg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA16E392FFCA;
	Sun,  3 May 2026 16:59:33 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <38238703-4460-4a57-8d00-5e390fd2d4b5@kernel.org>
References: <38238703-4460-4a57-8d00-5e390fd2d4b5@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <38238703-4460-4a57-8d00-5e390fd2d4b5@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-rc1
X-PR-Tracked-Commit-Id: 5b31044e649e3e54c2caef135c09b371c2fbcd08
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 811129272de4f91da34f869ae1a1dd1fe608f64f
Message-Id: <177782757226.4174759.3383189939595984601.pr-tracker-bot@kernel.org>
Date: Sun, 03 May 2026 16:59:32 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Stat-Signature: mchyy8ue85ih8ow78nyy7ypat9yb483q
X-Rspamd-Queue-Id: 07BCCA0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777827621-710073
X-HE-Meta: U2FsdGVkX1829a1ZOuZxy1IZVuegNbrijLy/mQPIDMgU9sVx1o/FZj5qNTh0fXnGp2yebZOUZC6O/bpFwrIDSrc33d5LekA4q8zpi4TcAw0yQJJTxM4N24d6hXJVo7RIJjn0OYGuvgQUQDWj2OXxwrMwMCsunNVcQLXB2lWwlqxNE61vlQ/J9+i2qsTCwThmoyloLeoQLYnKJ9CVXDVlHWte9BvVPCN2o7CLkOjA1IuF3Yfh9glPf81tFztlkddqeC+K22qP4O2fV9wQFsTjfuLsmxwayPJBSj4W+ofEGCuPqPjz6AFFkXK/M2xmYW8XmBJBojNjs309v/27vUeFWl5hObZEbAjXHH3JYr+nPVSK653kHmwDU2NZeMYJuiHUH5Kppi8/QlrLWy8yPyaw7sMX/VSM3gqcNLYto0rFOV9rx0iNvuXKOAuKpLV/zshtneC4XqBrqfugzP4w9266jUF/ahawJNTCY9diaelYSaMfQttPR5cnLI3NBW7A3Lj+pIukKMPI4tHAdtDNRuL0mWiyGs/XxvMRmtL0r4TgmghULNC8U5Br1i/do6q8tcuqqR6V/dftVj0cPbhks9ksAtAp9E9wiEC8rsyPNgry5PyD6K+OuDU9mKv6KsZm5i8uLQMwQep8dpEN0BGHHzwYgtWu7xFtkto7qyubJlg1CSn0uIJhfJxg5eqgfCHBQIPcCdvD5jPjHIZVLMNEJxdHcOBLtoaC20J+68ADQS7mHk//Cm0rTuMIaXTyKD73keGnD7ccjTsSnO+r3KzTNp3JlU5f4as1heb6lofKk5CM2X3J7m6RmtpSo5QKHm//s2AkPRg+ONRdIx7O8t5F8+UjPAtytgtPlvoKnASo4SgzlBUQi7dNOgcEAJFJ3O9vqDaB37U7M5ZRqxQjOWPhi8w2Bjce5dG02vG9OoL46zyXoQbZs99WWKMNNEs8/8EIjnCiwkt/BG390y1pumkHAj0
 0ojVDJf3
 ZM2I5pNeX1iASr656dsvRYG3rIiUO+zEKbsYmH/9e9K6Xuc0E+hqeWIj3dk7ADOkhUDtFTb3cNs4FES8zwTG+/TFr8rcyhInz3Xf07WbxDZWKQu84vZht92PY2dEcc89Gf469GxNVcrCotwX5h+zEiIqw+0ZU2relzKSIZ4nDcuyPYIdD7wp0kgQJP2MbCZIsQxPwPYmVmtHgm9vha6lr/VTNfQAFodyIEDrfegSjfBi5KiZPmMln5QRmF5cPDkilAlKutUEYmsa6yp1Ct39c74Odn0slB4zK2myK1XQTeXGMyxkq43B2RoKOQm37XXCQ8M+s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 3 May 2026 10:35:47 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/811129272de4f91da34f869ae1a1dd1fe608f64f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCAFCD2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 17:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07946B0005; Sun,  7 Dec 2025 12:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB81C6B0007; Sun,  7 Dec 2025 12:00:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE766B0008; Sun,  7 Dec 2025 12:00:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEA846B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:00:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2496FC08BB
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 17:00:12 +0000 (UTC)
X-FDA: 84193287864.21.E0D1652
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C2BB40008
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 17:00:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gsS/JYXg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765126810; a=rsa-sha256;
	cv=none;
	b=wD/PR2rBEwa4ZqR3R9fyK6OV1q+4AlG6ANbr3TxyHFyoOUmu24Lh5C817sdTr4T5G6f3X5
	wURq+E4z/WVSuhYfYFhEd10lvqMiDDH3oH9g0TXYHyIw/iFY/6O3qGmKKg5zJSjbR1fFki
	VhrGw7mDSXkYxHvPLbsXF0KN5mOUcT4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gsS/JYXg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765126810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=cM9N/Y2YM0ivGTdYNyu1L6tU+A0W65PAaPfID9G3NQc=;
	b=aAXeKdttti2PQVzv/All7EJr9wWQY6ZwSBz52IL73mlKdptHIJIdRcxxBniWWVM7+q8AT7
	+pwhr4gzUVi4tEJL2AOfKFDveBXtRY/hDuMQdw2iJB4U3qtKmzahMdkwA4YSDc+GPYePlD
	21V+Mm6ClqDth9333jlC7UkSMPlzj/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15D724364F;
	Sun,  7 Dec 2025 17:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5077C4CEFB;
	Sun,  7 Dec 2025 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765126809;
	bh=usNTRqSOSo0SeSzGwtOZLN8K7ivAUNupwHginTdOoFo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gsS/JYXgNgHMnVBgExRgpcqRyKSZ0pagJhayPcyT8TLwvda6uFJ7b49UQR+eQ9SlW
	 tB/bX5NIey2YGRvcCZ/0VaqH2zY46Pe9rEMVOogMNj6ilmjEOmMWPsnAVD6EaSuRfa
	 v+4GDWqIofnJnax2aGnEopvgggWKt6lN3dkhxmWZWRwZozk40k/Tm6VVgf98PkxUXx
	 PY5XcU4MGfIgPkIp1ktx1WdSrjHuwzbJ9za3vXy76nQLfcbpp6SAB/GpukQb0VJW6L
	 buOpWLEJ2CEHQsW83/73gabKJOraagF/gtaXm3WQkdS17Z+MYvvnG2JaIp4SuT8nSF
	 F0L5iruqllIvg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 795E63808200;
	Sun,  7 Dec 2025 16:57:06 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: introduce check_pages boot parameter
From: pr-tracker-bot@kernel.org
In-Reply-To: <aTWotB5ev3q9VdXj@kernel.org>
References: <aTWotB5ev3q9VdXj@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aTWotB5ev3q9VdXj@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-6.19-rc1
X-PR-Tracked-Commit-Id: 83c8f7b5e194eaf3fb268c513e23e23e892de8ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 67a454e6b1c604555c04501c77b7fedc5d98a779
Message-Id: <176512662494.2481827.7376767833314098209.pr-tracker-bot@kernel.org>
Date: Sun, 07 Dec 2025 16:57:04 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3C2BB40008
X-Stat-Signature: yffrxwk93zww6sqkt5mzfn7br1hjjm76
X-Rspam-User: 
X-HE-Tag: 1765126810-928656
X-HE-Meta: U2FsdGVkX1/15Kx1dNKo7zxX2sOCP8tzufuYr08BokjCxF+uOmB2UC9q0V1Hf7JeXO/oQ6FZPMoStmjbijzup8E2eKwOlJGcpX6p/po8NTAELyvzMlcOfCFlKBpKGF1IQfTLPohUo4Q9D3/qgG/cfb2vcufz4gEUN6Z6s5TZhB7CQDGZIXfUCUNfeQe3sxcuR8FJPOQWqrsu9VG4oRS6aVZSu6yTy5BDsbeTLdPPhwIq1jKo+Licww3MtAxQbX4tmJnO/epEy7KX/XnwMXqy4m3ekqHoNFTwFvilUZgY8urOA8/BWViQUOs7/6oVbTOXKwKBItsaeGCERt1hf9DIqcgAarCOiRazTdZdbct1hSCb+iwBeMwDOwephAdSyZZ5WxC0JR2NAmXBmSAs5Y62lBkXsYODjSc3uhkLpli/xLi1tElGQIFQ7uCfLbsXX5G+qf0B0ieral9tpWMivnYqdSCRy6KFYxLSSxranRxEXlUCV4aa0pDhogt+ct6XPVS3yFkH7MMftOU/c6AUSxsTwLi3wQvUKtL1u8ETYxjeLDdy9uy/iFkMc5cygxBpRkOiwn0H0kbu48qY9rEjxv+ajGaUlxWSAvvokpy2MMyJtYzc3XvGUhUzGzwUd1jMtvg+n12Tam8FVfwSic2bsFCWSJGFSsuI9X1XJbULUIh0G2fMRslgO8mHxdjPOp1kBJ5qHLsCes+3h9uqGaOzSj35WUPSGIs28+azdmEt20CuiSuQ9rnk/0P9+iJeyYWAt6C9QR2oQ/6ZfRQH3XbkT+OfuLVYss9EPUSLL/PggUgREK6rH3dzcZ2X6Qqn2mzZhH2Du1zpuc40MpsBkgofcT98r5Jd00ymUvpvXzHuIIX97i2IJkDjdNm0w9sDJZU/hskgk0Hu+GqR/VeZs6ykVuAOSWKLYFZLF6fA7wuZLtLaFhGAaz8dkLm779jRWPFE3jI7QNusscpFXUI20qK8vb5
 q/sdch+z
 sFWb9ckOrZ6fqqJD2f5oqmTTns82FW+a/qRRaR2cAHe5W5WEFahwpe8uw9PMxQH04xxBJvNTJjdRg5gWn79BbVn3hz+wJB11jeknRL/Sn3Sv+rBVD1FLemvsWoMDUMuU3iOzy91Gu1OMB3/hK651cg7NH46QWAYLF6851JBcJXrWj8/nVV1XcuIDnuOkrXoZH6JBAJTjkHBSpdL/SRtLoGNZy/OTXGKR5qsGGuzNKxEr27Ho8JtJuVF4HuLzVQ9kOxPhDOVnbgozIToExUkrkJS7cOZlWq/rdtSNCRsfOePzIv21KmBraINlPkycWxJawr9zCPhYch4dPZBtibkTNB0sQOPvD9BdYh6n5eGbRT6cU0/T4OzzPt3vOlXuNyP38DFlYHJrluxeoXvc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 7 Dec 2025 18:17:56 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-6.19-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/67a454e6b1c604555c04501c77b7fedc5d98a779

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


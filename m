Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFF2CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740566B00C0; Wed, 13 May 2026 11:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715116B00C1; Wed, 13 May 2026 11:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653EB6B00C2; Wed, 13 May 2026 11:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 542156B00C0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:29:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D712D16020C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:29:51 +0000 (UTC)
X-FDA: 84762781782.17.1D25762
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD46E40003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:29:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+Vu+Jp+;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=iLlOdkfp7QSNnUgF2BNs1mDqIRB05WnP42VaWXM4hMo=;
	b=ppv25CurPYplJWcrRZG99dJYjoOfLIWzwsFrcx6C2emfQu7yOXp0hdK59ZPkLCse3GlA/z
	veWodWOVrMwP5PEfbRj4IGksR/HRNhqJ9n8bcJTt3vcEpCcXxtqONbJCym/3smGWwv6xNS
	K0Cwcv5TGKlQu1W5dF44yWFUvNJesxY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+Vu+Jp+;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686190; a=rsa-sha256;
	cv=none;
	b=l1syfWEC1Bjd3z1RpmEc9Wez60DaT75X/eWXwE9+PVkmZpXBIvcOH1xWfosMtoJqisEGrP
	rWvm/5VJM00F+oQ6Ahdh2d8nrSsCofZ2VVJej5pXjKoxG/tvGeLyTsx3XVy2r3J5VYviJS
	mJ7UqZ/s6MK5F/0u2WZtEMi6ZvADQSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EA546012A;
	Wed, 13 May 2026 15:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC52C2BCB3;
	Wed, 13 May 2026 15:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778686189;
	bh=uI4vmPRYaOkKsG1dsiYOsQI9DoKlxqJpqxVwBQAaxqc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=L+Vu+Jp+2FX8Qfuuzc7PzEh9i337pkhDzNUaHJTS40QaG1axFrmsId5eKwUx4NKSJ
	 hPO8m2k1uEC7VDwKB6wBsDIsV+A9jikvCKp1NHWKN6QXHoPjER8JFmRAAvuNzl3PaH
	 laDqsxGbMdeKqZDwFHuWcJ8YwCLT7GPKIvlNSPN6dLpWpDhYlnTTwA8UvRurYtjkJn
	 391iVlc8xvbsJBH3B+nOhXHUelKcm990h5bjxAehvfMRRYj0ycDVGDoKei4lY8IHWU
	 wEObrI7FRy4lXxl3QpfWEDYT/8KvQHQ7MmL1bav8ONi2na/NNHpbWA5SArxOtqrk05
	 H2xDZQg0oHurQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA16839301B5;
	Wed, 13 May 2026 15:28:55 +0000 (UTC)
Subject: Re: [GIT PULL] liveupdate updates for v7.1-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <agRQ2pV1vsO-MoTB@kernel.org>
References: <agRQ2pV1vsO-MoTB@kernel.org>
X-PR-Tracked-List-Id: <kexec.lists.infradead.org>
X-PR-Tracked-Message-Id: <agRQ2pV1vsO-MoTB@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/fixes-2026-05-13
X-PR-Tracked-Commit-Id: 7b0b68b2b95606e65594958686833e53423f58f2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1f63dd8ca0dc05a8272bb8155f643c691d29bb11
Message-Id: <177868613426.3700920.13576586222009152264.pr-tracker-bot@kernel.org>
Date: Wed, 13 May 2026 15:28:54 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>, Evangelos Petrongonas <epetron@amazon.de>, Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD46E40003
X-Stat-Signature: 9kxco19j76tfb91kik78citd4uahkbz8
X-HE-Tag: 1778686189-832884
X-HE-Meta: U2FsdGVkX1/5DJhEK4rKLAysHGEUMoKIy5ep10apwgw2i6q6jjrhb5nd4o0ErzcfA8iAkzgptOwvKtbQCs5MvMdHusBrRn1iQq29Nj+oBN3PSQUcmBrqlzn3h8zn+a2mOgMlGSPf79gK5f93FF2ecMmMvc5OmBmHUCLT6uUrszCQo5udwK6pTdfiJYTvIqg9UX/IIkk6OqcO6os/Ued8IWcLmuOAXD8s3PGSpPZGHliRpf1dxzY1zxATa9Xvj5uppaVppDBO3x9mlOh3Wi43GDPAj81HbeBbKofWre6IBPmPXpquf5kJRsBKYeZ3VtxXbgVPzaxFCpt2x+b2CslFAAlvfDJlViLSKm1hoGcjXAGC/L1UJfbMfHHTbFzB8ls6kIF0girzD4uQQRyAZEnWIMfQUyvMyFw/WOEJn07D/LpDFWOitBbBcusoUgFhVHLIdIJjLSrlhbkAv/Arb4+u4XPGLv7SID1RamDjl7OuobO4hhC/3bxuNB+uLxl/9SVrtEGKfv4DiQNyJzqJfLQr292MF+QLM93NjVGjnDGK98h/Wn075ZuOHGvCxs2c4r5Uf0vQdsF7gP9mPcxQTWQ+ymtkBoqezNXABi5WyWOHGfzH7cFTnR46XtuA0ImnaprDSP4JndCNFoyr5Gz9ym7aPYMZNkL7C/3TARsJXS5WRG4RgQRjUUL1V3ZiUMaAhie4Mqx4pu/FM6G0eTut94liLcYhZneWmJksCPI7odmjKhc8JrU3DCsp8aemn9xJuSoDI14Ff3zeK5Rts/S5s9Zu96sZmMYTpjSx6+U+qPFtPl426jPiMxc8X7oZ+FcdIGP5vPelciFru9RxSqjiMDQdJdhPDQsbvdeCjbQmmIlK2aOSsUaPQzQ3Txojv7GwWTBtfAzDWK4GmtsZZ+0JteZlWcAuQgFSkVnhOt5MMaEA0jM/dJ3tnHbr3mmb9XdgTU6C0POkgpfOd6sLyQupSld
 MemlUM3T
 XpvVgZMxvUkRSM865d9/pnKH3xrsV9AjicUTYlnkEs92ofsGgriTNE/cSFXQ2oKavU57wIrwfIUBj4V2mYiNDQxcORvj0LnsKz+hi3V9bH3+EjBzbx3H6ryNcxK33euBC7YKVkrGg5fsCONgC1L6Rdq1mmHBz7OKhP4g72WWGFSwa9HFSGMazBPhepOkve02NYpfba+lmUR6J0haeEg9bWVcnKbvKEGzAuMTiPB0YbL+wSk6Uwf567lz8Du4eyJZJLBgXUKqA2Z5asWBqN+PpRBQS1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 13 May 2026 13:22:18 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/fixes-2026-05-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1f63dd8ca0dc05a8272bb8155f643c691d29bb11

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


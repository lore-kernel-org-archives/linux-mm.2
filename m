Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620EBD262AB
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 23:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFEA6B0088; Tue, 20 Jan 2026 18:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D776B008A; Tue, 20 Jan 2026 18:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8196B008C; Tue, 20 Jan 2026 18:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A76E06B0088
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:23:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 394B05A782
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:23:34 +0000 (UTC)
X-FDA: 84353921148.08.094E012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70E2DC0007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:23:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hnjvvg4x;
	spf=pass (imf22.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768951412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=3aeD+qmramYlmekcWrWX6MtCrDw1MoYapSfDsVtxEcs=;
	b=xeBU6pp0Ct57mK1IeNOKdw3IA/ApH6ryXJAU+UVezuZwWUCUChdxw3NWiie7luJzP8E0Av
	Gpuma2vrSZH9E0koR1D2PCJt6uXC+6dXMpcTahPVzLmPzuY8mWhMVGaqZWQgH/Y8bJH5Hr
	ESeTMu20AHq23w6b0gLDpa+yMkQjdJ0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hnjvvg4x;
	spf=pass (imf22.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768951412; a=rsa-sha256;
	cv=none;
	b=q5Cp/lGa5iHIofoQevaKDRIl7cJurpd+4nEUXpLro4Hif8KR+Jl1p6o1f7B1yQrHGUQntJ
	swL/HzI2LjjoohchD5iJAe32C8cvvYe5lE/Eztl7PHwdyKu+uSzQApRegQKA87uyXJ+99x
	5eer75iRZXPs89zS+1RtdCGl9whgG8g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E645600CB;
	Tue, 20 Jan 2026 23:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560ECC16AAE;
	Tue, 20 Jan 2026 23:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768951411;
	bh=K82kHZD1KaEicFMbRUFOLT/B+Jfrfiem190d9DbwiGE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hnjvvg4xpaH/4NscL42Oovch9uGb2f9afrwoXT03+uPmCWGyIkp98McVV+hZXM4Xg
	 3nlatJK7s8op1n2hN6H4zfxaNdpgyN4Yyyztt1AhWxBWMOnb1Xr/FLdXKyUzZO1YLz
	 xzuaDU7h0LiM/a1kXSekVdRF8QCCN5G7UtnMSPWwWn8iglim4tD31EDdHhHcBP0DZP
	 7sN1f9VyXw8a8kLpYDjT7MkUUnveVN7/ot6s99si00Ad2DH8ag6/wf+wSfc2ZAq8kl
	 NJNi0o2LaCdaf2cmW6BgUv/UAhgNx36VgjuNoD0NBJg0fo/9kj5Uddjzk7qdp/GzgR
	 QCD5A34WNTv/Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 11E6B380820D;
	Tue, 20 Jan 2026 23:23:30 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.19-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260120131126.fcd6df1111d067948a8244c4@linux-foundation.org>
References: <20260120131126.fcd6df1111d067948a8244c4@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260120131126.fcd6df1111d067948a8244c4@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-20-13-09
X-PR-Tracked-Commit-Id: 16aca2c98a6fdf071e5a1a765a295995d7c7e346
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c25f2fb1f469deaed2df8db524d91f3321a0f816
Message-Id: <176895140853.649372.8779652225988361344.pr-tracker-bot@kernel.org>
Date: Tue, 20 Jan 2026 23:23:28 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: ykwcp7ofbphe5zb87s4i6ffg5d8d3q9c
X-Rspam-User: 
X-Rspamd-Queue-Id: 70E2DC0007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768951412-712024
X-HE-Meta: U2FsdGVkX1+MtzwG+8E1jGaNs0kpnl2VxS3Z8cX6KL5HijhjVsxtwjQSHjNcfUsLKPzIjpO5viBa2lwpVrP/g7PIREcqSdfxXJIyCZxCUrQVkKYqPMD1PFy4MfTkkgBsnRd3o8B3A9o00b3LKoI8fYgTBQgKqKvsZQ00DCVsF6FWN3CWOvp1fp2X+bvEHI/dcHG1PC7UkO+hC73aL+P2OIRaL9o7t/ORJMZWn4TFgtW+U15vPNxA6Sui/qd8ULK3TtsTxuNCnmD8W8J3ZeRm46DZ4dB8FXuvfAZIqfja76fByg9w/wWFCMSPnE9DtdZSMdRNrI+0qJYEtpoHcHJ+EzyCRJJ43lFeVvMlomjcsNGsx1RnFH2MoF2RfkVSRD+bzGcQzAFOFLzMTyq3fYcpFIIrm3UTYLswkXWGjwUIfFgD/T1r0bWawlhmS2EpTmU8L8IZplrMRhIxEAArZnF7mCNbg0hPOZ+71wIwag+DOaxoInVX4+eym64CMs5LFosL8CUrDMIgxrPFFhUC4EHbVWY5n1fGZ3sm4QAOSTXPR0FMgWeD/iajyCqhG5eCEgPbryTJhybCRfDGvYPmKqZcg/9BEw5f/J283Qid8XobfD43gpmO6A8jpD2EC4815BREBFX0JLFtdg2aoQTr22oWSqrT6e6/k9GJsDynlagVUeJX8loviGOYzI4vQoj4/kb0iP9bK2j+WTre7+jpZGFSiEMDA9q6v4rIPRj3nIzrdrqd0DVVfU5YPXRRrqvqY4I3NSuuvsuFM1o9otA5K9rxpeNRoXeqaxyIt2tmVe9idjH6kIZ0kBgCiEcYLtOFeK4Y8KU3hOVexrhY+F4HKbrJTxnjCiywcQG6RAXbMixIRjdXRC65OJsAts9sragKis8zRuySvKkVtOil5XDfJ8fsEXytrVk63sF/s5zNm/koYJ1blXX+0Ke21ufTUdesx3rsDLsxJuV72Gb/8DjKu1q
 XPRTcUEa
 M1dijCtuQ7B0XqaDnJvjKthN/5NyaUmsx5y22RDvuhFgh5VYUQ3+JsUp8id22XngEHOpWMw7YLsz3zuOASyNMFFvfWwKBvPzPskwfV6n+hX/ZlXBFTaKBIrE6vVK3npEtgmjmj/zgItL81uCoN+vme/8RuuuLdIct4q96C5snWwZuZC0iiLQe1k2tb4wkueSv9LbZfepThPT2BVYh41c+mTDCKQlUNzMQ6zclY2J//PpTTW+i2Ofb8wNfq+3AQWNuiT1eR3s5AzFAunCfLQDFEb9UpsomzKoUnyGNcxvEn+m1eaVeMvIZq/dDamf8cu1FR8NwTvR5loiBVfMTRdB1n3LlNDp15CbCWNVncN5AAJ07Kb+0SwXtv7j+gkjXEuPVsMzMvBtLHvcmEBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Tue, 20 Jan 2026 13:11:26 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-20-13-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c25f2fb1f469deaed2df8db524d91f3321a0f816

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


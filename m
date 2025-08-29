Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6009FCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68CB56B0012; Fri, 29 Aug 2025 12:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63BA06B002B; Fri, 29 Aug 2025 12:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551BA6B002C; Fri, 29 Aug 2025 12:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E47C6B0012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:39:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1FACBB91F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:32 +0000 (UTC)
X-FDA: 83830355784.20.6210210
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1AE89A0010
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NX6JbhMw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756485571; a=rsa-sha256;
	cv=none;
	b=ZcusrE9mDfLK/+VKL3SLCMXgnXMdW08B9GMIpgexQ393Uu0GFBwerb/6Q2k+T+WB/3Y2mL
	VQebHsVpDucQvLcSCpji/xeFvjy/2sq2NBV3gE05+PoHEUePCw2ReXy7Qc4rKNyO894MAI
	HKfWt/58Jpgqg9CIqWqZBjqK7oXcoIA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NX6JbhMw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756485571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=an+aSNaq1g1QpVuIbM60PnRXpXO3E10k+X/2FVv+kZI=;
	b=gxl6JBYPmXz6lTp8JlFfNhUn5VNjiJQeHJ1ufniqT7nwk2TN6F0/C/P6QkGr76fNGthSEd
	wkiZJkPyH3E/NxrVkNSIQeTG/UsTV4LScdpH/yK/bSil+70/c+2n73/tZ0yRRQRDinATIB
	P8UcRTilcn0nWxQOb5DJwcvulZXbfxI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82612601BD;
	Fri, 29 Aug 2025 16:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E40C4CEF0;
	Fri, 29 Aug 2025 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756485570;
	bh=XIGv7VamxU9MjgUfmS+z3CQ1G2wAf/0j3V5pZ7uaqis=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=NX6JbhMwEiNrUXl7YKp8WGBKb+1Ijdb0f+ew4cpZVFSbtRw/cOTvnI66zePP2TWS4
	 8UtDPggxXItKMZfnF5KxjQXtcchiZApMZo4ifeggfV1S1Vczyv2ZEqPB0reic6LstO
	 ofS6YRvBCPVNJKP9eRGZG3wO8lUcCkhnldHVm3rY07L/wd3LuSLzxCyYRri9kvME9s
	 XHvYnpC2kIAOtQVlH9yuXn5daLj6y0lah7cjenNOY7kh+gv2d6nJQhGCdm+aYyewmG
	 1hyh5XmrLbgV9O5QQnBApQVdEwatzDAEDGmjvpHXNcaurWvsvzQcjsA7hDNFWZ/aYn
	 0GXSUVQTFoiJQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 354C2383BF75;
	Fri, 29 Aug 2025 16:39:38 +0000 (UTC)
Subject: Re: [GIT PULL] memblock fixes for v6.17-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <aK_qmw51CJz_Tz36@kernel.org>
References: <aK_qmw51CJz_Tz36@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aK_qmw51CJz_Tz36@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/fixes-2025-08-28
X-PR-Tracked-Commit-Id: b3dcc9d1d806fb1e175f85978713eef868531da4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5b9f3b013b33e73c6f8f2bbdc6b3fd87745b40af
Message-Id: <175648557686.2275621.12830998468782656220.pr-tracker-bot@kernel.org>
Date: Fri, 29 Aug 2025 16:39:36 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AE89A0010
X-Stat-Signature: ppeomik59y3y3wam94efhy1mdmjbmhap
X-HE-Tag: 1756485570-316844
X-HE-Meta: U2FsdGVkX18Biw8AMFT493ofEakrgIcqtoqaNc61dSGUgiIBpuM13fMKj0m5fwCHeO8cEu6EzbqHeL4XU6HAOw3tqrWg1AZnEclNkOB4njGmCLSl3EkAMZ3J6e2bdzj2A83ud57fxEr/dyOJSVgNILJT+qnHEDy3njIkAhaEBkLBn6T0t48QrfOMgqGIACW6b8BppZt6wOIwx7AGBdXHwLmdf6nxU84kZyhrYD32fGMa0NlNcZXsjyCW+9QwBFFzJT6asSvZ8MbYhnKmZNJlFuA93uvj+flUpFTW8rfoLsj8a28Fg5x+Uk+V1hjN79qo2c/izC3MIzfRHNEfyrmY7vKXgijWkDCA3a6jyBcbecaIWb29WxIKHAMp5SSEAIiOV+/C5v8JqDXElEJozIGkkFk6k4DyXVAXd+qiiLZSmw0uSbf2GfFqslMyaIe+EjkiDzt5Yuhm2DjpgFLS6XMTvEnm6I0C0jeBem8TarHgQMUXKrimWiwzZokMiGLdjDCeilnGGO2GOQBmad/uqztTo9yPrjPh3jpfX80QJ7V8YAUWkUEWi0MtSS4DYgaexI1/H9jJQW3c7vhMTJZ7SWf+b7eh23tt6W6nfG7ti+0NKgMkDQokUdUv9EJZNL9ffsO0gdDqNU9r65RCsNwa0rDHYorptKrp3OqSu+qItC1R7b9fOW7YBZT7Uzt9l2DKBuz3Mp8GhjCmDoJFrIC3jXagYWB2BdK9bX1q2iOD5xWh6iAv5esX7kKp9pFEP0JgD0n94T4WyelALUHZM+U9seHeLwiLEh1Jsog8Vkl7AC8WTRykGaFhJsuoS4hS836AHuVssCt12/ck9j+Tu3dB/Y5ZOyKMjWUtMfk07tDCyzMulz9vBCMteMcv1O7+N0989YhBcv9XO7JVGBtw/HN2WvYzItWMS6jgmiA/9gu1AvY5UxkH9IHZfgNFGKLn+zuqWnE0Gi2pSALFQoRnqdhhq+G
 Ha7FQ5zx
 uBYuvHV6FjBg+C1esxHiPPA8RS83PYQSIsM+xUC/70fTccvUCd0LjdxrvIOSIHkXhDTxWkb0ZcEl1ep+NKxH+ec9p4zanAUZSAPxUbvVCEgYAaAuobtVBtQYu99SsD78jNkQ5NWDqo7q9q0IgwYc4/ZhKu2HwOgKdh1434iWsZsD4TbNMFMAGzqq3qWAW8vSETWLIQSKj34RhsfoA28g+1kfEczOQM82IXPicFF+L36SKPauB8gt7yXnD83LyLnFazIHRTe+/lKhbL/g2ZU4MIgMAaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 28 Aug 2025 08:35:23 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/fixes-2025-08-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5b9f3b013b33e73c6f8f2bbdc6b3fd87745b40af

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


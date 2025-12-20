Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC10E67483
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 19:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50286B0088; Sat, 20 Dec 2025 14:47:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C287A6B0089; Sat, 20 Dec 2025 14:47:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56486B008A; Sat, 20 Dec 2025 14:47:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3B256B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 14:47:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 612721406A9
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 19:47:59 +0000 (UTC)
X-FDA: 84240885078.18.A406176
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B3F911A000C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 19:47:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TFSDcrsH;
	spf=pass (imf19.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766260077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7+QOF70/uPo61ztdH232ds4RlqMxzPxDUfYM2psJSKA=;
	b=RuFCfs2mxuVtwrVc3rO0jYzqKQ4QvB8B8cDMsDABobNfJHqBXg209ae0ubK4lh37l8ZlMt
	0bGRuXBelts1WuSI6GfHrzr0t74agvav2T8D4iK7H78NHGTAQ0Yi3E0vUdddGbyy0Uvm+2
	tDa22CM5M9hFhwxp+We5peBD7FuO1+I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TFSDcrsH;
	spf=pass (imf19.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766260077; a=rsa-sha256;
	cv=none;
	b=HLKj3nEdTdoVPtB7jJoSRFL81VdgJ3ZUAq7WpgMHCuE9FmvXgXdDNQSQ15GeAU/hPA03Ho
	bYVmjvfKNZu/yWrDHSxK+kXeshZ8L1IcovTEj+BxkUiBHloihrdQ05UGKuYDWpWljynImb
	ylSW9bCQf7tOK2OIucKA3jTD0ZIyMLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB35960053;
	Sat, 20 Dec 2025 19:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72425C4CEF5;
	Sat, 20 Dec 2025 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766260076;
	bh=fdmcFxev7flFM/iBSzGFjyVwvB00WB3K1snlJrn7GsQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TFSDcrsHqORebqKtahEnwbRVFFybzFjGwWisYo199uFqjbJ4QkxIBu2JNiSuO+1Lk
	 6fJfVioTBHozdg/ao7OhMucm0N0lSXhMkNIKAexrrivlJwYsoPH8FUoZSVcZHBypsi
	 EAvMkOhS3fa904A8PygdGvkcooleeWJ6sUcotOFmezVKpIqwDTTmx2IFl62fuGlSs+
	 I/qfUl+rcMibLOKzk6EXLvX8wZRAfdCTD1lG/nXq/lj35u1Ts2+WDJ1n+k+EUbg59a
	 vSOUykGIeeTp8sJ8ZpfHJEp3nxaVeik9eNaguyrgy0E8KFShoC703jBRNZpIm0dsbg
	 2CvKricwZYfUg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B656F3809A05;
	Sat, 20 Dec 2025 19:44:45 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.19-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <271c4413-2d6a-4dd9-9b31-714cfef3f28f@suse.cz>
References: <271c4413-2d6a-4dd9-9b31-714cfef3f28f@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <271c4413-2d6a-4dd9-9b31-714cfef3f28f@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc2
X-PR-Tracked-Commit-Id: 53ca00a19d345197a37a1bf552e8d1e7b091666c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 44f9a00a44a010f3d4611e642d9e5d6adb524170
Message-Id: <176625988418.123080.1577408789438919999.pr-tracker-bot@kernel.org>
Date: Sat, 20 Dec 2025 19:44:44 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Stat-Signature: dtftao54eh4msr9317u9rsct79r3rjjn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B3F911A000C
X-HE-Tag: 1766260077-66180
X-HE-Meta: U2FsdGVkX1/c0PLAuuNh5jLoaVrnohrn2+6StvbX1n6twteynh/OhjKyMH+zpm8vuHF2FQGeD8ddfDbwFWwyLjebvUcbjMDhCU98nC4JGTjBhD4D7n+AL5EETRk/XfZPUhanNqN+ultlWhAV+jI1DRgO5Cj9rJNJscUarI7qi9vVlwF2ytUSS4ZvsTPwa2zFhzfQf2qXWYJ5gf0eRzc1p1XWS19F3bNoSAD1YKnoNusImkmM0wXx0u/BQKnY4B1XPgBU5y3I4zqFi8Y7llM6vMM7GDIS1PQRS6urXBYn7K3DFygZMNC4b1MkuGJme5h/0H9BjRjYYjjtbNPBBzTJKr44QGk3GXaivIwzB1BxIJh2K2g/SroNdyetx4Hg6RKLnVNEpiTy2+ighqpYN4ZDgPpf58H3bS2QU+eji4pyOKxyXU4MFu7eajk9RcOSiQ9RaZnZZj2FtlJXiMrI9OXFzIYBdq4Qgk9IVLQH4S8lhAHnT3o2FfjFCbgO75hCUnWkFfRfrQyyw7ipy6hgvdnPbXY5K+51lYMkCqJ3wYO8NyooIoOLQroLm1Rrhsj2RorLQk5EGePxLX9j+WiPDnCgmUYB103xToPBSrmgAMO9DMav40vlQFlvTI56hJfKc+E4OxyoLwUgK0S6b0Oooeh6MP3JQmhWAQiq0rAQc5QlLR4p9zbEjuF2huJ9Pw5IuuTIXiRG8eQVitg/B3X3om1HSe/uA029DAxfm6MT8T1GpbrCcb+riNn1pJKBlfHdgZeSPaf1Fi4h5SsIc5CA5iZoF/TBwcdTsJWl6Xy3kRBO6mzFxWXicvd9Fj+irIIwZ3mxClOX7++R3S84L8VO7KRjyMDzH44uSWRtV2mjRKf8+VWtEIPkevoR1vMuzOCoI3bvjO/ptpejKZtdMgmSouXJ50EYW4eEz55HStOAXS3/bcONZ5E6bm5WngGcXF0soYxpzznQJzsfXYDjg6I7Sj9
 R0jilzqo
 0MT+PZCHKVnBo8PTXz6KLPxp9y0cRcQBTTfU2eH6gYXMrm4exLd5bRuDIG40zDdaZpx+YtIjj6ND/h+PyGawf5/+5J1jEAPYpzyeFiHjQlXRzmp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 19 Dec 2025 17:22:18 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/44f9a00a44a010f3d4611e642d9e5d6adb524170

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html


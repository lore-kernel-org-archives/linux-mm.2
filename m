Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477F9C531F2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 04:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629556B0088; Thu, 19 Feb 2026 23:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D68B6B0089; Thu, 19 Feb 2026 23:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B81F6B008A; Thu, 19 Feb 2026 23:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 394C16B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:10:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98E69160840
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:10:32 +0000 (UTC)
X-FDA: 84463508304.01.9A20882
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E9BB120004
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:10:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MzlOe0Jt;
	spf=pass (imf03.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771560631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0OVKgZAmQrpZSCSne3fNxbWN7hMvnzN291IRopqQ5A=;
	b=ytO5Gcy+cM83PkjErWCAb7/yn50V0Ab5Uhl2Y0NW3R2olLwnTL/KB7O9h25hasVv9JjHhz
	g29AokVT7av5WDQ+YpqCrqmw7X5DBgpK13B2gxCCr13G9CLtVH2lWTsv/YpdiF50zyiES2
	gueLCgC0kBTq16TIWGOe9BoYu+LONtE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MzlOe0Jt;
	spf=pass (imf03.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771560631; a=rsa-sha256;
	cv=none;
	b=rEmRZDDEYQBntmH+IZD0196+19ncyrRHsvyYA2B/JGa0wW4LcbzwEh2N+SKnJZP+DJq8xB
	mF3DCM7YFfA79KRpRFChOXrwwHS9hY4R5iWLpV4ZENhv46OL4tiIqLr5VSd5HYzFl3uhUF
	MaljLqdh8WlWaXl5y92WxwIli66X9M4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D305F40016;
	Fri, 20 Feb 2026 04:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BA7C116D0;
	Fri, 20 Feb 2026 04:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771560629;
	bh=gZxt4xZuUjXGGHmHKN+uEL1LSaVN4uFpnXdEPutVfBo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MzlOe0JtKCyX1m5ydTdmOVzcXvTdxMfSVFRW1WDwedpZ8p2JQgmRJOZGFUgTlts71
	 Hr60ts3TI6hMa3MEyxinxB57rKfjHU2uxE59BpIu/+eB5f3N+qA9HfZ/y9pxXHSsMe
	 L3ExxJrJPNmdBaRO6LklAWgLCZeMQM4SfZe7oXCSEv7YKA985b7AFKtdTkGKs4O6Cg
	 uqRH8XvnpIhuAXM6oqK780uPGKVGplX4xHqu5H1I49NkIMc68H4gUVOHdiYrMaHLJA
	 Q+bm4rmFxd0LDsuO3oJm/VkUkisIdSk1ra0ERiEMWoHPkm/KA2dJz7OtlmZRoOGqC+
	 GRRuuHhKY8EgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FE293809A88;
	Fri, 20 Feb 2026 04:10:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/5] uprobes: transition from kmap_atomic to
 kmap_local_page
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177156063804.189817.17364776119081008453.git-patchwork-notify@kernel.org>
Date: Fri, 20 Feb 2026 04:10:38 +0000
References: <20260103084243.195125-1-ming.jvle@gmail.com>
In-Reply-To: <20260103084243.195125-1-ming.jvle@gmail.com>
To: Keke Ming <ming.jvle@gmail.com>
Cc: linux-riscv@lists.infradead.org, mhiramat@kernel.org, oleg@redhat.com,
 peterz@infradead.org, linux@armlinux.org.uk, catalin.marinas@arm.com,
 will@kernel.org, tsbogend@alpha.franken.de, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org
X-Stat-Signature: 6n8xw33h3k5n8r6wrq9pfeabe5gyj8hq
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E9BB120004
X-HE-Tag: 1771560630-659216
X-HE-Meta: U2FsdGVkX19Ep/Ng09GGrHezGNf94jkg1lD8zQuuA+cVsThah/zWBKwQzPhFGYwpkbFQMaAeBW6PX0kyYGnSmgO/pMiTNl9X7wxLQ17yPNm8UZ/NQdAdde8QtifNgw40S7JdFYgUanOPLYKKFDF2bc/GIId/WeNPHvkTAeb+DvqTFJzGfDjP5ro08jGpop8B2ONIX7ltU+kE6efKJmWX/N9PIwll39aJ22qlMM0zQvyZxYMsRQvT3YqYjLPgQXzqq5VYK0+BFbjuc+BaGPL6OIwmpzwL9jtb03cqx+kznZv7jnUboBklNw+yhcAvAOEslBEUcivdCfO5YNeAhO3/J4pZPW/eNmyowyxNoRYNayRwNUsNiNTScsDRQCS4Es1W2QfozEcf5cqkPF7nroNMprf6Ynu3rjbLn8NGQ04QS/ZbTfRAjf85d2UYN7iboELadK0jUkUA9SdYRO0LgvWBRwzx+9ClFjFDdARqQINGWNwZR8dljLDmNNfa0VYOvLDzoQ1X/FhEImvmEOgNF0foxnssmdFOKQbwsp8jCyqSiPvKil532ep4q+I8qZ50J/9GHbj/nkhgxJy1e6atHts5pqC67CSB1NVy1Goxnb/w7YhaMIA+dbQx7diAAxCk0XX0yiysjTpNZWKUU2BdIWQcWtx7ocb/KgacLCbwAEZu6v7o76b/QmbQXFR0VbQ3XVYXl96HRGygnOMLS+zHxjNIQy5BhDtni682e1sXTDvd/krjx6bPSj2a4bms1oSaAMU/wfkrFAXPDbELwYlIDGqhyVEBQa8cyPl1hwU3Xk9QLmRU5yA6Q8i3UlZhnyFzSdsOM4iEQNtTevIY81YKIDa97FCk+Oi74VJZtuydb+g+EbwEvOoLvc3x0mSnnSQBR4XL5jF4dwCU9F8GAMv/bCHWF2hKL1V3yToII0/nfafmXH8VjEBqgK3pvhRdnjGMe8mMwuh7eJLQ3qcZHL8a5lz
 2vJ9Fiwl
 3w4sEBUTCWGsVQ+/PEW4tgvSI0VZhj1CPKJcf1bzgkg6PCClAi3G9gjvlf7RZdJC4yhyZRJ0vC7JGT0AlpVbRoIA9qKLYbebxL0G0CTaR89+gdAt1R6HmJNRc7aJ0yWxJe6RAv3Wge6vg8L+YmPSeNEBKm4qv+Ely8hSVmxjfCGpkgGWNpng3nZ35xp9wb1rUFdxPXAs3vjFO3GLhkdBqa/yWajOKJ2LsNbbJKpIlOhoJJ+NcCuAVXksSCeeXbmy+leB3TMf3+wjX3dj2ZdbpZ/DoUjZJgY/1GDjKRZ/6wG1+vV4oDFzwAdmu4nkX++PxTbLDJRkWI5EHpOzqKf26k4yLkwUMwCSATyhAY4S/mZ22ZWDuS/0Nt8l2HVNZjkgrwZvDQtXXZDtsarCNPDIadZP9C/HebCT5amV8DWiLWi33c8xzhGPeAo/Ra3ixyghuu9Tcf3M4Mqv704RzKSn0C8Os2XhzOESQpaudIHh7FHojwimxoVLwtmMxKzlzyWezgCtzhOmpYtxfdHieN73dEW1aQNbEG7tUrV2hZVUxdjjJURY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Peter Zijlstra <peterz@infradead.org>:

On Sat,  3 Jan 2026 16:42:38 +0800 you wrote:
> The use of kmap_atomic/kunmap_atomic is deprecated. The purpose of
> kmap-like functions is to create temporary mappings.
> 
> kmap_atomic() typically disables preemption, while kmap_local_page()
> allows preemption.
> 
> According to the documentation, kmap_atomic() is primarily necessary
> for contexts that cannot sleep.
> 
> [...]

Here is the summary with links:
  - [1/5] riscv/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
    https://git.kernel.org/riscv/c/a18dfb5dd332
  - [2/5] arm64/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
    https://git.kernel.org/riscv/c/094cc7bb5fc3
  - [3/5] mips/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
    https://git.kernel.org/riscv/c/e6eb9acc024c
  - [4/5] arm/uprobes: use kmap_local_page() in arch_uprobe_copy_ixol()
    https://git.kernel.org/riscv/c/1752a1ad43a1
  - [5/5] uprobes: use kmap_local_page() for temporary page mappings
    https://git.kernel.org/riscv/c/a491c02c2770

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2294CCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36678E000F; Wed,  8 Oct 2025 21:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C8F8E0002; Wed,  8 Oct 2025 21:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B492B8E000F; Wed,  8 Oct 2025 21:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A28648E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:07:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A8BA11B01B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:07:21 +0000 (UTC)
X-FDA: 83976787482.18.EFF6C33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8864E1A000F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:07:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mgLCEG1p;
	spf=pass (imf19.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759972039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QmteHczt4IB2OaGgMcuo7lCBy1YKUcT8nLt2LHCF7g=;
	b=vWoZkmeV1zXl/wAjgbjSZD3r/VAvGW2inqRVVv+uzu71bba0DuGsdD+dN3MqZVl2DiFfsy
	HTN6U3UF+LQlFKsM9m2eQ2/RccaLlLTFbWH2VCBR0UsNQmwebpzZhaR/MSDFnefvAc9ZmQ
	/UWC47C9ywmhKVjh1fAERWRucVSoF7U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mgLCEG1p;
	spf=pass (imf19.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759972039; a=rsa-sha256;
	cv=none;
	b=49jJyPMcd5GzdOPhwgk25yCNe9K9A5kLmbdy6/qWdottyuRmcJMGVnC9SH4t8+pWAZHCwy
	we3+zEGkzwG5xJ9s5Rvx1WUcbQ7n1tNEB8SH9gcXk+trhj9sLHxEzhLsSTSawayFs5sVPh
	zLZomHbn5rbAWkFcL1tkputNViDyVdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32835450E2;
	Thu,  9 Oct 2025 01:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1021AC4CEE7;
	Thu,  9 Oct 2025 01:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759972038;
	bh=0pQ9vc0S7+W0X1K4N+Om/UUij1yWdKMoXEP+Dp45E6A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mgLCEG1psTMeWNX86G6Tj93NFOr9A6HPWBooqhDsK/peZJiDr0z/lTt34SW/uV2wG
	 K2KA79ATbUyDb+QTtCiIb37Rmvl0ZB6h8EYOw6lZaU8PA4YEraSK96r4wnFJg5DgK6
	 px0wfbyKDtcXRuIuG3T18Ewh+okDNXN4RBEutXF8zlOxKiOztQ3FRVjOkE20nlpwGX
	 YhuXK6buub3FK7cN2EWSYIN6r/pZvCaQavyztMciWzkDa46lDOV/dfEDrzjJFL6sad
	 0NMFuRS+cJkrvvNwdswXaYRikNalB+yZpqvN9LdbCi0fl6LsirGqURxRennMUrvEHk
	 ipzxebesp0GnQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF8C3A41017;
	Thu,  9 Oct 2025 01:07:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 0/2] kasan: unify kasan_enabled() and remove
 arch-specific
 implementations
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175997202628.3661959.104646439887808862.git-patchwork-notify@kernel.org>
Date: Thu, 09 Oct 2025 01:07:06 +0000
References: <20250810125746.1105476-1-snovitoll@gmail.com>
In-Reply-To: <20250810125746.1105476-1-snovitoll@gmail.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: linux-riscv@lists.infradead.org, ryabinin.a.a@gmail.com,
 christophe.leroy@csgroup.eu, bhe@redhat.com, hca@linux.ibm.com,
 andreyknvl@gmail.com, akpm@linux-foundation.org, zhangqing@loongson.cn,
 chenhuacai@loongson.cn, davidgow@google.com, glider@google.com,
 dvyukov@google.com, alexghiti@rivosinc.com, alex@ghiti.fr,
 agordeev@linux.ibm.com, vincenzo.frascino@arm.com, elver@google.com,
 kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-mm@kvack.org
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8864E1A000F
X-Stat-Signature: 6iq6qsom3nnckdpzj5rqhude1fp6f9jn
X-Rspam-User: 
X-HE-Tag: 1759972039-670011
X-HE-Meta: U2FsdGVkX193AFLtnw9kGAZDsfhRdEoDcnuh/v85EmF25kP7km7kv59aCQQkFJrWhc+/X/QuCP6MXTuBdlpqhDtpRk6Y97Wb0yUchJRA4MY5YhJpbWRkjKkGsnH8v2OBEiQL1oiB5jEXHjIYt0+nWt1yBpgIpjOmj+WuHEzjd+pMGHnlpwjTHeWD8KBpi7tOezudhXP5F8+rj+IkrdCg39eX6cS07yATJovFgEDkUbhdsLdAYseMY06qmVbHs0rKyhBSy+oujeKx7QgbZkcOxDjzqvRXuy751Nt+79xlKJG+iaZXYcpFg1GdVQdj8qqqHeD1cdEsVST1joitlfiY5XOrDY/YaFzl9BYVGhqiXPnvkK2YuEY/sasNwzQO2x5n1ONCzMC0ei1hOEUwAOLE9vZNro/uww+RNGRsf6PZ2WVhEaSxD81Zk9lOhiLLrhUOuREBqUPmq3Qq97FvPMoHmq+GBhKQIb2rtP2iSa8nBTw0PzJdoKU68VhxBZSzx+svbz+edIMr2iGOH3qH7pxMdLBa+6ej7JeNzdEak36NCtWovEDpFpAi87yoIzQ4x0ydhLuAggl3etgnUkf+N5/GUZXvEMIb3jXp/x65iYdYqMg5z0wE2HpPGkx99gnDLSi2ZrxX8sMbNU/DvIxCAoL0iAozDV8uvRGBqJ1iFUQTF1KxHlzH3NaJKPBx0+brUgcp5IxIRjEqvjiKM5jQxN/fiD8wprQMTAJmG4yBvK1EuTPwTy1gQzn0fCA1Ggf6i4eEB8mT+h+nMgUZQh8t4iy5ccrZ+3rMpAn+c23hjmEdn6+CKlm2C2bRXdFY1mgqWfmDOtTyEOp8igWGJZxCRRXA5m5HSNIQqdoe+Qq2GzNJeJFpYRSQzmYqoBh0H7nYsvzSOYUbvm/ojlnzTsXn5dOn8p0Faw4QEoDZzYvkOW3PDSfMlFFx1TWznOMyyzBWAuiAkz2SdR5bWyjKOjOVocO
 HVoNJBeW
 8zZMvzEtQMz/9CqAqwxJfxOZLnaGXA/QvG1/NliM244BhcvGwZpxrThk9ITkVTWbRG3/0VgX/7nxtEzXXGIsWpDO2LtkR+q2OzDbKmZHA9tTUCw7baMGqUjp+68R0VOnvA3ZbkBruVCmluQP0DYqz/EMdwhE2JuxK1ur4ER1t1SqpNA+ahj7sBt3N3/hs9t6DMCFMO5sGDco1/dtHvWIEts3DD3baCdSZe92ahqPM1PwKs+2yoyq5wB3C1egue45G9aHcao3+ZKwHCUwT7ZoPj6UZKNlKrS5XcwUwv6l1YeqGnHJHrAcmyGIHN7hBt0yqJfNYCZt35SWFyg8IvemylRVVdeHsJXwO/x+KYY7xtjYvbv8zXhCaH/txvH1D8S1r0hL9rOc1xEU5S+tLTXOwEg1leJ9uUYSd8gvrz6BLvYvefNtpn8Tfd3hUnLA1Al/YWAwvq5CPaj1g3UqiguRcah+Mqk01I42azEHg2z+FFp3DPpgXzdawgX45sMy2YL6bYIDb2c2I4dodadKv3w9knar7OZMwlzX6inficOHdIDpZ4AM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (for-next)
by Andrew Morton <akpm@linux-foundation.org>:

On Sun, 10 Aug 2025 17:57:44 +0500 you wrote:
> This patch series addresses the fragmentation in KASAN initialization
> across architectures by introducing a unified approach that eliminates
> duplicate static keys and arch-specific kasan_arch_is_ready()
> implementations.
> 
> The core issue is that different architectures have inconsistent approaches
> to KASAN readiness tracking:
> - PowerPC, LoongArch, and UML arch, each implement own kasan_arch_is_ready()
> - Only HW_TAGS mode had a unified static key (kasan_flag_enabled)
> - Generic and SW_TAGS modes relied on arch-specific solutions
>   or always-on behavior
> 
> [...]

Here is the summary with links:
  - [v6,1/2] kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
    https://git.kernel.org/riscv/c/1e338f4d99e6
  - [v6,2/2] kasan: call kasan_init_generic in kasan_init
    https://git.kernel.org/riscv/c/e45085f2673b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




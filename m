Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08220CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726546B0088; Mon, 25 May 2026 11:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7526B008A; Mon, 25 May 2026 11:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577A76B008C; Mon, 25 May 2026 11:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48A066B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:50:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1EFC8BDC7
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:50:10 +0000 (UTC)
X-FDA: 84806378580.22.82584FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5842940015
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:50:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VjYzFiUb;
	spf=pass (imf01.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779724209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DFSewy4HiHsulqVjDY+J795cQvlcQzlXeEXsle8lBQ=;
	b=BN+xVBRJn45Dg2ddvYKNzQZBAKTXsLlr7HvoyoVjB3TG09NXBon8y8Nei6M4utOBJacUYe
	Uh/MO2Jm2TUuNyACJP2JuokhVSq8Ja2yAGT9McEXLS+xNSCj5qKGM7Lt/G1gMu0qI4tCW4
	ErmdqI3lrbIg1Ej3M2OQIBFRM19Ocu4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779724209; a=rsa-sha256;
	cv=none;
	b=uAM2FKlhcumN++Pn59wVn0YSTV7m9UT0zo/Rmbc9453ZeF0MGWBX3YWG+Es1HGNPguVOI+
	Amnjrhv2CsPQp1r0zCxSMuv/zw3Xm+siUhjA4WFduowZ2MnrKB88fFA8BSM/udSJMUH0ut
	42OEGY6aaqYSeCqGCN2P0fYzrGD5t3w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VjYzFiUb;
	spf=pass (imf01.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6F5B601F3;
	Mon, 25 May 2026 15:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944691F000E9;
	Mon, 25 May 2026 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779724208;
	bh=7DFSewy4HiHsulqVjDY+J795cQvlcQzlXeEXsle8lBQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VjYzFiUbbB+KydlfY9Z4MuBygfHZEOhzzF8hqPM3jzuAT12EAGWi4sWZ5Kj7xTBmG
	 /xgXWuskpWqOfF/++ekEIAsipeAeQb3YtnKrQnv1758Mmm97CNXTov68HsnU7ff+cT
	 5WPDO01gr5uSuD8EesHTGnWwfCDqLnLRq9HUAX2SED9u5AdOZxvlTTWIODe+Pntcpi
	 bHQnGL28WCVobvfZpLzPe+XKfGpoDvRcskhXnXu/QJRk1AFBymhjlbuU9uCvSG5UbJ
	 ZqD0nShvHeADxBhybW/GnMY1bwvu6WG8sgtinirBkF0AbNyu6WkTYy1he2ImOo86lK
	 Z8JDU7xInsufQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9389A380AA66;
	Mon, 25 May 2026 15:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177972421514.2623932.18366712575128006806.git-patchwork-notify@kernel.org>
Date: Mon, 25 May 2026 15:50:15 +0000
References: <20260517211232.1670594-2-tj@kernel.org>
In-Reply-To: <20260517211232.1670594-2-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: void@manifault.com, arighi@nvidia.com, changwoo@igalia.com,
 ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
 martin.lau@linux.dev, memxor@gmail.com, catalin.marinas@arm.com,
 will@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, akpm@linux-foundation.org, david@kernel.org,
 rppt@kernel.org, emil@etsalapatis.com, sched-ext@lists.linux.dev,
 bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam11
X-Stat-Signature: 8eyya35j39xkpzyjrogogkyiapcgz83x
X-Rspamd-Queue-Id: 5842940015
X-Rspam-User: 
X-HE-Tag: 1779724209-805914
X-HE-Meta: U2FsdGVkX1+sBvcxAgfUYBDJhyQB9sIVkL1Q5j6Eb4oDIvz/YCvoRzW9eNQSYvy3eWGsURl3x+rZYaTomI/UexeGph5wTAzhPrHJ2LkGyeZ2fep0WchYTEwdl/zpRRiXsslvK1CA4MS7yJ9Z0lxy7OuZWLFqjQUy+7wvHUBP2u31mj+cXP8aruodWs7WqK47Ml3TO5sQem3sGcIp5ZbRAfTJ6V67d54/gRp//63dWDiX9sMYEUsXWuCZwMCMnD5t6EUxRRbiVvQn9R4yewrdlgxP+6FxTgZDi9dcs3kVU+SyXBjC5NWZxb6WcGwHOVJtc3w29GQW0w8z7wPOxO/nonirrs5skWxiBQCmeQVt4lJa95q8bg/yBPE1cT28U5Er6gZrz4Dg2CrhtKyrdZ7rc3XU3vav8kGyTrTKYgzxYdgZ6qKpUTfeZWh3bYVKh6WDUBqVeP0PzqnT6J7Le9vz7O/V939D/wZGmnoK+P+x/yzxNmIDlj12yCE+7FvjT3D41zrHxXJliAbSm37JmSRUty0BGytXYh5UX9MFolIQwgeLkB6tUCMoFwRQ3/5AbzTXrED21RYblg5x9I2UBzX5foLDFdBa6dXVG94OXZvuvrXUavz/o70qMgsrMBzWbsZ5UR6bcDlxogKNbK3aPnxQDZmXMs4LPJX+ItStMQXWImpNU5sFmEJDE65cNrpDqAwvqDhj42uVxYNjHdiO39RqQj2BNuTS1mfipAlIAD6Nb4OaDHvY9jViWLY0mj4T5x3UUT+SaBHf5TKtfHM9Z8NWLOo+XRPwGt12E4DIndrPkcr2xB4I+9g/s1wte4NsrqQTiRvBMpleRq41AqxnGM7bGItInO71jw0CyErMau5E8gTWpHB15ShsDeM1yyZ0nHjq3qgtYAt01w/mFIpKcAqk7Ud8HVAL5fQV2kUiEanQ2arqwRPOyDjkoObM9tRzjwmrFJraFNcUd5r9qvwPq8e
 uYY2aONY
 5emX9nQqPekTuKda/o6E8axW07kPMUyKQ31Ws1mh3EvyWGJdHIDZIWH4KE/T7rCUCBi8elP7GJxEbUPmTwrI5RZeU5UOGIm19mQfNLm5UNZCeKURBU335rXTXct+XNXEwLERMWSWJBquPa/UZzwZ4Ojx4o1kzpkdonZV6O+KDRocp/+kXE20WkFGJc2u0qGv7iq3A/+51grg5u15dSc4A1G7eFGZfuyaUrkjY3tKI2idrVp6kb8GubxkP/uFcYGu/3Ig/YU6N5pqdgKpn7DfCHPIvvAY23MH8+412yG+Uaq8iONP/W+50rp5fSmgU7Nr1KgxgJrb0OUBo0muToKP3oEzyV8Y+wUytTcV7RodWtF3Sz+W6r8AIU/sps3MJCl0DFl18NnXDJatJecOjDehFW32ggyLB7l616+D2MQ3HMTwaN3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sun, 17 May 2026 11:12:25 -1000 you wrote:
> Add ptep_try_install(ptep, new_pte): atomically set *ptep to new_pte
> iff it is currently pte_none(). Returns true on success, false if the
> slot was already populated or the arch has no implementation.
> 
> The intended caller is the upcoming bpf_arena kernel-side fault
> recovery path. The install runs from a page fault and may have to
> contend with locks already held by the faulting kernel caller, so
> keeping it lock-free via cmpxchg is the safe choice.
> 
> [...]

Here is the summary with links:
  - [1/8] mm: Add ptep_try_install() for lockless empty-slot installs
    (no matching commit)
  - [2/8] bpf: Recover arena kernel faults with scratch page
    (no matching commit)
  - [3/8] bpf: Add sleepable variant of bpf_arena_alloc_pages for kernel callers
    https://git.kernel.org/bpf/bpf-next/c/f211c81ddc36
  - [4/8] bpf: Add bpf_struct_ops_for_each_prog()
    https://git.kernel.org/bpf/bpf-next/c/7c48a28c1bbe
  - [5/8] bpf/arena: Add bpf_arena_map_kern_vm_start() and bpf_prog_arena()
    https://git.kernel.org/bpf/bpf-next/c/53cc12a2dc88
  - [6/8] sched_ext: Require an arena for cid-form schedulers
    (no matching commit)
  - [7/8] sched_ext: Sub-allocator over kernel-claimed BPF arena pages
    (no matching commit)
  - [8/8] sched_ext: Convert ops.set_cmask() to arena-resident cmask
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




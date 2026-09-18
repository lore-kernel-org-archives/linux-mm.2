Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6747C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70716B0088; Fri, 18 Sep 2026 11:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21E46B0093; Fri, 18 Sep 2026 11:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0FF56B009B; Fri, 18 Sep 2026 11:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 874076B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:41:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2383C4072D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:41:17 +0000 (UTC)
X-FDA: 85227296994.11.057F435
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 79BA28000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:41:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsEW47le;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789746075;
	b=w+g+PoVS33SBGWTyXvar38Fnx5/NtAm8/NGv6LDsmKoZ2dC6xmaeWmPns9Bel16uaUKzld
	uz2YXX180SyjzdApXVUd5cpXK6+9dvxCk/6mrkbb6sjHRjwqHtYcfVKAwcK8YYMutnGtgU
	3OKvVwNuJbsCzRsWKYwgQIILd3RsjkU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsEW47le;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789746075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QrTzPwZV+cIHnSFVSbgZEXJuYX/Blul42NpRNzRFFzI=;
	b=UBASNpqoLs5X8g8hr8JqXzKRIBZ+7Cz2yzVOqPRaakvVFwiIn/mVSR0ov+CaQVYX+4cZnh
	GbfJqcRFCxM2ofgaUcGHowgFBDVI1HITlm174+vYS+nyfym9qRSq6j+McJpfv+sFXmt0ai
	Ba9pMZ9cdDUTExirtMClJWEq/JVf7fw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 997A941B21;
	Fri, 18 Sep 2026 15:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775A81F000FF;
	Fri, 18 Sep 2026 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789746074;
	bh=QrTzPwZV+cIHnSFVSbgZEXJuYX/Blul42NpRNzRFFzI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=nsEW47leoMgc4FKORvNabd03usLFuSKRcNZFN4aW2Gy2b8IjCvOmkjH8vOb16uW4n
	 OtLHVecucZGHMkwvo/kFOcb2XsPtL6YobuauLHrX/2qiJmhHJLjyc5l/pOjnv2xR85
	 FnF1Sj1cXHLq3gZnhwAM2ieQvqtyhniQ8KkThAXcCFM/NRmhrWfbPomCBABz76KgDT
	 EkvZd/yoWeULD8qmIHu1Thz0Df88vTJrfp7VoyRl40N+/8j0bGvCeApXdmt+G9PXOL
	 pCNGO/cyreL4Td7NEoFWpr30qPniyQjVXRCxoNCbDmQWELDoE3f81gn/mnpl4/yPCE
	 QCRN32bOoYLKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A8C380CFD6;
	Fri, 18 Sep 2026 15:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v9 0/5] bpf: Add user memory access kfuncs for
 mm_struct
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178974600740.1015302.4891269233605977297.git-patchwork-notify@kernel.org>
Date: Fri, 18 Sep 2026 15:40:07 +0000
References: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
 brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 kpsingh@kernel.org, ljs@kernel.org, matt@bobrowski.net, memxor@gmail.com,
 song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com,
 viro@zeniv.linux.org.uk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 79BA28000C
X-Stat-Signature: rd31o8gks3mc19xo15i58bx56d79srjm
X-HE-Tag: 1789746075-679545
X-HE-Meta: U2FsdGVkX1/96IzJp/fb3uaAWXLUM2HS2Uwdtzkpu9QS5wmOZNOHtCyX35f2L+nZKWkF5rjQdzqvIyMzNsbhAOj6ela2erfqC1HQ+9yiHIUhI0X6NTe4Axj7F2UkHRslEmLzFYFhKJM3LWv8++gCFiPgMy9pLtNeeht7T/PXTJ5fIJT0e8I3arR3nGksJs9GYVyXcG0TurWZDlFVZkYbpf8cQJHftUJuA4/Ldx4N3+gDzYZnIzm0mTuU9uO3MdkpvikDAOEe1fRS/J20z7s46izMAFs/EhLRn2uaTzpdBmNrUQDbXKZ/u1iSVPRFPsQDAGOBn2J4RgMFZBlOuRcJeEEs0CPpBemJJ21GPbw9Xc4huQu4L6kZ0fABx4uLU3Egg/6KOD1u68m8Sc2z39/2ufgMG1TTq8h5wRx1QzFVhGYDYO3vRrJlJmimgRzIrurs0TL5tVBTRiCUOEk6U5wr7h6ajxkE1bkSrGDlUQ4Nz8YuBVKzqJvRTZ/C4bsucqYoPYFYrc/WvTiiImFq2DjgG8YpRyXHlfoF6w8lmXEhyP/L3KcJoT49Vn9X9JCIKPMmQENO+SJD6Y/RUq+Ywjso/NU6l+5V9XXu3+plJQeREN+81mj7NFQ5ZF5KCPkbuMPQVXz1QVF4bhrHxxMIj2/Re2LoGPpZA7PmI1nx5fJOAK+2/dZ0QfWnugGHnilcPafETlSrJ2KsAZOrkALNV1boJffXbCV4bqTxrVreFbynvd0dWObwpKnIjnbjEL7sIkiLMj4Go+n0F0tNSmCcXQZ1gfjGQOqCaOV+1oLfVk7ZyOZDTsGAqI4+h7UVIJa7Hcsxa7EpWvwd8ttM5+Lwq+LNuzpQ8biNZSF7AhQVdZ22oYs0omqYjYJ8A/AX3u2kWhOhWxV0tKhrh0a45ingm83Z5Txm+5f5uS/e0cQ5aMBIrDatiMkVdkH+aSHU4MwOF5urALVRoBi9cAFDt4BJdUt
 SxlMEC/t
 OYkQCROxjkLqt1t6oZndKeMuVxA0cUR9Tem8kwaQvq0HZl6NzaMVJgEyjDvaWivoycld2QCuHuiYL8udiMiR2iebGlQLJXfSQD7/wSfCNSsvsBB8kZGlb27/h7G8VGeUrGwhrRyySDz+2C+ciOP+mbffjtDS3vN+NEHnJRYH/obHLFikMPnRnaGwsPY+U3KWWysN3GhL4Ks8JF9WPyCDEvG6b15TMmOnUxZTuxTDznWz30kV/Nk97LffLzCORhL4WZ+gcNTYFtjo1qGlfDMsLMXci5/4+bpFRNTNr6gwpsuGLeWOG49JrCaf0vRi1tKdLKcIQrpj8Qo88wiSTe8SLz8hlrPEYjMbSkLWk5jVorxIFxnE4lNeCwdsykN/0QA8M2vP+iV2Tg07N/endqxfPzDbECXjlkJaiqieM75bbT59lxLEGVuoF77WoEmHW/ar/VZoi72WkTZfVNLIueml61WuhsfXxNcGgo3Z03wtdpmlwf34tmH2DOIeA0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 18 Sep 2026 16:17:52 +0300 you wrote:
> On MMU systems, during exec, argument and environment strings are copied
> into the new address space held by struct linux_binprm before that address
> space is installed on the task_struct. Existing BPF user memory helpers
> operate on the current address space or one associated with a task_struct.
> Because no task_struct refers to the new address space at this point,
> programs cannot access these strings from the bprm_check_security LSM
> hook.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v9,1/5] mm: Add copy_remote_mm_str()
    https://git.kernel.org/bpf/bpf-next/c/69d38c792c53
  - [bpf-next,v9,2/5] exec: Clear bprm->mm before dropping its reference
    https://git.kernel.org/bpf/bpf-next/c/adc7fb9955e2
  - [bpf-next,v9,3/5] bpf: Add user memory access kfuncs for mm_struct
    https://git.kernel.org/bpf/bpf-next/c/3f9d98dfed79
  - [bpf-next,v9,4/5] bpf: Mark linux_binprm->mm as trusted-or-null
    https://git.kernel.org/bpf/bpf-next/c/cca46f91737c
  - [bpf-next,v9,5/5] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
    https://git.kernel.org/bpf/bpf-next/c/b5501fb38ff7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




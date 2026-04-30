Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E11CD1297
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04106B009F; Wed, 29 Apr 2026 23:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB1C6B00A1; Wed, 29 Apr 2026 23:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A526B009F; Wed, 29 Apr 2026 23:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADFF46B009F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6965F1C01FC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:28 +0000 (UTC)
X-FDA: 84713784456.01.670D02A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C5222180003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BDggSUI/";
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jT+OUJtAJIr/9twMSxAjiwxoPeCWeeNSM1KvGYf4q4Q=;
	b=7PyV54OewkoQF5eCZ8nlkFuHd1CnOfy8arRRhCYdi0N1shSvNC/5UA7RhML3ZBHhgiC9Dw
	bviRMmFxPAN/HK74TJXaquNJTlOShdF6cq0VMYPBDA4In/3KDvGBh10z7+7o5+sEsjIOYB
	bXoCLih9NGHXcvvc7jL4CaJ0vg/tqxM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BDggSUI/";
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519586; a=rsa-sha256;
	cv=none;
	b=pwnQoxDYqsRhqL/JGzfwr8NhyUuKDeTa1F7q51eyptDho6n8yl2t3szY74sg3fXJGLrF6t
	eWttxs1LrbNHRrxtcYRtczi7QPIEQ+zgdCAp4ses0iiOh9bslnbclCVvQsNATtfd37KMze
	katxzZmtsm9lO744K2vk8Nc59cNsy00=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13F8840B7A;
	Thu, 30 Apr 2026 03:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9403C2BCB8;
	Thu, 30 Apr 2026 03:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519586;
	bh=7NsYW91aqne8euCtRV/Zaf8K1DQN8v/p5dHajdo+8yc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BDggSUI/DU00ul+f1gXDXnnF9GW7Ln4bEPIleiGatyjAcEDR3/0c3HZ45qeuP53O+
	 RHqUBUleYalpg/t7kM2RRrOc7opPlWUoW4RC7GR5y3Bs0jP+staKlwJZvt8AY4Vght
	 GW5FNvgEwFUCcJDe8gKUKchXT0d4R9CHF5faG0OmsqjTk7ZMlgaNiCobP6ZJa8bHjV
	 843djgTadQOXBoY1gLWaFLk3iH4N4aTsoXVrb85auq+UuOKSwFnXafOsRXr416j9cA
	 Mt9x87MJjmjRNDYbbOA3t6kXEA8gYvQZOIzytzDlqzDkDODp/PFewOmUK5nEEmUChG
	 6H7uKZd5Pu/eg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD063809A07;
	Thu, 30 Apr 2026 03:25:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 11/18] x86/vdso: Undefine
 CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751954081.2274119.4093898849560517911.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:40 +0000
References: <20260227193030.272078-11-kas@kernel.org>
In-Reply-To: <20260227193030.272078-11-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev
X-Stat-Signature: ng566auuaiyaso3sshsu4qb67rbsqk16
X-Rspamd-Queue-Id: C5222180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777519586-659575
X-HE-Meta: U2FsdGVkX19eFe9rWUOhlL54KPi7T4JchnwPKK+PCjBEs+1+TjNaQ4+g1W7yUlZmaDIm2DLWTu1WrJLmHSaXSKTwnyW673rgXLXpnPhYdw0HoW/GOkq4JqD20Dq3GF4eKjP8k604BBPJ/ZU2EJqYvS+T60jVByNXGnfcFw/4W2GAgMi6E//f+zTs8yL2yW6VHKjEq+VIGZzNwwPwOEdt9NLYis0oey/zWrdIl3023kXMshdyQyl7yrRBmGtM5BYgo0DOcP+S8SaMZ513o9NUboJ7oq/j/Eq4NBeKaKCgR91xQ8oslekrI5ZvgAQ0lVJacqJIk+ZJbEkYrrkvGH95qZjX/yPL1dtEfDDhbLtTR7RunzELwz1P1ZV5bPYFB6ZnmbZWqPvYTQsin3HbwKVB9MnCk9Blf7zlCi/UASkZC5KS4LirSi4igK9zs3gZFtuTlEiKMGXrczvF7YVcQs/+VswZfrR04y9YjvkiiVx4cLL3zXtF2qbIM5mAecD1EhssplFThB9D3sOg/FguoM9xgrJFA7bEENBT0y1tI/F1n4C4+AHKMnKqkUMmHSCXPopCNBWz4SXutr88WBTO5jG2kD8xbNLVJDg3hnbQacCS+zVCTPd4z2Zo/Rhzrc8Nh88aujA8o3bV+KArP5ssLMAFYK8ttJkSpxjcgWYBd3eo3vJnRGyPN5Em2FuHkrw/tpd9bpGvJ436kT7p8tu3P0J/ZwV6Vf4DWthaMAmwCXdWUKqQ4a/3RcY43Oc0NgT0Jc7PAGcgx6bE7r2PmAnQIIQTe2a+R3q9Ja9boGwPEKOQmc59qVUlnSPqwaoKuV543ktmaJssN/9xAylcUHV7G1fgjn9lOYmcQr2xkutfXNYfqE0et5DVNP016OJb1KNuO06+15X9S0cmMpWH8wWeVNoVZxGxiM8WjRx6EBFBPBgM9Vq+jS34Sv+y6UXa6JHuGdSqpBnzan42bQN1F8CZaD3
 Ceqrc1iG
 86j1V9+Jt1y5awMYJ+T7K64SUDgstetMOschcffHLq3Z+n/c5ZsSnNLIxKOSSnD7QAaTae1cHlScHpogLVsiXyS+iRXk3P43L1UmnldPH1IqQ4ZmT7LM9PqTefnxThqVqXGhkOLFEGrNKLebLEuPY7CtHqCVUPPiuc80xRwE4B2hI18TXv+NuJbhjY1erHFvepaSPI5K4Qu+BVx9MBdV/npJ8F4yrghcZve3YVEgeYtgZhL2yNkTC9jvwMTNySk/0RV0q/4O5M3rZihT0L38n/ndV2hsGTHqL47blvQtlu/uRbeRcNjmAnzpAtUv2bVe7kMaLbk0uV1Vsl8GPm0M3wRMTC9Iv9pHm6b8OPWVOwPyNU088Cf1QU0C1xshYA1AEMjt6N2nHpBgcpuLwqS4QTOqXnaNzKqRD4+xPN+aga1T6eGTxQFZ639R4sRWfwr/2EdzSMyM5I9i1+B3sZED8YqksCl15Gu47BRfXHP44YUH+XWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:12 +0000 you wrote:
> The 32-bit VDSO build on x86_64 uses fake_32bit_build.h to undefine
> various kernel configuration options that are not suitable for the
> VDSO context or may cause build issues when including kernel headers.
> 
> Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP in fake_32bit_build.h to
> prepare for change in  HugeTLB Vmemmap Optimization.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,11/18] x86/vdso: Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32
    https://git.kernel.org/riscv/c/76351f2f0c27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




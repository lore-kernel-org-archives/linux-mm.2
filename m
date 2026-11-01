Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB6660A3829
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dkhr+eF3
Received: by kanga.kvack.org (Postfix)
	id C1E126B05B3; Sun,  1 Nov 2026 17:16:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF976B05B4; Sun,  1 Nov 2026 17:16:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BFA6B05B5; Sun,  1 Nov 2026 17:16:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 765636B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2251D120A65
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:06 +0000 (UTC)
X-FDA: 85387959132.01.E62B5F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F6F2120006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkhr+eF3;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793571364;
	b=yzQBn1LMUY7FgLrm8UaLzyqpJti77r/Vf9FYm2hhgF81qbiU8E92pdIuehZ0HdEclDKDpA
	MzpCGjsr8AwpaMtntvxHBe1lgFt+f5RXVdX6AqkoMHpUcJyUACz76Rqd+Ur+HvPW2fuTEr
	bAmokqFBXYUofEERGV4t6bbV3j+DawQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkhr+eF3;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793571364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QVLcxKIGpBrR1ls29kmgMJV8dBu1FUp9t501+9SlJY=;
	b=324DcTbU6uxD9m9BzP4zStU0Y6PB3NJWoNco0f2MzlFwjtrWHQcsCryLouCmonRdH42ocM
	6ZVV3bEdcmYn1Y4zJ0E4IZtB6KlR11hqva52ht/huAfpeeWbAtYfRV72HYbi7kIIrF6wt5
	rsLnFEV2wj7IhQi/F8qP1qirON3YB/U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B123D41FEF;
	Sun,  1 Nov 2026 22:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887CB1F00A2C;
	Sun,  1 Nov 2026 22:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571363;
	bh=1QVLcxKIGpBrR1ls29kmgMJV8dBu1FUp9t501+9SlJY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dkhr+eF3q1vLH5j+Vt4HH9N1vxJVl63OY3ZWjO6x3dSLn6eQyYKacs6+oM+3Qn+lI
	 thS97Vkt+DR9px4LyR/SisaZrzLD9G4XkXITq3BcSDr6ocIppa7a8idnye+qEIqM/4
	 lA297xuw1etIPcz1D0z9fjeTfmdqf6SQPW4T9L8XHNuLzhxg5drxCmE0d9RsQKGE7f
	 z+lpwxPVzUbcNwvBGGrQmdsobEkchSaH6YXFrcneezcbTudB2i/2DWGMJc6AtOWD6C
	 C8++koYKIE/Rb+G/udcYaxQ5Bv2MDWCQ3FwdoYvX/c9BzD2IHxxqLnrHL9kBU1vqtn
	 vMh0jbZFxh6bw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D35B38003B8;
	Sun,  1 Nov 2026 22:16:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357136205.2624073.6611857519856364383.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:16:02 +0000
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org,
 aou@eecs.berkeley.edu, akpm@linux-foundation.org, luto@kernel.org,
 bp@alien8.de, jackmanb@google.com, catalin.marinas@arm.com,
 dave.hansen@linux.intel.com, david@kernel.org, chenhuacai@kernel.org,
 mingo@kernel.org, mingo@redhat.com, kevin.brodsky@arm.com,
 liam@infradead.org, ljs@kernel.org, mhocko@suse.com, palmer@dabbelt.com,
 pjw@kernel.org, peterz@infradead.org, hpa@zytor.com, surenb@google.com,
 tglx@kernel.org, vbabka@kernel.org, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, x86@kernel.org, dave.hansen@intel.com,
 jgross@suse.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F6F2120006
X-Stat-Signature: t6zjuo1sxxyrrgmhdqhpj6q3sxueofyk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793571364-552337
X-HE-Meta: U2FsdGVkX1+b8TJBtSR3K3aPIFsq63MLDnpaYzdHXVg8ujLNQYNjkE8YYykKLBaQuXlOEHxJAvvEy4RiHqcBD8ZQuLacNa8fBvf9YYTyVYePNaBqtT6NRImLKv1S2pgCkjG3HBkyakAx/55yU6FadxjgTTmo0xesO7BJ2E1xtajFj5/0vuxflnC0ENWtwZvsRfn+S96VK1yux3o66VZxDggWPBt9WHx/bVevYXrFd7PQYr2LAvOHaWFqUk3mMGJWGMDHusCiTFcxEESr/kF+crta80K2gnejd8ftd5zCKv602KP8Ay/g4oU8ArQ722wkTxQnv1H1VCh+SC0naygyHCrkjzlaG9oQuCgejygfKkDPmyD1gHcIYTl8niD+2LxgB3WZ0Z+Vo/sRI6xzO3zURjnuyfKsF4zgJQoOqmvA1p0vSsYNdhMtiLVBsCiJi53f1ZI50u5uMO4RQPswZwaeIUDzpuj7m0rTIUV8ZYoBhOxkbrnBg6UMw8NQOTfIsjcsQXDuQRhip9SRAWIA3vNpIz6WNAxRFY/p8KeMWPZrhI3V5EBNFMpZijVA1A7oHUyutRLs/flXYYOHu0tBLTmpBFDyw63SWHPfC8345E9MlHq0PqU73BHH2OeuT5DivKamWxTPWbFBaEIAVvQiVnVqSfmTAk2rK7gPZhnXtsYTdAfj3f98qjGusZ5xbfprfqXi9kwdC35iM0Li9qfYBj/aJyncCt0MKAJLW8hC8Mz7+/QMAqLdxLyrg4CiXE549EPcL16czMOBZ96tRxg/BaZoZgu53ovC7MRpOfPHjAB4LGZk0LzJ+fUBdTySvBaggxCOOpSeXMVBgLigogY9MQTTEqgxOWAfJ5CxfI6e5Q6bp3a5DNY7z6pzB1ecp0nH/BGZcoLomjJokeuAIFqAtTxpA0zYfVCnIh6IC01OcgUwmEit7Ip0XXA3ealX6ujsP9d17kNOh3aVRwJidf8O4h6
 DtwlKbYN
 z5qrJZNFGuYRHd1UIIKSf1k8gEYveuYjoi2Zj4stRHqIkNdnUHjcY9eH5mWXriDO6IEGYDYXs7vFupm2a2gM4CzCnMXB1WgdUxQ0fX41UF0HHBz84aLJzcoWJS45p6ukChHJ9s/puxop7NQZbKR7Xe1aQeOeV0JHwdCcxHobmIeV8piRUQ0eNj6EFxoGghpKi9ePzAmU2H+kp/5aiCq4h2u81oXA5TQHjbVNXWNKpZBix1w13opVB9BAgw3jil642emgQij4rHE88ET0NZJPFyXvOdhjpzrOWB8sH1uX2YTBbaW0QWPQrZkhioLCrp9R4t+/TTgbgCG16P6dnQrx8PBbHRX82kKy/cGKX1SKLZn6lOHqCeu9/LaAAV4ClrM1lbttb4Cffs7wR2/0M8ajsckSzmtpzsMcVd8gUr2nD3C/873JG50LSkh7yDsRJd10jhGplzrmDA5OWKALDBXwXyd/CSMLbIOVF1DNqbSZ2cqs6dHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This series was applied to riscv/linux.git (fixes)
by Dave Hansen <dave.hansen@linux.intel.com>:

On Tue, 21 Jul 2026 19:23:23 +0300 you wrote:
> Currently there are 6 independent implementations for set_memory and
> set_direct_map APIs.
> 
> With increasing demand for kernel page table manipulations, for example
> "Direct Map Removal Support for guest_memfd" [1] and "mm: ASI direct map
> management" [2], it makes sense to have a generic core for kernel page
> table manipulation in mm/ with helpers in the architecture specific
> code.
> 
> [...]

Here is the summary with links:
  - [RFC,01/18] x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()
    (no matching commit)
  - [RFC,02/18] x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()
    https://git.kernel.org/riscv/c/ebaf7c9bbb1e
  - [RFC,03/18] x86/mm/pat: replace x86-speficic pg_level with generic pgtable_level
    (no matching commit)
  - [RFC,04/18] x86/mm/pat: use page table accessors for effective RW/NX bits
    (no matching commit)
  - [RFC,05/18] x86/mm/pat: use a generic helper for the large page size
    (no matching commit)
  - [RFC,06/18] x86/mm/pat: introduce an inline helper to check if alias needs update
    (no matching commit)
  - [RFC,07/18] x86/mm/pat: introduce cpa_handle_large_page()
    (no matching commit)
  - [RFC,08/18] x86/mm/pat: use cpa_split_data structure to pass split parameters
    (no matching commit)
  - [RFC,09/18] x86/mm/pat: use a single locked lookup for PTE verification
    (no matching commit)
  - [RFC,10/18] x86/mm/pat: move the large page size calculation to should_split_large_page
    (no matching commit)
  - [RFC,11/18] x86/mm/pat, mm: set_memory: pull change_page_attr() core to mm/
    (no matching commit)
  - [RFC,12/18] x86/pat/mm, mm/set_memory: abstract the CPA page table lock
    (no matching commit)
  - [RFC,13/18] mm/set_memory: read page table entries with pXdp_get()
    (no matching commit)
  - [RFC,14/18] x86/mm/pat, mm: move cpa-test to mm
    (no matching commit)
  - [RFC,15/18] riscv: convert set_memory to the generic CPA implementation
    (no matching commit)
  - [RFC,16/18] riscv: make set_direct_map_*_noflush actually noflush
    (no matching commit)
  - [RFC,17/18] loongarch: convert set_memory to the generic CPA implementation
    (no matching commit)
  - [RFC,18/18] loongarch: make set_direct_map_*_noflush actually noflush
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




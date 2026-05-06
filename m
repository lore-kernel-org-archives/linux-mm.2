Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C15BCD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404246B0005; Wed,  6 May 2026 11:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38D796B0088; Wed,  6 May 2026 11:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E106B008C; Wed,  6 May 2026 11:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF3E6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:29:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEAA9A0164
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:29:46 +0000 (UTC)
X-FDA: 84737379972.22.B2E0B97
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B7A918000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:29:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uFirFSB7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778081385; a=rsa-sha256;
	cv=none;
	b=cY9A0Mvb5MEMuIZf3mqmYioRfKB3vEJ9HqsEfP7PlBzibu6Obf11sTGGlHMI1R9z3x0cRu
	0T5Ng/XIFoCQ7oqr6iGFkmqK0WO8Wue5FXrNrWSu2WdwCMsCZNDjnOPAif97kSyydtRINU
	f/z+Mp7+S3f8rlI2Ffq6y+DP+DFRgAQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uFirFSB7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778081385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPed1cEalE8p9ynIcjerRfBMest/+qZpKOCHipzUr1A=;
	b=fLWqQ2p+MCzerG6SUq0s5iodkq70MdU4vLd5TsSb35fEkvA2AersA8U3/Nr8e30/ybiIPC
	juLaSLV/UzQPeuJgHni+fgmfsHjn0/d4klxxePE2l1l1BmlF9SL1EkddmtWo3eMrHSZWpy
	vut9ma1aREN5Ixpgcf/v7HkDliyZykU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB5FC1A00;
	Wed,  6 May 2026 08:29:37 -0700 (PDT)
Received: from [10.57.35.178] (unknown [10.57.35.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0ECE23F7B4;
	Wed,  6 May 2026 08:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778081383; bh=ip9HLEiG0rLbNmSPtdtn1g8pMwO4gElNKtnSHYmseRU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uFirFSB72AiOef9KIv+LoT9vVvtJCtTeQjSPmbbHWBwooyjT8eiFl6hli9r8u2BPS
	 gHyC5cl7Wkl3o2/jxclgGiXD3j4kM3UhGaulOOhnlK8I+2AmysP0zN+JdbUzX+Vc9a
	 hoBjF8BQMLMCsZkysXmV9xqpxgEHR0MXfBg+hjU8=
Message-ID: <77d63e89-04be-4b76-b360-dc45badd1a78@arm.com>
Date: Wed, 6 May 2026 17:29:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 00/24] pkeys-based page table hardening
To: linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Ira Weiny
 <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gnbkyxm1ccaq6fytsao1dcaysxeta3sx
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B7A918000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778081384-647870
X-HE-Meta: U2FsdGVkX1/W22F/9USTNd5WM6ian8SAdFOBnpoYP0ox+nXH9oViHye+8umFDCQeep40tFzThglLi91vbJpjh5KLKtOMMAXkWoBXOIt1VxmCL78se/onnVd9dMY5UvhbMxLwR32FeF41qWyvp/EZl73jsj5vzBblHiiiQ9YzFmtwsLgUBWMOfYc1RTdE/ZRg+lInPDgokOTQad+27rM66eMERdpDBenkED8fbepCPwF3PNkso7SdTPB1w8i2P4ENseuuo5j/4Xx89iPYVGTyS7r+VfloScNCf9GtB6ivW2R1FUMo7WDec8xP/1YcPkjEEgluhsgK323F1gIU6suNWDJTa6GMAfKbvVQwtgeEhgc3ifhptQ6WI8XqJh/gSo/KKlUhy2b4ZRyiXwKF2uKJBi6Yh1qnJwHAob90in/Ih0FWn15RYzLq5QeT1pTwC8vTgBN/rlYajBbzNRIWe4FdWSYGyYdgONFgIyaA20a/NtSnvJvP/eR87+eMXp8maFRQOWYyctbrcE1CSWjZlKL+rjACUTR1wQozeDRQu4UEp+SWhc6WgjUdPTS1gVHxC3jYUrT6dfqex2+0n1Q0rk4kMEsqSoJHIkTuoVVSNgwNTC/znrk3LuPEbM0SSEX0mqD6PcmGY5DS6JL/JIG+MgMBUid22ixl638OrgF1LD43ausStjSLQHAm9hxinAN7L2sF0guVmjKz/fWfqftJ7ndl6INKcBLc9kCFzzLCufeaXGMuFkI36/d4Txh+EEUArYQAq1jziNe3VPi+9ADJi7bzw3vICG4318Xo+5RLgM82ieApGLq2JnuaEvtMvwf1m6+VsH+UjkiK0LumAzLe8xWL4QrZ1M562S983jgWJteZpSYL1kG3GhHpvBkp0mBMr4BSbRImSzoygU7y1FnqxZNw1glHcKjb1gRwCv+c7jTdAX/y/phvBg2iUweYA6Ci8zm2Wv8ByTJHt8gzuWBo7OM
 TaDH8pAI
 cWflDEN9U0ZfJSgxHOXsNs71JSfAlMSM4Rsi+ya0l73I05jXulAmFJCzVz993q3VWibAoRs8/fRl7TRURENlxd1R87lK8X3UgQ/Lwv1lFG4dl5OAHoOFjRaqZXCUwsdEHjAep9gpDMu1Wt9yJ/07qu5LCPI5vov7jjw2div/gjUi2GttYvNlUlqUKXIs50ALs7Q0PpSTwctppGpc/ROXHYmu/LQGItLAZx8GIPv1jXIcPyhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/05/2026 18:05, Kevin Brodsky wrote:
> Kevin Brodsky (23):
>       mm: Introduce kpkeys
>       set_memory: Introduce set_memory_pkey() stub
>       arm64: mm: Enable overlays for all EL1 indirect permissions
>       arm64: Introduce por_elx_set_pkey_perms() helper
>       arm64: Implement asm/kpkeys.h using POE
>       arm64: set_memory: Implement set_memory_pkey()
>       arm64: Context-switch POR_EL1
>       arm64: Enable kpkeys
>       memblock: Move INIT_MEMBLOCK_* macros to header
>       mm: kpkeys: Introduce kpkeys_hardened_pgtables feature
>       mm: kpkeys: Protect regular page tables
>       mm: kpkeys: Introduce early page table allocator
>       mm: kpkeys: Protect vmemmap page tables
>       mm: kpkeys: Introduce hook for protecting static page tables
>       arm64: kpkeys: Implement arch_supports_kpkeys_early()
>       arm64: kpkeys: Support KPKEYS_CTX_PGTABLES
>       arm64: kpkeys: Ensure the linear map can be modified
>       arm64: kpkeys: Protect early page tables
>       arm64: kpkeys: Protect init_pg_dir
>       arm64: kpkeys: Guard page table writes
>       arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES switches
>       arm64: kpkeys: Enable kpkeys_hardened_pgtables support
>       mm: Add basic tests for kpkeys_hardened_pgtables
>
> Yeoreum Yun (1):
>       arm64: Initialize POR_EL1 register on cpu_resume()
>
>  arch/arm64/Kconfig                        |   2 +
>  arch/arm64/include/asm/cpufeature.h       |  12 ++
>  arch/arm64/include/asm/kpkeys.h           |  76 ++++++++++++
>  arch/arm64/include/asm/pgtable-prot.h     |  16 +--
>  arch/arm64/include/asm/pgtable.h          |  66 +++++++++-
>  arch/arm64/include/asm/por.h              |  11 ++
>  arch/arm64/include/asm/processor.h        |   2 +
>  arch/arm64/include/asm/set_memory.h       |   4 +
>  arch/arm64/kernel/cpufeature.c            |   5 +-
>  arch/arm64/kernel/process.c               |   9 ++
>  arch/arm64/kernel/sleep.S                 |  12 ++
>  arch/arm64/mm/fault.c                     |   2 +
>  arch/arm64/mm/init.c                      |   1 +
>  arch/arm64/mm/mmu.c                       |  48 +++++---
>  arch/arm64/mm/pageattr.c                  |  29 ++++-
>  include/asm-generic/kpkeys.h              |  21 ++++
>  include/linux/kpkeys.h                    | 177 ++++++++++++++++++++++++++
>  include/linux/memblock.h                  |  11 ++
>  include/linux/mm.h                        |  14 ++-
>  include/linux/set_memory.h                |   7 ++
>  mm/Kconfig                                |   5 +
>  mm/Makefile                               |   2 +
>  mm/kpkeys_hardened_pgtables.c             | 180 +++++++++++++++++++++++++++
>  mm/memblock.c                             |  11 --
>  mm/sparse-vmemmap.c                       |  29 +++--
>  mm/tests/kpkeys_hardened_pgtables_kunit.c | 198 ++++++++++++++++++++++++++++++
>  security/Kconfig.hardening                |  24 ++++
>  27 files changed, 923 insertions(+), 51 deletions(-)

Sashiko has found quite a few issues, some of which are potentially
concerning. I'll address them in RFC v8 - no need to point me to them
until then.

- Kevin


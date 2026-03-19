Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2232109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1634A6B0543; Thu, 19 Mar 2026 12:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDCE6B0544; Thu, 19 Mar 2026 12:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8056B0545; Thu, 19 Mar 2026 12:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D84986B0543
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:18:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 922DA1A062C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:18:44 +0000 (UTC)
X-FDA: 84563320968.13.EA6B802
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CEA43100014
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:18:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SAhj5GuC;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773937123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5KWTiJCMcaH4JlQWwOeL4gWSd0MErycqbXZQ8+Z8yc=;
	b=TkuQ73TdBAg05GGBdJPB+BTINQTe8mlvbE3wHVTwqEKshAAE1/oLwDJTuPhqN4CAOpLMIU
	MHn16BjWWf36HiPx7UbWRSnmz1fmSppknA/ulwSiwLp4mMndU1QTRhQ3r/H5+Z9uMZrRZB
	WEgRhKoIgHHlr7OSGrKVsWA4bS7ECvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773937123; a=rsa-sha256;
	cv=none;
	b=zWlZQq34WpoZ2Hdtv+PuD21JKG1TXf5skbqmiy/szw0FyKN0B0XilREGIc9iDwlemAAoSN
	rlk8yxynZxmcrB2NxeCc/g56oEIq2zJpjSqMcHTaRRYtdiV6OM4fDDZ+5cMuE/AsF/PCv0
	hkWhx263GDrDqRgGU5kWtokWzZhboUQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SAhj5GuC;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CB5A44100;
	Thu, 19 Mar 2026 16:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5EDC19424;
	Thu, 19 Mar 2026 16:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773937121;
	bh=+rJxXvh9jbY/cYu63rGxCHb0s8bdU5IuTtrr+qf/8ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SAhj5GuC0PfaoylzOpmZEg5wivkofnQ+GtRsdaeJOUJ4uAmHeX9yWUjJtJAn3it/L
	 DtIYhs/uZLj/VchTSC0AmON6+W7EzTrZwPGqVuCyAhjCjaHPnhkABYQUeqprmOj1i/
	 R/FWq7IVvWU1IGMy9FTlbHxdCNuIq9kR2X6GzLnLDJQbozNo/mkx2YeXRGXNiMY0o7
	 vQpts1+55w++E8C9ighzin4xwksBwu0yd2u4NfBf4vlh8psPZ69uaMIHcyWDj4a0OE
	 UwiaTPNnXiiVy+7V9ISLDkx2gH43hmidRMy6gz3GsbPkAVEku6PbjeRjw4rot/k9lf
	 Rn92JSY6yNwyg==
Date: Thu, 19 Mar 2026 18:18:22 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
Message-ID: <abwhzkhM9Bk9xPIf@kernel.org>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-1-42270124966f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319-config_migration-v1-1-42270124966f@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CEA43100014
X-Stat-Signature: zh19at8nix9qdh77g6cfqb7k58abapcm
X-Rspam-User: 
X-HE-Tag: 1773937122-457209
X-HE-Meta: U2FsdGVkX18az9C9LTtuQsvjI6LpQDYcPw7dO3gs1Y6BLY8YzoIIoidA9a5Z3/3oUnlwR+6fozKDUAa4UlqjqrgYNSImzoVyJgtO8CCASozQnfFbTAtwKKkVRGn4R3mblnb7ZwgldOSghv622G7iXyFdDhP62YCJnzzCCUJL+X/eX/u4JEfvkQKepzhhDtO+8GYZuBQMGML1T0YS8qLdFkLpr3Qfxndfjcl9Y7XvPzie608hwkWLhtgHyb/yvco+3RFZtz/S3bUdYSVztomSXRv32o6g26lMdXXR4EXY5pDubWcaDerAsBzbAC8eE10VcA2aV0XjrLF2t7NU/sAeo2OU4h4ZL/Pl53y4DAsedFo3zFRyedS8V9R6z9x9TvWt1BW77ROa86gxl3C6IrxgNLTLYdPhqZ7z2zUwLJpGsarSXUetP2g1iAgJ1udnUvWJ7w2LJlEl8rlFLUdrZDH7GTSr/2woqhZJO037MIG4PbBPrVOpxwLRcygzDrrG8fqiWaxgyubyBcn0vzrFgzQgqAO/vWym2k1QkdNSovCygaZ6yPeeCxkM1Z5Cm8lo+eswF23X6wQHV45tm+baIlygxuK1LvmXPuNbnu+4F2dYjEKFkOBfDVi/RnlivaZOGIoCmSy1a9CpLL1uqUMcH5LyU6Dw70r0AyCyioBOIy+Fyg13Gk1JV3uN0xiqhd0IBNRCpdcvy9ZDSj3QLX1Zy4tfHXEzkPf5ynd7drLzPyueSOKuLI4EDIzIDm4jDrJI9xXa02r8PbQvqufk7HqQDbJZx7wHBE2+tkhVRCcLeSfa9KDHQgyGndWSR8zaELZH1Lfm9xJ0jRLdu8TVwlGXKYBGUwkcnfw+ELUQkHQJ7/937ivErYGlqFDEamcJZBhy7TpdN22jIjCasiTbQEjGo9Rz9n3QdzD3o0kC13xmVAFxa8QvpL/xUns7p77ysAEg7KuAycnGwnKkGxXFO7GUb4O
 34dqv6BY
 fVxCCn5muYGvoXeDbRPSj/aOEXNjOvwwscu9lWMSOBggRjbYxUHv4V70DUCLxUAqEdPZLYVJ1imNg7FcNqS9ig3yod0AycK+AaYR0XvoN6O8oln6uOfJgMjiNQ2voULGS/XquRkeMfbtH4Ex/E81cJ7jBQwVWa8qiwj/btJmACTVMqbkp7Ysr93hrC4PN3SFm4HwYmiTlo0m/gd5a0H8yIYwxB2DLw0+TqYIiBYZT8F6it+t13+/jZWfcbE5iP27cNfZUTqjIHt0zgSgyIj9/PMEYIjqb4+h41+7URntAgoAOIj244MjnbWk8BeYaBxnSzT6qx1AxhxM5lKr88WNQhg30kVPE2XSlNK6myzbVCcVns5d6GOi5Tfpt36jrTt/2xgpoEeuJ2VQuA3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:19:40AM +0100, David Hildenbrand (Arm) wrote:
> All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
> select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG. So we can just remove
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.
> 
> For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
> and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
> CONFIG_CMA and CONFIG_COMPACTION already do).
> 
> We'll clean up CONFIG_MIGRATION next.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/arm64/Kconfig     | 1 -
>  arch/loongarch/Kconfig | 1 -
>  arch/powerpc/Kconfig   | 1 -
>  arch/riscv/Kconfig     | 1 -
>  arch/s390/Kconfig      | 1 -
>  arch/x86/Kconfig       | 1 -
>  mm/Kconfig             | 9 +++------
>  7 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index edc927d9e85a..d01800962d84 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -85,7 +85,6 @@ config S390
>  	select ARCH_32BIT_USTAT_F_TINODE
>  	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
>  	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM

Not really related, but s390 does not have anything but SPARSEMEM_VMEMMAP.

> -	select ARCH_ENABLE_MEMORY_HOTREMOVE
>  	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
>  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>  	select ARCH_HAS_CC_CAN_LINK

-- 
Sincerely yours,
Mike.


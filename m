Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A2460A5BCD
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gT8uquAn
Received: by kanga.kvack.org (Postfix)
	id 651D56B05B2; Sun,  1 Nov 2026 17:16:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629126B05B3; Sun,  1 Nov 2026 17:16:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5662C6B05B4; Sun,  1 Nov 2026 17:16:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5756B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92EE5A82A9
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:00 +0000 (UTC)
X-FDA: 85387958880.18.D159E21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1293A0003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:15:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gT8uquAn;
	spf=pass (imf15.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793571359;
	b=CBElliDT0i3tyoEhDWROPKc3JyoTowo2T6v5Koa9WrSo908ET5gN428aXobhEXGhJT7Dbl
	4gCLH7KqWvrPslHDHkIanvblhOKWpYvtOJTTkNJFw7DuFF591yULSmQrpKfUTtQtC6eUux
	KqWk6a3vhFeuMhlvmfpTUUaZBlNQsaY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gT8uquAn;
	spf=pass (imf15.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793571359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22yhHEiHUWVm81OxkB+6UNZ5/HC7Jn4HF5eln+k49OY=;
	b=kho/Y6QjWRfHqeXpvHHtK/wzrv6eCEVTZu+6Zqp21KcKgoKmQ5FJ/RR1c/bJy5EtweWMFj
	W44K7qamgRERcujNjTn6z/nbSAnUbCP5Ro2VlGbMQkU+u+EUN3qdyQ3TvSkVnhqaYgUGFw
	ZkC3vw7uELPqRCCMy2dNg/iBZ43v61A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1478344038;
	Sun,  1 Nov 2026 22:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D191F0157D;
	Sun,  1 Nov 2026 22:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571358;
	bh=22yhHEiHUWVm81OxkB+6UNZ5/HC7Jn4HF5eln+k49OY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gT8uquAnEWBRqbOFSUZpNEaxjvUvJ/bDn3nZQUsNJZUlI6Gk8Hbb3XEkhVIaVDRoV
	 2gYU6ml+WaMNKlPmFp30xmMIjuvfyf8SlD8YdPaaBgTyNJmHvk9bFXZ1fiH4aHx/Zk
	 edGwaci/wyJ0nCQhsH9YKkutM0kU8KLugwOCbc/N+SxR6OEDg23CaFG3hwoGs2NiCA
	 Kbij8WbBXvF7uQxa8xbqi0+xePd+KJBP0eQnINMffjV7Gf5NvA1MsereH7UBTMliqO
	 5rcpUaXdFoKO8f5lPDIkkfGcDqtMLaxl2k5QhPhvXyRLajFq6WKmv5GsciX18v/q8M
	 Bz9guAmO027gQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D5B538003B8;
	Sun,  1 Nov 2026 22:15:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 00/12] mm: make userland page table freeing RCU-safe
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357135604.2624073.12750471724213497880.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:15:56 +0000
References: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
In-Reply-To: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
To: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, guoren@kernel.org, bcain@kernel.org,
 geert@linux-m68k.org, dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 jonas@southpole.se, stefan.kristiansson@saunalahti.fi, shorne@gmail.com,
 dalias@libc.org, glaubitz@physik.fu-berlin.de, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux@armlinux.org.uk, vgupta@kernel.org, monstr@monstr.eu, chris@zankel.net,
 jcmvbkbc@gmail.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, davem@davemloft.net,
 andreas@gaisler.com, richard.henderson@linaro.org, mattst88@gmail.com,
 linmag7@gmail.com, catalin.marinas@arm.com, mark.rutland@arm.com,
 chenhuacai@kernel.org, kernel@xen0n.name, tsbogend@alpha.franken.de,
 James.Bottomley@HansenPartnership.com, deller@gmx.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, chleroy@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 richard@nod.at, anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, arnd@arndb.de, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jgg@ziepe.ca,
 jhubbard@nvidia.com, peterx@redhat.com, ysato@users.sourceforge.jp,
 shakeel.butt@linux.dev, corbet@lwn.net, rdunlap@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org,
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, hughd@google.com, qi.zheng@linux.dev,
 linux-doc@vger.kernel.org, gerg@linux-m68k.org
X-Rspam-User: 
X-Rspamd-Queue-Id: D1293A0003
X-Stat-Signature: gdft1bgdwo54exxydn3u57yt3rpz1tog
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793571358-231419
X-HE-Meta: U2FsdGVkX18vBkahnu/PwPEl7yKYiQl4EXNOQVQXDxFXxXU5Gnkqd5RRIvozLcO8Ff55p09Co/QbjJT89wSnw1GKjLMIh6jMlqC6HmmkPtdliydzbRI4vWpJFfM4BrplFJ7o5HA1MPbbXALVtFItQokoAkTyqUMPjtCJYYoXiJDgmD1QEx8ffFFy0BiaMYKSGTgQesqHb2TYTC0GNNnlPD9GQHN2K6sax+frva/PVsQ407LlW1UMuTuuBg5TALkYkmU2OkLlHvW5ygkSQorBNc2bJRMz0WJ8W4H4mCMm0RaxnSiXmw7+w3oG7yK+shvmrcp9lZZSAHzzJTwssog00HhSF8IuzoOTMJpVv3npLS1ULcE2uJGSl/KSYFssipK3SlKpIZt2UDhs+ZuCeTFOoVbyHZ7wrOQrvMac/hi97l9akfE3V0MpuIZOtHv7znimNg7/Ah2FvZ86J1A24rqvgp4tQbuSsAERdfavjv0UptkqOQdlvBlb0G39bhi0kfZ/15Z5ekhXyiRi49xisSA8s4+Bxj/1HUtadfEZrMHqiqTVux1BUSjGctqaQgT/cc0yIss8uvsYu5NBg9ZJJDlegysGDdGAy4Y/Ys46JqigN5rUrya2a4SHYHIkcJotpQe1dE0VbcFHISGYIA08iR6EAjszAAEogFP5XjUv1t0oCGlXqXRt6BdJj6GD4eOjxtV4m2lPlBEgpTdIir0jD1ivxHZ8kkAR/qJoZF1reV4GH4XDQZKP/jUjD0lRIpDI5DcsXZNeug9zeeXbuw2rM9my4SjRmSRflxAkF8o/vAVpO5Rybmv3hOmHfg4kNvhwotSRqy0svb6FD1QurV9tPCCh2M8/N1he4d/KQsc492Mbda8Qi2I6gG/WRrN7oXvNlrZL+LjXj6sdYA1fgLnnPbglb1RJtgNjPJ3XaqLIKr/0BvWVifiiW9y+MlR4Qvdu/e5ERd1M0jirgQIFKv5jTxX
 mGyNdb+s
 npyzDMOA7gGSHLa86Em5QdXIQYIJHYyXt0dK0LORIDiwNPmT12UIqOvc3Vjtr3KOdUm/nDrNgMST6NxSMsUcer8TrZf3RqVQBXahQg3ZJ5bUHK+wZyW3ZeR2nJV3ASRGOg5vgymeVkuw6/WPMIxZw0NqWGsVVHcb89Bv93A8azd+jGJtoJfbJR54D/D6UaEth/FauldCXSeWLM8zvxhzn8vfAqsFm1c3+Vs9B/JgoE4MyfZn27i/BSqZLKLwrufB4Zc1jUVDhTFczfQFYrziA/XV4tijWqn7qLQc+vBI6/SkFRggXi96/9vlvGACceN4y7T/xerwUAfCh1Gv+BgR5MjHzdvPtKk7On+J71xLIdJI83u0mJVoKamWhnrQuzpcsNj1DBb6045MmcBWpb7bVFAccsOxLqNeZqnOJv8o0IBl9aPu8jHKfJApk5DjEtoeyqbYivEf6HRGPECcXilMU56FcXh7+/qxDxPh9dIRN9upEIgbjHT53tpRHDVCWokQYWndk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 25 Sep 2026 21:09:35 +0100 you wrote:
> The majority of architectures in the kernel defer page table freeing until
> an RCU grace period has elapsed, this series converts all remaining
> architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> altogether.
> 
> This is important because it enables safe lockless page table walking under
> RCU alone.
> 
> [...]

Here is the summary with links:
  - [v5,01/12] mm/khugepaged: deposit a newly allocated page table on collapse
    https://git.kernel.org/riscv/c/eb823057e092
  - [v5,02/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for most 2-level architectures
    https://git.kernel.org/riscv/c/d22254fd57f0
  - [v5,03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU riscv
    https://git.kernel.org/riscv/c/5ae75414416f
  - [v5,04/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
    https://git.kernel.org/riscv/c/8e645d98fb78
  - [v5,05/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for arc, microblaze, xtensa
    https://git.kernel.org/riscv/c/799bd3c4be5f
  - [v5,06/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
    https://git.kernel.org/riscv/c/461a24a81215
  - [v5,07/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-coldfire
    https://git.kernel.org/riscv/c/ccdaaf591664
  - [v5,08/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
    https://git.kernel.org/riscv/c/a72df945113a
  - [v5,09/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-motorola
    https://git.kernel.org/riscv/c/0f5cbeebe00e
  - [v5,10/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
    https://git.kernel.org/riscv/c/35dd856770f3
  - [v5,11/12] mm: userland pgtable freeing is RCU-safe now, remove leftover bits
    https://git.kernel.org/riscv/c/35e340a47888
  - [v5,12/12] mm: change the contract for free_pgtables(), update docs
    https://git.kernel.org/riscv/c/a5c0a39d0e57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




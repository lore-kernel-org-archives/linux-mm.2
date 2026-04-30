Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8B0CD13D9
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D376B0093; Wed, 29 Apr 2026 23:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF736B0095; Wed, 29 Apr 2026 23:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F806B0096; Wed, 29 Apr 2026 23:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 900446B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 350011B968A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:03 +0000 (UTC)
X-FDA: 84713783406.15.E113AAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6732E4000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBlnnBYu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6i/n2OIWbssFgspqU3XsUAyhEOujOux9IGEgU9tR/9A=;
	b=VsLDWgipvBNkdNqLnk01uwnIV+zdAr99B6+wUSVrYzsS/xbL2G+4fLTEYrM7urbmgmwx8Y
	zrcRTKDPuJUSJmCaMLCEFBE9JavoAv/YZxRWgiyug8k3MEa7MUB3U/25tzR8FgxrRDQ1Cf
	lTYh/WFAkeQ40V5pheXL3gr5zkekhUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519561; a=rsa-sha256;
	cv=none;
	b=WSW4I/Ku6Ahg/UWXo961RuEygxAQC9oaGq+iCBXADMVrUk17o2pXiahnAa4wbsOTI58+yx
	y3EyxfDvJSeXDkRQQSrDyX1M1+IPZ05OhDBUvAa2YTlKwWQVtkrsqWdCGR+bADOwC0t0hm
	ZB9BdC2oXNtjZ1IJtmEdM5+CJ9R3oSI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBlnnBYu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 68490445A1;
	Thu, 30 Apr 2026 03:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EC8C2BCB8;
	Thu, 30 Apr 2026 03:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519560;
	bh=FqQgY6wUDRilF2lGF6AUp3SKA6W84Y4EVzMNWrmj1MA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dBlnnBYufwWMR1nExtz6aedB6xaU7P3x/0oqMjOtTdGUGUeJhPpncFc8sQY3bIxea
	 XS/p9LPRIkyQYR5a1xzoJhZL0FGP3XnLB7ZOHUY+pjLBscTvEbhOx3347ogxt9Bg+O
	 C2d21DtveABggnbmyzR85YZv8OmWR7FrM7RHm1MgP1DRBG3Ws+XDi1lSb5QcoQRFQy
	 HggmLnjnOtaQyPsKj5Of94mOctLczazEPyKkSBrZTM0g4YEqgl8wDGz5u4d4xH7e3X
	 tNGIsp/yArFBiyVYOS04DFlQB67Ot1uXHMbEsSeRTpDG+n3WdwGMNxgjPm1MfRZuFz
	 N/I5dqZRvaPOw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CF413809A07;
	Thu, 30 Apr 2026 03:25:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 00/15] mm: memory hot(un)plug and SPARSEMEM cleanups
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751951529.2274119.16732782086222000591.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:15 +0000
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: David Hildenbrand (Arm) <david@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, sidhartha.kumar@oracle.com,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: 6732E4000A
X-Rspamd-Server: rspam04
X-Stat-Signature: fe3uotkyyuqm8qoinxp5ew669e89jgno
X-HE-Tag: 1777519561-141702
X-HE-Meta: U2FsdGVkX18QcmS9mYOLWrv9xfVitLSHXSqeYQq/fpdXG77Out6kQ/dO6foT9N8y8h7No5FHREYtw/hlRvumpL6Lwklqwsd2nVblRFbI8d6zxA80KN/okGdzjHJ0HXjcJX4mP6d0KhP2ymnUw2KISB1e86GuOdHRD16kJiTX4MaVJgJPWAUJpuHHcdBiX+Gw3BHyQynZAj03RBGUpZzkp9Ea13iCgTNRr4olIo6IY5jpUDJitFaL7QkbXuf2QcjDTOtnjzfASxdHU/vKwxxIvwg6GHGCz4hAmjxg+dq9fX+AUgiDluibsAWavUVnPMufO40u6BYYB+IsAu3OF5ap8/tXyuNfxwJ4Aww5HciSibUIRyWo268CQ5l+iWek0BKkEJgtFnBjLKY/vdRD+dkmlGT+BxTR89E11IbXhKCTAdo5dy9p1BKbOYEZD7sR1kaQnL1imfPurUqU14e14qD1jV9rQDNeEa+L44+dD3HEowzYCSdiiCagcfvQdxj9C8b0E3Hao5hs1mWM5OJUz2iGRyYm11D3pYkRiYvteTMcTsCuq1l5Yjlot/rK4AssW/7O5Td2RsBfvX8yVLy8qY1FQVXgsGlEh5WunvIbGCQBUh+pJzW4Z4ZZRTa+MP+tIISBMnAAQDLLIT2b0Y/k+nPb1V2T6m6BcmS17w7FZl/V1uPQHGhIdAhYQTW1eXYFLlqd3f4i7BwMjQcko2qiDA2wzOOQd2onKfTqBowVdBqeSVx5liAeMxqEHnksVL3YvjrWr1smVJPMc6bsfBPw5xW17o/pt9l3Rc+EdrnCtY8jq/HtpnWA2q54bYxP3aUMB0+d/gn9Jk9Gc4NyyxPKryiUcAUrCrSaywf06N1aTVQZb2hkGTE+gxN2Vu/yOai1+XPxB9y65EUDCiF8p2+gC/bKrsfnmjv10tf8MJHsfA6lvYljfDlbf9vxgtz0mQduDYSQe0P/1WCqmuwFRJ1aHJ7
 PAbH8kz2
 Oxi4tOr3MEIFCfmgSoEZU+5DdnSE6QCSUJ3KWWY7Ha02a40zdZb7gpPZoT0LvCPkIB3Q/vOX/SBce5Lg349Rq3rRDSIXe812hpjXg9VtQbMj4l+446YWbkAfj+kumIks2Gf4FvPID3A892HrN7LuJAuOST0ywyX9SjstcNHmsVTiNqdqQGXzqemzLo33uRxWg7O192hBfIc7QxFd55d/IVsw1GrSPJVNi4neeVZ5QmwMA3lU+rIGCE8BHtHMeKdQpOJ6Hl31Jf390/t3hlf1gc1LUajRi7qO27pHAEp8wyOt83eHCdGyJ/NgvUDQSFa9dq0wt9Kmbou61Q3HJxBLzHXhaJnXRpbvrnQaGa+L4hEyw+kGrTazT7xI0CLGMOvhkav2l91V7hgBVHfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 20 Mar 2026 23:13:32 +0100 you wrote:
> Some cleanups around memory hot(un)plug and SPARSEMEM. In essence,
> we can limit CONFIG_MEMORY_HOTPLUG to CONFIG_SPARSEMEM_VMEMMAP,
> remove some dead code, and move all the hotplug bits over to
> mm/sparse-vmemmap.c.
> 
> Some further/related cleanups around other unnecessary code
> (memory hole handling and complicated usemap allocation).
> 
> [...]

Here is the summary with links:
  - [v2,01/15] mm/memory_hotplug: fix possible race in scan_movable_pages()
    https://git.kernel.org/riscv/c/89e69c7d187e
  - [v2,02/15] mm/memory_hotplug: remove for_each_valid_pfn() usage
    https://git.kernel.org/riscv/c/9d80de66a046
  - [v2,03/15] mm/sparse: remove WARN_ONs from (online|offline)_mem_sections()
    https://git.kernel.org/riscv/c/e66383b6746d
  - [v2,04/15] mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
    https://git.kernel.org/riscv/c/fb3c3f5d27ef
  - [v2,05/15] mm/memory_hotplug: simplify check_pfn_span()
    https://git.kernel.org/riscv/c/62257a5fb987
  - [v2,06/15] mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG
    https://git.kernel.org/riscv/c/119c31caa59e
  - [v2,07/15] mm/bootmem_info: remove handling for !CONFIG_SPARSEMEM_VMEMMAP
    https://git.kernel.org/riscv/c/41293414433a
  - [v2,08/15] mm/bootmem_info: avoid using sparse_decode_mem_map()
    https://git.kernel.org/riscv/c/7f8e592bb327
  - [v2,09/15] mm/sparse: remove sparse_decode_mem_map()
    https://git.kernel.org/riscv/c/22688ade3b54
  - [v2,10/15] mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific usemap allocation handling
    https://git.kernel.org/riscv/c/dac89b150bdb
  - [v2,11/15] mm: prepare to move subsection_map_init() to mm/sparse-vmemmap.c
    https://git.kernel.org/riscv/c/fead6dcff83b
  - [v2,12/15] mm/sparse: drop set_section_nid() from sparse_add_section()
    https://git.kernel.org/riscv/c/b551ed94d959
  - [v2,13/15] mm/sparse: move sparse_init_one_section() to internal.h
    (no matching commit)
  - [v2,14/15] mm/sparse: move __section_mark_present() to internal.h
    https://git.kernel.org/riscv/c/08e5f77c3720
  - [v2,15/15] mm/sparse: move memory hotplug bits to sparse-vmemmap.c
    https://git.kernel.org/riscv/c/738de20c4faf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




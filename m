Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC40BFF8864
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F26F6B00B1; Wed, 29 Apr 2026 23:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA4B6B00B3; Wed, 29 Apr 2026 23:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8B36B00B4; Wed, 29 Apr 2026 23:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4E26B00B1
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B677516022E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:39 +0000 (UTC)
X-FDA: 84713784918.27.2E27A0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B00D120005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=geUpuuDM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsC3bM2jLmvNPIco9ZviAWnAnaBbzQh4CXwepo8w+vw=;
	b=dxjDEOZMcGfGyL0MkZB4kCY7Cy+ZiPwz52glzfp69SRA9LIntlW4pzmUNkTGg8199giu+i
	7hx3+NHl0zmAAeNgXTBUNC1gJF7m75PeZ2Hf4FsChcNRJyRbC+rRO+I9sgZ77Lw/lqJCKP
	GrzQaAL4Ha3ksxL4PYuM60oeXx1ya7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519598; a=rsa-sha256;
	cv=none;
	b=r4XC6+g7MwBwaQjEdAvI8c+FBjIJeCrDygRajuE/if2G7ufG6IfnKYqDlOgPl02ODNcSc7
	iU0N4+bvWpFS36HUXUVutQ2mu7A2ynITP6xfjSEGe7+c8NRhshvEXFpmOJ8SwrgCCS++OB
	MBxCjSkEe7Spsj1hTxorrIy5CQjtMG8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=geUpuuDM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BAAE4458A;
	Thu, 30 Apr 2026 03:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF135C2BCB9;
	Thu, 30 Apr 2026 03:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519596;
	bh=bc+dg0Bc8LDaQ9OEb5RjsesIcFKeDCO/6xovARLSG30=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=geUpuuDMCyhCp6bEdcbfN0LxnZCUCG0dgvu3qA/x+vL21nkrLzZ8fbVpg72WGZE28
	 GW58cY5htqwvpdHnIBBxusd/QaNcLFa+lj440eecLAww3/Tl672LYNkzLLEjf/tTSC
	 BpJ/B2ryHel/66TKXqJYyWj2hlvJjZgUYAyyblpCJqEkiH+W7IzZtgCsm05BvXOqTC
	 7UXOUp/0g8nuPuEp/UKXTadmyETa8KxH8Ey5ukE8RHBtYyFcXm2Y2LcaUH2nkGobnw
	 UofVwlyT6LtPYOcYzQrW4VSyZ9ncKX38Ij7OlcUNxKwM+79KdZnCJOFbQp/inSmfSd
	 OIy8h9cqLZpvQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FDD13809A07;
	Thu, 30 Apr 2026 03:25:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 12/18] mm/hugetlb: Remove fake head pages
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751955179.2274119.2481489263486900849.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:51 +0000
References: <20260227193030.272078-12-kas@kernel.org>
In-Reply-To: <20260227193030.272078-12-kas@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0B00D120005
X-Stat-Signature: 6myq1yju3dm3q1fsq3377qsc4xpgf9oc
X-Rspam-User: 
X-HE-Tag: 1777519597-212170
X-HE-Meta: U2FsdGVkX182BMrj54qNJMCYShKtteiVbU5CBz6WQC7RpTJQJXaHKMKQLnsavSME1IEMuCXuuQdQ1qAj24JbJ/DHKhyNDhZ0v+4KdnxVfJHHsNHgl46LUEvG8s8JOW0qLHrGn78/Y7F3IHuoeBRFHVBHu/gzkcBacgTAH168EYmfsCTxNctOX1ow8Ytol7fjqQ+B0zckeCGM9ksK1O68DxEAgeoTF8bTvw8ZGok8U+4Qj8pQK+kanA1SdnR40MyBWA+A+xYLTaZ/lNMRuWZk0X5mIYhLQ0n/SRObTxoA5TdsvZGwbGzGhcLZ1lKV9kqn9dkRCGlaF0tZiqx6R59ZeGBrTs4nV7t5wnB8rmtgLYwbPrvRtcEjBWhvLE//a343JXhmM7TFABTarhEOKsIWWUD9p2E4XuC8ZzM2r9nLDoOubZmdC0hMsH7m8Blq+2G5eNGKw3ryCM5jWljm2hbZPym7zIVtg5WBbsgOOK1FheFzmm7YvJCceiYRAuZgz33n/n37C4DPqhvOUOgdoT08W384w1Fd5LiNO5Hp4sZBgoUvri2SW/nmdVubxubkm2JzQSNAGrF25G2ag4KZ4M9HUGt1/6UL++xWRjYjhC9dSI0plF+a8pc8VGwh8Qu4xiD/LcoI4Rm6b0HYnNjqdivb2epWHAlEdtRaefTnPfDRiUxcpixYXhyD03Bi0KQ9ZgmwDy49FFOk4MlPXD5gZ8Ru/Wj55erWsYgIP0L8NKyC/xoZZTl32ASQD4BStd5fQzEkodCvSEDtHRPImIilDInViQgY/ZbjlMv3Uw2V4S8igabItZWVTlMtM3LKfAjrn9CCr4K5t1AgwbMTe6tc2u+nDTnBy7FF6Po/SFO7jK/5FwJwScb5jVaXTjzXv6fd6HoxZLD/bcUim49PzT5Mgg9T1j0kjOvBKRIy+wUyI6yOxiMauDoqBEdk32smNivCK/S7lXRO6smRdhBZLTXGSS0
 A92q9ssO
 IkveJZOjnjlX+XQn6dfQCBUjqf1L559bwLRs7a2YPHgA3oimyX5yTI1644QYrEEsKWVliea7YhS4LnwiDu6yICWIsGYGiHgBftesoNujW6jz9hxu8N0FzUMqAmjsgx0NVNm+I9QIBgLUWHqeFWHdF8qG8khTj/riserS+Bbi4Q6jLfwpiWwl424BwnjdJWWtlvVa40RQ8SAdoWg1lMGspX8Ua+GS6oBaFZg3zVM2Uez5CaD7Lx52ilGtcFz8+KlorrrMYHoqWdACX0oR8aHaadeTQE5hDC0QP5P+3GWsID/CeW0LaBWNywp+QJJxSynzojgStpXOAqwCtUjYN9srza9Juu2j//OXwxSbDU/Gj+RyBOc0FtOG4q99LlJMPpGt5hApdhIyhXb9+1NGYqnzqVWzGqh214uwCtyiuMz0CHZP0LWo8MT8ilGAd6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:13 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> vmemmap pages for huge pages and remapping the freed range to a single
> page containing the struct page metadata.
> 
> With the new mask-based compound_info encoding (for power-of-2 struct
> page sizes), all tail pages of the same order are now identical
> regardless of which compound page they belong to. This means the tail
> pages can be truly shared without fake heads.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,12/18] mm/hugetlb: Remove fake head pages
    https://git.kernel.org/riscv/c/622026e87c40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html




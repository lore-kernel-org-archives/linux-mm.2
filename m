Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6030A606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LkGb8lMG
Received: by kanga.kvack.org (Postfix)
	id 4E71B6B0680; Thu, 19 Nov 2026 12:00:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF126B0681; Thu, 19 Nov 2026 12:00:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5F76B06C1; Thu, 19 Nov 2026 12:00:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B18E6B0680
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:00:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB4CB140B56
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:00:54 +0000 (UTC)
X-FDA: 85452483228.17.E8EBDDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A6634C0015
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:00:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LkGb8lMG;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795107652;
	b=r99hIHKtVL78rfiAnIXG1xEzK+v8D/MGyKIVrMSakNJGGNLpAQKw8qzpTCswPun0n79tcN
	7Duyt/Bo4x/XK+8Zhd823JtqgYHnLwa0ZdxGMMjbqG2CjU9M8kVcDeaPG3ODJ3fI6B2jjw
	XO1Ihr2qpmTBs9r9MBlFth/O9wzvY6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAGuNfK4PGkEBhiPgllG38LiVsfLG3yw/JzSv5KJ1FY=;
	b=3D3cGiswDEMRuYd7AjM0BHJocddULL5N8Zt3mt8pNVIJCcWsKRRiwZYC5uWOiP1Sj/M+EE
	hvOZNiYAz6VxQKP4Jax6VLNP2HEvKEP/QAxO6i69e/QaOklhwm4IF6U4tQI+96soiwf/NV
	NDqVunrqbWjxr3VJwrZBXMW4WDeWtDM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LkGb8lMG;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 287836185E;
	Thu, 19 Nov 2026 17:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649FE1F000C4;
	Thu, 19 Nov 2026 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795107651;
	bh=ZAGuNfK4PGkEBhiPgllG38LiVsfLG3yw/JzSv5KJ1FY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LkGb8lMGrcmpPfcxmFdF4FwE6VN7ukOvtg016rCSOGbcS5HWRH58fh0XjLJyeXm30
	 tOBPIIZy6TPV3JEmcklLtPc/oax9XC0iKigQYdzgT6GaAy6I5XpCe3MVuEH6HhSjG8
	 kc0mE9oC7MNHp1oO0lIASjx9P4W2ZCLOwMgaT1CQ=
Date: Thu, 19 Nov 2026 09:00:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Joao Martins <joao.m.martins@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Sashiko <sashiko-bot@kernel.org>, Jiaqi Yan <jiaqiyan@google.com>,
 "Jose A . Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm/hugetlb_vmemmap: Fix HVO races and deadlock
Message-Id: <20261119090050.6858fd2871d2756c6d3c809a@linux-foundation.org>
In-Reply-To: <20261114112523.75208-1-songmuchun@bytedance.com>
References: <20261114112523.75208-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A6634C0015
X-Rspam-User:
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8u4e6ukf3r79ys4ajujdibbsdtp56t33
X-Rspamd-Server: rspam10
X-HE-Tag: 1795107652-20914
X-HE-Meta: U2FsdGVkX184AlwoVG7hvazg+Jyb4t7Hr5o18o7JbuB8TjHOhEmjhfKoo/+bbu1kaIA4ICN4wzdq9JqkykVIFSsOKquxE2QJH+SOqQpZQCatR4VPAP/uz1aSpOk0WKEWw669npT3l6USekOjnwZ7jW5D/Vcqho92fU/saQ8aGZQuZSZE/JloNqXawWFpoAItpHA9WMlaKQEbFJHKk0h24LWY/xNDuDP/WQRpxi8sq3x4g0eFblB2Dqb9A7N/bVNtiz8mV60xGOp/05U33B8CiYVSecU+VCmTnovVMvCisO8rD3uFDR790ItvW92Bk9ZmKYz5HZXz9DEWhnAwd77xWZ7cByDBqm6TYT9VCrVJTrwJCOmgxu0WGHWQZXfO9mTHm1qT+d03WExt21ueBTttlgk1AzPCEIdUOF2KN647z6ByDoHEm8cTUyHs+z1UmeZ3SX1php/u3+YzW3wgJtcJs5K9/1zavmX0MuZ6CiFcWlFN/F3uMDV7dnBtNNJywOvgMg4SRZl1JOWOamVMVU6ArYchnLk4TYY8Q8ywWimKGZCjM2tFTBHoHJO0rryHRs1d3OPoLcvEwsPBcvn+uwPeApKUqK7vmX4VNaDLrsdR/5r+IIKoMkIC/LyOvS5K9LCRnorDgR8O/2k20zV4UigW2GvKhD4QOaB1chXOsxDiOhq1pAsmjNHjkPVVCsEoMyeITIW+EUrKzzSYkeWpM3FppIrOTkgzTr9essszYhnGrRjuESAQrJPWg9BtMyHqQsGZsm6TGtMtiyrAHGetIgRP7YDqbGNrgVFSP6ob5VbaCGhHf4rLvvox87kyVbe7jEaIzJ7qsmlvYixtjZqigzAnbVq7WLW/j47A6zHN4MaqtbpxlxRT93sFCPOmfa5vVYl2/kFAwIh4y5EX5aet83WLCyF0q62a4wW7TvSNBU+4XdsB5nYmC5uiA4ngW4iFH9e9Md7r1bFsUkRkdN57qOA
 f4JKY7ch
 9TRmrBzy6ze1FBP81bmwUzVo3IfmQ3kl5fZRNkpLMMII/3/0if7TYXRH0VbuuTNbXjs6+rNGiAcmT8FFviQYuFUpVZtS3ovQU8lAMGE1p0WuQ/qpcRxa0rVNPh6mhbsjnQ+3zM318Vc+wzVeodEWXgT3n07EiZYqwCHHFks3+81/q5bT9alwP1jAaLpvmCojolJRD96IPZYmRwEjge5OwiJMgggHA0Gc8B/LGywy0oVOG20aAA4Fmp70zsn/XtHfaMIY1rmjcV07AAOlEe9nM65NkOjhnH+eASrbXkSvP5DSX+0m+Rw3BhN7KDalve7qdqoeR32tXXhJAIx2HzwiOPWTvA0nyhG5R1yRKNDjFPLTcVbmfj3Ku86grrSTwIbEB/wDGPuzPc8K4kNWGVrgsqzHG+V+9o9Pw91pJmXMBMnPiitaWq1g5WrLyXz+s2ON+7fw/JYmUaqCqGZXgP3WzSPb4a8+iocvGn4xO4lF0gN9k4tUlw0Ec5Ah1hQoeZck8T8Kpe6WyLCR7KJ+T5e5WVE3atubZNKGffSuGiJJQ+/zs3nDtoFzHfPKJsCN7BAk5fFX4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 14 Nov 2026 19:25:20 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This series fixes three HVO issues reported by Sashiko.
> 
> The first patch serializes HWPoison updates and removal against HVO
> remapping so raw_hwp_page state cannot be lost or freed while a
> replacement vmemmap head page is being installed. The second patch uses
> an HVO-private rwsem to prevent deferred PMD splits from racing with PTE
> remapping before the TLB flush. The last patch switches the vmemmap walk
> to the lockless walker so a PMD split allocation cannot recurse into
> init_mm.mmap_lock through reclaim.
> 

Thanks, tested in a VM.  The series did everything it claimed to do and
the LLM couldn't fid a way to break it.

Tested-by: Andrew Morton <akpm@linux-foundation.org>


: I tested the three patches in x86-64 QEMU guests. A had the series
: removed; B had it applied. Both used the same kernel configuration and
: fresh boots. The main tests used four CPUs, two NUMA nodes, 8 GiB RAM
: and 2 MiB HugeTLB pages. I added the same temporary delays and log
: messages to A and B, guarded by the test processes' current->comm, so
: other processes did not take those delays.
: 
: [1/3] mm/hugetlb_vmemmap: fix HWPoison state races during optimization
: 
: I put a three-second pause immediately after HVO copied the vmemmap
: head, then poisoned a tail page during that pause. On A, the HWPoison
: state was lost and the huge page remained in the free pool; B kept it
: out. Poisoning the last 4 KiB tail page gave the same result. For the
: reverse race, I also paused before the copy to poison the page, then
: unpoisoned it during the post-copy pause. A left stale HWPoison flags
: on the head and tail; B cleared them.
: 
: [2/3] mm/hugetlb_vmemmap: fix PMD split TLB flush race
: 
: I put a three-second pause immediately before the deferred
: flush_tlb_all(), after the split PMDs had been published. During that
: pause, separate processes allocated huge pages in the affected range.
: Temporary log messages recorded the old and new backing PFNs at each
: remap. A changed PTE mappings before the flush; B did not. Four
: simultaneous allocations repeated the early remapping on A across
: both split PMD ranges. I did not observe a processor using a stale
: TLB entry.
: 
: [3/3] mm/hugetlb_vmemmap: fix deadlock during PMD split
: 
: This test used a separate four-CPU, one-node, 4 GiB QEMU guest. An
: emulated QXL device initialized TTM. Because QXL's own pages were
: cached, a small test module used TTM's page-pool interfaces to return
: 512 write-combined pages to its pool. A process held about 2.5 GiB
: of guest memory.
: 
: I created an init_mm.mmap_lock writer before HVO entered the PMD
: split. At the split, I released that writer, paused for 300 ms to let
: it wait on the lock, then called TTM's actual shrinker from the HVO
: task. A reached set_pages_wb() and blocked trying to take
: init_mm.mmap_lock; the huge-page allocation did not finish. On B,
: the writer completed, the shrinker freed the pool pages, and the
: allocation finished. The shrinker call was forced at this point.
: This tests TTM's page-freeing path and the lock order, but does not
: show that ordinary reclaim would select TTM at that instant.


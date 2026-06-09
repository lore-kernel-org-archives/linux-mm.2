Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39FE6CD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0986B0093; Tue,  9 Jun 2026 11:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1BA6B0095; Tue,  9 Jun 2026 11:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA286B0096; Tue,  9 Jun 2026 11:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67FC26B0093
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:54:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 336391A0647
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:54:44 +0000 (UTC)
X-FDA: 84860822088.16.6F19B30
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf05.hostedemail.com (Postfix) with ESMTP id 42140100010
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:54:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781020482;
	b=QPz/wcU3H3gSdWh69aMcX7+p2HB808nSLP7YtkmM61opW5Xl9r1QwdVGD8LIG3Ry5tOUaJ
	yrzP2bVx6FDmDmtCfHgkI8c3E3A7pSnDxWO/HypOdqRR4NHydjUjNvuN/Y+CwUit3TxpfT
	wAAtnGgEQR+W7SB/7FnWzcJLKcCPdDY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781020482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h2xF6Dj7GyPRpT2EfkYWfpIBrdvTlK7OvEdoE1Wqr+Y=;
	b=W3IihxfGGTGHU/9FtGRalLyQJhCW/T/g0BwpPM54a8nQPPkxgAU4Mf9QzlrmKOIJnxC+WN
	K02yODbJZ/yYNUOYq3SsJddrS5JK2QX4/CyxmHkBnd3YDcL8s153f3SCNpIqlfj6zFJXkh
	IVMCiTbKFXzllXwVGDSsp1m3exqYoXw=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 10 Jun 2026 00:54:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 10 Jun 2026 00:54:36 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [RFC 0/4] mm, swap: Enable THP SWAP for PowerPC Book3S64
Message-ID: <aig3PFm9jst8cHxn@yjaykim-PowerEdge-T330>
References: <cover.1781000840.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1781000840.git.ritesh.list@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42140100010
X-Rspam-User: 
X-Stat-Signature: cgsqk6umyu5t3ggwt5kiandtj4pu95fj
X-HE-Tag: 1781020480-588844
X-HE-Meta: U2FsdGVkX19NR3gAUwcZWn84ELDyM4kCzHKJmIesAztQ2jqZ1x891VziP+H9P3u19N6c2GKEZOhEpo70RYfwKVnISGfpZnAguBEs3vYiLPG4K3odAZa7dcxsQol7JECPuiUkub+E8Ai/PuTr4EFGlYglOCf+BbMk08p6b8FEx1onKLh1CAotJ3ZMK6hCgpsxv2K+V0ZoOJNQ3jRg1+DxAFIRwZ1tg7qrTS0Xu+AakKi43QBI+TBrW+TFFkn+FZmNIJ5ONy+51RbgAWuqeK7wkZMxTbFzSb9Q40gWEenwEyvVNeKsW05BWiDXX7ThQa/ha2fgK13XgNeeGGmLGheV5A3g69wofVMOM9f8GSMPSXCAtLDoGa56he+0UiGpGEEc4zH0VRHL0wrU2c5r9Dnaw4AA27PyNmX79cC2OL2M6EDUrzpVHE9UUGc5G/JKmoL5QxaLlCpmZa3zYpSAShaGzeNk4x4Kz1sLdgGP8BXugk6eGOfZLZ8or5ifTx1UfH9TW39ZFqe/77yvc+AtmduQ4yFC6K1AprXNMxxzpF6IHxBe9pT5ps8uxlRChlYchYDx5KGowcoY8I7UWxRuRBdKBvemVtK5g7p4k1yh8wqiUfYL6rNXDwLsRbPHHj017/0wJnoEipGYBNRQp8qxi4MevqynOfmGRshL/BvD3wDfFt74bDC6/opZQJwT5PrHEUR4CZl7H63WoAG2PWiJRGqrW6/K/grYLvFCnI5w7+hQ5mNhJ5xU0MFBGJ3jD7olbxGmAFWl+Rv2SAMJggY8ZvuY/RMabiQ6yQw817+TkAHOEIHyTPLNhW9uvyrzUczF6ePQOqCrv6aaOo4PjH+F0GVdEdk8WLQaLBtBcdn80U/XzzMWeWUV1pXVEcZp9QiANZcRH7/2D8yjSDuq3lX2H0iGqYmrB7q481zPR26FkezuGuR0fBbSwD582uyA6omkEUeQFn+u5pC2GSvtgigVlfh
 1Oi8+MWB
 auz9pqGlYq2oXaDpvK21VJZORSLSJmRi68LoaEnlSBqsC50zm1k6+OomXHFt+3ylnVyouTdwl1YUbhQPjeTzRXi6cAnUIm8wyA9KE90fcr1u3a4OVS24unznyV7eNlsbk1GqqedPH0Ixg5nwt8GqZFO595lf28HY5jzZCcgzucStomy8g8W1CXROr7kbOsLxrHyQYq5LVvnRTGaeKP0YwaKqY83bmHIEYUx/yn7fG31hxPsTMRThEhqAFgnGg7J0Xw4ge+HHhVuIycIvv9iCQdaDaqFPGfBqEZDJonYhyoMFpZfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 06:49:30PM +0530, Ritesh Harjani (IBM) wrote:
> On PowerPC Book3S64, MMU is selected at runtime, so macros like PMD_SHIFT are
> effectively runtime variables in the Book3S64 code. THP swap code uses these
> macros for e.g. to size some of its array data structures based on PMD_ORDER.
> This patch series makes that usage dependent on the runtime variable.
> 
> Sayali did some performance runs of this on Book3S64 with Radix and it gives
> 40-50% performance improvement. We also plan to run it with Hash, will soon
> update the results.
> 
> Note that this patch series is based out of linux-next (next-20260608).
> 
> Ritesh Harjani (IBM) (4):
>   include/linux/swap.h: Remove unused leftovers
>   mm, swap: make SWAPFILE_CLUSTER runtime
>   mm, swap: make SWAP_NR_ORDERS runtime
>   powerpc: Kconfig: Enable THP_SWAP on Book3S64
> 
>  arch/powerpc/platforms/Kconfig.cputype |   1 +
>  include/linux/swap.h                   |  17 +---
>  mm/swap.h                              |   5 +-
>  mm/swap_table.h                        |   6 +-
>  mm/swapfile.c                          | 132 ++++++++++++++++++-------
>  5 files changed, 106 insertions(+), 55 deletions(-)
> 
> --
> 2.39.5
>
Hello!

Instead of making SWAP_NR_ORDERS fully runtime, could we set it to the max
PMD_ORDER possible on PowerPC Book3S64 as a compile-time constant in the
swap.h ifdef block? (My assumtion is PMD_ORDER max not too big.)

I think the general runtime version adds cost. It impacts all other archs.
percpu_swap_cluster needs a runtime alloc,
the si/offset and nonfull/frag arrays become separate pointers, and some
accesses get one more indirection. And for nr_orders=1, the allocation
itself is just waste. 

With a compile-time possible max constant, the only downside is some acceptable amount of
wasted bytes per CPU / per device on Book3S64 (the unused entries in the swap
offset cache and the nonfull/frag lists), with no perf impact. the perf
improvement comes from THP swap itself, right? Other arches see no
impact at all.

patch 2 looks fine as is. SWAPFILE_CLUSTER backs much bigger per-cluster
arrays, so runtime sizing makes sense there, and it looks like no impact to
other arches or the current code.

Thanks!
Youngjun Park


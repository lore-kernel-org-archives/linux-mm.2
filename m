Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E33F606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 23:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bp4qHMkT
Received: by kanga.kvack.org (Postfix)
	id 475C76B00EF; Sun, 15 Nov 2026 18:02:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426366B05B0; Sun, 15 Nov 2026 18:02:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C4C6B05B1; Sun, 15 Nov 2026 18:02:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00AD46B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:02:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E482E1C41C5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:02:38 +0000 (UTC)
X-FDA: 85438879596.08.9217B17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44B70A000C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:02:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bp4qHMkT;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794783757;
	b=TLVcFgbJ6QQRd+jADAR1CPee5LbhdVOqALdCrHKpZI/nmBEuVgiX3l6ushswHIFdmsAxiS
	eZs43E0MSHpV8As0vib3jaR6eGWuAAo80LPgoWPBocUJuHLmDbC3x+4OhaSMaj79TAV3Fa
	OZjqGdRzITg5mdcBgowAL5kKB6sA8Ds=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bp4qHMkT;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794783757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKZLVviTPAasAjwZ45EGIXC3/piLCHzV8MWKFs7dwkw=;
	b=qO38s0QwvE4yfAe+xftPJAGg5t7lqDIyx6RrGlayUCASw0B+S2BhRJuGGSS2/clneej4+f
	9Gz8T1AbxiPe3fSfmUP/3iKOorPnw0tFPGU633sYQFENvzLVRexWaKPD/sPbXDu+TVPTve
	SBWIPxfIiD0WaclfEyOyTio533Rc3dc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC44261851;
	Sun, 15 Nov 2026 23:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B30D1F000C4;
	Sun, 15 Nov 2026 23:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794783756;
	bh=BKZLVviTPAasAjwZ45EGIXC3/piLCHzV8MWKFs7dwkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bp4qHMkTiNj7pmttT1qqyHNc4XUALCOQme1pxy97DELSmauGpY8OHEOEOXwe88oxd
	 2p49Pmf6HAbXoToz2UD4hiIrKvPimcaS7e7mMURp6QJ0acdfa52nujWu0QZB86A5ht
	 fxrPXsMOS5TspEmmeByCuQVnC9SSeJYkYGjJQ5OyaC1zDCbtT+RtBqBMgVAgtuX3/e
	 1nwTuclZU704ljAniyO/APpKW2eDKz3kWYYaB/Q75CyC4ADuKN6kAig+oRebPTRffZ
	 XW/89g0GkODfl72N7cSO+iHlHcaZ78ETJs/4tqG3nUqpA8yL4mmZ7aMCj2LDGMNaU2
	 +OL3OKt1fBoOA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: zippermonkey@icloud.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	bruzzhang@tencent.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com
Subject: [PATCH v6 0/5] mm: batch TLB flushing for dirty folios in vmscan
Date: Mon, 16 Nov 2026 07:02:31 +0800
Message-Id: <20261115230231.21194-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 44B70A000C
X-Stat-Signature: 31ynoeaap4d6bmgtwbbm3163iq5yd31g
X-Rspam-User: 
X-HE-Tag: 1794783757-665282
X-HE-Meta: U2FsdGVkX1/n958uV1YCInBIfkW6F3kN5gBU8rW00r+x/19bC03nDjEmvGg9HCZRFv7O9/EjDMOu6AKlGstRRKp9jxDb+T6HhxA0oZWJCv9y5gdAK6CBc1b8hmvDG+bI/GokiNu9NfqX6hXHZYhrrtdxGA4uuPmuPN527D9NmmYVz5kAuyAKJ7VWFO3PCUZaI6G9GHj2R/U5o+PddlPg9sIPF4YNS37TEuK/23Aq6E4ZSMNrf7hyND/0c7d2N65s8tsjpR0sg/Mx4AZ7eT0G+pxohOAUulPXcFOEpC/zhMfQQC3vYy10Fj4GGXMECuyRiFziCJW3yEtkrw7ROVemrgiqY+2fQf0OIAx2ciTKFLtFfW8JbcAfLXTbzrgcxRvg8l/fIF+7WbxcK4841v62AtAmbIZ5jjgaZUNu4RoW2GzV3hK6wPZTRaOsqhJPATx6LkhDCb9MDNABrMItdV9XNjjSnFfTEGR7tFXz6phkVrvR+p+Jo6f7a2V/bTyQeD5UAxgh7gIvoBbBQkJ9cP8vXKjEhKOcF5v689KTgeAScxJzoFZmPQWK+K6Yn0z/0goBuux8HfsiLZISR+y0Ds/V+NnQlEze46G3SjVOCIxpRuH/9aRwXBq2fcT6CbXR4e9vegpa3kNfFiR0Kadz3XA9yL4jOfyWGtCKFBWvtbCv2ytXAzCwYn/oJHd5QRrFfdfUSZcKoq7ZUY5u+zHc+N7bL6WBVivJdj4/tl/ASxfWJQxx4S2dVcpFTPdVOjI5XT9vCvLWsv2oXUHSPLgb81h4JYQSLreecR819mwZMf57uSlnQ/Zk4OH9cNoBfXqw5jBE4rpA7cGN71T6vZGrhrVVJFusgAM/p91kAL6j4xXwiAwt3N+oUodWDrvlVHVkx1GBD8PFrrR/w/4xUp51J5qzgkqzsntBHxvm1KDgeccMmbNiplj7v8Jr0HCuOUKzmXYC4FFfjh9h9v+U/0cvv/o
 R62/J8wN
 n7bL9KCol2f4ZbnfZ/JRNHaYcxF+mVrFMiPQ3tF+9CXznMP6R268OpS4sPZYUXNHgvo1aXwn2YiRkW2YZoxtexx/8GBZiJIkHbOvHDUn539xqDUukqXfYaPdPKB7Lu2WovYih2vCZlc4JXiByMa6F8qnKtRq9zKAegvDcpxsEy4dyjzo+iqZO1WiGuX+TpFBLMvGD7J6tHYTh0Lew5yHVRj24bWeUvViasj8MrzMn69WbpEjciKzf9STZyqhcVBucx7dPpDJ1+9WuxBTxSLJZxpq6T3Y5/K0L3tVt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 6:35 PM Zhang Peng <zippermonkey@icloud.com> wrote:
>
> This series introduces batch TLB flushing optimization for dirty folios
> during memory reclaim, aiming to reduce IPI overhead on multi-core systems.
>
> Background
> ----------
> Reclaim calls try_to_unmap_flush_dirty() before writing out each dirty
> folio. When writable TLB entries are pending, this triggers a flush.
> On systems that use IPIs for TLB shootdowns, frequent flushes can add
> significant overhead.
>
> Approach
> --------
> Collect dirty folios into a folio_batch, releasing their locks while
> collecting the batch so swap faults can progress. Before writeout, try
> locking each folio again and recheck writeback, mappings and DMA pins.
> Keep eligible folios locked, flush pending writable TLB entries once,
> then page them out. Process a final partial batch at the end of the scan.
>
> Changes
> -------
> Patch 1: Extract the folio activation block at activate_locked into
>          folio_activate_locked().
> Patch 2: Extract the folio-freeing path (buffer release, lazyfree,
>          __remove_mapping, folio_batch drain) into folio_try_reclaim_free().
>          Group retained folios, deferred frees and the reclaimed count
>          in reclaim_folio_state, local to each shrink_folio_list() call.
> Patch 3: Extract the pageout() dispatch state machine into folio_try_pageout().
> Patch 4: Extract the TTU setup and try_to_unmap() block into folio_try_unmap().
> Patch 5: Implement batch TLB flushing logic. Dirty folios are accumulated in
>          batches and a single TLB flush is performed for each batch before
>          calling pageout.
>
> Testing
> -------
> The benchmark script uses stress-ng to compare TLB shootdown behavior before and
> after this patch. It constrains a stress-ng workload via memcg to force reclaim
> through shrink_folio_list(), reporting TLB shootdowns and IPIs.
>
> Core benchmark command: stress-ng --vm 16 --vm-bytes 2G --vm-keep --timeout 60
>
> ==========================================================================
>                  batch_dirty_tlb_flush Benchmark Results
> ==========================================================================
>   Kernel: 7.0.0-rc1+   CPUs: 16
>   MemTotal: 31834M   SwapTotal: 8191M
>   memcg limit: 512M   alloc: 2G   workers: 16   duration: 60s
> --------------------------------------------------------------------------
> Metric                 Before        After             Delta (abs / %)
> --------------------------------------------------------------------------
> bogo ops/s             28238.63      35833.97          +7595.34 (+26.9%)
> TLB shootdowns         55428953      17621697          -37807256 (-68.2%)
> Function call IPIs     34073695      14498768          -19574927 (-57.4%)
> pgscan_anon (pages)    52856224      60252894          7396670 (+14.0%)
> pgsteal_anon (pages)   29004962      34054753          5049791 (+17.4%)
> --------------------------------------------------------------------------
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---

Hi Peng,

Just a quick update: this patch is still on my radar. I ran a
quick perf test while building the kernel. Without your patch,
try_to_unmap_flush_dirty() accounted for 1.75% of CPU cycles.

I guess there could be workloads where try_to_unmap_flush_dirty()
accounts for an even larger share of CPU cycles.

# Children      Self  Command  Shared Object      Symbol                      
# ........  ........  .......  .................  ............................
#

     1.75%     0.01%  cc1              [kernel.kallsyms]  [.] try_to_unmap_flush_dirty
            |          
             --1.74%--try_to_unmap_flush_dirty
                       try_to_unmap_flush (inlined)
                       |          
                        --1.73%--arch_tlbbatch_flush
                                  |          
                                   --1.70%--flush_tlb_multi (inlined)
                                             __flush_tlb_multi (inlined)
                                             |          
                                              --1.69%--native_flush_tlb_multi
                                                        |          
                                                         --1.68%--on_each_cpu_cond_mask
                                                                   |          
                                                                    --1.62%--smp_call_function_many_cond
                                                                              |          
                                                                               --1.23%--csd_lock_wait (inlined)


With your patch, the CPU overhead drops by roughly 7x:


# Children      Self  Command  Shared Object      Symbol                      
# ........  ........  .......  .................  ............................
#
     0.25%     0.00%  cc1      [kernel.kallsyms]  [.] try_to_unmap_flush_dirty
            |          
             --0.24%--try_to_unmap_flush_dirty
                       try_to_unmap_flush (inlined)
                       |          
                        --0.24%--arch_tlbbatch_flush
                                  |          
                                   --0.24%--flush_tlb_multi (inlined)
                                             __flush_tlb_multi (inlined)
                                             |          
                                              --0.24%--native_flush_tlb_multi
                                                        |          
                                                         --0.23%--on_each_cpu_cond_mask
                                                                   |          
                                                                    --0.21%--smp_call_function_many_cond
                                                                              |          
                                                                               --0.14%--csd_lock_wait (inlined)

     0.00%     0.00%  fixdep   [kernel.kallsyms]  [.] try_to_unmap_flush_dirty


Overall, I think this is a good approach. I'll be traveling soon
and will return to this patchset for more testing and a thorough
review in about two and a half weeks.

Thanks
Barry



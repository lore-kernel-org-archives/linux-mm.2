Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB5E5CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3587A8E0022; Mon,  1 Sep 2025 04:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0F18E001E; Mon,  1 Sep 2025 04:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D03C8E0022; Mon,  1 Sep 2025 04:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEC5A8E001E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:34:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABF1913AD5F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:48 +0000 (UTC)
X-FDA: 83840020656.26.9333720
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1104980009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJhi5ygu;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKg+hjyUmu1JGnIne6LGUMVbGBEwvISnW1xltpM8Njc=;
	b=5z3H38wkdspniTBC5hRGhAmb7JG6V1XdF2TUi2QD0bppbloNnDDUSXiYsO/u92Pwgn+6NH
	XgkVxue9aCQe8GmzKTJz/cVlfQkXwOlVe8ExtSzBkKAqsCYk/ROrY393dpUQaWGoLDNT1Z
	DOBkjL6MslhbxjJQf8qg+dXZDAT4ZQw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJhi5ygu;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715687; a=rsa-sha256;
	cv=none;
	b=bv5OsEqtWJs5vIx2KXoK1wlpG7s20sgUSkhaqse3HbyLA/bntBpXWWvRr1J6nMI+ly4xLn
	v+mfoM7tjKY228SVgYg/vhfTtsxOqXxWSz87lymO71EWBwAh8P50DEt3svovSbPs4s78Xx
	CZBRmwxPiLXom4CyDTo8CyzOEwfdFm8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 237B244C0C;
	Mon,  1 Sep 2025 08:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39ABC4CEF4;
	Mon,  1 Sep 2025 08:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756715686;
	bh=zkkspZlHcKC4C7aIeuCgP1WZ3hWEhniSwzjVItRMrh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJhi5yguJHsnSZp7RF3kwwUDCXuzjvFgxpVADQAv5/mix6G3N9uE1k04Qf/aoEHWV
	 rWchSAh71hq7+Z5BQmOd6Yda71T9HGIoo902H0K1wDX6Ia5NkN4BesDI/jrP7VoSDg
	 R/vs//u5RpXX1GmZsYiKSyJII+E7xAqHWaiDRUEzWUyE8icEzuecQAzhMk360tEROs
	 z4vFOokX3rDir5mkAhQD/XXcZ1mn1uVdVVsbmxmMdWWWpxLEfnZ4t7ST7oUcZlM50r
	 Hk+c1z0OgS0NivzwoZGwUVMliKnisZAb/zcaO3lNOO09SL0rvMFmPOWM2XPeMBJSYU
	 U8M2ymxeU7Mkg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 4/4] memblock: drop for_each_free_mem_pfn_range_in_zone_from()
Date: Mon,  1 Sep 2025 11:34:23 +0300
Message-ID: <20250901083423.3061349-5-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250901083423.3061349-1-rppt@kernel.org>
References: <20250901083423.3061349-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1104980009
X-Stat-Signature: hsy7qfegtjbm1fxkj5imwabbshe4xddf
X-Rspam-User: 
X-HE-Tag: 1756715686-8379
X-HE-Meta: U2FsdGVkX1/ryCRvvl+RciHJwN89z0x9aGV4yy/T281jxQ6LknLvRqrmGfNQvPCf9s9KRh1docL/ERlicH7mo58XLvOiWuv/hY2SbkMMW6JOLInBiGkJ+CZSYuZjiZjPNbcc0zApiaqNbDQl/ns2Ak3CitjddmfLnmcZm/yXswdvI6vhHX0aQAwtUTtqrhcCp0z9YchiVguxs8dSG3JLR8aOM5+XB+BT8aAfxjdFPPS3STR7rlgQfzbQqy+Xm16LNYVHMwixaKpQJbiCD4JjaZITbScTThJ7SqEc/528mestcDv4sRvCfJLDhVNzp2COiWAUCjib/BevlI8CY7P+mYyQeWGRQkcgAWwxJ98UoOu0jnYNrCbgZtQ1urF6psBkcbIF/Wn4S1TXwKbhPfR2kbWV6YoM4Zd0WHsAoDYDhn+Y2Srb7TIn+Ndja21g0mXGdfHRGqUEvmU/9RO1V8c37r2b/wR1M4YfQQHOk9Js9bk19AlG24vFbGDKyG2sAmQEvkGKy+1UqPtRWqmbGdxctCzFGN7j21K9i5sAonAKdfslBd02w6Vy7N9C1cnZQgKTVJSQpmGEN9ZX38Gj8/inM6xt3xKrtM1Q+38RlQzwILyks39qniE2Fqf5d3eTSfLOZJFJvNG7xWxYegO3E7VbjoJEIa+sa2H2MqNi8Wu/6JmzeU32yt9pRfntYsP+A4NeLpvI/nvm+TCG+xXWIHu8xxOSEcpOZdsu4oMAsWXEAJCds8PIgAEgpe6A2wr1i7GDAXSaNRC5PX0Ds431Bv2A01HZYOXFUQ2S0+WPoP2J/e2R8lRTEPux4fAZc4E78C5a6Ejkdhs7KGNJFnH71i+9iLDGrYaLsGzh6mcBtdafmgGOOuIf0hntKTxKjdbVBT4k8Ebu+kcfKPebbtaoI63zRaXG2ZOBc1hJdLHltQ0fxyKudzDPd3vB3majvJhVTPFhGem9jt8pNlasHrKPhIr
 cfqlpthS
 EBWJhyHS75MmT/QyoC6EXAIiM7FRhG+vu0UTjjJ+IOW3OwTNIp3/RRU1ullfHIDPSuADAPSh4EaNgvYYz9AyC0X0Nkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

for_each_free_mem_pfn_range_in_zone_from() and its "backend" implementation
__next_mem_pfn_range_in_zone() were only used by deferred initialization of
the memory map.

Remove them as they are not used anymore.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Link: https://lore.kernel.org/r/20250818064615.505641-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .clang-format            |  1 -
 include/linux/memblock.h | 22 --------------
 mm/memblock.c            | 64 ----------------------------------------
 3 files changed, 87 deletions(-)

diff --git a/.clang-format b/.clang-format
index 48405c54ef27..f371a13b4d19 100644
--- a/.clang-format
+++ b/.clang-format
@@ -294,7 +294,6 @@ ForEachMacros:
   - 'for_each_fib6_node_rt_rcu'
   - 'for_each_fib6_walker_rt'
   - 'for_each_file_lock'
-  - 'for_each_free_mem_pfn_range_in_zone_from'
   - 'for_each_free_mem_range'
   - 'for_each_free_mem_range_reverse'
   - 'for_each_func_rsrc'
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index fcda8481de9a..221118b5a16e 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -324,28 +324,6 @@ void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
 	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
 
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-void __next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
-				  unsigned long *out_spfn,
-				  unsigned long *out_epfn);
-
-/**
- * for_each_free_mem_pfn_range_in_zone_from - iterate through zone specific
- * free memblock areas from a given point
- * @i: u64 used as loop variable
- * @zone: zone in which all of the memory blocks reside
- * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
- * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
- *
- * Walks over free (memory && !reserved) areas of memblock in a specific
- * zone, continuing from current position. Available as soon as memblock is
- * initialized.
- */
-#define for_each_free_mem_pfn_range_in_zone_from(i, zone, p_start, p_end) \
-	for (; i != U64_MAX;					  \
-	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
-
-#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 /**
  * for_each_free_mem_range - iterate through free memblock areas
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c..120a501a887a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1445,70 +1445,6 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 	return 0;
 }
 
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-/**
- * __next_mem_pfn_range_in_zone - iterator for for_each_*_range_in_zone()
- *
- * @idx: pointer to u64 loop variable
- * @zone: zone in which all of the memory blocks reside
- * @out_spfn: ptr to ulong for start pfn of the range, can be %NULL
- * @out_epfn: ptr to ulong for end pfn of the range, can be %NULL
- *
- * This function is meant to be a zone/pfn specific wrapper for the
- * for_each_mem_range type iterators. Specifically they are used in the
- * deferred memory init routines and as such we were duplicating much of
- * this logic throughout the code. So instead of having it in multiple
- * locations it seemed like it would make more sense to centralize this to
- * one new iterator that does everything they need.
- */
-void __init_memblock
-__next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
-			     unsigned long *out_spfn, unsigned long *out_epfn)
-{
-	int zone_nid = zone_to_nid(zone);
-	phys_addr_t spa, epa;
-
-	__next_mem_range(idx, zone_nid, MEMBLOCK_NONE,
-			 &memblock.memory, &memblock.reserved,
-			 &spa, &epa, NULL);
-
-	while (*idx != U64_MAX) {
-		unsigned long epfn = PFN_DOWN(epa);
-		unsigned long spfn = PFN_UP(spa);
-
-		/*
-		 * Verify the end is at least past the start of the zone and
-		 * that we have at least one PFN to initialize.
-		 */
-		if (zone->zone_start_pfn < epfn && spfn < epfn) {
-			/* if we went too far just stop searching */
-			if (zone_end_pfn(zone) <= spfn) {
-				*idx = U64_MAX;
-				break;
-			}
-
-			if (out_spfn)
-				*out_spfn = max(zone->zone_start_pfn, spfn);
-			if (out_epfn)
-				*out_epfn = min(zone_end_pfn(zone), epfn);
-
-			return;
-		}
-
-		__next_mem_range(idx, zone_nid, MEMBLOCK_NONE,
-				 &memblock.memory, &memblock.reserved,
-				 &spa, &epa, NULL);
-	}
-
-	/* signal end of iteration */
-	if (out_spfn)
-		*out_spfn = ULONG_MAX;
-	if (out_epfn)
-		*out_epfn = 0;
-}
-
-#endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
-
 /**
  * memblock_alloc_range_nid - allocate boot memory block
  * @size: size of memory block to be allocated in bytes
-- 
2.50.1



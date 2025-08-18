Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF0FCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ACC76B00C9; Mon, 18 Aug 2025 02:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D148E0014; Mon, 18 Aug 2025 02:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14BB18E0013; Mon, 18 Aug 2025 02:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F34C26B00C9
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:46:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49A3D138FAD
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:40 +0000 (UTC)
X-FDA: 83788944960.29.BBC54EB
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9CFE3100006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u0Rpyu4y;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UeSgCA6ebvBlLvwuNlNBwToj21zEnD385dv71fuTzn8=;
	b=5AoDJctBc6qNe4d/oVbyIcGXUFJSPOxBizgV4Sty08EhR46jU7/F/OG31vR8R00pazPKyB
	c8ADPrHRmoKpSvUqicNJ/qv/oDtv+S60S1/1TMkieDIDy79QEiTdVvmBb+v2wtym8PBJbS
	ZXCy9DlYDYqGgZqgFJD9lU6iPpDAxo4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u0Rpyu4y;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499598; a=rsa-sha256;
	cv=none;
	b=SvB7GnEQy1Ks/1u0z0BkZ6Ekw06D69OS2fCHjeNTuuTh/sv8NbMXIyfyF/VFF67QLb4idd
	Y+yZ8BAJfA8QPGOo7/6adK0bhc3NULBY2FNMaGqJh02s5q4EHbv7Jep+uARp7l6J/FYTWZ
	o8DiELDZIWf3hGEIw7LiMTCseC/AzAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 95EC85C599F;
	Mon, 18 Aug 2025 06:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325E2C4CEEB;
	Mon, 18 Aug 2025 06:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755499597;
	bh=mWBw2dxrn3qCb6ZjGXqIStKZeXRZV0QwSHDvWZaNzXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0Rpyu4y8bEUq8EbFwZHD5j3l2gjivkI8HDDJLhyxDRHEzCdCC1nxhMjOdh19vgTq
	 l2Rzc/qXKbDwoWkF8Ma9mBNItHubHiDEcL60X2pyfsp/yozfyASpmtNvkn2ppiP6bB
	 K6wWyhJ/w6QjVyS96IfFo28aq/M+NW61AdgJE1nl989dXsHPbfrR1fQmRp6glOM3xP
	 5DSgy8XwoD+L7Spl9BPnUEIZbM9qVXYU7mj/i2XxngBbxSUtSsf8JKLy3qvkjxZySg
	 d7lut5t2oHgzynTJjzf0lUc+6ZM4fT2vERwhMokUsHvgPSi31DWsxsDcw2doc3jVyJ
	 qazIie45dnMmQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH 4/4] memblock: drop for_each_free_mem_pfn_range_in_zone_from()
Date: Mon, 18 Aug 2025 09:46:15 +0300
Message-ID: <20250818064615.505641-5-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818064615.505641-1-rppt@kernel.org>
References: <20250818064615.505641-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9CFE3100006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7bmbbfzmnjhkqu5p5wcqd61ugiicjbnn
X-HE-Tag: 1755499598-973452
X-HE-Meta: U2FsdGVkX19Yz1ovNgcmk5A1Fvb+UlfxT+72o0yerNHeF30qNEYc7PzkfnE3XzIy/VQ25NaZjWryCfYhXuw6+YwO3tTbV82T4pe9TGN1vUolYjp7v/pngjOgm3dtqX4qGASjK0VyExhEAtMLA96UeJefouGehMkquNH78oz9WLHwl4a+1iBp6Kk4FpPBnoUTZG5BFqVeMVRMFRTpIoAOZU82gdy0hlZQf/o4bwjpMW7d3RPWAzBJltOQRk9GMIharvBbP/Z7WefYpf887rL2hesXrKDB0Z6Dyt65Qaydugbr470htJxPFUdpQZobuwIf1XMaT3mfr+ahc242FbdsF1zUzcSDFHGJDwdqUlQVdv/TTFcVW5owjo3G6tqugfJR+7nRnC+gQqfh+dyW9ZDEwKwkOb2GbYeNkVBoAsjp9Wgd/+oON53g9d+DnPoL5lv2Su/5MKr6uHU6X3sREgdeLmwdyPs1BHHTOBMeHUt2/Me2c7vdr9AJD412zZFydDAbyQQXf9F5Vugyh5Sn2791Cx04BIt4kgbbHvcfAR2LfPIFEiykaSu+/q9cmV6TcjKh/WQGWh0tfKJ8P57ob0Gq+NVVjq4U2VkvRVnDnBv2E1h5MDsJflweKw4nGdxryc5Zuf7SHq0EpgWnl+nfCCUvb+aC2N3jpnADpvrIPGuBX8NMgdER96bbD70c2E8gERxCqPMygqFojb/egvnHZCu33hSuRkN3ZXRSVBCWL4GfqqKAVx0mg7CiNy0iLVNj+ZDj78RTem6CH6EXXOQk9SMPP0R6cwelRL+58nGEwAELjnQi5XVnLT+DPkKBXUoGyz+dIc4e09Lz091RWFbZFAjWnBPN1AVGgWizJRsovBLbmXjOaXrm6Uo1gFL7yIsg2eVq54wsU0iHd8GSRCCrj9odjuXksTdvXAsSjhUSIMaCS62CsXD5fZaWmJ+GUpZ88dCeijY+ufMrfWISjqonpLr
 /K4GOlAB
 fAelHN+GfZObjxxqYTQOtx078wDF5J/6WlnNDSLBS4PAIjcsaBjX61oBY7ZXcFn/O/l4ZfHB5pqo7ruYLNs2JHf7EAjmtLZXDG+KwwvvT5ODJQ9+PROkoM5YVaUkshij84uELbSOmaFNS6e2dUjfhrjZQ8H4TYRPjdlkNG5glpyPkcYXi4WeZuZpfYpRXZcz3du2/QWv/98HMRTkZ0Pr+zr2W2ZIs2KvCCJZagyt4+HNDHxEhKT8UpHAVyevwH8Y1T/pUZ7i0wCHxjq/3++XfCk1hna5kouQB8ju6vndNyERlc5vTCn+8lmrVOnGEvtrKKtFy
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
index b96746376e17..20b61e910f4d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -323,28 +323,6 @@ void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
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
index 154f1d73b61f..337c025109fa 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1438,70 +1438,6 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
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



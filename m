Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3060EB105A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1716B00B4; Tue, 10 Mar 2026 10:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC016B00B6; Tue, 10 Mar 2026 10:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF4B6B00B7; Tue, 10 Mar 2026 10:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB41C6B00B4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:54:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6967E1BFFD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:54:43 +0000 (UTC)
X-FDA: 84530450046.29.37A41CA
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf29.hostedemail.com (Postfix) with ESMTP id AA97E120005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:54:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=taHmAdo3;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGWvFNNHbAVQyTUs3YvCDY0GyMiml7VfROhcweab0g8=;
	b=F4Ri54iP4y3aXW6asLZIosnIk/UD7Wh0d7UDO88hbyH/ZVVfmfL3MNHIKE4paG9rFIckdi
	fbqeoy6vrNolctX1SEzyHoUiH7DOMC4svXvtJJgagE1GKttITE3mDxcwFYAARVrXn0asAY
	Ri5SgNDpX4dTC7qcG9pFG6cOSoOWZpA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154481; a=rsa-sha256;
	cv=none;
	b=Sny5RoesQsB92A1rgDbNyc/sDRMd220g11NHVRfMzIADHdQ5rHVoQZj39PqWDOHebmsg5y
	pQniuK4uF7uB7RAjcX5SsnLDB5ySPdzeeW8O3E2acJdPN1DnyVZMmsNm45Y2MTavCPDH30
	50uqcgdeK4QCgZm70i7PS6yfDxotjq8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=taHmAdo3;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773154479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGWvFNNHbAVQyTUs3YvCDY0GyMiml7VfROhcweab0g8=;
	b=taHmAdo34oCwjQFIaRdmRojINXQm081BWLVpiG89JRPghIcpldJ2rwOWU0KURRrhy5yjpf
	19sWjb7mkMYRCePOGCQXpG9Wc5IKYu1fi/V6HuLIH/qnuv0qdwjurQ0tE2yqYewmgWxhBS
	i69FLwkpsJPKnJP2wwNrpkeBXTBIoAo=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	ryan.roberts@arm.com,
	david@kernel.org
Cc: ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 1/4] arm64: request contpte-sized folios for exec memory
Date: Tue, 10 Mar 2026 07:51:14 -0700
Message-ID: <20260310145406.3073394-2-usama.arif@linux.dev>
In-Reply-To: <20260310145406.3073394-1-usama.arif@linux.dev>
References: <20260310145406.3073394-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA97E120005
X-Stat-Signature: smgin7eceny7htk1h46bxiozsrewnz4t
X-Rspam-User: 
X-HE-Tag: 1773154481-642936
X-HE-Meta: U2FsdGVkX18x/hpAJrFDSCeKN3Mw8u/1HqXU/kZ/wScAYpnoe+Y1AnKV7YkkXGhokwfmA7SA2Kb+EuTRTFtKcTe0siMNT/jPjpM2zDMiYR+BVbmrkBAoBMPG7hoePRAL1Fn5obDZiC1OvR3AwwX+xLsdcPupuT2kZguTBOJduw70W/CP/P0IZpqoOE/B83rB8hySJzoCMcSZVzAiGjdvv/XJiH0uayihKeNNPKbEaQ9V0opVii/Vl5yF8HzJoGMMUvRnqxokb8XMTdWBFgD/lS3SlMQQZQKNi6UXVMuaqh3n1PNnAgWLQ6xGIuBrg/yM1KbtcTGni9gsgiOelv8wLv4rtJ07oiMMxfmEHbjdPK8+ZvUQny/x6UPsKXp8tm2sdl+A8DTAowS000gvcXVFgIX2nJ15TzJwhGPYNyOBQuleqEG+EcIjqGqVBJ9MQ5FeSmfyxRX+OISc/6JHXB5vNaQTGDpa4sYrMPLx39WLzGdUXZX1GSyC8ghb65rH/Zykvx89fWOzQDTKyBWMuehvvcI/Avm6/jsiOkJ6bBbqx+8s/L2KPf2btsiKVcX1DeG4BL2msXLgZAA5g+LXOuMk9bCQ7jvqMwuvnijSnYO9TA6De4SjCOnwI7heDtZwaiG08PdUfrVVhuFNVlIO7dh4NNbX04yC7iQpMfWBFwcQtazWatL7jZs7Y2Jil6piaoQvyY/mz3ts/ZJcuvAoCyCYLeaWy8GzsYEwYAW1QNjMGNA6b4RtB2T7NK9jAey+XUdQqX13QViX4Sy1wxvwOl2VwKesyynvn5FC/4S6S7mWxhTh/OauIHpwHTDD5B0Nk8YwwQlTR5otc2hJcnd6od7zfkR+M0p6qDdSq09kF87CGxG/kFSFqQqZpuLMZn1x1u1QorIEsdxlIWdcu72kAIjKH9D2siDiZnIFn06d5aXQB8tzcDPFOFt6rEFkhb7ur5czeZ/m1WtQIiWmjPUyKgO
 9qFlScM5
 S/V5PNNz/Z9CkxR538s5QCGiDinStAzOl6fSthUZejOKxJS3YXt8BnFtCVirlN+gSg+NNo2ctEjSMCSw7d1D05vKUqZeCQ8LNt1zoXI/YYsKcgET/1/QkaV/hzTI7HT6ZZMvKQqzGhJBv22KhvX2nlEkJ0JbqWi8j0I6B8/Fy+mU59ZPJAVc1SY/fKzU2qcPZZSnEhtAntpn8kq2aw1NT7tJXu1x1uomuRd1rX60XaGPmnTGs8J+dZmhJos8E2cDka1vwiutHLd/AL5ky9ZCxcekkEL5wzYSjhY9L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

exec_folio_order() was introduced [1] to request readahead of executable
file-backed pages at an arch-preferred folio order, so that the hardware
can coalesce contiguous PTEs into fewer iTLB entries (contpte).

The current implementation uses ilog2(SZ_64K >> PAGE_SHIFT), which
requests 64K folios. This is optimal for 4K base pages (where CONT_PTES
= 16, contpte size = 64K), but suboptimal for 16K and 64K base pages:

Page size | Before (order) | After (order) | contpte
----------|----------------|---------------|--------
4K        | 4 (64K)        | 4 (64K)       | Yes (unchanged)
16K       | 2 (64K)        | 7 (2M)        | Yes (new)
64K       | 0 (64K)        | 5 (2M)        | Yes (new)

For 16K pages, CONT_PTES = 128 and the contpte size is 2M (order 7).
For 64K pages, CONT_PTES = 32 and the contpte size is 2M (order 5).

Use ilog2(CONT_PTES) instead, which directly evaluates to contpte-aligned
order for all page sizes.

The worst-case waste is bounded to one folio (up to 2MB - 64KB)
at the end of the file, since page_cache_ra_order() reduces the folio
order near EOF to avoid allocating past i_size.

[1] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/pgtable.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b3e58735c49bd..a1110a33acb35 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1600,12 +1600,11 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
 #define arch_wants_old_prefaulted_pte	cpu_has_hw_af
 
 /*
- * Request exec memory is read into pagecache in at least 64K folios. This size
- * can be contpte-mapped when 4K base pages are in use (16 pages into 1 iTLB
- * entry), and HPA can coalesce it (4 pages into 1 TLB entry) when 16K base
- * pages are in use.
+ * Request exec memory is read into pagecache in contpte-sized folios. The
+ * contpte size is the number of contiguous PTEs that the hardware can coalesce
+ * into a single iTLB entry: 64K for 4K pages, 2M for 16K and 64K pages.
  */
-#define exec_folio_order() ilog2(SZ_64K >> PAGE_SHIFT)
+#define exec_folio_order() ilog2(CONT_PTES)
 
 static inline bool pud_sect_supported(void)
 {
-- 
2.47.3



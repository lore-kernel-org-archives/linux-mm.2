Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2070CCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C586B00EC; Thu, 25 Jun 2026 03:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7CA6B00EE; Thu, 25 Jun 2026 03:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4051D6B00EF; Thu, 25 Jun 2026 03:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE1B6B00EC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:39:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9626E40604
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:39:55 +0000 (UTC)
X-FDA: 84917635950.15.E1FDD4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EEFCB140002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:39:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGPmq9l0;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373194;
	b=wsJyMkX03AcjxDlggq5/HnStmbBiEVsfTjenG2AX9c3+LOYrRBhCYXhyyCBvfKQNDuFvqb
	nwd5w9C+1GZonp/K3higuNj67yIlEWZFe9ULGF3JzrveXs4T3OH58DK0mIxyLfcBr4wjfW
	0tQYjerZv6TeYWYdZM+mS/WI2d8GVVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSJ+S3PGQHQUzTw7lG7PXPuxkl/9B8uEBbMRx1+mPJc=;
	b=ngbKU5s8ckT8OlPyqoGR7kV72zrg/Qe553Ta09/zbfLZR9/ULqniOL1Hr3L/N2VBVSghen
	RsUwMgriUnF+u4Vrn8czM2YA8WbMbhEeJW8M7vz6ogMTdtl6w9u6JiCKNMgyFuX2wBeS0n
	lDbsf4C4VA6JXmT+MEpTRKwVDD9YNgc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGPmq9l0;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 890446021E;
	Thu, 25 Jun 2026 07:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3845A1F000E9;
	Thu, 25 Jun 2026 07:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373193;
	bh=cSJ+S3PGQHQUzTw7lG7PXPuxkl/9B8uEBbMRx1+mPJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGPmq9l0POx4DEWSLbmxYHSJs/KUS99Pv1jWNSkTfaWZApGYsefRTZaBwU1oaUqEx
	 pcFojiUsELD+syaEP04sNoXR9TyV8ZuT7owQmryEmdQQTnqRIHymS/x2i7NswRXecu
	 InUWWGufuNIWQmSM2RX8fDV4zbB3yQyGPxp8EpKw9mBBTp+0l9v/9ZX/Rzi/XCA0z/
	 ew3Xu4ZmJ1JY5xvkocBP019rmX6dKV4FmcmbPyWJiPIHnLHjYkjjBA+SZX95ZUysa/
	 Rx3bIluMow60fTkxdbRg/GPCU1QrLahUlHSSeUdnu8bUu4HVgGuJF7aDzQr4JiyqtC
	 zJNNGqQz96z2A==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/mm_init: drop overlap_memmap_init()
Date: Thu, 25 Jun 2026 10:39:40 +0300
Message-ID: <20260625073941.145014-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625073941.145014-1-rppt@kernel.org>
References: <20260625073941.145014-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEFCB140002
X-Stat-Signature: 9sgdwwdpe3a8ja6nuj57ms1su7wu34bc
X-HE-Tag: 1782373193-316103
X-HE-Meta: U2FsdGVkX1+N8YRBuZ/awhZjjeF/cqzA4GrAK3JJH0mmezSZNhN+Qb7182JxHy4tOJlml3JPMhA7JxTLV0EyDb6TAVReCHbK7ODZuIp9lnnMwrfa9t6X9QGtFonk5eH1gVeFAA+vamH4nJxqkoZpRShobRi3a3f/e3OrVvvdp1wsyCxsz0XZ8wcGKa4hIIsi7uuZPbejHVm3WV1mPLf1yjExl74HlytYz/eiz7aPCL2Lrsa4FEM1awedckgAl5ODZlUo1qf7ish1XGtAlOni8tU+F1KNvcbJGfkoYBwiCBgnLGonX2vFercQ58ASDcoeRQi89yaf8DDv9vz+LBM9PLJlIJ0+iM0qnuYg0QDEcDojnKD8AddwesG2a+88RNJNJkeyC4xrPy+ZACAg2zGth5Vx7k0fsbDe6X0dokNli+PUq2PERYdpEyboY/TXVNDDcsXiDaY2xXzM0rX1qiiqbuOSOGtwnhOoJmdnGrS7yvFX/wzR5pQUhIrAiGmAQqvnpcXmTk42yRY1AtJrNLaW2dvVJirfsZwTglz1cIhXAxMjgTIO+f/M1KzbZkGUDT5Po/CDUdF7iVFn7mwnuzUKT+LCShEiOgUhqFLyOshb0uCxa8ATICYO8QRPL7C9gOq8FWNT+g4nKZlmhIRq/Igh+PAJarnDQmiK/iqwaBVzGpJG1hZvoaXE62xPfUpL99pNcPMw9y4KK5geT07szN9cOs/edNU3mlhQMo3dJut6kOVD62KMVzyttHMyIRiS+ATiT3tV5P75aAoLdBrjWZQDyVtMANpT95W1LxA+x5x/VtcFKKKVSFIS2u7ADRobmMoX14EW2QYTWgH7HY0iGvjF4tgDjKigJf1kEC8ETW5JVo9vf1xGTJzVoqQ1E5dTXxO3zYk9RcPworuIEaTH0xKoRKKjKZi59+SUm5R8u7by1mioOZzfhWjfEKWuHrrgLnUUayT6tAjgEABXJe3EjLe
 lxBWPdIv
 mNjfHoOTzRXzOrvZPpQUmisgSqUUGaSHhOeUj78nv5TMlrbAKDIoSAzq5KpW46QyPZBOSehKAaC1nS5LT5HESxsnKdZjjbofsdOlSt+Q9PAZIwfqKey4UaT1ZsY8VYkbwdl44UaLw/tp/kH90sWpuXp0HszumxAIuvcnJHDv4Yky5Khpfucod1DRxqOn7rbKQbeit0JchFSYVsTigaz9RALDlq96jrZ3yJkg1LUYe56VDwnWhPH0zyuK4vkgaBH9ctrch084iHA4I9CasmH3EEYEADA46DFm4QnBuU75j/qVkTpo2brGcsAo6cdDZbNwQhloFCNi93A0PE2u7PHCOh7/DaKN1Ys7z3J3tIVp4nT/qkmkvAmLLny44dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When ZONE_NORMAL and ZONE_MOVABLE could overlap because kernelcore=mirror
didn't reduce the span of ZONE_NORMAL, initialization of the memory map had
to skip overlapping pages during initialization of ZONE_MOVABLE to avoid
double initialization of the same struct pages.

Since kernelcore=mirror works now the same way as other variants of
kernelcore=/movablecore=, and adjusts the span of ZONE_NORMAL, there can't
be an overlap between ZONE_NORMAL and ZONE_MOVABLE.

Remove overlap_memmap_init().

Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index dce9dc9f2302..6f0a71ccca30 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
 	__init_deferred_page(pfn, nid);
 }
 
-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
-static bool __meminit
-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
-{
-	static struct memblock_region *r __meminitdata;
-
-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
-			for_each_mem_region(r) {
-				if (*pfn < memblock_region_memory_end_pfn(r))
-					break;
-			}
-		}
-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
-		    memblock_is_mirror(r)) {
-			*pfn = memblock_region_memory_end_pfn(r);
-			return true;
-		}
-	}
-	return false;
-}
-
 /*
  * Only struct pages that correspond to ranges defined by memblock.memory
  * are zeroed and initialized by going through __init_single_page() during
@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * function.  They do not exist on hotplugged memory.
 		 */
 		if (context == MEMINIT_EARLY) {
-			if (overlap_memmap_init(zone, &pfn))
-				continue;
 			if (defer_init(nid, pfn, zone_end_pfn)) {
 				deferred_struct_pages = true;
 				break;
-- 
2.53.0



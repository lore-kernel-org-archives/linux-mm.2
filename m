Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9468C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFB76B00A5; Tue, 30 Jun 2026 03:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A904D6B00A6; Tue, 30 Jun 2026 03:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F7B6B00A7; Tue, 30 Jun 2026 03:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 659C76B00A5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:22:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C86D81403AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:22:26 +0000 (UTC)
X-FDA: 84935735892.21.3772ACE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3AAA480003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:22:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acUjTNpa;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804145;
	b=z7Jck/L5qKWk1ZQ5xiVOs9YCKAbOLYSayem4FivlXJK/o6lzhNjR+aTTBS8+jAfoHaiaOv
	/HzHo9O17rc88cd4Lk14wFtWaiErvvsftbb9EfSMxTA9MFTzg1Lov1ffk5q2E3pedJYMLX
	Pl8/14j41Cep1ok8v/GpUV/GWnzCzB0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0XMfOS9Ca4gesbEKnVY7f8yMPjjkgkoHlJ40QUpOHA=;
	b=EF0gqI9G6yb51mQ3h8lfCV9WfPnmqhhKIkMGL0jrePdrZMOyqffhg1Uq8VukMI+H4T+Wn8
	TqyFydHCgF2Tb2E8fORjNMY/lrwvPLVHKSF9oY7gJQYxAJfnCLTRRT+jBtJhOvypIKjgyb
	ULRF6W1LPjT0cjP9L3t4cG55QNNdPEo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acUjTNpa;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 945A1601C2;
	Tue, 30 Jun 2026 07:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3725F1F000E9;
	Tue, 30 Jun 2026 07:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782804144;
	bh=y0XMfOS9Ca4gesbEKnVY7f8yMPjjkgkoHlJ40QUpOHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acUjTNpayhnlurAC7VyXypDgIJqrmclztiDNXm3mjydmB+rasN//K57Aj2U/5DWAS
	 HSAi7/571gpyjr6wuxbPdei2LRpmrszUdZJ/xm6H91iV3zXOGmUP6T2SUVWX8sKCHr
	 HbojYGNRbyVsIy+6lgvcp+iv/4nJdw6FFpl7+n4lwHFGRJVDweoKaiorfGKxouILe/
	 1Euotm7QbqVr/M+RC6/m8yRVYQrNB4/Dz0gYWyN9TszJGSih8xPq07d8Q4JEDm5ML7
	 L3RrcPkrLa8O4OT6a7Rn26TUzD4piLbh4vkpOFuBRSSIA/01yeR9LIWxyQ81RbQ0tv
	 P2FZ098qtz7mw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/mm_init: drop overlap_memmap_init()
Date: Tue, 30 Jun 2026 10:22:12 +0300
Message-ID: <20260630072212.624305-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260630072212.624305-1-rppt@kernel.org>
References: <20260630072212.624305-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mbc8n8ewxtzr7ihs9hzh7q8h67p1xx4e
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AAA480003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782804145-673835
X-HE-Meta: U2FsdGVkX1/S+1rozvz1swbrVI7PG8S6s3jFJQ0yc4vXtTss5tIjQq2AmTsSPCkiOytH+qNWxtThioqVKvoj4U+3+rsKAkZgF8sX+dg5686jtzFC3zVJ7kCNM4iGhtrXQwoVX6/WS7AhEVgLK98uEhOCjCdRLgUhW0r5i+V8M/dWfCPyio7/Bt+0JGy8MQfVlVs4R/cK++T4aBIdPDudCJExKlj7KjBF51VVkSknjuSU8suGkr/ZJ8tK2EyLZmZ33PVFlKMQD6zPDVAe45L3lJRXxMcc3svWmGs01Pzsfi3U3hdAgMraIZYUT/XtorSadmwCqa44ep4/CV8DAoFNPCx/R25O85OctmDmZtGp2dnJBpAAQ7Qp6HYrKl7Utf+nb8eDNnl72p6qL9pnEBxNeVkuTVQX0NQARI0JChJsO5mmu8JDfn7Yx0XQzddvpPF1XCUdWgwewzm/VXXXDBrTcnjmPyaZ8UqGKvBk/5Wk+MAXHWNyMbgkHMfbtGwSYA3xNUEDft5Z5GKqDDEbHZbAdjCqwi+EK0mhW/PN2xIrghlTJk3PW9BoMEPb1IBx2K1MbOJYYGs3qSVxwZE6F6QBJYdRuoiVaoakzSmZjB76tCpBmb0FuO9M3sNhyqFuG73vrhJNhxsAfGV1FKxT692KcSuJhqJP4wPgZN9UnARVyaC0KrJpDEcHWBg0kTKHCcsUqLTbKYL30Q9tN6Ckh0eImrkeCNh2jiPpx2LfIFQrm7CfthIaI+54AuNVnSgQ625fmF51bu/5uCjgxzCuO0ll8iQXBpzyi1a1OmhQi2J3T4X7gvDjKvBcUHJjmaZN48kybWCfea5ohV+JvhsZRL5p5MQIoPGmSr+yyZkbDpVPAQHr6oqwwSgIqgmvhAH44vnwgQcvMEexBw57P1QmZME2LsHKN0ghyCA6LANJRlifjU+fXfvBQ2b82ZvDj3skRbv91VnfLTRonbV/SsgtXR8
 o1Q4YQIQ
 aDWf5XpKXuZthrnhQNmAjkHyBmlvMFVmJF92MwGsw+q0X2t9pCxvZVwi0MNNNGdDGwf3eWHGv6uFkZBZESCcaW2PSxwh24KtuPbkDUgk4izusz5hlG2FYM/4BICbRvpHoWz+k0X7rWIr/cNiBzTZqoIzV2f84yXuE0tH8otHc3Blntit0a3QRZVkKtpMmuH5Uj2Gqqesu3g7M6+vsBRLsa5kPHEsxdva/CLmHPe0zgeaq6y1sjY9GMRBpclsIwQh4xe4PPPMyDBguqPuYJPjV2Hu+hPS/WKPsRfFfJiCLTNUf7E4bQF4gmAEuYrbCVDBOgraKh/bHqpP6Y97UnKZonm1VDSL1l/y0XmJbpY4PIJY3/DON+TL5qNjVOw==
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
index 57923dd33d06..838b5a0ad98d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -799,28 +799,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
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
@@ -907,8 +885,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
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



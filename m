Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B211099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F626B00E2; Fri, 20 Mar 2026 18:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356666B00E4; Fri, 20 Mar 2026 18:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294566B00E8; Fri, 20 Mar 2026 18:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17BA96B00E2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6C061A03FA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:07 +0000 (UTC)
X-FDA: 84567845334.16.7EDCB9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 050F34000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ITuTXaTR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqMRPFymUgptl7lZXi96i42z52l9shaObmtKsLpQjss=;
	b=nPFTuBYYsX0TLXH3gwCS1bXwo+7m/HnGph55C0oXRR8cYvrDIRqNf/DP2v7b1e9Aw+B7jE
	Do7yje5hfF5Kk+nafY7H9WOfXBQkbY5e0mj6kh+guc5yPEb7YEJ9yKIwHsDI/H6YJUkwXt
	teT1Izq7I5JCyurfP5a6a3cPt+rX20k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044846; a=rsa-sha256;
	cv=none;
	b=jcHsMakYfwWvN1HbY4Wxx8c3GrwWsXpntrR0EeFThTMEh8aVDjA13F74y0IdeJeow4HCYD
	6FpC3DCU42u44vNAMHCd3btn87ANT4l1GaVmySSZ/kZ0VDRDojtvJm9VYAfqodR8m2ZqmC
	Z/KINvsNa4r8qkU2d90H1vo+VdIyULU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ITuTXaTR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3410942A1D;
	Fri, 20 Mar 2026 22:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533C1C4CEF7;
	Fri, 20 Mar 2026 22:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044845;
	bh=IA23Gy39M2F3BrgjRU1645p2gPCHoKr3S7Gd6stw5xY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ITuTXaTR5d3MLfnoE8tiWvMk3cJVFd3Gn4KFKc27ZUXry5hmpyQELFB1C+kYArpwP
	 E68SqIwWSExdhJKLtwAb8/MnDcxtEzcli+cyl8rEOVXy7QUJttlz4Cs/vtHelyYvP3
	 MhBm0AMFhp9AV1a/Rp0cp6DluC2ISIen3+X7xuRxf5M//eU6B65u8yZDbBBB/9fk5o
	 CzhinwrYTx4Pr2gD4mtFdMumrSj2a/MequJzUXzrkLsZ+sT/qMEvLquBZzaeByDTBP
	 SNOXBPB7LC6GIlWCEKYfJoDyoNHCpxCA98DY3irXB4tVAUChm6T+w8VsIuqcwuBd1l
	 0psq2Gp2a4cIg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:37 +0100
Subject: [PATCH v2 05/15] mm/memory_hotplug: simplify check_pfn_span()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-5-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 050F34000E
X-Stat-Signature: r5adws7x8y4zz7og38rwdfu9ygxzmzee
X-Rspam-User: 
X-HE-Tag: 1774044845-485566
X-HE-Meta: U2FsdGVkX18NTDzuoCWS+y9m+R/ncbz2XY4yderp/zA2UjHJiapVvPDw3OesfKQYbKNsnPkiqPBNcyM/jnhB2bu7roWaK6ZEVfx+iQpTQ15ZZCtzqF+4+sRfBEsoTv9hqNJQucFsszqXSkyjkWQOKMRol/KrW3/8ACfCgqEtwrJyCniBWkM32cEq+HQDjjubU1RNl1TrCWxc1La6htkDD9+6EZJYZ6SF1kx5YYBfpUIGhzcGQl4ppetD69s5EsV1MBU6FalvywvXANCHmk7/PmPTlrA+yZAVNAsrwQTu0eqt4Hqad+Eu+r0FO8+9JHOZImMTEIeup4QzrFT8XdxwVlbtXYhQZsfqmC5Q/r1MCY1EubGMwCkWW4sZNBtqfaAWM1A08nBl1iZHrfMHoMeGJ3qwrWL0h0c5Ve7IG1/gDqHzR9D4Rgm1ylxgJRo64nFD/Na6mTayHBsjuMh+QvmLrbucxZLGX37/C5DPKjEHUD/+Vm5rfHWdDl7sp3+k4Z/gqjr77Pef+MRR3kHBKp7HbiI8yjIQ/2Va3qaZrzXii5Zd7a/xF2E4wr0Wke81wJ+wMEDSbBhvGR/hbEZi5Rt7XUbQHzEWlJA9kdW74x6ngzV91WE+Wo9dMVk9el/A/jjAVvPfxI5pjwBXt0x/DuZsVzra1UOEnXUDQMjhT32DcneaalpM33k93SrySULW2jLSaiaIK6xUsgn9tLKTVoJctp3gNhZcO6uMobb8T9skSQz7YB3NsAR8CvKz6JOEkwh98bxD9oCRRF9oUM1RYYUPSk1CqNXrMibLYUKfHTt0XFtbf9wBFs0PkdRo/0m9U/f9qtyxpISfWPyQONwMtfYoE0FNAqvSK3AZB1cdOuf0aLuS8Aae+0/1xvsUP1vrUzRq/2PUYX2Q5YPohgnMfEKfv7pqbkggoDuhvohmK4X2Cui1yHGeWswfUJHXWPe6440rZqr3bztxV56hnEARj7t
 X2z99JtV
 lR1kUAAwsSHEs7KkmDY1ukC0f7nkfh3lrFQnG/Y923ih4QLIPw8rDGwQZWilVIwKhIx6+mnEC+d759YvSrv0dP1gxQ7pRrQphdI+NrTUoZuT0c3inPcfsKQ/KzCpLj5JuaT+2vI5ToykodAY4XQT7VBTZwnQUIHrZ/xijFGGV0l22jNKVWBCB/ArLNpkKs+4QAvzTpCOZuqT8xrevPN3SBdY1ey6RW/YsZnnDz8ye8g/aqJcCcClRd4+SYhyE9+iKbfccpsWVtpz1ATe33DKvaSHz805BzBci5fJz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now always have CONFIG_SPARSEMEM_VMEMMAP, so remove the dead code.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0c26b1f2be6e..ef2b03eb1873 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -320,21 +320,13 @@ static void release_memory_resource(struct resource *res)
 static int check_pfn_span(unsigned long pfn, unsigned long nr_pages)
 {
 	/*
-	 * Disallow all operations smaller than a sub-section and only
-	 * allow operations smaller than a section for
-	 * SPARSEMEM_VMEMMAP. Note that check_hotplug_memory_range()
-	 * enforces a larger memory_block_size_bytes() granularity for
-	 * memory that will be marked online, so this check should only
-	 * fire for direct arch_{add,remove}_memory() users outside of
-	 * add_memory_resource().
+	 * Disallow all operations smaller than a sub-section.
+	 * Note that check_hotplug_memory_range() enforces a larger
+	 * memory_block_size_bytes() granularity for memory that will be marked
+	 * online, so this check should only fire for direct
+	 * arch_{add,remove}_memory() users outside of add_memory_resource().
 	 */
-	unsigned long min_align;
-
-	if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
-		min_align = PAGES_PER_SUBSECTION;
-	else
-		min_align = PAGES_PER_SECTION;
-	if (!IS_ALIGNED(pfn | nr_pages, min_align))
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION))
 		return -EINVAL;
 	return 0;
 }

-- 
2.43.0



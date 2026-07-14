Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD11BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869C86B0088; Tue, 14 Jul 2026 16:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3496B0092; Tue, 14 Jul 2026 16:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBBD6B0093; Tue, 14 Jul 2026 16:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 324A76B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:51:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6EB01C0513
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:51:25 +0000 (UTC)
X-FDA: 84988577730.01.9613448
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 24180120008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:51:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hr9i5kGg;
	spf=pass (imf29.hostedemail.com: domain of 3SqFWagoKCEEpfodslqvnljrrjoh.frpolqx0-ppnydfn.ruj@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3SqFWagoKCEEpfodslqvnljrrjoh.frpolqx0-ppnydfn.ruj@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784062284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d9tldHgHpDRf8TAZCwFzg+tWQLwf+4+RS0Dz7CW5np8=;
	b=xD86cJ+cNOUL94Z/p7Y8rGrUZ824AV/sdmYoDEF9OYw662N/33/6UKKjKTkxi11rAg2DPF
	kuHt2yioZhWQ4DoAZbFnrjp173uYpWe8ZL1pcDfgQCbJogDWJp4Y8rXsoiOEpbbmO7w9+i
	IniORqK+XLxJ3tCZ/A0UK7x5Q5yvcp8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hr9i5kGg;
	spf=pass (imf29.hostedemail.com: domain of 3SqFWagoKCEEpfodslqvnljrrjoh.frpolqx0-ppnydfn.ruj@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3SqFWagoKCEEpfodslqvnljrrjoh.frpolqx0-ppnydfn.ruj@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784062284;
	b=KQDBkmE2cRuaGsL3v95U1VjjYe3hbzQdBTClBcMMexQ4+/juWRy1MN1yHOumZO/7itjksx
	i/Rj3uuLt2FyDKSupwcjoEYUWWAOBglbEy4QnT3oNjakKpbkVy2Fu3sEI5//iBjgQ2SmQe
	6+iXB5Y/Rkki51+755jKhRCMMWnoa4k=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4926596eebcso9875345e9.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784062282; x=1784667082; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d9tldHgHpDRf8TAZCwFzg+tWQLwf+4+RS0Dz7CW5np8=;
        b=Hr9i5kGg0J0bC3pLhHB2XYhMDkJ7dST1x59rktulxn8oFEwl5L/eN4IGcZMOoCzzlQ
         ZrjKgRZlQofk/yuT29sA2KeO5ajzBUPoUt4BmPSJ6sqdA+E9cs7Zg4baKwjCa2FODwaF
         WFk9KZt9vBC5YhdT5dAMbKm9LsE0+hjPjf84VNcNoSAoMwrSCzbVvqlA8o5BjL+zgMAh
         Ac336P2bXblE0eSDcKWvfgTnQnvZvkeuwD5ZZ3wZ6CEpxnYSFM7fMWYVY+DsGnq9iwv9
         PoVvPh9FZc7/T0sw6GgTV9N3aBo87TI9yvEwpojHt8CfLW03PYZjHtTWw7zsUAkeuOkS
         DzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784062282; x=1784667082;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d9tldHgHpDRf8TAZCwFzg+tWQLwf+4+RS0Dz7CW5np8=;
        b=GbhvuIXYUgpHdQu6ntTRD2/rlyEdewoeB+391RJPf8CRobm8SxPU+m0GDMY57yLx4v
         OSf+NCCp1Nl46blsdl2smV4W3547PV/vOc43ldQttQ8JyF6ULtcRr7a1CbPAPJjC8qS6
         7oPNeYv6PUY2G/XApq6GSUQD514RLy8HsvWBsg9RROHyQSo6oVcsDnNtHmJ269l/DaAf
         DxsDgcjQ+rPht7vXfQpXzJldEArUyl2/0Axr/l3Mp61LAsiwhy+qivo0goAjsg0mYBkX
         kPOyzBJDqKCIwDa956tW1FbMxBXXMeb+KRLW8GaVF/eYmmHGv3/TONrTV0CE8WW08lJd
         aXuQ==
X-Gm-Message-State: AOJu0YwdtXvC+8Bq1QllzXsMPkWtLHkIAmMEd7fbIFFYDDSe82EGxLA8
	t/jKERGLxnj3rsTfM3CMd0D0X0q7QStWvhDPAD6Zw/lIWiileiCwF5e4ldrJJHS4iElfRnU/btj
	/rZiRRVHwWsx1Re+ASWKSAA==
X-Received: from wmkz11.prod.google.com ([2002:a7b:c7cb:0:b0:493:b78f:716b])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f06:b0:493:b9cd:1272 with SMTP id 5b1f17b1804b1-493f881de56mr144831135e9.23.1784062282098;
 Tue, 14 Jul 2026 13:51:22 -0700 (PDT)
Date: Tue, 14 Jul 2026 22:51:11 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260714205111.2497151-1-mclapinski@google.com>
Subject: [PATCH] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
From: Michal Clapinski <mclapinski@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pi8st5ct7w3mdu87yft95beriaw6jkb3
X-Rspamd-Queue-Id: 24180120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784062283-816865
X-HE-Meta: U2FsdGVkX1+IlxjDCTF36OtU/8XxA1AFni81d61YHBqRKNOY0SRlMq08FSn59qwDye1GJI3Vk7QCW3exmgKcBA7i38yjpXusO8a1IoE6GR3TcZDjNvybwQ9ze/wcuF4IlClYpjmncWOOBSgc0B2LAsiTGYsyVsyF7EF4HQHf7+MMdfzwOmfd0IZ1OA2mzbFReZWAsKf177hQcjSeC/v21tiFulq12hiLn/ZgEiYkNwLJSY6R21MfAKb3hKjIrgEl6N5S4rcAnUmk44ulQDkC+kkCv3taOSJ53mn7TBcxGNSrF+15D6ItrHry8aTk/YslOyfaRyMsf8mEQtI3pfhYAoKbLVHYd/JcokgefWmi0zr8VHZN0aVk1Iiab2dPpmBqlfVZxnZKJWfXnvPQJyfW3v+IBkk9MvSOaYy4kdMlkV/6wvEOpgAlh7dh9CPqV3i/GGiP9iw99CKasNhXcOFtdgrMnmjkCZ1sel8rdJZcxrQEncyAgxqFzm4xoXj9zCAZOxCcgA6uyffF3kfSL2X/Hb/wBqLZPY9O+ZQtq/a6/eFH+amJ0yj5lOwpCjtMJZY0wNbpoiIlqlMZ6jmLmjgC4viwHmBHJoNjy0z43wb1Dunt+rRw7HwOqKmyjRNJieEvFKA/z411pBwFIfcGApOCtAWwI1VMb7K0BPvptnCnoezRPxpvS6jtYzEwi1bCEWN0i7zgk8y0yY+TSaModC+Ivk3c8mdlIjt63BrKQXW7naUCb8gbs1CItV5q7yOD1bzesA9yH17/HvbdHwKSyn7ojEzErq35mf+rT0vG20pSIEH540YU6fANcfUF/s8zVRq+qXi4EIQUldxy6ePKVHTwCDGoD99EoQc/cD+jRwFkJzPARCfxrpcaZJosd5W1qmfZvdtCZIs+6vYEPB8xMODo7pSsWW5fBY+yLZD4MaxWZUMslF59Uo1g5QfiWFrYJx73JOpW8s5kPUVhSC9Ch8A
 cAqHr6Pb
 5hl/E+kIdxgAF6riiKWEiKccDuFWmzmNaCcdhPQ2Aq3DfqBQRj2jtXXRfjAFoma/IwwFTNouvFDxfsdTlJgo4aT/KM9iLtHN67CmrQ/s+yUxJVCMcBfNyVhG3r20E0xBBX0unihGUb9ZVIBQWYl+XOn0X1ppk0FZz6hLMD72im9em1UxuLYc71EgoZmL+NHYSOnSoTbhSuupPSRts5mvnCtgM0t0HxfrUE8tSv0EZvAdMbiWkFfFv1uK9Jcm2BVhwkquJytJVQFsVnCFpef2VYsfpBzTsPGHyn390nQiCMZBZDbBwvPQKEQ9q2j4AMmTFm6TqKfXP9TOl9xDa8EMyOb3iCHT7Rke2NJG4ggzAQ38CZmZkbuKAZFlXSR8jimueKNLpmTyEjMdxpjoMD/m1t3bB73JgZ8/xfMIOMwjTSnHVblValT4hcz2c09wKHLUXd9ZHXcO/edlBWlVOqvl4EdZjFotCR0RYKSL+e8RoMEx9kKeLzlXUVXgWbd4BtLIfTN4Wrf6CFATZ0X5tT6VKcc7deBdgPPphgpSeA3ALZslsFNkkEhkyRuQxOBZBxDt7X6eT9Q06RoNkKcL8SaBdTdTrvfJpJ65ah6Wh+oM5zcltuyX0OBpU+sfAIv82s8eAkkQ/LxhereoiiTV3DGlUDFa3UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I caught this crash:
BUG: unable to handle page fault for address: ff19164fffff8328
RIP: 0010:__free_one_page+0x1a1/0x6b0
Call Trace:
 <TASK>
 [<ffffffff913208bf>] free_one_page+0xaf/0x240
 [<ffffffff93973288>] deferred_free_pages+0xa8/0xd0
 [<ffffffff93971b4f>] deferred_init_memmap_chunk+0x10f/0x1b0
 [<ffffffff9396e265>] padata_mt_helper+0x65/0xa0
 [<ffffffff90fac402>] process_scheduled_works+0x202/0x410
 [<ffffffff90fae739>] worker_thread+0x1f9/0x2d0
 [<ffffffff90fb62fd>] kthread+0x27d/0x2f0
 [<ffffffff90fae540>] ? __pfx_worker_thread+0x10/0x10
 [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
 [<ffffffff90efdc55>] ret_from_fork+0x145/0x280
 [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
 [<ffffffff90e2e46a>] ret_from_fork_asm+0x1a/0x30
 </TASK>

deferred_init_memmap_chunk() works fine without KHO because free
regions will never be neighbors. However, with KHO, free memory
will be split into (free && scratch) and (free && !scratch).
KHO scratch is aligned to CMA_MIN_ALIGNMENT_BYTES (which on my setup
is equal to 1 << 9 pages) but buddy can look at the neighborhood of
MAX_ORDER_NR_PAGES pages (which is equal to 1 << 10 pages).
This sometimes crashes when one half of the neighborhood is being
initialized but the other part is yet to be initialized.

To fix this, let's just align KHO scratch to MAX_ORDER_NR_PAGES pages.

Fixes: c6073743d0c7 ("kho: make preserved pages compatible with deferred struct page init")
Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
Unfortunately, this is very hard to catch, so I don't have a good
reproducer. But I run the code with the fix through extensive testing
and it seems fine.
I think I've never caught it before because enabling HUGETLB is what
causes CMA_MIN_ALIGNMENT_PAGES to be 1 << 9, instead of 1 << 10.

If this passes review, please cherry-pick it to 7.2 so we don't release
a broken kernel.
---
 kernel/liveupdate/kexec_handover.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..50928aaa3371 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -38,6 +38,16 @@
 #include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
+/*
+ * This is the minimal alignment required by deferred struct page init.
+ * deferred_init_memmap_chunk frees memory to the buddy allocator, which looks
+ * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
+ * If KHO scratch is not aligned to that value, buddy can access uninitialized
+ * struct pages, which can cause a crash.
+ */
+#define SCRATCH_ALIGNMENT_BYTES (1 << (PAGE_SHIFT + MAX_PAGE_ORDER))
+static_assert(SCRATCH_ALIGNMENT_BYTES >= CMA_MIN_ALIGNMENT_BYTES);
+
 /* The magic token for preserved pages */
 #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
 
@@ -640,8 +650,8 @@ static void __init scratch_size_update(void)
 	 * Scratch areas are released as MIGRATE_CMA. Round them up to the right
 	 * size.
 	 */
-	scratch_size_lowmem = round_up(scratch_size_lowmem, CMA_MIN_ALIGNMENT_BYTES);
-	scratch_size_global = round_up(scratch_size_global, CMA_MIN_ALIGNMENT_BYTES);
+	scratch_size_lowmem = round_up(scratch_size_lowmem, SCRATCH_ALIGNMENT_BYTES);
+	scratch_size_global = round_up(scratch_size_global, SCRATCH_ALIGNMENT_BYTES);
 }
 
 static phys_addr_t __init scratch_size_node(int nid)
@@ -656,7 +666,7 @@ static phys_addr_t __init scratch_size_node(int nid)
 		size = scratch_size_pernode;
 	}
 
-	return round_up(size, CMA_MIN_ALIGNMENT_BYTES);
+	return round_up(size, SCRATCH_ALIGNMENT_BYTES);
 }
 
 /**
@@ -692,7 +702,7 @@ static void __init kho_reserve_scratch(void)
 	 * next kernel
 	 */
 	size = scratch_size_lowmem;
-	addr = memblock_phys_alloc_range(size, CMA_MIN_ALIGNMENT_BYTES, 0,
+	addr = memblock_phys_alloc_range(size, SCRATCH_ALIGNMENT_BYTES, 0,
 					 ARCH_LOW_ADDRESS_LIMIT);
 	if (!addr) {
 		pr_err("Failed to reserve lowmem scratch buffer\n");
@@ -705,7 +715,7 @@ static void __init kho_reserve_scratch(void)
 
 	/* reserve large contiguous area for allocations without nid */
 	size = scratch_size_global;
-	addr = memblock_phys_alloc(size, CMA_MIN_ALIGNMENT_BYTES);
+	addr = memblock_phys_alloc(size, SCRATCH_ALIGNMENT_BYTES);
 	if (!addr) {
 		pr_err("Failed to reserve global scratch buffer\n");
 		goto err_free_scratch_areas;
@@ -721,7 +731,7 @@ static void __init kho_reserve_scratch(void)
 	 */
 	for_each_node_state(nid, N_MEMORY) {
 		size = scratch_size_node(nid);
-		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
+		addr = memblock_alloc_range_nid(size, SCRATCH_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
 						nid, true);
 		if (!addr) {
-- 
2.55.0.141.g00534a21ce-goog



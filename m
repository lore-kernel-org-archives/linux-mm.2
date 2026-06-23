Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2756CCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E616B0093; Tue, 23 Jun 2026 05:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA8B6B0095; Tue, 23 Jun 2026 05:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5E66B0096; Tue, 23 Jun 2026 05:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E95896B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:24:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A2AC140418
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:24:23 +0000 (UTC)
X-FDA: 84910641606.04.C3A965A
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id A290720002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:24:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cGZ6v4VY;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206661;
	b=iOk6p/MG6SWVPBtEnvXtyKwPTQwu9lGbqmPTkkEJhseclih64x8vCeI7MyvoZh+gnUnY9B
	2qzLLrUP3FyIfaBiqXPjqsLxHomsWZOZdE5XbvIR93B7SiwYYNW7YNGUOR+b+eCw2lL7Gd
	bqC7X6tn184rJT+Ixxi2l/YQ2XJo/SU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=h1js4iTIk2T/KClSyxWwkjP+L1YbVSXomlj6I6PanWg=;
	b=SQlWNZ3m4hxbyl+atC4ZzDZr9LFILp7knMgT7U1ga+29FEb7dNJfb3aKYOIeabVJEKReiR
	C5JGHGYB4ea730GkMbq2+CVRsXoFlAI9n/I7MTAtFL3VcEeK7M4hm6/1o3PeA2ilsYwzTC
	uK4bNFOkvJvZu1bJL0BCOF2yGRUCbGM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cGZ6v4VY;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c029505b389so143529166b.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782206660; x=1782811460; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h1js4iTIk2T/KClSyxWwkjP+L1YbVSXomlj6I6PanWg=;
        b=cGZ6v4VY6Irz2DIj+bupJXspv11WWCQnmKWHd1Gio3YOt+wiiSEIbrX8gZ1anDmFoc
         AGjCJvt31s/RUbwLZcrtZwMrwiN+XPo0/JJVMeyA/e/HB+Tv5YKE/3Ahag1CTzjbHLr5
         fu+xfro50D20KZjOKnHf19bDLslK46+upOTpBV4jc6k7309zMzvQahcfWe9qO7QkFijM
         DQYXzDLNRbULpf2F23PILmavvEwpqoRZnYoem/+CFdPTfj4J8eZKUjmMt+2kXyUE3bCp
         wQYYF1G0L6mbazlH7R/F3d+00OYtrn6xtm6x7mdyMaVjcwnos7poOMYKEnjNY9M1Eglg
         VUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782206660; x=1782811460;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h1js4iTIk2T/KClSyxWwkjP+L1YbVSXomlj6I6PanWg=;
        b=aV3pCOT4okljd27Mt4LRBrXuzftRh2tGKqv/G0Te69ZlAwosP6iWNOEOzCT53BKJgw
         9qCv/Ao/PP3iA10hYIr/0DqUCxxM2l96HHz2spHFyIqznZ2v6H1BQUKCzgHA1JfiZ9OQ
         yAaNxvp1jfsxKh4V9jO/N7Ze1Ohbvds2vtea8piK4SfTvZVmiaakgmYYfW1dk2seyzVk
         j0lWxI47IWbC2EB7SDZ7xhYFOmX/BsZmpACIXQdhYn2kCCqDAL52hr7jl1vt1loD6DGm
         mrsq/as3w1/ksPMyu/IbDHqvl4aE7axh2VSFbc9XbowLy7yGpGKDOF9WWT2B46rJopa1
         Nq9g==
X-Gm-Message-State: AOJu0YxlPyPgBDzYZi4KlKEsKNqQllGWhQjvUp0Nej3LC8zZK4jXWp3E
	/FOMG/crfOj6P9j/snX2OqxmhPh/mfBLkQJ288dduwD6BpJmRrPp9Nu5
X-Gm-Gg: AfdE7ckr5k85OgpA7cTPHKxT45M/pDJdbJsw6z6ga/hQ5TzotaA9ZKdCF/7Gmzl1nIf
	zy5v062iecSh1X3ZBlOQMo7mJEu/3S5VaImaKmYFNJ1ftlRVGruupwK34S1bEIInQEd10Qu4MLo
	Mw3rF+cUQnyEa9dHHRvvcQ5GcwT0uNSyWfsqpLku7vZU96NG2EW1eoQn85gajz80d0ZFQLNdJ8T
	+wAzrRqcpoTp3F9ilMAd1A9L47BIbpgWCzekAIlmoS7tXgcaT8OGYOWe5nzsZD9f1c9sx4IaOcH
	lB7GUR6GYXZYSwiy5Bfs+9pdbFvlT/CboN18EEYUYYwzT0ZZadxgCFWKB1a7nZP4ZtK3K4hIMH5
	f1FZFP0ATSp2BmoxJrOZamyZxGFICYlnQMfVeh777ziN8veDy9xsWNbHVV+cv5FjhXfcqhnhpJP
	+TYO/O+fhKnRU=
X-Received: by 2002:a17:906:9f86:b0:c0d:7c31:26a9 with SMTP id a640c23a62f3a-c102faa5967mr165140566b.2.1782206659723;
        Tue, 23 Jun 2026 02:24:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c6161ec94sm479276666b.59.2026.06.23.02.24.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 02:24:19 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	izumi.taku@jp.fujitsu.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	yuan1.liu@intel.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch 2/3] mm/mm_init: remove overlap_memmap_init() as no overlapped zone
Date: Tue, 23 Jun 2026 09:23:50 +0000
Message-Id: <20260623092351.13031-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20260623092351.13031-1-richard.weiyang@gmail.com>
References: <20260623092351.13031-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A290720002
X-Rspam-User: 
X-Stat-Signature: tq9jobb7quo4fabwnn3ecakdnzjxoosn
X-HE-Tag: 1782206661-223594
X-HE-Meta: U2FsdGVkX1/U0DifXrFAi8K0O/BGVRI5KYGGKhvUAGr/0X4+RkrbrZ7BxkOVLvXHBnyN0hoK7jOojxpoMbpJHsJKIo7GF5AHtXACIOThdtRzEyizHzxZMbNUkySpaKh6i/5LRfd4mPVCJcAEnQoT7u6UraOhGfEtgThv0uHr22z4dSxx6EMoTks/WDbY3JOVN4HYpFWOP62cBMmGtfNfhaUsVMoT89lpOU6GdmqgIpLiMAvpQRyJVsbV1bfSA1kFzz6tB6QksN6+JLEo3OPQYX+mS/ZouZijM1sD1KSXXTGuHjdG1pTSMeUKeksLQSSoFk2Jz3nP+emV+KPYIQK3vLrHZTWVH28CRklEIWaBMX5JluMlFhqJAfJ/XWllVrvailrMNmman4ot2tHbbLcGHU60f2PUg5GIaHJhf2Ct78S4OBaqDBTBvXNemsR2ULdqtNIL9axhVcyZPQzf2q2GMs0ryS8d+wMZhRa9k8c/OjSCHnOeGaEyypwfd4fqlm08OH1sRVRuMygNSwyUWbUiwfq2k/WCRm3I+aWfmXGxxwJiaRZvhlIVOh+bKoTiVTERlodOxdzEMtNs4z99PHGsdFGr6v2VMDz6bJXfcM3UX4iGAQCiQgXtdcIgwoFft+0CgPp4OV1j9di0IUj3WgCuTLPcNBBBPV6sBY+xIzpe7G7iHMGgGRW1Wmsb3HFBxNAk9/1zItltes2wBYQf31CJtU/GLUjtMbhgRaHfQhLKaXjzEMEhaxFuurznDECSIRMoZU6uythFg3Mw1oyDmns2tS0jlAN/gf49GFHWu6Vf05DQBY9SIR4FI53PYBn5g1mS8C4mEzBKns8m/ReXnqz0wetEf3XPUwzYvXZtcrL3C4wBTSObhAB+Cly77JXKw1OsgVqLOqGjn+vwiCplOqmPmrxaMD9mpwEFvveayc16UOCIFEY2L/2b1c3qf5nrqyDqP1CpvTw1breffJfnUKj
 1Dmo+IN9
 jbgY7xdL4EDiYSDcSycE5MsXRnpF2Jtop+dx/YaEGYDAF1lxPxKY97XcXUPh22/4FCX1vlUsGEJjJHjFRCQAk7zJIBap5+VOmH8RagcvD2hUQ0GYYofSnG6jO/mERe8yeAtOTAScET0YLY+wgy2dKXhYI1i+N9PFlzgy6c8nKIo1TWcGBu7l2P5pu+0eDA5Mdt+/y0bxl+Tz1cOtczXGCooI9D29w7f8Gwh3557XZjexU0IWhKzEwXZrszovk9TpzwaB0DEqfNNRTLwLi/YmGsg7/3Jxd2Mk2ErpCfniU+kFd+8j/p2pJMqWTpz7lcJDkMsqsbAl4YL42l0HBN8heCJPYWK1kkwGc3t2dhBKA8gfLIYxOULwxYNKmel3i8UOiFLiXtuBwuaUM13x8+qEvM55SC1ythMKTjqGfiJ/mHD2SOJFFvd/0VmNdCLoIVsv2sgZNiIcxvA92NCnGkLtb9hhkf6ZJQB0+bU/iWitYUlTd7HEfuN8pL42+h8wbI712sNlOr6rdVXV9jKM1Zx/knlVM/ogc42Lr2F6GE70IUcF6FFx68xEMaeZWQIVVXYu11KpmqzCJaMfUuP55e6jwep/V4kclGdzNZPRGZUVHdYuR4puFKvbAoL2pgvvr9gnl1cnD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When commit 342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror
option") is introduced, it would have overlapped Zone Normal and Zone
Movable. And this original code would initialize overlapped range twice.

For example, if the memory layout is below:

  memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x2
  memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x2
  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 0 flags: 0x2
  memory[0x3]     [0x0000000140000000-0x00000001bfffffff], 0x0000000080000000 bytes on node 0 flags: 0x0

We would get Zone range with kernelcore=mirror set:

  Normal  [100000, 1c0000]
  Movable [140000, 1c0000]

According to original logic, during memmap_init() it calls
memmap_init_zone_range() with the same range from
for_each_mem_pfn_range() for each populated zone. And then clamp the
same memory range with specific zone boundary.

  memmap_init()
      for_each_mem_pfn_range(&start_pfn, &end_pfn)
          for: zone = ZONE_DMA, ZONE_DEVICE
              memmap_init_zone_range(zone, start_pfn, end_pfn)   <-- same range, but different zone
                  memmap_init_range()                            <-- clamped with zone range

For the last memblock region:

  [0x0000000140000000-0x00000001bfffffff]

It belongs to both Zone Normal and Zone Movable, which means the same range
would be initialized twice by memmap_init_range(), but with different
zone_id.

Original code is expected to skip overlapped range with
overlap_memmap_init(). But it only skip when (zone == ZONE_MOVABLE), which
in turn has no effect for this memory layout. So the last range is first
initialized to Zone Normal, then to Zone Movable which is what we
expect.

After previous cleanup, the overlapped zone is gone, so the
overlap_memmap_init() is not necessary anymore.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>
---
 mm/mm_init.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index b8ff4aff19c0..da0e65bf8d02 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -797,28 +797,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
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
@@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * function.  They do not exist on hotplugged memory.
 		 */
 		if (context == MEMINIT_EARLY) {
-			if (overlap_memmap_init(zone, &pfn))
-				continue;
 			if (defer_init(nid, pfn, zone_end_pfn)) {
 				deferred_struct_pages = true;
 				break;
-- 
2.34.1



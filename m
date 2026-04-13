Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AAB2EBFD37
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748146B0092; Mon, 13 Apr 2026 06:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1B86B0093; Mon, 13 Apr 2026 06:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BEE6B0095; Mon, 13 Apr 2026 06:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 425A16B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:47:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3F3DC02F1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:02 +0000 (UTC)
X-FDA: 84653205084.11.A81E431
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 56048100002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:47:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M8TniFZa;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776077221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fs0n/OzFNeckAueC8LfWfTlLTyUX14LcR/tRI0bUDF4=;
	b=RoALd/4dB+JO15mOB5PoL8yzjytLf/zPUQLvTV5bcbyzN96fkOY2T3+MuQBFKIOSbnTrEk
	tOi4XnA6FN1QlLmkYGKmCbxXwwSQnOB0IezdBEbjUPEtbEebdPhontWDQ6LSRAeDTVRD9M
	0iM1hZ7db0yjsjPhUZ2q09lDKJ7cQ8M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M8TniFZa;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776077221; a=rsa-sha256;
	cv=none;
	b=OV9z4geC3wwJ31rtvu5Pp+EV6CfIt9hMM/vECxye521PA79GiQUCpyx8/YI3TY6xxk0P49
	+J3PhH/8h3votP1sntZSu3MbazMIJmXEC0J+fPvvJ4a3lWcuvI42A+/nNKufSV9Ii/Dp3f
	IQjZg2qwdjLYrMFAAKC27/ogXtXuOqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CEAF461333;
	Mon, 13 Apr 2026 10:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDEDC116C6;
	Mon, 13 Apr 2026 10:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776077220;
	bh=81EMB7S4o9tzdPXH5l/vEk9ZCs4EQ+KrdDzyhygI3S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8TniFZaI+x3/UeKRImAcLzg05X5Z/Niv8RknnIWDxRcj4apBbDyDrZqPHiLyC2hM
	 U5nRZpHixLzePeFPfOkZIFS9jqbM1ZGhwJsKfRvhHzXnduOofWD3AlNzC+DIefYJtr
	 DpCNBfeqasmeK/oZoxmqihOzmmqluyJvDXF2/f2nOYlBObqoYVDFpJG6EMjFIrkIYV
	 wWzTokZcPllpst35SXuHotxR2BD2ZVRc4H2XpF+8Cb4+tXKSeG+2qZOkyaitKPdBZU
	 B91GRHlveCunXlXYMFMdBhqUTArsa07KgyofEI0XZxk6WCLuCHF5PY4id6PsHSuMza
	 EbSKxzUI79cuA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Mike Rapoport <rppt@kernel.org>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/10] sh: mm: remove numa.c
Date: Mon, 13 Apr 2026 13:46:40 +0300
Message-ID: <20260413104649.852228-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: btrsb931q8oy8axc1oiys6jgbw4o5rhj
X-Rspamd-Queue-Id: 56048100002
X-Rspamd-Server: rspam09
X-HE-Tag: 1776077221-468981
X-HE-Meta: U2FsdGVkX19vvN85LLC33Ywf4WpNU22cLd4uW9YjihEhHKcY+2VBBgEG6p+JcJecjkrgLS4fdWwzFYwae1RpPtVMDNMQE0wIPRr23ksvPIhEwiTDsQv2LkhpBWdQDE6Y0r0TqoRDgg8wiMd6zcxE6dltsItsVJwcjjW5iQYV3dkUg+/+5D8O99cJyhit7kkeDHic6OUhNPWCPGCQ/llcCeFxzEDWoaTKRYN2YIJ05pBDz4mY4lPNoi0aFzWRlEqVSRuoBi6Y5RtP2mjy/OTyPkpLEIlKIOzd0Dqo8UcoIjBAH6C4IpSyq+qUE2pS0WFMUu2VSvPduVgqoQRGOVGvB31j517QGxJSmJzqEy3B1BQzUGO3vqlgV2K7puSG5hXwjbe4pdQVCAOPqlP0XN03oVJVyL+0EVhVzz3IlgIlbeCnghfI3zGcmpjtFOfIMLwbJvEtjxMoz8UAExQE/bgdSGrL+i1U4F2SwoiQLr3w1Sw1eOj7gbVYOOW+CKnuTbLORt8IfbmDhYji7UJaumjZ/UvkK4hP5THGLNMLzJcYlr7USRq+tMZZd0j7FM2jA1+j2Gp4MNKHhOBamxvVGE0AvdzkdyKIQCY+UOUlXYOX1wcX+gb2gb4/R3QIDD0XYJfsDI731ODMCywSjaHaA9WyKwQ+G+gu4Mrqlui0YMujvEE7ZIL12vSZ4bACooLgKmpBSs+np5SYWPFk6KpuvVJl28YHwdmzGrUCAoQno+JLatftlXwmojL9xjbu8hZ7fT/nCM2X9/Z7pyHRrf8kk+YriCJwaHuojnJvIHTTDAPdjPF4ruZgwlHgNdVExUo6uMgfEsPEGlJzFB8U5rWRmtbfYCFA3Us/hiWPv1x1iq5BpLDPyJVNRBIwWlaIVfKYmBhaNV1vSt/3FGCZr5H8m7vBB2Dj9KFrXBlTj7FcV982EZXJVe8B95hu0Gt81RDxh+RFZo/gN98f3qdQycmdPkx
 HONfFeLm
 Q/c+o1GdEBkqkqopj5FnrOLc22fXX5TUvgk7In30MMuPzTLAVIJpVJ+5/bJpdJnXPVKtmxoeNAw+IxPd7TIWW1jFTUktDqo7o9ziwopMeuQxYtOf5HBx9qWRikiEJOCaZ8NA0ThSDELaLmgSXSdNx1S5AfN6Br3t/0c6qga44zeLjqi04CKSS6nEpnVLlrpVyX2X8brjYM7TEuvW3BX9IT+p+ili6vo45yIFJv6J8A3ZcfhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since CONFIG_NUMA is removed, numa.c won't be ever compiled.

Remove it.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/sh/mm/Makefile |  1 -
 arch/sh/mm/numa.c   | 53 ---------------------------------------------
 2 files changed, 54 deletions(-)
 delete mode 100644 arch/sh/mm/numa.c

diff --git a/arch/sh/mm/Makefile b/arch/sh/mm/Makefile
index f69ddc70b146..7033947955d6 100644
--- a/arch/sh/mm/Makefile
+++ b/arch/sh/mm/Makefile
@@ -37,7 +37,6 @@ endif
 obj-$(CONFIG_DEBUG_FS)		+= $(debugfs-y)
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_PMB)		+= pmb.o
-obj-$(CONFIG_NUMA)		+= numa.o
 obj-$(CONFIG_IOREMAP_FIXED)	+= ioremap_fixed.o
 obj-$(CONFIG_UNCACHED_MAPPING)	+= uncached.o
 obj-$(CONFIG_HAVE_SRAM_POOL)	+= sram.o
diff --git a/arch/sh/mm/numa.c b/arch/sh/mm/numa.c
deleted file mode 100644
index 9bc212b5e762..000000000000
--- a/arch/sh/mm/numa.c
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * arch/sh/mm/numa.c - Multiple node support for SH machines
- *
- *  Copyright (C) 2007  Paul Mundt
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-#include <linux/module.h>
-#include <linux/memblock.h>
-#include <linux/mm.h>
-#include <linux/numa.h>
-#include <linux/pfn.h>
-#include <asm/sections.h>
-
-/*
- * On SH machines the conventional approach is to stash system RAM
- * in node 0, and other memory blocks in to node 1 and up, ordered by
- * latency. Each node's pgdat is node-local at the beginning of the node,
- * immediately followed by the node mem map.
- */
-void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
-{
-	unsigned long start_pfn, end_pfn;
-
-	/* Don't allow bogus node assignment */
-	BUG_ON(nid >= MAX_NUMNODES || nid <= 0);
-
-	start_pfn = PFN_DOWN(start);
-	end_pfn = PFN_DOWN(end);
-
-	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
-			 PAGE_KERNEL);
-
-	memblock_add(start, end - start);
-
-	__add_active_range(nid, start_pfn, end_pfn);
-
-	/* Node-local pgdat */
-	NODE_DATA(nid) = memblock_alloc_node(sizeof(struct pglist_data),
-					     SMP_CACHE_BYTES, nid);
-	if (!NODE_DATA(nid))
-		panic("%s: Failed to allocate %zu bytes align=0x%x nid=%d\n",
-		      __func__, sizeof(struct pglist_data), SMP_CACHE_BYTES,
-		      nid);
-
-	NODE_DATA(nid)->node_start_pfn = start_pfn;
-	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
-
-	/* It's up */
-	node_set_online(nid);
-}
-- 
2.53.0



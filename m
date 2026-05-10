Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA3CCD37B9
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 13:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF846B008C; Sun, 10 May 2026 09:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9708B6B0092; Sun, 10 May 2026 09:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812036B0093; Sun, 10 May 2026 09:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 710DC6B008C
	for <linux-mm@kvack.org>; Sun, 10 May 2026 09:56:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1435F1203F4
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:56:01 +0000 (UTC)
X-FDA: 84751658922.06.5881245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 85708180010
	for <linux-mm@kvack.org>; Sun, 10 May 2026 13:55:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SvTRL/9E";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778421359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w715WEKCidGp64LTlUpNGp1NpgF0wrbTOThSEf9PhOc=;
	b=KUd+lA6SJJ24CbV2yJ5O3VwvbNw89WoCMg2TC4vCAJ3cZIIju1n++zotfw1z7xEC96tHAx
	Z183TEInpfk1KDpXjBWXgMWEvORoTeKdOV20s2ttSDTt58hWbD932rk6jaQCQyJv1AKvAr
	DO4EwLXnYFkt6r7Mz8z9MBlOGp3ScpU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778421359; a=rsa-sha256;
	cv=none;
	b=BHU3r9kjwt/k5IJu9/CuUS4QEeaLz+ZeCl/Q5+KrEvsgqOtw+ULIkiH8a+kEyYGC2tWSNI
	jN4WJUNZGlLWApEbTVj9YuuVmY72j2xUjnc+SYH+mGzDDV0FkXdJGlyic/A7AiZP9SXqim
	W3DxNhmsACFzDXMQYy/XL+fv8v7PrCs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SvTRL/9E";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A8F460129;
	Sun, 10 May 2026 13:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACF4C2BCB8;
	Sun, 10 May 2026 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778421358;
	bh=rmDupBOctIJ9BKC2nX3b3eQmWjMWgjh9aoXPYqNNTOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvTRL/9E2WMo2CU4KU1DpiM+fNYf06eQFb4Bk/0BeN/63va5BvvKmVMgw+j19bdMs
	 jtxMqXqDzc9gWaNW5PkIFHqX0z0HIXMTAJ90tikpfsvAnINK4ayvmaVjV9n7kwmHeW
	 lIjfWBkCiqHfp9EbY6D4nwKUHXW4yV/P37jlHH8X6EYVSQdqz7gLvr/rKkh8AxMykB
	 +av2+0VgzgY0nhe/veyCAUno/Uzn5/4xaQpCzNfLhQyI8D1LgBhpbt3v5uzSMEpIxv
	 kF3VIb5224P2fx4WgndwSVy+SU131GuBVXRZMNtkuJRnUwlW4XifgEx9Ywdq+looct
	 ThVlg6BCxMZTQ==
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
Subject: [PATCH v2 02/10] sh: mm: remove numa.c
Date: Sun, 10 May 2026 16:55:38 +0300
Message-ID: <20260510135546.13554-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 85708180010
X-Stat-Signature: 9a7hww5ytkzg5qit46zxresi883eakz9
X-Rspam-User: 
X-HE-Tag: 1778421359-242917
X-HE-Meta: U2FsdGVkX18ktyu9KRaMe0beupBu9jkH3mWOLXEFin6kES/1KX1rEaxiMdxNcXEzPom/2WAUZ5XqLMYAO0y9xMlTKTHqeV5nvFDGYybdZ2XKL20rTkA2z4YAWZ+9LnzVoblGzC/2jNnrATsrsiEXFzDxjlFaZdHZ9rL565dEVd8CNNjqekGSyqG8yEYrg1aqpCmU7JwD9g9mjwghx6wVnyc5cZ2vMhgF9pLm4pPkA86mS+eUKTufgMKXXnce5ztd1Y6pThJNQJ9tt+QxXdhocf/3xkk98ywN7yJgTM+BqgfClKjBEH1UlRtQeQbVPZTADCiqSpDsRuiClymVsMhWcFDcbrterZXGeqaAq3NC4QsjrGI1qgPuNt6XXB9CuFq+HRz134rSaUP860nUh2kZ477QDtBiHuWc46Pz4kNMpJsjFIN273Bz1XerFWOaNy0e3ZuNSI4B94X/AV0no9dez+G+UJaFmQ0LrEOFs5mtrmEjwhH4K9G088IMy6mV/EfBvrF9zjrZsAks+VdpBaOL0Pv4diadmiU4zhOg/OsGMBVQtx1V4NnOStJvpg6O9sGAz8rFD7K/PrFo9kmGhj7bIe7w9FFg/Q45JOYci0e0kb/XJxIdATRIr3Pl2xR/s+qpxTuHFdFGvsd7Ob+ux5vAIvsW1IWeP/25mcfAeJVuYMAtmGG4Ay3X6AZZpyFjgiul35zYUrQDtj1vgPLn2xC+rFPYsSnHABsvFsnkm/jABB2JrQw2khD+9efBtWcX+xQAwZlzupbbuYJhXPcPQ1HdPeBpk3dF3Tf3U/9arFcMT16kgCCEfN5nsEsb/6Iut8vV2E0LxlN4puSKV/MDanihCbbw6ufgoaNb1+3s9Vf6+xS4SGBMCR2UDmgDz3v8xeY0ERY+FxTg76seZBL1sk1BUyVHbhBmnqSpF4Tyz/s3Y2ujMD4QjYKj2tFHGOho44uhUMG1y3C+sfwS+2JQgMB
 pxKTcDDA
 Uz6xAdNMDnxF7UHEzdDB/k0kyJdeK6iGEdNHCeI8XXWtX6pcAdi4AaQIJrJy9uNVSsDZTUswm/tyH+VwLbkEanbwPNRtUnW29JDQfk+1+ttVFv3IWDFSEUBnjQ5MtPAR83TJTMR56ro5+33xAYFoScOBdfBKl9yarqkJrQSGptoHHfVu4CIcHiBXZggKryV6K6irQTdCgZJxNqPdKVMn4ZoFM4VCyl7wZc/vgnXUVEdu4qA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since CONFIG_NUMA is removed, numa.c won't be ever compiled.

Remove it.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
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



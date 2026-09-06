Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB2F7C79F9F
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 14:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8659A6B0088; Sun,  6 Sep 2026 10:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0DA6B008A; Sun,  6 Sep 2026 10:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8926B008C; Sun,  6 Sep 2026 10:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6036B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:40:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF27B8055D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:40:27 +0000 (UTC)
X-FDA: 85183598094.28.9DC3370
Received: from out-utut-a193.jellyfish.systems (out-utut-a193.jellyfish.systems [198.177.127.193])
	by imf30.hostedemail.com (Postfix) with ESMTP id 023B780004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:40:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=fGDW8m6X;
	spf=pass (imf30.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.193 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788705626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SYRNVojqsH1/4lhtvXeoKfo9GZcaHz/Gw1aGpXQnbRw=;
	b=aBj/w5r5tJ/mFY3UG7X6Lp+PJzdQa4PI8tH3PQq6jioyHKq3soY+dl+1Tb70Z0W1X3SGRy
	5XTQDPjneVpY0ZK4cyJRZeSTmW/qmLeC7br3u6lWd9kltLgE+A5S9GjZ6zQbCNo+RI5Ta/
	qglIB6yOqEr3zuNyuhDuwY9zRrZ+90M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788705626;
	b=CS6fVYa06Q3+TUcXPsKuTmqbST4JY4ZN7/ZhLD8DdEak11OKCIOEGT9oEXnBt8MVQCDWkW
	jst1XNpbIZzRMiSmHvKTK8Qs9tgRiKnOg5TBeNbySHgkx4uFI7hUPuT8+6w8hqhL/wn/yW
	5VcH8kaY9JZHJMK5Fjq75KWPZ67zlGU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=fGDW8m6X;
	spf=pass (imf30.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.193 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hdCY16Ffmz2x9q;
	Sun, 06 Sep 2026 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788705624;
	bh=SYRNVojqsH1/4lhtvXeoKfo9GZcaHz/Gw1aGpXQnbRw=;
	h=From:To:Cc:Subject:Date:From;
	b=fGDW8m6Xr+gZafIZuxWKLTwCPXyapmM6OTOGl5Vdf0suRyflErkMBFPCVjtcYz1CG
	 tdh1SDYBHPUlM3bl3WGDk0xQhOpMAK1hBBdw34MScuNLx+LA046CeoZTOwaCiwqfv0
	 o8G5z9vQRBLKDdMjE8Cw7Yv7cURciHU4jOlVuVqqOEnhjeSrNE0htQiLDXAmjdkN2V
	 hIqY3mNOmbbn+mlK4+ArpIfcvGJGV4W5qBinFNqq382ijoeryh4KiuwCcD29U/vVtn
	 6lV6UsMIMcs8obFJLmGIYSIM5lCSPX1VkgDZ/N0geJ2OTpaoSKLyMSJGat9tCeFDVg
	 2zfaE2crbOmaw==
From: Tianyi Chen <hi@tychen.cc>
To: rppt@kernel.org
Cc: Tianyi Chen <hi@tychen.cc>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] memblock tests: model the low allocation limit within dummy memory
Date: Sun,  6 Sep 2026 22:40:10 +0800
Message-ID: <20260906144011.848898-1-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 023B780004
X-Stat-Signature: x39j9jp1zzo1xt9zgfdzcmuzcde5zayo
X-HE-Tag: 1788705625-332875
X-HE-Meta: U2FsdGVkX1/ueKUsTUcyhHIRmMjoJZAt3kqncnQ+wsVy6nZd7xIPrBEAtOMdfhiFocx8cOBJu0qhTbYhkZPApnKnQdpF0SoZxjIkjWFpMdyTit+3Hb0cutQYdQ9CAv37bX35yxd1F78r29hDHWYMKh45rW/071nU1/sqX8JgnqmreULqSmq5XJ3SGcAaQxrB7MNoamhr6kPXkQD4aNr2nuSAbllzv8ZrzQmbI5Lzqpk8ogsqgM5qv7UnViDv/reuTG6k4O7kOGi/cdWn7aNY5YO379XxoBwSOpzTGlgXAMAckk7a+cFKuIQ0zKJuGnRijpFQLFiyO3aVlKOKeO1Lnu2hqKAq+UYAunLNiqmjp/O6nyjBr+hp6kES8ktBCYwEhZtMWJvZeGz9Ui2he33Rd7wjplKqrLuo4eI9TN306zRqF5dY15kKbjr8YiwoQ0+vo1yJBbERbqPo4JFwF0+WKfZMKwrhBlzc2KVfwcnahI8fw3H6Pd2vLwEqNLyPs+WLGkjjyI19/5fCSQYCdgYDXFqWHmH4OzsjiiRsqJZ0VO8ZBQliofRSa37sSb6o5FMeIozgNjxVtug9NEX4SSfY7xpfQTvmJfuo/Ul8KF1nW/dJ8TmMWqY8GnPzLai1TiZ81ymyKsn+U5N3VjyjIH79V0lmqFl7JSKhhcgcLijJPTDFPLxRtJ8A0qAf6EfY+WSmypEsBdFPMVD3ThBG4tV1JlLwQrqL7X6CwKGIQqPMmkZG5fbQZMB0Mp50h0fOc5PxPKlI+8LYbRFgcSCjOT1fxBp35qhcOtov5G5VSag72pdlGmSBonYotvn4L7ay0ZEq5j2yFSUMLm9OX9yfoR5a0wESD556peuwgCjE5Agdnhd5XgbE0vIbcStHJojjdrIr++gthb55gYbxBV5WzMKYdy6zHMcMD0JzcJfsPhq4ZDx4p6c5MKEo52PNSO/MeIYadpyMqtwnlObcbtwAEaN
 ZoOO71Cl
 GcQpPUdB/gL5FTPb8JVl+jOVg0F0TR1vpk3n01hPjXo7d7yYBNJgZ+K4/oTfWdDC3SYpgFvKqWERSrtf7mu3qemgWnZiOvcZoA5BCKCzUl43Tg+tCiJuWRhU4audlg1szSZnMglig6hBxIDSI6ucupXKmJIwwYZZpx50qhy0xsutVsqjwkY4C81mmYbZpDGReU0racyQi0+Ib+wYo4nnOcozeE43nRQyLwmVvnVmJ3CuTV9Vq9Ghmzj80btP2SWBu2G5N7NJxAlV6KUpLqzTAnvV+w3prACwWo3T+EHAWkD+XRhgZQocyrdFu78nQr7CXoXSg3690e8rjTes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The simulator represents physical addresses using the address of its
allocated buffer. That buffer can lie above the default
ARCH_LOW_ADDRESS_LIMIT, preventing meaningful memblock_alloc_low()
tests.

Use the existing architecture override in asm/dma.h to place the limit
halfway through the dummy memory buffer. Resolve it after the buffer
has been allocated, so both low and high memory can be represented
regardless of its address. The production allocator is unchanged.

Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/asm/dma.h      | 6 ++++++
 tools/testing/memblock/tests/common.c | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/tools/testing/memblock/asm/dma.h b/tools/testing/memblock/asm/dma.h
index 13ff8e5d22e..6607408dcf2 100644
--- a/tools/testing/memblock/asm/dma.h
+++ b/tools/testing/memblock/asm/dma.h
@@ -2,4 +2,10 @@
 #ifndef _TOOLS_DMA_H
 #define _TOOLS_DMA_H
 
+#include <linux/types.h>
+
+phys_addr_t dummy_physical_memory_low_limit(void);
+
+#define ARCH_LOW_ADDRESS_LIMIT dummy_physical_memory_low_limit()
+
 #endif
diff --git a/tools/testing/memblock/tests/common.c b/tools/testing/memblock/tests/common.c
index 3250c8e5124..4e6a920c459 100644
--- a/tools/testing/memblock/tests/common.c
+++ b/tools/testing/memblock/tests/common.c
@@ -118,6 +118,11 @@ phys_addr_t dummy_physical_memory_base(void)
 	return (phys_addr_t)memory_block.base;
 }
 
+phys_addr_t dummy_physical_memory_low_limit(void)
+{
+	return dummy_physical_memory_base() + MEM_SIZE / 2;
+}
+
 static void usage(const char *prog)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(help_opts) != ARRAY_SIZE(long_opts) - 1);
-- 
2.55.0



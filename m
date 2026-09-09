Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D69EC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1606B008C; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6817B6B0092; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570D76B0093; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 331D56B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CA81A4826
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:55:49 +0000 (UTC)
X-FDA: 85195884018.17.045F129
Received: from out-2z4y-a131.jellyfish.systems (out-2z4y-a131.jellyfish.systems [198.54.127.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5161E80004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:55:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=EPVxsCbz;
	spf=pass (imf30.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.131 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788998147;
	b=n4N6NnDHr2LolVo5kZ4U/zEAmpk8iN+RioVD+1HgYaLc+u/mX+Lc0nLAeIQJfIY287F/9w
	Zl3t2SrgslGitXh8hfe8gLR13Irrw2IO5JbZ+J2nHzrS8XY2tIrrt48bqc+GHCdfKNhibD
	T+hhY2BQE68mJKOocJHMkF0tg4A376A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=EPVxsCbz;
	spf=pass (imf30.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.131 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788998147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1z3Z8gwjIPEJ7RUurdh1RsBPbnoHaInN21ppueWrqqM=;
	b=A8mBdaba5E9JAcEJr1vpR9rI8d7mm+ckilpfsHMDfJBmG2u//l3UieSDXtpek89kMulrhT
	9yfVqLJSaHuV0534vCaKJCOqHXdCiTgx5W5JYXYxLb/ttlOWya5gwbXherOUz5J8m/cj8y
	Wjc+L7FtspGsT9ULMpu0ILBtXdkthXs=
Received: from 192.168.5.7 (unknown [23.142.132.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hgHkC2CxVz2x99;
	Wed, 09 Sep 2026 23:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788998133;
	bh=1z3Z8gwjIPEJ7RUurdh1RsBPbnoHaInN21ppueWrqqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPVxsCbz1LPCAxLcZgiOsedsqzRRSGjZ6JPsEEA3TU9opRqGOLKW1p4c0+eucT89d
	 NItqVcuK+XOGakvFLMit+6z1tLJ/W3cmGARIC08kiOws+MBQ+zGpPOc/eVf/WVIHaP
	 RPkEsj/tYWB0ooWque7FrnfbaXXq62hOQTxko82e/IGb7/uFrjK/AGzZLJP6kY3BQk
	 ixVsilravnf4s+bNp9usLKRTuv84plip8G8S9uYuyLWJ5YdUYGJR6dFMDt4Qt5t899
	 9PY2un3xwUcOUENCndcyt0aXFdpkdyN7VUtxv1dNdidS3egif2+IRBKW+lgpjmQXvL
	 p3gsrs4zGGfMA==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hi@tychen.cc
Subject: [PATCH v3 1/2] memblock tests: model the low allocation limit within dummy memory
Date: Thu, 10 Sep 2026 07:55:28 +0800
Message-ID: <f16c272cd52316b83c35d87987b4d8687c4a3182.1788997523.git.hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788997523.git.hi@tychen.cc>
References: <cover.1788997523.git.hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5161E80004
X-Stat-Signature: 6sm9ftun74n46m7qen8orzm6zagfoyiy
X-HE-Tag: 1788998147-775848
X-HE-Meta: U2FsdGVkX1+dnhK10BeNMsjBhxzCbJigM0Xg1eebgujEr0Lx07mtRS0lF/SC32FIE33MXc98t/Hmn9Ml+Nib218M26vNvH79TjuqAhXhe3L6MNKCaHKqJePCqbBC19bC9SjioPrlNFB6gV/mKHCXU+2BspQNb6r5SMLT0gS5J8c5FoJ2zy+n7ucmhsvoZU2B80dZtZXmP8cHKTdh46oB0GOkVukVRxF9vk8zhAfaxnPcj2nyJ5vJLDZffs4RMs6zQpBr9nB34i7+J2Gks13kBkFeB4JVZWR3rPZkIi3RYZAuqs6xb9Rs0Vs2iaMeMjHFUrtNxZWLtccQGVWUt9ReZNoptcXbUOg/KKp/LFmbjaSoNv5KXUtnCFy3uJgYNnPtqFtq3ekh3b6S1PRVNHOm0UW82NyaTZ+Vqjnb04TVPoSHZggrgbPQww3KhhlNvKonHxNm4vN6GvFry2P0Wr46PWguR0SgwU346mO4X+aTyuUaMERw5dETxXZxUk9X1pPIQT+zlK1hBu5kiRu9jru/w4zrAatEsN808e3kbJrLjSz4RLaixxCMcuv5QQk6o7yaxIMwHs5V8TSET4StBobWPYAL3WJ5pc62OliuQPbwJmyRb9eIgZfUOK7FmvVCYE/Wof7O/ov0r+TYZkWDXoJDNcFSlRc6jJp+3QptoqUcDJo4VW7qi5jby7kTYOlTrRtcKS8tscDlLtW4O/ZbuyTvI2eEQ4qqX3lGN2ySsZoSA/1YsSiEl/+QHgYZohbutiNFRFCsvvYpL6IKqRuFpU1V39Uys96IUF3EfeTAuqfKvuFyUzYmFMyZoqkiVIdujCrRxtnpsW19XhN8FdYMmIjoTjn1N5CngCqnp884WAcMUmrH3k3cHps6uHcA3cjJeeuY45pMXAzqNJLY9t4GjWBkifztgPZY222H2sUxT+A8u5PWbdiYexiFNsn+mM9tFq50jWczvHtKTUwlpz10VSF
 kKkd+78C
 6h+M2BumKqR0bTogY/eFiRrYToukwVqa+S2mTRCPEV+lVoQXb5fzjwtJSVUsv6QN4oBqkydtqsV0uzH5VvMbHiD1XDhXbNm3lMPKMcL2iPLPR0Srp8lp3YEDEyUlJxFzEjtpxX38l2f2DIIIjW1iEibadkHgrGMuHVpns7z3wtDQBHM8WxkbrDv/AmHFLyEm/nQ7uTalEha1VYYn/ufjhFJEVbs4C0P8ucwwrrP9YBipzXmJ1sGZ8rnuEbyCIa3mZu/2ZNcn4k1OKPEXLyiIMIeG1TCoqLIl6q8bYCA2DadtmikLLaQz27cwqJaK11ScP2xVRszzpZS/83C26EaxHbmMtRU8ruMNqW6rj
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

Use the architecture override in asm/dma.h to place the limit halfway
through the memory registered by setup_memblock(). Resolve the limit
after allocating the buffer, leaving registered memory on both sides.

Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/asm/dma.h      | 6 ++++++
 tools/testing/memblock/tests/common.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/tools/testing/memblock/asm/dma.h b/tools/testing/memblock/asm/dma.h
index 13ff8e5d22ef..6607408dcf25 100644
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
index 3250c8e5124b..ac032610a56e 100644
--- a/tools/testing/memblock/tests/common.c
+++ b/tools/testing/memblock/tests/common.c
@@ -118,6 +118,12 @@ phys_addr_t dummy_physical_memory_base(void)
 	return (phys_addr_t)memory_block.base;
 }
 
+phys_addr_t dummy_physical_memory_low_limit(void)
+{
+	/* The low limit is halfway through memory registered by setup_memblock(). */
+	return dummy_physical_memory_base() + MEM_SIZE / 2;
+}
+
 static void usage(const char *prog)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(help_opts) != ARRAY_SIZE(long_opts) - 1);
-- 
2.55.0



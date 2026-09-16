Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C6E3C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB1B6B0096; Wed, 16 Sep 2026 12:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A08E6B0098; Wed, 16 Sep 2026 12:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6856B0099; Wed, 16 Sep 2026 12:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED5C6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:11:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 003B04078F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:11:43 +0000 (UTC)
X-FDA: 85220116128.26.AA576A9
Received: from out-2z4y-a133.jellyfish.systems (out-2z4y-a133.jellyfish.systems [198.54.127.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 345ACA0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:11:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=WPwqNqrk;
	spf=pass (imf15.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.133 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789575102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOXnInNUODU5Lzwbj44QgpGQDJ5UdG0pb1N+gcZ3ygM=;
	b=XaobmY7JPugCU5cDXxFMS4NhmNTn8qn6yMi94CzB9eCAyZlPazZ3c9XZCIjh4Nkli43wTa
	0zdJ7Z+Fa6fCPcIFSGQXBq1eNwX8X8eWUWUIg1ofI+MvHCFdWY3+iNKuvo18ItTs0QAtZw
	K0Ko9WgdvMpsrCBGVYHVsw6wgUrEH9Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=WPwqNqrk;
	spf=pass (imf15.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.133 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789575102;
	b=VMcxrMDHsj+ShB0+hxaa7kO7FGCEjCkFDgfHRvdAhwKuoVeQXDcR3kTxKw0FxtaMNH+MZa
	6YzkpeKM2PRxoszBtiWb0AKLrcYTgV7QU07nCqHR1H/blaOG/SLlcJ4ahAeAd3rNlE/z2A
	t9R/+6Jfs2dz/FrLl2groCJbCGcri7o=
Received: from fedora (unknown [117.147.120.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hlP5P70Fcz8sWt;
	Wed, 16 Sep 2026 16:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1789575084;
	bh=yOXnInNUODU5Lzwbj44QgpGQDJ5UdG0pb1N+gcZ3ygM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPwqNqrk70w9Mi1PTiVb6REraDWc5644Q4DVFs1kz+uY3u6Fcrf++JlERFNRShvl8
	 p94/jBTEY1XFb/FCt5frxY04pDZM56TdIcGoI+/+xTPsJ+RO5ZJEoxZIYg38Qr21zD
	 6PPKoactrpEXzt1jPgi1SNYr1/W9lJ4nxoiPG4YpE3AUQL+FNTF+FifTenzEdLpVi1
	 2PwHMujfmISna+i6IL23zs82FG/Hxqe76iLEQpE9T9oA3q5gRJI8vQl1x+jT0rGmjl
	 IKlBgrMX/y0hzV8987QPdQoUepqTOb+1Qd0GluEWkfjzd8kzPuv2CEtYEPMP3Z5LCU
	 q2keh9ePG9kYQ==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] memblock tests: zero-extend simulated memory addresses
Date: Thu, 17 Sep 2026 00:11:05 +0800
Message-ID: <20260916161105.2548281-3-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916161105.2548281-1-hi@tychen.cc>
References: <20260916161105.2548281-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 345ACA0005
X-Stat-Signature: zd36dfogq4q7a5ppxbo5gqufwbq3jcn5
X-Rspam-User: 
X-HE-Tag: 1789575101-142505
X-HE-Meta: U2FsdGVkX19/h9m56wN37KUTSIznworML0VGyFmYM43+/i1T+SJ15tQZQibntFb54r+Y6+/Q2EZXQS7uZliERy+QMW7QUBZp1Fsdgq+ai8Fl9r0okxOBRTDho817dOptxWnQ1quJD5RXwdB3GVFKC0+upb0Kr5F/F+VoFFvP09zj09X1WQr3hmOZ1NSWq+zyRoK7OwmExfdR9Q33frpSRfsWOxkQn90vOGVsCmUS8nLJZahhFhYTW1Y05IJewXFS309cgn8RAgS+iYwiqq0jcS/eEgthFvO+GoeM7aSkfbzI7jfroEk0t50WSBc9KkVr9Q0wOrJJK0mj8jOhWX6RtZXzpoWBvCQ7KGRbl0UhDjlFCx+xFJle7bhEjS88kbbJm4hqZhJI9K9/vLtXpEB1/epByRt2VjBf3r+nUnzOE/QKhnQhfCxKlXAm55Kh/PxFC8N0UEuyJVzLD9n6F0BmUsj6Kc9kaHrpyhwa1WPyALYxLV4NCJL5bmNIu0iInjJB9F3Nm2j2M1kfhlPa4NvYIfy4mBCvO6O4NU1vJj4SffIqhpTjp+CR2uIPIKX4qxz8Ng3Xmihfiko+qGYYSXMPGO5zejwWGj4P2BZUSS4WaicRQR0G3aI8fpz5jaylh3gC5qmbDHDBRNFGdFfyfZiZYMjH/KtEXaBrf2u6TOnYgY6sqtLgAcArJqFNdLu7TsovkQYG5mVd+n9WrE5GXnWDseZAKvb2Y+FgJQve5nHsqk4u66G8HTB/HKrp36Klz7vlPKPI1Le+7MV4uQEFzXkh3FIpKJGfYLx3zD1DcJIy7warM2l64Bgzbs2GRM057wp67Q4D4Q2WjPUOBKQDpMx53PRyKhPcFaDdmxYbUn0REgCQaZi/AMWQSQCUGBs9fjJuOjWh/uD8/t6/CZWxfDLkbZo8A1Aagu2TO43NRhH+cbPuuasbmk/ZanaVRXRDKmtGHf31REeLvdnlxIzaeAG
 ZoduHHvx
 y5Z+voIZXglkW3S/Ona1d7nvB+eNtozmu2VJjLmrmcxMxHulxHcdWErbM3PCVl9mCLn4DH0m6eg9zzCsHuC/vdxm1yy4+/J9V8X/OBkkbi6RAbv0aiyyNU4JY/MtdQ7IyY0yNlzshx//zJ1ZuhbbSkRngiDXGOsHtpOxi5NZ68J7ehuCUDkK2i75MIFj+bf4KjMkRU8rF93GsaRZudYhuyeYyYRPiZL9vJJRjeLJMgNGAE5hSTWMVr2GHnaokAZcOlTjT9Ri3lr/aY3EEdrhKm936hOzmn5hBx8nSIpr+P/Lm9rP95hsfDvE5pcYvC8QGziviQQo3vB9MbBSfFe5u840te6+Vke0xEy6nhnsAK/Giehc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Converting a 32-bit pointer directly to the 64-bit phys_addr_t can
sign-extend it when BUILD=32 is used. A dummy allocation above 2 GiB
then gets registered at an address different from its unsigned pointer
value. The low-address tests compare that value against the registered
range and fail once the earlier maximum-address free test is fixed.

Convert through uintptr_t when registering and reporting dummy memory.
This preserves the pointer bits and agrees with the simulator __pa()
conversion and the allocation tests.

Fixes: 284d950dd6b0 ("memblock tests: Add simulation of physical memory")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/tests/common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/memblock/tests/common.c b/tools/testing/memblock/tests/common.c
index ac032610a56e..2a248973eb4c 100644
--- a/tools/testing/memblock/tests/common.c
+++ b/tools/testing/memblock/tests/common.c
@@ -67,7 +67,7 @@ static inline void fill_memblock(void)
 void setup_memblock(void)
 {
 	reset_memblock_regions();
-	memblock_add((phys_addr_t)memory_block.base, MEM_SIZE);
+	memblock_add((phys_addr_t)(uintptr_t)memory_block.base, MEM_SIZE);
 	fill_memblock();
 }
 
@@ -88,7 +88,7 @@ void setup_numa_memblock(const unsigned int node_fracs[])
 	int flags;
 
 	reset_memblock_regions();
-	base = (phys_addr_t)memory_block.base;
+	base = (phys_addr_t)(uintptr_t)memory_block.base;
 	flags = (movable_node_is_enabled()) ? MEMBLOCK_NONE : MEMBLOCK_HOTPLUG;
 
 	for (int i = 0; i < NUMA_NODES; i++) {
@@ -115,7 +115,7 @@ void dummy_physical_memory_cleanup(void)
 
 phys_addr_t dummy_physical_memory_base(void)
 {
-	return (phys_addr_t)memory_block.base;
+	return (phys_addr_t)(uintptr_t)memory_block.base;
 }
 
 phys_addr_t dummy_physical_memory_low_limit(void)
-- 
2.55.0



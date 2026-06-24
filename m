Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9730CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58046B00AF; Wed, 24 Jun 2026 11:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08996B00BB; Wed, 24 Jun 2026 11:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9200F6B00BC; Wed, 24 Jun 2026 11:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69A626B00AF
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:07:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC3471403CE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:07:10 +0000 (UTC)
X-FDA: 84915134220.01.274DD66
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2B29A140013
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:07:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o99GCm9a;
	spf=pass (imf09.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313629;
	b=MGME/ZXIIKq4Cp5E8/O4LcjMISau9LAROaQBaCNsNhUx/I0Np7JonsvGDvBOJmbiuApM/2
	jLImd3W1dWpETwprLQpQt5G03L5CVIQVU9MYpVmkgKDjJG4JSItBqgE16b2VXUr9tdj/QY
	8iCVoNipZJNVHx6S/C4KdCT/ppJ03zo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xRpVEreNtBO4LtMlEcvHt//25dFczNuN6BaD0yWTPJI=;
	b=69BdYRF8ClHsMcSe6bEFhmvaymdHPFNv9wJuMl6ZrkRBRAkE/3XoP96Pe21hCbBQTOJm3t
	TOCReqkny9QLt2PB2IHa6Ipq36MiP1dGPak3ZwsBb2U6kjeYD8qMJAg0KtFwk1TRWbPBX6
	1X73D1vwBu6Z6kiKzVO5KZTgiYvktFs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o99GCm9a;
	spf=pass (imf09.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782313625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xRpVEreNtBO4LtMlEcvHt//25dFczNuN6BaD0yWTPJI=;
	b=o99GCm9a1C1H8WixwhlJ2S3xac9KEoDLf+l5sXO4aLJSVg1Yom5pll3awcujFCiCN9N4Oq
	wkyzTcGL3lkEKZ5C9v8Uv5efbfGxgimiVkJVcxNF5hP6CxQ9dZGN/vuOeo24Ep/8fAUvDs
	KSmQYOCCIlxRLIvW/0cyK9wrhGOahhE=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] tools/mm: add thp_swap_allocator_test binary to .gitignore
Date: Wed, 24 Jun 2026 23:06:42 +0800
Message-ID: <20260624150642.19749-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2B29A140013
X-Rspam-User: 
X-Stat-Signature: h768euy6dqnfgfnnyz4fy7a6azcy7ds5
X-HE-Tag: 1782313629-256183
X-HE-Meta: U2FsdGVkX1/AasMb5BLyf5OWRA7y91I5r4RDLfaoitfMKm3yAw2+xKk7L+bNS+E3N7Irdw2w85COCYVm8hyOvKGlX9ZROFjGPlTgeZ4UmKv0MQa2J+mjsmBR5MaOjwsOtM0FOHwlI73n7DpSsrW7SJ6UsLqhjCz1vJ4Ks6lu8CoBruUHjNv+7a15vaotYS6fUHFXFWdacqACdDeUECPgCWkygncCBQ6y26Uc7+uKsckpzT6OpSzN0EssaFeinssWGOnff/AOHUK0qQessJyEpadbzWpJhFQYZcQnLBHi7Iwmw0WD8EDkEsLVVK1i47p3omlmKWLaxOKBSptMOKHCSEuYCg9bxwVYS2iX6oZ1VP1h4STbu4y3XXuAcQA69faw05rM+SaftbwXYKFS6DFle12Cqz6+VuThBovMP5i/o7iIMdvSnceDE+EsoG+oP3Z2NrXfOWuQ0Ri3T6EI09d3efFEraG1Zc2XpnTTA1zpFUhfQI+/fIgie83eZJnzhlUBM44nd7Pj9g1y++icxlTJ6nQKbRGtH4lTWydAfwJOarC1THCRBlpv65ei0La9ZMmlfl24CsEMspku/s+QxpcjjM2rZ91NAuX8WOaBml33odGDegPByWbM9Xr9s67aOKCCzsD4OhC5ZiYrf0TrWzaplUmQj3aN82I1pVvQ2S8D0a5BlpmZATR7VrF1gKTTx8Zi2GAkogXREKuSH0B85/i8DMnJgt6bP016LDBIB7qK6+s8JXVhBQpi5dkVm3X46zhTE89M0R7qSDslEtOSJ6DL7DEJiMBRTb9a4BbxwbM9+4C+xQy4AG6IkRJ9A2pIoaGDQhpycrm52JSaOOFz2RInncUZL6PXXzTfqHkB2rRU0KGSkE2DirZ+ZbsSiMZAV2umqOTzEPZDq0V1tqA4G1CNbhH2KXCE5rcL2pBaoQN9JKGcWtaTAqbp3NW9coI2SjR6BKp/9mRiRTlJv72vBNV
 +g17pLoM
 C+521B8tz0BQH9PpjRGo4qWWgzH5KGsIP8/wS9EnzjLtAxtj3YRo+bkUoaZJWUMySCI4f32Vy/iI8DoR/nH8Duy/ByKvRb49yG1nBkOTahwjSSe8pP94kZ4YEi4Ah+lahL0MN4hAi9clnBXcn/VCZNhOAccj4lNC4rg2HRSORosCSeUpxmre+5NF/xZ2LayawEie8EMmWk2u7MX4mAGvfTqAlzvjx8Gc3ATb/+ozP99E4EfF3Ae7paVk73g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tell git to ignore the generated binary for thp_swap_allocator_test.c.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---
 tools/mm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 922879f93fc8..1446a659e540 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -2,3 +2,4 @@
 slabinfo
 page-types
 page_owner_sort
+thp_swap_allocator_test
-- 
2.53.0



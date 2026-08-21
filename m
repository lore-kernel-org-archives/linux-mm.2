Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 489E2C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 00:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3866C6B0088; Thu, 20 Aug 2026 20:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337026B0095; Thu, 20 Aug 2026 20:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D866B009B; Thu, 20 Aug 2026 20:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3BC26B0088
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:51:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 729541C0C9A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:51:37 +0000 (UTC)
X-FDA: 85123448634.15.0D3544D
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6FFFC120002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:51:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KOPEn+s7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of enlin.mu@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=enlin.mu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787273495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QZOg+jZljXDlotKf+8GfR+DKZmTplIVxCslI3AuLm4o=;
	b=ZnT4gbeRk3VHrXgA1+/U3sbnuynsAibACwy4IqNV2NaFblPD9I9y1W0zGUzeP3hqVnwwd0
	4HItRkoBHAa0yzhXLvzhXfC4I1rfilKdo0Rp01ZATjvQhZE1FX6lx/vwNBgAgVgvkyymp2
	nCRhDQtVkAiFwvhGOwfbnhDgfzFaxZE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KOPEn+s7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of enlin.mu@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=enlin.mu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787273495;
	b=iIXqqUQtZMldPTaH6nPBgLDi34CRuet1HpUDZvSRAkJClnnmeKOmivl7ew+7pL3qs/A2Z5
	UVNsbIgLr6Epq64M41crK22gbuwS8d5cF6OaVPiv3535SYksxTR6iTzFMAk98RuUctnlqZ
	2MrF4Jf9eCiby71lNnkqjm5ncf3sWRI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=v5sr0a368wMr49xT+OFIPBbKrTHL7LftGS48PMffOgQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787273492; v=1; x=1787878292;
 b=KOPEn+s7M6mIEvVRejZtMv4HJAW1pKLcVQ+92ghO0E/ltlLRmpr77ELQavZenmibnxtLN5jW
 nAYYhGSKaDg2QH2ffyjWsxFEInaAjmN0Vxdv6AsxRdTZ8UEFXxwPw5AuPsAEp/OzUE8XJiN0jqg
 UQrG45/Uox+xPn/1QSb+X/HQ=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (2408:8411:24a0:401:66b7:563b:1733:817d)
	by mta10.migadu.com with ESMTPS id cac206903308ca7c;
	Fri, 21 Aug 2026 00:51:22 +0000
X-Mizu-Trace-ID: cac206903308ca7c
X-Migadu-Flow: FLOW_OUT
From: Enlin Mu <enlin.mu@linux.dev>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enlin.mu@unisoc.com,
	enlin.mu@linux.dev
Subject: [PATCH] mm/vmscan: fix comment logic in balance_pgdat
Date: Fri, 21 Aug 2026 08:51:07 +0800
Message-Id: <20260821005107.3416-1-enlin.mu@linux.dev>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6FFFC120002
X-Stat-Signature: 7g8yqk14teu4t6jr9ztnzd77witaqyc1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787273495-395203
X-HE-Meta: U2FsdGVkX1/2tFmsIZYxUi7AoVsN5tievMiwEFs9VMISs8o4mKLC2sN1MK819cD0uvVnbHBHMB0x3PEFoYj0s/gPsF90K3v/sxXWj6M9s2cNz6mHOqm7okya/57+zMBG6AgJqbtAVraTzHcXXwbhar361uJDqEH9IwX/JOBupKEFu9y5bNIROvZ0BJouVhJ6afFWT4AvEH6ie0D2YypdhJtOHdhTF4J3jj3nhy4835wc2p4olG9n0AApTvjfYBkr3LrCH3oY4JwDie4yQrLapzG6MIDOB7ZYUpyolNlMBebfeDzjV3gOCk2kdPNKdmRreoRCAQPcN+Tj8fRPwFyNabrfFOXwM8q100rHYLN7uA66rSnrDKDfJ2RlUYl9oRuoQzWV1yIvKa4nSJuhd3auShSpS3w24u3xVuMdUETS2ScwOexYKxMnZBIbTqd/hBCnSHw51k/Rdu2ONcCQXWsNcwxN5d/NnYM10hBDnSEdknLAbFJlnJSqMTcvFSTRHYSqrCZEw4hAgTlkHaifFgeLwdY6z6aNyF9VO7cwpmDWEeBqp+O9rtkPdDuIErvFUqpXd0ihUkFRvhruBVvT7WCDNUv4xA05A9EBL7QBHdXwi7wqR5+uppjTVY9u4SVBW2FA16Z6ry+Luz/yQJqJ8uHgucfJBml+6pUTT93bNMgdZsfFNjiENIjfHJPaVSHglL3jJ5LftbnRNITrFoaDdqModCp1g83lKbfVx0Ioi6+V80YAsWb5iB19G5KlgIo168S8faAkcsFvVCZfqOnRzQ9W6YTs6wksMIQN/XB4UmgZ5U1bRKF0pz78QC8emVxE2Ag0z3QwQ9hOA3B+yhbfiF+a8KhAQNEKX9Hi4blxkU/0XQkncvCF/nNS2QjHJTAQHY1mEwKZyB9wHIBN522VBRjPQ3uA1QpupKLk1UzML/yw5uzlbP1pWir1DxnwPyCmKnt/hcTiyw+F2WPNHqvxSvK
 x6lKERUX
 qhhTDp3ET/CUlWWGowW2ideraa+x04iDqXoRYF+RugmJxqhACnFpeXih+2ydTX85kSOrNL5ZfaBIQ8ESQOPZJfdfkYKufTYOxdUezlUTIkfkLTczbwHdMFTaGfKp7butotgEyHtF0BmP34U/MTzmLIlrqz4RtjJ9HzaIdOumNS3o+VqlyBMc39hj6GyQI35Qs5DNSCd7NyKarm3+7LRvPua6yljS/pgfxtzpl0MHRtjzUpgmzIeQgX7RMUqAZoG2NSUhoriozap1X3kqjf5YFd3n0u+uijs95xsY8cmCGFOxr4vdAEWDlYrKd9ekJPWBVk9jkqqzUNXDxj2QmRRg+mBbdJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In balance_pgdat(), when the low watermark is met, processes sleeping on
pfmemalloc_wait are woken up because they are able to safely make forward
progress.

However, the comment incorrectly states "they should not be able",
which contradicts the actual code behavior. Fix this typo to accurately
reflect the logic.

No functional changes are introduced.

Signed-off-by: Enlin Mu <enlin.mu@unisoc.com>
Signed-off-by: Enlin Mu <enlin.mu@linux.dev>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..822f73758c42 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7188,7 +7188,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 		/*
 		 * If the low watermark is met there is no need for processes
-		 * to be throttled on pfmemalloc_wait as they should not be
+		 * to be throttled on pfmemalloc_wait as they should be
 		 * able to safely make forward progress. Wake them
 		 */
 		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&
-- 
2.39.5



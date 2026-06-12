Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED01CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC606B0005; Thu, 11 Jun 2026 23:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD38A6B0088; Thu, 11 Jun 2026 23:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10D66B008C; Thu, 11 Jun 2026 23:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 940F26B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:11:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F1251403A2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:11:22 +0000 (UTC)
X-FDA: 84869784804.26.0FF6ABE
Received: from mail-m2476.xmail.ntesmail.com (mail-m2476.xmail.ntesmail.com [45.195.24.76])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F1E9C0002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:11:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.76 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781233880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=JXKP3QZY2mscR8WZcIn81MQYc8N8gTRwtf/RYbfNyy4=;
	b=HNVBwRiP5L1KG3ZiiibhwWejtSnoaDSCxwavlOaBlNC40kCAcOUrXSwAPstvcCZZaCnz1i
	LZEKRcnkOPnde0EyAanHDS51RLH34ZUT74tDb7E1ch30K7KJfobdIa4zYOSyBwPxFXcIsJ
	RVbBxr8ak1IAgokhhjb2RIT4W7T/kRE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.76 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781233880;
	b=Pu9eZfSBy2OSPMV20aN4mECf8Lf31wK/LgWSmQ5JYk2gjYcXjsNYj1vg85vWu39oIshU6J
	frx9T5dQDKe1+W885r0FlwE0YpAdpHTyN80V6T0fZDhHhH9DLEznrOB8q/HOhrrLuyp/8g
	lw2atC/rXxJmpjlrsseag0CNltSGayk=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b583596e;
	Fri, 12 Jun 2026 11:11:13 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH] mm/memblock: Remove redundant pageblock_align() in free_unused_memmap()
Date: Fri, 12 Jun 2026 11:11:05 +0800
Message-Id: <20260612031105.3350181-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9eb9cff0fb0229kunmc57f76532447b4
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSUMYVhhNTUtCThkZQx9DTVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zge8fz8chjphr4ekt3ezjkqkpp9gf476
X-Rspamd-Queue-Id: 7F1E9C0002
X-HE-Tag: 1781233879-88551
X-HE-Meta: U2FsdGVkX19z48AbFtFrvyOyaeW3kGroG4evCqI2BJn5MzVbjc1tjGn35LTPifuoaT5y7U9kyBFsXMAEJW7lVMmyTRhYoGP2EfzMMBSezkhh7B9x4XwtNy048fLkQFb69eLI1Td17CwqwzrurLoUOrAFd72fDKhHa8rRHquVy4JU3Y6XSGVWQYgf4KVdyxXdvbyGEenxqLKwFNIlg4IkO8XRRtWH7UMDmDolfwVy1gjSkgqlJEOP0vwey66kkBxD6pvTNRugMHVydDmeRIN/MIILC+GFOD3ra+lJCdSd1C7ICeo0hRuWefRQulHVKQb7AwhdDpKcDVF/sN9QjMLQ6AkXUCf3lImEMWxLzctUs5Anp4E92ZSVzwcwAtnmC3HiTqe3vW9ySHxWJbqHOm46HmPa21Dr1GsU7/AxHIjgimDENjJw4Yg663Qc5O1G9kVxkZKsS6DfLuBd53IZqGVVqhuo7CVuUkt+rBbtdS2vsE1E8ZMAdaMj8NNYSMCxpzVXMbUTBHmi8kmAhmC76pnjmZXuTH0s1xmrAdTujSEhKtUt18Lb+8q73dp/sO5Gh4qBkQn8S6K0PmlkcUY4j2zfYG9c7kulBGuJHC/TBlM54uBIwzNr2YglqguOvW3un0Do0RU8xvWC+K9EaL9kYhRk+bmlWiPfHAd1iINhsBaeTDvyFKZWt21A6c5mUm1xcEpCvGZqDoM3I+mh3humkfyToRLRjfmF+HzyXYRFTCOk02uCMA6TabVreypGzzQ5nK6DIoQyhjnOcVqDZYeQnVOzdIXY1yd+d3tkEbEMyy/RlaZ83P03rRiI2zND1Gvo0tRutCc/btnc+e3o/en3VxuTYunN6Gv2ChSTyc7l3p2eSk0+ObvRXZbGgtMNN5kag3VsyYIM/0jMmbYaYzSW8+uMui3gwRBQrpVtQI9qIXuVx18i0pHEPHvVvPBzoth42O2sCblxMmoq55MrcpCElAl
 kloBfDo8
 6C7hpXCILAZJIbIyDPRvNn9pCUERbxW58oWvPSjrHsk3ak7zKUPwgDZ5OTfgVD5PJC+ea+eXO6U7IjF2MUVbvSep7UD4GJ0k/QRxVa5z31ZcYxA1+h7Dc6OE2nXdnZ4sxJFY1BgUfUwW/GMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The assignment `prev_end = pageblock_align(end)` is redundant because
`prev_end` was already aligned to pageblock oundaries inside the loop.
Since pageblock_align() is a pure function, calling it again with the
same input produces the same result.

This line was added in commit f921f53e089a ("memblock: align freed
memory map on pageblock boundaries with SPARSEMEM"). Remove it to
simplify the code.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/memblock.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index ccd43f3abb82..f50792375604 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2258,10 +2258,8 @@ static void __init free_unused_memmap(void)
 	}
 
 #ifdef CONFIG_SPARSEMEM
-	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION)) {
-		prev_end = pageblock_align(end);
+	if (!IS_ALIGNED(prev_end, PAGES_PER_SECTION))
 		free_memmap(prev_end, ALIGN(prev_end, PAGES_PER_SECTION));
-	}
 #endif
 }
 
-- 
2.20.1



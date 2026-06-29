Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41D2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29CBA6B00DB; Mon, 29 Jun 2026 10:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E006B00DC; Mon, 29 Jun 2026 10:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A8D6B00DE; Mon, 29 Jun 2026 10:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3A166B00DB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20DD4120119
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:45 +0000 (UTC)
X-FDA: 84933216690.06.E1D3740
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC1171C000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=A3WHZrem;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf21.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744163;
	b=3jff7Vd09crk/UzcqWpOOyHEfAcAR/wrsFxBPl9/zHnR0ceE/fe1l+LdmWGA8oPytp2wfX
	+OEWkplBsFFDZjuecid9a31sDjfiCZdIIyM7/pIcAkJMuYLYCCOo8GAM3+TaOQ5cS8IuRK
	yU57YvY0RRKnm0U+xGVwIVe+SxfNgQw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLih83L5YNlKQN9UI6QjpBHdMJhi1HQdwNwTb2ff8ss=;
	b=TYbiYUitA4ZW/vmWWkRSTObuhw636z8NHrd5YEDcdL3xhbGDyHLaAACABTXLZDurcPUU/r
	BiFBIkg8O75H8m24HsszN9oXFn1TvVxnhx6JIgiBQzAhqcfHNg37ObpGQ1ypNvbZckgWBz
	JlTTxQZQXvpDT6TElVyLyKmdQg1Z2RE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=A3WHZrem;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf21.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XLih83L5YNlKQN9UI6QjpBHdMJhi1HQdwNwTb2ff8ss=; b=A3WHZremHrWl3ad5fYZXgM0Q4g
	7z/YsbfJ0Pjq5vD2yIelUGS2BnEwRZsYs/an31ApMJCvtY5R+Q+IAqGuIZA9XA+vrTT6f77abymCG
	PqiX2K5XCm9XR/RdJmYOGJNYZFGcLHA3AirfnadRmytg49EXT7es9qGyp1J9WN0IzLM8pVqapvEFQ
	1jdHx5PWaX7UR2R6r24UDptCN+gSBYfXnceK/wSsN1Yeo9VLVaMANWRbS+qL+Cu2iVNycqXfUKhCB
	+vDQ2eET6OC91qnkvCQJIWSGCbD4tvWL4lu+LUOxJGlwgrpQHlcH81OdUjJLKelCMJwxQzKJVplwI
	i8OnRtPg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDC5-0000000EuZF-48m5;
	Mon, 29 Jun 2026 14:42:42 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 06/18] maple_tree: Drop MAPLE_ALLOC_SLOTS
Date: Mon, 29 Jun 2026 10:41:33 -0400
Message-ID: <20260629144145.1572283-7-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC1171C000B
X-Stat-Signature: fa1xxb1o3bmrnumhy8d4b89r564e3ryb
X-HE-Tag: 1782744162-865758
X-HE-Meta: U2FsdGVkX1+OzA29PSjzUJPbnM0VRDmalvlM7X5ODD6phyC8ABzS3WtvKC2pYwZg1/wzSOu3Wsj1sHGKACyaA7e+9GV9Tkv+X1TUGHVHEFR3xYEBUrqWqWRKn47r0h9HbPhp/QiR7tTczoNk+GcdnIhBSZCyl8FHtRLhdclswSqvftWjkpGPfsQ53l18JMgxD6yXBm5gqalGDsP+tNmzVX4MwxQ3CL+Q3dh+9KHn7jGE23ikBiHA7ltF8quk3M8Gj++GdearVs6C9p65Bf3mKsZ/RFfp5FJD+AOA6gt1hUOftRx6yocb0guz6AcSlZww6d0pD+kSkx6tZzHBUO0MDRtub7LKF5rxcffN35iEnCkupbq3UAk7UFgflTweuMLv3jdOLsyH6P3C5kwo3IUClwfWesQZmL5b+KtHwW1EERFuCxxR9NGjOBSwoaTnvs8y+z+x8OO//SJKDBSjqn5jQyNlGA2/1I8eEK0nkwX/BZVUt+cm9Xzk18knc/lPJEFxMcWSjga9TtWNm84oK1MdvUMIvjxqrCR9hVU38LGu1Um4k124CwkprOI9Gg7Cwy+yZWn1sJGkH2J6X1cnQiKUppF76H1p9cmamTE+xx8JTj3f5kVwQErFyMCHM6Jw3B3pEM/cso0gyCMTzQi6m8CX5lYoBAGVHG1Tm1su7bHU2uOgZ0q0zwW0muV0O55nHOQ/oItb5Suo1/raW5/V0FONZPPAMS2vLFbMtRxPXZdtLQB8YIzCvKJrtMzAL6VfvU5AWABhK5GtvhzFN0flEfTaFe3abu1Lakqzq6NIuTOV4YxTZSn2RMGFxpsUT1xyzkZ+bGl/Ofsnr6kXub8bM4ZYBlOfutreOmQA3XQjrbzbMNEoSAHDc/tqSZerXXgiBcGQckE5XZ5hnhKEE7LusAYvMSVL4llkl+plRjsUoL7ZnUwYwWskb4UlH4PoBQWUiSBVM2HScoCB8VX53Yebxcc
 xn3T73oh
 K/CsBnKGNU9n8iqTQTeqWPHRpqaFtd4fcWJRjR8xeW+wCGiVY4dL4f8hrj8bRRwo11zLjxX6hF0MhiBi2wTBlSs/udFhaKNh4cLTq4PifeUYkMcMKM7W+8rWT874a/X2KtpFXRRuuT9fr6az125nC6Q36jwIWT9bl59L4Zit3mFI95PcX928SqQx5JisXYBU/oJUjLzc/WH6IzQbtnmPaHQEad+Dhsb+tGeJ/YcgCE7GLbLllZzG3w9ZQ0e5VbjB3Vl/62v5NfYz48l9S3ZOZiDvqYlyzD8Fnyl97O2jOIhiNqJS/gs4khj4GkJOzy8ufwqV6INVU6ripwaRq/+4POAGIcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MAPLE_ALLOC_SLOTS is no longer used, so remove it.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 220b380cdd491..346eae48cf15e 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -29,13 +29,11 @@
 #define MAPLE_NODE_SLOTS	31	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	16	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	10	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 1)
 #else
 /* 32bit sizes */
 #define MAPLE_NODE_SLOTS	63	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	32	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	21	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 2)
 #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
 
 #define MAPLE_NODE_MASK		255UL
-- 
2.47.3



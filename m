Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA26C4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 03:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D466B0088; Sat, 18 Jul 2026 23:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCF16B008A; Sat, 18 Jul 2026 23:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2C56B008C; Sat, 18 Jul 2026 23:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3356B0088
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 23:37:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E26D716047B
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 03:37:13 +0000 (UTC)
X-FDA: 85004115546.09.BE7C6E7
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53F18180002
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 03:37:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf16.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784432232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=bh3oq5Q6H5MKM8wiXgx3Vj8TnUkoSB9lSXGVlgkIvR0=;
	b=igs0h8OWgP5QNy2CUrfeR1N8z1BbKa0tYvyD4KQ+FCaGkD2NnougjuybWlNcYLtgisZk5M
	Pzmep2r1SG/2LmaWQmlBnqEWcuwmBh9Ons1RFBXrgCATyzz1qA7h8IGC8MixBne1VBAoDE
	Sy/Diri4s4F2WaCvVO2uZJp/KjMIksQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf16.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784432232;
	b=irOyq6F50iXI6xfhI1xnHxKHebzrGC0g81JvKRJnja/aZAMH5df5N5J6HytZUlctI4UjQW
	VHpe/75CJFnR9Vo/hq/OLfg1yh4KdFUx4IQTXNeoSInI+imFAFqZyDZnOpTNDxFH6YooiY
	CIvlNuBa7e2kjedEOSmZ4AQJtLjofz4=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h2q8N0MD4z8Xrr9;
	Sun, 19 Jul 2026 11:37:08 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 66J3b2MU030228;
	Sun, 19 Jul 2026 11:37:02 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 19 Jul 2026 11:37:01 +0800 (CST)
X-Zmail-TransId: 2afa6a5c465d9b9-512e7
X-Mailer: Zmail v1.0
Message-ID: <20260719113701797vZ3R8NxiqYt8dEfeUxtON@zte.com.cn>
Date: Sun, 19 Jul 2026 11:37:01 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9zbHViOiBwcmV2ZW50IHBmbWVtYWxsb2Mgb2JqZWN0cyBmcm9tIGVudGVyaW5nIHRoZSBiYXJu?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66J3b2MU030228
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 19 Jul 2026 11:37:08 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5C4664.000/4h2q8N0MD4z8Xrr9
X-Stat-Signature: 5tzjeek1dyi44d9wuz6jiwc39pwpfjhx
X-Rspamd-Queue-Id: 53F18180002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784432231-446999
X-HE-Meta: U2FsdGVkX1+jydmjwfUn/xwAlvhtd6Jocq2sD6dKOnqsDIf3GRN/FaNEqqZAdhvXBydaBk22JpSUnUuxyKBGJG8pbZ8ZDVYQZymPyPT2pHb/9E/hK/eog0n5Sqzl01SwXX3c7AQ5MkwMUx2Zv/58tM6ZbckmKMk5ryzX4YSSa14iEnF7LKv4xH6B8KkmLMhgovWWxsJA60X9gZLO1DLQYlMCPDI8+7lSkX/lv9/zqroTOJjCzbW2mAM6wsKmi7WccR4IRC6xx96xbu/t7tci/2a85hrUar4fDsqvT4pF00HVOUPJJ66/6bMp+oCb2Hmqn422oqeBzKaDOBJ4cpQx3fhVw98vmGq6VvxElqNQSRv7oK3CZqb+xbaFPM8lQ0eDmxOhkVJGDtouvnQ3rDAFeMgfgKmrqaoruRZ7XZPraMUpYRBPYlo+tUmxNzZ377g7JO5nM8woevJiw24/rLlFwCqbw9tJdn4kvcK4rnXowASqsHKEmC1CUeoZkvBZ9YWmmvtWE7D5z71DOqRl7qBhyVu0YTAppxgDxBR3CpDdBJ+UPhsRD3ywgD0B65VT7TAKqwjATGYQdqWVrdaEaB5DYQoVpYjh784OWe3SspqvBOT72AT1XLJNc0UZUHdoRVU+8Vz5ORehlqMCWYHsh4tj5dh4UCfHEFHD0oaK+u06XobxtaU4SIj6grIqjET3pT1PQp8qrhnVQgtZwpr6o7fLveObTD0N3LEyYeTSUCb2qvXE+itBzGIN6hY1rYDZ9nzBfDippM9qD46wCWQShfudQx/6He4jXhGZwjqhbKmQA9oOUjN/UUt2Uj5lqgYqJybQqylcPtSk9GgYHMhPj19yxp1N9fgo793jFBLCZWLm2YjaXSm41vu7wlpIoaGcsYMzrZGBmQjoibyLoshcmQcrvD9GJvKwyotWwnjFOVR/RykQd/TOjDeVO9gosu3121dbBCOPBe0QVJQGPUbhgNZ
 PDvaqTJD
 R+AJCmWuCpDmWMdV51LWQW3UjUNXK4f3I92tl7xNWk8cf88bwH1XnAjPIxgx0QA97dxZIvWIfdj5jbGR231M+UWKYJy85Xu2hJU/kTRQok5VkTSMM4EWm/yYULhgY3jL3x8vQnwKdZmH6ChpCl0Usx5gsLVjZXbdOxSO6GY8fXqki+VMg7H3I3rR4zL1o5sQkneK1dAt+cVBwLefESlkS5C5BfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

kmem_cache_return_sheaf() may refill a partially consumed sheaf before
placing it in the barn. Without an explicit restriction, this refill may
draw objects from pfmemalloc slabs and consume emergency reserves.

Add __GFP_NOMEMALLOC so returned sheaves are refilled only from normal
memory. If that fails, flush and free the sheaf instead.

Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 53b4976d3831..34f17ecbde87 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	 * simply flush and free it.
 	 */
 	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
-	    refill_sheaf(s, sheaf, gfp)) {
+	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
 		sheaf_flush_unused(s, sheaf);
 		free_empty_sheaf(s, sheaf);
 		return;
-- 
2.25.1


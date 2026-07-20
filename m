Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1938C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 13:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0446B008C; Mon, 20 Jul 2026 09:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88386B0096; Mon, 20 Jul 2026 09:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0386B009D; Mon, 20 Jul 2026 09:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9936B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:11:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D71F80182
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:11:40 +0000 (UTC)
X-FDA: 85009191960.03.A1C0FF8
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7AC8180014
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:11:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf16.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784553098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ywdWGkDen/1MpYx1MAdYErzRAMOzgMn5VFnbJ4nGZik=;
	b=y25QBgnmTI/3dge5ISAplwjMdnIewkmg6KB9oRY5nu5hk2+b9wznGSn/8732/o2Y88ppXZ
	S4WCICS4uOjVRSwXdajXCcBdPqxjPC9NYn/81QKyIwDv0GuLw26z/oGhCrPwTkHCNzhVyl
	KtvMD0APqEyCXrciJ3jUIJdmlxcS9is=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf16.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784553098;
	b=ozoCCgBWAFAHRTo/qyAEnOOmnIs1Do1Bvkzwz4xCQYNI26Y9EzXI2JPkaSufEeyin1p9I5
	I8ETVpUEKVEh12TXbU+wzciCuNbnw6jUUb/sJOV1ynaBtMUyQQxOxMSaBXDv1yF2ZE+yny
	ieLOGJ0En6JHOcXK969awEPyUqKf8+w=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4h3grY2Nc5z55RJ3;
	Mon, 20 Jul 2026 21:11:25 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 66KDBNxk039877;
	Mon, 20 Jul 2026 21:11:23 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 20 Jul 2026 21:11:27 +0800 (CST)
X-Zmail-TransId: 2afc6a5e1e7f293-12308
X-Mailer: Zmail v1.0
Message-ID: <20260720211127124sYtTNbvsxCXN9_pDh-pwt@zte.com.cn>
Date: Mon, 20 Jul 2026 21:11:27 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBtbS9zbHViOiBwcmV2ZW50IHBmbWVtYWxsb2Mgb2JqZWN0cyBmcm9tIGVudGVyaW5nIHRoZSBiYXJuwqA=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66KDBNxk039877
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 20 Jul 2026 21:11:25 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5E1E7D.000/4h3grY2Nc5z55RJ3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7AC8180014
X-Rspam-User: 
X-Stat-Signature: hnt41nyb8dgckx4skiy6htkuuduhpa6a
X-HE-Tag: 1784553096-904203
X-HE-Meta: U2FsdGVkX18Hho3LhkD4ynMWBlbmYCB7zG8L/4rWz8LZhURDw8BXyRtNlXyl3kfVS7JTrM9iRHd6iX9UlvM/dVe04h8qd9zJBQetdOHTvMkcaG+BWTXddz0iVwL7oIVu6czWTvXntudzyTOCynaN1ttcGJJESAYUttBgWAthXUmDM0GfafeKbiIft9XdOGFXKW344jmPRB0p5Xx2YkTItr4eXvQZCdIWPFuE/8nGcNgqqD2Wcr8sqq017egCTRunE8jnYGGt81ROyifOx+qUGyMKzwd3I/xeKnkvVDiCUcweZ3Mn0h3/Cj8OzLa5+SlXEDsviIzeNmV5L73WFzbo6iDG3raO7y+YR9gMmcwdjZVGjOkWsCcmxAyPkMAQss1XCjSjJXLUWpQda/3uqgHNBaSoPQifZK3ZMEyWbeVyb9Th5Fk+LVpjHprnX+fdRVJwWcDIQEs+7RhrS4Z8a4PsIFkuafU8D6BGvTlfmQ1YNQUFcd85Z1pMWw24WiMHo+uTkdEh/VY2af0r5M5shm8XqUzQ0aCHKMewsTdnFoEMV15PBHyM8Gh+NpxXFW6Id2FLeriaGIMGxKjypEJIRUQSNtebwYeP9u5TzKLLRAZfMuniRCfZ69433oFkUYHmRO0OwwnXKXb3yuwpt2NLpiVeYChST9G3vENH6BqEvlgymJesgoE9iuEGBIibcS2JYS3Jih6CjfVCSldgEKQGt3eBH/SKEEYrZm6nwAAatH1v2fDkS/NKmQrEblGAtpqqcXPmZ4xwL0cFLIg7H5j/SjgFnNVbhATJp9pQejVhaCJ5era58N4hZempzfzIipzhNeP5bNnehxQyupS/2n1egWIgj3uA0RHBxne71ipe8+9LIXesevpSUqFj8InSCUStbExl+ue/8BIkhRtJ+IibBmsQdRIkXy0VgNvfWr8rzFvX767Kivulbn7Qvm01e2aT4J4gM4eEppsqueMhid9DA+k
 Y2gPW4uZ
 jD8K6VkP5Vg2xcO/SvU0A/4bT6R9h0qlYWzTtLrlInzl8lbvu3qXsup7YPEHP5Gg31ZU1YAt8QEgnM3+wP5KCqYN7Vve2vBiYYIl8uI3HBJXcLqY3rsZxf8FkwUvOxuJlvHOIY039nvgygDJj3dc/X66t2IQ73LBadIT63PfHY/Mtz+vdzhQDHsubihKBI0ehU7B8pP4ATUijP7s=
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

Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
normal memory. Also add __GFP_NOWARN, as suggested by Hao Li, because this
refill is a best-effort attempt and failure is acceptable. If the refill
fails, flush and free the sheaf instead.

Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
Changes in v2:
- add __GFP_NOWARN as suggested by Hao.
- Link to v1: https://lore.kernel.org/all/20260719113701797vZ3R8NxiqYt8dEfeUxtON@zte.com.cn/

---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 53b4976d3831..357b7522c817 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	 * simply flush and free it.
 	 */
 	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
-	    refill_sheaf(s, sheaf, gfp)) {
+	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 		sheaf_flush_unused(s, sheaf);
 		free_empty_sheaf(s, sheaf);
 		return;
-- 
2.25.1


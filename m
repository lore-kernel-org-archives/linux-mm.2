Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54559CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 06:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E796B0093; Fri, 22 May 2026 02:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915C96B0095; Fri, 22 May 2026 02:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853076B0096; Fri, 22 May 2026 02:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 767D26B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:59:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1030A91BDE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:59:15 +0000 (UTC)
X-FDA: 84794154270.10.45D637D
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7668A40004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:59:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779433153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=06NMA6nQDq2H7KTGNV5OwjoMyJccPjpzvv6sBO0t96s=;
	b=NSvxUEWDb/ja0A66BOOz/fJJ0L3AilicERHhUy6sSS+YO4y51VTMclu0rSU72aY4aBjwMo
	Aw6GP3vh+qg445vp7MBfvWJEOBMawDzpfLeOp3wfjqyUAl2amxZZrEB0hdZMK0QFx8WRCr
	pjHn2S06LNcq5ZZ9vf2hwxtMRVTM6Qw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779433153; a=rsa-sha256;
	cv=none;
	b=KsrP5KEeQyPOZSduusGeciAORdhA/w2nSaDY3gJbrzcPE3NMQPBbE3Isf+QtEyU19Gio+v
	PIDlyMPAMA1gNvCK5Xaa2PRNzIYJrqtMLXMqw0Wv72U8hMyWtYlZo3UtsnT1eTsL/45y7w
	XWCujmkxksBVuXBvGubg0iLM8RaUv7g=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gMGNC2gFVz8XrrJ;
	Fri, 22 May 2026 14:59:07 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 64M6wwj6027824;
	Fri, 22 May 2026 14:58:58 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 14:59:00 +0800 (CST)
X-Zmail-TransId: 2afa6a0ffeb4e96-7a2a0
X-Mailer: Zmail v1.0
Message-ID: <20260522145900248m-nBcy07_SCDk2ATDWfmg@zte.com.cn>
Date: Fri, 22 May 2026 14:59:00 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyXSBtbS9zbHViOiBmcmVlIHByZWZpbGxlZCBlbXB0eSBzaGVhdmVzIGNvbnNpc3RlbnRseQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64M6wwj6027824
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 22 May 2026 14:59:07 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FFEBB.000/4gMGNC2gFVz8XrrJ
X-Rspamd-Queue-Id: 7668A40004
X-Stat-Signature: pqs8gcx4r4h74a3kw84ne8yt4qjg9f91
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779433152-368356
X-HE-Meta: U2FsdGVkX18DywxI8LZ8KR0O9rMsxawziSw1+E/R3knUmluFI061zqnzCDtMQsrZL+2tdXdGMknIvFO1kgJZqicrVYvlcun+dIRj29zneFziY/UujlNplRNRYZQlf8TYRab01boA9OqaXOlMGNfxMIuZfywJpoYidGUb9zUQBzP/0cvK24OeM5lecxNssZkKAqX++YYGRGguuaHJjYPDTUV4PMqRG6UINt5sJGgGwDH3oZFmqUNeXUdBUc6Ei7Q65DBYvXG9LK5KO+jtSTZLC/ceYO6TKtLXIhUb1u1Cfenr6g/DLVeimVs9G/Z7T4Xbd5j+xCBBd3Mf0rMzsh1VYAi/u647ndLW+WYYsWDfc/5WQdU60puvGIF34NRUf16ySURN+NFPrbcWAcAQHhi0GJH2oK7fEndPcaSp8eo99+p5h8Q8dTzR4SsAul1ZjUsKyES8soLryjv+akRbMcDItMz+TwWZTq2ONjDh9PSvrR3WiCDamZk3VXnGOwEFFkVneHVZVEgx81XyNWTs2NIdARt6Xx25ecSCQUFvrB5PIXcRBnjrF4w+l4FLfTgq3qTcgwj8ba5JTqghOv3BxVZlf9+bTnQXcDS7cHfsOVjwFo0CUmn0DS/i/G881h48XgnyBKNjJrBN+oprAW0c4sEFRcrCbbjhXzkMu9Kxnj18Zmajl9WTeNU2c6W0jfD2g+DgKSTSA6ze790+H13Fy1pkQ9jSCLSXnL4PVUVoT3Fwd9KpN/svmyv8mGrvUZO+YGbowzDcvEIT/LySd8YJX7s0zPCrGYI2RYiZU0id/e0FEu+JTQfhC5NUcDP09OJJVNiAbxxNjjOSF8/VlicI5p7RO3UPx0We4HKIMlCN9hAp7Ja0DGTBve5fa8YwIrKaDSJ5g7hIxqzyOUFFff+BZCBxH+zR6R7yNCEwWAkTqmsYpbM9k7FB1zZPe5eJ8MxJw6WkjMDxozo+RCVEptlK6qa
 9SivE6qk
 9z/jgPYs/mbAglBlGLoWqLk1UQowsc75uw7ZftM5rshJBL02G2XvXooeq0uDO1787J2uJcaOytmDJe1dLfAuaET/0eRNY2VOQ53Z7PtI8YjKM3eOck1gY4fBCTWzTiFgOaCcLD/5uuwaQFEPs9uHCGrU50IhPToEIWYITU9u/VwMAFEqskLIuFifbv+l5byY2N/gDehXryh/n7m/G3taJuwJpJNfpz0BmW/teBIkPgU567vZd63tW+IUtVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

Empty sheaves allocated by alloc_empty_sheaf() should be released with
free_empty_sheaf().

Move the common empty-sheaf initialization into __alloc_empty_sheaf(),
including the capacity and default pfmemalloc state, and use it for
oversized prefilled sheaves as well.

This keeps the prefill paths consistent: after flushing an oversized or
pfmemalloc sheaf, release the now-empty sheaf through free_empty_sheaf()
instead of kfree().

Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
Changes in v2:
- Rework the change as suggested by Harry.
- Teach __alloc_empty_sheaf() to initialize capacity and pfmemalloc.
- Allocate oversized prefilled sheaves through __alloc_empty_sheaf().
- Free flushed oversized and pfmemalloc sheaves through free_empty_sheaf().
- Link to v1: https://lore.kernel.org/all/20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn/

---
 mm/slub.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 04692a6f9128..bbe8351f1bfa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2782,6 +2782,8 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 		return NULL;

 	sheaf->cache = s;
+	sheaf->capacity = capacity;
+	sheaf->pfmemalloc = false;

 	stat(s, SHEAF_ALLOC);

@@ -5015,21 +5017,15 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)

 	if (unlikely(size > s->sheaf_capacity)) {

-		sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
+		sheaf = __alloc_empty_sheaf(s, gfp, size);
 		if (!sheaf)
 			return NULL;

 		stat(s, SHEAF_PREFILL_OVERSIZE);
-		sheaf->cache = s;
-		sheaf->capacity = size;

-		/*
-		 * we do not need to care about pfmemalloc here because oversize
-		 * sheaves area always flushed and freed when returned
-		 */
 		if (!__kmem_cache_alloc_bulk(s, gfp, size,
 					     &sheaf->objects[0])) {
-			kfree(sheaf);
+			free_empty_sheaf(s, sheaf);
 			return NULL;
 		}

@@ -5064,9 +5060,6 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 		sheaf = alloc_empty_sheaf(s, gfp);

 	if (sheaf) {
-		sheaf->capacity = s->sheaf_capacity;
-		sheaf->pfmemalloc = false;
-
 		if (sheaf->size < size &&
 		    __prefill_sheaf_pfmemalloc(s, sheaf, gfp)) {
 			sheaf_flush_unused(s, sheaf);
@@ -5097,7 +5090,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (unlikely((sheaf->capacity != s->sheaf_capacity)
 		     || sheaf->pfmemalloc)) {
 		sheaf_flush_unused(s, sheaf);
-		kfree(sheaf);
+		free_empty_sheaf(s, sheaf);
 		return;
 	}

-- 
2.25.1


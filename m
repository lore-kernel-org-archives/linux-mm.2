Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6F4CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4AC6B0088; Thu, 21 May 2026 07:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875426B008A; Thu, 21 May 2026 07:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1C56B008C; Thu, 21 May 2026 07:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D94E6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:50:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E7AD8E8FE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:50:26 +0000 (UTC)
X-FDA: 84791259252.16.7FFE47C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id AF7C540009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:50:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779364223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=GOkrWQ9x4lHcgn0fzzkygSjwNPTl6G23/wU94pCddxU=;
	b=MEbk7uNbCmvXBX4PhtDxWs23qjXNaifE+6kGHd8LIrzQht/5dM1hMmnuNi0w5/OdDIDb9E
	kXg15ww82hMuIKx7MOalhdGNZKqUFP6QbkrAx0GUPA/oYk1+L61/QHWGWjJWcNNcx48guI
	Kbot7OmtUVR2RG5MFPatpCuSNeH1qtw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779364223; a=rsa-sha256;
	cv=none;
	b=HUh2D+w/95Maatq/BKplUNHcvhXELD3dHGXIcYGx8F+TNWNuu50eKJ3ko6F9GlmY50uDfr
	IL3N68H78FbXJNemKrDBavPoGBGS/rWZ3ilnm79qcZlgGixwrpuiX/DwYV6PiFehovkMRC
	b38745lNnsMisjPbaLTD+L1fxgOJXQY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gLmtc5pfsz5BNS0;
	Thu, 21 May 2026 19:50:16 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 64LBoCAH057581;
	Thu, 21 May 2026 19:50:12 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 21 May 2026 19:50:15 +0800 (CST)
X-Zmail-TransId: 2afa6a0ef177b6a-aa43f
X-Mailer: Zmail v1.0
Message-ID: <20260521195015105Y4zvKHj0TfPZEujixy9Vo@zte.com.cn>
Date: Thu, 21 May 2026 19:50:15 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9zbHViOiBmcmVlIHJldHVybmVkIHBmbWVtYWxsb2Mgc2hlYXZlcyB2aWEgZnJlZV9lbXB0eV9zaGVhZigp?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64LBoCAH057581
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 21 May 2026 19:50:16 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0EF178.002/4gLmtc5pfsz5BNS0
X-Rspam-User: 
X-Rspamd-Queue-Id: AF7C540009
X-Rspamd-Server: rspam04
X-Stat-Signature: egg76j4ixt9gj7ckbto1sez81hkea6qm
X-HE-Tag: 1779364222-621964
X-HE-Meta: U2FsdGVkX18nEYIxElQ/gFa34OJEy6Ducgj2CnvGAgVOtwAsWA0q3/3x6MGk/gIAbRhWQsNkHQ/35waXNggyPziw086CoJzS4F4AET2hApn3ZhuNHZRx2Q+XzQ0zjdm4TX9hhnBYSugL664xZPSeN9Q8VgFhAqp+p19acH6W6Rvj2ubjRVN4dYAjT/6f20gm5ZNLZzUW2/oOX2vYjG0lhzXTtG0k2Vo7NfNp72IGqj6l3Yp4UkRRTxuZvDd3M9hRqAxg4ZfeiFWPkoSX3KEbuj8CuEHUYIoJU25ixE/8tlo4v46KQI+BZailWeR2TLo68eFmoM0Vju3X3hXYgD0myNDUmRgaSUhzsRBjzE9R0+YS2urYGEnY1ggMhZKxaqIP5CFQ57k2LT+8YJOUp5JQ1Yxbehufs5JmNaUB8juz4xGpb/eMvbbt9gaocQ2f8zloQLRfHQ5NuIIjiXvgC+fRX4Q5ydCnbIOWOWtekaBCMxXz8PSN0Hcd+Y7m16f5Afqzjs5fUWC+treM6lUMeiMjHBQwTN7kH8TeKbDfHM5ObD+5oVprOOYZ8a8jK1KsJUCkq1jiS6vvQve8aedxkiDjufVVM/NzPxJ0XBp48ACV5dtfGH2N7KKuz7w4y0BYD/YgLeWn+hIJlkfnMfrUY6SH/u5Q8QYX3uic9buF6knHDmtsF6IvKTZ5SVXoO+7pLlOe9NWw/o2FQd6ac32+uPuhYns6xKcUQK7XBlv/xxr4zrnzPke7yqev+HugbNOtCXIFHIHIsBnnDydEZQTIClmMU0f3o+sfltbC9ADrCOhhGiwgdxIie2WbX+Sfh33vag5yKpCNDxQ+P68tM6pquc9F//zE79UQsyau0k+tcd1866xbMuu7oWblDi6Bf7Ud6FpaSJaweDsHPuPlycBwu+WuowCyVZdFGqErx7brFv/Vaa+FGB1YlKv34C9eI8ZhRgAcgwgZdG9Z1vdmdc+vUOU
 ftZFeMk4
 8ELsQJb1ACybHiE+HSAOs/o+XODNC1dwhSIp4wJnswH+lCLNaxBzrNOZHeMt5aQ+gugu1/cEb+ACBC85qclq6qj8iHRBJX2GaX+PgJlbaZ2iS/FeusZf10v2kbMzOSO1ssUJvu/pBw5GTkAlqmQuutFoVlhSoIDPohaQ7Y6i7SxNc5me6y/cjcmd3En4s/gLwqvX8a2F+1RYnewZeC19kdbjlHQjtX5hLVMkVXEu0IOL4bnbZ7l1bM7TuzCXYT+oWKVbSUXy9L0yvsaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

Regular sized sheaves are allocated through alloc_empty_sheaf(), which
sets __GFP_NO_OBJ_EXT. free_empty_sheaf() is the matching free helper
for such sheaves. It marks kmalloc sheaves with an empty codetag before
kfree(), avoiding the alloc_tag_sub() warning for intentionally missing
object extensions.

kmem_cache_return_sheaf() currently handles returned pfmemalloc sheaves
in the same branch as oversize sheaves and uses kfree(). That is right
for oversize sheaves, which are allocated directly with kzalloc_flex(),
but it misses the matching free path for regular sized pfmemalloc sheaves
that came from alloc_empty_sheaf().

Split the two cases. Keep plain kfree() for capacity-mismatched oversize
sheaves, and use free_empty_sheaf() after flushing returned pfmemalloc
regular sheaves.

Fixes: <1ce20c2> ("slab: handle pfmemalloc slabs properly with sheaves")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
 mm/slub.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 04692a6f9128..a6b720fa79ad 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5094,13 +5094,18 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	struct slub_percpu_sheaves *pcs;
 	struct node_barn *barn;

-	if (unlikely((sheaf->capacity != s->sheaf_capacity)
-		     || sheaf->pfmemalloc)) {
+	if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
 		sheaf_flush_unused(s, sheaf);
 		kfree(sheaf);
 		return;
 	}

+	if (unlikely(sheaf->pfmemalloc)) {
+		sheaf_flush_unused(s, sheaf);
+		free_empty_sheaf(s, sheaf);
+		return;
+	}
+
 	local_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	barn = get_barn(s);
-- 
2.25.1


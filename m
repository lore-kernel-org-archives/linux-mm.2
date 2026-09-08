Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8692C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E433E6B0093; Mon,  7 Sep 2026 23:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A576B009F; Mon,  7 Sep 2026 23:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58136B00A1; Mon,  7 Sep 2026 23:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5B8D6B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:19:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40F54A0394
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:19:26 +0000 (UTC)
X-FDA: 85189139532.28.77577F2
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6CF50160002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:19:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788837563;
	b=6EJsiH51X5h0pR+zJlV2QfE95lnUsNEIXO0cqb8XVJkup2ILEEEXZM5Ax6qpC7q4Blce0+
	IlI4D09QlKYZ4T4vOau7A0n60GyIPyPe358Oakug7eE2GSHjOlUHnD2sn5nfGbzZ3F5tF3
	sk/vgW5WyxgczIiXbZyl8BweDWDSts0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788837563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vy/i9A6mkE1v5tC5uE5IThXyMBBe4xFvzxnC4IMvkRE=;
	b=lxYm5ltTJBrduMchgcPXOo0won12OSuvUuYLiY0CZg8p+kHed1L+NnYmLJNjJzv1hjUSEU
	L8UTQIVHYyuJ8eaP0Jor9o2j8/TiMKov3nHLk7CKMjokk8RqxuGwHEm+/5aQCq+s52RXOy
	XKSegkZa1JRpHDhfSS/bsy790n1U+tQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
X-UUID: 110f5742ab3411f19a56ed5b684f684d-20260908
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:35e9f908-a554-48eb-987a-073a9f7dc827,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:f2aa7d636663486bd5c464afcb28c61f,BulkI
	D:nil,BulkQuantity:0,SF:81|82|102|850|865|898,TC:nil,Content:0|15|50|99,ED
	M:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 110f5742ab3411f19a56ed5b684f684d-20260908
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 24674537; Tue, 08 Sep 2026 11:19:13 +0800
From: Qiqi Liu <liuqiqi@kylinos.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rostedt@goodmis.org,
	gourry@gourry.net,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [PATCH v2] mm: page_alloc: add missing hooks to bulk allocation path
Date: Tue,  8 Sep 2026 11:19:09 +0800
Message-Id: <20260908031909.91771-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907120949.418450-1-liuqiqi@kylinos.cn>
References: <20260907120949.418450-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CF50160002
X-Stat-Signature: dp13srow5jfngadwekmnmg3m3z1oct9a
X-HE-Tag: 1788837562-365967
X-HE-Meta: U2FsdGVkX18ZJVUypg2BthJUdNWESWeMH1PcwuS5lgUo6HDKVDml0mJ1Pw0BPhNGxOOLOlYPB5nv9sJq3DcpOzXtCIgx8m9zmXPBW48XvED3UD9zwv3MIr+kbz2YGY9JgaFC5SmUzlE3ZL/T9rAVEmkNeccmz9xHUqGOJ9jnk1sgl0LQw+xggeU7uxEiNKAwkfgTpgPrfUrOHut4GRfb1fCETrrf+7OP0CggNWvsqIu7cYxBLJOnFFrar4ikLpOHqnXn4JEpfCBZT1nqYjZevA1lfYsKA0agfrRZQIbXWssB0mdFkzKhubW4fq+2tDH/WWGlHF5DjAyapk6WJjZ2OBGmY9w+8pQhIKqMI6QMDHI1oDNVIK8T/1b06qPtlt+QzkX7/Sp7GJVInWVnGuZxOM5XLcy85rth+oW1+LRtPKMFPJ+P2SHSJPPmu1mNolDCIGX2hVX3hHYeNzS46ZLsejxgp7eZqwr8Oqf0FQ2z4kpTtlj/nHVykZLQfw/8pvCJeB231JYp9A0f6ztXeIbwFmwkxFEzT7GNaYaCdzvvVGGwScKyDMkuB0xFSUl6cNwAESNN7UCACHoYpDI9l9tJJr4Cvj3p4tgCObhgqw3a/tYrHclYvIYpRFTSiqJG3fsrkNtw0VqIXVb9vodkkZKWHPXoKRYa6aFg+J+zYmC4zFoIkS+8Lns3y4bZi0tltCoXCmm8QAkbaxep/8mKta2Wy3SbyYTYrmA67eOiaJAHoQE5oGwve7YFfQ0uXDArWYnAWCU8/KnvOomS6nLftjVOxdCfQVNzyfBW+xEb/UoHgY3DpUUCMpZPPq3c0EOdwE7FRAGgdhNT0jMVDX7mujmAWQeK4EZT7cAzkOv7rGZgxxTbpdQR5qbYggKq03BpWsK/iZimeXH35xqjPAoFnv1NNek1tL3SQOjZmDjV1vdBXdhmQJwAvqHoBVVuLPhnWt1xbux3yz+B1QtDoZKhc7K
 lPGaqFhF
 Gu97R0FoQiEbDbDlCXfxwC6lKNkB/bPnPfNUjOvo30RX0XxemMBx5snDPTQHqX9SkMFILDVAeZQnwdJsnSNFoi9a4RiF8ZqJP9KduYQjSlggyjAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bulk allocation path in alloc_pages_bulk_noprof() currently misses
trace_mm_page_alloc() and kmsan_alloc_page() calls, leaving bulk-allocated
pages invisible to ftrace/BPF/perf and leaving KMSAN shadow memory stale.

Add both calls after set_page_refcounted() in the bulk loop to match the
standard allocation path. Both are no-ops when their respective features
are disabled, so there is no overhead in production kernels.

Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..02ba19f6dbb5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5280,6 +5280,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
 		set_page_refcounted(page);
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
+		kmsan_alloc_page(page, 0, gfp);
 		page_array[nr_populated++] = page;
 	}
 
-- 
2.25.1



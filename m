Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE477C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 07:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C686B0088; Tue, 15 Sep 2026 03:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE366B008C; Tue, 15 Sep 2026 03:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3046B0093; Tue, 15 Sep 2026 03:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B28C6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:49:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95B61160329
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:49:53 +0000 (UTC)
X-FDA: 85215222666.12.076A472
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id D42551C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:49:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789458591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=1LrbYR68lJcsvX6vkqbvpsWBdJPb0k388P3jDx/V1z0=;
	b=22Epv7dYe1Nz45yVFbdilyMSBMs/FXtjvt0bw5bvXyWEQbXW34hX8pKDINnKR4O5tDaGgp
	acooNCPkzhcHxHsN7fvYMGLzEN4/GYk5NYG5QuMC20QhleBTLHkTyXSXTdfx2pKPkmYajA
	jOVAvj4I01lB4y+S2hJLwoygjrCuRvI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789458591;
	b=6QUhjOkpTP1JnyMoIWL0IZ6ZgX4Gc3vs7oc5L/dhJV4pT3+GY17pmz4ChOwoMF5H1ufwxm
	APMq4tAZmdM7b77vlD8hAdwhyKsLd9shvSlOYxt1jDttq8s4ll8R3PEWqT/KMWflhOx+/M
	yV6YHWTgddy6Jml0u6AFIkgsB4aNT20=
X-UUID: 03a7a7cab0da11f19a56ed5b684f684d-20260915
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:8f2ab040-5536-41ad-8532-fb9d25d4391b,IP:0,U
	RL:25,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:50
X-CID-META: VersionHash:7db8b62,CLOUDID:698a00d3bc0c39f0ec6b3b8d823d0796,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50|99,EDM:5,IP
	:nil,URL:99|11|95|82|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 03a7a7cab0da11f19a56ed5b684f684d-20260915
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2140594793; Tue, 15 Sep 2026 15:49:43 +0800
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
	stable@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [PATCH v3] mm/page_alloc: apply per-task GFP context in bulk allocator
Date: Tue, 15 Sep 2026 15:49:28 +0800
Message-Id: <20260915074928.327471-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D42551C0003
X-Stat-Signature: b7arozng6n61wxxq74q45f3ydio3mbzy
X-Rspam-User: 
X-HE-Tag: 1789458590-581958
X-HE-Meta: U2FsdGVkX1/KIeYsAPQEzFlpAP5qQKa/XUg0K5HoXLU5g96kr9H+eWjzDXFEUCxrEOZmSF4Dl0uU5EPG+hLueiXKd3GkYka0jdmL/aCGQBC1ac/UKVptbmaWIiNdPUKCFvfMPHl63VhIcYT2n3ANy9eCjxi8kH2DJeNfDvvm29spf3lu/HDMYp+tchY6WHWc4DudDY+fSflksWetDhFn7eJ6xi2KyiIx8iDbUvSF0U7/rmZJUibkyp8p0vj18+LZXL/pLXu9eRq9l/ny1TM3PCOo65m3M2QqGChaq2k/34144pB5p+WzhhI2KbydRh9aGirO7uiv0vyIN6OvhIAasC8M9McndRmYPw+qNRLMdOTnSELf/O+PJyh9BwxCmA4RY+H+Ld0y6ZRUzNdNFE7705zb+uiVi8z/z43z6YdYNufCXX967AXjK44zN0nQZtK3KXzNmqQvyuTorEGD4hfrHq4e5AddQV11hH9bGM9NEh1FgnTcrTlXnhvF4Q06U799BxToblA1wZBO3Ioo6qZHQZBlatT/Btu+/v+B1c9/Ha61owHPG+NA8jkhpadoMeV7tIM5ozj8Z5xEnGX0DiZ8s3itry9Bc4x58pqt1R2rBAWlMEF1//6/MIWfwKpnb7Qf36hDVQhNXHvqWZokAWv45nuWtx8O3QIFdBilZ+wxaXGXk7/5CegTkxBvZVaJmTs6iCTrd7VFbqMcRCWHnp8EpG23HbHi1yR7EUQ4dQH6FtnCxgVQndBdj27pgv0tpxXx+yCEbmhNsdtgapOrlAZEaKJtkyx08T0uvhGc8WGK6G2Y6KsBd0nU0eB/QsMgocWCPETRQlVIxfY/6OoS20/aG2FaelOIDa7fRR17EucEVs/0iuX2aQYI2HZD5P0mxeE4mANI3UNHXoRwmr3aVsF/mHMwPy+bUTBJQhjCQVWyKlfS3mkSODlwbXifXw7BnhkHlpfKk8IqDa400IoOoUm
 AdidEqEH
 31Y9YceXxxSKdXvGSM2Ya8K7cBVJ4Iww1aXraKw1xmcGwTCYsEIm8i9hsCRaybelXENeF6/PNVB562lxGGrUWxaFghXJgK+VXSYmGH9wex+PLzl1hCq2ZHcIofBLeMb9lHf1o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pages_bulk_noprof() does not call current_gfp_context(), so
per-task scoped allocation constraints (PF_MEMALLOC_NOIO,
PF_MEMALLOC_NOFS, PF_MEMALLOC_PIN) are not applied on the bulk
fast path.

By ignoring PF_MEMALLOC_NOIO and PF_MEMALLOC_NOFS, the allocation can
theoretically result in a deadlock.

Ignoring PF_MEMALLOC_PIN also has consequences: without clearing
__GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for
the PCP list, and a task with PF_MEMALLOC_PIN set receives movable
pages from the bulk allocator.  Once pinned, these pages can no
longer be migrated but remain in MOVABLE pageblocks, violating the
mobility contract.  This can increase fragmentation and interfere
with compaction or contiguous-memory allocations, eventually
surfacing as higher allocation latency or allocation failures under
memory pressure.

Found via review of the bulk allocation tracepoint hooks [1].

[1] https://lore.kernel.org/all/20260907120949.418450-1-liuqiqi@kylinos.cn/
Link: https://sashiko.dev/#/patchset/20260907120949.418450-1-liuqiqi%40kylinos.cn
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..3be7288a1aa7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5207,6 +5207,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
+	gfp = current_gfp_context(gfp);
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
-- 
2.25.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617D1C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597706B008A; Tue,  8 Sep 2026 02:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549776B0098; Tue,  8 Sep 2026 02:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E816B00B0; Tue,  8 Sep 2026 02:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21E3D6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:51:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EC3D160386
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:51:02 +0000 (UTC)
X-FDA: 85189672764.29.035C1C0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4F4D9180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:50:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788850260;
	b=YizytiZ7SHdSQbYd4SF+5ccLLHYBsJahMw571Dq0kN/YNpnNTTBX8q1wKN1xG05cYNDHfy
	YUuaIQzEq+QJwEEvm+JwqltR5HqV7c80ZYTj3qIN+Z8c/3ABBtw8ArANtI4JEHGahQyYXc
	T2J4feMdmn48M2yuqWp2ShbHwIvpccA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788850260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zNVbKr+BOy40cKruLZlBTv3PlLm2XSJZoqQLyWV42tk=;
	b=5Om8dLpxxY7EUmyI/HhVO2fOYY8KddrmZyc3iJLV+GfSI5TNbz3VO4iRZHVGoDh1JqwARR
	YNUqj3O9KRw9Wh9b4uk0GwXYjdeJfQN5E4rdSEB7f7K6TAsdQcyGpQyDhcJf3jiGRrD5Bd
	TcnrqLGuG4gI3K6MH6h3dp8utUNhdmQ=
X-UUID: 9f07f438ab5111f19a56ed5b684f684d-20260908
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:fbcbc149-e036-4ab9-acd7-25072a84f49e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:87ba067fa001faebc6bb9e21890526b9,BulkI
	D:nil,BulkQuantity:0,SF:81|82|102|850|865|898,TC:nil,Content:0|15|50|99,ED
	M:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9f07f438ab5111f19a56ed5b684f684d-20260908
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1618917366; Tue, 08 Sep 2026 14:50:47 +0800
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
Subject: [PATCH v3] mm: page_alloc: add missing hooks to bulk allocation path
Date: Tue,  8 Sep 2026 14:50:43 +0800
Message-Id: <20260908065043.217569-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907120949.418450-1-liuqiqi@kylinos.cn>
References: <20260907120949.418450-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F4D9180002
X-Stat-Signature: drobxqeaubwhtejrkuqs7tcz31jo9zh6
X-HE-Tag: 1788850258-621183
X-HE-Meta: U2FsdGVkX19YPKtlwSmlYMUA8+1zMYt5hQqPmvIXh8l4D0QfmKHcKQi+jFSPBLmd5CZAk+mVK60USPduK4Qa8qIod0lyT/81zPX8ey0HPErucPROXIS3ti/WN9aBJyvU+XVh7OAsCBiPHGrQRtogA6UmRNbamQcnO3XBp9ZjP1eN+GFba6H3uC/QCTyFQwN9n/ZGELOT3ugurtFE6rovvO/9SRHqZjfl/5HSV4fzfqE+b5oYkG8XJ864rh71WWlHbaetsVtDz+rQ43Y2r0CGXRTlBEiHZc4wRnQvvGIKu8GUbQpe4JSxgBd0b0/+JyLfqQG0jCL/1QFi3kdVrFVggMt/Sy5Stws4QslW0UVp6FAscEE61f9//COndlmEW0ZjXiRNflDnzdG5gaAk9oHPTf4pbx7jBrbcInDImyrBy89KHJcmebXV06QKHV2N9nzo/GQtQzmv1/4/1GxbuPi50zojwtNmf59nfuSBii9f2VsyEdFCRoXAPlcK58n7yCfl5U5SrwirXPKf81JmEDbKYC/gawc8sgsgtBIhnHfLZHx+HB8nQFi/07G9BtBKHXiooEArtUtZqK5MaBQv9zaaA4xZTJDfABzZDrUBKnKwEELXNeEbhY1JCAF4huX9BP+aDmRGLyinS0FoSRL///AsaCZVmOSTzw144wiXqJTy7aoF2yywgXk8M/gFfJHELyvOJ/LWiJuJyQ0E0PZjL81l080PzM0027B3D0+0zSwzgGZE6ZoWN6k6nY6iYJCeTCSloWYExuuEj333AgBUQWzDWlDdAvJwUPN8Y7xTNd1KXkFETSXE8Ft/P2H07Tl7jnEU7MlK3pguLzOIg443GjcMiyEdsCx5aLmC6HTJ3reLksm1Sqlalna4UvuhRFEdBirMdJlwgmRtkEIRjbkyF4lWL9vQSiN0U3PMprA1Imb1hHE7lMdyRKWkgI0ACRXr36505Q803qTDDKyRG0VFKPz
 AoENe2Ci
 OSnek6VZCdMB2qa6XXT1xR5QmqrscTKF27XxsH5E3tXc6tRpO8KjiKv8mjX6nU0z2v6rjOwOaazwkpHaft9ktneonBdSKfrVCaBPQB+KHbVGG1zM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bulk allocation path in alloc_pages_bulk_noprof() currently misses
trace_mm_page_alloc() and kmsan_alloc_page() calls, leaving bulk-allocated
pages invisible to ftrace/BPF/perf and leaving KMSAN shadow memory stale.

Add both calls after set_page_refcounted() in the bulk loop to match
the standard allocation path. The gfp mask passed to kmsan_alloc_page()
is stripped of __GFP_RECLAIM because the bulk loop runs under the PCP
spinlock, and KMSAN's stack depot allocation must not sleep.

Both are no-ops when their respective features are disabled, so there
is no overhead in production kernels.

Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..73c73499a051 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5280,6 +5280,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
 		set_page_refcounted(page);
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
+		kmsan_alloc_page(page, 0, gfp & ~__GFP_RECLAIM);
 		page_array[nr_populated++] = page;
 	}
 
-- 
2.25.1



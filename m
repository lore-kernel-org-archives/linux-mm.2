Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACBFCD6E49
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1BA6B0088; Thu, 28 May 2026 09:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577BA6B008A; Thu, 28 May 2026 09:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A706B0092; Thu, 28 May 2026 09:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF736B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:42:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0A6B1C1F2A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:42:42 +0000 (UTC)
X-FDA: 84816943764.20.8F26ECD
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 069E7A0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:42:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779975760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lEnHgyvE2M4DJz6U+CaN1QiYFyUMI1I08rCF0jakQ6E=;
	b=6LQUNuC2UjK4SY/ca9z0Px8pzjipFJY1RgRCE0186pmhdglGxtfS3yraihOHo8v8wcIkyk
	x9qXB+J+IsNYtoo5GSQRyTtppqrRsSuEF0XyVLJ/Nd42oooM8dSc/OHpMvo3WtAo2udFjR
	S92mZCPz+c2C/ApZOMONG9+NRxov8uQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779975760; a=rsa-sha256;
	cv=none;
	b=iyIY12otyDUpecsc1fl27xKoRzcLZbuMT1S2BSSzpL3DJtyl4usMzJNR2oXqk4dAc2esIy
	tRSucdUPX9hzEXTvWpEyLhaJjW94xCQw/QGHyJ1vtejoifrA3W+hLV0+Vr0I6cvgwsfmEh
	RY2hgOrlsPTlpyAWVpZk8rK4vmgtIUU=
X-UUID: 13c665785a9b11f1aa26b74ffac11d73-20260528
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ab36454b-9f05-421a-9205-64d07ea47e56,IP:15,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:ab36454b-9f05-421a-9205-64d07ea47e56,IP:15,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:42ae2bfba8560986a52cbf559157ad2d,BulkI
	D:260528214234ISS1MR9D,BulkQuantity:0,Recheck:0,SF:17|19|66|78|81|82|102|1
	23|127|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:n
	il,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 13c665785a9b11f1aa26b74ffac11d73-20260528
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(39.156.73.13)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1987843736; Thu, 28 May 2026 21:42:32 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	ying.huang@linux.alibaba.com,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [PATCH 1/1] mm/memory-tier: add node_tier_id as stable tier identifier
Date: Thu, 28 May 2026 21:42:12 +0800
Message-Id: <20260528134212.240492-2-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260528134212.240492-1-liuqiqi@kylinos.cn>
References: <20260528134212.240492-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 069E7A0005
X-Stat-Signature: syrcnitzaz1ojey1ds9a9hzfs8amjuy4
X-Rspam-User: 
X-HE-Tag: 1779975759-102620
X-HE-Meta: U2FsdGVkX1/Nx+YB+w0aE8Gl2BbwGYlUku5gtV/fx+qB8TsnWVefbvGj7pOW6ErQqDmfZGL+MFArfN1T1Mxpvd+P1W9fCLmN9mAFlawC40EC3CKOOcsjwwdNg/wVtUPeSOKKR0QNplb5c8nqHUU+hOVQUvYX45/K0VlqfCetwmlo66QY5gE1uhXQKRug1JGiZqcfRCmFjt1ngAwfSt0/bq64l9TZhmBqc1Y60IfhVaJh/Gt81rjS6qtP5PUA9sg9GEB3uydcK5zK9pn1eYT7JLfYCQ2HlSUn/TlL2+ZLPpBUlL67jAr6QQj6PfnWiZkZcTm4k42MLG1ZgCkL/L7rGMMxgP0/TZpQRuAqgssoxH/tyOjou6++0UrUQuSUvJaY4mqwTUtwy1dqm82E4OySEq+1SMDB93ZW83rjeFbQVkXlRBf0GjrWUvhQ/XTUaxQ6Z1LB9PID0qqlWlatuplc1J8d8Mp6TA+79sBlVFAed/klkUdrxYLj5i9vkOVRsq+0gRTe7M3DV9j+2wpMPfdEzwJR6OtS9B3g7CBgoWvA71nP6XGjFkZ14VtnKc6IRhWkaME86J7CQhgHKz8F1iPIBadReM4P/UEuUlyyzDzGJvzLoQeNqhB7SO7RpIxq5UGaaOIrtKNXS9qMTdj3FHOChzzWPthJjw/x55wh+ni4RS4jx6KU69ub6VttKPJz2iYiNQjLdh9BzdMYT08E7A7IIb2EEHHKlifS5Vqn+9G1wvTBpkRcxaBTc7ZZPrXbSJV+j25QYVx2NqaBmFuoZ+uY06yQsasbsUi8da9ZOexqCP7efERdHHtXDwZ0X7nTyATjz0GJORrxPoI7lnVcaOcN+6tSz4RqhkALj5kOOa26B8cnFmoGZre2T8+l9/2kkJEf5nH0EIJH1T6ixMIS3e7lZh7Yey/TGlD+YNhh8UE5G3e5i1heyjVkwUNV/UGCvVgAK3j6iUNAjQFbdhx/THR
 Osetv8+v
 ik/AOPe7xpebGavb5GlIlZFpuax9OV5ACQdiUn9q5lIC+Y84RLqlkUb/xzxDloC876/U9eDN+6qA9EJbjtzO+ddlrxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiqi Liu <liuqiqi@kylinos.cn>

The memory tier subsystem tracks node-to-tier relationships via
pglist_data::memtier, which is an RCU-protected pointer. This makes it
unsuitable for lockless, low-overhead contexts.

Introduce pglist_data::node_tier_id to cache the stable memory tier
dev.id for each NUMA node. The field is updated together with
pgdat->memtier and can be safely read using READ_ONCE() from any
context.

Key properties:

- Stable across tier reconfiguration
- Safe for lockless readers
- Does not require RCU protection
- Complements, but does not replace, pglist_data::memtier

This is infrastructure work. Future consumers can build on top of this
mechanism.

No functional change intended.

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 include/linux/mmzone.h | 2 ++
 mm/memory-tiers.c      | 4 +++-
 mm/mm_init.c           | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..6b5a6da3f821 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1605,6 +1605,8 @@ typedef struct pglist_data {
 	atomic_long_t		vm_stat[NR_VM_NODE_STAT_ITEMS];
 #ifdef CONFIG_NUMA
 	struct memory_tier __rcu *memtier;
+	/* stable tier dev.id, lockless, hot-path safe. */
+	int node_tier_id;
 #endif
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..cfb3aa56b4c3 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -566,8 +566,10 @@ static struct memory_tier *set_node_memory_tier(int node)
 	memtype = node_memory_types[node].memtype;
 	node_set(node, memtype->nodes);
 	memtier = find_create_memory_tier(memtype);
-	if (!IS_ERR(memtier))
+	if (!IS_ERR(memtier)) {
 		rcu_assign_pointer(pgdat->memtier, memtier);
+		pgdat->node_tier_id = memtier->dev.id;
+	}
 	return memtier;
 }
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..db72456fb14c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1711,6 +1711,7 @@ static void __init free_area_init_node(int nid)
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = start_pfn;
 	pgdat->per_cpu_nodestats = NULL;
+	pgdat->node_tier_id = -1;
 
 	if (start_pfn != end_pfn) {
 		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
-- 
2.25.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84A8C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 08:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0F96B008A; Sat, 11 Jul 2026 04:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81A16B008C; Sat, 11 Jul 2026 04:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70CB6B0092; Sat, 11 Jul 2026 04:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 867B66B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:46:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 241261698A0
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:46:41 +0000 (UTC)
X-FDA: 84975865002.16.678EC96
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id 081DA40006
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:46:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783759598;
	b=19Ku+FYkx1WmnmOePkwXHFfKJHYXd8Q/RPWx/IUx7jEdkZcKX2g4mfgO98/Js06OX7p98i
	gmR81l70cIaq+06393sA5zwyb+EdlPN8mKom22CU8VLfZplNjzrqHj9NybD/8LLlopMiBM
	kfqz5a08JiWe839GckyZYzPamFN33zo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783759598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=T9h+VJ1d4OOfGUM8e7vfZnAjiR5B+FBRChUlXsmz0uU=;
	b=t6YUkMhfGvG+yqFqdyOuytecCXgQNaZLKVH1Yx/mWKIT4eMjBuB1xkNl8920oDSzMmjaJD
	kc2iCqb4HpBOfv2blx6FB0JRMWksE+atiSDOUChq41Z4eiaY5QAg8O02Kfb7DQPk7oO/Bt
	pO/aLmg68EuXJz7LRNKs7jGW7ZZuhi0=
X-UUID: 01f9e8747d0511f1aa26b74ffac11d73-20260711
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ba486e74-fc71-4415-8b5a-585d5b3e3a08,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:6be4078e0d1b9d067f170c49f73b2977,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 01f9e8747d0511f1aa26b74ffac11d73-20260711
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 798131107; Sat, 11 Jul 2026 16:46:28 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm: huge_memory: Fix kobject cleanup in thpsize_create error
Date: Sat, 11 Jul 2026 16:46:24 +0800
Message-Id: <20260711084624.207777-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 081DA40006
X-Rspam-User: 
X-Stat-Signature: nd5ewsooa416ew1pyqi47ofo15u4gwt9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783759596-730955
X-HE-Meta: U2FsdGVkX1/gFbB0Op2fLBp3UZ4bZDXaBLvgOWVDeVT7D8GC1eLu177RdwVzWdSaRGHkojs3og9gpoiGcyHWNtj/+uMEz2aZrNfNzo+sgFfQR41/CuOHzQOF27sd6m7nVRQHiB8WpeJLFeRH9leyD2/r/u/OOrAWjMIumqDhbfSkR8yTRiswuUeVt1kSikx8RCGpNBq2pqtV35W0tVUmMisaQvuSnJVz2oQPBDCjEHlkiu0VlfPcGLvCqwiD7dOPgxCfdnLV5UzHyNZdx1pD/On/EuHGilKYRtrPl7sZKjHMpfXSyjEXkjFQo1gjed53fuuv73lO6FzuUqBfNSNojvrmSYGTxNltqfnHviueSbiMVFamIhPFei843RldAU9bamN6SkwC8jihtxBgWMn/CX1Go7YAd6gVFp6xcjm7RQSP6MoGkBmKTPMisKKzgVuHfVkE3XQQWmvYOqc2s6Md9IwsWHd2WPAY9JM3+kWOaWJx8MqNhznsnm+NVkP2Pc/uogx82htuwOsA9NxwywGvJoON/nAd9dxGdBRXGA+FCQ0hxXWXpsHDtT6ZNfTZLZB6eykl1Z48z9ZK+EhNKOv6mFR90lxUKVueMPTCGYVty24k0QrjwbFj/zNsFCc4986AVrUm50GIqLXWdQ0SDtACfcE3bhTQVqhAlTce+WUlqktECrzOiyi3yGvmjupT7MQxN0xXZlFSlvZpsTJ+YdAuWuE4ThtmZJu6JLZM/ds0OVY5oNe6zbZzCybgK3Z0d1ypBq1zQGQediPnHe8zhrjhpVg+ZUx/HhRprltCZ7vNA5l8VNa9eC58jneODghnOhaqznOmjvlqUxBXJat6GeC60Ag6eAv5mUAN0LkYISp+w0X9uyRC0BPaYWNSwchwk6Cy+NTF36ySTFHnF/sOy9CEtgzi2S/jpR/LJVJPXSrshmkNMJZGlCl7Y8WGMYjfKp8Uf+sE7UH8Um8AankCnZ8
 iwIicMGq
 PxrRXbDFlvWa0eaBCFGlTpTsPgvIVY7AaqiWSdGCHrsxk7T5VjAvmqBlSwTuqS/TQvYPbB6U4V/ytS6LDDhWviQRqMg6vphGAiNwp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kobject_init_and_add() fails, the kobject API requires calling
kobject_put() to properly clean up the memory, not direct kfree().

According to the kobject API documentation, kobject_init_and_add()
calls kobject_init() internally. If the subsequent kobject_add()
fails, the kobject has still been initialized and must be cleaned up
via the reference count mechanism (kobject_put), not direct kfree().

Direct kfree() leaves the kobject's internal state (including the
reference count and kset membership) uncleaned, which can cause:
 - Memory leaks of kobject internal structures
 - Potential use-after-free if there are pending references
 - Inconsistent state with the rest of the error handling code

This fix matches the pattern used elsewhere in the kernel and in the
same function (err_put label) which correctly uses kobject_put().

Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..7aeb17d60ac7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -819,7 +819,7 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
 	if (ret) {
-		kfree(thpsize);
+		kobject_put(&thpsize->kobj);
 		goto err;
 	}
 
-- 
2.25.1



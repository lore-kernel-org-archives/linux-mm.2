Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 383B4CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 03:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5568F6B0005; Tue, 20 Jan 2026 22:48:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502E46B0088; Tue, 20 Jan 2026 22:48:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40ECE6B0089; Tue, 20 Jan 2026 22:48:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33AC86B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:48:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2FDC5ABB7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:48:32 +0000 (UTC)
X-FDA: 84354588864.30.F0F4480
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3C88160006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:48:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768967311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=fYrwEAuBJ9+x/sJptaN+0uDOyhLkw6EcQvSFcfqPj9Q=;
	b=vac/A47THh20lMPN108ERippkUuCbzQu5dsaD/So1OvhqUHkRDee/PNpJ3qefmO+X6DA3h
	poBrOan+EQbRHJNbZj/LFuXnCd4Io0pOslH411eaEVk1JIOuyUP+lXrpMvHuh5bSU+g8YJ
	hkEwU5TLLNElY8LB/cTUBrAMoczFr34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768967311; a=rsa-sha256;
	cv=none;
	b=o1QI/pAam4NyyQ7OrCQIb5Q5kFEJdJKefT8WhvoMfYBXBk2NbmoYMJ8cyxUUS4A8tNrUpx
	l9VNspb5dspz7GPtqZiDPmvFsoffZGkWV8GHgJnx8yAEqViTs/F2qITBCIOg2qU0CfV5KE
	RIihKgHGt2k4FETrmbQOyvq8zOr4bS4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
X-UUID: 083431d2f67c11f0b0f03b4cfa9209d1-20260121
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:78d9c00c-3ca0-4351-8e91-e8470a25bfb3,IP:0,UR
	L:0,TC:0,Content:-25,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-50
X-CID-META: VersionHash:a9d874c,CLOUDID:584130e69e5ac565d386589d7a86afc4,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:2
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 083431d2f67c11f0b0f03b4cfa9209d1-20260121
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 684165713; Wed, 21 Jan 2026 11:48:22 +0800
From: zenghongling <zenghongling@kylinos.cn>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH] mm: Use %pe format specifier for error pointers
Date: Wed, 21 Jan 2026 11:48:17 +0800
Message-Id: <20260121034817.607435-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 838f7kp56pra4at7b7m5jjz1dj9pgdmk
X-Rspamd-Queue-Id: E3C88160006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1768967309-717692
X-HE-Meta: U2FsdGVkX199HGS2A9G78DN6eZXY+4jra63vZMn6yKdUbc1U9LW1QE1t+0uYEI2ibZ3pEv8mdywRuTsG+wLg9f/45YE4Zzs6qiByuhipv4VhOGV5Mq7WTNRVv1gaFx5+LcrsP7quqtNGcq+B4dJjFGE+p/gvmxtDQUWoRz2lHZSiW+fFFZ1UVfgSyF/KkjsHNfm+1KOS4lar6n2c6zoypRvV0dtghwQCegdfJajd+K6O+OeUZtveeqK24OwVFIlqDONXXruQx0i15xryZnm80HjjhjRQ/nBupVhKuvdz2haYSPIlY9eeayg1YKK/fg3RI+pyCjKDWrQBbaLX68ux0L1AyMI1mTWGPdp9P2mGMhtICl8EpPqp982euCLfEEflzTaT8cKTErTl2RBeQYwzkcY2z/UQqrzoP02vqQFxCkkoLYXfnV7kX6AtOiCnqidg1/ZEaMYNCjmYwmF8fGS0VRQgmLGQVUPscWa6BWLRTzicyUcw/FNcV24pPS0fs4FJKhlIyvqFbt4BeMZLGJRCNFxdvpq5Yk4d0fctR5iUNXXr1UKmQgggnUJv4NZMZYud/bL7XfNxFrEzcwSXeyM9xYmX8Ba3LRuk3t7bK96tbfx/ou+N4tlnA/6FNqFOaxgumQGkMXHBrbESOcGjedp173VzPJ07DQedbbZgmZ8+zXjACTYU9ktoACmpJcyH2p2Z0Yp8YKXPtuObbfRy1ye7sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert error logging throughout the MM subsystem to use
the %pe format specifier instead of PTR_ERR() with integer
format specifiers.

Found by:
----
./zswap.c:753:20-27: WARNING: Consider using %pe to print PTR_ERR()
./vmscan.c:7504:12-19: WARNING: Consider using %pe to print PTR_ERR()
---

Signed-off-by: zenghongling <zenghongling@kylinos.cn>
---
 mm/vmscan.c | 4 ++--
 mm/zswap.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..29ed0b304b5c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7500,8 +7500,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d，ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d, ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..c35604db32ad 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
-- 
2.25.1



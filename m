Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFBCC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290B16B0088; Sat, 11 Jul 2026 00:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268A66B008A; Sat, 11 Jul 2026 00:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180E76B008C; Sat, 11 Jul 2026 00:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF0D56B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:18:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 836D61698FB
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:18:37 +0000 (UTC)
X-FDA: 84975189474.16.086DE23
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id A9267180003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:18:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783743515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=B7XdOKgdQalK38PddxqIRo3qWglIAmVDlKWUgTicjbQ=;
	b=Z5C8w0By9sdIpcaUTcZS6Zm2lYHXt3JVvxVIQ+1ApxyxDheVZB64kWSowY17mn1I4mdpz8
	3l6jI5x3zfDdmBH8SW+ihwFqMhO2DVIGY/bC2TotPIFsjrR2RP+j1J8xdyVg6iWpqSS+0U
	zFZst4kzLwSkxJ/AzsAUQwjZkZZ7uBo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783743515;
	b=dhqUKaST9IPDGIAah6/EFJbRro3r9EqUx3hmd79lW1k6ZDfyyfEgYqgRdatzVJ0hs+rD19
	6XZyFDGhnz5HHaa5qoguHlmP+Xan2619zjasz2maYfnTvgHTlhOALECMKSYr1x8PKzKm1C
	EIsePzQ+wO7p6I3/MCsRsL6VsvSDvHw=
X-UUID: 910a68ca7cdf11f1aa26b74ffac11d73-20260711
X-CID-CACHE: Type:Local,Time:202607111215+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:41b0a526-72cd-46ae-bb86-3fd3d12447a7,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:4d2b7686572bcb2e9fb89b31bab63187,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 910a68ca7cdf11f1aa26b74ffac11d73-20260711
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 236819042; Sat, 11 Jul 2026 12:18:27 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm: shrinker: fix double-free in alloc_shrinker_info error path
Date: Sat, 11 Jul 2026 12:18:23 +0800
Message-Id: <20260711041823.95135-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9267180003
X-Stat-Signature: hr5rdd135xo7emsdtxjjh9ahm73fjnpu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783743514-731193
X-HE-Meta: U2FsdGVkX18yuaWh/foHv8zQi63S0ekNk+fR8W8NgsTmS5HwtMqgSf4Q0xnn1ogJRHMJBrx8dfY11SYLndfHjYcNjTMsKc+x4NKkH9zAZfgcZVZwLyGYu+J9Ys5Mye6HDQAAqu/VUxrBbbP7J/PtR5nxryikkqh+hdLrGsS5k2a1qBf0KRNpoFvFw63WGYYsTg7+veDtAI4dtXOEKRYpJO46tfBOjprTAsET+JUn5PYNKPxZmUqiJXRVjDX5UbwrOv5/oTUrddkh6Is5VKhNNMnxAF1W2sXF0yjQFsTejOvaPU9YKft8BTAvElX8s6Dn8nE37r0rg5YyU+2Vu4dDbDC570L3BLldOAOVE5HlrwDNEDgk66oCyPG10AOY7IJuyNblGVnUGBM2QaGvd7EtokbD4JbC9LnDBNWeKfiWyY2TN01rrMgfiFqqgFShRi2QxFkKKf2KhBD14Wp/082dYKJ9yQi8MHTHpwFoL8fPY7lNN1RrahZ4YlmnSGPsk7MB3sOZteJukYWryDFOmCahw41poCdmsaomjAPL6c8+Vh3nxpXTcve6be5ypHqj0MKapN9jhqzmx8gEFjnks6WjJeeEW+M1wuhNvMp8leeko9MFFhZ+oXKSWXBy48TsxEjmKwcpS/teqHNWjDSW2IHXTVXcYwQAhfkfQpVhi3egA5NMNn5Tws4K4GOqVpU5V7wtzLnVXZsvSZ87YXWwBWEU6GCSMIr8rhtJeJOOwn6HdDoxUnLQ8HZ2V/3tosdYFOj50MnbiyP3FMEHerzWf7ogiGLot/M6IYZwDX0a4T8bVLFxqRSY5b3oMe0WZo61KhXPTibJ+hKx+LT7xhYagrhq4InewXefU21YONsISbTkfdsy0fT/09HFKrq0/quBXmd/DUh9bZqeW/NeoKPMbE/VHG5u+Z1hX+xVMb2XHpkCtVt4Q3B+joQdlrbFmcLs/Clhr9rnx3URjmfbntlcp/n
 y9bFlkae
 wE2FamVRkZLQF5T0+NRzUTPi8r4klNnX6XB0twGewon11KFkxMkM6OuzvlJFSmCl8uEoNeGkGGCv8e24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_shrinker_info(), when shrinker_unit_alloc() fails for a node,
the error handler calls free_shrinker_info() which iterates over ALL
nodes and tries to free their shrinker_info. For the failed node,
rcu_assign_pointer() was skipped, so its shrinker_info still points
to old data. This causes double-free of valid shrinker_info structures.

Fix by tracking which node failed and only freeing shrinker_info
structures that were successfully assigned via rcu_assign_pointer()
in this call. Failed/unhandled nodes are left untouched.

Fixes: 4a3ec379aa21 ("mm: shrinker: make shrinker tracking memcg aware")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 mm/shrinker.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7082d01c8c9d..92c6cb455fc9 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -78,6 +78,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int nid, ret = 0;
 	int array_size = 0;
+	int failed_nid;
 
 	mutex_lock(&shrinker_mutex);
 	array_size = shrinker_unit_size(shrinker_nr_max);
@@ -98,8 +99,18 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 	return ret;
 
 err:
+	failed_nid = nid;
+	for_each_node(nid) {
+		struct shrinker_info *info;
+
+		if (nid >= failed_nid)
+			break;
+		info = shrinker_info_protected(memcg, nid);
+		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, NULL);
+		shrinker_unit_free(info, 0);
+		kvfree(info);
+	}
 	mutex_unlock(&shrinker_mutex);
-	free_shrinker_info(memcg);
 	return -ENOMEM;
 }
 
-- 
2.25.1



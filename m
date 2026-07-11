Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A17F0C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32F96B0005; Sat, 11 Jul 2026 00:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AA76B0088; Sat, 11 Jul 2026 00:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E213D6B008A; Sat, 11 Jul 2026 00:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB3526B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:15:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43EFF1A067C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:15:25 +0000 (UTC)
X-FDA: 84975181410.13.CFED4DD
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40005A0003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:15:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783743322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=B7XdOKgdQalK38PddxqIRo3qWglIAmVDlKWUgTicjbQ=;
	b=yvDHW52E67YZvxCOZ2kN7uEAk5v1dTBMzbleC6Lx7w0eoa2Xhk22oLIqNFkvPXa1U77NBL
	3E+b53jIzI8Wb7HsqxvsI0iqk1sbTWukmsKPfPguh5mlSBB9ZsAwUKKwF9ZIM+akZVtBU7
	IjQmlueJNVbBRaRUS5b55LLZNq+4ArI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783743322;
	b=0QTyyXYUGuSgzJY2fQenvyS5QziAIXWWr7izt7o7f7mjQthlcLKxHUApobzcqwxEd6FUfo
	hm/TIpfSE3PO80exr7KiYAEHmh6V+TEMzvA6r+sHIOXGPabK3VpOqKQLlH2AEAibmv8Sxe
	uHHV29Bweac//DAlFF6bjdGzkV0RPL0=
X-UUID: 1d77ca247cdf11f1aa26b74ffac11d73-20260711
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ac1c0899-ffc9-44ec-bd45-f07c830aca9e,IP:0,U
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
X-UUID: 1d77ca247cdf11f1aa26b74ffac11d73-20260711
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1745808913; Sat, 11 Jul 2026 12:15:13 +0800
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
Date: Sat, 11 Jul 2026 12:15:09 +0800
Message-Id: <20260711041509.92926-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40005A0003
X-Stat-Signature: hr5rdd135xo7emsdtxjjh9ahm73fjnpu
X-HE-Tag: 1783743320-825600
X-HE-Meta: U2FsdGVkX18/28gHaHBm8EHoKQkodnNXOilnUQn8nuUVn/nw1e7et4OV6fgL1e1U77RFWwEIuPs4df171lQraagpDnNf0cNuwOJzgC+UG5OiG/5eA2ws/ZpeF46h2HixUg1X8IsEfZw1tTnwavade93zTnhDR3suLPvVkA6ycLbdfUiwYynsb0Td0xDuUYrqKDC6RJ8ZgI7l4kvEIQ+4ogku8M/ZefqCsbC8AC8vcS1CfHM18o2EI+t1AOdcxhVAh5AtEfuFckJyTPAZ5/8v0qR4SZYBIYmqRe9iJ6JaXR4bfqcoEw0fkXG/R8IWihoJXHI0eK6xJidSGSSl1ZQ6yGmXC+AXJjZz/huahtt47n+j7coM6r2tbHLNmPMXJQxGS6OMkQVBANcSvoy53MqAjbEwgKKBIrsobhj4itfeBW9N5nZ/Y5ccy2SjKUM24505337p4B/3/IRLbHpUMuCU3KoPMmHV0jbKYPZ9/xXW0QUE5WZBcEqT2/p5G1igRZpHMzANkGHMsu375GIkrBGYdFFYprmY0QUKHcyGR93aEnAYOsact5T5oVQb/HVgcbW+DqbTr61O9LP/3aV8Dod9+cZJIUTgvCWYSED6JdqWdBzZApIGRgn+ZOkEO7ZqXvfvbwDDn9Do4CFizmJLJ5lyaj4lLCtRjsGbr6cJ2DR9Nw5vcS6Jn141JP8YrkZ0kkyHQylBlZNIkm73tQ0c/gLr4Rh7kLq3UkuXWLalKSZsa32SYWxhzJWlYnM1jDUFUGodlHd9jEX3Z8nUCBp4rRXiAnW93ofOApMm5zXAjmidSBrYMoOdtkc5Jd8aSB0KAtpQydtyooPD/KB8FrqZDE0UneHlxy0hopbh2nbf/mH6FJC8gHn4y5HbDr0Cy1974JXGnnR/txWvAsmIrAPkXjHWh8uq3m1NLmYFJEeTsRGRx7sU9qw9U3SJxiscZT+G+Ke9JfKhPvKCOBEZ/5WT2Fa
 UVZ25OyK
 vIimJ/+JRZcN1pc7AQJ9oM5R8/9NpzK1Aat1IpZVpb+tjw7gmJ9jRg/cbgkb5YzvOzSDwrk+e6dNzt+I=
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



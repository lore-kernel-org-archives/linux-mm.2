Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E3CC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5059D6B0088; Sat, 11 Jul 2026 00:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5026B008A; Sat, 11 Jul 2026 00:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2C86B008C; Sat, 11 Jul 2026 00:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 180FA6B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:20:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AD1A1C8E59
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:20:06 +0000 (UTC)
X-FDA: 84975193212.14.64B3D76
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id DA19D40007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:20:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783743604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=XmfqQjQRIgHhyF0Pu7ZGuSqDmgxI/VEgjOlfmIo0zu0=;
	b=6PZuFSwBXln22FQBj420/3kpB5z4mnS48VHOtZoDcT/draZFjzT6ZdqroK1Eo36Hm/2733
	TElgWbwbipL9rV5PVaIPLBZYnZfScVl0k6aF5Uf3UKHuwJeH0ceQ9IRZdrX9BLhdbMn8Ou
	4ciOXvF1VEoI/h6+/2/IdPEaVRAJjsU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783743604;
	b=752AYp+Mfq2olgWZLC2C8bLh32ajCPYCDIlHaMcLqutfSsTrIBvNqqQ6mRZvSQZlN4Fq7a
	NVQuQ7GF6Xc9gVxjFY/yhuW+EUt4qPX7xDfUGjGfNFagnOwdgS6dv0IvvT3jg5EFunVfsi
	RhOf8Fb1AJ5GMwZvbcDmdVd3x3DI4Oc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
X-UUID: c742c4a07cdf11f1aa26b74ffac11d73-20260711
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8f0cc9af-a872-43b3-8a0c-47185e98c887,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:d01a9fcadf696ed342315feaf3c2f80d,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c742c4a07cdf11f1aa26b74ffac11d73-20260711
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1833275747; Sat, 11 Jul 2026 12:19:58 +0800
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
Subject: [PATCH] mm: shrinker: Fix double-free in alloc_shrinker_info error path
Date: Sat, 11 Jul 2026 12:19:54 +0800
Message-Id: <20260711041954.95749-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA19D40007
X-Stat-Signature: nt5fscgqokri7k7dgoum8wmrnk71tcse
X-HE-Tag: 1783743603-162917
X-HE-Meta: U2FsdGVkX19E+oYVB8TDZfc6vFS2ZJVFcXlrvnvMM6SiNg2bHowJw+frtKb91xB9lFTl2/oCAjPmZIeM1JYGIeMr5xwzDceUzR9gZfRO2jWomgre8+vUxidZ9Lh6zP//ZwP198MeyRyaWRR/2bWkRLaPsZnIbAwxOy8o5g/71k307CJLSw2ELVuzkk4HbNLr6zy0rxUOAhhSrPoS9M26BWTTadeIoxVjSERqyNOAb5kAJ01LEcIleL1luNlcnkXs4eoDHYertRHN7RBDfySJXbGXY1u17r8em/VfPCTAuwdi29dczK4uPjbwN+XiU0jCVNHMR8SpXqOMWP+uRdym6aq6AEP3Z6JqMwUrdqYAbBmOloDFxzD17fMYl4neC55DQpKoaIaGcG/CpQPXKDysFV3whvnU7RF75NX2oN/2XSBN0hRU1u2r+FCmGRUvU1P2nMqUFk/w7zP4MPct+tAt6FB+IQ0xPFOGziWnfXpVudiSuBU5U7ivXmG7CyAOB6CyUuYPFwwkC1G6FWD5SibIDvpcD8QYaWKHrmUy0kYD67o0hT7stTTHawsDoitR9JHzfU7cSlxU5I8UH33+x0KcvXo+wM38RBtLK+bsJDvsIW3omFBiNyz8TR8yylHUKIeExnkAuzx6OiE2cYFAm7mrW0KbMYIfTWuCEwt0weE1+GtkV49uYkme71frp5bfu+zvTBLEGyFYbb2Gl7KWeQfX5f8otCwdMsO33izMldqCRYr59F4qdFnkrCMnVq1y29i2tlU32XhXMIF7UE2gtajTAFG2JISljb4v3OAqghksxKPkuqB08/DSBch31w6sSaAuxTdAnxDf2P8o/YsdMdU3+4rMkXp3CJantBeVHXk1lGHlFhY/XnZGNFAaKEgGf/xvMO5JH2fgY+5wl+SVlkMtmpV3IvMbJSBNa5/JS4x33y02JMzJ+Qw/IUMhxQEidvmpP/sIqjMfekVlBbnzAOB
 19bk9BXR
 r62fAQ3jutOXyXR/zQq1rhGUZfSNEYMqC4OS0A27N6Y6WIM+avTLdIo9TXV7xlFRTGNW7/zDXprym/UQ=
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

Fixes: 15e8156713cc ("mm: shrinker: avoid memleak in alloc_shrinker_info")
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



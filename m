Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E01C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C58D6B0092; Mon, 13 Jul 2026 03:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0765A6B0093; Mon, 13 Jul 2026 03:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE046B0095; Mon, 13 Jul 2026 03:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD51D6B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:00:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63DE11C4387
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:00:38 +0000 (UTC)
X-FDA: 84982855356.21.E753B76
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E210140017
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:00:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783926036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rPnxlGINN5qT1AmSy6zBxrAVUNMi8osUAT3fU2BJ/sk=;
	b=gFQ7l7jPwQ1vAZSNCyvPUv7hSjtz01pPUx0rJ7GHRZmuNWMvrko2zMe1KmYpHMWzB2r0oe
	3FLt6pqEWjy7MbaHYjMOhOrvDhZnSI9oJ/9w4Scej+K1D7MBuMb21nPNWAWJ7NnVY6BtNh
	SNh4zW2xxdFLQA2bczTaSppvUQ0JBnA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783926036;
	b=rWUnpieqRAW10WzjMXIKE5C54lPR3E32APkl5AgqR132NPlo2H8Kpl5yAFQU9hLKGid34r
	o2hbck+A/Wh++m2CRfahVsAbRMYEBS+AW6WLXIfyZY0AATT5iv7Fy+aZnaYj+kAcXzUsmx
	SpxLSIHhIUCP9VHv8sdHh5PaoDI/8+Y=
X-UUID: 881fa8247e8811f1aa26b74ffac11d73-20260713
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d033092c-4aa8-4159-acc8-ea1f5dd7a3c0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:18b88f4baafce44e06f5bd80fdd65fdd,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 881fa8247e8811f1aa26b74ffac11d73-20260713
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1196695508; Mon, 13 Jul 2026 15:00:28 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	vdavydov.dev@gmail.com,
	davej@fedoraproject.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH v1] mm/slub: add comment explaining intentional kobject handling in sysfs_slab_add
Date: Mon, 13 Jul 2026 15:00:24 +0800
Message-Id: <20260713070024.153552-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r7zu8dnjzhnr59gy8gymf6iwe49b7oqa
X-Rspamd-Queue-Id: 8E210140017
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783926034-164091
X-HE-Meta: U2FsdGVkX1+TLyMS4MnMvdnFOV86tKZW2HLeXKf9TtV8kcT/yYanlCs4pIDqLD3n2Qj3QH5O1Dw9PqMtN89jqnn6vavGoPKz0cy4lNpZ65Ij8uK/5AglDgzId1KVE/Gxx1//zKLlVW2NFYteHYDEO2dq9iPzZ4mmWPpDUY6aLUNtpxrEa/uvjNbcwTr+ie+6OW+Pfp+1/dD1HJDdc398pXxJ3XBA+OvNXEKfB5RukaFhXx74FJsLvV98oofON/FsS+5jI7xqHFBZYPGCMnAH9Qtppcxp0d5pwhlOnmHN3+9zF0MAah9AooXnx9IbMQgCW2H44OMOBde7kZdN7A7MKqWyxbnvIBZA2IXu5sXn7wRcgskznGLPqXKjokNSL1bHUSJ8tpZmq7U9LY1WcwNdP2hYlHVFxGAGPl/qcV1QxGPYhVBWBr1Lskn+RMcuvpl+K9fLFvX+igVPuSQfjfT7KvWUd1W9d029zWVQVoU+P2MmcLAt+tkx9hKaepIdx7rKh3UoBmaeYVnM2QdHPZ7FVV5F/oUUKUlFseC4ZkCgVRxWbvaMzHNYlEVwg/58xSZMsgXAfmPHNLEy6wcjy/P/3lDy01IxDCs74islphNCpJ1XZcjKsPavtE6+tHHDrWbiDnVrP+ZokL/pqMB0LAD8X6rZT/jj5XqqqthiL9MuYWZKCtqFggrkHNmGCo/zj9xVpBzetUCoM8XvZVU1hs8F49I6kgbcWr79/6moET5ccArZj/iDOsCTTkW6/T3l4iPrZ4mP6CCddhfQpc98ck+aiV+zhrrLNvSBPoxqYgoRc+4aJHvcJJKiqhrAWy7kz2OpE/9LpBvwP/Rpc5E0tHEijUT0xtMJmfVZE1cGVZ6H9zPar2j8P3Ba1dZc/Dq1RtO6VQRGEYe99vRvuRZCS03Q8FKvk5AMho/bj+ovkfc6iSq+0pHmG+HzgAxTdheZmw5bq1c/BJRVSQfvIGa6ibt
 3sO1KP19
 Zwsbd/JmgRr0Ha2jjuByEfXTEbWtGHq1988iJ/28FHPZ9h5n8Qgo75yAOw1t7XrQ5XlGPKT6gNZ0IsToI4PkOtIXWK2h3agkLpq+F0uO4VZZddmzzs9OLmJT96c3qG896v+UONMT+8W3yGh9XUoprBMTbDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a comment to clarify why we don't call kobject_put() when
kobject_init_and_add() fails in sysfs_slab_add().

Per commit 2420baa8e046 ("mm/slab: Allow cache creation to proceed
even if sysfs registration fails"), sysfs failures are treated as
non-fatal and the cache continues to be used. Calling kobject_put()
would trigger slab_kmem_cache_release() which frees the entire
cache structure, so we intentionally skip it.

Suggested-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 Change in v1:
 -Correct the email
---
 mm/slub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 9ec774dc7009..edc822d7d9ea 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9690,6 +9690,11 @@ static int sysfs_slab_add(struct kmem_cache *s)
 
 	s->kobj.kset = kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
+	/*
+	 * Intentionally skip kobject_put(). See commit 2420baa8e046
+	 * ("mm/slab: Allow cache creation to proceed even if sysfs
+	 * registration fails")
+	 */
 	if (err)
 		goto out;
 
-- 
2.25.1



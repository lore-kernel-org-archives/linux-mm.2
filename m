Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA587C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B18C6B0005; Mon, 13 Jul 2026 02:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962626B0088; Mon, 13 Jul 2026 02:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851876B008A; Mon, 13 Jul 2026 02:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEEE6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:52:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0344516A0A1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:52:08 +0000 (UTC)
X-FDA: 84982833978.22.DB5B153
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B0AD20002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:52:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783925525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=VF1orWY1NRQsS5oVJ56jdjGQx4eu2M/gWCuvWMjapFE=;
	b=5OfvqIw5Htx0l3jvSjMRZAzSgeUGGymfkxfZYjx73T75H5oMlPJyd1O1I0dnGAyZEfSVMW
	1Env5WyIUmfNf1/aMS7WdWsS1/eCRWz3TtY0WIjHyh6alaelhoPI3wowcfAPfUe9bd4/+K
	k4cgz5eQjOc6Zunsrj7k6Pg1NpWhxO4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783925525;
	b=O502mC9tN9+W0EPwDj7tHVR84XVwKBpoyPTUJKeex6jTcmMaAk1A8lkJKvemueM4ZhTWKG
	pimxAdkqbWmzYE8geYxp2v6WLMyA8dDRSusRoVIbZzACkzsix2ivlcr5jQ7PEHHO0pyiS0
	YZU8LrCO5zKJrszCGcq+yUZ84haDNKU=
X-UUID: 56671dea7e8711f1aa26b74ffac11d73-20260713
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e885e6ee-1443-4082-ba71-e71559edb3bb,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:53571e9e5a5dcf0ab86fa7777c8f2dcf,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 56671dea7e8711f1aa26b74ffac11d73-20260713
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 40432187; Mon, 13 Jul 2026 14:51:56 +0800
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
	Hongling Zeng <zenghongling@kylinos.cn>,
	Hyeonggon Kim <pictureone@kakao.com>
Subject: [PATCH] mm/slub: add comment explaining intentional kobject handling in sysfs_slab_add
Date: Mon, 13 Jul 2026 14:51:51 +0800
Message-Id: <20260713065151.149982-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fccndf8de476e6sk1x7ghwkupdgres5a
X-Rspamd-Queue-Id: 1B0AD20002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783925523-191529
X-HE-Meta: U2FsdGVkX19hfBO/KJiYKS2BMwXStRicRgeKRTNSsA7GWEvBXNir/yUahqi05wk+MlchTenz7FUrt22jOrfKmLU4noOxxfXIKPgDbCRdqh5aEfS8Vlilbv4dNh1LseYZqV1gPp8MG5r/xLUCnt4N/nJ+AJa6N3X+1DKs9JzEuU3KucvZ+Twa5rp9Krlp86EWdQ3kan5rc9eeFpt0o2V5l+GboOu4etOYAwE+g1HbyFFOPp5YB+yHCQ9SsyEtUL0Uo6+7kbFu4pqVKu5cS2D6XnW4SlPU/ael4XYens46IZRAndMSc2zN2xBlZ39H4P7ALaA71L3oHInWCmybsWe4KQNHVIWTU4tScMB5MgBwcCbK5xsyhDiPj8nG2ogKSxHzqAdkNzccZeumeG1V6th5FVhHEC5cY+FKQP0TcM4cZOiJwiPOPekPLOkfmeSo+uW4UU5HOHRsTz0MUR2U3R18tsMANC3mpW7LRl2GGlTixBD8BnFr5w/EQoJluOcQvZOB/k3GpiOeh6/i4DBHdLJgPJCQ9BqpiwJ32quVOO6o6jnpYcEgLkqXIMHwgGr/jVyAojiNMJw0Eok1TkmGYkkX7my/0E91ziVTC4ahut6+yAh5Jqp7YYhYKD2jeBDFMKqxv7Z/VZGJqgYLb+5oLP2ni1/XI/RFnvdI8zXWbqAJX1BxWF5EhVoOrAynciXUR+vZZggbguZVR/1kWqrDbvWt9twMGMtVoYIUmsbgLaWX9x3jkkgjQqjpoKejeg9vV3wpeeG5Zz00GgAhcPtaK8zo5UQ8uMBNIr9JANkBwOHMzFto72lov/OGsjQbnxDjFJpIoEppX8ovKMbqTY66LcgrEhMW65fn1QOt/iuSH2BwtPwgHiIfKVODbLQufEatWOkjPNsJu2csRF8wCuZ3ArVG+6CGHt2J1AjBuwxkM03ad3FRo4N6u8jg272zJKfV4o3em0xVUOT7M6vHlrQj3bo
 WdY10lD8
 xByMVxUYvgPLM8iFAdE0+79s5x9MC0oiRsQW+jtIeZLQN5RtDE9ej3JpDZwz4w2inR7dsgyR56Va/u0ZVVoktuSsAKH6yfAkJZAopToJfP6PiZ7UZiYHeRWmhmZFwPFpOtmdc0bohWUpkO7eoCN7WTPL3rw==
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

Suggested-by: Hyeonggon Kim <pictureone@kakao.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
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



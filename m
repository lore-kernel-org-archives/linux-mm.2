Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 096C2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C2D6B0088; Mon, 13 Jul 2026 01:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD266B008A; Mon, 13 Jul 2026 01:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13826B008C; Mon, 13 Jul 2026 01:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 876276B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:58:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAF6C1A0A91
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:58:44 +0000 (UTC)
X-FDA: 84982699368.20.C8FDBBF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6CEA0180004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:58:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783922323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=xnxJgjxrvNbsF6iBdyiFrWLxVV/PluRQC3CvJ04wpeE=;
	b=GEoN97cnWJTssWpxsLGZwG9S+jtkUBIg4yIT+wJLwBti+SsBqcOJzLiyH4UR0jHsEubIml
	GUqibwfLdwm2c8mVTMPdbxKQtCwjrtnGUx2BVwbH/NrT/haGzeBunF2OsTDr+ytKiyZsv6
	lMaOEq5W6dOctajSOa/auSCd2aRHNIM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783922323;
	b=XEPkemjAKW588eN8dwNz4fjkuljplpat4q0vFadY+4E0NTBMkXJPG02TTwGb5CQWGm8+dn
	2bKO3s9Vqtqpl70wf3tH/UphqmqTyfmond9RrRfPQz8fFAQVfTIoGIkDk+VDmft12JOjyj
	fCFH9/JDHg7k7D62Ie3AIG1EFrR9VPw=
X-UUID: e19d9ac27e7f11f1aa26b74ffac11d73-20260713
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1f8b2aec-638a-472a-8172-120feae4a683,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:09047162c704750643ea2dea6117a374,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e19d9ac27e7f11f1aa26b74ffac11d73-20260713
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1830885440; Mon, 13 Jul 2026 13:58:33 +0800
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
Subject: [PATCH] mm/slub: fix kobject leak in sysfs_slab_add error path
Date: Mon, 13 Jul 2026 13:58:29 +0800
Message-Id: <20260713055829.127864-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6CEA0180004
X-Stat-Signature: dkpzghngow3oacui4youtk6qdydpcxrr
X-Rspam-User: 
X-HE-Tag: 1783922321-603084
X-HE-Meta: U2FsdGVkX18FIf76ZyiLzB7+XPQI0jkRdyQbRfneqnfHAriWVrNBs5Xg8EScjumt+33SqAeNU7ZOeeQPTMBzQ1Jkr5shp4JrOjE/8PMrO2deAfJImKLauhqUxmBii7CxtLbVRYYT6qQK1K92h9E91DYrmG98eCCXfX9tTPyWaEFP1VwpDhbVuExA+xMTULlDjRFrE6o0OgLgnp4ZRm/PtucYCsBs6itUfcPJ2A1eE2nyAQT78eC/MbyVk/AHLsPZg/fah4onIP562swaI9iWYqb0QQJqazf/fEFcFcBy7Xq2q6rdneMrGXs61llge4SYA7D+nn6qNj+GImml7DecxDnUg9hVjkMYedFpscrH66t+ksxrgb4ofY13neU6gf5Z9nAuDwtIZMujq7gY+ez5HjiSUsdCFMY/+omYnKlUiqCK4H+dGhof6LkLmfB5VRJocyc8PLmfnLDCOhGjFCq+UzpAQbawYRoW66M5cqin5kn6OahdHUDiJTKAKxfWwcHmmnRUBQsxnkOQZH1phjnmcdE5zONkB1aaMGzjyrbNfSPI5EGK9VMisja04wnpbKgGpKD3kCs2HGG61uHER2/kJg5QHDjIcKvclD72K/S7Rt/3L87dcsCUxYHr3zD5zwstkLHn9HK63L4lxji10PK9hyUH5fm3xJaOr9cFyAynwAbGiyweu4WYGxmt07EEv72TzF7uRTCyOLxWPu6vvYBS9PRg9osa2xTdJ1FgmnlNferZ6BC5BEMkYUySc83oTqy3wK7MCeYleGSAsZXOV/yPiOPSSzEV7wun97QMkmDydJ/M6y2xhcUolD207GYLKjncR69wUHATdQ03eU5xu5wyS8dIjCc9k+MpnMMcIfBGWamgG5BMSVSXt5/lYta2jKZuPEUWQsoo4uisR7cU3oD32sMyAkmqNQy6yVaV8amgP/mBo0P+Iix8daOw5QyXg4mNiejZx4WzUvl48QG3gAf
 kRBw7Yfq
 bpRh8B5ZW1FMcQiiWIylWpVZkEqW7B+kJyEATvP9vXgfVAjyYSc+i2NJEQCZqPUgI1KV+ugAFOH1TjRETUwCLdb780ufGbx4FGQ+3RFv3M7hXZHxTFCp5+7lMjM5knLUxoBFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kobject_init_and_add() fails in sysfs_slab_add(), the kobject
is not properly cleaned up, causing a memory leak.

According to the kobject API documentation, when kobject_init_and_add()
returns an error, the caller must call kobject_put() to properly clean
up the memory associated with the object. The current code only frees
the 'name' string but forgets to release the kobject reference.

Fix this by calling kobject_put() before jumping to the error label.

Fixes: 54b6a731025f ("slub: fix leak of 'name' in sysfs_slab_add")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 mm/slub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9ec774dc7009..fec2cd08d129 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9690,8 +9690,10 @@ static int sysfs_slab_add(struct kmem_cache *s)
 
 	s->kobj.kset = kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
-	if (err)
+	if (err) {
+		kobject_put(&s->kobj);
 		goto out;
+	}
 
 	if (!unmergeable) {
 		/* Setup first alias */
-- 
2.25.1



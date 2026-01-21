Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E409D262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 08:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D346B0089; Wed, 21 Jan 2026 03:13:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E246B008A; Wed, 21 Jan 2026 03:13:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AFD6B008C; Wed, 21 Jan 2026 03:13:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 874686B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:13:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F1E313BBE3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:13:59 +0000 (UTC)
X-FDA: 84355257798.30.C7F5015
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2CCB2A0003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:13:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768983237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=mp3Zo9wI0OZBhaGjRpOXLuKevUUWgyLgYCAfxPTtLvM=;
	b=BRUD0LhwCMBCm2GDPjc3wgTPPzxgz8c9AzT5xy4Fi0XRzMpSwues5Iabjp7aVRaXzicpMh
	lEQG+mLYj7QW93m5agbTDkgiFg2ppa+4FdlUL+EXghA3okgvCO2EToLLIJYAc4u+F9HzK4
	3bChnW59dbI5BiPZU6Wt3nFyYRJ8Tbk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768983237; a=rsa-sha256;
	cv=none;
	b=Pclze+qJK6FMIsBxui8zoNJMAYiArOk3bXuYhg7yCkF+kcp4IXNtXOztMLKjCJmYBEHyJF
	85ENNImzpQ9oE1PXi/Fd7M22qdUX+2qt9c4l+u1KJfL93eTzz3Kf8hEaunQBBsyektzFD4
	glcGHASAwcFPOTqS5yeM6UUWlsTnZ44=
X-UUID: 1d65e0b2f6a111f0b0f03b4cfa9209d1-20260121
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:23de3b17-c3dd-49c4-bcc3-504236bae68f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:5a380108bd19bed4eb7bdae6ce452c73,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:-
	3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1d65e0b2f6a111f0b0f03b4cfa9209d1-20260121
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1266633411; Wed, 21 Jan 2026 16:13:49 +0800
From: zenghongling <zenghongling@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH] mm/huge_memory: Fix iterator variable usage after swap()
Date: Wed, 21 Jan 2026 16:13:43 +0800
Message-Id: <20260121081343.713715-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2CCB2A0003
X-Rspam-User: 
X-Stat-Signature: 87oxkrbwtoc8xrjjuptb7reciyf4fx9c
X-Rspamd-Server: rspam08
X-HE-Tag: 1768983235-70928
X-HE-Meta: U2FsdGVkX18Bt1AZ6o7R3EpvZzosLv7T42YkgTsYT0UTZ4AP75S8TrvtBIA8HwnLv8lKBvWtWCR86eRdxNYu/YkxbY2HXz1SNhGB9DKbaHTM5snp7ZZj3YD8a7I6l9etiYTwdC9IfiGOKUKg/Fh0IKdN2OZbDBpVcSpw+8VqznVKdSuwvxfunPr98sJTTNo06VJ+CPkmdMjnXNPsS5dxkZeW71Jyr8EkdXRONtblP6VJeaiBzJ1pmaFiEywSnYmsxgTe0zkklFOQCs+zfr+Et8tmInLmOVHaY6HjfiqKE3J1FbXBdaqxT0/cOnTSuj7MBXiSMoySijTPK9xtvDToXQLALgBBzuUEapDjRjZyjboYZzihbxS40dMhkJcFbqz3Wx+di4FsqHtPwB2oUBwfY6sfUNOpbKMc9bUAPG+8aZzA1qPj92SzWTizbH+T2wpF9Nqf96Fy0hF+FAjJiZfs05lMXqKXvEkK3xs2lVfBMgzHznhrblFJOD+vfimU24SRzxtzwRixjG2DV3nh4dy7yMNe2hZXdBCL1sQgQksTpTcb2AEOhGPBZ6bsLM0aKUSIaT5Lo+BJapx6Y/6j6VKKlKyiaff9kmuO3BrWY4fV4QGdbcN5MDEmzV9sKxPvBZrZ9Ka04n3G7PMexOb3N72PuORqcXJMvjDntB9E8sLy0pUoZ66B3UGDnUXUKnwC2rK5vErKkh6SE8AqdCr22KaUCf4+EBFx4F+ar5x2nH3G/TFWRVRpJWo2O905s4NlgmerB7YsLPAECUpUJk5IYVPmjdLVj27S4odzhWdewkWPkR3MVn51BMdOp+JYxJluXMiNyjbcgjFgWoe6NHFBr4dfEo6BaLNh9dpMRuKdnXGKj466zCQrIrijztmZAsy/CRrmlBE013FhVhqbsAnCSsiAuZXrq7rKBtdziyZfwahaSYekuPUf+Y/no4sOqR4DzEmTRxzIKfyy1TzaoCTjxmA
 Mat2bA8i
 IchXamyL2bUDnQC5z31w2u2T3WvK06+wkqZWTZbDZ2lubajWVZPOhmIAKjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The iterator variable 'folio' is swapped with 'prev' in the else
branch. Using 'folio' after swap() checks the potentially NULL
'prev' value, not the original iterator value.

Fix by moving folio_put() call before the swap operation in the
path where swap() occurs.

Found by:
./huge_memory.c:4225:6-11: ERROR: iterator variable bound on line 4178 cannot be NULL

Signed-off-by: zenghongling <zenghongling@kylinos.cn>
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6cba1cb14b23..258bf4725aea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4212,6 +4212,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 			; /* folio already removed from list */
 		} else if (!folio_test_partially_mapped(folio)) {
 			list_del_init(&folio->_deferred_list);
+			folio_put(folio);
 			removed++;
 		} else {
 			/*
@@ -4220,10 +4221,9 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 			 * left on the list (which may be concurrently unqueued)
 			 * by one safe folio with refcount still raised.
 			 */
+			folio_put(folio);
 			swap(folio, prev);
 		}
-		if (folio)
-			folio_put(folio);
 	}
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-- 
2.25.1



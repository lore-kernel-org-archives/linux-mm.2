Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8874BD262AD
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 01:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37686B0005; Tue, 20 Jan 2026 20:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5AF6B0088; Tue, 20 Jan 2026 20:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA2B6B0089; Tue, 20 Jan 2026 20:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC1756B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:51:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 688FC5A678
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:51:32 +0000 (UTC)
X-FDA: 84354294024.27.FE0247D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63489A0007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:51:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768960290; a=rsa-sha256;
	cv=none;
	b=boKilkT3zPTycARBuogUb60KzDyZam99SF84RFkF7uIpjgfo/GQ1NQb/wFZxrf+ApCMt8p
	hl69dzdfs0xVd0LmTu0xZWuwHKRvMVCy+w/FB8dFGiDobyumtiZ7WUFGDG/wQFQpqQzFBm
	yqX2u0HqavZHbOu6/j78HwzPHyXjf8E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768960290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0Qg+8O6+W+1KNDGQ7BkwwpaJo8BYfVIByj4VNTdG8HU=;
	b=zAyhpiiEfiNEW82bmlhqP+F55GXhjG/YIaDTeOxqJcHBjMzL/UJfft1IxPk3Zmigj5JTbm
	vmlqUImuV5kytVRoxQ9TF+deE/TGYT6IZ0LA17iq/Qjop1Y3SKzD/HQ/Djpb305vQlj3xg
	Fq/gJ55zo1V/APOWlUSjAc268WGwYpM=
X-UUID: aea1d152f66b11f0b0f03b4cfa9209d1-20260121
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:ce5610e3-0fb6-4bb8-a5ed-b81c91c881ea,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:3329acb18ca83feef44571041f79366b,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:-
	3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aea1d152f66b11f0b0f03b4cfa9209d1-20260121
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 693689911; Wed, 21 Jan 2026 09:51:20 +0800
From: zenghongling <zenghongling@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH] mm/hugetlb_vmemmap: Use max() macro to simplify the code
Date: Wed, 21 Jan 2026 09:51:14 +0800
Message-Id: <20260121015114.560424-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rfgniyiqz88h37gop5o5j6dgaswza7es
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 63489A0007
X-HE-Tag: 1768960289-684455
X-HE-Meta: U2FsdGVkX1/zQA66vmZvrlsq3TPN5zSxvIGkqy44oP8vaH+1KL5ccsZ9E9395sDW+2uqH0q4Jc9Xxz33txQOzusJyt4tUExXBQ9DDYQt2TCIl0oukLGGmRwubrVreJvkw9KSMvRVsUqZw/27o4iEJpPUHZG1p4u0CI8degGfY9cdkxWq7l+IvTVG5QZjCd+AFGUsK6cZBhqy71etm1k9r0/yZw7IZyRsRicSAomGv5JTCH/6Ae8ds3cEsKT5QPzVXZNhOjgb10QT95gfDvZGH8/wci9XOhXFn/sMDzMICb/a3FEw9JQxEMj8JtbEw6q0iu9ozGK60uxOyrcASLeROyz4w3j0hiqIer52hVXTyTP2fmRj+1It3Kgg6wrtjQDuj2Gr+nfZx3HcauB9ivQo1Qd0qvPZsFemckOQOOwMBnJRjhxLEe4wouRBnT2hFmenW+PDh8MI7Dl2v8FEbzbTJYfNmjEAmV83N3kdOB8YAylan5gXYSUv/zA6OIVHct7wyDXbIE3UKYNZcWeeNCx7OTloIJLaMROBxq6LbwSNO8RByhgx6Hq6s6vQprYuSV5TXgwMgWIAEEVuBiV7mNKIU4tMzng9R+G83Ywtzp+TPnMVvhwknobU4v6RjsL5rQ6h3gDsmRZg0eSEbmfcsNW6x1AoXBq4PhmVi0Mw+b1e8q3Ktst/jQkPZ7refiHqiyRKZk4fUNNiN28GqZuPcoRL69rcoq4emxCuT5YUfI/C1kvUIY4L7KNecg3EkkTXN+PRxJSK3UthLgoDsgs93EMZf1FCzRtwz3h5Aoodr8JzKGqaf8JUkHyf//ByhCHI9CWID056pu5HUMGFouPmS/1NuxHjM9hGd0CcV5u12vsOmSH0BkiOMJDcD1XCH1t9B7A/Op1oBIoA1PV13IGJBa8OVv0m9G/JIUL4PSoRmx5kCXrGaB2uup93FpCL6tOczStLCgvKUrEO19lut4W8IZ0
 6Rd+8pac
 Rgx8NbzYICEhnJl8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the max() macro to simplify the function and improve
its readability.

Signed-off-by: zenghongling <zenghongling@kylinos.cn>
---
 mm/hugetlb_vmemmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 18b490825215..abdfa870b096 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -48,7 +48,7 @@ static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
-	return size > 0 ? size : 0;
+	return max(size, 0);
 }
 #else
 static inline int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
-- 
2.25.1



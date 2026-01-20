Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F98CD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0BD36B03A4; Tue, 20 Jan 2026 04:49:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCE86B03A8; Tue, 20 Jan 2026 04:49:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6176B03A9; Tue, 20 Jan 2026 04:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA536B03A4
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:49:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DC90B9890
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:49:49 +0000 (UTC)
X-FDA: 84351870498.26.DA50636
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5FEA6100002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:49:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768902587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=X0QHD2C6YMnZisj7Wd2gnE+r/8y3go1EphoTZJYP/AE=;
	b=MeCeGHzJlUidJBWQbehNmO5xunGzCsCwqF5IsaEENj7udDyh/K52leVA0SDWLw9thiPGZQ
	R4RCxI/5yaYP+Spux+F8bS9Gnvsi7VdpZbOePcyiYveBdLSnn4zamMKNhGsmloawTJFcVA
	CgRGtWP+LNEGM+zlrr6L6B+0Z8ATWTI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768902587; a=rsa-sha256;
	cv=none;
	b=tdrilWokU8nkAtB9RF/UHEB8ZKMuS7lwzphKPR4BQsZlkHMHf1rMmQvokK0hARcAjwe3yF
	AfAcuXcyKTGOadXb7P6Xy5t1sVxrncQMvkbT82KtUKqQ+7kxjtrftCjlJBwCVHuIy6ZZUP
	UcGqB2xlt7m0aDvFR6UuJaeutuO6NrE=
X-UUID: 553bc3d8f5e511f0b0f03b4cfa9209d1-20260120
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e83c5ec6-2ece-4fc3-8c46-ed6376153996,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:3f109679c0d437bf637de4f3ac79da14,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:-
	3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 553bc3d8f5e511f0b0f03b4cfa9209d1-20260120
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 619146282; Tue, 20 Jan 2026 17:49:37 +0800
From: zenghongling <zenghongling@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH] mm/pagewalk: use min() to simplify the code
Date: Tue, 20 Jan 2026 17:49:32 +0800
Message-Id: <20260120094932.183697-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5FEA6100002
X-Stat-Signature: rc1y5qxwtbuoyfth9q3qs4xaxonzaxk1
X-HE-Tag: 1768902586-889545
X-HE-Meta: U2FsdGVkX1/SwYPDMwlm4XqDOniz5f/I6PJewnpyACfnQlaf4B3LnKe/DMKDB9f+0KVgx24Aynk6s961NzY6iouYhGqLUd/M1VQ3etK/wNVrk68SmrN7QUfpGp0aXZfb7CcoCSfVgvZoRl7gvNpROy6wgnh9ZzXSFtKVS3vQotdk1ul7ZSmxJ/JuQgM/QI9VKnN8sV9eJ1PBxdQ3DGqedEZQXDZxpL3oQSsfBDLkQKeDdqVBwSFrAs3T+wx2xxKETnE6BRKbTwqX0U8UDwpVmnZz1z4BPYF1rJPXQG0KdjbraBLZUZgfe64ui9OWsv/gp3uLhP5w90mDY5AexfQlOL4vHym4pQvxxozqy25SeGAZrWicc0elaHQvtm+KSAP1A3hpaj0PCA66WCvonJROcshFwBNsYxKaLhsEN8wOKChXLQkLxp/+ghgEYIOokB/BaaXE7hNLz/nlOrGswqVOOpnsBD9QYSUPJlYOomZUi1bip/IiYyrwCyv3vrV1I6kR0Y68ph5FUt3j+w4hig7inaF9fhYYa5fNdS/wolYDoPC31aUz//htVY1QuJ69eFrJDVyeAVv+RAFu2Z9n1PsuoMHG4ZGUzalgBu4pSCWBFhL1fzReYwsTKUcnI64YGZ/hra3bFbdkHtKnGhaRDWmZHg7aEVKwe4ei1wO6SDdJhcv8cVJ5ubScMFQuUkn+4nfeIutqvowH2YtH+9FEJ6yFwOPtpCd/Ssy+80P2hyXUBHGDlMU7KALnBwFJLor0ZEcHDFc7i8bn7LH1yen3+Z22vP68EVI/5MGwGJ9Uq157Q1taaBB1eqBvsThRLucewzOuuVF1Qj3bBzXzUUTO7BFyDFdxhh7zNfjWm+DbNgA5I2J+jr6ane5coxSshp6k5D/umDwEt5cufwyx9AtFhR1DBx8PKkskACTONiKbdJPp3ZD/LU4CNscyxQrMGJBJ+RyLInW/XyX/A8TSWhOVuHf
 rRBs6pUA
 EluHH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the min() macro to simplify the function and improve
its readability.

Signed-off-by: zenghongling <zenghongling@kylinos.cn>
---
 mm/pagewalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 9f91cf85a5be..82db421b5b34 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -313,7 +313,7 @@ static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
 				       unsigned long end)
 {
 	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+	return min(boundary, end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
-- 
2.25.1



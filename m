Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893ACC5AC9E
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844C66B008A; Fri,  7 Aug 2026 03:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C846B0092; Fri,  7 Aug 2026 03:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7327D6B0093; Fri,  7 Aug 2026 03:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48FF06B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:51:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3800A037D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:51:49 +0000 (UTC)
X-FDA: 85073704338.29.A8D44A9
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9044B40003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:51:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786089107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G0G/evJ0w4+LOuHx74aiIPm6NjdOXtVc8iogYZE86Do=;
	b=UYDFQ938u1S/GFxgOTYyVnO9ESKPZjVz4CY8zrW5ABGqeKLboyiYcvyUQrjrZnBu3v0YmW
	ptph9MzDfDdWcLnLTSuxOl84RvT1Ru2p05lSwletQcl+5lfIghlptIW4QXfV95E1EbHY2r
	QUsHtT6+jja/zulCuAOg9ffmSj0+YTk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786089107;
	b=wB4NBVSUYv6DPFFa0X9ssHw66GdKqedZVXBpyYVxqZV1jjxsvaqbd9MQWugHr8k+M/Kkp8
	UFdqqKZ8pNgCCUcP9tO5nVFGOd6ipvrZzQz4TUeQ0eUmTJrQKRCII0oNFSnCBouctTQ0pG
	P9DvSqI2Rigk2jFRyC8ccPMIt4TE3g8=
X-UUID: d0243634923411f1aa26b74ffac11d73-20260807
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9248a66f-0245-4dce-a9c1-9cc137809a2c,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:9248a66f-0245-4dce-a9c1-9cc137809a2c,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:796fb985dc2c6de23780a711ccd274f9,BulkI
	D:2608071551394GP681FK,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d0243634923411f1aa26b74ffac11d73-20260807
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(223.104.44.99)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1127736449; Fri, 07 Aug 2026 15:51:35 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v1 1/2] kho: remove useless phys increment in inner loop
Date: Fri,  7 Aug 2026 15:51:27 +0800
Message-Id: <20260807075128.542806-2-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260807075128.542806-1-duanchenghao@kylinos.cn>
References: <20260807075128.542806-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9044B40003
X-Stat-Signature: uc1hr7w4ip3gon7dejgxpig5i1138j88
X-Rspam-User: 
X-HE-Tag: 1786089105-638117
X-HE-Meta: U2FsdGVkX18qmRZYSBlW9051D9t/DK49stg8f6eRdq9069GNJrvSCBdK16c9gPF4XU8av/NPJ2MfwVT+FBnjJEoHygxjlrdU99f4mkerHXb+q6TDx3MTC8Ja1p0ceKdnMlDBy8V0iUWieJUv3bPLx5/M18sBGWuHqOQq3atGU3FgFwEvPwwsIC/JmyDu0g9zcU/+K71RrsWnYe7G5Eaj+CVM1gZPr/njGH3dnsZ9bQPGxsKbuK2Ef2W0FPR0W/ECmqwuOXIMM2Mew5hp+BZcJphxVW3Mkck5MPbbIFemGMQUgRC0dPoT7+UCzwiS/TCShBpoVEKee8G4PPwR5NqxVbo/RJkwdeTU9tba0d4Z21IHkcVZsbNcHCoRm+aKNEKyr+9BpDh3PD7oK9QdIoMLz37FSJHapaG4NtML/ac1Mcv6nFGX1gFrayZ83IyaONMScIPJ1lgfNrw+Vgd55md5p/Qd6u0W/aX1TCZ1QHPgm14vP8PGrNqg4/HOttEaXWlyWGCD8HFttcMYN1wfEiHIGIeYLMFpWP4WRUnZGCanou5ypiKf36f33R2rjEizbiERHOgwNLcIN1JeP4lDCKfidDuBr/w59sudZdLdf9KBRtalJT2jArB1WQJ/fdYQfyx+sqJJ5Jw+MEhFjF/ezeb0rnGx/DlF2Sxn0kJwL7IjYnujvmnOCHtOk7ISOBA/yCupF2odwcWjdN7h1T8E9SitrGqr46z40BNkHpJkgNjfOUc7E/9c4shdSLbdbpYd8k0BbWjOZdYuNVo51yIrFYoHfb0gxR040UcQL/e/uwT9UbMAT72IvfALrUbOKDPVP5y97w3LGieqQLjtT7zyxdP+fNDrEzF0vFqQlnsyzQtDeXVUvGsgiDGT4KUclxPm0Nw4cknaVsP0MO1hkceJeTVyGU7aIE3mo0l2rzMcT5aP4lYW4ACjvFR6FZwhtQP+wad133obitIt3RqNjIKgE3y
 p1oavtzT
 IVtuEZ6m/K3BaoCUeXsknUR0yVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The statement phys += contig_pages * PAGE_SIZE at the end of the inner
for-loop in kho_restore_vmalloc() is redundant code. The variable 'phys'
is local to each loop iteration (re-assigned from chunk->phys[i] on every
iteration) and is never referenced after this increment, so the statement
has no functional impact. Remove it to avoid confusion during code review.

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 kernel/liveupdate/kexec_handover.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 175c08a6e41e..ba03ff5baa9e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1191,8 +1191,6 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 
 			for (int j = 0; j < contig_pages; j++)
 				pages[idx++] = page + j;
-
-			phys += contig_pages * PAGE_SIZE;
 		}
 
 		page = kho_restore_pages(virt_to_phys(chunk), 1);
-- 
2.25.1



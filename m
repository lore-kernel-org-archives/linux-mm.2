Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 234A2CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 14:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4B96B0093; Mon,  5 Oct 2026 10:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DDB6B0095; Mon,  5 Oct 2026 10:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1CC36B0096; Mon,  5 Oct 2026 10:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C83816B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:22:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07AC3C01CB
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:22:01 +0000 (UTC)
X-FDA: 85288786842.21.FDCB464
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id E4CD21A000D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:21:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791210119;
	b=BMO9FmR/TTUsplca5cvWi7ZUW447o0HWQb4aWYR+1iA8z65PIhdNzsLh1eVBNrttqkEANt
	zZSvkhmPSHys54fRDHuw6Yz+SRqVKSiurhncfj4/ae/PJdKNzUHjxON4YQ+xhQedXSCsrc
	TBw7439mUNTtEFYVnc1ybRhmKZDGxck=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791210119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=dd2ahcUzokt9zubppyaUsQ8ScaNPCK7xleJSCDqMITA=;
	b=sY/TpkWQ/uy0H0dcjDWE+6ZHAnyy/iftVRPSEeQcOZ26dN6TLospvNuZDjjA2ixBBOgVSN
	RZDxCmh5liR8M4ETtPFLJmJFEQdaID0rsHzTKRs3HhgL/KyBvy97aRHFAsMq7/pUIvuW1H
	tdbmat2cMVIOAkZFZ695sRrDWBjV3/c=
X-UUID: 170b7cd0c0c811f19a56ed5b684f684d-20261005
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:0dfb1966-5f27-4c05-b2b0-9a162f5eefa9,IP:20,
	URL:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.3.19,REQID:0dfb1966-5f27-4c05-b2b0-9a162f5eefa9,IP:20,UR
	L:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:e32978d867f735ec8dd91cb4c0b3d7e9,BulkI
	D:2610052221484IO67GT4,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 170b7cd0c0c811f19a56ed5b684f684d-20261005
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(39.156.73.11)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2123756161; Mon, 05 Oct 2026 22:21:43 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/hugetlb_cma: remove two unused include files
Date: Mon,  5 Oct 2026 22:20:40 +0800
Message-ID: <20261005142040.675204-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4CD21A000D
X-Rspam-User: 
X-Stat-Signature: w5kfa7rwo8ckkm5adr58wibw7ydbyj5e
X-HE-Tag: 1791210117-601738
X-HE-Meta: U2FsdGVkX1++bem1Jc8t2c16s+V0azcmstSeV+JgXTcy79ZlGRB76AyLkRTf2IFuAkps75fuf/xiuoFNJQVHyICIjFfHqNAvG/nOv3Dhgkdidb7f2b2NAXXse82uHhcnDbuHgJbkgvXbC1Qq+9KG1avRZwZvS1l20p9F3RVngD4WxcZyK2Cf2Rl+oKqMiCzh9NdOLzwFGfbmr5TgmMWk/a6bEhzta5rbXo+0+tggujVS+cnyefuOigulIp4c/H2SpzU7VMfF/YSL57t2+mU6iPzBYELJWl9HQZbb5c01sdmavr4fup5rIl8AoVUG0S4chtk7EeeMOa0JasEfHLslCcJha9f4YOs5tqOaV3+4IUfkPMufk+zfKfRkWlWL/lRIwjvHHidHQM3GS5fadpFpruvsbwg/jjWa4EL+JydG/jxjAZtEKDRNOwHIiX9QuGtVK9GKC7oVeULiey8ji7RpD3ldn8EPygRhllkpVJxbHB7y6Ncn3PCXdWT6dCEczSYi7d9bVtMN5HYuTJMLdnPapyXh5tJnxhCBIBGMM73Zwp4/vpucdwofNa8cvQYxm+WooAwVOzl6TW9fLH0xWWMb8jMRkRmzoFQoS03/UfvQVewHKBBCPlG8laBNtjTh91mLjny+kLl9KM8wSj4U2urPaZKynFLDGifxbm6EZwZGlOTSK1UKWzAbAEetMHYCIXhYmI5hHBrK2j1IFeLHkC5qlUT4DbGN6q7DEiy7FftNO1wOgqBwbWIshHB91UIQ6/OSGawOHPUtJi9Ese4Epz2nGP7ggodUGaHCOcUpJ1EQB6l3vrp+lhLQIo7Vbjk/XxxBbXLzWcOdYpAIDUw0ZSe6Z+4AxyBo7QgF5DN8dgTpTwqMUW7WirvcwlByA+LE5h/Idg65jA/FRrvjcEJMQgdDDdgKu5B5+IMWaDFeZVTxJVsS2NZp0i0sx+krDijm/9rN577JkICjvtntOl/NhfE
 66k6XVyr
 IzJEzHCVRnIjOXjT682tDfkWCQFR0JC4Dcg6aGSb9ZUUNfcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_cma.c includes <linux/mm_inline.h> and <asm/setup.h> but never
uses anything from them, so they can be dropped.

Found with clang-tidy (misc-include-cleaner).  This holds regardless of
config: the file's only #ifdef is CONFIG_NUMA, and it only touches memblock
helpers, so removing these is safe on all arches.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/hugetlb_cma.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 95fd2d190f0d..80b2407e9f07 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -4,10 +4,8 @@
 #include <linux/cma.h>
 #include <linux/compiler.h>
 #include <linux/cpuset.h>
-#include <linux/mm_inline.h>
 
 #include <asm/page.h>
-#include <asm/setup.h>
 
 #include <linux/hugetlb.h>
 #include <linux/memblock.h>

base-commit: 0aaec43576cd41474a8e90c919631c0c9fc88417
-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D18AFCA5FE7
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 06:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BCA6B008C; Sat,  3 Oct 2026 02:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921E36B0092; Sat,  3 Oct 2026 02:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E96B6B0093; Sat,  3 Oct 2026 02:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFBE6B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 02:01:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1C12A08D2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:01:21 +0000 (UTC)
X-FDA: 85280267562.13.6F1BA9B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id DE96820009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:01:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791007279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=EpdQwtxp7i9ynayGanYeKtunx5khwD7+gGC4oa1qfi4=;
	b=5Pty1SgC7QRWP1OXN7gA9cPsAs4rWt12/PJYcO56bwqrG/oe8mHMScA3LIjzW9DsQF98OE
	N79GkjadZSzY+VF0r+WPfFr1Ra/zurvetfhTyBpnpi+ise40RLsHVlXMXN3atyP9td6mCG
	WUvajAei3FdfMGYxyqcvwZy23x9GBI8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791007279;
	b=NcqTCSzCiF9YItruw2VXUn7PRArdgov8JqrcO9pkMJ+wkvD9EjvcNX13iFJJL+SzaraJ/p
	1mnv6/4uPHBB5ZhngoF/yX+z1WkQdWGeTHSrqJkGFWEXUcrsOwC3wnXOZNTKrQw8EnfAFi
	owIdUbZx2ojh47+qtnUx723ALZoBI7o=
X-UUID: d4d558d8beef11f19a56ed5b684f684d-20261003
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:92ae08c4-4d6a-4787-a2ba-b2990e617779,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:92ae08c4-4d6a-4787-a2ba-b2990e617779,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:3b80404b1ba5e3dc0a63d755c756d944,BulkI
	D:261003140113NO7ATH1I,BulkQuantity:0,SF:17|19|38|66|78|101|102|127|850|86
	5|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d4d558d8beef11f19a56ed5b684f684d-20261003
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(175.169.70.242)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 649705112; Sat, 03 Oct 2026 14:01:10 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	sj@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>,
	Joe Perches <joe@perches.com>
Subject: [PATCH v2 1/2] MAINTAINERS: cover all hugetlb headers under HUGETLB SUBSYSTEM
Date: Sat,  3 Oct 2026 14:00:28 +0800
Message-Id: <20261003060029.2152489-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE96820009
X-Rspam-User: 
X-Stat-Signature: pcejh3z6m1d47bj7ew1rq1jesd7nu47c
X-HE-Tag: 1791007278-206656
X-HE-Meta: U2FsdGVkX1/FFHVR4KlMuE/I/6DxxaDHNd3k6+vms9MZ9iIKrvVXE4qVmmRaVkHadtjKjaWyCjKOzdburY7e25ebIB4FZIZ5aIEPU8yr4lyQOpCJqDVYpvREP5noSi+Vw7vjgR13Qf3pI59tC0Jsm5szFudzn9M0EWyTmoUI7BoSM81gcynWktR4rnOzzvMPr2vKToo2YffPNi6USoAF0v4+Y7XELPOxk547oMubVO+tarLuYfizEXqPB8lwkC2N6qNrPuI7LWav2wSuR33gNDmkD8XFZfJVipF2gjK+MTCSOk8wF72Xc5eoYLvIv77bD1oFDICVHlajkpeUINH4lwUxEYK6+f2Ze5+QaQjkWVOpQIBr60nfLxkB9vq2Bou3BlbqX1k5b+fb93vDqy7HnUeiGhK2ePLBJxP0yAdk3zgO/CIMbMbl7UonM/8ldqI9fYVc+G995sfdmbfLUbyWY1YKQXrXAHytqLCvWZ6RPpGu/KF24Iwd+9Jt3jTA3pTLhpo0PoNSanG+w9l/qUccaBz3J3VpgSOD/ATzfef7v0jS/hw0wuWUIyonD62NI77vIukzNB8o5nck57uPdzaUPZdSrLQ6qR8raz4elFVIP7bLBJoVQmTBaeiIgmLLkYwjh2gRvAWJ/VIu4/H0bPyDy1UvLcfsnnFA7d9HUBB6HinIZRt/6jB/nEPbqbr12DleNzYmaoyls04iXzPfUmU2s+gE4Sv86bSS6A4YG3r/grob+qzQW4hmNHW36s83qrOdHsuSKgHFbrJNP97KpxKS0kOPj+LzQOi77ceuqrlQ7ID+nvdjG4JRhMcecaCuLL7cZfsjmvdCyTl5dJXzBqaB6biUi6828jiYf/Imkzt2qAs2aPU/ai7XNzFQDDhK+ttf7pMSvaqk5l0XpDvJi5jIEvQ7LToO08T29yUlbaMul3rnYpgaAILZ0LaQY3MPdkUcm3VJDnGXCAaIdpv4pEP
 Mo4+LCZv
 ROVYvmQcZ72KirvYOzcN3nSpNtc499XwrphSsIp0ezBIDbdsZRTVVmu74XDzOrBpgLUE1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HUGETLB SUBSYSTEM F: entries list include/linux/hugetlb.h
explicitly, but other hugetlb headers are not covered, so
get_maintainer.pl does not attribute them to the hugetlb maintainers.

Enumerating headers by hand is also fragile: any header not listed (such
as hugetlb_cgroup.h) falls outside the subsystem.  Joe Perches suggested
using a glob F: entry, which covers all current and future hugetlb
headers in one line and avoids the gap.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Enze Li <lienze@kylinos.cn>
---
Changes in v2:
- Adopt the glob pattern "F: include/linux/hugetlb*" as suggested by
  Joe Perches.
- Drop the Acked-by: tags from Muchun Song and David Hildenbrand, since
  the patch content changed.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fc95062c7e38..5c38da7090db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12097,7 +12097,7 @@ F:	Documentation/admin-guide/mm/hugetlbpage.rst
 F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
-F:	include/linux/hugetlb.h
+F:	include/linux/hugetlb*
 F:	include/linux/vmemmap-optimization.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c

base-commit: 763ad0211c7b587344f03bc4d1299810aeb736f4
-- 
2.25.1



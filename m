Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB294CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 12:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA04C6B0088; Thu,  1 Oct 2026 08:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51186B008C; Thu,  1 Oct 2026 08:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67DB6B0092; Thu,  1 Oct 2026 08:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97E3A6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:38:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13E77A5913
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:38:19 +0000 (UTC)
X-FDA: 85274010318.23.A309722
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 328B6C0009
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:38:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790858297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=haEagmylUrCZspqfsPxeDT2JY/Fik06BMmYOHOLFKKA=;
	b=nvDe2xzDtWR4KHXkLdfQUyRnhfGMDWhPFRRC9K0Z1mwPtrYFF98cHOqpJ0IRHF4Fn7qWh/
	t+Habm+Ty//yZInt7LYzHXxurnF6BXk1KfoPm9YEf+aoUArINBOIUAnnCUADjshiPDgbls
	0oLvDZitA6DG0ovkAUJ0aadk9Vr95Ak=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790858297;
	b=ElS9dFYImh6s1jIJ7EnSH2zEchtUIKsYlAU71DFuXYpRhDA99ilPkdm+ovwNb8Z9m2yvNT
	jUkCbqLCW8jXnjO7CD7rKSwRg8NI2n41puDcfbA978hLevvMyTou0Ry3CE1AxpWLhHmirp
	G+t2R24FHVpq+J3wNd8A9C8W0LTckCk=
X-UUID: f29d2640bd9411f19a56ed5b684f684d-20261001
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d8a3bf9b-ccfe-42d3-af19-97c94c30332e,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:d8a3bf9b-ccfe-42d3-af19-97c94c30332e,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:fa5811b16cf6a5b9055d2c7f2be89049,BulkI
	D:261001203357HTPRU24Z,BulkQuantity:1,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f29d2640bd9411f19a56ed5b684f684d-20261001
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(175.169.70.242)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 378255551; Thu, 01 Oct 2026 20:38:04 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH 1/2] MAINTAINERS: add include/linux/hugetlb_cgroup.h to HUGETLB SUBSYSTEM
Date: Thu,  1 Oct 2026 20:37:46 +0800
Message-Id: <20261001123747.634845-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 328B6C0009
X-Stat-Signature: bgaza1q954c7mxfg63tfuq9owwyzrysg
X-Rspam-User: 
X-HE-Tag: 1790858295-570835
X-HE-Meta: U2FsdGVkX1/5tNOUNGvcDN2aLibB51csfNAUgJfQlRBQ9YzHZvOfrryC5H5KN8UG8nwav06CNR8tp3Z1NxRWJ8pAJaVzBnuWrLZKGJk27YQFUSx3+rCpEFNyAjSDjUu81LOfkHfH3XbhGAshMlzyI2MhrSRBtmU22c3+DpWjNgxtmLB434jcNj1SlZTZZU1mlpVnx9Hr5JAhrNX6v4jwbNZ31fmiCZJjL4AXXufRwnzc40lOpEX6PDnYkzw5h7lwGblD6CFC3EfxiIGjXdJci9vyNdTI1IihUpGebNWOB9lrWGd3ZC/WuxkcYhZonkyGrcLsTP3yhUffuCtsCUupjKpjH4muyfWzQutG1aMpXmezoA4I0PY/dDxHRZbFH0BLKNLiAcEjYqYeUlEHkcO54a9DUzso/EvQmavF4ZCZDdA7t0sUucSn6/DDbvWW+L3mhkjxs6oIn1EouTfIKU/22Co+2OA67I7sH54WBt8rnH0PoDHDuz8TthVdbsnP270sFa8VFJnNhQiHX6ktXv0EeJj3MZ9GiOLHpTg4stWvGBJHCJ7aTEh+qg9Frk+IJGpwoL/EhMRWkJyF8u9QXCWtVop3uX6CdUH1qAz3z1SB11jLc9lNf+4AGkqFNZ7DqBqNlOQd9IPj6OZc3+H/pAUWKXDH8SIAAhKlflwYxk84KjgTkyqOttZlG58Fps6KhygvT2f/H6bd/Z9reai+tiSTtnfyY+l5DD5H04p++6GoAoiBh+SUgh1buwuPi/zrLUIqIZOa/xBOHg4MVtJnGlDCPlIQXRVV9jcQRFERnRVp1MjtP+S3buXBGJ7rCmGk5CZFtn1Tf8OS+grUZA/mAjkh3W9EcGflNaFEJbZGOtwmGp1zSF2Ltm4MML9x4TPfXls1zxFvKr3Py8C9spvmordxBrkRiWeztlK/GcPLXi2mHp8KcqXebCa3NpHds7GO6kSi44v+MHx7g61LjKt3ggm
 lSq16cRC
 aSqx07D93t7wxrXCJnm6Gz5FI9NvhE10rWqU5XhPfzxR5NME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

include/linux/hugetlb_cgroup.h is the header file paired with
mm/hugetlb_cgroup.c, but it is not listed among the HUGETLB SUBSYSTEM
F: entries.  As a result get_maintainer.pl does not attribute the header
to the hugetlb maintainers explicitly.  Add the F: entry so the file is
covered.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 596efa354ea2..6c210e90722f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12097,6 +12097,7 @@ F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
+F:	include/linux/hugetlb_cgroup.h
 F:	include/linux/vmemmap-optimization.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
-- 
2.25.1



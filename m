Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B853FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9162E6B0088; Fri, 10 Jul 2026 00:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7806B008A; Fri, 10 Jul 2026 00:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD956B008C; Fri, 10 Jul 2026 00:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B56D6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:48:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C44F51C37A7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:48:05 +0000 (UTC)
X-FDA: 84971634930.02.278AEE0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id DABBA140002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:48:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783658882;
	b=yO3dJn/dyqyPJL2MMAf+ePvLU/pdY1fI+hHjp81GoV0SIbE8IJKq/tACKxkFY90fF4IFAv
	GM1BXiPf8MH92inE6oYW3lbHJUgLqYcYQVgAyzykIi76kn2va7qjh2qnVsT82oJGPgJPmz
	mc5bygCaiuu3uFn6HzFweOffK8H2dp0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783658882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=zAkVEP9KgsS7o2q/x8CRFwBpvIIlW+ZILu+TPxEd5w8=;
	b=NiSiypo4wlbCodKg5/Xtf+2thdbMYwtJ1BT2EjKDzK7r+cmUGvB+7GI7SzrLA3c+vCFfng
	+NvgIdh59CCEAnvq2AL1tGuJISUoBmTOjYIBr8lwEp7JklJKCAOzs4h/1uN/G7joU6gjOV
	HfzB6wz1kpeeTXyBh57pstK9D6tla+E=
X-UUID: 821619247c1a11f1aa26b74ffac11d73-20260710
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:98e98a50-95fb-4d0e-9d68-570f4c1ef2ef,IP:20,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:45
X-CID-INFO: VERSION:1.3.12,REQID:98e98a50-95fb-4d0e-9d68-570f4c1ef2ef,IP:20,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:45
X-CID-META: VersionHash:e7bac3a,CLOUDID:261bab691877bae7105c0796ae33e56f,BulkI
	D:260710124754QEEL9PD6,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|136
	|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 821619247c1a11f1aa26b74ffac11d73-20260710
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1294044832; Fri, 10 Jul 2026 12:47:51 +0800
From: Song Hu <husong@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 0/4] Docs/ABI/damon: sysfs ABI document fixes and additions
Date: Fri, 10 Jul 2026 12:47:33 +0800
Message-ID: <20260710044737.561102-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DABBA140002
X-Rspam-User: 
X-Stat-Signature: 3of47bsr1e6p1cxkd33jhozayrqtpw7t
X-Rspamd-Server: rspam03
X-HE-Tag: 1783658880-694521
X-HE-Meta: U2FsdGVkX19DAr2a3CA5OMhWQvYMHT5gYPKvNdPUrU6Q3aIjk6uCu4Xm+ZoUnxR5Mtq6Sq8jXVjQwn4KDrIFgEgg8jU94yXm6RbY4G+MkuNgIgUYe5wgrbjQLDGlgrotmpuOhgL2f3xUBS50XEAkMuuTakCu1oirKbNO7z+3SaiJdqlnyJ+LVc/GVYM35B5+CujIjjoRnBUA3uJWdkdiD/+l+iKrTMQwRStocU0Hs8NE0avY5t0uLH5Y9RVkrkyuVwDS3UjKvU4vrKuB4JOl6W/9ZOxjnLgJcrtO/T+QlZ2XPR22Vbxt3RguY7HL9LxwvPsHDdmaBqLy4FDWjhbI++IumIg+9IFvzk2kBQ1wL+V5a1tq6So2otOuA+AgOrRlf3pvOuMoEnqnztGub5nAj6FRcAer/pG0UfZIP2J25TtbqCVnAftSwfpsAZnrL2iynxNKgpHYjRdMlr5GYbrKdSwLUWy/xHX5L7RYDoG76EDddyVBxiRsy24gK60Y8dsSVa6nvL01tfNICxa3m8YjeUJWhFk80AguHQ4yZ/7XVJDPHAsm1aPdR52u2E0yZq5ANDCD7+Yz2cSryAR8yDpHe6OynuMpbsA1PpZ4MCe9KUfyYCTHVMlJUcF/X4RDiUDotWyQP+NWqdgXIcuSSQokpWWoHuzg6XpJoVTEBop53CAfDYoFoQcs9E37pcTxDcjxYp0funEIFF6wZIpZghX9EWLCKsv/sroUeU4N4aVQIx4MYYBtMm0ikHRDmllOf9mMHWBfamOLD0npL1Qxd4G59sTnRskea0rzQDhje0dTx6F2BVLgJ2Y8U1k6yjs4dEn24443Fcig2KYBLXGL/4bNCgLZFPpDXrT68Szskse5evGJDsFWtH01ZQYt9JOIgsJJ7CLWy1nYh7yteXnsYmTLG70FlTnugTIi6FGu7sQmWdoZnfeEWHayDwzEmwS0g4ucB6i+VSJTtXYkqWIvz22
 GM/ELfsy
 XDf8D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes typos and fills in missing entries in the DAMON
sysfs ABI document (Documentation/ABI/testing/sysfs-kernel-mm-damon).

Patch 1 fixes a path typo, "intrvals_goal" -> "intervals_goal", in
four What: entries; the documented path points to a non-existent
directory, so it is Cc'ed to stable.

Patch 2 fixes two further typos ("WDate:", "manimum").

Patches 3 and 4 add ABI entries that exist in the kernel and are
already described in usage.rst but are missing from the canonical ABI
document: the 'update_tuned_intervals' state command (patch 3) and the
'tried_regions/<R>/probes/<P>/hits' file (patch 4).

Song Hu (4):
  Docs/ABI/damon: fix typo in intervals_goal sysfs path
  Docs/ABI/damon: fix typos
  Docs/ABI/damon: document update_tuned_intervals state command
  Docs/ABI/damon: document tried_regions probe hits

 .../ABI/testing/sysfs-kernel-mm-damon         | 29 ++++++++++++++-----
 1 file changed, 22 insertions(+), 7 deletions(-)

-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21194CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379666B0005; Thu, 28 May 2026 09:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351CA6B008C; Thu, 28 May 2026 09:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246D86B0005; Thu, 28 May 2026 09:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 142CD6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:42:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA77112081C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:42:42 +0000 (UTC)
X-FDA: 84816943764.07.2803014
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id 03D58140009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:42:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779975760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=nad8q4bqEzxF9lMPq2ZZtCV/pkKvkgX89ZsQiAnPiPI=;
	b=e8Y+u69iauAupBwWbD8JrCqcA9OL7wEk2G9W0vcI75OzM6O7Dn7Cw320zfqWjJVgXqg2Dm
	qePoTe1mr0+Dc0T+IH2VrkUXqSNuJWfIuywfCd/KY4ILOWc8Fe+wGbYyjECuaFSTaMCSBq
	CLQJooTI9Fm7L9sqLkb2aVn0wSPx+Qo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779975760; a=rsa-sha256;
	cv=none;
	b=lSGygh5qzGz3Wol5w77SczrvD4TgBP2zeHEsG286wjNdfF5Pz/HzAj/16ecv0+77NOL8tI
	4k3rVv19JENLjvhpsOfwy5Hzgg35oNskAUe3na0QdAtfQwUQgDcKIW/ASlc87ga8s3tKz5
	ahC466JXyeDlWPO3+pbGnv4qUnALKMc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
X-UUID: 0fe72ed85a9b11f1aa26b74ffac11d73-20260528
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6a15cafe-7633-4ccc-a01c-5652f56cb7c1,IP:15,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.3.12,REQID:6a15cafe-7633-4ccc-a01c-5652f56cb7c1,IP:15,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:5be438a3638e2f8398670b76448001c8,BulkI
	D:260528214228SA6429NK,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|123|127
	|850|865|898,TC:nil,Content:0|15|50,EDM:1,IP:-2,URL:0,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0fe72ed85a9b11f1aa26b74ffac11d73-20260528
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(39.156.73.13)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1967851017; Thu, 28 May 2026 21:42:25 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	ying.huang@linux.alibaba.com,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [PATCH 0/1] RFC: mm/memory-tier: add stable node-tier id
Date: Thu, 28 May 2026 21:42:11 +0800
Message-Id: <20260528134212.240492-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 03D58140009
X-Stat-Signature: qcdyyzdpho5egkpnj61inkkqoeexsmm5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779975758-327868
X-HE-Meta: U2FsdGVkX19YOQSue9dYXYWPsDNe/G2qcXhWKCkwbHWeQWrrHDq0n+7lX6KZvF613kOCc4sjOWm2jkoajDhCsszRrlw/ekzu78BclVgeYV7LWhoJB/FKBXh9rr4oQaZg5a1Yry1X2/kaA7mwkWsFVPdXBb7UUy7ADoiMMJIl/FAbNggN4Z2DSTX0QhY8swyrdymnYpgoVHPBzx7rekQadPAJbCWDuxGzpkf+ESZt5snDJ2AKOMtQlzkS2aHQDBVklUpFG4oVxUvZUHMHnZRVQKHMFvl2diuO61D2dzwJXhcVVKQ40ABc59AMKrnPCQYR0nPhgqoIF9kG+SUXm/v2+DCq7lzYJPLxnixbTwZvdHKsTn2FvWYJE1FkbJSjwWPFzlD5msZEujWSGjI/EjPXS/lvG7u3w40DK7hlre7aJoRgblPlyrDzGWprdw0EVUuY+DhsKE/KZHgMnfmPOG4OEpp77O1Auwp/oNNZaWzYzCVLy331/3NZl4FyY2TujBlXKX9s17lNPdXTlZgLRnouHy8sOR71J+fzfXIVbS7bIBI7prP5S14CqRWJ1pRJU69BNIOFTqYhMkMzFgZTEykoQjCNlYav6BsrnNl/PLY9s5TsI7zFvLz+phMX02VugJaynAJjWWR2Y/+KOxEXUSD6vg6uPmo5URfeQ9k3sw4B4bh6Vr/C0qKeE0dDlVfUpTYHZhl2Ag5oSyoWoy2CSRopDU0dRNfHzXpMSuM7v10ehUVs4A39ezyeeoyjAf4mjhi8EkPgzPsiKuEhexVEBAXAcItz9aIZL1SyLSzSzMsy1UwuBqDH6U1Fi7LFzfSCL8ROMaVaiXiWY1g3FgxxMJXDzwRrv22YT8lMyqH6cJ661tec2btW/1yNvrbzMUPrD0K3MScUxpBfggal99IKMr7Egk9cJktfLNeZ3+6TLLg5YZyAR/agsFQr107itopBHGsKRQvR2VTrNpST+neKmYQ
 PaKNfnVm
 mvIqW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiqi Liu <liuqiqi@kylinos.cn>

This RFC proposes a lightweight way to expose a stable node-to-tier
mapping without requiring RCU protection or dereferencing
pglist_data::memtier.

Motivation:

- Lockless consumers cannot safely access pglist_data::memtier
- Adding new fields needs careful consideration
- We want a clean separation between core tier logic and consumers

What this patch does:

- Adds pglist_data::node_tier_id
- Updates it together with pgdat->memtier
- Leaves consumption to future patches

Potential future consumer:

- Per-tier memory cgroup accounting could benefit from a lockless
  node-to-tier mapping. That usage will be proposed separately once
  there is agreement on this approach.

What this RFC is asking:

- Is this direction acceptable?
- Should this be a separate field, or embedded elsewhere?
- Are there better alternatives we should consider?

Tested on NUMA systems with DRAM and CXL-based memory tiers.

Qiqi Liu (1):
  mm/memory-tier: add node_tier_id as stable tier identifier

 include/linux/mmzone.h | 2 ++
 mm/memory-tiers.c      | 4 +++-
 mm/mm_init.c           | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.25.1



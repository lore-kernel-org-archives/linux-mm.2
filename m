Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85EA3C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C736B0181; Wed, 12 Aug 2026 08:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313456B0183; Wed, 12 Aug 2026 08:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B576B0184; Wed, 12 Aug 2026 08:10:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F283D6B0181
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:10:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3AABBC034D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:09:54 +0000 (UTC)
X-FDA: 85092498708.23.365BDE5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 56C6B2000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:09:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786536592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=zZHuFAx4Sn7bWqzHMVLiNC9Jlyq36BX6RvVqGHCTQ3k=;
	b=Fk+JpG/znxyl4hjxj+WCkZaA6iW94xCbfMybPt9U2Jh0G11D/xGIQGhs48zcqm/mNi9W6+
	QI6iqEv76iwJHAOJwGcLitaTxvcSxb/MbgfOfuNE2caA51/oH3KDzz/JaFuTgy0EKiy9Xm
	9b9HK1KgowSumoJVJxsY3uGL0jYKT6k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786536592;
	b=GhVW9Uan7/WY4gByjYHsnI1IR7Np2M45Ft8MY0cIqYWaIy9s28kHg5ZBIKvjDJqJIuleif
	O1ZkHEJrR1nEr51nZeWMsQSTqD0Ly8rP1qlTrcqJ2YrwY0gjAfXtRdGb6ZaesH6yMjxQqD
	eRlZryMqmp3bQ6mWehMXe4cIavSe0jg=
X-UUID: b1fdb75a964611f1aa26b74ffac11d73-20260812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8f2cf8b3-7b09-41ce-a6a7-15911279cfc4,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:8f2cf8b3-7b09-41ce-a6a7-15911279cfc4,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:4b712535197c2843bbebfa3bc8d24bfa,BulkI
	D:2608122009446HJA6JVH,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b1fdb75a964611f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1734024905; Wed, 12 Aug 2026 20:09:40 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 0/3] selftests/mm: TAP output and global-state fixes
Date: Wed, 12 Aug 2026 20:08:18 +0800
Message-ID: <20260812120821.523860-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 386mp3jpfn36u1js6gbnsyxuga7c4uzf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56C6B2000E
X-HE-Tag: 1786536588-344214
X-HE-Meta: U2FsdGVkX18zl+hWhR9mTQitYRXge/a3obKmslHy3wccl3OuKoDTx34+s02wRGnrNSErAljYWJJiX1yiCuXb7ecSa/HXpynhIRPuq7MlnNr3vQEWkLeSIDPfkvqi2K2VtYyHd6A7YhXAi/REyNOobvhOXjn1nhz8I+3OAamHloQx0WN+l0CMK9tTgvqZTKZ6NYSsFWFt8wHIxGv+zEoeg+cFmnQMfYKeJoQQHwrQZrkNCj/BB1y1jcEnlbkULUS0T3NNPoFpCLnS57zvlSVPeNnxjQtblbK/50GfA0985t8+JRh9IGbGWdGJ4EQugXt/SjlHcGxOP5aDJ42U0cfkz1/+ZRThNXSvaTC9RnBxDb7ugwzsjKCiIrGA1GNhZ+x7Aok7hB5kIDliY2uEIbh9zk1v25PC7fVH7y++sD5gWuqDSPGZASTTaCbbOeBSTGM9lH3IWg9+7IgkqdhCz1Z34gVnLLiBN/8p06/ccvarZhL6EUC1hmdyJe+NuCeiy71EnQHb9+2cUXVkJqh2ETCAszSZv6qfQK5sXULQRtN+SQjrUg3Uy8tq+6SP9gxL0PHVGTO39yjdxhNKfFDjFBTC1qxF1aK49PIl4t/pxENsDVpnZIXyG97e2HuywufCa+nFSuHuL5/n8VNPJLZM9CG7TdDnzQFM1ao8k6xS3k+uRvR9XHWPvPX+3GslzPJe3+nA4vTEvAh5opv+vK134HCeWx9WYuVoherg/3Owwej3pBt042ttA2HZTYmZAm5Eqsb9hl3gVjTTqGS9BklYyM2Zok7651lCYuU3jcTQQJ1mOtH36aFTQcQJp4rnCMeoj2GVFpISow55dhh5JEdyx0qBIvDwS/Wvgj8Z2+c+bBMBGzzD6kxu3ISPznNKA+n2zkle97xcgaXESiYIIAnQrB8JVhuOgIEmIGqREdhWfhBCKjQG+YcgEEqjK2ZaLURs7FJ6dQyitc9fjq3sa82WiU6
 +pxCGQv2
 6+Bhv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-wp-mremap and mremap_test never print the TAP header (and mremap_test
skips with a bare exit(KSFT_SKIP) rather than a KTAP skip), so their output
is not valid KTAP; hugetlb-soft-offline toggles enable_soft_offline during
the run and leaves it disabled afterwards.

Tested on x86_64.

Song Hu (3):
  selftests/mm: emit TAP header in uffd-wp-mremap
  selftests/mm: emit TAP header and use TAP skip in mremap_test
  selftests/mm: restore enable_soft_offline in hugetlb-soft-offline

 .../selftests/mm/hugetlb-soft-offline.c       | 24 +++++++++++++++++++
 tools/testing/selftests/mm/mremap_test.c      | 15 ++++++------
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  2 ++
 3 files changed, 33 insertions(+), 8 deletions(-)

-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82242CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C856B0005; Fri, 29 May 2026 03:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE4B6B0088; Fri, 29 May 2026 03:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02AA6B008A; Fri, 29 May 2026 03:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8BE6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:16:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 414E8A0BE1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:52 +0000 (UTC)
X-FDA: 84819600264.12.DF02C62
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id 76F92C000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:16:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780039009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=/+XgHBMtp/y0PV5K0/8risG+6bC6au6kifOqzQWntAE=;
	b=Zk/YU0JSqs/2bNYKHUlKgsJF52HCzQ4WyAxUx/t8vVds3CTD+E+6ixBOUlhDweUsjO1TKY
	0vbIONaW6cUlLOds6eaVRfAQbOd853Xi7Q2uZ0sLggG6xTl6zbOnsL3mdsTwH0DvG4BpC6
	IJM9Ssc34OA/4AaG6fAHnlCMAm6DxeE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780039009; a=rsa-sha256;
	cv=none;
	b=0L7MmaBg2IxrIMH/R+xtS9Q+7z/Exsm6+1rJasn/WZHyUo/KhNdtM56MvSEgiqxSHMs5jD
	jtZ65VZkHxBrMtO+tbnvYZxmkgImLbK0M1uYh1k+PdkvwzHlGCu8mhzdwYjNBX7pjt5aqU
	iHPSlrn0+k+qZyYM5J3da2w+j3q2Gb8=
X-UUID: 55667f485b2e11f1aa26b74ffac11d73-20260529
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f7c0792c-2e1d-4cca-a68c-0b03cb29a632,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:f7c0792c-2e1d-4cca-a68c-0b03cb29a632,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:69b4f09c5df088340c9f7f839c9324f0,BulkI
	D:2605291516391VZCB8W4,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 55667f485b2e11f1aa26b74ffac11d73-20260529
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1738305913; Fri, 29 May 2026 15:16:38 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v4 0/4] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Fri, 29 May 2026 15:16:29 +0800
Message-Id: <20260529071633.2807814-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t8uicf5rzzwiffemohtz819bigo4149m
X-Rspamd-Queue-Id: 76F92C000E
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780039007-107623
X-HE-Meta: U2FsdGVkX19zTIRkPXsCv2Bv4gzY+BoQcFP+OWWRnA5ETOF1uJweFoUNs5dR8qq4Y7kgT3OgS27e4Q/XcvqOOM3i2LB4vu5lvaA0Lx4WTL06R31B02j84FU9Ye559S2PEIwKt5wbdHlxv8DIVevjwlNn0XDxYslphgeoRDNEMIuXYv2KvCOxLVMVweRtxAhOxjlQ3+R0n8gH1FiRYlgOJMUsEtXFDgPjEvRADTtgr2Tws6FStJqXqY75+YYrYyxIXe73xlBkc3Qlgjdc6Ay2MDRhyIQ4GW07qLXK/Ip8q6wFPnEoA4BxUTrvWAqLSxZhscmh2fPHHLJ9neJQguttVoGJSNC4j3MgA4jQJsg8PVcfhnlgp8MAJV4dJ9ZEnxKV/ae9jISwQtPJsK7OZIDAbJXmjKlQ17LwTU7QqgqA/Iruhm785dimoZp6K/VDINMIm3gVEIDWdOCIrEr6wAkxivRQ1QxCBbk13mmiaUvBhesU7Mun2N1jIuEk3gv4GRthiWI+Dp6zQp7As5bXvgOBnn0PH4qzOTZT/iIySkf3SeqlW5rQRILFwZ9c+eXjYtNFweQzpPR2HLtvC+z4WgDGLdleC88k+M7LI+T6KbbGN+umxphn0ZRjr13bhfxDoY0IJ8a8JYETTGqtFnUI3hAnXNpk5txPBb4pH9lmx50nTnWMYO1jR+a4W+3s5dXDBx0O5e1xC7Gv5nvydZwP7mVf71dXb+Mn7kjSl8eEnzywGWRkQ3Nq0vJ41jhkCJiljVQ+wHPln/w4RzZjVU5EBLnKyRB6zkjU0hDtAmKQ3VTtm6p2GlX/hSTpyhd0u5XGArogqmuipzLc5tT5HHx41jATYqBRL4a8UwkmQBloGH2aFOGiVLRlWm/XmTY9YE9ClHJl4Wa1dWKnApuVpjAqxfkbuHTb6X/FYzb1bGUXhEtIY9mYBNbXpcKLo84dbZwkctUhVvlNzhIIz3vRj2p8DGg
 EutqfaAX
 T/3c93sD9ER62ToCEyO5FCxyUJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The main changes in this series are to refactor shared tracing and assertion
helpers into a common file, unify both pkey selftests on pkey_assert() and 
per-test tracing for consistent diagnostics, and add missing mmap() return 
checks with MAP_FAILED used throughout for readability and consistency.

Hongfu Li (4):
  selftests/mm: move pkey selftest helpers to pkey_util.c
  selftests/mm: unify pkey sighandler selftest assertions and tracing
  selftests/mm: use pkey_assert on clone_raw failure in pkey test
  selftests/mm: add missing mmap() return checks in pkey tests

 tools/testing/selftests/mm/pkey-helpers.h     |   5 +-
 tools/testing/selftests/mm/pkey-powerpc.h     |   2 +-
 .../selftests/mm/pkey_sighandler_tests.c      | 110 +++++++++---------
 tools/testing/selftests/mm/pkey_util.c        |  86 ++++++++++++++
 tools/testing/selftests/mm/protection_keys.c  |  95 ++-------------
 5 files changed, 152 insertions(+), 146 deletions(-)

---
v4:
- Base changes on top of the latest mm-unstable branch.
- Split the first patch into three:
  patch 1: move pkey selftest helpers to shared code;
  patch 2: unify sighandler selftest assertions and per-test tracing;
  patch 3: use pkey_assert() on clone_raw() failure.
- Use ksft_exit_fail_perror() in main() for mmap() failure.
v3:
- Use pkey_assert() for remaining sigaction() and clone_raw() error
  checks for consistency.
v2:
- Update commit message
- Move shared tracing and assertion helpers to a common file,
  replace assert() with pkey_assert() in sighandler tests
- Drop assert() from main() in protection_keys.c and add a proper error
  message instead.
- Link to v1: https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/
-- 
2.50.1



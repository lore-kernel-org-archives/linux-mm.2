Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65324CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B5D6B0095; Mon, 25 May 2026 03:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FCE6B0096; Mon, 25 May 2026 03:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DD16B0098; Mon, 25 May 2026 03:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB5A36B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:30:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50031140174
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:30:11 +0000 (UTC)
X-FDA: 84805118622.01.45BF209
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5855CC0010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:30:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779694209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=m/e3sVQ0XOZpVT+0LiW/LypT+5emoOg0KU44yCG6+TQ=;
	b=2EfwD8sP8Pf5rZVPvp2xTaRx7hcZ3mt9MQU1ThzZvplUadnUzSmmx61G/XZvgsrtBEObeh
	vuXc23r+m5D8vQMUXzG9GQb7l2vTfOPInZMuAiWeNSz8CualJZSgXda9O7Zg6btdV4++B5
	OxErhH72WYLFgXeH6ae8og46FM5clXo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779694209; a=rsa-sha256;
	cv=none;
	b=Q9j2Rcw0SP1Vpspgeb94r3xLPdgYlOgVW5AaIVYb5cnGFZX+9IppVtk4jrsmv4V6TdT1g7
	OdfiiCqAkVtC8Oo9u7dZRmbj3wBr7EwMt6z577ss7+A/J4BlHGASuXAKNbqmZF++Q8m1JZ
	pzXmdh5ANA2VKl9v9uYZQlPweHnI5PY=
X-UUID: 89393c82580b11f1aa26b74ffac11d73-20260525
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6a2ec9fc-1d7d-42eb-8e77-6ebdc2449a43,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:6a2ec9fc-1d7d-42eb-8e77-6ebdc2449a43,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:05f470e43124d024726f241070f80412,BulkI
	D:2605251530023B5XW8HZ,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 89393c82580b11f1aa26b74ffac11d73-20260525
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1149553975; Mon, 25 May 2026 15:29:59 +0800
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
Subject: [PATCH v2 0/2] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Mon, 25 May 2026 15:30:24 +0800
Message-Id: <20260525073026.27594-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3mqmfp14q3kyxhwuk18cdc9u7a7xst8g
X-Rspamd-Queue-Id: 5855CC0010
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779694207-115140
X-HE-Meta: U2FsdGVkX1/AdDZDRZDQH1MM/CvXyZaFMQSxEYk9Q/jJbaoMgx49B3CP7FTGqKJGISEEy1bK5M6x4oRTRwiJVoCVr3qRwr2nDiDXavS7sKooRBxMZdl+CzB1I/TItyv/FvZKOZOeEsBN8YfX3MJhMc75vNu+5c1SGvBr7x6KlQuJ6+4GQUCvNZygKbQAtdBmcaN1mCVnQOlKH8C0OCFVQBrBesJGQ2JJ7p5SVw7Y1P1ZX7yfHlDvxN1sQMQaAqPLU/m+xbfpmPhKmFPwuT8V2GJ/CXabGsCm6s7bIzMz7NegIxR4SnVsdmMmWzX0JmyWzplH9mVjRvzjhhFFbzJnSnsJhYdY1quhluf0dz9amJgZ4knJgERcsD9eaaNRy2JEw7D3Sbk+7HWLqLj7bvHe/6nVASf7UlvT687wWo8Ap17IMuN/zJzIz8abINbF+04I56ZznBiT7a6LrACzSE/QLHK2dDn6Wo+yBwkK75OKX8s7upank/375AkVqV9OHTOWyNSX5n2O946x6sPxrpp+uQNePFVLrvva0L7jiyqlKAJgXhtfTchIUEL/7ZYrBh1VHsy09cV8MkVyxbx/+99bk0imIjADuknp5q2TBKeWCYh4YFTC9a+SkSIylOre6PJt6XQDM0fn9ZMDWMHq25iN3ODBVW+kITg9JuOys+Aid/a1pGFHcaP3GXHYY47j1UPMOcMcjyh8cnqT65NvBbehcTARrL5TkIRUOZaO76p/k8M6lAaseRc4pay7yb9JhSPuR+tzZwmHgBILWcZM9GrFRxsRcoQ0mE6YYEOwj34Dd03+xS8L6TXbvL6oq5S26X4pi8hC2/Y6oCT2Bjxhtq7Gz4LqAcGhzZBcU7HEC0UPB+8KhYrl+J97nXdP4UOljpsRfMjFf8Tu+I2rlTmGqjFErH8VldjjobLrM8EWLmlHk8IL4EsoaN6LtW8ued2Gdyuo/b7I24qe0HV2+P8qdJk
 DCC41quA
 O0d1diqPA/p+ZZPHOHb61hGBTsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is version 2 of the previous patch [0].  In v2, the changes are
split into two patches for easier review.
[0] https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/

The main changes in this series are to refactor shared tracing and assertion
helpers into a common file, unify both pkey selftests on pkey_assert() and 
per-test tracing for consistent diagnostics, and add missing mmap() return 
checks with MAP_FAILED used throughout for readability and consistency.

Hongfu Li (2):
  selftests/mm: Refactor pkey test helpers and unify assertions
  selftests/mm: add missing mmap() return checks in pkey tests

 tools/testing/selftests/mm/pkey-helpers.h     |  5 +-
 tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
 .../selftests/mm/pkey_sighandler_tests.c      | 20 ++--
 tools/testing/selftests/mm/pkey_util.c        | 81 +++++++++++++++
 tools/testing/selftests/mm/protection_keys.c  | 98 ++-----------------
 5 files changed, 109 insertions(+), 97 deletions(-)

---
v2:
- Update commit message
- Move shared tracing and assertion helpers to a common file,
  replace assert() with pkey_assert() in sighandler tests
- Drop assert() from main() in protection_keys.c and add a proper error
  message instead.
-- 
2.50.1



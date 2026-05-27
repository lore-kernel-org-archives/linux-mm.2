Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1F8CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372B86B008C; Tue, 26 May 2026 21:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350256B0092; Tue, 26 May 2026 21:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2607B6B0093; Tue, 26 May 2026 21:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 144236B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:38:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D21648EED3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:38:22 +0000 (UTC)
X-FDA: 84811489644.16.2D3A6B0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id E9AF080007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:38:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779845901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=HXcJcf3WLgUCWMhUO0Yr8fwxIaN/aaKRbbYyzwcc9ys=;
	b=a4gEmSb0I7uqORgLYvL+FIIRpk+g9dVBel3uH/DfIQaf0vXm4757qopa/VpJw2u1FBH4H1
	4xrDUnUkcaNbRH6mEXQyiF76Pqv9BU2IUJle0NZiPoNq1L/lE3Dr5op+ju1lbo7thYOvWs
	V/5ZL9ztoeK8NksoWcN6TqfSje8pwsI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779845901; a=rsa-sha256;
	cv=none;
	b=v9PjllNuYYJICJdkVzOluD8n7gb+NRb9ulWxKDq749CB7sbwYUMgwU81oGfDUJTs7hkMOU
	H0j8qqRIwBfav3QcCaYlQij3T7KvRO4j5OzkocADG/bKkF3zVXPUA+SsKXgbClvIs6P4Xc
	oozdeElTQxUTKLdOX2mi3pGClqVLwbw=
X-UUID: b8675b1c596c11f1aa26b74ffac11d73-20260527
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
X-CID-O-INFO: VERSION:1.3.12,REQID:30580d6b-d438-463b-9525-e2ee11ed9bc8,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:30580d6b-d438-463b-9525-e2ee11ed9bc8,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:6aeecbd46d70fac356ed410cf65ca50e,BulkI
	D:26052709124556E24UE2,BulkQuantity:1,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,B
	ulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b8675b1c596c11f1aa26b74ffac11d73-20260527
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 449002259; Wed, 27 May 2026 09:38:11 +0800
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
Subject: [PATCH v3 0/2] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Wed, 27 May 2026 09:38:23 +0800
Message-Id: <20260527013825.1134225-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pg7ipj89pcoq1s5wt48txtwsj34rn3b7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9AF080007
X-HE-Tag: 1779845899-371814
X-HE-Meta: U2FsdGVkX1/U8Iw4vLTXHxypOj5N/qdm+lK/lWCg+5pz3w/DHzQ/Cim7KVT99Blc71cYMqewNxJDNGFikvIUxvRnuWowH3dSErtdJCOu6krteMF/E7zhgsdpmyZi1nOEiUgG2hQf4L6/n2w1NpMO5IAuERhdKejrxdfx67VFP9oP28vFWIvrMcw7zFizB1GWLTZBOGVkGuGpbQBGGsEFavdp77wYtUrMwza59fVlj7nuJcNGy9mBiO6HYpIIDdNJ7qT0ymXt1vEwYWYBsjvZLANPgA2C841ilMVcXztYhfUE1kFDuJa3jpd5KBKQrkK9rJ7Asl4kNCThjFgmsDwyjXBq8X9bXIY7MaDCIz/lJ/pIveolw4RHIOrXVG2NbGNqP3nb6xoMH8AuhHlsr0jCHWY5h8g836pNKmF/2x6MVSQjMjrLndGSGEbYZqwJ4hh9pwJ0s49Or97+tmCF5ObSLcf64Bt5JhLocsyNI9jqPc22fCO5PHwYke2FSHVMo1z2u2quI2+R04UZzJT6lWfzS1yXpkVp49zxZJAGN0eJ1Qc8xDtUzeEyFpCRNneOYBXPC7RfezrFHBb/GyH2ZszIAGYH6t53Nhfg3Oy266gFktff214hHzH6dTVBT0xQjOnX+CZ/K7L9FdkR7hMm4f8xWGztgfu2Yw5Ghz+I2tKy8K1fqqCmuruRNq5sSLtHPLf83iwYmYZ3HMZJu7VTt/J3NURn9GPdcaVYT+i+/21wur/hjwntFI5Ib0z8j4Uk7r88R7akwkfvVs41Ga8s2+TjCdeKcvHOkgqyQvF3GH0LWhhoUXDt7dsnvOq0a2mSTWJUiegjnJWU2eY2npYReUMyNbHwUF+Eva29nVd0iBKSLNhYsj/+pFGBdETja+auT8ai99TeDvJDB9M0zka4PNtE3YKiqQg+82JE3G7fTxY/KxXYq1P+A7iMMiLh+PmTgKSCWJOpP8ZVWvMqaeNT95w
 kFIoPlSe
 S+uFG7XPXoh6FAdewJsnYnUot/A==
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

Hongfu Li (2):
  selftests/mm: refactor pkey test helpers and unify assertions
  selftests/mm: add missing mmap() return checks in pkey tests

 tools/testing/selftests/mm/pkey-helpers.h     |   5 +-
 tools/testing/selftests/mm/pkey-powerpc.h     |   2 +-
 .../selftests/mm/pkey_sighandler_tests.c      | 110 +++++++++---------
 tools/testing/selftests/mm/pkey_util.c        |  81 +++++++++++++
 tools/testing/selftests/mm/protection_keys.c  |  98 ++--------------
 5 files changed, 150 insertions(+), 146 deletions(-)

---
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



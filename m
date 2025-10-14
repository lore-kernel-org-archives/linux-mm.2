Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A3BCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 10:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12768E00DE; Tue, 14 Oct 2025 06:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2638E000D; Tue, 14 Oct 2025 06:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9978E00DE; Tue, 14 Oct 2025 06:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C92608E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:23:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5ACFC1A07EE
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:23:55 +0000 (UTC)
X-FDA: 83996334030.21.339B618
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id DEA8F2000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:23:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="o/9cubEa";
	spf=pass (imf03.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760437433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J9JOaJlvD/7q8qVNfsfW+49TDQ791v2pZOsg2KuuwpY=;
	b=mWb4iFwBdfuNUdD4P/k1kCcRXlwWCJiGlDLcXCa4g1YRn4ECSOEXrsPtbHuNvl0RCZkxJR
	5uCJ2PZEId2xAybQIdDaHqER4qdsoraKpUpM8Xslr5UmxcelTct9N1T9J9Z+o1IjiszxQm
	Or26KmxBtuk+jepl/dH9F6k7hlA5jUc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="o/9cubEa";
	spf=pass (imf03.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760437433; a=rsa-sha256;
	cv=none;
	b=uoP8y1JTRVfRcXZl+7TCsmoLOf76zFQ/3Mq9zlNxUogQJXRlFHc8zPCS2UlrWXxtuFfNK4
	jr0Mz2ZtagBQpiDTGGawrW/CBOr+J5Hdm2kK5x/y5PsKQuI9sTFwGdUzhu9WKSwOiXdYT6
	191vG1IoTE/+sjf+MAjWpmDHNAA/47Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760437428; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=J9JOaJlvD/7q8qVNfsfW+49TDQ791v2pZOsg2KuuwpY=;
	b=o/9cubEaxUaZYl6aA4L9zQ1dwpUyWwOCTSwKmAaHmhMxztvWiobGgUc0GBaayfc+25cqUazqUa2DTDDYdRV2LMZSM6Se4+QhIuGc+10mGI2i4kuovz1SzYKbHqnD5gH7Aa1w+bat//NSu8XO2IAhy1cSbkMA75lk9uN4ivz1NpM=
Received: from L-G4162440-1116.localdomain(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0WqBnE89_1760437427 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 18:23:48 +0800
From: Yadong Qi <yadong.qi@linux.alibaba.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ying.huang@linux.alibaba.com,
	dan.carpenter@linaro.org
Cc: Yadong Qi <yadong.qi@linux.alibaba.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] mm: vmalloc: fix uninitialized value issue
Date: Tue, 14 Oct 2025 18:23:37 +0800
Message-Id: <20251014102337.5453-1-yadong.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DEA8F2000E
X-Stat-Signature: waywek6uexjh1hjp73fs61urezohuodh
X-Rspam-User: 
X-HE-Tag: 1760437431-694732
X-HE-Meta: U2FsdGVkX1/W5Hjc3OoSI/CCvnYxJMpefIItxf33eDepZNxhcGFXuaBCPxbTy9nxNi6keV4FCFtbfJ8lIsbH36eUNluC4odD8D11SfIBpymGjs/8GZ1/URV37rb3mGKdaaxWDJ49NRwI6vg5huA1gz9s1UzPho2st2loLZT6OGca5cE1pINjD5E/l2BnpAluziEqpXpsBSiSAwXMFCWZ+KRPl8A+N6VTIDSfYHxc/JKCOXOdRnN5En7tUEfWoHkt0pwEVV2QFR5POIleqPIwRbkKnAljlyV3aUnQy8XWPRo9PNPWTM24JLkaBYAMdKl2KZmMvQG031fsgyaoYLvVxTRoggX+r/W3Pi7124C6EDuVzvl4ERFPdz4/+lKJJ2v2kXt0kzku2FKkHn55Cj9OHE4cCi/nKP1R8ccCD+VABw7TM6U8OM1EdNlSs9AvbxEd0cYecK0lJy1chv2KVYis/n7gOAYxvttI7UZElKyXOZdeFss8UlUf6jrHh2Nfnfm7104LnoLy0hmiJyFj1uKMDdpAOq6B59+x2pCFEJjalDsEQPVfgpgBUgzfjQBhrJOVkcNGwW7qts6WJYt2QEt0k2XaIGKd4vv34DcpTn4GI3v73xyioy8wmPTraKGUFsCBTeSYJBAxN2FImE2J0HkgKwqWrO5/+8fjFHf3JYNTyi2sVIxkdb9qTVM5+7pbKQxbIvzrg+h5r9vyqDk0BCKZU6Y8AjxgOdAxq2AiOm/Gh7yZNAHdOhuWXwcaWwt8wtscDTeCKh5wNu7WM7JanekNg0L4Er1LBgrn/DJWUhlrl3qqcFX50lyT4YaaSbea7rxrm6Af0j+6lGnOHGGXe7U9tNpEaSkNCzx2cWtRal5+dvm/AAHgLNYxoB13JM3U9QOGXcc17t6QtmtH0JzjQwOF7M7pbnmZOr7uZjc+StWu52wJphkchB/KrtdlqRjJMgm/TqZ5PWafSA+YndCY8xa
 empl/BWm
 kHVCQ2/N5v26yU/nLc9ruruaRo0kjpAjvt/PyG18fD+lJV1v2FCKeGRCQkXaV2RAk5TtRPysXwLWUmfbqn+Dv7k0Po2gAUPd1FO2rBiPkf+mwo28oLPnr0jAj5sCMVJ5e8tloHkelqNcnrbY8AVD2ICUgcLvGTRfB6j9F65gKmRFziURDl7pvjvtB5HtvX8isp6obdcgOUBKJU8rqDVrIDEDsqUJu78HU9kNsukFYHp5Si8DrGUgEvZymbQcfCMpYa/ei+1MfVxO6BI0W6fWifrleguLv8YHSDu3E8zpqPLsTGU9wbudMbmaXki40Xha7lmTFFIszxIAGuV1UdKZvJDRvA/okLmEtml9DzmPVfb39htLWxusT+PUwWwcCpg5Eke10ojurQEr/s88=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Issues reported by LKP:
  mm/vmalloc.c:191 vmap_pmd_range() error: uninitialized symbol 'err'.
  mm/vmalloc.c:243 vmap_pud_range() error: uninitialized symbol 'err'.
  mm/vmalloc.c:295 vmap_p4d_range() error: uninitialized symbol 'err'.

Fix by initailizing err with 0.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202510110050.VG9YKMRK-lkp@intel.com/
Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
---
 mm/vmalloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c0213118a75e..6d6d4cf3e176 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -170,7 +170,7 @@ static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 {
 	pmd_t *pmd;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
@@ -222,7 +222,7 @@ static int vmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 {
 	pud_t *pud;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
@@ -274,7 +274,7 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 {
 	p4d_t *p4d;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
-- 
2.43.5



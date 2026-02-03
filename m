Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A009E6E7E6
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 10:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974DB6B0088; Tue,  3 Feb 2026 05:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9225C6B008A; Tue,  3 Feb 2026 05:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F1C6B008C; Tue,  3 Feb 2026 05:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73FA06B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:27:27 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D43A140423
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:27:27 +0000 (UTC)
X-FDA: 84402768534.27.799964C
Received: from h3cspam02-ex.h3c.com (smtp.h3c.com [221.12.31.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 96282C000A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:27:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of qin.yuA@h3c.com designates 221.12.31.56 as permitted sender) smtp.mailfrom=qin.yuA@h3c.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770114445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Mew4Zn4Xmax+wTeUkTn8AbZtoeXWnjxXVAssVALqdyQ=;
	b=n3VydY1LF9vv0cO0kGLCKo7AVekgcV/fih9h1WL9/ZQLUMJuQm1gT0vZV1EEkrlDPG2cFh
	1ZydTCLo8fgjktcpkqBLvdc58JCZFy9+Z/A1U7zSt+l6nIxv1+uf/j5bn9PMZ1u/GAIl0O
	q8TUpe0LXkfOFQuA3NpR/dqBIEsbqo0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of qin.yuA@h3c.com designates 221.12.31.56 as permitted sender) smtp.mailfrom=qin.yuA@h3c.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770114445; a=rsa-sha256;
	cv=none;
	b=IadxGu04y7u2SFMFQMnORhsEvGssFcEwEk2KcJ/2yxyr3TubTRtToaltiqWTtKlppKYhuK
	s7Gk2AbM4uYGrKPnJjZ7OCH+xtdB3KsiRgNjl3DR0E3ZLJpLkJzohcuyrE5Kf8hE700+5t
	XX8ZIVC6ojYK1V9+2/fPWqSpu7bC+Q4=
Received: from mail.maildlp.com ([172.25.15.154])
	by h3cspam02-ex.h3c.com with ESMTP id 613AQrv9096806;
	Tue, 3 Feb 2026 18:26:53 +0800 (+08)
	(envelope-from qin.yuA@h3c.com)
Received: from DAG6EX08-BJD.srv.huawei-3com.com (unknown [10.153.34.10])
	by mail.maildlp.com (Postfix) with ESMTP id 868702011874;
	Tue,  3 Feb 2026 18:36:39 +0800 (CST)
Received: from localhost.localdomain (10.142.164.51) by
 DAG6EX08-BJD.srv.huawei-3com.com (10.153.34.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.27; Tue, 3 Feb 2026 18:26:53 +0800
From: qinyu <qin.yuA@h3c.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <linux-mm@kvack.org>, qinyu <qin.yuA@h3c.com>
Subject: [PATCH] mm/page_idle.c: remove redundant mmu notifier in aging code
Date: Tue, 3 Feb 2026 18:26:49 +0800
Message-ID: <20260203102649.2486836-1-qin.yuA@h3c.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.142.164.51]
X-ClientProxiedBy: BJSMTP01-EX.srv.huawei-3com.com (10.63.20.132) To
 DAG6EX08-BJD.srv.huawei-3com.com (10.153.34.10)
X-DNSRBL: 
X-MAIL:h3cspam02-ex.h3c.com 613AQrv9096806
X-Rspam-User: 
X-Rspamd-Queue-Id: 96282C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: kfc7tc6ibkuek6dikwkxp9hm1fksc1fn
X-HE-Tag: 1770114442-394696
X-HE-Meta: U2FsdGVkX19ZpDRebM4OuG2HiMuXmp5r2G0PpRPKOeTWUlOsjwgQIVqf8G9s9z9PxQtycYhBu/9VMiJEy0hq71I15S/SivDqmpV2rzN6chR+QspQ4xZF6resj/2kMm/DoT1EtHcokwq76rnSoGB6smJHj+fG809FACDuTMGMYu+87MPQV17IxBrEb5iNZnnJvPzSMhHhlUBObonKfFb1gN4jIcnIZJUmkh0G06qsDpdSOcZstUSoOTyHfYpjs/arZzmqL8xvT3Ln6QlZi6MrznmdOnBcR4lbliZsBkMe1IF6H9Z+pSjkfUYPUZaw+TxafShZDsv8dANxbiAR/L/3KUTvipN6dpBNu1Exss3fPAbwTcyYoqw1dSBzqXxREE9PVNe1ZWehTmkkkmsTvLFHznJL2OeBwWg3l8he2tyENF8znmRrsZKY8+m5HAbVsBHJOY13rshaSHX6mSsjjhM5Cq0vMVTgab7BvGcsiSEVEZECvb24wUOYxHVhTmTBmv8aCzmVDzH6ykir2xTkO1a210Dryqhvqn/eWXQF6jwpksmHEhdL7ixi4Hr1ZCjmncAVf9PRAAN3lxn1GV0MFgXi1hzArK/93ifGz38MO2JWos2gsfhDUdi25kwu8jqyXEOoiAgxUfcHnUy9xAdDw/tUTJHYBf01A2+3AlVmZXKW1PDIHyVPEBXKCh7JHbxb1BIh1NcP4yNPkHIil3a9Yz76Z3OWIczkJIEMSv3vOcSVsvKpHFA9bqmtL3tLKKw6ZJvVefaGNHuBCiPMgI/5M4gd70mR4yfdUDqPL7lYFEfgQARfk4yQJcrT9co24Pk2gZ3mdvly8oXpzYsdmCxAGJkJE/Eq8LC2Tp1u1RXswQe61lZvrb/1N6mTFneXeK7o/oY0GniM0TBj8UtfRsnHl52DCP0+WIMeJ5hrsO7CY4GULq7xLBypengnepN44G0410NTNo9IGkHTVCq3yoa4zzc
 ZetQmQex
 ofoDA7c6LmtRoun1/4TC88jn+OkdFUSIPu8O/6zf56UXC+UwmZt/c4HWq5YvwN6rKMbxlfOaNB6kb8rBN4BKqhMFXeCgLsfWeNA6nt0TdxuxXhurEcshvE4HDETYN4qqdfpC+ffoqQsKIWQVzlqoARGe/frDA+SLVnSGCfkg2HZU7dwLZkhL2aaAJxCcvpelsAtPEAWsHGsDKUGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000007, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

now we have mmu_notifier_clear_young immediately follows
pmdp_clear_young_notify which internally call mmu_notifier_clear_young,
this is redundant. change it with non-notify variant and keep consistent
with ptep aging code.

Signed-off-by: qinyu <qin.yuA@h3c.com>
---
 mm/page_idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_idle.c b/mm/page_idle.c
index 96bb94c7b..9c67cbac2 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -74,7 +74,7 @@ static bool page_idle_clear_pte_refs_one(struct folio *folio,
 			pmd_t pmdval = pmdp_get(pvmw.pmd);
 
 			if (likely(pmd_present(pmdval)))
-				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
+				referenced |= pmdp_test_and_clear_young(vma, addr, pvmw.pmd);
 			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
 		} else {
 			/* unexpected pmd-mapped page? */
-- 
2.33.0



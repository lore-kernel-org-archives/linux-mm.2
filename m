Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17711FD9E34
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 04:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252446B0005; Thu, 26 Feb 2026 23:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE1C6B0088; Thu, 26 Feb 2026 23:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD526B0089; Thu, 26 Feb 2026 23:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB1C86B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:03:13 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A21B59031
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:03:13 +0000 (UTC)
X-FDA: 84488891466.26.390BCE0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8F83B40004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:03:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772164992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=CJO1PBqdFrnBC33ihoT+zHeFUsA6brXJ/u8/cwSzNzE=;
	b=yLcoDzjKJneLROB6PG0IRykvDX7lvJcdfgcSc+vVqtq/4K/+as/mKkMkri81bAnbcIoK6y
	bv3JIFlLK1MlKP0OChDHvAcwjCccyQ1yhPE2BpErvsqqcbKJyUQ3HM2Gm+AyfhcbrQVsxY
	Aecv5Fh04iBPHmDmbqCZlP8Z696u6ss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772164992; a=rsa-sha256;
	cv=none;
	b=Mjg9EVXAW79s39ROu4egiJlgQ4Hkf1jciNaJXbORCl4eK7VfdSbu7iKgjZyFAvBsoOgEc9
	U1Y95tzzA04mCwZlBxVTeySwxNNALfudL8IwGkjSmHBtI1c0bhQBfSH1leGM2yw4DuDjyH
	VaAm+QFYDbEwxD0ntuGhC5ypcZmcXiI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AA0514BF;
	Thu, 26 Feb 2026 20:03:04 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2DCD73F62B;
	Thu, 26 Feb 2026 20:03:09 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Replace READ_ONCE() in pud_trans_unstable()
Date: Fri, 27 Feb 2026 04:03:00 +0000
Message-Id: <20260227040300.2091901-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F83B40004
X-Stat-Signature: e7oxqoeyui4tps5yz33ui46h6qmnqkt4
X-Rspam-User: 
X-HE-Tag: 1772164991-687059
X-HE-Meta: U2FsdGVkX1+Qg8tFFNRB0g5yX/t8/xK5Gzeudhw5H3y+P+wE+yePcSkzh+ij47Xf2oMS40wujDhT+tH8l3KX8o3m+syr0w2ekuJlO+uKKWeIoa+dccHdERJsFBev6gAufulp9zdPkUJnV8S1w4edY7D30hIcTyztL8ZuCJlGoml6QqQPEfSK1ODLsB1srvmeT8o8SmgUvO8c6nhHW8l3mUP6pRoROFnNUWJtNmJ01qzQvHssTV+yrKP3wHjBwC/8jtz6Ne0afPCdFhMsMcxe4whL8OmYOAHdhLRBaiXdjHgQw6DHqlRu3TzcohEAMCWLH8WNCdzVAB4pyyumqId+oyXAwtzlFRdnRDZXRuieGKWGs1xr48W5OKtc/A/HSRywrtvAjXTX3cL+OM8H2Tq5uF3fRbjtyNsber2zEPl9xoKKQMUEhZzIL7soYwH3c5pJRV2I5VmLWaP3vD9L2LTZvOepY673OHNymh8uGwq4hIvQhfz3O7cd9PC6oRBc6BOy93xOEuNzZwKZO20PqaC6fQ35D7SduQs2EZtlehLqh0ZISpB/pOelonQksXYl/zX3i4x4ePgU3qTcEyxTvTwfHTIZs7Xj2mk31RDhXoKjQb654UYmc4oNiV9P8xC75ozvgipotZX4cVkwzxezcfUDOlqpNc9EX8kVCrSrToKYwFGHkG+2MfgwukASobrr216m/+61KTdpMec6njhCPhd2y1XNe1v6pCCvZGXKAKKPyphiUjN/n1uLbEP1eRRdYQO/OGuG1lnYqD+VX/0Qxgvp808pe54xEoyuwzh3+Y0AqQdxCP1HNQFvd/qvjHo1thM6jROti1CiqCPVZdfolFCAL+1poD/HD0XRrcqKunO285vc/TZVVn/cEEjVPPsA2GDIFQrxbAnafozv82k3T1ypwczTmPUAktnZ6HXipDnAZYRA+KToEvd8+uIbR9B8OhXBc8zjQF0zD0zC2Hxm1PZ
 6P7y8bGR
 bT6zz89wC9zdNnQ+n0M5WrXhE2IwzRxcSYdTgb5MVLiARXuba7hFT/sYFhLeVwPuBSw3YFlyd+q5cGT0wjOCz1hwqpnaWfvfvdLPbo6b+5dMhwRAlsPZIA9K3HuEsy6yDSAT98mj0H8hdtFUO7SYQGHgEZS5Sfxae+x45w+XcI6FBWeWwhxTHF44W4q0hgkFVO6+pTcxZJonIV4y169BCKixosBmEteU734fXxbLbU7EX5P6M1qYA37NnGO2FzZiSleZF0rOpWpbr8XAOBOpZ45pryJfIlAOMkWjUBAdar74ndIauVgHT+cU1t8whIytq9MzQX9sIiAhQWjBTT7qJ6MKoekkLQ41VxCtdpm3leTH5P8GW9gcW6SIndb1MVk1ESxpbYEStxOhRxxdlLnwe06cTUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace READ_ONCE() with the existing standard page table accessor for PUD
aka pudp_get() in pud_trans_unstable(). This does not create any functional
change for platforms that do not override pudp_get(), which still defaults
to READ_ONCE().

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies both on v7.0-rc1 and mm-unstable.

Part of the D128 series but independent. Hence could be considered on its own.

https://lore.kernel.org/all/20260224051153.3150613-4-anshuman.khandual@arm.com/

 include/linux/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index a50df42a893f..d4826447bc93 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1989,7 +1989,7 @@ static inline int pud_trans_unstable(pud_t *pud)
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	if (pud_none(pudval) || pud_trans_huge(pudval))
 		return 1;
-- 
2.30.2



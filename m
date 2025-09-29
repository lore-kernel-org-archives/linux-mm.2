Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD81DCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221EA8E0005; Mon, 29 Sep 2025 06:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0AC8E0002; Mon, 29 Sep 2025 06:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DBB8E0005; Mon, 29 Sep 2025 06:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECFE98E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:46:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73F43587F9
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:46:52 +0000 (UTC)
X-FDA: 83941959864.07.FA2FBE2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5CA016000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:46:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759142811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=DdnsqeT1i+HZ8r/ZlogS9cMjD7I/b7fjRCcc0LxjT2g=;
	b=8LxrYm+Qk4UaRwb6WOm88kzFldBHUl4wEC8hjRNshTbYNaSl6UPAOheTXx8dZjUGiBhlrP
	4y2K3yNCXR4DIbbHthSFTMRCDMamPgypiqQpToVTWen0Wgj9XTfagX3QITwCdex9u3AQNd
	pTFTAm5QWgXPUnVF/UzQeG23jFkT3IQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759142811; a=rsa-sha256;
	cv=none;
	b=Dwnven4ykQEQrZLA2FFqDypHdCpyxedUXcALeXRJcBKWffS+Ee/osqlYn48ZpmCQv8/IqW
	ecfODlM+/7smHn7t/3NQWJWydCgCExyQh3bEZLREte8OlrWPXsb6NatVgOQ2+7FF+cIPTU
	tpRqO6CJx0rVkackt3VB+/onHcib6S4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB93B150C;
	Mon, 29 Sep 2025 03:46:41 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A37F93F66E;
	Mon, 29 Sep 2025 03:46:48 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/thp: Drop follow_devmap_pmd() default stub
Date: Mon, 29 Sep 2025 11:46:43 +0100
Message-Id: <20250929104643.1100421-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5CA016000C
X-Stat-Signature: cfrq3kgn1bngrsfhapd5ntez6w98qtq6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759142810-419248
X-HE-Meta: U2FsdGVkX18RxD94GyEcMUWTiedpzxA+SNMKXReg/C184zGUsiB8ZmOszR7Xn9IOkP1a8M3DL6QDg4fST/zWZf3dTeKrnQsdqyLG+lDIgdeuAL+wo+8qhfSqpWThp797r4mGIXP2KczPwvslpktsieEvMDCXPn+vmy3kWjHC4yzYZstKPIfJtS3Tv770MeUFhVU+vZNgsysDnJchL62IXv7WuGP+CKD50u8o/ytJznhFentgFfd13vPApkSD3cTtrRFMTz5e8RG9SLag2CkwehyA0AxuyYJYd5h9F1Bo85vg8z3gjoDxWgskYPzcMcBDG3m7b7xZydF50CKZ+QweAP678DsmiFGalVd1eD0DXVk5DdzXvsJz0nEgPfZiE/TDR2/tvlc1OY+GrPJVlSCha+Lpx7HmBh4kj7Ka7P5giBNmbhUs9CAiIgnnde+/jaabffPmTUuDC/bO444rI+2yMqN2edM08H+eSktnAkDb24gE9aZefFhR1mjHd50aQkdWImucwnkq1uyFL7fvOJvJGBG7e+cs2BqFhiUPPK3a3VC0NYEEfDFrQPXt6ix3I0/ZtZucTu9JCTw2WogyVjV9OgPOd9CmnBKn0PNWF9w6yIa/7r0aWbwnG8Fp6/u/liJYnRr9uBtN/S8wtyGQdVA/XK3WACdhwmFwwHoZU2JoOONelgIqH4rMSYGqfE+SOn6bHOVCn49TdP2WPbCtwRJNGEk4ZXYMu3UH11OHeiQUNQ2akDH5mOy7HK08Sv91++AMZMDHoNy5BvLpHvshN45IEUfi1v4iyBkGqmeXGdzbk/1B6jkQdO2j+r2P1uyl5YxXRbql44pB3AKei2pdezE5SJD393seyDEBXpB8MXEzQ9HsYiWZRRWz1JiKEak706z5M1p13vZ3HNqPmAvXOZ6EoT8LctNg9WDo9oBH9tk0buz4NTi1NQf72ReyMzIDrCcqR29RWIfh1QHLlDGOcLw
 MTTX40vK
 4Bs0Rq7VT6/7NQQvkXMFASbMVcgNiZlzrftUxjFbzretYIZG4UD8ky8GMIp7zKvikO0phOfVfh99nSz/EWcprGTZbXx/kGjMPW5TtbKk9PUtQBDzru7FAkmvIO5+Cet7wLWis78RJFYE65U5B02Eey1q8I3wPIboyt4PcI800zms2xmpOedwx2yy/xNm0i46G8AG/gcVExFXCjxfsyVYXsIsGLrb+1UHtXBdRAIeyFCZrYsLevujtAhTjTuPejmCJ2g73cMArNc+6juq7RNWbV+Fne/PA9Ph7BPXxc74YHM+P2N5XzPs8eISOcy/c0F59uCOsqq8qjYV61ICDVve9bBN4qDteEMwypcvV/T89NQdoiGOwEvyHvGB0OOF6tdlJ7BOTftFPsQXi5YxnKqF1SrdGxHKcRCZPRPrdTyDGXfTJck8oUuOO7QVOyxpqg2r08BXP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_devmap_pmd() has already been dropped by the commit fd2825b0760a
("mm/gup: remove pXX_devmap usage from get_user_pages()"). The fallback
stub in the header which is now redundant, can be dropped off as well.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 include/linux/huge_mm.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..96ce0ca54e49 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -652,12 +652,6 @@ static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
 	return;
 }
 
-static inline struct page *follow_devmap_pmd(struct vm_area_struct *vma,
-	unsigned long addr, pmd_t *pmd, int flags, struct dev_pagemap **pgmap)
-{
-	return NULL;
-}
-
 static inline bool thp_migration_supported(void)
 {
 	return false;
-- 
2.30.2



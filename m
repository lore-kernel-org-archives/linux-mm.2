Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC04DCD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 11:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6582A6B0088; Fri,  1 May 2026 07:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E8B6B008A; Fri,  1 May 2026 07:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545276B008C; Fri,  1 May 2026 07:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40FDD6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:51:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92D591C0019
	for <linux-mm@kvack.org>; Fri,  1 May 2026 11:51:35 +0000 (UTC)
X-FDA: 84718686150.10.AF06F94
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id D0C2040011
	for <linux-mm@kvack.org>; Fri,  1 May 2026 11:51:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kowG5+Nj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777636293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5tw+WZA+mqeGQt1Qd8OUfYQgGb3rmHRrC8yOZWNPTlc=;
	b=5EWIjGD5bwSKNTBJAwfvRLDgEiv8MVsnrcIfE4pDokRhVcZxfbx/IdVDXqQ/TQjGn/BH0l
	lXsOS80zktair1J58f96acnv4tpgpAwdhlpMV2wH4RG+iNbwy8+jnuqabM3pbqme1rqDoT
	P469nymXeCPhEbQOnxk47/wOZxTwduY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777636293; a=rsa-sha256;
	cv=none;
	b=XSFePY7pnQW9fe+dELtBqk98RNSqS7igOwbi6TVqLvD3uFRqFzkRTBMt5K6ffG7PFCodMH
	4ym2egPGTnbmeVZy+uEHXTkSjLYWZVDEsHYdcp5UB7DYWGjjy9iMknUq6AHWQD2GqAUIig
	UrMx7rHS4hyR9e2przIuqd9zlIn9tHc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kowG5+Nj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8296d553142so1257303b3a.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 04:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777636293; x=1778241093; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5tw+WZA+mqeGQt1Qd8OUfYQgGb3rmHRrC8yOZWNPTlc=;
        b=kowG5+NjJ9twC4XZ5novVI3BXvPZxOHcKZmSQQk/p7czZJYAog+M+DocnSG54c353Z
         /6mfoq5lhgEq/3zqmd9fgrXz8XeeHzKxAUa8HHJdEkHlAnE3wA9cO1Ei9c83sARjxTZd
         i/NijXBvGODEJtzuvULupATYTP7Qb1BXRxls8Ht4NbwOMB6aIYQE7ckE6Mz+G5A3rqsK
         xvEdCyExiGcuagYDnz0h/iRIa55JczqA4tdSshN+SiMIY+9tHyDzgwzaVVnJblIiYvNW
         zh07P9TZ857bUgJBlhNuc+7NferTaI9uZv5N3GvQHADTEtgf/vKwHEzE/XN+hCqrKViQ
         Zlhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777636293; x=1778241093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5tw+WZA+mqeGQt1Qd8OUfYQgGb3rmHRrC8yOZWNPTlc=;
        b=NfdBv5kcug9Oq98ATQcm9N3KABYQA9MBEukRW+g4V0s4PR25L+Fn6WLmyZF7Bmz01E
         aaEnzQjXUT/Qz/4KyaMVz8MrX6opEEIvq8MHzLx954fjb6a+btY1dECkIkAZrCU2KN3a
         Gs9GJXFI5xWhru3oTIdeQK3N7+8gt+wFSkr87HemcErm4nMQSwVT3H9XaAlAhdIHBHwM
         ftjdt6gTU/7IKmtgZ3BiDZQwGRRPmhLCIU8VVkq+Ym/wDdYuh2Ec1wS9OJcOQJhcXo9/
         IP2ljf+d/ge3IVun2YFHCjwlbTiZciLjlnUO3/1XP4VWrdXNA9QIINN4QvyQOI4VskDT
         ISVA==
X-Forwarded-Encrypted: i=1; AFNElJ8OVS4Jw9rfaIJVjj6UvrNt/fl0Dw21HZJv2Y+a5MpDEf9X5qz5U0GdBTZ8rfBVGrOO2iMoBAJhrg==@kvack.org
X-Gm-Message-State: AOJu0YzxlU3vcpmFxuBhFK+n2OqmrN99ym8ryps3Rqpxihg0Sn3RQ0Rf
	QAJHAOMki2/MehgbFD3HZcCBouqdd9zexIMjn1kPSdxkbsqWRQg8pBWk
X-Gm-Gg: AeBDiesZcBxoRW/lS98KgCRHKaiiXHatiZDm/fVimyEnaiiQiuQWDiZiMxJxaRXS4k8
	vfTYO5tvKGHlhBGwaHTtPy9w3XPan/KmO1RXoOYBvfqsl1Wcxjzec5TAY1EUSuKBv1vi9+Su1kR
	8j+l29Iq0utDecG8sh9416BxhIHv/z6RUnMiPM03a4QV4JxY1xgXOX/cBaPGItcBde9HS4S6NTg
	XBSNjYbGi7yz4vdzmlutjA1LN4/+qon91XXPvmqj8TvZYDlMKtd3TqfFvgqzmslZrm7FFYyLDgR
	C11j+WC1W+N4h3hz0fGgnI3EyVCEEQOleYU8wvni2Oa9906OhK+VHUvEWGS87O8RQ5jj2LJLkOG
	rJxWcIEoFBIa34nrQfmO6Dbx2BTPAJbjKYLKt3u4tjkWNTIWG6vTZl7bZTINeEeOQNa7xFoHdGm
	AoH9hdTzMGoLz28XJ7V1FooU6Qwy+8u7kqtdtj4mdtWOFqgh6e+SozuZ0o
X-Received: by 2002:a05:6a00:4c93:b0:834:df57:9d36 with SMTP id d2e1a72fcca58-834fdc5aac0mr7868686b3a.25.1777636292620;
        Fri, 01 May 2026 04:51:32 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.19.217])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515893f14sm2563533b3a.17.2026.05.01.04.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:51:32 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sunny Patel <nueralspacetech@gmail.com>
Subject: [PATCH v3] mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
Date: Fri,  1 May 2026 17:21:16 +0530
Message-ID: <20260501115122.23288-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0C2040011
X-Stat-Signature: dskc8aybatz6j85dfkw9brpy8h76gsrc
X-Rspam-User: 
X-HE-Tag: 1777636293-989751
X-HE-Meta: U2FsdGVkX1/7zvr6C5D30xWdveVCeD6hXRzGukwSsucaRbQY9NeaBX5BhGcdJe/z7z6gbIqB9oObnvnW2g9dktIGzhO4s2trm3wn3V7aT7JrBa2mxkCZLB1Z6cbixUxWN5rzFiVowASP6Gsc9fens3adnNOiSVTqOxRaKKllRfq+B5edPm/KA08+z0ivDKyvhVdDD2nnfc8zcaBrkTx40S5AK25dNrgVWK1m3HklStZg90lEk5r9jOAvlt2nFBf8ly/4i7p8aEFrmgV3UKBIP0Vsx5omCFGaoT5A3MTVB5MUgrqUsBER/xPNxgibqysIWPOe/P+go2LvHgHCjIvYC2PodB9msYVCJoMO4y9sfqutRcTkJF9QkcbqbzOlJoEcQOU2agXYPl/TlBZxzcpM7RKqFdDdch9eGcJleNccYSc6X+NG5t68GZ+0f12mAFg3lRfCHGz4sJAOCSBG+ze/a3sLHIrI8wqRa07KMe8HSBqRiK+EkGv6s+xojull0gU5lbvG+HTXMIRBCHn8pmyIn4oE9WEgK5CjtrcTyf3h8pquhQ24Y7RXT/As0X1UmiyaFsuikoLxzp4u2WBPSujnHrQ3xKp8AOslYtRMK+y/xS52hGUVLNulGyXqY5+2HH28XeQ1NIg2v9IPZNEb5jiTySNHOtthooA3luKu6LUKIVPlKtHCvfcJ4zzMGdB/vsabKQCFa29dCizv/c9W1L5MCgbn4C4SULoDSY2YVx1V4RC9fxiKbCJLvR7duvibPPmnRSSjfYwqU6QDfliX+WNMeCfVsSofrcA+JQpOWxO6fEAm5v3pBgj/bgkx0E/y4pj+vQWHH9mHk2mjM1ISVAVu9BQp0aSJtWVNYh9TWKodMlH1Q21xpK2OT1hp7mEWgxzs5RrBaFmWqq8jBQSr9G3Qe14EYAGGe9FqfS9ty/o+kMMENz1bp+ySUkmEFQVCQ14KoXah4sA6jLW/2eXrGL3
 Nl3sYmVR
 Ex/WW4tUeOjVW3xu8HYRiahrWBV5Pfd2nk/qSBQfpAMSJBY/8bok5GqtwMG0O/XlKeW1km9bnXV3Bjbp9KWn5MlnsMkBDSCnzN1cj0Azz9IRGOFQB20dgyrOSC8SlAMmz+xlDuILO/cfnOgJ5f3iiWymgnQk43AnQ/XpPb8YVVBJNIShna+rFfrVziT/miLLFr3gtSe6BERqPEg4/ib6JrwNqyDw081toPsMN9Jeamc7LTnt2Pn8yhL8S3wYRoWLvRaLD343VHr7AGhA9wKAN7cRJaNEd/v4pfXo0nOus8am7MujqMcbOg2sMMrWzwSIKkehhLajM0Wv+015UCOlSIYaspQ9NKdpO1EZkv7HiLCo1PsuY99lrmvKUQ5mlDUm7dgsOCVBScb29CdJrWTTJBCgZ3g9bu4Wy1/XtzUo/b1LmU3cEmrHJ4C3IBkfkXiY1bOduihF9m+ARdfRx8fMmhBaLBlKpfXXIzal377gwQTQzoEspqHy/FowPDv0twDLgyR026ao2Q074W66xg5jlvus1Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
to a PMD check failure, the pgtable allocated earlier via
pte_alloc_one() is never freed, causing a memory leak.

Added free_abort label to release the pgtable in error path.

Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
---

Changes in v3:
	- Added free_abort label as suggested to release the pgtable 
	in error path.
	- v2 had the pte_free() call in both error paths, this 
	version has a single goto target for both paths to avoid code duplication.

 mm/migrate_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index fbfe5715f635..0360b410067b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	} else {
 		if (folio_is_zone_device(folio) &&
 		    !folio_is_device_coherent(folio)) {
-			goto abort;
+			goto free_abort;
 		}
 		entry = folio_mk_pmd(folio, vma->vm_page_prot);
 		if (vma->vm_flags & VM_WRITE)
@@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 
 unlock_abort:
 	spin_unlock(ptl);
+free_abort:
+	pte_free(vma->vm_mm, pgtable);
 abort:
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
-- 
2.43.0



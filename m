Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C629CD3427
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 01:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137806B00BC; Thu,  7 May 2026 21:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F186B00BD; Thu,  7 May 2026 21:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BBF6B00BF; Thu,  7 May 2026 21:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA8A36B00BC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 21:37:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9513BA03E7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:37:52 +0000 (UTC)
X-FDA: 84742541184.21.20C89AC
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id C26D5C0014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 01:37:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CVRax0gz;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778204270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=mCR0Uxw8nPMjXkQNBVuhopP7MZk6tXzc3P0jjJgs7Do=;
	b=Dsbvnel0nDC3jG3dbAH99t/pqYGsOy7yMZdeq+/DA14UKjoUwv6g8j0Bf1Hrqzp9uMZAfi
	hxbLqGcQccjSfVmJPDxoIqqpkNynEbs4mExhytqkkoznkG+28eu/EtsnvjXo7XO9DSLZmZ
	MVpG1mkZh1bxoFEMi7yaDaDbgjVyTQw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778204270; a=rsa-sha256;
	cv=none;
	b=YjrM7/h3y1raIP2+7z426+SjHauupldWpVSpmTt9jglvZEH+edGdT3Uf6suMr6z7IRXtRD
	e6qwzqD1olQWM/iOBaYkpspzHmBFX6fEN1o+0NuVVQEF3qZpORI3WNraYk0MeMB7Q61v8v
	WHphn/hHsWJy7A8gyzjiQxq/Jbffxkg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CVRax0gz;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bc3582acc23so228016566b.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 18:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778204269; x=1778809069; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCR0Uxw8nPMjXkQNBVuhopP7MZk6tXzc3P0jjJgs7Do=;
        b=CVRax0gzLXKNNTCe56cBC0VdCTe0Go8JyIJGSX8jxKw/mQKGIys9TXt9ezs6fkSNac
         kvVXGw/9xUbSYDDeV2f+YkVwd02iwqW4XFGEnPiOxwTSXAJjNmg6d5rfsXMcY9c84nCy
         jtA7cL7TZD41sT0VR6kiRuBT2qjpO8X2mRpthH9ugrnq0vcTXYWb+WzSeXwJV0PAA59k
         VeCPGVksIfbFJH4cnHMsiVHyBtFq5WAdkVsT3/KTwCccfOn/ADHxKf6RDIHMepla6bNL
         UdPV/Hb7WJj9OeWmSgCgZSXSwQsvuYH3cOK4FcBGhNgF6WDvm4IyYrz8A2HutvkxH959
         v1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778204269; x=1778809069;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mCR0Uxw8nPMjXkQNBVuhopP7MZk6tXzc3P0jjJgs7Do=;
        b=d439XOKkGITt50GQASO4sJUJdU+kfrjdubtHEjU8JxpkchzLNenbQ0VGeVHTc1tJKo
         4joCTevRZzoMH9Zw4Vf8p/DBYQZJVIGhv5qq4uniUpriVugxirYMHmzYqh4GcU+L66Yo
         xMnfP1CjZw3TMX2oS8sx1Okg6PIVwyb1V9l0QLveVexTzrJx+bDTNEepv2C8f+by4lCv
         WIByc+utnHZ9BqDBSw7PQpbwX85xP9plTM/q2hQTDQKfRNEB4Rxtg8nUohkWiH1UiVv6
         jDQ9I5XPLNGRuoZTS6aEBNqUGZP/8zTYxIe0cAManQvB1giG5WmcdGQ1kksjef7xZwrG
         Q3IA==
X-Gm-Message-State: AOJu0YwVm1Shw7PWY7BIzyXWsALt3dCSv+QcMZbsHCWUaAepTlQdmkFC
	sw/eYXVLpuAJSlxgHUL12S+yl0AQ71J/latkhgNwC4s3Q7f/UfcGkkqu
X-Gm-Gg: AeBDietb/tPNIVdhkz6znDE7o6aEhI0dJ5+Hgg1txHhcmZoFCOA7xKsQAXHS7Kc1aQl
	60dsqVVG6ZW6yQX9yI+1FVls12HfbJpWQiUccTk9RiC1jqRpqFCX6C5d69HpN6GsMfM48jK9Ssi
	HM+mwW1lo18IHNs+mHA/xKk1UVBIaZmNm6bXwpticGGMu2TZOCKLFNgjq5NtmRUAWDyvWdtmBgw
	NWCDYDxqUBfCO2VVUAOLI1tSXW5PfowYDgsYL2zIdf2dn6+Vrn6uNXNuBgZ5kWhiw3TnQD12Ftc
	snR5WxJUiUiPxKfGGJzX/pfZH+MuKbLK+JHc0NtaOuFOzn+X7qxdY9vLQdJBLIa0SxCqo90kS1b
	yoEB3vmHVYGPyY73x3TPJAfuB891rXbRb0NBDV+V/GKOmYkYw2Tu4UgUHPOjYUNbvk1ONFCjrWQ
	g/ljiiMAfpVHOtN3nIwClItMxV0wQNzg+w
X-Received: by 2002:a17:907:25c8:b0:bc1:526c:1ee3 with SMTP id a640c23a62f3a-bc56b124741mr594281766b.13.1778204268865;
        Thu, 07 May 2026 18:37:48 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcac02c82a3sm12614666b.13.2026.05.07.18.37.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2026 18:37:47 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	sj@kernel.org,
	ziy@nvidia.com,
	balbirs@nvidia.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_vma_mapped: revalidate and do proper check before return device-private pmd
Date: Fri,  8 May 2026 01:37:28 +0000
Message-Id: <20260508013728.21285-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C26D5C0014
X-Stat-Signature: a9mx3hxmhxfkyjtztz7t3os7ogujs93q
X-Rspam-User: 
X-HE-Tag: 1778204270-308686
X-HE-Meta: U2FsdGVkX19O2NLVTU91HQ5tz9hBsD351RoHwcK0zqnKLuJdpdOp0vMdi7f9LsKVo2Im++UtmDtCvgzgE4UqHePfoWliSx9ot+4ag+Kikogr8DcxiqwS1buTe3ZiIkUmcoqHDz1AF1KeQ2S9qg3dz7je7wXdqCVRXxqULgY1GPpItcshPi1pWSuS4/b/ToG7uoOM32PAQfkDwugJ4bwZP+rZgQrFUli/P0wTZ9JXaIWbHMBMEqkhLhJ+wtXWIndEOUGkk325fqdxc0vJyr3vX+USRMDUB6G2z8lhQG1A+3QFnQLbVZueG1UQFMvZoL4uaFTHc2KxX+dK2yaSJO7YlTfpUO0jBy8IHQxWhJ2Q3uLbHk2wJKawfO3wEUjloF4kYolNF8xA1cHwhgM+kVuA2hA4omaUYwU1s9qZnqhO2lSoaTEOBKfxsd5FrkEtZsuaEzCQvnokELFb8Ajmh+tO1h88AwM0mWWyRSRnfYfWkRYq3IY9D8Jea4Lyhzn7Lg/LjABFtJQOTRjK9LHKsY8hrbJkK7l0ADWuwPt8D4v7D0K+bm4VNkPUiGab4BYQ4ZA5FbSUmFZd0xfLACZRPBw4UqUIJCRVmv72Yw7aNmugXYsQ7AlxrVzYqvoesvLEt53huKoRfBJlM1iCAjFuwY9lN/n6XdmRvZGixnwcz8HAMxMaqSx7AGKqzE93XagCEkYeb9ey5Iqe4mhFEqwdQqcKSXQnMNlwSy0zDFFlQzQNGQbtHotJKdUM3CQPJytygL5Z4OCKqqlHX8rrZVai3Vim1Aj1KlvhhfG/fGghZNFeyXgKSsCf2bhEQ1+SQLAqyR5BdU7J001A+b3FSMqqM5p2f+h2vUnrGRn2YeKUyCAXv55wNPZ/eaCVz5jtYwmrZUr87DfCBt4PMl0LEH+54haSI2hbeVIuQP1rjljoVAfPw21Ok6I2wsMhza3kytqZpuDeUe+XyLYPi7i1EIBON05
 zBHVQa7b
 iv4hXvJUo4njOSDkB7CMEONlzElNUDSIq0WMkqIXinXGO/jWB5eTcdzu23KiQVrMBY/DL/42ie1Z/f9ypNlrv+8cVm69bPyOzQRmtLDHqfCgLuuoPwhxvXxUEb00oZATcV1p+Weim1qezIycIeIdBGvFPS/wg3Igg/+DbQvtUzHHUPBJQbpuWfCCCdu3zVBEuu9Bo7Fg9LXuO1mZh80A1pfHM5DHLG2O4oq4VO5oQ68dd6XXpUy/LsSda6nsKlyakr8pLO0mjKrZWw11JM6bXnUPXPUGku599i5tlFsyduQ4mRWrNFNNxrxwnRafQdyEmEn1NgSDlImUWa/v0sk4Zhs5Xep+k8dO+C94oes53xJQtq9bSYR30wth1kCfNuTyqdss+QYl/L8rcsLBjaKANRLnXS39LWlB9pl4FTFc6n/yViw9y+oA3nEX/tOQpkERmVkcvm0/U9wLpCnJYydEvC3d/+pBsE/bERbE2pH+2HNelg5nNkI63FmfjyZm5OHwJf74gsyAwWSKCyUlRA2v3KFve/SKkwaWbHKGHp8MG3gcGHlg/Fy/OL3LtbaTfpHPYQjZswBrJft9ZeJKHhdC6YjyGRjIXRdsO1o+vYUKqFYwUMj3C+ENFse9VJQ8KWFNKqp1ONGV8a09vek499c8vdM2gJrVUIKX63DS1roiaSzlK8VRr7kcSpAXqsvXJrGOEbevhx5domnVvStdDJ9xaXIGcPOjVOEgJ5Md2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For pmd_trans_huge() and pmd_is_migration_entry(), we does following
before return the pmd entry:

  * re-validate pmd entry
  * check PVMW_MIGRATION
  * check_pmd()
  * handle on pte level if split under us

But for device-private pmd, we just return after pmd_lock(). This may
lead to inproper situation.

This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
support device-private entries") by following the same pattern as
pmd_trans_huge() and pmd_is_migration_entry().

Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: <stable@vger.kernel.org>
---
 mm/page_vma_mapped.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index a4d52fdb3056..5d337ea43019 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -269,21 +269,33 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
+			softleaf_t entry = softleaf_from_pmd(pmde);
 
 			if (softleaf_is_device_private(entry)) {
 				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-				return true;
-			}
-
-			if ((pvmw->flags & PVMW_SYNC) &&
-			    thp_vma_suitable_order(vma, pvmw->address,
-						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR))
-				sync_with_folio_pmd_zap(mm, pvmw->pmd);
+				entry = softleaf_from_pmd(*pvmw->pmd);
+
+				if (softleaf_is_device_private(entry)) {
+					if (pvmw->flags & PVMW_MIGRATION)
+						return not_found(pvmw);
+					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+						return not_found(pvmw);
+					return true;
+				}
 
-			step_forward(pvmw, PMD_SIZE);
-			continue;
+				/* THP pmd was split under us: handle on pte level */
+				spin_unlock(pvmw->ptl);
+				pvmw->ptl = NULL;
+			} else {
+				if ((pvmw->flags & PVMW_SYNC) &&
+				    thp_vma_suitable_order(vma, pvmw->address,
+							   PMD_ORDER) &&
+				    (pvmw->nr_pages >= HPAGE_PMD_NR))
+					sync_with_folio_pmd_zap(mm, pvmw->pmd);
+
+				step_forward(pvmw, PMD_SIZE);
+				continue;
+			}
 		}
 		if (!map_pte(pvmw, &pmde, &ptl)) {
 			if (!pvmw->pte)
-- 
2.34.1



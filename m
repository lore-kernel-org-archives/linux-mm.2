Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3F3CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 04:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1440C8E000A; Wed,  8 Oct 2025 00:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4E48E0002; Wed,  8 Oct 2025 00:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26208E000A; Wed,  8 Oct 2025 00:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDEFF8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:40:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D597585C2
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:40:11 +0000 (UTC)
X-FDA: 83973695022.26.F169386
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 94F994000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:40:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf27.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759898409; a=rsa-sha256;
	cv=none;
	b=4LnKMhxR18pQ9tf0jH+0QiiFSyUEt283EXLWH+5YgiIbQf3t7YXMZMtAUJHXn2qsutjwEP
	NEKydhxCakBo0KyJn0hsTynUbvIgsTD6hNDxt/1UaTVvzGnmzToxso08azlOUsiqaVsM3i
	zsyTn/JXAKQJGhnhKSp/PKQWLylL1pE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf27.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759898409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O1vidbU4o/R9Ye6BnVqcmKpIlA05IhBIAjHHRerQXS0=;
	b=J3GCTV+CL8icxDaqgegtF2i3gf4R2eKxSlz+L74vGtGKfq0UR1mtBVGu+aVo41iy43M1nL
	AvDVnYJXsgceNJbKq/IzKXyzJwhTaFOZxDyw6yMg7pvuMTPjNNGryFUA//9aKxL/4pSs5z
	SLFDy/poxMRawfH8SC7OholRz0vkHT4=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ee12807d97so6032329f8f.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 21:40:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759898408; x=1760503208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O1vidbU4o/R9Ye6BnVqcmKpIlA05IhBIAjHHRerQXS0=;
        b=vEVNsxAupoNLueLIJyQygDe1phwWc/vZjtsgHMq3Wd5T+3UNo45H4oK9+dq78Nb599
         Em++7hbON8RDeff0fbvcAfUVlcU9h1f2AX7apBPGgDjTGBvwjjYA1YfvIH3oaxKFv3h9
         puArts7OUo2Wcf3DRJtNTLKJr8DhZ6sNgvsZ5s1N5ZgO2zfCRaegR8As2cUAW1LtehvY
         nbd4K+itW0LmyE04cWFxxQVTFP7NNRC5zUcrqPgomPNBHGChRON5X52+Z2jKN67DbwEM
         cbgfZY+odvpCRX+T2ZYUTiyEZSzqaK85I6im1YUIOT9rbZYtuLbgpjAMOh0NG1ABsHqB
         7nmw==
X-Forwarded-Encrypted: i=1; AJvYcCXb2doqn0gBnfxQvchdx9P4/1ChXw+ROBDpLFjrAU920ObahUjOf8PCC/wDMONcbLIN0C9syCasXg==@kvack.org
X-Gm-Message-State: AOJu0Yy5PE+sglHc5YXQwiCrDA0CBG+rdSVJKQN2o66RPIWYfKNNymeH
	r8j3nxVTKUGfOIbfPSpsyJxYYtwaIHxBVOKGzcVA8hfAXiko1L3boSJX
X-Gm-Gg: ASbGncus4Qikt6llkEjJYXk7i231V5E2p2aUeZn2An89IX4TFQUOhT9JD4LL8FXoKkk
	atj6V0y8HPtwEyyqJ+kcpjwOOYS3xfxUHaby992+JhkAXGKgVlYdAUjPKDQwRGh6wbX0z3QCbTj
	+xgCopbgRiFPePGxmM5/dtOznG1MQLNB9H0Bd/YtVXnhLUyKmFabHe9B43c+HgRoH36eIDAHjYN
	ecWJJVjk/tYhCFB/bBaeQ/vxwi7cHjUrlCmgzQreV7ChRQZB0n4ZAj0nJQiItx9aY1Idyf//wyx
	7Ti+Nu5WSlNjUkefhzGQx4tCBRHD8surbU/dS6yBB38qf5KbH25CdsNlLGozo3fX0eiCKolZ5Py
	KQysr6aQChxu+g5mHA0VjnEEoxUfJxYAW/sImlsI=
X-Google-Smtp-Source: AGHT+IHOpwHZ85+agtOAF2qCT7IEMETz9GhbzRlWnNeqadDo/gCzv+K2+p7rO5lMYvUpSyxh4Ub+DQ==
X-Received: by 2002:a05:6000:2890:b0:3ea:f4a1:f063 with SMTP id ffacd0b85a97d-4267b3394cdmr964670f8f.55.1759898408068;
        Tue, 07 Oct 2025 21:40:08 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::30b2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c49sm28159164f8f.3.2025.10.07.21.40.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 21:40:07 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v3 1/3] mm/khugepaged: optimize PTE scanning with if-else-if-else-if chain
Date: Wed,  8 Oct 2025 12:37:46 +0800
Message-ID: <20251008043748.45554-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251008043748.45554-1-lance.yang@linux.dev>
References: <20251008043748.45554-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 94F994000A
X-Stat-Signature: 54w8crq15uiopd1c5dexdrg57kf5dxoz
X-HE-Tag: 1759898409-343490
X-HE-Meta: U2FsdGVkX1+vLT9TU4BdnrJNhZdg/FNymyneVF/iSw18y2KorAMSRJ3dcm0F8H5lmFzJjQ826PnDkh+QcVfwf89tXePaeTtKUn8NNM2glDy4UKADSpBnF1rVx1/+5v4drhKxh94nu12mDvGISRRii4NfuMJmGhhh7PLfkoojyJr7DScQwi3lU0agPV28RafEgc5SlFlp4kwcb1/ZSCNOiY9RpxepmvFihUWaU05AEBh9D3H1TnzGCi9sLxwXssVjO0BRSBNmpT1u1ASsO6yX4NdTq1mh1ldNoU4UkXscNX7IyMDa4diV3DYenhEgqxqY/ZSAuMsskYNXq9SbbMFdYDYtuZLbBYZ7T3lpQ+r6A5+R+fXNSoYcFQn/csUyOu6ri9sZgsbvGsPiRu4NEr3Bms09q5kn5L478o8R48B/IqkwIBZRDF2oHAoILt5vLd5UwphIotq6oEpD9DpbaAloHy/gJBAne08rFzf2GRGkX9a5u0ObT7ytD/XR/Ir461i/eURntZfgs3TTueX0AmT7acyz2m1i7TnUy4NGobxngMPueiUtMJmGXHTSfFVYun0Yv2eEr/NcGuE5P+WxAR6HFu+pL6hGsvRBALhHnUZTIxF5rKf8gnMRUBWoTWYFbZE6Yb8tcvdc9YBN4jWmxDllE3oMs6TO9BkWC0MDkMe7W3L82GmPNsPnffH5glw8vkS4rXcprvaqeAn1QTprnt7LBUosWrJ7utotUNL/AOIYtg2QMd30uoXUwH2zS7F3OdibrSTcIxiPuXjILIcwY8EJFehakoNeUZeB8JfD87j795jYgT5vOSWteAhzeDIh/Zd/T5/9UZ+jivLpN+lVS/u8zhVj4zqgMa0fc8uqxlm+kfnyM8JPFBHLT2AQyBGWR78x9+sSxd3xm7VUcxIxajGcho1969tvcS4JMfwBT69KYagtE1AWnQyIBgDxXjZZCHuzKk7SmaL8lPTxkTo5Fpv
 yV7aB5dO
 W/PH92Jnm2nymcqmfTdetXxPUl9/ERNzW6BwlrHGxvIxfrAZ2UVxR7OIK+XVWCuHhjNg6F2jK1x9GsdgckJXPeoqpf5Z9pgFN9vFTXL7ddMdVjDMx7IDZ8Ty8M0i9GZmONzZ3sX2xHkfqT+bchhEJqiDDfPeqUFtgA+2ZGw3Oa4MfSx0wkq1jIo/eZuSluGVvIJZvVXMivdphscCWy7WYiEjDiGSxPMAggBty3FaqNmS5Fr5GhRTr+eYcHbo4FEmMK/q3Ucp/nGgRQUeHwarNw37wl62/ZyXB2TeeLmt9LT9GYGwAtto3YOxeNbvaeEsPPE/jYu3q6gePHjuLKYuRmEAJZEWm0j/QYkafhr4K6v3/YPMcUq3mivcu7Fbqz92NPfic2z82yXo+mXawtTBylpA5p5i/HAEq9wv8klxl5D74mT0CBeEzfE0Y0MljLj1nak/1KWPMI+ViDkEwS5f4ZO1sZP3bKbjWXx8ownXjGX9dYNB5E/7RBB8X6Q4ugq7YUYQotFvIRi79OLAk9ShzprvNk/CnOLE6i03JS7LCn2kpZDu5XgyBtZmkxi6NKeBQkzXlAJpwhF7wBIgAZ0d/P1bLjHGnekQ4Q8b0aFls65zZmQU1iR6N2+SaUoibmKoAvAYXvefH4lHiYYvOr0XTz5LR/ABIpcA7xH7xCzn785FTAGNFPOQvsgQkzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

As pointed out by Dev, the PTE checks for disjoint conditions in the
scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
and pte_uffd_wp are mutually exclusive.

This patch refactors the loops in both __collapse_huge_page_isolate() and
hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
instead of separate if blocks. While at it, the redundant pte_present()
check before is_zero_pfn() is also removed.

Also, this is a preparatory step to make it easier to merge the
almost-duplicated scanning logic in these two functions, as suggested
by David.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index bec3e268dc76..e3e27223137a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -548,8 +548,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || (pte_present(pteval) &&
-				is_zero_pfn(pte_pfn(pteval)))) {
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
@@ -560,12 +559,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out;
 			}
-		}
-		if (!pte_present(pteval)) {
+		} else if (!pte_present(pteval)) {
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
-		}
-		if (pte_uffd_wp(pteval)) {
+		} else if (pte_uffd_wp(pteval)) {
 			result = SCAN_PTE_UFFD_WP;
 			goto out;
 		}
@@ -1321,8 +1318,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				goto out_unmap;
 			}
-		}
-		if (pte_uffd_wp(pteval)) {
+		} else if (pte_uffd_wp(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
 			 * PTEs are armed with uffd write protection.
-- 
2.49.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F8DD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 05:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5876B009D; Mon, 29 Dec 2025 00:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0FB6B009E; Mon, 29 Dec 2025 00:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3266B009F; Mon, 29 Dec 2025 00:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A857D6B009D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:52:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67088C356F
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:33 +0000 (UTC)
X-FDA: 84271438986.20.3480559
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 740A44000C
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bq0ozPaN;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766987551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0TAcRTppXCDnIWmkxS69nQ13SWq+RnVhYEMaAViPXU=;
	b=BaRnehWtyV9SChnXBugpiaYQJ+eYMWaM4qede/jPh1RVqu9k9mdvdF9MOrdL3nK96DL0GB
	2NyJb7t2dmFYCiC4h5Uff+fvxwkNt1c5osNK5BPZ/kdTVZZQzrR/mo6d/QeCPYXrDNGIZg
	l58P+rSlFcyaoP1P4TIaEpq854osrfA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bq0ozPaN;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766987551; a=rsa-sha256;
	cv=none;
	b=1BpYuh4+K3bUcaU6Zgef6v3aneD9kdol9F2c5xGfRjr1s8Sl6Ur4osgaX7VyVpggxsG3TU
	MPKE6syChHueU9VWWraKlzjawv77W6DkbQEWKViXMvrRU9g0JgmO3XrYTa1EUKYNJRsNak
	eRvjfsngwrLkOHIzKWObVtQc6HB5lQQ=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34c1d84781bso10048577a91.2
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766987550; x=1767592350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p0TAcRTppXCDnIWmkxS69nQ13SWq+RnVhYEMaAViPXU=;
        b=bq0ozPaNR350ewwfxVKCOYilB5LpDh7JMmuBPgRlINdXhrqXWQLURZnZGtrWir3+hO
         SKqpeTmK+DxS5gQQIsYMBgIa9YcLSZu4t3O5uR5sVsCokOvVtQmKG2nPXeaZCIxIUcjQ
         EqoF2xVYhEnLHdikEzHuWEiIs6wmY1JrvRwuBBOjR+8+HFFzZ6YHf0MnERl4fl6HlUlL
         UA9UwXiQj+EaTBmk/Pl9+3m0BvOlEwT3MlTc81cVPLWmu1g6ZH5f8HaFwwPZ917FnMNA
         4fVmOku6HqwCT4ysKxYVezkUtxQB4raIG1+4n0gBUbNXBeD6pSCWahu2mdZI4h4kurFD
         sPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766987550; x=1767592350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p0TAcRTppXCDnIWmkxS69nQ13SWq+RnVhYEMaAViPXU=;
        b=EkBa141kHCOPtvYhcrkH9cbdrj0riff5bOu8ji1buq39aDu92XrN5DX4PuyYLZ8QhN
         k09sqS/SSOWbcZJnHTWfA9XUgAgDYls29P0m3HyHkhnuIV3NVIGaNgCYQB80eoTqaEBX
         I76id1LzuELJkGIv2xXxgRh1gaEA/DQeKxpeHcffVk7oby1FlZJ1pkxrEy/tGVplprjq
         WXRVzXp9/z0Xk1RhOeuIi2nGc8D0uOqUPG5fZfutnlYELbN4K2LY/d3BEjsoH3WLiGZP
         /0BcJ6c2VFGFXqxS/GBvh4xacSoaVl4DLXUdUqC7AJsCQGTpRXqsHbY1W4X1wVdALNaS
         badw==
X-Forwarded-Encrypted: i=1; AJvYcCWxA4eubA8rIJ4xi97qBuT3Qqc7iLvx91vgdtJh6ZASL1qrnvvoK2QdOJJbDQSoe6hrBdToQkbpkg==@kvack.org
X-Gm-Message-State: AOJu0YxiH/DGMcBe81FvMWQ/hN+uREUvO9rqy6krwcD2xAH2FArgh8oG
	bXziUSI1e+X1t4pd53Wfqj08K3uMB+/SYde/JRYhNFEtadsUmtsZYxM5
X-Gm-Gg: AY/fxX7E4KOzhAZ4bJimy8JVddOpTYVroWxannpq9B0g8fQtAGOyDpQcsWojOra33jq
	Zz0XPeUW8Mo7bQqHDqOUA1QprxRPyiu2+BTRiT4m+CofMwA5w+wqBA7OCOrYGq9mISrg0CznUH2
	t7v1g+0BAVPFWdPdn/74OmvKO+fc6Vd9VJfdFxvDzRZdH7T7sGtLFbGlJpPlOKDuOvr0vNOS+UM
	11HmmtEXoO0qM9eBlPEYVGV94+LU83I5v5+mI6XLlwfo4fN+KlqC+RnOgzS/ey2HhYMqfABu7Lk
	A94C6HcVvhbmPk9NLDWyPb/EPhvUsPuiqZtIImtabWtlVCTkVhmCenxhC3yoNmRCwoTtHLW7Hy/
	Cj38TPHidCO2tQEd5d1kH5I25jsvWHXQN/A4wXhpit7NmTne9TVRgT7YrZJeoe3ZWQB2Ud8sNsl
	+KtJGtO0ckrN59WDOs3dZNUrvdhE3IbEa1YHCDPx8=
X-Google-Smtp-Source: AGHT+IFN+5k0M6/l/01VR9YiTbqghhmhkxo3d/mqneg0X5+Q2LxFb2X5MQf8t67NEYAVtiiwDIIDfA==
X-Received: by 2002:a17:90b:582c:b0:340:5c27:a096 with SMTP id 98e67ed59e1d1-34e92113697mr26001072a91.6.1766987550278;
        Sun, 28 Dec 2025 21:52:30 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e920c9a7csm26164019a91.0.2025.12.28.21.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 21:52:28 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
Date: Mon, 29 Dec 2025 13:51:51 +0800
Message-ID: <20251229055151.54887-5-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251229055151.54887-1-yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bxg1ro3mng5id6q68jqoj7qf9jep3r3t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 740A44000C
X-HE-Tag: 1766987551-380118
X-HE-Meta: U2FsdGVkX19Q3vtvMyImOxQ3spg5fTI1E1wniFh42pjFsJKGjQEB6Ys8y/RAihT7N5390qUsIVjDfGh33W1yF3Ix/UP6hNGU3KYWyPnE8n1IU1ILgSmwO4BYrJVteAjbF4N2vHj1ruYEGe0/ac2CvsmPffuD92SWPeKg7mucSnyHzKxqQkLgdbNOQVEI/H6ZldhCkfCKKfNXU0/DE3eIHFDDCc/cah/h9FnYugMylRLRvM6Yt7Oac0bUO08jTj6jj+1LSwSISY2fhcRYo9j4QMwHX0sw/VzW3BCT90EY49APqlgNblXDM6wA/iIL5jCmU7sasm39Fg1OxtmmWn0FBrZ/qyUd0a0MqD02vo5Q0zAmDUXlJ73KrJXcplQremd/1M45p5QCBLsnw8V7qdevTP4pPAVtkOpoNw9XQtScyBNr4U/wqSM3qEY/ILnMRTZq7ilvDjlnwlJBBq/jXjas131Azj4S2rMLUdwbwpe6SqaM4KM6EDUUSTlbhgbnxC64HJT0/R77hKLCIGshs/hiK//5UrF3yJn8gT54MIiiv3ubMYQ13Blbsohv92VvXyJSHFzmHawY1XQMQwNrqud7A3xZrczCFtIA2LrYtLHVeNvW1WcWNWXEfGtI50TkzW4iUV1LkfF01Rju7P052CtX3JBYUfXf/aNKefHY5oHA+ocONM56vLyGASwBJ4ySFahtngMKh7/nxuZC8vC2t1Qshvwn40MF6BYZgoCdAA6Y33wpgAwezf68gNA1SU13ucCh774SI3kznLGYeaftMNj8SYiHJAuP0YwEI8MbibXpOIB23/s4tCovkrmGEJOOs/+GvI7pXqpmJYZbRsecLvKrBF4Sp/yIioBl4puAkRxo1tLwoUljUX5byoKlEeAJX64YvYOkWEctJ97IN95PR83+B2Hi1kjAu9bTHm0FAaSWyjbfR3p8xekYH5s3jTaf8bkHS01kCBGhIMoNVOc+N2M
 DBuCJG3Z
 o9HyYPCzLtChZ6NQ1gOJb86QCFUS9cqPFwMcR3uruBrgA76g3VwXAjL5LrglcZ3vMQroXou2RJikHzWt1RGSRZl6AUNzgorJe4dX6qsbVoPOkmTVJEDg2GN5eWMATu20Dz7NQt7hd3bUUCZQ7aMbE3PFhSXwA4Er52aENV8aoFiQ2PD6UqZ1UTC18rvgeBaohgpnuEIvTgAJMxmjM6K4PTVpsBxKgQeQkB+I4Gl9Uoul2ogzseirWBTnp9KfW+8xMVv0A654UccEc0n0XRi2d7ULaa5wcyNjeoABf0vqqtm+3zonikUrZyc6Xsq1dgABJ+PNbw3jlzi299a4HfBJgILc2oITbXmJnUSNaTr5SETRMuSJh5Qs2aw88pxGt6RKFz5kzovceo1Ttd2HguQTzrUaXVdj235Ir2TXbB0PV4Z2PYZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
reduce redundant operation.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2b3685b195f5..72be87ef384b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2439,6 +2439,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 
 		cond_resched();
 		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+			vma = NULL;
 			progress++;
 			break;
 		}
@@ -2459,8 +2460,10 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+				vma = NULL;
 				goto breakouterloop;
+			}
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
@@ -2477,8 +2480,10 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
-					if (hpage_collapse_test_exit_or_disable(mm))
+					if (hpage_collapse_test_exit_or_disable(mm)) {
+						vma = NULL;
 						goto breakouterloop;
+					}
 					*result = collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
 					if (*result == SCAN_PMD_MAPPED)
-- 
2.51.0



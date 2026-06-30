Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B59C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B676B00F8; Tue, 30 Jun 2026 11:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BF96B00FB; Tue, 30 Jun 2026 11:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8ABF6B00FC; Tue, 30 Jun 2026 11:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4D146B00F8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:26:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34346140523
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:26:29 +0000 (UTC)
X-FDA: 84936955698.02.DAE3F20
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8050240003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:26:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R7JKKPOY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782833187;
	b=gzlvbBLniLrZxigkxlHiYHR9mM9uz/cq5WDaTSu/fu+Vcc0usIVB4amPpWN948dAsSLpdt
	NlVDMXF+i74NcmTbPjwyl1LAFTa1mzBuQMIy5zahsrPReDndaUfTva4Gi1j/6QvAGrfXJ9
	9/3iFdq8ps962tWz1KOLdOgqrrt5EtU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782833187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a9OMsgmFwx4twtX8wuXkotNjpYBSB2q91Hio3qUcaSo=;
	b=r70LNmmbVPxMzR3fiT5sQ3anHRKOyeLSqJk514xjMPI3ARw1uY3CGoe38SJFkyio5r9J/y
	pISpoWMUgc5CkR+o+Djzw4AGOKHDwri9+yuh2fPitlzL3+vfo4A9MDLeHfjhpF/G508Zoc
	SmGWxgLF6YjEI77OAXoc79zni09NLAA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R7JKKPOY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-39acf7c6d59so39286361fa.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782833186; x=1783437986; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a9OMsgmFwx4twtX8wuXkotNjpYBSB2q91Hio3qUcaSo=;
        b=R7JKKPOY8jX7XmQMphJxyPtWDzPz27EE7eJEkOtQfvTU4wCbGHLf371BoeqrfY3z8o
         fWClmzDIOAfyrVgcEjCzlvPTSk29/Lexr8Uoo/3CbyMHwPlNSfj4get6h9yuWR1knZRS
         cWsN338+hhVrvF1oz1Q/EXA2rUn8/wXR+1BxYlKEsWXiUz1ipF2sh1e2PH+95c1d7RlB
         5O7rz2FmAwHrmnJ143ldRrmz5JqZ+CwvXB1ZTvhsMIPuX8e7ETNivy6+0wwPnE60eWpl
         qtxdUYmjPo1/PRVGfRxjyUDyix6roq+hH5YWatS+f807i4LDKMk69IqOSZPY8RAIxBkz
         eyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782833186; x=1783437986;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9OMsgmFwx4twtX8wuXkotNjpYBSB2q91Hio3qUcaSo=;
        b=i8pIB0O/H02wSD4j2iZCwhDhkwCxtI+U4HjTX1M39rC9sJ3ZxqxFbFhUPvOcfa8I2a
         8fBHXEAFtNtxzGFJAMKDbF1O581XVw/UfT3jWUSx6pcTFmmSC1xlU4cvjkooUfw/xPGF
         aVzvT+LBZIS5Ta2aT2u6jI62zxHux3EqN+FCxm29qWs5lNV3rfsTONr4/SF21nJiCRid
         CvuV+b0DdpeKK/1uNJuXSvihszmjTB1dCTGtXTGoM1uB8S6NWFD3As/DTA7ZjV9hT5sQ
         J8vwo3oaPr83bDsktYqGYoDPkP47GAfGxhXedU6vF8DI7vXg0st7PskNSaZxnmAAkhMi
         AdUg==
X-Forwarded-Encrypted: i=1; AHgh+RqN7hzjRMrCpnzIOeMgjWd9jwh/B2tcAO24TyEBBEQggea+bytakuccS48mI6XueS6AAAm9T8dwrg==@kvack.org
X-Gm-Message-State: AOJu0Ywzpv59cEqG/zZyrCNtP8yRa8HSTIedrhFrX2td8KInO9EFIROl
	jxVnzDeniVN4wFsQ8SCxzqfEjYLZ8nTn1HugSdd0OnBUTKVBa/CCslaU
X-Gm-Gg: AfdE7ckiNxOENLd0TRYXip9vaKReD2MfI3dzGg+fbd76/D/dFALOYj3ekyrXwNa5mRM
	w56qg0qCjjaraijVq69BkOsyS/6t7jrjZvCcseRgofiaqhB3vZxpbRnEUu+sUm4VnMatASmqBLB
	Gw5sqU5eFr90pAu1a1KxnXXxbGfg6WFuDQrnR0v3psvuwuaYufSOx1ZwPu6arHMVgpx4sAmsBOe
	4otboFbq/HiomXeLAGc2UZl/fyiV51chbJiRM1e9lf7d3efblI6HiZfznIzXgh6JAz0480CFhBe
	yMWbSJZrM/YRLBNRztW4JCsJyV3u2vyPMTQ3tFo9pIHJ8H18N5/W0SzQnu8X+rpPEpOX5dTqvLI
	m5ru/ScqrwlbkwJNFWUpZTkLTm92UEPme8NNLszjBlFrFTsTTstn3VnCckLciOwNwsOG4rv1BCj
	IvmCffJAG1r0BwCoStOFHq+5EmQAXsz1HjcWxRJBQs91spdy9jS5oHrfos4J1YaFWwbyxR6ekgz
	Pzkiz8=
X-Received: by 2002:a05:6512:618:10b0:5ae:a9d1:2854 with SMTP id 2adb3069b0e04-5aec10c76acmr294395e87.44.1782833185330;
        Tue, 30 Jun 2026 08:26:25 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aebe333664sm667745e87.6.2026.06.30.08.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:26:24 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH] mm/damon/vaddr: check address space stability before VMA traversal
Date: Tue, 30 Jun 2026 18:25:58 +0300
Message-ID: <20260630152558.24063-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8050240003
X-Rspam-User: 
X-Stat-Signature: 3xiqffz18afwnf9w4ewfm1c99cif1bdt
X-HE-Tag: 1782833187-22189
X-HE-Meta: U2FsdGVkX1+AOBB9jVGD/sjaCEx1fpx7n/lMTmjHb1DhmwyLUl4+8CFk454KMssbG/84Qcjt3J6KRf4+1X4Sp6+qnOqOJEDAQDnV4NMpr7ED9B4h+Krl7g1W3cVyO9ktwf3yArNmBvQZFMRDtqo9OeXVX11wCGTG+eEyLTgZNvng8PKAIwgoikpWAFRhnMftRxRNoZ7XFtCh4C3xhVyGHfNoaaJwgmQhxeIrWhC+GHApCVFDJOneKL6lPbygzlhzAbPONzNyi3ieiTGcrCQu1GCs2F8NYcAWekGvZl8Dtm63lJGtrmEfyOFpvksMpubW3HOCauT6eUcMariQwuIylsQNCwl7bzdtD0DbGC2vMeSuhLQ2EWwtCd7+bfdJgMUNSVooxLJvCuFi/FtLfOSwVvhCnycG9WFfIvimRBS2PnYw+T88mgAjAT80NZu3WbxObiDNyKSEsKb59PIlCxAGKrwnzkKiylguU67PghvR2UUIbA8T/qC2B0G4q+k8S0iC2JyVliHOugKUixP7NwkNYy+j6x70EJM4E2/t9A+128mCZ5NtMWVXkpxE7lL9WL6ii3/7gUwi0j3Xnm2KDQeeaW6P+QULOKAlWrFt0VfM9cjF/RY5ik2eL5gFW/Je/NJTBtHJKQS4FIgo+hjN+Exsa6IXuT1ToGAOCRaNXXM+MHAuMaMI9yYLVkfd976i1HU2mB0PQXGBW6AKrpT9W5Dpd/E7+pEihwRUKbbWZ5mEPoyRGBkZtVXsKmMTfUTO5hqoMC5rLcXavm0HWtqSOJbm/Hk0+EHoIn69u3bGebh6igW+5LGoPYG68Yw5Qy3vmXSZzMEz1u4UOm+sKIV1DvMw+7lszkmgDwaLIVWMJPrG3sB+lPRaHwPEVxIeNkQoCQpCRmxRBRMVaQ2WK4U2bE3JH7Afsn5EsPCfOlNF2o/u+VDJcrq+Om6mWvYxBj2P+PPX0GHit+pUob6s7RXZvAs
 sgdaExgb
 OtqGS0fxeFtUNA2XPNKaM4ly0bv4nulLnKTANbtJxx3V6OwSAYgPVTWDFFi/xNZPJpZcWGqISjipmo52tFZjfyf1yoPXHVEOGkxbLq9ScNxJwhhcUmOkAS789WKWZVZg75fjVNhdBifxrS4TKV2d7QOMwoS8dSMTW46faYgmEM4IqtlnIYFqAAl2iGJOVuRfuvz9Ni+pvCyEcscIaP7l0klgsNGyvhbC+g/JmgfoVRSJ8qzBySE3pt0uYICIFO231viw+6sbodCSHaYHknR3c/SyeHVqRvkk2Hvs9rvOR1EDz+pmyGkgLOMt5A+Y7rHyTV9i0ydEEDnIhAMqxkfIT04ap78Gbudt4Kbd13hZy7GMIXvETZ9ittLj2gTIUbfcQsDZ6CGrW2Oz7ciuQJTuoeAv0fEIfFdB2IVZtSiqbQgYqz3W1h5CioAExtPalcOaolJhyBz8TyTS4Ol/inmoxZxYpi+RMrCYClbM4FBinRQDtAniSD3PLq6OzX9xyVMGXWyqj5faxlkGRtKt2Y3bDFPKuT9T4ZFWEVwwQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In __damon_va_three_regions(), the VMA tree is traversed without
checking if the address space is stable. If the OOM reaper runs
concurrently, it may mark the mm as MMF_UNSTABLE and leave empty
markers in the maple tree.
Add a check_stable_address_space(mm) call before iterating over
the VMAs to avoid potential NULL pointer dereferences.

Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 mm/damon/vaddr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 345b89b5d..e756ac147 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -11,6 +11,7 @@
 #include <linux/hugetlb.h>
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
+#include <linux/oom.h>
 #include <linux/page_idle.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
@@ -84,6 +85,9 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 	 * If this is too slow, it can be optimised to examine the maple
 	 * tree gaps.
 	 */
+	if (!check_stable_address_space(mm))
+		return -EINVAL;
+
 	for_each_vma(vmi, vma) {
 		unsigned long gap;
 
-- 
2.47.3



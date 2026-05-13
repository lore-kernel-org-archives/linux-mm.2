Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746D1CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E198E6B008A; Wed, 13 May 2026 01:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0E06B0092; Wed, 13 May 2026 01:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C466B008A; Wed, 13 May 2026 01:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4A106B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:54:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FC7B1A0743
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:54:41 +0000 (UTC)
X-FDA: 84761332362.19.6FFD2BC
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8BA5940006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:54:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=klVobYbr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778651679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6h70PACfeGxFdas58NKRpLs1f9lUrNEWlfzoFG+VXoo=;
	b=SdtE/SXQApTIfA39877mYMUloxWXgCLcsp+i6Tlc8WWOShLxTzRYaddKHjRrq7NezmjpiL
	WnCtb3my9gDDXu27VUzo6nvt/icYBxF3gkeLRSXnLLOhk5GhIM6y+BevPFCLAopQaWFODm
	c2Guck24tg+3cDe5lFiQ6R4nK8cS3QI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778651679; a=rsa-sha256;
	cv=none;
	b=SAe+CHvvebOSd33zDGqCrUcO0Dx42dEH0RfeFMA48xPF88s4/hgHH0Dh2Z9NU7gh2QgJVM
	P6RrNdlkzR8P9zfxnb3rj4BEm+SgoqpHKRybdExPuslR6UTsyIOK5hAoDEArfW+DwjYS1k
	PDO4oVlic0aA9uiWSaNP9ae0kuWMGlw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=klVobYbr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.193 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2b9ec9443c2so39164255ad.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 22:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778651678; x=1779256478; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6h70PACfeGxFdas58NKRpLs1f9lUrNEWlfzoFG+VXoo=;
        b=klVobYbr4b04IBMIMPOBsB+z7UWDTKZ0r/d4fh7TbrxEY0WiIQmDKiyakl75yDdSU6
         DrFJk4AwLRUKhVxHrgYDZXx5eb3lxvHaIKAoj70FK8bIzX8TVt7Nr/CZpae+8D8DT/Jy
         r8cmfdpck2nqUceStoiNpVAC/QbBFV63RDvbRYwP3ysTdC5jABTFYoqOIFus1VL4UWuf
         c10+w8ISRdiroX9fenKRtJtEzn+DN4VJjNXLlGg5zGGRyv8V8AbTq+QMYHDheQku5mmZ
         2qn2Xgu43M6VRjGf7OukiFrzwLV9SK0qlN+TvvGSzSvmUR8+fK+o+Ger6XSD6qmTs5WX
         WBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778651678; x=1779256478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6h70PACfeGxFdas58NKRpLs1f9lUrNEWlfzoFG+VXoo=;
        b=F5C8mnnxJo301xMhVhtVF+IDGS1WH1KxL22bzdyDU2f/2/yF8IfN3//XZ7Dg3LUVyV
         l8r+qXSQT4Z/8Q0QAuUE0FqpE/aK46+dbrfmFzYdKamk+Yv8MLLpXaggTyaxkteqqg6f
         YKij2L9PvOI9pHw9mPJmLBMEZvh0OB/rspx++pTaehCxkbYG6x2Wl+/gVEme3qPOrSO2
         hkzSEnhmvcLzEpj7wPyyPeF79QWqZYpgVrlNGaSi7WLjs82SVbhMbnQYP+mq2AMDsoK3
         PLefL0YdYdEUJBGBm2kWigkOTMvVpVH/YtXXe+iaeo4apPvmaosfIQVyx2VVeJS3kRTc
         tmFg==
X-Gm-Message-State: AOJu0YzTss54hxCmjrBMOiiM5Ml4iugMfwB3enM2fpWL9XdqEF9iBaq/
	r15JBIhP3sWoQbYzGqSA3YcywF6/sIwV6NqXkFeVl/bzDMMUUFCq9kr7Q/6vpmyWAryQfpju
X-Gm-Gg: Acq92OHC72jN8xNNBV2sSwXy2hiWHGIKAzWn2GU6LVw1lHdpJwAOB/1x9ZqiU2dXYg0
	Wo15CUHSK6OK5Z/LgdBQ2smrUUT10rYrjqmYbVVji/Jd81RoQWNbgWNGZ9SBq96A9f+y9OBq3+i
	brad6l+DrTyReAT8St4rnDVn3/Pl+5tAVmk2GSwTykGOsOD1bn9P3gzou4FrQZWI4lCISAbWt75
	o0Leneh/PiHxlx20fE4XltJTdyYkYmXkRSg5M++/yF4GHzMoaiDp8sePWCOr74ZyQabfUR3JhQA
	Lxpmi7gF+1gpGJPaj5Snv4qBJdCPUon90GO8D8tn49ihVZivmaobSaCnGKWBtYHOjR0wlBOXxrJ
	x7JFk8eVkI7Fdv6ci53Ixm0KcgL2VWd0NjTcuYf0Y+Mfex9XFGuxuoqcFbcMoihjb2Cmde68A2G
	bcjqM3L2/XH7Sut3EfyPdbFGqzu9FljT+2g2JRmA==
X-Received: by 2002:a17:903:1b2c:b0:2b2:4fc1:f653 with SMTP id d9443c01a7336-2bd270fb751mr18218605ad.3.1778651677756;
        Tue, 12 May 2026 22:54:37 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d4050dsm146718735ad.31.2026.05.12.22.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 22:54:37 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
X-Google-Original-From: Wandun Chen <chenwandun@lixiang.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Subject: [PATCH v3] mm/khugepaged: avoid underflow in madvise_collapse for sub-PMD MADV_COLLAPSE
Date: Wed, 13 May 2026 13:54:28 +0800
Message-ID: <20260513055428.1664898-1-chenwandun@lixiang.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BA5940006
X-Rspamd-Server: rspam04
X-Stat-Signature: q5cdczejtejmiyuz1u9r6mybseoc7g4i
X-HE-Tag: 1778651679-501707
X-HE-Meta: U2FsdGVkX1+ozNiIbiRnt3OdeR09mYH5+ejdaYWAjDZUhCoyakypFOxfiSa945/r8sWwbTc04Ak3zG+8PO/jJzlsnChdcpj0Wuy7hcDydK6+TLXC6ZKf+lWWJXwqCDLrjZKUd/Y4N1bOikEUrCDznfm87vvjfhKuse9DSrhPe0gK6Vf+hYXPJfd5izL8Ur9DeNQu0t6iKM5IVr2vOUABjbHirRV9gCLSIC8bADYXfMio/JZxPuupNPSVwpqcCOD6WPg7RMeI+S8sc2NBKFclWTH8raIuhvUfjNpv/77B7buOlpuGAVmBuTFQO7H0M6ueLNy3q1JKezW0gKLUrWFFkOXMlq3yItq+JGrUf8lkFkXjwMq2GlMoWuVFHzLeUfjpKQ2c0vLNacKfTb1sLja+0eq4M10+JvW6vs8VbY56oDXje5vgUO6QMRH5RH3ZnZ++ASajMdAR+rcXw1aaTlA0euATICdIvedhIus3ESQuijxvw1IqAaxCGeNoGHFPv5IfSHHmEf9dPSiPhTTzs8biN4vt+XV0AXK5LHiQzK8EYH2TiBhIsmEPKMKasvGi+B017la4dT5SO7WZXoZZX/wH7Gmjg0v4tM1FfPEgsR8Aus/KtaYgotNTdYi/DjfeuGV1mnWA/7mVIBK9WDd5s7ycRvhySKmPGRpDPo3mUhM/8+PSbQ6PdSRjFSInvQjcwSrjLM0nrLzc/Jgk21ZP1MZe++bC7iaMujRxa5DqX649CkdR3GDg2yN947mGGdDQZjc3ZTqDHNtUb33ro1dvTRyt3i5l0XnEfdugtChT7PsB+ZTsqv4bC4TVHaq67XidxCLuixJjFfyxmSoUIneW8IiC9DuLlaaIEo1hxv+uj3d5ArunulHDvREXZIBnS3t1Nr4gqreXOxNeB3MtgTAw5rNP4HGZZfeGC+lKKUQB710EzPcrjpAixu1Gn08f9mu/sY/UoKWFDTVYEaUgTucl4rv
 UERksW73
 tkhSo1kZti/YwDY6KOS5DWBTvo1nGr8xUSdd8HZ7G5nx6c7ZpylTclS+gK4pUQs1Sf5Sx9t9I7Uf86JOYwVN3DrgT23aZ9PPNl0HwCBPnhXY33TkWSzEmZLHrLBn9fCUbNUgBn8tEmv91ctpKkMR2/XIq4JM0uPUZiFO3U330Vl6Vi/sFhGi64ZHyqPSRF3fi2AiKSw3HndMSUGULUYzOWDa+qfKx0RBu4Bfj1HX9uc2O5iVrouDHVXo13eyDjNhkDWBt43cbOvf+hsZxc1qLiIKp8uim901I91yID2MXQppWX8JuQaw325rRdH1c+OU5coszPzjP438/pZg9Nj5ePI4pFNC6CwSEoqunb01OmPBqXXH3v4GGKbPpuZLpTE0qRG0mzx/XvXoQiDN/W6UISk2FA3GQ1Q8txbB7YRTcqyziAhYA43kwICrDfbELUwjqQpXSgk1NqeB64Ar7aOd6QXCQlG4fV6Voe3d0pvTPDJG9Yy7QmCXQZHHUVRDDZN4A52dtLzGi+33RZkdChNoXLYbHRncKMTAC/HAFBo8BvjZmcos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Wandun <chenwandun@lixiang.com>

madvise_collapse() computes the THP-aligned window:

    hstart = ALIGN(start, HPAGE_PMD_SIZE); 	/* round up */
    hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);	/* round down */

The following case will cause hstart > hend, and result in underflow
in the return statement, avoid it by returning zero early when
hstart > hend. The return value is due to input is valid to madvise(),
and there is nothing to collapse.

    madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);

In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() are
unnecessary when hstart == hend, so skip these operations by
returning early too.

Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
---
v2 --> v3:
- Return 0 when hstart > hend, suggested by David and Lorenzo.

v1 --> v2:
- Rebase and resolve code conflict.
- Return -EINVAL when hstart > hend, suggested by Lorenzo.
- Drop Fixes tag, suggested by David and Lorenzo.
- Updated commit message to be more explicit, suggested by Lorenzo.
---
 mm/khugepaged.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 28a843f30b32..fd7e893c998d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2837,6 +2837,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
+	hstart = ALIGN(start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
+
+	if (hstart >= hend)
+		return 0;
+
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
@@ -2846,9 +2852,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
-
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
 
-- 
2.43.0



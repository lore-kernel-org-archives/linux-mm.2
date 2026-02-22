Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB123C624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C036B009B; Sun, 22 Feb 2026 03:49:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3307F6B009D; Sun, 22 Feb 2026 03:49:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212406B009E; Sun, 22 Feb 2026 03:49:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 092686B009B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADC911C5FD
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:32 +0000 (UTC)
X-FDA: 84471468984.21.AE19842
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A79B1C000B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aEtfa8xJ;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0SIufGPxfCWQh/+gXEhZXOnJbmqG7niTtTuU93HVZQ=;
	b=Rw0m4gppAYkVn7SUMNzScdr/nQlyyaO9qCJZpD1q4qReYEoDJN1whO7Mq7MqmaE5n0mO9P
	GPNTSk8jK8hOIqrXR50O8S4PBUEOth1iL/E3lEkK/nyUlLMZ3PSUg0UcFvKRp7dRANqYVK
	Kkiio9+8uMNMzH6Wr13hNaPHGIyfTGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750171; a=rsa-sha256;
	cv=none;
	b=2A4C09cWhjsaVZQDNnB+UMBo4PYwxeZRa+6U+hzkWgDBdoEnYIbyFaM+N6rdDhaRFnGgRp
	qZ9L9cqSO2Wt46pnHM3Wwwu39SZAuBYvWvAGNUzTPydZEmUT2YbYXWJa3elAqFgfGxSLXD
	6RY/n5BR4gemYLunrxtm/dK0G5K2o2o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aEtfa8xJ;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-503347e8715so43170941cf.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750170; x=1772354970; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0SIufGPxfCWQh/+gXEhZXOnJbmqG7niTtTuU93HVZQ=;
        b=aEtfa8xJpd49UrCgQkai49+5NIt8E5xIkcUMF1Ni0KH9446uuX/9ruSUxP4ta7ElZm
         bRrgQV4IsQQC0wph4eoI5Npqxm+z62yGpWuqoIZjGVJ9lD/tvkD1C43PGtd3o2HaS2b1
         2ZrP/4S5dHAAIE+/QzM1XIdsb/wRtKw93ZSIEYWD6NgT9fLOYjB2qJCtJc0xE25vx9sr
         lDfUGi4z4VgDDi2ygDCxnV3qlsnrOqa+hzZcRWgcMtGRVvU59mfrpG8X6TQ6Juk1zs6P
         9mJS9CpqOpmT5D45YZ5efFvgSfeEZHI38p4UqQ0cLns1o8ZjaZ7P7JDh+P9m2bSWbqQE
         grdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750170; x=1772354970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H0SIufGPxfCWQh/+gXEhZXOnJbmqG7niTtTuU93HVZQ=;
        b=ndpDxgvrK5IfRAQphuhJGv7LS4cjLjseDCSKUcEVQkv136pDSxl5Kn/ae4LllDN6EI
         CCiPTSVL/oeugWmUuyfIyv4hHNGUX4t7gG6mzBxVT5amUzyIgs3ZuljFPNxbBTsdCJf9
         N1KlnXbNkFpFlt+GCboMxsDynmiGBSDDJV+AVMSUWcad7Qp97WYE3lOVztYryUA3orWa
         laZ4YnYeTZVK7TTND1p8Ph7qRyiCzXUpfRV9xZBJHUH463sq6eZBzE0ZslHrHicWt7G1
         401wUd1st/iKUlsRHnmGESlgFYEcag9tpP5V7Zygx2OoB4d9AYuzV9vjk8Pckxj7I41i
         dIRg==
X-Forwarded-Encrypted: i=1; AJvYcCWwQgdi2H5ope0+nXcgrfApEtI2Jo828S2e0791HkjGLydfxzaeHQV6BNFMdvtqv/aXkcuyLgjnrQ==@kvack.org
X-Gm-Message-State: AOJu0YyPDS3kW96mroIUqbAZ+F1V+OM86H7Okym5kGwWjCT0z5d6gGWZ
	eOJHYs8QOFZwurtVcJvhe1PNMOCgM5MVRseG3/c2q0Slq7GDiCJBaCSotdFk8sGLE9o=
X-Gm-Gg: AZuq6aIgiem5doRt2polyHO+J6qSPL49/lfG8Og3uP+nHDpsBXa6qm2Cs4MJBIAlFSk
	E9qpVTeVSKtUnRjed57kKsA3MceREuq5mgSCv4kBY4c8lujWjhwpi450T4NrLkWjjfpnXNEumJ0
	TE6dKBCN+AFKUFJYCMKBsxf4jOiLis0OHPw6k/EJucYFI0Bs2fAZfQEJMGNYDHzXYNdDv0sUDMV
	64xO035B/nkCiBXwg07F/9pFg4C0d91xsC+g4dM8d1Vsb2julKlzR8KSbaPj+nKy2F4h6fcZYf4
	duXJ0ZAWwiVmDYw6t9LG1Y530BmVPiYuIX2exIxGZUHJXZVgzTxYfyKQBP8b4ZFBifeb4JBr3M+
	LJmxn2WyIEjl4GzOshMre/51n9+IpVqujqFVLfqj83rWLDZpk1ho27/jrXee2BMWiT/Nyfn04gd
	lkhwcHP5AWkqZPJGe4aeSs/+1AcSHCv55f/2d5Zsp2maCR2sFA6V5wtDXc08QxEKtje4o940XXt
	88S30162fKse04=
X-Received: by 2002:ac8:7d84:0:b0:506:8a2:b1ca with SMTP id d75a77b69052e-5070bcedb32mr65601961cf.73.1771750170035;
        Sun, 22 Feb 2026 00:49:30 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:29 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 09/27] mm/khugepaged: skip private node folios when trying to collapse.
Date: Sun, 22 Feb 2026 03:48:24 -0500
Message-ID: <20260222084842.1824063-10-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A79B1C000B
X-Stat-Signature: mjmwwctu6z56p646nnyhpajdiabzcrth
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771750170-981812
X-HE-Meta: U2FsdGVkX1/e3xTJhaxNYKFVKdxlJ1ZKjm4ROwbY+KTtKtvTA1HObTZyhyTnuHnwGr/cccdkvS96p8GNRZQSnLeDzT/EQEHuqzoEBBWgzNuqi5TijSRt+TKKtgthFHXoiT3sxU51F81pc6lmgblDoATbiw8rUGZ5yY3FvbkLbDqk1BC9pxEmXW2Tn1wjP59U9VMjqRR3+CJGt/BqZkUvcjQ5ZjTG7VXj40J/UAGHj4hkNeuRNk4HQXT3mCYhAF7tKixGxS8bssA0NNcTaHekWm9Ps0fYhO2yBlfdiiKDXPiiVXm3cy8SPNIx/aHpcFcPl6qLVkJvTgS0zO6WTfmXMbEVK2dgH7fVd/5gAmuv7oFZ0JtHdqX+O1yA3ejhQVP+HAsDFySa48T4bSK2tcqC6rizOuVhvVvl/nUMO8n+hVeZvWKsQkDoRdJ/F/DGRk1Sd7KGrBUAdn35WW3RW7x6hYNHF0bKGGazebpZbCAXUxHH05v2Sgw8fR5FBrvu1caX+2x11Gj7WXagTV41+EFgN2fCJJod0Tj2ByKNhRDBWoyDORzkIbb2ufPH3kpQsa+ZzKzZymxITazQtio6LVzTEPknpSUz4NBv1d15ryPr+lLoEx7Y45rphIzYoVk2T1RINFmQZuU0BKRWvXv3YYyhOTo2THGPUQzpnz6DbwXARAKtvpxQogmfJYbBJOzPW12DkcB/MiDRjnsw96heAaluzcxo+wqRsO0SixG4ij7AFBuj4FHyEhl9OrLPrinvdoydoLbVE0KUs2N2GijHJIGZrTI3Z0YK6HcTDXFqj1Kx4nXYQyWHeXjOD0WBS96hv09oD1WVcOcACf6583FNBQChp83h9IchDF9oyg3tBJC/Zj4CpHfNiBNmb5Q4kioJTQJOb2CkNuygCaIbVye10Jx6EV7FUMnTufIZzSChth+Jjic102Ci+LvoGaTr1KLjAEd2S1jX5fiQ+t9Zv+g1vkt
 GeAiMyA1
 MFZgE/W1r0oWdGb8ql5D+RzuVFNXo4MZDGEXoWJ91aESDcgMF83mJUZNadnGQWsFqEpafGYs86az+yIK8gRYWJ0AkwZz9J21eX4QW7rH86LYbN9M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A collapse operation allocates a new large folio and migrates the
smaller folios into it.  This is an issue for private nodes:

  1. The private node service may not support migration
  2. Collapse may promotes pages from the private node to a local node,
     which may result in an LRU inversion that defeats memory tiering.

Handle this just like zone_device for now.

It may be possible to support this later for some private node services
that report explicit support for collapse (and migration).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/khugepaged.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..36f6bc5da53c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -21,6 +21,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/dax.h>
 #include <linux/ksm.h>
+#include <linux/node_private.h>
 #include <linux/pgalloc.h>
 
 #include <asm/tlb.h>
@@ -571,7 +572,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1323,7 +1324,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
@@ -1575,7 +1576,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		}
 
 		page = vm_normal_page(vma, addr, ptent);
-		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+		if (WARN_ON_ONCE(page && page_is_private_managed(page)))
 			page = NULL;
 		/*
 		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03CEDC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0674B6B00B3; Mon, 20 Jul 2026 05:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0185D6B00B5; Mon, 20 Jul 2026 05:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97956B00B6; Mon, 20 Jul 2026 05:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C082C6B00B3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D8BF1C01A8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:51 +0000 (UTC)
X-FDA: 85008640542.17.575FB7C
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 914D91C0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jHG7jdNJ;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539969;
	b=CmkE+5JFvwUWJmfD7YImrDBlz7L1b1kzpoy7LtdXk/0ChCuS8yZC+KPXh8wpXzsKdcl5vc
	17V8Gz+QQfCaColqO4uCZtQop5ZmCQCo59WyrDBHBP3C02VqgXOZ+Ao3N1EZzOK7xOegqr
	IATNvpx+8VIriHyA+WV+RO7/iZ/yQ7M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jHG7jdNJ;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUQR5bYOFscVYvmZ5A+sUAKgtlLdOTzx7v4nsieLPYo=;
	b=qXreRijmMd0Q4rxhBJ2Bd6ErZkkcDsxsNEp2LqwduNAuzLkEhZdVFARP+8YdSj4PqIKMgU
	hmKvPbKtgznuDYNmg+OcR63HfPEAJA1p5ehPFaordXPb0hBEnc5bdTaYm6Qlda1uEXwodN
	jPD7DE+EcC7DW3KvMT/yn/9aDtSIUkQ=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ceae1ed204so76233695ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539968; x=1785144768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YUQR5bYOFscVYvmZ5A+sUAKgtlLdOTzx7v4nsieLPYo=;
        b=jHG7jdNJNeyJTVGxFBgmCpLfQMEkhr+UlmJZNaet2M/AebsIxUeyXr4U7nTqSVWVfJ
         XseBo5x/grpO4qVrkA8xPNkE9KSN3hQMl+8hyyOTm7Wk4Rj7sjLOJGCjEc6Zhl+ZTtfS
         NgvynK5NtQZzPzZ0Voqu3NCyXIiOh35dDdYIKK53RHvpEaExF+BNKDHyTBt6QIevwXbZ
         7avu3Lflb5SYStzA6QYxBdem+wFS2pyOujV3Twmmj46tKkU9bXQArJHwKy0Ae4kXRR4f
         loQmtgGd7u2ad24DbivFFNXBvCkX+JQWgqNqy7Gaaeq5cU3OMLw5FUSlRYliFFr0BfCV
         mf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539968; x=1785144768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YUQR5bYOFscVYvmZ5A+sUAKgtlLdOTzx7v4nsieLPYo=;
        b=dQ1/h/eZrnCFyOoKYUO/qVLwZmKXDyLLJQAdS0EyN7quGhQcgUo/LWogpZnaDTYllx
         EFmy1EHjFi5E+pb9G3yNjuShib9oqscehk2HZMLgyrE0XsM8QSrrBHzk/d9wsuoXsSXV
         YQfyOeA9Rkqo1oCiXa3g/xkRR0G6s6TkNZEoCu51M6pXdZOlbGirJl7OLz3joBhl7fz3
         d2/mPybGKRe+EqULo3cMGFElJ9Z24ItC5RKvac7xjrzQXrnh2WJfy+rDO4bW56hoDRkO
         Kc9vyIh3ydLdDdmVgKi42z+sFtblsQ2lYa/31iz6zchjyGGo3S+FzZ9ZicazcltsUNWg
         Gu+A==
X-Forwarded-Encrypted: i=1; AHgh+Rr0rzAEGC2MWSr2GDLB0pRDFPe/FDJ9I/Thn+0MC2Qq4AknsizPLi8HdaNXNFiaC8ub6Jgy/8u1jQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6D/EjY+Xr0lkBOSvZwNMK0zfVY6xC0WzkWiMsteHjMClXFaBQ
	RoOxvBumrGglpuVSRbAhsB8sYWn9q1D8SwMFU9fK4bLTocqNeBAgEn5LeAErP3k3wEY=
X-Gm-Gg: AfdE7cljzfP0esfGds6KtqhNbPssw83Ecs9S3GuKABIRgp4ZvpEmNa2COrI6TENpzkQ
	FgewMtHLstzGdaRLnykSmnP9eBDPSdKzU0HZmFyClsk9T0X6jZQE6o03dFRVnO1427y44Foitn9
	F/ekjJCGJNxfcBM3ay3/DOqwfaGZHSK0VYVsSfQjGEOSGunVI/Z0QQAwobRmLERB8h6u2gjKf1n
	bPhLr5RJsM8PPIg1aj3xQmIEYLxQ4RMdITzykApfIFVJeMhZFsCQrccSVm5E1EA76BrObdyBeLI
	Lk5to7UGI66/3xJFlgmoNpOka6KwkbobERwMJbLdErmg4PFz91PLhaR+WYZEy+cptqAz+3vY39p
	POluHapA3om/2O7I33OzofaI5d+ykmYxmsxmw9SPKSL5LPbXuAXLHG8ydwLp1RoATBvfs5P8fvF
	XBhj/U5xi8QRW2Q3/1l62W7oM=
X-Received: by 2002:a17:903:2a8b:b0:2ca:ddbd:a19b with SMTP id d9443c01a7336-2cf34997827mr147433445ad.28.1784539968387;
        Mon, 20 Jul 2026 02:32:48 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:47 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 13/17] mm/sparse: remove section_map_size()
Date: Mon, 20 Jul 2026 17:31:23 +0800
Message-ID: <20260720093127.540540-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 914D91C0003
X-Stat-Signature: wjexe5iugr1yzegru11troqejbwcmrkw
X-HE-Tag: 1784539969-973581
X-HE-Meta: U2FsdGVkX19QwBCHi0z7t+X0Fkv4SddEFgM4TY1XNnstTgzpx9adrhOVUVyvBuC+u0Y9jtXIPf8e05qb8srpXVIijgaAyl2GCmZ4jBtMFsFlVnrYP9EGAH3Mq2q6/2/Ufd2HqLkporAqhWebZfWXSvYBW1i66mklBKz9Ker3kq80BMHEi0R8t/dWbZpzvDfigWhr+EJzCjZiFOvSwA42WyL2PPOuwRKM4SisexJSm9TkmstJIOvyrFUH1DStlr1BrGcMSZkDnS2VsVWxR+UrVWm9kJSu1hC+gqLZOs8PIyw1Nx6lU1vCyAm5iLF1VPPFTb9FeIt5Gh4GyMcuib+eAMD2BRROJQ7D+nkG7VX0R8VuHrGjtBteq7p6mKRjslzN7h0T/K72GWRHMKkhCuYAAaWra+sBwE/ZKKTx43+yqOPMRIYkHegcQY7bKuxuJB9+r0musUorGDX3Jkt13fWV3yGp7O9TEMY/y5LQTZ11Uw84wJGOr2Lg6rdZLQtVl6wcDzdPP3NgnBXZTrLjpFDSfw5Z61bCXkfy6ypI01G9yl98pP4TMTjtO+HPwfGzJzf0ah3qgOcIoEIeTuRPhHcCO7dayoT1ltWk0T/Hj3CFJUXbTYx1/+DcIKmD5aV3BJD5n2BiU5i0ym+nPJRI2Jyjg3ZKI69kJanLPwXZvJwspevKbuEAIXivffcqEzJXHN1Q5jdHWHKonLOO7RTiYcVywMAwEh+fFuz81yPM4QAErA0FCIR/fjnq2EolhRGEzlZdNzsm1yKXEeYL39zDNq2tfKPl3wdd3ucn3De/nA4Ne6ajbY34/aDGzdgv+FO+aFioNPhRP+wVxf6DqiOVefZp8mqbnZNo/kyAZBAmhpW6t8e6UuGTJTuxWCBZlxpxvJky/ZIWrOMXMssd3QS8QxfEtU/rH83i2ZaZeGtvvZ0aGQmGONSlBaAWSkdMeKwDMh6E2WKp0z9G5qUhNDwCilC
 7zp+cYes
 zl/fIpRED2jem4FB18wOfAfwbRRbIXVmyXI7E5rFNMbiAXp8ZrX9e2uPTc4xPJF8lHGGNlv7OZvqg9AyWQ/W8mcJoEMVRM3c/zxstNFwYr1XkUkE/m4LOAOEaUzhYXPlLRjXMLNLjX5E+XPSw3cCOHIkvd5/g+UXyvFQM2uJtYyn3TMiXVPLZJj3jwZZJNg2kcdJeZRokYOLSph4QeKDb79a9K2BiMbBJlU4Fhs41o5E65glffll2/npQ6RN6+JkQ5+vJvwxkLl8++lRhlyBvlC2ge6OfdniAhY0yTGiSjWwy+Rt08JXBmzdqdh0EA8LpE199HnLpnQ867ODPXwNRa8oeNjWVa03luHQEP+OA0kpeDL0FEKyr0b9CkGJD6HDSkFb3/N5xLKY5Wix5bOPScXp+7Q9Ak8aKFSSB7pdKYKUJ/2CnUihxvuNw3SwHfupayPPIao6WDloCrbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_map_size() no longer provides any shared logic.

After the sparse-vmemmap changes, its only remaining user is the
!CONFIG_SPARSEMEM_VMEMMAP path in __populate_section_memmap(), which can
compute the size inline with PAGE_ALIGN(sizeof(struct page) *
PAGES_PER_SECTION).

Remove section_map_size() and inline the remaining calculation.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mm.h |  1 -
 mm/sparse.c        | 15 ++-------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1462669418b1..624c52da88c4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5022,7 +5022,6 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 }
 #endif
 
-unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
diff --git a/mm/sparse.c b/mm/sparse.c
index 743112ac84b1..785c0be80aed 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -219,23 +219,12 @@ size_t mem_section_usage_size(void)
 	return sizeof(struct mem_section_usage) + usemap_size();
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-unsigned long __init section_map_size(void)
-{
-	return ALIGN(sizeof(struct page) * PAGES_PER_SECTION, PMD_SIZE);
-}
-
-#else
-unsigned long __init section_map_size(void)
-{
-	return PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
-}
-
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	unsigned long size = section_map_size();
+	unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
 	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
-- 
2.54.0



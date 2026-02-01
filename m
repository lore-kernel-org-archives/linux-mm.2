Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56EBE7C70D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 06:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179906B0089; Sun,  1 Feb 2026 01:35:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1236E6B008A; Sun,  1 Feb 2026 01:35:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B1D6B008C; Sun,  1 Feb 2026 01:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC2FC6B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 01:35:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DE09140466
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 06:35:58 +0000 (UTC)
X-FDA: 84394927596.25.3E0EFC9
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id AFF1B40008
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 06:35:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l5k7la4Y;
	spf=pass (imf07.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769927756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8AdoB6sry4rs5wh+etYdnccb09faRPmAEKL/AFwYIU=;
	b=NUgdqr70CSzmhGLEaQj8et/zLVPhANXIP84u8zNIp4k3KegZbA7W5ZdZ1R4gOk2zJgN49Z
	306XGtsD7XsBsFYD7/7ee4/5O4NmOY1V4qlSdLWFFIzBd0whNZW/7YQXiS/w6xpiAtF6so
	stQKdWYlSxqoikysoDGUTnP9z03waQo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l5k7la4Y;
	spf=pass (imf07.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769927756; a=rsa-sha256;
	cv=none;
	b=IitiOnDRAl3/oqDrWGldSwberojzY660ysm/mgxI0Y90oZqqp4A5U6TUO1B1VNw6i9T+Sc
	/5SbWAmR/TVcnl14R0srQWogr397k01cVUwZAomDV6J1ZsKG2PWDUencohh3EMKUfKjrQV
	lZit8ekrzF+Wgumv9rLBf129bC+xXDI=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-823081bb15fso1772243b3a.3
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 22:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769927755; x=1770532555; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8AdoB6sry4rs5wh+etYdnccb09faRPmAEKL/AFwYIU=;
        b=l5k7la4Y+6YPOg9G4pRJOs6M7iULZ4ChKN+wgiXJMvIQE/NeafIQdd2gpSzqHmhsrZ
         IKNfGGZcIegb4fWvX97PK7LP3JkqCnCj4EdpUQ2ffqyV3ojfyNnUtmlCsicLGnxaGASm
         fEj8Mb6qg5i1WJsFr/mCE8ax9x0MbFmgMSzUHXVotR2dTiqIWXbqPoewmuUTIfAUEU4X
         XAXbmiWJZwhGt6D/dkUGgtDZGVq4cPA7S5IywnAKcKftZ6NVG5azmo/FzZcrViBw47Hj
         TnmGpXvlGWZKXR/IGOE92ZLksp5Z6z6+NL3AFgvTwEoc1EDHBSShv/M0tWuMeehY+Eeq
         uqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769927755; x=1770532555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z8AdoB6sry4rs5wh+etYdnccb09faRPmAEKL/AFwYIU=;
        b=bVbsUyQoL7kxF+CMwBbuX6NXgOKy4jZzY+uH9LTGXqAVezJKo/HSwtqvFeFCb51evH
         6mKd4tBG1plF35d+PIeYCqQxBLIbkIup4fNhwrB4TMHcYRUj4F0GW7tJ3SVBWs8hlpgt
         eo2kgPC9SsmXyydESdzPJOJAd1xBh2bNFC4vNzQtoTm88MVrTUs2fBu3tjE1PGrp0zLr
         4+y048KuKKvwATKc1VnKorsXp4gG0X1lie9ZAg18WarwxMib3c2XYDF7jXb3tHLBFLBe
         iW0SGRW2iWlF6FfdmzvEZ1UnDOuW+naqizdUc5M2CrFBWfffhnTb2arzvkpm0POtJiWm
         yWgQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6Q95OAJJy4vE+SJw35V4sGUdiVS6rHCtfNjTp/nLXr9P945nd5Lzcyl83bQ/KZIbmTUX7ONkISg==@kvack.org
X-Gm-Message-State: AOJu0Yzckojfkq6scJFAlHifnbxIYC5Kc2UeeTHq2rqXBVp+Mv5Dc6vC
	wpyltdUvqf8VkAUMQuNxYVWRypaV67W4J2ZDjVWAYODqVBcKKUMYKvTg
X-Gm-Gg: AZuq6aJF9LFG4IH/6CUxZ19gY5k+s853uiB/cIjZlR6iyR+x/j8cfrzrKqGL2hS2Qb0
	H1jNXZgREZmCM4G5dckyE/XJMT9BNVG8095ItFeUjBRGvNJHoTFSKz1ZLXNKU/POIslfsjnGLNO
	k+l9fsOqc9SCrhPtN/UlLNA65VzE1N3QU9MWWfS7OeqIIr7DfMiRWcpKxHitRe03qg7mXfGD/NB
	QYj5NYy2gBkFD9aK2UeLevXoTUui4ZfAnFicjKw7+WD2LbQmv6WNTzy91q2iWZy5bCQ6MKPRnxu
	D3W5m/e112Fzag34StBUVttQubs5xsezV5W5SIK50UQMq8w8zY13MxGlWLgXM/Z/47d786TIIwT
	v+b9EFLdLBuwIyRuZgC0WVA+oNZfswcJHscH++Rff70CHW6C6heFpd/yJfvk7eiNKEKUrdZ6nIS
	/ZZGiPlv8J7n+aqmyp/i+VQoUwJsTpKzoOxAEiwq9bVg==
X-Received: by 2002:a05:6a00:12d1:b0:7a4:460e:f86a with SMTP id d2e1a72fcca58-823aa634e4fmr8121991b3a.25.1769927755539;
        Sat, 31 Jan 2026 22:35:55 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.120])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6b2bdsm12149294b3a.30.2026.01.31.22.35.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 31 Jan 2026 22:35:55 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v6 2/2] mm: Convert vmemmap_p?d_populate() to static functions
Date: Sun,  1 Feb 2026 14:35:32 +0800
Message-ID: <20260201063532.44807-3-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260201063532.44807-1-pilgrimtao@gmail.com>
References: <20260201063532.44807-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: qpzb8mpn5qyz93fm6gb8575xuw1rt68j
X-Rspamd-Queue-Id: AFF1B40008
X-Rspam-User: 
X-HE-Tag: 1769927756-809175
X-HE-Meta: U2FsdGVkX19h2Mw9ItMewEG3FXDhCXtLbR3Ec/Q7xK8tyjxFPZsFPEEEg3G6pHiCYvk6a4I4pmCzFX4/cGpHbq9B/qUa9b+HDcGXp1ggCHzmNnwPz0U27vthMJ+K+rQ30ch5k2xcEEqICO8jzvjD7njXq2Cnm6PWplWIx/J/O7wleMqptLhGkPwBal5IOkYoC83ZJjtzcsI1RHwEnjLkg/tf5nb2zt6p8zLUYMjjhIt4/NLpYwDlwxVzP8cNHcR6lhXgAZVCUW5qWD6Y0ilkseyniObuH/CTVIMngjgdu92ywodJ+HL9Euw+1Kr1eZLo5FmM6KbJvEB7/aSvsAI/nbkSti9jo3vOhmplfjgiGpkeARqWdBsqutSJxg1MId/CjQBqHBTVIMgzpo3n72CN1P9zO9Xf8e/42TUUssB/Pf2V6iMPgVqTbLmMCW7xXmyPb8Pkh9lRraOfW7nG+X39OZh+4k6oMVXfSRiMMJ/Cx99czFZqxJ3CFfKB52Fsh4S5LISuaIwcbhd/9gZdwo9z9TMIfcTcBtHek2xseyh/wFLxFfrd8QdHpPOiHOgF8GfpL4+MMeMDd5DkPr/rrrr8BsUfXj2/Huc/zwdgHFBAuIzbJoubchaeTO4DPjVUkyyQz5aDpQ5AbvnnwEoofrbW+Eyjqt+BBZba5XWE90aUA+rVXwUTpABiSgmHnBB+JYzvDMuvdOJZnSj3cPl3XQzFgl7MuDlE5326WxfzNNP/YAz5jFNPd7B0085LTnboUXWZlI0Pq3tn/pmfrNUMZJN1nnT1lkhKwcW95mTUl5jnY+zRR/xMQrSaGBcz/ExbnD7XwOsyKlstxISKv8sB+B0jMGqAe3czBL3wJZHNlYdvBAu6Hrw1MJCotmlViWRcWgQ/z3eCVz7L4z8p6J5Rjs2cx0vbtabaevOJsbJzPZX/G/+O446VIztI+ocOUbMy818PCl2rzXwiyekdkm958H1
 +v6K3D9u
 O4KaKHFqUDuSk3ZDeSrD3bzp/+QXnOo09nOp33nRwQGLa6Am/tyH7DNPW2RLBT1n2KLsVS1JUeH+2W0qOT0f4x173IyR1b8EEAtjUPfl44hVgubkXH8kZaCsGHI0a0PcLyssfW2vbArz3BNLukG6U0gbbvEFai0cH/pyGgSaDeAfFO/3JeFm6YqBWsjRITMYKLWrsU6cO7Xt8pDuPz0bV7YklqCBJi2f86ZW+ca95E98APUhL72ZASsxwFveDJvrgIcxlO129KfR4vmQbrvEICZAp/4YaApbtqBlvxDDQzmqao4sxN4tXZvDdJYNEB8t0FyeLfxRGVIOCngpPZaN5xWsbBwDXWOus4jwLoayW0ETkANUjPEGk87g0+yAvCGnKGzTWZslrp8e4z9O0wA3DZ0pp8B9eAXBJqNDNCD+s4weHCwvlM3708X+DnY4/PHVQjxqwtNFyZ98aO9ZcsksEzeCGrakjP+FVUKxvsYtc2ZleDqrIhvAyArjj/JfyXQ4m4WtXxSYuoV0avtNdCAaBmg+okVJcE2JXuINrDFxyuuEsi3et9PN2K/EU0QkGTJIMAXvPZD89ocAlBhkw7z07hDZe84aW8/rbib4ogVkhvJwt/Ks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

Since the vmemmap_p?d_populate functions are unused outside the mm
subsystem, we can remove their external declarations and convert
them to static functions.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
---
 include/linux/mm.h  |  7 -------
 mm/sparse-vmemmap.c | 10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0d5be9dc736..10a0664b4ce2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4238,13 +4238,6 @@ unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
-pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
-p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
-pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
-pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
-pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap, unsigned long ptpfn,
-			    unsigned long flags);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 37522d6cb398..67f9a08c2376 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -151,7 +151,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
+static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
 {
@@ -195,7 +195,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
 	return p;
 }
 
-pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
+static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
@@ -208,7 +208,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 	return pmd;
 }
 
-pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
+static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	if (pud_none(*pud)) {
@@ -221,7 +221,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 	return pud;
 }
 
-p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
+static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d)) {
@@ -234,7 +234,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 	return p4d;
 }
 
-pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
+static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd)) {
-- 
2.50.1 (Apple Git-155)



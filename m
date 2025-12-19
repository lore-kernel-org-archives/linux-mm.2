Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88169D767F9
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E811F6B0092; Fri, 19 Dec 2025 06:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39086B0093; Fri, 19 Dec 2025 06:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45206B0095; Fri, 19 Dec 2025 06:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C22626B0092
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:58:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77286603F1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:46 +0000 (UTC)
X-FDA: 84236073852.09.C8486C1
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D349140008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:58:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BKEamvUV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766145524; a=rsa-sha256;
	cv=none;
	b=1JcN8XyA0Uel8RyzTvJ22zvV2aGna0HG/oF1N2D431y7q/0YhAchvPEOY76lqsVemCeRmk
	wmAJug4G0MDMogEoAj4TFYmrQNTbHJvBJuIaLGyWfwf9PPz4wHarRUW2xJ4c5SCqkDMSKD
	iLCrwhik0edwo22A5kVdJV+t45AceE0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BKEamvUV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766145524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVePrI9HNUUUrQXi6c3AiF1RzNZZo1pMhE3QtRBD0Es=;
	b=35M5yZfGVQOp2s+59YlU6AgQzMqljRRbDVNU7gYBjITs3GcOT79/Ub4eDb8R5tDrbJ1Tot
	X94CjDNVxheg/5yfPNwoUjMMT095Dv+tke6ZMKX4UVgWh2NhuaLg/a9xSroES6K9g9hDMm
	t7SrJKamNRYkxgBzUHLJPgabH3d+YUE=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so1858776b3a.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766145523; x=1766750323; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kVePrI9HNUUUrQXi6c3AiF1RzNZZo1pMhE3QtRBD0Es=;
        b=BKEamvUVfbQP17eNOQ9HnncWTeRG8AG3HSdhsK/3iH3Hq27erUOl/dqwCS2uypRsg8
         ev81+dYIKOlYgnfgpbOyJLHDaGeRTZAYwphJoNda4oPfxl/sWoz2LT5g63L8SYkwTEzA
         eN3eT9OJse+NRPlFZZZQW6Lf1HIs/27gzjvpH4R0LSQKInHxNVRZJDJKGhhSMlh3CeiR
         fy+mA/lCPDqzrk60c3zKePZNFpu3X9uAP/DvKj5mHbw/+LHvMS3G7iyNfTMq/BVY9+3b
         4GSIBBVYp8uO5JyiMzmkogfvA/7M13TEfXMfIAt2uQjkrg/d1i4eMD1I2XJNNyc8psDK
         CRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766145523; x=1766750323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kVePrI9HNUUUrQXi6c3AiF1RzNZZo1pMhE3QtRBD0Es=;
        b=HO8GfquI5iTox8X4y98GzOwp3xzRz9SvOhJGQbTBxFxBDoo6S1SSyEsKeBf5eDxsYq
         O9aCemSZxFZmO/l2iXnYGDa0fQbNwEMjUQO48kPRRNF26xsW5HDrPCXuNUEvR1f9FJVq
         O4D1NdPW0KMl6x90t4T2mQHx0Cvmr0HVSjeBP0OdDK6CwDkc7Qy6JQJ3XFpR0WPvAFJq
         ghCtGloqb2+oiGMqg1LcxcDBYcVrd9GDg496DznDUZI05GNMIaE46EaCNRghrR2odXkP
         8EQcjy7ZAP3gK+x+K28h6JSDhmrN7RBpfxDVvreOfS5vKVnRyaQqHpnyMh52mHEIbTdr
         6zGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlZ9AR3UfOgY4RQa3hE/0ljunahMNYoC4rPPOhKBtdC7lsO78waCiZyVXLBHP5YY6pKk1Nclglfg==@kvack.org
X-Gm-Message-State: AOJu0YxEFgKZOgmu2U4eNvdDQlZzAXPBjb9ozon3DldE3WDCqOKGmmq1
	aAk0A+9B6bk60OSeYu7rwETtw1DiS48KAacbIkQ/cucs6q+CkqLclDpw
X-Gm-Gg: AY/fxX6T1GA+ZR3MJq8STJGR4U2w5IciWdlecg6nFdEcQywvjDXPu2AOH9Lb3MW94Gz
	c7BNSTGo+5oRoqFTOSRQvQg6g6+TRNTF4IQUV8jnCV9b1XgaX6IdKseDRIoZ2M/43oBDJkPtpdb
	2xQH/26AKNlTGMI7TDCpLGCjNfWndz1qDwVePxnLrxZk4eUYTGBXHmcMjvRhSlkjTzOLHPw3Fqp
	5Rlk8AoTSbwcHWqnBWpMK9YYEBm2elRBU0MDyGTJPmwmDSvgirxqO6aCGyfiWd29/lyqAwcCPee
	itf47cqa1tma7Vt+K2VeFmRPiK9uUlYr28tHkOz5FUV69VmbpqszPmBVAmgLTxzaBxTZefFaNQG
	cEdpD4HS7ZUT6gmUVjRmFKY6MmrMTOCfWqnglrPH/PjBD0jHPWwV0JXztpGhdjKInDrO9HFwse5
	zVmm4e0LnA/1HOafKzF+BNwv0zg3lHZ3OpNi+kLKpZFA==
X-Google-Smtp-Source: AGHT+IEssKL24IcA70xxc4mhVvvw4D6teK050VKbdzvFCYfVJoKpYEGbrW4olo5yzEO8AY5fL8eV1g==
X-Received: by 2002:a05:6a00:1bca:b0:7e8:4398:b358 with SMTP id d2e1a72fcca58-7ff6607b228mr1844327b3a.43.1766145523337;
        Fri, 19 Dec 2025 03:58:43 -0800 (PST)
Received: from localhost.localdomain ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b127b00sm2258560b3a.21.2025.12.19.03.58.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Dec 2025 03:58:43 -0800 (PST)
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
Subject: [PATCH v4 2/3] mm: Convert vmemmap_p?d_populate() to static functions
Date: Fri, 19 Dec 2025 19:58:11 +0800
Message-ID: <20251219115812.65855-3-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251219115812.65855-1-pilgrimtao@gmail.com>
References: <20251219115812.65855-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D349140008
X-Rspamd-Server: rspam03
X-Stat-Signature: d88hasqpnmzqgz1yu78zg7hca3rtzfrc
X-Rspam-User: 
X-HE-Tag: 1766145524-96189
X-HE-Meta: U2FsdGVkX1967UsYhgpt43Zdb0EG642rN8hLq4GwTDyZqhPA4HTe7WgP0UE2BpoU9W33hSniuaa7zox1erHIa7hXuJpa/+YQ8JhCFo34trHsQVrtUp2HlxaroOD0wvYzaDN2C9aqH74V9kybXHkiwoh0eoo11cu3n1zIbGEyx4kGuixjo9QOz+hDn2a8yr1Hr731vbuQrhbuS/qpUH+0U6SUB4uYECwMHs0IPD8mQv+IGZwwgRjCmSBPYuPhR6io6b3Mh7lcCxQNWMLgZYBdCkhgSbDH7hgu3Jd1T9+WjGxntSOoLb2SQ2LbpMbUUtRC6kGz8t67y52Z40ZFOR27KA5Nh4xSoskKwt9C9tWlafDZp4oTUa++iXTshNLUfxK4D2i8zJrlLA/saSJXWGyJzryyeZqZBShQ1PslQYYtRbtJ8oPGecI0zgqxPL4yppShaOUh0k8nwTATpJO0w9wXRnQG62aELge8TcjqRYwjDgfirnf1z5yoCB/ZaF0zVl/d9EkUD0LTQUB1AWxjA672UIDiM/VxTGp//IpqoVPc+emNZqpM8G3h1j9/INiq7kvcvveN0HnnpN+YgYS4wdpPo6TO+OeylLSlBlHFKLU3AQyVP20XQ/Cia+G/5tzdAC01Vk3Ie7w6OxPkV+Mg5rdRow+rt8ysEP36UY282/ClrFkTfRnOe3vfhNWWmB0O9pGbUjGNiAHdFT9pXsjS0FKgfiNl9vp+BEqNboRVt/IDshRGuyVqBhQVkAp2tefHCoPLerTNSohG68LOYNeBLPxRXevgYi8eZ6ZhueVXHUwaqlQywHCjrm+eB/tWdk+fQhNsPmqod1R9jtAmvk7CN2DYWtU4GgZd4GBLy02QQdPSFitB1wqwhXO2SbLCijYY9KnCPb7atbpCSfOommzU3sjSNNCDWWG3PiSZOHZ1JmDPy1V8jEtZW8yZEhQ2XFmhtgO4N0cEtbxTFcoawEOfrXb
 lFUIZIkY
 4VucwEppvtfm0G2SNUIsxF+rHWUJHdcmepQlMlIG8LQ8FHdZ1I03YeCA+XFwRozQAQHlbbCYNEnX4u9XxlkkbTYqMiIdEKSw4r1Y7YVtiuzclYRZrH0VOhtnkkUldzNJpbo++DV73yA15u18OdRJ0UYBtZWlhEgZ2hJ4nCasAvawXBmKH0NykX0VCUfF1M2arMMc8AO6hIxdHFDBP+5TOu4HmecK0m5s/NFr46OWXAfSN3J+dhP/0vI4PgqMQchYHfdUJnfFpjTyzKHvN13w7e+bWXYrfowArSumGl1xhwBF6c6oNs+rqYM1S90dyuqN47i8DK30XboC+YSErYBAOcuSvHVWXS6Dbv52xUjhEMN9VRZJxkpVsaieF1vlg5gR4sfHyyuUD/qLoWKEHNzbX53op1RxA50rlxHrtxC2qPwDy5YQ4o3NnUJLZQoMwUpVTt6WhwJMLeYjMrktgiIZngwqRdaHjrvsSwiPH2cMWqd92GTKjV9L2BFlOuTziR1tDkzIZJb8AmpTgxLunIbfBmo4WhJObYHVr7LNO3ZjjUx4nlbO7lEJsB0rAuw==
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
index 15076261d0c2..d98a38a6ac0e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4234,13 +4234,6 @@ unsigned long section_map_size(void);
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



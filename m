Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2682D6E2CA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A88A6B008A; Thu, 18 Dec 2025 12:48:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0731B6B008C; Thu, 18 Dec 2025 12:48:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7BB6B0092; Thu, 18 Dec 2025 12:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC96C6B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:48:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B289212BDB
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:13 +0000 (UTC)
X-FDA: 84233325666.25.11B094E
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id D838214000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jY/7iPvY";
	spf=pass (imf23.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9a/4Q9iM3UvOXiUx1Ukt0rzePZxlPvy/hVaPhme1T4U=;
	b=ojMcUfNQTvFep/tKKk6Fgr96JjuGaVU7IY1P+v8pjlRFAXhKPrciYpcGuNavcJWxDUJV62
	oiqL2Wp1Zc6cHjjMUbXck2eFDAem+r+TVIWBaGwy5IIV9wExQs6YXeC7cJYbhaOxuxK+NG
	dJbOWzpxrvpT6WM1zSwPN57CMPCYuaU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jY/7iPvY";
	spf=pass (imf23.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766080091; a=rsa-sha256;
	cv=none;
	b=duJA9OOOj4zcIh+bLglGZhT0s6ncY9AQuoLInHoVk/6bydrqspyjHrEuVBOJZA58pxtB2W
	eXslUUDnuEjlNFoqx9Qe05pi0UGdgA4httShvHEEu1okmeV9WS/3hkKLrmAogLL8jInKD7
	T/EdrA+oDSJce9SBH51uYtPg+2cfjgY=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so846767b3a.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766080091; x=1766684891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9a/4Q9iM3UvOXiUx1Ukt0rzePZxlPvy/hVaPhme1T4U=;
        b=jY/7iPvYylBoB8ltmY0barcyQHLfZly4l7s+K+SpEnedpy789YbUUQMIcC71fhsxxh
         1RQy+RfMOWt0MoeoNMOC5dlAU6WyLo/xT7rcT+SieeVuZVWScmuO0Pmgd7Kha8rx74b2
         TQRTFgyTn99mp7MMna0HMLsMpGrrWXtXABmzO8qYwC1tXX5kG2613Dn0aOgPRYRVCX7z
         NWeKn2KD0XgEH9b6FamTyTJpmtNWFHOuw1E8RBifqxkRYht21tkMN0bMmZN1cShmpmse
         bkQRohBmL0C/BNRDi7vTOgJPZlxr6loaU+YkP90AGXa1GpkhjEmlAP3mpKMy6Tg042z1
         WzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080091; x=1766684891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9a/4Q9iM3UvOXiUx1Ukt0rzePZxlPvy/hVaPhme1T4U=;
        b=hgnFyJbUCv38JpWAWG/ySc6GfdvrJu4K2MM3wIb27tCsBMA2hlmAXDbRbb+pdSLL4I
         WjCwQGAD2ehW/l4oOc6OnMnhUlgVAb42V0P0Q+/ovWWe4ezLBxZ+4HaiyiswwAd2q1Kz
         x8dQdSOjOk8oArWGEKMBB2mLNS86sj9P/sYfxDe62N4TQvTwIWBlybitrXiiM8CmAGoJ
         78+KE7UoyvlULh0vq1TfZKuWdgOCYoSSkTSiLLeWRwijkJfIB0PfLKJnPQp8wYYSQnWM
         1IAe6V31ul1V4gHcPAuAxjX4ty1yHK8qpIefYvft3vx/6lIVUfkXl79H54qAAgQQfDUd
         Yr1g==
X-Forwarded-Encrypted: i=1; AJvYcCW4kK1SqXG39xzUYnAC1Q/ogsMSl771b1VkrQN2NyiOdPyPfkUgFjmRAmvyqADpe8zicTnFAonJNw==@kvack.org
X-Gm-Message-State: AOJu0Yxv2t5U5/6ZkmcvN1tpT8D4xzZ2gO8LyqBeEEGW3RIdcfMMjxRX
	7M76L4d/qNyNpwBPVSgVr2O/iHYQmyYj7B/g8Z4O03EEawDqA0pfUH3v
X-Gm-Gg: AY/fxX69cuC5M4coV5J0uH6XdkBV8KA54rppD5YzpgzbnT9jRhsIiX8ymYf/Ccnec/y
	alkqNO1mHBVEbpN5CPiA5E3aWmzB3EoLGloPUVUubj/greyL9AIKbqzPY9UnSmtoDS1/Ivr7amG
	bHsS9k22Ke376hqXUXMNWmvOof21t/JDTTw7YWRm929DW7kqm4P4v+dFLmh4sUdtThMvATXLEaC
	TyFioOEpk4565+0VE/9WxImOyeybtQA2ZLtYkXzFaJgrw9j7LDZc1o6SiwS6F4CqqhN5ARRlhRV
	rLVnHJxvnzfRygTq5tavlABSW4X9X10SLPopQPO68jQL2nEDLjshURXML02b4+R2b5z2kGfVoH9
	SyilPWyNCJOZFUJZ5ttmPt8ucuc7ei6Ih7gOGqOFbfJbj/NCDhtnqVhHgoLdZMHwrDzeBHZBlKw
	DDLR2i8Nn6xCLt0b1RrZYlat2rjFCg9MQYuArIMcrrWhw=
X-Google-Smtp-Source: AGHT+IGfR2lFl+VRcbKc2jOFwOYw8g8R1rmbfL3f0XS3RZAPvpW2FkBK4dNPKqBXwbIN07Xw1mOU8g==
X-Received: by 2002:a05:6a21:3290:b0:35e:4017:3f32 with SMTP id adf61e73a8af0-376a96b9a7bmr226011637.38.1766080090692;
        Thu, 18 Dec 2025 09:48:10 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.152])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2fffa3e7sm2847400a12.24.2025.12.18.09.48.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Dec 2025 09:48:10 -0800 (PST)
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
Subject: [PATCH v3 2/3] mm: Convert vmemmap_p?d_populate() to static functions
Date: Fri, 19 Dec 2025 01:47:48 +0800
Message-ID: <20251218174749.45965-3-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251218174749.45965-1-pilgrimtao@gmail.com>
References: <20251218174749.45965-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D838214000B
X-Stat-Signature: xnfjct149ppwznibbkk78if1q8mscffi
X-HE-Tag: 1766080091-513442
X-HE-Meta: U2FsdGVkX1+0AN7qwkYLmTRRsTZFgdMK3jB1VkgmDP9pd8yq7KrP2YbYrBuzHmrA4vqif/5wt/J1qZNX7veDulkbL56OjleCD99/LocOORyOVGoFtMLq08DBPRUF7smznxUkRcoxj11wWhDvwcEeS5lRCuP2lZfe91JlZswlJCG24tUOwKRVy5r37RgmvZXwzAVG0zMVHQ88eZlQOMZ/0qc8/fFM9bQ2mJNOVJJhuU6D5tpF85/C9KIbPCD1S80I97Pq9uT+ytmodWYopYz8WVOc0TkrER2OHmTO9QTp+GUTfbjbndk0r4bhheD6cunefm6TMeaMnHWhDNGeOE/hsQbRU4s4FxvvjVHZdLrTJaueki7wk23E7IjhA6gEq+DjlTm7UtrWDL3s5p2CtlMX2z5B5Bm2/YUXMEze4cm4bGMU5cDiDdEPNUYrOUmSNLsxgE+Hcfy2cpvqigWW9LT65F4IGD3z/0IOPdh/JGC2RnnetkWhrlliQw0jTImkpmRzRdTDVbkSSor5nXVnih7chR/TcPEjlxBplUSczlWndpGVkfa49xKHtYEg0EqosQrJKSCL3/4FkT46EKTw1himCeDsE3zX8tP1Gca0e+PcqXqqGiF0sogfCoq6zU6ek6aP27uXOUTA9jBlKSIokpYzXiw5mL6JUydX35aiFhLrSJx3E4ojAkaDkmPHlohHA1Nq6JfNaQVRqR32BCoLSOFRCb/rp0CTqR7HQQc/LzT5jZnzaUc5TicBWvFr0HQ8jNRTP06ACs02TgLcpjSoejvSPYJZms5nyqW3UW+050r6R3uecebAIRAhz7lnBxGnSbcCC84Hwp9sqmloza+Sc5uYskb+kkYN5LbXn/OYdQa/1/46+hWFXhyPQrOaEwYzeTG+cmKOXRsP9XlG5zE/0NWaxE9rJILmeVpFjr6ljxMIiH7cGlC/5FJQ5WSo5oDY9W7q9p5Hpz8EZ+KofVLeZ6s
 QNj6Hn9m
 vTIGE+cFabRQnm5xTOhiQ69WECXb2Gfj9gzWfEk8Wzbf/EQf1ORhzh71du36N97Vtc0MOtkJMk/Em7opvPkdlt6ytZ61jxUBE+az2/3+gqXOPNB3N19QPkoF4hXF2kUfogiwz0KkWjjLMNe6iIEvTdVTR9mXmMghIPnsF5hf3IrAPKbclgFG9z5EuoVdO44bQ5FozWCZ/K8gT7O3nvg8HggG4w5tVo+FEsX8xBkQi+yPmdtOTYJ8ctzKXDm4phaQ45Udx8tu8QD05no6ngHduBtHhvpKeLAAHvsZL7NMG75NdCnYdhTw2ykQR0rcd4ALbqxPwB/vHXc7zQR5Avbu34SPx77khrXdu4PIdGV5IROLOL1NJjR4Rx4nAhPGlgG+YNFyoiLleAsB9POWT4ODdLz+R+LwergRwIRZZWQu05rCCTbhd1onghICxIBiBIx00l9HasHxHMvTmmztQq0wSMrvtInwr0wR+pnzhHlYrv0/cWk98M8JmIegxcxzIfwE+AwdRuIakqNKcZcBr7U/u9zlQAJVgNhgbGsCEmkrjl6nyZG8hN7HwV/pajA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

Eliminate the external declarations of vmemmap_p?d_populate functions
and convert them to static functions.

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



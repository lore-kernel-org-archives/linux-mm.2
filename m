Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE89D6E2BF
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9126B0089; Thu, 18 Dec 2025 12:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979EB6B008A; Thu, 18 Dec 2025 12:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A70F6B008C; Thu, 18 Dec 2025 12:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DFF16B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:48:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0260314023E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:07 +0000 (UTC)
X-FDA: 84233325456.29.2C6E337
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 12B1140008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UbRCPhY4;
	spf=pass (imf17.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epYK/hDqdjWsYGExN15M5ZNaIRiA4fpEDtVX6uPFKD4=;
	b=ia1tGH66vMlZgaZOcX3N+P4PAzaeolNSuJq7hyNA5pFGgSL0fsYmPRNB2HUt+I0Tcnztqw
	EaoIZVCEuq9zgwzKevBf/uRqd9NUV7nI6fEWpebzfdcXsJgnWb+xoyR58qktYtmgamrWc5
	OzjfuUpFrDtn49rfgbbsGf4vRKGC3OY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UbRCPhY4;
	spf=pass (imf17.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766080086; a=rsa-sha256;
	cv=none;
	b=lmnHoFA4Tb2kFacblN/CoqzD1MrzYZfrpV5cL/tyrOrO+L+1ekCZWtB8FDb+S5qTzaZci1
	ADU0HasBeKAVQr5CJEX//trqoUH+UZq+2w74lMgoJAAnzJZaI0OwuXsLYtm/QZyyoGiOCv
	5Nn6eWJdBwxTA7a020+InxrdU1Kiffs=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7f121c00dedso1197573b3a.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766080085; x=1766684885; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epYK/hDqdjWsYGExN15M5ZNaIRiA4fpEDtVX6uPFKD4=;
        b=UbRCPhY4sqZBYd0BX1IliYqOHNl77a09J4h7abmosTgdT52Az5ke2AhCNbT7wslonX
         uh1ZmYkv1IKTUg3D+pwyWG2HIG1ZnGAzNvkrDiZ1noaWxOjqOIz2MYVZsJRqfR54uT2e
         RZUuXpRrJjB6trfhoHU2yAlhjlH9Ti779Gmv6k5JFPmen98DtPt+PRHoxAwB4RwJD4ct
         rpif/4FYz6mG262pZSFt3/zhLCKzqKXknVxj7YZrc/7VoyyZBYuI3vdR+O9eJ+q1JoKZ
         QoM7JpsTCgtMKf0AUOl2Yz9gtWnmUDLm4Y771bPNt/ss0AiggiHAT1/IlIIf3eEDc+Ub
         FsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080085; x=1766684885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=epYK/hDqdjWsYGExN15M5ZNaIRiA4fpEDtVX6uPFKD4=;
        b=IExtZLJM0/fo0hvGvVr6DGNlzW1BXVYbSSGI6PgHLp5h74b53LNi5LWCROYVdJc3EU
         5/Sfmv+Qa2MWAgKzq2fXcBoKhdxryrABsE1FuI8kDVDj88C3BmaqnXSWI5Y5wZUUns2S
         f0YWnIH0TC38TL0m7fiBe/kWtCYTSf5fLBZXaNx/sK+iciiDbmVIsISTNxuaXX7UrTDl
         BvPuL6h63HCjtdJ+EbGofCJCQx3ydKYywmG+kBy5GUkxPXSHA5kXZ2bFJuRkvoDnkF+j
         c9Rs5hGr8hryUjtFqVPQ7ZFhSmKbpcdloUfYnrQStcqu8sWGlQzCy4DuLWRb/X5iNtTg
         UrWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfzDItRgI6i5u2iko6SR0NCJp7weR7tvZoSaKiqYV6bhiI2jwlJfVcqYGVbiKjq59qmNY62T8Q5Q==@kvack.org
X-Gm-Message-State: AOJu0Yw6Kc0Kj2XWu5A2s1Kf46F1RVjH+OBeH3wvOJUTxwcWIWUH6H37
	gXLUAfkVio+P42gwmqRMgMH43AFIccGhwr/Qkx7R2lweA7+vKRq5Ofpr
X-Gm-Gg: AY/fxX7lz6YtErItFZEOhHn0fRlHC7ldtE9lWd0+CpNiigGHA745HhvLFiV1pE6gr1Y
	T/FUFBWioS+hJcSUUs9ZhOQLk+4Lyx+t9IK80TfYXe0Uw0DvQYvg7LBW1M3dCk8YZ4sP32Jghg8
	q0Krok3XGFrtyuSZjik6+sYxSR7SLz4GNtNezLr3Tc0GHlMb2DbDpHFfUuKEXHLCglVvdqaDfGu
	8LUk85+r+V5pGjNJrEjXXO5a9+dA8Wb5OYH0vLuw9REsxW6xAPjfwokE21lkgS2fdTEcHEvcXk9
	nakc8qRRr8Tj7RR3c4sMbCaYsE21cVbErQGhX2tBziUXZmVRaoZkjGGJ8LB0XJznjjQ9dOH41mx
	LUMecmxorKMvQLIINUR+kpP9Nxl2vCa5Z9vXJqhbp79l3nuPQzeSoNHYktsoFqO+Pgk0hrG0/Hu
	zRLyhAFgJtPbQ5K5h1sV4RBN125QuCL13n+supSAKgM7g=
X-Google-Smtp-Source: AGHT+IEiUJb9RR+h+zWjnVgNYIE3LIavRn+FigrW0373Cgz4UkWlOkBrVQuLtzTTA20/OyG5rizoPg==
X-Received: by 2002:a05:6a20:258c:b0:366:2476:db4a with SMTP id adf61e73a8af0-376aabfb668mr280882637.59.1766080084881;
        Thu, 18 Dec 2025 09:48:04 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.152])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2fffa3e7sm2847400a12.24.2025.12.18.09.47.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Dec 2025 09:48:04 -0800 (PST)
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
Subject: [PATCH v3 1/3] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
Date: Fri, 19 Dec 2025 01:47:47 +0800
Message-ID: <20251218174749.45965-2-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251218174749.45965-1-pilgrimtao@gmail.com>
References: <20251218174749.45965-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 12B1140008
X-Stat-Signature: 5maz1nb91aiw533sd3i49nfdhamu7bgm
X-Rspam-User: 
X-HE-Tag: 1766080085-426425
X-HE-Meta: U2FsdGVkX19ckmTk4OZtHD3OiCdBUkF+g0DeTTxvu1TaTuzOBuXJPJyU1mgtFCS2dt8T90d1fKUd9xW6mA09Czt6M07gzxvCxF/zVxkO8rRcOgOcSdK99CblgCNvyeYaa0hH3nyVj2OWXoGWw7ap3oGrXBF/BgHTqvTenqjwgNKF7ZOluIX1qEuU65FoX3pkJiBCzGoeA358v1INyE+leQmSjGwjbf9cImhQ3zTv31On7ZWBvZJxRjS98kUZe+8sgwESZALJgvM6JMSW2NmqOT/fKgutpK5V2mQjO58ptPiBGT7HUDOQPzO6R0MRUqySlzS9h8CHsMwQYVhkjKAIvDJ58mKg8WJiW96zQl+9YAtvMgdVUKjDALmlPTLQ6K4RMNYFZsIkWECL/rjG9L9fzNrRz3TXNNPr2oWcmgJ1Hv7f7nJ1NACT+JU5IXlicUlC6we7J88eD9k5D0XtHsmnjY6ESeqBxK+LLrBlqQEv3sQEblPaqlU85XBqkUMPrymeZMGB9daUza7CSHxEmcR8JgT35Wz9PvXNhWfEg22WnKPR8BNcLhiZCBDiw+sRqA9r0jhAJwNdpdWJn8Kleb6ywZnTfG7yoVndCHkmnB/wa0uWuOTlr0f1DoUmKPEJ15hT+DJPOBNkr2gBHbdQCw1qPPtmWWNAQ+xu6yQ8yyESSqUztQ69h9H3qwk7CsqUU7MNIA0a3gbNcVxy3jkrJ6HNhRy2pa/bIt9mfl8S/4TKtfmCiRvVGKS7zNSkBKh8TQEXMu3Bq2K6EvySEk4bJf3KC3d2WbYtENk8OVhdlJYs7Te6KARnSF9Jb/rtcY2qN3w3hQ4FJW+XYj+yoeYBjLqEoisIAy2Mq7VSB3LtY8FP/Iz6WLINsNw0mrqSpIrNzwwyawMBMLDGNMIhduAIU4RR9hGparOqL0KtOMz3x2LFvuwCS0/lprLO0xtQjSqSZ5wIDVclvEVB+G4l5+dwt9+
 3MjI7eNm
 8CmK49gfABR+LL8HdMudZL9UiZVdpPAVyMeOpze3kqbSPqVp4NK3+t3vQcgaCQjVVLXa6SK33IEvRe3qJ1vxGYDqxKzTkcdfxgRCS6ZOdefHwl9ZHDVj5rjxbor2VgVv5CFfEWBcjHS5T+H6zjlQPtPp98xYblTdNjSPDjSEXHdgbZc+ysw0ZJjlb1B3SWCFg5+WIHg+2fmz2w0BI7Q2MQI9+3+ZUVcZ1YJdTXwJNhwAGkJ1tA2SfU4+A9GlIHE7XtLsuIhWarR3HQ8puoIbJ94gu/lBsZG2w7nULVv0bikBFJgECnrSIgZ6Wuf+l2eC8PiReGI3rxGMkQMgNR52E0hy9d2ZvuQBrcwzKnBpvHykMb8N9qPxKQitxHhE0YIb5tF4Jr85P0/ghQJ3bh9A5yzVFNSLAskCw65y47imlWycZBGjMEyI0uRQQAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

1. In the SPARC architecture, reimplemented vmemmap_populate using
vmemmap_populate_hugepages.
2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
when vmemmap_alloc_block returns NULL.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
---
 arch/sparc/mm/init_64.c | 47 ++++++++++++-----------------------------
 1 file changed, 14 insertions(+), 33 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index df9f7c444c39..f477ab1b4f08 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
 	unsigned long pte_base;
 
@@ -2595,39 +2595,20 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 
 	pte_base |= _PAGE_PMD_HUGE;
 
-	vstart = vstart & PMD_MASK;
-	vend = ALIGN(vend, PMD_SIZE);
-	for (; vstart < vend; vstart += PMD_SIZE) {
-		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
-		unsigned long pte;
-		p4d_t *p4d;
-		pud_t *pud;
-		pmd_t *pmd;
-
-		if (!pgd)
-			return -ENOMEM;
-
-		p4d = vmemmap_p4d_populate(pgd, vstart, node);
-		if (!p4d)
-			return -ENOMEM;
-
-		pud = vmemmap_pud_populate(p4d, vstart, node);
-		if (!pud)
-			return -ENOMEM;
-
-		pmd = pmd_offset(pud, vstart);
-		pte = pmd_val(*pmd);
-		if (!(pte & _PAGE_VALID)) {
-			void *block = vmemmap_alloc_block(PMD_SIZE, node);
-
-			if (!block)
-				return -ENOMEM;
+	pmd_val(*pmd) = pte_base | __pa(p);
+}
 
-			pmd_val(*pmd) = pte_base | __pa(block);
-		}
-	}
+int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
+				unsigned long addr, unsigned long next)
+{
+	vmemmap_verify((pte_t *)pmdp, node, addr, next);
+	return 1;
+}
 
-	return 0;
+int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
+			       int node, struct vmem_altmap *altmap)
+{
+	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-- 
2.50.1 (Apple Git-155)



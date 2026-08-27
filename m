Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD48BC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E222A6B009D; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCFD46B00A1; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACD86B00A3; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE2F6B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAF27160111
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:42 +0000 (UTC)
X-FDA: 85147572804.22.05B93ED
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 878D4100003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SKY3L7vC;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847881;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfxEk7T6JyEQqsUbsOIOBOw3o1DLsBcu07jRZivHztM=;
	b=xA8SLoetnC1/aZU2tJDXGZacI5Gc+cMR3Hz9x6rT81ey96K6dPKF+glu8dPosH1fJXwe/J
	K9678ctPlfy3Pu7twIVgVccWzlVYzBD3/MriXzrhu7n14HTHuPgtIPlFyLPgzfEb65HRaV
	jD0hyjKuAgApAviF8fOtSZN4k5EaXkY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SKY3L7vC;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847881;
	b=OJz8QkE/Y0xxyFwQlnJm5Tm0DVW3Yd4azTJxUZebwPmKIsWdyLmvI2KvXHXV4Dsqn2ThsX
	KCmXjIv3IktRNPUCdca3daCDFQPHHZfhyPr9RQxBQ0cMCw4UUrhYojEQmwmw4hqBS03afG
	aiV4LsXISYVH94Dxss6QnIcUBd14v/w=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UfxEk7T6JyEQqsUbsOIOBOw3o1DLsBcu07jRZivHztM=;
	b=SKY3L7vCGkgTSi/KQ22wZIdzfe/u4jTApdIfM0GcFZOaP2qSaY8c/zr5l1/36iDTjFDpDUA7O
	UrwwRuiQncZvbhNNPoZvfOw1Z+UzhAVIvBPmVXFX0z5iJfvI9onj3Yu6VZSipEiJJQo/FQPTKvD
	IEPRflEz2cCmIVDQejLXU5M=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KV2tftzJ46Dv;
	Fri, 28 Aug 2026 00:24:14 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id EBE4940572;
	Fri, 28 Aug 2026 00:24:35 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:35 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 03/18] mm: allow per-NUMA node local P4D/PUD/PMD/PTE allocation
Date: Fri, 28 Aug 2026 00:11:43 +0800
Message-ID: <20260827161158.3618409-4-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 878D4100003
X-Stat-Signature: x7ye6kptmoe665ziw54qprdxrin17acq
X-Rspam-User: 
X-HE-Tag: 1787847880-595095
X-HE-Meta: U2FsdGVkX1/3CTIytbEqiMf4AmVvl3SCFHapCvs20VXQlC25vwS+tvskkQ2mv27XM06z+5UVXzBff1hfADj9JoSY+/3kOAP4vQXvEZnbuhV3PdPjwtkJ3+A7ID8l0qi5/lRkInbk10IW3vVP5WqS5Szf2tq0vIkkqvkLT+cFMBjkrUVHEfFBc3oLCuPeBEKA4890nqUtjEWMXkiD8S/Q0GZuvbV4kbcioFA4bPIzx/eQtsvZeAkGuRnjMcTC+Sl14XJIfqD+7mvf1ut2kZhe5tRlQEo6KH3mU3ciayhB/rikKLqegWcvNG66vy2kWb9sUjK2oeUldmyyKKmx0ZDo461CtdZNizR+aJPbo9gUa5JpeIZTvnpTq7kO9CVhpXJvfQN4qYNzsyVXcmA22lNAwBFebnGxBXp4bbDkzb7lYDIz044mRcH0Fl7JDSoXqtSACHt8Fdtgfao+OK0V2IdhphTonskNvP+F2cTVZtd/3oQQCtpV+9RTk7rCPbS22DlDjRr0Jo6uRFk35iEJDWgB4R+47b0HIh72OC6zEG81gudcnNo9M4/pbKoLByZm33IwFLjZkEkJX5qbjhy5AGzcWGZkCxIE5dUvK5cDs+oHRZX6NVX2gMqKN9WXUReHOdZVcSiN2LLVJfX90Cn/LauBDbUPB/jmT2I+vLhhOUDdzqu7JxOs9m2XhNGpZ75YU+8WEScn4hecip9xlJj4NhTdpqQL5Kag0Ef1gt9oe148OUWvSKcTFCU3nF9o/FvMqa8OZaWauE430IblRRhni1QtKIrKafr8l64vJ+ogu0AZ54gQXgYp5h8fNY060xAMNX/ytiy0qzmzW/NiRqjInqnqQnv8jOAdZ1ypVzsSAQW9SV3LxVzs6KVmO0BnElsw+L9+h6z+Ql5ICCBbmH8N39ZKC6HY2tH+bUXFVLMucUtWIbpOf1FydWvEmUn8l4u3jyeCq9qP+hmeCCJ2jAhcK4K
 cPoPSrHr
 jP3+SqqoYhr1DnujqHeRqkXd3iq4IyymaIykPGpzKUMYreDQullYr5S0VvF1hq1G96WLLJeBb45V6P9xQFf6KY7Kz+fpMm2kDfhBZj/4AXxI89eCNKPHpPEJx7AfavKHos0lMkL4uigBJELi1Vfu372fMzUgadZgt3cP7waoeKLKNyidmY+A7m3XsBsHTumdDjMQ/uTUMmEVBsyV7puqMlz5ie6x3xxFPfNttWNWsD0jN5ofhH8Yri1I156/K0nK9v4aP9ObM9Oj8Iq6rFcgQroYr7+UdatZbKww7tAJl3xHUiADAJD4di+GV9xLx0nzHDX8UO+BurxYjcJK/iUrJFhlaba91pqi9dtEjIepmCtyK7AyY+4GRDMr3haDSFrGyCurScN2ld43YVBrLApmxxyblOW3jWAwejkKuXakU11+IFKRsFzsBGCWeB6cCKBmLih7CuHe3NN08mhc9jdzP2NrdShpFKhAmE+FMkQ+HdghmEkiJQVNsNc3lzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 include/asm-generic/pgalloc.h       | 90 +++++++++++++++++++++++++++++
 include/asm-generic/pgtable-nop4d.h |  5 ++
 include/asm-generic/pgtable-nopmd.h |  5 ++
 include/asm-generic/pgtable-nopud.h |  5 ++
 include/linux/mm.h                  | 87 +++++++++++++++++++++++++++-
 mm/memory.c                         | 68 ++++++++++++++++++++++
 6 files changed, 259 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 051aa1331051..79d10806c0fc 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -85,6 +85,26 @@ static inline pgtable_t __pte_alloc_one_noprof(struct mm_struct *mm, gfp_t gfp)
 }
 #define __pte_alloc_one(...)	alloc_hooks(__pte_alloc_one_noprof(__VA_ARGS__))
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline pgtable_t __pte_alloc_one_node_noprof(unsigned int nid,
+					     struct mm_struct *mm, gfp_t gfp)
+{
+	struct ptdesc *ptdesc;
+
+	ptdesc = pagetable_alloc_node_noprof(nid, gfp, 0);
+	if (!ptdesc)
+		return NULL;
+	if (!pagetable_pte_ctor(mm, ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
+
+	return ptdesc_page(ptdesc);
+}
+
+#define __pte_alloc_one_node(...) alloc_hooks(__pte_alloc_one_node_noprof(__VA_ARGS__))
+#endif
+
 #ifndef __HAVE_ARCH_PTE_ALLOC_ONE
 /**
  * pte_alloc_one - allocate a page for PTE-level user page table
@@ -99,6 +119,17 @@ static inline pgtable_t pte_alloc_one_noprof(struct mm_struct *mm)
 	return __pte_alloc_one_noprof(mm, GFP_PGTABLE_USER);
 }
 #define pte_alloc_one(...)	alloc_hooks(pte_alloc_one_noprof(__VA_ARGS__))
+
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline pgtable_t pte_alloc_one_node_noprof(unsigned int nid,
+					   struct mm_struct *mm)
+{
+	return __pte_alloc_one_node(nid, mm, GFP_PGTABLE_USER | __GFP_THISNODE);
+}
+
+#define pte_alloc_one_node(...)	alloc_hooks(pte_alloc_one_node_noprof(__VA_ARGS__))
+#endif
+
 #endif
 
 /*
@@ -154,6 +185,33 @@ static inline pmd_t *pmd_alloc_one_noprof(struct mm_struct *mm, unsigned long ad
 	return ptdesc_address(ptdesc);
 }
 #define pmd_alloc_one(...)	alloc_hooks(pmd_alloc_one_noprof(__VA_ARGS__))
+
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline pmd_t *pmd_alloc_one_node_noprof(unsigned int nid,
+					struct mm_struct *mm,
+					unsigned long addr)
+{
+	struct ptdesc *ptdesc;
+	gfp_t gfp = GFP_PGTABLE_USER;
+
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+
+	gfp |= __GFP_THISNODE;
+
+	ptdesc = pagetable_alloc_node_noprof(nid, gfp, 0);
+	if (!ptdesc)
+		return NULL;
+	if (!pagetable_pmd_ctor(mm, ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
+	return ptdesc_address(ptdesc);
+}
+
+#define pmd_alloc_one_node(...)	alloc_hooks(pmd_alloc_one_node_noprof(__VA_ARGS__))
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 #endif
 
 #ifndef __HAVE_ARCH_PMD_FREE
@@ -191,6 +249,27 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
 }
 #define __pud_alloc_one(...)	alloc_hooks(__pud_alloc_one_noprof(__VA_ARGS__))
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline pud_t *__pud_alloc_one_node_noprof(unsigned int nid,
+					  struct mm_struct *mm,
+					  unsigned long addr)
+{
+	gfp_t gfp = GFP_PGTABLE_USER;
+	struct ptdesc *ptdesc;
+
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+
+	gfp |= __GFP_THISNODE;
+	ptdesc = pagetable_alloc_node_noprof(nid, gfp, 0);
+	if (!ptdesc)
+		return NULL;
+	return ptdesc_address(ptdesc);
+}
+
+#define __pud_alloc_one_node(...)	alloc_hooks(__pud_alloc_one_node_noprof(__VA_ARGS__))
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 #ifndef __HAVE_ARCH_PUD_ALLOC_ONE
 /**
  * pud_alloc_one - allocate memory for a PUD-level page table
@@ -206,6 +285,17 @@ static inline pud_t *pud_alloc_one_noprof(struct mm_struct *mm, unsigned long ad
 	return __pud_alloc_one_noprof(mm, addr);
 }
 #define pud_alloc_one(...)	alloc_hooks(pud_alloc_one_noprof(__VA_ARGS__))
+
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline pud_t *pud_alloc_one_node_noprof(unsigned int nid,
+					struct mm_struct *mm, unsigned long addr)
+{
+	return __pud_alloc_one_node(nid, mm, addr);
+}
+
+#define pud_alloc_one_node(...)	alloc_hooks(pud_alloc_one_node_noprof(__VA_ARGS__))
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 #endif
 
 static inline void __pud_free(struct mm_struct *mm, pud_t *pud)
diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 89c21f84cffb..95c03ceeeea0 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -48,6 +48,11 @@ static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
  * inside the pgd, so has no extra memory associated with it.
  */
 #define p4d_alloc_one(mm, address)		NULL
+
+#ifdef CONFIG_KERNEL_REPLICATION
+#define p4d_alloc_one_node(nid, mm, address)	NULL
+#endif
+
 #define p4d_free(mm, x)				do { } while (0)
 #define p4d_free_tlb(tlb, x, a)			do { } while (0)
 
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 36b6490ed180..9849760b3751 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -60,6 +60,11 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
  * inside the pud, so has no extra memory associated with it.
  */
 #define pmd_alloc_one(mm, address)		NULL
+
+#ifdef CONFIG_KERNEL_REPLICATION
+#define pmd_alloc_one_node(nid, mm, address)	NULL
+#endif
+
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 }
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index 356cbfbaab24..0acbac9961d0 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -56,6 +56,11 @@ static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
  * inside the p4d, so has no extra memory associated with it.
  */
 #define pud_alloc_one(mm, address)		NULL
+
+#ifdef CONFIG_KERNEL_REPLICATION
+#define pud_alloc_one_node(nid, mm, address)	NULL
+#endif
+
 #define pud_free(mm, x)				do { } while (0)
 #define pud_free_tlb(tlb, x, a)		        do { } while (0)
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..95213a81907c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3595,8 +3595,24 @@ static inline int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
 {
 	return 0;
 }
-#else
+
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline int __p4d_alloc_node(unsigned int nid,
+				   struct mm_struct *mm,
+				   pgd_t *pgd, unsigned long address)
+{
+	return 0;
+}
+#endif
+
+#else /* !__PAGETABLE_P4D_FOLDED */
 int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address);
+
+#ifdef CONFIG_KERNEL_REPLICATION
+int __p4d_alloc_node(unsigned int nid, struct mm_struct *mm,
+		     pgd_t *pgd, unsigned long address);
+#endif
+
 #endif
 
 #if defined(__PAGETABLE_PUD_FOLDED) || !defined(CONFIG_MMU)
@@ -3605,12 +3621,27 @@ static inline int __pud_alloc(struct mm_struct *mm, p4d_t *p4d,
 {
 	return 0;
 }
+
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline int __pud_alloc_node(unsigned int nid,
+				   struct mm_struct *mm,
+				   p4d_t *p4d, unsigned long address)
+{
+	return 0;
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 static inline void mm_inc_nr_puds(struct mm_struct *mm) {}
 static inline void mm_dec_nr_puds(struct mm_struct *mm) {}
 
 #else
 int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address);
 
+#ifdef CONFIG_KERNEL_REPLICATION
+int __pud_alloc_node(unsigned int nid,
+		     struct mm_struct *mm,
+		     p4d_t *p4d, unsigned long address);
+#endif /* CONFIG_KERNEL_REPLICATION */
 static inline void mm_inc_nr_puds(struct mm_struct *mm)
 {
 	if (mm_pud_folded(mm))
@@ -3633,12 +3664,27 @@ static inline int __pmd_alloc(struct mm_struct *mm, pud_t *pud,
 	return 0;
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline int __pmd_alloc_node(unsigned int nid,
+				   struct mm_struct *mm,
+				   pud_t *pud, unsigned long address)
+{
+	return 0;
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 static inline void mm_inc_nr_pmds(struct mm_struct *mm) {}
 static inline void mm_dec_nr_pmds(struct mm_struct *mm) {}
 
 #else
 int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address);
 
+#ifdef CONFIG_KERNEL_REPLICATION
+int __pmd_alloc_node(unsigned int nid,
+		     struct mm_struct *mm,
+		     pud_t *pud, unsigned long address);
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 static inline void mm_inc_nr_pmds(struct mm_struct *mm)
 {
 	if (mm_pmd_folded(mm))
@@ -3710,6 +3756,32 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address))?
 		NULL: pmd_offset(pud, address);
 }
+
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline p4d_t *p4d_alloc_node(unsigned int nid,
+		struct mm_struct *mm,
+		pgd_t *pgd, unsigned long address)
+{
+	return (unlikely(pgd_none(*pgd)) && __p4d_alloc_node(nid, mm, pgd, address)) ?
+		NULL : p4d_offset(pgd, address);
+}
+
+static inline pud_t *pud_alloc_node(unsigned int nid,
+		struct mm_struct *mm,
+		p4d_t *p4d, unsigned long address)
+{
+	return (unlikely(p4d_none(*p4d)) && __pud_alloc_node(nid, mm, p4d, address)) ?
+		NULL : pud_offset(p4d, address);
+}
+
+static inline pmd_t *pmd_alloc_node(unsigned int nid,
+		struct mm_struct *mm,
+		pud_t *pud, unsigned long address)
+{
+	return (unlikely(pud_none(*pud)) && __pmd_alloc_node(nid, mm, pud, address)) ?
+		NULL : pmd_offset(pud, address);
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
 #endif /* CONFIG_MMU */
 
 enum pt_flags {
@@ -3812,6 +3884,19 @@ static inline void pagetable_free_kernel(struct ptdesc *pt)
 	__pagetable_free(pt);
 }
 #endif
+
+#ifdef CONFIG_KERNEL_REPLICATION
+
+static inline struct ptdesc *pagetable_alloc_node_noprof(int nid, gfp_t gfp,
+						  unsigned int order)
+{
+	struct page *page = alloc_pages_node_noprof(nid, gfp | __GFP_COMP, order);
+
+	return page_ptdesc(page);
+}
+
+#endif
+
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..05853e4fb266 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6906,6 +6906,28 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 EXPORT_SYMBOL_GPL(handle_mm_fault);
 
 #ifndef __PAGETABLE_P4D_FOLDED
+
+#ifdef CONFIG_KERNEL_REPLICATION
+int __p4d_alloc_node(unsigned int nid,
+		struct mm_struct *mm,
+		pgd_t *pgd, unsigned long address)
+{
+	p4d_t *new = p4d_alloc_one_node(nid, mm, address);
+	if (!new)
+		return -ENOMEM;
+
+	spin_lock(&mm->page_table_lock);
+	if (pgd_present(*pgd)) { /* Another has populated it */
+		p4d_free(mm, new);
+	} else {
+		smp_wmb(); /* See comment in pmd_install() */
+		pgd_populate(mm, pgd, new);
+	}
+	spin_unlock(&mm->page_table_lock);
+	return 0;
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 /*
  * Allocate p4d page table.
  * We've already handled the fast-path in-line.
@@ -6929,6 +6951,28 @@ int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
 #endif /* __PAGETABLE_P4D_FOLDED */
 
 #ifndef __PAGETABLE_PUD_FOLDED
+
+#ifdef CONFIG_KERNEL_REPLICATION
+int __pud_alloc_node(unsigned int nid,
+		struct mm_struct *mm,
+		p4d_t *p4d, unsigned long address)
+{
+	pud_t *new = pud_alloc_one_node(nid, mm, address);
+	if (!new)
+		return -ENOMEM;
+
+	spin_lock(&mm->page_table_lock);
+	if (!p4d_present(*p4d)) {
+		mm_inc_nr_puds(mm);
+		smp_wmb(); /* See comment in pmd_install() */
+		p4d_populate(mm, p4d, new);
+	} else  /* Another has populated it */
+		pud_free(mm, new);
+	spin_unlock(&mm->page_table_lock);
+	return 0;
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 /*
  * Allocate page upper directory.
  * We've already handled the fast-path in-line.
@@ -6974,6 +7018,30 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 	spin_unlock(ptl);
 	return 0;
 }
+
+#ifdef CONFIG_KERNEL_REPLICATION
+int __pmd_alloc_node(unsigned int nid,
+		struct mm_struct *mm,
+		pud_t *pud, unsigned long address)
+{
+	spinlock_t *ptl;
+	pmd_t *new = pmd_alloc_one_node(nid, mm, address);
+	if (!new)
+		return -ENOMEM;
+
+	ptl = pud_lock(mm, pud);
+	if (!pud_present(*pud)) {
+		mm_inc_nr_pmds(mm);
+		smp_wmb(); /* See comment in pmd_install() */
+		pud_populate(mm, pud, new);
+	} else { /* Another has populated it */
+		pmd_free(mm, new);
+	}
+	spin_unlock(ptl);
+	return 0;
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
-- 
2.34.1



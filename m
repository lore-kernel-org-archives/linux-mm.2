Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91592EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D616B00BC; Sun,  5 Apr 2026 08:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053326B00BE; Sun,  5 Apr 2026 08:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84096B00BF; Sun,  5 Apr 2026 08:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA8196B00BC
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EB2FC3288
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:49 +0000 (UTC)
X-FDA: 84624499218.19.32F18A1
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9CE90140007
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hVyFQxCR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393747; a=rsa-sha256;
	cv=none;
	b=MmAeiUxo9AB3wTSENt+yEZRdAX1eus3AhSpkUtjMWk/YQLZrgkvQHxm3Brv44C63P8SEF2
	g1RiMXIskZqpkjY9xunag7ZxYEegDtEwAiuaBlm7zSIDFXOcr8pU/ba2iLlVoSs+FvHgSi
	9LIWcreJyE/AIJQNtZmtOE4RuLujUdU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hVyFQxCR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sb6cTU6E76tVxQHa/I/Ro9Ws0lLMXSEWXuSGv9owj/A=;
	b=TaSPauGlU9xWFtqw4qo0Ycc3hjbUPsK9SxXQbaqYIUegJuI6PGfLa/DBGMbL7McZ9nv5Ru
	CxI8Jldx5b5IabLOMnLKaZsmhVsLid2XFduZZX8od7LuqxdJQq/WRGcrlQMtK5sryADs1m
	zkYU/6ACGCr0ORu5ChOVkib31EQKaLE=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3591cc98871so1313260a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393746; x=1775998546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sb6cTU6E76tVxQHa/I/Ro9Ws0lLMXSEWXuSGv9owj/A=;
        b=hVyFQxCRi6+hv9+zcbGqBe5eObL2KFen1wk8KOjXRxMrEa7aN4Z4RyGvbnFddg45Pv
         eCLBd2Se/zLnMbPM3sX6zSR3xXXyhXwmUSgNLTaaqiAryfBnus8FHzcW0hdUxtEUxtc/
         BG5pYnljaZ20zsEFZhwT+oD1DexoBXLlSzRlfFGGptTJlgTCupqo0eqbzzvPX7LfPso2
         KTQFqcYOc20IyD1IiNMiMy2tRUdjbyGkIEXx237Mus+jDhlowve5lgPL0bSYuGU0JL/X
         VcjgykYeunKnyd1eBHyIKJH0W9Gbvxe2/HtiK+eMK/zFGLN/fTvaRtCDXQUvk8KcFTh1
         3dmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393746; x=1775998546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sb6cTU6E76tVxQHa/I/Ro9Ws0lLMXSEWXuSGv9owj/A=;
        b=UV5cUT8kZNNskaXvz0ekwJCugN5pj32RxyOUn8NumMsdIcovbluD9nRgRYBwtJEg95
         c4UZLrwX/YM3qKApIKlaXBomRmVQf+Te3ckEVX1/x7fyL1kBAx6AbC4CJbI7ijaJf+nM
         stFQfoXJhls7ra/koHtFt5pldLQ2u9o6am06ukbNtJ2gChc7CZc0/HWbwhJLiMmv58Ns
         osToD1834xV9LLHA1xGQQ7ylTu16EM49R6kija1mOJ0x8pnE8gSnr1XbA0JPLIcITnQq
         +pgNM+mXd8zApPYd58VsikezxSvaHstjRCKoSE2OVVydK0AzoLvXQA6bX18R57709GPD
         kYKg==
X-Forwarded-Encrypted: i=1; AJvYcCVsN/8y+mHsMvwDZcMMN6KsPmUQeORN23Yu1Y9MpkVA9onRnP3rFtrzt8XqnLCV6UMYd9EgzZz6rA==@kvack.org
X-Gm-Message-State: AOJu0Yyonk114vRpC4qm8MEgGfE7g8ZOpWAEK4T5dOWtEfZYfwUcxRQh
	y9d98fPH0FiHdJCbYi9T3mH6Y0gEcXgVe2MpJKJEqQhdkaJa06M9JHEZUAsZXePBcPA=
X-Gm-Gg: AeBDieuUl5/t8ZjflYSRJn9ffGsmQVurGENs1MjZjLZdwbkjZhH4dRwiM4MXqS+L/HV
	kbb9pBhppfhzT4UBtK9GLo+ahW4TWlcP3Hhb4XZHuEEzhBAD/1wKocbMPjDI3GyMHuUn2WyPt6f
	LBeyGpRFxIzFfz7rkdF9SYueiUiXD3pW3f5sff3BmINF7K53nZpJ0iC3lAbGtOy6d3R1A1mzzJ3
	8h5+rW4/+51L7qg8KlXwFCHhHe5aZOcJfmJ7vJalpneSl4muLrfltcPUeWVM9nK+wb1cwJs+rQC
	0neJk5lykigKKg2G0rl/IJI6oqUUTLqz2RWC9KOmRSosEmffkJd7/x925kKdkZhPh4yEr1+xN0m
	KGNeh47aSDKz5aNaDuL7RmZeloKAP9HgjiOD/rpe0vp3P4yh7Wn6LqYax5GRa0fxrsBMqBPUcS4
	Xac1ro/R0w3fbUBl0QWvktbLN6I8m1Y4QhtxuDLmHea2g=
X-Received: by 2002:a17:90b:2ccc:b0:35d:a0b7:9608 with SMTP id 98e67ed59e1d1-35de67dc7d4mr8298573a91.7.1775393746346;
        Sun, 05 Apr 2026 05:55:46 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:46 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 22/49] mm/sparse: introduce compound page order to mem_section
Date: Sun,  5 Apr 2026 20:52:13 +0800
Message-Id: <20260405125240.2558577-23-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uijpg3zpq16bmi5ooisfeawxytoqrjgj
X-Rspamd-Queue-Id: 9CE90140007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775393747-106838
X-HE-Meta: U2FsdGVkX19XRNNQgrdLVMJ0tZfHdnMfik843qQIPZU4FGv2+CcQUqXW3vGoxLITsXVdyjquD3X2zQDiIqbYy571TbTNkyFfMha6aT0AuPFfyEtL0z1TZkkbtFYWmKMp111p6e6mpbj2Td9DPOckbJtPRFNwSPxtUsd8YctjumYB95kPJ2zmW9lRNtSINfRbo/m8DQzK5R+7SlPAufr2BisjebheGepbshEx0MwQVOWLnB4hhXEH1NF8lFlso5hYJo1Yz7GbgbXGPMLN46L4gxK59AtGb/Yo1BqVmJSnco37liggLAbSYfJAE4qp7iv4wB0ZsMBrMly21k9/2l59MNh9cJAAYw/w3QOz7GLvUoK07t4S/qN53LmbfJKl1Ph069V2lqOm06GgFY4ZH7SlXSBUj/mA4qV2lan/vKDl2L09xoeAnzFwxeVVvwAzlqUMJcpwO8o4oCaoBOSht4W9Es49bJZtvLRCXgkK1uVTdWKazaRjKx0/RDlxrWAmKVaGUCV3+pKllKueLu3xgkSyGEbIMsm1CBiKKayjonPCFyRLYv6B7b1FsVgLTxNy2MAXMXscp82cqyZ20muE9hX6R4iWiZK6uISEyAYHZnsI11lWVy3a21pLuPhqXEcJjAZ/Ykswx9gv+cFBcM+TRPmGZHGkY7K20v7NRnE8IF+8ISuraKGZZm+7s5IxdoRgGCva8iKrjTwtafMHYR7Q64yvE0fNFDfLtJV9YftIURySSRkONwwDpr47AikEXSDmiOGZiE2FygY8t5DDB0UqHAk3VubvKClE3p2cjCGD4fOgjPbOxR0yM2AbDnjJit+wi/kn+zNbQhp7KOsVodCMLB09mRtMDFHRKQ9QS3/BhZ+idrvqI5/dyl+mjGBxP69okCGVnpHXzGU5qzY7kJgy2IedmxMdbJJ1M9bU132zxmJjRMPSN7LdThUfKMR82RxRuvgOBuzXlW1i3UBHOYmPBvs
 fhwN6gjq
 feAAP+kka1Mxv33Od9DCMGrYZNUqf8CqPHlj9YnBf5p+qMlFxA9CK8gFZNVwAe+u3Y5ielNRalnoaXQbAZeyko5sDTYEBAInHNHp8jcd8g4ZFuVF85HKXysqNMytttDHa5gJbY+Z08SvtU32edfBCvEC7okK17dXFmbeohmvojPpCsl972VGSyMCc5DERjk/ARsOlYvWT8RucbQr4NLuE0rCu2dXpdT6ZwXLSO3ye5YkmdqHH1XdGsKFNmkqPacA0JGuFngHJeVLhmV4HnBPhMBmhWu6aOct9raMloIPnYXDx2R2KL8hkK6R1cx8Hm3ur5g+7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During early system boot and DAX device initialization, the establishment
of vmemmap page mappings via __populate_section_memmap() is done on a
per-section basis, followed by the initialization of the struct page area.

Currently, there are two scenarios utilizing HugeTLB Vmemmap Optimization
(HVO): HugeTLB and DAX.

For HugeTLB, the SPARSEMEM_VMEMMAP_PREINIT mechanism is used to apply HVO
(with Read-Write mappings), and later, vmemmap_wrprotect_hvo() is used to
enforce Read-Only mappings. HugeTLB has to manage its own related statistics
and metadata updates; the work done by hugetlb_vmemmap_init_early() is
somewhat similar to what sparse_init_nid() does. Furthermore, the shared
vmemmap tail pages allocated by vmemmap_get_tail() are left uninitialized
because they would be overwritten by the subsequent memmap_init(). We are
forced to compensate for this in hugetlb_vmemmap_init(). This limitation
also forces us to maintain two separate implementations of vmemmap_get_tail()
(one in hugetlb_vmemmap.c and another in sparse-vmemmap.c).

For DAX, HVO is already applied via __populate_section_memmap(), but it
does not employ Read-Only mappings, which introduces potential security
risks. Moreover, the fact that HugeTLB and DAX implement different logics
for what is essentially the same purpose increases code complexity and
maintenance burden.

The root cause of these issues is that a memory section is completely unaware
of the concept of compound pages. It cannot properly handle HVO or struct
page initialization for them.

To solve this, introduce the concept of compound page order to the memory
section (`struct mem_section`). Typically, a section holds compound pages
of a specific order, and a larger compound page will span multiple sections.
In the future, this order information can be utilized to unify and streamline
the aforementioned scenarios.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e3755666846..620503aa29ba 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2014,6 +2014,14 @@ struct mem_section {
 	 */
 	struct page_ext *page_ext;
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	/*
+	 * The order of compound pages in this section. Typically, the section
+	 * holds compound pages of this order; a larger compound page will span
+	 * multiple sections.
+	 */
+	unsigned int order;
+#endif
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
@@ -2210,6 +2218,17 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 	*pfn = (*pfn & PAGE_SECTION_MASK) + (bit * PAGES_PER_SUBSECTION);
 	return true;
 }
+
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+	VM_BUG_ON(section->order && order && section->order != order);
+	section->order = order;
+}
+
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return section->order;
+}
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
@@ -2220,6 +2239,15 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 {
 	return true;
 }
+
+static inline void section_set_order(struct mem_section *section, unsigned int order)
+{
+}
+
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return 0;
+}
 #endif
 
 void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-- 
2.20.1



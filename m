Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD379F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAB36B00DE; Sun,  5 Apr 2026 08:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B456B00E0; Sun,  5 Apr 2026 08:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8DE6B00E1; Sun,  5 Apr 2026 08:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7D86B00DE
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:57:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0739F1B8EC2
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:46 +0000 (UTC)
X-FDA: 84624504132.16.540FE6D
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 32FFC4000C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Qy02JYP+;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJ+KumqAX13hYqdLVZVTFF+dZIRX9xi7vByMiu7tcmo=;
	b=pcOeWbwNpxlI1smDN7JCGVs28OKUHu5BaFL+uS0NsyxmEv92kTQ+8/mnN4aGMeIggxt8Ib
	o9Vwg32megm/vcZH9fyVzH6IXQxDnBcrk2xufZNpS0NsXFTYYOxhQ3z00+BG9B9RdTGUvP
	JsH0V5fKswU6vQPBXsSU7MJroYa8dD8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Qy02JYP+;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393864; a=rsa-sha256;
	cv=none;
	b=SLoHrW3OVn3JQDa89xyP0dunXf0awxza+82ZD5+4sHUtZaGBGDaTEniqQ6Xbk+jTa0q2Gf
	GNylqflwE23VYTQ8tL6JSITE58gPEFVq3ILqMfR9qdQ2e6Prec/2OjQwcGiWsGmL3dmfA3
	uaLbeqD+GRGwzDaXT5Y4kaJniBcUMsw=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35c1a131946so2405386a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393863; x=1775998663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJ+KumqAX13hYqdLVZVTFF+dZIRX9xi7vByMiu7tcmo=;
        b=Qy02JYP+eAyjoTEPoKItpvZRF1V+xV0hH190NaUVnI1wIUkFDwFONy+ckOtOQ2L7+F
         K75iZFPcA7SidIPCReZyQrwcOs7b8/4SIZxH0tte+MjUpoNGhm/wm4H0dUgBNUyD0Eil
         /UJDpOKEzWKLmIh6eZJ+Tr5LoeR/lEyRER2HdH1J401BwzDdT+UzIe8EGZv1DkfONTED
         51ghmShmpiosOc4rt3Kf7yr42dpGT4n2p9Z6CQnnrzzxfPY73IZDfjkBHCOZcIhKnNz6
         nu3BcSmarFqe+q40/ZstCqArAiC58NA10/NBAaQ7TolbuS/oYI1wDfTnrTuPA50cd3LC
         egLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393863; x=1775998663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FJ+KumqAX13hYqdLVZVTFF+dZIRX9xi7vByMiu7tcmo=;
        b=dxmlhvDHDUsFsBn9zZB0KCuC6vnWvxs+6zjXbUnPwn/GXob8DjUrNAvlCSjOFFqC6T
         qJ1OIwGLorQw/racEaz+sygeoRh2XNpWu2P4Qe7z3jjYOoNNFJL929AgSJ1E14CDSz24
         uSBYxczW6ZPCyTcUbSoQZNde9VxNlZci6SrK0dHiitIE7WMlwvnIGIrh2rOvtEX7qhg4
         02p7Q9SGuu625jEzJ2sAwytatwvEAbTRjFZD5I+Weg9DX9KMCPXi9XYB7XiGEPexrMWg
         emEayl7pN2JqlEJljGaTjTYlrajT47nECdsjCIcBUKg8bbzy02HG9VN3kFzmfI783Tue
         Zspg==
X-Forwarded-Encrypted: i=1; AJvYcCXc/jY9zbq+5VP07sU2LkQrlclUBFtEANd6DpEbs8VkryGUz3ckjk9FHDj+6TxZj30C4c5GxbxR6Q==@kvack.org
X-Gm-Message-State: AOJu0YxfheLJrNuGXW19vxFbWyQT4IjobFh+fxhzjH53VJG+Xjzdgasg
	Vl1JxKvsfuXgNRKlHMon3yvarlKvjVvQMHG+ddtue2j+fptTEhv+ioQ1IWe55YeYadI=
X-Gm-Gg: AeBDiesm8RBFOGJdX1C0eL5kT454wzU1zADUxJen88TXO09ot+rIG8ymnRSBE9JtvjY
	zcBCa7KanBHXd6rSICaw1hz11XGu9RqqBg0IzfpAzlmBrJzsAxmDFJBzztQENwwyXiCMhmilnTz
	nZt9vjsRPL5ihiZMj01Eia8Lu2xP0kydiu1JICidy9uMSE/RsNXjMsK68m8obyqAqjqN4So1UzP
	F74KRKKiOsSK+DNaKWg6PeDr1y7cC51BI9yZURYHslqwYxckqfYgJ/b99/NeGkQPPhlkKpVbI1M
	EXTmFbC5XLn+6+LyE4Q0NaHKuzPrk357dPO4EJc0eeny5R5bpc4G7vzRW5cGOK/kGO6782YNnlp
	+x0CDgRD9edbEfxXX4dEHbHPmChne+2eJlodqoxQXj7lfTVbcK4ILX3ijxjLWA0EsZqpkn5AsSh
	BOiBwniuml/kNU6pQj+u6F7a15R5gHGk1LXXWxGTf3TY0=
X-Received: by 2002:a17:90b:3f50:b0:356:21e9:73ff with SMTP id 98e67ed59e1d1-35de5c3d5b5mr6803962a91.11.1775393862969;
        Sun, 05 Apr 2026 05:57:42 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:57:42 -0700 (PDT)
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
Subject: [PATCH 39/49] mm/sparse-vmemmap: remove unused ptpfn argument
Date: Sun,  5 Apr 2026 20:52:30 +0800
Message-Id: <20260405125240.2558577-40-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bbpqomrc3kcycykt4doo5pb97g5jkbuj
X-Rspamd-Queue-Id: 32FFC4000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1775393863-848069
X-HE-Meta: U2FsdGVkX1+sTq3SMiEu1SKVt/wqjvT335vaP2wQmzfG4JhTRgI4MYkBZIo6DdEjPQwIq7mcgyXCNHTsv8uN6rR9haFoXOkSjQLxdSOltTkvGAmodIo+9SfSAo1M1P+Sc2Waz2OoRp/uhB5jgR7FL0Sz5Sw+/FtCDIZgeOJx5Ub4kEz++mdpHkU/CGq0UnyxWi1+g1DW1x5VJ8C5braPVBZRs2D0IHQmh4Fy0TT98xbJbCxxab1yi0M+wMSzPSLu8Qhx6UJyG1bvrfHehdf2rAgK1ezPeClo4+s8k9VeHnSmJiPPE1eni3OpAmuhIpkjnq39Lv0YtmsyNlgbu31l8ZtN201LgcDqq0CRND9tkw7F18NN8mwOA7rGZ1E1qA0PlxJShLRsGGiM3S8q87Bk7Z5emtWgw1ZDKhBONDtzAzO4kM9tPRxuyDOjtfW7RFnIqN9nfeCdl9k8tMCokjzbTPTa2z8COCbC/TIAaEfoYikR7tUdIzENTpVdapsIO3ywoHu5PDNo54w3csl/Q0kySEjJXKCJAvSRe8DBd4CKY9VJdPDDfx8+6dAUNzkBlc/z5o50dzhHXdDOKl7n+qSvSCbgPbF5/PVEPxJ5T8JM9CbYUqDxPQf8K1lqsdnG9etgxOnhRXcP5UXYnEHmO8idnpvvmGZiFp1dljFYGnMEiIt1hptr8847bhETUzw7xa2plWnzlXt4VkciEDld3nt8/5vop7Xjsda3FFHbVJPMgSqfnWfKUmr9zOeoW1sd6kOnbNsHa2dPemOfg2OhLGRsS5SrQ/VcSd3/kzyg3rg8AFghcqTmwJfd44XcaPEiMwRq3Zbmd9QKY6sIv+QU2Xlo2wi1UAhrwbYjOi4cL+mMwvOKx980rlJEE1THRT55Tx5gNCfdgZRDObvQFzKjj6h3iCJhdplB2QHBIsB2RtfNTgvHA4PCs5oyKcuzr2uCqm1LRNCaeXp/krMnOwL4vjR
 eE/9WXrY
 ddVR/lrcwc0jMExIMErRPGrewws2bQ02mr/PAiLEwvch+iAc8jDPYEKj7nI5ZujDohLZNMWWU6l2Fyap4lV/KAzadrvQRUHiFS9eXzLD9FB4Fp2Oxf+EWs8YrUlSqc5UEJ3OMMb+JLXaNDtRzcwNsLfiRV0vhSmSoyL87GBPxxhv+AJccDwJ+WZb+WKb4aQf5CjrVQZKIgn8FbVjbuYYgEFBP28XdtV82xE8FtnMuVhEk/Hoz0EOzjHq1/BqQ30uJgt89MPwrq+aoZhLWl1sUwL3PqzrNxvBsBt+hArVGPdd2FINt/6hcypIrT2CR/QY4EESO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ptpfn argument is unused as it is assigned unconditionally before
being used in vmemmap_pte_populate(). Let's remove it.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index c70275717054..36e5bcb5ba9b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -149,8 +149,7 @@ static inline struct zone *section_to_zone(const struct mem_section *ms, int nid
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+					      struct vmem_altmap *altmap)
 {
 	pte_t entry, *pte = pte_offset_kernel(pmd, addr);
 
@@ -175,17 +174,15 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		 */
 		if (slab_is_available())
 			get_page(page);
-		ptpfn = page_to_pfn(page);
 
 		/* Remap shared tail page read-only to catch illegal writes. */
-		entry = pfn_pte(ptpfn, PAGE_KERNEL_RO);
+		entry = pfn_pte(page_to_pfn(page), PAGE_KERNEL_RO);
 	} else {
 		void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 		if (!p)
 			return NULL;
-		ptpfn = PHYS_PFN(__pa(p));
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
+		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 	}
 	set_pte_at(&init_mm, addr, pte, entry);
 
@@ -255,8 +252,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+						  struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -276,7 +272,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -292,7 +288,7 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap, -1);
+		pte = vmemmap_populate_address(addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
 	}
-- 
2.20.1



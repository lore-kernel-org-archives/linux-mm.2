Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9B78606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qumxXpnF
Received: by kanga.kvack.org (Postfix)
	id 08D7F6B05B4; Thu,  5 Nov 2026 03:02:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03DE66B05B5; Thu,  5 Nov 2026 03:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95FF6B05B6; Thu,  5 Nov 2026 03:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CAEAD6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:02:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8BFBA0997
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:02:51 +0000 (UTC)
X-FDA: 85400324142.20.099D83B
Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92092A0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:02:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qumxXpnF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.14 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793865770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxtCL2T8KiQqlFgNcp5VFWE9VcQtrK6ENswsXI1n4JM=;
	b=u1SlBsgksM7Q6inAAXmA+UorbyQya73a5m/p25YzZcshp1aXwR4yxrtJQRvADJryVH9B1O
	rtEtNq/W4Noc6RbEzb5+xrsX+pGvcp6eSZjxh811K6+yeOfN2V1hTEdSr0toStHr+NOSGi
	+XyNh1aWJlv1JBHvWW7xVGOGdjlrfvU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793865770;
	b=tMmo2DB3/KZ6Vn6h0FKf83vQYE413aEJo1oiF3Vq/nwYb0xPsQv9wJlpbmYT5wQAnJDxVN
	O1nOxPWtESTBF8DbNSa/u8ZLc32ozNX4VLSKOCyn6r61DgSI4Q8N/4ASYs30InVIsTBC1v
	MsUFNF5SLzXBD7naF+Eus3YFcOT8yH4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qumxXpnF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.14 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7jP/rJr+RjhHJpfHb2z4eMviiB8ovnJGAObKcXmPABg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793865767; v=1; x=1794470567;
 b=qumxXpnFUFKkkDyNUaOVORlqtd3XqCGh5A2m9LCjo1SrNd+9biBl2y4GqdZA9jIIbuxl1dW0
 7scWFr23yOz6QmgTCLbC5BRoXs/2mbbp7M/w6UY0J5JhjKuLDmz8pM5g2VIOduIxGndZ8esKH3M
 vJztjno+jhAX8iKR2MFMmK8E=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c7e6f45eb6351582;
	Thu, 05 Nov 2026 08:02:46 +0000
X-Mizu-Trace-ID: c7e6f45eb6351582
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: sashiko-bot@kernel.org,
	songmuchun@bytedance.com
Cc: david@kernel.org,
	maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	lance.yang@linux.dev,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	osalvador@suse.de,
	qi.zheng@linux.dev,
	muchun.song@linux.dev,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	linux-mm@kvack.org,
	x86@kernel.org,
	linux-s390@vger.kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com
Subject: Re: [PATCH v2 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
Date: Thu,  5 Nov 2026 16:02:41 +0800
Message-ID: <20261105080241.57241-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <sashiko-outbox-198652@kernel.org>
References: <sashiko-outbox-198652@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5h4echzwjqtc8mmtcs3goo3pidsku1za
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92092A0005
X-HE-Tag: 1793865769-996314
X-HE-Meta: U2FsdGVkX19q3J6KEUGA4uh9plgyIUdhlAPeorxRJ4tmW8gAeJl+XWbfXp222H6QUBt/0xoNtPT/ch9NK0M1whsnAQZuS0TldLe4SuacUG+Zkpadgo6G35RwFN5FhmQ9JeTUJWrE+89VJ73OHN5f35kmoHVwNcQJa6Ac8uH71v3LHLKnnHSBj1UrDQfGUMe79wVLjBRJ4TV7xIC6XUgZ7RpQ77vrlsGZRYbAjNPjbY3A/S9NLCqjXKXRRWBExlLOEVgHoqJ8QAO5Aelb2LM92CnotTkdq67SVGGSr6zNfczaK0tb5Ka+MUjZcJU1wAt6stjuUpLKbd5SJmjWhiqF06TDI4iJBNEQVw6/823coh3DlzZq6EzuJI/JM3DImv/kBWbK93At3v7KTYC/3uVNHBY25KyWmwLFlhjEVC8JF5FNeOU1z0C2hzSFA+0Gm9pFypAd8M3swKYwZOW92L6yT0cPddf3EuT5AVpbW/EP6JK7zwNHexoprVRdEHSnGjNp2HKnKVUi572qtUJjcR7OgE1ut1PI0Xe6sQcJY6xu1A8B0jdFvegaEACFSrQczakiK+9y4FynoICYc4B43LzTW1C6Nrb5Smw407UOaOxpQ8A45sjw/h1W/PcUAhZEjcdgmPVeYS4N6cJhescx1GZy7/gVfZ+qfIks2A8C5w10yA+TlIEnvRb+B6vUN1kDLMN1A80WOOJw3wYOOEkMAh3gvuWPpkKfF5lDsKzSTnxbnvJ/lw2kwOH/3EfevTnsdiRx2WW7r1P95E6swcNv0B4Cg2D1I/4UPE/EFpUiAFTPZnk4+rRVMNe5ZhmFgoj+IMNmj3FYo5BbOQufdQsGP0upbp3gxM5lGnzhPSml4YgdrU20pI3tFzxC3QqyJ0tJxMvddRjsyjdiFV8lSu/5CI4FbaLOBJCLrrMonGFZ9PIvy9ykt6hSn10+Ls6NIe52fL+ungG/u5D1YBV858cLzDN
 wtwYiLAp
 cmd/nH1tkPWg5EiZKRGY59g6LzlXYmESyRHxE87voPy2xUiaeii9yU5NuoBU5q/Z7K8iz1zcTtFGO0DMoskr/fIeNy0GROYtuc+8QZSQkPE8u2cmNDvNuqbxXpP0N12geCtMumunOuv9Mb/yXuoOo1EaRYt51xYFsP6LPJpjO1t23HOJCRRxebWVv83a8BPv8DGhi0/UFuzB3/TvpZTz12APxI1Sda8frIWIGRzHASnTSUgr2ZQK7CoD82t05qnbMzyLkhsCugjxWbAlFiyr9Tc74pBMmjrp+4ARCE+QCQLS+WeU2HJdGyRSheywEafBM+uBSIFSNxO3Y82QKFj5RF3IwXxzu5WAj+y5rMkxdGYWfmFf5IGcIJlxkBXT5IbKCDgZB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 07:16:48AM +0000, sashiko-bot@kernel.org wrote:
>Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>- [Low] mm: undeclared vmemmap in section_vmemmap_optimization_disable()
>- [Low] mm: define vmemmap_optimizable_order() before section_vmemmap_optimizable()
>--

IIUC, on LoongArch, asm/pgtable.h includes vmemmap-optimization.h before
defining vmemmap.

How about taking a PFN and page count instead, and leaving the conversion
to the callers?

---8<---
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index c91afce46136..5a3a225135be 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -143,7 +143,8 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap)
 {
-	section_vmemmap_optimization_disable(start, end);
+	section_vmemmap_optimization_disable(page_to_pfn((struct page *)start),
+					     (end - start) / sizeof(struct page));
 #if CONFIG_PGTABLE_LEVELS == 2
 	return vmemmap_populate_basepages(start, end, node, NULL);
 #else
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 4d6928f717cf..43c98aec29aa 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -283,7 +283,8 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		return radix__vmemmap_populate(start, end, node, altmap);
 #endif
 
-	section_vmemmap_optimization_disable(start, end);
+	section_vmemmap_optimization_disable(page_to_pfn((struct page *)start),
+					     (end - start) / sizeof(struct page));
 	return __vmemmap_populate(start, end, node, altmap);
 }
 
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index 9d9f7a67d195..0501234ab16b 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -76,11 +76,9 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *section
 	return vmemmap_optimizable_order(section_compound_order(section));
 }
 
-static inline void section_vmemmap_optimization_disable(unsigned long start,
-		unsigned long end)
+static inline void section_vmemmap_optimization_disable(unsigned long pfn,
+							unsigned long nr_pages)
 {
-	unsigned long pfn = page_to_pfn((struct page *)start);
-	unsigned long nr_pages = (end - start) / sizeof(struct page);
 	struct mem_section *section = __pfn_to_section(pfn);
 
 	if (nr_pages < PAGES_PER_SECTION) {
@@ -119,8 +117,8 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *section
 	return false;
 }
 
-static inline void section_vmemmap_optimization_disable(unsigned long start,
-		unsigned long end)
+static inline void section_vmemmap_optimization_disable(unsigned long pfn,
+							unsigned long nr_pages)
 {
 }
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5777f2e29684..64bc346d0fc5 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -474,7 +474,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 
 	/* Altmap-backed vmemmap pages cannot be optimized. */
 	if (altmap)
-		section_vmemmap_optimization_disable(start, end);
+		section_vmemmap_optimization_disable(pfn, nr_pages);
 	r = vmemmap_populate(start, end, nid, altmap);
 	if (r < 0)
 		return NULL;
---

Cheers, Lance


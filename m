Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A398E1099B47
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CF36B00E9; Fri, 20 Mar 2026 18:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134696B00EA; Fri, 20 Mar 2026 18:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071CF6B00EB; Fri, 20 Mar 2026 18:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9E8E6B00E9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C16D91A03C3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:15 +0000 (UTC)
X-FDA: 84567845670.11.B936E78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3645E40012
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYJKP7zl;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yaq1J6UyWRTF8acDLXtbPnOB3o7G2szMILjfPx6Y18c=;
	b=UQtX9CyGpF2XZEuf9p8sb4+XypoiieCAFxcUeaYO5xORea91UZZ2d/jt2xJI0r+KMuOkoM
	qBSjkzgaDelCamGaCRHMBMjqGdHKpIKrQpmaecANm/8UPmuWdjTtmEELyuVkYC+IcHiCZR
	gLyd2dsmMyBw6CY/SlwxenralnrcVJ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BYJKP7zl;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044854; a=rsa-sha256;
	cv=none;
	b=oN6EtrtF0sElXdSNAdS6JC2sOWJRnsDZHq8tQ0RAAGfj1DITDLcmPvdoR93Zs0ejDy75iD
	DvHlgajBjRc1EWuHh68cyoCx9pK539sDjxygN4o9vi6gPTX+f43Cys1rpBLsO0zRBvlkgq
	oeV2h8Y5irz4i3Hbx5TSXOKA93xjiu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C10C660132;
	Fri, 20 Mar 2026 22:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD735C2BCB6;
	Fri, 20 Mar 2026 22:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044853;
	bh=QZECcZOo9XU6VE0O+G1ptFNqIVCOuWAko6C1OasJr/U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BYJKP7zlv4jBTvu80a24WL8Ct5aU4DcbuPl7DomVKZQywcFSHmDul15sUSZzpOS9w
	 VGpkVDDKudEKjzp330WynQpTZJarltWaw0dHJ3u7eeAic+bRO3z2vaoJXKeKE8CzXJ
	 Hlir4vVzCgO/f2OKDKqS8rRg5eQw0Vi39t7NMLD4x1kMCvNqs1ghvWraXEpRmdgbkJ
	 ouDmSeYe65LVeauMLiEz99LE6nUEBfU2ntRObRZhG73T8ceIv43bw4PDm71NWkHgYS
	 M2POdUrqX1hIGxGX4jWTxYwJH7i/lYl4bma2SJk/M0epQ5B85WZGwtmdA9RUsRNrzD
	 BZVwwK53Fv3qA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:39 +0100
Subject: [PATCH v2 07/15] mm/bootmem_info: remove handling for
 !CONFIG_SPARSEMEM_VMEMMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-7-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3645E40012
X-Stat-Signature: qxup6uu4sr8gb6bqicn59niazmie3hma
X-Rspam-User: 
X-HE-Tag: 1774044854-693020
X-HE-Meta: U2FsdGVkX1/9DyhTt31X1D2XjG7gBVw2jCMqXUlCwJKXb5fbG8wRdLFvWn43EiQUmtOZbYCFb3Yv69Akh9EgK9qZhAKo4tjcDCdv99ipYeJnqDc0KyJJ5nf7Oeiu+Cb6XIZ63IRYAuVVTyOdSC089G3XnEd6hiJ2Zf1PG9x3+pH0T3jrNz6zhQ+y546RbbUNi7gFSH24DiA2gkNKxAIgBDm1C4/4yEVcl9HFxXe0D9JNqohBk6IklyFvaRoF62wgHmVO32inH2CFQXxVdfXia8yBp6x8E1MduQ3WxyyVIG5/y0oULoC0dAd+Dv7uqZRHJSrPILBIAIlrR3X9k8vvPHXaSR+rzxhBTZw3vz3S6O2Xvn8vBT69IMdl03RYORZocRicQrkQ8sWyE8SLXUuhzHE5opFujFTuMqoSJ+fhBplBr23Sk4JgtdlM7HFEpNC0kTi8BiCYSWvFvtVAJkTSE7UpJYj1hrgQKnC7eLlSGPqec/8qOUgiHmDFJiKrN8w49kAide8xCkXjDmtLPhNNX1QN7MW3LIGVghlgq+n5qK6c8zrIUp/zKNV0GbyaFKPmRW3EX0b9sd7DEf5WkHCuaK3QcdmIKxjdOXk4ZwtSEn6bH4QXvdMFkvIbqwlvw3blUc00p4i6GjeRFTqFquHlRRbXApr7iNTBOao2s+KX21bn1gbRKHCeOqxuBCs17cK1ySvl39XRwDApmaxtcYorRpJe/CBfeQ6ROxcH9PT3lKSn0UJACo50s9wP/4fDXjFjrPG19AO642iIq5NiAVPj30QbzLOl3fEGkwnNy3Ukre8GCiPcbwtwhuHVv3T6m+X4ZSJHaWWz8zOGK0iKSgb5rFLa1GWDeF8uhCeslpX1VJ10cDe/7REF+g7i3CPikCZnXPqhY/jh5kXPtI/2FRqmIwNvW9MgLZXHcYLBD1tIuaVVNOBDf0N/V1iSBB6wun8FonDIwunGrCcHjjm0ABe
 E2gOYkNN
 am4wh5/bqyIsAw5EmkfgB9fL5gTXx3m34vBzIH7SUHXiiK7s9FthyJwYRB1P6pY/i8+L97GJZi1PlzLCnYlzURIaJb+xJzEdmSLASDnTm+uvF38WRa+d+JjHn6TjnpTUeyoVbIxlHojswNlwAEfbXDiJE+PKKayBtX3o/EpzHbxLJibmekFv9eWR/Bej00DK88Hagi7gGmurH6DIvozl67hUu3MTL/8G7eNXAlTEK+e89BvVzA2YqEB8sd8yvumua8d0zHlWoq2whfbgq25Nd31OzouevW1jTNavnx1JmHeup1G5fFZOZFj4P6VxPpSM4fGU8NxCVLg8H0uU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is not immediately obvious that CONFIG_HAVE_BOOTMEM_INFO_NODE is
only selected from CONFIG_MEMORY_HOTREMOVE, which itself depends on
CONFIG_MEMORY_HOTPLUG that ... depends on CONFIG_SPARSEMEM_VMEMMAP.

Let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers that are dead code.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/bootmem_info.c | 37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index b0e2a9fa641f..e61e08e24924 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -40,42 +40,6 @@ void put_page_bootmem(struct page *page)
 	}
 }
 
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void __init register_page_bootmem_info_section(unsigned long start_pfn)
-{
-	unsigned long mapsize, section_nr, i;
-	struct mem_section *ms;
-	struct page *page, *memmap;
-	struct mem_section_usage *usage;
-
-	section_nr = pfn_to_section_nr(start_pfn);
-	ms = __nr_to_section(section_nr);
-
-	/* Get section's memmap address */
-	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-
-	/*
-	 * Get page for the memmap's phys address
-	 * XXX: need more consideration for sparse_vmemmap...
-	 */
-	page = virt_to_page(memmap);
-	mapsize = sizeof(struct page) * PAGES_PER_SECTION;
-	mapsize = PAGE_ALIGN(mapsize) >> PAGE_SHIFT;
-
-	/* remember memmap's page */
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, SECTION_INFO);
-
-	usage = ms->usage;
-	page = virt_to_page(usage);
-
-	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
-
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
-
-}
-#else /* CONFIG_SPARSEMEM_VMEMMAP */
 static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long mapsize, section_nr, i;
@@ -100,7 +64,6 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 	for (i = 0; i < mapsize; i++, page++)
 		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 }
-#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
 {

-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C7DFEE4CB
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 07:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DF46B008A; Sat, 28 Feb 2026 02:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722506B008C; Sat, 28 Feb 2026 02:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644786B0092; Sat, 28 Feb 2026 02:15:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6196B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:15:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 11EBB1D054
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:30 +0000 (UTC)
X-FDA: 84493004820.24.F55FA2B
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87AF440006
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LoTKhMsn;
	spf=pass (imf01.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772262928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WAYkRFCYpcA+nAu13ib8+d0IGvS7iebtzbag+H95n4=;
	b=J8E7G+rgn7o19dxoIEUjrfo3IBV2ECS5mMf24UafPHrH5CAW1N/CeflzG+eQH249QbtKY1
	FLI7G540K9JTrW46cXohDJDCfW8twwU2Qi4KahgRUjVBgG3sYwYBrEj1AE2IFHKxo7VfqD
	IDBUCisDQEhCxJnP//wMePGehYQKqsY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LoTKhMsn;
	spf=pass (imf01.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772262928; a=rsa-sha256;
	cv=none;
	b=2+GtqOqOza2TVt4jhHDTdJ43J/aX6DJ++38wCksV1vRgkY7mnaq0wgKeIWiBIAsxYwYtsg
	i2KqBXax2QBT0FRm3IEwr3y6RUbNc2c9DsU84zBeYTKYW1lPde84ZS/nsC3V1GeQQNyZ72
	TTJ7scpocMSH3QC0R9WRFzPa5E9n/Ko=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4WAYkRFCYpcA+nAu13ib8+d0IGvS7iebtzbag+H95n4=;
	b=LoTKhMsnG4bUuracOAyVcvy7GChGNh6pZ0RXf5XyLir4bwYo/l+8jGr8CLDvZFyTS5KqC73M5
	tcFI8XDj92UQ0NwM/PDBYjTSTLRu09DO2bv0fhN/8yVkr9XQyw+Wwb/ZZT4oJNaYFDxkRhi9SFL
	6yMWypZ6QWkvJvOIu++TKjk=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fNGYs1cGwznTVY;
	Sat, 28 Feb 2026 15:10:41 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B40B40568;
	Sat, 28 Feb 2026 15:15:20 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 28 Feb
 2026 15:15:19 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>, <jgross@suse.com>,
	<conor.dooley@microchip.com>, <Jonathan.Cameron@huawei.com>,
	<riel@surriel.com>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge page attributes
Date: Sat, 28 Feb 2026 15:09:04 +0800
Message-ID: <20260228070906.1418911-3-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260228070906.1418911-1-yintirui@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: 87AF440006
X-Rspamd-Server: rspam08
X-Stat-Signature: y9jd1mkbk9hndmscjqyw7emx1sxop7y4
X-HE-Tag: 1772262925-434330
X-HE-Meta: U2FsdGVkX1/T0AVD7NBwDgktNGMWB1FF+4xpFPNPHZKaZzK9Bwf8cmFDCrQhgMvoVBYibW053yjC55/XY84asms1aKKdLxaL6MvWWgi25qo1BBgPDKAIY+GWI3TLEDbZg7HrKrSxdwCU/2+usCdLSmXqUkeLE7J9OnlLpN3fTGaxlyTqHpTF3KnD3i4Y622LEpWU5qJ4s/v9XoeimtRUfX/LWjKXtSZEdSO/uNswtzJGU8NPHEgJS+3cuqA8Xrz9L2iNwHLiwFk9wtVp//yvss5Xa68U1TgGEuMtyDt8Z8F2XOnEVEAEvVSdTMhbfjJ4rvuQl1T0y3Nhn7KwcDnLdlE5kxV5m7TGrUg90kDKOpELFU/89ineOEwFL1awV7a97dJJWB/NYGrm6lQpRtNl6aL+S3WhFDvCy2pZkc2zNjSkDNj/jvaaZKGrkBjPggmklt16svjT7z5PpqVmMC/Fyd2/G3V0Fa6KIfQWq0+QUjUdL6SkQfKXC23awLxpOiTsb0I7vKhQm0Qc6IxftYsabyjUWc9YA1p83aKigEAJmCNenR+w9J4jdVqyTQoAIjX3WHSfDjOX0VziTRYxr29PhNojFuO4pOOZi2jBfATCXJygvt7ZKJmzBIa81bi/9BtC5SWXskOKPKhJIsrN6N8Mg88/fj68QxHBo/b2+kRFMjkJdaEHFAPCBd28+PPbYc0RG80BcL/vy7ZS2tB/VZUap6RlHnk3zSH4CrVbT7rDKLNSGGYMzzYDBZ8nFQ93BPIi7Y2H0ZkCwxfYhjY9ng4NKPXxVIzFND6x7VBb1x8uOmkxgz6ew/vU8mfXO44WvqZ7eX74gwc8jHHTCLsZZJtkt82V7FyZ/QwpLEbvCZ5ko+eSYhxq7Ku+FJdXoShccjhUhmAkKS/5q233Fpj0FkKxOU5s8PuooU5ATZUcphHbnsACs6Xg9RVBmxmauvdEo9z7y0amOf66Gz7LdvWdi++
 GegJ3beo
 eTEyw57F1CaQuL3f+dZFwXyD2rxK//55smYJN/1XqnAw4SApwdbkZGt13/Oiu9hh/nopXxDdMlDtg12JYaqE/KdIKWAf7EV1ulb4kQptQKI8Bj8FGyKwz3MyLIgkJODTWzfclLrNb8syu4tnD6/QxAuS/hyTPcgJHTDl5fPCX1ZbtHGx1jZsJ6BaJJ9SDZSAaG8zeErvg4e99rA4NUnlL3WwzeivMKIURjGwknZkNBml1shYmSs5aMa/U0ngNAlAnjuz4orE9AcGafSAyxTUOaJumEqV3u4fkyANIUgc8xEJF/3PayhbwXcxWre9oYNvI0lP0O4p+EHv5w6mdlge8fV0+0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A fundamental principle of page table type safety is that `pte_t` represents
the lowest level page table entry and should never carry huge page attributes.

Currently, passing a pgprot with huge page bits (e.g., extracted via
pmd_pgprot()) into pfn_pte() creates a malformed PTE that retains the huge
attribute, leading to the necessity of the ugly `pte_clrhuge()` anti-pattern.

Enforce type safety by making `pfn_pte()` inherently filter out huge page
attributes:
- On x86: Strip the `_PAGE_PSE` bit.
- On ARM64: Mask out the block descriptor bits in `PTE_TYPE_MASK` and
  enforce the `PTE_TYPE_PAGE` format.
- On RISC-V: No changes required, as RISC-V leaf PMDs and PTEs share the
  exact same hardware format and do not use a distinct huge bit.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/arm64/include/asm/pgtable.h | 4 +++-
 arch/x86/include/asm/pgtable.h   | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b3e58735c49b..f2a7a40106d2 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -141,7 +141,9 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
 
 #define pte_pfn(pte)		(__pte_to_phys(pte) >> PAGE_SHIFT)
 #define pfn_pte(pfn,prot)	\
-	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
+	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | \
+		((pgprot_val(prot) & ~(PTE_TYPE_MASK & ~PTE_VALID)) | \
+		(PTE_TYPE_PAGE & ~PTE_VALID)))
 
 #define pte_none(pte)		(!pte_val(pte))
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 1662c5a8f445..a4dbd81d42bf 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -738,6 +738,10 @@ static inline pgprotval_t check_pgprot(pgprot_t pgprot)
 static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 {
 	phys_addr_t pfn = (phys_addr_t)page_nr << PAGE_SHIFT;
+
+	/* Filter out _PAGE_PSE to ensure PTEs never carry the huge page bit */
+	pgprot = __pgprot(pgprot_val(pgprot) & ~_PAGE_PSE);
+
 	/* This bit combination is used to mark shadow stacks */
 	WARN_ON_ONCE((pgprot_val(pgprot) & (_PAGE_DIRTY | _PAGE_RW)) ==
 			_PAGE_DIRTY);
-- 
2.22.0



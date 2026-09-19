Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0943DC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2D76B0099; Sat, 19 Sep 2026 06:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C696B009B; Sat, 19 Sep 2026 06:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C990A6B009D; Sat, 19 Sep 2026 06:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E07A6B0099
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:14:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 269FD1C1C71
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:06 +0000 (UTC)
X-FDA: 85230101292.06.CDE902D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4F2AD40004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A5YLFeGZ;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789812844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0/4XqGVU5S/9f/PZzNEAFRof4FQ5qGGY7ug2k95TJE=;
	b=J4O4W57M3flNBVjd6v2GjtVIvvQ2ESji/AYDQdob8PotTwe6JvN6SQa8UIVdkWqD8zmu6c
	ekRfemdKADCUwONFDcq7gQOU2xu76WGPl/sEeJdh3I0EEQpR0TkHBEpy14nUo062mUhW47
	WIQbom3GAHg97F+cImfq5RWtrti+a90=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A5YLFeGZ;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789812844;
	b=lXl3DyqCdprBht2plNUUnQh2NUoigZng+mbPOnW7WpJZbkpUPUJmk1EMZZra4hf4JLdVj3
	qs6GfVofCyTDBJUqlVrz2DWPnEQ259zAv2Qte2SmG5qqcn7ITi3vkU49miyUV54inB0FD1
	8JDjtTC0r1vkvPZDQdPtdi7rOdbr1wg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7B01165C;
	Sat, 19 Sep 2026 03:13:59 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E7693F86F;
	Sat, 19 Sep 2026 03:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789812843; bh=ET3FvwGyXsOPaB1nqYS3yhI0YhtaILrYR+8hbIFKAFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5YLFeGZ8Zun87ka+h8+QBQCSK3/qQmTNs4AeTSBY1I6fxZlh8muzQNXudyPURw+9
	 Vhr9ArzZwSEsfbjjL5hCUDKokAn/Kr0dfu24YPlfpQrdqjxbjLtoWr7POA7xDUUwRU
	 BLrp+fhufuZQjw7SDVmky0z1WTWG1Wh/Efwe7mkY=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Helge Deller <deller@gmx.de>,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] loongarch/mm: Drop all pxdp_get()
Date: Sat, 19 Sep 2026 15:43:40 +0530
Message-ID: <20260919101343.1959572-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260919101343.1959572-1-anshuman.khandual@arm.com>
References: <20260919101343.1959572-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F2AD40004
X-Stat-Signature: 1e9ypxqizr699pkmq9oar1jx81uc9bjm
X-Rspam-User: 
X-HE-Tag: 1789812844-724636
X-HE-Meta: U2FsdGVkX18Smo7yJmudkt9c7ICOdqjsrPtt3dsjjNDMUXCJNW6gGEcij+zfLL99vIiSFAPPg9Dju8XSUfpR1pgd0FD+6Xv783yct1GaCN+sZSLkeazVK3rYCRk5gu1UjLgy7MWoebIL7XWNAGNE1JTN3eTPVwxULKoQsEC7Tb3s7KRDv1KD4mPunIB0EE53cg4njNVcZnX4kz4GvaL03fVfAvZOQumQP9B83yh4KrIuJxbE8Znkdo+9Eo/2pQKFaL73058hfa5eWM+5SSJnbFd/sS+DtD/KS7y1nrMb1Hf0rPJrVMnjDMDPrvVVheWVPoQ63S7zONSr+njhl4J+I66tDizVP82kJTkP8R8qan/xzr2ShJhKjFPIBWRvO2DUu/jblvowTI798hTLKV9ppnVuU37bDBOHKAF5zAXhCP98rUbvl6VPTjv5WDR3wKsf5Mq9h4xZwLr4xffHTCKXiOBK6LshdF4i6YfDsE7YMbXMGz9jqqF1lI6kJRQmWIDk6bo235dKUKDdDpwk1B3nLAuRRyXoDRsxWIXH7HqejeR87pIGTD9NzTz6b+ivpVirYF/baj566RSkgCb2tsJ8HTwzI1LL5iUaR0bY6Oqiz9y24QbXvTcIzZmBUSt9jN3mQy9Wyb5xGgpsxP+zsJ4x8SWRAz82FL25Z1A6+uhLUEcs6+2z+ouXXrOZSVpVBrN9JdRjIHCbwfFl+D1ZkZm70rLRIDXIcMCNOBbPswa9RqpA8PzUNC5jxWhrOL6Pb68jqOWcmiu8fy4p0Q75x1H8ZDBHCkk3Pl37UrdX1dH/pR+2/RYeu/6kCyeBsKnj+8VOxH5bmXAsKxYZdWc7StPTNOEEY4jTH3p7xsoHt/CdLerpPZdrg/p3TzxK9wsJawswD8Y4bU764MTnzbjdinM4oZqFGCT5PKW94iNDsLhniC+VWhdSUr/lTGyOxAxSW+oBdnvFdyRqr9+KC85+4rH
 9lzXn++7
 c8neB5wSUr9v0AQpIt6imCff7CJcrLLhm84QyVRUOLu9UmpFVT7UE4+rJw9uTwsfmndXVx8ncI5OR0ReCTlpPuff5RTwawqslMBqf/N2LWi2GUYHXtbVqhs5lba8PCxs1xFMEB0ZltssN/7wGZ+d8atqiF/jup4Lioob/KYHCO3kOLToh7a8DbLX1Z+5ic8SpUMoCLMKRcFHViyL4wMnI3ayjPW1K6sl3ZCaaAOZ4fDFwgbGTB6ALT52pVvEdQjhPEP9X3Hl8AHK/98LZfjP7nRdjfhhT18I+vSfauOQCWMBfN6+505fU9Djys8vNBjARtbjLUtcavbtW9B6b02RTTxCaoQ0/GnDb3y63NLTXFjxcKy1SSzaUZqP/KcEpJlO2dnFBkMDfDAbV+vnRux8omLKhQTpoxjA3lhRBGOJMdpa18IVLy36R+II0M2w0uUcm2sZ/VqapVo1cJQXVDhZQo1HJ65XgRlrNQoYfkTBY0umVUUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current platform specific pxdp_get() helpers are exact same as the default
ones defined in the generic MM header (include/linux/pgtable.h) thus making
them redundant. Move functions that are now depending on generic helpers to
avoid build failure.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: loongarch@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/loongarch/include/asm/pgtable.h | 20 ++------------------
 arch/loongarch/mm/init.c             | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d739..cda4d5652d609 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -125,9 +125,6 @@ struct vm_area_struct;
 
 #endif
 
-#define ptep_get(ptep) READ_ONCE(*(ptep))
-#define pmdp_get(pmdp) READ_ONCE(*(pmdp))
-
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -371,12 +368,7 @@ static inline void set_pte(pte_t *ptep, pte_t pteval)
 #endif
 }
 
-static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	pte_t pte = ptep_get(ptep);
-	pte_val(pte) &= _PAGE_GLOBAL;
-	set_pte(ptep, pte);
-}
+void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 
 #define PGD_T_LOG2	(__builtin_ffs(sizeof(pgd_t)) - 1)
 #define PMD_T_LOG2	(__builtin_ffs(sizeof(pmd_t)) - 1)
@@ -611,16 +603,8 @@ static inline pmd_t pmd_mkinvalid(pmd_t pmd)
  * different prototype.
  */
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
-static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
-					    unsigned long address, pmd_t *pmdp)
-{
-	pmd_t old = pmdp_get(pmdp);
-
-	pmd_clear(pmdp);
-
-	return old;
-}
 
+pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long address, pmd_t *pmdp);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 3407030f3e7a2..3262dc3a2971e 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -255,3 +255,22 @@ struct execmem_info __init *execmem_arch_setup(void)
 	return &execmem_info;
 }
 #endif /* CONFIG_EXECMEM && MODULES_VADDR */
+
+void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = ptep_get(ptep);
+
+	pte_val(pte) &= _PAGE_GLOBAL;
+	set_pte(ptep, pte);
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long address, pmd_t *pmdp)
+{
+	pmd_t old = pmdp_get(pmdp);
+
+	pmd_clear(pmdp);
+
+	return old;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-- 
2.43.0



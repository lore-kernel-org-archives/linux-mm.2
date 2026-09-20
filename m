Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33EA2C982E6
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399F26B0098; Sun, 20 Sep 2026 15:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325026B0099; Sun, 20 Sep 2026 15:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECD96B009B; Sun, 20 Sep 2026 15:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4E776B0098
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:37:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 581E6A5466
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:27 +0000 (UTC)
X-FDA: 85235149734.23.61ACE98
Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A67E40005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:37:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="KMBf/RnU";
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933045;
	b=YSPpgmB4KcEFQV8jSOFRnPc48LKIiITF0dpSqNSULA8VacFhkcRsiJDtIvCOCTEUbtubfF
	M3wjJ98T5b59NxslIeDj28JfA0wmlEP+1hGXfYwzZWE4p0hP8uDgB8Z/bWofTcidX+pS8x
	ycK6GS07329nHKzOqiMxiV0BaiOF6nw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="KMBf/RnU";
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5nAPiFxyuCO/MgJOwL1aiw4E3m2Ng0EpjBlpOl2sok=;
	b=vb0fW5dQNFlBf71eX9Q2D4FkN0s47t79m58Xcgqp556vSCS1BcPAtDKNEoLFOoFDaCjRBe
	EjP3rCoP2dXUt+GdqmuJ25lpVnnejDLGfLoaPMpwB4X0GvlwgSbqvoNgDphH1f9oRxbbFy
	CV0D1yVx7MdL31XeDTASBu/dH/TJEMI=
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d43f9b119so18204537b3.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933045; x=1790537845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=i5nAPiFxyuCO/MgJOwL1aiw4E3m2Ng0EpjBlpOl2sok=;
        b=KMBf/RnUdAMTTzdxHs3A4e82sc3ZSiguk4C1GEOGJuuKOWfjNiux/rrDuye2T81alJ
         EvyB7yvOyXjKcxzDqBEsMo6QuoQyECdzCzzdD+jLZFtNEJphF1hj1kDeXn2m/Ywdb6Gx
         00eZ8sRirh3w1L6DRkVRc6+sBoi5HUtKmTAfxDqD1IGMSZCZqIbIniYm8QMexh0fAzu3
         dbxTl2qD9G6j3hf8yHPMJ0RF8NtBanBPuaaCuSMfX1RkbLu9nfLg7CrAIY20RylkdsTa
         /KDJO2uQ5s8PNdDhgXJX+dR9OfXvlZO2eIVuLMf1u489VuJOnZd0v+vmS9MZSh3O9s86
         9uXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933045; x=1790537845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=i5nAPiFxyuCO/MgJOwL1aiw4E3m2Ng0EpjBlpOl2sok=;
        b=kZ1I11LGXOxvQhtYvc804v68YcFELoaiY5cSplVdodc/qoEXf+/6S7IvpRkdoob38p
         T3qoh1jE4mdk0tZ4OXPw2jzKGwE0oIz39FaSlygHkBt7Zh6fbvLj/FVETb4jKtpeq+v4
         sLWck/LhXe5Gu0RgswxvrEiyzbouica+fudO0SSk19O+K1c2xdS2G8EefEygBySpcA0B
         wIhGb9DC6yhlklv3SdcxUt21dEiRn6U52ElvxXWgC0yYrJJUaSeib9S2R9tBqLqLcKcS
         DjNzj2dD1gYNZR3U9UI9iuewB+x4oPoRUpJEeyY8z9sPLR/5oUlTIvTpfaXu830XTBv0
         M8/g==
X-Forwarded-Encrypted: i=1; AKwUvBzbw8nAbrYrnS/KIU2JJGhPEogVMjmYpRopssr8rJcKRa1Rhtji8GCI0OMmIdXDJBbA1J6xbW5FKQ==@kvack.org
X-Gm-Message-State: AFuF++kAPa1qyi/OJIgPYmc0AMv/CWclQhWqb88qtPsSRW9X1gOecvHu
	MwVa3/EFwDJhSW5qwEnJovbXxyGgf2UAX0awK28uOZIJBUXfxlyByFATpVMc0lBaBhM=
X-Gm-Gg: AYBFou1BBgP+NM2CFxXPWOv09367GOISJxttXLxebn+FcJ43g1HSYoZFBWNivTmXwRP
	kV+JM/haR0rgPhcMVKEJk2sgxhKRsahHQ6fpwtJCo15i+ZpqYEi/7u9RGKCnRb4oc+FtCdEcyTz
	pr11Zan5aBVBRy237tzPTOSVqUbsoPKxitcrbnLREJrpkZzYC/LrT5BnMV5D1LTjEm6A5w/3tc/
	Kh8LXrT5OwcUExlDbZC5op3aj+pQGLOPRCUCviymmmu3dNkTBPBzFVJwG3m9CJMTRYB13MSo80I
	i4Yj1IzcOcu2VNXs+LEUZ9Gh9pZHAsU1vZ0AXqNHHmBV1Zgkqpamg+taOSb5mCOetZ83Ujh1C3I
	u5YIBwPNoypK9N2ukA0hBDL+MkncOCU89i9IhopddNjQTQjrwpvLlVOrymApbHOkctMNZlMCwdx
	0dv4ZQAMUUMCqg0MUl9jrUh29/u6hP7O/UVtN3ZwlKNBksCpit5glsIsrPMa8w43Bxe6IL+KQHl
	Pi2245mzifMMh57dE1xZAIIlmiDKIgK1EWIw68JtyF1fhuUWvMZQRxR2C9nsPrFQ2tDdcFGghGz
	lX/9dU+MIjJImWhBT8g=
X-Received: by 2002:a05:690c:e297:20b0:870:f53:4edd with SMTP id 00721157ae682-897305168b0mr18683667b3.7.1789933044691;
        Sun, 20 Sep 2026 12:37:24 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a48aab042sm18597427b3.47.2026.09.20.12.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:24 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 05/46] arm64: mm: Add trans_pgd_map_range() support
Date: Sun, 20 Sep 2026 15:36:09 -0400
Message-ID: <20260920193650.3373435-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A67E40005
X-Stat-Signature: 4cshtgb3ygyb9obzn7o3sjkwcpec6dib
X-HE-Tag: 1789933045-148425
X-HE-Meta: U2FsdGVkX18nNvmMbhfzcQn8ENP7FKfJeP09ORVXCvuR4Dkq6IQbhG5nP6oeFgzpW6elPQ/drKlBsTf1qFGaU5Nsg3Pm+A9mKOVEiGo8zykM5d340sze060mC30B68bjkNCS0PxwVZ0xOXyoUrMPrYZ2bYG1A7z23prMfDCY4Y+GVO7ygh0o9nglJ1a+Bmz9SYeYWnazI/iLCH23ArzbQuqY7U02qEdhskqNnB9UvbF2vTC9e/3XuSHntDjRTqphKbF3PcyEXmw8AtHXCayIC1TQXI2jqL26dIViYgNwFVbmcyfnSZkfMbTgcnvI3jqxXf08pskDFYjUXuTNwO4S2azx8ogNkGB5+zIKNrq1mNyH8qZZSvc8Oe1kbAlTFYiUvYXOd1/kDQES/7ddMgYVtXQj5Bc1fS4jlLCogUuP6AHkM1lq9dmwf1dpFXf2v6+IB2hVgeKv7ek9yg/6lZbK/FoNAJ+zimnZlY2HvNvlOPF11ZKhWKflgRp+mXPPt/10xh1Dgj+YeFhI9KRHO0mRhDS5s7QRB2fg0CS1Wn3o1JIfxgKiKmgDCY3vuydmhWvMjscZ2mtkjfQ579NmNloRkXCVJ0GjiN0FFxLxGmmCDbStMpd4WczBt6dbuLhSFUqgP6O8VdTX6UgrTBwxeLnJd5e0e0ERwlvIfQ9ESOmi5iX0dvXFj7/nr1FCeii8PPyGkWvv51v5Dbyy8h7ZrC4q2D+EX940DyygX6KketqB51wzNMzCzQMXYWn41MejxrveG++IDfM32cjvH2RTBS9mlHbuhQstFQ1HMRZToEeFbFs0RfVZ5XSfJXZ9q7KW4+6FATxShwGpBtdUXoKxBG5GN4+siMP50qza1//FxCXxmj2dhT3mJqAMyBVvVbJ17dOcMEBPw5qJsyEAQuV7EMkTd4Vw5RMP1ctIgW61eWGelOnk2ZWsF9JG6VYtRFhlSp1AVKBhkubG/Q+MnvSL3gt
 TGFMZC/r
 Gy7SyqZzMsaIS42IR5rlLhAnYzCUfoJfuMu4t9szTcaWap1U3m0P8n6X7gT+rE5DtpTl+x017voPBmjWING1z6Tm0J8/8gYmAMx/FGorBKc2jxwmU7ZrtsZzxibDXobmDWStHVfxKuxM8lYwoaRZ0Lj3gU696Qns6gXXg8rD3q7aWH5GdVkOoYNHd6ev735Nd7sQf2xoX51L/A1mQkYhN1vOj1/X6VsQObIn2lORKEspujXpzyIkpXFew59iwtv0vCL8Cne8sqVcnIFlNj9Wa+uhnEfQ0zYGASk7aoNzSkvJ2cGd/WKCkq8/FeRv3jxnJtNbHhzUyPLjtpFCSggg2ZllnwLPZqfb/7y0P0Te1oUP7S4zyaTiFFUy6HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce trans_pgd_map_range() to allow mapping arbitrary physical
memory ranges into transitional page tables.

This helper allocates intermediate translation levels (P4D, PUD, PMD,
and PTE) on demand using the trans_pgd allocator, enabling precise
virtual-to-physical address mappings in transitional contexts such as
isolated execution environments.

Add comprehensive kernel documentation detailing the isolated page
table mappings: Caretaker text/rodata (ROX), writable data (RW),
stacks (RW), and preserved buffers without cloning the direct map.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/include/asm/trans_pgd.h |  4 ++
 arch/arm64/mm/trans_pgd.c          | 70 ++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/arch/arm64/include/asm/trans_pgd.h b/arch/arm64/include/asm/trans_pgd.h
index 033d400a4ea4..1e17ae145b0c 100644
--- a/arch/arm64/include/asm/trans_pgd.h
+++ b/arch/arm64/include/asm/trans_pgd.h
@@ -30,6 +30,10 @@ struct trans_pgd_info {
 int trans_pgd_create_copy(struct trans_pgd_info *info, pgd_t **trans_pgd,
 			  unsigned long start, unsigned long end);
 
+int trans_pgd_map_range(struct trans_pgd_info *info, pgd_t *trans_pgd,
+			phys_addr_t pa, unsigned long va, size_t size,
+			pgprot_t prot);
+
 int trans_pgd_idmap_page(struct trans_pgd_info *info, phys_addr_t *trans_ttbr0,
 			 unsigned long *t0sz, void *page);
 
diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index cca9706a875c..f0a55d4270cc 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -200,6 +200,76 @@ int trans_pgd_create_copy(struct trans_pgd_info *info, pgd_t **dst_pgdp,
 	return rc;
 }
 
+/**
+ * trans_pgd_map_range - Map a physical address range into a transition page table
+ * @info: Transition page table allocation info containing the page allocator
+ * @trans_pgd: Root transition page table pointer
+ * @pa: Physical address to map
+ * @va: Virtual address to map to
+ * @size: Size of the range to map in bytes (page-aligned)
+ * @prot: Page protection attributes (e.g. PAGE_KERNEL, PAGE_KERNEL_ROX)
+ *
+ * Populates the page table hierarchy (P4D, PUD, PMD, PTE) allocating new
+ * intermediate tables using info->trans_alloc_page() as needed. Used by
+ * liveupdate Caretaker to construct isolated page tables.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
+int trans_pgd_map_range(struct trans_pgd_info *info, pgd_t *trans_pgd,
+			phys_addr_t pa, unsigned long va, size_t size,
+			pgprot_t prot)
+{
+	unsigned long end = va + size;
+	unsigned long addr = va;
+
+	while (addr < end) {
+		pgd_t *pgdp = pgd_offset_pgd(trans_pgd, addr);
+		p4d_t *p4dp;
+		pud_t *pudp;
+		pmd_t *pmdp;
+		pte_t *ptep;
+
+		if (pgd_none(READ_ONCE(*pgdp))) {
+			p4dp = trans_alloc(info);
+			if (!p4dp)
+				return -ENOMEM;
+			pgd_populate(&init_mm, pgdp, p4dp);
+		}
+		p4dp = p4d_offset(pgdp, addr);
+
+		if (p4d_none(READ_ONCE(*p4dp))) {
+			pudp = trans_alloc(info);
+			if (!pudp)
+				return -ENOMEM;
+			p4d_populate(&init_mm, p4dp, pudp);
+		}
+		pudp = pud_offset(p4dp, addr);
+
+		if (pud_none(READ_ONCE(*pudp))) {
+			pmdp = trans_alloc(info);
+			if (!pmdp)
+				return -ENOMEM;
+			pud_populate(&init_mm, pudp, pmdp);
+		}
+		pmdp = pmd_offset(pudp, addr);
+
+		if (pmd_none(READ_ONCE(*pmdp))) {
+			ptep = trans_alloc(info);
+			if (!ptep)
+				return -ENOMEM;
+			pmd_populate_kernel(&init_mm, pmdp, ptep);
+		}
+		ptep = pte_offset_kernel(pmdp, addr);
+
+		set_pte(ptep, pfn_pte(PHYS_PFN(pa), prot));
+
+		addr += PAGE_SIZE;
+		pa += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
 /*
  * The page we want to idmap may be outside the range covered by VA_BITS that
  * can be built using the kernel's p?d_populate() helpers. As a one off, for a
-- 
2.55.0.1082.g2b9226bbc0-goog



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333B2C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E6990009F; Wed, 13 Aug 2025 10:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0ED4900088; Wed, 13 Aug 2025 10:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8FA90009F; Wed, 13 Aug 2025 10:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4A9900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:56:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66E2758B63
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:56:28 +0000 (UTC)
X-FDA: 83772035256.25.5C93293
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB1394000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:56:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of chaitanyas.prakash@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=chaitanyas.prakash@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755096986; a=rsa-sha256;
	cv=none;
	b=6L8U1Y6xaTfzttcyZF4KRCPBXtFReA6jWiOhQRbLJNRkF6wfx4byaZRorDe8qrG9kKfUIa
	KYm7ECVNIG7hqX+wOvo3rlStitUJt+PqHLosqrwrWx42zmFCmlG3Y+VbtVy2kgbbJANxDL
	5Do+zQ7sS1kMHBQDbrXoOsF9oTzLVog=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of chaitanyas.prakash@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=chaitanyas.prakash@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755096986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hH2Ag1dIEuC8Jxe54WHLC6K1HWMsOn8nAJRMDT/vzz4=;
	b=3resjTM4YEfM5Kgke8kAc4p1fYbn577AEhlQWD+VVL5hnRi6qsK2Hc2jAz5DmMOi0YHHEr
	3gEm7K9uZ1ojWwt2HiEu0meO6Bmy+SxrX/vlJlPeVFQ7tKcEv262MZfmDJvHnDBi+V7/K6
	dduYtMiz8pEYrUk9DW58a/4DU+7pETA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB8B112FC;
	Wed, 13 Aug 2025 07:56:17 -0700 (PDT)
Received: from a079125.blr.arm.com (a079125.arm.com [10.164.21.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7D9823F738;
	Wed, 13 Aug 2025 07:56:22 -0700 (PDT)
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zhenhua Huang <quic_zhenhuah@quicinc.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 2/2] arm64/mm: Update create_kpti_ng_temp_pgd() to handle pgtable_alloc failure
Date: Wed, 13 Aug 2025 20:26:07 +0530
Message-Id: <20250813145607.1612234-3-chaitanyas.prakash@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
References: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 97nmsjey5zwyek9676uxetkp4rgxewb5
X-Rspam-User: 
X-Rspamd-Queue-Id: CB1394000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1755096986-752017
X-HE-Meta: U2FsdGVkX18j7FEVGP92s7uhgemBnEwQgpPT7x4OfheTBjCM0UMjBblwzWrV8b9U7/TRM/SI2cv/ISVxVUDWutQIVjM1hah84XYWL49M3rb3fNmraobtJWqWNwHpOtBk72lqDj9Ble/jdvzYd2zuiKFkUkv1RPdynDO9WOLJeNaqVC9jv3EnYQS5GeyHL/AoddiNtt6Gjdn9nGEl4Xi48zMZCSikdm+/kSW/7RVgsRBQ04te46iTi2MfZAoMtiPqe09CV5WorazU9EYU4blMdWAcjRv2fF69FfxzgbfG/rd/AnDO5pf0OQtyjOLYg8DmFItV9+R3O0LTzH/DhBfr6RmVvOao3MuIzXEPZyjDz5smHZa/VCRDfUvqgdKTxhZwxv7iimRmxNKljlQvqUzmUrDq3HAoUY5w7byiUq8jIt0ZvKB+qD0augnrAEG3bpoCO26LcDprP2tYXpcVMoC67aefzFozwvUY1rI9WUaW+UCiohCjdA48MQ/B0sunNhY13PJ74KFYQ0/TD679GBzgJFVHeh1q8FxQtMd1Rgyl5t5N35cuC6gIG+kSpp+ZM6VLFPzngyiD12oxSn4xUODoBajvxBLOenVzad5ukgY2OdppWneXCNs2dcgJ7i71TBnElSEI7t2hBB4QyIf7kvOWBjILsZF/rpquQ7dzmvse9eUAwAtZcjFohRqQgYP4fN3zdIPSflmw/GEjUn7NE0etwoERymTx/zFFoBzz43sFbGLItKjzu9J6EMce1PPSElhk7Lh4wWpb5oN+AmSJS7lXQwJmqapZ69Qp7kI6NImIqMlMEwLmvg0Vkx1l1RroDOM1uVzhm3kkl8qUbhTiuKvhqzl5TJKN1wweoGY0bb9GWrz3K3+ovXqesvX3dbNNePgYC3w/OI3z42s5c1VIkrNl826puZKgh960WViJHq5h3e14I8VUrG3WFur+gNlYc8DOsksZpLWndlT042q/efF
 f1uSJMI/
 K3WHSx5RWN8KNrDY5Q3bO8b1WMz/w1KRc7a45qE2D8ekev98EoMyoBv60Emo9xBDMFruyNIU9Zs+ce47AmJFPlw+bkHOqUIgURLAkxtWD5egxDYlzeEHV1GFjPb55pDBOmYu3qOh535JtEUr/kfi1MavE1fzSf3QdYbjS+AwbCTvLd6wlw2qvSfvXGvnyE0CcverQHhgx7LUm3PQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

create_kpti_ng_temp_pgd() was created as an alias for void returning
__create_pgd_mapping_locked() and relied on pgtable_alloc() to BUG_ON()
if an allocation failure occurred. But as __create_pgd_mapping_locked()
has been updated as a part of the error propagation patch to return a
non-void value, update create_kpti_ng_temp_pgd() to act as a wrapper
around __create_pgd_mapping_locked() and BUG_ON() on ret being a non
zero value.

Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
---
 arch/arm64/mm/mmu.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index db7f45ef16574..19cbabceb38bd 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -76,6 +76,14 @@ EXPORT_SYMBOL(empty_zero_page);
 static DEFINE_SPINLOCK(swapper_pgdir_lock);
 static DEFINE_MUTEX(fixmap_lock);
 
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys,
+			     unsigned long virt, phys_addr_t size,
+			     pgprot_t prot,
+			     phys_addr_t (*pgtable_alloc)(enum pgtable_type),
+			     int flags);
+#endif
+
 void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 {
 	pgd_t *fixmap_pgdp;
@@ -541,11 +549,17 @@ static void ___create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 }
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-extern __alias(__create_pgd_mapping_locked)
 void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
 			     phys_addr_t size, pgprot_t prot,
 			     phys_addr_t (*pgtable_alloc)(enum pgtable_type),
-			     int flags);
+			     int flags)
+{
+	int ret = 0;
+
+	ret = __create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
+					  pgtable_alloc, flags);
+	BUG_ON(ret);
+}
 #endif
 
 static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
-- 
2.34.1



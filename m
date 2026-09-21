Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86415C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502126B00AD; Mon, 21 Sep 2026 10:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B38A6B00D5; Mon, 21 Sep 2026 10:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9126B00D7; Mon, 21 Sep 2026 10:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDC816B00AD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:49:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39E33A01E0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:31 +0000 (UTC)
X-FDA: 85238052942.22.FA970C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8ABC21C000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avX+lq+F;
	spf=pass (imf18.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgD4D7h4EfSsMTxEOq8ADKWRNeWiq2+KsY/R5C+YQNM=;
	b=j3ZYXA2VIYtmP7dl9EpsZQJiRU2qq3a0Sn5Vcg/M0AXvIDYOtTHLE3R4EAIn7FvlBD4xjQ
	50uPYCR+yTs73ZbVF9ZguiaC35FJ7X+4cEW4BHjYN4OBzHtue4NtY1Ee7YA4FRzTGrZwN4
	wxld3kX2ZFbngQ4uo8yefEitK3p0a8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002169;
	b=02ildNLaIQG7Bc8ulR4Y5FRRFKi8gwy0ykLjMeBK54q4kPyq1Md1KF46anVG8CjD/Lgm/b
	RfgLUZ90sg8f7Bty/hOaFmLK74pzYR6BTcIClKqCiQKkP0uqunbRm5f0fNSmqfQUjZLiNz
	seipOMtvvbZONjWDT8LMC3N/Sc8htsE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avX+lq+F;
	spf=pass (imf18.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D09B940385;
	Mon, 21 Sep 2026 14:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFFD1F0089A;
	Mon, 21 Sep 2026 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002168;
	bh=AgD4D7h4EfSsMTxEOq8ADKWRNeWiq2+KsY/R5C+YQNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avX+lq+FEOvHDH2Ka+90xabX+/3XfcNlbMJOgo8hQbVT7KtytJirI2WAK3ZkdU+A2
	 dhOvEYZsoG4EK7R7gE/4hye/lvQQedFCROIZN1l6Ld90l61kqkUYnN03fFNFiaYeNw
	 xYhBUCcKknnZvHXKI7GHaDux6pUgVHLc0uY4qpQE1aVbJbF6TcenTqDGPVxMhfNzEU
	 A5n9MGaMcMz9ytuyWSYbK8Q+RhhbKuySFp6CYcloHxaLPeHMEykf8QuR+nfpaHndMC
	 eMeu0po3UwytgA8nKwZWgmhH5E9118kfO7P0hK8BFGlTQZgTXiEdpTbbrdUfSBmXiV
	 vdTOxKBQ5YG6g==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	christian.koenig@amd.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v7 03/13] arm64: realm: Expose the CCA shared granule size through mem_encrypt ops
Date: Mon, 21 Sep 2026 20:18:37 +0530
Message-ID: <20260921144847.501151-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 667x4uxm7rptbh98wecuj3mejt3x9b3y
X-Rspamd-Queue-Id: 8ABC21C000A
X-HE-Tag: 1790002169-412223
X-HE-Meta: U2FsdGVkX1+rmfNz3wkeS8TtI61cmpzlXXNo8I/1eazLlyr/HQodo03RzrBemovcyg3FISR/V83FdNRhsak/zYQy3zD2HFjDGjQKMLKhf4H6Evw3vgZB0ZtSXLK6cmAxLd2GpgS5CdFx2Xyv50hqn0V1Ajoy/Ap+vEC0DoniIbTtnTsN2N6XUrDqvjKbPV9K8v/+OSSV8LHmcJYmpuNsDlp/ERRcP5s33+SM80P1DtRFRiIOLJAC48KszA1jVL08IdAUawXsmc0DLPK57o5bg0IUhUO4OE+L9NnhdKGyEIunDoiIVqFZRVHtJZVORZLwx6iQxhpAa3plK/zWZzT8aVyEpdA7sMfhjdLyY++pP/sXS0uUyYWvCqjgqXKsVYYBPWg9hJ5k8RBEa8bCDTEvGz4SjiQkKmonGp0M9v0nLYqb/WihntkSC8iibqzE2XUCgVkyhhw15qje+Fn/aGvs14SgdXywIxBxSf195XXFexACACgaXWlukeo59PhWQx/YzBYM5yW7LAgw1LlDxxZ3G1Jy5+P/UMLT9DzPI+eNL4hYl17koosOc3047amBKiKuWPsjAMe4Ma96Lz9PFdS/KLbxb8TD2hVJX4stw3bT+51c4Umw7pNMmJporQACFYSz3NbMUOLWVJIXaK63P+glvaKBVFfRdfzRDaqQ1478N+cwSaUuKb2rit965D0kJmnztBwO4VYbxZcWec0m2A4KLaxPLkVMkGIWan7gY3TrdlvprB7PgxSHQvBPh6oOtBOlKdky+iF3KneskAQ+LQvplI9TPvjbkG8x9CTq+vLbrGe1Wdabwbo4epEDxmg45bI8uP4SxLeykkkIZLaRniMaxlQJbN2rqUQvLNZplzhDvwiuOfAdoTixD0FMD/O9fEAmJD/mTfLjyc2m4t277++zEdU7ozdfenntjj7/qR5OrgATZUFRPQTVX2csBVHM7zsfEfWoF3iq7JvVrHX4rXt
 p2P8vDZM
 5GO0gHHfQa49MyyWluKYZ3xcGUf4Rd3NWGtNmcO8fmOHsmXRRl8OpfdXRAUMfCtNl3tUc5dhd+otcNjmHaenWYYnWoYIYnXnAk1lgvKt1TCOMOVrO2bTbfpaaa+wVC3icmtNeBsuM/oaqBjXw5H1owcJGvELoFdtSV8kpM7qq5akpSLzbwz0WRcUBCpUtaYHeB4qyjGUmrIs89FOjusPkddvATy9WHkllyp8A5jepqxPXVCHhdkvOFYVy34FZDdkdKwVde4sQdCRJ3AnuCIeHcenW+X8K5C/PkCWRbCV08RYNEdYg060+A7JumPFl+o+MG/iG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CCA guests must align shared/private memory transitions to the IPA state
change alignment reported by the host. This alignment can be larger than
PAGE_SIZE, so transitioning only a PAGE_SIZE-sized subrange may leave
part of the host-managed granule in the wrong state.

Cache the RHI-reported alignment during Realm initialization and expose
it through the arm64 memory encryption operations. Implement
arch_cc_shared_granule_size() so the common CoCo shared-memory allocator
uses the same constraint. Use PAGE_SIZE when no suitable backend is
registered.

The common cc_make_shared() and cc_make_private() wrappers validate both
the base and size against the architecture's shared granule size. Remove
the PAGE_SIZE-only address checks from the lower-level arm64 transition
hooks so that range validation remains in the common wrappers.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/mem_encrypt.h |  1 +
 arch/arm64/mm/mem_encrypt.c          | 13 +++++++++++--
 drivers/firmware/arm_rmm/rsi.c       | 13 ++++++++++++-
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index ef8b8463e52b..32064338c9b0 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -10,6 +10,7 @@ struct device;
 struct arm64_mem_crypt_ops {
 	int (*encrypt)(unsigned long addr, int numpages);
 	int (*decrypt)(unsigned long addr, int numpages);
+	size_t (*shared_granule_size)(void);
 };
 
 int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
index ee3c0ab04384..e6c059d20595 100644
--- a/arch/arm64/mm/mem_encrypt.c
+++ b/arch/arm64/mm/mem_encrypt.c
@@ -16,6 +16,7 @@
 #include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/err.h>
+#include <linux/cc_shared.h>
 #include <linux/mm.h>
 
 #include <asm/mem_encrypt.h>
@@ -33,7 +34,7 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops)
 
 int set_memory_encrypted(unsigned long addr, int numpages)
 {
-	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+	if (likely(!crypt_ops))
 		return 0;
 
 	return crypt_ops->encrypt(addr, numpages);
@@ -42,9 +43,17 @@ EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
-	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+	if (likely(!crypt_ops))
 		return 0;
 
 	return crypt_ops->decrypt(addr, numpages);
 }
 EXPORT_SYMBOL_GPL(set_memory_decrypted);
+
+size_t arch_cc_shared_granule_size(void)
+{
+	if (likely(!crypt_ops) || !crypt_ops->shared_granule_size)
+		return PAGE_SIZE;
+
+	return crypt_ops->shared_granule_size();
+}
diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
index 883f6091ff95..b59099d1f318 100644
--- a/drivers/firmware/arm_rmm/rsi.c
+++ b/drivers/firmware/arm_rmm/rsi.c
@@ -18,6 +18,7 @@
 #include <asm/pgtable.h>
 
 static struct realm_config config;
+static size_t ipa_state_change_alignment = PAGE_SIZE;
 
 unsigned long prot_ns_shared;
 EXPORT_SYMBOL(prot_ns_shared);
@@ -154,9 +155,17 @@ static int realm_set_memory_decrypted(unsigned long addr, int numpages)
 	return ret;
 }
 
+static size_t realm_shared_granule_size(void)
+{
+	if (is_realm_world())
+		return ipa_state_change_alignment;
+	return PAGE_SIZE;
+}
+
 static const struct arm64_mem_crypt_ops realm_crypt_ops = {
 	.encrypt = realm_set_memory_encrypted,
 	.decrypt = realm_set_memory_decrypted,
+	.shared_granule_size = realm_shared_granule_size,
 };
 
 static int realm_register_memory_enc_ops(void)
@@ -166,7 +175,7 @@ static int realm_register_memory_enc_ops(void)
 
 /* we need an aligned struct for rsi_host_call. slab is not yet ready */
 static struct rsi_host_call hostconf_call __initdata;
-static unsigned long __maybe_unused __init get_ipa_state_change_alignment(void)
+static unsigned long __init get_ipa_state_change_alignment(void)
 {
 	long ret;
 	unsigned long shared_granule_size;
@@ -217,6 +226,8 @@ void __init arm64_rsi_init(void)
 		return;
 	if (WARN_ON(rsi_get_realm_config(lm_alias(&config))))
 		return;
+
+	ipa_state_change_alignment = get_ipa_state_change_alignment();
 	prot_ns_shared = __phys_to_pte_val(BIT(config.ipa_bits - 1));
 
 	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
-- 
2.43.0



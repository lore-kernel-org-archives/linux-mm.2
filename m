Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DA5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39076B00B6; Fri,  3 Jul 2026 13:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9886B00B7; Fri,  3 Jul 2026 13:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFF76B00B8; Fri,  3 Jul 2026 13:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F00D6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 133321C1BEF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:23 +0000 (UTC)
X-FDA: 84948177006.19.583806C
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 488DC18000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B8YyvmMO;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100361;
	b=d0XBABDA1MdsrQcirXpcuOC6N7ve5OAjlYaU8xZxD6RIhnq0PzJ+41IqxA/5i3S9lChrwN
	8HAAxoy+tvCiHijEJehXh5ilEkr3c+bv2mIuhOjVeFCDtGRKaYRtxe0sEnjk9EOQdyA7fv
	kR4wc3R96crC9lkc1io46rfk2bV5o2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mq5IV9LvSyhzCCwOF7ehFTtL3crP81fivAnhquPzxl0=;
	b=QaISnGYssEhCHQ2DSrDcHnW4ENKAEte+PBcGNxaqf6eOPbnq/KtzYgmFtOEO0H5v0qrJIg
	s6JHbuqszLdIFqweiDw3wn8wJT1MrqVnH7bev4RimNMWSy046Vf09CKz0vAbBE0+2Q1HFa
	a6b0VPa2vL67K/AsX8cn6GYBVn5vsZk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B8YyvmMO;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mq5IV9LvSyhzCCwOF7ehFTtL3crP81fivAnhquPzxl0=;
	b=B8YyvmMOUwNf+XHJdYX6ekcHRru4ESYnn6wSFJkamqj60Nm7EAtMme5aNRv1Do/DfuySOC
	TdXDiqP3Y+QKsnccwdQ6VvKVOG8RkkD1B+LZb2u51HkR4wP7auGN6HkUUSZLlnjkg1MWl+
	ULKHh9Dpz4FTG6ZWRzTGPKJxgrDCIcE=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 01/11] mm: add PMD swap entry detection support
Date: Fri,  3 Jul 2026 10:38:18 -0700
Message-ID: <20260703173903.3789516-2-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 488DC18000D
X-Stat-Signature: 6iobkru1k7ccrkgjjn3z8uifd69j53fb
X-Rspam-User: 
X-HE-Tag: 1783100361-261547
X-HE-Meta: U2FsdGVkX18YNYLzh7crgeg2gcGl6r68iuJh/7l5S3goixKT23vPa2ywEUdPnRawsILpa7LH9Xl5MViVqVy7xU9dC20UYGLhJg1OIP5hDvuEetivjY4DNY0UF5v3OLiRBIZoxuPwxS5pBHkRcHWCIxUTi6qLa+ouwE/AVxyUcZzqwjmbqAD9osWv66NJUtfkU/el3KbOR+gO7FbKhJvplMmtp4RIBzHqyZgX3tUjZSZgNqUxJAcIR2+TX//AlUD6JnhSUxpQvbY3Oez4SRd1w/PbvZugvQuf4VC10loRSriCaBCn1ymqPenxdv8MJ2FeCV0xnl62v/h8SgjHd+jnd7zAdmLD0mJai2kSXUAhh5qWS0W5n1h19gCDj85RGqXWGUqGrbLyRh4R6lqUWGFgiXahTc6AmpE62m0bKDHpAumbCT61GbiDIhFey70QR+nQa4yyvKngow4q2fx07SlESObN66I71hmBgt4XyrjOoNhsgx/sl1QK3MzS4J3szJKii7YintGqiDzyrC1U/4AderAl9uu4vY8/bu/b4+RLJokT3nthizaz0SSrzAiRBDBgJmqKwr1CM6UNkt93kb8GHQGQBYH2LU67VAnQTD9Um8NbDo3v7z8RKTpnylobQchd9WhWJ02iL7gSCi97jGMkqEM/eERupX28nwq1YSWJsg2CRzSW1GgYDCneuCGl83OzfPyogmRf61i0Vlz6EzrB9/iZhYqw608EOQKMrjuC0xJuy+4cRrxXHSrSGiUvuHnVmrwV5PXKbx5bTvsrb3CYGWut7XeavWrnARb4SrB9XaAWnowUnuOHpt1j8APzFZj8WwN+n92HAOqW53QDJyrlvyvkQl+g58HA2w7Nzu/9FlfFRfDZoZQxndCwRNYPF1GGTdoMBzNgA7rUOgvR9MKVj4RmvNaqNHeSA2sMXLEQ1AD+daryHbrIK8Zptx4Lm/l9B6YsezBPiDWXCUR03Dh
 lYT2Ik/v
 kms8c4Lkz1nSIxA4uR3nOk42BShcL1ChXwB+eZgMTqMg7FKnlw9bfiIuRroV51jRvuqiyDH4KUtDVdpBdNvW4ngFT0uKvOxZw9PuAzgxQbjQcRYiPNK2VpO1AHQEQLbI47pcYK616vr2lntx3YFJGQpSsBYJcXZ4DWT97zvfJL5uuHuIQSvuO9i2jmhXSMFMg34LdwIT7Zx0ciJOnSCBBwnMmnrY3+fGz0gJA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently when a PMD-mapped THP is swapped out, the PMD is always split into 512 PTE-level swap entries.  To preserve huge page information across swap cycles, later patches will install a single PMD-level swap entry instead.  This patch adds the infrastructure to detect those entries.

Teach the softleaf layer to recognise PMD swap entries: pmd_is_swap_entry() detects them and softleaf_is_valid_pmd_entry() accepts them as a valid non-present type.  Clear the exclusive overlay bit in softleaf_from_pmd() before decoding, matching how soft_dirty and uffd_wp bits are already stripped.

Add pmd_swp_mkexclusive(), pmd_swp_exclusive(), and pmd_swp_clear_exclusive() helpers to each architecture that supports PMD softleaf entries (x86, arm64, s390, riscv, loongarch, powerpc), mirroring the existing PTE swap exclusive helpers in each arch's pgtable.h.  Provide generic no-op PMD swap exclusive fallbacks for architectures without PMD softleaf support, matching the generic PMD swap soft-dirty fallbacks.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/pgtable.h             |  4 ++++
 arch/loongarch/include/asm/pgtable.h         | 17 ++++++++++++++
 arch/powerpc/include/asm/book3s/64/pgtable.h | 15 ++++++++++++
 arch/riscv/include/asm/pgtable.h             | 15 ++++++++++++
 arch/s390/include/asm/pgtable.h              | 15 ++++++++++++
 arch/x86/include/asm/pgtable.h               | 15 ++++++++++++
 include/linux/leafops.h                      | 24 ++++++++++++++++----
 include/linux/pgtable.h                      | 17 ++++++++++++++
 8 files changed, 117 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 984badfa9a74..0de4a2917fe2 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -601,6 +601,10 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pmd_swp_clear_uffd_wp(pmd) \
 				pte_pmd(pte_swp_clear_uffd_wp(pmd_pte(pmd)))
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
+#define pmd_swp_exclusive(pmd)	pte_swp_exclusive(pmd_pte(pmd))
+#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
+#define pmd_swp_clear_exclusive(pmd) \
+				pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d73..a63567eb4e3b 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -357,6 +357,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	pmd_val(pmd) |= _PAGE_SWP_EXCLUSIVE;
+	return pmd;
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~_PAGE_SWP_EXCLUSIVE;
+	return pmd;
+}
+
 #define pte_none(pte)		(!(pte_val(pte) & ~_PAGE_GLOBAL))
 #define pte_present(pte)	(pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 #define pte_no_exec(pte)	(pte_val(pte) & _PAGE_NO_EXEC)
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 6f30aa8a6490..e8467ea4f4de 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -699,6 +699,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
 }
 
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return __pmd_raw(pmd_raw(pmd) | cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return __pmd_raw(pmd_raw(pmd) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
+}
+
 static inline bool check_pte_access(unsigned long access, unsigned long ptev)
 {
 	/*
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2aa529e882d3..9918b3f51efd 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -930,6 +930,21 @@ static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pte_swp_exclusive(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
+}
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline bool pmd_soft_dirty(pmd_t pmd)
 {
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 6faccfa63b09..e9d29439d817 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -870,6 +870,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return clear_pte_bit(pte, __pgprot(_PAGE_SWP_EXCLUSIVE));
 }
 
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return set_pmd_bit(pmd, __pgprot(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return clear_pmd_bit(pmd, __pgprot(_PAGE_SWP_EXCLUSIVE));
+}
+
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_SOFT_DIRTY;
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index e0fd318d4004..2dd7a5c590a9 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1529,6 +1529,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
 }
 
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline int pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 88888daeb018..988e59c6fa8a 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -102,6 +102,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 		pmd = pmd_swp_clear_soft_dirty(pmd);
 	if (pmd_swp_uffd_wp(pmd))
 		pmd = pmd_swp_clear_uffd_wp(pmd);
+	if (pmd_swp_exclusive(pmd))
+		pmd = pmd_swp_clear_exclusive(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 
 	/* Temporary until swp_entry_t eliminated. */
@@ -634,18 +636,30 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
  */
 static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
 {
-	/* Only device private, migration entries valid for PMD. */
+	/* Device private, migration, and swap entries valid for PMD. */
 	return softleaf_is_device_private(entry) ||
-		softleaf_is_migration(entry);
+		softleaf_is_migration(entry) ||
+		softleaf_is_swap(entry);
+}
+
+/**
+ * pmd_is_swap_entry() - Does this PMD entry encode an actual swap entry?
+ * @pmd: PMD entry.
+ *
+ * Returns: true if the PMD encodes a swap entry, otherwise false.
+ */
+static inline bool pmd_is_swap_entry(pmd_t pmd)
+{
+	return softleaf_is_swap(softleaf_from_pmd(pmd));
 }
 
 /**
  * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
  * @pmd: PMD entry.
  *
- * PMD leaf entries are valid only if they are device private or migration
- * entries. This function asserts that a PMD leaf entry is valid in this
- * respect.
+ * PMD leaf entries are valid only if they are device private, migration,
+ * or swap entries. This function asserts that a PMD leaf entry is valid
+ * in this respect.
  *
  * Returns: true if the PMD entry is a valid leaf entry, otherwise false.
  */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e38f069c1c91..0b985ce6673e 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1917,6 +1917,23 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 }
 #endif
 
+#ifndef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return false;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+
 #ifndef __HAVE_PFNMAP_TRACKING
 /*
  * Interfaces that can be used by architecture code to keep track of
-- 
2.53.0-Meta



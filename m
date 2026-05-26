Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB896CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500B06B0093; Tue, 26 May 2026 09:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1816B00C8; Tue, 26 May 2026 09:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3538C6B00C9; Tue, 26 May 2026 09:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1126B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF01DA020B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:36 +0000 (UTC)
X-FDA: 84809592672.17.7B2245E
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf23.hostedemail.com (Postfix) with ESMTP id BBD03140012
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="t KGlIuU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FhBpHRRE;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCsrlFlMXo0746uAMjG4gQ0SrYEk0HAPTcU35/Iu7B4=;
	b=U+ETAf1Gvg1gb25Nqeob5EsrRR+qzvXAJ3di5pC7WIbZQdsqYrEfTFDad9ZjMn1U4nQvAb
	kfMEI/hKhhVCq5zRowa+m1zAS5/c7vgHgFI4qfmxgxn7Lx3lLWGR8sMSKw8evKn/HcPHIX
	P9o6ZbbV/FOqPgCHDhufqA2tSmIF6NA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="t KGlIuU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FhBpHRRE;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800734; a=rsa-sha256;
	cv=none;
	b=mnH0ERh7ybEym8MI8nhVl7VB25PQmjbX6D3euYghyOBe0smaNICfvQtMwzygyplPByCRqi
	IrMHhY7mzM8DTO+AOWvKEfLDgFX5+NZMNUJSh5/RQca0mKuC8/NcTn+73w5VF6SgNaJcb/
	yjeOiAVxt6lPWEVaRGFdv3hJyaE8zNo=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 852C67A0188;
	Tue, 26 May 2026 09:05:33 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 26 May 2026 09:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800733; x=
	1779887133; bh=HCsrlFlMXo0746uAMjG4gQ0SrYEk0HAPTcU35/Iu7B4=; b=t
	KGlIuUrpeKL1ig9ccVedk4hPGXMKxXw7ch2hWhs47PTr9IKp+nMXMgQdHQC0ZQcA
	oI57e9wBHL1QR0avdhjXKO1J52khCFFzhqLbe9HS4+VaF70RnSdcxVX1sawHKkRR
	XcwTu9okXntQpx03Pt9Ote57M7Ggp23YTSiTUXAx3XmLkFh5tnM39cW8lLBX1YQg
	PkOiBQjWtEY+RVxvRsGm1WEgM0Vt0Q6SbH562HhWbGwJb1HKH6o/MRsRqEvCJQE7
	OaeoZWkf5eAsgFV3AkAJ+OOhj/jDX5j3oG88I+RF6+19lZWEjwNkXPZ/rdEJ/TDy
	lwh2DY5KbWMiMgvSkniSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800733; x=1779887133; bh=H
	CsrlFlMXo0746uAMjG4gQ0SrYEk0HAPTcU35/Iu7B4=; b=FhBpHRREWXFtIukan
	ZkVPMd3xREGBPADUYUlFf8PqWBKKXaB/lSHru1stf4QjcHm43U2kWx6tu+FbfBKn
	AeaBl23bc9lyFz2txAPRrttzIy4xMvmqrEOiGBURZo/zQyz92PaNOdSEVFQGEyEr
	YQ7VVO6giF1hmg7TojPOicHeJnOtQ5BL44GQlaH4ghyK8i6cvgmhiLEhLNE+IiI+
	GCnkfXkGnP2dY4l1vJZCj8t793mrSzw8STUIwiCUiS+dgiaIxRSNt0Z6D2t3lZq/
	Xervj4So2y+wT9GiL90FK7uJKaP+1xMei3iyNkaaUXf34ZxIiKOIQ4LWR09gPOCV
	XBPFw==
X-ME-Sender: <xms:nZoVaonDtt2k8QdG9CCgIEzGpeegwrNjAUjpG1tLtxYPuHJ5x8wq_w>
    <xme:nZoVarye9HhomeXUEuynCzfEBBnoeZcTYG-tqU8DAcxSzkcFWNtaIojM0qtYIu1yG
    EqrxN9IcSI-l1uoibp-1INEo-1eUzoAIKkpGxV919LPt6ano7Wm8Ok>
X-ME-Received: <xmr:nZoVavK90eydQZdtT78reagxpHE9dJN8YtFiJfzWM-m0FBA5vJQpeF6ZOlKvpA>
X-ME-Proxy-Cause: dmFkZTFqbc6fXhopwy+hAOgtjHy4pTGuHjfXZXlZdTx/k4tQMvhyI2vZzCnM5UZQOJLsQ6
    MBNN4KMbmYZdvz5T8cIgQbo11hylcsT72WGhRELqB/NWcVS6dsw2DuAcdzpihvUx/kC7Rx
    TXAh0tKkGSNzPC9MzCVari3WizUMLAhLPeZR8i+UtrjD8sUs4gbS3nJjyE6j7x9rQvwYKa
    Vo1Cdu33hYc8iqP/ATtq14j2/nP5x/Vq5r72hY07O9WQkAcMkY7hJXfuznzppNnRfPI/E0
    vXoMBAS+e5kQ5+gg0Sxc802FUu+VDDuhW3vvNg1v2vn17b0MDhDS2LwVSA9QGKzjnWPAVG
    qjlEBrv2x0pedg7+xAqspi2iHWlK7FMZDywfadvLqN5YjoMLNV+9sasygPgpJ0F+J/RB0d
    4roJ4OeCLMaBdYF7KYAyTaAR3d0O3hDAIoZ2znCSBcXyE+jlsTfrqJr5AaziQ46fYBxipx
    I/1piC/oKJ/HbuoYSe55uZ8xCqpgY26CjnbNIp+9YHdLszG4dzV5If3WxTNGIb+K28l/8S
    wj4WeSSSGYfllEGWGwW2PUHIXkF1enaIUm2ImD5D6v5MB2TeBBgGlZhWppk457ftQABBbl
    kqrHgMv0enRAyeRxhYTR0L7qRD536iI8FOg7oKBxDmvO1TZgWkQSeZZ3zLeQ
X-ME-Proxy: <xmx:nZoVauJc6a6_7hPdfmhJdVpe0PDmsn1F06ZzAmL8z1whfL6a1Ma2ZA>
    <xmx:nZoVauXq742cjI9OHv4_o5GlFM1BZcoJIElUT5nKxcxiANb8CU1tDw>
    <xmx:nZoVamDTlRwTE31MUecNwPfMIn7dPMoqDbYtGNgkKnlMgCUdrjePFQ>
    <xmx:nZoVahFmJDSik2drmVX0vxxWPRUot-czj3rp-5GsI45gIz1S0NuoJQ>
    <xmx:nZoVamFUZr-jxYm_ZK0okSvq1aFNXoQAuR_8FiYX9JyN1_AAXXQ7VH8E>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:32 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 06/18] mm: rename uffd-wp PTE bit macros to uffd
Date: Tue, 26 May 2026 14:04:54 +0100
Message-ID: <20260526130509.2748441-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1e8ozby8cnpwrtodifr5xjbw5np4n97a
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BBD03140012
X-Rspam-User: 
X-HE-Tag: 1779800734-555647
X-HE-Meta: U2FsdGVkX19cnSWBR1v+wkx+trLwLBEwi3+0/FdPKqoRMCFTb4i6UNzBoH66M0omqo3KXpssYONMkD7E9kNLGvlE7Gewda0iJ3M5z7O+mHYett/XwLKJZUAjh7ByAvHdJKOWe/OxcpSZaO1iZdPZqhRFCt3u0Qq1m9i2cULjJ7f0p8VEREwgj174LHswrhSTbc8q+Y0UYExAHXrMkZFXTK4EJzLJ8vtRMPK4A6gslNIj8B0dcsMgeXYgx4nI5p+hH/KB7QjO5ezQWDhTqWopxlaUbLth2nzGPNXaRy6KNEbXkX5+lgkRkXpsOVztK4MtjyTvxBdo7PdvN4D6UHXXW3KXfYeE4KPEyjydaiPEOqcgbZDXErYVrnOVdPSaB/yfBLzJGgh4OqxWV8Jx+9TB+NT57qGiWWNKwtWA9tS9aizbQ9zvwE7Nw49pJhWBaaeFQhzQy8Glerd9OPWbf6AqsNsrvx8HRJrR2ar7kI+fzoLhnsaB//Y7CEGLCxYYJL6+l7zqUdydXUcE0MQUx6e7yb0NhHHCOSecSNl+569kPv4sjiHMr0uE75frPJDcTcEJIE6e2Ryab+hdBpcpPKsCH5a2KHlnXkblipS906lfFUG6pLcDHeb5AtuGm9aHRJUV67+JN76ZyMPtCRquxniyBkwpIA1qNgn0eHUTy1zBkpddzsXDC7omuHmIF53u2hbnskEbREwWJr7t+6AsJnYAdzpxUAqZEYTis2WE+zW9nSBLPDbp58QFSW5xvWi1zd9sABk2yw7OjVAH53Vsw0nxv/AAVe+JVpoZBtvhOcL6KSXxfj7CnegsTJZqQJ8xupQhV9AWzQ3tXmHqophS9/Em0zFz1Bb4jf7YDi/ZxX+1w88gl5NkIvpn8CgJkrtFDSEqqDaYpiCN263fiw38zFjgLzV6F1LXYGWF8OzA8ICvb170wd8vdKCnAeYJBwU51v7fHTIwQel2fOZcbO/jZA8
 KoLGHpMZ
 mTiJa7AC7ajwvGGHgrEMPHedquawuliYZVRfwLRQV3Y2o0nJPKGEEG29Nfwm5nrKM3nH8Xn5G/MQ6xtXBZQOZWfXnxhVD3FoEuKQ0MmM4MG3zL9TAf/Ep6GxnxpSrNHtW6dw20WOQXIQy8R4aWgJiempfZ83JDiPm3cyuKhbXDmOffUXTkpTxqsh386De2oJ9Ece60SRs6zet1ZZU7UGvlujx+7KvPbWv+JITlMxTM6g/2QWwBCoSNqhTDdQnoMCB+NRlyfDxcWcYwbwZvNFJITVzicSlR/a4RUnd2NvaZG8Bd/DlZ3V1qasc1bfpoAKTospHz6l6Qtbrwjr+NJChPCHCpUp92aK747cflaW0loBtyclF0B1QUhGmypCuScQf/jYnZV4qoeqHdABe1ylMrIc1GNn0Hcv0fLg0yYDOgbEkGDwXVYZVAaH8W3b53IBglhU/7bongTEA6xQkO6OqXBNrDNBhv8nMHACCcq3Annc9m/7wtVlj5CuFM2nnQFrf5GolLx/X9I8xP6dll3jV0VlLAutjJ47duattgu8ksLXrVe+Ichyi6YnkA+2i0p5RzFNBnIYdZaVfohVuL5CHQtkxvMvKhEfy1UArG//3q7eFvLitRx4KkogcRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The uffd-wp PTE bit is about to gain a second consumer: userfaultfd
RWP will use the same bit to mark access-tracking PTEs, distinct
from mprotect(PROT_NONE) or NUMA-hinting PTEs. WP vs RWP semantics
come from the VMA flag; the bit is just "uffd has claimed this
entry." Drop the "_wp" suffix from the arch-private bit macros so
they reflect that.

  x86:   _PAGE_BIT_UFFD_WP  -> _PAGE_BIT_UFFD
         _PAGE_UFFD_WP      -> _PAGE_UFFD
         _PAGE_SWP_UFFD_WP  -> _PAGE_SWP_UFFD
  arm64: PTE_UFFD_WP        -> PTE_UFFD
         PTE_SWP_UFFD_WP    -> PTE_SWP_UFFD
  riscv: _PAGE_UFFD_WP      -> _PAGE_UFFD
         _PAGE_SWP_UFFD_WP  -> _PAGE_SWP_UFFD

Pure mechanical rename -- no behavior change.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 arch/arm64/include/asm/pgtable-prot.h |  8 ++++----
 arch/arm64/include/asm/pgtable.h      | 12 ++++++------
 arch/riscv/include/asm/pgtable-bits.h | 12 ++++++------
 arch/riscv/include/asm/pgtable.h      | 14 +++++++-------
 arch/x86/include/asm/pgtable.h        | 24 ++++++++++++------------
 arch/x86/include/asm/pgtable_types.h  | 16 ++++++++--------
 6 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 212ce1b02e15..09d7c00cf405 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -28,11 +28,11 @@
 #define PTE_PRESENT_VALID_KERNEL (PTE_VALID | PTE_MAYBE_NG)
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-#define PTE_UFFD_WP		(_AT(pteval_t, 1) << 58) /* uffd-wp tracking */
-#define PTE_SWP_UFFD_WP		(_AT(pteval_t, 1) << 3)	 /* only for swp ptes */
+#define PTE_UFFD		(_AT(pteval_t, 1) << 58) /* userfaultfd tracking */
+#define PTE_SWP_UFFD		(_AT(pteval_t, 1) << 3)	 /* only for swp ptes */
 #else
-#define PTE_UFFD_WP		(_AT(pteval_t, 0))
-#define PTE_SWP_UFFD_WP		(_AT(pteval_t, 0))
+#define PTE_UFFD		(_AT(pteval_t, 0))
+#define PTE_SWP_UFFD		(_AT(pteval_t, 0))
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
 #define _PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 873f4ea2e288..3eecb2c17711 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -343,17 +343,17 @@ static inline pmd_t pmd_mknoncont(pmd_t pmd)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pte_uffd_wp(pte_t pte)
 {
-	return !!(pte_val(pte) & PTE_UFFD_WP);
+	return !!(pte_val(pte) & PTE_UFFD);
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
 {
-	return pte_wrprotect(set_pte_bit(pte, __pgprot(PTE_UFFD_WP)));
+	return pte_wrprotect(set_pte_bit(pte, __pgprot(PTE_UFFD)));
 }
 
 static inline pte_t pte_clear_uffd_wp(pte_t pte)
 {
-	return clear_pte_bit(pte, __pgprot(PTE_UFFD_WP));
+	return clear_pte_bit(pte, __pgprot(PTE_UFFD));
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
@@ -539,17 +539,17 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
 {
-	return set_pte_bit(pte, __pgprot(PTE_SWP_UFFD_WP));
+	return set_pte_bit(pte, __pgprot(PTE_SWP_UFFD));
 }
 
 static inline int pte_swp_uffd_wp(pte_t pte)
 {
-	return !!(pte_val(pte) & PTE_SWP_UFFD_WP);
+	return !!(pte_val(pte) & PTE_SWP_UFFD);
 }
 
 static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 {
-	return clear_pte_bit(pte, __pgprot(PTE_SWP_UFFD_WP));
+	return clear_pte_bit(pte, __pgprot(PTE_SWP_UFFD));
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index b422d9691e60..d5a86b4df3ce 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -40,20 +40,20 @@
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 
-/* ext_svrsw60t59b: Bit(60) for uffd-wp tracking */
-#define _PAGE_UFFD_WP							\
+/* ext_svrsw60t59b: Bit(60) for userfaultfd tracking */
+#define _PAGE_UFFD							\
 	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
 	 (1UL << 60) : 0)
 /*
  * Bit 4 is not involved into swap entry computation, so we
- * can borrow it for swap page uffd-wp tracking.
+ * can borrow it for swap page userfaultfd tracking.
  */
-#define _PAGE_SWP_UFFD_WP						\
+#define _PAGE_SWP_UFFD						\
 	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
 	 _PAGE_USER : 0)
 #else
-#define _PAGE_UFFD_WP		0
-#define _PAGE_SWP_UFFD_WP	0
+#define _PAGE_UFFD		0
+#define _PAGE_SWP_UFFD		0
 #endif
 
 #define _PAGE_TABLE     _PAGE_PRESENT
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 48a127323b21..ca69948b3ed8 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -405,32 +405,32 @@ static inline pte_t pte_wrprotect(pte_t pte)
 
 static inline bool pte_uffd_wp(pte_t pte)
 {
-	return !!(pte_val(pte) & _PAGE_UFFD_WP);
+	return !!(pte_val(pte) & _PAGE_UFFD);
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
 {
-	return pte_wrprotect(__pte(pte_val(pte) | _PAGE_UFFD_WP));
+	return pte_wrprotect(__pte(pte_val(pte) | _PAGE_UFFD));
 }
 
 static inline pte_t pte_clear_uffd_wp(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(_PAGE_UFFD_WP));
+	return __pte(pte_val(pte) & ~(_PAGE_UFFD));
 }
 
 static inline bool pte_swp_uffd_wp(pte_t pte)
 {
-	return !!(pte_val(pte) & _PAGE_SWP_UFFD_WP);
+	return !!(pte_val(pte) & _PAGE_SWP_UFFD);
 }
 
 static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
 {
-	return __pte(pte_val(pte) | _PAGE_SWP_UFFD_WP);
+	return __pte(pte_val(pte) | _PAGE_SWP_UFFD);
 }
 
 static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(_PAGE_SWP_UFFD_WP));
+	return __pte(pte_val(pte) & ~(_PAGE_SWP_UFFD));
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
@@ -1157,7 +1157,7 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 2:	(zero)
  *	bit            3:	_PAGE_SWP_SOFT_DIRTY
- *	bit            4:	_PAGE_SWP_UFFD_WP
+ *	bit            4:	_PAGE_SWP_UFFD
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index c7f014cbf0a9..038c806b50a2 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -413,17 +413,17 @@ static inline pte_t pte_wrprotect(pte_t pte)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pte_uffd_wp(pte_t pte)
 {
-	return pte_flags(pte) & _PAGE_UFFD_WP;
+	return pte_flags(pte) & _PAGE_UFFD;
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
 {
-	return pte_wrprotect(pte_set_flags(pte, _PAGE_UFFD_WP));
+	return pte_wrprotect(pte_set_flags(pte, _PAGE_UFFD));
 }
 
 static inline pte_t pte_clear_uffd_wp(pte_t pte)
 {
-	return pte_clear_flags(pte, _PAGE_UFFD_WP);
+	return pte_clear_flags(pte, _PAGE_UFFD);
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
@@ -528,17 +528,17 @@ static inline pmd_t pmd_wrprotect(pmd_t pmd)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pmd_uffd_wp(pmd_t pmd)
 {
-	return pmd_flags(pmd) & _PAGE_UFFD_WP;
+	return pmd_flags(pmd) & _PAGE_UFFD;
 }
 
 static inline pmd_t pmd_mkuffd_wp(pmd_t pmd)
 {
-	return pmd_wrprotect(pmd_set_flags(pmd, _PAGE_UFFD_WP));
+	return pmd_wrprotect(pmd_set_flags(pmd, _PAGE_UFFD));
 }
 
 static inline pmd_t pmd_clear_uffd_wp(pmd_t pmd)
 {
-	return pmd_clear_flags(pmd, _PAGE_UFFD_WP);
+	return pmd_clear_flags(pmd, _PAGE_UFFD);
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
@@ -1550,32 +1550,32 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline pte_t pte_swp_mkuffd_wp(pte_t pte)
 {
-	return pte_set_flags(pte, _PAGE_SWP_UFFD_WP);
+	return pte_set_flags(pte, _PAGE_SWP_UFFD);
 }
 
 static inline int pte_swp_uffd_wp(pte_t pte)
 {
-	return pte_flags(pte) & _PAGE_SWP_UFFD_WP;
+	return pte_flags(pte) & _PAGE_SWP_UFFD;
 }
 
 static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 {
-	return pte_clear_flags(pte, _PAGE_SWP_UFFD_WP);
+	return pte_clear_flags(pte, _PAGE_SWP_UFFD);
 }
 
 static inline pmd_t pmd_swp_mkuffd_wp(pmd_t pmd)
 {
-	return pmd_set_flags(pmd, _PAGE_SWP_UFFD_WP);
+	return pmd_set_flags(pmd, _PAGE_SWP_UFFD);
 }
 
 static inline int pmd_swp_uffd_wp(pmd_t pmd)
 {
-	return pmd_flags(pmd) & _PAGE_SWP_UFFD_WP;
+	return pmd_flags(pmd) & _PAGE_SWP_UFFD;
 }
 
 static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
 {
-	return pmd_clear_flags(pmd, _PAGE_SWP_UFFD_WP);
+	return pmd_clear_flags(pmd, _PAGE_SWP_UFFD);
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 2ec250ba467e..af08d98be930 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -31,7 +31,7 @@
 
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_SOFTW1
-#define _PAGE_BIT_UFFD_WP	_PAGE_BIT_SOFTW2 /* userfaultfd wrprotected */
+#define _PAGE_BIT_UFFD		_PAGE_BIT_SOFTW2 /* userfaultfd tracking */
 #define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_SOFTW3 /* software dirty tracking */
 #define _PAGE_BIT_KERNEL_4K	_PAGE_BIT_SOFTW3 /* page must not be converted to large */
 
@@ -39,7 +39,7 @@
 #define _PAGE_BIT_SAVED_DIRTY	_PAGE_BIT_SOFTW5 /* Saved Dirty bit (leaf) */
 #define _PAGE_BIT_NOPTISHADOW	_PAGE_BIT_SOFTW5 /* No PTI shadow (root PGD) */
 #else
-/* Shared with _PAGE_BIT_UFFD_WP which is not supported on 32 bit */
+/* Shared with _PAGE_BIT_UFFD which is not supported on 32 bit */
 #define _PAGE_BIT_SAVED_DIRTY	_PAGE_BIT_SOFTW2 /* Saved Dirty bit (leaf) */
 #define _PAGE_BIT_NOPTISHADOW	_PAGE_BIT_SOFTW2 /* No PTI shadow (root PGD) */
 #endif
@@ -111,11 +111,11 @@
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
-#define _PAGE_UFFD_WP		(_AT(pteval_t, 1) << _PAGE_BIT_UFFD_WP)
-#define _PAGE_SWP_UFFD_WP	_PAGE_USER
+#define _PAGE_UFFD		(_AT(pteval_t, 1) << _PAGE_BIT_UFFD)
+#define _PAGE_SWP_UFFD		_PAGE_USER
 #else
-#define _PAGE_UFFD_WP		(_AT(pteval_t, 0))
-#define _PAGE_SWP_UFFD_WP	(_AT(pteval_t, 0))
+#define _PAGE_UFFD		(_AT(pteval_t, 0))
+#define _PAGE_SWP_UFFD		(_AT(pteval_t, 0))
 #endif
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
@@ -129,7 +129,7 @@
 /*
  * The hardware requires shadow stack to be Write=0,Dirty=1. However,
  * there are valid cases where the kernel might create read-only PTEs that
- * are dirty (e.g., fork(), mprotect(), uffd-wp(), soft-dirty tracking). In
+ * are dirty (e.g., fork(), mprotect(), userfaultfd, soft-dirty tracking). In
  * this case, the _PAGE_SAVED_DIRTY bit is used instead of the HW-dirty bit,
  * to avoid creating a wrong "shadow stack" PTEs. Such PTEs have
  * (Write=0,SavedDirty=1,Dirty=0) set.
@@ -151,7 +151,7 @@
 #define _COMMON_PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |	\
 				 _PAGE_SPECIAL | _PAGE_ACCESSED |	\
 				 _PAGE_DIRTY_BITS | _PAGE_SOFT_DIRTY |	\
-				 _PAGE_CC | _PAGE_UFFD_WP)
+				 _PAGE_CC | _PAGE_UFFD)
 #define _PAGE_CHG_MASK	(_COMMON_PAGE_CHG_MASK | _PAGE_PAT)
 #define _HPAGE_CHG_MASK (_COMMON_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_PAT_LARGE)
 
-- 
2.54.0



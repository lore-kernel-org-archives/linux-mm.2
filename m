Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7866C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958756B00FC; Mon,  6 Jul 2026 04:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E356B00FF; Mon,  6 Jul 2026 04:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF9B6B0101; Mon,  6 Jul 2026 04:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4E76B00FC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9276A0327
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:15 +0000 (UTC)
X-FDA: 84957724950.01.73D1DE2
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf03.hostedemail.com (Postfix) with ESMTP id B970720009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="P WnJ99h";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Yg3kilDa;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327693;
	b=HymQE3bvNTwXwHzBqFhCPgIZIHJol9j0Ci7DM/At4lDKXfhPM6172XZbmUYHmcOPB2szfG
	jkUHhCIJUaMpNq7LPR4edIMF55+9beEe2XAC1x0Upm/FwTLIMpHak791eo0LqR6yZljSPs
	1XCV230MdIFQeWQZ1FkJbgvtLN8/xX0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="P WnJ99h";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Yg3kilDa;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAw5Wnaz1Tg+5juWDZ07G/maveeDBAbOyuy4cG6fNA0=;
	b=BZzOl4TDHYXLEa7Z/CDrHaOhw9A4Gqw6DYNyccCsuyQjNYLf0+MWWjVxkZeVHzJEAv3NPi
	nV4QS5QfVshFLgkMFSfQvfilzByjX/J04w6IdFJjSVBH4m6U3/lgul9xdUkeQ1N+I/gkX/
	1xNSkMeFX4NuXruGEX+6s4aZ/Vch7rs=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 8C5C11D0010E;
	Mon,  6 Jul 2026 04:48:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 06 Jul 2026 04:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783327692; x=
	1783414092; bh=hAw5Wnaz1Tg+5juWDZ07G/maveeDBAbOyuy4cG6fNA0=; b=P
	WnJ99h58/rB6PN99Xwfet62X42z/lq7Cst4fBjd6as8xeQsVZJysjG+fs4g0ulO4
	LriWm1tEuB9rZWuqnrpHtSY4GiGrEF9hVYs3yULVneB04gyMOTWHDVAkxWahF61C
	Un9ve9dJkj1lzHbHP1OkvAaXLhOBZv6nIasK1anq2S12iOIWwBIToiWTKmMAjRuu
	gmqQkc0rU+SwXQeIqQZq1d7lLjawaaHo+x0jwRrRagKc7wfwhNEcEvatxVPJON2B
	oBkA8RxlSeMQNkhbffAyksF/UTCVCByxjXjlFC0QPqn3EKAZbCgViOQTDErYELr0
	fiRZjzFyG2LAj3223WaiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783327692; x=1783414092; bh=h
	Aw5Wnaz1Tg+5juWDZ07G/maveeDBAbOyuy4cG6fNA0=; b=Yg3kilDackj3i6LbL
	h5D5qc42WyzGxRXRtaU2e5KJNbUBigtt/Hqzu2bI5UD3S8hRQh9KCxkFzwv+iNSa
	YMEtLGG6aSWlkwJ45sQ1fsCntJekpP7HNszhWyOPNFqEZ38aHqi0PN6Zuhei6sup
	U1nRZqHJcdmXYyDRF93POXwamaH3EDQS60NYte5yet5v9kT7DzmYtKmN246jbwnA
	zbu7muZO89lR223oWoqSm/ieNxxQL+5pw1M/4jpjGLimwICS+Mc+VL72DPTBLgCg
	m1JpDL41WZqr9UpxwKnKe+YAFkJNqmmnDi6mT12VCs4V/gM8xAE/EwA6nwyJZfRn
	9+m5w==
X-ME-Sender: <xms:zGtLalbmEcGFOA8xm9wHhpusVlX82AyhrSyzHxjGwWgm5gHI7EC0ww>
    <xme:zGtLagWeAgNz8k_H57LbcAroVBs7PcF7ggfwFdTshdHMiTvmLQpcKM3K5f9EUN0UO
    m1IR2gc3HTV2OxNkXUk5vHGdERx1QbY4MbmjjxHdZG5LkKOtUiNmiNA>
X-ME-Received: <xmr:zGtLagcGb-3wXysxcUuKKU1OWJMGYC99w7AcDpBlGmkwaBBKQZ5hy_taen1bYg>
X-ME-Proxy-Cause: dmFkZTEaPZdviD2XbalDAKS8tszO4Hte+xIg0jgPrUan8C55y4EV/KJ/Eom7XifH61NPsj
    FpHJNCv922yiJ1/uYMxxnyO7ohj4FdG9jlt3xAQ9ulNn8sNn16Di9FfOZz57KTymaDzX0X
    Oa0xwtmkNizaUUH2ahz49zlPrt4p4TivjhaMFb9MByS5fcrdsopAtNxM42z/KLfZEzontY
    dL7oYKud5vnDF47FBpMkQLkbBVAcKZwKKE3gao9aGmCcABxV7K5XPoDt0NUeM7mdB6UBaE
    xlUOaRlAzH3c/cAXi9JZvKpCWHAqobGBBf/9tSV3q5HJYXgQVn2KMNtd8oDpj8yLDeA9L5
    kfH3y02EmCP5xKadHHRM28sYoOu+UDo9Wjhu0tm+BnTBePD/4u9TFYCJYUagO/nBnyWQFc
    M4TAsPOX8v8h9QGmncUgnTttizGkSwPy8RRngxw8GAuufIE8iD+EjKqJM/DbiMzOy3vF5g
    mmaKI3+SokjR0lv1fZMhpGumF1MZqqk9phVRg8mfbkm/lnZCex4NkI2RkbWKOFQQfwkFMY
    N0S1xB+6Hp9SUTi74K4o+XYk4MMwk4VYO48Ye8CuYRVOHG71MYMawjbrDjC4qjmO1Ei+M9
    CKEhKnx4XGvXZCBQO84f5WPfJMwIRcRf4bqXcQiwJGGE16Fh5SkvF34LASOg
X-ME-Proxy: <xmx:zGtLatPr_-n4upIa1QkP8baF-2oCiQmhRArdZv1yTD0bLsycNvbUoA>
    <xmx:zGtLaoJNI7-Chc9mDnF_R2T2EGEJpywv0TaAJqm_zDfzBku_fNfIsw>
    <xmx:zGtLajney0iSyMaue0xG8zZZPBLbuIBTocwZrlfG4PCbqpinV12XPw>
    <xmx:zGtLanb68cJEH8SExMCZLk5AYfeya1ZFNVZnLNyKFl39hKn-vdyG-Q>
    <xmx:zGtLasYvDasvChmVx7In0Uh0ziXZ_8xnWn_9jxF7Mt2GlRX-f-Du8WGy>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:11 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v9 02/15] mm: rename uffd-wp PTE bit macros to uffd
Date: Mon,  6 Jul 2026 09:47:51 +0100
Message-ID: <20260706084805.8400-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B970720009
X-Stat-Signature: yusjwth9z6nbzrybahjsjkyn8fgzwd4y
X-HE-Tag: 1783327693-413632
X-HE-Meta: U2FsdGVkX1/QiYLZae6vDyPXoSr+DxUW1hLUUEmvbGzR2Pzp0guWPDqbdSY6tQ5kbwzy5kxppMETM8MtVq8RlLjjHG2UgmTBg4E/cnrdTSfsOg6/B3Nujb+AR4mhGHm00q5aczLxhkorcQWssRAK8UbK+3cfEoNrJ2fiDnIj3kmg6IPOgBnqrn6yms36FqplkW53wUw2R2qWpKJhTUlW6NDsNE3CAg7BNyhh7b0GmicUwlDRZGdYBxQK+kaRk82YghSfI/NVWWsVdGNYwm6UxlGX86FCRBBlRk006Dute0Unaw7jj8z5QGvFmQX6qsZ2WADpIOjKtN5nAyoj/IdGNZYBNNd269ynpQuxY1KvANY4W5fu22jGv5NPV8uo4bH6zbr0tn9GKmPm0F0iG6xOj/RbCtxfTn6qFoz1Di3M6PGPkiFlbQio9kpUF4KVNgyUwY0cZ/FQoDFWMO8wlaBqck3tlgAhm6MGrlUJjQXy8xFARj9r1mz00TXhKyAhUPJIJQcx/Sx35HWylxhyWJOWE6fhR8u3os9056W9BUgsnxNsZpmAE//vIBhYk3ar2CBzmbgPy75uZE4s3YuoRyXF8ZPjWo/dcQ+zC0QkDRr/poxEekCm6fnrLO6YUn2c1bTeZM4O/2AzaGV5D+oI06d9bJ4O+eGAbcKKLOJ6Z5C/1AAoRYwkOYsogBOue92kNemblYX8PoQZGjTLH0NP/tnNkDtwTl1OwRrZNy5/6ceMlDZqeUW1oi2toV4KNrbYi3+oCxnxFiltwOuifw9+aQiOeccQ6cDjoAW63OET4CzQqCMfz3kBqZEaN/QbrB3afSx0/m1WkgcmBOoj8ReXJjtF7A/srnX3dgnHjzNMKHTMoiyzrfTqvHcqVAbi8C0L6ucfxd98gakJaDsh4ezy0H7co0ZbHsWaIn4Gaiqc3Uqj/u6tN9uhSBm9JXlfW/HWdZMqKIVlE2AUwDLwaQaUSf/
 D86bVQ5R
 k49APDxQwhwXSdu4zxYudaYymjGhjJQhV4W/tjoYy6QpJlEQph6cABkuXy5qbleJNlF2kCUr0Ji2YKxVOtwpKUTo3qJLeFerqNgGGP2eBCNssJfSENCl194RIn25FbFry+PEm/VWA0DUdRlhu5YWrHmfSAXaGo0u/z13jTdncUd27hgs78msisBgB6nIa3raeG0B3MbgtH37/sUvWnreaHvoESo1xE/9B8UeSUVRf2uVshwjDvBxS7vS7PZUydiw0aGxhKbrd8nFOD4mZlXq1JCpqKE73wxGMU8KyUJhnsd/O7kGzNP/9TrqB2PdwXwc5J79TT37wmKn1txnrWDmCpOgF7kXmjtCcnV4AhJH2qCe7PVZoBZffjBODCyOmQMM4A5hGPPqqNzo3dPudQTWVrYPWjGg8XU0AiaMIUv0kC3YyC0ItMVy4DcesySnvcKExPK9eWZwSWdut1u0WhW2CtLpBXMxMdNL/4kQS2zUcMXsBGeJ/Ao2eNLuYCZzdYUGY+KjwttxzXFLe80NewWhPx7qI3Q==
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
index 83eb707508cc..6f6d0fd7d62a 100644
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
index 8139e0b2f008..00ae4cd7f0dd 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -415,32 +415,32 @@ static inline pte_t pte_wrprotect(pte_t pte)
 
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
 
@@ -1167,7 +1167,7 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *	bit            0:	_PAGE_PRESENT (zero)
  *	bit       1 to 2:	(zero)
  *	bit            3:	_PAGE_SWP_SOFT_DIRTY
- *	bit            4:	_PAGE_SWP_UFFD_WP
+ *	bit            4:	_PAGE_SWP_UFFD
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 36c44350f843..0633bc0f6f1b 100644
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
 
@@ -1562,32 +1562,32 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
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



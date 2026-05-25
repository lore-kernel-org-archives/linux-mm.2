Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D31BCD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B0A6B0088; Mon, 25 May 2026 07:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB436B008A; Mon, 25 May 2026 07:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EAE66B008C; Mon, 25 May 2026 07:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AA426B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:37:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 553581401EC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:37:59 +0000 (UTC)
X-FDA: 84805743078.16.D245A29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 666FC4000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:37:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nlTOzEvX;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65V0pZt8PzOC8ExjP4JKi8FrLHOgvVkRbRky8UNSx0Y=;
	b=QfgJzf04bc8xO+eW0ykUYm+jaUEvH0/0Cx01QZ42ckpkW/s8KLo5slomuWNCH8n2c82stm
	F2wXeen+/mJYGzxk/ZyrgqzAsGD++G4Omma1yz7gVX2/xzWk/z7gxbbVyy71EP7DQ8t4IL
	zmGP/WVZDC3T3Lx2e1TiH+5ErSluq8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709077; a=rsa-sha256;
	cv=none;
	b=wb78wYZYiTfCn16tYiueGsbTRluX1jjga2tBlIfq1TsfwUaUmZtShUUsyZd+534ER6NdK2
	dZkzQjqIeenmPw9mNMM2otPL+bDvHSj7/uPSchuhDl43h1vwn0w856otXjtLoFEvDXp1Dv
	7BTfgFXvoiWUYxr986xA/UgtqTggVYM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nlTOzEvX;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D94B760200;
	Mon, 25 May 2026 11:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96ED1F00A3C;
	Mon, 25 May 2026 11:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709076;
	bh=65V0pZt8PzOC8ExjP4JKi8FrLHOgvVkRbRky8UNSx0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlTOzEvX7CJO6pRhOkLLPaEOLoatwRrGEu+RHmVfeFPph1nlTL6ml7JS8XyGLWQhB
	 asdpso/WACPmiKXV02Y8Ugx6lB4RJIPSNKHHLPxrYElyeEBEHRA1pGsIHxbBdEBONk
	 JhZTRbsVH/UrLQDKq866Jnl3Dmb+J05/BX4gCzpfjzTMhv1SubDQWJwEGki2uAf7HS
	 kdtGzb0Vi1GMWNg6AS/kfhfv9Xuq2LDL3169IKLPgx0h3lccztcRt6jGUOs5piGKso
	 LHErJQZRKfb59JgPF+cyDpVY6fG7WXTmLvG5Zr4Tn5pGZLM9Z5vW+QItvtsCnF0PWq
	 Pb2zI0j4RFViQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 00B4EF40082;
	Mon, 25 May 2026 07:37:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 25 May 2026 07:37:55 -0400
X-ME-Sender: <xms:kjQUamdL_trb60rRkavhCJ-D5nYPr7jzMfgsvGw6Rih9FCdABqOtYQ>
    <xme:kjQUakLsIlk048cJavAsTqke7vEgC-b6ISchs81mVIhexvDvYSMh_zxM6xJu9hxky
    gS-D5-MfDoFMpPvq6tZzdmR0asw57jvFuLdh5Qd8oLuXm8FZWVA4Q>
X-ME-Received: <xmr:kjQUagAkt6UG6Q5FW5PiLcELIagxTfPy3Udy5_VjGC7XdnHZBApwFmJ7X2iFiQ>
X-ME-Proxy-Cause: dmFkZTE8BdsnOcJoKEIc8nWENdzZ3IJcc78XaZb937JZptTbBfsj35uOLLco64YanRFUy/
    vxRRXxJncUkkFhQ6Fw9JoTXNpIBZaIk7PJKSogIAKlou1fnKpK60SVEE9wIdCSKeJSiEmd
    jMYcCTSecv2wdbvACcZ3jQHh2R35wiBKAXeBalxbQ8obtaPzZg26qqKn3eo1ycSESHvZEY
    8vksW44pxFuJVzxfC4xrmaM24Xz/fIt3AP98RkQGIoAMYfpB8FzSca86T9jBGlmKI9r1LK
    Ip3BvhMbIznxq4KZmZ20/tINtDmxtvyOkjCcERfRzx2DQnK/TIBWkODYKxc/0O8u9p7elF
    KcUTR86ZQJoGhU1HA6iy+dYermkezpR1lmYcDz9spmacRXxrsgjIPgXs/sK3nKIMn5rNYF
    n/CtnCYKc/DCRzoZfKC518fT2zreVavInyDtfzQWP2Vz+eRBVPhsE9ONRimPLH95Z1kJ2G
    bb+yMJUGA2dv/h469dGFzti/mCkBjvqPgWs/diwNGOt85XIr+UjaV3wvuMWePmYJD6P5A+
    GMRPzaMQ9geks/3O1RETYPcZV2FUgBOZ6XGAbWdEs3E/tlwC7Lu9N2iSle2Om5ITxH0I+U
    WAuc8Vr4zJIiKb9bDHgxuuBOC/WMy7fdN4SvazDwIL1wKgEGQ2NYGq86O8rA
X-ME-Proxy: <xmx:kjQUathkLrsdU0RHi0sKtFv4u1lpKNdr_y7Dkc_j5ZsSHX7Uk8umLg>
    <xmx:kjQUaqNSQ3ejshXPaUiz_HCE281AfRhTkLff9YXlQTzCJseTnefffg>
    <xmx:kjQUakazdcsOZYR0qkVelpT561UIU9rDQL_INL0PhOrqs8fBPy4ulw>
    <xmx:kjQUav9ep6h6cm11TyooDFqecE5CCpvK3vw93wVaLHOU2vZITxw2bg>
    <xmx:kjQUan27UjzR-lwDyhrGypWsWZWcNfE3rspNmqNoZoEmPlEVibDz6K-b>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:37:53 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
Subject: [PATCH v4 01/14] mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
Date: Mon, 25 May 2026 12:37:15 +0100
Message-ID: <20260525113737.1942478-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: wqr7jqyqxbyfuphrtg5poqwa6o3857p3
X-Rspamd-Queue-Id: 666FC4000A
X-Rspam-User: 
X-HE-Tag: 1779709077-243310
X-HE-Meta: U2FsdGVkX1/8QZzd3pZ1Jp3o5VSXuw5DKm5e0HMXt3Tydwr2BCCYFSAgFSWbqXTZHHnZllhBMQpxlGo+YDjOIOLBRs5xcoXfiL24fToRh76Lndom/BYMIL7so0H9pmhSVH7Nb37nFNqx/ERy6zeeIGZSniSKYK+9axZnC5scwaOKAWKp5/jI6Z0CAhwUXRaOkLjlXHpNQZm7incC1l4b9lWezYygqpkBFvkApCQIFnrt8jmYzpR37lqF0/dl7N/Qfj39km9DkvGyENVvIASK9qj5mr1uo03qeVVSXSUoLmAziTukiRtbN7S/UM24KslyUzMlN7cjNRRqpK06cVcwjap9lhg4QygWU/2N7o6qwkiXTbGX6a5PvNatiYAieXwedJsLkYTkiFitcSDFPEF8kRdgykHgWUGazWiRJ1wGFNMFUYnHFqwRhoK71P1UCt7CCSj3pi92qDVj/F5jbs21EmBFE5nQLkyPGT6OkRflFXI0p/Qv0s5IDbOqgMRW5ZYoq1Y8pKMaal9vIVvhiOXSmU3uk343Dfz4IjH56F1mGV4jSTgNiz0h0cRnRq50F1A6QSQpURF/JO/1o50pGhIljtQvlRW0Dhwae38apJ6SB1vYeTByWYAnkk7IquJVT/H7X54QdYvYW/PSdrylyO6NnkZ3izhIKD6KpMJjI0/Ni6xGwmWe5polomhJ3lNz7FyLqG0iK/peMtVZC0Y5Z+VzIS1cYE1xu0RQzX3ZAGyyR8fHiMXTJ4vsrm4Js7sFO3FZLiYxkZacMMfAq0wStEDWSnqtVqPIIprJQGCZtTUtK9zrGjLlH8ccLOp5QbQnJ5Gpm4hyTBbYo+DszpOTTE9BqqVj6U37AKM9SMnynK8oMc7Su7UyJfKnUAcIwTHqIKb9KVdaZx/97MWeccirXuHKsJxyp6Bw1znUGd2wn/4acdhfr7Fer6kAzRvBhvRbzRAcT/Zkcl+vBRokgySLPVj
 jXzdPtWt
 x/xvpM1urYAXn6gqxQWUdZoNqSkU4P5F1+HmIHv00GsOjZMKaVk2pygQnWVwFlni6mxX5irbS9ktN1rvq38kMQne7m63PtbgYx9ucDK/h93ZAmeUMScwMN1GSGkGALQ1h7KsQQ6xvqoWHsC9OKMcnNVlfLHLmeZ6AasnLe70zlcltKgTbm068aRRKJO31jo/sdRpSXjJUpNAa8pjm+iGMOFXgEihkormhJMEz4+84zdaVg46fPbQ6HVSUY+Keof4RzHnSf9Dmf/rwcLxhl0NQRWbuL5wXnHjzV6wTj2N0qjjZVnjuUaWleTeOHXtM7kQmwpbVa5PKZVJcA2c0cf3Qaraeqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_protnone() and pmd_protnone() detect present-but-inaccessible page
table entries. This capability is useful beyond NUMA balancing -- for
example, userfaultfd working set tracking uses protnone PTEs to track
page access without unmapping pages.

Introduce CONFIG_ARCH_HAS_PTE_PROTNONE to decouple the protnone PTE
infrastructure from CONFIG_NUMA_BALANCING. The six architectures that
support protnone PTEs (x86_64, arm64, powerpc, s390, riscv, loongarch)
now select this option, and CONFIG_NUMA_BALANCING depends on it.

No functional change -- the same set of architectures continues to have
working protnone support, but the infrastructure is now available
independently of NUMA balancing.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/Kconfig                           |  1 +
 arch/arm64/include/asm/pgtable.h             |  7 ++---
 arch/loongarch/Kconfig                       |  1 +
 arch/loongarch/include/asm/pgtable.h         |  4 +--
 arch/powerpc/include/asm/book3s/64/pgtable.h |  8 ++---
 arch/powerpc/platforms/Kconfig.cputype       |  1 +
 arch/riscv/Kconfig                           |  1 +
 arch/riscv/include/asm/pgtable.h             |  7 ++---
 arch/s390/Kconfig                            |  1 +
 arch/s390/include/asm/pgtable.h              |  4 +--
 arch/x86/Kconfig                             |  1 +
 arch/x86/include/asm/pgtable.h               |  8 ++---
 include/linux/pgtable.h                      | 32 ++++++++++++++------
 init/Kconfig                                 |  8 +++++
 mm/debug_vm_pgtable.c                        |  4 +--
 15 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..319470b3b1bb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -78,6 +78,7 @@ config ARM64
 	select ARCH_SUPPORTS_CFI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4dfa42b7d053..873f4ea2e288 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -553,10 +553,7 @@ static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	/*
@@ -575,7 +572,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 606597da46b8..77e9a9a30483 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -67,6 +67,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 2a0b63ae421f..d295447a2763 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -619,7 +619,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline long pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_PROTNONE);
@@ -629,7 +629,7 @@ static inline long pmd_protnone(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _PAGE_PROTNONE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index e67e64ac6e8c..53a0c5892548 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -490,13 +490,13 @@ static inline pte_t pte_clear_soft_dirty(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE | _PAGE_RWX)) ==
 		cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_hw_valid(pte_t pte)
 {
@@ -1067,12 +1067,12 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #endif
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..36b64a24cf30 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -87,6 +87,7 @@ config PPC_BOOK3S_64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_SUPPORTS_HUGETLBFS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select HAVE_MOVE_PMD
 	select HAVE_MOVE_PUD
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index c5754942cf85..e2c5776d18cf 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -71,6 +71,7 @@ config RISCV
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
+	select ARCH_HAS_PTE_PROTNONE if MMU
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_SCHED_MC if SMP
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index a1a7c6520a09..48a127323b21 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -524,10 +524,7 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 					PAGE_SIZE)
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/asm-generic/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) == _PAGE_PROT_NONE;
@@ -537,7 +534,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 /* Modify page protection bits */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ecbcbb781e40..bc5bef08454b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -151,6 +151,7 @@ config S390
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && CC_IS_CLANG
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2c6cee8241e0..97241dea5573 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -842,7 +842,7 @@ static inline int pte_same(pte_t a, pte_t b)
 	return pte_val(a) == pte_val(b);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return pte_present(pte) && !(pte_val(pte) & _PAGE_READ);
@@ -853,7 +853,7 @@ static inline int pmd_protnone(pmd_t pmd)
 	/* pmd_leaf(pmd) implies pmd_present(pmd) */
 	return pmd_leaf(pmd) && !(pmd_val(pmd) & _SEGMENT_ENTRY_READ);
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_swp_exclusive(pte_t pte)
 {
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..9da1119e8ff6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -123,6 +123,7 @@ config X86
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
+	select ARCH_HAS_PTE_PROTNONE		if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
 	select ARCH_SUPPORTS_CFI		if X86_64
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2187e9cfcefa..c7f014cbf0a9 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -985,11 +985,7 @@ static inline int pmd_present(pmd_t pmd)
 	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * These work without NUMA balancing but the kernel does not care. See the
- * comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
@@ -1001,7 +997,7 @@ static inline int pmd_protnone(pmd_t pmd)
 	return (pmd_flags(pmd) & (_PAGE_PROTNONE | _PAGE_PRESENT))
 		== _PAGE_PROTNONE;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline int pmd_none(pmd_t pmd)
 {
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..b6516a11adfa 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2052,18 +2052,26 @@ static inline int pud_trans_unstable(pud_t *pud)
 	return 0;
 }
 
-#ifndef CONFIG_NUMA_BALANCING
+#ifndef CONFIG_ARCH_HAS_PTE_PROTNONE
 /*
- * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It is
- * perfectly valid to indicate "no" in that case, which is why our default
- * implementation defaults to "always no".
+ * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It
+ * is perfectly valid to indicate "no" in that case, which is why our
+ * default implementation defaults to "always no".
  *
- * In an accessible VMA, however, pte_protnone() reliably indicates PROT_NONE
- * page protection due to NUMA hinting. NUMA hinting faults only apply in
- * accessible VMAs.
+ * In an accessible VMA, pte_protnone() reliably indicates a present
+ * PROT_NONE page protection. Today the kernel uses such PTEs for two
+ * purposes: NUMA hinting faults, and userfaultfd RWP tracking on
+ * VM_UFFD_RWP VMAs. The two are distinguished by the uffd PTE bit and
+ * the VMA flag; see include/linux/userfaultfd_k.h.
  *
- * So, to reliably identify PROT_NONE PTEs that require a NUMA hinting fault,
- * looking at the VMA accessibility is sufficient.
+ * So, to reliably identify PROT_NONE PTEs that require kernel handling,
+ * looking at the VMA accessibility (and the uffd bit on RWP VMAs) is
+ * sufficient.
+ *
+ * Architectures without CONFIG_ARCH_HAS_PTE_PROTNONE get the always-zero
+ * stubs below; PAGE_NONE references that survive to runtime fire the
+ * BUILD_BUG() fallback, since callers should have folded such paths to
+ * dead code via IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).
  */
 static inline int pte_protnone(pte_t pte)
 {
@@ -2074,7 +2082,11 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return 0;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+
+#ifndef PAGE_NONE
+#define PAGE_NONE ({ BUILD_BUG(); (pgprot_t){0}; })
+#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #endif /* CONFIG_MMU */
 
diff --git a/init/Kconfig b/init/Kconfig
index 2937c4d308ae..58abb7f19206 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -944,6 +944,13 @@ config SCHED_PROXY_EXEC
 
 endmenu
 
+#
+# For architectures that support present-but-inaccessible (PROT_NONE) page
+# table entries detectable via pte_protnone() / pmd_protnone():
+#
+config ARCH_HAS_PTE_PROTNONE
+	bool
+
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
@@ -1010,6 +1017,7 @@ config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
+	depends on ARCH_HAS_PTE_PROTNONE
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 23dc3ee09561..5e9f3a35f924 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -672,7 +672,7 @@ static void __init pte_protnone_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot_none);
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	pr_debug("Validating PTE protnone\n");
@@ -685,7 +685,7 @@ static void __init pmd_protnone_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	if (!has_transparent_hugepage())
-- 
2.54.0



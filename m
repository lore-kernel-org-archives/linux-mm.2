Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1CF9CEACD6
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 21:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391CD8E0020; Fri, 14 Nov 2025 16:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342A78E0005; Fri, 14 Nov 2025 16:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2318B8E0020; Fri, 14 Nov 2025 16:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D57A8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:49:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5F698937C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:49:29 +0000 (UTC)
X-FDA: 84110554458.21.18EEF53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4817E40002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:49:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q2o6DD7H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763156968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5BkAeGjFAR37zBADHAlvlRHppK4yl8/KxkL2I6oi6/k=;
	b=zH+3PQVLRU67EL2iSz6boofoTBtqJYrN6kSutGh6Wh9b/Hzw8iZCHBhYXRLW/eEPSfj9Vf
	nlRf+MCm6gZ3MM4kHXCeVIg3IcAxKZmLfrAmRGCGGBtsL8I0+V6eX1M3PuD9iGjixKkkUA
	Zs9HAh7RsSvZATO94NuXCecjsFk4PHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763156968; a=rsa-sha256;
	cv=none;
	b=W91kLiov5RTwHagBB8+Az3pu/ZgX9Be/SaV8Nsw8rU3VaDOlFMv3qPrXPHs1vnsQ/+g5ZO
	xfBbgVsZwA/qegMfXBUDkfAers+4baVlOZzcneTMocgQ/b6AKxbnhdkMiPN83KKqI5uyFD
	2DtehMf3xc7BQmhE8xCGisub1ub4A50=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q2o6DD7H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADBEA6018A;
	Fri, 14 Nov 2025 21:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102D9C4CEF5;
	Fri, 14 Nov 2025 21:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763156967;
	bh=ySvSzShrg1v70DOhLwUfjU/Do8dZ0r5nlYPKicAzxRc=;
	h=From:To:Cc:Subject:Date:From;
	b=q2o6DD7HnK+jCwD2HWc9iJCezb5y4hbOkGor8kefy1DNjvE6Py/4DkEgl+hTrpcuh
	 DWyvUbH3iGSe7RA879sOTFAyyK9q8qsLhPaAhpTnLxmUthlwEfXItYxYkasuMRpuzb
	 /6rBf+BtkIcAKnJ2KJYJjkjI8fM2AUw5q+4FzNP+mdMiAjH325qlVL1kl1PJ9ixOaQ
	 kozEZ2hcq1T+GjWbTF/wHT+jUmg3nhLOn0wIvpRViFwGPyqTjP3di8ZtFymIlU5B3Q
	 bLxKh9VpAor6zH8i8aMpSBVT5R69Pcnf9fBDNhxZX/M5vTb7Tr7iI9lEbNCaZEwA7u
	 UO7rfB9yfE6pA==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
Date: Fri, 14 Nov 2025 22:49:20 +0100
Message-ID: <20251114214920.2550676-1-david@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 937bdnhzchyoia8xe9kmijm6ifw4g5wd
X-Rspam-User: 
X-Rspamd-Queue-Id: 4817E40002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763156968-885982
X-HE-Meta: U2FsdGVkX1+LkszfGCBwPo1qL6oQ9ceRnro6TMWPP+0kvXdWjQGGPXzuZle2E3yalUWtnLmblrC8XXPb3orqSMOgPjHPoROb4DEeN5SGUL5sW/2P54Wb1jC7RbDHhXR6+XEiqNItb+j9Skc5FB+Gm29fHRLv5noRY/lkRAgkjSneBAdvzXFKCgG1UG6b43v43c613fm8NvGTrTmhrHox5QZrIQIxAJ858RFnGCBAEEPX0i+sds4Wkuu8Mq8i21+PchkIyPH7Ja6WbrZDamzpRrhw0G7ZPvylnImeIaRiWnCpKyO+czbuvTgF4dJbJ4ocHJevOWaVvS0Rs59k2O5GFrFSaoeiJUyuReTWSX1vwYlXzBfLwIzLgrPn3yBhsiSTOiBbeKeo4aR0KPlfUJuMDvnKJr+lZkDgWZcfkHduFhSffo7Ssp+t9fPPVvNNBExFXBUcJCVWdhIu2tlV2aeM4Vi7NUn5t/WJ9spzJfn+UNoFNSnOpP7pFApipRQCpb8vPHDo4evocqgfcuO50cSDCfG8mZ2hL/db5JU+uThZdwLt63moXu/6y4dAJ/jHEeltvG8xXFuLLfNpj+xySeuWbe4yhRsVcEsB+lJ9CeQwj2ySaCK7YUBsC1yNTyo43jM8wPsN6jrcliuXYYj6ffCMvwPmLIhOkzdfmexxku/ybul72TcqNMvhUknNyBoy5h88roG8WVR2ZWJBTnxn8d2oR6QJDT+E/tS0Vt2a6fo41ruYevMJYz6UyX1sIxIhwUgIYniaS82YParZpy9+bHjsjpTTzk/gaPevQDRXyQFQP9ZX0GZkxzj0tvO+bJnO+YqTHvyo4MLazVkyVNGppsdYgAc3V5MhGXdDtI5XoTr+ACaCnU95+UYzy/36L5W/BrI4pGqGie5m2JbaWPZ1ATaSOtxC7knY0rxFEaa5/0qkdADZkpx6xxkoeeVFHn9fqqqVmRWdcBVq0pTByJifVTb
 jnH10ZU6
 w7IOcDyvT+9WSlXqoJ+EXW0t55k21P+Ejy8diZh4Odj6KJ48QbPGNWNiKVCmR9ijcTInahigBVkQjc1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
runtime allocation of gigantic hugetlb folios. In the meantime it evolved
into a generic way for the architecture to state that it supports
gigantic hugetlb folios.

In commit fae7d834c43c ("mm: add __dump_folio()") we started using
CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
have folios larger than what the buddy can handle. In the context of
that commit, we started using MAX_FOLIO_ORDER to detect page corruptions
when dumping tail pages of folios. Before that commit, we assumed that
we cannot have folios larger than the highest buddy order, which was
obviously wrong.

In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
when registering hstate"), we used MAX_FOLIO_ORDER to detect
inconsistencies, and in fact, we found some now.

Powerpc allows for configs that can allocate gigantic folio during boot
(not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
exceed PUD_ORDER.

To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
GiB on 64bit (possible on arm64 and powerpc) and 1 GiB on 32 bit (powerpc).
Note that on some powerpc configurations, whether we actually have gigantic
pages depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
nothing really problematic about setting it unconditionally: we just try to
keep the value small so we can better detect problems in __dump_folio()
and inconsistencies around the expected largest folio in the system.

Ideally, we'd have a better way to obtain the maximum hugetlb folio size
and detect ourselves whether we really end up with gigantic folios. Let's
defer bigger changes and fix the warnings first.

While at it, handle gigantic DAX folios more clearly: DAX can only
end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
HUGETLB_PAGE.

Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
also allow for runtime allocations of folios in some more powerpc configs.
I don't think this is a problem, but if it is we could handle it through
__HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.

While __dump_page()/__dump_folio was also problematic (not handling dumping
of tail pages of such gigantic folios correctly), it doesn't seem
critical enough to mark it as a fix.

Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---

v1 -> v2:
* Adjust patch description (typo, 16G vs 1G)
* Remove ARCH_HAS_GIGANTIC_PAGE from arch/powerpc/platforms/Kconfig.cputype
* Mention CONFIG_HAVE_GIGANTIC_FOLIOS in comment
* Use 1 GiB on 32bit to avoid unsigned-long capacity issues

I yet have to boot-test this on 32bit powerpc. Something for Monday.

---
 arch/powerpc/Kconfig                   |  1 +
 arch/powerpc/platforms/Kconfig.cputype |  1 -
 include/linux/mm.h                     | 13 ++++++++++---
 mm/Kconfig                             |  7 +++++++
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e24f4d88885ae..9537a61ebae02 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -137,6 +137,7 @@ config PPC
 	select ARCH_HAS_DMA_OPS			if PPC64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 7b527d18aa5ee..4c321a8ea8965 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -423,7 +423,6 @@ config PPC_64S_HASH_MMU
 config PPC_RADIX_MMU
 	bool "Radix MMU Support"
 	depends on PPC_BOOK3S_64
-	select ARCH_HAS_GIGANTIC_PAGE
 	default y
 	help
 	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32b..7c79b3369b82c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
+#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
 /*
  * We don't expect any folios that exceed buddy sizes (and consequently
  * memory sections).
@@ -2087,10 +2087,17 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
  * pages are guaranteed to be contiguous.
  */
 #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#else
+#elif defined(CONFIG_HUGETLB_PAGE)
 /*
  * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (e.g., hugetlb, dax).
+ * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
+ * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
+ */
+#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
+#else
+/*
+ * Without hugetlb, gigantic folios that are bigger than a single PUD are
+ * currently impossible.
  */
 #define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
diff --git a/mm/Kconfig b/mm/Kconfig
index 0e26f4fc8717b..ca3f146bc7053 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -908,6 +908,13 @@ config PAGE_MAPCOUNT
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
+#
+# We can end up creating gigantic folio.
+#
+config HAVE_GIGANTIC_FOLIOS
+	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
+		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n

base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.51.0



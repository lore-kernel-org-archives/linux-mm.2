Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9672BCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E510F8E0019; Wed, 12 Nov 2025 09:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E011E8E0011; Wed, 12 Nov 2025 09:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF03D8E0019; Wed, 12 Nov 2025 09:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B8D4C8E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:56:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 415E7894A7
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:56:40 +0000 (UTC)
X-FDA: 84102256560.12.7386383
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C33C240003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:56:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D79khSQs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762959398; a=rsa-sha256;
	cv=none;
	b=IO4kVQUTK1Yy0oNq0UJnn+L8UJnmSBMSZYFIv4N/6Djj5edNePT5DkyJ9O7fEZJIvJgqAJ
	m6Viw8xWYQVlGniqdXuoWdZHCeKWa0LJSzRPAswgb8iQ5dnYz86A+MV+6leGK8gQ4Eka1S
	8kv83UDf9NO4Eg0Qqs+PkqUObXqzoPo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D79khSQs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762959398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ryP1wiJVw9aw+DpTbMpV/h0UEZ8NMcdOc+GlItX0uJI=;
	b=QQJUL6PKEHdscfxj0wpKeGQlcTkArPk6wB50WaZQZnFPRts2mjjCplbnHX6GN3lqvwaNxp
	78SnKd3YzxNueIJflOGjhn9906Ej3KcMxd6/u6gi2cqr/9VBaeHLgZ3iC2IDKOwRHaktK3
	6oHT/Nr4oROUM40QwHQDtbNacfRwgHI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37CDE60219;
	Wed, 12 Nov 2025 14:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BD2C113D0;
	Wed, 12 Nov 2025 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762959397;
	bh=/i5+uzL0Oqs6gEV3AXY8bbYwafp63UToQF5glVJFuPc=;
	h=From:To:Cc:Subject:Date:From;
	b=D79khSQsyM2jtSumiC6G+0g59BNd6JFWbzNVlgUIR79tiGlaliyAjTfh8cVo+sovs
	 Zf0qtjUtxNdE+enBHdx/SoUjg4XTdWhKo1E9Cw3JDQqa2QNqbP6roWSveZcgbKByYY
	 u1kGW4HkXHsIbz364QHPma0yJrxgNJqgw8txrHtMUGMzq8CzEpmTvJIcUflZesjOQO
	 hMjrnKaZxEfOSo72qJpGUddcPsp6Rag5IxCIIyWNvAORAhmC8jp0NveqasSz6ceZti
	 cKLJCFHmP8tgM/qYXGge3d1hQBnhVyLPZ/IqOkQKjj41GF0X1ZkvlsbfDMYi42+4mk
	 Ygc6eYKKTpabw==
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
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v1] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
Date: Wed, 12 Nov 2025 15:56:32 +0100
Message-ID: <20251112145632.508687-1-david@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C33C240003
X-Rspamd-Server: rspam07
X-Stat-Signature: eunmn66rrr5m189xcbuiasup6otqh5hz
X-Rspam-User: 
X-HE-Tag: 1762959398-756687
X-HE-Meta: U2FsdGVkX189iqNDe7nsBdaydaIvVfPDIAXoCtBymcD27UR3JeytBwIiNCX2Jlftw8I9G2gBCAcvl4pwsCG+xsJQAFeE9m5qfw3eHI8oP7hpOFF4wTVstbnON4F4XjzA1610azbXBiwqJtmXybsIOrBFGIUGLK2JvKvrv+m/ARAsAncSeEF3Sk3wwBEtfU7GziN2P2aNv9fAUlQHyYecjtlbvo2DUtCZfA4Uiv+/w4bUr918Q4JXI6PiEFiyvDe6PqhjZNjNKmjN27FYmr3HFJZCO2qiBETvUtLjuvam7VW8rgpQ5+4UEimWVmrLsra9ymN8KmrDJI49+cG6oXCbf14SBchfPYQwzEelOSGiZ7z8PfpV/qc1eK/VDVztvILrQsP+TfApCyvG9ORS0nFA2UqU1/PRkm0DzN1pIM/UhkXu41n9j9bQ2+5DGQ9HdHW+NTcxoQ5gD4+Iwol/Urz3JtFMgkbAu6VIOa2Bz8CAIfJM9/+BUD06WDHGODv/Nwwj/eVazPdOq51kXDxKFp6I3TwCtAPxPfwrEJKqpcJbTrSMX1+DY4tzh0WTTvTNsX90wr5GYrrwlrDTkqez+Id8KzjpL7Lmhgm0b23cJxZebnPSIoPRbxqq7gx6bGNqgmuA9visAQ50MHJw62qAVptALMqFM5Gc29D08rMgpGilYZyYVnul7T+sh54nRz5Ifgquz2MS5Nlpq2x9QSF9ej+uEEvZFGvqYkNfUweZ00OcAYUrTlyMwH/V4H4vGDGLx9v6XwSyTaJClBaopacFniK27XzLs79evHNanmasOhPJtGApAGzneMh9VgoM3RvTA2xgdip4iIRJY8yVAKdmchxDbs+tqAFZG0sp8iGHWBOclp0AUZJB/aBLECuF0MUJvLMqx2nthdgG9T73jbiYzWh0+Gvh3y02/8f9JiTI7n8v9YAZmj2YcxPHbIZwe0tJ/RkoFr6V7fiXSBKJxHDtRTA
 4ogfzfjF
 2DkzSJnRfXYiR5VfKeYiiF1pZo/R3epb3x9V4n7kYnSrNm/WAFIcTU49zEWywmRcovDF1c3zZ2mAYtVx6UJfArIg5JTlcIRj7CXJdkvWi0L5dRTQWKUTgq94NrCi22H0MBfG3EEop4Qr+e2bpPfIYm9Sl5taTv0g5/TvYM9R8gF8H+v4c4gJ+9qgI0Z/rwNN6Ol0wBsKgusT6mtQ6PvjNuUijaS8P3eRY8gLyMVyv6CmDovQoPL5jKyaQXSIkD0c7m/aY2xRGpWvtVF9HUg3grdWguh6hErrYELY3vQH9iAP7jzcX3IuSrEvpztfbrLJVMNcqjGHYBwrV0s3JZEK+jVaWCWXe5RR2dQbhMXF30UEwZhJTGRvAX1J7/buKWHGuwqrSi15HazJxNjy5b4K+pWCj9kYrKQFLNHEikCsDnVPVTp8DYG/btADVRcQxwKsKoJ69cjbYpxGsowP4glAAETTfXJzkp2ZNwr2aa+SvvD6I5rGH9G5pNHP1G+k5BTu3wblYRsqOvAo7DV5zb1FdGOKCkyEviwYVk3AD92Y6QuCrbSu+ksu6hUzS02DLx6NHoojhKvHvWK5csvkF2EMSj2p7kHvH/EF8qgkRkrbx+j3FGVU5+IshrJTbiw==
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
GiB (possible on arm64 and powerpc). Note that on some powerpc
configurations, whether we actually have gigantic pages
depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
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
of tail pages of such gigantic folios correctly), it doesn't relevant
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
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/powerpc/Kconfig |  1 +
 include/linux/mm.h   | 12 +++++++++---
 mm/Kconfig           |  7 +++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

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
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32b..63aea4b3fb5d9 100644
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
@@ -2087,10 +2087,16 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
  * pages are guaranteed to be contiguous.
  */
 #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#else
+#elif defined(CONFIG_HUGETLB_PAGE)
 /*
  * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (e.g., hugetlb, dax).
+ * currently expect: with hugetlb, we expect no folios larger than 16 GiB.
+ */
+#define MAX_FOLIO_ORDER		get_order(SZ_16G)
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
-- 
2.51.0



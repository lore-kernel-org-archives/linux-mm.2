Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D87D44C5A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0C6D6B008A; Thu, 15 Jan 2026 09:46:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4036B008C; Thu, 15 Jan 2026 09:46:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5086B0092; Thu, 15 Jan 2026 09:46:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B801C6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BF8BB8BAF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:16 +0000 (UTC)
X-FDA: 84334473552.06.5DFE0DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9ED011C0012
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZzRTJffe;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488374; a=rsa-sha256;
	cv=none;
	b=WA+SGKmPbH3kF+Y5N7/bYeykIvnOK7hV2tZspH8lhS8xKKt2OOgviNqKjAtc91S6JKBbHt
	gSDW6HpnC74O5qiv1gQwd/Wgum72s3rjrwqpeV3eHT3bpcYIKXIDvlLxgu5B7im/hRTA2+
	TJNMMqCCDzRC2Qe3Qhy5qAqex5Myf7M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZzRTJffe;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yInNh073jOJnQPtBnu/Jk5d0nuPUjHswnjFWpzA6BbI=;
	b=uRBBJCRAGqIsO2RP+PTPQ95BYdazsD/YeqNipTaEqKLcAkLA3q8+1QvTOKgKb+VgkW6g/y
	iN1cPJa6XV2hp4CpZIqzx1v+5s5ZYzRP42w5+/eo5eKxBfbQGeCxD9s8tx4p5Q87Zlw7cc
	vLAMn3z+1MR2JWHN29384TQmf1Fg2GE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D6C8601B9;
	Thu, 15 Jan 2026 14:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B06FC19422;
	Thu, 15 Jan 2026 14:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488373;
	bh=USgADkH2vXFF+KeppM0w/kcZpZeTOtI5OuFJPC+VuNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzRTJffeEY6NoaRswZLi9FLo+IFQVPXC4iqomj0rHMfDMYo89JhiPvUSa9hixuj1C
	 XWJHQ/iGkrHwgH6izQx7BMXzks/JOxvVVzic2y70rx/CV75lMycqcMwUjDwM8d6kl4
	 8dfB632BrNRljOW+Bix0v85Q2haeZx5sZjPYD3wNcgs6LOzzYAxfaaO0ncxh73oQtz
	 YkRKUCg+sEY5tXKz8oFyULhxFEKCeLhqnh3XnH1NBADyapLfYCXzerJkm2X2MimDvI
	 LwJkbvcjDqhF/EFaRFkNsAY3e8+fqLZkWH48WPl/73AOXz5y2oJZCHBdgd42HoTwN/
	 /Rcp69JBKwZYQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id A959BF40068;
	Thu, 15 Jan 2026 09:46:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 15 Jan 2026 09:46:12 -0500
X-ME-Sender: <xms:tP1oaTY5klSGv1-91UejVGUPsbuMmlt6AYetHd1EHaNcNjf72AYcLw>
    <xme:tP1oaRoYJxjkyYjOUF4iOVq8cN2dq4KR0UvSz-vGaAdceWEGi7T6rIriOehF1RNvI
    ssNlA5gQCIztAZUCbhj2zjPBpDf_TAIH78xU929iDm1_Jyn4KhOAJw>
X-ME-Received: <xmr:tP1oaYyTo0bhkFe3YCDgGgQtNmJ_bmZ7IB7ORyAlJYKTRVFwEDp-iDmUSLUTvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:tP1oaRJyF_RWzK6sYzgnN30z2SiS68QHb6_i6bws2z4hIoLDoMnLeA>
    <xmx:tP1oaS4GXPYT3zRWd6AslaWjoqZWmPGVXMhBMYSCGemQorIFVmlXYg>
    <xmx:tP1oaXxEJwXWWcFVS7cgt85H7GKTCQnz4x9nPKKnpI-ILUJ0kDlQqQ>
    <xmx:tP1oac93oyxgFlrmypkaQ_lPhsx2mnlUNdx9uGpKW90XWHzp9prH-A>
    <xmx:tP1oaTHnhCehTBjgF2wvEerzyqwPOUYudc59YC8SK_IfopJi8n6NfC2j>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:12 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 02/15] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Date: Thu, 15 Jan 2026 14:45:48 +0000
Message-ID: <20260115144604.822702-3-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9ED011C0012
X-Stat-Signature: qrhc5dremht3rrgwxj67scx7o6jfpaao
X-Rspam-User: 
X-HE-Tag: 1768488374-370155
X-HE-Meta: U2FsdGVkX19Zx5lnItZ8ZPhI+Ry1pRiDnabMTfk2sc/YuadzKLjvMw0zD9rEzHTDj2D2s1CGmUgUdl4FfR+NddKhvG7vF/FmS3RsrGLuqa1L6GtNgbisBWjOABmIIjAtpiYIFqPNLhWgZEE8RbN+U9lixmJyNk/Gtm8GanU42IU2n1sZEo1xwjtVfPVmuDagHGG20vRQ4Bb0j4bXofY3c+n3DFjVoHCW1w2dRK0dzLQb4tmpYw9KdeH9WLuuMMPnsXned2QG8VuO/qHhvD4ypuR0KmFNG0qrUAFNUAHTmRVYA5CWhJjyAU+02359Rz1vliyI6JSv/oh01SF6O2MlfUjFw6HOjC01vRM0X/2sSXyu8EkmxdtCwKO3aFmMy6ziVdRKn3TqodX0GaXYcqbKHsh63mGTrVOQ7Du45r1jvWrjuy6WfQGae4TsgIYLIULCUwKvpbGkEmUzRXPKMHqYbS8omotlra/CySEajvVTDbIoUOhJVOM4viYqdKxNbNROYz/pU0A5410GGoqzkkdH1nAjeFic5AcheORTny6Wt+xRxYmPhLAlpfX2Xh5pGn1hBq7iMGPUsOa5g6f57zg5NIbiyiQgPV2Jf3FtQPupOsqdEu10UAq0ghufNC1fe0h7rGDmmakyamLFLqqp34UjlAJ3NLHpQYf9Q7pWEu6aZRoXjwyf+0wwgSIQrWl+jL1gXkeFw7fF0y2Hz1J7o/U/APm5kwoJ7heFatJqB49npTcJ/9eDNZbLLhyopApogrODLF14NZNcZ76LpGDZoh1tJJ4j4GK468dIucVXTT0y2wUCgsgwqiOdzVdnMG+eU3qd+OjXblEl9ZntOvVBCelAKwtDZBsiSQarDftdwsfWTU19F1pHR/rfpgUBBZ/4CDG1ZYeyOQBa1Y9PCGCxjSqsTkhGMxak5UgNopvXcN00bhbShkuOHxM6Vqu35At7SE/45Ueipwmdm+4jgAWSDNy
 1zooRaBS
 1eph4e6zmDvz0QDcfFBSGDBKNIF3CI5fap7k+WIjqvOxcBCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.

This is preparation for adding the vmemmap_tails array to struct
pglist_data, which requires MAX_FOLIO_ORDER to be available in mmzone.h.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mm.h     | 31 -------------------------------
 include/linux/mmzone.h | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..2c409f583569 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -26,7 +26,6 @@
 #include <linux/page-flags.h>
 #include <linux/page_ref.h>
 #include <linux/overflow.h>
-#include <linux/sizes.h>
 #include <linux/sched.h>
 #include <linux/pgtable.h>
 #include <linux/kasan.h>
@@ -2074,36 +2073,6 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
-/*
- * We don't expect any folios that exceed buddy sizes (and consequently
- * memory sections).
- */
-#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
-#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-/*
- * Only pages within a single memory section are guaranteed to be
- * contiguous. By limiting folios to a single memory section, all folio
- * pages are guaranteed to be contiguous.
- */
-#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#elif defined(CONFIG_HUGETLB_PAGE)
-/*
- * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
- * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
- */
-#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
-#else
-/*
- * Without hugetlb, gigantic folios that are bigger than a single PUD are
- * currently impossible.
- */
-#define MAX_FOLIO_ORDER		PUD_ORDER
-#endif
-
-#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
-
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..6a2f3696068e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -21,8 +21,10 @@
 #include <linux/atomic.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
+#include <linux/pgtable.h>
 #include <linux/local_lock.h>
 #include <linux/zswap.h>
+#include <linux/sizes.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -61,6 +63,36 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
+#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
+/*
+ * We don't expect any folios that exceed buddy sizes (and consequently
+ * memory sections).
+ */
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
+#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Only pages within a single memory section are guaranteed to be
+ * contiguous. By limiting folios to a single memory section, all folio
+ * pages are guaranteed to be contiguous.
+ */
+#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
+#elif defined(CONFIG_HUGETLB_PAGE)
+/*
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
+ * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
+ */
+#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
+#else
+/*
+ * Without hugetlb, gigantic folios that are bigger than a single PUD are
+ * currently impossible.
+ */
+#define MAX_FOLIO_ORDER		PUD_ORDER
+#endif
+
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
-- 
2.51.2



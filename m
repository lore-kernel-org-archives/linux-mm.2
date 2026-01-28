Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8D0D25B7E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6996B008A; Wed, 28 Jan 2026 08:55:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176666B008C; Wed, 28 Jan 2026 08:55:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E8A6B0092; Wed, 28 Jan 2026 08:55:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7CA46B008A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:55:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66B571A064B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:14 +0000 (UTC)
X-FDA: 84381519348.24.48A0366
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 639FC40009
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GSKal1md;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7vzDxChpsKg03+NYp1xjpS8xJER5E5J5vzhRbxMT7k=;
	b=n6brSU1OMVedfmvPu8z0l0rfbGXlYLAoydFXce9qbXlFo4pzR8EnzYTiID859rxoLE7FhR
	emgpLujSAJ6ZyNfEUqanVrFVWo1aPtmIo2xF4Slzzt17O6slejheicA2nLGPqr54J7gTN8
	rgNo6Cb1h3T6dL3UoSojhpBeNAaEmnQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GSKal1md;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608512; a=rsa-sha256;
	cv=none;
	b=Tr1HbxBFaACGoicdsP1TsDB414n5ucBcYpqWaZNqFdNV+WHJzTQJe66bDd4YX3rTsKMvbw
	qdLRGFDcnls1B0mDa36IOzLgOnJZ0gRBc6Znvap/GxqY7mq1pmuBgAjVckoTx/eDI12LCl
	l+TG1btLtMhof8ny8muBiloDDCnn38w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CA4A76011F;
	Wed, 28 Jan 2026 13:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7802AC116C6;
	Wed, 28 Jan 2026 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608511;
	bh=AAnIadXhZxE/xw6Xd6felYchHz0PQHYO69+c3YSZCe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSKal1mdGyYmQdTcYaYWCrpQxqhSa0abl4M88scQ0oD0CPPMAn/W/ziTb5o6fOIqc
	 4GviC1yzRokvwgBPo4Mn5i1z42TFw9Hv68PgJkXY/+KkOZpWAwQaIU12j6Uf7dKtFz
	 sHAzx+zvICzU/5o5F6m8Ryb4pX9Hbm/GdWN6XQG/34VCS/0U7VkyhuCgEHbfl/Uzko
	 /NYsD50WtFXcMPBlu1X9gfC7Tclo9vEz1mttJ/MAqP32i3lGlfcKDRiiHIw3kPj3ng
	 bZ9wOztB2fskRP8QTnEYtDbUiYRl4+quj2VGGyJodJ/hEy9+8gwkIrtokcI8mBw0nu
	 PcDvqL6OGjZoA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9C036F4006A;
	Wed, 28 Jan 2026 08:55:09 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 28 Jan 2026 08:55:09 -0500
X-ME-Sender: <xms:PRV6aXctoo9CvAcsI446BvMWXAjccvR2nSboGgyGbdhtTMUvA4Vb3A>
    <xme:PRV6adUlombAl4wSx96uHdftCOkeDK6SC_bmPGpqN_kEHTckWMCqGpQxzrf2FvInZ
    8mdZth2kFyYXxeRpZbfvz8-8dQls-c1TiwooI8aOyQ_R3NSg3ZUt-8>
X-ME-Received: <xmr:PRV6aeXXOfJhXd26JAR1fWCiG3wHqvMDjS3O2y2aQ12Nw4_7Hj9vou1sBmpYZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdelpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:PRV6adPpqUuA53jX-Gx5rGE3Y2LI7uv89Odvj7UIdDFmCOMzVBKSQA>
    <xmx:PRV6aR7PCcJrhG-wm3HqCMnc35XfrvBoeRE_2IXOauSejyCeMoMTNA>
    <xmx:PRV6aWoXcBHQ_v2j3ZcrDozr4huvlUdeHhlsZZGpoOxjreE6hDqF3w>
    <xmx:PRV6aXBa7YZQ0lcR5V9u9YptXp9OdeoQDS02F41otLs02d1-x5Rz5Q>
    <xmx:PRV6aUcjIyt9oZyw7hFCtgE-pDDbiRss8bEHzKmAGSOvysTO_bD_PYD2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:55:07 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
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
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCHv5 01/17] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Date: Wed, 28 Jan 2026 13:54:42 +0000
Message-ID: <20260128135500.22121-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 639FC40009
X-Stat-Signature: wb5zaoza6qwhm3ghi6rgxz3u7itd4fzf
X-Rspam-User: 
X-HE-Tag: 1769608512-645210
X-HE-Meta: U2FsdGVkX1/cAFp+LlXifnKDNa/fKGSPp8wpQBZ3nZj+pnrTmabyH5o0t33LzmOnPzuAc7QSRgqeaOZNJqfHo2Ssj+mPLpwig/pPfWc7VgLXPjjE2fp0fC2N9JZTkhqus81YjQRh5OruEK6jr07iHUtzdnFu8Q9IHIaRqCakHR0ukLO1OGlT/g1Msmn6xmVpVJoUO19Njp/9ERsWdKEL9p8lYVGgAvEOT9Sa3PDvtKJY00/E+FCFX9xV3LtyWjmdqOdAcTbTPq9XAlxr+JKGPlbKfd2FSXBnpgOTMx1OGornq2jkNSmLIZo22nbUfHdhbAI29ZFXOWowTUyKeuqqoOC/GYsXPxHozZAwbMKtdbtAo8LvOptGo+IQIfjMZbRZWp1QplD3sn2vqjmO+CmmcHbE59PrQestgAjT1qnL9z/SBIMHR2+c/35f75Ie9sDZfX7IlpJv8Zb/xezE9nqmWFQVTf9jcVFoZfAe9N+AV9oF5sGOqhPrf/UkaQs8QscdBTRQcsdmY4hMiAX5OtbPHEA08kRO8oR8bE/Lmog/4ylPS1gd2nz2lWerY0M9wBN7WgLSUPgoPe0an18LiTJfUsjNfdX59fK9+aiwqxPz2khtf8Be7L0P5+zEIxCgEqvXJES7lUJXhf2ud6lzd4zIqAG/3sl/aTYZG9IEByh0Nnk0pLjHKy7TCjcFc+t8+94X8gxAY9nLq4mKNso2d2rY/ewJDNs+AbcLcd1MSI7rDEHkQXCEHem+1biHqWIpvaq+nmmKt5KPz0NTEO5t7Hdb4BdFOraUmVXkiVcc6jVL/kFMr+ArrkkTWrRzbO1G3VrTKZOpBN+dm3K2B6BVcJ0YklCMWe0ByQWbYAdaZGGSgx4O05px8HDBqKQLjKOIPmSycSdZVjmSJtgZXp1FP7TiHxYK3j/A4IHJgPC8BeraOwS0LORFjtVOoCKJqdAo3WTOx4Gt9UFcLiPbnWBdvMc
 yOu/9IWh
 BlPxp7YwU9JL4fzxk+GpWQx/bkF7KdTpVXqulI9ROpa/k+bv2buD7a7GzA0TlX2Ph8bOu+ZsLRGY2aGOsA5u5mUQPQatlsmm4JrN4tE8fYrxyAMudaDaXwNwu53kfY+R2aEUVr1Kz5jyq5Cj62knHX4WcQrIlF5HvnZCovAHVLH9DdQU1e20PUNPTCqqJO5Qtp3Dv5201JH0j9kt1aqH5r2g1PHmuo65fxb+UfoLjsZt2pCAKqDUMYByhg3tyos94jiizLOHJG1WXSZXnVaI3526gD0W8C8PlLJHauYbWTjEBEhqwQCmJSsJbrE9Rhppy7MW1GnguD9uUToSwdBnpjsLWmHHZ+kop9OijuX4To+rIuNs=
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
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/mm.h     | 31 -------------------------------
 include/linux/mmzone.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f8a8fd47399c..8d5fa655fea4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -27,7 +27,6 @@
 #include <linux/page-flags.h>
 #include <linux/page_ref.h>
 #include <linux/overflow.h>
-#include <linux/sizes.h>
 #include <linux/sched.h>
 #include <linux/pgtable.h>
 #include <linux/kasan.h>
@@ -2477,36 +2476,6 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
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
index 3e51190a55e4..be8ce40b5638 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -23,6 +23,7 @@
 #include <linux/page-flags.h>
 #include <linux/local_lock.h>
 #include <linux/zswap.h>
+#include <linux/sizes.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -61,6 +62,36 @@
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



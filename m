Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9A9FD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D50C6B00BC; Fri, 27 Feb 2026 14:43:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FD46B00C0; Fri, 27 Feb 2026 14:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418826B00C1; Fri, 27 Feb 2026 14:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 269636B00BC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E07F6160908
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:15 +0000 (UTC)
X-FDA: 84491260350.14.8D0F3BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0C0DC0010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QMo2DoZe;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRHweEHITMhDIEDYfG2/SbUENH4WCd6wB2uHJabN3/o=;
	b=ksQBPJlesRSG01Tzirn+xDu/1sHBDGUcIHhjUdom0t72SXJlgbguY9144kmHi3SrrhQ6uT
	5nmR+sO/8uzRReXM2ZWtA0ZI5jVFIhxjjjGovC7HKXiJZoj3iq+BKvoVSOowezu5OC8iJO
	s50Qdue3PfBMJPmP/mWwr4dZyhp/Dds=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QMo2DoZe;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221394; a=rsa-sha256;
	cv=none;
	b=o8HYELMR+oqdSF9HmcalyR4FaJaI4MweP4rcYSOtR02+91caAnBksO47oFul3TzyMpTYK7
	Dro3pGBBa+dpEiy7EkVFosCaRCufwsF//qi9UXYnseD1cULEeK5FHJNo9DuPt/Q2f1V7dm
	hLM3O/rhoqWrcTJy6GQqoHymxdj3s0I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A0FA442EA;
	Fri, 27 Feb 2026 19:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2639AC4AF0B;
	Fri, 27 Feb 2026 19:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221392;
	bh=Y1gOIVTqDUoFIuPraJvRHSm3XRXvUUXuo2VeFUmVaTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMo2DoZe08ra8mhDTzS68Eub5Lx8Pk9kXcpTM7mqHM3rznFOBu269Zw+mVMQJZbnL
	 YBkXUJaArTX3bnVUF4LIY+rptlEunmryD8R3aQjd0HVhZ/C8BWg7Ldirjz01X8P2VY
	 JoLag6nA1odOA0BDTlTqtdHkzOtOX8ZYuA58tSGsVIp1KuM+7RfWj6WncAimdRBqjq
	 RkNTHM7laU4dLs5xDx8EHmARJPtKKQ2Pr5E3ldTff6dT1JoiFnqNUvaJ69NInxdrbU
	 NbukgcG3XVKgUG5gAAbHbOBQtUzPZ5omicQx+1PL8nFUhPNe+fEmUC8FH5j1dCvF/E
	 Gh61u4/v3zslg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 50448F40069;
	Fri, 27 Feb 2026 14:43:11 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 14:43:11 -0500
X-ME-Sender: <xms:z_OhaVGTLEtv06XPoC9DBkEMFGKDhUEYe1KtkbrgF2xjAgqLHW0a1w>
    <xme:z_OhaTiJsmpT_iTVomgknjEADj61moMD4ReqDndqLDLDrmztEQoWLpGPf3OeDwBid
    YCHtz-34PCvuu0Wr4H5DmUhvsc15Twl2oUwCg8ZmjE59Rbeq9cnCoF1>
X-ME-Received: <xmr:z_OhaRSemuKzjT-oGXrNWSogPKLbrLTpi-vu1IedxUFJeGaZ4dsJ9qcLueI_Rw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:z_Ohab-ZbrWkafciQVEHAThTV-Yh-Ckq3S2YyTlT_BtT6bCpyzY7xA>
    <xmx:z_OhaXT6B-EykzfYF0SgMpM74iBI6RQd2ZkNrU-zsOkKjyR-01fuiw>
    <xmx:z_OhaSZfpfL1_xg8WSmhWz-KJWkNlHIdMu_lpIxP5SIuk1bmoCJgUw>
    <xmx:z_OhaQQPU7v5UAj9ZVY4wBLd_T2rP-wj01VXNKY6BsqT_uMNeTG53A>
    <xmx:z_Ohad7ckh9R3xrssKX4JIoh7MYPUh8TTidUAmDH2LyR-MDbqf-fqB9O>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:10 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv7 01/18] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Date: Fri, 27 Feb 2026 19:42:39 +0000
Message-ID: <20260227194302.274384-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D0C0DC0010
X-Stat-Signature: owhqksd54gionuiajg6dobbmfco7adfc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772221393-314291
X-HE-Meta: U2FsdGVkX19tYttjpMdmcwWpjzhTlsz72upLTdYfWlMgFKf0Y/q7eg4+shs2TaKF4EL/VcjWIZ+1ewpD/aK3VUgvGqfDe2115rhqfFCTnf0Q+wapjcha3zWxf6Kx6i72z8ZnC6w5pinGWUBnpODD//YhWK966RHcffsqAMmSKraK6WCNH4d4uNEHRESpEVv3XTWWM7dvptZQREu93WjdU20ZUp+KBnH6dAXAkq1508Twh6vl1E/U4Gx79rDz85qilvqZOsDJPua0Ul5+X/A44n3MYw/r81bFMWy46T8tpmEivYgd+d9iGdqrzdZXLY1kMiPK/CpM6cnSLGJO56UxvKBEcioO1m8Ni437PEuHDKSwP7Mm+QtR+jKUyoOkiMb3RiZN87SnVpqrv7u9CU6y3wjgxMezSTEoXhngVJF31eNUGsEeHsUMnLrSj6DV0IDIWPLcAOHJa/1e0tOklHupOF0i5PEKhhAnakkbylsLreVLvDatqTKoYStB45wcXxjsoYtfBxJL8uIIgwyPfNBTFP82yYrCCqObpboXStMQMctAFG/gHujO6dK9xpcjkt47gHSN8bCDuSjNzbuNzIh1I03+0MYGPkYSsl+BNLZgxebGAGRKIW3fSbYqdpyj72nzKe4HzDDxhe8cPFi0ijD1I+gzq7ipLxiYHV5+64J1BSJwbx0Q+Udz03951zguAoL91nXU57/HtGxRQZVALmeXAmyhczu7Oqd9g4joKyY7UDKwK6CMGSg8lqajdzbb+YtbIgCrtZ8Ppjzlw5yAlwpGjtz+3sFJjy6o3eSr71fh7WH3fFKRZpuB65viJImkOklA/8+YcwTzCT1Se0S49fvY5A1RAOm35M1FBCxRLIZuXrWOKTT6RTzUeX/nVEqFLZk+mVgG9FhdBn+1uuRr7uX0ADQOi1lAAxHYXDWvtk5rrRedRTd8jj7EWZ8TQG1SXVhA6Xd39T+ARqyUjG2c0aO
 a8mX0h2c
 FjWN73LxmnJ98Fd1L8g1OnYpBi/loodGrnolSvApqlKqG2ayPMKvKLRy5xF8mfWKi4BgkdDWSbxMb4L0+Fs7Eutx+nSPivyuk64Hz3rZSQzg6lSdqTS+Ok4RacbYFbLwFjcoJTQbN7CpqtvM8o1VGt4WQ62xS54qV0y6MgSH6qDvpEPFY0OjLlZiRVH/yNaD1VMOiNcxQN4xIzlbpqvnMQmhYmObfOoUeg1YHOBtW+/U8hz0U44b/fpeJjwXZlRSepYub9NYJbVOCrpYRsOZWdYOJypoyktXdOSrgEod9FaeGky82rRTTgCdheqeeleFrJ/bSjzemDId+VgJ5qzXJ8arlwKa2+EPAx0Mbf6PeTOks7ajiV6YgWmae1Nz+rao+bXSv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.

This is preparation for adding the vmemmap_tails array to struct
zone, which requires MAX_FOLIO_ORDER to be available in mmzone.h.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mm.h     | 31 -------------------------------
 include/linux/mmzone.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..7f4dbbb9d783 100644
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
@@ -2479,36 +2478,6 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
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



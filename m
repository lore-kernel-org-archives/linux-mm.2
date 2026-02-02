Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62776E7DEFA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DFD6B00F3; Mon,  2 Feb 2026 10:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE1C6B00F5; Mon,  2 Feb 2026 10:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD986B00F6; Mon,  2 Feb 2026 10:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 993526B00F3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:56:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49446D3A75
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:56:57 +0000 (UTC)
X-FDA: 84399970074.18.6E2C72E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3249B140007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:56:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ltgGZ4SC;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7vzDxChpsKg03+NYp1xjpS8xJER5E5J5vzhRbxMT7k=;
	b=gkj7Li1xrXZy1XHNmcOvFDe9tlkc3aEOgHhYd6R69qcYi0czcHvE5V1DKgL9R0ftbpP641
	TKlgaPOonod/nquCmkV1efnFLNeWo8bswWGQwQAyDMkW/BTky5f/uVofmgbVvzXDpMGT/1
	gcxh9GfCy63ncBTu7b3mOIRYlj7FrZs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ltgGZ4SC;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047815; a=rsa-sha256;
	cv=none;
	b=siEnuzvlsf4sjgw2XhJz/gXOwFOrCXGqWbbT0EjrIHSasxS9ju8C2TtXKX9W+V0fRknAbF
	hS4lGdYMB5IefVvEoBiUkt85S4RD2R9mCq+lHz4Zo5/nHZ2qVfd1FL/ZsTgVeLVLcw+PYW
	MuFz8xZ75aFmG+JV7+esA9mgoTsyZbM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8958402E4;
	Mon,  2 Feb 2026 15:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C176C4AF0B;
	Mon,  2 Feb 2026 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047813;
	bh=AAnIadXhZxE/xw6Xd6felYchHz0PQHYO69+c3YSZCe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltgGZ4SCXFUov6HvDevQtFcFhGRD2uyoQ7feb4gdTcRZ/I9TmUkdepKWOb6Jicnav
	 BJ1oAZTPYv5UmtqweWFFl3iXtO2hKC1iM3GqpuFpsq+Ji9AS9NQCP3029lkvLBq6i1
	 QvblSMkfGUMHJ4eN8CRlB1onJBDYHKV0836fzcY8ZyhsXUiz6EEROaw0EtRJiNL4WW
	 ZKmnxXz0rb6ZAkITd8vFtwr/QrNBhezEisrNqtcKvXaYfWMllKilZm6ZbY9GfU0sLK
	 KnbJABN3dKFdQ0EVuoKnqqGns1koTjjQ6GlxrICRLoFPFNTXeZEMYTcvWbYdYCjskP
	 FFE/Bs8yMLLLA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9B01DF40069;
	Mon,  2 Feb 2026 10:56:52 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 02 Feb 2026 10:56:52 -0500
X-ME-Sender: <xms:RMmAaZ4vhPcb7sP9kiqfqIfDeldi64XfuBJEfPgmBT2rfX7sce7y_w>
    <xme:RMmAaXAawH3yQ9DHeaMzL84__JhTR_tp1bUCZ8idXndy1RCiA0m4pBgLTGnz-704-
    63Fby9_qHmipplMmmSngzNP8hY034nn79uxXXrG3AtFZQdOOJJB7mc>
X-ME-Received: <xmr:RMmAaeQ_opyOhrKK5LcaKh-LhRC-K3O42p1t_cRN7Ey16kaH5ktBdxOuKOZukg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:RMmAaWZLoagEu_EMnI49bcGxRGAdZaG8l_6ThTEYNgMMdQ4wmmy4_g>
    <xmx:RMmAabVsjAZGaVKFtdctyHi3-UAOPG9NZjEAP19kfOb1GIfovn5g4A>
    <xmx:RMmAabXa1s9AOlNx0H34Q6mvchAeSh5pzWdxFOODTaj3SsNsnnYvWg>
    <xmx:RMmAaV_jR_-BLSFrPptejodkRwpJXcXTZM7wmigOvJreB9qRbo0L3Q>
    <xmx:RMmAaQorCj8SrIygf8oG6HXC5NCW7lCS1vAPY5UoutPQDbm8B8i3Q594>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:56:50 -0500 (EST)
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
Subject: [PATCHv6 01/17] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Date: Mon,  2 Feb 2026 15:56:17 +0000
Message-ID: <20260202155634.650837-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3249B140007
X-Stat-Signature: pg78fb7p4mpfa3kx47ehbr3k43tqcy19
X-Rspam-User: 
X-HE-Tag: 1770047814-445953
X-HE-Meta: U2FsdGVkX1+oIFzc1d7oGM05JOKs4VUIq3vxOBbDj7QeuqZ2ldJ95+sfSTIm1fm/pT6RGVr4wlAcitHs8HbChIEq+U/47+NOcdh2NsRCpmWcTPdQYGSj/8eUM+cFQbIPMSlTxS2B0g0BGtvAUZSfWdBDSnry7XOk1Gwn0qNTPGCs+0VTom0oRzfWnES3mVcAuOAH57LdsHqdu+JtBqEVSaIphFBih1i13aQQvZTipIKYaXKW6eWnujNNu7e3DdjQFPjM8VsLG5JUmz/+xZjxucPruOBjZpZb3wN8Hdv+kGPkqd7EJYiDjpD7M3Yn7DvAEU0urx2l4Mg15JXHi9kYXaIm5OBzyw7iOmAiQdbwfSdws7NP+q22HmLd3avJKV2IZ632+AF8YUpBgM6kg43QcDrAQmLmmKIG89SGbzH/zP7YF34OvA/f0VL01cJqm8k63qEzt4pIitj8zwINnqsUIXPc8n9WlVGz+0GOG5I+B/pvBTbqVy+t5trnQkmUi73AeTnMwDsgNAESLsrnv5rBBIM1a60EJqoP8scM/MH2kiZVpbxMhpqN5u6dRMgt5YaTfQyzGMk/QZlLF56Q7V2lMBUaZvQIZQ+FE5vC1DS9SQCUmHQZaSTu0o6wP77u/TXsg2hkuH/zCFErT47Q8QVjfstw5sznNu19MGEEEz1kcKY0mAfbUe0Y53jbpKTnhQ7CpI+eN4kjJ6t/TD6s0XcLQIalYy5Wpq6n6a92xsYxYb+l121rOT1RflDssicwBsi6fs/45Rg22hgbHCllqXjGyJ/jRAKmKrdxH/m751V3LtE0v/3+IO7UvUbzaBYYUyAgMC6vgN9wne5BxRwAjGWsBETBy17S3T6eydyDqN8NlHP5e5KH0rZqNdPoUCrojQWSVLoRPKKhaOG5ExbcoZWfKKiRYl7pUJ1MaTmEq1Jf8rRPNWrp6su6I2oRjYZ6v0vZeRPZERmmyCbeDIrsB+A
 M1pgjmmQ
 VD+812cJNqg91YnuXmGf6WFFJ3D8ltGe3dT79WdOOrmJeIfkmTeK4V8Hj18741pq79h0Z75Y5ikZygD9N9UTKFbwk9dBzifpkcUpJnOVyK7jJGSMH+hOIusUHdiTrpLUSHxTXsfl8Okhih1zSdOqKu4lrljib99HRqLH/zfgvcELOKB0QPJDTxmz2ykABr+1k0hKjtBvAD1hQKGjMYvqSUDqPeMPqL6ZnaG7oviGA06sQ8RR+PvSW6y+0N0LHpc0FeihhVZ7zs00UV8H5FIw/tBMSG20l0slaTndnJaA1x8ivAiwbqHH3JcBf9JmykVj24hXfnFCnljs3cUEX6d4/osFHvzMh8UOidLp2joUpqvXF3/U=
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



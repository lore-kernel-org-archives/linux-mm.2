Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27AB0FD7F93
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879316B009F; Fri, 27 Feb 2026 14:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823536B00A3; Fri, 27 Feb 2026 14:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750186B00A4; Fri, 27 Feb 2026 14:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6496B009F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21EA48C719
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:37 +0000 (UTC)
X-FDA: 84491228514.07.702169B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 21EB7140007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GfTopM/F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRHweEHITMhDIEDYfG2/SbUENH4WCd6wB2uHJabN3/o=;
	b=sfgCIras0dnW9fsBJrdm3LH/LlYBa53bYA2ftp+/f/k+IrAdsIj24WVxtdLnN1fPe2fV7z
	ZosINGM9FNlyjoLmvIZWOWbNkKzElj6NsRR11SOm8OnE8qCq3uH5FSzHzo6ApETEjFEjlM
	jXfOeERDB4b85/ikt/wZJtFmYY1VhdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220635; a=rsa-sha256;
	cv=none;
	b=CWMi1EesgsVTUG7U1papsqsiemh8BicQO683rn4+oG5bPiWERaEv7E0j5upy8+2OoV9MgC
	P6vKFa4mNzx+HqqcI/rWu0R08fC+d7dU6kwxQY+6JQXTmRCWTpcWZc9ANqgYWCKqgd1EKr
	qAYtpfX6XSdfXn6lsJo+x/kN8xLMs5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GfTopM/F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 890136013F;
	Fri, 27 Feb 2026 19:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C2AC4AF09;
	Fri, 27 Feb 2026 19:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220634;
	bh=Y1gOIVTqDUoFIuPraJvRHSm3XRXvUUXuo2VeFUmVaTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfTopM/FhZ5VP9VNdyT2qNcb1FactWxr+NX8w/TMapj8UkWMzPTsh68rC1Wk9kC5j
	 d63Zk+r5cHGa31JMvay8jYszIcnzvWzHo0e9TMTWgAeOOugetfWm4teEeepImg3pni
	 tB0rfJsQZicMlrSb7VZMNXRfMI+LQXuoC6P17nQU0RhsTRwmJuGuq4jZbgqEhXAbQw
	 AKEmsX9g0YcU9DL5VLDzVfJnm/8isQVnP5knrLC8SWaTXB4WG9s7VTesJjNA4sBFFr
	 q4YY+m/i4FuPUMWw+d7uJGxbdKuJL6OyKqz7FR62QmGSEF/Ji4SWbDc/bawQuy1Bk+
	 3lp9G15LOI1YQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id AF351F40068;
	Fri, 27 Feb 2026 14:30:32 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 27 Feb 2026 14:30:32 -0500
X-ME-Sender: <xms:2PChaU2h8_5QEA7jdUgzFYTChomOT4Lzughlj5JsPxn5p2Chfjtf4w>
    <xme:2PChafO7qldM6m4VbF5Uiy-w7xVBXWNJGPxIy-j0A8ZA95XQGT5-L5kiXKsXeOLyu
    JB_4Xxfw_lIlP3F4uVsoGKY0bbsmruswyGDI7DriBRu50X3-i2cmAzK>
X-ME-Received: <xmr:2PChaau2aLEQvFwHljJ0DzebfpjGrgYh4t-0yx4YbS1SKKHGvrlFXzdGgu5gow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:2PChaSGoTOEn_ukMBqSi1-nbJ0kUxOOtYuTxZx9KvhKghro_Crjx1A>
    <xmx:2PChaVTqNsNAK_0fOc4z6SlbHsZaA7WoyaUJXdyhlyud77tvIHNTkw>
    <xmx:2PChaWgx3wGNTOEwaoM-8cCQ2FVNRdNkalgw7lCYfIZEfMPI7-vxaQ>
    <xmx:2PChaZafvfFp9mFJKcqhnz1-FKhysjuHp0b-783uN0FtouwTkxIdyg>
    <xmx:2PChaXW4-Ha1ka29tijT4W3s1xNhV3OqgkB0fBUAScKPiUk91Eq33gx0>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:31 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
Subject: [PATCHv7 01/18] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Date: Fri, 27 Feb 2026 19:30:02 +0000
Message-ID: <20260227193030.272078-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21EB7140007
X-Stat-Signature: owhqksd54gionuiajg6dobbmfco7adfc
X-Rspam-User: 
X-HE-Tag: 1772220634-333396
X-HE-Meta: U2FsdGVkX19//h6h+amtYgG0rukMBVyI84tjjdGQ5t3STWlTczgRm78nPoXFdLf47+FElYJUzLPTMBLWfxbpdz/USJD600KIeS1SIAHJyJ1mpeqHCSB+0OiYYsTm9AF0C4fo9IIXW9hJZCxAp7evGuIlFP5CZaYo8C30fM4nL2O0fajSs01cCvkexqyCXfHbXV0IEoWGtQsRkyhS1OOjRR74IqM81p3285vQmbwrRV6fCg9Ur8q52IXtiOsu9V3koWrIMkIFAVCbtJl5JriYq/a1bnSjxsSzkQ8oJTb7lChQstYqDdYILWkw/38Ab92BnBw1Q1dLzY6aSx7Sr5HGvkcQVCYzXj3v1rLKZ6/rW50nKxVfn70J4p9Xpf5xMnnm6TL88Y0tAIW1/7QG7UfqmpN9HMyJmfOiY/BtsS58fpOyaTGyzTfNiSuT30eFk/WcGnWBNMoNNFIuPI4TkL0VHeELnLqa5UPBdIKm78is4mxK4ruG3uk3RDIHBlOBrsKbOojVNQCzZgIFoPTy7AYaXQaZimM+crE6seLATk17kveKUNUNQKv1xwEygAAMh9uirWwurzCaqdP5DjHfKq+ilxiTzs7SLnTD2i/U3m9mgqao0QoUjU9qNPeA7tprA5ZSlHgP5Bdf5O9gYAn8QojM06F77zrWouH4YOWASdhSszuIXfxEqRmTCcZ8fiZkyeskfu1sfRX8hFB9/ZUt0kjnGROkhPPscnPQVBWTgyLo3zih+eG/xA83vHG/pVW2STf9cLNNBiZ5i8MQo0ULmHke4prubLMoAa5aDtJSCXDqh11HfF1uRFyIzsBIFZeDiy21mbO11P2Xfe8yuDbGvk8e4KELJXZBDaLoVm9MRkznCBqLpO1HhHUPzp9IB4tgPnAzhqEJ6ZWWvV6pB6TnoG9vhiSaQjXM0rPpaU185p8HRmNBrTpJQE9HjflkX2J3MxuhhG1gNPGForhfj9lv87h
 NglJSsNF
 peqfsLhV9Y6KgXcC1u3b7VHhWkpIkpF77VHzo9VgnJWc9a59zNvr15uR5y1uiA5xhVf6rKY9y+KZfRpCg7G+ju886ubew0g8vnY4bdE2BhLs9ry/lXgyki71+2+i63sUwFEcLEr8uoZaYZgI9QUqHILOxqiykpkJSn3ucGoKbG1mFEz4TuKHnkUHwTFNsCb3epAEmMzmmU/wMJIPV4ZJzTCPmlJU2/LeipqVbU7fCAywyjRqdpKCA+W2KnU4TsFK+JIj4ixmhCrUt3DEJLq/had0j0k6rxaAbmwzJznHhrUvIGJeEfWngWC+AgwtfrN0LVjZMF+imO8mMfEl3+HGdSKnWgT37E9ZsH1OWP1DfIICt3iCHpCDu+67kPl02FvB+ZsNS
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



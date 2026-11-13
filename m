Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88897606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m3MKDB77
Received: by kanga.kvack.org (Postfix)
	id 907BB6B05CD; Fri, 13 Nov 2026 16:47:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7286B05CE; Fri, 13 Nov 2026 16:47:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778116B05CF; Fri, 13 Nov 2026 16:47:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318CC6B05CD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:47:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56F0714018A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:12 +0000 (UTC)
X-FDA: 85431431904.12.32EC040
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9661580007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3MKDB77;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606430;
	b=Igd9/FdqY1YHjMKoE2Q9AJtIPGJ+iLq5bsXriC6hMVuOUuwFwnibud7HjzQwcElgHWEs5I
	5qR6jfS2BMSJ8YtlQpSXIqm4hjNObdmjUcActJLuh92l9yVIzmUIPJeiVAsC0XnjVtzWL9
	o5+X6PcZ6E1T/FXsuj9/PBsmUN9HhMY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3MKDB77;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apAT4VjpJC36vVjxGEJmMW5TwbguNTu7ge9I4OVkMS8=;
	b=0BZmbRpS2qbUd0+ch0oxsJkiCSxKkGoVXe9Jwvhvz+z3XHTKXOpBxCHU5YQZLltmG8cNYQ
	5U5R1EkkkRhKnaCLYmq6PmssoqeLEbfEnJzLHoAQSjAKo71+gIWL0wPAlIBmQ72RQjr6+R
	ZlZT3DRd2hjut4WHAP6B7HrZCH4Bgqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7B1846CBF;
	Fri, 13 Nov 2026 21:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455181F000C4;
	Fri, 13 Nov 2026 21:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606429;
	bh=apAT4VjpJC36vVjxGEJmMW5TwbguNTu7ge9I4OVkMS8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m3MKDB77Ap4k/9FV325kHd7dhlR5iioZTOIr0DiIMZH0JljSRcnA2DJxvlFLC9n+H
	 c54nMPE7y8quq0sj0qQPd4lXplLnVS51jx3geyudAWreMzKhsSXOjgGjWqkQwCdZBM
	 1bLml3OtBeDqd73kvAjdA6pMrXTlQYNdA54I5BWofbgaNp8LqqPKkvKy9HcZGlVwkl
	 3ORM9hxVgh+CyndWH2w1pUuA4vkxfPNj5yp4bzINF8eLIhp44xq2iHfhtMClMaBWhp
	 V4qtiIjPGP+e/4nC1PkPYeB+k3AyC1cfxC6w2v8jlvXALy+GmS+mAwGXLd9vBCINQ4
	 LmUXwLaUISmEQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:27 +0000
Subject: [PATCH v2 09/13] mm/migrate_device: fix use-after-free of the anon
 rmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-9-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5530; i=ljs@kernel.org;
 h=from:subject:message-id; bh=OX27u7rU+9JbIx9DBrYTwdwqvdYrHdIaQA8QSBlifPs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/yMLL5cc07vbbfb2jn6rg+0tK7svDX1n5nTr1Xbz
 667I5DzpKOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATUTvOyDBbS6LtTvq5TxIb
 Vn8LlCwodQjXWHpjUtx6rYM6DhHv42cyMlw8HnnSLV6/7c/Kda78ufJmXx0T50euvC3wUK7jSxX
 ze14A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: jyu8fs8xofqc8g6eoocu1f4mc46bjfmb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9661580007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606430-957732
X-HE-Meta: U2FsdGVkX1/Vs4DHZx3eN0bx+GWomMVDSBn470xd8KFHFaZXXA3qf7IBPI98hP7LpFy6n6NhTeBEztuje5HmZKfIBwOOLVKKBURTBMP0Oy+zuXZodAcGJ/1XY5ed+dQT7EP6I+s87K0HdOrpZgNEAqc7U60fIhA8OsHM5GmCd7vjAmfzBbP45Oxnn3VpctaZrTnRNqAONny/KcoO9eCJYWzQ4ilQNdLO1xlS98OmBgEj3qdNSNezqIU9oJaf88SgQmmb8Ojk1/HN7xJTHdk+oomj/dZMukVdwFZ9UMfs70DcCPyALtuuxhd/opRklOK5j6pb7kMEudukF9vOLMNgJ9c+l/M+foea9R0uKqQxm7bjQ9TmBenkNFV429LIZKPBn2rUzsyUh/dNUhyzG43qRIasugNzAoo9PJSQeBR+vtU5aIZaeu+l+F7MUj7msxVsREqMnVkk3vYr2OuJx3axEYT0Wj5+Uzhyh5qrK0hA//uSDaS6Frzz6uZWFtNhmXPXkvezldxx6Uv1utuxuBJFir+lnzWrBrAHt/yVgCSFVRN6KWN5oUbKljCmcDV5TAeDb0Qtg7krLK76giVYKpZZ1cmMurB06nb09N2gS2jIDMw2QbnhIuRHBzDFhCjsaen7+Lv2WlY5Ak51D+IhZlEG3keSI+7gfIj/BUOp/HxWIWVpj29XYXpoBrwaf9mHE5aaNTq9fguwhpfsoIH3fpfMRH4MDL+6TVBF5MraZbCvmUU/axfHGFjutADAKm4XvD5d1K57lo8g5x11LvMTrvuRaNf317DYo1y/HEq1l1sTMG3MHsYnsUqFU7llngfiqWH4v4BuHsrf/3lIU4w+pNxn8HonHzjz9MTUomYaoIzadG9QGm2RsYcqrI6g89qyyvrSkwtgQpr3x7si1BtvdwmUID+wpMTZAYcktqyTbHnXYZ5zklO0vxEiyeFnAW7Z2oR1bX9JWD4yWnuGq/36bv8
 Maxb31rz
 f/cXekBP9ihjG6AcEAgv1satZwQGS5IfNCqqIbDHLsDy+s5BF0CnqJPmO7z0SRNNOmElgoJGIOZKFYc3or2HwmOydxGfgv0l0Z1Zb6eG0KLskBMZGAnF9TNfPIhEXjET0pv/EjQ6GBuek45VT2Aj9RmA5Prv8BvZhph2H1txpEIGGbFFpHbX0ajShIitOhTxNoaeigXMOXvwybEPJBfAypsa0be6yReRyaBmh5qarjsQQp1j6ASPZa8LJ8Gu7b7G77rKwsNkirKvQ6Syof4VJTlxvc5rMIwOxpumtLPXodEG04h1xUmNjYjSCil21ZSzyMy3m453V3CYcKvqluPelLTdY7Q0WTwAXi4eM2EGvXj6kotYrj0avjk4jzwog+7CG1N4dGCJIZkb67zDTwkwu18om7hJ60a3CQbIe5IPWTNO4XUPGaqLW69qEccI+b+idWTo6O85WcmH/3+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A munmap() of anonymous memory can result in a use-after-free of the
anonymous rmap if a concurrent device memory migration occurs and the
migration runs without the mmap_lock held.

This can occur for a long-term pin of device-coherent memory, or a driver
evicting its device memory by PFN.

Consider:

    eviction                        munmap()
    ========                        ========
    migrate_device_range()
      migrate_device_unmap()
        try_to_migrate()
                                    zap the migration entry
                                    unlink_anon_vmas()
                                      last VMA: free the anon_vma
    migrate_device_finalize()
      remove_migration_ptes()
        /* locks and walks the freed anon_vma */

If munmap() runs before try_to_migrate() instead, the folio is no longer
mapped and gets no migration entry. The walk still runs, and follows the
stale folio->mapping to the freed anon_vma.

Resolve this by pinning the anon rmap of each folio which possesses one in
migrate_device_range(), migrate_device_pfns() and
migrate_device_coherent_folio() before its PTEs are replaced, and
unpinning it once the walk is done.

A folio which is no longer mapped cannot be pinned and has no migration
entries to remove, so skip it rather than migrating it.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/migrate.h |  1 +
 mm/migrate_device.c     | 39 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 78424b3824c2..c6cce7925b9b 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -136,6 +136,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 #define MIGRATE_PFN_MIGRATE	(1UL << 1)
 #define MIGRATE_PFN_WRITE	(1UL << 3)
 #define MIGRATE_PFN_COMPOUND	(1UL << 4)
+#define MIGRATE_PFN_ANON_RMAP	(1UL << 5)	/* mm internal */
 #define MIGRATE_PFN_SHIFT	6
 
 static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 141d60d27e90..b4660eeb975a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -552,6 +552,27 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
 	return true;
 }
 
+/*
+ * Pin the anonymous rmap if present to allow migration entries to be safely
+ * removed. Returns true if the pin succeeded or no pin is required, and false
+ * if the folio is no longer mapped.
+ */
+static bool pin_anon_rmap(struct folio *folio, unsigned long *src_pfn)
+{
+	if (!folio_test_anon(folio) || folio_test_ksm(folio))
+		return true;
+	if (!folio_get_anon_vma(folio)) /* Pin the anon rmap. */
+		return false;
+	*src_pfn |= MIGRATE_PFN_ANON_RMAP;
+	return true;
+}
+
+static void unpin_anon_rmap(struct folio *folio, unsigned long src_pfn)
+{
+	if (src_pfn & MIGRATE_PFN_ANON_RMAP)
+		put_anon_vma(folio_anon_vma(folio)); /* Unpin the anon rmap. */
+}
+
 /*
  * Unmaps pages for migration. Returns number of source pfns marked as
  * migrating.
@@ -633,6 +654,7 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 
 		folio = page_folio(page);
 		remove_migration_ptes(folio, folio, 0);
+		unpin_anon_rmap(folio, src_pfns[i]);
 
 		src_pfns[i] = 0;
 		if (fault_folio != folio)
@@ -1331,6 +1353,7 @@ static void __migrate_device_finalize(unsigned long *src_pfns,
 		if (!folio_is_zone_device(dst))
 			folio_add_lru(dst);
 		remove_migration_ptes(src, dst, 0);
+		unpin_anon_rmap(src, src_pfns[i]);
 		if (fault_folio != src)
 			folio_unlock(src);
 		folio_put(src);
@@ -1380,6 +1403,7 @@ EXPORT_SYMBOL(migrate_vma_finalize);
 
 static unsigned long migrate_device_pfn_lock(unsigned long pfn)
 {
+	unsigned long src_pfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 	struct folio *folio;
 
 	folio = folio_get_nontail_page(pfn_to_page(pfn));
@@ -1391,7 +1415,13 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
 		return 0;
 	}
 
-	return migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
+	if (!pin_anon_rmap(folio, &src_pfn)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return 0;
+	}
+
+	return src_pfn;
 }
 
 /**
@@ -1427,6 +1457,7 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
 		nr = folio_nr_pages(folio);
 		if (nr > npages - i) {
 			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+				unpin_anon_rmap(folio, src_pfns[i]);
 				folio_unlock(folio);
 				folio_put(folio);
 			}
@@ -1470,6 +1501,7 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
 		nr = folio_nr_pages(folio);
 		if (nr > npages - i) {
 			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
+				unpin_anon_rmap(folio, src_pfns[i]);
 				folio_unlock(folio);
 				folio_put(folio);
 			}
@@ -1505,6 +1537,11 @@ int migrate_device_coherent_folio(struct folio *folio)
 
 	folio_lock(folio);
 	src_pfn = migrate_pfn(folio_pfn(folio)) | MIGRATE_PFN_MIGRATE;
+	if (!pin_anon_rmap(folio, &src_pfn)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return -EBUSY;
+	}
 
 	/*
 	 * We don't have a VMA and don't need to walk the page tables to find

-- 
2.56.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6018ACD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88826B008C; Tue, 12 May 2026 07:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11156B0092; Tue, 12 May 2026 07:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927D56B0093; Tue, 12 May 2026 07:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82BB46B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:04:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18593C1BC7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:04:14 +0000 (UTC)
X-FDA: 84758483628.04.1464A61
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4670A0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:04:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E5+G1AQK;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778583852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJ453m18AXLW2cvTL2nZxKSqcBfSaYzaUhJU3ZkcczM=;
	b=vTGqTh9DF51KaAqi4rj719cK16C8qX8FvkJ8E1YHy0Xb679wMRsrIJVpVCrmVKV23SWPl4
	YRmQjaGDocz9muxrW1pLerdRdMgccbaZC4cdVWYQXSVuZAWhfIX/hCsR4z0lm9RcUZQoiO
	MZUJuS9LU+PaoGdgXXuNSUlcCr5VnY8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E5+G1AQK;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778583852; a=rsa-sha256;
	cv=none;
	b=yKsltLe9GZG3gx/iJf3DSaOD2tYVMI6TpARVBt9GtV2ePhfv4fqbtfkgorduJiYzPeTuCc
	k3ZY7eQ6MnvPXmEOTN25lNfCz+lMDk2WYm+j6ElNnrJsA1q6V3fr/Hs0du/llQfazqh5az
	Tj1MIscEaT1MchoPjwQVo/fq1BlMiSM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778583852; x=1810119852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0/h+ElM/jcg5vY60EU0F+b8mrK8INiKreVM7Lv+pmWY=;
  b=E5+G1AQKmdraoZ4ONWQfjblN3CUGCtNy4crjYfs5CZKzWsNXem/PCakk
   Dmat+m+eEn2rutzgcIQEaCOqrNDk0lUz3vrKkHOo0e6vDUfTG/P2Jjiz6
   xQ4HJMDy4Abq1e/1Fp0n2jWaAzS4GQ6fbEkPO65jF8JAseLKrbTazqgEG
   WzNyH5JgwmEgchNC3BFj8hd6QyiwJ9T42tDD5leHeJdKGQL0uD4A+yL5l
   IxZsVtJP0Zlr0Q0jVi/R+33lDcdPyxumYw5+XYmB9FpHevO3F8lfNdFm7
   s3svaOgUDqF9yjn7zt5h5MRpfzQaggmnNFG/xw/JAAt/w/3ZHzVdBGiL+
   g==;
X-CSE-ConnectionGUID: PXKSmrL9SfyrVLsT1+w/4w==
X-CSE-MsgGUID: ZlmYvl6DR5O1W4dLXVVzMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="104944463"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="104944463"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 04:04:11 -0700
X-CSE-ConnectionGUID: JvmgcqrwRb+j0gZOdoRRXw==
X-CSE-MsgGUID: 1Z5CXpMuSzO6E8CS8mSylg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="231339484"
Received: from vpanait-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.172])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 04:04:05 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
Date: Tue, 12 May 2026 13:03:38 +0200
Message-ID: <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C4670A0007
X-Rspamd-Server: rspam06
X-Stat-Signature: 5nk1yo1cjjqk8q1e81uofpxznuftnabt
X-HE-Tag: 1778583851-967007
X-HE-Meta: U2FsdGVkX1+C1sUKZvsXh5DKTK3ppcuY/EHkCO7mtAdNjMIhim03qUHEErebTjtE52D/aamU631X6SMPdQ2/vDC10eOtdrw3C/NZIp8+RfHxPXsFDT5psZ8N23Fdj0ijSQyFg/RqoT+Pyih03bz0cYJt58QGdIP+Qyy4pna6ZRdlrGmsC63toWRqqRF6IJDFp+yvR8QAvvnaYPOqY5zirKtyM0Xneb6tS+TJsDRxY0rQukl9VgJJPtlW5spY1AyMReF56xGIY4w+Q3+uHZDmnnNKn33rR1VTHmnzS7zQJFTFKlcm66Qgr9IZLJKcLttYVvBqQqNVJ7WsL0LepAkSBQ+K1RgP0KGqyRC4mLLUKmdvlg6v0mRZQVME8evz7fdAQH/o5UIYu2cwZsHj806WTtvKbZhJeIDuYyO6WgDr+NvIWDoQ1DTWIM/XXtwTybcJfI7K34K9SOyVs9w5ClvmeWuVRJ+gJmeTLQ+GIZFXJR9LQQXDmXhpxVgo50B/1t8rcAjuZt6YXN8+HijQz/sXjOgQ1FYSOAg5U+ek9nk7VIm50OPY02p53vXd+OZ2o/W6YDZTDQu7HMWx8VVNoowVBGF0VECUtPh/wy6SiUFGK/iQEvRc9zAodt7pyE019EAi0YrDaQwi76B/lOcnwDLjdx6BBFg3NZec2XPWGCEyCBRAsCwMzpZLxjGQPXJEIJkSOuMBndeZ/jLcCAzjxJrt8tWbLgw7enuGJMtDV1Oq+EOMShf0zUAAEXQFimWdPJ/dt6yCEDynY2fEdthsYygjP+UXFSVXNj9q7uoYtgCjiDXOU5cDbv+yZa8gqMTZtshrqxFoQh32DSDZlVFlVEHFaJLhmQf9LDe+/NavlmHYDB7RdMBqcjdzQ7r47do9ijA0skSauz2kk7DfnpQVjV6/ughcFTh8XT3E5E9Lzp6O36hhGhC5THmklENGZyMtmn/BXHrx2kqOyOuMeBIja+j
 sY5gLDvA
 asjKlnPU29+r37T8qdNS9vkNB0Xx/0bJKeW9j1NqR0H/eZx4D2Cohi1Unuwe94WftWgassCWj8+ANqlp86enZrL9qj10gu23Um4yFTjaPlYrEMUQv6mbw7jl5sENncK6Gp7ehhfAwawz6O0qwW+JGq+2yjvpPUFvCKSmBAzG08e1rtP8ZwvxwjfMv0trl4OaaAaatX182BnQ7xZ61aFBfrhmuhDgWuYhFgNdfd0a0DxcpvVK31NcBzAbHTa8A2iYw9IpTxFRnW92nmWk3RMJSw6yY94YflX2Spd3Cnbm8Elb74MGnL4nU5ulGBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce shmem_insert_folio(), which transfers an isolated folio
zero-copy into a shmem file's page cache.  The folio is charged to
memcg, inserted into the address space, and placed on the anon LRU
for normal reclaim.  An optional writeback parameter requests
immediate swap writeback.

Higher-order folios are promoted to compound before insertion,
enabling THP-sized swap entries with CONFIG_THP_SWAP=y.  On failure
the folio is returned to its original state and the caller retains
ownership.

Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 include/linux/mm.h       |   1 +
 include/linux/shmem_fs.h |   2 +
 mm/page_alloc.c          |  21 ++++++++
 mm/shmem.c               | 105 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..e2e7b0c0998b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1676,6 +1676,7 @@ struct mmu_gather;
 struct inode;
 
 extern void prep_compound_page(struct page *page, unsigned int order);
+extern void undo_compound_page(struct page *page);
 
 static inline unsigned int folio_large_order(const struct folio *folio)
 {
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 93a0ba872ebe..2dc9355757fd 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -175,6 +175,8 @@ int shmem_get_folio(struct inode *inode, pgoff_t index, loff_t write_end,
 		struct folio **foliop, enum sgp_type sgp);
 struct folio *shmem_read_folio_gfp(struct address_space *mapping,
 		pgoff_t index, gfp_t gfp);
+int shmem_insert_folio(struct file *file, struct folio *folio, unsigned int order,
+		       pgoff_t index, bool writeback, gfp_t folio_gfp);
 
 static inline struct folio *shmem_read_folio(struct address_space *mapping,
 		pgoff_t index)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..db82825a3348 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -705,6 +705,27 @@ void prep_compound_page(struct page *page, unsigned int order)
 	prep_compound_head(page, order);
 }
 
+/**
+ * undo_compound_page() - Reverse the effect of prep_compound_page().
+ * @page: The head page of a compound page to demote.
+ *
+ * Returns the pages to non-compound state as if prep_compound_page()
+ * had never been called.  split_page() must NOT have been called on
+ * the compound page; tail refcounts must be 0.  The caller must ensure
+ * no other users hold references to the compound page.
+ */
+void undo_compound_page(struct page *page)
+{
+	unsigned int i, nr = 1U << compound_order(page);
+
+	page[1].flags.f &= ~PAGE_FLAGS_SECOND;
+	for (i = 1; i < nr; i++) {
+		page[i].mapping = NULL;
+		clear_compound_head(&page[i]);
+	}
+	ClearPageHead(page);
+}
+
 static inline void set_buddy_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..45e80a74f77c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -937,6 +937,111 @@ int shmem_add_to_page_cache(struct folio *folio,
 	return 0;
 }
 
+/**
+ * shmem_insert_folio() - Insert an isolated folio into a shmem file.
+ * @file: The shmem file created with shmem_file_setup().
+ * @folio: The folio to insert. Must be isolated (not on LRU), unlocked,
+ *         have exactly one reference (the caller's), have no page-table
+ *         mappings, and have folio->mapping == NULL.
+ * @order: The allocation order of @folio.  If @order > 0 and @folio is
+ *         not already a large (compound) folio, it will be promoted to a
+ *         compound folio of this order inside this function.  This requires
+ *         the standard post-alloc state: head refcount == 1, tail
+ *         refcounts == 0 (i.e. split_page() must NOT have been called).
+ *         On failure the promotion is reversed and the folio is returned
+ *         to its original non-compound state.
+ * @index: Page-cache index at which to insert. Must be aligned to
+ *         (1 << @order) and within the file's size.
+ * @writeback: If true, attempt immediate writeback to swap after insertion.
+ *             Best-effort; failure is silently ignored.
+ * @folio_gfp: The GFP flags to use for memory-cgroup charging.
+ *
+ * The folio is inserted zero-copy into the shmem page cache and placed on
+ * the anon LRU, where it participates in normal kernel reclaim (written to
+ * swap under memory pressure).  Any previous content at @index is discarded.
+ * On success the caller should release their reference with folio_put() and
+ * track the (@file, @index) pair for later recovery via shmem_read_folio()
+ * and release via shmem_truncate_range().
+ *
+ * Return: 0 on success.  On failure the folio is returned to its original
+ * state and the caller retains ownership.
+ */
+int shmem_insert_folio(struct file *file, struct folio *folio, unsigned int order,
+		       pgoff_t index, bool writeback, gfp_t folio_gfp)
+{
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	bool promoted;
+	long nr_pages;
+	int ret;
+
+	promoted = order > 0 && !folio_test_large(folio);
+	if (promoted)
+		prep_compound_page(&folio->page, order);
+	nr_pages = folio_nr_pages(folio);
+
+	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+	VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
+	VM_BUG_ON_FOLIO(folio->mapping, folio);
+	VM_BUG_ON(index != round_down(index, nr_pages));
+
+	folio_lock(folio);
+	__folio_set_swapbacked(folio);
+	folio_mark_uptodate(folio);
+
+	folio_gfp &= GFP_RECLAIM_MASK;
+	ret = mem_cgroup_charge(folio, NULL, folio_gfp);
+	if (ret)
+		goto err_unlock;
+
+	ret = shmem_add_to_page_cache(folio, mapping, index, NULL, folio_gfp);
+	if (ret == -EEXIST) {
+		shmem_truncate_range(inode,
+				     (loff_t)index << PAGE_SHIFT,
+				     ((loff_t)(index + nr_pages) << PAGE_SHIFT) - 1);
+		ret = shmem_add_to_page_cache(folio, mapping, index, NULL,
+					      folio_gfp);
+	}
+	if (ret)
+		goto err_uncharge;
+
+	folio_mark_dirty(folio);
+
+	ret = shmem_inode_acct_blocks(inode, nr_pages);
+	if (ret) {
+		filemap_remove_folio(folio);
+		goto err_uncharge;
+	}
+
+	shmem_recalc_inode(inode, nr_pages, 0);
+
+	if (writeback) {
+		ret = shmem_writeout(folio, NULL, NULL);
+		if (ret == AOP_WRITEPAGE_ACTIVATE) {
+			/* No swap slot available; reclaim will retry. */
+			folio_add_lru(folio);
+			folio_unlock(folio);
+		}
+		/* ret == 0 or ret < 0: folio unlocked by shmem_writeout */
+	} else {
+		folio_add_lru(folio);
+		folio_unlock(folio);
+	}
+
+	return 0;
+
+err_uncharge:
+	mem_cgroup_uncharge(folio);
+err_unlock:
+	__folio_clear_swapbacked(folio);
+	folio_unlock(folio);
+	if (promoted)
+		undo_compound_page(&folio->page);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(shmem_insert_folio);
+
 /*
  * Somewhat like filemap_remove_folio, but substitutes swap for @folio.
  */
-- 
2.54.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A37F606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=SG/Kcund
Received: by kanga.kvack.org (Postfix)
	id 2EF546B06B7; Tue, 27 Oct 2026 07:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6926B06B9; Tue, 27 Oct 2026 07:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DCE16B06BA; Tue, 27 Oct 2026 07:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E94ED6B06B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:27:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BF6CC09B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:27:37 +0000 (UTC)
X-FDA: 85368180954.04.6707D7D
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1AADDC0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:27:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="SG/Kcund";
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf22.hostedemail.com: domain of "prvs=753d3cd48=dipiets@amazon.it" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=753d3cd48=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793100455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HsKdK9P6x+a2bQCUw3wOJJDVhpLfIWOP/r/ePtVHGk=;
	b=bJGw2zhLRWWs+wFF21nrzbTtccML9o5irkXD/yRtW8OlZagxCNnA5N8DoDKdDR03yU5KC8
	9G7+lvKDY2W4j0VdJIu7IVAvwcvnafhmNUwyYznEjFfNleD/2asiyubhPi6qEw0enAC8XA
	pafC8JR7OF2fKWP7ro9WdhO0T/Iy2/w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="SG/Kcund";
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf22.hostedemail.com: domain of "prvs=753d3cd48=dipiets@amazon.it" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=753d3cd48=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793100455;
	b=n5bsF5ijDEmNoX8e7jhNqezeltH7wZiLcUL7iU7D5uGekdAN5ivyj0LRMwFjCBIaBT+YWb
	HLCiyTCZEC3oyHm22fVG4zJLrPIYQJR5PnUs/5r5bjhgehHUkjPeO1zVPpECVQqrfKF+Yy
	ImhQvsr6kDztWYcBv+T+l7DcBHFlUAc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1793100455; x=1824636455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2HsKdK9P6x+a2bQCUw3wOJJDVhpLfIWOP/r/ePtVHGk=;
  b=SG/Kcund9R8LO86hfx8zU/0WmHr6juhlRI2SVL88nJxrReaMCpo1XQ/c
   Gc6JAMO9vTv2j6y1w/htAo+Z1uFdrH6ru3Pxp8PX9QrKTnsRWkbIVuB5L
   0Ag9dXh9V5T9evSS8YECV367rcqSp1KGITeie0tuZIK8S+KFW+BY2I9QD
   VU5Bv0ZDsX+W+jO1s2q9epNhcpOzG6lfCWUqN+Ju991y0KNtED+VB2vHo
   3Pv7ztqk01uUBUg+XOTOgo5qp4eUaGyGQ5XFnfd/Zi8JC1JIARC6KAzfg
   dt+ObNpWpH8VyT17qLRHZ2NnkbTaM4w8eP6Rm4MwUNCsfXLh1EYvWWzvU
   g==;
X-CSE-ConnectionGUID: 385GSDEWQP6GfoP9TG5oPQ==
X-CSE-MsgGUID: wuJCmHMiTHui2Zvf77Ci4g==
X-IronPort-AV: E=Sophos;i="6.27,181,1787011200"; 
   d="scan'208";a="32251280"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:27:31 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:23464]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.230:2525] with esmtp (Farcaster)
 id c8175336-d6c7-4fea-bc92-125eeab3bbca; Tue, 27 Oct 2026 11:27:30 +0000 (UTC)
X-Farcaster-Flow-ID: c8175336-d6c7-4fea-bc92-125eeab3bbca
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 27 Oct 2026 11:27:30 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 27 Oct 2026
 11:27:24 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <ryan.roberts@arm.com>, <abuehaze@amazon.com>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <dipietro.salvatore@gmail.com>, <rvvandan@amazon.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<linkinjeon@kernel.org>, <sj1557.seo@samsung.com>, <yuezhang.mo@sony.com>,
	<miklos@szeredi.hu>, <agruenba@redhat.com>, <djwong@kernel.org>,
	<hyc.lee@gmail.com>, <almaz.alexandrovich@paragon-software.com>,
	<cem@kernel.org>, <dlemoal@kernel.org>, <naohiro.aota@wdc.com>,
	<jth@kernel.org>, <willy@infradead.org>, <david@kernel.org>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <ritesh.list@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<exfat@lists.linux.dev>, <fuse-devel@lists.linux.dev>,
	<gfs2@lists.linux.dev>, <linux-xfs@vger.kernel.org>, <ntfs@lists.linux.dev>,
	<ntfs3@lists.linux.dev>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] mm: add infrastructure for per-dirty-page accounting
Date: Tue, 27 Oct 2026 11:27:01 +0000
Message-ID: <20261027112702.3747009-2-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261027112702.3747009-1-dipiets@amazon.it>
References: <20261027112702.3747009-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1AADDC0005
X-Stat-Signature: 4tbc9ho6x6txnb3w799uwm6u1fyfeq6j
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793100454-972160
X-HE-Meta: U2FsdGVkX18qKXNX6k9EN24dh+OP2ktqeshy8kkm/YVU2je3Kys8xxVoT6yp7BiUEp3wZk7fU7iA4sXzkI5AlWJCMjZPuy9M8r9iKmv2q6Gyu5oTP8vcfmYMM5a1um2l7lqFRWwdW3s+i5twpWLmB/QDPjEuQRZAK334P6VXk3TKdfXESLfcM6fAAWyMWoQMCjmGbrKPbhr4A8jPckbFPP1VoG8Qpdb3BwDWrynWi7bGz5kwYjqonOPJZSbtzt2eftcC/N84FQp3HKL21sc5lxONxfAaFUaCeAYMXIEfVKLs95VD/PpJlDeH9Fhd4zEocOg3RnXgKyXt+Tg6klnSWlclQZ6d13Ud10pUFf9mzUxazm0kTdlkrYCr1uVlIc8Cm/ob3SyFPjV1D9xusNQLfxSvV2c4Uu3/UFpJxeBwFrQ3/hPfqJCh8ioqlP4rHBW59QpQwNfkLA2TrbTwAiZEUUwCg2C34tPCTdMELeGHCdvo40MpF/2a1A+haKV2GZQYHZOHfDvazL0mfzYB4PO9/56daZSlWjOvE1nI4gIBFNVTpqFQ9bGwHqzHP6tvVRKBw4QRmB0LEbsMWast3npPIIgsUrjaT0nFaYG+SO6MdqvPay+K/RkQ7ygHI6aZC7r0mSLzEZPtlZna154nlNVlHtvBP9s3iGJ5Pnf5t+SZPTJ3ECsTi2OP7wjWC3zW6OfvBVgAXuvYA5kHtuFCZ5t93hjSzTIdnQZmhoKL3HsvgeYuoGmjNwzNCpWzopBgLNv7jtR84sJhmBSIK1J1lqgyN8jSjyjT+DnbQw0OSE10BVU4UCmPHZ2AEP2E0/hEnvf/7534biGoukCflB489dw3ZcqkaqtewqLI9svsIyAupejHsoGCST6ZypBP+FT4DRanXWz29d6AaizXTR0K16cjCk7oZq3v3SdvaK+biHGKmZs5tzNwjtdgg1NJXpBbMV6mjC1ciKzfjqJwDeeH+nj
 OxaeMaEy
 grDxBb2MfhcaFKoyb5vIJ88hbS7Q7Mt4wq8ZUobAB+2T6AVfzCzNBvvy3gKF9oCtpxAzKHFvaTdLh7kYQpArw9R0lEWaaHzUN/KTwmTHSSTdiJdlAUWlg3+YZwtlPiilC8zH0s8gqJuQiWbdk2W4/8qoWtuBfKS1ktlvmh2CIFSw/gS9S5ne3Pp6SozM/9WhdK1UDyQyGO9ZSDn4gRooDda/oMIkBWsdS4U1v0W4n+LAsRQHMvMBS0zO58CvkQF9n8fifxJkkegMEToYgqwAYIim+MEdzK/m1q+6DIMTdnG2cOEhFYwhBr8GCeSViQ2zUIpcas7eQoT/ns21WUzpJCIGuFbm9dO3YlUZO0hskvudeKUraF1Bn5SvzRCj518OcrGo22xG9S913QPjo1tDjxRJMvHpkIY7I2DY56JYMTbZF5N5b7r1mn/IA6nH1pfVHnDCnv9o+JdU1IyjXsqZQI37aWuyFzlbI1Vxwd46LLdKGPdlhdnj/MfBiscdCDmhk0SOfau+RALq+9lNsHTErChFfUqbJQXtqZH0fwsE9GyH3xvkxWYP9hHHiN8mOI5vrzS2ZO37Sx9EtQFhFfthYenEDQV/HoZWH9phBLgIG7eulqwhbA0h+eHKCiG/gkrtfoGhqCij8roa94d64JhbExT6F5vUZKYJ3Stj8MW7or/5naJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the mm-side machinery that lets a filesystem charge the dirty
counters (NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE) per
dirty page instead of per whole folio, without yet enabling it for
any filesystem.

Add an AS_DIRTY_PER_BLOCK mapping flag with
mapping_set_dirty_per_block()/mapping_dirty_per_block() helpers, an
accounted_dirty_pages() address_space_operations callback, and an
@accounted argument to __folio_mark_dirty() (with filemap_dirty_folio()
split into __filemap_dirty_folio()) so the generic per-folio charge can
be suppressed for folios a filesystem has already accounted.

folio_accounted_dirty_pages() dispatches through the new a_ops callback,
falling back to folio_nr_pages() when no filesystem opts in, and
folio_account_cleaned() and folio migration use it in place of
folio_nr_pages().  folio_clear_dirty_for_io() leaves the charge of
per-block folios to the filesystem.  No filesystem sets the flag or
registers the callback yet, so this commit is a no-op on its own.

This is a prerequisite for the following iomap patch, which fixes the
over-accounting; both are needed for stable.

Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Reviewed-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
---
 fs/buffer.c             |  4 +-
 include/linux/fs.h      |  7 ++++
 include/linux/pagemap.h | 20 ++++++++-
 mm/internal.h           |  3 ++
 mm/migrate.c            | 17 ++++++--
 mm/page-writeback.c     | 91 ++++++++++++++++++++++++++++++++---------
 6 files changed, 115 insertions(+), 27 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ed966fa73b1b..7ed5250dda9d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -693,7 +693,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 	spin_unlock(&mapping->i_private_lock);
 
 	if (newly_dirty)
-		__folio_mark_dirty(folio, mapping, 1);
+		__folio_mark_dirty(folio, mapping, 1, false);
 
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -1011,7 +1011,7 @@ void mark_buffer_dirty(struct buffer_head *bh)
 		if (!folio_test_set_dirty(folio)) {
 			mapping = folio->mapping;
 			if (mapping)
-				__folio_mark_dirty(folio, mapping, 0);
+				__folio_mark_dirty(folio, mapping, 0, false);
 		}
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index deb411e86661..5abd2af50b59 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -407,6 +407,13 @@ struct address_space_operations {
 	/* Mark a folio dirty.  Return true if this dirtied it */
 	bool (*dirty_folio)(struct address_space *, struct folio *);
 
+	/*
+	 * Pages of the folio currently charged to the dirty counters, for
+	 * filesystems that account dirty state at sub-folio (per-block)
+	 * granularity.
+	 */
+	long (*accounted_dirty_pages)(struct folio *folio);
+
 	void (*readahead)(struct readahead_control *);
 
 	int (*write_begin)(const struct kiocb *, struct address_space *mapping,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..5bbcd9da1a6b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_DIRTY_PER_BLOCK = 11, /* fs accounts dirty pages, not whole folios */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -304,6 +305,20 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
 	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
+/*
+ * Set by filesystems that charge the mm dirty counters per dirty page rather
+ * than per folio, so the generic paths must not also account whole folios.
+ */
+static inline void mapping_set_dirty_per_block(struct address_space *mapping)
+{
+	set_bit(AS_DIRTY_PER_BLOCK, &mapping->flags);
+}
+
+static inline bool mapping_dirty_per_block(const struct address_space *mapping)
+{
+	return test_bit(AS_DIRTY_PER_BLOCK, &mapping->flags);
+}
+
 static inline bool mapping_stable_writes(const struct address_space *mapping)
 {
 	return test_bit(AS_STABLE_WRITES, &mapping->flags);
@@ -1311,7 +1326,10 @@ void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
-void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
+void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
+		int warn, bool accounted);
+bool __filemap_dirty_folio(struct address_space *mapping, struct folio *folio,
+		bool accounted);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..4647aca5fe8d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -40,6 +40,9 @@ void *workingset_eviction(struct folio *folio,
 void workingset_refault(struct folio *folio, void *shadow);
 void workingset_activation(struct folio *folio);
 
+/* mm/page-writeback.c */
+long folio_accounted_dirty_pages(struct folio *folio);
+
 /* mm/folio.c */
 void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..0e7b7834a9fd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -588,6 +588,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	struct zone *oldzone, *newzone;
 	int dirty;
 	long nr = folio_nr_pages(folio);
+	long nr_dirty = nr;
 
 	if (!mapping) {
 		/* Take off deferred split queue while frozen and memcg set */
@@ -614,6 +615,14 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	oldzone = folio_zone(folio);
 	newzone = folio_zone(newfolio);
 
+	/*
+	 * Only what was charged moves between the zones below, which may be less
+	 * than the whole folio.  Sample it outside the i_pages lock, as it walks
+	 * the per-block state, and while the folio is still dirty.
+	 */
+	if (folio_test_dirty(folio))
+		nr_dirty = folio_accounted_dirty_pages(folio);
+
 	if (folio_test_swapcache(folio))
 		ci = swap_cluster_get_and_lock_irq(folio);
 	else
@@ -708,10 +717,10 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		}
 #endif
 		if (dirty && mapping_can_writeback(mapping)) {
-			mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
-			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
-			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
-			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
+			mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr_dirty);
+			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr_dirty);
+			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr_dirty);
+			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr_dirty);
 		}
 		rcu_read_unlock();
 	}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eeab25d6ce36..6b4a8b6ad34c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2601,7 +2601,7 @@ EXPORT_SYMBOL(noop_dirty_folio);
  * NOTE: This relies on being atomic wrt interrupts.
  */
 static void folio_account_dirtied(struct folio *folio,
-		struct address_space *mapping)
+		struct address_space *mapping, bool accounted)
 {
 	struct inode *inode = mapping->host;
 
@@ -2614,14 +2614,21 @@ static void folio_account_dirtied(struct folio *folio,
 		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
 
-		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
-		if (folio_test_dropbehind(folio))
-			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
-		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
-		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
-		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
-		wb_stat_mod(wb, WB_DIRTIED, nr);
-		task_io_account_write(nr * PAGE_SIZE);
+		/*
+		 * @accounted means the filesystem charged these per dirty page
+		 * already; the rate limiters below stay per-folio.  Keep in sync
+		 * with folio_account_cleaned() and folio_clear_dirty_for_io().
+		 */
+		if (!accounted) {
+			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+			if (folio_test_dropbehind(folio))
+				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
+			__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
+			wb_stat_mod(wb, WB_RECLAIMABLE, nr);
+			__node_stat_mod_folio(folio, NR_DIRTIED, nr);
+			wb_stat_mod(wb, WB_DIRTIED, nr);
+			task_io_account_write(nr * PAGE_SIZE);
+		}
 		current->nr_dirtied += nr;
 		__this_cpu_add(bdp_ratelimits, nr);
 
@@ -2629,13 +2636,41 @@ static void folio_account_dirtied(struct folio *folio,
 	}
 }
 
+/**
+ * folio_accounted_dirty_pages - pages of @folio charged to the dirty counters
+ * @folio: folio to query
+ *
+ * Use this rather than folio_nr_pages() when moving or discharging a folio's dirty
+ * accounting, as a folio is not necessarily charged for all of its pages.  Walks
+ * per-block state that truncation frees, so the caller must hold the folio lock.
+ *
+ * Return: the whole folio for the usual per-folio accounting, otherwise only the
+ * pages holding a dirty block, and zero once those have been discharged.
+ */
+long folio_accounted_dirty_pages(struct folio *folio)
+{
+	struct address_space *mapping = folio->mapping;
+
+	if (mapping && mapping_dirty_per_block(mapping) && folio->private &&
+	    mapping->a_ops->accounted_dirty_pages)
+		return mapping->a_ops->accounted_dirty_pages(folio);
+	return folio_nr_pages(folio);
+}
+
 /*
  * Helper function for deaccounting dirty page without writeback.
  *
  */
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 {
-	long nr = folio_nr_pages(folio);
+	/*
+	 * Discharge exactly what was charged; zero if the fs already did it.
+	 * Counters below mirror folio_account_dirtied().
+	 */
+	long nr = folio_accounted_dirty_pages(folio);
+
+	if (!nr)
+		return;
 
 	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
 	if (folio_test_dropbehind(folio))
@@ -2661,7 +2696,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  * try_to_free_buffers() to fail.
  */
 void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
-			     int warn)
+			     int warn, bool accounted)
 {
 	unsigned long flags;
 
@@ -2674,7 +2709,7 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
 	xa_lock_irqsave(&mapping->i_pages, flags);
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
-		folio_account_dirtied(folio, mapping);
+		folio_account_dirtied(folio, mapping, accounted);
 		__xa_set_mark(&mapping->i_pages, folio->index,
 			      PAGECACHE_TAG_DIRTY);
 	}
@@ -2700,12 +2735,13 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
  * simply hold the folio lock, but e.g. zap_pte_range() calls with the
  * folio mapped and the pte lock held, which also locks out truncation.
  */
-bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
+bool __filemap_dirty_folio(struct address_space *mapping, struct folio *folio,
+		bool accounted)
 {
 	if (folio_test_set_dirty(folio))
 		return false;
 
-	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
+	__folio_mark_dirty(folio, mapping, !folio_test_private(folio), accounted);
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
@@ -2713,6 +2749,12 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	}
 	return true;
 }
+EXPORT_SYMBOL_GPL(__filemap_dirty_folio);
+
+bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
+{
+	return __filemap_dirty_folio(mapping, folio, false);
+}
 EXPORT_SYMBOL(filemap_dirty_folio);
 
 /**
@@ -2912,12 +2954,21 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 */
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 		if (folio_test_clear_dirty(folio)) {
-			long nr = folio_nr_pages(folio);
-			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-			if (folio_test_dropbehind(folio))
-				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
-			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			/*
+			 * Per-block folios keep their dirty bits, and the charge,
+			 * until the fs writes them back.  Folios of such a mapping
+			 * that never got per-block state were charged whole, so
+			 * they discharge here as usual.
+			 */
+			if (!mapping_dirty_per_block(mapping) || !folio->private) {
+				long nr = folio_nr_pages(folio);
+
+				lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+				if (folio_test_dropbehind(folio))
+					wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
+				zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
+				wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			}
 			ret = true;
 		}
 		unlocked_inode_to_wb_end(inode, &cookie);
-- 
2.50.1




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico





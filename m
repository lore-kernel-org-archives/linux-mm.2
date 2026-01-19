Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD8DD2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0291E6B0314; Mon, 19 Jan 2026 18:02:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0080C6B0316; Mon, 19 Jan 2026 18:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56086B0317; Mon, 19 Jan 2026 18:02:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5D766B0314
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:02:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84A2313A75B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:26 +0000 (UTC)
X-FDA: 84350239092.13.4929E9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BEF5A2000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cwpscc+r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863744; a=rsa-sha256;
	cv=none;
	b=5QhpWiOgNb8pvVq0+ykKaoSrta/mU2VFRfAqIb/8MYAOr190n6D0IL5S8tZVYqsR4LKwtJ
	0vGCf4bHT2ATrRGmn+ACZEbhvx4R35C2Zxmcat7PR828kkhQTvc+/bByt1iucEUDG21QQX
	DGKUbQcrCnOdOuyBGbIp+XBjMsOJ5CE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cwpscc+r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttxPGtwt7jmM6c9nkDVBUEHXnIKNk4+FY3J8rzp2QMA=;
	b=dVa886ld3lhDSduWOnavmjEZYr9DuE2THbMdtoz4pUUN1M0ktfN5e9Y7Acyn2QAolGcr1E
	/WSRQ6jHr15//xhd6gZ1B5wpSy771/oL5/NeqW2eH1QSiRYZywRhLLxADsejoLCabVivSf
	NWkBhI+jugbTRfn9tsXm76k9fZbqgj4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D974841A7B;
	Mon, 19 Jan 2026 23:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E383C19424;
	Mon, 19 Jan 2026 23:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863743;
	bh=SnhMKeXWJjdrWLtSbqKw7V4EMXVK/pgfK7VZwhJNF9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cwpscc+r+ZQnX9sK8UbIxMV80FOtiD0YmfSvImeyZ1PRPQH2lLEE20JaD3ObyynTS
	 EGuheGjlkJBQOTWpsnYX+6heM102tLpDu6hT5riS/StPirtxFNFhQIt+gXzAzu7kUT
	 Uzc4AuZlWiPVtXJnQFd63BCCJMA5kq3Amhls8qWKE7JNdROfRWhZztXHKUFcrYZNRw
	 cVB+zSGrii6PulRMvxLEhh/ZRNUvVNnIvhFuWUFz+Uvo0liKLJgMoJUzmbMyXFccU9
	 /FyQCbCpzZq84lBXHcsEEz5XJxyaDrhzSquDZ/IjDQFhLnqPjvyS+ROF1QKGZ/ITAv
	 Bphv7kbjcZ1ew==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 06/24] mm/balloon_compaction: centralize adjust_managed_page_count() handling
Date: Tue, 20 Jan 2026 00:01:14 +0100
Message-ID: <20260119230133.3551867-7-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9g9pgagfr3ej8p6ukwkgifgm8jdw5zox
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BEF5A2000B
X-HE-Tag: 1768863744-735878
X-HE-Meta: U2FsdGVkX191WONXkcF/ze4F/9bU30pV4Vf31Mr89AbjsfsmBVz9Phcgg8eZY/aRK0CCKoW0ogTcJ0RJ+Xh0RlHCjWaZBI5QS/Kw9A397XjGDYBVuTLnBJMTCNE6oOq2GKSDaZi4UJnPBSTVLN74QA2jp9120KO2sQ4GyYD+R6MBiHUB7s/1vZTo0hxcWk3D48ztj8fy9naPhTSolOqcwpPfWYG7ZKpLPySAAeNtu9lDH84W03KuYVUp9k7FCxGGJcJtLVJ+HIEdv+ZlGmJ/71nLjdjaC3jrfbi2WyX2YihJF5UtYcMy5NAzaU1nBH2qk4o1iG0sBKACwPqQQSQeke1JIXxhPVzS/s61irNwcop+0vWCBJj4AlR7mdwnwG0pHjdqO59UZ4/ovUreWx/zpcpu/+9RpupLSpSZZ97LholsbKQRGEi+PXCU/cWU9jRHyhQPXdxDXKKtFbml/wuFX6NbWIV/gNf23x7bI7vV+1JYJlIfalI5Fu6H2Dd8y2YM/m/JUuDHjQzSv5OnPSv8b/mEnonVzNtOkszNimNB/6aFAc7f2cpTe0u+Z9SamCZ3SnZJHKdkU25INYxzHMXGtrm69OIXqNIHDYzC3r/NetLWJOhLRFMkhEDWBcUppS1DzVk32nvn3qx2OVByZhvY4ohHLngotW2NHK/P/OakqqDC1vgdNZauqatB73ERNXtM7fag7vaMR10YZNObgsgcqevWxf375RkclLTtW8gDMs9VQa6rkCB/qQjKdp1E712BtGKL62UUK1BvsGfEu5cWzYtzuISPxcB75dDltHydUVXArFgV7umfOoQqzIIyl5nBCVHuuKE6saFAZgmv8uFfDzfbsz9ogu3SPHtQy0vOfRi22Yp867OcD9Z4YVkcADyBFNc4iNjUzapJ9/DDL5ALLM8Uhwp+4Hi2umXzkqqcjinfW46C4rJCV9KseArGllfG8+/6s1F81BujClTGPzT
 jH713vVN
 1Qs41/C0xHFp2znRNYVTCyom6b5br9nKEpzXiB6rnW2xUb+7GxywcBsQG0FDeHLS34YFcP9JXdi6BxFcyZGb4qcCNs1lmM0wpGAxMyKzbUMdGu+M4NM7JzbpFsftXQrNQQvqrNFmTx0q4FKf0IDtxasCUBd64ftd5lPfrqUrdwAclbfVjPeVXxEWaRnWpxenBf1V+PDfcdsez83GwjyqAJl+xitMTU/CFErEH4BwgJ7M5gR/W6Gn+ZHUWJ18MPkpLsvmZSDLduqE9p/gEbfw5CEkLtLBN6GFxH8N+f1mdM/vY/B3Z5q1toPxQRhVO30R38kVo78Iet9P3hKQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's centralize it, by allowing for the driver to enable this handling
through a new flag (bool for now) in the balloon device info.

Note that we now adjust the counter when adding/removing a page into the
balloon list: when removing a page to deflate it, it will now happen
before the driver communicated with hypervisor, not afterwards.

This shouldn't make a difference in practice.

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/powerpc/platforms/pseries/cmm.c | 13 +------------
 drivers/virtio/virtio_balloon.c      | 19 ++-----------------
 include/linux/balloon_compaction.h   |  2 ++
 mm/balloon_compaction.c              | 17 +++++++++++++++++
 4 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 15f873f733a41..7fd8b3d7e7637 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -165,7 +165,6 @@ static long cmm_alloc_pages(long nr)
 
 		balloon_page_enqueue(&b_dev_info, page);
 		atomic_long_inc(&loaned_pages);
-		adjust_managed_page_count(page, -1);
 		nr--;
 	}
 
@@ -190,7 +189,6 @@ static long cmm_free_pages(long nr)
 		if (!page)
 			break;
 		plpar_page_set_active(page);
-		adjust_managed_page_count(page, 1);
 		__free_page(page);
 		atomic_long_dec(&loaned_pages);
 		nr--;
@@ -515,16 +513,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 		return -EBUSY;
 	}
 
-	/*
-	 * When we migrate a page to a different zone, we have to fixup the
-	 * count of both involved zones as we adjusted the managed page count
-	 * when inflating.
-	 */
-	if (page_zone(page) != page_zone(newpage)) {
-		adjust_managed_page_count(page, 1);
-		adjust_managed_page_count(newpage, -1);
-	}
-
 	/*
 	 * activate/"deflate" the old page. We ignore any errors just like the
 	 * other callers.
@@ -551,6 +539,7 @@ static int cmm_init(void)
 		return -EOPNOTSUPP;
 
 	balloon_devinfo_init(&b_dev_info);
+	b_dev_info.adjust_managed_page_count = true;
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
 		b_dev_info.migratepage = cmm_migratepage;
 
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index df2756c071dae..15c1cf5fd249c 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -274,9 +274,6 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 
 		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
 		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
-		if (!virtio_has_feature(vb->vdev,
-					VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
-			adjust_managed_page_count(page, -1);
 		vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE;
 	}
 
@@ -295,9 +292,6 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 	struct page *page, *next;
 
 	list_for_each_entry_safe(page, next, pages, lru) {
-		if (!virtio_has_feature(vb->vdev,
-					VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
-			adjust_managed_page_count(page, 1);
 		list_del(&page->lru);
 		put_page(page); /* balloon reference */
 	}
@@ -839,17 +833,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	if (!mutex_trylock(&vb->balloon_lock))
 		return -EAGAIN;
 
-	/*
-	  * When we migrate a page to a different zone and adjusted the
-	  * managed page count when inflating, we have to fixup the count of
-	  * both involved zones.
-	  */
-	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM) &&
-	    page_zone(page) != page_zone(newpage)) {
-		adjust_managed_page_count(page, 1);
-		adjust_managed_page_count(newpage, -1);
-	}
-
 	/* balloon's page migration 1st step  -- inflate "newpage" */
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb, vb->pfns, newpage);
@@ -958,6 +941,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	if (err)
 		goto out_free_vb;
 
+	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+		vb->vb_dev_info.adjust_managed_page_count = true;
 #ifdef CONFIG_BALLOON_COMPACTION
 	vb->vb_dev_info.migratepage = virtballoon_migratepage;
 #endif
diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 7cfe48769239e..3109d3c43d306 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -56,6 +56,7 @@ struct balloon_dev_info {
 	struct list_head pages;		/* Pages enqueued & handled to Host */
 	int (*migratepage)(struct balloon_dev_info *, struct page *newpage,
 			struct page *page, enum migrate_mode mode);
+	bool adjust_managed_page_count;
 };
 
 extern struct page *balloon_page_alloc(void);
@@ -73,6 +74,7 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 	spin_lock_init(&balloon->pages_lock);
 	INIT_LIST_HEAD(&balloon->pages);
 	balloon->migratepage = NULL;
+	balloon->adjust_managed_page_count = false;
 }
 
 #ifdef CONFIG_BALLOON_COMPACTION
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 764fa25dc4bd1..4fe2a0cff69ec 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -23,6 +23,8 @@ static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 	BUG_ON(!trylock_page(page));
 	balloon_page_insert(b_dev_info, page);
 	unlock_page(page);
+	if (b_dev_info->adjust_managed_page_count)
+		adjust_managed_page_count(page, -1);
 	__count_vm_event(BALLOON_INFLATE);
 	inc_node_page_state(page, NR_BALLOON_PAGES);
 }
@@ -95,6 +97,8 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 			continue;
 
 		list_del(&page->lru);
+		if (b_dev_info->adjust_managed_page_count)
+			adjust_managed_page_count(page, 1);
 		balloon_page_finalize(page);
 		__count_vm_event(BALLOON_DEFLATE);
 		list_add(&page->lru, pages);
@@ -264,9 +268,22 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 		get_page(newpage);
 		balloon_page_insert(b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
+
+		if (b_dev_info->adjust_managed_page_count &&
+		    page_zone(page) != page_zone(newpage)) {
+			/*
+			 * When we migrate a page to a different zone we
+			 * have to fixup the count of both involved zones.
+			 */
+			adjust_managed_page_count(page, 1);
+			adjust_managed_page_count(newpage, -1);
+		}
 	} else {
 		/* Old page was deflated but new page not inflated. */
 		__count_vm_event(BALLOON_DEFLATE);
+
+		if (b_dev_info->adjust_managed_page_count)
+			adjust_managed_page_count(page, 1);
 	}
 
 	b_dev_info->isolated_pages--;
-- 
2.52.0



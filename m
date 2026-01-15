Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BB5D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550D46B0093; Thu, 15 Jan 2026 04:21:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FED36B0095; Thu, 15 Jan 2026 04:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405BD6B0096; Thu, 15 Jan 2026 04:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 316CA6B0093
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C517A139FAC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:01 +0000 (UTC)
X-FDA: 84333653922.29.A4AFEBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 236C1140009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I1aAQlLm;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468860; a=rsa-sha256;
	cv=none;
	b=CRWo1X7wd58JZnXuOElQch6bbls4mc4640707MmJ0FIlTSP1wkr/hs8vZlyeM0USn258Ta
	jUlRJyiFRxDcr4tsjPdrbbbWNK5/IiEM+/yKrosINTzjzoqMdqPKhb7hktU8pmf6JFdaKz
	wWFYYTvI4+Z7RBvbwBjd+A23IMf+p2s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I1aAQlLm;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdWjSbIStmKyFpNK166VHXqnHmfhF7faI5EggDX/TWY=;
	b=iCWxb74FtItimrAUp5JiJU0uGNb4ao99WVcGUu2Xa5sbUBIDfFmUnJhrWFXIQ+gc3LzuBl
	tk0fYbFqWGjjZ5RdUQnJoazRUadGQtlVsFYfB/Zm94WO7lm/9MU/2QUui1qdGMlNrLsz4h
	mhDonK6tyBjQ1c4Yd+apP0fAiw0G9X4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CAFD601B4;
	Thu, 15 Jan 2026 09:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D11C116D0;
	Thu, 15 Jan 2026 09:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468859;
	bh=PdUVHGvcMA44CGxVHVjOza1O8qvsgkQWnlz3sIbCXJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1aAQlLmB/ddxTS02O6Gwqsds4e8W1dDtCAZnlVEjjhGUUq13GDM6gkcThI2QiTIe
	 amYV85wji7q92wT3tPLWAVUEcSogqSP+TM4kqclevUbrl9JWbNJIOVXizaC3thUlK5
	 4PFst91uf4/dkWf5oCwkYsG1iV3uaVgTschseOzIggRXL323yssIpdgC6d6NDB4uhB
	 LtXwa5ea+hjPPWx0OPiN7RisqrtDWY0bTLG+3l6NJgeYg3yc1hSiQ3T4bxOEMTOlwr
	 F86Mwn/tnC4ZW6jTH4SeC9PGfkKhAmifRTlFsjzixJHg+WNlzKiY5CVzVlmClWSIRy
	 zbKBzuwVjnYJA==
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
Subject: [PATCH v2 05/23] mm/balloon_compaction: centralize adjust_managed_page_count() handling
Date: Thu, 15 Jan 2026 10:19:55 +0100
Message-ID: <20260115092015.3928975-6-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6gspjd5t93pim4b7upr1ytgsbzn676se
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 236C1140009
X-Rspam-User: 
X-HE-Tag: 1768468859-374963
X-HE-Meta: U2FsdGVkX1+dg0k/5dCeoS/rq9/LeLBJ0Vh83c9lkgfwlRje/1VZYQr0WogE9uz21LAvh/vK9dKL4BkgtX6xACTPDlb/AfkHwYb4jSQRuPOyb81gRVCw0O1TGQtZhJ8NAGvxovH1qqZXKuDE3pHQcway8M9BAoYfl+R9SlVpjhexq1+s0Lp+g3Erh1mJBYC1RzG39r/HY76nN7LbU+O7a4tiXZ0fVRPwFGJM92x9B7o2Lbq5mQodctBJ4VjJlksYvedfkERWGXZZyK4uaqYBTX/m2jm96Ml+f0fSeR6AQsxTsv+LwFKQzx6YpUOCqIzhbwuUhmR1G46j7ESVk0Wt5XgL6DIkkRo6ZtBU8KC7X/KcaOCrewQ0o7d0xdF8HcqHhOSoXwVadnbGKfLU5QdYVuVHj4b4OfiQ+Nm1z0txSyAb0t9OuI6hWt3AreZMEft4wvC9zlmqohrmNPfebwzr4G4RACTsVqTJjwVVojQLIK1qMVQ7yPesUUQyTL8XuOb+e1Ft/vZ38su9GfR/37fM3YW87NPPeR8K/MovzF6Qwfqkir9cyw5GhQhBr3nArz2MrOALGz9/OeDgSVqrYKufciFFwPkJzGFGP3BQLQ/uR57S8HX17dzu56tiE7BLCsc2+parnRDrz9oofBkAjzO3/alFMT4joBN95NQnSZ+I+y83YbZYheiZjeeMkeVwtHTHhcqkuFKwnMm9b30q6zn1uWkIoD+8q5RQDzCScI6Jed+ztrYi6mV3B4h3Cp4MTIFZKDGYul8tVzHIHrYx60s4iL342i8gF4bYEoVz9e4n8YOaoyB5Fj/7e8zTSM5sdgqJIESqqM6R9i9NtGr/Boxwh0XfaUosQkYVGJ9rj25V4W6VH4fetErpLdaOA6bjV4uoLiNna7r1u8JNxCDUe/sXaDhkhl/KZ/ksoKmXBqju4ClKYTaEc9NjXWBQ4d458yahe5ZughDGwMAbMQvRVMY
 suF0Wn8F
 6NX8iEsZ6ke2YqdHAkVNkp/tFhGFBRIRQBL+F8TTeFsLJIb7uN5pOQxa6T7NgmGFRqAUwJgmLEgpgc43TlMcE3VeiyqlmH635OCgGSCt0447b1voK6M5aLi7BvYNgfWQg6H9S/Tn/KWAlVLWVa/nvXEnQFjc0qubfpwom1nYm78kIXn4Siap931an0DVAF2x1QtNuBqMepzCKxXhCt8qNoTRe89Jq9h/egwADZ+o2wEUEZSpbFVophuyZGCFlOk91XaMH9AIkQLoWL6NfTB48EXr2Qg==
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
index 5444c61bb9e76..fd9ec47cf4670 100644
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
@@ -256,12 +260,25 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 
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
 		break;
 	case -ENOENT:
 		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 
 		/* Old page was deflated but new page not inflated. */
 		__count_vm_event(BALLOON_DEFLATE);
+
+		if (b_dev_info->adjust_managed_page_count)
+			adjust_managed_page_count(page, 1);
 		break;
 	default:
 		return rc;
-- 
2.52.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEB8D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC4B6B0092; Thu, 15 Jan 2026 04:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7806B0093; Thu, 15 Jan 2026 04:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1FC76B0095; Thu, 15 Jan 2026 04:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCB906B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:20:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 710E0139E7D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:55 +0000 (UTC)
X-FDA: 84333653670.23.4F55F15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A874520008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:20:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mr92APs5;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqPha+TFocKTwBNrjPpsK2xBYViVutTf7zNnk6SHeSY=;
	b=o2LwmPUazCTWz/aHsUHRHQ+wqoFX1Pw3E9iKmjcBMDW0l6wngf3ixOqJQT9AeAI9yeDmjq
	Az1yagVASZgbcgNuN3EZWsoER5A5JMAvEcbYPBrLX7nc+n1OHjGm5/A2HPSkYHBoYUQ07R
	NP4pvvh34E3lD2eaZ4O0UuVDAVkiG1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468853; a=rsa-sha256;
	cv=none;
	b=pIKbdQksmaMZVe2GaYEBhCCAjqD/nmFQqA6SFGzMNtIvNUcJu/qmLna/rs4e8z4zMwgExR
	oD60d5QiBUlrwm2VOnMaATk7hYtsiF3d5cyUgRcSkHPJ0xObeYAawcwpmcYEZrPwFgs3gy
	MAK/J+YN0DsX0poQYuBaQELVXhFIQak=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mr92APs5;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 992D043FC7;
	Thu, 15 Jan 2026 09:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A1CC116D0;
	Thu, 15 Jan 2026 09:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468852;
	bh=w4KcHLR+BH8XcJwxxcNytMND/0cbiSTTskBUX/GwE2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mr92APs5Utiee9xvMBLboUUTDgM0ap0b5FPXynhnef271Ip7h1Y0U7ViG/f/yERpz
	 grC7h7iFLv7vSBxlDgzUvpHtw4xj/FB8+Q2m0ytRi9uVgqtrEtfCKxSnrLukHF9Gh8
	 LY7hCQRU+XGBRFqvQ7x4opgkMp+KEWTpBWnZx+xcsns1RavhWR5feNPh6OmKfNALn/
	 vhqH7OGIpuNY18FGFgnDnPHMAilbZSoxLfAvZ+stEdCBuXqIE4+mUF1ulfKBea8RBA
	 hklYllWA2Hibwj7VZ7fctrerV/2Ula+CedMaEvanTiCpeXX1yf5iXU28VO4TRw+16w
	 AEFeqZbVyZYvg==
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
Subject: [PATCH v2 04/23] mm/balloon_compaction: centralize basic page migration handling
Date: Thu, 15 Jan 2026 10:19:54 +0100
Message-ID: <20260115092015.3928975-5-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A874520008
X-Rspam-User: 
X-Stat-Signature: qiqgwk9hnayjkp64ozjz3nsbcpcczc57
X-HE-Tag: 1768468853-928319
X-HE-Meta: U2FsdGVkX1/L2hM1Yd9BHirku2yWrilnxUrjpVJuHTKAOG7yxHVhS76HvnakwHldyEYuptTh5AWb5r18bnekT+exstY68StTW1TUd+rs/V5fG5tlXc5Y+FXBNyXJmKZwZr+9X4RDGRoYZJfsFdf14dhICC1M3fl9ILN1vW9mRMYDCUFyI9ge7GOai4vfzF6dUcYQUoYrKoUApsRE4kA3iRxffEdG4cC4DMywCFCNHChpOE/IPZnNOJUVDDE627u82uNrmcCzxO2c79RMbIG/HSLPVNOsncT9l/fcccpQ/YzpgKyvcIL4xWm3NjNZFIITYjf+taAxVL2wSrxaJeEVeJnj5Ejrwok69WSE4/ADNrzCdrJG4nZKJPEimRUcuZ2NkChZE71SyyW/VWT6Oj9br+MQYsHZe16lqOFWYkrPZL02kPr6BGZHtC6+BA/cvNTbzaeQtCnymPPk1Z7Nv0lq+xPIJx5lszlCCajjz6Q16Wp1ObYpj7InxObJknMpMPdHrJHYRw9YrEKpwU/EQdDYzJin8d5i43VZBCcx3AJenK4RczLgH5hQ2SFRcbjqcE3he5Fmt3f43hkBo5I2Oy1k7zFKhTj4XBNLrRq96vl5WLrxgmYVbZF6qi8MxcvzMcudccmr+k5UpkTZW1lW7BUqm78NrlpLJsGXibD3ZPUC5nrXdtnhF+lSprNOzKuHlZhcH57SWN9hYq9zjJS9qFhWbkJahmfKRpJJ5LjL9fknFeL0Fr64xYKUH2xIw4I9eCNMpsuTO6qO6QpeqJBBUquV4+OZZjGorje6WNdTuZN53Tv/1J4WT+yyoxwo/55fxSYs3ys11Dz8KEc+uQdQy0WgZFzDJL70w3eTbDyUT6s4xRlI8kqpOc8BHLKnNA7oZ8DFE4RtawOOXkFp5MWBx3hNQ1DO/qgsSxP+4m+08+DarRP8vFoI7PeBNR2T/PlkoYbLSoak1jFXd9kcgUNm2xs
 E6v8YqHl
 ayxdFoP2w+KxbUyPjhkXNoy2uIe4XkigCtKtjnt6pI0eJ/qev4hOE0Zo0S4OYRyN7gqkyCa5HGpEitYXRqF0Fuzo5TlxI5cT+xeUjavSd3pziebOnlViJVdkc2EKQm7u2XaaBckfdGGZTr/CkQ0ztXbmFMxgdgV1FYhLsi0hqlx5++ZOj/ZfoHkE4+rbuNoUdZHDAzY+m/GcCjWlfi/1sNpP5PaFuISwOknTK6Ckpr4WVGVwsaBQgtY0/pX/MrwVzHfV3FxUR/FnPy0a2Kz7CeApmJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's update the balloon page references, the balloon page list, the
BALLOON_MIGRATE counter and the isolated-pages counter in
balloon_page_migrate(), after letting the balloon->migratepage()
callback deal with the actual inflation+deflation.

Note that we now perform the balloon list modifications outside of any
implementation-specific locks: which is fine, there is nothing special
about these page actions that the lock would be protecting.

The old page is already no longer in the list (isolated) and the new page
is not yet in the list.

Let's use -ENOENT to communicate the special "inflation of new page
failed after already deflating the old page" to balloon_page_migrate() so
it can handle it accordingly.

While at it, rename balloon->b_dev_info to make it match the other
functions. Also, drop the comment above balloon_page_migrate(), which
seems unnecessary.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/powerpc/platforms/pseries/cmm.c | 16 ---------
 drivers/misc/vmw_balloon.c           | 49 +++++-----------------------
 drivers/virtio/virtio_balloon.c      | 12 -------
 mm/balloon_compaction.c              | 37 ++++++++++++++++++---
 4 files changed, 41 insertions(+), 73 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 9a6efbc80d2ad..15f873f733a41 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -501,8 +501,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 			   struct page *newpage, struct page *page,
 			   enum migrate_mode mode)
 {
-	unsigned long flags;
-
 	/*
 	 * loan/"inflate" the newpage first.
 	 *
@@ -517,9 +515,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 		return -EBUSY;
 	}
 
-	/* balloon page list reference */
-	get_page(newpage);
-
 	/*
 	 * When we migrate a page to a different zone, we have to fixup the
 	 * count of both involved zones as we adjusted the managed page count
@@ -530,22 +525,11 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 		adjust_managed_page_count(newpage, -1);
 	}
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
-	balloon_page_insert(b_dev_info, newpage);
-	__count_vm_event(BALLOON_MIGRATE);
-	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
-
 	/*
 	 * activate/"deflate" the old page. We ignore any errors just like the
 	 * other callers.
 	 */
 	plpar_page_set_active(page);
-
-	balloon_page_finalize(page);
-	/* balloon page list reference */
-	put_page(page);
-
 	return 0;
 }
 #else /* CONFIG_BALLOON_COMPACTION */
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 07e60a4b846aa..52b8c0f1eead7 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1724,18 +1724,17 @@ static inline void vmballoon_debugfs_exit(struct vmballoon *b)
  * @page: a ballooned page that should be migrated.
  * @mode: migration mode, ignored.
  *
- * This function is really open-coded, but that is according to the interface
- * that balloon_compaction provides.
- *
  * Return: zero on success, -EAGAIN when migration cannot be performed
- *	   momentarily, and -EBUSY if migration failed and should be retried
- *	   with that specific page.
+ *	   momentarily, -EBUSY if migration failed and should be retried
+ *	   with that specific page, and -ENOENT when deflating @page
+ *	   succeeded but inflating @newpage failed, effectively deflating
+ *	   the balloon.
  */
 static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 				 struct page *newpage, struct page *page,
 				 enum migrate_mode mode)
 {
-	unsigned long status, flags;
+	unsigned long status;
 	struct vmballoon *b;
 	int ret = 0;
 
@@ -1773,14 +1772,6 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 		goto out_unlock;
 	}
 
-	/*
-	 * The page is isolated, so it is safe to delete it without holding
-	 * @pages_lock . We keep holding @comm_lock since we will need it in a
-	 * second.
-	 */
-	balloon_page_finalize(page);
-	put_page(page);
-
 	/* Inflate */
 	vmballoon_add_page(b, 0, newpage);
 	status = vmballoon_lock_op(b, 1, VMW_BALLOON_4K_PAGE,
@@ -1799,36 +1790,12 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 		 * change.
 		 */
 		atomic64_dec(&b->size);
-	} else {
 		/*
-		 * Success. Take a reference for the page, and we will add it to
-		 * the list after acquiring the lock.
+		 * Tell the core that we're deflating the old page and don't
+		 * need the new page.
 		 */
-		get_page(newpage);
-	}
-
-	/* Update the balloon list under the @pages_lock */
-	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
-
-	/*
-	 * On inflation success, we already took a reference for the @newpage.
-	 * If we succeed just insert it to the list and update the statistics
-	 * under the lock.
-	 */
-	if (status == VMW_BALLOON_SUCCESS) {
-		balloon_page_insert(&b->b_dev_info, newpage);
-		__count_vm_event(BALLOON_MIGRATE);
-	} else {
-		__count_vm_event(BALLOON_DEFLATE);
+		ret = -ENOENT;
 	}
-
-	/*
-	 * We deflated successfully, so regardless to the inflation success, we
-	 * need to reduce the number of isolated_pages.
-	 */
-	b->b_dev_info.isolated_pages--;
-	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
-
 out_unlock:
 	up_read(&b->conf_sem);
 	return ret;
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 74fe59f5a78c6..df2756c071dae 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -827,7 +827,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 {
 	struct virtio_balloon *vb = container_of(vb_dev_info,
 			struct virtio_balloon, vb_dev_info);
-	unsigned long flags;
 
 	/*
 	 * In order to avoid lock contention while migrating pages concurrently
@@ -840,8 +839,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	if (!mutex_trylock(&vb->balloon_lock))
 		return -EAGAIN;
 
-	get_page(newpage); /* balloon reference */
-
 	/*
 	  * When we migrate a page to a different zone and adjusted the
 	  * managed page count when inflating, we have to fixup the count of
@@ -854,11 +851,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	}
 
 	/* balloon's page migration 1st step  -- inflate "newpage" */
-	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
-	balloon_page_insert(vb_dev_info, newpage);
-	vb_dev_info->isolated_pages--;
-	__count_vm_event(BALLOON_MIGRATE);
-	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb, vb->pfns, newpage);
 	tell_host(vb, vb->inflate_vq);
@@ -869,10 +861,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	tell_host(vb, vb->deflate_vq);
 
 	mutex_unlock(&vb->balloon_lock);
-
-	balloon_page_finalize(page);
-	put_page(page); /* balloon reference */
-
 	return 0;
 }
 #endif /* CONFIG_BALLOON_COMPACTION */
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 03c5dbabb1565..5444c61bb9e76 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -232,20 +232,49 @@ static void balloon_page_putback(struct page *page)
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 }
 
-/* move_to_new_page() counterpart for a ballooned page */
 static int balloon_page_migrate(struct page *newpage, struct page *page,
 		enum migrate_mode mode)
 {
-	struct balloon_dev_info *balloon = balloon_page_device(page);
+	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
+	unsigned long flags;
+	int rc;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	/* Isolated balloon pages cannot get deflated. */
-	if (WARN_ON_ONCE(!balloon))
+	if (WARN_ON_ONCE(!b_dev_info))
 		return -EAGAIN;
 
-	return balloon->migratepage(balloon, newpage, page, mode);
+	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
+	switch (rc) {
+	case 0:
+		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+
+		/* Insert the new page into the balloon list. */
+		get_page(newpage);
+
+		balloon_page_insert(b_dev_info, newpage);
+		__count_vm_event(BALLOON_MIGRATE);
+		break;
+	case -ENOENT:
+		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+
+		/* Old page was deflated but new page not inflated. */
+		__count_vm_event(BALLOON_DEFLATE);
+		break;
+	default:
+		return rc;
+	}
+
+	b_dev_info->isolated_pages--;
+	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+
+	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
+	balloon_page_finalize(page);
+	put_page(page);
+
+	return 0;
 }
 
 const struct movable_operations balloon_mops = {
-- 
2.52.0



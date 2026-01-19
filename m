Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76960D2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA4B6B0312; Mon, 19 Jan 2026 18:02:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8FB6B0314; Mon, 19 Jan 2026 18:02:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8556B0315; Mon, 19 Jan 2026 18:02:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA5E16B0312
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:02:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 879C41602F1
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:19 +0000 (UTC)
X-FDA: 84350238798.20.E49F28F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6116C0005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0Tp7C+Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863738; a=rsa-sha256;
	cv=none;
	b=2W8XQqShtA0BcAQ99FgxxLXU+PwJ0Qh2hQnVf8Waq1JfK2dR8DsY/pyedtP9PK1bFOlo2j
	Mtxa+42zDx1+4daasEWPvcY528OumUJLsF5XcR14riWDI7ZSRfZgaEc2+UalI9mGu0FIV8
	5/12g9TMwg8bRIkYU7Dwo7Z2iB2j3K0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0Tp7C+Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+DFFypOC/10qVO8yIib8j/MVIUtdX9QOaobCQ6+bq4=;
	b=wKArPCVx5KDProrS1EUGvswSUQXro/GxLeyd+CJG2q5GRH609Gyx/cICx7QnQr77fTEtVd
	Oc5St0Hc2hMKQL62cq+9NtiDZu385LfEU2t4ZI6WvF03cicpXs7YGtC8Nbijy28gDGXU56
	cWFglAmaWrzYUPuepVvTdLh15XzF8/Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08BDA434EA;
	Mon, 19 Jan 2026 23:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24201C116C6;
	Mon, 19 Jan 2026 23:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863736;
	bh=24p8pe28M/olJp8gPe2KI8fAWybhc5W/Q/2dQB8WznY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0Tp7C+YM+A/uQI/1du9fKf6+JaulSjW6UdekTe82Na5TlGxSOuOiTKnD3PwDOous
	 PXYMwxtHubYDyt9cf3scV8t08VlIVv4mhTg26OY53GrImPwI/atZTPwpPNb0M2FHqE
	 IuoZsEJm81OCwSvJu6hllGNQ/0c4YPN+mfgdwu02cHngSQXSJgQfU+dTCZT6qxlCRa
	 lfr4QlJi9xbT4N1tf9pPnMHnK8uuorGUrTekzGXv91Erq6HSUZJqO2vPp3QIhN3tcg
	 nSDTvOQNKoJ3fOBjWmgV20r9GanLaTbHj5+iTYkNwQqHMk5H5scYu5X/7oFXfbzc10
	 rXloLqGyhC1lQ==
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
Subject: [PATCH v3 05/24] mm/balloon_compaction: centralize basic page migration handling
Date: Tue, 20 Jan 2026 00:01:13 +0100
Message-ID: <20260119230133.3551867-6-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D6116C0005
X-Stat-Signature: nxqhju8zapupbe67rd8niibxm713duur
X-Rspam-User: 
X-HE-Tag: 1768863737-612851
X-HE-Meta: U2FsdGVkX1+Zj/ERcOpTgwgl6j2vwfaKhwIySpf2v1ZbkqTH/j6UhpHCz4bEwdPKqF5F428BjSxTNdS6AofMuEY46qd27/ZrzolKVa6BHAUeC6rjQR69npiUgpL54r+JN6OahSqlOJJfiK9o63tVVppbGuAFvaIWDXEguMEmJReqeeizA/NIu9ooHlpJ5dzexGiBLo6x57D83k9ShebZMHgPObO2w4VaCz2P2m4iHLgqcBC3IiUqONpjl5no6l7IcuXp6m8Z7ISkT2oBqR+/FEHNQ0PMzVIUKUOVmkDtW8qDC5TTUTf/Yt61dTiHb7PnCISUOYkveVfc0zJ/uw2Q0Kqt9fSV+FYkLIrERLZFHvIJaB/0rLcbqRSijynIVboT45AQxs5VWtuQxDARPVQURl8ZY97jcDE+HB8HLdIsiqrWq/rnrdRYpsbqbnwN1yWWEvPxLQJr2WNGneuHOsfZxAQ2cZrZfvB0bWr0pgEyZBmbhp6f4+YYGoHEyWAXbuZS75dME6brJnLgFYGA1Ij4aelNK59zHg82ypPhp3U7xGiICPoJ3VpjBEd8Is5agxmezWI2r4RjdPCGxFR4eVmYMVC8rTUeycW6uTJwn0gNIvo51bdndkJg8GBnIs5hAqxJtI1RAO5RfmmsuwkuczfFpgShroyMlsk5foYUv1+7SCjhHID+Xib3aROJPG+THLHjZ3eh9Bwr5MS/LBksJrK4k6sY7sBnp1IpLphLw3nktrpdGk+Nrg9JNJTg5PKxtOKL7HFlv3S5M0WSuY0h3LPd90O5flR8/BSDaU0TtKmEeOJR3hOYln1nm50wFZe88zWf+Y4Ux+daXpe2cTls44JG5MLn624AoDTj156PQv1D4JGCr7oTqsoJOuoHKTjiaAMzXs2QyhqDbQbDjWqO02byPGoxKSmyx/jJCotjQM3a0ABQTk7WclRdIDrAsZSkn55ujgm5k2E4aK2GOfN581A
 gyKrTRpJ
 ASlu8ZzEYEe4bzwWtzTou5uu/by4Re2oArLSAsPOC3Yoo4x7JTczqTZKvpJ4xlDJHAah1upEO9SZJno1K3uUopvXfmSPoXiKiFiJiJaa8RZsebcDz2zC8XKFqgyXKE73WgovRPSyFDP0rfVtI2izW57iGl2MCsT1DyTCLPTHs3onAmffkModbmjmoZiQwJBsOYUgOg+GyBLxYnN/hYf71kWCnYrYk1rCZ1pyYRkWT0SJZuOloWz67vDGn6AMYfdngu2sH0Vzh6inUctTgRBTKIP3z5oqQpO0F0Jup7pRY6jp4GEK9wqVrEsV1FQ==
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

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/powerpc/platforms/pseries/cmm.c | 16 ---------
 drivers/misc/vmw_balloon.c           | 49 +++++-----------------------
 drivers/virtio/virtio_balloon.c      | 12 -------
 mm/balloon_compaction.c              | 31 +++++++++++++++---
 4 files changed, 35 insertions(+), 73 deletions(-)

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
index 85eea88cea083..764fa25dc4bd1 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -236,11 +236,12 @@ static void balloon_page_putback(struct page *page)
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
@@ -250,10 +251,32 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	 * device. As isolated balloon pages cannot get deflated, we still have
 	 * a balloon device here.
 	 */
-	if (WARN_ON_ONCE(!balloon))
+	if (WARN_ON_ONCE(!b_dev_info))
 		return -EAGAIN;
 
-	return balloon->migratepage(balloon, newpage, page, mode);
+	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
+	if (rc < 0 && rc != -ENOENT)
+		return rc;
+
+	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	if (!rc) {
+		/* Insert the new page into the balloon list. */
+		get_page(newpage);
+		balloon_page_insert(b_dev_info, newpage);
+		__count_vm_event(BALLOON_MIGRATE);
+	} else {
+		/* Old page was deflated but new page not inflated. */
+		__count_vm_event(BALLOON_DEFLATE);
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



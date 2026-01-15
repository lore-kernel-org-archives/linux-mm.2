Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E714FD41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323D66B0096; Thu, 15 Jan 2026 04:21:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7406B0098; Thu, 15 Jan 2026 04:21:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E056B0099; Thu, 15 Jan 2026 04:21:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1056F6B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:09 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD345C1493
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:08 +0000 (UTC)
X-FDA: 84333654216.03.FAC6723
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0740940003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXLQM63O;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhmI/YXbXaD8EQlnB7HumxCi6p4qAIdlRnQBD0SBVO0=;
	b=DSSBp7UsDqdzklSYgohiQaiXjfDj73wR2gUk9D7/r3lcRW1zMLQ4sy/g203FEwNTt9erQ+
	xp3Prcfrp96tYBwwjnHkt/e0D5pjJxnGpw2KJEXyAbpCg9PhJwamL2xepXGp4DYAsx8bvH
	KvGqMQA/ZUaGvaXA8e/MBNGV7rioJsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468867; a=rsa-sha256;
	cv=none;
	b=tbewKhcPm9jKUK6ycYo9rxcgz7OYUYd5TbfEKgjDbph2R8kA/1i3Zkt5cAgl5jUb1vlu3O
	sDZMA9MGHjHLy/FXpL/P/HrT7bnhlydS/AkwCaEzon+wMsMr4RPc4Kze6KFXSWyFzykqWc
	ic1+O2WSw4LISjyu4IpbGjqdxXtRCr8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXLQM63O;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 292D440867;
	Thu, 15 Jan 2026 09:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD927C116D0;
	Thu, 15 Jan 2026 09:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468866;
	bh=q+Q0Uz5/ogC154Dbd2goOOehqbQ7Ij08x/c47bAW3yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXLQM63OvUIAXjYM+1gJ3tSen1quB36s7/mPz09KWLc8uyMyUjvkG+5++fUqmVxEC
	 Ykn9RLJBfr+XLAQCzsxuqPR3iFk2NH5/VUlGWjrSQvbN6yRv6MdW+RPqgfBGTpbb7s
	 yNUtgwNE0o8ISZJVBv0oWmfNnm2mXPLKwkfb9gfxKlvygbG7+Qgtuzt2sunaQRDlew
	 /SjsLbp9llx3T5l3KcqqQxexGe+DtC/i7Rli1miNq1yQYMRLazApEy59dXNa41Y9aj
	 sEY7jrlMhmyPaOGOgRBrG9ePy1z2tZsMKrJJKpCEre3nCdobOpHUefVnVn5mBk6HET
	 ZAoNRBLwYG8TA==
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
Subject: [PATCH v2 06/23] vmw_balloon: stop using the balloon_dev_info lock
Date: Thu, 15 Jan 2026 10:19:56 +0100
Message-ID: <20260115092015.3928975-7-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0740940003
X-Rspam-User: 
X-Stat-Signature: xfsbx95458a37a3oa8rxrdhuqap7a7pw
X-HE-Tag: 1768468866-40417
X-HE-Meta: U2FsdGVkX1/g6iIVHx33C0OxILJMg6KXqOxgr8UsmkI1qqPCNPZYp77+/sm/hs1g+txV+8X3PrA33NUu0smiwsXNyOVZfrUX/zzwp1HTYlwnndTGSUmjvaj5hnh3+yXgw79BM5iNhd1dMgkbZuB+ItlcZZFlXfsdYm/A2jVIaw69TfwZUVDKvwBCxaSRCgX3npWjRe1E2GjG7jYhw/6oVUsQ9aZrFrItgb5/mabJ2V1lSr7BqdVF/ya8qD70pw+jy6P87ux2J8GyrH9CvkZtxo4hUZ/1ZpUnAM3zBNk1fJ9pts6djB9pDDwUqqQkrclJnBNSpskC19Yp1ZrcFZ2/l4uwPkRzDmKJw6zwkOAVw/djUktowINEJBMsBi4Pg1j80qDnJzAk5EPI3AA3PA4IBWpfWa+4RtFLrt8BdmuJBy3UAXtTmXdva8N2RjsVGgxP+747fqB6NeXNkSOR5LtG3SRKeNIvf4cx/6Dhe+ofeHaBNCGfWBDrQH4KVOzcPENJ9K7QZ3DRCLjB3j0ydayjZ2NUPq5OreVh36l86QZ15wofq975QeEdXGLFWOZ5UciycxFoCCpHVlnMBXtEcJ71l/DlZSvwOsT8hMxJ6mFCIx+smqu63SL8IfFZKqXJQ6Ts8aRhcAtH0Wef07bUjnFuE2yTnYJdo0TPlFkZb06ugP1eQO3eyI9rC/+y7sP3zd0sxGOOetFQ04gVLT0NWlsaaMrEOrfylnBJ8U5rFQ3ouNDDc25vxMOJdwIAmfNuMSvJlp05yzdj7HuPzsWR69p1dvOV1OGzgEQ2CBv1x8/n8JpXtPWHwGlP8UuSwJAi7tc+8Eo+Dj+yg9DNGvZ35uYT5cUzgVjgAuwDa+TFsQ3vjVBrfM8jQxLwhBq3K9Vatjlc9DjxHS+xJHEono89h6VjZS96Ml9kmFBOSOFKCJldCdm+p8ZGP1z4mzikoqbqWr4lfClY1OXPrdCZ1vtWHBO
 vX3RMFlP
 G1vuanR91pu/RHc2ycWa4I2itZv+r/4e4yum1BICyhldBM91+by1rtN9J3mbH8PMp/FrPp3wIQpU9M1X0O8T/ULctuFimKmkg8FordMBpI05zCVWUijktRtJ53JrVbqFGZCMufKdILAjLegctS7/8NRX/5NdjsfwG+y3HirUfCGMKgE+hZaTfqWI2i/QOhC5W80sMIXplQJth9kNj0wFG3xun77wl42CTu+y3kIymyZg9nRu3lrI6Z3xpvhyu7I+mgNy9GM7nsDCKDlJWstsdnwqNag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's not piggy-back on the existing lock and use a separate lock for the
huge page list. Now that we use a separate lock, there is no need to
disable interrupts, so use the non-irqsave variants.

This is a preparation for changing the locking used to protect
balloon_dev_info.

While at it, talk about "page migration" instead of "page compaction".
We'll change that in core code soon as well.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 drivers/misc/vmw_balloon.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 52b8c0f1eead7..53e9335b6718c 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -354,10 +354,15 @@ struct vmballoon {
 	/**
 	 * @huge_pages - list of the inflated 2MB pages.
 	 *
-	 * Protected by @b_dev_info.pages_lock .
+	 * Protected by @huge_pages_lock.
 	 */
 	struct list_head huge_pages;
 
+	/**
+	 * @huge_pages_lock: lock for the list of inflated 2MB pages.
+	 */
+	spinlock_t huge_pages_lock;
+
 	/**
 	 * @vmci_doorbell.
 	 *
@@ -987,7 +992,6 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 					unsigned int *n_pages,
 					enum vmballoon_page_size_type page_size)
 {
-	unsigned long flags;
 	struct page *page;
 
 	if (page_size == VMW_BALLOON_4K_PAGE) {
@@ -995,9 +999,9 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 	} else {
 		/*
 		 * Keep the huge pages in a local list which is not available
-		 * for the balloon compaction mechanism.
+		 * for the balloon page migration.
 		 */
-		spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
+		spin_lock(&b->huge_pages_lock);
 
 		list_for_each_entry(page, pages, lru) {
 			vmballoon_mark_page_offline(page, VMW_BALLOON_2M_PAGE);
@@ -1006,7 +1010,7 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
 		list_splice_init(pages, &b->huge_pages);
 		__count_vm_events(BALLOON_INFLATE, *n_pages *
 				  vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
-		spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
+		spin_unlock(&b->huge_pages_lock);
 	}
 
 	*n_pages = 0;
@@ -1033,7 +1037,6 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 {
 	struct page *page, *tmp;
 	unsigned int i = 0;
-	unsigned long flags;
 
 	/* In the case of 4k pages, use the compaction infrastructure */
 	if (page_size == VMW_BALLOON_4K_PAGE) {
@@ -1043,7 +1046,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 	}
 
 	/* 2MB pages */
-	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
+	spin_lock(&b->huge_pages_lock);
 	list_for_each_entry_safe(page, tmp, &b->huge_pages, lru) {
 		vmballoon_mark_page_online(page, VMW_BALLOON_2M_PAGE);
 
@@ -1054,7 +1057,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
 
 	__count_vm_events(BALLOON_DEFLATE,
 			  i * vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
-	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
+	spin_unlock(&b->huge_pages_lock);
 	*n_pages = i;
 }
 
@@ -1828,6 +1831,7 @@ static int __init vmballoon_init(void)
 		balloon.b_dev_info.migratepage = vmballoon_migratepage;
 
 	INIT_LIST_HEAD(&balloon.huge_pages);
+	spin_lock_init(&balloon.huge_pages_lock);
 	spin_lock_init(&balloon.comm_lock);
 	init_rwsem(&balloon.conf_sem);
 	balloon.vmci_doorbell = VMCI_INVALID_HANDLE;
-- 
2.52.0



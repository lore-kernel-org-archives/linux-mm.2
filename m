Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCE9D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1806B0088; Thu, 15 Jan 2026 04:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5FD6B00A6; Thu, 15 Jan 2026 04:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1816B00A8; Thu, 15 Jan 2026 04:21:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB5AD6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93219B76EB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:42 +0000 (UTC)
X-FDA: 84333655644.02.12045E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BA95100004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gjHo4SPq;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468901; a=rsa-sha256;
	cv=none;
	b=v6BJnPJIkxEtPd/YUHG5swg+L6AH89saaT16zKZigTBS/+qtDSTtGAAONfpdbRyRpPgBYC
	DDCEXI/BE4TyPgvV9zQl94aThANUmrfpkz3zBm81VXguB5L2+puJnH4uDMhNRvmzDnV9B7
	dj35laJ+vaeixRly1w5ascqxj20PlUo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gjHo4SPq;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yedf5pTsTIH7yZA71uFz0MYlxe8DVcPZiVuQOgyPLN4=;
	b=5/hmNscwFf53OopDZFundPbYJqT0YdnxVvpJwFRAosJashvtpDwtuxZMbac+zfKcpFq7wz
	IEg/wIxFKd9FR4xtjV4XodARHtyi5BqPUIzvFcMfsofABGLFSZp6BosqL+2punhc5NPVEa
	3X81eDpzAEupQXJjQGNKMKRCR+t4CTU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 694F5601B2;
	Thu, 15 Jan 2026 09:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84860C116D0;
	Thu, 15 Jan 2026 09:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468900;
	bh=7Fok2QOLie23GL34zkS9ujQ08CnApW1sZfbHS9ad6qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjHo4SPqXCwAV3VLQdXz/juLHBwZNkzTqrcYtbfYSxBaSvH+n5lb5GZqiD2ycVH9Q
	 TO+0ZInpSdsqpUqW1vje/qktqMIJNqUZasZtMkmbImz/v+3qyrOUvBLbYel/59dZDx
	 CHaY+HvEtsPTc6G7ult2MmEWMmgpWMOvgO+sq9j3mSWbmchbR6+3m1WPyJdO/H1dDr
	 xyP5tNDrUHa5hiq/htOY6d+se+LFPUr2DuRQUibb7RzdR+pFQ8MEF7mIJgiyIz7du9
	 PJ3LVFh7wFYG3SEZEOBq/kYev6Zmqjg9nRgcroBBwNzHwezu+BBiIaey87TRFW5RDP
	 ahbnv9gDliQ9A==
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
Subject: [PATCH v2 11/23] drivers/virtio/virtio_balloon: stop using balloon_page_push/pop()
Date: Thu, 15 Jan 2026 10:20:01 +0100
Message-ID: <20260115092015.3928975-12-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0BA95100004
X-Stat-Signature: krrbixwqkfwnpko7udkkzgcf6yit1tgy
X-Rspam-User: 
X-HE-Tag: 1768468900-808127
X-HE-Meta: U2FsdGVkX1+aR+DJxZMkSWRP3kzKNjchWorsS50EwBTVY1atHP7VkSfr4OVE3/1jI43fXmguzFBy/K9JyNhKKc/KZhwa5071cp0/PaCy+CPrL3973Lp0kHxPLNpqg0VbpYTEvQrifUzbTda3zzu5SJUmkmzFR4nXORTkdKs+phEZ6AY1ldcO99d8uR8lelu5xxyNYhlxg65y5ZjgWxp2bPGdtKHLxNuGqQL1MHh8scuZMhR5dPWi2JtVXUyIc93snnmB+TFILgo+tTvPCPmdMMXqRSmJCyadVpVR62Jxs3HvdxY0+fl77wEow/zv+ztnZWMSfHtm7WDUg/QlB5Ra1BL+PtbRAcRqVr+k3GDrX4TYLFm8c6L8uZ09dFDKPYVpPsASvkLzvXfg2UjDrK4QGO/SieJ0RfYMWRbVHipgh+CfzzVcf4g8pwhBA5MFfqaM1D2z0J6Ie1KBOQpba3v7sTK82RoW2v0I1JC47eu8LxZ8CcOrZzfNEKF1tKYBGD7Im6ajpxNUdrpnnnJ6j63Qpuo9bsYBi68Ox/dUm8J6Vmu+sBUjLfCGOHu4zXPXYqolFpjxGCnsVnGAUTJnaFkrSsNuIEYG6erMeMIV6YxT/BQD5bQqGioX4lCzlfgZG3zXvjB7ILoFJ4jCc0Mf1pC7cOVRP6LX7TM/uR4sDSqfQp/T+5e1w4geP7drp3WZYuuOH5uJomb0juzR/GljbLW8an9c6l/UFcWhW9Bw18O3vNYP/NVdQt9JKN10+ifzjooHjztCNuwemhYhZRm1wKDlNi5FW1O0KXYibc85LhwPaJmiUj2D99I2R45AhATRrLFm5CUSbScDgaBfLnWQraX6GoKay8gDUsXjLwP+3XN8w32VYcuFj6L/+Lny8QSv+oRqc4wT5TN38EMT0hXORNi31uI9bIag3ieghvyG+M9pjHDW6qpFwJoLkwRJg1/L6jWGMw7jgfFoAYwfvLCsPNz
 BzsTMReo
 A6lws637nq84785pxU3BzvUu3K1HlMPjbxPpCFcgN/d6O0Jqe/QSetvKCx92OvVsVSXVt84awcYrCdiWf0stljn7/sxDVue5Eo/FzMyA+HxKqCY3H5BtUcf8XK01WKCVgwHsIZV4XiqJTcE89cKREzVliVsNUY0kyc5iEvi3n48wXQkKrj+lmq90lVkXz6kiKJ7jiqjXWp7eRIb0jGCdz8QvX6daioKn9TVEPIh4zCm7IML7ZQ7mWQmq5/qRff2MczZym91AhlE7Pdv1Wm6qc5dw/Bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's stop using these functions so we can remove them. They look like
belonging to the balloon API for managing the device balloon list when
really they are just simple helpers only used by virtio-balloon.

Let's just inline them and switch to a proper
list_for_each_entry_safe().

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 15c1cf5fd249c..6ae00de78b61b 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -242,8 +242,8 @@ static void set_page_pfns(struct virtio_balloon *vb,
 static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 {
 	unsigned int num_allocated_pages;
+	struct page *page, *next;
 	unsigned int num_pfns;
-	struct page *page;
 	LIST_HEAD(pages);
 
 	/* We can only do one array worth at a time. */
@@ -262,14 +262,15 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 			break;
 		}
 
-		balloon_page_push(&pages, page);
+		list_add(&page->lru, &pages);
 	}
 
 	mutex_lock(&vb->balloon_lock);
 
 	vb->num_pfns = 0;
 
-	while ((page = balloon_page_pop(&pages))) {
+	list_for_each_entry_safe(page, next, &pages, lru) {
+		list_del(&page->lru);
 		balloon_page_enqueue(&vb->vb_dev_info, page);
 
 		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
@@ -474,15 +475,19 @@ static inline s64 towards_target(struct virtio_balloon *vb)
 static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
 					     unsigned long num_to_return)
 {
-	struct page *page;
-	unsigned long num_returned;
+	unsigned long num_returned = 0;
+	struct page *page, *next;
+
+	if (unlikely(!num_to_return))
+		return 0;
 
 	spin_lock_irq(&vb->free_page_list_lock);
-	for (num_returned = 0; num_returned < num_to_return; num_returned++) {
-		page = balloon_page_pop(&vb->free_page_list);
-		if (!page)
-			break;
+
+	list_for_each_entry_safe(page, next, &vb->free_page_list, lru) {
+		list_del(&page->lru);
 		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		if (++num_returned == num_to_return)
+			break;
 	}
 	vb->num_free_page_blocks -= num_returned;
 	spin_unlock_irq(&vb->free_page_list_lock);
@@ -717,7 +722,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
 		}
 		virtqueue_kick(vq);
 		spin_lock_irq(&vb->free_page_list_lock);
-		balloon_page_push(&vb->free_page_list, page);
+		list_add(&page->lru, &vb->free_page_list);
 		vb->num_free_page_blocks++;
 		spin_unlock_irq(&vb->free_page_list_lock);
 	} else {
-- 
2.52.0



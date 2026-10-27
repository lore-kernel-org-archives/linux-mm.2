Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CBB606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fVKB+kaB
Received: by kanga.kvack.org (Postfix)
	id AF0826B05C1; Mon, 26 Oct 2026 22:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2716B05C2; Mon, 26 Oct 2026 22:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B3C6B05C3; Mon, 26 Oct 2026 22:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0AE6B05C1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:57:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACF7F16092B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:59 +0000 (UTC)
X-FDA: 85366894158.19.949B401
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id AA38B20008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fVKB+kaB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3-BLgag0KCPsnhylqorxjkolqjrrjoh.frpolqx0-ppnydfn.ruj@flex--kevinloughlin.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3-BLgag0KCPsnhylqorxjkolqjrrjoh.frpolqx0-ppnydfn.ruj@flex--kevinloughlin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uOyeoIi9QhKAYiQPs1BFfiuxWbIrsz7kuwNrIhzcWE=;
	b=i9/F2TZmi8B1Dr4dE7HOeglWndbaOmAZjUaWRuZDPmdTin/fiPsOIHfAOnAOuuI4Jcxjvn
	O7EM/NpZ8Ou3p/7PyhaNqrj3vsrWU+yX68BYFlfoAzcNqKkW5LBhuX0LLxvQ+EtNZmJ1pg
	G6Xbgflt+X/JdqbwmJff75nv+I+v86A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fVKB+kaB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3-BLgag0KCPsnhylqorxjkolqjrrjoh.frpolqx0-ppnydfn.ruj@flex--kevinloughlin.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3-BLgag0KCPsnhylqorxjkolqjrrjoh.frpolqx0-ppnydfn.ruj@flex--kevinloughlin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069818;
	b=q8kLQCH/ikuBIPr902dun4cDZW0OHbT1qEVXuTj8oCqCBeliBL0WK190GVtszgdY+oZjlw
	p8zJg6tUlUnXeaCRyp1FTqn+U23pAacAjQVh5nuYoykU5Uj84nqk3uwxJDNLNLVADY39Tu
	A9SeLAg34xMJRdeOab5yBfPt7ljRwJ4=
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-702a3e438dbso3794968eaf.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069817; x=1793674617; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8uOyeoIi9QhKAYiQPs1BFfiuxWbIrsz7kuwNrIhzcWE=;
        b=fVKB+kaBDrWPk+UsXmqkm5PPU8nF2lYFAbz3RVS251WGk5MgQt4l9yma8G7f622qbg
         hDAudoqS0N1AgJUQg1Lv+sRXgqHcoWkg9srmdmaF580z4t++cjpLXXWcdGsiBlPQH32R
         5loynPQeyhiIdl/czIhDATznQokVv9YeLNeHf1nZe9sArFIu5Q+4xwCbzsH18tiBjHGZ
         yEGdo55328EcVAkmmm5bPVi0F9n85R8dne7UQ8RRRs5xAI928iH3aK6T1RmW36wZ4fjY
         A6sC/kK9O4whEWtyb5iqdsUzqA0bhKJfnRb5ti1hEEND7MG5N3urQKg/P/dYhrdBwysO
         DIog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069817; x=1793674617;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uOyeoIi9QhKAYiQPs1BFfiuxWbIrsz7kuwNrIhzcWE=;
        b=UMPqCOrjmjPmHQo8VTqpzOpZvUraebm+Sc/h19DxFToJIut6k1J9dwUzc7SXbHJnh2
         sQRmluAKDaO2muW0KjSc/YO8GcMZm+7kM3TqamhHZNUMrmgFNFR4EesasdIYFFJd2ZMS
         lKURLMViaRFMTW9pbUeDZsnQOQvNNiMiG89QPI8JvL4XKJ07WXRTiLPlALG/Yg0fn8e7
         Y7x/Xhe9z+GLS6/hr84Bim/bN8M++5i/hgdPrgUX/U7pSEkJ2g9kzwK35HfQTqewipV/
         C419Kbnop7Lbf/IOStwz4SM1rb8PaDqG+gjkU2ecaYWQxyw0UOK0vYyL2U5n7clZ93Zq
         vHiw==
X-Forwarded-Encrypted: i=1; AKwUvBxNO4LxMR29azCp8Vqone25r+zfFR01Z7R4WTQKVN2KEZPnWBHPOSNB6XWXLTQ2XOHQbGZ2AzaB5A==@kvack.org
X-Gm-Message-State: AFq9FYJiIGH1wgP6Z0KPeQxJ02EKInc2no+kIPumvAjlTXl+MbPONkY3
	YQEei8Axnn2bbKDYzieIQVuDVEb8xNUhY3cCrMXt83geVBvufzBh5908Ps59IbrFR/7l0Hx9TSD
	eyY0XreoCCDU7uRYVX2r3c2bwFtWjI7QQKg==
X-Received: from iowl9.prod.google.com ([2002:a05:6602:2dc9:b0:9c7:5a74:531d])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:7094:20b0:6d7:aca3:bba9 with SMTP id 006d021491bc7-70ba0e5ee88mr3818249eaf.38.1793069816905;
 Mon, 26 Oct 2026 19:56:56 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:13 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-11-kevinloughlin@google.com>
Subject: [PATCH 10/13] virtio_balloon: add higher-order page inflation
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: AA38B20008
X-Stat-Signature: kcwuxtjubfk8tzn6n5hy8ey1g1i75zi8
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069818-962208
X-HE-Meta: U2FsdGVkX19PLo7W02mTyyOGlXlUBEm1MRDW2+3XCJrrN+/q0Vabi27CeX6D4Uf77dG9eq6dwfOGgmQEh6OHM2i1mMZL4sB6c+HUzWdO4tAhj159ZpUkzeOAa+d43CW3SpHLt+dzYzeiBf81sZUo7BduycokedeCnJmmPmX6hILBE1r0/ysL90ScdHpx7lbP2wF9cBGxC64x0TuANB4+isScc5wvm7wzDlZcLRgIm82rYGJZstl6O6rvwgThAnSmw+Uu4qflGuhU8qEVWEL+L5AyYkKhXLO5MWI3TK5VLVjEQBemPdaqoDS3nJ2/3cWLdJ4GbpWK77pYSfx+1be7P/P3mVe2lY/A1fVsLUFnhNA6eM9JzZ/CyZxt5Z1PRrYtOgk6858+S1HG5naxKBGr5RCsq7DCm1s8O7D162/kdCabqYHhCFFVW9uPkFcP/EpbD7+jlygFFxI2pdHxzdc5jf6+JCH7+uU3d6Xac0me5U6CkbPcqcQOPWqkJjpxmdOnqdDZr/NRmSJKjTOdNIt9O4psSP7O5mRzAX5zEAjqJ8U6fWni0JL6SMQbUYZdl0k9SZOSNrGFVjwx0Ktb7ADAPgipkFcB4lNV11cverTArWUK9OrOkWHROIxwY2G3OR8bh5lUdVj+5j1LaqPn4/pvxAr6klpP3PuvkysXLgqbXwpRmHIVWSr54NKpycKWck05ixJTBXmsY2OuRxc+rxWvnHIQfXmKC07ZkbdHrLJudgNx8ZltsKdQgRT4Q3UCR7tQx7d/vuj+6hpTkuSdS4nndeWYM20Um+0iq++bTySKTa300S5b8ddcJ1A+A6jmPd/hk5UtXcLb6JEdQLx2TyMk2Dji+Se2qaz5agUs3yFTDzGv5Obatf6Jc7tILCsu4WwKZ0l6EpGK66aVsk+amoOboHxQjAdMER/uFpeGCMT4YqlrIzT1IkSSHZmzWuF9RqvFQkUg6wlcUh4BUHlYgdV
 xwa8dlyO
 vCGev2Ev0IbRGGS6+MUyMZFOqg8uzZNZO3XJk/5AYKt9tK3oYtdkOtRv8fc6bdS6oWIeh6yyjnCnzI8pzFg8QuR9ot21L8Pdt67BC1+c7Xy551XFBL71itm3wRGEKlsCiRjm+CENYswKBnvBu0Hlj0DtEhATGqDodx/kW0dXpfEDDgB/gQn3x0OWQHQs2NNuxSftQyVDbgyIl2X2FwbObt9vCSDiA3YGzaoa+TGlbLEjINB7T1G9sWB5FTJpMe8JzovaIwgOTCCRXtiQ1G3t9ibTXnaOt1K98XQcetme2GXFkerfJHALcL06Vwt8dlWJleiu5/z0TUDkGUOGTEvFOguW8z7fjqTSnb0hFCloJF3qWAMZSsHlggP6JlyGeVhaO8BFvVV8B+dQLDeZGFSHgOjwVXaoZTMqcCrPnO3Tls3b9vYr+yZ04aPAGsIpdwfXFOxcnxmCZhD6H/HYJ/RvWYSL01/e9YYnvMn+rxOCOEc+kBWt7YoodVumNXGQRKJUc+RXtyasRVv+blbGGs2Lsyno/krV19eoE4Vat91ua795eXo2OuVQYd9H6c5Djr+h2qy2G0iOYOL5S3/rmZpr80uuvxvYPYYf+r/cQqLtCmStC6V05hfZHtMwPAzNl4lHATNX/kgsJluCylmcRsPc2UNvXZPKND9Z0U//kLf72uVRaO8oymCf9Ij5Pxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In confidential computing guests requiring page state transitions,
unaccepted memory tracking operates at the EFI unaccepted memory unit
granularity (typically 2MB / order 9 on x86). Inflating the balloon
with 4KB pages would prevent unaccepting the backing 2MB unit.

Inflate balloon pages at unaccepted_memory_order() when
virtballoon_cc_needs_state_transition() is true, while retaining
order-0 allocations for non-CoCo guests and CoCo guests that do not
use unaccepted memory transitions. When a higher-order balloon page
spans more 4KB balloon PFNs than VIRTIO_BALLOON_ARRAY_PFNS_MAX (256),
transmit its PFNs to the host in VIRTIO_BALLOON_ARRAY_PFNS_MAX chunks.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/virtio/virtio_balloon.c | 87 ++++++++++++++++++++++++++-------
 include/linux/balloon.h         |  1 +
 mm/balloon.c                    | 67 +++++++++++++++++++------
 3 files changed, 121 insertions(+), 34 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 11f74848fdc4..d162c162b496 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -182,6 +182,13 @@ static void balloon_ack(struct virtqueue *vq)
 	wake_up(&vb->acked);
 }
 
+static inline bool virtballoon_cc_needs_state_transition(void)
+{
+	return IS_ENABLED(CONFIG_UNACCEPTED_MEMORY) &&
+	       cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
+	       has_unaccepted_memory();
+}
+
 static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
 	struct scatterlist sg;
@@ -243,24 +250,49 @@ static void set_page_pfns(struct virtio_balloon *vb,
 					  page_to_balloon_pfn(page) + i);
 }
 
+static void queue_page_pfns(struct virtio_balloon *vb, struct virtqueue *vq,
+			    struct page *page, unsigned int order)
+{
+	unsigned int nr_pages = 1 << order;
+	unsigned int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		set_page_pfns(vb, vb->pfns + vb->num_pfns, page + i);
+		vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE;
+		if (vb->num_pfns == ARRAY_SIZE(vb->pfns)) {
+			tell_host(vb, vq);
+			vb->num_pfns = 0;
+		}
+	}
+}
+
+static inline unsigned int virtballoon_preferred_order(void)
+{
+	if (virtballoon_cc_needs_state_transition())
+		return unaccepted_memory_order();
+	return 0;
+}
+
 static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 {
-	unsigned int num_allocated_pages;
+	unsigned int order = virtballoon_preferred_order();
+	unsigned int page_pfns = (1 << order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
+	unsigned int num_allocated_pages = 0;
 	struct page *page, *next;
 	unsigned int num_pfns;
 	LIST_HEAD(pages);
 
-	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	/* We can only do one array or preferred-order page worth at a time. */
+	num = min(num, max_t(size_t, ARRAY_SIZE(vb->pfns), page_pfns));
 
 	for (num_pfns = 0; num_pfns < num;
-	     num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
-		page = balloon_page_alloc();
+	     num_pfns += page_pfns) {
+		page = balloon_pages_alloc(order);
 
 		if (!page) {
 			dev_info_ratelimited(&vb->vdev->dev,
 					     "Out of puff! Can't get %u pages\n",
-					     VIRTIO_BALLOON_PAGES_PER_PAGE);
+					     page_pfns);
 			/* Sleep for at least 1/5 of a second before retry. */
 			msleep(200);
 			break;
@@ -274,15 +306,17 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 	vb->num_pfns = 0;
 
 	list_for_each_entry_safe(page, next, &pages, lru) {
+		unsigned int page_order = compound_order(page);
+		unsigned int pfns = (1 << page_order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
+
 		list_del(&page->lru);
 		balloon_page_enqueue(&vb->vb_dev_info, page);
 
-		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
-		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
-		vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE;
+		vb->num_pages += pfns;
+		num_allocated_pages += pfns;
+		queue_page_pfns(vb, vb->inflate_vq, page, page_order);
 	}
 
-	num_allocated_pages = vb->num_pfns;
 	/* Did we get any? */
 	if (vb->num_pfns != 0)
 		tell_host(vb, vb->inflate_vq);
@@ -304,28 +338,42 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 
 static unsigned int leak_balloon(struct virtio_balloon *vb, size_t num)
 {
-	unsigned int num_freed_pages;
+	unsigned int order = virtballoon_preferred_order();
+	unsigned int page_pfns = (1 << order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
+	unsigned int num_freed_pages = 0;
 	struct page *page;
 	struct balloon_dev_info *vb_dev_info = &vb->vb_dev_info;
 	LIST_HEAD(pages);
 
-	/* We can only do one array worth at a time. */
-	num = min(num, ARRAY_SIZE(vb->pfns));
+	/* We can only do one array or preferred-order page worth at a time. */
+	num = min(num, max_t(size_t, ARRAY_SIZE(vb->pfns), page_pfns));
 
 	mutex_lock(&vb->balloon_lock);
 	/* We can't release more pages than taken */
 	num = min(num, (size_t)vb->num_pages);
-	for (vb->num_pfns = 0; vb->num_pfns < num;
-	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
+	vb->num_pfns = 0;
+	while (num_freed_pages < num) {
+		unsigned int dequeued_order;
+		unsigned int dequeued_pfns;
+
 		page = balloon_page_dequeue(vb_dev_info);
 		if (!page)
 			break;
-		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
+		dequeued_order = compound_order(page);
+		dequeued_pfns = (1 << dequeued_order) * VIRTIO_BALLOON_PAGES_PER_PAGE;
+
+		if (num_freed_pages + dequeued_pfns > num &&
+		    num_freed_pages > 0) {
+			balloon_page_enqueue(vb_dev_info, page);
+			break;
+		}
+
+		queue_page_pfns(vb, vb->deflate_vq, page, dequeued_order);
 		list_add(&page->lru, &pages);
-		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
+		vb->num_pages -= dequeued_pfns;
+		num_freed_pages += dequeued_pfns;
 	}
 
-	num_freed_pages = vb->num_pfns;
 	/*
 	 * Note that if
 	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
@@ -474,7 +522,8 @@ static inline s64 towards_target(struct virtio_balloon *vb)
 	 * Aligned up to guest page size to avoid inflating and deflating
 	 * balloon endlessly.
 	 */
-	target = ALIGN(num_pages, VIRTIO_BALLOON_PAGES_PER_PAGE);
+	target = ALIGN((s64)num_pages,
+		       VIRTIO_BALLOON_PAGES_PER_PAGE << virtballoon_preferred_order());
 	return target - vb->num_pages;
 }
 
diff --git a/include/linux/balloon.h b/include/linux/balloon.h
index ca5b15150f42..bc46e36b997f 100644
--- a/include/linux/balloon.h
+++ b/include/linux/balloon.h
@@ -58,6 +58,7 @@ struct balloon_dev_info {
 	bool adjust_managed_page_count;
 };
 
+struct page *balloon_pages_alloc(unsigned int order);
 struct page *balloon_page_alloc(void);
 void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 		struct page *page);
diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc6..e9941d08d8e9 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -27,9 +27,12 @@ static DEFINE_SPINLOCK(balloon_pages_lock);
 static void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
 {
+	unsigned int i, nr_pages = 1U << compound_order(page);
+
 	lockdep_assert_held(&balloon_pages_lock);
-	__SetPageOffline(page);
-	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION)) {
+	for (i = 0; i < nr_pages; i++)
+		__SetPageOffline(page + i);
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !PageCompound(page)) {
 		SetPageMovableOps(page);
 		set_page_private(page, (unsigned long)balloon);
 	}
@@ -45,20 +48,31 @@ static void balloon_page_insert(struct balloon_dev_info *balloon,
  */
 static void balloon_page_finalize(struct page *page)
 {
+	unsigned int i, nr_pages = 1U << compound_order(page);
+
 	lockdep_assert_held(&balloon_pages_lock);
-	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !PageCompound(page))
 		set_page_private(page, 0);
-	/* PageOffline is sticky until the page is freed to the buddy. */
+	/*
+	 * PageOffline is sticky on the head page until freed to the buddy,
+	 * which resets the head page's page_type in __free_pages_prepare().
+	 * Clear PageOffline on tail pages here as __free_pages_prepare()
+	 * expects tail pages to have a default page_type.
+	 */
+	for (i = 1; i < nr_pages; i++)
+		__ClearPageOffline(page + i);
 }
 
 static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 				     struct page *page)
 {
+	unsigned int order = compound_order(page);
+
 	balloon_page_insert(b_dev_info, page);
 	if (b_dev_info->adjust_managed_page_count)
-		adjust_managed_page_count(page, -1);
-	__count_vm_event(BALLOON_INFLATE);
-	inc_node_page_state(page, NR_BALLOON_PAGES);
+		adjust_managed_page_count(page, -(1L << order));
+	__count_vm_events(BALLOON_INFLATE, 1UL << order);
+	mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES, 1L << order);
 }
 
 /**
@@ -117,15 +131,18 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 
 	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_for_each_entry_safe(page, tmp, &b_dev_info->pages, lru) {
+		unsigned int order = compound_order(page);
+
 		if (n_pages == n_req_pages)
 			break;
 		list_del(&page->lru);
 		if (b_dev_info->adjust_managed_page_count)
-			adjust_managed_page_count(page, 1);
+			adjust_managed_page_count(page, 1L << order);
 		balloon_page_finalize(page);
-		__count_vm_event(BALLOON_DEFLATE);
+		__count_vm_events(BALLOON_DEFLATE, 1UL << order);
 		list_add(&page->lru, pages);
-		dec_node_page_state(page, NR_BALLOON_PAGES);
+		mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES,
+				    -(1L << order));
 		n_pages++;
 	}
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
@@ -135,8 +152,9 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
 
 /**
- * balloon_page_alloc - allocates a new page for insertion into the balloon
- *			page list.
+ * balloon_pages_alloc - allocates a new page of given order for insertion
+ *			 into the balloon page list.
+ * @order: allocation order
  *
  * Driver must call this function to properly allocate a new balloon page.
  * Driver must call balloon_page_enqueue before definitively removing the page
@@ -144,16 +162,35 @@ EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
  *
  * Return: struct page for the allocated page or NULL on allocation failure.
  */
-struct page *balloon_page_alloc(void)
+struct page *balloon_pages_alloc(unsigned int order)
 {
 	gfp_t gfp_flags = __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
 
-	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
+	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION) && !order)
 		gfp_flags |= GFP_HIGHUSER_MOVABLE;
 	else
 		gfp_flags |= GFP_HIGHUSER;
 
-	return alloc_page(gfp_flags);
+	if (order > 0)
+		gfp_flags |= __GFP_COMP;
+
+	return alloc_pages(gfp_flags, order);
+}
+EXPORT_SYMBOL_GPL(balloon_pages_alloc);
+
+/**
+ * balloon_page_alloc - allocates a new page for insertion into the balloon
+ *			page list.
+ *
+ * Driver must call this function to properly allocate a new balloon page.
+ * Driver must call balloon_page_enqueue before definitively removing the page
+ * from the guest system.
+ *
+ * Return: struct page for the allocated page or NULL on allocation failure.
+ */
+struct page *balloon_page_alloc(void)
+{
+	return balloon_pages_alloc(0);
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-- 
2.56.0.307.g5fe7bd680c-goog



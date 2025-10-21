Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A98CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474968E0032; Tue, 21 Oct 2025 08:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BE38E002F; Tue, 21 Oct 2025 08:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3623D8E0032; Tue, 21 Oct 2025 08:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 225C18E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA84D11A027
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:55 +0000 (UTC)
X-FDA: 84022128750.25.4C5B822
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id AE20B140008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D8vRuqyB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bd8gqizIzdxCBecoKAkM92GzGk5zRQnzgqcXQENTV8k=;
	b=rP0Oq7Lr9xDYLcAKutal7BYn9a/R/NDgkUhKywdLcdJOOSr7aHhK8jDZ8ssI+MI+yuyCWD
	J8DpizO1jMMlnF9ymVZfKGXUam3UsWzI/pm3q9CueLX17vFF6phD1FJwnWkYwPlWprI6se
	Gwfe7k1YYkPDoTZj9Zg+HihHJI3Y+7Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D8vRuqyB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051593; a=rsa-sha256;
	cv=none;
	b=QhimzW48YcxjDLJfg8c7eQ1hPGeL+No01p+Ml+RurhMQ3OfPqO3iRZmyF3bIxz9g1GqKzQ
	Rdd7+aTcX5mlWxZIXZ5bjHDd6FRDmOJ8YeRbH9O876onjdIVDSBUZrQsaC9LpOrEqq2xYM
	7Xi3O8arzzssSdo9ROuYnoXYLYs4/sc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bd8gqizIzdxCBecoKAkM92GzGk5zRQnzgqcXQENTV8k=;
	b=D8vRuqyBmqAmZyATGQat1fG31Vxv+JC1FKqHDgKa8T2+63jsOhk8FlMA9EMDdLy4jvZQPw
	zTSOD5ATMgeupbiWNohOwYg2lLUXekLHaFSfLM/eHAI3cHuDpB+yNbqFlebf2bPwt+6AHK
	aMM6ChLlCj/7W2B0Zrzp8SKWk/masrU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-ilzrfrzkPoii6WvZQXvTGA-1; Tue, 21 Oct 2025 08:59:52 -0400
X-MC-Unique: ilzrfrzkPoii6WvZQXvTGA-1
X-Mimecast-MFC-AGG-ID: ilzrfrzkPoii6WvZQXvTGA_1761051591
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47108163eeaso26924905e9.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051590; x=1761656390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bd8gqizIzdxCBecoKAkM92GzGk5zRQnzgqcXQENTV8k=;
        b=OeQEw3JfCgNW0M9rHFZhZbvMrGk9K7spccyO/PHt7IUqA8/fUueOjb1g2h6cQ62has
         myx01ETBUXtw5JoYafN8FWOM1g2js+B56V7Iy4lURZ0BN1rblXvwY/xRlEntkLLNDuiR
         STfK6tVy5+ftJbGpQ46IFew66b9qSeCDvHr7Yisq4SD57mVe0zezvXu64J5kNrIOOq7D
         wsEF4tapK7r7Ew5+FD751yL/P5dscqhgU5nHnRVPoiPtM4CzVY6CuVcBaoIPzSS6RNIg
         5iotaglzTbnDoKvB04+qQMIo83NDQ3KHhOq/Yjpi60t/3QYfhkCxgmSyFm2j8JkZBTt0
         KDjg==
X-Gm-Message-State: AOJu0Yxs1wxF6DaQO9dDk38+o6YzcYSfo8jow7L0fJL7KE0Y8wBQRv8N
	I12hKnWObWosZUlE6Y2UZBaw5tRE4cc+vQKq+VGlBWkT5QkUpUubcOJQ8YTcpCIKk1Z7cb4IQvt
	Rmn2+pM8MUOTSYBdKl7mg0m3uUdkmS9b8eoCeK0Ou+cbUQDRTusPK
X-Gm-Gg: ASbGncuxNQ/+yftsOMoczUOfydrQVTVdMrnaOtQHbR3BW/rHm2+VfhtV9G7StgfCCZ0
	2101q/SAbXGeGP5Bz37PODOp1ryyhskv7M3/Nuf/FbLWO1u0I9baxkto+N1+vsnHHmxJ+h4UrZS
	FidzvnG/rKgZIWgyXyDdDCJ21DStubvH+gdzCYjvdVNxPeSuuOwiav4kUC5Nh7LjpBIVcgmbeMv
	oztfaA1bhh/m0Khz71B3DpMbRBSH0y8g+4IjFdq9HV8fq1R5zjtA9GK/rMsLggBtpeZ7amnANAX
	4JlZMvtVR/XCoQAsXIcAujg/Eu33opE2ZDCzWeRE7v3f/EYF2FpWCD47pQXF4ofIlmx//m2f3Jl
	3FzzsAFD8RmfMG/VW5R7CBkcQ8SyOtTlOUsNmK7KSWqMNm5aDNNDDjJZEHrAp
X-Received: by 2002:a05:600c:3e17:b0:46f:c576:189a with SMTP id 5b1f17b1804b1-4711791c3c3mr130359945e9.29.1761051590570;
        Tue, 21 Oct 2025 05:59:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdxh7ZKT7824WXcxtADh1plje6WLOr4tApQ2cZuBwyOs4GdyEk8i7jKfPxnpNj/2+0EbpvXg==
X-Received: by 2002:a05:600c:3e17:b0:46f:c576:189a with SMTP id 5b1f17b1804b1-4711791c3c3mr130359575e9.29.1761051590107;
        Tue, 21 Oct 2025 05:59:50 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47494aa0336sm18536345e9.1.2025.10.21.05.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:49 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v1 08/23] mm/balloon_compaction: remove dependency on page lock
Date: Tue, 21 Oct 2025 14:59:13 +0200
Message-ID: <20251021125929.377194-9-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -7YJwaPzoE9--egFEsy-9DaFBOyduW3R8GalFkHJ8WQ_1761051591
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: AE20B140008
X-Rspamd-Server: rspam03
X-Stat-Signature: xhbyotq9an89fiwfdzatfeimx4fzqnhy
X-HE-Tag: 1761051593-651660
X-HE-Meta: U2FsdGVkX1+tHmdsrfoEZZmVdjZuziN4z7uJ+s+JxnTIYgFFg+JXZQ+3FNV465yCmxUaPWO5UKyAxe6rlpRZcPV27eKei7Z9S0EkCEOJ5FZWU9EZQAasu2cqsBCTTy7L9lfB3SYZl4MLV5o6hx9NqAC7U1xVpwe0WlIi3etHAPFcnYfQ7+ek+Sf/XN5Uc/vfHX5UgsuoYEeQ5uUJ54206ngIzgbwjv1n/TFbex//w7zhcwCzqSFWeajtvRHGkyz9QWPLs/yTOh35g9IdMnB7n9lEm8W8cMtNWsmKn7Qkad+qPTB5QG2Li03P3qBuIywItsVTWHYZUki31mWRIzTEeOgQd5RETCLN+OKekLrJiEVkHyYjww/E++Q2cFcKfnmUJvHUgGWiro2p6I6qm8qgWb3r69qIAlDdwDvPgmpPfJbHeItXxfpzM8uscNsxGEsAON+Bnnr5PisGQkpOUG7o81DEnVp6m7f+l0GQdExQkuS/624XBEF771lp4zsuuhdp9VfbqD+JoivoXQ0Xhp4poz3IQoP0Kgd+cJrhMUhabJ9Sea7inZfVAEBeBFXPMRrlMqumfWQCHQgkKS3O3BCqXnAA75Y1XdAwZK2ViE2PooGPDQeusU9CLbjIBbkPXplf+LClOilGHrL66sP/VxUd48ntbE67MJ4d3UcfjCpTb154BkyXocF9mvEPMX+gqmdprYW9lAR/ttT24wWVy18RDyCotkSvTd1DHbTyToB3Wpmf8lO8sbBANXbNdaJvXPNsw+fZ6ZU2F7Mni3f00GltPhCDk/g6yuEi64a4S61L/dSuUCojfYbe7qGeklWjDUZ5vi50ckiUyWELfgjyjJ8t001wQ7fZO9HhGTJ8hMGSQV4xzAj4LHlrO5ulkt5RG1XyHsAySD+gDVMavrznntFcznoKlF1d0reaFYTxax07PP7DTEsLdV4bB/T5+/prvxXTWPt/xg2wXvBITwUrDTx
 sk/LB7M3
 qIlvggT9NdcKzVV7dAMwyPi4o6riYlzXheL4LZCGCbGVLpIxLh9t8BrqlWmjPpYR9V93mwPe0luzhidgEqaE1vqkiYwCWtIE++GXh26Iy5uEFSZZ2r3KUnA3DKnJdM23dz9SIWdKxfwH5jqxGmigMLT36sAwGbkDjGorK2TDsWWvkVKvyiK1JqQGRNgCsXiCicULRooEtcEpXFsowwQTMe9nVrmv53I057GEeBysIXcKGR0fd+q8GNcXSvSaYDASxCYgxl/LIkEaOf1pu2ysCksWxi6f8qcLa9QOHiJo0mv9rzI8AqZzy0+vXJB3Kh4rinEtG+qIM/SpN5APWTQU7N5CgMZ/kOTMeLPgtU608k7YDoHGJlvL5ZWrZvg9baM0uWatzeWAI0lIaiU5d2s6yAGzA9MHrgEqPcfzO8xu13+F4pGamQWUnltWoUIlDQDN829ctPEC+arGBnRllbLiS5ZicLQS41QQnnHBZwH41TnFsuCgA4Up4t7sBXoARPhExcXgCdET1pMlc6EydgrLcXqAz4BVG8zhwdSktfAdf/j7+ShOcmozIRpinOz37aL/872sWv4Z/xzB4XUbB2TzerK/NjTOhMAVyj/PtP/0ByaUV3zL1tRJ4tKtiXdM13R4iIfXh3Pls5wQEEnhX//Hs0PCLljw9upnBILD9+X2ZI2FRjf3zsP8g9gh3Ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's stop using the page lock in balloon code and instead use only the
balloon_device_lock.

As soon as we set the PG_movable_ops flag, we might now get isolation
callbacks for that page as we are no longer holding the page lock. In
there, we'll simply synchronize using the balloon_device_lock.

So in balloon_page_isolate() lookup the balloon_dev_info through
page->private under balloon_device_lock.

It's crucial that we update page->private under the balloon_device_lock,
so the isolation callback can properly deal with concurrent deflation.

Consequently, make sure that balloon_page_finalize() is called under
balloon_device_lock as we remove a page from the list and clear
page->private. balloon_page_insert() is already called with the
balloon_device_lock held.

Note that the core will still lock the pages, for example in
isolate_movable_ops_page(). The lock is there still relevant for
handling the PageMovableOpsIsolated flag, but that can be later changed
to use an atomic test-and-set instead, or moved into the movable_ops
backends.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/balloon_compaction.h | 27 +++++++++++----------
 mm/balloon_compaction.c            | 38 ++++++++++--------------------
 2 files changed, 26 insertions(+), 39 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index e2d9eb40e1fbb..ad594af6ed100 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -12,24 +12,26 @@
  * is derived from the page type (PageOffline()) combined with the
  * PG_movable_ops flag (PageMovableOps()).
  *
+ * Once the page type and the PG_movable_ops are set, migration code
+ * can initiate page isolation by invoking the
+ * movable_operations()->isolate_page() callback
+ *
+ * As long as page->private is set, the page is either on the balloon list
+ * or isolated for migration. If page->private is not set, the page is
+ * either still getting inflated, or was deflated to be freed by the balloon
+ * driver soon. Isolation is impossible in both cases.
+ *
  * As the page isolation scanning step a compaction thread does is a lockless
  * procedure (from a page standpoint), it might bring some racy situations while
  * performing balloon page compaction. In order to sort out these racy scenarios
  * and safely perform balloon's page compaction and migration we must, always,
  * ensure following these simple rules:
  *
- *   i. Setting the PG_movable_ops flag and page->private with the following
- *	lock order
- *	    +-page_lock(page);
- *	      +--spin_lock_irq(&balloon_pages_lock);
+ *   i. Inflation/deflation must set/clear page->private under the
+ *      balloon_pages_lock
  *
  *  ii. isolation or dequeueing procedure must remove the page from balloon
- *      device page list under &balloon_pages_lock
- *
- * The functions provided by this interface are placed to help on coping with
- * the aforementioned balloon page corner case, as well as to ensure the simple
- * set of exposed rules are satisfied while we are dealing with balloon pages
- * compaction / migration.
+ *      device page list under balloon_pages_lock
  *
  * Copyright (C) 2012, Red Hat, Inc.  Rafael Aquini <aquini@redhat.com>
  */
@@ -93,8 +95,7 @@ static inline struct balloon_dev_info *balloon_page_device(struct page *page)
  * @balloon : pointer to balloon device
  * @page    : page to be assigned as a 'balloon page'
  *
- * Caller must ensure the page is locked and the spin_lock protecting balloon
- * pages list is held before inserting a page into the balloon device.
+ * Caller must ensure the balloon_pages_lock is held.
  */
 static inline void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
@@ -119,7 +120,7 @@ static inline gfp_t balloon_mapping_gfp_mask(void)
  *			   balloon list for release to the page allocator
  * @page: page to be released to the page allocator
  *
- * Caller must ensure that the page is locked.
+ * Caller must ensure the balloon_pages_lock is held.
  */
 static inline void balloon_page_finalize(struct page *page)
 {
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 97e838795354d..28ef0cb6b3bbc 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -20,15 +20,7 @@ static DEFINE_SPINLOCK(balloon_pages_lock);
 static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 				     struct page *page)
 {
-	/*
-	 * Block others from accessing the 'page' when we get around to
-	 * establishing additional references. We should be the only one
-	 * holding a reference to the 'page' at this point. If we are not, then
-	 * memory corruption is possible and we should stop execution.
-	 */
-	BUG_ON(!trylock_page(page));
 	balloon_page_insert(b_dev_info, page);
-	unlock_page(page);
 	if (b_dev_info->adjust_managed_page_count)
 		adjust_managed_page_count(page, -1);
 	__count_vm_event(BALLOON_INFLATE);
@@ -93,22 +85,12 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 	list_for_each_entry_safe(page, tmp, &b_dev_info->pages, lru) {
 		if (n_pages == n_req_pages)
 			break;
-
-		/*
-		 * Block others from accessing the 'page' while we get around to
-		 * establishing additional references and preparing the 'page'
-		 * to be released by the balloon driver.
-		 */
-		if (!trylock_page(page))
-			continue;
-
 		list_del(&page->lru);
 		if (b_dev_info->adjust_managed_page_count)
 			adjust_managed_page_count(page, 1);
 		balloon_page_finalize(page);
 		__count_vm_event(BALLOON_DEFLATE);
 		list_add(&page->lru, pages);
-		unlock_page(page);
 		dec_node_page_state(page, NR_BALLOON_PAGES);
 		n_pages++;
 	}
@@ -213,13 +195,19 @@ EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
 
 {
-	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
+	struct balloon_dev_info *b_dev_info;
 	unsigned long flags;
 
-	if (!b_dev_info)
-		return false;
-
 	spin_lock_irqsave(&balloon_pages_lock, flags);
+	b_dev_info = balloon_page_device(page);
+	if (!b_dev_info) {
+		/*
+		 * The page already got deflated and removed from the
+		 * balloon list.
+		 */
+		spin_unlock_irqrestore(&balloon_pages_lock, flags);
+		return false;
+	}
 	list_del(&page->lru);
 	b_dev_info->isolated_pages++;
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
@@ -249,9 +237,6 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	unsigned long flags;
 	int rc;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
-
 	/* Isolated balloon pages cannot get deflated. */
 	if (WARN_ON_ONCE(!b_dev_info))
 		return -EAGAIN;
@@ -291,10 +276,11 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	}
 
 	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
 	balloon_page_finalize(page);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
+
 	put_page(page);
 
 	return 0;
-- 
2.51.0



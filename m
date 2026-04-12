Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE36E93807
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9296B0092; Sun, 12 Apr 2026 18:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0886B0093; Sun, 12 Apr 2026 18:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6AD6B0095; Sun, 12 Apr 2026 18:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B28E6B0092
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:50:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F2BA140C4C
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:52 +0000 (UTC)
X-FDA: 84651400344.30.A064041
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 668901C0002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RFXw6+gW;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7fwwS8rthQO9vLHBO8UifZIVV+lw2sOdmaFyBVbO1I=;
	b=eWc0aH45eyRYe6FglbVZvd0kPbuDN2fxjetjB3hwdaUwNlv5FShU6O33FSOBMoDqeQIGuV
	FXUU5c09Bnx1YKkyNDZ3xSD9XoxOexwYJguyZqpzHCW/rRcFCihrE71dRVlk1oYpYUbaXe
	Vh9z1k3JukogaHOta//inTXIlyM+PGw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RFXw6+gW;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034250; a=rsa-sha256;
	cv=none;
	b=VELN/GewenaacDXY5GD7UATFJD6viPYpNISgDBEoMAEP/227zXgZv+VER0MrXpQo2LQ9ge
	LHhMNFdvgJQPDFydI9n6W2263wJc3EtEYwHtmIN7sG67s0MCfChSr0a6/o+wPoUzQVNYQD
	UtfV2xYfmww2GsOeoUqYyYD4SdWHhVc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p7fwwS8rthQO9vLHBO8UifZIVV+lw2sOdmaFyBVbO1I=;
	b=RFXw6+gW2/UEZ79RTTX/u/TocYcFq6hgY34FyBFmmIq3IOjSVabClvoG57n1ZzDaoj4mzb
	d1963k815qyrVdcdU1Lur7ROAn17QetxVDZ1PAHY2707KN/uNGxJfL6Xfc0ctxDHRSKTcu
	q3pDpt0FVijYt1mNeYQrZzmi9580M54=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-PBKk5L0nNXuHwljNTNMmkQ-1; Sun, 12 Apr 2026 18:50:48 -0400
X-MC-Unique: PBKk5L0nNXuHwljNTNMmkQ-1
X-Mimecast-MFC-AGG-ID: PBKk5L0nNXuHwljNTNMmkQ_1776034247
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43cfedb10a8so2318060f8f.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034247; x=1776639047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p7fwwS8rthQO9vLHBO8UifZIVV+lw2sOdmaFyBVbO1I=;
        b=iqNOrsROB4B5iaiHkHcBwX1j8rDCOIg125fcwMuXMkLa2q3qUpZwqDpS+gdxPKfnu0
         dpWAOfInoJz1oWGVurVzNcSvH9Y3wBfOP7GIPIpQAcNNj9/XRMdTLMEsZCADZI6pTYlU
         et8/fBzmc22MzhWyxcscDN3awDT15QN8kf0pNgPime23HP2yuWcjIl1dmZ1/qOPrzuuL
         pPdtdilGHKquytw86HsYzhRc5dGFKXk3laxvNRLmCpssMSpcvcRuPsTikjMQViLqUPPq
         5CPHm4T++/d+yw+q+1cMsP0xVRVjEeQa2hiXo+qxNtqC2YnWAedgUChfwE3l0MC1OmD7
         Yhcg==
X-Forwarded-Encrypted: i=1; AFNElJ/WIqfM1SyTFLJ7t5EYMzLRLDB1cmfP2Ocwz036aoI0MCMytYQtMdaVEPQ6CgDoN3z+MFD2/23OKw==@kvack.org
X-Gm-Message-State: AOJu0Ywzrmp4CnqhxB7xzeX2AFzZpb8p2GG2xUn0R/ZdStMQXKZhUZYf
	OFf3anhlqUzw70T+wDzKpsspcxoKjjfsObTEta8G8XxQfQ/SGlJw7pf4snAX0iXp7NHqvuEfH/5
	0Z05toZzd2e4V8/nf9Mm/zZ14dTKkklGyPkVH4JL+MRKHBhK6mMyu
X-Gm-Gg: AeBDievwQomUhXmR+b1zzTlI3BYK74S6/w6OJw0qQdchqHwR29AoTEqt/30t27qMB2h
	9vZ/2lsQ9kIV/kmYibNUzOHwWSvsrxFYO12NObDK4+7y2yXK5db1UfwSR1p1dLd9q7X+khQVn8G
	ytbxOUPefv4EPYflrC2d43N00CTuDQpf4ozT32MbulZtkymTMLw4CpzJcnloTqtVTZfA484JgZ+
	mS6gNzychZi9kpYXHgJSi3VVR1jU+kcJmmxCpkvJk8r2MR8ccKX0u8vaQcf3fH7YmZ9l3uoGNKO
	1flCcIlvwcS4LtCTfh7wEXUbwt3yghBMFOON5CwDEkQ/s6H4TAGdKyb+wmvp8FIyB6rX7PYJqNF
	3V5jpPPB8ksObzsTaB7oY0lTPpk4Pz48IwICl6y0+/48=
X-Received: by 2002:a05:6000:2f88:b0:43d:71f4:7ed5 with SMTP id ffacd0b85a97d-43d71f480a8mr5521369f8f.17.1776034246836;
        Sun, 12 Apr 2026 15:50:46 -0700 (PDT)
X-Received: by 2002:a05:6000:2f88:b0:43d:71f4:7ed5 with SMTP id ffacd0b85a97d-43d71f480a8mr5521336f8f.17.1776034246368;
        Sun, 12 Apr 2026 15:50:46 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e50200sm27750304f8f.29.2026.04.12.15.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:50:45 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:50:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 2/9] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MTZaWDK_RWrt_e5aM7w7NNNcPZdG49pzuBUM5GD8zcA_1776034247
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: y7s53a4o385byzo1gxgpy6gpjrgeqbb3
X-Rspamd-Queue-Id: 668901C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1776034250-890863
X-HE-Meta: U2FsdGVkX18FcITw2uNKYJZsVido/GxdahQNB3/6u6aqq93S/L5kJPcoqRZex5ouvEmeJK1Y3ai6hTlFSKck0+Bkjfa7Tnt5Z7pde3Z35pPXHLM2e7ZCtRj8yILTEpWv8hFjAvgLJk/sH0t0Xj3Ik4ciLucC5JHU6SCqbrmryJWgd/3i64uTUGaagQPY6Pa3JOzy6rqwa45RYtcFITYO6n+VUIomiWfh3trMzsqeJQL6DrnT/kKVQg1vdvToY8uoH8Wp6abpx0SnFz0d97FzbNFtsiCxw++R90o3wtNc8Bq01mvxT5uGIbIUgm/sjk05fD+Rg6yJ0wJbqIeoT20bhknAj+jco+eMktnpZVFeltLKHvxrkFp6AeVWERCFRbFMrI/PFOkbKgyuFZDP7a6VlvYVg21YBG+cQIWQlNKRRuCcs5IeJgw1uav7mJbyepZy8VPSBIuZiWV5toCVy7Njpc/ObylhQeOuR7KX78oZZ3+/ZGqkqbgDL+XWYBJd9efffITYAA3Cbm+sfXv4Em6ywKhCkQDQ3WMtaTLXqX4MEEB0waEy9EpxOq4fImKsEGIZ7rk8ZExh+UDsUPyzk3BYdng0RSOShJaMpg+Am/P6Ov+dhSFzpQfuTzcAIm0O1txjo+8cKOJMyLYkMM6Q8hfx5J6eaQcSVbpgEc2oT2lOZXM71g5VD8XEeJawhrG4htekxiPW95xjhAl+hiiz/e0Cc04raIKWfEZABeuWXXY9+7qnATwyJA2sTVBmUJNSyi3m4BfsOgSx0HdjKjRy8HcSzbuafqH3Wd9uO61wbdXv5k/Ws8vr0f/vhUdmw2G/R6I9KAnG4eZv55RTjZeS6t2tnB++IE6bp15MAuivlc+XuqfSYg8SIeds1pPXKPjj9O06/PuPL874g+B9ad51DQd1m1/uS7UMPzJP1yy3vWExX/FNKRu435PFQXRYvB51EEZZ922xDz+bPOMljiQDbsY
 J65i8+Tu
 Exml/rzUpb/KJnd2hnAko8I9V/Z0QSXcwqrMatRNupedDXI6mEoGuHPd/56tKa9kMm6OejTrowyYizQPlJtnrybl5JWqzocP6LoJ+uxz+oTdoCVxkl46NBNRLNw5HRarUPgjlUg+5jPhZZkrZaSWU2pfbQgRI2FlIzxC9wTa8++RaAK0bV2ralu0k36ymkg86YvmgXJE4KZ80ZX2xo1sH0t2nTSmaw+koxdHPd+QMlciabIWx3a95HcsTyhc5op0/Z+Rvy+UYgYY+IMHYubb5eOR51NaGvTvt9YLIyQTHwI1nt4rDtAgDGp/64SYTDX0iEYdQGeMRWwun63qzSxEoj21MvmRb1CpKhMH3mLPrEFVJPPd0W8P30kIfTJzzAb9Wp9cyIlN0q/sff2tJTxchxI6axA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a guest reports free pages to the hypervisor via the page reporting
framework (used by virtio-balloon and hv_balloon), the host typically
zeros those pages when reclaiming their backing memory.  However, when
those pages are later allocated in the guest, post_alloc_hook()
unconditionally zeros them again if __GFP_ZERO is set.  This
double-zeroing is wasteful, especially for large pages.

Avoid redundant zeroing by propagating the "host already zeroed this"
information through the allocation path:

1. Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
   drivers to declare that their host zeros reported pages on reclaim.
   A static key (page_reporting_host_zeroes) gates the fast path.

2. In page_del_and_expand(), when the page was reported and the
   static key is enabled, stash a sentinel value (MAGIC_PAGE_ZEROED)
   in page->private.

3. In post_alloc_hook(), check page->private for the sentinel.  If
   present and zeroing was requested (but not tag zeroing), skip
   kernel_init_pages().

In particular, __GFP_ZERO is used by the x86 arch override of
vma_alloc_zeroed_movable_folio.

No driver sets host_zeroes_pages yet; a follow-up patch to
virtio_balloon is needed to opt in.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h             |  6 ++++++
 include/linux/page_reporting.h |  3 +++
 mm/page_alloc.c                | 21 +++++++++++++++++++++
 mm/page_reporting.c            |  9 +++++++++
 mm/page_reporting.h            |  2 ++
 5 files changed, 41 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..59fc77c4c90e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4814,6 +4814,12 @@ static inline bool user_alloc_needs_zeroing(void)
 				   &init_on_alloc);
 }
 
+/*
+ * Sentinel stored in page->private to indicate the page was pre-zeroed
+ * by the hypervisor (via free page reporting).
+ */
+#define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
+
 int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status);
 int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status);
 int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3a7c..10faadfeb4fb 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -13,6 +13,9 @@ struct page_reporting_dev_info {
 	int (*report)(struct page_reporting_dev_info *prdev,
 		      struct scatterlist *sg, unsigned int nents);
 
+	/* If true, host zeros reported pages on reclaim */
+	bool host_zeroes_pages;
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index edbb1edf463d..efb65eee826b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1774,8 +1774,20 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
+
+	was_reported = was_reported &&
+		       static_branch_unlikely(&page_reporting_host_zeroes);
+
 	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
+
+	/*
+	 * If the page was reported and the host is known to zero reported
+	 * pages, mark it zeroed via page->private so that
+	 * post_alloc_hook() can skip redundant zeroing.
+	 */
+	if (was_reported)
+		set_page_private(page, MAGIC_PAGE_ZEROED);
 }
 
 static void check_new_page_bad(struct page *page)
@@ -1851,11 +1863,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
+	bool prezeroed = page_private(page) == MAGIC_PAGE_ZEROED;
 	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 	int i;
 
 	set_page_private(page, 0);
 
+	/*
+	 * If the page is pre-zeroed, skip memory initialization.
+	 * We still need to handle tag zeroing separately since the host
+	 * does not know about memory tags.
+	 */
+	if (prezeroed && init && !zero_tags)
+		init = false;
+
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..cb24832bdf4e 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -50,6 +50,8 @@ EXPORT_SYMBOL_GPL(page_reporting_order);
 #define PAGE_REPORTING_DELAY	(2 * HZ)
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
+DEFINE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
 enum {
 	PAGE_REPORTING_IDLE = 0,
 	PAGE_REPORTING_REQUESTED,
@@ -386,6 +388,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	/* enable zeroed page optimization if host zeroes reported pages */
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -410,6 +416,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
 		/* Flush any existing work, and lock it out */
 		cancel_delayed_work_sync(&prdev->work);
+
+		if (prdev->host_zeroes_pages)
+			static_branch_disable(&page_reporting_host_zeroes);
 	}
 
 	mutex_unlock(&page_reporting_mutex);
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
index c51dbc228b94..2bbf99f456f5 100644
--- a/mm/page_reporting.h
+++ b/mm/page_reporting.h
@@ -15,6 +15,8 @@ DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
 extern unsigned int page_reporting_order;
 void __page_reporting_notify(void);
 
+DECLARE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
 static inline bool page_reported(struct page *page)
 {
 	return static_branch_unlikely(&page_reporting_enabled) &&
-- 
MST



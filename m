Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 089A8CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC976B00BC; Mon,  8 Jun 2026 04:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D276B00BE; Mon,  8 Jun 2026 04:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564CD6B00BF; Mon,  8 Jun 2026 04:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 449246B00BC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:38:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 090181409E1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:52 +0000 (UTC)
X-FDA: 84856094904.15.06F92E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD2111C000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DlTapet2;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1lvfH8Mz6BNBeGQvvcXVuozV5D9pusYvRbrmVhIfIf0=;
	b=1AiUJT3nxgXMpuQE7RdxBtATYlMCW41Z3XWPO5pbHc1yZGgeSfNWdIV5AAIYIRlJ2xg8QJ
	daLgtXfHcQ4RN01vjDxYCT/Hw0MRgYtweQ0/HFbkm60TpADG9MH5Y7eLIEY/fWBQ8U2xhV
	rgacHOxBIDM2q922AzElZHpBJVrHsq8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907929;
	b=a+EjFhBmwVpqDWI5Dg80NhJ23EA9vZ4+e/jqOTrqy1vF/iHsJMxGieC5GvNyZiOf7hVwJP
	PxjtjMpkprGzhQ7IpsSe6YNJd2F5AU/ROwKbVgN0wL6F2Eo4CG5xi9wXqYrt3WiIW4EemB
	8NdNmIm1P+jY4gzG0HsO/Xj5xMxBEaA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DlTapet2;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1lvfH8Mz6BNBeGQvvcXVuozV5D9pusYvRbrmVhIfIf0=;
	b=DlTapet2T4ktiww2FSwxG+lE4KDjZIcaI4onjkGmuFPZWex1/xziDRMfmcplF7OvBOiwWC
	JxEsGtsQPVaNQBh8r61ys2VGLKBFvoEoUerImHnAt+jf9xvb2kC29uQJAp9LF8DNaeplHC
	819B45EDsamu6FNS5ZmjsG62aaaFj3o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-ttdO3rHHO0OVQtPnSl-WlA-1; Mon, 08 Jun 2026 04:38:47 -0400
X-MC-Unique: ttdO3rHHO0OVQtPnSl-WlA-1
X-Mimecast-MFC-AGG-ID: ttdO3rHHO0OVQtPnSl-WlA_1780907926
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490ace40f13so18300595e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907926; x=1781512726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lvfH8Mz6BNBeGQvvcXVuozV5D9pusYvRbrmVhIfIf0=;
        b=FtlXp+YnKb7n2soYYnT0qCWb5SsChGemwzU6f8arcWPoDRE5KAudutaryZdRCosVos
         zp26AYMS2LWDT5klMVN1v15Ov7yTfQXwu6+rZWho03OWgQplRBcBmWgKH/ml4Miv4f5B
         bcmAP+JVkYXZTM6m2ziDd2+PKIPTO32TETGxCKFttfJ+bBiPmIduF2DVAwvZSng5AYl+
         VvDabV5VBpMwvf2rt17u4I11+pzNuoo4fwBs7xo4mrDgHMT7/DJKVqGXmt9ugE8WAcBK
         Qyy2fQO/NN6QcgD0TxhLSopGllB4gULE9tej+UhYfmOnLikzrVBrnR0Yh3b7f2pIloDs
         ZJ9g==
X-Forwarded-Encrypted: i=1; AFNElJ+gag/WioKFJoG7lDR5UTSv9CLsCVbolskfF51R/vm646ngsnXHOkXR9wwqiuRMsSiMVDHQEU4UHw==@kvack.org
X-Gm-Message-State: AOJu0YwjU9StZ8+U4+vHfectAOw0F4F1AIt8KWB9hrcBl9vdRxVjiTIP
	pJ8LHfMsijxYCq7wl5pfwiE4Epb7rbK/J7mTlg/9DLm8wdU+gb9c7wfQ+QdEkYSxwMiTIxqVgVP
	yht5lbLdrVDT9jsfQuwWnn/Qheu9bjrz5gRSKmNCaBvzSj27kaPHu
X-Gm-Gg: Acq92OG9HXi14WKESzo7twMKogxeOzRpuCXaU6TKs01XReMKfIafT6Rgs1JkD/OZ86k
	9aH4vGZ+SrIOGO30g0hV1ZUZ6hnt6gyH+MdB6Rp4s70d6fXxub22jHjLGxla3FwdSr3UBc/6RpC
	8ufRH7g60OR6YSptWOIx38KAt2lGx3AQpZCbenzRLmDjvLRZdbFrapSEsRchzvqmhEDgZ+mjZug
	s76YcJ+VPJHk9QcUaYh/LvsaruDdC3WrZA8SFhy+xf3ZUXAAeAz2EXOwwCcZI3xK4Mx+PilviP3
	TtrdXsLyKOm6LI8PfZ1m9R9BiZBIa+mNX0cHYe5oPaMZDcbpcB6Vb36Lb7yfCjmrR3Qiyrmzd6s
	ZwJCGPpFba+Z5BqhxLMIt6Po=
X-Received: by 2002:a05:600c:628c:b0:48f:e26a:1744 with SMTP id 5b1f17b1804b1-490c25a87f5mr237272535e9.9.1780907926343;
        Mon, 08 Jun 2026 01:38:46 -0700 (PDT)
X-Received: by 2002:a05:600c:628c:b0:48f:e26a:1744 with SMTP id 5b1f17b1804b1-490c25a87f5mr237271745e9.9.1780907925906;
        Mon, 08 Jun 2026 01:38:45 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2eadefsm51854339f8f.11.2026.06.08.01.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:38:45 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:38:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 22/37] mm: add free_frozen_pages_zeroed
Message-ID: <4220116b4d91f3e933fa76ad473106c2e48fd452.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tOu_4XZqVvx8VR3lPD5Jp7tAFlGbq6PomddYRt_gUHw_1780907926
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: AD2111C000A
X-Rspam-User: 
X-Stat-Signature: uyreujuspn5djurk58aq3qncddfggaqg
X-Rspamd-Server: rspam08
X-HE-Tag: 1780907929-298160
X-HE-Meta: U2FsdGVkX187VTKMI4eZVQf5iMCnipvAhwULJEBQbQUmIEeskmeW+8lVN0OaZPICLqbHxg7BZyB1hmH44x6X7Q2YMhC9yME09W1cg/2rTdRuO28wb27taH9K0WqGtWEALLWbkDiCY/fmJckGfFGzmfMeTKcYGsLBNw+D5+tNNLAw0CzvZUMsj8f4fVY4FgMIVD6rR9qxZpoMBw69gp6F/7WRxsLuv8w3x/5r5Xmod+fTpqhFfEH1T1Bv12WRZqTsrsIUHWZ+noRtTBNXbKcWwaXfBCTt6AnSD0R3ugXho1cYPnI+eGpodqVivuPg0VSkeD1HDRAN8atK0U0E1IusOVP+S4fj68LaRQdvEB/o2fn697uxBoAsEoVXtID0c+lRs7bFHmrzrOCgk5IrICEF8D+YTP3Zv6lqLicKHqx1TC+ZWE2nK6LA2KabejMhLBG/09xCzE7uE2bf3rKKWy1HawBI6AqX3AdjKrL2cX9XX7lRCrDDdb3QQlIiOmvo7wLRHXpNPBln0qfHlgG0YiQDjTS8SPSOANzBi7mTYegnlHTKCe+NtQgb0ydobxUhAXGRDV6FTKbrk1GpjQxxKdR2cLbvheDYqCHaUX2ELrkc1n+IQkSxLqjDevjSxdcfWhGgQaJyOl7dXPyAUowzARTJZZ+AMMzTfD6wPJbit0Pt63vrebY3YCiUW1IBzinmHlA1FB4F+XS7wRNL5L0S9iSoRHNrg6kwSjtd6k4v4XuRd92A34DnlLUqEasMMGnneoM1ixKLXh7/xaoBANgWfLNqJBq9EZdp9/PxoW/eqyic5uVZe2M1yNT/GSKz1N15Du0IiYJttrT7DyUnKsvpV4BjR4WYxAxkAf8odhafZcMdD/0rNtLU/XJmYIovFyA93YPXrfpx3hPQS3XSlM3eCYjvcPHkY0zb+uif9wV+BSPn19cThofH5jWP9tfCuUPpRpjKlzW2AQJMc4wZMY2X1E8
 eDA1dkt4
 vfoXU168rAuYg63EFnGDpHWMDV0C0O8tt+SpJAoG9msWdNp0c0EwB7WwM9lDUX+kzqRDRvQqd41A91kTm+Pkqzc6L0cDnUieltwHMMbfd1N5O10MWNDO5aAzq3YrL49oTarFLL3pCbfE7pmQzvcXtBBODSMU5SzxOLApvloLi3iF1iIDd18zPTVOwA7xJ3j63hK9rfkUXhvVXRTEXWDt6d+L7Y0LYD1NCD//8ev9zK622Wimfg7dvI9XQtCXpV9MaxX/6sOyF4ouCjmWIGoBXgaVpnOl5ITfh8VZyTbULDQJQK8G/C0nIiqfZG5VIQdEX8PislBVIczJ2ktrwYFtEpJltwJvLf0TBhOZ+Q2W199j3sn6rUEM/1w2Jx/yTmKXd5QXNGP9RpKp8E/paiujclQ/VmVzLt71Kbo9oUmMUipkekwU9nJq0MgGPQ1sLxvwWFPze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add free_frozen_pages_zeroed(page, order) to free a frozen page
while marking it as zeroed, so the next allocation can skip
redundant zeroing.

An FPI_ZEROED internal flag carries the hint through the free path.
PageZeroed is set after __free_pages_prepare() clears all flags,
so the hint survives on the free list.

__SetPageZeroed is non-atomic but safe here: the page is frozen
(refcount 0) and not yet on any free list.

Note: when want_init_on_free() zeroes the page via
kernel_init_pages(), the page is zero but the direct-map
cache lines may be dirty. A later patch (skip
kernel_init_pages for FPI_ZEROED) avoids the redundant
re-zero, and post_alloc_hook handles the dcache flush
for user pages on aliasing architectures.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  1 +
 mm/internal.h       |  1 +
 mm/page_alloc.c     | 23 ++++++++++++++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 73109d4e31a4..d24b61e45861 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -384,6 +384,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff --git a/mm/internal.h b/mm/internal.h
index 4af5e72742ba..fd910743ddc3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -938,6 +938,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
+void free_frozen_pages_zeroed(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 21f9e92922f1..008f1a311c40 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -91,6 +91,13 @@ typedef int __bitwise fpi_t;
 /* Free the page without taking locks. Rely on trylock only. */
 #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
 
+/*
+ * The page contents are known to be zero (e.g., the host zeroed them
+ * during balloon deflate).  Set PageZeroed after free so the next
+ * allocation can skip redundant zeroing.
+ */
+#define FPI_ZEROED		((__force fpi_t)BIT(3))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
@@ -1596,8 +1603,12 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		/* Don't mark zeroed if poison overwrote with 0xAA. */
+		if ((fpi_flags & FPI_ZEROED) && !page_poisoning_enabled_static())
+			__SetPageZeroed(page);
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -3020,6 +3031,10 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	if (!__free_pages_prepare(page, order, fpi_flags))
 		return;
 
+	/* Don't mark zeroed if poison overwrote with 0xAA. */
+	if ((fpi_flags & FPI_ZEROED) && !page_poisoning_enabled_static())
+		__SetPageZeroed(page);
+
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
 	 * Place ISOLATE pages on the isolated list because they are being
@@ -3058,6 +3073,12 @@ void free_frozen_pages(struct page *page, unsigned int order)
 	__free_frozen_pages(page, order, FPI_NONE);
 }
 
+void free_frozen_pages_zeroed(struct page *page, unsigned int order)
+{
+	__free_frozen_pages(page, order, FPI_ZEROED);
+}
+EXPORT_SYMBOL(free_frozen_pages_zeroed);
+
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
 	__free_frozen_pages(page, order, FPI_TRYLOCK);
-- 
MST



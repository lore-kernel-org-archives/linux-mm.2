Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98CA5F588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC9B6B0088; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B41F6B0089; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5346B008A; Mon, 20 Apr 2026 08:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFA176B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94FAEC2FFE
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:39 +0000 (UTC)
X-FDA: 84678918198.12.0365CCB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49B73120003
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N3R1/G1/";
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5FdBsp1kGQjyJJvapBdTNqnIIO/0keRRtcyQFKcGwU=;
	b=mriAl/M2rqBGjgJFOPycgtioKdp1JxnruKjVisAuYIqaTLVDkTHQPfodT3M+WecgNt/gvJ
	LV/hyGpMeX/0SVdkx7AZrdWDpxt1I5NhBT3hKZL2ZNphZAiUArayKk0/a1NlUEkYenzjxe
	c2DSKv92Mb5K70NH1T0lAUrFdGQ38BA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689437; a=rsa-sha256;
	cv=none;
	b=qyB29AxcTarf21za+uRwy7qKle+3oVn9a30UTvSz4A8qZoGnzI2ykLiZlWRu+RTc6NSul4
	GUoCz9kE7CadA7qoR4XsU+9LKxW2Rjy8RRxgWnpC6F3YW3pGKrlEdrD/jbWt2ES13aUZr8
	C212jdbAKhU8p9wxxw3hEp0WoqBK8tU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N3R1/G1/";
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l5FdBsp1kGQjyJJvapBdTNqnIIO/0keRRtcyQFKcGwU=;
	b=N3R1/G1/fbDEVo1scinpk4T6NhV52fkoKuzUaIUpqsuXdMz5IpjccNO5gvPNuIMF7wJlN+
	F+LRV2OlxhOPazq+Jg24etEb2fMje9g7wEcHuzfQrcwFUbZu5wf4V/0Bvkp6iewLxlO2yS
	yNd8DIA1Ji4Cxg+X5nHsM/Sk4RdaWn4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-OHUaQ0PaMaaImHdQv0WqjQ-1; Mon, 20 Apr 2026 08:50:32 -0400
X-MC-Unique: OHUaQ0PaMaaImHdQv0WqjQ-1
X-Mimecast-MFC-AGG-ID: OHUaQ0PaMaaImHdQv0WqjQ_1776689428
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488e097a270so22534145e9.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689428; x=1777294228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5FdBsp1kGQjyJJvapBdTNqnIIO/0keRRtcyQFKcGwU=;
        b=cJsA50ZFN4TsgnRmB5Dv9DiPmYn2sw9SlGNoBG7owJEny8ioCh4/p0pc6PPHlDbQ4E
         WqunESX+5eqqVct0zCYmdQo65K1lU6hjOxu79eoWoO8Lr4ca4hfsy1RsgOIjtTTKvEjo
         36yIkATWa9/wxOszRFwRakau4AAM+3btG+ahLcsU0DBWYRf+YOW+zLmKzg4AEfb6mefu
         fRiwFBXRPhkmrDfO7Ngn80IVQELG+DAZ/YSs7FyFuqaGLL4BaRTisNwILSvQ5N7HgEuO
         aX5JJaURLKy9BfPGcNuUVokUhoQmz63h8WNJKkYVLfZahY91FHAlxAaXz9KaEaLSNxv5
         dL/A==
X-Forwarded-Encrypted: i=1; AFNElJ97UmEJchKFU0o4C5eb3vPZ9JToQqWTjItmMB7J2b9lmMLiR3Ok5vmCPag7r2N43a/bS92sUzwo9g==@kvack.org
X-Gm-Message-State: AOJu0Yw88MA5wWmTtpiv/NF6Rpnj2Tw/r2J8laC5RurJSvYiJd2sIXGm
	cp7BRaVkNx/y/LKwnEdLApc9kl5jOz/Mat2K+V0Vl/fYmF8iJbHptWVAKYJrUllhKhPCzIRonoS
	trQsq2saQlRzgbyGqZti5YNmWdZnlnmIEkMwgrOp3mZzh5tpiKF9K
X-Gm-Gg: AeBDievrVbs+DcxaZM73AGZu1nUkJGtXhd/LXxG/Y6HP+87agFdenYdsS/2Cx4ongco
	obDhqvF4YkXpY1vqsoC6g5TNkS6Sd3qhhftFoBO3RYJE01nHH+AkWWzYtxEsp6GGuzm8rlTnivS
	zJ7CZmxl034ycWVKZRT3PM4A5XDz8wYzpw64vDe0EdCCSW5UNJemncXI/m1vdW6lcshB0htWKgy
	jhDmtrBaz7AbQaXQZAGu49W2Qv4S+wEu6NbT7PQXha/k7CjaIN22DlIdvnXSMB3O16ZRg80Lby1
	iu8qTMXeTBUCyJl+BblNAetqdC1kIlHwyNC0nq4t4RULtSTrAcvSyzujaY9bfRSGtzYnckAgsNY
	lPgFsGGksOYsMUDGNm3B668VP/3hovvuaWqTDsLHNCj59KHqm7F+s0w==
X-Received: by 2002:a05:600c:c0db:b0:485:2a4b:7bc3 with SMTP id 5b1f17b1804b1-488fb745289mr134427095e9.4.1776689427813;
        Mon, 20 Apr 2026 05:50:27 -0700 (PDT)
X-Received: by 2002:a05:600c:c0db:b0:485:2a4b:7bc3 with SMTP id 5b1f17b1804b1-488fb745289mr134426535e9.4.1776689427197;
        Mon, 20 Apr 2026 05:50:27 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891f4016bbsm17219265e9.4.2026.04.20.05.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:26 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:23 -0400
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
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH RFC v2 02/18] mm: add pghint_t type and vma_alloc_folio_hints
 API
Message-ID: <290d615a001cf121dc0c604eb79451bcc7917baa.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MZm1gD9oTIWIJR5-Uu-ByIb7c_vqcNp73OCUaRrqP1c_1776689428
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 49B73120003
X-Rspamd-Server: rspam07
X-Stat-Signature: a4gjzikip4nyd84ji1g9rt39cb87dt9u
X-Rspam-User: 
X-HE-Tag: 1776689436-66040
X-HE-Meta: U2FsdGVkX18BcJkgnkkpoYTepS+t0msJcfGIKSlv9L6OyMDG1uHZ87SYfy43QRKlLr+B/m5Wr4M6KsaH6lHW3KTnLn04V53uGvx+NRWZDDYG/dzUpuu+KpmOUy6VgQqAxA/bcSFCrAo607SQFXywNix5O3QSB7eVqqEu7YddgzroIskLwvNP/Eg8PvolUjsP3LRP5svB0ZaGSySKabPaN2dnGqiGT+tQvX7MHRcglflSlA8eq/tqcNnthZkSNfm6Y1fS7SZRj6U6bNCdG3VhYVezJ5GPt3Fb1MkVYH8Duo2xmYLYJ5vfkBQU5TFdX+3RmxRJR7vk0U+4m40MP3RmH+m5qJNBdazPhHoW9+GTsE2L+SarR3Q2Zo8rcPb0hInXNwtfM2FSm55b5DGm2/wJW4moZEgC63lkW1+okp6WRVDOccJXjofKyknYgkHCSx3GmZb29rNKNfJT1ooMKkvg4F+7CEps5srKUJ9v/sTaS1DDg9MXiCuoTvmefFsgXE/8ENJ1xAkFOVQy//flyqVMWJWoMukeXxZfTLApLtaVIoiJVm3YakwmkBNsE7vEXRHubFNzs/HemdQGwYTVTajBNDC0xxZ9wS0RyuNmx+eY8w306ppf/9/tE5njlaIuJsBwf9umw4FfMQp/gLfoqaDayKgmUWwjUZUdwXrxJYESimviXg3hGJ0CHibuOX6zJtMR9l3FFVf81RcIhVGrl0UFCMZV9QSfTJmV8EKg9Ew3zXlJ6zc/7uQEOc1WlADKKDR81VSyHuZZeLcL/dhkes0OfdH6qmigZ3JpJsaZHAtUS8sTxMWqtSvmjwRJDKs+iPvZD4LEcLT+lKp+lKoC3Gn3oiA83+jm3tz7b+KD25o1K2NUqOR0+4jdIUV5GNFD/HVH4eeofCo9ATvffIFxMo17pgo4wYvponpII6LqnWbT69yOp46CjgVnHsZmJK03Ey9RU2o5nN28b0DyPPym+15
 QNYBrKHv
 52k2ythd0KXi2lLTEL7+pLDOYnrl7rzOKhuBgRtv9K9N1DR7fxZQEFbSSqAMfsfe5G71xTujVKozvziTQt1a19WOcfuF6i54h5Y/JziJXvlOGTHcuI2GF62dk0r5akCG1jSdmRjIU1PN0YjSR0LZuVX8XuZv0buUn+WvPdBRnkl1PMIWOyk3k6GBDG0jBcNM2/BlZz09WKvMkL5F06/8qp9GkT1i0ceSQaFiYW+SXQv52AKSD1Dxeexu65kUwdxHpY6SVGOBlgwsJXxMSgs2qTXM2xWxmPHkFJ1/W3CFeA1K3oiTLsfiZvL8gQmGKjvBP62MsUUeZyn2viltA2yi6q/kroB2AWgTH09k4w+ocmh0Y/aNZdYGqCq8H3VjzCX03UwJVFcPjAYVeBRd+KvksunEPOKuvogHwNS3uo10oJBz1AN0Xdr3dUnVm+3c+s1uwX/Rw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add pghint_t, a bitwise type for communicating page allocation hints
between the allocator and callers.  Define PGHINT_ZEROED to indicate
that the allocated page contents are known to be zero.

Add _hints variants of the allocation functions that accept a
pghint_t *hints output parameter:

  vma_alloc_folio_hints()  -> folio_alloc_mpol_hints (internal)
                           -> __alloc_frozen_pages_hints()

The existing APIs are unchanged and continue to work without hints.
For now, hints is always initialized to 0.  A subsequent patch will
set PGHINT_ZEROED when the page was pre-zeroed by the host.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/gfp.h | 15 ++++++++
 mm/internal.h       |  4 +++
 mm/mempolicy.c      | 85 +++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c     | 15 ++++++--
 4 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 51ef13ed756e..14433a20e60c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -226,6 +226,9 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
+typedef unsigned int __bitwise pghint_t;
+#define PGHINT_ZEROED	((__force pghint_t)BIT(0))
+
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
@@ -325,6 +328,9 @@ struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
 		unsigned long addr);
+struct folio *vma_alloc_folio_hints_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr,
+		pghint_t *hints);
 #else
 static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order)
 {
@@ -344,12 +350,21 @@ static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
 {
 	return folio_alloc_noprof(gfp, order);
 }
+static inline struct folio *vma_alloc_folio_hints_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr,
+		pghint_t *hints)
+{
+	if (hints)
+		*hints = 0;
+	return folio_alloc_noprof(gfp, order);
+}
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
 #define folio_alloc(...)			alloc_hooks(folio_alloc_noprof(__VA_ARGS__))
 #define folio_alloc_mpol(...)			alloc_hooks(folio_alloc_mpol_noprof(__VA_ARGS__))
 #define vma_alloc_folio(...)			alloc_hooks(vma_alloc_folio_noprof(__VA_ARGS__))
+#define vma_alloc_folio_hints(...)		alloc_hooks(vma_alloc_folio_hints_noprof(__VA_ARGS__))
 
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..686667b956c0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -894,8 +894,12 @@ extern int user_min_free_kbytes;
 
 struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
 		nodemask_t *);
+struct page *__alloc_frozen_pages_hints_noprof(gfp_t, unsigned int order,
+		int nid, nodemask_t *, pghint_t *hints);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
+#define __alloc_frozen_pages_hints(...) \
+	alloc_hooks(__alloc_frozen_pages_hints_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cf92bd6a8226..b918639eef71 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2547,6 +2547,91 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct
 }
 EXPORT_SYMBOL(vma_alloc_folio_noprof);
 
+static struct page *alloc_pages_preferred_many_hints(gfp_t gfp,
+		unsigned int order, int nid, nodemask_t *nodemask,
+		pghint_t *hints)
+{
+	struct page *page;
+	gfp_t preferred_gfp;
+
+	preferred_gfp = gfp | __GFP_NOWARN;
+	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
+	page = __alloc_frozen_pages_hints_noprof(preferred_gfp, order, nid,
+						 nodemask, hints);
+	if (!page)
+		page = __alloc_frozen_pages_hints_noprof(gfp, order, nid, NULL,
+							 hints);
+
+	return page;
+}
+
+static struct page *alloc_pages_mpol_hints(gfp_t gfp, unsigned int order,
+		struct mempolicy *pol, pgoff_t ilx, int nid,
+		pghint_t *hints)
+{
+	nodemask_t *nodemask;
+	struct page *page;
+
+	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
+
+	if (pol->mode == MPOL_PREFERRED_MANY)
+		return alloc_pages_preferred_many_hints(gfp, order, nid,
+						       nodemask, hints);
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    order == HPAGE_PMD_ORDER && ilx != NO_INTERLEAVE_INDEX) {
+		if (pol->mode != MPOL_INTERLEAVE &&
+		    pol->mode != MPOL_WEIGHTED_INTERLEAVE &&
+		    (!nodemask || node_isset(nid, *nodemask))) {
+			page = __alloc_frozen_pages_hints_noprof(
+				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
+				nid, NULL, hints);
+			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
+				return page;
+		}
+	}
+
+	page = __alloc_frozen_pages_hints_noprof(gfp, order, nid, nodemask,
+						 hints);
+
+	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
+		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
+		if (static_branch_likely(&vm_numa_stat_key) &&
+		    page_to_nid(page) == nid) {
+			preempt_disable();
+			__count_numa_event(page_zone(page), NUMA_INTERLEAVE_HIT);
+			preempt_enable();
+		}
+	}
+
+	return page;
+}
+
+struct folio *vma_alloc_folio_hints_noprof(gfp_t gfp, int order,
+		struct vm_area_struct *vma, unsigned long addr,
+		pghint_t *hints)
+{
+	struct mempolicy *pol;
+	pgoff_t ilx;
+	struct folio *folio;
+	struct page *page;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		gfp |= __GFP_NOWARN;
+
+	pol = get_vma_policy(vma, addr, order, &ilx);
+	page = alloc_pages_mpol_hints(gfp | __GFP_COMP, order, pol, ilx,
+				      numa_node_id(), hints);
+	mpol_cond_put(pol);
+	if (!page)
+		return NULL;
+
+	set_page_refcounted(page);
+	folio = page_rmappable_folio(page);
+	return folio;
+}
+EXPORT_SYMBOL(vma_alloc_folio_hints_noprof);
+
 struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 {
 	struct mempolicy *pol = &default_policy;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index edbb1edf463d..f7abbc46e725 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5222,14 +5222,17 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
-		int preferred_nid, nodemask_t *nodemask)
+struct page *__alloc_frozen_pages_hints_noprof(gfp_t gfp, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask, pghint_t *hints)
 {
 	struct page *page;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
+	if (hints)
+		*hints = (pghint_t)0;
+
 	/*
 	 * There are several places where we assume that the order value is sane
 	 * so bail out early if the request is out of bound.
@@ -5285,6 +5288,14 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 
 	return page;
 }
+EXPORT_SYMBOL(__alloc_frozen_pages_hints_noprof);
+
+struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask)
+{
+	return __alloc_frozen_pages_hints_noprof(gfp, order, preferred_nid,
+						nodemask, NULL);
+}
 EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
 
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
-- 
MST



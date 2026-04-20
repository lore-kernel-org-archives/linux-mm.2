Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11CDCF588C1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFFF96B0093; Mon, 20 Apr 2026 08:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64A46B0095; Mon, 20 Apr 2026 08:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50E56B0096; Mon, 20 Apr 2026 08:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1F16B0093
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CB28140A51
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:47 +0000 (UTC)
X-FDA: 84678918534.23.E83B663
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF87320003
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iGbhMUp+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689445; a=rsa-sha256;
	cv=none;
	b=P2UIBQrypWLtxhlxk2yblF3zPBPvpUU/vA8Nl3m3xVvR+U7vpyYjzANVaKmu/u0Vw5u9zu
	WCQ8uPOvKn4jOdYvG+TTLZGSLjDjAWjh/ca8jwg7Q9Im6wK77rW3PI3YJrvyYDUPpK/b0U
	E61VWciAOMlk/P5of2MsJ1HvVQKiehI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iGbhMUp+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJcG0BVg25HZ2E/z9uEY2PXmC8ZZQ0Dy/q/+TJStPMY=;
	b=VLlBmmByri89ZV/QJaHtLpgwUi41Tp33zRmVamR3QoHTXrXCLV1tg/wLAkqQRd8wpl7Bd0
	gAuLKT3HnRX0+dSrd1Pr0AE2O7O6YmkSJfvWj7lHCXyqui9rs1ZcU3lHQIj/P8qTL9b2Al
	i6d+6DIvurPSzQ7YB/j09HmqNFPqtpA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YJcG0BVg25HZ2E/z9uEY2PXmC8ZZQ0Dy/q/+TJStPMY=;
	b=iGbhMUp+mOsUpon+xH39dAXASkRveFClob3YiI8Xxg/7saEtw0L4c4/Q1/Q/c3LJdzCfHs
	+uhf0BCWlgP8vxAd7/702gyxGlRD6L+L1l1qf75sVWkJSiwPTgnO/68e36kQgeCuIvy3AU
	sbFFWIX0WS4P9kAvUt2sr4awKp8L8AM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-YT8_HnwINcOcWm8ZkJWuZg-1; Mon, 20 Apr 2026 08:50:43 -0400
X-MC-Unique: YT8_HnwINcOcWm8ZkJWuZg-1
X-Mimecast-MFC-AGG-ID: YT8_HnwINcOcWm8ZkJWuZg_1776689442
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488c213b485so26494475e9.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689442; x=1777294242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJcG0BVg25HZ2E/z9uEY2PXmC8ZZQ0Dy/q/+TJStPMY=;
        b=Cb8cvIpRz6OaG87W1HXE4ow3aQBvvHjzThneT8BYrNxmZKVfq1h8y2Tr5QMJ3riBW9
         4ndooPBZv4zBzMx+JFLm/lLZ3PEmSZXBzNhPKcLDWzKcBGNLsdskyhe3d4oGIKRB51TS
         DUrz55WzV0xFx158QvGXp5/3GQJnImIzJoo5HQV09Smpa/0LIQz/9bV1qnSh6E7Hib4Z
         43lQ/nlaU8oqLtxHY50r6VZpmrp6bDyHJ/pJAtxdg7N2xARFu7SeP7MnsuJa7JXZHuJp
         upRXrJS7wRbPNaYme1A8rity6WDpx5D/E34fv1mXwNE7SEI05KohcYPv/FxzqSMod2RF
         wIJw==
X-Forwarded-Encrypted: i=1; AFNElJ84b9YFOsp6aVum7pQkNvTEybVABgF1Prygrs6gBLdmJNuFheJG1RcamB/GWzbS6GeLi4kTymem8w==@kvack.org
X-Gm-Message-State: AOJu0YzRABFWZuoulSfFUiF0h463Ept6gr6e7PVjAEnqh5Xd6SfBa/HL
	OdmCyXWqfeDFbI+ItTutWXeulLgz1CvRUI+fh0M+Ox3Z1Cwe6qENmu0oD0/puJK14MlbU9Npf/X
	qZ1E3Qj3LCC26aKaRZ+QJDNuC9gHJ5Per8tBe9EDHTxKsUUz6RHut
X-Gm-Gg: AeBDiesNrvPgSLmaajIaE7m0fC0l5gRk375J2Gr49Esq/RG5Q1N/xL0IhZXDVeOY4hD
	kGU0KRgDjoEeNFOhz45ni2TtoQPbnQqOdxr63J6i0QG7Egu+/S2GGS5Rl5sKMyZXFgYJmZq165D
	a2Kkm/jLiyRQu67d/lTat/lrfM48T/CzXvEfxjxXvv/UY/uaz4dSYCqUKKxthzEGXIvB4jmLZyE
	d5ETZ55oHlHg0urZhiaWWowBnndSIqjigzSL3z/hQK/kcZWep9rRZEBcZ5h3RS0MQOALb82MdMX
	DYVrP6uYX1FC4syq+s2AD+PL8RnFkw8nIXNYCAoD2eCCPAAxZn7hChFT9D0iTc/IiEODonyQXOX
	MpXXexY9ozxn1L1ViHASSqlyfXCtRVwD8YR4hoCMTOjOstXqDSeHmHg==
X-Received: by 2002:a05:600c:4f0c:b0:489:1c1f:35e6 with SMTP id 5b1f17b1804b1-4891c1f38c8mr61834745e9.6.1776689441673;
        Mon, 20 Apr 2026 05:50:41 -0700 (PDT)
X-Received: by 2002:a05:600c:4f0c:b0:489:1c1f:35e6 with SMTP id 5b1f17b1804b1-4891c1f38c8mr61834045e9.6.1776689441052;
        Mon, 20 Apr 2026 05:50:41 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7bf696sm89203495e9.32.2026.04.20.05.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:40 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:38 -0400
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
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v2 07/18] mm: post_alloc_hook: use PG_zeroed to skip
 zeroing, return pghint_t
Message-ID: <fea448c692ed75232179a24ca853fdc8dede42f6.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XIGqCKfAUiV4RlgEXGleqNZPxWyDurTWPx6c5wO1Uxg_1776689442
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Stat-Signature: n7ssezxj5apbf995yya7znp6rhps4c76
X-Rspam-User: 
X-Rspamd-Queue-Id: EF87320003
X-HE-Tag: 1776689444-542792
X-HE-Meta: U2FsdGVkX18rKQI4tKnmC1oaL2mNzeM0psaRaRQg2vYI+0zHAD5QrXLL06VWNh3w0kekdbLK1Wt40SmxGPmjFNQOx2olMe851J1g98zTkdA/CfeR/XlaDDYJ0G2qQVc1vg2dRMdjiXkrSS6kO5xNO1U1nFWXPR/pcF03rUG8MGDCddFWGiQN3FeW5ER/wWg8XFjqsJHrgG9Ri+xTO6YGT/aGWn4KC4jM6BKW5/UfUGnIgMD6HTaAML+zs9iu0FwO3VyLY2VhI0MFVaL2bLBBvM7jT3C90uB8Kh9xrfy+iT/AwhgGX+0ZFbVBsQetyTlsON2u7rV8kFJaIdpbff1WOvmAv/OWA9gqAWTiG9BKmEnzzZXoHM7M3x9TAl+4euBbz1Ua2tSwdj6doBjLir+ZULaeCBgLUsQNuDzcJv7xBLx4S0wWUyQvXsoZuZgrU5e2kju+1rk3O/ncJ/wQAue+MDyhxXt/liL00go/df6c36RELNp75J70wstu26teoAb7vtAuYb/sqy3wwhGTdU9QsPfdIzyoxSfHkhXcWdw/03DSaoBQBTo12ax3iP7tiDgM4fjQOiCwEXCvqBFpENIS5gT2IKAMVLrohyh5t4jairhlKCKLTRqX+veCWjjMUZut1oY0s8yXiMqo2iPcpQLYtIF+05/6SL3/3K+mLRyV4o76ZuPyqUTY4/dFzW6d/VXeu1FeiGnoNPt2GDeAX9j3yFYrQzyjdyOrOB+iEGDlQVO+RBS91IgAt3uVBOH51110jfXGqNf9tnZ0S/rIvG24tBXLlTPxEwEwcQMrp4pliPbqsnOl4VREJcdB2s7rLQZPa+lq7SGAaxT9wYSxL6fmfcyY1emWJIJPVAKZCRSmRmFNcZDCVkPShzdrBU+i6YfJe9O/usSUWzqJUdfn1lgfo0pgYF20wWmy/xNYqywFo7gZFvJsFUVJlerDDqM7CT6lY4aHRyMhdklK2FZBCIU
 KDQLrnBG
 Axu2afDJ62cZ3l7VHg1yqDacm6x7tpnEKCfLjBbjc3IH6taW6nEqgmRyrBDswNTiniEnV/TH1C3kkbUbbkcSOcwuPOYIW/gFjIOJenHCFv0wd3pNNiAzntQNpl58xFBpF3yqTuFYi6C5sH6I7E+Ydud6NhFesPGhenTZXmkvOWdlOx/ruk7H6AZgN/9dbDhbmoqy+HjA6W10q3wUasAe6N5R9Pcih7T39Jx+qKXjHpe9Bav1qMZVr+gIL/k3C/1km75KSIbRDaECUVg6GiKJybOWnbRzA36mnvWbdT35hkRXSvhYoYidiJhKC6uwHZ581XR7kk65gnErjaKq/nOdxxQuB2UTVVTEvNk+2DzRwplVKu101OUGKVuYGxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add pghint_t *hints parameter to post_alloc_hook() and
prep_new_page(). post_alloc_hook() reads PageZeroed, clears
it, and returns PGHINT_ZEROED via hints.

This provides a single point where PG_zeroed is consumed and
cleared, regardless of whether the page came through PCP or
buddy. The flag is set in page_del_and_expand() and survives
both paths until post_alloc_hook() consumes it.

Only get_page_from_freelist() passes hints through
prep_new_page(); all other callers (compaction, bulk alloc,
split, contig) pass NULL.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/compaction.c |  4 ++--
 mm/internal.h   |  3 ++-
 mm/page_alloc.c | 25 +++++++++++++++++--------
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..6fcce7756613 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,7 +82,7 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE);
+	post_alloc_hook(page, order, __GFP_MOVABLE, NULL);
 	set_page_refcounted(page);
 	return page;
 }
@@ -1833,7 +1833,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 	}
 	dst = (struct folio *)freepage;
 
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, NULL);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/internal.h b/mm/internal.h
index 686667b956c0..2964cdfcd31f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -887,7 +887,8 @@ static inline void prep_compound_tail(struct page *head, int tail_idx)
 	set_page_private(p, 0);
 }
 
-void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
+		     pghint_t *hints);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ece61d02ea96..a4cfd645599a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1863,13 +1863,21 @@ static inline bool should_skip_init(gfp_t flags)
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags)
+				gfp_t gfp_flags, pghint_t *hints)
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
 	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
+	bool zeroed = PageZeroed(page);
 	int i;
 
+	__ClearPageZeroed(page);
+	if (hints)
+		*hints = zeroed ? PGHINT_ZEROED : 0;
+
+	if (zeroed && !zero_tags)
+		init = false;
+
 	set_page_private(page, 0);
 
 	arch_alloc_page(page, order);
@@ -1918,9 +1926,9 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-							unsigned int alloc_flags)
+					unsigned int alloc_flags, pghint_t *hints)
 {
-	post_alloc_hook(page, order, gfp_flags);
+	post_alloc_hook(page, order, gfp_flags, hints);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -3991,7 +3999,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
 				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
-			prep_new_page(page, order, gfp_mask, alloc_flags);
+			prep_new_page(page, order, gfp_mask, alloc_flags,
+				      hints);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -4227,7 +4236,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	/* Prep a captured page if available */
 	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags);
+		prep_new_page(page, order, gfp_mask, alloc_flags, NULL);
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -5223,7 +5232,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0);
+		prep_new_page(page, 0, gfp, 0, NULL);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6958,7 +6967,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, NULL);
 			if (!order)
 				continue;
 
@@ -7164,7 +7173,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, 0, NULL);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
-- 
MST



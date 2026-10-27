Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B17606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=LgqyktbL
Received: by kanga.kvack.org (Postfix)
	id AC9C66B05BD; Mon, 26 Oct 2026 22:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A626B05BF; Mon, 26 Oct 2026 22:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990F96B05C0; Mon, 26 Oct 2026 22:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 641506B05BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA8CD80338
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:56 +0000 (UTC)
X-FDA: 85366894032.12.D7C1379
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by imf18.hostedemail.com (Postfix) with ESMTP id EFFEA1C0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LgqyktbL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 39RLgag0KCPgpj0nsqtzlmqnslttlqj.htrqnsz2-rrp0fhp.twl@flex--kevinloughlin.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=39RLgag0KCPgpj0nsqtzlmqnslttlqj.htrqnsz2-rrp0fhp.twl@flex--kevinloughlin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCdG6rFn11zBCazpVzMCvIt14BjXcoxSwJ2DZpHTKik=;
	b=ilBpZDcnK8g+PtTy0WjXYVM9mQMjYV142GzQZ0Rl88Q0aGa/WzY7v3e2vCV0AlzgN3PLK3
	3nObXuO8B5z2LvyhJQntb6FHcwLCNlqyiZK3wIiraHWty+pvjOr4Us8Sw7DbGb1A+PA7yR
	elrjEjJN6seYcLgHC8my1mOo3LVSECs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LgqyktbL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 39RLgag0KCPgpj0nsqtzlmqnslttlqj.htrqnsz2-rrp0fhp.twl@flex--kevinloughlin.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=39RLgag0KCPgpj0nsqtzlmqnslttlqj.htrqnsz2-rrp0fhp.twl@flex--kevinloughlin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069815;
	b=K94UnJsWiu1fDmUESiUSwbShlgFgmS4qxwHPeN9/GMyOYzvOo/4w3i4C/e9GoNvZge/MHJ
	FLKHQF2y12PLm5FdkeWoxFKdF0oBpGDa2DiReX7FfvCoV+KX07skhF1p0uqOK0qSS08j4+
	NQjiTCBkspmdsZBlk4roIJqMEAsSdwE=
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-44899f99756so6644858fac.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069814; x=1793674614; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCdG6rFn11zBCazpVzMCvIt14BjXcoxSwJ2DZpHTKik=;
        b=LgqyktbLyHngMc9o65Ts5+VIL0LdjAHMuLutiVlew7RCpYiFkO1w17wjdod4hugY0u
         CqEsiEIwlvhQRXcqBnSRP7ewyzr+Ma2R83vw9t3tzpb/7IJxTU4/KLVj3mOhzj++wWiB
         dcqNPLBcZ+RfA12oWozRCWl+nDVrcaOt4XKA5+3ubLDayEWPxBzvdzy86V0T1sGe4Kad
         shX8KDmNfbgAKuBloreNPVc/Yd/BDo+zriy8K4phODnp0GWhJvloRo7sm3YR9XE8igKR
         SzoTUkaHxjynmCu3NjKEkHbxa9cJrIBzOUS1gxq/mBjYASdPprZPj0x1afFPQkB6mMjw
         FHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069814; x=1793674614;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LCdG6rFn11zBCazpVzMCvIt14BjXcoxSwJ2DZpHTKik=;
        b=ZLXDYkdfAQP7wqq6FJCuNgZjAl9mhqUuDhWcoh254euAA7Myxqrdu3gbe8QxYlSuYj
         wPs9CzsetkULU6jXqjv33InR5420l8udkUppj53Q3ewFOIJM2yMc9jyemC/9OnHLXZ01
         Coh5kdwiKowfE22uA3UrpoGAYeBI1l7IAXgGfRL2Q6lKRUFnJmlwzGMvBwJAS8+FWShR
         xAPcFml7M/CCyqrWOqLAtODct9eKaZIY1zhq0WKprymUqXVBPBNFAXYjI+duEprCT3rd
         zOHtEuIwd+NnfMVivBE/tEujXzBtW86/LncDoTx1AlqRZtr32mURwfq5cayalJDfHJVW
         2Qcw==
X-Forwarded-Encrypted: i=1; AKwUvBw5Szo+2EhqgTuD+CyVs8hJxpHXY0ImDX+Iw7OB+Lz8KQEAAA7BE15DR/qLhEIRD/6S8w7O03nAlg==@kvack.org
X-Gm-Message-State: AFq9FYKm48UfsX1t8AyB+ZHZPbJ1LrdIpgSViNLf2iDbGN+hFNWSexq8
	GwCSh4HqsAYiLME2QuKIAPYwi7bPKRF1CuHAP5+g24Axwp4HFiI2k+hPGeMOq6frEGH7YCWfrn1
	8X4jc/N2MyDwF5YgH/QgjNLV+VZhWbk2dhQ==
X-Received: from iohd14-n1.prod.google.com ([2002:a05:6602:86ce:10b0:9c4:b80b:7605])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1b2b:b0:4f4:73a9:f853 with SMTP id 5614622812f47-55bfff91bbdmr5294339b6e.1.1793069813464;
 Mon, 26 Oct 2026 19:56:53 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:11 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-9-kevinloughlin@google.com>
Subject: [PATCH 08/13] mm/page_alloc: route unaccepted isolated pages
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
X-Rspamd-Queue-Id: EFFEA1C0006
X-Rspam-User: 
X-Stat-Signature: w4cxdspawpq1db4gpukmqn3efzsek94c
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793069814-288963
X-HE-Meta: U2FsdGVkX19VCL+Kg+08bJcNIS/afZeUsNcchuV+CmDgAD1aP2SFWwcc1HXm6e/0Em99zKwlb8gzJzV8+u34cKojLHVc1Mo3cf7DrYXj2hRm/yHyDCSMEsqFLTf02WiyjZP8lfF1nxYjidejmc3hG09h9sVDmzIsH1/XtSVNDeJzKjJceDJFROKduaeZFgzUkKeEyLXO+S5qqSwHj2DiSXcJ64CnoedJnBiXBDoiX09Wh/ELO8agmtsQ4wEwn5ul/MR4EUScPv7i4b2Y+4HMeUR0TduD+PQ6SIl06VQC4nnGlMA9nfeqFkSkSDRiMQzR12I6L/N4yFNhPtbOsfNf7qnNA+CxhC9OySFg8gO7Oc6GUdzEWyKYrNxvHpSDaHBJrdm8Ejf5seBGAFx0Y1fICEbH5BdN16LGHtm0ofj+cEFo48PRO3f3YtsfFRV6Ezz19RIZZABAfZvm5md20u2CsHgt81HzHU8a7OMtmLK2ZOqnGkMWmpLpppfmchhaSKk79mw1+2f95Dyuqj2muZRNrqJS1tFz9bz0+AeJi29S4sJDznL+OG+szEyExrygLR/odEvoG9t6ZOopIe52/QrjcoOcjtzAI/KuMrXDWkKQZqQcy5Oz24PLzpVuBnaMkb31PRYliKyLfBRcIXBfswjHVOw7vHZFH0Utro4OXmRW+rro1M7C3KEu7cHrTYBULWfMKbIm0k6zrXFEc6reviuHyxjddDPvjAJ5teKo6wNr1STa+4l/2n1ZtrcXGThbjWAcaZVBnALL4tDtYotEYg85STacz+oV3V4yMh99tCGdESqwm6haR3kufnROzTloMlKYRFK1jl9aFvbQS9t5VT1FLDfGg4fw6t17i5GcIvCkO76ND0X39lvc3JhHofun5c3wABtBmc238auLvZbi7zlshH3Rp0dX2dGYmO4V+frdhE4cXcZwHDGVmOGMlAadWGx+vAC/1kDgJ3H1Aiv6h7Z
 TQNfpto/
 /OOb1acpT47A9oFgxcpegOz0zduRZ6sPoqB+rP9NMnFIpfRXSpiaUDI3xZkYB1+jHlSGUqlIsJ/HZTFQVwZ6uBalxdBoU8F2OrZeww3XhEjuF76qd7p6bQqKfR7AkLddjxzxpqJBIxsCLM6aFIqbj+R/r9rqYbWhVZqtgHsMPn4ntVgyCnDBGl/gRDOl9jOkBhUzDXLb6ZZyMtPt0YVAR3WpH/YEBPwsLQGd58rNVAzYItZBNiwXo2UKOiHt7MH/M3UsXDolR6Ca6hHaNK422xfPUOy81iNhdWusSWz+rUIJFdzlEnYwR1G8T0I+ocjDnGINsaxsfvvhKSFrELKtmYYWUHqeEe6v59Ql0Ory1yNgBu2+OAvWzsXloP6Me1QMDLD07WvM1vqHhejIKnEFbjj0p6kMhMp3yn/w7lbTKGAIfI/GWQgVddBbTARg6omJvJG69wnYlkbhFnLNV9QwgZ/ud1tTpwclEP15NGobmcCznHCufhB2B6xywZWiARnCfk7DcYDpr9tTyGhQeYMnlWFZ5DaTs7N2JtURKb8rL6WCmfPoxwS+kw992WBi+F53GNPZznry3+jiNxcRNpwl24oS8EfbtG5bvJhF0iae3Me3yt0IeUf0XoHiu1krlJW/mLakVO4I5Yf44OWBEkAO51N/5gAFH5B6MTz2zxGSYK/kf65Lk2qyIS3O9EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When free page reporting unaccepts isolated pages on confidential
computing guests, __putback_isolated_page() must not return those
unaccepted pages directly to zone->free_area; doing so would violate the
allocator invariant that all pages on zone->free_area are accepted.

Update __putback_isolated_page(), __free_pages_ok(),
__free_frozen_pages(), and free_unref_folios() to route dynamically
unaccepted pages to zone->unaccepted_pages via __free_unaccepted_locked()
(falling back to immediate acceptance for isolated or CMA pageblocks).

In addition:
- Extract free_pages_prepare_init() so post-acceptance poisoning,
  zeroing, KASAN tagging, arch_free_page(), and debug_pagealloc
  unmapping run after accept_memory() without touching unaccepted pages
  in __free_pages_prepare() or re-running metadata teardown in
  __accept_page().
- Pass FPI_SKIP_REPORT_NOTIFY when __accept_page() frees a freshly
  accepted block into the buddy allocator so it is not immediately
  re-queued for free page reporting before allocation.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 mm/page_alloc.c | 120 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 85 insertions(+), 35 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 46ae8c6f3814..c10b77304633 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1298,12 +1298,53 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+static inline bool should_free_unaccepted(struct page *page,
+					  unsigned int order,
+					  fpi_t fpi_flags)
+{
+	return !(fpi_flags & FPI_NOLOCK) &&
+	       page_contains_unaccepted(page, order);
+}
+
+static void free_pages_prepare_init(struct page *page, unsigned int order)
+{
+	bool skip_kasan_poison = should_skip_kasan_poison(page);
+	bool init = want_init_on_free();
+
+	kernel_poison_pages(page, 1 << order);
+
+	/*
+	 * As memory initialization might be integrated into KASAN,
+	 * KASAN poisoning and memory initialization code must be
+	 * kept together to avoid discrepancies in behavior.
+	 *
+	 * With hardware tag-based KASAN, memory tags must be set before the
+	 * page becomes unavailable via debug_pagealloc or arch_free_page.
+	 */
+	if (!skip_kasan_poison) {
+		kasan_poison_pages(page, order, init);
+
+		/* Memory is already initialized if KASAN did it internally. */
+		if (kasan_has_integrated_init())
+			init = false;
+	}
+	if (init)
+		clear_highpages_kasan_tagged(page, 1 << order);
+
+	/*
+	 * arch_free_page() can make the page's contents inaccessible.  s390
+	 * does this.  So nothing which can access the page's contents should
+	 * happen after this.
+	 */
+	arch_free_page(page, order);
+
+	debug_pagealloc_unmap_pages(page, 1 << order);
+}
+
 static __always_inline bool __free_pages_prepare(struct page *page,
 		unsigned int order, fpi_t fpi_flags)
 {
 	int bad = 0;
-	bool skip_kasan_poison = should_skip_kasan_poison(page);
-	bool init = want_init_on_free();
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
 
@@ -1411,34 +1452,10 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 					   PAGE_SIZE << order);
 	}
 
-	kernel_poison_pages(page, 1 << order);
-
-	/*
-	 * As memory initialization might be integrated into KASAN,
-	 * KASAN poisoning and memory initialization code must be
-	 * kept together to avoid discrepancies in behavior.
-	 *
-	 * With hardware tag-based KASAN, memory tags must be set before the
-	 * page becomes unavailable via debug_pagealloc or arch_free_page.
-	 */
-	if (!skip_kasan_poison) {
-		kasan_poison_pages(page, order, init);
-
-		/* Memory is already initialized if KASAN did it internally. */
-		if (kasan_has_integrated_init())
-			init = false;
-	}
-	if (init)
-		clear_highpages_kasan_tagged(page, 1 << order);
-
-	/*
-	 * arch_free_page() can make the page's contents inaccessible.  s390
-	 * does this.  So nothing which can access the page's contents should
-	 * happen after this.
-	 */
-	arch_free_page(page, order);
+	if (should_free_unaccepted(page, order, fpi_flags))
+		return true;
 
-	debug_pagealloc_unmap_pages(page, 1 << order);
+	free_pages_prepare_init(page, order);
 
 	return true;
 }
@@ -1572,14 +1589,31 @@ static void free_one_page(struct zone *zone, struct page *page,
 	__count_vm_events(PGFREE, 1 << order);
 }
 
+static bool handle_unaccepted_free(struct page *page, unsigned int order,
+				   fpi_t fpi_flags)
+{
+	if (!should_free_unaccepted(page, order, fpi_flags))
+		return false;
+
+	if (__free_unaccepted(page, order))
+		return true;
+
+	accept_memory(page_to_phys(page), PAGE_SIZE << order);
+	free_pages_prepare_init(page, order);
+	return false;
+}
+
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags)
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct zone *zone = page_zone(page);
 
-	if (__free_pages_prepare(page, order, fpi_flags))
+	if (__free_pages_prepare(page, order, fpi_flags)) {
+		if (handle_unaccepted_free(page, order, fpi_flags))
+			return;
 		free_one_page(zone, page, pfn, order, fpi_flags);
+	}
 }
 
 void __meminit __free_pages_core(struct page *page, unsigned int order,
@@ -2955,7 +2989,8 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
-	if (!pcp_allowed_order(order)) {
+	if (!pcp_allowed_order(order) ||
+	    should_free_unaccepted(page, order, fpi_flags)) {
 		__free_pages_ok(page, order, fpi_flags);
 		return;
 	}
@@ -3024,9 +3059,13 @@ void free_unref_folios(struct folio_batch *folios)
 			continue;
 		/*
 		 * Free orders not handled on the PCP directly to the
-		 * allocator.
+		 * allocator, as well as any pages containing unaccepted memory.
 		 */
-		if (!pcp_allowed_order(order)) {
+		if (!pcp_allowed_order(order) ||
+		    should_free_unaccepted(&folio->page, order, FPI_NONE)) {
+			if (handle_unaccepted_free(&folio->page, order,
+						   FPI_NONE))
+				continue;
 			free_one_page(folio_zone(folio), &folio->page,
 				      pfn, order, FPI_NONE);
 			continue;
@@ -3187,6 +3226,16 @@ void __putback_isolated_page(struct page *page, unsigned int order, int mt)
 	/* zone lock should be held when this function is called */
 	lockdep_assert_held(&zone->lock);
 
+	if (page_contains_unaccepted(page, order)) {
+		if (__free_unaccepted_locked(page, zone, order))
+			return;
+		accept_memory(page_to_phys(page), PAGE_SIZE << order);
+		free_pages_prepare_init(page, order);
+		split_large_buddy(zone, page, page_to_pfn(page), order,
+				  FPI_SKIP_REPORT_NOTIFY | FPI_TO_TAIL);
+		return;
+	}
+
 	/* Return isolated page to tail of freelist. */
 	__free_one_page(page, page_to_pfn(page), zone, order, mt,
 			FPI_SKIP_REPORT_NOTIFY | FPI_TO_TAIL);
@@ -7933,8 +7982,9 @@ static void __accept_page(struct zone *zone, unsigned long *flags,
 	spin_unlock_irqrestore(&zone->lock, *flags);
 
 	accept_memory(page_to_phys(page), PAGE_SIZE << order);
-
-	__free_pages_ok(page, order, FPI_TO_TAIL);
+	free_pages_prepare_init(page, order);
+	free_one_page(zone, page, page_to_pfn(page), order,
+		      FPI_TO_TAIL | FPI_SKIP_REPORT_NOTIFY);
 }
 
 void accept_page(struct page *page)
-- 
2.56.0.307.g5fe7bd680c-goog



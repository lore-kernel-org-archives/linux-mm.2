Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A371BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8598E0098; Wed, 29 Oct 2025 11:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9208E0045; Wed, 29 Oct 2025 11:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDAD78E0098; Wed, 29 Oct 2025 11:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D88188E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81E3512B3DE
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:24 +0000 (UTC)
X-FDA: 84051611448.04.A818995
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id AF330180015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBl9OinT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndK9rgLMnW0lXi4W8q46Dx/IRDzQ0optlFYL4qNTikM=;
	b=PwgR0bxH/g9/zcXdZz5hD4TN5dpDzAQVrjjpVnk3d/EOVkRxpLgMtz7923ecleezhI5PBN
	TwO/fVGCyOaB+2mfYkBjJfPBW6DBUPylSMw83afgEnzEWm6nCCpU5XsHgK61yTuzpNznmn
	1BobqaUZhoa3oPw0AspD4s8k52NLtp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753562; a=rsa-sha256;
	cv=none;
	b=cWP0UocGkpU+XhZb83yWSZrFRNZD1gLI7ogB38ICaMxSEQ4f/LqqzZ3g9dzFz+ClHUPZJS
	yu6+xh4HG9jBgIS5Tkf4BNl8pgS8+/9GGjx0it01YJy9TozijPBVr3ruCahGl/gdpqhVKw
	Urvtn8f+jkot3WiaxLwU4ALsGXGNDbY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBl9OinT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33bc2178d6aso79864a91.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753561; x=1762358361; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ndK9rgLMnW0lXi4W8q46Dx/IRDzQ0optlFYL4qNTikM=;
        b=NBl9OinT0l1dM2nL89wptZjdKB5pjQa5COcBvOvRhHDc9m6yeHlxYXfxpB1dWouuhv
         DxYlzfGOeK82dDIwWNFRnl5R4i7GrVheEHusQ+E2EiaLOAU0bhmCL40waAM47wu0JPes
         B8e1BNVOmcLis09dk3vtcitdfJh1ES3YI8c+VdzCyxcQy5Y3qAtcJ1XRUCuulwaOF1Vx
         90YpAeV8LY12xl0d4O6GyDUqmniya+DEdNcs8/rCv53Dtaa8qfCslpow/gKMjF0loQbD
         oQzFikDIr1ZxddxSaW8X6KSEDqc6PR/vTdpxlrIa+0c/Ffv38XvAeQCrIVVQd8v7GE+I
         LIZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753561; x=1762358361;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ndK9rgLMnW0lXi4W8q46Dx/IRDzQ0optlFYL4qNTikM=;
        b=ArfEkUQW5OItnaAAjwhLoUp3J9lGEmlMtOKG1J837wsYm675BkQqaJum78hchrOrRn
         tcnzYXv0pVtqZLtvPaU+gg+9UecdY6C9PkfnuwpXfY+l9RgyoWYq6FYPJSdKw/moQrfn
         82XbYv5C/DR19oScjpxUTtjUgVp2hl71YVCSpHS0vHUsalTblw0ZdVINAuiLsdNNnLWE
         OVBxizdpTsOuRcSd9VyFk4X/2xOFFTQR3QZswilaEhT8ZfuCjvN+eAo06VMXarAUJsnf
         lpUJe7l3FVIJqK58wpbIY68Q716HlX1sAC2u7vyZGaVFlX8NYl3ReeAsAEJFD1oNxcAs
         6zSg==
X-Gm-Message-State: AOJu0Yw5STYAtS+9aMnV0ND/zocX5rUov22FeR4rhLbnWwTA1O21QAbO
	PhjOFgiVP9urQv0zhi2cxGYPXLGbnInPrkZTL5wb4Tk/pblcR4Kt4Qlg
X-Gm-Gg: ASbGncuUYrtgVSKcRS/7bj72cMnyy0Any92KXhlAWFwZrrNj3gXwdpV1KFLlEOI752O
	UXvqX2lXFlDqDOEQaVHYltWK1LyHKLoljlTmTvRpAzYHS4Ro/KHCwcpGr+SC/PYe9/DzHOn8INw
	SeujkzIeyU+1VNPYZyJHh4wDUXKkWK+BQxYnsJ8b1ygzx+CDtHKjDBuBsrkhKZzeBWnp/PDUZ9L
	C1cxdvTloYWI8bElSVC9yy/WnzoXJHX3ahyHFRxU2ceqL4Yrd1ZP6uQH/4cwyllPwEexNrdnCBj
	z0udNAn4k5rhvsknCHKfRi99PAd/XHU6wHXoE5gLEk30RW5cSjMbs0wPNazLFAFeRwd7/3nan6e
	VhL3iXdls9r2u0fTCsqqAO/k4um+M8BMuomSBeVckZp5b+vnqtZAzOoRF681xM3NS9mjFrrXBKu
	YAiu3+duXIVpi/DCZvQXgc
X-Google-Smtp-Source: AGHT+IFLkRpwM32hzKfCMcykzpH7VmCSQ2IyTOtMyj93WrL2JrbkqW/t9fuG8FuM15oE3b/6CKBLRw==
X-Received: by 2002:a17:90b:288b:b0:338:3156:fc43 with SMTP id 98e67ed59e1d1-3403a15ab0emr4047870a91.11.1761753561487;
        Wed, 29 Oct 2025 08:59:21 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:21 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:31 +0800
Subject: [PATCH 05/19] mm, swap: simplify the code and reduce indention
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-5-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam01
X-Stat-Signature: z4skm75wms7t7cfp8cq5owagpb3esepq
X-Rspam-User: 
X-Rspamd-Queue-Id: AF330180015
X-HE-Tag: 1761753562-120531
X-HE-Meta: U2FsdGVkX18Q0FpFBLcjQIz+d2/euf5RheSXupGdb3iGTVahepM/gAy53MamgHIhtfCNM0yRmK8CIyGMkrpgIUVFirZwu/o7FTqQe2v1OiTnFt5Nlu8x4VHcqd0229ackJw2AEr+d08CLRXwRgwjmeIkgefgtKS5JAc3Ygn8sKklzaEyre1DJVOcxyp6mQmOXX9O7AmP18ncqun+Y4yRjLLPRibIdGbYSx75i/VrmVqZqHge+tOFlJvPiW29zHN5519oGrGFqhVCUUKrcQ1mKZZ94UCQp2R2wHR5HEvCE7Mr/K3/2ZZMAdpfdyJl2EI7nIItaDKzTl+VR0DfSieaBpxRJSSmcwbKmGom8qrFONl//gqDjR6o+369EMGcio4rLQEtjGJQXBlW0DVn7Z5XGEg4qxJbKKSoAUw7hImnifFZthotbE0dQyiLJuKmdtv7zWiktcf6NL6bE8oIxAEqMJ7fQOfzYsP1WQ5VWz0Mnx5HaHznKqldIEZLp+3YE5aqDsAdcu09DG+o+QJRoW5z0WkuUC3px70GXQwCKNZh/RyZyqQsTLZ4KruvjxtvK2GLlf7TnbxRpqpVZwZQId8V8eKhyko8BANj6BliyjseLEqJbmHWI+egOODzG9wcqY8So7lJVb/e3ibWm8DkJg9UxNsC0lIjJoBGaPQ9+bQ7EIXadeLXjS7lV4Y3aaiP4PP8HfbtIemTRwlxXzo69DSEWY2byOLoWNgvwrPXKnhm/w77xeAwgfVv88vkvAry0bQ3cIoKksSjZKEtuT3u/ys2xQIiJ+uZ3/XFYsF8RHxIsGNppNOZI+sIXrR9lWOudNru01u7DcaxZTpHBZW/cvtIRL50RnurK/KzXjZ0jienYqFZnYyXDHmKNb5w4N9WD1CuDQ5FUVdf1KFvw4HZ4IHyv1Zf/uqZY6XYcpHlFRHiJyjkXBsvltp6YvFOciLlQ4woiknHvkH/a2nZyEKx3/Z
 Pbn5b4hK
 /xBYf42aPI+2ZrASGOpnECTpvw4C3v5Cdf00Tq9aGXNsjOrCwUrYqfzYCAzeQr7b+pK7xQm3jq0qAsnLgECkBEj+a5QqAqL3Kf/NZgLfo7BAqewE5jo5NS0lljblaCM8dtTeQwKGarkKO3B/T7nH6kalXT3wF1pxPcK205PrgnUl7T+E1+Tyd+2MoXdeXXua7LPlNA+G1zoExNtShwiaFSJH0A7v9JitmSv6OcR2T6BDiwQodecJ9PbWEo7u8TcVanohwzhu0/5NX+S86Wcamt957BZCEXQgA2+4gVYIBvLn0UT5TqSRxYExWhNQdZJvLqJkt7MMOKHs3lQvc4UMdfR0p6G3uEukVWlobNJhFGrN0IIXlVl9OetQG7pwM+81aCoUFnCFoBrSjQQonJLggDr/Wkq8PBvuFlq2GbfkfEapYnIQwJgWmdBemmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now swap cache is always used, multiple swap cache checks are no longer
useful, remove them and reduce the code indention.

No behavior change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 89 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 43 insertions(+), 46 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 78457347ae60..6c5cd86c4a66 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4763,55 +4763,52 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_release;
 
 	page = folio_file_page(folio, swp_offset(entry));
-	if (swapcache) {
-		/*
-		 * Make sure folio_free_swap() or swapoff did not release the
-		 * swapcache from under us.  The page pin, and pte_same test
-		 * below, are not enough to exclude that.  Even if it is still
-		 * swapcache, we need to check that the page's swap has not
-		 * changed.
-		 */
-		if (unlikely(!folio_matches_swap_entry(folio, entry)))
-			goto out_page;
-
-		if (unlikely(PageHWPoison(page))) {
-			/*
-			 * hwpoisoned dirty swapcache pages are kept for killing
-			 * owner processes (which may be unknown at hwpoison time)
-			 */
-			ret = VM_FAULT_HWPOISON;
-			goto out_page;
-		}
-
-		/*
-		 * KSM sometimes has to copy on read faults, for example, if
-		 * folio->index of non-ksm folios would be nonlinear inside the
-		 * anon VMA -- the ksm flag is lost on actual swapout.
-		 */
-		folio = ksm_might_need_to_copy(folio, vma, vmf->address);
-		if (unlikely(!folio)) {
-			ret = VM_FAULT_OOM;
-			folio = swapcache;
-			goto out_page;
-		} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
-			ret = VM_FAULT_HWPOISON;
-			folio = swapcache;
-			goto out_page;
-		}
-		if (folio != swapcache)
-			page = folio_page(folio, 0);
+	/*
+	 * Make sure folio_free_swap() or swapoff did not release the
+	 * swapcache from under us.  The page pin, and pte_same test
+	 * below, are not enough to exclude that.  Even if it is still
+	 * swapcache, we need to check that the page's swap has not
+	 * changed.
+	 */
+	if (unlikely(!folio_matches_swap_entry(folio, entry)))
+		goto out_page;
 
+	if (unlikely(PageHWPoison(page))) {
 		/*
-		 * If we want to map a page that's in the swapcache writable, we
-		 * have to detect via the refcount if we're really the exclusive
-		 * owner. Try removing the extra reference from the local LRU
-		 * caches if required.
+		 * hwpoisoned dirty swapcache pages are kept for killing
+		 * owner processes (which may be unknown at hwpoison time)
 		 */
-		if ((vmf->flags & FAULT_FLAG_WRITE) && folio == swapcache &&
-		    !folio_test_ksm(folio) && !folio_test_lru(folio))
-			lru_add_drain();
+		ret = VM_FAULT_HWPOISON;
+		goto out_page;
 	}
 
+	/*
+	 * KSM sometimes has to copy on read faults, for example, if
+	 * folio->index of non-ksm folios would be nonlinear inside the
+	 * anon VMA -- the ksm flag is lost on actual swapout.
+	 */
+	folio = ksm_might_need_to_copy(folio, vma, vmf->address);
+	if (unlikely(!folio)) {
+		ret = VM_FAULT_OOM;
+		folio = swapcache;
+		goto out_page;
+	} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
+		ret = VM_FAULT_HWPOISON;
+		folio = swapcache;
+		goto out_page;
+	} else if (folio != swapcache)
+		page = folio_page(folio, 0);
+
+	/*
+	 * If we want to map a page that's in the swapcache writable, we
+	 * have to detect via the refcount if we're really the exclusive
+	 * owner. Try removing the extra reference from the local LRU
+	 * caches if required.
+	 */
+	if ((vmf->flags & FAULT_FLAG_WRITE) &&
+	    !folio_test_ksm(folio) && !folio_test_lru(folio))
+		lru_add_drain();
+
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
@@ -5001,7 +4998,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			pte, pte, nr_pages);
 
 	folio_unlock(folio);
-	if (folio != swapcache && swapcache) {
+	if (unlikely(folio != swapcache)) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -5039,7 +5036,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
-	if (folio != swapcache && swapcache) {
+	if (folio != swapcache) {
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}

-- 
2.51.1



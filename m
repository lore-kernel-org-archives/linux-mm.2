Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C600FCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8E36B00A0; Tue, 29 Sep 2026 17:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667256B00A1; Tue, 29 Sep 2026 17:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507F16B00A2; Tue, 29 Sep 2026 17:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6936B00A0
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FBFE1C3415
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:35 +0000 (UTC)
X-FDA: 85268151990.24.ED547B8
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA946160006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H5fCSGYU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3XDO8agoKCBE4z2rFCrz9yx55x2v.t532z4BE-331Crt1.58x@flex--nilayvaish.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3XDO8agoKCBE4z2rFCrz9yx55x2v.t532z4BE-331Crt1.58x@flex--nilayvaish.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAMB3W3KRBdsKi3TzRfB6ZNmdd0wTycBXYPw/qJaC3E=;
	b=l1eDrxjYKecuvYkowRQ7g6uM/R1b/738kBUu97aWKHIozl/ZxR3F2UgyQlf2NATWHKZiWa
	NMD2yun/LyxwlRJdoGszhxJPebHUr70T6T5tOIQdfqWFD9fG4dZP9YKS2Po66zDN0bumgt
	hP/tfVZczRBC92AW8Ty7t2sHoyao8mU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H5fCSGYU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3XDO8agoKCBE4z2rFCrz9yx55x2v.t532z4BE-331Crt1.58x@flex--nilayvaish.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3XDO8agoKCBE4z2rFCrz9yx55x2v.t532z4BE-331Crt1.58x@flex--nilayvaish.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718813;
	b=qf0XIqsokr8eSPkBfD/CDZ3GohwqRX9xrvgpFzr/WC+hhbdSdT07XHmTL4w20Q6xvSof6q
	wTck7CIMncVBqa4jZftRO31CidSKVZAjpmvJvJRaArXb9nJ8OASEyQgmR2SsdtDQ++lmiG
	iD9r0MIrxtBmTSb2m/R/bqA2S0Et3JY=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-34afa104860so1779462eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718813; x=1791323613; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pAMB3W3KRBdsKi3TzRfB6ZNmdd0wTycBXYPw/qJaC3E=;
        b=H5fCSGYUIBByHj6TNzXPbzkXRACaU3fpJW6eOJ2UA39VFaJnK7ffZF/Mvtd4h+4gJe
         h0NC1Zpyn4s4+iZpOqyOezTB7qjnYV5w2ifkq/RQ7rdXxiVLoPHX22W6mbjzlZtX0lKO
         KVsVabSPkjsNuH1tw1M2EAcZVGcc0amf3rblqYiAw2tfNJx2T22B/o50opuH6oBkRha+
         RTL5bDlJhZaibOIP2AZ5hcZpS8sQb+/Qbavp5zNtMjzVSsDM/XO72W/hT2h+w59Bc4ij
         lanA8vEk16j9svukW8nunQciL3A2A/MkT6oL7vQR/LooU6sfcH5yqFN/nQkgZYDKZoTW
         MIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718813; x=1791323613;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pAMB3W3KRBdsKi3TzRfB6ZNmdd0wTycBXYPw/qJaC3E=;
        b=XZ9VZxtNiOcbD7LwGCcjUlTPEFLylQgKoJQVWaHEfG92sv0TvNhtDZrosFaYKclTXH
         mPsVaZTeNHdAs4HMZcTdLN6BEbxH5/M9xlVXAjOD2d5dN5gjTTlP1XS5wvmPKYl+Url2
         2xwMdspjU3Xh4QvB2BXJwXefNO8tGbph2v0qNZBApOpV1Y2ZyTI4JJqU58tYA8yYT0go
         weEIjda5dGwAEk0PADPe36CYSJB7M7z1JynKIjFkOei17ATinMsUWw0jTZG6RlE4OkoX
         2JqeJuVnk/NHjKu/uHROFY4E8978fjUQgKC2H680tkxS7b5Bbff9FyQ7M10+sDl/tjTT
         11Ow==
X-Forwarded-Encrypted: i=1; AKwUvBy4Oz6Ij7yAnQk//PvrbMfgIBApxbJZoDF86PxB3pQu0g+W+TEahhO7NWHn/IVBv+NUAoufZOpIPg==@kvack.org
X-Gm-Message-State: AFq9FYISzUyev4dhT86+66PQg4yIO6ENtsFL6smisA1nUUFoxNWe3FRM
	aThx1h7S65LN97m3aNCYcjH+cEGjToBVo6lrI9anB4NMI1FPPEH8bMB1sirsNxkFJgZdDriAVMo
	jCxpkYlIN1gyzCWq4PC11nA==
X-Received: from dybhi53.prod.google.com ([2002:a05:7301:29b5:b0:33e:4e3a:51a8])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:18aa:b0:342:5098:a983 with SMTP id 5a478bee46e88-34c6370d985mr650471eec.11.1790718812376;
 Tue, 29 Sep 2026 14:53:32 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:52:02 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-12-nilayvaish@google.com>
Subject: [PATCH 11/15] mm/rmap, gup: use folio_page() for PageAnonExclusive
 and gup_must_unshare
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 1uo5ccbareb197sj71sob6o73byshwsp
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA946160006
X-HE-Tag: 1790718813-721020
X-HE-Meta: U2FsdGVkX19mnSyKV0p7N7GeWZXv/UVn6HalWMnaXywh3wQf1yxwEkXmhQbrWsBexb5KmpF611OlGLg6b3SW8ae1j5NrC/+o+EYxbD7brQ71WmVqIeBHJu2fusL/1/A7JF/XUpiuZclD0AO62rOw10BEKL4hjwKvo+2IR/NIsjL8ggLFVWzoyDfPTEhCfmSy6HTrGkjJtZQN81p0LobHt6cCanWg5sQaJTRgbcQQnzkOG9MAyFTEgFCVpFqyTSOzPwP6fceUzfS1U+qO2BUY1Ju4xNs7qZxH6P/qzhZeZ8QBOjQIeEKR5TdYlxSPfTqqNahQUdYvIZvO6hSNcIucpnZU0OSs2nElOHYzJEcdNihgRFVOYgdV5wC639MmrCPlgYrnTHAr9YHuQNPwMfv2R6meaptwezDLc64WSALPYWEYVGA306OETCPebj6nQ/l8loL4wWpOEcgql23XtPooIBXr/cb8dw4hTmUjx+jWIKZkIw4qHvSRZQ1l67WxJsHb4izM9PJV5On/3GxlGsDuXoVo/3XTCi3Tu8J+LRAyslBxjWliJykLmhFTQ1fwGTg3NP/cHlxaHcMuMxE1pFOprVS5mkwDPwL+AWJOjvxBiXrmkF45uhEGXiUXchQOQVz9oq7qzqQVUX+PILtbDxFy6uAtxSnDg8ZDaefG7Lc3AsMX86/T/NJkGixZc4SvKZPtjvS0gPpdhfTpu/IbC0pw4T8U3VFD1oN7WTHrMIhau9OAFNNX6bj6ytl/rVy6HR0moYTHb2sMXAz33Rq/3z+NOxJ/GF0jUDJrnCwhNQaoHnS8zYIaz1kPzapvrzpzdryennJ9T6dqeoBhOI+XILhmP5hHZ4izJb1Co9sNcJM71m0Snhd1EuK688Sm0fxUFoZe85tYyI4jJGZgpO2twRzNUKKfHnFlCsPQRNS7TCWxHjMYPFytgJtEzQa9n51iiHcjKIhCaYRZFTQM33NimZq
 g9+34FPa
 MmYeMb1/bCxblSbJu+RE1WZdoTg26WyycF/6+NMjic9urNUeeY2EptLRsVzO5mcHJUZWJM3SzzoCH5KmzNvWYEGHTMvDYN/wCPCTTMlN0HNgoELehxwEGcUdgcCMwtFJfYL06PHs9bYPdhmoDcR70scil7KcvbER/z1zPHfI8Vws1SWU6BlFMVy/bH8gsPZ1Zw2zHmoxHmvljH13a7NV5qRn9jim2wQXH/t2dEerhoRq3GRgd+QBdHCxeLrWiqcMa7FIMVShichZ1izNWkTYkq9hJeFjibuzVA69LIPo1mRjNteDID5UweEgIi8csT3xB9JMO/KUR2Gu/iXyljIUpobYjLDSvDNm7oXsy/v88Ig6MF/9XZIMJWK6wsoTcrzOJfdglQvk3hSLWtPsmBp0Yw1pYvhvTL0dMO9S+QVwXf+huWeJJdIpodludOWw7WMsv0f9/CH+vldw9nDFkFrCDgX6nfI5Co83x56C8arA+W0AJsAuqnh4gFwMpuwj/t20Bp7z4lo2x+2yvEbNltwSWfnbP9wF9PXE1vur/suZ/RDXdpC2DSABLYiySmoNvg0AFfCf4ku0RK2jlLvS/6xI4GZjRiP3RYNhHysn4fSFW81g8SkB2QLxb//fXdZbHlEzE8SYPNqHbd3EgoExTQPXttzWrOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace &folio->page with folio_page(folio, 0) when checking or setting
PageAnonExclusive() in folio_add_new_anon_rmap(),
hugetlb_add_anon_rmap(), hugetlb_add_new_anon_rmap(), and
sanity_check_pinned_pages(), and when calling gup_must_unshare() in
gup_fast_pmd_leaf() and gup_fast_pud_leaf().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/gup.c  | 11 +++++++----
 mm/rmap.c | 10 +++++-----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8e9ef5ee7498..1ce7ea5e7abb 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -59,10 +59,11 @@ static inline void sanity_check_pinned_pages(struct page **pages,
 		    !folio_test_anon(folio))
 			continue;
 		if (!folio_test_large(folio) || folio_test_hugetlb(folio))
-			VM_WARN_ON_ONCE_FOLIO(!PageAnonExclusive(&folio->page), folio);
+			VM_WARN_ON_ONCE_FOLIO(!PageAnonExclusive(folio_page(folio, 0)),
+					      folio);
 		else
 			/* Either a PTE-mapped or a PMD-mapped THP. */
-			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page) &&
+			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(folio_page(folio, 0)) &&
 					     !PageAnonExclusive(page), page);
 	}
 }
@@ -2957,7 +2958,8 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
-	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
+	if (!pmd_write(orig) &&
+	    gup_must_unshare(NULL, flags, folio_page(folio, 0))) {
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
@@ -2999,7 +3001,8 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		return 0;
 	}
 
-	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
+	if (!pud_write(orig) &&
+	    gup_must_unshare(NULL, flags, folio_page(folio, 0))) {
 		gup_put_folio(folio, nr_pages, flags);
 		return 0;
 	}
diff --git a/mm/rmap.c b/mm/rmap.c
index fbd66a2823b7..cd1cf570c770 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1668,7 +1668,7 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_mapcount, 0);
 		if (exclusive)
-			SetPageAnonExclusive(&folio->page);
+			SetPageAnonExclusive(folio_page(folio, 0));
 	} else if (!folio_test_pmd_mappable(folio)) {
 		int i;
 
@@ -1694,7 +1694,7 @@ void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
 			atomic_set(&folio->_nr_pages_mapped, ENTIRELY_MAPPED);
 		if (exclusive)
-			SetPageAnonExclusive(&folio->page);
+			SetPageAnonExclusive(folio_page(folio, 0));
 		nr_pmdmapped = nr;
 	}
 
@@ -3187,9 +3187,9 @@ void hugetlb_add_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 	atomic_inc(&folio->_entire_mapcount);
 	atomic_inc(&folio->_large_mapcount);
 	if (flags & RMAP_EXCLUSIVE)
-		SetPageAnonExclusive(&folio->page);
+		SetPageAnonExclusive(folio_page(folio, 0));
 	VM_WARN_ON_FOLIO(folio_entire_mapcount(folio) > 1 &&
-			 PageAnonExclusive(&folio->page), folio);
+			 PageAnonExclusive(folio_page(folio, 0)), folio);
 }
 
 void hugetlb_add_new_anon_rmap(struct folio *folio,
@@ -3203,6 +3203,6 @@ void hugetlb_add_new_anon_rmap(struct folio *folio,
 	atomic_set(&folio->_large_mapcount, 0);
 	folio_clear_hugetlb_restore_reserve(folio);
 	__folio_set_anon(folio, vma, address, true);
-	SetPageAnonExclusive(&folio->page);
+	SetPageAnonExclusive(folio_page(folio, 0));
 }
 #endif /* CONFIG_HUGETLB_PAGE */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog



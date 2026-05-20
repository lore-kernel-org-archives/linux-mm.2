Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E53F9CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D70C6B00EB; Wed, 20 May 2026 11:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187516B00EC; Wed, 20 May 2026 11:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CAA6B00F4; Wed, 20 May 2026 11:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB64F6B00EB
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:17:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3C04160B7A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:17:00 +0000 (UTC)
X-FDA: 84788151000.04.E0A74E9
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A62B14000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:16:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qyIXu3fY;
	spf=pass (imf09.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779290219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HRK/2n7aSflmkUMt0ioC7IYMvFFnRR1GUnQPCT4nJ7o=;
	b=wNMdBDxZfZDRTizeTEN2eHl3wGnLdW4EI8nKVAajcTR0A2qcgDmkQYjBfGLD5vW9e/+E5S
	Pw5qYV25j5bGDV4GNb8Uqs9+qWvAQ1x/yW+MLOtKIJhTm7Km7z0/3RG/glMqXA8LWmb2Hl
	HmrW9JAiZHEDexEl/b2x0XMuCamAOuw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qyIXu3fY;
	spf=pass (imf09.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779290219; a=rsa-sha256;
	cv=none;
	b=x08Yr01dgSmn9OG7g+GJrjmM/zACGVmSkimgKT8PzLdtNohgGyEa7V6Bk5EYxeeudxRlUt
	q2PfEcCihrMqzolLT9d+kfrIdMoaf93JsLMTP4DvvT7tm3sJXp66LYgnrKfYt2YkVXBN6X
	lgq3+2eDihEI62owdklFnLdg61o98eY=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b9e9a6802aso20956195ad.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 08:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779290218; x=1779895018; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HRK/2n7aSflmkUMt0ioC7IYMvFFnRR1GUnQPCT4nJ7o=;
        b=qyIXu3fYMWv9lUyjImt/bxRZ1+crJRkMusvhPS58u+q5kddLlB+tR7lwyQGuyoBqgW
         d+Mbttvly9bLPJNRwsgPN9IiKpr0+SbAwKIqimMCdhEaXhnsZGNvPf+z0kmpFC5VyAtO
         AsfRxdtOWsXsbjZWkrna/fpXI48zwMCySB0YsXSTASyiQdtY1QxWwdAWQKg8+UqM53uN
         4vLke5dmUR8EI7sRw6dYZtraLiALaFsf9FE8TxQ/X8oxaEe/IhxT8WbICaMBeJCPE/gS
         cw+rowBGGceI8A09waBkXFAwEfJEsxvNKs0d67PUSOPB09ocZOjzZCL7CjR2lsAGRiIZ
         u+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290218; x=1779895018;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HRK/2n7aSflmkUMt0ioC7IYMvFFnRR1GUnQPCT4nJ7o=;
        b=CknIsnHwTzm3wg8b5lBIZjsIXTDPxAdlqVaxMhnhYSAecdobd4ogLl+6kmBzt1Pj/d
         jVLmtbqwJ7o/0Naht9ezrcEFW6z8HQAAN9VkMwjMuWMPukDJGcKQ+M3n73YnlJebOhLZ
         2CYvfWr+Xi6pee9B3SVSLvlJLr/1VNR+DgQEymp4FnQ4CbHMxHGqucoKzd9DFuTbSUIe
         Y87IfbuU71frx/8w0+89C1A00LgB3IuCcPjHZG0wNpOx7PK5/IxPJbIShH7pCemkkh3u
         MXTKL/51oQrqCoTSB+CUXnY5YIqtNgpjKk1kecNTlug/zTKhAXMX/fkt6+nJ/G83M9eu
         LsOQ==
X-Gm-Message-State: AOJu0YzuSHr2EydaZw3BblUAJ0KRMh5MSaCksTwQmavb6A1ijf/3QKZy
	zdcE7OTAE+66JHTK1Xug0vKyc8y8+fwyyrLSMduN7vUF5yfnW5HgxKDdUXVtTXOHOf8=
X-Gm-Gg: Acq92OFXJMH6hAXRo5MVcYqZLhbKEcnxpjGTpFYLcPDwLnBiZzmiOO9jQ3McWVTHifJ
	W4Uge+LQWxrwkL4OtI9EKLO1QLejGQGXh5FQ3FvrZe2KJB1V89uKuag6bjg/5R60YiU+h9vK9ML
	D6u3LSlQEkhZFySsWyFbfwF7XrNPiJxW6BUpS6Ol21Vz0Ibzvjn/UpLzSIfbiv88U889obsB2zN
	259qNLMbFFvAw8cN0ligjPyZpBAUKXjDZ/A45aGUEPRYfkShodd8lxERe3KPPPxjI/+x+RimR2u
	MDBiep9A1on5M5oFkZKWbpaYixCnnK8prQt8jl860448iwzs7V+ms6gb1dx084faCn2fUwkCwHC
	t9DsOJKeR9gSsPT6rv+6CwnbD++RYXhjsTknP/+iH/WFBepXlqlfhEsx11AAWzNNcIzgRshy/H6
	EWtXzVVrM9RWFWLkAFg0IUTIzAlYMLtFCT7vPZ8Zw=
X-Received: by 2002:a17:902:c406:b0:2b7:a1ff:b239 with SMTP id d9443c01a7336-2bd7e847effmr258697415ad.14.1779290217668;
        Wed, 20 May 2026 08:16:57 -0700 (PDT)
Received: from localhost.localdomain ([240e:390:6ed:f081:3ad9:490a:885c:dca6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5b568cefsm224364315ad.0.2026.05.20.08.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:16:57 -0700 (PDT)
From: yizhang089@gmail.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	david@redhat.com,
	william.kucharski@linux.dev,
	karol.wachowski@linux.intel.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	liuyongqiang13@huawei.com,
	wangkefeng.wang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v3] mm: do not install PMD mappings when handling a COW fault
Date: Wed, 20 May 2026 11:16:24 -0400
Message-ID: <20260520151624.78370-1-yizhang089@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A62B14000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 7dmqpe1f3ni7cbba81t9u6qd4zcyxm9s
X-HE-Tag: 1779290218-171050
X-HE-Meta: U2FsdGVkX19tylLLe/WjZYTkpKFy0SKQMnVrw3HAGTQ+lDCpJkhP8jGwXBjyXv4PlrhT4ncahLkWkuweOCqPA7l+7eCQuiRSle36IX2DU8KvOhk9I+KcNB3Ks9fPlTQ0pgLm/JMjibyu6fzK8En4tlBLskIFrynAnkdHAhugaBWi08DCbu000+/KfCSitbsyHpcUD/oOkycTcZESI7KUId32l/tr30DJ7WKzafRNxR+UG9/us/bygK4FLWZWbxiBdiueLwqjJFi4jF+TnmjBJ+4F4V3Pu4CucwPH+XA1mVLq7iY8OaydxoU286w4N7n4mqv6+0Dmu1is99xeISbccHj+t5ZokiSjnot3PXwnL7GPheUy3iuQVK/8xQXD97dTx1wiU/YrFsmtObh+6M3D7MvlyPMmBWLmKVaq45yM9xlClszXDYJxYMdnQWVCxZugJXmH1t0cwoYF3jae+8P077nheXIsf+hXH9kiumJ/fVuFOo+c1KU1UrPgUkUQMx1EBKKZAGUd37jv17wMEDFOepc2ywJVnKLHp1/fsBGzbZFB8+iCFMtlmAWU6GPyOHqFHXr3CbEZlqkgZseOgrV+/ZxspVaw9oO863gsFpYyRZVx28Cry1Kuv7DL74Dr5rncKqXAeLaVNyaD4+btrA5jJ0ZsZjgjHApAEUzB89u2gMFTXvd/7Y5qDMeIhwqbjhmkv6XH+Iul0JF7UYeBAYOfI6k/WsBcXpnPF1p5D5CaNEjRwEPMzxex4LEr8xuGQrR99KgXPP3uWHK+O5ku2KkB1LPjk56sMwdc/UGHsOA8xnnucHYFBVTRi5aIihQ+jauIajRP9HiimJrMxsRPKlgAwsmFQZ4VbnZWGBqYOv7dXG1w817vDgmFbPCWVwQ5g0jRP0Aul0VBmYY7DXydj0lI9NJ4jnTrp1P2Hv8OXs+zHb4CsXPYOZhYfEivIvgNzGgBkMmhj+E+5zE4crwktpE
 fVfqI+Gi
 ms8oI4gO/VLA53waBUAXPkpncAj4VBf9qY1h8RYtJQmmNUXxaizJOBHxHYLEjt9By7duPhRohvehcZ7gRtxFkUvKwnLmCocVq6IfKqdTjDZXKNZ4wpDC0LG22pmM2E7uNnFDqoxvnuiHwG1CcwmSpdP8xH2NPNZUM6gDYHxRgEE29xeHtcUDC1lk9RLOFfXg8DepEUfuoLHFjU/Ed3gNMfXLxO3KRtLtFauvuz0ISyV6cxZrdt5kPrYQxZZuZlzTVu9ZAG2hniwOtld3BZF9WsMpZ7MiQ+BzeTHcxADodag4xXxZmfkwFUA7DKAZ4YKQRT27hlXN7kf4AsukTmN+EIUM+udiDnvnObg/l+Zv1JA4cY4b3jOYkHRuyoPWhmp9mZgsX/OXhbrF6Ajvx7I92dB9bOoQ1sokI2osPTReL5h+0E0x8WiB7AnGXAmJWNd+6CnGos5G3rm6tnkQl7iSj/hyP4tfHrbdoaabDnuKEsjr3rRaUsie6IvOH6m6B0wSWhXvZWRI5fDDstyWar9BVfE+b0MD9a88bhc4lkx2q24ctU5/rfcmNwDj7AbifSBwCrnRpX//CQG3ZgUpUgF7sYe4bhLpGJx+hqL2T+ixWD5nfljk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

When pinning a page with FOLL_LONGTERM in a CoW VMA and a PMD-aligned
(2MB on x86) large folio follow_page_mask() failed to obtain a valid
anonymous page, resulting in an infinite loop issue. The specific
triggering process is as follows:

1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
   has a 2MB large folio installed in the page cache.

   addr = mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, 0);

2. The kernel driver pass this mapped address to pin_user_pages_fast()
   in FOLL_LONGTERM mode.

   pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);

  ->  pin_user_pages_fast()
  |   gup_fast_fallback()
  |    __gup_longterm_locked()
  |     __get_user_pages_locked()
  |      __get_user_pages()
  |       follow_page_mask()
  |        follow_p4d_mask()
  |         follow_pud_mask()
  |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
  |                            //huge PMD is installed. This is normal
  |                            //in the first round, but it shouldn't
  |                            //happen in the second round.
  |           follow_huge_pmd() //require an anonymous page
  |            return -EMLINK;
  |   faultin_page()
  |    handle_mm_fault()
  |     wp_huge_pmd() //remove PMD and fall back to PTE
  |     handle_pte_fault()
  |      do_pte_missing()
  |       do_fault()
  |        do_read_fault() //FAULT_FLAG_WRITE is not set
  |         finish_fault()
  |          do_set_pmd() //install a huge PMD again, this is wrong!!!
  |      do_wp_page() //create private anonymous pages
  <-    goto retry;

Due to an incorrectly large PMD set in do_read_fault(),
follow_pmd_mask() always returns -EMLINK, causing an infinite loop.

David pointed out that we can preallocate a page table and remap the PMD
to be mapped by a PTE table in wp_huge_pmd() in the future. But now we
can avoid this issue by not installing PMD mappings when handling a COW
and unshare fault in do_set_pmd().

Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page")
Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Closes: https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@linux.intel.com/
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
v2->v3:
 - Update comments to clarify why we shouldn't install PMD mappings
   while doing CoW.

 mm/memory.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..b1aed4f08224 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5520,6 +5520,17 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
+	/*
+	 * We're about to trigger a write or unshare fault on a CoW
+	 * mapping, breaking the shared folio into private anonymous
+	 * copies at PTE granularity.  A PMD mapping would bind an
+	 * entire PMD-sized range to the shared folio, defeating CoW.
+	 * Fall back to direct PTE mapping.
+	 */
+	if (is_cow_mapping(vma->vm_flags) &&
+	    (vmf->flags & (FAULT_FLAG_WRITE | FAULT_FLAG_UNSHARE)))
+		return ret;
+
 	if (!is_pmd_order(folio_order(folio)))
 		return ret;
 	page = &folio->page;
-- 
2.52.0



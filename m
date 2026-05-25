Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DACCD5BAB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF336B0093; Sun, 24 May 2026 22:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0BC6B0095; Sun, 24 May 2026 22:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EAA6B0096; Sun, 24 May 2026 22:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5EE66B0093
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:52:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5630B1615C5
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:52:39 +0000 (UTC)
X-FDA: 84804419238.06.A578B73
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22B03100011
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:52:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Ikjb/ncj";
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779677557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zj/X4pvgFZcL9zGnArV+92F7pzdoDEC4xvQFc9PbqWU=;
	b=op9sdjCvf5ztXEWubQHoKbl63Krd14khMuZTe+kGyXS5Wqqib5faNpkQildNJgdH9daB9D
	pIkq0CpRj4sIdRCQBuZTAq7pB4/snJh64hAURRshd+dL4Li+dUQD/QdFrLKNwPwXkkZ4fj
	iByTIapGKHuxLI72gY5YJD3CeXvyjsI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Ikjb/ncj";
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779677557; a=rsa-sha256;
	cv=none;
	b=LD6XpW+sIucsxP0bDZAr/LxEWo2Ls09ax55f9TdOWzWE5y7sexLeM0MN6yn1aqTm2hLhek
	PwQodTHU7wCMgSn9Xr8cnf+AvtrLmBtEERkvLf4EGfXx00VlnB5T51/QJL3/C+KMPeysGs
	DYdmQTuAHGuCw9xb1NUXgkskUbrLfDQ=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ba6485d219so69798515ad.3
        for <linux-mm@kvack.org>; Sun, 24 May 2026 19:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1779677556; x=1780282356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zj/X4pvgFZcL9zGnArV+92F7pzdoDEC4xvQFc9PbqWU=;
        b=Ikjb/ncjfCXjqyuc+jcetRZSfmJVUDl5tOpGZl+b4ek88KwXmFWr7YvKYYKAQx8016
         oAAOQxn4T6X53JoI4UKloxGH0M7RMKyhV5LtIZ64gndNqXaaxaJ6B8G3A/vygUzhFhLu
         z0JLwNzPxP6bjSUwi2xRfDz6DcL0mx5lMax+UovtP8gA4RpPnW/5nrPXUMd1mh2dQWhX
         x4khkAirHg31wvZRQNDpbyFBSbhIHLzMFiWfNlJcrQbWFPRjENI7HFOLJUCDicbWvXmx
         QUvkIUVIL/ZCQPCz/CmRYoTAGZ5Ld9/b+8k7lJRJ6nLiliAJCrqPR1r2Ue6zyReLdqMU
         7Dlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779677556; x=1780282356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zj/X4pvgFZcL9zGnArV+92F7pzdoDEC4xvQFc9PbqWU=;
        b=op7S1XQ7P45Q5GHPHVmcp86g7f8qAIC3oTNaUXNLmwk4HWC43LnFcVpfMlDDQUz9Sk
         cdlRZtXqAEY9F/SxKM9wKcQUIf7rIQ3G9dZNGmmIv3RD9RwhA0/OcIwf+R/KmnBPSkEF
         S2N6UKlOXh0gv9rzdjG9McX2BPq/X/rh5bl2VF+E5R9T7/Elv/447iv7lb5yOAbjYiBQ
         pGWnxosY/GUvDQ6SxdQQQuLlobWQSCgU4+l9v+/C6KsHi/bS4AxGn7znQHa89zbfnohr
         mAs+M+U64FRaoOIXvOvD1L6MTtht/NZs+yAgvhSco4GssAKZcDCyE/lcpQ7gyQxOq4o5
         RW4w==
X-Forwarded-Encrypted: i=1; AFNElJ+cG0elA+kabk7V89iJrSHu0cX2iXwVINbNJXS1NKgW+TB6SR/CPcRLTW6bl3slkqRDXbIRKOg6VQ==@kvack.org
X-Gm-Message-State: AOJu0YyS/3KIYhNoTQKn6d0BbsuNcSYIszG7YPlLmCf5aOqUDMrwqcY8
	PuS7fmFFpo4V5h1mdxatal/nwo7NtrChq9Y2DclJyt+U4+L0M88OP7q4FtpVPONFdeg=
X-Gm-Gg: Acq92OHbSWTg+2pxaBhNDiSxLNEQX8FLZv1U2+lyN+4TjIvhHUcIBmywMuXUBMs2RrI
	6STBZu1n6eng2FJak2/yQk/u4gYhb6m/XgA5iQKuAhb0LHeoAwC8r15y+voh4AFWFkUJxnJQCl6
	potMjAgEXyD6+F8ZmO+mE4QPMeWm+S/HBrOh0E91e6n1IzphlIuOKAONTn63cJNVkO51O7MhPtv
	RRK7ppLcdQoErNsDm/NUeQ3Xs98IFqqgezJH+AW+Fm1sMORetsNpe9a1yzTe1fvb+nNIyHGR82D
	stnacIatLTqpoXNT7MolUklL+uJ26tCd2S9Acwen99MoQZ9b8GB/B/T+0P2IxstuFgN4s9Er8Av
	3CHq65OFLB9ZbJeB7PqSQXlR/8Ukd3nRhDsWATZynrbivYvfEO7esdjAAnhWi+MK6CJE/Wo5MrW
	M36HbtpGoXyb7YXunbR3fAcYVO6IsK
X-Received: by 2002:a17:903:3c6d:b0:2b7:86be:7673 with SMTP id d9443c01a7336-2beb0366450mr131723115ad.6.1779677555752;
        Sun, 24 May 2026 19:52:35 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::347])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5695f54sm80182155ad.10.2026.05.24.19.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 19:52:34 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback
Date: Mon, 25 May 2026 10:52:13 +0800
Message-ID: <20260525025213.2229628-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yx5z4gjqai8a8fbsw6qpbybax188xw5k
X-Rspamd-Queue-Id: 22B03100011
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779677556-335346
X-HE-Meta: U2FsdGVkX1+mjnc+8afxo+/2j94kKdNiel0LIJm4AsM1NMp3IG1KHHnwNsTYyYM69GxtLdBaQHXste6CpWld5IzyCNv9lVbMrNx3YypVvso9Fc/C56kyANz9fPRDqPZLykjAIm5jDcC0E71DgxiUSIHjpCkzMI6qWL+juARrASSY+u0E4ULwSc/R635OPknBBlwYeC1RJIzvvtCqG20KFkAVQ+NRzgXHUZS0L6E6XIybLvUxzJJQlkKS1qRSd5hAs9NhrQzLz21Wne912ovjS8il5nJZDBlGrscuvrSkwpq38lsi1X/Y/542BP8GlpHX6VZPKP7C3O+kWaLhIguId6CYwt7BKthNfRij2MnZEOFGSLDcnYUPyar3S0W4qXbsl8qzl87EkIsk9R63kAn9+UJ87hf4oIWGqHs7M182ApW8pQwgkDlNLEGuq6NPXDNsgzCSDV35l1VFxlhXUUIa6nkJtvFOYb97EV8DyT8M8JNumuQ5ooytsIMR3GopeHTAMqgqI5KUgRJ3QzGX1/qI2/2oyClFWjQNGVUNzWSV45kReO6em8ddPeGkgnTHJtarrfQppjGHdvud24lxfUzasz2ducgs6kNAkEJJ8C+qK/6DdDTqTVLr1a/XAL3OuBwOCTGEqkxtVK26Mkj14yaPccwqk8vwRgo2sepxTGbBPvyux8sUHYTvVWU/DQ8IZE3w+y/MTBk+HIbeANaqn2/RdXWrRLThGiH9IN8ghUm8++WvaicU0yxvMcJrPfX1JsUaOGT8SZJufJqDQNeVfhng0WAEDou2ANi+9UwKsG0HuLMq6/WPdlLVFD96OQMYhoTeNBL45JOnj87oteqIytpSoNlmp4ciJvi1JuQwylwpWsWALgsItSSnohAAhvcxTLQ9IkSFP8jZtUGxKWAIcdBp3nPs4HPViUHvprYrnkNhrPAILpEaQewjDlsJTomfhi5rjhYsUeLULBuDjQ2Ku19
 5LSxHU2+
 aNsXmef4sWksbN56y6lyKX443Ap14Xbi0SWmHfJ8U6c5p7PMWcjEnTsWOyaGARcjdpsfQjVRENMLpOIjeBUTRjRpiDCUdnYpKJEWPyYBweOtFF24Y8gVzZm1WY1k9hwzw/HkoEtmUvvWs6f4EFk822vxfFZjkvBTl7bcxJd21oyBWKUB08SblsCFWX37kiT1ovN7dmidMCPRpYfo8OBxisTbN/k11qezPqx3DvzAFmpcnMf5KXh0p9W1yuh3gyr6J2YhNW3I05A04/vz3cU3gJTG5xKx0BqGHSaTTWbXJN7Otwp6f422DAqs5J+uRNX9dnQXV05HpHp1i50h2aL7e8NBD6klJQNXkX/xVKpIuh7jjia0CY1oJg/toy2dBGJkAHPsklPXbpi9Hsm13LjQGM0A4gPwRf6AHlmMEziqfJCKRwrrf1vZULZX547X2OYEki6GeK4sttMCsFcF0yIulk2GmfR9LFruTuHB0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_restore_pte() rebuilds restored vmemmap pages from a
tail-page template derived from compound_head(). This is wrong when the
current PTE already maps a page whose contents are not tail-page
metadata.

In the rollback path of vmemmap_remap_free(), the first restored PTE is
backed by vmemmap_head and contains head-page metadata. Reconstructing
that page from a tail-page template overwrites the head-page state and
corrupts the restored vmemmap page.

Fix this by copying the full page from the page currently mapped by the
PTE. Also pass vmemmap_tail to the rollback walk so only PTEs backed by
the shared tail page are restored, while the head PTE remains mapped to
vmemmap_head. Add VM_WARN_ON_ONCE() checks for unexpected cases.

Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4a077d231d3a..133b46dfb09f 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -207,6 +207,8 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 
 	/* Remapping the head page requires r/w */
 	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
+
 		list_del(&walk->vmemmap_head->lru);
 
 		/*
@@ -218,6 +220,8 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 
 		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
 	} else {
+		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
+
 		/*
 		 * Remap the tail pages as read-only to catch illegal write
 		 * operation to the tail pages.
@@ -232,33 +236,28 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
-	struct page *page;
-	struct page *from, *to;
-
-	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&page->lru);
+	struct page *src = pte_page(ptep_get(pte)), *dst;
 
 	/*
-	 * Initialize tail pages in the newly allocated vmemmap page.
-	 *
-	 * There is folio-scope metadata that is encoded in the first few
-	 * tail pages.
-	 *
-	 * Use the value last tail page in the page with the head page
-	 * to initialize the rest of tail pages.
+	 * When rolling back vmemmap_remap_free(), keep the copied head page
+	 * mapping and restore only PTEs currently pointing at the shared tail
+	 * page.
 	 */
-	from = compound_head((struct page *)addr) +
-		PAGE_SIZE / sizeof(struct page) - 1;
-	to = page_to_virt(page);
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++, to++)
-		*to = *from;
+	if (walk->vmemmap_tail && walk->vmemmap_tail != src)
+		return;
+
+	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
+
+	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
+	list_del(&dst->lru);
+	copy_page(page_to_virt(dst), page_to_virt(src));
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
 	 * before the set_pte_at() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
+	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 }
 
 /**
@@ -324,6 +323,7 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	 */
 	walk = (struct vmemmap_remap_walk) {
 		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= 0,
 	};

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909B7CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 04:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0CDF8E0002; Tue, 30 Sep 2025 00:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18A68E000B; Tue, 30 Sep 2025 00:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43D38E0005; Tue, 30 Sep 2025 00:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A53908E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:36:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 496FCC057C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:36:16 +0000 (UTC)
X-FDA: 83944654752.10.7F2EBB0
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 74689140002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:36:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759206974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=fm5G8/vjhsIUjpmRZq3jBHzITraDiDjFFu8BBE5iGww=;
	b=ydADqzb0PugCYlqimu5O74Hv4rArRLueV0Djjmw8hcn3kpFa2AA49W0wh94/RNBhKeenvB
	QXgNdTkTdmVqxD+4dFyN9MBhxBIWAT4Akv+uLwO4iIh6SQgZ1NZzya5cEiKhlmS9wkXG00
	vMaADH0DhsA1ANhT/rpScKliUESFGws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759206974; a=rsa-sha256;
	cv=none;
	b=0une9HdZCyufMrz/JSBRhwz+QRWbIVYAGLAfXlQ6/VmeJg3W6wrwrf77ctEkcF4nAdP0pq
	uwRA7umveX8pK4R0GeuAyqKfdp1DDyGXM8xvGLblEHTDnSysQ1EFfskrG0onay4ZydMW/D
	0XC3dlog1j7qxkUrDN65YFFAax5KsHg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3f42b54d1b9so588207f8f.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759206973; x=1759811773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fm5G8/vjhsIUjpmRZq3jBHzITraDiDjFFu8BBE5iGww=;
        b=emg+sdFJWQdAC2ax+i7TKZCxcyotlQ6AvlQBVniGGqVRfYKbdHLk6M8Xm1xveFBHQa
         F0mxX/n4tB2WYBQC+eM/Wmop0NsrbJocnnWyAMAS5opNI/wucxsZE0NH2eSReFphFrRE
         yYNpXnw9eubCjIUb8Svf7Nr6HnspHtYsaOUjMW3Q1gOg4M3riNe20F/5+uSIK7iAr04D
         t5SGiW5bRm0lZYvjR5V04/eKKbCGCRZ64q5OpqpghFY2HVTdf+Bf6NiI/aiSvN8YSe7t
         L6pX/WRNzyIaxMKnQL99yU4PnNWC2yD+vGkmIIvl+MbJvkkRCzXcd9BTALHS7rqSY3QN
         mdCA==
X-Forwarded-Encrypted: i=1; AJvYcCWkC/H7CIopb0b3Uf9h9dRxtuk5mje6tVTXQA/00hKPoEl4+wzgocR4VJWAnpkZiomLQh4neZu6pg==@kvack.org
X-Gm-Message-State: AOJu0Yw0CK6H5bCvIh3s5gRO9Mz0fp0ouU+VPUKAAhzTJgnj1ecMm8gp
	7RtR6Eoc/axr/M7WzClK9WoYTROMtKvNVOzVn8bRv37NXIT6e/ELcoiz
X-Gm-Gg: ASbGncvroJVRtPRgfDfdMccW6rO6zu8UBOukvp5Zb72/X4OzOMY77imd3E+AHpTBgmJ
	WzG2hr54qJcVxNnl1uZJLSGVuHmI3yL0UzOqR2IN13qyvkiLbrxOC4H81brKz5ykr+SE0CNoQb7
	1VG+YbbR9gJgUITm5gkMmvV7aR2kV+GaWDJ7famIx0wdpUi+dbwVI+u6tyD/tu50YF5XmzbSrOB
	czpMZTJrPyaGRn5qf48rKa0ihMe5cnTmlux/3R3anz9OukD6Wfc35wQNG/amxDMiZwUsmBdWx30
	cRc2Q35P3Ry0fdqj40cnQoqaOfylGNER3Xx5wvA6ooRA8ak8k103c9E/Vnaz5v/ZI5zne1aIblH
	FP760lspdgd3/bu3GDuuYmYiFC/IlCMJZhTPPJCiGGT6KVxofEQ==
X-Google-Smtp-Source: AGHT+IFBQFR5WWYgcTfynxJt/Hg+yCz06L3cy9rUJ/5SIpRbrAFoiE+fVMS62c0opwP4Z9BkumTQuQ==
X-Received: by 2002:a05:6000:1acb:b0:3ec:c50c:715b with SMTP id ffacd0b85a97d-40e4458ce21mr15661043f8f.19.1759206972744;
        Mon, 29 Sep 2025 21:36:12 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb71esm20934560f8f.1.2025.09.29.21.36.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:36:12 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: peterx@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	npache@redhat.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	usamaarif642@gmail.com,
	yuzhao@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ioworker0@gmail.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
Date: Tue, 30 Sep 2025 12:33:51 +0800
Message-ID: <20250930043351.34927-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ruyedg3ae6u4rboaqe6hgs7bkecupogi
X-Rspamd-Queue-Id: 74689140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759206974-819377
X-HE-Meta: U2FsdGVkX18Tx1l6zAUSyShg9WVPB2i+hdWES3hNe0QiS5mAj6ebZ8K1o2iHaL9GOgqOU98ofm2cHiMF2rMXKdfcmwkjZ5nINGxHkDjiJp24EE3XJLA1IQA+iI14KfacF91wAILflqrJV/DoCmBlU10V/Npr+pYOncCDyCegh5D6EKYeTOgS10LDveUa9ytFllmOYCEc77De1YsSwvsdswbDhVgIejYVLQ0pnbdSw4IUKEHwfe+Q3xpnx8bnPbwAc5oSOX7tbMPgzEzdc0D6M9WOegIMhkR2JNnxl0fJfpRrYMaaj3J6uVWOYwkkIUTebvn3s7UgWHwLgjJBkL83Qv0nEFPN46vzzN6tvsZJjjup9cT/kbs/Ctom58WRTTW5vQX4GbIuswrjIh8kTDtrOnTHu7eS5271/D6kAuOTJU1R6kaYaEi32j1uXlXWUS6TEFRt0DDxYEjGXx6DEwg1ETkLUvRYELSjN378nwDjnn8P99DyqF/419ZRbIIpsLb08nPXsVMVhwpN54TwuJ/NBv108GkKfQS96GTPsv3FlhZZ7ewNnw07YLaTLAmmwb5m0ETMaxdyF3qFQaocScfefx1/q2cXhJk/bremQegG7+PtsmHQSctgjV6+TQNoEBq1XIStLYzsglNBkwKNoqfeN+1hXDBCDLZ+jBCoLdO15NbNJfoZc4omsqr4KyxC/ohtboLuA5Tvxna0z/0rA59GlD+YPnboaWpbBvhIsiWT3/dSXjyxKuZmb/bWE0qTJLBDeRTuKdj8K+TQyg/saq92ADnVe+Aq2HF0qR2I66szIaaQfR0a1pwyBCaaVydvuwZs4tRgB44DIZ9nv7YnTVzW/cmMnZ9V1Ys5AzyDcm1uWwEHdgoPBAshz7jdPzTtYkFgi3sKcrx/KzVjm1j5kNtg/VzqdgNAR27XIXR4nOgRfKil5x/gHlGAeFAhlb9cv/MLaywoZuIeBH1oUVpA7qY
 rWiqC9bH
 T7EEmr2oJIqtX3CLzurLxVzKFU86Z79bKM+Un+tTski5bR40s7RcVt0BrPtJaM0zPikKSiBaziEXdmDD21NlbDLro85mrO7seq+gBx9bu6LRx9kSxLG82dfWUAtSvRhzcHtk3u7hb/ZV+RsxkCUrCHUsUF1zskBPLH/u51EMuaGWF1IqjbbDq1UkPuNbMLY2y+Uk3w7hZiVvUPiiAlneiMXoW15UHcwgPitDLe4Wowx8iaZqbcG2dxMA8YRGyFqLpCIH8sYXyHYUaVaq7/dFrBIAcKBjWU4WiJSSpkbetK7a6mbLoG4LF5qBTO4JIlNrT8R78kNun0PKmbPk7HTZZRcP/dYf51Hk1aEc/RhffSBO+tmEBvNEhpaA4CYrpYlY1dYCk5Xx6EkclQF7oLwOPMVRuZHkrXroWhqceuN2KRGS2J4TQS4DoNQGSvPdVqtfB4WjUWYhYwJ5Sh/5STpx8UwdhPoWYhGGz/BUMqaJAONGQCD1IBrNnKmHAr5toycr4GQa0CXIl1WpEhOlijmAdTB1ExlfSxxYZ/D0WAK2aUUo5aM7bE6MhTcDGysef+mgli2wUcFsy4l8K2SMj7Sg4776rLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When splitting an mTHP and replacing a zero-filled subpage with the shared
zeropage, try_to_map_unused_to_zeropage() currently drops several important
PTE bits.

For userspace tools like CRIU, which rely on the soft-dirty mechanism for
incremental snapshots, losing the soft-dirty bit means modified pages are
missed, leading to inconsistent memory state after restore.

As pointed out by David, the more critical uffd-wp bit is also dropped.
This breaks the userfaultfd write-protection mechanism, causing writes
to be silently missed by monitoring applications, which can lead to data
corruption.

Preserve both the soft-dirty and uffd-wp bits from the old PTE when
creating the new zeropage mapping to ensure they are correctly tracked.

Cc: <stable@vger.kernel.org>
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
 - Avoid calling ptep_get() multiple times (per Dev)
 - Double-check the uffd-wp bit (per David)
 - Collect Acked-by from David - thanks!
 - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/

 mm/migrate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ce83c2c3c287..50aa91d9ab4e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -300,13 +300,14 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 					  unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
+	pte_t oldpte = ptep_get(pvmw->pte);
 	pte_t newpte;
 
 	if (PageCompound(page))
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
+	VM_BUG_ON_PAGE(pte_present(oldpte), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
@@ -322,6 +323,12 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
 					pvmw->vma->vm_page_prot));
+
+	if (pte_swp_soft_dirty(oldpte))
+		newpte = pte_mksoft_dirty(newpte);
+	if (pte_swp_uffd_wp(oldpte))
+		newpte = pte_mkuffd_wp(newpte);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
-- 
2.49.0



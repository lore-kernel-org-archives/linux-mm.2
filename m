Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F43DC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F7D6B00B2; Tue, 25 Aug 2026 04:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6BE6B00B4; Tue, 25 Aug 2026 04:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0D86B00B2; Tue, 25 Aug 2026 04:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5806B00B2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:50:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 939B5160391
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:50:09 +0000 (UTC)
X-FDA: 85139169738.15.253B669
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id C48DE40006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:50:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="OVq/U9Ot";
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkaNBeAytbvVs3m3mYf/1Z2YiyF8/bnD0d7KipoqAQ4=;
	b=vKTWy3RNE3n499CoLTowYmJzfmHpI620uMDSpXj20JK9Viqz2zNOVAxTzFk63zS+0TzOO0
	h1sqW/kxiimLknieBPA+p8Sd37Mqg5gzNx+3zVsr56PVICPxBMV+fr/X00bzKNFL81bLml
	bZweyoR6rmZl3dpwdJm/PKip7mBp9Rs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647807;
	b=E/infgKcNbIchrXugaxiyfLt9BIhpybAhviij7IymEzVq04OQq1U7VtwB/1VXvo7iZhE+6
	f6PloQwUtHOW+9RUjiwQNhtfiL51AfCDMf6x+cf+WHtb+EFj84aeTdeFkexrCcvx/M+PfP
	OUQ0HNAFkyTH6SkBbPLJ8jXhGiDBS1Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="OVq/U9Ot";
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e041ea211so3831898a91.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647807; x=1788252607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MkaNBeAytbvVs3m3mYf/1Z2YiyF8/bnD0d7KipoqAQ4=;
        b=OVq/U9OthiKpnYfAsxbpUjIBXemdC8dB974IS05jIABeDD/rIYnVljJCBYVJ8775g2
         dZjdHSEx6K5RVjqBQJdUnXgWY23zZLZ9+HlK596yxVv8YIsIbwKi0553J0KLf9EZ0bGJ
         VYc5fmSEx3Ah1GII+x2SGg3ZnbhJZBRNl3qaKcc9j/eAL1jiG1+/fDnGactfl0nBRDB6
         rGuJu+ncY+o4sd0X8yZfEJljYKHPpi5NyUY6XKusU2lGPaC5paKdmS8Vpkau09gBiBy5
         LahRjPGCp+65cyHajvHHxCmzQlONHM+01eoDL3j5qPNT51THqtrUad8gfVm9uQFvngYV
         f9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647807; x=1788252607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MkaNBeAytbvVs3m3mYf/1Z2YiyF8/bnD0d7KipoqAQ4=;
        b=efI8+bZe6lduPLcqr1exczqQdovcZWeFrZOJYjZxZWFr6A3IWcU0Zfy/16SGLeUQZq
         cZB3HSWY+NVI38SCBAbtExfCy+hF7F7AbrtE/BN0e6rC9fDgsY9JY9ErG6sexZJnIwO1
         XF9F00GuuLr/7ESQ2jgeXbV8VhFtUm3zdMO+G38Yh6MQZNb951v6zO5LviHMvSHOeJgw
         3qTlVaehQpsSrQvlO3uLV7OlVQTsI376eH12Vt+eGndY/LfuCvEGqsfdBQgN0W4Sswil
         fzRNgd3sgBfsVbrhBo4Wgkqv8cUd2rBUm+ELDBjDunJe7sKCSKuax1+vEKkeyJ98TBWP
         NbjA==
X-Forwarded-Encrypted: i=1; AHgh+RpzrCFy5uroc10NbgPkcSvMRNDgBWGXyGvn1mTqPsA4aMHwHgoTlKXuCVIq4RBfB4F7Wd36esBD8g==@kvack.org
X-Gm-Message-State: AFuF++nG+4f/3NZ7W3MFB/edixLkHSXhCRO9VgceYXrcm4j9qmFMItnf
	tb7BqCWtx9HpQDW9PgubEm9uD/79AS+K4YFr42DqpNPa4n8fPfBozI8vCcVnaYNZ1Nk=
X-Gm-Gg: AR+sD13GIIzEVLReD466KCqD8s+qOMP7OMdLp8e/eVAG2dgFMc+9wTLV2siABZchEpz
	BkJ2c1zvqngcxW06dWzl06E4gbFwqqetWi+rV8K/4o9eEPyGa/6c1+4zsTwAIYJn8XTGMzT+gT3
	J9i1zGBT7MczarkHjSianUGtGiz9REGOG1VmR/pevXw55LvAWbUFY8FdQHOB3PJu5gr4tK2Y8K4
	wDJOaVLCxRq96iIMpXCTzL2txHDW8vjnX4RbNRrXXJzOkgx8LLUsO4mJRO180bDhTpVDKv537W5
	2vSPVbqcQ3vImsydIg3N2q5OKWnAUvDb87OUhFyoPZu6OESmUtUFu8Pzxl/xelLmMOe8AwbfjtV
	rxL4c+2TN3D97OjYwdG6KXmfjnq/EeTDbVIdklOn0TOTgJA2lN1Q/R6F/+MZydbmghLXKe3gPa3
	2yECMf2ksI4VaS6h8tUPp+vAPQrcxeWwqSkLMVl0sxnpWMZoLFieiFzZL77uyNArdFFxZJ/JFlq
	QIaRMqTUaG0zQtpcXw5xyKArw==
X-Received: by 2002:a17:90b:53d0:b0:38e:bbf1:de3f with SMTP id 98e67ed59e1d1-395c359a74bmr59356178a91.12.1787647806588;
        Tue, 25 Aug 2026 01:50:06 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.50.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:50:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 16/17] mm/hugetlb: localize struct huge_bootmem_page
Date: Tue, 25 Aug 2026 16:46:07 +0800
Message-ID: <20260825084608.47437-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n9zpg9hz6z5ac9c9yexb9hpukaqfbc6u
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C48DE40006
X-HE-Tag: 1787647807-686454
X-HE-Meta: U2FsdGVkX19Ftp5WSwSmB0T27yyU1c7mA7xxcVl2GTl9Rg6UvXwsbhqvOTvx104yQDnS9gRcuCXz34lovpBew6SWEuyNc8Zhr3yEjigjCuc2NEnfnV871kAld/xLYSWk/4zPqxDNBYKBg+0Km1wmdNddpiBXF13vACxcEKW9twA+tNAmIDQt5bNG5cYukhVEtwjvLcsG/IZPki48fD1w8ieGnuFT9Xn3yDYLVoJ+PbqmSFD9ex/xlUewH7N8iELwCcO8iHphAYGVGFkS/hXQ9cc8oJz1YzGqxYVBpYRa+5cl4txVjohHXJwsnA/a0kmp7ewGlbtOo56K33gaUdm3DgD+esNWAO1sH/dkLVkeMPwv3LoeBO/LIlbqiuPV7D7S6swxgsZZAvboLuVs1h0UVDtie6htQuJAZzLJgH7yBQbn8Sh/t12C+CUTnL67DN3fdG91L509xk3pWpAR5mjN/uFHv1rP7diPuJEuDtSM5iF+7hu4s/sjegMgtkXIKEx0qlMUKDkvv6CVNIr3G7OTS2SVkZV8tOoKfHNYMZSeev0NtWkVMIAjnYAQ4/IeiQZEyj1PgJCyhsYxWScWeY7Cju+5y3BJhG04S4aCFmR4hOmoFHfJ7eoZQ9cs/NZrpI9mpZ2j9xDWvnvT/MtC/kj7XL+MNV/Dfi2PMFQYUU29IgIB2GPwZLiZ83mhyGtAEYjtTm/9U5dkPw2RpSHNB9Qx/vjTS9+iHsHdv3cbYYxg9G3JZWsjRGmiZOZ1UTiFmG7263/oR96w1umGqym/T32ab88n/wfUtC2yj9FKYsJWZfg5dIGIkGVWISPTFsjkDeSWULV2WBorzipJp6oc/lGwieBTo/y4/rcQgJQC7QEtEDcTsJqKTAAexC9ivUI1gV7fW/ORprr6GA6iO+lSXtcHjxtU5GpO1OMPWgrVfWr9qjBISFgc9d8xOl3b/h4glxIBr4PBShFUC/98cHWDcWY
 sJxz6jIJ
 jLl6RZiahfm0xM8Bv8vXCkBxnelKHwiRvvMh4qOIB8mtvzX2F8RJlTsva8GWnt1eOqcT61CAOBMSjy5m/X/ho85hBx8K4JJNoPlnjyOSw8eameO4Cz/N57dkL6VRWtcsMDlgH7ohLTDZgBws3PLdOMb+xSS07CP25BuJZ+tNkwHX7l4yNncH0FpEi5YKQM+zYseFgyXG4ZRS/1KEYOW3sZWisGyRY8zlzrTBIo3GqOjFD0G3BFtODMbpurzfpOIwR0rhVMMR5PowhBf2e+TcYLjxz+h/87C+HTsER8a2b5d9C9tVuDcysEdmRw5jP+6o3/IifOYn0Fn715pDIdPXwZn5ukxFWZxxmeYsz3ESsJQTlGW098rW8geD3LwVFrRMoWUG5wpYgCDZtkqojiBRws2vaU/gGMn1ESlYI19LooL9gWLihisDwxhuoaclBzawgxhUKrr8tCem4wmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct huge_bootmem_page is only used by hugetlb boot-time allocation
code, but its definition currently lives in mm/internal.h because
hugetlb_vmemmap_optimize_bootmem_page() takes it as an argument. This
exposes a hugetlb-specific internal type more broadly than needed.

Change hugetlb_vmemmap_optimize_bootmem_page() to take the information it
actually needs. With that interface, mm/hugetlb_vmemmap.h no longer needs
to include mm/internal.h, and struct huge_bootmem_page can move into
mm/hugetlb.c.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Pass PFN and order to hugetlb_vmemmap_optimize_bootmem_page() instead
  of struct hstate and bootmem metadata to simplify the code further
- Collect Acked-by from Mike Rapoport
---
 mm/hugetlb.c         | 8 +++++++-
 mm/hugetlb_vmemmap.c | 8 +++-----
 mm/hugetlb_vmemmap.h | 5 ++---
 mm/internal.h        | 7 -------
 4 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6822fb4159fb..51d386b8b5c1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,12 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+	unsigned long flags;
+};
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -3140,7 +3146,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-		hugetlb_vmemmap_optimize_bootmem_page(m);
+		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a25adc474351..eb339c4a71f4 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "sparse.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -705,15 +706,12 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+void __init hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
-	struct hstate *h = m->hstate;
-	unsigned long pfn = PHYS_PFN(__pa(m));
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
+	section_set_order_range(pfn, 1UL << order, order);
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 20eb03df542a..464192e32dec 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-#include "internal.h"
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -26,7 +25,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
+void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -77,7 +76,7 @@ static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+static inline void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..c37a468d53c1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -23,13 +23,6 @@
 #include "vma.h"
 
 struct folio_batch;
-struct hstate;
-
-struct huge_bootmem_page {
-	struct list_head list;
-	struct hstate *hstate;
-	unsigned long flags;
-};
 
 /* mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
-- 
2.54.0



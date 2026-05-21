Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C986CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A23E6B008A; Thu, 21 May 2026 05:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904196B0092; Thu, 21 May 2026 05:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8866B0095; Thu, 21 May 2026 05:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 517336B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:07:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16EDCC1F7B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:07:37 +0000 (UTC)
X-FDA: 84790848954.09.9FD2DA5
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5D137140017
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:07:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CY66bobv;
	spf=pass (imf09.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779354455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXhh/3pfw6eWOrAj3wFcgN8+CS5myBHUR35TRSpaluM=;
	b=QrXq9U10jxCCwZpzAGPMEltJdWq0rvGgjSFRABwUpHyH3DfgLTmjsigAmI95mbRgHuKcvc
	eNC236jUHA4cpHwO9E33hyupB/gB8Hhzuel0X17gkFEYyO+hiyPTuIVcgAXWMM/Sj/fYyq
	fjuayjEyrFZU+NfpN+ZfjtL4v0XrFIY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CY66bobv;
	spf=pass (imf09.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779354455; a=rsa-sha256;
	cv=none;
	b=Q5ktmDRH5C/qvLkS9EHyi77hqubBuZIVzrXwVbWq7w8KeTitRwxUDlpXRZ/IH9N+OcFLKf
	1Ofwo4BSOOUKVnskgx1G0+HI1UVNrb5792cuC5nkkFsulLlT91EZ7oR2R24btvFCF3s8bd
	1+5XOE0J/Aogd18VYXDoAOun/PY9wP8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779354452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXhh/3pfw6eWOrAj3wFcgN8+CS5myBHUR35TRSpaluM=;
	b=CY66bobv7cI+tfUFCA/g4Yu0zOZlao4OPUOIFKNduJpYTF+RzbO31IbRX6KWQ+V63drLZu
	XRtEH4aCF3fEdbyuTAH7LHMMYNz7Kd8pSynWJcRysuoMQLxvNa8akJpyPBZWiYGIOotGyO
	4s0MP7fuJF/W87waK+o0wlBfxrSuH4U=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	David Laight <david.laight.linux@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to vdso/page.h
Date: Thu, 21 May 2026 11:06:57 +0200
Message-ID: <20260521090655.160282-5-thorsten.blum@linux.dev>
In-Reply-To: <20260521090655.160282-4-thorsten.blum@linux.dev>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1390; i=thorsten.blum@linux.dev; h=from:subject; bh=d+sRF5H30DnHl8zsHElEvlBRcbP5jT6jopR0Zg0fwzQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFl8p83L2YoD9YrWr2m+xXYp2k3SYM0CL4mSWtO66ezv3 ujvFvvTUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABP5pM7I8GsVQ3HH+8xfPgvC XjPkV8g0Zhac5a3P2nxxqbSQQGmDEiPDxOOfXd5Utv4U27LX+cHEXSl8tscvHQjWTTrhvEd9olQ YEwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5D137140017
X-Rspam-User: 
X-Stat-Signature: 36jzqpauagqyxiu8dm6crsnuksprze57
X-HE-Tag: 1779354455-373387
X-HE-Meta: U2FsdGVkX18tyWWul/KHoO7NccCpVrh1xf74mT3dfu3MMfH+uHflrXSUqhBRpo4v/qeukk7JDdDjyLZtzb8XBVqulWQoOxCAu+TcKjdWZYdTdX4LVniQ97392RqQBBDNsaJxoX1nbjIgbcVZ3LIc2SKU4bH1yGJuPV0lziyswN2DEP+Zb17+D3h91ulGLJZAaWC00QVUzbz8IQhmEiZwnZsYqLZ+T3lwaLC1hl8Qjf3VTtDpf8qYWzY7khmkeWhawVw/1KJvrjOsy/IjxPm/XvWuFTJHSuOJkZ/xwNuc4QLIJzLegdc1O3tgEhYs7kB/xYDMMt41pTTwVkfz+VdHtGc6Xd0Mu4P5YijLL2n65YBvrUtTtpBG/UFJCsxa03IbeZ9XcHBs/8ACRWItYdYVv1RavUlY5aTMkEdNDBg7UdndAQcDfaI9AprLOLjZQiIixDVHJn0HT8025fTcOiNCrR13MOCd5GCgCqvNdVSewQU7onmPPtFmNK5AcHZSXxrdQEo+NoJgw4SL7qH87wykolDGUEq+c3MQqC9g60TeEKM+qWBbCQLAzoCVR9eFqZrW9tcXhNmVpDcRR2XjwBQ/HLScVyB2hHuLL0CyP6ru6LKR5yaTyXOoY1URpvozFONs7rOk1Q36Ehhejtwgg/43Uwqod0iNRFb83sap6WR7jrTMWlX4hFFaKWkDacK1ZankTL063CO8hOLG07TWmHaZ6xx0bCAlncPJtoLNnaP7K3VDrKM9aLag7UrrZTn3EzX+nZD7cEsvEW9zc9IH3mEDUdtP7Qe3jlG32aqdiM2LjkFeeR6SnsD7OojpYJ43FDmpTymx4vh5QV++HlfIwizZt8dZ213YWA5wzKp8iPD9bz0/fQQk8jibN5scuJn5sIJ4G8Z4KTrOFV4hcEUc7euJt4iFk8vIQ8JhLEH/rTQqKP37DIjn6yDQsWU+vTTHr9aEns4Sa53MU8v7pFm1I7x
 M3mvxsN/
 j2Dj6d+UBsMM4bixS0YiZ1O2Ros93jg1P9ehG/dajiF+iKlK82ogTqDT1y37rjPTuHlLC0F7Nqxzl/1mjWDWVLAWpCVsVvvjLMwHj4Trg9aQOFdG8ZfmFZYDo4T6syvy60fJ3NI/zU3YeUPrXm44df0Qmqrf+kQigESAO4nE33QI2VtWHvRRtefuw38bDxe/waw0gKsDdDSt8rO9am4IJiS2b/wnWFYU4o/9GkpDeViF83qrrLbCYBEfeRj/lykBLKDT8vazuUb2nT2g78h+/ps4dL6J/eqh4EcSNiAvy+m2tH65YxlfD+lWLsKZMGttonqa0AgRVQKM6p9MARiVx9BIQcMYDWzYMFegO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move offset_in_page() out of linux/mm.h so users that only need page
offset calculations can include the lightweight vdso/page.h header
instead of pulling in the large linux/mm.h.

Include vdso/page.h from linux/mm.h so existing users of
offset_in_page() continue to build.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/linux/mm.h  | 2 +-
 include/vdso/page.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9cedc5e75aa9..d5c7f1ca80ef 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -37,6 +37,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <vdso/page.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -3023,7 +3024,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
  */
 extern void pagefault_out_of_memory(void);
 
-#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 #define offset_in_folio(folio, p) ((unsigned long)(p) & (folio_size(folio) - 1))
 
 /*
diff --git a/include/vdso/page.h b/include/vdso/page.h
index bc47186c07fc..948b13091084 100644
--- a/include/vdso/page.h
+++ b/include/vdso/page.h
@@ -28,4 +28,6 @@
 #define PAGE_MASK	(~(PAGE_SIZE - 1))
 #endif
 
+#define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
+
 #endif	/* __VDSO_PAGE_H */


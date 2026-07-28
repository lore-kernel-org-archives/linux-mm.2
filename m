Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1301BC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D866B0098; Tue, 28 Jul 2026 09:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B416B0099; Tue, 28 Jul 2026 09:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47EA6B009B; Tue, 28 Jul 2026 09:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AED6A6B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:08:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24C371C0A9C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:19 +0000 (UTC)
X-FDA: 85038213918.19.8B74A1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5720020009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cu9QmqSd;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7MX1MGs508cUN6xCRbAVP0KOcolddHw8KtRR6TuHhw=;
	b=VkFkOzZXBdaClW+Dmhd4/KcOeRui+5TdL8wjH4DHT5kMGYLRHAUlhA0ILbQANCApZoH0fR
	5dxbnAeifLndn3l5dtK9C2xf3pJNbDgWd+KgazqSHPxciELCMCyT2Ea4o5coYVkTJCEQvS
	uzId8qf7GIJvW+xv+pkAJf+SwRbPc0s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cu9QmqSd;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244097;
	b=hDIpc17pD6VWuHGJMi9paYYU78LCbP3/WcF8wNaUU1cdtGWTxEg+doxb2Y2pJB5tjS6sGa
	B5cPIg8iPtJ77ABybt8f8P6OhAOsisu72EPwCgXDtFgPm//NjrGjyCBHsmWHSTnTkikiQR
	X3yd3GHw855X75FFZ8pOIPTImwhLD+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E4CC43D77;
	Tue, 28 Jul 2026 13:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB9F1F000E9;
	Tue, 28 Jul 2026 13:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785244096;
	bh=G7MX1MGs508cUN6xCRbAVP0KOcolddHw8KtRR6TuHhw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cu9QmqSd9G58fcL+OkxtnXYi5TguTf11LIFRpQcrMpgkr3ZIKGUAgohguxAsP5yBD
	 dOtfjxqdPowbwzzowZCPOVPXebaq0SLKt5fmnWoyH8h/lXldJZguBcmC7R6J885fko
	 HRHW1AmWOLY7jp5F3FX/NfnitzaSCEHG9IyIwHYE1Thk30U4kQgPZNH8AxlNLStsPP
	 Pw92SA8PCmod5jXAsZmHQv/vnpBVOnu+UBtFK4XFk+ONXxWt2x+8stOH5XFsYUpzUg
	 A79VyG6JgiVkANaGRmVOWu2v5EZHOkEog/3syRkQrxd8+AaWSRtLjdbKavBPNYlWMO
	 9idT1MzaBv9jw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 28 Jul 2026 16:07:44 +0300
Subject: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
In-Reply-To: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
 Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 5720020009
X-Rspamd-Server: rspam01
X-Stat-Signature: hogfipi5tzf5rrzs95p5ztim8qjph1f7
X-HE-Tag: 1785244097-426493
X-HE-Meta: U2FsdGVkX19TasFPtfYo8Kfc05A1y0giP6QtfJWPBTIfEnwWGJ/WJqMAftYBgk9EV46oph6VRylox9xi8W6bRmlnkVW4DdnZdkI5IzsK2Ukmd8h9je8jl8ggIrxdT6LzGr+715kbEXIoYdKqJ25kJQL3kTtX3BGzapJASZAkN6KaUci3X8UVfF5Ns38XQkgBmIxn+hLvmFzmkidtuXEUJUwk35mGVInmJkg0bz5ASqtTGhNW2cBfPq6mhMT+nhvetbTWQINod0D4bvg/r2MyXJu+2+ng+EBk1IlOUaZozkN0qwKt88zGCbMkhz5JObGsyyAZXxlBNS8V4D3qg2k8tCt7TfJA6SgQNfI18BM574FSAj0hH4nY0Xe9wxlJeoxXv5YKqw9Hu+LPxl+ogrJsqhmuaueUiueh5+a7qou/lSRFNS/PB3wxAqnaa80AeAuDvy2Pt/OwdYKCk+1wgxSM3vz0s4zTREOy6WlGAb/SWow47T1kVD0c1uo/SB9mh2sTXvzxeras0Z7yclKvtecKLm6+k5t2QJA2rAqj1do1DTmjcMuQ8JQ/8LJpH3OSLKFBFbUTikNS3Xgm5p99wSfPQfrSq7AurjK5bm6ytzCAeKaPFYZ+nH16pESh4A8V8kTaEnccbwFXqgleZ7f97uZqe763jcLmcH0ua09HCKIdmu6sM42bgy98BjxJE95sJ+26QwggKwLaRoH1yPEEEPOd4K174qoobLChNVyTRLdeXkFj+2fKVgLjf68tnR+nVSz9cRDyIDD3D8DlOwHpOlW9+Ynnhsa6qNo7B4WsKBcUeN45TWx8e2ZXZktU0uBgj4TGZnH+hqhnPTStAwGsvFCmMOE6M/1jB5MOc7e/GkZ11uQv0OLYCUytwg8ybY0PK+k7JZo0xqdeCKiqtqTmXl85wEypkIHJ86DGRB/u5CJo3OEOr9n3/t8cPBQqEaduGIhK6kplXyNFX1Rd31ktOj0
 AVMHVWz3
 DYbx6B3pTw8BNo5kQBp79unHVOQi93cVKf77qTw0fHrZ9lqbDEfD8j2UjOcc3Kmgg/oYIf7i3Dx2kFlg/6vtoSivHI2siM3WdLd4VMP7BAR8LP8zIZ+2U2xtB58vYp56sUO/DrhHMA/TJGabICiXC5cM7lc+6+bMWyu/PIs4mr5kfpxyyelJN7/LBnSe+hGCoHN1YAz6EtnxNN5t+3QmriJAS1HJ26E+U9YVQHHCh16kIIQFvPnvFlgwfAWkZXuzdd3hMQK2esU+7dAR7twaLbJsqQaIe0SWp45es2kYTLT61zmvYg2noqAyz8r+xKkXuQ3KewRtEcrVvSUsdXBqJXfqOqN60UkHS7k+Fl55CPEmx3NVAfsDnh30u7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The splitting and merging of kernel page table mappings between small and
large is protected by cpa_lock.

Commit 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on
debug_pagealloc_enabled()") disabled gatig of cpa_lock on
debug_pagealloc_enabled() to simplify the code presuming that skipping
the lock when debug_pagealloc_enabled() was an optimization.

However Lorenzo Stoakes notes that:

  __kernel_map_pages() can be called from irq context:

  < GFP_ATOMIC context >
  kfree() or whatever
  -> ...
  -> __free_pages_prepare()
  -> debug_pagealloc_unmap_pages()
  -> __kernel_map_pages()
  -> __change_page_attr_set_clr()
  -> cpa_lock spins [irqs off]

  So you're spin locking in irq context here, which is probably not a
  good idea.

It would be possible to unconditionally use spin_lock_irqsave() and
spin_unlock_irqrestore() but that would complicate locking rules even
more.

Restore gating of cpa_lock of debug_pagealloc_enabled(), but instead of
putting the open-coded condition

	if (debug_pagealloc_enabled())

before every lock and unlock operation, wrap the condition and the
locking operation into cpa_lock() and cpa_unlock() helpers.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index b1e780a465b5..4c8922695fd3 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -65,8 +65,25 @@ static const int cpa_warn_level = CPA_PROTECT;
  * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
  * stale large tlb entries, to change the page attribute in parallel to some
  * other cpu splitting a large page entry along with changing the attribute.
+ *
+ * When debug_pagealloc_enabled(), page attributes could be changed in atomic
+ * context that would warrant disabling IRQs. But since debug_pagealloc always
+ * uses 4k pages in the direct map there are no races for splits and collapses
+ * and locking can be just skipped altogether.
  */
-static DEFINE_SPINLOCK(cpa_lock);
+static DEFINE_SPINLOCK(_cpa_lock);
+
+static inline void cpa_lock(void)
+{
+	if (!debug_pagealloc_enabled())
+		spin_lock(&_cpa_lock);
+}
+
+static inline void cpa_unlock(void)
+{
+	if (!debug_pagealloc_enabled())
+		spin_unlock(&_cpa_lock);
+}
 
 #define CPA_FLUSHTLB 1
 #define CPA_ARRAY 2
@@ -417,7 +434,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 	int collapsed = 0;
 	int i;
 
-	spin_lock(&cpa_lock);
+	cpa_lock();
 
 	if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 		for (i = 0; i < cpa->numpages; i++)
@@ -433,7 +450,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 	}
 
 	if (!collapsed) {
-		spin_unlock(&cpa_lock);
+		cpa_unlock();
 		return;
 	}
 
@@ -444,7 +461,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 		pagetable_free(ptdesc);
 	}
 
-	spin_unlock(&cpa_lock);
+	cpa_unlock();
 }
 
 static void cpa_flush(struct cpa_data *cpa, int cache)
@@ -1239,9 +1256,9 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 {
 	struct ptdesc *ptdesc;
 
-	spin_unlock(&cpa_lock);
+	cpa_unlock();
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
-	spin_lock(&cpa_lock);
+	cpa_lock();
 	if (!ptdesc)
 		return -ENOMEM;
 
@@ -2025,9 +2042,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		spin_lock(&cpa_lock);
+		cpa_lock();
 		ret = __change_page_attr(cpa, primary);
-		spin_unlock(&cpa_lock);
+		cpa_unlock();
 		if (ret)
 			goto out;
 

-- 
2.53.0



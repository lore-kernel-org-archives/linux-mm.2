Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB71CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1684E6B00A4; Sat,  3 Oct 2026 17:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D8F6B00A7; Sat,  3 Oct 2026 17:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052116B00A5; Sat,  3 Oct 2026 17:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA1CE6B00A5
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3678F80A19
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:10 +0000 (UTC)
X-FDA: 85282590540.10.9387065
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1ACC820004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pCVRhQHK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3OXLBagYKCIApvm33sksskpi.gsqpmry1-qqozego.svk@flex--lrizzo.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3OXLBagYKCIApvm33sksskpi.gsqpmry1-qqozego.svk@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBRuh0l2egpE1B41MMPnAEWjkJ8WwDrinCFew24ym24=;
	b=HpBCDyjWTfi/K50gSqdM8M7zqNkxYWJL8Nno6XBKAZXLkXpa4X2tnLJnFDpsIksVhqunP5
	hxOU2uYUkfDjiLike2cJ4Axjeb0SYrIWfBPeDqVLUfioViLXwWft0xeGz9iY5ZzhsH0Xqb
	jP5rgRlvtJKwPHuKpgh6253ikm1JS2A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pCVRhQHK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3OXLBagYKCIApvm33sksskpi.gsqpmry1-qqozego.svk@flex--lrizzo.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3OXLBagYKCIApvm33sksskpi.gsqpmry1-qqozego.svk@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062587;
	b=ipzldFM58Tz53qApGOXpawSJ6nX3SymcOQU8hWNVCBymKe+zxro39tzuOFvAkGQKY12SD7
	EGnbw6kjDvviql7hRV/yjf+u+sd9Bt/BbnpfQV2+epnPSkIYnIv7pw34A0YNFXznD3laqg
	vlePZC4nVGNj6HQWhTQdWo0mYPw81vA=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6abfb865707so666861a12.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062586; x=1791667386; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dBRuh0l2egpE1B41MMPnAEWjkJ8WwDrinCFew24ym24=;
        b=pCVRhQHKNI/QOyr3pSUgPiKLdrVjhkwq3wtaLQDi/iA7OjN671F9VCyloDJ3p6PUbe
         baa0WcnXTBB6rqCj7Mzx1XobsH+7HTVoM5HoEgTTzGu+6/o9iQdTfy+uKIuek5mNjJS4
         68PC/xa/GxIEfx8JN81oDXVxVfm8iL0S6zypv1jSglifyadxjCoV73EBjTPtDm9kmk3v
         meFFYgeX2W1K7DSr0JcuMN8/42Sxa+Fsw2S24Jw8XpjggLBAU2W3S+zY29XZ77XboGjS
         pVY0uvPkM+Ai/hrlWp2QUALs4qgEVvCiXbHKk0FxXAcvs8oEcDw5s28uuYc61h0uiO27
         ekQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062586; x=1791667386;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dBRuh0l2egpE1B41MMPnAEWjkJ8WwDrinCFew24ym24=;
        b=Y7ypo2UtfOH4c82IuMz74woPf3dGH4qrfSM/FY9x6AKZdNQEem3IfleTj8g4DhkFLS
         0cIKlDbIKMdhnleYSzhbuolifdzBzjYL7aqW9WfRp9Rr7K275qr4vzg5bPILsry8od4f
         EywS+mo4UN2t8Yk5PWOUscUuPKz2TS607oYbEURIU+R/xd/yigpW30Nvi8d/VFeUAej8
         wgBMk5oG00v6qTptt5ZQqAE0tcYexzbY91FYZa7BL/ITG3pjTV0k0OeLOzDRhiypLK7N
         VJV3Uji9UKaCbWh9GLnOLnTTQFHCp0DTJsviDV8ZGcosl240J6qu1XBDB/srWNQAFR+g
         J2JQ==
X-Forwarded-Encrypted: i=1; AKwUvBwjaGZlZs2D1u03uhxa+DOLzrNzHbH1mqDKJIoZpveaqsvXn5UtlCRcFAd7TYkywBqIEDLWJJBtcw==@kvack.org
X-Gm-Message-State: AFq9FYI+nL/wIjKkf4DI8Aa5aNHNSOC+z6VKX8uizATcCOWBrAGAX445
	6JTKWeGfWR3kOxKnudApuCUo5zlnQQhmDL39iw+MH/YDcqtMR/GbKMKhPa3fG59XCsFXRaKIOL9
	Z1xPYOQ==
X-Received: from edqt4.prod.google.com ([2002:aa7:d704:0:b0:6ac:be07:5a0a])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1950:b0:6af:82a0:d3b2
 with SMTP id 4fb4d7f45d1cf-6af9e2f9281mr5230450a12.29.1791062585244; Sat, 03
 Oct 2026 14:23:05 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:33 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-15-lrizzo@google.com>
Subject: [RFC: DMA_PMD 14/22] iommu/dma: Support decrypted and pinned DMA_PMD pages
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7agqxgc48xp8f97apiqzeac65ju6hfr6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1ACC820004
X-HE-Tag: 1791062586-669862
X-HE-Meta: U2FsdGVkX1+TT6Y7ZazgKAZd0xe8Iw8An30b2u1fJ9QTQtzeHzQb6k7CXNEShX59EMpd+SZW4QdP0ysH4Nt1mqW3nCsZa92OEaYEnYk7obVizKonhAolt/UFnEHnRQzQbJ952UaSoFYkism/Wq+8nN01B9P63wmDbFddGa4mS1jCfdiYD6ZOOQipgEYIaMK3Czi3OBXaUi51zBz9OcrVZ9cMTO5oslctbOWwJlYC/wW5C5u3oNUSWuZLWf5Trqwo+L6bj3LjbwfglRyyVCtxo3zBx2ONNyGHzVQPmrggVLvWBIoTsWTXXQc4XrFq2Z90QM3dJYvK9uldHTXMIEDMa0uQQ6q8FS6rHpVFsiT5DSALcciy/HYwYuWVNNN3aK/EU0ook/L5mfTKlz4YKb+kfVwGwdUEG3OXMKAkN9TNPyoLLZGlMYDM+YyR9KBjElaZ9PrUqL8pBlxNUHmPjP4WJmrYFCKH2t9LgS3tequdOgF/t4vLH0fcHg9cb0VhF/x76NUglZBWunIDR2LDwG1EqQ3yQu2ZS0KdyEEXsiOpFnOEioVImEcdd8ueznZL9lNjd1aVevmTxyO2fKrP8JNowQk5/GDMPdq7Axwtp+AzzuNz0o4yFJretjrF/mZLbqDU6emFUyjR0ltRDfT2wFNRygAt/OHREVfxhXAq7pNSFX3hdCPB5alj+jAIUVUDcqnNqXlWToBn6BnOi8Q6YT5hCuupe/vR/Xt+CG8ng7iq+6sU+ZoZOUU54J0vCn/J1m6w6qb4HaI/4FOA+o0g+rP/gjcg3w1FPhyQj9ubTXpbYXcZmULsxV59e6VcQ73NStC4PjfwzOrIbAjLK7p+tN4dF5Dbt1d7Sk405qj2HItsWOlUeQY8pEyFjb9jTYcGeDTZ1lCioMB1990gRalnMoSBMzBWo8EMGqny/s8s22+LtNCAZXuOLY9fZqkpTnvOquKy5zO6WXLg6zgH9JTGov2
 RzZAt3TJ
 yTZqpG2O/DnLNW2Z7TKXSPys11F5LjUNZt8LnIfsZ59HttYFaUlEQo96Ji5kInM8SR04UGg4EwFzCbwdfcZQ7rZ/pW2yri3nZtzZScLY7yyunv25F0svtEr7Dq6NMXXviUby2BDeO5DMrmSh42jv3HFXtSyRazbx4vw/Nx/cl2FUeGYCJcUdTR7uemfV5I67V3TayKH4IjB4oaqcWwI1uNyyjwNsiXX0rdxVCRdaaCTl87ZNbL5qnf2NCE7h3IcVUC6JGN08kV71akGdDaCf7UjM2fOX72dsBMO/d62gb+M4vDeSzTJjPhsR1kgB+k+XJ/hUxMi9O3lPloFw3dJCCT0KzpwvJtUXU5VY0YmgQSmOz5SoEQJfPMm6lRb+UiYUGtsiexvdYvL2Ar2j/Loeps1v+pBOb8cpJr6vRuJhg6EkXMgNGopHTC2Sezy+DGLo/xHq6ZSEoG61aVH8UXfORcQ3N2XgxKBt2HdrXOdS9qCTuFwI+mkR4F0e0IsARtAklOaajQ/Em7T8wCrNGmlmNuTi4J4LGY13ZWtsOb0eGML3Jhihk5mL1xsf18x9BclhOJ2IaMQMAk86WQxXZ+heDRPvsthiS+4qPsYuul4djfFkUTy9xuISRvvbbqEdaMH0SsWy+f8EeAEFWfK+y/Br3fouV6IA0W9g6OJAc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In Confidential Computing (CoCo) guests (AMD SEV-SNP, Intel TDX, ARM CCA),
guest memory is private/encrypted by default and DMA buffers must be
converted to shared/decrypted in the host page tables before a device
can access them. Similarly, in preemptible VMs, IO-accessible memory may
need to be pinned in the host on allocation and unpinned on release.

Doing these conversions on a per-packet 4K basis is prohibitive. With
DMA_PMD pools, a 2MB page is allocated once from the buddy allocator,
handed out in sub-blocks, and only returned when completely idle.

Add two module parameters (dma_pmd.decrypt and dma_pmd.pin, with
dma_pmd.decrypt auto-enabled when CC_ATTR_GUEST_MEM_ENCRYPT is active)
and per-PMD-page state flags in meta->flags (DMA_PMD_DECRYPTED,
DMA_PMD_PINNED):

- On 2MB page allocation (dma_pmd_add_page), call dma_pmd_page_prepare()
  before splitting the compound page to invoke set_memory_decrypted()
  and/or the host pin hook. Skip conversion if the caller cannot sleep
  (!gfpflags_allow_blocking), since set_memory_decrypted() acquires
  cpa_lock and allocates PTE pages.
- On 2MB page release (dma_pmd_release_page / dma_pmd_release_page_rcu),
  call dma_pmd_page_unprepare() before RCU free to restore
  set_memory_encrypted() and/or unpin before returning the 2MB page to
  the buddy allocator. If restoration fails, leak the 2MB page rather
  than returning a page with inconsistent encryption/pin state to buddy.
- In dma_pmd_shrink_scan(), defer decrypted/pinned pages to the async
  reclaim workqueue (dma_pmd_free_list) instead of calling
  dma_pmd_release_page() inline under fs_reclaim.
- Add dma_is_pmd_direct(phys) and use it in dma_direct_map_phys() to
  bypass swiotlb_map() bounce buffering for decrypted/pinned DMA_PMD
  pages, using phys_to_dma_direct() so force_dma_unencrypted() devices
  receive unencrypted DMA addresses.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-pmd-kunit.c |   2 +-
 drivers/iommu/dma-pmd-meta.c  |  15 +++-
 drivers/iommu/dma-pmd-pool.c  | 147 ++++++++++++++++++++++++++++------
 drivers/iommu/dma-pmd-priv.h  |  14 +++-
 include/linux/dma-pmd.h       |  15 ++++
 kernel/dma/direct.c           |   6 +-
 6 files changed, 168 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/dma-pmd-kunit.c b/drivers/iommu/dma-pmd-kunit.c
index c2363277e2ecd..7fcc2bcb315bc 100644
--- a/drivers/iommu/dma-pmd-kunit.c
+++ b/drivers/iommu/dma-pmd-kunit.c
@@ -53,7 +53,7 @@ static void test_meta_invalid_phys(struct kunit *test)
 
 static void dma_pmd_meta_set_pooled(struct dma_pmd_meta *m, bool pooled)
 {
-	WRITE_ONCE(m->pooled, pooled);
+	WRITE_ONCE(m->flags, pooled ? DMA_PMD_POOLED : 0);
 }
 
 static void test_meta_pooled_toggle(struct kunit *test)
diff --git a/drivers/iommu/dma-pmd-meta.c b/drivers/iommu/dma-pmd-meta.c
index 8f2bc7d77e5bd..744964d2c7974 100644
--- a/drivers/iommu/dma-pmd-meta.c
+++ b/drivers/iommu/dma-pmd-meta.c
@@ -8,6 +8,7 @@
 #include <linux/bitmap.h>
 #include <linux/cache.h>
 #include <linux/cacheflush.h>
+#include <linux/cc_platform.h>
 #include <linux/dma-pmd.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
@@ -64,10 +65,22 @@ static __always_inline struct dma_pmd_meta *__dma_pmd_meta_of_pfn(unsigned long
 
 bool __dma_is_pmd_page(unsigned long pfn)
 {
-	return READ_ONCE(__dma_pmd_meta_of_pfn(pfn)->pooled);
+	return READ_ONCE(__dma_pmd_meta_of_pfn(pfn)->flags) & DMA_PMD_POOLED;
 }
 EXPORT_SYMBOL(__dma_is_pmd_page);
 
+bool __dma_is_pmd_direct(unsigned long pfn)
+{
+	u8 flags = READ_ONCE(__dma_pmd_meta_of_pfn(pfn)->flags);
+
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
+	    !(flags & DMA_PMD_DECRYPTED))
+		return false;
+	return (flags & DMA_PMD_POOLED) &&
+	       (flags & (DMA_PMD_DECRYPTED | DMA_PMD_PINNED));
+}
+EXPORT_SYMBOL(__dma_is_pmd_direct);
+
 /**
  * dma_pmd_meta_of_pfn - Metadata for a PFN known to be used by DMA_PMD.
  * @pfn: PFN the caller already holds a struct page for
diff --git a/drivers/iommu/dma-pmd-pool.c b/drivers/iommu/dma-pmd-pool.c
index 1d4244ba422a3..deacb6f7d3610 100644
--- a/drivers/iommu/dma-pmd-pool.c
+++ b/drivers/iommu/dma-pmd-pool.c
@@ -9,6 +9,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/cache.h>
+#include <linux/cc_platform.h>
 #include <linux/debugfs.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-pmd.h>
@@ -22,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 #include <linux/seq_file.h>
+#include <linux/set_memory.h>
 #include <linux/shrinker.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -39,6 +41,14 @@ static LLIST_HEAD(dma_pmd_free_list);
 /* Dedicated WQ_MEM_RECLAIM workqueue, can run without allocations. */
 static struct workqueue_struct *dma_pmd_wq __ro_after_init;
 
+/* Mark pooled PMD pages decrypted for DMA (auto-enabled on CoCo guests). */
+static bool dma_pmd_decrypt __read_mostly;
+module_param_named(decrypt, dma_pmd_decrypt, bool, 0644);
+
+/* Pin pooled PMD pages in the host hypervisor on allocation and unpin on release. */
+static bool dma_pmd_pin __read_mostly;
+module_param_named(pin, dma_pmd_pin, bool, 0644);
+
 /*
  * Running total and global ceiling on DMA_PMD pages pinned across all pools.
  * If zero, it is set at boot at 1/8 of total RAM.
@@ -65,6 +75,70 @@ static void dma_pmd_pool_free_kref(struct kref *kref)
 	dma_pmd_schedule_reclaim();
 }
 
+static int dma_pmd_page_prepare(struct page *page, struct dma_pmd_meta *meta,
+				bool can_block)
+{
+	bool want_decrypt = READ_ONCE(dma_pmd_decrypt);
+	bool want_pin = READ_ONCE(dma_pmd_pin);
+	void *vaddr = page_address(page);
+	int ret;
+
+	if (!want_decrypt && !want_pin)
+		return 0;
+
+	/*
+	 * Decryption and host-pinning hypercalls may sleep. In atomic context,
+	 * leave DMA_PMD_DECRYPTED/PINNED unset so the page is still pooled but
+	 * uses normal swiotlb bounce buffering when required.
+	 */
+	if (!can_block) {
+		pr_warn_ratelimited("%s: cannot block but want %s %s\n", __func__,
+				    want_decrypt ? "decrypt" : "", want_pin ? "pin" : "");
+		return 0;
+	}
+
+	/*
+	 * Explicit page decryption is for CoCo guests (where force_dma_unencrypted()
+	 * is true), not bare-metal SME hosts where 64-bit devices and the IOMMU
+	 * set the encryption bit in DMA addresses and IOMMU PTEs.
+	 */
+	if (want_decrypt && !WARN_ON_ONCE(cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))) {
+		ret = set_memory_decrypted((unsigned long)vaddr, 1 << PMD_ORDER);
+		if (ret)
+			return ret;
+		/* Initialize cleartext cachelines after flipping encryption state. */
+		memset(vaddr, 0, PMD_SIZE);
+		meta->flags |= DMA_PMD_DECRYPTED;
+	}
+
+	if (want_pin) {
+		/* Hook point for hypervisor GPA range pinning. */
+		meta->flags |= DMA_PMD_PINNED;
+	}
+
+	return 0;
+}
+
+static int dma_pmd_page_unprepare(struct dma_pmd_meta *meta)
+{
+	struct page *page = pfn_to_page(dma_pmd_meta_to_pfn(meta));
+
+	if (meta->flags & DMA_PMD_PINNED) {
+		/* Hook point for hypervisor GPA range unpinning. */
+		WRITE_ONCE(meta->flags, meta->flags & ~DMA_PMD_PINNED);
+	}
+
+	if (meta->flags & DMA_PMD_DECRYPTED) {
+		if (set_memory_encrypted((unsigned long)page_address(page),
+					 1 << PMD_ORDER)) {
+			pr_warn_ratelimited("dma_pmd: leaking PMD page that could not be re-encrypted\n");
+			return -EIO;
+		}
+		WRITE_ONCE(meta->flags, meta->flags & ~DMA_PMD_DECRYPTED);
+	}
+	return 0;
+}
+
 /*
  * Releasing an idle PMD page proceeds in three stages:
  *
@@ -74,7 +148,7 @@ static void dma_pmd_pool_free_kref(struct kref *kref)
  *    pushed locklessly onto dma_pmd_free_list and dma_pmd_reclaim_work is
  *    scheduled on dma_pmd_wq.
  * 2. In process context, dma_pmd_release_page() unmaps all IOMMU domains
- *    (dma_pmd_unmap_all()), clears meta->pooled so new lockless readers stop
+ *    (dma_pmd_unmap_all()), clears DMA_PMD_POOLED so new lockless readers stop
  *    entering @meta, and queues dma_pmd_release_page_rcu() via call_rcu().
  * 3. After an RCU grace period (once no concurrent dma_pmd_free_page() reader
  *    can still be dereferencing @meta), dma_pmd_release_page_rcu() unfreezes
@@ -97,22 +171,21 @@ static void dma_pmd_release_page_rcu(struct rcu_head *head)
 	 * block is freed, the PMD frame can be reallocated and @meta overwritten.
 	 */
 	struct dma_pmd_meta *meta = container_of(head, struct dma_pmd_meta, rcu);
-	struct page *page = pfn_to_page(dma_pmd_meta_to_pfn(meta));
+	struct page *block, *page = pfn_to_page(dma_pmd_meta_to_pfn(meta));
 	struct dma_pmd_pool *pool = READ_ONCE(meta->pool);
-	unsigned int nr = DMA_PMD_BLOCKS(pool->order);
-	unsigned int order = pool->order;
+	unsigned int order = pool->order, i, nr = DMA_PMD_BLOCKS(order);
+	bool leak = READ_ONCE(meta->flags) & DMA_PMD_DECRYPTED;
 	unsigned long flags;
-	unsigned int i;
-
-	for (i = 0; i < nr; i++) {
-		struct page *block = page + (i << order);
 
-		page_ref_unfreeze(block, 1);
-		__free_pages(block, order);
+	if (!leak) {
+		for (i = 0; i < nr; i++) {
+			block = page + (i << order);
+			page_ref_unfreeze(block, 1);
+			__free_pages(block, order);
+		}
+		atomic_long_dec(&dma_pmd_nr_pages);
 	}
 
-	atomic_long_dec(&dma_pmd_nr_pages);
-
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->pmd_free_cnt++;
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -138,7 +211,9 @@ static void dma_pmd_release_page(struct dma_pmd_meta *meta)
 	 * dma_is_pmd_page() just before this may still be reading @meta, so
 	 * the PMD page and its metadata entry must outlive the grace period.
 	 */
-	WRITE_ONCE(meta->pooled, false);
+	WRITE_ONCE(meta->flags, meta->flags & ~DMA_PMD_POOLED);
+	dma_pmd_page_unprepare(meta);
+
 	call_rcu(&meta->rcu, dma_pmd_release_page_rcu);
 }
 
@@ -392,20 +467,33 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 		return NULL;
 	}
 
-	/* Fails with -EBUSY if a concurrent PFN walker holds a speculative ref. */
-	if (split_page_compound(page, PMD_ORDER, pool->order)) {
+	meta = dma_pmd_meta_of_pfn(page_to_pfn(page));
+	memset(meta, 0, sizeof(*meta));
+	meta->pool = pool;
+	spin_lock_init(&meta->map_lock);
+
+	if (dma_pmd_page_prepare(page, meta, can_block)) {
 		__free_pages(page, PMD_ORDER);
 		atomic_long_dec(&dma_pmd_nr_pages);
 		return NULL;
 	}
 
-	meta = dma_pmd_meta_of_pfn(page_to_pfn(page));
-	memset(meta, 0, sizeof(*meta));
-	meta->pool = pool;
-	spin_lock_init(&meta->map_lock);
+	/* Fails with -EBUSY if a concurrent PFN walker holds a speculative ref. */
+	if (split_page_compound(page, PMD_ORDER, pool->order)) {
+		if (!dma_pmd_page_unprepare(meta)) {
+			__free_pages(page, PMD_ORDER);
+			atomic_long_dec(&dma_pmd_nr_pages);
+		}
+		return NULL;
+	}
 
-	bitmap_set(meta->dirty_bitmap, 0, nr);
-	meta->nr_dirty = nr;
+	if (meta->flags & DMA_PMD_DECRYPTED) {
+		bitmap_set(meta->free_bitmap, 0, nr);
+		meta->nr_free = nr;
+	} else {
+		bitmap_set(meta->dirty_bitmap, 0, nr);
+		meta->nr_dirty = nr;
+	}
 
 	kref_get(&pool->refcount);
 
@@ -418,7 +506,7 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 	 * function returns and the caller publishes the PMD page under
 	 * @pool->lock, whose release orders both stores against every consumer.
 	 */
-	WRITE_ONCE(meta->pooled, true);
+	WRITE_ONCE(meta->flags, meta->flags | DMA_PMD_POOLED);
 
 	return meta;
 }
@@ -764,10 +852,18 @@ static unsigned long dma_pmd_shrink_scan(struct shrinker *shrink,
 	/*
 	 * Retiring is done outside both locks: dma_pmd_release_page() unmaps
 	 * from the IOMMU, which is far too long to hold pool->lock for.
+	 * Pages that need set_memory_encrypted() cannot be released under
+	 * fs_reclaim (CPA allocates PTE pages on x86); hand them to the
+	 * reclaim workqueue instead.
 	 */
 	list_for_each_entry_safe(meta, tmp, &release_list, list) {
-		list_del(&meta->list);
-		dma_pmd_release_page(meta);
+		list_del_init(&meta->list);
+		if (meta->flags & (DMA_PMD_DECRYPTED | DMA_PMD_PINNED)) {
+			llist_add(&meta->llnode, &dma_pmd_free_list);
+			dma_pmd_schedule_reclaim();
+		} else {
+			dma_pmd_release_page(meta);
+		}
 	}
 	srcu_read_unlock(&dma_pmd_srcu, srcu_idx);
 
@@ -806,6 +902,9 @@ static int __init dma_pmd_init(void)
 	if (!dma_pmd_max_pages)
 		dma_pmd_max_pages = max(totalram_pages() >> (PMD_ORDER + 3), 16UL);
 
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		dma_pmd_decrypt = true;
+
 	/*
 	 * Reclaim frees memory, so it must not queue behind arbitrary work on
 	 * system_wq when the machine is already short of it. Failure is not
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
index b411ecb1fdafc..8c7a50d5b7220 100644
--- a/drivers/iommu/dma-pmd-priv.h
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -107,10 +107,16 @@ enum {
 #define DMA_PMD_META_SHIFT		8
 #define DMA_PMD_META_SIZE		BIT(DMA_PMD_META_SHIFT)
 
+enum {
+	DMA_PMD_POOLED		= BIT(0),
+	DMA_PMD_DECRYPTED	= BIT(1),
+	DMA_PMD_PINNED		= BIT(2),
+};
+
 /**
  * struct dma_pmd_meta - Metadata for a single DMA_PMD page
- * @pooled:	True while this page is owned by an dma_pmd_pool (offset 0)
- *		read locklessly by dma_is_pmd_page().
+ * @flags:	Bitmask of DMA_PMD_POOLED, DMA_PMD_DECRYPTED, DMA_PMD_PINNED
+ *		(offset 0), read locklessly by dma_is_pmd_page() and dma_is_pmd_direct().
  * @nr_free:	Number of zeroed available blocks in @free_bitmap
  * @nr_dirty:	Number of dirty available blocks in @dirty_bitmap
  * @map_lock:	Spinlock protecting slow-path updates to @domains_mapped
@@ -138,7 +144,7 @@ enum {
  * physical pages (128 KB per GB of RAM).
  */
 struct dma_pmd_meta {
-	bool pooled;
+	u8 flags;
 	u16 nr_free;
 	u16 nr_dirty;
 	spinlock_t map_lock;
@@ -160,7 +166,7 @@ struct dma_pmd_meta {
 	DECLARE_BITMAP(dirty_bitmap, 1U << PMD_ORDER) ____cacheline_aligned;
 } __aligned(DMA_PMD_META_SIZE);
 
-static_assert(offsetof(struct dma_pmd_meta, pooled) == 0);
+static_assert(offsetof(struct dma_pmd_meta, flags) == 0);
 static_assert(sizeof(struct dma_pmd_meta) == DMA_PMD_META_SIZE);
 
 static inline unsigned int dma_pmd_meta_avail(const struct dma_pmd_meta *m)
diff --git a/include/linux/dma-pmd.h b/include/linux/dma-pmd.h
index 7b7e9477d44e1..c9775e86979f9 100644
--- a/include/linux/dma-pmd.h
+++ b/include/linux/dma-pmd.h
@@ -16,6 +16,7 @@ struct dma_pmd_pool;
 extern void *dma_pmd_meta_array;
 
 bool __dma_is_pmd_page(unsigned long pfn);
+bool __dma_is_pmd_direct(unsigned long pfn);
 
 static inline bool dma_is_pmd_page(unsigned long pfn)
 {
@@ -29,6 +30,15 @@ static inline bool dma_is_pmd_page(unsigned long pfn)
 	return __dma_is_pmd_page(pfn);
 }
 
+static inline bool dma_is_pmd_direct(phys_addr_t phys)
+{
+	/* Pairs with smp_store_release() in dma_pmd_meta_init(). */
+	if (likely(!smp_load_acquire(&dma_pmd_meta_array)))
+		return false;
+
+	return __dma_is_pmd_direct(phys >> PAGE_SHIFT);
+}
+
 bool __dma_pmd_free_page(struct page *page);
 
 static inline bool dma_pmd_free_page(struct page *page)
@@ -117,6 +127,11 @@ static inline bool dma_is_pmd_page(unsigned long pfn)
 	return false;
 }
 
+static inline bool dma_is_pmd_direct(phys_addr_t phys)
+{
+	return false;
+}
+
 static inline bool dma_pmd_free_page(struct page *page)
 {
 	return false;
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index da665ca22d5c0..a786c2869b869 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -7,6 +7,7 @@
 #include <linux/memblock.h> /* for max_pfn */
 #include <linux/export.h>
 #include <linux/mm.h>
+#include <linux/dma-pmd.h>
 #include <linux/dma-map-ops.h>
 #include <linux/scatterlist.h>
 #include <linux/pfn.h>
@@ -679,7 +680,10 @@ dma_addr_t dma_direct_map_phys(struct device *dev, phys_addr_t phys,
 			attrs |= DMA_ATTR_CC_SHARED;
 	}
 
-	if (is_swiotlb_force_bounce(dev)) {
+	if (dma_is_pmd_direct(phys)) {
+		if (force_dma_unencrypted(dev))
+			attrs |= DMA_ATTR_CC_SHARED;
+	} else if (is_swiotlb_force_bounce(dev)) {
 		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 			return DMA_MAPPING_ERROR;
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog



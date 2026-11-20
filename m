Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8526074AEC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UB743jpk
Received: by kanga.kvack.org (Postfix)
	id 0ED8B6B06DD; Thu, 19 Nov 2026 20:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5106B06F1; Thu, 19 Nov 2026 20:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE0C6B0721; Thu, 19 Nov 2026 20:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53D166B06DD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CDC8080D3A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:09 +0000 (UTC)
X-FDA: 85453708578.14.B5A8F4D
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0FBF14000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UB743jpk;
	spf=pass (imf26.hostedemail.com: domain of 3Op3_agYKCNE8E5MMB3BB381.zB985AHK-997Ixz7.BE3@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3Op3_agYKCNE8E5MMB3BB381.zB985AHK-997Ixz7.BE3@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136828;
	b=4wtuuRily6hKpNwcVrpcgeMsped/SSmLRYksHyGX1AAqxoJZ2vlEooBVxAMTFoFrlkUstJ
	84jKJT5PXYV0h+PmWQ874uSOHwO6EYDhDt9OE3nP6q/bGV3SW2ZMh1FPkoqyPqFVVGm/u/
	AC7sP7z/EbZr1oCckDbTH05cjWvanz8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghCioAWnsLQak5k0kvPvfr8deKgEuthAAq8UagRgRJs=;
	b=5bQSu/1pjLfIsJAfmvSPClxuw9ltzK8vypZdhPRsGZz+zWBvErH0jrLGgK9J2E16M2BEDM
	yxY4HKGHIHfZs1LY9WThspd1lv3iRtWGeFZ+Kq/crvNnnNh10dhCilkzBWt0iyRpk8PaFd
	1gHnM7x0uDRwwVk/YrkjftbhV69TxjM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UB743jpk;
	spf=pass (imf26.hostedemail.com: domain of 3Op3_agYKCNE8E5MMB3BB381.zB985AHK-997Ixz7.BE3@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3Op3_agYKCNE8E5MMB3BB381.zB985AHK-997Ixz7.BE3@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c49df8fe86eso38312966b.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136827; x=1795741627; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ghCioAWnsLQak5k0kvPvfr8deKgEuthAAq8UagRgRJs=;
        b=UB743jpkGxNlZQkpdMVNxDRGoB1iE2nD93Xm8y6Vf5sI5vC+AmByFDg5/Ulj8C+z0Y
         vQP5vfZfPDz8S9ckIFbnOLHXI02TuQ+d4YjWx/ESu9XiRzXGCquW/aCx90Wrm6F+7hkv
         pGCbyDVmSRdj8AtAcB4K0oXg1VHLDusjnu+zwskscC0DUeflupNmFDuRQjYjdYj0udGz
         0aiUynqOHoLZYBtExgVhkXBswZChL+r8pmjwK7h6Db4xj/0OcnIzD4c1MhG9Boays0oj
         1gGONrCvCtai19I6uitRvbyxO247VfYCaHCSkrzsCgrGG7ahwRRpMhszodw9Or/lLMv+
         iwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136827; x=1795741627;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ghCioAWnsLQak5k0kvPvfr8deKgEuthAAq8UagRgRJs=;
        b=kxOzK/MiuzMvA7nbwiBxrpC9NclMKjBevafanZmB7MgJoLcph7OALCMdJyWHHGp3oM
         cgn5CzDZeTjJRRMZrcDD1km4Tl9/6hA4MakqyqQWheVcL0Q04S0WKTSLEJc1wG0HhyXE
         o9UvcSmwwKBl1sc8aMDTGobzFwnJeN3LsteedCzBkHFLkrTsssWh/zWnbI2uFfdfVeJZ
         +PxTTgSLRD4VTN5Z3rs/i9ZgAQURc70jrGWbhlPCfAA9yeUAAPNKzqDpgJ+31ZZzoMqe
         btlGdPJgN1ANlTgfpPTUHbC0/Rj/ZqEU8ftTEUu/sgUBzNumSk2zCJjp/FIJCEDoO1hr
         F/NA==
X-Forwarded-Encrypted: i=1; AL+hErGsksxLGHeRKgLNHAVc/kDTwdHErixdBTMEmugZxhj/OQIGiekPT318Ol89FF3LL0WXw9S7M8V8kg==@kvack.org
X-Gm-Message-State: APuU4Z/FWhExSR8JhpVoBCQgTP557+qE06QB13k++fa6Q4y6OJ0Iqjrw
	2eCTNhuvvw4us6s5G8ljv5jaJc0my5CPl2z4qi+OGpznZXCHkzWEfqGDDbH/D5MMgZeV5aynQyw
	0lk1dqw==
X-Received: from edpj3.prod.google.com ([2002:aa7:c0c3:0:b0:6b8:a76b:dc47])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:13c8:b0:6b5:8695:f839
 with SMTP id 4fb4d7f45d1cf-6ba37ed815dmr762145a12.45.1795136826091; Thu, 19
 Nov 2026 17:07:06 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:35 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-6-lrizzo@google.com>
Subject: [RFC PATCH v3 05/25] mm: Add global cap and shrinker for PISA pages
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0FBF14000B
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: n7qh8u14unfdi7u741ifqnhgjn4tzxm4
X-HE-Tag: 1795136827-638094
X-HE-Meta: U2FsdGVkX19Nz6K7yv+EzVEcGOkZVJ/yub4U2/z/nraW7uEql2f2a8QaDX3KgqgjmHSYx1z6QW9h2gs/CTu8S17cEujGLpLJ45vyjpLnRjyUCFP4+72iBTkKW4SOj6RifAzxlYsq3lbgQ3KA/81oYTlnnM8xC5YrluP6o/BMid4Wq+WXQ88FBNITaxkgM2/LL8FKLyfoizOcJuq2d4h8FgVsIrefUHejwog1hoWb36Xp6OY4oLJNz3vTs7sjrTMQTcItl2zWwGi+kTPtR2KXVoVxCjn0oloK0lsre4EKdj99IcNCSz3BEF8ViiPrMXe4nP6e4icWMfH0gOsHtpJMqoT8bjvUfJ/BJ7Wlp4Mn/sRiZ0DhUuPjAENZkXgkbcnj5KvDQoMKq80BKUQV5HTg48cLh9Xvd40JHS3hcNlVYvTVbm1OD3o36Kl0wV4TA3p2Qp3Up9322qx3HaaL8m+FdYsiKwxg+uSCYy2d+Kh35TWlTU3EIgtJVs/OLUqA9Fy863eZ82+/Zo8mt6ehxvxM9JNqiAicK7Uw+u81PHJxKytvrszdWxMhS5PCkT0KpS3/8Qp8WNrtm4EXTgzVPWnBO4owS0XYdPF7c7dJCIm+Z75bbyUojpj9S+hOJG7plm9a+Y0EAGlMW4arGHrQiMbfsJ8qRRVWPAZcbmiT4qEt86FdNxk9b/LPjG3d8E6wUIdoQeR8Qy8MloDBs7zQnttEeZJWAgTc93hIv5LITWJZLlOUDF8awsondhM4tZsVv6ZCMB+sVgBNfP7L6VdnmwqGuuKh483cEwbJ+yYtbmL9y5W3CCLIW5t1ouiog1Fxp69fJsjVMaRYYBZomijs6EV0svdPjCfHyhbEEnFMz7wseKpt3BOlNXqpjetbFcxcRJoq0FWLn5zJHX0rtkHol8H4wNxpWGNtunnS+PN7lDksgrnqeu4f5Gpby3s1t3ZO+RaO9P2d9o2KKGu9R0PS+ov
 6BnAlBoW
 9FUwOqgJ15o15OmfrGis8TnGnkH5Jfx2WEr+gwPTlt9FwjXFX+GJRtNsvdtcd/hRJjQqWLQA1bEnrv0dKzF/LvInQOVVEsFOCUy9IVLRReCjxEA5zWJPUugUu+QDmopYVu5uI9pkmpozAvxrKIH2APpmqgf70SqR4Et4wDPLxcKsc1mFfrymgj/XqglJ7n6/hjTFIQDC82N/+MirJXxLx5GZ2WJOTJ+Z1JR1awnrSF8rnoxuZT4Ghtq6RNJrp959BY9x8Hf3soV1pDF33AsOTtkz8tCCsveH2MULa3bmwuEG/xkmwZDTrTxHOrXWqmTCBeDdVwg35gR7SsLEfzBnaQcHaY8XWUSZJNww10UDq5hWcwf0DiHZjeCqQYXFas0meAh/adFeKZ5MRPNSdH5mopSPzmhseAzX4G587fuM1plMIlbkj32JwkELdsNi34wn9HwKjgnhcE5RGMVi1SSfFDCQwoHPXAfC8V1eBkaoi6tT9b9zF+KgLtj01LdU+m251P+HEKHyLg5yYbY/SvtvRsO+EubIcTkEfczulfzx3/XXKXyNSAF0T5cOI+UEqKQiFBqx/mSizhnDeaKjPdNUEx8HqnLU3Y1P4iwlitvHP0nRIBa9wCBrRHiZFvzfC8PTsTrYssNM/w0WKW0zbTt66G+QcKY4ANBTIegu/GzSy/8BJz3aHsirygtf2r8kG+9Kj2ho7vKJQPVXfTarArEASW1MphBHdOc9gKUZan2elfA+d//MZtsdE7PfBIxeb/RM+6K3/OTX0OwF5elxcmAsXWtQPXfVTnLPzteXOHiP5RrLn8ssI09IYyX3LmJRdl6YiWYVWmJBHvM1re8M2rqBBPxvwyvgF+bQ7IlIou3jptBWJXA5ilGvHm7iNP8czGZpapmaWa5ZdDXCEAn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add mechanisms to bound the number of unused PISA pages:

 - a global ceiling, pisa.max_pages, on the number of PISA pages pinned
   across all allocators and reservoirs, defaulting to one eighth of RAM,
   with a floor for small machines.

 - a shrinker that, under reclaim, drains the per-node reservoirs first
   and then completely idle pages across all allocators.
   Idle pages are detached under the allocator lock but retired outside
   it, to avoid holding the lock during the expensive unmaps/iotlb flush.

 - recycle gating for caller pools (pisa_page_can_recycle()): blocks that
   belong to old, sparse partial pages are returned to their allocator
   instead of being recycled in place, so those pages can drain to idle.
   Tuned by pisa.compact, pisa.target_usage_percent and pisa.old_ms.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/pisa-iommu.h |   3 +
 include/linux/pisa.h       |  20 +++++-
 mm/pisa-alloc.c            | 116 ++++++++++++++++++++++++++++++++++
 mm/pisa-kunit.c            |  16 +++++
 mm/pisa-meta.c             | 123 ++++++++++++++++++++++++++++++++++++-
 mm/pisa-node.c             |  33 +++++++++-
 mm/pisa-priv.h             |  38 ++++++++++++
 7 files changed, 344 insertions(+), 5 deletions(-)

diff --git a/include/linux/pisa-iommu.h b/include/linux/pisa-iommu.h
index 098430c5f864a..b29b405804193 100644
--- a/include/linux/pisa-iommu.h
+++ b/include/linux/pisa-iommu.h
@@ -29,6 +29,7 @@ struct pisa_meta {
 	u16 nr_clean;		/* zeroed available blocks in @clean_bitmap */
 	u16 nr_dirty;		/* dirty available blocks in @dirty_bitmap */
 	u8 on_list;		/* current placement in @pa (PISA_LIST_*) */
+	bool drain;		/* sparse old page draining back to @idle */
 	u32 slot;		/* dense index in @pisa_meta_array and IOVA windows */
 	struct pisa_alloc *pa;	/* NULL for reservoir pages */
 	struct list_head list;	/* node in @pa lists or pisa_node.pages */
@@ -37,6 +38,7 @@ struct pisa_meta {
 		struct llist_node llnode; /* node in lockless pisa_free_list */
 		struct rcu_head rcu;
 	};
+	unsigned long alloc_jiffies;	/* jiffies when page entered/re-entered use */
 
 	DECLARE_BITMAP(clean_bitmap, _PISA_MAX_BLOCKS) ____cacheline_aligned;
 	DECLARE_BITMAP(dirty_bitmap, _PISA_MAX_BLOCKS) ____cacheline_aligned;
@@ -45,6 +47,7 @@ struct pisa_meta {
 static_assert(sizeof(struct pisa_meta) == _PISA_META_SIZE);
 
 extern struct pisa_meta *pisa_meta_array;
+extern unsigned int pisa_nr_slots;
 
 struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn);
 bool pisa_quarantine_page(struct pisa_meta *meta);
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index f07432d2e6809..3307fae1dbd66 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -40,12 +40,18 @@ enum {
 #define PISA_ACTIVE		BIT(_PISA_ACTIVE)	/* set up as a PISA page, not retired yet */
 #define PISA_QUARANTINED	BIT(_PISA_QUARANTINED)	/* IOMMU unmap failed: never reuse */
 
-/* Enabled on first pisa_meta_init() to activate fast-path hooks. */
+/*
+ * Static keys guarding all kernel hooks:
+ * - @pisa_key: enabled on first device opt-in (pisa_meta_init()).
+ * - @pisa_recycle_check_key: enabled when pisa.compact or pisa.target_usage_percent > 0.
+ */
 DECLARE_STATIC_KEY_FALSE(pisa_key);
+DECLARE_STATIC_KEY_FALSE(pisa_recycle_check_key);
 
 extern u32 *pisa_pfn2slot;
 
 int pisa_meta_init(void);
+bool __pisa_page_can_recycle(const struct page *page);
 
 static inline bool pisa_enabled(void)
 {
@@ -103,6 +109,13 @@ static inline struct page *pisa_virt_to_page(const void *addr)
 	return is_pisa_page(page) ? page : NULL;
 }
 
+/* Hook for skb_page_frag_refill() and __pisa_free_page() (@pisa_recycle_check_key). */
+static inline bool pisa_page_can_recycle(const struct page *page)
+{
+	return !static_branch_unlikely(&pisa_recycle_check_key) ||
+	       __pisa_page_can_recycle(page);
+}
+
 #else /* !CONFIG_PISA */
 
 static inline int pisa_meta_init(void) { return -EOPNOTSUPP; }
@@ -112,5 +125,10 @@ static inline bool is_pisa_page(const struct page *page) { return false; }
 static inline bool is_pisa_phys(phys_addr_t phys) { return false; }
 static inline struct page *pisa_virt_to_page(const void *addr) { return NULL; }
 
+static inline bool pisa_page_can_recycle(const struct page *page)
+{
+	return true;
+}
+
 #endif /* CONFIG_PISA */
 #endif /* _LINUX_PISA_H */
diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index e7f7ed5dca067..c09f321b07eeb 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -4,6 +4,7 @@
  * See Documentation/core-api/pisa.rst for the architecture overview.
  */
 
+#include <kunit/visibility.h>
 #include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
@@ -24,6 +25,7 @@
 #include <linux/page_table_check.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/mm.h>
+#include <linux/shrinker.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -39,6 +41,30 @@ LLIST_HEAD(pisa_free_list);
 /* Dedicated WQ_MEM_RECLAIM workqueue, can run without allocations. */
 static struct workqueue_struct *pisa_wq __ro_after_init;
 
+/* Global count and ceiling on PISA pages across all allocators and reservoirs (0 = 1/8 RAM). */
+atomic_long_t pisa_nr_pages __cacheline_aligned_in_smp;
+unsigned long pisa_max_pages __read_mostly;
+
+static int pisa_max_pages_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned long v;
+	int ret = kstrtoul(val, 0, &v);
+
+	if (ret)
+		return ret;
+	/* Once sized at boot, 0 selects the default and the slot count caps the value. */
+	if (pisa_nr_slots)
+		v = min_t(unsigned long, v ?: pisa_default_max_pages(), pisa_nr_slots);
+	WRITE_ONCE(pisa_max_pages, v);
+	return 0;
+}
+
+static const struct kernel_param_ops pisa_max_pages_ops = {
+	.set = pisa_max_pages_set,
+	.get = param_get_ulong,
+};
+module_param_cb(max_pages, &pisa_max_pages_ops, &pisa_max_pages, 0644);
+
 /* Max completely idle PISA pages kept per allocator before async release (at least 1). */
 static unsigned int pisa_max_idle __read_mostly = 1;
 
@@ -286,6 +312,7 @@ static bool pisa_return_block_locked(struct pisa_alloc *pa, struct page *block)
 		__set_bit(idx, meta->dirty_bitmap);
 		meta->nr_dirty++;
 	}
+	pa->blocks_in_use--;
 	return pisa_place_meta(meta);
 }
 
@@ -450,6 +477,7 @@ static unsigned int pisa_scan_bitmap(struct pisa_meta *meta, bool dirty,
 			break;
 	}
 	*countp -= used;
+	pa->blocks_in_use += used;
 	return got;
 }
 
@@ -465,6 +493,7 @@ static struct pisa_meta *pisa_pick_meta(struct pisa_alloc *pa, bool zero)
 		meta = list_first_entry_or_null(&pa->idle, struct pisa_meta, list);
 		if (meta && meta->nr_clean) {
 			pa->num_idle_pages--;
+			WRITE_ONCE(meta->alloc_jiffies, jiffies);
 			WRITE_ONCE(pa->idle_jiffies, jiffies);
 			return meta;
 		}
@@ -488,6 +517,7 @@ static struct pisa_meta *pisa_pick_meta(struct pisa_alloc *pa, bool zero)
 	if (!list_empty(&pa->idle)) {
 		meta = list_last_entry(&pa->idle, struct pisa_meta, list);
 		pa->num_idle_pages--;
+		WRITE_ONCE(meta->alloc_jiffies, jiffies);
 		WRITE_ONCE(pa->idle_jiffies, jiffies);
 		return meta;
 	}
@@ -524,6 +554,8 @@ static unsigned int take_blocks(struct pisa_meta *meta, unsigned int want,
 		meta->nr_clean = 0;
 		meta->nr_dirty = 0;
 	}
+	if (READ_ONCE(meta->drain))
+		WRITE_ONCE(meta->drain, false);
 	pisa_place_meta(meta);
 
 	return got;
@@ -553,8 +585,10 @@ static unsigned long __pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp, unsigne
 			goto out;
 		spin_lock_irqsave(&pa->lock, flags);
 		meta->pa = pa;
+		WRITE_ONCE(meta->alloc_jiffies, jiffies);
 		/* Set PISA_ACTIVE after @meta is fully set up. */
 		pisa_meta_set_flags(meta, PISA_ACTIVE);
+		pa->stats.page_alloc++;
 	}
 	spin_unlock_irqrestore(&pa->lock, flags);
 
@@ -657,12 +691,83 @@ bool __pisa_free_page(struct page *page, unsigned int order)
 	return true;
 }
 
+/* Shrinker: releases reservoir pages first, then idle allocator pages. */
+static unsigned long pisa_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+{
+	unsigned long nr = pisa_reservoir_count();
+	struct pisa_alloc *pa;
+
+	guard(read_lock)(&pisa_allocs_lock);
+	list_for_each_entry(pa, &pisa_allocs, node)
+		nr += READ_ONCE(pa->num_idle_pages);
+
+	return nr << PISA_ORDER;
+}
+
+/* Detach PISA pages from @list onto @release_list up to @nr_to_scan base pages. */
+unsigned long pisa_shrink_list(spinlock_t *lock, struct list_head *list,
+			       unsigned int *nr, struct list_head *release_list,
+			       unsigned long nr_to_scan)
+{
+	unsigned long freed = 0;
+
+	guard(spinlock_irqsave)(lock);
+	while (freed < nr_to_scan && !list_empty(list)) {
+		/* Dirty idle pages are at the tail: keep the pre-zeroed ones at the head. */
+		struct pisa_meta *meta = list_last_entry(list, struct pisa_meta, list);
+
+		WRITE_ONCE(meta->on_list, PISA_LIST_NONE);
+		list_move(&meta->list, release_list);
+		WRITE_ONCE(*nr, *nr - 1);
+		freed += 1UL << PISA_ORDER;
+	}
+
+	return freed;
+}
+
+VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+{
+	struct pisa_meta *meta, *tmp;
+	struct pisa_alloc *pa;
+	unsigned long freed;
+	LIST_HEAD(release_list);
+
+	freed = pisa_reservoir_shrink(&release_list, sc->nr_to_scan);
+
+	if (freed < sc->nr_to_scan) {
+		read_lock(&pisa_allocs_lock);
+		list_for_each_entry(pa, &pisa_allocs, node) {
+			freed += pisa_shrink_list(&pa->lock, &pa->idle,
+						  &pa->num_idle_pages, &release_list,
+						  sc->nr_to_scan - freed);
+
+			if (freed >= sc->nr_to_scan)
+				break;
+		}
+		read_unlock(&pisa_allocs_lock);
+	}
+
+	/* Retiring must not run under @pa->lock. */
+	list_for_each_entry_safe(meta, tmp, &release_list, list) {
+		list_del_init(&meta->list);
+		pisa_release_page(meta);
+	}
+
+	/* Charge do_shrink_slab() for the full PISA pages reclaimed. */
+	sc->nr_scanned = freed;
+
+	return freed ?: SHRINK_STOP;
+}
+
 static int __init pisa_init(void)
 {
+	struct shrinker *shrink;
 	int nid;
 
 	pisa_node_init();
 
+	pisa_slots_configure();
+
 	/* Preallocate the supported per-node allocators. */
 	for_each_node_state(nid, N_MEMORY) {
 		pisa_alloc_ensure(&pisa_nodes[nid].pa[0][0], nid, 0,
@@ -677,6 +782,17 @@ static int __init pisa_init(void)
 	if (!pisa_wq)
 		pr_warn("pisa: no reclaim workqueue, falling back to system_wq\n");
 
+	shrink = shrinker_alloc(0, "pisa");
+	if (!shrink) {
+		pr_warn("pisa: shrinker registration failed\n");
+		return 0;
+	}
+
+	shrink->count_objects = pisa_shrink_count;
+	shrink->scan_objects = pisa_shrink_scan;
+	shrink->seeks = DEFAULT_SEEKS;
+	shrinker_register(shrink);
+
 	return 0;
 }
 subsys_initcall(pisa_init);
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index ea605cb6afe5b..cd2bfbfb0f1a7 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -7,6 +7,7 @@
 #include <linux/gfp.h>
 #include <linux/pisa.h>
 #include <linux/mm.h>
+#include <linux/shrinker.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
 
@@ -108,8 +109,10 @@ static void test_alloc_and_recycle(struct kunit *test)
 		{ 0, false },
 		{ SKB_FRAG_PAGE_ORDER, true },
 	};
+	struct shrink_control sc = { .nr_to_scan = ULONG_MAX };
 	struct page *p1, *p2, *bulk[3];
 	struct pisa_alloc *pa;
+	unsigned long old_max;
 
 	KUNIT_EXPECT_NULL(test, pisa_alloc_create(first_memory_node, 0, DMA_NONE));
 	KUNIT_EXPECT_NULL(test, pisa_alloc_create(first_memory_node, PISA_ORDER + 1,
@@ -124,6 +127,7 @@ static void test_alloc_and_recycle(struct kunit *test)
 
 		pa = pisa_node_pa(first_memory_node, order, cases[i].ro);
 		KUNIT_ASSERT_NOT_NULL(test, pa);
+		pisa_shrink_scan(NULL, &sc);
 		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_ACCOUNT));
 		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_DMA32));
 		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_THISNODE));
@@ -164,6 +168,7 @@ static void test_alloc_and_recycle(struct kunit *test)
 
 		if (p2)
 			__free_pages(p2, order);
+		pisa_shrink_scan(NULL, &sc);
 	}
 
 	/* Plain alloc_page() without __GFP_PISA_* comes from the buddy allocator. */
@@ -171,6 +176,16 @@ static void test_alloc_and_recycle(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, p1);
 	KUNIT_EXPECT_FALSE(test, is_pisa_page(p1));
 	__free_pages(p1, 0);
+
+	/* Global budget cap (pisa_max_pages = 0) refuses new PISA pages. */
+	pa = pisa_node_pa(first_memory_node, SKB_FRAG_PAGE_ORDER, true);
+	KUNIT_ASSERT_NOT_NULL(test, pa);
+	old_max = READ_ONCE(pisa_max_pages);
+	WRITE_ONCE(pisa_max_pages, 0);
+	WRITE_ONCE(pisa_reservoir_max, 0);
+	KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL));
+	WRITE_ONCE(pisa_reservoir_max, 16);
+	WRITE_ONCE(pisa_max_pages, old_max);
 }
 
 /* Wait for the reclaim worker and its RCU callback to retire @meta. */
@@ -221,6 +236,7 @@ static void test_quarantine(struct kunit *test)
 	/* Give the page to @pa with half of its blocks in use. */
 	spin_lock_irqsave(&pa->lock, flags);
 	meta->pa = pa;
+	pa->stats.page_alloc++;	/* balanced by page_free when the page is retired */
 	meta->nr_clean = bpp / 2;
 	pisa_meta_set_flags(meta, PISA_ACTIVE);
 	pisa_place_meta(meta);
diff --git a/mm/pisa-meta.c b/mm/pisa-meta.c
index 7cdb1c45d65c8..30f0f2f6ef628 100644
--- a/mm/pisa-meta.c
+++ b/mm/pisa-meta.c
@@ -84,6 +84,41 @@ static_assert(PISA_SHIFT <= SUBSECTION_SHIFT);
 DEFINE_STATIC_KEY_FALSE(pisa_key);
 EXPORT_SYMBOL(pisa_key);
 
+static unsigned int pisa_compact __read_mostly;
+static unsigned int pisa_target_usage_percent __read_mostly;
+static unsigned int pisa_old_ms __read_mostly;
+
+/* Enabled when pisa.compact > 0 or pisa.target_usage_percent > 0. */
+DEFINE_STATIC_KEY_FALSE(pisa_recycle_check_key);
+EXPORT_SYMBOL(pisa_recycle_check_key);
+
+static int pisa_recycle_param_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+
+	ret = (kp->arg == &pisa_target_usage_percent) ?
+	      param_set_uint_minmax(val, kp, 0, 100) : param_set_uint(val, kp);
+
+	if (!ret) {
+		if (pisa_compact || pisa_target_usage_percent)
+			static_branch_enable(&pisa_recycle_check_key);
+		else
+			static_branch_disable(&pisa_recycle_check_key);
+	}
+	return ret;
+}
+
+static const struct kernel_param_ops pisa_recycle_param_ops = {
+	.set = pisa_recycle_param_set,
+	.get = param_get_uint,
+};
+
+/* Stop recycling partial-page blocks when free blocks exceed @pisa_compact PISA pages. */
+module_param_cb(compact, &pisa_recycle_param_ops, &pisa_compact, 0644);
+/* Stop recycling partial pages older than @pisa_old_ms when usage < @pisa_target_usage_percent%. */
+module_param_cb(target_usage_percent, &pisa_recycle_param_ops, &pisa_target_usage_percent, 0644);
+module_param_cb(old_ms, &pisa_recycle_param_ops, &pisa_old_ms, 0644);
+
 /*
  * Number of compact metadata / PISA-page IOVA slots (half of physical RAM). Each
  * PISA page holds one slot in [0, pisa_nr_slots), indexing @pisa_meta_array[slot]
@@ -121,8 +156,13 @@ static unsigned int pisa_slot_hint;	/* no free slot below this */
  */
 void pisa_slots_configure(void)
 {
-	pisa_nr_slots = min_t(unsigned long, totalram_pages() >> (PISA_ORDER + 1),
-			      PISA_MAX_SLOTS);
+	unsigned long max_slots = min_t(unsigned long, totalram_pages() >> (PISA_ORDER + 1),
+					PISA_MAX_SLOTS);
+
+	if (!pisa_max_pages)
+		pisa_max_pages = pisa_default_max_pages();
+	pisa_max_pages = min(pisa_max_pages, max_slots);
+	pisa_nr_slots = max_slots;
 }
 
 /* Return metadata for @pfn, or shared sink @pisa_meta_nil (flags == 0) if unbacked. */
@@ -180,6 +220,10 @@ bool pisa_place_meta(struct pisa_meta *meta)
 			to_list |= meta->on_list & PISA_LIST_SPARSE;
 	}
 
+	/* Done draining once idle or dense (on @idle, PISA_LIST_SPARSE only means dirty). */
+	if ((avail == bpp || !(to_list & PISA_LIST_SPARSE)) && READ_ONCE(meta->drain))
+		WRITE_ONCE(meta->drain, false);
+
 	if (to_list != meta->on_list) {
 		struct list_head *head;
 
@@ -206,6 +250,81 @@ bool pisa_place_meta(struct pisa_meta *meta)
 	return avail == bpp && pa->num_idle_pages > pa->max_idle_pages;
 }
 
+/*
+ * __pisa_page_can_recycle - Check if a block can stay cached in a caller pool
+ * @page: Block head page
+ *
+ * Called on the recycle fast path (per-CPU cache, TX page_frag) while the
+ * caller still owns @page (so its PISA page cannot be retired).
+ *
+ * Allow recycling when:
+ * - @meta is dense (not on a sparse partial list),
+ * - @meta is not already marked @drain and was recently allocated (within
+ *   @pisa_old_ms), or
+ * - unused blocks in @pa are within @pisa_compact * bpp or used capacity is
+ *   at least @pisa_target_usage_percent%.
+ * Otherwise mark @meta->drain and refuse recycling until @meta drains to idle
+ * or becomes dense again on allocation.
+ *
+ * Return: true if @page can be recycled in place, false if it should be
+ * released back to its allocator so sparse PISA pages can drain.
+ */
+static bool pisa_meta_can_recycle(struct pisa_meta *meta)
+{
+	unsigned int compact, target_pct, old_ms;
+	unsigned long bpp, in_use, free_blocks, max_age;
+	const struct pisa_alloc *pa;
+	long held;
+
+	/* Let a quarantined page drain: never recycle its blocks in place. */
+	if (unlikely(READ_ONCE(meta->flags) & PISA_QUARANTINED))
+		return false;
+
+	if (!(READ_ONCE(meta->on_list) & PISA_LIST_SPARSE))
+		return true;
+
+	if (READ_ONCE(meta->drain))
+		return false;
+
+	old_ms = READ_ONCE(pisa_old_ms);
+	if (old_ms) {
+		max_age = msecs_to_jiffies(min(old_ms, PISA_OLD_MS_MAX));
+		if (!time_after(jiffies, READ_ONCE(meta->alloc_jiffies) + max_age))
+			return true;
+	}
+
+	pa = READ_ONCE(meta->pa);
+	if (!pa || READ_ONCE(meta->list.prev) == &pa->partial ||
+	    READ_ONCE(meta->list.prev) == &pa->partial_dirty)
+		return true;
+
+	bpp = PISA_BLOCKS(pa->order);
+	held = pisa_alloc_held_pages(pa);
+	in_use = READ_ONCE(pa->blocks_in_use);
+	free_blocks = held > 0 && (unsigned long)held * bpp > in_use ?
+		      (unsigned long)held * bpp - in_use : 0;
+
+	compact = READ_ONCE(pisa_compact);
+	target_pct = READ_ONCE(pisa_target_usage_percent);
+	if ((!compact && !target_pct) ||
+	    (compact && free_blocks <= (unsigned long)compact * bpp) ||
+	    (target_pct && in_use * 100 >= (unsigned long)held * bpp * target_pct)) {
+		WRITE_ONCE(meta->alloc_jiffies, jiffies);
+		return true;
+	}
+
+	WRITE_ONCE(meta->drain, true);
+	return false;
+}
+
+bool __pisa_page_can_recycle(const struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	return !is_pisa_pfn(pfn) || pisa_meta_can_recycle(pisa_meta_of_pfn(pfn));
+}
+EXPORT_SYMBOL(__pisa_page_can_recycle);
+
 /* PTE for @addr in a vmalloc metadata table, or NULL if not allocated. */
 static pte_t *pisa_meta_pte(unsigned long addr)
 {
diff --git a/mm/pisa-node.c b/mm/pisa-node.c
index 5b9b44186b967..29f6ba866b633 100644
--- a/mm/pisa-node.c
+++ b/mm/pisa-node.c
@@ -82,6 +82,10 @@ static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
 			return ERR_PTR(-EAGAIN);
 	}
 
+	/* Racy check against global ceiling across allocators and reservoirs. */
+	if (atomic_long_read(&pisa_nr_pages) >= READ_ONCE(pisa_max_pages))
+		return ERR_PTR(-ENOSPC);
+
 	/*
 	 * Long-lived active pages must be unmovable, lowmem, non-compound, and
 	 * must not dip into emergency reserves or trigger OOM/warnings.
@@ -110,6 +114,8 @@ static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
 		memalloc_flags_restore(memflags);
 
 	meta = pisa_meta_of_pfn(page_to_pfn(page));
+
+	atomic_long_inc(&pisa_nr_pages);
 	*clean = (gfp & __GFP_ZERO) || want_init_on_alloc(0) || want_init_on_free();
 
 	return meta;
@@ -138,10 +144,10 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 	/* The page has been unmapped from every domain by pisa_release_page() */
 	pisa_slot_free(meta);
 
-	/* Possibly still mapped by a device: leak it. */
+	/* Possibly still mapped by a device: leak it, still charged. */
 	if (flags & PISA_QUARANTINED)
 		return;
-
+	atomic_long_dec(&pisa_nr_pages);
 	for (unsigned int i = 0; i < PISA_BLOCKS(order); i++) {
 		struct page *block = page + (i << order);
 
@@ -158,9 +164,13 @@ void pisa_release_page(struct pisa_meta *meta)
 
 		pisa_slot_free(meta);
 		__free_pages(page, PISA_ORDER);
+		atomic_long_dec(&pisa_nr_pages);
 		return;
 	}
 
+	/* Count it now: pisa_alloc_held_pages() must not see a retiring page as held. */
+	atomic64_inc(&meta->pa->stats.page_free);
+
 	/* pisa_unmap_all_domains(meta) will be called here once IOMMU mappings are added. */
 
 	/* Clear PISA_ACTIVE before the RCU grace period so new readers stop entering. */
@@ -322,6 +332,25 @@ unsigned long pisa_reservoir_count(void)
 	return nr;
 }
 
+/* Detach up to @nr_to_scan base pages from reservoirs onto @release_list. */
+unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan)
+{
+	unsigned long freed = 0;
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct pisa_node *node = &pisa_nodes[nid];
+
+		if (!READ_ONCE(node->nr_pages))
+			continue;
+		freed += pisa_shrink_list(&node->lock, &node->pages, &node->nr_pages,
+					  release_list, nr_to_scan - freed);
+		if (freed >= nr_to_scan)
+			break;
+	}
+	return freed;
+}
+
 void __init pisa_node_init(void)
 {
 	for (int nid = 0; nid < MAX_NUMNODES; nid++) {
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index 46170da8a0f0d..a191ede9bf3ce 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -79,6 +79,12 @@ static inline unsigned int pisa_meta_avail(const struct pisa_meta *meta)
 	return meta->nr_clean + meta->nr_dirty;
 }
 
+/* Per-allocator statistics, see pisa_allocs_show(). */
+struct pisa_alloc_stats {
+	u64		page_alloc;
+	atomic64_t	page_free;
+};
+
 /* Allocator managing blocks of a fixed order, carved from PISA pages. */
 struct pisa_alloc {
 	/* First cacheline: hot fields touched on block alloc and free. */
@@ -91,12 +97,22 @@ struct pisa_alloc {
 	unsigned int		num_idle_pages;
 	unsigned int		max_idle_pages;
 	unsigned long		idle_jiffies;	/* last change of @idle at/above @max_idle_pages */
+	unsigned long		blocks_in_use;	/* blocks handed out and not yet freed */
 	/* Cold. */
 	int			nid;		/* home NUMA node */
 	struct list_head	node;		/* node in pisa_allocs */
 	char			name[48];
+	struct pisa_alloc_stats	stats;
 } ____cacheline_aligned;
 
+/* Active non-idle PISA pages held by @pa, for soft compaction checks. */
+static inline long pisa_alloc_held_pages(const struct pisa_alloc *pa)
+{
+	return (long)(READ_ONCE(pa->stats.page_alloc) -
+		      atomic64_read(&pa->stats.page_free)) -
+	       READ_ONCE(pa->num_idle_pages);
+}
+
 /* Max block order for predefined per-node allocators in pisa_node.pa[][]. */
 #define PISA_MAX_ALLOC_ORDER	3U
 
@@ -117,6 +133,12 @@ extern struct pisa_node pisa_nodes[MAX_NUMNODES];
 int pisa_meta_ensure_pfn(unsigned long pfn, bool can_block);
 void pisa_slots_configure(void);
 
+/* Default global cap: 1/8 of RAM, at least 16 PISA pages. */
+static inline unsigned long pisa_default_max_pages(void)
+{
+	return max(totalram_pages() >> (PISA_ORDER + 3), 16UL);
+}
+
 static inline unsigned long pisa_meta_to_pfn(const struct pisa_meta *meta)
 {
 	return meta->base_pfn;
@@ -129,6 +151,16 @@ static inline struct page *pisa_meta_to_page(const struct pisa_meta *meta)
 
 void pisa_slot_free(struct pisa_meta *meta);
 
+struct shrink_control;
+struct shrinker;
+#if IS_ENABLED(CONFIG_KUNIT)
+unsigned long pisa_shrink_scan(struct shrinker *shrink, struct shrink_control *sc);
+#endif
+
+/* Global PISA page budget across all allocators and per-node reservoirs. */
+extern atomic_long_t pisa_nr_pages;
+extern unsigned long pisa_max_pages;
+
 static inline int pisa_sanitize_nid(int nid)
 {
 	if ((unsigned int)nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
@@ -175,12 +207,18 @@ static inline struct page *pisa_alloc(struct pisa_alloc *pa, gfp_t gfp)
 	return page;
 }
 
+#define PISA_OLD_MS_MAX		100000U
+unsigned long pisa_shrink_list(spinlock_t *lock, struct list_head *list,
+			       unsigned int *nr, struct list_head *release_list,
+			       unsigned long nr_to_scan);
+
 /* pisa-node.c: per-NUMA-node PISA page reservoir and work item */
 extern unsigned int pisa_reservoir_max;
 void pisa_node_init(void);
 void pisa_schedule_reservoir(void);
 struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean);
 unsigned long pisa_reservoir_count(void);
+unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan);
 
 #endif /* CONFIG_PISA */
 #endif /* _MM_PISA_PRIV_H */
-- 
2.56.1.809.ga0b61035b5-goog



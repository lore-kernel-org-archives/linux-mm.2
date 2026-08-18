Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26752C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 22:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080E56B0092; Tue, 18 Aug 2026 18:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0596A6B0093; Tue, 18 Aug 2026 18:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB05E6B0095; Tue, 18 Aug 2026 18:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7A886B0092
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:59:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A02AC0390
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:26 +0000 (UTC)
X-FDA: 85115908332.14.9E10CE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9D85D1C000E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:59:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TyX8nUis;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787093964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX1DWIadQ6nIRR1fyXkWC0pb34Vk39QSCu5CRyVrb0A=;
	b=b0HhJHmnGXrSwi5Q0twIvoexGVpFQB3dADMjrrqER6ht2UoX8nlsBBB925+q159HWcK7fh
	2rLZEvffVmb0f1bkUdiy/ZTXMEtrEpsQlYczQI7j5AqLjo2nJoDOQForN7R3uUIMQi+MvB
	jiRyencJ8/NeeYN0ZLxA4/HMMH7K7YI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787093964;
	b=djadTXcHi+r17I7dH1fb8l7tqk8jf8k6X+wlQmoupUmBPV08E6mmrWyyX5NadRXFKSwh+2
	NaOY0WVZxgAYPxQGGt0WdrLEFfQBsQgHWsrC0J1/U2PJAETxNGW/VjWs0tMPUsGDgd93xa
	+W/3SztU2g7wNdgzzF+q5HBt7BHKWac=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TyX8nUis;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3AA043FB8;
	Tue, 18 Aug 2026 22:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA8E1F00A3D;
	Tue, 18 Aug 2026 22:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787093962;
	bh=HX1DWIadQ6nIRR1fyXkWC0pb34Vk39QSCu5CRyVrb0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyX8nUis49ca4jtpbJ98TM2fg/c4aU445zPNr7AmIN7lFk2ZW8SS9+OnUsAYqofR9
	 Yy9kscqbH5fQFNtNq19IH2IPrSk/zdBlAGEa5PrDfnxFt/yWNSe//1UQ0+rdd2dHnQ
	 USWpKcr5QBR84gMw/mwE9X0cnqHvFO/7p7NQ+77CXfLHm7o6RFTQ3ptqpydBk2d/1i
	 46CL2IasQhIqDnFrQJoXtI7QrzOF1FttzzVk+yFPTrqTq3uh6vVaKxqbdMJ4feI2wM
	 qJitG39O7M/ngE89xcIjRj5En6Rj4Gc3Ebq/HqBkc7Hkrr6wFwVvFbad8xdXV8PNvO
	 LC5MinjdK4MxA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@kernel.org,
	ziy@nvidia.com,
	hughd@google.com,
	ackerleytng@google.com,
	usama.arif@linux.dev,
	joannelkoong@gmail.com,
	hannes@cmpxchg.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v3 1/4] mm: allow smaller large folios to use lru_cache
Date: Wed, 19 Aug 2026 06:59:01 +0800
Message-Id: <20260818225904.55236-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260818225904.55236-1-baohua@kernel.org>
References: <20260818225904.55236-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kfw3tcmwzwzaab7cjda9bxwziad84xxr
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D85D1C000E
X-HE-Tag: 1787093964-979990
X-HE-Meta: U2FsdGVkX19xhcT47RBp9C8qkgCmtUJoBEPbxHwRCjsXHFTFAEGBkPQNROCtmTT8o4iOEfyYEaYGPPeORcgy+zU0GMy6wIX+rMThXOwGF3skHE0qYFrCvCUr9ctk7x1FOF1d9f0vnMLcmq1NhqAMIo4plJ/FwHLpt4pKFcDRdac/6D6uZ/H1t1KYcvddofKCluAgNR9rZ6dsrp1tmS+No0kT4pDsuOiJjQsOTqtih4JkILBMQ0QFufBTXlEO+EB2+bsLlhCxvglE7S9XP8pH0997mlhom7JSQYlHdqujNMdvmBi+87LxJpEozQnvO7/7SL14rroUuXaStkNt3kU91is9CkaIkszZy+/J9zy1JP6WmflcU/G0vPzXaRd3BVoAmBNnuiso/6eA2NZhOTvXi3wb4m1WYtXntXBjibHSrrytw3NnMAp6QzSVRF3tQUEMS+T0gAeDYz83eCSkF9TSmfgcHLwshKqgs8WInvZaT8TJYdXgBB/VbEL6EW0GnboYLC5t1sT7S/ExtFNnScUvM4lpklLZXb9Jq93HbT6ap7MecXRueJpQju2cHDA41ZxISxlBhmTcfa5PGVaI1t8JeTlp/Qo0G0ZK3PTvRagrPTBmZgHm/gu4wc55tA4I4vFNrglPRfsUNsS+D09b/P5TEB+hU3/O0/T45zmi6mC4M3CsohfIRAFoE7Bz2VI+k+ZAYvbNAJVA0WglwMOz/4ElmfkWD6n+/lpvxgjLig3BTI8W4lt68S3VWtzuXBWBka6dwRfFhzJtMtP0/aaUEyoF01l1yHx+JAD/ZN5Qr42AxfqeC7m0/3a9azYwBAMNYmgvp0an5Pw5+WNaMxGfkcSgLOsoLWXcSu+7m3b8TGN1moHBppG/XE0N64fPvViqwYFqBL23IUOGrs9CsXdG4qsxsNaMLlwQoWe/oBnEIaIoJDRrHyy3MSKH/JiIhMUe69+W2v1R80aQ+raI8gBx8Su
 KC+9aDCH
 AZcnOjhz82NIZBqnTSL589jQy0dPe9wEq0kuqk6GLSRzrrNOdtxPzEVi51NvVyqgte5ATafnKylNvHellxjzXs8i1ndyRuwXCZJET4gQiVil+WT8JEG0O26ID1wlfGKja4DJFk/NwsH9nahvxAXDSz0Np2JAoyHvKHyFIAtw2Oh/tQd9XHb+vnXkWhDcpZnx0Y21odbPNwNc/TmwEq+1DcOsvxj9YNuhqY/h9C+f3e1WaWGTeJgP0wjLnT1vA2KH0HJDYyTHkREHFQTGbFqSffq5xADl59DaclkGr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For systems that primarily use smaller-order large folios, enabling the
lru_cache can help reduce lock contention.

For higher-order large folios, the number of folios involved is likely
to be smaller, making lock contention less significant.

This patch enables the lru_cache for large folios whose `nr_pages` is
smaller than `FOLIO_BATCH_SIZE`. To avoid holding too many pages in the
lru_cache, which could affect accounting and reclamation, we also limit
the total number of pages in the cache to `FOLIO_BATCH_SIZE`.

To track the number of pages, this patch adds an `unsigned short
nr_pages` field to `struct folio_batch`. It cannot overflow because the
batch contains at most `FOLIO_BATCH_SIZE` folios, each of which has fewer
than `FOLIO_BATCH_SIZE` pages.

For non-LRU caches, `folio_batch` only needs to track the number of
folios, so `nr_pages` is left at zero.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/folio_batch.h | 25 +++++++++++++++++++++++++
 mm/folio.c                  | 10 +++++++++-
 mm/internal.h               |  4 ++--
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
index b45946adc50b..ffc7de091fa3 100644
--- a/include/linux/folio_batch.h
+++ b/include/linux/folio_batch.h
@@ -10,6 +10,7 @@
 #define _LINUX_FOLIO_BATCH_H
 
 #include <linux/types.h>
+#include <linux/mm.h>
 
 /* 31 pointers + header align the folio_batch structure to a power of two */
 #define FOLIO_BATCH_SIZE	31
@@ -28,6 +29,7 @@ struct folio;
 struct folio_batch {
 	unsigned char nr;
 	unsigned char i;
+	unsigned short nr_pages;
 	bool percpu_pvec_drained;
 	struct folio *folios[FOLIO_BATCH_SIZE];
 };
@@ -42,6 +44,7 @@ static inline void folio_batch_init(struct folio_batch *fbatch)
 {
 	fbatch->nr = 0;
 	fbatch->i = 0;
+	fbatch->nr_pages = 0;
 	fbatch->percpu_pvec_drained = false;
 }
 
@@ -49,6 +52,7 @@ static inline void folio_batch_reinit(struct folio_batch *fbatch)
 {
 	fbatch->nr = 0;
 	fbatch->i = 0;
+	fbatch->nr_pages = 0;
 }
 
 static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
@@ -78,6 +82,27 @@ static inline unsigned folio_batch_add(struct folio_batch *fbatch,
 	return folio_batch_space(fbatch);
 }
 
+/**
+ * folio_batch_add_lru_cache() - Add a folio to a batch of lru_cache
+ * @fbatch: The folio batch.
+ * @folio: The folio to add.
+ *
+ * The folio is added to the end of the batch.
+ * The batch must have previously been initialised using folio_batch_init().
+ *
+ * Return: 0 if the lru_cache is filled with more than FOLIO_BATCH_SIZE
+ *         pages; otherwise, the number of available slots.
+ */
+static inline unsigned folio_batch_add_lru_cache(struct folio_batch *fbatch,
+		struct folio *folio)
+{
+	fbatch->folios[fbatch->nr++] = folio;
+	fbatch->nr_pages += (unsigned short)folio_nr_pages(folio);
+	if (fbatch->nr_pages > FOLIO_BATCH_SIZE)
+		return 0;
+	return folio_batch_space(fbatch);
+}
+
 /**
  * folio_batch_next - Return the next folio to process.
  * @fbatch: The folio batch being processed.
diff --git a/mm/folio.c b/mm/folio.c
index 59c477120b9a..e5820d7263e8 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -219,7 +219,7 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+	if (!folio_batch_add_lru_cache(this_cpu_ptr(fbatch), folio) ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
@@ -981,6 +981,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 	int i, j;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
+	unsigned long nr_pages = 0;
 
 	for (i = 0, j = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
@@ -1020,6 +1021,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 
 		if (j != i)
 			folios->folios[j] = folio;
+		nr_pages += folio_nr_pages(folio);
 		j++;
 	}
 	if (lruvec)
@@ -1030,6 +1032,12 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 	}
 
 	folios->nr = j;
+	/*
+	 * For lru_cache, track the number of pages; for non-LRU caches,
+	 * folio_batch->nr_pages is always 0.
+	 */
+	if (folios->nr_pages > 0)
+		folios->nr_pages = nr_pages;
 	mem_cgroup_uncharge_folios(folios);
 	free_unref_folios(folios);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..06adf78e13a2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -48,9 +48,9 @@ static inline bool folio_may_be_lru_cached(const struct folio *folio)
 	/*
 	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
 	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
-	 * will be sensible, but nobody has implemented and tested that yet.
+	 * will be sensible.
 	 */
-	return !folio_test_large(folio);
+	return folio_nr_pages(folio) < FOLIO_BATCH_SIZE;
 }
 
 static inline void lru_cache_enable(void)
-- 
2.34.1



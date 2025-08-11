Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB98CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CEED6B0135; Mon, 11 Aug 2025 04:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6EB6B0136; Mon, 11 Aug 2025 04:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCDD6B0137; Mon, 11 Aug 2025 04:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08C3C6B0135
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:41:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC188BA922
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:39 +0000 (UTC)
X-FDA: 83763833118.02.23ABDD0
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB614C0013
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="I1V64/Qa";
	spf=pass (imf10.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/ct59qYuG3RzWBHGmFR3jjZkQ8rYUbub3Dfwy3OQL8=;
	b=mI5IBpPZEqYJDr6TOo5HcJzfEfkTnPV+ora1k8hQUNtH0dWaIYZlhVSz47E3C45s/Scz6g
	+ZiV/Co2CKt8yHZ+WDtR6YUi6biXKUH48iggnnBZRx6Emgh0FOaOJUWj0M3/zZBHtXAerV
	EHEVB79qu5x/LFi7sVFQsPYV9frFA/4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="I1V64/Qa";
	spf=pass (imf10.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754901698; a=rsa-sha256;
	cv=none;
	b=UqgYzLlKFLwlD7v4kl3iMH9KbPoyeeeySfbJEnWuVbnCTSPdoBnQmTgZWqPIXKkrfr/rPS
	r7MhKAPsUq3n/PBEVMKwnvY2rPaY2eUAj31gOyS4c5lceMch0oFg9SZVtf7MXjQ4aGUv7t
	jCQT4qx7jofqUhOFcnGvftiGFSGFrOU=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4c0p5T5kCFz9sQm;
	Mon, 11 Aug 2025 10:41:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754901693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/ct59qYuG3RzWBHGmFR3jjZkQ8rYUbub3Dfwy3OQL8=;
	b=I1V64/Qa0hW8Rv/GwNRA7NkvQNI/IiT42ZOqRmActPnPYDdt/AlPaJekhUaRyfIQHlKqP3
	MHEM1VZIq+MoRYSteiJOOq6BoKgtOwTLJLyzhsuxvCaGpIyUx0U7UE9nB7WoYxAKKq9UqC
	ykDyhGids0yVZxjcIrV6McddnYZ1h4Q7bpV+oglCwJGv+7mcVjDs7lrgtzgMdcdP42pbBE
	xMKkSNG4v5pd4AnJ9oExDbVvbqeenPWqy1BqZZiUM6XnMBdI5GQVQj9cjHh/vev5EvKU1S
	rp19Jazq1ULSQQymX9cnSYmUfEGKOSlqjMKzddFVJ63NMVIXfqEaZ278FNkX/Q==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v3 1/5] mm: rename huge_zero_page to huge_zero_folio
Date: Mon, 11 Aug 2025 10:41:09 +0200
Message-ID: <20250811084113.647267-2-kernel@pankajraghav.com>
In-Reply-To: <20250811084113.647267-1-kernel@pankajraghav.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ihiitfh96z5kg91artyqu9z7mrfs4amm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB614C0013
X-Rspam-User: 
X-HE-Tag: 1754901697-570837
X-HE-Meta: U2FsdGVkX18ZYZgMM5Wm8SJHbrlPK29WZJfXr8RAmuHyUSflRu4CKGP2jXl3YOCGIIMu1+kotdnmteC1wZwz63VNA+Pxs7oDYvNi5tTU54YoBbaHyreBWpJNJ+p0h+jmoPYl7tHedyvUpxif2JaaGruquhUKxAEW7frZ91hVtP8LurZull0ew8ur26ceSE2iJJLN50kgrWJPWs4rhNV1c5Gzq07KRmwBGxdJQAmlSbtot0fkjtBsInBW9C3cWeZbXqUSi9J3lIugAQ5ncl61eQRlYVAYDCy9je05k6S3k4/vPETdkTO0nGOS9SSWkDw8mu67IxQIT2uz/A+wyHVTIY35o5+HgALbmI1kL9ZrzpClEl8uQzOvOv55AdNDSx+IKDNZIdKFJFO7ldeT41tVSQmYfkdfDWfEygRFgQUqcYZ4mXFeqQOmV/+6GDvn1c6CNt3/Uc65cXOap8KnJRMxo385M5XtESlcJrpm3U1nLmDyueiZZrEmFg8W0hH3PWxQLX56jzB6xtZV+9Eq4B3o+zXPu/C7deovpKCJTNT997wxOjNe9NvRYCZl3to55OGVoQW279A1rKR176mYoSLugMHmesLz1pHHucRFK+46Vyz9ixyCoB3TX7Iu3pFr1dAxn7kiE9E3T0oE39hwuxEYVNK7Y6Nul8LPgUAOziMpuI/MOaJsll65DSitKF1+Bh5Nrx6ma3GnwKJU8EQR3hGWHhnSwMFyzmaQCGa39rKccJSf+XDS8qFC7Hy0D9CfdDDGbD9Q51VGoegEf3zTlttARlGmPQ0yh5SZLVmH5m1qr3iSPNSpgrrjVhqbe0NnRmHeqo2TneKVlvo5gPS2AsOOh7NpZxuMO70Li+vU5A7t++TiQ6/b8GuuZR+4CUiBmLS4LkD5NaAXYwKPnws+kNkzYcOQDVDQQUYbbWphURO1xOGyLcB+MCw912avTmupVD/eJ5gV+A8GoaLIOdmp6kw
 6Q77zgv4
 Gp59uYnU419u7Dq3/ytRCsnq1ywfBBx4eV4i6YqVK1GdfqEFR1wDb1os+dndGwmvJPZ0+taCtP4/J4GZYJkVRr/z23I8p2ir7KFIKTJ+6fCuOigrcoVwCuk+AGL25QOKMFddz4+k9lwDOvnJ3aTtkosV77vAL/B/zeMbL+gLRDkMilbyZGOhhLBDb+6755nKzCUWM+iWx0Vj+JQXMExs5wmLd3ElrD7HY+XCLcHsqj9WNXCxbw3iZBnBQJnINM3Q6ljpVOzoQV5T9gpKU66c2bRDcipzYdKijKTex4zt+bWTILPFHLrr3J4L+HwWr6dcwmM+G5e+Ak9iBNOLJZNxUPdhYjxIRlVX2lgA511iYsMzxIRQG0OKCZ2VGxd3nrB3QIv70M2SzRDNtQGJ6ko+EH9GAqY3U4hWg+8J/IPpSrtfap8m4QRzg2O9Pf/Nu/uvna2+yfFebFQrYjpQolZrkUQOxlr/DpyMcfqWbTLr19rgQVFfH15TkBS/O5ZUAxcjMG+dB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

As the transition already happened from exposing huge_zero_page to
huge_zero_folio, change the name of the shrinker and the other helper
function to reflect that.

No functional changes.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 mm/huge_memory.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..6625514f622b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -207,7 +207,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	return orders;
 }
 
-static bool get_huge_zero_page(void)
+static bool get_huge_zero_folio(void)
 {
 	struct folio *zero_folio;
 retry:
@@ -237,7 +237,7 @@ static bool get_huge_zero_page(void)
 	return true;
 }
 
-static void put_huge_zero_page(void)
+static void put_huge_zero_folio(void)
 {
 	/*
 	 * Counter should never go to zero here. Only shrinker can put
@@ -251,11 +251,11 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
 		return READ_ONCE(huge_zero_folio);
 
-	if (!get_huge_zero_page())
+	if (!get_huge_zero_folio())
 		return NULL;
 
 	if (test_and_set_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
-		put_huge_zero_page();
+		put_huge_zero_folio();
 
 	return READ_ONCE(huge_zero_folio);
 }
@@ -263,18 +263,18 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
-		put_huge_zero_page();
+		put_huge_zero_folio();
 }
 
-static unsigned long shrink_huge_zero_page_count(struct shrinker *shrink,
-					struct shrink_control *sc)
+static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
+						  struct shrink_control *sc)
 {
 	/* we can free zero page only if last reference remains */
 	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
 }
 
-static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
-				       struct shrink_control *sc)
+static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
+						 struct shrink_control *sc)
 {
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
@@ -287,7 +287,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	return 0;
 }
 
-static struct shrinker *huge_zero_page_shrinker;
+static struct shrinker *huge_zero_folio_shrinker;
 
 #ifdef CONFIG_SYSFS
 static ssize_t enabled_show(struct kobject *kobj,
@@ -849,8 +849,8 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 
 static int __init thp_shrinker_init(void)
 {
-	huge_zero_page_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_page_shrinker)
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker)
 		return -ENOMEM;
 
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
@@ -858,13 +858,13 @@ static int __init thp_shrinker_init(void)
 						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker) {
-		shrinker_free(huge_zero_page_shrinker);
+		shrinker_free(huge_zero_folio_shrinker);
 		return -ENOMEM;
 	}
 
-	huge_zero_page_shrinker->count_objects = shrink_huge_zero_page_count;
-	huge_zero_page_shrinker->scan_objects = shrink_huge_zero_page_scan;
-	shrinker_register(huge_zero_page_shrinker);
+	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
+	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
+	shrinker_register(huge_zero_folio_shrinker);
 
 	deferred_split_shrinker->count_objects = deferred_split_count;
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
@@ -875,7 +875,7 @@ static int __init thp_shrinker_init(void)
 
 static void __init thp_shrinker_exit(void)
 {
-	shrinker_free(huge_zero_page_shrinker);
+	shrinker_free(huge_zero_folio_shrinker);
 	shrinker_free(deferred_split_shrinker);
 }
 
-- 
2.49.0



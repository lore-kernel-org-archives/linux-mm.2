Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00E8C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 09:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218996B0092; Tue, 22 Jul 2025 05:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B856B00A5; Tue, 22 Jul 2025 05:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AAB6B00A7; Tue, 22 Jul 2025 05:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6C086B0092
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:42:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71E1AC0303
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:42:40 +0000 (UTC)
X-FDA: 83691410880.27.2E18A57
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf18.hostedemail.com (Postfix) with ESMTP id D5D9D1C000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:42:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=o+kgP4wN;
	spf=pass (imf18.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753177359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkFrb5mCNuui7GC4+ZivqwyBFvkydagw0IS4O3GFosI=;
	b=zVW6J2MNiBa5YARDYKbGxlHZPdDX+pbUtRxsn4EsACsgLQVpUZjAdN4BQ+otSdk7Wm7tfy
	KtUPlVW40qxE8yXJUtJ27KW90G7PIU+fjgVLM8ubKcLv/7C9F87QJ0ZhCRCzl1jPIVQ1Zq
	wHGJpbUWQCeD7xm6ScEgNplpAaIlzK4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=o+kgP4wN;
	spf=pass (imf18.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753177359; a=rsa-sha256;
	cv=none;
	b=uoMBU6+bbLhlixC7t+JkmimqqiYC0dlhlvaKSPrMAHJ3AS9bzw4WPCbY1+Qqb5xXX3OwGf
	7so98lX2XPe3wbWt2g3ZSMoCN4Je0iMXzH4RjKjNXVwILUi+/4WDaq57FnaIZ2CZhmuB3J
	pNw5FpyGUKHxbswqfzFK60YF82k9fh4=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4bmXP73Zcvz9tht;
	Tue, 22 Jul 2025 11:42:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753177355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EkFrb5mCNuui7GC4+ZivqwyBFvkydagw0IS4O3GFosI=;
	b=o+kgP4wNhjY5eTyH7SsHPA0QXxHdjIPiezXWmhC17Cq39gi1RTU/DViRyyO4gZBs1eDlDj
	bkyxR9N6PPTIxJ35WqsTG6weGH3Cq1UMyjWi7RdYgXSOiG8jD7QttpM1zBIZDsBf63gLXc
	wbMweJJgqFDYkrqrwhJ3jDdaHtdV49VqQ9m2K+j4vBfxQy9c1dukZo43RO+EV1AkfK6wPI
	1WqlZYmcUR8TCjVDYkT0Y+oToapzDlviBNpKRRX6XmbDChlHx6Kazo8Sjpks98hEAv1BmW
	E6kXuxgNyr6hUQkxQlq6BMNBvks5SX8dfuX8zWp7h9Ao/Pof61HJwc7QPcg3mw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC 1/4] mm: rename huge_zero_page_shrinker to huge_zero_folio_shrinker
Date: Tue, 22 Jul 2025 11:42:12 +0200
Message-ID: <20250722094215.448132-2-kernel@pankajraghav.com>
In-Reply-To: <20250722094215.448132-1-kernel@pankajraghav.com>
References: <20250722094215.448132-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6d8txj6ojrbaty8wix1cnu11hd3qimn4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D5D9D1C000B
X-Rspam-User: 
X-HE-Tag: 1753177358-543849
X-HE-Meta: U2FsdGVkX1+R4YLXVcfJcWvI15zO874isFw1jpK2TVzn/X5t+dQT3v4/pS1dWJPabMVn/ij19wrY7Rvr/zrjGqqA4Sc4ipUw+wQwrLp6CFudNOdj0VFK+gkC7LVflZp+TBy1mjob9eLMiUkZ56qp8bXXzCm5gMV5Ba3JsPnXUNgO5mUU+bkaFpH4KLX7u/bNcvlNR3mgiKWUspnkJepL4HwKlzYyG/YvnF3yeqUlfW9NgfJyMD/bQQM1SIRLNcNwK+b2dkiOlltwLJ1sO4Esq/2EfWE+5nrze4gCjzV5wVz3FMs6Pmirma6V7LwXdW+xRytJKVFcWo9J6zVHuL2uHEey8meeWqCtHt6vwXZuTJNdRYusrNNS75K1tyBICCJwmvB3fUxTdoR360KeROIurJFxSlkkN1U7RI1PlHtL7sK1TtO98ABq37URaFI4o7WkRVkz/qjYwknfQvjFJrQuYjZI6/iePgbP0nWzn0wsZqu+FJlrMZR7wcn2F2yqvs0PLEqTg1FiakF5RG9+PRrflTACBxN1IJepEwK6eOp/KLhNPsSKK4tqnl3B8agtohfCSktAoCxXNl0oRVhX/944k2uqPpFYncVRE5GTi5yG0eZNtt2oy8iFJ6iaNqki+Br6VlrwVzmlQL7DVCdhwzBUXhJxJBRc+3vyM8eqL37YY3LKuTdjKw3Z0a3eW4UOdD1h9jZ9rJiJR6LBpTNs4edTHtWPUrr3AwVtE7+wU/oTO82kQYw5Z/Mx5ac9berhhegZVx4dfdIa2rTedT6bFq5iT1UYq5oAsqpm1jTgXFDlsgXMCU/B6VW7HxD2EAWwaiEmfitdjLwfDEbaBqMSjByQ9PYqXVfqP3FBbPk/9bOfQKYtnhvc5YWc3cEGawarySHmC3oFkC2CG8yiW8Lq3Je3PhYP4EXQF5Ouot41y0rhYAtoWDnrsrWx/5HVEy1Pvv3NsglYYQEp3qALrm4WZXE
 Ap6Q6FhU
 rs+MbNs8SwY2spFRHIdMn4UAEsdu/N2EjjDSUoWbHGrYhKMC7nk0qZO0HxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

As we already moved from exposing huge_zero_page to huge_zero_folio,
change the name of the shrinker to reflect that.

No functional changes.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 mm/huge_memory.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..5d8365d1d3e9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -266,15 +266,15 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
 		put_huge_zero_page();
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



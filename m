Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA34606A33D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=w93hL3eD
Received: by kanga.kvack.org (Postfix)
	id 536CA6B05D8; Thu,  5 Nov 2026 13:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6046B05D9; Thu,  5 Nov 2026 13:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388B66B05DA; Thu,  5 Nov 2026 13:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7096B05D8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C698C0BE2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:43 +0000 (UTC)
X-FDA: 85401934086.13.1C5F0B2
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C051A0012
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w93hL3eD;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTkQgAFQb13D2NQe7Ymv03xi+ycIuHXZDBueXOZ6laQ=;
	b=7jrDVKiUxB2gsWiwMa82jdSHRuRYjF9kKdOEPlsVcO8fnkFZpE3T8wW02vZyAhCFGL2zfE
	hdOYYg9TF0QlrlEyeGW008Hwc1pyxAeui3tOrRsLOEi8/7U14ldSGBx7hkb848/TlpGEr/
	Am6N79jNbf94ZuHGlTIucycVbN2hYBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904101;
	b=2kPG0DgTXN4rNfkA5ROT+LXvu0aJzlyNsvb/He3wCNDj6/CulwtQbHvE3wXn8lyByWV7SP
	oqQB6XkJ9x4gexVvOby/koGPm4nVjnuiiTkBF5eb+5mao2DbJbTW1lhtCCa2IOMC03dTFF
	Nn8RcynfgSGxAQfY9h1QoPRgR44xrk8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w93hL3eD;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gtwkzCCRR5a8LFYW6Q8g6wa92+pnZlz0qa19Rbk0Nmg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904100; v=1; x=1794508900;
 b=w93hL3eDrok5topCpNv//X825qTYwNznSaJBucz2j52W+US+5F78b2P4YXLUN88+5HHSaIZq
 K2EStH73muaq7TQICs0BvFKCt5NeGO+Nj5zwJHQGyQTX3EmJUAHHaYKD6HUsx3UXknFM2cyWs9c
 xzQWfbNrn4tRnvyy4enkz31k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 319861037ae1e3f7;
	Thu, 05 Nov 2026 18:41:40 +0000
X-Mizu-Trace-ID: 319861037ae1e3f7
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 18/32] fs/proc: account PMD swap entries in smaps
Date: Thu,  5 Nov 2026 10:39:02 -0800
Message-ID: <20261105183940.2236717-19-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jfxrod3tmmreqw5wxookgp33tmp98htu
X-Rspamd-Queue-Id: 7C051A0012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904101-288466
X-HE-Meta: U2FsdGVkX1/Bzee1FyRKJ4P6FyNURqP05UAWUK0Av2lFFxjLYOCPyasnMRv31ntfIk5jrkV0AkaHgFYdv8MZFZEP5IwEBsU06RzybB7XsCCKap1Mm12Io1bbi23+bSuelQPooU4NJTNpS7cQc9RYthTo1O4m6KMOVnnKuULYy6GC4W4cFvJN+44e9anTniLh/SVawHdIMvsBFzH67BwViEdjNgq6iSU7xPTyVTWMvOf65Hfh3EQHiR6i8Tr3HYVwbYho1UYJNRz5cjsxZIu41ZSydAiVivcB11uo8KvwoNg/6nVqF7guhEOTCaWGUUOaHGuxHv9LBe5e+ITDNXh6Ylj75iJagw8buqlLyhurWOBnLNG+CHkrv4gTa41JcWzh8aMWEW86DDqKi0/rfnI7LdIzOujUxYcVXRrTC+F8emuShLXnKO7JqwELech1jXF8VXWFbx5+6P13UV9IvD87kE7p6yDHEOluTfLCT3FqJDgKjg9YjAQCGx1oX/rYyLy9wcCBn62WXfnyem6PpEJcYWD9j9+gejEfyBXlPrXZoHxiNwnF+Buk7V0UW18dSh9KuA3gBeE2zDjSqjA+K/A7lU1BfCxxm4uZ4wol+PVceBK5wfdJQmxnbvyv+SuhN2vRuJJjnmWM+46KzGRqYvmBDvATcKH4xvA0aa1tMGhktCPM+tdFOY4Omo7wwRluf5rsGhlwO0UbmGj1j1LF2wDzRT/2fhVVmxRk/LZFak9AMoXqCyLk+Zsskh7jPDQS3SP1Nf0M8O84fborZT/r48vl4RL2k4N5jCE16/QlfriDS3YYvlSfs0z19n83w2eoJzqupJl25pFVReUswjV7JRK3TlqF/+np6qR4/6LlfjXCemsYX34w48pB6UoaBq+f8tJxbZHb4CzNHcIYocvkEYUb3cRgRmrpwPrJUDJyDpv/heTgY+seZvTTpFch57w3CJNvUtEA2S795LD8ffh271W
 7lX6Z7YR
 z2P/CTN8IDnqaR69usDc6JrxraLlI10T+sMYS29R1wguHvmTZaRw76D+PQBkfP7hqpyuluEZ3oHRc1aLfZFUKT/TbQcxUv7EI4p7G2NTovrKFKSEbbcbsUrsVbaNxSkbi7e/PCiW7X2ieYCX7DohRdXbI3JjWVV6pyxWldxOSg01wohRRtmYin6wT81xDcTGbsB7gnHrcqndXE9k+85GCLQjg0kR7TRqjLbJu3Q1danwQtXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

smaps_pmd_entry() derives a page from a non-present PMD and gives up if
it cannot. A PMD swap entry carries no PFN, so a swapped-out THP is
missing from both Swap and SwapPss.

The slots of a PMD swap entry can have different swap reference counts,
so SwapPss has to be computed one slot at a time rather than divided
once. Factor that loop out of smaps_pte_entry() and call it from both
levels, then return early: a swapped-out THP is not resident and must
not be added to AnonHugePages or Rss.

While touching PMD softleaf accounting, match the PTE path and treat
device-private PMD entries as fake-present. This lets smaps use
mapcount-based PSS and private/shared accounting instead of treating
them like migration entries.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d1..bfe9d6af76d5a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -965,6 +965,25 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
 #endif
 }
 
+static void smaps_account_swap(struct mem_size_stats *mss,
+			       softleaf_t entry, unsigned long nr_pages)
+{
+	mss->swap += nr_pages << PAGE_SHIFT;
+	do {
+		int swapcount = swp_swapcount(entry);
+
+		if (swapcount >= 2) {
+			u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
+
+			do_div(pss_delta, swapcount);
+			mss->swap_pss += pss_delta;
+		} else {
+			mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
+		}
+		entry.val++;
+	} while (--nr_pages);
+}
+
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
@@ -986,18 +1005,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		const softleaf_t entry = softleaf_from_pte(ptent);
 
 		if (softleaf_is_swap(entry)) {
-			int mapcount;
-
-			mss->swap += PAGE_SIZE;
-			mapcount = swp_swapcount(entry);
-			if (mapcount >= 2) {
-				u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
-
-				do_div(pss_delta, mapcount);
-				mss->swap_pss += pss_delta;
-			} else {
-				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
-			}
+			smaps_account_swap(mss, entry, 1);
 		} else if (softleaf_has_pfn(entry)) {
 			if (softleaf_is_device_private(entry))
 				present = true;
@@ -1030,8 +1038,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	} else if (unlikely(thp_migration_supported())) {
 		const softleaf_t entry = softleaf_from_pmd(*pmd);
 
-		if (softleaf_has_pfn(entry))
+		if (softleaf_is_swap(entry)) {
+			smaps_account_swap(mss, entry, HPAGE_PMD_NR);
+			return;
+		}
+		if (softleaf_has_pfn(entry)) {
+			if (softleaf_is_device_private(entry))
+				present = true;
 			page = softleaf_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
-- 
2.53.0-Meta



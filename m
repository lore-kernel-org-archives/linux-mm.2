Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915F0606A8A3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=O7UvWw6D
Received: by kanga.kvack.org (Postfix)
	id 1CD426B05CB; Wed, 11 Nov 2026 06:39:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17ECF6B05CC; Wed, 11 Nov 2026 06:39:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39356B05CE; Wed, 11 Nov 2026 06:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D24476B05CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:39:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AC23A7B26
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:39:21 +0000 (UTC)
X-FDA: 85422642522.20.5FD66EB
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	by imf23.hostedemail.com (Postfix) with ESMTP id 27035140002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:39:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O7UvWw6D;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsSfYSFniRGmuPRfq48u5DDdTpeJF4QuAl3fe5dik5M=;
	b=ffzgcG0m1mzJxyNBF1dgDSFZpOkmZw02qn/xm2YYY35tRTcI6XPhrQZ+qqUGaz1d++qlnG
	SwG++8QXAbQdLBylWV89p/iHcoa1q8ZCFrezaMl8nbNXAmUmtC93I2LF/h+bLPtJo5Jlas
	+L5leSxB960R1c4iw5FXSy7GGRxEhoA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397159;
	b=pGE5uOTEX20+Z1HnPIHIdrlSjkYzUYbSIFg2ta7+KGeo2rU3kK1zjy2iY6Iz2vKC5hSPiw
	f8e/7Q3v3FE/JhyviIEfjr1ro7Cm1Km52BZdnb1sH0U6s3MFmGlonuFSn2esSkl8T7evp7
	Hf1UijxypAd9sslgJNjn0nEcMbZHCCc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O7UvWw6D;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zdZjBwRCrc/bJJQOamLttRr417Z2hw8mLNGL8JIUru8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794397156; v=1; x=1795001956;
 b=O7UvWw6DTIle1OGgNxQFMYG7hepijbTb6ERfRfSS5opxNxPUNoALMR57ZqMwxeWPXjU/2TcL
 d5lHg8gMznxqBQ7sVYZ5wcrU9YEz5a7c5OtjzW3+aKxDYzlHL0TfyA1MmkEND2mSznUtlVZrvne
 8gKn8dvxGTeZ3CBePG5C4EMs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 780683f44d9afa50;
	Wed, 11 Nov 2026 11:39:15 +0000
X-Mizu-Trace-ID: 780683f44d9afa50
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] mm: don't PTE-batch a swap-in over a hardware-poisoned subpage
Date: Wed, 11 Nov 2026 03:38:29 -0800
Message-ID: <20261111113904.650722-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111113904.650722-1-usama.arif@linux.dev>
References: <20261111113904.650722-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ba13rzhn588d37k9pop8pum9xsq19cgj
X-Rspamd-Queue-Id: 27035140002
X-Rspam-User: 
X-HE-Tag: 1794397158-855475
X-HE-Meta: U2FsdGVkX1+D1gAiHQ51taXkjMgQ0+f8bbDqmTTiQduzPO5KUi6OtowXpowAeHmQSfOxehLp8lMQiGlj6qa2LTI0FY6HTL+p6szQhxrcP1k067vFEI2Xvg2ikUfg2kgRoDvU7d3iLJDvPwkdukr1gbJlSBel3qfYQnL/izeoz0Pc0x67YAjLjDf+ZZDwoJq6JcgcI8FN+ajmcQG5a4d7N+Hsh/nuDtDUmhKoOGV9KmELAPCves4ZIpISlDSdJKj71aT2FNfuqg5HGQT6siiZcxvk6mnyfPFJqUxU3sU3WN0SqyJI95mq38/VlSE4tEKHvHbMPOIoX63vOZgGuc9ga/G+/ic/unOFU4FSJFeNHCjKxo1pUfYNCjuwoz6xd9GMuMl747eBJWGKStFwlGz3OTYqmLoD2GgzpXTC6Us4K8DM0fxuQw6QLttPaMh/s+rg18z3cWSBPmFzkjS6fcvYnZH8HpjCQP1Zor4NDhYZksqrM9TU0OMJOgG1fJmCS1iqEuObqLd2u7vbtlpYYBiawVWNlshGwjwA8frfrq8D7kMHyrsp/mQ0++50o6oez8xSz6KGW2tlzIanHopUq7sEprNIw14I+cijVr8J9H+VW4Y5xUPxi9xdneKYEaCe3HybKTjOCoXIIsj9/Xazayb/a/exgbXBrk80xNzrJhUd3FNG1/qWu83bICp6/xgmwLfT2o0k+M3LVXoDUVxDrG+/Sx7dvPZTX+jZYdar37CMuyzi2Pz6m4NHawxuyJHDRKmpjt8WQUmBeWYi8TnjECPgl9q/5ZA7ASggOl6TwiVd37jnxPVd09wp4NUjqHkXndxZUc7r+UkNdOyDnXjobfzutxIEBEMps3OaDEX+JwV/j+C8lA4lCWZaTpAMqJu8YCPiNhJd5KPw0F6/GknFz/ytxsN59+a+51pbkjzC/1fpxi10A8vYdTo4EbnzF0msxFu5zCm6qaxopckAs6H++qh
 5T8g/Cd7
 MDL7F5WODKMlkacjTh5P7E2xsMYVHOQTMBHE1qRlC2qBkOgixDktZzXG4j10ytIYWuEj1cbmT4/NuaOLvpR/0nUpfMleufERmkz7vplwiHg1aWHqK6gO+FcnFxyoKEcmaxdeqieKx++vHC+alKFtU6JXX8NOKlg+F8vzstcIsB+yfSh242EaV64FuEVlXH1aJZSWXdJkCYEaSdglqvNhoFsSWOowpaSC7IK0o1J3edo5PujBQV/fDWtDIMr9/4mfVcuhV0CPn5bVtzrI5FNES8vJWH1zWzNdMyYpdG/NL8qZ+wHfpABD3oy3rs2vdoH/GuMCMLzG4LLgebPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_swap_page() checks PageHWPoison() on the faulting page, but the
large-folio batching path then maps the rest of the folio without looking
at the other subpages. A poisoned subpage that is not the one being
faulted gets mapped anyway, and the fault that would have reported it
never happens.

Skip batching for such a folio and let each page take its own fault,
where the existing check catches it.

Scan the subpages rather than testing the folio-level PG_has_hwpoisoned:
memory_failure() sets PageHWPoison() on the subpage first and only sets
the folio flag much later, and the bail-outs in between - for example
get_hwpoison_page() losing a page lifecycle race - return with the
subpage marked and the folio flag never set.

Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/internal.h | 15 +++++++++++++++
 mm/memory.c   |  4 ++++
 2 files changed, 19 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index cd3675c044e0a..e61c02f4019b0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -28,6 +28,21 @@ struct folio_batch;
 int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
 
+/*
+ * Check every page of the folio for HWPoison, rather than relying on the
+ * folio-level PG_has_hwpoisoned, which memory_failure() can leave clear.
+ */
+static inline bool folio_has_any_hwpoisoned_page(const struct folio *folio)
+{
+	long nr = folio_nr_pages(folio);
+	long i;
+
+	for (i = 0; i < nr; i++)
+		if (PageHWPoison(folio_page(folio, i)))
+			return true;
+	return false;
+}
+
 /* mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 			    bool flush);
diff --git a/mm/memory.c b/mm/memory.c
index d477a4f986bc8..4b7d456332200 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5158,6 +5158,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
 			goto check_folio;
 
+		/* Let a poisoned subpage take its own fault. */
+		if (folio_has_any_hwpoisoned_page(folio))
+			goto check_folio;
+
 		page_idx = idx;
 		address = folio_start;
 		ptep = folio_ptep;
-- 
2.53.0-Meta



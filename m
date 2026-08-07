Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871E7C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3886B00C1; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAAD76B00C5; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D719A6B00C4; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2B126B00C1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 471631401D3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:56 +0000 (UTC)
X-FDA: 85075823952.11.776C0DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4669C40009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGeSFBf7;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139574;
	b=ahGhXgh6zuCGQi0kusFfEgDE5OacYrQXUNd0TgwR5k59yuzAPGRMI1gj1MoENCjrFbT4pP
	e8DofDUbACfLbjpLN8GXMiE2BDiHf9YFagHAE3GFtKw9QDbL+CenFkfvJY7DozK/nzbARQ
	vRFHCfVD9LtmDk3mp7mmJku7BoeF5dg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGeSFBf7;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139574;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psUW2qgyByy045ECDKtbD+G37XprHdFgVCgMkWChVVQ=;
	b=tGyENF71163fUZLHFxBHSXAb6BkW1By0wB58sAETUgFqGTuXvRxuMgxyjmLTbEXg8xq3Ep
	WJbQQy/LQTiv9fH0oWxt0kDc7BecQK2sbauw+PDmIzkt1sMfOBZ/RTwTn4ZUdHXLRSBfBk
	+XDESFGWutVUvQERtMAnJ145cBLnZrY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CC1945138;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06435C4AF13;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139569;
	bh=C8OI6kju/OzMAnmo1MLoFl/+g7Mz5T91QIShVMCU3HM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eGeSFBf7/4+J80IRIsOi3FHf6wjaVM8/+K955E0oLP9NWFiU1sGNewFog625zOgOY
	 AOB7xqCmqQLkedW+shhfVpoqAzmKTGDrANHgX1UyZMqJgiFBNP6lrk9WukFa3T812/
	 lg/8XNxR148+odbnj29usyJTNpVN4/+hQ7xFNSDr7qUb0/KfvmPGmHVxMBbc4J2veL
	 N+vljeyRxgGH/JyEWip/XQb8HjKdPVynYDcBA97fc18E0uPMfs2gB0sa26nBLjpPcs
	 RIEXMJFp/0cDxs0crZvB14efNoNVqxGfbI/4YpduxgtlWL91v+cIQ17jn4NlqEWun7
	 PXjHq7DnisSBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EB2C5ACD1;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:53 -0700
Subject: [PATCH v10 14/41] mm/gup: factor out LRU cache draining for folio
 into lru_cache_drain_for_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-14-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=5756;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xV++FlZvFI4NwrLc3veqIQ22RTFlEXFJFbRA5Ehxu/0=;
 b=9YrnGTHepXwH7Ocuf/jdvkIQyqGXFL+hq1GjIfVIdNlq/Sj/XRMZp5UufgETznFOEOs76yZdZ
 b8PmUno3coGDK7JcNd2gKLkodQEly/BURV7tihbNuQW+fmMbNrK3aFw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4669C40009
X-Stat-Signature: cmk1emcjw9x1hpq3d4csydyb3jq8c1oe
X-Rspam-User: 
X-HE-Tag: 1786139574-178035
X-HE-Meta: U2FsdGVkX18XvLAqdX9mHeI+rHmxjhy0MQAc328rPhelBXI3BA1zqrOT7IBmoxAqdX3iZB+ukQo+o4px3gDI8gPtRqaOwCYo+oz+whiH/Jzk0uHajNPwcXv9Ms/nVroE0R3MJT7OukpYGVKe1TW04oGjHfjgK2GSPKmVjAchf+BB2XwIItRJufgxmtFfUYI2/PrIvYlNCqrIbB4HuaG5lwOHvYWTGqY14tmKKK4Ec17stKqogRBY2Evt/iwhzgxSuAybGzv7K2zPr2FG3pNAtlO6UaAE1h2L9EoYfwzJZEopu6RHNdfGO11yxoH7fgXhM37qiBLX+6VIMWC8X/R1uIOWG2Hgax8jCdIPws5oVemXoilN322gR0QIa9YU7JP+vNQYX3MR4hX3+KGO+uXVTMKyIC9OEU3So5StIcclEd1iL7PNhvIbfxXWkV8q8vb/h4bJzPl+bqpAMQXwQmEFakbESiOeov+KQRxLdVxj1ALO981IhHMBIJw4mkd27psvNxreHS82hqtoOXSHroaY2EOKWus7O77CZsU260aFMNWtNZu8zSjGzLdiUSLOFDk7uazkG8IODTX91vEqjnSLUxPHtWgU/alywLehunNCifJKxRjLFblkSQd2Ojp2iWrDBLDtlr/cm37RMWnJoBw8w3F8miPk/beqynRO5KX/RTLIrdpFeDLgzavU9FN8/zEirzsxFa03cSe6v6T2mNAUKYfP75GEpuKOOGJnJtGfiaV2IhEcvoRM/kcXDpFqQ1FnRrTtLn6bc0WfJiCMADVnEcwt91Mg6RdXen9Q2MSRjd+e1i+OQGMyx4+cY2sXRLzZwPaPGB/oq7BNmKNCYYi/zOjPajY7wNPqVOYFwKCo9rOGHU6ZAqf1kmIZVei9cWbxz6bBhJ28wH/Gk1NX74HX6RcCYyDznp3p2ysiHc9MjbSbebY7ScFhdi+ngQPhm64NRmmjIKoC8n0L5NSqDud
 6uhrzdJW
 eJx8Gvcr80pnT+KW/M5AI9UlRssZS9NRE0C0939lYeF6IqnIn7QacisubK5OV4dMU/whTdzM7HEm4U6mKIuTZ4hOrpvePHvwbpMvbwqIAAuXqdB7LIFJYqaTUEVRuLM8FsQUVlpSLmxLGM4oKqO/uXCsP8bo2nSas4LKN9N1znORqjbTGJkjWDXgUF4yRAlqOMhFn6paiDqaUH75yfCzjama2UO5ynSrRU8BNtJlMCPA5UY2hIVn0hbJlzbwWRC8b18G30iAdNGOF1WENXOG2rvLVjNdWsJ6GuXuuyY06qG+thexrtI+wHoAhAe6v4SIxZ8PotK3aqAMmqBlyTugVz9VDdMhDJMMBYR301MdeYH9f03zDIZuP2xzHbbWJ9Stus+vypEmKPsBryehQg9e9lAIWNrUoso3y5tVX49c+UP88uzNjYhWd8jKW8RiCWtbmP70zrG3oJfqpuhXZhmGgXjhrPmNmzC+6mYYnfSRT268yw4R0peQ63cHIv2qhv7JglC37TwDuTFJEzGqcSAENO4OE3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

KVM with guest_memfd wants to remove any folio references due to LRU
caches, as it really must only allow to convert folios from shared to
private when there are no unexpected folio references (e.g., from GUP
references).

So, to drive the refcount down, it needs a way to flush the LRU caches.
Let's factor out what we have in lru_cache_drain_for_folio(). Document
it, and also mention that concurrent folio (un)mapping might, in theory,
miss detecting LRU cache references. Keep obtaining the expected refcount
twice to minimize the possibility. For the current and future user that
should work, and we don't really have a better alternative: we could
detect if the mapcount changed, but it would still be racy and add more
complexity with questionable benefit.

Maybe there is a chance to avoid the draining entirely in the future,
by avoiding extra references from the LRU cache: Hugh thinks there might
be a way. But for the time being, this handling is unfortunately
required.

Make folio_may_be_lru_cached() accept a const pointer so
lru_cache_drain_for_folio() can accept a const pointer as well.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/swap.h | 11 ++++++++++-
 mm/gup.c             | 15 ++-------------
 mm/swap.c            | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245baa..e625d64c9e13d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -317,7 +317,7 @@ void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
-static inline bool folio_may_be_lru_cached(struct folio *folio)
+static inline bool folio_may_be_lru_cached(const struct folio *folio)
 {
 	/*
 	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
@@ -344,6 +344,15 @@ extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
+
+enum lru_cache_drained {
+	LRU_CACHE_NOT_DRAINED,
+	LRU_CACHE_DRAINED,
+	LRU_CACHE_DRAINED_ALL,
+};
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained);
+
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 extern void swap_setup(void);
diff --git a/mm/gup.c b/mm/gup.c
index bde05664fe9a9..1bd8915517196 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2266,9 +2266,9 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	unsigned long collected = 0;
 	struct folio *folio;
-	int drained = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2293,18 +2293,7 @@ static unsigned long collect_longterm_unpinnable_folios(
 		 * but also to remove any other folio references from LRU
 		 * caches.
 		 */
-		if (drained == 0 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + pin_refs) {
-			lru_add_drain();
-			drained = 1;
-		}
-		if (drained == 1 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + pin_refs) {
-			lru_add_drain_all();
-			drained = 2;
-		}
+		lru_cache_drain_for_folio(folio, pin_refs, &drained);
 
 		if (!folio_isolate_lru(folio))
 			continue;
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8c..8e965c8ce9aa9 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -950,6 +950,52 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
+/**
+ * lru_cache_drain_for_folio() - drain LRU caches if the caches might hold
+ *				 folio references
+ * @folio: The folio.
+ * @extra_refs: Extra folio references held by the caller.
+ * @drained: Drain status for batch folio processing.
+ *
+ * Drain LRU caches if the caches might hold folio references. Start
+ * with a local LRU cache drain, to then drain LRU caches on all CPUs if
+ * local draining was insufficient.
+ *
+ * This function detects LRU cache references by comparing the folio refcount
+ * with the sum of the expected folio refcount + extra references held by the
+ * caller. Note that we cannot rely on PG_lru to reliably detect all LRU
+ * cache references, and there are rare scenarios (concurrent folio (un)mapping)
+ * where this function might miss detecting LRU cache references.
+ *
+ * If @drained is not NULL, the function will avoid re-draining LRU caches
+ * when processing multiple folios in a row. In that case, the variable
+ * @drained points at must be initialized to LRU_CACHE_NOT_DRAINED before
+ * the first invocation by the caller.
+ */
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained)
+{
+	if (!folio_may_be_lru_cached(folio))
+		return;
+
+	if (!drained || *drained == LRU_CACHE_NOT_DRAINED) {
+		if (folio_ref_count(folio) ==
+		    folio_expected_ref_count(folio) + extra_refs)
+			return;
+		lru_add_drain();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED;
+	}
+	if (!drained || *drained == LRU_CACHE_DRAINED) {
+		if (folio_ref_count(folio) ==
+		    folio_expected_ref_count(folio) + extra_refs)
+			return;
+		lru_add_drain_all();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED_ALL;
+	}
+}
+
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
 /*

-- 
2.55.0.654.g21b8a5bc05-goog




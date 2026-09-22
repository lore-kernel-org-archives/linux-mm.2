Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDFACC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116126B0093; Tue, 22 Sep 2026 19:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A046B0095; Tue, 22 Sep 2026 19:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E824A6B0096; Tue, 22 Sep 2026 19:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B47876B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09D35405BA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:42 +0000 (UTC)
X-FDA: 85243065684.08.20E4C3E
Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4434C20009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XObeHBbG;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.233 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oNw9RPMr3V+/qUjJEYCXBc3lvf+tyCPjegYTQeEM3I=;
	b=y6SbnFYtt4NQCoN0jY1SDg9L7+K6KpVMR+d8p6iAPjPTneye0Hrcg2X2r954XWabqXEJWn
	XRbruQ8TP5qzuJiWJ9CKiiHFnmxAD3WDvNHTvY5W5mnlwQMFw6u8c/yapFC4rCt/LtFo78
	F0xIncY35KJBtGWu0Vi/o0itbQ6X5Ts=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XObeHBbG;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.233 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121520;
	b=wX9W+QgEOouT6qYEGck4G9Tri9BOx86YyjOSibeGbiSgt8BhpGp7pR5QgPdKzP5ohLAbcp
	PdklnsoesH+F36jTaa6+TZvK9TXVVKknTzkaY3gkNCbAqtp0OLLHoqPNUgc/VXIXY94Nsz
	vPBlFIRNAQQlazZwiIcShUmj0AfCuVU=
Received: by mail-qk2-f41.google.com with SMTP id d75a77b69052e-532d63f434fso5503461cf.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121519; x=1790726319; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/oNw9RPMr3V+/qUjJEYCXBc3lvf+tyCPjegYTQeEM3I=;
        b=XObeHBbGHYDzE7yE8yLkOCvdOfJgX5XAWcohW0SffcSLv8IO4lheGFg6pNa/LYpT4m
         j4JiuRbH+/ao5j9Hm0NnzcNvNX/UbGqie1vEyqzAYt7T3kAPevmNET605wB/7QAkD6HM
         uOjCT/4rWdLnWQSVks69mUqLr5oXKfYrQ5Rhp8PmiZ+b7Zl5BEQI3ogoPyAt8qV1vgYS
         GOMJU7yZ6IpwKkmK84e1bjeeWqnHOUDKWKbGu7Hb3n02X3GTon+UDqrcxr/MEsUDzmKq
         W8nc2XXISLPX0ALze04gyy5SpfYgyqLoTWH3LbI0nTvBjSTKjlgmiToeaERKQkdiLDiW
         Cz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121519; x=1790726319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/oNw9RPMr3V+/qUjJEYCXBc3lvf+tyCPjegYTQeEM3I=;
        b=cKWHG/4jpHcXdMRUcjiBrVNC6a0EklGBHRFCNt5/UP4RDf+qP2dQVyZBY5tuRC714r
         GP4DKBWDMYySW+gLt4Te3/La8sG3Yx39uKy0Gxx5+Fs8N1dhFlC8s6CQ3/eWcwG7TY+c
         SXu8eGRsWUwfabCKzlRGOExkm+17boGn7JSrVQmD/jdJvSy1G1DFRr2IBiX83l+ZvzgG
         tI/I0HWo+A6ILJ4iIFjW+/rPbQuftYUFPi+1UGxS1CQCFrA3/c37I3tY16DaMdaluEqt
         XYXKOeZZTDJjGAjv9ShcXyiRNClblSPD7G0K+kGHFq1viQA79TNu4yH5Ssw5KgpjQkaz
         Gsqw==
X-Gm-Message-State: AFuF++lFjDUaK9O0JDh4mTyoDi74cBFqK24cmfC6AYk0o2eITrTP77y6
	Wmx3+mZzc3rZa9nV/c203N6NZjvbKxC5SBp/XbIFnCYz6sjUEpGbZ32J0ROH1KUu+24a1+jnZIf
	gnyH3nIY=
X-Gm-Gg: AYBFou3YOXHSV+l9yulfAJQAheuKIqJx12Gdk72yFK5YaDkrx2bdmGaWQaNR5z6/KTN
	dmaKM/2DzbT/CbUghtUZLZfiEGvoVu7G6T0NAAmYv0s8X3Omp3XEyZGrJw6gJw0jzDRvMw0Idb/
	sOjpPxZsgpxbePboyWy3H05lA+i0qBv6sE+g481//K+1yegZF3bto7XN4Ag97UIhwU+mnzSr9r/
	UBlIV9WlJAY9c2ZTsc1+j3PQ5Oo/YAver286lzPzohMZ5aKtCQN+zOSPTRigNZnhYt5bB4iXRWG
	FIqcpTE6r6N8h64e6oO3iV5Cyj+a6vi5z18YOU7aKJhXRG3s5md1xIj4x+61AN/AJAW+LfZN+GP
	lIoeZOC2etpcKWSdlU/7h8r5U7XOoXUmvwzUzvcUsfoBj3H/Du37TejC/lqCQvP977FgdR3g1iZ
	rYZ5jaCk20KcQ5K3mMVrVbO2/zWJwnxTdB04PhCU7hm6H4N/7yGBrZ9wSaCN54W5lQbfqE+ij2R
	8aHrZM05EUq6mQbE0W+pxs6l8eTqknL3+cFY5uF/QrTYOGVPolA/LKD3KyrAEWbFiuA7ns=
X-Received: by 2002:a05:622a:305:b0:530:f77a:89aa with SMTP id d75a77b69052e-532eacb0064mr19428811cf.30.1790121519361;
        Tue, 22 Sep 2026 16:58:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:39 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH 03/10] mm/madvise: factor shared LRU folio handling
Date: Tue, 22 Sep 2026 19:58:23 -0400
Message-ID: <20260922235830.2350770-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mtphfz5jtr9rd9f17ftb8r76czaxiqyy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4434C20009
X-HE-Tag: 1790121520-666895
X-HE-Meta: U2FsdGVkX1/TgnIi/hI9XWgG2lRQ3iTfpoCW/dqVPxY1F8veKGsR/Uv1Rcj+QTifwp4q2lIU0RSngk/iXSqCoG3g2BiSTZkDta9RKEftPOzTcDkQVmgcy69mDdTprW18xfNDiCHZc1z6juUkPPlNhfiktB90aasMkYGI/15eR30ueWH4+hZCOm9/woVK/5jxBPBOYeSJ+p80Ck8iS2hIsEpDA1IYcBX3tHWkXOq4Z7krPd6HVSuMWBfLxOplP2cS6CyK2bLq4PN7CC/xmnHXjXiXwaDFFpH9IPafPaWA6Qk1YKHeeTM5YdCXnl//bUl2LxB9++PQ40vVrQL/WlKTgt5qzU6+HJtIdTXgE6m0cyCpFBuV0P3+fGkdEbYpTUWQGDdpXV6m8YT/vhZX0bMCSSAzHWOouOghnT2Knkd41w8ah5dBRXfyH71WwPrLLzCFVRtXeXWb52KIaolw28tdUQT6T06bnSRDdRqQCUZvKs88t1pfgRCgJyoDZQw7DoFMUOreRrfDk+gDqGyFQ5yHIO2YMXSqtBTa6jfns4ERK1CwIf5SO31mi/pA260gBmxACp+h9OigZkVmXx82NKFxqhPemDwWC+GkdPNI0hTWzso1aIHWkb1VsyUb3LmoQK6TXZfVXZQPwubdTTfJfSo3so77sRkMNUAGhLYnAyvxzmxjQC2zOu90Sc/r0WdxlBfQggiGKxIYtGpUL7RnsUaTkbRhbLlLuEgpvoNoyxgJg69YGVAMlk9Kp0kwTXj00Hm9DouVmqGOG5D/Vt3HhyH7qH48u8LqzD+ucEYemMfCDyK0six0VVrMRwnoRr57wsQvwysgzLRpjsDOXr5ElNlOOrQ4dm91fOh3d0EvelNgvOI3jIzJ9I6oE9F6ptPTt/AChm6fAgFqLYsgY29+yVa6MZogGen38jcGMuooysh5nRKFCmtV/LyWIaQZLwEh8W8hXSQmZ3cQmYV8YRN0/e1
 GbF9fcMu
 /J4VGSQKVRYGbrMPGFp/Vp1NVBEHSULYYHh5UcoHBO0Mm/1Vo89HFSxtubKUmQ+lHm6s/rKoIsLAN0qRo5tbreX5a84X4sJ415E8o8mQYAwehE2Sd5aj9i1QocEbLwa7MaldvllMjx3nQhVLFqinBJ6OYHyVmVXELdg7J3nnAGkWIwY2YQbfCx/REA4piAOqElpvbaRUnW/ROOKfKaj2ueoiEVraajUG53IWI0LD4SZ8vNFEThrwEzr/EOYla9TDfBiXCcooXFSKPGhPZSxZBoHfLKlkC1WR35JyNUoJEmwd1SSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The huge-PMD and PTE paths duplicate folio filtering, reference clearing,
deactivation and pageout isolation. Keeping both copies synchronized
obscures the page-table-specific control flow.

Factor the common filtering and LRU operation into helpers. Keep the
lock-before-reference sequence visible at each split site because an early
reference can prevent split_folio() from succeeding.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 90 +++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 47 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 83d54ab385da8..c345fef23f15d 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -361,6 +361,39 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+static inline void
+madvise_lru_folio(struct folio *folio, bool pageout,
+		struct list_head *folio_list)
+{
+	/*
+	 * Clear references before deactivating or reclaiming the folio. This can
+	 * make idle-page tracking miss recent accesses.
+	 */
+	folio_clear_referenced(folio);
+	folio_test_clear_young(folio);
+	if (folio_test_active(folio))
+		folio_set_workingset(folio);
+
+	if (!pageout) {
+		folio_deactivate(folio);
+		return;
+	}
+
+	if (!folio_isolate_lru(folio))
+		return;
+	if (folio_test_unevictable(folio))
+		folio_putback_lru(folio);
+	else
+		list_add(&folio->lru, folio_list);
+}
+
+static bool madvise_lru_folio_is_filtered(struct folio *folio,
+		bool pageout_anon_only)
+{
+	return folio_maybe_mapped_shared(folio) ||
+	       (pageout_anon_only && !folio_test_anon(folio));
+}
+
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -373,15 +406,14 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	spinlock_t *ptl;
 	struct folio *folio = NULL;
 	LIST_HEAD(folio_list);
-	bool pageout_anon_only_filter;
 	unsigned int batch_count = 0;
+	bool pageout_anon_only;
 	int nr;
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
-
-	pageout_anon_only_filter = pageout && !vma_is_anonymous(vma) &&
-					!can_do_file_pageout(vma);
+	pageout_anon_only = pageout && !vma_is_anonymous(vma) &&
+				       !can_do_file_pageout(vma);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(*pmd)) {
@@ -407,11 +439,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (folio_is_zone_device(folio))
 			goto huge_unlock;
 
-		/* Do not interfere with other mappings of this folio */
-		if (folio_maybe_mapped_shared(folio))
-			goto huge_unlock;
-
-		if (pageout_anon_only_filter && !folio_test_anon(folio))
+		if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
 			goto huge_unlock;
 
 		if (next - addr != HPAGE_PMD_SIZE) {
@@ -437,19 +465,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
-		if (pageout) {
-			if (folio_isolate_lru(folio)) {
-				if (folio_test_unevictable(folio))
-					folio_putback_lru(folio);
-				else
-					list_add(&folio->lru, &folio_list);
-			}
-		} else
-			folio_deactivate(folio);
+		madvise_lru_folio(folio, pageout, &folio_list);
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
@@ -502,9 +518,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			if (nr < folio_nr_pages(folio)) {
 				int err;
 
-				if (folio_maybe_mapped_shared(folio))
-					continue;
-				if (pageout_anon_only_filter && !folio_test_anon(folio))
+				if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
 					continue;
 				if (!folio_trylock(folio))
 					continue;
@@ -537,7 +551,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		    folio_mapcount(folio) != folio_nr_pages(folio))
 			continue;
 
-		if (pageout_anon_only_filter && !folio_test_anon(folio))
+		if (pageout_anon_only && !folio_test_anon(folio))
 			continue;
 
 		if (!pageout && pte_young(ptent)) {
@@ -546,25 +560,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 
-		/*
-		 * We are deactivating a folio for accelerating reclaiming.
-		 * VM couldn't reclaim the folio unless we clear PG_young.
-		 * As a side effect, it makes confuse idle-page tracking
-		 * because they will miss recent referenced history.
-		 */
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
-		if (pageout) {
-			if (folio_isolate_lru(folio)) {
-				if (folio_test_unevictable(folio))
-					folio_putback_lru(folio);
-				else
-					list_add(&folio->lru, &folio_list);
-			}
-		} else
-			folio_deactivate(folio);
+		madvise_lru_folio(folio, pageout, &folio_list);
 	}
 
 out:
@@ -651,8 +647,8 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
 	 * owner nor write capable of the file. We allow private file mappings
 	 * further to pageout dirty anon pages.
 	 */
-	if (!vma_is_anonymous(vma) && (!can_do_file_pageout(vma) &&
-				(vma->vm_flags & VM_MAYSHARE)))
+	if (!vma_is_anonymous(vma) && !can_do_file_pageout(vma) &&
+	    (vma->vm_flags & VM_MAYSHARE))
 		return 0;
 
 	lru_add_drain();
-- 
2.53.0-Meta



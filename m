Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B258AC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720256B03ED; Sun, 16 Aug 2026 18:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7926B0863; Sun, 16 Aug 2026 18:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E136B0864; Sun, 16 Aug 2026 18:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7B196B03ED
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61E2EC011D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:42 +0000 (UTC)
X-FDA: 85108618644.18.391E27E
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6FA4240004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="C ifAacI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ke+Pz5jQ;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920400;
	b=g72Nb0hmXaLVphCkj/OBZnSUDQa2OPOPXEG8bU6SR8VwB65stwxVikIRszroM6SQusvIGD
	lP2vwRLTgkNDbsZU/FpPf1DW/yYiCx+GAnI58RpLpz8oS9c41kOTQp6nKmAfCVAdLNSust
	wcJDpBZuoLKuJ9CLvcLZbX2JIdxKaZY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="C ifAacI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ke+Pz5jQ;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+VwmvOWkQQIRGq2yrrL0lOcYIpS4iEV3Q9I35NYUqY=;
	b=0P9OSdVNUhW4HQx/1iIsdOJRfETluMhhkzcA7jJW4INEpw+wrx9e0laa5V4BTZ+j7pbIde
	1epG3w+iuSrH253cqbP57oHFS6dJMN7VdRIAQL31jJB8mvq4zzX5Ce6OvYcnOiCMK3ej8N
	ishcUyWiE7JH+wJN5NL7g3SXutqDmUg=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id ED44C14000F8;
	Sun, 16 Aug 2026 18:46:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sun, 16 Aug 2026 18:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920399; x=
	1787006799; bh=J+VwmvOWkQQIRGq2yrrL0lOcYIpS4iEV3Q9I35NYUqY=; b=C
	ifAacI5NLADSIgETp9aUgPDTj/HPjrbGohJHGfsGwfpEo9KdvcvoAoUBdqDMvbB4
	xBHuRNjkopP/EfuEPaypBjHIDKETtXEZAGyqd/q+tX4bYiC1RJQ3JGUZIco+2ufd
	LISfGTTlwLXNr0LahSfa4Z2RExpcVUG1z7jqK7IvCb71plD0WLOoyd34xfXrQhZX
	UptGTHX09vbD78EAXlP7ZFgPNQT1fyWATp/HH5BnewSLIktm5sz+zG/zj3t7IaGB
	PCDwf4Blk2wZ1K4I41MgOP4zeOkq7rpc8JklO9EBWEFVWLemaObCzQUuUVkAMsrq
	1iAjbCB9Sj2YxPLkrWKmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920399; x=1787006799; bh=J
	+VwmvOWkQQIRGq2yrrL0lOcYIpS4iEV3Q9I35NYUqY=; b=ke+Pz5jQQ1F8Pj6qK
	5LqN1WRiReWrEOxswy3084QMQEc9S9UOGbNnSgNbiMuZprqcu4Vk4ZZ6DxDtxzY6
	i+DCfT2KI3lwdO9QteVxv9V2FVnE/mf2eN633nRA/D2qMUJfAHzEzCxLH902x/OW
	LtNDJlCrqLIdltJ4HqofveFmukXb6qwMzdOWG4iSfOKQPeZ4CbDkvwpeOdA+yPk5
	inw2Oi4Y29mKPx+oUTe6bjDrgO6MBirWz1ZYNT7fmkO0sdDyQ0lagVaL1veqUKC5
	VDJCnJsn7boa9sormKAoDDs4xq+ik4MhMWHr1+Q38BuJsrCeaOjc/d7NvZbdy27/
	FWFLw==
X-ME-Sender: <xms:zz2Cavot6_JZr_FNJ2Dtg0pLX0MU7e_zBDt1OoMraSr1sRcC3ohUXg>
    <xme:zz2Cau9kXLI7vxS11-T7EQqWOrQnYJh3zm4Ljr3qqE-SgKYwJnKfw5B6JaG2bTdGs
    3ZisqrjBhyiNRPfpDMK8WA5h5jvoL12LxHtwLKlGTMrUh5OREzP4LI>
X-ME-Received: <xmr:zz2CaoSrJ5_Cdhupsc7zlIWCTjLaT8APNSBPS4cgVQoP2k5rEx13AElTXAI>
X-ME-Proxy-Cause: dmFkZTE1oit9MZbgdPNUA4HHWsMULK6Cz5sdpDL6Wk/wD7kfNXGu3e/EXf5M9JXawVpDPI
    Kd9lJ1GZVafs565rM9S+cZw+n/cMd1S9oSxi3Xv7RrTuiH9afQzGtYFTyBhKsmYEaht9J5
    vV7dyNSnAuCNScX81AQnXoyHXD4pg8pag19vnm592IJQcIf6BATwad+RD51AIfid8gba17
    gKSwUtsEMegipv8zNYIHYPR4e68lUdiPrbHwyMm74ZzHlAmAfr/QUkf9Bs0a0GPARTfnrV
    SpFrZ9EiV9esVNjz/LhavbueoSNqwHuOcKcj3vQwMSxA4okLdcH8vRa2PTuYlMcoV2XUMw
    iPTPisQJJ3aMD2hQvaOlWvC36TobhKHzVMIEx3pDiySZgO1/07ljaQzRO6Zpje+xuTKxkE
    ZKzA3xepHraairMh3zaBFf4LK64p7T+TbqDRH2+EsmE/ss3KoXhGPe2C/P+SzYzKECJzBk
    sqx70BhANkCN6E47RQvptQNsJ606DlBKGaRnIAUe3hEbKuOipgIW7nC5bMTZkAZA1+KGYa
    da+N4OnGE3uVHiChxofFWQqm4T/uX3/79S7l1N9TBgu5F6fBvk9VO8iNUMlDDL8G0RzFNf
    hoa4Si9vWNYj/p4zzPWh9da7jH4bUOZQtdWKOMHfFgYp2+E7s2pLchRukpYA
X-ME-Proxy: <xmx:zz2CaveBOdsbvrfUGIiQgLySafkgMOD74y2PbB4LaAc6PkR3EZZw3g>
    <xmx:zz2CalKBVQPl3rXCRCVsNA0hhhvN-dtozT0-vIXlg0nM4qUq_EdXxw>
    <xmx:zz2CakHaMKELXPrb9Uy2GhLC7Uejtu928RlKwOVAk_SZ25xezewKhA>
    <xmx:zz2Cal6ol3SYxxbYHnsPlBbyuuIIN4ifo6FbZX7vL8wdWff6XeEEaA>
    <xmx:zz2CaqufkSTusAdk-em37E7fAugpqSycFyCss2LJc2Wx_Sqq15IqmjxY>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:39 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 11/57] mm/collapse: sketch the passes of a round
Date: Sun, 16 Aug 2026 23:45:23 +0100
Message-ID: <20260816224609.308019-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6FA4240004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: nucz5xozzsmywrp8migzafesmttho78p
X-HE-Tag: 1786920400-712207
X-HE-Meta: U2FsdGVkX1+TAkeErKgeRWACOx6YvSBWr5oJXsfNjcGl4GAHzFOjIRKd4X3jfh5UCUeX0GrrcVgpRN+jZ+2q3MUNcxpnoBegT/2EnhwEEmXV7k1E59LrE0zbNgs/aMuH07nArzr8KqR3+TuyeQQ4xQMONnmGpSWE8WPEEkcyKOLoMY7ukzry4dV+XYYEeDVtBixWS7zJAXzCtD3nRdAAAfYXvZmCxQjHkqH5VklTNY23DyAdRqMq955N1/iz0KSnIBKiOcYV+v4PLtYTNMO8FbGvzK07cNmbWWTY856e8IzGEECgBcxmhgM7rxpCo3U34sPMiOe7AaEBMR8lBMsLbP+UgfiDJ98LjF7yO71FzpwD1KcZIvfmKovn0D/m2Az7sPGkuknaj3q+JxdB6Elsc79izCItD/c6w4VORvfxgMyxYIrj0aT88TEshYiU9fS4CmEUDL+39ycT0AMaslI8X61g4Ntv5PBrXnMf+Gju6v3uOu9PdQmzuezbY39a1GkzFkfn3frR2y9QNmolDfaEPN3N8cKlT1p7fdS+C5wss3rKe4xZL+Xx/3LH27oaHk9+U+TQTpJ+tmrwsERIKiFGag6nU3giJQeFli0wSpX0omJmMWrOhWOezYKCK7MP4ThY1aIvUppDIvxNWchHaNvZGHCPJCOyberpRVgraaRV5eeq7i3IArbWS8s0wF4yPnNYQK+tV8eFJiOoTnYJEvpKGS4Zd6hH+yNN40ezVUgCo3CJFcCNSTi2O54mfbqA7CxKkuFEWm5Gs1EYP2Ad1VMWGhLZn+TqgtWPmzDwvH96VxQFZofF0VSn40DNikr6KGoyPaWgSAuPzFQTzU+mi5pTclXM0r+7XIfpzEemX1fI/i2DCg2Xyp01n16vk89YtTrXUwIOxEuvqzzRFCo8BA+qQptKtm9G5rwr9B9LWY8bLQV6AKh/h1mw4arfXYqZn0+hbiDcWa9ZrdA52xZxkei
 EWwsflcf
 4r0YFwbqEdxXeC2t7GAsR4ZHxv+QDQFOQpnM0O7/zsRpM51wUfI1i5HVk/0HPqNk78MLkqIE4KENojDWNqDg7TT4IGY1zb0JABRUR17TwJbrN80/UUO/pdfbRWKoHjQn+2gk/DU4WIi2hbd3gkdLY4kAtRcczZ/hF6cd/kuC08ZbflhOsJpz2/prvgK2GGQu1BF2pcPr8eNgWdnfaPOSsHeq3o5haQYfJ25g7HfhFQLc1SYbeghUsJC4dgm7a2ayzvYsbYBijvm6lreZ+i5mu/U5nMBcfXn7DNjK8IkJ+IxIiReUOZiYr1h9SgfJpH3nsvHwH72QqF2L1TQCRLuXfO+CMrkBS/1hx4yN9lz43FowdVxspxRa6u8/TJxjoCg9G1CuIAtu+oQHDR9uJpzth/GyTIxcDDWRxgXbjwFbWTbkn2qvERgEZgTBhO7LN/AW9s/YSSBWfFYVyHZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A round is a sequence of passes over the same batch, and their order is
most of the design.  It falls into three parts:

 - before any lock, the allocations that may sleep: destination folios,
   and the page table a PMD-order candidate deposits;
 - under mmap_read, revalidation and fault-in, which may have to give the
   lock up;
 - from the freeze onwards, a stretch that has to run to completion.

Each pass in that last part works on what the one before it left, and
every barrier raised has to be lowered again.  The destinations still
missing are asked for there too, without reclaim: a faulter on a frozen
source would wait for the allocation.

Lay that sequence out, with every pass a stub but one.  collapse_round()
takes mmap_read for the middle of it: a collapse is called without the
lock, and takes its own for each round.  It brackets the frozen window in
one mmu-notifier invalidate over the whole batch.

That invalidate needs a span before any pass has a body, so
collapse_revalidate() settles it from the start, in cc->batch_start and
cc->batch_end.  The span is taken over the candidates rather than off the
ends of the array: a region refused at one order can re-enter selection
at a lower one, so a round is not address-ordered and candidates[0] need
not be the lowest.

A fault-in that had to sleep comes back with the lock dropped, reported
as SCAN_LOCK_DROPPED.  The round takes the lock again and runs the pass
afresh, a bounded number of times, rather than sending the batch back to
selection.

The stubs do nothing, so the round does nothing.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/trace/events/huge_memory.h |   1 +
 mm/collapse.c                      | 207 +++++++++++++++++++++++++++++
 mm/collapse.h                      |   9 ++
 3 files changed, 217 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 5a48c5406cce..778f5a56956c 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -24,6 +24,7 @@
 	EM( SCAN_PAGE_COUNT,		"not_suitable_page_count")	\
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
+	EM( SCAN_LOCK_DROPPED,		"lock_dropped")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
 	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
 	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
diff --git a/mm/collapse.c b/mm/collapse.c
index ad9e5a447854..25c0f72a9a68 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -94,6 +94,14 @@
  */
 #define COLLAPSE_BATCH_BYTES		SZ_32M
 
+/*
+ * How many times a round runs the fault-in pass.  A fault that has to wait drops
+ * the lock, and running the pass again costs a walk of the batch but buys at
+ * least one completed swap-in; readahead brings a cluster in at a time, so this
+ * covers a PMD's default max_ptes_swap.
+ */
+#define COLLAPSE_FAULTIN_PASSES	8
+
 /* Windows in one table at the finest order collapse cuts */
 #define COLLAPSE_TABLE_WINDOWS	(HPAGE_PMD_NR >> COLLAPSE_MIN_MTHP_ORDER)
 
@@ -118,6 +126,21 @@ struct collapse_candidate {
 	enum scan_result result;
 };
 
+static unsigned long candidate_start(const struct collapse_candidate *cand)
+{
+	return cand->addr;
+}
+
+static unsigned long candidate_size(const struct collapse_candidate *cand)
+{
+	return PAGE_SIZE << cand->order;
+}
+
+static unsigned long candidate_end(const struct collapse_candidate *cand)
+{
+	return candidate_start(cand) + candidate_size(cand);
+}
+
 /* Where a candidate sits in the table, in the PTE offsets selection counts in */
 static unsigned int candidate_offset(const struct collapse_candidate *cand,
 				     unsigned long pmd_addr)
@@ -140,6 +163,134 @@ int collapse_control_init(struct collapse_control *cc)
 	return 0;
 }
 
+/*
+ * The scan and the allocation both dropped mmap_lock, so nothing seen before it
+ * can be trusted: find the VMA and the PTE table again, and check they still
+ * allow every provisioned candidate.
+ *
+ * This is also where the batch's span is settled, for the invalidate the round
+ * issues over it.
+ */
+static enum scan_result collapse_revalidate(struct vm_area_struct *vma,
+					    unsigned long pmd_addr,
+					    struct collapse_control *cc,
+					    pmd_t **pmdp)
+{
+	unsigned int i;
+
+	cc->batch_start = ULONG_MAX;
+	cc->batch_end = 0;
+
+	for (i = 0; i < cc->nr_candidates; i++) {
+		struct collapse_candidate *cand = &cc->candidates[i];
+
+		cc->batch_start = min(cc->batch_start, candidate_start(cand));
+		cc->batch_end = max(cc->batch_end, candidate_end(cand));
+	}
+
+	return SCAN_SUCCEED;
+}
+
+/*
+ * Make every source the round needs present and exclusively owned by this mm,
+ * by faulting it in as an ordinary access would.  Sleeps, and drops mmap_lock on
+ * failure, since a fault may have to be retried with it released.
+ *
+ * Anything faulted in lands on a per-CPU LRU batch, holding a reference the
+ * freeze cannot account for, so the freeze drains those batches before it
+ * starts.
+ */
+static enum scan_result collapse_faultin(struct vm_area_struct *vma,
+					 struct collapse_control *cc,
+					 pmd_t *pmd)
+{
+	return SCAN_SUCCEED;
+}
+
+/*
+ * Raise the two barriers on the sources of every candidate: migration entries in
+ * their PTEs, then a frozen refcount.  Takes the table's ptl once for the whole
+ * batch, and flushes the TLB once before dropping it.  A candidate whose sources
+ * moved is dropped here.
+ */
+static void collapse_freeze(struct vm_area_struct *vma,
+			    struct collapse_control *cc, pmd_t *pmd)
+{
+}
+
+/*
+ * Allocate ahead of the freeze for the candidates whose light allocation missed
+ * last round.  This is where reclaim belongs: nothing is held or frozen, so a
+ * long compaction costs only khugepaged's own progress -- which is why the
+ * mechanism this replaces allocated here too.  Having asked the allocator to try
+ * hard, a miss now is a failure.
+ */
+static void collapse_reserve(struct mm_struct *mm, struct collapse_control *cc)
+{
+}
+
+/*
+ * Secure the page table the PMD terminal layer deposits.  This stays ahead of the
+ * freeze because pte_alloc_one() allocates with GFP_PGTABLE_USER and takes no gfp
+ * to strip: order-0 or not, it may reclaim and sleep, which is what the window
+ * exists to keep out.  The destination folio has a light gfp to fall back on and
+ * so can be deferred; this has none.
+ */
+static void collapse_deposit(struct mm_struct *mm, struct collapse_control *cc)
+{
+}
+
+/*
+ * Give the frozen candidates that still need one a destination folio, without
+ * reclaim: a faulter on their sources would wait for it.
+ *
+ * A miss here is not a failure, as long as a retry could do better: the
+ * candidate keeps its freeze and asks for the reclaiming gfp, which
+ * collapse_reserve() uses before the next round freezes anything.  When the
+ * policy forbids reclaim there is nothing better to retry with, so the miss is
+ * the answer, and a smaller order over the same region is the better next move.
+ */
+static void collapse_provision(struct mm_struct *mm,
+			       struct collapse_control *cc)
+{
+}
+
+/*
+ * Copy the frozen sources into their destinations.  Nothing can reach either
+ * side, so this needs no page-table lock, and it sleeps.
+ */
+static void collapse_copy(struct vm_area_struct *vma,
+			  struct collapse_control *cc)
+{
+}
+
+/* Publish each destination folio in place of the sources it replaces */
+static void collapse_install(struct vm_area_struct *vma,
+			     struct collapse_control *cc, pmd_t *pmd)
+{
+}
+
+/*
+ * Lower the barriers the freeze raised, on the sources of an installed candidate
+ * and on those of one that got no further.
+ */
+static void collapse_putback(struct vm_area_struct *vma,
+			     struct collapse_control *cc)
+{
+}
+
+/*
+ * Settle whatever the round reached: account what was installed, release what
+ * was not, and give every candidate the result selection will classify.  Returns
+ * how many candidates were installed.
+ */
+static unsigned int collapse_finish(struct mm_struct *mm,
+				    struct collapse_control *cc,
+				    enum scan_result result)
+{
+	return 0;
+}
+
 /*
  * Carry one batch of candidates through the passes.  Every candidate comes back
  * with a result of its own: the passes before the freeze mark what they refuse
@@ -149,6 +300,62 @@ int collapse_control_init(struct collapse_control *cc)
 static void collapse_round(struct mm_struct *mm, unsigned long pmd_addr,
 			   struct collapse_control *cc)
 {
+	unsigned int passes = COLLAPSE_FAULTIN_PASSES;
+	struct mmu_notifier_range range;
+	struct vm_area_struct *vma;
+	enum scan_result result;
+	pmd_t *pmd;
+
+	collapse_reserve(mm, cc);
+	collapse_deposit(mm, cc);
+
+retry:
+	mmap_read_lock(mm);
+
+	vma = find_vma(mm, pmd_addr);
+	if (!vma) {
+		result = SCAN_VMA_NULL;
+		goto out_unlock;
+	}
+
+	result = collapse_revalidate(vma, pmd_addr, cc, &pmd);
+	if (result != SCAN_SUCCEED)
+		goto out_unlock;
+
+	result = collapse_faultin(vma, cc, pmd);
+	/*
+	 * A fault dropped the lock to wait, as a swap-in does.  The swap-in it
+	 * started is still running and the walk skips whatever has arrived, so
+	 * take the lock again rather than send the batch back to selection.  The
+	 * VMA and the table are looked up afresh: both may have changed.
+	 */
+	if (result == SCAN_LOCK_DROPPED && --passes)
+		goto retry;
+	if (result != SCAN_SUCCEED)
+		goto out;	/* the callee released mmap_lock */
+
+	/* One invalidate window spans the batch, as collapse_revalidate() left it */
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
+				cc->batch_start, cc->batch_end);
+	mmu_notifier_invalidate_range_start(&range);
+
+	/*
+	 * None of these can fail as a whole: the freeze takes the sources it
+	 * can and drops the candidates it cannot, and each pass after it works
+	 * on what the one before left, so every barrier raised is lowered again.
+	 */
+	collapse_freeze(vma, cc, pmd);
+	collapse_provision(mm, cc);
+	collapse_copy(vma, cc);
+	collapse_install(vma, cc, pmd);
+	collapse_putback(vma, cc);
+
+	mmu_notifier_invalidate_range_end(&range);
+
+out_unlock:
+	mmap_read_unlock(mm);
+out:
+	collapse_finish(mm, cc, result);
 }
 
 /*
diff --git a/mm/collapse.h b/mm/collapse.h
index 1159ed39b9eb..c61db86dc6c2 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -29,6 +29,7 @@ enum scan_result {
 	SCAN_PAGE_COUNT,
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
+	SCAN_LOCK_DROPPED,
 	SCAN_PAGE_ANON,
 	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
@@ -126,6 +127,14 @@ struct collapse_control {
 	/* The candidate windows collected for the current round */
 	struct collapse_candidate *candidates;
 	unsigned int nr_candidates;
+
+	/*
+	 * What the candidates the round still means to freeze span, settled by
+	 * collapse_revalidate() as it walks them.  A round is not necessarily
+	 * address-ordered, so this cannot be read off the ends of the array.
+	 */
+	unsigned long batch_start;
+	unsigned long batch_end;
 };
 
 int collapse_control_init(struct collapse_control *cc);
-- 
2.54.0



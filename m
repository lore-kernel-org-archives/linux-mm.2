Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF69C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7516B086B; Sun, 16 Aug 2026 18:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AFAD6B086D; Sun, 16 Aug 2026 18:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3774C6B086E; Sun, 16 Aug 2026 18:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 009F96B086B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65A8E1C1975
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:52 +0000 (UTC)
X-FDA: 85108619064.06.0C33A81
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6427D14000C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="E 069G+D";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KntytyFr;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ywJVJxC7MTikatPnYdIRmEVTRQZLN6oVNDZix3roGc=;
	b=yOqsXCmlLBLGyDn9r7+8KHu0++qGBdDUOHy2dR/J98Xgxf3Gt+4lSa4UblRtTEPcBNHKoM
	NddY1UGjhcJmkngWBSOvhtwQwtva2x8C4ErDiSCyGmmt0rJbWCx7rB+HM2yC/benTNGVsW
	UEX+Xq6cMaom5XVPyEpdEkQdVXkYcoE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="E 069G+D";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KntytyFr;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920410;
	b=uiQec5FPodEPoeDi3mm/Imw62GrKMukR0i70YeGEEL5RYi1iKlI1g4hrqml1pTjxrhvRtw
	13/tNF4WZbbWIW9z+4EYC3vnta+ujWl8Di7OIrJcbCet78JmY9X0UzgFVUB+1JKdTKP/SF
	t8aO3V2IpM6w9muUyV24YJ+guojwryY=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id E9702EC0074;
	Sun, 16 Aug 2026 18:46:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sun, 16 Aug 2026 18:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920409; x=
	1787006809; bh=2ywJVJxC7MTikatPnYdIRmEVTRQZLN6oVNDZix3roGc=; b=E
	069G+DoIYd+WI0gOOhBCViUF8G821/Ar0ln7d4a8iNI21rU26YxRjhxNFbMtFjQh
	cv8WOu/uaHbRqGQspQZFAdpZPm/l3pQIYrAGApx4Ps7mWlDilw8BalVVB4uVNoBu
	CgAq/RoxKLCOWMcsNrshl6idHZ3jjQ6pzJyI4aic82mNYoNPZA8QSd0kbdsEApz0
	fdknEXAdVZdgUaZQ0P1K43Q4S2WfbEf0nJYU7DU0ALObbv8dlqsLyeJyo2Wa5wVT
	5NaTF6BWpEh4myesfbPy/U1b0W1aXoly0JCb1/oib9R7K8TnYC/kqW75fKQ8W7/f
	/haFW09Y4cf6g3N7xAxbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920409; x=1787006809; bh=2
	ywJVJxC7MTikatPnYdIRmEVTRQZLN6oVNDZix3roGc=; b=KntytyFr+cnbA8Fp1
	nE3IT98uGb8FecuX6Oi9fH2eUS5cOK+OhKoM7BKBAejvC7cQTVOWn6rMAhA7ieNr
	yGtiKztcbtHmpxLjs1okF+pzv4qsxaE7ycrysMzswxHrJbCxo6GJG9UFO/qKrcZY
	8vEkR2/DH8lhZIQ8bY9XzPRON2zTTo2O0uRSaabMvpqQMiKvAU9zUmhkY4EBtyw3
	X3e5tCvyxQ/4iT2aRIdRHrB/ZPjsj8fv+rOH6Q7KqN9/PgsPZqEviz2Ji0RfYyTN
	NqUM/mlfHl9N+NPU0kem8cZBSo6N4/FNA1VwbgYuRMFkhblATvg8mJ9aINlrzCTX
	N9edA==
X-ME-Sender: <xms:2T2CauPr9I8w1ypcClPsBA6wy02fyOx-UN9ojCRv0QgDUx-m96R4fQ>
    <xme:2T2CamhZSAM_gRaEPcK3Xi92MrFqPW8SzfriQiXSJxGLuBUtyp9vUjprUHc2yfSKT
    SQVlfm0RQIn6rgH7GFx1QwwrLuheZXv3Sg-659Awp5jb1mR-bZAkjEK>
X-ME-Received: <xmr:2T2Cagtkjt9fILJLcZTIT-G8uEqZw-xLlCRj1k5C6zi_iI8OqNkUjIXFytY>
X-ME-Proxy-Cause: dmFkZTFt7uwKlsd4UyzlmYX1bnlzO4+qp5TmvoTS/qzkFKfMuj25xYssUPl6UU5Ie9xRba
    Y0bWuaC/AePVMhqrkCnU3j3fo4+kQ4lrNr0qcDw4ZM2xDmZI+m2r8oZbGDZU/DcLlRMJvk
    pxa8BemzxDXpf0p5hqW+oOweEwIQBvnr/hc1O3uCrLqxLkUCX+QMvT/AmKStBz4XcOBl17
    ynvfoFkCi5Qu6ZndF8QgBKMwimBrechIaqu56LTRaFtWn2N2FSoSPFDDGPAClh8o3Wii3h
    WmXtU4UIpdlwyanZt6DS7CEKxM1G2yBGNUvAI/9KSggaAyLfyuWlS9a0iep84iGUQaZXYv
    /Kitamsvub2Ns1F5CATJjmh/MwtuDVaVCUSOL+ReX2n/nS6/v8j7ZLyQvo1bPe9fvWARNN
    1GR7OlnsagNqnFjSx+CpisG+sJTSVBoCjRelw724v+Plqd7NKxMQMfzQQMqfXxeSl8X09O
    tGE42hHsNTh4oM3hZ4RbwZNz9Ozf5SsyXL0bVSRUeVrgxMT6Ah9BfHH+FuYMZVLN3HUPlJ
    rXAvkqE085ShHgBKFrQgk5/v8UnTjEndj+ycM/lbi6F3pLD8CHnrgfNvFMJCTOpalHL+ey
    yU+2VzoySjHyuq+Imx2QXeWPjwppnEDRQ6ADg2jdj92om8VH5PgbGz/CrJJQ
X-ME-Proxy: <xmx:2T2Cata7B-Emn_oeYiYaXOhgwhXvs1lqlP7yALbnGwl85_yX7ZfMDw>
    <xmx:2T2CanVcVpB8D2y8ICPmmPAmHHNzKYqImBmgPhsYRh0ZXiyc_GC2qQ>
    <xmx:2T2CaoLQehpWDIZN4Fw7KCJdCGZ6gas1cuDFxqu4aARtfHtcZsQxUw>
    <xmx:2T2Caqc3cS4ibhIcW_G788_ZjKYaI7LGPNvl_y8vdkRSNXpovqkliA>
    <xmx:2T2CaoYHLc6lCuDuCyxS_lf-dHA1pjgRGutm55dEIeaKesrdsoJRL1hu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:49 -0400 (EDT)
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
Subject: [RFC PATCH 16/57] mm/collapse: freeze the sources behind migration entries
Date: Sun, 16 Aug 2026 23:45:28 +0100
Message-ID: <20260816224609.308019-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6427D14000C
X-Stat-Signature: ginrg7xjca1y6mjkqoogjcsfazmf4ixf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786920410-96358
X-HE-Meta: U2FsdGVkX18/HxSP5KACn1NNuWQwJpXeuCwLZK59pDLOjhNb+TCITaN1iadCyVdHlA2rBlzZWmXHug3YoMsbpV2rrQTLHkEmnSEe16mSjdaVOtkOXQ/a7XteczYM6Pnr+lmhtJ0sTkrFHakb3zXvU6bsRjnmV+hC/gUbnoXV091XNVVUwld50LyMl5Dy5rZJELMGgZ0Y92iuYJIaf4PuxDHY+UnifonXh13zA2r0hxtP/luV+ETAyvbprqldqOsVSaghre85MtxCWrjNfgR9npkm/W92pXc1jumE2P+S9hivbFwNMfSl4AJURyxQo8eunkZzwjIAV/ykH85xaaF/s0E4miKdbn0wVg58nCZ/enQiPe+MTOfXXErMixDBOmD+eVBsU5H/wcVGoLzxKsuwQzjiSnkojuSE2WixngjQ8oJd2lys0a3uZIQX4LI6V0suOls+FbapGoJ31oXgTGTm7FrZqvWxd9ZkCuPy3OeLa8RMdzn00wOMz1D7rVNJ+PEn9Q8IyIIEqcGvewBKm5U4X1p7cyuCAOHVA0pRTTGTfwveryQ1bRfEKMLWuYLiYCvVv3t9kLjq+aOHCiQ2lL3IZ+FkFqeB8nF0Ap1HjSWR9lPOZbXsz56cs7MCOLGiEcJAgysCqN1CqwILQEjMwf/+ntJbpo8F116Z5ifR2jxy6N2CcFSABs8pQeY8N87zWkiRM563Rd06khWGU+Fi68lhHq7sro4/CXi83oR/Ggl6D7pn1ktrtLa4OmgE7ph9ly2XFOYdxo+lRUsgLQBTEOWoooiBq0SHmGBEMWK8X3ynN8rDK60AM/JP8ydcxFsEPrvtXJppazsusd8vtsKILEG6qeyKHLroUs1vvdJ2bUZ62VYq4zZApC8n6DVKkpNL2RE2VAsx2LlGoL8LBiDpLbi++aAdblsQe2S//J3Z4EMaXng0D7pYTMULS8w9vqHZJpH0ONQoGiAYKEwAk1Vtv+P
 k0/BWYsj
 LWq2UvjutVLCJUYgCjUey6tJldrvEAhQzB4MmPdLuFwoAFnm4C7ki3s2j0UkdY/CzK2cCtiGUTvQ9SKpVnLMkF72phON7WSfGz5NHN1K90U4xXnW9xzd28htI5QEIoLk2pyNm9kY6BDrJl1+i6Cr8S4IF6f+49BMe1rpVHFHoRyxmCIEQpL7CUYLIiEDLCPOp6xCnsmYqZQ90Tm4cSiGeNnrVo5Hkx6ZEPQgGm1xkzegJzHRqmGw8SE48Nau9a5dQNakxRax83txweRkQRl8ed+qwxEAQA6NMYdAOeL+kR9XwVWIwveO24AMSvoRnGp+MP15VMg277qkn4AWMdvJdE/W0oKUwXtb8LV9EBnv+R1gnWYybSHXbhg1Xhgu0MC1Cnctxw5Rx3yaFnw+Ejhtf7Bp8zb7nyUNat/HXdSGWA0aXCYOudGyHXIdxDTJ78mib4IuvoURT6mupx1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The acting half.  For every span the checking half accepted:

 1. take a reference on the source folio and lock it;
 2. replace its PTEs with migration entries.  This closes the userspace
    side: faults and GUP-slow now wait on that folio lock, taken before
    the first entry becomes visible;
 3. freeze the folio to folio_expected_ref_count() + 1.  This closes the
    kernel side: folio_try_get() fails.

The two barriers rise in that order because it is reachability order, and
together they are what lets the copy run with no lock at all.

Writeback is the one case the freeze cannot catch, so such a folio is
refused up front.  PG_writeback holds no reference of its own, so the
frozen count is exactly right and the freeze succeeds -- then
folio_end_writeback() takes a reference outright and BUGs on it, or frees
it under the copy.

From the freeze to the putback the round holds every source folio's lock
at once, and folio locks have no global order.  The engine only ever
folio_trylock()s, and unfreezes rather than blocks on refusal, so it is
never the waiting edge of a cycle.

One ranged TLB flush covers everything that froze, before the ptl is
dropped.  Until it completes a CPU with a stale entry could still write a
source through the old mapping, and that path never consults a refcount.

A candidate that cannot finish restores what it displaced, unfreezes,
unlocks and drops out; its neighbours carry on.  The restore needs no
flush of its own: what it puts back is identical to whatever a stale
entry holds.

It restores slot by slot.  The PTEs of one span agree on the PFN and
nothing else, so a partial CoW, or a clear_refs write-protect undone one
page at a time, leaves permissions the first PTE cannot stand for.  Dirty
accumulated over the span goes to the folio instead, the way unmap does.

The displaced values live in a pool sized to a whole table, since one
candidate can displace that much and the byte cap bounds a round, not a
candidate.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 335 ++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/collapse.h |   3 +
 2 files changed, 330 insertions(+), 8 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index c75d91cb9d48..cf2b9b3640ae 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -115,10 +115,20 @@
 	min(COLLAPSE_BATCH_BYTES >> (PAGE_SHIFT + COLLAPSE_MIN_MTHP_ORDER), \
 	    COLLAPSE_TABLE_WINDOWS)
 
+/*
+ * The saved-PTE pool spans a whole table.  The byte cap bounds what a round
+ * holds, but not what one candidate does: a sub-PMD order goes up to
+ * HPAGE_PMD_NR/2 pages -- 256M at order 12 with 64K pages -- and displaces all
+ * of its PTEs in one shot regardless.  So the pool has to fit the largest span
+ * of displaced PTEs a table can hold, which is the table itself.
+ */
+#define COLLAPSE_SAVED_PTES	HPAGE_PMD_NR
+
 /* How far a candidate got, and so what a failure has to undo for it */
 enum collapse_candidate_state {
 	CAND_SELECTED,		/* collected; nothing held on its behalf yet */
 	CAND_SKIPPED,		/* refused; nothing of it left to undo */
+	CAND_FROZEN,		/* sources displaced and frozen */
 };
 
 /*
@@ -136,6 +146,7 @@ struct collapse_candidate {
 	enum scan_result result;
 	struct folio *new_folio;
 	pgtable_t deposit;		/* PMD order: fresh table to deposit */
+	pte_t *saved_ptes;		/* its slice of collapse_control::saved_ptes */
 };
 
 static unsigned long candidate_start(const struct collapse_candidate *cand)
@@ -168,15 +179,20 @@ static unsigned int candidate_offset(const struct collapse_candidate *cand,
 void collapse_control_release(struct collapse_control *cc)
 {
 	kfree(cc->candidates);
+	kfree(cc->saved_ptes);
 	cc->candidates = NULL;
+	cc->saved_ptes = NULL;
 }
 
 int collapse_control_init(struct collapse_control *cc)
 {
 	cc->nr_candidates = 0;
 	cc->candidates = kmalloc_objs(*cc->candidates, COLLAPSE_MAX_CANDIDATES);
-	if (!cc->candidates)
+	cc->saved_ptes = kmalloc_objs(*cc->saved_ptes, COLLAPSE_SAVED_PTES);
+	if (!cc->candidates || !cc->saved_ptes) {
+		collapse_control_release(cc);
 		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -401,6 +417,99 @@ static unsigned int collapse_span_max(pte_t first, unsigned int max)
 	return min(max, left);
 }
 
+/*
+ * Length of the source span at slot @i, read from the saved PTEs rather than the
+ * table: once frozen the slots hold migration entries, so a rollback re-derives
+ * the freeze's spans from what it displaced.
+ */
+static unsigned int collapse_saved_span_len(struct collapse_candidate *cand,
+					    unsigned int i, unsigned int bound)
+{
+	pte_t first = cand->saved_ptes[i];
+	unsigned int nr, nr_max;
+
+	nr_max = collapse_span_max(first, bound - i);
+	for (nr = 1; nr < nr_max; nr++) {
+		pte_t saved = cand->saved_ptes[i + nr];
+
+		if (pte_none_or_zero(saved) ||
+		    pte_pfn(saved) != pte_pfn(first) + nr)
+			break;
+	}
+	return nr;
+}
+
+/*
+ * Undo a freeze that could not complete: restore the displaced PTE values over
+ * the candidate's migration entries, then unfreeze, unlock and release the
+ * source folios.
+ *
+ * How far the freeze got:
+ *
+ *  - @nr_saved slots were displaced, in PTEs;
+ *  - @nr_frozen of those belong to folios that were also frozen.
+ *
+ * Each slot restores by class: a hole was never modified, a cleared zeropage is
+ * stored back plainly, and a source's saved value goes back as it was.  All are
+ * plain stores -- writing over a non-present entry has no hardware A/D race.
+ *
+ * Slot by slot, not one set_ptes() over the span: the PTEs of one folio need
+ * not agree on more than the PFN, so the first one's permissions are not the
+ * span's.
+ *
+ * Deliberately no TLB flush: the restored translation is identical to anything
+ * a stale TLB entry may hold, so every stale entry is benign.  This reads like
+ * a missing flush; it is not.
+ *
+ * Caller holds the table's ptl -- the same uninterrupted hold the freeze ran
+ * under.
+ */
+static void collapse_unfreeze_candidate(struct mm_struct *mm,
+					struct collapse_candidate *cand,
+					pte_t *pte, unsigned int nr_saved,
+					unsigned int nr_frozen)
+{
+	unsigned long addr = cand->addr;
+	unsigned int i = 0;
+
+	while (i < nr_saved) {
+		pte_t saved = cand->saved_ptes[i];
+		struct folio *folio;
+		unsigned int nr, k;
+
+		if (pte_none(saved)) {
+			/* Hole: nothing was touched */
+			i++;
+			addr += PAGE_SIZE;
+			continue;
+		}
+		if (is_zero_pfn(pte_pfn(saved))) {
+			/* Cleared zeropage: plain non-present -> present store */
+			set_pte_at(mm, addr, pte + i, saved);
+			i++;
+			addr += PAGE_SIZE;
+			continue;
+		}
+
+		folio = pte_folio(saved);
+		nr = collapse_saved_span_len(cand, i, nr_saved);
+
+		for (k = 0; k < nr; k++) {
+			set_pte_at(mm, addr + k * PAGE_SIZE, pte + i + k,
+				   cand->saved_ptes[i + k]);
+		}
+		if (i < nr_frozen) {
+			folio_ref_unfreeze(folio,
+					   folio_expected_ref_count(folio) + 1);
+		}
+		folio_unlock(folio);
+		folio_put(folio);
+
+		i += nr;
+		addr += nr * PAGE_SIZE;
+	}
+}
+
 /*
  * Can this candidate's sources be frozen?  Every slot is checked and nothing is
  * touched, so a refusal costs the round nothing but the walk.
@@ -525,6 +634,193 @@ static enum scan_result collapse_check_candidate(struct vm_area_struct *vma,
 	return SCAN_SUCCEED;
 }
 
+/*
+ * Freeze one candidate's sources, span by span, raising both quiescence
+ * barriers in reachability order:
+ *
+ *  1. the span's PTEs become migration entries.  Faults and GUP-slow now wait
+ *     on the source folio's lock, taken before the first entry is visible.
+ *  2. the folio is frozen to its expected reference count, so folio_try_get()
+ *     fails for anyone taking a speculative reference.
+ *
+ * All or nothing: a failure part way through unwinds what it displaced and
+ * leaves the table as it was found.
+ *
+ * Neither barrier deflects a path that takes its reference outright rather
+ * than speculatively.  Such a source has to be refused before the freeze, not
+ * survive it -- see the writeback test below.
+ *
+ * A round holds every source folio's lock at once, from freeze to putback, and
+ * folio locks have no global order.  That cannot deadlock: folio_trylock() is
+ * the engine's only acquisition and a refusal unfreezes instead of blocking, so
+ * the engine is never the waiting edge of a cycle.  Nothing between freeze and
+ * putback waits on anything that could wait on us -- allocation and charging
+ * happen earlier, and the copy only copies.  The install does take the ptl
+ * while holding these folio locks, which is the safe order: a faulter on one of
+ * our migration entries cannot sleep on the folio lock under a spinlock, so it
+ * drops the ptl first.  Do not add a blocking lock or a sleeping allocation
+ * between freeze and putback.
+ *
+ * On entry:
+ *
+ *  - mmap_read is held, and the table's ptl for the whole freeze;
+ *  - collapse_check_candidate() has accepted the candidate under that same ptl
+ *    hold;
+ *  - the round is covered by an mmu_notifier_invalidate_range_start() issued
+ *    outside the ptl.
+ *
+ * collapse_freeze() issues the ranged TLB flush over everything that froze
+ * before dropping the ptl.  No copy may run before it completes.
+ */
+static enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
+		struct collapse_candidate *cand, pte_t *pte)
+{
+	const unsigned int nr_pages = candidate_nr_pages(cand);
+	unsigned int nr_saved = 0, nr_frozen = 0;
+	enum scan_result result;
+	struct folio *folio;
+	unsigned long addr;
+	unsigned int i;
+
+	for (i = 0, addr = cand->addr; i < nr_pages;) {
+		pte_t ptent = ptep_get(pte + i);
+		unsigned int nr, nr_max, k;
+		pte_t rep;
+
+		if (pte_none(ptent)) {
+			/* Hole: nothing to freeze; install verifies it stayed one */
+			cand->saved_ptes[i] = ptent;
+			nr_saved = ++i;
+			addr += PAGE_SIZE;
+			continue;
+		}
+		if (is_zero_pfn(pte_pfn(ptent))) {
+			/*
+			 * Clear the zeropage mapping now, covered by the round's
+			 * ranged flush: overwriting a live PTE at install would
+			 * be a valid->valid transition, breaking arm64's
+			 * break-before-make.  The zeropage has neither rmap nor
+			 * per-map references -- the saved value alone undoes it.
+			 */
+			cand->saved_ptes[i] =
+				ptep_get_and_clear(mm, addr, pte + i);
+			nr_saved = ++i;
+			addr += PAGE_SIZE;
+			continue;
+		}
+
+		folio = pte_folio(ptent);
+
+		/*
+		 * A folio revisited by a second span of this round is already
+		 * ours and frozen at its first span: folio_get() on a zero count
+		 * is a bug, and try-get fails cleanly.  Scrambled layouts
+		 * (mremap) construct this; nothing else can hold a folio frozen
+		 * while its PTE is live under our ptl, so it is not transient.
+		 */
+		if (!folio_try_get(folio)) {
+			result = SCAN_PAGE_COUNT;
+			goto unfreeze;
+		}
+		if (!folio_trylock(folio)) {
+			folio_put(folio);
+			result = SCAN_PAGE_LOCK;
+			goto unfreeze;
+		}
+
+		/*
+		 * Never freeze a folio under writeback.  PG_writeback holds no
+		 * reference of its own -- the swapcache reference keeps the folio
+		 * alive, and everything that would drop it waits for the flag --
+		 * so folio_end_writeback() plain folio_get()s a folio it may
+		 * assume is alive: a BUG on a frozen one, or with
+		 * CONFIG_DEBUG_VM off, a free under our copy.
+		 *
+		 * Unlike every other hazard here, the freeze does not catch it.
+		 * folio_expected_ref_count() counts the swapcache reference, so
+		 * the count is exactly right and the freeze succeeds.  Nor can
+		 * "is it in the swapcache" stand in for this test: that would
+		 * refuse the pages the fault-in pass just swapped in.
+		 *
+		 * Reachable even though writeback starts on an unmapped folio: a
+		 * re-fault from the swapcache maps it back before the bio
+		 * completes, and folio_free_swap() will not drop the cache entry
+		 * under writeback.  Testing once is enough -- writeback starts
+		 * only under the folio lock, which we hold from here through
+		 * putback.
+		 */
+		if (folio_test_writeback(folio)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			goto unfreeze;
+		}
+
+		/* Each slot's own value: a span agrees on the PFN, not the rest */
+		cand->saved_ptes[i] = ptent;
+		nr_max = collapse_span_max(ptent, nr_pages - i);
+		for (nr = 1; nr < nr_max; nr++) {
+			pte_t tail = ptep_get(pte + i + nr);
+
+			if (!pte_present(tail) ||
+			    pte_pfn(tail) != pte_pfn(ptent) + nr)
+				break;
+			cand->saved_ptes[i + nr] = tail;
+		}
+
+		/*
+		 * The clear is the GUP-fast linearization point: a grab landing
+		 * before it elevates the refcount and the freeze below fails
+		 * (the candidate unfreezes); one landing after fails its PTE
+		 * re-read and retries.  Clear and store sit adjacent under one
+		 * uninterrupted ptl hold, batched per span
+		 * (get_and_clear_full_ptes() unfolds contpte), so the transient
+		 * none window is invisible to installers, which all take the ptl.
+		 */
+		rep = get_and_clear_full_ptes(mm, addr, pte + i, nr, 0);
+
+		/*
+		 * Dirty from the clear -- including any the hardware set since
+		 * the reads above -- goes to the folio, the way unmap does,
+		 * rather than onto PTEs that never had it.  Young needs no such
+		 * care: a migration entry drops it either way.
+		 */
+		if (pte_dirty(rep))
+			folio_mark_dirty(folio);
+
+		for (k = 0; k < nr; k++) {
+			pte_t saved = cand->saved_ptes[i + k];
+			swp_entry_t entry;
+			pte_t swp_pte;
+
+			entry = make_readable_migration_entry(pte_pfn(saved));
+			swp_pte = swp_entry_to_pte(entry);
+			if (pte_soft_dirty(saved))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			set_pte_at(mm, addr + k * PAGE_SIZE, pte + i + k,
+				   swp_pte);
+		}
+		nr_saved = i + nr;
+
+		if (!folio_ref_freeze(folio,
+				      folio_expected_ref_count(folio) + 1)) {
+			result = SCAN_PAGE_COUNT;
+			goto unfreeze;
+		}
+		nr_frozen = nr_saved;
+
+		i += nr;
+		addr += nr * PAGE_SIZE;
+	}
+
+	cand->state = CAND_FROZEN;
+	return SCAN_SUCCEED;
+
+unfreeze:
+	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
+	return result;
+}
+
 /*
  * Raise the two barriers on the sources of every candidate: migration entries in
  * their PTEs, then a frozen refcount.  Takes the table's ptl once for the whole
@@ -534,11 +830,15 @@ static enum scan_result collapse_check_candidate(struct vm_area_struct *vma,
 static void collapse_freeze(struct vm_area_struct *vma,
 			    struct collapse_control *cc, pmd_t *pmd)
 {
+	unsigned long flush_start = ULONG_MAX, flush_end = 0;
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, *table;
 	spinlock_t *ptl;
 	unsigned int i;
 
+	/* Pending per-CPU folio batches hold references that fail the freeze */
+	lru_add_drain();
+
 	pte = pte_offset_map_lock(mm, pmd, cc->candidates[0].addr, &ptl);
 	if (!pte) {
 		for (i = 0; i < cc->nr_candidates; i++) {
@@ -562,15 +862,27 @@ static void collapse_freeze(struct vm_area_struct *vma,
 	for (i = 0; i < cc->nr_candidates; i++) {
 		struct collapse_candidate *cand = &cc->candidates[i];
 		pte_t *cand_pte = table + pte_index(cand->addr);
+		enum scan_result result;
 
 		if (cand->state != CAND_SELECTED)
 			continue;
 
-		cand->result = collapse_check_candidate(vma, cc, cand, cand_pte);
-		if (cand->result != SCAN_SUCCEED)
+		result = collapse_check_candidate(vma, cc, cand, cand_pte);
+		if (result == SCAN_SUCCEED)
+			result = collapse_freeze_candidate(mm, cand, cand_pte);
+
+		cand->result = result;
+		if (result != SCAN_SUCCEED) {
 			cand->state = CAND_SKIPPED;
+			continue;
+		}
+
+		flush_start = min(flush_start, candidate_start(cand));
+		flush_end = max(flush_end, candidate_end(cand));
 	}
 
+	if (flush_end)
+		flush_tlb_range(vma, flush_start, flush_end);
 	pte_unmap_unlock(pte, ptl);
 }
 
@@ -698,7 +1010,7 @@ static void collapse_provision(struct mm_struct *mm,
 		struct collapse_candidate *cand = &cc->candidates[i];
 		enum scan_result result;
 
-		if (cand->state != CAND_SELECTED || cand->new_folio)
+		if (cand->state != CAND_FROZEN || cand->new_folio)
 			continue;
 
 		result = collapse_alloc(mm, cc, cand, gfp);
@@ -1200,13 +1512,14 @@ static bool collapse_run_batch(struct mm_struct *mm, unsigned long pmd_addr,
  * a single candidate is above the cap all by itself once a PMD is (512M with
  * 64K pages), and refusing it would collapse nothing at all.
  */
-static bool collapse_batch_full(struct collapse_control *cc,
+static bool collapse_batch_full(struct collapse_control *cc, unsigned int slots,
 				unsigned long bytes, unsigned int order)
 {
 	if (!cc->nr_candidates)
 		return false;
 
 	return cc->nr_candidates == COLLAPSE_MAX_CANDIDATES ||
+	       slots + (1U << order) > COLLAPSE_SAVED_PTES ||
 	       bytes + (PAGE_SIZE << order) > COLLAPSE_BATCH_BYTES;
 }
 
@@ -1215,7 +1528,8 @@ static bool collapse_batch_full(struct collapse_control *cc,
  * previous round's values, so every field is set here.
  */
 static void collapse_add_candidate(struct collapse_control *cc,
-				   unsigned long addr, unsigned int order)
+				   unsigned long addr, unsigned int order,
+				   pte_t *saved_ptes)
 {
 	struct collapse_candidate *cand;
 
@@ -1232,6 +1546,7 @@ static void collapse_add_candidate(struct collapse_control *cc,
 	cand->result = SCAN_FAIL;
 	cand->new_folio = NULL;
 	cand->deposit = NULL;
+	cand->saved_ptes = saved_ptes;
 }
 
 /*
@@ -1246,6 +1561,7 @@ collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
 	const unsigned long pmd_addr = start & HPAGE_PMD_MASK;
 	unsigned int offset, order;
 	unsigned long bytes = 0;
+	unsigned int slots = 0;
 	bool pending = false;
 	bool cont = true;
 
@@ -1256,7 +1572,7 @@ collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
 		if (!pending)
 			pending = collapse_next_candidate(cc, &offset, &order);
 
-		if (!pending || collapse_batch_full(cc, bytes, order)) {
+		if (!pending || collapse_batch_full(cc, slots, bytes, order)) {
 			/*
 			 * Selection is exhausted and the round is empty: the
 			 * range is done.  Without this a flush of an empty
@@ -1267,6 +1583,7 @@ collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
 				break;
 
 			cont = collapse_run_batch(mm, pmd_addr, cc);
+			slots = 0;
 			bytes = 0;
 			continue;
 		}
@@ -1276,8 +1593,10 @@ collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
 		 * collecting costs nothing but the array slot.  A candidate the
 		 * full round could not take is kept pending for the next one.
 		 */
-		collapse_add_candidate(cc, pmd_addr + offset * PAGE_SIZE, order);
+		collapse_add_candidate(cc, pmd_addr + offset * PAGE_SIZE, order,
+				       cc->saved_ptes + slots);
 
+		slots += 1U << order;
 		bytes += PAGE_SIZE << order;
 		pending = false;
 	}
diff --git a/mm/collapse.h b/mm/collapse.h
index 747168104a72..3256c45ee228 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -137,6 +137,9 @@ struct collapse_control {
 	 */
 	unsigned long batch_start;
 	unsigned long batch_end;
+
+	/* PTE values the round displaced, carved up between its candidates */
+	pte_t *saved_ptes;
 };
 
 static inline int collapse_test_exit(struct mm_struct *mm)
-- 
2.54.0



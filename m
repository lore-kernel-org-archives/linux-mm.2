Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70A6DC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B403D6B0879; Sun, 16 Aug 2026 18:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9686B087B; Sun, 16 Aug 2026 18:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F51E6B087C; Sun, 16 Aug 2026 18:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F63B6B0879
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E56AC40628
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:04 +0000 (UTC)
X-FDA: 85108619568.12.625974C
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1164840004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="n y2uZjQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QHQBe79j;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920423;
	b=rF519l2zhQcsW+ITzaB2tR8298CllYkeWrXr+1/I0bY5BKyRXAdC7biG4TjDDq/lYBui2e
	PE/ZqDj5CVk2VjR3sPJ33e0VtGK4Y+wAMHXc20+M4B6cKZso+bXIYvSNb9sUO6M8WqxOz9
	mspFkCKaV0gBE+KCNimZvaOBQUNaLzg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="n y2uZjQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QHQBe79j;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzlfiKIcvEbT8Dr/8J+UmVaUqw8Y/2tyxTnz6oo7+IU=;
	b=fp5Pd9mQfbdC5Bx/KcYnRyxx7HLKgUojhASj7hLRrtzVmtk8PbF+YEA449qa2DmxgboJ6J
	iI7wXMtxxEQpt8DBPL9gf9gcfA+Wu1sTQ9cFkbQ4RaTfaJjQ8Vlkg0/3UNYlgYLfeNE29x
	ixe/iiNOZX4UoSdw0Ev/7/cSoJYEYBU=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id A1ACAEC0246;
	Sun, 16 Aug 2026 18:47:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sun, 16 Aug 2026 18:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920422; x=
	1787006822; bh=qzlfiKIcvEbT8Dr/8J+UmVaUqw8Y/2tyxTnz6oo7+IU=; b=n
	y2uZjQ39Z45oxzCucWHqHZWv5YZDRetLzNNV5GCNHCDEGC9wlzSI5jzbCF7uR7fk
	1GvWKXurQgug48KbUeFublWC6BH7EEj6V3z5VvNideshKDSaJQVEmhzWHxg5SrVD
	nKNs3PrXYkGNjn9tKOAX/VGCSQAeRzjhDuamghEBlzdKF31lvQY+NTDygccAxTNK
	1iEeAwXTrcq4l9CTMRTp4drqBkBizQb2NDyXmjFwwQ9Mwgr+2X8Ae2wzwJzLs2ZY
	fGbQb3Gm7ElB8nBZ0j3PpBlWEsMY3IpZrusavoC32Ja/Z8V+/IAWwQEJsWzDBSKw
	l2jGNopytQGRqwoyzLYDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920422; x=1787006822; bh=q
	zlfiKIcvEbT8Dr/8J+UmVaUqw8Y/2tyxTnz6oo7+IU=; b=QHQBe79jZ5W+AjIsH
	8jI3at8052DccDT1GJdP0OC5UE9md2mgTewL+KWmZuZCnOLTPFGApWNq8Yq48taZ
	4I3s2KdKjUdsBEPJmNr+3e11seON2EDhVFQPTe1TgzYB/OPKRUESJVWP8qoXp/9r
	H6PpynctpSGgy58eeRFXP9hD2gypGH/dX8sLRQxiNWbkzx4xnvEuAnP4Ldq9xb8K
	KyQpazIflBi6BCR3vGBi/np3WAp0OkUdZNZ4SVDnLvrD2Bmbj1xo4yCx81TV0HDz
	iGgVpBWhpjrzFpFvKUIdDeaWRmbiHsPbSsgGsAPddNGvlPlqxdDXEqAQct9SeAOv
	GtFdw==
X-ME-Sender: <xms:5j2CavJHhQfMpft9fF6lKK3I9UNYhH5UXhIavu40vr9Po9fYLxH0EQ>
    <xme:5j2CaodD7uuUrwWn5YphJz_7DvsE_yQ8UaPwF7ym-9_XLCpUqIfa-bP4TKBAUhFbx
    q57imF6qDdsAVRdG3ReFnxhyYFbrLdMPw7zvsxQfP8fQWig3_hgZ22f>
X-ME-Received: <xmr:5j2CajwCYDQfF2fNcOA_ESuOw60IVOjzOCw0jAsetxFsZBdiQnD7OPOWOqw>
X-ME-Proxy-Cause: dmFkZTFX8QZ1Abcp//ElmtP0wYUsUMnb+KjPA544aOlJXhXcQAudkXa81C9Rj4L11ediC/
    SYpDnD1LvcyFEAv2YFQNL3ReIx6t28G7cFOXvsWQqNdQRv24cIelnnbcWrHqur16sY2q+b
    PHK84xbhjrx0R6ZFbdj3lDcQr+wbYteZ9PHsSvZgjQoovnxRkTlpJXxI+K+aK0DY9MqaWr
    nM0jSjvJAOtmNeFdTIuI9VxKMOFqeJI9DUUNBafqnTlsaU2K5w1xy/oDJpRmozGKRfcEpJ
    T4FDpTcqBKNo58tTW6I4nVl91YkYNyFfziYdH6IV5aj62MGBqsSUtSYZnaDODTOndFzToM
    MZcmzdxzEDBChv7E0c2Xjsinj9zJe8Q5aa6n4OlJqqveLcQGvaXqWzd7QR9JsdEtU27rOw
    JUcvqeU5GST0gG0WMSxAMvGj4+YO6ChL3A4m737E7UOdycrEYBdvuyCiO1B1fN4ildGW75
    9DhSN/aJ4aniV6bisp3pLIVgHYSzBzKjs0JMAg4qCqUXig9qixxwzzHICDHHPzIQYQi7WP
    ImdDWbUrXQYfXkXPLMpK+OxzBZQu5Wm+uObzndajfcgGbkFpakF3J0YAW0YeNiCPQKZxRr
    XNeomXEHQ/V11EoDQUpSqlBfnVMS7YlgywXks3dovS90F97XkDJJiYmecVSg
X-ME-Proxy: <xmx:5j2Cak--v4OsbjXRHbOoJ6mJxHhlU4F91eqMVrx5gL-r8jaIfexb8g>
    <xmx:5j2CaspC1E9UwWOPuMUyAZa1K47nfAwESTorEZC2PgQz1bAFiUhRvQ>
    <xmx:5j2CalkKm39NkL2Ge6MqhE1dJP9yVNC5tBo6Tfkv2C5Syjpvcf1d_g>
    <xmx:5j2CapayI7VHpWdzY3cmKkxcWfXgphY7hmaQy_47kS-RuQgihgCKTg>
    <xmx:5j2CatoMhtayUFIYO01sI8H4g4NCKtKeq-6QR-A7qZOOuw1SOZ7f1uDy>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:01 -0400 (EDT)
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
Subject: [RFC PATCH 23/57] mm/collapse: give a refused region a second chance
Date: Sun, 16 Aug 2026 23:45:35 +0100
Message-ID: <20260816224609.308019-24-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1164840004
X-Stat-Signature: ahrr935ubq9st7ge39t5cm4oir9rmtk4
X-HE-Tag: 1786920422-915447
X-HE-Meta: U2FsdGVkX1+ShyHwIxXDPRj0Q0GK8BPWnD19kqjJ4qjNQQv1CaAw7wKYp7tZW0diCBdxLMMZqHixf1RCHLuaePgSPKXByxom7NvpDFvuMmWRVVumxWTKY/nt1J3FcsrBruuq8eR3d/HraRAIeiJquhZB3rsdbHITara5tT8x3fmo/fKxuqVvzktbM7CG93CoMwEGmL7YfgAc/HY+IeEcuMEC3CpX1FLGXdgbgNPOlIvamHNGdB2fLQbI45dyI0+S/nzt6V3P8eqHR2LxjkEqZvc1GRpT6tl5sOa2CY5xM+t62eL0q+D18SsFjH6O47MJFB02lkaHP3xpltfsVDNCERSqvcp2RaQ6qta+oh0lfuWaItKWwZh6FrVg2Qid0JldrIjzDLR94A2+iXIEcuXPGMDL3/qqDX1hnxkvR4BDYf4Wu3WMy9OtrbsLJECixoMND5tI3lBFYYPPc9FryNIJCYyvi5OD0VrK0wX1gNijMTCKk1Z5Fxrn0gOme+KORe9PMv3uCAJCkeflEVMnjO5cg1DbOfEdA5au7g31m7PGp6vgqd67u/16yJaBDw+9f+AqB0xY987/ryAziWHXG1TZF91DlntwtH3Wcs2Z7+i1kreeQErdF9BtxVPKdL3EDwqrIPhTPQto3Fxv4vVm1CBo5EdFHCPg9eAQNm4nUVfPy+JX6O5DzOksF+wM5RYIavmeTMXiS3BRcM1e+k8lJzpzii1ObVQM2MxpEcj0q1Rui7WLoQ2Nto5BYL51J6lzz5GuvXq2oeyCpQJge6dApRpakQ9OzBjOHv0ET0JlLPRKm49M3PCqeuriuYlMe1v4Tv4Aqr3Vbk/+nphMGhA1zJiyuwRhCYHf1cc1ghU9fR+gBBXDeSgPRzi17zADADpj/DqX3odEqjC+puNDFga3Q3WVYdnYzhucbeWUSd6GpLNakwoFlmscg0Uuhg8rHbqABsEVaDSCVqFmD1NwagHMH1y
 nNTrtM8J
 fHQJKgcu6EhvW6dD467bHsi05jZqrCzUPEirA9E2OT0mPB6nFdm7iXoykzvFLtKWOIGwpqNsOzReavB2y5xUmXqJOAf7X/rZ5E+6DUYpO4Y0D8DwS5reeQpAXH6bkugaGuNjYoe/AJ51ByfYfDp2dempM0rhB8H84g/zJp03RfR0sb7SggW914A/uU4JkADrS9OAqVzPX2Uq+7RdNVyU9gH03S+DAjIOCL9jRDgeTYeQn/yZ4q2PVFXhJSGs6OjGJvkxzIVNnc43kq/vokjs8mycAiOBb0CnlyQsjAJ3q0dk2cGv+7tMw/SQP2m0n3ozGOJhBBk/tjt6VLiUuBez9MUT5FQH88paM3S5cVZdLO4MVciPn59aTVLettHzzqgR4QT5B3zvG30Y/hvWyRT7jlDF2jW97yLaPktYPizr4Bxwi9PVNhIWY5QdCyykchOZMYmbFsnx6WxvhSwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Fill in the rest of selection: a store of regions to re-enter, and the
classification that decides what goes in it.

Each attempted candidate's outcome is one of four:

 - it collapsed, or was already a huge page.  The region is done; the
   cursor stepped past it at emission.
 - it was refused for something a smaller window might avoid.  The whole
   region goes back at the next enabled order down: selection cannot tell
   which slot refused, so it re-probes the region rather than guessing.
 - only its in-window allocation missed.  The region goes back at the
   same order, marked so the round that picks it up allocates with
   reclaim before freezing anything.
 - the outcome condemns the table.  Selection stops there and drops
   everything queued.

A queued region is walked exactly as the table is: the largest order its
offset's alignment allows, capped by the region's own, descending through
the enabled orders until one qualifies, then stepping past what it
emitted.  Walking rather than shrinking one window is what keeps the tail
of a region in play, which is often where the collapsible part is.

The store is a stack, and the classify loop feeding it walks the batch in
emission order, so entries pop in the order they were refused rather than
by address.  A round drawn from two of them is not address-ordered.

Selection terminates because the pushes that tile a region strictly
descend, and the one that keeps the order cannot repeat for a region: it
comes back asking for reclaim, and a miss the allocator was asked to work
for is a failure, which descends.

An allocation failure is only reported as one when nothing smaller is
left to try.  The caller answers such a failure by backing off for a
while, and a failure at a large order is no reason to: one PMD is 512M
with 64K pages, so that attempt fails as a matter of course, while the
order the region settles for allocates fine.

collapse_anon_pmd() can now say what the table yielded, in order of
precedence:

 - a collapse;
 - an allocation failure, which the caller answers by backing off.  It
   outranks both refusals below, being the only result acted on;
 - the scan's own refusal, when selection never got as far as refusing a
   window;
 - the last reason a window was refused.

All are per table, so the reset that opens a table clears them, the retry
store included.

A dropped lock is classified with the outcomes that abandon the table,
not with those that try a smaller order.  The fault-in pass has already
taken the lock again as many times as it may, so what is left says
nothing about any window, and demoting every candidate the round was
carrying would be a verdict no pass reached.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 201 +++++++++++++++++++++++++++++++++++++++++++++++---
 mm/collapse.h |  11 +++
 2 files changed, 203 insertions(+), 9 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 258bb9cc32c5..9b73ebff1103 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -124,6 +124,16 @@
  */
 #define COLLAPSE_SAVED_PTES	HPAGE_PMD_NR
 
+/*
+ * Capacity of the retry store: the most regions a table can hold at once.  Live
+ * entries cover disjoint regions -- a region is one candidate's extent, and an
+ * extent is consumed from the cursor or from one entry, never from two -- and
+ * the smallest a producer pushes is one window at the smallest order.  Not
+ * bounded by what a round pushes: the stack is drained from the top, so an entry
+ * below a live one outlives the round that pushed it.
+ */
+#define COLLAPSE_RETRY_STORE_SIZE	COLLAPSE_TABLE_WINDOWS
+
 /* How far a candidate got, and so what a failure has to undo for it */
 enum collapse_candidate_state {
 	CAND_SELECTED,		/* collected; nothing held on its behalf yet */
@@ -132,6 +142,21 @@ enum collapse_candidate_state {
 	CAND_INSTALLED,		/* the destination is mapped */
 };
 
+/*
+ * A region queued to re-enter selection, walked like the table itself: @offset is
+ * the next window to probe, @end one past the region, and @order the largest to
+ * try -- below the order that just failed, so the same window cannot be emitted
+ * twice.  Walking the region rather than shrinking one window keeps its tail,
+ * which is often where the collapsible window is.
+ */
+struct collapse_retry {
+	unsigned int offset;
+	unsigned int end;
+	unsigned int order;
+	/* The light allocation missed here: the next attempt may reclaim */
+	bool reclaim;
+};
+
 /*
  * A candidate is an (addr, order) window selected for collapse.  Selection
  * counts in PTE offsets -- the bitmap it reads and the alignment it honours are
@@ -181,16 +206,20 @@ void collapse_control_release(struct collapse_control *cc)
 {
 	kfree(cc->candidates);
 	kfree(cc->saved_ptes);
+	kfree(cc->retries);
 	cc->candidates = NULL;
 	cc->saved_ptes = NULL;
+	cc->retries = NULL;
 }
 
 int collapse_control_init(struct collapse_control *cc)
 {
 	cc->nr_candidates = 0;
+	cc->nr_retries = 0;
 	cc->candidates = kmalloc_objs(*cc->candidates, COLLAPSE_MAX_CANDIDATES);
 	cc->saved_ptes = kmalloc_objs(*cc->saved_ptes, COLLAPSE_SAVED_PTES);
-	if (!cc->candidates || !cc->saved_ptes) {
+	cc->retries = kmalloc_objs(*cc->retries, COLLAPSE_RETRY_STORE_SIZE);
+	if (!cc->candidates || !cc->saved_ptes || !cc->retries) {
 		collapse_control_release(cc);
 		return -ENOMEM;
 	}
@@ -1855,6 +1884,9 @@ static void collapse_anon_scan_init(struct collapse_control *cc)
 	cc->select_orders = 0;
 	cc->scan_unmapped = 0;
 	cc->nr_collapsed = 0;
+	cc->select_result = SCAN_FAIL;
+	cc->smallest_alloc_failed = false;
+	cc->nr_retries = 0;
 }
 
 /*
@@ -2010,6 +2042,48 @@ static bool collapse_window_eligible(struct collapse_control *cc,
 	return nr_eligible_ptes >= nr_ptes - max_ptes_none;
 }
 
+/*
+ * Queue the region [@offset, @end) to re-enter selection at @order.  Two
+ * producers push, both in collapse_classify_result(): a refused region, tiled at
+ * the next enabled order down because selection cannot tell which slot refused;
+ * and a region whose in-window allocation missed, at an unchanged order, asking
+ * for reclaim next time.
+ *
+ * The store is a stack, and the classify loop that feeds it walks the batch by
+ * ascending address, so entries pop in the order they were refused rather than
+ * by address: a round drawn from two of them descends.  Nothing may take
+ * candidates[0] for the lowest -- what a round spans is cc->batch_start and
+ * cc->batch_end, taken over its candidates by collapse_revalidate().
+ *
+ * Selection terminates because the tiling producer strictly descends, and the
+ * unchanged-order one cannot fire twice for a region: its retry arrives with
+ * reclaim set, so the next miss is a failure that descends.
+ *
+ * The store is sized for the most regions a table can hold, so this cannot
+ * overflow; losing an entry would cost a region its lower-order attempt, so it
+ * asserts rather than fails.
+ */
+static void collapse_push_retry(struct collapse_control *cc, unsigned int offset,
+				unsigned int end, unsigned int order,
+				bool reclaim)
+{
+	struct collapse_retry *retry;
+
+	if (cc->nr_retries >= COLLAPSE_RETRY_STORE_SIZE) {
+		VM_WARN_ON_ONCE(1);
+		return;
+	}
+
+	retry = &cc->retries[cc->nr_retries];
+
+	retry->offset = offset;
+	retry->end = end;
+	retry->order = order;
+	retry->reclaim = reclaim;
+
+	cc->nr_retries++;
+}
+
 /*
  * The next window worth attempting, as an (offset, order) pair.  False when
  * selection is exhausted, which is what ends the range.
@@ -2019,8 +2093,42 @@ static bool collapse_window_eligible(struct collapse_control *cc,
  * particular -- would be stale by construction.
  */
 static bool collapse_next_candidate(struct collapse_control *cc,
-				    unsigned int *offset, unsigned int *order)
+				    unsigned int *offset, unsigned int *order,
+				    bool *reclaim)
 {
+	while (cc->nr_retries) {
+		struct collapse_retry *r = &cc->retries[cc->nr_retries - 1];
+		unsigned int try, smallest;
+
+		if (r->offset >= r->end) {
+			cc->nr_retries--;
+			continue;
+		}
+
+		/*
+		 * The same walk as the table's own: the largest order the
+		 * offset's alignment allows, capped by the region's, descending
+		 * through the enabled orders until one fits.  If nothing fits
+		 * here, step over the smallest window tried and carry on --
+		 * which is what keeps the region's tail in play.
+		 */
+		try = min(max_order_from_offset(r->offset), r->order);
+		smallest = try;
+		while (try && !collapse_window_eligible(cc, r->offset, try)) {
+			smallest = try;
+			try = collapse_lower_order(cc, try);
+		}
+
+		if (try) {
+			*offset = r->offset;
+			*order = try;
+			*reclaim = r->reclaim;
+			r->offset += 1U << try;
+			return true;
+		}
+		r->offset += 1U << smallest;
+	}
+
 	while (cc->select_offset < cc->select_end) {
 		if (!collapse_window_eligible(cc, cc->select_offset,
 					      cc->select_order)) {
@@ -2035,6 +2143,7 @@ static bool collapse_next_candidate(struct collapse_control *cc,
 		 */
 		*offset = cc->select_offset;
 		*order = cc->select_order;
+		*reclaim = false;
 		collapse_selection_advance(cc, 1U << cc->select_order);
 		return true;
 	}
@@ -2051,7 +2160,68 @@ static bool collapse_classify_result(struct collapse_control *cc,
 				     unsigned int offset, unsigned int order,
 				     enum scan_result result)
 {
-	return true;
+	unsigned int lower;
+
+	switch (result) {
+	/* Done with the region: the cursor moved past it at emission */
+	case SCAN_SUCCEED:
+		cc->nr_collapsed += 1U << order;
+		fallthrough;
+	case SCAN_PTE_MAPPED_HUGEPAGE:
+		return true;
+	/* Only the light allocation missed: the same order, allowed to reclaim */
+	case SCAN_ALLOC_LIGHT_MISS:
+		collapse_push_retry(cc, offset, offset + (1U << order), order,
+				    /*reclaim=*/ true);
+		return true;
+	/* A smaller order over the same region might still fit */
+	case SCAN_ALLOC_HUGE_PAGE_FAIL:
+		/*
+		 * Only a failure with nothing left below it says the allocator
+		 * cannot serve this collapse.  A failure at a large order says
+		 * nothing about what the region will settle for -- one PMD is
+		 * 512M with 64K pages, so that attempt fails as a matter of
+		 * course -- and the caller answers an allocation failure by
+		 * backing off for a while.
+		 */
+		if (!collapse_lower_order(cc, order))
+			cc->smallest_alloc_failed = true;
+		fallthrough;
+	case SCAN_LACK_REFERENCED_PAGE:
+	case SCAN_EXCEED_NONE_PTE:
+	case SCAN_EXCEED_SWAP_PTE:
+	case SCAN_EXCEED_SHARED_PTE:
+	case SCAN_PAGE_LOCK:
+	case SCAN_PAGE_COUNT:
+	case SCAN_PAGE_NOT_EXCLUSIVE:
+	case SCAN_PAGE_NULL:
+	case SCAN_DEL_PAGE_LRU:
+	case SCAN_PTE_NON_PRESENT:
+	case SCAN_PTE_UFFD:
+	case SCAN_PAGE_LAZYFREE:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
+		cc->select_result = result;
+		lower = collapse_lower_order(cc, order);
+		if (lower) {
+			/* The whole failed region re-enters, as one entry */
+			collapse_push_retry(cc, offset, offset + (1U << order),
+					    lower, /*reclaim=*/ false);
+		}
+		return true;
+	/*
+	 * Nothing further is worth attempting in this table.  A dropped lock
+	 * belongs here rather than above: it says nothing about any window, so
+	 * lowering the order of every candidate the round was carrying would be
+	 * a verdict nobody reached.  The next scan finds the table again.
+	 */
+	case SCAN_LOCK_DROPPED:
+	case SCAN_PMD_MAPPED:
+	default:
+		cc->select_result = result;
+		cc->select_offset = cc->select_end;
+		cc->nr_retries = 0;
+		return false;
+	}
 }
 
 /*
@@ -2112,7 +2282,7 @@ static bool collapse_batch_full(struct collapse_control *cc, unsigned int slots,
  */
 static void collapse_add_candidate(struct collapse_control *cc,
 				   unsigned long addr, unsigned int order,
-				   pte_t *saved_ptes)
+				   bool reclaim, pte_t *saved_ptes)
 {
 	struct collapse_candidate *cand;
 
@@ -2124,7 +2294,7 @@ static void collapse_add_candidate(struct collapse_control *cc,
 	cc->nr_candidates++;
 	cand->addr = addr;
 	cand->order = order;
-	cand->reclaim = false;
+	cand->reclaim = reclaim;
 	cand->state = CAND_SELECTED;
 	cand->result = SCAN_FAIL;
 	cand->new_folio = NULL;
@@ -2145,7 +2315,7 @@ collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
 	unsigned int offset, order;
 	unsigned long bytes = 0;
 	unsigned int slots = 0;
-	bool pending = false;
+	bool pending = false, reclaim = false;
 	bool cont = true;
 
 	collapse_selection_init(cc, (start - pmd_addr) >> PAGE_SHIFT,
@@ -2153,7 +2323,8 @@ collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
 
 	while (cont) {
 		if (!pending)
-			pending = collapse_next_candidate(cc, &offset, &order);
+			pending = collapse_next_candidate(cc, &offset, &order,
+							  &reclaim);
 
 		if (!pending || collapse_batch_full(cc, slots, bytes, order)) {
 			/*
@@ -2177,12 +2348,24 @@ collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
 		 * full round could not take is kept pending for the next one.
 		 */
 		collapse_add_candidate(cc, pmd_addr + offset * PAGE_SIZE, order,
-				       cc->saved_ptes + slots);
+				       reclaim, cc->saved_ptes + slots);
 
 		slots += 1U << order;
 		bytes += PAGE_SIZE << order;
 		pending = false;
 	}
 
-	return cc->nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
+	if (cc->nr_collapsed)
+		return SCAN_SUCCEED;
+	/*
+	 * Report an allocation failure over any refusal, the scan's included: it
+	 * is the one outcome the caller acts on, by backing off rather than
+	 * scanning on.
+	 */
+	if (cc->smallest_alloc_failed)
+		return SCAN_ALLOC_HUGE_PAGE_FAIL;
+	/* Nothing salvaged and nothing to wait for: say what was refused */
+	if (cc->scan_refusal != SCAN_SUCCEED)
+		return cc->scan_refusal;
+	return cc->select_result;
 }
diff --git a/mm/collapse.h b/mm/collapse.h
index 94b796271843..3803f5a89087 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -11,6 +11,7 @@
 #define COLLAPSE_MIN_MTHP_ORDER		2
 
 struct collapse_candidate;
+struct collapse_retry;
 
 enum scan_result {
 	SCAN_FAIL,
@@ -135,6 +136,16 @@ struct collapse_control {
 	 */
 	enum scan_result scan_refusal;
 
+	/* Why the last window was refused */
+	enum scan_result select_result;
+
+	/* A region ran out of orders to try because none could be allocated */
+	bool smallest_alloc_failed;
+
+	/* Regions waiting to re-enter selection at a lower order */
+	struct collapse_retry *retries;
+	unsigned int nr_retries;
+
 	/* The candidate windows collected for the current round */
 	struct collapse_candidate *candidates;
 	unsigned int nr_candidates;
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BEE4C5DF70
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26F16B0877; Sun, 16 Aug 2026 18:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFDC36B0879; Sun, 16 Aug 2026 18:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5B86B087A; Sun, 16 Aug 2026 18:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A69036B0877
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D4E91205FC
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:03 +0000 (UTC)
X-FDA: 85108619526.29.6F355D2
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf09.hostedemail.com (Postfix) with ESMTP id 55CC114000C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="T f8ZBSB";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AB0csPAg;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1+9D9mcuyt/yxdgXW36/YFxLEOMLmPJXeDS+6QRV2M=;
	b=idQrklLsKlXWhiGnL/gFC5SXeUDBavhe0mGXEYYZW10G1Bp7L4CTU4I8NwgRIxTQQvCAg5
	ZKN4noZbTGA0SHV+5ag5an5B8/bL2ipqs2YXQ51bl8IH94q09CzG6kY6B9RIjd1OkntoZx
	nXexgYsr1laSLEsLUwgVIEnlDq/+k98=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="T f8ZBSB";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AB0csPAg;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920421;
	b=jLn5bqEKqi0n+p3h/0drWvIDaQnrdA+L8UusO9ToCq4OZ1n8hi64QpuXSkO2s8t9KwHMeb
	J/ZyPXU54JuW8bVbfNemWrYZHTC2DedfBlKZeomtjXdzkmOOd/Lkfd5ga0IZNhxS2G8phe
	gA7VThxlGqeueO6ttu0Yy6Y0rpVHqAc=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id E7A64EC0241;
	Sun, 16 Aug 2026 18:47:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sun, 16 Aug 2026 18:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920420; x=
	1787006820; bh=J1+9D9mcuyt/yxdgXW36/YFxLEOMLmPJXeDS+6QRV2M=; b=T
	f8ZBSBA3TQRK3cD9jO4SD+8+5wk4KAvSmI88xPbHNQQ5uy6iP3VbK+kdBjeI3lQH
	4Uc+i4JN1TGKJHDaJqLp87se4FThEzjG+MY6YJqo1ZSRYbIz54PGd597teurTpcZ
	TiL4MzYQNoRWKr9j4akAwU9Y7zNfm9IOVaGc69Gf4WVWgDFoVOlL/UHDdSwBTWAG
	DV+LyaFOKVXAheken+gJw4on7+C9BRs2RK5WwAHys4l0r/HxDuy7VKJandTVEiX3
	ruO6aLt/NZYWUivJ26MQrQklgCuYO1mYxyANBTQEDz14R+sRW0tUVto6uBCgy5BN
	zswoaiGjXIld8YV4WXptg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920420; x=1787006820; bh=J
	1+9D9mcuyt/yxdgXW36/YFxLEOMLmPJXeDS+6QRV2M=; b=AB0csPAgdvYAGp2gQ
	PiZ8s9TB0lKptBLgc6G8XjReoWX3VQPWod9imkjpE79kqUKaLGn80ihiDFB1OIz0
	B/CNlftWgGIIm35vtT2TvU17FV5LvtxlkCrlwYLrflNfzrpEnUZyxTBsQkgCqPL2
	PxTKH2EqVOV2hhQEYiwpEtRnx8n0K44p0beGRM9qHVcrNgKXqNM3Hw8V6zKg2uUf
	8hSVfY18P+DiMRqCfRwFEuEUDYj3UmnUGcyXBtVHhW7CsEZ5+169BbNgrcdk8gbu
	X9vFIZ1sM4q2VI2IkvwLa0hg6UQKBvJIxlY979/8XvTxKQfQuRkUX35QffVinQIK
	OX61g==
X-ME-Sender: <xms:5D2CathmKe_S5Z3a5FPjO13vpZLQkGGy3yeCxM8B7Gb-qKQsrKKk8w>
    <xme:5D2CarnR9IJlc4OvHwBtrp4ARBQMEWsGqrIzcHNf3vEm0qVsjjGk3Ztbw1dP1W9HV
    VCjosG5RnmEABjBL1wnMlZIALY_447QCOCzXgrYAWgi3DlOq8OtSbU>
X-ME-Received: <xmr:5D2Caohkwljo_5atCYjhUMEtNkX8d1rGTKMrRFt1hBVIB2YWsTWW6K6vZiM>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtc7
    YPFXNzpcj4NYLt23UmZkN6vYCsvNuqRLXW2/cXefqbxj2Ku/EoFycRIBFGawf0PxryN+Ss
    t7WEunz71VUfOY4zX967A9vNhnBU7zoN7JwtQVp8mdlYrYolVL1fcnlt4bdpNKdHuwZ3+v
    ZxaZVO8TeJhVBOw1hQ1lmw0SyaRFM0DgZbVpmtF16qIJ/Y2yOFAOIDaAzF1wjmqhEnnqjk
    IOf+1hbIQ3Wdy1ombl+1sqs1iZoiq11q6UdwsaD8e5fjodHmOzN/3y40+8nouAVZJxY6iF
    aj0zkUU68uxiRWlFTw0RZwSEXhpsRX558YVTFYZaKy+qpBE9hovTY7LMtYzA
X-ME-Proxy: <xmx:5D2Cag8_2A1zH9w4UURlg9PWxKVlZq2mm5BamwjpOk0vHirheiH7xw>
    <xmx:5D2Carpxj2GAAs1QYydVib8Y9mszwmkLYpZr1J7MJevBzlm5-KEuvQ>
    <xmx:5D2CauPcgOpDHV2cD5ci1dz3gV8mI9x3JZMQxdVezE2Rbe3bXdpLhA>
    <xmx:5D2CavSij7eSks4BrppBv8RAbxirLNVGT4IxbIeVXJwfcoqO0mE7fw>
    <xmx:5D2CanfwrsPJ0T76uZ0qz2L-Y19ekWjEQ3GpbXBMc44vBIxbOoQtqZIP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:00 -0400 (EDT)
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
Subject: [RFC PATCH 22/57] mm/collapse: walk a table with a selection cursor
Date: Sun, 16 Aug 2026 23:45:34 +0100
Message-ID: <20260816224609.308019-23-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 55CC114000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 3bq6gpph6worqygyjz4fkfp9hfqs9rbg
X-HE-Tag: 1786920421-697846
X-HE-Meta: U2FsdGVkX1+n96mjK9h3IomBqOgilPv8Z9CxinbxRI506U+o7kYKPM8Kzpsu4PCb0ZUawF5XG1RvrFRXbGC0XxQgKCYfZki2YpI7T3yFJm0WQThNFRHwfsLzhGmfFO9eO66asuJlNmJ2HnIYZfOd9YcpDFGh2IJo1/MQZ6NMC/q05/5umCTi5C/I9z8P9Q8TUL0Rk+35wm4WFCdcV0GD0DoMKCX72Pkc1rzG1zMu/1HO8S/nFP64YdpqNFVr1M3F2sXgTckp3Fty+6ipr8X9xsDOguZ2/FztMxxdyIqBmjb1ep9DmnRR7yec2+veagwztvIFGVx2A26AfM50dryXjzZwsRoWURgN2FVgw6pDsOdTUcBRq38uTukcuJZE3XMcKBPzLDKmbj9glixiVyffaj45x86VfQ0gfYkMbElKFbJuwH5939ebq4XJLl+KvxKzACpAp1/c0HMjncexMRADRk4PoeCGQ1GEzFwh2nm21tZAos5oIbTFhBDA/5ByXnwzsb6rey082H/EmwM/u+3UCeF+k1+amBGbkzrFRp4qobcxp626UjXoh7TiPBwxl9kuOGt9fnAMgHR0+s62C3W/+6/Lmj12pJpEwSNcx2ykhcfq8uytUDBWSWsiD1sKzwiG0QDiBD8y0JZ+9TJyiRL9p8CwF5Sa3XMxunDR6knLTirortXN5CiDIHqT3oCouL73zSepNeoqDvWLBkV7t3XaRtWc9F1In348ke3VLNl8PMvQcad0GjGRI/aOeK/ocUcq378MehCMo2V7W8qRnG4Q/lqi84HfTCkCyksbhkAi1jhbhCXkS28CHAT7faP8Jck6m+gANUO4rJjJUTLJCie12AwMEqGtEI71gsc0De8oJNl/99lRBKfOeqYTvtoAcgNm5MpwNB3RRU4Zqe9KhCne7IgkyVH8UcvOGN4kA2Zf5NppvRdXI+Vsw6AwvdPQ67i8Ju0X6e/OkRhpkWRxtsV
 4XEx4k6P
 nQD8D2q6+UolGHP7rA3tBbb7OLi8UZC8gPBLgdRyQ5D3PdKSGu5QgCMO/P2R4RVVx26OZgaRc89eMk+B04gAj0SEOQXka9EYPlUPocdQrqsJaiUq/Oi+Ghz6Ipi+UlanIUV/G/qoYT1Naq1a1OecjAg3FV7bbh3lGaPqeniBGD6gZ3bzt0fmxnSel3oqj+DfMR02E9YpYG8TS0DXYGrZ8nl7fyQ43FBZF8NfPYlNGUbRBah8270K1STozxUICffq4JZoe7WiAEi/cqTUoRDTMeP/EQRHYs7wPSMKKodkmLsGZZdzA0gf/NaWMwWLxnaWaDMkqN0Zk4Kxl1wSOfwmYQvz4d8lbSyxKaB1dmMNTm3Ws/NeNp8fC7vQH0k4GIVoWzztE6BWsO87gCVC3bzt7eO4LTaXjTfKf/AEpRvBrYSLvJD2lRchLtjuZxQBjVNiZ3WKgeLUezifYXtM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Fill in the half of selection that emits candidates: a cursor over the
table, handing out the largest window that fits where it stands.

Two things bound the order at any point.  A huge page has to be naturally
aligned, so the cursor's own offset caps it -- at offset 4 nothing above
order 2 can start -- and the largest enabled order caps it too.

A window qualifies when enough of it is eligible: the scan's bits counted
over the window, against the max_ptes_none limit for that order.  One
that does not qualify drops to the next enabled order below, which need
not be half of it, since a sparse set of enabled sizes may skip several.
When no smaller order is left, the cursor steps over the region.

Only the scan's bitmap is read, so a clear bit is either a hole or a PTE
the scan disqualified.  Occupancy here means what a collapse could use,
not what is present.

Non-present PTEs the scan accepted are the exception.  They are counted
apart, in cc->scan_unmapped, and added back only for a PMD candidate,
which faults them in; a smaller window leaves them as holes, sub-PMD
collapse not reading swap.

The cursor advances at emission and never rewinds.  A round is collected
before it is run, so within a round every attempt is assumed to succeed.
Nothing here gives a refused region a second chance.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 126 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/collapse.h   |  10 ++++
 mm/khugepaged.c |   2 +-
 3 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 2da1f8ddcca8..258bb9cc32c5 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -1841,6 +1841,7 @@ static enum scan_result collapse_scan_table(struct vm_area_struct *vma,
 	if (result != SCAN_SUCCEED)
 		cc->select_orders &= ~BIT(HPAGE_PMD_ORDER);
 
+	cc->scan_unmapped = unmapped;
 	return result;
 }
 
@@ -1852,6 +1853,7 @@ static void collapse_anon_scan_init(struct collapse_control *cc)
 	nodes_clear(cc->alloc_nmask);
 
 	cc->select_orders = 0;
+	cc->scan_unmapped = 0;
 	cc->nr_collapsed = 0;
 }
 
@@ -1896,10 +1898,116 @@ collapse_scan_anon_pmd(struct vm_area_struct *vma, unsigned long start,
 	return cc->scan_refusal;
 }
 
+/*
+ * Selection cuts the table into candidate windows and feeds them to rounds.  A
+ * window is cut at the largest enabled order that fits and qualifies -- the PMD
+ * order, when the whole table qualified -- and a region that does not qualify is
+ * probed at the next enabled order below, which need not be half of it: a sparse
+ * set of enabled sizes may skip several.
+ *
+ * Only cc->eligible_ptes is read, so a clear bit is either a hole or a PTE the
+ * scan disqualified: a window's occupancy is what a collapse could use, not what
+ * is present.
+ */
+
+/*
+ * Largest order a window may be rooted at: the largest enabled one.
+ * select_orders is fixed for the table, and the caller checked it is not empty,
+ * so this is well-defined for the whole walk.
+ */
+static unsigned int collapse_root_order(struct collapse_control *cc)
+{
+	return __fls(cc->select_orders);
+}
+
+/*
+ * The next enabled order below @order, or 0 when there is none.  select_orders
+ * never carries an order below COLLAPSE_MIN_MTHP_ORDER -- THP_ORDERS_ALL_ANON
+ * masks orders 0 and 1 -- so __fls() honours that floor by itself.  Order 0 has
+ * no bits below it to mask and has to answer 0 outright: a walk that ascended
+ * instead would emit a window at an offset it is not aligned for.
+ */
+static unsigned int collapse_lower_order(struct collapse_control *cc,
+					 unsigned int order)
+{
+	unsigned long lower;
+
+	if (!order)
+		return 0;
+
+	lower = cc->select_orders & GENMASK(order - 1, 0);
+	return lower ? __fls(lower) : 0;
+}
+
 /* Point the selection cursor at [start, end) of the table, in PTE offsets */
 static void collapse_selection_init(struct collapse_control *cc,
 				    unsigned int start, unsigned int end)
 {
+	cc->select_start = start;
+	cc->select_end = end;
+	cc->select_offset = start;
+	cc->select_order = min(max_order_from_offset(start),
+			       collapse_root_order(cc));
+}
+
+/*
+ * Advance past the region [select_offset, select_offset + nr_ptes) and determine
+ * the highest order that can be attempted next.  Since huge pages must be
+ * naturally aligned, it is limited by the alignment of the new offset: after an
+ * order-2 mTHP at offset 0 the offset becomes 4, and __ffs(4) == 2, so the next
+ * attempt starts at order 2.
+ */
+static void collapse_selection_advance(struct collapse_control *cc,
+				       unsigned int nr_ptes)
+{
+	cc->select_offset += nr_ptes;
+	cc->select_order = min(max_order_from_offset(cc->select_offset),
+			       collapse_root_order(cc));
+}
+
+/*
+ * The window at the cursor did not qualify.  Drop to the next smaller enabled
+ * order over the same region, or -- when no smaller order remains -- give the
+ * region up and advance the cursor past it.
+ */
+static void collapse_selection_reject(struct collapse_control *cc)
+{
+	unsigned int lower = collapse_lower_order(cc, cc->select_order);
+
+	if (lower)
+		cc->select_order = lower;
+	else
+		collapse_selection_advance(cc, 1U << cc->select_order);
+}
+
+/* Is the window at @offset one a collapse of @order should be attempted on? */
+static bool collapse_window_eligible(struct collapse_control *cc,
+				     unsigned int offset, unsigned int order)
+{
+	unsigned int nr_ptes = 1U << order;
+	unsigned int max_ptes_none, nr_eligible_ptes;
+
+	if (!test_bit(order, &cc->select_orders))
+		return false;
+
+	/* The window must lie inside the scanned range */
+	if (offset < cc->select_start || offset + nr_ptes > cc->select_end)
+		return false;
+
+	max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
+	nr_eligible_ptes = bitmap_weight_from(cc->eligible_ptes, offset,
+					      offset + nr_ptes);
+
+	/*
+	 * Swap PTEs the scan accepted are counted in cc->scan_unmapped, not in
+	 * the bitmap.  collapse_faultin() reads them in for a PMD candidate, so
+	 * there they do become sources; a smaller window leaves them as holes,
+	 * sub-PMD collapse not faulting swap in.
+	 */
+	if (is_pmd_order(order))
+		nr_eligible_ptes += cc->scan_unmapped;
+
+	return nr_eligible_ptes >= nr_ptes - max_ptes_none;
 }
 
 /*
@@ -1913,6 +2021,24 @@ static void collapse_selection_init(struct collapse_control *cc,
 static bool collapse_next_candidate(struct collapse_control *cc,
 				    unsigned int *offset, unsigned int *order)
 {
+	while (cc->select_offset < cc->select_end) {
+		if (!collapse_window_eligible(cc, cc->select_offset,
+					      cc->select_order)) {
+			collapse_selection_reject(cc);
+			continue;
+		}
+
+		/*
+		 * The cursor advances past the window at emission: a round is
+		 * collected before it is run, so within a round every attempt is
+		 * assumed to succeed.
+		 */
+		*offset = cc->select_offset;
+		*order = cc->select_order;
+		collapse_selection_advance(cc, 1U << cc->select_order);
+		return true;
+	}
+
 	return false;
 }
 
diff --git a/mm/collapse.h b/mm/collapse.h
index 3256c45ee228..94b796271843 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -114,6 +114,15 @@ struct collapse_control {
 	/* Orders still worth attempting in the table being scanned */
 	unsigned long select_orders;
 
+	/* Non-present PTEs the scan accepted, which no bitmap bit marks */
+	unsigned int scan_unmapped;
+
+	/* Where selection has got to in the table, and at what order */
+	unsigned int select_start;
+	unsigned int select_end;
+	unsigned int select_offset;
+	unsigned int select_order;
+
 	/* PTEs collapsed in it so far */
 	unsigned int nr_collapsed;
 
@@ -166,6 +175,7 @@ enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
 		unsigned long address, pmd_t **pmd);
 int collapse_find_target_node(struct collapse_control *cc);
 bool collapse_scan_abort(int nid, struct collapse_control *cc);
+unsigned int max_order_from_offset(unsigned int offset);
 unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order);
 unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1244e161beae..c7c933e819e2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1426,7 +1426,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 }
 
 /* Return the highest naturally aligned order that fits at @offset within a PMD. */
-static unsigned int max_order_from_offset(unsigned int offset)
+unsigned int max_order_from_offset(unsigned int offset)
 {
 	if (offset == 0)
 		return HPAGE_PMD_ORDER;
-- 
2.54.0



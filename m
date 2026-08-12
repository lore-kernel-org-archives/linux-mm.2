Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361ADC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83926B0140; Wed, 12 Aug 2026 09:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5D66B0142; Wed, 12 Aug 2026 09:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBE86B0143; Wed, 12 Aug 2026 09:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90F716B0140
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38AB780373
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:38 +0000 (UTC)
X-FDA: 85092684516.28.6466D9E
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf29.hostedemail.com (Postfix) with ESMTP id 545F9120010
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="L w9IHym";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Th715Xjc;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeZs2UseJcgjssEuDoTxdhaLLmHeagTkQsJsYI528D8=;
	b=8ejYz7kIrukUfjdiy0fqMmrdkt/zuuty+Hd1+qSnED2czb+kBWLNs/PA05cnvB3xHf01UX
	OhaFJrlXtdny6Sw3wo38TUQIeit8r2/RNBf97MQ1+CRJ4fF8fOU6F1dKjXw9cJJ2kcA0HE
	ncXxy3OJeXSpfRVZUsedwPislPJFJkc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="L w9IHym";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Th715Xjc;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541016;
	b=ABtFY3f6b+qTd0ZaIqKj/wKEcyqVMEB4XgsjGAg1RXTAjfrObZ64W4RZNG0Iz+oh4g6Eon
	K0BZj+ZKMqco02gxds6gadTNMlFJDlBJI39baXOUze2SsH69xaaYjStxtBI55SbOXskA2H
	v8GxPj6REi+R1l4tf9zNxR+ss2r9ypo=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 2811E1D00165;
	Wed, 12 Aug 2026 09:23:35 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 12 Aug 2026 09:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541015; x=
	1786627415; bh=oeZs2UseJcgjssEuDoTxdhaLLmHeagTkQsJsYI528D8=; b=L
	w9IHymNYFUdCX1n6pCnEqiO+w5U8ENtkxk1NsACctkKVOn8ROw2eWYZjIw9TOVwG
	+dfYW0bzbX4DOXEusvKGcvRlhleMhuL+J+EOKTfHZeR7nAxTMqrwJEUh3iHz7Cqr
	vzB02XkWuy0tWTjw/wsF2H5Szvv8gOfle8oALZICrMVXO0DwACv521Wmh07dYItv
	D0lxxyl6TC2MlMaTMvCKBkX7OKSLYFVT2V1lGpuYx0rv/6Md5fj9l30eWzYqSAxx
	FqGeeS/u0o61GEPdCTeF/+f4Tvu7K/kxDH7rDsGRmTbbVjslCB6NC80yo1ceXogC
	omURnqsB7DfUeIfI9S/bQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541015; x=1786627415; bh=o
	eZs2UseJcgjssEuDoTxdhaLLmHeagTkQsJsYI528D8=; b=Th715XjcVgT36pmDR
	c/ZVhfKCOWpXTnv/BnxSATstrdYwEFdAJq1yGEnIFot48XQeKEO/sCHnhk010ml1
	2D+d+6mZTqgwL4c3OLXV0vBSDz71OSBYNpfHeCYClROrksn2zImTokxuJ8EZdeg7
	t49iuMGFYzNGS6bnQD8qtId2+bMGlrQ+slkRvP5SGCl7Lvdaj7gp/HGpAAglIyc0
	Kxw6QUd1Es389lIu+9ygAqguUbPCuqdmkdivxU6RIgBkeuSoaHAcmminYicYo/ct
	7pGVl1sy6fdH0hbBSp2NiWPbZqrTho2RN3h1ORytQFaozZUPZzRmzEWcnn7k2QnM
	LAqNg==
X-ME-Sender: <xms:1nN8ajYPdKTJEi86yCnYBrwNdfq2UMbgHafd-z_VUYtlZ3cE_5kgqQ>
    <xme:1nN8amVFB_MynEx3GfxTARXFHK0UUhZ1Ca91ikEZtFYh6bl_Zja5RC2xRydE76Jv1
    s0bHkr4-G0C177RAVayQp4I_Vj8n_yc6PzJhsVqftlTgDYQteMngYs>
X-ME-Received: <xmr:1nN8aueJStoH0bZaba0MFDkU-YpfCSlpTyPUsmJTUOAzCmRac8fQQBGGQGc>
X-ME-Proxy-Cause: dmFkZTGK88F9UMnXZ5YHCfZ+3CEyhDPNn2cwpG7gczg1QtUW3+KH6lRiOTrWgwtmC8SwM8
    lS9N2AAOkbX57R9oIGEGX/Y22a2ZgCAGYteUW+bA41LZ08JSUTSnxLP4aLeGJ+l2igRpiI
    z056Op0LI1NxVlka48nXFKSS8a/uwNZK+39708VFH13YHS1sNHrX5zvuU5299hb11Ao5H/
    zQrZEfdZM4G7c0rNyXZ30syjB6Y8P8LTAhLTAHwdc8i3T8CZWzvPOusg5fBb0jumhRSeE4
    e5clat+a+U2DXBe0wlr1aBcOwBQzkKo/UFV6TzMBSg5j9cF+ay7ufreZHSHrXPVD1XvofL
    E3n9Xy4pBFhY5FAp8tzoG+gD4sN0Aj2N6U89gzjxC+Hl3rn8uf6IbEup57zqPScVTNeItr
    VxEvT8CC31vyw7k0COC3c6WQDWNraJU38zlqU+WWaMZTjyYgjY7irO9mnzqjB3O39Cpa3X
    pgZb7Ph8QvjQEphfAJrapAxRDrIyLYuqlIBDlodTDvE7ZbmhIcdkELCsoBCuskCn/fKo/b
    xo+96fAwhS/eVvb3npy+RFRhX8jcWRVWhKXiQcvf92Wtn3CFIe0imOHRyiAbaV8tDUZ3aa
    piBPrd8f7E/y1QqP9LO1KYqgb78c+3sRd9aYJdq/llNs9MNerhnjsOW1xKLQ
X-ME-Proxy: <xmx:1nN8ajNScs5fLnlULNcJBKxmRFAoeqfL7IzW0TGStnNgChM5qYg2KA>
    <xmx:1nN8amIkU2ydmiu3_0brJhJw-0-uMolYl4P9zQU32_thcaoKcQBbZQ>
    <xmx:1nN8apmbt1dQ-hll8O87Oj6DeLyNUb6rxFNs4lhWn7TKaG4P4-B70Q>
    <xmx:1nN8albc9b1ayPF2iim3XF_Lg5VrCgjetiwZKeWV0IpnfoQmpY-HEg>
    <xmx:13N8au5WJJS0l0qaD3uu0sG4LDfX3IHAu4hM6lAN-xAOklrU6bv1yQzR>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:34 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v3 10/18] selftests/mm: add order-parameterized khugepaged collapse cases
Date: Wed, 12 Aug 2026 14:22:56 +0100
Message-ID: <20260812132304.199287-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 545F9120010
X-Rspamd-Server: rspam07
X-Stat-Signature: oubqjcqensgihkwjpi77gcqg3rgmowsd
X-HE-Tag: 1786541016-538067
X-HE-Meta: U2FsdGVkX19RJepThsGlfYA00IxLslCHm6FtI3NMsU9oVoNJwMH0f2rJyD45+t+SRIHdSDSSTDorXwFfYAmUp4lWKMAcEabYy7wA9LKiuRXH+QjTt8UU9WNfy/Z6mcxhJVXcvhwI8trEhL4BxfJCCos1cNkDulrq5ynkvKIMfJhXxCtm3+BOhBJvWsvIX+PETka7VHta4P/NMleGfe5Rjz4aGXZOiAXL2hzK2Gd+6K+gLAY903uI77DXyPW1fVFy4PdOVncKgaLCg7S3xHI8APDolmhY16JCaPRJYkGDeWujTGeITx6In4g+Vcdho7g4jnBCLPuM3R6vV2KrkSYnlrWHxRBsJPw1TlNxsS7BWHJZvKJIAx0O94rdGoWcNtk5DgH9/09OD2IZjmQ/FT5DntmdtfdG/uJTcrwPuu7HdNLN3hro8GF0bPe4Er98BVvK5oEOqeEj3W04NxIyjwT5ppSq6pv1Trne/4qVKbJ8aqCyOkYSRW64CwHvDZNyXrkJC+OUPx/5boW7fHsr7Z4HLdQJmbUJQsQC/63N4fSt1aWB5stNV2WT2T0A2lZfyZAokchoCK6HTpM4EncOiCBRxttsIx/JwIYXhVs1kNgQN0US4mpn2/FPUSesFMXBeatj5czwakKDYCXqAvbVSZsvCLYyN5kk4xZGZFLc9FoLgLsrLecQ671y0p6VOxpugV3PLSXVLm1pMrvfPAV2AWyDD7DVf8O9NDIhhV0Jl1jwK7GYyIvwQjQQNogLCkqEeoSjN7Xm2ihfWpavkotiSd4QNjqNjy8e+/BVvBPYyNYNmOo3FQtJrJQb951M+i50T7ztesLRTMd3VotLBTU76Q3ovXRh9unoSLkuv/6Wav3DuvBeFUdNE3HmqZn///Mm+OF/h5WRKYhRm4il9hu8BkMpOMCGb4bCyyknfg4qSm6OTTX+WQLcG08BR/dqx9Mo4ZDlVPwr/ThRWQzJ4obG+Qh
 jehPCuBN
 1CRPsnIJMZBt3Q018APQZOYKAtCnhrwOj5kUomkxwhTU0m9OD0uIuDzXyrsFvuokM/UTAZmo5OPSFGw2pwHhO5ouqAtqZOd1Qy0Ukk8auHd4UBTuCY0D59yPwB8tdoC4O2HPurZQLP5Qec9vjo8NkrI45i7v3DbTSDCD+nUKlN/yo59gR7sh/Ge+aEXJW7feorC2I7+X4tqX7zRjIe1AlCqJcAkW1LEwjXoSJGYTSzDv9nNj6hxYIf63X2YDvkQ+4vbmMBJIgCBP+6dO0X+TK6obWs0XnMJPaniiBjUhwxO9ddGRzfZ4glHf15KNQ0659oczd+eMb/vbFCvQ5IZ6frwZ0Ohci8uJ8q3ETCGTGeKKcVWPvBjwA8bZKWheKwYahG8rFyQLI7rHwMJ1gdozMzZBXsaO/Tt3GFF+YCLnkOE6GOaHBbZ2EBxL/I7xZ+HtTgbTK0h17lD0vWJAZqihF6jZCdEgirUYMQO4vlFD3Ze/Nng6qFUMQVgP8SlaAG1P5jAyk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The mthp_khugepaged context runs the generic cases at a sub-PMD order,
which answers how many folios of that order a range ends up with.  It
cannot say which window they are in, so "the populated window collapsed
and its neighbour did not" and "one window collapsed twice" look alike.

Add four cases that check each aligned window on its own, with the
folio-order helpers in vm_util:

- collapse_order_single_window: only the populated window collapses;
- collapse_order_partial_window: the default max_ptes_none lets a window
  with one present PTE collapse;
- collapse_order_max_ptes_none: with max_ptes_none=0 a full window
  collapses and one missing a page does not;
- collapse_order_mixed_sources: sources that are already large folios of
  a smaller order collapse to the target.

Each case faults its region before MADV_HUGEPAGE with only the target
order enabled, so the sources are order 0 and the result can only come
from khugepaged.  They wait for a full pass rather than for the result to
appear: without a completed pass, "not collapsed" and "not scanned yet"
are the same thing.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 230 ++++++++++++++++++++++++
 1 file changed, 230 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 8458cd2ff0df..7889ea1cd322 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -31,6 +31,8 @@ static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
 static int collapse_order;
+static int pagemap_fd = -1;
+static int kpageflags_fd = -1;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -1250,6 +1252,216 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/* Smallest order khugepaged will consider for mTHP collapse. */
+#define MIN_MTHP_ORDER 2
+
+/*
+ * Order-parameterized collapse cases for the mthp_khugepaged context.  What
+ * they add over the generic cases run under that context is per-window
+ * detection: which aligned window collapsed, and which of its neighbours did
+ * not.  check_huge() answers how many folios of the order the range holds,
+ * which cannot tell one window from another.
+ *
+ * The region is faulted before MADV_HUGEPAGE, and the target order is only
+ * enabled for madvise, so the sources are always order 0 and the collapse
+ * product can only have come from khugepaged.
+ */
+static size_t mthp_window_size(void)
+{
+	return page_size << collapse_order;
+}
+
+static void mthp_push_target_order(void)
+{
+	struct thp_settings settings = *thp_current_settings();
+	int i;
+
+	/*
+	 * The target order, for madvise only, and nothing else enabled: the
+	 * cases fault their region before MADV_HUGEPAGE, so the sources are
+	 * order 0 whatever -s asked the fault path for.  That matters for the
+	 * cases built around a hole -- a large source folio would fill it in
+	 * and the window would collapse after all.
+	 * collapse_order_mixed_sources enables the source order it wants on
+	 * top of this.
+	 */
+	settings.thp_enabled = THP_NEVER;
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	settings.hugepages[collapse_order].enabled = THP_MADVISE;
+	thp_push_settings(&settings);
+}
+
+static bool window_collapsed(void *p, size_t len)
+{
+	return is_range_backed_by_folio_orders(p, len, collapse_order,
+					       pagemap_fd, kpageflags_fd);
+}
+
+/* No aligned window in [p, p + len) is backed at the target order. */
+static bool window_not_collapsed(void *p, size_t len)
+{
+	size_t window = mthp_window_size();
+	char *addr = p;
+
+	for (; len >= window; addr += window, len -= window) {
+		if (window_collapsed(addr, window))
+			return false;
+	}
+	return true;
+}
+
+static bool khugepaged_wait_full_pass(void)
+{
+	/* Wait up to 30 seconds for the pass to complete. */
+	return khugepaged_full_pass(30);
+}
+
+static void collapse_order_single_window(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	size_t window = mthp_window_size();
+	void *p;
+
+	mthp_push_target_order();
+
+	p = ops->setup_area(1);
+	ops->fault(p, window, 2 * window);
+	if (!window_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse one fully populated window...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (window_collapsed(p + window, window) &&
+		 window_not_collapsed(p, window) &&
+		 window_not_collapsed(p + 2 * window,
+				      hpage_pmd_size - 2 * window))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, window, 2 * window);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_partial_window(struct collapse_context *c,
+					  struct mem_ops *ops)
+{
+	void *p;
+
+	mthp_push_target_order();
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, page_size);
+	if (!window_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse window with single PTE entry present...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (window_collapsed(p, mthp_window_size()))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, page_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_max_ptes_none(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	struct thp_settings settings;
+	size_t window = mthp_window_size();
+	void *p;
+
+	mthp_push_target_order();
+	settings = *thp_current_settings();
+	settings.khugepaged.max_ptes_none = 0;
+	thp_push_settings(&settings);
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, 2 * window - page_size);
+	if (!window_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse full window, not the one missing a page...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (window_collapsed(p, window) &&
+		 window_not_collapsed(p + window, window))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, 2 * window - page_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_mixed_sources(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	struct thp_settings settings;
+	void *p;
+
+	if (collapse_order <= MIN_MTHP_ORDER) {
+		ksft_test_result_skip("%s: no source order below target\n",
+				      __func__);
+		return;
+	}
+
+	mthp_push_target_order();
+
+	/* Fault the whole region as order-MIN_MTHP_ORDER folios. */
+	settings = *thp_current_settings();
+	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	thp_push_settings(&settings);
+	p = ops->setup_area(1);
+	ops->fault(p, 0, hpage_pmd_size);
+	thp_pop_settings();
+
+	/*
+	 * The order is enabled, but the allocator can still fall back under
+	 * fragmentation.  That leaves nothing to collapse from, which is the
+	 * machine's answer rather than a reason to end the run.
+	 */
+	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, MIN_MTHP_ORDER,
+					     pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("No order-%d sources to collapse...",
+			       MIN_MTHP_ORDER);
+		skip("Skip");
+		ops->cleanup_area(p, hpage_pmd_size);
+		thp_pop_settings();
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse region backed by smaller large folios...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (window_collapsed(p, hpage_pmd_size))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, hpage_pmd_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
@@ -1418,6 +1630,20 @@ int main(int argc, char **argv)
 
 	parse_test_type(argc, argv);
 
+	if (mthp_khugepaged_context &&
+	    !(thp_supported_orders() & (1UL << collapse_order)))
+		ksft_exit_skip("Order %d is not a supported anon THP order\n",
+			       collapse_order);
+
+	if (mthp_khugepaged_context) {
+		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+		if (pagemap_fd < 0)
+			ksft_exit_fail_perror("open(/proc/self/pagemap)");
+		kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+		if (kpageflags_fd < 0)
+			ksft_exit_fail_perror("open(/proc/kpageflags)");
+	}
+
 	setbuf(stdout, NULL);
 
 	/*
@@ -1480,6 +1706,10 @@ int main(int argc, char **argv)
 	TEST(collapse_empty, madvise_context, anon_ops);
 
 	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
+	TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
-- 
2.54.0



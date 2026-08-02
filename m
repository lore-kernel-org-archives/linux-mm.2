Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33589C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF0F6B0093; Sun,  2 Aug 2026 15:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA636B0095; Sun,  2 Aug 2026 15:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B546B0096; Sun,  2 Aug 2026 15:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F00896B0093
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E8278052B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:10 +0000 (UTC)
X-FDA: 85057378140.19.5130E32
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf20.hostedemail.com (Postfix) with ESMTP id 51CFE1C0007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=FXvE9qPS;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="C zh2r/Q";
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42Jk8anv09Ae+D5TcqeZWyKxnhTNFQk1HNvbrY4yTeM=;
	b=RnS+N4v/X2PAy8ByDackMXVicF4Y6ipV8SUItN4QkkC60/Wzq29YAP08a3Z6JXLkThObyr
	gjv/jxE8DJtZR6oN4+BWXBUHwf63td32lO7y3PsbWP5doYHxzpmeKLuYR6FXgL9dKtkEli
	wuTe1HAxYqRNkBOt96FdhlQk3mFhjRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700388;
	b=JUzzzqh4eefcSK7LJioHx1iN1w6i0jAHinETCmwOVdNXvUb3qwfpmJ+nRRfp4AzijOEGM7
	5U/u+Ty+FdTt+6IKsTLjZhwRQ3RQWWW0Gt7LZ8mJPGQGJsx9Rriy+NSd8NtaotmRbatXCg
	Pw7nZNWR9RNsc/vI+iNhfRxjVg5o8gc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=FXvE9qPS;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="C zh2r/Q";
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E10EB1400053;
	Sun,  2 Aug 2026 15:53:07 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sun, 02 Aug 2026 15:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1785700387; x=1785786787; bh=42Jk8anv09Ae+D5TcqeZWyKxnhTNFQk1
	HNvbrY4yTeM=; b=FXvE9qPS4gNJi6Ok/gHuf/7o0xspxI0WUkdVusjcSFEXNj+b
	28pPX9F0vM1KSfCXdUTSPJWUNrh7OTEwzjfHVJM85CODQ0RbgzDUpdt+IMwz5g11
	aiGpehNWNyShrz8r0MFbrKTxyd1z910hGJAwoS1yokxpMke/WttknjxdthY9xRrD
	43TifxNcPAuK+XHj6CzV1LeZKVP2Eow7xLXLx4NLaB4/rjJQzBBExqvcAq3CT8ui
	9IrfE6Zuf1BHfWR/WfQOYaq024zapFgL0SxAzXqwVRACgZ2VwmgkKsTVu3oOe8kW
	GEAUFcf7s18OURwU65SCTY+UE5WzuwaEVw9h5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785700387; x=
	1785786787; bh=42Jk8anv09Ae+D5TcqeZWyKxnhTNFQk1HNvbrY4yTeM=; b=C
	zh2r/QdDtG6XtCiiHkjqg3edJ0xn746ubXCkgvA+ClzatPMGvrWRBkUcHcQHotlG
	iZ/oQ3Mmyw2YNMjiga7mTzvpPBh8C5OFQx3sLmsxnhUu1XlPAxMKWJ9fgk2vM0IE
	qeBKUdCNlOsJDdx7MLUyEHSOGTQrP83PLeJcISOcL9QGetCIIRtPH9BDAAD6vSKC
	H19PLeG5oRSi+ETVts0PZEV2zrN28ev5zfFOO3u3FN0eAxGMWloeiCLQbnMHVf4N
	vlSuJNwzBwh2Cyo1jSo4oZIgX5z6qFM/xqYkE2ffd0NusfIfafstBgBpuS+9gmSq
	Uiy7yoItjPe9Nt2chg+uw==
X-ME-Sender: <xms:I6BvasJzK6gtv18qxDLl7kw9kF2-gP__WwE5MQChrwa-468vtwBjtA>
    <xme:I6Bvamo9FEIr7gyJ7bdm94eSWxL1LSo1n9uZxSI-Otj9uoJ0HCSeKxYWBp0B5ZTFP
    83o2k1F3h9uj_XIx_5EVIyCAUhNDxYp3KTLpBPx_TG_Nr_1_j081Tyo>
X-ME-Received: <xmr:I6Bvapr_qCGHEqNcK3_Zmt0Vy_QxxCVVd4-d6F9ZE1aSun90NgYyP_nzpGg>
X-ME-Proxy-Cause: dmFkZTFFI2e4v0VL62gQn4LBnevEk7hs7RPV0r834Y3gUTCorNoKUtwVAeDj7rz+NLSQhu
    y/OAVYT+Jiel/qs6SnenOZvG6g0/cBirKvBT04HwvsU8h7D4yYwa5SFmotLmYkPQwKQLoR
    XyoVa9k9cCWRGnBS8/iQFE4ExZ0v8G70T6sZm1EWsdaZBvTMj2GHQiHvKs8tPPQK8XgZ9j
    RKmuu8fzg0HU9Cb/JfQjtmfbnMGFW/DwOIP3fzuIoiDtK7qjVWTEWpHzYz7Wp/+2gMhckz
    XQqrN9Qeyr78NcH0CzwZM7Ax6TTOlUlNfoUZ9kxKI2Wss6eEBOi+d/VU1OXEnW0ohbmjTH
    BtqE1+cv2cteR2qhShD+uyo8H1448/28Y7fN7vaw1d/k8RZxzBZzzXX0a1nsjsDAzfrfmK
    yuKzABaar3AaDK8VUd8UPrs8rPEBN7UGpq4If0b8rbkWaMhC71CSIh+Rpau7p+4gP7Aeko
    FiLGM7yAPhClmaahdy56j3JK17Il2bcE8GxCr72ym1yCvVLvSnohSuK6jQ9H52vBjX+uBC
    314guuaTKgLAhbNOWky6B0t86FTmaLLPqpo2nOefoeO2a1W/vxWC/CTQnJVD73AYmpuc08
    arqjR5DJPZDNOUYpP1ps5M0Bl601AoeEEsoo44bOOOMa6O+vnT+oss/yBBjA
X-ME-Proxy: <xmx:I6BvasH3_XNJooHH1KSWT3QsR8h5QtcW-8awBpNIYJD072KViyudRQ>
    <xmx:I6BvaromZCiJ2WtRAHKALIl-X-UaamVedMPGSi5gaV_M143QUXh2dg>
    <xmx:I6Bvai3wH0NCw8NPyKUwlM4Jsq8zLJ_hcr3gsxBFNNwcQ32kkJzPyg>
    <xmx:I6Bvasspla1_UbZvoAj8X4i-WQ4lw5VW65VZeLB16XSKaZC6AunmcA>
    <xmx:I6BvajHsNQ52xPa4oG2wtDrtU6Y7kzWFKBY4sqcJd8hW3JjzPSgFCkEs>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:07 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 04/16] selftests/mm: add order-parameterized khugepaged collapse cases
Date: Sun,  2 Aug 2026 20:52:36 +0100
Message-ID: <20260802195254.1937477-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51CFE1C0007
X-Stat-Signature: dftuf8y1dqsscsctmcug8uiimgj4c4pu
X-Rspam-User: 
X-HE-Tag: 1785700388-180670
X-HE-Meta: U2FsdGVkX19d6DarTrOmCfm/i22RF4zoQGl1WxdsMDS0oYu+yLnPQY8mq75oR1Oyyz6DeoCANZTDeIQE6Tlk3RU+7By0uAy3a+a6lzDnsBqAWvXvBF/fKEv7XeS3QZKl6VI+Kuxz3QRdjeuiZfpFUXq1nC92A4FYDSgoam8VNNSSa9rbHsMSLkRR06QCr8g5/strO+Srqn54QWYJF7XjRbNw6i3xWuSYYRwR6xHbIndA4nlPojwPLEHleqLX3fnQ0xdij/40q3ZuKq7/i3NDim0sp6EBGu85yVFuG1l2hh6HOXCg2vCKbBl1a/yeZuQsrOe317C0lVNJkhV3kURkXVApYdAhs23a8quW1XCN28mUyPAq9Xw2Fvzo+c42nzvpmFfCw0nLXaoWbkWlHkW3E9rtl9piEecrxur6fghH2qKELdXRB4RFX43YipoR1bcMREBIPIaICTtbhwh/+JvImV/I2fNk1QhGLe7KLGGezAkoUwnBTRtrLnf9oskRC1FTqXFcLWMCkdRcEWJTklKWFrXvOymrkF04ocQYV+Rls6J+kEFu/GM37pc/IEnMJgZ25gs9Ud0aDyi/ClVaFCjTEQFiJKD2O1f5qZwoWnuM7+34KgUNkhc5bakqF2kiLfzyS/J9xxSKgCUBkrh53r0aw8/NoMDFgh/nB5PlkDuJysmPaQLTTy7PUgNSoXyOf1rDaD9F3AqmJhgcJHnKrsrXuwrbmHwWYAnCnnJRAXMyP64UsrYW3Fl7KAXKfuo+e1GUKwvC2U0jgZAchlvZXYp187x7oTeEJjP/zIq+XgehSAjez4MmnTr26cyvYtY7fSoEabN94KxVxfx5CcqyA2L4c3cOmxiZo2TUClcDWDyKpnj9WUA3DL2snNpF6kc6KCdL1+HvhJh/FxkBck0bkKEi37rfE15RmVslAlyRaPb2GSs2+YW0QO3nyyo/ULNFahUFmylYWccQt1mS3t8dBUW
 ckLcrfeD
 UpLZEqgkJ/UiA7WwyGG4STeTGlSaQGgh84uW4F7epOZ2sROH7i7CIOeyo5RS0DUIV3DxcayJwNF5rzKOF4o9SbbgOlQ/26wx8fJODCF9+1pqQ6PCH+jpNbs13Y5ICc5UMRy2jfl4s4VLG5qLFolkBwSgjkgFCiFl6fa57/W+8qhUUYe2p6vVtPwhjx4A0MQarNaJ8aqX7AGLxbOOKiZo4DnVPd0RSfZC8zEqeV89zY/p8gm5Mxrs/TYPMo/EJoI7gTcnvaFLWmfgMkK2kD6t23rtc42SxOZnjaqFPtgujf5Q3pYI0EVE6F6vDj66w1rG0K32vD9AWOMXTaM65tWm9vDvQ4GTH3UWtBy29fwLbf0o0JnWSMuBZFq80/FI5fGRzwo2vkMQG+kxg5lCTHThHKpmYf12LfiHPDoWfkNvpmszU4o552QPxODT9uZ0SGznN8+N5JN0/BoFDizGM/3wxDOR3lXe3f8h9sCjSGUua6mjYic8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

All khugepaged collapse cases are written against PMD collapse: the
regions, the thresholds and the detection (smaps AnonHugePages, which
only accounts PMD mappings) all assume the PMD-order product. The mTHP
collapse support merged in 7.2 has no functional selftest coverage.

Add an -o <order> mode running order-parameterized anon collapse cases
against khugepaged. The region is faulted to order 0 first (the target
order is "inherit" under enabled=madvise, so pre-MADV_HUGEPAGE faults
cannot produce large folios), then one full khugepaged pass is awaited
via the full_scans barrier, and results are detected per aligned
window with the vm_util folio-order helpers:

- collapse_order_full: a fully populated PTE table collapses to the
  target order across the range;
- collapse_order_single_window: only the populated window collapses,
  empty neighbours stay untouched;
- collapse_order_partial_window: default max_ptes_none permits
  collapse of a window with a single present PTE;
- collapse_order_max_ptes_none: with max_ptes_none=0, a full window
  collapses while one missing a single page must not.

-o accepts any order up to the PMD order. At the PMD order the cases
baseline the PMD collapse path with the same test text used for the
mTHP orders; single_window and max_ptes_none, which place a second
window beyond the one-hugepage area, have no room below the PMD and
skip there via skip_at_pmd_order(), while full and partial_window run
unchanged.

The default and -s modes are untouched. Passes on x86-64 4K (-o 2, 3,
5, 8) and arm64 64K (-o 5, the 2M contPTE case); the default PMD suite
is unchanged at 26/26.

collapse_order_mixed_sources is an order-parameterized case too: a
region faulted as smaller large folios collapses to the target
order (collapse accepts source folios of any order below the target).
It passes on the current kernel, so it rides here with the other order
cases.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c   | 289 +++++++++++++++++++++-
 tools/testing/selftests/mm/run_vmtests.sh |   2 +
 2 files changed, 289 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087..971e97a7330a 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -26,9 +26,13 @@
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
+static int hpage_pmd_order;
 static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
+static int anon_target_order;
+static int pagemap_fd = -1;
+static int kpageflags_fd = -1;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -1088,6 +1092,231 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * Order-parameterized collapse cases (-o <order>): khugepaged collapses
+ * 4K-faulted memory into folios of the given sub-PMD order. Detection is
+ * folio-based (vm_util), not smaps: AnonHugePages only accounts PMD
+ * mappings.
+ *
+ * The region is faulted before MADV_HUGEPAGE and the target order is
+ * configured "inherit" under enabled=madvise, so faults are always
+ * order 0 and the collapse product can only come from khugepaged.
+ */
+static size_t anon_order_size(void)
+{
+	return page_size << anon_target_order;
+}
+
+static bool range_collapsed(void *p, size_t len)
+{
+	return is_range_backed_by_folio_orders(p, len, anon_target_order,
+					       pagemap_fd, kpageflags_fd);
+}
+
+/* No aligned window in [p, p + len) is backed at the target order. */
+static bool range_not_collapsed(void *p, size_t len)
+{
+	size_t window = anon_order_size();
+	char *addr = p;
+
+	for (; len >= window; addr += window, len -= window) {
+		if (range_collapsed(addr, window))
+			return false;
+	}
+	return true;
+}
+
+/*
+ * Completion barrier: one full khugepaged pass that started after this
+ * call. Waiting for full_scans to advance by two guarantees it; a +1
+ * step might complete a pass that scanned our mm before the setup.
+ */
+static bool khugepaged_wait_full_pass(void)
+{
+	int full_scans = thp_read_num("khugepaged/full_scans") + 2;
+	int timeout = 60; /* 30 seconds */
+
+	while (timeout--) {
+		if (thp_read_num("khugepaged/full_scans") >= full_scans)
+			return true;
+		printf(".");
+		usleep(TICK);
+	}
+	return false;
+}
+
+/*
+ * Cases whose geometry needs a window strictly below the PMD skip at
+ * -o <PMD order>; the rest run there unchanged, baselining the legacy
+ * PMD engine with the same test text used for the mTHP orders.
+ */
+static bool skip_at_pmd_order(const char *name)
+{
+	if (anon_target_order < hpage_pmd_order)
+		return false;
+	ksft_test_result_skip("%s: needs a window below the PMD\n", name);
+	return true;
+}
+
+static void collapse_order_full(struct collapse_context *c, struct mem_ops *ops)
+{
+	void *p;
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, hpage_pmd_size);
+	if (!range_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse fully populated PTE table to target order...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (range_collapsed(p, hpage_pmd_size))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, hpage_pmd_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_single_window(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	size_t window = anon_order_size();
+	void *p;
+
+	if (skip_at_pmd_order(__func__))
+		return;
+
+	p = ops->setup_area(1);
+	ops->fault(p, window, 2 * window);
+	if (!range_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse one fully populated window...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (range_collapsed(p + window, window) &&
+		 range_not_collapsed(p, window) &&
+		 range_not_collapsed(p + 2 * window,
+				     hpage_pmd_size - 2 * window))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, window, 2 * window);
+	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_partial_window(struct collapse_context *c,
+					  struct mem_ops *ops)
+{
+	void *p;
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, page_size);
+	if (!range_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse window with single PTE entry present...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (range_collapsed(p, anon_order_size()))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, page_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+static void collapse_order_max_ptes_none(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	struct thp_settings settings = *thp_current_settings();
+	size_t window = anon_order_size();
+	void *p;
+
+	if (skip_at_pmd_order(__func__))
+		return;
+
+	settings.khugepaged.max_ptes_none = 0;
+	thp_push_settings(&settings);
+
+	p = ops->setup_area(1);
+	ops->fault(p, 0, 2 * window - page_size);
+	if (!range_not_collapsed(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse full window, not the one missing a page...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (range_collapsed(p, window) &&
+		 range_not_collapsed(p + window, window))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, 2 * window - page_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
+/* Smallest order khugepaged will consider for mTHP collapse. */
+#define MIN_MTHP_ORDER 2
+
+/*
+ * A region backed by large folios of a smaller order is a valid source
+ * for collapse to the target order:
+ * __collapse_huge_page_isolate() accepts any source folio of an order
+ * strictly below the candidate's.
+ */
+static void collapse_order_mixed_sources(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	struct thp_settings settings = *thp_current_settings();
+	void *p;
+
+	if (anon_target_order <= MIN_MTHP_ORDER) {
+		ksft_test_result_skip("%s: no source order below target\n",
+				      __func__);
+		return;
+	}
+
+	/* Fault the whole region as order-MIN_MTHP_ORDER folios. */
+	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	thp_push_settings(&settings);
+	p = ops->setup_area(1);
+	ops->fault(p, 0, hpage_pmd_size);
+	thp_pop_settings();
+
+	if (!is_range_backed_by_folio_orders(p, hpage_pmd_size, MIN_MTHP_ORDER,
+					     pagemap_fd, kpageflags_fd))
+		ksft_exit_fail_msg("Region not backed by order-%d folios after fault\n",
+				   MIN_MTHP_ORDER);
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse region backed by smaller large folios...");
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (range_collapsed(p, hpage_pmd_size))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, hpage_pmd_size);
+	ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
@@ -1103,6 +1332,9 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-h: This help message.\n");
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
+	fprintf(stderr,	"\t\t-o: collapse target order for khugepaged:anon.\n");
+	fprintf(stderr,	"\t\t    Runs the order-parameterized collapse cases instead\n");
+	fprintf(stderr,	"\t\t    of the PMD cases. Cannot be combined with -s.\n");
 	exit(1);
 }
 
@@ -1112,17 +1344,23 @@ static void parse_test_type(int argc, char **argv)
 	char *buf;
 	const char *token;
 
-	while ((opt = getopt(argc, argv, "s:h")) != -1) {
+	while ((opt = getopt(argc, argv, "s:o:h")) != -1) {
 		switch (opt) {
 		case 's':
 			anon_order = atoi(optarg);
 			break;
+		case 'o':
+			anon_target_order = atoi(optarg);
+			break;
 		case 'h':
 		default:
 			usage();
 		}
 	}
 
+	if (anon_target_order && anon_order)
+		usage();
+
 	argv += optind;
 	argc -= optind;
 
@@ -1207,7 +1445,6 @@ static int nr_test_cases;
 
 int main(int argc, char **argv)
 {
-	int hpage_pmd_order;
 	struct thp_settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
@@ -1244,6 +1481,13 @@ int main(int argc, char **argv)
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
+	if (anon_target_order &&
+	    !(thp_supported_orders() & (1UL << anon_target_order)))
+		ksft_exit_skip("Order %d is not a supported anon THP order\n",
+			       anon_target_order);
+	if (anon_target_order > hpage_pmd_order)
+		ksft_exit_fail_msg("-o takes at most the PMD order\n");
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
@@ -1253,9 +1497,49 @@ int main(int argc, char **argv)
 	default_settings.shmem_hugepages[hpage_pmd_order].enabled = SHMEM_INHERIT;
 	default_settings.shmem_hugepages[anon_order].enabled = SHMEM_ALWAYS;
 
+	if (anon_target_order) {
+		/*
+		 * Only the target order may produce large folios, and only
+		 * from khugepaged: "inherit" under enabled=madvise keeps
+		 * pre-MADV_HUGEPAGE faults at order 0.
+		 */
+		default_settings.hugepages[hpage_pmd_order].enabled = THP_NEVER;
+		default_settings.hugepages[anon_target_order].enabled = THP_INHERIT;
+		/*
+		 * Order-parameterized cases are driven strictly by the
+		 * khugepaged_full_pass() barrier, which wakes the daemon
+		 * itself. A long scan_sleep keeps khugepaged from
+		 * free-running between barrier steps, and a pages_to_scan
+		 * covering everything makes one wake complete one full
+		 * pass (the barrier's contract), so a run performs a
+		 * deterministic number of passes — what the stage A/B
+		 * trace comparisons rely on.
+		 */
+		default_settings.khugepaged.scan_sleep_millisecs = 60000;
+		default_settings.khugepaged.pages_to_scan = 1UL << 24;
+
+		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+		if (pagemap_fd < 0)
+			ksft_exit_fail_perror("open(\"/proc/self/pagemap\")");
+		kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+		if (kpageflags_fd < 0)
+			ksft_exit_skip("open(\"/proc/kpageflags\") requires root\n");
+	}
+
 	save_settings();
 	thp_push_settings(&default_settings);
 
+	if (anon_target_order) {
+		TEST(collapse_order_full, khugepaged_context, anon_ops);
+		TEST(collapse_order_single_window, khugepaged_context, anon_ops);
+		TEST(collapse_order_partial_window, khugepaged_context, anon_ops);
+		TEST(collapse_order_max_ptes_none, khugepaged_context, anon_ops);
+		TEST(collapse_order_mixed_sources, khugepaged_context, anon_ops);
+
+		ksft_set_plan(nr_test_cases);
+		goto run;
+	}
+
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, read_only_file_ops);
 	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
@@ -1336,6 +1620,7 @@ int main(int argc, char **argv)
 	ksft_set_plan(nr_test_cases + 1);
 
 	alloc_at_fault();
+run:
 	for (int i = 0; i < nr_test_cases; i++) {
 		struct test_case *t = &test_cases[i];
 
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8bf898b71350..6f42e35b5227 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -408,6 +408,8 @@ CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
 
+CATEGORY="thp" run_test ./khugepaged -o 2 khugepaged:anon
+
 CATEGORY="thp" run_test ./khugepaged all:shmem
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
-- 
2.54.0



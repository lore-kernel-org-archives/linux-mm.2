Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB99C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1C06B075B; Fri, 14 Aug 2026 21:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA926B075D; Fri, 14 Aug 2026 21:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9E46B075E; Fri, 14 Aug 2026 21:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D186D6B075B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51C4B1402BE
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:30 +0000 (UTC)
X-FDA: 85101846900.18.4DD9DB4
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6E49C20006
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b /g+kqZ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RhKRP1ko;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TndxdCltkGuvzZg0b5nL1NfZtt1dBi/ccjiEs/49rKo=;
	b=I4+CBJRSOkFM3DelhetHlTJ15WsEcgCli2kZXWdulP6CCAQyUlddwtfWV96tjx12rA9AtL
	U6Fqvbo0TsS8Y80ejki63K0oz98qLS3hd7DWTA+j6U4QkbwkGrocOYe72U268t9vmkchek
	OAD5Vl2kmJW8epzluzs4/l/imdTMyaw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b /g+kqZ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RhKRP1ko;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759168;
	b=61sEwEGR+g84y0f6M+mDN0TcRMLDdleMnQINsbKosB2pP/7yV7jPdJUNias4dC85IO1Z2Z
	4p8YxCXB0ppygBsqgDpfv6OEwrMsBCCTnAflgJa+OF5k1ilaUVJyBMJlqm2lZMGEmJn1aZ
	4HqA0xSu5CEiLigENhn1W/BucLfaLyM=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 053DAEC0222;
	Fri, 14 Aug 2026 21:59:28 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 14 Aug 2026 21:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759168; x=
	1786845568; bh=TndxdCltkGuvzZg0b5nL1NfZtt1dBi/ccjiEs/49rKo=; b=b
	/g+kqZmdyT/Fnm90OChIX7THylkcZdL5RzQwijJKaZewSVJuIUdkxYulJNaw5kFj
	Zwc/lC0J59tY/+pMlMD4DobTXP64Nb5MJB+veuzukFtSp1UGpKB/tpwOT1EI9GJu
	Jh2YyWFJ/jdRGlLaxSeSoFOBUm9yyalSOsPEr94i8Pmu27Wb2g36N5Za2/sn1Jc7
	sgvqrpqL1IY++6wfYetxVhdV/8pYMKWwChmhzaucgj88jzH1d4fYm27H1EiEkeuL
	5Tj50eh8rMrG+7RF1yK4yXjgZpvVxlPj429Sq9Glj8tzIZ+mDXmzBhHsVy7nQm7t
	aHR3oGJhgik+tp6ObZ4Eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759168; x=1786845568; bh=T
	ndxdCltkGuvzZg0b5nL1NfZtt1dBi/ccjiEs/49rKo=; b=RhKRP1koDI+ptIxl3
	HGLgxJxt9j3omxH9cRDrfouD5bJwupqLsPOl83WrtPBwtCFXZy58Tz7ibrLlgcKY
	/9CRyrwf3nOKQxxXsY0zWzzoE0cF/ZG+pxGr/+nk4/NNRCT+oc1RlEr63EWoNVZ7
	ndD4VnzTj9Q1/8EGF6chW0Qr0/s/oXRXaDKRscwVAUBUJHIu36COh/z3Nf/ovIuu
	pqfXrhF/b1UVOdJwGjuINmyBp9GNF7g/OyiGjK6ziB6F+GQZPXP1+sZ2Cyks8HO2
	DDl26DeNPyHMMqpAI2k1iE/AsrkGlDD8w9aZexMT6GqgZ+t49libXTx0mTitVJh3
	JbZkg==
X-ME-Sender: <xms:_8d_asSkhv24EC3NKuBHRT5jYpMemo7n6qHhVJNXVdWjJLjkO7sdmQ>
    <xme:_8d_atuGNpUwuqR5pZtxn_xS7aqjkBrqjfxTys5q7qTYbY0EfJN5srTD95yhdwtEb
    eiUB9srD3EMu0VWaaOvr-nyKAUF8BgkohJlKRV3eJgpAIUNv3--yXc>
X-ME-Received: <xmr:_8d_aiVtAQoD3_zH6vuTl3U_4T1zj8g9C9wPtLxRQr8pSL2eoBCmdXQ3elw>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1UQh
    NZgwgKpraJQ4GfA8YlvrMbphan98J2x248uA7+GQJDmU5vuQuFfP9TqLssry0XavFL6pSe
    CSbzkCGUFIj/OQN8jsfYXJAUYAFsWIpI2kcVV/xHNSdtuebZ+h4xBojLYlydWLCcjiyZci
    nHPuSmfGs/mzRGIfDM/mxAj55kilgC8yhXvrJHezys3fagfeVEqBfLZdTM15LcTq09UZz5
    qu+H3Ov+ZvdmgtJ7488deEr22TLks+7nZ6eYeFdgP868jPPfsXQmzQ5WLYsRKN51XmETcJ
    1gMxzmWboYjDOFCJtnCipj1RCiFNNbyKWTOyNN1WFB+zaT8yhIzXuN7inBrQ
X-ME-Proxy: <xmx:_8d_apnHorALe35Ci_ae7e_boqJ4-NnufGzsN-PMxO0_2fir2M8e8A>
    <xmx:_8d_atDEdvLBou0-jSWxY_DWuSG1kSLnbwKNgB6EfHDurC9wFqqlzg>
    <xmx:_8d_am--bcCT16_GNv6nZHnPJfz0MsygCV1Ndxks56oPbvy-pnLxXQ>
    <xmx:_8d_anT1FqgzBqt0g1MybiFvl9-8zeXJCOeiAnq7RAC2uq-bij02Ng>
    <xmx:AMh_as3TXoA00QmwcOkVOQfMzmg1RlAX_5ec-TxfOgDDuL-tTyWvoxQN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:27 -0400 (EDT)
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
Subject: [PATCH v4 11/19] selftests/mm: add order-parameterized khugepaged collapse cases
Date: Sat, 15 Aug 2026 02:58:53 +0100
Message-ID: <20260815015901.1236937-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rg987ftogxifkhsqsidr14b4jmscmxnk
X-Rspamd-Queue-Id: 6E49C20006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786759168-315248
X-HE-Meta: U2FsdGVkX1+vaKqsFI4N2w9o3MI/+T2va1Oy31rmyG6TQ66wmKfroiU9t6V/Oxkf6qcd4OXPLFoGRmcTa2FKWqbqldeupCuhSfPBTZuM0dHvTg1Mlnh59XqNm/xm4JhSFONQFaXHDIwz2EEz0AB/m+Ir4Gbn48vPqjXjKq+DDmW9yzseUMNz/JdgrNFhw3nsK6S4U5Z8vnaETR8MJ7eogA2Bly9vul+CgJF5q+MuzKUXs3TP5gFMxOCuV9gepb/oUMYA5QquX1fnH+VAbnMSwfvFjB1wNXk/thSPrDdo2gZOtUY72oqYi2P1i54bax1XOo7iQYPr6Z+RIE34O1zkpMpcY8cMxv6/AA5UyArbSrYcEhH1DoGV0Hc3y+xMg+4fUMTYdQtQxYDfsG3wQXHf9JmiWUsZmCoKD8sk8pz2ceDhc+gHHIovRXklSLlNZIok65tWcw1t8eP5HMPTGF8Ry7Bwc3PX2EEFtLpiajwZDrGlWajsf/WYcTDJkSyEFMW0jObaRIlodQCqDgS1RxcIJsp/XlBvNVqxs0kUZYHOLNGEhU17Go7/gdXc240hRvEz6Cg7nsvSryQ9Jt1cZhIH6gkJAgXpJWvGe0JAv7IhMuHHQJPROCTPXLNWAJntsaAYZRrzTWl3+FJI2Xg8MIKI6Pg9cUdq/MhA0oplzRyO5UWDcZU9ZlCbTIbWyVblz3f5n3Cp/XkuzuYwkQ/gEPvw5by/ss251Hmh1ds+NOeJ1TPVP/Ue3j5Y82HrUBwERBTydNnYnIiOBJDVyKIY2MzHUkQhAXsODKhDOQL5pTGo0AHy7iGFY0+0q54ibAnRGdI8XcPv10fBLa8HMNmO9A7C7OSKmeF8OrEpSxpRsYjIljdFuc07z3jR/QBaS0KaNv3mwC6owuTIVj9AWU56pF6hfwg4PxeRNPw3a4QsJzZz5rUCLabLN1WmwYz9TB5zYuChz0/6IXR6q3WldyxcJDr
 ifS/fP6i
 AclAaZ2xpmrILx46N7jIPmZ5jSX/fcNLAuItWKXf9Z1ub84wZvaCyRGVd0DalwqsJvbTV+z49wRV3vd0CJMV9O9UazVaSUeWOA00+y612vl/4YD2njJfhv8wkdc3l4pwucgzivgKHZ5RQrwi1awyGz6eO11tzNeeACDBOVkpiKKf1BTjo3sARebTlNlg1U8g313mqKnmETGkiatbW5Ylhk1BIZPGTXvJoKCU0nOBCV15cFLjJClAkFr4i4r7xJoiMkqpVwPAbWuwVGHP8rrL9ElUOZpRmIwaWg6wa2RFv59AV5+1JlRoP6kyz/bBPiQo7TKaUVSGDE8G4loXF6nypmujduwGxJt6mDs9AI23HlGA25f9nB45whLWHMMQv3S3phjHiTGVE6FUcjip9t/5lf+bGEwCMki0F18O/4DlN88jc86ln4Ruz73sWAkvEgoDOXQLn93eJITcHwk/pCBpDXjwag+k2dmOVT52QB4PWsSH9FNuzV3AZkBzi4sZjCEduzn7A
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

- collapse_order_single_window(): only the populated window collapses;
- collapse_order_partial_window(): the default max_ptes_none lets a window
  with one present PTE collapse;
- collapse_order_max_ptes_none(): with max_ptes_none=0 a full window
  collapses and one missing a page does not;
- collapse_order_mixed_sources(): sources that are already large folios of
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
index 0008862e7cbc..0489967d6ee0 100644
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
@@ -1227,6 +1229,216 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
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
@@ -1395,6 +1607,20 @@ int main(int argc, char **argv)
 
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
@@ -1450,6 +1676,10 @@ int main(int argc, char **argv)
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27363C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F756B08B1; Sun, 16 Aug 2026 18:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19526B08B3; Sun, 16 Aug 2026 18:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9F86B08B4; Sun, 16 Aug 2026 18:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC4A6B08B1
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BF5D805EB
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:54 +0000 (UTC)
X-FDA: 85108621668.09.2CBAA77
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B03440008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="x A337mv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QfjNs5uP;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920472;
	b=2OxsVVyOBai6L2NVbddurW12yHrpA7AdOaxUMEUd2msKDfjIZS9C0oSaaEzfx2sAeCWC7f
	Ik6PJZDuFUGI/3jBKy7YtEExRBMuz+uRNOwuTVJXHn/absoi64os6J6pK3TMPUnZ81h3iY
	p4wHVUwZ6xl51S2jjcnoFitcp2BIAuc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="x A337mv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QfjNs5uP;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHV+00xH9B3bJYx8y5slE3mzGKqkEhVlu1wRFthp3Pk=;
	b=P1mCflF8emHZOR7XsXHQ2RDXk8u1uvKsaonqSg/wzSRlu+oMVNSiFf40fhPj/77NqN84+K
	1qyFJOBT5xkVJeXQeafUt2+/MqqH6o/mOIVFzvIuwL8Axdt4NyU+QoIjeVPHu4XJfwjtzL
	Mv7B1sRSZYBxAy6KqolT5aX0CgBD9Io=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3103814000EE;
	Sun, 16 Aug 2026 18:47:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sun, 16 Aug 2026 18:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920472; x=
	1787006872; bh=wHV+00xH9B3bJYx8y5slE3mzGKqkEhVlu1wRFthp3Pk=; b=x
	A337mvyUFlpppzBdiF3Cu5k9EWiW/mPwjKlFQ/EXtIodTzvnUTAOUv3VnRXvYjcP
	BvsI78mXPc70LuodC4qj7bM30YcVCzUF6bWD25/7lIJKsC/SxkFTfrbAyhixXe/a
	Ot2cgLPAViVXFX20f1ru0+uCEaCqC272zU0ifxB51M0YvHmHo6xZiuHUCJgaHFop
	sNiaEmjnxlTqfqW1yUJj6/pkllSKYYaoyyXsWDIaZ6i7iNKsQrvVATmoqc9Pqwsg
	nfy1mTw7sQCJFJS+XFYlzKSlJqzQofUcHkgoKkMpwRYgrpDu20KHTAbDPusrYQOD
	WLY8l/lRq1E+tcEixhsuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920472; x=1787006872; bh=w
	HV+00xH9B3bJYx8y5slE3mzGKqkEhVlu1wRFthp3Pk=; b=QfjNs5uPIoaSLCjY4
	UNvENcFHjTNOENXnBPqTi+RNc22z55HCrvzacXE7SByYPz/otrYquY5kNhc9W/3g
	LJKZRjgZmIW3rhS35U/WAqh93TYt/66eol9QOdQmjq9k275DoFipa+J8BMQSSkmp
	uYPcyX7FoE3dxI715BbSY+NfHhll5cGsXZF4Baj2Eu7idCmmIGSdXfquxh3juO5Y
	u10RldDwrSLco3n7O23TY902qashNBNAUBQi18VDEWR3xNFy+jWdJHukqh+svl2R
	0Q+F820OiBKJJYrzAvITwog2ofMeMp2mGGznk4AB5awQjF9JUJ9I7O0pSSD433cS
	r2H9g==
X-ME-Sender: <xms:Fz6CaoZgiCDc1KxOay93nBsy4Osg8ZhCu9GhNZqmCXV2vUtn2ke9kQ>
    <xme:Fz6CaouyxFpKBMt1J_FT6745AkY3cxXGAUKPK5Tfgh4jznvS0Kd_Jfuo2XvXdAgud
    EC1UPc25YeSFmlx56oRZvCEK50oWmJSyEQ4plSMGJA8ZHGEJ_KXGBz1>
X-ME-Received: <xmr:Fz6CavDeGt0nJRM1iU7maNNyHJtk2gElrZGw9egA19wxGZSNE6uErJd3ohQ>
X-ME-Proxy-Cause: dmFkZTFt7uwKlsd4UyzlmYX1bnlzO4+qp5TmvoTS/qzkFKfMuj25xYssUPl6UU5Ie9xRba
    Y0bWuaC/AePVMhqrkCnU3j3fo4+kQ4lrNr0qcDw4ZM2xDmZI+m2r8oZbGDZU/DcLlRMJvk
    pxa8BemzxDXpf0p5hqW+oOweEwIQBvnr/hc1O3uCrLqxLkUCX+QMvT/AmKStBz4XcOBl17
    ynvfoFkCi5Qu6ZndF8QgBKMwimBrechIaqu56LTRaFtWn2N2FSoSPFDDGPAClh8o3Wii3h
    WmXtU4UIpdlwyanZt6DS7CEKxM1G2yBGNUvAI/9KSggaAyLfyuWlS9a0iep84iGUQaZXfq
    knD0n9YA/kWmvfl0Wjb8E/Beu3ua4NshP/Nio/tZ6O8p5iMb+wpx4YBhk175j5jhIoNquf
    +gH+mFtvZJEmhVHsfKOwvOI/Zqd9dLt3FKSCAdmKnioYMErInfqEm+HllRAv8ksF/n6S5S
    h2uR4Bt/+ZJoTA+GRWlNvAH0+HzPvPGFqXohUpm2Y5V9P1mXIEgx/+CO6eALiZ20+Mpnd1
    O0fqm0rJ2cvqo0NujMKgCoRTnm8xRyygGCtnH8y5EQi/fGzr2AjM3K+VHQ7HUZbO016+tv
    bw5ebY3O4xa6hlnqtSatzZA1NE7UEOHzGO6lgunGBISbTEBpHkcnlEiy4S+w
X-ME-Proxy: <xmx:Fz6CavNuicul1hB7acVRkWI-FSMEUDenG3hIg6ni5a9JljXLb7NeyQ>
    <xmx:Fz6Cap7QlyTSrmQOlcBYGIe8F7bYZ6vbjlzjedSZDzFRHKABd8Ea6A>
    <xmx:Fz6Cap3lul_7Ir028YdmawBxWM8F9jt4sEs9abx7frYUMAieWlq87w>
    <xmx:Fz6CaoomY9yx_yWOP-HFjrcgA4La4oDeGUEkDPml4LOLzLxyqpJF5Q>
    <xmx:GD6Case2J7iIxkQ6smxyjic-RGnxsxJv7nQtrZsKbjwvALgygkwA4Ngm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:51 -0400 (EDT)
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
Subject: [RFC PATCH 51/57] selftests/mm: cover collapse inside a sub-PMD VMA
Date: Sun, 16 Aug 2026 23:46:03 +0100
Message-ID: <20260816224609.308019-52-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B03440008
X-Rspam-User: 
X-Stat-Signature: 1tfisjgzwesubfxordjbr7oaaew4z46j
X-Rspamd-Server: rspam06
X-HE-Tag: 1786920472-137905
X-HE-Meta: U2FsdGVkX19LRPDx8ys3CY58NhHg8a5S2+mnjstY57ayUAizMacAymg736QTXxpNikuUVGK9c9dIlJHjtfOVn5PtTXxZGj549rJoLLtSzjHlzyFxwuFplUSBAaikssjhvxscrRw1cvs/5pxiYZTwACDiKsenSgUnoVxwxWv3T/xL2D3/s61/lSKXcvf+HI2Skx0HjVqXlJdcUOI4EafhjrCrbWMkTPMsq0nbK/zjBAeHDNdX8wv3mMtPDEeDcx6zWpg27bKjCj2e1VsHIUyiuLmGjwH7WoCgy6wYnAjJ6yrWHNLQlU9ISBsWDAtdfVsUNYHyXsGP4+j6FD8waNcc4UkRHEga1J0/uXCLu3IbkXHTBuUCT+joDzVCIXI9fNCKSg7/1O/12s/YKSzey08NMqReoxaHBqMl7LbDC1jcgqZQ2Sl7uiTgDD+IrIs8CbPCdLW8RDgax6vVIOn9u5S14p3vyLEIQHuoHwAVarrL4JTeDFSczxpUojmxCn/B43iSc49eaWPGypSUB6MxaMyvvx+wcqIb1lkkQQNhkTusJ32suOY9lXiFBb8LqTMM2IrtOh/G2QTyT2r62uc4jcqoZb/twPD017bd9f7iQagj/teCxWDPqNQVf9gKrWlQ2qJ1NemsNp9fh8QVUMXFtGKZal9leOU72pnR+vanpTVr+DwLS+eVfkipcOrvP6lWTFWx0WLEwfX8B8cGSCj5qT3frEg1HwASyZrNCaC3rkBwZfT+Oyq0cL26NYmTr2JJrn70Ukk1CGv/1u7BhBMzm8qoOoPT4Ki78QDsGKA0Ug8b+0W/5tWO/FcsdtSV5kl9PaKWLtD0eJSCvynqT6O7e23D1tftDj1Y/KieuI3UOCfifLkcqqEewS8BlLnvztNA7U7v87H9yG6Yyv+WqVvWosK6w+AaudIX4TdJ9QOkcJEgsGNxzh0pRDzcvayHZe0ZVe1NHz5iHqnwSnc06hYJiJ+
 W7KvrH8t
 cEjnNaytSzd9vffK2nRI2ckZZ45/dLEkRzRj0P/dKUJPB5gbV9TI8FsJDN7+qvruvm4EEFr3QbfEBoIRHjCb+bTo+kwiwkShsf1SLNHbkZ+tKfPJlMHFOLSkSCpWtfWyzlquaXCxy6qD7XG4C843IDSeI3Jt/vasQiR8q1y4klQOwkspQtXZSE0t6H0fnkl5MuXHoL7bCEAfGpHqDLmr6rhDhWv6G7Mvk+mVHgaCdaD/DsyXqkWw69P8Z0rt8s2QWQ+bTb8ZHmKBNrS/XkcJTvJE1miXsYFSn300w8ca8oD6VnXRWarpt3zBtQ93n0HFNVTfHOq67mvWjoFuBjPkB6VG5XI9I6oSVvT8v2kx2xbcU9MirFp69PGGD/x3G3mVbxs8NAZq6x0MDBqZEQIbNn//ieckKcovpjTWvOx7Alr4HmF+9ueu8RxeQuvY7MLviatN0qKInry6LObU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The new engine can collapse an mTHP inside a VMA smaller than a PMD.  The
old mechanism could not: its coverage was rooted at whole PMD-aligned
spans, so a VMA that could not hold one was passed over however many
mTHP-sized windows it held.  On arm64 with 64K pages, where a PMD is 512M,
that was every VMA below 512M.

Nothing covers that, so add two cases:

 - a VMA of exactly one window, the smallest thing that can be collapsed
   at all;
 - a VMA of several windows, which also walks from one window to the next
   inside a single VMA.

The second takes as many windows as fit in half a table.  At the order
just below the PMD order two windows are already a whole table, so there
is no room for several and the case skips.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 65 +++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 172e7307eeee..85f138cfb9b2 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1536,6 +1536,69 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * A VMA smaller than a PMD is a valid collapse target, so long as it holds a
+ * naturally aligned window of the target order.  This is the case khugepaged
+ * used to pass over entirely, its coverage being rooted at whole PMD-aligned
+ * spans, which on arm64 with 64K pages meant every VMA below 512M.
+ */
+static void __collapse_order_sub_pmd_vma(struct collapse_context *c,
+					 struct mem_ops *ops, int nr_windows,
+					 const char *name)
+{
+	size_t size = nr_windows * mthp_window_size();
+	void *p;
+
+	mthp_push_target_order();
+
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (p != BASE_ADDR)
+		ksft_exit_fail_msg("Failed to allocate VMA at %p\n", BASE_ADDR);
+
+	fill_memory(p, 0, size);
+	if (!window_not_collapsed(p, size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	madvise(p, size, MADV_HUGEPAGE);
+	ksft_print_msg("Collapse inside a sub-PMD VMA (%d windows)...",
+		       nr_windows);
+	if (!khugepaged_wait_full_pass())
+		fail("Timeout");
+	else if (window_collapsed(p, size))
+		success("OK");
+	else
+		fail("Fail");
+
+	validate_memory(p, 0, size);
+	munmap(p, size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", name);
+}
+
+static void collapse_order_sub_pmd_vma(struct collapse_context *c,
+				       struct mem_ops *ops)
+{
+	__collapse_order_sub_pmd_vma(c, ops, 1, __func__);
+}
+
+static void collapse_order_sub_pmd_range(struct collapse_context *c,
+					 struct mem_ops *ops)
+{
+	size_t window = mthp_window_size();
+	int nr_windows = 16;
+
+	while (nr_windows > 1 && nr_windows * window > hpage_pmd_size / 2)
+		nr_windows /= 2;
+
+	if (nr_windows == 1) {
+		ksft_test_result_skip("%s: no room for multiple windows below the PMD\n",
+				      __func__);
+		return;
+	}
+	__collapse_order_sub_pmd_vma(c, ops, nr_windows, __func__);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
@@ -1823,6 +1886,8 @@ int main(int argc, char **argv)
 		TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_sub_pmd_vma, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_sub_pmd_range, mthp_khugepaged_context, anon_ops);
 	}
 
 	TEST(collapse_full, madvise_context, anon_ops);
-- 
2.54.0



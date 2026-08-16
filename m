Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FC8C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BA036B08BC; Sun, 16 Aug 2026 18:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D066B08BD; Sun, 16 Aug 2026 18:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C326B08BE; Sun, 16 Aug 2026 18:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B69AF6B08BC
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:48:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3AD634042E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:48:03 +0000 (UTC)
X-FDA: 85108622046.22.9677930
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B63C1C0006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:48:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q 1nl18j";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HBZrNw5X;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920481;
	b=0/3TbkjifNC9UjOBFX9GDn/L9fb1gOwA9bcQZPzy38RWIZatZDbXEgowvTPxRQ+TwuO+Hh
	MDy1WdjRkglYpsDIAq7LJsraDYvPGGvnboDiybWfR8ULN6WIhj1PLI+vbOjvyKjbc5pi1I
	ZcsdtQufPei8BguBAnml/DEZ2tIq6K0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q 1nl18j";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HBZrNw5X;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxeIcugRbXVZfwL3UIFb4N2+J7ON7LziwuBbRMyDD8k=;
	b=7sWNXOosiUqyA0VKlE37hDcyQSwjVOr35TEYJyjG1IKSiecRZ4IpijEVCniORiVH0IVfVE
	RedNVmyO33iaRyD8xzAcv2M3UBWY9V3pvF0LluOM1gbLJedzKyirEWLbnaUNZcI9wdhdEh
	DAi2xdKd+quRwcs5Zg1wo4k3cjY/s1E=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 080F7EC0242;
	Sun, 16 Aug 2026 18:48:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sun, 16 Aug 2026 18:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920481; x=
	1787006881; bh=GxeIcugRbXVZfwL3UIFb4N2+J7ON7LziwuBbRMyDD8k=; b=Q
	1nl18jyTLYzI3yx4j+jwVY/KO10w2lM3QYtsyjfOG4YOYBwTTnXPm4LRNOpGJ7DC
	dmKxYGXrkLCioU5z597fuaWe1KK1SoBHdOqe8jVVxx8MR5EmpfiZNAoZN4ptk6Do
	AKXYSDxDlff8PElQJPNGo9Gwn5a5iZywwlOUcAyZ4qnWz5NmpDoicDuH9UgfEJKu
	oiDVD5rHzcOmcKWYCWbFK1KMpMgUEKeMjzMZzKOtq5veaoK8uWxWeGfaDkyJ99Bt
	eGtKMBK+kMBbdqMD4Gydwilbq39tES6G7BP86WARBy1JZkAP/jnsRdituYma7+ac
	lvecsLUJu69i55sDnPcPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920481; x=1787006881; bh=G
	xeIcugRbXVZfwL3UIFb4N2+J7ON7LziwuBbRMyDD8k=; b=HBZrNw5XGXWsoSjY/
	l2Ty9l7Y2HQdxrIGH/GmBuDYsahOR7E3ZhJ7jrSBaXi6PaevxI/Qf6bG5rxg+k3K
	3UvOZ5FlVYhUKt8uwxUk/RSSKVXcVEz01RWIOyi1e2oSV9DwG6jdLF4CFvyFXKGf
	fiOCfCaV0iuAw9DbMeMee4rZHJ79Do9HuXLHLTBAzscPu8eXBw+dHBbSq+8GQj8q
	5PqkmoLrGd3iwwReLQvYbgkfL1D5f+nq/be1sa9A8Fwi/pdDNVC5hAkCmeOVJ2wl
	iC4dGym4EQV4Gf/TD9kygnf/BmERNW97vZnmtxLZufRwGB+cbK2zMGe+dliAX3uP
	bo9ug==
X-ME-Sender: <xms:ID6CarHNVqrH9pjbuZMemB1OZ7N0sW0SU1Q2w0-xArCBHW-Y9HwAbA>
    <xme:ID6CatrPYWsFCsTDM3-_-Ugq035N_JxSd09WFHjuZC9D7pkv_Rf4mSU64BmeEo6Of
    xv1vNg8vwai6kCey5_29XogplG825zsUiFlf-ybSLtMigWTth_QOd-e>
X-ME-Received: <xmr:ID6CapNTKZ_rkw3PfmGyNFIUWQP9OVErkw8sGQ1wEKkdr5pW62pv9dsHqnk>
X-ME-Proxy-Cause: dmFkZTGU6CsvhMdBtF1sno4coJRY9LqZz27w5X62/KcvcmaHPoOW0E1BwYMGQvImxADkeF
    Vrd/NWvQclh95CfVK4mxB+x5IwibSBkynFlxvp5GF5/z4jepOu57IyLHUvB8DzXymwpMun
    cyoWwWLP4hjAaD7bSTsoDmYKe03ryBERSg0IuR8ZqJolHrsaFnqWf5mL2byVsL9qLL9zPI
    9yLFlvwwZlCiJbT4IVFlRVV/9A2lZNuDFrGWvpQWw3cjqX9EcFrpnMQcn/0MdQygQWXSYC
    yXHZy2pRvgBssh5qObsL1GM1XSEE6m2uHX2m5CwJlvTSIfOodU1appS1XFI/CBVlhtQ7bu
    WKduOy5KF3rkObzFMiEUvs0Uj+LfiCh6TivtFsv9ZCNMbNZlGDBoD70ARSLp0XqawKgcWO
    4RiWTFPOoz+vIHDroCYLvSEQINMB4dtDTXJ4bPtSoOC1A7Uuzl+tv2HVHx+vABiXweeL5Y
    B3sGlUM6WH7yS7YE4BSgR6uka3P965uA8/oqj2x+5VFy/Ho1o+YZlJ6AzrIDQ2AOtpBe1f
    oON1he5PaB+Gj11+twxr/dYpMSHdLv7yT7mnf/dci59b0UPnqF9iMScbflIoYgvrHP20+G
    HvUS/ei21AytaZzWxcEuOCYs0kXcHbXn/msGaoTEwH1OUh7FsC6dL8NQXoJg
X-ME-Proxy: <xmx:ID6CalqKv0hCUxmF86ciHpXUTy3ebSv3UxCAlN0wCK99JAaQHTeFrQ>
    <xmx:ID6CankFNKYtlXTcEsPn3FwCNKApsL-bSTzIZEaquGLMo-ttCjrQbg>
    <xmx:ID6CatwonootbN2xB3VzZK0QOdiMoG8W70sF3rZfeQRAr2Ski3DgPg>
    <xmx:ID6Cal1ipe2HfUXooDqHPQuEju8XQHca1H3JyNEYbA9q3M_rCennmQ>
    <xmx:IT6CananLT0nU6sQR71oBM7lv19j5Kw6TIPwBvwOOamkgv9APnRcXioe>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:48:00 -0400 (EDT)
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
Subject: [RFC PATCH 56/57] selftests/mm: cover the scaled max_ptes_shared limit
Date: Sun, 16 Aug 2026 23:46:08 +0100
Message-ID: <20260816224609.308019-57-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B63C1C0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ugshxjoapgzmh6g84789qd9u6ccom5xn
X-HE-Tag: 1786920481-797652
X-HE-Meta: U2FsdGVkX18kuGr5ljKd9xXmqcyBrdfeLFxtVbmMx+qiw5YsyNr68epd/gOqzuIubVL7Qng1uFbF0f0k9smjywU59OBYBjdeJT/vLLVAKlLt0vHt+o2qnR6Wi/DCjI344zYlFdehXJkVDr7/qPccf+GiUqYYXRiVIi3nd4tCzfU8ZTCZNanLdq9GVjyIeHvZMbqDq1O6Y9c6zoAwwpr/OurnPgpOa7Vv1xqrSsAkZuiqLFUaGvaW+DN7724RWaCtkSyXNOSouz7t2ir50sTAoAZNo2mCjkrxXPsYXCR3S+4er3QgeWKvFQus7YkgWUgqVgMBQJH7nV9Xox15FiJp/PJWNDyWUc8yJcpflzkmGwcxHXUJUmEutNB5wMyOusOXr5IVBLSXQUS2T01i/iTLZA28jHF3EAPl7PlTDkSqWQX3frl8/IGVbT4haCQLyllRlWBc8tk36VUzABXqwHge0ONSZHx4ByZweauX/Ko3TqgjqHQdE8cp339UbO/l6nxnbxPw2eRmON/aTYSSHLut2O+qKJmtXgVj29vJXsUaiYl2gOXU+g3VVsgCo4NHUEErsSpZqITQPWcrxZTx9tdmyhgRjFuhsmKRRdT1/fgqPt1xklQ/asFwB2c0ZFZLqiHgALZVjEaA4IqVl8OnNhMcjdyVs3C1SeT5/Nl9wK9IiDXe9tAijy1jmdjQos5R9/HiTa0bDeaUzXIF3hzeSKLJ8CKebn2hNQDdyyKfi80zD7tDRJ+BYIUIzh9QCYMsvKh7hX3Z/ve78EGYyyAulBCrill+ShPlvS1EuRdVsGG7Lzz0iIBcdrGsMLKtKbXZP/kCxehNZ6TgjargzexJE4Gv3m/XNNL4tAwCB4cIZp8Rewa6M7p+l+yPZSDXg3l3VV6p2IyVXdLxJiMXPd80tJnbA8j3RYZRLrvfkrD/NxJDEo6tCf8x6PYVm/x1MtuYv91i2qI7mX7g8F1hb6qiiOo
 pMngUp52
 7HWAuHyA1UiW4m19hPd9C1l+ygVT3BQq6tp9FM5m+qU1N06I0HgUz/rKB/Prjtv0XLo4/pR7PaaruQeKA0ac05+3QDEa2ZL7UXpE4M09kXpJi1yLrg4rbKmtRCN+T53/b0yeEPrejxvvIF/qC8aOCTEoYG6CYxPhTMZcYIWI5otTycrhWdL0ovcdonVrnSmsD3bA8AJD0LMkvTYGgWbvmPrKqzuyd2Owa5J56Pl3lQYl5ROXAlwfNe4TcikO+9GCXfvxXjhd35TGvEkBSzmzpGi9Pakvidev4IkFc67iF7qCnMoMkKSphKRQC39dGaH1ICwJaotGMOrRVO0qvzrD+4Qlq46q+1KTj2AsHBA5NgOFsBrFpDA6Q/q9IUoA8x4kmcuEtSKXw+OPgDm9rHcoWCcksEfrX7Pw+ARi1YWcL0JvLLNV86y1SpAI/wzZZm4EUoPvsRG/ZceFIr0EeAUP3XzXIU0P1AhI+sQrHMuRIJfpND1JPr8tZrJkfbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

max_ptes_shared is written in PTEs of a whole PMD, but a range smaller
than a PMD is scanned in full and judged by the same setting.  Compared
raw the limit is then unreachable: on arm64 with 64K base pages a 2M range
holds 32 PTEs and can never exceed a 4096-PTE budget.  So it is scaled to
what was actually scanned, and what decides is the shared fraction rather
than the count.

Cover both directions in one sub-PMD range, with a forked child holding
the sources shared.  One PTE past the scaled budget: nothing in the range
collapses.  Break CoW on one more page, bringing it inside: it collapses.

The counts come from the current max_ptes_shared rather than being
hardcoded, so the case follows the setting and the order it runs at.

Without the scaling the first half passes wrongly: a few dozen shared PTEs
never reach a limit expressed in PMD units, so the range collapses when it
should not.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 85 +++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index bd684cd25fed..dde24756a3a2 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1791,6 +1791,90 @@ static void collapse_order_pinned_window(struct collapse_context *c,
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/*
+ * max_ptes_shared counts PTEs of a whole PMD, but a VMA smaller than one is
+ * scanned in full and judged against the same setting, so the limit is scaled
+ * to the range actually scanned: what decides is the shared *fraction*, not
+ * the raw count. An unscaled comparison against HPAGE_PMD_NR/2 could never
+ * refuse a range this small, so both directions are checked here.
+ */
+static void collapse_order_sub_pmd_shared(struct collapse_context *c,
+					  struct mem_ops *ops)
+{
+	size_t window = mthp_window_size();
+	size_t size = 4 * window;
+	unsigned long nr_ptes = size / page_size;
+	unsigned long budget, cow;
+	int max_shared, wstatus;
+	void *p;
+
+	/*
+	 * The range has to stay strictly below a PMD to say anything about the
+	 * scaling: at exactly one PMD the scaled limit is the raw one, and the
+	 * case would pass without testing what it is here for.
+	 */
+	if (size >= hpage_pmd_size) {
+		ksft_test_result_skip("%s: four windows do not fit below the PMD\n",
+				      __func__);
+		return;
+	}
+
+	max_shared = thp_read_num("khugepaged/max_ptes_shared");
+	/* The same fraction of this range as max_shared is of a PMD. */
+	budget = (unsigned long)max_shared * nr_ptes / hpage_pmd_nr;
+	if (budget + 1 > nr_ptes) {
+		ksft_test_result_skip("%s: max_ptes_shared leaves nothing to exceed\n",
+				      __func__);
+		return;
+	}
+
+	mthp_push_target_order();
+
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (p != BASE_ADDR)
+		ksft_exit_fail_msg("Failed to allocate VMA at %p\n", BASE_ADDR);
+	fill_memory(p, 0, size);
+	madvise(p, size, MADV_HUGEPAGE);
+
+	if (!fork()) {
+		/*
+		 * Everything is shared with the parent now. Break CoW on all
+		 * but budget + 1 PTEs: one PTE over the scaled limit, and far
+		 * below the unscaled one.
+		 */
+		cow = nr_ptes - budget - 1;
+		fill_memory(p, 0, cow * page_size);
+		ksft_print_msg("Refuse a sub-PMD range over the scaled max_ptes_shared...");
+		if (!khugepaged_wait_full_pass())
+			fail("Timeout");
+		else if (window_not_collapsed(p, size))
+			success("OK");
+		else
+			fail("Fail");
+
+		/* One fewer shared PTE brings it back within the limit. */
+		fill_memory(p, cow * page_size, (cow + 1) * page_size);
+		ksft_print_msg("Collapse once inside it...");
+		if (!khugepaged_wait_full_pass())
+			fail("Timeout");
+		else if (window_collapsed(p, size))
+			success("OK");
+		else
+			fail("Fail");
+
+		validate_memory(p, 0, size);
+		_exit(exit_status);
+	}
+	wait(&wstatus);
+	if (WEXITSTATUS(wstatus))
+		exit_status = WEXITSTATUS(wstatus);
+
+	munmap(p, size);
+	thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
@@ -2084,6 +2168,7 @@ int main(int argc, char **argv)
 		TEST(collapse_order_mlocked, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_lazyfree_window, mthp_khugepaged_context, anon_ops);
 		TEST(collapse_order_pinned_window, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_sub_pmd_shared, mthp_khugepaged_context, anon_ops);
 	}
 
 	TEST(collapse_full, madvise_context, anon_ops);
-- 
2.54.0



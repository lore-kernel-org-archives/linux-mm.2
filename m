Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55831CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92116B009F; Tue, 29 Sep 2026 09:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0EA6B00A1; Tue, 29 Sep 2026 09:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5E16B00A2; Tue, 29 Sep 2026 09:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FDE36B009F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:15:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC68C1404B9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:15:36 +0000 (UTC)
X-FDA: 85266846672.18.FA3579A
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf16.hostedemail.com (Postfix) with ESMTP id C89CF180007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:15:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n PkzHty";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=PXK7OPBK;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790687734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+8v5S2boYfDtEfUZ6s/YaQO9DjL7x5EBGDEc0MT0aY=;
	b=O8GDJ+iIfiw8gd0n/MLcBh+TcCt0Uc6mPfIHrPed3bcH6UuB89uOLp3ms4BGRQhglewvKu
	9lb4aIDHbEdECH5Wovup4SwVGhEd3I/gKOGyHT7wl4vMMe8BfXgv6rgba0+n0rdLAdDuSB
	7KiOpjiIId8BcdhO/GxNKI6wP0hA2QU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n PkzHty";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=PXK7OPBK;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790687734;
	b=uRB73qlS+6IcZpLQBpBn4uFXPRsTScJ1fwFc7LhthXjt5uJVOjTwKwlvRCDJHJOKUMAdgH
	mSZt41pyV5+n1KggZILVxmaz3UnzRS2ngv0U/liigwiv3R0Ll/BOE2knT3aa/LvJ7DOwww
	yX1TyQeviIQLEVZvS3xCC2aQcUhM38A=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 4D4BEEC10F8;
	Tue, 29 Sep 2026 09:15:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 29 Sep 2026 09:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790687734; x=
	1790774134; bh=j+8v5S2boYfDtEfUZ6s/YaQO9DjL7x5EBGDEc0MT0aY=; b=n
	PkzHtyQjPAXHP4KOgmChR5Hnv/OuFbVK1lMmOJBGx7wD+usC6OssSnFfU8Dah0wR
	UrxYI9ODurhZ5SpuMzf8dhjSDZ6fLNBqCyvLfUDC20S4r/+YCVZTa4qFtttqXYII
	ZweA7New0FFVmFeycSt6cnQxQ30EsrVGPSWNnWTD5d4r7hBfXJRYmIAYJAMhWP3m
	GI0x5mpPsBdQsM92I77m185X+a3uPaxE6ZeVaafc+3JFa6z25eUVvWeJbVgAbh6O
	TSJGFPSElxtJ5h2Md/leEY96ehZxSfUnrQzi9vLpjmSd5xVN7cLq5YjxTTa/VGN2
	pnGM6yb4Tp+mWGK5GvGbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790687734; x=1790774134; bh=j
	+8v5S2boYfDtEfUZ6s/YaQO9DjL7x5EBGDEc0MT0aY=; b=PXK7OPBKwRuUTcp5m
	meSulHlH34r/SLasiPsUGKXeB35h1oHy46zeN48zH1tQeKedKY8Xy2zp8O2eQPRn
	3BDkPHGQyPnIjK2HIFbV8xOiMaFG/1e+tc8pO5cZdXjJEmZLpc/2mCzNMAZSjl6l
	5siv92YUxYReBcssDk+vo8iBq4LmugCaUqURQaYL1B7h7d/Gzyiy8JjkmJtgBMCF
	+HkOHgQ90qbjXwTb1nPmr08aIujw+qGYHr38fz9MEJzRCh11qButeOUHMvQA6iik
	rhpLNahuXx+GsQFVaRt1WOzNpL6jnr8Bj3+nMNTIUZ/ZMNd1r9mOLtKaWOPi0E7/
	4a7XQ==
X-ME-Sender: <xms:9rm7auK-gKeMl2-DZS_4NDfso-ZBx6-rSY-klgWSlpOHzhSnXJ3R0w>
    <xme:9rm7anxZcQeaCXlYc99kNQpDVB9cDw_qsgrBS4Rg_3tAnLxdESvBnTIW_shkRtUdj
    Cr276mUofL_KRbDBW8RpkZ9fBvfM_gFfJKlRF7faUvGj40c8haQxzs>
X-ME-Received: <xmr:9rm7aixnum6ke9Imh1YnFDLDX7VbfXp4x_A4JmWSQvdxY2Od5_PIcV1LvCk>
X-ME-Proxy-Cause: dmFkZTFOfxfIFB7Dof8MQ0ob0YOYZEeiJaQRd8Ge2o8s43JQBWK37zdhQkq0XKYCwyywIg
    ZiGTtKXHoUljwzASlUEqjkV2UiU5ISCyg4jFvPfvIP9aIL98y8KUyJ9/8nxAgQVzOno5ir
    gOyA9ix1zjXD9/21H1LXhnhqMhLomFu/ViqkjFAXC9CKAfQMEv8+8xSZHkEVnRS9GvI0hU
    Kv/GBbpDcDsB+T2kAW8zM2iBszjip0w6LYLK/BIQnmNfYTMqFl7tu75C+ED+3K9BUbd39w
    gpffHgcOGSxmIwtsFGo7ZDjX2aGXL0benmT0LYISRxT/k3lDpt602p+lCE+0O7nNMuhttY
    at8WHjp4xIjLRdU9BNRn0rjVIdIeEpnl/5k1JU325dDEsyH+YuXTsOulzDsJ8nI4J969ND
    FikMbxRYerIqxkpgMYhpbFMj643WtIICWVqAwKTs1aRILBQmd7iNrIfjMIK++9qALhNkPC
    CuUCAQPA29ra8c4sGO+ddDm5LF4cM40qPGNWSqr5+dOcXQjRqwl7nDnp3bfT2dcU24C8Qn
    lrAX+jA78SblvpgQGwKlQM8k3o3FM7H84DQKMECUiCNQ6fzSXFwZbhAI3heDQXHflWeNmN
    t65ydAClK3i++pBBv61sv8jQYJoiehiI8ngZYsl4TZagf9ZfogNAmx/XhWfg
X-ME-Proxy: <xmx:9rm7ap0csagon12F30RLnGqNoVKfw5cTZc0xHe4CJuIGYRxazfHBdw>
    <xmx:9rm7akXZ1EeMNZR5v2F2BGBSlcpLUXXZV2SEFjY9fPAvyeVBWy-lxQ>
    <xmx:9rm7atdzwfQdsKEm_7UmSEHbKmeZr_KjjsLAmQGTxEDx21IiZMdAoA>
    <xmx:9rm7al-N0ZgnZ9hw_O54C7fM0qHOgZPS7buEuaGq63WIS4r71FHIOA>
    <xmx:9rm7ajYxQUo2Nd1Hu8br8aC2dmJVfU9il2b3sHY_KZGO2ZP84FQqLtE4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Sep 2026 09:15:33 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 4/4] selftests/mm: check split results by position, drop gather_folio_orders()
Date: Tue, 29 Sep 2026 14:15:19 +0100
Message-ID: <20260929131521.153079-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929131521.153079-1-kirill@shutemov.name>
References: <20260929131521.153079-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C89CF180007
X-Stat-Signature: ss8p6p8q3i3xp6dr151ud5ogm838etce
X-Rspam-User: 
X-HE-Tag: 1790687734-784072
X-HE-Meta: U2FsdGVkX1+AVrWE4nRImTRFTdcVtsvBqUHVBBptCIc2j13DYW4ktaM6K31eWrL8L4CrqJFXuXiaK81z/cVGsemaRddA1LPs5JNtzkrgz0kWlbIPmC8LrFB/0W48SxECjJmSAjasj5RydBP8HIUTMRVXwYShUtGCh7UMeUx2sKqMM3iSHCDUGEcdb+43Tp0D+SkTBVZbUdSr0i3N+Eq/JE2V8rPJN9u2lesTXd8A6ae4PghzIsWPnZvhJduGA6EtdLYoXQVbON+4oEYg0kclkBEZINH72O1idPw+30pWWArtiN3Zv0Q3DkiP2kH8MFhGhTa6VdsNHw+5Lor57FzLdtm4yitnYmtOvuC/fOJ9IRyEVO/RlYNewLINv5+IrOEi1uTYP7JxkDfOqL7kEq0S4XSrX75vyg18C6lW/BpvTbhahcIaMztawwFPfiap9y009VC+O9kFfMgRzXMfAvEHrBEv4znpk5oIvvwC0QzRnyNIe/c3KrP33lmNemxHsMWp/NrH1wWF2pr686AVweK2L+1kjnlIb1HE4or9yztlQAWIAK0nW3M7AuX/jovKwKuava6xz/9N2iEJis5KOurixXR8J2F739urdmnf+Vz0HzN6VlhOt9k4yJp81S2dtBFDC9PWAQLhS48dsizUEduQ6xKkreU5ANX9HBE7Zs6SfoMFTyZnVzLZ7M2LcNqX9iLYH5jEbAuFxQJORTlSRxyuIsTQV1K7Sg5Onh2YHm7Nn10azp0w9Jk+aL/70gc9yF2VLdSX/yxsf9Fx8liD6ZU3oYjx0IhnJXQtHXApuQY84idZwG9mqmWz51LQ+HFOsWzkwNqbSuLeeWXElD/D3hKTKo1rEHUyxJySLLIl4fq1chtx/CXeuTakg/z/wbqcm4NtxzfsSCs3P8CmH6uJOXVyMXpkXb6qGD1lpcUoE6lHqEJu0CZ0iuZw8EvSUi4/ts1cotnSAkRaBkqQSpbfOlZ
 JMvmzqsO
 b6i8623+A3h6Ww0Zi5hu2rg7VPpMR5VS53aeusDxheXYE5PFK2WRgC6AuWSZIhUG66YU4PdUBrNVVFb/brKQKy4D4w5pMIes5elKrMxFWbajGILm+G7fgZxeVuVvFe3B82Al8vc0mi57qnAKh/1qCvwtCctVilC20md1aFAQZqICymNA0nLgjUjkDpp5avlpwZMRjH0tQJZ8qqQ26qhxWl+eTQDnaCPX18ne+lMs1nwqfZPWk4tnmbBTzSGm8BaxEtk3TYM/wsX+G/v/5/JrMeZZCG70VEmZPqek1CC8veFQL8EpHrtHV0ooZXSldB8MTHwhVljzblx26pkaj0ld+T5O4wLw2tR3C1qrsUQ8myIfZnPTerc1Fi/ZeA0pOZ1uzMeYh4Ix9+RMVQ8bCvEKV1OtcjzAoKzqWGzMeS2DXR2TVt0prdvVJNVp9ZQyBeFbp/aiiQrDV1aogyal2kvIzyRPM3M0qV37oAHK0BxycnsYRQ66mAbCi+n513g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

split_huge_page_test.c checks a split by counting folios of each order
in the range.  The count does not say where the folios are, so a split
at the wrong offset passes as long as the per-order totals match.

The layout after a split is known.  A uniform split leaves one folio of
the target order per window.  A non-uniform split halves the folio and
then the half containing the offset, down to the target order, and each
folio it leaves behind sits where the offset determines.  Check these
positions with check_huge_anon() and check_huge_file().  Unlike the
count, this requires every page to be present.  That is fine, the test
has just read the whole range.

This removes the last user of gather_folio_orders().  Drop it.  Make
is_backed_by_folio() use the cached descriptors as well, so the test
does not need its own.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../selftests/mm/split_huge_page_test.c       | 104 ++++++--------
 tools/testing/selftests/mm/vm_util.c          | 128 +-----------------
 tools/testing/selftests/mm/vm_util.h          |   5 +-
 3 files changed, 44 insertions(+), 193 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index ef4058662b91..1539ce2c0954 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -26,7 +26,6 @@ uint64_t pagesize;
 unsigned int pageshift;
 uint64_t pmd_pagesize;
 unsigned int pmd_order;
-int *expected_orders;
 
 #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
 #define SMAP_PATH "/proc/self/smaps"
@@ -36,38 +35,40 @@ int *expected_orders;
 #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
 #define PATH_FMT "%s,0x%lx,0x%lx,%d"
 
-const char *pagemap_proc = "/proc/self/pagemap";
-const char *kpageflags_proc = "/proc/kpageflags";
-int pagemap_fd;
-int kpageflags_fd;
-
-static int check_after_split_folio_orders(char *vaddr_start, size_t len,
-		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
+/*
+ * A non-uniform split halves the folio, then halves the half holding
+ * @offset, down to @order.  Every half left behind is one folio, and the
+ * last two halves are both of @order.  Check that each PMD-sized part of
+ * the range came out that way.
+ */
+static bool check_split_at_offset(char *addr, size_t len, int order, int offset)
 {
-	int *vaddr_orders;
-	int status;
-	int i;
+	char *part;
 
-	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
+	for (part = addr; part < addr + len; part += pmd_pagesize) {
+		size_t off = (size_t)offset * pagesize;
+		char *lo = part;
+		int cur;
 
-	if (!vaddr_orders)
-		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
+		for (cur = pmd_order - 1; cur >= order; cur--) {
+			size_t half = pagesize << cur;
+			char *left;
 
-	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
-	status = gather_folio_orders(vaddr_start, len, pagemap_fd,
-				     kpageflags_fd, vaddr_orders, nr_orders);
-	if (status)
-		ksft_exit_fail_msg("gather folio info failed\n");
-
-	for (i = 0; i < nr_orders; i++)
-		if (vaddr_orders[i] != orders[i]) {
-			ksft_print_msg("order %d: expected: %d got %d\n", i,
-				       orders[i], vaddr_orders[i]);
-			status = -1;
+			if (off < half) {
+				left = lo + half;
+			} else {
+				left = lo;
+				lo += half;
+				off -= half;
+			}
+			if (!check_huge_file(left, half, 1, half))
+				return false;
 		}
+		if (!check_huge_file(lo, pagesize << order, 1, pagesize << order))
+			return false;
+	}
 
-	free(vaddr_orders);
-	return status;
+	return true;
 }
 
 static void write_debugfs(const char *fmt, ...)
@@ -191,12 +192,8 @@ static void split_pmd_thp_to_order(int order)
 		if (one_page[i] != (char)i)
 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
 
-	memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
-	expected_orders[order] = 4 << (pmd_order - order);
-
-	if (check_after_split_folio_orders(one_page, len, pagemap_fd,
-					   kpageflags_fd, expected_orders,
-					   (pmd_order + 1)))
+	if (!check_huge_anon(one_page, len, len / (pagesize << order),
+			     pagesize << order))
 		ksft_exit_fail_msg("Unexpected THP split\n");
 
 	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 0, pmd_pagesize))
@@ -264,8 +261,7 @@ static void split_pte_mapped_thp(void)
 	 * check_huge_anon() cannot be used as it checks for PMD mappings.
 	 */
 	for (i = 0; i < nr_thps; i++) {
-		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
-				       pagemap_fd, kpageflags_fd))
+		if (is_backed_by_folio(page_area + i * pagesize, pmd_order))
 			continue;
 		ksft_test_result_fail("THP %zu missing after mremap\n", i);
 		goto out;
@@ -285,8 +281,7 @@ static void split_pte_mapped_thp(void)
 
 	/* Split failed? */
 	for (i = 0; i < nr_thps; i++) {
-		if (is_backed_by_folio(page_area + i * pagesize, 0,
-				       pagemap_fd, kpageflags_fd))
+		if (is_backed_by_folio(page_area + i * pagesize, 0))
 			continue;
 		ksft_test_result_fail("THP %zu not split\n", i);
 	}
@@ -518,6 +513,7 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 	size_t i;
 	char testfile[INPUT_MAX];
 	int err = 0;
+	bool ok;
 
 	err = snprintf(testfile, INPUT_MAX, "%s/test", fs_loc);
 
@@ -530,7 +526,6 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 
 	err = 0;
 
-	memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
 	/*
 	 * use [split_addr, split_addr + pagesize) range to split THPs, since
 	 * the debugfs function always split a range with pagesize step and
@@ -541,18 +536,10 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
 			write_debugfs(PID_FMT, getpid(), (uint64_t)split_addr,
 				      (uint64_t)split_addr + pagesize, order);
-
-		expected_orders[order] = fd_size / (pagesize << order);
 	} else {
-		int times = fd_size / pmd_pagesize;
-
 		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
 			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)split_addr,
 				      (uint64_t)split_addr + pagesize, order, offset);
-
-		for (i = order + 1; i < pmd_order; i++)
-			expected_orders[i] = times;
-		expected_orders[order] = 2 * times;
 	}
 
 	for (i = 0; i < fd_size; i++)
@@ -562,9 +549,12 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
 			goto out;
 		}
 
-	if (check_after_split_folio_orders(addr, fd_size, pagemap_fd,
-					   kpageflags_fd, expected_orders,
-					   (pmd_order + 1))) {
+	if (offset == -1)
+		ok = check_huge_file(addr, fd_size, fd_size / (pagesize << order),
+				     pagesize << order);
+	else
+		ok = check_split_at_offset(addr, fd_size, order, offset);
+	if (!ok) {
 		ksft_print_msg("Unexpected THP split\n");
 		err = 1;
 		goto out;
@@ -625,21 +615,9 @@ int main(int argc, char **argv)
 	nr_pages = pmd_pagesize / pagesize;
 	pmd_order = sz2ord(pmd_pagesize, pagesize);
 
-	expected_orders = (int *)malloc(sizeof(int) * (pmd_order + 1));
-	if (!expected_orders)
-		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
-
 	tests = 2 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - 1) * 4 + 2;
 	ksft_set_plan(tests);
 
-	pagemap_fd = open(pagemap_proc, O_RDONLY);
-	if (pagemap_fd == -1)
-		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
-
-	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
-	if (kpageflags_fd == -1)
-		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
-
 	fd_size = 2 * pmd_pagesize;
 
 	split_pmd_zero_pages();
@@ -664,9 +642,5 @@ int main(int argc, char **argv)
 			split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, offset);
 	cleanup_thp_fs(fs_loc, created_tmp);
 
-	close(pagemap_fd);
-	close(kpageflags_fd);
-	free(expected_orders);
-
 	ksft_finished();
 }
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4c0d0e6f2553..abf047a2c09e 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -242,125 +242,6 @@ unsigned long rss_anon(void)
 	return rss_anon;
 }
 
-static int vaddr_pageflags_get(char *vaddr, int pagemap_fd, int kpageflags_fd,
-		uint64_t *flags)
-{
-	unsigned long pfn;
-
-	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
-
-	/* non-present PFN */
-	if (pfn == -1UL)
-		return 1;
-
-	if (pageflags_get(pfn, kpageflags_fd, flags))
-		return -1;
-
-	return 0;
-}
-
-/*
- * gather_folio_orders - scan through [vaddr_start, len) and record
- * folio orders
- *
- * @vaddr_start: start vaddr
- * @len: range length
- * @pagemap_fd: file descriptor to /proc/<pid>/pagemap
- * @kpageflags_fd: file descriptor to /proc/kpageflags
- * @orders: output folio order array
- * @nr_orders: folio order array size
- *
- * gather_folio_orders() scan through [vaddr_start, len) and check
- * all folios within the range and record their orders. All order-0 pages will
- * be recorded. Non-present vaddr is skipped.
- *
- * Return: 0 - no error, -1 - unhandled cases
- */
-int gather_folio_orders(char *vaddr_start, size_t len,
-		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
-{
-	uint64_t page_flags = 0;
-	int cur_order = -1;
-	char *vaddr;
-
-	if (pagemap_fd == -1 || kpageflags_fd == -1)
-		return -1;
-	if (!orders)
-		return -1;
-	if (nr_orders <= 0)
-		return -1;
-
-	for (vaddr = vaddr_start; vaddr < vaddr_start + len;) {
-		char *next_folio_vaddr;
-		int status;
-
-		status = vaddr_pageflags_get(vaddr, pagemap_fd, kpageflags_fd,
-				&page_flags);
-		if (status < 0)
-			return -1;
-
-		/* skip non present vaddr */
-		if (status == 1) {
-			vaddr += psize();
-			continue;
-		}
-
-		/* all order-0 pages with possible false postive (non folio) */
-		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
-			orders[0]++;
-			vaddr += psize();
-			continue;
-		}
-
-		/* skip non thp compound pages */
-		if (!(page_flags & KPF_THP)) {
-			vaddr += psize();
-			continue;
-		}
-
-		/* vpn points to part of a THP at this point */
-		if (page_flags & KPF_COMPOUND_HEAD)
-			cur_order = 1;
-		else {
-			vaddr += psize();
-			continue;
-		}
-
-		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
-
-		if (next_folio_vaddr >= vaddr_start + len)
-			break;
-
-		while ((status = vaddr_pageflags_get(next_folio_vaddr,
-						     pagemap_fd, kpageflags_fd,
-						     &page_flags)) >= 0) {
-			/*
-			 * non present vaddr, next compound head page, or
-			 * order-0 page
-			 */
-			if (status == 1 ||
-			    (page_flags & KPF_COMPOUND_HEAD) ||
-			    !(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
-				if (cur_order < nr_orders) {
-					orders[cur_order]++;
-					cur_order = -1;
-					vaddr = next_folio_vaddr;
-				}
-				break;
-			}
-
-			cur_order++;
-			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
-		}
-
-		if (status < 0)
-			return status;
-	}
-	if (cur_order > 0 && cur_order < nr_orders)
-		orders[cur_order]++;
-	return 0;
-}
-
 char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 {
 	int ret;
@@ -414,7 +295,6 @@ static bool is_range_backed_by_order(char *start, size_t len, int order)
 	const unsigned long nr_pages = 1UL << order;
 	const size_t folio_size = nr_pages * psize();
 	const int pagemap_fd = pagemap_fd_get();
-	const int kpageflags_fd = kpageflags_fd_get();
 	char *vaddr;
 
 	if ((uintptr_t)start % folio_size || len % folio_size)
@@ -435,7 +315,7 @@ static bool is_range_backed_by_order(char *start, size_t len, int order)
 				return false;
 		}
 
-		if (!is_backed_by_folio(vaddr, order, pagemap_fd, kpageflags_fd))
+		if (!is_backed_by_folio(vaddr, order))
 			return false;
 	}
 
@@ -579,12 +459,13 @@ int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
 	return 0;
 }
 
-bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
-			int kpageflags_fd)
+bool is_backed_by_folio(char *vaddr, int order)
 {
 	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
 	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
 	const unsigned long nr_pages = 1UL << order;
+	const int pagemap_fd = pagemap_fd_get();
+	const int kpageflags_fd = kpageflags_fd_get();
 	unsigned long pfn_head;
 	uint64_t pfn_flags;
 	unsigned long pfn;
@@ -640,7 +521,6 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 	ksft_exit_fail_msg("Failed to get folio info\n");
 }
 
-
 #define TRACEFS_ROOT "/sys/kernel/tracing"
 
 /*
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 2bf64d5b42aa..581c1b8445a0 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -98,10 +98,7 @@ bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
-int gather_folio_orders(char *vaddr_start, size_t len,
-		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
-bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
-			int kpageflags_fd);
+bool is_backed_by_folio(char *vaddr, int order);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0



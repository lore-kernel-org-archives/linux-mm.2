Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76065CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 15:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4FA6B0098; Fri,  9 Oct 2026 11:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D9B6B0099; Fri,  9 Oct 2026 11:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D356B009B; Fri,  9 Oct 2026 11:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5FF6B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:32:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3C6C16043F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:32:25 +0000 (UTC)
X-FDA: 85303479450.17.143EE84
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf22.hostedemail.com (Postfix) with ESMTP id 933F5C000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:32:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O 5JJHfs";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="qobj/hDL";
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791559943;
	b=osOUGzSJf02xklWjNyFetVExUgLwbHKHQBVte9lozDaeV7erZgdNqqn5YjxwWOw5pVwDPe
	SN1mYxCnuzFqcU3W8LtG3foR60h3RFt59FH/JeEB1XGTISlsiVdRP7jw9Bj06kqu4HS1Xu
	8C3pxTVUS/m2D+GCIglqLgjFwMOd2Sc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O 5JJHfs";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="qobj/hDL";
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791559943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEDimwxG1YNl4veDf2DKH6AeVkzdXpLJqRpemy2ckAs=;
	b=Sz/9YdkG4csxlpZNtl8LT1vQ80V1+94tsnhnJ18szMekgJYlp7kDm+1rTHjI+4I6BmKbt1
	KbkV+3kJl/FTAY+xJvTFu3DxWvIW6aa6THtZXmQahAsl8gOeIPW0Dx7INTyozbdqp9Fpz1
	xQ9AufVUWzHJltCBjWpVcfJmD12MdyI=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2E2DA1400157
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:32:23 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 09 Oct 2026 11:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791559943; x=
	1791646343; bh=OEDimwxG1YNl4veDf2DKH6AeVkzdXpLJqRpemy2ckAs=; b=O
	5JJHfseRPUICKPUWXDNpH00UfsZXiueMjuVjA/5EBB+pcw0kXnNhRnCmcB76tBtA
	ETYuARWTPgMli4G/npZyCDmEMy5tSV21/4BP67c/5TKWqyZgmLtw7zdVktIecELx
	dKfHD+brBNpyAVgJI34zTgWFpQY+Ts9CI09vRMJhTILTArODeXuXQFWKj4qgCANk
	xGIHuQG8B96HT2BARHX0aUivbTPYdgS5UITOFVVEQTC79ILz7cQ0ubypGVPNMne7
	dtXDLRZNDw5B1x1yKizxqwYWms/D91g9GDXvFPahhB0uuesdFR4J75/o7WSiYHA/
	MJHF/9xJv06+ER7alwJww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1791559943; x=1791646343; bh=O
	EDimwxG1YNl4veDf2DKH6AeVkzdXpLJqRpemy2ckAs=; b=qobj/hDLUtqcUh4Hv
	cImvyPf29b5rdyzFJZ8xrPXeVP18vH24x4jr+aTZ8H56nTYZnKNfWT2V40/yO0X7
	KEYIXeHMO3NPYxEN2FUPttUT94CKul22gWpDObbHX5boZuRvQqeMdbJdWR1/QakT
	L91xZsSjJ5p61sCHMVte/qewZDBcsN8qRCYI3fp9W/HhRNEx83vLA3FQzJYH3wm5
	Oci0oVk1sVpjcVMBXx4GrhUfnfUZztz8PNEyTpEoz6xtgw2w2ajdkZfagL+EqML/
	QaZws5+MCLv6dtqQcZdq2MkN6l572mUKvuKX/de8fghGnb8tlaC34Gk4aAMZ+aSQ
	DBc8g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791559943; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:dA8FRAPWFKCuvdVeAAuMxnXdWX8N+1u3dGkmJR0gLOPFL8C
	E+CWrIOdRNuGbM8g5lnGXsQPtMtrjZiJUxKd5YCrmHVladdBrAjFmepFNgUH8+x8
	ZLCPLr/njSlMq+OWga39CTEb8hXszU3hpXypOzIPBgBR9oRFCN23lMXWw+gNZuPq
	BHsGqL672JW1RMuPJPRz7PSYZnUJENsox6hanRxVdammpWOvHn/dlGtO3Vuezd6N
	eLuonjREFOOhNmUUg0cQ+vtpka8RoFO9UcLaXY2AkYCImqHF+a0izPCGagnMIJEX
	DhZTVpk1M8pkzx4RR762UcBOz34OKp4WMX3z8SA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:EjqJvJne4BQEcmYXTtAUK7BhPJiwcvnoUHYwG+CHfXQ=:UzYe57BS9a/BJyqzyMU9NlnReAPFYsoSdtTWIMRed2A=;
X-ME-Sender: <xms:BwnJajr1pzs5wZYJyFTMdQMZ16WM1CBWXl-qLDPHAXcWCw9iW4yVyg>
    <xme:BwnJahJrDxHOb7CNfAk5GnBL4MDcRcE0SjP86SgVdTDpwIx3r72yw7ARml93yDNYx
    vrGC6s57h9u4mCkg_UVhL4Y3iDgJrGJ7yeOFWe1QBBPhVG-gWpYG8B->
X-ME-Received: <xmr:BwnJaotpbDSsZ7voQNkcLHB4HjTY43KNoQfBWiI0Zf4rY0Eh5rt5onfR4eA>
X-ME-Proxy-Cause: dmFkZTGIoGBLZMaAhgcaayk5wgp7rW9vayQkfonvs0TKGSEuuYzL1U5eWR8oX+vcbxv0ak
    vZ6V5Fk2n6N+IaumklX1qzBk7r0hEpcbcO59DsZzPQwz0SNLq5ubZVbwk/A0B0ImP1q9S/
    wvMCjtg/pGCexbzTYCAAsFMX+sI9bOrGKjIjV+CjlMDzV5ttTW2+3V5NxcPyUYh3hDVmY6
    5SaA7LVa7G47KypkYvo+NaxjJdB6S0C6Hb2KUpv2JaxJ1DNuAn/rjb2TmQMM/Oo0fomkKJ
    59473bNh2ppMgxEJkQDpXpn3GMfvTNgjovDF8A3Cgd0ETDAPdqWfdTSt6z83qaSG77WHQG
    86xSEi8z4UdHVqTV1hgSzEO0yQtk9XzrRpWXt7E/zljVaNEEktikjaLRG7usQlDvZd5017
    XNvyQPH/VORCKW78arBlgd2PMGRtolarXk14D04Exn05yMAnvmCBckiiu3Rw2M6a45XA4a
    zPeN1bM8WBHYKFjWtVFs56qVkJr0xl17cYzSafxQuV30jTMYr7KHRGFQCpO/57QwXfsep0
    15yUlgRNIfRK7GavtCVA/QBba27KER2hKCqQChduKERDwuscy9cEZQURanLUn/V/7ykiti
    Jf6sSuTe2QJl3mcHWFb1pAf0xD9HYL8K8N+CEUCbAOYIrRVENl6Czopkd3Fw
X-ME-Proxy: <xmx:BwnJaptuGl2svQYC6_eonPc_41xzvBzRM2mx9XvfM2oK8ApHIOZmyQ>
    <xmx:BwnJanVN1cYDJXMHI6Pub0tyTIxZliggeacL61QOFJfyKXUZzOAbrA>
    <xmx:BwnJaqUpcYLDU1dFtW8CXfGPfMt393mfynRLeCgdxEalM9uuVUl-6A>
    <xmx:BwnJaiTJV7x1msWO-eY7nj5JN5rBXLRETJIQlsTFQ0EQux1180YGFw>
    <xmx:BwnJaoj3QqabTZ1DsJnIVxMaFRE9xX9CbExr8Ks8dufbRH6omSnK5A-Q>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 11:32:22 -0400 (EDT)
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
Subject: [PATCH v2 4/4] selftests/mm: check split results by position, drop gather_folio_orders()
Date: Fri,  9 Oct 2026 16:32:08 +0100
Message-ID: <20261009153210.236517-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009153210.236517-1-kirill@shutemov.name>
References: <20261009153210.236517-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 38w7gcswzoacazoifnjwfpmadieoja4a
X-Rspamd-Queue-Id: 933F5C000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791559943-835770
X-HE-Meta: U2FsdGVkX18xh8V9lvs0H/w1OVZY6fo5co09bKYc8WNoJNdRFBT0K8qnLrHVakjNNnzC/XP3uqr1X665u/vJIjIdc/baoyafgcFcWWechLJsuBcIPkz3II5zFh4CJdRJ6Xj517RpB68Qlk85OSTyucImPJJpmV/FbO0BawC9ivxYeMSID0bflWScQRkEGT3qwbIvdh89uO+IqbHuZKcNIzQ+0Yf1/KRRm+h3Wt1y35VkA0i4y+lqQN4VAoyMSR0DF87VuBCrzdoaN+C7Zb76F5UmYsL4/JsWXuL04r9wxykOIYeswW2Mg++XKyvXQyf/AByy9sU5r7HnGgq6FwIpYJXdFyLJDqbx6eKj3dpS+vldE69j1Dq1JAl8SLcvpkWM9NNbUvD5bb5VimwF6oDtCfiOMwnVCRFMW2eJv96OwukxOz1KdiH9Rm00SH4hWj/XCB72BfgC44WpBFbQHslpirSpuMkbNVdZ5VQp8JLOLrZ/GmiVoraCGVsC8EazjLJlt3eWMn4c+zDqRr9+us5wQCRcWzMQ32xOfzRsBACC7h7YjBI+xJhYKV91tcU5ZAmnZ4wgLQpreMnzpDLEnDGiXiqwmNh1TDJ/PtPzKgB/V3jp93mmk6825AyXUPcpa685UoH60dfdaEpEdtnXVzpLCMHPs6YWVv0j/WPT7Ozn9ZH9H4mIAiYxTy4O1pUxxJmsYnj8dromtdsnpfXTSahj/4U1p8JBZpdMrbT1Z++5mVrkCBcctfG644yCICc6lQGjJhoiDC/MJR5QhIH/b05td+zrRX+TtatVGAWZcGR+SKtw5plaoWz9HybK6WdPLangUkKo9qcXy3TbRRjTB1Vh601BhWOjFtAKRTXy058863jm02SUYYw4kL2R4Wobg6GBdUcmDLG0+tRfXdBNF6gjmTM6OOn1fgua45G3VY3Ew/fkSpf05kk2NrE6Q4k0LAxEfbEuoFhVIiLknYaIc4z
 59IEOmLH
 ftnDTaUeOTlaNQXFVLzFyI6absCNvMhpAIKMTAklWXl2+EkNYp0QBoyEHZtKmQcZi71eqt93nxbB4BVy+tQfkKdStdJNSbX/OqeAI7FqORIL4XZcg+eP8rO7tV8zhN5JVmLWGxoqHMHxK6jiKPqcfupZCd3OA/Vs22u037L9OMGWKn/CTnfDzmst3WDqtwdVxEpOJ1K+3XtBGqvSAHNF1upGkASKRcxzgpP0RVv/z7P1pFMjLFrXqcHLEm6atj2t7bUjH8dY6gFjeDMjCBVoDWJajkboNsM4AuN2xD6cZdmiCATeM50zU9YNKQUGvcuHhQRuPKzu4N6LPykosT5/KMm6dfSLvRIShRP6PCY/E0akU+vZFafaEU18GsT6eFDWXwm2ij+1cfhsaoh0A1Jb2rkZPm/843puMI0mQdIwqlwgonZHik54gMhqn1m+Ye7OTUCoCF4R7UKA4GDIGryAzM0wX7JdCswp3buUhk1AdgJuvAHDkkug/aSGKus0YRJfF4f5tDa+KBc6XfoxbhagNfcO6qg8BlZAI8S9ilka4rWL/37dB7j9y0gSMa6OSGJKnLXIH
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
index e72bafe63277..7e5d323f64a9 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -238,125 +238,6 @@ unsigned long rss_anon(void)
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
@@ -410,7 +291,6 @@ static bool is_range_backed_by_order(char *start, size_t len, int order)
 	const unsigned long nr_pages = 1UL << order;
 	const size_t folio_size = nr_pages * psize();
 	const int pagemap_fd = pagemap_fd_get();
-	const int kpageflags_fd = kpageflags_fd_get();
 	char *vaddr;
 
 	if ((uintptr_t)start % folio_size || len % folio_size)
@@ -431,7 +311,7 @@ static bool is_range_backed_by_order(char *start, size_t len, int order)
 				return false;
 		}
 
-		if (!is_backed_by_folio(vaddr, order, pagemap_fd, kpageflags_fd))
+		if (!is_backed_by_folio(vaddr, order))
 			return false;
 	}
 
@@ -575,12 +455,13 @@ int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
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
@@ -636,7 +517,6 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
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



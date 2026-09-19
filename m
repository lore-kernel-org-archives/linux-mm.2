Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF01C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60E56B00B7; Fri, 18 Sep 2026 20:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A126B6B00B8; Fri, 18 Sep 2026 20:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926366B00B9; Fri, 18 Sep 2026 20:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60EEA6B00B7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD1A6C0164
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:21 +0000 (UTC)
X-FDA: 85228617642.01.B6EA1E9
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf15.hostedemail.com (Postfix) with ESMTP id EEEB7A0005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="P dp0K7h";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=fPxIfBAm;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fa/WJc2cfEFuyIl50fDbtXrH+t+EEF5j2F2zkGzhbgo=;
	b=z5keD/eDhITsDXEH/CdM2+sMcBkLPkYuKHBlzAY2pvP63/4A2uKWOVMwsy+cS/VuLOIoXk
	3oSsV4NYC1HZlLrIpU/EbNNuqg6Bq/y+fMterCINVULJCO59jx7bV4RB+2E79XmFmnqLGh
	5HOIaoKF6oyNUwGHNMJF/M08wteymAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777520;
	b=jxMVfOCMx8W3NUmRhvsGIn+mN3HCN8H+bqrpF9ASN74yn75LG4EKc4Xa4TiZgGcP3R8Vbq
	3XYlJJ+eMIFF18b7OdrZ8AvxI2WFoKvwRhBLB2VsPJ55rSd8AACP54MeDWoMSTWPVWn1Qn
	DjWHBeHSLlDuVwFlyWbKktqag/6VoTs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="P dp0K7h";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=fPxIfBAm;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 883831400157;
	Fri, 18 Sep 2026 20:25:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 18 Sep 2026 20:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777519; x=
	1789863919; bh=fa/WJc2cfEFuyIl50fDbtXrH+t+EEF5j2F2zkGzhbgo=; b=P
	dp0K7hEqo2aY9AKX0qqbhmo0IHLrT66+pJkvcbdHc8SCAhxtUcKpeW0ECcWaGOxz
	PPUC7bhLh6jcVbm+rarofqzoz9Y060VoIVmFPylwAksIiycrnwtHasdATyqfDpw2
	eZGQJ4img2a4+ogJf2goujALnEYZ/fDT+yrVYTFw4vKVQnG5zyYWW8alMdGdldn1
	EJ/Ti133299GN+48XysoGGLfftu3e80or5MY9KCBucOiKasOUA7RTCqTDYZRz7hs
	3dzAsu8wgGySN4/W0cyQBt+Xh8BQqqjxCLcEPuW3HY5lMPFp3/a6Si5ClJUsToUc
	TukOqx6mFHHGvpTJA/48w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777519; x=1789863919; bh=f
	a/WJc2cfEFuyIl50fDbtXrH+t+EEF5j2F2zkGzhbgo=; b=fPxIfBAmqorJipw6l
	ZW0VjNuw/NDwAMzwiFD88fduiZs20i56kOQ6Hq610K3QFjqNTsJr9MJ/+ztsaNq+
	Vj92MuD8po0wn4Q8ELxQwi8Kb4KvEjdYLgGlI7zsAeYDyuvCGIa0ckm7n+VXDOgj
	CwScS+vHGv11plf+056tk8Gur4RZKlo0tTYybJ0rLt1aKhPC9nMvszPhKHuNaJxQ
	OcD9k7FOAkQDztWK6TPzXsb9+RKHRV2KLjDN0Pw3aC4yV8La11hSvZKF0kSjQJzo
	LyahbfRmbo7r/R49ifQhazTecBNvnmjCX0B8QoSMiBFctWx86wk10g62gdjPTXEG
	Y1OHw==
X-ME-Sender: <xms:b9atanbJwNt3-eLDlLvLD45xKJITlnwKMsMk7VnAEmW15_KVdw34vQ>
    <xme:b9atauxjIj2qEOfKHsFwSSPsiCHHdPo4tqfBqvPY0orYSYofukIuyglkgkVz5zlhj
    3CGxW5q8_uZIjkJfWa0kymohjoivbbW1BCeJohRDeR5qN4mnyRBpams>
X-ME-Received: <xmr:b9atasLrvt2SXRPg0nmGJ95TT6gSr5v5WuJuvrH0MbsG2w2bmtADYrBE43I>
X-ME-Proxy-Cause: dmFkZTEzseHgHAxanvosBbYuJPOsY+n0X5UbYs0PPazNY//kQZ3NkUWvwvZaeFG4K6MaM1
    51QpOH4aelOmHBptEhruNIkMmEsuOQeZbGrvL7mQj2kdmmCNYrJ7V/Gxu8ar4BzJpo5rV7
    vKP2ia7U0+Vm59vAPsz2JcwivFHP+0OmSoqV+JfA3yKlcOkTPrhdGkX4AgOHLm4XJUt5mM
    HeqMESXl6ibr/xrgjBd4IZM9oAbU6DWk9Q3+fqdUek4rHv8tNSmXbmq+2iLXuPMZjgN42W
    gGRNasGU39A5UL6wnmEy31YC46agADHTZYQX6KPmc3+B0CXfmIhRtSns1d+buSvmpYlDp9
    j6GFWtDjZQsGlRkbX/dsu0s7jWW7EO1cfRuTcY+UE8AlB0fR385acoC+SqLw4KEIHZVYJ7
    RlxUp8478WKHcL6UgnYOt4wMQncTQvzdsvR6I0RBACFW40USEQkXMs57QveT6Ne4KKR2H+
    wQoywy4x4VmaQ1j8BBLkeVJsZrBBZvRxo+kStTpfypsnYjJFHVKl739ROevHthakKZ3px3
    X0AjsgCwq5+SX1EC/zZkfGRo4pUP/LNFfhy3jP7rTTdsXUgzqHPJLIQXDvkB349nu5QT7w
    maSFRJwSnBZPgGl3Aq3hrwnONEIc3eFqh5MbHMqcoNf6L9rhy90NYVSstmVw
X-ME-Proxy: <xmx:b9atalffUHbnO-iTP56kBURuoi-6r_3C5k3J9LrGslLzGCthGxkGrg>
    <xmx:b9atakurHKm4Y-nhDLsdEmnorIjO9CEwvQyWAXly6lYYlIe0lwrN8Q>
    <xmx:b9atajGwTfq59x9dtP0l3GaIKGiFrMnYKbNBuUKb7VC4yD-3dCtxvQ>
    <xmx:b9ataue0fe44NmnnTk1lO-QjsocNRen6KxNZ-kE_q68CRA-eVRTR6A>
    <xmx:b9atagjUn2fobPlVnFDi2P1r9ggNjeukCDJQCO2jY4AH7Th4DNE_4KA2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:18 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 11/19] selftests/mm: add order-parameterized khugepaged collapse cases
Date: Sat, 19 Sep 2026 01:24:41 +0100
Message-ID: <20260919002451.496763-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sd7cb5wji8zqobtosk8et4geynxkzuub
X-Rspam-User: 
X-Rspamd-Queue-Id: EEEB7A0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789777519-58629
X-HE-Meta: U2FsdGVkX191a2TxkUCHVsDkSHl3XgfqXH/THhNKmLkwp9RVeRsQhhEDNiVywUf87rmHQs3HBpjq1AYjHI8sdkt5aZcNdLA0voT4000JyT4HPtJKwOPSDEOZvzEcqfwsiDUfFi6/cEXJHn7VBbH6VF3Nu7w9wItDBGgNvSUvwo9/pq3XRRvs+kh5tKkKy6EITuSKiaKK92U0ZpLBAuZI6feBjcuR49hffZf8JVcULTVKRLcrtIv0BynClgrbTICR+fO0Y2+KY6Zp5g5QdUkJc0HvPbQTtCneXLkeDcPUAzZB3e1YqxPRVzsGWGQAI1Oy3FbPfG2uCgNQJOEOkmZsTxMYKL6wwbwquOeW1yuoZdP6J+uO0S/7Z0sea5zreURIfE9Iqa+T+WHyZP2oIisT3W5gTwkJgpd51oCigg5H7IKS/7e9CboSWjlR+A+VVlo4t7SYeG/Q0idVnShb4omkSwdXPXo6oO1yD9jH3ckCYmTMi5x25Y0tcoGL3i46BNCC+Nwim89Ha7uIXW4U7msrSdVNa4teeGN6zhnL0D9h8ZdCa6sApHCuIIEdjDQiXHFDABoWhGSqD7fe20rOjvboFzThe3m0o5mbUmRd8A2vEwPLwnA8TusC5HGXwyVO9WE/fnyZHxdokoMLJ8h4Vg5KPCbmsgpmN5BT/XJXXYxX/gottsxQzstf5GliLZ+f7WTrr6UtuMDeA1cUCag5mhEY5+jXMqfNKnaEaWlVt1gnVuqafFvGE/GUeyNKfZUWqiFQNtIvwuviQm6n1bKIQvGs30fdasa5ubY6rnzqDyjhSvTSg7dVTsp+GYNXoCtug3rw76laC4xH0UWgs7yYx1K6H2V8EvuYNyQx0JIA/xr64HVDD5APH2rZNglU7SrDQZwe2cWlcvMtUJgp7Um+XmNMaLOxpcodkVu4hth8E9TcO6fthpWq/XHr5mEbsJKp6eClDcpLBR7OaHLVqNvzBk2
 C13Gr+xv
 390s2DfzKCZDprZM4KCb1LzU+05EXcph6TTYPQe+M1UkGWV1rge+/JKjzoFC+z9bFXQrshkgiE0sydYstoTyridVMUNtX7NIHgUx6pp+8V2XWdh6UL2jmLx3WQGN/rxkJQ0uofbgQw/0Af5uB2/gAOYrCU9g2tjWoKHDUHiMl0dEMYgk4ddIYRD8M04L/P+/G+UvGOb+B/Kmi3cudX/fNqG3k0at+wagTqjfwAe2oAK+og922VH8CHeYDglQaMt8JUhSIc0ftyt2KJ18wngxIM63kcf43b+l4deXYRChBjk+mKUhrkYeut/vFdxMAbmuKb63XCiav3R2yGhJPIavEXQ0v6wZrrctAJ9YIDEBH8ldmPN3etK2dgi4JadmO0tqFAYs/Va6l/febhxzkEatF1/9O6G+j4CQTsDU/Xu0P4HLp80gejOroK4VoRssA5u7waTOgpNK6GFJDdkzvGjbnX4vvvhZqTC857P4pQEajx0B6JwD9ZnFOqmpdzfo5VsmYMQ//
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The mthp_khugepaged context runs the generic cases at a sub-PMD order,
which answers how many folios of that order a range ends up with.  It
cannot say which order-sized window they landed in, so "the populated
window collapsed" and "the empty window next to it collapsed instead" look
alike.

Add four cases that check each window on its own, with the folio-order
helpers in vm_util:

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

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 212 ++++++++++++++++++++++++
 1 file changed, 212 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index e013eebc7136..51bda01446cd 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -30,6 +30,8 @@ static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
 static int collapse_order;
+static int pagemap_fd = -1;
+static int kpageflags_fd = -1;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -1209,6 +1211,198 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
+/* Smallest order khugepaged will consider for mTHP collapse */
+#define MIN_MTHP_ORDER 2
+
+/* Time budget for one khugepaged pass in the collapse_order_* cases */
+#define MTHP_PASS_TIMEOUT_S 30
+
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
+	 * Only the target order, and only for madvise: the cases fault their
+	 * region first, so the sources stay order 0 whatever -s asked for.
+	 */
+	settings.thp_enabled = THP_NEVER;
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	settings.hugepages[collapse_order].enabled = THP_MADVISE;
+	thp_push_settings(&settings);
+}
+
+static bool all_windows_at_order(void *p, size_t len)
+{
+	return is_range_backed_by_order(p, len, collapse_order,
+					pagemap_fd, kpageflags_fd);
+}
+
+static bool any_window_at_order(void *p, size_t len)
+{
+	size_t window = mthp_window_size();
+	char *addr = p;
+
+	for (; len >= window; addr += window, len -= window) {
+		if (all_windows_at_order(addr, window))
+			return true;
+	}
+	return false;
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
+	if (any_window_at_order(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	ksft_print_msg("Collapse one fully populated window...");
+	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
+		fail("Timeout");
+	else if (all_windows_at_order(p + window, window) &&
+		 !any_window_at_order(p, window) &&
+		 !any_window_at_order(p + 2 * window,
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
+	if (any_window_at_order(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	ksft_print_msg("Collapse window with single PTE entry present...");
+	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
+		fail("Timeout");
+	else if (all_windows_at_order(p, mthp_window_size()))
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
+	if (any_window_at_order(p, hpage_pmd_size))
+		ksft_exit_fail_msg("Unexpected large folio after fault\n");
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	ksft_print_msg("Collapse full window, not the one missing a page...");
+	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
+		fail("Timeout");
+	else if (all_windows_at_order(p, window) &&
+		 !any_window_at_order(p + window, window))
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
+	settings = *thp_current_settings();
+	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	thp_push_settings(&settings);
+	p = ops->setup_area(1);
+	ops->fault(p, 0, hpage_pmd_size);
+	thp_pop_settings();
+
+	/*
+	 * The allocator can fall back to smaller folios under fragmentation;
+	 * having nothing to collapse from is not a failure.
+	 */
+	if (!is_range_backed_by_order(p, hpage_pmd_size, MIN_MTHP_ORDER,
+				      pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("No order-%d sources to collapse...",
+			       MIN_MTHP_ORDER);
+		skip("Skip");
+		ops->cleanup_area(p, hpage_pmd_size);
+		thp_pop_settings();
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+	ksft_print_msg("Collapse region backed by smaller large folios...");
+	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
+		fail("Timeout");
+	else if (all_windows_at_order(p, hpage_pmd_size))
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
@@ -1377,6 +1571,20 @@ int main(int argc, char **argv)
 
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
@@ -1427,6 +1635,10 @@ int main(int argc, char **argv)
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



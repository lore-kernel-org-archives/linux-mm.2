Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4783ACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12A56B009E; Tue, 29 Sep 2026 09:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C39B6B009F; Tue, 29 Sep 2026 09:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9076B00A0; Tue, 29 Sep 2026 09:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67A626B009E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:15:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 016E9A04CE
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:15:34 +0000 (UTC)
X-FDA: 85266846588.29.67D65E5
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf21.hostedemail.com (Postfix) with ESMTP id 002071C0010
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:15:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="r BSfudP";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=fELLyLhJ;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790687733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LUfrXRyLCdFRoiMVwG+yyWGldHAqH9d7f7m5wCQeUU=;
	b=WycgCDbTAsldGCGv4ioUOjj59FfPvj8C/L2gpFRduTFzk2cXa3tcnJRg/tZe/U7DHLMinM
	JJizb+HariyHQoCXjk0+s80eZ8eQl185z4dqwLsSk+D+Gsok4LLI1sDus9vTsfsPdTlIwq
	+1XqwzlF4xQAnRPOwQgkgi4Jw1h2XcA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790687733;
	b=gkr6uvmdEm7RuoHs2YXdP++4G+3XCQkgzLcEei8vxfzi7PkbjigOUAlomPVgx1q24wIQyi
	4eKx/uV8I6OCeCOlM7XAj12/s+5yJ0xcL/O24i6CjihqKfXoPjRzUFbULYEGie4pL2FQkP
	SWGxGytCgtiGE7bFi7lNCi/+7DmKWbs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="r BSfudP";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=fELLyLhJ;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 776271400FA9;
	Tue, 29 Sep 2026 09:15:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 29 Sep 2026 09:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790687732; x=
	1790774132; bh=5LUfrXRyLCdFRoiMVwG+yyWGldHAqH9d7f7m5wCQeUU=; b=r
	BSfudPkuD9HQ/fCZ64h4Ea8gGGsWC7ZSfw31OFc0h87oPSvZWbgoXsnveKScK42V
	hH1K/NBGltpPjddpK2fa+/chDz+Bat294BB2rLhbnGB68n1w5jH7AHWctOeNeXfI
	uh36g//YmI6d72rUMS9lLZCPKcl/yiPBhK2ReVzy0V0+2acWWZo0dnTU8g85WjKP
	3VbX9LKsyeD0hobfrADn/6K6fjE/PxJTgUrpXPLC86Jxss+RyjQ47BtJ92cQeuxR
	ZpPL+GHrpZTI2l+NUjR4yOiUhLR7lBAAiry+GcrCTcvHZtXJuMWKcTAieNKH05O9
	3MYAY+t875uE91hP7wbng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790687732; x=1790774132; bh=5
	LUfrXRyLCdFRoiMVwG+yyWGldHAqH9d7f7m5wCQeUU=; b=fELLyLhJ0ETR9EUni
	w33n3z3frwQO+9viQ8mByhYN+cyqv3CkSygmNFwWS7JHV9Af3V/6uRUnmubC7Yj2
	+7puJowlrAzpYnJDygOwlIAdClL5OcccThSFhb8WwAPcKTxxeFZCUHOjME/JqXuc
	eaSq8jDZBao5vz0po1REEegHsfZuCouA1ukB96iVSKrdLouAFE28Z43f3gi/lz5w
	NDRiW6n6BT5HKQfHC/z2B+yF8zHUdBUxI7NteL1Fys2QF8cn/XHOYxsz8klFsPgL
	Wzso+mluJIKlpGJWO2ZRxToe91v4scxcroOHgXQPJQ5/oSvQeNgevoLnPQZhDRjF
	RAsOQ==
X-ME-Sender: <xms:9Lm7aopz1gC39FXvjzmWSx9OAnzFE9x_4j-mDR8ohRfHXGSbbKVxaQ>
    <xme:9Lm7agQ1HkxAZtX1SUNfjRqn5_7j-GBmbRpsV0uw98n-i2ilBfHzn1rOnqlmb8s_v
    IbpLzAw2jhm6ODAezwX9LxKN-T7OZMMltiTFTkcXsrs9U-Pt_ObJhm->
X-ME-Received: <xmr:9Lm7ahQQ8Eosw50S21LZlNOI7abhFZ3VJrU1xSfd4cAmzjM0yPQMuheo0mU>
X-ME-Proxy-Cause: dmFkZTFOfxfIFB7Dof8MQ0ob0YOYZEeiJaQRd8Ge2o8s43JQBWK37zdhQkq0XKYCwyywIg
    ZiGTtKXHoUljwzASlUEqjkV2UiU5ISCyg4jFvPfvIP9aIL98y8KUyJ9/8nxAgQVzOno5ir
    gOyA9ix1zjXD9/21H1LXhnhqMhLomFu/ViqkjFAXC9CKAfQMEv8+8xSZHkEVnRS9GvI0hU
    Kv/GBbpDcDsB+T2kAW8zM2iBszjip0w6LYLK/BIQnmNfYTMqFl7tu75C+ED+3K9BUbd39w
    gpffHgcOGSxmIwtsFGo7ZDjX2aGXL0benmT0LYISRxT/k3lDpt602p+lCE+0O7nNMuhtnp
    cUdzu6bShxQSzrvuxCwuQnclYDBJCjYYPjFFvCsdkG+xP5sSENkj9xcX5I1ZT1f1L9MvCB
    LxkjkjmApstjazCw5L/jI9UAF32bSQEKefO7ucDBfY2PYe0Xt/Cp9/NYaLSWH6PQCcN4XT
    /JHxKPl/lGOcMYB30BlHO45qjLhXZdcCjZ6a0kP0MitDNqLsezKv3cPQKvhoGKmZ+R+SHN
    wxoYS4gQC43KyajqTo5qH5eUo2LPibHK8ejrEzBl+Op8UdHmlvSWTWCGUNIN9uC36eDTV9
    qaWEoYuIrmJtl5s6+4l8JHogBLUUimaRo5WUWIR1RbS73jaElL+3h+vvqwJg
X-ME-Proxy: <xmx:9Lm7amV3Koe0yHXSNwe5f5jl-T_0iU912AlGPv1-cV6HdKhabp14Tw>
    <xmx:9Lm7am0wcClFP8GsVTw1QlhlnsqU5_LuAmD633C0mh0aurEjskNjEA>
    <xmx:9Lm7at9_E50EeS1vp3nVRXLH9gRV9LSeKZYwvBWOP0gu_NrePWribw>
    <xmx:9Lm7asfc7wGQf8VftouYVXyPHETt7W_xDq5mWA2OMdNb3oMvns7IIQ>
    <xmx:9Lm7av7leO9B4v3_WbGaO5vlYK-dUuIP_g0ucE4-l7YSFGCNcntKu576>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Sep 2026 09:15:31 -0400 (EDT)
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
Subject: [PATCH 3/4] selftests/mm: check collapse results through check_huge() only
Date: Tue, 29 Sep 2026 14:15:18 +0100
Message-ID: <20260929131521.153079-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929131521.153079-1-kirill@shutemov.name>
References: <20260929131521.153079-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 002071C0010
X-Stat-Signature: rkktrggzc4c9jbndonw4wn4c7cyscssb
X-Rspam-User: 
X-HE-Tag: 1790687732-680338
X-HE-Meta: U2FsdGVkX19dzFGeDAmj4Tc1V/+i4eduvoO+DO/hT2x87wDkH8sJO//QHjJFBd8QvvO1Qqgm5yGb//lXy5VwPC5eRHxtAt5jbrORSGcg33ifLDk0CD1L1NzqNUBWuMDbdag2tYPhrp4yqPDnCZF2pMwbHYaat5paBc27KsssONjmJxHBgZ2dIRk0OoRJb9TziSwU4pdM61iVlluKTJ8C+ENC1vsvCaTlPC/EGWyboFsrWRXtkVFPgz22+KxSa0xSnOTrpocz4C8LVX1JTrp/xaQvX3mQ4QPKUA/y3MYaFcGXW/nqiyp7MYMkznhELqdYZsWmtB24hOqnfip1yBNLUqLIzXxgXkPj0NQwks1mJ3PQ1CvJW1bZldtvVzzKp5OTmxvG3/qara7Zmde5TJkLMCy/7oHq1QfoF32b4GBRqBCnbXtWZQOJDsBPOOqtFlpIq/elQVhxymlRIa887jyNmAneemb1W9jbUg4itSKloEvUKZ4T5xp9Y/tytHvL4oVprSywz4j74dOfhdTovy38X6OMpFaT1jR/A7P/72x++lN2v+luIMxr5cM6TJqn2AbfL2X3Ze4WUBD17N8OWoArH1/bCpDxebx5MjmYg3ORy3CaeyO1hLm8Xp0+cdS6E8ZtoSo6grgSs1Rr8riZ1mKvyTHnMzaBDDrjLmIFFGvkpeUyJknQ/hA82R3/sgjoSVhD+73nL8KGMA5rL3NuozKrLD0KWZK3QEmH/u/uRr5ZRQpRwu14R/OeFz3Ecm0WJVnFtd9t3rOY+dAklv4XZ0jKlVT3Bu8AVP/L4kap6Y1Wv6MZeuUw+iWnEpiLRXJuZY4UGldnB1+eFZrb0R9mZItIIzS3OfJSenNfLRqEHrNPT83/jAGY63oSilFPQfEV7zopjhiVasq/meVIkyvMAjf4l1msgkaT3itqmmZkRQy1da7kbqOnXuT45aiH/TVyQ9NnjhZr+ggbtqZnLHwrtJ/
 2l6NfDnS
 hQ1qkoidXAVFJXM6YBVPadLedLoqHb4hD8ThXgKGdD5XpxKsldYEo2T6EzCz6dPD/4ydkAdCRX0qqfVNAy/cFved6idWaFFu+S6teT758JfdNoaJhCSjiIl5FXRUizECOrCU7hyDr/WijgeLbSvnYmyOmOQvM6A/pYZiCvWjg7Tt+oF0MhmMZwH2h+Hh+UT3Eah0f7dNT4Aawj+Hqte1IJ0fk0RKBQNFUSWsQjMBdiEdZYTnx3ZGv2mQJS9poXHDhy6cjyniQpYHCdxpM3MCy0ph/0FrUqtdOFRV1wsYK/IhUXwxeV9dyS6Y+FyGVXVsXfaiNEsXQ37nLj3fPKAQ7vZAI167hQg8ug1YZcXxAc/I0Wrf5ig3o+/zs7La2GVB6hxn2m7Txq9I5J3M81FGHuW0y90zobj2dAXXR6hg2uL+XduH0XgLwJV8PhIizOFhIGJ63IhF2coK9l9G5GW7NQ9RS1jGz/9YLKooZf4xuMLHXuF4LEgKdLVspwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

khugepaged.c checks collapse results in two ways.  Generic cases go
through the mem_ops check_huge() callback.  collapse_order_* cases call
is_range_backed_by_order() on descriptors of their own.  Baolin Wang
found that confusing.  The split only existed because check_huge()
counted folios instead of windows.

Now that check_huge() checks windows, the two give the same answer.
Use the callback for the collapse_order_* cases and drop the private
descriptors.

Convert khugepaged_sync_check and folio_order_check the same way.  The
latter still checks that each order is detected as that order, not as
the one below and not as order 0, only now through check_huge_anon().
At the PMD order that means the PMD-mapping check rather than the
page-flag walk.

is_range_backed_by_order() has no users outside vm_util.c left.  Make it
static and let it use the cached descriptors.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../testing/selftests/mm/folio_order_check.c  | 28 +++--------
 tools/testing/selftests/mm/khugepaged.c       | 47 ++++++++-----------
 .../selftests/mm/khugepaged_sync_check.c      |  7 +--
 tools/testing/selftests/mm/vm_util.c          | 19 +++-----
 tools/testing/selftests/mm/vm_util.h          |  2 -
 5 files changed, 34 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/mm/folio_order_check.c b/tools/testing/selftests/mm/folio_order_check.c
index 5eafbcc1b4f3..aa0586047620 100644
--- a/tools/testing/selftests/mm/folio_order_check.c
+++ b/tools/testing/selftests/mm/folio_order_check.c
@@ -1,13 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Self-check for the vm_util folio-order helpers, is_backed_by_folio() and
- * is_range_backed_by_order(), which the khugepaged mTHP cases use to detect
- * collapse results.  For every anon THP order the kernel supports, fault
- * memory in with only that order enabled and require the helpers to report
- * exactly that order.
+ * Self-check for check_huge_anon(), which the khugepaged mTHP cases use to
+ * tell collapse results.  For every anon THP order the kernel supports,
+ * fault memory in with only that order enabled and require the check to
+ * report exactly that order: not the order below it, and not order 0.
  */
 #define _GNU_SOURCE
-#include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
@@ -17,9 +15,6 @@
 #include "vm_util.h"
 #include <mm/hugepage_settings.h>
 
-static int pagemap_fd;
-static int kpageflags_fd;
-
 static char *alloc_aligned(size_t size)
 {
 	size_t len = size * 2;
@@ -56,22 +51,20 @@ static void check_order(int order)
 	p = alloc_aligned(size);
 	*p = 1;
 
-	if (!is_range_backed_by_order(p, size, order, pagemap_fd, kpageflags_fd)) {
+	if (!check_huge_anon(p, size, 1, size)) {
 		ksft_print_msg("order %d not detected after fault\n", order);
 		ok = false;
 	}
 
 	/* A lower order must be rejected: the folio is larger */
-	if (order && is_range_backed_by_order(p, size, order - 1,
-					      pagemap_fd, kpageflags_fd)) {
+	if (order && check_huge_anon(p, size, 2, size / 2)) {
 		ksft_print_msg("order %d also reported as order %d\n",
 			       order, order - 1);
 		ok = false;
 	}
 
 	/* A large folio must not pass as order 0 */
-	if (order && is_range_backed_by_order(p, size, 0,
-					      pagemap_fd, kpageflags_fd)) {
+	if (order && check_huge_anon(p, size, 1 << order, psize())) {
 		ksft_print_msg("order %d also reported as order 0\n", order);
 		ok = false;
 	}
@@ -93,13 +86,6 @@ int main(void)
 	if (!thp_available())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
-	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-	if (pagemap_fd < 0)
-		ksft_exit_fail_perror("open(/proc/self/pagemap)");
-	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
-	if (kpageflags_fd < 0)
-		ksft_exit_skip("open(/proc/kpageflags) requires root\n");
-
 	orders = thp_supported_orders();
 	if (!orders)
 		ksft_exit_skip("No supported THP orders\n");
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 61bd69d604d2..a5b682eca888 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -33,8 +33,6 @@ static int collapse_order;
 static bool collapse_order_set;
 static int collapse_orders[NR_ORDERS];
 static int nr_collapse_orders;
-static int pagemap_fd = -1;
-static int kpageflags_fd = -1;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -1330,19 +1328,20 @@ static void mthp_push_target_order(void)
 	thp_push_settings(&settings);
 }
 
-static bool all_windows_at_order(void *p, size_t len)
+static bool all_windows_at_order(struct mem_ops *ops, void *p, size_t len)
 {
-	return is_range_backed_by_order(p, len, collapse_order,
-					pagemap_fd, kpageflags_fd);
+	size_t window = mthp_window_size();
+
+	return ops->check_huge(p, len, len / window, window);
 }
 
-static bool any_window_at_order(void *p, size_t len)
+static bool any_window_at_order(struct mem_ops *ops, void *p, size_t len)
 {
 	size_t window = mthp_window_size();
 	char *addr = p;
 
 	for (; len >= window; addr += window, len -= window) {
-		if (all_windows_at_order(addr, window))
+		if (ops->check_huge(addr, window, 1, window))
 			return true;
 	}
 	return false;
@@ -1358,7 +1357,7 @@ static void collapse_order_single_window(struct collapse_context *c,
 
 	p = ops->setup_area(1);
 	ops->fault(p, window, 2 * window);
-	if (any_window_at_order(p, hpage_pmd_size))
+	if (any_window_at_order(ops, p, hpage_pmd_size))
 		ksft_exit_fail_msg("Unexpected large folio after fault\n");
 
 	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
@@ -1366,9 +1365,9 @@ static void collapse_order_single_window(struct collapse_context *c,
 	ksft_print_msg("Collapse one fully populated window...");
 	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
 		fail("Timeout");
-	else if (all_windows_at_order(p + window, window) &&
-		 !any_window_at_order(p, window) &&
-		 !any_window_at_order(p + 2 * window,
+	else if (all_windows_at_order(ops, p + window, window) &&
+		 !any_window_at_order(ops, p, window) &&
+		 !any_window_at_order(ops, p + 2 * window,
 				      hpage_pmd_size - 2 * window))
 		success("OK");
 	else
@@ -1389,7 +1388,7 @@ static void collapse_order_partial_window(struct collapse_context *c,
 
 	p = ops->setup_area(1);
 	ops->fault(p, 0, page_size);
-	if (any_window_at_order(p, hpage_pmd_size))
+	if (any_window_at_order(ops, p, hpage_pmd_size))
 		ksft_exit_fail_msg("Unexpected large folio after fault\n");
 
 	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
@@ -1397,7 +1396,7 @@ static void collapse_order_partial_window(struct collapse_context *c,
 	ksft_print_msg("Collapse window with single PTE entry present...");
 	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
 		fail("Timeout");
-	else if (all_windows_at_order(p, mthp_window_size()))
+	else if (all_windows_at_order(ops, p, mthp_window_size()))
 		success("OK");
 	else
 		fail("Fail");
@@ -1422,7 +1421,7 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
 
 	p = ops->setup_area(1);
 	ops->fault(p, 0, 2 * window - page_size);
-	if (any_window_at_order(p, hpage_pmd_size))
+	if (any_window_at_order(ops, p, hpage_pmd_size))
 		ksft_exit_fail_msg("Unexpected large folio after fault\n");
 
 	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
@@ -1430,8 +1429,8 @@ static void collapse_order_max_ptes_none(struct collapse_context *c,
 	ksft_print_msg("Collapse full window, not the one missing a page...");
 	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
 		fail("Timeout");
-	else if (all_windows_at_order(p, window) &&
-		 !any_window_at_order(p + window, window))
+	else if (all_windows_at_order(ops, p, window) &&
+		 !any_window_at_order(ops, p + window, window))
 		success("OK");
 	else
 		fail("Fail");
@@ -1447,6 +1446,7 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 					 struct mem_ops *ops)
 {
 	int source_order = anon_order ? anon_order : MIN_MTHP_ORDER;
+	size_t source_size = page_size << source_order;
 	struct thp_settings settings;
 	void *p;
 
@@ -1470,8 +1470,8 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 	 * The allocator can fall back to smaller folios under fragmentation;
 	 * having nothing to collapse from is not a failure.
 	 */
-	if (!is_range_backed_by_order(p, hpage_pmd_size, source_order,
-				      pagemap_fd, kpageflags_fd)) {
+	if (!ops->check_huge(p, hpage_pmd_size, hpage_pmd_size / source_size,
+			     source_size)) {
 		ksft_print_msg("No order-%d sources to collapse...", source_order);
 		skip("Skip");
 		ops->cleanup_area(p, hpage_pmd_size);
@@ -1486,7 +1486,7 @@ static void collapse_order_mixed_sources(struct collapse_context *c,
 		       source_order);
 	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
 		fail("Timeout");
-	else if (all_windows_at_order(p, hpage_pmd_size))
+	else if (all_windows_at_order(ops, p, hpage_pmd_size))
 		success("OK");
 	else
 		fail("Fail");
@@ -1715,15 +1715,6 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (mthp_khugepaged_context) {
-		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-		if (pagemap_fd < 0)
-			ksft_exit_fail_perror("open(/proc/self/pagemap)");
-		kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
-		if (kpageflags_fd < 0)
-			ksft_exit_fail_perror("open(/proc/kpageflags)");
-	}
-
 	setbuf(stdout, NULL);
 
 	/*
diff --git a/tools/testing/selftests/mm/khugepaged_sync_check.c b/tools/testing/selftests/mm/khugepaged_sync_check.c
index 28a9b1ff5d44..40cba121a987 100644
--- a/tools/testing/selftests/mm/khugepaged_sync_check.c
+++ b/tools/testing/selftests/mm/khugepaged_sync_check.c
@@ -26,7 +26,6 @@
 #define PASS_TIMEOUT_S 30
 
 static int pagemap_fd;
-static int kpageflags_fd;
 static int trace_events_fd = -1;
 static unsigned long hpage_pmd_size;
 
@@ -116,8 +115,7 @@ static void one_step(int iteration)
 	if (!passed)
 		ksft_exit_fail_msg("khugepaged did not complete a full pass\n");
 
-	collapsed = is_range_backed_by_order(p, window, TARGET_ORDER,
-					     pagemap_fd, kpageflags_fd);
+	collapsed = check_huge_anon(p, window, 1, window);
 	attributed = count_attributed(pfns, nr_pages, TARGET_ORDER);
 
 	ksft_test_result(collapsed && attributed == 1,
@@ -146,9 +144,6 @@ int main(void)
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_perror("open(/proc/self/pagemap)");
-	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
-	if (kpageflags_fd < 0)
-		ksft_exit_skip("open(/proc/kpageflags) requires root\n");
 	trace_events_fd = tracing_events_open("huge_memory");
 	if (trace_events_fd < 0)
 		ksft_exit_skip("huge_memory events require tracefs and root\n");
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 0a4b85e29e14..4c0d0e6f2553 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -401,8 +401,6 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
  * @start: start of the range, a multiple of the folio size
  * @len: length of the range in bytes, a multiple of the folio size
  * @order: the folio order to check for
- * @pagemap_fd: open /proc/<pid>/pagemap of the range's owner
- * @kpageflags_fd: open /proc/kpageflags
  *
  * Every folio-sized, folio-aligned part of the range must map one folio of
  * @order, head to tail, with the head at the start of the part.  A part
@@ -411,11 +409,12 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
  *
  * Returns: true if the whole range is backed that way, false otherwise.
  */
-bool is_range_backed_by_order(char *start, size_t len, int order,
-			      int pagemap_fd, int kpageflags_fd)
+static bool is_range_backed_by_order(char *start, size_t len, int order)
 {
 	const unsigned long nr_pages = 1UL << order;
 	const size_t folio_size = nr_pages * psize();
+	const int pagemap_fd = pagemap_fd_get();
+	const int kpageflags_fd = kpageflags_fd_get();
 	char *vaddr;
 
 	if ((uintptr_t)start % folio_size || len % folio_size)
@@ -448,16 +447,14 @@ bool is_range_backed_by_order(char *start, size_t len, int order,
  * size each, with the folio's head at the window start.  A folio mapped off
  * its alignment or split across two windows counts for neither.
  */
-static int count_windows_at_order(char *start, size_t len, uint64_t hpage_size,
-				  int pagemap_fd, int kpageflags_fd)
+static int count_windows_at_order(char *start, size_t len, uint64_t hpage_size)
 {
 	const int order = sz2ord(hpage_size, psize());
 	int nr_windows = 0;
 	char *addr;
 
 	for (addr = start; addr + hpage_size <= start + len; addr += hpage_size) {
-		if (is_range_backed_by_order(addr, hpage_size, order,
-					     pagemap_fd, kpageflags_fd))
+		if (is_range_backed_by_order(addr, hpage_size, order))
 			nr_windows++;
 	}
 
@@ -486,7 +483,7 @@ static bool check_huge_type(uint64_t categories, enum check_huge_type type)
 static bool __check_huge(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size, enum check_huge_type type)
 {
-	int pagemap_fd, kpageflags_fd;
+	int pagemap_fd;
 	int nr_pmd_mappings = 0;
 	uint64_t pmd_pagesize, scan_mapping_size;
 	uint64_t categories;
@@ -505,11 +502,9 @@ static bool __check_huge(void *addr, size_t len, int nr_hpages,
 	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
 
 	pagemap_fd = pagemap_fd_get();
-	kpageflags_fd = kpageflags_fd_get();
 
 	if (!check_pmd_mapping &&
-	    nr_hpages != count_windows_at_order(start, len, hpage_size,
-						pagemap_fd, kpageflags_fd))
+	    nr_hpages != count_windows_at_order(start, len, hpage_size))
 		return false;
 
 	for (; start < end; start += scan_mapping_size) {
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b5d59729d432..2bf64d5b42aa 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -102,8 +102,6 @@ int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 			int kpageflags_fd);
-bool is_range_backed_by_order(char *start, size_t len, int order,
-			      int pagemap_fd, int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0



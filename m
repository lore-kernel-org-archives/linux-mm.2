Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8EF0CA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 05:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4146B0008; Wed,  3 Sep 2025 01:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5386B000C; Wed,  3 Sep 2025 01:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC7E6B000D; Wed,  3 Sep 2025 01:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFEB96B0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:46:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4072D5885E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:46:51 +0000 (UTC)
X-FDA: 83846855022.23.4DC73C9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35A14A0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:46:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756878409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Z58CnCvGqyK7sajlRmZg0CLT8oTakvjhA+ekt0QMIU8=;
	b=4MrdZLV1L9UB++WR4pZ1+Dzy3KSyqZvbXLTJVgqXuCgDI876XwgQuq+B00IxpbjGoq12CG
	s0vnBS5id1gk2XNqOvvT2wuyXrqyjO1pt6YwAvfLpHdcVnPeMjpg+eFa77N9INaVUcqj9Z
	xPh+pZ8w3ecEk4KTCCXIVip9OfeAdDI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756878409; a=rsa-sha256;
	cv=none;
	b=uTXYpUSrev67r34Ep4nVpe6bpYodxgsi/9fTb2vvduaaTJmfws89A6SsfpRXKEandUJOk5
	B3YpzMiW45gjp6S4alZIGTxvTiBsrmVC5A42uBWY6qPwo51b+UWvJogEzEAMie/0rsooLR
	tCA58aXd+kxesB6VKdgC9cHCYDIJPU4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C17EF1691;
	Tue,  2 Sep 2025 22:46:39 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F2F7A3F694;
	Tue,  2 Sep 2025 22:46:43 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	kas@kernel.org,
	willy@infradead.org,
	hughd@google.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
Date: Wed,  3 Sep 2025 11:16:34 +0530
Message-Id: <20250903054635.19949-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: app6bbapgq41dh15whneoawyqy5tb11z
X-Rspam-User: 
X-Rspamd-Queue-Id: 35A14A0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756878409-494500
X-HE-Meta: U2FsdGVkX19mZi4+7MqT9Q0lbfQilNkLNiBeAtezNAFJDH+PLTfDmSjz9457OwAI+RJJjpOYo4nUGOX/WxLmMQ9qOgOV2xNeUT71EJ7AEWqVhB7gGH2fQ+TadKbQ7x4SxHWQHoIUCaVSG91J9mUwUOtxgaNeXabq+K7T2/GoNYVGKkQRcANlvaI99JMfKLTh1gHbZov7t+mUy0BAC/d7AeIIRnBAUejVJTY4oHYjzEnuQ7NVuEqMr2aoANYXu+2p1Tx2Nmwm+PEay61GtS/f2C383LVqWywA+hDgk4dKt+AMTzS4BAPrITcsh0gcWgMKmq/yfsVptBk+oJ6vTPG5/5xs7+gNrJ0Yt7cO3/N9LvstmR0df/+D11OnwrLxBsTfGOBs6K84ztrJi8S9e10IYhy3H6C1/IjfFOAnSRVLChVEjlg2oZ9e3vNmZo7OsqfiQD88yGF6rVtN58fBGCE3khB5S5HkkWL8OfIj6ww9m5gHb9aRku7+cjvBoeLaqCzSvYdqVhnCzIDAE32fVKk/BbKxq+RgKnbcJGemrmQ1ETA46aMRL5WXYIgXc/ckWvLC/1JmYP3BqCXMx+LXUvO+rTqDaAQIja8w7ZXfRvJb5Fokwj94K3/1f6trGxWIBZ7AguBhBbybih8z8e5QRhONdY0LhXUOg1Wtp/+gQKDvRhS57+7FLar6kJFkuLfCAzcdCxOhQqZAhKERXKiplghPAcCC/829xziVyUfo87npjRn0u6JFkl/fPTxaNgvmYA4/9emgDwExBUzZTf2g7C/EAzueHMLCk6t8svcwoxKbRTYe2/EEiaxGHILvy9D6hjVjUGP9kjmZGewiRImk/VlQrnGWOi5ZStrHPHbjJwnS9D8uXEerJeP6XePU/qvkm6682jYd5L6HI8N6jnUbu16AsvpFsCFnEDajt6JPQ8Jf7yFfR/R0pgD7AltK4gC134SRbn54xDnIiMIVFjRMHo4
 74kMu3q5
 QPPmy3qvJ2RneEWONUCkqyi7D66Xkcs66imLifKg5jrHHoH4PBBrOGdoHjQEfCUFpxhe5EyxTqYpI1+w6XlKTYoi9JF3J5IXr1+80j3SRvK9L0SAk20JNc0EN80UKkavK0FSQx9hR38HWoI1VrA8jwHAollxnnEmPjW2HaLo7el12wcg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently khugepaged does not collapse a region which does not have a
single writable page. This is wasteful since non-writable VMAs mapped by
the application won't benefit from THP collapse. Therefore, remove this
restriction and allow khugepaged to collapse a VMA with arbitrary
protections.

Along with this, currently MADV_COLLAPSE does not perform a collapse on a
non-writable VMA, and this restriction is nowhere to be found on the
manpage - the restriction itself sounds wrong to me since the user knows
the protection of the memory it has mapped, so collapsing read-only
memory via madvise() should be a choice of the user which shouldn't
be overriden by the kernel.

On an arm64 machine, an average of 5% improvement is seen on some mmtests
benchmarks, particularly hackbench, with a maximum improvement of 12%.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
RFC->v1:
Drop writable references from tracepoints

RFC:
https://lore.kernel.org/all/20250901074817.73012-1-dev.jain@arm.com/

I can see performance improvements on mmtests run on an arm64 machine
comparing with 6.17-rc2. (I) denotes statistically significant improvement,
(R) denotes statistically significant regression (Please ignore the
numbers in the middle column):

+------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
| mmtests/hackbench                  | process-pipes-1 (seconds)                                |                 0.145 |                   -0.06% |
|                                    | process-pipes-4 (seconds)                                |                0.4335 |                   -0.27% |
|                                    | process-pipes-7 (seconds)                                |                 0.823 |              (I) -12.13% |
|                                    | process-pipes-12 (seconds)                               |    1.3538333333333334 |               (I) -5.32% |
|                                    | process-pipes-21 (seconds)                               |    1.8971666666666664 |               (I) -2.87% |
|                                    | process-pipes-30 (seconds)                               |    2.5023333333333335 |               (I) -3.39% |
|                                    | process-pipes-48 (seconds)                               |                3.4305 |               (I) -5.65% |
|                                    | process-pipes-79 (seconds)                               |     4.245833333333334 |               (I) -6.74% |
|                                    | process-pipes-110 (seconds)                              |     5.114833333333333 |               (I) -6.26% |
|                                    | process-pipes-141 (seconds)                              |                6.1885 |               (I) -4.99% |
|                                    | process-pipes-172 (seconds)                              |     7.231833333333334 |               (I) -4.45% |
|                                    | process-pipes-203 (seconds)                              |     8.393166666666668 |               (I) -3.65% |
|                                    | process-pipes-234 (seconds)                              |     9.487499999999999 |               (I) -3.45% |
|                                    | process-pipes-256 (seconds)                              |    10.316166666666666 |               (I) -3.47% |
|                                    | process-sockets-1 (seconds)                              |                 0.289 |                    2.13% |
|                                    | process-sockets-4 (seconds)                              |    0.7596666666666666 |                    1.02% |
|                                    | process-sockets-7 (seconds)                              |    1.1663333333333334 |                   -0.26% |
|                                    | process-sockets-12 (seconds)                             |    1.8641666666666665 |                   -1.24% |
|                                    | process-sockets-21 (seconds)                             |    3.0773333333333333 |                    0.01% |
|                                    | process-sockets-30 (seconds)                             |                4.2405 |                   -0.15% |
|                                    | process-sockets-48 (seconds)                             |     6.459666666666666 |                    0.15% |
|                                    | process-sockets-79 (seconds)                             |    10.156833333333333 |                    1.45% |
|                                    | process-sockets-110 (seconds)                            |    14.317833333333333 |                   -1.64% |
|                                    | process-sockets-141 (seconds)                            |               20.8735 |               (I) -4.27% |
|                                    | process-sockets-172 (seconds)                            |    26.205333333333332 |                    0.30% |
|                                    | process-sockets-203 (seconds)                            |    31.298000000000002 |                   -1.71% |
|                                    | process-sockets-234 (seconds)                            |    36.104000000000006 |                   -1.94% |
|                                    | process-sockets-256 (seconds)                            |     39.44016666666667 |                   -0.71% |
|                                    | thread-pipes-1 (seconds)                                 |   0.17550000000000002 |                    0.66% |
|                                    | thread-pipes-4 (seconds)                                 |   0.44716666666666666 |                    1.66% |
|                                    | thread-pipes-7 (seconds)                                 |                0.7345 |                   -0.17% |
|                                    | thread-pipes-12 (seconds)                                |     1.405833333333333 |               (I) -4.12% |
|                                    | thread-pipes-21 (seconds)                                |    2.0113333333333334 |               (I) -2.13% |
|                                    | thread-pipes-30 (seconds)                                |    2.6648333333333336 |               (I) -3.78% |
|                                    | thread-pipes-48 (seconds)                                |    3.6341666666666668 |               (I) -5.77% |
|                                    | thread-pipes-79 (seconds)                                |                4.4085 |               (I) -5.31% |
|                                    | thread-pipes-110 (seconds)                               |     5.374666666666666 |               (I) -6.12% |
|                                    | thread-pipes-141 (seconds)                               |     6.385666666666666 |               (I) -4.00% |
|                                    | thread-pipes-172 (seconds)                               |     7.403000000000001 |               (I) -3.01% |
|                                    | thread-pipes-203 (seconds)                               |     8.570333333333332 |               (I) -2.62% |
|                                    | thread-pipes-234 (seconds)                               |     9.719166666666666 |               (I) -2.00% |
|                                    | thread-pipes-256 (seconds)                               |    10.552833333333334 |               (I) -2.30% |
|                                    | thread-sockets-1 (seconds)                               |                0.3065 |                (R) 2.39% |
+------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+

+------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
| mmtests/sysbench-mutex             | sysbenchmutex-1 (usec)                                   |    194.38333333333333 |                   -0.02% |
|                                    | sysbenchmutex-4 (usec)                                   |               200.875 |                   -0.02% |
|                                    | sysbenchmutex-7 (usec)                                   |    201.23000000000002 |                    0.00% |
|                                    | sysbenchmutex-12 (usec)                                  |    201.77666666666664 |                    0.12% |
|                                    | sysbenchmutex-21 (usec)                                  |                203.03 |                   -0.40% |
|                                    | sysbenchmutex-30 (usec)                                  |               203.285 |                    0.08% |
|                                    | sysbenchmutex-48 (usec)                                  |    231.30000000000004 |                    2.59% |
|                                    | sysbenchmutex-79 (usec)                                  |               362.075 |                   -0.80% |
|                                    | sysbenchmutex-110 (usec)                                 |     516.8233333333334 |                   -3.87% |
|                                    | sysbenchmutex-128 (usec)                                 |     593.3533333333334 |               (I) -4.46% |
+------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+

 mm/khugepaged.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4ec324a4c1fe..a0f1df2a7ae6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			writable = true;
 	}
 
-	if (unlikely(!writable)) {
-		result = SCAN_PAGE_RO;
-	} else if (unlikely(cc->is_khugepaged && !referenced)) {
+	if (unlikely(cc->is_khugepaged && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		     mmu_notifier_test_young(vma->vm_mm, _address)))
 			referenced++;
 	}
-	if (!writable) {
-		result = SCAN_PAGE_RO;
-	} else if (cc->is_khugepaged &&
+	if (cc->is_khugepaged &&
 		   (!referenced ||
 		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
@@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		case SCAN_PMD_NULL:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
-		case SCAN_PAGE_RO:
 		case SCAN_LACK_REFERENCED_PAGE:
 		case SCAN_PAGE_NULL:
 		case SCAN_PAGE_COUNT:
-- 
2.30.2



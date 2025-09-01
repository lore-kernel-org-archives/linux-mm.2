Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2026ACA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AF288E0010; Mon,  1 Sep 2025 03:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586F48E0003; Mon,  1 Sep 2025 03:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C35B8E0010; Mon,  1 Sep 2025 03:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 382C28E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:48:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0BC0119F43
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:48:32 +0000 (UTC)
X-FDA: 83839904064.18.B0C76D4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id DBF4980008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:48:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756712911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=YWMXStOYEP0PkPJcXzd+l2HATrBYDQNeUTniK9kw1ic=;
	b=AH/0M0m6egcHcCMslfI459rBGegQthc4vqlp045ekzr3QDmQSTALe4Xe0USqmUfh1aGd5S
	stKviJedFBoSnPsfwKJagMbddKVglPFJ7rM9JDSnmbyB8YzwZ67AdkK5/ezRi9ON947+qJ
	6sWwDn7eBFDjlp4IKJK3TmGf/ifDUk4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756712911; a=rsa-sha256;
	cv=none;
	b=GwIgUcbyb9hmbIa1okdR8LqHmyK/f37a/PTlCFgfiFy8xvK+1HGy0k4l6FkMncoS1J3+Kx
	SAYEGXROA/jfXaVmJ28Ie63VQemjcSD8th9uGLX+UFoQ3TKk+LyUmbZrnI8u+8A3Cjd0RL
	DziUm2+cLZE7ilchDgNRbs+5mIHGUXI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B69D1A25;
	Mon,  1 Sep 2025 00:48:21 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 407453F6A8;
	Mon,  1 Sep 2025 00:48:25 -0700 (PDT)
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
Subject: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
Date: Mon,  1 Sep 2025 13:18:17 +0530
Message-Id: <20250901074817.73012-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DBF4980008
X-Rspam-User: 
X-Stat-Signature: bmatogodamypf7z7ebasntg4tqrjrhyk
X-Rspamd-Server: rspam09
X-HE-Tag: 1756712910-337989
X-HE-Meta: U2FsdGVkX19UI3ka9AAAkZt6gcJTJTy9muHoAqcqNNhE2NQagVlBf15L4DRYBQAF8iYsnibgIEP/r2qbKruIrkF3QUf6p1xzFjqpbI1S9RvR6gpgzyMhHNgkwsEuzvxGVFbMNhfgxAIl0cXyFQrTxRvN0Jh110LgxdT4ucYv0jkOl8dO6cfY4Y2pft2csLn7Nwmls0uKlKBX2xQzASHJCT+EBWpnaE7eD4Zvi3jzCowVZTmDNUDjZiqAh9URzNWcDORTSqMUT+Z1Q2ZjlT84bwpi7Uv6GqCxTBXLjgTRUOssBsQdwZb9AqF79HyaO9gB7rwvhpnYMToEgqRMcByS/9lFkgoghPfRakcjgQt8FDL/Z3Kl0KfSPbf1gUWbmzQVQdJc0XK6vv08fKsKsnBf+mCI2Jz2wrNu947ud2nTj0qhqZTXaou5zQaqMeOR//LiEjhvmgsPatONh5WdCihn1SffiVNYFfAejCNoM3PibI1UxpczF1hEkx6e0iMTDpovLHc/8LSRdW4tGsAow9lcyA10wc4vBoagdqTCePCtnWuveOWL5Wwxt7w75N2woFtdFxOyIPXv5JW/P1hTgcBz3l5CFG+ixSfiIhMXZB9oSb0oB2AoIpIBCR/q0FqLxwaUyTdoSiYBxTpCXVMFW3nJz5uBzneydrSvWBQDKIvvdHJ5UF8v5X2qqnSzwYNbu3i2OPAh0YXMHTXHYG73WKKW7cSjlC9rlDO3+mljNu/JL8pMUGk3CqIIg+uCdDgIAFgigTsLZofX+AUfwe4L61UpRbR+ad+CVyWueX5N3xuEYWDe9RRhmoTQYQ+6kBsSQFfd+DPoZBCiLO+SJG35tFPO4Q3Htg/9JdnivuKq23HD3AWPKlyLnqL1/xBO1cGA1yNjIzsV1NcedMDnNet0oMmLwAd87qKs8LfCQUFWOYeQuEZyfx7q6ND6pXZXmO2EuNLCpQlobe1zplLosCQFX6p
 C5zsAJ6I
 2S/bAQSoQA2kRayLjIYP0od4xpOcNUA+jLjMeWygiaiPAPrW94f9/xKHPRqnZZic9U4w8o1PFCg6L9av72ynZpvNc7swEeNvWub6QiaH/xCDfykEhDVd5VQOmD8qKSfGX2mNY4mhMfveVBa4kvyfXRG3kN4vYUI8VdWiHxrrGMgjCSi3u+c5hCbo077MdnPkF6K8yUxt07bUDuf0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently khugepaged does not collapse a region which does not have a
single writable page. This is wasteful since, apart from any non-writable
memory mapped by the application, there are a lot of non-writable VMAs
which will benefit from collapsing - the VMAs of the executable, those
of the glibc, vvar and vdso, which won't be unmapped during the lifetime
of the process, as opposed to other VMAs which maybe unmapped. Therefore,
remove this restriction and allow khugepaged to collapse a VMA with
arbitrary protections.

Along with this, currently MADV_COLLAPSE does not perform a collapse on a
non-writable VMA, and this restriction is nowhere to be found on the
manpage - the restriction itself sounds wrong to me since the user knows
the protection of the memory it has mapped, so collapsing read-only
memory via madvise() should be a choice of the user which shouldn't
be overriden by the kernel.

I dug into the history of this and couldn't find any concrete reason of
the current behaviour - [1] is the v1 of the original khugepaged patch
which required all ptes to be writable. [2] is the v1 of the patch which
changed this behaviour to require at least one pte to be writable. The
closest thing I could find was: in response to [2], Kirill says in [3] -
"As a side effect it will effectively allow collapse in PROT_READ vmas,
right? I'm not convinced it's a good idea." (Although Kirill realizes in
[4] that this was not the intention of the patch).

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

No regressions were observed with mm-selftests.

[1] https://lore.kernel.org/all/679861e2e81b32a0ae08.1264054854@v2.random/
[2] https://lore.kernel.org/all/1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com/
[3] https://lore.kernel.org/all/20150123113701.GB5975@node.dhcp.inet.fi/
[4] https://lore.kernel.org/all/20150123155802.GA7011@node.dhcp.inet.fi/

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Based on mm-new.

Not very sure of the tracing parts which this patch changes. I have kept
the writable portion for the tracing to maintain backward compat, just
dropped it as a collapse condition.

 include/trace/events/huge_memory.h |  2 +-
 mm/khugepaged.c                    | 11 +++--------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 2305df6cb485..f2472c1c132a 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -19,7 +19,7 @@
 	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
 	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
 	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
-	EM( SCAN_PAGE_RO,		"no_writable_page")		\
+	EM( SCAN_PAGE_RO,		"no_writable_page") /* deprecated */	\
 	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
 	EM( SCAN_PAGE_NULL,		"page_null")			\
 	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4ec324a4c1fe..5ef8482597a9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -39,7 +39,7 @@ enum scan_result {
 	SCAN_PTE_NON_PRESENT,
 	SCAN_PTE_UFFD_WP,
 	SCAN_PTE_MAPPED_HUGEPAGE,
-	SCAN_PAGE_RO,
+	SCAN_PAGE_RO,	/* deprecated */
 	SCAN_LACK_REFERENCED_PAGE,
 	SCAN_PAGE_NULL,
 	SCAN_SCAN_ABORT,
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



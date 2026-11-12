Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB9E606A893
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NJQ4BvBf
Received: by kanga.kvack.org (Postfix)
	id 42DCF6B05B8; Thu, 12 Nov 2026 04:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE9E6B05B9; Thu, 12 Nov 2026 04:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD8B6B05C3; Thu, 12 Nov 2026 04:03:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0937F6B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:03:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99F4514050A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:25 +0000 (UTC)
X-FDA: 85425878370.24.940754A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id AC8661C0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NJQ4BvBf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474204;
	b=6eFxIGRn52HUd5sQNJgTSOhVr3+W99o2GzBk7hqhe18VS2B51R5RteBvKw7OkgRu7+DmsZ
	K/EhkF9qirh7Lhj9YzKNIpG+xB4rr/n/XwW3KiSyTi7PFvnNPk70PIuBWDT546dtZgQe4B
	of1lE43801nArHHg7RvrpGhDP6oU0xU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPvNr3mZonc2DF68bCIP/ucq9mR3dRYykiaNISklMLs=;
	b=42SV+L29v60VPjbZ1d5fzoP5zoa4y3VrR/YcLAqe8sBlCeYYQMGBy+nM24ZV5RpgVWEYb+
	sJRXlyaC5KPwTfXMofqpdedvZPzg7M332+Q6eJ6dbYjIBO5ViJpJgW4FC5W3ez/rCZxrWs
	tTtY9SWQRGcjFSSOE+PsJPZ3FQI9BCo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NJQ4BvBf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD1B7339;
	Thu, 12 Nov 2026 01:03:19 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.169.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2FD1D3F632;
	Thu, 12 Nov 2026 01:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794474202; bh=iDc8VYXRuayG1421sMnA6tNhOgvIr0UOwFtSDUy3iIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJQ4BvBfwqXuu+JQb6LFfPIh4nX5n3/0+MzBSS04lBhBKO7/L1jOSWLR8VIcfQE1A
	 j1AZz1ObGzOrz9c1UxNIG2nESE+7TvotYYj4EUsR+T1gr6+4fn5lw1AfdU5iq+3rOt
	 C+7bRrmN6ry+celZHFLerDmLtBALhQZMP59rXAGg=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 2/4] selftests/mm: detect masked PFNs in allocate_transhuge()
Date: Thu, 12 Nov 2026 14:32:48 +0530
Message-ID: <20261112090250.334344-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112090250.334344-1-sarthak.sharma@arm.com>
References: <20261112090250.334344-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC8661C0008
X-Rspamd-Server: rspam12
X-Stat-Signature: cj1pubj6k9rao7qntpi15uj8uba7qthh
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794474203-552668
X-HE-Meta: U2FsdGVkX195FZPxfAMIUH3E98g0bBCMvYdDovV2zrFgLFx2HeGljoelEQ1E7sVdU7Bqt1QbpWc+FN16dyINVp5zzbaVmT9+peXWIrEOX1Zyo4q5LeZu2f5nbuurK+jmy1/9pBRaR4sDSma2ZvCxBlEfo2h3HABi0zBgvJ6gc372pmtQ4Jv0vpGyMEqtMUuZrGl5Jy10tn28scKHJAQAT1fiRUUJ6eiFDid6hzAgU1acc0NJlMgRyWwbfd7znAtcBj6c7WD8KdT1nY7ME9mnele9G+V3WC++ForQTOL2XRFC0YAuzrlnTuu661p8Llrls+pEAEEvca/4fgyFH2kZroK3oqeacDC+MTHT9vEcrL0JldNH2iUlSfOGfMYUYHFEo9zmAKpcZZOruZHdsawXrRNslTi8v2ETS/8xHA0dlip0VfcCIEJQq3/rS9bFTlvD0FNm0opsX6LcQ44aCGvMdpgCjZdG/JMeJAXI73u3spJkkWZtpWdsOd1ju6ALn1YewMC7S9Hp1kq8gL2euN0goeLmWB2Kl+IZTMjcMnWsXlT4uJjA1jziUVDctT9flBmY68rbQahalwUC78pvzS1Wyev5gej2ehDAA8INcaERDmKSjF6/6nCXomhk/VPd7Y23I4W3mYxN+3MgplrUkQFJ/8hWOocNX/zLl04b3zBjBJVEBf2C7NTtdF/FsLK95ahR0LkOTqY30IFYJcRRJNcUnJkFhLDAt1oLbr582uwzKzuEwm+vgTc0yWORUzQB7DK0a6phkcnKswY3ojFgZEpZ1QzilNRvhl4poTFJ+vhNAqLziTkj9tA24ZxcZRiDGy4LDTeqC3QJ8nBVReO56u1dbDPRQQMwpA5/d6CKB7JaDFCOLgC3mkjQmz3eY0J4lXkq+uvxFx2aNdaOpQEqj9EfOJckcS7SG8rh9EmbR3Q0ZJxFVGdDsCVjbFGy6owbYaUQbDFV7mFQMJaDuTaMOJs
 Au5vEQ4o
 g2i14ODgebcbGPDXaPFPozS4sLpepLcXkOlgn/SXKBhwG+89dHN35/UiXraGF1RvM0rrHER6DVNIFpBIVbCEBNfRGyn6jq3j1P3ontKqK13lM2RdRFNkTp7PRapViZoqusEPVJs4H4yPtrvzMEUA+y+g9mWKyjOiQvZASDWYQzh1DvCTZZXWxxQAJat4Npx1xp2wmg9sSpnkCLRHN3dLzRbb/YtOzxUXadBqeQepqZRZQ9cfSDZ1G+gfwO8VOePL7PHmw8eNTVRkvnmYOQQ1152sfuXM5d+TkhQDOOW5c0OgvmU92HIDHegnOHE0ODYBNzZSbE9oZPr7D/UfybOwNzu+vkdbKZNuRUqV0txg8wKLkP8FFtp8KQagSSKQqwvv+bpMdeV0olKLghl3cccSzRqnYrWJ/qHf1NT8olnrSk/E8XCVFNA3CClzDJqKdoKaNpVg5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

allocate_transhuge() uses pagemap PFNs to determine whether a THP
was allocated. But pagemap PFN returns zero PFNs when the caller
is not allowed to read them (without CAP_SYS_ADMIN). Currently
this looks like a normal THP allocation failure.

When both pagemap entries are present but their PFNs are zero,
return -EACCES since the THP size and alignment cannot be verified.
In case of a base page fallback, the second entry won't be present
and thus it will still return -1 indicating a THP allocation failure.

Update ksm_tests.c to skip the test when pagemap PFNs are
unavailable. While here, use a common cleanup path and
add the missing close(pagemap_fd).

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/ksm_tests.c | 26 +++++++++++++++++---------
 tools/testing/selftests/mm/vm_util.c   |  9 +++++++++
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index 9e6e1633d0b5..9f97ce28e72a 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <stdint.h>
+#include <errno.h>
 #include <err.h>
 
 #include "kselftest.h"
@@ -521,6 +522,8 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	unsigned long scan_time_ns;
 	int pagemap_fd, n_normal_pages, n_huge_pages;
 	const uint64_t hpage_size = pmd_psize();
+	int status = KSFT_FAIL;
+	int64_t pfn;
 
 	if (!thp_is_enabled()) {
 		ksft_print_msg("Transparent Hugepages not available\n");
@@ -551,7 +554,13 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	n_normal_pages = 0;
 	n_huge_pages = 0;
 	for (void *p = map_ptr; p < map_ptr + len; p += hpage_size) {
-		if (allocate_transhuge(p, pagemap_fd) < 0)
+		pfn = allocate_transhuge(p, pagemap_fd);
+		if (pfn == -EACCES) {
+			ksft_print_msg("Pagemap PFNs are unavailable\n");
+			status = KSFT_SKIP;
+			goto out;
+		}
+		if (pfn < 0)
 			n_normal_pages++;
 		else
 			n_huge_pages++;
@@ -563,13 +572,13 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
 		ksft_perror("clock_gettime");
-		goto err_out;
+		goto out;
 	}
 	if (ksm_merge_pages(merge_type, map_ptr, map_size, start_time, timeout))
-		goto err_out;
+		goto out;
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &end_time)) {
 		ksft_perror("clock_gettime");
-		goto err_out;
+		goto out;
 	}
 
 	scan_time_ns = (end_time.tv_sec - start_time.tv_sec) * NSEC_PER_SEC +
@@ -581,12 +590,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
 	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
 					       ((double)scan_time_ns / NSEC_PER_SEC));
 
+	status = KSFT_PASS;
+out:
+	close(pagemap_fd);
 	munmap(map_ptr_orig, len + hpage_size);
-	return KSFT_PASS;
-
-err_out:
-	munmap(map_ptr_orig, len + hpage_size);
-	return KSFT_FAIL;
+	return status;
 }
 
 static int ksm_merge_time(int merge_type, int mapping, int prot, int timeout, size_t map_size)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 8ef226107d78..9942bbea7837 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -534,6 +534,15 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 		  (uintptr_t)ptr >> (pshift() - 3)) != sizeof(ent))
 		ksft_exit_fail_msg("read pagemap\n");
 
+	/*
+	 * Both entries present means that a THP has been allocated. But if
+	 * their PFNs are masked, we cannot verify the size and alignment of
+	 * the THP
+	 */
+	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
+	    !PAGEMAP_PFN(ent[0]) && !PAGEMAP_PFN(ent[1]))
+		return -EACCES;
+
 	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
 	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
 	    !(PAGEMAP_PFN(ent[0]) & ((1 << (hpage_shift - pshift())) - 1)))
-- 
2.53.0



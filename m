Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3FA5F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685C76B028C; Sat, 18 Apr 2026 07:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CC96B028E; Sat, 18 Apr 2026 07:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BD46B028F; Sat, 18 Apr 2026 07:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 425A66B028C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B58F1604D0
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:23 +0000 (UTC)
X-FDA: 84671382726.10.76654EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 299D6C0009
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dIO8VQ3T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510021; a=rsa-sha256;
	cv=none;
	b=0M+6ADmJsUCzJgB3H13RnPR0ugV0+6lvjydsdNvbcXvhQrLI49fJ5lgE0THOSAeouY9MUB
	oj9ctusuxnPrjzpHJq8M7DJvWeJPN144UygtshDCivceOT7N7wGA8rvJK36ugAGkiiw9nm
	XF5z9zZvu+lB35FgZG+gHYbybjvZLzo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dIO8VQ3T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9WG+XyXROzP7f1nJPp9WS73n1yvU7tqVlusyYg+bLU=;
	b=qdn9Pd5GxRkRmYOrrTL3ir+OEuktW5gd25ba+9jumHRpj+Dgr71Un6PMLibdIBOD/8pVCD
	tNHbVJI9HUiXHnXta6jt6xcg3l18wBkmeVne5gxYE4R6jLB53nDRaESHndhd6ofyFgtn3G
	njhTccSf8XtVXUxVuh5/srqspd82uXI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A7F5406E6;
	Sat, 18 Apr 2026 11:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433CAC2BCB7;
	Sat, 18 Apr 2026 11:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510019;
	bh=6G+HupLEy7RoQW/oaRMLwy3Q9S37tIjtSZCXvkrmYmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIO8VQ3TxggvSkpcrYRjrUOeiV7Q7WOLEvRJ84y8+g1/H1nXjBl+C8SQE1s0MetTE
	 5aXyi/sFpcqVaj+bK0wCDOJKaluKNLuIbtAlRX9H97QyxYc9l92GW9EAY9+TQ3hTBZ
	 gxTttAgP95t+Sra5pE/LdU0mlHWYxuOlEmpYO9mTLIvdoz4gGyIg8CiyrBHCnje88H
	 rVGM+gySlaVVUz4lPpXWtfh79hgnkhB0b4xRpCIPd7Tyh/kJ6aObk6bjkT74Un80J8
	 LqHg4jsIOA/QnZ57d67JlznhuUp8easMrm3jJ7ilzDxV51+FTjW0b6geu/5V7hHUyl
	 VWNQ49YL8HHlQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 44/53] selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:29 +0300
Message-ID: <20260418105539.1261536-45-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 1s7j918hpf4eic883ip71s39cyuogu3r
X-Rspam-User: 
X-Rspamd-Queue-Id: 299D6C0009
X-HE-Tag: 1776510020-353320
X-HE-Meta: U2FsdGVkX1/bgYVrnN2VKkegvjZW7+ed1dh3E3YjKwBiZMGQ/VmTxXJkX0e/SS3LyaucDTN8dPnyWdG4QCeI/BBZOyFDkOUE62OOwpyJiHedZeqslFh9D/T25XCOAfvDsnvxE5l1qt4klBxOArCij2HMzyucuGa9QDswA1v9NUmt8Ah5oKPnVWwsexpvAz+ITEiQl0SQOwfGR6pALdiJLBkVcltDpVHd1VBwt9a2pXQYBUdD3GyioGOW/0vVrejKLgH0uZ5QzKQJwCO5TaFNzq75XBBwFDl1ukz+apYhmmpnk7c21RDMsKlDKzgvrtMy9RA/yo3B7WSLrNziz36YtJz1TPt2+ppyKJx0ZQQwvr3OhwKDKCnntOoNTTwXOPNydaNPSaLcnhwatYMoJ2y5SDjCOEdtch8nhHBXzXXyvlUhj1wDME/gMqt3nSabOnbuJuT2toMmmbSHi76N5Rf6ziZvbaMdx37cDAxOprYY0twjHbvIxhriil58ZxyOyp4rbOfIjx4jv98IL+T+MFnkHQxJhFZR7kd5FRcWrvUyYN43bCuboMaaojZDs/fBVy2nVFMbq9rNiXRxxM7tOwAhBRyhWHA5eamKD5jJxJjeml3x7CWVWqKKvSnOV91DosyiT+vF6TBv1v+Ce4RE3bzuHyKKEQ6amJp7RvXCqgXq8dPtwcwVozdWCSqH5rN6SdxROuBu4XYZgH2vTUpxTc0dlNxBZQiiBfzAY6I1Fp87XFgXojhBicOa/Q5dktvvMUmLw6dltWZhL6Gb35lZBpHaCB/KkBOpAHZryTXXLw6eHnEkQaYAa2xLtjoTbJQlPm2wHmNFm2bpWyc10jhbSS7flPULa4LeJoxiIph39h2J5ssapSHcP5NL2Xvo4Efa+5xJ+grC4IMoHGbnmGvyk/9uxAJqx3IEdO3bs7lEPAnI6ysqzR/rJLxzIVngQCd9S02P/UP9G7DCWW3XR4ISfnq
 ZeLfJmHv
 t+fVRiOtIT/GiP0Fvz2WCLUcA1mQSG6skS+ET42bVnjruJp+WBDdQflNTZupuSWWTVblVrbozRL+WNtF8Ha9HgT1uebccPZ0FlFIPAXYX1o3cxg+eDe6tKzfbc/Gl4Q54+P3bGD0E+ei8YzQg+xMgF4tevOio11e2Rld6SN235lz5+LOkagIte+48gOthy6rKeSSeYF4hj9QsknPZAvkTzgwTJN2h8SpwSMrZtoKb3gXdKeUTb3h1yw2DMo2AJ3BZaRv2K49IRpU2sFQgBHtk92tolC+JufdnpMAq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

pagemap-ioctl skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 7f9428d6062c..e2c62cb6978f 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -7,8 +7,6 @@
 #include <sys/mman.h>
 #include <errno.h>
 #include <malloc.h>
-#include "vm_util.h"
-#include "kselftest.h"
 #include <linux/types.h>
 #include <linux/memfd.h>
 #include <linux/userfaultfd.h>
@@ -23,6 +21,10 @@
 #include <sys/ipc.h>
 #include <sys/shm.h>
 
+#include "vm_util.h"
+#include "kselftest.h"
+#include "hugepage_settings.h"
+
 #define PAGEMAP_BITS_ALL		(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
 					 PAGE_IS_FILE | PAGE_IS_PRESENT |	\
 					 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
@@ -1554,6 +1556,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (init_uffd())
 		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
+	if (!hugetlb_setup_default(4))
+		ksft_exit_skip("Not enough huge pages\n");
+
 	ksft_set_plan(117);
 
 	page_size = getpagesize();
@@ -1605,7 +1610,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	}
 
 	/* 5. SHM Hugetlb page testing */
-	mem_size = 2*1024*1024;
+	mem_size = default_huge_page_size();
 	mem = gethugetlb_mem(mem_size, &shmid);
 	if (mem) {
 		wp_init(mem, mem_size);
@@ -1633,7 +1638,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	}
 
 	/* 7. File Hugetlb testing */
-	mem_size = 2*1024*1024;
+	mem_size = default_huge_page_size();
 	fd = memfd_create("uffd-test", MFD_HUGETLB | MFD_NOEXEC_SEAL);
 	if (fd < 0)
 		ksft_exit_fail_msg("uffd-test creation failed %d %s\n", errno, strerror(errno));
-- 
2.53.0



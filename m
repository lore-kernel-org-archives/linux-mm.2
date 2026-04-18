Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECCAF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806566B0208; Sat, 18 Apr 2026 06:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7146B020A; Sat, 18 Apr 2026 06:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6386B020B; Sat, 18 Apr 2026 06:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 566016B0208
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:56:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2743AC1D41
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:40 +0000 (UTC)
X-FDA: 84671373360.23.4FEF80F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7E7FDC0007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f7xJe9tY;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zcP9bMgK/o5Ir4vWVOWkw/EM6btSqnojLC6g/f/36o=;
	b=7+A2b3xpmbzEndDCa+sPNfkG5oN9CbiZoYOMOnQQ9dpzZwbb4s1Z4apx1FLb1xby2Zgf9K
	5PlvJM2c/U0E+DvtbDKuFOKMsRSayvxRpYf99HEzKN1Pu003Grxogy/MltGQL94w+hJKKS
	y8o2ULyQdwJnbrovczReWln3r+edjCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509798; a=rsa-sha256;
	cv=none;
	b=g/8o+aSSfQhCSxW7gYx4vgx2+gjllO60dRACR49A+AR4mx3kc5+dwTke0lRlhef9z7Qgst
	J+A3VLPOFzcfHMDNAFDxJ7LUzSHNlJNegJKdlHRoMNnB0zUq6RtVeSRtsInMPUXNf0iO1S
	30ol6k/ABuiYxS9hLvwPz7HyD7ojzb8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f7xJe9tY;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B915342B25;
	Sat, 18 Apr 2026 10:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DB9C2BCB9;
	Sat, 18 Apr 2026 10:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509797;
	bh=NitfBPXl8kD3vu5rR/J2HvzzLd7OiNMTutBSbiBcjN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7xJe9tYyt16QWurqku2tRbQs22RNG4wZ5+X6pwY3jWd4cfBJqucTkoMNStMJrb4D
	 ECBq0Y2QVGXBtpIsYni7zsr2niIyMWIXByzusEXS+7Ta6VJq8vJOXLjdhchid3Rg7x
	 It/dEhwlySxOzxPd2sdDMlLQ6NU0ge5wY3ChPiDQO7jSrLVN1Au057xvWllg3BZwud
	 8f5lk0gCGuT+OWTNsxLFlMrZiOv/OWj7LnJcaF9gPWBjsYx7V8KZVH0q4gIwO/JMq9
	 jTBj5CAV9iYej7d08NDY3CQ9WHxbrQxQgn2NiiWA41PZCqfRUFq5PJcOYZUFgtiVPm
	 hJ/51JEQanYEA==
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
Subject: [PATCH v2 08/53] selftests/mm: hugetlb-vmemmap: use kselftest framework
Date: Sat, 18 Apr 2026 13:54:53 +0300
Message-ID: <20260418105539.1261536-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1shstkwxfacpb3p3ni7t6sdxfg1o6imn
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E7FDC0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1776509798-60655
X-HE-Meta: U2FsdGVkX1/9TFRLO0RmejXK/y/lUDBODV+eHa/XM/RajQ2KiQ5c2FiPLZi7bUrfZ/vnRiAUmgUlyTLPrA3YpraYBMScpiVbdv+zqM4yEJz9St3wOGcvG2KYRahR6MmlB0Rg7aM18gcPCXnBVDYwuST+e457wX73o+lZqcPHFnpXlR1/WxseoGyFgCPrFQ/ZKkdZTycP7piw67k2WIUzWQKVqvGutHEHLyiKvxip3+EblUVRv+tnlgQ9GlpDnE5GYS2TSn65Gg0zhHBUL8BJtULBmTWMh0C8LSmp2htmmBcx8Pxj0il+DpZqBZif5euryGkkDbdiD96v+EJ4FvSPUCrtl8/5dBxar4ShXqoVSBaRk5R9HKNYsBIse2qMcVhPdhgL3rHHMYrN10jP2VP++pzmDU33uA3jzOFOr+9xrzGy9LtF81y1h7jjGyEW4htvq9/seNXP8Xr8xty1Wsr7McRP81GMZUVBYKsmqs+xhIwwcmkZsZ0HkkvjryGnzFDumGWSTUFsL+0+cPVF00MqmN3FZjShLqCNoGG8tRIBTfJ6xjW8saQL4S7kLiAaJhyZRIo8fl4XlITzXPSjw4TPRezUNj1BXOKqgs3hXb+6CyzRPWYMoLya8KABQotGnPVaVwQgoHCvaiMPk1pmSzcaJwr0ifv+1WvHM1vZBnWjj3VTN/Xn5t2xv+YVxXcdjC/O2OAafGXhUNfcXAkMmf/9dVGZdqFnnWSxhUhCm/Vfjh+4Kem5yQ8q7btnwz1Qt6DlZS0PD+JA3mxBZ/dQSekDYS0zRRux9S8+jFTICGXlTuhRUPD8pIA+kpDKkGvhihAlPhkBid3zOflHqfpL0iyZ11dbMdgeadftYLJr317mVDDVFS2pwQWdTfBQOeEmn4Xl5ByOURPplcnuTnrTz0gs4ZpVHgtM3EKGk1S1LBI83+qGM5kUQ43MPUdlKayZlXYK70Lw3aOGSV1AVy8tIAc
 6IfDh0cA
 +KCIGYMwuFhzyO++Xroh8AHQde+Fxtc1+SEGl5s1EFi9x8ZgGwrGyCJzVGax0WlJ6IrsQQ4nVDJn1QhgkwsIsapJAR6YnGUPeAe7yhHFupHjvEMijSfYGuKMJcgVjCNsEen1msl7SWbMLgEK/CwuFN7sBOVDcTMFJZoILS0nXdUQ5fn+qI7dKWDpZDhHqbw1+s+JFbg2PjEi5q32wDxn4qcnhpZdyF92pnAWs6U8Q/TGL162LMCML+G+wlkrvSHZ6tC96
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-vmemmap test to use kselftest framework for reporting
and tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-vmemmap.c | 42 +++++++++-----------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
index df366a4d1b92..485a6978b40f 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -63,7 +63,7 @@ static int check_page_flags(unsigned long pfn)
 	read(fd, &pageflags, sizeof(pageflags));
 	if ((pageflags & HEAD_PAGE_FLAGS) != HEAD_PAGE_FLAGS) {
 		close(fd);
-		printf("Head page flags (%lx) is invalid\n", pageflags);
+		ksft_print_msg("Head page flags (%lx) is invalid\n", pageflags);
 		return -1;
 	}
 
@@ -77,7 +77,7 @@ static int check_page_flags(unsigned long pfn)
 		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
 		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
 			close(fd);
-			printf("Tail page flags (%lx) is invalid\n", pageflags);
+			ksft_print_msg("Tail page flags (%lx) is invalid\n", pageflags);
 			return -1;
 		}
 	}
@@ -91,44 +91,38 @@ int main(int argc, char **argv)
 {
 	void *addr;
 	unsigned long pfn;
+	int ret;
+
+	ksft_print_header();
+	ksft_set_plan(1);
 
 	pagesize  = psize();
 	maplength = default_huge_page_size();
-	if (!maplength) {
-		printf("Unable to determine huge page size\n");
-		exit(1);
-	}
+	if (!maplength)
+		ksft_exit_skip("Unable to determine huge page size\n");
 
 	addr = mmap(NULL, maplength, PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
 
 	/* Trigger allocation of HugeTLB page. */
 	write_bytes(addr, maplength);
 
 	pfn = virt_to_pfn(addr);
 	if (pfn == -1UL) {
+		ksft_perror("virt_to_pfn");
 		munmap(addr, maplength);
-		perror("virt_to_pfn");
-		exit(1);
+		ksft_exit_fail();
 	}
 
-	printf("Returned address is %p whose pfn is %lx\n", addr, pfn);
+	ksft_print_msg("Returned address is %p whose pfn is %lx\n", addr, pfn);
 
-	if (check_page_flags(pfn) < 0) {
-		munmap(addr, maplength);
-		perror("check_page_flags");
-		exit(1);
-	}
+	ret = check_page_flags(pfn);
 
-	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, maplength)) {
-		perror("munmap");
-		exit(1);
-	}
+	if (munmap(addr, maplength))
+		ksft_exit_fail_perror("munmap");
 
-	return 0;
+	ksft_test_result(!ret, "HugeTLB vmemmap page flags\n");
+	ksft_finished();
 }
-- 
2.53.0



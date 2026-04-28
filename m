Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25BD1FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92DA66B00A4; Tue, 28 Apr 2026 16:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD596B00A6; Tue, 28 Apr 2026 16:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4236B00A7; Tue, 28 Apr 2026 16:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0FA6B00A4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F0814049A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:53 +0000 (UTC)
X-FDA: 84709141146.20.2F9F319
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5B97B16000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lp7BNmJf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lz6fZNIDKsMnbjccTEPKo+Uxc8tEiIx7r7mYgbNXxM8=;
	b=pnaeOqrmWC18LWyBw5s0uQD31WwjsqWg7mBqK55Z0/T6k7El0xjQBp0ZCFUFLaIdSnslUw
	i5cwQjf9kyMu3nfiNQlVTB0Fz9+DUUcHTXlC7tQAc9o4v6fEpCMFh1i6DjPGy8IRyt/nqI
	fayBPBpEcYcPCfmLOUop4SvcpF7kQqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409031; a=rsa-sha256;
	cv=none;
	b=1s6iMEXu/lh3EgUTSw7tplVRUJiO4ZDv9nprMY9JU7AbzkrHQBEREnJqVTLrBUg/9HGuhz
	l1v3IiJshP+3rFrtZmzMSfY2xJA5XrxoVuxNW0Ua5sgvqpJOsZ+Edv7HeQ3D6eRbfPM452
	ASyYx76be/pEIxx30f/Bc/bCx0gsfAw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lp7BNmJf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8213042A2E;
	Tue, 28 Apr 2026 20:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5442AC2BCB3;
	Tue, 28 Apr 2026 20:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409030;
	bh=bpVjE+rMZ04PnOlIbMfzh/SWaUuNZKecssAAspqsN00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lp7BNmJfBs3tnIXRwomoqgNhS3DpKCfQnJiUKp0ucl4K0f1Qr/E4L975/0TC+Tejs
	 8bphHhHBaxKSe3Q7WxLlL+zQmOYK67ceUwO6kM3zTrTkslmOh5U+uXc3AWHA3Wgdqw
	 Ior2MXonGYqegGcU6qpUJ2I2cZic5sG9876hxsh/nrct7YHaLpcHZbx9n1mKXrHnmv
	 pPi2JLgfCdbJ6pmTzVqlBUJ5rsWfkf1zMuRFIkDYfWZaFNibPhnsJC6/i68phkXOED
	 ZHBIhZ5NZK/AoKcIZXhGvRflC+tdNyQN/dBUldyqkyFG3YpeInMFQ1s8aR5PFCv/mT
	 VMt6K8MPkbr2Q==
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
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v3 09/54] selftests/mm: hugetlb-vmemmap: use kselftest framework
Date: Tue, 28 Apr 2026 23:41:55 +0300
Message-ID: <20260428204240.1924129-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5B97B16000C
X-Stat-Signature: rwupzwsqbucjym7itzny18znpnufe6ss
X-Rspam-User: 
X-HE-Tag: 1777409031-489949
X-HE-Meta: U2FsdGVkX19/B84PBhZfK1r2j6EASb98znBWDbR9XlgMypQlnflxYaxklXQXkh8g8tHGDNF+FLULbVkdnrAloVl31u+Q4Z5GC+V7ytBKcWGty8GavzM3fZQtRx5LGFZQ5FCJIbfn9Ju/mU4KNjxEMbShGiH+kK82g12D4d1lejJqckD1z+/mt7qaAhXE6mz4IAJ80vGxxlaXRt1Nk8EBvUTZbigrdHuUEJ+ZH9lLCBiSp/dnRT4uCI1dsjttI1s02v8E49pk+KjI1HBg1uA9tD996Fl2fj1HGpHJyFspjwyMlUkU+XbbeYx3ySdbPRu8IX1ZvYRxZFeosxlnRdDflwlu2hBFPT/UwoSYKC7etTKu5vNMm7pR/fLm9iS/05pNnlY8uX1Q3vpKQwvrFyLlUpntTR6SUz5I3JUITFXG7xAOrZFr2gm9klI4UwEMfowWemHqcLs0LjTTwyrDyZKnWwk68blZTK134OdQ6c8wZhUdvJg0EAcZuIZ947Ipc0AmDc7uKRuPXDYRZaef5CdFH4zPPcIDk+y3UfXcKK4oYW+U6ouq0CWQ9tjtwbkGDpmwpmYYmT8ntBXBgAb//3G9yIhtADljNFCwL4TOx6zr2Sn+V/X8MXAjiWAlUZJZaJJ419rtDIlV0wCTurPt4rzVAR5+6O48Z8CGHQv6Q+OYk+NaPAKErFAugO2DwVXayFMzAR+aVPFZ0TNSOsNEoOr+sEJUETYR75tQvhouYIh8I7SJDaQlkFfz9YzurtsMYnpaLVte5p2siUnEOSNuaGPnY4iHZoiMyUyL+YFe6BdqmdieuOS5ZfLnZ8SSYBQ/6xouu/bH+DifHo9wU07iy6ziKgAkWrdAuuWVJQJUnQdTEE+faS4zCZjdz3OyHOs6Ov/RVVmtA+B7fT4XTfn/SzDlODDHP0yN1KM9ognt8bTsxQ4w+pb3XAFRAwizz3FllrsbhRTTu26J9+z584Tehug
 Mjmxr7Wr
 8RWeK/Q9IsIxEaLM4FpPoHnPSuPKAM1PJBGjHn4q4WQA3olJdYbCtdc9ZaaUC8CY7YwNcOXxCAjOc4JNWpd5ZNM2GYSTr0v2v7R/8XZlC7IVG9ZUV7osu4zpixgMA6o/+2e+w5Ejk4hVMZBmMw70LSQsyO9RDFXBJh/A85eueJff00wMg3lwNBOI2aR7gmk+vVwEcao9NeXydr/nRxhnET8SW/qqIIAaZybCm/x9YHg+kGz8ZZ5KVtBrUuK+ptnr9qb9Gi+vg1gXDoEBjAXu2gOvXiMAVfiCj1Ibzg6mvN0DAdZ9Rh4J5/55wIbJjqlCfKVGP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-vmemmap test to use kselftest framework for reporting
and tracking successful and failing runs.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
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



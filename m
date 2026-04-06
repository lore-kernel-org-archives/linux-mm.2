Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DD9F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58206B009E; Mon,  6 Apr 2026 10:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F5D6B00A5; Mon,  6 Apr 2026 10:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D186B00A6; Mon,  6 Apr 2026 10:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 858946B009E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29EB18BA3D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:35 +0000 (UTC)
X-FDA: 84628336590.21.DC7DB3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 699142000F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UbDpBxXk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485113; a=rsa-sha256;
	cv=none;
	b=fQ0eGtEuJSCR1gPdLpPOLDX+1DttO+8JGrenhThXeK4oKpeVLAMRwBJAb0QTNg3YxTfOz7
	rKT2Os7mDuyfXp13+DbNUZi4DFDKRrhrHGOdt4MWrs4mkeD4V26hC7psSbbvpSBaXfrCuZ
	Ih4CaBHSRV5vWbihGpt7/yGwDxuMh+w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UbDpBxXk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2q9dYRb6zmeXyhvqOr5b8Sof0agwaWt8EMjestkrQM=;
	b=rMYCXii2rFsQVgaN2ZbKLBVF0wh4zYWStC6h/HO0s0O8TrIE+YCN9RJpf7EdcZLqJGqENh
	ADjEh+0m8dIDdJeMLNGuWbuit6wMsPiCOc6J7xAV5UlcjSu4ZAVLeAaldi2VobJktjYa+T
	CaIL/50F17Yg2onGoqkIguLUeHw7ej0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 952A343897;
	Mon,  6 Apr 2026 14:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3500BC2BC9E;
	Mon,  6 Apr 2026 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485112;
	bh=cHW95NZ42YfNcufefUqyP5vy9sk2uSEi5NqGd6FjA9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbDpBxXkoh2MOdnNvogyfcjAd9o0RD0BIw5YWHsmCZEsSyouqb2A7B7qKWwXSuNL5
	 zU1k8lkIyulvmUhm5+oHtElMogza3qEtmnAsQTVQIsVpcn/zk8MDwvjxx1Rs88y5X+
	 jGR7y59IhXmfOC8/hkmCEJilYFRDQl1prX+P52/dPuHCILqGj8Xzo5dPghyfg1LjSC
	 q+heU+tRNJmzpCq30Zgnums5QbRXB1FDsiSglkpizQw+wQt6511TUj9WiP/75JhXHd
	 yP4o0JUBpw4hHuApGXB1xPjf/MhyyUzDfecYAm6fdE5tFmvVMTOBYbkBQzhK9VNOrv
	 rBfMhQ0x1BhSw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/53] selftests/mm: hugetlb-vmemmap: use kselftest framework
Date: Mon,  6 Apr 2026 17:16:50 +0300
Message-ID: <20260406141735.2179309-9-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aapzqedd7qgiip5188ejmwqpx8yj7eej
X-Rspamd-Queue-Id: 699142000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485113-434044
X-HE-Meta: U2FsdGVkX18PFmF1E/pM8RoXnwtNUFggk8hqXN/u/sH1DPC+V6BOresXnkYwwk2a55i0jXepqQjv4eL3x6FKpAZ901GMp4HrJxWhl5L2BQSsn+A5xMZzB8bQGXInU4LzKBoDZiGQQv6/+YeIZ8UoVCCvLgE63C9ZASxdQAHvtqPwRkjDSgyD/0tEp1MFCENDvpHPBK+xN2KICQ41ekXwuoDAxYyI8VjnI+xKdm7ICvlTONXJsYSLch4Svlk4m1pgywDXX568/sTK9QmSz2ywvQ2Eukkcn4XviSgWuFw03c3ly2HyMgd3+e0uLiQq2Y3my3PoD8NHIeIamNgqTF6znHxSHYYUeB59jNBkgQcsc0Acy44X+9i4IgSGRV23A5EATZKih0yY9hoKhWQCxvyo2vh5mn6gcbqVmrLx7zpGG6FVqi+Eh97s/g1ndl0ArVGVUj2riT/h5yCCgf+0r262IWe5C96pbEcxsAJ7gNWRHjfH4C9hMPOY0lVLXBS+pBwy3AqMzD64WGieihkLAhdnZn6HZUwRqq0FLT0+WgfKRWx7rdmOFxtplTWkvZMVeZLZOkP7cb5nDTyhr8AJ2cz3lSZyPrqZgUGPffxn3yLlmMV3OtDY/kSlaspQpXZ9JJJPJrX/U2M32szxwUGhhbTe9wRjXpB6uTfuAdLJmYIyTbMwqEdc3xgA9tjvZB2HtWdCmm1ZU6ZfBrMVYh6YLW2KmtDJ52n/9rz5rRhxb/SRgqHEmtPXd9vIxiy3SfBmcxE3dLIJ8m7s6sCk+zcGsYnJviySo7yizKdOxYJF/zdLrKqwzsBxqTGjk39V8KnS9wTUfKC2oPp0qd4LnTeTMgiEyv7aL3NZhwGYztHy5S4XyqbgoE8wIAjPY3cN0DWRaZeuSu685u69e5MGEkABK6KgiaoKlZptC+dh1istwfeFMFBaZ2BOROFtYkOfaPRnFYZ5Hkk5BxhAAnG19tlUq7W
 eZJMKhA9
 a5SrCgoexyelpbHOK4VwseXfQ5SgFHoh+4q0Cgyh9KEphx2YFRxAtG5j8Pgjhqhg1aAJsB59nryRwL6ciCoNadQAwA5CxLx3OM7fX2GCRrBlLJQTq/zfIoxAADUBPzfcDvSN4MiC6ceg6l6af8bCwaiCt6TTzvc55IhsNCkgEv8yMa84VoMuGOjvu2WiT1cEMZz33Fm6BNCmwQ7BPBAb+5PJMIpf9J2HUxuxaegzkj7Y55KM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-vmemmap test to use kselftest framework for reporting
and tracking successful and failing runs.

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



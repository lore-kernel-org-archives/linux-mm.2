Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4AD60A2607
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YbGeh5+y
Received: by kanga.kvack.org (Postfix)
	id E2FDA6B05BF; Mon,  2 Nov 2026 05:03:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE05B6B05C0; Mon,  2 Nov 2026 05:03:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DD16B05C1; Mon,  2 Nov 2026 05:03:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFAAC6B05BF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:03:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37E56A8AA3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:37 +0000 (UTC)
X-FDA: 85389742074.10.1DBE35C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 917AF40003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YbGeh5+y;
	spf=pass (imf17.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613815;
	b=fyN/xb59ayRNgUdkKGf4fZno3g77q7KndI5erJXhY85msIETHASjb7y98oKau+dxv0XpeO
	h810wRnyjC2yu6TBDOtNAKRm6K8CKniP9f93X1cT8grstwvtv1Q8qJ0nxwKC4VK+byYF2X
	uioF6+IWSXv20/kjkbknNzv0+pIHobE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YbGeh5+y;
	spf=pass (imf17.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdnDmqlCH80gjvSxzbKE92AxnXNoFECvTQW6aAOAAUc=;
	b=RcJBjPJe7GlrzI9pQg0TqV4oD+v7r++lFfIBXs2mFm+6S1tr0S2e7Hqy28XYyot98mJ8ej
	2QALl51b7+k+QcnPQ9kcuupsPXgVn60Bc4MfCOjuAvqtHxLpFVZGPHc0ZcPQGdAhyv5kqk
	q1un9g2tdHa5u+JLjOt5ZOFHeTVLlDo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C32D293B;
	Mon,  2 Nov 2026 02:03:31 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B88CB3F59E;
	Mon,  2 Nov 2026 02:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613814; bh=h5dXF0m91cnxVDQONyXlGNTGhZvMDOX5pVEbRrsufFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbGeh5+yY/p2Pf0TkK8JgmGOFxk8huewbNvCL9C2KItaKajh1Y75ulaitXhXdVliD
	 G/H/x/NrUUkFkvpeANJctSS3OYjmyc1EqfUJLCs0wG1DMupLaTVYvGg9vt9c9xBQJ1
	 J0Kflxh+CdtIKZdCCkPi9fDjUSCUUCUmFdaHW2Z0=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND v2 08/12] selftests/mm: mremap_test: handle cleanup after mmap failures
Date: Mon,  2 Nov 2026 15:32:07 +0530
Message-ID: <20261102100211.141831-9-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y1rot7m9xfw8efuwn681soyi6en69edm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 917AF40003
X-Rspam-User: 
X-HE-Tag: 1793613815-3668
X-HE-Meta: U2FsdGVkX18Vr3duffpO22Nt79W1Z4MO/ERAVSLI+zVLwHomY90FhcgzxR2QB1+f1cJk/AbpBoIu/zM1mwlqfTNstCgsJE306hFFZlFnTa75csonJB+jw3olpdstR07oBlF3Yw0n2ODQbM/mLS4pwY3TPU2MxolIfg6hGrq03vp3eQWvcQXbBXU+vWlJpwq5XEqdD/TcgMFOaVzh91npu6aH/G4x2MFSN6Ik5lblBGb1+YHbFZhCUbBpdN8kBvBicEzRLdJvCbAqYeguZ5ZPVY7U3CrB6MBbveL9N4e8RBTj4DZjYyWi2pqtAB2U0evKgXSqTKxLg/PNCz93bDWK+LxVwhWOfjZyaMadjFDvix9mtsIDeSA4uz8iYHWWqM4V/WGWXqzgyNRMlZuMKIzdREXKdeJ2nDowWGAUtaIywXCU9PeXmHtpC85h/sGEhLj7sYDir2tw1IiZpXzdJUS2DNWFGk/SsqYwEjc0rbA2J9Xot7HPOv0N6ArXEn8dulsc03OhyJ81mVfjtnSouSoMrwnjJJnCFJWqeTw/XR2whkq/Yau7dgtHTDxiQV2E6NWyMtFKWz4XwMZX036ChWV1Gf9+4YCQE9Mc9bKZVVZLzg1jOset/jtLVU2bpSIPPykWJdLlX0Idecwe5e5BuXLy8J7Ku0w8l+KfExA/IMz3nAGyZQYfQ2r8jiyfi0YY/uL5m1kAHNoyHo/CvRTWX4b77qSGfBMxTBOSP+5YawQutCAF90FuP7B1+gdAs66yInwZ6RCHi5VzQH9cslfnADDeWMPiC/uuhisVLJyhj4spC+5xNJ8U7kR+1ZYOGmay3Y3WCNwTcXPxUtwUgjSNkwCYPleIYN/obE7MVlfXCpT7huwa/X45y7M0+N2eeqEVVpFk/JtnHZ9GXCUn2MYHUDo/p6KKUybx792foKuQxDCrZlTuFnDc6v8wf2EyteuqfujG8y9vycegA2jLVyd0t9X
 ceC4KcsA
 jEeMUr9QrpGv9+Eb/UOiwoKjhneUk9ij38k1x4zL7Y/zTf2TOds+oEKwzowTEeYbDBSZvzd1yAmM+pVX1/hrXUSczD54fvicZjRjDESAzEWIFKNaeBJmGKLSVBhg4X7fgcQSLIUt8moimJHIxJGCXTyNPUi+EyLHPkBW/1I/C4OysE5mHo7zcHdlYLLclqb3aAdCD9W4crgiKqSsENhHDLeWs9ZRagu6SafUOMeB/FppbqvIHDcml97o1yiMzOcAV9bvuKdeEcjmn3YeCa1J3cokMfBVyj7cgSEkH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In several tests, when target mapping fails, we directly
jump to the result handling, without unmapping the
previously created source mapping. This leaks the
source mapping. Unmap the source mapping when target
mapping fails.

Also bypass munmap() when source mapping fails in
mremap_move_within_range().

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 514d2003b88d..63bf8a475fe6 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -340,7 +340,7 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 	if (new_ptr == MAP_FAILED) {
 		ksft_perror("mremap");
 		success = 0;
-		goto out;
+		goto out_unmap;
 	}
 
 	/* Verify byte pattern after remapping */
@@ -357,9 +357,9 @@ static void mremap_move_within_range(unsigned int pattern_seed, char *rand_addr)
 		}
 	}
 
-out:
+out_unmap:
 	munmap(ptr, size);
-
+out:
 	ksft_test_result(success, "%s\n", test_name);
 }
 
@@ -415,7 +415,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 	if (tgt_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		success = false;
-		goto out;
+		goto out_unmap_src;
 	}
 	if (munmap(tgt_ptr, 2 * size)) {
 		ksft_perror("munmap");
@@ -501,6 +501,7 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 
 out_unmap:
 	munmap(tgt_ptr, 2 * size);
+out_unmap_src:
 	munmap(ptr, size);
 out:
 	ksft_test_result(success, "%s%s\n", test_name, dont_unmap ? " [dontunmap]" : "");
@@ -529,7 +530,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 	if (tgt_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		success = false;
-		goto out;
+		goto out_unmap_src;
 	}
 	if (munmap(tgt_ptr, size)) {
 		ksft_perror("munmap");
@@ -573,6 +574,7 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 
 out_unmap:
 	munmap(tgt_ptr, size);
+out_unmap_src:
 	munmap(ptr, size);
 out:
 	ksft_test_result(success, "%s%s\n", test_name, inplace ? " [inplace]" : "");
@@ -605,7 +607,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 	if (tgt_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		success = false;
-		goto out;
+		goto out_unmap_src;
 	}
 	if (munmap(tgt_ptr, size)) {
 		ksft_perror("munmap");
@@ -690,6 +692,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 
 out_unmap:
 	munmap(tgt_ptr, size);
+out_unmap_src:
 	munmap(ptr, size);
 out:
 	ksft_test_result(success, "%s%s\n", test_name, dont_unmap ? " [dontunmap]" : "");
@@ -738,7 +741,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	if (tgt_ptr == MAP_FAILED) {
 		ksft_perror("mmap");
 		success = false;
-		goto out_close_uffd;
+		goto out_unmap_src;
 	}
 	if (munmap(tgt_ptr, size)) {
 		ksft_perror("munmap");
@@ -910,6 +913,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 
 out_unmap:
 	munmap(tgt_ptr, size);
+out_unmap_src:
 	munmap(ptr, size);
 out_close_uffd:
 	close(uffd);
-- 
2.53.0



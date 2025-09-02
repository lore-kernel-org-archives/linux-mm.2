Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9BE3CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BD18E0023; Tue,  2 Sep 2025 12:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BED8E0003; Tue,  2 Sep 2025 12:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497F98E0023; Tue,  2 Sep 2025 12:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F64C8E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:25:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF9F81D9C3D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:25:54 +0000 (UTC)
X-FDA: 83844836628.07.545810A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 534818000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:25:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YMfMCr70;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756830353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMnknAcw0zGmxUXxtl0RJkmxRxufvbi04WvYxzB4SiQ=;
	b=WNZ2PxHxZ6CkPJ4sX9CTkj4iwpBfei7uo5j8qIpqBUgKdvsqhBc+MFnJpDOoA588vCWNkR
	PFT3bY3rl4pzCl9qcuDVnfhACpP8joOpbHjcpQWvXC72MmXJaJkQ414i/4WxOr/AKW5dAj
	AwJNgwh//uncYh27BIIKLWMeX5gJjHo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YMfMCr70;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756830353; a=rsa-sha256;
	cv=none;
	b=Tq31orVINC6sIWWNteLmegz/23UVEIa4FLHipEX/DNmzgRhFjKl1qmW5/nH7UhDKVBTsR9
	y7rvFYnRE/NFTEULkmj6AF3uUjy6BGxwLUCJMMN6YcQlEjA60V5KElrLA8e85pIXylxPQe
	DFQTIWhOz6VNwbAnKCaI7f/PgWR3RW8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756830352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sMnknAcw0zGmxUXxtl0RJkmxRxufvbi04WvYxzB4SiQ=;
	b=YMfMCr70A6Lx7j9iW1AIRDVmIV/0r/Pi70/ITPZzFTjkf8qQ0Ce5zWPAPKiFFM0/g99GDZ
	m76wadtHCYJsJMxOtp23/4cMiLiZpCq9eYBsSZnEY508yp+tdT6Btz+Ifx8t2Q38H5fX9o
	lHFFBAygELTv38MdOcvEP3wLsXd943U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-W1xsoQL6PVWgUup9MWJIow-1; Tue,
 02 Sep 2025 12:25:49 -0400
X-MC-Unique: W1xsoQL6PVWgUup9MWJIow-1
X-Mimecast-MFC-AGG-ID: W1xsoQL6PVWgUup9MWJIow_1756830348
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C7951800290;
	Tue,  2 Sep 2025 16:25:48 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.80.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C0AB300019F;
	Tue,  2 Sep 2025 16:25:45 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 2/2] selftests/mm: split_huge_page_test: cleanups for split_pte_mapped_thp test
Date: Tue,  2 Sep 2025 18:25:36 +0200
Message-ID: <20250902162536.956465-3-david@redhat.com>
In-Reply-To: <20250902162536.956465-1-david@redhat.com>
References: <20250902162536.956465-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 534818000D
X-Stat-Signature: kyxjxy6555193oqn8im5frkfgfj6ea87
X-Rspam-User: 
X-HE-Tag: 1756830353-105491
X-HE-Meta: U2FsdGVkX19ot6smLCfSTLTsYBglbSNLnZaSv/JqAmShwCGygmpdCyKG8jurOdTKqoQibwQs+dVXv5zkxSLfSR12XIz8qX4jHVKmaA1eP1L9yJf925XACG6FoOcXinosm5D5LEoQcTevVfpUTWWMQV2LhKIc/7xVv1F7smknEvktFa5JL8SGm3TKDiwCU53G2OFxP9JkKcKyAJzXh5VUHlwOSQ9fPAcO7UvVSZmeLkTaANvOUT9W2feSfhskKqH8AD2c5OxAaikbhlsiyFjS98qexromI8hVfvbuMYN2E5asKTWhX5rJxYvs8rOjqYltKW420ImIEffK7tx/GkYJRN2067CcwvI3Gau/His0fPNe9s6p/lu9L0hZVP87Ky4n0Wmg0rfcBE5CDmpimsRqKTZigBgIHLKutPcsQ7C6tKEYiXPkq9uoNJsDSOdosvt4GVjrVvC4NDQjGxyxPUgFLz2shcNnAoBOVyUdP52btgr6sq7yPpiTeaA3lX80DnKoQxvjtOAFi44BVFvA6C9/NkrUYHn5fpV7FygvsbZ7cvy8dKMswhLKLoAM8h4QT9VPEbMwm6lvz3s+8Max6UD2pD+FL9vwgjaZiv7Zcu6HVEj/E2V1Usxa0+HkS2BRUIUEKUZH0WfECbdrYL4nGtkoKddmwNG2ylFgXRrqRDbGVNESNtIzAutUvWjN9xsOVUzgacbad7gmrPereiCDafbXi4fc8d/MBNgj56ZR3a+6lU2ezZARViuPeWBIldwehnVjQ01lI11j26ile/xAbMwwtVzTtE8YccDhAnil1TQ7lxLma3qGxyLmsgRfqZmdxMDwoSMcpNo2wIDAClhiQVhWdHZV9A9FmGLMG29ji4U05InQVPHsanTd03hS864p3Jb660dmwfdVWO+VsJfq5m4rJuATLetBJzJDmommEgmdz4AWYCX/WIPBHq1W3TxGdSh64yjhnv6eCJnPCDFgrsp
 2/G4in6r
 +ffuJAJ5ebyj3goGSKK2BMn4ICm//dNK5cO01KCDL1r1b5jpUUqOPM0PmDfHjBsij+4A52Lc+P8LcC3bntAfDIs4vcBt1UK/Ad29jrhFEsnsg84k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is room for improvement, so let's clean up a bit:

(1) Define "4" as a constant.

(2) SKIP if we fail to allocate all THPs (e.g., fragmented) and add
    recovery code for all other failure cases: no need to exit the test.

(3) Rename "len" to thp_area_size, and "one_page" to "thp_area".

(4) Allocate a new area "page_area" into which we will mremap the
    pages; add "page_area_size". Now we can easily merge the two
    mremap instances into a single one.

(5) Iterate THPs instead of bytes when checking for missed THPs after
    mremap.

(6) Rename "pte_mapped2" to "tmp", used to verify mremap(MAP_FIXED)
    result.

(7) Split the corruption test from the failed-split test, so we can just
    iterate bytes vs. thps naturally.

(8) Extend comments and clarify why we are using mremap in the first
    place.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 .../selftests/mm/split_huge_page_test.c       | 123 +++++++++++-------
 1 file changed, 74 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 72d6d8bb329ed..7731191cc8e9b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -389,67 +389,92 @@ static void split_pmd_thp_to_order(int order)
 
 static void split_pte_mapped_thp(void)
 {
-	char *one_page, *pte_mapped, *pte_mapped2;
-	size_t len = 4 * pmd_pagesize;
-	uint64_t thp_size;
+	const size_t nr_thps = 4;
+	const size_t thp_area_size = nr_thps * pmd_pagesize;
+	const size_t page_area_size = nr_thps * pagesize;
+	char *thp_area, *tmp, *page_area = MAP_FAILED;
 	size_t i;
 
-	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
+	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (one_page == MAP_FAILED)
-		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
+	if (thp_area == MAP_FAILED) {
+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
+		return;
+	}
 
-	madvise(one_page, len, MADV_HUGEPAGE);
+	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
 
-	for (i = 0; i < len; i++)
-		one_page[i] = (char)i;
+	for (i = 0; i < thp_area_size; i++)
+		thp_area[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
-		ksft_exit_fail_msg("No THP is allocated\n");
+	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
+		ksft_test_result_skip("Not all THPs allocated\n");
+		goto out;
+	}
 
-	/* remap the first pagesize of first THP */
-	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
-
-	/* remap the Nth pagesize of Nth THP */
-	for (i = 1; i < 4; i++) {
-		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
-				     pagesize, pagesize,
-				     MREMAP_MAYMOVE|MREMAP_FIXED,
-				     pte_mapped + pagesize * i);
-		if (pte_mapped2 == MAP_FAILED)
-			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
-	}
-
-	/* smap does not show THPs after mremap, use kpageflags instead */
-	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++)
-		if (i % pagesize == 0 &&
-		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
-			thp_size++;
-
-	if (thp_size != 4)
-		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
-
-	/* split all remapped THPs */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
-		      (uint64_t)pte_mapped + pagesize * 4, 0);
-
-	/* smap does not show THPs after mremap, use kpageflags instead */
-	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++) {
-		if (pte_mapped[i] != (char)i)
-			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+	/*
+	 * To challenge spitting code, we will mremap a single page of each
+	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
+	 * replace the PMD mappings in the thp_area by PTE mappings first,
+	 * but leaving the THP unsplit, to then create a page-sized hole in
+	 * the thp_area.
+	 * We will then manually trigger splitting of all THPs through the
+	 * single mremap'ed pages of each THP in the page_area.
+	 */
+	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (page_area == MAP_FAILED) {
+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
+		goto out;
+	}
 
-		if (i % pagesize == 0 &&
-		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
-			thp_size++;
+	for (i = 0; i < nr_thps; i++) {
+		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
+			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
+			     page_area + pagesize * i);
+		if (tmp != MAP_FAILED)
+			continue;
+		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
+		goto out;
+	}
+
+	/*
+	 * Verify that our THPs were not split yet. Note that
+	 * check_huge_anon() cannot be used as it checks for PMD mappings.
+	 */
+	for (i = 0; i < nr_thps; i++) {
+		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
+				       pagemap_fd, kpageflags_fd))
+			continue;
+		ksft_test_result_fail("THP %zu missing after mremap\n", i);
+		goto out;
 	}
 
-	if (thp_size)
-		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
+	/* Split all THPs through the remapped pages. */
+	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
+		      (uint64_t)page_area + page_area_size, 0);
+
+	/* Corruption during mremap or split? */
+	for (i = 0; i < page_area_size; i++) {
+		if (page_area[i] == (char)i)
+			continue;
+		ksft_test_result_fail("%zu byte corrupted\n", i);
+		goto out;
+	}
+
+	/* Split failed? */
+	for (i = 0; i < nr_thps; i++) {
+		if (is_backed_by_folio(page_area + i * pagesize, 0,
+				       pagemap_fd, kpageflags_fd))
+			continue;
+		ksft_test_result_fail("THP %zu not split\n", i);
+	}
 
 	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
-	munmap(one_page, len);
+out:
+	munmap(thp_area, thp_area_size);
+	if (page_area != MAP_FAILED)
+		munmap(page_area, page_area_size);
 }
 
 static void split_file_backed_thp(int order)
-- 
2.50.1



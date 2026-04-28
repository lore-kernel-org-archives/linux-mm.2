Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F643FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785D76B00D7; Tue, 28 Apr 2026 16:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75BB86B00D9; Tue, 28 Apr 2026 16:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699036B00DA; Tue, 28 Apr 2026 16:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58F3D6B00D7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19E261B8FB8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:44 +0000 (UTC)
X-FDA: 84709148328.16.34BBE9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8DD094000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYuSQhSV;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW63MfJ4Ood0qwn/Lol3yNzgWQPHJJneODL7qiJ8/jE=;
	b=b37QlWSS8H2pRJR8VGvKenlu4e1lQmlMSKHGl2CnVnbyOEQm5luQfXcIykQEq4SGVvdN50
	0Zq1pI8vRzglGVi2B589EqoG5iMaFBmnEUhSG69lFMtT9UKqtJA5AD6O1mGMqn8k2krSFl
	hT143+cXePYiwonfQNXIvCJZmjAVk/E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYuSQhSV;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409202; a=rsa-sha256;
	cv=none;
	b=eehlL7yTGIRPvGJz4t5cnu0wbBhS4zTLAyWBFGYjRLIidiTZqfuxTKFyWw5mX213ahroA4
	cl25mr0j4ZZIgQQX3qZCMd1nwcZ2lvfMdcgdlZo4Cjvrczce2yvCzhgyPYCwemawTJLLPR
	hCZuMlcAAknGqXfQ5Eqk+E8+CG8CT9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C2F26132E;
	Tue, 28 Apr 2026 20:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DBEC2BCAF;
	Tue, 28 Apr 2026 20:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409201;
	bh=dW6FhGF6pU1ym+r/rDESusHBHIrjPAzWgWJPywW+wGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYuSQhSVJ0ne2pgs7DvNzBdLL+G7mpiR2pp5C86jf+5176Cqh40SJcetAD5R9OMMn
	 UROUjRqwcCbItrnjUJ9UCitoH+/D8VGH5E1o0CEXfEBBUwjChlwUxNpS064vULczf0
	 NwjkOyYaU5HHVj93kINvzKGKm3Y/nxQvdczmtMMXPWURgH14HTphEAGHIyqb5ij3GD
	 AK1E0tRd7AGjK4iuxNPZsAy1jPYwds9CRgB89P4KIGtx5+YKGOi4y+y/7eC88Y9vhz
	 ugAjg/AoCer2QAdSJloOlHPCzVkhAGf9OxkOc9azhyQBlX1jCpwI2RwBvcEDFl+bXJ
	 c17JRcaUxrrEA==
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
Subject: [PATCH v3 35/54] selftests/mm: hugepage_dio: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:21 +0300
Message-ID: <20260428204240.1924129-36-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f6ias5qwgu5ghfbredx1e65ijuwnbs4m
X-Rspamd-Queue-Id: 8DD094000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777409202-294672
X-HE-Meta: U2FsdGVkX19U/OoOYaEv3hDZiV28rXncdjrIsUVjIvJs0wV//pXgqUu9nuDDJOAk98qt8bsjlsqdH+joiWslMWZhlQF8c9EJLTVF82Bnmg+4B9OMYt/e6n5No9dUrQk3zL5gmEZEJGhQeU4I7YZblc/bsL6dLPFRj4cPcqzm6E2hvhTSlfRXRAIvBgCwNzFQRnFjFVHlUvmYe8BT638GBK5x33IUDp0hHN9uZHcgkgs63u/1SEi8K2kkN3gt1tAH1ZCQv57n+4JIwMmwfgQwk717uzzaRV00O1sBvWiCEWHen8Eq3XatlkxLjK65MTZ6n5TH0E9r/Zh89NPGhGYjA2d9BbZ35veiWensimtBpYbOTJjZWWEF/c6LtlN3Lhfuk18jWj7/lrSvYowFh/f3gcPmcoggrIY6oVs3oCxEdTpVznQqtvMxYAJqtipfq/+vmqW02k5EH3DvyEi5ZpvU79wp/uEnYmXHvH2J8hzEcNuIr98+19P2PhdzhM0jve05ZgLoKpXLRGmHl7stZkee4fNjXdcNPKlv0ajFUh5HB1OJRB+cE/rCdkmHlUPcU9zD9ShscPdEVaqp+R0EM+X/gCmzYRvBy7dQ2Sxx0IQuGBFUM4fc88cM1w1gbGbADLg7ObfirtXeTF4RGK1P9BOTnwiyeURkvZNmhiAOkkemFFLhiZTHVeH5B7MjuITe1+ysYw3RdQz1SflgzoEUedXHWBrPjC4c9jgXmZZts5hBi6tb7xujXHueawkT/oeIGt57cyTFJwfPOhrmqBrv3rdl8ZDbdCe6RWtSn0KAoWm2/+w+X6SlqVo4dzYBlRwToCd6N9UsXdfTDOPynMIbrVMMAcHR9mQ7O7G7Nw4ygxqxCIZgda9XqdtOsE6xiUuhD571AXIKLdmKPrx7g580ZkspJ9wsWSDGopxCLJ2P682r7pspCCivKtNkuYH8UYdmBnxGjeH8jjNIydIrzYzkdvB
 N6MhwnsR
 xw78HMsOoxD8KkSaHxQXnp1muWYSEf4pUSa9OFMlrhlfPh955LORkDVWjbrjKspKw2gmaO/6IZgCv09CDJrbU6VugfZKCbDz50sEn/BAZ/xGaPcWXMTmRM9aFb1e5Lx37qKWXKPVZyV/LV8JrIWKS1ZVvVKnoTIfWLLom+0DWlaLhW43FFLr9DhiSLQFou3kFGhNtvqFa9AHdjYxxjGnKptRutnMLABCvPJrBjJcuMnbYyeF0eV/SegTi+PBI3k5lV2f9UMzBtstVNCheTrul0PnRNOuZGRFojkvN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugepage_dio test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb_dio.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 47019433ddaf..fb4600570e13 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -85,8 +85,6 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
 
 	/* Get the default huge page size */
 	h_pagesize = default_huge_page_size();
-	if (!h_pagesize)
-		ksft_exit_fail_msg("Unable to determine huge page size\n");
 
 	/* Reset file position since fd is shared across tests */
 	if (lseek(fd, 0, SEEK_SET) < 0)
@@ -94,10 +92,6 @@ static void run_dio_using_hugetlb(int fd, unsigned int start_off,
 
 	/* Get the free huge pages before allocation */
 	free_hpage_b = hugetlb_free_default_pages();
-	if (free_hpage_b == 0) {
-		close(fd);
-		ksft_exit_skip("No free hugepage, exiting!\n");
-	}
 
 	/* Allocate a hugetlb page */
 	orig_buffer = mmap(NULL, h_pagesize, mmap_prot, mmap_flags, -1, 0);
@@ -141,8 +135,8 @@ int main(void)
 
 	ksft_print_header();
 
-	/* Check if huge pages are free */
-	if (!hugetlb_free_default_pages())
+	/* request a huge page */
+	if (!hugetlb_setup_default(1))
 		ksft_exit_skip("No free hugepage, exiting\n");
 
 	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
-- 
2.53.0


